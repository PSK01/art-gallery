drop database if exists ArtGalleryDB;
create database ArtGalleryDB;

use ArtGallerydb;

drop table if exists ArtistInfoT;
CREATE TABLE ArtistInfoT (
    artistID INT NOT NULL AUTO_INCREMENT,
    artistName VARCHAR(255) NOT NULL,
    artistDOB DATE,
    artistApt VARCHAR(255),
    artistStreet VARCHAR(255),
    artistCountry VARCHAR(255),
    artistState VARCHAR(255),
    artistZip VARCHAR(255),
    artistEmail VARCHAR(255) NOT NULL,
    artistPhone VARCHAR(255) NOT NULL,
    PRIMARY KEY (artistID)
);

drop table if exists EventT;
CREATE TABLE EventT (
    eventID INT NOT NULL AUTO_INCREMENT,
    eventName VARCHAR(255) NOT NULL,
    eventDesc LONGTEXT,
    eventStartDate DATE NOT NULL,
    eventEndDate DATE,
    eventStartTime TIME NOT NULL,
    eventEndTime TIME NOT NULL,
    PRIMARY KEY (eventID)
);

drop table if exists EmployeeInfoT;
CREATE TABLE EmployeeInfoT (
    empID INT NOT NULL AUTO_INCREMENT,
    empName VARCHAR(255) NOT NULL,
    empDOB DATE NOT NULL,
    empApt VARCHAR(255) NOT NULL,
    empStreet VARCHAR(255) NOT NULL,
    empCountry VARCHAR(255) NOT NULL,
    empState VARCHAR(255) NOT NULL,
    empZip VARCHAR(255) NOT NULL,
    empEmail VARCHAR(255) NOT NULL,
    empPhone VARCHAR(255) NOT NULL,
    empStartDate DATE NOT NULL,
    empEndDate DATE DEFAULT NULL,
    empSalary DECIMAL(15 , 2 ) NOT NULL,
    empTitle VARCHAR(255) NOT NULL,
    PRIMARY KEY (empID)
);

drop table if exists CustomerInfoT;
CREATE TABLE CustomerInfoT (
    custID INT NOT NULL AUTO_INCREMENT,
    custName VARCHAR(255) NOT NULL,
    custDOB DATE,
    custPhone VARCHAR(255),
    custEmail VARCHAR(255),
    custStreet VARCHAR(255),
    custApt VARCHAR(255),
    custCountry VARCHAR(255),
    custstate VARCHAR(255),
    custzip VARCHAR(255),
    PRIMARY KEY (custID)
);

drop table if exists ProductInfoT;
CREATE TABLE ProductInfoT (
    prodID INT NOT NULL AUTO_INCREMENT,
    prodname VARCHAR(255) NOT NULL,
    PRIMARY KEY (prodID)
);

drop table if exists CustomerInterestT;
CREATE TABLE CustomerInterestT (
    custID INT NOT NULL,
    prodID INT NOT NULL,
    FOREIGN KEY (prodID)
        REFERENCES ProductInfoT (prodID),
    FOREIGN KEY (custID)
        REFERENCES CustomerInfoT (custID)
);

drop table if exists InventoryArtT;
CREATE TABLE InventoryArtT (
    itemID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    itemName VARCHAR(50) NOT NULL,
    artistID INT,
    itemCreateDate DATE,
    itemMoveInDate DATE NOT NULL,
    itemMoveoutDate DATE,
    FOREIGN KEY (artistID)
        REFERENCES ArtistInfoT (artistID)
); 

drop table if exists PartnerOrgT;
CREATE TABLE PartnerOrgT (
    partorgID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    partorgName VARCHAR(50) NOT NULL,
    partorgApt VARCHAR(50) NOT NULL,
    partorgStreet VARCHAR(50) NOT NULL,
    partorgCountry VARCHAR(50) NOT NULL,
    partorgState VARCHAR(50) NOT NULL,
    partorgZip VARCHAR(50) NOT NULL,
    partorgEmail VARCHAR(50) NOT NULL,
    partorgPhone VARCHAR(50) NOT NULL,
    partorgStartDate DATE,
    partorgType VARCHAR(50),
    constraint check_type check (partOrgType in ('janitorial','catering','waste disposal'))
);

drop table if exists DisplayArtT;
CREATE TABLE DisplayArtT (
    itemID INT NOT NULL,
    displayLocation VARCHAR(50) NOT NULL,
    FOREIGN KEY (itemID)
        REFERENCES InventoryArtT (itemID),
	CONSTRAINT display CHECK (displayLocation in ('H1','H2','H3'))
); 

drop table if exists LedgerT;
CREATE TABLE LedgerT (
    transactionID INT AUTO_INCREMENT PRIMARY KEY ,
    transactionAmt DECIMAL(10 , 2 ) NOT NULL,
    transactionTS DATETIME
);  
ALTER TABLE LedgerT AUTO_INCREMENT = 12000;

drop table if exists CreditT;
CREATE TABLE CreditT (
    transaction_ID INT,
    credit DECIMAL(10 , 2 ),
    transaction_time DATETIME
);

drop table if exists DebitT;
CREATE TABLE DebitT (
    transaction_ID INT,
    debit DECIMAL(10 , 2 ),
    transaction_time DATETIME
);

drop table if exists CollabT;
CREATE TABLE CollabT (
    collabID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    collabName LONGTEXT NOT NULL,
    collabDesc LONGTEXT,
    collabStartDate DATE,
    collabEndDate DATE
); 

drop table if exists ArtistContractT;
CREATE TABLE ArtistContractT (
    contractID INT NOT NULL PRIMARY KEY,
    artistID INT,
    contractSignDate DATE,
    contractStartDate DATE NOT NULL,
    contractEndDate DATE,
    contractComPer INT,
    FOREIGN KEY (artistID)
        REFERENCES ArtistInfoT (artistID)
); 

