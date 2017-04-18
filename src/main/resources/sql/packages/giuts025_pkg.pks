CREATE OR REPLACE PACKAGE CPI.GIUTS025_PKG
AS

    TYPE policy_type IS RECORD(
        par_id              gipi_polbasic.par_id%TYPE,
        policy_id           gipi_polbasic.policy_id%TYPE,
        line_cd             gipi_polbasic.line_cd%TYPE,
        subline_cd          gipi_polbasic.subline_cd%TYPE,
        iss_cd              gipi_polbasic.iss_cd%TYPE,
        issue_yy            gipi_polbasic.issue_yy%TYPE,
        pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
        renew_no            gipi_polbasic.renew_no%TYPE,
        endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
        endt_yy             gipi_polbasic.endt_yy%TYPE,
        endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
        assd_no             gipi_polbasic.assd_no%TYPE,
        assd_name           giis_assured.assd_name%TYPE,
        n_endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
        n_endt_yy           gipi_polbasic.endt_yy%TYPE,
        n_endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
        ref_pol_no          gipi_polbasic.REF_POL_NO%type,
        manual_renew_no     gipi_polbasic.MANUAL_RENEW_NO%type,
        ref_accept_no       giri_inpolbas.REF_ACCEPT_NO%type,
        accept_no           giri_inpolbas.ACCEPT_NO%type,
        active_renewal      VARCHAR2(1),
        ongoing_renewal     VARCHAR2(1)
    );
    
    TYPE policy_tab IS TABLE OF policy_type;
    
    
    FUNCTION get_policy_listing(
        p_line_cd           gipi_polbasic.LINE_CD%type,
        p_subline_cd        gipi_polbasic.SUBLINE_CD%type,
        p_iss_cd            gipi_polbasic.ISS_CD%type,
        p_issue_yy          gipi_polbasic.ISSUE_YY%type,
        p_pol_seq_no        gipi_polbasic.POL_SEQ_NO%type,
        p_renew_no          gipi_polbasic.RENEW_NO%type,
        p_n_endt_iss_cd     VARCHAR2,
        p_n_endt_yy         VARCHAR2,
        p_n_endt_seq_no     VARCHAR2,
        p_ref_pol_no        gipi_polbasic.REF_POL_NO%type,
        p_manual_renew_no   gipi_polbasic.MANUAL_RENEW_NO%type,
        p_user_id           VARCHAR2
    ) RETURN policy_tab PIPELINED;
    
    
    PROCEDURE update_gipi_polbasic(
        p_policy_id             IN  gipi_polbasic.POLICY_ID%type,
        p_new_ref_pol_no        IN  gipi_polbasic.REF_POL_NO%type,
        p_new_manual_renew_no   IN  gipi_polbasic.MANUAL_RENEW_NO%type,
		p_new_ref_accept_no   	IN  giri_inpolbas.REF_ACCEPT_NO%type --added by robert SR 5165 11.05.15
    ); 
    
    
    TYPE invoice_type IS RECORD(
        policy_id       gipi_invoice.POLICY_ID%type,
        iss_cd          gipi_invoice.ISS_CD%type,
        ref_inv_no      gipi_invoice.REF_INV_NO%type,
        prem_seq_no     gipi_invoice.PREM_SEQ_NO%type,
        invoice_no      VARCHAR2(20)
    );
    
    TYPE invoice_tab IS TABLE OF invoice_type;
    
    FUNCTION get_invoice_listing(
        p_policy_id         gipi_invoice.POLICY_ID%type,
        p_iss_cd            gipi_invoice.ISS_CD%type
    ) RETURN invoice_tab PIPELINED;


    PROCEDURE update_gipi_invoice(
        p_iss_cd            IN  gipi_invoice.ISS_CD%type,
        p_prem_seq_no       IN  gipi_invoice.PREM_SEQ_NO%type,
        p_new_ref_inv_no    IN  gipi_invoice.REF_INV_NO%type
    );

END GIUTS025_PKG;
/


