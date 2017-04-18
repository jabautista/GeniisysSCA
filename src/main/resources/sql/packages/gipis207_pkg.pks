CREATE OR REPLACE PACKAGE CPI.GIPIS207_PKG AS

    TYPE par_type IS RECORD(
        par_id      batch_parlist_v2.par_id%TYPE,
        par_no      VARCHAR2(50),
        line_cd     batch_parlist_v2.line_cd%TYPE,
        subline_cd  batch_parlist_v2.subline_cd%TYPE,
        iss_cd      batch_parlist_v2.iss_cd%TYPE,
        assd_no     batch_parlist_v2.assd_no%TYPE,
        assd_name   giis_assured.assd_name%TYPE,
        user_id     batch_parlist_v2.user_id%TYPE,
        par_type    batch_parlist_v2.par_type%TYPE,
        par_yy      batch_parlist_v2.par_yy%TYPE,
        par_seq_no  batch_parlist_v2.par_seq_no%TYPE,
        quote_seq_no batch_parlist_v2.quote_seq_no%TYPE,
        bank_ref_no batch_parlist_v2.bank_ref_no%TYPE,
        posting_sw  VARCHAR2(1)
    );
   
    TYPE par_tab IS TABLE OF par_type;  

    TYPE error_log_type IS RECORD(
        par_id      giis_post_error_log.par_id%TYPE,
        par_no      VARCHAR2(100),
        remarks     giis_post_error_log.remarks%TYPE,
        user_id     giis_post_error_log.user_id%TYPE
    );
   
    TYPE error_log_tab IS TABLE OF error_log_type;

    TYPE posted_log_type IS RECORD(
        par_id      giis_posted_log.par_id%TYPE,
        par_no      VARCHAR2(100),
        policy_no   VARCHAR2(100),
        remarks     giis_posted_log.remarks%TYPE,
        user_id     giis_posted_log.user_id%TYPE
    );
   
    TYPE posted_log_tab IS TABLE OF posted_log_type;    
    

    TYPE lov_type IS RECORD(
        line_cd      giis_line.line_cd%TYPE,
        subline_cd   giis_subline.subline_cd%TYPE,
        subline_name giis_subline.subline_name%TYPE,
        iss_cd       giis_issource.iss_cd%TYPE,
        iss_name     giis_issource.iss_name%TYPE,
        user_id      giis_users.user_id%TYPE,
        user_name    giis_users.user_name%TYPE
    );
   
    TYPE lov_tab IS TABLE OF lov_type;          
    
    FUNCTION get_iss_cd_batch_posting(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN VARCHAR2;

    FUNCTION get_par_list_batch_posting(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN par_tab PIPELINED;

    FUNCTION get_error_log(
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN error_log_tab PIPELINED;

    FUNCTION get_posted_log(
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN posted_log_tab PIPELINED;              
    
    FUNCTION get_subline_list_batch_posting(
        p_line_cd       giis_line.line_cd%TYPE
    )
        RETURN lov_tab PIPELINED;
    
    FUNCTION get_iss_list_batch_posting(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN lov_tab PIPELINED; 
                     
    FUNCTION get_user_list_batch_posting
        RETURN lov_tab PIPELINED; 

    PROCEDURE delete_log(p_user_id giis_users.user_id%TYPE); 

    FUNCTION check_endt(
        p_par_id        batch_parlist_v2.par_id%TYPE
    )
        RETURN CHAR;       

    PROCEDURE check_if_back_endt(
        p_par_id    IN   GIPI_PARLIST.par_id%TYPE,
        p_message   OUT  VARCHAR2
    );            

    PROCEDURE pre_post_error2(
        p_par_id   IN NUMBER,
        p_remarks  IN VARCHAR2,
        p_module_id IN VARCHAR2
    );    

    PROCEDURE post_posted_log(
        p_par_id   IN NUMBER,
        p_user_id  IN VARCHAR,
        p_remarks  IN VARCHAR
    );       

    PROCEDURE check_cancel_par_posting(
        p_par_id   IN gipi_wpolbas.par_id%TYPE,
        p_message   OUT  VARCHAR2
    );
                                                                            
END GIPIS207_pkg;
/


