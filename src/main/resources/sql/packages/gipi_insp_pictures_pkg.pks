CREATE OR REPLACE PACKAGE CPI.gipi_insp_pictures_pkg AS

  TYPE gipi_insp_pictures_type IS RECORD(
    insp_no			GIPI_INSP_PICTURES.insp_no%TYPE,
	item_no			GIPI_INSP_PICTURES.item_no%TYPE,
	file_name		GIPI_INSP_PICTURES.file_name%TYPE,
	file_type		GIPI_INSP_PICTURES.file_type%TYPE,
	file_ext		GIPI_INSP_PICTURES.file_ext%TYPE,
	remarks			GIPI_INSP_PICTURES.remarks%TYPE,
	sketch_tag		GIPI_INSP_PICTURES.sketch_tag%TYPE,
	last_update 	GIPI_INSP_PICTURES.last_update%TYPE,
	user_id  	  	GIPI_INSP_PICTURES.user_id%TYPE,
    real_file_name  VARCHAR2(1000)
  );
  
  TYPE gipi_insp_pictures_tab IS TABLE OF gipi_insp_pictures_type;
  
  FUNCTION get_gipi_insp_pictures(
    p_insp_no		GIPI_INSP_PICTURES.insp_no%TYPE,
	p_item_no		GIPI_INSP_PICTURES.item_no%TYPE
  ) RETURN gipi_insp_pictures_tab PIPELINED;
  
  FUNCTION get_gipi_insp_pictures2(
    p_insp_no       GIPI_INSP_PICTURES.insp_no%TYPE,
    p_item_no       GIPI_INSP_PICTURES.item_no%TYPE
  ) RETURN gipi_insp_pictures_tab PIPELINED;
  
  PROCEDURE set_gipi_insp_pictures(
    p_insp_pic		GIPI_INSP_PICTURES%ROWTYPE
  );
  
  PROCEDURE del_gipi_insp_pictures(
    p_insp_no		GIPI_INSP_PICTURES.insp_no%TYPE,
	p_item_no		GIPI_INSP_PICTURES.item_no%TYPE
  );
  
   PROCEDURE del_gipi_insp_pictures2(
    p_insp_no		GIPI_INSP_PICTURES.insp_no%TYPE,
	p_item_no		GIPI_INSP_PICTURES.item_no%TYPE,
	p_file_name		GIPI_INSP_PICTURES.file_name%TYPE
  );
  
  TYPE attachment_type IS RECORD(
    insp_no     GIPI_INSP_PICTURES.insp_no%TYPE,
    item_no     GIPI_INSP_PICTURES.item_no%TYPE,
    file_name   GIPI_INSP_PICTURES.file_name%TYPE
  );
  
  TYPE attachment_tab IS TABLE OF attachment_type;
  
  FUNCTION get_attachments(
    p_insp_no   GIPI_INSP_PICTURES.insp_no%TYPE,
    p_item_no   GIPI_INSP_PICTURES.item_no%TYPE
  ) RETURN attachment_tab PIPELINED;
  
END gipi_insp_pictures_pkg;
/


