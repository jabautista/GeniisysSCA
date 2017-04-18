CREATE OR REPLACE PACKAGE CPI.GIACS289_PKG
AS
    TYPE bill_per_policy_type IS RECORD (
        line_cd         VARCHAR2(2),
        subline_cd      VARCHAR2(7),
        iss_cd_gp       VARCHAR2(2),
        issue_yy        NUMBER(2),
        pol_seq_no      NUMBER(7),                       
        renew_no        NUMBER(2),
        endt_iss_cd     VARCHAR2(2),
        endt_yy         NUMBER(2),
        endt_seq_no     NUMBER(6),
        iss_cd          VARCHAR2(2),
        prem_seq_no     NUMBER(12),
        prem_amt        NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        tax_amt         NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        receivable      NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        prem_os         NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014    
        prem_paid       NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        comm_paid       NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        comm            NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        wtax            NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        ivat            NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        net_comm        NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        net_recv        NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        comm_os         NUMBER(19,9),-- NUMBER(12,2),  -- shan 11.21.2014
        --added by MarkS for Sr-22136 total 
        prem_amt_tot    NUMBER(19,9),
        tax_amt_tot     NUMBER(19,9),
        receivable_tot  NUMBER(19,9),
        prem_os_tot     NUMBER(19,9),    
        prem_paid_tot   NUMBER(19,9),
        comm_paid_tot   NUMBER(19,9),
        comm_tot        NUMBER(19,9),
        wtax_tot        NUMBER(19,9),
        ivat_tot        NUMBER(19,9),
        net_comm_tot    NUMBER(19,9),
        net_recv_tot    NUMBER(19,9),
        comm_os_tot     NUMBER(19,9),
        --end SR-22136
        currency_rt     NUMBER(12,9)
        
    );
    TYPE bill_per_policy_tab IS TABLE OF bill_per_policy_type;
    
    FUNCTION get_bill_per_policy ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE
    )
    RETURN bill_per_policy_tab PIPELINED;
    
    
    FUNCTION get_bill_per_policy2 ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE,
            p_prem_os           VARCHAR2,
            p_prem_comm_os      VARCHAR2
    )
    RETURN bill_per_policy_tab PIPELINED;
    
    FUNCTION get_bill_per_policy_table ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE,
            p_prem_os           VARCHAR2,
            p_prem_comm_os      VARCHAR2
    )
    RETURN bill_per_policy_tab PIPELINED;
        
    TYPE bill_per_policy_lov_type IS RECORD (
        --policy_id           NUMBER(12),
        line_cd             VARCHAR2(2),
        subline_cd          VARCHAR2(7),
        iss_cd              VARCHAR2(2),
        issue_yy            NUMBER(2),
        pol_seq_no          NUMBER(7),
        renew_no            NUMBER(12),
        ref_pol_no          VARCHAR2(30),
        intm_no             NUMBER(12),
        intm_name           VARCHAR2(240),
        assd_no             NUMBER(12),
        assd_name           VARCHAR2(500),
        policy_no           VARCHAR2(50)
    );
    
    TYPE bill_per_policy_lov_tab IS TABLE OF bill_per_policy_lov_type;
    
    FUNCTION get_bill_per_policy_lov(
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE,
            p_assd_no           GIIS_ASSURED.assd_no%TYPE,
            p_module_id         giis_modules.module_id%TYPE,
            p_user_id           giis_users.user_id%TYPE
    )
    RETURN bill_per_policy_lov_tab PIPELINED;   
    
    TYPE bill_per_policy_prem_type IS RECORD (
        collection_amt      GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
        b140_iss_cd         GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
        b140_prem_seq_no    GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
        branch_cd           GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        tran_date           GIAC_ACCTRANS.tran_date%TYPE,
        ref_no              VARCHAR2(50),
        line_cd             GIPI_POLBASIC.line_cd%TYPE,
        subline_cd          GIPI_POLBASIC.subline_cd%TYPE,
        iss_cd              GIPI_POLBASIC.iss_cd%TYPE,
        issue_yy            GIPI_POLBASIC.issue_yy%TYPE,
        pol_seq_no          GIPI_POLBASIC.pol_seq_no%TYPE,
        renew_no            GIPI_POLBASIC.renew_no%TYPE
    );
    
    TYPE bill_per_policy_prem_tab IS TABLE OF bill_per_policy_prem_type;
    
    FUNCTION get_bill_per_policy_prem ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_prem_seq_no       GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE
    )
    RETURN bill_per_policy_prem_tab PIPELINED;
    
    TYPE bill_per_policy_comm_type IS RECORD (
        comm_amt            NUMBER(12,2),
        wtax_amt            NUMBER(12,2),
        input_vat_amt       NUMBER(12,2),
        net_comm            NUMBER(12,2),
        ref_no              VARCHAR2(50),
        gcp_iss_cd          VARCHAR2(5),
        prem_seq_no         NUMBER(12),
        branch_cd           VARCHAR2(5),
        tran_date           GIAC_ACCTRANS.tran_date%TYPE,
        line_cd             GIPI_POLBASIC.line_cd%TYPE,
        subline_cd          GIPI_POLBASIC.subline_cd%TYPE,
        iss_cd              GIPI_POLBASIC.iss_cd%TYPE,
        issue_yy            GIPI_POLBASIC.issue_yy%TYPE,
        pol_seq_no          GIPI_POLBASIC.pol_seq_no%TYPE,
        renew_no            GIPI_POLBASIC.renew_no%TYPE
    );
    
    TYPE bill_per_policy_comm_tab IS TABLE OF bill_per_policy_comm_type;
    
    FUNCTION get_bill_per_policy_comm ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_prem_seq_no       GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE  -- shan 11.24.2014
    )
    RETURN bill_per_policy_comm_tab PIPELINED;
    
END;
/
