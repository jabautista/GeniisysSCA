CREATE OR REPLACE PACKAGE CPI.giacs412_pkg
AS
   TYPE giac_cancelled_policies_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,  
      policy_id          giac_cancelled_policies_v.policy_id%TYPE,  
      policy_number      VARCHAR2 (50),
      tsi_amt            giac_cancelled_policies_v.tsi_amt%TYPE, 
      prem_amt           giac_cancelled_policies_v.prem_amt%TYPE, 
      line_cd            giac_cancelled_policies_v.line_cd%TYPE,   
      subline_cd         giac_cancelled_policies_v.subline_cd%TYPE,   
      iss_cd             giac_cancelled_policies_v.iss_cd%TYPE,  
      issue_yy           giac_cancelled_policies_v.issue_yy%TYPE,
      pol_seq_no         giac_cancelled_policies_v.pol_seq_no%TYPE, 
      renew_no           giac_cancelled_policies_v.renew_no%TYPE, 
      assd_name          giac_cancelled_policies_v.assd_name%TYPE,
      incept_date        giac_cancelled_policies_v.incept_date%TYPE, 
      expiry_date        giac_cancelled_policies_v.expiry_date%TYPE,
      reg_policy_sw      giac_cancelled_policies_v.reg_policy_sw%TYPE,
      cancellation_tag   giac_cancelled_policies_v.cancellation_tag%TYPE
   );

   TYPE giac_cancelled_policies_tab IS TABLE OF giac_cancelled_policies_type;

   TYPE giac_endorsement_policies_type IS RECORD (
      endt_number        VARCHAR2 (50),
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      eff_date           gipi_polbasic.eff_date%TYPE,
      issue_date         gipi_polbasic.issue_date%TYPE,
      endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE,
      tsi_amt            gipi_polbasic.tsi_amt%TYPE,
      prem_amt           gipi_polbasic.prem_amt%TYPE
   );

   TYPE giac_endorsement_policies_tab IS TABLE OF giac_endorsement_policies_type;

    FUNCTION get_cancelled_policies_records (
        p_user_id           giis_users.user_id%TYPE,
        p_policy_number     VARCHAR2,
        p_assd_name         giis_assured.ASSD_NAME%TYPE,
        p_incept_date       VARCHAR2,
        p_expiry_date       VARCHAR2,
        p_tsi_amt           gipi_polbasic.TSI_AMT%TYPE,
        p_prem_amt          gipi_polbasic.PREM_AMT%TYPE,
        p_order_by          VARCHAR2,
        p_asc_desc_flag     VARCHAR2,
        p_row_from          NUMBER,
        p_row_to            NUMBER     
    )  RETURN giac_cancelled_policies_tab PIPELINED;

   FUNCTION get_endorsement_records (
      p_user_id      giis_users.user_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN giac_endorsement_policies_tab PIPELINED;

   PROCEDURE process_payments (
      p_cancellation_tag            VARCHAR2,
      p_line_cd                     VARCHAR2,
      p_subline_cd                  VARCHAR2,
      p_iss_cd                      VARCHAR2,
      p_issue_yy                    VARCHAR2,
      p_pol_seq_no                  VARCHAR2,
      p_renew_no                    VARCHAR2,
      p_user_id                     giis_users.user_id%TYPE,
      p_tran_id            IN OUT   VARCHAR2
   );

   PROCEDURE populate_giac_acctrans (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_branch_cd   gipi_polbasic.iss_cd%TYPE
   );

   PROCEDURE populate_giac_direct_prem (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   );

   PROCEDURE populate_giac_comm_payts (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   );
      
   -- ================================================
   -- for enhancement : shan 04.15.2015
   
    TYPE policies_for_reverse_type IS RECORD (
        count_             NUMBER,
        rownum_            NUMBER,
        policy_id          gipi_polbasic.policy_id%TYPE,
        policy_number      VARCHAR2 (50),
        tsi_amt            gipi_polbasic.tsi_amt%TYPE,
        prem_amt           gipi_polbasic.prem_amt%TYPE,
        line_cd            gipi_polbasic.line_cd%TYPE,
        subline_cd         gipi_polbasic.subline_cd%TYPE,
        iss_cd             gipi_polbasic.iss_cd%TYPE,
        issue_yy           gipi_polbasic.issue_yy%TYPE,
        pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
        renew_no           gipi_polbasic.renew_no%TYPE,
        assd_no            giis_assured.ASSD_NO%TYPE,
        assd_name          giis_assured.assd_name%TYPE,
        incept_date        gipi_polbasic.incept_date%TYPE,
        expiry_date        gipi_polbasic.expiry_date%TYPE
    );

    TYPE policies_for_reverse_tab IS TABLE OF policies_for_reverse_type;
   
    FUNCTION get_policies_for_reverse (
        p_user_id           giis_users.user_id%TYPE,
        p_policy_number     VARCHAR2,
        p_assd_name         giis_assured.ASSD_NAME%TYPE,
        p_incept_date       VARCHAR2,
        p_expiry_date       VARCHAR2,
        p_tsi_amt           gipi_polbasic.TSI_AMT%TYPE,
        p_prem_amt          gipi_polbasic.PREM_AMT%TYPE,
        p_order_by          VARCHAR2,
        p_asc_desc_flag     VARCHAR2,
        p_row_from          NUMBER,
        p_row_to            NUMBER     
    ) RETURN policies_for_reverse_tab PIPELINED;
    
    PROCEDURE reverse_processed_pol(
        p_line_cd           VARCHAR2,
        p_subline_cd        VARCHAR2,
        p_iss_cd            VARCHAR2,
        p_issue_yy          VARCHAR2,
        p_pol_seq_no        VARCHAR2,
        p_renew_no          VARCHAR2,
        p_user_id           VARCHAR2
    );
    
    -- end enhancement : shan 04.15.2015
    -- ================================================
END;
/
