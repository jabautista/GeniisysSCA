CREATE OR REPLACE PACKAGE BODY CPI.Create_Acctg_Entries AS

PROCEDURE BPC_AEG_Check_Chart_Of_Accts_Y
    (cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE ,
     --aeg_iss_cd              GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
     --aeg_bill_no             GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
     v_message           OUT VARCHAR2) IS

BEGIN
--msg_alert('AEG CHK CHART OF ACCTS...','I',FALSE);
  SELECT DISTINCT(gl_acct_id)
    INTO cca_gl_acct_id
    FROM GIAC_CHART_OF_ACCTS
   WHERE gl_acct_category  = cca_gl_acct_category
     AND gl_control_acct   = cca_gl_control_acct
     AND gl_sub_acct_1     = cca_gl_sub_acct_1
     AND gl_sub_acct_2     = cca_gl_sub_acct_2
     AND gl_sub_acct_3     = cca_gl_sub_acct_3
     AND gl_sub_acct_4     = cca_gl_sub_acct_4
     AND gl_sub_acct_5     = cca_gl_sub_acct_5
     AND gl_sub_acct_6     = cca_gl_sub_acct_6
     AND gl_sub_acct_7     = cca_gl_sub_acct_7;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     BEGIN
       v_message := 'GL account code '||TO_CHAR(cca_gl_acct_category)
                ||'-'||TO_CHAR(cca_gl_control_acct,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_1,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_2,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_3,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_4,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_5,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_6,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans). Bill No : ';
/*
       aeg_delete_acct_entries;
       delete
         from giac_direct_prem_collns
        where gacc_tran_id = :GLOBAL.cg$giop_gacc_tran_id
          and b140_prem_seq_no = :gdpc.b140_prem_seq_no
          and b140_iss_cd = :gdpc.b140_iss_cd;
       commit;
*/
     END;
END;

--------------
/*****************************************************************************
*                                                                            *
* This procedure determines whether the records will be updated or inserted  *
* in GIAC_ACCT_ENTRIES.                                                      *
*                                                                            *
*****************************************************************************/

PROCEDURE BPC_AEG_Insert_Update_Acct_Y
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
     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,--Vincent 05182006
     iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
     iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
     iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
     iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
     v_message              OUT VARCHAR2,
     p_gacc_tran_id         NUMBER,
     p_branch_cd       VARCHAR2,
     p_fund_cd              VARCHAR2) IS
     iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;

     
BEGIN
  SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
    INTO iuae_acct_entry_id
    FROM GIAC_ACCT_ENTRIES
   WHERE gacc_gibr_branch_cd = p_branch_cd
     AND gacc_gfun_fund_cd   = p_fund_cd
     AND gacc_tran_id        = p_gacc_tran_id
     AND NVL(sl_cd,0) = NVL(iuae_sl_cd,0)            --alfie 07052010 : to use the existing accounting entry id having null sl_cd
     AND generation_type = iuae_generation_type
     AND NVL(gl_acct_id, gl_acct_id) = iuae_gl_acct_id; -- grace 02.01.2007 for optimization purpose

  IF NVL(iuae_acct_entry_id,0) = 0 THEN

--msg_alert('insert...','I',FALSE);

    iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
    INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                  gacc_gibr_branch_cd, acct_entry_id    ,
                                  gl_acct_id         , gl_acct_category ,
                                  gl_control_acct    , gl_sub_acct_1    ,
                                  gl_sub_acct_2      , gl_sub_acct_3    ,
                                  gl_sub_acct_4      , gl_sub_acct_5    ,
                                  gl_sub_acct_6      , gl_sub_acct_7    ,
                                  sl_cd              , sl_type_cd       , --Vincent 05182006: added sl_type_cd
                                  debit_amt          , credit_amt       , 
                                  generation_type    , user_id          , 
                                  last_update)
       VALUES (p_gacc_tran_id  , p_fund_cd,
               p_branch_cd, iuae_acct_entry_id          ,
               iuae_gl_acct_id               , iuae_gl_acct_category       ,
               iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
               iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
               iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
               iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
               iuae_sl_cd                    , iuae_sl_type_cd             ,--Vincent 05182006: added sl_type_cd
               iuae_debit_amt                , iuae_credit_amt             , 
               iuae_generation_type          , USER           , 
               SYSDATE);
  ELSE
