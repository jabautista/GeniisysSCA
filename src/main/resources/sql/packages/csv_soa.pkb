CREATE OR REPLACE PACKAGE BODY CPI.csv_soa
AS
   FUNCTION csv_giacr199 (
      p_bal_amt_due   NUMBER,
      p_user          VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_cut_off       DATE
   )
      RETURN giacr199_type PIPELINED
   IS
      v_giacr199        giacr199_rec_type;
      v_branch_name     giis_issource.iss_name%TYPE;
      v_intm_cd         giis_intermediary.ref_intm_cd%TYPE;
      v_address         VARCHAR2 (250);
      v_bm              VARCHAR2 (5);
      v_comm_amt        NUMBER (16, 2);
      v_comm_paid       NUMBER (16, 2);
      v_wholding_tax    NUMBER (16, 2);
      v_gst_amount      NUMBER (16, 2);                     --added by RCDatu
      v_input_vat_amt   NUMBER (16, 2);                     --added by RCDatu
      v_whtax           NUMBER (16, 2);
      v_wtax_paid       NUMBER (16, 2);
      v_net_amt         NUMBER (16, 2);
   BEGIN
      FOR rec IN (SELECT   UPPER (intm_name) intm_name, intm_no, a.intm_type,
                           column_title, a.incept_date, assd_no, assd_name,
                           balance_amt_due, policy_no,
                           iss_cd || '-' || prem_seq_no || '-'
                           || inst_no bill_no,
                           due_date, expiry_date, no_of_days, ref_pol_no,
                           prem_bal_due, tax_bal_due, iss_cd, prem_seq_no,
                           branch_cd, b.col_no, a.inst_no
                      FROM giac_soa_rep_ext a, giac_soa_title b
                     WHERE a.column_no = b.col_no
                       AND balance_amt_due >=
                                          NVL (p_bal_amt_due, balance_amt_due)
                       AND a.user_id = p_user
                       AND intm_no = NVL (p_intm_no, intm_no)
                       AND intm_type = NVL (p_intm_type, intm_type)
                       AND branch_cd = NVL (p_branch_cd, branch_cd)
                       AND due_tag =
                                DECODE (p_inc_overdue,
                                        'I', due_tag,
                                        'N', 'Y'
                                       )
                       AND b.rep_cd = 1
                  ORDER BY intm_no, b.col_no, 7, 5, inst_no)
      LOOP
         --get BRANCH NAME--
         BEGIN
            FOR c IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = rec.branch_cd)
            LOOP
               v_branch_name := c.iss_name;
               EXIT;
            END LOOP;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_branch_name := NULL;
         END;

         --get INTM_CD--
         BEGIN
            FOR c IN (SELECT ref_intm_cd
                        FROM giis_intermediary
                       WHERE intm_no = rec.intm_no)
            LOOP
               v_intm_cd := c.ref_intm_cd;
               EXIT;
            END LOOP;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_intm_cd := NULL;
         END;

         --get ADDRESS--
         BEGIN
            FOR c1 IN
               (SELECT DECODE (SIGN (  3
                                     - NVL (LENGTH (   bill_addr1
                                                    || bill_addr2
                                                    || bill_addr3
                                                   ),
                                            0
                                           )
                                    ),
                               1, 'MAIL',
                               -1, 'BILL',
                               'MAIL'
                              ) addr
                  FROM giis_intermediary
                 WHERE intm_no = rec.intm_no)
            LOOP
               v_bm := c1.addr;
               EXIT;
            END LOOP;

            IF (v_bm = 'MAIL' OR v_bm IS NULL)
            THEN
               SELECT    mail_addr1
                      || DECODE (mail_addr2, NULL, '', ' ')
                      || mail_addr2
                      || DECODE (mail_addr3, NULL, '', ' ')
                      || mail_addr3
                 INTO v_address
                 FROM giis_intermediary
                WHERE intm_no = rec.intm_no;
            ELSIF v_bm = 'BILL'
            THEN
               SELECT    bill_addr1
                      || DECODE (bill_addr2, NULL, '', ' ')
                      || bill_addr2
                      || DECODE (bill_addr3, NULL, '', ' ')
                      || bill_addr3
                 INTO v_address
                 FROM giis_intermediary
                WHERE intm_no = rec.intm_no;
            ELSE
               v_address := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_address :=
                        'NO SUCH INTERMEDIARY AVAILABLE IN GIIS_INTERMEDIARY';
            WHEN TOO_MANY_ROWS
            THEN
               v_address :=
                           'TOO MANY VALUES FOR ADDRESS IN GIIS_INTERMEDIARY';
            WHEN OTHERS
            THEN
               v_address := NULL;
         END;

         --get COMM_AMT--
--         BEGIN
--            FOR c IN
--               (SELECT   gspe.gacc_tran_id, SUM (gspe.comm_amt) comm_amt
--                    FROM giac_comm_payts gspe, giac_acctrans c
--                   WHERE gspe.gacc_tran_id = c.tran_id
--                     AND gspe.gacc_tran_id NOT IN (
--                            SELECT a.tran_id
--                              FROM giac_acctrans a, giac_reversals b
--                             WHERE b.reversing_tran_id = a.tran_id
--                               AND a.tran_flag <> 'D')
--                     AND gspe.intm_no = rec.intm_no
--                     AND gspe.iss_cd = rec.iss_cd
--                     AND gspe.prem_seq_no = rec.prem_seq_no
--                     AND TRUNC (c.tran_date) <= TRUNC (TO_DATE (p_cut_off))
--                GROUP BY gspe.gacc_tran_id)
--            LOOP
--               v_comm_paid := c.comm_amt;
--               EXIT;
--            END LOOP;

         --            IF v_comm_paid IS NULL
--            THEN
--               v_comm_paid := 0;
--            END IF;

         --            FOR a IN (SELECT commission_amt
--                        FROM gipi_comm_invoice
--                       WHERE intrmdry_intm_no = rec.intm_no
--                         AND iss_cd = rec.iss_cd
--                         AND prem_seq_no = rec.prem_seq_no)
--            LOOP
--               v_comm_amt := a.commission_amt;
--               EXIT;
--            END LOOP;

         --            IF v_comm_amt IS NULL
--            THEN
--               v_comm_amt := 0;
--            END IF;

         --            v_comm_amt := v_comm_amt - v_comm_paid;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               v_comm_amt := NULL;
--         END;
         ---Modified get_comm amt
         v_comm_amt :=
            get_giacr199_comm_amt (p_bal_amt_due,
                                   rec.iss_cd,
                                   rec.prem_seq_no,
                                   rec.intm_no,
                                   rec.inst_no,
                                   p_cut_off,
                                   p_user          -- added by MarkS 5.18.2016 SR-22192
                                  );
         --get GST-- --Added by RCDatu--
         v_gst_amount :=
            get_gstformula (rec.iss_cd,
                            rec.prem_seq_no,
                            rec.intm_no,
                            p_cut_off
                           );
         v_input_vat_amt :=
            get_input_vatformula (rec.iss_cd,
                                  rec.prem_seq_no,
                                  rec.intm_no,
                                  rec.inst_no,
                                  p_cut_off,
                                  p_user          -- added by MarkS 5.18.2016 SR-22192
                                 );

         --get WHOLDING_TAX--
         BEGIN
         	--added by Daniel Marasigan SR 22232 07.11.2016; reset variable values
            v_wtax_paid := 0; 
            v_whtax := 0;
            
            FOR c IN
               (SELECT   gspe.gacc_tran_id, SUM (gspe.wtax_amt) wtax_amt
                    FROM giac_comm_payts gspe, giac_acctrans c
                   WHERE gspe.gacc_tran_id = c.tran_id
                     AND gspe.gacc_tran_id NOT IN (
                            SELECT a.tran_id
                              FROM giac_acctrans a, giac_reversals b
                             WHERE b.reversing_tran_id = a.tran_id
                               AND a.tran_flag <> 'D')
                     AND gspe.intm_no = rec.intm_no
                     AND gspe.iss_cd = rec.iss_cd
                     AND gspe.prem_seq_no = rec.prem_seq_no
                     AND TRUNC (c.tran_date) <= TRUNC (TO_DATE (p_cut_off))
                GROUP BY gspe.gacc_tran_id)
            LOOP
               v_wtax_paid := c.wtax_amt;
               EXIT;
            END LOOP;

--            IF v_wtax_paid IS NULL --commented out by Daniel Marasigan
--            THEN
--               v_wtax_paid := 0;
--            END IF;

            FOR c IN (SELECT (NVL (wholding_tax, 0) * NVL (currency_rt, 1) --modified by Daniel Marasigan SR 22232; match PDF report
                             ) wholding_tax
                        FROM gipi_comm_invoice a, gipi_invoice b
                       WHERE a.iss_cd = b.iss_cd
                         AND a.intrmdry_intm_no = rec.intm_no
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.iss_cd = rec.iss_cd
                         AND a.prem_seq_no = rec.prem_seq_no)
            LOOP
               v_whtax := c.wholding_tax;
            END LOOP;

