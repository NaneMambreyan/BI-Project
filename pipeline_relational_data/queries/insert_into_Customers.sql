USE ORDERS_RELATIONAL_DB;

INSERT INTO Customers
    ([CustomerID],[CompanyName],[ContactName], [ContactTitle], [Address], 
    [City], [Region], [PostalCode], [Country], [Phone], [Fax])
    values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
