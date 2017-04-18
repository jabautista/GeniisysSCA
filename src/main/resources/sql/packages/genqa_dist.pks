CREATE OR REPLACE PACKAGE CPI.genqa_dist
AS
/* ===================================================================================================================================
**  Variable Declarations
** ==================================================================================================================================*/
   v_result_passed   VARCHAR2 (15) := 'PASSED';
   v_result_failed   VARCHAR2 (15) := 'FAILED';

/* ===================================================================================================================================
**  Main Process Procedures
** ==================================================================================================================================*/
   PROCEDURE validate_distribution_rec (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_module_id       IN   giis_modules.module_id%TYPE,
      p_action          IN   VARCHAR2,
      p_spec_dist_sw    IN   VARCHAR2,
      p_spec_tsi_prem   IN   VARCHAR2,
      p_user            IN   giis_users.user_id%TYPE
   );

   PROCEDURE validate_parameters (
      p_dist_no         IN       giuw_pol_dist.dist_no%TYPE,
      p_module_id       IN       giis_modules.module_id%TYPE,
      p_action          IN       VARCHAR2,
      p_spec_dist_sw    IN       VARCHAR2,
      p_spec_tsi_prem   IN       VARCHAR2,
      p_user            IN       giis_users.user_id%TYPE,
      p_err             OUT      BOOLEAN,
      p_err_msge        OUT      VARCHAR2
   );

   PROCEDURE identify_disttype (
      p_module_id          IN       giis_modules.module_id%TYPE,
      p_spec_dist_sw       IN       VARCHAR2,
      p_spec_tsi_prem      IN       VARCHAR2,
      p_dist_type          OUT      VARCHAR2,
      p_distmod_type       OUT      VARCHAR2,
      p_dist_by_tsi_prem   OUT      VARCHAR2
   );

   PROCEDURE validate_save_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE validate_post_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_log_result (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2,
      p_findings              IN   VARCHAR2,
      p_query_fnc             IN   VARCHAR2,
      p_program_unit          IN   VARCHAR2,
      p_result                IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation  - Zero Share Percentage - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_btsp_zerospct_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_btsp_zerospct_f_itmpldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_btsp_zerospct_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_btsp_zerospct_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Check Existence of Records in Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_exists_witemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_witemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_witemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_witemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_wperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_wperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_wpolicyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_wpolicyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Check Existence of Records in Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_exists_f_itemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_itemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_itemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_itemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_perilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_perilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_policyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_f_policyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_wfrps01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_exists_wfrps02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Checking of the existence of Not Null and Null DIST_SPCT1 in Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_ntnll_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_ntnll_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_ntnll_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_ntnll_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Checking of the existence of Not Null and Null DIST_SPCT1 in Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_ntnll_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_ntnll_spct1_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_ntnll_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_ntnll_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_f_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_chk_null_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparing TSI/Premium from ITMPERIL - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_compt_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_compt_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_compt_wtemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparing TSI/Premium from ITMPERIL - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_compt_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_compt_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_compt_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Checking if there are share % whose decimal places is greater than nine (9) - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_dtl_rndoff9_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_dtl_rndoff9_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_dtl_rndoff9_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_dtl_rndoff9_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Checking if there are share % whose decimal places is greater than nine (9) - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_dtl_rndoff9_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_dtl_rndoff9_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_dtl_rndoff9_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_dtl_rndoff9_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparison of Amounts between Distribution Tables - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_witemds_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_witmprlds_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_witmprldtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_witmprldtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wperilds_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wpolds_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wpoldsdtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wpoldsdtl_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wpoldsdtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparison of Amounts between Distribution Tables - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_f_itemds_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_itmprlds_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_itmprldtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_itmprldtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_perilds_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_perildsdtl_wdstfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_polds_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_poldsdtl_wdistfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_poldsdtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_poldsdtl_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_f_poldsdtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Validating GIUW_POL_DIST
** ==================================================================================================================================*/
   PROCEDURE p_val_pol_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparing Final and Working Distribution Tables if EQUAL
** ==================================================================================================================================*/
   PROCEDURE p_val_witemdsdtl_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_witmpldsdtl_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wperildsdtl_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_val_wpoldsdtl_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

      /* ===================================================================================================================================
   **  Dist Validation - Checking existence of non-zero TSI/Prem with zero share % - Working Distribution Tables
   ** ==================================================================================================================================*/
   PROCEDURE p_valcnt_nzroprem_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_nzrotsi_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

      /* ===================================================================================================================================
   **  Dist Validation - Checking existence of non-zero TSI/Prem with zero share % - Final Distribution Tables
   ** ==================================================================================================================================*/
   PROCEDURE p_valcnt_nzroprem_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_nzrotsi_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation -
** ==================================================================================================================================*/

   /* ===================================================================================================================================
   **  Dist Validation - Verification of amounts based on manual computation - Working Distribution Tables
   ** ==================================================================================================================================*/
   PROCEDURE p_valcnt_orsk_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_orsk_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_pdist_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_pdist_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Verification of amounts based on manual computation - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valcnt_orsk_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_orsk_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_pdist_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valcnt_pdist_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valcnt_sign_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valcnt_sign_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Consistency of Share % in Distribution - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valconst_shr_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valconst_shr_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valconst_shr_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_witmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_witmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Consistency of Share % in Distribution - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valconst_shr_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valconst_shr_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_valconst_shr_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_f_itmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_f_itmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcomp_shr_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Validation of existence of Share % based on dist type - Peril/One Risk - Working Distribution Table
** ==================================================================================================================================*/
   PROCEDURE p_vcorsk_wpoldtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_wpoldtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_wpoldtl_witmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_wpoldtl_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_wpoldtl_wperildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_wpoldtl_wperildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_wperildtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_wperildtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_wperildtl_witmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_wperildtl_witmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_wperildtl_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_wperildtl_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Validation of existence of Share % based on dist type - Peril/One Risk - Final Distribution Table
** ==================================================================================================================================*/
   PROCEDURE p_vcorsk_poldtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_poldtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_poldtl_f_itmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_poldtl_f_itmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_poldtl_f_perildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vcorsk_poldtl_f_perildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_perildtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_perildtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_perildtl_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_perildtl_f_itmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_perildtl_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_vpdist_perildtl_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

/* ===================================================================================================================================
**  Dist Validation - Validating if there exists working binder tables
** ==================================================================================================================================*/
   PROCEDURE p_wrkngbndr_wfrps_ri (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_wrkngbndr_wfrperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_wrkngbndr_wbinderperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_wrkngbndr_wbinder (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );

   PROCEDURE p_wrkngbndr_wfrps_peril_grp (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   );
/* ==========================================================================================================================================*/
END genqa_dist;
/

DROP PACKAGE CPI.GENQA_DIST;