drop table if exists SalesT;
CREATE TABLE SalesT (
    salesID INT AUTO_INCREMENT PRIMARY KEY,
    transactionID INT,
    itemID INT,
    custID INT,
    salesmanID INT,
    salesAmount DECIMAL(10 , 2),
    artistID INT,
    salesDate DATE NOT NULL,
    FOREIGN KEY (itemID)
        REFERENCES inventoryArtT (itemID),
    FOREIGN KEY (custID)
        REFERENCES CustomerInfoT (custID),
    FOREIGN KEY (salesmanID)
        REFERENCES EmployeeInfoT (empID),
    FOREIGN KEY (artistID)
        REFERENCES ArtistInfoT (artistID)
);
ALTER TABLE salesT AUTO_INCREMENT = 10000;

drop table if exists artistcontract_auditT;
CREATE TABLE artistcontract_auditT (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(50),
    changeTimestamp DATETIME,
    contractID INT,
    artistID INT,
    contractSignDate DATE,
    contractStartDate DATE,
    contractEndDate DATE,
    contractComPer INT,
    currentCommision INT
);

drop table if exists partnerOrg_auditT;
CREATE TABLE partnerOrg_auditT (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(50),
    partorgID INT,
    partorgName VARCHAR(50),
    partorgApt VARCHAR(50),
    partorgStreet VARCHAR(50),
    partorgCountry VARCHAR(50),
    partorgState VARCHAR(50),
    partorgZip VARCHAR(50),
    partorgEmail VARCHAR(50),
    partorgPhone VARCHAR(50),
    partorgStartDate DATE,
    partnerorgEndDate DATE,
    partorgType VARCHAR(50)
);

-- DROP TABLE SEQUENCE IF NEEDED --
-- drop table partnerOrg_auditT;
-- drop table artistcontract_auditT;
-- drop table creditt;
-- drop table debitt;
-- drop table salest;
-- drop table eventt;
-- drop table employeeinfot;
-- drop table customerinterestt;
-- drop table partnerorgt;
-- drop table displayartt;
-- drop table collabt;
-- drop table artistcontractt;
-- drop table ledgert;
-- drop table inventoryartt;
-- drop table productinfot;
-- drop table customerinfot;
-- drop table artistinfot;

show tables;

-- --------------------------------------------------------------------------------------
-- INDEXES

-- 1. salesmanID: FK in salesT 
-- used in queries multiple times
CREATE INDEX salesmanIDI
ON SalesT(salesmanID);

-- 2. artistID: FK in salesT 
-- used in queries multiple times
CREATE INDEX artistIDI
ON SalesT(artistID);

-- VIEW
-- view on EmployeeInfoT
-- other employees can only see empID, empName
CREATE VIEW EmployeeInfoV AS
	SELECT empID, empName
    FROM employeeInfoT;
-- ---------------------------------------------------------------------------------------
-- Stored Procedures

-- TRIGGERS

-- 1. artistContractT - AUDIT TABLE - PRE UPDATE TRIGGER - 
-- all old fieldvalues need to be stored when an artist renews (updates) his contract
-- add field currentCommision = new.contractComPer
drop trigger if exists artistcontract_updateT;
create trigger artistcontract_updateT
before update on artistcontractt
for each row
	insert into artistcontract_auditT
    set action = 'update',
    changeTimestamp = now(),
    contractID = old.contractID,
    artistID = old.artistID, 
	contractSignDate = old.contractSignDate,
	contractStartDate = old.contractStartDate,
	contractEndDate = old.contractEndDate,
	contractComPer = old.contractComPer,
	currentCommision = new.contractComPer;
    
    
