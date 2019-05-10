
# Santandar-Collaborative-Filtering
The dataset is sourced from a Kaggle competition - Santander Product Recommendation (Kaggle, 2017). It contains data about ~950K customers over 17 months (Jan 2015 to May 2016), resulting in over 13 million observations (1 per customer per month).

As we can see, even in the ‘ratings’ evaluation, SVD was the best in terms of performance with the least error. Hence, we choose the Singular Value Decomposition (SVD) as the one for predicting the additional products a user would purchase in May 2016.

# Evaluation
For models using implicit data
For the models using implicit data, we used a 2-step evaluation approach:
Step 1:  We set about creating an evaluation scheme where the following parameters were set:
Train-test split: 75% Train, 25% Test. This way the models would train on 75% of the data and be tested on 25% of the data set.
Good rating: We gave the threshold as 69 (The maximum rating was 136, so half of that +1). This was important so as to segregate which products the customers rated high and which they rated low. A score of 69 would mean that the customer would have kept that product for multiple months which would mean that he/she liked that product from the bank.
Given ratings: All. Since there were only 24 products, we chose to use all the ratings given by the customer.
We then evaluated the three algorithms (Random, SVD & IBCF) on this evaluation scheme on two different types of predictions:
Top N list: This type of evaluation checks how good the model is in predicting the top ‘N’ products which the customer might rate high. This would be useful when we would want to find the top 7 products to recommend to the customer. We evaluated using n=1, 5 & 7 and the performance is as below:
As we can see, even in the ‘ratings’ evaluation, SVD was the best in terms of performance with the least error. Hence, we choose the Singular Value Decomposition (SVD) as the one for predicting the additional products a user would purchase in May 2016.

# Deployment
The deployment phase of the model will come in the form of Santander using our recommendation model to offer new products to their current customers. In doing so they will stand to boost their revenue, as the benefit of a customer potentially using a new product far outweighs the cost making these such offers.
However, there are certain ethical risks involved in this approach. Because we are dealing with personal data, such as address, gender, or age data, it is important to be very careful when making recommendations. It would be a good look for the bank to check if they made discriminatory recommendations to their customers. There are multiple ways to reduce these risks and avoid discrimination, as shown below:
Asking consent: Santander can avoid the risk of backfiring from customers by asking for consent from its customers that their data could be used for making recommendations.
Excluding sensitive information like gender from algorithms: Excluding sensitive information like race and gender from algorithms make sure that inherent biases and prejudices are not propagated into recommendations.
Ensuring equal participation: Statistical parity is important so that various groups of customers have access to all products. This will ensure that the algorithm is fair and will also ensure that there is no bias for or against customers.

# Conclusion and Next Steps
After completing the recommender systems model for Santander, we found that our models gave them a good chance at correctly recommending which new products a customer would buy. While the accuracy of the models is low, this is a product of the fact that there are many more factors and variable that go into what bank product a customer will need, and we don’t have complete data on all of that. For example, if a customer is looking to buy a house, then they would need to get a mortgage, but we have no way of knowing based on their previous product usage whether or not they are looking at a new house. But with this in mind, Santander can still put their data to use in a positive and rewarding way. As an improvement for this recommendation system, we think that finding a way to run UBCF on the massive scale for all customers would help, as it would enable Santander to recommend new products to customers based on all of their similar products. 
