CREATE OR REPLACE PACKAGE CPI.GIACS121_PKG AS

    TYPE soa_facul_ri_lov_type IS RECORD(
        line_cd     giis_line.line_cd%TYPE,
        line_name   giis_line.line_name%TYPE,
        ri_cd       giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        ri_name     giis_reinsurer.ri_name%TYPE
    );
    
    TYPE soa_facul_ri_lov_tab IS TABLE OF soa_facul_ri_lov_type;

    TYPE last_extract_type IS RECORD(
        from_date    giac_ri_stmt_ext.from_date%TYPE,
        to_date      giac_ri_stmt_ext.to_date%TYPE,
        cut_off_date giac_ri_stmt_ext.cut_off_date%TYPE
    );
    
    TYPE last_extract_tab IS TABLE OF last_extract_type;

    FUNCTION get_last_extract(
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN last_extract_tab PIPELINED;    
    
    FUNCTION get_soa_facul_ri_line(
        p_ri_cd     giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN soa_facul_ri_lov_tab PIPELINED;

    FUNCTION get_soa_facul_ri_lov
        RETURN soa_facul_ri_lov_tab PIPELINED;

    PROCEDURE delete_soa_facul_ri(
        p_user_id   giis_users.user_id%TYPE    
    );

    PROCEDURE extract_soa_facul_ri(
        p_date_tag      VARCHAR2,
        p_curr_tag      VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_cut_off_date  VARCHAR2,
        p_line_cd       giis_line.line_cd%TYPE,
        p_ri_cd         giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_msg       OUT VARCHAR2  
    );
            
END GIACS121_PKG;
/


