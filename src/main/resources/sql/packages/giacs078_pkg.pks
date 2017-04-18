CREATE OR REPLACE PACKAGE CPI.GIACS078_PKG
AS
    
    PROCEDURE get_initial_values(
        p_user          IN  giac_coll_analysis_ext.USER_ID%type,
        p_from_date     OUT VARCHAR2,
        p_to_date       OUT VARCHAR2,
        p_branch_cd     OUT VARCHAR2,
        p_branch_name   OUT VARCHAR2,
        p_intm_no       OUT NUMBER,
        p_intm_name     OUT VARCHAR2
    );
        
    
    PROCEDURE extract_records(
        p_from_date     IN  giac_order_of_payts.OR_DATE%type,
        p_to_date       IN  giac_order_of_payts.OR_DATE%type,
        p_branch_cd     IN  giac_order_of_payts.GIBR_BRANCH_CD%type,
        p_intm_no       IN  VARCHAR2,
        p_date_tag      IN  VARCHAR2,
        p_user          IN  giac_coll_analysis_ext.USER_ID%type,
        p_extracted_rec OUT NUMBER
    );    

END GIACS078_PKG;
/


