CREATE OR REPLACE PACKAGE BODY CPI.GIADD01A_PKG
AS 
FUNCTION get_payt_request(
          p_tran_id       GIAC_ACCT_ENTRIES.GACC_GFUN_FUND_CD%Type
     )
     
     RETURN get_giadd01a_payt_request_tab PIPELINED
     IS    
            v_list get_giadd01a_type;
         
     BEGIN
     
          
      FOR i IN (
        SELECT *
          FROM    
                (SELECT to_char(request_date,'fmMonth DD, RRRR') request_date,
                        tran_id ,
                        payee,
                        payt_amt , 
                        particulars  ,
                        ltrim(rtrim(document_cd||'-'||branch_cd||decode(line_cd,null, null, '-'||line_cd)||
                            '-'||doc_year||'-'||LPAD(doc_mm,2,'0')||'-'||to_char(doc_seq_no)))  request_no,
                        gou.ouc_name,
                        gprq.create_by,
                        GRQD.currency_cd
                   FROM giac_payt_requests GPRQ , 
                        giac_payt_requests_dtl GRQD, 
                        giac_oucs gou
                  WHERE gprq.ref_id = grqd.gprq_ref_id
                    and tran_id = p_tran_id
                    and gou.ouc_id = gprq.GOUC_OUC_ID) A, 
                (SELECT a.gacc_tran_id,
                        a.acct_entry_id,
                        a.gl_acct_id ,
                        c.gl_acct_sname,
                        UPPER(b.sl_name) sl_name,
                        RTRIM(LTRIM(a.gl_acct_category||'-'||
                          a.gl_control_acct||'-'||
                          a.gl_sub_acct_1||'-'||
                          a.gl_sub_acct_2||'-'||
                          a.gl_sub_acct_3||'-'||
                          a.gl_sub_acct_4||'-'||
                          a.gl_sub_acct_5||'-'||
                          a.gl_sub_acct_6||'-'||
                          a.gl_sub_acct_7)) acct_code,
                        NVL(a.credit_amt,0) credit,
                        NVL(a.debit_amt,0)  debit,
                        NVL(a.debit_amt,0) - NVL(a.credit_amt,0) deb_cre
                   FROM giac_acct_entries a, giac_sl_lists b, giac_chart_of_accts c
                  WHERE a.sl_cd = b.sl_cd(+)
                   and  c.gl_acct_id  = a.gl_acct_id
                    AND a.sl_type_cd = b.sl_type_cd(+)
                    and a.gacc_tran_id = p_tran_id
               ORDER BY debit desc, acct_entry_id ) B)
              
        LOOP
               v_list.request_date             :=  i.request_date;
                v_list.tran_id                  :=  i.tran_id;
                v_list.payee                    :=  i.payee;
                v_list.payt_amt                 :=  i.payt_amt;          
                v_list.particulars              :=  i.particulars;
                v_list.request_no               :=  i.request_no;
                v_list.ouc_name                 :=  i.ouc_name;
                v_list.create_by                :=  i.create_by;
                v_list.currency_cd              :=  i.currency_cd;
                v_list.gacc_tran_id             :=  i.gacc_tran_id;
                v_list.acct_entry_id            :=  i.acct_entry_id;
                v_list.gl_acct_id               :=  i.gl_acct_id;
                v_list.sl_name                  :=  i.sl_name;
                v_list.acct_code                :=  i.acct_code;
                v_list.credit                   :=  i.credit;
                v_list.debit                    :=  i.debit;
                v_list.deb_cre                 :=  i.deb_cre;
                v_list.gl_acct_sname           :=  i.gl_acct_sname;  
                v_list.rsic_logo           := giisp.v ('LOGO_FILE');
              
              select param_value_v company_address
                into v_list.company_address
                from giis_parameters
               WHERE param_name = 'COMPANY_ADDRESS';
                
              SELECT  param_value_v as company_name
                INTO  v_list.company_name  
                FROM  GIIS_PARAMETERS
               WHERE param_name like 'COMPANY_NAME';
               
               
               begin
                    SELECT UPPER (signatory) signatory
                    INTO v_list.treasurer_name
                    FROM giis_signatory_names
                    WHERE UPPER (designation) LIKE '%TREASURER%'
                    AND status = 1;
    
               EXCEPTION
                WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                v_list.treasurer_name := '__________________________________';
               end;
                         
               
        PIPE ROW (v_list);        
        END LOOP;  
         
    
      RETURN;        
    END;
    
 FUNCTION get_op_signatory(
          p_report_id     GIIS_REPORTS.REPORT_ID%Type,
          p_branch_cd     GIAC_DOCUMENTS.BRANCH_CD%Type,
          p_document_cd   GIAC_DOCUMENTS.DOCUMENT_CD%Type,
          p_create_by     GIIS_USERS.USER_ID%Type
     )
     
     RETURN get_giadd01a_op_signatory_tab PIPELINED
     IS    
            v_list get_giadd01a_op_signatory_type;
         
     BEGIN
        FOR i in (
             SELECT 
                   (SELECT REPORT_NO 
                       FROM GIAC_DOCUMENTS 
                              WHERE REPORT_ID = NVL(p_report_id,' ') 
                                AND BRANCH_CD = NVL(p_branch_cd,' ')
                                AND DOCUMENT_CD = NVL(p_document_cd,' ')) "REPORT_NO", 
                             0 "ITEM_NO" , 
               'Prepared By: ' "LABEL", 
                   B.USER_NAME "SIGNATORY",
                   designation, 
                           ' ' "BRANCH_CD", 
                           ' ' "DOCUMENT_CD"
             FROM GIAC_USERS A, GIIS_USERS B
            WHERE A.USER_ID (+) = B.USER_ID 
              AND NVL(A.USER_ID, B.USER_ID) = UPPER(p_create_by)
            UNION
                (
                SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation, a.branch_cd, a.document_cd
                  FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c 
                 WHERE a.report_no = b.report_no
                   AND a.report_id = b.report_id 
                   AND a.report_id = p_report_id
                   AND NVL(a.document_cd,p_document_cd) = p_document_cd
                   AND NVL(a.branch_cd,p_branch_cd) = p_branch_cd
                   AND b.signatory_id = c.signatory_id   
                   --AND UPPER(b.label) LIKE '%APPROVED BY%'
                   AND UPPER(b.label) NOT LIKE '%VERIFIED BY%'
             MINUS
                SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation, a.branch_cd, a.document_cd
                  FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND a.report_id = b.report_id
                   AND a.report_id = p_report_id
                   AND a.document_cd IS NULL 
                   AND EXISTS (SELECT 1 
                                 FROM giac_documents
                                WHERE report_id = p_report_id
                                  AND document_cd = p_document_cd)  
                  AND b.signatory_id = c.signatory_id
             MINUS   
                SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation, a.branch_cd, a.document_cd
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
                )
             UNION
                SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation, branch_cd, document_cd
                  FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND a.report_id = b.report_id
                   AND a.report_id = p_report_id
                   AND a.branch_cd = p_branch_cd 
                   AND ((a.document_cd = p_document_cd AND a.branch_cd IS NULL) 
                   OR (a.branch_cd = p_branch_cd AND a.document_cd IS NULL))
                   AND b.signatory_id = c.signatory_id   
                   AND UPPER(b.label) LIKE '%APPROVED BY%'
                   AND UPPER(b.label) NOT LIKE '%VERIFIED BY%'
                ORDER BY 2
        )
        
        Loop
                v_list.report_no               :=  i.report_no;
                v_list.item_no                 :=  i.item_no;
                v_list.c_label                 :=  i.label;
                v_list.signatory               :=  i.signatory;
                v_list.designation             :=  i.designation;
                v_list.branch_cd               :=  i.branch_cd;
                v_list.document_cd             :=  i.document_cd;
            PIPE ROW (v_list);  
        End loop;
        
     END;
   FUNCTION get_ap_signatory(
          p_report_id     GIIS_REPORTS.REPORT_ID%Type,
          p_branch_cd     GIAC_DOCUMENTS.BRANCH_CD%Type,
          p_document_cd   GIAC_DOCUMENTS.DOCUMENT_CD%Type
     )
     
     RETURN get_giadd01a_ap_signatory_tab PIPELINED
     IS    
            v_list get_giadd01a_ap_signatory_type;  
            
       BEGIN
            FOR i in   
            (
                      (SELECT a.report_no     "D_REPORT_NO", 
                        b.item_no       "D_ITEM_NO", 
                        b.label         "D_LABEL", 
                        c.signatory     "D_SIGNATORY", 
                        c.designation   "D_DESIGNATION", 
                        a.branch_cd     "D_BRANCH_CD", 
                        a.document_cd   "D_DOCUMENTATION_CD"
                   FROM giac_documents a,
                        giac_rep_signatory b, 
                        giis_signatory_names c 
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id 
                    AND a.report_id = p_report_id
                    AND b.signatory_id = c.signatory_id   
                     AND NVL(a.document_cd,NVL(p_document_cd,'_')) = NVL(p_document_cd,'_')
               AND NVL(a.branch_cd,NVL(p_branch_cd,'_')) = NVL(p_branch_cd,'_')
                    AND UPPER(b.label) NOT LIKE '%CHECKED BY%'
                    AND UPPER(b.label) LIKE '%VERIFIED BY%'
                    MINUS
                SELECT a.report_no,
                       b.item_no, 
                       b.label, 
                       c.signatory, 
                       c.designation, 
                       a.branch_cd, 
                       a.document_cd
                 FROM giac_documents a,
                      giac_rep_signatory b,
                      giis_signatory_names c
                WHERE a.report_no = b.report_no
                  AND a.report_id = b.report_id
                  AND a.report_id = p_report_id
                  AND a.document_cd IS NULL 
                  AND EXISTS (SELECT 1 
                                FROM giac_documents
                               WHERE report_id = p_report_id
                                 AND document_cd = p_document_cd)  
                  AND b.signatory_id = c.signatory_id
            MINUS   
                SELECT a.report_no,
                       b.item_no,
                       b.label,
                       c.signatory,
                       c.designation,
                       a.branch_cd,
                       a.document_cd
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND a.report_id = b.report_id
                   AND a.report_id = p_report_id
                   AND a.branch_cd IS NULL 
                   AND EXISTS (SELECT 1 
                                 FROM giac_documents
                                WHERE report_id = p_report_id
                                  AND branch_cd = p_branch_cd)  
                 AND b.signatory_id = c.signatory_id )
                  UNION
                SELECT a.report_no     "D_REPORT_NO", 
                       b.item_no       "D_ITEM_NO", 
                       b.label         "D_LABEL", 
                       c.signatory     "D_SIGNATORY", 
                       c.designation   "D_DESIGNATION", 
                       a.branch_cd     "D_BRANCH_CD", 
                       a.document_cd   "D_DOCUMENTATION_CD"
                  FROM  giac_documents a,
                        giac_rep_signatory b,
                        giis_signatory_names c
                WHERE a.report_no = b.report_no
                  AND a.report_id = b.report_id
                  AND a.report_id = p_report_id
                  AND a.branch_cd = p_branch_cd 
                  AND ((a.document_cd = p_document_cd AND a.branch_cd IS NULL) 
                   OR (a.branch_cd = p_branch_cd AND a.document_cd IS NULL))
                  AND b.signatory_id = c.signatory_id   
                  AND UPPER(b.label) NOT LIKE '%APPROVED BY%'
                  AND UPPER(b.label) LIKE '%REVIEWED BY%'
                  ORDER BY 2
         )
            loop
                    v_list.d_report_no             :=  i.d_report_no;
                    v_list.d_item_no               :=  i.d_item_no;
                    v_list.d_label                 :=  i.d_label;
                    v_list.d_signatory             :=  i.d_signatory;
                    v_list.d_designation           :=  i.d_designation;
                    v_list.d_branch_cd             :=  i.d_branch_cd;
                    v_list.d_documentation_cd      :=  i.d_documentation_cd; 
            
                PIPE ROW (v_list); 
            end loop;
        end;
            
END;
/


