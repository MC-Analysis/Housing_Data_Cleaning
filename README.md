# Housing Data Cleaning
Hello!  

This project contains the queries I wrote to clean a data set containing housing data from this data set from kaggle (https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data). The SaleDate column was simplified from datetime format to only the date. Null PropertyAddress entries were filled by joining the table on itself to find instances where a single property had been sold multiple times. I split the general PropertyAddress and OwnerAddress Columns into separate and more usable Address, City, and State columns. The SoldAsVacant column was standardized from containing values of "Y", "N", "Yes", and "No" to only "Yes" and "No". Duplicate entries were removed using a CTE. The now unused SaleDate, PropertyAddress, and OwnerAddress columns were removed in favor of their new simplified replacements.  

Thank you for taking the time to read this!

## Contact

My email: myarcurtis@gmail.com  
My linkedin: www.linkedin.com/in/mya-curtis 
