----How To Clean Data In SQL----

Select * 
From NashvileHousingData
--====================================================================================================================================================



----Standardaize Date Format:

Select SaleDateConverted , CONVERT(Date,SaleDate)
From NashvileHousingData


Update NashvileHousingData
Set SaleDate=CONVERT(Date,SaleDate)

Alter Table NashvileHousingData
Add SaleDateConverted Date

Update NashvileHousingData
Set SaleDateConverted =CONVERT(Date,SaleDate)
--====================================================================================================================================================


----Populate Property Adrress Data:

Select PropertyAddress
From NashvileHousingData
Where PropertyAddress Is Null

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  From NashvileHousingData a
   Join NashvileHousingData b
   on a.ParcelID=b.ParcelID
   And a.[UniqueID ]<> b.[UniqueID ]
   Where A.PropertyAddress Is Null

   Update a
   Set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
   From NashvileHousingData a
   Join NashvileHousingData b
   on a.ParcelID=b.ParcelID
   And a.[UniqueID ]<> b.[UniqueID ]
   Where A.PropertyAddress Is Null
   --====================================================================================================================================================

   --Breaking Address Into Individual Columns(Address,City,State):

   Select PropertyAddress
   From NashvileHousingData
   
   Select
   SUBSTRING(PropertyAddress,1, CHARINDEX(',' , PropertyAddress)-1) As Adrress,
   SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress)) As Adrress
   From NashvileHousingData


   Alter Table NashvileHousingData
Add PropertySplitAddress Nvarchar(255);

Update NashvileHousingData
Set PropertySplitAddress =SUBSTRING(PropertyAddress,1, CHARINDEX(',' , PropertyAddress)-1)



Alter Table NashvileHousingData
Add PropertySplitCity Nvarchar(255);

Update NashvileHousingData
Set PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress))





Select * From NashvileHousingData




--Breaking Address Into Individual Columns

Select OwnerAddress
From NashvileHousingData

Select PARSENAME(Replace(OwnerAddress  , ',', '.'),3)
, PARSENAME(Replace(OwnerAddress, ',', '.'),2)
,PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From NashvileHousingData




Alter Table NashvileHousingData
Add OWnersSplitAddress Nvarchar(255);

Update NashvileHousingData
Set OWnersSplitAddress =PARSENAME(Replace(OwnerAddress  , ',', '.'),3)





Alter Table NashvileHousingData
Add OwnersSplitCity Nvarchar(255);

Update NashvileHousingData
Set OwnersSplitCity =PARSENAME(Replace(OwnerAddress, ',', '.'),2)




Alter Table NashvileHousingData
Add OwnersSplitState Nvarchar(255);

Update NashvileHousingData
Set OwnersSplitState =PARSENAME(Replace(OwnerAddress, ',', '.'),1)



Select* From NashvileHousingData

--====================================================================================================================================================

--**** Changing Y And N to Yes ANd No In columns ****

Select Distinct(SoldAsVacant)
From NashvileHousingData

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From NashvileHousingData
Group By SoldAsVacant
Order By 2



Select SoldAsVacant,
Case When SoldAsVacant='y' Then 'Yes'
     When SoldAsVacant='N' Then 'No'
	 Else SoldAsVacant
	 End
From NashvileHousingData

Update NashvileHousingData
Set SoldAsVacant =Case When SoldAsVacant='y' Then 'Yes'
     When SoldAsVacant='N' Then 'No'
	 Else SoldAsVacant
	 End

--====================================================================================================================================================

-- Remove duplicate values:

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

From NashvileHousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvileHousingData
--====================================================================================================================================================




-- Delete Unused Columns



Select *
From NashvileHousingData


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

