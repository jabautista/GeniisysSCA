CREATE OR REPLACE PACKAGE BODY CPI.giacr129_pkg
AS
 /*
   **  Created by   : Michael John R. Malicad
   **  Date Created : 07.16.2013
   **  Reference By : GIACR129
   **  Description  : Direct Business Production Take up Reports - Detailed per Line / Subline
   */
   FUNCTION cf_co_nameformula
      RETURN VARCHAR2
   IS
      v_company   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
   END;

   FUNCTION cf_1formula
      RETURN CHAR
   IS
      v_company_address   giac_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_company_address := ' ';
      END;

      RETURN (v_company_address);
   END;

   FUNCTION get_giacr129_record (p_date DATE)
      RETURN giacr129_record_tab PIPELINED
   IS
      v_list   giacr129_record_type;
   BEGIN
      v_list.company_name := cf_co_nameformula;
      v_list.company_address := cf_1formula;

      FOR i IN
         (SELECT   p_date, a.line_name "LINE_NAME",
                   a.subline_name "SUBLINE_NAME", a.pos_neg_inclusion,
                   a.policy_no "POLICY_NO", a.incept_date "INCEPT_DT",
                   a.issue_date "ISSUE_DT", d.assd_name "ASSURED_NAME",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', DECODE (b.prem_amt,
                                             0, 0,
                                             ROUND (  c.premium_amt
                                                    / b.prem_amt
                                                    * a.tsi_amt,
                                                    2
                                                   )
                                            ),
                                  -1
                                * DECODE (b.prem_amt,
                                          0, 0,
                                          ROUND (  c.premium_amt
                                                 / b.prem_amt
                                                 * a.tsi_amt,
                                                 2
                                                )
                                         )
                               )
                       ) "TSI_AMT",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', c.premium_amt * b.currency_rt,
                                -1 * (c.premium_amt * b.currency_rt)
                               )
                       ) "PREMIUM_AMT",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', c.commission_amt * b.currency_rt,
                                -1 * (c.commission_amt * b.currency_rt)
                               )
                       ) "COMMISSION_AMT",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', DECODE (b.prem_amt,
                                             0, 0,
                                             ROUND (  (  c.premium_amt
                                                       / b.prem_amt
                                                      )
                                                    * (  b.tax_amt
                                                       * b.currency_rt
                                                      ),
                                                    2
                                                   )
                                            ),
                                  -1
                                * DECODE (b.prem_amt,
                                          0, 0,
                                          ROUND (  (c.premium_amt / b.prem_amt
                                                   )
                                                 * (b.tax_amt * b.currency_rt
                                                   ),
                                                 2
                                                )
                                         )
                               )
                       ) "TAX_AMT",
                   e.pol_seq_no, e.issue_yy
              FROM giac_production_ext a,
                   gipi_invoice b,
                   gipi_comm_invoice c,
                   giis_assured d,
                   gipi_polbasic e
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND a.assd_no = d.assd_no
               AND a.policy_id = e.policy_id
          GROUP BY a.pos_neg_inclusion,
                   a.line_name,
                   a.subline_name,
                   e.issue_yy,
                   e.pol_seq_no,
                   a.policy_no,
                   a.incept_date,
                   a.issue_date,
                   d.assd_name)
      LOOP
         v_list.p_date := p_date;
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.pos_neg_inclusion := i.pos_neg_inclusion;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := i.incept_dt;
         v_list.issue_date := i.issue_dt;
         v_list.assd_name := i.assured_name;
         v_list.tsi_amt := i.tsi_amt;
         v_list.premium_amt := i.premium_amt;
         v_list.commission_amt := i.commission_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.issue_yy := i.issue_yy;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr129_record;
END;
/


