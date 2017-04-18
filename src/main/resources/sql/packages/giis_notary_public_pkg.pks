CREATE OR REPLACE PACKAGE CPI.GIIS_NOTARY_PUBLIC_PKG AS

  TYPE notary_public_type IS RECORD
    (np_no           GIIS_NOTARY_PUBLIC.np_no%TYPE,
     np_name         GIIS_NOTARY_PUBLIC.np_name%TYPE);
  
  TYPE notary_public_tab IS TABLE OF notary_public_type;
  
  FUNCTION get_notary_public_list 
    RETURN notary_public_tab PIPELINED;

END GIIS_NOTARY_PUBLIC_PKG;
/


