DROP PROCEDURE CPI.UPDATE_PENDING_CLAIMS;

CREATE OR REPLACE PROCEDURE CPI.Update_Pending_Claims(
	   	  p_line_cd			GIPI_WPOLBAS.line_cd%TYPE,
		  p_subline_cd		GIPI_WPOLBAS.subline_cd%TYPE,
		  p_iss_cd			GIPI_WPOLBAS.iss_cd%TYPE,
		  p_issue_yy		GIPI_WPOLBAS.issue_yy%TYPE,
		  p_pol_seq_no		GIPI_WPOLBAS.pol_seq_no%TYPE,
		  p_renew_no		GIPI_WPOLBAS.renew_no%TYPE,
		  p_eff_date		GIPI_WPOLBAS.eff_date%TYPE 
		  )
   IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : update_pending_claims program unit
  */
  	FOR d IN (SELECT a.claim_id
                FROM GICL_CLAIMS a
               WHERE 1=1
                 AND a.line_cd        = p_line_cd
                 AND a.subline_cd     = p_subline_cd
                 AND a.pol_iss_cd     = p_iss_cd 
                 AND a.issue_yy       = p_issue_yy 
                 AND a.pol_seq_no     = p_pol_seq_no
                 AND a.renew_no       = p_renew_no
                 AND TRUNC(a.dsp_loss_date) >= TRUNC(p_eff_date)) --added TRUNC by jdiago 08.04.2014
  	LOOP
  		UPDATE GICL_CLAIMS
  	     SET refresh_sw = 'Y'
  	   WHERE claim_id   = d.claim_id;
  	END LOOP;	              
END;
/


