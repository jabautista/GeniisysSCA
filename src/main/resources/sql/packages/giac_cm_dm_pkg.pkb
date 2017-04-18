CREATE OR REPLACE PACKAGE BODY CPI.GIAC_CM_DM_PKG
AS

   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 20, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Inserts/Updates credit/debit memo information
  */
  PROCEDURE set_cm_dm_info(p_memo IN OUT giac_cm_dm%ROWTYPE)
  IS
    v_memo_seq_no       giac_cm_dm.memo_seq_no%TYPE;
    v_last_update       giac_cm_dm.last_update%TYPE;
  BEGIN
    /*Generate the series to be used for the CM/DM No.*/
-- 	IF p_memo.memo_seq_no IS NULL THEN
--        v_memo_seq_no := CPI.giac_sequence_generation(p_memo.fund_cd,
--                                                      p_memo.branch_cd,
--                                                      p_memo.memo_type,
--                                                      p_memo.memo_year,
--                                                      0);
--        p_memo.memo_seq_no := v_memo_seq_no;
--    END IF;
               
--    v_last_update := TO_DATE(TO_CHAR(p_memo.last_update, 'mm-dd-yyyy HH12:MI:SS AM'));
--    p_memo.last_update := v_last_update;
    SELECT last_update
      INTO v_last_update
      FROM giac_acctrans
     WHERE tran_id = p_memo.gacc_tran_id;
     
    GIIS_USERS_PKG.app_user := p_memo.user_id; --marco - 06.11.2013
    p_memo.last_update := v_last_update;
                                   
    MERGE INTO giac_cm_dm
    USING dual 
       ON (gacc_tran_id = p_memo.gacc_tran_id)
     WHEN NOT MATCHED THEN
          INSERT (gacc_tran_id, fund_cd, branch_cd,
                  memo_type, memo_date, memo_year, memo_seq_no,
                  memo_status, recipient, particulars,
                  amount, currency_cd, currency_rt,
                  local_amt, user_id, last_update,
                  ri_comm_vat, ri_comm_amt) -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
          VALUES (p_memo.gacc_tran_id, p_memo.fund_cd, p_memo.branch_cd,
                  p_memo.memo_type, p_memo.memo_date, p_memo.memo_year, p_memo.memo_seq_no,
                  p_memo.memo_status, p_memo.recipient, p_memo.particulars,
                  p_memo.amount, p_memo.currency_cd, p_memo.currency_rt,
                  p_memo.local_amt, p_memo.user_id, p_memo.last_update,
                  p_memo.ri_comm_vat, p_memo.ri_comm_amt) -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
     WHEN MATCHED THEN
          UPDATE
          SET --gacc_tran_id = p_memo.gacc_tran_id,
              fund_cd = p_memo.fund_cd,
              branch_cd = p_memo.branch_cd,
              memo_type = p_memo.memo_type,
--              memo_date = p_memo.memo_date,
              memo_year = p_memo.memo_year,
--              memo_seq_no = p_memo.memo_seq_no,
              memo_status = p_memo.memo_status,
              recipient = p_memo.recipient,
              particulars = p_memo.particulars,
              amount = p_memo.amount,
              currency_cd = p_memo.currency_cd,
              currency_rt = p_memo.currency_rt,
              local_amt = p_memo.local_amt,
              user_id = p_memo.user_id,
              last_update = p_memo.last_update,
              ri_comm_vat = p_memo.ri_comm_vat, -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
              ri_comm_amt = p_memo.ri_comm_amt; -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
                            
  END set_cm_dm_info; 
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 20, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Inserts/Updates credit/debit memo information into giac_accctrans
  */
  PROCEDURE insert_memo_into_acctrans(
        p_gacc_tran_id      IN OUT  GIAC_CM_DM.GACC_TRAN_ID%TYPE,
        p_fund_cd           IN   giac_cm_dm.fund_cd%TYPE,
        p_branch_cd         IN   giac_cm_dm.branch_cd%TYPE,
        p_memo_type         IN   giac_cm_dm.memo_type%TYPE,
        p_memo_year         IN   giac_cm_dm.memo_year%TYPE,
        p_memo_date         IN   giac_cm_dm.memo_date%TYPE,
        p_particulars       IN   giac_cm_dm.particulars%TYPE,
        p_user_id           IN OUT  giac_cm_dm.user_id%TYPE,
        p_last_update       IN OUT  giac_cm_dm.last_update%TYPE,
        p_memo_seq_no       IN OUT  giac_cm_dm.memo_seq_no%TYPE,
        p_last_update_str   IN OUT  VARCHAR2 
  )
  IS
    CURSOR fund IS 
        SELECT '1'
          FROM giis_funds
         WHERE fund_cd = p_fund_cd;
         
    CURSOR branch IS
        SELECT '1'
          FROM giac_branches
         WHERE branch_cd = p_branch_cd;
         
    v_fund          VARCHAR2(1);
    v_branch        VARCHAR2(1);
    v_message       VARCHAR2(200);
    v_gacc_tran_id  giac_acctrans.tran_id%TYPE;
    v_memo_seq_no   giac_cm_dm.memo_Seq_no%TYPE;
    v_last_update   giac_cm_dm.last_update%TYPE;
    v_last_update_str VARCHAR2(100);
    v_memo_type         VARCHAR2(100) := p_memo_type;
    v_mean_memo_type    VARCHAR2(100);
  BEGIN
    GIIS_USERS_PKG.app_user := p_user_id; -- marco - 06.11.2013
  
    OPEN fund;
    FETCH fund INTO v_fund;
    
    IF fund%NOTFOUND THEN
        raise_application_error(-20001, 'Geniisys Exception#imgMessage.ERROR#Invalid fund code.');
    ELSE 
        OPEN branch;
        FETCH branch INTO v_branch;
        
        IF branch%NOTFOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#imgMessage.ERROR#Invalid branch code.');
        END IF;    
        CLOSE branch;
    END IF;
    CLOSE fund;
    
    /* Validate this item against the REF_CODES table */
    BEGIN
        chk_char_ref_codes(v_memo_type, 
                           v_mean_memo_type, 
                           'GIAC_CM_DM.MEMO_TYPE');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#Invalid value for Memo Type.');
    END;
    
    
    IF p_gacc_tran_id IS NULL THEN
        BEGIN
            SELECT acctran_tran_id_s.nextval
              INTO p_gacc_tran_id 
              FROM dual;
              
--              p_gacc_tran_id := v_gacc_tran_id;
        EXCEPTION
            WHEN no_data_found THEN
                raise_application_error(-20101, 'Geniisys Exception#imgMessage.ERROR#ACCTRAN_TRAN_ID sequence not found.');
        END;
    END IF;
    
    BEGIN
		IF p_memo_seq_no IS NULL THEN
            /*Generate the series to be used for the CM/DM No.*/
            v_memo_seq_no := CPI.giac_sequence_generation(p_fund_cd,
                                                      p_branch_cd,
                                                      p_memo_type,
                                                      p_memo_year,
                                                      0);
            p_memo_seq_no := v_memo_seq_no;
            v_last_update_str := TO_CHAR(p_last_update, 'mm-dd-yyyy HH12:MI:SS AM');
            v_last_update := p_last_update;
        
            INSERT 
              INTO giac_acctrans
			       (tran_id, gfun_fund_cd, gibr_branch_cd, 
                    tran_date, tran_year, tran_month,
                    tran_flag, tran_class, particulars,
                    user_id, last_update)
            VALUES (p_gacc_tran_id, p_fund_cd, p_branch_cd, 
                    p_memo_date, p_memo_year, to_number(to_char(p_memo_date, 'MM')),
                    'O', p_memo_type, p_particulars,
			        p_user_id, p_last_update);
        ELSE
            v_last_update := SYSDATE;
            v_last_update_str := TO_CHAR(SYSDATE, 'mm-dd-yyyy HH12:MI:SS AM');
        
            UPDATE giac_acctrans
	           SET particulars =  p_particulars, 
       	           user_id = p_user_id,
                   last_update = p_last_update
             WHERE tran_id = p_gacc_tran_id;
        END IF;
        
        p_last_update_str := v_last_update_str;
        p_last_update := v_last_update;
        
	EXCEPTION
		WHEN OTHERS THEN
            NULL;
