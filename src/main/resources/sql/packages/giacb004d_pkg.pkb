CREATE OR REPLACE PACKAGE BODY CPI.GIACB004D_PKG
AS
/*
   ** Created by : Kenneth Labrador
   ** Date Created : 10.11.2013
   ** Reference By : GIACB004D
   ** Description : Inward Facultative Acceptances (Detail)
   */
   FUNCTION get_giacb400d_record (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb400d_record_tab PIPELINED
   IS
      v_list   giacb400d_record_type;
      v_flag   BOOLEAN               := FALSE;
      v_pol    VARCHAR2 (50);
   BEGIN
      v_list.cf_company_name := NVL (giisp.v ('COMPANY_NAME'), ' ');
      v_list.top_date :=
            'For the Month of '
         || TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'fmMONTH yyyy');
      v_list.cf_company_address := NVL (giisp.v ('COMPANY_ADDRESS'), ' ');
      v_list.v_flag := 'N';

      FOR i IN
         (SELECT   a.line_cd, NVL (d.currency_rt, 0) currency_rt,
                   get_policy_no (a.policy_id) policy_number,
                   e.assd_name assured, f.ri_name reinsurer, d.currency_cd,
                   SUM (DECODE (TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'),
                                         'MM-YYYY'
                                        ),
                                TO_CHAR (a.acct_ent_date, 'MM-YYYY'), c.prem_amt
                                 * d.currency_rt,
                                c.prem_amt * d.currency_rt * -1
                               )
                       ) premium,
                   SUM
                      (DECODE (TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'),
                                        'MM-YYYY'
                                       ),
                               TO_CHAR (a.acct_ent_date, 'MM-YYYY'), c.ri_comm_amt
                                * d.currency_rt,
                               c.ri_comm_amt * d.currency_rt * -1
                              )
                      ) ri_commission
              FROM gipi_polbasic a,
                   giri_inpolbas b,
                   gipi_invperil c,
                   gipi_invoice d,
                   giis_assured e,
                   giis_reinsurer f
             WHERE 1 = 1
               AND c.iss_cd = d.iss_cd
               AND c.prem_seq_no = d.prem_seq_no
               AND a.policy_id = d.policy_id
               AND a.policy_id = b.policy_id
               AND a.assd_no = e.assd_no
               AND b.ri_cd = f.ri_cd
               AND a.iss_cd = 'RI'
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 d.iss_cd,
                                                 'GIARPR001',
                                                 p_user_id
                                                ) = 1
               AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                           TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'MM-YYYY')
                    OR TO_CHAR (a.spld_acct_ent_date, 'MM-YYYY') =
                           TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'MM-YYYY')
                   )
          GROUP BY a.line_cd,
                   d.currency_rt,
                   get_policy_no (a.policy_id),
                   e.assd_name,
                   f.ri_name,
                   d.currency_cd
          ORDER BY policy_number)
      LOOP
         IF v_list.policy_number = i.policy_number
         THEN
            v_list.assured := '';
            v_list.reinsurer := '';
         ELSE
            v_list.assured := i.assured;
            v_list.reinsurer := i.reinsurer;
         END IF;

         v_flag := TRUE;
         v_list.v_flag := 'Y';
         v_list.line_cd := i.line_cd;
         v_list.currency_rt := i.currency_rt;
         v_list.policy_number := i.policy_number;
         v_list.currency_cd := i.currency_cd;
         v_list.premium := i.premium;
         v_list.ri_commission := i.ri_commission;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         END;

         BEGIN
            SELECT SUM (NVL (b.ri_comm_vat * b.currency_rt, 0)) ri_comm_vat
              INTO v_list.ri_comm_vat
              FROM gipi_polbasic a, gipi_invoice b
             WHERE a.policy_id = b.policy_id
               AND a.iss_cd = 'RI'
               AND get_policy_no (a.policy_id) = i.policy_number
               AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                           TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'MM-YYYY')
                    OR TO_CHAR (a.spld_acct_ent_date, 'MM-YYYY') =
                           TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'MM-YYYY')
                   );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.ri_comm_vat := 0;
            WHEN TOO_MANY_ROWS
            THEN
               v_list.ri_comm_vat := v_list.ri_comm_vat;
         END;

         BEGIN
            SELECT   SUM (NVL (d.tax_amt, 0)) prem_vat
                INTO v_list.prem_vat
                FROM gipi_polbasic a,
                     giri_inpolbas b,
                     gipi_invperil c,
                     gipi_invoice d,
                     giis_assured e,
                     giis_reinsurer f
               WHERE 1 = 1
                 AND c.iss_cd = d.iss_cd
                 AND c.prem_seq_no = d.prem_seq_no
                 AND a.policy_id = d.policy_id
                 AND a.policy_id = b.policy_id
                 AND a.assd_no = e.assd_no
                 AND b.ri_cd = f.ri_cd
                 AND a.iss_cd = 'RI'
                 AND get_policy_no (a.policy_id) = i.policy_number
                 AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                            TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'),
                                     'MM-YYYY')
                      OR TO_CHAR (a.spld_acct_ent_date, 'MM-YYYY') =
                            TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'),
                                     'MM-YYYY')
                     )
            GROUP BY a.policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.prem_vat := 0;
            WHEN TOO_MANY_ROWS
            THEN
               v_list.prem_vat := v_list.prem_vat;
         END;

         BEGIN
            v_list.cf_net :=
               (  (NVL (i.premium, 0) + NVL (v_list.prem_vat, 0))
                - (NVL (i.ri_commission, 0) + NVL (v_list.ri_comm_vat, 0))
               );
         END;

         PIPE ROW (v_list);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacb400d_record;
END GIACB004D_PKG;
/


