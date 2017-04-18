DROP PROCEDURE CPI.AEG_CREATE_ACCT_ENTRIES_026;

CREATE OR REPLACE PROCEDURE CPI.AEG_CREATE_ACCT_ENTRIES_026
  (p_gacc_branch_cd         GIAC_ACCTRANS.gibr_branch_cd%TYPE,
   p_gacc_fund_cd           GIAC_ACCTRANS.gfun_fund_cd%TYPE,
   p_gacc_tran_id           GIAC_ACCTRANS.tran_id%TYPE, 
   aeg_collection_amt       GIAC_BANK_COLLNS.collection_amt%TYPE,
   aeg_gen_type             GIAC_ACCT_ENTRIES.generation_type%TYPE,
   aeg_module_id            GIAC_MODULES.module_id%type,
   aeg_item_no              GIAC_MODULE_ENTRIES.item_no%TYPE,
   aeg_sl_cd                GIAC_ACCT_ENTRIES.sl_cd%TYPE,
   aeg_sl_type_cd           GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
   aeg_sl_source_cd         GIAC_ACCT_ENTRIES.sl_source_cd%TYPE) IS

  ws_gl_acct_category       GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
  ws_gl_control_acct        GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
  ws_gl_sub_acct_1          GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  ws_gl_sub_acct_2          GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_gl_sub_acct_3          GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  ws_gl_sub_acct_4          GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  ws_gl_sub_acct_5          GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  ws_gl_sub_acct_6          GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  ws_gl_sub_acct_7          GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

  ws_pol_type_tag           GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
  ws_intm_type_level        GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
  ws_old_new_acct_level     GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
  ws_line_dep_level         GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
  ws_dr_cr_tag              GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
  ws_acct_intm_cd           GIIS_INTM_TYPE.acct_intm_cd%TYPE;
  ws_line_cd                GIIS_LINE.line_cd%TYPE;
  ws_iss_cd                 GIPI_POLBASIC.iss_cd%TYPE;
  ws_old_acct_cd            GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_new_acct_cd            GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  pt_gl_sub_acct_1          GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  pt_gl_sub_acct_2          GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  pt_gl_sub_acct_3          GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  pt_gl_sub_acct_4          GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  pt_gl_sub_acct_5          GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  pt_gl_sub_acct_6          GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  pt_gl_sub_acct_7          GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

  ws_debit_amt              GIAC_ACCT_ENTRIES.debit_amt%TYPE;
  ws_credit_amt             GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
  ws_gl_acct_id             GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
  ws_sl_cd                  GIAC_ACCT_ENTRIES.sl_cd%TYPE;
  
/*****************************************************************************
*                                                                            *
* This procedure handles the creation of accounting entries per transaction. *
*                                                                            *
*****************************************************************************/
 
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
          FROM GIAC_MODULE_ENTRIES
         WHERE module_id = aeg_module_id
           AND item_no   = aeg_item_no
        FOR UPDATE of gl_sub_acct_1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No data found in giac_module_entries.');
      END;


  /**************************************************************************
  *                                                                         *
  * Check if the acctg code exists in GIAC_CHART_OF_ACCTS TABLE.            *
  *                                                                         *
  **************************************************************************/
/*
  AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                           ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                           ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                           ws_gl_acct_id);
*/
  IF aeg_collection_amt > 0 THEN
     ws_debit_amt  := 0;
     ws_credit_amt := ABS(aeg_collection_amt);
  ELSE
     ws_debit_amt  := ABS(aeg_collection_amt);
     ws_credit_amt := 0;
  END IF;

  /****************************************************************************
  *                                                                           *
  * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
  * same transaction id.  Insert the record if it does not exists else update *
  * the existing record.                                                      *
  *                                                                           *
  ****************************************************************************/
  BEGIN

  SELECT DISTINCT(gl_acct_id)
    INTO ws_gl_acct_id
    FROM GIAC_CHART_OF_ACCTS
   WHERE gl_acct_category  = ws_gl_acct_category
     AND gl_control_acct   = ws_gl_control_acct
     AND gl_sub_acct_1     = ws_gl_sub_acct_1
     AND gl_sub_acct_2     = ws_gl_sub_acct_2
     AND gl_sub_acct_3     = ws_gl_sub_acct_3
     AND gl_sub_acct_4     = ws_gl_sub_acct_4
     AND gl_sub_acct_5     = ws_gl_sub_acct_5
     AND gl_sub_acct_6     = ws_gl_sub_acct_6
     AND gl_sub_acct_7     = ws_gl_sub_acct_7;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20002, 'Geniisys Exception#E#GL account code '||to_char(ws_gl_acct_category)
                ||'-'||to_char(ws_gl_control_acct,'09') 
                ||'-'||to_char(ws_gl_sub_acct_1,'09')
                ||'-'||to_char(ws_gl_sub_acct_2,'09')
                ||'-'||to_char(ws_gl_sub_acct_3,'09')
                ||'-'||to_char(ws_gl_sub_acct_4,'09')
                ||'-'||to_char(ws_gl_sub_acct_5,'09')
                ||'-'||to_char(ws_gl_sub_acct_6,'09')
                ||'-'||to_char(ws_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans). ');

  END;

  BEGIN
    SELECT gl_acct_category    ,
       gl_control_acct     ,
       gl_sub_acct_1       ,
       gl_sub_acct_2       ,
       gl_sub_acct_3       ,
       gl_sub_acct_4       ,
       gl_sub_acct_5       ,
       gl_sub_acct_6       ,
       gl_sub_acct_7       ,
       gl_acct_id   
    INTO ws_gl_acct_category    ,
       ws_gl_control_acct     ,
       ws_gl_sub_acct_1       ,
       ws_gl_sub_acct_2       ,
       ws_gl_sub_acct_3       ,
       ws_gl_sub_acct_4       ,
       ws_gl_sub_acct_5       ,
       ws_gl_sub_acct_6       ,
       ws_gl_sub_acct_7       ,
       ws_gl_acct_id   
    FROM GIAC_CHART_OF_ACCTS
   WHERE gl_acct_id = ws_gl_acct_id;

  EXCEPTION
   WHEN no_data_found THEN
     RAISE_APPLICATION_ERROR(-20003, 'Geniisys Exception#E#GL account code '||TO_CHAR(ws_gl_acct_category)
                ||'-'||TO_CHAR(ws_gl_control_acct,'09') 
                ||'-'||TO_CHAR(ws_gl_sub_acct_1,'09')
                ||'-'||TO_CHAR(ws_gl_sub_acct_2,'09')
                ||'-'||TO_CHAR(ws_gl_sub_acct_3,'09')
                ||'-'||TO_CHAR(ws_gl_sub_acct_4,'09')
                ||'-'||TO_CHAR(ws_gl_sub_acct_5,'09')
                ||'-'||TO_CHAR(ws_gl_sub_acct_6,'09')
                ||'-'||TO_CHAR(ws_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans). ');
  END;

   GIAC_ACCT_ENTRIES_PKG.AEG_INSERT_UPDATE_ACCT_ENTRIES
        (p_gacc_branch_cd   , p_gacc_fund_cd    , p_gacc_tran_id,
         ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
         ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
         ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
         aeg_sl_cd          , aeg_sl_type_cd     ,aeg_sl_source_cd , 
         aeg_gen_type       , ws_gl_acct_id   ,        
         ws_debit_amt       , ws_credit_amt);
END;
/


