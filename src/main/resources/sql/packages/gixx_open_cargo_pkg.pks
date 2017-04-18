CREATE OR REPLACE PACKAGE CPI.GIXX_OPEN_CARGO_PKG 
AS
  --  added by Kris 03.11.2013 for GIPIS101
  TYPE open_cargo_type IS RECORD(
        extract_id          gixx_open_cargo.extract_id%TYPE,
        geog_cd             gixx_open_cargo.geog_cd%TYPE,
        cargo_class_cd      gixx_open_cargo.cargo_class_cd%TYPE,
        rec_flag            gixx_open_cargo.rec_flag%TYPE,
        policy_id           gixx_open_cargo.policy_id%TYPE,
                
        cargo_class_desc    giis_cargo_class.cargo_class_desc%TYPE
  );
      
  TYPE open_cargo_tab IS TABLE OF open_cargo_type;
  
  FUNCTION get_open_cargo_list(
        p_extract_id    gixx_open_cargo.extract_id%TYPE,
        p_geog_cd       gixx_open_cargo.geog_cd%TYPE
  ) RETURN open_cargo_tab PIPELINED;
  -- end 03.11.2013: for GIPIS101

END GIXX_OPEN_CARGO_PKG;
/


