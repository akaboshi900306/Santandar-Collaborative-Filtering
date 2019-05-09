# Reading required libraries ----------------------------------------------
library(data.table)
library(igraph)
library(recommenderlab)
library(ggplot2)
library(dplyr)
install.packages("fastDummies")
library(fastDummies)

# Reading the data --------------------------------------------------------
setwd("C:\\Users\\akabo\\Downloads\\machine_learning 2\\santandar\\train")

data <- fread("train_ver2.csv")
testdata <- fread("test_ver2.csv")
# sample_submission <- fread("sample_submission.csv")

data <- data.table(data)
head(data)
#head(testdata)
#head(sample_submission)
str(data)


# Extracting the month ----------------------------------------------------


data$month <- month(data$fecha_dato)



# Data Cleaning -----------------------------------------------------------
# Inspired from https://www.kaggle.com/apryor6/detailed-cleaning-visualization ---------------

# Checking for nulls
sapply(data,function(x)any(is.na(x)))
unique(data$age)

# 'age'
ggplot(data=data,aes(x=age)) + 
  geom_bar(alpha=0.75,fill="tomato",color="black") +
  ggtitle("Age Distribution") 

# Since the distribution looks bimodal, we see 2 peaks - large number of university students, then large
# number of middle age
data$age[(data$age < 18)]  <- mean(data$age[(data$age >= 18) & (data$age <=30)],na.rm=TRUE)
data$age[(data$age > 100)] <- mean(data$age[(data$age >= 30) & (data$age <=100)],na.rm=TRUE)
data$age[is.na(data$age)]  <- median(data$age,na.rm=TRUE)
data$age                 <- round(data$age)

# Visualizing 'age' distribution
ggplot(data=data,aes(x=age)) + 
  geom_bar(alpha=0.75,fill="tomato",color="black") +
  xlim(c(18,100)) + 
  ggtitle("Age Distribution") 

# 'ind_nuevo'
sum(is.na(data$ind_nuevo))

# Setting NAs as min months active
data$ind_nuevo[is.na(data$ind_nuevo)] <- 1 

# 'antiguedad'
sum(is.na(data$antiguedad))

# Assigning min seniority

data$antiguedad[is.na(data$antiguedad)] <- min(data$antiguedad,na.rm=TRUE)
data$antiguedad[data$antiguedad<0] <- 0

# Some people don't have date of joining the company. Assigning median to them.
data$fecha_alta[is.na(data$fecha_alta)] <- median(data$fecha_alta,na.rm=TRUE)

# 'indrel'
table(data$indrel)

# Most entries are for status 1. Hence assigning that for the NAs
data$indrel[is.na(data$indrel)] <- 1

# Dropping 'tipodom' (address type) & 'cod_prov' (province code) since name of province exists in nomprov
data$tipodom <- NULL
data$cod_prov <- NULL

# Checking which columns have NAs
sapply(data,function(x)any(is.na(x)))


# 'ind_actividad_cliente'
sum(is.na(data$ind_actividad_cliente))
# Setting the missing values to median
data$ind_actividad_cliente[is.na(data$ind_actividad_cliente)] <- median(data$ind_actividad_cliente,
                                                                        na.rm=TRUE)

# Checking the unique entries in 'nomprov'
unique(data$nomprov)

# Setting the missing values as 'UNKNOWN'
data$nomprov[data$nomprov==""] <- "UNKNOWN"

# Finding the total missing values in 'renta'
sum(is.na(data$renta))

# Visualizing the renta by city
data %>%
  filter(!is.na(renta)) %>%
  group_by(nomprov) %>%
  summarise(med.income = median(renta)) %>%
  arrange(med.income) %>%
  mutate(city=factor(nomprov,levels=nomprov)) %>% # the factor() call prevents reordering the names
  ggplot(aes(x=city,y=med.income)) + 
  geom_point(color="#f72a3e") + 
  guides(color=FALSE) + 
  xlab("City") +
  ylab("Median Income") +  
  theme(axis.text.x=element_blank(), axis.ticks = element_blank()) + 
  geom_text(aes(x=city,y=med.income,label=city,family="Times", fontface="italic"),angle=90,hjust=-.25) +
  ylim(c(50000,200000)) + theme_wsj()+
  ggtitle("Income Distribution by City")

