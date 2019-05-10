
# Santandar-Collaborative-Filtering
The dataset is sourced from a Kaggle competition - Santander Product Recommendation (Kaggle, 2017). It contains data about ~950K customers over 17 months (Jan 2015 to May 2016), resulting in over 13 million observations (1 per customer per month).

As we can see, even in the ‘ratings’ evaluation, SVD was the best in terms of performance with the least error. Hence, we choose the Singular Value Decomposition (SVD) as the one for predicting the additional products a user would purchase in May 2016.

# Conclusion and Next Steps
After completing the recommender systems model for Santander, we found that our models gave them a good chance at correctly recommending which new products a customer would buy. While the accuracy of the models is low, this is a product of the fact that there are many more factors and variable that go into what bank product a customer will need, and we don’t have complete data on all of that. For example, if a customer is looking to buy a house, then they would need to get a mortgage, but we have no way of knowing based on their previous product usage whether or not they are looking at a new house. But with this in mind, Santander can still put their data to use in a positive and rewarding way. As an improvement for this recommendation system, we think that finding a way to run UBCF on the massive scale for all customers would help, as it would enable Santander to recommend new products to customers based on all of their similar products. 
