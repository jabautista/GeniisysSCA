CREATE OR REPLACE PACKAGE CPI.GIEXR102_PKG
AS
/**
* Rey Jadlocon
* 02-29-2012
**/
TYPE get_details_type IS RECORD(
        iss_cd                      GIEX_EXPIRIES_V.iss_cd%TYPE,
        line_cd                     GIEX_EXPIRIES_V.line_cd%TYPE,
        subline_cd                  GIEX_EXPIRIES_V.subline_cd%TYPE,
        issue_yy                    GIEX_EXPIRIES_V.issue_yy%TYPE,
        pol_seq_no                  GIEX_EXPIRIES_V.pol_seq_no%TYPE,
        renew_no                    GIEX_EXPIRIES_V.renew_no%TYPE,
        iss_cd2                     GIEX_EXPIRIES_V.iss_cd%TYPE,
        line_cd2                    GIEX_EXPIRIES_V.line_cd%TYPE,
        subline_cd2                 GIEX_EXPIRIES_V.subline_cd%TYPE,
        policy_no                   varchar2(100),
        tsi_amt                     GIEX_EXPIRIES_V.tsi_amt%TYPE,
        prem_amt                    GIEX_EXPIRIES_V.prem_amt%TYPE,
        tax_amt                     GIEX_EXPIRIES_V.tax_amt%TYPE,
        expiry_date                 GIEX_EXPIRIES_V.expiry_date%TYPE,
        line_name                   varchar2(100),
        subline_name                varchar2(100),
        policy_id                   GIEX_EXPIRIES_V.policy_id%TYPE,
        peril_cd                    varchar2(100),
        prem_amt2                   GIEX_EXPIRIES_V.prem_amt%TYPE,
        tsi_amt2                    GIEX_EXPIRIES_V.tsi_amt%TYPE,
        starting_date               VARCHAR2(100),
        ending_date                 VARCHAR2(100),
        company_name                varchar2(100),
        company_address             varchar2(100),
        iss_name                    varchar2(100),
        assd_name                   giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012 [FROM varchar2(100)]
        ref_pol_no                  varchar2(500),
        INTM_NO                     varchar2(2000),
        INTM_Name                   varchar2(3000),
        peril                       varchar2(100),
        prem                        number,
        tsi                         number,
        total_due                   number);
 TYPE get_details_tab IS TABLE OF get_details_type;
 
 
 FUNCTION get_details(P_POLICY_ID            GIEX_EXPIRIES_V.POLICY_ID%TYPE,
                     P_ASSD_NO              GIEX_EXPIRIES_V.ASSD_NO%TYPE,
                     P_ISS_CD               GIEX_EXPIRIES_V.ISS_CD%TYPE,
                     P_SUBLINE_CD           GIEX_EXPIRIES_V.SUBLINE_CD%TYPE,
                     P_LINE_CD              GIEX_EXPIRIES_V.LINE_CD%TYPE,
                     P_STARTING_DATE        VARCHAR2,
                     P_ENDING_DATE          VARCHAR2,
                     P_INCLUDE_PACK         VARCHAR2,
                     P_CLAIMS_FLAG          VARCHAR2,
                     P_BALANCE_FLAG         VARCHAR2,
                     p_is_package           VARCHAR2,
                     p_user_id              VARCHAR2) -- marco - 04.29.2013 - added parameter                     
        RETURN get_details_tab PIPELINED;
        
 function CF_ASSURED(p_line_cd       varchar2,
                    p_subline_cd    varchar2,
                    p_iss_cd        varchar2,
                    p_issue_yy      number,
                    p_pol_seq_no    number,
                    p_renew_no      number,
                    p_policy_id     number)
             RETURN varchar2;
   
 FUNCTION cf_total_dueformula (p_prem_amt NUMBER, p_tax_amt NUMBER)
   RETURN NUMBER;          
              
   
END GIEXR102_PKG;
/


