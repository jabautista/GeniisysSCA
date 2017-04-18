CREATE OR REPLACE FUNCTION CPI.get_plate_no (
   p_line_cd      gipi_polbasic.line_cd%TYPE,
   p_subline_cd   gipi_polbasic.subline_cd%TYPE,
   p_iss_cd       gipi_polbasic.iss_cd%TYPE,
   p_issue_yy     gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
   p_renew_no     gipi_polbasic.renew_no%TYPE,
   p_loss_date    gicl_claims.dsp_loss_date%TYPE, --benjo 10.20.2016 SR-23261
   p_pol_eff_date gicl_claims.pol_eff_date%TYPE, --benjo 10.20.2016 SR-23261
   p_expiry_date  gicl_claims.expiry_date%TYPE, --benjo 10.20.2016 SR-23261
   p_item_no      gipi_vehicle.item_no%TYPE
)
   RETURN VARCHAR2
IS
   v_plate_no   gipi_vehicle.plate_no%TYPE;
   v_item       gipi_vehicle.item_no%TYPE;
BEGIN
/* created by jayr 11252003
** this will return the latest plate number for the specified policy */
   IF p_item_no IS NULL
   THEN                                            --item count is equal to 1
      FOR a IN
         (SELECT a.item_no
            FROM gipi_vehicle a, gipi_polbasic b
           WHERE a.policy_id = b.policy_id
             AND b.line_cd = p_line_cd
             AND b.subline_cd = p_subline_cd
             AND b.iss_cd = p_iss_cd
             AND b.issue_yy = p_issue_yy
             AND b.pol_seq_no = p_pol_seq_no
             AND b.renew_no = p_renew_no
             AND b.pol_flag IN ('1', '2', '3', 'X')
             AND TRUNC (DECODE (TRUNC (b.eff_date),
                                TRUNC (b.incept_date), p_pol_eff_date,
                                b.eff_date
                               )
                       ) <= TRUNC (p_loss_date) --benjo 10.20.2016 SR-23261
             AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                b.expiry_date, p_expiry_date,
                                b.endt_expiry_date
                               )
                       ) >= TRUNC (p_loss_date)) --benjo 10.20.2016 SR-23261
      LOOP
         v_item := a.item_no;
      END LOOP;
   ELSE            
      v_item := p_item_no;
   END IF;

   FOR rec IN
      (SELECT   y.item_no, y.plate_no, x.endt_seq_no
           FROM gipi_polbasic x, gipi_vehicle y
          WHERE 1 = 1
            AND x.policy_id = y.policy_id
            AND x.line_cd = p_line_cd
            AND x.subline_cd = p_subline_cd
            AND x.iss_cd = p_iss_cd
            AND x.issue_yy = p_issue_yy
            AND x.pol_seq_no = p_pol_seq_no
            AND x.renew_no = p_renew_no
            AND y.item_no = v_item
            AND x.pol_flag IN ('1', '2', '3', 'X')
            AND TRUNC (DECODE (TRUNC (x.eff_date),
                               TRUNC (x.incept_date), p_pol_eff_date,
                               x.eff_date
                              )
                      ) <= TRUNC (p_loss_date) --benjo 10.20.2016 SR-23261
            AND TRUNC (DECODE (NVL (x.endt_expiry_date, x.expiry_date),
                               x.expiry_date, p_expiry_date,
                               x.endt_expiry_date
                              )
                      ) >= TRUNC (p_loss_date) --benjo 10.20.2016 SR-23261
       ORDER BY x.eff_date DESC, x.endt_seq_no DESC)
   LOOP
      v_plate_no := rec.plate_no;

      --check for change in plate_no using backward endt.
      FOR rec2 IN
         (SELECT   b.item_no, b.plate_no, a.endt_seq_no
              FROM gipi_polbasic a, gipi_vehicle b
             WHERE 1 = 1
               AND a.policy_id = b.policy_id
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd = p_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
               AND b.item_no = v_item
               AND a.pol_flag IN ('1', '2', '3', 'X')
               AND NVL (a.endt_seq_no, 0) > 0
               AND NVL (a.back_stat, 5) = 2
               AND NVL (a.endt_seq_no, 0) > rec.endt_seq_no
               AND TRUNC (DECODE (TRUNC (a.eff_date),
                                  TRUNC (a.incept_date), p_pol_eff_date,
                                  a.eff_date
                                 )
                         ) <= TRUNC (p_loss_date) --benjo 10.20.2016 SR-23261
               AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                  a.expiry_date, p_expiry_date,
                                  a.endt_expiry_date
                                 )
                         ) >= TRUNC (p_loss_date) --benjo 10.20.2016 SR-23261
          ORDER BY a.endt_seq_no DESC)
      LOOP
         v_plate_no := rec2.plate_no;
         EXIT;
      END LOOP;

      EXIT;
   END LOOP;

   RETURN (v_plate_no);
END;
/


