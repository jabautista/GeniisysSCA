CREATE OR REPLACE PACKAGE CPI.giacs353_pkg
AS
   TYPE checking_scripts_type IS RECORD
   (
      eom_script_no       giac_eom_checking_scripts.eom_script_no%TYPE,
      eom_script_title    giac_eom_checking_scripts.eom_script_title%TYPE,
      eom_script_text_1   giac_eom_checking_scripts.eom_script_text_1%TYPE,
      eom_script_text_2   giac_eom_checking_scripts.eom_script_text_2%TYPE,
      eom_script_soln     giac_eom_checking_scripts.eom_script_soln%TYPE,
      remarks             giac_eom_checking_scripts.remarks%TYPE,
      user_id             giac_eom_checking_scripts.user_id%TYPE,
      last_update         giac_eom_checking_scripts.last_update%TYPE,
      check_book_date     giac_eom_checking_scripts.check_book_date%TYPE --mikel 05.30.2016
   );

   TYPE checking_scripts_tab IS TABLE OF checking_scripts_type;

   FUNCTION get_checking_scripts
      RETURN checking_scripts_tab
      PIPELINED;

   FUNCTION get_data_type (p_query VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_format (p_query VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_param_restriction (p_query VARCHAR2)
      RETURN VARCHAR2;

   TYPE check_query_type IS RECORD
   (
      script   VARCHAR2 (32767),
      stat     VARCHAR2 (7)
   );

   TYPE check_query_tab IS TABLE OF check_query_type;

   FUNCTION check_query (p_month VARCHAR2, p_year VARCHAR2, p_query VARCHAR2)
      RETURN check_query_tab
      PIPELINED;

   --mikel 05.27.2016; automate patch

   TYPE policy_rec IS RECORD
   (
      policy_no       VARCHAR2 (100),
      policy_id       gipi_polbasic.policy_id%TYPE,
      dist_no         giuw_pol_dist.dist_no%TYPE,
      fnl_binder_id   giri_binder.fnl_binder_id%TYPE,
      claim_id        gicl_claims.claim_id%TYPE
   );

   PROCEDURE insert_upd_pol_dist (p_policy_id gipi_polbasic.policy_id%TYPE);

   PROCEDURE update_pol_flag (p_policy_id gipi_polbasic.policy_id%TYPE);

   PROCEDURE update_booking_date (p_policy_id   gipi_polbasic.policy_id%TYPE);
   
   PROCEDURE update_direct_comm (p_policy_id   gipi_polbasic.policy_id%TYPE);
   
   --PROCEDURE insert_direct_comm (p_policy_id   gipi_polbasic.policy_id%TYPE);

   PROCEDURE update_ri_comm (p_policy_id gipi_polbasic.policy_id%TYPE);

   PROCEDURE update_dist_flag (
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_script_tag    giac_eom_checking_scripts.eom_script_tag%TYPE);

   PROCEDURE update_takeup_seq_no (
      p_policy_id    gipi_polbasic.policy_id%TYPE,
      p_dist_no      giuw_pol_dist.dist_no%TYPE);
      
   PROCEDURE update_currency_rt (
      p_policy_id    gipi_polbasic.policy_id%TYPE,
      p_dist_no      giuw_pol_dist.dist_no%TYPE);   

   PROCEDURE update_binder_amt (
      p_fnl_binder_id giri_binder.fnl_binder_id%TYPE);

   PROCEDURE populate_direct_claim_payts;

   PROCEDURE update_claim_dist_no (p_claim_id gicl_claims.claim_id%TYPE);

   PROCEDURE patch_records (p_month            VARCHAR2,
                            p_year             VARCHAR2,
                            p_script_type      VARCHAR2,
                            p_module_id        VARCHAR2);
--end mikel 05.27.2016; GENQA 5544

END;
/
