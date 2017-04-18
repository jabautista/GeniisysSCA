CREATE OR REPLACE PACKAGE CPI.GIIS060_PKG
AS
    
    TYPE giis_xol_type IS RECORD(
        xol_id          giis_xol.xol_id%TYPE,
        line_cd         giis_xol.line_cd%TYPE,
        xol_yy          giis_xol.xol_yy%TYPE,
        xol_seq_no      giis_xol.xol_seq_no%TYPE,
        xol_trty_name   giis_xol.xol_trty_name%TYPE,
        user_id         giis_xol.user_id%TYPE,
        last_update     VARCHAR2 (30),
        remarks         giis_xol.remarks%TYPE
    );
    
    TYPE giis_xol_type_tab IS TABLE OF giis_xol_type;
    
    FUNCTION get_xol_list (p_line_cd  giis_line.line_cd%TYPE)
    RETURN giis_xol_type_tab PIPELINED;
    
    PROCEDURE chk_xol_exists (p_line_cd     IN giis_line.line_cd%TYPE,
                              p_xol_id      IN giis_xol.xol_id%TYPE,
                              p_xol_seq_no  IN giis_xol.xol_seq_no%TYPE,
                              p_exists      OUT VARCHAR2);
                          
    PROCEDURE set_giis060_xol (   
        p_line_cd       IN      giis_xol.line_cd%TYPE,
        p_xol_id        IN      giis_xol.xol_id%TYPE,
        p_xol_seq_no    IN OUT  giis_xol.xol_seq_no%TYPE,
        p_xol_trty_name IN      giis_xol.xol_trty_name%TYPE,
        p_xol_yy        IN      giis_xol.xol_yy%TYPE,
        p_user_id       IN      giis_xol.user_id%TYPE,
        p_remarks       IN       giis_xol.remarks%TYPE
    );    
    
    FUNCTION validate_add_xol (p_line_cd        IN giis_line.line_cd%TYPE, 
                               p_xol_seq_no     IN giis_xol.xol_seq_no%TYPE,
                               p_xol_trty_name  IN giis_xol.xol_trty_name%TYPE)
    RETURN VARCHAR2; 
    
    FUNCTION validate_update_xol (p_line_cd         IN giis_line.line_cd%TYPE, 
                                  p_xol_seq_no      IN giis_xol.xol_seq_no%TYPE, 
                                  p_xol_trty_name   IN giis_xol.xol_trty_name%TYPE)
    RETURN VARCHAR2;    
    
    FUNCTION validate_delete_xol (p_xol_id IN giis_xol.xol_id%TYPE)     
    RETURN VARCHAR2;
    
    PROCEDURE delete_xol (p_xol_id IN giis_xol.xol_id%TYPE);             

END; 
/

