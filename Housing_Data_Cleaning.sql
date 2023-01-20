--Data Cleaning in SQL


SELECT * 
FROM HousingData..NashvilleHousing

--Standardizing Date Format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM HousingData..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SimpleSaleDate Date

UPDATE HousingData..NashvilleHousing
SET SimpleSaleDate = CONVERT(Date,SaleDate)


--Populating Property Address Data


SELECT *
FROM HousingData..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData..NashvilleHousing a
JOIN HousingData..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData..NashvilleHousing a
JOIN HousingData..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


--Breaking PropertyAddress Into Individual Columns (Address, City) For Improved Usability


SELECT PropertyAddress
FROM HousingData..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM HousingData..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD AddressOnly Nvarchar(255)

UPDATE NashvilleHousing
SET AddressOnly = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD CityOnly Nvarchar(255)

UPDATE NashvilleHousing
SET CityOnly = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


--Breaking OwnerAddress Into Individual Columns (Address, City) For Improved Usability


SELECT OwnerAddress
FROM HousingData..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM HousingData..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerAddressOnly Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerAddressOnly = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerCityOnly Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerCityOnly = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerStateOnly Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerStateOnly = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT OwnerCityOnly, OwnerStateOnly, OwnerAddressOnly
FROM HousingData..NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" column for consistency


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM HousingData..NashvilleHousing
ORDER BY SoldAsVacant

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END



-- Removing Duplicates Using a CTE


WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
FROM HousingData..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- Deleting Unused Columns


SELECT *
FROM HousingData..NashvilleHousing

ALTER TABLE HousingData..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE HousingData..NashvilleHousing
DROP COLUMN SaleDate
