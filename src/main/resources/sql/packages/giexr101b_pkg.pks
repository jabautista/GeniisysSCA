CREATE OR REPLACE PACKAGE CPI.GIEXR101B_PKG
AS
/**
* Rey Jadlocon
* 02-23-2012
**/
TYPE get_details_type IS RECORD(
            iss_cd                      giex_expiries_v.iss_cd%TYPE,
            line_cd                     giex_expiries_v.line_cd%TYPE,
            subline_cd                  giex_expiries_v.subline_cd%TYPE,
            issue_yy                    giex_expiries_v.issue_yy%TYPE,
            pol_seq_no                  giex_expiries_v.pol_seq_no%TYPE,
            renew_no                    giex_expiries_v.renew_no%TYPE,
            iss_cd2                     giex_expiries_v.iss_cd%TYPE,
            line_cd2                    giex_expiries_v.line_cd%TYPE,
            subline_cd2                 giex_expiries_v.subline_cd%TYPE,
            policy_no                   VARCHAR2(100),
            tsi_amt                     giex_expiries_v.tsi_amt%TYPE,
            prem_amt                    giex_expiries_v.prem_amt%TYPE,
            tax_amt                     giex_expiries_v.tax_amt%TYPE,
            expiry_date                 giex_expiries_v.expiry_date%TYPE,
            line_name                   VARCHAR2(100),
            subline_name                VARCHAR2(100),
            policy_id                   giex_expiries_v.policy_id%TYPE,
            balance_flag                VARCHAR2(10),
            claim_flag                  VARCHAR2(10),
            ren_tsi_amt                 giex_expiries_v.ren_tsi_amt%TYPE,
            ren_prem_amt                giex_expiries_v.ren_prem_amt%TYPE,
            company_name                varchar2(500),
            company_address             varchar2(500),
            text                        varchar2(500),
            starting_date               VARCHAR2(100),
            ending_date                 VARCHAR2(100),
            iss_name                    varchar2(100),
            assd_name                   giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012[FROM varchar2(100)]
            ref_pol_no                  varchar2(100),
            INTM_Name                   varchar2(100),
            intm_no                     varchar2(100)         
       );
       
     TYPE get_details_tab IS TABLE OF get_details_type;
     
     
     FUNCTION get_details(P_POLICY_ID        INTEGER,
                     P_ASSD_NO          INTEGER,
                     P_INTM_NO          VARCHAR2,
                     P_ISS_CD           VARCHAR2,
                     P_SUBLINE_CD       VARCHAR2,
                     P_LINE_CD          VARCHAR2,
                     P_ENDING_DATE      VARCHAR2,
                     P_STARTING_DATE    VARCHAR2,
                     p_include_pack     VARCHAR2,
                     p_claims_flag      VARCHAR2,
                     p_balance_flag     VARCHAR2,
                     p_user_id          VARCHAR2) -- marco - 04.29.2013 - added parameter
        RETURN get_details_tab PIPELINED;

END GIEXR101B_PKG;
/


