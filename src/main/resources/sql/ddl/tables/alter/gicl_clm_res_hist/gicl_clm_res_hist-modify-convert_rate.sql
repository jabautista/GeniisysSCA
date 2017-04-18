SET serveroutput ON

DECLARE 
    v_count         NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GICL_CLM_RES_HIST'
       AND UPPER(column_name) = 'CONVERT_RATE'
       AND UPPER(nullable) = 'N'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.gicl_clm_res_hist MODIFY convert_rate NUMBER (12,9) NOT NULL');
        dbms_output.put_line('CONVERT_RATE successfully set to NOT NULLABLE.');
    ELSE
        dbms_output.put_line('CONVERT_RATE is already set to NOT NULLABLE.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;