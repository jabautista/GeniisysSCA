CREATE OR REPLACE PACKAGE CPI.GIUTS032_PKG
AS
    TYPE giuts032_pol_lov_type IS RECORD (
        policy_id        NUMBER(12),
        line_cd          VARCHAR2(2),
        subline_cd       VARCHAR2(7),
        iss_cd           VARCHAR2(2),
        issue_yy         NUMBER(2),
        pol_seq_no       NUMBER(7),
        renew_no         NUMBER(2),
        endt_iss_cd      VARCHAR2(2),
        endt_yy          NUMBER(2),
        endt_seq_no      NUMBER(6),
        assd_no          NUMBER(12),
        assd_name        VARCHAR2(500),
        incept_date      DATE,
        expiry_date      DATE,
        eff_date         DATE,
        endt_expiry_date DATE    
    );
    TYPE giuts032_pol_lov_tab IS TABLE OF giuts032_pol_lov_type;
    
    FUNCTION get_giuts032_pol_lov(
            p_line_cd       VARCHAR2,
            p_subline_cd    VARCHAR2,
            p_iss_cd        VARCHAR2,
            p_issue_yy      VARCHAR2,
            p_pol_seq_no    VARCHAR2,
            p_renew_no      VARCHAR2,
            p_user_id       giis_users.user_id%TYPE
    )
            RETURN giuts032_pol_lov_tab PIPELINED;
            
    TYPE giuts032_table_type IS RECORD (
        policy_id        NUMBER(12),
        item_no          NUMBER(9),
        item_title       VARCHAR2(50),
        mv_file_no       VARCHAR2(15)   
    );
    TYPE giuts032_table_tab IS TABLE OF giuts032_table_type;
    
    FUNCTION get_giuts032_table(
        p_policy_id     VARCHAR2
    )
            RETURN giuts032_table_tab PIPELINED;
    
    PROCEDURE save_update_mv_file_number (p_mv_file_number VARCHAR2, p_policy_id VARCHAR2, p_item_no VARCHAR2);

END;
/


