CREATE OR REPLACE PACKAGE CPI.GIACS503_PKG 
AS

    PROCEDURE new_form_instance(
        p_year                  IN OUT NUMBER,
        p_month                 IN OUT NUMBER,
        p_first_posting_date    IN OUT NUMBER
    );
    
    PROCEDURE post_sl(
        p_year                  IN  NUMBER,
        p_month                 IN  NUMBER,
        p_first_posting_date    IN  NUMBER,
        p_message               OUT VARCHAR2
    );
    
    FUNCTION validate_bef_print(
        p_year                  IN  NUMBER,
        p_month                 IN  NUMBER
    ) RETURN NUMBER;

END GIACS503_PKG;
/


