CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PAYTERM_PKG  AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: CGFK$GIPI_WINVOICE5_DSP_PAYT_T 
***********************************************************************************/
  
  FUNCTION get_pay_terms_list 
    RETURN pay_terms_list_tab PIPELINED IS
 
 v_terms  pay_terms_list_type;

  BEGIN
    FOR i IN (
  SELECT payt_terms, payt_terms_desc, no_of_payt, annual_sw, no_of_days, on_incept_tag, no_payt_days
       FROM GIIS_PAYTERM
   ORDER BY payt_terms_desc)
 LOOP
 v_terms.payt_terms  := i.payt_terms;
  v_terms.payt_terms_desc := i.payt_terms_desc;
  v_terms.no_of_payt  := i.no_of_payt;
  v_terms.annual_sw  := i.annual_sw;
  v_terms.no_of_days := i.no_of_days;
  v_terms.on_incept_tag    := i.on_incept_tag;
  v_terms.no_payt_days := i.no_payt_days;
   PIPE ROW(v_terms);
 END LOOP;
 
    RETURN;
  END get_pay_terms_list;
 
 
 /*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 04.23.2013
    **  Reference By : GIUTS022 - CHANGE IN PAYMENT TERM
    **  payterm lov
    */  
   FUNCTION get_payterm_lov_giuts022
      RETURN pay_terms_list_tab
      PIPELINED IS
 
 v_terms  pay_terms_list_type;

  BEGIN
        FOR i IN (
      SELECT payt_terms, payt_terms_desc, no_of_payt
           FROM GIIS_PAYTERM)
       
     LOOP
     v_terms.payt_terms  := i.payt_terms;
      v_terms.payt_terms_desc := i.payt_terms_desc;
      v_terms.no_of_payt  := i.no_of_payt;
       PIPE ROW(v_terms);
     END LOOP;
 
    RETURN;
  END get_payterm_lov_giuts022;
  
 END GIIS_PAYTERM_PKG;
/


