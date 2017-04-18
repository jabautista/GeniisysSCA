CREATE OR REPLACE PACKAGE CPI.GIIS_PAYTERM_PKG
AS
   /********************************** FUNCTION 1 ************************************
     MODULE: GIPIS026
     RECORD GROUP NAME: CGFK$GIPI_WINVOICE5_DSP_PAYT_T
   ***********************************************************************************/

   TYPE pay_terms_list_type IS RECORD
   (
      payt_terms        GIIS_PAYTERM.payt_terms%TYPE,
      payt_terms_desc   GIIS_PAYTERM.payt_terms_desc%TYPE,
      no_of_payt        GIIS_PAYTERM.no_of_payt%TYPE,
      annual_sw         GIIS_PAYTERM.annual_sw%TYPE,
      no_of_days        GIIS_PAYTERM.no_of_days%TYPE,
      on_incept_tag     GIIS_PAYTERM.on_incept_tag%TYPE,
      no_payt_days      GIIS_PAYTERM.no_payt_days%TYPE
   );

   TYPE pay_terms_list_tab IS TABLE OF pay_terms_list_type;

   FUNCTION get_pay_terms_list
      RETURN pay_terms_list_tab
      PIPELINED;
      
      --Kenneth L 04.23.2013
   FUNCTION get_payterm_lov_giuts022
      RETURN pay_terms_list_tab
      PIPELINED;
      
END GIIS_PAYTERM_PKG;
/


