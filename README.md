# HOUSING DATACLEANING
## About
This project aims to clean the Housing data using SQL.

## Approch Used
1.Standardize Date Format
  
  -By converting the given column of SaleDate to formal **DATE** format.

2.Populate Property Address data
  
  -Firstly,Joining the table to itself using **JOIN** function and filling the NULL space by to output of joining.

3.Breaking out Address into Individual Columns (Address, City, State)
  
  -Splitting the **PropertyAddress** by using the **SUBSTRING** function and **CHARINDEX** function to seperate it from **','** into two seperate columns of **ADDRESS** and **CITY**.
  
  -Secondly,Splitting the Owneraddress into **ADDRESS** ,**CITY** and **STATE** using **PARSENAME** function.

4.Change Y and N to Yes and No in "Sold as Vacant" field
  
  -Using **CASE** statement.

5.Remove Duplicates
  
  -Firstly,creating a CTE then using **ROWNUMBER()** function to count number of rows in the given condition that is defined by using **PARTITION** function.THis will give us to count to 
    rows where the condition in PARTITION statement satisfies.
  
  - Then deleting the rows where the count is more than 1 which will delete the duplicate rows.

6.Delete Unused Columns
  
  -Lastly,deleting the unused columns using **DROP COLUMN** function.
