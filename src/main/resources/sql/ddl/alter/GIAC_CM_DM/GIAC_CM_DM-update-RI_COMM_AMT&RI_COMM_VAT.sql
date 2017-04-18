SET SERVEROUTPUT ON;

DECLARE
   v_ri_comm_amt   giac_cm_dm.ri_comm_amt%TYPE;

   v_ri_comm_vat   giac_cm_dm.ri_comm_vat%TYPE;

   v_count         NUMBER := 0;
BEGIN
   FOR rec IN (SELECT gacc_tran_id,
                      dv_tran_id,
                      memo_type,
                      memo_year,
                      memo_seq_no
                 FROM giac_cm_dm)
   LOOP
      SELECT SUM (comm_amt) ri_comm_amt, SUM (comm_vat) ri_comm_vat
        INTO v_ri_comm_amt, v_ri_comm_vat
        FROM giac_outfacul_prem_payts
       WHERE gacc_tran_id = rec.dv_tran_id AND cm_tag = 'Y';

      UPDATE giac_cm_dm
         SET ri_comm_amt = v_ri_comm_amt, ri_comm_vat = v_ri_comm_vat
       WHERE     gacc_tran_id = rec.gacc_tran_id
             AND dv_tran_id = rec.dv_tran_id
             AND memo_type = rec.memo_type
             AND memo_year = rec.memo_year
             AND memo_seq_no = rec.memo_seq_no;

      IF SQL%FOUND
      THEN
         v_count := v_count + 1;
      END IF;
   END LOOP;

   DBMS_OUTPUT.put_line (v_count || ' records udpated.');
   COMMIT;
END;