DROP PROCEDURE CPI.POP_GICL_24TH_TAB_MN;

CREATE OR REPLACE PROCEDURE CPI.pop_gicl_24th_tab_mn(
  p_date DATE,
  p_session_id         gicl_loss_ratio_ext.session_id%TYPE) AS
  v_date DATE := p_date;
  v_mm   gicl_24th_tab.col_mm%TYPE;
  v_month gicl_24th_tab.col_month%TYPE;
  v_factor gicl_24th_tab.factor%TYPE;
  v_fact NUMBER(2) := 11;
  ctr NUMBER(2) := 0;
BEGIN
  DELETE FROM gicl_24th_tab_mn
   WHERE user_id = USER;
  COMMIT;
   FOR k IN  0..11 LOOP
   ctr := ctr + 1;
      IF k < 2 THEN
   	  		dbms_output.put_line(TO_CHAR(ADD_MONTHS(v_date,-k),'Month')||' '||v_fact||'/'||'24');
			v_mm := TO_NUMBER(TO_CHAR(ADD_MONTHS(v_date,-k),'mm'),99);
   			v_month := TO_CHAR(ADD_MONTHS(v_date,-k),'Month');
   			v_factor := 1;
      ELSE
   	        v_mm := TO_NUMBER(TO_CHAR(ADD_MONTHS(v_date,-k),'mm'),99);
            v_month := TO_CHAR(ADD_MONTHS(v_date,-k),'Month');
            v_factor := 0;
      END IF;
   INSERT INTO gicl_24th_tab_mn(
     col_mm, col_month, factor, row_mm, session_id, user_id)
   VALUES(
     v_mm, v_month, v_factor,ctr, p_session_id, USER);
   END LOOP;
END;
/


