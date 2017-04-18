DROP FUNCTION CPI.CHECK_USER_PER_ISS_CD_ACCTG2;

CREATE OR REPLACE FUNCTION CPI."CHECK_USER_PER_ISS_CD_ACCTG2" (p_line_cd   VARCHAR2
         , p_iss_cd    VARCHAR2
         , p_module_id VARCHAR2
         , p_user_id   giis_users.user_id%TYPE)
  RETURN NUMBER IS
  v_iss_cd_access NUMBER(1) := 0;
   v_access_tag      NUMBER (1) := 2; --mikel 04.05.2013
BEGIN

  FOR a IN (
  SELECT 1, a.user_grp, b.tran_cd --mikel 04.05.2013; added user_grp, tran_cd
    FROM giis_users a
        , giis_user_iss_cd b
        , giis_modules_tran c
   WHERE a.user_id  = b.userid
     AND a.user_id   = NVL(p_user_id, USER)
     AND b.iss_cd    = p_iss_cd
     AND b.tran_cd   = c.tran_cd
                AND c.module_id = p_module_id)
   LOOP
      --added by mikel 04.05.2013; added validation for access_tag
      BEGIN
          SELECT access_tag
            INTO v_access_tag
            FROM /* GIIS_USER_GRP_MODULES -- jhing replaced with: */ GIIS_USER_MODULES 
           WHERE /* user_grp = a.user_grp  -- jhing replaced with: */ userid = NVL(p_user_id, user)
             AND tran_cd = a.tran_cd
             AND module_id = p_module_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
      END;         
      
      IF v_access_tag = 1 THEN  --mikel 04.05.2013 
    v_iss_cd_access := 1;

      END IF;  
      
  END LOOP;
  IF v_iss_cd_access = 1 THEN
     RETURN v_iss_cd_access;
  END IF;
  FOR a IN (
  SELECT 1, a.user_grp, b.tran_cd /* jhing 04.06.2013 added user_grp and tran_cd */ 
    FROM giis_users a
        , giis_user_grp_dtl b
        , giis_modules_tran c
   WHERE a.user_grp  = b.user_grp
     AND a.user_id   = NVL(p_user_id, USER)
     AND b.iss_cd    = p_iss_cd
     AND b.tran_cd   = c.tran_cd
                AND c.module_id = p_module_id)
   LOOP
   
   --added by mikel 04.05.2013; added validation for access_tag
     BEGIN
       SELECT access_tag
         INTO v_access_tag
         FROM /* GIIS_USER_MODULES -- jhing 04.06.2013 replaced with: */ GIIS_USER_GRP_MODULES 
        WHERE /* userid = user -- jhing 04.06.2013 replaced with: */ user_grp = a.user_grp
		  AND tran_cd   = a.tran_cd --added by steven 06.01.2013 to handle multiple tran. code in a module_id
          AND module_id = p_module_id;
     EXCEPTION WHEN NO_DATA_FOUND THEN
       NULL;   
     END;
       
     IF v_access_tag = 1 THEN --mikel 04.05.2013    
    v_iss_cd_access := 1;
     END IF;
      
  END LOOP;
  IF v_iss_cd_access = 1 THEN
   RETURN v_iss_cd_access;
  END IF;
  RETURN v_iss_cd_access;
END check_user_per_iss_cd_acctg2;
/


