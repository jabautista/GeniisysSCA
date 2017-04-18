CREATE OR REPLACE PACKAGE CPI.UPLOAD_DPC_WEB AS
/* Created By:   Vincent
** Date Created: 02132006
** Description:  This package holds most of the procedures used by the accounting
**               uploading modules for direct premium collections.
*/
  pvar_fund_cd     GIIS_FUNDS.fund_cd%TYPE;
  pvar_branch_cd   GIAC_BRANCHES.branch_cd%TYPE;
  pvar_evat_cd     GIAC_TAXES.tax_cd%TYPE;

  pvar_tran_id     GIAC_ACCTRANS.tran_id%TYPE;
  pvar_module_id   GIAC_MODULES.module_id%TYPE;
  pvar_gen_type    GIAC_MODULES.generation_type%TYPE;

  pvar_sl_type_cd1    GIAC_PARAMETERS.param_name%TYPE;
  pvar_sl_type_cd2    GIAC_PARAMETERS.param_name%TYPE;
  pvar_sl_type_cd3    GIAC_PARAMETERS.param_name%TYPE;
  pvar_comm_take_up   GIAC_PARAMETERS.param_value_n%TYPE;

  pvar_item_num    giac_module_entries.item_no%TYPE;  --alfie 11162009
  pvar_bill_no    gipi_invoice.prem_seq_no%TYPE; --alfie 11162009
  pvar_issue_cd    gipi_invoice.iss_cd%TYPE; --alfie 11162009

  PROCEDURE set_fixed_variables (
     p_fund_cd    VARCHAR2
    ,p_branch_cd  VARCHAR2
    ,p_evat_cd    NUMBER
    );

  PROCEDURE check_tran_mm (
     p_date   IN GIAC_ACCTRANS.tran_date%TYPE
    );

  PROCEDURE Check_Dcb_User (
    p_date   IN GIAC_ACCTRANS.tran_date%TYPE,
    p_user_id   IN  VARCHAR2
    );

  PROCEDURE get_dcb_no (
    p_date     IN  GIAC_ACCTRANS.tran_date%TYPE
   ,p_dcb_no   OUT GIAC_COLLN_BATCH.dcb_no%TYPE
    );

   --Deo [10.06.2016]: add start
   PROCEDURE create_dcb_no (
      p_dcb_no      NUMBER,
      p_or_date     giac_upload_prem_refno.tran_date%TYPE,
      p_fund_cd     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   );

   PROCEDURE get_dcb_no2 (
      p_date        IN       giac_acctrans.tran_date%TYPE,
      p_dcb_no      OUT      giac_colln_batch.dcb_no%TYPE,
      p_with_open   OUT      VARCHAR2
   );
   --Deo [10.06.2016]: add ends
   
  PROCEDURE tax_alloc_type1 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    );

  PROCEDURE tax_alloc_type3 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    );

  PROCEDURE aeg_check_level (
     cl_level         IN NUMBER
    ,cl_value         IN NUMBER
    ,cl_sub_acct1 IN OUT NUMBER
    ,cl_sub_acct2 IN OUT NUMBER
    ,cl_sub_acct3 IN OUT NUMBER
    ,cl_sub_acct4 IN OUT NUMBER
    ,cl_sub_acct5 IN OUT NUMBER
    ,cl_sub_acct6 IN OUT NUMBER
    ,cl_sub_acct7 IN OUT NUMBER
    );

  PROCEDURE aeg_check_chart_of_accts (
     cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    );

  --modified by jason: added branch_cd and fund_cd
  PROCEDURE aeg_parameters (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE
    ,aeg_fund_cd     GIAC_ACCTRANS.gfun_fund_cd%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,p_user_id        VARCHAR2
    );

  PROCEDURE aeg_create_acct_entries (
     aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE
    ,aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_acct_amt           GIPI_INVOICE.prem_amt%TYPE
    ,aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_insert_update_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ,p_user_id               VARCHAR2
    );

  PROCEDURE gen_dpc_acct_entries (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,p_user_id      varchar2
    );

  PROCEDURE aeg_parameters_y_prem_rec (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,p_user_id       varchar2
    );

  PROCEDURE aeg_parameters_y_prem_dep (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,p_user_id      varchar2
    );

  PROCEDURE aeg_parameters_y (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,p_user_id      varchar2
    );

  PROCEDURE aeg_create_dpc_acct_entries (
     aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE
    ,aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE
    ,aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE
    ,aeg_line_cd            GIIS_LINE.line_cd%TYPE
    ,aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE
    ,aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE
    ,aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_ins_upd_dpc_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_parameters_n (
     p_tran_id   GIAC_ACCTRANS.tran_id%TYPE
    ,p_module_nm  GIAC_MODULES.module_name%TYPE
    ,p_user_id      varchar2
    );

  PROCEDURE aeg_create_acct_entries_tax_n (
     aeg_tax_cd    GIAC_TAXES.tax_cd%TYPE
    ,aeg_tax_amt    GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE
    ,aeg_gen_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,p_user_id      VARCHAR2
    );

  PROCEDURE aeg_ins_upd_acct_tax_n (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_parameters_pdep (
     aeg_tran_id   GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm  GIAC_MODULES.module_name%TYPE
    ,p_user_id      varchar2
    );

  PROCEDURE aeg_create_pdep_acct_entries (
     aeg_collection_amt   GIAC_BANK_COLLNS.collection_amt%TYPE
    ,aeg_gen_type         GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,aeg_module_id        GIAC_MODULES.module_id%TYPE
    ,aeg_item_no          GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_sl_cd            GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,aeg_sl_type_cd       GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,aeg_sl_source_cd     GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_ins_upd_pdep_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_parameters_misc (
     aeg_tran_id       GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm      GIAC_MODULES.module_name%TYPE
    ,aeg_item_no         GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_collection_amt  GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,aeg_sl_cd           GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,p_user_id          varchar2
    );

  PROCEDURE aeg_create_misc_acct_entries (
     aeg_collection_amt   GIAC_BANK_COLLNS.collection_amt%TYPE
    ,aeg_gen_type         GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,aeg_module_id        GIAC_MODULES.module_id%TYPE
    ,aeg_item_no          GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_sl_cd            GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,aeg_sl_type_cd       GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,aeg_sl_source_cd     GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE aeg_ins_upd_misc_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE prem_to_be_pd_type1 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    );

  PROCEDURE prem_to_be_pd_type3 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    );

  PROCEDURE aeg_parameters_comm (
     aeg_tran_id    GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,aeg_sl_type_cd1  GIAC_PARAMETERS.param_name%TYPE
    ,aeg_sl_type_cd2  GIAC_PARAMETERS.param_name%TYPE
    ,aeg_sl_type_cd3  GIAC_PARAMETERS.param_name%TYPE
    ,p_user_id          VARCHAR2
    );

  PROCEDURE get_sl_code (
     p_intm_no           IN NUMBER
    ,p_assd_no           IN NUMBER
    ,p_acct_line_cd      IN NUMBER
    ,p_sl_cd_c          OUT NUMBER
    ,p_sl_cd_t          OUT NUMBER
    ,p_sl_cd_i          OUT NUMBER
    ,p_gl_intm_no       OUT NUMBER
    );

  PROCEDURE comm_payable_proc (
     p_intm_no       IN GIAC_COMM_PAYTS.intm_no%TYPE
    ,p_assd_no       IN GIPI_POLBASIC.assd_no%TYPE
    ,p_acct_line_cd  IN GIIS_LINE.acct_line_cd%TYPE
    ,p_comm_amt      IN GIAC_COMM_PAYTS.comm_amt%TYPE
    ,p_wtax_amt      IN GIAC_COMM_PAYTS.wtax_amt%TYPE
   ,p_line_cd       IN GIIS_LINE.line_cd%TYPE
    ,p_input_vat_amt IN GIAC_COMM_PAYTS.input_vat_amt%TYPE
    ,p_sl_cd1        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,p_sl_cd2        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,p_sl_cd3        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,p_user_id       IN VARCHAR2
    );

  PROCEDURE aeg_ins_upd_comm_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ,p_user_id              VARCHAR2
    );

  PROCEDURE upd_guf(
     p_gacc_tran_id  GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    );

  PROCEDURE upd_guf_jv(
     p_gacc_tran_id  GIAC_ACCTRANS.tran_id%TYPE
    ,p_tran_seq_no   GIAC_ACCTRANS.tran_seq_no%TYPE
    );

  PROCEDURE upd_guf_dv(
     p_gacc_tran_id  GIAC_ACCTRANS.tran_id%TYPE
    );

  --Added by Jason 08-06-2007 start--
  PROCEDURE aeg_create_cib_acct_entries(
     aeg_tran_id         GIAC_ACCTRANS.tran_id%TYPE,
  aeg_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
  aeg_fund_cd         GIAC_ACCTRANS.gfun_fund_cd%TYPE,
     aeg_bank_cd       GIAC_BANKS.bank_cd%TYPE,
     aeg_bank_acct_cd    GIAC_BANK_ACCOUNTS.bank_acct_cd%TYPE,
     aeg_acct_amt      GIAC_COLLECTION_DTL.amount%TYPE,
  aeg_gen_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
  p_user_id     VARCHAR2
 );

  PROCEDURE AEG_Delete_Acct_Entries(
    aeg_tran_id          GIAC_ACCTRANS.tran_id%TYPE,
 aeg_gen_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
 );
  --Added by Jason 08-06-2007 end--

  PROCEDURE aeg_parameters_inwfacul (
     aeg_tran_id  GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm  GIAC_MODULES.module_name%TYPE
    ,aeg_sl_type_cd1    GIAC_PARAMETERS.param_name%TYPE
    ,aeg_sl_type_cd2    GIAC_PARAMETERS.param_name%TYPE
    ,p_user_id       varchar2
    );

  PROCEDURE aeg_create_inwfacul_entries (
     aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
     aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
     aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
     aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
     aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
     aeg_line_cd            GIIS_LINE.line_cd%TYPE,
     aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
     aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
     aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
     p_user_id              VARCHAR2
    );

  PROCEDURE aeg_ins_up_inwfacul_entries (
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
     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
     iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
     iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
     iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
     iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
     p_user_id              VARCHAR2
    );

  PROCEDURE aeg_parameters_outfacul (
     aeg_tran_id  GIAC_ACCTRANS.tran_id%TYPE,
     aeg_module_nm  GIAC_MODULES.module_name%TYPE,
     p_user_id          varchar2
    );

  PROCEDURE aeg_create_outfacul_entries (
     aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
     aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
     aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
     aeg_iss_cd             GIAC_RI_REQ_PAYT_DTL.iss_cd%TYPE,
     aeg_bill_no            GIAC_RI_REQ_PAYT_DTL.prem_seq_no%TYPE,
     aeg_line_cd            GIIS_LINE.line_cd%TYPE,
     aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
     aeg_acct_amt           GIAC_OUTFACUL_PREM_PAYTS.disbursement_amt%TYPE,
     aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
     p_user_id            VARCHAR2
    );

  PROCEDURE aeg_get_sl_type_leaf_tag (
     aeg_gl_acct_id GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    );

  PROCEDURE aeg_ins_up_outfacul_entries (
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
     iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE,
     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
     p_user_id              VARCHAR2
    );
END UPLOAD_DPC_WEB; 
/