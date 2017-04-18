CREATE OR REPLACE PACKAGE CPI.GIPIR928B_PKG
AS
    TYPE get_line_type IS RECORD(
                        line_name           GIIS_LINE.line_name%TYPE,
                        line_cd             GIIS_LINE.line_cd%TYPE,
                        net_ret_tsi         NUMBER(20,2),
                        net_ret_prem        NUMBER(20,2),
                        treaty_tsi          NUMBER(20,2),
                        treaty_prem         NUMBER(20,2),
                        facultative_tsi     NUMBER(20,2),
                        facultative_prem   NUMBER(20,2),
                        total_tsi          NUMBER(20,2),
                        total_premium      NUMBER(20,2),
                        v_company           giis_parameters.param_value_v%TYPE,
                        address             giis_parameters.param_value_v%TYPE, -- VARCHAR2(100), changed by robert 01.02.14 
                        fromto_date         VARCHAR2(100),
                        based_on            VARCHAR2(50),
                        policy_label        VARCHAR2(50)
                        
                        );
    TYPE gipir928b_tab IS TABLE OF get_line_type;
    TYPE get_subline_type IS RECORD(
                        subline_cd          GIIS_SUBLINE.subline_cd%TYPE,
                        net_ret_tsi         NUMBER(20,2),
                        net_ret_prem        NUMBER(20,2),
                        treaty_tsi          NUMBER(20,2),
                        treaty_prem         NUMBER(20,2),
                        facultative_tsi     NUMBER(20,2),
                        facultative_prem   NUMBER(20,2),
                        total_tsi          NUMBER(20,2),
                        total_premium      NUMBER(20,2)
                        );
    TYPE gipir928b_subline_tab IS TABLE OF get_subline_type;
    TYPE get_policy_type IS RECORD(
                        policy_no           GIPI_UWREPORTS_DIST_PERIL_EXT.policy_no%TYPE,
                        net_ret_tsi         NUMBER(20,2),
                        net_ret_prem        NUMBER(20,2),
                        treaty_tsi          NUMBER(20,2),
                        treaty_prem         NUMBER(20,2),
                        facultative_tsi     NUMBER(20,2),
                        facultative_prem   NUMBER(20,2),
                        total_tsi          NUMBER(20,2),
                        total_premium      NUMBER(20,2)
                        );
    TYPE gipir928b_policy_tab IS TABLE OF get_policy_type;
    FUNCTION get_line (P_SUBLINE_CD GIIS_SUBLINE.SUBLINE_CD%TYPE, 
                       P_SCOPE NUMBER, 
                       P_ISS_CD GIPI_UWREPORTS_DIST_PERIL_EXT.ISS_CD%TYPE,
                       P_LINE_CD GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE, 
                       P_ISS_PARAM NUMBER,
                       p_user_id    GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
    RETURN gipir928b_tab PIPELINED;
    FUNCTION get_subline (P_SUBLINE_CD GIIS_SUBLINE.SUBLINE_CD%TYPE, 
                           P_SCOPE NUMBER, 
                           P_ISS_CD GIPI_UWREPORTS_DIST_PERIL_EXT.ISS_CD%TYPE,
                           P_LINE_CD GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE, 
                           P_ISS_PARAM NUMBER,
                           P_LINE_CD1 GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE,
                           p_user_id    GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
    RETURN gipir928b_subline_tab PIPELINED;
    FUNCTION get_policy (P_SUBLINE_CD GIIS_SUBLINE.SUBLINE_CD%TYPE, 
                           P_SCOPE NUMBER, 
                           P_ISS_CD GIPI_UWREPORTS_DIST_PERIL_EXT.ISS_CD%TYPE,
                           P_LINE_CD GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE, 
                           P_ISS_PARAM NUMBER,
                           P_LINE_CD1 GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE,
                           P_SUBLINE_CD1 GIIS_SUBLINE.SUBLINE_CD%TYPE,
                           p_user_id    GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
    RETURN gipir928b_policy_tab PIPELINED;
END; 
/


DROP PUBLIC SYNONYM GIPIR928B_PKG;

CREATE PUBLIC SYNONYM GIPIR928B_PKG FOR CPI.GIPIR928B_PKG;


