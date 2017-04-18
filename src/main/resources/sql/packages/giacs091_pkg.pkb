CREATE OR REPLACE PACKAGE BODY CPI.GIACS091_PKG
AS
   FUNCTION get_giacs091_branch_lov(
        p_search        VARCHAR2,
        p_user          VARCHAR2,
        p_fund_cd       VARCHAR2 -- apollo cruz 09.16.2015 sr#20107
   ) 
   RETURN giacs091_branch_lov_tab PIPELINED
   IS
      v_list giacs091_branch_lov_type;
   BEGIN
        FOR i IN (
          SELECT branch_cd, branch_name
            FROM giac_branches
           WHERE gfun_fund_cd = p_fund_cd
             AND check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS091', p_user) = 1
             AND (branch_cd LIKE (p_search)
              OR UPPER(branch_name) LIKE UPPER(p_search))
           ORDER BY branch_cd
        )
        LOOP
            v_list.branch_cd    := i.branch_cd;
            v_list.branch_name  := i.branch_name;
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   
   FUNCTION get_giacs091_list(
        p_date          VARCHAR2,
        p_fund_cd       VARCHAR2, -- apollo cruz 09.17.2015 sr#20107
        p_branch        VARCHAR2
   ) 
   RETURN giacs091_rec_tab PIPELINED
   IS
      v_list giacs091_rec_type;
   BEGIN
        FOR i IN (
                SELECT apdc_id, pdc_id, bank_cd, bank_branch, item_no, check_class, check_no,
                       check_date, check_amt, currency_cd, currency_rt, check_flag, gross_amt,
                       commission_amt, vat_amt, gacc_tran_id, payor, address_1, address_2,
                       address_3, tin, particulars, pay_mode, intm_no, fc_comm_amt,
                       fc_gross_amt, fc_tax_amt, fcurrency_amt, remarks
                  FROM giac_apdc_payt_dtl a
                 WHERE check_flag NOT IN ('C', 'R', 'A')
                   AND check_date <= TO_DATE (p_date, 'mm-dd-yyyy')
                   AND EXISTS (
                          SELECT 'X'
                            FROM giac_apdc_payt b
                           WHERE a.apdc_id = b.apdc_id
                             AND b.fund_cd = p_fund_cd  -- apollo cruz 09.17.2015 sr#20107
                             AND b.branch_cd = p_branch --modified by jdiago 08.07.2014 : from default 'HO' to p_branch_cd
                             AND apdc_flag = 'P'
                             AND apdc_no IS NOT NULL
                             )
        )
        LOOP
            v_list.apdc_id        := i.apdc_id;       
            v_list.pdc_id         := i.pdc_id;        
            v_list.bank_cd        := i.bank_cd;
            v_list.bank_branch    := i.bank_branch;   
            v_list.item_no        := i.item_no;       
            v_list.check_class    := i.check_class;   
            v_list.check_no       := i.check_no;      
            v_list.check_date     := i.check_date;    
            v_list.check_amt      := i.check_amt;     
            v_list.currency_cd    := i.currency_cd;   
            v_list.currency_rt    := i.currency_rt;   
            v_list.check_flag     := i.check_flag;    
            v_list.gross_amt      := i.gross_amt;     
            v_list.commission_amt := i.commission_amt;
            v_list.vat_amt        := i.vat_amt;       
            v_list.gacc_tran_id   := i.gacc_tran_id;  
            v_list.payor          := i.payor;         
            v_list.address_1      := i.address_1;     
            v_list.address_2      := i.address_2;     
            v_list.address_3      := i.address_3;     
            v_list.tin            := i.tin;           
            v_list.particulars    := i.particulars;   
            v_list.pay_mode       := i.pay_mode;      
            v_list.intm_no        := i.intm_no;       
            v_list.fc_comm_amt    := i.fc_comm_amt;   
            v_list.fc_gross_amt   := i.fc_gross_amt;
            v_list.fc_tax_amt     := i.fc_tax_amt;
            v_list.fcurrency_amt  := i.fcurrency_amt;     
            v_list.remarks        := i.remarks;
            
            BEGIN
                SELECT bank_sname
                  INTO v_list.bank_sname
                  FROM giac_banks
                 WHERE bank_cd = i.bank_cd;
            EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            BEGIN      
                SELECT short_name, currency_desc, currency_rt
                  INTO v_list.short_name, v_list.currency_desc, v_list.convert_rt
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
              EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;  
            END;
            
            BEGIN
                SELECT rv_meaning
                  INTO v_list.nbt_status
                  FROM cg_ref_codes
                 WHERE rv_low_value = i.check_flag
                   AND rv_domain = 'GIAC_APDC_PAYT_DTL.CHECK_FLAG';
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;  
            END;
            
            BEGIN
                SELECT apdc_pref || '-' || apdc_no
                  INTO v_list.nbt_apdc_no
                  FROM giac_apdc_payt
                 WHERE apdc_flag = 'P' 
                   AND apdc_id = i.apdc_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN NULL;  
            END;
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE set_giacs091_rec(
        p_pdc_id        giac_apdc_payt_dtl.pdc_id%TYPE,
        p_remarks       giac_apdc_payt_dtl.remarks%TYPE,
        p_user_id       giac_apdc_payt_dtl.user_id%TYPE
   )
   IS
   BEGIN
        UPDATE giac_apdc_payt_dtl
           SET remarks = p_remarks, user_id = p_user_id, last_update = SYSDATE
         WHERE pdc_id = p_pdc_id;
   END;
   
   
   PROCEDURE set_or_particulars(
        p_pdc_id        giac_apdc_payt_dtl.pdc_id%TYPE,     
        p_payor         giac_apdc_payt_dtl.payor%TYPE,      
        p_address_1     giac_apdc_payt_dtl.address_1%TYPE,  
        p_address_2     giac_apdc_payt_dtl.address_2%TYPE,  
        p_address_3     giac_apdc_payt_dtl.address_3%TYPE,  
        p_tin           giac_apdc_payt_dtl.tin%TYPE,        
        p_intm_no       giac_apdc_payt_dtl.intm_no%TYPE,    
        p_particulars   giac_apdc_payt_dtl.particulars%TYPE,
        p_user_id       giac_apdc_payt_dtl.user_id%TYPE    
   )
   IS
   BEGIN
        UPDATE giac_apdc_payt_dtl
           SET payor = p_payor, address_1 = p_address_1, address_2 = p_address_2, address_3 = p_address_3,
               tin = p_tin, intm_no = p_intm_no, particulars = p_particulars, user_id = p_user_id, last_update = SYSDATE
         WHERE pdc_id = p_pdc_id;
   END;
   
   
   FUNCTION get_giacs091_details_list(
        p_pdc_id        VARCHAR2
   ) 
   RETURN giacs091_rec_details_tab PIPELINED
   IS
      v_list giacs091_rec_details_type;
   BEGIN
        --added table giac_apdc_payt_dtl for nvl of currency_cd, currency_rt and fcurrency_amt : jdiago 08.26.2014
        FOR i IN (SELECT a.pdc_id, a.transaction_type, a.iss_cd, a.prem_seq_no, 
                         a.inst_no, a.collection_amt, a.user_id, a.last_update,
                         NVL (a.currency_cd, b.currency_cd) currency_cd,
                         NVL (a.currency_rt, b.currency_rt) currency_rt, 
                         a.premium_amt, a.tax_amt, 
                         NVL (a.fcurrency_amt, b.fcurrency_amt) fcurrency_amt
                    FROM giac_pdc_prem_colln a, giac_apdc_payt_dtl b
                   WHERE a.pdc_id = p_pdc_id 
                     AND a.pdc_id = b.pdc_id
                   ORDER BY inst_no
        )
        LOOP
            v_list.pdc_id          := i.pdc_id;          
            v_list.transaction_type:= i.transaction_type;
            v_list.iss_cd          := i.iss_cd;          
            v_list.prem_seq_no     := i.prem_seq_no;     
            v_list.inst_no         := i.inst_no;         
            v_list.collection_amt  := i.collection_amt;  
            v_list.user_id         := i.user_id;         
            v_list.last_update     := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');   
            v_list.currency_cd     := i.currency_cd;     
            v_list.currency_rt     := i.currency_rt;     
            v_list.premium_amt     := i.premium_amt;     
            v_list.tax_amt         := i.tax_amt;
            v_list.fcurrency_amt   := i.fcurrency_amt;      
            
            
            FOR a IN (SELECT c.policy_id, d.assd_name 
                    FROM giis_assured d, gipi_parlist e, gipi_polbasic c, gipi_invoice b, 
                         giac_aging_soa_details a 
                     WHERE e.assd_no = d.assd_no 
                         AND e.assd_no = d.assd_no 
                     AND e.assd_no = d.assd_no 
                     AND c.par_id = e.par_id 
                     AND a.policy_id = c.policy_id 
                     AND a.prem_seq_no = b.prem_seq_no 
                     AND a.iss_cd = b.iss_cd 
                     AND a.balance_amt_due > 0 
                     AND a.iss_cd = i.iss_cd
                     AND b.prem_seq_no = i.prem_seq_no
            )
            LOOP
                 v_list.dsp_assured     := a.assd_name;
                 v_list.dsp_policy_no   := get_policy_no(a.policy_id);
                 EXIT;
            END LOOP; 
                     
            BEGIN      
                SELECT currency_desc
                  INTO v_list.dsp_currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
              EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;  
            END;     
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   
   FUNCTION get_giacs091_bank_lov(
        p_search        VARCHAR2
   ) 
   RETURN giacs091_bank_lov_tab PIPELINED
   IS
      v_list giacs091_bank_lov_type;
   BEGIN
        FOR i IN (
             SELECT DISTINCT gbac.bank_cd, gban.bank_name
               FROM giac_bank_accounts gbac, giac_banks gban
              WHERE gbac.bank_cd = gban.bank_cd
                AND gbac.bank_account_flag = 'A'
                AND gbac.opening_date < SYSDATE
                AND NVL (gbac.closing_date, SYSDATE + 1) > SYSDATE
                AND (gbac.bank_cd LIKE (p_search)
                 OR UPPER(gban.bank_name) LIKE UPPER(p_search))
           ORDER BY 2
        )
        LOOP
            v_list.bank_cd    := i.bank_cd;  
            v_list.bank_name  := i.bank_name;
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   
   FUNCTION get_giacs091_bank_acct_lov(
        p_search        VARCHAR2,
        p_bank_cd       VARCHAR2
   ) 
   RETURN giacs091_bank_acct_lov_tab PIPELINED
   IS
      v_list giacs091_bank_acct_lov_type;
   BEGIN
        FOR i IN (
              SELECT gbac.bank_acct_cd, gbac.bank_acct_no, gbac.bank_acct_type,
                     gbac.branch_cd
                FROM giac_bank_accounts gbac
               WHERE gbac.bank_account_flag = 'A'
                 AND gbac.bank_cd = p_bank_cd
                 AND gbac.opening_date < SYSDATE
                 AND NVL (gbac.closing_date, SYSDATE + 1) > SYSDATE
                 AND (gbac.bank_acct_cd LIKE (p_search)
                  OR UPPER(gbac.bank_acct_no) LIKE UPPER(p_search))
            ORDER BY 1
        )
        LOOP
            v_list.bank_acct_cd   := i.bank_acct_cd;  
            v_list.bank_acct_no   := i.bank_acct_no;  
            v_list.bank_acct_type := i.bank_acct_type;
            v_list.branch_cd      := i.branch_cd;     
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE multiple_or (
      p_check_date          VARCHAR2,
      p_pdc_id              NUMBER,
      p_bank_cd             VARCHAR2,
      p_bank_acct_cd        VARCHAR2,
      p_message         OUT VARCHAR2,
      p_user_id             VARCHAR2
   )
   IS
      v_last_update    giac_acctrans.last_update%TYPE;
      v_user_id        giac_acctrans.user_id%TYPE;
      v_tran_flag      giac_acctrans.tran_flag%TYPE;
      v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
      v_tran_date      giac_acctrans.tran_date%TYPE;
      v_tran_year      giac_acctrans.tran_year%TYPE;
      v_tran_month     giac_acctrans.tran_month%TYPE; 
      v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
      v_or_date        giac_order_of_payts.or_date%type;    
      v_particulars    giac_order_of_payts.particulars%TYPE;
      v_payor          giac_order_of_payts.payor%TYPE;
      v_address1       giac_order_of_payts.address_1%TYPE;
      v_address2       giac_order_of_payts.address_2%TYPE;
      v_address3       giac_order_of_payts.address_3%TYPE;
      v_cashier_cd     giac_order_of_payts.cashier_cd%TYPE;
      v_collection     giac_order_of_payts.collection_amt%TYPE;
      v_amount         giac_collection_dtl.amount%TYPE;
      v_currency_cd    giac_collection_dtl.currency_cd%TYPE;
      v_currency_rt    giac_collection_dtl.currency_rt%TYPE;
      v_item_no        giac_collection_dtl.item_no%TYPE;
      v_pay_mode       giac_collection_dtl.pay_mode%TYPE;
      v_bank_cd        giac_collection_dtl.bank_cd%TYPE;
      v_check_date     giac_collection_dtl.check_date%TYPE;
      v_check_class    giac_collection_dtl.check_class%TYPE;
      v_check_no       giac_collection_dtl.check_no%TYPE;
      v_fcurrency_amt  giac_collection_dtl.fcurrency_amt%TYPE;
      v_gross_amt      giac_collection_dtl.gross_amt%TYPE;
      v_intm_no        giac_collection_dtl.intm_no%TYPE;
      v_commission_amt giac_collection_dtl.commission_amt%TYPE;
      v_vat_amt        giac_collection_dtl.vat_amt%TYPE;
      v_fc_comm_amt    giac_collection_dtl.fc_comm_amt%TYPE;
      v_fc_gross_amt   giac_collection_dtl.fc_gross_amt%TYPE;
      v_fc_tax_amt     giac_collection_dtl.fc_tax_amt%TYPE;
      v_bank_name      giac_banks.bank_name%TYPE;
      v_apdc_no        giac_order_of_payts.prov_receipt_no%TYPE;
      v_item           giac_collection_dtl.item_no%TYPE;
      
      v_list           giac_apdc_payt_dtl%ROWTYPE;
      
      v_fund_cd        giac_apdc_payt.fund_cd%TYPE;  
      v_branch_cd      giac_apdc_payt.branch_cd%TYPE;
      v_tran_id        giac_acctrans.tran_id%TYPE;
      v_collection_amt giac_pdc_prem_colln.collection_amt%TYPE := 0; --added default value 0 : jdiago 08.19.2014
      
      v_dcb_no         giac_colln_batch.dcb_no%TYPE;
      v_dcb_tran_date  giac_colln_batch.tran_date%TYPE;
    BEGIN        

                SELECT *
                  INTO v_list
                  FROM giac_apdc_payt_dtl
                 WHERE pdc_id = p_pdc_id;
                
                /* Removed by jdiago 08.19.2014 : handle multiple ORs
                BEGIN
                    SELECT collection_amt
                      INTO v_collection_amt
                      FROM giac_pdc_prem_colln
                     WHERE pdc_id = v_list.pdc_id;
                     
                EXCEPTION
                    when no_data_found then
                       v_collection_amt := '';               
                END;
                */
                
                FOR gppc IN (SELECT collection_amt --added by jdiago 08.19.2014 to handle multiple ORs
                               FROM giac_pdc_prem_colln
                              WHERE pdc_id = v_list.pdc_id)
                LOOP
                   v_collection_amt := v_collection_amt + gppc.collection_amt;
                END LOOP;
                
                /*SELECT rv_meaning
                  INTO :gapd.nbt_status
                  FROM cg_ref_codes
                 WHERE rv_low_value = v_list.checkflag
                   AND rv_domain = 'GIAC_APDC_PAYT_DTL.CHECK_FLAG'; */
                      
                FOR a IN (
                        SELECT fund_cd, branch_cd,
                               apdc_pref
                               || '-'
                               || apdc_no
                               || DECODE (ref_apdc_no, NULL, '', '/')
                               || ref_apdc_no apdc_no
                          FROM giac_apdc_payt a, giac_apdc_payt_dtl b
                         WHERE a.apdc_id = b.apdc_id 
                           AND b.pdc_id = p_pdc_id
                )
                LOOP
                    v_fund_cd   := a.fund_cd;
                    v_branch_cd := a.branch_cd;    
                    v_apdc_no   := a.apdc_no;
                END LOOP;

                FOR b IN (
                        SELECT cashier_cd
                          FROM giac_dcb_users
                         WHERE dcb_user_id = p_user_id
                           AND gibr_fund_cd = v_fund_cd
                           AND gibr_branch_cd = v_branch_cd
                )
                LOOP
                    v_cashier_cd := b.cashier_cd;
                END LOOP;    
                    
                FOR c IN (
                        SELECT bank_name
                          FROM giac_banks
                         WHERE bank_cd = p_bank_cd
                )
                LOOP
                    v_bank_name := c.bank_name;
                END LOOP;
                
                v_dcb_tran_date := TO_DATE(p_check_date, 'mm-dd-yyyy'); -- apollo cruz 09.09.2015 sr#20107
                get_dcb_no(v_fund_cd, v_branch_cd, v_dcb_no, v_dcb_tran_date, p_message);
                
                IF p_message != '' THEN
                    RETURN;
                END IF;
                
                                
                SELECT acctran_tran_id_s.NEXTVAL
                  INTO v_tran_id
                  FROM SYS.DUAL;
                    
                v_tran_flag := 'O';
                v_tran_date := TO_DATE(p_check_date, 'MM-DD-YYYY');
                v_or_date := to_date(to_char(v_tran_date, 'MM-DD-YYYY')||' '||to_char(SYSDATE,'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
                v_user_id := p_user_id;
                v_last_update := SYSDATE;
            
                IF v_list.particulars IS NULL OR v_list.payor IS NULL THEN
                  FOR i IN (
                            SELECT particulars, payor
                              FROM giac_apdc_payt
                             WHERE apdc_id = v_list.apdc_id
                  )
                  LOOP
                        v_particulars := i.particulars;
                        v_payor       := i.payor;
                  END LOOP;    
                ELSE
                    v_particulars := v_list.particulars;
                    v_payor       := v_list.payor;
                END IF;
                    
                v_address1      := v_list.address_1;
                v_address2      := v_list.address_2;
                v_address3      := v_list.address_3;
                v_collection    := v_collection_amt;
                v_amount        := v_list.check_amt;
                v_currency_cd   := v_list.currency_cd;
                v_currency_rt   := v_list.currency_rt;
                v_item_no       := v_list.item_no;
                v_pay_mode      := v_list.pay_mode;
                v_bank_cd       := v_list.bank_cd;
                v_check_date    := v_list.check_date;
                v_check_no      := v_list.check_no;
                v_check_class   := v_list.check_class;
                v_fcurrency_amt := v_list.fcurrency_amt;
                v_gross_amt     := v_list.gross_amt;
                v_intm_no       := v_list.intm_no;
                v_commission_amt    := v_list.commission_amt;
                v_vat_amt       := v_list.vat_amt;
                v_fc_comm_amt   := v_list.fc_comm_amt;
                v_fc_gross_amt  := v_list.fc_gross_amt;
                v_fc_tax_amt    := v_list.fc_tax_amt;
                v_tran_class_no := v_dcb_no;
                v_tran_year     := TO_NUMBER(TO_CHAR(v_tran_date, 'YYYY'));
                v_tran_month    := TO_NUMBER(TO_CHAR(v_tran_date, 'MM'));
                v_tran_seq_no   := giac_sequence_generation(v_fund_cd, v_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
                v_item          := 1;
                  
                INSERT INTO giac_acctrans
                            (tran_id, gfun_fund_cd, gibr_branch_cd,
                             tran_date, tran_flag, tran_class, tran_class_no, particulars,
                             tran_year, tran_month, tran_seq_no, user_id,
                             last_update
                            )
                     VALUES (v_tran_id, v_fund_cd, v_branch_cd,
                             v_tran_date, v_tran_flag, 'COL', v_tran_class_no, v_particulars,
                             v_tran_year, v_tran_month, v_tran_seq_no, v_user_id,
                             v_last_update
                            );
                                      
                INSERT INTO giac_order_of_payts
                            (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                             payor, or_date, cashier_cd, dcb_no, or_flag,
                             address_1, address_2, address_3, particulars, collection_amt,
                             currency_cd, gross_amt, gross_tag, intm_no, prov_receipt_no,
                             user_id, last_update
                            )
                     VALUES (v_tran_id, v_fund_cd, v_branch_cd,
                             v_payor, v_or_date, v_cashier_cd, v_dcb_no, 'N',
                             v_address1, v_address2, v_address3, v_particulars, v_amount,
                             v_currency_cd, v_gross_amt, 'Y', v_intm_no, v_apdc_no,
                             v_user_id, v_last_update
                            );          
                                
                INSERT INTO giac_collection_dtl
                            (amount, currency_cd, currency_rt, gacc_tran_id,
                             item_no, pay_mode, bank_cd, check_date, check_no,
                             check_class, particulars, fcurrency_amt, gross_amt,
                             intm_no, commission_amt, vat_amt, fc_comm_amt,
                             fc_gross_amt, fc_tax_amt, dcb_bank_cd,
                             dcb_bank_acct_cd, user_id, last_update, pdc_id --added by john dolon 6.4.2015;
                            )
                     VALUES (v_amount, v_currency_cd, v_currency_rt, v_tran_id,
                             v_item, v_pay_mode, v_bank_cd, v_check_date, v_check_no,
                             v_check_class, v_particulars, v_fcurrency_amt, v_gross_amt,
                             v_intm_no, v_commission_amt, v_vat_amt, v_fc_comm_amt,
                             v_fc_gross_amt, v_fc_tax_amt, p_bank_cd,
                             p_bank_acct_cd, v_user_id, v_last_update, v_list.pdc_id --added by john dolon 6.4.2015;
                            );
                                
                giacs091_pkg.aeg_parameters(v_tran_id, 'GIACS001', v_fund_cd, v_branch_cd, p_message, p_user_id);
                
                IF p_message != '' THEN
                    RETURN;
                END IF;
                    
                UPDATE giac_apdc_payt_dtl
                   SET  gacc_tran_id = v_tran_id, 
                        check_flag = 'A'
                 WHERE apdc_id = v_list.apdc_id
                   AND item_no = v_list.item_no;  
                
               p_message := v_bank_name||' Check No. '||v_check_no||' has been applied to Official Receipts with DCB No. '||
                          v_dcb_no||' cashier '||v_cashier_cd||'.';    
          
    END;
    
    PROCEDURE aeg_parameters(
            aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
            aeg_module_nm   GIAC_MODULES.module_name%TYPE,
            aeg_fund_cd     GIAC_APDC_PAYT.fund_cd%TYPE, 
            aeg_branch_cd   GIAC_APDC_PAYT.branch_cd%TYPE,
            p_message       OUT VARCHAR2,
            p_user_id       VARCHAR2
    ) 
    IS
    
    v_module_id   giac_modules.module_id%TYPE;
    v_gen_type    giac_modules.generation_type%TYPE;
   
      CURSOR PR_cur IS
        SELECT amount, pay_mode, 
               dcb_bank_cd, dcb_bank_acct_cd
          FROM giac_collection_dtl
         WHERE gacc_tran_id = aeg_tran_id;

    BEGIN
          BEGIN
            SELECT module_id,
                   generation_type
              INTO v_module_id,
                   v_gen_type
              FROM giac_modules
             WHERE module_name  = 'GIACS001';
          EXCEPTION
            WHEN no_data_found THEN
                p_message := 'No data found in GIAC MODULES.';
          END;

         
          FOR pr_rec IN pr_cur LOOP
             giacs091_pkg.aeg_create_cib_acct_entries(pr_rec.dcb_bank_cd, pr_rec.dcb_bank_acct_cd, pr_rec.amount, v_gen_type, aeg_tran_id, aeg_fund_cd, aeg_branch_cd, p_message, p_user_id);
          END LOOP;
          
    END;
    
    
    PROCEDURE aeg_create_cib_acct_entries(
        aeg_bank_cd         giac_banks.bank_cd%TYPE,
        aeg_bank_acct_cd    giac_bank_accounts.bank_acct_cd%TYPE,
        aeg_acct_amt        giac_collection_dtl.amount%TYPE,
        aeg_gen_type        giac_acct_entries.generation_type%TYPE,
        aeg_tran_id         giac_acctrans.tran_id%TYPE,
        aeg_fund_cd         giac_apdc_payt.fund_cd%TYPE, 
        aeg_branch_cd       giac_apdc_payt.branch_cd%TYPE,
        p_message           VARCHAR2,
        p_user_id           VARCHAR2
    ) 
    IS
    
    v_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE;
    v_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE;
    v_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE;
    v_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE;
    v_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE;
    v_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE;
    v_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE;
    v_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE;
    v_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE;
    v_dr_cr_tag         giac_chart_of_accts.dr_cr_tag%TYPE;
    v_debit_amt         giac_acct_entries.debit_amt%TYPE;
    v_credit_amt        giac_acct_entries.credit_amt%TYPE;
    v_gl_acct_id        giac_acct_entries.gl_acct_id%TYPE;
    v_sl_cd             giac_acct_entries.sl_cd%TYPE;
    v_sl_type_cd        giac_acct_entries.sl_type_cd%TYPE;
    v_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
    v_sl_source_cd      giac_acct_entries.sl_source_cd%TYPE := '1';
   
    BEGIN
      BEGIN
        SELECT gl_acct_id, sl_cd
          INTO v_gl_acct_id, v_sl_cd
          FROM giac_bank_accounts
          WHERE bank_cd = aeg_bank_cd
          AND bank_acct_cd = aeg_bank_acct_cd;
      EXCEPTION
        WHEN no_data_found THEN
            raise_application_error (-20001, 'No data found in giac_bank_accounts for bank_cd/bank_acct_cd: '||aeg_bank_cd||'/'||aeg_bank_acct_cd);
      END;

        BEGIN
            SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
               gl_sub_acct_2,    gl_sub_acct_3,   gl_sub_acct_4,
               gl_sub_acct_5,    gl_sub_acct_6,   gl_sub_acct_7,
               dr_cr_tag,        gslt_sl_type_cd
          INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,
                     v_gl_sub_acct_2,    v_gl_sub_acct_3,   v_gl_sub_acct_4,
                     v_gl_sub_acct_5,    v_gl_sub_acct_6,   v_gl_sub_acct_7,
                     v_dr_cr_tag,        v_sl_type_cd
            FROM giac_chart_of_accts
         WHERE gl_acct_id = v_gl_acct_id;
        EXCEPTION
            WHEN no_data_found THEN
                raise_application_error (-20001, 'No record in the Chart of Accounts for this GL ID '||to_char(v_gl_acct_id,'fm999999'));
        END;

      /****************************************************************************
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      ****************************************************************************/

      IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := abs(aeg_acct_amt);
        v_credit_amt := 0;
      ELSE
        v_debit_amt  := 0;
        v_credit_amt := abs(aeg_acct_amt);
      END IF;

      /****************************************************************************
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      ****************************************************************************/

       BEGIN
          SELECT nvl(max(acct_entry_id),0) acct_entry_id
            INTO v_acct_entry_id
            FROM giac_acct_entries
         WHERE gacc_gibr_branch_cd = aeg_branch_cd 
           AND gacc_gfun_fund_cd   = aeg_fund_cd 
           AND gacc_tran_id        = aeg_tran_id
           AND gl_acct_id          = v_gl_acct_id
           AND generation_type     = aeg_gen_type
             AND nvl(sl_cd, 0)          = nvl(v_sl_cd, nvl(sl_cd, 0))
             AND nvl(sl_type_cd, '-')   = nvl(v_sl_type_cd, nvl(sl_type_cd, '-'))
             AND nvl(sl_source_cd, '-') = nvl(v_sl_source_cd, nvl(sl_source_cd, '-'));
                
          IF nvl(v_acct_entry_id,0) = 0 THEN
            v_acct_entry_id := nvl(v_acct_entry_id,0) + 1;
            INSERT INTO giac_acct_entries(gacc_tran_id,        gacc_gfun_fund_cd,
                                          gacc_gibr_branch_cd, acct_entry_id,
                                          gl_acct_id,          gl_acct_category,
                                          gl_control_acct,     gl_sub_acct_1,
                                          gl_sub_acct_2,       gl_sub_acct_3,
                                          gl_sub_acct_4,       gl_sub_acct_5,
                                          gl_sub_acct_6,       gl_sub_acct_7,
                                          sl_cd,               debit_amt,
                                          credit_amt,          generation_type,
                                          user_id,             last_update,
                                          sl_type_cd,          sl_source_cd)
                 VALUES (aeg_tran_id,   aeg_fund_cd,
                         aeg_branch_cd, v_acct_entry_id,
                         v_gl_acct_id,          v_gl_acct_category,
                         v_gl_control_acct,     v_gl_sub_acct_1,
                         v_gl_sub_acct_2,       v_gl_sub_acct_3,
                         v_gl_sub_acct_4,       v_gl_sub_acct_5,
                         v_gl_sub_acct_6,       v_gl_sub_acct_7,
                         v_sl_cd,               v_debit_amt,
                         v_credit_amt,          aeg_gen_type,
                         p_user_id,             SYSDATE,
                         v_sl_type_cd ,         v_sl_source_cd);
          ELSE
            UPDATE giac_acct_entries
              SET debit_amt  = debit_amt  + v_debit_amt,
                  credit_amt = credit_amt + v_credit_amt,
                  user_id = p_user_id,
                  last_update = SYSDATE
            WHERE gacc_tran_id           = aeg_tran_id
              AND gacc_gibr_branch_cd    = aeg_branch_cd
              AND gacc_gfun_fund_cd      = aeg_fund_cd
              AND gl_acct_id             = v_gl_acct_id
              AND nvl(sl_cd, 0)          = nvl(v_sl_cd, nvl(sl_cd, 0))
              AND nvl(sl_type_cd, '-')   = nvl(v_sl_type_cd, nvl(sl_type_cd, '-'))
              AND nvl(sl_source_cd, '-') = nvl(v_sl_source_cd, nvl(sl_source_cd, '-'))
              AND generation_type        = aeg_gen_type;
          END IF;
        END;                                     
    END;
    
    PROCEDURE group_or (
      p_check_date          VARCHAR2,
      p_pdc_id              NUMBER,
      p_bank_cd             VARCHAR2,
      p_bank_acct_cd        VARCHAR2,
      p_user_id             VARCHAR2,
      p_tran_id         OUT giac_acctrans.tran_id%TYPE,
      p_particulars     OUT VARCHAR2,
      p_message         OUT VARCHAR2
   )
   IS
      v_last_update    giac_acctrans.last_update%TYPE;
      v_user_id        giac_acctrans.user_id%TYPE;
      v_tran_flag      giac_acctrans.tran_flag%TYPE;
      v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
      v_tran_date      giac_acctrans.tran_date%TYPE;
      v_tran_year      giac_acctrans.tran_year%TYPE;
      v_tran_month     giac_acctrans.tran_month%TYPE; 
      v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
      v_or_date        giac_order_of_payts.or_date%type;    
      v_particulars    giac_order_of_payts.particulars%TYPE;
      v_payor          giac_order_of_payts.payor%TYPE;
      v_address1       giac_order_of_payts.address_1%TYPE;
      v_address2       giac_order_of_payts.address_2%TYPE;
      v_address3       giac_order_of_payts.address_3%TYPE;
      v_cashier_cd     giac_order_of_payts.cashier_cd%TYPE;
      v_collection     giac_order_of_payts.collection_amt%TYPE;
      v_amount         giac_collection_dtl.amount%TYPE;
      v_currency_cd    giac_collection_dtl.currency_cd%TYPE;
      v_currency_rt    giac_collection_dtl.currency_rt%TYPE;
      v_item_no        giac_collection_dtl.item_no%TYPE;
      v_pay_mode       giac_collection_dtl.pay_mode%TYPE;
      v_bank_cd        giac_collection_dtl.bank_cd%TYPE;
      v_check_date     giac_collection_dtl.check_date%TYPE;
      v_check_class    giac_collection_dtl.check_class%TYPE;
      v_check_no       giac_collection_dtl.check_no%TYPE;
      v_fcurrency_amt  giac_collection_dtl.fcurrency_amt%TYPE;
      v_gross_amt      giac_collection_dtl.gross_amt%TYPE;
      v_intm_no        giac_collection_dtl.intm_no%TYPE;
      v_commission_amt giac_collection_dtl.commission_amt%TYPE;
      v_vat_amt        giac_collection_dtl.vat_amt%TYPE;
      v_fc_comm_amt    giac_collection_dtl.fc_comm_amt%TYPE;
      v_fc_gross_amt   giac_collection_dtl.fc_gross_amt%TYPE;
      v_fc_tax_amt     giac_collection_dtl.fc_tax_amt%TYPE;
      v_bank_name      giac_banks.bank_name%TYPE;
      v_apdc_no        giac_order_of_payts.prov_receipt_no%TYPE;
      v_item           giac_collection_dtl.item_no%TYPE;
      
      v_list           giac_apdc_payt_dtl%ROWTYPE;
      
      v_fund_cd        giac_apdc_payt.fund_cd%TYPE;  
      v_branch_cd      giac_apdc_payt.branch_cd%TYPE;
      v_collection_amt giac_pdc_prem_colln.collection_amt%TYPE;
      
      v_dcb_no         giac_colln_batch.dcb_no%TYPE;
      v_dcb_tran_date  giac_colln_batch.tran_date%TYPE;
      v_apdc_id        giac_apdc_payt_dtl.apdc_id%TYPE;
      
    BEGIN        
        /*SELECT rv_meaning
          INTO :gapd.nbt_status
          FROM cg_ref_codes
         WHERE rv_low_value = :gapd.check_flag
           AND rv_domain = 'GIAC_APDC_PAYT_DTL.CHECK_FLAG';*/
           
           null;
       SELECT *
          INTO v_list
          FROM giac_apdc_payt_dtl
         WHERE pdc_id = p_pdc_id;
         
        BEGIN
            SELECT collection_amt
              INTO v_collection_amt
              FROM giac_pdc_prem_colln
             WHERE pdc_id = v_list.pdc_id;
                     
        EXCEPTION
            when no_data_found then
               v_collection_amt := '';               
        END;
                       
        FOR a IN (
            SELECT fund_cd, branch_cd,
                      apdc_pref
                   || '-'
                   || apdc_no
                   || DECODE (ref_apdc_no, NULL, '', '/')
                   || ref_apdc_no apdc_no
              FROM giac_apdc_payt a, giac_apdc_payt_dtl b
             WHERE a.apdc_id = b.apdc_id 
               AND b.pdc_id = p_pdc_id
        )
        LOOP
            v_fund_cd := a.fund_cd;
            v_branch_cd := a.branch_cd;    
            v_apdc_no := a.apdc_no;
        END LOOP;
                
       FOR b IN (
            SELECT cashier_cd
              FROM giac_dcb_users
             WHERE dcb_user_id = p_user_id
               AND gibr_fund_cd = v_fund_cd
               AND gibr_branch_cd = v_branch_cd
       )
       LOOP
           v_cashier_cd := b.cashier_cd;
       END LOOP;    
                
       FOR c IN (
            SELECT bank_name
              FROM giac_banks
             WHERE bank_cd = p_bank_cd
       )
       LOOP
            v_bank_name := c.bank_name;
       END LOOP;
       
       v_dcb_tran_date := TO_DATE(p_check_date, 'mm-dd-yyyy'); -- apollo cruz 09.09.2015 sr#20107     
       get_dcb_no(v_fund_cd, v_branch_cd, v_dcb_no, v_dcb_tran_date, p_message);
       
       IF p_message != '' THEN
            RETURN;
       END IF;
             
        SELECT acctran_tran_id_s.NEXTVAL
          INTO p_tran_id
          FROM SYS.DUAL;
                
                
        v_apdc_id   := v_list.apdc_id;
        v_tran_flag := 'O'; 
        v_tran_date := TO_DATE(p_check_date,'MM-DD-YYYY');
        v_or_date   := to_date(to_char(TO_DATE(p_check_date,'MM-DD-YYYY'), 'MM-DD-YYYY')||' '||to_char(SYSDATE,'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
        v_user_id   := p_user_id;
        v_last_update := SYSDATE;
        IF v_list.particulars IS NULL OR v_list.payor IS NULL THEN
          FOR i IN (SELECT particulars, payor
                        FROM giac_apdc_payt
                       WHERE apdc_id = v_list.apdc_id)
            LOOP
                p_particulars := i.particulars;
                v_payor       := i.payor;
            END LOOP;    
        ELSE
            p_particulars   := v_list.particulars;
            v_payor         := v_list.payor;
        END IF;
        
        v_address1      := v_list.address_1;
        v_address2      := v_list.address_2;
        v_address3      := v_list.address_3;
        v_collection    := v_collection_amt;
        v_amount        := v_list.check_amt;
        v_currency_cd   := v_list.currency_cd;
        v_currency_rt   := v_list.currency_rt;
        
        IF v_list.item_no = 1 then
                v_item_no := v_list.item_no;
        ELSE
            v_item_no := 1;
        END IF;
                
        v_pay_mode := v_list.pay_mode;
        v_bank_cd := v_list.bank_cd;
        v_check_date := v_list.check_date;
        v_check_no := v_list.check_no;
        v_check_class := v_list.check_class;
        v_fcurrency_amt := v_list.fcurrency_amt;
        v_gross_amt := v_list.gross_amt;
        v_intm_no := v_list.intm_no;
        v_commission_amt := v_list.commission_amt;
        v_vat_amt := v_list.vat_amt;
        v_fc_comm_amt := v_list.fc_comm_amt;
        v_fc_gross_amt := v_list.fc_gross_amt;
        v_fc_tax_amt := v_list.fc_tax_amt;
        v_tran_class_no := v_dcb_no;
        v_tran_year := TO_NUMBER(TO_CHAR(v_tran_date, 'YYYY'));
        v_tran_month := TO_NUMBER(TO_CHAR(v_tran_date, 'MM'));
        v_tran_seq_no := giac_sequence_generation(v_fund_cd, v_branch_cd,  'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
                                                        
        INSERT INTO giac_acctrans
                    (tran_id, gfun_fund_cd, gibr_branch_cd,
                     tran_date, tran_flag, tran_class, tran_class_no, particulars,
                     tran_year, tran_month, tran_seq_no, user_id,
                     last_update
                    )
             VALUES (p_tran_id, v_fund_cd, v_branch_cd,
                     v_tran_date, v_tran_flag, 'COL', v_tran_class_no, p_particulars,
                     v_tran_year, v_tran_month, v_tran_seq_no, v_user_id,
                     v_last_update
                    );
                         
        INSERT INTO giac_order_of_payts
                    (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                     payor, or_date, cashier_cd, dcb_no, or_flag,
                     address_1, address_2, address_3, particulars,
                     collection_amt, currency_cd, gross_amt, gross_tag, intm_no,
                     prov_receipt_no, user_id, last_update
                    )
             VALUES (p_tran_id, v_fund_cd, v_branch_cd,
                     'VARIOUS', v_or_date, v_cashier_cd, v_dcb_no, 'N',
                     v_address1, v_address2, v_address3, 'Various Policies',
                     v_amount,  v_currency_cd, v_gross_amt, 'Y', v_intm_no,
                     'VARIOUS', v_user_id, v_last_update
                    );
    END;
    
    PROCEDURE process_group_or(
          p_pdc_id          NUMBER,
          p_bank_cd         VARCHAR2,
          p_bank_acct_cd    VARCHAR2,
          p_user_id         VARCHAR2,
          p_tran_id         giac_acctrans.tran_id%TYPE,
          p_particulars     VARCHAR2,
          p_item_no         NUMBER
   )
    IS
        v_list           giac_apdc_payt_dtl%ROWTYPE;
    BEGIN
        SELECT *
          INTO v_list
          FROM giac_apdc_payt_dtl
         WHERE pdc_id = p_pdc_id;
         
        INSERT INTO giac_collection_dtl
                    (amount, currency_cd, currency_rt, gacc_tran_id,
                     item_no, pay_mode, bank_cd, check_date, check_no,
                     check_class, particulars, fcurrency_amt, gross_amt,
                     intm_no, commission_amt, vat_amt, fc_comm_amt,
                     fc_gross_amt, fc_tax_amt, dcb_bank_cd,
                     dcb_bank_acct_cd, user_id, last_update, pdc_id --added by john dolon 6.4.2015;
                    )
             VALUES (v_list.check_amt, v_list.currency_cd, v_list.currency_rt, p_tran_id,
                     p_item_no, v_list.pay_mode, v_list.bank_cd, v_list.check_date, v_list.check_no,
                     v_list.check_class, p_particulars, v_list.fcurrency_amt, v_list.gross_amt,
                     v_list.intm_no, v_list.commission_amt, v_list.vat_amt, v_list.fc_comm_amt,
                     v_list.fc_gross_amt, v_list.fc_tax_amt, p_bank_cd,
                     p_bank_acct_cd, p_user_id , sysdate, v_list.pdc_id --added by john dolon 6.4.2015;
                    );
                    
            UPDATE giac_apdc_payt_dtl
               SET gacc_tran_id = p_tran_id,
                   check_flag = 'A'
             WHERE apdc_id = v_list.apdc_id 
               AND item_no = v_list.item_no;
               
    END;
    
    PROCEDURE validate_dcb_no(
       p_pdc_id            NUMBER,
       p_check_date        VARCHAR2, -- apollo cruz 09.09.2015 sr#20107
       p_message     OUT   VARCHAR2
   )
   IS
       v_fund_cd    giac_apdc_payt.fund_cd%TYPE;
       v_branch_cd  giac_apdc_payt.branch_cd%TYPE;
       v_dcb_no     giac_colln_batch.dcb_no%TYPE;
       v_tran_date  giac_colln_batch.tran_date%TYPE;

   BEGIN
        FOR a IN (
            SELECT fund_cd, branch_cd,
                      apdc_pref
                   || '-'
                   || apdc_no
                   || DECODE (ref_apdc_no, NULL, '', '/')
                   || ref_apdc_no apdc_no                     
              FROM giac_apdc_payt a, giac_apdc_payt_dtl b 
             WHERE a.apdc_id = b.apdc_id 
               AND b.pdc_id  = p_pdc_id
        )
        LOOP
            v_fund_cd   := a.fund_cd;
            v_branch_cd := a.branch_cd;    
        END LOOP;
        
        v_tran_date := TO_DATE(p_check_date, 'mm-dd-yyyy'); -- apollo cruz 09.09.2015 sr#20107
        get_dcb_no(v_fund_cd, v_branch_cd, v_dcb_no, v_tran_date, p_message);
   END;
   
   
   PROCEDURE create_dcb_no(
       p_pdc_id            NUMBER,
       p_check_date        VARCHAR2,
       p_user_id           VARCHAR2
   )
   IS
       v_fund_cd    giac_apdc_payt.fund_cd%TYPE;
       v_branch_cd  giac_apdc_payt.branch_cd%TYPE;
       v_dcb_no     giac_colln_batch.dcb_no%TYPE;
   BEGIN
        FOR a IN (
            SELECT fund_cd, branch_cd,
                      apdc_pref
                   || '-'
                   || apdc_no
                   || DECODE (ref_apdc_no, NULL, '', '/')
                   || ref_apdc_no apdc_no                     
              FROM giac_apdc_payt a, giac_apdc_payt_dtl b 
             WHERE a.apdc_id = b.apdc_id 
               AND b.pdc_id  = p_pdc_id
        )
        LOOP
            v_fund_cd   := a.fund_cd;
            v_branch_cd := a.branch_cd;    
        END LOOP;

        FOR x IN (
            SELECT (NVL (MAX (dcb_no), 0) + 1) new_dcb_no
              FROM giac_colln_batch
             WHERE fund_cd = v_fund_cd
               AND branch_cd = v_branch_cd
               AND dcb_year = TO_NUMBER (TO_CHAR (TO_DATE(p_check_date,'MM-DD-YYYY'), 'YYYY'))
        ) 
        LOOP
            v_dcb_no   := x.new_dcb_no;
            EXIT;
        END LOOP;


        INSERT INTO giac_colln_batch
                    (dcb_no, dcb_year,
                     fund_cd, branch_cd, tran_date, dcb_flag,
                     remarks, user_id, last_update
                    )
             VALUES (v_dcb_no, TO_NUMBER (TO_CHAR (TO_DATE(p_check_date,'MM-DD-YYYY'), 'YYYY')),
                     v_fund_cd, v_branch_cd, TO_DATE(p_check_date,'MM-DD-YYYY'), 'O',
                     'Inserted from GIACS091.', p_user_id, SYSDATE
                    );
   END;
   
   
   PROCEDURE default_deposit_bank(
       p_pdc_id            NUMBER,
       p_user_id           VARCHAR2,
       p_bank_cd       OUT VARCHAR2,
       p_bank_acct_cd  OUT VARCHAR2,
       p_bank_name     OUT VARCHAR2,
       p_acct_no       OUT VARCHAR2
   )
   IS
       v_fund_cd    giac_apdc_payt.fund_cd%TYPE;
       v_branch_cd  giac_apdc_payt.branch_cd%TYPE; 
   BEGIN
        FOR a IN (
            SELECT fund_cd, branch_cd
              FROM giac_apdc_payt a, giac_apdc_payt_dtl b
             WHERE a.apdc_id = b.apdc_id 
               AND b.pdc_id = p_pdc_id
        )
        LOOP
            v_fund_cd   := a.fund_cd;
            v_branch_cd := a.branch_cd;	
        END LOOP;
        
        
        FOR a IN (
            SELECT bank_cd, bank_acct_cd
              FROM giac_dcb_users
             WHERE gibr_fund_cd = v_fund_cd
               AND gibr_branch_cd = v_branch_cd 
               AND dcb_user_id = p_user_id 
                   )
        LOOP     
            p_bank_cd       := a.bank_cd;
            p_bank_acct_cd  := a.bank_acct_cd;
            
            IF a.bank_cd IS NULL THEN
                FOR b IN (
                    SELECT bank_cd, bank_acct_cd
                      FROM giac_branches
                     WHERE gfun_fund_cd = v_fund_cd
                       AND branch_cd = v_branch_cd
                )
                LOOP     
                    p_bank_cd       := b.bank_cd;
                    p_bank_acct_cd  := b.bank_acct_cd;
                END LOOP; 
            END IF;
        END LOOP;
        
        IF p_bank_cd IS NOT NULL THEN
              FOR rec1 IN (SELECT bank_name
                             FROM giac_banks
                            WHERE bank_cd = p_bank_cd)
              LOOP
                  p_bank_name := rec1.bank_name;
              END LOOP;
              
              FOR rec2 IN (SELECT bank_acct_no
                             FROM giac_bank_accounts
                            WHERE bank_cd = p_bank_cd
                              AND bank_acct_cd = p_bank_acct_cd)
              LOOP
                  p_acct_no := rec2.bank_acct_no;
              END LOOP;
        END IF; 
        
   END;
   
   PROCEDURE group_final_update(
       p_pdc_id          NUMBER,
       p_tran_id         giac_acctrans.tran_id%TYPE,
       p_check_date      VARCHAR2, -- apollo cruz 09.09.2015 sr#20107 
       p_user_id         VARCHAR2,
       p_message     OUT VARCHAR2
   )
   IS
       v_list           giac_apdc_payt%ROWTYPE;
       v_cashier_cd     giac_dcb_users.cashier_cd%TYPE;
       v_coll_tot		giac_order_of_payts.collection_amt%TYPE;
       v_gross_tot   	giac_order_of_payts.gross_amt%TYPE;
       v_dcb_no         giac_colln_batch.dcb_no%TYPE;
       v_dcb_tran_date  giac_colln_batch.tran_date%TYPE;
   BEGIN
   
        FOR a IN (
            SELECT fund_cd, branch_cd
              FROM giac_apdc_payt a, giac_apdc_payt_dtl b
             WHERE a.apdc_id = b.apdc_id 
               AND b.pdc_id = p_pdc_id
        )
        LOOP
            v_list.fund_cd   := a.fund_cd;
            v_list.branch_cd := a.branch_cd;	
        END LOOP;
         
        FOR b IN (
            SELECT cashier_cd
              FROM giac_dcb_users
             WHERE dcb_user_id = p_user_id
               AND gibr_fund_cd = v_list.fund_cd
               AND gibr_branch_cd = v_list.branch_cd
        )
        LOOP
            v_cashier_cd := b.cashier_cd;
        END LOOP;  

        SELECT SUM (amount) coll_tot, SUM (gross_amt) gross_tot
          INTO v_coll_tot, v_gross_tot
          FROM giac_collection_dtl
         WHERE gacc_tran_id = p_tran_id;
         	        
        UPDATE giac_order_of_payts
           SET collection_amt = v_coll_tot,
               gross_amt = v_gross_tot
         WHERE gacc_tran_id = p_tran_id;
             
        giacs091_pkg.aeg_parameters(p_tran_id, 'GIACS001', v_list.fund_cd, v_list.branch_cd, p_message, p_user_id);
        
        
                    
        IF p_message != '' THEN
            RETURN;
        END IF;
        
        v_dcb_tran_date := TO_DATE(p_check_date, 'mm-dd-yyyy'); -- apollo cruz 09.09.2015 sr#20107                
        get_dcb_no(v_list.fund_cd, v_list.branch_cd, v_dcb_no, v_dcb_tran_date, p_message);
                    
        IF p_message != '' THEN
            RETURN;
        END IF;                
                        
        p_message := 'The checks have been applied to Official Receipts with DCB No. '||v_dcb_no||' cashier '||v_cashier_cd||'.'; 
   END;
   
   -- added by apollo cruz 09.16.2015 sr#20107
   FUNCTION get_fund_lov (
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2
   )
      RETURN fund_lov_tab PIPELINED
   IS
      v fund_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.fund_cd, a.fund_desc
                  FROM giis_funds a, giac_branches b
                 WHERE a.fund_cd = b.gfun_fund_cd 
                   AND check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS091', p_user_id) = 1
                   AND (UPPER(a.fund_cd) LIKE UPPER(NVL(p_keyword, a.fund_cd))
                        OR UPPER(a.fund_desc) LIKE UPPER(NVL(p_keyword, a.fund_desc))))
      LOOP
         v.fund_cd := i.fund_cd;
         v.fund_desc := i.fund_desc;
         PIPE ROW(v);
      END LOOP;
   END get_fund_lov;
   
   -- added by apollo cruz 09.17.2015 sr#20107
   FUNCTION validate_transaction_date (
      p_fund_cd      VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_check_date   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_closed_tag VARCHAR2(2);
   BEGIN
      BEGIN
         SELECT closed_tag
           INTO v_closed_tag
           FROM giac_tran_mm
          WHERE fund_cd = p_fund_cd
            AND branch_cd = giacp.v('MAIN_BRANCH_CD') --p_branch_cd
            AND tran_yr = TO_NUMBER(SUBSTR(p_check_date, 7, 4))
            AND tran_mm = TO_NUMBER(SUBSTR(p_check_date, 1, 2));
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_closed_tag := 'XX';
      END;      
   
      RETURN v_closed_tag;       
   END validate_transaction_date;      
  -- added by MarkS SR5881 12.13.2016  
   FUNCTION check_soa_balance_due (
      p_pdc_id        VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_balance VARCHAR2(2) := 'Y';
   BEGIN
        FOR i IN (SELECT c.balance_amt_due, a.collection_amt
                    FROM giac_pdc_prem_colln a, giac_apdc_payt_dtl b,giac_aging_soa_details c 
                   WHERE a.pdc_id       = p_pdc_id 
                     AND a.pdc_id       = b.pdc_id
                     AND c.inst_no      = a.inst_no 
                     AND c.iss_cd       = a.iss_cd 
                     AND c.prem_seq_no  = a.prem_seq_no
        )
        LOOP
            IF i.balance_amt_due < i.collection_amt THEN
                v_balance := 'N';
                EXIT;
            END IF;
        END LOOP;
        
        RETURN v_balance;    
   END check_soa_balance_due;  
END;
/