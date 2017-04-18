DROP PROCEDURE CPI.COPY_POL_WBANK_SCHED;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wbank_sched(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
    v_renew_no    GIPI_WPOLBAS.RENEW_NO%TYPE;
    v_eff_date    GIPI_WPOLBAS.EFF_DATE%TYPE;
    v_issue_yy    GIPI_WPOLBAS.ISSUE_YY%TYPE;
    v_line_cd     GIPI_WPOLBAS.LINE_CD%TYPE;
    v_subline_cd  GIPI_WPOLBAS.SUBLINE_CD%TYPE;
    v_pol_seq_no  GIPI_WPOLBAS.POL_SEQ_NO%TYPE;
    v_endt_seq_no GIPI_WPOLBAS.ENDT_SEQ_NO%TYPE;
    v_iss_cd      GIPI_WPOLBAS.ISS_CD%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wbank_sched program unit
  */
  
  FOR pol IN (
     SELECT line_cd,subline_cd,iss_cd,endt_seq_no,
            renew_no,eff_date,issue_yy,pol_seq_no
       FROM GIPI_POLBASIC
      WHERE policy_id = p_policy_id)
  LOOP
    v_renew_no    := pol.renew_no;
    v_eff_date    := pol.eff_date;
    v_issue_yy    := pol.issue_yy;
    v_line_cd     := pol.line_cd;
    v_subline_cd  := pol.subline_cd;
    v_pol_seq_no  := pol.pol_seq_no;
    v_endt_seq_no := pol.endt_seq_no;
    v_iss_cd      := pol.iss_cd;
  END LOOP;

 -- :gauge.FILE := 'passing copy policy BANK SCHEDULE';
 -- vbx_counter;
  BEGIN
  INSERT INTO GIPI_BANK_SCHEDULE
               (policy_id,     bank_item_no,  bank_line_cd,    bank_subline_cd,
                bank_iss_cd,   bank_issue_yy, bank_pol_seq_no, bank_endt_seq_no,
                bank_renew_no, bank_eff_date, bank,bank_address,
                cash_in_vault,cash_in_transit,include_tag) 
       SELECT p_policy_id,bank_item_no,  v_line_cd,    v_subline_cd,
              v_iss_cd,   v_issue_yy, v_pol_seq_no, 0,
              v_renew_no, v_eff_date, bank,bank_address,
                cash_in_vault,cash_in_transit,include_tag
         FROM GIPI_WBANK_SCHEDULE
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;  
END;
/