-- 2. partnerOrgT - AUDIT TABLE - PRE DELETE TRIGGER
-- Add field partOrgEndDate (today's date) and keep all other fields from partnerOrgT
drop trigger if exists pastPartnerOrg_deleteT;
create trigger pastPartnerOrg_deleteT
before delete on partnerOrgT
for each row 
	insert into partnerOrg_auditT
    set action = 'delete',
	partorgID = old.partorgID,
	partorgName = old.partorgName,
	partorgApt = old.partorgApt, 
	partorgStreet = old.partorgStreet,
	partorgCountry = old.partorgCountry,
	partorgState = old.partorgState,
	partorgZip = old.partorgZip,
	partorgEmail = old.partorgEmail,
	partorgPhone = old.partorgPhone,
	partorgStartDate = old.partorgStartDate,
	partnerorgEndDate = date_format(curdate(), '%Y-%m-%d'),
	partorgType = old.partorgType;

-- 3. ledgerT - CREDITT/DEBITT TABLES - POST INSERT TRIGGER
-- Automatic trigger credit entry from ledger when transactionAmt > 0
-- Automatic trigger debit entry from ledger when transactionAmt < 0

drop trigger if exists ledger_creditT;
delimiter $$
create trigger ledger_creditT
after insert on ledgert
for each row
begin
	if new.transactionAmt > 0 then
		insert into creditt values(new.transactionID, new.transactionAmt, now());
	else 
		insert into debitt values(new.transactionID, new.transactionAmt, now());
	end if;
end$$
delimiter ;

-- 4 salesT - salesT/inventoryartT/transactionT TABLES - PRE INSERT TRIGGER
-- check if the item exists in the inventory else throw error
-- update itemmoveoutdate in the inventoryartt from null to curdate() [item moved out from the inventory]
-- insert a new entry into ledgert
-- add transactionid to salest from ledgert
-- add artistID to salesT from inventoryartt
drop trigger if exists sales_entryT;
delimiter $$
create trigger sales_entryT
before insert on salest
for each row
begin
	if (new.itemID in (select itemID from inventoryartt where itemmoveoutdate is not null)) then 
		signal sqlstate '45000'
			set message_text = 'Item does not exist in the inventory';
	else
		update inventoryartt set itemmoveoutdate = curdate() where inventoryartt.itemid = new.itemID;
		insert into ledgert(transactionAmt,transactionTS) value(new.salesAmount, now());
        set new.transactionID  = (select ledgert.transactionID from ledgert order by transactionTS desc limit 1);
		set new.artistID = (select inventoryartt.artistID from inventoryartt where inventoryartt.itemID = new.itemID);
    end if;
end $$
delimiter ;

select * from inventoryartt;

-- FUNCTIONS

-- 1. totalPurchase()
drop function if exists totalPurchase;
delimiter $$
create function totalPurchase(cust_ID int)
returns decimal(10,2)
deterministic
begin
	declare totalPurchaseAmt decimal(10,2);
    set totalPurchaseAmt = (select sum(salesAmount) from salesT where custID = cust_ID);
    return totalPurchaseAmt;
end$$
delimiter ;

-- 2. totalSales()
-- in - artistID
-- out - totalSalesAmt
drop function if exists totalSales;
delimiter $$
create function totalSales(artist_ID int)
returns decimal(10,2)
deterministic
begin
	declare totalSalesAmt decimal(10,2);
    set totalSalesAmt = (select sum(salesAmount) from salesT where artistID = artist_ID);
    return totalSalesAmt;
end$$
delimiter ;

-- PROCEDURES

-- 1. PROCEDURE - GetCustomerLevel 
-- in - custID, @totalPurchase
-- print customerLevel
drop procedure if exists GetCustomerLevel;
delimiter $$
create procedure GetCustomerLevel(
 in cust_ID int,
 out customerLevel varchar(20)
 )
 begin
	declare totalPurchaseAmt decimal(10,2);
    -- call the function
    set totalPurchaseAmt = totalPurchase(cust_ID);
    if totalPurchaseAmt > 100000 then
		set customerLevel = 'PLATINUM';
	elseif (totalPurchaseAmt > 10000 and totalPurchaseAmt <= 100000) then 
		set customerLevel = 'GOLD';
	elseif (totalPurchaseAmt > 0 and totalPurchaseAmt <= 10000) then
		set customerLevel = 'SILVER';
	else
		set customerLevel = 'Invalid ID';
	end if;
end $$
delimiter ;


-- 2. PROCEDURE - GetArtistLevel 
-- in - artistID, @totalSales
-- print artistLevel
drop procedure if exists GetArtistLevel;
delimiter $$
create procedure GetArtistLevel(
 in artist_ID int,
 out artistLevel varchar(20)
 )
 begin
	declare totalSalesAmt decimal(10,2);
    -- call the function
    set totalSalesAmt = totalSales(artist_ID);
    if totalSalesAmt > 100000 then
		set artistLevel = 'GENIUS';
	elseif (totalSalesAmt > 50000 and totalSalesAmt <= 100000) then 
		set artistLevel = 'EXPERT';
	elseif (totalSalesAmt > 10000 and totalSalesAmt <= 50000) then
		set artistLevel = 'NOVICE';
	elseif (totalSalesAmt > 0 and totalSalesAmt <= 10000) then
		set artistLevel = 'ROOKIE';
	else
		set artistLevel = 'Invalid ID';
	end if;
end $$
delimiter ;

-- 3. PROCEDURE - GetPlanner
-- in - date
-- print - all events happening on that date
drop procedure if exists GetPlanner;
delimiter $$
create procedure GetPlanner(
in input_date date
)
begin
	select *
    from eventt
    where eventStartDate = input_date
    order by eventStartTime, eventEndTime;
end $$
delimiter ;

-- ---------------------------------------------------------------------------------------
-- Inserting the data

insert into artistinfot values ('1001','Leonardo Da Vinci','1980-04-10','4691','490 Elanor Grand St', 'USA', 'Michigan', '4980', 'leodavinci@gmail.com', '972-643-1234');
insert into artistinfot values ('1002','John V Ram','1966-04-08','7295','3761 N. 14th St', 'Australia', 'Queensland', '4700', 'jon24@gmail.com', '(11) 500 555-0162');
insert into artistinfot values ('1003','Lauren M Walker','1968-01-18','8370','4785 Scott Street', 'USA', 'Washington', '98312', 'lauren41@gmail.com', '717-555-0164');
insert into artistinfot values ('1004','Elizabeth Johnson','2001-10-12','4365','7553 Harness Circle', 'Australia', 'New South Wales', '2500', 'elizabeth5@yahoo.co.in', '(11) 500 555-0131');
insert into artistinfot values ('1005','Trevor Bryant','1996-1-12','1236','5781 Sharon Dr.', 'USA', 'California', '90012', 'trevor18@gmail.com', '853-555-0174');
insert into artistinfot values ('1006','Latoya C Goel','1978-4-03','0701','8154 Pheasant Circle', 'England', 'London', '7511.55', 'latoya18@gmail.com', '(11) 500 555-0149');
insert into artistinfot values ('1007','Fernando Barnes','2000-6-14','2209','7633 Greenhills Circle', 'Canada', 'Vancouver', '1500', 'fernando47@yahoo.com', '469-555-0125');
insert into artistinfot values ('1008','Eduardo Johnson','1951-08-12','8932','Hochstr 8444', 'Germany', 'Hessen', '34117', 'eduardo1@gmail.com', '(11) 500 555-0188');
insert into artistinfot values ('1009','Monica Kim','1998-12-12','2777','6, rue Philibert-Delorme', 'France', 'Hauts de Seine', '92700', 'monica1@gmail.com', '(11) 500 555-0118');
insert into artistinfot values ('1010','Shannon C Zhu','1988-10-10','9001','6, rue des Vendangeurs', 'France', 'Val d\'Oise', '95000', 'shannon13@gmail.com', '(11) 500 555-0183');
insert into artistinfot values ('1011','Kelli I Navarro','1995-04-29','1900','1164 Augustine Drive', 'Australia', 'New South Wales', '4661.5', 'kellie8@gmail.com', '(11) 500 555-0157');
insert into artistinfot values ('1012','Natalie M James',NULL,'3209','1277 Army Dr.', 'USA', 'California', '91203', 'natlaiej@gmail.com', '344-555-0196');
insert into artistinfot values ('1013','Marcus L Wood','1999-02-12','9001','8074 Oakmead', 'USA', 'California', '94109', 'marcuswood@gmail.com', '387-555-0136');
insert into artistinfot values ('1014','Warren Shah','1988-10-10','6932','6144 Rising Dawn Way', 'Australia', 'Queensland', '42170', 'warren41@gmail.com', '(11) 500 555-0193');
insert into artistinfot values ('1015','Jill Carlsen','2002-03-30','7885','3393 Alpha Way', 'Australia', 'New South Wales', '2300', 'jill28@gmail.com', '(11) 500 555-0176');
insert into artistinfot values ('1016','Chase Langley','1991-09-12','3002','4144 Mary Dr.', 'Canada', 'British Columbia', '95000', 'chase4@gmail.com', '939-555-0154');
insert into artistinfot values ('1017','Pearlie Rusek','1993-08-23','6503','5154 Brannan Pl.', 'Australia', 'Victoria', '48871', 'pearliewhirlie@gmail.com', '633-555-0100');
insert into artistinfot values ('1018','Jay Kapoor','1985-06-10','8410','420 Chandini Chowk. ', 'India', 'New Delhi', '11001', 'jay7@gmail.com', '(11) 500 555-0159');
insert into artistinfot values ('1019','Tracy Clark','1979-05-19','6001','6045 Elwood Drive', 'Australia', 'New South Wales', '2264', 'tracy3@gmail.com', '(11) 500 555-0157');
insert into artistinfot values ('1020','Ross Alvarez','1997-05-28','6667','490 Sepulveda Ct.', 'USA', 'California', '92118', 'ross25@gmail.com', '152-555-0151');


insert into inventoryartt values ('7000', 'Nighthawks', '1020', '2012-10-20', '2013-05-10',Null);
insert into inventoryartt values ('7001', 'Shiva as Lord of Dance', '1019', '2006-11-01', '2007-03-15',Null);
insert into inventoryartt values ('7002', 'Love Of Winter', '1014', '1999-06-01', '2001-01-01',Null);
insert into inventoryartt values ('7003', 'American Gothic', '1013', NULL, '2009-09-22',Null);
insert into inventoryartt values ('7004', 'The Bedroom', '1018', '2019-01-22', '2022-02-10',Null);
insert into inventoryartt values ('7005', 'Nightlife', '1010', '2020-09-08', '2021-02-19',Null);
insert into inventoryartt values ('7006', 'The Old Guitarist', '1017', '1999-04-20', '2007-01-31',Null);
insert into inventoryartt values ('7007', 'America Windows', '1016',NULL, '2014-03-05',Null);
insert into inventoryartt values ('7008', 'City Landscape', '1015', '2000-08-08', '2010-08-11',Null);
insert into inventoryartt values ('7009', 'Target', '1003', '1991-10-20', '2000-07-12',Null);
insert into inventoryartt values ('7010', 'Water Lilies', '1002', '2008-11-20', '2008-12-01',Null);
insert into inventoryartt values ('7011', 'Two Sisters', '1008', '2002-06-01', '2002-08-24',Null);
insert into inventoryartt values ('7012', 'The Rock', '1011', '2004-02-03', '2016-07-16',Null);
insert into inventoryartt values ('7013', 'Sky Above the Clouds', '1009', NULL, '2008-01-22',Null);
insert into inventoryartt values ('7014', 'Clown Torture', '1007', '2001-11-02', '2002-01-15',NULL);
insert into inventoryartt values ('7015', 'Figure With Meat', '1006', '2010-11-23', '2011-09-23',NULL);
insert into inventoryartt values ('7016', 'The Red Armchair', '1001', '1998-07-15', '2000-01-01',NULL);
insert into inventoryartt values ('7017', 'Self Portrait', '1004', '2017-10-28', '2018-06-21',NULL);
insert into inventoryartt values ('7018', 'The Earth is a Man', '1005', '2006-07-20', '2009-02-20',NULL);
insert into inventoryartt values ('7019', 'Little Harbour in Normandy', '1012', NULL, '2022-08-12',NULL);
insert into inventoryartt values ('7020', 'Ballet at the Paris Opera', '1019', '2016-05-29', '2018-06-30',NULL);

 
insert into employeeinfot values ('2000','Sarah Kent', '1980-10-05', '7890', '3884 Bates Court', 'USA', 'Oregon', 97355, 'sarah78@gmail.com', '424-555-0137', '2000-11-01', null, 100000.00,'Mrs.');
insert into employeeinfot values ('2001','Ryan Brown', '1990-03-22', '1209', '2939 Wesley Ct.', 'USA', 'California', 90401, 'ryan90@gmail.com', '539-555-0198', '2000-11-01', null, 94000.00,'Mr.');
insert into employeeinfot values ('2002','Byron Vasquez', '1993-08-29', '3420', '3187 Hackamore Lane', 'Australia', 'New South Wales', 2055, 'byron9@gmail.com', '(11) 500 555-0136', '2000-11-01', null, 25000.00,'Mr.');
insert into employeeinfot values ('2003','Jasmine Taylor', '2000-07-13', '1098', '2457 Matterhorn Court', 'USA', 'Washington', 9902, 'jasmineT8@gmail.com', '557-555-0146', '2000-11-01', null, 40000.00,'Ms.');
insert into employeeinfot values ('2004','Edward Hernandez', '1978-11-16', '9999', '7607 Pine Hollow Road', 'USA', 'Washington', 98107, 'eduhernandez@gmail.com', '178-555-0196', '2000-11-01', null, 22000.00,'Mr.');
insert into employeeinfot values ('2005','Ashley Henderson', '1992-01-12', '5621', '8834 San Jose Ave.', 'Canada', 'British Columbia', 1616, 'ashleyhendo@gmail.com', '173-555-0121', '2012-11-01', null, 19000.00,'Mrs.');
insert into employeeinfot values ('2006','Alfredo Romero', '1996-04-22', '8976', '2499 Greendell Pl', 'USA', 'Oregon', 97005, 'alfredo10@gmail.com', '342-555-0110', '2012-11-01', null,28000.00, 'Mr.');
insert into employeeinfot values ('2007','Daniel Cox', '2003-06-20', '4093', '2346 Wren Ave', 'USA', 'Washington', 98055, 'danicox@gmail.com', '396-555-0158', '2015-11-01', null,42000.00, 'Mr.');
insert into employeeinfot values ('2008','Jennifer Simmons', '2001-06-30', '2039', '7959 Mt. Wilson Way', 'Canada', 'British Columbia', 11268, 'jenny42@gmail.com', '148-555-0115', '2018-11-01', null, 29000.00,'Ms.');
insert into employeeinfot values ('2009','Ryan Foster', '1994-02-28', '5860', '5376 Sahara Drive', 'USA', 'California', 94015, 'misterfoster@gmail.com', '961-555-0133', '2019-11-01', null, 30000.00,'Mr.');
insert into employeeinfot values ('2010','Elizabeth Jones', '1995-09-29', '1356', '2253 Firestone Dr.', 'USA', 'Washington', 98033, 'elijonesey@gmail.com', '941-555-0110', '2020-11-01', null, 41000.00,'Mrs.');
insert into employeeinfot values ('2011','Lauren Martinez', '1986-12-31', '0395', '4357 Tosca Way', 'USA', 'California', 90210, 'lauram@gmail.com', '977-555-0117', '202-11-01', null, 48000.00,'Mrs.');


insert into artistcontractt values (5001,1001,'2000-01-01','2000-02-01','2040-05-06',50);
insert into artistcontractt values (5002,1002,'2006-02-13','2006-03-19','2025-10-12',60);
insert into artistcontractt values (5003,1003,'2000-07-01','2005-02-01','2020-01-01',75);
insert into artistcontractt values (5004,1004,'2001-01-01','2002-02-05',NULL,20);
insert into artistcontractt values (5005,1005,'2015-01-01','2008-02-01',NULL,50);
insert into artistcontractt values (5006,1006,'1998-09-12','2016-05-16','2040-10-10',60);
insert into artistcontractt values (5007,1007,'1998-09-12', '2000-05-16',NULL,70);
insert into artistcontractt values (5008,1008,'2006-03-01','2007-02-01','2010-01-01',60);
insert into artistcontractt values (5009,1009,'2007-04-10','2008-0-01','2013-09-08',50);
insert into artistcontractt values (5010,1010,'2008-05-20','2009-02-01','2010-02-01',55);
insert into artistcontractt values (5011,1011,'2009-12-30','2010-02-01','2015-08-01',35);
insert into artistcontractt values (5012,1012,'2010-11-14','2011-02-01','2016-09-01',45);
insert into artistcontractt values (5013,1013,'2011-06-18','2012-02-01','2017-11-01',65);
insert into artistcontractt values (5014,1014,'2012-02-22','2013-02-01','2015-10-02',70);
insert into artistcontractt values (5015,1015,'2000-08-25','2014-02-01','2016-04-01',50);
insert into artistcontractt values (5016,1016,'2003-10-26','2015-02-01','2016-02-01',55);
insert into artistcontractt values (5017,1017,'2004-02-12','2005-02-01','2030-01-01',80);
insert into artistcontractt values (5018,1018,'2002-07-30','2003-02-01','2010-05-01',50);
insert into artistcontractt values (5019,1019,'2001-06-30','2005-02-01','2012-10-01',40);
insert into artistcontractt values (5020,1020,'2008-08-31','2009-02-01','2025-06-01',40);


insert into displayartt values ('7000', 'H1');
insert into displayartt values ('7011', 'H1');
insert into displayartt values ('7012', 'H1');
insert into displayartt values ('7013', 'H2');
insert into displayartt values ('7016', 'H2');
insert into displayartt values ('7017', 'H2');
insert into displayartt values ('7019', 'H2');
insert into displayartt values ('7020', 'H3');


insert into productinfot values('3003', 'Souveniers');
insert into productinfot values('3004', 'Art Pieces');
insert into productinfot values('3005', 'Newsletters');


insert into customerinfot values ('6001',"Daniel Mcconnell",'1997-10-05',"516-721-3355","montes.nascetur@google.net","199-3334 Nunc Street","7215","South Korea","Seoul Capital","100-015");
insert into customerinfot values('6002',"Gary Hicks",'2000-04-16',"(473) 604-7051","vel@icloud.couk","Ap #258-6879 Interdum Rd.","1341","USA","NY","10001");
insert into customerinfot values('6003',"Gabriel Donaldson",'1968-07-13',"(994) 851-7855","aliquet.molestie.tellus@outlook.net","P.O. Box 388, 6448 Turpis Av.","6981","USA","California","90263");
insert into customerinfot values('6004',"August Gallagher",'1958-03-03',"958-741-9569","non.sapien.molestie@hotmail.ca","P.O. Box 835, 3906 Adipiscing, Rd.","2134","India","Maharashtra","400080");
insert into customerinfot values('6005',"Tana Burris",'2003-05-26',"932-502-5547","mauris@hotmail.com","Ap #192-2583 Vel Avenue","0987","USA","Texas","75252");
insert into customerinfot values('6006',"Mira Carrillo",'1971-05-18',"978-463-5356","aliquam.adipiscing.lacus@aol.edu","P.O. Box 522, 7271 Massa. Ave","4150","USA","Texas","75024");
insert into customerinfot values('6007',"Venus Romero",'1965-12-18',"(734) 225-3477","pede@protonmail.com","702-514 Sed, St.","8591","USA","NY","10002");
insert into customerinfot values('6008',"Gail Padilla",'1988-07-14',"961-366-5614","natoque.penatibus@outlook.com","1159 Aenean Av.","6908","USA","California","91331");
insert into customerinfot values('6009',"Ora Cotton",'1959-01-20',"(436) 765-2283","consectetuer.euismod@yahoo.edu","9813 Tristique Avenue","3178","Japan","Tokyo Prefecture","53717");
insert into customerinfot values('6010',"Chava Hernandez",'2002-01-29',"488-574-2533","mauris.ipsum.porta@hotmail.net","Ap #123-4930 Consectetuer Street","9308","USA","Texas","75080");
insert into customerinfot values('6011',"Lionel Ronaldo",'1998-01-29',"488-554-1533","lR@hotmail.net","Stillwaterlane","6100","USA","Texas","75020");
insert into customerinfot values('6012',"Luis Diaz",'1996-01-29',"448-584-2513","ld@hotmail.net","Ap #123-481 Consectetuer Street","9301","USA","Texas","75081");
insert into customerinfot values('6013',"Christain Pulisic",'1995-01-29',"988-374-2513","CP@hotmail.net","Ap #123-4930 Plaza Street","1502","USA","Texas","75024");
insert into customerinfot values('6014',"Tyler Adams",'1994-11-29',"448-570-2233","TAa@hotmail.net","Ap #12-430 Consectetuer Street","98","USA","Texas","75025");


insert into ledgert(transactionAmt,transactionTS) values (-730, '2022-02-03 13:40:10' );
insert into ledgert(transactionAmt,transactionTS) values (1000, '2022-02-26 11:42:21' );
insert into ledgert(transactionAmt,transactionTS) values (-200, '2022-03-12 04:10:48' );


insert into collabt(collabID,collabName,collabDesc,collabStartDate,collabEndDate)
values('301','Max Ernst and Dorothea Tanning','the glimpse of war','2022-12-12','2022-12-16'),
       ('302','Marina Ambramović and Ulay','the moon nights','2022-12-08','2022-12-10'),
       ('303','Andy Warhol and Jean-Michel Basquiat','A Crazy Art-World Marriage','2022-11-28','2022-11-30'),
       ('304','Jasper Johns and Robert Rauschenberg','When Abstract Expressionists Meet','2022-11-24','2022-12-06'),
       ('305','Marcel Duchamp and Man Ray','50 Years of Shared Aesthetics','2022-11-28','2022-12-01'),
       ('306','Pablo Picasso and Gjon Mili','Drawing with Pure Light','2022-12-01','2022-12-08'),
       ('307','Frida Kahlo and Diego Rivera','100 years of solitude','2022-11-28','2022-12-07'),
       ('308','Bernd and Hilla Becher','Impression: Sunrise','2022-11-23','2022-11-29'),
       ('309','Georgia O’Keeffe and Alfred Stieglitz','the creative cure','2022-12-20','2022-12-30'),
       ('310','Georgia O’Keeffe and Alfred Stieglitz','the riverdale magic','2022-11-26','2022-12-06'),
       ('311','Christo and Jeanne-Claude',null, '2022-11-27','2022-12-10'),
       ('312','Tim Noble and Sue Webster',null, '2022-11-17','2022-12-01'),
       ('313','Marsha Blaker and Paul DeSomma',null, '2022-11-27','2022-12-05');


insert into PartnerOrgT(partorgID,partorgName,partorgapt,partorgStreet,partorgCountry,partorgState,partorgZip ,partorgEmail ,partorgPhone,partorgStartDate,partorgType)
values('901','Taste & Fun Catering','Welcome Home','1350 n greenville','usa','texas','76093','cxy@gmail.com','9876789890','2022-11-01','catering'),
	  ('902','Ultimate Food','Relaxing Apartments','TN 37217','usa','arizona','76034','ultimate@gmail.com','4567898765','2022-11-03','catering'),
	  ('903','My Catering Company','Peak Living','80403 golden co','usa','california','75022','my@yahooo.com','988978876','2022-11-03','catering'),
      ('904','The Catering Angels','Sunset Homes','4016 Doane Street','usa','hawaii','75223','angels@gmail.com','7899877890','2022-11-24','catering'),
      ('905','Veolia Environmental Services','Pristine Apartments','2436 Naples Avenue','usa','florida','67598','veolia@gmail.com','8908900988','2022-11-23','waste disposal'),
      ('906','Republic Services Inc','Value Living','2325 Eastridge Circle','usa','washington','75095','republic67@gmail.com','9879876789','2022-11-02','waste disposal'),
      ('907','Waste Connections Inc','Luxe Living','19141 Pine Ridge Circle','usa','nashville','89067','waste@gmail.com','8906789808','2022-11-08','waste disposal'),
      ('908','Stericycle Inc','The Sweetest Homes','915 Heath Drive','usa','ohio','78906','stericycle@gmail.com','9090909090','2022-11-04','waste disposal'),
	  ('909','Maid in Manhattan','Sea View Apartment','1693 Alice Court','usa','colorado','23657','maid@yahoo.com','7878787878','2022-11-06','janitorial'),
      ('910','Deep Clean Office Team','Cozy Nest Apartments','5331 Rexford Court','usa','michigan','45678','deepclean@gmail.com','6767676778','2022-11-23','janitorial'),
      ('911','Fresh Start Office Cleaning','Honest Homes','8642 Yule Street','usa','texes','90876','freash@yahoo.com','8989898909','2022-11-27','janitorial'),
      ('912','Meticulous Maids','Prime Location Apartments','4001 Anderson Road','usa','ohio','77667','maids@gmail.com','9876543212','2022-11-20','janitorial'),
      ('913','Maids on Wheels','Estate Location Apartments','7421 Frankford Road','usa','texas','75252','maidsonwheels@gmail.com','9876544512','2022-11-20','janitorial'),
      ('914','Maids on Wheels','Estate Location Apartments','7421 Frankford Road','usa','texas','75252','maidsonwheels@gmail.com','9876544512','2022-11-20','catering'),
	  ('915','Maids on Wheels','Estate Location Apartments','7421 Frankford Road','usa','texas','75252','maidsonwheels@gmail.com','9876544512','2022-11-20','waste disposal');

insert into eventt(eventid,eventname,eventdesc,eventstartdate,eventstarttime,eventendtime)     
values('1007','Josephine Durkin: Funeral Flowers','exhibition of new 2D works by Dallas-based sculptor','2022-12-06','09:00:00','21:00:00'),
        ('1008','KEITH CARTER Ghostlight','exhibition in celebration of his recent Lifetime Achievement','2022-12-05','09:00:00','22:30:00'),
        ('1009','Sam Mack buff','the show references the words numerous definitions','2022-12-08','10:00:00','20:00:00'),
        ('1010','József Csató Lush Ferns in Empty Wells','an exhibition of artworks by Budapest based artist József Csató - I','2022-11-06','11:00:00','21:00:00'),
        ('1011','József Csató Lush Ferns in Empty Wells','an exhibition of artworks by Budapest based artist József Csató - II','2022-12-06','05:00:00','09:00:00');
 
insert into CustomerInterestT values
('6001', '3003'),
('6002', '3003'), 
('6003','3004') , 
('6004','3004'), 
('6005','3003'), 
('6006','3005'), 
('6007','3004'), 
('6008','3005'), 
('6009','3004'), 
('6010','3004'),
('6008','3003'), 
('6003','3005'),
('6014','3005'),
('6011','3005'),
('6012','3003'),
('6013','3005');

insert into SalesT(itemID, custID, salesmanID, salesAmount, salesDate) values
('7001','6001','2001','230.57', '2022-11-11'),
('7002','6002','2002','432.68','2022-11-1'),
('7003','6003','2003','714.52','2022-10-25'),
('7004','6004','2004','329','2022-09-21'),
('7005','6005','2005', '568.23','2022-07-22'),
('7006','6006','2006','497.82','2022-06-20'),
('7007','6006','2006','118','2022-11-22'),
('7008','6006','2006','508.45','2022-10-01'),
('7009','6006','2006','160','2022-09-15'),
('7010','6006','2006','665.8','2022-09-2'),
('7018','6007','2006','685.89','2021-12-12'),
('7015','6007','2005','585.89','2020-10-01'),
('7014','6008','2007','799.89','2015-10-01');
-- ---------------------------------------------------------------------------------------
-- Queries

-- 1. Display all the art pieces along with the names of the artists who created them and the year in which they were created that are displayed in hall 1 (DisplayArtT and InventoryArtT)
select DisplayArtT.itemID, DisplayArtT.displayLocation, InventoryArtT.artistID, extract(year from InventoryArtT.itemCreateDate) as yearOfCreation, ArtistInfoT.artistName 
from DisplayArtT
inner join InventoryArtT
on DisplayArtT.itemID = InventoryArtT.itemID
inner join ArtistInfoT
on InventoryArtT.artistID = ArtistInfoT.artistID
where DisplayArtT.displayLocation = 'H1';

-- 2. Display all the sales made in the month of Nov 2022 (salesT and inventoryArtT and customerInfoT)
select SalesT.salesID, customerInfoT.custName, inventoryArtT.itemID, SalesT.salesDate
from SalesT
inner join inventoryArtT
on inventoryArtT.itemID = SalesT.itemID
inner join customerInfoT
on customerInfoT.custID = SalesT.custID
where SalesT.salesDate like ('2022-11-%');

-- 3. To find the employee of the month November (max total sales) in the year 2022 (SalesT and EmployeeInfoT)
select SalesT.salesmanID, EmployeeInfoT.empName, sum(SalesT.salesAmount) as totalSales
from SalesT
inner join EmployeeInfoT
on EmployeeInfoT.empID = SalesT.salesmanID
where SalesT.salesDate like ('2022-11-%')
group by SalesT.salesmanID
order by totalSales desc
limit 1;

-- 4. Best performing (Top 5) artists in the year 2022 
select SalesT.artistID, ArtistInfoT.artistName, sum(SalesT.salesAmount) as totalSales 
from SalesT
inner join ArtistInfoT
on SalesT.artistID = ArtistInfoT.artistID
where SalesT.salesDate like ('2022%')
group by SalesT.artistID
order by totalSales desc 
limit 5;

-- 5. Least performing art pieces (Top 5 DESC)
-- itemmoveoutdate must be null (still in the inventory)
-- AND
-- must be in the inventory for at least a year
select * from InventoryArtT
where itemMoveOutDate is null and itemMoveInDate < (select date_sub(curdate(), interval 1 year))
order by itemMoveInDate
limit 5;

-- 6. List all the customers that belong to a particular area (zipcode = x) and are interested in newsletters (productID = 3005)
-- assume our gallery is in texas, forthworth area
-- you want to select customers that live in the area with zipcode starting from 75---
-- ADD MORE ROWS
select *, ProductInfoT.prodName
from CustomerInfoT
left join CustomerInterestT
on CustomerInfoT.custID = CustomerInterestT.custID
inner join ProductInfoT
on CustomerInterestT.prodID = ProductInfoT.prodID
where custCountry = 'USA' and custzip like ('75%') and ProductInfoT.prodName = 'Newsletters';

-- 7. List all the paintings that are priced higher than the average price of all the paintings sold in the gallery (subquery)
select distinct itemID, salesAmount 
from SalesT
where salesAmount > (select avg(salesAmount) from SalesT);

-- 8. List months of 2022 in descending order of the total sales
select sum(salesAmount) as totalSales, monthname(salesDate) as monthOfYear 
from SalesT
where year(salesDate) = '2022'
group by month(salesDate)
order by totalSales desc;

-- 9. List average/total sales for the month of November 2022
select avg(salesAmount) as avgSales, monthname(salesDate) as monthOfYear
from SalesT
where month(salesDate) = '11' and year(salesDate) = '2022';

-- 10. List the customers who have not purchased anything from the gallery
select CustomerInfoT.custID , CustomerInfoT.custName 
from CustomerInfoT 
where CustomerInfoT.custID not in (select distinct CustomerInfoT.custID from CustomerInfoT right join SalesT on CustomerInfoT.custID = SalesT.custID);

-- 11. List the customers who have not purchased anything from the gallery for the last five years
-- keep resluts from the above query as well
-- ADD MORE ROWS IN THE SECOND PART OF THE UNION QUERY
select CustomerInfoT.custID , CustomerInfoT.custName 
from CustomerInfoT 
where CustomerInfoT.custID not in (select distinct CustomerInfoT.custID from CustomerInfoT right join SalesT on CustomerInfoT.custID = SalesT.custID)
union
select CustomerInfoT.custID , CustomerInfoT.custName
from CustomerInfoT
right join SalesT
on CustomerInfoT.custID = SalesT.custID
where datediff(now(), SalesT.salesDate)/365 > 5;

-- 12. Display sale with 3rd highest sales amount for each year
with cte as
(select *, row_number() over(partition by year(salesDate) order by salesAmount desc) as row_num 
from salesT)
select *
from cte
where row_num = 3;

-- 13. Calculate the total commission earned by an artist given the artist ID = 1001
select salesT.artistID, sum(salesT.salesAmount)*artistcontractT.contractComPer/100 as totalCommission
from salesT
left join artistcontractT
on salesT.artistID = artistcontractT.artistID
where salesT.artistID = 1001;

-- 14. Calculate average yearly sales made by an artist and the commission he earned for it over the years (artist ID = 1001)
-- ADD MORE ROWS FOR OTHER YEARS FOR AN ARTIST
select salesT.artistID, year(salesDate) as yearOfSale, avg(salesT.salesAmount) as avgSales, sum(salesT.salesAmount)*artistcontractT.contractComPer/100 as totalCommission
from salesT
left join artistcontractT
on salesT.artistID = artistcontractT.artistID
group by salesT.artistID, year(salesT.salesDate)
having salesT.artistID = 1001;

-- 15. Calculate average yearly sales made by a salesman (salesmanID = 2006)
-- ADD MORE ROWS FOR OTHER YEARS
select salesmanID, year(salesDate) as yearOfSale, avg(salesAmount) as avgSales
from salesT
group by salesmanID, year(salesDate)
having salesmanID = 2006;

-- 16. Find all the customers who have interest in the products of the art gallery and have their birthday today and what product they are interested in.
select customerinfot.custID, customerinfot.custName, customerinfot.custDOB, customerinfot.custPhone, customerinterestt.prodID, productinfot.prodName from customerinfot
join customerinterestt
on customerinfot.custID = customerinterestt.custID
join productinfot
on customerinterestt.prodID = productinfot.prodID
where date_format((customerinfot.custDOB),'%m-%d') = date_format(now(),'%m-%d');
-- ----------------------------------------------------------------------------------------
-- OUTPUT

-- STORED PROCEDURES AND FUNCTIONS
call GetPlanner('2022-12-06');

select totalPurchase(6001);

call GetCustomerLevel(6001, @customerLevel);
select @customerLevel;

call GetCustomerLevel(-1, @customerLevel);
select @customerLevel;

select totalSales(1001);

call GetArtistLevel(1001, @artistLevel);
select @artistLevel;

call GetArtistLevel(9, @artistLevel);
select @artistLevel;

-- TRIGGERS
update artistcontractt
set contractcomper = 45
where contractid = 5004;
select * from artistcontract_auditt;

delete 
from partnerorgt
where partorgID = 913;
select * from partnerorg_auditt;

insert into ledgert(transactionAmt, transactionTS) values (-500, now());
select * from ledgert;
select * from debitt;
select * from creditt;

select * from inventoryartt;

-- will throw error because the item does not exist in the inventory
-- insert into salest(itemID, custID, salesmanID, salesAmount, salesDate) value(7014, 6006, 2006, 665.89,'2022-12-01');

insert into salest(itemID, custID, salesmanID, salesAmount, salesDate) value
(7011, 6006, 2006, 665.89,'2022-12-01');
select * from ledgert;
select * from inventoryartt;
select * from salest;

-- VIEW
select * from employeeinfov;
