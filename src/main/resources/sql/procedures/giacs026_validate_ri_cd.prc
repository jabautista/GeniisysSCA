DROP PROCEDURE CPI.GIACS026_VALIDATE_RI_CD;

CREATE OR REPLACE PROCEDURE CPI.GIACS026_VALIDATE_RI_CD(
	   p_b140_prem_seq_no							IN     GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
	   p_inst_no									IN     GIAC_PREM_DEPOSIT.inst_no%TYPE,
	   p_assd_no  									IN OUT GIAC_PREM_DEPOSIT.assd_no%TYPE,
	   p_dsp_a150_line_cd							IN OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,	  
	   p_ri_cd										IN OUT GIAC_PREM_DEPOSIT.ri_cd%TYPE,
	   p_ri_name									IN OUT GIIS_REINSURER.ri_name%TYPE,
	   p_line_cd									IN OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
	   p_subline_cd									IN OUT GIAC_PREM_DEPOSIT.subline_cd%TYPE,
	   p_iss_cd										IN OUT GIAC_PREM_DEPOSIT.iss_cd%TYPE,
	   p_issue_yy									IN OUT GIAC_PREM_DEPOSIT.issue_yy%TYPE,
	   p_pol_seq_no									IN OUT GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
	   p_renew_no									IN OUT GIAC_PREM_DEPOSIT.renew_no%TYPE,
	   p_message									IN OUT VARCHAR2,
       p_par_line_cd                                IN OUT GIPI_PARLIST.line_cd%TYPE,
       p_par_iss_cd                                 IN OUT GIPI_PARLIST.iss_cd%TYPE,
       p_par_yy                                     IN OUT GIPI_PARLIST.par_yy%TYPE,
       p_par_seq_no                                 IN OUT GIPI_PARLIST.par_seq_no%TYPE,
       p_quote_seq_no                               IN OUT GIPI_PARLIST.quote_seq_no%TYPE
)
IS
  /*
  **  Created by   :  Emman
  **  Date Created :  08.09.2010
  **  Reference By : (GIACS026 - Premium Deposit)
  **  Description  : Executes the procedure VALIDATE_RI_CD of GIACS026 and gets the updated fields
  */ 
  v_policy_id        GIPI_POLBASIC.policy_id%TYPE;
  v_par_id           GIPI_PARLIST.par_id%TYPE;
BEGIN
  p_message := 'SUCCESS';
  
  SELECT a020_assd_no,    a150_line_cd , a180_ri_cd
   INTO p_assd_no, p_dsp_a150_line_cd, p_ri_cd
   FROM giac_aging_ri_soa_details
  WHERE prem_seq_no = p_b140_prem_seq_no
    AND inst_no = p_inst_no;

  SELECT ri_name 
    INTO p_ri_name
    FROM giis_reinsurer 
   WHERE ri_cd =p_ri_cd;

  SELECT GAGD.A150_LINE_CD  
    INTO p_dsp_a150_line_cd
    FROM GIAC_AGING_RI_SOA_DETAILS GAGD
   where gagd.a180_ri_cd = p_ri_cd
    and  GAGD.PREM_SEQ_NO  = p_b140_prem_seq_no
    and  GAGD.INST_NO   = p_inst_no;

--  MESSAGE(' p_assd_no '||to_char(p_assd_no));
--  MESSAGE(' p_assd_no '||to_char(p_assd_no));
--  MESSAGE(' p_dsp_a150_line_cd '||p_dsp_a150_line_cd );
--  MESSAGE(' p_dsp_a150_line_cd '||p_dsp_a150_line_cd );

--added by reymon 11192012
  SELECT policy_id
    INTO v_policy_id
	  FROM gipi_invoice
	 WHERE iss_cd = p_iss_cd
	   AND prem_seq_no = p_b140_prem_seq_no;

  SELECT a.line_cd, a.subline_cd, a.iss_cd,
         a.issue_yy, a.pol_seq_no, a.renew_no, a.par_id
    INTO p_line_cd, p_subline_cd , p_iss_cd ,
         p_issue_yy , p_pol_seq_no , p_renew_no, v_par_id
    FROM gipi_polbasic a
   WHERE a.policy_id = v_policy_id; --added by reymon 11192012

  --marco - 12.09.2014
  SELECT line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
    INTO p_par_line_cd, p_par_iss_cd, p_par_yy, p_par_seq_no, p_quote_seq_no
    FROM GIPI_PARLIST
   WHERE par_id = v_par_id;
   
EXCEPTION
  WHEN NO_DATA_FOUND THEN null;
  WHEN TOO_MANY_ROWS THEN 
    p_line_cd := null;
	p_subline_cd := null;
	p_iss_cd := null;
	p_issue_yy := null;
	p_pol_seq_no := null;
	p_renew_no := null;
	p_message := 'Too many Rows Found';
END;
/


