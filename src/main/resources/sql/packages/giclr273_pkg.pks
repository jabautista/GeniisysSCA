CREATE OR REPLACE PACKAGE CPI.giclr273_pkg
AS
   TYPE rec_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      date_type         VARCHAR2(200),
      claim_no          VARCHAR2(50),
      policy_no         VARCHAR2(50),
      assd_name         giis_assured.assd_name%TYPE,
      clm_stat_cd       VARCHAR2(50),
      loss_res_amt      gicl_claims.loss_res_amt%TYPE,
      exp_res_amt       gicl_claims.exp_res_amt%TYPE,
      loss_pd_amt       gicl_claims.loss_pd_amt%TYPE,
      exp_pd_amt        gicl_claims.exp_pd_amt%TYPE,
      ex_gratia_payt    gicl_claims.exp_res_amt%TYPE,
      tot_loss_pd       gicl_claims.loss_pd_amt%TYPE,
      tot_loss_res      gicl_claims.loss_res_amt%TYPE,
      tot_exp_pd        gicl_claims.exp_pd_amt%TYPE,
      tot_exp_res       gicl_claims.exp_res_amt%TYPE,
      tot_ex_gratia     gicl_claims.exp_res_amt%TYPE,
      v_print           VARCHAR2(8)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   FUNCTION get_rec_list (
      p_as_of_date      VARCHAR2,    
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_ldate     VARCHAR2,    
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN rec_tab PIPELINED;
    
END;
/


