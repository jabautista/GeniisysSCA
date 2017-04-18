CREATE OR REPLACE PROCEDURE CPI.Tax_Default_Value_Type1 (
   P_TRAN_ID               IN     NUMBER,
   P_TRAN_TYPE             IN     NUMBER,
   P_ISS_CD                IN     VARCHAR2,
   P_PREM_SEQ_NO           IN     NUMBER,
   P_INST_NO               IN     NUMBER,
   P_FUND_CD               IN     VARCHAR2,
   P_PARAM_PREMIUM_AMT     IN     GIPI_INSTALLMENT.prem_amt%TYPE,
   P_COLLECTION_AMT        IN     GIPI_INSTALLMENT.prem_amt%TYPE,
   P_PREMIUM_AMT           IN OUT GIPI_INSTALLMENT.prem_amt%TYPE,
   P_TAX_AMT               IN OUT NUMBER,
   P_PREM_VAT_EXEMPT       IN OUT NUMBER,
   P_GIAC_TAX_COLLNS_CUR      OUT giac_tax_collns_pkg.rc_giac_tax_collns_cur)
IS
   /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
   **  then allocate tax collected amt to taxes other than VAT, balance
   **  should be allocated to ratio of original premium_amt and vat amount
   **  (vat amount must first be determined)
   */

   param_value_evat               GIAC_PARAMETERS.param_value_n%TYPE; --for evat
   v_max_inst_no                  GIPI_INSTALLMENT.inst_no%TYPE; --holds the no of installment
   v_balance_amt_due              GIPI_INSTALLMENT.prem_amt%TYPE;
   v_balance_due                  GIPI_INSTALLMENT.prem_amt%TYPE;
   v_tax_balance_due              GIPI_INSTALLMENT.tax_amt%TYPE;
   v_collection_amt               GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
   v_tax_inserted                 GIAC_TAX_COLLNS.tax_amt%TYPE;
   v_curr_rt                      GIPI_INVOICE.currency_rt%TYPE;
   v_tax_alloc                    GIPI_INV_TAX.tax_allocation%TYPE;
   SWITCH                         VARCHAR2 (1) := 'N';
   last_tax_inserted              GIPI_INV_TAX.tax_cd%TYPE;
   x                              NUMBER := 0;

   v_with_evat                    VARCHAR2 (1) := 'N';

   v_user                         VARCHAR2 (50) := NVL (giis_users_pkg.app_user, USER);

   v_colln_amt_less_prem_exempt   NUMBER := 0;

   v_diff                         NUMBER := 0;

   v_tot_bal_due                  giac_aging_soa_details.balance_amt_due%TYPE;
   
   /* Modified by Mikel 11.02.2015; UCPBGEN 20470
   ** Divide the tax amount to the total no. of installment before converting to local currency
   ** to tally with the local amount in the giac_aging_soa_details.
   */ 
   
   /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
   **  VAT will always be retrieved last
   */
   CURSOR c1
   IS
        SELECT A.iss_cd,
               A.prem_seq_no,
               A.tax_cd,
               --NVL (A.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               A.tax_allocation,
               b.fund_cd,
               A.line_cd,
               c.currency_rt
          FROM GIPI_INV_TAX A, GIAC_TAXES b, GIPI_INVOICE c
         WHERE     A.tax_cd = b.tax_cd
               AND A.iss_cd = c.iss_cd
               AND A.prem_seq_no = c.prem_seq_no
               AND A.iss_cd = p_iss_cd
               AND A.prem_seq_no = p_prem_seq_no
               AND b.fund_Cd = p_fund_cd
      ORDER BY A.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c2
   IS
        SELECT A.iss_cd,
               A.prem_seq_no,
               A.tax_cd,
               --NVL (A.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               A.tax_allocation,
               b.fund_cd,
               A.line_cd,
               c.currency_rt
          FROM GIPI_INV_TAX A, GIAC_TAXES b, GIPI_INVOICE c
         WHERE     A.tax_cd = b.tax_cd
               AND A.iss_cd = c.iss_cd
               AND A.prem_seq_no = c.prem_seq_no
               AND A.iss_cd = p_iss_cd
               AND A.prem_seq_no = p_prem_seq_no
               AND A.tax_cd != param_value_evat
               AND b.fund_Cd = p_fund_cd
      --ORDER BY a.tax_cd ASC, b.tax_type, b.priority_cd;
      ORDER BY b.priority_cd ASC; --mikel 11.13.2015; first payment should be allocated based on priority

   CURSOR c3
   IS
        SELECT A.iss_cd,
               A.prem_seq_no,
               A.tax_cd,
               --NVL (A.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               A.tax_allocation,
               b.fund_cd,
               A.line_cd,
               c.currency_rt,
               a.rate
          FROM GIPI_INV_TAX A, GIAC_TAXES b, GIPI_INVOICE c
         WHERE     A.tax_cd = b.tax_cd
               AND A.iss_cd = c.iss_cd
               AND A.prem_seq_no = c.prem_seq_no
               AND A.iss_cd = p_iss_cd
               AND A.prem_seq_no = p_prem_seq_no
               AND A.tax_cd = param_value_evat
               AND b.fund_Cd = p_fund_cd
      ORDER BY A.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c4 (
      P_TAX_CD NUMBER)
   IS
      SELECT SUM (NVL (A.tax_amt, 0)) tax_amt
        FROM GIAC_TAX_COLLNS A, GIAC_ACCTRANS b
       WHERE     A.gacc_tran_id = b.tran_id
             AND A.b160_iss_cd = p_iss_cd
             AND A.b160_prem_Seq_no = p_prem_Seq_no
             AND b.tran_flag != 'D'
             AND A.b160_tax_cd = p_tax_cd
             AND A.gacc_tran_id != p_tran_id
             AND A.inst_no = p_inst_no
             AND b.tran_id NOT IN
                    (SELECT aa.gacc_tran_id
                       FROM GIAC_REVERSALS aa, GIAC_ACCTRANS bb
                      WHERE     aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D');

   CURSOR c4a (
      P_TAX_CD NUMBER)
   IS
      SELECT SUM (NVL (A.tax_amt, 0)) tax_amt
        FROM GIAC_TAX_COLLNS A, GIAC_ACCTRANS b
       WHERE     A.gacc_tran_id = b.tran_id
             AND A.b160_iss_cd = p_iss_cd
             AND A.b160_prem_Seq_no = p_prem_Seq_no
             AND b.tran_flag != 'D'
             AND A.b160_tax_cd = p_tax_cd
             AND A.gacc_tran_id != p_tran_id
             --     AND    a.inst_no = p_inst_no
             AND b.tran_id NOT IN
                    (SELECT aa.gacc_tran_id
                       FROM GIAC_REVERSALS aa, GIAC_ACCTRANS bb
                      WHERE     aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D');

   CURSOR c5 (
      p_tax_alloc VARCHAR)
   IS
        SELECT A.iss_cd,
               A.prem_seq_no,
               A.tax_cd,
               --NVL (A.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               A.tax_allocation,
               b.fund_cd,
               A.line_cd,
               c.currency_rt,
               a.rate
          FROM GIPI_INV_TAX A, GIAC_TAXES b, GIPI_INVOICE c
         WHERE     A.tax_cd = b.tax_cd
               AND A.iss_cd = c.iss_cd
               AND A.prem_seq_no = c.prem_seq_no
               AND A.iss_cd = p_iss_cd
               AND A.prem_seq_no = p_prem_seq_no
               AND b.fund_Cd = p_fund_cd
               AND A.tax_allocation = p_tax_alloc
               AND A.tax_cd != param_value_evat
      ORDER BY A.tax_cd ASC, b.tax_type, b.priority_cd;

BEGIN
   FOR i
      IN (SELECT gacc_tran_id,
                 transaction_type,
                 b160_iss_cd,
                 b160_prem_seq_no,
                 inst_no
            FROM (SELECT gacc_tran_id,
                         transaction_type,
                         b160_iss_cd,
                         b160_prem_seq_no,
                         inst_no
                    FROM giac_tax_collns
                  MINUS
                  SELECT gacc_tran_id,
                         transaction_type,
                         b140_iss_cd,
                         b140_prem_seq_no,
                         inst_no
                    FROM giac_direct_prem_collns)
           WHERE     b160_iss_cd = p_iss_cd
                 AND b160_prem_seq_no = p_prem_seq_no
                 AND inst_no = p_inst_no
                 AND transaction_type = p_tran_type)
   LOOP
      DELETE FROM giac_tax_collns
            WHERE     gacc_tran_id = i.gacc_tran_id
                  AND b160_iss_cd = i.b160_iss_cd
                  AND b160_prem_seq_no = i.b160_prem_seq_no
                  AND inst_no = i.inst_no
                  AND transaction_type = i.transaction_type;
   END LOOP;

   DELETE FROM GIAC_TAX_COLLNS
         WHERE     gacc_tran_id = p_tran_id
               AND B160_iss_cd = p_iss_cd
               AND B160_prem_seq_no = p_prem_seq_no
               AND inst_no = p_inst_no
               AND transaction_type = p_tran_type;

   BEGIN
      SELECT param_value_n
        INTO param_value_evat
        FROM GIAC_PARAMETERS
       WHERE param_name LIKE 'EVAT';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         param_value_evat := NULL;
   END;

   /* to get the no of payments or inst_no */
   SELECT MAX (inst_no)
     INTO v_max_inst_no
     FROM GIPI_INSTALLMENT
    WHERE iss_cd = p_iss_Cd AND prem_Seq_no = p_prem_seq_no;

   --get total balance due
   SELECT balance_amt_due
     INTO v_tot_bal_due
     FROM giac_aging_soa_details
    WHERE     iss_cd = p_iss_cd
          AND prem_seq_no = p_prem_seq_no
          AND inst_no = p_inst_no;


   v_collection_amt := p_collection_amt;

   BEGIN
      SELECT DISTINCT tax_allocation
        INTO v_tax_alloc
        FROM GIPI_INV_TAX
       WHERE iss_cd = p_iss_cd AND prem_Seq_no = p_prem_Seq_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_tax_alloc := NULL;
      WHEN TOO_MANY_ROWS
      THEN
         v_tax_alloc := NULL;
   END;


   IF    (v_tax_alloc = 'F' AND p_inst_no != 1)
      OR (v_tax_alloc = 'L' AND p_inst_no != v_max_inst_no)
   THEN
      p_tax_amt := 0;
      p_premium_amt := p_collection_amt;

      IF p_prem_vat_exempt > p_collection_amt
      THEN
         p_prem_vat_exempt := p_collection_amt;
      ELSE
         p_premium_amt := p_collection_amt - p_prem_vat_exempt;
      END IF;
   END IF;



   IF    (v_tax_alloc = 'F' AND p_inst_no = 1)
      OR (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no)
      OR (v_tax_alloc = 'S')
   THEN
      v_collection_amt := p_collection_amt;

      FOR c1_rec IN c2
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt

            IF v_balance_due > v_collection_amt
            THEN
               v_balance_due := v_collection_amt;
            END IF;

            v_collection_amt := v_collection_amt - v_balance_due;

            INSERT INTO GIAC_TAX_COLLNS (GACC_TRAN_ID,
                                         TRANSACTION_TYPE,
                                         B160_ISS_CD,
                                         B160_PREM_SEQ_NO,
                                         B160_TAX_CD,
                                         TAX_AMT,
                                         FUND_CD,
                                         REMARKS,
                                         USER_ID,
                                         LAST_UPDATE,
                                         INST_NO)
                 VALUES (p_tran_id,
                         p_tran_type,
                         p_iss_cd,
                         p_prem_Seq_no,
                         c1_rec.tax_cd,
                         v_balance_due,
                         c1_rec.fund_cd,
                         NULL,
                         v_user,
                         SYSDATE,
                         p_inst_no);
         END LOOP rec;
      END LOOP c1_rec;
   END IF;

   IF v_tax_alloc IS NULL
   THEN
      /*
      **therefore there are mixed tax allocations in the bill
      **process everything the same as the normal process except for evat
      **the excess amount after the process should be allocated to evat 0
      */
      v_tax_inserted := 0;
      v_collection_amt := p_collection_amt;

      FOR c1_rec IN c2
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0);  --mikel 11.02.2015; added currency_rt

            IF v_balance_due > v_collection_amt
            THEN
               v_balance_due := v_collection_amt;
            END IF;

            IF    (c1_rec.tax_allocation = 'F' AND p_inst_no = 1)
               OR (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no)
            THEN
               IF v_balance_due > v_collection_amt
               THEN
                  v_balance_due := v_collection_amt;
               END IF;
            ELSIF    (c1_rec.tax_allocation = 'F' AND p_inst_no != 1)
                  OR (    c1_rec.tax_allocation = 'L'
                      AND p_inst_no != v_max_inst_no)
            THEN
               v_balance_due := 0;
            ELSIF c1_rec.tax_allocation = 'S'
            THEN
               v_balance_due :=
                    (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                  - NVL (rec.tax_amt, 0);

               IF p_inst_no = v_max_inst_no AND v_max_inst_no <> 1
               THEN
                  IF   (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                     * v_max_inst_no <> (c1_rec.tax_amt * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                  THEN
                     v_diff :=
                            (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                          * v_max_inst_no
                        - (c1_rec.tax_amt * c1_rec.currency_rt); --mikel 11.02.2015; added currency_rt
                     v_balance_due :=
                          (  (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                           - v_diff)
                        - NVL (rec.tax_amt, 0);
                  END IF;
               END IF;
            END IF;

            IF v_collection_amt != 0
            THEN
               v_collection_amt := v_collection_amt - v_balance_due;
            ELSE
               v_balance_due := 0;
            END IF;

            INSERT INTO GIAC_TAX_COLLNS (GACC_TRAN_ID,
                                         TRANSACTION_TYPE,
                                         B160_ISS_CD,
                                         B160_PREM_SEQ_NO,
                                         B160_TAX_CD,
                                         TAX_AMT,
                                         FUND_CD,
                                         REMARKS,
                                         USER_ID,
                                         LAST_UPDATE,
                                         INST_NO)
                 VALUES (p_tran_id,
                         p_tran_type,
                         p_iss_cd,
                         p_prem_Seq_no,
                         c1_rec.tax_cd,
                         v_balance_due,
                         c1_rec.fund_cd,
                         NULL,
                         v_user,
                         SYSDATE,
                         p_inst_no);
         END LOOP rec;
      END LOOP c1_rec;
   END IF;

   FOR c1_rec IN c3
   LOOP
      v_balance_due := 0;

      IF c1_rec.tax_amt != 0
      THEN
         switch := 'Y';

         IF c1_rec.tax_allocation = 'S'
         THEN
            FOR rec IN c4 (c1_rec.tax_cd)
            LOOP
               v_balance_due :=
                    (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                  - NVL (rec.tax_amt, 0)
                  + p_param_premium_amt;

               /* Adjust VAT to avoid discrepancy in computing premium and tax breakdown. */
               IF p_inst_no = v_max_inst_no AND v_max_inst_no <> 1
               THEN
                  IF   (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                     * v_max_inst_no <> (c1_rec.tax_amt) --mikel 11.02.2015; added currency_rt
                  THEN
                     v_diff :=
                            (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                          * v_max_inst_no
                        - (c1_rec.tax_amt * c1_rec.currency_rt) ; --mikel 11.02.2015; added currency_rt 
                     v_balance_due :=
                          (  (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                           - v_diff)
                        - NVL (rec.tax_amt, 0)
                        + p_param_premium_amt;
                  END IF;
               END IF;

               IF v_balance_due != 0
               THEN
                  IF SIGN (v_collection_amt - p_prem_vat_exempt) = -1
                  THEN
                     v_colln_amt_less_prem_exempt := 0;
                     p_prem_vat_exempt := v_collection_amt;
                  ELSIF SIGN (v_collection_amt - p_prem_vat_exempt) = 0
                  THEN
                     v_colln_amt_less_prem_exempt := 0;
                  ELSE
                     v_colln_amt_less_prem_exempt :=
                        v_collection_amt - p_prem_vat_exempt;
                  END IF;

                  v_balance_due :=
                       v_colln_amt_less_prem_exempt
                     * (  (  (  (ROUND ( (c1_rec.tax_amt / v_max_inst_no), 2)  * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                              - v_diff)
                           - NVL (rec.tax_amt, 0))
                        / v_balance_due);
               END IF;

               p_premium_amt :=
                    (v_colln_amt_less_prem_exempt - v_balance_due)
                  + p_prem_vat_exempt;

               p_tax_amt := p_collection_amt - p_premium_amt;
            END LOOP;
         ELSIF    (c1_rec.tax_allocation = 'F' AND p_inst_no = 1)
               OR (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no)
         THEN
            FOR rec IN c4 (c1_rec.tax_cd)
            LOOP
               p_premium_amt := v_collection_amt;

               IF v_collection_amt != 0
               THEN
                  v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt

                  /*allocate the balance to premum vat-exempt before VAT and premium vatabale*/
                  IF v_collection_amt >= p_prem_vat_exempt
                  THEN
                     v_colln_amt_less_prem_exempt :=
                        v_collection_amt - p_prem_vat_exempt;
                  ELSE
                     p_prem_vat_exempt := v_collection_amt;
                     v_colln_amt_less_prem_exempt := 0;
                  END IF;

                  IF v_colln_amt_less_prem_exempt >= v_balance_due
                  THEN
                     p_premium_amt :=
                          v_colln_amt_less_prem_exempt
                        - v_balance_due
                        + p_prem_vat_exempt;
                  ELSIF v_colln_amt_less_prem_exempt < v_balance_due
                  THEN
                     p_premium_amt := p_prem_vat_exempt;
                     v_balance_due := v_colln_amt_less_prem_exempt;
                  END IF;
               ELSE
                  p_prem_vat_exempt := 0;
                  v_balance_due := 0;
               END IF;

               p_tax_amt := p_collection_amt - p_premium_amt;
            END LOOP;
         ELSIF    (c1_rec.tax_allocation = 'F' AND p_inst_no != 1)
               OR (c1_rec.tax_allocation = 'L' AND p_inst_no != v_max_inst_no)
         THEN
            v_balance_due := 0;

            /*allocate the balance to premum vat-exempt before VAT and premium vatabale*/
            IF v_collection_amt >= p_prem_vat_exempt
            THEN
               v_colln_amt_less_prem_exempt :=
                  v_collection_amt - p_prem_vat_exempt;
            ELSE
               p_prem_vat_exempt := v_collection_amt;
               v_colln_amt_less_prem_exempt := 0;
            END IF;

            IF v_colln_amt_less_prem_exempt >= v_balance_due
            THEN
               p_premium_amt :=
                    v_colln_amt_less_prem_exempt
                  - v_balance_due
                  + p_prem_vat_exempt;
            ELSIF v_colln_amt_less_prem_exempt < v_balance_due
            THEN
               p_premium_amt := p_prem_vat_exempt;
               v_balance_due := v_colln_amt_less_prem_exempt;
            END IF;

            p_tax_amt := p_collection_amt - p_premium_amt;
         END IF;
      END IF;

      INSERT INTO GIAC_TAX_COLLNS (GACC_TRAN_ID,
                                   TRANSACTION_TYPE,
                                   B160_ISS_CD,
                                   B160_PREM_SEQ_NO,
                                   B160_TAX_CD,
                                   TAX_AMT,
                                   FUND_CD,
                                   REMARKS,
                                   USER_ID,
                                   LAST_UPDATE,
                                   INST_NO)
           VALUES (p_tran_id,
                   p_tran_type,
                   p_iss_cd,
                   p_prem_Seq_no,
                   c1_rec.tax_cd,
                   v_balance_due,
                   c1_rec.fund_cd,
                   NULL,
                   v_user,
                   SYSDATE,
                   p_inst_no);
   END LOOP;

   --no VAT
   IF SWITCH != 'Y'
   THEN
      p_premium_amt := v_collection_amt;
      p_tax_amt := p_collection_amt - p_premium_amt;
      p_prem_vat_exempt := p_premium_amt;
   END IF;

   OPEN P_GIAC_TAX_COLLNS_CUR FOR
      SELECT gtc.gacc_tran_id,
             gtc.transaction_type,
             gtc.b160_iss_cd,
             gtc.b160_prem_seq_no,
             gtc.b160_tax_cd,
             gtc.inst_no,
             gtc.fund_cd,
             gtc.tax_amt,
             gt.tax_name
        FROM giac_tax_collns gtc, giac_taxes gt
       WHERE     gtc.gacc_tran_id = p_tran_id
             AND gtc.b160_iss_cd = p_iss_cd
             AND gtc.b160_prem_seq_no = p_prem_seq_no
             AND gtc.inst_no = p_inst_no
             AND gt.tax_cd = gtc.b160_tax_cd;
END;
/