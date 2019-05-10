
# Santandar-Collaborative-Filtering
# The dataset is sourced from a Kaggle competition - Santander Product Recommendation (Kaggle, 2017). It contains data about ~950K customers over 17 months (Jan 2015 to May 2016), resulting in over 13 million observations (1 per customer per month).


Table 5: Evaluation results for various recommender algorithms

# As we can see, even in the ‘ratings’ evaluation, SVD was the best in terms of performance with the least error. Hence, we choose the Singular Value Decomposition (SVD) as the one for predicting the additional products a user would purchase in May 2016.

# Step 2: We used the SVD model to predict the additional seven products each current customer would buy in May 2016, given the products they already owned as of April 2016. These recommendations were compared against the new products bought by customers in May ‘16. The output of the evaluation looked as below:

# Table 6: Results of the evaluation of SVD on the final test set
# In addition to seeing the results via accuracy, it is also important to make sure that our recommendations make business sense and can be explained. Below, we have an example of a successful prediction:
# Table 7: Example of successful recommendations
# For models using explicit data
# For the model using Explicit data, we again strove to recommend seven new products to our selected customers. Because of the smaller scale of this model compared to the one using implicit data, we will only consider the evaluation of the final predictions. Note that, considering we are only looking at a certain subset of customers, we will only consider the results centered around those customers. What we found is as below:

# Table 8: Results of the evaluation of Jaccard similarity on the final test set
We can see here that this model does a very good job of predicting which products a new customer will buy. Implementing this model will enable Santander to feel relatively confident in deploying this recommender system, as its high accuracy in terms of recommendations will entice their customers to start using more products at their bank. 
	As with the previous section, it is important to make sure that our results make good business sense in addition to having a high accuracy. Below is an example of a recommendation that was made:


Ncodpers
Products had before
Product recommended
120474
Direct Debit Account
Current Account
Table 9: Example of successful recommendations
This makes logical sense: a person an account at Santander where they keep money to pay for taxes (direct debit), so we would recommend to him a  current (checking) account to keep his/her spending money in the same place. 

VI. Deployment
	The deployment phase of the model will come in the form of Santander using our recommendation model to offer new products to their current customers. In doing so they will stand to boost their revenue, as the benefit of a customer potentially using a new product far outweighs the cost making these such offers.
However, there are certain ethical risks involved in this approach. Because we are dealing with personal data, such as address, gender, or age data, it is important to be very careful when making recommendations. It would be a good look for the bank to check if they made discriminatory recommendations to their customers. There are multiple ways to reduce these risks and avoid discrimination, as shown below:
Asking consent: Santander can avoid the risk of backfiring from customers by asking for consent from its customers that their data could be used for making recommendations.
Excluding sensitive information like gender from algorithms: Excluding sensitive information like race and gender from algorithms make sure that inherent biases and prejudices are not propagated into recommendations.
Ensuring equal participation: Statistical parity is important so that various groups of customers have access to all products. This will ensure that the algorithm is fair and will also ensure that there is no bias for or against customers.

VII. Conclusion and Next Steps
	After completing the recommender systems model for Santander, we found that our models gave them a good chance at correctly recommending which new products a customer would buy. While the accuracy of the models is low, this is a product of the fact that there are many more factors and variable that go into what bank product a customer will need, and we don’t have complete data on all of that. For example, if a customer is looking to buy a house, then they would need to get a mortgage, but we have no way of knowing based on their previous product usage whether or not they are looking at a new house. But with this in mind, Santander can still put their data to use in a positive and rewarding way. As an improvement for this recommendation system, we think that finding a way to run UBCF on the massive scale for all customers would help, as it would enable Santander to recommend new products to customers based on all of their similar products. 
