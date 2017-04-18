CREATE OR REPLACE PACKAGE CPI.GIPIR913_PKG
AS
    TYPE report_type IS RECORD (
        policy_id           GIPI_POLBASIC.policy_id%TYPE,
        acct_of_cd          GIPI_POLBASIC.acct_of_cd%TYPE,
        label_tag           GIPI_POLBASIC.label_tag%TYPE,
        assd_name           VARCHAR2(600),--GIIS_ASSURED.assd_name%TYPE, changed datatype to varchar2(600) by robert 04.29.2013 sr 12880
        address1            GIPI_POLBASIC.address1%TYPE,
        address2            GIPI_POLBASIC.address2%TYPE,
        address3            GIPI_POLBASIC.address3%TYPE,
        assd_tin            GIIS_ASSURED.assd_tin%TYPE,
        iss_cd              GIPI_INVOICE.iss_cd%TYPE,
        prem_seq_no         GIPI_INVOICE.prem_seq_no%TYPE,
        invoice_no          VARCHAR2(50),
        date_issued         VARCHAR2(50),
        line_name           GIIS_LINE.line_name%TYPE,
        policy_no           VARCHAR2(100), --adpascual - 03192012
        endt_no             VARCHAR2(50),
        date_from           VARCHAR2(50),
        date_to             VARCHAR2(50),
        subline_subline_time    VARCHAR2(50),
        tsi_amt             GIPI_POLBASIC.tsi_amt%TYPE,
        short_name          VARCHAR2(50),
        prem_amt            GIPI_INVOICE.prem_amt%TYPE,
        intermediary        VARCHAR2(200),
        currency_cd         GIPI_INVOICE.currency_cd%TYPE,    
        policy_currency     GIPI_INVOICE.policy_currency%TYPE,
        iv_currency_rt      GIPI_INVOICE.currency_rt%TYPE,
        bank_ref_no         GIPI_POLBASIC.bank_ref_no%TYPE,
        subline_name        GIIS_SUBLINE.subline_name%TYPE,
        intrmdry_intm_no    GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
        cy_currency_rt      GIIS_CURRENCY.currency_rt%TYPE,
        currency_desc       VARCHAR2(50),
        intm_name           GIIS_INTERMEDIARY.intm_name%TYPE,
        class_name          GIIS_SUBLINE.subline_name%TYPE,
        sum_insured_fc      NUMBER(16,2),
        assd_name2          VARCHAR2(600),--GIIS_ASSURED.assd_name%TYPE, changed datatype to varchar2(600) by robert 04.29.2013 sr 12880
        cf_prem_label       VARCHAR2(50),
        cf_prem_amt         VARCHAR2(20),
        company_tin         VARCHAR2(200),
        eff_date            GIPI_POLBASIC.eff_date%TYPE,
        cf_BIR_permit_no   VARCHAR2(200),
        issue_address       VARCHAR2(150)
        );
    TYPE report_tab IS TABLE OF report_type;
   
   TYPE report_pack_type IS RECORD (
        pack_policy_id         GIPI_POLBASIC.pack_policy_id%TYPE,
        acct_of_cd             GIPI_POLBASIC.acct_of_cd%TYPE,
        label_tag              GIPI_POLBASIC.label_tag%TYPE,
      assd_no                 GIPI_POLBASIC.assd_no%TYPE,
        assd_name              GIIS_ASSURED.assd_name%TYPE,
        address1               GIPI_POLBASIC.address1%TYPE,
        address2               GIPI_POLBASIC.address2%TYPE,
        address3               GIPI_POLBASIC.address3%TYPE,
        assd_tin                  GIIS_ASSURED.assd_tin%TYPE,
      invoice_no             VARCHAR2(50),
      date_issued            VARCHAR2(50),
      line_name              GIIS_LINE.line_name%TYPE,
      policy_no              VARCHAR2(100),
      endt_no                VARCHAR2(50),
      date_from              VARCHAR2(50),
        date_to                VARCHAR2(50),
      subline_subline_time    VARCHAR2(50),
      tsi_amt                GIPI_POLBASIC.tsi_amt%TYPE,
      short_name             VARCHAR2(50),
        prem_amt               GIPI_INVOICE.prem_amt%TYPE,
      intermediary           VARCHAR2(200),
      currency_cd            GIPI_INVOICE.currency_cd%TYPE,    
        policy_currency        GIPI_INVOICE.policy_currency%TYPE,
      iv_currency_rt         GIPI_INVOICE.currency_rt%TYPE,
      bank_ref_no            GIPI_POLBASIC.bank_ref_no%TYPE,
        subline_name           GIIS_SUBLINE.subline_name%TYPE,
        intrmdry_intm_no       GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
        cy_currency_rt         GIIS_CURRENCY.currency_rt%TYPE,
      currency_desc          VARCHAR2(50),
        intm_name              GIIS_INTERMEDIARY.intm_name%TYPE,
        class_name             GIIS_SUBLINE.subline_name%TYPE,
        sum_insured_fc         NUMBER(16,2),
      assd_name2             GIIS_ASSURED.assd_name%TYPE,
        issue_address           VARCHAR2(150)
        );
    TYPE report_pack_tab IS TABLE OF report_pack_type;

FUNCTION populate_gipir913_UCPB(p_policy_id     GIPI_POLBASIC.policy_id%TYPE)
    RETURN report_tab   PIPELINED;
    
FUNCTION populate_gipir913C_UCPB(p_policy_id     GIPI_POLBASIC.policy_id%TYPE)
    RETURN report_tab   PIPELINED;    

FUNCTION populate_gipir913D (p_policy_id     GIPI_POLBASIC.policy_id%TYPE)
    RETURN report_tab   PIPELINED;    
    
FUNCTION cf_premlabelformula (
    p_policy_id   GIPI_POLBASIC.policy_id%TYPE,
    p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
    p_prem_seq_no GIPI_INVOICE.prem_seq_no%TYPE
    )
    RETURN VARCHAR2;

FUNCTION cf_premamtformula (
    p_policy_id     GIPI_POLBASIC.policy_id%TYPE,
    p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
    p_prem_seq_no GIPI_INVOICE.prem_seq_no%TYPE
  )
    RETURN VARCHAR2;  
   
FUNCTION populate_pack_gipir913B(p_policy_id   GIPI_POLBASIC.policy_id%TYPE)
   RETURN report_pack_tab   PIPELINED;  
    
END GIPIR913_PKG; 
/