--			raise_application_error(-20101, v_message);
    END;
    
  END insert_memo_into_acctrans;
  
  
  FUNCTION get_memo_seq_no(
        p_gacc_tran_id    giac_cm_dm.gacc_tran_id%TYPE 
  ) RETURN NUMBER
  IS
        v_memo_seq_no   giac_cm_dm.memo_seq_no%TYPE;
  BEGIN
        SELECT memo_seq_no
          INTO v_memo_seq_no
          FROM giac_cm_dm
         WHERE gacc_tran_id = p_gacc_tran_id;
        
        RETURN v_memo_seq_no;
  EXCEPTION
    WHEN no_data_found THEN
        RETURN NULL;
  END get_memo_seq_no;
    
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 20, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   When-Create-Record Trigger, 
  */
  FUNCTION get_default_memo_info RETURN giac_cm_dm_tab PIPELINED
  IS
    v_memo  giac_cm_dm_type;
  BEGIN   
    BEGIN
        FOR rec IN (SELECT substr(rv_meaning,1,10) rv_meaning, rv_low_value
                      FROM cg_ref_codes
                     WHERE rv_domain = 'GIAC_CM_DM.MEMO_STATUS'
                       AND substr(rv_low_value,1,1) = 'U')
        LOOP
            v_memo.mean_memo_status := rec.rv_meaning;
            v_memo.memo_status := rec.rv_low_value;
            v_memo.memo_type := 'CM';
            v_memo.last_update := sysdate; 
            v_memo.last_update_str := TO_CHAR(SYSDATE, 'mm-dd-yyyy HH12:MI:SS AM');
--            v_memo.user_id := NVL (giis_users_pkg.app_user, USER);
            v_memo.dsp_memo_date := TRUNC(sysdate);
            v_memo.memo_date := v_memo.dsp_memo_date;
            v_memo.memo_year := TO_NUMBER(TO_CHAR(sysdate, 'YYYY'));
            
            SELECT GIACP.V('FUND_CD')
              INTO v_memo.fund_cd
              FROM dual;
              
            FOR rec IN (SELECT fund_desc
                          FROM giis_funds
                         WHERE fund_cd = v_memo.fund_cd)
            LOOP
                v_memo.fund_desc := rec.fund_desc;
            END LOOP;
              
            SELECT NVL(giacp.v('ALLOW_TRAN_FOR_CLOSED_MONTH'),'Y')
              INTO v_memo.allow_tran_tag
              FROM dual;
            
            SELECT param_value_v 
              INTO v_memo.allow_print_tag
              FROM giac_parameters 
             WHERE param_name = 'ALLOW_PRINT_FOR_OPEN_CMDM';
        
            SELECT param_value_v cancel_param
              INTO v_memo.allow_cancel_tag
              FROM giac_parameters 
             WHERE param_name = 'ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH';
            
            BEGIN
                SELECT param_value_v 
                  INTO v_memo.local_curr_sname
                  FROM giac_parameters
                 WHERE param_name LIKE 'DEFAULT_CURRENCY';
            EXCEPTION
                WHEN no_data_found THEN
                    v_memo.local_curr_sname := NULL;
            END;
            
            BEGIN
                SELECT currency_rt, main_currency_cd
                  INTO v_memo.local_curr_rt, v_memo.local_curr_cd
                  FROM giis_currency
                 WHERE short_name = v_memo.local_curr_sname;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END; 
            
            PIPE ROW(v_memo);            
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_memo.mean_memo_status := NULL;
            v_memo.memo_status := 'U';
    END;
    
  END get_default_memo_info;
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 20, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Retrieves credit/debit memo information
  */
  FUNCTION get_memo_list(
        p_branch_cd            IN  giac_cm_dm.branch_cd%TYPE,
        p_fund_cd              IN  giac_cm_dm.fund_cd%TYPE,
        p_gacc_tran_id         IN  giac_cm_dm.gacc_tran_id%TYPE,
        p_module               IN  giac_modules.module_name%TYPE,
        p_tran_status          IN  giac_acctrans.tran_flag%TYPE, --Added by Jerome Bautista 11.16.2015 SR 3467
        p_user_id              IN  giac_cm_dm.user_id%TYPE
  ) RETURN giac_cm_dm_tab PIPELINED
  IS
    v_memo  giac_cm_dm_type;
  BEGIN
    FOR rec IN (SELECT gacc_tran_id, fund_cd, branch_cd,
                       memo_type, memo_date,
                       memo_year, memo_seq_no,
                       memo_status, 
                       recipient, a.particulars,
                       amount, a.currency_rt,
                       local_amt, a.currency_cd,
                       a.user_id, a.last_update, dv_tran_id, -- Added by Jerome Bautista 01.06.2016 SR 3467
                       b.tran_flag, a.ri_comm_vat, a.ri_comm_amt -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 
                 FROM giac_cm_dm a, giac_acctrans b
                WHERE fund_cd       = NVL(p_fund_cd, fund_cd)
                  AND gacc_tran_id  = NVL(p_gacc_tran_id, gacc_tran_id)
                  AND gacc_tran_id = b.tran_id --Added by Jerome Bautista 01.05.2016
                  AND branch_cd     = NVL(p_branch_cd, branch_cd)
                  AND branch_cd IN (SELECT iss_cd
                                      FROM giis_issource
                                     WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(null, iss_cd, p_module, p_user_id),
                                                           1, iss_cd,
                                                           NULL))
                 AND tran_flag = NVL(p_tran_status, tran_flag) -- Added by Jerome Bautista 11.16.2015 SR 3467
                ORDER BY memo_date DESC, memo_type DESC, memo_seq_no DESC)
    LOOP
    
        v_memo.gacc_tran_id := rec.gacc_tran_id;
        v_memo.fund_cd := rec.fund_cd;
        v_memo.branch_cd := rec.branch_cd;
        v_memo.memo_type := rec.memo_type;
        v_memo.memo_date := TRUNC(rec.memo_date);
        v_memo.memo_year := rec.memo_year;
        v_memo.memo_seq_no := rec.memo_seq_no;
        v_memo.memo_status := rec.memo_status;
        v_memo.recipient := rec.recipient;
        v_memo.particulars := rec.particulars;
        v_memo.amount := rec.amount;
        v_memo.currency_rt := rec.currency_rt;
        v_memo.local_amt := rec.local_amt;
        v_memo.currency_cd := rec.currency_cd;
        v_memo.user_id := rec.user_id;
        v_memo.last_update := rec.last_update;
        v_memo.last_update_str := TO_CHAR(rec.last_update, 'mm-dd-yyyy HH:MI:SS AM');
        v_memo.memo_number := rec.memo_year || '-' || LPAD(rec.memo_seq_no, 6, 0);
        v_memo.dv_no := get_ref_no(rec.dv_tran_id); --Added by Jerome Bautista 01.05.2016
        v_memo.ri_comm_vat := rec.ri_comm_vat; -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
        v_memo.ri_comm_amt := rec.ri_comm_amt; -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
        
        /* Populate non-base table field to display domain meaning */
        BEGIN
            DECLARE
                v_curr_value    VARCHAR2(1) := rec.memo_status;
            BEGIN
               /* GIAC_CM_DM_PKG.cgdv$chk_char_ref_codes(v_curr_value, 
                                                       v_memo.mean_memo_status, 
                                                       'GIAC_CM_DM.MEMO_STATUS');*/
                chk_char_ref_codes(v_curr_value, 
                           v_memo.mean_memo_status, 
                           'GIAC_CM_DM.MEMO_STATUS');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_memo.mean_memo_status := NULL;
            END;
            
            DECLARE
                v_curr_value    VARCHAR2(3) := rec.memo_type;
            BEGIN
               chk_char_ref_codes(v_curr_value, 
                                  v_memo.mean_memo_type, 
                                  'GIAC_CM_DM.MEMO_TYPE');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_memo.mean_memo_type := NULL;
                    RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#Invalid value for Memo Type.');
            END;
        END;
        
        /* Query lookup data for the foreign key(s) */
        BEGIN
            BEGIN
                GIAC_CM_DM_PKG.cgfk$chk_gacc_gacc_gibr_fk(rec.branch_cd,
                                                          v_memo.branch_name,
                                                          v_memo.fund_desc,
                                                          v_memo.grac_rac_cd);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_memo.branch_name  := NULL;
                    v_memo.fund_desc    := NULL;
                    v_memo.grac_rac_cd  := NULL;
                WHEN OTHERS THEN NULL;
            END;
        END;
        
        BEGIN
            SELECT memo_date
              INTO v_memo.dsp_memo_date
              FROM giac_cm_dm
             WHERE gacc_tran_id = rec.gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                NULL;
        END;
        
        /* Populate foreign currency and default currency short names */
        BEGIN
            DECLARE
                CURSOR C IS SELECT short_name
                              FROM giis_currency
                             WHERE main_currency_cd = rec.currency_cd;
            BEGIN
            
                 OPEN C;
                FETCH C 
                 INTO v_memo.foreign_curr_sname;
            
                IF C%NOTFOUND THEN
                    RAISE NO_DATA_FOUND;
                END IF;
                CLOSE C;
                
                BEGIN
                    SELECT param_value_v
                      INTO v_memo.local_curr_sname
                      FROM giac_parameters
                     WHERE param_name LIKE 'DEFAULT_CURRENCY';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END; 
                
                BEGIN
                    SELECT currency_rt, main_currency_cd
                      INTO v_memo.local_curr_rt, v_memo.local_curr_cd
                      FROM giis_currency
                     WHERE short_name = v_memo.local_curr_sname;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END; 
                
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;
        END;
        
        BEGIN
            SELECT NVL(giacp.v('ALLOW_TRAN_FOR_CLOSED_MONTH'),'Y')
              INTO v_memo.allow_tran_tag
              FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.allow_tran_tag := 'Y';
        END;
        
        BEGIN
            SELECT GIAC_ACCTRANS_PKG.get_tran_flag(rec.gacc_tran_id)
              INTO v_memo.tran_flag 
              FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.tran_flag := '';
        END;
        
        BEGIN
            SELECT param_value_v 
              INTO v_memo.allow_print_tag
              FROM giac_parameters 
             WHERE param_name = 'ALLOW_PRINT_FOR_OPEN_CMDM';
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.allow_print_tag := '';
        END;
        
        BEGIN
            SELECT param_value_v cancel_param
              INTO v_memo.allow_cancel_tag
              FROM giac_parameters 
             WHERE param_name = 'ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH';
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.allow_cancel_tag := '';
        END;
        
        BEGIN
            SELECT (giac_cm_dm_pkg.get_closed_tag(v_memo.fund_cd, v_memo.branch_cd, v_memo.memo_date)) closed_tag
              INTO v_memo.closed_tag
              FROM dual; 
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.closed_tag := '';
        END;
        
        BEGIN
            SELECT (giac_cm_dm_pkg.check_applied_cm(p_gacc_tran_id))  
              INTO v_memo.check_applied_cm_tag
              FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.check_applied_cm_tag := 0;
        END;
        
        BEGIN  
            SELECT check_user_per_iss_cd_acctg2(null, p_branch_cd, p_module, p_user_id)
              INTO v_memo.check_user_tag
              FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                v_memo.check_user_tag := 0;
        END;
 
        PIPE ROW(v_memo);        
    END LOOP;
    
  END get_memo_list;
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 25, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Cancels credit/debit memo
                    Cancel_opt Program Unit
  */
  PROCEDURE cancel_cm_dm(
        p_gacc_tran_id      giac_cm_dm.gacc_tran_id%TYPE,
--        p_acc_tran_id 
        p_fund_cd           giac_cm_dm.fund_cd%TYPE,
        p_branch_cd         giac_cm_dm.branch_cd%TYPE,
        p_memo_type         giac_cm_dm.memo_type%TYPE,
        p_memo_year         giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no       giac_cm_dm.memo_seq_no%TYPE,
        p_memo_date         giac_cm_dm.memo_date%TYPE,
        p_user_id           giac_cm_dm.user_id%TYPE,
        p_tran_flag         giac_acctrans.tran_flag%TYPE,
        p_message           OUT VARCHAR2
  )
  IS
    v_cancel        giac_parameters.param_value_v%TYPE;
    v_closed_tag    giac_parameters.param_value_v%TYPE;
    
    v_dummy       	NUMBER; 	
    v_acc_tran_id   giac_acctrans.tran_id%TYPE;  -- gagamitin ni AEG_PARAMETERS_REV; placeholder for variables.tran_id
  BEGIN
    GIIS_USERS_PKG.app_user := p_user_id; --marco - 06.11.2013
    IF NVL(giacp.v('ENTER_ADVANCED_PAYT'),'N') = 'Y' THEN 	               	     	   		               
	    BEGIN
            SELECT count(*)
   	          INTO v_dummy
   	          FROM giac_advanced_payt
   	         WHERE gacc_tran_id = p_gacc_tran_id
   	           AND acct_ent_date IS NOT NULL;   	        
		
        EXCEPTION
            WHEN no_data_found THEN
			    v_dummy := 0;
		END;                         	    
     	        
        IF v_dummy > 0 THEN
            -- originally insert_acctrans_cap in fmb
	        GIAC_CM_DM_PKG.insert_acctrans_071(p_fund_cd    , p_branch_cd, SYSDATE,
                                               p_memo_type  , p_memo_year, p_memo_seq_no,
                                               p_memo_date  , 'CAP'      , v_acc_tran_id,
                                               p_user_id    , p_message);                                                                  

			GIAC_CM_DM_PKG.aeg_parameters_rev_071(p_gacc_tran_id, 'GIACB005', 
                                                  v_acc_tran_id, 
                                                  p_fund_cd, p_branch_cd, p_message);
        END IF;     
                
		UPDATE giac_advanced_payt
           SET cancel_date      = SYSDATE, 
               rev_gacc_tran_id = v_acc_tran_id,
               user_id = p_user_id,
               last_update = SYSDATE
		 WHERE gacc_tran_id = p_gacc_tran_id;   
                       
    END IF;
    
    IF p_tran_flag = 'P' THEN
	    --call procedures to create the reversing entries
        -- originally  -->
