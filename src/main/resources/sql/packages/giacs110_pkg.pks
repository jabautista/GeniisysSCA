CREATE OR REPLACE PACKAGE CPI.giacs110_pkg 
   /*
   **  Created by        : bonok
   **  Date Created      : 07.25.2013
   **  Reference By      : GIACS110 - Taxes withheld from Payees
   **
   */
AS
   TYPE payee_cd_giacs110_lov_type IS RECORD(
      payee_class_cd    giis_payee_class.payee_class_cd%TYPE,
      class_desc        giis_payee_class.class_desc%TYPE
   );
    
   TYPE payee_cd_giacs110_lov_tab IS TABLE OF payee_cd_giacs110_lov_type;
   
   FUNCTION get_payee_cd_giacs110_lov
   RETURN payee_cd_giacs110_lov_tab PIPELINED;
   
   TYPE tax_cd_giacs110_lov_type IS RECORD(
      bir_tax_cd        giac_wholding_taxes.bir_tax_cd%TYPE,
      whtax_id          giac_wholding_taxes.whtax_id%TYPE,
      whtax_desc        giac_wholding_taxes.whtax_desc%TYPE
   );
    
   TYPE tax_cd_giacs110_lov_tab IS TABLE OF tax_cd_giacs110_lov_type;
   
   FUNCTION get_tax_cd_giacs110_lov
   RETURN tax_cd_giacs110_lov_tab PIPELINED;
   
   TYPE payee_no_giacs110_lov_type IS RECORD(
      payee_no          giis_payees.payee_no%TYPE,
      payee_name        VARCHAR2(600)
   );
   
   TYPE payee_no_giacs110_lov_tab IS TABLE OF payee_no_giacs110_lov_type;
   
   FUNCTION get_payee_no_giacs110_lov(
      p_payee_class_cd  giis_payees.payee_class_cd%TYPE
   ) RETURN payee_no_giacs110_lov_tab PIPELINED;
   
   FUNCTION validate_payee_cd_giacs110(
      p_payee_class_cd  giis_payee_class.payee_class_cd%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION validate_tax_cd_giacs110(
      p_whtax_id        giac_wholding_taxes.whtax_id%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION validate_payee_no_giacs110(
      p_payee_no        giis_payees.payee_no%TYPE,
      p_payee_class_cd  giis_payees.payee_class_cd%TYPE
   ) RETURN VARCHAR2;
END giacs110_pkg;
/


