DROP DATABASE IF EXISTS rug_sale;
CREATE DATABASE rug_sale;
USE rug_sale;

CREATE TABLE Rugs (
    PRIMARY KEY     (RugID),
    RugID           INT AUTO_INCREMENT,
    Description     VARCHAR(200),
    PurchasePrice   DECIMAL(9,2),
    Markup          DECIMAL(4,2),
    ListPrice       DECIMAL(9,2)
)

CREATE TABLE Customers (
    PRIMARY KEY     (CustomerID),
    CustomerID      INT AUTO_INCREMENT,
    Name            VARCHAR(30),
    Address         VARCHAR(200),
    Phone           INT,
    IsAtice         BOOlEAN
)

CREATE TABLE Reservations (
    FOREIGN KEY     (CustomerID) REFERENCES     Consumers(ConsumerID),
    FOREIGN KEY     (RugID)      REFERENCES     Rugs(RugID),
    CustomerID      INT NOT NULL,
    RugID           INT NOT NULL,
    ReserveStart    DATETIME,
    ReserveDue      DATETIME,
    ReserveReturn   DATETIME
)

CREATE TABLE Transactions (
    FOREIGN KEY     (CustomerID) REFERENCES     Consumers(ConsumerID),
    FOREIGN KEY     (RugID)      REFERENCES     Rugs(RugID),
    CustomerID      INT NOT NULL,
    RugID           INT NOT NULL,
    SaleDate        DATETIME,
    SalePrice       DECIMAL(9,2),
    SaleNet         DECIMAL(9,2),
    DateReturn      DATETIME
)

