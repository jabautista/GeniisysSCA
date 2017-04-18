DROP PROCEDURE CPI.AEG_CREATE_ACCT_ENTRIES_086;

CREATE OR REPLACE PROCEDURE CPI.AEG_Create_Acct_Entries_086
  (aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
   aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
   aeg_branch_cd          GIAC_ACCTRANS.gibr_branch_cd%TYPE,
   aeg_iss_cd             GIIS_ISSOURCE.iss_cd%TYPE,
   aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,   
   aeg_acct_amt           GIAC_BATCH_DV_DTL.paid_amt%TYPE,
   aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
   aeg_tran_id            GIAC_ACCTRANS.tran_id%TYPE,
   p_branch_sl_type 	  VARCHAR2,
   p_fund_cd      		  giac_acctrans.gfun_fund_cd%TYPE,
   p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
   p_convert_rate         giac_batch_dv.convert_rate%TYPE --added by steven 1.26.2012; added p_convert_rate for foreign currency. Base on SR 0012036.
   ) IS

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
  ws_branch_dep_level              GIAC_MODULE_ENTRIES.branch_level%TYPE;
  ws_trty_type_level                   GIAC_MODULE_ENTRIES.ca_treaty_type_level%TYPE;
  ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
  ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
  ws_line_cd                       GIIS_LINE.line_cd%TYPE;
  ws_iss_cd                        GIIS_ISSOURCE.iss_cd%TYPE;
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
  ws_sl_type_cd                           GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;
  ws_sl_cd                         GIAC_ACCT_ENTRIES.sl_cd%TYPE;  
 
BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

   /**************************************************************************
   *                                                                         *
   * Populate the GL Account Code used in every transaction.                 *
   *                                                                         *
   **************************************************************************/
    --msg_alert(aeg_module_id||' '||aeg_item_no,'I',false); --jcf
    BEGIN
      SELECT gl_acct_category   , gl_control_acct,
             gl_sub_acct_1      , gl_sub_acct_2  ,
             gl_sub_acct_3      , gl_sub_acct_4  ,
             gl_sub_acct_5      , gl_sub_acct_6  ,
             gl_sub_acct_7      , pol_type_tag   ,
             NVL(branch_level,0), dr_cr_tag      , 
               sl_type_cd
        INTO ws_gl_acct_category, ws_gl_control_acct,
             ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
             ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
             ws_gl_sub_acct_7   , ws_pol_type_tag   ,
             ws_branch_dep_level, ws_dr_cr_tag      ,
             ws_sl_type_cd
        FROM giac_module_entries
       WHERE module_id = aeg_module_id
         AND item_no   = aeg_item_no;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         --msg_alert ('No data found in giac_module_entries.', 'E', TRUE);
         null;
   END;
  
  
  
  /************************************************************************** 
  *                                                                                                                                                *
  * Validate if the General Ledger Account Category is Zero. If it is, the  *
  * item in the Module Entries will not be used, thus it will not execute   *
  * the rest of the program unit.                                                                                    *                 
  *                                                                         *
  **************************************************************************/
  IF ws_gl_acct_category = 0 THEN
    RETURN;
  END IF;

  /**************************************************************************
  *                                                                         *
  * Validate the BRANCH_LEVEL value which indicates the segment of the      *
  * GL account code that holds the branch number.                           *
  *                                                                         *
  **************************************************************************/
  
  IF ws_branch_dep_level != 0 THEN      
    BEGIN
      SELECT acct_iss_cd
        INTO ws_iss_cd
        FROM giis_issource
       WHERE iss_cd = aeg_iss_cd;
  EXCEPTION
    WHEN no_data_found THEN
    --  Msg_Alert('No data found in GIIS_ISSOURCE.','E',true);      
    null;
  END;
  
  AEG_Check_Level(ws_branch_dep_level, ws_iss_cd       , ws_gl_sub_acct_1,
                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
  END IF;

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/
  /*MSG_ALERT('CREATE '||ws_gl_acct_category||'-'||ws_gl_control_acct||'-'||ws_gl_sub_acct_1||'-'||
                           ws_gl_sub_acct_2||'-'||ws_gl_sub_acct_3||'-'||ws_gl_sub_acct_4||'-'||
                           ws_gl_sub_acct_5||'-'||ws_gl_sub_acct_6||'-'||ws_gl_sub_acct_7||'-'||
                           ws_gl_acct_id,'I',FALSE);--JEN.090505*/
                                                      
  AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                           ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                           ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                           ws_gl_acct_id);

  /***************************************************************************
  *                                                                                             *
  * Fetch the SL TYPE from GIAC_CHART_OF_ACCTS table and compare it to the   *
  * value of BRANCH_SL_TYPE of GIAC_PARAMETERS... This will identify the     *
  * value of the SL CODE of GIAC_ACCT_ENTRIES.                                         *
  *                                                                                             *
  ***************************************************************************/

  IF ws_sl_type_cd = p_branch_sl_type THEN        --to insert sl_cd of branch
     ws_sl_cd := aeg_sl_cd;
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
  AEG_Insert_Update_Acct_Ent_086(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                 ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                 ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                 ws_sl_cd           , aeg_gen_type      , ws_gl_acct_id   ,        
                                 (ws_debit_amt*p_convert_rate)       , (ws_credit_amt*p_convert_rate)     ,--added by steven 1.26.2012; added p_convert_rate for foreign currency. Base on SR 0012036.
                                 aeg_tran_id        , aeg_branch_cd,ws_sl_type_cd,p_fund_cd,p_user_id);
END;
/