--     done.   1. create_records_in_acctrans(:gcmdm.fund_cd, :gcmdm.branch_cd, SYSDATE);        
--     done.   2. insert_into_reversals;
--     done.   3. gen_reversing_acct_entries;

        GIAC_CM_DM_PKG.insert_acctrans_071(p_fund_cd    , p_branch_cd, SYSDATE,
                                           p_memo_type  , p_memo_year, p_memo_seq_no,
                                           p_memo_date  , NULL       , v_acc_tran_id,
                                           p_user_id    , p_message); 
                                           
        GIAC_CM_DM_PKG.insert_into_reversals_071(p_gacc_tran_id, v_acc_tran_id, p_message);
        
        GIAC_ACCT_ENTRIES_PKG.gen_reversing_acct_entries(p_gacc_tran_id, p_fund_cd, p_branch_cd, v_acc_tran_id);
        
        
    ELSE
	    UPDATE giac_acctrans
           SET tran_flag = 'D'
         WHERE tran_id = p_gacc_tran_id;
	END IF;              
    
    UPDATE giac_cm_dm
       SET memo_status = 'C',
           user_id = p_user_id,
           last_update = SYSDATE
     WHERE gacc_tran_id = p_gacc_tran_id;    			
    
	p_message := 'Credit/Debit Memo (CM/DM) cancellation procedure complete.';
  
  END cancel_cm_dm;
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 20, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   This trigger checks that the given value exists in the REF_CODES 
                    table for the given domain.  It must be either one of the distinct
                    values, or within one of the ranges (high value not null).
  */
