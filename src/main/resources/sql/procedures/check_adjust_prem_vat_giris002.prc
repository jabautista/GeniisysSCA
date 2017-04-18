DROP PROCEDURE CPI.CHECK_ADJUST_PREM_VAT_GIRIS002;

CREATE OR REPLACE PROCEDURE CPI.CHECK_ADJUST_PREM_VAT_GIRIS002(
    p_ri_cd         IN NUMBER,
    p_line_cd       IN GIPI_PARLIST.line_cd%TYPE,
    p_iss_cd        IN GIPI_PARLIST.iss_cd%TYPE,
    p_par_yy        IN GIPI_PARLIST.par_yy%TYPE,
    p_par_seq_no    IN GIPI_PARLIST.par_seq_no%TYPE,
    p_subline_cd    IN GIPI_POLBASIC.subline_cd%TYPE,
    p_renew_no      IN GIPI_POLBASIC.renew_no%TYPE,
    p_pol_seq_no    IN GIPI_POLBASIC.pol_seq_no%TYPE,
    p_issue_yy      IN GIPI_POLBASIC.issue_yy%TYPE,
    p_prem_vat      OUT NUMBER
) IS
    v_par_id      gipi_parlist.par_id%TYPE;
    v_par_status  gipi_parlist.par_status%TYPE;
    v_booking     DATE;
    v_pol_flag    gipi_polbasic.pol_flag%TYPE;
    v_prem_vat    VARCHAR2(1):='N';
BEGIN
    FOR c1 IN (SELECT par_id, par_status
               FROM gipi_parlist
              WHERE line_cd = p_line_cd	
                AND iss_cd = p_iss_cd
                AND par_yy = p_par_yy
                AND par_seq_no = p_par_seq_no)
    LOOP
        v_par_id := c1.par_id;
        v_par_status := c1.par_status;
    END LOOP;	   
    
    IF v_par_status = 10 THEN
        FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                     FROM gipi_polbasic
                    WHERE par_id = v_par_id)
        LOOP
            v_booking := TO_DATE(c1.booking_mth||'/'||c1.booking_year,'MONTH/YYYY');
            v_pol_flag := c1.pol_flag;
        END LOOP;	  	            
    ELSE
        FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                     FROM gipi_wpolbas
                    WHERE par_id = v_par_id)
        LOOP
            v_booking := TO_DATE(c1.booking_mth||'/'||c1.booking_year,'MONTH/YYYY');
            v_pol_flag := c1.pol_flag;
        END LOOP;    	
    END IF; 
    
    IF v_pol_flag = '4' THEN
  	    FOR c1 IN (SELECT policy_id
  	             FROM gipi_polbasic
  	            WHERE line_cd = p_line_cd 
  	              AND subline_cd = p_subline_cd 
  	              AND iss_cd = p_iss_cd 
  	              AND issue_yy = p_issue_yy
  	              AND pol_seq_no = p_pol_seq_no
  	              AND renew_no = p_renew_no
  	              AND endt_seq_no = 0)
        LOOP
            FOR c2 IN (SELECT 1
									 FROM GIRI_BINDER d, GIRI_FRPS_RI C, GIRI_DISTFRPS b, GIUW_POL_DIST a
									WHERE d.fnl_binder_id = C.fnl_binder_id
									  AND d.reverse_date IS NULL									  
									  AND d.ri_cd = p_ri_cd
									  AND d.ri_prem_vat IS NOT NULL
									  AND C.line_cd = b.line_cd
									  AND C.frps_yy = b.frps_yy
									  AND C.frps_seq_no = b.frps_seq_no
									  AND b.dist_no = a.dist_no
									  AND a.policy_id = c1.policy_id) 
            LOOP
                v_prem_vat := 'Y';
            END LOOP;	    		
        END LOOP;
    
        IF v_prem_vat = 'N' THEN
            p_prem_vat := 0;

        ELSIF v_prem_vat = 'Y'/* and variable.v_status = 'CHANGED' */THEN			
                p_prem_vat := 1;--variable.v_ri_prem_vat_n;	
        --    ELSIF v_prem_vat = 'Y'/* and p_prem_vat <> variable.v_ri_prem_vat_o*/ THEN		
        --        p_prem_vat := 2;--variable.v_ri_prem_vat_o;
        END IF;
    ELSE 
        /*IF variable.v_status = 'CHANGED' THEN
			p_prem_vat := variable.v_ri_prem_vat_n;

		ELSIF p_prem_vat <> variable.v_ri_prem_vat_o THEN
			p_prem_vat := variable.v_ri_prem_vat_o;
		ELSE 
			p_prem_vat := p_prem_vat;
		END IF;	*/
        p_prem_vat := 2;
    END IF;    
END CHECK_ADJUST_PREM_VAT_GIRIS002;
/


