CREATE OR REPLACE PACKAGE CPI.giclr051a_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 07.29.2013
** Reference By : giclr051a
** Description  : List of FLA's for printing */

   TYPE giclr051a_record_type IS RECORD (
      line              VARCHAR2 (20),
      claim_id          gicl_claims.claim_id%TYPE,
      claim_number      VARCHAR2 (50),
      policy_number     VARCHAR2 (50),
      assured_name      gicl_claims.assured_name%TYPE,
      advice_no         VARCHAR2 (50),
      trty_name         giis_dist_share.trty_name%TYPE,
      fla_no            VARCHAR2 (50),
      ri_cd             gicl_advs_fla.ri_cd%TYPE,
      la_yy             gicl_advs_fla.la_yy%TYPE,
      fla_seq_no        gicl_advs_fla.fla_seq_no%TYPE,
      in_hou_adj        gicl_claims.in_hou_adj%TYPE,
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      p_line_cd         VARCHAR2 (40),
      p_user_id         VARCHAR2 (40),
      company_add       VARCHAR2 (500),
      company_name      VARCHAR2 (500),
      cf_paid_shr_amt   NUMBER (18, 2),
      cf_net_shr_amt    NUMBER (18, 2),
      cf_adv_shr_amt    NUMBER (18, 2),
      p_claim_id        NUMBER (12),
      p_la_yy           NUMBER (2),
      cf_status         VARCHAR2 (50),
      cf_reinsurer      VARCHAR2 (500),
      pjsname           VARCHAR2 (1)
   );

   TYPE giclr051a_record_tab IS TABLE OF giclr051a_record_type;

   FUNCTION get_giclr051a_record (
        p_line_cd VARCHAR2, 
        p_user_id VARCHAR2,
        p_all_users VARCHAR2
   )
      RETURN giclr051a_record_tab PIPELINED;
END;
/


