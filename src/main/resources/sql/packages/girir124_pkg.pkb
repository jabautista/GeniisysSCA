CREATE OR REPLACE PACKAGE BODY cpi.girir124_pkg
AS
/*
**  Created by   :  Benjo Brito
**  Date Created :  08.03.2016
**  Description  :  GIRIR124 - INWARD TREATY REGISTER
*/
   FUNCTION get_report_details (
      p_report_month   VARCHAR2,
      p_report_year    VARCHAR2,
      p_transaction    VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_rec          report_type;
      v_param_date   VARCHAR2 (100);
      v_multiplier   NUMBER;
      v_line_name    giis_line.line_name%TYPE;    
      v_trty_yy      giri_intreaty.trty_yy%TYPE;
      v_trty_name    giis_dist_share.trty_name%TYPE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         SELECT UPPER (report_title)
           INTO v_rec.report_title
           FROM giis_reports
          WHERE report_id = 'GIRIR124';
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            v_rec.report_title := '';
      END;

      IF NVL (p_transaction, 'BOOKED') = 'BOOKED'
      THEN
         v_param_date := 'BY ACCOUNTING ENTRY DATE ';
      END IF;

      IF p_report_month IS NOT NULL
      THEN
         v_param_date :=
                v_param_date || 'FOR THE MONTH OF ' || UPPER (p_report_month);

         IF p_report_year IS NOT NULL
         THEN
            v_param_date := v_param_date || ', ' || p_report_year;
         END IF;
      END IF;

      v_rec.param_date := TRIM (v_param_date);

      FOR i IN (SELECT   b.line_name, a.trty_yy, d.trty_name, c.ri_name,
                         a.line_cd, a.intrty_seq_no, a.tran_type, a.tran_no,
                         a.booking_mth, a.booking_yy, a.acct_ent_date, a.acct_neg_date,
                         a.ri_prem_amt, a.ri_comm_amt, a.ri_comm_vat, a.currency_rt,
                         a.clm_loss_pd_amt, a.clm_loss_exp_amt,
                         a.clm_recoverable_amt, a.charge_amount,
                         TO_CHAR (a.acct_neg_date, 'fmMONTH YYYY') acct_neg_date2
                    FROM giri_intreaty a,
                         giis_line b,
                         giis_reinsurer c,
                         giis_dist_share d
                   WHERE a.line_cd = b.line_cd
                     AND a.ri_cd = c.ri_cd
                     AND a.line_cd = d.line_cd
                     AND a.share_cd = d.share_cd
                     AND (   DECODE(p_transaction, 'BOOKED', 1, 0) = 1
                          OR (    a.acct_ent_date IS NULL
                              AND a.cancel_date IS NULL
                              AND TO_CHAR(TO_DATE(a.booking_mth, 'MM'), 'fmMONTH') = NVL(p_report_month, TO_CHAR(TO_DATE(a.booking_mth, 'MM'), 'fmMONTH'))
                              AND TO_CHAR(TO_DATE(a.booking_yy, 'YYYY'), 'YYYY') = NVL (p_report_year, TO_CHAR (TO_DATE (a.booking_yy, 'YYYY'), 'YYYY'))
                             )
                         )
                     AND (   DECODE(p_transaction, 'BOOKED', 0, 1) = 1
                          OR (   TO_CHAR(a.acct_ent_date, 'fmMONTH YYYY') = NVL(p_report_month, TO_CHAR(a.acct_ent_date, 'fmMONTH')) ||' '|| NVL(p_report_year, TO_CHAR(a.acct_ent_date, 'YYYY'))
                              OR TO_CHAR(a.acct_neg_date, 'fmMONTH YYYY') = NVL(p_report_month, TO_CHAR(a.acct_neg_date, 'fmMONTH')) ||' '|| NVL(p_report_year, TO_CHAR(a.acct_neg_date, 'YYYY'))
                             )
                         )
                ORDER BY b.line_name, a.trty_yy, d.trty_name, a.intrty_seq_no)
      LOOP
         IF     i.line_name = v_line_name
            AND i.trty_yy <> v_trty_yy
         THEN
            v_rec.trty_separate := 'Y';
         ELSIF  i.line_name = v_line_name
            AND i.trty_yy = v_trty_yy
            AND i.trty_name <> v_trty_name
         THEN
            v_rec.trty_separate := 'N';
         ELSE
            v_rec.trty_separate := NULL;
         END IF;
         
         v_line_name := i.line_name;
         v_trty_yy := i.trty_yy;
         v_trty_name := i.trty_name;
         v_multiplier := 1;
    
         IF i.acct_neg_date2 = p_report_month || ' ' || p_report_year
         THEN
            v_multiplier := -1;
         END IF;
         
         v_rec.line_name := i.line_name;
         v_rec.trty_yy := TO_CHAR (TO_DATE (i.trty_yy, 'YY'), 'YYYY');
         v_rec.trty_name := i.trty_name;
         v_rec.ri_name := i.ri_name;
         v_rec.intrty_no :=
               i.line_cd
            || '-'
            || i.trty_yy
            || '-'
            || TO_CHAR (i.intrty_seq_no, 'fm00009');
         v_rec.period := i.tran_type || ' / ' || TO_CHAR (i.tran_no, 'fm09');
         v_rec.booking_date := i.booking_mth || ' ' || TO_CHAR (i.booking_yy);
         v_rec.acct_ent_date := TO_CHAR (i.acct_ent_date, 'MM-DD-YYYY');
         v_rec.acct_neg_date := TO_CHAR (i.acct_neg_date, 'MM-DD-YYYY');
         v_rec.ri_prem_amt := NVL (i.ri_prem_amt, 0) * i.currency_rt * v_multiplier;
         v_rec.ri_comm_amt := NVL (i.ri_comm_amt, 0) * i.currency_rt * v_multiplier;
         v_rec.ri_comm_vat := NVL (i.ri_comm_vat, 0) * i.currency_rt * v_multiplier;
         v_rec.clm_loss_pd_amt := NVL (i.clm_loss_pd_amt, 0) * i.currency_rt * v_multiplier;
         v_rec.clm_loss_exp_amt := NVL (i.clm_loss_exp_amt, 0) * i.currency_rt * v_multiplier;
         v_rec.clm_recoverable_amt := NVL (i.clm_recoverable_amt, 0) * i.currency_rt * v_multiplier;
         v_rec.charge_amount := NVL (i.charge_amount, 0) * i.currency_rt * v_multiplier;
         v_rec.total :=
            NVL (  NVL (i.ri_prem_amt, 0)
                 - (NVL (i.ri_comm_amt, 0) + NVL (i.ri_comm_vat, 0))
                 - (NVL (i.clm_loss_pd_amt, 0) + NVL (i.clm_loss_exp_amt, 0))
                 + NVL (i.clm_recoverable_amt, 0)
                 + NVL (i.charge_amount, 0),
                 0
                ) * i.currency_rt * v_multiplier;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/