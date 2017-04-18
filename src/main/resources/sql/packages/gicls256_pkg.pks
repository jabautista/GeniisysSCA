CREATE OR REPLACE PACKAGE CPI.gicls256_pkg
AS

   TYPE gicls256_details_type IS RECORD (
      line_name             VARCHAR2 (100),
      loss_cat_des          giis_loss_ctgry.loss_cat_des%TYPE,
      claim_number          VARCHAR2 (100),
      policy_number         VARCHAR2 (100),
      assured_name          gicl_claims.assd_name2%TYPE,
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      clm_file_date         DATE,
      item                  VARCHAR (100),
      peril_name            giis_peril.peril_name%TYPE,
      loss_reserve          gicl_clm_reserve.loss_reserve%TYPE,
      exp_reserve           gicl_clm_reserve.expense_reserve%TYPE,
      loss_paid             gicl_clm_reserve.losses_paid%TYPE,
      exp_paid              gicl_clm_reserve.expenses_paid%TYPE,
      item_no               VARCHAR2(6),
      tot_loss_reserve      gicl_clm_reserve.loss_reserve%TYPE,
      tot_exp_reserve       gicl_clm_reserve.expense_reserve%TYPE,
      tot_loss_paid         gicl_clm_reserve.losses_paid%TYPE,
      tot_exp_paid          gicl_clm_reserve.expenses_paid%TYPE,
      clm_stat_desc         giis_clm_stat.clm_stat_desc%TYPE
   );

   TYPE gicls256_details_tab IS TABLE OF gicls256_details_type;
   
   TYPE loss_cat_det_type IS RECORD (
      loss_cat_cd           giis_loss_ctgry.loss_cat_cd%TYPE,
      loss_cat_desc         giis_loss_ctgry.loss_cat_des%TYPE
   );
   
   TYPE loss_cat_det_tab IS TABLE OF loss_cat_det_type;
   
   TYPE line_cd_list_type IS RECORD (
      line_cd           giis_loss_ctgry.line_cd%TYPE
   );
   
   TYPE line_cd_list_tab IS TABLE OF line_cd_list_type;

   FUNCTION populate_gicls256_details (
      p_line_cd       giis_line.line_cd%TYPE,
      p_loss_cat      giis_loss_ctgry.loss_cat_cd%TYPE,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_date    VARCHAR2,
      p_search_by     VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN gicls256_details_tab PIPELINED;
      
   FUNCTION validate_line_per_linename(
      p_line_name     GIIS_LINE.line_name%TYPE
   )
      RETURN VARCHAR2;
      
   FUNCTION validate_loss_cat_desc(
      p_line_cd       giis_line.line_cd%TYPE,
      p_loss_cat_des  giis_loss_ctgry.loss_cat_des%TYPE
   )
      RETURN VARCHAR2;
      
   FUNCTION fetch_valid_loss_cat(
      p_line_cd       giis_line.line_cd%TYPE
   )
      RETURN loss_cat_det_tab PIPELINED;
      
   FUNCTION fetch_valid_lines(
      p_module_id         VARCHAR2
   )
      RETURN line_cd_list_tab PIPELINED;
   
   PROCEDURE populate_gicls256_totals (
      p_line_cd               IN     giis_line.line_cd%TYPE,
      p_loss_cat              IN     giis_loss_ctgry.loss_cat_cd%TYPE,
      p_from_date             IN     VARCHAR2,
      p_to_date               IN     VARCHAR2,
      p_as_of_date            IN     VARCHAR2,
      p_search_by             IN     VARCHAR2,
      p_user                  IN     VARCHAR2,
      tot_loss_reserve           OUT NUMBER,
      tot_exp_reserve            OUT NUMBER,
      tot_loss_paid              OUT NUMBER,
      tot_exp_paid               OUT NUMBER
    );
      
END gicls256_pkg;
/


