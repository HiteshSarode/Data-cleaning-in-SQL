select *
from Datacleaning..NationalHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select salesdateconverted
from Datacleaning..NationalHousing

update NationalHousing
SET SaleDate=convert(date,SaleDate)

--By Adding a new column in table

alter table NationalHousing
add salesdateconverted Date;

update NationalHousing
SET salesdateconverted=convert(date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select PropertyAddress
from Datacleaning..NationalHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
--WE can fill the null propertyaddress where the parcleID is same cuz where the parcleID is same address is same
from Datacleaning..NationalHousing a
join Datacleaning..NationalHousing b
     on a.ParcelID=b.ParcelID -- We are basically joining the table to itself where parcleID are same but uniqueID is different so it does show the 
	 and a.[UniqueID ]!=b.[UniqueID ]--result for same row,,THEN it will show the propertyaddress where value is null
where a.PropertyAddress is null

update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from Datacleaning..NationalHousing a
join Datacleaning..NationalHousing b
     on a.ParcelID=b.ParcelID
	 and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

select OwnerAddress
from Datacleaning..NationalHousing
where OwnerAddress is null

select a.ParcelID,a.OwnerAddress,b.ParcelID,b.OwnerAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
--WE can fill the null propertyaddress where the parcleID is same cuz where the parcleID is same address is same
from Datacleaning..NationalHousing a
join Datacleaning..NationalHousing b
     on a.ParcelID=b.ParcelID -- We are basically joining the table to itself where parcleID are same but uniqueID is different so it does show the 
	 and a.[UniqueID ]!=b.[UniqueID ]--result for same row,,THEN it will show the propertyaddress where value is null
where a.OwnerAddress is null

update a
SET OwnerAddress=ISNULL(a.OwnerAddress,b.OwnerAddress)
from Datacleaning..NationalHousing a
join Datacleaning..NationalHousing b
     on a.ParcelID=b.ParcelID
	 and a.[UniqueID ]!=b.[UniqueID ]
where a.OwnerAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from Datacleaning..NationalHousing

select SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,len(PropertyAddress)) as Address
from Datacleaning..NationalHousing

alter table NationalHousing
ADD PropertyspiltAddress nvarchar(255);

update NationalHousing
set PropertyspiltAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

alter table NationalHousing
add PropertysplitCity nvarchar(255);

update NationalHousing
set PropertysplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,len(PropertyAddress))


select PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from Datacleaning..NationalHousing

alter table NationalHousing
add OwnersplitAddress nvarchar(255);

update NationalHousing
set OwnersplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NationalHousing
add OwnersplitCity nvarchar(255);

update NationalHousing
set OwnersplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NationalHousing
add OwnersplitState nvarchar(255);

update NationalHousing
set OwnersplitState=PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from Datacleaning..NationalHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant)
from Datacleaning..NationalHousing

select SoldAsVacant,
    case when SoldAsVacant='Y' then 'Yes'
	     when SoldAsVacant='N' then 'No'
	     else SoldAsVacant
	end
from Datacleaning..NationalHousing

update NationalHousing
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
	     when SoldAsVacant='N' then 'No'
	     else SoldAsVacant
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
                            
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Datacleaning..NationalHousing
)
--where [UniqueID ]=27121 or [UniqueID ]=26110
--order by ParcelID
delete
from RowNumCTE
where row_num>1

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

alter table Datacleaning..NationalHousing
drop column SaleDate,PropertyAddress,OwnerAddress


