CREATE OR REPLACE PACKAGE CPI.GICLS219_PKG AS

    TYPE subline_type IS RECORD(
        subline_cd      giis_subline.subline_cd%TYPE,
        subline_name    giis_subline.subline_name%TYPE
    );
    
    TYPE subline_tab IS TABLE OF subline_type;
    
    TYPE branch_type IS RECORD(
        iss_cd       giis_issource.iss_cd%TYPE,
        iss_name     giis_issource.iss_name%TYPE
    );
   
    TYPE branch_tab IS TABLE OF branch_type;
    
    FUNCTION get_outst_loa_subline_lov(
        p_branch_cd     giis_issource.iss_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN subline_tab PIPELINED;

    FUNCTION get_outst_loa_branch_lov(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED;
        
END GICLS219_PKG;
/


