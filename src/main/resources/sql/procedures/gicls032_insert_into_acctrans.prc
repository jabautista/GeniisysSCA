DROP PROCEDURE CPI.GICLS032_INSERT_INTO_ACCTRANS;

CREATE OR REPLACE PROCEDURE CPI.gicls032_insert_into_acctrans (
   p_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
   p_user_id           giis_users.user_id%TYPE,
   p_tran_id     OUT   giac_payt_requests_dtl.tran_id%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  2.28.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - insert_into_acctrans
   */
   v_fund_cd       giac_parameters.param_value_v%TYPE   := giacp.v ('FUND_CD');

   CURSOR fund
   IS
      SELECT '1'
        FROM giis_funds
       WHERE fund_cd = v_fund_cd;

   CURSOR branch
   IS
      SELECT '1'
        FROM giac_branches
       WHERE branch_cd = p_branch_cd;

   v_fund          VARCHAR2 (1);
   v_branch        VARCHAR2 (1);
   v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
BEGIN
   OPEN fund;

   FETCH fund
    INTO v_fund;

   IF fund%NOTFOUND
   THEN
      raise_application_error (-20001, 'Fund code is not found in GIIS_FUNDS.');
   ELSE
      OPEN branch;

      FETCH branch
       INTO v_branch;

      IF branch%NOTFOUND
      THEN
         raise_application_error (-20001, 'Branch code is not found in GIAC_BRANCHES.');
      END IF;

      CLOSE branch;
   END IF;

   CLOSE fund;

   BEGIN
      SELECT acctran_tran_id_s.NEXTVAL
        INTO p_tran_id
        FROM DUAL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'ACCTRAN_TRAN_ID sequence not found.');
   END;

   v_tran_seq_no :=
      giac_sequence_generation (v_fund_cd,
                                p_branch_cd,
                                'ACCTRAN_TRAN_SEQ_NO',
                                TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')),
                                TO_NUMBER (TO_CHAR (SYSDATE, 'mm'))
                               );

   INSERT INTO giac_acctrans
               (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date, tran_flag, tran_class, tran_year,
                tran_month, tran_seq_no, user_id, last_update
               )
        VALUES (p_tran_id, v_fund_cd, p_branch_cd, SYSDATE, 'O', 'DV', TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')),
                TO_NUMBER (TO_CHAR (SYSDATE, 'MM')), v_tran_seq_no, p_user_id, SYSDATE
               );

   IF SQL%NOTFOUND
   THEN
      raise_application_error (-20001, 'Cannot Insert into giac_acctrans.');
   ELSE
      RETURN;
   END IF;
END;
/


