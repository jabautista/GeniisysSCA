CREATE OR REPLACE PACKAGE BODY CPI.gipi_insp_pictures_pkg AS

/*
** Created by : Angelo
** Date Created : April 15, 2011
** Reference By : (GIPIS197 - Attach Media)
** Description : Procedure for attached files for inspection report item
*/

  FUNCTION get_gipi_insp_pictures(
    p_insp_no		GIPI_INSP_PICTURES.insp_no%TYPE,
	p_item_no		GIPI_INSP_PICTURES.item_no%TYPE
  ) RETURN gipi_insp_pictures_tab PIPELINED

  IS
    v_insp_pic			gipi_insp_pictures_type;
  BEGIN
  	   FOR i IN (SELECT insp_no, item_no, file_name,
	   	   	 			file_type, file_ext, remarks,sketch_tag,last_update,user_id
				   FROM gipi_insp_pictures
	   			  WHERE insp_no = p_insp_no
				    AND item_no = p_item_no
			   ORDER BY file_name)
	   LOOP
	   	   v_insp_pic.insp_no	  := i.insp_no;
		   v_insp_pic.item_no	  := i.item_no;
		   v_insp_pic.file_name	  := i.file_name;
		   v_insp_pic.file_type	  := i.file_type;
		   v_insp_pic.file_ext	  := i.file_ext;
		   v_insp_pic.remarks	  := i.remarks;
		   v_insp_pic.sketch_tag  := i.sketch_tag;
		   v_insp_pic.last_update := i.last_update;
		   v_insp_pic.user_id  	  := i.user_id;
		   PIPE ROW(v_insp_pic);
	   END LOOP;
	   RETURN;
  END get_gipi_insp_pictures;

  FUNCTION get_gipi_insp_pictures2(
    p_insp_no       GIPI_INSP_PICTURES.insp_no%TYPE,
    p_item_no       GIPI_INSP_PICTURES.item_no%TYPE
  ) RETURN gipi_insp_pictures_tab PIPELINED
  IS
    v_row   gipi_insp_pictures_type;
  BEGIN
    FOR i IN (SELECT insp_no, item_no, file_name,
	   	   	 			file_type, file_ext, remarks,sketch_tag,last_update,user_id
				   FROM gipi_insp_pictures
	   			  WHERE insp_no = p_insp_no
				    AND item_no = p_item_no)
	LOOP
       v_row.insp_no	  := i.insp_no;
       v_row.item_no	  := i.item_no;
       v_row.file_name	  := i.file_name;
       v_row.file_type	  := i.file_type;
       v_row.file_ext	  := i.file_ext;
       v_row.remarks	  := i.remarks;
       v_row.sketch_tag   := i.sketch_tag;
       v_row.last_update  := i.last_update;
       v_row.user_id  	  := i.user_id;
       v_row.real_file_name := REGEXP_REPLACE(i.file_name, '.*/','');
       PIPE ROW(v_row);
	END LOOP;
    RETURN;
  END get_gipi_insp_pictures2;

  PROCEDURE set_gipi_insp_pictures(
    p_insp_pic		GIPI_INSP_PICTURES%ROWTYPE
  )

  IS

  BEGIN
  	   MERGE INTO gipi_insp_pictures
	   USING DUAL ON (insp_no 	= p_insp_pic.insp_no
	   		 	  AND item_no	= p_insp_pic.item_no
				  AND file_name = p_insp_pic.file_name)
		 WHEN NOT MATCHED THEN
		   INSERT (insp_no, item_no, file_name, file_type,
		   		   file_ext, remarks, user_id, last_update,sketch_tag)  -- added by steven: sketch_tag
		   VALUES (p_insp_pic.insp_no, p_insp_pic.item_no, p_insp_pic.file_name,
		   		   p_insp_pic.file_type, p_insp_pic.file_ext, p_insp_pic.remarks,
				   p_insp_pic.user_id, SYSDATE,p_insp_pic.sketch_tag)
		 WHEN MATCHED THEN
		   UPDATE SET file_type = p_insp_pic.file_type,
		   		      file_ext = p_insp_pic.file_ext,
					  sketch_tag = p_insp_pic.sketch_tag,
					  remarks = p_insp_pic.remarks;
  END set_gipi_insp_pictures;

  PROCEDURE del_gipi_insp_pictures(
    p_insp_no		GIPI_INSP_PICTURES.insp_no%TYPE,
	p_item_no		GIPI_INSP_PICTURES.item_no%TYPE
  )

  IS

  BEGIN
  	   DELETE FROM gipi_insp_pictures
	    WHERE insp_no = p_insp_no
		  AND item_no = p_item_no;
  END del_gipi_insp_pictures;

  PROCEDURE del_gipi_insp_pictures2(
    p_insp_no		GIPI_INSP_PICTURES.insp_no%TYPE,
	p_item_no		GIPI_INSP_PICTURES.item_no%TYPE,
	p_file_name		GIPI_INSP_PICTURES.file_name%TYPE
  )

  IS

  BEGIN
  	   DELETE FROM gipi_insp_pictures
	    WHERE insp_no = p_insp_no
		  AND item_no = p_item_no
		  AND file_name= p_file_name;
  END del_gipi_insp_pictures2;

  FUNCTION get_attachments(
    p_insp_no   GIPI_INSP_PICTURES.insp_no%TYPE,
    p_item_no   GIPI_INSP_PICTURES.item_no%TYPE
  ) 
    RETURN attachment_tab PIPELINED
  AS
    v_rec attachment_type;
  BEGIN
    FOR i IN (SELECT insp_no, item_no, file_name
                FROM gipi_insp_pictures
               WHERE insp_no = p_insp_no
                 AND item_no = p_item_no)
    LOOP
        v_rec.insp_no   := i.insp_no;
        v_rec.item_no   := i.item_no;
        v_rec.file_name := i.file_name;
        
        PIPE ROW(v_rec);
    END LOOP;
  END;

END gipi_insp_pictures_pkg;
/


