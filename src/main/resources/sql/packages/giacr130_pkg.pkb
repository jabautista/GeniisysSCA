CREATE OR REPLACE PACKAGE BODY CPI.GIACR130_PKG
AS
/*
   **  Created by   : Ariel P. Ignas Jr
   **  Date Created : 07.16.2013
   **  Reference By : GIACR130
   **  Description  : Direct Business Production Take up Reports - Summary per source of business
   */
   FUNCTION cf_co_nameformula
      RETURN VARCHAR2
   IS
      company_name   VARCHAR2 (50);
   BEGIN
      FOR c IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         company_name := c.param_value_v;
         EXIT;
      END LOOP;

      RETURN (company_name);
   END;

   FUNCTION cf_company_addformula
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

   FUNCTION get_giacr130_record (p_date DATE)
      RETURN giacr130_record_tab PIPELINED
   IS
      v_list   giacr130_record_type;
   BEGIN
      v_list.cf_company_name := cf_co_nameformula;
      v_list.cf_company_add := cf_company_addformula;

      FOR i IN (SELECT   p_date, d.intm_name "SOURCE_OF_BUSINESS",
                         a.pos_neg_inclusion, a.line_name "LINE_NAME",
                         a.subline_name "SUBLINE_NAME",
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', a.tsi_amt,
                                      -1 * a.tsi_amt
                                     )
                             ) "TSI_AMT",
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', b.prem_amt * b.currency_rt,
                                      -1 * (b.prem_amt * b.currency_rt)
                                     )
                             ) "PREM_AMT",
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', c.commission_amt * b.currency_rt,
                                      -1 * (c.commission_amt * b.currency_rt)
                                     )
                             ) "COMM_AMT",
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', b.tax_amt * b.currency_rt,
                                      -1 * (b.tax_amt * b.currency_rt)
                                     )
                             ) "TAX_AMT"
                    FROM giac_production_ext a,
                         gipi_invoice b,
                         gipi_comm_invoice c,
                         giis_intermediary d,
                         giis_intm_type e
                   WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id(+)
                     AND c.intrmdry_intm_no = d.intm_no
                     AND d.intm_type = e.intm_type
                GROUP BY a.pos_neg_inclusion,
                         d.intm_name,
                         a.line_name,
                         a.subline_name)
      LOOP
         v_list.p_date := UPPER(TO_CHAR(i.p_date, 'MONTH, RRRR'));
         v_list.intm_name := i.source_of_business;
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.pos_neg_inclusion := i.pos_neg_inclusion;
         v_list.tsi_amt := i.tsi_amt;
         v_list.prem_amt := i.prem_amt;
         v_list.comm_amt := i.comm_amt;
         v_list.tax_amt := i.tax_amt;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr130_record;
END;
/


