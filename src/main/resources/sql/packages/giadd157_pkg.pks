CREATE OR REPLACE PACKAGE CPI.GIADD157_PKG 
AS
    TYPE report_header IS RECORD (
       company_name     GIAC_PARAMETERS.param_value_v%TYPE,
       company_addr     GIAC_PARAMETERS.param_value_v%TYPE,
       report_name      GIIS_REPORTS.report_title%TYPE,
       fromto_date      VARCHAR2(50)
    );
    TYPE report_header_tab IS TABLE OF report_header;
     
    TYPE report_detail IS RECORD (
       comm_slip_no     VARCHAR2(50),
       comm_slip_date   GIAC_COMM_FUND_EXT.comm_slip_date%TYPE,
       intm_type_no     VARCHAR2(50),
       intm_name        GIIS_INTERMEDIARY.intm_name%TYPE,
       bill_no          VARCHAR2(50),
       comm_amt         GIAC_COMM_FUND_EXT.comm_amt%TYPE,
       wtax_amt         GIAC_COMM_FUND_EXT.wtax_amt%TYPE,
       input_vat_amt    GIAC_COMM_FUND_EXT.input_vat_amt%TYPE,
       net_commission   NUMBER(15,2),
       spoiled_tag      GIAC_COMM_FUND_EXT.spoiled_tag%TYPE
    );
    TYPE report_detail_tab IS TABLE OF report_detail;
    
    TYPE report_summary IS RECORD (
       comm_amt         GIAC_COMM_FUND_EXT.comm_amt%TYPE,
       wtax_amt         GIAC_COMM_FUND_EXT.wtax_amt%TYPE,
       input_vat_amt    GIAC_COMM_FUND_EXT.input_vat_amt%TYPE,
       netcomm          NUMBER(15,2),
       spoiled_tag      GIAC_COMM_FUND_EXT.spoiled_tag%TYPE
    );
    TYPE report_summary_tab IS TABLE OF report_summary;
    
    TYPE report_signatory IS RECORD (
       report_no        GIAC_DOCUMENTS.report_no%TYPE,
       item_no          GIAC_REP_SIGNATORY.item_no%TYPE,
       label            GIAC_REP_SIGNATORY.label%TYPE,
       signatory        GIIS_SIGNATORY_NAMES.signatory%TYPE,
       designation      GIIS_SIGNATORY_NAMES.designation%TYPE
    );
    TYPE report_signatory_tab IS TABLE OF report_signatory;
    
    FUNCTION get_report_header (
        p_report_id GIIS_REPORTS.report_id%TYPE,
        p_tran_id   GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE
    )
      RETURN report_header_tab PIPELINED;
    
    FUNCTION get_report_detail (p_tran_id  GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE)
      RETURN report_detail_tab PIPELINED;
    
    FUNCTION get_report_summary (p_tran_id  GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE)
      RETURN report_summary_tab PIPELINED;
    
    FUNCTION get_report_signatory (
        p_report_id     GIAC_DOCUMENTS.report_id%TYPE,
        p_branch_cd     GIAC_DOCUMENTS.branch_cd%TYPE
    )
      RETURN report_signatory_tab PIPELINED;
    
    
END giadd157_pkg;
/


