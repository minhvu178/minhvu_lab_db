-- WB: Good work Minh. Please see some comments below.
DROP DATABASE IF EXISTS rug_sale;
CREATE DATABASE rug_sale;
USE rug_sale;

CREATE TABLE Rugs (
    PRIMARY KEY     (RugID),
    RugID           INT AUTO_INCREMENT,
    Description     VARCHAR(200), -- WB: This is a multi-part field. Not only that, but it 
    -- WB: would ideally have several validation tables, for country, style, and material.
    PurchasePrice   DECIMAL(9,2),
    DateAc          DATETIME(2),
    Markup          DECIMAL(4,2),
    ListPrice       DECIMAL(9,2) -- WB: When purchase price and markup are stored, this is a calculated field.
);

CREATE TABLE Customers (
    PRIMARY KEY     (CustomerID),
    CustomerID      INT AUTO_INCREMENT,
    Name            VARCHAR(30),
    Address         VARCHAR(200), -- WB: This is a multi-part field, and should be broken up.
    Phone           INT
);

CREATE TABLE Reservations (
    FOREIGN KEY     (CustomerID) REFERENCES     Consumers(ConsumerID),
    FOREIGN KEY     (RugID)      REFERENCES     Rugs(RugID),
    CustomerID      INT NOT NULL,
    RugID           INT NOT NULL,
    ReserveStart    DATETIME,
    ReserveDue      DATETIME,
    ReserveReturn   DATETIME
);

CREATE TABLE Transactions (
    FOREIGN KEY     (CustomerID) REFERENCES     Consumers(ConsumerID),
    FOREIGN KEY     (RugID)      REFERENCES     Rugs(RugID),
    CustomerID      INT NOT NULL,
    RugID           INT NOT NULL,
    PRIMARY KEY     (RugID,CustomerID,SaleDate)
    SaleDate        DATETIME(2),
    SalePrice       DECIMAL(9,2),
    SaleNet         DECIMAL(9,2),
    DateReturn      DATETIME
);



INSERT INTO Rugs(Description, PurchasePrice, DateAc, Markup, ListPrice)
VALUES  ('Turkey Ushak 1925 5x7 Wool', 625.00, '2017-04-06', 1.00, 1250.00),
        ('Iran Tabriz 1910 10x14 Silk', 28000.00, '2017-04-06', 0.75, 49000.00),
        ('India Agra 2017 Wool 8x10', 1200.00, '2017-06-15', 1.00, 2400.00),
        ('India Agra 2017 Wool 4x6', 450.00, '2017-06-15', 1.20, 990.00);

INSERT INTO Customers(Name, Address, Phone)
VALUES  ('Akira Ingram', '68 Country Drive, Roseville, MI 48066', 9262526716),
        ('Meredith Spencer', '9044 Piper Lane, North Royalton, OH 44133', 8175305994),
        ('Marco Page', '747 East Harrison Lane, Atlanta, GA 30303', 5887996535),
        ('Sandra Page', '747 East Harrison Lane, Atlanta, GA 30303', 9976972666),
        ('Bria Le', '386 Silver Spear Court, Coraopolis, PA 15108', 9994943316),
        ('Gloria Gomez', '78 Corona Rd., Fullerton, CA 92831', 8679262585);
        
SELECT * FROM Rugs;
SELECT * FROM Customers;



