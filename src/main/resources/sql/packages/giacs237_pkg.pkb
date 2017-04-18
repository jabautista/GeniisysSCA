CREATE OR REPLACE PACKAGE BODY CPI.GIACS237_PKG AS
    FUNCTION get_fund_cd_lov
      RETURN fund_cd_lov_tab PIPELINED
    IS
      v_list fund_cd_lov_type;
    BEGIN 
      FOR i IN(SELECT fund_cd, fund_desc 
                 FROM giis_funds 
             ORDER BY fund_cd)
      LOOP
        v_list.fund_cd := i.fund_cd;
        v_list.fund_desc := i.fund_desc;
        PIPE ROW(v_list);
      END LOOP;
      RETURN;         
    END get_fund_cd_lov; 
    
    FUNCTION get_branch_cd_lov(
       p_fund_cd VARCHAR2,
       p_user_id VARCHAR2
    )
      RETURN branch_cd_lov_tab PIPELINED
    IS
        v_list branch_cd_lov_type;
    BEGIN
        FOR i IN(SELECT branch_cd, branch_name 
                    FROM giac_branches 
                 WHERE gfun_fund_cd = NVL(p_fund_cd, gfun_fund_cd)
                 AND check_user_per_iss_cd_acctg2(NULL, branch_cd, 'GIACS237', p_user_id) = 1)
        LOOP
            v_list.branch_cd := i.branch_cd;
            v_list.branch_name := i.branch_name;
            PIPE ROW(v_list);
        END LOOP;       
          RETURN;
     END get_branch_cd_lov; 
     
     
     FUNCTION get_dv_status (
        p_fund_cd       giis_funds.fund_cd%TYPE,
        p_branch_cd     giac_branches.branch_cd%TYPE,
        p_dv_flag       VARCHAR2
     )
        RETURN acc_dv_status_tab PIPELINED
     IS
        v_list acc_dv_status_type;
    BEGIN
        FOR i IN(SELECT a.gacc_tran_id, b.document_cd, b.branch_cd, b.line_cd, b.doc_year,
                        b.doc_mm, b.doc_seq_no, a.gibr_gfun_fund_cd, a.gibr_branch_cd,
                        a.gprq_ref_id, a.particulars, a.dv_flag, a.payee, a.dv_no, a.dv_tag,
                        a.dv_pref, a.user_id, a.last_update, a.print_tag, a.dv_date, a.ref_no,
                        a.payee_no, c.rv_meaning, d.check_no, d.check_pref_suf, d.check_date
                   FROM giac_disb_vouchers a,
                        giac_payt_requests b,
                        cg_ref_codes c,
                        giac_chk_disbursement d
                  WHERE 1 = 1
                    AND a.gprq_ref_id = b.ref_id
                    AND rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG'
                    AND rv_low_value = a.dv_flag
                    AND a.gacc_tran_id = d.gacc_tran_id(+)
                    AND a.gibr_gfun_fund_cd = p_fund_cd
                    AND a.gibr_branch_cd = p_branch_cd
                    AND a.dv_flag = NVL(p_dv_flag, a.dv_flag)
               ORDER BY a.last_update DESC, a.dv_flag) -- bonok :: 2.1.2016 :: UCPB SR 21526
                    
          LOOP
          v_list.gacc_tran_id   := i.gacc_tran_id;
          v_list.dv_date        :=  i.dv_date;
          v_list.dv_pref        := i.dv_pref;
          v_list.dv_no          := i.dv_no;
          v_list.chk_date       := i.check_date;
          v_list.req_no         := i.document_cd|| '-' || i.branch_cd|| '-' || i.line_cd || '-' || i.doc_year|| '-' || i.doc_mm|| '-' || i.doc_seq_no;
          v_list.check_pref_suf := i.check_pref_suf;
          v_list.check_no       := i.check_no;
          --v_list.chk_no         := i.CHECK_PREF_SUF|| '-' || i.CHECK_NO; 
          v_list.particulars    := i.particulars;
          v_list.user_id        := i.user_id;
          v_list.last_update    := TO_CHAR (i.last_update, 'mm-dd-yyyy HH:MI:ss AM');
          v_list.status         := i.rv_meaning; 
          v_list.payee          := i.payee;
                 
          PIPE ROW (v_list);
       END LOOP;
       RETURN;
    END get_dv_status;
    
    FUNCTION get_status_history (
      p_gacc_tran_id VARCHAR2
    )
      RETURN status_history_tab PIPELINED 
    IS
      v_list status_history_type;
    BEGIN
      FOR i IN(SELECT a.gacc_tran_id, a.dv_flag, a.user_id, a.last_update, b.rv_meaning
                 FROM giac_dv_stat_hist a, cg_ref_codes b
                WHERE b.rv_low_value = a.dv_flag
                  AND b.rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG'
                  AND a.gacc_tran_id = p_gacc_tran_id)
      LOOP
        v_list.dv_flag := i.dv_flag;
        v_list.user_id := i.user_id;
        v_list.last_update := TO_CHAR (i.last_update, 'mm-dd-yyyy HH:MI:ss AM');
        v_list.rv_meaning := i.rv_meaning;
      
        PIPE ROW(v_list);
      END LOOP;                    
    END get_status_history;  
    
END;
/
