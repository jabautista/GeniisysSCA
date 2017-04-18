CREATE OR REPLACE PACKAGE BODY cpi.giri_intreaty_pkg
AS
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
   FUNCTION get_giri_intreaty_tg (
      p_intrty_flag   giri_intreaty.intrty_flag%TYPE,
      p_line_cd       giri_intreaty.line_cd%TYPE,
      p_trty_yy       giri_intreaty.trty_yy%TYPE,
      p_share_cd      giri_intreaty.share_cd%TYPE
   )
      RETURN giri_intreaty_tg_tab PIPELINED
   IS
      v_rec   giri_intreaty_tg_type;
   BEGIN
      FOR i IN (SELECT   a.intreaty_id, b.ri_name, a.line_cd, a.trty_yy,
                         a.intrty_seq_no, a.accept_date, a.user_id,
                         a.last_update, a.approve_by, a.approve_date
                    FROM giri_intreaty a, giis_reinsurer b
                   WHERE a.ri_cd = b.ri_cd
                     AND a.intrty_flag = p_intrty_flag
                     AND a.line_cd = p_line_cd
                     AND a.trty_yy = p_trty_yy
                     AND a.share_cd = p_share_cd
                ORDER BY a.last_update DESC)
      LOOP
         v_rec.intreaty_id := i.intreaty_id;
         v_rec.ri_name := i.ri_name;
         v_rec.intrty_no :=
               i.line_cd
            || '-'
            || i.trty_yy
            || '-'
            || TO_CHAR (i.intrty_seq_no, 'fm00009');
         v_rec.accept_date := TO_CHAR (i.accept_date, 'MM-DD-YYYY');
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY');
         v_rec.approve_by := i.approve_by;
         v_rec.approve_date := TO_CHAR (i.approve_date, 'MM-DD-YYYY');
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giris056_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN giris056_line_lov_tab PIPELINED
   IS
      v_rec   giris056_line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_iss_cd2 (line_cd,
                                                 NULL,
                                                 'GIRIS056',
                                                 p_user_id
                                                ) = 1
                ORDER BY line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giris056_trty_yy_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN giris056_trty_yy_lov_tab PIPELINED
   IS
      v_rec   giris056_trty_yy_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT trty_yy
                           FROM giis_dist_share
                          WHERE share_type = '2' AND line_cd = p_line_cd
                       ORDER BY trty_yy)
      LOOP
         v_rec.trty_yy := i.trty_yy;
         v_rec.dsp_trty_yy := TO_CHAR (TO_DATE (i.trty_yy, 'YY'), 'YYYY');
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giris056_trty_name_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_trty_yy   giis_dist_share.trty_yy%TYPE
   )
      RETURN giris056_trty_name_lov_tab PIPELINED
   IS
      v_rec   giris056_trty_name_lov_type;
   BEGIN
      FOR i IN (SELECT   share_cd, trty_name
                    FROM giis_dist_share
                   WHERE share_type = '2'
                     AND line_cd = p_line_cd
                     AND trty_yy = p_trty_yy
                ORDER BY share_cd)
      LOOP
         v_rec.share_cd := i.share_cd;
         v_rec.trty_name := i.trty_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE copy_intreaty (
      p_intreaty_id         giri_intreaty.intreaty_id%TYPE,
      p_intrty_no     OUT   VARCHAR2
   )
   IS
      v_intrty_seq_no   giri_intreaty.intrty_seq_no%TYPE;
      v_intreaty_id     giri_intreaty.intreaty_id%TYPE;
   BEGIN
      FOR i IN (SELECT intreaty_id, line_cd, trty_yy, ri_cd,
                       booking_mth, booking_yy, tran_type,
                       tran_no, currency_cd, currency_rt, ri_prem_amt,
                       ri_comm_rt, ri_comm_amt, ri_vat_rt, ri_comm_vat,
                       clm_loss_pd_amt, clm_loss_exp_amt,
                       clm_recoverable_amt, charge_amount, share_cd
                  FROM giri_intreaty
                 WHERE intreaty_id = p_intreaty_id)
      LOOP
         BEGIN
            SELECT inward_treaty_s.NEXTVAL
              INTO v_intreaty_id
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_intreaty_id := 1;
         END;

         BEGIN
            SELECT MAX (intrty_seq_no) + 1
              INTO v_intrty_seq_no
              FROM giri_intreaty
             WHERE line_cd = i.line_cd AND trty_yy = i.trty_yy;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_intrty_seq_no := 1;
         END;

         p_intrty_no :=
               i.line_cd
            || '-'
            || i.trty_yy
            || '-'
            || TO_CHAR (v_intrty_seq_no, 'fm00009');

         INSERT INTO giri_intreaty
                     (intreaty_id, line_cd, trty_yy,
                      intrty_seq_no, ri_cd, accept_date,
                      booking_mth, booking_yy, tran_type, tran_no, currency_cd,
                      currency_rt, ri_prem_amt, ri_comm_rt,
                      ri_comm_amt, ri_vat_rt, ri_comm_vat,
                      clm_loss_pd_amt, clm_loss_exp_amt,
                      clm_recoverable_amt, charge_amount, intrty_flag,
                      share_cd
                     )
              VALUES (NVL (v_intreaty_id, 1), i.line_cd, i.trty_yy,
                      NVL (v_intrty_seq_no, 1), i.ri_cd, TRUNC(SYSDATE),
                      i.booking_mth, i.booking_yy, i.tran_type, i.tran_no, i.currency_cd,
                      i.currency_rt, i.ri_prem_amt, i.ri_comm_rt,
                      i.ri_comm_amt, i.ri_vat_rt, i.ri_comm_vat,
                      i.clm_loss_pd_amt, i.clm_loss_exp_amt,
                      i.clm_recoverable_amt, i.charge_amount, 1,
                      i.share_cd
                     );

         FOR x IN (SELECT charge_cd, amount, w_tax
                     FROM giri_intreaty_charges
                    WHERE intreaty_id = i.intreaty_id)
         LOOP
            INSERT INTO giri_intreaty_charges
                        (intreaty_id, charge_cd, amount, w_tax
                        )
                 VALUES (v_intreaty_id, x.charge_cd, x.amount, x.w_tax
                        );
         END LOOP;

         FOR y IN (SELECT tax_type, tax_cd, charge_cd, charge_amt, sl_type_cd,
                          sl_cd, tax_pct, tax_amt
                     FROM giri_incharges_tax
                    WHERE intreaty_id = i.intreaty_id)
         LOOP
            INSERT INTO giri_incharges_tax
                        (intreaty_id, tax_type, tax_cd, charge_cd,
                         charge_amt, sl_type_cd, sl_cd, tax_pct,
                         tax_amt
                        )
                 VALUES (v_intreaty_id, y.tax_type, y.tax_cd, y.charge_cd,
                         y.charge_amt, y.sl_type_cd, y.sl_cd, y.tax_pct,
                         y.tax_amt
                        );
         END LOOP;
      END LOOP;
   END;

   PROCEDURE approve_intreaty (
      p_intreaty_id   giri_intreaty.intreaty_id%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
   IS
   BEGIN
      UPDATE giri_intreaty
         SET intrty_flag = 2,
             approve_by = p_user_id,
             approve_date = TRUNC(SYSDATE)
       WHERE intreaty_id = p_intreaty_id;
   END;

   PROCEDURE cancel_intreaty (
      p_intreaty_id   giri_intreaty.intreaty_id%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
   IS
   BEGIN
      UPDATE giri_intreaty
         SET intrty_flag = 3,
             cancel_user = p_user_id,
             cancel_date = TRUNC(SYSDATE)
       WHERE intreaty_id = p_intreaty_id;
   END;

   FUNCTION get_dist_share (
      p_line_cd    giis_dist_share.line_cd%TYPE,
      p_share_cd   giis_dist_share.share_cd%TYPE,
      p_trty_yy    giis_dist_share.trty_yy%TYPE
   )
      RETURN dist_share_tab PIPELINED
   IS
      v_rec   dist_share_type;
   BEGIN
      FOR i IN (SELECT b.line_name, a.trty_yy, a.trty_name, a.eff_date,
                       a.expiry_date
                  FROM giis_dist_share a, giis_line b
                 WHERE a.line_cd = p_line_cd
                   AND a.share_cd = p_share_cd
                   AND a.trty_yy = p_trty_yy
                   AND a.share_type = '2'
                   AND a.line_cd = b.line_cd)
      LOOP
         v_rec.line_name := i.line_name;
         v_rec.dsp_trty_yy := TO_CHAR (TO_DATE (i.trty_yy, 'YY'), 'YYYY');
         v_rec.trty_name := i.trty_name;
         v_rec.trty_term :=
               TO_CHAR (i.eff_date, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (i.expiry_date, 'fmMonth DD, YYYY');
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_ri_lov (
      p_line_cd    giri_intreaty.line_cd%TYPE,
      p_trty_yy    giri_intreaty.trty_yy%TYPE,
      p_share_cd   giri_intreaty.share_cd%TYPE,
      p_ri_cd      giri_intreaty.ri_cd%TYPE
   )
      RETURN ri_lov_tab PIPELINED
   IS
      v_rec   ri_lov_type;
   BEGIN
      FOR i IN (SELECT   a.ri_cd, b.ri_name, a.trty_shr_pct, a.ri_comm_rt,
                         b.input_vat_rate
                    FROM giis_trty_panel a, giis_reinsurer b
                   WHERE a.ri_cd = b.ri_cd
                     AND a.line_cd = p_line_cd
                     AND a.trty_seq_no = p_share_cd
                     AND a.trty_yy = p_trty_yy
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                ORDER BY b.ri_name)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.trty_shr_pct := i.trty_shr_pct || '%';
         v_rec.ri_comm_rt := NVL (i.ri_comm_rt, 0);
         v_rec.dsp_ri_comm_rt :=
                            TO_CHAR (NVL (i.ri_comm_rt, 0), 'fm990.00')
                            || '%';
         v_rec.ri_vat_rt := NVL (i.input_vat_rate, 0);
         v_rec.dsp_ri_vat_rt :=
                        TO_CHAR (NVL (i.input_vat_rate, 0), 'fm990.00')
                        || '%';
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_tran_type_list
      RETURN tran_type_list_tab PIPELINED
   IS
      v_rec   tran_type_list_type;
   BEGIN
      FOR i IN (SELECT SUBSTR (rv_low_value, 0, 3) rv_low_value
                  FROM cg_ref_codes
                 WHERE UPPER (rv_domain) = 'GIRI_INTREATY.TRAN_TYPE')
      LOOP
         v_rec.tran_type := i.rv_low_value;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE get_dflt_booking_date (
      p_accept_date    IN       DATE,
      p_booking_year   OUT      gipi_wpolbas.booking_year%TYPE,
      p_booking_mth    OUT      gipi_wpolbas.booking_mth%TYPE
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN
         (SELECT   booking_year, booking_mth,
                   TO_CHAR (TO_DATE (   '01-'
                                     || SUBSTR (booking_mth, 1, 3)
                                     || booking_year,
                                     'DD-MON-YYYY'
                                    ),
                            'MM'
                           )
              FROM giis_booking_month
             WHERE NVL (booked_tag, 'N') <> 'Y'
               AND (   booking_year >
                                   TO_NUMBER (TO_CHAR (p_accept_date, 'YYYY'))
                    OR (    booking_year =
                                   TO_NUMBER (TO_CHAR (p_accept_date, 'YYYY'))
                        AND TO_NUMBER
                                   (TO_CHAR (TO_DATE (   '01-'
                                                      || SUBSTR (booking_mth,
                                                                 1,
                                                                 3
                                                                )
                                                      || booking_year,
                                                      'DD-MON-YYYY'
                                                     ),
                                             'MM'
                                            )
                                   ) >=
                                     TO_NUMBER (TO_CHAR (p_accept_date, 'MM'))
                       )
                   )
          ORDER BY 1, 3)
      LOOP
         p_booking_year := i.booking_year;
         p_booking_mth := i.booking_mth;
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'N'
      THEN
         p_booking_year := NULL;
         p_booking_mth := NULL;
      END IF;
   END;

   FUNCTION get_giri_intreaty (p_intreaty_id giri_intreaty.intreaty_id%TYPE)
      RETURN giri_intreaty_tab PIPELINED
   IS
      v_rec   giri_intreaty_type;
   BEGIN
      FOR i IN (SELECT intreaty_id, line_cd, trty_yy, intrty_seq_no, ri_cd,
                       accept_date, approve_by, approve_date, cancel_user,
                       cancel_date, acct_ent_date, acct_neg_date,
                       booking_mth, booking_yy, tran_type, tran_no,
                       currency_cd, currency_rt, ri_prem_amt, ri_comm_rt,
                       ri_comm_amt, ri_vat_rt, ri_comm_vat, clm_loss_pd_amt,
                       clm_loss_exp_amt, clm_recoverable_amt, charge_amount,
                       intrty_flag, share_cd
                  FROM giri_intreaty
                 WHERE intreaty_id = p_intreaty_id)
      LOOP
         v_rec.intreaty_id := i.intreaty_id;
         v_rec.line_cd := i.line_cd;
         v_rec.trty_yy := i.trty_yy;
         v_rec.intrty_seq_no := i.intrty_seq_no;
         v_rec.ri_cd := i.ri_cd;
         v_rec.accept_date := i.accept_date;
         v_rec.approve_by := i.approve_by;
         v_rec.approve_date := i.approve_date;
         v_rec.cancel_user := i.cancel_user;
         v_rec.cancel_date := i.cancel_date;
         v_rec.acct_ent_date := i.acct_ent_date;
         v_rec.acct_neg_date := i.acct_neg_date;
         v_rec.booking_mth := i.booking_mth;
         v_rec.booking_yy := i.booking_yy;
         v_rec.tran_type := i.tran_type;
         v_rec.tran_no := i.tran_no;
         v_rec.currency_cd := i.currency_cd;
         v_rec.currency_rt := i.currency_rt;
         v_rec.ri_prem_amt := i.ri_prem_amt;
         v_rec.ri_comm_rt := i.ri_comm_rt;
         v_rec.ri_comm_amt := i.ri_comm_amt;
         v_rec.ri_vat_rt := i.ri_vat_rt;
         v_rec.ri_comm_vat := i.ri_comm_vat;
         v_rec.clm_loss_pd_amt := i.clm_loss_pd_amt;
         v_rec.clm_loss_exp_amt := i.clm_loss_exp_amt;
         v_rec.clm_recoverable_amt := i.clm_recoverable_amt;
         v_rec.charge_amount := i.charge_amount;
         v_rec.intrty_flag := i.intrty_flag;
         v_rec.share_cd := i.share_cd;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giri_intreaty_charges (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE
   )
      RETURN giri_intreaty_charges_tab PIPELINED
   IS
      v_rec   giri_intreaty_charges_type;
      v_tax_amount   NUMBER (15, 2);
   BEGIN
      FOR i IN (SELECT intreaty_id, charge_cd, amount, w_tax
                  FROM giri_intreaty_charges
                 WHERE intreaty_id = p_intreaty_id)
      LOOP
         IF NVL (i.w_tax, 'N') = 'Y'
         THEN
            BEGIN
               SELECT SUM (NVL (tax_amt, 0))
                 INTO v_tax_amount
                 FROM giri_incharges_tax
                WHERE intreaty_id = i.intreaty_id AND charge_cd = i.charge_cd;

               v_rec.dsp_amount := i.amount + v_tax_amount;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dsp_amount := i.amount;
            END;
         ELSE
            v_rec.dsp_amount := i.amount;
         END IF;
         
         v_rec.intreaty_id := i.intreaty_id;
         v_rec.charge_cd := i.charge_cd;
         v_rec.amount := i.amount;
         v_rec.w_tax := i.w_tax;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giri_intreaty_charges_tg (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE
   )
      RETURN giri_intreaty_charges_tg_tab PIPELINED
   IS
      v_rec          giri_intreaty_charges_tg_type;
      v_tax_amount   NUMBER (15, 2);
   BEGIN
      FOR i IN (SELECT a.intreaty_id, a.charge_cd, b.tax_name, a.amount,
                       a.w_tax
                  FROM giri_intreaty_charges a, giac_taxes b
                 WHERE a.charge_cd = b.tax_cd
                   AND a.intreaty_id = p_intreaty_id)
      LOOP
         IF NVL (i.w_tax, 'N') = 'Y'
         THEN
            BEGIN
               SELECT SUM (NVL (tax_amt, 0))
                 INTO v_tax_amount
                 FROM giri_incharges_tax
                WHERE intreaty_id = i.intreaty_id AND charge_cd = i.charge_cd;

               v_rec.dsp_amount := i.amount + v_tax_amount;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dsp_amount := i.amount;
            END;
         ELSE
            v_rec.dsp_amount := i.amount;
         END IF;

         v_rec.intreaty_id := i.intreaty_id;
         v_rec.charge_cd := i.charge_cd;
         v_rec.tax_name := i.tax_name;
         v_rec.amount := i.amount;
         v_rec.w_tax := i.w_tax;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_charges_lov
      RETURN charges_lov_tab PIPELINED
   IS
      v_rec   charges_lov_type;
   BEGIN
      FOR i IN (SELECT tax_cd, tax_name
                  FROM giac_taxes
                 WHERE UPPER (fund_cd) = UPPER (giacp.v ('FUND_CD'))
                   AND NVL (intrty_sw, 'N') = 'Y')
      LOOP
         v_rec.tax_cd := i.tax_cd;
         v_rec.tax_name := i.tax_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE save_giri_intreaty (p_giri_intreaty giri_intreaty%ROWTYPE)
   IS
      intreaty          giri_intreaty%ROWTYPE;
      v_intrty_seq_no   giri_intreaty.intrty_seq_no%TYPE;
   BEGIN
      intreaty := p_giri_intreaty;

      BEGIN
         SELECT MAX (intrty_seq_no) + 1
           INTO v_intrty_seq_no
           FROM giri_intreaty
          WHERE line_cd = intreaty.line_cd AND trty_yy = intreaty.trty_yy;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_intrty_seq_no := 1;
      END;

      MERGE INTO giri_intreaty
         USING DUAL
         ON (intreaty_id = intreaty.intreaty_id)
         WHEN NOT MATCHED THEN
            INSERT (intreaty_id, line_cd, trty_yy, intrty_seq_no, ri_cd,
                    accept_date, booking_mth, booking_yy, tran_type, tran_no,
                    currency_cd, currency_rt, ri_prem_amt, ri_comm_rt,
                    ri_comm_amt, ri_vat_rt, ri_comm_vat, clm_loss_pd_amt,
                    clm_loss_exp_amt, clm_recoverable_amt, charge_amount,
                    intrty_flag, share_cd)
            VALUES (intreaty.intreaty_id, intreaty.line_cd, intreaty.trty_yy,
                    NVL(v_intrty_seq_no, 1), intreaty.ri_cd,
                    TRUNC(intreaty.accept_date), intreaty.booking_mth,
                    intreaty.booking_yy, intreaty.tran_type, intreaty.tran_no,
                    intreaty.currency_cd, intreaty.currency_rt,
                    intreaty.ri_prem_amt, intreaty.ri_comm_rt,
                    intreaty.ri_comm_amt, intreaty.ri_vat_rt,
                    intreaty.ri_comm_vat, intreaty.clm_loss_pd_amt,
                    intreaty.clm_loss_exp_amt, intreaty.clm_recoverable_amt,
                    intreaty.charge_amount, intreaty.intrty_flag,
                    intreaty.share_cd)
         WHEN MATCHED THEN
            UPDATE
               SET line_cd = intreaty.line_cd, trty_yy = intreaty.trty_yy,
                   intrty_seq_no = intreaty.intrty_seq_no,
                   ri_cd = intreaty.ri_cd, accept_date = TRUNC(intreaty.accept_date),
                   booking_mth = intreaty.booking_mth,
                   booking_yy = intreaty.booking_yy,
                   tran_type = intreaty.tran_type, tran_no = intreaty.tran_no,
                   currency_cd = intreaty.currency_cd,
                   currency_rt = intreaty.currency_rt,
                   ri_prem_amt = intreaty.ri_prem_amt,
                   ri_comm_rt = intreaty.ri_comm_rt,
                   ri_comm_amt = intreaty.ri_comm_amt,
                   ri_vat_rt = intreaty.ri_vat_rt,
                   ri_comm_vat = intreaty.ri_comm_vat,
                   clm_loss_pd_amt = intreaty.clm_loss_pd_amt,
                   clm_loss_exp_amt = intreaty.clm_loss_exp_amt,
                   clm_recoverable_amt = intreaty.clm_recoverable_amt,
                   charge_amount = intreaty.charge_amount,
                   intrty_flag = intreaty.intrty_flag,
                   share_cd = intreaty.share_cd
            ;
   END;

   PROCEDURE del_giri_intreaty_charges (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE,
      p_charge_cd     giri_intreaty_charges.charge_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giri_intreaty_charges
            WHERE intreaty_id = p_intreaty_id AND charge_cd = p_charge_cd;
   END;

   PROCEDURE add_giri_intreaty_charges (
      p_giri_intreaty_charges   giri_intreaty_charges%ROWTYPE
   )
   IS
      intreaty   giri_intreaty_charges%ROWTYPE;
   BEGIN
      intreaty := p_giri_intreaty_charges;
      MERGE INTO giri_intreaty_charges
         USING DUAL
         ON (    intreaty_id = intreaty.intreaty_id
             AND charge_cd = intreaty.charge_cd)
         WHEN NOT MATCHED THEN
            INSERT (intreaty_id, charge_cd, amount, w_tax)
            VALUES (intreaty.intreaty_id, intreaty.charge_cd, intreaty.amount,
                    intreaty.w_tax)
         WHEN MATCHED THEN
            UPDATE
               SET amount = intreaty.amount, w_tax = intreaty.w_tax
            ;
   END;

   FUNCTION get_giri_incharges_tax (
      p_intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      p_charge_cd     giri_incharges_tax.charge_cd%TYPE
   )
      RETURN giri_incharges_tax_tab PIPELINED
   IS
      v_rec   giri_incharges_tax_type;
   BEGIN
      FOR i IN (SELECT a.intreaty_id, a.tax_type, a.tax_cd, a.charge_cd,
                       a.charge_amt, a.sl_type_cd, a.sl_cd, a.tax_pct,
                       a.tax_amt
                  FROM giri_incharges_tax a
                 WHERE a.intreaty_id = p_intreaty_id
                   AND a.charge_cd = p_charge_cd)
      LOOP
         v_rec.intreaty_id := i.intreaty_id;
         v_rec.tax_type := i.tax_type;
         v_rec.tax_cd := i.tax_cd;
         v_rec.charge_cd := i.charge_cd;
         v_rec.charge_amt := i.charge_amt;
         v_rec.sl_type_cd := i.sl_type_cd;
         v_rec.sl_cd := i.sl_cd;
         v_rec.tax_pct := i.tax_pct;
         v_rec.tax_amt := i.tax_amt;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giri_incharges_tax_tg (
      p_intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      p_charge_cd     giri_incharges_tax.charge_cd%TYPE
   )
      RETURN giri_incharges_tax_tg_tab PIPELINED
   IS
      v_rec         giri_incharges_tax_tg_type;
      v_module_id   giac_modules.module_id%TYPE;
   BEGIN
      FOR i IN (SELECT a.intreaty_id, a.tax_type, a.tax_cd, a.sl_type_cd,
                       a.sl_cd, a.charge_cd, a.charge_amt, a.tax_pct,
                       a.tax_amt
                  FROM giri_incharges_tax a
                 WHERE a.intreaty_id = p_intreaty_id
                   AND a.charge_cd = p_charge_cd)
      LOOP
         v_rec.intreaty_id := i.intreaty_id;
         v_rec.tax_type := i.tax_type;
         v_rec.tax_cd := i.tax_cd;
         v_rec.sl_type_cd := i.sl_type_cd;
         v_rec.sl_cd := i.sl_cd;
         v_rec.charge_cd := i.charge_cd;
         v_rec.charge_amt := i.charge_amt;
         v_rec.tax_pct := i.tax_pct;
         v_rec.tax_amt := i.tax_amt;

         IF i.tax_type = 'W'
         THEN
            SELECT whtax_desc
              INTO v_rec.tax_name
              FROM giac_wholding_taxes
             WHERE whtax_id = i.tax_cd;
         ELSE
            SELECT module_id
              INTO v_module_id
              FROM giac_modules
             WHERE module_name = 'GIACS039';

            SELECT description
              INTO v_rec.tax_name
              FROM giac_module_entries
             WHERE module_id = v_module_id AND item_no = i.tax_cd;
         END IF;

         SELECT tax_name
           INTO v_rec.charge
           FROM giac_taxes
          WHERE UPPER (fund_cd) = UPPER (giacp.v ('FUND_CD'))
            AND tax_cd = i.charge_cd;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_taxes_lov (p_tax_type giri_incharges_tax.tax_type%TYPE)
      RETURN taxes_lov_tab PIPELINED
   IS
      v_rec         taxes_lov_type;
      v_module_id   giac_modules.module_id%TYPE;
   BEGIN
      IF p_tax_type = 'W'
      THEN
         FOR w IN (SELECT whtax_id, whtax_desc, percent_rate, sl_type_cd
                     FROM giac_wholding_taxes
                    WHERE UPPER (gibr_gfun_fund_cd) =
                                                  UPPER (giacp.v ('FUND_CD'))
                      AND UPPER (gibr_branch_cd) =
                                                 UPPER (giacp.v ('BRANCH_CD')))
         LOOP
            v_rec.tax_type_cd := p_tax_type||'-'||TO_CHAR(w.whtax_id);
            v_rec.tax_cd := w.whtax_id;
            v_rec.tax_name := w.whtax_desc;
            v_rec.tax_pct := w.percent_rate;
            v_rec.sl_type_cd := w.sl_type_cd;
            PIPE ROW (v_rec);
         END LOOP;
      ELSE
         SELECT module_id
           INTO v_module_id
           FROM giac_modules
          WHERE module_name = 'GIACS039';

         FOR i IN (SELECT item_no, description, sl_type_cd
                     FROM giac_module_entries
                    WHERE module_id = v_module_id)
         LOOP
            v_rec.tax_type_cd := p_tax_type||'-'||TO_CHAR(i.item_no);
            v_rec.tax_cd := i.item_no;
            v_rec.tax_name := i.description;
            v_rec.tax_pct := giacp.n ('INPUT_VAT_RT');
            v_rec.sl_type_cd := i.sl_type_cd;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END;

   FUNCTION get_sl_lov (p_sl_type_cd giac_sl_lists.sl_type_cd%TYPE)
      RETURN sl_lov_tab PIPELINED
   IS
      v_rec   sl_lov_type;
   BEGIN
      FOR i IN (SELECT sl_cd, sl_name
                  FROM giac_sl_lists
                 WHERE UPPER (fund_cd) = UPPER (giacp.v ('FUND_CD'))
                   AND sl_type_cd = p_sl_type_cd)
      LOOP
         v_rec.sl_cd := i.sl_cd;
         v_rec.sl_name := i.sl_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE del_giri_incharges_tax (
      p_intreaty_id   giri_incharges_tax.intreaty_id%TYPE,
      p_tax_type      giri_incharges_tax.tax_type%TYPE,
      p_tax_cd        giri_incharges_tax.tax_cd%TYPE,
      p_charge_cd     giri_incharges_tax.charge_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giri_incharges_tax
            WHERE intreaty_id = p_intreaty_id
              AND tax_type = p_tax_type
              AND tax_cd = p_tax_cd
              AND charge_cd = p_charge_cd;
   END;

   PROCEDURE add_giri_incharges_tax (
      p_giri_incharges_tax   giri_incharges_tax%ROWTYPE
   )
   IS
      tax   giri_incharges_tax%ROWTYPE;
   BEGIN
      tax := p_giri_incharges_tax;
      MERGE INTO giri_incharges_tax
         USING DUAL
         ON (    intreaty_id = tax.intreaty_id
             AND tax_type = tax.tax_type
             AND tax_cd = tax.tax_cd
             AND charge_cd = tax.charge_cd)
         WHEN NOT MATCHED THEN
            INSERT (intreaty_id, tax_type, tax_cd, charge_cd, charge_amt,
                    sl_type_cd, sl_cd, tax_pct, tax_amt)
            VALUES (tax.intreaty_id, tax.tax_type, tax.tax_cd, tax.charge_cd,
                    tax.charge_amt, tax.sl_type_cd, tax.sl_cd, tax.tax_pct,
                    tax.tax_amt)
         WHEN MATCHED THEN
            UPDATE
               SET charge_amt = tax.charge_amt, sl_type_cd = tax.sl_type_cd,
                   sl_cd = tax.sl_cd, tax_pct = tax.tax_pct,
                   tax_amt = tax.tax_amt
            ;
   END;

   PROCEDURE update_intreaty_charges (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE,
      p_charge_cd     giri_intreaty_charges.charge_cd%TYPE
   )
   IS
      v_exists   VARCHAR2 (1) := NULL;
      v_wtax     VARCHAR2 (1) := 'N';
   BEGIN
      SELECT COUNT (*)
        INTO v_exists
        FROM giri_incharges_tax
       WHERE intreaty_id = p_intreaty_id AND charge_cd = p_charge_cd;

      IF NVL (v_exists, 0) > 0
      THEN
         v_wtax := 'Y';
      END IF;

      UPDATE giri_intreaty_charges
         SET w_tax = v_wtax
       WHERE intreaty_id = p_intreaty_id AND charge_cd = p_charge_cd;
   END;
   
   PROCEDURE update_charge_amount (
      p_intreaty_id   giri_intreaty_charges.intreaty_id%TYPE
   )
   IS
      v_amount       giri_intreaty.charge_amount%TYPE  := 0;
      v_tax_amount   NUMBER (15, 2)                    := 0;
   BEGIN
      FOR i IN (SELECT intreaty_id, charge_cd, amount, w_tax
                  FROM giri_intreaty_charges
                 WHERE intreaty_id = p_intreaty_id)
      LOOP
         IF NVL (i.w_tax, 'N') = 'Y'
         THEN
            BEGIN
               SELECT SUM (NVL (tax_amt, 0))
                 INTO v_tax_amount
                 FROM giri_incharges_tax
                WHERE intreaty_id = i.intreaty_id AND charge_cd = i.charge_cd;

               v_amount := v_amount + i.amount + v_tax_amount;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_amount := v_amount + i.amount;
            END;
         ELSE
            v_amount := v_amount + i.amount;
         END IF;
      END LOOP;

      UPDATE giri_intreaty
         SET charge_amount = v_amount
       WHERE intreaty_id = p_intreaty_id;
   END;

   FUNCTION get_intreaty_id (
      p_line_cd         giri_intreaty.line_cd%TYPE,
      p_trty_yy         giri_intreaty.trty_yy%TYPE,
      p_intrty_seq_no   giri_intreaty.intrty_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_intreaty_id   NUMBER := 0;
   BEGIN
      SELECT intreaty_id
        INTO v_intreaty_id
        FROM giri_intreaty
       WHERE line_cd = p_line_cd
         AND trty_yy = p_trty_yy
         AND TO_CHAR (intrty_seq_no, 'fm00009') =
                                          TO_CHAR (p_intrty_seq_no, 'fm00009');

      RETURN v_intreaty_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN TOO_MANY_ROWS
      THEN
         RETURN 0;
   END;

   FUNCTION get_giris057_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN giris057_line_lov_tab PIPELINED
   IS
      v_rec   giris057_line_lov_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.line_name
                    FROM giis_line a
                   WHERE check_user_per_iss_cd2 (a.line_cd,
                                                 NULL,
                                                 'GIRIS057',
                                                 p_user_id
                                                ) = 1
                     AND a.line_cd IN (SELECT DISTINCT b.line_cd
                                         FROM giri_intreaty b)
                ORDER BY a.line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giris057_trty_yy_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN giris057_trty_yy_lov_tab PIPELINED
   IS
      v_rec   giris057_trty_yy_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.trty_yy
                           FROM giis_dist_share a
                          WHERE a.share_type = '2'
                            AND (a.line_cd, a.trty_yy) IN (SELECT DISTINCT b.line_cd, b.trty_yy
                                                             FROM giri_intreaty b
                                                            WHERE b.line_cd = p_line_cd)
                       ORDER BY a.trty_yy)
      LOOP
         v_rec.trty_yy := i.trty_yy;
         v_rec.dsp_trty_yy := TO_CHAR (TO_DATE (i.trty_yy, 'YY'), 'YYYY');
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giris057_intrty_no_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_trty_yy   giri_intreaty.trty_yy%TYPE
   )
      RETURN giris057_intrty_no_lov_tab PIPELINED
   IS
      v_rec   giris057_intrty_no_lov_type;
   BEGIN
      FOR i IN (SELECT   a.intrty_seq_no, b.ri_name, c.trty_name
                    FROM giri_intreaty a, giis_reinsurer b, giis_dist_share c
                   WHERE a.ri_cd = b.ri_cd
                     AND a.line_cd = c.line_cd
                     AND a.share_cd = c.share_cd
                     AND a.line_cd = p_line_cd
                     AND a.trty_yy = p_trty_yy
                ORDER BY a.intrty_seq_no)
      LOOP
         v_rec.intrty_seq_no := TO_CHAR (i.intrty_seq_no, 'fm00009');
         v_rec.ri_name := i.ri_name;
         v_rec.trty_name := i.trty_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_view_intreaty (p_intreaty_id giri_intreaty.intreaty_id%TYPE)
      RETURN view_intreaty_tab PIPELINED
   IS
      v_rec   view_intreaty_type;
   BEGIN
      FOR i IN (SELECT a.intreaty_id, a.line_cd, a.trty_yy, a.intrty_seq_no,
                       b.line_name, c.trty_name, c.eff_date, c.expiry_date,
                       d.ri_name, e.trty_shr_pct, a.accept_date, a.tran_type,
                       a.tran_no, a.booking_mth, a.booking_yy, a.approve_by,
                       a.approve_date, a.acct_ent_date, a.cancel_user,
                       a.cancel_date, a.acct_neg_date, f.short_name,
                       a.currency_rt, a.ri_prem_amt, a.ri_comm_rt,
                       a.ri_comm_amt, a.ri_vat_rt, a.ri_comm_vat,
                       a.clm_loss_pd_amt, a.clm_loss_exp_amt,
                       a.clm_recoverable_amt, a.charge_amount
                  FROM giri_intreaty a,
                       giis_line b,
                       giis_dist_share c,
                       giis_reinsurer d,
                       giis_trty_panel e,
                       giis_currency f
                 WHERE a.intreaty_id = p_intreaty_id
                   AND a.line_cd = b.line_cd
                   AND a.line_cd = c.line_cd
                   AND a.share_cd = c.share_cd
                   AND a.ri_cd = d.ri_cd
                   AND a.line_cd = e.line_cd
                   AND a.share_cd = e.trty_seq_no
                   AND a.trty_yy = e.trty_yy
                   AND a.ri_cd = e.ri_cd
                   AND a.currency_cd = f.main_currency_cd)
      LOOP
         v_rec.intreaty_id := i.intreaty_id;
         v_rec.line_cd := i.line_cd;
         v_rec.trty_yy := i.trty_yy;
         v_rec.intrty_seq_no := TO_CHAR (i.intrty_seq_no, 'fm00009');
         v_rec.line_name := i.line_name;
         v_rec.dsp_trty_yy := TO_CHAR (TO_DATE (i.trty_yy, 'YY'), 'YYYY');
         v_rec.trty_name := i.trty_name;
         v_rec.trty_term :=
               TO_CHAR (i.eff_date, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (i.expiry_date, 'fmMonth DD, YYYY');
         v_rec.ri_name := i.ri_name;
         v_rec.trty_shr_pct := i.trty_shr_pct || '%';
         v_rec.accept_date := TO_CHAR (i.accept_date, 'MM-DD-YYYY');
         v_rec.period := i.tran_type || ' - ' || TO_CHAR (i.tran_no, 'fm09');
         v_rec.booking_month :=
                               TO_CHAR (i.booking_yy) || ' - '
                               || i.booking_mth;
         v_rec.approve_by := i.approve_by;
         v_rec.approve_date := TO_CHAR (i.approve_date, 'MM-DD-YYYY');
         v_rec.acct_ent_date := TO_CHAR (i.acct_ent_date, 'MM-DD-YYYY');
         v_rec.cancel_user := i.cancel_user;
         v_rec.cancel_date := TO_CHAR (i.cancel_date, 'MM-DD-YYYY');
         v_rec.acct_neg_date := TO_CHAR (i.acct_neg_date, 'MM-DD-YYYY');
         v_rec.short_name := i.short_name;
         v_rec.currency_rt := NVL (i.currency_rt, 0);
         v_rec.ri_prem_amt := NVL (i.ri_prem_amt, 0);
         v_rec.ri_comm_rt := TO_CHAR (NVL (i.ri_comm_rt, 0), 'fm990.00')
                             || '%';
         v_rec.ri_comm_amt := NVL (i.ri_comm_amt, 0);
         v_rec.ri_vat_rt := TO_CHAR (NVL (i.ri_vat_rt, 0), 'fm990.00') || '%';
         v_rec.ri_comm_vat := NVL (i.ri_comm_vat, 0);
         v_rec.clm_loss_pd_amt := NVL (i.clm_loss_pd_amt, 0);
         v_rec.clm_loss_exp_amt := NVL (i.clm_loss_exp_amt, 0);
         v_rec.clm_recoverable_amt := NVL (i.clm_recoverable_amt, 0);
         v_rec.charge_amount := NVL (i.charge_amount, 0);
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/