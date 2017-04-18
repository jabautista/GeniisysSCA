DROP PROCEDURE CPI.DO_PAYTERM_COMPUTATION;

CREATE OR REPLACE PROCEDURE CPI.do_payterm_computation (
   p_version        IN   VARCHAR2 DEFAULT '1',
   p_nbt_due_date   IN   VARCHAR2,
   p_par_id         IN   NUMBER,
   p_line_cd        IN   VARCHAR2
)
IS
   pv_date_sw              VARCHAR2 (1);
   pv_date_sw1             VARCHAR2 (1);
   pv_last_due_date_sc     gipi_winstallment.due_date%TYPE;
   pv_last_due_date        gipi_winstallment.due_date%TYPE;
   p_msg_alert             VARCHAR2 (100);
   v_tax_amt1              gipi_winstallment.tax_amt%TYPE     := 0;
   v_tax_amt2              gipi_winstallment.tax_amt%TYPE     := 0;
   v_tax_amt3              gipi_winstallment.tax_amt%TYPE     := 0;
   counter                 NUMBER                             := 0;
   var_no_of_payt          giis_payterm.no_of_payt%TYPE;
   var_inst_no             gipi_winstallment.inst_no%TYPE     := 0;
   var_share_pct           gipi_winstallment.share_pct%TYPE   := 0;
   v_share_pct_due         gipi_winstallment.share_pct%TYPE;
   var_prem_amt            gipi_winstallment.prem_amt%TYPE    := 0;
   v_prem_amt_due          gipi_winstallment.prem_amt%TYPE;
   var_due_date            DATE     := TO_DATE (p_nbt_due_date, 'mm-dd-rrrr');
   v_tot_dist_prem         NUMBER;
   v_tot_tax_amt           NUMBER;
   v_diff_tax_amt          NUMBER;
   v_diff_cents            NUMBER;
   v_tot_share_pct         NUMBER;
   v_diff_pct              NUMBER;
   var_tax_amt_due         gipi_winstallment.tax_amt%TYPE     := 0;
   var_ini_tax_amt         NUMBER;
   v_pol_period            NUMBER;
   v_interval              NUMBER;
   v_incept_date           gipi_wpolbas.incept_date%TYPE;
   v_expiry_date           gipi_wpolbas.expiry_date%TYPE;
   v_on_incept_tag         giis_payterm.on_incept_tag%TYPE;
   v_no_of_days            NUMBER;            
   v_no_of_payment         NUMBER;
   v_policy_days           NUMBER;
   v_no_payt_days          NUMBER;
   v_no_of_days_again      NUMBER;
   v_exact_no_of_payment   NUMBER;        --used for computation of intervals
--*********************
   v_is_longterm           BOOLEAN                            := FALSE;
   -----------------------------------------------------added by glyza 04.10.08
   v_count                 NUMBER;                        --number of takeups
   v_variable              VARCHAR2 (1)                       := 'N';       --
   v_exist                 VARCHAR2 (1)                       := 'N';       --
   v_old_incept_date       gipi_wpolbas.incept_date%TYPE;
                                                   --incept date gipi_wpolbas
   v_old_expiry_date       gipi_wpolbas.expiry_date%TYPE;
                                                   --expiry_date gipi_wpolbas
BEGIN
/*added by glyza 04.10.08*/
---------------------------------------
   FOR x IN (SELECT MAX (takeup_seq_no) takeup_seq
               FROM gipi_winvoice
              WHERE par_id = p_par_id)
   LOOP
      v_count := x.takeup_seq;
   END LOOP;

   IF v_count > 1
   THEN
      v_variable := 'Y';
   END IF;

----------------------------------------
   FOR l IN (SELECT eff_date, endt_expiry_date, expiry_date
               FROM gipi_wpolbas
              WHERE par_id = p_par_id)
   LOOP                                 ------------------------------------ L
      IF l.endt_expiry_date IS NULL
      THEN
         v_expiry_date := l.expiry_date;
         v_incept_date := l.eff_date;
         v_old_expiry_date := l.expiry_date;
                                         -------------added by glyza 04.10.08
         v_old_incept_date := l.eff_date;
                                         -------------added by glyza 04.10.08
      ELSE
         v_expiry_date := l.endt_expiry_date;
         v_incept_date := l.eff_date;
         v_old_expiry_date := l.endt_expiry_date;
                                         -------------added by glyza 04.10.08
         v_old_incept_date := l.eff_date;
                                         -------------added by glyza 04.10.08
      END IF;

      EXIT;
   END LOOP;                            ------------------------------------ L

   FOR s IN (SELECT   a.no_of_days, a.no_of_payt, a.annual_sw,
                      a.on_incept_tag, a.no_payt_days, b.prem_amt,
                      b.other_charges, b.due_date, b.item_grp,
                      b.takeup_seq_no, b.payt_terms
                 FROM giis_payterm a, gipi_winvoice b
                WHERE b.par_id = p_par_id AND a.payt_terms = b.payt_terms
             ORDER BY b.item_grp, b.takeup_seq_no)
   LOOP                                 ------------------------------------ S
