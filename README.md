# Sales-increase-in-restaurant-industry
increase the sales by locating accurate prospectuses and potential partners

+

Our goal is to increase sales - locating accurate prospectuses and potential partners
 * in the background, testing software from a third-party provider that offers contact information for restaurants and locations that we would target in sales
 The offer consists of real data that we will market to that SW house in order to obtain the required data in return
Datasource : [SalesForceSync] within [Integrations] db
One table returns top level accounts AccountIDs under the following conditions, a total of 100 Accounts are required
 - 50% of locations belong to the same metro region, by which we determine that it unequivocally belongs to sought-after locations such as Pittsburgh and Richmond
 - The highest level in the hierarchy (Ownership)
 - No contact information

SalesForce Contact
 - We make join with that table
 - After joining, we return only those rows that do not have Contact information

Suggested solutions:
 - Can SELF JOIN from SfSync in order to filter the top level, one of way
 - to set the Parent column to IS NULL
