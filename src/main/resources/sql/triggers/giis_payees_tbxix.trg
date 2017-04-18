DROP TRIGGER CPI.GIIS_PAYEES_TBXIX;

CREATE OR REPLACE TRIGGER CPI.GIIS_PAYEES_TBXIX
BEFORE INSERT ON CPI.GIIS_PAYEES FOR EACH ROW
DECLARE
   v_payee_no GIIS_PAYEE_NO.PAYEE_NO%TYPE;
   v_valid_cd GIAC_PARAMETERS.PARAM_VALUE_N%TYPE;
   v_payee_cd GIAC_PARAMETERS.PARAM_VALUE_N%TYPE;
   v_fund     GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
   v_branch   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
   v_payee_class_tag GIIS_PAYEE_CLASS.payee_class_tag%TYPE;
BEGIN -- big part
   BEGIN
      SELECT payee_class_tag
        INTO v_payee_class_tag
        FROM GIIS_PAYEE_CLASS
       WHERE payee_class_cd = :NEW.payee_class_cd;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20109,'ERROR IN GETTING PAYEE CLASS TAG.');
   END;
   IF v_payee_class_tag = 'S'  -- S/M
   THEN
      NULL;   -- do nothing for SYSTEM generated payees
   ELSIF v_payee_class_tag = 'M'
   THEN
      v_payee_no:= NULL;
      --
      -- get parameter values
      --
      BEGIN -- get_param
         v_valid_cd := Giacp.N('BRANCH_VALID_CD');
         IF v_valid_cd IS NULL THEN
            RAISE_APPLICATION_ERROR(-20110,'PARAMETER NOT FOUND.');
     END IF;
         v_payee_cd := Giacp.N('MAX_PAYEE_CD');
        IF v_payee_cd IS NULL THEN
            RAISE_APPLICATION_ERROR(-20110,'PARAMETER NOT FOUND.');
     END IF;
         v_fund := Giacp.V('FUND_CD');
         IF v_fund IS NULL THEN
            RAISE_APPLICATION_ERROR(-20110,'PARAMETER NOT FOUND.');
         END IF;
         v_branch := Giacp.V('BRANCH_CD');
         IF v_branch IS NULL THEN
            RAISE_APPLICATION_ERROR(-20110,'PARAMETER NOT FOUND.');
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20111,'ERROR IN GETTING PARAMETER VALUE.');
      END get_param;
      FOR ctr IN (SELECT payee_no
                    FROM GIIS_PAYEE_NO
                WHERE fund_cd= v_fund
                     AND branch_cd = v_branch
                  AND payee_class_cd = :NEW.payee_class_cd)
      LOOP
         v_payee_no:=ctr.payee_no+1;
         EXIT;
      END LOOP;
      IF v_payee_no IS NOT NULL
      THEN
         :NEW.payee_no:=v_payee_no;
         IF v_payee_no < v_payee_cd AND v_payee_no > v_valid_cd
         THEN
            UPDATE GIIS_PAYEE_NO
               SET payee_no= :NEW.payee_no
             WHERE fund_cd= v_fund
               AND payee_class_cd = :NEW.payee_class_cd
               AND branch_cd = v_branch;
         ELSE
            RAISE_APPLICATION_ERROR(-20111,'PAYEE NO. OUT OF RANGE.');
         END IF;
      ELSE
         :NEW.payee_no := v_valid_cd;
         INSERT INTO GIIS_PAYEE_NO
                (fund_cd, branch_cd, payee_class_cd, payee_no)
         VALUES (v_fund, v_branch, :NEW.payee_class_cd, :NEW.payee_no);
      END IF;
   END IF; -- S/M
EXCEPTION
   WHEN NO_DATA_FOUND  THEN
      RAISE_APPLICATION_ERROR(-20110,'DATA DOES NOT EXIST.');
END;
/


