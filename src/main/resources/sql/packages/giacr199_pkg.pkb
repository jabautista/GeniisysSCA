CREATE OR REPLACE PACKAGE BODY CPI.giacr199_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 05.31.2013
    **  Reference By : GIACR199 - STATEMENT OF ACCOUNTS
    */
   FUNCTION get_details (
      p_bal_amt_due   NUMBER,
      p_user          VARCHAR,
      p_intm_no       VARCHAR,
      p_intm_type     VARCHAR,
      p_branch_cd     VARCHAR,
      p_inc_overdue   VARCHAR,
      p_cut_off       VARCHAR
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list         get_details_type;
      v_tag          VARCHAR2 (5);
      v_name1        VARCHAR2 (75);
      v_name2        VARCHAR2 (75);
      v_from_date1   DATE;
      v_to_date1     DATE;
      v_from_date2   DATE;
      v_to_date2     DATE;
      v_and          VARCHAR2 (25);
      dsp_name       VARCHAR2 (300);
      v_as_of_date   DATE;
      v_header       giac_parameters.param_value_v%TYPE
                                                    := giacp.v ('SOA_HEADER');
      v_from_to      giac_parameters.param_value_v%TYPE
                                                   := giacp.v ('SOA_FROM_TO');
      v_ref_date     giac_parameters.param_value_v%TYPE
                                                  := giacp.v ('SOA_REF_DATE');
      v_intm_add     VARCHAR2 (250);
      v_bm           VARCHAR2 (5);
      v_comm         NUMBER (16, 2);
      v_comm_paid    NUMBER (16, 2);
      v_comm_parent  NUMBER (16, 2)     := 0;    --added by Daniel Marasigan SR-22232
      v_whtax        NUMBER (16, 2);
      v_wtax_paid    NUMBER (16, 2);
      v_inst_no      NUMBER;                     --added by Daniel Marasigan SR-22232
   BEGIN 
      IF v_header = 'Y'
      THEN
         BEGIN
            SELECT param_value_v
              INTO v_list.cf_company
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.cf_company :=
                              '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.cf_company :=
                       '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
         END;
      ELSE
         v_list.cf_company := NULL;
      END IF;

      IF v_header = 'Y'
      THEN
         BEGIN
            SELECT param_value_v
              INTO v_list.cf_com_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.cf_com_address :=
                           '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.cf_com_address :=
                   '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         END;
      ELSE
         v_list.cf_company := NULL;
      END IF;

      BEGIN
         v_list.report_title := giacp.v ('SOA_TITLE');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.report_title :=
                              '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.report_title :=
                      '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
      END;

      BEGIN
         v_list.date_label := giacp.v ('SOA_DATE_LABEL');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.date_label :=
                                '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.date_label :=
                        '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
      END;

      BEGIN
         v_list.cf_date := NULL;

         FOR c IN (SELECT param_date
                     FROM giac_soa_rep_ext
                    WHERE user_id = P_USER AND ROWNUM = 1)
         LOOP
            v_list.cf_date := c.param_date;
            EXIT;
         END LOOP;

         IF v_list.cf_date IS NULL
         THEN
            v_list.cf_date := SYSDATE;
         END IF;
      END;

      BEGIN
         IF v_from_to = 'Y'
         THEN
            BEGIN
               FOR c IN (SELECT date_tag, from_date1, to_date1, from_date2,
                                to_date2, as_of_date
                           FROM giac_soa_rep_ext
                          WHERE user_id = P_USER AND ROWNUM = 1)
               LOOP
                  v_tag := c.date_tag;
                  v_from_date1 := c.from_date1;
                  v_to_date1 := c.to_date1;
                  v_from_date2 := c.from_date2;
                  v_to_date2 := c.to_date2;
                  v_as_of_date := c.as_of_date;
                  EXIT;
               END LOOP;

               IF v_as_of_date IS NOT NULL
               THEN
                  v_name1 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
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
                  v_list.date_tag1 := '(Unknown Basis of Extraction)';
               END IF;

               SELECT DECODE (v_name2, NULL, NULL, ' and ')
                 INTO v_and
                 FROM DUAL;

               v_list.date_tag1 := ('Based on ' || v_name1);
               v_list.date_tag2 := (v_and || v_name2);
            END;
         ELSE
            v_list.date_tag1 := NULL;
            v_list.date_tag2 := NULL;
         END IF;
      END;

      BEGIN
         IF v_from_to = 'N'
         THEN
            IF v_ref_date = 'Y'
            THEN
               BEGIN
                  FOR c IN (SELECT date_tag, from_date1, to_date1,
                                   from_date2, to_date2, as_of_date
                              FROM giac_soa_rep_ext
                             WHERE user_id = P_USER AND ROWNUM = 1)
                  LOOP
                     v_tag := c.date_tag;
                     v_from_date1 := c.from_date1;
                     v_to_date1 := c.to_date1;
                     v_from_date2 := c.from_date2;
                     v_to_date2 := c.to_date2;
                     v_as_of_date := c.as_of_date;
                     EXIT;
                  END LOOP;

                  IF v_as_of_date IS NOT NULL
                  THEN
                     v_name1 :=
                           'As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
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
                     v_list.date_tag3 := '(Unknown Basis of Extraction)';
                  END IF;

                  SELECT DECODE (v_name2, NULL, NULL, ' and ')
                    INTO v_and
                    FROM DUAL;

                  v_list.date_tag3 := ('Based on ' || v_name1);
                  v_list.date_tag4 := (v_and || v_name2);
               END;
            ELSE
               v_list.date_tag3 := NULL;
               v_list.date_tag4 := NULL;
            END IF;
         ELSE
            v_list.date_tag3 := NULL;
            v_list.date_tag4 := NULL;
         END IF;
      END;

      BEGIN
         v_list.signatory_tag := giacp.v ('SOA_SIGNATORY');
      END;

      BEGIN
         FOR i IN (SELECT label
                     FROM giac_rep_signatory
                    WHERE report_id = 'GIACR199'
                    ORDER BY item_no)
         LOOP
            v_list.label := i.label;
            EXIT;
         END LOOP;
      END;

      BEGIN
         FOR i IN (SELECT signatory
                     FROM giac_rep_signatory a, giis_signatory_names b
                    WHERE a.signatory_id = b.signatory_id
                      AND report_id = 'GIACR199'
                    ORDER BY item_no)
         LOOP
            v_list.signatory := i.signatory;
            EXIT;
         END LOOP;
      END;

      BEGIN
         FOR i IN (SELECT designation
                     FROM giac_rep_signatory a, giis_signatory_names b
                    WHERE a.signatory_id = b.signatory_id
                      AND report_id = 'GIACR199'
                    ORDER BY item_no)
         LOOP
            v_list.designation := i.designation;
            EXIT;
         END LOOP;
      END;

      FOR i IN (SELECT   UPPER (a.intm_name) intm_name, a.intm_no,
                         a.intm_type, a.column_title, a.incept_date,
                         a.assd_no, a.assd_name, a.balance_amt_due,
                         a.policy_no,
                            a.iss_cd
                         || '-'
                         || a.prem_seq_no
                         || '-'
                         || a.inst_no bill_no,
                         a.due_date, a.expiry_date, a.no_of_days,
                         a.ref_pol_no, a.prem_bal_due, a.tax_bal_due,
                         a.iss_cd, a.prem_seq_no, a.branch_cd, b.col_no,
                         c.input_vat_rate
                    FROM giac_soa_rep_ext a,
                         giac_soa_title b,
                         giis_intermediary c
                   WHERE a.column_no = b.col_no
                     AND c.intm_no = a.intm_no
                     AND a.balance_amt_due >=
                                          NVL (p_bal_amt_due, balance_amt_due)
                     AND a.balance_amt_due != 0
                     AND a.user_id = p_user
                     AND a.intm_no = NVL (p_intm_no, a.intm_no)
                     AND a.intm_type LIKE NVL (p_intm_type, '%')
                     AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                     AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
                     AND b.rep_cd = 1
                ORDER BY a.intm_no, b.col_no, 7, 5, a.inst_no)
      LOOP
         v_list.intm_name := i.intm_name;
         v_list.intm_no := i.intm_no;
         v_list.intm_type := i.intm_type;
         v_list.column_title := i.column_title;
         v_list.incept_date := i.incept_date;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.balance_amt_due := i.balance_amt_due;
         v_list.policy_no := i.policy_no;
         v_list.bill_no := i.bill_no;
         v_list.due_date := i.due_date;
         v_list.expiry_date := i.expiry_date;
         v_list.no_of_days := i.no_of_days;
         v_list.ref_pol_no := i.ref_pol_no;
         v_list.prem_bal_due := i.prem_bal_due;
         v_list.tax_bal_due := i.tax_bal_due;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.branch_cd := i.branch_cd;
         v_list.col_no := i.col_no;
         v_list.input_vat_rate := i.input_vat_rate;

         BEGIN
            FOR j IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = i.branch_cd)
            LOOP
               v_list.branch_name := j.iss_name;
               EXIT;
            END LOOP;
         END;

         BEGIN
            FOR j IN (SELECT ref_intm_cd
                        FROM giis_intermediary
                       WHERE intm_no = i.intm_no)
            LOOP
               v_list.ref_intm := j.ref_intm_cd;
               EXIT;
            END LOOP;
         END;

         BEGIN
            v_intm_add := NULL;
            v_bm := NULL;

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
                 WHERE intm_no = i.intm_no)
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
                WHERE intm_no = i.intm_no;
            ELSIF v_bm = 'BILL'
            THEN
               SELECT    bill_addr1
                      || DECODE (bill_addr2, NULL, '', ' ')
                      || bill_addr2
                      || DECODE (bill_addr3, NULL, '', ' ')
                      || bill_addr3
                 INTO v_intm_add
                 FROM giis_intermediary
                WHERE intm_no = i.intm_no;
            ELSE
               v_intm_add := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
            END IF;

            v_list.intm_add := v_intm_add;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_add :=
                        'NO SUCH INTERMEDIARY AVAILABLE IN GIIS_INTERMEDIARY';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.intm_add :=
                           'TOO MANY VALUES FOR ADDRESS IN GIIS_INTERMEDIARY';
         END;

         BEGIN
            v_comm := NULL;
            v_comm_paid := NULL;

            FOR c IN
               (SELECT   gspe.gacc_tran_id, SUM (gspe.comm_amt) comm_amt
                    FROM giac_comm_payts gspe, giac_acctrans c
                   WHERE gspe.gacc_tran_id = c.tran_id
                     AND gspe.gacc_tran_id NOT IN (
                            SELECT a.tran_id
                              FROM giac_acctrans a, giac_reversals b
                             WHERE b.reversing_tran_id = a.tran_id
                               AND a.tran_flag <> 'D')
                     AND c.tran_flag <> 'D'
                     AND gspe.intm_no = i.intm_no
                     AND gspe.iss_cd = i.iss_cd
                     AND gspe.prem_seq_no = i.prem_seq_no
                     AND TRUNC (c.tran_date) <= TRUNC (TO_DATE (p_cut_off,'MM-DD-YYYY'))
                GROUP BY gspe.gacc_tran_id)
            LOOP
               v_comm_paid := c.comm_amt;
               EXIT;
            END LOOP;

            IF v_comm_paid IS NULL
            THEN
               v_comm_paid := 0;
            END IF;

            FOR a IN (SELECT (NVL (commission_amt, 0) * NVL (currency_rt, 1)
                             ) commission_amt
                        FROM gipi_comm_invoice a, gipi_invoice b
                       WHERE a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.intrmdry_intm_no = i.intm_no
                         AND a.iss_cd = i.iss_cd
                         AND a.prem_seq_no = i.prem_seq_no)
            LOOP
               v_comm := a.commission_amt;
               EXIT;
            END LOOP;

            IF v_comm IS NULL
            THEN
               v_comm := 0;
            END IF;

            --added by Daniel Marasigan SR-22232
            FOR parnt IN (SELECT   gspe.gacc_tran_id, SUM (gspe.comm_amt) comm_amt
                            FROM giac_ovride_comm_payts gspe, giac_acctrans c
                           WHERE gspe.gacc_tran_id = c.tran_id
                             AND gspe.gacc_tran_id NOT IN (
                                    SELECT a.tran_id
                                      FROM giac_acctrans a, giac_reversals b
                                     WHERE b.reversing_tran_id = a.tran_id
                                       AND a.tran_flag <> 'D')
                             AND c.tran_flag <> 'D'
                             AND gspe.intm_no = i.intm_no
                             AND gspe.iss_cd = i.iss_cd
                             AND gspe.prem_seq_no = i.prem_seq_no
                             AND TRUNC (c.tran_date) <= TRUNC (TO_DATE (p_cut_off,'MM-DD-YYYY'))
                        GROUP BY gspe.gacc_tran_id)
            LOOP
                v_comm_parent := NVL(parnt.comm_amt, 0);
            END LOOP;
            
            FOR x IN (SELECT MAX (inst_no) inst_no --added by Daniel Marasigan SR 22232 07.11.2016
                        FROM gipi_installment
                       WHERE iss_cd = i.iss_cd
                         AND prem_seq_no = i.prem_seq_no)
            LOOP
               v_inst_no := x.inst_no;
               EXIT;
            END LOOP;
            
            v_comm := v_comm / v_inst_no;
            v_comm := v_comm - v_comm_paid - v_comm_parent;
            v_list.cf_comm_amt := v_comm;
         END;

         BEGIN
            v_whtax := NULL;
            v_wtax_paid := NULL;

            FOR c IN
               (SELECT   gspe.gacc_tran_id, SUM (gspe.wtax_amt) wtax_amt
                    FROM giac_comm_payts gspe, giac_acctrans c
                   WHERE gspe.gacc_tran_id = c.tran_id
                     AND gspe.gacc_tran_id NOT IN (
                            SELECT a.tran_id
                              FROM giac_acctrans a, giac_reversals b
                             WHERE b.reversing_tran_id = a.tran_id
                               AND a.tran_flag <> 'D')
                     AND gspe.intm_no = i.intm_no
                     AND gspe.iss_cd = i.iss_cd
                     AND gspe.prem_seq_no = i.prem_seq_no 
                     AND TRUNC (c.tran_date) <= TRUNC (TO_DATE (p_cut_off, 'MM-DD-YYYY'))
                GROUP BY gspe.gacc_tran_id)
            LOOP
               v_wtax_paid := c.wtax_amt;
               EXIT;
            END LOOP;

            IF v_wtax_paid IS NULL
            THEN
               v_wtax_paid := 0;
            END IF;

            FOR c IN (SELECT (NVL (wholding_tax, 0) * NVL (currency_rt, 1)
                             ) wholding_tax
                        FROM gipi_comm_invoice a, gipi_invoice b
                       WHERE a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.intrmdry_intm_no = i.intm_no
                         AND a.iss_cd = i.iss_cd
                         AND a.prem_seq_no = i.prem_seq_no)
            LOOP
               v_whtax := c.wholding_tax;
            END LOOP;

            IF v_whtax IS NULL
            THEN
               v_whtax := 0;
            END IF;

            v_list.cf_whtax := v_whtax - v_wtax_paid;
         END;

         BEGIN
            v_list.cf_input_vat_amt :=
                  NVL (v_list.cf_comm_amt, 0) * NVL (i.input_vat_rate, 0)
                  / 100;
         END;

         BEGIN
            v_list.cf_net_amt :=
                 NVL (i.balance_amt_due, 0)
               - (  NVL (v_list.cf_comm_amt, 0)
                  - NVL (v_list.cf_whtax, 0)
                  + NVL (v_list.cf_input_vat_amt, 0)
                 );
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_details;
END giacr199_pkg;
/


