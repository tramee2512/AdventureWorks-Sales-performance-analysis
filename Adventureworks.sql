SELECT OrderDetails.*
    Product.Name, 
    Product.ProductNumber,
    Product.StandardCost, 
    Product.ListPrice,
    Product.ProductSubcategoryID, 
    Product_Subcategory.Name as Subcategory, 
    Product_Category.Name AS Category
FROM `tc-da-1.adwentureworks_db.product` AS Product
JOIN `tc-da-1.adwentureworks_db.salesorderdetail` AS OrderDetails
    ON OrderDetails.ProductID = Product.ProductID
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS Product_Subcategory
    ON Product.ProductSubcategoryID = Product_Subcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS Product_Category
    ON Product_Subcategory.ProductCategoryID = Product_Category.ProductCategoryID

SELECT Sales.*,
    OrderDetails.ProductID,
    OrderDetails.OrderQty,
    OrderDetails.UnitPrice,
    OrderDetails.UnitPriceDiscount,
    OrderDetails.LineTotal
FROM `tc-da-1.adwentureworks_db.salesorderheader` AS Sales
JOIN `tc-da-1.adwentureworks_db.salesorderdetail` AS OrderDetails
    ON Sales.SalesOrderID = OrderDetails.SalesOrderID

SELECT employee.employeeid 
    employee.contactid, 
    employee.title, 
    contact.contactid,
    contact.firstname,
    contact.middlename,
    contact.lastname
FROM `tc-da-1.adwentureworks_db.employeet` AS Employee
JOIN `tc-da-1.adwentureworks_db.contact` AS Contact
    ON employee.contactid = contact.contactid

SELECT address.addressid,
      province.stateprovincecode as ship_province,
      province.CountryRegionCode as country_code,
      province.name as country_state_name,
      country.name as country_name
FROM `tc-da-1.adwentureworks_db.address` as address
JOIN `tc-da-1.adwentureworks_db.stateprovince` as province
    ON address.stateprovinceid = province.stateprovinceid
JOIN `tc-da-1.adwentureworks_db.countryregion` as country
    ON province.countryregioncode = country.countryregioncode


WITH sales_per_reason AS (
 SELECT
   DATE_TRUNC(OrderDate, MONTH) AS year_month,
   sales_reason.SalesReasonID,
   SUM(sales.TotalDue) AS sales_amount
 FROM
   `tc-da-1.adwentureworks_db.salesorderheader` AS sales
 INNER JOIN
   `tc-da-1.adwentureworks_db.salesorderheadersalesreason` AS sales_reason
 ON
   sales.SalesOrderID = sales_reason.salesOrderID
 GROUP BY 1,2
)
SELECT
 sales_per_reason.year_month,
 reason.Name AS sales_reason,
 sales_per_reason.sales_amount
FROM
 sales_per_reason
LEFT JOIN
 `tc-da-1.adwentureworks_db.salesreason` AS reason
ON
 sales_per_reason.SalesReasonID = reason.SalesReasonID



--- Create Datetable
Date = 
VAR StartDate = YEAR( MIN (SalesDetails[OrderDate] ) )
VAR EndDate = YEAR( MAX (SalesDetails[OrderDate] ) )
RETURN
ADDCOLUMNS (
    FILTER(
        CALENDARAUTO(),
        YEAR( [Date] ) >= StartDate &&
        YEAR( [Date] ) <= EndDate
    ),
"YYYYMM", FORMAT ( [Date], "YYYYMM" ),
"Year", YEAR ( [Date] ),
"MonthNumber", MONTH( [Date] ),
"MonthNameShort", FORMAT ( [Date], "mmm" ),
"MonthNameLong", FORMAT ( [Date], "mmmm" ),
"DayOfWeekNumber", WEEKDAY ( [Date] ),
"DayOfWeek", FORMAT ( [Date], "dddd" ),
"DayOfWeekShort", FORMAT ( [Date], "ddd" ),
"Quarter", "Q" & FORMAT ( [Date], "Q" ),
"YearQuarter", FORMAT ( [Date], "YYYY" ) & " Q" & FORMAT ( [Date], "Q" ),
"MonthYear", FORMAT( [Date], "mmm yyyy")
)

--- Pareto table
Pareto Table 2 = 
SUMMARIZE(
    FILTER(
        'SalesDetails',
        'SalesDetails'[New Sales Person] <> "Online"
    ),
    'SalesDetails'[New Sales Person],
    "Sum Sales", 'SalesDetails'[Revenue])

--- Sales Person
SELECT employee.employeeid, 
    employee.contactid, 
    employee.title, 
    contact.firstname,
    contact.middlename,
    contact.lastname
FROM `tc-da-1.adwentureworks_db.employee` AS Employee
JOIN `tc-da-1.adwentureworks_db.contact` AS Contact
    ON employee.contactid = contact.contactid

--- Sales Region
SELECT address.addressid,
      province.stateprovincecode as ship_province,
      province.CountryRegionCode as country_code,
      province.name as country_state_name,
      country.name as country_name
FROM `tc-da-1.adwentureworks_db.address` as address
JOIN `tc-da-1.adwentureworks_db.stateprovince` as province
    ON address.stateprovinceid = province.stateprovinceid
JOIN `tc-da-1.adwentureworks_db.countryregion` as country
    ON province.countryregioncode = country.countryregioncode

--- Sales Product
SELECT OrderDetails.*, 
    Product.Name, 
    Product.ProductNumber,
    Product.StandardCost, 
    Product.ListPrice,
    Product.ProductSubcategoryID, 
    Product_Subcategory.Name as Subcategory, 
    Product_Category.Name AS Category
FROM `tc-da-1.adwentureworks_db.product` AS Product
JOIN `tc-da-1.adwentureworks_db.salesorderdetail` AS OrderDetails
    ON OrderDetails.ProductID = Product.ProductID
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS Product_Subcategory
    ON Product.ProductSubcategoryID = Product_Subcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS Product_Category
    ON Product_Subcategory.ProductCategoryID = Product_Category.ProductCategoryID

