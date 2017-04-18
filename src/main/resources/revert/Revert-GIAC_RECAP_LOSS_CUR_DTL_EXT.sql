DECLARE
   v_tab_exists     NUMBER          := 0;
   v_tab_name       VARCHAR2 (1000) := 'GIAC_RECAP_LOSS_CUR_DTL_EXT';   
BEGIN
  SELECT 1
    INTO v_tab_exists
    FROM all_tables
   WHERE table_name = v_tab_name AND owner = 'CPI';
   
   EXECUTE IMMEDIATE('DROP TABLE cpi.GIAC_RECAP_LOSS_CUR_DTL_EXT CASCADE CONSTRAINTS');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
    DBMS_OUTPUT.put_line ('Table is not existing');
END;