CREATE OR REPLACE PACKAGE CPI.Create_Acctg_Entries AS

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
  v_message           OUT VARCHAR2);

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
  p_fund_cd              VARCHAR2);

   PROCEDURE BPC_AEG_Create_Acct_Entries_Y (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                                            aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
                                            aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
                                            --aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
                                            --aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
                                            --aeg_line_cd            GIIS_LINE.line_cd%TYPE,
                                            --aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
                                            aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
                                            aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
           v_message           OUT VARCHAR2,
           p_gacc_tran_id         NUMBER,
                                            p_branch_cd            VARCHAR2,
                                            p_fund_cd              VARCHAR2);
END;
/


