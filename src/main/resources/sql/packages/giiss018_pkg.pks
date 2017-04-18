CREATE OR REPLACE PACKAGE CPI.giiss018_pkg
AS
   /*
    **  Created by        : Kenneth L.
    **  Date Created     : 10.17.2012
    **  Reference By     : (GIISS018)
    */
   TYPE pay_terms_list_type IS RECORD (
      payt_terms        giis_payterm.payt_terms%TYPE,
      payt_terms_desc   giis_payterm.payt_terms_desc%TYPE,
      no_of_payt        giis_payterm.no_of_payt%TYPE,
      annual_sw         giis_payterm.annual_sw%TYPE,
      no_of_days        giis_payterm.no_of_days%TYPE,
      on_incept_tag     giis_payterm.on_incept_tag%TYPE,
      remarks           giis_payterm.remarks%TYPE,
      user_id           giis_payterm.user_id%TYPE,
      no_payt_days      giis_payterm.no_payt_days%TYPE,
      last_update       VARCHAR2(100)
   );

   TYPE pay_terms_list_tab IS TABLE OF pay_terms_list_type;

   FUNCTION get_pay_terms_list
      RETURN pay_terms_list_tab PIPELINED;

   PROCEDURE set_pay_terms_list (p_payterm giis_payterm%ROWTYPE);

   PROCEDURE delete_pay_terms_list (p_payt_terms giis_payterm.payt_terms%TYPE);
   
   FUNCTION validate_add_paytterm (p_payt_terms giis_payterm.payt_terms%TYPE)
        RETURN VARCHAR2;
 
   FUNCTION validate_del_paytterm (p_payt_terms giis_payterm.payt_terms%TYPE)
        RETURN VARCHAR2;
   
   FUNCTION validate_add_paytermdesc (p_payt_terms giis_payterm.payt_terms%TYPE, p_payt_terms_desc giis_payterm.payt_terms_desc%TYPE)
        RETURN VARCHAR2;
END giiss018_pkg;
/


