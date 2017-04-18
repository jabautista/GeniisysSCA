CREATE OR REPLACE PACKAGE CPI.GIISS224_PKG AS

    TYPE mc_dep_rate_list_type IS RECORD
    (id                 NUMBER(5),    
     car_company_cd     GIIS_MC_DEP_RATE.car_company_cd%TYPE,
     car_company        GIIS_MC_CAR_COMPANY.car_company%TYPE,
     make_cd            GIIS_MC_DEP_RATE.make_cd%TYPE,
     make               GIIS_MC_MAKE.make%TYPE,     
     model_year         GIIS_MC_DEP_RATE.model_year%TYPE,     
     series_cd          GIIS_MC_DEP_RATE.series_cd%TYPE,   
     engine_series      GIIS_MC_ENG_SERIES.engine_series%TYPE,
     line_cd            GIIS_MC_DEP_RATE.line_cd%TYPE,
     subline_cd         GIIS_MC_DEP_RATE.subline_cd%TYPE,
     subline_name       GIIS_SUBLINE.subline_name%TYPE,        
     subline_type_cd    GIIS_MC_DEP_RATE.subline_type_cd%TYPE,
     subline_type       GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE,
     rate               GIIS_MC_DEP_RATE.rate%TYPE,
     delete_sw          GIIS_MC_DEP_RATE.delete_sw%TYPE,
     user_id            GIIS_MC_FMV.user_id%TYPE,
     last_update        VARCHAR2(100)       
    );        
    TYPE mc_dep_rate_list_tab IS TABLE OF mc_dep_rate_list_type;
         
    TYPE car_company_lov_type IS RECORD (
      car_company_cd      GIIS_MC_DEP_RATE.car_company_cd%TYPE,
      car_company         GIIS_MC_CAR_COMPANY.car_company%TYPE
    );
    TYPE car_company_lov_tab IS TABLE OF car_company_lov_type;
    
    TYPE make_lov_type IS RECORD (
     make_cd            GIIS_MC_DEP_RATE.make_cd%TYPE,
     make               GIIS_MC_MAKE.make%TYPE,
     subline_cd         GIIS_MC_MAKE.subline_cd%TYPE
    );
    TYPE make_lov_tab IS TABLE OF make_lov_type;    
    
    TYPE engine_lov_type IS RECORD (
     series_cd          GIIS_MC_DEP_RATE.series_cd%TYPE,   
     engine_series      GIIS_MC_ENG_SERIES.engine_series%TYPE
    );
    TYPE engine_lov_tab IS TABLE OF engine_lov_type; 
    
    TYPE line_cd_lov_type IS RECORD (
     line_cd            GIIS_MC_DEP_PERIL.line_cd%TYPE,
     line_name          GIIS_LINE.line_name%TYPE
    );
    TYPE line_cd_lov_tab IS TABLE OF line_cd_lov_type;       
    
    TYPE subline_lov_type IS RECORD (
     subline_cd         GIIS_SUBLINE.subline_cd%TYPE,
     subline_name       GIIS_SUBLINE.subline_name%TYPE
    );
    TYPE subline_lov_tab IS TABLE OF subline_lov_type;      
    
    TYPE subline_type_lov_type IS RECORD (
     subline_type_cd    GIIS_MC_DEP_RATE.subline_type_cd%TYPE,
     subline_type       GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE
    );
    TYPE subline_type_lov_tab IS TABLE OF subline_type_lov_type;    
    
    TYPE model_year_list_type IS RECORD (
      model_year         GIIS_MC_DEP_RATE.model_year%TYPE
    );
    TYPE model_year_list_tab IS TABLE OF model_year_list_type;     
    
    TYPE mc_dep_rate_peril_type IS RECORD
    (id                 GIIS_MC_DEP_PERIL.id%TYPE,       
     line_cd            GIIS_MC_DEP_PERIL.line_cd%TYPE,
     line_name          GIIS_LINE.line_name%TYPE,
     peril_cd           GIIS_MC_DEP_PERIL.peril_cd%TYPE,  
     peril_name         GIIS_PERIL.peril_name%TYPE,
     user_id            GIIS_MC_DEP_PERIL.user_id%TYPE,
     last_update        VARCHAR2(100)       
    );        
    TYPE mc_dep_rate_peril_tab IS TABLE OF mc_dep_rate_peril_type;        
    
    TYPE peril_name_lov_type IS RECORD (
     peril_cd           GIIS_MC_DEP_PERIL.peril_cd%TYPE,
     peril_name         GIIS_PERIL.peril_name%TYPE
    );
    TYPE peril_name_lov_tab IS TABLE OF peril_name_lov_type;           
    FUNCTION get_mc_dep_rate_list (
        p_user_id     giis_users.user_id%TYPE
        )
    RETURN mc_dep_rate_list_tab PIPELINED;
      FUNCTION get_car_company_lov (
        p_keyword VARCHAR2
        )
    RETURN car_company_lov_tab PIPELINED;   
        FUNCTION get_make_lov (
        p_keyword VARCHAR2,
        p_car_company_cd      GIIS_MC_DEP_RATE.car_company_cd%TYPE
        )
    RETURN make_lov_tab PIPELINED;    
    FUNCTION get_engine_lov (
        p_keyword VARCHAR2,
        p_car_company_cd      GIIS_MC_DEP_RATE.car_company_cd%TYPE,
        p_make_cd             GIIS_MC_DEP_RATE.make_cd%TYPE
        )
    RETURN engine_lov_tab PIPELINED;   
    FUNCTION get_line_cd_lov (
        p_keyword VARCHAR2,
        p_user_id     giis_users.user_id%TYPE
        )
    RETURN line_cd_lov_tab PIPELINED;   
    FUNCTION get_subline_lov (
        p_keyword VARCHAR2,
        p_line_cd             GIIS_MC_DEP_PERIL.line_cd%TYPE
        )
    RETURN subline_lov_tab PIPELINED;                 
    FUNCTION get_subline_type_lov (
        p_keyword VARCHAR2,
        p_subline_cd          GIIS_MC_DEP_RATE.subline_type_cd%TYPE
        )
    RETURN subline_type_lov_tab PIPELINED;   
    FUNCTION get_model_year_list
    RETURN model_year_list_tab PIPELINED;                        
    PROCEDURE set_giis_mcdr (
        p_mcdr    GIIS_MC_DEP_RATE%ROWTYPE
    );
    FUNCTION validate_add_mc_dep_rate_rec (
        p_id                        GIIS_MC_DEP_RATE.id%TYPE,
        p_car_company_cd            GIIS_MC_DEP_RATE.car_company_cd%TYPE,
	    p_make_cd	                GIIS_MC_DEP_RATE.make_cd%TYPE,
        p_series_cd	                GIIS_MC_DEP_RATE.series_cd%TYPE,   
        p_model_year	            GIIS_MC_DEP_RATE.model_year%TYPE,
        p_line_cd	                GIIS_MC_DEP_RATE.line_cd%TYPE,
        p_subline_cd	            GIIS_MC_DEP_RATE.subline_cd%TYPE,
        p_subline_type_cd	        GIIS_MC_DEP_RATE.subline_type_cd%TYPE
    )
    RETURN VARCHAR2;
    FUNCTION get_mc_dep_rate_peril (
      p_id                          GIIS_MC_DEP_PERIL.id%TYPE,
      p_line_cd                     GIIS_MC_DEP_PERIL.line_cd%TYPE
      )
    RETURN mc_dep_rate_peril_tab PIPELINED;          
    FUNCTION get_peril_name_lov (
        p_keyword VARCHAR2,
        p_line_cd                   GIIS_MC_DEP_PERIL.line_cd%TYPE
        )
    RETURN peril_name_lov_tab PIPELINED;     
    PROCEDURE delete_peril_dep_rate (
        p_id                        GIIS_MC_DEP_PERIL.id%TYPE,
        p_line_cd                   GIIS_MC_DEP_PERIL.line_cd%TYPE,
        p_peril_cd                  GIIS_MC_DEP_PERIL.peril_cd%TYPE        
    );      
    PROCEDURE set_peril_dep_rate (
        p_peril_dep                 GIIS_MC_DEP_PERIL%ROWTYPE           
    );
    FUNCTION validate_peril_rec (
        p_id                        GIIS_MC_DEP_PERIL.id%TYPE
    )
    RETURN VARCHAR2;  
    PROCEDURE delete_peril_rec (
        p_id                        GIIS_MC_DEP_PERIL.id%TYPE        
    );        

END GIISS224_PKG;
/