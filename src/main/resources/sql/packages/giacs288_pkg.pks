CREATE OR REPLACE PACKAGE CPI.GIACS288_PKG AS

    TYPE giacs288_type IS RECORD(
        iss_cd              gipi_invoice.iss_cd%TYPE,
        prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
        line_cd             gipi_polbasic.line_cd%TYPE,
        subline_cd          gipi_polbasic.subline_cd%TYPE,
        pol_iss_cd          gipi_polbasic.iss_cd%TYPE,
        issue_yy            gipi_polbasic.issue_yy%TYPE,
        pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
        renew_no            gipi_polbasic.renew_no%TYPE,
        endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
        endt_yy             gipi_polbasic.endt_yy%TYPE,
        endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
        endt_type           gipi_polbasic.endt_type%TYPE,
        ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
        assd_no             giis_assured.assd_no%TYPE,
        assd_name           giis_assured.assd_name%TYPE,
        bill_number         VARCHAR2(50),
        policy_number       VARCHAR2(50),
        endt_number         VARCHAR2(50),
        assured             VARCHAR2(600),
        prem_pd             NUMBER(16, 2),
        prem_os             NUMBER(16, 2),
        comm_pd             NUMBER(16, 2),
        comm_os             NUMBER(16, 2),
        total_prem_pd       NUMBER(16, 2),
        total_prem_os       NUMBER(16, 2),
        total_comm_pd       NUMBER(16, 2),
        total_comm_os       NUMBER(16, 2)
    );
    TYPE giacs288_tab IS TABLE OF giacs288_type;
    
    FUNCTION get_bills_per_intermediary(
        p_intm_no           giis_intermediary.intm_no%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_bill_number       VARCHAR2,
        p_policy_number     VARCHAR2,
        p_endt_number       VARCHAR2,
        p_assured           VARCHAR2,
        p_ref_pol_no        gipi_polbasic.ref_pol_no%TYPE
    )
      RETURN giacs288_tab PIPELINED;

END GIACS288_PKG;
/


