CREATE OR REPLACE PACKAGE CPI.giris012_pkg
AS
   TYPE frps_lov_type IS RECORD (
      line_cd       giri_distfrps_v.line_cd%TYPE,
      frps_yy       giri_distfrps_v.frps_yy%TYPE,
      frps_seq_no   giri_distfrps_v.frps_seq_no%TYPE,
      subline_cd    giri_distfrps_v.subline_cd%TYPE,
      iss_cd        giri_distfrps_v.iss_cd%TYPE,
      issue_yy      giri_distfrps_v.issue_yy%TYPE,
      pol_seq_no    giri_distfrps_v.pol_seq_no%TYPE,
      renew_no      giri_distfrps_v.renew_no%TYPE,
      assured       giri_distfrps_v.assured%TYPE,
      eff_date      giri_distfrps_v.eff_date%TYPE,
      expiry_date   giri_distfrps_v.expiry_date%TYPE,
      endt_iss_cd   giri_distfrps_v.endt_iss_cd%TYPE,
      endt_yy       giri_distfrps_v.endt_yy%TYPE,
      endt_seq_no   giri_distfrps_v.endt_seq_no%TYPE
   );
   
   TYPE frps_lov_tab IS TABLE OF frps_lov_type;
   
   FUNCTION get_frps_lov (
      p_line_cd      VARCHAR2,
      p_frps_yy      VARCHAR2,
      p_frps_seq_no  VARCHAR2,
      p_eff_date     VARCHAR2,
      p_expiry_date  VARCHAR2,
      p_subline_cd   VARCHAR2,   
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_endt_iss_cd  VARCHAR2,
      p_endt_yy      VARCHAR2,
      p_endt_seq_no  VARCHAR2,
      p_assured      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN frps_lov_tab PIPELINED;
      
   TYPE main_tg_type IS RECORD (
      binder_no         VARCHAR2(100),
      ri_sname2         giis_reinsurer.ri_sname%TYPE,
      net_due           NUMBER(16, 2),
      net_due_computed  NUMBER(16, 2),
      tot_amt_paid      NUMBER(16, 2),
      disbursement_amt  NUMBER(16, 2),
      balance           NUMBER(16, 2),
      line_cd           giri_frps_ri.line_cd%TYPE,
      frps_yy           giri_frps_ri.frps_yy%TYPE,
      frps_seq_no       giri_frps_ri.frps_seq_no%TYPE,
      fnl_binder_id     giri_frps_ri.fnl_binder_id%TYPE,
      frps_no           VARCHAR2(30),
      ri_sname          giis_reinsurer.ri_sname%TYPE,
      ri_prem_amt       NUMBER(16, 2),
      ri_comm_amt       NUMBER(16, 2),
      prem_tax          NUMBER(16, 2),
      ri_cd             giis_reinsurer.ri_cd%TYPE
   );
   
   TYPE main_tg_tab IS TABLE OF main_tg_type;
   
   FUNCTION populate_main_tg (
      p_line_cd      VARCHAR2,
      p_frps_yy      VARCHAR2,
      p_frps_seq_no  VARCHAR2,
      p_user_id      VARCHAR2   
   )
      RETURN main_tg_tab PIPELINED;
      
   TYPE details_type IS RECORD (
      gacc_tran_id         giac_acctrans.tran_id%TYPE,
      d010_fnl_binder_id   giac_outfacul_prem_payts.d010_fnl_binder_id%TYPE,
      tran_class           giac_acctrans.tran_class%TYPE,   
      ref_no               VARCHAR2(50),
      pay_date             giac_acctrans.tran_date%TYPE,
      disbursement_amt     giac_outfacul_prem_payts.disbursement_amt%TYPE
   );
   
   TYPE details_tab IS TABLE OF details_type;
   
   FUNCTION get_details (
      p_fnl_binder_id   VARCHAR2
   )
      RETURN details_tab PIPELINED;
      
END;
/


