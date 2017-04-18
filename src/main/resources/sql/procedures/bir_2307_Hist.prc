/*
** Created by   : Paolo J. Santos
** Date Created : 12.27.2016
** Reference By : GIACS0022
** Description  : BIR 2307 for printing */
CREATE OR REPLACE PROCEDURE cpi.bir_2307_Hist (
      p_tran_id     IN   NUMBER,
      p_item_no     IN   VARCHAR2,
      p_user        IN   VARCHAR2)
   AS
      v_exists         VARCHAR2 (1)  := 'N'; --checks tran_id in GIAC_PRINTED_BIR2307_HIST
      v_exists2        VARCHAR2 (1)  := 'N'; --checks tax_id in GIAC_PRINTED_BIR2307_HIST for that tran_id.
      v_print_seq_no   NUMBER;
      v_bir_tax_cd     VARCHAR2 (10);
      v_percent_rate   NUMBER;
      v_hist_no        NUMBER:=0;
   BEGIN
      FOR i IN
         (SELECT   SUM (income_amt) income_amt,
                   SUM (wholding_tax_amt) wholding_tax_amt, payee_cd,
                   payee_class_cd, gwtx_whtax_id
              FROM giac_taxes_wheld
             WHERE gacc_tran_id = p_tran_id
               AND item_no IN (SELECT COLUMN_VALUE
                                 FROM TABLE (split_comma_separated (p_item_no)))
          GROUP BY payee_cd, payee_class_cd, gwtx_whtax_id)
      LOOP
         BEGIN
            SELECT 'Y'
              INTO v_exists
              FROM giac_printed_bir2307_hist
             WHERE gacc_tran_id = p_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exists := 'N';
            WHEN TOO_MANY_ROWS 
            THEN
               v_exists := 'Y';
         END;

         BEGIN
            SELECT bir_tax_cd, percent_rate
              INTO v_bir_tax_cd, v_percent_rate
              FROM giac_wholding_taxes
             WHERE whtax_id = i.gwtx_whtax_id;
          EXCEPTION
            WHEN NO_DATA_FOUND
                THEN
              raise_application_error (-20001,
                                  'Error in saving history. No set up found in withholding tax maintenance for this particular tax code.');
         END;
         
         BEGIN
         SELECT NVL(MAX(BIR_HIST_NO),0) + 1
           INTO v_hist_no
           FROM giac_printed_bir2307_hist;
         END;

         IF v_exists = 'Y'
         THEN
            BEGIN
               SELECT 'Y'
                 INTO v_exists2
                 FROM giac_printed_bir2307_hist
                WHERE gacc_tran_id = p_tran_id
                  AND gwtx_whtax_id = i.gwtx_whtax_id
                  AND payee_cd = i.payee_cd
                  AND payee_class_cd = i.payee_class_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_exists2 := 'N';
            END; 

            IF v_exists2 = 'Y'
            THEN
               SELECT print_seq_no + 1
                 INTO v_print_seq_no
                 FROM giac_printed_bir2307_hist
                WHERE gacc_tran_id = p_tran_id
                  AND gwtx_whtax_id = i.gwtx_whtax_id
                  AND payee_cd = i.payee_cd
                  AND payee_class_cd = i.payee_class_cd;

               UPDATE giac_printed_bir2307_hist
                  SET print_seq_no = v_print_seq_no,
                      income_amt = i.income_amt,
                      bir_tax_cd = v_bir_tax_cd,
                      wholding_tax_amt = i.wholding_tax_amt,
                      whtax_rt = v_percent_rate,
                      user_id = p_user,
                      last_update = SYSDATE
                WHERE gacc_tran_id = p_tran_id
                  AND payee_cd = i.payee_cd
                  AND payee_class_cd = i.payee_class_cd
                  AND gwtx_whtax_id = i.gwtx_whtax_id;

            ELSE
               INSERT INTO giac_printed_bir2307_hist
                           (bir_hist_no, gacc_tran_id, payee_cd, payee_class_cd,
                            gwtx_whtax_id, print_seq_no, bir_tax_cd,
                            whtax_rt, income_amt,
                            wholding_tax_amt, user_id, last_update
                           )
                    VALUES (v_hist_no,p_tran_id, i.payee_cd, i.payee_class_cd,
                            i.gwtx_whtax_id, 1, v_bir_tax_cd,
                            v_percent_rate, i.income_amt,
                            i.wholding_tax_amt, p_user, SYSDATE
                           );
            END IF;
         ELSE
            INSERT INTO giac_printed_bir2307_hist
                        (bir_hist_no, gacc_tran_id, payee_cd, payee_class_cd,
                         gwtx_whtax_id, print_seq_no, bir_tax_cd, whtax_rt,
                         income_amt, wholding_tax_amt, user_id,
                         last_update
                        )
                 VALUES (v_hist_no, p_tran_id, i.payee_cd, i.payee_class_cd,
                         i.gwtx_whtax_id, 1, v_bir_tax_cd, v_percent_rate,
                         i.income_amt, i.wholding_tax_amt, p_user,
                         SYSDATE
                        );
         END IF;
      END LOOP;
END;
/
CREATE OR REPLACE PUBLIC SYNONYM BIR_2307_HIST FOR CPI.BIR_2307_HIST;