CREATE OR REPLACE PACKAGE CPI.Gipi_WPictures_Pkg AS

  TYPE gipi_wpicture_type IS RECORD(
    par_id      GIPI_WPICTURES.par_id%TYPE,
    item_no     GIPI_WPICTURES.item_no%TYPE,
    file_name   GIPI_WPICTURES.file_name%TYPE,
    file_type   GIPI_WPICTURES.file_type%TYPE,
    file_ext    GIPI_WPICTURES.file_ext%TYPE,
    remarks     GIPI_WPICTURES.remarks%TYPE,
    real_file_name  VARCHAR2(1000)
  );
    
  TYPE gipi_wpicture_tab IS TABLE OF gipi_wpicture_type;
  
  FUNCTION get_gipi_wpicture(p_par_id      GIPI_WPICTURES.par_id%TYPE,
                             p_item_no     GIPI_WPICTURES.item_no%TYPE) 
    RETURN gipi_wpicture_tab PIPELINED;
  
  PROCEDURE set_gipi_wpicture(p_wpicture   GIPI_WPICTURES%ROWTYPE);
  
  PROCEDURE del_gipi_wpicture(p_par_id     GIPI_WPICTURES.par_id%TYPE,
                              p_item_no    GIPI_WPICTURES.item_no%TYPE,
                              p_file_name  GIPI_WPICTURES.file_name%TYPE);
                              
  PROCEDURE del_gipi_wpictures(p_par_id     GIPI_WPICTURES.par_id%TYPE,
                              p_item_no    GIPI_WPICTURES.item_no%TYPE);                            

  TYPE gipi_wpicture2_type IS RECORD (
    par_id      gipi_wpictures.par_id%TYPE,
    item_no     gipi_wpictures.item_no%TYPE,
    file_name   gipi_wpictures.file_name%TYPE
  );
  
  TYPE gipi_wpicture2_tab IS TABLE OF gipi_wpicture2_type;
  
  FUNCTION get_attachment_by_par(
    p_par_id    gipi_wpictures.par_id%TYPE
  )
    RETURN gipi_wpicture2_tab PIPELINED;
    
  PROCEDURE update_file_name3(
    p_par_id        gipi_wpictures.par_id%TYPE,
    p_item_no       gipi_wpictures.item_no%TYPE,
    p_old_file_name gipi_wpictures.file_name%TYPE,
    p_new_file_name gipi_wpictures.file_name%TYPE
  );

  PROCEDURE save_attachment(
    p_par_id        gipi_wpictures.par_id%TYPE,
    p_item_no       gipi_wpictures.item_no%TYPE,
    p_file_name     gipi_wpictures.file_name%TYPE,
    p_file_type     gipi_wpictures.file_type%TYPE,
    p_file_ext      gipi_wpictures.file_ext%TYPE,
    p_remarks       gipi_wpictures.remarks%TYPE,
    p_user_id       gipi_wpictures.user_id%TYPE
  );
  
  TYPE attachment_type IS RECORD(
    file_name   gipi_wpictures.file_name%TYPE
  );
  
  TYPE attachment_tab IS TABLE OF attachment_type;
  
  FUNCTION get_item_attachments(
    p_par_id    gipi_wpictures.par_id%TYPE,
    p_item_no   gipi_wpictures.item_no%TYPE
  ) RETURN attachment_tab PIPELINED;

  PROCEDURE del_par_gipi_wpictures(p_par_id gipi_wpictures.par_id%TYPE);                       

END Gipi_WPictures_Pkg;
/


