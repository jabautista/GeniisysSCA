CREATE OR REPLACE PACKAGE CPI.GIACR290A_PKG AS

TYPE giacr209A_type IS RECORD(
    
    pol_no       varchar2(40),
    ceded_auth  giac_recap_summ_ext.CEDED_PREM_AUTH%type,
    ceded_asean giac_recap_summ_ext.CEDED_PREM_ASEAN%type,
    ceded_oth   giac_recap_summ_ext.CEDED_PREM_OTH%type,
    net_direct  giac_recap_summ_ext.CEDED_PREM_OTH%type,
    direct_prem giac_recap_summ_ext.DIRECT_PREM%type,
    inw_auth    giac_recap_summ_ext.INW_PREM_AUTH%type,
    inw_asean    giac_recap_summ_ext.INW_PREM_ASEAN%type,
    inw_oth    giac_recap_summ_ext.INW_PREM_OTH%type,
    retced_auth giac_recap_summ_ext.RETCEDED_PREM_AUTH%type,
    retced_asean giac_recap_summ_ext.RETCEDED_PREM_ASEAN%type,
    retced_oth   giac_recap_summ_ext.RETCEDED_PREM_OTH%type,
    net_written  giac_recap_summ_ext.RETCEDED_PREM_OTH%type,
    rep_title   varchar2(200),
    dtl_sub_title   varchar2(100),
    direct_title    varchar2(100),
    cedgroup_title  varchar2(100),
    netdirect_title varchar2(100),
    assumed_title   varchar2(100),
    netwritten_title    varchar2(100),
    retroceded_title    varchar2(100),
    subtitle        varchar2(100),
    pol_title       varchar2(100),
    company_name    varchar2(100),
    company_address varchar2(100)
    
    );

TYPE giacr209A_tab IS TABLE OF giacr209A_type;

FUNCTION populate_giacr209A(
    p_report_type varchar2,
    p_row_title   varchar2,
    p_date2          varchar2
    
    
)
RETURN giacr209A_tab PIPELINED;
END GIACR290A_PKG;
/


