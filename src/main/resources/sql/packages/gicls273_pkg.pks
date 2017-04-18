CREATE OR REPLACE PACKAGE CPI.gicls273_pkg
AS
   TYPE rec_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      claim_no          VARCHAR2(50),
      line_cd           gicl_claims.line_cd%TYPE,
      subline_cd        gicl_claims.subline_cd%TYPE,
      iss_cd            gicl_claims.iss_cd%TYPE,
      clm_yy            gicl_claims.clm_yy%TYPE,
      clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      clm_stat_desc     giis_clm_stat.clm_stat_desc%TYPE,
      assd_no           gicl_claims.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      loss_pd_amt       gicl_claims.loss_pd_amt%TYPE,
      loss_res_amt      gicl_claims.loss_res_amt%TYPE,
      exp_pd_amt        gicl_claims.exp_pd_amt%TYPE,
      exp_res_amt       gicl_claims.exp_res_amt%TYPE,
      tot_loss_pd       gicl_claims.loss_pd_amt%TYPE,
      tot_loss_res      gicl_claims.loss_res_amt%TYPE,
      tot_exp_pd        gicl_claims.exp_pd_amt%TYPE,
      tot_exp_res       gicl_claims.exp_res_amt%TYPE,
      clm_file_date     VARCHAR2(50),
      loss_date         VARCHAR2(50),
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      issue_yy          gicl_claims.issue_yy%TYPE,
      pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      renew_no          gicl_claims.renew_no%TYPE,
      policy_no         VARCHAR2(50),
      loss_cat_cd       gicl_claims.loss_cat_cd%TYPE
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   TYPE sub_rec_type IS RECORD (
      claim_no          VARCHAR2(50),
      policy_no         VARCHAR2(50),
      loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE,
      loss_date         VARCHAR2(50),
      item_no           gicl_clm_loss_exp.item_no%TYPE,
      item_title        gicl_clm_item.item_title%TYPE,
      peril_cd          gicl_clm_loss_exp.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      hist_seq_no       gicl_clm_loss_exp.hist_seq_no%TYPE,
      class_desc        giis_payee_class.class_desc%TYPE,
      payee_name        VARCHAR2(1000),
      assd_name         giis_assured.assd_name%TYPE,
      net_amt           gicl_clm_loss_exp.net_amt%TYPE,
      paid_amt          gicl_clm_loss_exp.paid_amt%TYPE,
      advise_amt        gicl_clm_loss_exp.advise_amt%TYPE,
      ex_gratia_sw      gicl_clm_loss_exp.ex_gratia_sw%TYPE
   ); 

   TYPE sub_rec_tab IS TABLE OF sub_rec_type;
   
   FUNCTION get_rec_list (
      p_search_by       VARCHAR2,
      p_as_of_date      VARCHAR2,    
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN rec_tab PIPELINED;
      
   FUNCTION get_sub_rec_list (
      p_search_by       VARCHAR2,
      p_as_of_date      VARCHAR2,    
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_user_id         VARCHAR2,
      p_claim_id        gicl_claims.claim_id%TYPE
   )
      RETURN sub_rec_tab PIPELINED;      
   
END;
/


