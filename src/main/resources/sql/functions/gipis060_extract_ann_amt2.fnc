DROP FUNCTION CPI.GIPIS060_EXTRACT_ANN_AMT2;

CREATE OR REPLACE FUNCTION CPI.GIPIS060_EXTRACT_ANN_AMT2 (
	   	  		  		    p_par_id     gipi_wpolbas.par_id%TYPE,
	   	  		  		    p_item       gipi_witem.item_no%TYPE,
                            p_ann_prem1  IN OUT gipi_witem.ann_prem_amt%TYPE,
                            p_ann_tsi1   IN OUT gipi_witem.ann_tsi_amt%TYPE)
RETURN VARCHAR2
IS
  v_comp_prem     gipi_witmperl.ann_prem_amt%TYPE := 0; 
  v_prorate       NUMBER;
BEGIN

	p_ann_prem1 := 0;
	p_ann_tsi1 := 0;
	
	FOR b540 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
			 	   FROM gipi_wpolbas
				  WHERE par_id = p_par_id)
	LOOP
	  FOR A2 IN
	      ( SELECT A.tsi_amt tsi,       A.prem_amt  prem,       
	               B.eff_date,          B.endt_expiry_date,    B.expiry_date,
	               B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
	               B.short_rt_percent   short_rt,
	               A.peril_cd
	          FROM GIPI_ITMPERIL A,
	               GIPI_POLBASIC B
	         WHERE B.line_cd      =  b540.line_cd
	           AND B.subline_cd   =  b540.subline_cd
	           AND B.iss_cd       =  b540.iss_cd
	           AND B.issue_yy     =  b540.issue_yy
	           AND B.pol_seq_no   =  b540.pol_seq_no
	           AND B.renew_no     =  b540.renew_no
	           AND B.policy_id    =  A.policy_id
	           AND A.item_no      =  p_item
	           AND B.pol_flag     in('1','2','3','X') 
			   AND TRUNC(NVL(b.endt_expiry_date,b.expiry_date)) >= TRUNC(b540.eff_date)
			   AND TRUNC(b.eff_date) <= DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date),TRUNC(b540.eff_date))
	         ORDER BY      b.eff_date DESC) LOOP
	      v_comp_prem := 0;
	      IF A2.prorate_flag = 1 THEN
	         IF A2.endt_expiry_date <= A2.eff_date THEN
	            RETURN 'Your endorsement expiry date is equal to or less than your effectivity date.'||
	                      ' Restricted condition.';
	         ELSE
	            IF A2.comp_sw = 'Y' THEN
	               v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
	                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
	            ELSIF A2.comp_sw = 'M' THEN
	               v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
	                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
	            ELSE 
	               v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
	                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
	            END IF;
	         END IF;
		       IF TRUNC(A2.eff_date) = TRUNC(A2.endt_expiry_date) THEN
		       	  v_prorate := 1;
		       END IF;	  
	         v_comp_prem  := A2.prem/v_prorate;
	      ELSIF A2.prorate_flag = 2 THEN
	         v_comp_prem  :=  A2.prem;
	      ELSE
	         v_comp_prem :=  A2.prem/(A2.short_rt/100);  
	      END IF;
	      p_ann_prem1 := p_ann_prem1 + v_comp_prem;
	      FOR TYPE IN
	          ( SELECT peril_type
	              FROM giis_peril
	             WHERE line_cd = b540.line_cd
	               AND peril_cd = A2.peril_cd
	          ) LOOP
	          IF type.peril_type = 'B' THEN            
	             p_ann_tsi1  := p_ann_tsi1  + A2.tsi;
	          END IF;
	     END LOOP;
	    END LOOP;
	END LOOP;
	
	RETURN 'SUCCESS';       
END;
/


