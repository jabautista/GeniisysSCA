CREATE OR REPLACE PACKAGE CPI.UW_REPORTS_SOA_PKG AS
  TYPE uw_soa_type IS RECORD
(policy_id      GIPI_POLBASIC.POLICY_ID%TYPE,
line_name       VARCHAR2(100),
subline_name    VARCHAR2(100),
policyno        VARCHAR2(100),
endtno          VARCHAR2(100),
premseqno       VARCHAR2(100),
endt_seq_no     GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE,
item_grp        GIPI_INVOICE.ITEM_GRP%TYPE,
assd_tin        GIIS_ASSURED.ASSD_TIN%TYPE,
address1        VARCHAR2(100),
address2        VARCHAR2(100),
address3        VARCHAR2(100),
issue_date      DATE,
eff_date        DATE,
fromdate        VARCHAR2(100),
todate          VARCHAR2(100),
par_id          GIPI_POLBASIC.PAR_ID%TYPE,
iss_cd          GIPI_POLBASIC.ISS_CD%TYPE,
remarks         GIPI_INVOICE.REMARKS%TYPE,
other_charges   GIPI_INVOICE.REMARKS%TYPE,
property        GIPI_INVOICE.PROPERTY%TYPE,
user_id         VARCHAR2(100),
co_insurance_sw GIPI_POLBASIC.CO_INSURANCE_SW%TYPE,
assd_name       VARCHAR2(600),
intm_no         VARCHAR2(100),
bir_no          GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
prem_rt         VARCHAR2(50),
peril_name      VARCHAR2(50),
currency_desc   GIIS_CURRENCY.CURRENCY_DESC%TYPE,
tsi_amt         GIPI_POLBASIC.TSI_AMT%TYPE,
prem_amt        GIPI_POLBASIC.PREM_AMT%TYPE,
vatable_amt     NUMBER,
zero_rated      NUMBER,
vat_exempt      NUMBER
);

  TYPE uw_soa_tab IS TABLE OF uw_soa_type;
  
    TYPE uw_soa_peril_type IS RECORD
(policy_id      GIPI_POLBASIC.POLICY_ID%TYPE,
item_grp        GIPI_INVOICE.ITEM_GRP%TYPE,
peril_prem_amt  GIPI_ITMPERIL.PREM_AMT%TYPE,
peril_sname     GIIS_PERIL.PERIL_SNAME%TYPE
);

    TYPE uw_soa_peril_tab IS TABLE OF uw_soa_peril_type;
    
    TYPE uw_soa_tax_type IS RECORD
(policy_id      GIPI_POLBASIC.POLICY_ID%TYPE,
item_grp        GIPI_INVOICE.ITEM_GRP%TYPE,
tax_desc        GIIS_TAX_CHARGES.TAX_DESC%TYPE,
tax_amt         GIPI_INV_TAX.TAX_AMT%TYPE
);

    TYPE uw_soa_tax_tab IS TABLE OF uw_soa_tax_type; 
    
    TYPE uw_soa_seici_type IS RECORD
(policy_id        GIPI_POLBASIC.policy_id%TYPE,
par_id            GIPI_POLBASIC.par_id%TYPE,
incept_tag        GIPI_POLBASIC.incept_tag%TYPE,
expiry_tag        GIPI_POLBASIC.expiry_tag%TYPE,
line_name        VARCHAR2(100),
subline_name    VARCHAR2(100),
subline_time    VARCHAR2(100),
no_of_items        GIPI_POLBASIC.no_of_items%TYPE,
issue_date        GIPI_POLBASIC.issue_date%TYPE,
fromdate        VARCHAR2(100),
todate            VARCHAR2(100),    
expiry_date        VARCHAR2(100),
policyno        VARCHAR2(100),    
eff_date        GIPI_POLBASIC.eff_date%TYPE,
endt_seq_no        GIPI_POLBASIC.endt_seq_no%TYPE,
endtno            VARCHAR2(100),
assd_name        VARCHAR2(600),
assd_no            GIPI_POLBASIC.assd_no%TYPE,
acct_of_cd        GIPI_POLBASIC.acct_of_cd%TYPE,
address1        VARCHAR2(100),
address2        VARCHAR2(100),
address3        VARCHAR2(100),
prem_seq_no        GIPI_INVOICE.prem_seq_no%TYPE,
iss_cd1            GIPI_INVOICE.iss_cd%TYPE,
item_grp        GIPI_INVOICE.item_grp%TYPE,
premseqno        VARCHAR2(100),
other_charges    GIPI_INVOICE.other_charges%TYPE,
property        GIPI_INVOICE.property%TYPE,
remarks            GIPI_INVOICE.remarks%TYPE,
currency_desc    GIIS_CURRENCY.currency_desc%TYPE,
currency_cd        GIIS_CURRENCY.main_currency_cd%TYPE,
short_name        GIIS_CURRENCY.short_name%TYPE,
mortg_name        GIPI_POLBASIC.mortg_name%TYPE,
user_id            GIPI_POLBASIC.user_id%TYPE,
line_cd            GIPI_POLBASIC.line_cd%TYPE,
subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
issue_yy        GIPI_POLBASIC.issue_yy%TYPE,
pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
renew_no        GIPI_POLBASIC.renew_no%TYPE,
ref_pol_no        GIPI_POLBASIC.ref_pol_no%TYPE,
label_tag        VARCHAR2(50),
acct_iss_cd        VARCHAR2(50),
acct_of_cd_sw    VARCHAR2(50),
acctofcd         VARCHAR2(50),
co_insurance_sw GIPI_POLBASIC.CO_INSURANCE_SW%TYPE,
tsi_amt         GIPI_POLBASIC.TSI_AMT%TYPE,
prem_amt        GIPI_POLBASIC.PREM_AMT%TYPE,
vatable_amt     NUMBER,
zero_rated      NUMBER,
vat_exempt      NUMBER,
prem_rt         VARCHAR2(50),
peril_name      VARCHAR2(50));

    TYPE uw_soa_seici_tab IS TABLE OF uw_soa_seici_type;
    
     TYPE uw_soa_seici_peril_type IS RECORD
