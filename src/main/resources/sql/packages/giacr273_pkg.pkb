CREATE OR REPLACE PACKAGE BODY CPI.giacr273_pkg
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 06.25.2013
    **  Reference By : GIACR273_PKG - Disbursement List
    */
   
   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR i IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_company_name := i.param_value_v;
         EXIT;
      END LOOP;

      RETURN (v_company_name);
   END;

   FUNCTION cf_1formula
      RETURN CHAR
   IS
      v_company_address   giac_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_company_address := ' ';
      END;

      RETURN (v_company_address);
   END;
   
    
    -- modified by shan 01.13.2014
   FUNCTION cf_dateformula (p_trunc_date VARCHAR2)
      RETURN VARCHAR2
   IS
      --p_trunc_date   VARCHAR2 (100);
   BEGIN
      IF p_trunc_date = 'P' THEN
         RETURN ('Posting Date');
      ELSE
         RETURN ('Tran Date');
      END IF;

      RETURN NULL;
   END;
   

   FUNCTION get_giacr273_records_1 (p_branch VARCHAR2, p_doc_cd VARCHAR2, p_date1 DATE, p_date2 DATE, p_trunc_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr273_record_tab PIPELINED
   IS
      v_list   giacr273_record_type;
   BEGIN
      FOR i IN (SELECT      d.gl_acct_category
                         || '-'
                         || d.gl_control_acct
                         || '-'
                         || d.gl_sub_acct_1
                         || '-'
                         || d.gl_sub_acct_2
                         || '-'
                         || d.gl_sub_acct_3
                         || '-'
                         || d.gl_sub_acct_4
                         || '-'
                         || d.gl_sub_acct_5
                         || '-'
                         || d.gl_sub_acct_6
                         || '-'
                         || d.gl_sub_acct_7 gl_accnt_no,
                         a.gl_acct_name, SUM (NVL (d.debit_amt, 0)) d_debit, SUM (NVL (d.credit_amt, 0)) d_credit, c.branch_cd branch_cd_one, c.document_cd document_cd_one
                    FROM giac_acct_entries d, giac_chart_of_accts a, giac_disb_vouchers b, giac_payt_requests c, giac_acctrans e
                   WHERE d.gl_acct_id = a.gl_acct_id
                     AND b.req_dtl_no = 1
                     AND b.gacc_tran_id = d.gacc_tran_id
                    -- AND b.dv_flag = 'P' -- as per maam juday, all DV should be included regardless of status : shan 11.18.2014
                     AND c.ref_id = b.gprq_ref_id
                     AND b.gacc_tran_id = e.tran_id
                     AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
                     AND c.document_cd = NVL (p_doc_cd, c.document_cd)
                    -- AND e.tran_flag IN ('C', 'P') -- as per maam juday, all DV should be included regardless of status : shan 11.18.2014
                     AND (   (TRUNC (e.tran_date) BETWEEN NVL (p_date1, e.tran_date) AND NVL (p_date2, e.tran_date) AND (p_trunc_date = 'T'))
                          OR (TRUNC (e.posting_date) BETWEEN NVL (p_date1, e.posting_date) AND NVL (p_date2, e.posting_date) AND (p_trunc_date = 'P'))
                         )
                     AND check_user_per_iss_cd_acctg2 (NULL, b.gibr_branch_cd, 'GIACS273', p_user_id) = 1   --added p_user_id shan 01.13.2014
                /*added by Ladz 05272013 for security access*/
                GROUP BY    d.gl_acct_category
                         || '-'
                         || d.gl_control_acct
                         || '-'
                         || d.gl_sub_acct_1
                         || '-'
                         || d.gl_sub_acct_2
                         || '-'
                         || d.gl_sub_acct_3
                         || '-'
                         || d.gl_sub_acct_4
                         || '-'
                         || d.gl_sub_acct_5
                         || '-'
                         || d.gl_sub_acct_6
                         || '-'
                         || d.gl_sub_acct_7,
                         a.gl_acct_name,
                         branch_cd,
                         document_cd
                ORDER BY branch_cd_one, document_cd_one, gl_accnt_no)
      LOOP
         v_list.gl_accnt_no := i.gl_accnt_no;
         v_list.account_name := i.gl_acct_name;
         v_list.d_debit := i.d_debit;
         v_list.d_credit := i.d_credit;
         v_list.branch_cd_one := i.branch_cd_one;
         v_list.document_cd_one := i.document_cd_one;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr273_records_1;
   
    
    -- edited by shan 01.13.2014
    FUNCTION get_giacr273_records (p_branch VARCHAR2, p_doc_cd VARCHAR2, p_date1 DATE, p_date2 DATE, p_trunc_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr273_record_tab PIPELINED
    IS
      v_list    giacr273_record_type;
      v_print   BOOLEAN := false;
    BEGIN      
        v_list.fdate := cf_dateformula(p_trunc_date);
        v_list.address := cf_1formula;
        v_list.company_name := cf_company_nameformula;
        
        FOR i IN (SELECT f.branch_name, a.gacc_tran_id, a.dv_date, a.dv_no, a.dv_pref || '-' || dv_no dv_ref_no,
                         DECODE (a.ref_no, NULL, a.dv_pref || '-' || TO_CHAR (a.dv_no), a.ref_no, a.dv_pref || '-' || a.dv_no || '/' || a.ref_no) AS dv_dec_ref_no, 
                         a.dv_amt, a.payee, c.branch_cd,  c.document_cd,
                         d.gl_acct_category
                         || '-'
                         || d.gl_control_acct
                         || '-'
                         || d.gl_sub_acct_1
                         || '-'
                         || d.gl_sub_acct_2
                         || '-'
                         || d.gl_sub_acct_3
                         || '-'
                         || d.gl_sub_acct_4
                         || '-'
                         || d.gl_sub_acct_5
                         || '-'
                         || d.gl_sub_acct_6
                         || '-'
                         || d.gl_sub_acct_7 gl_acct,
                         e.gl_acct_sname, d.debit_amt, d.credit_amt, a.DV_FLAG,
                         a.gibr_gfun_fund_cd   --Dren Niebres 05.04.2016 SR-5225
                    FROM giac_payt_requests c, giac_disb_vouchers a, giac_acctrans b, giac_acct_entries d, giac_chart_of_accts e, giac_branches f
                   WHERE 1 = 1
                     AND a.req_dtl_no = 1
                     AND f.branch_cd = c.branch_cd                                                                                                                         /* for optimization purpose*/
                     AND d.gl_acct_id = e.gl_acct_id
                     AND c.ref_id = a.gprq_ref_id
                     AND a.gacc_tran_id = b.tran_id
                     AND b.tran_id = d.gacc_tran_id
                    /* AND a.dv_flag = 'P'
                     AND b.tran_flag IN ('C', 'P')*/ -- as per maam juday, all DV should be included regardless of status : shan 11.18.2014
                     AND a.gibr_gfun_fund_cd = f.gfun_fund_cd
                     AND a.gibr_branch_cd = f.branch_cd
                     AND a.gibr_branch_cd = NVL (p_branch, a.gibr_branch_cd)
                     AND c.document_cd = NVL (p_doc_cd, c.document_cd)
                     AND (   (TRUNC (b.tran_date) BETWEEN NVL (p_date1, b.tran_date) AND NVL (p_date2, b.tran_date) AND (p_trunc_date = 'T'))
                          OR (TRUNC (b.posting_date) BETWEEN NVL (p_date1, b.posting_date) AND NVL (p_date2, b.posting_date) AND (p_trunc_date = 'P'))
                         )
                     AND check_user_per_iss_cd_acctg2 (NULL, a.gibr_branch_cd, 'GIACS273', p_user_id) = 1   -- added p_user_id shan 01.13.2014
                ORDER BY /*f.branch_name,*/ c.branch_cd, c.document_cd, a.dv_no, a.ref_no ASC)
        LOOP
             v_print        := TRUE;
             v_list.print_details   := 'Y';
             v_list.branch_name := i.branch_name;
             /*v_list.fdate := cf_dateformula;      
             v_list.address := cf_1formula;
             v_list.company_name := cf_company_nameformula;*/
             v_list.gacc_tran_id := i.gacc_tran_id;
             v_list.dv_date := i.dv_date;
             v_list.dv_no := i.dv_no;
             v_list.dv_ref_no := i.dv_ref_no;
             v_list.dv_dec_ref_no := i.dv_dec_ref_no;
             v_list.dv_amt := i.dv_amt;
             v_list.payee := i.payee;
             v_list.branch_cd := i.branch_cd;
             v_list.document_cd := i.document_cd;
             v_list.gl_acct := i.gl_acct;
             v_list.gl_acct_sname := i.gl_acct_sname;
             v_list.debit_amt := i.debit_amt;
             v_list.credit_amt := i.credit_amt;
             v_list.dv_flag := i.dv_flag;
             v_list.company_fund_cd := i.gibr_gfun_fund_cd;  --Dren Niebres 05.04.2016 SR-5225
             
             FOR j IN (SELECT *
                         FROM cg_ref_codes
                        WHERE rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG'
                          AND rv_low_value = i.dv_flag)
             LOOP
                v_list.dv_status := j.rv_meaning;
             END LOOP;
             
             PIPE ROW (v_list);
        END LOOP;
      
        IF v_print = FALSE THEN
            v_list.print_details := 'N';
            PIPE ROW (v_list);
        END IF;

        RETURN;
    END get_giacr273_records;
END;
/