--  PROCEDURE cgdv$chk_char_ref_codes(
--        p_value		IN OUT VARCHAR2      /* Value to be validated  */
--        , p_meaning	IN OUT VARCHAR2      /* Domain meaning         */
--        , p_domain	IN     VARCHAR2      /* Reference codes domain */
--  ) 
--  IS
--    v_new_value       VARCHAR2(240);
--	v_curr_value      VARCHAR2(240);
--  BEGIN
--  
--    v_curr_value := p_value;
--    
--    IF v_curr_value IS NOT NULL THEN
--        SELECT DECODE(rv_high_value, NULL, rv_low_value, v_curr_value),
--               rv_meaning
--          INTO v_new_value,
--               p_meaning
--          FROM cg_ref_codes
--         WHERE ((rv_high_value IS NULL 
--                               AND v_curr_value IN (rv_low_value, rv_abbreviation))
--                 OR
--                 (v_curr_value BETWEEN rv_low_value AND rv_high_value))
--            AND rownum = 1
--            AND rv_domain = p_domain;
--            
--        p_value := v_new_value;
--    END IF;
--    
--  END cgdv$chk_char_ref_codes;
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 20, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Validates foreign key value/query lookup data.
  */
  PROCEDURE CGFK$CHK_GACC_GACC_GIBR_FK (
        p_branch_cd     IN OUT      giac_cm_dm.branch_cd%TYPE,
        p_branch_name   IN OUT      giac_branches.branch_name%TYPE,
        p_fund_desc     IN OUT      giis_funds.fund_desc%TYPE,
        p_grac_rac_cd   IN OUT      giis_funds.grac_rac_cd%TYPE 
  )
  IS
  
  BEGIN
    
    DECLARE
        CURSOR C IS SELECT GIBR.branch_name, 
                           GFUN.fund_desc,
                           GFUN.grac_rac_cd
                      FROM giac_branches GIBR,
                           giis_funds GFUN
                     WHERE GIBR.branch_cd = p_branch_cd
                       AND GFUN.fund_cd= GIBR.gfun_fund_cd;   
    BEGIN
        OPEN C;
        FETCH C
         INTO p_branch_name,
              p_fund_desc,
              p_grac_rac_cd;
    
        IF C%NOTFOUND THEN
            RAISE NO_DATA_FOUND;
        END IF;
        
        CLOSE C;
    EXCEPTION
        WHEN OTHERS THEN 
            NULL;
    END;  
  
  END CGFK$CHK_GACC_GACC_GIBR_FK;
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 2, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Gets the value for closed tag of the given memo date
                    When-Validate-Item Trigger for dsp_memo_date
  */
  FUNCTION get_closed_tag(
        p_fund_cd   IN  giac_tran_mm.fund_cd%TYPE,
        p_branch_cd IN  giac_tran_mm.branch_cd%TYPE,
        p_date      IN  giac_acctrans.tran_date%TYPE
  ) RETURN VARCHAR2
  IS
    v_closed_tag  giac_tran_mm.closed_tag%TYPE;
  BEGIN
    FOR a1 IN (SELECT closed_tag
                 FROM giac_tran_mm
                WHERE fund_cd = p_fund_cd
               	--AND branch_cd = giacp.v('BRANCH_CD')--commented by totel--10/27/2006
               	AND branch_cd = p_branch_cd      --replacement for the commented where clause.
                                                 --to consider the branch of the transaction in the validation of the date being entered. 
               	AND tran_yr = to_number(to_char(p_date, 'YYYY'))
               	AND tran_mm = to_number(to_char(p_date, 'MM'))) 
	LOOP
        v_closed_tag := a1.closed_tag;
        EXIT;
    END LOOP;          
       
    RETURN (v_closed_tag);
  END get_closed_tag;
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 2, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Checks if or_flag of a memo is cancelled, replaced, or deleted.
                    Check_Applied_Cm function body
  */
  FUNCTION check_applied_cm(
        p_gacc_tran_id  IN  giac_cm_dm.gacc_tran_id%TYPE
  ) RETURN NUMBER
  IS
    v_cm_used		NUMBER:=0;
  BEGIN
      SELECT 1
 		INTO v_cm_used 
		FROM giac_order_of_payts a, 
             giac_collection_dtl b 
	   WHERE a.gacc_tran_id = b.gacc_tran_id 
		 AND b.cm_tran_id = p_gacc_tran_id
		 AND b.pay_mode = 'CMI' 
		 AND a.or_flag NOT IN ('C','R','D')
		 AND ROWNUM = 1;
         
	RETURN v_cm_used;
    	 
  EXCEPTION 
    WHEN no_data_found THEN
        RETURN v_cm_used;
        
  END check_applied_cm;
  
  
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  April 9, 2013
    ** Reference by:  GIACS071 - Credit Memo / Debit Memo
    ** Description:   Updates the status to "P" if memo has been successfully printed.
    */
    PROCEDURE update_memo_status(
        p_gacc_tran_id      giac_cm_dm.gacc_tran_id%TYPE,
        p_memo_status       giac_cm_dm.memo_status%TYPE,
        p_user_id           giac_cm_dm.user_id%TYPE
    ) IS
    
    BEGIN
    
        IF p_memo_status = 'U' THEN
            UPDATE giac_cm_dm
               SET memo_status = 'P',
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = p_gacc_tran_id;
        END IF;
    
    END update_memo_status;

   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 25, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Gets the list of recipients
  */
  FUNCTION get_recipient_list RETURN recipient_tab PIPELINED
    IS
        v_recipient     recipient_type;
    BEGIN
        FOR rec IN (SELECT UPPER(intm_name) fname,
                           'INTERMEDIARY' recipient_type
                      FROM giis_intermediary
                     WHERE intm_no > 0 
                     UNION ALL
                    SELECT UPPER(assd_name) fname,
                           'ASSURED' recipient_type
                      FROM giis_assured
                     WHERE assd_no > 0
                     UNION ALL  -- For consolidation as per Sir Robert. -- Jerome 01.06.2016
                    SELECT UPPER(ri_name) fname,
                           'REINSURER' recipient_type
                      FROM giis_reinsurer
                     WHERE ri_cd > 0
                     ORDER BY 1)
        LOOP
            IF LENGTH(rec.fname) > 240 THEN -- limit the recipient to the max size of giac_cm_dm.recipient 
                v_recipient.recipient_name := SUBSTR(rec.fname, 0, 240);
            ELSE
                v_recipient.recipient_name := rec.fname;
            END IF;
                    
            v_recipient.recipient_type := rec.recipient_type;
            
            PIPE ROW(v_recipient);
        END LOOP;
        
    END get_recipient_list;
    
    FUNCTION validate_curr_sname(
        p_curr_sname        giis_currency.short_name%TYPE
    ) RETURN VARCHAR2
    IS
        v_valid     VARCHAR2(1) := 'N';
    BEGIN
        FOR c IN (SELECT main_currency_cd, currency_rt rate 
					FROM giis_currency
                   WHERE short_name LIKE p_curr_sname)
	    LOOP
		    v_valid := 'Y';
            EXIT;            
    	END LOOP;
        
        RETURN (v_valid); 
    END; 
    
  ------------------------ CREATION OF ACCOUNTING ENTRIES ------------------------ 
      
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 25, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Creates accounting entries.
                    Executes AEG_PARAMETERS Program Unit
  */
  PROCEDURE aeg_parameters_071 (
    p_aeg_tran_id       giac_acctrans.tran_id%TYPE,   
    p_aeg_module_name   giac_modules.module_name%TYPE,
    p_branch_cd            IN  giac_acct_entries.gacc_gibr_branch_cd%TYPE,
    p_fund_cd         IN  giac_acct_entries.gacc_gfun_fund_cd%TYPE,
    p_user_id         IN  giac_acct_entries.user_id%TYPE
--    p_gacc_tran_id         IN  giac_acct_entries.gacc_tran_id%TYPE
  ) IS
        CURSOR cur_cm IS
        SELECT NVL(local_amt,0) local_amt
          FROM giac_cm_dm
         WHERE gacc_tran_id = p_aeg_tran_id
           AND memo_type IN ('CM','RCM');   -- judyann 12112012; added RCM memo_type       
           
        CURSOR cur_dm IS
        SELECT NVL(local_amt,0) local_amt
          FROM giac_cm_dm
         WHERE gacc_tran_id = p_aeg_tran_id
           AND memo_type = 'DM';   
           
        v_module_id     giac_modules.module_id%TYPE;
        v_gen_type      giac_modules.generation_type%TYPE; 
        v_outfacul_comm_vat_entry	giac_parameters.param_value_v%TYPE := giacp.v('OUTFACUL_COMM_VAT_ENTRY'); -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
    BEGIN
        BEGIN
            SELECT module_id,
                   generation_type
              INTO v_module_id,
                   v_gen_type
              FROM giac_modules
             WHERE module_name  = p_aeg_module_name;
        EXCEPTION
            WHEN no_data_found THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#No data found in GIAC MODULES. module: ' || p_aeg_module_name);
        END;
      
        /*
        ** Call the deletion of accounting entry procedure.
        */
        giac_acct_entries_pkg.aeg_delete_acct_entries(p_aeg_tran_id, v_gen_type);
        
        /*
        ** Call the accounting entry generation procedure.
        */
      
        FOR rec_cm IN cur_cm 
        LOOP
            GIAC_CM_DM_PKG.aeg_create_acct_entries_071(v_module_id,
                                                   1, 
                                                   rec_cm.local_amt,
                                                   v_gen_type,
                                                   p_branch_cd,     -- added params
                                                   p_fund_cd,
                                                   p_aeg_tran_id,
                                                   p_user_id);  -- added params
        END LOOP;
        
        FOR rec_dm IN cur_dm 
        LOOP
            GIAC_CM_DM_PKG.aeg_create_acct_entries_071(v_module_id  ,
                                                   2, 
                                                   rec_dm.local_amt,
                                                   v_gen_type,
                                                   p_branch_cd,     -- added params
                                                   p_fund_cd,
                                                   p_aeg_tran_id,
                                                   p_user_id);  -- added params
        END LOOP;
        
        -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
        IF v_outfacul_comm_vat_entry = 'CO' THEN
           FOR i IN (SELECT NVL(ri_comm_vat,0) ri_comm_vat
			           FROM giac_cm_dm
			          WHERE gacc_tran_id = p_aeg_tran_id
			            AND memo_type = 'RCM')
			LOOP
				GIAC_CM_DM_PKG.aeg_create_acct_entries_071(v_module_id  ,
                                                   4, 
                                                   i.ri_comm_vat,
                                                   v_gen_type,
                                                   p_branch_cd,
                                                   p_fund_cd,
                                                   p_aeg_tran_id,
                                                   p_user_id); 
			END LOOP;
        END IF;

    END aeg_parameters_071;
    
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 25, 2013
    ** Reference by:  GIACS071 - Credit Memo / Debit Memo
    ** Description:   This procedure handles the creation of accounting entries
                      per transaction.
                      AEG_CREATE_ACCT_ENTRIES Program Unit
    */  
    PROCEDURE aeg_create_acct_entries_071 (
        aeg_module_id          giac_module_entries.module_id%TYPE,
        aeg_item_no            giac_module_entries.item_no%TYPE,
        aeg_acct_amt           giac_cm_dm.local_amt%TYPE,
        aeg_gen_type           giac_acct_entries.generation_type%TYPE,
        p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
        p_user_id              giac_acct_entries.user_id%TYPE
    ) IS 
          ws_gl_acct_category              giac_acct_entries.gl_acct_category%TYPE;
          ws_gl_control_acct               giac_acct_entries.gl_control_acct%TYPE;
          ws_gl_sub_acct_1                 giac_acct_entries.gl_sub_acct_1%TYPE;
          ws_gl_sub_acct_2                 giac_acct_entries.gl_sub_acct_2%TYPE;
          ws_gl_sub_acct_3                 giac_acct_entries.gl_sub_acct_3%TYPE;
          ws_gl_sub_acct_4                 giac_acct_entries.gl_sub_acct_4%TYPE;
          ws_gl_sub_acct_5                 giac_acct_entries.gl_sub_acct_5%TYPE;
          ws_gl_sub_acct_6                 giac_acct_entries.gl_sub_acct_6%TYPE;
          ws_gl_sub_acct_7                 giac_acct_entries.gl_sub_acct_7%TYPE;
          ws_pol_type_tag                  giac_module_entries.pol_type_tag%TYPE;
          ws_intm_type_level               giac_module_entries.intm_type_level%TYPE;
          ws_old_new_acct_level            giac_module_entries.old_new_acct_level%TYPE;
          ws_line_dep_level                giac_module_entries.line_dependency_level%TYPE;
          ws_dr_cr_tag                     giac_module_entries.dr_cr_tag%TYPE;
          ws_acct_intm_cd                  giis_intm_type.acct_intm_cd%TYPE;
          ws_line_cd                       giis_line.line_cd%TYPE;
          ws_iss_cd                        gipi_polbasic.iss_cd%TYPE;
          ws_old_acct_cd                   giac_acct_entries.gl_sub_acct_2%TYPE;
          ws_new_acct_cd                   giac_acct_entries.gl_sub_acct_2%TYPE;
          pt_gl_sub_acct_1                 giac_acct_entries.gl_sub_acct_1%TYPE;
          pt_gl_sub_acct_2                 giac_acct_entries.gl_sub_acct_2%TYPE;
          pt_gl_sub_acct_3                 giac_acct_entries.gl_sub_acct_3%TYPE;
          pt_gl_sub_acct_4                 giac_acct_entries.gl_sub_acct_4%TYPE;
          pt_gl_sub_acct_5                 giac_acct_entries.gl_sub_acct_5%TYPE;
          pt_gl_sub_acct_6                 giac_acct_entries.gl_sub_acct_6%TYPE;
          pt_gl_sub_acct_7                 giac_acct_entries.gl_sub_acct_7%TYPE;
          ws_debit_amt                     giac_acct_entries.debit_amt%TYPE;
          ws_credit_amt                    giac_acct_entries.credit_amt%TYPE;  
          ws_gl_acct_id                    giac_acct_entries.gl_acct_id%TYPE;    
          
          v_message                         VARCHAR2(2000) := null;
    BEGIN 

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      
      BEGIN
            SELECT gl_acct_category, gl_control_acct,
                   gl_sub_acct_1   , gl_sub_acct_2  ,
                   gl_sub_acct_3   , gl_sub_acct_4  ,
                   gl_sub_acct_5   , gl_sub_acct_6  ,
                   gl_sub_acct_7   , pol_type_tag   ,
                   intm_type_level , old_new_acct_level,
                   dr_cr_tag       , line_dependency_level
              INTO ws_gl_acct_category, ws_gl_control_acct,
                   ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
                   ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
                   ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
                   ws_gl_sub_acct_7   , ws_pol_type_tag   ,
                   ws_intm_type_level , ws_old_new_acct_level,
                   ws_dr_cr_tag       , ws_line_dep_level
              FROM giac_module_entries
             WHERE module_id = aeg_module_id
               AND item_no   = aeg_item_no
               FOR UPDATE of gl_sub_acct_1;
            
      EXCEPTION
        WHEN no_data_found THEN
