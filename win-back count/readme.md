  ### win-back calculation of accounts that left and re-joined after 1 month period of time

  **Description:**
  Data source: Restaurant Locations table
	Result: Location count by month
	
  Using the locations table, for both sets, identify the locations and brands that can be counted as win-backs.
	Brand identifier - String before the dash in the Restaurant_Name column.
	Location - Can be counted as same location if the Brand is the same, and the address information is same or very similar.
	Win back - Location/Brand that have exited out of Dinova program ( in the case of Brand for the first iteration, we want 
  to flag them as exited if all their locations were out of program) , and then resigned with Dinova after a minimum time period of 1 month
