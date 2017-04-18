CREATE OR REPLACE PACKAGE CPI.Gipi_Wopen_Cargo_Pkg AS

  TYPE gipi_wopen_cargo_type IS RECORD (
    par_id           GIPI_WOPEN_CARGO.par_id%TYPE,
    geog_cd          GIPI_WOPEN_CARGO.geog_cd%TYPE,
    cargo_class_cd   GIPI_WOPEN_CARGO.cargo_class_cd%TYPE,
    cargo_class_desc GIIS_CARGO_CLASS.cargo_class_desc%TYPE,
    rec_flag         GIPI_WOPEN_CARGO.rec_flag%TYPE);
    
  TYPE gipi_wopen_cargo_tab IS TABLE OF gipi_wopen_cargo_type;
  
  FUNCTION get_gipi_wopen_cargo (p_par_id  IN GIPI_WOPEN_CARGO.par_id%TYPE,
                                 p_geog_cd IN GIPI_WOPEN_CARGO.geog_cd%TYPE)
    RETURN gipi_wopen_cargo_tab PIPELINED;                                      

  
  Procedure set_gipi_wopen_cargo (p_wopen_cargo IN GIPI_WOPEN_CARGO%ROWTYPE);
    
    
  Procedure del_gipi_wopen_cargo (p_par_id         IN GIPI_WOPEN_CARGO.par_id%TYPE,
                                  p_geog_cd        IN GIPI_WOPEN_CARGO.geog_cd%TYPE,
                                  p_cargo_class_cd IN GIPI_WOPEN_CARGO.cargo_class_cd%TYPE);

  Procedure del_all_gipi_wopen_cargo (p_par_id  IN GIPI_WOPEN_CARGO.par_id%TYPE,
                                      p_geog_cd IN GIPI_WOPEN_CARGO.geog_cd%TYPE);
    
	Procedure del_gipi_wopen_cargo (p_par_id IN GIPI_WOPEN_CARGO.par_id%TYPE);
    
    PROCEDURE set_gipi_wopen_cargo_endt(
        p_par_id                GIPI_WOPEN_CARGO.par_id%TYPE,
        p_geog_cd               GIPI_WOPEN_CARGO.geog_cd%TYPE,
        p_cargo_class_cd        GIPI_WOPEN_CARGO.cargo_class_cd%TYPE,
        p_rec_flag              GIPI_WOPEN_CARGO.rec_flag%TYPE
    );
END Gipi_Wopen_Cargo_Pkg;
/


