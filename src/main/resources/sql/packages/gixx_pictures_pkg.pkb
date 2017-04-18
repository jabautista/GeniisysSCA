CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Pictures_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for retrieval of attached file records of the given extract_id and item_no.
*/
  FUNCTION get_gixx_picture(p_extract_id  GIXX_PICTURES.extract_id%TYPE,    --extract_id to limit the query
                            p_item_no     GIXX_PICTURES.item_no%TYPE)       --item_no to limit the query
    RETURN gixx_picture_tab PIPELINED IS

    v_picture  gixx_picture_type;

  BEGIN
    FOR i IN (
      SELECT extract_id, item_no, file_name,     file_type,
             file_ext,   remarks, pol_file_name
        FROM GIXX_PICTURES
       WHERE extract_id  = p_extract_id
         AND item_no     = p_item_no
       ORDER BY file_name)
    LOOP
      v_picture.extract_id     := i.extract_id;
      v_picture.item_no        := i.item_no;
      v_picture.file_name      := i.file_name;
      v_picture.file_type      := i.file_type;
      v_picture.file_ext       := i.file_ext;
      v_picture.remarks        := i.remarks;
      v_picture.pol_file_name  := i.pol_file_name;
      PIPE ROW(v_picture);
    END LOOP;
    RETURN;
  END get_gixx_picture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for inserting and updating file attachment records.
*/
  PROCEDURE set_gixx_picture(p_picture   GIXX_PICTURES%ROWTYPE)     --gixx_pictures row type to be inserted or updated
  IS
  BEGIN
    MERGE INTO GIXX_PICTURES
    USING DUAL ON (extract_id = p_picture.extract_id
               AND item_no    = p_picture.item_no
               AND file_name  = p_picture.file_name)
      WHEN NOT MATCHED THEN
        INSERT (extract_id,  item_no,   file_name,      file_type,
                file_ext,    remarks,   pol_file_name,  create_user)
        VALUES (p_picture.extract_id,   p_picture.item_no, p_picture.file_name,     p_picture.file_type,
                p_picture.file_ext,     p_picture.remarks, p_picture.pol_file_name, p_picture.user_id)
      WHEN MATCHED THEN
        UPDATE SET file_type     = p_picture.file_type,
                   file_ext      = p_picture.file_ext,
                   remarks       = p_picture.remarks,
                   pol_file_name = p_picture.pol_file_name,
                   user_id       = p_picture.user_id;
  END set_gixx_picture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for deleting file attachment record.
*/
  PROCEDURE del_gixx_picture(p_extract_id  GIXX_PICTURES.extract_id%TYPE,   --extract_id to limit the deletion
                             p_item_no     GIXX_PICTURES.item_no%TYPE,      --item_no to limit the deletion
                             p_file_name   GIXX_PICTURES.file_name%TYPE)    --file_name to limit the deletion
  IS
  BEGIN
    DELETE FROM GIXX_PICTURES
     WHERE extract_id = p_extract_id
       AND item_no    = p_item_no
       AND file_name  = p_file_name;

  END del_gixx_picture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for deleting file attachment records of the given extract_id and item_no.
*/
  PROCEDURE del_gixx_pictures(p_extract_id GIXX_PICTURES.extract_id%TYPE,   --extract_id to limit the deletion
                              p_item_no    GIXX_PICTURES.item_no%TYPE)      --item_no to limit the deletion
  IS
  BEGIN
    DELETE FROM GIXX_PICTURES
     WHERE extract_id = p_extract_id
       AND item_no    = p_item_no;

  END del_gixx_pictures;

END Gixx_Pictures_Pkg;
/


