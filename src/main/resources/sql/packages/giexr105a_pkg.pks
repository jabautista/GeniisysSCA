CREATE OR REPLACE PACKAGE CPI.GIEXR105A_PKG
AS


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
            MAKE                GIEX_EXPIRIES_V.MAKE%TYPE,
            MOTOR_NO            GIEX_EXPIRIES_V.MOTOR_NO%TYPE,
            ITEM_TITLE          GIEX_EXPIRIES_V.ITEM_TITLE%TYPE,
            BALANCE_FLAG        GIEX_EXPIRIES_V.BALANCE_FLAG%TYPE,
            CLAIM_FLAG          GIEX_EXPIRIES_V.CLAIM_FLAG%TYPE,
            COMPANY_NAME        VARCHAR2(100),
            COMPANY_ADDRESS     VARCHAR2(100),
            INTM_NO             VARCHAR2(3000),
            grp_intm_no         giis_intermediary.intm_no%TYPE,
            STARTING_DATE       DATE,
            ENDING_DATE         DATE,
            ISS_NAME            VARCHAR2(100),
            ASSD_NAME           giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012 [FROM VARCHAR2(100)]
            REF_POL_NO          VARCHAR2(50),
            makeformula         VARCHAR2(100),
            item_desc           varchar2(100),
            peril_name          varchar2(100),
            REN_TSI_AMT         number,
            REN_PREM_AMT        number,
            INTM_NAME           varchar2(100),
            MARK                varchar2(100));
   TYPE get_details_tab IS TABLE OF get_details_type;
   
   FUNCTION get_details(p_policy_id            number,
                     p_assd_no              number,
                     p_intm_no              number,
                     p_iss_cd               varchar2,
                     p_subline_cd           varchar2,
                     p_line_cd              varchar2,
                     p_ending_date          varchar2,
                     p_starting_date        varchar2,
                     p_include_pack         varchar2,
                     p_claims_flag          varchar2,
                     p_balance_flag         varchar2,
                     p_is_package           varchar2,
                     p_user_id              varchar2)
         RETURN get_details_tab PIPELINED;


END GIEXR105A_PKG;
/