/*added by glyza 04.10.08*/
  ---------------------------------------
      IF v_variable = 'Y'
      THEN
         FOR y IN (SELECT takeup_seq_no, due_date
                     FROM gipi_winvoice
                    WHERE par_id = p_par_id
                      AND takeup_seq_no = s.takeup_seq_no + 1)
         LOOP
            v_exist := 'Y';
            v_incept_date := s.due_date;
            v_expiry_date := y.due_date;
         END LOOP;

         IF v_exist = 'N'
         THEN
            v_expiry_date := v_old_expiry_date;
         END IF;
      END IF;

----------------------------------------
      IF s.takeup_seq_no > 1
      THEN
         v_is_longterm := TRUE;
      END IF;

      BEGIN
         SELECT COUNT (*)
           INTO counter
           FROM gipi_winstallment
          WHERE par_id = p_par_id
            AND item_grp = s.item_grp
            AND takeup_seq_no = s.takeup_seq_no;

         IF counter > 0
         THEN
            pv_date_sw := 'N';
         ELSE
            pv_date_sw := 'Y';
         END IF;
      END;

      --reset
      v_tax_amt1 := 0;
      v_tax_amt2 := 0;
      v_tax_amt3 := 0;
      var_share_pct := 0;
      var_prem_amt := 0;
      var_tax_amt_due := 0;
      v_no_of_payment := 0;
      -- SET VARIABLES TO BE USED --
      v_no_of_days := NVL (s.no_of_days, 0);

      IF NVL (s.on_incept_tag, 'N') = 'N'
      THEN
         v_no_of_days_again := 0;
      ELSE
         v_no_of_days_again := NVL (s.no_of_days, 0);
      END IF;

      var_no_of_payt := s.no_of_payt;
      v_no_payt_days := s.no_payt_days;

      IF TRUNC (v_expiry_date - v_incept_date) = 31
      THEN
         v_policy_days := 30;
      ELSE
         v_policy_days := TRUNC (v_expiry_date - v_incept_date);
      END IF;

