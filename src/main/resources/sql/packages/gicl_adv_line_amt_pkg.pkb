CREATE OR REPLACE PACKAGE BODY CPI.gicl_adv_line_amt_pkg
AS
   FUNCTION get_range_to (
      p_user_id   giis_users.user_id%TYPE,
      p_line_cd   gicl_adv_line_amt.line_cd%TYPE,
      p_iss_cd    gicl_adv_line_amt.iss_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_range_to   gicl_adv_line_amt.range_to%TYPE;
   BEGIN
      SELECT range_to
        INTO v_range_to
        FROM gicl_adv_line_amt
       WHERE adv_user = p_user_id AND line_cd = p_line_cd AND iss_cd = p_iss_cd;

      RETURN v_range_to;
   END;
END;
/


