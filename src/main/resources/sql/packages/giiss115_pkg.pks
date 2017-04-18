CREATE OR REPLACE PACKAGE CPI.giiss115_pkg
AS

   TYPE rec_type IS RECORD(
      car_company_cd       giis_mc_car_company.car_company_cd%TYPE,
      car_company          giis_mc_car_company.car_company%TYPE,
      remarks              giis_mc_car_company.remarks%TYPE,
      user_id              giis_mc_car_company.user_id%TYPE,
      last_update          VARCHAR2 (30)
   ); 
   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE,
      p_car_company        giis_mc_car_company.car_company%TYPE
   )
     RETURN rec_tab PIPELINED;

   PROCEDURE set_rec(
      p_rec                giis_mc_car_company%ROWTYPE
   );

   PROCEDURE del_rec(
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE
   );

   PROCEDURE val_del_rec(
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE
   );
   
   PROCEDURE val_add_rec(
      p_car_company        giis_mc_car_company.car_company%TYPE,
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE,
      p_action             VARCHAR2
   );
   
END;
/