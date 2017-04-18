DROP PROCEDURE CPI.AEG_CREATE_ACCT_ENTRIES_TAX_N;

CREATE OR REPLACE PROCEDURE CPI.AEG_Create_Acct_Entries_tax_N
  (aeg_tax_cd		  GIAC_TAXES.tax_cd%type,
   aeg_tax_amt            GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE,
   aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
   p_msg_alert             OUT   VARCHAR2,
   p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
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
  dummy 			   varchar2(1);
BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);


  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/
  select 	GL_ACCT_CATEGORY,	GL_CONTROL_ACCT,
		GL_SUB_ACCT_1,		GL_SUB_ACCT_2,
		GL_SUB_ACCT_3,		GL_SUB_ACCT_4,
		GL_SUB_ACCT_5,		GL_SUB_ACCT_6,
		GL_SUB_ACCT_7,		GL_ACCT_ID
  into    	ws_gl_acct_category, 	ws_gl_control_acct, 
		ws_gl_sub_acct_1,       ws_gl_sub_acct_2   , 
		ws_gl_sub_acct_3  , 	ws_gl_sub_acct_4,
        	ws_gl_sub_acct_5   , 	ws_gl_sub_acct_6  , 
		ws_gl_sub_acct_7,	ws_gl_acct_id
  from 		giac_taxes
  where   	tax_cd = aeg_tax_cd;

  BEGIN
  --msg_alert('AEG CHK CHART OF ACCTS...','I',FALSE);
    SELECT 'x'
      INTO dummy
      FROM giac_chart_of_accts
    WHERE gl_acct_id = ws_gl_acct_id;
  EXCEPTION
    WHEN no_data_found THEN
      BEGIN
        p_msg_alert := 'GL account code '||to_char(ws_gl_acct_category)
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
  END;



  /****************************************************************************
  *                                                                           *
  * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *

  * debit-credit tag to determine whether the positive amount will be debited *
  * or credited.                                                              *
  *                                                                           *
  ****************************************************************************/

   IF ws_dr_cr_tag = 'D' THEN
      IF aeg_tax_amt > 0 THEN
        ws_debit_amt  := ABS(aeg_tax_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_tax_amt);
      END IF;
    ELSE
      IF aeg_tax_amt > 0 THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_tax_amt);
      ELSE
        ws_debit_amt  := ABS(aeg_tax_amt);
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

   AEG_Ins_Upd_Acct_tax_N(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                  null               , aeg_gen_type      , ws_gl_acct_id   ,        
                                  ws_debit_amt       , ws_credit_amt,
								  p_giop_gacc_branch_cd,
   								  p_giop_gacc_fund_cd,
   								  p_giop_gacc_tran_id);
END;
/


