DROP PROCEDURE CPI.PRE_COMMIT_B2_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Pre_Commit_B2_Gipis002(
	   	  p_line_cd			   IN VARCHAR2,
		  p_op_subline_cd	   IN VARCHAR2,
		  p_op_iss_cd		   IN VARCHAR2,
		  p_op_issue_yy		   IN VARCHAR2,
		  p_op_pol_seqno	   IN VARCHAR2,
		  p_op_renew_no		   IN VARCHAR2,
		  p_eff_date		   IN VARCHAR2,
		  p_expiry_date		   IN VARCHAR2,
		  p_msg_alert		   OUT VARCHAR2
	   	  )
	IS
	p_eff_date2       DATE;
	p_expiry_date2	  DATE;
	v_expiry_date	  DATE;
	v_incept_date	  DATE;
	v_expiry_date2	  DATE;
	v_incept_date2	  DATE;
	v_msg_alert		  VARCHAR2(3200);
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : to validate if expiry/effectivity date is ok
  */
	p_eff_date2		  := TO_DATE(p_eff_date,'MM-DD-YYYY');
	p_expiry_date2 	  := TO_DATE(p_expiry_date,'MM-DD-YYYY');
	
	FOR c1 IN (  SELECT TRUNC(incept_date) incept_date, 
		   	  	 		TRUNC(expiry_date) expiry_date, 
						assd_no, 
						TRUNC(eff_date) eff_date
                    FROM GIPI_POLBASIC
                   WHERE line_cd    = p_line_cd 
                     AND subline_cd = p_op_subline_cd 
                     AND iss_cd     = p_op_iss_cd
                     AND issue_yy   = p_op_issue_yy
                     AND pol_seq_no = p_op_pol_seqno
                ORDER BY eff_date DESC)
     LOOP
     	 v_expiry_date  := c1.expiry_date;
		 v_incept_date  := c1.incept_date;
         Pre_Commit_B_Gipis002(p_line_cd, p_op_subline_cd, p_op_iss_cd, p_op_issue_yy, p_op_pol_seqno, p_op_renew_no, c1.eff_date, v_expiry_date2, v_incept_date2);

       IF TRUNC(p_eff_date2) NOT BETWEEN NVL(v_incept_date2,v_incept_date) AND NVL(v_expiry_date2,v_expiry_date) THEN
          v_msg_alert := 'Effectivity date '||TO_CHAR(p_eff_date2)||' must be within '||
	            TO_CHAR(NVL(v_incept_date2,v_incept_date))||' and '||TO_CHAR(NVL(v_expiry_date2,v_expiry_date))||'.';
       ELSIF TRUNC(p_expiry_date2) NOT BETWEEN NVL(v_incept_date2,v_incept_date) AND NVL(v_expiry_date2,v_expiry_date) THEN --issa07.09.2007
       	  v_msg_alert := 'Expiry date '||TO_CHAR(p_expiry_date2)||' must be within '||
	            TO_CHAR(NVL(v_incept_date2,v_incept_date))||' and '||TO_CHAR(NVL(v_expiry_date2,v_expiry_date))||'.';
       END IF;
       EXIT;
     END LOOP;
	 p_msg_alert := NVL(v_msg_alert,'SUCCESS');
END;
/


