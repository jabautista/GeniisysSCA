CREATE OR REPLACE PACKAGE CPI.GIACS136_PKG AS 

    TYPE treaty_type IS RECORD(
        share_cd    giis_dist_share.share_cd%TYPE,
        treaty_name giis_dist_share.trty_name%TYPE    
    );
    
    TYPE treaty_tab IS TABLE OF treaty_type;
    
    
    TYPE line_type IS RECORD(
        line_cd     giis_line.line_cd%TYPE,
        line_name   giis_line.line_name%TYPE
    );
    
    TYPE line_tab IS TABLE OF line_type;

    TYPE param_type IS RECORD(
        cession_year gixx_trty_prem_comm.cession_year%TYPE,
        cession_mm   gixx_trty_prem_comm.cession_mm%TYPE,
        share_cd     giis_dist_share.share_cd%TYPE,
        treaty_name  giis_dist_share.trty_name%TYPE,  
        line_cd      giis_line.line_cd%TYPE,
        line_name    giis_line.line_name%TYPE
    );
    
    TYPE param_tab IS TABLE OF param_type;    
    --added by MarkS 12.14.2016 SR5867 optimization
    TYPE extract_records_type IS RECORD(
        branch_cd gixx_trty_prem_comm.branch_cd%TYPE,
        treaty_yy gixx_trty_prem_comm.treaty_yy%TYPE,  
        prnt_ri_cd    gixx_trty_prem_comm.prnt_ri_cd%TYPE, 
        trty_shr_pct  gixx_trty_prem_comm.trty_shr_pct%TYPE, 
        trty_com_rt  gixx_trty_prem_comm.trty_com_rt%TYPE, 
        premium_amt  gixx_trty_prem_comm.premium_amt%TYPE, 
        commission_amt  gixx_trty_prem_comm.commission_amt%TYPE,
        cession_year gixx_trty_prem_comm.cession_year%TYPE,
        cession_mm   gixx_trty_prem_comm.cession_mm%TYPE,
        share_cd     gixx_trty_prem_comm.share_cd%TYPE,
        line_cd      gixx_trty_prem_comm.line_cd%TYPE
        
    );
    TYPE extract_records_tab IS TABLE OF extract_records_type; 
    
    FUNCTION get_prev_params(
        p_user_id       gixx_trty_prem_comm.user_id%TYPE
    )
        RETURN param_tab PIPELINED;     
    
    FUNCTION get_treaty_lov(
        p_quarter     gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year        gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd     gixx_trty_prem_comm.line_cd%TYPE
    )
        RETURN treaty_tab PIPELINED;
    
    FUNCTION get_line_lov(
        p_quarter   gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year      gixx_trty_prem_comm.cession_year%TYPE
    )
        RETURN line_tab PIPELINED;
        
    FUNCTION validate_existing_extract(
        p_quarter   gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year      gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id   giis_users.user_id%TYPE,
        p_line_cd   gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd  gixx_trty_prem_comm.share_cd%TYPE
    )
        RETURN VARCHAR2;
        
    PROCEDURE delete_extracted_records(
        p_quarter IN  gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year    IN  gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id IN  giis_users.user_id%TYPE
    );
    
    FUNCTION validate_before_insert(
        p_quarter IN  gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year    IN  gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id IN  giis_users.user_id%TYPE
    )
        RETURN VARCHAR2;

    PROCEDURE extract_records(
        p_quarter  IN  gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year     IN  gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id  IN  giis_users.user_id%TYPE,
        p_line_cd  IN  gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd IN  gixx_trty_prem_comm.share_cd%TYPE,
        p_msg      OUT VARCHAR2
    );
END giacs136_pkg;
/


