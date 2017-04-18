CREATE OR REPLACE PACKAGE CPI.giclr207l_pkg
AS
   TYPE giclr207l_type IS RECORD (
      exist             VARCHAR2 (1),
      orig_subline_cd   giis_subline.subline_cd%TYPE,
      line_cd           VARCHAR2 (20),
      subline_cd        VARCHAR2 (20),
      company_name      VARCHAR2 (300),
      company_add       VARCHAR2 (500),
      rep_title         giis_reports.report_title%TYPE,
      line_name         giis_line.line_name%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      as_of_date        VARCHAR2 (100),
      claim_id          gicl_claims.claim_id%TYPE,
      assured_name      VARCHAR2 (500),
      policy_no         VARCHAR2 (300),
      claim_no          VARCHAR2 (300),
      pol_eff_date      DATE,
      loss_date         DATE,
      clm_file_date     DATE,
      expiry_date       DATE,
      os_loss           NUMBER (16, 2),
      orig_os_loss      NUMBER (16, 2),
      col_header1       VARCHAR2 (50),
      col_header2       VARCHAR2 (50),
      col_header3       VARCHAR2 (50),
      col_header4       VARCHAR2 (50),
      sum_col_header1   NUMBER (16, 2),
      sum_col_header2   NUMBER (16, 2),
      sum_col_header3   NUMBER (16, 2),
      sum_col_header4   NUMBER (16, 2),
      ri_cd1            VARCHAR2 (50),
      ri_cd2            VARCHAR2 (50),
      ri_cd3            VARCHAR2 (50),
      ri_cd4            VARCHAR2 (50),
      sum_ri_cd1        NUMBER (16, 2),
      sum_ri_cd2        NUMBER (16, 2),
      sum_ri_cd3        NUMBER (16, 2),
      sum_ri_cd4        NUMBER (16, 2),
      ri_cd_header1     VARCHAR2 (50),
      ri_cd_header2     VARCHAR2 (50),
      ri_cd_header3     VARCHAR2 (50),
      ri_cd_header4     VARCHAR2 (50)
   );

   TYPE giclr207l_tab IS TABLE OF giclr207l_type;

   TYPE giclr207_item_type IS RECORD (
      claim_id      gicl_claims.claim_id%TYPE,
      item_no       gicl_take_up_hist.item_no%TYPE,
      ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
      item_title    gicl_clm_item.item_title%TYPE
   );

   TYPE giclr207_item_tab IS TABLE OF giclr207_item_type;

   TYPE giclr207_peril_type IS RECORD (
      claim_id     gicl_claims.claim_id%TYPE,
      item_no      gicl_take_up_hist.item_no%TYPE,
      peril_cd     gicl_take_up_hist.peril_cd%TYPE,
      os_loss      gicl_take_up_hist.os_expense%TYPE,
      peril_name   giis_peril.peril_name%TYPE,
      intm         VARCHAR2 (300)
   );

   TYPE giclr207_peril_tab IS TABLE OF giclr207_peril_type;

   TYPE giclr207l_summary_type IS RECORD (
      share_ri        giis_trty_panel.trty_shr_pct%TYPE,
      grp_seq_no      gicl_reserve_rids_xtr.grp_seq_no%TYPE,
      rids_loss_amt   NUMBER (18, 2),
      trty_name       giis_dist_share.trty_name%TYPE,
      ri_sname        giis_reinsurer.ri_sname%TYPE
   );

   TYPE giclr207l_summary_tab IS TABLE OF giclr207l_summary_type;

   FUNCTION get_giclr207l_details (p_tran_id NUMBER)
      RETURN giclr207l_tab PIPELINED;

   FUNCTION get_giclr207l_item (
      p_tran_id    NUMBER,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN giclr207_item_tab PIPELINED;

   FUNCTION get_giclr207l_peril (
      p_tran_id    NUMBER,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN giclr207_peril_tab PIPELINED;

   FUNCTION cf_intm_ri (
      p_claim_id   gicl_claims.claim_id%TYPE,
      p_peril_cd   gicl_take_up_hist.peril_cd%TYPE,
      p_item_no    gicl_take_up_hist.peril_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_giclr207l_summary (
      p_tran_id      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN giclr207l_summary_tab PIPELINED;
END;
/


