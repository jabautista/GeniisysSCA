DROP PROCEDURE CPI.POP_GICL_24TH_TAB;

CREATE OR REPLACE PROCEDURE CPI.pop_gicl_24th_tab(
  p_date DATE,
  p_session_id         gicl_loss_ratio_ext.session_id%TYPE) AS
  v_date DATE := p_date;
  v_mm   gicl_24th_tab.col_mm%TYPE;
  v_month gicl_24th_tab.col_month%TYPE;
  v_factor gicl_24th_tab.factor%TYPE;
  v_fact NUMBER(2) := 23;
  ctr NUMBER(2) := 0;
BEGIN
  --Delete the previous content
  DELETE FROM gicl_24th_tab
   WHERE user_id = USER;
  COMMIT;
  FOR k IN  0..11 LOOP
   ctr := ctr + 1;
   dbms_output.put_line(TO_CHAR(ADD_MONTHS(v_date,-k),'Month')||' '||v_fact||'/'||'24');
   --dbms_output.put_line(TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,-k),'mm'),99)||' '||v_fact||'/'||'24');
   v_mm := TO_NUMBER(TO_CHAR(ADD_MONTHS(v_date,-k),'mm'),99);
   v_month := TO_CHAR(ADD_MONTHS(v_date,-k),'Month');
   v_factor := v_fact/24;
   INSERT INTO gicl_24th_tab(
     col_mm, col_month, factor, row_mm, session_id, user_id)
   VALUES(
     v_mm, v_month, v_factor,ctr, p_session_id, USER);
   v_fact := v_fact - 2;
  END LOOP;
END;
/


