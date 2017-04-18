CREATE OR REPLACE PACKAGE CPI.gicls275_pkg
AS
   TYPE get_mcreplacementpart_lov_type IS RECORD (
      car_company      giis_mc_car_company.car_company%TYPE,
      car_company_cd   giis_mc_car_company.car_company_cd%TYPE
   );

   TYPE get_mcreplacementpart_lov_tab IS TABLE OF get_mcreplacementpart_lov_type;

   FUNCTION get_mcreplacementpart_lov_list ( -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
      p_search_string VARCHAR2,      
      p_car_make      VARCHAR2, 
      p_model_year    VARCHAR2,
      p_car_part      VARCHAR2      
   ) -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End
      RETURN get_mcreplacementpart_lov_tab PIPELINED;

   TYPE get_mcreplacementmake_lov_type IS RECORD (
      make_cd   giis_mc_make.make_cd%TYPE,
      make      giis_mc_make.make%TYPE
   );

   TYPE get_mcreplacementmake_lov_tab IS TABLE OF get_mcreplacementmake_lov_type;

   FUNCTION get_mcreplacementmake_lov_list (
      p_search_string   VARCHAR2,
      p_car_company     VARCHAR2, -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
      p_model_year      VARCHAR2,
      p_car_part        VARCHAR2 -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End    
   )
      RETURN get_mcreplacementmake_lov_tab PIPELINED;

   TYPE get_mcreplacementyr_lov_type IS RECORD (
      model_year   gicl_motor_car_dtl.model_year%TYPE
   );

   TYPE get_mcreplacementyr_lov_tab IS TABLE OF get_mcreplacementyr_lov_type;

   FUNCTION get_mcreplacementyr_lov_list (
      p_search_string   VARCHAR2,
      p_make            VARCHAR2,
      p_car_company     VARCHAR2, -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
      p_car_part        VARCHAR2 -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End    
   )
      RETURN get_mcreplacementyr_lov_tab PIPELINED;

   TYPE get_replacementparts_lov_type IS RECORD (
      loss_exp_cd     giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE
   );

   TYPE get_replacementparts_lov_tab IS TABLE OF get_replacementparts_lov_type;

   FUNCTION get_replacementparts_lov_list (
      p_search_string   VARCHAR2,
      p_make            VARCHAR2,
      p_car_company     VARCHAR2,
      p_model_year      VARCHAR2
   )
      RETURN get_replacementparts_lov_tab PIPELINED;

   TYPE get_mcreplacement_details_type IS RECORD (
      claim_id          gicl_motor_car_dtl.claim_id%TYPE,
      item_no           VARCHAR2 (10),
      peril_name        giis_peril.peril_name%TYPE,
      class_desc        giis_payee_class.class_desc%TYPE,
      payee_last_name   giis_payees.payee_last_name%TYPE,
      hist_seq_no       gicl_clm_loss_exp.hist_seq_no%TYPE,
      le_stat_desc      gicl_le_stat.le_stat_desc%TYPE,
      dtl_amt           gicl_loss_exp_dtl.dtl_amt%TYPE,
      user_id           gicl_loss_exp_dtl.user_id%TYPE,
      last_update       VARCHAR2(20),
      claim_number      VARCHAR2(50),
      policy_no         VARCHAR2(50),
      assd_name         gicl_claims.assured_name%TYPE,
      clm_stat_desc     giis_clm_stat.clm_stat_desc%TYPE,
      loss_date         gicl_claims.loss_date%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      line_cd           gicl_claims.line_cd%TYPE,
      subline_cd        gicl_claims.subline_cd%TYPE,
      iss_cd            gicl_claims.iss_cd%TYPE,
      issue_yy          gicl_claims.issue_yy%TYPE,
      pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      renew_no          gicl_claims.renew_no%TYPE,
      clm_yy            gicl_claims.clm_yy%TYPE,
      clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      clm_loss_id       gicl_loss_exp_dtl.clm_loss_id%TYPE,
      loss_exp_cd       gicl_loss_exp_dtl.loss_exp_cd%TYPE
   );

   TYPE get_mcreplacement_details_tab IS TABLE OF get_mcreplacement_details_type;

   FUNCTION get_mcreplacement_details (
      p_car_company_cd   NUMBER,
      p_make_cd          NUMBER,
      p_model_year       NUMBER,
      p_loss_exp_cd      VARCHAR2,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by        VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2
   )
      RETURN get_mcreplacement_details_tab PIPELINED;

   TYPE get_loss_details_type IS RECORD (
      ded_amt           gicl_loss_exp_ded_dtl.ded_amt%TYPE,
      ded_base_amt      gicl_loss_exp_ded_dtl.ded_amt%TYPE,
      line_cd           gicl_loss_exp_dtl.line_cd%TYPE,
      loss_exp_cd       gicl_loss_exp_dtl.loss_exp_cd%TYPE,
      dsp_exp_desc      giis_loss_exp.loss_exp_desc%TYPE,
      no_of_units       gicl_loss_exp_dtl.no_of_units%TYPE,
      nbt_base_amt      gicl_loss_exp_dtl.ded_base_amt%TYPE,
      dtl_amt           gicl_loss_exp_dtl.dtl_amt%TYPE,
      nbt_net_amt       gicl_loss_exp_dtl.ded_base_amt%TYPE,
      tot_dtl_amt       NUMBER (16, 2),
      tot_net_amt   NUMBER (16, 2)
   );

   TYPE get_loss_details_tab IS TABLE OF get_loss_details_type;

   FUNCTION get_loss_dtls (
      p_claim_id      VARCHAR2,
      p_clm_loss_id   VARCHAR2,
      p_loss_exp_cd   VARCHAR2
   )
      RETURN get_loss_details_tab PIPELINED;
END;
/


