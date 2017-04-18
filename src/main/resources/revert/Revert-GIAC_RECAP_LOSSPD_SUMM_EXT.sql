DECLARE
   v_tab_exists     NUMBER          := 0;
   v_tab_name       VARCHAR2 (1000) := 'giac_recap_losspd_summ_ext';   
BEGIN
  SELECT 1
    INTO v_tab_exists
    FROM all_tables
   WHERE table_name = UPPER(v_tab_name) AND owner = 'CPI';
   
   EXECUTE IMMEDIATE('ALTER TABLE giac_recap_losspd_summ_ext
                      DROP (ret_os_loss_cy     ,
                      ret_os_exp_cy       ,
                      ret_os_loss_py      ,
                      ret_os_exp_py       );');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
    DBMS_OUTPUT.put_line ('Table is not existing');
END;