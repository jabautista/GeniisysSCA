CREATE OR REPLACE PACKAGE CPI.giiss012_pkg
AS
   TYPE main_type IS RECORD (
      fr_item_type      giis_fi_item_type.fr_item_type%TYPE,
      fr_itm_tp_ds      giis_fi_item_type.fr_itm_tp_ds%TYPE,
      fi_itm_grp_desc   cg_ref_codes.rv_meaning%TYPE,
      main_itm_typ      giis_fi_item_type.main_itm_typ%TYPE,
      remarks           giis_fi_item_type.remarks%TYPE,
      user_id           giis_fi_item_type.user_id%TYPE,
      last_update       VARCHAR2(50),
      fi_item_grp       giis_fi_item_type.fi_item_grp%TYPE,
      cpi_rec_no        giis_fi_item_type.cpi_rec_no%TYPE
      
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_fi_item_type
      RETURN main_tab PIPELINED;
      
   TYPE fi_item_grp_type IS RECORD (
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE
   );
   
   TYPE fi_item_grp_tab IS TABLE OF fi_item_grp_type;
   
   FUNCTION get_fi_item_grp_lov
      RETURN fi_item_grp_tab PIPELINED;
      
   PROCEDURE val_add_rec(p_fr_item_type giis_fi_item_type.fr_item_type%TYPE);
   
   PROCEDURE val_del_rec(p_fr_item_type giis_fi_item_type.fr_item_type%TYPE);
   
   PROCEDURE set_rec (p_rec giis_fi_item_type%ROWTYPE);
   
   PROCEDURE del_rec (p_fr_item_type VARCHAR2);
      
END;
/


