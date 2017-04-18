CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Grp_Hdr_Pkg AS

  FUNCTION get_giis_user_grp_list (p_param    VARCHAR2)
    RETURN giis_user_grp_tab PIPELINED IS

    v_user_grp    giis_user_grp_type;

  BEGIN
    FOR a IN (SELECT a.user_grp,  a.user_grp_desc, a.grp_iss_cd,  b.iss_name, a.remarks
                FROM GIIS_USER_GRP_HDR a,
                     GIIS_ISSOURCE b
                 WHERE a.grp_iss_cd = b.iss_cd
                 AND (a.user_grp                LIKE '%'|| UPPER(p_param) ||'%' OR
                      a.user_grp_desc        LIKE '%'|| UPPER(p_param) ||'%' OR
                      b.iss_name  LIKE '%'|| UPPER(p_param) ||'%')
               ORDER BY a.user_grp)
    LOOP
      v_user_grp.user_grp         := a.user_grp;
      v_user_grp.user_grp_desc    := a.user_grp_desc;
      v_user_grp.grp_iss_cd       := a.grp_iss_cd;
      v_user_grp.iss_name         := a.iss_name;
	  v_user_grp.remarks		  := a.remarks;
      PIPE ROW(v_user_grp);
    END LOOP;
    RETURN;
  END get_giis_user_grp_list;


  PROCEDURE set_giis_user_grp_hdr (
    v_user_grp                 GIIS_USER_GRP_HDR.user_grp%TYPE,
    v_user_grp_desc            GIIS_USER_GRP_HDR.user_grp_desc%TYPE,
    v_remarks                  GIIS_USER_GRP_HDR.remarks%TYPE,
    v_grp_iss_cd               GIIS_USER_GRP_HDR.grp_iss_cd%TYPE,
    v_session_user             GIIS_USERS.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_GRP_HDR
    USING DUAL ON (user_grp = v_user_grp)
     WHEN NOT MATCHED THEN
            INSERT (user_grp,       user_grp_desc,     user_id,          last_update,    remarks,       grp_iss_cd,
                    create_user,    create_date)
            VALUES (v_user_grp,     v_user_grp_desc,   v_session_user,   SYSDATE,        v_remarks,     v_grp_iss_cd,
                    v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_grp_desc =   v_user_grp_desc,
                     user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     remarks       =   v_remarks,
                     grp_iss_cd    =   v_grp_iss_cd;
    --COMMIT;
  END set_giis_user_grp_hdr;

  PROCEDURE del_giis_user_grp_hdr (p_user_grp	    	GIIS_USER_GRP_HDR.user_grp%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_HDR
     WHERE user_grp  = p_user_grp;

    DELETE FROM GIIS_USER_GRP_TRAN
     WHERE user_grp = p_user_grp;

    DELETE FROM GIIS_USER_GRP_MODULES
     WHERE user_grp = p_user_grp;

    COMMIT;

  END del_giis_user_grp_hdr;

  /*
   **  Created by     : Marco Paolo Rebong
   **  Date Created   : 08.22.2012
   **  Reference By   : GIISS041 - Maintain User Group
   **  Description    : copies records from a user group to a new user group
   */
  PROCEDURE copy_user_group_records(
    p_user_grp          GIIS_USER_GRP_HDR.user_grp%TYPE,
    p_new_user_grp      GIIS_USER_GRP_HDR.user_grp%TYPE,
    p_user_id           GIIS_USER_GRP_HDR.user_id%TYPE
  )
  IS
    v_tran              NUMBER;
    v_iss               VARCHAR2(10);

    CURSOR c1 IS
        (SELECT tran_cd, remarks, access_tag
	       FROM GIIS_USER_GRP_TRAN
	      WHERE user_grp = p_user_grp);

	CURSOR c2 IS
        (SELECT module_id, remarks, access_tag
	       FROM GIIS_USER_GRP_MODULES
	      WHERE user_grp = p_user_grp
	        AND tran_cd = v_tran);

	CURSOR c3 IS
	    (SELECT iss_cd, remarks
	       FROM GIIS_USER_GRP_DTL
	      WHERE user_grp = p_user_grp
	        AND tran_cd = v_tran);

    CURSOR c4 IS
        (SELECT line_cd, remarks
           FROM GIIS_USER_GRP_LINE
          WHERE user_grp = p_user_grp
            AND tran_cd = v_tran
            AND iss_cd = v_iss);
  BEGIN
    FOR c1_rec in c1 LOOP
        v_tran := c1_rec.tran_cd;
        MERGE INTO GIIS_USER_GRP_TRAN
        USING DUAL ON (user_grp = p_new_user_grp AND
                       tran_cd = c1_rec.tran_cd)
         WHEN NOT MATCHED THEN
              INSERT (user_grp, tran_cd, user_id, last_update, remarks, access_tag)
              VALUES (p_new_user_grp, c1_rec.tran_cd, p_user_id, SYSDATE, c1_rec.remarks, c1_rec.access_tag)
         WHEN MATCHED THEN
              UPDATE SET user_id = p_user_id,
                         last_update = SYSDATE,
                         remarks = c1_rec.remarks,
                         access_tag = c1_rec.access_tag;

        FOR c2_rec in c2 LOOP
            MERGE INTO GIIS_USER_GRP_MODULES
            USING DUAL ON (user_grp = p_new_user_grp AND module_id = c2_rec.module_id AND tran_cd = c1_rec.tran_cd)
             WHEN NOT MATCHED THEN
                  INSERT (user_grp, module_id, user_id, last_update, remarks, access_tag, tran_cd)
                  VALUES (p_new_user_grp, c2_rec.module_id, p_user_id, SYSDATE, c2_rec.remarks, c2_rec.access_tag, c1_rec.tran_cd)
             WHEN MATCHED THEN
                  UPDATE SET user_id = p_user_id,
                             last_update = SYSDATE,
                             remarks = c2_rec.remarks,
                             access_tag = c2_rec.access_tag;
        END LOOP;

        FOR c3_rec in c3 LOOP
            MERGE INTO GIIS_USER_GRP_DTL
            USING DUAL ON (user_grp = p_new_user_grp AND iss_cd = c3_rec.iss_cd AND tran_cd = v_tran)
             WHEN NOT MATCHED THEN
                  INSERT (user_grp, iss_cd, user_id, last_update, remarks, tran_cd)
                  VALUES (p_new_user_grp, c3_rec.iss_cd, p_user_id, SYSDATE, c3_rec.remarks, v_tran)
             WHEN MATCHED THEN
                  UPDATE SET user_id = p_user_id,
                             last_update = SYSDATE,
                             remarks = c3_rec.remarks;

            v_iss := c3_rec.iss_cd;
            FOR c4_rec in c4 LOOP
                MERGE INTO GIIS_USER_GRP_LINE
                USING DUAL ON (user_grp = p_new_user_grp AND tran_cd = v_tran AND line_cd = c4_rec.line_cd AND iss_cd = v_iss)
                 WHEN NOT MATCHED THEN
                      INSERT (user_grp, line_cd, iss_cd, user_id, last_update, remarks, tran_cd)
                      VALUES (p_new_user_grp, c4_rec.line_cd, v_iss, p_user_id, SYSDATE, c4_rec.remarks, v_tran)
                 WHEN MATCHED THEN
                      UPDATE SET user_id = p_user_id,
                                 last_update = SYSDATE,
                                 remarks = c4_rec.remarks;
            END LOOP;
        END LOOP;
    END LOOP;
  END;

END Giis_User_Grp_Hdr_Pkg;
/


