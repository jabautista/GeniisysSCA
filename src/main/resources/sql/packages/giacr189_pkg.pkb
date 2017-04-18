CREATE OR REPLACE PACKAGE BODY CPI.giacr189_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 06.05.2013
    **  Reference By : GIACR189 - LOSSES PAID BORDEREAUX (PER ENROLLEE)
    */
   FUNCTION get_details (
      p_month         VARCHAR2,
      p_user          VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_intm_no       VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_assd_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_cut_off       VARCHAR2,
      p_no            VARCHAR2,
      p_bal_amt_due   NUMBER
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list                get_details_type;
      v_tag                 VARCHAR2 (5);
      v_name1               VARCHAR2 (75);
      v_name2               VARCHAR2 (75);
      v_from_date1          DATE;
      v_to_date1            DATE;
      v_from_date2          DATE;
      v_to_date2            DATE;
      v_and                 VARCHAR2 (25);
      v_rep_date            VARCHAR2 (1);
      v_param_date          DATE;
      v_as_of_date          DATE;
      v_header              giac_parameters.param_value_v%TYPE
                                                    := giacp.v ('SOA_HEADER');
      v_from_to             giac_parameters.param_value_v%TYPE
                                                   := giacp.v ('SOA_FROM_TO');
      v_ref_date            giac_parameters.param_value_v%TYPE
                                                  := giacp.v ('SOA_REF_DATE');
      v_intm_add            VARCHAR2 (250);
      v_bm                  VARCHAR2 (5);
      v_comm                NUMBER (16, 2);
      v_comm_paid           NUMBER (16, 2);
      v_whtax               NUMBER (16, 2);
      v_wtax_paid           NUMBER (16, 2);
      v_count               NUMBER (1)                           := 0;
      v_title_tab           title_tab;
     /* v_index               NUMBER                               := 0;		-- SR-4032 : shan 06.19.2015
      v_id                  NUMBER                               := 0;
      v_no_of_col_allowed   NUMBER                               := 5;*/
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
         v_list.soa_branch_total := giacp.v ('SOA_BRANCH_TOTALS');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.soa_branch_total :=
                                '(NO EXISTING SOA_BRANCH_TOTALS IN GIAC_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.soa_branch_total :=
                        '(TOO MANY VALUES FOR SOA_BRANCH_TOTALS IN GIAC_PARAMETERS)';
      END;

      BEGIN
         v_list.cf_date := NULL;

         FOR c IN (SELECT param_date
                     FROM giac_soa_rep_ext
                    WHERE user_id = p_user AND ROWNUM = 1)
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
               FOR c IN (SELECT a.date_tag, a.from_date1, a.to_date1,
                                a.from_date2, a.to_date2, a.as_of_date,
                                a.param_date, b.rep_date
                           FROM giac_soa_rep_ext a, giac_soa_rep_ext_param b
                          WHERE ROWNUM = 1
                            AND a.user_id = p_user
                            AND b.user_id = p_user)
               LOOP
                  v_tag := c.date_tag;
                  v_from_date1 := c.from_date1;
                  v_to_date1 := c.to_date1;
                  v_from_date2 := c.from_date2;
                  v_to_date2 := c.to_date2;
                  v_rep_date := c.rep_date;
                  v_as_of_date := c.as_of_date;
                  v_param_date := c.param_date;
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
                           'Booking Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
                     v_name2 := NULL;
                  ELSIF v_tag = 'IN'
                  THEN
                     v_name1 :=
                           'Incept Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
                     v_name2 := NULL;
                  ELSIF v_tag = 'IS'
                  THEN
                     v_name1 :=
                           'Issue Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
                     v_name2 := NULL;
                  ELSIF v_tag = 'BKIN'
                  THEN
                     v_name1 :=
                           'Booking Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
                     v_name2 :=
                           'Incept Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
                  ELSIF v_tag = 'BKIS'
                  THEN
                     v_name1 :=
                           'Booking Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
                     v_name2 :=
                           'Issue Dates As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                        || ' to '
                        || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
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

      v_tag := NULL;
      v_from_date1 := NULL;
      v_to_date1 := NULL;
      v_from_date2 := NULL;
      v_to_date2 := NULL;
      v_rep_date := NULL;
      v_as_of_date := NULL;
      v_param_date := NULL;

      BEGIN
         FOR c IN (SELECT a.date_tag, a.from_date1, a.to_date1, a.from_date2,
                          a.to_date2, a.as_of_date, a.param_date, b.rep_date
                     FROM giac_soa_rep_ext a, giac_soa_rep_ext_param b
                    WHERE ROWNUM = 1
                      AND a.user_id = p_user
                      AND b.user_id = p_user)
         LOOP
            v_tag := c.date_tag;
            v_from_date1 := c.from_date1;
            v_to_date1 := c.to_date1;
            v_from_date2 := c.from_date2;
            v_to_date2 := c.to_date2;
            v_rep_date := c.rep_date;
            v_as_of_date := c.as_of_date;
            v_param_date := c.param_date;
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
               v_list.date_tag3 := '(Unknown Basis of Extraction)';
            END IF;

            SELECT DECODE (v_name2, NULL, NULL, ' and ')
              INTO v_and
              FROM DUAL;

            v_list.date_tag3 := ('Based on ' || v_name1);
            v_list.date_tag4 := (v_and || v_name2);
         ELSIF v_rep_date = 'A'
         THEN
            IF v_tag = 'BK'
            THEN
               v_name1 :=
                     'Booking Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
               v_name2 := NULL;
            ELSIF v_tag = 'IN'
            THEN
               v_name1 :=
                     'Incept Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
               v_name2 := NULL;
            ELSIF v_tag = 'IS'
            THEN
               v_name1 :=
                     'Issue Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
               v_name2 := NULL;
            ELSIF v_tag = 'BKIN'
            THEN
               v_name1 :=
                     'Booking Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
               v_name2 :=
                     'Incept Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
            ELSIF v_tag = 'BKIS'
            THEN
               v_name1 :=
                     'Booking Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
               v_name2 :=
                     'Issue Dates As Of Date '
                  || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY')
                  || ' to '
                  || TO_CHAR (v_param_date, 'fmMonth DD, YYYY');
            ELSE
               v_list.date_tag3 := '(Unknown Basis of Extraction)';
            END IF;

            SELECT DECODE (v_name2, NULL, NULL, ' and ')
              INTO v_and
              FROM DUAL;

            v_list.date_tag3 := ('Based on ' || v_name1);
            v_list.date_tag4 := (v_and || v_name2);
         END IF;
      END;

      BEGIN
         v_list.signatory_tag := giacp.v ('SOA_SIGNATORY');
      END;

      BEGIN
         FOR i IN (SELECT label
                     FROM giac_rep_signatory
                    WHERE report_id = 'GIACR189'
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
                      AND report_id = 'GIACR189'
                      ORDER BY a.item_no)
         LOOP
            v_list.signatory := i.signatory;
            EXIT;
         END LOOP;
      END;

      BEGIN
         FOR i IN (SELECT designation
                     FROM giac_rep_signatory a, giis_signatory_names b
                    WHERE a.signatory_id = b.signatory_id
                      AND report_id = 'GIACR189'
                      ORDER BY a.item_no)
         LOOP
            v_list.designation := i.designation;
            EXIT;
         END LOOP;
      END;

      FOR i IN
         (SELECT   /*+ INDEX (giac_soa_rep_ext GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (giac_soa_rep_ext GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(giac_soa_rep_ext GIAC_SOA_REP_EXT_INTM_TYPE_IDX) INDEX(giac_soa_rep_ext GIAC_SOA_REP_EXT_ASSD_NO_IDX)*/
                   a.policy_no, a.branch_cd, UPPER (a.intm_name) intm_name,
                   a.intm_no, a.intm_type,            -- jenny vi lim 01062005
                                          a.ref_pol_no, a.assd_name,
                   a.assd_no,
                      a.iss_cd
                   || '-'
                   || LPAD (a.prem_seq_no, 12, 0)
                   || '-'
                   || LPAD (a.inst_no, 2, 0) bill_no,
                   a.prem_bal_due, a.tax_bal_due, a.balance_amt_due,
                   a.aging_id, a.no_of_days, a.due_date, a.column_no,
                   a.column_title, a.iss_cd, a.prem_seq_no, a.inst_no,
                   b.iss_name, a.incept_date
              FROM giac_soa_rep_ext a, giis_issource b
             WHERE balance_amt_due >= NVL (p_bal_amt_due, balance_amt_due)
               --kat 08162007
               AND a.intm_no IS NOT NULL         -- added by rose b. (3/25/08)
               AND a.intm_name IS NOT NULL       -- added by rose b. (3/25/08)
               AND a.branch_cd IS NOT NULL       -- added by rose b. (3/25/08)
               AND b.iss_name IS NOT NULL        -- added by rose b. (3/25/08)
               AND a.prem_bal_due <> 0           -- added by rose b. (3/24/08)
               AND a.branch_cd = b.iss_cd
               AND a.branch_cd LIKE NVL (p_branch_cd, '%')
               AND a.intm_no = NVL (p_intm_no, intm_no)
               AND a.intm_type LIKE NVL (p_intm_type, '%')
               -- jenny vi lim 01062005
               AND a.assd_no = NVL (p_assd_no, assd_no)
               AND a.user_id = UPPER (p_user)
               AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
          ORDER BY 2, UPPER (a.intm_name), 1, 4, a.inst_no)
      LOOP
         /*v_id := 0;		-- SR-4032 : shan 06.19.2015
         v_index := 0;
         v_title_tab := title_tab ();

         FOR t IN (SELECT DISTINCT col_title, col_no
                              FROM giac_soa_title
                             WHERE rep_cd = 1
                          ORDER BY col_no)
         LOOP
            v_index := v_index + 1;
            v_title_tab.EXTEND;
            v_title_tab (v_index).col_title := t.col_title;
            v_title_tab (v_index).col_no := t.col_no;
         END LOOP;

         v_index := 1;
         v_list.no_of_dummy := 1;

         IF v_title_tab.COUNT > v_no_of_col_allowed
         THEN
            v_list.no_of_dummy :=
                              TRUNC (v_title_tab.COUNT / v_no_of_col_allowed);

            IF MOD (v_title_tab.COUNT, v_no_of_col_allowed) > 0
            THEN
               v_list.no_of_dummy := v_list.no_of_dummy + 1;
            END IF;
         END IF;

         LOOP
            v_id := v_id + 1;
            v_list.branch_cd := NULL;
            v_list.branch_name := NULL;
            v_list.intm_type := NULL;
            v_list.intm_no := NULL;
            v_list.intm_name := NULL;
            v_list.policy_no := NULL;
            v_list.incept_date := NULL;
            v_list.ref_pol_no := NULL;
            v_list.assd_name := NULL;
            v_list.bill_no := NULL;
            v_list.due_date := NULL;
            v_list.prem_bal_due := NULL;
            v_list.tax_bal_due := NULL;
            v_list.balance_amt_due := NULL;
            v_list.col_title1 := NULL;
            v_list.col_no1 := NULL;
            v_list.col_title2 := NULL;
            v_list.col_no2 := NULL;
            v_list.col_title3 := NULL;
            v_list.col_no3 := NULL;
            v_list.col_title4 := NULL;
            v_list.col_no4 := NULL;
            v_list.col_title5 := NULL;
            v_list.col_no5 := NULL;*/		-- SR-4032 : shan 06.19.2015
            v_list.branch_cd := i.branch_cd;
            v_list.branch_name := i.iss_name;
            v_list.intm_type := i.intm_type;
            v_list.intm_no := i.intm_no;
            v_list.intm_name := i.intm_name;
            v_list.policy_no := i.policy_no;
            v_list.incept_date := i.incept_date;
            v_list.ref_pol_no := i.ref_pol_no;
            v_list.assd_name := i.assd_name;
            v_list.bill_no := i.bill_no;
            v_list.due_date := i.due_date;
            v_list.prem_bal_due := i.prem_bal_due;
            v_list.tax_bal_due := i.tax_bal_due;
            v_list.balance_amt_due := i.balance_amt_due;
            v_count := 1;
            v_list.exist_pdc := 'FALSE';
            v_list.column_no    := i.column_no;		-- SR-4032 : shan 06.19.2015
            v_list.column_title := i.column_title;	-- SR-4032 : shan 06.19.2015

            BEGIN
               FOR j IN (SELECT 1 exist
                           FROM giac_pdc_prem_colln a,
                                giac_apdc_payt_dtl b,
                                giac_apdc_payt c
                          WHERE a.pdc_id = b.pdc_id
                            AND b.apdc_id = c.apdc_id
                            AND a.iss_cd = i.iss_cd
                            AND a.prem_seq_no = i.prem_seq_no
                            AND a.inst_no = i.inst_no
                            AND c.apdc_flag = 'P'
                            AND b.check_flag NOT IN ('C', 'R')
                            AND TRUNC (c.apdc_date) <=
                                             TO_DATE (p_cut_off, 'mm-dd-yyyy'))
               LOOP
                  IF j.exist IS NOT NULL
                  THEN
                     v_list.exist_pdc := 'TRUE';
                  ELSE
                     v_list.exist_pdc := 'FALSE';
                  END IF;
               END LOOP;
            END;
            
            /*v_list.intm_name_dummy := v_list.intm_name || '_' || v_id;	-- SR-4032 : shan 06.19.2015
            v_list.branch_cd_dummy := v_list.branch_cd || '_' || v_id;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title1 := v_title_tab (v_index).col_title;
               v_list.col_no1 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title2 := v_title_tab (v_index).col_title;
               v_list.col_no2 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title3 := v_title_tab (v_index).col_title;
               v_list.col_no3 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title4 := v_title_tab (v_index).col_title;
               v_list.col_no4 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title5 := v_title_tab (v_index).col_title;
               v_list.col_no5 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;*/		-- SR-4032 : shan 06.19.2015

            PIPE ROW (v_list);
            --EXIT WHEN v_index > v_title_tab.COUNT;	-- SR-4032 : shan 06.19.2015
         --END LOOP;	-- SR-4032 : shan 06.19.2015
      END LOOP;

      IF v_count = 0
      THEN
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_details;

   FUNCTION get_bal_amt_detail (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_user          VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_col_no        VARCHAR2,
      p_policy_no     VARCHAR2,
      p_bill_no       VARCHAR2
   )
      RETURN get_bal_amt_detail_tab PIPELINED
   IS
      v_list   get_bal_amt_detail_type;
      v_cnt    NUMBER(1) := 0;
   BEGIN
      FOR i IN
         (SELECT   /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                   a.policy_no, a.branch_cd, UPPER (a.intm_name) intm_name,
                   a.intm_no, a.intm_type,           -- jenny vi lim 01062005
                                          a.incept_date, a.ref_pol_no,
                   a.assd_no, a.assd_name,
                      a.iss_cd
                   || '-'
                   || LPAD (a.prem_seq_no, 12, 0)
                   || '-'
                   || LPAD (a.inst_no, 2, 0) bill_no,
                   
--modified bill number by adding leading zeros in prem_seq_no and inst_no by MAC 02/26/2013.
                   a.prem_bal_due, a.tax_bal_due, a.balance_amt_due,
                   a.aging_id, a.no_of_days, a.due_date, a.column_no,
                   a.column_title, a.expiry_date,
                                                 -- annabelle 12.13.05
                                                 a.iss_cd, a.prem_seq_no,
                   a.inst_no, b.iss_name
              FROM giac_soa_rep_ext a, giis_issource b
             WHERE balance_amt_due >= NVL (p_bal_amt_due, balance_amt_due)
               --kat 08162007
               AND a.intm_name IS NOT NULL       -- added by rose b. (3/25/08)
               AND a.branch_cd IS NOT NULL       -- added by rose b. (3/25/08)
               AND b.iss_name IS NOT NULL        -- added by rose b. (3/25/08)
               AND a.prem_bal_due <> 0           -- added by rose b. (3/24/08)
               AND a.branch_cd = b.iss_cd
               AND branch_cd LIKE NVL (p_branch_cd, '%')
               AND intm_no = NVL (p_intm_no, intm_no)
               AND intm_type LIKE NVL (p_intm_type, '%')
               -- jenny vi lim 01062005
               AND a.user_id = UPPER (p_user)
               AND due_tag = DECODE (p_inc_overdue, 'I', due_tag, 'N', 'Y')
               AND a.column_no = p_col_no
               AND a.policy_no = p_policy_no
               AND    a.iss_cd
                   || '-'
                   || LPAD (a.prem_seq_no, 12, 0)
                   || '-'
                   || LPAD (a.inst_no, 2, 0) = p_bill_no
          ORDER BY 2, UPPER (intm_name), 1, 4, inst_no)
      LOOP
         v_cnt := 1;
         v_list.col_title := i.column_title;
         v_list.col_no := p_col_no;
         v_list.policy_no := i.policy_no;
         v_list.balance_amt_due := i.balance_amt_due;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_cnt = 0 THEN
        v_list.balance_amt_due := 0;
        PIPE ROW (v_list);
      END IF;
   END get_bal_amt_detail;

   FUNCTION get_apdc (
      p_month         VARCHAR2,
      p_user          VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_intm_no       VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_assd_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_cut_off       VARCHAR2,
      p_no            VARCHAR2,
      p_bal_amt_due   NUMBER,
      p_policy_no     VARCHAR2,
      p_bill_no       VARCHAR2
   )
      RETURN get_apdc_tab PIPELINED
   IS
      v_list   get_apdc_type;
   BEGIN
      /*FOR i IN (SELECT   a.policy_no, a.branch_cd,	-- SR-4032 : shan 06.19.2015
                         UPPER (a.intm_name) intm_name, a.intm_no,
                         a.intm_type, a.incept_date, a.ref_pol_no, a.assd_no,
                         a.assd_name,
                            a.iss_cd
                         || '-'
                         || a.prem_seq_no
                         || '-'
                         || a.inst_no bill_no,
                         a.prem_bal_due, a.tax_bal_due, a.balance_amt_due,
                         a.aging_id, a.no_of_days, a.due_date, a.column_no,
                         a.column_title, a.expiry_date, a.iss_cd,
                         a.prem_seq_no, a.inst_no, b.iss_name, a.due_tag,
                         a.user_id
                    FROM giac_soa_rep_ext a, giis_issource b
                   WHERE balance_amt_due >=
                                         NVL (p_bal_amt_due, balance_amt_due)
                     AND a.intm_name IS NOT NULL
                     AND a.branch_cd IS NOT NULL
                     AND b.iss_name IS NOT NULL
                     AND a.balance_amt_due <> 0
                     AND a.branch_cd = b.iss_cd
                     AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND intm_type = NVL (p_intm_type, a.intm_type)
                     AND a.user_id = UPPER (p_user)
                     AND due_tag =
                                DECODE (p_inc_overdue,
                                        'I', due_tag,
                                        'N', 'Y'
                                       )
                     AND a.policy_no = NVL (p_policy_no, a.policy_no)
                     AND a.iss_cd || '-' || a.prem_seq_no || '-' || a.inst_no =
                            NVL (p_bill_no,
                                    a.iss_cd
                                 || '-'
                                 || a.prem_seq_no
                                 || '-'
                                 || a.inst_no
                                )
                ORDER BY 2, UPPER (intm_name), 1, 4, inst_no)
      LOOP
         FOR j IN (SELECT DISTINCT col_title, col_no
                              FROM giac_soa_title
                             WHERE rep_cd = 1
                          ORDER BY col_no)
         LOOP
            FOR k IN (SELECT   policy_no, branch_cd,
                               UPPER (intm_name) intm_name, intm_no,
                               intm_type, ref_pol_no, assd_name, assd_no,
                                  iss_cd
                               || '-'
                               || prem_seq_no
                               || '-'
                               || inst_no bill_no,
                               prem_bal_due, tax_bal_due, balance_amt_due,
                               aging_id, no_of_days, due_date, column_no,
                               column_title, iss_cd, prem_seq_no, inst_no
                          FROM giac_soa_rep_ext
                         WHERE balance_amt_due >=
                                         NVL (p_bal_amt_due, balance_amt_due)
                           AND intm_no IS NOT NULL
                           AND intm_name IS NOT NULL
                           AND branch_cd IS NOT NULL
                           AND balance_amt_due <> 0
                           AND branch_cd = NVL (p_branch_cd, branch_cd)
                           AND intm_no = NVL (p_intm_no, intm_no)
                           AND intm_type = NVL (p_intm_type, intm_type)
                           AND assd_no = NVL (p_assd_no, assd_no)
                           AND user_id = UPPER (p_user)
                           AND due_tag =
                                  DECODE (p_inc_overdue,
                                          'I', due_tag,
                                          'N', 'Y'
                                         )
                           AND branch_cd = i.branch_cd
                           AND policy_no = i.policy_no
                           AND iss_cd || '-' || prem_seq_no || '-' || inst_no =
                                                                     i.bill_no
                           AND column_title = j.col_title
                           AND intm_no = i.intm_no
                      ORDER BY 2, UPPER (intm_name), 1, 4, inst_no)
            LOOP*/		-- SR-4032 : shan 06.19.2015
               FOR l IN (SELECT      d.apdc_pref
                                  || '-'
                                  || d.branch_cd
                                  || '-'
                                  || d.apdc_no apdc_number,
                                  d.apdc_date, c.bank_cd, e.bank_sname,
                                  c.bank_branch, c.check_no, c.check_date,
                                  c.check_amt, b.iss_cd, b.prem_seq_no,
                                  b.inst_no,
                                     b.iss_cd
                                  || '-'
                                  || b.prem_seq_no
                                  || '-'
                                  || b.inst_no bill_no,
                                  b.collection_amt, a.intm_type, d.apdc_pref,
                                  d.branch_cd, d.apdc_no, a.intm_no
                             FROM giac_soa_rep_ext a,
                                  giac_pdc_prem_colln b,
                                  giac_apdc_payt_dtl c,
                                  giac_apdc_payt d,
                                  giac_banks e
                            WHERE b.pdc_id = c.pdc_id
                              AND c.apdc_id = d.apdc_id
                              AND c.bank_cd = e.bank_cd
                              AND d.apdc_flag = 'P'
                              AND c.check_flag NOT IN ('C', 'R')
                              AND TRUNC (d.apdc_date) <=
                                             TO_DATE (p_cut_off, 'mm-dd-yyyy')
                              AND a.iss_cd = b.iss_cd
                              AND a.prem_seq_no = b.prem_seq_no
                              AND a.inst_no = b.inst_no
                              AND a.balance_amt_due >=
                                        NVL (p_bal_amt_due, a.balance_amt_due)
                              AND a.intm_type LIKE NVL (p_intm_type, '%')
                              AND a.user_id = UPPER (p_user)
                              AND a.intm_no = NVL (p_intm_no, a.intm_no)
                              AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                              /*AND a.branch_cd = k.branch_cd	-- SR-4032 : shan 06.19.2015
                              AND a.intm_no = k.intm_no*/
                         ORDER BY d.apdc_pref, d.branch_cd, d.apdc_no)
               LOOP
                  v_list.apdc_number := l.apdc_number;
                  v_list.apdc_date := l.apdc_date;
                  v_list.bank_sname := l.bank_sname;
                  v_list.bank_branch := l.bank_branch;
                  v_list.check_no := l.check_no;
                  v_list.check_date_apdc := l.check_date;
                  v_list.check_amt := l.check_amt;
                  v_list.bill_no := l.bill_no;
                  v_list.collection_amt := l.collection_amt;
               /*END LOOP;		-- SR-4032 : shan 06.19.2015
            END LOOP;*/

            PIPE ROW (v_list);
         END LOOP;
      --END LOOP;		-- SR-4032 : shan 06.19.2015
   END get_apdc;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list   csv_col_type;
   BEGIN
      FOR i IN (SELECT   argument_name
                    FROM all_arguments
                   WHERE owner = 'CPI'
                     AND package_name = 'CSV_SOA'
                     AND object_name = 'CSV_GIACR189'
                     AND in_out = 'OUT'
                     AND argument_name IS NOT NULL
                ORDER BY POSITION)
      LOOP
         v_list.col_name := i.argument_name;

         IF (SUBSTR (i.argument_name, 0, 6) = 'COL_NO')
         THEN
            v_list.col_name :=
                          csv_soa.get_col_title (SUBSTR (i.argument_name, 7));
         END IF;

         IF v_list.col_name IS NULL
         THEN
            v_list.col_name := i.argument_name;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_csv_cols;
END giacr189_pkg;
/