CREATE OR REPLACE PACKAGE BODY CPI.GIACS032_PKG
AS
   FUNCTION get_giacs032_fund_lov
   RETURN giacs032_fund_lov_tab PIPELINED
   IS
      v_list giacs032_fund_lov_type;
   BEGIN
        FOR i IN (
            SELECT fund_cd, fund_desc
              FROM giis_funds
        )
        LOOP
            v_list.fund_cd    := i.fund_cd;  
            v_list.fund_desc  := i.fund_desc;
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs032_branch_lov(
        p_fund_cd       VARCHAR2,
        p_user_id       VARCHAR2
   )
   RETURN giacs032_branch_lov_tab PIPELINED
   IS
      v_list giacs032_branch_lov_type;
   BEGIN
        FOR i IN (
            SELECT branch_cd, branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = p_fund_cd
               AND check_user_per_iss_cd_acctg2(NULL, branch_cd, 'GIACS032', p_user_id) = 1
        )
        LOOP
            v_list.branch_cd    := i.branch_cd;  
            v_list.branch_name  := i.branch_name;
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   
   FUNCTION get_giacs032_list(
        p_fund_cd          VARCHAR2,
        p_branch_cd        VARCHAR2,
        p_check_flag       VARCHAR2
   ) 
   RETURN giacs032_rec_tab PIPELINED
   IS
      v_list giacs032_rec_type;
   BEGIN
        FOR i IN (
                SELECT *
                  FROM giac_pdc_checks
                 WHERE check_flag = NVL(p_check_flag, check_flag)
                   AND gacc_tran_id IN (    
                          SELECT gacc_tran_id
                            FROM giac_order_of_payts
                           WHERE gibr_gfun_fund_cd = p_fund_cd
                             AND gibr_branch_cd = p_branch_cd)
        )
        LOOP
            v_list.item_id          := i.item_id;         
            v_list.gacc_tran_id     := i.gacc_tran_id;    
            v_list.bank_cd          := i.bank_cd;         
            v_list.check_no         := i.check_no;        
            v_list.check_date       := i.check_date;      
            v_list.ref_no           := i.ref_no;          
            v_list.amount           := i.amount;          
            v_list.currency_cd      := i.currency_cd;     
            v_list.currency_rt      := i.currency_rt;     
            v_list.fcurrency_amt    := i.fcurrency_amt;   
            v_list.particulars      := i.particulars;     
            v_list.user_id          := i.user_id;         
            v_list.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');   
            v_list.item_no          := i.item_no;         
            v_list.check_flag       := i.check_flag;      
            v_list.group_no         := i.group_no;        
            v_list.gibr_branch_cd   := i.gibr_branch_cd;  
            v_list.gfun_fund_cd     := i.gfun_fund_cd;    
            v_list.gacc_tran_id_new := i.gacc_tran_id_new;
            
           SELECT bank_sname
              INTO v_list.bank_sname
              FROM giac_banks
             WHERE bank_cd = i.bank_cd;
             
            SELECT rv_meaning
              INTO v_list.status
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_PDC_CHECKS.CHECK_FLAG'
               AND rv_low_value = i.check_flag;
               
             FOR j IN (
                    SELECT tran_year, tran_month, tran_seq_no
                      FROM giac_acctrans
                     WHERE tran_id = i.gacc_tran_id_new
             )
             LOOP
                v_list.tran_year    := j.tran_year; 
                v_list.tran_month   := j.tran_month; 
                v_list.tran_seq_no  := j.tran_seq_no;
             END LOOP;
             
             FOR j IN (
                    SELECT due_dcb_date dcb_date
                      FROM giac_collection_dtl
                     WHERE gacc_tran_id = i.gacc_tran_id
                      and item_no = i.item_no
             )
             LOOP
                v_list.dcb_date    := TRUNC (j.dcb_date);
             END LOOP;
             
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE get_for_deposit_dtl(
        p_fund_cd         IN     VARCHAR2,
        p_branch_cd       IN     VARCHAR2,
        p_dcb_date        IN     VARCHAR2,
        v_dcb_no             OUT NUMBER,
        v_flag               OUT VARCHAR2,
        v_tran_date          OUT VARCHAR2
   )
   IS
   BEGIN
         SELECT MIN(dcb_no), dcb_flag, trunc(tran_date)  
           INTO v_dcb_no, v_flag, v_tran_date
           FROM giac_colln_batch
          WHERE fund_cd                          = p_fund_cd
            AND branch_cd                        = p_branch_cd
            AND dcb_year                         = TO_NUMBER(TO_CHAR(TO_DATE(p_dcb_date, 'MM-DD-YYYY'), 'YYYY'))
            AND trunc(tran_date)                 = TO_DATE(p_dcb_date, 'MM-DD-YYYY')
