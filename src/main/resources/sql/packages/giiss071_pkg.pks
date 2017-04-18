CREATE OR REPLACE PACKAGE CPI.GIISS071_PKG
AS

    TYPE rec_type IS RECORD(
        signatory_id        GIIS_SIGNATORY_NAMES.SIGNATORY_ID%type,
        signatory           GIIS_SIGNATORY_NAMES.SIGNATORY%type,
        designation         GIIS_SIGNATORY_NAMES.DESIGNATION%type,
        res_cert_no         GIIS_SIGNATORY_NAMES.RES_CERT_NO%type,
        res_cert_date       VARCHAR2(30),
        res_cert_place      GIIS_SIGNATORY_NAMES.RES_CERT_PLACE%type,
        status              GIIS_SIGNATORY_NAMES.STATUS%type,
        status_mean         CG_REF_CODES.RV_MEANING%type,
        file_name           GIIS_SIGNATORY_NAMES.FILE_NAME%type,
        remarks             GIIS_SIGNATORY_NAMES.REMARKS%type,
        user_id             GIIS_SIGNATORY_NAMES.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    FUNCTION get_rec_list(
        p_signatory           GIIS_SIGNATORY_NAMES.SIGNATORY%type
    ) RETURN rec_tab PIPELINED;

    PROCEDURE set_rec (p_rec GIIS_SIGNATORY_NAMES%ROWTYPE);

    PROCEDURE del_rec (p_signatory_id   GIIS_SIGNATORY_NAMES.signatory_id%type);

    PROCEDURE val_del_rec (p_signatory_id   GIIS_SIGNATORY_NAMES.signatory_id%type);
   
    PROCEDURE val_add_rec(
        p_signatory_id  GIIS_SIGNATORY_NAMES.signatory_id%type,
        p_signatory     GIIS_SIGNATORY_NAMES.SIGNATORY%type,
        p_res_cert_no   GIIS_SIGNATORY_NAMES.RES_CERT_NO%type
    );
    
    PROCEDURE val_update_rec(
        p_signatory_id  GIIS_SIGNATORY_NAMES.signatory_id%type,
        p_signatory     GIIS_SIGNATORY_NAMES.SIGNATORY%type,
        p_res_cert_no   GIIS_SIGNATORY_NAMES.RES_CERT_NO%type
    );
    
    PROCEDURE set_signatory_file_name (
      p_signatory_id   giis_signatory_names.signatory_id%TYPE,
      p_file_name      giis_signatory_names.file_name%TYPE
    );
    
END GIISS071_PKG;
/


