CREATE OR REPLACE PACKAGE BODY CPI.GIACR127_PKG
AS
 /*
   **  Created by   : Paolo Santos
   **  Date Created : 07.16.2013
   **  Reference By : GIACR127
   **  Description  : Direct Business Production Take up Reports - Summary per Line / Subline
   */
   FUNCTION cf_spoiledformula (p_pos_neg_inclusion VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_pos_neg_inclusion = 'P'
      THEN
         RETURN (NULL);
      ELSIF p_pos_neg_inclusion = 'N'
      THEN
         RETURN ('S');
      END IF;

      RETURN NULL;
   END;

   FUNCTION cf_2formula
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

   FUNCTION get_giacr127_record (p_date DATE)
      RETURN giacr127_record_tab PIPELINED
   IS
      v_list   giacr127_record_type;
   BEGIN
      FOR i IN
         (SELECT   p_date, a.pos_neg_inclusion, a.line_name "LINE_NAME",
                   a.subline_name "SUBLINE_NAME",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', a.tsi_amt,
                                -1 * a.tsi_amt
                               )
                       ) "TSI_AMT",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', a.prem_amt * b.currency_rt,
                                -1 * (a.prem_amt * b.currency_rt)
                               )
                       ) "PREM_AMT",
                   SUM (get_booked_intm_comm_amt (b.iss_cd,
                                                  b.prem_seq_no,
                                                  a.intm_no,
--                                                   TO_DATE ('01 ' || p_date,
--                                                             'DD MONTH, RRRR'
--                                                            ),
--                                                   LAST_DAY (TO_DATE ('01 ' || p_date,
--                                                                      'DD MONTH, RRRR'
                                                  p_date,
                                                  LAST_DAY (p_date)
                                                 
                       )) "COMM_AMT",
                   SUM (DECODE (a.pos_neg_inclusion,
                                'P', b.tax_amt * b.currency_rt,
                                -1 * (b.tax_amt * b.currency_rt)
                               )
                       ) "TAX_AMT"
              FROM giac_production_ext a, gipi_invoice b
             WHERE a.policy_id = b.policy_id
          GROUP BY a.pos_neg_inclusion, a.line_name, a.subline_name)
      LOOP
        v_list.p_date := UPPER(TO_CHAR(p_date, 'MONTH, RRRR'));
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.prem_amt := i.prem_amt;
         v_list.pos_neg_inclusion := i.pos_neg_inclusion;
         v_list.tsi_amt := i.tsi_amt;
         v_list.comm_amt := i.comm_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.cf_co_name := cf_co_nameformula;
         v_list.cf_company_add := cf_2formula;
         v_list.cf_spoiled := cf_spoiledformula (i.pos_neg_inclusion);
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr127_record;
END;
/


