CREATE OR REPLACE PACKAGE BODY cpi.gipir924_pkg
AS
   FUNCTION get_main (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN gipir924_tab PIPELINED
   IS
      v                 gipir924_type;
      v_special_risk    giis_document.text%TYPE;
      v_tsi_amt         NUMBER := 0;
      v_prem_amt        NUMBER := 0;
   BEGIN
      BEGIN
         SELECT NVL(text, 'N')
           INTO v.show_total_taxes
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'SHOW_TOTAL_TAXES';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v.show_total_taxes := 'N';
      END;

      BEGIN
         SELECT NVL(text, 'N')
           INTO v.display_wholding_tax
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'DISPLAY_WHOLDING_TAX';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v.display_wholding_tax := 'N';
      END;

      BEGIN
         SELECT NVL(text, 'N')
           INTO v.display_separate_premtax_vat
           FROM giis_document
          WHERE report_id = 'GIPIR923'
            AND title = 'DISPLAY_SEPARATE_PREMTAX_VAT';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v.display_separate_premtax_vat := 'N';
      END;

      BEGIN
         SELECT NVL(text, 'N')
           INTO v_special_risk
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'PRINT_SPECIAL_RISK';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_special_risk := 'N';
      END;
      
      IF v_special_risk = 'Y' THEN
        BEGIN
           SELECT SUM (NVL (a.tsi_amt, 0)), SUM (NVL (a.prem_amt, 0))
             INTO v_tsi_amt, v_prem_amt
             FROM gipi_uwreports_invperil a, gipi_uwreports_ext b
            WHERE a.user_id = p_user_id
              AND a.tab_number = p_tab
              AND NVL (a.special_risk_tag, 'N') = 'Y'
              AND a.user_id = b.user_id
              AND a.tab_number = b.tab_number
              AND a.iss_cd = b.iss_cd
              AND a.prem_seq_no = b.prem_seq_no
              AND a.rec_type = b.rec_type
              AND a.line_cd LIKE NVL (p_line_cd, '%')
              AND DECODE (p_iss_param, 1, NVL (b.cred_branch, b.iss_cd), b.iss_cd) LIKE NVL (p_iss_cd, '%')
              AND b.subline_cd LIKE NVL (p_subline_cd, '%')
              AND (   (p_scope = 1 AND b.endt_seq_no = 0)
                   OR (p_scope = 2 AND b.endt_seq_no > 0)
                   OR (p_scope = 3 AND b.pol_flag = '4')
                   OR (    p_scope = 4
                       AND b.pol_flag = '5'
                       AND NVL (b.reinstate_tag, 'N') =
                              DECODE (p_reinstated, 'Y', 'Y', 'N', NVL (b.reinstate_tag, 'N')))
                   OR (p_scope = 5 AND b.pol_flag <> '5')
                   OR p_scope = 6);--Added by pjsantos 03/14/2017, GENQA 5955

           IF v_tsi_amt <> 0 AND v_prem_amt <> 0
           THEN
              v.print_special_risk := 'Y';
           END IF;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v.print_special_risk := 'N';
        END;
      ELSE
        v.print_special_risk := 'N';
      END IF;

      v.company_name := giisp.v ('COMPANY_NAME');
      v.company_address := giisp.v ('COMPANY_ADDRESS');
      v.date_heading := get_date_heading (p_user_id);
      v.based_on_heading := get_based_on_heading (p_user_id, p_scope, p_reinstated);

      FOR i IN (SELECT   iss_cd, iss_name, line_cd, subline_cd, subline_name,
                         SUM (pol_count) pol_count, SUM (total_tsi) total_tsi,
                         SUM (total_prem) total_prem, SUM (vat) vat,
                         SUM (prem_tax) prem_tax,
                         SUM (vat_prem_tax) vat_prem_tax, SUM (lgt) lgt,
                         SUM (doc_stamps) doc_stamps, SUM (fst) fst,
                         SUM (other_charges) other_charges,
                         SUM (total_amount_due) total_amount_due,
                         SUM (total_taxes) total_taxes,
                         SUM (comm_amt) comm_amt,
                         SUM (wholding_tax) wholding_tax
                    FROM TABLE (gipir923_pkg.get_details (p_iss_cd,
                                                          p_line_cd,
                                                          p_subline_cd,
                                                          p_scope,
                                                          p_iss_param,
                                                          p_user_id,
                                                          p_tab,
                                                          p_reinstated
                                                         )
                               )
                GROUP BY iss_cd, iss_name, line_cd, subline_cd, subline_name
                ORDER BY iss_cd, line_cd, subline_cd)
      LOOP
         v.iss_cd := i.iss_cd;
         v.iss_name := i.iss_name;
         v.line_cd := i.line_cd;
         v.subline_name := i.subline_name;
         v.pol_count := i.pol_count;
         v.total_tsi := i.total_tsi;
         v.total_prem := i.total_prem;
         v.vat := i.vat;
         v.prem_tax := i.prem_tax;
         v.vat_prem_tax := i.vat_prem_tax;
         v.lgt := i.lgt;
         v.doc_stamps := i.doc_stamps;
         v.fst := i.fst;
         v.other_charges := i.other_charges;
         v.total_amount_due := i.total_amount_due;
         v.total_taxes := i.total_taxes;
         v.comm_amt := i.comm_amt;
         v.wholding_tax := i.wholding_tax;
         PIPE ROW (v);
      END LOOP;
   END;

   FUNCTION get_risk_totals (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN risk_totals_tab PIPELINED
   IS
      v                      risk_totals_type;
      v_iss_cd_ri            giis_issource.iss_cd%TYPE := NVL (giisp.v ('ISS_CD_RI'), 'RI');
   BEGIN
    FOR i IN (SELECT SUM (DECODE (NVL (b.special_risk_tag, 'N'),
                                  'Y', DECODE (b.peril_type, 'B', b.tsi_amt, 0),
                                  0
                                 )
                         ) s_total_si,
                     SUM (DECODE (NVL (b.special_risk_tag, 'N'),
                                  'N', DECODE (b.peril_type, 'B', b.tsi_amt, 0),
                                  0
                                 )
                         ) ns_total_si,
                     SUM (DECODE (NVL (b.special_risk_tag, 'N'),
                                  'Y', NVL (b.prem_amt, 0),
                                  0
                                 )
                         ) s_total_prem,
                     SUM (DECODE (NVL (b.special_risk_tag, 'N'),
                                  'N', NVL (b.prem_amt, 0),
                                  0
                                 )
                         ) ns_total_prem,
                     SUM (DECODE (NVL (DECODE (v_iss_cd_ri,
                                               a.iss_cd, b.special_risk_tag,
                                               d.special_risk_tag
                                              ),
                                       'N'
                                      ),
                                  'Y', DECODE (v_iss_cd_ri,
                                               a.iss_cd, NVL (b.ri_comm_amt, 0),
                                               d.commission_amt
                                              ),
                                  0
                                 )
                         ) s_total_comm,
                     SUM
                        (DECODE (NVL (DECODE (v_iss_cd_ri,
                                              a.iss_cd, b.special_risk_tag,
                                              d.special_risk_tag
                                             ),
                                      'N'
                                     ),
                                 'N', DECODE (v_iss_cd_ri,
                                              a.iss_cd, NVL (b.ri_comm_amt, 0),
                                              d.commission_amt
                                             ),
                                 0
                                )
                        ) ns_total_comm,
                     SUM (DECODE (NVL (d.special_risk_tag, 'N'),
                                  'Y', d.wholding_tax,
                                  0
                                 )
                         ) s_total_wholding_tax,
                     SUM (DECODE (NVL (d.special_risk_tag, 'N'),
                                  'N', d.wholding_tax,
                                  0
                                 )
                         ) ns_total_wholding_tax
                FROM gipi_uwreports_ext a,
                     gipi_uwreports_invperil b,
                     gipi_uwreports_comm_invperil d
               WHERE a.user_id = p_user_id
                 AND a.line_cd LIKE NVL (p_line_cd, '%')
                 AND DECODE (p_iss_param,
                             1, NVL (a.cred_branch, a.iss_cd),
                             a.iss_cd
                            ) LIKE NVL (p_iss_cd, '%')
                 AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                 AND (   (p_scope = 1 AND endt_seq_no = 0)
                      OR (p_scope = 2 AND endt_seq_no > 0)
                      OR (p_scope = 3 AND pol_flag = '4')
                      OR (    p_scope = 4
                          AND pol_flag = '5'
                          AND NVL (reinstate_tag, 'N') =
                                 DECODE (p_reinstated,
                                         'Y', 'Y',
                                         'N', NVL (reinstate_tag, 'N')
                                        )
                         )
                      OR (p_scope = 5 AND pol_flag <> '5')
                      OR p_scope = 6) --Added by pjsantos 03/14/2017, GENQA 5955
                 AND a.tab_number = p_tab
                 AND a.policy_id = b.policy_id
                 AND a.iss_cd = b.iss_cd
                 AND a.prem_seq_no = b.prem_seq_no
                 AND a.rec_type = b.rec_type
                 AND a.tab_number = b.tab_number
                 AND a.user_id = b.user_id
                 AND a.policy_id = d.policy_id
                 AND a.iss_cd = d.iss_cd
                 AND a.prem_seq_no = d.prem_seq_no
                 AND a.rec_type = d.rec_type
                 AND a.tab_number = d.tab_number
                 AND a.user_id = d.user_id
                 AND b.peril_cd = d.peril_cd)
     LOOP
       v.s_total_si := NVL (i.s_total_si, 0);
       v.ns_total_si := NVL (i.ns_total_si, 0);
       v.s_total_prem := NVL (i.s_total_prem, 0);
       v.ns_total_prem := NVL (i.ns_total_prem, 0);
       v.s_total_comm := NVL (i.s_total_comm, 0);
       v.ns_total_comm := NVL (i.ns_total_comm, 0);
       v.s_total_wholding_tax := NVL (i.s_total_wholding_tax, 0);
       v.ns_total_wholding_tax := NVL (i.ns_total_wholding_tax, 0);

       PIPE ROW (v);
     END LOOP;
   END get_risk_totals;

   FUNCTION get_date_heading (p_user_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_param_date   NUMBER (1);
      v_from_date    DATE;
      v_to_date      DATE;
      heading3       VARCHAR2 (150);
   BEGIN
      SELECT DISTINCT param_date, from_date, TO_DATE
                 INTO v_param_date, v_from_date, v_to_date
                 FROM gipi_uwreports_ext
                WHERE user_id = p_user_id AND ROWNUM = 1;

      IF v_param_date IN (1, 2, 4)
      THEN
         IF v_from_date = v_to_date
         THEN
            heading3 := 'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      ELSE
         IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
         THEN
            heading3 :=
                'For the Month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      END IF;

      RETURN (heading3);
   END get_date_heading;

   FUNCTION get_based_on_heading (
      p_user_id      VARCHAR2,
      p_scope        VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_param_date     NUMBER (1);
      v_based_on       VARCHAR2 (100);
      v_policy_label   VARCHAR2 (300);
   BEGIN
      SELECT param_date
        INTO v_param_date
        FROM gipi_uwreports_ext
       WHERE user_id = p_user_id AND ROWNUM = 1;

      IF v_param_date = 1
      THEN
         v_based_on := 'Based on Issue Date';
      ELSIF v_param_date = 2
      THEN
         v_based_on := 'Based on Inception Date';
      ELSIF v_param_date = 3
      THEN
         v_based_on := 'Based on Booking Month - Year';
      ELSIF v_param_date = 4
      THEN
         v_based_on := 'Based on Acctg Entry Date';
      END IF;

      IF p_scope = 1
      THEN
         v_policy_label := v_based_on || ' / ' || 'Policies Only';
      ELSIF p_scope = 2
      THEN
         v_policy_label := v_based_on || ' / ' || 'Endorsements Only';
      ELSIF p_scope = 3
      THEN
         v_policy_label := v_based_on || ' / ' || 'Cancelled';
      ELSIF p_scope = 4
      THEN
         v_policy_label := v_based_on || ' / ' || 'Spoiled Policies';

         IF NVL (p_reinstated, 'N') = 'Y'
         THEN
            v_policy_label := v_policy_label || ' - Reinstated Policies Only';
         END IF;
      ELSE
         v_policy_label :=
                       v_based_on || ' / ' || 'All (except spoiled policies)';
      END IF;

      RETURN (v_policy_label);
   END get_based_on_heading;
END gipir924_pkg;
/