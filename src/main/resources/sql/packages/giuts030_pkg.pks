CREATE OR REPLACE PACKAGE CPI.giuts030_pkg
AS
   TYPE binder_list_type IS RECORD (
      --added SR5801 11.8.2016 optimized by MarkS
      count_                NUMBER,
      rownum_               NUMBER,
      --added SR5801 11.8.2016 optimized by MarkS
      line_cd          giri_binder.line_cd%TYPE,
      binder_yy        giri_binder.binder_yy%TYPE,
      binder_seq_no    giri_binder.binder_seq_no%TYPE,
      ri_cd            giri_binder.ri_cd%TYPE,
      ri_name          giis_reinsurer.ri_name%TYPE,
      binder_date      giri_binder.binder_date%TYPE,
      reverse_date     giri_binder.reverse_date%TYPE,
      ri_tsi_amt       giri_binder.ri_tsi_amt%TYPE,
      ri_prem_amt      giri_binder.ri_prem_amt%TYPE,
      bndr_stat_cd     giri_binder.bndr_stat_cd%TYPE,
      bndr_stat_desc   giis_binder_status.bndr_stat_desc%TYPE,
      policy_no        VARCHAR2 (100),
      assd_no          giis_assured.assd_no%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      fnl_binder_id    giri_binder.fnl_binder_id%TYPE,
      frps_no          VARCHAR2 (100),
      ref_binder_no    giri_binder.ref_binder_no%TYPE,
      confirm_no       giri_binder.confirm_no%TYPE,
      confirm_date     giri_binder.confirm_date%TYPE,
      release_date     giri_binder.release_date%TYPE,
      released_by      giri_binder.released_by%TYPE,
      replaced_flag    giri_binder.replaced_flag%TYPE
   );
   
   TYPE binder_list_tab IS TABLE OF binder_list_type;
   
   FUNCTION get_binder_list(
      p_module_id VARCHAR2,
      p_user_id   VARCHAR2,
      p_status    VARCHAR2,
      --added by MarkS 11.8.2016 SR5801
      p_order_by              VARCHAR2,
      p_asc_desc_flag       VARCHAR2,
      p_from                  NUMBER,
      p_to                    NUMBER,
      p_line_cd             VARCHAR2,
      p_binder_yy           NUMBER,
      p_binder_seq_no       NUMBER,
      p_ri_name             VARCHAR2,
      p_binder_date         VARCHAR2,
      p_reverse_date        VARCHAR2,
      p_ri_tsi_amt          NUMBER,   
      p_ri_prem_amt         NUMBER,   
      p_bndr_stat_desc      VARCHAR2
      --END
   )  
      RETURN binder_list_tab PIPELINED;
END;
/
