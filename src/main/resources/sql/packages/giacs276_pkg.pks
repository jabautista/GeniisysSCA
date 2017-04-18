CREATE OR REPLACE PACKAGE CPI.GIACS276_PKG
AS

        PROCEDURE check_last_extract(
            p_comm          NUMBER,
            p_from_date     DATE, 
            p_to_date       DATE,
            p_line_cd       VARCHAR2,
            p_alert_out OUT VARCHAR2  
        );
        
        PROCEDURE ext_comm_income(
            p_from_date     DATE, 
            p_to_date       DATE,
            p_line_cd       VARCHAR2,
            p_user          IN  giac_redist_binders_ext.USER_ID%type,
            --p_message   OUT VARCHAR2,
            p_rec_extracted OUT NUMBER,
            p_iss               NUMBER
        );
        
        PROCEDURE ext_comm_expense(
            p_from_date     DATE, 
            p_to_date       DATE,
            p_line_cd       VARCHAR2,
            p_user          IN  giac_redist_binders_ext.USER_ID%type,
            --p_message   OUT VARCHAR2,
            p_rec_extracted OUT NUMBER,
            p_iss               NUMBER
        );
        
        PROCEDURE ext_rec_giacs276(
            p_comm          IN NUMBER,
            p_iss           IN NUMBER,
            p_from_date     IN VARCHAR2, 
            p_to_date       IN VARCHAR2,
            p_line_cd       IN VARCHAR2,
            p_user          IN VARCHAR2,
            p_rec_extracted OUT NUMBER
        );
        
   TYPE giacs276_line_type IS RECORD (
      line_cd         giis_line.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE
   );

   TYPE giacs276_line_tab IS TABLE OF giacs276_line_type;
        
    FUNCTION get_giacs276_line_lov(
        p_module_id         GIIS_MODULES.module_id%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE,
        p_find_text         VARCHAR2
    )
      RETURN giacs276_line_tab PIPELINED;
    /*---start Gzelle 09222015 SR18729---*/ 
    PROCEDURE get_initial_values( 
        p_comm          IN OUT      VARCHAR2, 
        p_user_id       IN      giis_users.user_id%TYPE, 
        p_from_date     OUT     VARCHAR2, 
        p_to_date       OUT     VARCHAR2, 
        p_line_cd       OUT     giis_line.line_cd%TYPE, 
        p_line_name     OUT     giis_line.line_name%TYPE 
    ); 
    

    PROCEDURE val_extract_print( 
        p_trigger       IN     VARCHAR2, 
        p_comm          IN     VARCHAR2, 
        p_user_id       IN OUT giis_users.user_id%TYPE, 
        p_from_date     IN     VARCHAR2, 
        p_to_date       IN     VARCHAR2, 
        p_line_cd       IN     giis_line.line_cd%TYPE, 
        p_out           OUT    VARCHAR2 
    );    
    /*---end Gzelle 09222015 SR18729---*/     
END GIACS276_PKG;
/


