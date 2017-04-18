CREATE OR REPLACE PACKAGE CPI.giacs352_pkg
AS
   TYPE rec_type IS RECORD (
      eom_script_no       giac_eom_checking_scripts.eom_script_no%TYPE,
      eom_script_title    giac_eom_checking_scripts.eom_script_title%TYPE,
      eom_script_text_1   giac_eom_checking_scripts.eom_script_text_1%TYPE,
      eom_script_text_2   giac_eom_checking_scripts.eom_script_text_2%TYPE,
      eom_script_soln     giac_eom_checking_scripts.eom_script_soln%TYPE,
      remarks             giac_eom_checking_scripts.remarks%TYPE,
      user_id             giac_eom_checking_scripts.user_id%TYPE,
      last_update         VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_eom_script_no       giac_eom_checking_scripts.eom_script_no%TYPE,
      p_eom_script_title    giac_eom_checking_scripts.eom_script_title%TYPE,
      p_eom_script_text_1   giac_eom_checking_scripts.eom_script_text_1%TYPE,
      p_eom_script_text_2   giac_eom_checking_scripts.eom_script_text_2%TYPE,
      p_eom_script_soln     giac_eom_checking_scripts.eom_script_soln%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_eom_checking_scripts%ROWTYPE);

   PROCEDURE del_rec (
      p_eom_script_no   giac_eom_checking_scripts.eom_script_no%TYPE
   );
END;
/


