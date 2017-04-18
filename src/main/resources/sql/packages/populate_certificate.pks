CREATE OR REPLACE PACKAGE CPI.POPULATE_CERTIFICATE AS
/******************************************************************************
   NAME:       POPULATE_CERTIFICATE
   PURPOSE:    For populating certificate documents

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/4/2011            Grace    Created this package.
******************************************************************************/
  TYPE casualty_type IS RECORD (
     policy_no                  VARCHAR2(50),
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     LOCATION                   GIPI_CASUALTY_ITEM.LOCATION%TYPE,
     item_title                 GIPI_ITEM.item_title%TYPE,
     tsi_amt                    VARCHAR2(50),
     effectivity                VARCHAR2(50),
     mortg_name                 GIIS_MORTGAGEE.mortg_name%TYPE,
     issue_date                 VARCHAR2(50),
     expiry_date                VARCHAR2(50),          --added by gino
     issue_date_DDth            VARCHAR2(50) --* Added by Windell ON June 9, 2011; Date format example -> 9th of June 2011
   );
    
  TYPE casualty_tab IS TABLE OF casualty_type;

  FUNCTION Populate_Casualty_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN casualty_tab PIPELINED;
    
  TYPE hull_type IS RECORD (
     policy_no                  VARCHAR2(50),
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     tsi_amt                    VARCHAR2(50),
     effectivity                VARCHAR2(50),
     mortg_name                 GIIS_MORTGAGEE.mortg_name%TYPE,
     issue_date                 VARCHAR2(50),
     issue_date_ii              VARCHAR2(50),--added by gino
     vessel_name                GIIS_VESSEL.vessel_name%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%type,--added by gino
     line_cd                    GIPI_POLBASIC.line_cd%type--added by gino
   );
    
  TYPE hull_tab IS TABLE OF hull_type;
  
  FUNCTION Populate_Hull_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN hull_tab PIPELINED;
    
  TYPE aviation_type IS RECORD (
     policy_no                  VARCHAR2(50),
     assd_name                     GIIS_ASSURED.assd_name%TYPE,
     tsi_amt                    VARCHAR2(50),
     effectivity                VARCHAR2(50),
     air_desc               GIIS_AIR_TYPE.AIR_desc%TYPE, -- ABIE 06152011
     year_built                 GIIS_VESSEL.year_built%TYPE,
     rpc_no                     GIIS_VESSEL.rpc_no%TYPE,
     mortg_name                 GIIS_MORTGAGEE.mortg_name%TYPE,
     issue_date                 VARCHAR2(50),
     issue_date_ii              VARCHAR2(50)--added by gino
   );
    
  TYPE aviation_tab IS TABLE OF aviation_type;
         
  FUNCTION Populate_Aviation_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN aviation_tab PIPELINED;
  
  TYPE itmperil_type IS RECORD (
     policy_id            gipi_itmperil.policy_id%TYPE,
     item_no            gipi_itmperil.item_no%TYPE,
     peril_name                GIIS_PERIL.peril_name%TYPE,
     tsi_amt                   VARCHAR2(50),
     short_name                GIIS_CURRENCY.short_name%TYPE,
     prem_amt                  VARCHAR2(50)
   );
    
  TYPE itmperil_tab IS TABLE OF itmperil_type;      
  
  FUNCTION Populate_Itmperil (p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
                              p_item_no      GIPI_ITEM.item_no%TYPE)     
    RETURN itmperil_tab PIPELINED;
    
  TYPE accident_type IS RECORD (
     policy_no                  VARCHAR2(50),
     item_no                    gipi_item.item_no%TYPE,
     item_title                 GIPI_ITEM.item_title%TYPE,
     address                    VARCHAR2(200),
     position                   GIIS_POSITION.position%TYPE,
     birthday                   VARCHAR2(50),
     effectivity                VARCHAR2(50)
   );
    
  TYPE accident_tab IS TABLE OF accident_type;       
  
  
  FUNCTION Populate_Accident_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN accident_tab PIPELINED;

  FUNCTION Populate_Accident_cert_one (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN accident_tab PIPELINED;    
  
  TYPE engineering_type IS RECORD (
     policy_no                  VARCHAR2(50),
     assd_name                     GIIS_ASSURED.assd_name%TYPE,
     site_location              GIPI_ENGG_BASIC.site_location%TYPE,
     effectivity                VARCHAR2(50),
     mortg_name                 GIIS_MORTGAGEE.mortg_name%TYPE,
     eff_date                   VARCHAR2(50),--added by gino
     issue_date                 VARCHAR2(50),--added by gino
     issue_date_DDth            VARCHAR2(50) --* Added by Windell ON June 9, 2011; Date format example -> 9th of June 2011
   );
    
  TYPE engineering_tab IS TABLE OF engineering_type;
  
  FUNCTION Populate_Engineering_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN engineering_tab PIPELINED;
      
          
  TYPE fire_type IS RECORD (
     policy_no                  VARCHAR2(50),
     assd_name                     GIIS_ASSURED.assd_name%TYPE,
     loc_risk                   VARCHAR2(200),
     effectivity                VARCHAR2(50),
     mortg_name                 GIIS_MORTGAGEE.mortg_name%TYPE,
     issue_day                  VARCHAR2(20),
     issue_month_year           VARCHAR2(20)
   );
    
  TYPE fire_tab IS TABLE OF fire_type;
  
  FUNCTION Populate_Fire_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN fire_tab PIPELINED;      
        

  TYPE cargo_type IS RECORD (
     policy_no                  VARCHAR2(50),
     policy_id                    gipi_item.policy_id%TYPE,
     item_no                    gipi_item.item_no%TYPE,
     assd_name                     GIIS_ASSURED.assd_name%TYPE,
     item_title                 GIPI_ITEM.item_title%TYPE,
     invoice                    VARCHAR2(50),
     origin                     VARCHAR2(50),
     destn                      VARCHAR2(50),
     vestype_desc               GIIS_VESTYPE.vestype_desc%TYPE,
     tsi_amt                    gipi_item.tsi_amt%type,
     issue_day                  VARCHAR2(20),
     issue_month_year           VARCHAR2(20)
   );
    
  TYPE cargo_tab IS TABLE OF cargo_type;
  
  FUNCTION Populate_Cargo_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)   
    RETURN cargo_tab PIPELINED;       

  TYPE signatory_type IS RECORD (
    signatory                  GIIS_SIGNATORY_NAMES.signatory%TYPE,
    designation                   GIIS_SIGNATORY_NAMES.designation%TYPE,
    res_cert_no                     GIIS_SIGNATORY_NAMES.res_cert_no%TYPE,
    res_cert_place               GIIS_SIGNATORY_NAMES.res_cert_place%TYPE,
    res_cert_date               GIIS_SIGNATORY_NAMES.res_cert_date%TYPE
  );  
   TYPE signatory_tab IS TABLE OF signatory_type;
   
  FUNCTION Populate_text_for_Signatory (p_iss_cd    GIIS_SIGNATORY.iss_cd%TYPE,
                                        p_line_cd   GIIS_SIGNATORY.line_cd%TYPE)   
    RETURN signatory_tab PIPELINED; 
  
  FUNCTION get_spelled_number (p_number    VARCHAR2)
    RETURN VARCHAR2;

  TYPE mc_type IS RECORD (---------Populate_MC_cert---------gino 5.10.11
    POLICY_ID    NUMBER(12),
    ITEM_NO      NUMBER(9),
    POLICY_NO    VARCHAR2(4000 BYTE),
    ITEM_TITLE   VARCHAR2(250 BYTE),
    ASSD_NAME    VARCHAR2(500 BYTE),
    PLATE_NO     VARCHAR2(10 BYTE),
    COLOR        VARCHAR2(50 BYTE),
    MOTOR_NO     VARCHAR2(20 BYTE),
    MORTG_NAME   VARCHAR2(50 BYTE),
    ISSUE_DATE   VARCHAR2(30 BYTE),
    EFFECTIVITY  VARCHAR2(30 BYTE),
    SERIAL_NO    VARCHAR2(25 BYTE)
  );  
   TYPE mc_tab IS TABLE OF mc_type;
   
