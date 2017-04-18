CREATE OR REPLACE PACKAGE CPI.giuts012_pkg
AS
   /*
   ** Created by : J. Diago
   ** Date Created : 08.15.2013
   ** Referenced by : GIUTS012 - Update Binder Status
   */
   TYPE giuts012_dtls_type IS RECORD (
      fnl_binder_id        giri_binder.fnl_binder_id%TYPE,
      binder_no            VARCHAR2 (50),
      policy_no            VARCHAR2 (100),
      line_cd              giri_binder.line_cd%TYPE,
      binder_yy            giri_binder.binder_yy%TYPE,
      binder_seq_no        giri_binder.binder_seq_no%TYPE,
      dsp_binder_seq_no    VARCHAR2 (10),
      binder_date          giri_binder.binder_date%TYPE,
      ri_cd                giri_binder.ri_cd%TYPE,
      dsp_ri_sname         giis_reinsurer.ri_sname%TYPE,
      ri_shr_pct           giri_binder.ri_shr_pct%TYPE,
      ri_tsi_amt           giri_binder.ri_tsi_amt%TYPE,
      ri_prem_amt          giri_binder.ri_prem_amt%TYPE,
      dsp_eff_date         gipi_polbasic.eff_date%TYPE,
      dsp_expiry_date      gipi_polbasic.expiry_date%TYPE,
      confirm_no           giri_binder.confirm_no%TYPE,
      confirm_date         giri_binder.confirm_date%TYPE,
      released_by          giri_binder.released_by%TYPE,
      release_date         giri_binder.release_date%TYPE,
      bndr_stat_cd         giri_binder.bndr_stat_cd%TYPE,
      nbt_bndr_stat_desc   giis_binder_status.bndr_stat_desc%TYPE,
      dsp_line_cd          gipi_polbasic.line_cd%TYPE,
      dsp_subline_cd       gipi_polbasic.subline_cd%TYPE,
      dsp_iss_cd           gipi_polbasic.iss_cd%TYPE,
      dsp_issue_yy         gipi_polbasic.issue_yy%TYPE,
      dsp_pol_seq_no       VARCHAR2 (10),
      dsp_renew_no         gipi_polbasic.renew_no%TYPE,
      dsp_endt_iss_cd      gipi_polbasic.endt_iss_cd%TYPE,
      dsp_endt_yy          gipi_polbasic.endt_yy%TYPE,
      dsp_endt_seq_no      VARCHAR2 (10),
      dsp_assd_name        giis_assured.assd_name%TYPE,
      dsp_frps_line_cd     giri_frps_ri.line_cd%TYPE,
      dsp_frps_yy          giri_frps_ri.frps_yy%TYPE,
      dsp_frps_seq_no      VARCHAR2 (10),
      dsp_ri_accept_by     giri_frps_ri.ri_accept_by%TYPE,
      dsp_ri_as_no         giri_frps_ri.ri_as_no%TYPE,
      dsp_ri_accept_date   giri_frps_ri.ri_accept_date%TYPE
   );

   TYPE giuts012_dtls_tab IS TABLE OF giuts012_dtls_type;

   TYPE giuts012_binder_stat_type IS RECORD (
      bndr_stat_cd     giis_binder_status.bndr_stat_cd%TYPE,
      bndr_stat_desc   giis_binder_status.bndr_stat_desc%TYPE
   );

   TYPE giuts012_binder_stat_tab IS TABLE OF giuts012_binder_stat_type;

   FUNCTION get_giuts012_dtls (
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_binder_yy       giri_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_binder.binder_seq_no%TYPE,
      p_ri_cd           giri_binder.ri_cd%TYPE
   )
      RETURN giuts012_dtls_tab PIPELINED;

   FUNCTION get_status_lov
      RETURN giuts012_binder_stat_tab PIPELINED;

   PROCEDURE update_binder_status (
      p_user_id         IN       giis_users.user_id%TYPE,
      p_confirm_no      IN       giri_binder.confirm_no%TYPE,
      p_confirm_date    IN       giri_binder.confirm_date%TYPE,
      p_released_by     IN       giri_binder.released_by%TYPE,
      p_release_date    IN       giri_binder.release_date%TYPE,
      p_fnl_binder_id   IN       giri_binder.fnl_binder_id%TYPE,
      p_status          IN       giis_binder_status.bndr_stat_desc%TYPE,
      p_bndr_status     OUT      giis_binder_status.bndr_stat_desc%TYPE
   );
END;
/