--            NULL;
              --RAISE_APPLICATION_ERROR(-20001,'No data found in giac_module_entries: GIACS071 - Credit/Debit Memo.');
              RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#No data found in giac_module_entries: GIACS071 - Credit/Debit Memo.'); -- marco - 04.22.2013 - dagdag message para macatch
      END;
      
      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/

--        GIAC_CM_DM_PKG.aeg_check_chart_of_accts_071(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
--                                 ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
--                                 ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
--                                 ws_gl_acct_id);
        giac_acct_entries_pkg.aeg_check_chart_of_accts(ws_gl_acct_category, ws_gl_control_acct,
                                                   ws_gl_sub_acct_1   , ws_gl_sub_acct_2  , ws_gl_sub_acct_3,
                                                   ws_gl_sub_acct_4   , ws_gl_sub_acct_5  , ws_gl_sub_acct_6,
                                                   ws_gl_sub_acct_7   , 
                                                   ws_gl_acct_id      , v_message);
        
        IF v_message IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#'||v_message);
        END IF;                                 
                  
      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/

      IF ws_dr_cr_tag = 'D' THEN
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := abs(aeg_acct_amt);
            ws_credit_amt := 0;
          ELSE
            ws_debit_amt  := 0;
            ws_credit_amt := abs(aeg_acct_amt);
          END IF;
      ELSE
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := 0;
            ws_credit_amt := abs(aeg_acct_amt);
          ELSE
            ws_debit_amt  := abs(aeg_acct_amt);
            ws_credit_amt := 0;
          END IF;
      END IF; 
      
      
      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/

       GIAC_CM_DM_PKG.aeg_set_acct_entries_071(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                               ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                               aeg_gen_type       , ws_gl_acct_id     , ws_debit_amt    , 
                                               ws_credit_amt,
                                               p_branch_cd, p_fund_cd, p_gacc_tran_id, p_user_id);   -- added params           

    END aeg_create_acct_entries_071;
    
    
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 25, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   This procedure determines whether the records will be 
                    updated or inserted in GIAC_ACCT_ENTRTIES.
                    Executes AEG_INSERT_UPDATE_ACCT_ENTRIES Program Unit
  */
  PROCEDURE aeg_set_acct_entries_071 (
         iuae_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE,
         iuae_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE,
         iuae_generation_type   giac_acct_entries.generation_type%TYPE,
         iuae_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
         iuae_debit_amt         giac_acct_entries.debit_amt%TYPE,
         iuae_credit_amt        giac_acct_entries.credit_amt%TYPE,
         
         p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
         p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
         p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
         p_user_id              giac_acct_entries.user_id%TYPE
    ) IS
        iuae_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
    BEGIN
        SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
          INTO iuae_acct_entry_id
          FROM giac_acct_entries
         WHERE gacc_gibr_branch_cd = p_branch_cd 
           AND gacc_gfun_fund_cd   = p_fund_cd 
           AND gacc_tran_id        = p_gacc_tran_id 
           AND gl_acct_id          = iuae_gl_acct_id
           AND generation_type     = iuae_generation_type;
         
         
        IF nvl(iuae_acct_entry_id,0) = 0 THEN
            iuae_acct_entry_id := nvl(iuae_acct_entry_id,0) + 1;
            INSERT INTO giac_acct_entries(gacc_tran_id       , gacc_gfun_fund_cd,
                                      gacc_gibr_branch_cd, acct_entry_id    ,
                                      gl_acct_id         , gl_acct_category ,
                                      gl_control_acct    , gl_sub_acct_1    ,
                                      gl_sub_acct_2      , gl_sub_acct_3    ,
                                      gl_sub_acct_4      , gl_sub_acct_5    ,
                                      gl_sub_acct_6      , gl_sub_acct_7    ,
                                      sl_cd              , debit_amt        ,
                                      credit_amt         , generation_type  ,
                                      user_id            , last_update)
            VALUES (p_gacc_tran_id               , p_fund_cd                   ,
                   p_branch_cd                   , iuae_acct_entry_id          ,
                   iuae_gl_acct_id               , iuae_gl_acct_category       ,
                   iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                   iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                   iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                   iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                   NULL                          , iuae_debit_amt              ,
                   iuae_credit_amt               , iuae_generation_type        ,
                   p_user_id             		 , SYSDATE); --marco - 06.11.2013 - added p_user_id parameter
        ELSE
            UPDATE giac_acct_entries
               SET debit_amt  = debit_amt  + iuae_debit_amt,
                   credit_amt = credit_amt + iuae_credit_amt,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE generation_type     = iuae_generation_type
               AND gl_acct_id          = iuae_gl_acct_id
               AND gacc_gibr_branch_cd = p_branch_cd
               AND gacc_gfun_fund_cd   = p_fund_cd 
               AND gacc_tran_id        = p_gacc_tran_id ;
        END IF;
        
    END aeg_set_acct_entries_071;
    
    
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 25, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   This procedure checks the existence of GL codes 
                    in GIAC_CHART_OF_ACCTS. 
                    Executes AEG_CHECK_CHART_OF_ACCTS Program Unit
  */
