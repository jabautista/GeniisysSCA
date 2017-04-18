CREATE OR REPLACE PACKAGE CPI.gicls252_pkg
AS
   TYPE clm_status_type IS RECORD (
      claim_id        VARCHAR2 (50),
      policy_no       VARCHAR2 (50),
      assured_name    gicl_claims.assured_name%TYPE,
      claim_status    VARCHAR (50),
      --close_date      gicl_claims.close_date%TYPE, kenneth L 11.19.2013
      close_date      VARCHAR (50),
      --dsp_loss_date   gicl_claims.dsp_loss_date%TYPE, kenneth L 11.19.2013
      dsp_loss_date      VARCHAR (50),
      --clm_file_date   gicl_claims.clm_file_date%TYPE, kenneth L 11.19.2013
      clm_file_date      VARCHAR (50),
      remarks         gicl_claims.remarks%TYPE,
      --entry_date      gicl_claims.entry_date%TYPE, kenneth L 11.19.2013
      entry_date      VARCHAR (50),
      in_hou_adj      gicl_claims.in_hou_adj%TYPE,
      loss_res_amt    gicl_claims.loss_res_amt%TYPE,
      exp_res_amt     gicl_claims.exp_res_amt%TYPE,
      loss_pd_amt     gicl_claims.loss_pd_amt%TYPE,
      exp_pd_amt      gicl_claims.exp_pd_amt%TYPE,
      line_cd         gicl_claims.line_cd%TYPE,
      subline_cd      gicl_claims.subline_cd%TYPE,
      issue_yy        gicl_claims.issue_yy%TYPE,
      pol_seq_no      gicl_claims.pol_seq_no%TYPE,
      renew_no        gicl_claims.renew_no%TYPE,
      pol_iss_cd      gicl_claims.pol_iss_cd%TYPE,
      clm_yy          gicl_claims.clm_yy%TYPE,
      clm_seq_no      gicl_claims.clm_seq_no%TYPE,
      iss_cd          gicl_claims.iss_cd%TYPE
   );

   TYPE clm_status_tab IS TABLE OF clm_status_type;

   FUNCTION get_clm_status (
      p_user_id         giis_users.user_id%TYPE,
      p_clm_stat_type   giis_clm_stat.clm_stat_type%TYPE,
      p_date_col        VARCHAR,
      p_date_as_of      VARCHAR,
      p_date_from       VARCHAR,
      p_date_to         VARCHAR
   )
      RETURN clm_status_tab PIPELINED;
END;
/


