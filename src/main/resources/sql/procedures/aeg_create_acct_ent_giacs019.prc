DROP PROCEDURE CPI.AEG_CREATE_ACCT_ENT_GIACS019;

CREATE OR REPLACE PROCEDURE CPI.AEG_Create_Acct_Ent_Giacs019
  (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
   aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
   aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
   aeg_iss_cd             GIAC_RI_REQ_PAYT_DTL.iss_cd%TYPE,
   aeg_bill_no            GIAC_RI_REQ_PAYT_DTL.prem_seq_no%TYPE,
   aeg_line_cd            GIIS_LINE.line_cd%TYPE,
   aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
   aeg_acct_amt           GIAC_OUTFACUL_PREM_PAYTS.disbursement_amt%TYPE,
   aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
   aeg_gacc_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
   aeg_gacc_fund_cd      giac_acctrans.gfun_fund_cd%TYPE,
   aeg_gacc_tran_id      giac_order_of_payts.gacc_tran_id%TYPE,
   aeg_message  	OUT	  varchar2
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
  ws_sl_type_cd			   GIAC_ACCT_ENTRIES.sl_type_cd%type; 

--GIAC_ACCT_ENTRIES.sl_source_cd%type,     
--     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type      )I
 
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
         WHERE module_id = aeg_module_id
           AND item_no   = aeg_item_no
        FOR UPDATE of gl_sub_acct_1;
      EXCEPTION
        WHEN no_data_found THEN
          aeg_message := 'No data found in giac_module_entries.';
      END;



--IGNORE THESE PARTS FOR NOW (INTM_TYPE, LINE DEP, OLD/NEW ACCT LEVEL)

  /**************************************************************************
  *                                                                         *
  * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
  * GL account code that holds the intermediary type.                       *
  *                                                                         *
  **************************************************************************/
/*
      IF ws_intm_type_level != 0 THEN
        BEGIN
          SELECT DISTINCT(c.acct_intm_cd)
            INTO ws_acct_intm_cd
            FROM gipi_comm_invoice a,
                 giis_intermediary b,
                 giis_intm_type c
           WHERE a.intrmdry_intm_no = b.intm_no
             AND b.intm_type        = c.intm_type
             AND a.iss_cd           = aeg_iss_cd
             AND a.prem_seq_no      = aeg_bill_no;
        EXCEPTION
          WHEN no_data_found THEN
            Msg_Alert('No data found in giis_intm_type.','E',true);
        END;
        AEG_Check_Level(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                        ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                        ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;
*/
  /**************************************************************************
  *                                                                         *
  * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
  * the GL account code that holds the line number.                         *
  *                                                                         *
  **************************************************************************/

      IF ws_line_dep_level != 0 THEN      
        BEGIN
          SELECT acct_line_cd
            INTO ws_line_cd
            FROM giis_line
           WHERE line_cd = aeg_line_cd;
        EXCEPTION
          WHEN no_data_found THEN
            aeg_message := 'No data found in giis_line.';      
        END;
      giac_acct_entries_pkg.AEG_Check_Level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                      ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                      ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;

  /**************************************************************************
  *                                                                         *
  * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
  * the GL account code that holds the old and new account values.          *
  *                                                                         *
  **************************************************************************/

      IF ws_old_new_acct_level != 0 THEN
        BEGIN
          BEGIN
            SELECT param_value_v
              INTO ws_iss_cd
              FROM giac_parameters
             WHERE param_name = 'OLD_ISS_CD';
          END;
          BEGIN
            SELECT param_value_n
              INTO ws_old_acct_cd
              FROM giac_parameters
             WHERE param_name = 'OLD_ACCT_CD';
          END;
          BEGIN
            SELECT param_value_n
              INTO ws_new_acct_cd
              FROM giac_parameters
             WHERE param_name = 'NEW_ACCT_CD';

          END;
          IF aeg_iss_cd = ws_iss_cd THEN
            giac_acct_entries_pkg.AEG_Check_Level(ws_old_new_acct_level, ws_old_acct_cd  , ws_gl_sub_acct_1,
                            ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                            ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
          ELSE
            giac_acct_entries_pkg.AEG_Check_Level(ws_old_new_acct_level, ws_new_acct_cd  , ws_gl_sub_acct_1,
                            ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                            ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
          END IF;
        EXCEPTION
          WHEN no_data_found THEN
            aeg_message := 'No data found in giac_parameters.';
        END;
      END IF;

  /**************************************************************************
  *                                                                         *
  * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
  * segments will be attached to this GL account.                           *
  *                                                                         *
  **************************************************************************/

      IF ws_pol_type_tag = 'Y' THEN
        BEGIN
          SELECT NVL(gl_sub_acct_1,0), NVL(gl_sub_acct_2,0),
                 NVL(gl_sub_acct_3,0), NVL(gl_sub_acct_4,0),
                 NVL(gl_sub_acct_5,0), NVL(gl_sub_acct_6,0),
                 NVL(gl_sub_acct_7,0)
            INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                 pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                 pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                 pt_gl_sub_acct_7
            FROM giac_policy_type_entries
           WHERE line_cd = aeg_line_cd
             AND type_cd = aeg_type_cd;
          IF pt_gl_sub_acct_1 != 0 THEN
            ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
          END IF;
          IF pt_gl_sub_acct_2 != 0 THEN
            ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
          END IF;
          IF pt_gl_sub_acct_3 != 0 THEN
            ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
          END IF;
          IF pt_gl_sub_acct_4 != 0 THEN
            ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
          END IF;
          IF pt_gl_sub_acct_5 != 0 THEN
            ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
          END IF;
          IF pt_gl_sub_acct_6 != 0 THEN
            ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
          END IF;
          IF pt_gl_sub_acct_7 != 0 THEN
            ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
          END IF;
        EXCEPTION
          WHEN no_data_found THEN
            aeg_message := 'No data found in giac_policy_type_entries.';
        END;
      END IF;

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/

    giac_acct_entries_pkg.AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                             ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                             ws_gl_acct_id, aeg_message);


   --validate the GL account's SL type if it is for RI.
   AEG_get_sl_type_leaf_tag(ws_gl_acct_id, aeg_sl_cd, aeg_message);
   

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

  BEGIN

  SELECT DISTINCT(nvl(GSLT_SL_TYPE_CD, ' '))
    INTO ws_sl_type_cd
    FROM giac_chart_of_accts
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
   WHEN no_data_found THEN
     aeg_message := 'GL account code '||to_char(ws_gl_acct_category)
                ||'-'||to_char(ws_gl_control_acct,'09') 
                ||'-'||to_char(ws_gl_sub_acct_1,'09')
                ||'-'||to_char(ws_gl_sub_acct_2,'09')
                ||'-'||to_char(ws_gl_sub_acct_3,'09')
                ||'-'||to_char(ws_gl_sub_acct_4,'09')
                ||'-'||to_char(ws_gl_sub_acct_5,'09')
                ||'-'||to_char(ws_gl_sub_acct_6,'09')
                ||'-'||to_char(ws_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans).';
  END;

   AEG_Insert_Update_Acct_Entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                  aeg_sl_cd          , aeg_gen_type      , ws_gl_acct_id   ,        
                                  ws_debit_amt       , ws_credit_amt	 , '1'               ,
                                  ws_sl_type_cd, aeg_gacc_branch_cd, aeg_gacc_fund_cd, aeg_gacc_tran_id);
END;
/


