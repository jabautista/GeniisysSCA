CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Pictures_Pkg AS
  
  TYPE gipi_quote_pic_tab IS TABLE OF GIPI_QUOTE_PICTURES%ROWTYPE;
  
  FUNCTION get_gipi_quote_pic (p_quote_id           GIPI_QUOTE.quote_id%TYPE,
                               p_item_no            GIPI_QUOTE_PICTURES.item_no%TYPE)
    RETURN gipi_quote_pic_tab PIPELINED; 
	
  PROCEDURE Set_Gipi_Quote_Pic (p_gipi_quote_pic   IN       GIPI_QUOTE_PICTURES%ROWTYPE);
  	
  PROCEDURE del_gipi_quote_pic (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                                p_item_no     GIPI_QUOTE_PICTURES.item_no%TYPE,
								p_file_name   GIPI_QUOTE_PICTURES.file_name%TYPE);
                                
  FUNCTION get_gipi_quote_pictures (p_quote_id           GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_pic_tab PIPELINED;
    
  FUNCTION get_gipi_quote_pic_for_pack (p_pack_quote_id           GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_pic_tab PIPELINED;	
	
	TYPE quote_pic_type IS RECORD (
        quote_id     GIPI_QUOTE_PICTURES.quote_id%TYPE,
        item_no      GIPI_QUOTE_PICTURES.item_no%TYPE,
        file_name    GIPI_QUOTE_PICTURES.file_name%TYPE,
        file_path    VARCHAR2(32767),
        file_type    GIPI_QUOTE_PICTURES.file_type%TYPE,
        file_ext     GIPI_QUOTE_PICTURES.file_ext%TYPE,
        remarks      GIPI_QUOTE_PICTURES.remarks%TYPE,
        real_file_name VARCHAR2(1000)
    );
    
  TYPE quote_pic_tab IS TABLE OF quote_pic_type;
	
	FUNCTION get_gipi_quote_pictures2 (p_quote_id           GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_pic_tab PIPELINED;
    
  FUNCTION get_gipi_quote_picture3 (
    p_quote_id      gipi_quote_pictures.quote_id%TYPE,
    p_item_no       gipi_quote_pictures.item_no%TYPE
  )
    RETURN quote_pic_tab PIPELINED;
	
    FUNCTION get_gipi_quote_picture_list (
        p_quote_id          gipi_quote_pictures.quote_id%TYPE,
        p_item_no           gipi_quote_pictures.item_no%TYPE,
        p_filename          gipi_quote_pictures.file_name%TYPE,
        p_remarks           gipi_quote_pictures.remarks%TYPE
    )
      RETURN quote_pic_tab PIPELINED;
  
  TYPE attachment_type IS RECORD (
    quote_id    gipi_quote_pictures.quote_id%TYPE,
    item_no     gipi_quote_pictures.item_no%TYPE,
    file_name   gipi_quote_pictures.file_name%TYPE   
  );
  
  TYPE attachment_tab IS TABLE OF attachment_type;
  
  FUNCTION get_attachment_list (
    p_quote_id  gipi_quote_pictures.quote_id%TYPE,
    p_item_no   gipi_quote_pictures.item_no%TYPE
  )
    RETURN attachment_tab PIPELINED;
  
  PROCEDURE delete_item_attachments(
    p_quote_id      gipi_quote_pictures.quote_id%TYPE,
    p_item_no       gipi_quote_pictures.item_no%TYPE
  );
  
  TYPE attachment2_type IS RECORD (
    quote_id    gipi_quote_pictures.quote_id%TYPE,
    item_no     gipi_quote_pictures.item_no%TYPE,
    file_name   gipi_quote_pictures.file_name%TYPE
  );
  
  TYPE attachment2_tab IS TABLE OF attachment2_type;
  
  FUNCTION get_attachment_by_quote (
    p_quote_id  gipi_quote_pictures.quote_id%TYPE
  )
    RETURN attachment2_tab PIPELINED;
  
  PROCEDURE update_file_name2 (
    p_quote_id      gipi_quote_pictures.quote_id%TYPE,
    p_item_no       gipi_quote_pictures.item_no%TYPE,
    p_old_file_name gipi_quote_pictures.file_name%TYPE,
    p_new_file_name gipi_quote_pictures.file_name%TYPE
  );
  
END Gipi_Quote_Pictures_Pkg;
/


