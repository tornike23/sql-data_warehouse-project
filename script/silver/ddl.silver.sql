/*
==============DDL SCRIPT================
This is a ddl script for loading silver
dropping existing schemas
*/


DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id int,
    cst_key varchar(50),
    cst_firstname varchar(50),
    cst_lastname varchar(50),
    cst_maritial_status varchar(50),
    cst_gndr varchar(50),
    cst_create_date date
);


DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id int,
    cat_id varchar(50),
    prd_key varchar(50),
    prd_nm varchar(50),
    prd_cost int,
    prd_line varchar(50),
    prd_start_dt date,
    prd_end_dt date,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_sales_details;


CREATE TABLE silver.crm_sales_details (
    sls_ord_num   varchar(50),
    sls_prd_key   varchar(50),
    sls_cust_id   int,
    sls_order_dt  date,
    sls_ship_dt   date,
    sls_due_dt    date,
    sls_sales     int,
    sls_quantity  int,
    sls_price     int
);



-- no ddl changes for erp_cust_az12

-- no ddl changes for erp_loc_a101

-- no ddl changes for erp_px_cat_g1v2