--msg_alert('update...','I',FALSE);
    UPDATE GIAC_ACCT_ENTRIES
       SET debit_amt  = debit_amt  + iuae_debit_amt,
           credit_amt = credit_amt + iuae_credit_amt
     WHERE NVL(sl_cd,0) = NVL(iuae_sl_cd,0)              ----alfie 07052010 : to update the existing accounting entry id having null sl_cd
       AND generation_type     = iuae_generation_type
       AND NVL(gl_acct_id, gl_acct_id) = iuae_gl_acct_id -- grace 02.01.2007 for optimization purpose
       AND gacc_gibr_branch_cd = p_branch_cd
       AND gacc_gfun_fund_cd   = p_fund_cd
       AND gacc_tran_id        = p_gacc_tran_id;
  END IF;
--msg_alert('done...','I',FALSE);
END;
--------------

/*****************************************************************************
*                                                                            *
* This procedure handles the creation of accounting entries per transaction. *
*                                                                            *
*****************************************************************************/

PROCEDURE BPC_AEG_Create_Acct_Entries_Y
  (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
   aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
   aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
   --aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
   --aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
   --aeg_line_cd            GIIS_LINE.line_cd%TYPE,
   --aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
   aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
   aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
   v_message              OUT VARCHAR2,
   p_gacc_tran_id         NUMBER,
   p_branch_cd            VARCHAR2,
   p_fund_cd              VARCHAR2) IS

  ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
  ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
  ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
  ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
  ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
  ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
  ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
  ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
  ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
  ws_line_cd                       GIIS_LINE.line_cd%TYPE;
--  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
  ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
  ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
  ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
  ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
  ws_sl_type_cd                    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;--Vincent 05182006
 
BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);


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
               NVL(intm_type_level,0) , NVL(old_new_acct_level,0),
               dr_cr_tag              , NVL(line_dependency_level,0)
               ,sl_type_cd--Vincent 05182006
          INTO ws_gl_acct_category, ws_gl_control_acct,
               ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
               ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
               ws_gl_sub_acct_7   , ws_pol_type_tag   ,
               ws_intm_type_level , ws_old_new_acct_level,
               ws_dr_cr_tag       , ws_line_dep_level
               ,ws_sl_type_cd--Vincent 05182006
          FROM GIAC_MODULE_ENTRIES
         WHERE module_id = aeg_module_id
           AND item_no   = aeg_item_no;
        --FOR UPDATE of gl_sub_acct_1;--Vincent 01302007: comment out, temporary @FGIC user locks
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_message := 'No data found in giac_module_entries.';
      END;

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/

    BPC_AEG_Check_Chart_Of_Accts_Y(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                             ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                             ws_gl_acct_id      , --aeg_iss_cd        , aeg_bill_no,
                             v_message);

  /****************************************************************************
  *                                                                           *
  * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
  * debit-credit tag to determine whether the positive amount will be debited *
  * or credited.                                                              *
  *                                                                           *
  ****************************************************************************/

    IF ws_dr_cr_tag = 'D' THEN
      IF aeg_acct_amt > 0 THEN
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      END IF;
    ELSE
      IF aeg_acct_amt > 0 THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      ELSE
        ws_debit_amt  := ABS(aeg_acct_amt);
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

   BPC_AEG_Insert_Update_Acct_Y(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                            ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                            ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                            aeg_sl_cd          , ws_sl_type_cd     , aeg_gen_type, --Vincent 05182006: added ws_sl_type_cd
                            ws_gl_acct_id      , ws_debit_amt      , ws_credit_amt,
                            v_message          , p_gacc_tran_id    , p_branch_cd,
                            p_fund_cd);
END;
--------------
END;
/


