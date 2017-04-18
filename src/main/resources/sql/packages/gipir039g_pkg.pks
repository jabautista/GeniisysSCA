CREATE OR REPLACE PACKAGE CPI.GIPIR039G_PKG
AS

    TYPE main_report_type IS RECORD(
        company_name            giac_parameters.param_value_v%type,
        company_address         giac_parameters.param_value_v%type,
        title                   VARCHAR2(200),
        header                  VARCHAR2(100),
        print_details           VARCHAR2(1),
        
        zone_no                 GIPI_FIRESTAT_EXTRACT_DTL.ZONE_NO%type,
        zone_type               GIPI_FIRESTAT_EXTRACT_DTL.ZONE_TYPE%type,
        zone_grp                GIIS_FLOOD_ZONE.ZONE_GRP%type,
        zone_grp1               GIIS_FLOOD_ZONE.ZONE_GRP%type,
        cf_zone_grp             VARCHAR2(20),
        policy_id               GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type,
        policy_no               VARCHAR2(100),
        total_tsi               NUMBER(18,2),
        total_prem              NUMBER(18,2)
    );
    
    TYPE main_report_tab IS TABLE OF main_report_type;
    
    
    FUNCTION populate_main_report(
        p_zone_type     VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2
    ) RETURN main_report_tab PIPELINED;
    
    
    FUNCTION CF_BLDG_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_CONTENT_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_LOSS_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
    FUNCTION CF_BLDG_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_CONTENT_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_LOSS_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
    FUNCTION CF_BLDG_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_CONTENT_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_LOSS_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
    FUNCTION CF_GRND_BLDG_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_GRND_BLDG_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
    
     FUNCTION CF_GRND_BLDG_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER;
    
        
    TYPE recap_type IS RECORD(
        cf_bldg_pol_cnt         NUMBER,
        cf_bldg_tsi_amt         NUMBER(18,2),
        cf_bldg_prem_amt        NUMBER(18,2),
        cf_content_pol_cnt      NUMBER,
        cf_content_tsi_amt      NUMBER(18,2),
        cf_content_prem_amt     NUMBER(18,2),
        cf_loss_pol_cnt         NUMBER,
        cf_loss_tsi_amt         NUMBER(18,2),
        cf_loss_prem_amt        NUMBER(18,2),
        cf_grnd_bldg_pol_cnt    NUMBER,
        cf_grnd_bldg_tsi_amt    NUMBER(18,2),
        cf_grnd_bldg_prem_amt   NUMBER(18,2)
    );
    
    TYPE recap_tab IS TABLE OF recap_type;
    
    FUNCTION populate_recap(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,  
        p_user_id       VARCHAR2
    ) RETURN recap_tab PIPELINED;
    
    
    TYPE matrix_title_type IS RECORD(
        dummy_cd      VARCHAR2(1),
        fi_item_grp   VARCHAR2 (50)
    );
    
    TYPE matrix_title_tab IS TABLE OF matrix_title_type;
    
    FUNCTION get_matrix_title(
        p_user_id   VARCHAR2
    ) RETURN matrix_title_tab PIPELINED;
    
    
    TYPE matrix_details_type IS RECORD(
        zone_no                 GIPI_FIRESTAT_EXTRACT_DTL.ZONE_NO%type,
        zone_grp                GIIS_FLOOD_ZONE.ZONE_GRP%type,
        zone_type               GIPI_FIRESTAT_EXTRACT_DTL.ZONE_TYPE%type,
        policy_id               GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type,
        policy_no               VARCHAR2(100),        
        dummy_cd                VARCHAR2(1),
        fi_item_grp             VARCHAR2(50),
        share_tsi               NUMBER(18,2),
        share_prem              NUMBER(18,2)
    );
    
    TYPE matrix_details_tab IS TABLE OF matrix_details_type;
    
    FUNCTION populate_matrix_details(
        p_zone_type     VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2,
        p_policy_id     GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type,
        p_zone_no       GIPI_FIRESTAT_EXTRACT_DTL.ZONE_NO%type
    ) RETURN matrix_details_tab PIPELINED;
    
    
    TYPE matrix_subtotal_type IS RECORD(
        zone_grp            GIIS_FLOOD_ZONE.ZONE_GRP%type,  
        fi_item_grp         VARCHAR2(50),
        zone_tot_tsi        NUMBER(18,2),
        zone_tot_prem       NUMBER(18,2)
    );
    
    TYPE matrix_subtotal_tab IS TABLE OF matrix_subtotal_type;
    
    
    FUNCTION get_matrix_subtotal(
        p_zone_type     VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2,
        p_zone_grp      GIIS_FLOOD_ZONE.ZONE_GRP%type
    ) RETURN matrix_subtotal_tab PIPELINED;
    
    
    TYPE matrix_total_type IS RECORD(
        fi_item_grp         VARCHAR2(50),
        zone_grnd_tot_tsi   NUMBER(18,2),
        zone_grnd_tot_prem  NUMBER(18,2)
    );
    
    TYPE matrix_total_tab IS TABLE OF matrix_total_type;
    
    
    FUNCTION get_matrix_total(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2
    ) RETURN matrix_total_tab PIPELINED;
    
END GIPIR039G_PKG;
/


