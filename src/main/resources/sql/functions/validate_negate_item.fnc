DROP FUNCTION CPI.VALIDATE_NEGATE_ITEM;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_NEGATE_ITEM (
	p_par_id	  GIPI_WPOLBAS.par_id%TYPE,
	p_item_no	  GIPI_WITEM.item_no%TYPE
	) RETURN VARCHAR2
IS
  v_line_cd			 GIPI_WPOLBAS.line_cd%TYPE;
  v_iss_cd			 GIPI_WPOLBAS.iss_cd%TYPE;
  v_subline_cd		 GIPI_WPOLBAS.subline_cd%TYPE;
  v_issue_yy		 GIPI_WPOLBAS.issue_yy%TYPE;
  v_pol_seq_no		 GIPI_WPOLBAS.pol_seq_no%TYPE;
  v_renew_no		 GIPI_WPOLBAS.renew_no%TYPE;
  v_eff_date		 GIPI_WPOLBAS.eff_date%TYPE;
BEGIN
  SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no, eff_date
    INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date
    FROM GIPI_WPOLBAS
   WHERE par_id = p_par_id;
   
  FOR A IN (SELECT b.ann_tsi_amt, b.ann_prem_amt
               FROM gipi_item b,gipi_polbasic a
              WHERE a.line_cd     =  v_line_cd
                AND a.iss_cd      =  v_iss_cd
                AND a.subline_cd  =  v_subline_cd
                AND a.issue_yy    =  v_issue_yy
                AND a.pol_seq_no  =  v_pol_seq_no
                AND a.renew_no    =  v_renew_no
                AND a.pol_flag    IN( '1','2','3','X')
                AND TRUNC(a.eff_date) <= TRUNC(v_eff_date)
                AND NVL(a.endt_expiry_date,a.expiry_date) >=  v_eff_date
                AND a.policy_id = b.policy_id
                AND b.item_no = p_item_no
           ORDER BY a.eff_date desc)
  LOOP
  	IF A.ann_tsi_amt = 0 AND A.ann_prem_amt = 0 THEN
  		 RETURN 'This item had already been negated or zero out on previous endorsement.';
  	END IF;
  END LOOP;
  
  RETURN 'SUCCESS';
END;
/


