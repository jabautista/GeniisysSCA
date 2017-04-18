CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Pictures_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for retrieval of attached file records of the given policy_id and item_no.
*/
  FUNCTION get_gipi_picture(p_policy_id  GIPI_PICTURES.policy_id%TYPE,  --policy_id to limit the query
                            p_item_no    GIPI_PICTURES.item_no%TYPE)    --item_no to limit the query
    RETURN gipi_picture_tab PIPELINED IS

    v_picture  gipi_picture_type;

  BEGIN
    FOR i IN (
      SELECT policy_id, item_no, file_name,     file_type,
             file_ext,  remarks, pol_file_name, arc_ext_data
        FROM GIPI_PICTURES
       WHERE policy_id  = p_policy_id
         AND item_no    = p_item_no
       ORDER BY file_name)
    LOOP
      v_picture.policy_id     := i.policy_id;
      v_picture.item_no       := i.item_no;
      v_picture.file_name     := i.file_name;
      v_picture.file_type     := i.file_type;
      v_picture.file_ext      := i.file_ext;
      v_picture.remarks       := i.remarks;
      v_picture.pol_file_name := i.pol_file_name;
      v_picture.arc_ext_data  := i.arc_ext_data;
      v_picture.real_file_name := REGEXP_REPLACE(i.file_name, '.*/','');
      
      PIPE ROW(v_picture);
    END LOOP;
    RETURN;
  END get_gipi_picture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for inserting and updating file attachment records.
*/
  PROCEDURE set_gipi_picture(p_picture   GIPI_PICTURES%ROWTYPE)     --gipi_pictures row type to be inserted or updated
  IS
  BEGIN
    MERGE INTO GIPI_PICTURES
    USING DUAL ON (policy_id = p_picture.policy_id
               AND item_no   = p_picture.item_no
               AND file_name = p_picture.file_name)
      WHEN NOT MATCHED THEN
        INSERT (policy_id,  item_no,    file_name,      file_type,
                file_ext,   remarks,    create_user)
        VALUES (p_picture.policy_id,    p_picture.item_no, p_picture.file_name, p_picture.file_type,
                p_picture.file_ext,     p_picture.remarks, p_picture.user_id)
      WHEN MATCHED THEN
        UPDATE SET file_type     = p_picture.file_type,
                   file_ext      = p_picture.file_ext,
                   remarks       = p_picture.remarks,
                   pol_file_name = p_picture.pol_file_name,
                   arc_ext_data  = p_picture.arc_ext_data,
                   user_id       = p_picture.user_id;
  END set_gipi_picture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for deleting file attachment record.
*/
  PROCEDURE del_gipi_picture(p_policy_id  GIPI_PICTURES.policy_id%TYPE,     --policy_id to limit the deletion
                             p_item_no    GIPI_PICTURES.item_no%TYPE,       --item_no to limit the deletion
                             p_file_name  GIPI_PICTURES.file_name%TYPE)     --file_name to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_PICTURES
     WHERE policy_id = p_policy_id
       AND item_no   = p_item_no
       AND file_name = p_file_name;

  END del_gipi_picture;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS204 - Attach Media)
**  Description  : This is for deleting file attachment records of the given policy_id and item_no.
*/
  PROCEDURE del_gipi_pictures(p_policy_id GIPI_PICTURES.policy_id%TYPE,     --policy_id to limit the deletion
                              p_item_no   GIPI_PICTURES.item_no%TYPE)       --item_no to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_PICTURES
     WHERE policy_id  = p_policy_id
       AND item_no    = p_item_no;

  END del_gipi_pictures;

END Gipi_Pictures_Pkg;
/


