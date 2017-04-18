CREATE OR REPLACE PACKAGE CPI.gipi_coc_auth_pkg
AS
   TYPE gipi_coc_auth_type IS RECORD (
      policy_id           gipi_polbasic.policy_id%TYPE,
      cocaf_user          giis_cocaf_users.cocaf_user%TYPE,
      cocaf_pwd           giis_cocaf_users.cocaf_pwd%TYPE,
      item_no             gipi_item.item_no%TYPE,
      reg_type            gipi_wvehicle.reg_type%TYPE,
      coc_no              VARCHAR (20),
      plate_no            gipi_vehicle.plate_no%TYPE,
      mv_file_no          gipi_vehicle.mv_file_no%TYPE,
      motor_no            gipi_vehicle.motor_no%TYPE,
      serial_no           gipi_vehicle.serial_no%TYPE,
      incept_date         VARCHAR (20),
      expiry_date         VARCHAR (20),
      mv_type             gipi_vehicle.mv_type%TYPE,
      mv_prem_type        gipi_vehicle.mv_prem_type%TYPE,
      tax_type            gipi_vehicle.tax_type%TYPE,
      assd_name           giis_assured.assd_name%TYPE,
      assd_tin            giis_assured.assd_tin%TYPE
   );

   TYPE gipi_coc_auth_tab IS TABLE OF gipi_coc_auth_type;

   FUNCTION get_coc_authentication (
      p_user_id   giis_users.user_id%TYPE,
      p_par_id    gipi_polbasic.par_id%TYPE,
      p_use_default_tin VARCHAR2
   )
      RETURN gipi_coc_auth_tab PIPELINED;

   FUNCTION get_pack_coc_authentication (
      p_user_id       giis_users.user_id%TYPE,
      p_pack_par_id   gipi_pack_parlist.pack_par_id%TYPE,
      p_use_default_tin VARCHAR2
   )
      RETURN gipi_coc_auth_tab PIPELINED;

   PROCEDURE set_coc_authentication (
      p_auth_no        gipi_coc_auth.auth_no%TYPE,
      p_cocaf_user     gipi_coc_auth.cocaf_user%TYPE,
      p_coc_no         gipi_coc_auth.coc_no%TYPE,
      p_err_msg        gipi_coc_auth.err_msg%TYPE,
      p_item_no        gipi_coc_auth.item_no%TYPE,
      p_policy_id      gipi_coc_auth.policy_id%TYPE,
      p_reg_date       gipi_coc_auth.reg_date%TYPE,
      p_last_user_id   gipi_coc_auth.last_user_id%TYPE
   );
END gipi_coc_auth_pkg;
/