CREATE OR REPLACE PACKAGE BODY CPI.GIPIR929A_MX_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 01.22.2013
    **  Reference By : GIPIR929A_MX - Inward RI Production Register - Summary
    */
   FUNCTION get_report_data (
      P_RI_CD        gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
      P_ISS_CD       gipi_uwreports_ext.iss_cd%TYPE,
      P_LINE_CD      gipi_uwreports_ext.line_cd%TYPE,
      P_SUBLINE_CD   gipi_uwreports_ext.subline_cd%TYPE,
      P_SCOPE        gipi_uwreports_ext.SCOPE%TYPE,
      P_USER_ID      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_report_data_tab PIPELINED
   IS
      v_data         get_report_data_type;
      v_param_date   NUMBER (1);
      v_iss_param    NUMBER;
   BEGIN
      FOR i IN (SELECT   a.ri_name, a.ri_cd, a.line_cd, a.line_name,
                         a.subline_cd, a.subline_name, a.cred_branch iss_cd,
                         SUM (a.total_tsi) total_tsi,
                         SUM (a.total_prem) total_prem, a.param_date,
                         a.from_date, a.TO_DATE, a.SCOPE, a.user_id,
                           SUM (a.total_prem)
                         + SUM (NVL (a.tax1, 0))
                         + SUM (NVL (a.tax2, 0))
                         + SUM (NVL (a.tax3, 0))
                         + SUM (NVL (a.tax4, 0))
                         + SUM (NVL (a.tax5, 0))
                         + SUM (NVL (a.tax6, 0))
                         + SUM (NVL (a.tax7, 0))
                         + SUM (NVL (a.tax8, 0))
                         + SUM (NVL (a.tax9, 0))
                         + SUM (NVL (a.tax10, 0))
                         + SUM (NVL (a.tax11, 0))
                         + SUM (NVL (a.tax12, 0))
                         + SUM (NVL (a.tax13, 0))
                         + SUM (NVL (a.tax14, 0))
                         + SUM (NVL (a.tax15, 0))
                         + SUM (a.other_charges) total,
                         COUNT (a.policy_id) polcount,
                         SUM (b.commission) commission,
                         SUM (c.ri_comm_vat) ri_comm_vat
                    FROM gipi_uwreports_inw_ri_ext a,
                         (SELECT   x.policy_id, x.line_cd, x.subline_cd,
                                   SUM (y.ri_comm_amt) commission
                              FROM gipi_uwreports_inw_ri_ext x,
                                   gipi_itmperil y
                             WHERE x.policy_id = y.policy_id
                               AND x.user_id = p_user_id
                          GROUP BY x.line_cd, x.subline_cd, x.policy_id) b,
                         gipi_invoice c
                   WHERE a.policy_id = b.policy_id(+)
                     AND a.policy_id = c.policy_id
                     AND a.user_id = p_user_id
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND NVL (a.cred_branch, 'x') =
                                      NVL (p_iss_cd, NVL (a.cred_branch, 'x'))
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                         )
                GROUP BY a.cred_branch,
                         a.ri_name,
                         a.line_cd,
                         a.line_name,
                         a.subline_cd,
                         a.subline_name,
                         param_date,
                         a.from_date,
                         a.TO_DATE,
                         SCOPE,
                         a.user_id,
                         a.ri_cd
                ORDER BY a.ri_name)
      LOOP
         v_data.ri_cd           := i.ri_cd;
         v_data.ri_name         := i.ri_name;
         v_data.line_cd         := i.line_cd;
         v_data.line_name       := i.line_name;
         v_data.subline_cd      := i.subline_cd;
         v_data.subline_name    := i.subline_name;
         v_data.iss_cd          := i.iss_cd;
         v_data.total_tsi       := i.total_tsi;
         v_data.total_prem      := i.total_prem;
         v_data.param_date      := i.param_date;
         v_data.from_date       := i.from_date;
         v_data.TO_DATE         := i.TO_DATE;
         v_data.SCOPE           := i.SCOPE;
         v_data.user_id         := i.user_id;
         v_data.total           := i.total;
         v_data.polcount        := i.polcount;
         v_data.commission      := i.commission;
         v_data.ri_comm_vat     := i.ri_comm_vat;

         --for cf_based_on
         BEGIN
            SELECT param_date
              INTO v_param_date
              FROM gipi_uwreports_inw_ri_ext
             WHERE user_id = p_user_id AND ROWNUM = 1;

            IF v_param_date = 1
            THEN
               v_data.cf_based_on := 'Based on Issue Date';
            ELSIF v_param_date = 2
            THEN
               v_data.cf_based_on := 'Based on Inception Date';
            ELSIF v_param_date = 3
            THEN
               v_data.cf_based_on := 'Based on Booking month - year';
            ELSIF v_param_date = 4
            THEN
               v_data.cf_based_on := 'Based on Acctg Entry Date';
            END IF;

            IF p_scope = 1
            THEN
               v_data.policy_label :=
                               v_data.cf_based_on || ' / ' || 'Policies Only';
            ELSIF p_scope = 2
            THEN
               v_data.policy_label :=
                           v_data.cf_based_on || ' / ' || 'Endorsements Only';
            ELSIF p_scope = 3
            THEN
               v_data.policy_label :=
                   v_data.cf_based_on || ' / ' || 'Policies and Endorsements';
            END IF;
         END;

         --for cf_company_name
         BEGIN
            SELECT param_value_v
              INTO v_data.cf_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';
         END;

         --for cf_company_address
         BEGIN
            SELECT param_value_v
              INTO v_data.cf_company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --for cf_heading3
         BEGIN
            SELECT DISTINCT param_date, from_date, TO_DATE
                       INTO v_param_date, v_data.from_dt, v_data.to_dt
                       FROM gipi_uwreports_inw_ri_ext
                      WHERE user_id = p_user_id;

            IF v_param_date IN (1, 2, 4)
            THEN
               IF v_data.from_dt = v_data.to_dt
               THEN
                  v_data.cf_heading3 :=
                       'For ' || TO_CHAR (v_data.from_dt, 'fmMonth dd, yyyy');
               ELSE
                  v_data.cf_heading3 :=
                        'For the period of '
                     || TO_CHAR (v_data.from_dt, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_data.to_dt, 'fmMonth dd, yyyy');
               END IF;
            ELSE
               IF v_data.from_dt = v_data.to_dt
               THEN
                  v_data.cf_heading3 :=
                        'For the month of '
                     || TO_CHAR (v_data.from_dt, 'fmMonth, yyyy');
               ELSE
                  v_data.cf_heading3 :=
                        'For the period of '
                     || TO_CHAR (v_data.from_dt, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_data.to_dt, 'fmMonth dd, yyyy');
               END IF;
            END IF;
         END;

         --for cf_iss_name
         BEGIN
            BEGIN
               SELECT iss_name
                 INTO v_data.cf_iss_name
                 FROM giis_issource
                WHERE iss_cd = v_data.iss_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
               THEN
                  v_data.cf_iss_name := NULL;
            END;

            IF v_data.iss_cd IS NULL
            THEN
               v_data.cf_iss_name := NULL;
            ELSE
               v_data.cf_iss_name :=
                                 v_data.iss_cd || ' - ' || v_data.cf_iss_name;
            END IF;
         END;

         --for cf_iss_header
         BEGIN
            IF v_iss_param = 1
            THEN
               v_data.cf_iss_header := 'Crediting Branch :';
            ELSIF v_iss_param = 2
            THEN
               v_data.cf_iss_header := 'Issue Source     :';
            ELSE
               v_data.cf_iss_header := NULL;
            END IF;
         END;

         PIPE ROW (v_data);
      END LOOP;

      RETURN;
   END get_report_data;

   --function for retrieving tax amounts
   FUNCTION get_taxes (
      P_RI_CD        gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
      P_ISS_CD       gipi_uwreports_ext.iss_cd%TYPE,
      P_ISS_PARAM    NUMBER,
      P_LINE_CD      gipi_uwreports_ext.line_cd%TYPE,
      P_SUBLINE_CD   gipi_uwreports_ext.subline_cd%TYPE,
      P_SCOPE        gipi_uwreports_ext.SCOPE%TYPE,
      P_USER_ID      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_taxes_tab PIPELINED
   IS
      v_taxes   get_taxes_type;
      v_count  NUMBER;
   BEGIN
    v_count := 0;
      FOR i IN (SELECT DISTINCT a.tax_cd, INITCAP (a.tax_desc) tax_name, ROW_NUMBER()  OVER ( ORDER BY a.tax_cd) AS tax_count
                           FROM giis_tax_charges a
                          WHERE EXISTS (SELECT 1
                                          FROM gipi_inv_tax
                                         WHERE tax_cd = a.tax_cd)
                                      GROUP BY a.tax_cd, a.tax_desc   
                       ORDER BY tax_cd)
       
       
      LOOP
         FOR j IN (SELECT ri_cd, line_cd, subline_cd, iss_cd, tax_amt, ROW_NUMBER()  OVER ( ORDER BY ri_cd) AS ri_count,
                          line_name, subline_name, ri_name,  total,
                          commission, ri_comm_vat, polcount, total_tsi, total_prem 
                          , tax_cd
                          , ROW_NUMBER()  OVER ( ORDER BY i.tax_cd) AS count_row
                     FROM (SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax1
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    1 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax2
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    2 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax3
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    3 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax4
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    4 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax5
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    5 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax6
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    6 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax7
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    7 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax8
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    8 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax9
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    9 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax10
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    10 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax11
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    11 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax12
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    12 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax13
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    13 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax14
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    14 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name
                           UNION
                           SELECT   a.ri_cd, a.line_cd, a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax15
                                                     ),
                                              0
                                             )
                                        ) tax_amt,
                                    15 AS tax_cd, a.line_name, a.subline_name,
                                    a.ri_name,
                                      SUM (a.total_prem)
                                    + SUM (NVL (a.tax1, 0))
                                    + SUM (NVL (a.tax2, 0))
                                    + SUM (NVL (a.tax3, 0))
                                    + SUM (NVL (a.tax4, 0))
                                    + SUM (NVL (a.tax5, 0))
                                    + SUM (NVL (a.tax6, 0))
                                    + SUM (NVL (a.tax7, 0))
                                    + SUM (NVL (a.tax8, 0))
                                    + SUM (NVL (a.tax9, 0))
                                    + SUM (NVL (a.tax10, 0))
                                    + SUM (NVL (a.tax11, 0))
                                    + SUM (NVL (a.tax12, 0))
                                    + SUM (NVL (a.tax13, 0))
                                    + SUM (NVL (a.tax14, 0))
                                    + SUM (NVL (a.tax15, 0))
                                    + SUM (a.other_charges) total,
                                    SUM (c.commission) commission,
                                    SUM (d.ri_comm_vat) ri_comm_vat,
                                    COUNT (a.policy_id) polcount,
                                    SUM (a.total_tsi) total_tsi,
                                    SUM (a.total_prem) total_prem
                               FROM gipi_uwreports_inw_ri_ext a,
                                    gipi_polbasic b,
                                    (SELECT   x.policy_id, x.line_cd,
                                              x.subline_cd,
                                              SUM (y.ri_comm_amt) commission
                                         FROM gipi_uwreports_inw_ri_ext x,
                                              gipi_itmperil y
                                        WHERE x.policy_id = y.policy_id
                                          AND x.user_id = p_user_id
                                     GROUP BY x.line_cd,
                                              x.subline_cd,
                                              x.policy_id) c,
                                    gipi_invoice d
                              WHERE a.policy_id = b.policy_id
                                AND a.policy_id = c.policy_id(+)
                                AND a.policy_id = d.policy_id
                                AND a.user_id = p_user_id
                                AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                                AND NVL (a.cred_branch, 'x') =
                                       NVL (p_iss_cd,
                                            NVL (a.cred_branch, 'x'))
                                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                                AND (   (    p_scope = 3
                                         AND a.endt_seq_no = a.endt_seq_no
                                        )
                                     OR (p_scope = 1 AND a.endt_seq_no = 0)
                                     OR (p_scope = 2 AND a.endt_seq_no > 0)
                                    )
                           GROUP BY a.ri_cd,
                                    a.line_cd,
                                    a.subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ),
                                    a.line_name,
                                    a.subline_name,
                                    a.ri_name)x
                    WHERE x.tax_cd = i.tax_cd
                    )
                    
        
         LOOP
        
            v_taxes.ri_cd           := j.ri_cd;
            v_taxes.subline_cd      := j.subline_cd;
            v_taxes.line_cd         := j.line_cd;
            v_taxes.iss_cd          := j.iss_cd;
            v_taxes.tax_amt         := j.tax_amt;
            v_taxes.tax_cd          := i.tax_cd;
            v_taxes.tax_name        := i.tax_name;
            v_taxes.line_name       := j.line_name;
            v_taxes.subline_name    := j.subline_name;
            v_taxes.ri_name         := j.ri_name;
            v_taxes.v_reference     := 1;
            v_taxes.v_tax_count     := i.tax_count;
            v_taxes.v_ri_count      := j.ri_count;
               
            
            if v_count < j.count_row
            then
                v_taxes.V_COUNT     := j.count_ROW;
                v_count             := v_taxes.V_COUNT;
                v_taxes.total       := j.total;
                v_taxes.commission  := j.commission;
                v_taxes.ri_comm_vat := j.ri_comm_vat;
                v_taxes.total_tsi   := j.total_tsi;
                v_taxes.total_prem  := j.total_prem;
                v_taxes.polcount    := j.polcount;
            else
                v_taxes.V_COUNT     := 0;
                v_taxes.total       := 0;
                v_taxes.commission  := 0;
                v_taxes.ri_comm_vat := 0;
                v_taxes.total_tsi   := 0;
                v_taxes.total_prem  := 0;
                v_taxes.polcount    := 0;
             end if;
             
            PIPE ROW (v_taxes);
            
            
         END LOOP;
            
         --populates total, commission and ri_comm_vat with 0 ,if tax_cd is greater than 15 (because table gipi_uwreports_inw_ri_ext only have 15 taxes)
         IF i.tax_cd > 15
         THEN
            v_taxes.tax_cd          := i.tax_cd;
            v_taxes.tax_name        := i.tax_name;
            v_taxes.total           := 0;
            v_taxes.commission      := 0;
            v_taxes.ri_comm_vat     := 0;
            v_taxes.polcount        := 0;
            v_taxes.total_tsi       := 0;
            v_taxes.total_prem      := 0;
            v_taxes.v_tax_count     := i.tax_count;
            PIPE ROW (v_taxes);
         END IF;
      END LOOP;

      RETURN;
   END get_taxes;

   --function for report header (tax_names)
   FUNCTION get_header
      RETURN get_header_tab PIPELINED
   IS
      v_header   get_header_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.tax_cd, INITCAP (a.tax_desc) tax_name
                           FROM giis_tax_charges a
                          WHERE EXISTS (SELECT 1
                                          FROM gipi_inv_tax
                                         WHERE tax_cd = a.tax_cd)
                       ORDER BY 1)
      LOOP
         v_header.tax_cd := i.tax_cd;
         v_header.tax_name := i.tax_name;
         PIPE ROW (v_header);
      END LOOP;

      RETURN;
   END get_header;
END GIPIR929A_MX_PKG;
/


