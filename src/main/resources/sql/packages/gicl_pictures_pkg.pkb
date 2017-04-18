CREATE OR REPLACE PACKAGE BODY CPI.gicl_pictures_pkg
AS

    /*
    ** Created by : Niknok Orio 
    ** Date Created : 09 19, 2011
    ** Reference By : (GICLS015 - Fire Item Info) 
    ** Description : Procedure for attached files for claim item information 
    */
    FUNCTION get_gicl_pictures(
        p_claim_id        gicl_pictures.claim_id%TYPE,
        p_item_no         gicl_pictures.item_no%TYPE
        )   
    RETURN gicl_pictures_tab PIPELINED IS
        v_list          gicl_pictures_type;
    BEGIN    
        FOR i IN (SELECT a.claim_id, a.item_no, a.file_name,
                         a.file_ext, a.file_type, a.remarks
                    FROM gicl_pictures a
                   WHERE a.claim_id = p_claim_id
                     AND a.item_no = p_item_no)
        LOOP
            v_list.claim_id         := i.claim_id;
            v_list.item_no          := i.item_no;
            v_list.file_name        := i.file_name;
            v_list.file_ext         := i.file_ext;
            v_list.file_type        := i.file_type;
            v_list.remarks          := i.remarks;
            v_list.real_file_name   := REGEXP_REPLACE(i.file_name, '.*/','');
        PIPE ROW(v_list);             
        END LOOP;
    RETURN;
    END;

    /*
    ** Created by : Niknok Orio 
    ** Date Created : 09 19, 2011
    ** Reference By : (GICLS015 - Fire Item Info) 
    ** Description : Procedure for attached files for claim item information 
    */
    PROCEDURE set_gicl_pictures(
        p_clm		GICL_PICTURES%ROWTYPE
    ) IS
    BEGIN
        MERGE INTO gicl_pictures
	    USING DUAL ON (claim_id = p_clm.claim_id
	   		 	  AND item_no	= p_clm.item_no
				  AND file_name = p_clm.file_name)
		 WHEN NOT MATCHED THEN
		   INSERT (claim_id, item_no, file_name, file_type,
		   		   file_ext, remarks, user_id, last_update)
		   VALUES (p_clm.claim_id, p_clm.item_no, p_clm.file_name,
		   		   p_clm.file_type, p_clm.file_ext, p_clm.remarks,
				   p_clm.user_id, SYSDATE)
		 WHEN MATCHED THEN
		   UPDATE SET file_type = p_clm.file_type,
		   		      file_ext = p_clm.file_ext,
					  remarks = p_clm.remarks,
                      user_id = p_clm.user_id,
                      last_update = sysdate;
    END set_gicl_pictures;

    /*
    ** Created by : Niknok Orio 
    ** Date Created : 09 19, 2011
    ** Reference By : (GICLS015 - Fire Item Info) 
    ** Description : Procedure for attached files for claim item information 
    */
    PROCEDURE del_gicl_pictures(
        p_claim_id		gicl_pictures.claim_id%TYPE,
	    p_item_no		gicl_pictures.item_no%TYPE
    ) IS
    BEGIN
  	   DELETE FROM gicl_pictures
	    WHERE claim_id = p_claim_id
		  AND item_no = p_item_no;
    END del_gicl_pictures;
  
    PROCEDURE del_gicl_picture (
        p_claim_id      gicl_pictures.claim_id%TYPE,
        p_item_no       gicl_pictures.item_no%TYPE,
        p_file_name     gicl_pictures.file_name%TYPE
    ) IS
    BEGIN
        DELETE FROM gicl_pictures
         WHERE claim_id = p_claim_id
           AND item_no = p_item_no
           AND file_name = p_file_name;
    END del_gicl_picture;

END gicl_pictures_pkg;
/


