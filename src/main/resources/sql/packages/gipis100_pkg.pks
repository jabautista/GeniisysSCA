CREATE OR REPLACE PACKAGE CPI.gipis100_pkg
AS
   TYPE pol_type IS RECORD (
      count_           NUMBER,
      rownum_          NUMBER,
      policy_id        gipi_polbasic.policy_id%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      expiry_date      VARCHAR2 (10),
      assd_no          gipi_polbasic.assd_no%TYPE,
      cred_branch      gipi_polbasic.cred_branch%TYPE,
      issue_date       VARCHAR2 (10),
      incept_date      VARCHAR2 (10),
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      mean_pol_flag    VARCHAR (50),
      nbt_line_cd      gipi_parlist.line_cd%TYPE,
      nbt_iss_cd       gipi_parlist.iss_cd%TYPE,
      par_yy           gipi_parlist.par_yy%TYPE,
      par_seq_no       gipi_parlist.par_seq_no%TYPE,
      quote_seq_no     gipi_parlist.quote_seq_no%TYPE,
      line_cd_rn       giex_rn_no.line_cd%TYPE,
      iss_cd_rn        giex_rn_no.iss_cd%TYPE,
      rn_yy            giex_rn_no.rn_yy%TYPE,
      rn_seq_no        giex_rn_no.rn_seq_no%TYPE,
      assd_name        VARCHAR (505),
      pack_pol_no      VARCHAR (50),
      pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE,
      iss_name         giis_issource.iss_name%TYPE
   );

   TYPE pol_tab IS TABLE OF pol_type;

   FUNCTION get_query_policy_list (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no      gipi_polbasic.ref_pol_no%TYPE,
      p_nbt_line_cd     gipi_polbasic.line_cd%TYPE,
      p_nbt_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_par_yy          gipi_parlist.par_yy%TYPE,
      p_par_seq_no      gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no    gipi_parlist.quote_seq_no%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN pol_tab PIPELINED;

   TYPE gipi_polinfo_type IS RECORD (
      count_           NUMBER,
      rownum_          NUMBER,
      policy_id        gipi_polbasic.policy_id%TYPE,
      endorsement_no   VARCHAR (50),
      endt_type        gipi_polbasic.endt_type%TYPE,
      eff_date         gipi_polbasic.eff_date%TYPE,
      issue_date       gipi_polbasic.issue_date%TYPE,
      acct_ent_date    gipi_polbasic.acct_ent_date%TYPE,
      par_no           VARCHAR (50),
      quote_seq_no     gipi_parlist.quote_seq_no%TYPE,
      ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      prem_amt         gipi_polbasic.prem_amt%TYPE,
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      spld_flag        gipi_polbasic.spld_flag%TYPE,
      mean_pol_flag    VARCHAR (50),
      reinstate_tag    gipi_polbasic.reinstate_tag%TYPE
   );

   TYPE gipi_polinfo_tab IS TABLE OF gipi_polinfo_type;

   FUNCTION get_gipi_related_polinfo (
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_subline_cd       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         gipi_polbasic.renew_no%TYPE,
      p_endorsement_no   VARCHAR2,
      p_par_no           VARCHAR2,
      p_eff_date         VARCHAR2,
      p_issue_date       VARCHAR2,
      p_acct_ent_date    VARCHAR2,
      p_ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      p_status           VARCHAR,
      p_order_by         VARCHAR2,
      p_asc_desc_flag    VARCHAR2,
      p_from             NUMBER,
      p_to               NUMBER
   )
      RETURN gipi_polinfo_tab PIPELINED;

   TYPE motor_cars_type IS RECORD (
      count_           NUMBER,
      rownum_          NUMBER,
      coc_serial_no    gipi_vehicle.coc_serial_no%TYPE,
      model_year       gipi_vehicle.model_year%TYPE,
      serial_no        gipi_vehicle.serial_no%TYPE,
      policy_id        gipi_vehicle.policy_id%TYPE,
      motor_no         gipi_vehicle.motor_no%TYPE,
      plate_no         gipi_vehicle.plate_no%TYPE,
      coc_type         gipi_vehicle.coc_type%TYPE,
      item_no          gipi_vehicle.item_no%TYPE,
      coc_yy           gipi_vehicle.coc_yy%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      policy_no        VARCHAR2 (50),
      status           VARCHAR2 (50),
      has_attachment   VARCHAR2 (1)
   );

   TYPE motor_cars_tab IS TABLE OF motor_cars_type;

   FUNCTION get_motor_cars (
      p_item_no         gipi_vehicle.item_no%TYPE,
      p_motor_no        gipi_vehicle.motor_no%TYPE,
      p_plate_no        gipi_vehicle.plate_no%TYPE,
      p_serial_no       gipi_vehicle.serial_no%TYPE,
      p_model_year      gipi_vehicle.model_year%TYPE,
      p_coc_type        gipi_vehicle.coc_type%TYPE,
      p_coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      p_coc_yy          gipi_vehicle.coc_yy%TYPE,
      p_policy_no       VARCHAR2,
      p_pol_flag        gipi_polbasic.pol_flag%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN motor_cars_tab PIPELINED;
END gipis100_pkg;
/


