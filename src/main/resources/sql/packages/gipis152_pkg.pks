CREATE OR REPLACE PACKAGE CPI.GIPIS152_PKG
AS
    TYPE user_type IS RECORD (
        active_flag     giis_users.active_flag%TYPE,
        comm_update_tag giis_users.comm_update_tag%TYPE,
        all_user_sw     giis_users.all_user_sw%TYPE,
        mgr_sw          giis_users.mgr_sw%TYPE,
        user_id         giis_users.user_id%TYPE,
        user_name       giis_users.user_name%TYPE,
        user_grp        giis_users.user_grp%TYPE,
        user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
        grp_iss_cd      giis_user_grp_hdr.grp_iss_cd%TYPE,
        last_update     VARCHAR2(64),
        last_user_id    giis_users.last_user_id%TYPE,
        remarks         giis_users.remarks%TYPE
    );

    TYPE user_tab IS TABLE OF user_type;
    
    TYPE tran_type IS RECORD(
        tran_hdr_user_id giis_user_tran.userid%TYPE,
        tran_cd          giis_user_tran.tran_cd%TYPE,
        tran_desc        giis_transaction.tran_desc%TYPE,
        inc_all_tag      VARCHAR2(4)
    );
    
    TYPE tran_tab IS TABLE OF tran_type;
    
    TYPE iss_type IS RECORD(
        iss_cd          giis_user_iss_cd.iss_cd%TYPE,
        iss_name        giis_issource.iss_name%TYPE
    );
    
    TYPE iss_tab IS TABLE OF iss_type;
    
    TYPE line_type IS RECORD(
        line_cd         giis_user_line.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE
    );
    
    TYPE line_tab IS TABLE OF line_type;
    
    TYPE modules_type IS RECORD(
        mod_header_user_id  giis_user_modules.userid%TYPE,
        inc_tag             VARCHAR2(4),
        module_id           giis_modules.module_id%TYPE,
        module_desc         giis_modules.module_desc%TYPE,
        access_tag          giis_user_modules.access_tag%TYPE,
        access_tag_desc     cg_ref_codes.rv_meaning%TYPE,
        mod_remarks         giis_user_modules.remarks%TYPE,
        mod_user_id         giis_user_modules.user_id%TYPE,
        mod_last_update     VARCHAR2(64)
    );
    
    TYPE modules_tab IS TABLE OF modules_type;
    
    TYPE grp_tran_type IS RECORD(
        tran_user_grp       giis_user_grp_tran.user_grp%TYPE,
        tran_cd_grp         giis_user_tran.tran_cd%TYPE,
        tran_desc_grp       giis_transaction.tran_desc%TYPE
    );
    
    TYPE grp_tran_tab IS TABLE OF grp_tran_type; 
    
    TYPE grp_iss_type IS RECORD(
        iss_user_grp    giis_user_grp_dtl.user_grp%TYPE,
        iss_tran_cd_grp giis_user_grp_dtl.tran_cd%TYPE,
        iss_cd_grp      giis_user_grp_dtl.iss_cd%TYPE,
        iss_name_grp    giis_issource.iss_name%TYPE
    );
    
    TYPE grp_iss_tab IS TABLE OF grp_iss_type;
    
    TYPE grp_line_type IS RECORD(
        line_cd_grp      giis_user_grp_line.line_cd%TYPE,
        line_tran_cd_grp giis_user_grp_line.tran_cd%TYPE,
        line_user_grp    giis_user_grp_line.user_grp%TYPE,
        line_name_grp    giis_line.line_name%TYPE,
        acct_line_cd_grp giis_line.acct_line_cd%TYPE
    );
    
    TYPE grp_line_tab IS TABLE OF grp_line_type;

    TYPE modules_grp_type IS RECORD(
        mod_user_grp        giis_user_modules.userid%TYPE,
        inc_tag_grp         VARCHAR2(4),
        module_id_grp       giis_modules.module_id%TYPE,
        module_desc_grp     giis_modules.module_desc%TYPE,
        access_tag_grp      giis_user_grp_modules.access_tag%TYPE,
        access_tag_desc_grp cg_ref_codes.rv_meaning%TYPE
    );
    
    TYPE modules_grp_tab IS TABLE OF modules_grp_type;     
    
    TYPE hist_type IS RECORD(
        hist_user_id        giis_user_grp_hist.userid%TYPE,
        hist_id             giis_user_grp_hist.hist_id%TYPE,
        old_user_grp        giis_user_grp_hist.old_user_grp%TYPE,
        old_user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
        new_user_grp        giis_user_grp_hist.new_user_grp%TYPE,
        new_user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
        hist_last_update    VARCHAR2(64)
    );
    
    TYPE hist_tab IS TABLE OF hist_type;   
    FUNCTION get_user_listing(
        p_app_user       giis_users.user_id%TYPE
    )
        RETURN user_tab PIPELINED;

    FUNCTION get_tran_list(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN tran_tab PIPELINED;
        
    FUNCTION get_tran_iss(
        p_user_id       giis_users.user_id%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE
    )
        RETURN iss_tab PIPELINED;
        
    FUNCTION get_tran_line(
        p_user_id       giis_users.user_id%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE
    )
         RETURN line_tab PIPELINED;
    
    FUNCTION get_module_list(
        p_user_id       giis_users.user_id%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE
    )
        RETURN modules_tab PIPELINED;
    
    FUNCTION get_tran_grp(
        p_user_grp        giis_users.user_grp%TYPE
    )
        RETURN grp_tran_tab PIPELINED;
    
    
    FUNCTION get_iss_grp(
        p_user_grp      giis_user_grp_tran.user_grp%TYPE,      
        p_tran_cd       giis_user_grp_tran.tran_cd%TYPE
    )
        RETURN grp_iss_tab PIPELINED;
    
    FUNCTION get_line_grp(
        p_user_grp      giis_user_grp_dtl.user_grp%TYPE,
        p_tran_cd       giis_user_grp_dtl.tran_cd%TYPE,
        p_iss_cd        giis_user_grp_dtl.iss_cd%TYPE
    )
        RETURN grp_line_tab PIPELINED;

    FUNCTION get_module_list_grp(
        p_user_grp      giis_user_grp_dtl.user_grp%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE
    )
        RETURN modules_grp_tab PIPELINED; 
        
    FUNCTION get_history_list(
        p_user_id      giis_users.user_id%TYPE
    )
        RETURN hist_tab PIPELINED;   
                

END GIPIS152_PKG;
/


