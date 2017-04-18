DROP FUNCTION CPI.GET_UNREN_PREM;

CREATE OR REPLACE FUNCTION CPI.get_unren_prem (p_endt_seq_no NUMBER,
                                           p_old_pol_id  NUMBER)
RETURN NUMBER AS
--p_endt_seq_no NUMBER; --commented out by MJ 05/07/2013
--p_old_pol_id  NUMBER; --commented out by MJ 05/07/2013
p_ret_val     NUMBER;
BEGIN
  IF (p_endt_seq_no = 0 AND p_old_pol_id IS NOT NULL) AND
     (p_endt_seq_no <> 0 AND p_old_pol_id IS NULL) THEN
     p_ret_val := 0;
     RETURN p_ret_val;
  ELSIF
     (p_endt_seq_no = 0 AND p_old_pol_id IS NULL) THEN
     p_ret_val := 1;
     RETURN p_ret_val;
  END IF;
END;
/