new.incomes <-data %>%
  select(nomprov) %>%
  merge(data %>%
          group_by(nomprov) %>%
          summarise(med.income=median(renta,na.rm=TRUE)),by="nomprov") %>%
  select(nomprov,med.income) %>%
  arrange(nomprov)
data <- arrange(data,nomprov)
data$renta[is.na(data$renta)] <- new.incomes$med.income[is.na(data$renta)]
rm(new.incomes)

# Assign median renta to the NAs
data$renta[is.na(data$renta)] <- median(data$renta,na.rm=TRUE)
data <- arrange(data,fecha_dato)

# Checking for NAs in 'ind_nomina_utl1'
sum(is.na(data$ind_nomina_ult1))
# Setting the NAs to 0 assuming that the person does not have that product
data[is.na(data)] <- 0

# Assign most common values to the entries with blank
data$indfall[data$indfall==""] <- "N"
data$tiprel_1mes[data$tiprel_1mes==""] <- "A"
data$indrel_1mes[data$indrel_1mes==""] <- "1"
# change to just numbers because it currently contains letters and numbers
data$indrel_1mes[data$indrel_1mes=="P"] <- "5" 
data$indrel_1mes <- as.factor(as.integer(data$indrel_1mes))

# Assign UNKNOWN to the entries with blank
data$pais_residencia[data$pais_residencia==""] <- "UNKNOWN"
data$sexo[data$sexo==""]                       <- "UNKNOWN"
data$ult_fec_cli_1t[data$ult_fec_cli_1t==""]   <- "UNKNOWN"
data$ind_empleado[data$ind_empleado==""]       <- "UNKNOWN"
data$indext[data$indext==""]                   <- "UNKNOWN"
data$indresi[data$indresi==""]                 <- "UNKNOWN"
data$conyuemp[data$conyuemp==""]               <- "UNKNOWN"
data$segmento[data$segmento==""]               <- "UNKNOWN"

# Extracting features from the data as names
features <- grepl("ind_+.*ult.*", names(data))
data[,features] <- lapply(data[,features],function(x)as.integer(round(x)))
data$total.services <- rowSums(data[,features],na.rm=TRUE)
# Arrange data by the fetch date
data <- data %>% arrange(fecha_dato)
# Adding a month id
data$month.id <- as.numeric(factor((data$fecha_dato)))
# Adding the next month's id
data$month.next.id <- data$month.id + 1
head(data)


data <- data.table(data)
# Setting how many months' data is present in system
data[,count_mon := .N,by=ncodpers]


# Adding a month counter
test <- data.table(
  fecha_dato = c(sort((unique(data$fecha_dato)))),
  mon_in_order = c(seq_along(sort((unique(data$fecha_dato)))))
)
data <- merge(data, test, by= 'fecha_dato')
data[,latest_month := max(mon_in_order), by=ncodpers]

#data_month15 <- data[data$mon_in_order==15]
data_month16 <- data[data$mon_in_order==16]
data_month17 <- data[data$mon_in_order==17]

head(data_month17)
min(data$mon_in_order)

users <- unique(data$ncodpers)
head(users)
users <- data.table(users)

# Extracting users whose data is present in month 16 & 17
users_16 <- data.table(unique(data_month16$ncodpers))
users_17 <- data.table(unique(data_month17$ncodpers))

# Common users whose data is present for month 16 & 17
common_users <- merge(x=users_16, y=users_17, by='V1')

data_common_users <- data[ncodpers %in% common_users$V1]

head(data_common_users)

train_data <- data_common_users[!(mon_in_order %in% c(16,17)) ]

head(train_data)

#train_data[,latest_month := max(mon_in_order), by=ncodpers]
#train_data[,count_mon := .N, by=ncodpers]

# Checking the users with latest_month 1
users_min_data <- train_data[train_data$latest_month==1]$ncodpers
# Taking them out
common_users <- common_users[!(V1 %in% users_min_data)]
# train_data <- NULL
data_common_users <- data_common_users[!(ncodpers %in% users_min_data)]
train_data <- train_data[!(ncodpers %in% users_min_data) ]


min(train_data$count_mon)
unique(train_data[train_data$count_mon==1]$ncodpers)

customer_profile <- train_data[mon_in_order == latest_month]

