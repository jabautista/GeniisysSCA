DROP PROCEDURE CPI.ADJUST_PREM_VAT_GIRIS002;

CREATE OR REPLACE PROCEDURE CPI.ADJUST_PREM_VAT_GIRIS002 (
   p_prem_vat          IN OUT NUMBER,
   p_ri_cd             IN     NUMBER,
   P_PREM_VAT_OLD             NUMBER,
   p_line_cd                  VARCHAR2,
   p_subline_cd               VARCHAR2,
   p_iss_cd                   VARCHAR2,
   p_par_yy                   NUMBER,
   p_par_seq_no               NUMBER,
   p_pol_seq_no               NUMBER,
   p_renew_no                 NUMBER,
   p_issue_yy                 NUMBER,
   P_ri_PREM_VAT_NEW          NUMBER,
   status                     VARCHAR2)
IS
   v_par_id       gipi_parlist.par_id%TYPE;
   v_par_status   gipi_parlist.par_status%TYPE;
   v_booking      DATE;
   v_pol_flag     gipi_polbasic.pol_flag%TYPE;
   v_prem_vat     VARCHAR2 (1) := 'N';
BEGIN
   FOR c1
      IN (SELECT par_id, par_status
            FROM gipi_parlist
           WHERE     line_cd = p_line_cd
                 AND iss_cd = p_iss_cd
                 AND par_yy = p_par_yy
                 AND par_seq_no = p_par_seq_no)
   LOOP
      v_par_id := c1.par_id;
      v_par_status := c1.par_status;
   END LOOP;

   IF v_par_status = 10
   THEN
      FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                   FROM gipi_polbasic
                  WHERE par_id = v_par_id)
      LOOP
         v_booking :=
            TO_DATE (c1.booking_mth || '/' || c1.booking_year, 'MONTH/YYYY');
         v_pol_flag := c1.pol_flag;
      END LOOP;
   ELSE
      FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                   FROM gipi_wpolbas
                  WHERE par_id = v_par_id)
      LOOP
         v_booking :=
            TO_DATE (c1.booking_mth || '/' || c1.booking_year, 'MONTH/YYYY');
         v_pol_flag := c1.pol_flag;
      END LOOP;
   END IF;

   IF v_pol_flag = '4'
   THEN
      FOR c1
         IN (SELECT policy_id
               FROM gipi_polbasic
              WHERE     line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND endt_seq_no = 0)
      LOOP
         FOR c2
            IN (SELECT 1
                  FROM GIRI_BINDER d,
                       GIRI_FRPS_RI C,
                       GIRI_DISTFRPS b,
                       GIUW_POL_DIST a
                 WHERE     d.fnl_binder_id = C.fnl_binder_id
                       AND d.reverse_date IS NULL
                       AND d.ri_cd = p_ri_cd
                       AND d.ri_prem_vat IS NOT NULL
                       AND C.line_cd = b.line_cd
                       AND C.frps_yy = b.frps_yy
                       AND C.frps_seq_no = b.frps_seq_no
                       AND b.dist_no = a.dist_no
                       AND a.policy_id = c1.policy_id)
         LOOP
            v_prem_vat := 'Y';
         END LOOP;
      END LOOP;

      IF v_prem_vat = 'N'
      THEN
         p_prem_vat := 0;
      /* issa12.06.2007 modified conditions to update ri_prem_vat in giri_wbinder if ri_prem_vat is recomputed
      ** for prf of PCIC, error encountered during month-end
      */
      ELSIF v_prem_vat = 'Y'  and status = 'CHANGED'
      THEN
         p_prem_vat := P_ri_PREM_VAT_NEW;
      ELSIF v_prem_vat = 'Y' AND p_prem_vat <> P_PREM_VAT_OLD
      THEN
         p_prem_vat := P_PREM_VAT_OLD;
      --end i--
      /*ELSE
       p_prem_vat := p_prem_vat;*/
      END IF;
   ELSE
      /*issa09.03.2007 modified conditions to update ri_prem_vat in giri_wbinder if ri_prem_vat is recomputed
      **  for prf id 845 of FLT
      */

      IF status = 'CHANGED' THEN
       p_prem_vat := P_ri_PREM_VAT_NEW;
     
      ELSIF p_prem_vat <> P_PREM_VAT_OLD
      THEN
         p_prem_vat := P_PREM_VAT_OLD;
      ELSE
         p_prem_vat := p_prem_vat;
      END IF;
   /*ELSIF v_booking < TO_DATE('APRIL/2007','MONTH/YYYY') THEN
     IF p_prem_vat <> variable.v_ri_prem_vat_o THEN
     p_prem_vat := variable.v_ri_prem_vat_o;
    ELSE
      p_prem_vat := p_prem_vat;
     END IF;
   END IF;*/
   END IF;
END;
/


