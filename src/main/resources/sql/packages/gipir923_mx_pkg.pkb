CREATE OR REPLACE PACKAGE BODY CPI.gipir923_mx_pkg
AS
   /*
    **  Created by   :  Steven Ramirez
    **  Date Created : 01.18.2013
    **  Reference By : GIPIR923_MX - Production Report(Detailed)
    */
   FUNCTION populate_gipir923_mx (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE,
      p_from         number,
      p_to           number
      
   )
      RETURN report_tab PIPELINED
   AS
      rep              report_type;
      v_param_date     NUMBER (1);
      v_from_date      DATE;
      v_to_date        DATE;
      v_heading3       VARCHAR2 (150);
      v_company_name   VARCHAR2 (150);
      v_based_on       VARCHAR2 (100);
      v_policy_label   VARCHAR2 (200);
      v_address        VARCHAR2 (500);
      v_iss_name       giis_issource.iss_name%TYPE;
      v_policy_no      VARCHAR2 (100);
      v_endt_no        VARCHAR2 (30);
      v_ref_pol_no     VARCHAR2 (35)                 := NULL;
	  v_cnt_tax        NUMBER (20);
      v_mod_tax        NUMBER (20);
      v_did_tax        NUMBER (20);
   BEGIN
      FOR i IN
         (SELECT   DECODE (spld_date,
                           NULL, DECODE (a.dist_flag, 3, 'D', 'U'),
                           'S'
                          ) "DIST_FLAG",
                   a.line_cd, a.subline_cd,
                   DECODE (p_iss_param,
                           1, a.cred_branch,
                           a.iss_cd
                          ) iss_cd_head,
                   a.iss_cd iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                   a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.issue_date,
                   a.incept_date, a.expiry_date,
                   DECODE (spld_date, NULL, a.total_tsi, 0) total_tsi,
                   DECODE (spld_date, NULL, a.total_prem, 0) total_prem,
                   DECODE (spld_date, NULL, a.other_taxes, 0) other_taxes,
                   DECODE (spld_date,
                           NULL, (  a.total_prem
                                  + NVL (a.tax1, 0)
                                  + NVL (a.tax2, 0)
                                  + NVL (a.tax3, 0)
                                  + NVL (a.tax4, 0)
                                  + NVL (a.tax5, 0)
                                  + NVL (a.tax6, 0)
                                  + NVL (a.tax7, 0)
                                  + NVL (a.tax8, 0)
                                  + NVL (a.tax9, 0)
                                  + NVL (a.tax10, 0)
                                  + NVL (a.tax11, 0)
                                  + NVL (a.tax12, 0)
                                  + NVL (a.tax13, 0)
                                  + NVL (a.tax14, 0)
                                  + NVL (a.tax15, 0)
                            ),
                           0
                          ) "TOTAL_CHARGES",
                   DECODE (spld_date,
                           NULL, (  NVL (a.tax1, 0)
                                  + NVL (a.tax2, 0)
                                  + NVL (a.tax3, 0)
                                  + NVL (a.tax4, 0)
                                  + NVL (a.tax5, 0)
                                  + NVL (a.tax6, 0)
                                  + NVL (a.tax7, 0)
                                  + NVL (a.tax8, 0)
                                  + NVL (a.tax9, 0)
                                  + NVL (a.tax10, 0)
                                  + NVL (a.tax11, 0)
                                  + NVL (a.tax12, 0)
                                  + NVL (a.tax13, 0)
                                  + NVL (a.tax14, 0)
                                  + NVL (a.tax15, 0)
                            ),
                           0
                          ) total_taxes,
                   a.param_date, a.from_date, a.TO_DATE, SCOPE, a.user_id,
                   a.policy_id, a.assd_no,
                   DECODE (spld_date,
                           NULL, NULL,
                              ' S P O I L E D / '
                           || TO_CHAR (spld_date, 'DD-MM-RRRR')
                          ) spld_date,
                   DECODE (spld_date, NULL, 1, 0) pol_count,
                   DECODE (spld_date, NULL, NVL (a.comm_amt, 0), 0) comm_amt,
                   DECODE (spld_date,
                           NULL, NVL (b.wholding_tax, 0),
                           0
                          ) wholding_tax,
                   DECODE (spld_date, NULL, NVL (b.net_comm, 0), 0) net_comm
                                                                            --,A.policy_id
                   ,
                   b.ref_inv_no
              FROM (SELECT   SUM
                                (DECODE (c.ri_comm_amt * c.currency_rt,
                                         0, NVL (  b.commission_amt
                                                 * c.currency_rt,
                                                 0
                                                ),
                                         c.ri_comm_amt * c.currency_rt
                                        )
                                ) commission_amt,
                             SUM (NVL (b.wholding_tax, 0)) wholding_tax,
                             SUM (  NVL (b.commission_amt, 0)
                                  - NVL (b.wholding_tax, 0)
                                 ) net_comm,
                             c.policy_id policy_id, c.ref_inv_no ref_inv_no
                        FROM gipi_comm_invoice b, gipi_invoice c
                       WHERE b.iss_cd = c.iss_cd  --b.policy_id=c.policy_id(+)
                         AND b.prem_seq_no = c.prem_seq_no
                    GROUP BY c.policy_id, c.ref_inv_no) b,
                   gipi_uwreports_ext a
             WHERE a.policy_id = b.policy_id(+)
               AND a.user_id = p_user_id
               AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                      NVL (p_iss_cd,
                           DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                          )
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                    OR (p_scope = 1 AND endt_seq_no = 0 AND pol_flag <> '5')
                    OR (p_scope = 2 AND endt_seq_no > 0 AND pol_flag <> '5')
                   --OR (p_scope=3 AND pol_flag='4')
                   )
          ORDER BY a.iss_cd,
                   a.line_cd,
                   a.subline_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.endt_iss_cd,
                   a.endt_yy,
                   a.endt_seq_no)
      LOOP
         rep.dis_flag := i.dist_flag;
         rep.line_cd := i.line_cd;
         rep.subline_cd := i.subline_cd;
         rep.iss_cd_head := i.iss_cd_head;
         rep.iss_cd := i.iss_cd;
         rep.issue_yy := i.issue_yy;
         rep.pol_seq_no := i.pol_seq_no;
         rep.renew_no := i.renew_no;
         rep.endt_iss_cd := i.endt_iss_cd;
         rep.endt_yy := i.endt_yy;
         rep.endt_seq_no := i.endt_seq_no;
         rep.issue_date := i.issue_date;
         rep.incept_date := i.incept_date;
         rep.expiry_date := i.expiry_date;
         rep.policy_id := i.policy_id;
         rep.total_tsi := i.total_tsi;
         rep.total_prem := i.total_prem;
         rep.total_taxes := i.total_taxes;
         rep.other_taxes := i.other_taxes;
         rep.total_charges := i.total_charges;
         rep.spld_date := i.spld_date;
         rep.pol_count := i.pol_count;
         rep.comm_amt := i.comm_amt;
         rep.wholding_tax := i.wholding_tax;
         rep.net_comm := i.net_comm;
         --for the print_special_risk_param
         rep.print_special_risk_param := NULL;
         
         /*IF p_to IS NULL THEN
            rep.p_to := 5;
         ELSE
            rep.p_to := p_to+5;
         END IF;
         
         IF p_from IS NULL THEN
            rep.p_from := 1;
         ELSE
            rep.p_from := p_from+5;
         END IF;*/
		 BEGIN
             SELECT count(*) count_
             INTO v_cnt_tax
                FROM TABLE(GIPIR923_MX_PKG.populate_tax(p_subline_cd, p_line_cd,p_iss_cd, p_iss_param, p_scope, '',  p_user_id));
              EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_cnt_tax := 0;
         END;
         
         IF p_to IS NULL THEN
            v_mod_tax := mod(v_cnt_tax,5);
            v_did_tax := v_cnt_tax/5;
            if v_mod_tax = 0 then
                rep.p_to := v_cnt_tax;
            else
                rep.p_to := (v_did_tax*5)+5;
            end if;
            rep.p_from :=  rep.p_to-4;
         ELSE
            rep.p_to := p_to-5;
            rep.p_from := p_from-5;
         END IF;
         
