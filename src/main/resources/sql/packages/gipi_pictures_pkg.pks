CREATE OR REPLACE PACKAGE CPI.Gipi_Pictures_Pkg AS

  TYPE gipi_picture_type IS RECORD(
    policy_id       GIPI_PICTURES.policy_id%TYPE,
    item_no         GIPI_PICTURES.item_no%TYPE,
    file_name       GIPI_PICTURES.file_name%TYPE,
    file_type       GIPI_PICTURES.file_type%TYPE,
    file_ext        GIPI_PICTURES.file_ext%TYPE,
    remarks         GIPI_PICTURES.remarks%TYPE,
    pol_file_name   GIPI_PICTURES.pol_file_name%TYPE,
    arc_ext_data    GIPI_PICTURES.arc_ext_data%TYPE,
    real_file_name  VARCHAR2(1000)
  );
    
  TYPE gipi_picture_tab IS TABLE OF gipi_picture_type;
  
  FUNCTION get_gipi_picture(p_policy_id    GIPI_PICTURES.policy_id%TYPE,
                            p_item_no      GIPI_PICTURES.item_no%TYPE) 
    RETURN gipi_picture_tab PIPELINED;
  
  PROCEDURE set_gipi_picture(p_picture     GIPI_PICTURES%ROWTYPE);
  
  PROCEDURE del_gipi_picture(p_policy_id   GIPI_PICTURES.policy_id%TYPE,
                             p_item_no     GIPI_PICTURES.item_no%TYPE,
                             p_file_name   GIPI_PICTURES.file_name%TYPE);
                              
  PROCEDURE del_gipi_pictures(p_policy_id  GIPI_PICTURES.policy_id%TYPE,
                              p_item_no    GIPI_PICTURES.item_no%TYPE);                            

END Gipi_Pictures_Pkg;
/


