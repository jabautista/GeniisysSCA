DROP PROCEDURE CPI.VAL_AMT_BEFORE_CLOSING;

CREATE OR REPLACE PROCEDURE CPI.val_amt_before_closing (
   p_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
   p_grqd_payt_amt   giac_payt_requests_dtl.payt_amt%TYPE
)
IS
   v_exists       giac_acct_entries.gacc_tran_id%TYPE;
   v_sum_debit    NUMBER (24, 2);
   v_sum_credit   NUMBER (24, 2);
   v_tot_amt      giac_payt_requests_dtl.payt_amt%TYPE;
BEGIN
   FOR a1 IN (SELECT gacc_tran_id
                FROM giac_acct_entries
               WHERE gacc_tran_id = p_tran_id)
   LOOP
      v_exists := a1.gacc_tran_id;
      EXIT;
   END LOOP;

   IF v_exists IS NULL
   THEN
      raise_application_error
         (-20001,
          'Geniisys Exception#E#Please enter transaction details first. Press DR Details to display the transaction screens'
         );
   ELSE
      BEGIN
         SELECT NVL (SUM (debit_amt), 0), NVL (SUM (credit_amt), 0)
           INTO v_sum_debit, v_sum_credit
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_tran_id;

         v_tot_amt := v_sum_debit - v_sum_credit;

         IF NVL (v_tot_amt, 0) = 0
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Total transaction amount should not be equal to zero.'
               );
         ELSIF NVL (v_tot_amt, 0) < 0
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Total transaction amount should have a positive debit amount.'
               );
         ELSIF NVL (v_tot_amt, 0) > 0
         THEN
            IF NVL (v_tot_amt, 0) <> NVL (p_grqd_payt_amt, 0)
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Disbursement Request Amount does not match total transaction amount.'
                  );
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Credit/debit amounts not found. Please see sysdtem administrator.'
               );
      END;
   END IF;
END;
/


