DROP FUNCTION CPI.CHECK_BACK_ENDT_BEFORE_DELETE;

CREATE OR REPLACE FUNCTION CPI.CHECK_BACK_ENDT_BEFORE_DELETE (
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
   
  FOR A2 IN(SELECT policy_id, a.endt_iss_cd||'-'||to_char(a.endt_yy,'09')||to_char(a.endt_seq_no,'099999') endt_no
                 FROM gipi_polbasic a
                WHERE a.line_cd     =  v_line_cd
                  AND a.iss_cd      =  v_iss_cd
                  AND a.subline_cd  =  v_subline_cd
                  AND a.issue_yy    =  v_issue_yy
                  AND a.pol_seq_no  =  v_pol_seq_no
                  AND a.renew_no    =  v_renew_no
                  AND a.pol_flag    IN( '1','2','3','X')
                  AND a.eff_date >  v_eff_date
                  AND NVL(a.endt_expiry_date,a.expiry_date) >=  v_eff_date
              ORDER BY eff_date)
     LOOP     
       FOR A3 IN (SELECT line_cd, peril_cd
                    FROM gipi_itmperil b
                   WHERE policy_id = a2.policy_id
                     AND b.item_no = p_item_no
                     AND (b.prem_amt <> 0 OR
                          b.tsi_amt  <> 0))
       LOOP
     	   FOR B IN (SELECT peril_name
     	               FROM giis_peril
     	              WHERE line_cd = a3.line_cd
     	                AND peril_cd = a3.peril_cd)
     	   LOOP             
           RETURN 'Deletion of this peril is not allowed because this is a '||
                     'backward endorsement and there is an existing '||
                     'affecting endorsement for peril ' ||LTRIM(RTRIM(b.peril_name))||
                     ' in Endt No. '||a2.endt_no;
     	   END LOOP;      
       END LOOP;
  END LOOP;   
  
  RETURN 'SUCCESS';
END;
/


