CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Pictures_Pkg AS

  FUNCTION get_gipi_quote_pic (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
  		   					   p_item_no    GIPI_QUOTE_PICTURES.item_no%TYPE)
    RETURN gipi_quote_pic_tab PIPELINED  IS

	v_gipi_quote_pic     GIPI_QUOTE_PICTURES%ROWTYPE;

  BEGIN
    FOR i IN (
      SELECT quote_id,  item_no,     file_name,    file_type,     file_ext,    remarks
        FROM GIPI_QUOTE_PICTURES
       WHERE quote_id = p_quote_id
	     AND item_no  = p_item_no)
    LOOP
	  v_gipi_quote_pic.quote_id         := i.quote_id;
	  v_gipi_quote_pic.item_no          := i.item_no;
	  v_gipi_quote_pic.file_name        := i.file_name;
	  v_gipi_quote_pic.file_type        := i.file_type;
	  v_gipi_quote_pic.file_ext         := i.file_ext;
  	  v_gipi_quote_pic.remarks          := i.remarks;
      PIPE ROW (v_gipi_quote_pic);
    END LOOP;
	RETURN;
  END get_gipi_quote_pic;

  PROCEDURE set_gipi_quote_pic (p_gipi_quote_pic   IN       GIPI_QUOTE_PICTURES%ROWTYPE)
  IS

  BEGIN

	MERGE INTO GIPI_QUOTE_PICTURES
     USING dual ON (quote_id      = p_gipi_quote_pic.quote_id
	                AND item_no   = p_gipi_quote_pic.item_no
					AND file_name = p_gipi_quote_pic.file_name)
     WHEN NOT MATCHED THEN
         INSERT ( quote_id,                     item_no,                      file_name,                      file_type,
		          file_ext,                     remarks,                      user_id,                        last_update )
		 VALUES ( p_gipi_quote_pic.quote_id,    p_gipi_quote_pic.item_no,     p_gipi_quote_pic.file_name,     p_gipi_quote_pic.file_type,
		          p_gipi_quote_pic.file_ext,    p_gipi_quote_pic.remarks,     p_gipi_quote_pic.user_id,       p_gipi_quote_pic.last_update )
     WHEN MATCHED THEN
         UPDATE SET file_type   =  p_gipi_quote_pic.file_type,
		            file_ext    =  p_gipi_quote_pic.file_ext,
					remarks     =  p_gipi_quote_pic.remarks,
					user_id     =  p_gipi_quote_pic.user_id,
					last_update =  p_gipi_quote_pic.last_update;
    COMMIT;
  END set_gipi_quote_pic;

  PROCEDURE del_gipi_quote_pic (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                                p_item_no     GIPI_QUOTE_PICTURES.item_no%TYPE,
								p_file_name   GIPI_QUOTE_PICTURES.file_name%TYPE) IS

  BEGIN

	DELETE FROM GIPI_QUOTE_PICTURES
     WHERE quote_id  = p_quote_id
	   AND item_no   = p_item_no
	   AND file_name = p_file_name;
	COMMIT;

  END del_gipi_quote_pic;
  
  FUNCTION get_gipi_quote_pictures (p_quote_id           GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_pic_tab PIPELINED  IS

	v_gipi_quote_pic     GIPI_QUOTE_PICTURES%ROWTYPE;

  BEGIN
    FOR i IN (
      SELECT quote_id,  item_no,     file_name,    file_type,     file_ext,    remarks
        FROM GIPI_QUOTE_PICTURES
       WHERE quote_id = p_quote_id)
    LOOP
	  v_gipi_quote_pic.quote_id         := i.quote_id;
	  v_gipi_quote_pic.item_no          := i.item_no;
	  v_gipi_quote_pic.file_name        := i.file_name;
	  v_gipi_quote_pic.file_type        := i.file_type;
	  v_gipi_quote_pic.file_ext         := i.file_ext;
  	  v_gipi_quote_pic.remarks          := i.remarks;
      PIPE ROW (v_gipi_quote_pic);
    END LOOP;
	RETURN;
  END get_gipi_quote_pictures;

  FUNCTION get_gipi_quote_pic_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_pic_tab PIPELINED  IS

	v_gipi_quote_pic     GIPI_QUOTE_PICTURES%ROWTYPE;

  BEGIN
    FOR i IN (
      SELECT quote_id,  item_no,     file_name,    file_type,     file_ext,    remarks
        FROM GIPI_QUOTE_PICTURES
       WHERE quote_id IN (SELECT quote_id
                          FROM GIPI_QUOTE
                          WHERE pack_quote_id = p_pack_quote_id))
    LOOP
	  v_gipi_quote_pic.quote_id         := i.quote_id;
	  v_gipi_quote_pic.item_no          := i.item_no;
	  v_gipi_quote_pic.file_name        := i.file_name;
	  v_gipi_quote_pic.file_type        := i.file_type;
	  v_gipi_quote_pic.file_ext         := i.file_ext;
  	  v_gipi_quote_pic.remarks          := i.remarks;
      PIPE ROW (v_gipi_quote_pic);
    END LOOP;
	RETURN;
  END get_gipi_quote_pic_for_pack;

  FUNCTION get_gipi_quote_pictures2 (p_quote_id           GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_pic_tab PIPELINED
  IS
	v_gipi_quote_pic     quote_pic_type;
  BEGIN
    FOR i IN (
      SELECT quote_id,  item_no,     file_name,    file_type,     file_ext,    remarks
        FROM GIPI_QUOTE_PICTURES
       WHERE quote_id = p_quote_id)
    LOOP
	  v_gipi_quote_pic.quote_id         := i.quote_id;
	  v_gipi_quote_pic.item_no          := i.item_no;
      v_gipi_quote_pic.file_name        := SUBSTR(i.file_name, INSTR( i.file_name, '/', -1) + 1, LENGTH(i.file_name));
	  v_gipi_quote_pic.file_path        := i.file_name;
	  v_gipi_quote_pic.file_type        := i.file_type;
	  v_gipi_quote_pic.file_ext         := i.file_ext;
  	  v_gipi_quote_pic.remarks          := i.remarks;
      PIPE ROW (v_gipi_quote_pic);
    END LOOP;
	RETURN;
  END get_gipi_quote_pictures2;

    FUNCTION get_gipi_quote_picture_list (
        p_quote_id          gipi_quote_pictures.quote_id%TYPE,
        p_item_no           gipi_quote_pictures.item_no%TYPE,
        p_filename          gipi_quote_pictures.file_name%TYPE,
        p_remarks           gipi_quote_pictures.remarks%TYPE
    )
      RETURN quote_pic_tab PIPELINED
    IS
        v_row               quote_pic_type;
    BEGIN
        FOR i IN(SELECT quote_id, item_no, file_name filepath, 
                        SUBSTR(file_name, INSTR( file_name, '/', -1) + 1, LENGTH(file_name)) filename, remarks
                   FROM gipi_quote_pictures
                  WHERE quote_id = p_quote_id
                    AND item_no = p_item_no
                    AND UPPER(SUBSTR(file_name, INSTR( file_name, '/', -1) + 1, LENGTH(file_name))) LIKE UPPER(NVL(p_filename, SUBSTR(file_name, INSTR( file_name, '/', -1) + 1, LENGTH(file_name)))))
        LOOP
            v_row.quote_id := i.quote_id;
            v_row.item_no := i.item_no;
            v_row.file_path := i.filepath;
            v_row.file_name := i.filename;
            v_row.remarks := i.remarks;
            PIPE ROW(v_row);
        END LOOP;
    END;

  FUNCTION get_attachment_list (
    p_quote_id  gipi_quote_pictures.quote_id%TYPE,
    p_item_no   gipi_quote_pictures.item_no%TYPE
  )
    RETURN attachment_tab PIPELINED
  IS
    v_row       attachment_type;
  BEGIN
    FOR i IN (SELECT quote_id, item_no, file_name
                FROM gipi_quote_pictures
               WHERE quote_id = p_quote_id
                 AND item_no = p_item_no)
    LOOP
        v_row.quote_id  := i.quote_id;
        v_row.item_no   := i.item_no;
        v_row.file_name := i.file_name;
        PIPE ROW(v_row);
    END LOOP;
  END;

  PROCEDURE delete_item_attachments(
    p_quote_id      gipi_quote_pictures.quote_id%TYPE,
    p_item_no       gipi_quote_pictures.item_no%TYPE
  ) IS
  BEGIN
    DELETE FROM gipi_quote_pictures
     WHERE quote_id = p_quote_id
       AND item_no = p_item_no;
  END;

  FUNCTION get_attachment_by_quote (
    p_quote_id  gipi_quote_pictures.quote_id%TYPE
  )
    RETURN attachment2_tab PIPELINED
  IS
    v_row   attachment2_type;
  BEGIN
    FOR i IN (SELECT quote_id, item_no, file_name
                FROM gipi_quote_pictures
               WHERE quote_id = p_quote_id)
    LOOP
        v_row.quote_id  := i.quote_id;
        v_row.item_no   := i.item_no;
        v_row.file_name := i.file_name;
        PIPE ROW(v_row);
    END LOOP;
  END;

  PROCEDURE update_file_name2 (
    p_quote_id      gipi_quote_pictures.quote_id%TYPE,
    p_item_no       gipi_quote_pictures.item_no%TYPE,
    p_old_file_name gipi_quote_pictures.file_name%TYPE,
    p_new_file_name gipi_quote_pictures.file_name%TYPE
  ) IS
  BEGIN
    UPDATE gipi_quote_pictures
       SET file_name = p_new_file_name
     WHERE quote_id = p_quote_id
       AND item_no = p_item_no
       AND file_name = p_old_file_name;
  END;

  FUNCTION get_gipi_quote_picture3 (
    p_quote_id      gipi_quote_pictures.quote_id%TYPE,
    p_item_no       gipi_quote_pictures.item_no%TYPE
  )
    RETURN quote_pic_tab PIPELINED
  IS
    v_row   quote_pic_type;
  BEGIN
    FOR i IN(
        SELECT quote_id, item_no, file_name, file_type, file_ext, remarks
          FROM gipi_quote_pictures
         WHERE quote_id = p_quote_id
           AND item_no = p_item_no
    )
    LOOP
        v_row.quote_id  := i.quote_id;
        v_row.item_no   := i.item_no;
        v_row.file_name := i.file_name;
        v_row.file_type := i.file_type;
        v_row.file_ext  := i.file_ext;
        v_row.remarks   := i.remarks;
        v_row.real_file_name := REGEXP_REPLACE(i.file_name, '.*/','');
        
        PIPE ROW(v_row);
    END LOOP;
  END get_gipi_quote_picture3;

END Gipi_Quote_Pictures_Pkg;
/


