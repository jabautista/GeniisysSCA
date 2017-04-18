DROP PROCEDURE CPI.GENERATE_REF_NO;

CREATE OR REPLACE PROCEDURE CPI.generate_ref_no (
  p_acct_iss_cd   IN       giis_ref_seq.acct_iss_cd%TYPE,
  p_branch_cd     IN       giis_ref_seq.branch_cd%TYPE,
  p_ref_no        OUT      giis_ref_seq.ref_no%TYPE,
  p_module_id     IN       giis_modules.module_id%TYPE)
IS
  v_module_desc   giis_modules.module_desc%TYPE;
  v_ref_no        giis_ref_seq.ref_no%TYPE;
BEGIN
  BEGIN
    SELECT module_desc
      INTO v_module_desc
      FROM giis_modules
     WHERE module_id = p_module_id;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      NULL;
  END;

  SELECT ref_no
    INTO v_ref_no
    FROM giis_ref_seq
   WHERE acct_iss_cd = p_acct_iss_cd AND branch_cd = p_branch_cd;

  UPDATE giis_ref_seq
     SET ref_no = ref_no + 1
   WHERE acct_iss_cd = p_acct_iss_cd AND branch_cd = p_branch_cd;

  IF SQL%FOUND
  THEN
    INSERT INTO gipi_ref_no_hist
                (acct_iss_cd, branch_cd, ref_no,
                 mod_no,
                 user_id, last_update,
                 remarks)
         VALUES (p_acct_iss_cd, p_branch_cd, v_ref_no + 1,
                 TO_NUMBER (modulus_10 (   TRIM (TO_CHAR (p_acct_iss_cd, '00'))
                                        || '-'
                                        || TRIM (TO_CHAR (p_branch_cd, '0000'))
                                        || '-'
                                        || TRIM (TO_CHAR (p_ref_no, '0000000'))
                                       )
                           ),
                 NVL(giis_users_pkg.app_user, USER), SYSDATE,
                 'Generated using ' || p_module_id || ' - ' || v_module_desc);

    p_ref_no := v_ref_no + 1;
  END IF;

  --COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    v_ref_no := 1;

    INSERT INTO giis_ref_seq
         VALUES (p_acct_iss_cd, p_branch_cd, v_ref_no, NVL(giis_users_pkg.app_user, USER), SYSDATE,
                 'Generated using ' || p_module_id || ' - ' || v_module_desc);

    INSERT INTO gipi_ref_no_hist
                (acct_iss_cd, branch_cd, ref_no,
                 mod_no,
                 user_id, last_update,
                 remarks)
         VALUES (p_acct_iss_cd, p_branch_cd, v_ref_no,
                 TO_NUMBER (modulus_10 (   TRIM (TO_CHAR (p_acct_iss_cd, '00'))
                                        || '-'
                                        || TRIM (TO_CHAR (p_branch_cd, '0000'))
                                        || '-'
                                        || TRIM (TO_CHAR (p_ref_no, '0000000'))
                                       )
                           ),
                 NVL(giis_users_pkg.app_user, USER), SYSDATE,
                 'Generated using ' || p_module_id || ' - ' || v_module_desc);

    p_ref_no := v_ref_no;
    --COMMIT;
END generate_ref_no;
/


