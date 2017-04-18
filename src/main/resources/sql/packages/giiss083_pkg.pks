CREATE OR REPLACE PACKAGE CPI.giiss083_pkg
AS
   TYPE intermediary_type IS RECORD (
      intm_type      giis_intm_type.intm_type%TYPE,
      intm_desc      giis_intm_type.intm_desc%TYPE,
      acct_intm_cd   giis_intm_type.acct_intm_cd%TYPE,
      remarks        giis_intm_type.remarks%TYPE,
      user_id        giis_intm_type.user_id%TYPE,
      last_update    VARCHAR2 (200)
   );

   TYPE intermediary_tab IS TABLE OF intermediary_type;

   FUNCTION show_intm_type
      RETURN intermediary_tab PIPELINED;

   PROCEDURE set_intm_type (
      p_intm_type      giis_intm_type.intm_type%TYPE,
      p_acct_intm_cd   giis_intm_type.acct_intm_cd%TYPE,
      p_intm_desc      giis_intm_type.intm_desc%TYPE,
      p_remarks        giis_intm_type.remarks%TYPE
   );

   PROCEDURE val_del_rec (p_intm_type giis_intm_type.intm_type%TYPE);


   PROCEDURE val_add_rec (p_inm_type giis_intm_type.intm_type%TYPE);
   PROCEDURE delete_in_intm_type (p_intm_type giis_intm_type.intm_type%TYPE); 
   FUNCTION chk_giis_intm_type(p_intm_type giis_intm_type.intm_type%TYPE) --Added by Jerome 08.11.2016 SR 5583
   RETURN VARCHAR2;
END;
/


