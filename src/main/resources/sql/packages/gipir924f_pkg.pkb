CREATE OR REPLACE PACKAGE BODY CPI.gipir924f_pkg
AS
/*
   **  Created by   :  Jasmin G. Balingit
   **  Date Created : 05.16.2012
   **  Reference By : GIPIR924F - Underwriting Production Report- Policy/Register Summary
   */
   FUNCTION populate_gipir924f (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN report_tab PIPELINED
   AS
      rep   report_type;
   BEGIN
      FOR i IN
         (SELECT   line_cd, subline_cd, iss_cd, user_id, SCOPE,
                   SUM (NVL (DECODE (spld_date, NULL, a.total_tsi, 0), 0)
                       ) total_si,
                   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd_header,
                   SUM (NVL (DECODE (spld_date, NULL, a.total_prem, 0), 0)
                       ) total_prem,
                   SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0)
                       ) evatprem,
                   SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0)) fst,
                   SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0)) lgt,
                   SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0)
                       ) doc_stamps,
                   SUM (NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0)
                       ) other_taxes,
                   SUM (NVL (DECODE (spld_date, NULL, a.other_charges, 0), 0)
                       ) other_charges,
                     SUM (NVL (DECODE (spld_date, NULL, a.total_prem, 0), 0)
                         )
                   + SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.other_charges, 0),
                               0)
                         ) total,
                   COUNT (DECODE (spld_date, NULL, 1, 0)) pol_count,
                     SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0)
                         )
                   + SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0))
                   + SUM (NVL (DECODE (spld_date, NULL, a.other_charges, 0),
                               0)
                         ) total_taxes,
                   SUM (NVL (DECODE (spld_date, NULL, b.commission, 0), 0)
                       ) commission
              FROM gipi_uwreports_ext a,
                   (SELECT   SUM
                                (DECODE (c.ri_comm_amt * c.currency_rt,
                                         0, NVL (  b.commission_amt
                                                 * c.currency_rt,
                                                 0
                                                ),
                                         c.ri_comm_amt * c.currency_rt
                                        )
                                ) commission,
                             c.policy_id policy_id
                        FROM gipi_comm_invoice b, gipi_invoice c
                       WHERE b.policy_id = c.policy_id
                    GROUP BY c.policy_id) b
             WHERE a.policy_id = b.policy_id(+)
               AND a.user_id = p_user_id
               AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                      NVL (p_iss_cd,
                           DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                          )
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
--  AND spld_date IS NULL
               /* added security rights control by robert 01.02.14*/
			   AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
			   AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1
			   /* robert 01.02.14 end of added code */
          GROUP BY line_cd,
                   subline_cd, iss_cd,
                   user_id,
                   SCOPE,
                   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
          ORDER BY iss_cd, line_cd, subline_cd)
      LOOP
         rep.line_cd := i.line_cd;
         rep.subline_cd := i.subline_cd;
         rep.iss_cd := i.iss_cd;
         rep.iss_cd_header := i.iss_cd_header;
         rep.pol_count := i.pol_count;
         rep.total_si := i.total_si;
         rep.total_prem := i.total_prem;
         rep.evatprem := i.evatprem;
         rep.fst := i.fst;
         rep.lgt := i.lgt;
         rep.doc_stamps := i.doc_stamps;
         rep.other_taxes := i.other_taxes;
         rep.other_charges := i.other_charges;
         rep.total := i.total;
         rep.total_taxes := i.total_taxes;
         rep.commission := i.commission;
         rep.user_id := i.user_id;
         rep.SCOPE := i.SCOPE;
         rep.cf_company := gipir924f_pkg.cf_company (i.user_id, i.SCOPE);
         rep.cf_company_address :=
                        gipir924f_pkg.cf_company_address (i.user_id, i.SCOPE);
         rep.cf_heading3 := gipir924f_pkg.cf_heading3 (i.user_id);
         rep.cf_based_on := gipir924f_pkg.cf_based_on (i.user_id);
         rep.cf_iss_name := gipir924f_pkg.cf_iss_name (i.iss_cd);
         rep.cf_iss_title := gipir924f_pkg.cf_iss_title (p_iss_param);
         rep.cf_line_name := gipir924f_pkg.cf_line_name (i.line_cd);
         rep.cf_subline_name :=
                      gipir924f_pkg.cf_subline_name (i.subline_cd, i.line_cd);
         rep.cf_new_comm :=
            gipir924f_pkg.cf_new_comm (i.subline_cd,
                                       i.line_cd,
                                       i.iss_cd,
                                       p_iss_param,
                                       p_user_id
                                      );

         FOR x IN (SELECT giacp.v ('SHOW_TOTAL_TAXES') param_v
                     FROM DUAL)
         LOOP
            rep.param_v := x.param_v;
         END LOOP;

         PIPE ROW (rep);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_company (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR
   IS
      v_company_name   VARCHAR2 (150);
   BEGIN
      SELECT param_value_v
        INTO v_company_name
        FROM giis_parameters
       WHERE UPPER (param_name) = 'COMPANY_NAME';

      RETURN (v_company_name);
   END;

   FUNCTION cf_company_address (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   FUNCTION cf_heading3 (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR
   IS
      v_param_date   NUMBER (1);
      v_from_date    DATE;
      v_to_date      DATE;
      heading3       VARCHAR2 (150);
   BEGIN
      SELECT DISTINCT param_date, from_date, TO_DATE
                 INTO v_param_date, v_from_date, v_to_date
                 FROM gipi_uwreports_ext
                WHERE user_id = p_user_id;

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
   END;

   FUNCTION cf_based_on (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR
   IS
      v_param_date   NUMBER (1);
      v_based_on     VARCHAR2 (100);
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
         v_based_on := 'Based on Booking month - year';
      ELSIF v_param_date = 4
      THEN
         v_based_on := 'Based on Acctg Entry Date';
      END IF;

      RETURN (v_based_on);
   END;

   FUNCTION cf_iss_name (p_iss_cd gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (200);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (p_iss_cd || ' - ' || v_iss_name);
   END;

   FUNCTION cf_iss_title (p_iss_param gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR
   IS
   BEGIN
      IF p_iss_param = 2
      THEN
         RETURN ('Issue Source     :');
      ELSE
         RETURN ('Crediting Branch :');
      END IF;
   END;

   FUNCTION cf_line_name (p_line_cd giis_line.line_cd%TYPE)
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         RETURN (c.line_name);
      END LOOP;
   END;

   FUNCTION cf_subline_name (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         RETURN (c.subline_name);
      END LOOP;
   END;

   FUNCTION cf_new_comm (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN NUMBER
   IS
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2) := 0; -- marco - added default values
      v_commission_amt   NUMBER (20, 2) := 0; --
      v_comm_amt         NUMBER (20, 2) := 0; --
   BEGIN
      SELECT DISTINCT TO_DATE
                 INTO v_to_date
                 FROM gipi_uwreports_ext
                WHERE user_id = p_user_id;

      v_fund_cd := giacp.v ('FUND_CD');
      v_branch_cd := giacp.v ('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no,
                        c.ri_comm_amt, c.currency_rt, b.commission_amt,
                        a.spld_date
                   FROM gipi_comm_invoice b,
                        gipi_invoice c,
                        gipi_uwreports_ext a
                  WHERE a.policy_id = b.policy_id
                    AND a.policy_id = c.policy_id
                    AND a.user_id = p_user_id
                    AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                                                                      p_iss_cd
                    AND a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd)
      LOOP
         IF (rc.ri_comm_amt * rc.currency_rt) = 0
         THEN
            v_commission_amt := rc.commission_amt;

            FOR c1 IN (SELECT   acct_ent_date, commission_amt, comm_rec_id,
                                intm_no
                           FROM giac_new_comm_inv
                          WHERE iss_cd = rc.iss_cd
                            AND prem_seq_no = rc.prem_seq_no
                            AND fund_cd = v_fund_cd
                            AND branch_cd = v_branch_cd
                            AND tran_flag = 'P'
                            AND NVL (delete_sw, 'N') = 'N'
                       ORDER BY comm_rec_id DESC)
            LOOP
               IF c1.acct_ent_date > v_to_date
               THEN
                  FOR c2 IN (SELECT commission_amt
                               FROM giac_prev_comm_inv
                              WHERE fund_cd = v_fund_cd
                                AND branch_cd = v_branch_cd
                                AND comm_rec_id = c1.comm_rec_id
                                AND intm_no = c1.intm_no)
                  LOOP
                     v_commission_amt := c2.commission_amt;
                  END LOOP;
               ELSE
                  v_commission_amt := c1.commission_amt;
               END IF;

               EXIT;
            END LOOP;

            v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
         ELSE
            v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
         END IF;

         v_commission := NVL (v_commission, 0) + v_comm_amt;

         IF rc.spld_date IS NOT NULL
         THEN
            v_commission := 0;
            EXIT;
         END IF;
      END LOOP;

      RETURN (v_commission);
   END;
END gipir924f_pkg;
/


