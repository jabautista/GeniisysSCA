CREATE OR REPLACE PACKAGE BODY CPI.Gipi_MC_Upload_Pkg AS

/*
**  Created by   :  Grace Miralles
**  Date Created :  March 2, 2010
**  Reference By : (GIPIS198 - Upload Fleet Data)
**  Description  : This is for retrieval of uploaded fleet date.
*/
  FUNCTION get_gipi_mc_upload (p_filename      GIPI_MC_UPLOAD.filename%TYPE)  --name of the uploaded file
    RETURN gipi_mc_upload_tab PIPELINED IS

    v_upload      gipi_mc_upload%ROWTYPE;
    v_filename    VARCHAR2(500) := p_filename;
  BEGIN
    IF p_filename IS NULL THEN
        v_filename := '%';
    END IF;
    FOR i IN (
      SELECT upload_no, filename, upload_date, item_no, motor_no, serial_no, plate_no
        FROM GIPI_MC_UPLOAD
       WHERE filename like v_filename
       ORDER BY item_no)
    LOOP
      v_upload.upload_no   := i.upload_no;
      v_upload.filename    := i.filename;
      v_upload.upload_date := i.upload_date;
      v_upload.item_no     := i.item_no;
      v_upload.motor_no    := i.motor_no;
      v_upload.serial_no   := i.serial_no;
      v_upload.plate_no    := i.plate_no;
      PIPE ROW(v_upload);
    END LOOP;
    RETURN;
  END get_gipi_mc_upload;

/*
**  Created by   :  Grace C. Miralles
**  Date Created :  March 2, 2010
**  Reference By : (GIPIS198 - Upload Fleet Data)
**  Description  : This is for inserting valid records in GIPI_MC_UPLOAD
*/
  PROCEDURE set_gipi_mc_upload (p_filename            GIPI_MC_UPLOAD.filename%TYPE,
                                p_item_no             GIPI_MC_UPLOAD.item_no%TYPE,
                                p_motor_no            GIPI_MC_UPLOAD.motor_no%TYPE,
                                p_serial_no           GIPI_MC_UPLOAD.serial_no%TYPE,
                                p_plate_no            GIPI_MC_UPLOAD.plate_no%TYPE,
								p_item_title		  GIPI_MC_ERROR_LOG.item_title%TYPE,
								p_subline_type_cd	  GIPI_MC_ERROR_LOG.subline_type_cd%TYPE,
                                p_session_user    	  GIPI_MC_UPLOAD.user_id%TYPE)    --application user name
  IS

    v_exist         VARCHAR2(1) := 'N';
    v_upload_no     GIPI_MC_UPLOAD.upload_no%TYPE;

  BEGIN

  SELECT GIPI_MC_UPLOAD_SEQ_NO.NEXTVAL
          INTO v_upload_no
       FROM DUAL;

  FOR A IN (SELECT upload_no, filename, upload_date, item_no, motor_no, serial_no, plate_no
                FROM GIPI_MC_UPLOAD
               WHERE filename  = p_filename
                 AND (motor_no = p_motor_no
		          OR plate_no  = p_plate_no
		          OR serial_no = p_serial_no
		          OR item_no   = p_item_no))
    LOOP
      v_exist := 'Y';
    END LOOP;
    IF v_exist = 'Y' THEN
       INSERT INTO GIPI_MC_ERROR_LOG
               (upload_no,                filename,                   user_id,
                last_update,              item_no,                    motor_no,                 serial_no,
                plate_no,                 item_title,				  subline_type_cd,
				create_user,              create_date)
        VALUES (v_upload_no,              p_filename,                 p_session_user,
                SYSDATE,                  p_item_no,                  p_motor_no,               p_serial_no,
                p_plate_no,               p_item_title,				  p_subline_type_cd,
				p_session_user,           SYSDATE);
     ELSE
        INSERT INTO GIPI_MC_UPLOAD
               (upload_no,                filename,                   upload_date,				user_id,
                last_update,              item_no,                    motor_no,                 serial_no,
                plate_no,                 create_user,                create_date)
        VALUES (v_upload_no,              p_filename,                 SYSDATE,   				p_session_user,
                SYSDATE,                  p_item_no,                  p_motor_no,               p_serial_no,
                p_plate_no,               p_session_user,             SYSDATE);
        v_exist := 'N';
     END IF;
  END set_gipi_mc_upload;

/*
**  Created by   :  Grace C. Miralles
**  Date Created :  March 2, 2010
**  Reference By : (GIPIS198 - Upload Fleet Data)
**  Description  : This is for deleting the uploaded records
*/
  PROCEDURE del_gipi_mc_upload (p_filename       GIPI_MC_UPLOAD.filename%TYPE)   --filename of the records that will be deleted
  IS
  BEGIN
    DELETE FROM GIPI_MC_UPLOAD
     WHERE filename = p_filename;

  END del_gipi_mc_upload;

  /*
    **  Created by   :  D.Alcantara
    **  Date Created :  March 6, 2012
    **  Reference By : (GIPIS198 - Upload Fleet Data)
    **  Description  : This is for inserting valid records in GIPI_MC_ERROR_LOG
    */
  PROCEDURE set_gipi_mc_upload1 (p_upload_no          GIPI_MC_UPLOAD.upload_no%TYPE,
                                p_filename            GIPI_MC_UPLOAD.filename%TYPE,
                                p_item_no             GIPI_MC_UPLOAD.item_no%TYPE,
                                p_motor_no            GIPI_MC_UPLOAD.motor_no%TYPE,
                                p_serial_no           GIPI_MC_UPLOAD.serial_no%TYPE,
                                p_plate_no            GIPI_MC_UPLOAD.plate_no%TYPE,
								p_item_title		  GIPI_MC_ERROR_LOG.item_title%TYPE,
								p_subline_type_cd	  GIPI_MC_ERROR_LOG.subline_type_cd%TYPE,
                                p_user_id             GIPI_MC_UPLOAD.user_id%TYPE) IS
  BEGIN
    MERGE INTO GIPI_MC_UPLOAD
    USING DUAL
       ON (upload_no = p_upload_no AND p_filename = p_filename)
     WHEN NOT MATCHED THEN
        INSERT (
            upload_no,                filename,                   upload_date,				user_id,
            last_update,              item_no,                    motor_no,                 serial_no,
            plate_no,                 create_user,                create_date
         )
        VALUES (
            p_upload_no,              p_filename,                 SYSDATE,   				p_user_id,
            SYSDATE,                  p_item_no,                  p_motor_no,               p_serial_no,
            p_plate_no,               p_user_id,                  SYSDATE
         )
     WHEN MATCHED THEN
        UPDATE
           SET  upload_date     = SYSDATE,
                user_id         = NVL(p_user_id, USER),
                last_update     = SYSDATE,
                item_no         = p_item_no,
                motor_no        = p_motor_no,
                serial_no       = p_serial_no,
                plate_no        = p_plate_no,
                create_user     = NVL(p_user_id, USER),
                create_date     = SYSDATE;
  END set_gipi_mc_upload1;

END Gipi_MC_Upload_Pkg;
/


