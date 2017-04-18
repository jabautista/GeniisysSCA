CREATE OR REPLACE PACKAGE CPI.GIISS223_PKG AS

    TYPE mc_fmv_source_list_type IS RECORD
    (car_company        GIIS_MC_CAR_COMPANY.car_company%TYPE,
     car_company_cd     GIIS_MC_CAR_COMPANY.car_company_cd%TYPE,
     make               GIIS_MC_MAKE.make%TYPE,
     make_cd            GIIS_MC_MAKE.make_cd%TYPE,
     engine_series      GIIS_MC_ENG_SERIES.engine_series%TYPE,
     series_cd          GIIS_MC_ENG_SERIES.series_cd%TYPE     
    );        
    TYPE mc_fmv_source_list_tab IS TABLE OF mc_fmv_source_list_type;
    
    TYPE mc_fmv_maintenance_type IS RECORD
    (car_company_cd     GIIS_MC_FMV.car_company_cd%TYPE,
     make_cd            GIIS_MC_FMV.make_cd%TYPE,
     series_cd          GIIS_MC_FMV.series_cd%TYPE,
     model_year         GIIS_MC_FMV.model_year%TYPE,
     hist_no            GIIS_MC_FMV.hist_no%TYPE,
     eff_date           VARCHAR2(100),
     fmv_value          GIIS_MC_FMV.fmv_value%TYPE,
     fmv_value_min      GIIS_MC_FMV.fmv_value_min%TYPE,
     fmv_value_max      GIIS_MC_FMV.fmv_value_max%TYPE,
     delete_sw          GIIS_MC_FMV.delete_sw%TYPE,
     max_sequence       NUMBER (5),
     last_eff_date      VARCHAR2(100),
     user_id            GIIS_MC_FMV.user_id%TYPE,
     last_update        VARCHAR2(100)
     );        
    TYPE mc_fmv_maintenance_tab IS TABLE OF mc_fmv_maintenance_type;
          
    TYPE model_year_lov_type IS RECORD (
      model_year         GIIS_MC_FMV.model_year%TYPE
    );
    TYPE model_year_lov_tab IS TABLE OF model_year_lov_type;
    FUNCTION get_mc_fmv_source_list (
      p_user_id     giis_users.user_id%TYPE
      )
    RETURN mc_fmv_source_list_tab PIPELINED;
  
    FUNCTION get_mc_fmv_list(
        p_car_company_cd  IN  GIIS_MC_FMV.car_company_cd%TYPE,
        p_make_cd         IN  GIIS_MC_FMV.make_cd%TYPE,
        p_series_cd       IN  GIIS_MC_FMV.series_cd%TYPE    
    )
        RETURN mc_fmv_maintenance_tab PIPELINED;
    FUNCTION get_model_year_lov (
        p_keyword VARCHAR2
        )
    RETURN model_year_lov_tab PIPELINED;    
    PROCEDURE set_giis_fmv (
        p_fmv    GIIS_MC_FMV%ROWTYPE
    );

END GIISS223_PKG;
/
