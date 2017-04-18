CREATE OR REPLACE PACKAGE CPI.GIACR279_PKG
AS
    
    TYPE report_type IS RECORD (
        company_name        giac_parameters.PARAM_VALUE_V%type,
        company_address     giac_parameters.PARAM_VALUE_V%type,
        as_of               VARCHAR2(50),
        cut_off             VARCHAR2(50),
        
        ri_cd               giac_loss_rec_soa_ext.RI_CD%type,
        ri_name             giac_loss_rec_soa_ext.RI_NAME%type,
        line_cd             giac_loss_rec_soa_ext.LINE_CD%type,
        line_name           giac_loss_rec_soa_ext.LINE_NAME%type,
        claim_no            giac_loss_rec_soa_ext.CLAIM_NO%type,
        fla_no              giac_loss_rec_soa_ext.FLA_NO%type,
        policy_no           giac_loss_rec_soa_ext.POLICY_NO%type,
        assd_no             giac_loss_rec_soa_ext.ASSD_NO%type, --Dren 05.24.2016 SR-5349
        assd_name           giac_loss_rec_soa_ext.ASSD_NAME%type,
        fla_date            giac_loss_rec_soa_ext.FLA_DATE%type,
        as_of_date          giac_loss_rec_soa_ext.AS_OF_DATE%type,
        cut_off_date        giac_loss_rec_soa_ext.CUT_OFF_DATE%type,
        currency_cd         giac_loss_rec_soa_ext.CURRENCY_CD%type,
        convert_rate        giac_loss_rec_soa_ext.CONVERT_RATE%type,
        orig_curr_rate      giac_loss_rec_soa_ext.ORIG_CURR_RATE%type,
        payee_type          giac_loss_rec_soa_ext.PAYEE_TYPE%type,
        amount_due          giac_loss_rec_soa_ext.AMOUNT_DUE%type,
        cf_amount_due       giac_loss_rec_soa_ext.AMOUNT_DUE%type,
        print_band          VARCHAR2(1)        
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION populate_report(
        p_as_of_date        VARCHAR2,
        p_cut_off_date      VARCHAR2,
        p_ri_cd             giac_loss_rec_soa_ext.RI_CD%type,
        p_line_cd           giac_loss_rec_soa_ext.LINE_CD%type,
        p_payee_type        giac_loss_rec_soa_ext.PAYEE_TYPE%type,
        p_payee_type2       giac_loss_rec_soa_ext.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    ) RETURN report_tab PIPELINED;

END GIACR279_PKG;
/


