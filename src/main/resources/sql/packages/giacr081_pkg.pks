CREATE OR REPLACE PACKAGE CPI.GIACR081_PKG AS
    
    TYPE main_report_record_type IS RECORD (
        company_name            giis_parameters.param_value_v%TYPE,
        company_address         giis_parameters.param_value_v%TYPE,
        replenish_id            giac_replenish_dv.replenish_id%TYPE,
        branch_cd               giac_replenish_dv.branch_cd%TYPE,
        replenish_no            VARCHAR2(100),
        revolving_fund_amt      giac_replenish_dv.revolving_fund_amt%TYPE,
        replenish_tran_id       giac_replenish_dv.replenish_tran_id%TYPE,
        replenishment_amt       giac_replenish_dv.replenishment_amt%TYPE,
        dv_tran_id              giac_replenish_dv_dtl.dv_tran_id%TYPE,
        check_pref_suf_check_no VARCHAR2(16),
        amount                  giac_replenish_dv_dtl.amount%TYPE,
        particulars             giac_disb_vouchers.particulars%TYPE,
        payee                   giac_disb_vouchers.payee%TYPE,
        dv_pref_no              VARCHAR2(16),
        request_no              VARCHAR2(24),
        check_date              VARCHAR2(16),
        replenish_year          giac_replenish_dv.replenish_year%TYPE,
        print_details           VARCHAR2(1)         -- shan 10.09.2014
    );

    TYPE main_report_record_tab IS TABLE OF main_report_record_type;
    
    TYPE report_detail_record_type IS RECORD(
        item_no     giac_rep_signatory.item_no%TYPE,    
        label       giac_rep_signatory.label%TYPE,
        signatory   giis_signatory_names.signatory%TYPE,
        designation giis_signatory_names.designation%TYPE,
        branch_cd   giac_documents.branch_cd%TYPE
    );
    
    TYPE report_detail_record_tab IS TABLE OF report_detail_record_type;
  
    FUNCTION get_dv_records(
        p_replenish_id  giac_replenish_dv.replenish_id%TYPE
    )
        RETURN main_report_record_tab PIPELINED;
        
    FUNCTION get_signatory(
        p_user_id       giac_users.user_id%TYPE,
        p_report_id     giac_documents.report_id%TYPE,
        p_branch_cd     giac_replenish_dv.branch_cd%TYPE
    )
        RETURN report_detail_record_tab PIPELINED;

END GIACR081_PKG;
/


