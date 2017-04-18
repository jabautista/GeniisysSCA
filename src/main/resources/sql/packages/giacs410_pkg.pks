CREATE OR REPLACE PACKAGE CPI.GIACS410_PKG
AS

    FUNCTION get_gl_no
        RETURN NUMBER;
        
    
    FUNCTION get_finance_end
        RETURN NUMBER;
    
    
    FUNCTION get_fiscal_end
        RETURN NUMBER;
        
        
    TYPE tran_month_lov_type IS RECORD(
        tran_mm         giac_monthly_totals.TRAN_MM%type,
        tran_year       giac_monthly_totals.TRAN_YEAR%type,
        post_tag        giac_monthly_totals.POST_TAG%type,
        description     VARCHAR2(45)
    );
    
    TYPE tran_month_lov_tab IS TABLE OF tran_month_lov_type;
    
    
    FUNCTION get_tran_month_lov(
        p_tran_year     GIAC_MONTHLY_TOTALS.TRAN_YEAR%TYPE,
        p_user_id       VARCHAR2
    ) RETURN tran_month_lov_tab PIPELINED;
    
    
    PROCEDURE is_prev_month_closed(
        p_tran_year IN NUMBER,
        p_tran_mm   IN NUMBER,
        p_post_tag  IN VARCHAR2
    );
    
    
    PROCEDURE post_to_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_post_tag      IN VARCHAR,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER,
        p_msg          OUT VARCHAR    
    );
    
    PROCEDURE post_to_fiscal_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER
    );
    
    
    PROCEDURE post_to_finance_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER
    );
    
    
    PROCEDURE post_to_both_gl(
        p_tran_year     IN NUMBER,
        p_tran_mm       IN NUMBER,
        p_gl_no         IN NUMBER,
        p_fiscal_end    IN NUMBER,
        p_finance_end   IN NUMBER
    );
    

END GIACS410_PKG;
/


