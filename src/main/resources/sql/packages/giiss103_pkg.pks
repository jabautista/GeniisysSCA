CREATE OR REPLACE PACKAGE CPI.GIISS103_PKG
AS

   TYPE make_type IS RECORD(
      make_cd                 giis_mc_make.make_cd%TYPE,
      make                    giis_mc_make.make%TYPE,
      car_company_cd          giis_mc_make.car_company_cd%TYPE,
      car_company             giis_mc_car_company.car_company%TYPE,
      subline_cd              giis_mc_make.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE,
      no_of_pass              giis_mc_make.no_of_pass%TYPE,
      remarks                 giis_mc_make.remarks%TYPE,
      user_id                 giis_mc_make.user_id%TYPE,
      last_update             giis_mc_make.last_update%TYPE,
      dsp_last_update         VARCHAR(50)
   );
   TYPE make_tab IS TABLE OF make_type;
   
   TYPE eng_type IS RECORD(
      make_cd                 giis_mc_eng_series.make_cd%TYPE,
      car_company_cd          giis_mc_eng_series.car_company_cd%TYPE,
      series_cd               giis_mc_eng_series.series_cd%TYPE,
      engine_series           giis_mc_eng_series.engine_series%TYPE,
      remarks                 giis_mc_eng_series.remarks%TYPE,
      user_id                 giis_mc_eng_series.user_id%TYPE,
      last_update             giis_mc_eng_series.last_update%TYPE
   );
   TYPE eng_tab IS TABLE OF eng_type;
   
   TYPE subline_type IS RECORD(
      subline_cd              giis_subline.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE
   );
   TYPE subline_tab IS TABLE OF subline_type;
   
   TYPE company_type IS RECORD(
      car_company_cd          giis_mc_car_company.car_company_cd%TYPE,
      car_company             giis_mc_car_company.car_company%TYPE
   );
   TYPE company_tab IS TABLE OF company_type;
   
   FUNCTION get_make_listing(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_make                  giis_mc_make.make%TYPE,
      p_no_of_pass            giis_mc_make.no_of_pass%TYPE,
      p_subline_cd            giis_mc_make.subline_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE
   )
     RETURN make_tab PIPELINED;
     
   FUNCTION get_eng_listing(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE,
      p_engine_series         giis_mc_eng_series.engine_series%TYPE
   )
     RETURN eng_tab PIPELINED;
     
   FUNCTION get_subline_lov(
      p_find_text             VARCHAR2
   )
     RETURN subline_tab PIPELINED;
     
   FUNCTION get_company_lov(
      p_find_text             VARCHAR2
   )
     RETURN company_tab PIPELINED;
     
   PROCEDURE val_del_rec(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE
   );
   
   PROCEDURE del_rec(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE
   );
   
   PROCEDURE val_add_rec(
      p_action                VARCHAR2,-- andrew - 08052015 - SR 19241
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE,
      p_make                  giis_mc_make.make%TYPE,-- andrew - 08052015 - SR 19241
      p_subline_cd            giis_mc_make.subline_cd%TYPE,-- andrew - 08052015 - SR 19241
      p_no_of_pass            giis_mc_make.no_of_pass%TYPE-- andrew - 08052015 - SR 19241
   );
   
   PROCEDURE set_rec(
      p_rec                   giis_mc_make%ROWTYPE
   );
   
   PROCEDURE val_del_eng(
      p_make_cd               giis_mc_eng_series.make_cd%TYPE,
      p_car_company_cd        giis_mc_eng_series.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE
   );
   
   PROCEDURE del_eng(
      p_make_cd               giis_mc_eng_series.make_cd%TYPE,
      p_car_company_cd        giis_mc_eng_series.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE
   );
   
   PROCEDURE val_add_eng(
      p_action                VARCHAR2, -- andrew - 08052015 - SR 19241   
      p_make_cd               giis_mc_eng_series.make_cd%TYPE,
      p_car_company_cd        giis_mc_eng_series.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE,
      p_engine_series         giis_mc_eng_series.engine_series%TYPE
   );
   
   PROCEDURE set_eng(
      p_rec                   giis_mc_eng_series%ROWTYPE
   );
   
END;
/


