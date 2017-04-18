CREATE OR REPLACE PACKAGE CPI.giclr207d_pkg
AS
   TYPE giclr207d_type IS RECORD (
      exist             VARCHAR2 (1),
      orig_subline_cd   giis_subline.subline_cd%TYPE,
      line_cd           VARCHAR2 (20),
      subline_cd        VARCHAR2 (20),
      comp_name         VARCHAR2 (300),
      comp_add          VARCHAR2 (500),
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
      item_no           NUMBER (9),
      peril_cd          NUMBER (5),
      os_loss           NUMBER (16, 2),
      orig_os_loss      NUMBER (16, 2),
      ann_tsi_amt       NUMBER (16, 2),
      item_title        gicl_clm_item.item_title%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      intm              VARCHAR2 (1000),
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

   TYPE giclr207d_tab IS TABLE OF giclr207d_type;

   TYPE giclr207d_summary_type IS RECORD (
      share_ri      NUMBER (12, 9),
      ri_loss_amt   NUMBER (16, 2),
      trty_name     giis_dist_share.trty_name%TYPE,
      ri_name       giis_reinsurer.ri_name%TYPE
   );

   TYPE giclr207d_summary_tab IS TABLE OF giclr207d_summary_type;

   FUNCTION get_giclr207d_details (p_tran_id NUMBER)
      RETURN giclr207d_tab PIPELINED;

   FUNCTION cf_intm_ri (
      p_claim_id   gicl_claims.claim_id%TYPE,
      p_peril_cd   gicl_intm_itmperil.peril_cd%TYPE,
      p_item_no    gicl_intm_itmperil.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_summary (
      p_tran_id      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN giclr207d_summary_tab PIPELINED;
END;
/