--            AND dcb_flag                         = 'O'
          GROUP BY dcb_flag, tran_date;
   EXCEPTION
        WHEN OTHERS THEN
            v_dcb_no    := '';
            v_flag      := '';
            v_tran_date := '';
   END;
   
   PROCEDURE save_for_deposit(
        p_item_id       VARCHAR2,
        p_dcb_no        VARCHAR2,
        p_dcb_date      VARCHAR2,
        p_tran_id       VARCHAR2,
        p_item_no       VARCHAR2
   )
   IS
   BEGIN 
       UPDATE giac_pdc_checks
          SET check_flag = 'F'
        WHERE item_id = p_item_id;
        
       UPDATE giac_collection_dtl
          SET due_dcb_no   = p_dcb_no,
              due_dcb_date = to_date(p_dcb_date,'MM-DD-YYYY') 
        WHERE gacc_tran_id = p_tran_id
          AND pay_mode     = 'PDC'
          AND item_no      = p_item_no;
   END;
   
   
   FUNCTION get_giacs032_rep_history(
        p_fund_cd          VARCHAR2,
        p_branch_cd        VARCHAR2,
        p_tran_id          VARCHAR2,
        p_item_no          VARCHAR2
   ) 
   RETURN giacs032_rep_history_tab PIPELINED
   IS
      v_list giacs032_rep_history_type;
   BEGIN
        FOR i IN (
                SELECT *
                  FROM giac_repl_pay_hist
                 WHERE fund_cd      = p_fund_cd
                   AND branch_cd    = p_branch_cd
                   AND gacc_tran_id = p_tran_id
                   AND item_no      = p_item_no
        )
        LOOP
            v_list.history_id      := i.history_id;     
            v_list.fund_cd         := i.fund_cd;         
            v_list.branch_cd       := i.branch_cd;       
            v_list.gacc_tran_id    := i.gacc_tran_id;    
            v_list.item_no         := i.item_no;         
            v_list.old_pay_mode    := i.old_pay_mode;    
            v_list.new_pay_mode    := i.new_pay_mode;    
            v_list.old_amount      := i.old_amount;      
            v_list.new_amount      := i.new_amount;      
            v_list.user_id         := i.user_id;         
            v_list.last_update     := i.last_update;     
            v_list.override_user   := i.override_user;   
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs032_bank_lov
   RETURN giacs032_bank_lov_tab PIPELINED
   IS
      v_list giacs032_bank_lov_type;
   BEGIN
        FOR i IN (
              SELECT gban.bank_sname dsp_bank_sname,
                     gban.bank_name dsp_bank_name, gban.bank_cd bank_cd
                FROM giac_banks gban
            ORDER BY gban.bank_sname
        )
        LOOP
            v_list.bank_cd      := i.bank_cd;  
            v_list.bank_name    := i.dsp_bank_name;
            v_list.bank_sname   := i.dsp_bank_sname;
                   
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   
   FUNCTION get_giacs032_currency_lov
   RETURN giacs032_currency_lov_tab PIPELINED
   IS
      v_list giacs032_currency_lov_type;
   BEGIN
        FOR i IN (
              SELECT a430.short_name dsp_short_name,
                     a430.currency_desc dsp_currency_desc,
                     a430.main_currency_cd currency_cd, a430.currency_rt currency_rt
                FROM giis_currency a430
        )
        LOOP
            v_list.main_currency_cd     := i.currency_cd;  
            v_list.currency_desc        := i.dsp_currency_desc;
            v_list.currency_rt          := i.currency_rt;
            v_list.short_name           := i.dsp_short_name;     
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE save_replace_pdc(
      v_rec         GIAC_COLLECTION_DTL%ROWTYPE,
      p_fund_cd     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_old_amt     NUMBER,
      p_item_id     NUMBER
   )
   IS
        max_hist_id     NUMBER(8);
        v_item_no       NUMBER(8);
        v_fc_gross_amt  NUMBER(12,2);
        v_fc_comm_amt   NUMBER(12,2);
        v_fc_tax_amt    NUMBER(12,2);
        v_fcurrency_amt NUMBER(12,2);
   BEGIN
       DELETE giac_collection_dtl 
         WHERE gacc_tran_id = v_rec.gacc_tran_id
           AND pay_mode     = 'PDC'
           AND item_no      = v_rec.item_no;
           
        SELECT MAX (history_id)+ 1 hist_id 
          INTO max_hist_id
          FROM giac_repl_pay_hist;
          
    INSERT INTO giac_repl_pay_hist
                (branch_cd, fund_cd, gacc_tran_id, history_id,
                 item_no, old_pay_mode, new_pay_mode, old_amount, new_amount,
                 user_id, last_update, override_user
                )
         VALUES (p_branch_cd, p_fund_cd, v_rec.gacc_tran_id, max_hist_id,
                 v_rec.item_no, 'PDC', v_rec.pay_mode, p_old_amt, v_rec.amount,
                 v_rec.user_id, SYSDATE, v_rec.user_id
                );
                
        FOR cur3 IN (SELECT nvl(max(item_no),0)item_no
                       FROM giac_collection_dtl
                      WHERE gacc_tran_id = v_rec.gacc_tran_id)
        LOOP
          v_item_no := cur3.item_no;
          EXIT;
        END LOOP;
        
        v_item_no := v_rec.item_no + v_item_no;
        
        v_fc_gross_amt  := v_rec.gross_amt * v_rec.currency_rt;
        v_fc_comm_amt   := v_rec.commission_amt * v_rec.currency_rt;
        v_fc_tax_amt    := v_rec.vat_amt        * v_rec.currency_rt;
        v_fcurrency_amt := v_rec.amount * v_rec.currency_rt;
        
        INSERT INTO giac_collection_dtl
                (gacc_tran_id, item_no, pay_mode, amount, currency_cd, 
                 currency_rt, due_dcb_date, due_dcb_no, bank_cd, 
                 gross_amt, commission_amt, vat_amt,
                 fc_gross_amt, fc_comm_amt, fc_tax_amt, fcurrency_amt,
                 user_id, last_update
                )
         VALUES (v_rec.gacc_tran_id, v_item_no, v_rec.pay_mode, v_rec.amount, v_rec.currency_cd, 
                 v_rec.currency_rt, v_rec.due_dcb_date, v_rec.due_dcb_no, v_rec.bank_cd,
                 v_rec.gross_amt, v_rec.commission_amt, v_rec.vat_amt,
                 v_fc_gross_amt, v_fc_comm_amt, v_fc_tax_amt, v_fcurrency_amt,
                 v_rec.user_id, sysdate
                );
                
        UPDATE giac_pdc_checks
           SET check_flag = 'R',
               user_id = v_rec.user_id,
               last_update = SYSDATE
         WHERE item_id = p_item_id;
   END;
   
   PROCEDURE apply_pdc_payts(
        p_item_id       NUMBER,
        p_gacc_tran_id  NUMBER,
        p_fund_cd       VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_new_tran_id   OUT NUMBER,
        p_group_no      OUT NUMBER
   )
   IS
        v_group_no  giac_pdc_checks.group_no%TYPE;
        v_exists    VARCHAR2(1);
        v_gacc_tran_id NUMBER(12);
   BEGIN
        SELECT group_no_s.NEXTVAL
          INTO v_group_no
          FROM DUAL;
          
        UPDATE giac_pdc_checks
            SET group_no   = v_group_no,
                check_flag = 'W'
          WHERE item_id = p_item_id;  
         
        v_exists := 'N'; 
        FOR cur3 IN (
                  SELECT '1'
                    FROM giac_pdc_checks
                   WHERE gacc_tran_id_new = p_gacc_tran_id
        )
        LOOP
           v_exists := 'Y';
        END LOOP;
        
        IF v_exists = 'N' THEN
            create_records_in_acctrans(p_fund_cd, p_branch_cd, NULL, NULL, v_gacc_tran_id);
        END IF;
        
        BEGIN
             UPDATE giac_pdc_checks
                SET gacc_tran_id_new = v_gacc_tran_id
              WHERE group_no         = v_group_no
                AND gfun_fund_cd     = p_fund_cd 
                AND gibr_branch_cd   = p_branch_cd;  
        END;
        
        p_new_tran_id := v_gacc_tran_id;
        p_group_no := v_group_no;
          
   END;
   
   PROCEDURE create_records_in_acctrans(
      p_fund_cd            giac_pdc_checks.gfun_fund_cd%TYPE,
      p_branch_cd          giac_pdc_checks.gibr_branch_cd%TYPE,
      p_rev_tran_date      giac_acctrans.tran_date%TYPE,
      p_rev_tran_class_no  giac_acctrans.tran_class_no%TYPE,
      p_gacc_tran_id       OUT NUMBER
   )
   IS
      v_c1             VARCHAR2(1);
      v_c2             VARCHAR2(1);
      v_tran_id        giac_acctrans.tran_id%TYPE;
      v_last_update    giac_acctrans.last_update%TYPE;
      v_user_id        giac_acctrans.user_id%TYPE;
      v_closed_tag     giac_tran_mm.closed_tag%TYPE;
      v_tran_flag      giac_acctrans.tran_flag%TYPE;
      v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
      v_particulars    giac_acctrans.particulars%TYPE;
      v_tran_date      giac_acctrans.tran_date%TYPE;
      v_tran_year      giac_acctrans.tran_year%TYPE;
      v_tran_month     giac_acctrans.tran_month%TYPE; 
      v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
   BEGIN
        BEGIN
          SELECT acctran_tran_id_s.nextval
            INTO v_tran_id
            FROM dual;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error ('ACCTRAN_TRAN_ID sequence not found.', 'E', TRUE);
        END;
        
        v_tran_flag   := 'O';
        v_particulars := NULL;
        v_user_id     := USER;
        v_tran_date   := SYSDATE;
        v_tran_year   := TO_NUMBER(TO_CHAR(v_tran_date, 'YYYY'));
        v_tran_month  := TO_NUMBER(TO_CHAR(v_tran_date, 'MM'));
        v_tran_seq_no := giac_sequence_generation(p_fund_cd, p_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
        
        INSERT INTO giac_acctrans
                    (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date, tran_flag,
                     tran_class, tran_class_no, particulars, tran_year,
                     tran_month, tran_seq_no, user_id, last_update
                    )
             VALUES (v_tran_id, p_fund_cd, p_branch_cd, v_tran_date, v_tran_flag,
                     'PDC', v_tran_class_no, v_particulars, v_tran_year,
                     v_tran_month, v_tran_seq_no, v_user_id, v_last_update
                    );
                    
        p_gacc_tran_id := v_tran_id;        
   END;
   
END;
/


