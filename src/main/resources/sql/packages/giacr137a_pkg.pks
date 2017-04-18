CREATE OR REPLACE PACKAGE CPI.GIACR137A_PKG AS
    
    TYPE main_report_record_type IS RECORD (
        company_name    giis_parameters.param_value_v%TYPE,
        company_address giis_parameters.param_value_v%TYPE,
        cession_year    gixx_trty_prem_comm.cession_year%TYPE,
        line_cd         giis_line.line_cd%TYPE,
        share_cd        giis_dist_share.share_cd%TYPE,
        treaty_yy       giis_dist_share.trty_yy%TYPE,
        trty_com_rt     gixx_trty_prem_comm.trty_com_rt%TYPE,
        quarter_year    VARCHAR2(100),
        line_treaty     VARCHAR2(100),
        cf_month        VARCHAR2(100),
        cf_month_dum    VARCHAR2(100), -- added by MarkS SR5867 cause cf_month was used.
        comm_per_branch gixx_trty_prem_comm.commission_amt%TYPE,
        cession_year1   gixx_trty_prem_comm.cession_year%TYPE,  
        cession_mm1     gixx_trty_prem_comm.cession_mm%TYPE,  
        line_cd1        giis_line.line_cd%TYPE, 
        share_cd1       giis_dist_share.share_cd%TYPE,  
        branch_cd1      gixx_trty_prem_comm.branch_cd%TYPE,
        trty_com_rt2    gixx_trty_prem_comm.trty_com_rt%TYPE,
        header_flag     VARCHAR2 (1),
        --
        ri_sname     giis_reinsurer.ri_sname%TYPE,
        share_pct    VARCHAR2(10),
        line_cd2     giis_line.line_cd%TYPE,         
        trty_seq_no2 giis_trty_panel.trty_seq_no%TYPE,
        cession_mm   gixx_trty_prem_comm.cession_mm%TYPE,  
        prnt_ri_cd2  giis_trty_panel.prnt_ri_cd%TYPE,
        branch_cd    gixx_trty_prem_comm.branch_cd%TYPE,
        commission   gixx_trty_prem_comm.commission_amt%TYPE,
        commission1   gixx_trty_prem_comm.commission_amt%TYPE,
        commission2   gixx_trty_prem_comm.commission_amt%TYPE,
        commission3   gixx_trty_prem_comm.commission_amt%TYPE,
        commission4   gixx_trty_prem_comm.commission_amt%TYPE,
        commission5   gixx_trty_prem_comm.commission_amt%TYPE,
        commission6   gixx_trty_prem_comm.commission_amt%TYPE,
        commission7   gixx_trty_prem_comm.commission_amt%TYPE,
        mm_total             NUMBER (16, 2),
        grp_ris      VARCHAR2(100)
        --     
    );

    TYPE main_report_record_tab IS TABLE OF main_report_record_type;
    
    TYPE report_detail_record_type IS RECORD(
        ri_sname     giis_reinsurer.ri_sname%TYPE,
        share_pct    VARCHAR2(10),
        line_cd2     giis_line.line_cd%TYPE,         
        trty_seq_no2 giis_trty_panel.trty_seq_no%TYPE,
        cf_month     VARCHAR2(100),
        cession_mm   gixx_trty_prem_comm.cession_mm%TYPE,  
        prnt_ri_cd2  giis_trty_panel.prnt_ri_cd%TYPE,
        branch_cd    gixx_trty_prem_comm.branch_cd%TYPE,
        commission   gixx_trty_prem_comm.commission_amt%TYPE,
        --
        ri_sname1            giis_reinsurer.ri_sname%TYPE,
        shr_pct1             giis_trty_panel.trty_shr_pct%TYPE,
        ri_sname2            giis_reinsurer.ri_sname%TYPE,
        shr_pct2             giis_trty_panel.trty_shr_pct%TYPE,
        ri_sname3            giis_reinsurer.ri_sname%TYPE,
        shr_pct3             giis_trty_panel.trty_shr_pct%TYPE,
        ri_sname4            giis_reinsurer.ri_sname%TYPE,
        shr_pct4             giis_trty_panel.trty_shr_pct%TYPE,
        ri_sname5            giis_reinsurer.ri_sname%TYPE,
        shr_pct5             giis_trty_panel.trty_shr_pct%TYPE,
        ri_sname6            giis_reinsurer.ri_sname%TYPE,
        shr_pct6             giis_trty_panel.trty_shr_pct%TYPE,
        ri_sname7            giis_reinsurer.ri_sname%TYPE,
        shr_pct7             giis_trty_panel.trty_shr_pct%TYPE,
        commission1   gixx_trty_prem_comm.commission_amt%TYPE,
        commission2   gixx_trty_prem_comm.commission_amt%TYPE,
        commission3   gixx_trty_prem_comm.commission_amt%TYPE,
        commission4   gixx_trty_prem_comm.commission_amt%TYPE,
        commission5   gixx_trty_prem_comm.commission_amt%TYPE,
        commission6   gixx_trty_prem_comm.commission_amt%TYPE,
        commission7   gixx_trty_prem_comm.commission_amt%TYPE,
        mm_total             NUMBER (16, 2),
        grp_ris      VARCHAR2(100)
        --
    );
    
    TYPE report_detail_record_tab IS TABLE OF report_detail_record_type;
  
    FUNCTION get_main_report(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE  
    )
        RETURN main_report_record_tab PIPELINED;
        
    FUNCTION get_report_header(
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE
    )
        RETURN report_detail_record_tab PIPELINED;
        
    FUNCTION get_report_detail(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_trty_com_rt   gixx_trty_prem_comm.trty_com_rt%TYPE
    )
        RETURN report_detail_record_tab PIPELINED;
    
    FUNCTION get_report_column_detail(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_trty_com_rt   gixx_trty_prem_comm.trty_com_rt%TYPE
    )
        RETURN report_detail_record_tab PIPELINED;
END GIACR137A_PKG;
/