--         IF p_from IS NULL THEN
--            rep.p_from := v_cnt_tax-4;
--         ELSE
--            rep.p_from := p_from-5;
--         END IF;
        
         FOR a IN (SELECT text
                     FROM giis_document
                    WHERE report_id = 'GIPIR923'
                      AND title = 'PRINT_SPECIAL_RISK')
         LOOP
            rep.print_special_risk_param := a.text;
         END LOOP;

         --for the show_total_taxes_param
         BEGIN
            SELECT param_value_v
              INTO rep.show_total_taxes_param
              FROM giac_parameters
             WHERE param_name = 'SHOW_TOTAL_TAXES';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.show_total_taxes_param := 'N';
         END;

         --for the print_ref_inv_param
         BEGIN
            SELECT param_value_v
              INTO rep.print_ref_inv_param
              FROM giis_parameters
             WHERE param_name = 'PRINT_REF_INV';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.print_ref_inv_param := NULL;
         END;

         --for the cf_assd_name
         BEGIN
            SELECT assd_name
              INTO rep.cf_assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.cf_assd_name := NULL;
         END;

         --for the cf_policy_no
         v_policy_no :=
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || LTRIM (i.iss_cd)
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '09'));

         IF i.endt_seq_no <> 0
         THEN
            v_endt_no :=
                  i.endt_iss_cd
               || '-'
               || LTRIM (TO_CHAR (i.endt_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (i.endt_seq_no));
         END IF;

         BEGIN
            SELECT ref_pol_no
              INTO v_ref_pol_no
              FROM gipi_polbasic
             WHERE policy_id = i.policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ref_pol_no := NULL;
         END;

         IF v_ref_pol_no IS NOT NULL
         THEN
            v_ref_pol_no := '/' || v_ref_pol_no;
         END IF;

         rep.cf_policy_no := v_policy_no || ' ' || v_endt_no || v_ref_pol_no;

         --for the cf_iss_name
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_iss_name := '';
         END;

         rep.cf_iss_name := i.iss_cd || ' - ' || v_iss_name;

         --for the cf_iss_title
         IF p_iss_param = 2
         THEN
            rep.cf_iss_title := 'Issue Source     :';
         ELSE
            rep.cf_iss_title := 'Crediting Branch :';
         END IF;

         --for the cf_line_name
         FOR line IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = i.line_cd)
         LOOP
            rep.cf_line_name := line.line_name;
         END LOOP;

         --for the cf_subline_name
         FOR subline IN (SELECT subline_name
                           FROM giis_subline
                          WHERE line_cd = i.line_cd
                            AND subline_cd = i.subline_cd)
         LOOP
            rep.cf_subline_name := subline.subline_name;
         END LOOP;

         --for the cf_company
         BEGIN
            SELECT param_value_v
              INTO v_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_company_name := NULL;
         END;

         rep.cf_company := v_company_name;

         --for the cf_company_address
         BEGIN
            SELECT param_value_v
              INTO v_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_address := NULL;
         END;

         rep.cf_company_address := v_address;

         --for the cf_based_on
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
            v_based_on := 'Based on Booking month - year';
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
            v_policy_label :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
         END IF;

         rep.cf_based_on := v_policy_label;

         --for the cf_heading3
         SELECT DISTINCT param_date, from_date, TO_DATE
                    INTO v_param_date, v_from_date, v_to_date
                    FROM gipi_uwreports_ext
                   WHERE user_id = p_user_id;

         IF v_param_date IN (1, 2, 4)
         THEN
            IF v_from_date = v_to_date
            THEN
               v_heading3 :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
            ELSE
               v_heading3 :=
                     'For the period of '
                  || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                  || ' to '
                  || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
            END IF;
         ELSE
            IF v_from_date = v_to_date
            THEN
               v_heading3 :=
                     'For the month of '
                  || TO_CHAR (v_from_date, 'fmMonth, yyyy');
            ELSE
               v_heading3 :=
                     'For the period of '
                  || TO_CHAR (v_from_date, 'fmMonth, yyyy')
                  || ' to '
                  || TO_CHAR (v_to_date, 'fmMonth, yyyy');
            END IF;
         END IF;

         rep.cf_heading3 := v_heading3;
         PIPE ROW (rep);
      END LOOP;
   END populate_gipir923_mx;

   FUNCTION populate_tax (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_policy_id    gipi_uwreports_ext.policy_id%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN tax_tab PIPELINED
   AS
      rep        tax_type;
      v_exist    VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT DISTINCT a.tax_cd, a.tax_desc tax_name
                           FROM giis_tax_charges a
                          WHERE EXISTS (SELECT 1
                                          FROM gipi_inv_tax
                                         WHERE tax_cd = a.tax_cd))
      LOOP
         v_exist := 'N';

         FOR j IN (SELECT policy_id, line_cd, subline_cd, iss_cd, tax_amt
                     FROM (SELECT   policy_id, line_cd, subline_cd,
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
                                    1 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax2
                                                     ),
                                              0
                                             )
                                        ) tax2,
                                    2 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax3
                                                     ),
                                              0
                                             )
                                        ) tax3,
                                    3 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax4
                                                     ),
                                              0
                                             )
                                        ) tax4,
                                    4 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax5
                                                     ),
                                              0
                                             )
                                        ) tax5,
                                    5 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax6
                                                     ),
                                              0
                                             )
                                        ) tax6,
                                    6 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax7
                                                     ),
                                              0
                                             )
                                        ) tax7,
                                    7 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax8
                                                     ),
                                              0
                                             )
                                        ) tax8,
                                    8 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax9
                                                     ),
                                              0
                                             )
                                        ) tax9,
                                    9 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax10
                                                     ),
                                              0
                                             )
                                        ) tax10,
                                    10 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax11
                                                     ),
                                              0
                                             )
                                        ) tax11,
                                    11 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax12
                                                     ),
                                              0
                                             )
                                        ) tax12,
                                    12 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax13
                                                     ),
                                              0
                                             )
                                        ) tax13,
                                    13 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax14
                                                     ),
                                              0
                                             )
                                        ) tax14,
                                    14 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )
                           UNION
                           SELECT   policy_id, line_cd, subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) iss_cd,
                                    SUM (NVL (DECODE (spld_date,
                                                      NULL, a.tax15
                                                     ),
                                              0
                                             )
                                        ) tax15,
                                    15 AS tax_cd
                               FROM gipi_uwreports_ext a
                              WHERE a.user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           ) =
                                       NVL (p_iss_cd,
                                            DECODE (p_iss_param,
                                                    1, a.cred_branch,
                                                    a.iss_cd
                                                   )
                                           )
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd =
                                                NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 5
                                         AND endt_seq_no = endt_seq_no
                                        )
                                     OR (    p_scope = 1
                                         AND endt_seq_no = 0
                                         AND pol_flag <> '5'
                                        )
                                     OR (    p_scope = 2
                                         AND endt_seq_no > 0
                                         AND pol_flag <> '5'
                                        )
                                    --OR  (p_scope=4 AND POL_FLAG = '5')
                                    )
                           GROUP BY policy_id,
                                    line_cd,
                                    subline_cd,
                                    DECODE (p_iss_param,
                                            1, a.cred_branch,
                                            a.iss_cd
                                           )) x
                    WHERE x.tax_cd = i.tax_cd AND x.policy_id = p_policy_id)
         LOOP
            v_exist := 'Y';
            rep.policy_id := j.policy_id;
            rep.tax_cd := i.tax_cd;
            rep.tax_name := i.tax_name;
            rep.line_cd := j.line_cd;
            rep.subline_cd := j.subline_cd;
            rep.iss_cd := j.iss_cd;
            rep.tax_amt := j.tax_amt;
         END LOOP;

         IF v_exist = 'N'
         THEN
            rep.policy_id := p_policy_id;
            rep.tax_cd := i.tax_cd;
            rep.tax_name := i.tax_name;
            rep.line_cd := NULL;
            rep.subline_cd := NULL;
            rep.iss_cd := NULL;
            rep.tax_amt := NULL;
         END IF;

         PIPE ROW (rep);
      END LOOP;
   END populate_tax;

   FUNCTION populate_special_risk (
      p_line_cd     gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param   VARCHAR2,
      p_scope       gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id     gipi_uwreports_ext.user_id%TYPE
   )
      RETURN special_risk_tab PIPELINED
   AS
      rep   special_risk_type;
   BEGIN
      FOR a IN (SELECT   SUM (b.premium_amt) prem_amt,
                         SUM (b.commission_amt * c.currency_rt)
                                                              commission_amt,
                         NVL (e.special_risk_tag, 'N') special_risk_tag
                    FROM gipi_comm_inv_peril b,
                         gipi_invoice c,
                         (SELECT y.line_cd, y.peril_cd, y.special_risk_tag
                            FROM giis_peril y
                           WHERE y.line_cd IN (SELECT z.line_cd
                                                 FROM giis_peril z
                                                WHERE z.special_risk_tag = 'Y')) e,
                         gipi_uwreports_ext a
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = c.policy_id
                     AND b.peril_cd = e.peril_cd
                     AND e.line_cd = a.line_cd
                     AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                                                                      p_iss_cd
                     AND a.line_cd = p_line_cd
                     --AND a.line_cd   = giisp.v('LINE_CODE_FI')
                     AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                          OR (p_scope = 3 AND pol_flag = '4')
                          OR (p_scope = 4 AND pol_flag = '5')
                         )
                     AND spld_date IS NULL
                GROUP BY e.special_risk_tag)
      LOOP
         IF a.special_risk_tag = 'Y'
         THEN
            rep.cp_sr_prem := a.prem_amt;
            rep.cp_sr_comm := a.commission_amt;
         ELSE
            rep.cp_fr_prem := a.prem_amt;
            rep.cp_fr_comm := a.commission_amt;
         END IF;
      END LOOP;

      FOR a IN (SELECT   SUM (b.prem_amt) prem_amt,
                         SUM (b.ri_comm_amt * c.currency_rt) commission_amt,
                         NVL (e.special_risk_tag, 'N') special_risk_tag
                    FROM gipi_invperil b,
                         gipi_invoice c,
                         (SELECT y.line_cd, y.peril_cd, y.special_risk_tag
                            FROM giis_peril y
                           WHERE y.line_cd IN (SELECT z.line_cd
                                                 FROM giis_peril z
                                                WHERE z.special_risk_tag = 'Y')) e,
                         gipi_uwreports_ext a
                   WHERE 1 = 1
                     AND a.policy_id = c.policy_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND c.prem_seq_no = b.prem_seq_no
                     AND b.peril_cd = e.peril_cd
                     AND e.line_cd = a.line_cd
                     AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                                                                      p_iss_cd
                     --NVL( :p_iss_cd, a.iss_cd)
                     AND a.line_cd = p_line_cd
---------------------------------------------------------
-- commented by kim and replaced with the condition below
--     AND a.iss_cd    = giisp.v('ISS_CD_RI')
                     AND a.iss_cd = (SELECT param_value_v
                                       FROM giis_parameters
                                      WHERE param_name = 'ISS_CD_RI')
----------------------------------------------------------
                     AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                          OR (p_scope = 3 AND pol_flag = '4')
                          OR (p_scope = 4 AND pol_flag = '5')
                         )
                     AND spld_date IS NULL
                GROUP BY e.special_risk_tag)
      LOOP
         IF a.special_risk_tag = 'Y'
         THEN
            rep.cp_sr_prem := rep.cp_sr_prem + a.prem_amt;
            rep.cp_sr_comm := rep.cp_sr_comm + a.commission_amt;
         ELSE
            rep.cp_fr_prem := rep.cp_fr_prem + a.prem_amt;
            rep.cp_fr_comm := rep.cp_fr_comm + a.commission_amt;
         END IF;
      END LOOP;

      FOR a IN (SELECT   SUM (d.tsi_amt) tsi_amt,
                         NVL (e.special_risk_tag, 'N') special_risk_tag
                    FROM gipi_itmperil d,
                         (SELECT y.line_cd, y.peril_cd, y.special_risk_tag,
                                 y.peril_type
                            FROM giis_peril y
                           WHERE y.line_cd IN (SELECT z.line_cd
                                                 FROM giis_peril z
                                                WHERE z.special_risk_tag = 'Y')) e,
                         gipi_uwreports_ext a
                   WHERE d.policy_id = a.policy_id
                     AND d.item_no >= 0
                     AND NVL (d.line_cd, '') = a.line_cd
                     AND d.peril_cd = e.peril_cd
                     AND e.line_cd = a.line_cd
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                                                                      p_iss_cd
                     AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND a.line_cd = p_line_cd
                     AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                          OR (p_scope = 3 AND pol_flag = '4')
                          OR (p_scope = 4 AND pol_flag = '5')
                         )
                     AND spld_date IS NULL
                GROUP BY e.special_risk_tag)
      LOOP
         IF a.special_risk_tag = 'Y'
         THEN
            rep.cp_sr_tsi := a.tsi_amt;
         ELSE
            rep.cp_fr_tsi := a.tsi_amt;
         END IF;
      END LOOP;

      PIPE ROW (rep);
   END populate_special_risk;

   FUNCTION populate_summary (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN summary_tab PIPELINED
   AS
      rep   summary_type;
   BEGIN
      --for cf_cnt_spoiled and cf_prem_spoiled
      BEGIN
         SELECT NVL (SUM (DECODE (spld_date, NULL, 1, 0)), 0),
                NVL (SUM (DECODE (spld_date, NULL, total_prem, 0)), 0)
           INTO rep.cf_cnt_spoiled,
                rep.cf_prem_spoiled
           FROM gipi_uwreports_ext a
          WHERE a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND line_cd = NVL (p_line_cd, line_cd)
            AND subline_cd = NVL (p_subline_cd, subline_cd)
            AND p_scope = 5
            AND pol_flag = '5';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_cnt_spoiled := 0;
            rep.cf_prem_spoiled := 0;
      END;

      --for cf_comm_amt_spoiled
      rep.cf_comm_amt_spoiled := 0;

      --for cf_cnt_undist
      BEGIN
         SELECT NVL (SUM (DECODE (spld_date, NULL, 1, 0)), 0)
                                                            --count(dist_flag)
           INTO rep.cf_cnt_undist
           FROM gipi_uwreports_ext a
          WHERE NVL (dist_flag, 1) <> 3
            AND a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND line_cd = NVL (p_line_cd, line_cd)
            AND subline_cd = NVL (p_subline_cd, subline_cd)
            AND (   (    p_scope = 5
                     AND endt_seq_no = endt_seq_no
                     AND pol_flag < '5'
                    )
                 OR (p_scope = 1 AND endt_seq_no = 0 AND pol_flag <> '5')
                 OR (p_scope = 2 AND endt_seq_no > 0 AND pol_flag <> '5')
                 OR (p_scope = 3 AND pol_flag = '4')
                 OR (p_scope = 4 AND pol_flag = '5')
                );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_cnt_undist := 0;
      END;

      --for cf_prem_undist
      BEGIN
         SELECT NVL (SUM (DECODE (gue.spld_date, NULL, gue.total_prem, 0)), 0)
           INTO rep.cf_prem_undist
           FROM gipi_uwreports_ext gue
          WHERE NVL (gue.dist_flag, 1) <> 3
            AND gue.user_id = p_user_id
            AND DECODE (p_iss_param, 1, gue.cred_branch, gue.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, gue.cred_branch, gue.iss_cd)
                       )
            AND gue.line_cd = NVL (p_line_cd, line_cd)
            AND gue.subline_cd = NVL (p_subline_cd, subline_cd)
            AND (   (    p_scope = 5
                     AND gue.endt_seq_no = gue.endt_seq_no
                     AND gue.pol_flag <> '5'
                    )
                 OR (p_scope = 1 AND gue.endt_seq_no = 0 AND pol_flag <> '5'
                    )
                 OR (p_scope = 2 AND gue.endt_seq_no > 0 AND pol_flag <> '5'
                    )
                 OR (p_scope = 3 AND gue.pol_flag = '4')
                 OR (p_scope = 4 AND gue.pol_flag = '5')
                );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_prem_undist := 0;
      END;

      --for cf_comm_amt_undist
      BEGIN
         SELECT NVL (SUM (DECODE (spld_date, NULL, b.commission_amt, 0)), 0)
                                                               commission_amt
           INTO rep.cf_comm_amt_undist
           FROM (SELECT   SUM
                             (DECODE (c.ri_comm_amt * c.currency_rt,
                                      0, NVL (b.commission_amt * c.currency_rt,
                                              0
                                             ),
                                      c.ri_comm_amt * c.currency_rt
                                     )
                             ) commission_amt,
                          c.policy_id policy_id
                     FROM gipi_comm_invoice b, gipi_invoice c
                    WHERE b.iss_cd = c.iss_cd
                          AND b.prem_seq_no = c.prem_seq_no
                 --b.policy_id=c.policy_id
                 GROUP BY c.policy_id) b,
                gipi_uwreports_ext a
          WHERE a.policy_id = b.policy_id
            AND a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND line_cd = NVL (p_line_cd, line_cd)
            AND subline_cd = NVL (p_subline_cd, subline_cd)
            AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                 OR (p_scope = 1 AND endt_seq_no = 0 AND pol_flag <> '5')
                 OR (p_scope = 2 AND endt_seq_no > 0 AND pol_flag <> '5')
                 OR (p_scope = 3 AND pol_flag = '4')
                 OR (p_scope = 4 AND pol_flag = '5')
                )
            AND NVL (dist_flag, 1) <> 3
            AND spld_date IS NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_comm_amt_undist := 0;
      END;

      --for cf_cnt_dist and cf_prem_dist
      BEGIN
         SELECT NVL (SUM (DECODE (spld_date, NULL, 1, 0)), 0),
                NVL (SUM (DECODE (spld_date, NULL, total_prem, 0)), 0)
           INTO rep.cf_cnt_dist,
                rep.cf_prem_dist
           FROM gipi_uwreports_ext a
          WHERE dist_flag = 3
            AND a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND line_cd = NVL (p_line_cd, line_cd)
            AND subline_cd = NVL (p_subline_cd, subline_cd)
            AND (   (    p_scope = 5
                     AND endt_seq_no = endt_seq_no
                     AND pol_flag <> '5'
                    )
                 OR (p_scope = 1 AND endt_seq_no = 0 AND pol_flag <> '5')
                 OR (p_scope = 2 AND endt_seq_no > 0 AND pol_flag <> '5')
                 OR (p_scope = 3 AND pol_flag = '4')
                 OR (p_scope = 4 AND pol_flag = '5')
                );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_cnt_dist := 0;
            rep.cf_prem_dist := 0;
      END;

      --for cf_comm_amt_dist
      BEGIN
         SELECT NVL (SUM (DECODE (spld_date, NULL, b.commission_amt, 0)), 0)
                                                               commission_amt
           INTO rep.cf_comm_amt_dist
           FROM (SELECT   SUM
                             (DECODE (c.ri_comm_amt * c.currency_rt,
                                      0, NVL (b.commission_amt * c.currency_rt,
                                              0
                                             ),
                                      c.ri_comm_amt * c.currency_rt
                                     )
                             ) commission_amt,
                          c.policy_id policy_id
                     FROM gipi_comm_invoice b, gipi_invoice c
                    WHERE b.iss_cd = c.iss_cd
                          AND b.prem_seq_no = c.prem_seq_no
                 --b.policy_id=c.policy_id(+)
                 GROUP BY c.policy_id) b,
                gipi_uwreports_ext a
          WHERE a.policy_id = b.policy_id(+)
            AND a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND line_cd = NVL (p_line_cd, line_cd)
            AND subline_cd = NVL (p_subline_cd, subline_cd)
            AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                 OR (p_scope = 1 AND endt_seq_no = 0 AND pol_flag <> '5')
                 OR (p_scope = 2 AND endt_seq_no > 0 AND pol_flag <> '5')
                 OR (p_scope = 3 AND pol_flag = '4')
                 OR (p_scope = 4 AND pol_flag = '5')
                )
            AND dist_flag = 3
            AND spld_date IS NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_comm_amt_dist := 0;
      END;

      PIPE ROW (rep);
   END populate_summary;
END;
/


