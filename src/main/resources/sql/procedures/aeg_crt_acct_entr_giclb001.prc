DROP PROCEDURE CPI.AEG_CRT_ACCT_ENTR_GICLB001;

CREATE OR REPLACE PROCEDURE CPI.AEG_Crt_Acct_Entr_GICLB001(
    aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
    aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
    aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
    aeg_acct_intm_cd       GIIS_INTM_TYPE.acct_intm_cd%TYPE,
    aeg_line_cd            GIIS_LINE.line_cd%TYPE,
    aeg_subline_cd         GIIS_SUBLINE.subline_cd%TYPE,
    aeg_trty_type          GIIS_DIST_SHARE.acct_trty_type%TYPE,
    aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
    aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
    p_ri_sl_type           GIAC_SL_TYPES.sl_type_cd%type,
    p_claim_sl_cd          GIAC_PARAMETERS.param_value_n%type,
    p_branch_cd            GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
    p_fund_cd              GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
    p_tran_id              GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE
) 
IS
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.18.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  This procedure handles the creation of accounting entries per transaction.       
    */
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
  ws_trty_type_level               GIAC_MODULE_ENTRIES.ca_treaty_type_level%TYPE;
  ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
  ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
  ws_line_cd                       GIIS_LINE.line_cd%TYPE;
  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
  ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
  ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
  ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
  ws_sl_type_cd                    GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;
  ws_ri_parm                       GIAC_PARAMETERS.param_value_v%TYPE;
  ws_sl_cd                         GIAC_ACCT_ENTRIES.sl_cd%TYPE;
 
BEGIN

  /**************************************************************************
  *                                                                         *
  * Populate the GL Account Code used in every transactions.                *
  *                                                                         *
  **************************************************************************/
      BEGIN
        SELECT gl_acct_category             , gl_control_acct   ,
               gl_sub_acct_1                , gl_sub_acct_2     ,
               gl_sub_acct_3                , gl_sub_acct_4     ,
               gl_sub_acct_5                , gl_sub_acct_6     ,
               gl_sub_acct_7                , pol_type_tag      ,
               nvl(intm_type_level,0)       , old_new_acct_level,
               nvl(line_dependency_level,0) , dr_cr_tag         , 
               nvl(ca_treaty_type_level,0)  , sl_type_cd
          INTO ws_gl_acct_category          , ws_gl_control_acct,
               ws_gl_sub_acct_1             , ws_gl_sub_acct_2  ,
               ws_gl_sub_acct_3             , ws_gl_sub_acct_4  ,
               ws_gl_sub_acct_5             , ws_gl_sub_acct_6  ,
               ws_gl_sub_acct_7             , ws_pol_type_tag   ,
               ws_intm_type_level           , ws_old_new_acct_level,
               ws_line_dep_level            , ws_dr_cr_tag      ,
               ws_trty_type_level           , ws_sl_type_cd
          FROM giac_module_entries
         WHERE module_id = aeg_module_id
           AND item_no   = aeg_item_no;
      EXCEPTION
        WHEN no_data_found THEN
          --Msg_Alert('No data found in giac_module_entries.','E',true);
          raise_application_error('-20001', 'No data found in giac_module_entries.');
      END;

  /************************************************************************** 
  *                                        *
  * Validate if the General Ledger Account Category is Zero. If It is the   *
  * item in the Module Entries will not be used, thus it will not execute   *
  * the rest of the program unit.                        *                 
  *                                                                         *
  **************************************************************************/

  IF ws_gl_acct_category = 0 THEN
    RETURN;
  END IF;

  /**************************************************************************
  *                                                                         *
  * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
  * GL account code that holds the intermediary type.                       *
  *                                                                         *
  **************************************************************************/
      IF ws_intm_type_level != 0 THEN

        ws_acct_intm_cd := aeg_acct_intm_cd;

        aeg_check_level_giclb001(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                                 ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                 ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;

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
            --Msg_Alert('No data found in giis_line.','E',true);
            raise_application_error('-20001', 'No data found in giis_line.');      
        END;
        aeg_check_level_giclb001(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                                 ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                 ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;

  /**************************************************************************
  *                                                                         *
  * Validate the CA_TREATY_TYPE_LEVEL value which indicates the segment of  *
  * the GL account code that holds the treaty type code.                    *
  *                                                                         *
  **************************************************************************/

      IF ws_trty_type_level != 0 THEN      
         aeg_check_level_giclb001(ws_trty_type_level, aeg_trty_type   , ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/

    check_chart_of_accts_giclb001(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                  ws_gl_acct_id);

  /***************************************************************************
  *                                         *
  * Fetch the SL TYPE from GIAC_CHART_OF_ACCTS table and compare it to the   *
  * value of RI_SL_TYPE of GIAC_PARAMETERS...this will identify the value of   *
  * then SL CODE of GIAC_ACCT_ENTRIES.
  *                                         *
  ***************************************************************************/
   IF WS_SL_TYPE_CD = p_ri_sl_type THEN
      WS_SL_CD := AEG_SL_CD;
   ELSIF WS_SL_TYPE_CD = '6' THEN
      LSP_SL_CODE(p_claim_sl_cd, aeg_line_cd, aeg_subline_cd, aeg_sl_cd, ws_sl_cd);
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
  * Check if the derived GL code exists in GICL_ACCT_ENTRIES table for the    *
  * same transaction id.  Insert the record if it does not exists else update *
  * the existing record.                                                      *
  *                                                                           *
  ****************************************************************************/
  giac_acct_entries_pkg.ins_updt_acct_entries_giclb001(p_branch_cd         , p_fund_cd           , p_tran_id          ,
                                                       p_user_id           , ws_gl_acct_category , ws_gl_control_acct , 
                                                       ws_gl_sub_acct_1    , ws_gl_sub_acct_2    , ws_gl_sub_acct_3   , 
                                                       ws_gl_sub_acct_4    , ws_gl_sub_acct_5    , ws_gl_sub_acct_6   , 
                                                       ws_gl_sub_acct_7    , ws_sl_cd            , aeg_gen_type       , 
                                                       ws_gl_acct_id       , ws_debit_amt        , ws_credit_amt      , 
                                                       ws_sl_type_cd);
END;
/