--            IF v_whtax IS NULL --commented out by Daniel Marasigan
--            THEN
--               v_whtax := 0;
--            END IF;

            v_wholding_tax := v_whtax - v_wtax_paid;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_wholding_tax := NULL;
         END;

         --get NET_AMT--
         BEGIN
            IF NVL (giacp.v ('APPLY_GST'), 'N') = 'Y'
            THEN
               v_net_amt :=
                    NVL (rec.balance_amt_due, 0)
                  - (NVL (v_comm_amt, 0)                              --RCDATU
                     + NVL (v_gst_amount, 0));
            ELSE
               v_net_amt :=
                    NVL (rec.balance_amt_due, 0)
                  - (  NVL (v_comm_amt, 0)
                     - NVL (v_wholding_tax, 0)
                     + NVL (v_input_vat_amt, 0)
                    );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_net_amt := NULL;
         END;

         v_giacr199.branch_name := v_branch_name;
         v_giacr199.intm_no := rec.intm_no;
         v_giacr199.intm_cd := v_intm_cd;
         v_giacr199.intm_name := rec.intm_name;
         v_giacr199.address := v_address;
         v_giacr199.col_title := rec.column_title;
         v_giacr199.policy_no := rec.policy_no;
         v_giacr199.ref_pol_no := rec.ref_pol_no;
         v_giacr199.assd_name := rec.assd_name;
         v_giacr199.bill_no := rec.bill_no;
         v_giacr199.expiry_date := rec.expiry_date;
         v_giacr199.incept_date := rec.incept_date;
         v_giacr199.due_date := rec.due_date;
         v_giacr199.no_of_days := rec.no_of_days;
         v_giacr199.prem_amt := rec.prem_bal_due;
         v_giacr199.tax_amt := rec.tax_bal_due;
         v_giacr199.balance_amt := rec.balance_amt_due;
         v_giacr199.comm_amt := v_comm_amt;
         v_giacr199.wholding_tax := v_wholding_tax;
         v_giacr199.input_vat_amt := v_input_vat_amt; --added by Daniel Marasigan SR 22232
         v_giacr199.gst := v_gst_amount;
         v_giacr199.net_amt := v_net_amt;
         PIPE ROW (v_giacr199);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_whtaxformula (
      intmd_no      NUMBER,
      branch_cd     VARCHAR2,
      prem_seq_no   NUMBER,
      cut_off       VARCHAR2
   )
      RETURN NUMBER
   IS
      v_whtax            giac_comm_payts.wtax_amt%TYPE;
      v_wtax_paid        giac_comm_payts.wtax_amt%TYPE;
      int_no             giac_comm_payts.intm_no%TYPE;
      issue_cd           giac_comm_payts.iss_cd%TYPE;
      prem_sequence_no   giac_comm_payts.prem_seq_no%TYPE;
      v_currency_rt      gipi_invoice.currency_rt%TYPE;
   -- added by Jayson 01.21.2011
   BEGIN
      int_no := intmd_no;
      issue_cd := branch_cd;
      prem_sequence_no := prem_seq_no;

      FOR c IN
         (SELECT   gspe.gacc_tran_id, SUM (gspe.wtax_amt) wtax_amt
              FROM giac_comm_payts gspe, giac_acctrans c
             WHERE gspe.gacc_tran_id = c.tran_id
               AND gspe.gacc_tran_id NOT IN (
                      SELECT a.tran_id
                        FROM giac_acctrans a, giac_reversals b
                       WHERE b.reversing_tran_id = a.tran_id
                         AND a.tran_flag <> 'D')
               AND gspe.intm_no = int_no
               AND gspe.iss_cd = issue_cd
               AND gspe.prem_seq_no = prem_sequence_no
               AND TRUNC (c.tran_date) <= TRUNC (TO_DATE (cut_off))
          GROUP BY gspe.gacc_tran_id)
      LOOP
         v_wtax_paid := c.wtax_amt;
         EXIT;
      END LOOP;

      IF v_wtax_paid IS NULL
      THEN
         v_wtax_paid := 0;
      END IF;

      -- START added by Jayson 01.21.2011 --
      SELECT currency_rt
        INTO v_currency_rt
        FROM gipi_invoice
       WHERE iss_cd = issue_cd AND prem_seq_no = prem_sequence_no;

      -- END added by Jayson 01.21.2011 --
      FOR c IN (SELECT wholding_tax
                  FROM gipi_comm_invoice
                 WHERE intrmdry_intm_no = int_no
                   AND iss_cd = issue_cd
                   AND prem_seq_no = prem_sequence_no)
      LOOP
         v_whtax := c.wholding_tax * v_currency_rt;
      -- added by Jayson 01.21.2011
      END LOOP;

      IF v_whtax IS NULL
      THEN
         v_whtax := 0;
      END IF;

      RETURN (v_whtax - v_wtax_paid);
   END;

   FUNCTION cf_1formula
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_title   VARCHAR2 (100);
   BEGIN
      v_title := giacp.v ('SOA_TITLE');
      RETURN (v_title);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
      WHEN TOO_MANY_ROWS
      THEN
         v_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
   END;

   FUNCTION cf_1formula0034
      --copied from the report GIACR199.rdf, i edited a little
   RETURN VARCHAR2
   IS
      v_date_label   VARCHAR2 (100);
   BEGIN
      v_date_label := giacp.v ('SOA_DATE_LABEL');
      RETURN (v_date_label);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_date_label := '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
      WHEN TOO_MANY_ROWS
      THEN
         v_date_label :=
                        '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
   END;

   FUNCTION cf_dateformula
      --copied from the report GIACR199.rdf, i edited a little
   RETURN DATE
   IS
      v_date   DATE;
   BEGIN
      FOR c IN (SELECT param_date
                  FROM giac_soa_rep_ext
                 WHERE user_id = USER AND ROWNUM = 1)
      LOOP
         v_date := c.param_date;
         EXIT;
      END LOOP;

      IF v_date IS NULL
      THEN
         v_date := SYSDATE;
      END IF;

      RETURN (v_date);
   END;

   FUNCTION cf_1formula0038
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_signatory   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT signatory
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR199')
      LOOP
         v_signatory := i.signatory;
         EXIT;
      END LOOP;

      RETURN (v_signatory);
   END;

   FUNCTION cf_1formula0005
      RETURN DATE
   IS                 --copied from the report GIACR199.rdf, i edited a little
   BEGIN
      RETURN (SYSDATE);
   END;

   FUNCTION cf_ref_intm_cdformula (intmd_no giis_intermediary.intm_no%TYPE)
      RETURN VARCHAR2
   IS                                               --copied from GIACR199 rdf
      v_ref_intm   VARCHAR2 (50);
   BEGIN
      FOR c IN (SELECT ref_intm_cd
                  FROM giis_intermediary
                 WHERE intm_no = intmd_no)
      LOOP
         v_ref_intm := c.ref_intm_cd;
         EXIT;
      END LOOP;

      RETURN (v_ref_intm);
   END;

   FUNCTION cf_net_amtformula (
      bal_amt_due   NUMBER,
      comm_amt      NUMBER,
      whtax         NUMBER
   )
      RETURN NUMBER
   IS
      v_net   NUMBER;
   BEGIN
      v_net := NVL (bal_amt_due, 0) - NVL (comm_amt, 0) + NVL (whtax, 0);
      RETURN (v_net);
   END;

   FUNCTION cf_1formula0040
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_label   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT label
                  FROM giac_rep_signatory
                 WHERE report_id = 'GIACR199')
      LOOP
         v_label := i.label;
         EXIT;
      END LOOP;

      RETURN (v_label);
   END;

   FUNCTION cf_intm_addformula (intmd_no giis_intermediary.intm_no%TYPE)
      RETURN VARCHAR2
   IS
      v_intm_add   VARCHAR2 (250);
      v_bm         VARCHAR2 (5);
   BEGIN
      FOR c1 IN (SELECT DECODE (SIGN (  3
                                      - NVL (LENGTH (   bill_addr1
                                                     || bill_addr2
                                                     || bill_addr3
                                                    ),
                                             0
                                            )
                                     ),
                                1, 'MAIL',
                                -1, 'BILL',
                                'MAIL'
                               ) addr
                   FROM giis_intermediary
                  WHERE intm_no = intmd_no)
      LOOP
         v_bm := c1.addr;
         EXIT;
      END LOOP;

      IF (v_bm = 'MAIL' OR v_bm IS NULL)
      THEN
         SELECT    mail_addr1
                || DECODE (mail_addr2, NULL, '', ' ')
                || mail_addr2
                || DECODE (mail_addr3, NULL, '', ' ')
                || mail_addr3
           INTO v_intm_add
           FROM giis_intermediary
          WHERE intm_no = intmd_no;

         RETURN (v_intm_add);
      ELSIF v_bm = 'BILL'
      THEN
         SELECT    bill_addr1
                || DECODE (bill_addr2, NULL, '', ' ')
                || bill_addr2
                || DECODE (bill_addr3, NULL, '', ' ')
                || bill_addr3
           INTO v_intm_add
           FROM giis_intermediary
          WHERE intm_no = intmd_no;

         RETURN (v_intm_add);
      ELSE
         v_intm_add := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
         RETURN (v_intm_add);
      END IF;

      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_intm_add := 'NO SUCH INTERMEDIARY AVAILABLE IN GIIS_INTERMEDIARY';
         RETURN (v_intm_add);
      WHEN TOO_MANY_ROWS
      THEN
         v_intm_add := 'TOO MANY VALUES FOR ADDRESS IN GIIS_INTERMEDIARY';
         RETURN (v_intm_add);
   END;

   FUNCTION cf_inceptformula (the_prem_seq_no NUMBER, branch_cd VARCHAR2)
      RETURN DATE
   IS
      v_pol_id        NUMBER (12);
      v_incept        DATE;                                        --TAPOS NA
      v_prem_seq_no   gipi_invoice.prem_seq_no%TYPE;
      v_branch_cd     gipi_invoice.iss_cd%TYPE;
   BEGIN
      v_prem_seq_no := the_prem_seq_no;
      v_branch_cd := branch_cd;

      FOR a IN
         (SELECT policy_id
            FROM gipi_invoice --gipi_comm_invoice replaced by lina 02/06/2007
           WHERE 1 = 1       --intrmdry_intm_no = :intm_no1 commented by lina
             AND iss_cd = branch_cd
             AND prem_seq_no = v_prem_seq_no)
      LOOP
         v_pol_id := a.policy_id;
         EXIT;
      END LOOP;

      SELECT incept_date
        INTO v_incept
        FROM gipi_polbasic
       WHERE policy_id = v_pol_id;

      RETURN (TRUNC (v_incept));
   END;

   FUNCTION cf_designationformula
      RETURN CHAR
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_designation   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT designation
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR199')
      LOOP
         v_designation := i.designation;
         EXIT;
      END LOOP;

      RETURN (v_designation);
   END;

   FUNCTION cf_date_tag2formula
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_tag          VARCHAR2 (5);
      v_name1        VARCHAR2 (75);
      v_name2        VARCHAR2 (75);
      v_from_date1   DATE;
      v_to_date1     DATE;
      v_from_date2   DATE;
      v_to_date2     DATE;
      v_and          VARCHAR2 (25);
      dsp_name       VARCHAR2 (300);
      dsp_name2      VARCHAR2 (200);
      v_as_of_date   DATE;                                      --lems 121007
   BEGIN
      FOR c IN (SELECT date_tag, from_date1, to_date1, from_date2, to_date2,
                       as_of_date                               --lems 121007
                  FROM giac_soa_rep_ext
                 WHERE user_id = USER AND ROWNUM = 1)
      LOOP
         v_tag := c.date_tag;
         v_from_date1 := c.from_date1;
         v_to_date1 := c.to_date1;
         v_from_date2 := c.from_date2;
         v_to_date2 := c.to_date2;
         v_as_of_date := c.as_of_date;                          --lems 121007
         EXIT;
      END LOOP;

      /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
      --lems 121007
      IF v_as_of_date IS NOT NULL
      THEN
         v_name1 :=
                  'As Of Date ' || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
      --lems 121007
      ELSIF v_tag = 'BK'
      THEN
         v_name1 :=
               'Booking Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IN'
      THEN
         v_name1 :=
               'Inception Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IS'
      THEN
         v_name1 :=
               'Issue Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'BKIN'
      THEN
         v_name1 :=
               'Booking Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 :=
               'Inception Dates from '
            || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
      ELSIF v_tag = 'BKIS'
      THEN
         v_name1 :=
               'Booking Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 :=
               'Issue Dates from '
            || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
      ELSE
         dsp_name := '(Unknown Basis of Extraction)';
      END IF;

      SELECT DECODE (v_name2, NULL, NULL, ' and ')
        INTO v_and
        FROM DUAL;

      dsp_name := ('Based on ' || v_name1);
      /*PASS THE SECOND NAME TO CF_DATE_TAG2*/
      dsp_name2 := (v_and || v_name2);
      RETURN (dsp_name2);
   END;

   FUNCTION cf_date_tagformula
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_tag          VARCHAR2 (5);
      v_name1        VARCHAR2 (75);
      v_name2        VARCHAR2 (75);
      v_from_date1   DATE;
      v_to_date1     DATE;
      v_from_date2   DATE;
      v_to_date2     DATE;
      v_and          VARCHAR2 (25);
      dsp_name       VARCHAR2 (300);
      dsp_name2      VARCHAR2 (200);
      v_as_of_date   DATE;                                      --lems 121007
   BEGIN
      FOR c IN (SELECT date_tag, from_date1, to_date1, from_date2, to_date2,
                       as_of_date                               --lems 121007
                  FROM giac_soa_rep_ext
                 WHERE user_id = USER AND ROWNUM = 1)
      LOOP
         v_tag := c.date_tag;
         v_from_date1 := c.from_date1;
         v_to_date1 := c.to_date1;
         v_from_date2 := c.from_date2;
         v_to_date2 := c.to_date2;
         v_as_of_date := c.as_of_date;                          --lems 121007
         EXIT;
      END LOOP;

      /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
      --lems 121007
      IF v_as_of_date IS NOT NULL
      THEN
         v_name1 :=
                   'As Of Date ' || TO_CHAR (v_as_of_date, 'fmMonth DD YYYY');
      --lems 121007
      ELSIF v_tag = 'BK'
      THEN
         v_name1 :=
               'Booking Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IN'
      THEN
         v_name1 :=
               'Inception Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IS'
      THEN
         v_name1 :=
               'Issue Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'BKIN'
      THEN
         v_name1 :=
               'Booking Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD YYYY');
         v_name2 :=
               'Inception Dates from '
            || TO_CHAR (v_from_date2, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD YYYY');
      ELSIF v_tag = 'BKIS'
      THEN
         v_name1 :=
               'Booking Dates from '
            || TO_CHAR (v_from_date1, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD YYYY');
         v_name2 :=
               'Issue Dates from '
            || TO_CHAR (v_from_date2, 'fmMonth DD YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD YYYY');
      ELSE
         dsp_name := '(Unknown Basis of Extraction)';
      END IF;

      SELECT DECODE (v_name2, NULL, NULL, ' and ')
        INTO v_and
        FROM DUAL;

      dsp_name := ('Based on ' || v_name1);
      /*PASS THE SECOND NAME TO CF_DATE_TAG2*/
      dsp_name2 := (v_and || v_name2);
      RETURN (dsp_name);
   END;

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_name   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
         RETURN (v_name);
      WHEN TOO_MANY_ROWS
      THEN
         v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
         RETURN (v_name);
   END;

   FUNCTION cf_company_addformula
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_add   VARCHAR2 (350);
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
      WHEN TOO_MANY_ROWS
      THEN
         v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
   END;

   FUNCTION cf_comm_amtformula (
      intmd_no      NUMBER,
      branch_cd     VARCHAR2,
      cut_off       DATE,
      prem_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_comm             gipi_comm_invoice.commission_amt%TYPE;
      v_comm_paid        gipi_comm_invoice.commission_amt%TYPE;
      int_no             giac_comm_payts.intm_no%TYPE;
      issue_cd           giac_comm_payts.iss_cd%TYPE;
      prem_sequence_no   giac_comm_payts.prem_seq_no%TYPE;
      v_currency_rt      gipi_invoice.currency_rt%TYPE;
   -- added by Jayson 01.21.2011
   BEGIN
      int_no := intmd_no;
      issue_cd := branch_cd;
      prem_sequence_no := prem_seq_no;

      FOR c IN
         (SELECT   gspe.gacc_tran_id, SUM (gspe.comm_amt) comm_amt
              FROM giac_comm_payts gspe, giac_acctrans c
             WHERE gspe.gacc_tran_id = c.tran_id
               AND gspe.gacc_tran_id NOT IN (
                      SELECT a.tran_id
                        FROM giac_acctrans a, giac_reversals b
                       WHERE b.reversing_tran_id = a.tran_id
                         AND a.tran_flag <> 'D')
               AND gspe.intm_no = int_no
               AND gspe.iss_cd = issue_cd
               AND gspe.prem_seq_no = prem_sequence_no
               AND TRUNC (c.tran_date) <= TRUNC ((cut_off))
          GROUP BY gspe.gacc_tran_id)
      LOOP
         v_comm_paid := c.comm_amt;
         EXIT;
      END LOOP;

      IF v_comm_paid IS NULL
      THEN
         v_comm_paid := 0;
      END IF;

      -- START added by Jayson 01.21.2011 --
      SELECT currency_rt
        INTO v_currency_rt
        FROM gipi_invoice
       WHERE iss_cd = issue_cd AND prem_seq_no = prem_sequence_no;

      -- END added by Jayson 01.21.2011 --
      FOR a IN (SELECT commission_amt
                  FROM gipi_comm_invoice
                 WHERE intrmdry_intm_no = int_no
                   AND iss_cd = issue_cd
                   AND prem_seq_no = prem_sequence_no)
      LOOP
         v_comm := a.commission_amt * v_currency_rt;
         -- added v_currency_rt by Jayson 01.21.2011
         EXIT;
      END LOOP;

      IF v_comm IS NULL
      THEN
         v_comm := 0;
      END IF;

      v_comm := v_comm - v_comm_paid;
      RETURN (v_comm);
   END;

/* IF V_COMM_PAID IS NOT NULL THEN
  RETURN (V_COMM);
 ELSE
  V_COMM := 0;
  RETURN (V_COMM);
 END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     V_COMM := 0;
     RETURN (V_COMM);
  WHEN TOO_MANY_ROWS THEN
     V_COMM := 101010101;
     RETURN (V_COMM);
end;*/
   FUNCTION cf_branch_nameformula (branch_cd giis_issource.iss_cd%TYPE)
      RETURN VARCHAR2
   IS                 --copied from the report GIACR199.rdf, i edited a little
      v_branch_name   giis_issource.iss_name%TYPE;
   BEGIN
      FOR c IN (SELECT iss_name
                  FROM giis_issource
                 WHERE iss_cd = branch_cd)
      LOOP
         v_branch_name := c.iss_name;
         EXIT;
      END LOOP;

      RETURN (v_branch_name);
   END;

   FUNCTION m_8formattrigger
      RETURN BOOLEAN
   IS                                               --copied from GIACR199 rdf
      v_expiry   VARCHAR2 (1);
   BEGIN
      v_expiry := giacp.v ('SOA_EXPIRY');

      IF v_expiry = 'Y'
      THEN
         RETURN (TRUE);
      ELSE
         RETURN (FALSE);
      END IF;
   END;

   FUNCTION csv_giacr296 (                          --added by jcDY 11.17.2011
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN giacr296_type PIPELINED
   IS
      v_giacr296   giacr296_rec_type;
   BEGIN
      FOR rec IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name,
                           a.eff_date, a.booking_date, a.binder_no,
                           a.policy_no, a.assd_name, a.lprem_amt,
                           a.lprem_vat, a.lcomm_amt, a.lcomm_vat,
                           a.lwholding_vat, a.lnet_due
                      FROM giis_line b, giac_outfacul_soa_ext a
                     WHERE a.line_cd = b.line_cd
                       AND a.cut_off_date = p_cut_off_date
                       AND a.as_of_date = p_as_of_date
                       AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND a.lnet_due <> 0
                       AND a.user_id = /*USER*/ p_user_id -- added replaced user with p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
                  ORDER BY a.ri_name,
                           b.line_name,
                           a.eff_date,
                           a.booking_date,
                           a.binder_no,
                           a.policy_no)
      LOOP
         v_giacr296.ri_cd := rec.ri_cd;
         v_giacr296.ri_name := rec.ri_name;
         v_giacr296.line_cd := rec.line_cd;
         v_giacr296.line_name := rec.line_name;
         v_giacr296.eff_date := rec.eff_date;
         v_giacr296.booking_date := rec.booking_date;
         v_giacr296.binder_no := rec.binder_no;
         v_giacr296.policy_no := rec.policy_no;
         v_giacr296.assd_name := rec.assd_name;
         v_giacr296.lprem_amt := rec.lprem_amt;
         v_giacr296.lprem_vat := rec.lprem_vat;
         v_giacr296.lcomm_amt := rec.lcomm_amt;
         v_giacr296.lcomm_vat := rec.lcomm_vat;
         v_giacr296.lwholding_vat := rec.lwholding_vat;
         v_giacr296.lnet_due := rec.lnet_due;
         PIPE ROW (v_giacr296);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_giacr296a_old (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN giacr296a_type PIPELINED
   IS
      v_giacr296a   giacr296a_rec_type;
   BEGIN
      FOR rec IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name,
                           a.eff_date, a.booking_date, a.binder_no,
                           a.policy_no, a.assd_name, a.lprem_amt,
                           a.lprem_vat, a.lcomm_amt, a.lcomm_vat,
                           a.lwholding_vat, a.lnet_due, a.policy_id,
                           a.fnl_binder_id, c.column_no, c.column_title
                      FROM giis_line b,
                           giac_outfacul_soa_ext a,
                           giis_report_aging c
                     WHERE a.line_cd = b.line_cd
                       AND a.cut_off_date = p_cut_off_date
                       AND a.as_of_date = p_as_of_date
                       AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND a.lnet_due <> 0
                       AND c.report_id = 'GIACR296'
                       AND c.column_no = a.column_no
                       AND a.user_id = /*USER*/ p_user_id-- added replaced user with p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
                  ORDER BY a.ri_name,
                           b.line_name,
                           a.eff_date,
                           a.booking_date,
                           a.binder_no,
                           a.policy_no)
      LOOP
         v_giacr296a.ri_cd := rec.ri_cd;
         v_giacr296a.ri_name := rec.ri_name;
         v_giacr296a.line_cd := rec.line_cd;
         v_giacr296a.line_name := rec.line_name;
         v_giacr296a.eff_date := rec.eff_date;
         v_giacr296a.booking_date := rec.booking_date;
         v_giacr296a.binder_no := rec.binder_no;
         v_giacr296a.policy_no := rec.policy_no;
         v_giacr296a.assd_name := rec.assd_name;
         v_giacr296a.lprem_amt := rec.lprem_amt;
         v_giacr296a.lprem_vat := rec.lprem_vat;
         v_giacr296a.lcomm_amt := rec.lcomm_amt;
         v_giacr296a.lcomm_vat := rec.lcomm_vat;
         v_giacr296a.lwholding_vat := rec.lwholding_vat;
         v_giacr296a.lnet_due := rec.lnet_due;
         v_giacr296a.policy_id := rec.policy_id;
         v_giacr296a.fnl_binder_id := rec.fnl_binder_id;
         v_giacr296a.column_no := rec.column_no;
         v_giacr296a.column_title := rec.column_title;
         PIPE ROW (v_giacr296a);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION csv_giacr296a_query (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
 RETURN dyn_sql_query_tab
       PIPELINED
    IS
       v_cntAgingParams   NUMBER := 0;
       v_query            VARCHAR2(32767);
       v_dynQuery         dyn_sql_query;
    BEGIN
       v_query :=
             'SELECT a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, a.booking_date, a.binder_no,a.ppw,a.policy_no, a.assd_name, a.lprem_amt,'
              || 'a.lprem_vat, a.lcomm_amt, a.lcomm_vat,a.lwholding_vat, a.lnet_due, a.policy_id,a.fnl_binder_id';


       v_cntAgingParams := 0;

       FOR ctr
          IN (  SELECT column_no, column_title
                  FROM TABLE (
                          csv_soa.get_giacr296_agingCols ('GIACR296', p_user_id))
              ORDER BY column_no)
       LOOP
          IF v_cntAgingParams = 0
          THEN
             v_query :=
                   v_query
                || ' , DECODE (a.column_no, '
                || ctr.column_no
                || ', NVL (a.lnet_due, 0), 0) ';
          ELSE
             v_query :=
                   v_query
                || ' || '','' ||  DECODE (a.column_no, '
                || ctr.column_no
                || ', NVL (a.lnet_due, 0), 0) ';
          END IF;

          v_cntAgingParams := v_cntAgingParams + 1;
       END LOOP;
       
       IF v_cntAgingParams = 0 THEN
            v_query :=  v_query || ' , 0 aging  ';       
       END IF; 


       v_query :=
             v_query
          || ' FROM giis_line b, giac_outfacul_soa_ext a'          
          || ' WHERE  a.line_cd = b.line_cd '
          || ' AND a.cut_off_date = '''
          || p_cut_off_date
          || ''''
          || ' AND a.as_of_date = '''
          || p_as_of_date
          || '''';

       IF p_ri_cd IS NULL
       THEN
          v_query := v_query || ' AND a.ri_cd = NVL ( NULL , a.ri_cd) ';
       ELSE
          v_query := v_query || ' AND a.ri_cd = NVL (' || p_ri_cd || ', a.ri_cd) ';
       END IF;


       IF p_line_cd IS NULL
       THEN
          v_query := v_query || ' AND a.line_cd = NVL (NULL, a.line_cd) ';
       ELSE
          v_query :=
                v_query
             || ' AND a.line_cd = NVL ('''
             || p_line_cd
             || ''', a.line_cd) ';
       END IF;

       v_query :=
             v_query
          || '  AND a.lnet_due <> 0 AND a.user_id = '''
          || p_user_id
          || ''''
          || '  ORDER BY a.ri_name,b.line_name,a.eff_date,a.booking_date,a.binder_no,a.policy_no';

       v_dynQuery.query1 := SUBSTR (v_query, 1, 4000);
       v_dynQuery.query2 := SUBSTR (v_query, 4001, 8000);
       v_dynQuery.query3 := SUBSTR (v_query, 8001, 12000);
       v_dynQuery.query4 := SUBSTR (v_query, 12001, 16000);
       v_dynQuery.query5 := SUBSTR (v_query, 16001, 20000);
       v_dynQuery.query6 := SUBSTR (v_query, 20001, 24000);
       v_dynQuery.query7 := SUBSTR (v_query, 24001, 28000);
       v_dynQuery.query8 := SUBSTR (v_query, 28001, 32000);

       PIPE ROW (v_dynQuery);

       RETURN;
   END;

   FUNCTION csv_giacr296a (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN csv_rec_tab PIPELINED
    IS
       v_cntAgingParams   NUMBER := 0;
       v_query            VARCHAR2(32767);
       v_rec              csv_rec_type ; 
       v_header           VARCHAR2(32767); 
       
       
       TYPE giacr296a_rec2_type IS RECORD (
          ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
          ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
          line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
          line_name       giis_line.line_name%TYPE,
          eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
          booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
          binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
          ppw             giac_outfacul_soa_ext.ppw%TYPE,
          policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
          assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
          lprem_amt       giac_outfacul_soa_ext.lprem_amt%TYPE,
          lprem_vat       giac_outfacul_soa_ext.lprem_vat%TYPE,
          lcomm_amt       giac_outfacul_soa_ext.lcomm_amt%TYPE,
          lcomm_vat       giac_outfacul_soa_ext.lcomm_vat%TYPE,
          lwholding_vat   giac_outfacul_soa_ext.lwholding_vat%TYPE,
          lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE,
          policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
          fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
          aging_due_bal    VARCHAR2 (32767)
       );

       TYPE giacr296a_tab2 IS TABLE OF giacr296a_rec2_type;  
       
       v_temp_tbl   giacr296a_tab2;
                            
    BEGIN
    
       -- generate the header first 
       v_header  := 'RI CODE,RI NAME,LINE CODE,LINE NAME,EFF DATE,BOOKING DATE,BINDER NUMBER,PPW,POLICY NUMBER,ASSURED NAME,PREMIUM AMT,VAT ON PREM,'
       || 'COMMISSION AMT,VAT ON COMMISSION,WHOLDING VAT,NET DUE,POLICY ID, FNL BINDER ID';


       v_cntAgingParams := 0;

       FOR ctr
          IN (  SELECT column_no, column_title
                  FROM TABLE (
                          csv_soa.get_giacr296_agingCols ('GIACR296', p_user_id))
              ORDER BY column_no)
       LOOP
          v_header := v_header || ',"' || ctr.column_title  ||'"'; 
          v_cntAgingParams := v_cntAgingParams + 1;
       END LOOP;
       
       v_rec.rec := v_header;  
        
       PIPE ROW (v_rec);
       
       
       -- get the dynamic query
       v_query := NULL;
       FOR X in (  SELECT query1 , query2, query3, query4, query5, query6, query7, query8            
                      FROM TABLE(csv_soa.csv_giacr296a_query ( P_CUT_OFF_DATE
                                                               , P_AS_OF_DATE
                                                               , P_RI_CD
                                                               , P_LINE_CD
                                                               , P_USER_ID)) )
       LOOP
            
            v_query := NVL(x.query1, '') || NVL(x.query2, '') || NVL(x.query3, '') || NVL(x.query4, '') ||
                        NVL(x.query5, '') || NVL(x.query6, '') || NVL(x.query7, '') || NVL(x.query8, '')   ; 
       
       END LOOP;
       
       IF v_query IS NOT NULL THEN
            EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_temp_tbl;
            IF SQL%FOUND THEN 
                FOR c IN 1..v_temp_tbl.count 
                LOOP
                
                    v_rec.rec := v_temp_tbl(c).ri_cd || ',"' || 
                                 v_temp_tbl(c).ri_name || '",' || 
                                 v_temp_tbl(c).line_cd || ',"' || 
                                 v_temp_tbl(c).line_name || '",' || 
                                 v_temp_tbl(c).eff_date || ',' || 
                                 v_temp_tbl(c).booking_date || ',"' || 
                                 v_temp_tbl(c).binder_no || '",' || 
                                 v_temp_tbl(c).ppw || ',"' ||
                                 v_temp_tbl(c).policy_no || '","' || 
                                 v_temp_tbl(c).assd_name || '",' || 
                                 v_temp_tbl(c).lprem_amt || ',' || 
                                 v_temp_tbl(c).lprem_vat || ',' || 
                                 v_temp_tbl(c).lcomm_amt || ',' || 
                                 v_temp_tbl(c).lcomm_vat || ',' || 
                                 v_temp_tbl(c).lwholding_vat || ',' || 
                                 v_temp_tbl(c).lnet_due || ',' || 
                                 v_temp_tbl(c).policy_id || ',' || 
                                 v_temp_tbl(c).fnl_binder_id ;
                                 
                   IF v_cntAgingParams > 0 THEN                   
                        v_rec.rec :=  v_rec.rec || ',' || v_temp_tbl(c).aging_due_bal;                   
                   END IF;
                   
                   PIPE ROW (v_rec);               
                END LOOP;               
            
            END IF;       
       
       END IF;
       
       
       RETURN;
   END;
   

   FUNCTION csv_giacr296b (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN giacr296b_type PIPELINED
   IS
      v_giacr296b   giacr296b_rec_type;
   BEGIN
      FOR rec IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name,
                           a.eff_date, a.booking_date, a.binder_no,
                           a.policy_no, a.assd_name, a.fprem_amt,
                           a.fprem_vat, a.fcomm_amt, a.fcomm_vat,
                           a.fwholding_vat, a.fnet_due, a.currency_cd,
                           a.currency_rt, c.currency_desc,a.policy_id,a.fnl_binder_id  -- jhing added policy_id and fnl_binder_id 01.31.2016 to make all CSVs of giacr296 consistent- GENQA 4099,4100,4103,4102,4101
                      FROM giis_currency c,
                           giis_line b,
                           giac_outfacul_soa_ext a
                     WHERE a.currency_cd = c.main_currency_cd
                       AND a.line_cd = b.line_cd
                       AND a.cut_off_date = p_cut_off_date
                       AND a.as_of_date = p_as_of_date
                       AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND a.fnet_due <> 0
                       AND a.user_id = /*USER*/ p_user_id -- added replaced user with p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
                  ORDER BY a.ri_name,
                           b.line_name,
                           a.eff_date,
                           a.booking_date,
                           a.binder_no,
                           a.policy_no,
                           a.currency_cd,
                           a.currency_rt)
      LOOP
         v_giacr296b.ri_cd := rec.ri_cd;
         v_giacr296b.ri_name := rec.ri_name;
         v_giacr296b.line_cd := rec.line_cd;
         v_giacr296b.line_name := rec.line_name;
         v_giacr296b.eff_date := rec.eff_date;
         v_giacr296b.booking_date := rec.booking_date;
         v_giacr296b.binder_no := rec.binder_no;
         v_giacr296b.policy_no := rec.policy_no;
         v_giacr296b.assd_name := rec.assd_name;
         v_giacr296b.fprem_amt := rec.fprem_amt;
         v_giacr296b.fprem_vat := rec.fprem_vat;
         v_giacr296b.fcomm_amt := rec.fcomm_amt;
         v_giacr296b.fcomm_vat := rec.fcomm_vat;
         v_giacr296b.fwholding_vat := rec.fwholding_vat;
         v_giacr296b.fnet_due := rec.fnet_due;
         v_giacr296b.currency_cd := rec.currency_cd;
         v_giacr296b.currency_rt := rec.currency_rt;
         v_giacr296b.currency_desc := rec.currency_desc;
         v_giacr296b.policy_id := rec.policy_id;
         v_giacr296b.fnl_binder_id := rec.fnl_binder_id;
         PIPE ROW (v_giacr296b);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_giacr296c_old (   -- jhing 01.30.2016 new function will replace code with csv function  GENQA 4099,4100,4103,4102,4101
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2
   )
      RETURN giacr296c_type PIPELINED
   IS
      v_giacr296c   giacr296c_rec_type;
   BEGIN
      FOR rec IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name,
                           a.eff_date, a.booking_date, a.binder_no,
                           a.policy_no, a.assd_name, a.fprem_amt,
                           a.fprem_vat, a.fcomm_amt, a.fcomm_vat,
                           a.fwholding_vat, a.fnet_due, a.currency_cd,
                           a.currency_rt, c.currency_desc, d.column_no,
                           d.column_title
                      FROM giis_report_aging d,
                           giis_currency c,
                           giis_line b,
                           giac_outfacul_soa_ext a
                     WHERE a.currency_cd = c.main_currency_cd
                       AND a.line_cd = b.line_cd
                       AND a.cut_off_date = p_cut_off_date
                       AND a.as_of_date = p_as_of_date
                       AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND a.fnet_due <> 0
                       AND d.report_id = 'GIACR296'
                       AND d.column_no = a.column_no
                       AND a.user_id = USER
                  ORDER BY a.ri_name,
                           b.line_name,
                           a.eff_date,
                           a.booking_date,
                           a.binder_no,
                           a.policy_no,
                           a.currency_cd,
                           a.currency_rt)
      LOOP
         v_giacr296c.ri_cd := rec.ri_cd;
         v_giacr296c.ri_name := rec.ri_name;
         v_giacr296c.line_cd := rec.line_cd;
         v_giacr296c.line_name := rec.line_name;
         v_giacr296c.eff_date := rec.eff_date;
         v_giacr296c.booking_date := rec.booking_date;
         v_giacr296c.binder_no := rec.binder_no;
         v_giacr296c.policy_no := rec.policy_no;
         v_giacr296c.assd_name := rec.assd_name;
         v_giacr296c.fprem_amt := rec.fprem_amt;
         v_giacr296c.fprem_vat := rec.fprem_vat;
         v_giacr296c.fcomm_amt := rec.fcomm_amt;
         v_giacr296c.fcomm_vat := rec.fcomm_vat;
         v_giacr296c.fwholding_vat := rec.fwholding_vat;
         v_giacr296c.fnet_due := rec.fnet_due;
         v_giacr296c.currency_cd := rec.currency_cd;
         v_giacr296c.currency_rt := rec.currency_rt;
         v_giacr296c.currency_desc := rec.currency_desc;
         v_giacr296c.column_no := rec.column_no;
         v_giacr296c.column_title := rec.column_title;
         PIPE ROW (v_giacr296c);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_giacr296c_query (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
 RETURN dyn_sql_query_tab
       PIPELINED
    IS
       v_cntAgingParams   NUMBER := 0;
       v_query            VARCHAR2(32767);
       v_dynQuery         dyn_sql_query;
    BEGIN
       v_query :=
             'SELECT a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, a.booking_date, a.binder_no,a.policy_no, a.assd_name, a.fprem_amt,'
              || 'a.fprem_vat, a.fcomm_amt, a.fcomm_vat,a.fwholding_vat, a.fnet_due, a.currency_cd,a.currency_rt, c.currency_desc,a.policy_id,a.fnl_binder_id';


       v_cntAgingParams := 0;

       FOR ctr
          IN (  SELECT column_no, column_title
                  FROM TABLE (
                          csv_soa.get_giacr296_agingCols ('GIACR296', p_user_id))
              ORDER BY column_no)
       LOOP
          IF v_cntAgingParams = 0
          THEN
             v_query :=
                   v_query
                || ' , DECODE (a.column_no, '
                || ctr.column_no
                || ', NVL (a.fnet_due, 0), 0) ';
          ELSE
             v_query :=
                   v_query
                || ' || '','' ||  DECODE (a.column_no, '
                || ctr.column_no
                || ', NVL (a.fnet_due, 0), 0) ';
          END IF;

          v_cntAgingParams := v_cntAgingParams + 1;
       END LOOP;
       
       IF v_cntAgingParams = 0 THEN
            v_query :=  v_query || ' , 0 aging  ';       
       END IF; 


       v_query :=
             v_query
          || ' FROM giis_line b, giac_outfacul_soa_ext a, giis_currency c'          
          || ' WHERE  a.line_cd = b.line_cd AND a.currency_cd = c.main_currency_cd '
          || ' AND a.cut_off_date = '''
          || p_cut_off_date
          || ''''
          || ' AND a.as_of_date = '''
          || p_as_of_date
          || '''';

       IF p_ri_cd IS NULL
       THEN
          v_query := v_query || ' AND a.ri_cd = NVL ( NULL , a.ri_cd) ';
       ELSE
          v_query := v_query || ' AND a.ri_cd = NVL (' || p_ri_cd || ', a.ri_cd) ';
       END IF;


       IF p_line_cd IS NULL
       THEN
          v_query := v_query || ' AND a.line_cd = NVL (NULL, a.line_cd) ';
       ELSE
          v_query :=
                v_query
             || ' AND a.line_cd = NVL ('''
             || p_line_cd
             || ''', a.line_cd) ';
       END IF;

       v_query :=
             v_query
          || '  AND a.fnet_due <> 0 AND a.user_id = '''
          || p_user_id
          || ''''
          || '  ORDER BY a.ri_name,b.line_name,a.eff_date,a.booking_date,a.binder_no,a.policy_no, a.currency_cd,a.currency_rt ';

       v_dynQuery.query1 := SUBSTR (v_query, 1, 4000);
       v_dynQuery.query2 := SUBSTR (v_query, 4001, 8000);
       v_dynQuery.query3 := SUBSTR (v_query, 8001, 12000);
       v_dynQuery.query4 := SUBSTR (v_query, 12001, 16000);
       v_dynQuery.query5 := SUBSTR (v_query, 16001, 20000);
       v_dynQuery.query6 := SUBSTR (v_query, 20001, 24000);
       v_dynQuery.query7 := SUBSTR (v_query, 24001, 28000);
       v_dynQuery.query8 := SUBSTR (v_query, 28001, 32000);

       PIPE ROW (v_dynQuery);

       RETURN;
   END;

   FUNCTION csv_giacr296c (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN csv_rec_tab PIPELINED
    IS
       v_cntAgingParams   NUMBER := 0;
       v_query            VARCHAR2(32767);
       v_rec              csv_rec_type ; 
       v_header           VARCHAR2(32767); 
       
       
       TYPE giacr296c_rec2_type IS RECORD (
          ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
          ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
          line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
          line_name       giis_line.line_name%TYPE,
          eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
          booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
          binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
          policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
          assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
          fprem_amt       giac_outfacul_soa_ext.fprem_amt%TYPE,
          fprem_vat       giac_outfacul_soa_ext.fprem_vat%TYPE,
          fcomm_amt       giac_outfacul_soa_ext.fcomm_amt%TYPE,
          fcomm_vat       giac_outfacul_soa_ext.fcomm_vat%TYPE,
          fwholding_vat   giac_outfacul_soa_ext.fwholding_vat%TYPE,
          fnet_due        giac_outfacul_soa_ext.fnet_due%TYPE,
          currency_cd     giac_outfacul_soa_ext.currency_cd%TYPE,
          currency_rt     giac_outfacul_soa_ext.currency_rt%TYPE,
          currency_desc   giis_currency.currency_desc%TYPE,
          policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
          fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
          aging_due_bal    VARCHAR2 (32767)
       );

       TYPE giacr296c_tab2 IS TABLE OF giacr296c_rec2_type;  
       
       v_temp_tbl   giacr296c_tab2;
                            
    BEGIN
    
       -- generate the header first 
       v_header  := 'RI CODE,RI NAME,LINE CODE,LINE NAME,EFF DATE,BOOKING DATE,BINDER NUMBER,POLICY NUMBER,ASSURED NAME,PREMIUM AMT,VAT ON PREM,'
       || 'COMMISSION AMT,VAT ON COMMISSION,WHOLDING VAT,NET DUE,CURRENCY CODE, CURRENCY RATE, CURRENCY DESC,POLICY ID, FNL BINDER ID';


       v_cntAgingParams := 0;

       FOR ctr
          IN (  SELECT column_no, column_title
                  FROM TABLE (
                          csv_soa.get_giacr296_agingCols ('GIACR296', p_user_id))
              ORDER BY column_no)
       LOOP
          v_header := v_header || ',"' || ctr.column_title  ||'"'; 
          v_cntAgingParams := v_cntAgingParams + 1;
       END LOOP;
       
       v_rec.rec := v_header;  
        
       PIPE ROW (v_rec);
       
       
       -- get the dynamic query
       v_query := NULL;
       FOR X in (  SELECT query1 , query2, query3, query4, query5, query6, query7, query8            
                      FROM TABLE(csv_soa.csv_giacr296c_query ( P_CUT_OFF_DATE
                                                               , P_AS_OF_DATE
                                                               , P_RI_CD
                                                               , P_LINE_CD
                                                               , P_USER_ID)) )
       LOOP
            
            v_query := NVL(x.query1, '') || NVL(x.query2, '') || NVL(x.query3, '') || NVL(x.query4, '') ||
                        NVL(x.query5, '') || NVL(x.query6, '') || NVL(x.query7, '') || NVL(x.query8, '')   ; 
       
       END LOOP;
       
       IF v_query IS NOT NULL THEN
            EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_temp_tbl;
            IF SQL%FOUND THEN 
                FOR c IN 1..v_temp_tbl.count 
                LOOP
                
                    v_rec.rec := v_temp_tbl(c).ri_cd || ',"' || 
                                 v_temp_tbl(c).ri_name || '",' || 
                                 v_temp_tbl(c).line_cd || ',"' || 
                                 v_temp_tbl(c).line_name || '",' || 
                                 v_temp_tbl(c).eff_date || ',' || 
                                 v_temp_tbl(c).booking_date || ',"' || 
                                 v_temp_tbl(c).binder_no || '","' || 
                                 v_temp_tbl(c).policy_no || '","' || 
                                 v_temp_tbl(c).assd_name || '",' || 
                                 v_temp_tbl(c).fprem_amt || ',' || 
                                 v_temp_tbl(c).fprem_vat || ',' || 
                                 v_temp_tbl(c).fcomm_amt || ',' || 
                                 v_temp_tbl(c).fcomm_vat || ',' || 
                                 v_temp_tbl(c).fwholding_vat || ',' || 
                                 v_temp_tbl(c).fnet_due || ',' || 
                                 v_temp_tbl(c).currency_cd || ',' || 
                                 v_temp_tbl(c).currency_rt || ',"' ||
                                 v_temp_tbl(c).currency_desc || '",' ||
                                 v_temp_tbl(c).policy_id || ',' || 
                                 v_temp_tbl(c).fnl_binder_id; 
                                 
                   IF v_cntAgingParams > 0 THEN                   
                        v_rec.rec :=  v_rec.rec || ',' || v_temp_tbl(c).aging_due_bal;                   
                   END IF;
                   
                   PIPE ROW (v_rec);               
                END LOOP;               
            
            END IF;       
       
       END IF;
       
       
       RETURN;
   END;

   FUNCTION csv_giacr296d_old (  -- jhing will replace this function with a new one which dynamically sets aging as columns-  01.30.2016 GENQA 4099,4100,4103,4102,4101
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_paid           VARCHAR2,
      p_unpaid         VARCHAR2,
      p_partpaid       VARCHAR2
   )
      RETURN giacr296d_type PIPELINED
   IS
      v_giacr296d   giacr296d_rec_type;
   BEGIN
      FOR rec IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name,
                           a.eff_date, a.booking_date, a.binder_no,
                           a.policy_no, a.assd_name, a.lprem_amt,
                           a.lprem_vat, a.lcomm_amt, a.lcomm_vat,
                           a.lwholding_vat, a.lnet_due, a.policy_id,
                           a.fnl_binder_id, a.prem_bal, a.loss_tag,
                           a.intm_name, c.column_no, c.column_title
                      FROM giis_report_aging c,
                           giis_line b,
                           giac_outfacul_soa_ext a,
                           (SELECT   policy_id,
                                     SUM (NVL (  (prem_amt + tax_amt)
                                               * currency_rt,
                                               0
                                              )
                                         ) ptax_amt
                                FROM gipi_invoice
                            GROUP BY policy_id) d
                     WHERE a.line_cd = b.line_cd
                       AND a.cut_off_date = p_cut_off_date
                       AND a.as_of_date = p_as_of_date
                       AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND d.policy_id = a.policy_id
                       AND (   a.prem_bal = DECODE (p_paid, 'Y', 0)
                            OR (    a.prem_bal != DECODE (p_unpaid, 'Y', 0)
                                AND a.prem_bal =
                                            DECODE (p_unpaid,
                                                    'Y', d.ptax_amt
                                                   )
                               )
                            OR (    a.prem_bal != DECODE (p_partpaid, 'Y', 0)
                                AND a.prem_bal !=
                                          DECODE (p_partpaid,
                                                  'Y', d.ptax_amt
                                                 )
                               )
                           )
                       AND a.lnet_due <> 0
                       AND c.column_no = a.column_no
                       AND c.report_id = 'GIACR296'
                       AND a.user_id = USER
                  ORDER BY a.ri_name,
                           b.line_name,
                           a.eff_date,
                           a.booking_date,
                           a.binder_no,
                           a.policy_no)
      LOOP
         v_giacr296d.ri_cd := rec.ri_cd;
         v_giacr296d.ri_name := rec.ri_name;
         v_giacr296d.line_cd := rec.line_cd;
         v_giacr296d.line_name := rec.line_name;
         v_giacr296d.eff_date := rec.eff_date;
         v_giacr296d.booking_date := rec.booking_date;
         v_giacr296d.binder_no := rec.binder_no;
         v_giacr296d.policy_no := rec.policy_no;
         v_giacr296d.assd_name := rec.assd_name;
         v_giacr296d.lprem_amt := rec.lprem_amt;
         v_giacr296d.lprem_vat := rec.lprem_vat;
         v_giacr296d.lcomm_amt := rec.lcomm_amt;
         v_giacr296d.lcomm_vat := rec.lcomm_vat;
         v_giacr296d.lwholding_vat := rec.lwholding_vat;
         v_giacr296d.lnet_due := rec.lnet_due;
         v_giacr296d.policy_id := rec.policy_id;
         v_giacr296d.fnl_binder_id := rec.fnl_binder_id;
         v_giacr296d.prem_bal := rec.prem_bal;
         v_giacr296d.loss_tag := rec.loss_tag;
         v_giacr296d.intm_name := rec.intm_name;
         v_giacr296d.column_no := rec.column_no;
         v_giacr296d.column_title := rec.column_title;
         PIPE ROW (v_giacr296d);
      END LOOP;

      RETURN;
   END;                                         --added by jcDY 11.17.2011 end
   
   
   FUNCTION csv_giacr296d_query   ( p_cut_off_date    DATE,
                                    p_as_of_date      DATE,
                                    p_ri_cd           NUMBER,
                                    p_line_cd         VARCHAR2,
                                    p_paid            VARCHAR2,
                                    p_unpaid          VARCHAR2,
                                    p_partpaid        VARCHAR2,
                                    p_user_id         VARCHAR2  )
   RETURN dyn_sql_query_tab
       PIPELINED
    IS
       v_cntAgingParams   NUMBER := 0;
       v_query            VARCHAR2(32767);
       v_dynQuery         dyn_sql_query;
    BEGIN
       v_query :=
             'SELECT a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.ppw, a.policy_no, '
          || ' a.assd_name, a.lprem_amt,a.lprem_vat,a.lcomm_amt,a.lcomm_vat, a.lwholding_vat, a.lnet_due, a.policy_id, '
          || ' a.fnl_binder_id, a.prem_bal, a.loss_tag, a.intm_name';


       v_cntAgingParams := 0;

       FOR ctr
          IN (  SELECT column_no, column_title
                  FROM TABLE (
                          csv_soa.get_giacr296_agingCols ('GIACR296', p_user_id))
              ORDER BY column_no)
       LOOP
          IF v_cntAgingParams = 0
          THEN
             v_query :=
                   v_query
                || ' , DECODE (a.column_no, '
                || ctr.column_no
                || ', NVL (a.lnet_due, 0), 0) ';
          ELSE
             v_query :=
                   v_query
                || ' || '','' ||  DECODE (a.column_no, '
                || ctr.column_no
                || ', NVL (a.lnet_due, 0), 0) ';
          END IF;

          v_cntAgingParams := v_cntAgingParams + 1;
       END LOOP;
       
       IF v_cntAgingParams = 0 THEN
            v_query :=  v_query || ' , 0 aging  ';       
       END IF; 


       v_query :=
             v_query
          || ' FROM giis_line b, giac_outfacul_soa_ext a, '
          || '  (  SELECT policy_id, SUM (NVL ( (prem_amt + tax_amt) * currency_rt, 0)) ptax_amt '
          || '  FROM gipi_invoice  GROUP BY policy_id) d '
          || ' WHERE  a.line_cd = b.line_cd '
          || ' AND a.cut_off_date = '''
          || p_cut_off_date
          || ''''
          || ' AND a.as_of_date = '''
          || p_as_of_date
          || '''';

       IF p_ri_cd IS NULL
       THEN
          v_query := v_query || ' AND a.ri_cd = NVL ( NULL , a.ri_cd) ';
       ELSE
          v_query := v_query || ' AND a.ri_cd = NVL (' || p_ri_cd || ', a.ri_cd) ';
       END IF;


       IF p_line_cd IS NULL
       THEN
          v_query := v_query || ' AND a.line_cd = NVL (NULL, a.line_cd) ';
       ELSE
          v_query :=
                v_query
             || ' AND a.line_cd = NVL ('''
             || p_line_cd
             || ''', a.line_cd) ';
       END IF;

       v_query :=
             v_query
          || ' AND d.policy_id = a.policy_id '
          || ' AND (   a.prem_bal = DECODE ('''
          || p_paid
          || ''', ''Y'', 0) '
          || '  OR (    a.prem_bal != DECODE ('''
          || p_unpaid
          || ''', ''Y'', 0) '
          || '  AND a.prem_bal = DECODE ('''
          || p_unpaid
          || ''', ''Y'', d.ptax_amt)) '
          || '    OR (    a.prem_bal != DECODE ('''
          || p_partpaid
          || ''', ''Y'', 0) '
          || '    AND a.prem_bal != DECODE ('''
          || p_partpaid
          || ''', ''Y'', d.ptax_amt))) '
          || '  AND a.lnet_due <> 0 AND a.user_id = '''
          || p_user_id
          || ''''
          || '  ORDER BY a.ri_name, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no ';

       v_dynQuery.query1 := SUBSTR (v_query, 1, 4000);
       v_dynQuery.query2 := SUBSTR (v_query, 4001, 8000);
       v_dynQuery.query3 := SUBSTR (v_query, 8001, 12000);
       v_dynQuery.query4 := SUBSTR (v_query, 12001, 16000);
       v_dynQuery.query5 := SUBSTR (v_query, 16001, 20000);
       v_dynQuery.query6 := SUBSTR (v_query, 20001, 24000);
       v_dynQuery.query7 := SUBSTR (v_query, 24001, 28000);
       v_dynQuery.query8 := SUBSTR (v_query, 28001, 32000);

       PIPE ROW (v_dynQuery);

       RETURN;
   END;

   FUNCTION csv_giacr296d ( p_cut_off_date    DATE,     -- jhing 01.30.2016 new function
                            p_as_of_date      DATE,
                            p_ri_cd           NUMBER,
                            p_line_cd         VARCHAR2,
                            p_paid            VARCHAR2,
                            p_unpaid          VARCHAR2,
                            p_partpaid        VARCHAR2,
                            p_user_id         VARCHAR2  )-- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
      RETURN csv_rec_tab PIPELINED
    IS
       v_cntAgingParams   NUMBER := 0;
       v_query            VARCHAR2(32767);
       v_rec              csv_rec_type ; 
       v_header           VARCHAR2(32767); 
       
       
       TYPE giacr296d_rec2_type IS RECORD (
          ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
          ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
          line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
          line_name       giis_line.line_name%TYPE,
          eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
          booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
          binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
          ppw             giac_outfacul_soa_ext.ppw%TYPE,  
          policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
          assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
          lprem_amt       giac_outfacul_soa_ext.lprem_amt%TYPE,
          lprem_vat       giac_outfacul_soa_ext.lprem_vat%TYPE,
          lcomm_amt       giac_outfacul_soa_ext.lcomm_amt%TYPE,
          lcomm_vat       giac_outfacul_soa_ext.lcomm_vat%TYPE,
          lwholding_vat   giac_outfacul_soa_ext.lwholding_vat%TYPE,
          lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE,
          policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
          fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
          prem_bal        giac_outfacul_soa_ext.prem_bal%TYPE,
          loss_tag        giac_outfacul_soa_ext.loss_tag%TYPE,
          intm_name       giac_outfacul_soa_ext.intm_name%TYPE,
          aging_due_bal    VARCHAR2 (32767)
       );

       TYPE giacr296d_tab2 IS TABLE OF giacr296d_rec2_type;  
       
       v_temp_tbl   giacr296d_tab2;
                            
    BEGIN
    
       -- generate the header first 
       v_header  := 'RI CODE,RI NAME,LINE CODE,LINE NAME,EFF DATE,BOOKING DATE,BINDER NUMBER,PPW,POLICY NUMBER,ASSURED NAME,PREMIUM AMT,PREMIUM VAT,'
       || 'COMMISSION AMT,COMMISSION VAT,WHOLDING VAT,NET DUE, POLICY ID,FNL BINDER ID, DIRECT PREMIUM BALANCE,LOSS TAG,INTERMEDIARY NAME';


       v_cntAgingParams := 0;

       FOR ctr
          IN (  SELECT column_no, column_title
                  FROM TABLE (
                          csv_soa.get_giacr296_agingCols ('GIACR296', p_user_id))
              ORDER BY column_no)
       LOOP
          v_header := v_header || ',"' || ctr.column_title  ||'"'; 
          v_cntAgingParams := v_cntAgingParams + 1;
       END LOOP;
       
       v_rec.rec := v_header;  
        
       PIPE ROW (v_rec);
       
       
       -- get the dynamic query
       v_query := NULL;
       FOR X in (  SELECT query1 , query2, query3, query4, query5, query6, query7, query8            
                      FROM TABLE(csv_soa.csv_giacr296d_query (   P_CUT_OFF_DATE,
                                                                P_AS_OF_DATE,
                                                                                 P_RI_CD,
                                                                                 P_LINE_CD,
                                                                                 P_PAID,
                                                                                 P_UNPAID,
                                                                                 P_PARTPAID,
                                                                                 P_USER_ID)) )
       LOOP
            
            v_query := NVL(x.query1, '') || NVL(x.query2, '') || NVL(x.query3, '') || NVL(x.query4, '') ||
                        NVL(x.query5, '') || NVL(x.query6, '') || NVL(x.query7, '') || NVL(x.query8, '')   ; 
       
       END LOOP;
       
       IF v_query IS NOT NULL THEN
            EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_temp_tbl;
            IF SQL%FOUND THEN 
                FOR c IN 1..v_temp_tbl.count 
                LOOP
                
                    v_rec.rec := v_temp_tbl(c).ri_cd || ',"' || 
                                 v_temp_tbl(c).ri_name || '",' || 
                                 v_temp_tbl(c).line_cd || ',"' || 
                                 v_temp_tbl(c).line_name || '",' || 
                                 v_temp_tbl(c).eff_date || ',' || 
                                 v_temp_tbl(c).booking_date || ',"' || 
                                 v_temp_tbl(c).binder_no || '",' || 
                                 v_temp_tbl(c).ppw || ',"' || 
                                 v_temp_tbl(c).policy_no || '","' || 
                                 v_temp_tbl(c).assd_name || '",' || 
                                 v_temp_tbl(c).lprem_amt || ',' || 
                                 v_temp_tbl(c).lprem_vat || ',' || 
                                 v_temp_tbl(c).lcomm_amt || ',' || 
                                 v_temp_tbl(c).lcomm_vat || ',' || 
                                 v_temp_tbl(c).lwholding_vat || ',' || 
                                 v_temp_tbl(c).lnet_due || ',' || 
                                 v_temp_tbl(c).policy_id || ',' || 
                                 v_temp_tbl(c).fnl_binder_id || ',' || 
                                 v_temp_tbl(c).prem_bal || ',' || 
                                 v_temp_tbl(c).loss_tag || ',"' || 
                                 v_temp_tbl(c).intm_name || '"' ;
                                 
                   IF v_cntAgingParams > 0 THEN                   
                        v_rec.rec :=  v_rec.rec || ',' || v_temp_tbl(c).aging_due_bal;                   
                   END IF;
                   
                   PIPE ROW (v_rec);               
                END LOOP;               
            
            END IF;       
       
       END IF;
       
       
       RETURN;
   END;

   FUNCTION get_giacr296_agingCols (
      p_report_id      VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN giacr296_aging_rec_tbl PIPELINED
   IS
        v_rec giacr296_aging_rec ;
        v_user_branch    giis_issource.iss_cd%TYPE ;         
   BEGIN
     
     FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
     LOOP
     
        v_user_branch := tx.grp_iss_cd; 
     END LOOP;   
     
   
     FOR tc IN ( SELECT x.column_no, x.column_title
                      FROM giis_report_aging x
                     WHERE     x.report_id = p_report_id
                           AND (   (x.branch_cd IS NOT NULL AND x.branch_cd = v_user_branch)
                                OR (    x.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = p_report_id) =
                                           0)) )
     LOOP
        
        v_rec.column_no := tc.column_no;
        v_rec.column_title := tc.column_title ; 
        PIPE ROW (v_rec); 
     END LOOP;
   
     
     
   END ;   
      --added by reymon
   --for giacr193a report
   FUNCTION csv_giacr193a (
      p_bal_amt_due   NUMBER,
      p_user          VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2
   )
      RETURN giacr193a_type PIPELINED
   IS
      v_giacr193a   giacr193a_rec_type;
   BEGIN
      FOR rec IN (SELECT   /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           a.branch_cd, a.intm_type, a.intm_no,
                           get_ref_intm_cd (a.intm_no) ref_intm_cd,
                           UPPER (a.intm_name) intm_name, a.column_title,
                           SUBSTR (a.policy_no,
                                   1,
                                   INSTR (a.policy_no, '-') - 1
                                  ) line_cd,
                           a.policy_no, a.ref_pol_no, a.assd_name,
                              a.iss_cd
                           || '-'
                           || TO_CHAR (a.prem_seq_no, 'FM099999999999')
                           || '-'
                           || TO_CHAR (a.inst_no, 'FM09') bill_no,
                           TRUNC (a.incept_date) incept_date,
                           TRUNC (a.due_date) due_date, a.no_of_days,
                           a.prem_bal_due, a.balance_amt_due, a.iss_cd,
                           a.prem_seq_no, a.inst_no, a.user_id
                      FROM giac_soa_rep_ext a
                     WHERE 1 = 1
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >=
                                        NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
                  ORDER BY a.intm_no)
      LOOP
         BEGIN
            SELECT branch_name
              INTO v_giacr193a.branch_name
              FROM giac_branches
             WHERE branch_cd = rec.branch_cd;
         EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND
            THEN
               v_giacr193a.branch_name :=
                     'Branch code '
                  || rec.branch_cd
                  || ' does not exists in GIAC_BRANCHES';
         END;

         BEGIN
            SELECT intm_desc
              INTO v_giacr193a.intm_desc
              FROM giis_intm_type
             WHERE intm_type = rec.intm_type;
         EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND
            THEN
               v_giacr193a.intm_desc :=
                  'Intermediary type ' || rec.intm_type || ' does not exists';
         END;

         v_giacr193a.intm_no := rec.intm_no;
         v_giacr193a.ref_intm_cd := rec.ref_intm_cd;
         v_giacr193a.intm_name := rec.intm_name;

         DECLARE
            v_bm   VARCHAR2 (5);
         BEGIN
            FOR c1 IN
               (SELECT DECODE (SIGN (  3
                                     - NVL (LENGTH (   bill_addr1
                                                    || bill_addr2
                                                    || bill_addr3
                                                   ),
                                            0
                                           )
                                    ),
                               1, 'MAIL',
                               -1, 'BILL',
                               'MAIL'
                              ) addr
                  FROM giis_intermediary
                 WHERE intm_no = rec.intm_no)
            LOOP
               v_bm := c1.addr;
               EXIT;
            END LOOP;

            IF (v_bm = 'MAIL' OR v_bm IS NULL)
            THEN
               SELECT    mail_addr1
                      || DECODE (mail_addr2, NULL, '', ' ')
                      || mail_addr2
                      || DECODE (mail_addr3, NULL, '', ' ')
                      || mail_addr3
                 INTO v_giacr193a.intm_address
                 FROM giis_intermediary
                WHERE intm_no = rec.intm_no;
            ELSIF v_bm = 'BILL'
            THEN
               SELECT    bill_addr1
                      || DECODE (bill_addr2, NULL, '', ' ')
                      || bill_addr2
                      || DECODE (bill_addr3, NULL, '', ' ')
                      || bill_addr3
                 INTO v_giacr193a.intm_address
                 FROM giis_intermediary
                WHERE intm_no = rec.intm_no;
            ELSE
               v_giacr193a.intm_address :=
                                        'UNKNOWN VALUE OF ADDRESS PARAMETER.';
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giacr193a.intm_address :=
                        'NO SUCH INTERMEDIARY AVAILABLE IN GIIS_INTERMEDIARY';
            WHEN TOO_MANY_ROWS
            THEN
               v_giacr193a.intm_address :=
                           'TOO MANY VALUES FOR ADDRESS IN GIIS_INTERMEDIARY';
         END;

         v_giacr193a.column_title := rec.column_title;

         BEGIN
            SELECT line_name
              INTO v_giacr193a.line_name
              FROM giis_line
             WHERE line_cd = rec.line_cd;
         EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND
            THEN
               v_giacr193a.line_name := NULL;
         END;

         v_giacr193a.policy_no := rec.policy_no;
         v_giacr193a.ref_pol_no := rec.ref_pol_no;
         v_giacr193a.assd_name := rec.assd_name;
         v_giacr193a.bill_no := rec.bill_no;
         v_giacr193a.incept_date := rec.incept_date;
         v_giacr193a.due_date := rec.due_date;
         v_giacr193a.no_of_days := rec.no_of_days;
         v_giacr193a.prem_bal_due := rec.prem_bal_due;
         v_giacr193a.balance_amt_due := rec.balance_amt_due;
         v_giacr193a.iss_cd := rec.iss_cd;
         v_giacr193a.prem_seq_no := rec.prem_seq_no;
         v_giacr193a.inst_no := rec.inst_no;
         v_giacr193a.user_id := rec.user_id;
         PIPE ROW (v_giacr193a);
      END LOOP;
   END;

   FUNCTION csv_giacr190 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_date          DATE,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr190_type PIPELINED
   IS
      v_giacr190   giacr190_rec_type;
   BEGIN
      FOR rec IN (SELECT DISTINCT a.branch_cd, UPPER (a.intm_name) intm_name,
                                  a.intm_no, a.intm_type,
                                  SUM (balance_amt_due) balance_amt_due,
                                  SUM (prem_bal_due) prem_bal_due,
                                  SUM (tax_bal_due) tax_bal_due,
                                  TO_CHAR (b.ref_intm_cd) ref_intm_cd
                             FROM giac_soa_rep_ext a, giis_intermediary b
                            WHERE a.intm_no = b.intm_no
                              AND a.user_id = UPPER (p_user)
                              AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                              AND a.intm_no = NVL (p_intm_no, a.intm_no)
                              AND a.intm_type = NVL (p_intm_type, a.intm_type)
                              AND a.due_tag =
                                     DECODE (p_inc_overdue,
                                             'I', a.due_tag,
                                             'N', 'Y'
                                            )
                              AND check_user_per_iss_cd_acctg (NULL,
                                                               a.branch_cd,
                                                               'GIACS180'
                                                              ) = 1
                           --HAVING SUM (NVL (balance_amt_due, 0)) >= NVL (p_bal_amt_due, 0)
                  HAVING          NVL2 (p_bal_amt_due,
                                        SUM (balance_amt_due),
                                        SUM (ABS (balance_amt_due))
                                       ) >= NVL (p_bal_amt_due, 0.01)
                         GROUP BY a.branch_cd,
                                  a.intm_name,
                                  a.intm_no,
                                  b.ref_intm_cd,
                                  a.intm_type
                         ORDER BY 1, 2)
      LOOP
         v_giacr190.branch := rec.branch_cd || ' - ' || csv_soa.cf_branch_nameformula (rec.branch_cd);
         v_giacr190.intermediary := rec.intm_name;
         v_giacr190.ref_intm := rec.ref_intm_cd;
         v_giacr190.premium := rec.prem_bal_due;
         v_giacr190.taxes := rec.tax_bal_due;
         v_giacr190.amount_due := rec.balance_amt_due;
         v_giacr190.col_no1 :=
            csv_soa.get_bal_per_col_per_title (1,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no2 :=
            csv_soa.get_bal_per_col_per_title (2,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no3 :=
            csv_soa.get_bal_per_col_per_title (3,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no4 :=
            csv_soa.get_bal_per_col_per_title (4,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no5 :=
            csv_soa.get_bal_per_col_per_title (5,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no6 :=
            csv_soa.get_bal_per_col_per_title (6,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no7 :=
            csv_soa.get_bal_per_col_per_title (7,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no8 :=
            csv_soa.get_bal_per_col_per_title (8,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no9 :=
            csv_soa.get_bal_per_col_per_title (9,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no10 :=
            csv_soa.get_bal_per_col_per_title (10,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no11 :=
            csv_soa.get_bal_per_col_per_title (11,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no12 :=
            csv_soa.get_bal_per_col_per_title (12,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no13 :=
            csv_soa.get_bal_per_col_per_title (13,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr190.col_no14 :=
            csv_soa.get_bal_per_col_per_title (14,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               NULL,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         PIPE ROW (v_giacr190);
      END LOOP;
   END;

   FUNCTION csv_giacr191 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_assd_no       NUMBER,
      p_inc_overdue   VARCHAR2,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr191_type PIPELINED
   IS
      v_giacr191   giacr191_rec_type;
   BEGIN
      FOR rec IN (SELECT   a.branch_cd, a.assd_no, a.assd_name, a.policy_no,
                           a.incept_date, a.ref_pol_no,
                           UPPER (a.intm_name) intm_name, intm_no,
                              a.iss_cd
                           || '-'
                           || LPAD (a.prem_seq_no, 12, 0)
                           || '-'
                           || a.inst_no bill_no,
                           a.due_date, SUM (a.prem_bal_due) prem_bal_due,
                           SUM (a.tax_bal_due) tax_bal_due,
                           SUM (a.balance_amt_due) balance_amt_due
                      FROM giac_soa_rep_ext a, giis_issource b
                     WHERE a.balance_amt_due != 0
                       AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                       AND a.assd_no = NVL (p_assd_no, a.assd_no)
                       AND a.user_id = UPPER (p_user)
                       AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
                       AND a.iss_cd = b.iss_cd
                       AND check_user_per_iss_cd_acctg (NULL,
                                                        a.branch_cd,
                                                        'GIACS180'
                                                       ) = 1
                    HAVING NVL2 (p_bal_amt_due,
                                 SUM (balance_amt_due),
                                 SUM (ABS (balance_amt_due))
                                ) >= NVL (p_bal_amt_due, 0.01)
                  GROUP BY a.branch_cd,
                           a.assd_no,
                           a.assd_name,
                           a.policy_no,
                           a.incept_date,
                           a.ref_pol_no,
                           UPPER (a.intm_name),
                              a.iss_cd
                           || '-'
                           || LPAD (a.prem_seq_no, 12, 0)
                           || '-'
                           || a.inst_no,
                           a.due_date,
                           b.iss_cd,
                           a.iss_cd,
                           intm_no           --mikel 05.03.2013; added intm_no
                  ORDER BY a.branch_cd, a.assd_name, a.policy_no, 9)
      LOOP
         v_giacr191.branch_cd := rec.branch_cd;
         v_giacr191.branch_name :=
                                csv_soa.cf_branch_nameformula (rec.branch_cd);
         v_giacr191.assd_name := rec.assd_name;
         v_giacr191.policy_no := rec.policy_no;
         v_giacr191.incept_date := rec.incept_date;
         v_giacr191.ref_pol_no := rec.ref_pol_no;
         v_giacr191.intm_name := rec.intm_name;
         v_giacr191.bill_no := rec.bill_no;
         v_giacr191.due_date := rec.due_date;
         v_giacr191.prem_bal_due := rec.prem_bal_due;
         v_giacr191.tax_bal_due := rec.tax_bal_due;
         v_giacr191.balance_amt_due := rec.balance_amt_due;
         v_giacr191.col_no1 :=
            csv_soa.get_bal_per_col_per_title (1,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no2 :=
            csv_soa.get_bal_per_col_per_title (2,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no3 :=
            csv_soa.get_bal_per_col_per_title (3,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no4 :=
            csv_soa.get_bal_per_col_per_title (4,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no5 :=
            csv_soa.get_bal_per_col_per_title (5,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no6 :=
            csv_soa.get_bal_per_col_per_title (6,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no7 :=
            csv_soa.get_bal_per_col_per_title (7,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no8 :=
            csv_soa.get_bal_per_col_per_title (8,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no9 :=
            csv_soa.get_bal_per_col_per_title (9,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no10 :=
            csv_soa.get_bal_per_col_per_title (10,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no11 :=
            csv_soa.get_bal_per_col_per_title (11,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no12 :=
            csv_soa.get_bal_per_col_per_title (12,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no13 :=
            csv_soa.get_bal_per_col_per_title (13,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr191.col_no14 :=
            csv_soa.get_bal_per_col_per_title (14,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         PIPE ROW (v_giacr191);
      END LOOP;
   END;

   FUNCTION csv_giacr192 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_assd_no       NUMBER,
      p_inc_overdue   VARCHAR2,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr192_type PIPELINED
   IS
      v_giacr192   giacr192_rec_type;
   BEGIN
      FOR rec IN (SELECT DISTINCT branch_cd, assd_no,
                                  LTRIM (UPPER (assd_name)) assd_name,
                                  SUM (prem_bal_due) prem_bal_due,
                                  SUM (tax_bal_due) tax_bal_due,
                                  SUM (balance_amt_due) balance_amt_due
                             FROM giac_soa_rep_ext
                            WHERE user_id = UPPER (p_user)
                              AND branch_cd = NVL (p_branch_cd, branch_cd)
                              AND assd_no = NVL (p_assd_no, assd_no)
                              AND due_tag =
                                     DECODE (p_inc_overdue,
                                             'I', due_tag,
                                             'N', 'Y'
                                            )
                           HAVING NVL2 (p_bal_amt_due,
                                        SUM (balance_amt_due),
                                        SUM (ABS (balance_amt_due))
                                       ) >= NVL (p_bal_amt_due, 0.01)
                         GROUP BY branch_cd, assd_name, assd_no, assd_no
                         ORDER BY 1, LTRIM (UPPER (assd_name)))
      LOOP
         v_giacr192.branch_cd := rec.branch_cd;
         v_giacr192.branch_name :=
                                csv_soa.cf_branch_nameformula (rec.branch_cd);
         v_giacr192.assd_name := rec.assd_name;
         v_giacr192.prem_bal_due := rec.prem_bal_due;
         v_giacr192.tax_bal_due := rec.tax_bal_due;
         v_giacr192.balance_amt_due := rec.balance_amt_due;
         v_giacr192.col_no1 :=
            csv_soa.get_bal_per_col_per_title (1,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no2 :=
            csv_soa.get_bal_per_col_per_title (2,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no3 :=
            csv_soa.get_bal_per_col_per_title (3,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no4 :=
            csv_soa.get_bal_per_col_per_title (4,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no5 :=
            csv_soa.get_bal_per_col_per_title (5,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no6 :=
            csv_soa.get_bal_per_col_per_title (6,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no7 :=
            csv_soa.get_bal_per_col_per_title (7,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no8 :=
            csv_soa.get_bal_per_col_per_title (8,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no9 :=
            csv_soa.get_bal_per_col_per_title (9,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no10 :=
            csv_soa.get_bal_per_col_per_title (10,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no11 :=
            csv_soa.get_bal_per_col_per_title (11,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no12 :=
            csv_soa.get_bal_per_col_per_title (12,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no13 :=
            csv_soa.get_bal_per_col_per_title (13,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         v_giacr192.col_no14 :=
            csv_soa.get_bal_per_col_per_title (14,
                                               p_rep_id,
                                               p_user,
                                               rec.branch_cd,
                                               NULL,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               NULL,
                                               NULL
                                              );
         PIPE ROW (v_giacr192);
      END LOOP;
   END;

   FUNCTION get_bal_per_col_per_title (
      p_col_no        NUMBER,
      p_rep_id        VARCHAR2,
      p_user          VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_intm_no       NUMBER,
      p_assd_no       NUMBER,
      p_inc_overdue   VARCHAR2,
      p_bal_amt_due   NUMBER,
      p_policy_no     VARCHAR2,
      p_bill_no       VARCHAR2
   )
      RETURN NUMBER
   IS
      v_bal_due   NUMBER (12, 2);
   BEGIN
      IF p_rep_id = 'GIACR189'
      THEN
         /* Added by vondanix 050313 */ /* Modified by Joms Diago 05092013 */
         BEGIN
            SELECT   SUM (balance_amt_due)
                INTO v_bal_due
                FROM giac_soa_rep_ext a, giac_soa_title b
               WHERE 1 = 1
                 AND a.column_no = b.col_no
                 AND b.rep_cd = 1
                 AND a.column_no = p_col_no
                 AND a.user_id = UPPER (p_user)
                 AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                 AND a.intm_no = NVL (p_intm_no, a.intm_no)
                 AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
                 AND a.policy_no = p_policy_no
                 AND a.intm_no = p_intm_no
                 AND    a.iss_cd
                     || '-'
                     || LPAD (a.prem_seq_no, 12, 0)
                     || '-'
                     || a.inst_no = p_bill_no
            GROUP BY a.branch_cd,
                     a.assd_name,
                     a.assd_no,
                     a.policy_no,
                     a.column_title,
                     a.intm_no,
                        a.iss_cd
                     || '-'
                     || LPAD (a.prem_seq_no, 12, 0)
                     || '-'
                     || a.inst_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                        (-20201,
                            'Returns more than requested number of rows for '
                         || p_intm_no
                         || '-'
                         || p_col_no
                        );
         END;
      ELSIF p_rep_id = 'GIACR190'
      THEN
         BEGIN
            SELECT   SUM (balance_amt_due)
                INTO v_bal_due
                FROM giac_soa_rep_ext a, giac_soa_title b
               WHERE 1 = 1
                 AND a.column_no = b.col_no
                 AND b.rep_cd = 1
                 AND a.column_no = p_col_no
                 AND a.user_id = UPPER (p_user)
                 AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                 AND a.intm_no = NVL (p_intm_no, a.intm_no)
                 AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
            --HAVING ABS(SUM (NVL (balance_amt_due, 0))) >= ABS(NVL (p_bal_amt_due, 0))
            GROUP BY a.branch_cd,
                     a.intm_name,
                     a.intm_no,
                     a.intm_type,
                     a.column_title;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                        (-20201,
                            'Returns more than requested number of rows for '
                         || p_intm_no
                         || '-'
                         || p_col_no
                        );
         END;
      ELSIF p_rep_id = 'GIACR191'
      THEN
         BEGIN
            SELECT   SUM (balance_amt_due)
                INTO v_bal_due
                FROM giac_soa_rep_ext a, giac_soa_title b
               WHERE 1 = 1
                 AND a.column_no = b.col_no
                 AND b.rep_cd = 1
                 AND a.column_no = p_col_no
                 AND a.user_id = UPPER (p_user)
                 AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                 AND a.assd_no = NVL (p_assd_no, a.assd_no)
                 AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
                 AND a.policy_no = NVL (p_policy_no, a.policy_no)
                 AND a.intm_no = p_intm_no                 --mikel 05.03.2013;
                 AND    a.iss_cd
                     || '-'
                     || LPAD (a.prem_seq_no, 12, 0)
                     || '-'
                     || a.inst_no = p_bill_no               --mikel 05.03.2013
            GROUP BY a.branch_cd,
                     a.assd_name,
                     a.assd_no,
                     a.policy_no,
                     a.column_title,
                     a.intm_no,
                        a.iss_cd
                     || '-'
                     || LPAD (a.prem_seq_no, 12, 0)
                     || '-'
                     || a.inst_no;                         --mikel 05.03.2013;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                        (-20201,
                            'Returns more than requested number of rows for '
                         || p_assd_no
                         || '-'
                         || p_col_no
                        );
         END;
      ELSIF p_rep_id = 'GIACR192'
      THEN
         BEGIN
            SELECT   SUM (balance_amt_due)
                INTO v_bal_due
                FROM giac_soa_rep_ext a, giac_soa_title b
               WHERE 1 = 1
                 AND a.column_no = b.col_no
                 AND b.rep_cd = 1
                 AND a.column_no = p_col_no
                 AND a.user_id = UPPER (p_user)
                 AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                 AND a.assd_no = NVL (p_assd_no, a.assd_no)
                 AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
            GROUP BY a.branch_cd, a.assd_name, a.assd_no, a.column_title;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                        (-20201,
                            'Returns more than requested number of rows for '
                         || p_assd_no
                         || '-'
                         || p_col_no
                        );
         END;
      END IF;

      RETURN (NVL (v_bal_due, 0));
   END;

   FUNCTION get_col_title (p_col_no NUMBER)
      RETURN VARCHAR2
   IS
      v_col_title   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT REPLACE (RTRIM (   'DAYS_'
                                || REPLACE (REPLACE (col_title, 'DAYS', ''),
                                            '-',
                                            '_TO_'
                                           )
                               ),
                         ' ',
                         '_'
                        )
           INTO v_col_title
           FROM giac_soa_title
          WHERE rep_cd = 1 AND col_no = p_col_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_col_title);
   END;

   /* Modified by Joms Diago 05092013 */
   FUNCTION csv_giacr189 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr189_type PIPELINED
   IS
      v_giacr189   giacr189_rec_type;
   --v_balance_amt_due     NUMBER := 0.00; --Joms 05092013
   BEGIN
      FOR rec IN (SELECT   a.branch_cd, UPPER (a.intm_name) intm_name,
                           intm_no, a.policy_no, a.incept_date, a.ref_pol_no,
                           a.assd_no, a.assd_name,
                              a.iss_cd
                           || '-'
                           || LPAD (a.prem_seq_no, 12, 0)
                           || '-'
                           || a.inst_no bill_no,
                           a.due_date, SUM (a.prem_bal_due) prem_bal_due,
                           SUM (a.tax_bal_due) tax_bal_due,
                           SUM (a.balance_amt_due) balance_amt_due
                      FROM giac_soa_rep_ext a, giis_issource b
                     WHERE balance_amt_due >=
                                         NVL (p_bal_amt_due, balance_amt_due)
                       AND a.intm_name IS NOT NULL
                       AND a.branch_cd IS NOT NULL
                       AND b.iss_name IS NOT NULL
                       AND a.balance_amt_due <> 0
                       -- replaced prem_bal_due Ladz 0522213
                       AND a.branch_cd = b.iss_cd
                       AND branch_cd LIKE NVL (p_branch_cd, '%')
                       AND intm_no = NVL (p_intm_no, intm_no)
                       AND intm_type LIKE NVL (p_intm_type, '%')
                       AND a.user_id = UPPER (p_user)
                       AND due_tag =
                                DECODE (p_inc_overdue,
                                        'I', due_tag,
                                        'N', 'Y'
                                       )
                  GROUP BY a.branch_cd,
                           a.assd_no,
                           a.assd_name,
                           a.policy_no,
                           a.incept_date,
                           a.ref_pol_no,
                           UPPER (a.intm_name),
                              a.iss_cd
                           || '-'
                           || LPAD (a.prem_seq_no, 12, 0)
                           || '-'
                           || a.inst_no,
                           a.due_date,
                           b.iss_cd,
                           a.iss_cd,
                           intm_no           --mikel 05.03.2013; added intm_no
                  ORDER BY a.branch_cd, a.assd_name, a.policy_no, 9)
      LOOP
         v_giacr189.branch_cd := rec.branch_cd;
         v_giacr189.branch_name :=
                                csv_soa.cf_branch_nameformula (rec.branch_cd);
         v_giacr189.assd_name := rec.assd_name;
         v_giacr189.policy_no := rec.policy_no;
         v_giacr189.incept_date := rec.incept_date;
         v_giacr189.ref_pol_no := rec.ref_pol_no;
         v_giacr189.intm_name := rec.intm_name;
         v_giacr189.bill_no := rec.bill_no;
         v_giacr189.due_date := rec.due_date;
         v_giacr189.prem_bal_due := ROUND (rec.prem_bal_due, 5);
         v_giacr189.tax_bal_due := ROUND (rec.tax_bal_due, 5);
         v_giacr189.balance_amt_due := ROUND (rec.balance_amt_due, 5);
         v_giacr189.col_no1 :=
            csv_soa.get_bal_per_col_per_title (1,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no2 :=
            csv_soa.get_bal_per_col_per_title (2,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no3 :=
            csv_soa.get_bal_per_col_per_title (3,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no4 :=
            csv_soa.get_bal_per_col_per_title (4,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no5 :=
            csv_soa.get_bal_per_col_per_title (5,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no6 :=
            csv_soa.get_bal_per_col_per_title (6,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no7 :=
            csv_soa.get_bal_per_col_per_title (7,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no8 :=
            csv_soa.get_bal_per_col_per_title (8,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no9 :=
            csv_soa.get_bal_per_col_per_title (9,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no10 :=
            csv_soa.get_bal_per_col_per_title (10,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no11 :=
            csv_soa.get_bal_per_col_per_title (11,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no12 :=
            csv_soa.get_bal_per_col_per_title (12,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no13 :=
            csv_soa.get_bal_per_col_per_title (13,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         v_giacr189.col_no14 :=
            csv_soa.get_bal_per_col_per_title (14,
                                               p_rep_id,
                                               USER,
                                               rec.branch_cd,
                                               rec.intm_no,
                                               rec.assd_no,
                                               p_inc_overdue,
                                               p_bal_amt_due,
                                               rec.policy_no,
                                               rec.bill_no
                                              );
         PIPE ROW (v_giacr189);
              /*FOR rec IN (SELECT a.branch_cd, intm_no,  UPPER (a.intm_name) intm_name, a.policy_no,
                               a.incept_date, a.ref_pol_no, a.assd_name , a.assd_no ,
                               a.iss_cd || '-' || LPAD(a.prem_seq_no,12, 0) || '-' || a.inst_no bill_no, a.due_date,
                               SUM(a.prem_bal_due) prem_bal_due, SUM(a.tax_bal_due) tax_bal_due, SUM(a.balance_amt_due) balance_amt_due
                          FROM giac_soa_rep_ext a, giis_issource b
                FROM     giac_soa_rep_ext a,
                         giis_issource b
                WHERE    BALANCE_AMT_DUE>=NVL(p_bal_amt_due, BALANCE_AMT_DUE)
                         AND a.intm_name IS NOT NULL
                         AND a.branch_cd IS NOT NULL
                         AND b.iss_name IS NOT NULL
                         AND a.PREM_BAL_DUE <> 0
                         AND a.branch_cd = b.iss_cd
                         AND BRANCH_CD LIKE NVL(p_branch_cd,'%')
                         AND INTM_NO = NVL(p_intm_no,INTM_NO)
                         AND intm_type LIKE nvl(p_intm_type, '%')
                         AND a.USER_ID = UPPER(USER)
                         AND DUE_TAG = DECODE(p_inc_overdue, 'I',DUE_TAG,'N','Y')
                         AND check_user_per_iss_cd_acctg (NULL, a.branch_cd, 'GIACS180') = 1
               GROUP BY  a.policy_no, a.branch_cd, a.intm_name, a.iss_cd||'-'||a.prem_seq_no||'-'||a.inst_no, a.intm_no, a.intm_type,
                         a.incept_date, a.ref_pol_no, a.assd_no, a.assd_name, a.prem_bal_due,
                         a.tax_bal_due,
                         a.balance_amt_due,
                         a.aging_id,
                         a.no_of_days,
                         a.due_date,
                         a.column_no,
                         a.column_title,
                         a.expiry_date,
                         a.iss_cd,
                         a.prem_seq_no,
                         a.inst_no,
                         b.iss_name
               ORDER BY  2,UPPER(intm_name),1,4 ,INST_NO
                         )
             LOOP

             v_giacr189.days_1_to_30        := '0.00';
             v_giacr189.days_31_to_60       := '0.00';
             v_giacr189.days_61_to_90       := '0.00';
             v_giacr189.days_91_to_120      := '0.00';
             v_giacr189.days_121_to_150     := '0.00';
             v_giacr189.days_151_to_180     := '0.00';
             v_giacr189.days_over_181       := '0.00';

              v_giacr189.branch_cd        :=  rec.branch_cd;
              v_giacr189.branch_name      :=  csv_soa.CF_BRANCH_NAMEFormula(rec.branch_cd);
              v_giacr189.intm_name        :=  rec.intm_name;
              v_giacr189.policy_no        :=  rec.policy_no;
              v_giacr189.intm_name        :=  rec.intm_name;
              v_giacr189.incept_date      :=  rec.incept_date;

              v_giacr189.ref_pol_no       :=  rec.ref_pol_no;
              v_giacr189.assd_name        :=  rec.assd_name;
              v_giacr189.bill_no          :=  rec.bill_no;
              v_giacr189.date_due         :=  rec.due_date;
              v_giacr189.prem_bal_due     :=  ROUND(rec.prem_bal_due,5);
              v_giacr189.tax_bal_due      :=  ROUND(rec.tax_bal_due,5);

              v_balance_amt_due           :=  ROUND(rec.balance_amt_due,5);
              v_giacr189.balance_amt_due  :=  v_balance_amt_due;

      --        v_giacr189.days_1_to_30     :=  csv_soa.get_bal_per_col_per_title(1, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      --        v_giacr189.days_31_to_60          :=  csv_soa.get_bal_per_col_per_title(2, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      --        v_giacr189.days_61_to_90          :=  csv_soa.get_bal_per_col_per_title(3, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      --        v_giacr189.days_91_to_120          :=  csv_soa.get_bal_per_col_per_title(4, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      --        v_giacr189.days_121_to_150          :=  csv_soa.get_bal_per_col_per_title(5, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      --        v_giacr189.days_151_to_180          :=  csv_soa.get_bal_per_col_per_title(6, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      --        v_giacr189.days_over_181          :=  csv_soa.get_bal_per_col_per_title(7, p_rep_id, user, rec.branch_cd, NULL, rec.assd_no, p_inc_overdue, p_bal_amt_due, rec.policy_no);
      ----
              IF rec.column_no = 1 THEN
                 v_giacr189.days_1_to_30       :=  v_balance_amt_due;
              ELSIF rec.column_no = 2 THEN
                 v_giacr189.days_31_to_60      :=  v_balance_amt_due;
              ELSIF rec.column_no = 3 THEN
                 v_giacr189.days_61_to_90      :=  v_balance_amt_due;
              ELSIF rec.column_no = 4 THEN
                 v_giacr189.days_91_to_120     :=  v_balance_amt_due;
              ELSIF rec.column_no = 5 THEN
                 v_giacr189.days_121_to_150    :=  v_balance_amt_due;
              ELSIF rec.column_no = 6 THEN
                 v_giacr189.days_151_to_180    :=  v_balance_amt_due;
              ELSE
                 v_giacr189.days_over_181      :=  v_balance_amt_due;
              END IF;*/
      END LOOP;

      RETURN;
   END;

   /* Added by: RCDatu
   ** Date added: 11.15.2013
   ** Remarks: Compute commission amount per installment.
   */
   FUNCTION get_giacr199_comm_amt (
      p_balance_amt   giac_soa_rep_ext.balance_amt_due%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_inst_no       gipi_installment.inst_no%TYPE,
      p_cut_off       DATE,
      p_user_id       VARCHAR2 -- added by MarkS 5.18.2016 SR-22192
   )
      RETURN NUMBER
   IS
      v_comm        gipi_comm_invoice.commission_amt%TYPE   := 0;
      v_comm_paid   giac_comm_payts.comm_amt%TYPE           := 0;
      v_comm_paid2  giac_comm_payts.comm_amt%TYPE           := 0; --added by Daniel Marasigan SR-22232
      v_inst_no     gipi_installment.inst_no%TYPE;
      v_comm_amt    v_comm_amt_tab;
      v_zero        NUMBER                                  := 0;
      v_differ      gipi_comm_invoice.commission_amt%TYPE   := 0;
   BEGIN
      IF p_balance_amt = 0
      THEN                                                  --vondanix 100913
         RETURN (0);
      ELSE
         FOR ca2 IN
            (SELECT   /*+ index(b INVOICE_PK) */
                        SUM (NVL (gcip.commission_amt, 0) * b.currency_rt
                            )
                      -- - SUM (NVL (gpci.commission_amt, 0) * b.currency_rt) --removed by Daniel Marasigan SR-22232;
                                                              commission_amt,
                      c.iss_cd, c.prem_seq_no, c.inst_no, c.intm_no
                 FROM giac_parent_comm_invprl gpci,
                      gipi_comm_inv_peril gcip,
                      gipi_invoice b,
                      giac_soa_rep_ext c
                WHERE gpci.iss_cd(+) = gcip.iss_cd
                  AND gpci.prem_seq_no(+) = gcip.prem_seq_no
                  AND gpci.peril_cd(+) = gcip.peril_cd
                  AND gcip.intrmdry_intm_no = p_intm_no
                  AND gcip.iss_cd = p_iss_cd
                  AND gcip.prem_seq_no = p_prem_seq_no
                  AND gcip.iss_cd = b.iss_cd
                  AND gcip.prem_seq_no = b.prem_seq_no
                  AND gcip.prem_seq_no(+) = c.prem_seq_no
                  AND gcip.intrmdry_intm_no(+) = c.intm_no
                  AND gcip.iss_cd(+) = c.iss_cd
                  AND c.inst_no = p_inst_no
                  AND c.user_id = p_user_id -- added by MarkS 5.18.2016 SR-22192
             GROUP BY c.iss_cd, c.prem_seq_no, c.intm_no, c.inst_no
             ORDER BY c.iss_cd, c.prem_seq_no, c.intm_no, c.inst_no)
         LOOP
            IF ca2.commission_amt = 0
            THEN
               RETURN (v_zero);
            END IF;

            FOR i IN (SELECT MAX (inst_no) inst_no
                        FROM gipi_installment
                       WHERE iss_cd = ca2.iss_cd
                         AND prem_seq_no = ca2.prem_seq_no)
            LOOP
               v_inst_no := i.inst_no;
               EXIT;
            END LOOP;

            v_comm := ca2.commission_amt / v_inst_no;

            FOR ca1 IN
               (SELECT   /*+ index(b gacc_pk) */
                         a.gacc_tran_id, SUM (a.comm_amt) comm_amt
                    FROM giac_comm_payts a, giac_acctrans b
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gacc_tran_id NOT IN (
                            SELECT c.tran_id
                              FROM giac_acctrans c, giac_reversals b
                             WHERE b.reversing_tran_id = c.tran_id
                               AND c.tran_flag <> 'D')
                     AND a.intm_no = p_intm_no
                     AND a.iss_cd = p_iss_cd
                     AND a.prem_seq_no = p_prem_seq_no
                     AND TRUNC (b.tran_date) <= TRUNC (TO_DATE (p_cut_off))
                     AND b.tran_flag <> 'D'
                GROUP BY a.gacc_tran_id)
            LOOP
               v_comm_paid := v_comm_paid + NVL (ca1.comm_amt, 0);
               EXIT;
            END LOOP;
            
			--added by Daniel Marasigan SR-22232
            FOR ca3 IN
               (SELECT   
                         a.gacc_tran_id, SUM (a.comm_amt) comm_amt
                    FROM giac_ovride_comm_payts a, giac_acctrans b
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gacc_tran_id NOT IN (
                            SELECT c.tran_id
                              FROM giac_acctrans c, giac_reversals b
                             WHERE b.reversing_tran_id = c.tran_id
                               AND c.tran_flag <> 'D')
                     AND a.intm_no = p_intm_no
                     AND a.iss_cd = p_iss_cd
                     AND a.prem_seq_no = p_prem_seq_no
                     AND TRUNC (b.tran_date) <= TRUNC (TO_DATE (p_cut_off))
                     AND b.tran_flag <> 'D'
                GROUP BY a.gacc_tran_id)
            LOOP
               v_comm_paid2 := NVL (ca3.comm_amt, 0);
               EXIT;
            END LOOP;
            
            FOR a IN 1 .. v_inst_no --added "+ v_comm_paid2"; Daniel Marasigan SR-22232; included parent agent's debt/share, as advised by sir JM
            LOOP
               IF (v_comm_paid + v_comm_paid2) >= v_comm AND SIGN (v_comm) = 1
               THEN
                  v_comm_amt (a) := 0;
                  v_comm_paid := v_comm_paid - v_comm;
                  v_comm_paid2 := v_comm_paid2 - v_comm;
               ELSIF (v_comm_paid + v_comm_paid2) <= v_comm AND SIGN (v_comm) = -1
               THEN
                  v_comm_amt (a) := 0;
                  v_comm_paid := v_comm_paid - v_comm;
                  v_comm_paid2 := v_comm_paid2 - v_comm;
               ELSE
                  v_comm_amt (a) := v_comm - (v_comm_paid + v_comm_paid2);
                  v_comm_paid := 0;
               END IF;

               v_differ := v_differ + v_comm;
            END LOOP;

            IF ca2.inst_no = v_inst_no AND ca2.commission_amt - v_differ != 0
            THEN
               IF ca2.commission_amt > v_differ
               THEN
                  RETURN (  v_comm_amt (ca2.inst_no)
                          + ABS ((ca2.commission_amt - v_differ))
                         );
               ELSE
                  RETURN (  v_comm_amt (ca2.inst_no)
                          - ABS ((ca2.commission_amt - v_differ))
                         );
               END IF;
            ELSE
               RETURN (v_comm_amt (ca2.inst_no));
            END IF;
         END LOOP;
      END IF;

      RETURN (0);                                           --vondanix 10/4/13
   END;

      /*
   ** Added by: RCDatu
   ** Date: 11.15.2013
   ** Remarks: From GIACR199 version 10.10.2013 07:12PM
   */
   FUNCTION get_gstformula (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_cut_off       DATE
   )
      RETURN NUMBER
   IS
      v_gst      NUMBER := 0;
      v_gst_cd   NUMBER := giacp.n ('GST');
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_inv_tax
                 WHERE iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND tax_cd = v_gst_cd)
      LOOP
         FOR i IN
            (SELECT (  (NVL (a.commission_amt, 0) - NVL (c.comm_amt, 0))
                     * (NVL (b.input_vat_rate, 0) / 100)
                    ) gst
               FROM gipi_comm_invoice a,
                    giis_intermediary b,
                    (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                              SUM (j.comm_amt) comm_amt,
                              SUM (j.wtax_amt) wtax_amt,
                              SUM (j.input_vat_amt) input_vat_paid
                         FROM giac_comm_payts j, giac_acctrans k
                        WHERE j.gacc_tran_id = k.tran_id
                          AND k.tran_flag <> 'D'
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag != 'D'
                                    AND x.gacc_tran_id = j.gacc_tran_id)
                          AND TRUNC (k.tran_date) <=
                                                   TRUNC (TO_DATE (p_cut_off))
                     GROUP BY intm_no, iss_cd, prem_seq_no) c
              WHERE a.intrmdry_intm_no = b.intm_no
                AND a.iss_cd = c.iss_cd(+)
                AND a.prem_seq_no = c.prem_seq_no(+)
                AND a.intrmdry_intm_no = c.intm_no(+)
                AND a.iss_cd = p_iss_cd
                AND a.prem_seq_no = p_prem_seq_no
                AND a.intrmdry_intm_no = p_intm_no)
         LOOP
            v_gst := i.gst;
         END LOOP;
      END LOOP;

      RETURN (v_gst);
   END;

      /*
   ** Added by: RCDatu
   ** Modified on: 11.19.2013
   ** Remarks    : Input VAT amount formula from 10.10.2013 GIACR199 version
   */
   FUNCTION get_input_vatformula (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_inst_no       gipi_installment.inst_no%TYPE,
      p_cut_off       DATE,
      p_user_id       VARCHAR2 -- added by MarkS 5.18.2016 SR-22192
   )
      RETURN NUMBER
   IS
      v_input_vat    NUMBER (16, 2);
      v_invat_paid   giac_comm_payts.input_vat_amt%TYPE   := 0;
      v_inst_no      gipi_installment.inst_no%TYPE;
      v_invat_amt    v_invat_amt_tab;
      v_zero         NUMBER                               := 0;
      v_differ       giac_comm_payts.input_vat_amt%TYPE   := 0;
   BEGIN
      FOR invat IN (SELECT   /*+ index(b INVOICE_PK) */
                             SUM (  (  NVL (gcip.commission_amt
                                            * b.currency_rt,
                                            0
                                           )
                                     - NVL (gpci.commission_amt
                                            * b.currency_rt,
                                            0
                                           )
                                    )
                                  * (NVL (e.input_vat_rate, 0) / 100)
                                 ) input_vat,
                             c.iss_cd, c.prem_seq_no, c.inst_no, c.intm_no
                        FROM giac_parent_comm_invprl gpci,
                             gipi_comm_inv_peril gcip,
                             gipi_invoice b,
                             giac_soa_rep_ext c,
                             giis_intermediary e
                       WHERE gpci.iss_cd(+) = gcip.iss_cd
                         AND gpci.prem_seq_no(+) = gcip.prem_seq_no
                         AND gpci.peril_cd(+) = gcip.peril_cd
                         AND gcip.intrmdry_intm_no = p_intm_no
                         AND gcip.iss_cd = p_iss_cd
                         AND gcip.prem_seq_no = p_prem_seq_no
                         AND gcip.iss_cd = b.iss_cd
                         AND gcip.prem_seq_no = b.prem_seq_no
                         AND gcip.prem_seq_no(+) = c.prem_seq_no
                         AND gcip.intrmdry_intm_no(+) = c.intm_no
                         AND gcip.iss_cd(+) = c.iss_cd
                         AND gcip.intrmdry_intm_no = e.intm_no
                         AND c.inst_no = p_inst_no
                         AND c.user_id = p_user_id -- USER -- added by MarkS 5.18.2016 SR-22192
                    GROUP BY c.iss_cd, c.prem_seq_no, c.intm_no, c.inst_no
                    ORDER BY c.iss_cd, c.prem_seq_no, c.intm_no, c.inst_no)
      LOOP
         IF invat.input_vat = 0
         THEN
            RETURN (v_zero);
         END IF;

         FOR i IN (SELECT MAX (inst_no) inst_no
                     FROM gipi_installment
                    WHERE iss_cd = invat.iss_cd
                      AND prem_seq_no = invat.prem_seq_no)
         LOOP
            v_inst_no := i.inst_no;
            EXIT;
         END LOOP;

         v_input_vat := invat.input_vat / v_inst_no;

         FOR invat_paid IN
            (SELECT   /*+ index(k gacc_pk) */
                      j.gacc_tran_id, SUM (j.input_vat_amt) invat_amt
                 FROM giac_comm_payts j, giac_acctrans k
                WHERE j.gacc_tran_id = k.tran_id
                  AND j.gacc_tran_id NOT IN (
                         SELECT x.gacc_tran_id
                           FROM giac_reversals x, giac_acctrans y
                          WHERE x.reversing_tran_id = y.tran_id
                            AND y.tran_flag != 'D')
                  AND j.intm_no = p_intm_no
                  AND j.iss_cd = p_iss_cd
                  AND j.prem_seq_no = p_prem_seq_no
                  AND TRUNC (k.tran_date) <= TRUNC (TO_DATE (p_cut_off))
                  AND k.tran_flag <> 'D'
             GROUP BY j.gacc_tran_id)
         LOOP
            v_invat_paid := v_invat_paid + NVL (invat_paid.invat_amt, 0);
            EXIT;
         END LOOP;

         FOR a IN 1 .. v_inst_no
         LOOP
            IF v_invat_paid >= v_input_vat AND SIGN (v_input_vat) = 1
            THEN
               v_invat_amt (a) := 0;
               v_invat_paid := v_invat_paid - v_input_vat;
            ELSIF v_invat_paid <= v_input_vat AND SIGN (v_input_vat) = -1
            THEN
               v_invat_amt (a) := 0;
               v_invat_paid := v_invat_paid - v_input_vat;
            ELSE
               v_invat_amt (a) := v_input_vat - v_invat_paid;
               v_invat_paid := 0;
            END IF;

            v_differ := v_differ + v_input_vat;
         END LOOP;

         IF invat.inst_no = v_inst_no AND invat.input_vat - v_differ != 0
         THEN
            IF invat.input_vat > v_differ
            THEN
               RETURN (  v_invat_amt (invat.inst_no)
                       + ABS ((invat.input_vat - v_differ))
                      );
            ELSE
               RETURN (  v_invat_amt (invat.inst_no)
                       - ABS ((invat.input_vat - v_differ))
                      );
            END IF;
         ELSE
            RETURN (v_invat_amt (invat.inst_no));
         END IF;
      END LOOP;
      RETURN (v_zero);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (v_zero);
   END;
   
   
   /* added by carlo de guzman
    date 3.09.2016
   */

    FUNCTION csv_giacr197a(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_ASSD_NO         NUMBER,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_TYPE       VARCHAR2,
     P_USER            VARCHAR2
    )
     RETURN populate_giacr197a_tab PIPELINED
    AS
     ntt            populate_giacr197a_type;
     v_bm           VARCHAR2(5);
     v_tag          VARCHAR2(5);
     v_name1        VARCHAR2(75);
     v_name2        VARCHAR2(75);
     v_from_date1   DATE; 
     v_to_date1     DATE;
     v_from_date2   DATE;
     v_to_date2     DATE;
     v_and          VARCHAR2(25);
     v_rep_date     VARCHAR2(9);
     v_as_of_date   DATE;
     v_param_date   DATE;
     v_count        NUMBER(1) := 0;
     
    BEGIN
      
    
         FOR i IN (
            SELECT   UPPER (a.assd_name) assd_name, a.assd_no, a.column_title,
                     a.prem_bal_due, a.tax_bal_due, a.balance_amt_due, a.policy_no,
                     a.inst_no,
                     a.iss_cd || '-' || LPAD(a.prem_seq_no,12,0) || '-' || LPAD(a.inst_no,2,0) bill_no, --Dren 04.28.2016 SR-5341
                     a.due_date, a.incept_date, a.no_of_days, a.ref_pol_no, a.branch_cd,
                     a.intm_type, b.col_no,
                     SUM (DECODE (c.tax_cd, 8, c.tax_bal_due, 0)) doc_stamps,
                     SUM (DECODE (c.tax_cd, 9, c.tax_bal_due, 0)) lgt,
                     SUM (DECODE (c.tax_cd, 10, c.tax_bal_due, 0)) fst,
                       SUM (DECODE (c.tax_cd, 1, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 2, c.tax_bal_due, 0)) "PTAX_EVAT",
                       SUM (DECODE (c.tax_cd, 3, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 4, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 5, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 6, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 7, c.tax_bal_due, 0)) "OTHER_TAX"
                FROM GIAC_SOA_REP_EXT a, GIAC_SOA_TITLE b, GIAC_SOA_REP_TAX_EXT c
               WHERE 1 = 1
                 AND a.iss_cd = c.iss_cd
                 AND a.prem_seq_no = c.prem_seq_no
                 AND a.inst_no = c.inst_no
                 AND a.user_id = c.user_id
                 AND a.column_title = b.col_title
                 AND a.balance_amt_due != 0
                 AND a.user_id = P_USER
                 AND a.assd_no = NVL (P_ASSD_NO, a.assd_no)
                 AND a.branch_cd = NVL (P_BRANCH_CD, a.branch_cd)
                 AND a.intm_type = NVL (P_INTM_TYPE, intm_type)
                 AND a.due_tag = DECODE (P_INC_OVERDUE, 'I', a.due_tag, 'N', 'Y')
                 AND prem_bal_due >= NVL (P_BAL_AMT_DUE, prem_bal_due)
            GROUP BY a.assd_name,
                     a.assd_no,
                     a.column_title,
                     a.prem_bal_due,
                     a.tax_bal_due,
                     a.balance_amt_due,
                     a.policy_no,
                     a.inst_no,
                     a.iss_cd || '-' || LPAD(a.prem_seq_no,12,0) || '-' || LPAD(a.inst_no,2,0), --Dren 04.28.2016 SR-5341
                     a.due_date,
                     a.incept_date,
                     a.no_of_days,
                     a.ref_pol_no,
                     a.branch_cd,
                     a.intm_type,
                     b.col_no
             ORDER BY a.branch_cd, a.assd_no, b.col_no, a.policy_no, bill_no --Dren 04.28.2016 SR-5341
        
        )
        
        LOOP
         
            ntt.branch_code    := i.branch_cd;
            ntt.assured      := i.assd_name;
            ntt.assured_no         := i.assd_no;
            ntt.column_title    := i.column_title;
            ntt.policy_number       := i.policy_no;
            ntt.bill_no         := i.bill_no;
            ntt.due_date        := i.due_date;
            ntt.incept_date     := i.incept_date;
            ntt.age      := i.no_of_days;
            ntt.ref_pol_no      := i.ref_pol_no;
            ntt.premium_balance_due    := i.prem_bal_due;
            ntt.tax_balance_due     := i.tax_bal_due;
            ntt.balance_amount_due := i.balance_amt_due;
            ntt.documentary_stamps      := i.doc_stamps;
            ntt.local_government_tax             := i.lgt;
            ntt.fire_service_tax             := i.fst;
            ntt.premium_tax_vat       := i.ptax_evat;
            ntt.other_taxes       := i.other_tax;
            v_count := 1;
            
            BEGIN
                SELECT iss_name
                INTO ntt.branch_name  
                 FROM giis_issource
                 WHERE iss_cd = i.branch_cd;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN ntt.branch_name := '';
            END;
             
             BEGIN
               SELECT DECODE( SIGN(3-NVL(LENGTH(BILL_ADDR1||BILL_ADDR2||BILL_ADDR3), 0)), 1, 'MAIL',-1,'BILL','MAIL') ADDR
                 INTO v_bm
                 FROM GIIS_ASSURED
                WHERE ASSD_NO = i.assd_no;
                
                IF (V_BM = 'MAIL' OR V_BM IS NULL) THEN
                     SELECT MAIL_ADDR1||DECODE(MAIL_ADDR2,NULL,'',' ')||MAIL_ADDR2||DECODE(MAIL_ADDR3,NULL,'',' ')||MAIL_ADDR3
                       INTO ntt.address
                       FROM GIIS_ASSURED
                      WHERE ASSD_NO = i.assd_no;
                ELSIF V_BM = 'BILL' THEN
                     SELECT BILL_ADDR1||DECODE(BILL_ADDR2,NULL,'',' ')||BILL_ADDR2||DECODE(BILL_ADDR3,NULL,'',' ')||BILL_ADDR3
                       INTO ntt.address
                       FROM GIIS_ASSURED
                      WHERE ASSD_NO = i.assd_no;
                ELSE
                     ntt.address := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
                END IF;
                
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ntt.address := '';
                  WHEN TOO_MANY_ROWS THEN
                    ntt.address := '';
             
             END; 
            
        PIPE ROW(ntt);
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW(ntt);
        END IF;
        
    END;
   
   
   
END csv_soa;
/
