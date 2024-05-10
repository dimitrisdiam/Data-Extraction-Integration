CREATE TABLE loan
	(loan_number		varchar(10),
	 branch_ID			varchar(5),
	 amount				numeric(12,2),
	 remaining_amount 	numeric(12,2),
	 primary key (loan_number),
	 foreign key (branch_ID) references branch (branch_ID)
		on delete set NULL
	);

CREATE TABLE borrows
	(loan_number	varchar(10),
	 customer_ID	varchar(5),
	 primary key (loan_number),
	 foreign key (loan_number) references loan (loan_number)
		on delete  CASCADE,
	 foreign key (customer_ID) references customer (customer_ID)
		on delete cascade
	);

CREATE TABLE customer
	(customer_ID			varchar(5),
	 street					varchar(20),
	 number					varchar(5),
	 city					varchar(20),
	 country				varchar(20),
	 name					varchar(20),
	 primary key (customer_ID)
	);
	
CREATE TABLE provides
	(branch_ID				varchar(5),
	 loan_number			varchar(10),
	 primary key (loan_number),
	 foreign key (branch_ID) references branch (branch_ID)
		on delete set NULL,
	 foreign key (loan_number) references loan (loan_number)
		on delete set NULL
	);
	
	
CREATE TABLE branch
	(branch_ID		varchar(5) PRIMARY KEY,
	 branch_Name		varchar(50) NOT NULL,
	 street				varchar(20),
	 building_number 	numeric(5,0),
	 city	varchar(20) NOT NULL,
	 postal_code	varchar(10),
	 assets	numeric(12,5) CHECK (assets >= 0)
	);

CREATE TABLE account
	(AC_ID	varchar(18) PRIMARY KEY,
	 customer_ID	varchar(5),
 	 branch_ID	varchar(10),
	 balance	numeric(12,2),
	 foreign key (customer_ID) references customer (customer_ID) on delete  CASCADE,
	 foreign key (branch_ID) references branch (branch_ID) on delete cascade
	);
	
INSERT INTO branch
VALUES ("B001", "ING Bank Amsterdam", "Oudegracht 221", 10001, "Amsterdam","1012AB",1230000.00),
				("B002", "ING Bank Rotterdam","Neude 1",10002,"Rotterdam","2595DG",9876000.54),
				("B003", "ING Bank Utrecht", "Vredenburg 40",10003, "Utrecht","3521BM",67000.98),
				("B004", "ING Bank The Hague", "Mariaplaats 45",10004, "The Hague","4811WZ",3400089.1234),
				("B005", "ING Bank Eindhoven", "Lange Nieuwstraat 24", 10005, "Eindhoven" ,"6211PA",760100.654);
				
				
INSERT INTO loan
VALUES( "L001", "B001", 100000, 80000),
			("L002", "B001", 30000, 5000),
			("L003", "B002", 1000000, 850000),
			("L004", "B004", 450000, 450000),
			("L005", "B005", 30000, 20000),
			("L006", "B005", 200000, 180000);

INSERT INTO customer
VALUES ("9876543210", "Prinsengracht", 40, "Amsterdam","Netherlands", "Jansen"),
				("9876543211", "Prinsengracht",40,"Amsterdam","Netherlands","Jansen"),
				("1234876952", "Hauptstraße",88, "Stuttgart","Germany","Müller"),
 				("7890654321", "Keizerstraat",12, "Groningen","Netherlands","Visser"),
				("4567123980", "Buchenweg", 27, "Lausanne" ,"Switzerland","Wagner"),
				("7881257321", "Molenweg", 8, "Maastricht" ,"Netherlands","Dijk"),
				("6891272722", "Friedrichstraße", 115, "Dortmund" ,"Germany","Fischer");

INSERT INTO account
VALUES ("NL95INGB0123456789", "9876543210", "B002", 1000120.00),
				("NL14INGB0455679123", "9876543211","B003",54321.75),
				("NL31INGB0789011115", "1234876952", "B001",987654.32),
				("NL89INGB0980004321", "7890654321", "B004",12345678.99),
				("NL04INGB0654000098", "4567123980", "B005", 7500.50),
				("NL39INGB7212004321", "7881257321", "B004",2678678.69),
				("NL12INGB8912105612", "6891272722", "B001",698175.01);
			
INSERT INTO borrows 
VALUES ("L001", "6891272722"),
		("L002", "1234876952"),
		("L003", "9876543210"),
		("L004", "7890654321"),
		("L005", "4567123980"),
		("L006", "4567123980");
			

				
INSERT INTO provides
VALUES ("B001", "L001"),
				("B002", "L002"),
				("B003", "L003"),
				("B004", "L004"),
				("B005", "L005");
				
SELECT  AC_ID, customer_ID, balance, branch_Name, street, building_number
FROM account ac
LEFT JOIN branch br ON ac.branch_ID = br.branch_ID;

SELECT loan.branch_ID, branch_Name, AVG (amount)
FROM loan
JOIN branch ON loan.branch_ID = branch.branch_ID
GROUP BY loan.branch_ID;

SELECT customer_ID, balance
FROM account
WHERE balance = (Select max (balance)
				From account);