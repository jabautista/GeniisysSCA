CREATE OR REPLACE PACKAGE CPI.giiss217_pkg
AS
   TYPE rec_type IS RECORD (
      location_cd      giis_ca_location.location_cd%TYPE,
      location_desc    giis_ca_location.location_desc%TYPE,
      loc_addr         VARCHAR2 (150),
      loc_addr1        giis_ca_location.loc_addr1%TYPE,
      loc_addr2        giis_ca_location.loc_addr2%TYPE,
      loc_addr3        giis_ca_location.loc_addr3%TYPE,
      treaty_limit     giis_ca_location.treaty_limit%TYPE,
      ret_limit        giis_ca_location.ret_limit%TYPE,
      ret_beg_bal      giis_ca_location.ret_beg_bal%TYPE,
      treaty_beg_bal   giis_ca_location.treaty_beg_bal%TYPE,
      fac_beg_bal      giis_ca_location.fac_beg_bal%TYPE,
      from_date        VARCHAR2 (20),
      TO_DATE          VARCHAR2 (20),
      remarks          giis_ca_location.remarks%TYPE,
      user_id          giis_ca_location.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_location_cd     giis_ca_location.location_cd%TYPE,
      p_location_desc   giis_ca_location.location_desc%TYPE,
      p_loc_addr        VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_ca_location%ROWTYPE);

   PROCEDURE del_rec (p_location_cd giis_ca_location.location_cd%TYPE);
END;
/


