CREATE OR REPLACE PACKAGE BODY CPI.GIACR081_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.10.2013
   **  Reference By : GIACR081 (report for GIACS081)
   */    
    FUNCTION cf_company_name
       RETURN CHAR
    IS
       comp_name VARCHAR2(1000);
    BEGIN
        SELECT param_value_v
          INTO comp_name
          FROM giis_parameters
         WHERE param_name = 'COMPANY_NAME';	 
        RETURN(comp_name);
    END cf_company_name;    

    FUNCTION cf_company_address
       RETURN CHAR
    IS
       v_add  VARCHAR2(1000);
    BEGIN
        SELECT param_value_v
          INTO v_add
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
        RETURN (v_add);
    RETURN NULL; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_add := '(NO PARAMETER COMPANY_ADDRESS IN GIIS_PARAMETERS)';
        RETURN (v_add);
        WHEN TOO_MANY_ROWS THEN
            v_add := '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
        RETURN (v_add);
    END cf_company_address;

    FUNCTION get_dv_records(
        p_replenish_id  giac_replenish_dv.replenish_id%TYPE
    )
        RETURN main_report_record_tab PIPELINED
    IS
        v_rep   main_report_record_type;
        v_exists    BOOLEAN := FALSE;   -- shan 10.09.2014
    BEGIN
        FOR q IN(SELECT a.replenish_id, a.branch_cd, TO_CHAR(a.branch_cd||'-'||a.replenish_year||'-'||a.replenish_seq_no) replenishment_no,
                        a.revolving_fund_amt, a.replenishment_amt, replenish_tran_id, dv_tran_id, c.check_pref_suf ||'-'|| c.check_no check_no,
                        b.amount, d.particulars, d.payee, d.dv_pref||'-'|| d.dv_no dv_no,
                        DECODE (line_cd, 
                                    null, f.document_cd||'-'||f.doc_year||'-'||f.doc_mm||'-'|| f.doc_seq_no,
                                    f.document_cd||'-'||f.line_cd||'-'||f.doc_year||'-'||f.doc_mm||'-'|| f.doc_seq_no) request_no,
                        c.check_date, a.replenish_year  
                   FROM GIAC_REPLENISH_DV a, 
                        GIAC_REPLENISH_DV_DTL b, 
                        GIAC_CHK_DISBURSEMENT c,
                        GIAC_DISB_VOUCHERS d,
                        GIAC_PAYT_REQUESTS_DTL e,
                        GIAC_PAYT_REQUESTS f 
                  WHERE a.replenish_id = b.replenish_id 
                    AND b.dv_tran_id = c.gacc_tran_id
                    AND c.gacc_tran_id = d.gacc_tran_id
                    AND d.gacc_tran_id = e.tran_id
                    AND e.gprq_ref_id = f.ref_id
                    AND b.CHECK_ITEM_NO = c.ITEM_NO     -- added to retrieve records in the same replenishment : shan 10.09.2014
                    AND a.replenish_id = p_replenish_id
                    AND NVL(b.include_tag,'Y') = 'Y'
               ORDER BY c.check_pref_suf ||'-'|| c.check_no)
        LOOP
            v_exists                      := TRUE;  -- shan 10.09.2014
            v_rep.print_details           := 'Y';
            v_rep.company_name            := cf_company_name;
            v_rep.company_address         := cf_company_address;
            v_rep.replenish_id            := q.replenish_id;
            v_rep.branch_cd               := q.branch_cd;
            v_rep.replenish_no            := q.replenishment_no;
            v_rep.revolving_fund_amt      := q.revolving_fund_amt;
            v_rep.replenish_tran_id       := q.replenish_tran_id;
            --v_rep.replenishment_amt       := q.replenishment_amt; -- replaced with codes below : shan 10.09.2014            
            SELECT SUM(amount)
              INTO v_rep.replenishment_amt 
              FROM giac_replenish_dv_dtl
             WHERE replenish_id = q.replenish_id
               AND include_tag = 'Y';               
            v_rep.dv_tran_id              := q.dv_tran_id;
            v_rep.check_pref_suf_check_no := q.check_no;
            v_rep.amount                  := q.amount;
            v_rep.particulars             := q.particulars;
            v_rep.payee                   := q.payee;
            v_rep.dv_pref_no              := q.dv_no;
            v_rep.request_no              := q.request_no;
            v_rep.check_date              := TO_CHAR(q.check_date, 'MM-DD-YYYY');
            v_rep.replenish_year          := q.replenish_year;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = FALSE THEN
            v_rep.company_name            := cf_company_name;
            v_rep.company_address         := cf_company_address;
            v_rep.print_details           := 'N';
            PIPE ROW(v_rep);
        END IF;
    END get_dv_records;
        
    FUNCTION get_signatory(
        p_user_id       giac_users.user_id%TYPE,
        p_report_id     giac_documents.report_id%TYPE,
        p_branch_cd     giac_replenish_dv.branch_cd%TYPE
    )
        RETURN report_detail_record_tab PIPELINED
    IS
        v_rep   report_detail_record_type;
    BEGIN
        FOR q IN(SELECT 0 item_no, 'Prepared by:' label, user_name signatory, designation, ' ' branch_cd
                   FROM giac_users
                  WHERE user_id = p_user_id
                 UNION
                 SELECT b.item_no, b.label, c.signatory, c.designation, a.branch_cd
                   FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c 
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id 
                    AND a.report_id = p_report_id
                    AND NVL(a.branch_cd,NVL(p_branch_cd,'**')) = NVL(p_branch_cd,'**')
                    AND b.signatory_id = c.signatory_id
                 MINUS
                 SELECT b.item_no, b.label, c.signatory, c.designation, a.branch_cd
                   FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id
                    AND a.report_id = p_report_id
                    AND a.branch_cd IS NULL 
                    AND EXISTS (SELECT 1 
                                  FROM giac_documents
                                 WHERE report_id = p_report_id
                                   AND branch_cd = p_branch_cd)  
                    AND b.signatory_id = c.signatory_id 
               ORDER BY item_no)
        LOOP
            v_rep.item_no     := q.item_no;
            v_rep.label       := q.label;
            v_rep.signatory   := q.signatory;
            v_rep.designation := q.designation;
            v_rep.branch_cd   := q.branch_cd;
            PIPE ROW(v_rep);
        END LOOP;
    END get_signatory;
    
END GIACR081_PKG;
/


