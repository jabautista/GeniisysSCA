CREATE OR REPLACE PACKAGE BODY CPI.giacr131_pkg
AS
/*
**Created by: Benedict G. Castillo
**Date Created:07.16.2013
**Description:GIACR131:DIRECT BUSINESS PRODUCTION TAKE UP PER SOURCE OF BUSINESS
*/
   FUNCTION populate_giacr131 (p_date VARCHAR2)
      RETURN giacr131_tab PIPELINED
   AS
      v_rec         giacr131_type;
      v_not_exist   BOOLEAN       := TRUE;
      v_date        DATE := TO_DATE(p_date, 'MM-DD-YYYY'); --benjo 11.06.2015 GENQA-SR-5141
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
      --v_rec.v_date := ('For the month of ' || UPPER(TO_CHAR(p_date, 'MONTH, RRRR'))); --benjo 11.06.2015 comment out
      v_rec.v_date := ('For the month of ' || UPPER(TO_CHAR(v_date, 'fmMONTH, RRRR'))); --benjo 11.06.2015 GENQA-SR-5141

      FOR i IN (SELECT   p_date, e.intm_desc source_of_buss,
                         a.branch_name branch, a.pos_neg_inclusion,
                         a.line_name, a.subline_name,
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', a.tsi_amt,
                                      -1 * a.tsi_amt
                                     )
                             ) tsi_amt,
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', b.prem_amt * b.currency_rt,
                                      -1 * (b.prem_amt * b.currency_rt)
                                     )
                             ) prem_amt,
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', c.commission_amt * b.currency_rt,
                                      -1 * (c.commission_amt * b.currency_rt)
                                     )
                             ) comm_amt,
                         SUM (DECODE (a.pos_neg_inclusion,
                                      'P', b.tax_amt * b.currency_rt,
                                      -1 * (b.tax_amt * b.currency_rt)
                                     )
                             ) tax_amt
                    FROM giac_production_ext a,
                         gipi_invoice b,
                         gipi_comm_invoice c,
                         giis_intermediary d,
                         giis_intm_type e
                   WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id
                     AND c.intrmdry_intm_no = d.intm_no
                     AND d.intm_type = e.intm_type
                --AND A.POS_NEG_INCLUSION = 'P'
                GROUP BY a.pos_neg_inclusion,
                         a.branch_name,
                         e.intm_desc,
                         a.line_name,
                         a.subline_name
                ORDER BY a.branch_name,
                         e.intm_desc,
                         a.pos_neg_inclusion,
                         a.line_name)
      LOOP
         v_not_exist := FALSE;
         v_rec.branch := i.branch;
         v_rec.source_of_buss := i.source_of_buss;
         v_rec.line_name := i.line_name;
         v_rec.subline_name := i.subline_name;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.tax_amt := i.tax_amt;
         v_rec.comm_amt := i.comm_amt;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      ELSE
         NULL;
      END IF;
   END populate_giacr131;
END giacr131_pkg;
/


