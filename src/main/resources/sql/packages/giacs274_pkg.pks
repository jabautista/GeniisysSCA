CREATE OR REPLACE PACKAGE CPI.GIACS274_PKG
AS

    TYPE branch_lov_type IS RECORD(
        branch_cd       GIAC_BRANCHES.branch_cd%TYPE,
        branch_name     GIAC_BRANCHES.branch_name%TYPE
    );
    
    TYPE branch_lov_tab IS TABLE OF branch_lov_type;
    
    FUNCTION get_branch_lov(
        p_keyword   VARCHAR2,
        p_user_id   VARCHAR2
    ) RETURN branch_lov_tab PIPELINED;

    
    PROCEDURE populate_old_dist_no;

    
    PROCEDURE extract_binders(
        p_line_cd       IN  giac_redist_binders_ext.LINE_CD%type,
        p_iss_cd        IN  giac_redist_binders_ext.ISS_CD%type,
        p_from_date     IN  gipi_polbasic.ISSUE_DATE%type,
        p_to_date       IN  gipi_polbasic.ISSUE_DATE%type,
        p_as_of_date    IN  giac_redist_binders_ext.AS_OF_DATE%type,
        p_date_param    IN  VARCHAR2,
        p_issue_date    IN  VARCHAR2,
        p_eff_date      IN  VARCHAR2,
        p_user          IN giac_redist_binders_ext.USER_ID%type
    );
    
    
    PROCEDURE get_remaining_dist_no(
        p_line_cd       IN  giac_redist_binders_ext.LINE_CD%type,
        p_iss_cd        IN  giac_redist_binders_ext.ISS_CD%type,
        p_from_date     IN  gipi_polbasic.ISSUE_DATE%type,
        p_to_date       IN  gipi_polbasic.ISSUE_DATE%type,
        p_as_of_date    IN  giac_redist_binders_ext.AS_OF_DATE%type,
        p_date_param    IN  VARCHAR2,
        p_issue_date    IN  VARCHAR2,
        p_eff_date      IN  VARCHAR2,
        p_user          IN  giac_redist_binders_ext.USER_ID%type
    );
    
    PROCEDURE extract_records(
        p_line_cd       IN  giac_redist_binders_ext.LINE_CD%type,
        p_iss_cd        IN  giac_redist_binders_ext.ISS_CD%type,
        p_from_date     IN  gipi_polbasic.ISSUE_DATE%type,
        p_to_date       IN  gipi_polbasic.ISSUE_DATE%type,
        p_as_of_date    IN  giac_redist_binders_ext.AS_OF_DATE%type,
        p_date_param    IN  VARCHAR2,
        p_issue_date    IN  VARCHAR2,
        p_eff_date      IN  VARCHAR2,
        p_user          IN  giac_redist_binders_ext.USER_ID%type,
        p_msg           OUT VARCHAR,
        p_rec_extracted OUT NUMBER
    );
    
    PROCEDURE check_prev_ext_params(
        p_user_id       IN  giac_redist_binders_ext.USER_ID%type,
        p_param_line_cd OUT giac_redist_binders_ext.PARAM_LINE_CD%type,
        p_line_name     OUT GIIS_LINE.LINE_NAME%type,
        p_param_iss_cd  OUT giac_redist_binders_ext.PARAM_ISS_CD%type,
        p_iss_name      OUT GIAC_BRANCHES.BRANCH_NAME%type,
        p_from_date     OUT VARCHAR2,
        p_to_date       OUT VARCHAR2,
        p_as_of_date    OUT VARCHAR2,
        p_date_tag      OUT giac_redist_binders_ext.DATE_TAG%type
    );


END GIACS274_PKG;
/


