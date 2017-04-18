CREATE OR REPLACE PACKAGE CPI.Upd_Floater_CSV_Pkg AS

TYPE Gipi_Floater_Type IS RECORD
 (RECORD_NO               NUMBER(9),
  ITEM_NO                 NUMBER(9),
  ITEM_TITLE              VARCHAR2(50 BYTE),
  CURRENCY_CD             NUMBER(2),
  CURRENCY_RT             NUMBER(12,9),
  ITEM_DESC               VARCHAR2(2000 BYTE),
  ITEM_DESC2              VARCHAR2(2000 BYTE),
  LOCATION_CD             NUMBER(5),
  REGION_CD               NUMBER(2),
  LOCATION                VARCHAR2(150 BYTE),
  LIMIT_OF_LIABILITY      VARCHAR2(500 BYTE),
  INTEREST_ON_PREMISES    VARCHAR2(500 BYTE),
  SECTION_OR_HAZARD_INFO  VARCHAR2(2000 BYTE),
  CONVEYANCE_INFO         VARCHAR2(60 BYTE),
  PROPERTY_NO_TYPE        VARCHAR2(1 BYTE),
  PROPERTY_NO             VARCHAR2(30 BYTE),
  PERIL_CD                NUMBER(5),
  PREM_RT                 NUMBER(12,9),
  TSI_AMT                 NUMBER(16,2),
  PREM_AMT                NUMBER(12,2),
  AGGREGATE_SW            VARCHAR2(1 BYTE),
  RI_COMM_RATE            NUMBER(12,9),
  RI_COMM_AMT             NUMBER(14,2),
  DED_DEDUCTIBLE_CD       VARCHAR2(5 BYTE));

PROCEDURE Split_Perlfloater(line_to_split           IN VARCHAR2,
                            record_no              OUT NUMBER,
                            item_no                OUT NUMBER,
                            item_title             OUT VARCHAR2,
                            currency_cd            OUT NUMBER,
                            currency_rt            OUT NUMBER,
                            item_desc              OUT VARCHAR2,
                            item_desc2             OUT VARCHAR2,
                            location_cd            OUT NUMBER,
                            region_cd              OUT NUMBER,
                            location               OUT VARCHAR2,
                            limit_of_liability     OUT VARCHAR2,
                            interest_on_premises   OUT VARCHAR2,
                            section_or_hazard_info OUT VARCHAR2,
                            conveyance_info        OUT VARCHAR2,
                            property_no_type       OUT VARCHAR2,
                            property_no            OUT VARCHAR2,
                            PERIL_CD               OUT NUMBER,
                            PREM_rt                OUT NUMBER,
                            TSI_AMT                OUT NUMBER,
                            PREM_AMT               OUT NUMBER,
                            AGGREGATE_SW           OUT VARCHAR2,
                            RI_COMM_RATE           OUT NUMBER,
                            RI_COMM_AMT            OUT NUMBER,
                            ded_deductible_cd      OUT VARCHAR2);


PROCEDURE Upd_Floater_Peril (p_filename        IN VARCHAR2,
                             p_par_id          IN NUMBER,
                             p_line_cd         IN VARCHAR2,
                             p_subline_cd      IN VARCHAR2,
                             p_upload_no       IN NUMBER,
                             upload_ctr       OUT NUMBER,
                             total_rec        OUT NUMBER,
                             duplicate_ctr    OUT NUMBER,
                             p_message        OUT VARCHAR2);

PROCEDURE split_itmfloater(line_to_split            IN VARCHAR2,
                           record_no              OUT NUMBER,
                           item_no                OUT NUMBER,
                           item_title             OUT VARCHAR2,
                           currency_cd            OUT NUMBER,
                           currency_rt            OUT NUMBER,
                           item_desc              OUT VARCHAR2,
                           item_desc2             OUT VARCHAR2,
                           location_cd            OUT NUMBER,
                           region_cd              OUT NUMBER,
                           location               OUT VARCHAR2,
                           limit_of_liability     OUT VARCHAR2,
                           interest_on_premises   OUT VARCHAR2,
                           section_or_hazard_info OUT VARCHAR2,
                           conveyance_info        OUT VARCHAR2,
                           property_no_type       OUT VARCHAR2,
                           property_no            OUT VARCHAR2,
                           ded_deductible_cd      OUT VARCHAR2);

PROCEDURE Upd_Floater_Item  (p_filename        IN VARCHAR2,
                             p_par_id          IN NUMBER,
                             p_line_cd         IN VARCHAR2,
                             p_subline_cd      IN VARCHAR2,
                             p_upload_no       IN NUMBER,
                             upload_ctr       OUT NUMBER,
                             total_rec        OUT NUMBER,
                             duplicate_ctr    OUT NUMBER,
                             p_message        OUT VARCHAR2);

PROCEDURE Upd_Gipi_Witem_Tab (p_par_id IN NUMBER);

FUNCTION Check_Duration (pdate1  IN  DATE,
                         pdate2  IN  DATE) RETURN number;

END Upd_Floater_CSV_Pkg;
/