--  PROCEDURE aeg_check_chart_of_accts_071(
--         cca_gl_acct_category    giac_acct_entries.gl_acct_category%TYPE,
--         cca_gl_control_acct     giac_acct_entries.gl_control_acct%TYPE,
--         cca_gl_sub_acct_1       giac_acct_entries.gl_sub_acct_1%TYPE,
--         cca_gl_sub_acct_2       giac_acct_entries.gl_sub_acct_2%TYPE,
--         cca_gl_sub_acct_3       giac_acct_entries.gl_sub_acct_3%TYPE,
--         cca_gl_sub_acct_4       giac_acct_entries.gl_sub_acct_4%TYPE,
--         cca_gl_sub_acct_5       giac_acct_entries.gl_sub_acct_5%TYPE,
--         cca_gl_sub_acct_6       giac_acct_entries.gl_sub_acct_6%TYPE,
--         cca_gl_sub_acct_7       giac_acct_entries.gl_sub_acct_7%TYPE,
--         cca_gl_acct_id   IN OUT giac_chart_of_accts.gl_acct_id%TYPE
--  ) IS
--  BEGIN
--  
--      SELECT DISTINCT(gl_acct_id)
--        INTO cca_gl_acct_id
--        FROM giac_chart_of_accts
--       WHERE gl_acct_category  = cca_gl_acct_category
--         AND gl_control_acct   = cca_gl_control_acct
--         AND gl_sub_acct_1     = cca_gl_sub_acct_1
--         AND gl_sub_acct_2     = cca_gl_sub_acct_2
--         AND gl_sub_acct_3     = cca_gl_sub_acct_3
--         AND gl_sub_acct_4     = cca_gl_sub_acct_4
--         AND gl_sub_acct_5     = cca_gl_sub_acct_5
--         AND gl_sub_acct_6     = cca_gl_sub_acct_6
--         AND gl_sub_acct_7     = cca_gl_sub_acct_7;
--         
--  EXCEPTION
--    WHEN no_data_found THEN
--		RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#GL account code '||to_char(cca_gl_acct_category)
--              ||'-'||to_char(cca_gl_control_acct,'09') 
--              ||'-'||to_char(cca_gl_sub_acct_1,'09')
--              ||'-'||to_char(cca_gl_sub_acct_2,'09')
--              ||'-'||to_char(cca_gl_sub_acct_3,'09')
--              ||'-'||to_char(cca_gl_sub_acct_4,'09')
--              ||'-'||to_char(cca_gl_sub_acct_5,'09')
--              ||'-'||to_char(cca_gl_sub_acct_6,'09')
--              ||'-'||to_char(cca_gl_sub_acct_7,'09')
--              ||' does not exist in Chart of Accounts (Giac_Acctrans).');
--              
--  END aeg_check_chart_of_accts_071;
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 3, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Executes AEG_PARAMETERS_REV Program Unit on GIACS071
  */
  PROCEDURE aeg_parameters_rev_071 (
          p_aeg_tran_id               giac_acctrans.tran_id%TYPE,
          p_aeg_module_nm             giac_modules.module_name%TYPE,
          p_acc_tran_id               giac_acctrans.tran_id%TYPE,
          p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
          p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
          p_message             OUT   VARCHAR2
   ) IS
        CURSOR colln_cur IS 
		SELECT a.assd_no, b.line_cd, SUM(premium_amt + tax_amt) coll_amt
	      FROM giac_advanced_payt a, gipi_polbasic b
		 WHERE gacc_tran_id = p_aeg_tran_id
		   AND a.policy_id = b.policy_id
		   AND a.acct_ent_date IS NOT NULL
		 GROUP BY a.assd_no, b.line_cd;
         
         v_module_id   giac_modules.module_id%TYPE;
         v_gen_type    giac_modules.generation_type%TYPE;
   BEGIN
         BEGIN
            SELECT module_id,
                   generation_type
              INTO v_module_id,
                   v_gen_type
              FROM giac_modules
             WHERE module_name  = 'GIACB005';  	
         EXCEPTION
            WHEN no_data_found THEN
                p_message := 'No data found in GIAC MODULES.';
         END;

         giac_acct_entries_pkg.aeg_delete_entries_rev(p_aeg_tran_id, v_gen_type);       
           
         FOR colln_rec IN colln_cur
         LOOP
            GIAC_CM_DM_PKG.create_rev_entries_071(colln_rec.assd_no  , colln_rec.coll_amt, colln_rec.line_cd,
                                                  p_gibr_gfun_fund_cd, p_gibr_branch_cd  , p_acc_tran_id    , p_message) ;
         END LOOP;     
  
   END aeg_parameters_rev_071;
   
   
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 3, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Executes CREATE_REV_ENTRIES Program Unit on GIACS071
  */
  PROCEDURE create_rev_entries_071 (
          p_assd_no                      gipi_polbasic.assd_no%TYPE,
          p_coll_amt                     giac_comm_payts.comm_amt%TYPE,
          p_line_cd                      giis_line.line_cd%TYPE,
          p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
          p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
          p_acc_tran_id                  giac_acctrans.tran_id%TYPE,
          p_message             OUT      VARCHAR2
  ) IS
        x_intm_no       				giis_intermediary.intm_no%TYPE;
        w_sl_cd         				giac_acct_entries.sl_cd%TYPE;
        y_sl_cd            				giac_acct_entries.sl_cd%TYPE;
        z_sl_cd             			giac_acct_entries.sl_cd%TYPE;

        v_gl_acct_category  			giac_acct_entries.gl_acct_category%TYPE; 
        v_gl_control_acct   			giac_acct_entries.gl_control_acct%TYPE;
        v_gl_sub_acct_1  				giac_acct_entries.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2  				giac_acct_entries.gl_sub_acct_2%TYPE;
        v_gl_sub_acct_3  				giac_acct_entries.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4  				giac_acct_entries.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5  				giac_acct_entries.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6  				giac_acct_entries.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7  				giac_acct_entries.gl_sub_acct_7%TYPE;

        v_intm_type_level  				giac_module_entries.intm_type_level%TYPE;
        v_line_dependency_level 	    giac_module_entries.line_dependency_level%TYPE;
        v_dr_cr_tag         			giac_module_entries.dr_cr_tag%TYPE;
        v_debit_amt   					giac_acct_entries.debit_amt%TYPE;
        v_credit_amt  					giac_acct_entries.credit_amt%TYPE;
        v_acct_entry_id 				giac_acct_entries.acct_entry_id%TYPE;
        v_gen_type      				giac_modules.generation_type%TYPE;
        v_gl_acct_id    				giac_chart_of_accts.gl_acct_id%TYPE;
        v_sl_type_cd    				giac_module_entries.sl_type_cd%TYPE;--07/31/99 JEANNETTE
        v_sl_type_cd2    				giac_module_entries.sl_type_cd%TYPE;
        v_sl_type_cd3    				giac_module_entries.sl_type_cd%TYPE;
        ws_line_cd	    				giac_acct_entries.gl_sub_acct_6%TYPE;
        v_gl_intm_no        			giac_comm_payts.intm_no%TYPE;
        v_gl_assd_no        			gipi_polbasic.assd_no%TYPE;
        v_gl_acct_line_cd   			giis_line.acct_line_cd%TYPE; 
        ws_acct_intm_cd     			giis_intm_type.acct_intm_cd%TYPE;
  BEGIN
  
    BEGIN
        	SELECT a.gl_acct_category, a.gl_control_acct,
				   nvl(a.gl_sub_acct_1,0), nvl(a.gl_sub_acct_2,0), nvl(a.gl_sub_acct_3,0), nvl(a.gl_sub_acct_4,0),
                   nvl(a.gl_sub_acct_5,0), nvl(a.gl_sub_acct_6,0), nvl(a.gl_sub_acct_7,0), nvl(a.intm_type_level,0),
        	       a.dr_cr_tag, b.generation_type, a.sl_type_cd, a.line_dependency_level
			  INTO v_gl_acct_category, v_gl_control_acct, 
                   v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4, 
                   v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7, v_intm_type_level,
		           v_dr_cr_tag, v_gen_type, v_sl_type_cd, v_line_dependency_level  
			  FROM giac_module_entries a, giac_modules b
		     WHERE b.module_name = 'GIACB005' 
			   AND a.item_no = 1
			   AND b.module_id = a.module_id; 
    EXCEPTION   
        WHEN no_data_found THEN
