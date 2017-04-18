CREATE OR REPLACE PACKAGE CPI.GIPIR929B_PKG
AS
    TYPE gipir929b_type IS RECORD (
    
        company_name            GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        company_address         GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        based_on                VARCHAR2(100),
        period_of               VARCHAR2(150),
        
        iss_cd                  GIPI_UWREPORTS_INW_RI_EXT.ISS_CD%TYPE,
        iss_name                VARCHAR2(50),
        ri_cd                   GIPI_UWREPORTS_INW_RI_EXT.RI_CD%TYPE,
        intm_name               VARCHAR2(260),
        line_cd                 GIPI_UWREPORTS_INW_RI_EXT.LINE_CD%TYPE,
        line_name               GIPI_UWREPORTS_INW_RI_EXT.LINE_NAME%TYPE,
        subline_cd              GIPI_UWREPORTS_INW_RI_EXT.SUBLINE_CD%TYPE,   
        subline_name            GIPI_UWREPORTS_INW_RI_EXT.SUBLINE_NAME%TYPE,
        policy_no               VARCHAR2(300),
        policy_id               GIPI_UWREPORTS_INW_RI_EXT.POLICY_ID%TYPE,
        incept_date             GIPI_UWREPORTS_INW_RI_EXT.INCEPT_DATE%TYPE,
        total_tsi               GIPI_UWREPORTS_INW_RI_EXT.TOTAL_TSI%TYPE,
        total_prem              GIPI_UWREPORTS_INW_RI_EXT.TOTAL_PREM%TYPE,
        evat_prem               GIPI_UWREPORTS_INW_RI_EXT.EVATPREM%TYPE,
        lgt                     GIPI_UWREPORTS_INW_RI_EXT.LGT%TYPE,
        doc_stamps              GIPI_UWREPORTS_INW_RI_EXT.DOC_STAMPS%TYPE,
        fst                     GIPI_UWREPORTS_INW_RI_EXT.FST%TYPE,
        other_taxes             GIPI_UWREPORTS_INW_RI_EXT.OTHER_TAXES%TYPE,
        total                   NUMBER(12, 2),
        comm                    GIPI_UWREPORTS_INW_RI_EXT.RI_COMM_AMT%TYPE,
        ri_comm_vat             GIPI_UWREPORTS_INW_RI_EXT.RI_COMM_VAT%TYPE        
    );
    
    TYPE gipir929b_tab IS TABLE OF gipir929b_type;

    FUNCTION get_gipir929b_details (
        --p_assd_no       NUMBER,
        --p_intm_no       NUMBER,
        p_iss_cd        GIPI_UWREPORTS_INW_RI_EXT.CRED_BRANCH%TYPE,
        p_iss_param     VARCHAR2,
        p_line_cd       GIPI_UWREPORTS_INW_RI_EXT.LINE_CD%TYPE,
        p_ri_cd         GIPI_UWREPORTS_INW_RI_EXT.RI_CD%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_INW_RI_EXT.SUBLINE_CD%TYPE,
        p_user_id       GIPI_UWREPORTS_INW_RI_EXT.user_id%TYPE
    
    ) RETURN gipir929b_tab PIPELINED;
    
END; -- end of package specs
/


