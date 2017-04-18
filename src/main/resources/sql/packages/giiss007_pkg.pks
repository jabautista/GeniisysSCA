CREATE OR REPLACE PACKAGE CPI.giiss007_pkg
AS
   TYPE rec_type IS RECORD (
      district_no         giis_block.district_no%TYPE,
      block_no            giis_block.block_no%TYPE,
      block_desc          giis_block.block_desc%TYPE,
      retn_lim_amt        giis_block.retn_lim_amt%TYPE,
      trty_lim_amt        giis_block.trty_lim_amt%TYPE,
      netret_beg_bal      giis_block.netret_beg_bal%TYPE,
      facul_beg_bal       giis_block.facul_beg_bal%TYPE,
      trty_beg_bal        giis_block.trty_beg_bal%TYPE,
      eq_zone             giis_block.eq_zone%TYPE,
      flood_zone          giis_block.flood_zone%TYPE,
      typhoon_zone        giis_block.typhoon_zone%TYPE,
      sheet_no            giis_block.sheet_no%TYPE,
      district_desc       giis_block.district_desc%TYPE,
      user_id             giis_block.user_id%TYPE,
      last_update         VARCHAR2 (30),
      remarks             giis_block.remarks%TYPE,
      block_id            giis_block.block_id%TYPE,
      province_cd         giis_block.province_cd%TYPE,
      city                giis_block.city%TYPE,
      city_cd             giis_block.city_cd%TYPE,
      province            giis_block.province%TYPE,
      beg_balance         giis_block.beg_balance%TYPE,
      active_tag          giis_block.active_tag%TYPE,
      eq_zone_desc        giis_eqzone.eq_desc%TYPE,
      flood_zone_desc     giis_flood_zone.flood_zone_desc%TYPE,
      typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE eq_zone_rec_type IS RECORD (
      eq_zone   giis_eqzone.eq_zone%TYPE,
      eq_desc   giis_eqzone.eq_desc%TYPE
   );

   TYPE eq_zone_rec_tab IS TABLE OF eq_zone_rec_type;

   TYPE flood_zone_rec_type IS RECORD (
      flood_zone        giis_flood_zone.flood_zone%TYPE,
      flood_zone_desc   giis_flood_zone.flood_zone_desc%TYPE
   );

   TYPE flood_zone_rec_tab IS TABLE OF flood_zone_rec_type;

   TYPE typhoon_zone_rec_type IS RECORD (
      typhoon_zone        giis_typhoon_zone.typhoon_zone%TYPE,
      typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE
   );

   TYPE typhoon_zone_rec_tab IS TABLE OF typhoon_zone_rec_type;

   TYPE risks_rec_type IS RECORD (
      risk_cd     giis_risks.risk_cd%TYPE,
      risk_desc   giis_risks.risk_desc%TYPE
   );

   TYPE risks_rec_tab IS TABLE OF risks_rec_type;

   FUNCTION get_province_rec_list
      RETURN rec_tab PIPELINED;

   FUNCTION get_city_rec_list (p_province_cd giis_block.province_cd%TYPE)
      RETURN rec_tab PIPELINED;

   FUNCTION get_district_rec_list (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_block_rec_list (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_risks_rec_list (p_block_id giis_block.block_id%TYPE)
      RETURN risks_rec_tab PIPELINED;

   FUNCTION get_province_lov
      RETURN rec_tab PIPELINED;

   FUNCTION get_city_lov (p_province_cd giis_block.province_cd%TYPE)
      RETURN rec_tab PIPELINED;

   FUNCTION get_eq_zone_lov
      RETURN eq_zone_rec_tab PIPELINED;

   FUNCTION get_flood_zone_lov
      RETURN flood_zone_rec_tab PIPELINED;

   FUNCTION get_typhoon_zone_lov
      RETURN typhoon_zone_rec_tab PIPELINED;

   PROCEDURE val_del_rec_risk (
      p_block_id   giis_risks.block_id%TYPE,
      p_risk_cd    giis_risks.risk_cd%TYPE
   );

   PROCEDURE val_add_rec_risk (
      p_block_id    giis_risks.block_id%TYPE,
      p_risk_cd     giis_risks.risk_cd%TYPE,
      p_risk_desc   giis_risks.risk_desc%TYPE
   );

   PROCEDURE del_rec_risk (
      p_block_id   giis_risks.block_id%TYPE,
      p_risk_cd    giis_risks.risk_cd%TYPE
   );

   PROCEDURE set_rec_risk (p_rec giis_risks%ROWTYPE);

   PROCEDURE val_add_rec_block (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE,
      p_block_no      giis_block.block_no%TYPE
   );

   PROCEDURE val_del_rec_block (p_block_id giis_block.block_id%TYPE);

   PROCEDURE set_rec_block (p_rec giis_block%ROWTYPE);

   PROCEDURE update_rec_district (p_rec giis_block%ROWTYPE);

   PROCEDURE del_rec_block (p_block_id giis_block.block_id%TYPE);

   PROCEDURE val_del_rec_province (p_province_cd giis_block.province_cd%TYPE);

   PROCEDURE del_rec_province (p_province_cd giis_block.province_cd%TYPE);

   PROCEDURE val_del_rec_city (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE
   );

   PROCEDURE del_rec_city (p_rec giis_block%ROWTYPE);

   PROCEDURE val_del_rec_district (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   );

   PROCEDURE del_rec_district (p_rec giis_block%ROWTYPE);
   
   PROCEDURE val_add_rec_district (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   );
END;
/


