CREATE OR REPLACE PACKAGE CPI.gicls171_pkg
AS
   TYPE rec_type IS RECORD (
      loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc     giis_loss_exp.loss_exp_desc%TYPE,
      remarks           gicl_mc_lps.remarks%TYPE,
      user_id           gicl_mc_lps.user_id%TYPE,
      last_update       VARCHAR2 (30),
      tinsmith_light    gicl_mc_lps.tinsmith_light%TYPE,
      tinsmith_medium   gicl_mc_lps.tinsmith_medium%TYPE,
      tinsmith_heavy    gicl_mc_lps.tinsmith_heavy%TYPE,
      painting          gicl_mc_lps.painting%TYPE,
      hist_tag          VARCHAR2 (1)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
      p_loss_exp_desc     giis_loss_exp.loss_exp_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE save_rec (p_rec gicl_mc_lps%ROWTYPE);

   TYPE lps_hist_type IS RECORD (
      history_id        gicl_mc_lps_hist.history_id%TYPE,
      loss_exp_cd       gicl_mc_lps_hist.loss_exp_cd%TYPE,
      remarks           gicl_mc_lps_hist.remarks%TYPE,
      user_id           gicl_mc_lps_hist.user_id%TYPE,
      last_update       VARCHAR2 (30),
      tinsmith_light    gicl_mc_lps_hist.tinsmith_light%TYPE,
      tinsmith_medium   gicl_mc_lps_hist.tinsmith_medium%TYPE,
      tinsmith_heavy    gicl_mc_lps_hist.tinsmith_heavy%TYPE,
      painting          gicl_mc_lps_hist.painting%TYPE
   );

   TYPE lps_hist_tab IS TABLE OF lps_hist_type;

   FUNCTION get_lps_hist (p_loss_exp_cd VARCHAR2)
      RETURN lps_hist_tab PIPELINED;
END;
/


