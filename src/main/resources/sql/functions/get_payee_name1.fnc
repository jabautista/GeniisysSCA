DROP FUNCTION CPI.GET_PAYEE_NAME1;

CREATE OR REPLACE FUNCTION CPI.get_payee_name1 (p_claim_id NUMBER, p_clm_loss_id NUMBER)
RETURN VARCHAR2 AS
  v_payee_name  VARCHAR2(300);
  v_payee_class_cd giis_payees.payee_class_cd%TYPE;
  v_payee_no  giis_payees.payee_no%TYPE;
BEGIN
  FOR rec IN (SELECT payee_class_cd, payee_cd
                FROM gicl_clm_loss_exp
               WHERE claim_id = p_claim_id
                 AND clm_loss_id = p_clm_loss_id)
  LOOP
    v_payee_class_cd := rec.payee_class_cd;
    v_payee_no := rec.payee_cd;
    FOR NAME IN (SELECT DECODE(payee_first_name, NULL, payee_last_name, payee_last_name||', '||payee_first_name||' '||payee_middle_name) payee_name
                   FROM giis_payees
                  WHERE payee_class_cd = v_payee_class_cd
                    AND payee_no = v_payee_no)
    LOOP
      v_payee_name := NAME.payee_name;
      EXIT;
    END LOOP;
  END LOOP;
  RETURN (v_payee_name);
END;
/


