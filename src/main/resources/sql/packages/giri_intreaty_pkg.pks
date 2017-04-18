CREATE OR REPLACE PACKAGE cpi.giri_intreaty_pkg
AS
   TYPE giri_intreaty_tg_type IS RECORD (
      intreaty_id    giri_intreaty.intreaty_id%TYPE,
      ri_name        giis_reinsurer.ri_name%TYPE,
      intrty_no      VARCHAR2 (25),
      accept_date    VARCHAR2 (25),
      user_id        giri_intreaty.user_id%TYPE,
      last_update    VARCHAR2 (25),
      approve_by     giri_intreaty.approve_by%TYPE,
      approve_date   VARCHAR2 (25)
   );

   TYPE giri_intreaty_tg_tab IS TABLE OF giri_intreaty_tg_type;

   TYPE giris056_line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE giris056_line_lov_tab IS TABLE OF giris056_line_lov_type;

   TYPE giris056_trty_yy_lov_type IS RECORD (
      trty_yy       giis_dist_share.trty_yy%TYPE,
      dsp_trty_yy   NUMBER (4)
   );

   TYPE giris056_trty_yy_lov_tab IS TABLE OF giris056_trty_yy_lov_type;

   TYPE giris056_trty_name_lov_type IS RECORD (
      share_cd    giis_dist_share.share_cd%TYPE,
      trty_name   giis_dist_share.trty_name%TYPE
   );

   TYPE giris056_trty_name_lov_tab IS TABLE OF giris056_trty_name_lov_type;

   TYPE dist_share_type IS RECORD (
      line_name     giis_line.line_name%TYPE,
      dsp_trty_yy   NUMBER (4),
      trty_name     giis_dist_share.trty_name%TYPE,
      trty_term     VARCHAR2 (50)
   );

   TYPE dist_share_tab IS TABLE OF dist_share_type;

   TYPE ri_lov_type IS RECORD (
      ri_cd            giis_reinsurer.ri_cd%TYPE,
      ri_name          giis_reinsurer.ri_name%TYPE,
      trty_shr_pct     VARCHAR2 (25),
      ri_comm_rt       giis_trty_panel.ri_comm_rt%TYPE,
      dsp_ri_comm_rt   VARCHAR2 (25),
      ri_vat_rt        giis_reinsurer.input_vat_rate%TYPE,
      dsp_ri_vat_rt    VARCHAR2 (25)
   );

   TYPE ri_lov_tab IS TABLE OF ri_lov_type;

   TYPE tran_type_list_type IS RECORD (
      tran_type   cg_ref_codes.rv_low_value%TYPE
   );

   TYPE tran_type_list_tab IS TABLE OF tran_type_list_type;

   TYPE giri_intreaty_type IS RECORD (
      intreaty_id           giri_intreaty.intreaty_id%TYPE,
      line_cd               giri_intreaty.line_cd%TYPE,
      trty_yy               giri_intreaty.trty_yy%TYPE,
      intrty_seq_no         giri_intreaty.intrty_seq_no%TYPE,
      ri_cd                 giri_intreaty.ri_cd%TYPE,
      accept_date           giri_intreaty.accept_date%TYPE,
      approve_by            giri_intreaty.approve_by%TYPE,
      approve_date          giri_intreaty.approve_date%TYPE,
      cancel_user           giri_intreaty.cancel_user%TYPE,
      cancel_date           giri_intreaty.cancel_date%TYPE,
      acct_ent_date         giri_intreaty.acct_ent_date%TYPE,
      acct_neg_date         giri_intreaty.acct_neg_date%TYPE,
      booking_mth           giri_intreaty.booking_mth%TYPE,
      booking_yy            giri_intreaty.booking_yy%TYPE,
      tran_type             giri_intreaty.tran_type%TYPE,
      tran_no               giri_intreaty.tran_no%TYPE,
      currency_cd           giri_intreaty.currency_cd%TYPE,
      currency_rt           giri_intreaty.currency_rt%TYPE,
      ri_prem_amt           giri_intreaty.ri_prem_amt%TYPE,
      ri_comm_rt            giri_intreaty.ri_comm_rt%TYPE,
      ri_comm_amt           giri_intreaty.ri_comm_amt%TYPE,
      ri_vat_rt             giri_intreaty.ri_vat_rt%TYPE,
      ri_comm_vat           giri_intreaty.ri_comm_vat%TYPE,
      clm_loss_pd_amt       giri_intreaty.clm_loss_pd_amt%TYPE,
      clm_loss_exp_amt      giri_intreaty.clm_loss_exp_amt%TYPE,
      clm_recoverable_amt   giri_intreaty.clm_recoverable_amt%TYPE,
      charge_amount         giri_intreaty.charge_amount%TYPE,
      intrty_flag           giri_intreaty.intrty_flag%TYPE,
      share_cd              giri_intreaty.share_cd%TYPE
   );

   TYPE giri_intreaty_tab IS TABLE OF giri_intreaty_type;

   TYPE giri_intreaty_charges_type IS RECORD (
      intreaty_id   giri_intreaty_charges.intreaty_id%TYPE,
      charge_cd     giri_intreaty_charges.charge_cd%TYPE,
      amount        giri_intreaty_charges.amount%TYPE,
      dsp_amount    NUMBER (15, 2),
      w_tax         giri_intreaty_charges.w_tax%TYPE
   );

   TYPE giri_intreaty_charges_tab IS TABLE OF giri_intreaty_charges_type;

   TYPE giri_intreaty_charges_tg_type IS RECORD (
      intreaty_id    giri_intreaty_charges.intreaty_id%TYPE,
      charge_cd      giri_intreaty_charges.charge_cd%TYPE,
      tax_name       giac_taxes.tax_name%TYPE,
      amount         giri_intreaty_charges.amount%TYPE,
      dsp_amount     NUMBER (15, 2),
      w_tax          giri_intreaty_charges.w_tax%TYPE
   );

   TYPE giri_intreaty_charges_tg_tab IS TABLE OF giri_intreaty_charges_tg_type;

   TYPE charges_lov_type IS RECORD (
      tax_cd     giac_taxes.tax_cd%TYPE,
      tax_name   giac_taxes.tax_name%TYPE
   );

   TYPE charges_lov_tab IS TABLE OF charges_lov_type;

   TYPE giri_incharges_tax_type IS RECORD (
      intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      tax_type      giri_incharges_tax.tax_type%TYPE,
      tax_cd        giri_incharges_tax.tax_cd%TYPE,
      charge_cd     giri_incharges_tax.charge_cd%TYPE,
      charge_amt    giri_incharges_tax.charge_amt%TYPE,
      sl_type_cd    giri_incharges_tax.sl_type_cd%TYPE,
      sl_cd         giri_incharges_tax.sl_cd%TYPE,
      tax_pct       giri_incharges_tax.tax_pct%TYPE,
      tax_amt       giri_incharges_tax.tax_amt%TYPE
   );

   TYPE giri_incharges_tax_tab IS TABLE OF giri_incharges_tax_type;

   TYPE giri_incharges_tax_tg_type IS RECORD (
      intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      tax_type      giri_incharges_tax.tax_type%TYPE,
      tax_cd        giri_incharges_tax.tax_cd%TYPE,
      tax_name      VARCHAR2 (200),
      sl_type_cd    giri_incharges_tax.sl_type_cd%TYPE,
      sl_cd         giri_incharges_tax.sl_cd%TYPE,
      charge        giac_taxes.tax_name%TYPE,
      charge_cd     giri_incharges_tax.charge_cd%TYPE,
      charge_amt    giri_incharges_tax.charge_amt%TYPE,
      tax_pct       giri_incharges_tax.tax_pct%TYPE,
      tax_amt       giri_incharges_tax.tax_amt%TYPE
   );

   TYPE giri_incharges_tax_tg_tab IS TABLE OF giri_incharges_tax_tg_type;

   TYPE taxes_lov_type IS RECORD (
      tax_type_cd   VARCHAR2 (10),
      tax_cd        NUMBER (5),
      tax_name      VARCHAR2 (200),
      tax_pct       NUMBER (12, 9),
      sl_type_cd    VARCHAR2 (2)
   );

   TYPE taxes_lov_tab IS TABLE OF taxes_lov_type;

   TYPE sl_lov_type IS RECORD (
      sl_cd     giac_sl_lists.sl_cd%TYPE,
      sl_name   giac_sl_lists.sl_name%TYPE
   );

   TYPE sl_lov_tab IS TABLE OF sl_lov_type;

   TYPE giris057_line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE giris057_line_lov_tab IS TABLE OF giris057_line_lov_type;

   TYPE giris057_trty_yy_lov_type IS RECORD (
      trty_yy       giis_dist_share.trty_yy%TYPE,
      dsp_trty_yy   NUMBER (4)
   );

   TYPE giris057_trty_yy_lov_tab IS TABLE OF giris057_trty_yy_lov_type;

   TYPE giris057_intrty_no_lov_type IS RECORD (
      intrty_seq_no   VARCHAR2 (5),
      ri_name         giis_reinsurer.ri_name%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE
   );

   TYPE giris057_intrty_no_lov_tab IS TABLE OF giris057_intrty_no_lov_type;

   TYPE view_intreaty_type IS RECORD (
      intreaty_id           giri_intreaty.intreaty_id%TYPE,
      line_cd               giri_intreaty.line_cd%TYPE,
      trty_yy               giri_intreaty.trty_yy%TYPE,
      intrty_seq_no         VARCHAR2 (5),
      line_name             giis_line.line_name%TYPE,
      dsp_trty_yy           NUMBER (4),
      trty_name             giis_dist_share.trty_name%TYPE,
      trty_term             VARCHAR2 (50),
      ri_name               giis_reinsurer.ri_name%TYPE,
      trty_shr_pct          VARCHAR2 (25),
      accept_date           VARCHAR2 (25),
      period                VARCHAR2 (25),
      booking_month         VARCHAR2 (25),
      approve_by            giri_intreaty.approve_by%TYPE,
      approve_date          VARCHAR2 (25),
      acct_ent_date         VARCHAR2 (25),
      cancel_user           giri_intreaty.cancel_user%TYPE,
      cancel_date           VARCHAR2 (25),
      acct_neg_date         VARCHAR2 (25),
      short_name            giis_currency.short_name%TYPE,
      currency_rt           giri_intreaty.currency_rt%TYPE,
      ri_prem_amt           giri_intreaty.ri_prem_amt%TYPE,
      ri_comm_rt            VARCHAR2 (25),
      ri_comm_amt           giri_intreaty.ri_comm_amt%TYPE,
      ri_vat_rt             VARCHAR2 (25),
      ri_comm_vat           giri_intreaty.ri_comm_vat%TYPE,
      clm_loss_pd_amt       giri_intreaty.clm_loss_pd_amt%TYPE,
      clm_loss_exp_amt      giri_intreaty.clm_loss_exp_amt%TYPE,
      clm_recoverable_amt   giri_intreaty.clm_recoverable_amt%TYPE,
      charge_amount         giri_intreaty.charge_amount%TYPE
   );

   TYPE view_intreaty_tab IS TABLE OF view_intreaty_type;

   FUNCTION get_giri_intreaty_tg (
      p_intrty_flag   giri_intreaty.intrty_flag%TYPE,
      p_line_cd       giri_intreaty.line_cd%TYPE,
      p_trty_yy       giri_intreaty.trty_yy%TYPE,
      p_share_cd      giri_intreaty.share_cd%TYPE
   )
      RETURN giri_intreaty_tg_tab PIPELINED;

   FUNCTION get_giris056_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN giris056_line_lov_tab PIPELINED;

   FUNCTION get_giris056_trty_yy_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN giris056_trty_yy_lov_tab PIPELINED;

   FUNCTION get_giris056_trty_name_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_trty_yy   giis_dist_share.trty_yy%TYPE
   )
      RETURN giris056_trty_name_lov_tab PIPELINED;

   PROCEDURE copy_intreaty (
      p_intreaty_id         giri_intreaty.intreaty_id%TYPE,
      p_intrty_no     OUT   VARCHAR2
   );

   PROCEDURE approve_intreaty (
      p_intreaty_id   giri_intreaty.intreaty_id%TYPE,
      p_user_id       giis_users.user_id%TYPE
   );

   PROCEDURE cancel_intreaty (
      p_intreaty_id   giri_intreaty.intreaty_id%TYPE,
      p_user_id       giis_users.user_id%TYPE
   );

   FUNCTION get_dist_share (
      p_line_cd    giis_dist_share.line_cd%TYPE,
      p_share_cd   giis_dist_share.share_cd%TYPE,
      p_trty_yy    giis_dist_share.trty_yy%TYPE
   )
      RETURN dist_share_tab PIPELINED;

   FUNCTION get_ri_lov (
      p_line_cd    giri_intreaty.line_cd%TYPE,
      p_trty_yy    giri_intreaty.trty_yy%TYPE,
      p_share_cd   giri_intreaty.share_cd%TYPE,
      p_ri_cd      giri_intreaty.ri_cd%TYPE
   )
      RETURN ri_lov_tab PIPELINED;

   FUNCTION get_tran_type_list
      RETURN tran_type_list_tab PIPELINED;

   PROCEDURE get_dflt_booking_date (
      p_accept_date    IN       DATE,
      p_booking_year   OUT      gipi_wpolbas.booking_year%TYPE,
      p_booking_mth    OUT      gipi_wpolbas.booking_mth%TYPE
   );

   FUNCTION get_giri_intreaty (p_intreaty_id giri_intreaty.intreaty_id%TYPE)
      RETURN giri_intreaty_tab PIPELINED;

   FUNCTION get_giri_intreaty_charges (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE
   )
      RETURN giri_intreaty_charges_tab PIPELINED;

   FUNCTION get_giri_intreaty_charges_tg (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE
   )
      RETURN giri_intreaty_charges_tg_tab PIPELINED;

   FUNCTION get_charges_lov
      RETURN charges_lov_tab PIPELINED;

   PROCEDURE save_giri_intreaty (p_giri_intreaty giri_intreaty%ROWTYPE);

   PROCEDURE del_giri_intreaty_charges (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE,
      p_charge_cd     giri_intreaty_charges.charge_cd%TYPE
   );

   PROCEDURE add_giri_intreaty_charges (
      p_giri_intreaty_charges   giri_intreaty_charges%ROWTYPE
   );

   FUNCTION get_giri_incharges_tax (
      p_intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      p_charge_cd     giri_incharges_tax.charge_cd%TYPE
   )
      RETURN giri_incharges_tax_tab PIPELINED;

   FUNCTION get_giri_incharges_tax_tg (
      p_intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      p_charge_cd     giri_incharges_tax.charge_cd%TYPE
   )
      RETURN giri_incharges_tax_tg_tab PIPELINED;

   FUNCTION get_taxes_lov (p_tax_type giri_incharges_tax.tax_type%TYPE)
      RETURN taxes_lov_tab PIPELINED;

   FUNCTION get_sl_lov (p_sl_type_cd giac_sl_lists.sl_type_cd%TYPE)
      RETURN sl_lov_tab PIPELINED;

   PROCEDURE del_giri_incharges_tax (
      p_intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      p_tax_type      giri_incharges_tax.tax_type%TYPE,
      p_tax_cd        giri_incharges_tax.tax_cd%TYPE,
      p_charge_cd     giri_incharges_tax.charge_cd%TYPE
   );

   PROCEDURE add_giri_incharges_tax (
      p_giri_incharges_tax   giri_incharges_tax%ROWTYPE
   );

   PROCEDURE update_intreaty_charges (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE,
      p_charge_cd     giri_intreaty_charges.charge_cd%TYPE
   );
   
   PROCEDURE update_charge_amount (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE
   );

   FUNCTION get_intreaty_id (
      p_line_cd         giri_intreaty.line_cd%TYPE,
      p_trty_yy         giri_intreaty.trty_yy%TYPE,
      p_intrty_seq_no   giri_intreaty.intrty_seq_no%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_giris057_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN giris057_line_lov_tab PIPELINED;

   FUNCTION get_giris057_trty_yy_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN giris057_trty_yy_lov_tab PIPELINED;

   FUNCTION get_giris057_intrty_no_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_trty_yy   giri_intreaty.trty_yy%TYPE
   )
      RETURN giris057_intrty_no_lov_tab PIPELINED;

   FUNCTION get_view_intreaty (p_intreaty_id giri_intreaty.intreaty_id%TYPE)
      RETURN view_intreaty_tab PIPELINED;
END;
/