CREATE OR REPLACE PACKAGE CPI.Gipi_Wopen_Liab_Pkg AS

  TYPE gipi_wopen_liab_type IS RECORD
    (par_id           GIPI_WOPEN_LIAB.par_id%TYPE,
     geog_cd          GIPI_WOPEN_LIAB.geog_cd%TYPE,
     geog_desc        GIIS_GEOG_CLASS.geog_desc%TYPE,
     currency_cd      GIPI_WOPEN_LIAB.currency_cd%TYPE,
     currency_desc    GIIS_CURRENCY.currency_desc%TYPE,
     limit_liability  GIPI_WOPEN_LIAB.limit_liability%TYPE,
     currency_rt      GIPI_WOPEN_LIAB.currency_rt%TYPE,
     voy_limit        GIPI_WOPEN_LIAB.voy_limit%TYPE,
     rec_flag         GIPI_WOPEN_LIAB.rec_flag%TYPE,
     with_invoice_tag GIPI_WOPEN_LIAB.with_invoice_tag%TYPE,
     line_cd          GIPI_PARLIST.line_cd%TYPE);
  
  TYPE gipi_wopen_liab_tab IS TABLE OF gipi_wopen_liab_type;
  
  FUNCTION get_gipi_wopen_liab (p_par_id IN GIPI_WOPEN_LIAB.par_id%TYPE)
    RETURN gipi_wopen_liab_tab PIPELINED;
    
  
  Procedure set_gipi_wopen_liab (p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE);
    

  Procedure del_gipi_wopen_liab (
    p_par_id           IN GIPI_WOPEN_LIAB.par_id%TYPE,
    p_geog_cd          IN GIPI_WOPEN_LIAB.geog_cd%TYPE);  

	Procedure del_gipi_wopen_liab (p_par_id IN GIPI_WOPEN_LIAB.par_id%TYPE);
    
    PROCEDURE get_default_currency(
        p_line_cd       IN  GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd    IN  GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        IN  GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy      IN  GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    IN  GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no      IN  GIPI_WPOLBAS.renew_no%TYPE,
        p_currency_cd   OUT GIPI_WOPEN_LIAB.currency_cd%TYPE,
        p_currency_rt   OUT GIPI_WOPEN_LIAB.currency_rt%TYPE,
        p_currency_desc OUT GIIS_CURRENCY.currency_desc%TYPE
    );
	
	PROCEDURE set_gipi_wopen_liab_endt(
        p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE
    );
END Gipi_Wopen_Liab_Pkg;
/


