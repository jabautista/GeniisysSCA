CREATE OR REPLACE PACKAGE BODY CPI.giacs110_pkg
   /*
   **  Created by        : bonok
   **  Date Created      : 07.25.2013
   **  Reference By      : GIACS110 - Taxes withheld from Payees
   **
   */
AS
   FUNCTION get_payee_cd_giacs110_lov
   RETURN payee_cd_giacs110_lov_tab PIPELINED AS
      res               payee_cd_giacs110_lov_type;
   BEGIN
      FOR i IN (SELECT payee_class_cd, class_desc 
                  FROM giis_payee_class
                 ORDER BY class_desc)
      LOOP
         res.payee_class_cd := i.payee_class_cd;
         res.class_desc := i.class_desc;
         
         PIPE ROW(res);
      END LOOP;
   END;
   
   FUNCTION get_tax_cd_giacs110_lov
   RETURN tax_cd_giacs110_lov_tab PIPELINED AS
      res               tax_cd_giacs110_lov_type;
   BEGIN
      FOR i IN (SELECT bir_tax_cd, whtax_id, whtax_desc
                  FROM giac_wholding_taxes)
      LOOP
         res.bir_tax_cd := i.bir_tax_cd;
         res.whtax_id := i.whtax_id;
         res.whtax_desc := i.whtax_desc;
         
         PIPE ROW(res);
      END LOOP;
   END;   
   
   FUNCTION get_payee_no_giacs110_lov(
      p_payee_class_cd  giis_payees.payee_class_cd%TYPE
   ) RETURN payee_no_giacs110_lov_tab PIPELINED AS
      res               payee_no_giacs110_lov_type;
   BEGIN
      FOR i IN (SELECT payee_no, payee_last_name ||' '|| payee_first_name ||' '|| payee_middle_name payee_name
                  FROM giis_payees
                 WHERE payee_class_cd = p_payee_class_cd)
      LOOP
         res.payee_no := i.payee_no;
         res.payee_name := i.payee_name;
         
         PIPE ROW(res);
      END LOOP;
   END;                     
   
   FUNCTION validate_payee_cd_giacs110(
      p_payee_class_cd  giis_payee_class.payee_class_cd%TYPE
   ) RETURN VARCHAR2 AS
      v_class_desc      giis_payee_class.class_desc%TYPE;
   BEGIN
      SELECT class_desc
        INTO v_class_desc
        FROM giis_payee_class
       WHERE payee_class_cd = p_payee_class_cd;
         
      RETURN v_class_desc;
   END;
   
   FUNCTION validate_tax_cd_giacs110(
      p_whtax_id        giac_wholding_taxes.whtax_id%TYPE
   ) RETURN VARCHAR2 AS
      v_whtax_desc      giac_wholding_taxes.whtax_desc%TYPE;
   BEGIN
      SELECT whtax_desc
        INTO v_whtax_desc
        FROM giac_wholding_taxes
       WHERE whtax_id = p_whtax_id;
       
      RETURN v_whtax_desc;
   END;
   
   FUNCTION validate_payee_no_giacs110(
      p_payee_no        giis_payees.payee_no%TYPE,
      p_payee_class_cd  giis_payees.payee_class_cd%TYPE
   ) RETURN VARCHAR2 AS
      v_payee_name      VARCHAR2(600);
   BEGIN
      SELECT payee_last_name ||' '|| payee_first_name ||' '|| payee_middle_name payee_name
        INTO v_payee_name
        FROM giis_payees
       WHERE payee_class_cd = p_payee_class_cd
         AND payee_no = p_payee_no;
      
      RETURN v_payee_name;
   END;
END giacs110_pkg;
/


