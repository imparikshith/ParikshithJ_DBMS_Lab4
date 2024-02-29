# Display total number of  customers based on gender who have placed individual orders of worth at least Rs.3000
SELECT c.cus_gender AS Gender, COUNT(C.CUS_ID) AS Total_Customers
FROM customer c
JOIN (
    SELECT o.cus_id
    FROM orders o
    GROUP BY o.cus_id
    HAVING SUM(o.ord_amount) >= 3000
) AS Total_Orders ON c.cus_id = Total_Orders.cus_id
GROUP BY C.CUS_GENDER;

# Display all the orders along with product name ordered by a customer having customer id=2
SELECT p.pro_name AS Product_Name
FROM orders o, product p, supplier_pricing s
WHERE o.cus_id = 2 and o.pricing_id = s.pricing_id and s.pro_id = p.pro_id;

# Display the supplier details who can supply more than one product
SELECT *
FROM supplier
WHERE supp_id = ANY
	(SELECT supp_id
	FROM supplier_pricing
	GROUP BY supp_id
	HAVING COUNT(DISTINCT pro_id)>1);
    
# Find the least expensive product form each category and print the table with category id, name, product name and price of the product
SELECT c.cat_id AS Cat_id,
       c.cat_name AS Category_Name,
       p.pro_name AS Product_Name,
       sp.supp_price AS Price
FROM category c
JOIN product p ON c.cat_id = p.cat_id
JOIN (
    SELECT pr.cat_id,
           MIN(sp.supp_price) AS Min_Price
    FROM product pr
    JOIN supplier_pricing sp ON pr.pro_id = sp.pro_id
    GROUP BY pr.CAT_ID
) AS min_prices ON p.cat_id = min_prices.cat_id
JOIN supplier_pricing sp ON p.pro_id = sp.pro_id AND sp.supp_price = min_prices.Min_Price;

# Display the id and name of the product ordered after "2021-10-05"
SELECT p.pro_id AS Product_ID, p.pro_name AS Product_Name
FROM product p
JOIN supplier_pricing s ON p.pro_id = s.pro_id
JOIN orders o ON s.pricing_id = o.pricing_id
WHERE o.ord_date>"2021-10-05";

# Display the customer name and gender whose name start or end with character 'A'
SELECT cus_name AS Name, cus_gender AS Gender
FROM customer
WHERE cus_name LIKE "a%" OR cus_name LIKE "%a";

# Create a stored procedure
DELIMITER //

CREATE PROCEDURE GetSupplierRatings()
BEGIN
    SELECT 
        s.supp_id AS Supplier_ID,
        s.supp_name AS Supplier_Name,
        AVG(r.rat_ratstars) AS Rating,
        CASE 
            WHEN AVG(r.rat_ratstars) = 5 THEN 'Excellent Service'
            WHEN AVG(r.rat_ratstars) > 4 THEN 'Good Service'
            WHEN AVG(r.rat_ratstars) > 2 THEN 'Average Service'
            ELSE 'Poor Service'
        END AS Type_of_Service
    FROM 
        supplier s
    JOIN 
        supplier_pricing sp ON s.supp_id = sp.supp_id
    JOIN 
        orders o ON sp.pricing_id = o.pricing_id
    JOIN 
        rating r ON o.ord_id = r.ord_id
    GROUP BY 
        s.supp_id, s.supp_name;
END //

DELIMITER ;

CALL GetSupplierRatings();