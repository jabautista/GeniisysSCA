CREATE OR REPLACE PACKAGE BODY CPI.giacr197_pkg
AS
   FUNCTION get_giacr197_report (
      p_assd_no       NUMBER,
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_type     VARCHAR2,
      p_month         VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list         report_type;
      v_tag          VARCHAR2 (5);
      v_name1        VARCHAR2 (75);
      v_name2        VARCHAR2 (75);
      v_from_date1   DATE;
      v_to_date1     DATE;
      v_from_date2   DATE;
      v_to_date2     DATE;
      v_and          VARCHAR2 (25);
      v_as_of_date   DATE;
      v_param_date   DATE;
      dsp_name       VARCHAR2 (300);
      v_rep_date     VARCHAR2 (1);
      v_bal_due      VARCHAR2 (16);
      v_header       giac_parameters.param_value_v%TYPE
                                                    := giacp.v ('SOA_HEADER');
      v_from_to      giac_parameters.param_value_v%TYPE
                                                   := giacp.v ('SOA_FROM_TO');
      v_ref_date     giac_parameters.param_value_v%TYPE
                                                  := giacp.v ('SOA_REF_DATE');
      v_bm           VARCHAR2 (5);
      v_count        NUMBER(1) := 0;
   BEGIN
   
     BEGIN
        SELECT param_value_v
          INTO v_list.company_name
          FROM giis_parameters
         WHERE param_name = 'COMPANY_NAME';
     EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
           v_list.company_name :=
                          '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
        WHEN TOO_MANY_ROWS
        THEN
           v_list.company_name :=
                   '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
     END;

     BEGIN
        SELECT param_value_v
          INTO v_list.company_address
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
     EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
           v_list.company_address :=
                       '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
        WHEN TOO_MANY_ROWS
        THEN
           v_list.company_address :=
               '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
     END;

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
        FOR c IN (SELECT param_date
                    FROM giac_soa_rep_ext
                   WHERE user_id = P_USER /*USER*/ AND ROWNUM = 1)
        LOOP
           v_list.report_date := c.param_date;
           EXIT;
        END LOOP;

        IF v_list.report_date IS NULL
        THEN
           v_list.report_date := SYSDATE;
        END IF;
     END;

     BEGIN
        IF v_from_to = 'Y'
        THEN
           BEGIN
              FOR c IN (SELECT a.date_tag, a.from_date1, a.to_date1,
                               a.balance_amt_due, a.from_date2,
                               a.to_date2, a.as_of_date, a.param_date,
                               b.rep_date
                          --
                        FROM   giac_soa_rep_ext a,
                               giac_soa_rep_ext_param b
                         WHERE ROWNUM = 1
                           AND a.user_id = P_USER -- USER
                           AND b.user_id = P_USER) -- USER)
              LOOP
                 v_tag := c.date_tag;
                 v_from_date1 := c.from_date1;
                 v_to_date1 := c.to_date1;
                 v_from_date2 := c.from_date2;
                 v_to_date2 := c.to_date2;
                 v_rep_date := c.rep_date;
                 v_as_of_date := c.as_of_date;
                 v_param_date := c.param_date;
                 v_bal_due := c.balance_amt_due;
                 EXIT;
              END LOOP;

              IF v_rep_date = 'F'
              THEN
                 IF v_tag = 'BK'
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
                          'Incept Dates from '
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
              ELSIF v_rep_date = 'A'
              THEN
                 IF v_tag = 'BK'
                 THEN
                    v_name1 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                    v_name2 := NULL;
                 ELSIF v_tag = 'IN'
                 THEN
                    v_name1 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                    v_name2 := NULL;
                 ELSIF v_tag = 'IS'
                 THEN
                    v_name1 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                    v_name2 := NULL;
                 ELSIF v_tag = 'BKIN'
                 THEN
                    v_name1 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                    v_name2 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                 ELSIF v_tag = 'BKIS'
                 THEN
                    v_name1 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                    v_name2 :=
                          'As Of '
                       || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                 ELSE
                    v_list.date_tag1 := '(Unknown Basis of Extraction)';
                 END IF;

                 SELECT DECODE (v_name2, NULL, NULL, ' and ')
                   INTO v_and
                   FROM DUAL;

                 v_list.date_tag1 := ('Based on ' || v_name1);
                 v_list.date_tag2 := (v_and || v_name2);
              END IF;
           END;
        ELSE
           v_list.date_tag1 := NULL;
           v_list.date_tag2 := NULL;
        END IF;
     END;

     BEGIN
        v_list.date_tag2 := NVL (v_list.date_tag2, NULL);
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
                            WHERE user_id = P_USER /*USER*/ AND ROWNUM = 1)
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
   
        SELECT NVL(giacp.v ('SOA_SIGNATORY'), 'N')
          INTO v_list.print_signatory
          FROM DUAL;
           
      FOR i IN (SELECT DISTINCT UPPER (assd_name) assd_name, column_title,
                                assd_no, intm_type, branch_cd,
                                balance_amt_due, policy_no,
                                   a.iss_cd
                                || '-'
                                || LPAD (a.prem_seq_no, 12, 0) bill_no,
                                due_date, no_of_days, ref_pol_no,
                                prem_bal_due, tax_bal_due, incept_date,
                                b.col_no, c.iss_name, c.iss_cd
                           FROM giac_soa_rep_ext a,
                                giac_soa_title b,
                                giis_issource c
                          WHERE a.column_no = b.col_no
                            AND balance_amt_due != 0
                            AND a.user_id = p_user
                            AND a.branch_cd = c.iss_cd
                            AND branch_cd = NVL (p_branch_cd, branch_cd)
                            AND intm_type = NVL (p_intm_type, intm_type)
                            AND assd_no = NVL (p_assd_no, assd_no)
                            AND due_tag =
                                   DECODE (p_inc_overdue,
                                           'I', due_tag,
                                           'N', 'Y'
                                          )
                            AND prem_bal_due >=
                                             NVL (p_bal_amt_due, prem_bal_due)
                       ORDER BY branch_cd, assd_no, b.col_no, 7)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.iss_name := i.iss_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.column_title := i.column_title;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := i.incept_date;
         v_list.ref_pol_no := i.ref_pol_no;
         v_list.bill_no := i.bill_no;
         v_list.due_date := i.due_date;
         v_list.age := i.no_of_days;
         v_list.prem_amt := i.prem_bal_due;
         v_list.tax_amt := i.tax_bal_due;
         v_list.balance_amt := i.balance_amt_due;
         v_count := 1;
         

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
                  FROM giis_assured
                 WHERE assd_no = i.assd_no)
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
                 INTO v_list.assd_address
                 FROM giis_assured
                WHERE assd_no = i.assd_no;
            ELSIF v_bm = 'BILL'
            THEN
               SELECT    bill_addr1
                      || DECODE (bill_addr2, NULL, '', ' ')
                      || bill_addr2
                      || DECODE (bill_addr3, NULL, '', ' ')
                      || bill_addr3
                 INTO v_list.assd_address
                 FROM giis_assured
                WHERE assd_no = i.assd_no;
            ELSE
               v_list.assd_address := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assd_address :=
                                  'NO SUCH ASSURED AVAILABLE IN GIIS_ASSURED';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.assd_address :=
                                'TOO MANY VALUES FOR ADDRESS IN GIIS_ASSURED';
         END;

         BEGIN
            FOR j IN (SELECT label
                        FROM giac_rep_signatory
                       WHERE report_id = 'GIACR197'
                       ORDER BY item_no)
            LOOP
               v_list.cf_label := j.label;
               EXIT;
            END LOOP;
         END;

         BEGIN
            FOR v IN (SELECT signatory
                        FROM giac_rep_signatory a, giis_signatory_names b
                       WHERE a.signatory_id = b.signatory_id
                         AND report_id = 'GIACR197'
                       ORDER BY item_no)
            LOOP
               v_list.signatory := v.signatory;
               EXIT;
            END LOOP;
         END;

         BEGIN
            FOR d IN (SELECT designation
                        FROM giac_rep_signatory a, giis_signatory_names b
                       WHERE a.signatory_id = b.signatory_id
                         AND report_id = 'GIACR197'
                       ORDER BY item_no)
            LOOP
               v_list.designation := d.designation;
               EXIT;
            END LOOP;
         END;
         
         begin
           FOR i IN (SELECT param_value_v
                               FROM giac_parameters
                              WHERE param_name LIKE 'SOA_BRANCH_TOTALS')
           LOOP
             v_list.val := i.param_value_v;
           END LOOP;  					 
         end;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_count = 0 THEN
        PIPE ROW(v_list);
      END IF;

      --RETURN;
   END get_giacr197_report;
END;
/


