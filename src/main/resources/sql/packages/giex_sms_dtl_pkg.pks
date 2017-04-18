CREATE OR REPLACE PACKAGE CPI.GIEX_SMS_DTL_PKG
AS
    TYPE giex_sms_dtl_type IS RECORD(
        policy_id               GIEX_SMS_DTL.policy_id%TYPE,
        cellphone_no            GIEX_SMS_DTL.cellphone_no%TYPE,
        message                 GIEX_SMS_DTL.message%TYPE,
        date_received           GIEX_SMS_DTL.date_received%TYPE,
        date_sent               GIEX_SMS_DTL.date_sent%TYPE,
        date_created            GIEX_SMS_DTL.date_created%TYPE,
        user_id                 GIEX_SMS_DTL.user_id%TYPE,
        last_update             GIEX_SMS_DTL.last_update%TYPE,
        recipient_sender        GIEX_SMS_DTL.recipient_sender%TYPE,
        msg_id                  GIEX_SMS_DTL.msg_id%TYPE,
        dtl_id                  GIEX_SMS_DTL.dtl_id%TYPE,
        message_type            GIEX_SMS_DTL.message_type%TYPE,
        message_status          VARCHAR2(100),
        dsp_date_created        VARCHAR2(50),
        dsp_date_sent           VARCHAR2(50),
        dsp_date_received       VARCHAR2(50)
    );
    TYPE giex_sms_dtl_tab IS TABLE OF giex_sms_dtl_type;
    
    TYPE policy_details_dtls IS RECORD(
        iss_cd                  GIPI_INVOICE.iss_cd%TYPE,
        prem_seq_no             GIPI_INVOICE.prem_seq_no%TYPE,
        due_date                VARCHAR2(25),
        balance_due             GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE,
        invoice_no              VARCHAR2(100)
    );
    TYPE policy_details_tab IS TABLE OF policy_details_dtls;
    
    TYPE claim_details_dtls IS RECORD(
        iss_cd                  GICL_CLAIMS.iss_cd%TYPE,
        clm_yy                  GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no              GICL_CLAIMS.clm_seq_no%TYPE,
        loss_res_amt            GICL_CLAIMS.loss_res_amt%TYPE,
        loss_pd_amt             GICL_CLAIMS.loss_pd_amt%TYPE,
        clm_file_date           VARCHAR2(25),
        clm_stat_desc           GIIS_CLM_STAT.clm_stat_desc%TYPE,
        claim_no                VARCHAR2(100)
    );
    TYPE claim_details_tab IS TABLE OF claim_details_dtls;
    
    FUNCTION get_giex_sms_dtl(
        p_policy_id             GIEX_SMS_DTL.policy_id%TYPE
    )
      RETURN giex_sms_dtl_tab PIPELINED;
      
    FUNCTION get_policy_details(
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd                GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE
    )
      RETURN policy_details_tab PIPELINED;
      
    FUNCTION get_claim_details(
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd                GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE
    )
      RETURN claim_details_tab PIPELINED;
      
    PROCEDURE check_sms_assured(
        p_policy_id     IN      GIEX_SMS_DTL.policy_id%TYPE,
        p_assd_no       IN      GIEX_EXPIRY.assd_no%TYPE,
        p_assd_cp_no    OUT     GIIS_ASSURED.cp_no%TYPE,
        p_msg_count     OUT     NUMBER
    );
    
    PROCEDURE check_sms_intm(
        p_policy_id     IN      GIEX_SMS_DTL.policy_id%TYPE,
        p_intm_no       IN      GIEX_EXPIRY.intm_no%TYPE,
        p_intm_cp_no    OUT     GIIS_INTERMEDIARY.cp_no%TYPE,
        p_msg_count     OUT     NUMBER
    );
    
    PROCEDURE update_sms_tags(
        p_policy_id             GIEX_SMS_DTL.policy_id%TYPE,
        p_assd_sms              GIEX_EXPIRY.assd_sms%TYPE,
        p_intm_sms              GIEX_EXPIRY.intm_sms%TYPE
    );
    
    PROCEDURE generate_sms(
        p_user_id               GIEX_SMS_DTL.user_id%TYPE
    );
    
    PROCEDURE save_sms_renewal(
        p_policy_id             GIEX_EXPIRY.policy_id%TYPE,
        p_renew_flag            GIEX_EXPIRY.renew_flag%TYPE,
        p_remarks               GIEX_EXPIRY.remarks%TYPE
    );

END GIEX_SMS_DTL_PKG;
/


