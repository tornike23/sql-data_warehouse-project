/* 
============ Stored Procedure: Load Silver Value===========
Purpose:
Loads the Silver layer by taking raw data from 
the Bronze schema, applying necessary transformations 
and cleaning, and inserting it into the target tables.
===========================================================
*/


/* crm_cust_info table*/

TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info ( 
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_maritial_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE WHEN UPPER(TRIM(cst_maritial_status)) = 'M' THEN 'Married'
         WHEN UPPER(TRIM(cst_maritial_status)) = 'S' THEN 'Single'
         ELSE 'n/a'
    END AS cst_maritial_status,
    CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
         WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
         ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS recent
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t 
WHERE recent = 1;


/* crm_prd_info table */

TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
        WHEN 'R' THEN 'Road'
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touring'
        WHEN 'S' THEN 'Other Sales'
        ELSE 'n/a'
    END AS prd_line,
    CAST(prd_start_dt AS date) AS prd_start_dt,
    CAST(
        LEAD(prd_start_dt::date) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day'
        AS date
    ) AS prd_end_dt
FROM bronze.crm_prd_info;


/* crm_sales_details table */

TRUNCATE TABLE silver.crm_sales_details;
insert into silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity, 
	sls_price
)
select 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case 
        when sls_order_dt = 0 or length(sls_order_dt::varchar) != 8 then null
        else to_date(sls_order_dt::varchar, 'yyyymmdd')
    end as sls_order_dt,
    case 
        when sls_ship_dt = 0 or length(sls_ship_dt::varchar) != 8 then null
        else to_date(sls_ship_dt::varchar, 'yyyymmdd')
    end as sls_ship_dt,
    case 
        when sls_due_dt = 0 or length(sls_due_dt::varchar) != 8 then null
        else to_date(sls_due_dt::varchar, 'yyyymmdd')
    end as sls_due_dt,
    case 
        when sls_sales is null 
            or sls_sales <= 0 
            or sls_sales != sls_quantity * abs(sls_price) 
        then sls_quantity * abs(sls_price)
        else sls_sales
    end as sls_sales,
    sls_quantity,
    case 
        when sls_price is null or sls_price <= 0 
        then sls_sales / nullif(sls_quantity, 0)
        else sls_price
    end as sls_price
from bronze.crm_sales_details;
