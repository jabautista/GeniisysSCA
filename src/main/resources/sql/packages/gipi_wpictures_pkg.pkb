CREATE OR REPLACE PACKAGE BODY CPI.Gipi_WPictures_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 08, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for retrieval of attached file records of the given par_id and item_no.
*/
  FUNCTION get_gipi_wpicture(p_par_id      GIPI_WPICTURES.par_id%TYPE,      --par_id to limit the query
                             p_item_no     GIPI_WPICTURES.item_no%TYPE)     --item_no to limit the query
    RETURN gipi_wpicture_tab PIPELINED IS

    v_wpicture  gipi_wpicture_type;

  BEGIN
    FOR i IN (
      SELECT par_id, item_no, file_name, file_type, file_ext, remarks
        FROM GIPI_WPICTURES
       WHERE par_id  = p_par_id
         AND item_no = p_item_no
       ORDER BY file_name)
    LOOP
      v_wpicture.par_id      := i.par_id;
      v_wpicture.item_no     := i.item_no;
      v_wpicture.file_name   := i.file_name;
      v_wpicture.file_type   := i.file_type;
      v_wpicture.file_ext    := i.file_ext;
      v_wpicture.remarks     := i.remarks;
      v_wpicture.real_file_name := REGEXP_REPLACE(i.file_name, '.*/','');
      PIPE ROW(v_wpicture);
    END LOOP;
    RETURN;
  END get_gipi_wpicture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 08, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for inserting and updating file attachment records.
*/
  PROCEDURE set_gipi_wpicture(p_wpicture   GIPI_WPICTURES%ROWTYPE)  --gipi_wpictures row type to be inserted or updated
  IS
  BEGIN
    MERGE INTO GIPI_WPICTURES
    USING DUAL ON (par_id    = p_wpicture.par_id
               AND item_no   = p_wpicture.item_no
               AND file_name = p_wpicture.file_name)
      WHEN NOT MATCHED THEN
        INSERT (par_id,     item_no,    file_name,      file_type,
                file_ext,   remarks,    create_user)
        VALUES (p_wpicture.par_id,   p_wpicture.item_no, p_wpicture.file_name, p_wpicture.file_type,
                p_wpicture.file_ext, p_wpicture.remarks, p_wpicture.user_id)
      WHEN MATCHED THEN
        UPDATE SET file_type = p_wpicture.file_type,
                   file_ext  = p_wpicture.file_ext,
                   remarks   = p_wpicture.remarks,
                   user_id   = p_wpicture.user_id;
  END set_gipi_wpicture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 08, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for deleting file attachment record.
*/
  PROCEDURE del_gipi_wpicture(p_par_id     GIPI_WPICTURES.par_id%TYPE,      --par_id to limit the deletion
                              p_item_no    GIPI_WPICTURES.item_no%TYPE,     --item_no to limit the deletion
                              p_file_name  GIPI_WPICTURES.file_name%TYPE)   --file_name to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_WPICTURES
     WHERE par_id    = p_par_id
       AND item_no   = p_item_no
       AND file_name = p_file_name;

  END del_gipi_wpicture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 08, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for deleting file attachment records of the given par_id and item_no.
*/
  PROCEDURE del_gipi_wpictures(p_par_id     GIPI_WPICTURES.par_id%TYPE,     --par_id to limit the deletion
                               p_item_no    GIPI_WPICTURES.item_no%TYPE)    --item_no to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_WPICTURES
     WHERE par_id  = p_par_id
       AND item_no = p_item_no;

  END del_gipi_wpictures;
  
  FUNCTION get_attachment_by_par(
    p_par_id    gipi_wpictures.par_id%TYPE
  )
    RETURN gipi_wpicture2_tab PIPELINED
  IS
    v_row   gipi_wpicture2_type;
  BEGIN
    FOR i IN (SELECT par_id, item_no, file_name
                FROM gipi_wpictures
               WHERE par_id = p_par_id)
    LOOP
        v_row.par_id    := i.par_id;
        v_row.item_no   := i.item_no;
        v_row.file_name := i.file_name;
        PIPE ROW(v_row);
    END LOOP;
  END;

  FUNCTION get_item_attachments(
    p_par_id    gipi_wpictures.par_id%TYPE,
    p_item_no   gipi_wpictures.item_no%TYPE
  )
    RETURN attachment_tab PIPELINED
  IS
    v_row   attachment_type;
  BEGIN
    FOR i IN (
        SELECT file_name
          FROM gipi_wpictures
         WHERE par_id = p_par_id
           AND item_no = p_item_no)
    LOOP
        v_row.file_name := i.file_name;
        PIPE ROW(v_row);
    END LOOP;
  END;

  PROCEDURE update_file_name3(
    p_par_id        gipi_wpictures.par_id%TYPE,
    p_item_no       gipi_wpictures.item_no%TYPE,
    p_old_file_name gipi_wpictures.file_name%TYPE,
    p_new_file_name gipi_wpictures.file_name%TYPE
  ) IS
  BEGIN
    UPDATE gipi_wpictures
       SET file_name = p_new_file_name
     WHERE par_id = p_par_id
       AND item_no = p_item_no
       AND file_name = p_old_file_name;
  END;

   PROCEDURE save_attachment(
    p_par_id        gipi_wpictures.par_id%TYPE,
    p_item_no       gipi_wpictures.item_no%TYPE,
    p_file_name     gipi_wpictures.file_name%TYPE,
    p_file_type     gipi_wpictures.file_type%TYPE,
    p_file_ext      gipi_wpictures.file_ext%TYPE,
    p_remarks       gipi_wpictures.remarks%TYPE,
    p_user_id       gipi_wpictures.user_id%TYPE
  ) IS
  BEGIN
    MERGE INTO gipi_wpictures
    USING DUAL ON (par_id    = p_par_id
               AND item_no   = p_item_no
               AND file_name = p_file_name)
      WHEN NOT MATCHED THEN
        INSERT (par_id, item_no, file_name, file_type, file_ext, remarks, user_id)
        VALUES (p_par_id, p_item_no, p_file_name, p_file_type, p_file_ext, p_remarks, p_user_id)
      WHEN MATCHED THEN
        UPDATE SET file_type = p_file_type,
                   file_ext  = p_file_ext,
                   remarks   = p_remarks,
                   user_id   = p_user_id;
  END;

  PROCEDURE del_par_gipi_wpictures(
    p_par_id gipi_wpictures.par_id%TYPE)
  IS
  BEGIN
    DELETE FROM gipi_wpictures
     WHERE par_id   = p_par_id;
  END del_par_gipi_wpictures;

END Gipi_WPictures_Pkg;
/


