DROP FUNCTION CPI.GET_USER_ISS_CD;

CREATE OR REPLACE FUNCTION CPI.GET_USER_ISS_CD (
   v_user_id   giis_users.user_id%type
)
   RETURN VARCHAR2
IS
   v_iss_cd   giis_issource.iss_cd%TYPE:=NULL;

   CURSOR pol (v_user_id   giis_users.user_id%type)
   IS
        SELECT GRP_ISS_CD
          FROM GIIS_USER_GRP_HDR A, GIIS_USERS B
         WHERE 1=1
           AND B.USER_ID = v_user_id
           AND A.USER_GRP = B.USER_GRP;
BEGIN
   FOR rec IN pol (v_user_id)
   LOOP
      v_iss_cd  := rec.grp_iss_cd;
      EXIT;
   END LOOP rec;

   RETURN (v_iss_cd);
END GET_USER_ISS_CD;
/


