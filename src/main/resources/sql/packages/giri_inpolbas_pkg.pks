CREATE OR REPLACE PACKAGE CPI.giri_inpolbas_pkg
AS
    PROCEDURE get_cedant(
        p_line_cd           IN      GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd        IN      GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd        IN      GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy          IN      GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN      GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN      GIPI_POLBASIC.renew_no%TYPE,
        p_ri_cd             OUT     giri_inpolbas.ri_cd%TYPE,
        p_dsp_ri_name       OUT     giis_reinsurer.ri_name%TYPE
        );
        
    TYPE cedant_type IS RECORD(
        ri_cd                       GIRI_INPOLBAS.ri_cd%TYPE,
        ri_name                     GIIS_REINSURER.ri_name%TYPE
    );
    TYPE cedant_tab IS TABLE OF cedant_type;
    
    FUNCTION get_cedant_listing
      RETURN cedant_tab PIPELINED;
      
    PROCEDURE validate_cedant(
        p_ri_cd             IN      GIRI_INPOLBAS.ri_cd%TYPE,
        p_ri_name           OUT     GIIS_REINSURER.ri_name%TYPE
    );
    
END giri_inpolbas_pkg;
/


