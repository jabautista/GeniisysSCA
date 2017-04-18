CREATE OR REPLACE PACKAGE BODY CPI.giacr132_pkg
AS
/*
**Created by: Benedict G. Castillo
**Date Created: 07.16.2013
**Descritpion: GIACR132 - PRODUCTION TAKE UP PER  SOURCE OF BUSINESS - DETAILED
*/
   FUNCTION populate_giacr132 (p_date VARCHAR2)
      RETURN giacr132_tab PIPELINED
   AS
      v_rec         giacr132_type;
      v_not_exist   BOOLEAN       := TRUE;
      v_date        DATE := TO_DATE(p_date, 'MM-DD-YYYY'); --benjo 11.06.2015 GENQA-SR-5142
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
      --v_rec.accnt_ent_date := ('For the month of ' || UPPER(TO_CHAR(p_date, 'MONTH, RRRR'))); --benjo 11.06.2015 comment out
      v_rec.accnt_ent_date := ('For the month of ' || UPPER(TO_CHAR(v_date, 'fmMONTH, RRRR'))); --benjo 11.06.2015 GENQA-SR-5142

      FOR i IN (SELECT   p_date, d.intm_name source_of_buss, a.line_name,
                         a.subline_name, a.policy_no, a.pos_neg_inclusion,
                         DECODE (d.parent_intm_no,
                                 NULL, c.intrmdry_intm_no,
                                 d.parent_intm_no
                                ) intm_no,
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
                             ) tax_amt,
                         f.issue_yy, f.pol_seq_no
                    FROM giac_production_ext a,
                         gipi_invoice b,
                         gipi_comm_invoice c,
                         giis_intermediary d,
                         giis_intm_type e,
                         gipi_polbasic f
                   WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id(+)
                     AND b.iss_cd = c.iss_cd(+)
                     AND b.prem_seq_no = c.prem_seq_no(+)
                     AND c.intrmdry_intm_no = d.intm_no
                     AND d.intm_type = e.intm_type
                     AND a.policy_id = f.policy_id
                GROUP BY d.intm_name,
                         a.pos_neg_inclusion,
                         a.line_name,
                         a.subline_name,
                         f.issue_yy,
                         f.pol_seq_no,
                         a.policy_no,
                         c.iss_cd,
                         c.prem_seq_no,
                         d.parent_intm_no,
                         c.intrmdry_intm_no)
      LOOP
         v_not_exist := FALSE;
         v_rec.source_of_buss := i.source_of_buss;
         v_rec.line_name := i.line_name;
         v_rec.subline_name := i.subline_name;
         v_rec.policy_no := i.policy_no;

         IF i.pos_neg_inclusion = 'P'
         THEN
            v_rec.spoiled := NULL;
         ELSIF i.pos_neg_inclusion = 'N'
         THEN
            v_rec.spoiled := 'SPLD';
         END IF;

         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.comm_amt := i.comm_amt;
         v_rec.tax_amt := i.tax_amt;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      ELSE
         NULL;
      END IF;
   END populate_giacr132;
END giacr132_pkg;
/


