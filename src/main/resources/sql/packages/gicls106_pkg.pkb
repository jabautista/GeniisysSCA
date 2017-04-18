CREATE OR REPLACE PACKAGE BODY CPI.GICLS106_PKG
AS
   FUNCTION get_rec_list(
       p_tax_cd    VARCHAR2,
       p_branch_cd  VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
              SELECT loss_tax_id, tax_type, branch_cd,
                     tax_cd, tax_name, tax_rate, start_date, end_date, 
                     sl_type_cd, gl_acct_id,
                     remarks, user_id, last_update
                FROM giis_loss_taxes
               WHERE tax_type = p_tax_cd
                 AND branch_cd = p_branch_cd
                   )                   
      LOOP
         v_rec.loss_tax_id    := i.loss_tax_id;
         v_rec.tax_type       := i.tax_type;   
         v_rec.branch_cd      := i.branch_cd;  
         v_rec.tax_cd         := i.tax_cd;     
         v_rec.tax_name       := i.tax_name;   
         v_rec.tax_rate       := i.tax_rate;   
         v_rec.start_date     := i.start_date; 
         v_rec.end_date       := i.end_date; 
         v_rec.sl_type_cd     := i.sl_type_cd;
         v_rec.gl_acct_id     := i.gl_acct_id;   
         v_rec.remarks        := i.remarks;
         v_rec.user_id        := i.user_id;
         v_rec.last_update    := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         FOR j IN (
                SELECT gl_acct_name,gl_acct_category,gl_control_acct,
                       gl_sub_acct_1,gl_sub_acct_2,gl_sub_acct_3,gl_sub_acct_4,
                       gl_sub_acct_5,gl_sub_acct_6,gl_sub_acct_7
                  FROM giac_chart_of_accts
                 WHERE gl_acct_id = i.gl_acct_id
         ) 
         LOOP
             v_rec.gl_acct_name       := j.gl_acct_name;     
             v_rec.gl_acct_category   := j.gl_acct_category; 
             v_rec.gl_control_acct    := j.gl_control_acct;  
             v_rec.gl_sub_acct_1      := j.gl_sub_acct_1;   
             v_rec.gl_sub_acct_2      := j.gl_sub_acct_2;   
             v_rec.gl_sub_acct_3      := j.gl_sub_acct_3;   
             v_rec.gl_sub_acct_4      := j.gl_sub_acct_4;   
             v_rec.gl_sub_acct_5      := j.gl_sub_acct_5;   
             v_rec.gl_sub_acct_6      := j.gl_sub_acct_6;   
             v_rec.gl_sub_acct_7      := j.gl_sub_acct_7;   
         END LOOP;
         
         FOR j IN (
                SELECT sl_type_name
                  FROM giac_sl_types
                 WHERE sl_type_cd = i.sl_type_cd
         )
         LOOP
            v_rec.sl_type_name     := j.sl_type_name;  
         END LOOP;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_loss_taxes%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_loss_taxes
         USING DUAL
         ON (loss_tax_id = p_rec.loss_tax_id) 
         --WHEN NOT MATCHED THEN
           -- INSERT (fund_cd, branch_cd ,doc_name,doc_seq_no, doc_pref_suf, approved_series, remarks, user_id, last_update)
            --VALUES (p_rec.fund_cd, p_rec.branch_cd, p_rec.doc_name, p_rec.doc_seq_no, p_rec.doc_pref_suf, p_rec.approved_series,  p_rec.remarks,
                    --p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE 
               SET tax_rate = p_rec.tax_rate, start_date = p_rec.start_date, end_date =  p_rec.end_date,
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
   
   FUNCTION get_gicls106_tax_lov(
        p_search VARCHAR2
   )
    RETURN gicls106_tax_lov_tab PIPELINED
   IS
        v_list gicls106_tax_lov_type;
   BEGIN
        FOR i IN (
               SELECT rv_low_value, rv_meaning 
                 FROM cg_ref_codes
                WHERE rv_domain = 'GIIS_LOSS_TAXES.TAX_TYPE'
                  AND rv_low_value LIKE p_search
        )
        LOOP
            v_list.rv_low_value   := i.rv_low_value;  
            v_list.rv_meaning     := UPPER(i.rv_meaning);
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_gicls106_branch_lov(
        p_search VARCHAR2,
        p_user   VARCHAR2
   )
    RETURN gicls106_branch_lov_tab PIPELINED
   IS
        v_list gicls106_branch_lov_type;
   BEGIN
        FOR i IN (
              SELECT a.iss_cd, a.iss_name
                FROM giis_issource a
               WHERE iss_cd LIKE p_search
                 AND check_user_per_iss_cd2(null, iss_cd, 'GICLS106', p_user) = 1
               ORDER BY a.iss_cd
        )
        LOOP
            v_list.iss_cd   := i.iss_cd;  
            v_list.iss_name := i.iss_name;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   
   PROCEDURE validate_tax(
        p_tax_type   IN OUT VARCHAR2,
        p_tax_desc      OUT VARCHAR2
   )
   IS
   BEGIN
       SELECT rv_low_value, UPPER(rv_meaning) 
         INTO p_tax_type, p_tax_desc
         FROM cg_ref_codes
        WHERE rv_domain = 'GIIS_LOSS_TAXES.TAX_TYPE'
          AND UPPER(rv_low_value) LIKE UPPER(p_tax_type);
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_tax_type := 'manyrows';
           p_tax_desc := 'manyrows';
       WHEN OTHERS THEN
           p_tax_type := NULL;
           p_tax_desc := NULL;
   END;
   
   PROCEDURE validate_branch(
        p_branch   IN OUT VARCHAR2,
        p_branch_name OUT VARCHAR2,
        p_user     IN     VARCHAR2
   )
   IS
   BEGIN
       SELECT iss_cd, iss_name
         INTO p_branch, p_branch_name 
         FROM giis_issource
        WHERE UPPER(iss_cd) LIKE UPPER(p_branch)
          AND check_user_per_iss_cd2(null,iss_cd,'GICLS106',p_user) = 1;
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_branch := 'manyrows';
           p_branch_name := 'manyrows';
       WHEN OTHERS THEN
           p_branch := NULL;
           p_branch_name := NULL;
   END;
   
   
   FUNCTION get_tax_rate_history(
        p_loss_tax_id   VARCHAR2
   )
   RETURN tax_rate_history_tab PIPELINED
   IS
        v_list tax_rate_history_type;
   BEGIN
        FOR i IN (
               SELECT start_date, end_date, tax_rate, user_id, last_update 
                 FROM giis_loss_tax_hist
                WHERE loss_tax_id = p_loss_tax_id
        )
        LOOP
            v_list.tax_rate      := i.tax_rate;    
            v_list.start_date    := i.start_date;  
            v_list.end_date      := i.end_date;
            v_list.user_id       := i.user_id;     
            v_list.last_update    := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_copy_tax(
        p_iss_cd   VARCHAR2,
        p_user     VARCHAR2
   )
   RETURN copy_tax_tab PIPELINED
   IS
        v_list copy_tax_type;
   BEGIN
        FOR i IN (
               SELECT iss_cd, iss_name
                 FROM giis_issource
                WHERE iss_cd != p_iss_cd
                  AND check_user_per_iss_cd2(null, iss_cd, 'GICLS106', p_user) = 1
                ORDER BY iss_cd
        )
        LOOP
            v_list.iss_cd   := i.iss_cd;  
            v_list.iss_name := i.iss_name;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
    
   PROCEDURE copy_tax_to_issue_cd (p_rec giis_loss_taxes%ROWTYPE)
   IS
        v_loss_tax_id NUMBER;
   BEGIN 
       SELECT MAX(loss_tax_id)+1
         INTO v_loss_tax_id
         FROM giis_loss_taxes;
         
       INSERT INTO giis_loss_taxes (loss_tax_id, tax_type, tax_cd, tax_name, branch_cd, tax_rate, start_date, end_date, gl_acct_id, sl_type_cd, remarks, user_id, last_update)
       VALUES (v_loss_tax_id, p_rec.tax_type, p_rec.tax_cd, p_rec.tax_name, p_rec.branch_cd, p_rec.tax_rate, p_rec.start_date, p_rec.end_date, 
               p_rec.gl_acct_id, p_rec.sl_type_cd, p_rec.remarks, p_rec.user_id, SYSDATE);
   END;
   
   PROCEDURE validate_loss_taxes(
        p_tax_cd   IN VARCHAR2,
        p_iss_cd   IN VARCHAR2,
        p_tax_type IN VARCHAR2,
        p_output  OUT VARCHAR2
   )
   IS
   BEGIN
       p_output := '1';
       FOR i IN(
            SELECT '*'
              FROM giis_loss_taxes
             WHERE tax_cd = p_tax_cd
               AND branch_cd = p_iss_cd
               AND tax_type = p_tax_type
       )
       LOOP
        p_output := 'exist';
        EXIT;
       END LOOP;
   END;
   
   FUNCTION line_loss_exp(
        p_iss_cd        VARCHAR2,
        p_loss_tax_id   VARCHAR2,
        p_user          VARCHAR2
   )
   RETURN line_loss_exp_tab PIPELINED
   IS
        v_list line_loss_exp_type;
   BEGIN
        FOR i IN (
               SELECT line_cd, loss_exp_cd, loss_exp_type, tax_rate
                 FROM giis_loss_tax_line
                WHERE loss_tax_id = p_loss_tax_id
                  AND check_user_per_line2(line_cd, p_iss_cd, 'GICLS106',p_user) = 1 
        )
        LOOP
            v_list.line_cd       := i.line_cd;        
            v_list.loss_exp_cd   := i.loss_exp_cd;    
            v_list.loss_exp_type := i.loss_exp_type;
            v_list.tax_rate      := i.tax_rate;
            
            FOR j IN (
               SELECT line_name
                 FROM giis_line
                WHERE line_cd = i.line_cd
            )
            LOOP
                v_list.line   := i.line_cd || ' - ' || j.line_name;
                v_list.line_name := j.line_name;
            END LOOP;
            
            IF i.loss_exp_cd = '00' THEN
                v_list.loss_exp   := i.loss_exp_cd || ' - ' || UPPER('All Losses/Expenses') ;
                v_list.loss_exp_desc := UPPER('All Losses/Expenses');
            ELSE
                FOR j IN (
                   SELECT loss_exp_desc
                     FROM giis_loss_exp 
                    WHERE line_cd = i.line_cd
                      AND loss_exp_cd = i.loss_exp_cd
                      AND loss_exp_type = i.loss_exp_type
                )
                LOOP
                    v_list.loss_exp   := i.loss_exp_cd || ' - ' || j.loss_exp_desc;
                    v_list.loss_exp_desc := j.loss_exp_desc;
                END LOOP;
            END IF;
            
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_gicls106_line_lov(
        p_search VARCHAR2,
        p_user   VARCHAR2,
        p_iss_cd VARCHAR2
   )
    RETURN gicls106_line_lov_tab PIPELINED
   IS
        v_list gicls106_line_lov_type;
   BEGIN
        FOR i IN (
              SELECT a.line_cd, a.line_name
                FROM giis_line a
               WHERE line_cd LIKE p_search
                 AND check_user_per_line2(line_cd, p_iss_cd, 'GICLS106', p_user)=1
               ORDER BY a.line_cd
        )
        LOOP
            v_list.line_cd   := i.line_cd;  
            v_list.line_name := i.line_name;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_gicls106_loss_exp_lov(
      p_line_cd     VARCHAR2,
      p_search VARCHAR2
   )
    RETURN gicls106_loss_exp_lov_tab PIPELINED
   IS
        v_list gicls106_loss_exp_lov_type;
   BEGIN
        FOR i IN (
              SELECT loss_exp_cd, loss_exp_desc, loss_exp_type
                FROM giis_loss_exp
               WHERE line_cd = p_line_cd
                 AND NVL(comp_sw,'0') IN ('+', '0')
               ORDER BY loss_exp_cd
        )
        LOOP
            v_list.loss_exp_cd   := i.loss_exp_cd;  
            v_list.loss_exp_desc := i.loss_exp_desc;
            v_list.loss_exp_type := i.loss_exp_type;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        v_list.loss_exp_cd   := '00';  
        v_list.loss_exp_desc := UPPER('All Losses/Expenses');
        v_list.loss_exp_type := '';
        
        PIPE ROW(v_list); 
        
        RETURN;
   END;
   
   PROCEDURE save_line_loss_exp (p_rec giis_loss_tax_line%ROWTYPE)
   IS
        v_tax_hist_no NUMBER;
        v_last_update DATE;
   BEGIN
         MERGE INTO giis_loss_tax_line 
         USING DUAL
         ON (loss_tax_id = p_rec.loss_tax_id
         AND line_cd = p_rec.line_cd
         AND loss_exp_cd = p_rec.loss_exp_cd) 
             WHEN NOT MATCHED THEN
               INSERT (loss_tax_id, line_cd, loss_exp_cd, tax_rate, loss_exp_type, user_id, last_update)
                VALUES (p_rec.loss_tax_id, p_rec.line_cd, p_rec.loss_exp_cd, p_rec.tax_rate, p_rec.loss_exp_type, p_rec.user_id, SYSDATE)
             WHEN MATCHED THEN
                UPDATE 
                   SET tax_rate = p_rec.tax_rate, user_id = p_rec.user_id, last_update = SYSDATE;
   END;
   
   FUNCTION val_line_loss_exp(
            p_loss_tax_id   giis_loss_tax_line.loss_tax_id%TYPE,         
            p_line_cd       giis_loss_tax_line.line_cd%TYPE,    
            p_loss_exp_cd   giis_loss_tax_line.loss_exp_cd%TYPE 
   )
   RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_loss_tax_line
                 WHERE loss_tax_id = p_loss_tax_id
                   AND line_cd     = p_line_cd    
                   AND loss_exp_cd = p_loss_exp_cd
               )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN (v_exists);
   END;
   
   PROCEDURE validate_line(
        p_line_cd   IN OUT VARCHAR2,
        p_line_name    OUT VARCHAR2,
        p_user      IN     VARCHAR2,
        p_iss_cd    IN     VARCHAR2
   )
   IS
   BEGIN
       SELECT line_cd, line_name
         INTO p_line_cd, p_line_name
         FROM giis_line
        WHERE UPPER(p_line_cd) = line_cd
          AND check_user_per_line2(line_cd, p_iss_cd, 'GICLS106', p_user) = 1;
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_line_cd   := 'manyrows';
           p_line_name := 'manyrows';
       WHEN OTHERS THEN
           p_line_cd   := NULL;
           p_line_name := NULL;
   END;
   
   
   PROCEDURE validate_loss_exp(
        p_line_cd         IN     VARCHAR2,
        p_loss_exp_cd     IN OUT VARCHAR2,
        p_loss_exp_desc      OUT VARCHAR2,
        p_loss_exp_type      OUT VARCHAR2
   )
   IS
   BEGIN
       SELECT loss_exp_cd, loss_exp_desc, loss_exp_type
         INTO p_loss_exp_cd, p_loss_exp_desc, p_loss_exp_type
         FROM giis_loss_exp
        WHERE line_cd = UPPER(p_line_cd)
          AND NVL(comp_sw,'0') IN ('+', '0')
          AND loss_exp_cd = UPPER(p_loss_exp_cd);
          
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_loss_exp_cd   := 'manyrows';
           p_loss_exp_desc := 'manyrows';
           p_loss_exp_type := 'manyrows';
       WHEN OTHERS THEN
           IF '00' like p_loss_exp_cd THEN
                p_loss_exp_cd := '00';
                p_loss_exp_desc := UPPER('All Losses/Expenses');
                p_loss_exp_type := '';
           ELSE 
                p_loss_exp_cd   := NULL;
                p_loss_exp_desc := NULL;
                p_loss_exp_type := NULL;
           
           END IF;
   END;
   
   FUNCTION get_line_loss_exp_history(
        p_loss_tax_id   VARCHAR2,
        p_line_cd       VARCHAR2,
        p_loss_exp_cd   VARCHAR2
   )
   RETURN line_loss_exp_history_tab PIPELINED
   IS
        v_list line_loss_exp_history_type;
   BEGIN
        FOR i IN (
               SELECT line_cd, loss_exp_cd, tax_rate, user_id, last_update 
                 FROM giis_loss_tax_line_hist
                WHERE loss_tax_id = p_loss_tax_id
                  AND line_cd     = p_line_cd
                  AND loss_exp_cd = p_loss_exp_cd
        )
        LOOP
            v_list.line_cd       := i.line_cd;
            v_list.loss_exp_cd   := i.loss_exp_cd;   
            v_list.tax_rate      := i.tax_rate;    
            v_list.user_id       := i.user_id;     
            v_list.last_update   := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            FOR j IN (
                    SELECT line_name
                      FROM giis_line
                     WHERE line_cd = i.line_cd
                     )
            LOOP
                v_list.line_name := j.line_name;
            END LOOP;
            
            IF i.loss_exp_cd = '00' THEN
                v_list.loss_exp_desc := 'ALL LOSSES/EXPENSES';
            ELSE
                FOR j IN (
                        SELECT loss_exp_desc
                          FROM giis_loss_exp
                         WHERE loss_exp_cd = i.loss_exp_cd
                         )
                LOOP
                    v_list.loss_exp_desc := j.loss_exp_desc;
                END LOOP;
            END IF;                
                
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   
   PROCEDURE copy_tax_line_to_issue_cd (p_rec giis_loss_taxes%ROWTYPE, p_orig_iss_cd VARCHAR2)
   IS
        v_loss_tax_id NUMBER;
        v_loss_id     NUMBER;
   BEGIN 
       SELECT MAX(loss_tax_id)+1
         INTO v_loss_tax_id
         FROM giis_loss_taxes;
         
       INSERT INTO giis_loss_taxes (loss_tax_id, tax_type, tax_cd, tax_name, branch_cd, tax_rate, start_date, end_date, gl_acct_id, sl_type_cd, remarks, user_id, last_update)
       VALUES (v_loss_tax_id, p_rec.tax_type, p_rec.tax_cd, p_rec.tax_name, p_rec.branch_cd, p_rec.tax_rate, p_rec.start_date, p_rec.end_date, 
               p_rec.gl_acct_id, p_rec.sl_type_cd, p_rec.remarks, p_rec.user_id, SYSDATE);
               
       SELECT loss_tax_id
         INTO v_loss_id
         FROM giis_loss_taxes
        WHERE tax_type = p_rec.tax_type
          AND tax_cd = p_rec.tax_cd
          AND branch_cd = p_orig_iss_cd;
          
       FOR i IN (
              SELECT line_cd, loss_exp_cd, tax_rate, loss_exp_type
                FROM giis_loss_tax_line
               WHERE loss_tax_id = v_loss_id
       )
       LOOP
            INSERT INTO giis_loss_tax_line 
                   (loss_tax_id, line_cd, loss_exp_cd, tax_rate, loss_exp_type, user_id, last_update)
            VALUES (v_loss_tax_id, i.line_cd, i.loss_exp_cd, i.tax_rate, i.loss_exp_type, p_rec.user_id, SYSDATE);
       
       END LOOP;
   END;
   
   PROCEDURE populate_line_loss_exp_field(
        p_line_cd         IN     VARCHAR2,
        p_loss_exp_cd     IN     VARCHAR2,
        p_line_name          OUT VARCHAR2,
        p_loss_exp_desc      OUT VARCHAR2
   )
   IS
   BEGIN
       SELECT line_name
         INTO p_line_name
         FROM giis_line
        WHERE line_cd = p_line_cd;
        
       SELECT loss_exp_desc
         INTO p_loss_exp_desc
         FROM giis_loss_exp 
        WHERE line_cd = UPPER(p_line_cd)
          AND NVL(comp_sw,'0') IN ('+', '0')
          AND loss_exp_cd = UPPER(p_loss_exp_cd);
          
   EXCEPTION
       WHEN OTHERS THEN
           IF '00' like p_loss_exp_cd THEN
                p_loss_exp_desc := UPPER('All Losses/Expenses');
           ELSE 
                p_loss_exp_desc := NULL;
           END IF;
   END;
   
   PROCEDURE check_copy_tax_line_btn(
        p_loss_tax_id IN VARCHAR2,
        p_iss_cd      IN VARCHAR2,
        p_user        IN VARCHAR2,
        p_output     OUT VARCHAR2
   )
   IS
   BEGIN
       p_output := '';
       FOR i IN(
            SELECT '*'
              FROM giis_loss_tax_line
             WHERE loss_tax_id = p_loss_tax_id
               AND check_user_per_iss_cd2(line_cd, p_iss_cd, 'GICLS106', p_user) = 1
       )
       LOOP
        p_output := 'exist';
        EXIT;
       END LOOP;
   END;
   
END;
/


