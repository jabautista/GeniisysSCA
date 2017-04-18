CREATE OR REPLACE PACKAGE CPI.populate_giclr028_pla_xol_pkg AS
   TYPE populate_reports_type IS RECORD (
      wrd_pla_no        VARCHAR2 (32767),
      wrd_ri_name       VARCHAR2 (2000),
      wrd_ri_address    VARCHAR2 (200),
      wrd_title         VARCHAR2 (2000),
      wrd_header        VARCHAR2 (2000),
      wrd_begin         VARCHAR2 (500),
      wrd_line          VARCHAR2 (200),
      wrd_treaty_name   VARCHAR2 (200),
      wrd_assured       GICL_CLAIMS.assured_name%TYPE, --VARCHAR2 (100) --marco - 12.07.2012 - modified type
      wrd_policy_no     VARCHAR2 (200),
      wrd_ins_term      VARCHAR2 (200),
      wrd_item_title    VARCHAR2 (200),
      wrd_s             VARCHAR2 (200),
      wrd_s1            VARCHAR2 (200),
      wrd_s2            VARCHAR2 (200),
      wrd_s3            VARCHAR2 (200),
      wrd_s4            VARCHAR2 (200),
      wrd_tsi_amt       NUMBER,
      wrd_trty1         VARCHAR2 (200),
      wrd_trty2         VARCHAR2 (200),
      wrd_dist_amt      VARCHAR2 (200),
      wrd_dist_amt2     VARCHAR2 (200),
      wrd_loss_date     VARCHAR2 (200),
      wrd_loss_cat      VARCHAR2 (200),
      wrd_loss_loc      VARCHAR2 (200),
      wrd_los_amt       NUMBER                         := 0,
      wrd_exp_amt       NUMBER                         := 0,
      wrd_total_amt     NUMBER                         := 0,
      wrd_lebel6        VARCHAR2 (200),
      wrd_label7        VARCHAR2 (200),
      wrd_pct           VARCHAR2 (200),
      wrd_xol_desc      VARCHAR2 (200),
      wrd_xol_amt       VARCHAR2 (200),
      wrd_share_amt     NUMBER,
      wrd_signatory     VARCHAR2 (200),
      wrd_footer        VARCHAR2 (200),
      c1                VARCHAR2 (10),
      c2                VARCHAR2 (10),
      c3                VARCHAR2 (10),
      pla_id            gicl_advs_pla.pla_id%TYPE,
      currency_cd       gicl_advice.currency_cd%TYPE,
      wrd_date          VARCHAR2 (50),
      res_pla_id gicl_advs_pla.res_pla_id%TYPE,
      line_cd             gicl_claims.line_cd%TYPE,
      signatories       VARCHAR2(5000)                                      
   );

   TYPE populate_reports_tab IS TABLE OF populate_reports_type;

   TYPE pla_xol_type IS RECORD (
      share_type     gicl_loss_exp_ds.share_type%TYPE,
      stype          VARCHAR2 (50),
      wrd_xol_amt    NUMBER,
      wrd_xol_desc   giis_dist_share.trty_name%TYPE,
      wrd_s3         VARCHAR2 (50)
   );

   TYPE pla_xol_tab IS TABLE OF pla_xol_type;

   TYPE pla_xol_dist2_type IS RECORD (
      wrd_trty2       VARCHAR2 (2000),
      wrd_s2          VARCHAR2 (10),
      wrd_dist_amt2   VARCHAR2 (200)
   );

   TYPE pla_xol_dist2_tab IS TABLE OF pla_xol_dist2_type;
   
   TYPE pla_xol_dist_type IS RECORD (
      wrd_trty1       VARCHAR2 (2000),
      wrd_s1          VARCHAR2 (10),
      wrd_dist_amt1   VARCHAR2 (200)
   );

   TYPE pla_xol_dist_tab IS TABLE OF pla_xol_dist_type;

   FUNCTION populate_giclr028_pla_xol_ucpb (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_grp_seq_no   gicl_advs_fla.grp_seq_no%TYPE
   )
      RETURN populate_reports_tab PIPELINED;

   FUNCTION get_pla_xol_rec (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE
   )
      RETURN pla_xol_tab PIPELINED;

   FUNCTION get_pla_xol_dist (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_curr_sname   giis_currency.short_name%TYPE,
      p_pla_id        gicl_advs_pla.pla_id%TYPE,
      p_res_pla_id    gicl_reserve_rids.res_pla_id%TYPE
   )
      RETURN pla_xol_dist_tab PIPELINED;

   FUNCTION get_pla_xol_dist2 (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_curr_sname    giis_currency.short_name%TYPE
   )
      RETURN pla_xol_dist2_tab PIPELINED;      
         
END populate_giclr028_pla_xol_pkg;
/


