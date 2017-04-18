CREATE OR REPLACE PACKAGE CPI.GIACR137C_PKG AS
    
    TYPE main_report_record_type IS RECORD (
        company_name    giis_parameters.param_value_v%TYPE,
        company_address giis_parameters.param_value_v%TYPE,
        quarter         VARCHAR2(100),
        line_cd         giis_line.line_cd%TYPE,
        trty_name       VARCHAR2(100),
        line_trty_name  VARCHAR2(100),
        cession_year    gixx_trty_prem_comm.cession_year%TYPE,
        cf_month        VARCHAR2(100),
        cession_mm      gixx_trty_prem_comm.cession_mm%TYPE,
        trty_com_rt     gixx_trty_prem_comm.trty_com_rt%TYPE,
        branch_cd       gixx_trty_prem_comm.branch_cd%TYPE,
        branch_cd_dum   gixx_trty_prem_comm.branch_cd%TYPE,
        share_cd        gixx_trty_prem_comm.share_cd%TYPE,
        commmission     gixx_trty_prem_comm.commission_amt%TYPE,
        header_flag     VARCHAR2 (1),
        --MK
        prnt_ri_cd        gixx_trty_prem_comm.prnt_ri_cd%TYPE,
        ri_sname          giis_reinsurer.ri_sname%TYPE,
        trty_shr_pct      gixx_trty_prem_comm.trty_shr_pct%TYPE,
        branch_count      NUMBER(5)
        --
    );

    TYPE main_report_record_tab IS TABLE OF main_report_record_type;
    
    TYPE report_detail_record_type IS RECORD(
        cession_mm        gixx_trty_prem_comm.cession_mm%TYPE,
        branch_cd         gixx_trty_prem_comm.branch_cd%TYPE,  
        prnt_ri_cd        gixx_trty_prem_comm.prnt_ri_cd%TYPE,
        ri_sname          giis_reinsurer.ri_sname%TYPE,
        trty_shr_pct      gixx_trty_prem_comm.trty_shr_pct%TYPE,
        commmission       gixx_trty_prem_comm.commission_amt%TYPE,
        share_cd          gixx_trty_prem_comm.share_cd%TYPE,
        branch_count      NUMBER(5)
    );
    
    TYPE report_detail_record_tab IS TABLE OF report_detail_record_type;
    
    TYPE report_recap_record_type IS RECORD(
        share_cd          gixx_trty_prem_comm.share_cd%TYPE,
        line_cd_grand     gixx_trty_prem_comm.line_cd%TYPE,
        trty_name1        giis_dist_share.trty_name%TYPE,
        cession_year1     gixx_trty_prem_comm.cession_year%TYPE,  
        cession_mm1       gixx_trty_prem_comm.cession_mm%TYPE,
        month_grand       VARCHAR2(100),
        trty_com_rt1      gixx_trty_prem_comm.trty_com_rt%TYPE,
        ri_sname_grand    giis_reinsurer.ri_sname%TYPE,
        commission_grand  gixx_trty_prem_comm.commission_amt%TYPE         
    );
    
    TYPE report_recap_record_tab IS TABLE OF report_recap_record_type;
  
    FUNCTION get_main_report(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE  
    )
        RETURN main_report_record_tab PIPELINED;   
        
    FUNCTION get_report_detail(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN report_detail_record_tab PIPELINED;

    FUNCTION get_report_recap(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN report_recap_record_tab PIPELINED;
        
END GIACR137C_PKG;
/
