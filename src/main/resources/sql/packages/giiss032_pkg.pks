CREATE OR REPLACE PACKAGE CPI.giiss032_pkg
AS
   TYPE rec_type IS RECORD (
      line_cd             giis_intreaty.line_cd%TYPE,
      trty_seq_no         giis_intreaty.trty_seq_no%TYPE,
      trty_yy             giis_intreaty.trty_yy%TYPE,
      trty_name           giis_intreaty.trty_name%TYPE,
      dsp_ac_type_sname   giis_ca_trty_type.trty_sname%TYPE,
      uw_trty_type        giis_intreaty.uw_trty_type%TYPE,
      eff_date            VARCHAR2 (30),
      expiry_date         VARCHAR2 (30),
      ri_cd               giis_intreaty.ri_cd%TYPE,
      dsp_ri_sname        giis_reinsurer.ri_sname%TYPE,
      ac_trty_type        giis_intreaty.ac_trty_type%TYPE,
      trty_limit          giis_intreaty.trty_limit%TYPE,
      trty_shr_pct        giis_intreaty.trty_shr_pct%TYPE,
      trty_shr_amt        giis_intreaty.trty_shr_amt%TYPE,
      est_prem_inc        giis_intreaty.est_prem_inc%TYPE,
      prtfolio_sw         giis_intreaty.prtfolio_sw%TYPE,
      no_of_lines         giis_intreaty.no_of_lines%TYPE,
      inxs_amt            giis_intreaty.inxs_amt%TYPE,
      exc_loss_rt         giis_intreaty.exc_loss_rt%TYPE,
      ccall_limit         giis_intreaty.ccall_limit%TYPE,
      dep_prem            giis_intreaty.dep_prem%TYPE,
      currency_cd         giis_intreaty.currency_cd%TYPE,
      dsp_currency_name   giis_currency.currency_desc%TYPE,
      remarks             giis_intreaty.remarks%TYPE,
      user_id             giis_intreaty.user_id%TYPE,
      last_update         VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_trty_name     giis_intreaty.trty_name%TYPE,
      p_user_id       giis_intreaty.user_id%TYPE
   )
      RETURN rec_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   TYPE cedant_lov_type IS RECORD (
      ri_sname   giis_reinsurer.ri_sname%TYPE,
      ri_name    giis_reinsurer.ri_name%TYPE,
      ri_cd      giis_reinsurer.ri_cd%TYPE
   );

   TYPE cedant_lov_tab IS TABLE OF cedant_lov_type;

   FUNCTION get_cedant_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN cedant_lov_tab PIPELINED;

   TYPE currency_lov_type IS RECORD (
      short_name         giis_currency.short_name%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      main_currency_cd   giis_currency.main_currency_cd%TYPE
   );

   TYPE currency_lov_tab IS TABLE OF currency_lov_type;

   FUNCTION get_currency_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN currency_lov_tab PIPELINED;

   TYPE acctgtype_lov_type IS RECORD (
      ca_trty_type   giis_ca_trty_type.ca_trty_type%TYPE,
      trty_sname     giis_ca_trty_type.trty_sname%TYPE,
      trty_lname     giis_ca_trty_type.trty_lname%TYPE
   );

   TYPE acctgtype_lov_tab IS TABLE OF acctgtype_lov_type;

   FUNCTION get_acctgtype_lov (
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2,
      p_line_cd   VARCHAR2
   )
      RETURN acctgtype_lov_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_ri_cd         giis_intreaty.ri_cd%TYPE
   );

   PROCEDURE val_delete_rec (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_ri_cd         giis_intreaty.ri_cd%TYPE
   );

   PROCEDURE set_rec (p_rec giis_intreaty%ROWTYPE);

   PROCEDURE del_rec (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_ri_cd         giis_intreaty.ri_cd%TYPE
   );
END;
/


