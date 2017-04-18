CREATE OR REPLACE PACKAGE BODY CPI.GIACS322_PKG
AS
   FUNCTION get_rec_list(
       p_fund_cd    VARCHAR2,
       p_branch_cd  VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
      SELECT    a.fund_cd, a.branch_cd, a.doc_name, a.doc_seq_no, a.doc_pref_suf, a.approved_series, a.remarks, a.user_id, a.last_update 
                  FROM giac_doc_sequence a
                 WHERE a.fund_cd = p_fund_cd
                   AND a.branch_cd = p_branch_cd
                 ORDER BY a.doc_name
                   )                   
      LOOP
         v_rec.fund_cd        := i.fund_cd;     
         v_rec.branch_cd      := i.branch_cd;
         v_rec.doc_name       := i.doc_name;    
         v_rec.doc_seq_no     := i.doc_seq_no;  
         v_rec.doc_pref_suf   := i.doc_pref_suf;
         v_rec.approved_series   := i.approved_series;
         v_rec.remarks        := i.remarks;
         v_rec.user_id        := i.user_id;
         v_rec.last_update    := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec GIAC_DOC_SEQUENCE%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIAC_DOC_SEQUENCE
         USING DUAL
         ON (fund_cd    = p_rec.fund_cd  
         AND branch_cd  = p_rec.branch_cd
         AND doc_name   = p_rec.doc_name) 
         WHEN NOT MATCHED THEN
            INSERT (fund_cd, branch_cd ,doc_name,doc_seq_no, doc_pref_suf, approved_series, remarks, user_id, last_update)
            VALUES (p_rec.fund_cd, p_rec.branch_cd, p_rec.doc_name, p_rec.doc_seq_no, p_rec.doc_pref_suf, p_rec.approved_series,  p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET doc_seq_no = p_rec.doc_seq_no, doc_pref_suf = p_rec.doc_pref_suf, approved_series =  p_rec.approved_series,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
                    p_fund_cd    GIAC_DOC_SEQUENCE.fund_cd%TYPE, 
                    p_branch_cd  GIAC_DOC_SEQUENCE.branch_cd%TYPE,
                    p_doc_name   GIAC_DOC_SEQUENCE.doc_name%TYPE
   )
   AS
   BEGIN
      DELETE FROM GIAC_DOC_SEQUENCE
            WHERE fund_cd    = p_fund_cd  
              AND branch_cd  = p_branch_cd
              AND doc_name   = p_doc_name;
   END;

   FUNCTION val_del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
        /*FOR a IN (
              SELECT 1
                FROM gicl_clm_loss_exp
               WHERE item_stat_cd = p_le_stat_cd
        )
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN (v_exists);*/
        RETURN NULL;
   END;

   FUNCTION val_add_rec (
            p_fund_cd    GIAC_DOC_SEQUENCE.fund_cd%TYPE,          
            p_branch_cd  GIAC_DOC_SEQUENCE.branch_cd%TYPE,
            p_doc_name   GIAC_DOC_SEQUENCE.doc_name%TYPE
   )
   RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIAC_DOC_SEQUENCE
                 WHERE fund_cd    = p_fund_cd  
                   AND branch_cd  = p_branch_cd
                   AND doc_name   = p_doc_name
               )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      /*IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same Code.'
                                 );
      END IF;*/
      
      RETURN (v_exists);
   END;
   
   FUNCTION get_giacs322_company_lov(
        p_search        VARCHAR2
   )
    RETURN giacs322_company_lov_tab PIPELINED
   IS
        v_list giacs322_company_lov_type;
   BEGIN
        FOR i IN (
              SELECT DISTINCT GFUN_FUND_CD fund_cd 
                FROM GIAC_BRANCHES
               WHERE GFUN_FUND_CD LIKE p_search
               ORDER BY GFUN_FUND_CD
        )
        LOOP
            v_list.fund_cd   := i.fund_cd;  
          
            SELECT fund_desc
              INTO v_list.fund_desc 
              FROM GIIS_FUNDS
             WHERE fund_cd = i.fund_cd;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs322_branch_lov(
        p_fund_cd       VARCHAR2,
        p_search        VARCHAR2,
        p_user          VARCHAR2
   )
    RETURN giacs322_branch_lov_tab PIPELINED
   IS
        v_list giacs322_branch_lov_type;
   BEGIN
        FOR i IN (
               SELECT branch_cd, branch_name
                  FROM GIAC_BRANCHES
                 WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,branch_cd, 'GIACS322', p_user),1,branch_cd,NULL)
                   AND gfun_fund_cd = p_fund_cd
                   and branch_cd LIKE p_search
        )
        LOOP
            v_list.branch_cd   := i.branch_cd;  
            v_list.branch_name := i.branch_name;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
END;
/