missing_users<- common_users[!(V1 %in% customer_profile$ncodpers)]



# Checking if these missing users are only there in month 16 & 17
data_month16[ncodpers %in% missing_users$V1]
data_month17[ncodpers %in% missing_users$V1]
train_data[ncodpers %in% missing_users$V1]

# Dropping these users
common_users <- common_users[!(V1 %in% missing_users$V1)]
data_month16 <- data_month16[ncodpers %in% common_users$V1]
data_month17 <- data_month17[ncodpers %in% common_users$V1]
train_data <- train_data[ncodpers %in% common_users$V1]


# dummying variables ------------------------------------------------------

# using customer_profile
list1 <- c('pais_residencia','sexo','age','indrel_1mes','tiprel_1mes','indresi','indfall','nomprov','ind_actividad_cliente','renta','segmento')
cust_profile_data <- customer_profile[,  c('pais_residencia','sexo','age','indrel_1mes','tiprel_1mes','indresi','indfall','nomprov','ind_actividad_cliente','renta','segmento')]

# age buckets
cust_profile_data[, age18_25 := ifelse((age >= 18 & age<25),1,0)]
cust_profile_data[, age25_30 := ifelse((age >= 25 & age<30),1,0)]
cust_profile_data[, age30_35 := ifelse((age >= 30 & age<35),1,0)]
cust_profile_data[, age35_40 := ifelse((age >= 35 & age<40),1,0)]
cust_profile_data[, age40_50 := ifelse((age >= 40 & age<50),1,0)]
cust_profile_data[, age50_60 := ifelse((age >= 50 & age<60),1,0)]
cust_profile_data[, age60_up := ifelse((age >= 60),1,0)]

# renta buckets
cust_profile_data[, renta0_30 := ifelse((renta >= 0 & renta<30000),1,0)]
cust_profile_data[, renta30_60 := ifelse((renta >= 30000 & renta<60000),1,0)]
cust_profile_data[, renta60_90 := ifelse((renta >= 60000 & renta<90000),1,0)]
cust_profile_data[, renta90_120 := ifelse((renta >= 90000 & renta<120000),1,0)]
cust_profile_data[, renta120_200 := ifelse((renta >= 120000 & renta<200000),1,0)]
cust_profile_data[, renta200_500 := ifelse((renta >= 200000 & renta<500000),1,0)]
cust_profile_data[, renta500_up := ifelse((renta >= 500000),1,0)]

# everything else
test_run <- dummy_cols(cust_profile_data, select_columns = c('pais_residencia','indrel_1mes','tiprel_1mes','nomprov','segmento'))


ratings1 = as(as.matrix(test_run),"realRatingMatrix")
# default is cosine but can also specify Jaccard and others in options
# UBCF stands for user based collaborative filtering

similarity1 = similarity(ratings1,method = "jaccard")

# Data for creating ratings -----------------------------------------------


# Drop data_common_users
data_common_users <- NULL

data_for_ratings <- rbind(train_data, data_month16)

data_only <- data_for_ratings[,c(1,2, 23:46,52)]



new_dt1 <- data_only[,lapply(.SD, function(x) x*mon_in_order),.SDcols = !c("fecha_dato", 'mon_in_order'), by = ncodpers]
new_dt2 <- new_dt1[,lapply(.SD, function(x) sum(x)), by = ncodpers]
new_dt2 <- new_dt2[,lapply(.SD, function(x) ifelse(x ==0,NA,x))]
#new_dt2$str1 <- lapply(new_dt2$ncodpers, function(x) as.character(x))
dt2 <- as.matrix(new_dt2)
rownames(dt2, do.NULL = FALSE)
rownames(dt2) <- (new_dt2$ncodpers)
dt2 <- dt2[,2:25]
ratings <- as(dt2,"realRatingMatrix")




# evaluate different methods
eval <- evaluationScheme(ratings, method="split", train=0.75, given = -1, goodRating = 69)
eval

# algorithms (perform normalization automatically)
algorithms <- list(
  "random items" = list(name="RANDOM", param=NULL),
  "popular items" = list(name="POPULAR", param=NULL),
  "user-based CF" = list(name="UBCF", param=list(nn=50)),
  "item-based CF" = list(name="IBCF", param=list(k=50)),
  "SVD approximation" = list(name="SVD", param=list(k = 50)))