FUNCTION populate_mc_cert (
   p_policy_id   gipi_polbasic.policy_id%TYPE--,
   --p_item_no     gipi_item.item_no%TYPE
)                               
   RETURN mc_tab PIPELINED; ---------Populate_MC_cert---------end gino 5.10.11
   
-- start --
-- Populate_Bond_Cert --
  TYPE bond_type IS RECORD (
    POLICY_ID    GIPI_POLBASIC.POLICY_ID%TYPE,
    ISS_CD      GIPI_POLBASIC.ISS_CD%TYPE,
    LINE_CD     GIPI_POLBASIC.LINE_CD%TYPE,
    POLICY_NO    VARCHAR2(4000 BYTE),
    ASSD_NAME    GIIS_ASSURED.ASSD_NAME%TYPE,
    SUBLINE_NAME GIIS_SUBLINE.SUBLINE_NAME%TYPE,
    TSI_AMT      VARCHAR2(2000),
    EFF_DATE     GIPI_POLBASIC.EFF_DATE%TYPE,
    EXPIRY_DATE  GIPI_POLBASIC.EXPIRY_DATE%TYPE,
    CONTRACT_DTL GIPI_BOND_BASIC.CONTRACT_DTL%TYPE,
    INTM_NAME    GIIS_INTERMEDIARY.INTM_NAME%TYPE,
    PRIN_SIGNOR  GIIS_PRIN_SIGNTRY.PRIN_SIGNOR%TYPE,
    OBLIGEE_NAME    GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
    BOND_DTL        GIPI_BOND_BASIC.BOND_DTL%TYPE,
    INDEMNITY_TEXT  GIPI_BOND_BASIC.INDEMNITY_TEXT%TYPE,
    REMARKS         GIPI_BOND_BASIC.REMARKS%TYPE
  );  
   TYPE bond_tab IS TABLE OF bond_type;
   
FUNCTION Populate_Bond_Cert (p_policy_id   gipi_polbasic.policy_id%TYPE)          
                     
   RETURN bond_tab PIPELINED;
-- end of policy_bond_cert --

-- Populate_Bond_Cert --
  TYPE or_type IS RECORD (
    ROW_NUM      GIAC_DIRECT_PREM_COLLNS.INST_NO%TYPE,
    POLICY_NO    VARCHAR2(4000 BYTE),
    EFF_DATE     GIPI_POLBASIC.EFF_DATE%TYPE,
    EXPIRY_DATE  GIPI_POLBASIC.EXPIRY_DATE%TYPE,
    OR_DATE      GIAC_ORDER_OF_PAYTS.OR_DATE%TYPE,
    /*OR_NO        GIAC_ORDER_OF_PAYTS.OR_NO%TYPE*/ -- commented out by adpascual 07.16.2012 
	OR_NO		 VARCHAR2(2000 BYTE)
  );  
   TYPE or_tab IS TABLE OF or_type;
   
FUNCTION Populate_text_for_OR (p_policy_id   gipi_polbasic.policy_id%TYPE)          
                     
   RETURN or_tab PIPELINED;
-- end of populate_text_for_or --
-- abie 06212011   
   
END;
/


