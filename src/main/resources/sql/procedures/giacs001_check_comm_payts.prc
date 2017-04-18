CREATE OR REPLACE PROCEDURE CPI.giacs001_check_comm_payts (p_gacc_tran_id IN NUMBER
)
IS
   v_exist         VARCHAR2 (1)    := 'N';
   v_sign          NUMBER;
   v_child_sign    NUMBER;
   v_child_sign2    NUMBER; --added by gab 09.21.2016 SR 22252
   v_parent_sign   NUMBER;
   v_bill_nos      VARCHAR2 (2000);                                                                            --mikel 08.16.2012
   v_ref_nos       VARCHAR2 (2000);                                                                            --mikel 08.16.2012
   v_net_comm      VARCHAR(1) := 'N';       --added by albert 03.13.2017 (FGIC SR 23447)
   v_comm_exists   NUMBER;                                                                                     --mikel 08.16.2012
BEGIN
   FOR yy IN (SELECT DISTINCT b140_iss_cd, b140_prem_seq_no
                         FROM giac_direct_prem_collns
                        WHERE gacc_tran_id = p_gacc_tran_id
                     ORDER BY b140_iss_cd, b140_prem_seq_no)
   LOOP
      SELECT SIGN (prem_amt + tax_amt)
        INTO v_sign
        FROM gipi_invoice
       WHERE iss_cd = yy.b140_iss_cd AND prem_seq_no = yy.b140_prem_seq_no;
       
       --added by albert 03.13.2017 (FGIC SR 23447 - check if OR being cancelled is net of comm) 
      FOR z IN (SELECT 'X'
                  FROM giac_comm_payts
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND iss_cd = yy.b140_iss_cd
                   AND prem_seq_no = yy.b140_prem_seq_no)
      LOOP
        v_net_comm := 'Y';
        EXIT;
      END LOOP;
      --end albert 03.13.2017

      FOR child_exist IN (SELECT gacc_tran_id
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
                             AND a.iss_cd = yy.b140_iss_cd
                             AND a.prem_seq_no = yy.b140_prem_seq_no
                             AND a.gacc_tran_id > p_gacc_tran_id)
      LOOP
         v_exist := 'Y';
         v_bill_nos := yy.b140_iss_cd || '-' || LPAD (yy.b140_prem_seq_no, 12, 0) || ', ' || v_bill_nos;
         v_ref_nos :=
               v_ref_nos
            || CHR (13)
            || yy.b140_iss_cd
            || '-'
            || LPAD (yy.b140_prem_seq_no, 12, 0)
            || ' '
            || get_ref_no (child_exist.gacc_tran_id);
      END LOOP;

      FOR parent_exist IN (SELECT gacc_tran_id
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
                              AND a.iss_cd = yy.b140_iss_cd
                              AND a.prem_seq_no = yy.b140_prem_seq_no
                              AND a.gacc_tran_id > p_gacc_tran_id)
      LOOP
         v_exist := 'Y';

         IF INSTR (NVL (v_bill_nos, 'MIKELRAZON'), yy.b140_iss_cd || '-' || LPAD (yy.b140_prem_seq_no, 12, 0), 1) = 0
         THEN
            v_bill_nos := yy.b140_iss_cd || '-' || LPAD (yy.b140_prem_seq_no, 12, 0) || ', ' || v_bill_nos;
         END IF;

         v_ref_nos :=
               v_ref_nos
            || CHR (13)
            || yy.b140_iss_cd
            || '-'
            || LPAD (yy.b140_prem_seq_no, 12, 0)
            || ' '
            || get_ref_no (parent_exist.gacc_tran_id);
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
               AND NOT EXISTS (SELECT 'X'
                                 FROM giac_reversals x, giac_acctrans y
                                WHERE x.reversing_tran_id = y.tran_id AND y.tran_flag <> 'D' AND x.gacc_tran_id = a.gacc_tran_id)
               AND a.iss_cd = yy.b140_iss_cd
               AND a.prem_seq_no = yy.b140_prem_seq_no
--               AND a.gacc_tran_id >= p_gacc_tran_id; --edited by gab 09.21.2016 SR 22252
               AND a.gacc_tran_id > p_gacc_tran_id;
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
               AND NOT EXISTS (SELECT 'X'
                                 FROM giac_reversals x, giac_acctrans y
                                WHERE x.reversing_tran_id = y.tran_id AND y.tran_flag <> 'D' AND x.gacc_tran_id = a.gacc_tran_id)
               AND a.iss_cd = yy.b140_iss_cd
               AND a.prem_seq_no = yy.b140_prem_seq_no
--               AND a.gacc_tran_id >= p_gacc_tran_id; --edited by gab 09.21.2016 SR 22252
               AND a.gacc_tran_id > p_gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
         
         --added by gab 09.21.2016 SR 22252
         IF v_child_sign = 0
         THEN
            SELECT SIGN (SUM (comm_amt))
              INTO v_child_sign2
              FROM giac_comm_payts a, giac_acctrans b
             WHERE 1 = 1
               AND a.gacc_tran_id = b.tran_id
               AND b.tran_flag <> 'D'
               AND NOT EXISTS (SELECT 'X'
                                 FROM giac_reversals x, giac_acctrans y
                                WHERE x.reversing_tran_id = y.tran_id AND y.tran_flag <> 'D' AND x.gacc_tran_id = a.gacc_tran_id)
               AND a.iss_cd = yy.b140_iss_cd
               AND a.prem_seq_no = yy.b140_prem_seq_no
               AND a.gacc_tran_id >= p_gacc_tran_id;
               
            IF v_child_sign2 = 1
            THEN
                v_child_sign := NULL;
            END IF;
         
         END IF;

         IF v_sign = v_child_sign OR v_sign = v_parent_sign
         THEN
            v_comm_exists := 1;
         ELSIF (v_child_sign = 0 OR v_parent_sign = 0)  --added condition by gab 09.21.2016 SR 22252
           AND v_net_comm = 'Y' --added by albert (FGIC SR 23447 - check if OR to be cancelled is net of comm)
         THEN
            v_comm_exists := 2;
         ELSE
            v_comm_exists := 0;
         END IF;
      ELSE
         v_comm_exists := 0;
      END IF;
   END LOOP;

   IF v_comm_exists = 1
   THEN
      raise_application_error (-20001,
                                  'Geniisys Exception#I#The commission of bill no/s. '
                               || SUBSTR (v_bill_nos, 1, INSTR (v_bill_nos, ',', -1) - 1)
                               || ' was already settled. '
                               || 'Please cancel the commission payment first before cancelling the O.R.'
                               || CHR (13)
                               || CHR (13)
                               || 'Reference No.: '
                               || CHR (13)
                               || v_ref_nos
                              );
   ELSIF v_comm_exists = 2 --added condition by gab 09.21.2016 SR 22252
   THEN
      raise_application_error (-20001,
                                  'Geniisys Exception#I#The commission of bill no/s. '
                               || SUBSTR (v_bill_nos, 1, INSTR (v_bill_nos, ',', -1) - 1)
                               || ' was already reversed. '
                               || 'Please cancel the reversal first before cancelling the O.R.'
                               || CHR (13)
                               || CHR (13)
                               || 'Reference No.: '
                               || CHR (13)
                               || v_ref_nos
                              );
   END IF;
END;
/


