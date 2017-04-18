DROP PROCEDURE CPI.CHECK_COMMISSION;

CREATE OR REPLACE PROCEDURE CPI.check_commission (
   p_tran_id                giac_order_of_payts.gacc_tran_id%TYPE,
   p_cancel_flag   IN OUT   VARCHAR2
)
IS
   v_iss_cd          VARCHAR2 (2);                              -- rad 120309
   v_prem_seq_no     NUMBER;                                    -- rad 120309
   v_x_totdpc        NUMBER;                                    -- rad 120309
   v_y_totdpc        NUMBER;                                    -- rad 120309
   v_z_totdpc        NUMBER;                                    -- rad 120309
   v_cp_ctr          NUMBER;                                    -- rad 120309
   v_ocp_ctr         NUMBER;                                    -- rad 120309
   v_x_spoildpc      NUMBER;                                    -- rad 120309
   v_y_spoildpc      NUMBER;                                    -- rad 120309
   v_z_spoildpc      NUMBER;                                    -- rad 120309
   v_cp_tran_flag    NUMBER;                                    -- rad 120309
   v_ocp_tran_flag   NUMBER;                                    -- rad 120309
   v_reversal        NUMBER;                                    -- rad 120309
   v_cancel_flag     VARCHAR2 (1);                              -- rad 120309
BEGIN
   p_cancel_flag := 'N';

   FOR y IN (SELECT DISTINCT b140_iss_cd, b140_prem_seq_no
                        FROM giac_direct_prem_collns
                       WHERE gacc_tran_id = p_tran_id)
   LOOP
      v_y_totdpc := NVL (v_y_totdpc, 0) + 1;
      v_iss_cd := y.b140_iss_cd;
      v_prem_seq_no := y.b140_prem_seq_no;

      FOR x IN (SELECT DISTINCT gacc_tran_id, b140_iss_cd, b140_prem_seq_no
                           FROM giac_direct_prem_collns
                          WHERE gacc_tran_id != p_tran_id
                            AND b140_iss_cd = v_iss_cd
                            AND b140_prem_seq_no = v_prem_seq_no)
      LOOP
         v_x_totdpc := NVL (v_x_totdpc, 0) + 1;

         SELECT COUNT (*)
           INTO v_cp_ctr
           FROM giac_comm_payts
          WHERE gacc_tran_id = x.gacc_tran_id
            AND iss_cd = x.b140_iss_cd
            AND prem_seq_no = x.b140_prem_seq_no;

         SELECT COUNT (*)
           INTO v_ocp_ctr
           FROM giac_ovride_comm_payts
          WHERE gacc_tran_id = x.gacc_tran_id
            AND iss_cd = x.b140_iss_cd
            AND prem_seq_no = x.b140_prem_seq_no;

         IF    (v_cp_ctr = 0 AND v_ocp_ctr > 0)
            OR (v_cp_ctr > 0 AND v_ocp_ctr = 0)
            OR (v_cp_ctr > 0 AND v_ocp_ctr > 0)
         THEN
            v_x_spoildpc := NVL (v_x_spoildpc, 0) + 1;
         END IF;
      END LOOP;

      /* Checks if the iss_cd, and prem_seq_no match those in GIAC_COMM_PAYTS and GIAC_OVRIDE_COMM_PAYTS.
      ** Proceeds with cancel if all match and proceeds to CONDITION 2 if they don't.
      */
      IF     (v_x_totdpc > v_x_spoildpc)
         AND (v_x_totdpc IS NOT NULL AND v_x_spoildpc IS NOT NULL)
      THEN
         FOR z IN (SELECT DISTINCT gacc_tran_id, b140_iss_cd,
                                   b140_prem_seq_no
                              FROM giac_direct_prem_collns
                             WHERE gacc_tran_id != p_tran_id
                               AND b140_iss_cd = v_iss_cd
                               AND b140_prem_seq_no = v_prem_seq_no)
         LOOP
            v_z_totdpc := NVL (v_z_totdpc, 0) + 1;

            SELECT COUNT (*)
              INTO v_cp_tran_flag
              FROM giac_acctrans a, giac_comm_payts b
             WHERE gacc_tran_id = z.gacc_tran_id
               AND a.tran_id = b.gacc_tran_id
               AND iss_cd = z.b140_iss_cd
               AND prem_seq_no = z.b140_prem_seq_no
               AND tran_flag != 'D';

            SELECT COUNT (*)
              INTO v_ocp_tran_flag
              FROM giac_acctrans a, giac_ovride_comm_payts b
             WHERE gacc_tran_id = z.gacc_tran_id
               AND a.tran_id = b.gacc_tran_id
               AND iss_cd = z.b140_iss_cd
               AND prem_seq_no = z.b140_prem_seq_no
               AND tran_flag != 'D';

            SELECT COUNT (*)
              INTO v_reversal
              FROM giac_order_of_payts
             WHERE gacc_tran_id = p_tran_id
               AND gacc_tran_id NOT IN (SELECT gacc_tran_id
                                          FROM giac_reversals);

            IF (v_cp_tran_flag > 0 OR v_ocp_tran_flag > 0) AND v_reversal > 0
            THEN
               v_z_spoildpc := NVL (v_z_spoildpc, 0) + 1;
            END IF;
         END LOOP;

         /* Checks if the corresponding tran_id is not equal to 'D' and if gacc_tran_id does not exist in GIAC_REVERSALS.
         ** If both are satisfied it prompts the user to cancel the commission payment first before proceeding.
         */
         IF v_z_totdpc = NVL (v_z_spoildpc, 0)
         THEN
            v_y_spoildpc := NVL (v_y_spoildpc, 0) + 1;
         END IF;
      ELSE
         v_y_spoildpc := NVL (v_y_spoildpc, 0) + 1;
      END IF;
   END LOOP;

   IF v_y_totdpc != NVL (v_y_spoildpc, 0)
   THEN
      p_cancel_flag := 'N';
   ELSE
      p_cancel_flag := 'Y';
   END IF;
END;
/


