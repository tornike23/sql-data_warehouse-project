/*
===============================================================
This script is responsible for loading data into the tables.
Truncates and  uses COPY function to insert all data at once 
form the file.

Does not have any parameters.
===============================================================
*/



CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN

	RAISE NOTICE '=========================================';
	RAISE NOTICE 'Loading Bronze Layer';
	RAISE NOTICE '=========================================';

	RAISE NOTICE '-----------------------------------------';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '-----------------------------------------';
	
	TRUNCATE TABLE bronze.crm_cust_info;
	COPY bronze.crm_cust_info
	FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	
	TRUNCATE TABLE bronze.crm_prd_info;
	COPY bronze.crm_prd_info
	FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	
	TRUNCATE TABLE bronze.crm_sales_details;
	COPY bronze.crm_sales_details
	FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);

	RAISE NOTICE '-----------------------------------------';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '-----------------------------------------';
	
	TRUNCATE TABLE bronze.erp_loc_a101;
	COPY bronze.erp_loc_a101
	FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	
	TRUNCATE TABLE bronze.erp_cust_az12;
	COPY bronze.erp_cust_az12
	FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	COPY bronze.erp_px_cat_g1v2
	FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);

END;
$$;
