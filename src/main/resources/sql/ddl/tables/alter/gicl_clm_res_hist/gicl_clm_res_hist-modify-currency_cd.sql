SET serveroutput ON

DECLARE 
    v_count         NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GICL_CLM_RES_HIST'
       AND UPPER(column_name) = 'CURRENCY_CD'
       AND UPPER(nullable) = 'N'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.gicl_clm_res_hist MODIFY currency_cd NUMBER (2) NOT NULL');
        dbms_output.put_line('CURRENCY_CD successfully set to NOT NULLABLE.');
    ELSE
        dbms_output.put_line('CURRENCY_CD is already set to NOT NULLABLE.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;