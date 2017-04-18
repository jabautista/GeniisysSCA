DROP PROCEDURE CPI.AEG_CREATE_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.AEG_Create_Acct_Entries
  (p_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
   p_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
   p_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
   p_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
   p_branch_cd          GIAC_ACCT_ENTRIES.GACC_GIBR_BRANCH_CD%TYPE, --added by MJ 12/28/2012
   p_fund_cd            GIAC_ACCT_ENTRIES.GACC_GFUN_FUND_CD%TYPE,   --added by MJ 12/28/2012
   p_tran_id            GIAC_ACCT_ENTRIES.GACC_TRAN_ID%TYPE,        --added by MJ 12/28/2012
   p_user_id            GIIS_USERS.USER_ID%TYPE,                    --added by MJ 12/28/2012
   p_message OUT varchar2) IS

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
  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
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
         WHERE module_id = p_module_id
           AND item_no   = p_item_no
        FOR UPDATE of gl_sub_acct_1;

      EXCEPTION
        WHEN no_data_found THEN
          p_message := 'No data found in giac_module_entries: GIACS001 - Order of Payments';
      END;



  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/

    giac_acct_entries_pkg.AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                             ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                             ws_gl_acct_id, p_message);

  /****************************************************************************
  *                                                                           *
  * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
  * debit-credit tag to determine whether the positive amount will be debited *
  * or credited.                                                              *
  *                                                                           *
  ****************************************************************************/

    IF ws_dr_cr_tag = 'D' THEN
      IF p_acct_amt > 0 THEN
        ws_debit_amt  := ABS(p_acct_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(p_acct_amt);
      END IF;
    ELSE
      IF p_acct_amt > 0 THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(p_acct_amt);
      ELSE
        ws_debit_amt  := ABS(p_acct_amt);
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

   giac_acct_entries_pkg.insert_update_acct_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                  NULL,NULL,    --added by MJ 12/28/2012
                                  p_gen_type       , ws_gl_acct_id     , ws_debit_amt,       
				  				  ws_credit_amt,  p_branch_cd, p_fund_cd,
								  p_tran_id, p_user_id);

END;
/


