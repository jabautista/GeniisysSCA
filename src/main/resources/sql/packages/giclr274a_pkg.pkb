CREATE OR REPLACE PACKAGE BODY CPI.giclr274a_pkg
AS
/*
** Created By: Bonok
** Date Created: 05.20.2013
** Reference By: GICLR274A
** Description: CLAIM LISTING PER PACKAGE POLICY
*/
   FUNCTION get_giclr274a_detail(
      p_line_cd             gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_pack_polbasic.subline_cd%TYPE,
      p_pol_iss_cd          gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy            gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_pack_polbasic.renew_no%TYPE,      
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_as_of_date          VARCHAR2,
      p_from_ldate          VARCHAR2,
      p_to_ldate            VARCHAR2,
      p_as_of_ldate         VARCHAR2
   ) RETURN giclr274a_detail_tab PIPELINED IS
      res                   giclr274a_detail_type;                
   BEGIN
      FOR i IN (SELECT c.line_cd||'-'||c.subline_cd||'-'||c.iss_cd||'-'||ltrim(to_char(c.issue_yy,'09'))||'-'||ltrim(to_char(c.pol_seq_no,'0999999'))
                       ||'-'||ltrim(to_char(c.renew_no,'09')) package_policy_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||ltrim(to_char(a.issue_yy,'09'))||'-'||ltrim(to_char(a.pol_seq_no,'0999999'))
                       ||'-'||ltrim(to_char(a.renew_no,'09')) policy_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||ltrim(to_char(a.clm_yy,'09'))||'-'||ltrim(to_char(a.clm_seq_no,'0999999')) claim_no, 
                       a.assd_no, a.assured_name, a.dsp_loss_date, a.clm_file_date, b.clm_stat_desc,
                       NVL(a.loss_res_amt,0) loss_res_amt, NVL(a.exp_res_amt,0) exp_res_amt, 
                       NVL(a.loss_pd_amt,0) loss_pd_amt, NVL(a.exp_pd_amt,0) exp_pd_amt
                  FROM gicl_claims a, giis_clm_stat b, gipi_pack_polbasic c
                 WHERE a.clm_stat_cd = b.clm_stat_cd
                   AND a.pack_policy_id = c.pack_policy_id
                   AND c.line_cd = UPPER(p_line_cd)
                   AND c.subline_cd = UPPER(p_subline_cd)
                   AND a.pol_iss_cd = UPPER(p_pol_iss_cd)
                   AND c.issue_yy = p_issue_yy
                   AND c.pol_seq_no = p_pol_seq_no
                   AND c.renew_no = p_renew_no
                   AND check_user_per_line(c.line_cd, c.iss_cd, 'GICLS274') = 1
                   AND ((TRUNC(a.clm_file_date) >= TO_DATE(p_from_date, 'mm-dd-yyyy')
                         AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date, 'mm-dd-yyyy')
                          OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date, 'mm-dd-yyyy'))
                         OR (TRUNC(a.loss_date) >= TO_DATE(p_from_ldate, 'mm-dd-yyyy')
                             AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate, 'mm-dd-yyyy')
                              OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate, 'mm-dd-yyyy'))))
      LOOP
         res.package_policy_no := i.package_policy_no; 
         res.policy_no         := i.policy_no;
         res.claim_no          := i.claim_no;
         res.assd_no           := i.assd_no;
         res.assured_name      := i.assured_name;
         res.dsp_loss_date     := i.dsp_loss_date;
         res.clm_file_date     := i.clm_file_date;
         res.clm_stat_desc     := i.clm_stat_desc;
         res.loss_res_amt      := i.loss_res_amt;
         res.exp_res_amt       := i.exp_res_amt;
         res.loss_pd_amt       := i.loss_pd_amt;
         res.exp_pd_amt        := i.exp_pd_amt;
         
         res.company_name      := giisp.v('COMPANY_NAME');
         res.company_address   := giisp.v('COMPANY_ADDRESS');
         
         BEGIN
  	        IF p_as_of_date IS NOT NULL THEN
		       res.date_type := 'Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
	        ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
		       res.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
	        ELSIF p_as_of_ldate IS NOT NULL THEN	
	           res.date_type := 'Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
	        ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
		       res.date_type := 'Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate, 'mm-dd-yyyy'), 'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
	        END IF;
         END;
         
         PIPE ROW(res);
      END LOOP;
   END;
END giclr274a_pkg;
/