/*      --Computation for v_no_of_payment is for cases when policy duration is less than a year
    --however the no_of_payment as defined from the table is based on 1 year.
    --1.):v_no_of_payment == represents the number of payments to be made as evaluated
    --                       against v_duration and mode/terms of payment
    --2.)var_no_of_payt   == means the no_of_payments to be made (depending on ANNUAL_SW;
    --                       (if annual_sw = Y then no_of_payments is based yearly otherwise the
    --                       no. of payments defined on the maintenance should follow.)
    --3.)v_duration       == represents the number of months between the eff_date and expiry_date of the endorsement
*/
      IF NVL (s.annual_sw, 'N') = 'N'
      THEN
         IF v_no_payt_days IS NOT NULL
         THEN
            IF v_no_payt_days < v_policy_days - v_no_of_days
            THEN
               IF v_no_payt_days < var_no_of_payt
               THEN
                  v_no_of_payment := v_no_payt_days;
               ELSE
                  v_no_of_payment := var_no_of_payt;
               END IF;
            ELSE
               IF v_policy_days - v_no_of_days < var_no_of_payt
               THEN
                  v_no_of_payment := v_policy_days - v_no_of_days;
               ELSE
                  v_no_of_payment :=
                     ROUND (  ((v_policy_days - v_no_of_days) * var_no_of_payt
                              )
                            / v_no_payt_days
                           );
               END IF;
            END IF;

            v_exact_no_of_payment := v_no_of_payment;
         ELSE
            IF v_policy_days - v_no_of_days < var_no_of_payt
            THEN
               v_no_of_payment := v_policy_days - v_no_of_days;
            ELSE
               v_no_of_payment := var_no_of_payt;
            END IF;
         END IF;
      ELSE
         IF TRUNC ((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt >
               TRUNC (  TRUNC ((v_policy_days - v_no_of_days) / 365, 2)
                      * var_no_of_payt
                     )
         THEN
            v_no_of_payment :=
                 TRUNC (  TRUNC ((v_policy_days - v_no_of_days) / 365, 3)
                        * var_no_of_payt
                       )
               + 1;
         ELSE
            v_no_of_payment :=
               TRUNC (  TRUNC ((v_policy_days - v_no_of_days) / 365, 3)
                      * var_no_of_payt
                     );
         END IF;

         IF TRUNC ((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt <
                                                                             1
         THEN
            v_exact_no_of_payment := 1;
         ELSE
            v_exact_no_of_payment :=
                 TRUNC ((v_policy_days - v_no_of_days) / 365, 4)
               * var_no_of_payt;
         END IF;
      END IF;

      IF v_no_of_payment < 1
      THEN
         v_no_of_payment := 1;
      END IF;

      var_share_pct := TRUNC (100 / v_no_of_payment, 2);
      v_tot_share_pct := (var_share_pct * v_no_of_payment);
      v_diff_pct := 100 - v_tot_share_pct;
      var_prem_amt :=
         ROUND (((s.prem_amt + NVL (s.other_charges, 0)) / v_no_of_payment),
                2
               );
      v_tot_dist_prem := var_prem_amt * v_no_of_payment;
      v_diff_cents := s.prem_amt + NVL (s.other_charges, 0) - v_tot_dist_prem;
      v_pol_period := ((v_expiry_date - v_incept_date) + ROUND (1));
      v_interval := ROUND ((v_pol_period / 30) / s.no_of_payt);

      IF p_version = '1'
      THEN
         IF pv_date_sw = 'Y' OR NVL (pv_date_sw1, 'Y') = 'Y'
         THEN
            DELETE      gipi_winstallment
                  WHERE par_id = p_par_id
                    AND item_grp = s.item_grp
                    AND takeup_seq_no = s.takeup_seq_no;
         END IF;
      END IF;

      FOR a IN (SELECT tax_amt, tax_allocation
                  FROM gipi_winv_tax
                 WHERE par_id = p_par_id
                   AND item_grp = s.item_grp
                   AND takeup_seq_no = s.takeup_seq_no
                   AND tax_cd != (SELECT param_value_n
                                    FROM giis_parameters
                                   WHERE param_name = 'OTHER_CHARGES_CODE'))
                                                    --ADDED BY CRIS 03/16/2010
      LOOP                           ------------------------------------ S->A
         IF a.tax_allocation = 'F'
         THEN
            v_tax_amt1 := v_tax_amt1 + a.tax_amt;
         ELSIF a.tax_allocation = 'S'
         THEN
            v_tax_amt2 := v_tax_amt2 + a.tax_amt;
         ELSIF a.tax_allocation = 'L'
         THEN
            v_tax_amt3 := v_tax_amt3 + a.tax_amt;
         END IF;
      END LOOP;                      ------------------------------------ S->A

      IF v_tax_amt2 IS NOT NULL
      THEN
         var_ini_tax_amt := ROUND ((v_tax_amt2 / v_no_of_payment), 2);
         v_tot_tax_amt := var_ini_tax_amt * v_no_of_payment;
         v_diff_tax_amt := v_tax_amt2 - v_tot_tax_amt;
      END IF;

      FOR var_inst_no IN 1 .. v_no_of_payment
      LOOP                 ------------------------------------ S->var_inst_no
         IF p_line_cd = 'SC'
         THEN
            IF var_inst_no > 1
            THEN
               IF p_version = '2'
               THEN
                  var_due_date := ADD_MONTHS (var_due_date, 1);
               ELSIF v_no_of_days = 0
               THEN
                  var_due_date := var_due_date + 30;
               ELSE
                  var_due_date := var_due_date + v_no_of_days;
               END IF;
            ELSE
               var_due_date := TO_DATE (p_nbt_due_date, 'mm-dd-rrrr');
            END IF;

            IF var_inst_no = var_no_of_payt
            THEN
               pv_last_due_date_sc := var_due_date;
            END IF;
         END IF;

         IF var_inst_no = 1
         THEN
            IF v_is_longterm
            THEN
               var_due_date := s.due_date;
            ELSE
               var_due_date := TO_DATE (p_nbt_due_date, 'mm-dd-rrrr');
            END IF;

            IF v_no_of_payment = 1
            THEN
               var_tax_amt_due := v_tax_amt1 + var_ini_tax_amt + v_tax_amt3;
            ELSE
               var_tax_amt_due := v_tax_amt1 + var_ini_tax_amt;
            END IF;

            v_prem_amt_due := var_prem_amt;
            v_share_pct_due := var_share_pct;
         ELSIF var_inst_no = v_no_of_payment
         THEN
            var_tax_amt_due := v_tax_amt3 + var_ini_tax_amt + v_diff_tax_amt;
            v_prem_amt_due := var_prem_amt + v_diff_cents;
            v_share_pct_due := var_share_pct + v_diff_pct;

            /*
            **Corrects computation of due date by computing agains no. of days of the
            **policy instead of computing it against 365.  This is to handle
            **cases when policy duration is less than 1 year and annual_sw = 'N'
            */
            --utilizes the value of v_no_of_days to make sure that the last payment date will not
            --be greater than the expiry date
            --Also checks the duration.
            IF v_no_of_payment = 2
            THEN
               IF v_no_payt_days IS NOT NULL
               THEN
                  IF (v_policy_days - v_no_of_days) > v_no_payt_days
                  THEN
                     var_due_date :=
                          var_due_date
                        + ROUND (v_no_payt_days / v_no_of_payment)
                        + v_no_of_days_again;
                  ELSE
                     var_due_date :=
                          var_due_date
                        + ROUND (  (v_policy_days - v_no_of_days)
                                 / v_exact_no_of_payment
                                )
                        + v_no_of_days_again;
                  END IF;
               ELSE
                  var_due_date :=
                       var_due_date
                     + ROUND (  (v_policy_days - v_no_of_days)
                              / v_exact_no_of_payment
                             )
                     + v_no_of_days_again;
               END IF;
            ELSE
               IF v_no_payt_days IS NOT NULL
               THEN
                  IF (v_policy_days - v_no_of_days) > v_no_payt_days
                  THEN
                     var_due_date :=
                          var_due_date
                        + ROUND (v_no_payt_days / v_no_of_payment);
                  ELSE
                     var_due_date :=
                          var_due_date
                        + ROUND (  (v_policy_days - v_no_of_days)
                                 / v_exact_no_of_payment
                                );
                  END IF;
               ELSE
                  var_due_date :=
                       var_due_date
                     + ROUND (  (v_policy_days - v_no_of_days)
                              / v_exact_no_of_payment
                             );
               END IF;
            END IF;
--*******************
         ELSE
            var_tax_amt_due := var_ini_tax_amt;
            v_prem_amt_due := var_prem_amt;
            v_share_pct_due := var_share_pct;

            /*
            **Corrects computation of due date by computing agains no. of days of the
            **policy instead of computing it against 365.  This is to handle
            **cases when policy duration is less than 1 year and annual_sw = 'N'
            */
            --utilizes the value of v_no_of_days to make sure that the last payment date will not
            --be greater than the expiry date
            --Also checks the duration.
            IF v_no_payt_days IS NOT NULL
            THEN
               IF (v_policy_days - v_no_of_days) > v_no_payt_days
               THEN
                  var_due_date :=
                       var_due_date
                     + ROUND (v_no_payt_days / v_no_of_payment)
                     + v_no_of_days_again;
               ELSE
                  var_due_date :=
                       var_due_date
                     + ROUND (  (v_policy_days - v_no_of_days)
                              / v_exact_no_of_payment
                             )
                     + v_no_of_days_again;
               END IF;
            ELSE
               var_due_date :=
                    var_due_date
                  + ROUND (  (v_policy_days - v_no_of_days)
                           / v_exact_no_of_payment
                          )
                  + v_no_of_days_again;
            END IF;

            v_no_of_days_again := 0;
         END IF;

         pv_last_due_date := var_due_date;

         IF     (pv_date_sw = 'Y' OR NVL (pv_date_sw1, 'Y') = 'Y')
            AND p_version = '1'
         THEN
            INSERT INTO gipi_winstallment
                        (par_id, item_grp, takeup_seq_no, inst_no,
                         share_pct, prem_amt, tax_amt,
                         due_date
                        )
                 VALUES (p_par_id, s.item_grp, s.takeup_seq_no, var_inst_no,
                         v_share_pct_due, v_prem_amt_due, var_tax_amt_due,
                         var_due_date
                        );
         ELSE
            UPDATE gipi_winstallment
               SET share_pct = v_share_pct_due,
                   prem_amt = v_prem_amt_due,
                   tax_amt = var_tax_amt_due
             WHERE par_id = p_par_id
               AND item_grp = s.item_grp
               AND takeup_seq_no = s.takeup_seq_no
               AND inst_no = var_inst_no;
         END IF;
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
/


