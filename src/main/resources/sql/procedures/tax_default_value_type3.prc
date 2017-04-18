DROP PROCEDURE CPI.TAX_DEFAULT_VALUE_TYPE3;

CREATE OR REPLACE PROCEDURE CPI.tax_default_value_type3 (
   p_tran_id               IN       NUMBER,
   p_tran_type             IN       NUMBER,
   p_iss_cd                IN       VARCHAR2,
   p_prem_seq_no           IN       NUMBER
                                          --,P_USER_ID               IN VARCHAR2
                                          --,P_LAST_UPDATE           IN DATE
,
   p_inst_no               IN       NUMBER,
   p_fund_cd               IN       VARCHAR2                  --global.fund_cd
                                            ,
   p_param_premium_amt     IN       NUMBER             --PARAMETER.PREMIUM_AMT
                                          ,
   p_collection_amt        IN       NUMBER               --gdpc.collection_amt
                                          ,
   p_premium_amt           IN OUT   NUMBER                  --gdpc.premium_amt
                                          ,
   p_tax_amt               IN OUT   NUMBER,
   p_prem_vat_exempt       IN OUT   NUMBER         --added by alfie 09.21.2011
                                          ,
   p_giac_tax_collns_cur   OUT      giac_tax_collns_pkg.rc_giac_tax_collns_cur
--added by alfie: 10.24.2010
)
IS
   /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
   **  then allocate tax collected amt to taxes other than EVAT, balance
   **  should be allocated to ratio of original premium_amt and evat amount
   **  (evat amount must first be determined)
   */

   /* Modified by: Mikel
   ** Date modified: 12.06.2012
   ** Modifications: Compute EVAT based on tax_allocation
   */

   param_value_evat               giac_parameters.param_value_n%TYPE;
   --for evat
   v_max_inst_no                  gipi_installment.inst_no%TYPE;
   --holds the no of installment
   v_balance_amt_due              gipi_installment.prem_amt%TYPE;
   v_balance_due                  gipi_installment.prem_amt%TYPE;
   v_tax_balance_due              gipi_installment.tax_amt%TYPE;
   v_collection_amt               giac_direct_prem_collns.collection_amt%TYPE;
   v_tax_inserted                 giac_tax_collns.tax_amt%TYPE;
   v_curr_rt                      gipi_invoice.currency_rt%TYPE;
   v_tax_alloc                    gipi_inv_tax.tax_allocation%TYPE;
   SWITCH                         VARCHAR2 (1)                         := 'N';
   v_colln_amt_less_prem_exempt   NUMBER                                 := 0;

   v_diff NUMBER := 0; --mikel 12.06.2012
   v_tot_bal_due   giac_aging_soa_details.balance_amt_due%TYPE; --mikel 12.06.2012

   /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
   **  evat will always be retrieved last
   */
   CURSOR c1
   IS
      SELECT   a.iss_cd, a.prem_seq_no, a.tax_cd,
               --NVL (a.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               a.tax_allocation, b.fund_cd, a.line_cd, c.currency_rt
          FROM gipi_inv_tax a, giac_taxes b, gipi_invoice c
         WHERE a.tax_cd = b.tax_cd
           AND a.iss_cd = c.iss_cd
           AND a.prem_seq_no = c.prem_seq_no
           AND a.iss_cd = p_iss_cd
           AND a.prem_seq_no = p_prem_seq_no
           AND b.fund_cd = p_fund_cd
      ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c2
   IS
      SELECT   a.iss_cd, a.prem_seq_no, a.tax_cd,
               --NVL (a.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               a.tax_allocation, b.fund_cd, a.line_cd, c.currency_rt
          FROM gipi_inv_tax a, giac_taxes b, gipi_invoice c
         WHERE a.tax_cd = b.tax_cd
           AND a.iss_cd = c.iss_cd
           AND a.prem_seq_no = c.prem_seq_no
           AND a.iss_cd = p_iss_cd
           AND a.prem_seq_no = p_prem_seq_no
           AND a.tax_cd != param_value_evat
           AND b.fund_cd = p_fund_cd
      --ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;
      ORDER BY b.priority_cd ASC; --mikel 11.13.2015; first payment should be allocated based on priority

   CURSOR c3
   IS
      SELECT   a.iss_cd, a.prem_seq_no, a.tax_cd,
               --NVL (a.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               a.tax_allocation, b.fund_cd, a.line_cd, c.currency_rt
          FROM gipi_inv_tax a, giac_taxes b, gipi_invoice c
         WHERE a.tax_cd = b.tax_cd
           AND a.iss_cd = c.iss_cd
           AND a.prem_seq_no = c.prem_seq_no
           AND a.iss_cd = p_iss_cd
           AND a.prem_seq_no = p_prem_seq_no
           AND a.tax_cd = param_value_evat
           AND b.fund_cd = p_fund_cd
      ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c4 (p_tax_cd NUMBER)
   IS
      SELECT SUM (NVL (a.tax_amt, 0)) tax_amt
        FROM giac_tax_collns a, giac_acctrans b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND a.inst_no = p_inst_no
         AND b.tran_id NOT IN (
                SELECT aa.gacc_tran_id
                  FROM giac_reversals aa, giac_acctrans bb
                 WHERE aa.reversing_tran_id = bb.tran_id
                   AND bb.tran_flag != 'D');

   CURSOR c4a (p_tax_cd NUMBER)
   IS
      SELECT SUM (NVL (a.tax_amt, 0)) tax_amt
        FROM giac_tax_collns a, giac_acctrans b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
--     AND    a.inst_no = p_inst_no
         AND b.tran_id NOT IN (
                SELECT aa.gacc_tran_id
                  FROM giac_reversals aa, giac_acctrans bb
                 WHERE aa.reversing_tran_id = bb.tran_id
                   AND bb.tran_flag != 'D');

   CURSOR c5 (p_tax_alloc VARCHAR)
   IS
      SELECT   a.iss_cd, a.prem_seq_no, a.tax_cd,
               --NVL (a.tax_amt, 0) * NVL (c.currency_rt, 1) tax_amt,
               NVL (A.tax_amt, 0) tax_amt, --mikel 11.02.2015;
               a.tax_allocation, b.fund_cd, a.line_cd, c.currency_rt
          FROM gipi_inv_tax a, giac_taxes b, gipi_invoice c
         WHERE a.tax_cd = b.tax_cd
           AND a.iss_cd = c.iss_cd
           AND a.prem_seq_no = c.prem_seq_no
           AND a.iss_cd = p_iss_cd
           AND a.prem_seq_no = p_prem_seq_no
           AND b.fund_cd = p_fund_cd
           AND a.tax_allocation = p_tax_alloc
           AND a.tax_cd != param_value_evat
      ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;
BEGIN
--MESSAGE('TAX_DEFAULT_VALUE_type3');
--MESSAGE('TAX_DEFAULT_VALUE_type3');
--MESSAGE('parameter.collection_amt :  '|| to_char(:parameter.collection_amt));
--MESSAGE('parameter.premium_amt :  '|| to_char(:parameter.premium_amt));
--MESSAGE('parameter.tax_amt :  '|| to_char(:parameter.tax_amt));
   DELETE FROM giac_tax_collns
         WHERE gacc_tran_id = p_tran_id
           AND b160_iss_cd = p_iss_cd
           AND b160_prem_seq_no = p_prem_seq_no
           AND inst_no = p_inst_no
           AND transaction_type = p_tran_type;

   BEGIN
      SELECT param_value_n
        INTO param_value_evat
        FROM giac_parameters
       WHERE param_name LIKE 'EVAT';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         param_value_evat := NULL;
   END;

   /* to get the no of payments or inst_no */
   SELECT MAX (inst_no)
     INTO v_max_inst_no
     FROM gipi_installment
    WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;

   /* to get currency_rt for bill */
   SELECT DISTINCT currency_rt
              INTO v_curr_rt
              FROM gipi_invoice
             WHERE iss_cd = p_iss_cd
             AND prem_seq_no = p_prem_seq_no;

   --get total balance due -- mikel 12.06.2012
   SELECT balance_amt_due
     INTO v_tot_bal_due
     FROM giac_aging_soa_details
    WHERE iss_cd = p_iss_cd
      AND prem_seq_no = p_prem_seq_no
      AND inst_no = p_inst_no;

   v_curr_rt := NVL (v_curr_rt, 1);
   v_collection_amt := p_collection_amt;

   BEGIN
      SELECT DISTINCT tax_allocation
                 INTO v_tax_alloc
                 FROM gipi_inv_tax
                WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
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
   END IF;

   IF    (v_tax_alloc = 'F' AND p_inst_no = 1)
      OR (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no)
   THEN
      v_collection_amt := p_collection_amt;

      FOR c1_rec IN c2
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt

            IF ABS (v_balance_due) > ABS (v_collection_amt)
            THEN
               v_balance_due := v_collection_amt;
            END IF;

-- jfactor 04/04/2011 : added code for assigning values for the paramters p_premium_amt and p_tax_amt
-- when (v_tax_alloc = 'F' AND p_inst_no = 1) OR (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no)
-- -------------------------------------------------------------------------------------------------
            p_premium_amt := v_collection_amt - v_balance_due;
            p_tax_amt := p_collection_amt - p_premium_amt;
-- -------------------------------------------------------------------------------------------------

            --jfactor 04/11/2011 : placed the code for changing the value of v_collection_amount from before assigning
            --values to p_prem_amount and p_tax_amount to after assigning value to p_premium_amt and p_tax_amt, this is done
            --to correct the inconsistency in values of premium amount and withholding tax in the GIACS020 (DV >> Direct
            --Trans >> Commission Payments)  and GIACS211 (Bill Inquiry) -- FLT PRF 6610
            v_collection_amt := v_collection_amt - v_balance_due; 

            INSERT INTO giac_tax_collns
                        (gacc_tran_id, transaction_type, b160_iss_cd,
                         b160_prem_seq_no, b160_tax_cd, tax_amt,
                         fund_cd, remarks, user_id, last_update, inst_no
                        )
                 VALUES (p_tran_id, p_tran_type, p_iss_cd,
                         p_prem_seq_no, c1_rec.tax_cd, v_balance_due,
                         c1_rec.fund_cd, NULL, USER, SYSDATE, p_inst_no
                        );
         END LOOP rec;
      END LOOP c1_rec;
   --     FOR c1_rec IN c3 LOOP  --for evat only
   -- SWITCH := 'Y';  --jason 1/20/2009: check if there is evat
   --       FOR rec IN c4 (c1_rec.tax_cd) LOOP
   --          v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(REC.tax_amt,0) + p_param_premium_amt;
   --          IF v_balance_due != 0 THEN
   --            v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0)) / v_balance_due);
   --          END IF;
   --          IF ABS(v_balance_due) > ABS(NVL(c1_rec.tax_amt,0) - NVL(REC.tax_amt,0)) THEN
   --            v_balance_due := v_collection_amt;
   --          END IF;
   --          p_premium_amt := v_collection_amt - v_balance_due;
   --          p_tax_amt := p_collection_amt - p_premium_amt;
   --          INSERT INTO giac_tax_collns
   --            (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
   --             B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
   --             B160_TAX_CD                    ,TAX_AMT                        ,
   --             FUND_CD                        ,REMARKS                        ,
   --             USER_ID                        ,LAST_UPDATE                    ,
   --             INST_NO                        )
   --          VALUES
   --            (p_tran_id                      ,p_tran_type                    ,
   --             p_iss_cd                       ,p_prem_Seq_no                  ,
   --            c1_rec.tax_cd                  ,v_balance_due                  ,
   --             c1_rec.fund_cd                 ,NULL                           ,
   --             user                     ,sysdate                   ,
   --             p_inst_no                      );
   --       END LOOP rec;
   --     END LOOP c1_rec;

   -- --jason 1/20/2009 start: without evat
   -- IF SWITCH != 'Y' THEN
   --         p_premium_amt := v_collection_amt;
   --         p_tax_amt := p_collection_amt - p_premium_amt;
   --       END IF;
    --jaosn 1/20/2009 end--
   END IF;

   IF v_tax_alloc = 'S'
   THEN
      -- paano kung 1000 collected amount, total tax for that
      -- inst is 1000 including evat... should i pay the full
      -- amount for the other taxes??? and the eg. 100 left
      -- be divided proportionately to the premium and evat
      -- tapus the next time bayad siya check first kung fully
      -- paid na ung other taxes...????
      v_collection_amt := p_collection_amt;              --new collection_amt
      /* only processes taxes other that evat first */
      v_tax_inserted := 0;                                   --to inititalize
      v_tax_balance_due := 0;

      FOR c1_rec IN c2
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            /** receivable **/
            v_tax_balance_due :=
                 v_tax_balance_due
               + ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
               - NVL (rec.tax_amt, 0);
         END LOOP rec;
      END LOOP c1_rec;

      IF v_tax_balance_due != 0
      THEN
         FOR c1_rec IN c2
         LOOP
            FOR rec IN c4 (c1_rec.tax_cd)
            LOOP
               v_balance_due :=
                    v_collection_amt
                  * (  (  ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                        - NVL (rec.tax_amt, 0)
                       )
                     / v_tax_balance_due
                    );

               IF ABS (v_balance_due) >
                     ABS (  ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                          - NVL (rec.tax_amt, 0)
                         )
               THEN
                          --v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - nvl(rec.tax_amt,0);
                  --Vincent 061005: replaced the formula for v_balance_due with the select stmt below,
                  --to correct the error in amounts inserted for tax
                  SELECT   DECODE (p_inst_no,
                                   v_max_inst_no, DECODE
                                            (v_max_inst_no,
                                             1, (NVL (c1_rec.tax_amt, 0) * c1_rec.currency_rt), --mikel 11.02.2015; added currency_rt
                                               (  (NVL (c1_rec.tax_amt, 0) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                                                - (  (ROUND
                                                        (  NVL
                                                              (c1_rec.tax_amt,
                                                               0
                                                              ) 
                                                         / v_max_inst_no,
                                                         2
                                                        ) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                                                   * v_max_inst_no
                                                  )
                                               )
                                             + (ROUND (  NVL (c1_rec.tax_amt,
                                                             0)
                                                      / v_max_inst_no,
                                                      2
                                                     ) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                                            ),
                                   ((NVL (c1_rec.tax_amt, 0) / v_max_inst_no) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                                  ) 
                         - NVL (rec.tax_amt, 0)
                    INTO v_balance_due
                    FROM DUAL;
               --**vfm**--
               END IF;

               IF ABS (v_balance_due + v_tax_inserted) >
                                                        ABS (v_collection_amt)
               THEN
                  v_balance_due := v_collection_amt - v_tax_inserted;
               END IF;

               INSERT INTO giac_tax_collns
                           (gacc_tran_id, transaction_type, b160_iss_cd,
                            b160_prem_seq_no, b160_tax_cd, tax_amt,
                            fund_cd, remarks, user_id, last_update, inst_no
                           )
                    VALUES (p_tran_id, p_tran_type, p_iss_cd,
                            p_prem_seq_no, c1_rec.tax_cd, v_balance_due,
                            c1_rec.fund_cd, NULL, USER, SYSDATE, p_inst_no
                           );

               v_tax_inserted := v_tax_inserted + v_balance_due;
            END LOOP rec;
         END LOOP c1_rec;
      END IF;

      v_collection_amt := v_collection_amt - v_tax_inserted;
   --     FOR c1_rec IN c3 LOOP
   --       SWITCH := 'Y';
   --       FOR rec IN c4 (c1_rec.tax_cd) LOOP
   --         v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_param_premium_amt;
   --         IF v_balance_due != 0 THEN
   --            v_balance_due := v_collection_amt * ABS(((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) / v_balance_due);
   --         END IF;
   --         IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
   --            v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
   --         END IF;
   --         p_premium_amt := v_collection_amt - v_balance_due;
   --         p_tax_amt := p_collection_amt - p_premium_amt;
   --         INSERT INTO giac_tax_collns
   --              (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
   --               B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
   --               B160_TAX_CD                    ,TAX_AMT                        ,
   --               FUND_CD                        ,REMARKS                        ,
   --               USER_ID                        ,LAST_UPDATE                    ,
   --               INST_NO                        )
   --         VALUES
   --              (p_tran_id                      ,p_tran_type                    ,
   --               p_iss_cd                       ,p_prem_Seq_no                  ,
   --               c1_rec.tax_cd                  ,v_balance_due                  ,
   --               c1_rec.fund_cd                 ,NULL                           ,
   --               user                      ,sysdate                  ,
   --               p_inst_no                      );
   --       END LOOP rec;
   --     END LOOP c1_rec;
   --     IF SWITCH != 'Y' THEN
   --         p_premium_amt := v_collection_amt;
   --         p_tax_amt := p_collection_amt - p_premium_amt;
   --     END IF;
   END IF;                                            --v_tax_alloc = 'S' then

   IF v_tax_alloc IS NULL
   THEN
      /*
      **therefore there are mixed tax allocations in the bill
      **process everything the same as the normal process except for evat
      **the excess amount after the process should be allocated to evat 0
      */
      v_tax_inserted := 0;
      v_collection_amt := p_collection_amt;

      FOR c1_rec IN c5 ('F')
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt)  - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt

            IF ABS (v_balance_due) > ABS (v_collection_amt)
            THEN
               v_balance_due := v_collection_amt;
            END IF;

            IF p_inst_no != 1
            THEN
               v_balance_due := 0;
            END IF;

            v_collection_amt := v_collection_amt - v_balance_due;

            INSERT INTO giac_tax_collns
                        (gacc_tran_id, transaction_type, b160_iss_cd,
                         b160_prem_seq_no, b160_tax_cd, tax_amt,
                         fund_cd, remarks, user_id, last_update, inst_no
                        )
                 VALUES (p_tran_id, p_tran_type, p_iss_cd,
                         p_prem_seq_no, c1_rec.tax_cd, v_balance_due,
                         c1_rec.fund_cd, NULL, USER, SYSDATE, p_inst_no
                        );
         END LOOP rec;
      END LOOP c1_rec;                                               --for 'F'

      v_tax_balance_due := 0;
      v_tax_inserted := 0;

      FOR c1_rec IN c5 ('S')
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            v_tax_balance_due :=
                      ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt
         END LOOP rec;
      END LOOP c1_rec;

      IF v_tax_balance_due != 0
      THEN
         FOR c1_rec IN c5 ('S')
         LOOP
            FOR rec IN c4 (c1_rec.tax_cd)
            LOOP
               v_balance_due :=
                    v_collection_amt
                  * (  (  ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                        - NVL (rec.tax_amt, 0)
                       )
                     / v_tax_balance_due
                    );

               IF ABS (v_balance_due) >
                     ABS (  ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) --mikel 11.02.2015; added currency_rt
                          - NVL (rec.tax_amt, 0)
                         )
               THEN
                  v_balance_due :=
                      ((c1_rec.tax_amt / v_max_inst_no) * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt
               END IF;

               IF ABS (v_balance_due + v_tax_inserted) >
                                                        ABS (v_collection_amt)
               THEN
                  v_balance_due := v_collection_amt - v_tax_inserted;
               END IF;

               INSERT INTO giac_tax_collns
                           (gacc_tran_id, transaction_type, b160_iss_cd,
                            b160_prem_seq_no, b160_tax_cd, tax_amt,
                            fund_cd, remarks, user_id, last_update, inst_no
                           )
                    VALUES (p_tran_id, p_tran_type, p_iss_cd,
                            p_prem_seq_no, c1_rec.tax_cd, v_balance_due,
                            c1_rec.fund_cd, NULL, USER, SYSDATE, p_inst_no
                           );

               v_tax_inserted := v_tax_inserted + v_balance_due;
            END LOOP;
         END LOOP c1_rec;
      END IF;

      v_collection_amt := v_collection_amt - v_tax_inserted;

      FOR c1_rec IN c5 ('L')
      LOOP
         FOR rec IN c4 (c1_rec.tax_cd)
         LOOP
            IF p_inst_no != v_max_inst_no
            THEN
               v_balance_due := 0;
            ELSE
               v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt

               IF ABS (v_balance_due) > ABS (v_collection_amt)
               THEN
                  v_balance_due := v_collection_amt;
               END IF;

               v_collection_amt := v_collection_amt - v_balance_due;


               INSERT INTO giac_tax_collns
                           (gacc_tran_id, transaction_type, b160_iss_cd,
                            b160_prem_seq_no, b160_tax_cd, tax_amt,
                            fund_cd, remarks, user_id, last_update, inst_no
                           )
                    VALUES (p_tran_id, p_tran_type, p_iss_cd,
                            p_prem_seq_no, c1_rec.tax_cd, v_balance_due,
                            c1_rec.fund_cd, NULL, USER, SYSDATE, p_inst_no
                           );
            END IF;
         END LOOP rec;
      END LOOP c1_rec;
    --     FOR c1_rec IN c3 LOOP
    --       SWITCH := 'Y'; --to check if bill has evat
    --       IF (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) OR
    --          (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no) THEN
    --         FOR rec IN c4a (c1_rec.tax_cd) LOOP
    --           v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0) + p_param_premium_amt;
    --           IF v_balance_due != 0 THEN
    --             v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0))/v_balance_due);
    --           END IF;
    --           p_premium_amt := v_collection_amt - v_balance_due;
    --           p_tax_amt := p_collection_amt - p_premium_amt;
    --         END LOOP rec;
    --       ELSIF c1_rec.tax_allocation = 'S' THEN
    --         FOR rec IN c4 (c1_rec.tax_cd) LOOP
    --           v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_param_premium_amt;
    --           IF v_balance_due != 0 THEN
    --             v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_balance_due);
    --           END IF;
    --           p_premium_amt := v_collection_amt - v_balance_due;
    --           p_tax_amt := p_collection_amt - p_premium_amt;
    --         END LOOP rec;
   --        END IF;
    --         INSERT INTO giac_tax_collns
    --              (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
    --               B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
    --               B160_TAX_CD                    ,TAX_AMT                        ,
    --               FUND_CD                        ,REMARKS                        ,
    --               USER_ID                        ,LAST_UPDATE                    ,
    --               INST_NO                        )
    --       VALUES
    --              (p_tran_id                      ,p_tran_type                    ,
    --              p_iss_cd                       ,p_prem_Seq_no                  ,
    --               c1_rec.tax_cd                  ,v_balance_due                  ,
    --               c1_rec.fund_cd                 ,NULL                           ,
    --               user                          ,sysdate                 ,
    --               p_inst_no                      );
    --     END LOOP c1_rec;
    --     IF SWITCH != 'Y' THEN --no evat
    --       p_premium_amt := v_collection_amt;
    --       p_tax_amt := p_collection_amt - p_premium_amt;
    --     END IF;
   END IF;                                              --v_tax_alloc is  null

   FOR c1_rec IN c3
   LOOP
      IF c1_rec.tax_amt != 0 --mikel 02.07.2012; added condition to check if bill is not zero-rated.
      THEN
         SWITCH := 'Y';                           --to check if bill has evat

        IF c1_rec.tax_allocation = 'S' THEN --mikel 12.06.2012
             FOR rec IN c4a (c1_rec.tax_cd)
             LOOP
                v_balance_due :=
                       (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0) --mikel 11.02.2015; added currency_rt
                       + p_param_premium_amt;

                /* Mikel 12.06.2012
                ** Adjust EVAT to avoid discrepancy in computing premium and tax breakdown.
                */
                IF p_inst_no = v_max_inst_no THEN
                  IF v_max_inst_no <> 1 THEN
                    IF (ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt) * v_max_inst_no <> (c1_rec.tax_amt * c1_rec.currency_rt) THEN --mikel 11.02.2015; added currency_rt
                       v_diff := (ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt) * v_max_inst_no - (c1_rec.tax_amt * c1_rec.currency_rt); --mikel 11.02.2015; added currency_rt
                       v_balance_due := ((ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt) - v_diff) - (NVL(rec.tax_amt,0) * c1_rec.currency_rt) + p_param_premium_amt; --mikel 11.02.2015; added currency_rt
                    ELSE
                      v_balance_due := (ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt)  - (NVL(rec.tax_amt,0) * c1_rec.currency_rt) + p_param_premium_amt; --mikel 11.02.2015; added currency_rt
                    END IF;
                  ELSE
                      v_balance_due := (ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt) - (NVL(rec.tax_amt,0) * c1_rec.currency_rt) + p_param_premium_amt; --mikel 11.02.2015; added currency_rt
                  END IF;
                ELSE
                  v_balance_due := (ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt) - (NVL(rec.tax_amt,0) * c1_rec.currency_rt) + p_param_premium_amt; --mikel 11.02.2015; added currency_rt
                END IF; --mikel 12.06.2012

                IF v_balance_due != 0
                THEN
                   IF SIGN (ABS (v_collection_amt) - ABS (p_prem_vat_exempt)) = -1
                   THEN
                      v_colln_amt_less_prem_exempt := 0;
                      p_prem_vat_exempt := v_collection_amt;
                   ELSIF SIGN (ABS (v_collection_amt) - ABS (p_prem_vat_exempt)) = 0
                   THEN
                      v_colln_amt_less_prem_exempt := 0;
                   ELSE
                      v_colln_amt_less_prem_exempt := v_collection_amt - p_prem_vat_exempt;
                   END IF;

                   --v_balance_due := v_colln_amt_less_prem_exempt * ((c1_rec.tax_amt - NVL (rec.tax_amt, 0)) / v_balance_due); --comment out by mikel 12.06.2012
                   v_balance_due := v_colln_amt_less_prem_exempt * ((((ROUND((c1_rec.tax_amt/v_max_inst_no),2) * c1_rec.currency_rt) - v_diff) - (NVL(rec.tax_amt,0) * c1_rec.currency_rt))/v_balance_due); --mikel 12.06.2012 --mikel 11.02.2015; added currency_rt
                END IF;
                    p_premium_amt := (v_colln_amt_less_prem_exempt - v_balance_due) + p_prem_vat_exempt;
                    p_tax_amt := p_collection_amt - p_premium_amt;
             END LOOP rec;
        ELSIF    (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) --mikel 12.06.2012
               OR (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no
                  ) THEN
            FOR rec IN c4 (c1_rec.tax_cd)
            LOOP
               v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt) - NVL (rec.tax_amt, 0); --mikel 11.02.2015; added currency_rt
               IF ABS(v_collection_amt) > 0 THEN  --ABS function added by Sam 03.25.2014
                  IF ABS(v_balance_due) != 0 THEN --ABS function added by Sam 03.25.2014
                  
                     IF SIGN (ABS(v_collection_amt) - ABS(p_prem_vat_exempt)) = -1 THEN
                        v_colln_amt_less_prem_exempt := 0;
                        p_prem_vat_exempt := v_collection_amt;
                     ELSIF SIGN (ABS(v_collection_amt) - ABS(p_prem_vat_exempt)) = 0 THEN
                        v_colln_amt_less_prem_exempt := 0;
                     ELSE
                        v_colln_amt_less_prem_exempt :=
                        v_collection_amt - p_prem_vat_exempt;
                     END IF;

                     IF v_tot_bal_due = v_collection_amt THEN
                        p_premium_amt := (v_colln_amt_less_prem_exempt - v_balance_due) + p_prem_vat_exempt;
                        p_tax_amt := p_collection_amt - p_premium_amt;
                     ELSIF v_tot_bal_due <> p_collection_amt THEN
                        IF ABS(v_collection_amt) <= ABS(v_balance_due) THEN
                           v_balance_due := v_collection_amt;
                           p_premium_amt := 0 + p_prem_vat_exempt;
                           p_tax_amt := p_collection_amt - p_premium_amt;
                        ELSE
                           p_premium_amt := (v_colln_amt_less_prem_exempt - v_balance_due) + p_prem_vat_exempt;
                           p_tax_amt := p_collection_amt - p_premium_amt;
                        END IF;
                     ELSIF v_tot_bal_due = p_collection_amt THEN --added by Sam 03.25.2014
                        p_premium_amt := (v_colln_amt_less_prem_exempt - v_balance_due) + p_prem_vat_exempt;
                        p_tax_amt := p_collection_amt - p_premium_amt;   
                     END IF;
                  END IF;
               ELSIF v_collection_amt = 0
               THEN
                  v_balance_due := 0;
                  p_premium_amt := 0;
                  p_tax_amt := p_collection_amt - p_premium_amt;
               END IF;
            END LOOP;
        END IF;  --end mikel 12.06.2012

       --mikel 02.07.2012; added codes below to insert correct amount for evat in giac_tax_collns
      ELSIF (c1_rec.tax_amt * c1_rec.currency_rt) = 0 --bill is zero-rated --mikel 11.02.2015; added currency_rt
      THEN
         v_balance_due := (c1_rec.tax_amt * c1_rec.currency_rt); --mikel 11.02.2015; added currency_rt
      END IF;  --end mikel 02.07.2012

      INSERT INTO giac_tax_collns
                  (gacc_tran_id, transaction_type, b160_iss_cd,
                   b160_prem_seq_no, b160_tax_cd, tax_amt,
                   fund_cd, remarks, user_id, last_update, inst_no
                  )
           VALUES (p_tran_id, p_tran_type, p_iss_cd,
                   p_prem_seq_no, c1_rec.tax_cd, v_balance_due,
                   c1_rec.fund_cd, NULL, USER, SYSDATE, p_inst_no
                  );
   END LOOP;

   IF SWITCH != 'Y'
   THEN                                                              --no evat
      p_premium_amt := v_collection_amt;
      p_tax_amt := p_collection_amt - p_premium_amt;
      p_prem_vat_exempt := p_premium_amt;         --added by alfie 09.23.2011
   END IF;

   --added by alfie 10.24.2010: to fetch out the selected records to webpage (JSON variable)
   OPEN p_giac_tax_collns_cur FOR
      SELECT gtc.gacc_tran_id, gtc.transaction_type, gtc.b160_iss_cd,
             gtc.b160_prem_seq_no, gtc.b160_tax_cd, gtc.inst_no, gtc.fund_cd,
             gtc.tax_amt, gt.tax_name
        FROM giac_tax_collns gtc, giac_taxes gt
       WHERE gtc.gacc_tran_id = p_tran_id
         AND gtc.b160_iss_cd = p_iss_cd
         AND gtc.b160_prem_seq_no = p_prem_seq_no
         AND gtc.inst_no = p_inst_no
         AND gt.tax_cd = gtc.b160_tax_cd;
END;
/