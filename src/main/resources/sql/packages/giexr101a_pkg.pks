CREATE OR REPLACE PACKAGE CPI.GIEXR101A_PKG
AS
/**
* Rey Jadlocon
* 02.08.2012
**/
TYPE get_details_type IS RECORD(
                    subline_cd      GIEX_EXPIRIES_V.subline_cd%TYPE,   
                    line_cd         GIEX_EXPIRIES_V.line_cd%TYPE,      
                    issue_yy        GIEX_EXPIRIES_V.issue_yy%TYPE,     
                    pol_seq_no      GIEX_EXPIRIES_V.pol_seq_no%TYPE,   
                    renew_no        GIEX_EXPIRIES_V.renew_no%TYPE,     
                    iss_cd2         GIEX_EXPIRIES_V.iss_cd%TYPE,      
                    iss_cd          GIEX_EXPIRIES_V.iss_cd%TYPE,       
                    line_cd2        GIEX_EXPIRIES_V.line_cd%TYPE,     
                    policy_no       VARCHAR2(100),    
                    tsi_amt         GIEX_EXPIRIES_V.tsi_amt%TYPE,      
                    prem_amt        GIEX_EXPIRIES_V.prem_amt%TYPE,     
                    tax_amt         GIEX_EXPIRIES_V.tax_amt%TYPE,      
                    expiry_date     GIEX_EXPIRIES_V.expiry_date%TYPE,  
                    line_name       GIIS_LINE.line_name%TYPE,    
                    subline_name    GIIS_SUBLINE.subline_name%TYPE, 
                    policy_id       GIEX_EXPIRIES_V.policy_id%TYPE,    
                    plate_no        GIEX_EXPIRIES_V.plate_no%TYPE,     
                    model_year      GIEX_EXPIRIES_V.model_year%TYPE,   
                    color           GIEX_EXPIRIES_V.color%TYPE,        
                    serialno        GIEX_EXPIRIES_V.serialno%TYPE,    
                    make            GIEX_EXPIRIES_V.make%TYPE,         
                    motor_no        GIEX_EXPIRIES_V.motor_no%TYPE,     
                    item_title      GIEX_EXPIRIES_V.item_title%TYPE,   
                    balance_flag    VARCHAR2(1), 
                    claim_flag      VARCHAR2(1), 
                    ren_prem_amt    GIEX_EXPIRIES_V.ren_prem_amt%TYPE, 
                    ren_tsi_amt     GIEX_EXPIRIES_V.ren_tsi_amt%TYPE,
                    v_company_name  VARCHAR2(100),
                    v_company_address VARCHAR2(500),
                    ending_date     VARCHAR2(100),
                    starting_date   VARCHAR2(100),
                    iss_name        VARCHAR2(100),
                    assured         giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012 [From VARCHAR2(100)]
                    ref_pol_no      VARCHAR2(100),
                    agent           VARCHAR2(100),
                    make_motor      VARCHAR2(100)
                     );
                     
     TYPE get_details_tab IS TABLE OF get_details_type;


FUNCTION get_details(P_POLICY_ID                GIEX_EXPIRIES_V.policy_id%TYPE,
                     P_ASSD_NO                  GIEX_EXPIRIES_V.assd_no%TYPE,
                     P_INTM_NO                  GIEX_EXPIRIES_V.intm_no%TYPE,
                     P_ISS_CD                   GIEX_EXPIRIES_V.iss_cd%TYPE,
                     P_SUBLINE_CD               GIEX_EXPIRIES_V.subline_cd%TYPE,
                     P_LINE_CD                  GIEX_EXPIRIES_V.line_cd%TYPE,
                     P_ENDING_DATE              VARCHAR2,
                     P_STARTING_DATE            VARCHAR2,
                     p_include_pack             VARCHAR2,
                     p_claims_flag              VARCHAR2,
                     p_balance_flag             VARCHAR2)
      RETURN get_details_tab PIPELINED;
      
      
/**
* Rey Jadlocon
* 02-09-2012
**/
FUNCTION cf_item_descformula(p_plate_no     gipi_vehicle.plate_no%TYPE,
                             p_line_cd      gipi_polbasic.line_cd%TYPE,
                             p_subline_cd   gipi_polbasic.subline_cd%TYPE,
                             p_iss_cd       gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy     gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no     gipi_polbasic.renew_no%TYPE)
   RETURN CHAR;

/**
* Rey Jadlocon
* 02-09-2012
**/
FUNCTION cf_makeformula(p_motor_no          gipi_vehicle.motor_no%TYPE,
                        p_cf_item_desc      VARCHAR2,
                        p_make              gipi_vehicle.make%TYPE,
                        p_item_title        varchar2)
   RETURN CHAR;



END GIEXR101A_PKG;
/


