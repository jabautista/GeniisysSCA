DROP PROCEDURE CPI.AEG_INSERT_UPDATE_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.AEG_Insert_Update_Acct_Entries
    (iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
     iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
     iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
     iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
     iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
     iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%type,     
     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type,  
	 iuae_gacc_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
     iuae_gacc_fund_cd      giac_acctrans.gfun_fund_cd%TYPE,
	 iuae_gacc_tran_id      giac_order_of_payts.gacc_tran_id%TYPE
	 )
	 IS  
     iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;
BEGIN
  SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
    INTO iuae_acct_entry_id
    FROM giac_acct_entries
   WHERE gacc_gibr_branch_cd = iuae_gacc_branch_cd
     AND gacc_gfun_fund_cd   = iuae_gacc_fund_cd
     AND gl_acct_id          = iuae_gl_acct_id             
     AND sl_cd               = iuae_sl_cd
     AND generation_type     = iuae_generation_type
     AND gacc_tran_id        = iuae_gacc_tran_id;
IF NVL(iuae_debit_amt,0) = 0  and NVL(iuae_credit_amt,0) = 0 THEN 
	NULL;
ELSE  
  IF NVL(iuae_acct_entry_id,0) = 0 THEN
    iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
    INSERT into GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                  gacc_gibr_branch_cd, acct_entry_id    ,
                                  gl_acct_id         , gl_acct_category ,
                                  gl_control_acct    , gl_sub_acct_1    ,
                                  gl_sub_acct_2      , gl_sub_acct_3    ,
                                  gl_sub_acct_4      , gl_sub_acct_5    ,
                                  gl_sub_acct_6      , gl_sub_acct_7    ,
                                  sl_cd              , debit_amt        ,
                                  credit_amt         , generation_type  ,
                                  user_id            , last_update	,
                                  SL_TYPE_CD         , SL_SOURCE_CD )
       VALUES (iuae_gacc_tran_id  , iuae_gacc_fund_cd,
               iuae_gacc_branch_cd, iuae_acct_entry_id          ,
               iuae_gl_acct_id               , iuae_gl_acct_category       ,
               iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
               iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
               iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
               iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
               iuae_sl_cd                    , iuae_debit_amt              ,
               iuae_credit_amt               , iuae_generation_type        ,
               NVL (giis_users_pkg.app_user, USER)             , SYSDATE			   ,
	       iuae_sl_type_cd		     , iuae_sl_source_cd  );
  ELSE
    UPDATE giac_acct_entries
       SET debit_amt  = debit_amt  + iuae_debit_amt,
           credit_amt = credit_amt + iuae_credit_amt
     WHERE sl_cd               = iuae_sl_cd
       AND generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id
       AND gacc_gibr_branch_cd = iuae_gacc_branch_cd
       AND gacc_gfun_fund_cd   = iuae_gacc_fund_cd
       AND gacc_tran_id        = iuae_gacc_tran_id;
  END IF;
END IF;
END;
/


