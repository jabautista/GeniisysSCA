CREATE OR REPLACE PACKAGE CPI.GIISS203_PKG
AS
   TYPE rec_type IS RECORD (
      intm_no           GIIS_INTERMEDIARY.INTM_NO%type,
      intm_name         GIIS_INTERMEDIARY.INTM_NAME%type,
      ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%type,
      active_tag        GIIS_INTERMEDIARY.ACTIVE_TAG%type,
      parent_intm_no    GIIS_INTERMEDIARY.PARENT_INTM_NO%type,
      parent_intm_name  GIIS_INTERMEDIARY.INTM_NAME%type,
      intm_type         GIIS_INTERMEDIARY.INTM_TYPE%type,
      intm_type_desc    GIIS_INTM_TYPE.INTM_DESC%type,
      remarks           GIIS_INTERMEDIARY.REMARKS%type,
      user_id           GIIS_INTERMEDIARY.USER_ID%type,
      last_update       VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_intm_no           GIIS_INTERMEDIARY.INTM_NO%type,
      p_intm_name         GIIS_INTERMEDIARY.INTM_NAME%type,
      --p_ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%type,
      p_active_tag        GIIS_INTERMEDIARY.ACTIVE_TAG%type,
      p_intm_type         GIIS_INTERMEDIARY.INTM_TYPE%type
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec GIIS_INTERMEDIARY%ROWTYPE);

   --PROCEDURE del_rec (p_intm_no GIIS_INTERMEDIARY.INTM_NO%type);

   PROCEDURE val_del_rec (
        p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type,
        p_msg       OUT VARCHAR2,
        p_ctrl_sw1  OUT NUMBER
   );
   
    --PROCEDURE val_add_rec(p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type);
    
    
END GIISS203_PKG;
/


