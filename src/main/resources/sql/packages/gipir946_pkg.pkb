CREATE OR REPLACE PACKAGE BODY CPI.gipir946_pkg  
AS
   FUNCTION get_dt (
      p_scope        NUMBER,
      p_subline_cd   gipi_uwreports_peril_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_peril_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_peril_ext.iss_cd%TYPE,
      p_iss_param    NUMBER,
      p_user_id      gipi_uwreports_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      --,p_peril_cd gipi_uwreports_peril_ext.peril_cd%type, p_intm_name)
   RETURN gipir946_dt_tab PIPELINED
   IS
      v_dt             get_data_type;
      v_iss_name       VARCHAR2 (50);
      v_param_date     NUMBER (1);
      v_from_date      DATE;
      v_to_date        DATE;
      v_company_name   VARCHAR2 (150);
      v_address        VARCHAR2 (500);
      v_scope          NUMBER (1);
      v_based_on       VARCHAR2 (100);
      v_commission     NUMBER (20, 2);
   BEGIN
   
      --CF_ISS_HEADER
         IF p_iss_param = 1
         THEN
            v_dt.cf_iss_header := 'Crediting Branch';
         ELSIF p_iss_param = 2
         THEN
            v_dt.cf_iss_header := 'Issue Source';
         ELSE
            v_dt.cf_iss_header := ' ';
         END IF;

         --CF_HEADING3
         BEGIN
            SELECT DISTINCT param_date, from_date, TO_DATE
                       INTO v_param_date, v_from_date, v_to_date
                       FROM gipi_uwreports_peril_ext
                      WHERE user_id = p_user_id;

            IF v_param_date IN (1, 2, 4)
            THEN
               IF v_from_date = v_to_date
               THEN
                  v_dt.cf_heading :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
               ELSE
                  v_dt.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
            ELSE
               IF v_from_date = v_to_date
               THEN
                  v_dt.cf_heading :=
                        'For the month of '
                     || TO_CHAR (v_from_date, 'fmMonth, yyyy');
               ELSE
                  v_dt.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
            END IF;
         END;

         --CF_COMPANY
         BEGIN
            SELECT param_value_v
              INTO v_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';

            v_dt.cf_company := v_company_name;
         END;

         --CF_COMPANY_ADDRESS
         BEGIN
            SELECT param_value_v
              INTO v_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';

            v_dt.cf_com_address := v_address;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
               v_dt.cf_com_address := v_address;
         END;

         --CF_BASED_ON
         BEGIN
            SELECT param_date
              INTO v_param_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id
               AND ROWNUM = 1;

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

            v_scope := p_scope;

            IF v_scope = 1
            THEN
               v_dt.cf_based_on := v_based_on || ' / ' || 'Policies Only';
            ELSIF v_scope = 2
            THEN
               v_dt.cf_based_on := v_based_on || ' / ' || 'Endorsements Only';
            ELSIF v_scope = 3
            THEN
               v_dt.cf_based_on :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
            END IF;
         END;
         
      FOR rec IN (SELECT   /*+ NO_MERGE(A)*/
                           a.iss_cd iss_cd, a.iss_name iss_name,
                           a.line_cd line_cd, a.line_name line_name,
                           a.subline_cd subline_cd,
                           a.subline_name subline_name, a.peril_cd peril_cd,
                           a.peril_name peril_name, a.peril_type peril_type,
                           a.intm_no intm_no, a.intm_name intm_name,
                           a.sumdecode sumdecode, a.sumtsi sumtsi,
                           a.sumprem sumprem,                              --,
                           a.comm_amt  --Added by pjsantos 03/08/2017, for optimization GENQA 5912
                      --CF_new_commission(a.iss_cd, a.line_cd, a.subline_cd, a.peril_cd, --a.intm_no, :p_iss_param) CF_new_commission
                  FROM     (SELECT   DECODE (p_iss_param,
                                             1, cred_branch,
                                             x.iss_cd
                                            ) iss_cd,
                                     iss_name, x.line_cd, line_name,
                                     x.subline_cd, subline_name, peril_cd,
                                     peril_name, peril_type, intm_no,
                                     intm_name,
                                     SUM (DECODE (peril_type,
                                                  'B', tsi_amt,
                                                  0
                                                 )
                                         ) sumdecode,
                                     SUM (tsi_amt) sumtsi,
                                     SUM (prem_amt) sumprem, SUM(x.commission_amt) comm_amt  --Added by pjsantos 03/08/2017, for optimization GENQA 5912
                                FROM gipi_uwreports_peril_ext x,
                                     giis_subline y,
                                     giis_issource z
                               WHERE x.user_id = p_user_id
                                 AND DECODE (p_iss_param,
                                             1, cred_branch,
                                             x.iss_cd
                                            ) =
                                        NVL (p_iss_cd,
                                             DECODE (p_iss_param,
                                                     1, cred_branch,
                                                     x.iss_cd
                                                    )
                                            )
                                 AND x.iss_cd = z.iss_cd
                                 AND x.line_cd = y.line_cd
                                 AND x.subline_cd = y.subline_cd
                                 AND x.line_cd = NVL (p_line_cd, x.line_cd)
                                 AND x.subline_cd =
                                              NVL (p_subline_cd, x.subline_cd)
                                 AND x.iss_cd = NVL (p_iss_cd, x.iss_cd)
                                 AND (   (    p_scope = 3
                                          AND endt_seq_no = endt_seq_no
                                         )
                                      OR (p_scope = 1 AND endt_seq_no = 0)
                                      OR (p_scope = 2 AND endt_seq_no > 0)
                                     )
                            GROUP BY DECODE (p_iss_param,
                                             1, cred_branch,
                                             x.iss_cd
                                            ),
                                     iss_name,
                                     x.line_cd,
                                     line_name,
                                     x.subline_cd,
                                     subline_name,
                                     peril_cd,
                                     peril_name,
                                     peril_type,
                                     intm_no,
                                     intm_name) a  
                  ORDER BY iss_name, line_cd, subline_cd, peril_cd)
      LOOP
         v_dt.iss_cd := rec.iss_cd;
         v_dt.line_cd := rec.line_cd;
         v_dt.line_name := rec.line_name;
         v_dt.subline_cd := rec.subline_cd;
         v_dt.subline_name := rec.subline_name;
         v_dt.peril_cd := rec.peril_cd;
         v_dt.peril_name := rec.peril_name;
         v_dt.peril_type := rec.peril_type;
         v_dt.intm_no := rec.intm_no;
         v_dt.intm_name := rec.intm_name;
         v_dt.sumdecode := rec.sumdecode;
         v_dt.sumtsi := rec.sumtsi;
         v_dt.sumprem := rec.sumprem;
         v_dt.cf_iss_name := rec.iss_cd || '  -  ' || rec.iss_name;
         v_dt.cf_new_commission := rec.comm_amt; --Added by pjsantos 03/08/2017, for optimization GENQA 5912
 /*           gipir946_pkg.get_cf_commission (rec.subline_cd,
                                            rec.line_cd,
                                            rec.iss_cd,
                                            rec.intm_no,
                                            rec.peril_cd,
                                            p_user_id
                                           );*/ --Comment out by pjsantos 03/08/2017, for optimization GENQA 5912

         /*--CF_ISS_HEADER
         IF p_iss_param = 1
         THEN
            v_dt.cf_iss_header := 'Crediting Branch';
         ELSIF p_iss_param = 2
         THEN
            v_dt.cf_iss_header := 'Issue Source';
         ELSE
            v_dt.cf_iss_header := ' ';
         END IF;

         --CF_HEADING3
         BEGIN
            SELECT DISTINCT param_date, from_date, TO_DATE
                       INTO v_param_date, v_from_date, v_to_date
                       FROM gipi_uwreports_peril_ext
                      WHERE user_id = p_user_id;

            IF v_param_date IN (1, 2, 4)
            THEN
               IF v_from_date = v_to_date
               THEN
                  v_dt.cf_heading :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
               ELSE
                  v_dt.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
            ELSE
               IF v_from_date = v_to_date
               THEN
                  v_dt.cf_heading :=
                        'For the month of '
                     || TO_CHAR (v_from_date, 'fmMonth, yyyy');
               ELSE
                  v_dt.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
            END IF;
         END;

         --CF_COMPANY
         BEGIN
            SELECT param_value_v
              INTO v_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';

            v_dt.cf_company := v_company_name;
         END;

         --CF_COMPANY_ADDRESS
         BEGIN
            SELECT param_value_v
              INTO v_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';

            v_dt.cf_com_address := v_address;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
               v_dt.cf_com_address := v_address;
         END;

         --CF_BASED_ON
         BEGIN
            SELECT param_date
              INTO v_param_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id
               AND ROWNUM = 1;

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

            v_scope := p_scope;

            IF v_scope = 1
            THEN
               v_dt.cf_based_on := v_based_on || ' / ' || 'Policies Only';
            ELSIF v_scope = 2
            THEN
               v_dt.cf_based_on := v_based_on || ' / ' || 'Endorsements Only';
            ELSIF v_scope = 3
            THEN
               v_dt.cf_based_on :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
            END IF;
         END;*/--Moved to top by pjsantos 03/02/2017, for optimization GENQA 5912

         /*  BEGIN

             IF p_iss_cd <> 'RI' THEN
                 FOR A IN(
                 SELECT (b.commission_amt * e.currency_rt) commission
                 FROM GIPI_UWREPORTS_PERIL_EXT a,
                     GIPI_COMM_INV_PERIL b,
                     GIPI_INVPERIL d,
                     GIPI_INVOICE e
                 WHERE a.policy_id  = b.policy_id(+)
                 AND a.peril_cd   = b.peril_cd(+)
                 AND b.iss_cd = d.iss_cd
                 AND b.prem_seq_no = d.prem_seq_no
                 AND e.iss_cd = d.iss_cd
                 AND e.prem_seq_no = d.prem_seq_no
                 AND a.user_id       = USER
                 AND a.iss_cd     = NVL( p_iss_cd, a.iss_cd)
                 AND a.line_cd       = NVL( p_line_cd, a.line_cd)
                 AND a.subline_cd = NVL( p_subline_cd, a.subline_cd)
                 AND a.intm_no in (select intm_no from giis_intermediary where intm_name = a.intm_name)
                 AND d.peril_cd = a.peril_cd
                 --GROUP by decode(P_ISS_PARAM, 1, cred_branch, a.iss_cd), a.line_cd, line_name, a.subline_cd, a.peril_cd, peril_name, peril_type, intm_no, a.intm_name)
                 AND a.peril_cd = b.peril_cd)
                 LOOP
                 --if p_iss_cd <> 'RI' then
                 v_dt.CF_new_commission := a.commission;
                 --end if;
                 END LOOP;
             ELSE
                 FOR A IN(
                 SELECT (d.ri_comm_amt * e.currency_rt) commission
                 FROM GIPI_UWREPORTS_PERIL_EXT a,
                         GIPI_INVPERIL d,
                         GIPI_INVOICE e
                 WHERE a.policy_id  = e.policy_id
                 AND e.iss_cd = d.iss_cd
                 AND e.prem_seq_no = d.prem_seq_no
                 AND a.user_id       = USER
                 AND a.iss_cd     = NVL( p_iss_cd, a.iss_cd)
                 AND a.line_cd       = NVL( p_line_cd, a.line_cd)
                 AND a.subline_cd = NVL( p_subline_cd, a.subline_cd)
                 AND d.peril_cd = a.peril_cd)
                 --GROUP by decode(P_ISS_PARAM, 1, cred_branch, a.iss_cd), a.line_cd, line_name, a.subline_cd, a.peril_cd, peril_name, peril_type, intm_no, a.intm_name)
                 --AND a.peril_cd = p_peril_cd)
                 LOOP
                 v_dt.CF_new_commission := a.commission;
                 END LOOP;

             END IF;
           end; */
         PIPE ROW (v_dt);
      END LOOP;
   END;

   FUNCTION get_cf_commission (
      p_subline_cd   gipi_uwreports_peril_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_peril_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_peril_ext.iss_cd%TYPE,
      p_intm_no      gipi_uwreports_peril_ext.intm_no%TYPE,
      p_peril_cd     gipi_uwreports_peril_ext.peril_cd%TYPE,
      p_user_id      gipi_uwreports_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN NUMBER
   IS
      v_comm   NUMBER (20, 2);
   BEGIN
      IF p_iss_cd <> 'RI'
      THEN
         FOR a IN (SELECT SUM (b.commission_amt * currency_rt) commission
                     FROM gipi_uwreports_peril_ext a,
                          gipi_comm_inv_peril b,
                          gipi_invperil d,
                          gipi_invoice e
                    WHERE a.policy_id = b.policy_id(+)
                      AND a.peril_cd = b.peril_cd(+)
                      AND b.iss_cd = d.iss_cd
                      AND b.prem_seq_no = d.prem_seq_no
                      AND e.iss_cd = d.iss_cd
                      AND e.prem_seq_no = d.prem_seq_no
                      AND a.user_id = p_user_id
                      AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                      AND a.intm_no = p_intm_no
                      AND d.peril_cd = a.peril_cd
                      AND a.peril_cd = p_peril_cd)
         LOOP
            IF p_iss_cd <> 'RI'
            THEN
               v_comm := a.commission;
            END IF;
         END LOOP;
      ELSE
         FOR a IN (SELECT SUM (d.ri_comm_amt * e.currency_rt) commission
                     FROM gipi_uwreports_peril_ext a,
                          gipi_invperil d,
                          gipi_invoice e
                    WHERE a.policy_id = e.policy_id
                      AND e.iss_cd = d.iss_cd
                      AND e.prem_seq_no = d.prem_seq_no
                      AND a.user_id = p_user_id
                      AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                      AND d.peril_cd = a.peril_cd
                      --GROUP by decode(P_ISS_PARAM, 1, cred_branch, a.iss_cd), a.line_cd, line_name, a.subline_cd, a.peril_cd, peril_name, peril_type, intm_no, a.intm_name)
                      AND a.peril_cd = p_peril_cd)
         LOOP
            v_comm := a.commission;
         END LOOP;
      END IF;

      RETURN (v_comm);
   END;
END gipir946_pkg; 
/


