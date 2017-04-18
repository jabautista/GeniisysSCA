CREATE OR REPLACE PACKAGE CPI.Gipi_Wopen_Peril_Pkg AS

  TYPE gipi_wopen_peril_type IS RECORD
    (par_id         GIPI_WOPEN_PERIL.par_id%TYPE,
     peril_cd       GIPI_WOPEN_PERIL.peril_cd%TYPE,
     peril_name     GIIS_PERIL.peril_name%TYPE,
     prem_rate      GIPI_WOPEN_PERIL.prem_rate%TYPE,
     remarks        GIPI_WOPEN_PERIL.remarks%TYPE,
     geog_cd        GIPI_WOPEN_PERIL.geog_cd%TYPE,
     line_cd        GIPI_WOPEN_PERIL.line_cd%TYPE,
     peril_type     GIIS_PERIL.peril_type%TYPE,
     basc_perl_cd   GIIS_PERIL.basc_perl_cd%TYPE,
     rec_flag       GIPI_WOPEN_PERIL.rec_flag%TYPE);
     
  TYPE gipi_wopen_peril_tab IS TABLE OF gipi_wopen_peril_type;
  
  FUNCTION get_gipi_wopen_peril (p_par_id  IN GIPI_WOPEN_PERIL.par_id%TYPE,
                                 p_geog_cd IN GIPI_WOPEN_PERIL.geog_cd%TYPE,
                                 p_line_cd IN GIPI_WOPEN_PERIL.line_cd%TYPE)
    RETURN gipi_wopen_peril_tab PIPELINED;
    
  
  Procedure set_gipi_wopen_peril (p_wopen_peril IN GIPI_WOPEN_PERIL%ROWTYPE);
  
  Procedure del_gipi_wopen_peril (p_par_id   IN GIPI_WOPEN_PERIL.par_id%TYPE,
                                  p_geog_cd  IN GIPI_WOPEN_PERIL.geog_cd%TYPE,
                                  p_line_cd  IN GIPI_WOPEN_PERIL.line_cd%TYPE,
                                  p_peril_cd IN GIPI_WOPEN_PERIL.peril_cd%TYPE);

  Procedure del_all_gipi_wopen_peril (p_par_id  IN GIPI_WOPEN_PERIL.par_id%TYPE,
                                      p_geog_cd IN GIPI_WOPEN_PERIL.geog_cd%TYPE,
                                      p_line_cd IN GIPI_WOPEN_PERIL.line_cd%TYPE);

  Procedure del_all_gipi_wopen_peril (p_par_id  IN GIPI_WOPEN_PERIL.par_id%TYPE,
                                      p_geog_cd IN GIPI_WOPEN_PERIL.geog_cd%TYPE);                                      

	Procedure del_gipi_wopen_peril (p_par_id IN GIPI_WOPEN_PERIL.par_id%TYPE);
END Gipi_Wopen_Peril_Pkg;
/


