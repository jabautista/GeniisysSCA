CREATE OR REPLACE PACKAGE CPI.GIPIR039E_PKG
AS
   TYPE gipir039e_type IS RECORD (
      policy_no         VARCHAR2(50),
      sum_tsi           NUMBER(21,2),
      sum_prem_amt      NUMBER(21,2),
      zone_no           NUMBER(16),
      zone_type         NUMBER(16),
      fi_item_grp       VARCHAR2(2),
      zone_grp1         VARCHAR2(2),
      trty_type_cd      VARCHAR2(2),
      item_grp_name     VARCHAR2(100),
      zone_grp_name     VARCHAR2(50),
      not_exist         VARCHAR2(1)  
   );
   
   TYPE gipir039e_tab IS TABLE OF gipir039e_type;
   
   FUNCTION get_gipir039e(
        p_zone_type     VARCHAR2,
        p_trty_type_cd  VARCHAR2,
        p_as_of_sw      VARCHAR2
   )
   RETURN gipir039e_tab PIPELINED;
   
   TYPE gipir039e_header_type IS RECORD(
       company_name        VARCHAR2(100),
       company_address     VARCHAR2(250),
       report_title        VARCHAR2(200),
       report_date         VARCHAR2(200),
       report_trty_head    VARCHAR2(100)
   );
    
   TYPE gipir039e_header_tab IS TABLE OF gipir039e_header_type;
    
   FUNCTION get_gipir039e_header(
        p_zone_type     VARCHAR2,
        p_trty_cd       VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
   )
    RETURN gipir039e_header_tab PIPELINED;

   FUNCTION get_gipir039e_v2(
        p_zone_type     VARCHAR2,
        p_trty_type_cd  VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_user_id       VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2
   )
   RETURN gipir039e_tab PIPELINED;  

    TYPE main_report_type IS RECORD(
        company_name            giac_parameters.param_value_v%type,
        company_address         giac_parameters.param_value_v%type,
        title                   VARCHAR2(200),
        header                  VARCHAR2(100),
        print_details           VARCHAR2(1),
        
        zone_no                 NUMBER(16),
        zone_type               NUMBER(16),
        zone_grp                VARCHAR2(2),
        zone_grp1               VARCHAR2(2),
        cf_zone_grp             VARCHAR2(20),
        policy_id               GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type,
        policy_no               VARCHAR2(100),
        total_tsi               NUMBER(21,2),
        total_prem              NUMBER(21,2),
        item_grp_name           VARCHAR2(100),
        fi_item_grp             VARCHAR2(2)
    );
    
    TYPE main_report_tab IS TABLE OF main_report_type;

    FUNCTION populate_main_report_v2(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2
    ) RETURN main_report_tab PIPELINED;   
    
    TYPE recap_type IS RECORD(
        cf_bldg_pol_cnt         NUMBER,
        cf_bldg_tsi_amt         NUMBER(21,2),
        cf_bldg_prem_amt        NUMBER(21,2),
        cf_content_pol_cnt      NUMBER,
        cf_content_tsi_amt      NUMBER(21,2),
        cf_content_prem_amt     NUMBER(21,2),
        cf_loss_pol_cnt         NUMBER,
        cf_loss_tsi_amt         NUMBER(21,2),
        cf_loss_prem_amt        NUMBER(21,2),
        cf_grnd_bldg_pol_cnt    NUMBER,
        cf_grnd_bldg_tsi_amt    NUMBER(21,2),
        cf_grnd_bldg_prem_amt   NUMBER(21,2)
    );
    
    TYPE recap_tab IS TABLE OF recap_type;
    
    FUNCTION populate_recap(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2, --edgar 05/22/2015 SR 4318
        p_risk_cnt      VARCHAR2 --edgar 05/22/2015 SR 4318
    ) RETURN recap_tab PIPELINED;             
    
   TYPE gipir039c_dtls_type IS RECORD (
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      cf_rep_title         VARCHAR2 (200),
      cf_date_title        VARCHAR2 (100),
      cf_rep_header        VARCHAR2 (100), --edgar 05/22/2015 SR 4318
      policy_no1           VARCHAR2 (100),
      zone_no              gipi_firestat_extract_dtl.zone_no%TYPE,
      zone_type            gipi_firestat_extract_dtl.zone_type%TYPE,
      zone_grp1            giis_flood_zone.zone_grp%TYPE,
      policy_id            gipi_polbasic.policy_id%TYPE,
      zone_grp             giis_flood_zone.zone_grp%TYPE,
      cf_zone_grp          VARCHAR2 (20),
      item_grp_name        VARCHAR2(100),
      fi_item_grp          VARCHAR2(2),
      total_tsi               NUMBER(21,2),
      total_prem              NUMBER(21,2)            
   );

   TYPE gipir039c_dtls_tab IS TABLE OF gipir039c_dtls_type;
   
   FUNCTION get_gipir039c_dtls (
      p_as_of_sw    VARCHAR2,
      p_as_of_date  DATE,
      p_from_date   DATE,  --edgar 05/22/2015 SR 4318
      p_to_date     DATE,
      p_zone_type   VARCHAR2,
      p_user_id     VARCHAR2, --edgar 05/22/2015 SR 4318
      p_print_sw      VARCHAR2, --edgar 05/22/2015 SR 4318
      p_trty_type_cd  VARCHAR2   --edgar 05/22/2015 SR 4318
   )
      RETURN gipir039c_dtls_tab PIPELINED;    
      
    FUNCTION populate_recap_net(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2, --edgar 05/22/2015 SR 4318
        p_risk_cnt      VARCHAR2, --edgar 05/22/2015 SR 4318
        p_print_sw      VARCHAR2, --edgar 05/22/2015 SR 4318
        p_trty_type_cd  VARCHAR2 --edgar 05/22/2015 SR 4318
    ) RETURN recap_tab PIPELINED;          
END;
/

CREATE OR REPLACE PUBLIC SYNONYM GIPIR039E_PKG FOR CPI.GIPIR039E_PKG; --edgar 05/22/2015 SR 4318