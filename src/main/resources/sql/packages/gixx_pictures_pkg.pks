CREATE OR REPLACE PACKAGE CPI.Gixx_Pictures_Pkg AS

  TYPE gixx_picture_type IS RECORD(
    extract_id      GIXX_PICTURES.extract_id%TYPE,
    item_no         GIXX_PICTURES.item_no%TYPE,
    file_name       GIXX_PICTURES.file_name%TYPE,
    file_type       GIXX_PICTURES.file_type%TYPE,
    file_ext        GIXX_PICTURES.file_ext%TYPE,
    remarks         GIXX_PICTURES.remarks%TYPE,
    pol_file_name   GIXX_PICTURES.pol_file_name%TYPE);
    
  TYPE gixx_picture_tab IS TABLE OF gixx_picture_type;
  
  FUNCTION get_gixx_picture(p_extract_id   GIXX_PICTURES.extract_id%TYPE,
                            p_item_no      GIXX_PICTURES.item_no%TYPE) 
    RETURN gixx_picture_tab PIPELINED;
  
  PROCEDURE set_gixx_picture(p_picture     GIXX_PICTURES%ROWTYPE);
  
  PROCEDURE del_gixx_picture(p_extract_id  GIXX_PICTURES.extract_id%TYPE,
                             p_item_no     GIXX_PICTURES.item_no%TYPE,
                             p_file_name   GIXX_PICTURES.file_name%TYPE);
                              
  PROCEDURE del_gixx_pictures(p_extract_id GIXX_PICTURES.extract_id%TYPE,
                              p_item_no    GIXX_PICTURES.item_no%TYPE);                            

END Gixx_Pictures_Pkg;
/