(policy_id        GIPI_POLBASIC.policy_id%TYPE,
iss_cd            GIPI_INVOICE.iss_cd%TYPE,
prem_seq_no        GIPI_INVOICE.prem_seq_no%TYPE,
item_grp        GIPI_INVOICE.item_grp%TYPE,
peril_sname        GIIS_PERIL.peril_sname%TYPE,
tsi_amt            GIPI_INVPERIL.tsi_amt%TYPE,
prem_amt        GIPI_INVPERIL.prem_amt%TYPE,
line_cd            GIPI_POLBASIC.line_cd%TYPE,
SEQUENCE        GIIS_PERIL.SEQUENCE%TYPE,
peril_type        GIIS_PERIL.peril_type%TYPE,
basc_perl_cd    GIIS_PERIL.basc_perl_cd%TYPE,
peril_cd        GIIS_PERIL.peril_cd%TYPE
);

    TYPE uw_soa_seici_peril_tab IS TABLE OF uw_soa_seici_peril_type;
    
    TYPE uw_soa_seici_tax_type IS RECORD
(POLICY_ID        GIPI_INVOICE.policy_id%TYPE,
ITEM_GRP        GIPI_INVOICE.item_grp%TYPE,
PREM_SEQ_NO        GIPI_INVOICE.prem_seq_no%TYPE,
ISS_CD            GIPI_INVOICE.iss_cd%TYPE,
OTHER_CHARGES    GIPI_INVOICE.other_charges%TYPE,
TAX_AMT            GIPI_INV_TAX.tax_amt%TYPE, 
TAX_DESC        GIIS_TAX_CHARGES.tax_desc%TYPE,
TAX_CD            GIPI_INV_TAX.tax_cd%TYPE
);

    TYPE uw_soa_seici_tax_tab IS TABLE OF uw_soa_seici_tax_type;   
  
  
FUNCTION get_uw_soa_flt(p_policy_id GIPI_POLBASIC.policy_id%TYPE)
    RETURN uw_soa_tab PIPELINED;
    
FUNCTION get_uw_soa_peril_flt(p_policy_id GIPI_POLBASIC.policy_id%TYPE, 
        p_prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE,
        p_iss_cd          GIPI_INVOICE.ISS_CD%TYPE,
        p_co_insurance_sw GIPI_POLBASIC.co_insurance_sw%TYPE)
    RETURN uw_soa_peril_tab PIPELINED;    


FUNCTION get_uw_soa_tax_flt(p_policy_id GIPI_POLBASIC.policy_id%TYPE, 
        p_prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE,
        p_iss_cd          GIPI_INVOICE.ISS_CD%TYPE,
        p_co_insurance_sw GIPI_POLBASIC.co_insurance_sw%TYPE)
    RETURN uw_soa_tax_tab PIPELINED;  

FUNCTION get_uw_soa_seici (p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
    RETURN uw_soa_seici_tab PIPELINED;
    
FUNCTION get_uw_soa_peril_seici(p_policy_id       GIPI_POLBASIC.policy_id%TYPE, 
                                p_prem_seq_no     GIPI_INVOICE.prem_seq_no%TYPE)
    RETURN uw_soa_seici_peril_tab PIPELINED;
    
FUNCTION get_uw_soa_tax_seici(p_policy_id       GIPI_POLBASIC.policy_id%TYPE, 
                              p_prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE)
        
    RETURN uw_soa_seici_tax_tab PIPELINED;
    
END UW_REPORTS_SOA_PKG;
/


