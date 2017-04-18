DROP FUNCTION CPI.CHECK_CREDITING_BRANCH;

CREATE OR REPLACE FUNCTION CPI.check_crediting_branch(p_pack_pol varchar2,p_par_id number)
   RETURN BOOLEAN
IS
   v_access_flag       BOOLEAN;
   v_param             giis_parameters.param_value_v%TYPE;
BEGIN
   --querying the value of giis_users.temp_access_tag
   BEGIN
      SELECT param_value_v
        INTO v_param
        FROM giis_parameters
       WHERE param_name like 'MANDATORY_CRED_BRANCH';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_param := 'N';
   END;

   --will decide if user can logon or not
   IF v_param = 'Y' THEN
   v_access_flag := TRUE;
    IF NVL(p_pack_pol,'N') = 'Y' THEN
        FOR a in (select cred_branch
                    from gipi_wpolbas
                   where pack_par_id = p_par_id)
        LOOP
            IF a.cred_branch IS NULL THEN
                v_access_flag := FALSE;
            END IF;
        END LOOP;
    ELSIF NVL(p_pack_pol,'N') = 'N' THEN
        FOR a in (select cred_branch
                    from gipi_wpolbas
                   where par_id = p_par_id)
        LOOP
            IF a.cred_branch IS NULL THEN
                v_access_flag := FALSE;
            END IF;
        END LOOP;    
    ELSE
        v_access_flag := TRUE;
    END IF;
   END IF;
   
   RETURN v_access_flag;
END check_crediting_branch;
/


