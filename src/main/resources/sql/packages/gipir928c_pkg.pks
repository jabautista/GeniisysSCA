CREATE OR REPLACE PACKAGE CPI.GIPIR928C_PKG AS

    TYPE get_main_data_type IS RECORD(
        line_name           giis_line.line_name%TYPE,
        subline_cd          giis_subline.subline_cd%TYPE,
        peril_name          giis_peril.peril_name%TYPE,
        nrdisttsi           gipi_uwreports_dist_peril_ext.nr_dist_tsi%TYPE,
        nrdistprem          gipi_uwreports_dist_peril_ext.nr_dist_prem%TYPE,
        trdisttsi           gipi_uwreports_dist_peril_ext.tr_dist_tsi%TYPE,
        trdistprem          gipi_uwreports_dist_peril_ext.tr_dist_prem%TYPE,
        fadisttsi           gipi_uwreports_dist_peril_ext.fa_dist_tsi%TYPE,
        fadistprem          gipi_uwreports_dist_peril_ext.fa_dist_prem%TYPE,
        totaltsi            NUMBER(20,2),
        totalprem           NUMBER(20,2),
        company_name        VARCHAR(100),
        company_address     giis_parameters.param_value_v%TYPE, -- VARCHAR2(100), changed by robert 01.02.14 
        toggle              VARCHAR2(25),
        date_to             DATE,
        date_from           DATE,
        based_on            VARCHAR2(50)
                        
    );
    TYPE main_tab IS TABLE OF get_main_data_type;
    
    FUNCTION get_main_data(
        p_iss_cd            gipi_uwreports_dist_peril_ext.iss_cd%type,
        p_iss_param         NUMBER, 
        p_line_cd           gipi_uwreports_dist_peril_ext.line_cd%type, 
        p_scope             NUMBER, 
        p_subline_cd        gipi_uwreports_dist_peril_ext.subline_cd%type,
        p_user_id           gipi_uwreports_dist_peril_ext.user_id%TYPE
    )
      RETURN main_tab PIPELINED;
    
END GIPIR928C_PKG;
/


