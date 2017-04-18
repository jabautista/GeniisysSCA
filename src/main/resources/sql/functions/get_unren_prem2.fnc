DROP FUNCTION CPI.GET_UNREN_PREM2;

CREATE OR REPLACE FUNCTION CPI.get_unren_prem2 (p_endt_seq_no NUMBER,
                                            p_old_pol_id  NUMBER,
										    p_pol_id      NUMBER)
RETURN NUMBER AS
v_endt_seq_no NUMBER;
v_old_pol_id  NUMBER;
v_pol_id	  NUMBER;
v_ret_val     NUMBER;
BEGIN
  IF (p_endt_seq_no = 0 AND p_old_pol_id = v_pol_id) THEN
     v_ret_val := 0;
     RETURN v_ret_val;
  ELSIF
     (p_endt_seq_no = 0 AND p_old_pol_id <> v_pol_id) THEN
     v_ret_val := 1;
     RETURN v_ret_val;
  ELSIF
     (p_endt_seq_no <> 0 AND p_old_pol_id <> v_pol_id) THEN
	 v_ret_val := 0;
  ELSE
     v_ret_val := 0;
  END IF;
END;
/


