DROP TABLE IF EXISTS cart CASCADE;

DROP TABLE IF EXISTS cart_check_out_payment CASCADE;

DROP TABLE IF EXISTS cart_details CASCADE;

DROP TABLE IF EXISTS Order_History CASCADE;

DROP TABLE IF EXISTS customers CASCADE;

DROP TABLE IF EXISTS employees CASCADE;

DROP TABLE IF EXISTS login CASCADE;

DROP TABLE IF EXISTS manage_departments CASCADE;

DROP TABLE IF EXISTS products_suppliedby CASCADE;

DROP TABLE IF EXISTS stores CASCADE;

DROP TABLE IF EXISTS store_products CASCADE;

DROP TABLE IF EXISTS store_departments CASCADE;

DROP TABLE IF EXISTS suppliers CASCADE;

DROP TABLE IF EXISTS works_in CASCADE;

DROP TABLE IF EXISTS subdepartments CASCADE;

create table Login(
    user_id serial primary key,
    user_type integer not null,
    login_username varchar(128) not null unique,
    login_password varchar(128) not null
);

create table Customers(
    customer_id serial primary key,
    customer_name varchar(128),
    customer_mobile varchar(128),
    customer_address varchar(128),
    customer_email varchar(128),
    customer_dob date,
    customer_gender varchar(128),
    user_id integer unique not null,
    foreign key(user_id) references Login(user_id)
);

create table Employees(
    employee_id serial primary key,
    employee_name varchar(128) not null,
    employee_mail varchar(128) not null,
    employee_dob date,
    employee_mobile varchar(128),
    employee_address varchar(128),
    employee_gender varchar(20)
);

create table manage_Departments(
    dept_id integer primary key,
    dept_name varchar(128),
    manager_id integer not null,
    foreign key(manager_id) references Employees(employee_id)
);

create table works_in(
    employee_id integer primary key,
    department_id integer not null,
    foreign key(employee_id) references Employees(employee_id),
    foreign key(department_id) references manage_Departments(dept_id)
);

create table Stores(
    store_id integer primary key,
    store_type varchar(128) not null,
    store_address varchar(128)
);

create table store_departments(
    dept_id integer,
    store_id integer,
    primary key(dept_id, store_id),
    foreign key (dept_id) references manage_Departments(dept_id),
    foreign key(store_id) references Stores(store_id)
);

create table subdepartments(
    dept_id integer,
    sub_dept_id integer,
    sub_dept_name varchar(128),
    foreign key (dept_id) references manage_Departments(dept_id),
    primary key (dept_id, sub_dept_id)
);

create table Suppliers(
    supplier_id integer primary key,
    supplier_name varchar(128),
    supplier_category integer not null,
    supplier_address varchar(128),
    foreign key(supplier_category) references manage_Departments(dept_id)
);

create table Products_suppliedBy(
    product_id integer primary key,
    department_id integer not null,
    sub_department_id integer not null,
    supplier_id integer not null,
    product_name varchar,
    price decimal not null,
    product_description varchar,
    foreign key(supplier_id) references Suppliers(supplier_id)
);

create table store_products(
    store_id integer,
    product_id integer,
    quantity integer CHECK(quantity >= 0),
    primary key(store_id, product_id),
    foreign key(store_id) references Stores(store_id),
    foreign key(product_id) references Products_suppliedBy(product_id)
);

create table cart (
    cart_id serial primary key,
    customer_id integer
);

create table cart_details(
    cart_id integer,
    store_id integer,
    product_id integer not null,
    quantity integer not null,
    primary key (cart_id, store_id, product_id),
    foreign key(cart_id) references cart(cart_id),
    foreign key(store_id) references stores(store_id),
    foreign key(product_id) references products_suppliedby(product_id)
);

create table Cart_check_out_Payment(
    payment_id serial primary key,
    payment_datetime timestamp,
    payment_amount decimal,
    payment_type varchar(128),
    cart_id integer unique not null,
    customer_id integer not null,
    foreign key (cart_id) references cart(cart_id)
);

create table Order_History(
    customer_id integer,
    order_id integer,
    primary key(customer_id, order_id),
    foreign key (customer_id) references Customers(customer_id) on delete cascade,
    foreign key (order_id) references Cart_check_out_Payment(payment_id)
);


ALTER SEQUENCE IF EXISTS cart_cart_id_seq restart with 16;
ALTER SEQUENCE IF EXISTS cart_check_out_payment_payment_id_seq restart with 9;