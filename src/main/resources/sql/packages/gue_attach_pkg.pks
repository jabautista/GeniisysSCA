CREATE OR REPLACE PACKAGE CPI.GUE_ATTACH_PKG AS

    PROCEDURE set_gue_attach(p_attach GUE_ATTACH%ROWTYPE);

    TYPE gue_attach_type IS RECORD (
        tran_id     GUE_ATTACH.tran_id%TYPE,
        item_no     GUE_ATTACH.item_no%TYPE,
        file_name   GUE_ATTACH.file_name%TYPE,
        file_path   VARCHAR2(32767),
        remarks     GUE_ATTACH.remarks%TYPE
    );
    
    TYPE gue_attach_tab IS TABLE OF gue_attach_type;
    
    FUNCTION get_gue_attach_listing(p_tran_id GUE_ATTACH.tran_id%TYPE)
      RETURN gue_attach_tab PIPELINED;
    
    PROCEDURE del_gue_attach(
      p_tran_id GUE_ATTACH.tran_id%TYPE,
      p_item_no GUE_ATTACH.item_no%TYPE
    );
    
END GUE_ATTACH_PKG;
/


