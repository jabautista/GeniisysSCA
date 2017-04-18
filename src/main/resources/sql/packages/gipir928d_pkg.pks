CREATE OR REPLACE PACKAGE CPI.GIPIR928D_PKG
AS
	
	 TYPE report_type IS RECORD(
            line_name           giis_line.line_name%TYPE,
            subline_name        giis_subline.subline_name%TYPE,
			policy_no           gipi_uwreports_dist_peril_ext.policy_no%TYPE,
            nr_dist_tsi         gipi_uwreports_dist_peril_ext.nr_dist_tsi%TYPE,
            nr_dist_prem        gipi_uwreports_dist_peril_ext.nr_dist_prem%TYPE,
            tr_dist_tsi         gipi_uwreports_dist_peril_ext.tr_dist_tsi%TYPE,
            tr_dist_prem        gipi_uwreports_dist_peril_ext.tr_dist_prem%TYPE,
            fa_dist_tsi         gipi_uwreports_dist_peril_ext.fa_dist_tsi%TYPE,
            fa_dist_prem        gipi_uwreports_dist_peril_ext.fa_dist_prem%TYPE,
            total_sum_sinsured  NUMBER(20,2),
            total_premium       NUMBER(20,2),
            company_name        VARCHAR(100),
            company_address     giis_parameters.param_value_v%TYPE, -- VARCHAR2(100), changed by robert 01.02.14 
            toggle              VARCHAR2(25),
            date_to             DATE,
            date_from           DATE,
            based_on            VARCHAR2(50)
                        
    );
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION populate_gipir928d( P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type,
                            P_ISS_PARAM NUMBER, 
                            P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
                            P_SCOPE NUMBER, 
                            P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
                            p_user_id    gipi_uwreports_dist_peril_ext.user_id%TYPE)
    RETURN report_tab PIPELINED;
    
	
END gipir928D_pkg;
/


