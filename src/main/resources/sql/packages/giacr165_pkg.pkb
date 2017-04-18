CREATE OR REPLACE PACKAGE BODY CPI.giacr165_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.24.2013
   **  Reference By : GIACR165 - Special Reports(by Branch)
   **  Description  :
   */
   FUNCTION get_giacr165_records (
      p_from_date   DATE,
      p_to_date     DATE,
      p_report      VARCHAR2
   )
      RETURN giacr165_records_tab PIPELINED
   IS
      v_rec         giacr165_records_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      v_rec.cf_company := giisp.v ('COMPANY_NAME');
      v_rec.cf_company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.cf_from_date := TO_CHAR (p_from_date, get_rep_date_format);
      v_rec.cf_to_date := TO_CHAR (p_to_date, get_rep_date_format);

      FOR a IN (SELECT rep_title
                  FROM giac_eom_rep
                 WHERE rep_cd = p_report)
      LOOP
         v_rec.cf_title := a.rep_title;
      END LOOP;

      FOR i IN (SELECT   a.gibr_branch_cd, d.line_name, c.gl_acct_sname,
                         SUM (b.debit_amt) debit_amt, 
                         SUM (b.credit_amt) credit_amt,
                         SUM (b.debit_amt) - SUM (b.credit_amt) balance
                    FROM giac_acctrans a,
                         giac_acct_entries b,
                         giac_chart_of_accts c,
                         giis_line d,
                         giac_eom_rep e,
                         giac_eom_rep_dtl f
                   WHERE a.tran_id = b.gacc_tran_id
                     AND b.gl_acct_id = c.gl_acct_id
                     AND b.gl_acct_id = f.gl_acct_id
                     AND SUBSTR (LPAD (b.sl_cd, 6, '0'), 1, 2) =
                                                        d.acct_line_cd(+)
                     AND TRUNC (a.posting_date) BETWEEN TRUNC (p_from_date)
                                                    AND TRUNC (p_to_date)
                     AND tran_flag = 'P'
                     AND e.rep_cd = f.rep_cd
                     AND e.rep_cd = p_report
                GROUP BY a.gibr_branch_cd, d.line_name, c.gl_acct_sname)
      LOOP
         v_not_exist := FALSE;
         v_rec.branch_cd := i.gibr_branch_cd;
         v_rec.line_name := i.line_name;
         v_rec.gl_acct_sname := i.gl_acct_sname;
         v_rec.debit_amt := i.debit_amt;
         v_rec.credit_amt := i.credit_amt;
         v_rec.balance := i.balance;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;
END;
/


