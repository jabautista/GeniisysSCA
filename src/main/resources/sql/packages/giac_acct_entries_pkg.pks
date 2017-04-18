CREATE OR REPLACE PACKAGE CPI.giac_acct_entries_pkg
AS
   TYPE acct_entries_type IS RECORD (
      gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      acct_entry_id         giac_acct_entries.acct_entry_id%TYPE,
      gl_acct_id            giac_acct_entries.gl_acct_id%TYPE,
      gl_acct_category      VARCHAR2 (5),
                                   --GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
      gl_control_acct       VARCHAR2 (5),
                                    --GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
      gl_sub_acct_1         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
      gl_sub_acct_2         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
      gl_sub_acct_3         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
      gl_sub_acct_4         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
      gl_sub_acct_5         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
      gl_sub_acct_6         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
      gl_sub_acct_7         VARCHAR2 (5),
                                      --GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
      sl_cd                 giac_acct_entries.sl_cd%TYPE,
      debit_amt             giac_acct_entries.debit_amt%TYPE,
      credit_amt            giac_acct_entries.credit_amt%TYPE,
      generation_type       giac_acct_entries.generation_type%TYPE,
      sl_type_cd            giac_acct_entries.sl_type_cd%TYPE,
      sl_source_cd          giac_acct_entries.sl_source_cd%TYPE,
      remarks               giac_acct_entries.remarks%TYPE,
      cpi_rec_no            giac_acct_entries.cpi_rec_no%TYPE,
      cpi_branch_cd         giac_acct_entries.cpi_branch_cd%TYPE,
      sap_text              giac_acct_entries.sap_text%TYPE,
      gl_acct_name          giac_chart_of_accts.gl_acct_name%TYPE,
      sl_name               giac_sl_lists.sl_name%TYPE,
      acct_code                VARCHAR2 (100),
      ledger_cd			    giac_gl_acct_ref_no.ledger_cd%TYPE,		--start - Gzelle 11102015 KB#132 AP/AR ENH
      subledger_cd			giac_gl_acct_ref_no.subledger_cd%TYPE,
      transaction_cd   	    giac_gl_acct_ref_no.transaction_cd%TYPE,
      acct_seq_no   	    giac_gl_acct_ref_no.acct_seq_no%TYPE,
      acct_tran_type		giac_acct_entries.acct_tran_type%TYPE,	
      acct_ref_no           giac_acct_entries.acct_ref_no%TYPE,
      dr_cr_tag             giac_chart_of_accts.dr_cr_tag%TYPE      --end - Gzelle 11122015 KB#132 AP/AR ENH
   );

   TYPE acct_entries_tab IS TABLE OF acct_entries_type;

   PROCEDURE aeg_delete_acct_entries (
      p_gacc_tran_id    giac_prem_deposit.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE
   );

   PROCEDURE aeg_insert_update_acct_entries (
      p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acctrans.tran_id%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE
   );

   PROCEDURE aeg_create_acct_entries (
      p_gacc_branch_cd           giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd             giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id             giac_acctrans.tran_id%TYPE,
      aeg_collection_amt         giac_bank_collns.collection_amt%TYPE,
      aeg_gen_type               giac_acct_entries.generation_type%TYPE,
      aeg_module_id              giac_modules.module_id%TYPE,
      aeg_item_no                giac_module_entries.item_no%TYPE,
      aeg_sl_cd                  giac_acct_entries.sl_cd%TYPE,
      aeg_sl_type_cd             giac_acct_entries.sl_type_cd%TYPE,
      aeg_sl_source_cd           giac_acct_entries.sl_source_cd%TYPE,
      p_message            OUT   VARCHAR2
   );

   PROCEDURE aeg_parameters (
      p_gacc_branch_cd           giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd             giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id             giac_acctrans.tran_id%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_dep_flag                 giac_prem_deposit.dep_flag%TYPE,
      p_b140_iss_cd              giac_prem_deposit.b140_iss_cd%TYPE,
      p_b140_prem_seq_no         giac_prem_deposit.b140_prem_seq_no%TYPE,
      p_message            OUT   VARCHAR2
   );

   PROCEDURE aeg_check_level (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   );

   PROCEDURE aeg_check_chart_of_accts (
      cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE,
      p_msg_alert            OUT      VARCHAR2
   );

   PROCEDURE insert_update_acct_entries (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      p_gacc_branch_cd        giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      p_user_id               giis_users.user_id%TYPE
   );

   PROCEDURE giacs020_aeg_ins_upd_acct_ents (
      p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acctrans.tran_id%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE
   );

   PROCEDURE aeg_create_acct_entries2 (
      aeg_sl_cd                giac_acct_entries.sl_cd%TYPE,
      aeg_module_id            giac_module_entries.module_id%TYPE,
      aeg_item_no              giac_module_entries.item_no%TYPE,
      aeg_iss_cd               giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no              giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      aeg_line_cd              giis_line.line_cd%TYPE,
      aeg_type_cd              gipi_polbasic.type_cd%TYPE,
      aeg_acct_amt             giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type             giac_acct_entries.generation_type%TYPE,
      p_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
      p_user_id                giis_users.user_id%TYPE,
      p_msg_alert        OUT   VARCHAR2
   );

   PROCEDURE aeg_parameters2 (
      aeg_tran_id              giac_acctrans.tran_id%TYPE,
      aeg_module_nm            giac_modules.module_name%TYPE,
      aeg_sl_type_cd1          giac_parameters.param_name%TYPE,
      aeg_sl_type_cd2          giac_parameters.param_name%TYPE,
      p_gen_type               giac_acct_entries.generation_type%TYPE,
      p_module_id              giac_modules.module_id%TYPE,
      p_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_user_id                giis_users.user_id%TYPE,
      p_msg_alert        OUT   VARCHAR2
   );

   PROCEDURE aeg_delete_acct_entries_y (
      p_gacc_tran_id         giac_prem_deposit.gacc_tran_id%TYPE,
      p_module_name          giac_modules.module_name%TYPE,
      p_module_id      OUT   giac_modules.module_id%TYPE,
      p_gen_type       OUT   giac_modules.generation_type%TYPE
   );

   PROCEDURE giacs020_overdraft_comm_entry (
      p_gacc_branch_cd   IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd     IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id     IN       giac_comm_payts.gacc_tran_id%TYPE,
      p_iss_cd           IN       giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no      IN       giac_comm_payts.prem_seq_no%TYPE,
      p_intm_no          IN       giac_comm_payts.intm_no%TYPE,
      p_record_no        IN       giac_comm_payts.record_no%TYPE,
      p_disb_comm        IN       giac_comm_payts.disb_comm%TYPE,
      p_drv_comm_amt     IN       NUMBER,
      p_currency_cd      IN       giac_comm_payts.currency_cd%TYPE,
      p_convert_rate     IN       giac_comm_payts.convert_rate%TYPE,
      p_message          OUT      VARCHAR2
   );

   /*
   PROCEDURE aeg_parameters_y(aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
                                aeg_module_nm    GIAC_MODULES.module_name%TYPE,
                             aeg_sl_type_cd1  GIAC_PARAMETERS.param_name%TYPE,
                                aeg_sl_type_cd2  GIAC_PARAMETERS.param_name%TYPE,
                                aeg_sl_type_cd3  GIAC_PARAMETERS.param_name%TYPE);*/
   PROCEDURE gen_acct_entr_y (
      p_gacc_tran_id                giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name                 giac_modules.module_name%TYPE,
      p_item_no               OUT   INTEGER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   );

   PROCEDURE aeg_parameters_y (
      aeg_tran_id                   giac_acctrans.tran_id%TYPE,
      aeg_module_nm                 giac_modules.module_name%TYPE,
      p_item_no               OUT   NUMBER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   );

   PROCEDURE aeg_parameters_y_prem_dep (
      aeg_tran_id                   giac_acctrans.tran_id%TYPE,
      aeg_module_nm                 giac_modules.module_name%TYPE,
      p_item_no               OUT   INTEGER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   );

   PROCEDURE aeg_parameters_y_prem_rec (
      aeg_tran_id                   giac_acctrans.tran_id%TYPE,
      aeg_module_nm                 giac_modules.module_name%TYPE,
      p_item_no               OUT   NUMBER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   );

   PROCEDURE aeg_create_acct_entries_y (
      aeg_sl_cd               giac_acct_entries.sl_cd%TYPE,
      aeg_module_id           giac_module_entries.module_id%TYPE,
      aeg_item_no             giac_module_entries.item_no%TYPE,
      aeg_iss_cd              giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no             giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      aeg_line_cd             giis_line.line_cd%TYPE,
      aeg_type_cd             gipi_polbasic.type_cd%TYPE,
      aeg_acct_amt            giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type            giac_acct_entries.generation_type%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_check_level_y (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   );

   PROCEDURE aeg_check_chart_of_accts_y (
      cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE,
      aeg_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE
   );

   PROCEDURE aeg_insert_update_acct_y (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE gen_acct_entr_n (
      p_module_nm                   giac_modules.module_name%TYPE,
      p_transaction_type            giac_direct_prem_collns.transaction_type%TYPE,
      p_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
      p_item_no               OUT   NUMBER
   );

   PROCEDURE aeg_parameters_n (
      p_module_nm                   giac_modules.module_name%TYPE,
      p_transaction_type            giac_direct_prem_collns.transaction_type%TYPE,
      p_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
      p_item_no               OUT   NUMBER
   );

   PROCEDURE aeg_delete_acct_entries_n (
      p_gen_type            giac_modules.generation_type%TYPE,
      p_giop_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_create_acct_entries_n (
      aeg_sl_cd               giac_acct_entries.sl_cd%TYPE,
      aeg_module_id           giac_module_entries.module_id%TYPE,
      aeg_item_no             giac_module_entries.item_no%TYPE,
      aeg_iss_cd              giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no             giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      aeg_line_cd             giis_line.line_cd%TYPE,
      aeg_type_cd             gipi_polbasic.type_cd%TYPE,
      aeg_acct_amt            giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type            giac_acct_entries.generation_type%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_create_acct_entries_tax_n (
      aeg_tax_cd              giac_taxes.tax_cd%TYPE,
      aeg_tax_amt             giac_direct_prem_collns.tax_amt%TYPE,
      aeg_gen_type            giac_acct_entries.generation_type%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_ins_upd_acct_tax_n (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_check_chart_of_accts_n (
      cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE
   );

   PROCEDURE aeg_insert_update_acct_n (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      iuae_bill_no            giac_tax_collns.b160_prem_seq_no%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_check_level_n (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   );

   PROCEDURE aeg_ins_updt_acct_ent_giacs018 (
      p_gacc_tran_id      IN       giac_inw_claim_payts.gacc_tran_id%TYPE,
      p_gacc_branch_cd    IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd      IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_var_module_name   IN       giac_modules.module_name%TYPE,
      p_var_gen_type      IN OUT   giac_modules.generation_type%TYPE,
      p_message           OUT      VARCHAR2
   );

   FUNCTION get_acct_entries (
      p_gacc_tran_id   IN   giac_acct_entries.gacc_tran_id%TYPE
   )
      RETURN acct_entries_tab PIPELINED;

   PROCEDURE aeg_ins_updt_acct_ent_giacs022 (
      p_gacc_tran_id          giac_taxes_wheld.gacc_tran_id%TYPE,
      p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      iuae_sl_type_cd         giac_taxes_wheld.sl_type_cd%TYPE,
      iuae_sl_cd              giac_taxes_wheld.sl_cd%TYPE
   );

   PROCEDURE aeg_create_acc_ent_giacs022 (
      p_gacc_tran_id            giac_taxes_wheld.gacc_tran_id%TYPE,
      p_gacc_branch_cd          giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd            giac_acctrans.gfun_fund_cd%TYPE,
      aeg_module_id             giac_module_entries.module_id%TYPE,
      aeg_item_no               giac_module_entries.item_no%TYPE,
      aeg_acct_amt              giac_taxes_wheld.wholding_tax_amt%TYPE,
      aeg_sl_type_cd            giac_taxes_wheld.sl_type_cd%TYPE,
      aeg_sl_cd                 giac_taxes_wheld.sl_cd%TYPE,
      aeg_gwtx_whtax_id         giac_taxes_wheld.gwtx_whtax_id%TYPE,
      aeg_gen_type              giac_acct_entries.generation_type%TYPE,
      p_message           OUT   VARCHAR2
   );

   PROCEDURE aeg_parameters_giacs022 (
      p_gacc_tran_id      IN       giac_taxes_wheld.gacc_tran_id%TYPE,
      p_gacc_branch_cd    IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd      IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_var_module_name   IN       giac_modules.module_name%TYPE,
      p_message           OUT      VARCHAR2
   );

   PROCEDURE delete_acct_entry (
      p_gacc_tran_id    IN   giac_acct_entries.gacc_tran_id%TYPE,
      p_acct_entry_id   IN   giac_acct_entries.acct_entry_id%TYPE
   );

   PROCEDURE save_acct_entry (
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      p_gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_acct_entry_id         NUMBER,
      p_gl_acct_id            giac_acct_entries.gl_acct_id%TYPE,
      p_gl_acct_category      giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct       giac_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd                 giac_acct_entries.sl_cd%TYPE,
      p_debit_amt             giac_acct_entries.debit_amt%TYPE,
      p_credit_amt            giac_acct_entries.credit_amt%TYPE,
      p_generation_type       giac_acct_entries.generation_type%TYPE,
      p_sl_type_cd            giac_acct_entries.sl_type_cd%TYPE,
      p_sl_source_cd          giac_acct_entries.sl_source_cd%TYPE,
      p_remarks               giac_acct_entries.remarks%TYPE,
      p_sap_text              giac_acct_entries.sap_text%TYPE,
      p_user_id               giac_acct_entries.user_id%TYPE,
      p_acct_ref_no           giac_acct_entries.acct_ref_no%TYPE,   --Gzelle 11102015 KB#132 AP/AR ENH 
      p_acct_tran_type        giac_acct_entries.acct_tran_type%TYPE --Gzelle 11102015 KB#132 AP/AR ENH
   );

   PROCEDURE bpc_aeg_create_acct_entries_y (
      aeg_sl_cd              giac_acct_entries.sl_cd%TYPE,
      aeg_module_id          giac_module_entries.module_id%TYPE,
      aeg_item_no            giac_module_entries.item_no%TYPE,
      --aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
      --aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
      --aeg_line_cd            GIIS_LINE.line_cd%TYPE,
      --aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
      aeg_acct_amt           giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type           giac_acct_entries.generation_type%TYPE,
      v_message        OUT   VARCHAR2,
      p_gacc_tran_id         NUMBER,
      p_branch_cd            VARCHAR2,
      p_fund_cd              VARCHAR2
   );

   PROCEDURE update_acct_entries (
      p_gacc_branch_cd       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd         giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id         giac_acctrans.tran_id%TYPE,
      p_collection_amt       giac_oth_fund_off_collns.collection_amt%TYPE,
      uae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      uae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      uae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      uae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      uae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      uae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      uae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      uae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      uae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE
   );

   PROCEDURE aeg_ins_upd_acct_entr_giacs012 (
      p_gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE
   );

   PROCEDURE aeg_create_acct_entr_giacs012 (
      p_gacc_gibr_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_gfun_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id                giac_acct_entries.gacc_tran_id%TYPE,
      aeg_module_id                 giac_module_entries.module_id%TYPE,
      aeg_item_no                   giac_module_entries.item_no%TYPE,
      aeg_acct_amt                  giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type                  giac_acct_entries.generation_type%TYPE,
      p_message               OUT   VARCHAR2
   );

   PROCEDURE aeg_parameters_giacs012 (
      p_gacc_gibr_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_gfun_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id                giac_acct_entries.gacc_tran_id%TYPE,
      p_collection_amt              giac_oth_fund_off_collns.collection_amt%TYPE,
      p_item_no                     giac_module_entries.item_no%TYPE,
      p_module_name                 giac_modules.module_name%TYPE,
      p_message               OUT   VARCHAR2
   );

   PROCEDURE aeg_delete_entries_rev (
      p_acc_tran_id   giac_acctrans.tran_id%TYPE,
      p_gen_type      giac_modules.generation_type%TYPE
   );

   PROCEDURE aeg_insert_update_entries_rev (
      iuae_gl_acct_category    giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct     giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1       giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2       giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3       giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4       giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5       giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6       giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7       giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_type_cd          giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_source_cd        giac_acct_entries.sl_source_cd%TYPE,
      iuae_sl_cd               giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type     giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id          giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt           giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt          giac_acct_entries.credit_amt%TYPE,
      iuae_gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      iuae_gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      iuae_acc_tran_id         giac_acctrans.tran_id%TYPE
   );

   PROCEDURE aeg_parameters_rev (
      p_aeg_tran_id               giac_acctrans.tran_id%TYPE,
      p_aeg_module_nm             giac_modules.module_name%TYPE,
      p_acc_tran_id               giac_acctrans.tran_id%TYPE,
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_message             OUT   VARCHAR2
   );

   PROCEDURE create_rev_entries (
      p_assd_no             IN       gipi_polbasic.assd_no%TYPE,
      p_coll_amt            IN       giac_comm_payts.comm_amt%TYPE,
      p_line_cd             IN       giis_line.line_cd%TYPE,
      p_sl_cd                        giac_acct_entries.sl_cd%TYPE,
      p_gacc_tran_id        IN       giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_acc_tran_id                  giac_acctrans.tran_id%TYPE,
      p_message             OUT      VARCHAR2
   );

   PROCEDURE force_close_acct_entries (
      p_gacc_tran_id              giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_item_no                   giac_module_entries.item_no%TYPE,
      p_module_name               VARCHAR2,
      p_message             OUT   VARCHAR2
   );

   PROCEDURE gen_reversing_acct_entries (
      p_gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_acc_tran_id         giac_acctrans.tran_id%TYPE
   );

   PROCEDURE insert_acctrans_cap (
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_rev_tran_date                giac_acctrans.tran_date%TYPE,
      p_rev_tran_class_no            giac_acctrans.tran_class_no%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_tran_id             IN OUT   giac_acctrans.tran_id%TYPE,
      p_message             OUT      VARCHAR2
   );

   PROCEDURE insert_into_acct_entries (
      p_gacc_tran_id              giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_acc_tran_id               giac_acctrans.tran_id%TYPE,
      p_item_no                   giac_module_entries.item_no%TYPE,
      p_module_name               VARCHAR2,
      p_message             OUT   VARCHAR2
   );

   PROCEDURE aeg_parameters_giacs019 (
      p_tran_id                giac_acctrans.tran_id%TYPE,
      p_module_name            giac_modules.module_name%TYPE,
      p_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
      p_message          OUT   VARCHAR2
   );

   PROCEDURE aeg_create_acct_ent_giacs019 (
      aeg_sl_cd                  giac_acct_entries.sl_cd%TYPE,
      aeg_module_id              giac_module_entries.module_id%TYPE,
      aeg_item_no                giac_module_entries.item_no%TYPE,
      aeg_iss_cd                 giac_ri_req_payt_dtl.iss_cd%TYPE,
      aeg_bill_no                giac_ri_req_payt_dtl.prem_seq_no%TYPE,
      aeg_line_cd                giis_line.line_cd%TYPE,
      --aeg_type_cd                gipi_polbasic.type_cd%TYPE, commented by: Nica 06.27.2013
      aeg_acct_amt               giac_outfacul_prem_payts.disbursement_amt%TYPE,
      aeg_gen_type               giac_acct_entries.generation_type%TYPE,
      aeg_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
      aeg_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
      aeg_gacc_tran_id           giac_order_of_payts.gacc_tran_id%TYPE,
      aeg_message          OUT   VARCHAR2
   );

   PROCEDURE aeg_ins_upd_acct_ent_giacs019 (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_gacc_branch_cd     giac_acctrans.gibr_branch_cd%TYPE,
      iuae_gacc_fund_cd       giac_acctrans.gfun_fund_cd%TYPE,
      iuae_gacc_tran_id       giac_order_of_payts.gacc_tran_id%TYPE
   );

   PROCEDURE aeg_delete_acct_ent_giacs019 (
      p_gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE
   );

   PROCEDURE aeg_get_sl_type_leaf_tag (
      p_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      p_sl_cd              giac_acct_entries.sl_cd%TYPE,
      p_message      OUT   VARCHAR2
   );

   PROCEDURE aeg_parameters_giacs001 (
      p_tran_id             giac_acctrans.tran_id%TYPE,
      p_branch_cd           giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd             giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_module_name         giac_modules.module_name%TYPE,
      p_sl_cd               giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd          giac_acct_entries.sl_type_cd%TYPE,
      p_message       OUT   VARCHAR2
   );
   
   PROCEDURE aeg_ins_upd_rcm_entr_giacs001
    (p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
     p_gacc_fund_cd         giac_acct_entries.gacc_gfun_fund_cd%TYPE,
     p_gacc_branch_cd       giac_acct_entries.gacc_gibr_branch_cd%TYPE,
     iuae_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE,
     iuae_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE,
     iuae_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE,
     iuae_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE,
     iuae_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE,
     iuae_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE,
     iuae_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE,
     iuae_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE,
     iuae_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE,
     iuae_sl_cd             giac_acct_entries.sl_cd%TYPE,
     iuae_generation_type   giac_acct_entries.generation_type%TYPE,
     iuae_sl_type_cd        giac_acct_entries.sl_type_cd%TYPE,
     iuae_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
     iuae_debit_amt         giac_acct_entries.debit_amt%TYPE,
     iuae_credit_amt        giac_acct_entries.credit_amt%TYPE);
     
   PROCEDURE ins_rcm_into_op_text_giacs001 
    (p_gacc_tran_id           giac_op_text.gacc_tran_id%TYPE,
     p_gen_type               giac_modules.generation_type%TYPE,
     p_ri_local_comm_amt      giac_op_text.item_amt%TYPE,
     p_ri_local_comm_vat      giac_op_text.item_amt%TYPE,
     p_ri_foreign_comm_amt    giac_op_text.item_amt%TYPE,
     p_ri_foreign_comm_vat    giac_op_text.item_amt%TYPE,
     p_currency_cd            giac_op_text.currency_cd%TYPE);

   PROCEDURE delete_acct_entries_giacs001 (
      p_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE
   );

   PROCEDURE aeg_create_cib_giacs001 (
      p_bank_cd              giac_banks.bank_cd%TYPE,
      p_bank_acct_cd         giac_bank_accounts.bank_acct_cd%TYPE,
      p_acct_amt             giac_collection_dtl.amount%TYPE,
      p_gen_type             giac_acct_entries.generation_type%TYPE,
      p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
      p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_message        OUT   VARCHAR2
   );

   PROCEDURE create_acct_entries_giacs001 (
      p_module_id            giac_module_entries.module_id%TYPE,
      p_item_no              giac_module_entries.item_no%TYPE,
      p_acct_amt             giac_direct_prem_collns.collection_amt%TYPE,
      p_gen_type             giac_acct_entries.generation_type%TYPE,
      p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
      p_user_id              giis_users.user_id%TYPE,
      p_sl_cd                giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE,
      p_message        OUT   VARCHAR2
   );

   PROCEDURE aeg_balancing_entries_giacs035 (
      p_module_name   IN       giac_modules.module_name%TYPE,
      p_tran_id       IN       giac_acct_entries.gacc_tran_id%TYPE,
      p_branch_cd     IN       giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd       IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_item_no       IN       giac_module_entries.item_no%TYPE,
      p_with_pdc      IN       VARCHAR2,
      p_user          IN       giis_users.user_id%TYPE,
      p_mesg          OUT      VARCHAR2
   );

   TYPE acct_entries_type1 IS RECORD (
      dsp_gl_acct_code   VARCHAR2 (500),
      dsp_gl_acct_name   VARCHAR2 (500),
      dsp_sl_name   VARCHAR2 (500),
      gl_acct_id         gicl_acct_entries.gl_acct_id%TYPE,
      gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      sl_cd              gicl_acct_entries.sl_cd%TYPE,
      debit_amt          gicl_acct_entries.debit_amt%TYPE,
      credit_amt         gicl_acct_entries.credit_amt%TYPE
   );

   TYPE acct_entries_tab1 IS TABLE OF acct_entries_type1;

   FUNCTION get_giacs086_acct_entries (
      p_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
      p_gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_code            gicl_acct_entries.sl_cd%TYPE,
      p_debit_amt          gicl_acct_entries.debit_amt%TYPE,
      p_credit_amt         gicl_acct_entries.credit_amt%TYPE
   )
      RETURN acct_entries_tab1 PIPELINED;
      
   PROCEDURE Ins_Updt_Acct_Entries_gicls055 (
        p_recovery_acct_id        gicl_recovery_acct.recovery_acct_id%TYPE,
        p_tran_id                giac_acct_entries.gacc_tran_id%TYPE,
        p_fund_cd                giac_acctrans.gfun_fund_cd%TYPE,
        p_iss_cd                gicl_recovery_acct.iss_cd%TYPE,
        p_user_id                giis_users.user_id%TYPE
   );
   
   PROCEDURE offset_loss(
        p_tran_id       giac_acctrans.tran_id%TYPE,
        p_module_id     giac_module_entries.module_id%TYPE,
        p_user_id       giac_acct_entries.user_id%TYPE
   );
   
   PROCEDURE INS_UPDT_ACCT_ENTRIES_GICLB001(
        p_branch_cd            GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
        p_fund_cd              GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
        p_tran_id              GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
        iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
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
        iuae_sl_type_cd        giac_acct_entries.sl_type_cd%type
    );
    
    PROCEDURE ins_updt_acct_entries_giacs017(
        p_gacc_tran_id    GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_gacc_branch_cd  GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        p_gacc_fund_cd    GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        p_claim_id        giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       giac_direct_claim_payts.advice_id%TYPE,
        p_payee_class_cd  giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_cd        giac_direct_claim_payts.payee_cd%TYPE,
        p_var_gen_type    GIAC_MODULES.generation_type%TYPE,
        p_user_id         GIIS_USERS.user_id%TYPE
    );
    
    FUNCTION get_giacs016_sum_acct_entries (
      p_replenish_id   giac_acct_entries.gacc_tran_id%TYPE,
      p_gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_code            gicl_acct_entries.sl_cd%TYPE,
      p_debit_amt          gicl_acct_entries.debit_amt%TYPE,
      p_credit_amt         gicl_acct_entries.credit_amt%TYPE
   )
      RETURN acct_entries_tab1 PIPELINED;
      
   FUNCTION check_giacs060_gl_trans (
      p_branch_cd       VARCHAR2,
      p_fund_cd         VARCHAR2,
      p_category        VARCHAR2,
      p_control         VARCHAR2,
      p_sub1            VARCHAR2,
      p_sub2            VARCHAR2,
      p_sub3            VARCHAR2,
      p_sub4            VARCHAR2,
      p_sub5            VARCHAR2,
      p_sub6            VARCHAR2,
      p_sub7            VARCHAR2,
      p_tran_class      VARCHAR2,
      p_sl_cd           VARCHAR2,
      p_sl_type_cd      VARCHAR2,
      p_tran_post       VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2
   )
      RETURN VARCHAR2;   
      
      
   TYPE prem_rec_dtls_type IS RECORD (
      sl_cd    giac_acct_entries.sl_cd%TYPE,
      amount   giac_acct_entries.credit_amt%TYPE
   );

   TYPE prem_rec_dtls_tab IS TABLE OF prem_rec_dtls_type;

   FUNCTION peril_rec_computation (
      p_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_prem_colln    giac_direct_prem_collns.premium_amt%TYPE,
      p_gacc_tran_id  giac_acctrans.tran_id%TYPE
   )
      RETURN prem_rec_dtls_tab PIPELINED;
      
   FUNCTION intm_rec_computation (
      p_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_prem_colln    giac_direct_prem_collns.premium_amt%TYPE,
      p_gacc_tran_id  giac_acctrans.tran_id%TYPE
   )
      RETURN prem_rec_dtls_tab PIPELINED;
   PROCEDURE AEG_PARAMETERS_GIACS042 ( --  dren 08.03.2015 : SR 0017729 - GIACS042 Accounting Entries - Start
      p_gacc_branch_cd      giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd        giac_acctrans.gfun_fund_cd%TYPE,  
      p_gacc_tran_id        GIAC_ACCTRANS.tran_id%TYPE,
      p_module_name         GIAC_MODULES.module_name%TYPE,      
      p_message             OUT   VARCHAR2      
   );      
   PROCEDURE AEG_CREATE_ACCT_ENTRIES_42 (
      p_gacc_branch_cd           giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd             giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id             giac_acctrans.tran_id%TYPE,   
      p_bank_cd                  giac_bank_accounts.bank_cd%TYPE,
      p_bank_acct_cd             giac_bank_accounts.bank_acct_cd%TYPE,
      p_amount                   giac_dcb_bank_dep.amount%TYPE,
      p_module_id                giac_modules.module_id%TYPE,
      p_gen_type                 GIAC_ACCT_ENTRIES.generation_type%TYPE,   
      p_message           OUT    VARCHAR2    
   );   
   PROCEDURE AEG_CHECK_CHART_OF_ACCTS_42 (
      cca_gl_acct_id         IN OUT      giac_chart_of_accts.gl_acct_id%TYPE,      
      cca_gl_acct_category   IN OUT      giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct    IN OUT      giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1      IN OUT      giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2      IN OUT      giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3      IN OUT      giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4      IN OUT      giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5      IN OUT      giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6      IN OUT      giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7      IN OUT      giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_sl_type_cd         IN OUT      GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
      p_msg_alert            OUT         VARCHAR2 
   );  --  dren 08.03.2015 : SR 0017729 - GIACS042 Accounting Entries - End       
      
END giac_acct_entries_pkg;
/
