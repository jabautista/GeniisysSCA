CREATE OR REPLACE PACKAGE CPI.gipis175_pkg
AS
   TYPE policy_lov_type IS RECORD (
      policy_id            gipi_polbasic.policy_id%TYPE,
      line_cd              gipi_polbasic.line_cd%TYPE,
      subline_cd           gipi_polbasic.subline_cd%TYPE,
      iss_cd               gipi_polbasic.iss_cd%TYPE,
      issue_yy             gipi_polbasic.issue_yy%TYPE,
      pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
      renew_no             gipi_polbasic.renew_no%TYPE,
      par_id               gipi_polbasic.par_id%TYPE,
      pol_flag             gipi_polbasic.pol_flag%TYPE,
      pack_pol_flag        gipi_polbasic.pack_pol_flag%TYPE,
      co_insurance_sw      gipi_polbasic.co_insurance_sw%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      acct_ent_date        gipi_polbasic.acct_ent_date%TYPE,
      assd_no              gipi_polbasic.assd_no%TYPE,
      prorate_flag         gipi_polbasic.prorate_flag%TYPE,
      short_rt_percent     gipi_polbasic.short_rt_percent%TYPE,
      prov_prem_pct        gipi_polbasic.prov_prem_pct%TYPE,
      expired_sw           VARCHAR2 (1),
      endt_iss_cd          gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy              gipi_polbasic.endt_yy%TYPE,
      endt_seq_no          gipi_polbasic.endt_seq_no%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      nbt_incept_date      gipi_polbasic.incept_date%TYPE,
      nbt_eff_date         gipi_polbasic.eff_date%TYPE,
      nbt_acct_ent_date    gipi_polbasic.acct_ent_date%TYPE,
      nbt_expiry_date      gipi_polbasic.expiry_date%TYPE,
      nbt_issue_date       gipi_polbasic.issue_date%TYPE,
      nbt_booking_mth      gipi_polbasic.booking_mth%TYPE,
      nbt_booking_year     gipi_polbasic.booking_year%TYPE,
      nbt_ceding_company   giis_reinsurer.ri_name%TYPE,
      updatable_sw         VARCHAR2 (1),
      prev_ri_comm_amt     NUMBER (16, 2),
      old_ri_comm_vat      NUMBER (16, 2), --added by MarkS 9.14.2016 SR23053
      v480_policy_id       gipi_polbasic.policy_id%TYPE,
      v480_item_no         gipi_itmperil.item_no%TYPE,
      v480_ri_comm_amt     NUMBER (16, 2),
      v480_ri_comm_vat     NUMBER (16, 2),
      v_iss_cd             giis_issource.iss_cd%TYPE,
      branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE
                                                     := giacp.v ('BRANCH_CD'),
      fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE
                                                       := giacp.v ('FUND_CD'),
      ri_cd                giis_reinsurer.ri_cd%TYPE,
      input_vat_rate       giis_reinsurer.input_vat_rate%TYPE
   );

   TYPE policy_lov_tab IS TABLE OF policy_lov_type;

   FUNCTION get_policy_lov (
      p_user_id       VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_issue_yy      VARCHAR2,
      p_pol_seq_no    VARCHAR2,
      p_renew_no      VARCHAR2,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       VARCHAR2,
      p_endt_seq_no   VARCHAR2,
      p_assd_name     VARCHAR2
   )
      RETURN policy_lov_tab PIPELINED;

   TYPE item_type IS RECORD (
      prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      item_grp            gipi_item.item_grp%TYPE,
      item_desc           gipi_item.item_desc%TYPE,
      item_desc2          gipi_item.item_desc2%TYPE,
      rec_flag            gipi_item.rec_flag%TYPE,
      currency_cd         gipi_item.currency_cd%TYPE,
      dsp_currency_desc   giis_currency.currency_desc%TYPE,
      pack_line_cd        gipi_item.pack_line_cd%TYPE,
      pack_subline_cd     gipi_item.pack_subline_cd%TYPE,
      item_no             gipi_item.item_no%TYPE,
      item_title          gipi_item.item_title%TYPE,
      sum_comm_amt        NUMBER (16, 2),
      ri_comm_vat         gipi_invoice.ri_comm_vat%TYPE
   );

   TYPE item_tab IS TABLE OF item_type;

   FUNCTION get_items (p_policy_id VARCHAR2)
      RETURN item_tab PIPELINED;

   TYPE peril_type IS RECORD (
      policy_id          gipi_itmperil.policy_id%TYPE,
      line_cd            gipi_itmperil.line_cd%TYPE,
      peril_cd           gipi_itmperil.peril_cd%TYPE,
      item_no            gipi_itmperil.item_no%TYPE,
      dsp_peril_name     giis_peril.peril_name%TYPE,
      rec_flag           gipi_itmperil.rec_flag%TYPE,
      tarf_cd            gipi_itmperil.tarf_cd%TYPE,
      tsi_amt            gipi_itmperil.tsi_amt%TYPE,
      prem_rt            gipi_itmperil.prem_rt%TYPE,
      ann_tsi_amt        gipi_itmperil.ann_tsi_amt%TYPE,
      ann_prem_amt       gipi_itmperil.ann_prem_amt%TYPE,
      discount_sw        gipi_itmperil.discount_sw%TYPE,
      as_charge_sw       gipi_itmperil.as_charge_sw%TYPE,
      prem_amt           gipi_itmperil.prem_amt%TYPE,
      ri_comm_rate       gipi_itmperil.ri_comm_rate%TYPE,
      ri_comm_amt        gipi_itmperil.ri_comm_amt%TYPE,
      old_ri_comm_rate   gipi_itmperil.ri_comm_rate%TYPE,
      old_ri_comm_amt    gipi_itmperil.ri_comm_amt%TYPE,
      summ_comm_amt      gipi_itmperil.ri_comm_amt%TYPE,
      ri_comm_vat        gipi_invoice.ri_comm_vat%TYPE,
      old_ri_comm_vat    gipi_invoice.ri_comm_vat%TYPE,
      rg_num             NUMBER (3)
   );

   TYPE peril_tab IS TABLE OF peril_type;

   FUNCTION get_perils (p_policy_id VARCHAR2, p_item_no VARCHAR2)
      RETURN peril_tab PIPELINED;

   PROCEDURE pre_commit (
      p_policy_id          IN       VARCHAR2,
      p_item_grp           IN       VARCHAR2,
      p_iss_cd             OUT      VARCHAR2,
      p_prem_seq_no        OUT      VARCHAR2,
      p_prem_amt           OUT      VARCHAR2,
      p_prev_ri_comm_amt   OUT      VARCHAR2,
      p_tax_amt            OUT      VARCHAR2
   );

   PROCEDURE pop_ri_comm_vat (
      p_policy_id      IN       VARCHAR2,
      p_sum_comm_amt   IN       VARCHAR2,
      p_ri_comm_vat    OUT      VARCHAR2,
      p_ri_comm_rate   IN       VARCHAR2,
      p_ri_comm_amt    IN       VARCHAR2,
      p_item_no        IN       VARCHAR2,
      p_peril_cd       IN       VARCHAR2,
      p_co_insurance_sw IN    VARCHAR2,
      p_item_grp        IN    VARCHAR2
   );

   PROCEDURE create_records_in_acctrans (
      p_fund_cd       IN       VARCHAR2,
      p_branch_cd     IN       VARCHAR2,
      p_tran_class    IN       VARCHAR2,
      p_user_id       IN       VARCHAR2,
      p_tran_flag     IN       VARCHAR2,
      p_particulars   IN       VARCHAR2,
      p_tran_id       OUT      VARCHAR2
   );

   PROCEDURE aeg_delete_acct_entries (
      p_tran_id    IN   VARCHAR2,
      p_gen_type   IN   VARCHAR2
   );

   PROCEDURE aeg_create_acct_entries (
      p_aeg_module_id      IN   VARCHAR2,
      p_aeg_item_no        IN   VARCHAR2,
      p_aeg_acct_amt       IN   VARCHAR2,
      p_aeg_gen_type       IN   VARCHAR2,
      p_aeg_line_cd        IN   VARCHAR2,
      p_aeg_trty_type      IN   VARCHAR2,
      p_aeg_acct_intm_cd   IN   VARCHAR2,
      p_ri_cd              IN   VARCHAR2,
      p_branch_cd          IN   VARCHAR2,
      p_fund_cd            IN   VARCHAR2,
      p_tran_id            IN   VARCHAR2,
      p_user_id            IN   VARCHAR2
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
      p_cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      p_cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      p_cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      p_cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      p_cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      p_cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      p_cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      p_cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      p_cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      p_cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE
   );

   PROCEDURE aeg_insert_update_acct_entries (
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
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      p_branch_cd             VARCHAR2,
      p_fund_cd               VARCHAR2,
      p_tran_id               VARCHAR2,
      p_user_id               VARCHAR2
   );

   PROCEDURE aeg_parameters_rev (
      aeg_tran_id          giac_acctrans.tran_id%TYPE,
      aeg_module_nm        giac_modules.module_name%TYPE,
      p_tran_id            VARCHAR2,
      p_line_cd            VARCHAR2,
      p_prem_amt           VARCHAR2,
      p_ri_cd              VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_fund_cd            VARCHAR2,
      p_tax_amt            VARCHAR2,
      p_prev_ri_comm_amt   VARCHAR2,
      p_old_ri_comm_vat    VARCHAR2,
      p_user_id            VARCHAR2
   );

   PROCEDURE generate_icr_entry (
      p_iss_cd             IN       VARCHAR2,
      p_prem_seq_no        IN       VARCHAR2,
      p_fund_cd            IN       VARCHAR2,
      p_branch_cd          IN       VARCHAR2,
      p_user_id            IN       VARCHAR2,
      p_tran_flag          IN       VARCHAR2,
      --,
      p_line_cd            IN       VARCHAR2,
      p_prem_amt           IN       VARCHAR2,
      p_ri_cd              IN       VARCHAR2,
      p_tax_amt            IN       VARCHAR2,
      p_prev_ri_comm_amt   IN       VARCHAR2,
      p_old_ri_comm_vat    IN       VARCHAR2,
      p_rev_tran_id        OUT      VARCHAR2
   );

   PROCEDURE post_commit (
      p_policy_id          IN       VARCHAR2,
      p_item_grp           IN       VARCHAR2,
      p_iss_cd             IN       VARCHAR2,
      p_prem_seq_no        IN       VARCHAR2,
      p_branch_cd          IN       VARCHAR2,
      p_user_id            IN       VARCHAR2,
      p_line_cd            IN       VARCHAR2,
      p_ri_cd              IN       VARCHAR2,
      p_prev_ri_comm_amt   IN       VARCHAR2,
      p_old_ri_comm_vat    IN       VARCHAR2, --removed comment by MarkS SR23053 9.13.2016
      p_rev_tran_id        OUT      VARCHAR2,
      p_sum_ri_comm_vat    IN       VARCHAR2,
      p_new_tran_id        OUT      VARCHAR2,
      p_sum_ri_comm_amt    IN       VARCHAR2,
      p_acct_ent_date      IN       VARCHAR2
   );

   PROCEDURE update_orig_itmperl_inv_tables (
      p_policy_id      IN   VARCHAR2,
      p_item_no        IN   VARCHAR2,
      p_peril_cd       IN   VARCHAR2,
      p_ri_comm_rate   IN   VARCHAR2,
      p_item_grp       IN   VARCHAR2
   );

   PROCEDURE update_giac_table (
      p_policy_id     IN   VARCHAR2,
      p_prem_seq_no   IN   VARCHAR2,
      p_iss_cd        IN   VARCHAR2
   );

   PROCEDURE update_invperl (
      p_policy_id     IN   VARCHAR2,
      p_iss_cd        IN   VARCHAR2,
      p_prem_seq_no   IN   VARCHAR2
   );

   PROCEDURE update_orig_invperl (
      p_policy_id     IN   VARCHAR2,
      p_iss_cd        IN   VARCHAR2,
      p_prem_seq_no   IN   VARCHAR2
   );

   PROCEDURE update_v490 (
      p_co_insurance_sw   IN   VARCHAR2,
      p_policy_id         IN   VARCHAR2,
      p_item_no           IN   VARCHAR2,
      --p_peril_cd          IN   VARCHAR2,
      --p_ri_comm_rate      IN   VARCHAR2,
      p_item_grp          IN   VARCHAR2,
      p_prem_seq_no       IN   VARCHAR2,
      p_iss_cd            IN   VARCHAR2
   );

   PROCEDURE insert_hist (
      p_policy_id          IN   VARCHAR2,
      p_item_no            IN   VARCHAR2,
      p_peril_cd           IN   VARCHAR2,
      p_old_ri_comm_rate   IN   VARCHAR2,
      p_old_ri_comm_amt    IN   VARCHAR2,
      p_ri_comm_rate       IN   VARCHAR2,
      p_ri_comm_amt        IN   VARCHAR2,
      p_user_id            IN   VARCHAR2,
      p_acct_ent_date      IN   VARCHAR2
   );

   PROCEDURE update_gipi_invoice (
      p_policy_id         IN       VARCHAR2,
      p_item_grp          IN       VARCHAR2,
      p_sum_ri_comm_vat   OUT      VARCHAR2,
      p_sum_ri_comm_amt   OUT      VARCHAR2
   );

   PROCEDURE aeg_parameters (
      p_line_cd           IN   VARCHAR2,
      p_prem_amt          IN   VARCHAR2,
      p_tax_amt           IN   VARCHAR2,
      p_ri_comm_amt       IN   VARCHAR2,
      p_sum_ri_comm_vat   IN   VARCHAR2,
      p_tran_id           IN   VARCHAR2,
      p_ri_cd             IN   VARCHAR2,
      p_branch_cd         IN   VARCHAR2,
      p_fund_cd           IN   VARCHAR2,
      p_user_id           IN   VARCHAR2
   );

   PROCEDURE generate_ic_entry (
      p_line_cd           IN       VARCHAR2,
      p_prem_amt          IN       VARCHAR2,
      p_tax_amt           IN       VARCHAR2,
      p_ri_comm_amt       IN       VARCHAR2,
      p_sum_ri_comm_vat   IN       VARCHAR2,
      p_ri_cd             IN       VARCHAR2,
      p_branch_cd         IN       VARCHAR2,
      p_fund_cd           IN       VARCHAR2,
      p_user_id           IN       VARCHAR2,
      p_tran_flag         IN       VARCHAR2,
      p_iss_cd            IN       VARCHAR2,
      p_prem_seq_no       IN       VARCHAR2,
      p_tran_id           OUT      VARCHAR2
   );

   PROCEDURE insert_update_ri_comm_hist (
      p_rev_tran_id        IN   VARCHAR2,
      p_new_tran_id        IN   VARCHAR2,
      p_policy_id          IN   VARCHAR2,
      p_user_id            IN   VARCHAR2,
      p_sum_ri_comm_amt    IN   VARCHAR2,
      p_prev_ri_comm_amt   IN   VARCHAR2,
      p_acct_ent_date      IN   VARCHAR2,
      p_sum_ri_comm_vat    IN   VARCHAR2,
      p_old_ri_comm_vat    IN   VARCHAR2
   );
END;
/
