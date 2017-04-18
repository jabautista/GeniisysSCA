SET SERVEROUTPUT ON;

DECLARE
   v_old_text            VARCHAR2 (100);
   v_default_jv_seq_no   giac_acctrans.jv_seq_no%TYPE := 1;
   v_jv_seq_no           giac_acctrans.jv_seq_no%TYPE;
   v_count               NUMBER := 1;
BEGIN
   FOR rec IN (  SELECT tran_id,
                        gfun_fund_cd,
                        gibr_branch_cd,
                        tran_year,
                        tran_month,
                        JV_SEQ_NO
                   FROM giac_acctrans
                  WHERE tran_class NOT IN ('COL', 'DV')
               ORDER BY gfun_fund_cd,
                        gibr_branch_cd,
                        tran_year,
                        tran_month,
                        tran_id)
   LOOP
      IF    rec.gfun_fund_cd
         || '-'
         || rec.gibr_branch_cd
         || '-'
         || rec.tran_year
         || '-'
         || rec.tran_month = v_old_text
      THEN
         v_jv_seq_no := v_jv_seq_no + 1;
      ELSE
         v_jv_seq_no := v_default_jv_seq_no;
      END IF;

      UPDATE giac_acctrans
         SET jv_seq_no = v_jv_seq_no, jv_pref = 'JV'
       WHERE tran_id = rec.tran_id;

      v_old_text :=
            rec.gfun_fund_cd
         || '-'
         || rec.gibr_branch_cd
         || '-'
         || rec.tran_year
         || '-'
         || rec.tran_month;
      v_count := v_count + 1;
   END LOOP;

   COMMIT;
   DBMS_OUTPUT.put_line (v_count || ' records updated.');
END;