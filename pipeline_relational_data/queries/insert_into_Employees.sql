USE ORDERS_RELATIONAL_DB;

INSERT INTO Employees
    ([EmployeeID],[LastName],[FirstName], [Title], [TitleOfCourtesy], 
    [BirthDate], [HireDate], [Address], [City], [Region], [PostalCode],
    [Country], [HomePhone], [Extension], [Notes], [ReportsTo], [PhotoPath])
    values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
