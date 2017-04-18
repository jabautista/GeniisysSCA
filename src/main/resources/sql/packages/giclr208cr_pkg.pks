CREATE OR REPLACE PACKAGE CPI.giclr208cr_pkg
AS 
    TYPE giclr208cr_type IS RECORD (
        intm_no           gicl_res_brdrx_extr.intm_no%TYPE,
        intm_name         giis_intermediary.intm_name%TYPE,
        iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,
        iss_name          giis_issource.iss_name%TYPE,
        line_cd           gicl_res_brdrx_extr.line_cd%TYPE,
        line_name         giis_line.line_name%TYPE,
        claim_no          gicl_res_brdrx_extr.claim_no%TYPE,
        policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
        clm_file_date     gicl_res_brdrx_extr.clm_file_date%TYPE,
        eff_date          gicl_claims.pol_eff_date%TYPE,
        loss_date         gicl_res_brdrx_extr.loss_date%TYPE,
        assd_name         giis_assured.assd_name%TYPE,
        loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE,
        no_of_days        NUMBER(38),
        claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
        brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
        v_company_name    VARCHAR2(500),
        v_company_address VARCHAR2(500),
        v_title           VARCHAR2(100),
        v_param_date      VARCHAR2(100),
        v_date            VARCHAR2(100),
        exist             VARCHAR2(1)
    );
    TYPE giclr208cr_tab IS TABLE OF giclr208cr_type;
    
    TYPE giclr208cr_col_title_type IS RECORD (
        column_title   giis_report_aging.column_title%TYPE,
        column_no      giis_report_aging.column_no%TYPE
   );
   
   TYPE giclr208cr_col_title_tab IS TABLE OF giclr208cr_col_title_type;
   
   TYPE giclr208cr_os_loss_type IS RECORD (
        column_no         NUMBER(10),
        outstanding_loss  NUMBER(16,2)    
   );
   TYPE giclr208cr_os_loss_tab IS TABLE OF giclr208cr_os_loss_type;
   
   
FUNCTION get_giclr208cr_details (
    p_session_id   NUMBER,
    p_claim_id     NUMBER,
    p_date_option  NUMBER,
    p_from_date    VARCHAR2,
    p_to_date      VARCHAR2,
    p_as_of_date   VARCHAR2,
    p_os_date      NUMBER,
    p_aging_date   VARCHAR2,
    p_cut_off_date VARCHAR2,
    p_intm_break   NUMBER,
    p_iss_break    NUMBER
    )   
    RETURN  giclr208cr_tab PIPELINED;
FUNCTION get_giclr208cr_col_title
    RETURN giclr208cr_col_title_tab PIPELINED;
FUNCTION get_giclr208cr_os_loss (
    p_session_id      NUMBER,
    p_claim_id        NUMBER,
    p_no_of_days      NUMBER
    )
    RETURN giclr208cr_os_loss_tab PIPELINED;
FUNCTION get_giclr208cr_line_tot (
     p_session_id      NUMBER,
     p_claim_id        NUMBER,
     p_line_cd         VARCHAR2,
     p_cut_off_date    VARCHAR,
     p_aging_date      NUMBER,
     p_intm_no         VARCHAR2,
     p_iss_cd          VARCHAR2
    )
    RETURN giclr208cr_os_loss_tab PIPELINED;
FUNCTION get_giclr208cr_branch_tot(
     p_session_id      NUMBER,
     p_claim_id        NUMBER,
     p_cut_off_date    VARCHAR,
     p_aging_date      NUMBER,
     p_iss_cd          VARCHAR2
)    
    RETURN giclr208cr_os_loss_tab PIPELINED;
FUNCTION get_giclr208cr_intm_tot(
     p_session_id      NUMBER,
     p_claim_id        NUMBER,
     p_cut_off_date    VARCHAR,
     p_aging_date      NUMBER,
     p_intm_no          VARCHAR2
   )    
    RETURN giclr208cr_os_loss_tab PIPELINED;
FUNCTION get_giclr208cr_grand_tot(
     p_session_id      NUMBER,
     p_claim_id        NUMBER,
     p_cut_off_date    VARCHAR,
     p_aging_date      NUMBER
   )    
    RETURN giclr208cr_os_loss_tab PIPELINED;

END;
/


