DROP FUNCTION CPI.GET_PACK_POLICY_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Pack_Policy_No (
   v_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
)
   RETURN VARCHAR2
IS
   v_policy_no   VARCHAR2 (50) := NULL;

   CURSOR pol (v_policy_id gipi_pack_polbasic.pack_policy_id%TYPE)
   IS
      SELECT    line_cd
             || '-'
             || subline_cd
             || '-'
             || iss_cd
             || '-'
             || LTRIM (TO_CHAR (issue_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
             || '-'
             || LTRIM (TO_CHAR (renew_no, '09'))
             || DECODE (
                   NVL (endt_seq_no, 0),
                   0, '',
                      ' / '
                   || endt_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (endt_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (endt_seq_no, '9999999'))
                ) policy
        FROM gipi_pack_polbasic
       WHERE pack_policy_id = v_policy_id;
BEGIN
   FOR rec IN pol (v_policy_id)
   LOOP
      v_policy_no := rec.policy;
      EXIT;
   END LOOP rec;

   RETURN (v_policy_no);
END Get_Pack_Policy_No;
/


