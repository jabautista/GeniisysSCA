CREATE OR REPLACE PACKAGE CPI.GIACS171_PKG AS

    TYPE ri_type IS RECORD(
        ri_cd       giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        ri_name     giis_reinsurer.ri_name%TYPE
    );
    
    TYPE ri_tab IS TABLE OF ri_type;
    
    TYPE line_type IS RECORD(
        line_cd     giis_line.line_cd%TYPE,
        line_name   giis_line.line_name%TYPE
    );

    TYPE line_tab IS TABLE OF line_type;  
    
    TYPE date_type IS RECORD(
        from_date   VARCHAR2(10),
        to_date     VARCHAR2(10),
        ri_cd       giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        ri_name     giis_reinsurer.ri_name%TYPE,
        line_cd     giis_line.line_cd%TYPE,
        line_name   giis_line.line_name%TYPE
    );

    TYPE date_tab IS TABLE OF date_type;         

    FUNCTION get_ri_lov
        RETURN ri_tab PIPELINED;

    FUNCTION get_line_lov
        RETURN line_tab PIPELINED; 
        
    FUNCTION get_dates(
        p_user_id       giac_assumed_ri_ext.user_id%TYPE
    )
        RETURN date_tab PIPELINED;    
        
    PROCEDURE extract_to_table(
        p_from_date     IN  VARCHAR2,
        p_to_date       IN  VARCHAR2,
        p_line_cd       IN  gipi_polbasic.line_cd%TYPE,
        p_ri_cd         IN  giri_inpolbas.ri_cd%TYPE,
        p_user_id       IN  giac_assumed_ri_ext.user_id%TYPE,
        p_msg           OUT   VARCHAR2  
    );

END GIACS171_PKG;
/
