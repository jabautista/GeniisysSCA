CREATE OR REPLACE PACKAGE BODY CPI.gipir923_pkg 
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
      RETURN main_tab PIPELINED
   IS
      v                 main_type;
      v_special_risk    giis_document.text%TYPE;
      v_tsi_amt         NUMBER := 0;
      v_prem_amt        NUMBER := 0;
   BEGIN
      BEGIN
         SELECT NVL(text,'N')
           INTO v.show_total_taxes
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'SHOW_TOTAL_TAXES';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v.show_total_taxes := 'N';
      END;

      BEGIN
         SELECT NVL(text,'N')
           INTO v.display_wholding_tax
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'DISPLAY_WHOLDING_TAX';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v.display_wholding_tax := 'N';
      END;

      BEGIN
         SELECT NVL(text,'N')
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
         SELECT NVL(text,'N')
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
                   OR p_scope = 6); --Added by pjsantos 03/14/2017, GENQA 5955

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
      v.company_tin := 'VAT REG TIN ' || giisp.v ('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5962
      v.gen_version := giisp.v ('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5962
      v.date_heading := get_date_heading (p_user_id);
      v.based_on_heading := get_based_on_heading (p_user_id, p_scope, p_reinstated);
      
      PIPE ROW (v);
   END get_main;

   FUNCTION get_details (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN detail_tab PIPELINED
   IS
      v                   detail_type;
      v_print_ref_inv     giis_document.text%TYPE;
      v_rep_date_format   giis_parameters.param_value_v%TYPE;
      v_policy_id         gipi_polbasic.policy_id%TYPE;
      v_text              VARCHAR2(1); --added by gab 11.25.2015
      v_ref_pol_no        VARCHAR2(30); --added by gab 11.25.2015

      TYPE t IS RECORD (
         line_cd              giis_line.line_cd%TYPE,
         subline_cd           giis_subline.subline_cd%TYPE,
         iss_cd               giis_issource.iss_cd%TYPE,
         iss_cd2              giis_issource.iss_cd%TYPE,
         issue_yy             gipi_polbasic.issue_yy%TYPE,
         pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
         renew_no             gipi_polbasic.renew_no%TYPE,
         endt_seq_no          gipi_polbasic.endt_seq_no%TYPE,
         policy_id            gipi_polbasic.policy_id%TYPE,
         policy_no            VARCHAR2 (100),
         dist_flag            gipi_polbasic.dist_flag%TYPE,
         pol_flag             gipi_polbasic.pol_flag%TYPE,
         assd_no              giis_assured.assd_no%TYPE,
         prem_seq_no          gipi_invoice.prem_seq_no%TYPE,
         ref_inv_no           gipi_invoice.ref_inv_no%TYPE,
         issue_date           DATE,
         incept_date          DATE,
         expiry_date          DATE,
         multi_booking_mm     gipi_invoice.multi_booking_mm%TYPE,
         multi_booking_yy     gipi_invoice.multi_booking_yy%TYPE,
         acct_ent_date        DATE,
         spld_date            DATE,
         spld_acct_ent_date   DATE,
         total_tsi            NUMBER,
         total_prem           NUMBER,
         vat                  NUMBER,
         prem_tax             NUMBER,
         lgt                  NUMBER,
         doc_stamps           NUMBER,
         fst                  NUMBER,
         other_charges        NUMBER,
         other_taxes          NUMBER,
         comm_amt             NUMBER,
         wholding_tax         NUMBER,
         param_date           NUMBER,
         reinstate_tag        VARCHAR2 (1),
         tab_number           NUMBER,
         rec_type             gipi_uwreports_ext.rec_type%TYPE
      );

      TYPE t_tab IS TABLE OF t;

      v_t                 t_tab;
   BEGIN
      BEGIN
         SELECT giisp.v ('REP_DATE_FORMAT')
           INTO v_rep_date_format
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      DECLARE
         v_dummy   VARCHAR2 (100);
      BEGIN
         SELECT TO_CHAR (SYSDATE, v_rep_date_format)
           INTO v_dummy
           FROM DUAL;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      BEGIN
         SELECT NVL(text,'N')
           INTO v_print_ref_inv
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'PRINT_REF_INV';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_print_ref_inv := 'N';
      END;
      
      --added by gab 11.25.2015
      BEGIN
          SELECT NVL(text,'N')
          INTO v_text
          FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'INCLUDE_REF_POL_NO';
      EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            v_text := 'N';
      END;

      BEGIN
         SELECT line_cd,
                subline_cd,
                DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd)
                                                                       iss_cd,
                iss_cd iss_cd2,
                issue_yy,
                pol_seq_no,
                renew_no,
                endt_seq_no,
                policy_id,
                   line_cd
                || '-'
                || subline_cd
                || '-'
                || iss_cd
                || '-'
                || LTRIM (TO_CHAR (issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                || '-'
                || LTRIM (TO_CHAR (renew_no, '09'))
                || DECODE (NVL (endt_seq_no, 0),
                           0, '',
                              ' / '
                           || endt_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (endt_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
                          ) policy_no,
                dist_flag,
                pol_flag,
                assd_no,
                prem_seq_no,
                ref_inv_no,
                issue_date,
                incept_date,
                expiry_date,
                multi_booking_mm,
                multi_booking_yy,
                acct_ent_date,
                spld_date,
                spld_acct_ent_date,
                total_tsi,
                total_prem,
                vat,
                prem_tax,
                lgt,
                doc_stamps,
                fst,
                other_charges,
                other_taxes,
                comm_amt,
                wholding_tax,
                param_date,
                reinstate_tag,
                tab_number,
                rec_type
         BULK COLLECT INTO v_t
           FROM gipi_uwreports_ext
          WHERE user_id = p_user_id
          ORDER BY policy_no; --added by gab 11.25.2015
      END;

      FOR i IN 1 .. v_t.LAST
      LOOP
         IF     v_t (i).line_cd LIKE NVL (p_line_cd, '%')
            AND v_t (i).iss_cd LIKE NVL (p_iss_cd, '%')
            AND v_t (i).subline_cd LIKE NVL (p_subline_cd, '%')
            AND (   (p_scope = '1' AND v_t (i).endt_seq_no = 0 AND v_t (i).pol_flag <> '4') --edited by MarkS 8.18.2016 SR21060 to make sure no cancelled policies gets included
                 OR (p_scope = '2' AND v_t (i).endt_seq_no > 0)
                 OR (p_scope = '3' AND v_t (i).pol_flag = '4')
                 OR (    p_scope = '4'
                     AND v_t (i).pol_flag = '5'
                     AND (   (    p_reinstated = 'Y'
                              AND NVL (v_t (i).reinstate_tag, 'N') = 'Y'
                             )
                          OR p_reinstated = 'N'
                         )
                    )
                 OR (p_scope = '5' AND v_t (i).pol_flag <> '5')
                 OR p_scope = '6') --Added by pjsantos 03/14/2017, GENQA 5955
            AND v_t (i).tab_number = p_tab
         THEN
            v.policy_id := v_t (i).policy_id;
            v.line_cd := v_t (i).line_cd;
            v.subline_cd := v_t (i).subline_cd;
            v.issue_yy := v_t (i).issue_yy;
            v.pol_seq_no := v_t (i).pol_seq_no;
            v.renew_no := v_t (i).renew_no;
            v.endt_seq_no := v_t (i).endt_seq_no;
            v.iss_cd := v_t (i).iss_cd;
            v.iss_cd2 := v_t (i).iss_cd2;
            v.assd_no := v_t (i).assd_no;
            v.prem_seq_no := v_t (i).prem_seq_no;
            v.issue_date := TO_CHAR (v_t (i).issue_date, v_rep_date_format);
            v.incept_date := TO_CHAR (v_t (i).incept_date, v_rep_date_format);
            v.expiry_date := TO_CHAR (v_t (i).expiry_date, v_rep_date_format);
            v.booking_date :=
                  v_t (i).multi_booking_mm || ' ' || v_t (i).multi_booking_yy;
            v.acct_ent_date :=
                           TO_CHAR (v_t (i).acct_ent_date, v_rep_date_format);
            v.spld_date := TO_CHAR (v_t (i).spld_date, v_rep_date_format);
            v.spld_acct_ent_date :=
                      TO_CHAR (v_t (i).spld_acct_ent_date, v_rep_date_format);
            v.total_tsi := v_t (i).total_tsi;
            v.total_prem := v_t (i).total_prem;
            v.vat := v_t (i).vat;
            v.prem_tax := v_t (i).prem_tax;
            v.vat_prem_tax := v_t (i).vat + v_t (i).prem_tax;
            v.lgt := v_t (i).lgt;
            v.doc_stamps := v_t (i).doc_stamps;
            v.fst := v_t (i).fst;
            v.other_charges := v_t (i).other_taxes;
            v.other_taxes := v_t (i).other_taxes;
            v.total_taxes :=
                 v_t (i).vat
               + v_t (i).prem_tax
               + v_t (i).lgt
               + v_t (i).doc_stamps
               + v_t (i).fst
               + v_t (i).other_taxes;
            v.total_amount_due :=
                 v_t (i).total_prem
               + v_t (i).vat
               + v_t (i).prem_tax
               + v_t (i).lgt
               + v_t (i).doc_stamps
               + v_t (i).fst
               + v_t (i).other_taxes;
            v.comm_amt := v_t (i).comm_amt;
            v.wholding_tax := v_t (i).wholding_tax;
            --v.policy_no := v_t (i).policy_no; commented out by gab 11.25.2015
            v.param_date := v_t (i).param_date;
            v.spld_label := 'N';

            --added by gab 11.25.2015
            BEGIN
                SELECT ref_pol_no
                INTO v_ref_pol_no
                FROM gipi_polbasic
                WHERE policy_id = v.policy_id;
            END;
            
            --added by gab 11.25.2015
            IF v_text = 'N'
            THEN
                v.policy_no := v_t (i).policy_no;
            ELSIF v_text = 'Y' AND v_ref_pol_no IS NOT NULL OR v_ref_pol_no = ''
            THEN
                v.policy_no := v_t (i).policy_no || ' / ' || v_ref_pol_no;
            ELSE
                v.policy_no := v_t (i).policy_no;
            END IF;    
            
            IF v_t (i).pol_flag = '5'
            THEN
               v.policy_status := 'S';

               IF p_scope IN ('1', '2') AND v_t (i).param_date <> 4 THEN
                  v.comm_amt := 0;
                  v.total_prem := 0;
                  v.wholding_tax := 0;
                  v.total_tsi := NULL;
                  v.total_prem := NULL;
                  v.vat := NULL;
                  v.prem_tax := NULL;
                  v.vat_prem_tax := NULL;
                  v.doc_stamps := NULL;
                  v.fst := NULL;
                  v.lgt := NULL;
                  v.other_charges := NULL;
                  v.other_taxes := NULL;
                  v.total_taxes := NULL;
                  v.total_amount_due := NULL;
                  v.pol_count := 0;
                  v.spld_label := 'Y';
               ELSE
                  v.pol_count := 1;
               END IF;
            ELSE
            	IF v_t (i).pol_flag <> '4' THEN
                    IF p_scope = 5 THEN
                       IF GIISP.V('PRD_POL_CNT') = 1 THEN 
                            v.pol_count := 1;
                       ELSIF GIISP.V('PRD_POL_CNT') = 2 THEN 
                          IF v_t (i).endt_seq_no != 0 THEN
                            v.pol_count := 0;
                          ELSE 
                            v.pol_count := 1;
                          END IF;
                       ELSIF GIISP.V('PRD_POL_CNT') = 3 THEN 
                          IF v_t(i).endt_seq_no != 0 THEN
                            FOR j IN 1..i
                            LOOP
                                IF v_t(j).endt_seq_no = 0 THEN
                                    IF v_t (i).line_cd =  v_t (j).line_cd   AND
                                    v_t (i).subline_cd = v_t (j).subline_cd AND
                                    v_t (i).iss_cd     = v_t (j).iss_cd     AND
                                    v_t (i).issue_yy   = v_t (j).issue_yy   AND
                                    v_t (i).pol_seq_no = v_t (j).pol_seq_no AND
                                    v_t (i).renew_no   = v_t (j).renew_no   AND
                                    check_unique_policy(v_t(i).policy_id,v_t(j).policy_id) = 'F' THEN
                                                            
                                        v.pol_count := 1;
                                                                
                                    ELSE 
                                        v.pol_count := 0;
                                    END IF;
                                ELSE
                                     v.pol_count := 0;   
                                END IF; 
                            END LOOP;
                          ELSE
                            v.pol_count := 1;
                          END IF;
                                               
                       ELSE
                            v.pol_count := 1;
                       END IF;
                    END IF;
                END IF;
	               
               

               IF v_t (i).dist_flag = 3
               THEN
                  v.policy_status := 'D';
               ELSE
                  v.policy_status := 'U';
               END IF;
            END IF;

            BEGIN
               SELECT iss_name
                 INTO v.iss_name
                 FROM giis_issource
                WHERE iss_cd = v_t (i).iss_cd;
            END;

            BEGIN
               SELECT line_name
                 INTO v.line_name
                 FROM giis_line
                WHERE line_cd = v_t (i).line_cd;
            END;

            BEGIN
               SELECT subline_name
                 INTO v.subline_name
                 FROM giis_subline
                WHERE line_cd = v_t (i).line_cd
                  AND subline_cd = v_t (i).subline_cd;
            END;

            BEGIN
               SELECT SUBSTR (TRIM (assd_name), 1, 35)
                 INTO v.assd_name
                 FROM giis_assured
                WHERE assd_no = v_t (i).assd_no;
            END;

            IF v_t (i).prem_seq_no IS NOT NULL
            THEN
               v.invoice_no :=
                     v_t (i).iss_cd2 --iss_cd --replaced by john 12-21-2015;;0021060: UW Prod Report Printing Error #2
                  || '-'
                  || TRIM (TO_CHAR (v_t (i).prem_seq_no, '000000000000'));

               IF v_print_ref_inv = 'Y' AND v_t (i).ref_inv_no IS NOT NULL
               THEN
                  v.invoice_no := v.invoice_no || ' / ' || v_t (i).ref_inv_no;
               END IF;
            ELSE
               v.invoice_no := NULL;
            END IF;

            IF v_policy_id IS NULL OR v_policy_id <> v_t (i).policy_id
            THEN
               v.is_unique := 'Y';
            ELSE
               v.is_unique := 'N';
            END IF;

            IF p_scope = 1 AND v.is_unique = 'N' THEN
                v.pol_count := 0;
            ELSE
                v.pol_count := 1; --added by June Mark SR23492 [12.07.16]
            END IF;

            v_policy_id := v_t (i).policy_id;
            v.user_id := p_user_id;                       -- to be used in csv
            v.rec_type := v_t (i).rec_type;               -- to be used in csv
            PIPE ROW (v);
         END IF;
      END LOOP;
   END get_details;

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
       v             risk_totals_type;
       v_iss_cd_ri   giis_issource.iss_cd%TYPE := NVL (giisp.v ('ISS_CD_RI'), 'RI');
   BEGIN
       FOR i IN
          (SELECT SUM (DECODE (NVL (b.special_risk_tag, 'N'),
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
                  SUM (DECODE (NVL (DECODE (v_iss_cd_ri,
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

   FUNCTION get_recaps (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN recaps_tab PIPELINED
   IS
      v   recaps_type;
   BEGIN
      FOR i IN (SELECT   policy_status, SUM (pol_count) pol_count,
                         SUM (total_prem) total_prem,
                         SUM (comm_amt) total_comm
                    FROM (SELECT policy_status, pol_count, total_prem,
                                 comm_amt
                            FROM TABLE
                                      (gipir923_pkg.get_details (p_iss_cd,
                                                                 p_line_cd,
                                                                 p_subline_cd,
                                                                 p_scope,
                                                                 p_iss_param,
                                                                 p_user_id,
                                                                 p_tab,
                                                                 p_reinstated
                                                                )
                                      )
                          UNION ALL
                          SELECT 'D', 0, 0, 0
                            FROM DUAL
                          UNION ALL
                          SELECT 'U', 0, 0, 0
                            FROM DUAL
                          UNION ALL
                          SELECT 'S', 0, 0, 0
                            FROM DUAL)
                GROUP BY policy_status)
      LOOP
         v.policy_status := i.policy_status;
         v.pol_count := i.pol_count;
         v.total_prem := i.total_prem;
         v.total_comm := i.total_comm;

         IF i.policy_status = 'S'
         THEN
            v.pos := 1;
         ELSIF i.policy_status = 'U'
         THEN
            v.pos := 2;
         ELSE
            v.pos := 3;
         END IF;

         PIPE ROW (v);
      END LOOP;
   END get_recaps;

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
   FUNCTION check_unique_policy(pol_id_i gipi_uwreports_ext.policy_id%TYPE,pol_id_j gipi_uwreports_ext.policy_id%TYPE) 
   RETURN CHAR 
   IS
	v_acct_ent_date_i DATE;
    v_acct_ent_date_j DATE;
    v_incept_date_i DATE;
    v_incept_date_j DATE;
    v_issue_date_i DATE;
    v_issue_date_j DATE;
	BEGIN
    
		BEGIN
			SELECT TRUNC(acct_ent_date), TRUNC(incept_date), TRUNC(issue_date)
			  INTO v_acct_ent_date_i, v_incept_date_i, v_issue_date_i
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
        BEGIN
			SELECT TRUNC(acct_ent_date), TRUNC(incept_date), TRUNC(issue_date)
			  INTO v_acct_ent_date_j, v_incept_date_j, v_issue_date_j
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
      IF NVL(v_acct_ent_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_acct_ent_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) AND 
          NVL(v_incept_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_incept_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) 
          AND NVL(v_issue_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_issue_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) THEN
          RETURN('T');
      ELSE
          RETURN('F');
      END IF;   
	    
	END;
END gipir923_pkg;
/
