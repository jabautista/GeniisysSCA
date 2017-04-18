DROP PROCEDURE CPI.AEG_INSERT_UPDATE_ACCT_ENT_086;

CREATE OR REPLACE PROCEDURE CPI.AEG_Insert_Update_Acct_Ent_086
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
     iuae_tran_id           GIAC_ACCTRANS.tran_id%TYPE,
     iuae_branch_cd         GIAC_ACCTRANS.gibr_branch_cd%TYPE,
     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
     iuae_gacc_fund_cd      giac_acctrans.gfun_fund_cd%TYPE,
     p_user_id             GIAC_ACCT_ENTRIES.user_id%type
     ) IS
      
     iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;

     
BEGIN
--msg_alert(' AEG_Insert_Update_Acct_Entries ','I',FALSE);

  SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
    INTO iuae_acct_entry_id
    FROM giac_acct_entries
   WHERE gacc_tran_id        = iuae_tran_id
     AND gacc_gibr_branch_cd = iuae_branch_cd
     AND gl_acct_id          = iuae_gl_acct_id
     AND gl_sub_acct_1       = iuae_gl_sub_acct_1     
     AND gl_sub_acct_2       = iuae_gl_sub_acct_2     
     AND gl_sub_acct_3       = iuae_gl_sub_acct_3     
     AND gl_sub_acct_4       = iuae_gl_sub_acct_4     
     AND gl_sub_acct_5       = iuae_gl_sub_acct_5     
     AND gl_sub_acct_6       = iuae_gl_sub_acct_6     
     AND gl_sub_acct_7       = iuae_gl_sub_acct_7     
     AND generation_type     = iuae_generation_type;

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
                                  sl_type_cd         , sl_source_cd,
                                  user_id            , last_update)
       VALUES (iuae_tran_id                  , iuae_gacc_fund_cd       ,
               iuae_branch_cd                , iuae_acct_entry_id          ,
               iuae_gl_acct_id               , iuae_gl_acct_category       ,
               iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
               iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
               iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
               iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
               iuae_sl_cd                    , iuae_debit_amt              ,
               iuae_credit_amt               , iuae_generation_type        ,
               iuae_sl_type_cd               , '1',
               p_user_id                                      , SYSDATE);
  ELSE
      UPDATE giac_acct_entries
       SET debit_amt  = debit_amt  + iuae_debit_amt,
           credit_amt = credit_amt + iuae_credit_amt
     WHERE generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id
       AND gacc_tran_id        = iuae_tran_id 
       AND gacc_gibr_branch_cd = iuae_branch_cd;
  END IF;
END;
/


