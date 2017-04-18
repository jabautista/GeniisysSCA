CREATE OR REPLACE PROCEDURE CPI.check_comm_payts2 (
   p_gacc_tran_id   IN       NUMBER,
   p_iss_cd         IN       VARCHAR2,
   p_prem_seq_no    IN       NUMBER,
   p_bill_nos       IN OUT   VARCHAR2,
   p_ref_nos        IN OUT   VARCHAR2,
   p_exist          IN OUT   NUMBER
)
IS
   v_exist         VARCHAR2 (1) := 'N';
   v_sign          NUMBER;
   v_child_sign    NUMBER;
   v_parent_sign   NUMBER;
BEGIN
   SELECT SIGN (prem_amt + tax_amt)
     INTO v_sign
     FROM gipi_invoice
    WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;

   p_bill_nos := p_iss_cd || '-' || LPAD (p_prem_seq_no, 12, 0); --moved by reymon 08162013
   
   FOR child_exist IN (SELECT DISTINCT gacc_tran_id --added distinct reymon 08162013
                         FROM giac_comm_payts a, giac_acctrans b
                        WHERE 1 = 1
                          AND a.gacc_tran_id = b.tran_id
                          AND b.tran_flag <> 'D'
                          AND NOT EXISTS (
                                 SELECT 'X'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag <> 'D'
                                    AND x.gacc_tran_id = a.gacc_tran_id)
                          AND a.iss_cd = p_iss_cd
                          AND a.prem_seq_no = p_prem_seq_no
                          AND a.gacc_tran_id > p_gacc_tran_id)
   LOOP
      v_exist := 'Y';
      /* commented out and changed by reymon 08162013
      p_bill_nos := p_iss_cd || '-' || LPAD (p_prem_seq_no, 12, 0) || ', '|| p_bill_nos;
      p_ref_nos := p_ref_nos || CHR (13) || p_iss_cd || '-' || LPAD (p_prem_seq_no, 12, 0) || ' ' || get_ref_no (child_exist.gacc_tran_id);
      */
      p_ref_nos := p_ref_nos || CHR (13) || get_ref_no (child_exist.gacc_tran_id);
   END LOOP;

   FOR parent_exist IN
      (SELECT DISTINCT gacc_tran_id --added distinct reymon 08162013
         FROM giac_ovride_comm_payts a, giac_acctrans b
        WHERE 1 = 1
          AND a.gacc_tran_id = b.tran_id
          AND b.tran_flag <> 'D'
          AND NOT EXISTS (
                 SELECT 'X'
                   FROM giac_reversals x, giac_acctrans y
                  WHERE x.reversing_tran_id = y.tran_id
                    AND y.tran_flag <> 'D'
                    AND x.gacc_tran_id = a.gacc_tran_id)
          AND a.iss_cd = p_iss_cd
          AND a.prem_seq_no = p_prem_seq_no
          AND a.gacc_tran_id > p_gacc_tran_id)
   LOOP
      v_exist := 'Y';
      /* commented out and changed by reymon 08162013
      IF instr(NVL(p_bill_nos, 'MIKELRAZON'), p_iss_cd || '-' || LPAD (p_prem_seq_no, 12, 0), 1) = 0 THEN
        p_bill_nos := p_iss_cd || '-' || LPAD (p_prem_seq_no, 12, 0) || ', ' || p_bill_nos;
      END IF;
      p_ref_nos := p_ref_nos || CHR (13) || p_iss_cd || '-' || LPAD (p_prem_seq_no, 12, 0)|| ' ' || get_ref_no (parent_exist.gacc_tran_id);
      */
      p_ref_nos := p_ref_nos || CHR (13) || get_ref_no (parent_exist.gacc_tran_id);      
   END LOOP;

   IF v_exist = 'Y'
   THEN
      BEGIN
         SELECT SIGN (SUM (comm_amt))
           INTO v_child_sign
           FROM giac_comm_payts a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND b.tran_flag <> 'D'
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giac_reversals x, giac_acctrans y
                    WHERE x.reversing_tran_id = y.tran_id
                      AND y.tran_flag <> 'D'
                      AND x.gacc_tran_id = a.gacc_tran_id)
            AND a.iss_cd = p_iss_cd
            AND a.prem_seq_no = p_prem_seq_no
            AND a.gacc_tran_id > p_gacc_tran_id;  --modified by John Daniel SR-5182; previous: AND a.gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT SIGN (SUM (comm_amt))
           INTO v_parent_sign
           FROM giac_ovride_comm_payts a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND b.tran_flag <> 'D'
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giac_reversals x, giac_acctrans y
                    WHERE x.reversing_tran_id = y.tran_id
                      AND y.tran_flag <> 'D'
                      AND x.gacc_tran_id = a.gacc_tran_id)
            AND a.iss_cd = p_iss_cd
            AND a.prem_seq_no = p_prem_seq_no
            AND a.gacc_tran_id > p_gacc_tran_id;  --modified by John Daniel SR-5182; previous: AND a.gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF v_sign = v_child_sign OR v_sign = v_parent_sign
      THEN
         p_exist := 1;
      --added by albert 11.20.2015: consider cancellation of transactions with existing reversals 
      ELSIF v_child_sign = 0 OR v_parent_sign = 0 THEN
         p_exist := 2;
      --end albert 11.20.2015
      ELSE
         p_exist := 0;
      END IF;
   ELSE
      p_exist := 0;
   END IF;
END;
/