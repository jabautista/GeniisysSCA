CREATE OR REPLACE PACKAGE CPI.giiss068_pkg
AS
   TYPE rec_type IS RECORD (
      principal_id              giis_eng_principal.principal_id%TYPE,
      principal_cd              giis_eng_principal.principal_cd%TYPE,
      principal_name            giis_eng_principal.principal_name%TYPE,
      principal_type            giis_eng_principal.principal_type%TYPE,
      principal_type_mean       cg_ref_codes.rv_meaning%TYPE,
      subline_cd                giis_eng_principal.subline_cd%TYPE,
      subline_name              giis_subline.subline_name%TYPE,
      address1                  giis_eng_principal.address1%TYPE,
      address2                  giis_eng_principal.address2%TYPE,
      address3                  giis_eng_principal.address3%TYPE,
      remarks                   giis_eng_principal.remarks%TYPE,
      user_id                   giis_eng_principal.user_id%TYPE,
      last_update               VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_principal_id            giis_eng_principal.principal_id%TYPE,
      p_principal_cd            giis_eng_principal.principal_cd%TYPE,
      p_principal_name          giis_eng_principal.principal_name%TYPE,
      p_principal_type          giis_eng_principal.principal_type%TYPE,
      p_subline_cd              giis_eng_principal.subline_cd%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec     giis_eng_principal%ROWTYPE);

   PROCEDURE del_rec (p_principal_cd       giis_eng_principal.principal_cd%TYPE);

   PROCEDURE val_del_rec (p_principal_cd       giis_eng_principal.principal_cd%TYPE);

   PROCEDURE val_add_rec (p_principal_cd       giis_eng_principal.principal_cd%TYPE);
   
   FUNCTION get_next_id RETURN NUMBER;
   
   TYPE giiss068_subline_type IS RECORD (
        subline_cd      giis_subline.subline_cd%TYPE,
        subline_name    giis_subline.subline_name%TYPE
   );
   
   TYPE giis068_subline_tab IS TABLE OF giiss068_subline_type;
   
   FUNCTION get_giiss068_subline_lov RETURN giis068_subline_tab PIPELINED;
   
END;
/


