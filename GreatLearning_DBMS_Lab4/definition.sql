CREATE DATABASE GREATLEARNING;
USE GREATLEARNING;
CREATE TABLE supplier(supp_id int primary key,supp_name varchar(50) not null,supp_city varchar(50) not null,supp_phone varchar(10) not null);
CREATE TABLE customer(cus_id int primary key,cus_name varchar(20) not null,cus_phone varchar(10) not null,cus_city varchar(30) not null,cus_gender char);
CREATE TABLE category(cat_id int primary key,cat_name varchar(20) not null);
CREATE TABLE product(pro_id int primary key,pro_name varchar(20) default "dummy",pro_desc varchar(60),cat_id int,foreign key (cat_id) references category(cat_id));
CREATE TABLE supplier_pricing(pricing_id int primary key,pro_id int,supp_id int,supp_price int default 0, foreign key (pro_id) references product(pro_id),foreign key (supp_id) references supplier(supp_id));
CREATE TABLE orders(ord_id int primary key,ord_amount int not null,ord_date date not null, cus_id int,pricing_id int, foreign key (cus_id) references customer(cus_id), foreign key (pricing_id) references supplier_pricing(pricing_id));
CREATE TABLE rating(rat_id int primary key,ord_id int,rat_ratstars int not null, foreign key (ord_id) references orders(ord_id));