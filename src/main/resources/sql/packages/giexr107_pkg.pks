CREATE OR REPLACE PACKAGE CPI.GIEXR107_PKG
AS
    TYPE get_details_type IS RECORD(
                ri_cd                       NUMBER,
                ri_name                     VARCHAR2(100),
                bill_address12              VARCHAR2(100),
                bill_address23              VARCHAR2(100),
                bill_address34              VARCHAR2(100),
                currency_cd                 VARCHAR2(100),
                currency_desc               VARCHAR2(100),
                line_cd                     VARCHAR2(100),
                line_name                   VARCHAR2(100),
                issue_date                  VARCHAR2(100),
                policy_no                   VARCHAR2(100),
                policy_id                   NUMBER,
                binder                      VARCHAR2(100),
                expiry_date                 VARCHAR2(100),
                assured                     giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012 [FROM VARCHAR2(500)]
                assured_address             VARCHAR2(500),
                incept_date                 VARCHAR2(100),
                tsi                         NUMBER,
                sum_insured                 NUMBER,
                ri_share                    NUMBER,
                binder_tsi                  NUMBER,
                pct_accepted                NUMBER,
                frps_ri_remarks             giri_frps_ri.remarks%TYPE, --VARCHAR2(2000), changed datatype by robert 09272013
                company_name                VARCHAR2(2000),
                company_address             VARCHAR2(2000),
                expiry_month                VARCHAR2(100),
                expiry_year                 VARCHAR2(100),
                destn                       VARCHAR2(2000),
                risk1                       VARCHAR2(500),
                risk2                       VARCHAR2(500),
                risk3                       VARCHAR2(500),
                vessel_cd                   VARCHAR2(500),
                vessel_name                 VARCHAR2(500),
                endt_no                     VARCHAR2(60)); -- added by MarkS 04.29.2016 SR-22068
    TYPE get_details_tab IS TABLE OF get_details_type;
    
    FUNCTION get_details(p_line             varchar2,
                     p_reinsurer        varchar2,
                     p_expiry_month     varchar2,
                     p_expiry_year      varchar2,
                     p_user_id          varchar2)
    RETURN  get_details_tab PIPELINED;
    
    FUNCTION cf_company_addressformula
   RETURN CHAR;

    FUNCTION cf_destnformula(p_line_cd          varchar2,
                         p_policy_id        number)
   RETURN VARCHAR2;

   FUNCTION cf_loc_risk1formula(p_line_cd          varchar2,
                             p_policy_id        number)
   RETURN VARCHAR2;

    FUNCTION cf_loc_risk2formula(p_line_cd              varchar2,
                             p_policy_id            number)
   RETURN VARCHAR2;
   
   FUNCTION cf_loc_risk3formula(p_line_cd          varchar2,
                             p_policy_id        number)
   RETURN VARCHAR2;
   
   FUNCTION cf_vessel_cdformula(p_line_cd          varchar2,
                             p_policy_id        number)
   RETURN VARCHAR2;
   
   FUNCTION cf_vessel_nameformula(p_line_cd            varchar2,
                               p_cf_vessel_cd          varchar2)
   RETURN VARCHAR2;

END GIEXR107_PKG;
/
