CREATE OR REPLACE PACKAGE BODY CPI.GIACS410_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.27.2013
     ** Referenced By:  GIACS410 - Post Entries to GL
     **/
    
    FUNCTION get_gl_no
        RETURN NUMBER
    AS
        v_gl_no   NUMBER;
    BEGIN
        SELECT param_value_n
          INTO v_gl_no
          FROM giac_parameters
         WHERE UPPER(param_name) = UPPER('GL_NO');
         
        IF v_gl_no NOT IN (1, 2) THEN
            RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#E#Parameter gl_no has an invalid value.');
        END IF;
        
        RETURN(v_gl_no);
    RETURN NULL; EXCEPTION
        WHEN no_data_found THEN
            RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#E#Parameter gl_no not found in giac_parameters.');
            RETURN NULL;
    END get_gl_no;
        
        
    FUNCTION get_finance_end
        RETURN NUMBER
    AS
        v_finance_end    NUMBER;
    BEGIN
        SELECT param_value_n
          INTO v_finance_end
          FROM giac_parameters
         WHERE UPPER(param_name) = UPPER('FINANCE_END');
  
        RETURN(v_finance_end);
    RETURN NULL; EXCEPTION
        WHEN no_data_found THEN
            RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#E#Parameter finance_end not found in giac_parameters.');
        RETURN NULL;
    END get_finance_end;
    
    
    FUNCTION get_fiscal_end
        RETURN NUMBER
    AS
        v_fiscal_end    NUMBER;
    BEGIN
        SELECT param_value_n
          INTO v_fiscal_end
          FROM giac_parameters
         WHERE UPPER(param_name) = UPPER('FISCAL_END');
  
        RETURN(v_fiscal_end);
    RETURN NULL;EXCEPTION
        WHEN no_data_found THEN
            RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#E#Parameter fiscal_end not found in giac_parameters.');
        RETURN NULL;
    END get_fiscal_end;
        
        
    FUNCTION get_tran_month_lov(
        p_tran_year     GIAC_MONTHLY_TOTALS.TRAN_YEAR%TYPE,
        p_user_id       VARCHAR2
    ) RETURN tran_month_lov_tab PIPELINED
    AS
        lov     tran_month_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT tran_mm, tran_year, post_tag, 
                         DECODE(post_tag, '1', 'Posted to Fiscal GL', 
                                          '2', 'Posted to Financial GL', 
                                          '3', 'Posted to Fiscal and Financial GLs', 
                                                  null, 'Unposted') dum_mean 
                    FROM giac_monthly_totals  
                   WHERE tran_year = p_tran_year 
                     AND close_tag is null 
                     AND check_user_per_iss_cd_acctg2(null, branch_cd, 'GIACS410', p_user_id) = 1
                   ORDER BY tran_year, tran_mm)
        LOOP
            lov.tran_mm     := i.tran_mm;
            lov.tran_year   := i.tran_year;
            lov.post_tag    := i.post_tag;
            lov.description := i.dum_mean;
            
            PIPE ROW(lov);
        END LOOP;
    END get_tran_month_lov;


    PROCEDURE is_prev_month_closed(
        p_tran_year IN NUMBER,
        p_tran_mm   IN NUMBER,
        p_post_tag  IN VARCHAR2
    )
    AS
        v_gmto_close_tag          giac_monthly_totals.close_tag%TYPE;
        v_prev_fiscal_close_tag   giac_fiscal_yr.close_tag%TYPE;
        v_prev_finance_close_tag  giac_finance_yr.close_tag%TYPE;
        v_first_month             VARCHAR2(1);
    BEGIN
        FOR c IN (SELECT NVL(close_tag, '-') close_tag
                    FROM giac_monthly_totals
                   WHERE tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                           p_tran_year)
                     AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                        (p_tran_mm - 1))) 
        LOOP
            v_gmto_close_tag := c.close_tag;
            EXIT;
        END LOOP;
        
        IF v_gmto_close_tag = '-' THEN
            IF p_post_tag = '3' THEN
                --msg_alert('Please close the previous fiscal  months first.','I', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Please close the previous fiscal  months first.');
            ELSIF p_post_tag = '1' THEN
                FOR a IN (SELECT close_tag
                            FROM giac_fiscal_yr
                           WHERE tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                                (p_tran_mm - 1))) 
                LOOP
                    v_prev_fiscal_close_tag := a.close_tag;
                    EXIT;
                END LOOP;
          
                IF v_prev_fiscal_close_tag = 'N' THEN
                    --msg_alert('Please close the previous fiscal month first.','I', TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Please close the previous fiscal month first.');
                END IF;
            ELSIF p_post_tag = '2' THEN
                FOR b IN (SELECT close_tag
                            FROM giac_finance_yr
                           WHERE tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                                (p_tran_mm - 1))) 
                LOOP
                    v_prev_finance_close_tag := b.close_tag;
                    EXIT;
                END LOOP;
            
                IF v_prev_finance_close_tag = 'N' THEN
                    --msg_alert('Please close the previous financial month first.','I', TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Please close the previous financial month first.');
                END IF;
            END IF;
        ELSIF v_gmto_close_tag IS NULL THEN
            FOR d IN (SELECT '1' wan
                        FROM giac_monthly_totals
                       WHERE TO_DATE(TO_CHAR(tran_mm, 'fm09') || TO_CHAR(tran_year), 'MMYYYY') 
                                < TO_DATE(TO_CHAR(p_tran_mm, 'fm09') || TO_CHAR(p_tran_year), 'MMYYYY')) 
            LOOP
                v_first_month := d.wan;
                EXIT;
            END LOOP;
         
            -- if v_first_month is null, then it is the first month ever 
            -- to be processed, so continue with the processing.
            IF v_first_month IS NOT NULL THEN 
                --msg_alert('Previous month not found in giac_monthly_totals.','I', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Previous month not found in giac_monthly_totals.');
            END IF;
        END IF;
        
    END is_prev_month_closed;
    
    
    /** Description:    Validates that the record is not tagged as close (close_tag)
                        before calling the corresponding post procedure (post_to_fiscal_gl, post_to_finance_gl, or post_to_both_gl)
    **/
    PROCEDURE post_to_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_post_tag      IN VARCHAR,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER,
        p_msg          OUT VARCHAR    
    )
    AS
        v_gmto_close_tag    giac_monthly_totals.close_tag%TYPE;
        v_fiscal_close_tag  giac_fiscal_yr.close_tag%TYPE;
        v_finance_close_tag giac_finance_yr.close_tag%TYPE;
    BEGIN
        FOR d IN (SELECT close_tag
                    FROM giac_monthly_totals
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_gmto_close_tag := d.close_tag;
            EXIT;
        END LOOP;
  
        IF v_gmto_close_tag IS NULL THEN
            FOR a IN (SELECT close_tag
                        FROM giac_fiscal_yr
                       WHERE tran_year = p_tran_year
                         AND tran_mm = p_tran_mm) 
            LOOP
                v_fiscal_close_tag := a.close_tag;
                EXIT;
            END LOOP;
                
            FOR b IN (SELECT close_tag
                        FROM giac_finance_yr
                       WHERE tran_year = p_tran_year
                         AND tran_mm = p_tran_mm) 
            LOOP
                v_finance_close_tag := b.close_tag;
                EXIT;
            END LOOP;
        ELSIF v_gmto_close_tag = 'Y' THEN
            --msg_alert('Posting not allowed. This month has ' ||'already been closed.', 'I', TRUE);
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Posting not allowed. This month has already been closed.');
        END IF;
        
        IF v_gmto_close_tag IS NULL THEN
            IF p_post_tag = '1' THEN
                IF v_fiscal_close_tag IS NULL OR v_fiscal_close_tag = 'N' THEN
                    post_to_fiscal_gl(p_tran_year, p_tran_mm, p_gl_no, p_fiscal_end, p_finance_end);
                ELSIF v_fiscal_close_tag = 'Y' THEN
                    --msg_alert('Posting not allowed. This fiscal ' ||'month has already been closed.', 'I',TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Posting not allowed. This fiscal month has already been closed.');
                END IF;
            ELSIF p_post_tag = '2' THEN
                IF v_finance_close_tag IS NULL OR v_finance_close_tag = 'N' THEN
                    post_to_finance_gl(p_tran_year, p_tran_mm, p_gl_no, p_fiscal_end, p_finance_end);
                ELSIF v_finance_close_tag = 'Y' THEN
                    --msg_alert('Posting not allowed. This financial ' ||'month has already been closed.', 'I', TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Posting not allowed. This financial month has already been closed.');
                END IF;       
            ELSIF p_post_tag = '3' THEN
                IF (v_fiscal_close_tag  IS NULL AND v_finance_close_tag IS NULL)  OR  (v_fiscal_close_tag IS NULL AND v_finance_close_tag = 'N') OR
                      (v_fiscal_close_tag = 'N' AND v_finance_close_tag IS NULL)  OR  (v_fiscal_close_tag = 'N' AND v_finance_close_tag = 'N') THEN
                    post_to_both_gl(p_tran_year, p_tran_mm, p_gl_no, p_fiscal_end, p_finance_end);
                ELSIF v_fiscal_close_tag = 'Y' AND v_finance_close_tag = 'Y' THEN
                    --msg_alert('This month has already been closed.', 'I', TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#This month has already been closed.');
                ELSIF v_fiscal_close_tag = 'Y' AND v_finance_close_tag = 'N' THEN
                    --msg_alert('This fiscal month has already been closed. ' ||'Post to the financial GL only.', 'I', TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#This fiscal month has already been closed. Post to the financial GL only.');
                ELSIF v_fiscal_close_tag = 'N' AND v_finance_close_tag = 'Y' THEN
                    --msg_alert('This financial month has already been closed. ' ||'Post to fiscal GL only.', 'I', TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#This financial month has already been closed. Post to fiscal GL only.');
                END IF;     
            END IF;
        END IF;
        
        p_msg := 'SUCCESS';
    END post_to_gl;
    
    
    /** Description:    Inserts records into GIAC_FISCAL_YR and 
    **                  Updates the record's post_tag in GIAC_MONTHLY_TOTALS 
    **/
    PROCEDURE post_to_fiscal_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER
    )
    AS
        CURSOR a_cur IS 
            SELECT gl_acct_id, fund_cd,
                   branch_cd, tran_year, tran_mm, 
                   trans_debit_bal, trans_credit_bal
              FROM giac_monthly_totals
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm
               -- FOR UPDATE OF post_tag; comment in by Alfie 02192009
             ;
        CURSOR b_cur IS 
            SELECT a.gl_acct_id, a.fund_cd,
                   a.branch_cd, a.tran_year, a.tran_mm, 
                   a.trans_debit_bal, a.trans_credit_bal
              FROM giac_fiscal_yr a
             WHERE a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
               AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))
               AND NOT EXISTS (SELECT b.gl_acct_id, b.fund_cd,
                                      b.branch_cd, b.tran_year, b.tran_mm, 
                                      b.trans_debit_bal, b.trans_credit_bal
                                 FROM giac_fiscal_yr b
                                WHERE a.gl_acct_id = b.gl_acct_id
                                  AND a.branch_cd = b.branch_cd
                                  AND a.fund_cd = b.fund_cd 
                                  AND b.tran_year = p_tran_year
                                  AND b.tran_mm = p_tran_mm);
    
        v_fiscal_trans_bal          giac_fiscal_yr.trans_balance%TYPE;
        v_fiscal_beg_debit_amt      giac_fiscal_yr.beg_debit_amt%TYPE;
        v_fiscal_beg_credit_amt     giac_fiscal_yr.beg_credit_amt%TYPE;
        v_fiscal_end_debit_amt      giac_fiscal_yr.end_debit_amt%TYPE;
        v_fiscal_end_credit_amt     giac_fiscal_yr.end_credit_amt%TYPE;
        v_fiscal_trans_balance      giac_fiscal_yr.trans_balance%TYPE;
        
        v_prev_mm                   NUMBER(2);
        v_fiscal_exists             VARCHAR2(1);
        v_gl_acct_id                giac_monthly_totals.gl_acct_id%TYPE;
        v_gmto_post_tag             giac_monthly_totals.post_tag%TYPE;
        v_new_post_tag              giac_monthly_totals.post_tag%TYPE;
        v_trans_debit_balance       giac_monthly_totals.trans_debit_bal%TYPE;
        v_trans_credit_balance      giac_monthly_totals.trans_credit_bal%TYPE;
        v_acct_type                 giac_chart_of_accts.acct_type%TYPE;
        
        v_profit_loss_acct          giac_acct_entries.gl_acct_id%TYPE;
        v_gl_acct_category          giac_acct_entries.gl_acct_category%TYPE;
        v_gl_control_acct           giac_acct_entries.gl_control_acct%TYPE;
        v_gl_sub_acct_1             giac_acct_entries.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2             giac_acct_entries.gl_sub_acct_2%TYPE;     
        v_gl_sub_acct_3             giac_acct_entries.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4             giac_acct_entries.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5             giac_acct_entries.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6             giac_acct_entries.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7             giac_acct_entries.gl_sub_acct_7%TYPE;
        v_item_no                   giac_module_entries.item_no%TYPE;
        v_trans_balance             NUMBER; --03202009 alfie
        v_end_debit_amt             NUMBER;
        v_end_credit_amt            NUMBER; --:=)
    BEGIN
        FOR e IN (SELECT '1' wan
                    FROM giac_fiscal_yr
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_fiscal_exists := e.wan;
            EXIT;
        END LOOP;
        
        IF v_fiscal_exists IS NOT NULL THEN
            DELETE FROM giac_fiscal_yr
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
            
            IF SQL%NOTFOUND THEN
                --msg_alert('Error deleting giac_fiscal_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error deleting giac_fiscal_yr.');
            END IF;
        END IF;
        
        FOR d IN (SELECT post_tag
                    FROM giac_monthly_totals
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_gmto_post_tag := d.post_tag;
            EXIT;
        END LOOP;
        
        BEGIN
            SELECT DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))
              INTO v_prev_mm
              FROM dual;
        END;
        
        BEGIN
            IF p_gl_no = 1 THEN 
               v_item_no := 2;
            ELSIF p_gl_no = 2 THEN
               IF p_tran_mm = p_fiscal_end THEN
                  v_item_no := 1;
               ELSIF p_tran_mm = p_finance_end THEN
                  v_item_no := 2;
               END IF;
            END IF; 
            
            BEGIN 
                SELECT gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4,
                       gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7
                  INTO v_gl_acct_category, v_gl_control_acct,
                       v_gl_sub_acct_1, v_gl_sub_acct_2,
                       v_gl_sub_acct_3, v_gl_sub_acct_4,
                       v_gl_sub_acct_5, v_gl_sub_acct_6,
                       v_gl_sub_acct_7         
                  FROM GIAC_MODULE_ENTRIES
                 WHERE module_id IN (SELECT module_id
                                       FROM GIAC_MODULES
                                      WHERE module_name = 'GIACS411'
                                        AND item_no = v_item_no);  
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No data found in GIAC_MODULE_ENTRIES.');
            END;  
                                    
            BEGIN                        
                SELECT DISTINCT gl_acct_id
                  INTO v_profit_loss_acct
                  FROM GIAC_CHART_OF_ACCTS
                 WHERE gl_acct_category = v_gl_acct_category
                   AND gl_control_acct = v_gl_control_acct
                   AND gl_sub_acct_1 = v_gl_sub_acct_1
                   AND gl_sub_acct_2 = v_gl_sub_acct_2
                   AND gl_sub_acct_3 = v_gl_sub_acct_3
                   AND gl_sub_acct_4 = v_gl_sub_acct_4
                   AND gl_sub_acct_5 = v_gl_sub_acct_5
                   AND gl_sub_acct_6 = v_gl_sub_acct_6
                   AND gl_sub_acct_7 = v_gl_sub_acct_7
                   AND leaf_tag = 'Y'; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No data found in GIAC_CHART_OF_ACCTS.');
            END;      
        END;
        
        
        FOR a_rec IN a_cur LOOP
            v_gl_acct_id := a_rec.gl_acct_id; --03202009 alfie
            
            IF (p_gl_no = 1 AND v_prev_mm = p_finance_end) OR (p_gl_no = 2 AND v_prev_mm = p_fiscal_end) THEN
                FOR m IN  (SELECT a.gl_acct_id, a.end_debit_amt, a.end_credit_amt, b.acct_type
                             FROM GIAC_FISCAL_YR a, 
                                  GIAC_CHART_OF_ACCTS b
                            WHERE a.gl_acct_id = b.gl_acct_id(+)
                              AND a.gl_acct_id = a_rec.gl_acct_id
                              AND a.fund_cd = a_rec.fund_cd
                              AND a.branch_cd = a_rec.branch_cd
                              AND a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                              AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))) 
                  LOOP
                        v_acct_type     := m.acct_type;
                        v_end_debit_amt := m.end_debit_amt; --03202009 alfie
                        v_end_credit_amt:= m.end_credit_amt;
                        v_trans_balance := v_end_debit_amt - v_end_credit_amt; --:=)
                        
                        IF v_acct_type IN ('I', 'E') and v_gl_acct_id <> v_profit_loss_acct THEN
                            IF v_trans_balance <> 0 THEN --03202009 alfie
                                v_fiscal_beg_debit_amt  := m.end_debit_amt;
                                v_fiscal_beg_credit_amt := m.end_credit_amt; 
                            ELSE --:=) 
                                v_fiscal_beg_debit_amt  := 0;
                                v_fiscal_beg_credit_amt := 0; 
                            END IF;
                        ELSE
                            v_fiscal_beg_debit_amt  := m.end_debit_amt;
                            v_fiscal_beg_credit_amt := m.end_credit_amt; 
                        END IF;
                        
                        EXIT;
                  END LOOP; 
                          
                  IF v_fiscal_beg_debit_amt IS NULL THEN
                        v_fiscal_beg_debit_amt  := 0;
                  END IF;
                       
                  IF v_fiscal_beg_credit_amt IS NULL THEN
                        v_fiscal_beg_credit_amt := 0;
                  END IF;
            ELSE       
                FOR c IN (SELECT NVL(end_debit_amt, 0) end_debit_amt, 
                                 NVL(end_credit_amt, 0) end_credit_amt
                            FROM giac_fiscal_yr
                           WHERE gl_acct_id = a_rec.gl_acct_id
                             AND fund_cd = a_rec.fund_cd
                             AND branch_cd = a_rec.branch_cd
                             AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                                (p_tran_mm - 1))) 
                LOOP
                    v_fiscal_beg_debit_amt  := c.end_debit_amt;
                    v_fiscal_beg_credit_amt := c.end_credit_amt;
                    EXIT;
                END LOOP;
       
                IF v_fiscal_beg_debit_amt IS NULL THEN
                    v_fiscal_beg_debit_amt := 0;
                END IF;
                   
                IF v_fiscal_beg_credit_amt IS NULL THEN
                    v_fiscal_beg_credit_amt := 0;
                END IF;
            END IF;
            
            v_fiscal_end_debit_amt  := NVL(v_fiscal_beg_debit_amt, 0) + NVL(a_rec.trans_debit_bal, 0);
            v_fiscal_end_credit_amt := NVL(v_fiscal_beg_credit_amt, 0) + NVL(a_rec.trans_credit_bal, 0);
            v_fiscal_trans_balance  := v_fiscal_end_debit_amt - v_fiscal_end_credit_amt;
                     
            INSERT INTO  giac_fiscal_yr(gl_acct_id, fund_cd, 
                                        branch_cd, tran_year, tran_mm,
                                        beg_debit_amt, beg_credit_amt, 
                                        trans_debit_bal, trans_credit_bal,
                                        end_debit_amt, end_credit_amt,
                                        trans_balance, close_tag)
            VALUES (a_rec.gl_acct_id, a_rec.fund_cd,
                    a_rec.branch_cd, p_tran_year, p_tran_mm,
                    v_fiscal_beg_debit_amt, v_fiscal_beg_credit_amt,
                    a_rec.trans_debit_bal, a_rec.trans_credit_bal,
                    v_fiscal_end_debit_amt, v_fiscal_end_credit_amt,
                    v_fiscal_trans_balance, 'N');
             
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_fiscal_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_fiscal_yr.');
            END IF;

            ----------------------------------------------------------------------
            v_new_post_tag := '3';
            
            UPDATE giac_monthly_totals
               SET post_tag = v_new_post_tag
             WHERE gl_acct_id = a_rec.gl_acct_id
               AND fund_cd = a_rec.fund_cd
               AND branch_cd = a_rec.branch_cd
               AND tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
        
            IF SQL%NOTFOUND THEN
                --msg_alert('Error updating giac_monthly_totals.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error updating giac_monthly_totals.');
            END IF;
             
                
            v_fiscal_beg_debit_amt  := NULL;
            v_fiscal_beg_credit_amt := NULL;
            v_fiscal_end_debit_amt  := NULL;
            v_fiscal_end_credit_amt := NULL;
            v_fiscal_trans_balance  := NULL;
            v_new_post_tag          := NULL;
        END LOOP;
        
       ------------------------------------------------------------
        FOR b_rec in b_cur LOOP
            v_gl_acct_id := b_rec.gl_acct_id;
        
            IF (p_gl_no = 1 AND v_prev_mm = p_finance_end) OR (p_gl_no = 2 AND v_prev_mm = p_fiscal_end) THEN
                FOR w IN (SELECT a.gl_acct_id, a.end_debit_amt, a.end_credit_amt, b.acct_type
                            FROM GIAC_FISCAL_YR a, 
                                 GIAC_CHART_OF_ACCTS b
                           WHERE a.gl_acct_id = b.gl_acct_id(+)
                             AND a.gl_acct_id = b_rec.gl_acct_id
                             AND a.fund_cd = b_rec.fund_cd
                             AND a.branch_cd = b_rec.branch_cd
                             AND a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                             AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))) 
                LOOP
                    v_acct_type     := w.acct_type;
                    v_end_debit_amt := w.end_debit_amt; --03202009 alfie
                    v_end_credit_amt:= w.end_credit_amt;
                    v_trans_balance := v_end_debit_amt - v_end_credit_amt; --:=)
                    
                    IF v_acct_type IN ('I', 'E') and v_gl_acct_id <> v_profit_loss_acct THEN
                        IF v_trans_balance <> 0 THEN --03202009 alfie
                            v_fiscal_beg_debit_amt  := w.end_debit_amt;
                            v_fiscal_beg_credit_amt := w.end_credit_amt; 
                        ELSE --:=) 
                            v_fiscal_beg_debit_amt  := 0;
                            v_fiscal_beg_credit_amt := 0; 
                        END IF;
                    ELSE
                       v_fiscal_beg_debit_amt   := w.end_debit_amt;
                       v_fiscal_beg_credit_amt := w.end_credit_amt; 
                    END IF;
                    
                    EXIT;
                END LOOP;  
                  
                         
                IF v_fiscal_beg_debit_amt IS NULL THEN
                    v_fiscal_beg_debit_amt  := 0;
                END IF;     
                IF v_fiscal_beg_credit_amt IS NULL THEN
                    v_fiscal_beg_credit_amt := 0;
                END IF;
            ELSE       
                FOR x IN (SELECT NVL(end_debit_amt, 0) end_debit_amt, 
                                 NVL(end_credit_amt, 0) end_credit_amt
                            FROM giac_fiscal_yr
                           WHERE gl_acct_id = b_rec.gl_acct_id
                             AND fund_cd = b_rec.fund_cd
                             AND branch_cd = b_rec.branch_cd
                             AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                               (p_tran_mm - 1))) 
                LOOP
                    v_fiscal_beg_debit_amt  := x.end_debit_amt;
                    v_fiscal_beg_credit_amt := x.end_credit_amt;
                    EXIT;
                END LOOP;       
              
                IF v_fiscal_beg_debit_amt IS NULL THEN
                    v_fiscal_beg_debit_amt  := 0;
                END IF;    
              
                IF v_fiscal_beg_credit_amt IS NULL THEN
                    v_fiscal_beg_credit_amt := 0;
                END IF;
            END IF;
            
            IF v_gl_acct_id IS NOT NULL THEN   
                v_trans_debit_balance   := 0;
                v_trans_credit_balance  := 0; 
                v_fiscal_end_debit_amt  := NVL(v_fiscal_beg_debit_amt, 0) + 0;
                v_fiscal_end_credit_amt := NVL(v_fiscal_beg_credit_amt, 0) + 0;
                v_fiscal_trans_balance  := v_fiscal_end_debit_amt - v_fiscal_end_credit_amt;
            /* ELSE
                v_trans_debit_balance   := b_rec.trans_debit_bal;
                v_trans_credit_balance  := b_rec.trans_credit_bal; 
                v_fiscal_end_debit_amt  := NVL(v_fiscal_beg_debit_amt, 0) + NVL(v_trans_debit_balance, 0);
                v_fiscal_end_credit_amt := NVL(v_fiscal_beg_credit_amt, 0) + NVL(v_trans_credit_balance, 0);
                v_fiscal_trans_balance  := v_fiscal_end_debit_amt - v_fiscal_end_credit_amt;*/
            END IF; 
            
            INSERT INTO giac_fiscal_yr(gl_acct_id, fund_cd, 
                                       branch_cd, tran_year, tran_mm,
                                       beg_debit_amt, beg_credit_amt, 
                                       trans_debit_bal, trans_credit_bal,
                                       end_debit_amt, end_credit_amt,
                                       trans_balance, close_tag)
            VALUES(b_rec.gl_acct_id, b_rec.fund_cd,
                   b_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_fiscal_beg_debit_amt, v_fiscal_beg_credit_amt,
                   v_trans_debit_balance, v_trans_credit_balance,
                   v_fiscal_end_debit_amt, v_fiscal_end_credit_amt,
                   v_fiscal_trans_balance, 'N');
       
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_fiscal_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_fiscal_yr.');
            END IF;
            
        --------------------------------------------------------------------------------- 
            v_new_post_tag := '3';
            UPDATE giac_monthly_totals
               SET post_tag = v_new_post_tag
             WHERE gl_acct_id NOT IN (SELECT gl_acct_id
                                        FROM giac_monthly_totals
                                       WHERE tran_year = p_tran_year
                                         AND tran_mm = p_tran_mm)
               AND fund_cd = b_rec.fund_cd
               AND branch_cd = b_rec.branch_cd
               AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
               AND tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1));
             
             /*IF SQL%NOTFOUND THEN
                msg_alert('Error updating giac_monthly_totals.', 'E', TRUE);
             END IF;   */
             
                
            v_fiscal_beg_debit_amt  := NULL;
            v_fiscal_beg_credit_amt := NULL;
            v_fiscal_end_debit_amt  := NULL;
            v_fiscal_end_credit_amt := NULL;
            v_fiscal_trans_balance  := NULL;              
            v_new_post_tag          := NULL;
        END LOOP;
        
    END post_to_fiscal_gl;
    
    
    /** Description:    Inserts records into GIAC_FINANCE_YR and 
    **                  Updates the record's post_tag in GIAC_MONTHLY_TOTALS 
    **/
    PROCEDURE post_to_finance_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER
    )
    AS
       CURSOR a_cur IS 
            SELECT gl_acct_id, fund_cd,
                   branch_cd, tran_year, tran_mm, 
                   trans_debit_bal, trans_credit_bal
              FROM giac_monthly_totals
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm
             -- FOR UPDATE OF post_tag; comment in by Alfie 02192009
             ; 
             
        CURSOR b_cur IS 
             SELECT a.gl_acct_id, a.fund_cd,
                    a.branch_cd, a.tran_year, a.tran_mm, 
                    a.trans_debit_bal, a.trans_credit_bal
               FROM giac_finance_yr a
              WHERE a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))
                AND NOT EXISTS (SELECT b.gl_acct_id, b.fund_cd,
                                       b.branch_cd, b.tran_year, b.tran_mm, 
                                       b.trans_debit_bal, b.trans_credit_bal
                                  FROM giac_finance_yr b
                                 WHERE a.gl_acct_id = b.gl_acct_id
                                   AND a.branch_cd = b.branch_cd
                                   AND a.fund_cd = b.fund_cd 
                                   AND b.tran_year = p_tran_year
                                   AND b.tran_mm = p_tran_mm);
                                   
        v_finance_trans_bal         giac_finance_yr.trans_balance%TYPE;
        v_finance_beg_debit_amt     giac_finance_yr.beg_debit_amt%TYPE;
        v_finance_beg_credit_amt    giac_finance_yr.beg_credit_amt%TYPE;
        v_finance_end_debit_amt     giac_finance_yr.end_debit_amt%TYPE;
        v_finance_end_credit_amt    giac_finance_yr.end_credit_amt%TYPE;
        v_finance_trans_balance     giac_finance_yr.trans_balance%TYPE;
         
        v_prev_mm                   NUMBER(2);
        v_finance_exists            VARCHAR2(1);
        v_gl_acct_id                giac_monthly_totals.gl_acct_id%TYPE;
        v_gmto_post_tag             giac_monthly_totals.post_tag%TYPE;
        v_new_post_tag              giac_monthly_totals.post_tag%TYPE;
        v_trans_debit_balance       giac_monthly_totals.trans_debit_bal%TYPE;
        v_trans_credit_balance      giac_monthly_totals.trans_credit_bal%TYPE;
        v_acct_type                 giac_chart_of_accts.acct_type%TYPE;

        v_profit_loss_acct          giac_acct_entries.gl_acct_id%TYPE;
        v_gl_acct_category          giac_acct_entries.gl_acct_category%TYPE;
        v_gl_control_acct           giac_acct_entries.gl_control_acct%TYPE;
        v_gl_sub_acct_1             giac_acct_entries.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2             giac_acct_entries.gl_sub_acct_2%TYPE;     
        v_gl_sub_acct_3             giac_acct_entries.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4             giac_acct_entries.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5             giac_acct_entries.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6             giac_acct_entries.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7             giac_acct_entries.gl_sub_acct_7%TYPE;
        v_item_no                   giac_module_entries.item_no%TYPE;
        v_trans_balance             NUMBER; --03202009 alfie
        v_end_debit_amt             NUMBER;
        v_end_credit_amt            NUMBER; --:=)
    BEGIN
        FOR f IN (SELECT '1' wan
                    FROM giac_finance_yr
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_finance_exists := f.wan;
            EXIT;
        END LOOP;
  
        IF v_finance_exists IS NOT NULL THEN
            DELETE FROM giac_finance_yr
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
               
            IF SQL%NOTFOUND THEN
                --msg_alert('Error deleting giac_finance_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error deleting giac_finance_yr.');
            END IF;
        END IF;
       
        FOR d IN (SELECT post_tag
                    FROM giac_monthly_totals
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_gmto_post_tag := d.post_tag;
            EXIT;
        END LOOP;
    
        BEGIN
            SELECT DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))
              INTO v_prev_mm
              FROM dual;
        END;
     
        BEGIN
            IF p_gl_no = 1 THEN 
               v_item_no := 2;
            ELSIF p_gl_no = 2 THEN
               IF p_tran_mm = p_fiscal_end THEN
                  v_item_no := 1;
               ELSIF p_tran_mm = p_finance_end THEN
                  v_item_no := 2;
               END IF;
            END IF;  
            
            BEGIN
                SELECT gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4,
                       gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7
                  INTO v_gl_acct_category, v_gl_control_acct,
                       v_gl_sub_acct_1, v_gl_sub_acct_2,
                       v_gl_sub_acct_3, v_gl_sub_acct_4,
                       v_gl_sub_acct_5, v_gl_sub_acct_6,
                       v_gl_sub_acct_7         
                  FROM GIAC_MODULE_ENTRIES
                 WHERE module_id IN (SELECT module_id
                                       FROM GIAC_MODULES
                                      WHERE module_name = 'GIACS411'
                                        AND item_no = v_item_no);   
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No data found in GIAC_MODULE_ENTRIES.');
            END; 
            
            BEGIN                                    
                SELECT DISTINCT gl_acct_id
                  INTO v_profit_loss_acct
                  FROM GIAC_CHART_OF_ACCTS
                 WHERE gl_acct_category = v_gl_acct_category
                   AND gl_control_acct = v_gl_control_acct
                   AND gl_sub_acct_1 = v_gl_sub_acct_1
                   AND gl_sub_acct_2 = v_gl_sub_acct_2
                   AND gl_sub_acct_3 = v_gl_sub_acct_3
                   AND gl_sub_acct_4 = v_gl_sub_acct_4
                   AND gl_sub_acct_5 = v_gl_sub_acct_5
                   AND gl_sub_acct_6 = v_gl_sub_acct_6
                   AND gl_sub_acct_7 = v_gl_sub_acct_7
                   AND leaf_tag = 'Y'; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No data found in GIAC_CHART_OF_ACCTS.');
            END;      
        END;
        
        FOR a_rec IN a_cur LOOP
            v_gl_acct_id := a_rec.gl_acct_id; --03202009
            
            IF (p_gl_no = 1 AND v_prev_mm = p_finance_end) OR (p_gl_no = 2 AND v_prev_mm = p_finance_end) THEN
                FOR n IN (SELECT a.gl_acct_id, a.end_debit_amt, a.end_credit_amt, b.acct_type
                            FROM GIAC_FINANCE_YR a, 
                                 GIAC_CHART_OF_ACCTS b
                           WHERE a.gl_acct_id = b.gl_acct_id(+)
                             AND a.gl_acct_id = a_rec.gl_acct_id
                             AND a.fund_cd = a_rec.fund_cd
                             AND a.branch_cd = a_rec.branch_cd
                             AND a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                             AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))) 
                LOOP
                    v_acct_type     := n.acct_type;
                    v_end_debit_amt := n.end_debit_amt; --03202009 alfie
                    v_end_credit_amt:= n.end_credit_amt;
                    v_trans_balance := v_end_debit_amt - v_end_credit_amt;     --:=)   
                     
                    IF v_acct_type IN ('I', 'E') and v_gl_acct_id <> v_profit_loss_acct THEN
                        IF v_trans_balance <> 0 THEN --03202009 alfie
                            v_finance_beg_debit_amt     := n.end_debit_amt;
                            v_finance_beg_credit_amt    := n.end_credit_amt;     
                        ELSE --:=) 
                            v_finance_beg_debit_amt     := 0;
                            v_finance_beg_credit_amt    := 0;
                        END IF;
                    ELSE
                        v_finance_beg_debit_amt     := n.end_debit_amt;
                        v_finance_beg_credit_amt    := n.end_credit_amt; 
                    END IF;
                    
                    EXIT;
                END LOOP;  
                     
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF; 
                    
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            ELSE       
                FOR c IN (SELECT NVL(end_debit_amt, 0) end_debit_amt, 
                                 NVL(end_credit_amt, 0) end_credit_amt
                            FROM giac_finance_yr
                           WHERE gl_acct_id = a_rec.gl_acct_id
                             AND fund_cd = a_rec.fund_cd
                             AND branch_cd = a_rec.branch_cd
                             AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                                (p_tran_mm - 1))) 
                LOOP
                    v_finance_beg_debit_amt := c.end_debit_amt;
                    v_finance_beg_credit_amt := c.end_credit_amt;
                    EXIT;
                END LOOP;
                        
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF;  
                      
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            END IF; 
            
            v_finance_end_debit_amt     := NVL(v_finance_beg_debit_amt, 0) + NVL(a_rec.trans_debit_bal, 0);
            v_finance_end_credit_amt    := NVL(v_finance_beg_credit_amt, 0) + NVL(a_rec.trans_credit_bal, 0);
            v_finance_trans_balance     := v_finance_end_debit_amt - v_finance_end_credit_amt; 
            
            INSERT INTO giac_finance_yr(gl_acct_id, fund_cd, 
                                        branch_cd, tran_year, tran_mm,
                                        beg_debit_amt, beg_credit_amt, 
                                        trans_debit_bal, trans_credit_bal,
                                        end_debit_amt, end_credit_amt,
                                        trans_balance, close_tag)
            VALUES(a_rec.gl_acct_id, a_rec.fund_cd,
                   a_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_finance_beg_debit_amt, v_finance_beg_credit_amt,
                   a_rec.trans_debit_bal, a_rec.trans_credit_bal,
                   v_finance_end_debit_amt, v_finance_end_credit_amt,
                   v_finance_trans_balance, 'N');           
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_finance_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_finance_yr.');
            END IF;
        
            ----------------------------------------------------------------------
            v_new_post_tag := '3';
            
            UPDATE giac_monthly_totals
               SET post_tag = v_new_post_tag
             WHERE gl_acct_id = a_rec.gl_acct_id
               AND fund_cd = a_rec.fund_cd
               AND branch_cd = a_rec.branch_cd
               AND tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
             
             IF SQL%NOTFOUND THEN
                --msg_alert('Error updating giac_monthly_totals.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error updating giac_monthly_totals.');
             END IF;
                     
                        
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_end_debit_amt     := NULL;
            v_finance_end_credit_amt    := NULL;
            v_finance_trans_balance     := NULL;
            v_new_post_tag              := NULL;
        END LOOP;
        
        FOR b_rec in b_cur LOOP 
            v_gl_acct_id := b_rec.gl_acct_id;
            
            IF (p_gl_no = 1 AND v_prev_mm = p_finance_end) OR (p_gl_no = 2 AND v_prev_mm = p_finance_end) THEN
                FOR y IN (SELECT a.gl_acct_id, a.end_debit_amt, a.end_credit_amt, b.acct_type
                            FROM GIAC_FINANCE_YR a, 
                                 GIAC_CHART_OF_ACCTS b
                           WHERE a.gl_acct_id = b.gl_acct_id(+)
                             AND a.gl_acct_id = b_rec.gl_acct_id
                             AND a.fund_cd = b_rec.fund_cd
                             AND a.branch_cd = b_rec.branch_cd
                             AND a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                             AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))) 
                LOOP
                    v_acct_type     := y.acct_type;
                    v_end_debit_amt := y.end_debit_amt; --03202009 alfie
                    v_end_credit_amt:= y.end_credit_amt;
                    v_trans_balance := v_end_debit_amt - v_end_credit_amt;    --:=)
                    
                    IF v_acct_type IN ('I', 'E') and v_gl_acct_id <> v_profit_loss_acct THEN
                        IF v_trans_balance <> 0 THEN --03202009
                            v_finance_beg_debit_amt  := y.end_debit_amt;
                            v_finance_beg_credit_amt := y.end_credit_amt; 
                        ELSE --:=)
                            v_finance_beg_debit_amt  := 0;
                            v_finance_beg_credit_amt := 0; 
                        END IF;
                    ELSE
                       v_finance_beg_debit_amt  := y.end_debit_amt;
                       v_finance_beg_credit_amt := y.end_credit_amt; 
                    END IF;
                    
                    EXIT;
                END LOOP;         
                 
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF; 
                    
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            ELSE       
                FOR z IN (SELECT NVL(end_debit_amt, 0) end_debit_amt, 
                                 NVL(end_credit_amt, 0) end_credit_amt
                            FROM giac_finance_yr
                           WHERE gl_acct_id = b_rec.gl_acct_id
                             AND fund_cd = b_rec.fund_cd
                             AND branch_cd = b_rec.branch_cd
                             AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                  p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                                (p_tran_mm - 1))) 
                LOOP
                    v_finance_beg_debit_amt  := z.end_debit_amt;
                    v_finance_beg_credit_amt := z.end_credit_amt;
                    EXIT;
                END LOOP;
                        
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF;
                      
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            END IF;
            
            IF v_gl_acct_id IS NOT NULL THEN
                v_trans_debit_balance   := 0;
                v_trans_credit_balance  := 0; 
                v_finance_end_debit_amt := NVL(v_finance_beg_debit_amt, 0) + 0;
                v_finance_end_credit_amt:= NVL(v_finance_beg_credit_amt, 0) + 0;
                v_finance_trans_balance := v_finance_end_debit_amt - v_finance_end_credit_amt;
            /*ELSE
               v_trans_debit_balance    := b_rec.trans_debit_bal;
               v_trans_credit_balance   := b_rec.trans_credit_bal; 
               v_finance_end_debit_amt  := NVL(v_finance_beg_debit_amt, 0) + NVL(v_trans_debit_balance, 0);
               v_finance_end_credit_amt := NVL(v_finance_beg_credit_amt, 0) + NVL(v_trans_credit_balance, 0);
               v_finance_trans_balance  := v_finance_end_debit_amt - v_finance_end_credit_amt;*/
            END IF; 
            
            INSERT INTO giac_finance_yr(gl_acct_id, fund_cd, 
                                        branch_cd, tran_year, tran_mm,
                                        beg_debit_amt, beg_credit_amt, 
                                        trans_debit_bal, trans_credit_bal,
                                        end_debit_amt, end_credit_amt,
                                        trans_balance, close_tag)
            VALUES(b_rec.gl_acct_id, b_rec.fund_cd,
                   b_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_finance_beg_debit_amt, v_finance_beg_credit_amt,
                   v_trans_debit_balance, v_trans_credit_balance,
                   v_finance_end_debit_amt, v_finance_end_credit_amt,
                   v_finance_trans_balance, 'N');
           
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_finance_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_finance_yr.');
            END IF;
            
            ---------------------------------------------------------
            v_new_post_tag := '3';
            
            UPDATE giac_monthly_totals
               SET post_tag = v_new_post_tag
             WHERE gl_acct_id NOT IN (SELECT gl_acct_id
                                        FROM giac_monthly_totals
                                       WHERE tran_year = p_tran_year
                                         AND tran_mm = p_tran_mm)
               AND fund_cd = b_rec.fund_cd
               AND branch_cd = b_rec.branch_cd
               AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
               AND tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1));
              
            /*IF SQL%NOTFOUND THEN
                msg_alert('Error updating giac_monthly_totals.', 'E', TRUE);
            END IF;   */
                     
                        
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_end_debit_amt     := NULL;
            v_finance_end_credit_amt    := NULL;
            v_finance_trans_balance     := NULL;
            v_new_post_tag              := NULL;
        END LOOP;
    END post_to_finance_gl;
    
    
    /** Description:    Inserts records into GIAC_FISCAL_YR and GIAC_FINANCE_YR and 
    **                  Updates the record's post_tag in GIAC_MONTHLY_TOTALS 
    **/
    PROCEDURE post_to_both_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER
    )
    AS
        CURSOR a_cur IS 
            SELECT gl_acct_id, fund_cd,
                   branch_cd, tran_year, tran_mm, 
                   trans_debit_bal, trans_credit_bal
              FROM giac_monthly_totals
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm
             -- FOR UPDATE OF post_tag; comment in by Alfie 02192009
             ;
    
        CURSOR b_cur IS 
             SELECT a.gl_acct_id, a.fund_cd,
                    a.branch_cd, a.tran_year, a.tran_mm, 
                    a.trans_debit_bal, a.trans_credit_bal
               FROM giac_finance_yr a
              WHERE a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))
                AND NOT EXISTS (SELECT b.gl_acct_id, b.fund_cd,
                                       b.branch_cd, b.tran_year, b.tran_mm, 
                                       b.trans_debit_bal, b.trans_credit_bal
                                  FROM giac_finance_yr b
                                 WHERE a.gl_acct_id = b.gl_acct_id
                                   AND a.branch_cd = b.branch_cd
                                   AND a.fund_cd = b.fund_cd 
                                   AND b.tran_year = p_tran_year
                                   AND b.tran_mm = p_tran_mm);
                                   
        v_finance_trans_bal         giac_finance_yr.trans_balance%TYPE;
        v_finance_beg_debit_amt     giac_finance_yr.beg_debit_amt%TYPE;
        v_finance_beg_credit_amt    giac_finance_yr.beg_credit_amt%TYPE;
        v_finance_end_debit_amt     giac_finance_yr.end_debit_amt%TYPE;
        v_finance_end_credit_amt    giac_finance_yr.end_credit_amt%TYPE;
        v_finance_trans_balance     giac_finance_yr.trans_balance%TYPE;
         
        v_prev_mm                   NUMBER(2);
        v_finance_exists            VARCHAR2(1);
        v_gl_acct_id                giac_monthly_totals.gl_acct_id%TYPE;
        v_gmto_post_tag             giac_monthly_totals.post_tag%TYPE;
        v_new_post_tag              giac_monthly_totals.post_tag%TYPE;
        v_trans_debit_balance       giac_monthly_totals.trans_debit_bal%TYPE;
        v_trans_credit_balance      giac_monthly_totals.trans_credit_bal%TYPE;
        v_acct_type                 giac_chart_of_accts.acct_type%TYPE;
        v_fiscal_exists             VARCHAR2(1);

        v_profit_loss_acct          giac_acct_entries.gl_acct_id%TYPE;
        v_gl_acct_category          giac_acct_entries.gl_acct_category%TYPE;
        v_gl_control_acct           giac_acct_entries.gl_control_acct%TYPE;
        v_gl_sub_acct_1             giac_acct_entries.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2             giac_acct_entries.gl_sub_acct_2%TYPE;     
        v_gl_sub_acct_3             giac_acct_entries.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4             giac_acct_entries.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5             giac_acct_entries.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6             giac_acct_entries.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7             giac_acct_entries.gl_sub_acct_7%TYPE;
        v_item_no                   giac_module_entries.item_no%TYPE; 
        v_trans_balance             NUMBER; --03202009 alfie
        v_end_debit_amt             NUMBER;
        v_end_credit_amt            NUMBER; --:=)
    BEGIN
        FOR f IN (SELECT '1' wan
                    FROM giac_finance_yr
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_finance_exists := f.wan;
            EXIT;
        END LOOP;
  
        IF v_finance_exists IS NOT NULL THEN
            DELETE FROM giac_finance_yr
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
    
            IF SQL%NOTFOUND THEN
                --msg_alert('Error deleting giac_finance_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error deleting giac_finance_yr.');
            END IF;
        END IF;
       
        FOR e IN (SELECT '1' wan
                    FROM giac_fiscal_yr
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_fiscal_exists := e.wan;
            EXIT;
        END LOOP;
   
        IF v_fiscal_exists IS NOT NULL THEN
            DELETE FROM giac_fiscal_yr
             WHERE tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
    
            IF SQL%NOTFOUND THEN
                --msg_alert('Error deleting giac_fiscal_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error deleting giac_fiscal_yr.');
            END IF;
        END IF;
  
        FOR d IN (SELECT post_tag
                    FROM giac_monthly_totals
                   WHERE tran_year = p_tran_year
                     AND tran_mm = p_tran_mm) 
        LOOP
            v_gmto_post_tag := d.post_tag;
            EXIT;
        END LOOP;
    
        BEGIN
            SELECT DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))
              INTO v_prev_mm
              FROM dual;
        END;     
        
        BEGIN
            IF p_gl_no = 1 THEN 
                v_item_no := 2;
            ELSIF p_gl_no = 2 THEN
                IF p_tran_mm = p_fiscal_end THEN
                    v_item_no := 1;
                ELSIF p_tran_mm = p_finance_end THEN
                    v_item_no := 2;
                END IF;
            END IF;  
            
            BEGIN
                SELECT gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4,
                       gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7
                  INTO v_gl_acct_category, v_gl_control_acct,
                       v_gl_sub_acct_1, v_gl_sub_acct_2,
                       v_gl_sub_acct_3, v_gl_sub_acct_4,
                       v_gl_sub_acct_5, v_gl_sub_acct_6,
                       v_gl_sub_acct_7         
                  FROM GIAC_MODULE_ENTRIES
                 WHERE module_id IN (SELECT module_id
                                       FROM GIAC_MODULES
                                      WHERE module_name = 'GIACS411'
                                        AND item_no = v_item_no);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No data found in GIAC_MODULE_ENTRIES.');
            END;   
               
            BEGIN                     
                SELECT DISTINCT gl_acct_id
                  INTO v_profit_loss_acct
                  FROM GIAC_CHART_OF_ACCTS
                 WHERE gl_acct_category = v_gl_acct_category
                   AND gl_control_acct = v_gl_control_acct
                   AND gl_sub_acct_1 = v_gl_sub_acct_1
                   AND gl_sub_acct_2 = v_gl_sub_acct_2
                   AND gl_sub_acct_3 = v_gl_sub_acct_3
                   AND gl_sub_acct_4 = v_gl_sub_acct_4
                   AND gl_sub_acct_5 = v_gl_sub_acct_5
                   AND gl_sub_acct_6 = v_gl_sub_acct_6
                   AND gl_sub_acct_7 = v_gl_sub_acct_7
                   AND leaf_tag = 'Y';   
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No data found in GIAC_CHART_OF_ACCTS.');
            END;    
        END;         
        
        FOR a_rec IN a_cur LOOP
            v_gl_acct_id := a_rec.gl_acct_id; --03202009 alfie
            
            IF (p_gl_no = 1 AND v_prev_mm = p_finance_end) OR (p_gl_no = 2 AND v_prev_mm = p_finance_end) THEN
                FOR n IN (SELECT a.gl_acct_id, a.end_debit_amt, a.end_credit_amt, b.acct_type
                            FROM GIAC_FINANCE_YR a, 
                                 GIAC_CHART_OF_ACCTS b
                           WHERE a.gl_acct_id = b.gl_acct_id(+)
                             AND a.gl_acct_id = a_rec.gl_acct_id
                             AND a.fund_cd = a_rec.fund_cd
                             AND a.branch_cd = a_rec.branch_cd
                             AND a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                             AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))) 
                LOOP
                    v_acct_type     := n.acct_type;
                    v_end_credit_amt:= n.end_credit_amt; --03202009
                    v_end_debit_amt := n.end_debit_amt;
                    v_trans_balance := v_end_debit_amt - v_end_credit_amt; --:=)
                    
                    IF v_acct_type IN ('I', 'E') and v_gl_acct_id <> v_profit_loss_acct THEN
                        IF v_trans_balance <> 0 THEN --03202009
                            v_finance_beg_debit_amt  := n.end_debit_amt;
                            v_finance_beg_credit_amt := n.end_credit_amt;
                        ELSE --:=)
                            v_finance_beg_debit_amt  := 0;
                            v_finance_beg_credit_amt := 0;
                        END IF;
                    ELSE
                        v_finance_beg_debit_amt := n.end_debit_amt;
                        v_finance_beg_credit_amt := n.end_credit_amt; 
                    END IF;
                    
                    EXIT;
                END LOOP;  
                     
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF;
                    
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            ELSE       
                FOR c IN (SELECT NVL(end_debit_amt, 0) end_debit_amt, 
                                 NVL(end_credit_amt, 0) end_credit_amt
                            FROM giac_finance_yr
                           WHERE gl_acct_id = a_rec.gl_acct_id
                             AND fund_cd = a_rec.fund_cd
                             AND branch_cd = a_rec.branch_cd
                             AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                                (p_tran_mm - 1))) 
                LOOP
                    v_finance_beg_debit_amt  := c.end_debit_amt;
                    v_finance_beg_credit_amt := c.end_credit_amt;
                    EXIT;
                END LOOP; 
                       
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF;
                        
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            END IF; 
            
            v_finance_end_debit_amt  := NVL(v_finance_beg_debit_amt, 0) + NVL(a_rec.trans_debit_bal, 0);
            v_finance_end_credit_amt := NVL(v_finance_beg_credit_amt, 0) + NVL(a_rec.trans_credit_bal, 0);
            v_finance_trans_balance  := v_finance_end_debit_amt - v_finance_end_credit_amt; 
                                
            INSERT INTO giac_finance_yr(gl_acct_id, fund_cd, 
                                        branch_cd, tran_year, tran_mm,
                                        beg_debit_amt, beg_credit_amt, 
                                        trans_debit_bal, trans_credit_bal,
                                        end_debit_amt, end_credit_amt,
                                        trans_balance, close_tag)
            VALUES(a_rec.gl_acct_id, a_rec.fund_cd,
                   a_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_finance_beg_debit_amt, v_finance_beg_credit_amt,
                   a_rec.trans_debit_bal, a_rec.trans_credit_bal,
                   v_finance_end_debit_amt, v_finance_end_credit_amt,
                   v_finance_trans_balance, 'N');    
                    
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_finance_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_finance_yr.');
            END IF;
    
            INSERT INTO giac_fiscal_yr(gl_acct_id, fund_cd, 
                                       branch_cd, tran_year, tran_mm,
                                       beg_debit_amt, beg_credit_amt, 
                                       trans_debit_bal, trans_credit_bal,
                                       end_debit_amt, end_credit_amt,
                                       trans_balance, close_tag)
            VALUES(a_rec.gl_acct_id, a_rec.fund_cd,
                   a_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_finance_beg_debit_amt, v_finance_beg_credit_amt,
                   a_rec.trans_debit_bal, a_rec.trans_credit_bal,
                   v_finance_end_debit_amt, v_finance_end_credit_amt,
                   v_finance_trans_balance, 'N');
       
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_fiscal_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_fiscal_yr.');
            END IF;
            
            ----------------------------------------------------------------
            v_new_post_tag := '3';
            
            UPDATE giac_monthly_totals
               SET post_tag = v_new_post_tag
             WHERE gl_acct_id = a_rec.gl_acct_id
               AND fund_cd = a_rec.fund_cd
               AND branch_cd = a_rec.branch_cd
               AND tran_year = p_tran_year
               AND tran_mm = p_tran_mm;
              
            IF SQL%NOTFOUND THEN
                --msg_alert('Error updating giac_monthly_totals.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error updating giac_monthly_totals.');
            END IF;
                                 
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_end_debit_amt     := NULL;
            v_finance_end_credit_amt    := NULL;
            v_finance_trans_balance     := NULL;
            v_new_post_tag              := NULL;
        END LOOP;
        
        ------------------------------------------------------------
        FOR b_rec in b_cur LOOP
            v_gl_acct_id := b_rec.gl_acct_id;
            
            IF (p_gl_no = 1 AND v_prev_mm = p_finance_end) OR (p_gl_no = 2 AND v_prev_mm = p_finance_end) THEN
                FOR y IN (SELECT a.gl_acct_id, a.end_debit_amt, a.end_credit_amt, b.acct_type
                            FROM GIAC_FINANCE_YR a, 
                                 GIAC_CHART_OF_ACCTS b
                           WHERE a.gl_acct_id = b.gl_acct_id(+)
                             AND a.gl_acct_id = b_rec.gl_acct_id
                             AND a.fund_cd = b_rec.fund_cd
                             AND a.branch_cd = b_rec.branch_cd
                             AND a.tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
                             AND a.tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1))) 
                LOOP
                    v_acct_type     := y.acct_type;
                    v_end_credit_amt:= y.end_credit_amt; --03202009 alfie
                    v_end_debit_amt := y.end_debit_amt;
                    v_trans_balance := v_end_debit_amt - v_end_credit_amt; --:=)
                    
                    IF v_acct_type IN ('I', 'E') and v_gl_acct_id <> v_profit_loss_acct THEN
                        IF v_trans_balance <> 0 THEN  -- 03202009 alfie
                            v_finance_beg_debit_amt  := y.end_debit_amt;
                            v_finance_beg_credit_amt :=y.end_credit_amt;
                        ELSE --:=)
                            v_finance_beg_debit_amt  := 0;
                            v_finance_beg_credit_amt := 0;
                        END IF;
                    ELSE
                       v_finance_beg_debit_amt  := y.end_debit_amt;
                       v_finance_beg_credit_amt := y.end_credit_amt; 
                    END IF;
                    
                    EXIT;
                END LOOP;    
                   
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF;     
              
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
              
            ELSE       
                FOR z IN (SELECT NVL(end_debit_amt, 0) end_debit_amt, 
                                 NVL(end_credit_amt, 0) end_credit_amt
                            FROM giac_finance_yr
                           WHERE gl_acct_id = b_rec.gl_acct_id
                             AND fund_cd = b_rec.fund_cd
                             AND branch_cd = b_rec.branch_cd
                             AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),
                                                                   p_tran_year)
                             AND tran_mm = DECODE(p_tran_mm, 1, 12,
                                                               (p_tran_mm - 1))) 
                LOOP
                    v_finance_beg_debit_amt := z.end_debit_amt;
                    v_finance_beg_credit_amt := z.end_credit_amt;
                    EXIT;
                END LOOP; 
                     
                IF v_finance_beg_debit_amt IS NULL THEN
                    v_finance_beg_debit_amt := 0;
                END IF;  
                  
                IF v_finance_beg_credit_amt IS NULL THEN
                    v_finance_beg_credit_amt := 0;
                END IF;
            END IF;
            
            IF v_gl_acct_id IS NOT NULL THEN
                v_trans_debit_balance   := 0;
                v_trans_credit_balance  := 0; 
                v_finance_end_debit_amt := NVL(v_finance_beg_debit_amt, 0) + 0;
                v_finance_end_credit_amt:= NVL(v_finance_beg_credit_amt, 0) + 0;
                v_finance_trans_balance := v_finance_end_debit_amt -  v_finance_end_credit_amt;
            /*ELSE
                v_trans_debit_balance       := b_rec.trans_debit_bal;
                v_trans_credit_balance      := b_rec.trans_credit_bal; 
                v_finance_end_debit_amt     := NVL(v_finance_beg_debit_amt, 0) + NVL(v_trans_debit_balance, 0);
                v_finance_end_credit_amt    := NVL(v_finance_beg_credit_amt, 0) +  NVL(v_trans_credit_balance, 0);
                v_finance_trans_balance     := v_finance_end_debit_amt -  v_finance_end_credit_amt;*/
            END IF;  
            
            INSERT INTO giac_finance_yr(gl_acct_id, fund_cd, 
                                        branch_cd, tran_year, tran_mm,
                                        beg_debit_amt, beg_credit_amt, 
                                        trans_debit_bal, trans_credit_bal,
                                        end_debit_amt, end_credit_amt,
                                        trans_balance, close_tag)
            VALUES(b_rec.gl_acct_id, b_rec.fund_cd,
                   b_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_finance_beg_debit_amt, v_finance_beg_credit_amt,
                   v_trans_debit_balance, v_trans_credit_balance,
                   v_finance_end_debit_amt, v_finance_end_credit_amt,
                   v_finance_trans_balance, 'N');
           
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_finance_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_finance_yr.');
            END IF;
            
            INSERT INTO giac_fiscal_yr(gl_acct_id, fund_cd, 
                                       branch_cd, tran_year, tran_mm,
                                       beg_debit_amt, beg_credit_amt, 
                                       trans_debit_bal, trans_credit_bal,
                                       end_debit_amt, end_credit_amt,
                                       trans_balance, close_tag)
            VALUES(b_rec.gl_acct_id, b_rec.fund_cd,
                   b_rec.branch_cd, p_tran_year, p_tran_mm,
                   v_finance_beg_debit_amt, v_finance_beg_credit_amt,
                   v_trans_debit_balance, v_trans_credit_balance,
                   v_finance_end_debit_amt, v_finance_end_credit_amt,
                   v_finance_trans_balance, 'N');
           
            IF SQL%NOTFOUND THEN
                --msg_alert('Error inserting into giac_fiscal_yr.', 'E', TRUE);
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Error inserting into giac_fiscal_yr.');
            END IF;
            
            ---------------------------------------------------------
            v_new_post_tag := '3';
            
            UPDATE giac_monthly_totals
               SET post_tag = v_new_post_tag
             WHERE gl_acct_id NOT IN (SELECT gl_acct_id
                                        FROM giac_monthly_totals
                                       WHERE tran_year = p_tran_year
                                         AND tran_mm = p_tran_mm)
               AND fund_cd = b_rec.fund_cd
               AND branch_cd = b_rec.branch_cd
               AND tran_year = DECODE(p_tran_mm, 1, (p_tran_year - 1),p_tran_year)
               AND tran_mm = DECODE(p_tran_mm, 1, 12,(p_tran_mm - 1));
               
            /*IF SQL%NOTFOUND THEN
                msg_alert('Error updating giac_monthly_totals.', 'E', TRUE);
            END IF;   */
                     
                        
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_beg_debit_amt     := NULL;
            v_finance_beg_credit_amt    := NULL;
            v_finance_end_debit_amt     := NULL;
            v_finance_end_credit_amt    := NULL;
            v_finance_trans_balance     := NULL;
            v_new_post_tag              := NULL;
        END LOOP; 
        
    END post_to_both_gl;
    
END GIACS410_PKG;
/


