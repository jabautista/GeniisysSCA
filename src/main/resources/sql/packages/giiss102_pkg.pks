CREATE OR REPLACE PACKAGE CPI.GIISS102_PKG
AS
   TYPE rec_type IS RECORD (
      coll_type     GIIS_COLLATERAL_TYPE.COLL_TYPE%type,
      coll_name     GIIS_COLLATERAL_TYPE.COLL_NAME%type,
      remarks       GIIS_COLLATERAL_TYPE.REMARKS%type,
      user_id       GIIS_COLLATERAL_TYPE.USER_ID%type,
      last_update   VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_coll_type     GIIS_COLLATERAL_TYPE.COLL_TYPE%type,
      p_coll_name     GIIS_COLLATERAL_TYPE.COLL_NAME%type
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec GIIS_COLLATERAL_TYPE%ROWTYPE);

   PROCEDURE del_rec (p_coll_type GIIS_COLLATERAL_TYPE.coll_type%TYPE);

   PROCEDURE val_del_rec (p_coll_type GIIS_COLLATERAL_TYPE.coll_type%TYPE);
   
   PROCEDURE val_add_rec(p_coll_type GIIS_COLLATERAL_TYPE.coll_type%TYPE);
   
END GIISS102_PKG;
/


