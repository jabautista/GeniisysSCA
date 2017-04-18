DROP FUNCTION CPI.PACK_ENDT_EXTRACT_EXPIRY;

CREATE OR REPLACE FUNCTION CPI.pack_endt_extract_expiry(
    p_line_cd       IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
    p_subline_cd    IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
    p_iss_cd        IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
    p_issue_yy      IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no    IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no      IN GIPI_PACK_WPOLBAS.renew_no%TYPE)

RETURN DATE 

AS
    /*
	**  Created by		: Veronica V. Raymundo
	**  Date Created 	: 11.16.2011
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: This function returns the latest expiry date in case there is an endorsement of expiry 
	*/
    
    v_max_eff_date      GIPI_POLBASIC.eff_date%TYPE;
    v_expiry_date       GIPI_POLBASIC.expiry_date%TYPE;
    v_max_endt_seq      GIPI_POLBASIC.endt_seq_no%TYPE;
    v_v_expiry_date	    DATE;

BEGIN
  -- first get the expiry_date of the policy
  FOR A1 in (SELECT expiry_date
              FROM GIPI_PACK_POLBASIC a 
             WHERE a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd     = p_iss_cd
               AND a.issue_yy   = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no   = p_renew_no
               AND a.pol_flag in ('1','2','3','X')
               AND NVL(a.endt_seq_no,0) = 0)
  LOOP
    v_expiry_date  := a1.expiry_date;
    -- then check and retrieve for any change of expiry in case there is 
    -- endorsement of expiry date
    FOR B1 IN (SELECT expiry_date, endt_seq_no
                 FROM gipi_pack_polbasic a
                WHERE a.line_cd    = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd     = p_iss_cd
                  AND a.issue_yy   = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no   = p_renew_no
                  AND a.pol_flag IN ('1','2','3','X')
                  AND NVL(a.endt_seq_no,0) > 0
                  AND expiry_date <> a1.expiry_date
                  AND expiry_date = endt_expiry_date
                ORDER BY a.eff_date DESC)
    LOOP
      v_expiry_date  := b1.expiry_date;
      v_max_endt_seq := b1.endt_seq_no;
      FOR B2 IN (SELECT expiry_date, endt_seq_no
                   FROM gipi_pack_polbasic a
                  WHERE a.line_cd    = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd     = p_iss_cd
                    AND a.issue_yy   = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no   = p_renew_no
                    AND a.pol_flag in ('1','2','3','X')
                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> B1.expiry_date
                    AND expiry_date = endt_expiry_date
               ORDER BY a.eff_date desc)
      LOOP
        v_expiry_date  := b2.expiry_date;
        v_max_endt_seq := b2.endt_seq_no;
        EXIT;
     END LOOP;
      --check for change in expiry using backward endt. 
      FOR C IN (SELECT expiry_date
                  FROM gipi_pack_polbasic a
                 WHERE a.line_cd    = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd     = p_iss_cd
                   AND a.issue_yy   = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no   = p_renew_no
                   AND a.pol_flag in ('1','2','3','X')
                   AND NVL(a.endt_seq_no,0) > 0
                   AND expiry_date <> a1.expiry_date
                   AND expiry_date = endt_expiry_date
                   AND nvl(a.back_stat,5) = 2
                   AND NVL(a.endt_seq_no,0) > v_max_endt_seq
              ORDER BY a.endt_seq_no desc)
      LOOP
        v_expiry_date  := c.expiry_date;
        EXIT;
      END LOOP;    
      EXIT;
    END LOOP;
  END LOOP;
  v_v_expiry_date := v_expiry_date;
  RETURN v_v_expiry_date;      
END;
/


