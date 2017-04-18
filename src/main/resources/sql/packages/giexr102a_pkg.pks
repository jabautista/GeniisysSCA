CREATE OR REPLACE PACKAGE CPI.GIEXR102A_PKG
AS
/**
* Rey Jadlocon
* 03-01-2012
**/
TYPE get_details_type IS RECORD(
            ISS_CD              GIEX_EXPIRIES_V.ISS_CD%TYPE,
            LINE_CD             GIEX_EXPIRIES_V.LINE_CD%TYPE,
            SUBLINE_CD          GIEX_EXPIRIES_V.SUBLINE_CD%TYPE,
            ISSUE_YY            GIEX_EXPIRIES_V.ISSUE_YY%TYPE,
            POL_SEQ_NO          GIEX_EXPIRIES_V.POL_SEQ_NO%TYPE,
            RENEW_NO            GIEX_EXPIRIES_V.RENEW_NO%TYPE,
            ISS_CD2             GIEX_EXPIRIES_V.ISS_CD%TYPE,
            LINE_CD2            GIEX_EXPIRIES_V.LINE_CD%TYPE,
            SUBLINE_CD2         GIEX_EXPIRIES_V.SUBLINE_CD%TYPE,
            POLICY_NO           VARCHAR2(100),
            TSI_AMT             GIEX_EXPIRIES_V.TSI_AMT%TYPE,
            PREM_AMT            GIEX_EXPIRIES_V.PREM_AMT%TYPE,
            TAX_AMT             GIEX_EXPIRIES_V.TAX_AMT%TYPE,
            EXPIRY_DATE         GIEX_EXPIRIES_V.EXPIRY_DATE%TYPE,
            LINE_NAME           VARCHAR2(100),
            SUBLINE_NAME        GIIS_SUBLINE.SUBLINE_NAME%TYPE,
            POLICY_ID           GIEX_EXPIRIES_V.POLICY_ID%TYPE,
            PERIL_CD            GIEX_OLD_GROUP_PERIL.PERIL_CD%TYPE,
            PREM_AMT2           GIEX_OLD_GROUP_PERIL.PREM_AMT%TYPE,
            TSI_AMT2            GIEX_OLD_GROUP_PERIL.TSI_AMT%TYPE,
            PLATE_NO            GIEX_EXPIRIES_V.PLATE_NO%TYPE,
            MODEL_YEAR          GIEX_EXPIRIES_V.MODEL_YEAR%TYPE,
            COLOR               GIEX_EXPIRIES_V.COLOR%TYPE,
            SERIALNO            GIEX_EXPIRIES_V.SERIALNO%TYPE,
            MAKE                VARCHAR2(500),
            MOTOR_NO            GIEX_EXPIRIES_V.MOTOR_NO%TYPE,
            ITEM_TITLE          GIEX_EXPIRIES_V.ITEM_TITLE%TYPE,
            BALANCE_FLAG        GIEX_EXPIRIES_V.BALANCE_FLAG%TYPE,
            CLAIM_FLAG          GIEX_EXPIRIES_V.CLAIM_FLAG%TYPE,
            COMPANY_NAME        VARCHAR2(100),
            COMPANY_ADDRESS     VARCHAR2(100),
            INTM_NO             VARCHAR2(3000),
            STARTING_DATE       DATE,
            ENDING_DATE         DATE,
            ISS_NAME            VARCHAR2(100),
            ASSD_NAME           giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012 [FROM VARCHAR2(100)]
            REF_POL_NO          VARCHAR2(50),
            makeformula         VARCHAR2(500),
            item_desc           VARCHAR2(2000),
            peril_name          VARCHAR2(100));
   TYPE get_details_tab IS TABLE OF get_details_type;
   
   FUNCTION get_details(P_POLICY_ID            NUMBER,
                     P_ASSD_NO              NUMBER,
                     P_INTM_NO              NUMBER,
                     P_ISS_CD               VARCHAR2,
                     P_SUBLINE_CD           VARCHAR2,
                     P_LINE_CD              VARCHAR2,
                     P_ENDING_DATE          VARCHAR2,
                     P_STARTING_DATE        VARCHAR2,
                     P_INCLUDE_PACK         VARCHAR2,
                     P_CLAIMS_FLAG          VARCHAR2,
                     P_BALANCE_FLAG         VARCHAR2)
        RETURN get_details_tab PIPELINED;
        
        FUNCTION cf_item_descformula(p_line_cd          varchar2,
                             p_subline_cd       varchar2,
                             p_iss_cd           varchar2,
                             p_issue_yy         number,
                             p_pol_seq_no       number,
                             p_renew_no         number,
                             p_plate_no         varchar2)
   RETURN CHAR;
   
   FUNCTION cf_makeformula(p_motor_no      varchar2,
                        p_cf_item_desc  varchar2,
                        p_make          varchar2,
                        p_item_title    varchar2)
   RETURN CHAR;
END GIEXR102A_PKG;
/