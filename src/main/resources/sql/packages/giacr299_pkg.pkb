CREATE OR REPLACE PACKAGE BODY CPI.GIACR299_PKG
AS
   /*
   **  Created by        : bonok
   **  Date Created      : 09.23.2013
   **  Reference By      : GIACR299 - PAID POLICIES W/ FACULTATIVE
   */
   FUNCTION get_giacr299_details(
      p_line_cd               giis_line.line_cd%TYPE,
      p_bop                   NUMBER,
      p_branch_cd             giis_issource.iss_cd%TYPE,
      p_cut_off_param         NUMBER,
      p_from_date             VARCHAR2,
      p_to_date               VARCHAR2,
      p_tran_flag             giac_acctrans.tran_flag%TYPE, --Added by Jerome Bautista 10.16.2015 SR 3892
      p_user_id               giis_users.user_id%TYPE
   ) RETURN giacr299_tab PIPELINED AS
      res                     giacr299_type;
      v_no_details            VARCHAR2(1) := 'Y';
   BEGIN
      FOR i IN(SELECT get_policy_no(d.policy_id) policy_no, b.line_cd||'-'||binder_yy||'-'||binder_seq_no binder_no,
                      get_ri_name(b.ri_cd) reinsurer, c.ref_no, c.tran_date, e.iss_name, f.line_name
                 FROM gipi_invoice a,
                      giri_frps_outfacul_prem_v b,
                      giac_premium_colln_v c,
                      gipi_polbasic d,
                      giis_issource e,
                      giis_line f,
                      giac_acctrans g --Added by Jerome Bautista 10.16.2015 SR 3892
                WHERE a.policy_id = b.policy_id
                  AND a.policy_id = d.policy_id
                  AND a.iss_cd = c.iss_cd
                  and a.iss_cd = e.iss_cd
                  and b.line_cd = f.line_cd
                  AND a.prem_seq_no = c.prem_seq_no
                  AND c.tran_id = g.tran_id --Added by Jerome Bautista 10.16.2015 SR 3892
                  AND g.tran_flag NOT IN (p_tran_flag) --Added by Jerome Bautista 10.23.2015 SR 3892
                  AND b.line_cd = NVL(p_line_cd, d.line_cd)
                  AND DECODE(p_bop, '1', b.cred_branch, b.iss_cd) = NVL(p_branch_cd, d.iss_cd)
                  AND DECODE(p_cut_off_param, '1', c.posting_date, c.tran_date) 
                      BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                  AND B.balance > 0
                  AND check_user_per_iss_cd2(NULL, d.iss_cd, 'GIACS299', p_user_id) = 1
                ORDER BY DECODE(p_bop, '1', b.cred_branch, b.iss_cd), b.line_cd, policy_no, binder_No)
      LOOP
         res.policy_no := i.policy_no;
         res.binder_no := i.binder_no;
         res.reinsurer := i.reinsurer;
         res.ref_no := i.ref_no;
         res.tran_date := i.tran_date;
         res.iss_name := i.iss_name;
         res.line_name := i.line_name;
         
         res.company_name := giacp.v('COMPANY_NAME');
         res.company_address := giacp.v('COMPANY_ADDRESS');
         
         IF p_cut_off_param = '1' THEN
  		      res.cut_off_param := 'Posting Date';
         ELSE 
  	         res.cut_off_param := 'Transaction Date';
         END IF;
         
         res.date_label := 'From  '||TO_CHAR(TO_DATE(p_from_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR') ||'  To  '|| TO_CHAR(TO_DATE(p_to_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
         
         v_no_details := 'N';
         PIPE ROW(res);
      END LOOP;
      
      IF v_no_details = 'Y' THEN
         res.company_name := giacp.v('COMPANY_NAME');
         res.company_address := giacp.v('COMPANY_ADDRESS');
         
         IF p_cut_off_param = '1' THEN
  		      res.cut_off_param := 'Posting Date';
         ELSE 
  	         res.cut_off_param := 'Transaction Date';
         END IF;
         
         res.date_label := 'From  '||TO_CHAR(TO_DATE(p_from_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR') ||'  To  '|| TO_CHAR(TO_DATE(p_to_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
         
         res.iss_name := ' ';
         res.line_name := ' ';
         
         PIPE ROW(res);
      END IF;
   END;

END GIACR299_PKG;
/


