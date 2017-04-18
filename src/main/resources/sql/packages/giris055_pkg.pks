CREATE OR REPLACE PACKAGE CPI.giris055_pkg
AS
   TYPE giris055_dtls_type IS RECORD (
      --added SR5800 11.8.2016 optimized by MarkS
      count_                NUMBER,
      rownum_               NUMBER,
      --added SR5800 11.8.2016 optimized by MarkS
      fnl_binder_id     giri_binder.fnl_binder_id%TYPE,
      line_cd           giri_binder.line_cd%TYPE,
      binder_yy         giri_binder.binder_yy%TYPE,
      binder_seq_no     giri_binder.binder_seq_no%TYPE,
      binder_no         VARCHAR2 (50),
      dsp_ri_name       giis_reinsurer.ri_name%TYPE,
      binder_date       VARCHAR2 (50),
      reverse_date      VARCHAR2 (50),
      dsp_status        cg_ref_codes.rv_meaning%TYPE,
      nbt_assd_name     giis_assured.assd_name%TYPE,
      nbt_line_cd       gipi_polbasic.line_cd%TYPE,
      nbt_subline_cd    gipi_polbasic.subline_cd%TYPE,
      nbt_iss_cd        gipi_polbasic.iss_cd%TYPE,
      nbt_issue_yy      gipi_polbasic.issue_yy%TYPE,
      nbt_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      nbt_renew_no      gipi_polbasic.renew_no%TYPE,
      nbt_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      nbt_endt_yy       gipi_polbasic.endt_yy%TYPE,
      nbt_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      dist_peril_sw     VARCHAR2 (1)
   );

   TYPE giris055_dtls_tab IS TABLE OF giris055_dtls_type;

   FUNCTION get_giris055_dtls (
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_binder_yy       giri_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_binder.binder_seq_no%TYPE,
      p_binder_date     VARCHAR2,
      p_reverse_date    VARCHAR2,
      --added SR5800 11.8.2016 optimized by MarkS
      p_order_by             VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from                 NUMBER,
      p_to                   NUMBER,
      p_dsp_ri_name     VARCHAR2,
      p_dsp_status      VARCHAR2
      --added SR5800 11.8.2016 optimized by MarkS
   )
      RETURN giris055_dtls_tab PIPELINED;

   TYPE binder_distbyperil_type IS RECORD (
      nbt_peril_name   giis_peril.peril_name%TYPE,
      ri_shr_pct       giri_binder_peril.ri_shr_pct%TYPE,
      ri_tsi_amt       giri_binder_peril.ri_tsi_amt%TYPE,
      ri_prem_amt      giri_binder_peril.ri_prem_amt%TYPE,
      ri_comm_amt      giri_binder_peril.ri_comm_amt%TYPE
   );

   TYPE binder_distbyperil_tab IS TABLE OF binder_distbyperil_type;

   FUNCTION get_distbyperil_dtls (
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   )
      RETURN binder_distbyperil_tab PIPELINED;
END;
/