--            p_message := 'CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.';
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.');
    END;
    
    giac_acct_entries_pkg.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
                                                   v_gl_sub_acct_1   , v_gl_sub_acct_2  , v_gl_sub_acct_3,
                                                   v_gl_sub_acct_4   , v_gl_sub_acct_5  , v_gl_sub_acct_6,
                                                   v_gl_sub_acct_7   , 
                                                   v_gl_acct_id      , p_message);
                                                   
                                                   
    IF  p_coll_amt > 0 THEN  		--3.1               
    
 	    IF v_dr_cr_tag = 'D' THEN
    	    v_debit_amt  := 0;
            v_credit_amt := p_coll_amt;
 	    ELSE
    	    v_debit_amt  := p_coll_amt;
            v_credit_amt := 0;
        END IF;  

	ELSIF p_coll_amt < 0 THEN
  
  	    IF v_dr_cr_tag = 'D' THEN
    	    v_debit_amt := p_coll_amt * -1;
            v_credit_amt := 0;
        ELSE
    	    v_debit_amt  := 0;
            v_credit_amt := p_coll_amt * -1;
        END IF;    

	END IF;				--3.2
    
    giac_acct_entries_pkg.aeg_insert_update_entries_rev(v_gl_acct_category , v_gl_control_acct,
                                                        v_gl_sub_acct_1    , v_gl_sub_acct_2  , v_gl_sub_acct_3,
                                                        v_gl_sub_acct_4    , v_gl_sub_acct_5  , v_gl_sub_acct_6,
                                                        v_gl_sub_acct_7    , v_sl_type_cd     ,
                                                        '1'                , p_assd_no        , v_gen_type, 
                                                        v_gl_acct_id       , v_debit_amt      , v_credit_amt,
                                                        p_gibr_gfun_fund_cd, p_gibr_branch_cd , p_acc_tran_id);
                                                        
    BEGIN	--e1

        BEGIN      
          SELECT a.gl_acct_category    , a.gl_control_acct,
                 nvl(a.gl_sub_acct_1,0), nvl(a.gl_sub_acct_2,0), nvl(a.gl_sub_acct_3,0), nvl(a.gl_sub_acct_4,0),
                 nvl(a.gl_sub_acct_5,0), nvl(a.gl_sub_acct_6,0), nvl(a.gl_sub_acct_7,0), a.sl_type_cd, nvl(a.line_dependency_level,0), a.dr_cr_tag,
                 b.generation_type 
            INTO v_gl_acct_category, v_gl_control_acct, 
                 v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4, 
                 v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7, v_sl_type_cd, v_line_dependency_level, v_dr_cr_tag,
                 v_gen_type
            FROM giac_module_entries a, giac_modules b
           WHERE b.module_name = 'GIACB005' 
             AND a.item_no     = 2
             AND b.module_id   = a.module_id; 

        EXCEPTION
            WHEN no_data_found THEN
                p_message := 'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 2.';
        END;	--e2
        
        IF v_line_dependency_level != 0 THEN
        
            BEGIN	--d1
      	        SELECT acct_line_cd
         	      INTO ws_line_cd
         	      FROM giis_line
                 WHERE line_cd = p_line_cd;
            EXCEPTION
      	        WHEN no_data_found THEN
            	    p_message := 'No data found in giis_line.';      
            END;	--d2
            
            giac_acct_entries_pkg.aeg_check_level(v_line_dependency_level, ws_line_cd,
		    	          	                      v_gl_sub_acct_1        , v_gl_sub_acct_2,
		    	          	                      v_gl_sub_acct_3        , v_gl_sub_acct_4,
		    	          	                      v_gl_sub_acct_5        , v_gl_sub_acct_6,
                    	                          v_gl_sub_acct_7);
        END IF;
        
        giac_acct_entries_pkg.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
                                                       v_gl_sub_acct_1   , v_gl_sub_acct_2,
                                                       v_gl_sub_acct_3   , v_gl_sub_acct_4,
                                                       v_gl_sub_acct_5   , v_gl_sub_acct_6,
                                                       v_gl_sub_acct_7   , v_gl_acct_id, p_message);
                                                       
        IF  p_coll_amt > 0 THEN   	---- 4.1   
            IF v_dr_cr_tag = 'D' THEN
                v_debit_amt  := 0;
                v_credit_amt := p_coll_amt;
            ELSE
                v_debit_amt  := p_coll_amt;
                v_credit_amt := 0;
            END IF;  
        ELSIF p_coll_amt < 0 THEN
            IF v_dr_cr_tag = 'D' THEN
                v_debit_amt  := p_coll_amt * -1;
                v_credit_amt := 0;
            ELSE
                v_debit_amt  := 0;
                v_credit_amt := p_coll_amt * -1;
            END IF;
        END IF;		   
        
        giac_acct_entries_pkg.aeg_insert_update_entries_rev(v_gl_acct_category, v_gl_control_acct,
                                                            v_gl_sub_acct_1   , v_gl_sub_acct_2  , v_gl_sub_acct_3,
                                                            v_gl_sub_acct_4   , v_gl_sub_acct_5  , v_gl_sub_acct_6,
                                                            v_gl_sub_acct_7   , v_sl_type_cd     , '1'            , 
                                                            p_assd_no         , v_gen_type       , 
                                                            v_gl_acct_id      , v_debit_amt      , v_credit_amt,
                                                            p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_acc_tran_id);  
    
    END;
   
  END create_rev_entries_071;
  
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 3, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Creates reversing entry in giac_acctrans for posted Memo that is being cancelled
  **                and which has an advanced payment.
  **                Executes INSERT_ACCTRANS_CAP  and 
  **                CREATE_RECORDS_IN_ACCTRANS Program Units on GIACS071
  */
  PROCEDURE insert_acctrans_071 (
        p_fund_cd          giac_cm_dm.fund_cd%TYPE,
  		p_branch_cd        giac_cm_dm.branch_cd%TYPE,
        p_rev_tran_date    giac_acctrans.tran_date%TYPE,
        p_memo_type        giac_cm_dm.memo_type%TYPE,
        p_memo_year        giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no      giac_cm_dm.memo_seq_no%TYPE,
        p_memo_date        giac_cm_dm.memo_date%TYPE,
        p_tran_class       giac_acctrans.tran_class%TYPE, -- para mareuse na lang ung function.
        p_acc_tran_id      OUT giac_acctrans.tran_id%TYPE, -- gagamitin ni AEG_PARAMETERS_REV
        p_user_id          giac_cm_dm.user_id%TYPE,
        p_message          OUT VARCHAR2
  ) IS
         CURSOR c1 IS
         SELECT '1'
           FROM giis_funds
          WHERE fund_cd = p_fund_cd;

         CURSOR c2 IS 
         SELECT '2'
           FROM giac_branches
          WHERE branch_cd    = p_branch_cd
            AND gfun_fund_cd = p_fund_cd;
            
          v_c1             VARCHAR2(1);
          v_c2             VARCHAR2(1);
          v_tran_id        giac_acctrans.tran_id%TYPE;
          v_last_update    giac_acctrans.last_update%TYPE;
          v_user_id        giac_acctrans.user_id%TYPE;
          v_closed_tag     giac_tran_mm.closed_tag%TYPE;
          v_tran_flag      giac_acctrans.tran_flag%TYPE;
          v_tran_class     giac_acctrans.tran_class%TYPE;
          v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
          v_particulars    giac_acctrans.particulars%TYPE;
          v_tran_date      giac_acctrans.tran_date%TYPE;
          v_tran_year      giac_acctrans.tran_year%TYPE;
          v_tran_month     giac_acctrans.tran_month%TYPE; 
          v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
 	      v_cm_no_cm_date  VARCHAR2(50);
          
          variables_tran_id giac_acctrans.tran_id%TYPE;   -- variables.tran_id
        
  BEGIN
        OPEN c1;
        
        FETCH c1 INTO v_c1;  
        IF c1%NOTFOUND THEN
            p_message := 'Invalid company code.';
        ELSE
          OPEN c2;
          
          FETCH c2 INTO  v_c2;  
            IF c2%NOTFOUND THEN
              p_message := 'Invalid branch code.';
            END IF;
            
          CLOSE c2;
        END IF;
        
        CLOSE c1;
        
        BEGIN
  	        SELECT acctran_tran_id_s.NEXTVAL
    	      INTO variables_tran_id
              FROM dual;
              
            p_acc_tran_id := variables_tran_id;
        EXCEPTION
   	        WHEN no_data_found THEN
                p_message := 'ACCTRAN_TRAN_ID sequence not found.';
                p_acc_tran_id := NULL;
	    END;   
        
        v_user_id       := p_user_id; --USER; --NVL (giis_users_pkg.app_user, USER);
        v_last_update   := SYSDATE;  
        v_tran_date 	:= p_rev_tran_date;
        v_tran_flag 	:= 'C';
        v_tran_year 	:= to_number(to_char(v_tran_date, 'YYYY'));
        v_tran_month 	:= to_number(to_char(v_tran_date, 'MM'));  
        v_tran_seq_no   := giac_sequence_generation(p_fund_cd,
                                  					p_branch_cd,
                                  					'ACCTRAN_TRAN_SEQ_NO',
                                  					v_tran_year,
                                  					v_tran_month);
                                                                    
        v_tran_class_no := NULL;                      
                                  
        IF p_tran_class IS NOT NULL AND p_tran_class = 'CAP' THEN
            v_tran_class := p_tran_class;
            
            v_particulars := 'Reversing entry of Premium deposit for ' ||
                             p_memo_type || '-' || p_memo_year || '-' || p_memo_seq_no ||
                             ' dated ' || to_char(p_memo_date, 'MM-DD-RRRR') || '.'; 
                         
        ELSIF p_tran_class IS NULL THEN 
        
            IF p_memo_type = 'CM' THEN
		        v_tran_class := 'CMR';
	        ELSIF p_memo_type = 'DM' THEN
		        v_tran_class := 'DMR';
	        END IF;		
            
            v_particulars := 'To reverse entry for cancelled Memo No. '||
                             p_memo_type || '-' || p_memo_year || '-' || p_memo_seq_no ||
                             ' dated ' || to_char(p_memo_date, 'MM-DD-RRRR') || '.';
             
        END IF;
	       
                         
        giac_acctrans_pkg.set_giac_acctrans(variables_tran_id,
                                            p_fund_cd        , p_branch_cd,
                                            v_tran_date      , v_tran_flag,
                                            --'CAP' parameterized na lang to para mareuse ang function            
                                            v_tran_class     , v_tran_class_no,
                                            v_particulars    , v_tran_year,
                                            v_tran_month     , v_tran_seq_no,
                                            v_user_id        , v_last_update); 
                                            
  EXCEPTION
    WHEN OTHERS THEN
        NULL;
   
  END insert_acctrans_071;
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 3, 2013
  ** Reference by:  GIACS071 - Credit Memo / Debit Memo
  ** Description:   Inserts tran_id and reversing tran_id 
  **                of posted CM/DM that is being cancelled.
  */
  PROCEDURE insert_into_reversals_071(
        p_gacc_tran_id     giac_cm_dm.gacc_tran_id%TYPE,
        p_acc_tran_id      IN OUT  giac_acctrans.tran_id%TYPE,
        p_message          OUT VARCHAR
  ) IS
  
  BEGIN
    INSERT 
      INTO giac_reversals
           (gacc_tran_id  , reversing_tran_id, rev_corr_tag)
    VALUES (p_gacc_tran_id, p_acc_tran_id    , 'R'); 
    
    IF SQL%NOTFOUND THEN
        p_message := 'Cancel CM/DM: Unable to insert into reversals.';
        RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#Cancel CM/DM: Unable to insert into reversals.');
    END IF;
    
  END insert_into_reversals_071; 
    
END GIAC_CM_DM_PKG;
/


