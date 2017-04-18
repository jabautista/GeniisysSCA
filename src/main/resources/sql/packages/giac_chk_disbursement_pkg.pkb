CREATE OR REPLACE PACKAGE BODY CPI.giac_chk_disbursement_pkg
AS
   FUNCTION get_giacs016_chk_disbursement (
      p_gacc_tran_id   giac_chk_disbursement.gacc_tran_id%TYPE
   )
      RETURN giacs016_chk_disbursement_tab PIPELINED
   IS
      v_disb   giacs016_chk_disbursement_type;
   BEGIN
      FOR i IN (SELECT check_stat, check_date, check_pref_suf, check_no,
                       gacc_tran_id, item_no
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         v_disb.check_stat := i.check_stat;
         v_disb.check_date := i.check_date;
         v_disb.check_pref_suf := i.check_pref_suf;
         v_disb.check_no := i.check_no;
         v_disb.gacc_tran_id := i.gacc_tran_id;
         v_disb.item_no := i.item_no;

         FOR b IN (SELECT SUBSTR (rv_meaning, 1, 17) dsp_meaning
                     FROM cg_ref_codes
                    WHERE rv_low_value = i.check_stat
                      AND rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT')
         LOOP
            v_disb.dsp_check_flag_mean := b.dsp_meaning;
            EXIT;
         END LOOP;

         PIPE ROW (v_disb);
      END LOOP;
   END;
   
   
   FUNCTION get_giacs002_chk_disbursement
     RETURN giacs002_chk_disb_tab PIPELINED
   IS
        v_disb          giacs002_chk_disb_type;
   BEGIN
        FOR i IN (SELECT gacc_tran_id, item_no,
                         bank_acct_cd, bank_cd,
                         payee_class_cd, payee_no, payee,
                         check_pref_suf, check_no,
                         check_class, check_stat,
                         check_date, check_print_date, 
                         particulars, user_id, last_update
                    FROM giac_chk_disbursement
                   ORDER BY item_no)
        LOOP
            v_disb.gacc_tran_id     := i.gacc_tran_id;
            v_disb.item_no          := i.item_no;
            v_disb.bank_acct_cd     := i.bank_acct_cd;
            v_disb.bank_cd          := i.bank_cd;
            v_disb.payee_class_cd   := i.payee_class_cd;
            v_disb.payee_no         := i.payee_no;
            v_disb.payee            := i.payee;
            v_disb.check_pref_suf   := i.check_pref_suf;
            v_disb.check_no         := i.check_no;
            v_disb.check_class      := i.check_class;
            v_disb.check_stat       := i.check_stat;
            v_disb.check_date       := i.check_date;
            v_disb.str_check_date   := TO_CHAR(i.check_date, 'MM-DD-RRRR');
            v_disb.check_print_date := i.check_print_date;
            v_disb.str_check_print_date := TO_CHAR(i.check_print_date, 'MM-DD-RRRR');
            v_disb.particulars      := i.particulars;
            v_disb.user_id          := i.user_id;
            v_disb.last_update      := i.last_update;
            
            /**  POST QUERY */
            BEGIN
                giac_bank_accounts_pkg.check_bank(v_disb.bank_cd, 
                                                  v_disb.bank_acct_cd, 
                                                  v_disb.bank_acct_no, 
                                                  v_disb.bank_sname);--CGFK$CHK_GCDB_GCDB_GBAC_FK(TRUE);  /* IN : Is the trigger item level?                       */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    --message('Error: This Bank Cd,Bank Acct Cd does not exist');
                    raise_application_error(-20001, 'Geniisys Exception#I#These Bank Cd, Bank Acct Cd do not exist.');
                WHEN OTHERS THEN NULL;
                    --CGTE$OTHER_EXCEPTIONS;
            END;
                        
            PIPE ROW(v_disb);
        END LOOP;
        
   END get_giacs002_chk_disbursement;
   
   
   FUNCTION get_giacs002_chk_disb_info(
        p_gacc_tran_id         giac_chk_disbursement.gacc_tran_id%TYPE 
   ) RETURN giacs002_chk_disb_tab PIPELINED
   IS
        v_disb          giacs002_chk_disb_type;
   BEGIN
        FOR i IN (SELECT gacc_tran_id, 
                         item_no,  
                         bank_acct_cd, bank_cd,
                         currency_cd, currency_rt, 
                         fcurrency_amt, amount, disb_mode,
                         payee_class_cd, payee_no, payee,
                         check_pref_suf, check_no,
                         check_class, check_stat,
                         check_date, check_print_date, 
                         particulars, user_id, last_update, batch_tag,
                         check_received_by, check_released_by, check_release_date
                    FROM giac_chk_disbursement
                   WHERE gacc_tran_id = p_gacc_tran_id
                   ORDER BY item_no)
        LOOP
            v_disb.gacc_tran_id     := i.gacc_tran_id;
            v_disb.item_no          := i.item_no;
            v_disb.bank_acct_cd     := i.bank_acct_cd;
            v_disb.bank_cd          := i.bank_cd;
            v_disb.currency_cd      := i.currency_cd;
            v_disb.currency_rt      := i.currency_rt;
            v_disb.fcurrency_amt    := i.fcurrency_amt;
            v_disb.amount           := i.amount;
            v_disb.disb_mode        := i.disb_mode;
            v_disb.payee_class_cd   := i.payee_class_cd;
            v_disb.payee_no         := i.payee_no;
            v_disb.payee            := i.payee;
            v_disb.check_pref_suf   := i.check_pref_suf;
            v_disb.check_no         := i.check_no;
            v_disb.check_class      := i.check_class;
            v_disb.check_stat       := i.check_stat;
            v_disb.check_date       := i.check_date;
            v_disb.str_check_date   := TO_CHAR(i.check_date, 'mm-dd-yyyy');
            v_disb.check_print_date := i.check_print_date;
            v_disb.str_check_print_date := TO_CHAR(i.check_print_date, 'mm-dd-yyyy');--i.check_print_date;
            v_disb.particulars      := i.particulars;
            v_disb.user_id          := i.user_id;
            v_disb.last_update      := i.last_update;
            v_disb.str_last_update  := TO_CHAR(i.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
            v_disb.check_received_by := i.check_received_by;
            v_disb.check_released_by := i.check_released_by;
            v_disb.check_release_date := i.check_release_date;
            v_disb.batch_tag          := i.batch_tag;
            
            /**  POST QUERY */
            DECLARE
                curr_value VARCHAR2(1) := v_disb.check_stat;
             BEGIN
                CHK_CHAR_REF_CODES(curr_value                            /* MOD: Value to be valida */
                                   ,v_disb.check_stat_mean               /* MOD: Domain meaning     */
                                   ,'GIAC_CHK_DISBURSEMENT.CHECK_STAT'); /* IN : Reference codes do */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_disb.check_stat_mean := NULL;
                WHEN OTHERS THEN NULL;              
            END;
            
            DECLARE
                curr_value VARCHAR2(3) := v_disb.check_class;
             BEGIN
                CHK_CHAR_REF_CODES(curr_value                             /* MOD: Value to be valid */
                                   ,v_disb.check_class_mean                /* MOD: Domain meaning    */
                                   ,'GIAC_CHK_DISBURSEMENT.CHECK_CLASS');  /* IN : Reference codes d */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_disb.check_class_mean := NULL;
                WHEN OTHERS THEN NULL;
            END;
            
            BEGIN
                giac_bank_accounts_pkg.check_bank(v_disb.bank_cd, 
                                                  v_disb.bank_acct_cd, 
                                                  v_disb.bank_acct_no, 
                                                  v_disb.bank_sname);--CGFK$CHK_GCDB_GCDB_GBAC_FK(TRUE);  /* IN : Is the trigger item level?                       */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    --message('Error: This Bank Cd,Bank Acct Cd does not exist');
                    raise_application_error(-20001, 'Geniisys Exception#I#These Bank Cd, Bank Acct Cd do not exist.');
                WHEN OTHERS THEN NULL;
                    --CGTE$OTHER_EXCEPTIONS;
            END;
            
            /* Get the Total Amount  */
            BEGIN
              SELECT NVL(SUM(fcurrency_amt),0)
                INTO v_disb.total_amount
                FROM giac_chk_disbursement
               WHERE gacc_tran_id = v_disb.gacc_tran_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_disb.total_amount := NULL;
            END;
            
            SELECT short_name
              INTO v_disb.dsp_short_name
              FROM giis_currency
             WHERE main_currency_cd = v_disb.currency_cd;
                    
            PIPE ROW(v_disb);
        END LOOP;
   END get_giacs002_chk_disb_info;
   
   
   /*PROCEDURE set_chk_disb(
        p_check             giac_chk_disbursement%ROWTYPE
   ) IS
        
   BEGIN
         --raise_application_error(-20001, 'Geniisys Exception#E# tranID: ' || p_check.gacc_tran_id || ' itemNo: ' || p_check.item_no || '  currencycd: ' || p_check.currency_cd);
        
         MERGE INTO GIAC_CHK_DISBURSEMENT
         USING DUAL ON (gacc_tran_id = p_check.gacc_tran_id AND item_no = p_check.item_no)
          WHEN NOT MATCHED THEN
               INSERT (gacc_tran_id,        item_no,            bank_cd,            bank_acct_cd,
                       currency_cd,         currency_rt,        amount,             check_date,
                       check_pref_suf,      check_no,           check_stat,         check_class,
                       fcurrency_amt,       payee_class_cd,     payee_no,           payee,
                       user_id,             last_update,        particulars,        check_release_date,
                       check_released_by,   check_received_by,  check_print_date,   disb_mode)
                       
               VALUES (p_check.gacc_tran_id,        p_check.item_no,           p_check.bank_cd,             p_check.bank_acct_cd,
                       p_check.currency_cd,        p_check.currency_rt,       p_check.amount,              p_check.check_date,
                       p_check.check_pref_suf,      p_check.check_no,          p_check.check_stat,          p_check.check_class,
                       p_check.fcurrency_amt,       p_check.payee_class_cd,    p_check.payee_no,            p_check.payee,
                       p_check.user_id,             p_check.last_update,       p_check.particulars,         p_check.check_release_date,    
                       p_check.check_released_by,   p_check.check_received_by, p_check.check_print_date,    p_check.disb_mode)
          WHEN MATCHED THEN         
               UPDATE
                  SET bank_cd       = p_check.bank_cd,
                      bank_acct_cd  = p_check.bank_acct_cd,
                      currency_cd   = p_check.currency_cd,
                      currency_rt   = p_check.currency_rt,
                      amount        = p_check.amount,
                      check_date    = p_check.check_date,
                      check_pref_suf    = p_check.check_pref_suf,
                      check_no          = p_check.check_no,
                      check_stat        = p_check.check_stat,         
                      check_class       = p_check.check_class,
                      fcurrency_amt     = p_check.fcurrency_amt,  
                      payee_class_cd    = p_check.payee_class_cd, 
                      payee_no          = p_check.payee_no,           
                      payee             = p_check.payee,
                      user_id           = p_check.user_id,          
                      last_update       = p_check.last_update,   
                      particulars       = p_check.particulars,        
                      check_release_date=p_check.check_release_date, 
                      check_released_by = p_check.check_released_by,  
                      check_received_by = p_check.check_received_by,  
                      check_print_date = p_check.check_print_date,  
                      disb_mode = p_check.disb_mode;
   
   END set_chk_disb;*/
   
     PROCEDURE set_chk_disb(
        p_gacc_tran_id             GIAC_CHK_DISBURSEMENT.gacc_tran_id%TYPE ,        
        p_item_no   GIAC_CHK_DISBURSEMENT.item_no%TYPE,           
        p_bank_cd   GIAC_CHK_DISBURSEMENT.bank_cd%TYPE,             
        p_bank_acct_cd  GIAC_CHK_DISBURSEMENT.bank_acct_cd%TYPE,
        p_currency_cd    GIAC_CHK_DISBURSEMENT.currency_cd%TYPE,         
        p_currency_rt    GIAC_CHK_DISBURSEMENT.currency_rt%TYPE,       
        p_amount GIAC_CHK_DISBURSEMENT.amount%TYPE,              
        p_check_date GIAC_CHK_DISBURSEMENT.check_date%TYPE,
        p_check_pref_suf GIAC_CHK_DISBURSEMENT.check_pref_suf%TYPE,      
        p_check_no GIAC_CHK_DISBURSEMENT.check_no%TYPE,          
        p_check_stat GIAC_CHK_DISBURSEMENT.check_stat%TYPE,          
        p_check_class GIAC_CHK_DISBURSEMENT.check_class%TYPE,
        p_fcurrency_amt GIAC_CHK_DISBURSEMENT.fcurrency_amt%TYPE,       
        p_payee_class_cd GIAC_CHK_DISBURSEMENT.payee_class_cd%TYPE,    
        p_payee_no GIAC_CHK_DISBURSEMENT.payee_no%TYPE,            
        p_payee GIAC_CHK_DISBURSEMENT.payee%TYPE,
        p_user_id GIAC_CHK_DISBURSEMENT.user_id%TYPE,             
        p_last_update GIAC_CHK_DISBURSEMENT.last_update%TYPE,       
        p_particulars GIAC_CHK_DISBURSEMENT.particulars%TYPE,         
        p_check_release_date GIAC_CHK_DISBURSEMENT.check_release_date%TYPE,    
        p_check_released_by GIAC_CHK_DISBURSEMENT.check_released_by%TYPE,   
        p_check_received_by GIAC_CHK_DISBURSEMENT.check_received_by%TYPE, 
        p_check_print_date GIAC_CHK_DISBURSEMENT.check_print_date%TYPE,    
        p_disb_mode GIAC_CHK_DISBURSEMENT.disb_mode%TYPE
   ) IS
        
   BEGIN
         --raise_application_error(-20001, 'Geniisys Exception#E# tranID: ' || p_check.gacc_tran_id || ' itemNo: ' || p_check.item_no || '  currencycd: ' || p_check.currency_cd);
        
         MERGE INTO GIAC_CHK_DISBURSEMENT
         USING DUAL ON (gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no)
          WHEN NOT MATCHED THEN
               INSERT (gacc_tran_id,        item_no,            bank_cd,            bank_acct_cd,
                       currency_cd,         currency_rt,        amount,             check_date,
                       check_pref_suf,      check_no,           check_stat,         check_class,
                       fcurrency_amt,       payee_class_cd,     payee_no,           payee,
                       user_id,             last_update,        particulars,        check_release_date,
                       check_released_by,   check_received_by,  check_print_date,   disb_mode)
                       
               VALUES (p_gacc_tran_id,        p_item_no,           p_bank_cd,             p_bank_acct_cd,
                       p_currency_cd,         p_currency_rt,       p_amount,              p_check_date,
                       p_check_pref_suf,      p_check_no,          p_check_stat,          p_check_class,
                       p_fcurrency_amt,       p_payee_class_cd,    p_payee_no,            p_payee,
                       p_user_id,             p_last_update,       p_particulars,         p_check_release_date,    
                       p_check_released_by,   p_check_received_by, p_check_print_date,    p_disb_mode)
          WHEN MATCHED THEN         
               UPDATE
                  SET bank_cd       = p_bank_cd,
                      bank_acct_cd  = p_bank_acct_cd,
                      currency_cd   = p_currency_cd,
                      currency_rt   = p_currency_rt,
                      amount        = p_amount,
                      check_date    = p_check_date,
                      check_pref_suf    = p_check_pref_suf,
                      check_no          = p_check_no,
                      check_stat        = p_check_stat,         
                      check_class       = p_check_class,
                      fcurrency_amt     = p_fcurrency_amt,  
                      payee_class_cd    = p_payee_class_cd, 
                      payee_no          = p_payee_no,           
                      payee             = p_payee,
                      user_id           = p_user_id,          
                      last_update       = p_last_update,   
                      particulars       = p_particulars,        
                      check_release_date=p_check_release_date, 
                      check_released_by = p_check_released_by,  
                      check_received_by = p_check_received_by,  
                      check_print_date = p_check_print_date,  
                      disb_mode = p_disb_mode;
   
   END set_chk_disb;
   
   
   PROCEDURE del_chk_disb(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE
   ) IS   
   BEGIN
        DELETE 
          FROM giac_chk_disbursement
         WHERE gacc_tran_id = p_gacc_tran_id
           AND item_no = p_item_no;
   END del_chk_disb;
   
   -- Executes the update_giac_check_no program unit in GIACS002
   PROCEDURE update_giac_check_no(
        p_check_no                  GIAC_CHECK_NO.check_seq_no%TYPE,
        p_gibr_gfun_fund_cd         GIAC_CHECK_NO.fund_cd%TYPE,
        p_gibr_branch_cd            GIAC_CHECK_NO.branch_cd%TYPE,
        p_bank_cd                   GIAC_CHECK_NO.bank_cd%TYPE,
        p_bank_acct_cd              GIAC_CHECK_NO.bank_acct_cd%TYPE,
        p_check_pref_suf            GIAC_CHECK_NO.chk_prefix%TYPE
   ) IS
   BEGIN
        UPDATE GIAC_CHECK_NO
           SET check_seq_no = p_check_no
         WHERE fund_cd      = p_gibr_gfun_fund_cd
           AND branch_Cd    = p_gibr_branch_cd
           AND bank_cd      = p_bank_cd
           AND bank_acct_cd = p_bank_acct_cd
           AND NVL(chk_prefix,'-') = NVL(p_check_pref_suf, NVL(chk_prefix,'-'));
 
      IF SQL%NOTFOUND THEN
        INSERT 
          INTO GIAC_CHECK_NO 
               (fund_Cd,        branch_Cd,      bank_cd ,
                bank_acct_cd,   check_seq_no ,  user_id , 
                last_update ,   chk_prefix )
        VALUES (p_gibr_gfun_fund_cd,    p_gibr_branch_cd,   p_bank_cd, 
                p_bank_acct_cd,         p_CHECK_NO ,        nvl(giis_users_pkg.app_user, USER) , 
                SYSDATE ,               p_check_pref_suf);
        IF SQL%NOTFOUND THEN
          --msg_alert('Error updating giac_check_no.', 'E', TRUE);
          raise_application_error(-20001, 'Geniisys Exception#E#Error updating giac_check_no.');
        END IF;
      END IF;
   END update_giac_check_no;
   
   
   PROCEDURE spoil_check(
        p_gacc_tran_id      IN          giac_spoiled_check.gacc_tran_id%TYPE,
        p_item_no           IN          giac_spoiled_check.item_no%TYPE,
        p_bank_cd           IN          giac_spoiled_check.bank_cd%TYPE,
        p_bank_acct_cd      IN          giac_spoiled_check.bank_acct_cd%TYPE,
        p_check_date        IN          VARCHAR2, --giac_spoiled_check.check_date%TYPE,giac_spoiled_check.check_date%TYPE,
        p_check_pref_suf    IN          giac_spoiled_check.check_pref_suf%TYPE,
        p_check_no          IN          giac_spoiled_check.check_no%TYPE,
        p_check_stat        IN          giac_spoiled_check.check_stat%TYPE,
        p_check_class       IN          giac_spoiled_check.check_class%TYPE,
        p_currency_cd       IN          giac_spoiled_check.currency_cd%TYPE,
        p_fcurrency_amt     IN          giac_spoiled_check.fcurrency_amt%TYPE,
        p_currency_rt       IN          giac_spoiled_check.currency_rt%TYPE,
        p_amount            IN          giac_spoiled_check.amount%TYPE,
        p_print_dt          IN          VARCHAR2,  --giac_spoiled_check.print_dt%TYPE,giac_spoiled_check.print_dt%TYPE,
        p_user_id           IN OUT      giac_chk_disbursement.user_id%TYPE,        
        p_batch_tag         IN          giac_chk_disbursement.batch_tag%TYPE,
        p_check_dv_print    IN          cg_ref_codes.rv_meaning%TYPE,
        p_tran_flag         IN          giac_acctrans.tran_flag%TYPE,
        p_dv_flag           IN          giac_disb_vouchers.dv_flag%TYPE,
        p_str_last_update   OUT         VARCHAR2,--giac_chk_disbursement.last_update%TYPE,
        p_dv_print_tag      OUT         giac_disb_vouchers.print_tag%TYPE,
        p_dv_print_tag_mean OUT         cg_ref_codes.rv_meaning%TYPE
  
  ) IS
        v_check             giac_spoiled_check%ROWTYPE;
        v_prtd_chk    NUMBER := 0;
        v_tot_chk     NUMBER := 0;
        v_print_tag   giac_disb_vouchers.print_tag%TYPE;
        v_batch_tag   giac_chk_disbursement.batch_tag%TYPE;
  BEGIN
  
      v_check.gacc_tran_id      := p_gacc_tran_id;
      v_check.item_no           := p_item_no;
      v_check.bank_cd           := p_bank_cd;
      v_check.bank_acct_cd      := p_bank_acct_cd;
      v_check.check_date        := TO_DATE(p_check_date,'MM-DD-RRRR');
      v_check.check_pref_suf    := p_check_pref_suf;
      v_check.check_no          := p_check_no;
      v_check.check_stat        := p_check_stat;
      v_check.check_class       := p_check_class;
      v_check.currency_cd       := p_currency_cd;
      v_check.fcurrency_amt     := p_fcurrency_amt;
      v_check.currency_rt       := p_currency_rt;
      v_check.amount            := p_amount;
      v_check.print_dt          := TO_DATE(p_print_dt,'MM-DD-RRRR HH:MI:SS AM');
      v_check.user_id           := p_user_id;
      --p_check.last_update := p_last_update;
      
      GIAC_SPOILED_CHECK_PKG.insert_spoiled_check(v_check);
  
      IF p_tran_flag = 'C' THEN
          UPDATE giac_acctrans
             SET tran_flag = 'O'
           WHERE tran_id = P_GACC_TRAN_ID;
          
          IF SQL%NOTFOUND THEN
            --FORMS_DDL('ROLLBACK');
            --msg_alert('Spoil check: Unable to update acctrans.', 'E', TRUE);
            raise_application_error(-20001, 'Geniisys Exception#E#Spoil check: Unable to update acctrans.');
          END IF;
      END IF;
      
      -----------
      FOR a IN (SELECT COUNT(*) tot_chk
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = P_GACC_TRAN_ID) 
      LOOP
          v_tot_chk := a.tot_chk;
          EXIT;
      END LOOP;
                 
      FOR b IN (SELECT COUNT(*) prt
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = P_GACC_TRAN_ID
                   AND check_stat = '2') 
      LOOP
        v_prtd_chk := b.prt;
        EXIT;
      END LOOP;
      
      IF p_check_dv_print = '1' THEN
--        p_dv_print_date := null;
--        p_str_print_date := null;
--        p_str_print_time := null;
--        p_dv_flag := 'A';
--        p_dv_flag_mean := 'Approved for printing';

        v_print_tag := 1;
          
        -- update statement added by Kris 05.27.2013 
        UPDATE giac_disb_vouchers   
           SET dv_print_date = NULL,
               dv_flag = 'A',
               print_tag = v_print_tag,
               user_id = p_user_id,
               last_update = SYSDATE
         WHERE gacc_tran_id = p_gacc_tran_id;
        
      ELSIF p_check_dv_print = '2' THEN
          IF v_tot_chk = 1 THEN
                IF p_dv_flag = 'A' THEN
                    v_print_tag := 1;
                ELSIF p_dv_flag = 'P' THEN
                    v_print_tag := 4;
                END IF;
                
          ELSIF v_tot_chk > 1 THEN
                IF p_dv_flag = 'A' THEN
                      IF v_prtd_chk = 1 THEN
                        v_print_tag := 1;
                      ELSIF v_prtd_chk > 1 THEN
                        v_print_tag := 2;
                      END IF;
                ELSIF p_dv_flag = 'P' THEN
                      IF v_prtd_chk = 1 THEN
                        v_print_tag := 4;
                      ELSIF v_prtd_chk > 1 THEN
                        v_print_tag := 5;
                      END IF;
                END IF; -- GIDV.dv_flag.
          END IF; -- v_tot_chk.
        
      ELSIF p_check_dv_print = '3' THEN
         IF v_tot_chk = 1 THEN
                v_print_tag := 4;
                
         ELSIF v_tot_chk > 1 THEN
                IF v_prtd_chk = 1 THEN
                  v_print_tag := 4;
                ELSIF v_prtd_chk > 1 THEN
                  v_print_tag := 5;
                END IF;
         END IF;  
      END IF;-- GLOBAL.check_dv_print.
      
      -- assign to GIDV.print_tag the value of 
      -- v_print_tag w/c varies depending on
      -- the GLOBAL.check_dv_print.
      p_dv_print_tag := v_print_tag;
      SELECT (giac_disb_vouchers_pkg.get_print_tag_mean(p_dv_print_tag))
         INTO p_dv_print_tag_mean
         FROM dual;
      
      p_user_id := nvl(giis_users_pkg.app_user,USER);
      p_str_last_update := TO_CHAR(SYSDATE, 'MM-DD-RRRR HH:MI:SS AM');
      
      UPDATE giac_disb_vouchers
         SET print_tag = v_print_tag,
             user_id = p_useR_id,
             last_update = SYSDATE
       WHERE gacc_tran_id = p_gacc_tran_id;
      ---------------       
      
      -- judyann 05172010; for checks printed through batch printing
      IF p_batch_tag = 'Y' THEN   
           v_batch_tag := NULL;
      END IF;    

      -- update statement added by Kris 05.27.2013
      UPDATE giac_chk_disbursement
         SET check_pref_suf = NULL,
             check_no = NULL,
             check_stat = '1',
             check_date = NULL,
             batch_tag = v_batch_tag,
             user_id = p_user_id,
             last_update = SYSDATE
       WHERE gacc_tran_id = p_gacc_tran_id
         AND item_no = p_item_no;
  
  END ;
  
  PROCEDURE bef_delete_manual_check (
        p_fund_cd           GIAC_DISB_VOUCHERS.GIBR_GFUN_FUND_CD%TYPE,
        p_branch_cd         GIAC_DISB_VOUCHERS.gibr_branch_cd%TYPE,
        p_bank_cd           giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd      giac_chk_disbursement.bank_acct_cd%TYPE,
        p_check_pref_suf    giac_chk_disbursement.check_pref_suf%TYPE
   ) IS
   
   BEGIN
         UPDATE giac_check_no
            SET check_seq_no = check_seq_no - 1
            WHERE fund_cd    = p_fund_cd
            AND branch_Cd    = p_branch_cd
            AND bank_cd      = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd
            AND NVL(chk_prefix,'-') = NVL(p_check_pref_suf, NVL(chk_prefix,'-'));
            
         IF SQL%NOTFOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Error updating giac_check_no in button Delete.');
            --msg_alert('Error updating giac_check_no ' || 'in gcdb key-delrec.', 'E', TRUE);
         END IF;  
            
   END bef_delete_manual_check; 
   
   --05.16.2013
   PROCEDURE validate_check_no(
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE    
   ) IS
        cursor GCDB is
        SELECT 'x'
          FROM giac_chk_disbursement
         WHERE check_no = p_check_no
           AND NVL(check_pref_suf, '-') = NVL(p_check_pref_suf, '-')
           AND bank_cd = p_bank_cd
           AND bank_acct_cd = p_bank_acct_cd;
          
       CURSOR gisc IS
         SELECT 'x'
           FROM giac_spoiled_check
         WHERE check_no = p_check_no
           AND NVL(check_pref_suf, '-') = NVL(p_check_pref_suf, '-')
           AND bank_cd = p_bank_cd
           AND bank_acct_cd = p_bank_acct_cd;
            
      ws_dummy   VARCHAR2(1);
   BEGIN
        OPEN gcdb;
        
        FETCH gcdb INTO ws_dummy;
            IF gcdb%FOUND THEN
                IF p_check_pref_suf IS NOT NULL THEN
                    --msg_alert('Check No. ' ||  :GCDB.check_pref_suf  || '-' || TO_CHAR(:GCDB.check_no, '0999999999') || ' already exists.', 'I', FALSE);
                    raise_application_error(-20001, 'Geniisys Exception#I#Check No. ' 
                                                    || TO_CHAR(p_check_pref_suf) || '-' || LTRIM(TO_CHAR(p_check_no, '0999999999'))
                                                    || ' already exists.');
                    --:GCDB.check_no := :CG$CTRL.prv_check_no;
                ELSE
                    --msg_alert('Check No. ' || TO_CHAR(:GCDB.check_no, '0999999999') || ' already exists.', 'I', FALSE);
                    raise_application_error(-20001, 'Geniisys Exception#I#Check No. ' 
                                                    || LTRIM(TO_CHAR(p_check_no, '0999999999'))
                                                    || ' already exists.');
                    --:GCDB.check_no := :CG$CTRL.prv_check_no;
                    --RAISE FORM_TRIGGER_FAILURE;
                END IF;
            ELSE
                OPEN gisc;
                FETCH gisc INTO ws_dummy;
                IF gisc%FOUND THEN
                    -- msg_alert('This is a spoiled check number.', 'I', FALSE);
                    raise_application_error(-20001,'Geniisys Exception#I#This is a spoiled check number.');
                    --:GCDB.check_no := :CG$CTRL.prv_check_no;
                    --RAISE FORM_TRIGGER_FAILURE;
                END IF;
                CLOSE gisc;
            END IF;
            
        CLOSE gcdb;
   END validate_check_no; 
   
   
   PROCEDURE validate_bank_cd(
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE  
   ) IS
        v_check_no              giac_chk_disbursement.check_no%TYPE := p_check_no;
        v_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE := p_check_pref_suf;
        v_bank_cd               giac_chk_disbursement.bank_cd%TYPE := p_bank_cd;
        v_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE := p_bank_acct_cd; 
   BEGIN
        IF p_bank_cd IS NOT NULL THEN
            IF p_bank_acct_cd IS NOT NULL THEN
                    GIAC_CHK_DISBURSEMENT_PKG.validate_check_no(v_check_no, v_check_pref_suf, v_bank_cd, v_bank_acct_Cd);
            END IF;
            
            <<outer>>
            DECLARE
              v_exists  VARCHAR2(1) := 'N';
            BEGIN
              FOR a IN (SELECT a.bank_cd
                          FROM giac_bank_accounts a, giac_banks b
                         WHERE a.bank_cd = p_bank_cd
                           AND a.bank_cd = b.bank_cd) 
              LOOP
                v_exists := 'Y';
                EXIT;
              END LOOP;

              IF v_exists = 'N' THEN
                <<inner>>
                DECLARE
                  v_exists2  VARCHAR2(1) := 'N';
                BEGIN
                  FOR b IN (SELECT bank_cd
                              FROM giac_banks
                             WHERE bank_cd = p_bank_cd) 
                  LOOP
                    v_exists2 := 'Y';
                    EXIT;
                  END LOOP;        
                   
                  IF v_exists2 = 'N' THEN
                    --msg_alert('Invalid bank code.', 'W', TRUE);
                    raise_application_error(-20001, 'Geniisys Exception#I#Invalid bank code.');
                  ELSE
                    --msg_alert('No bank account code exists for ' || 'this bank code.', 'W', TRUE);
                    raise_application_error(-20001, 'Geniisys Exception#I#No bank account code exists for this bank code.');
                  END IF;
                END inner; 
              END IF;
            END outer;
        END IF;
   END validate_bank_cd;
   
    FUNCTION get_check_batch_printing_list(
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_checking              VARCHAR2,
        p_check_tag             VARCHAR2,
        p_tran_id_group         VARCHAR2,
        p_branch_cd             VARCHAR2            -- shan 10.07.2014
    )
     RETURN check_batch_printing_tab PIPELINED
    IS
        TYPE cur_type IS REF CURSOR;
            
        i                       cur_type;
        v_row                   check_batch_printing_type;
        v_query                 VARCHAR2(5000);
    BEGIN
        v_query := 'SELECT c.check_date, c.check_pref_suf, c.check_no, a.gacc_tran_id, a.dv_date, a.dv_pref, a.dv_no, ' ||
                          'b.document_cd, b.branch_cd as payt_branch_cd, b.line_cd, b.doc_year, b.doc_mm, ' ||
                          'b.doc_seq_no, a.payee, a.particulars, NVL(c.batch_tag, ''N''), c.bank_cd, c.bank_acct_cd, c.item_no, ' ||
                          'c.check_stat, c.check_class, c.currency_cd, c.fcurrency_amt, c.currency_rt, c.amount, c.last_update, a.print_tag ' ||
                     'FROM giac_disb_vouchers a, giac_payt_requests b, giac_chk_disbursement c ' ||
                    'WHERE a.gprq_ref_id = b.ref_id and c.gacc_tran_id = a.gacc_tran_id ' ||
                      'AND (c.disb_mode = ''C'' or c.disb_mode IS NULL) ' ||
                      'AND dv_flag in (''A'', ''P'') ' || 
                      'AND bank_cd = ' || p_bank_cd ||
                     ' AND bank_acct_cd = ' || p_bank_acct_cd || 
                     ' AND b.branch_cd = ''' || p_branch_cd || ''' ';   -- shan 10.07.2014
                          
        IF p_checking = 'N' THEN
            IF p_check_tag = 'Y' THEN
                v_query := v_query || 'AND check_stat LIKE ''1'' AND print_tag NOT IN (3, 6) AND a.gacc_tran_id IN ' || NVL(p_tran_id_group, '(-1)');
            ELSE
                v_query := v_query || 'AND print_tag NOT IN (3, 6) AND check_stat LIKE ''1''';
            END IF;	
        ELSE
            IF p_check_tag = 'Y' THEN
                v_query := v_query || 'AND check_stat LIKE ''2'' AND print_tag = 6 AND a.gacc_tran_id IN ' || NVL(p_tran_id_group, '(-1)');
            END IF;	
        END IF;
            
        OPEN i FOR v_query;
        LOOP
            FETCH i
             INTO v_row.dsp_check_date, v_row.check_pref_suf, v_row.check_no, v_row.gacc_tran_id, v_row.dv_date, v_row.dv_pref, v_row.dv_no,
                  v_row.document_cd, v_row.payt_branch_cd, v_row.line_cd, v_row.doc_year, v_row.doc_mm,
                  v_row.doc_seq_no, v_row.payee, v_row.particulars, v_row.batch_tag, v_row.bank_cd, v_row.bank_acct_cd, v_row.item_no,
                  v_row.check_stat, v_row.check_class, v_row.currency_cd,
                  v_row.fcurrency_amt, v_row.currency_rt, v_row.amount, v_row.last_update, v_row.print_tag;
                      
            v_row.check_number := v_row.check_pref_suf || '-' || v_row.check_no;
            v_row.dv_number := v_row.dv_pref || '-' || LTRIM(TO_CHAR(v_row.dv_no, '099999999'));
            v_row.request_number := v_row.document_cd || '-' || v_row.payt_branch_cd || '-' || v_row.line_cd || '-' || v_row.doc_year || '-' ||
                                    LTRIM(TO_CHAR(v_row.doc_mm, '09')) || '-' || LTRIM(TO_CHAR(v_row.doc_seq_no, '099999'));
                
            IF v_row.check_number = '-' THEN
                v_row.check_number := '';
            END IF;
                
            EXIT WHEN i%NOTFOUND;
                
            PIPE ROW(v_row);
        END LOOP;
        CLOSE i;
    END;
   
    PROCEDURE generate_check(
        p_fund_cd       IN      giis_funds.fund_cd%TYPE,
        p_branch_cd     IN      giac_bank_accounts.branch_cd%TYPE,
        p_bank_sname    IN      giac_banks.bank_sname%TYPE,
        p_bank_cd       IN      giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd  IN      giac_chk_disbursement.bank_acct_cd%TYPE,
        p_chk_prefix    OUT     VARCHAR2,
        p_check_seq_no  OUT     giac_check_no.check_seq_no%TYPE
    )
    IS
        v_default_check_pref    giac_parameters.param_value_v%TYPE;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO v_default_check_pref
              FROM giac_parameters
             WHERE param_name LIKE UPPER('%DEFAULT_CHECK_PREF%');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Default Check Prefix not found in giac_parameters.');
        END;
       
        IF v_default_check_pref = 'B' THEN
            p_chk_prefix := SUBSTR(p_bank_sname, 1, 5);
        ELSIF v_default_check_pref = 'C' THEN
            p_chk_prefix := p_branch_cd || '' || SUBSTR(p_bank_sname, 1, 3);
        ELSIF v_default_check_pref = 'P' THEN
            BEGIN
                SELECT param_value_v
                  INTO p_chk_prefix
                  FROM giac_parameters
                 WHERE UPPER(param_name) = 'CHECK_PREF';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Check Prefix not found in giac_parameters.');
            END;
        END IF;
            
        BEGIN
            SELECT check_seq_no + 1
              INTO p_check_seq_no
              FROM giac_check_no
             WHERE fund_cd = p_fund_cd 
               AND branch_cd = p_branch_cd 
               AND bank_cd = p_bank_cd
               AND bank_acct_cd = p_bank_acct_cd
               AND NVL(chk_prefix, '-') = NVL(p_chk_prefix, NVL(chk_prefix, '-'));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_check_seq_no := 1;
        END;
    END;
   
    PROCEDURE validate_spoil(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE
    )
    IS
        v_tran_flag             giac_acctrans.tran_flag%TYPE;
        v_check_stat            VARCHAR2(1);
        v_exists                VARCHAR2(1) := 'N';
    BEGIN
        SELECT tran_flag
          INTO v_tran_flag
          FROM giac_acctrans
         WHERE tran_id = p_gacc_tran_id;
      
        SELECT check_stat
          INTO v_check_stat
          FROM giac_chk_disbursement
         WHERE gacc_tran_id = p_gacc_tran_id
           AND item_no = p_item_no;
               
        IF v_check_stat <> '2' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Check cannot be spoiled.');
        ELSE
            IF v_tran_flag IN ('O', 'C') THEN
                FOR i IN (SELECT '1'
                            FROM giac_chk_release_info
                           WHERE gacc_tran_id = p_gacc_tran_id
                             AND item_no = p_item_no
                             AND NVL(check_pref_suf, '-') = NVL(p_check_pref_suf, NVL(check_pref_suf, '-'))
                             AND check_no = p_check_no)
                LOOP
                    v_exists := 'Y';
                    EXIT;
                END LOOP;
                    
                IF v_exists = 'Y' THEN
                   RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Spoiling not allowed. This check has already been released.');
                END IF;
            END IF;
        END IF;
    END;
   
    PROCEDURE spoil_check_giacs054(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_check_date            giac_chk_disbursement.check_date%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_stat            giac_chk_disbursement.check_stat%TYPE,
        p_check_class           giac_chk_disbursement.check_class%TYPE,
        p_currency_cd           giac_chk_disbursement.currency_cd%TYPE,
        p_fcurrency_amt         giac_chk_disbursement.fcurrency_amt%TYPE,
        p_currency_rt           giac_chk_disbursement.currency_rt%TYPE,
        p_amount                giac_chk_disbursement.amount%TYPE,
        p_last_update           giac_chk_disbursement.last_update%TYPE,
        p_user_id               giac_chk_disbursement.user_id%TYPE,
        p_check_dv_print        VARCHAR2                -- shan 10.01.2014
    )
    IS
        v_tran_flag             giac_acctrans.tran_flag%TYPE;
        v_check_stat            VARCHAR2(1);
        v_dv_flag               VARCHAR2(1) := 'N'; -- shan 10.07.2014
        v_print_tag             NUMBER(1);           -- shan 10.07.2014
        v_printed_chk_count     NUMBER;         -- shan 10.07.2014
        v_check_count           NUMBER ;        -- shan 10.07.2014
    BEGIN
        BEGIN
            SELECT tran_flag
              INTO v_tran_flag
              FROM giac_acctrans
             WHERE tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN OTHERS THEN
                v_tran_flag := NULL;
        END;
            
        BEGIN
            SELECT check_stat
              INTO v_check_stat
              FROM giac_chk_disbursement
             WHERE gacc_tran_id = p_gacc_tran_id
               AND item_no = p_item_no;
        EXCEPTION
            WHEN OTHERS THEN
                v_check_stat := NULL;
        END;
       
        INSERT INTO giac_spoiled_check(gacc_tran_id, item_no,
                                       bank_cd, bank_acct_cd,
                                       check_date, check_pref_suf,
                                       check_no, check_stat,
                                       check_class, currency_cd,
                                       fcurrency_amt, currency_rt,
                                       amount, print_dt,
                                       user_id, last_update)
         VALUES (p_gacc_tran_id, p_item_no,
                 p_bank_cd, p_bank_acct_cd,
                 p_check_date, p_check_pref_suf,
                 p_check_no, v_check_stat,
                 p_check_class, p_currency_cd,
                 p_fcurrency_amt, p_currency_rt,
                 p_amount, p_last_update,
                 p_user_id, SYSDATE);
                      
        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoil check: Unable to insert into spoiled_check.');
        END IF;
        
        /** shan 10.07.2014 **/
        SELECT COUNT(*)
          INTO v_check_count
          FROM giac_chk_disbursement
         WHERE gacc_tran_id = p_gacc_tran_id;
         
        SELECT COUNT(*)
          INTO v_printed_chk_count
          FROM giac_chk_disbursement
         WHERE gacc_tran_id = p_gacc_tran_id
           AND check_stat LIKE '2';
        
        FOR b IN (SELECT dv_flag
                    FROM giac_disb_vouchers
                   WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
            v_dv_flag := b.dv_flag;
            EXIT;
        END LOOP;
        /** end 10.07.2014 **/
            
        IF v_tran_flag = 'C' THEN
            UPDATE giac_acctrans
               SET tran_flag = 'O'
             WHERE tran_id = p_gacc_tran_id;
                 
            IF SQL%NOTFOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoil check: Unable to update acctrans.');
            END IF;
            
            UPDATE giac_chk_disbursement
               SET check_stat = '1', 
                   check_print_date = NULL,
                   check_date = NULL,
                   check_pref_suf = NULL,
                   check_no = NULL,
                   batch_tag = NULL
             WHERE gacc_tran_id = p_gacc_tran_id
               AND item_no = p_item_no;     -- shan 10.01.2014
            
            IF p_check_dv_print = '1' THEN  -- added condition : shan 10.01.2014
                UPDATE giac_disb_vouchers
                   SET print_tag = 1,
                       dv_flag = 'A'
                 WHERE gacc_tran_id = p_gacc_tran_id;
            ELSE
                UPDATE giac_disb_vouchers
                   SET print_tag = 1,
                       dv_flag = 'P'
                 WHERE gacc_tran_id = p_gacc_tran_id;
            END IF;
        ELSIF v_tran_flag = 'D' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoiling not allowed. This is a deleted transaction.');
        ELSIF v_tran_flag = 'P' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoiling not allowed. This is a posted transaction.');
        ELSIF v_tran_flag = 'O' THEN    -- shan 09.30.2014
            UPDATE giac_chk_disbursement
               SET check_stat = '1', 
                   check_print_date = NULL,
                   check_date = NULL,
                   check_pref_suf = NULL,
                   check_no = NULL,
                   batch_tag = NULL
             WHERE gacc_tran_id = p_gacc_tran_id
               AND item_no = p_item_no;
               
            IF p_check_dv_print = '1' THEN
                UPDATE giac_disb_vouchers
                   SET dv_flag = 'A',
                       print_tag = 1
                 WHERE gacc_tran_id = p_gacc_tran_id;
            ELSE
                IF p_check_dv_print = '2' THEN
                    IF v_dv_flag = 'A' THEN
                        IF v_check_count = 1 OR (v_check_count > 1 AND v_printed_chk_count = 1) THEN
                            v_print_tag := 1;
                        ELSE
                            v_print_tag := 2;
                        END IF;

                    ELSIF v_dv_flag = 'P' THEN
                        IF v_check_count = 1 OR (v_check_count > 1 AND v_printed_chk_count = 1) THEN
                            v_print_tag := 4;
                        ELSE
                            v_print_tag := 5;
                        END IF;
                    END IF;
                    
                ELSIF p_check_dv_print = '3' THEN
                    IF v_check_count = 1 OR (v_check_count > 1 AND v_printed_chk_count = 1) THEN
                        v_print_tag := 4;
                    ELSE
                        v_print_tag := 5;
                    END IF;
                END IF;
                
                UPDATE giac_disb_vouchers
                   SET print_tag = v_print_tag
                 WHERE gacc_tran_id = p_gacc_tran_id;            
            END IF;
        END IF;
    END;
   
    FUNCTION get_check_seq_no(
        p_fund_cd               giis_funds.fund_cd%TYPE,
        p_branch_cd             giac_bank_accounts.branch_cd%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_chk_prefix            giac_chk_disbursement.check_pref_suf%TYPE
    )
     RETURN NUMBER
    IS
        v_check_seq_no          giac_check_no.check_seq_no%TYPE;
    BEGIN
        SELECT check_seq_no + 1
          INTO v_check_seq_no
          FROM giac_check_no
         WHERE fund_cd = p_fund_cd
           AND branch_cd = p_branch_cd
           AND bank_cd = p_bank_cd 
           AND bank_acct_cd = p_bank_acct_cd 
           AND chk_prefix = p_chk_prefix;
               
        RETURN v_check_seq_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 1;	
    END;
   
    PROCEDURE process_printed_checks(
        p_tran_id               giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_check_date            giac_chk_disbursement.check_date%TYPE,
        p_check_pref            giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_user_id               giis_users.user_id%TYPE,
        p_check_dv_print        VARCHAR2                    -- shan 09.30.2014
    )
    IS
        v_exists                VARCHAR2(1) := 'N';
        v_exists2               VARCHAR2(1) := 'N';
        v_check_date			DATE;	
        v_check_print_date		DATE;
        v_param_value   	    NUMBER;
        v_tran_date			    giac_acctrans.tran_date%TYPE;
        v_dv_printed            VARCHAR2(1) := 'N'; -- shan 09.30.2014
        v_print_tag             NUMBER(1);           -- shan 09.30.2014
        v_with_unprinted_chk    VARCHAR2(1) := 'N'; -- shan 10.07.2014
    BEGIN
        UPDATE giac_chk_disbursement
  		     SET batch_tag = 'Y', 
  			      check_stat = '2',
  			      check_date = p_check_date, 
  			      check_pref_suf = p_check_pref,
  			      check_no = p_check_no,
  			      check_print_date = SYSDATE
  	      WHERE gacc_tran_id = p_tran_id
           AND item_no = p_item_no;
         
        /*UPDATE giac_disb_vouchers
  		     SET print_tag = 6,
  			      dv_flag = 'P'
  	      WHERE gacc_tran_id = p_tran_id;*/ -- moved below : shan 09.30.2014
                
        FOR a IN (SELECT '1' 
                    FROM giac_chk_disbursement
                   WHERE gacc_tran_id = p_tran_id
                     AND check_stat LIKE '1')
        LOOP
            v_exists := 'Y';
            v_with_unprinted_chk := 'Y';
            EXIT;
        END LOOP;
        
        IF v_exists = 'N' THEN
            FOR b IN (SELECT '1'
                        FROM giac_disb_vouchers
                       WHERE gacc_tran_id = p_tran_id
                         AND dv_flag LIKE 'A')
            LOOP
                v_exists := 'Y';
                EXIT;
            END LOOP;    
        END IF;
        
        /**  09.30.2014  **/
        IF p_check_dv_print = '1' THEN
            UPDATE giac_disb_vouchers
               SET print_tag = 6,
                   dv_flag = 'P'
             WHERE gacc_tran_id = p_tran_id;
        ELSE
            IF p_check_dv_print = '2' THEN
                FOR i IN (SELECT dv_flag
                            FROM giac_disb_vouchers
                           WHERE gacc_tran_id = p_tran_id
                             AND dv_flag = 'P')
                LOOP
                    v_dv_printed := 'Y';
                    EXIT;
                END LOOP;
                
                IF v_dv_printed = 'N' AND v_with_unprinted_chk = 'Y' THEN   -- v_exists: Y - with unprinted checks
                    v_print_tag := 2;
                ELSIF v_dv_printed = 'N' AND v_with_unprinted_chk = 'N' THEN
                    v_print_tag := 3;
                ELSIF v_dv_printed = 'Y' AND v_with_unprinted_chk = 'Y' THEN
                    v_print_tag := 5;
                ELSIF v_dv_printed = 'Y' AND v_with_unprinted_chk = 'N' THEN
                    v_print_tag := 6;
                END IF;
            ELSIF p_check_dv_print = '3' THEN
                IF v_exists = 'N' THEN  -- all checks printed
                    v_print_tag := 6;
                ELSE
                    v_print_tag := 5;
                END IF;
            END IF;
            
             UPDATE giac_disb_vouchers
               SET print_tag = v_print_tag
             WHERE gacc_tran_id = p_tran_id;
        END IF;
        /**  end 09.30.2014  **/
        
        IF v_exists = 'N' THEN
            FOR a IN (SELECT '1', TRUNC(check_date) check_date, TRUNC(check_print_date) check_print_date
                        FROM giac_chk_disbursement
                       WHERE gacc_tran_id = p_tran_id)
            LOOP
                v_exists2 := 'Y';
                v_check_date := a.check_date; 
                v_check_print_date := a.check_print_date; 
                EXIT;
            END LOOP;

            IF v_exists2 = 'Y' THEN 
                UPDATE giac_acctrans
                   SET tran_flag = 'C'
                 WHERE tran_id = p_tran_id;

                BEGIN 
                    SELECT param_value_v
                      INTO v_param_value
                      FROM giac_parameters
                     WHERE param_name like 'DISB_TRAN_DATE';
  
                    IF v_param_value = 2 THEN
          	            UPDATE giac_acctrans
                           SET tran_date = v_check_date
                         WHERE tran_id = p_tran_id;
                         
          	            v_tran_date := v_check_date;
                    ELSIF v_param_value = 3 THEN
          	            UPDATE giac_acctrans
                           SET tran_date = v_check_print_date
                         WHERE tran_id = p_tran_id;
           	            
                        v_tran_date := v_check_print_date;
                    ELSE
          	            BEGIN
        	                SELECT TRUNC(tran_date)
        	                  INTO v_tran_date
        	                  FROM giac_acctrans
        	                 WHERE tran_id = p_tran_id;
        	            EXCEPTION
        	   	            WHEN NO_DATA_FOUND THEN
        	 	                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No value for TRAN_DATE.');
        	            END;
                    END IF;
      
                    FOR chk_bdv IN(SELECT tran_id 
                                     FROM giac_acctrans 
                                    WHERE tran_id IN(SELECT jv_tran_id
                                                       FROM giac_batch_dv_dtl
                                                      WHERE batch_dv_id IN(SELECT batch_dv_id 
                                                                             FROM giac_batch_dv
                                                                            WHERE tran_id = p_tran_id)))
                    LOOP
                        UPDATE giac_acctrans
                           SET tran_flag = 'C',
                               tran_date = v_tran_date   
                         WHERE tran_id = chk_bdv.tran_id;
                    END LOOP;
      
                    IF SQL%NOTFOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error updating giac_acctrans.');
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Parameter DISB_TRAN_DATE does not exist in GIAC_PARAMETERS.');
                END;
            END IF;     
        END IF;
    END;
    
    PROCEDURE update_giac_check_no2(
        p_fund_cd               giis_funds.fund_cd%TYPE,
        p_branch_cd             giac_bank_accounts.branch_cd%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_check_pref            giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_user_id               giis_users.user_id%TYPE
    )
    IS
    BEGIN
        MERGE INTO giac_check_no
        USING DUAL ON (fund_cd = p_fund_cd AND branch_cd = p_branch_cd AND bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd AND chk_prefix = p_check_pref)
         WHEN NOT MATCHED THEN
              INSERT (fund_cd, branch_cd, bank_cd, bank_acct_cd, check_seq_no, chk_prefix, user_id, last_update)
              VALUES (p_fund_cd, p_branch_cd, p_bank_cd, p_bank_acct_cd, p_check_no, p_check_pref, p_user_id, SYSDATE)
         WHEN MATCHED THEN
              UPDATE
                 SET check_seq_no = p_check_no,
                     user_id = p_user_id,
                     last_update = SYSDATE;
    END;
    
    PROCEDURE update_printed_checks(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_check_date            giac_chk_disbursement.check_date%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_dv_print        VARCHAR2                    -- shan 10.07.2014
    )
    IS
        v_dv_flag               VARCHAR2(1) := 'N'; -- shan 10.07.2014
        v_print_tag             NUMBER(1);           -- shan 10.07.2014
        v_printed_chk_count     NUMBER;         -- shan 10.07.2014
        v_check_count           NUMBER ;        -- shan 10.07.2014
    BEGIN
        UPDATE giac_chk_disbursement
  		     SET batch_tag = 'Y',
  			      check_date = p_check_date,  
  			      check_pref_suf = p_check_pref_suf,
  			      check_no = p_check_no,
  			      check_print_date = SYSDATE,
               check_stat = '2'
  	      WHERE gacc_tran_id = p_gacc_tran_id
           AND item_no = p_item_no;
         
        UPDATE giac_acctrans
  		     SET tran_flag = 'C'
  	      WHERE tran_id = p_gacc_tran_id;

        /*UPDATE giac_disb_vouchers
           SET print_tag = 6,
               dv_flag = 'P'
         WHERE gacc_tran_id = p_gacc_tran_id;*/ -- replaced with codes below : shan 10.07.2014
         
        SELECT COUNT(*)
          INTO v_check_count
          FROM giac_chk_disbursement
         WHERE gacc_tran_id = p_gacc_tran_id;
         
        SELECT COUNT(*)
          INTO v_printed_chk_count
          FROM giac_chk_disbursement
         WHERE gacc_tran_id = p_gacc_tran_id
           AND check_stat LIKE '2';
        
        FOR b IN (SELECT dv_flag
                    FROM giac_disb_vouchers
                   WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
            v_dv_flag := b.dv_flag;
            EXIT;
        END LOOP;
         
        IF p_check_dv_print = '1' THEN
            UPDATE giac_disb_vouchers
               SET dv_flag = 'A',
                   print_tag = 1
             WHERE gacc_tran_id = p_gacc_tran_id;
        ELSE
            IF p_check_dv_print = '2' THEN
                IF v_dv_flag = 'A' THEN
                    IF v_check_count = 1 OR (v_check_count > 1 AND v_printed_chk_count = 1) THEN
                        v_print_tag := 1;
                    ELSE
                        v_print_tag := 2;
                    END IF;

                ELSIF v_dv_flag = 'P' THEN
                    IF v_check_count = 1 OR (v_check_count > 1 AND v_printed_chk_count = 1) THEN
                        v_print_tag := 4;
                    ELSE
                        v_print_tag := 5;
                    END IF;
                END IF;
                    
            ELSIF p_check_dv_print = '3' THEN
                IF v_check_count = 1 OR (v_check_count > 1 AND v_printed_chk_count = 1) THEN
                    v_print_tag := 4;
                ELSE
                    v_print_tag := 5;
                END IF;
            END IF;
                
            UPDATE giac_disb_vouchers
               SET print_tag = v_print_tag
             WHERE gacc_tran_id = p_gacc_tran_id;            
        END IF;
    END;
    
    PROCEDURE validate_check_seq_no(
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_chk_prefix            giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_seq_no          giac_chk_disbursement.check_no%TYPE,
        p_branch_cd             giac_bank_accounts.branch_cd%TYPE
    )
    IS
        v_check_pref            giac_chk_disbursement.check_pref_suf%TYPE;
        v_check_no              giac_chk_disbursement.check_no%TYPE;
        v_check_pref2           giac_spoiled_check.check_pref_suf%TYPE;
        v_check_no2             giac_spoiled_check.check_no%TYPE;
        v_check_pref3           giac_check_no.chk_prefix%TYPE;
        v_check_no3             giac_check_no.check_seq_no%TYPE;
    BEGIN
        SELECT check_pref_suf, check_no
          INTO v_check_pref, v_check_no
          FROM giac_chk_disbursement gcdb
         WHERE gcdb.bank_cd = p_bank_cd 
           AND gcdb.bank_acct_cd = p_bank_acct_cd 
           AND gcdb.check_pref_suf = p_chk_prefix
           AND gcdb.check_no = p_check_seq_no;
           
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#This Check No. already exists.');
    EXCEPTION           
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT check_pref_suf, check_no
                  INTO v_check_pref2, v_check_no2
                  FROM giac_spoiled_check
                 WHERE bank_cd = p_bank_cd  
                   AND bank_acct_cd = p_bank_acct_cd 
                   AND check_pref_suf = p_chk_prefix
                   AND check_no = p_check_seq_no;

                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#This Check No. has been spoiled.');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    BEGIN
                        SELECT chk_prefix,check_seq_no
 					      INTO v_check_pref3,v_check_no3
     					  FROM giac_check_no
 					     WHERE bank_cd = p_bank_cd  
        	               AND bank_acct_cd   = p_bank_acct_cd 
        	               AND chk_prefix = p_chk_prefix
        	               AND branch_cd = p_branch_cd;
                           
                        IF v_check_no3 >= p_check_seq_no THEN
                            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Check No. '||v_check_no3||' is the last check printed.');
                        END IF;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
            END;
    END;
   
END;
/


