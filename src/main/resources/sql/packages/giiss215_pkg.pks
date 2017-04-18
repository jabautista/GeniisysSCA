CREATE OR REPLACE PACKAGE CPI.giiss215_pkg
AS
   TYPE rec_type IS RECORD (
      area_cd       giis_banc_area.area_cd%TYPE,
      area_desc     giis_banc_area.area_desc%TYPE,
      eff_date      giis_banc_area.eff_date%TYPE,
      remarks       giis_banc_area.remarks%TYPE,
      user_id       giis_banc_area.user_id%TYPE,
      last_update   VARCHAR2 (50)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_area_cd     giis_banc_area.area_cd%TYPE,
      p_area_desc   giis_banc_area.area_desc%TYPE,
      p_eff_date    VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_banc_area%ROWTYPE);

   PROCEDURE val_add_rec (
      p_area_cd     giis_banc_area.area_cd%TYPE,
      p_area_desc   giis_banc_area.area_desc%TYPE
   );

   TYPE hist_type IS RECORD (
      area_cd        giis_banc_area_hist.area_cd%TYPE,
      old_eff_date   giis_banc_area_hist.old_eff_date%TYPE,
      new_eff_date   giis_banc_area_hist.new_eff_date%TYPE,
      user_id        giis_banc_area_hist.user_id%TYPE,
      last_update    giis_banc_area_hist.last_update%TYPE
--      last_update    VARCHAR2(50)
   );

   TYPE hist_tab IS TABLE OF hist_type;

   FUNCTION get_hist (p_area_cd VARCHAR2)
      RETURN hist_tab PIPELINED;
END;
/


