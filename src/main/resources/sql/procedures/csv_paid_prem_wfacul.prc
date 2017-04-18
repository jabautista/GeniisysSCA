DROP PROCEDURE CPI.CSV_PAID_PREM_WFACUL;

CREATE OR REPLACE PROCEDURE CPI.csv_paid_prem_wfacul (
   p_from_date       IN   DATE,
   p_to_date         IN   DATE,
   p_branch_cd       IN   VARCHAR2,
   p_line_cd         IN   VARCHAR2,
   p_cut_off_param   IN   NUMBER,
   p_bop                  NUMBER
)
IS
   f   UTL_FILE.file_type;
BEGIN
   --f := UTL_FILE.fopen ('CSV_PATH', 'CSV_PAID_PREM_WFACUL.csv', 'W');
   -- vin 6.17.2010 replaced the filename to GIACR299.csv plus USERNAME to avoid overlapping/overwriting the csv file
   -- in case there are more than one user trying to generate a csv file at the same time
   f := UTL_FILE.fopen ('CSV_PATH', 'GIACR299_' || USER || '.csv', 'W');
   UTL_FILE.put_line (f,'Branch'||','||'Line'||','||'Policy No.'||','||'Binder No'||','||'Reinsurer'||','||'Payment Reference No.'||','||'Payment Date');

   FOR c IN (SELECT get_policy_no (d.policy_id) policy_no,
                    b.line_cd || '-' || binder_yy || '-' || binder_seq_no binder_no,
                    get_ri_name (b.ri_cd) reinsurer, c.ref_no, c.tran_date, e.iss_name,
                    f.line_name
               FROM gipi_invoice a,
                    giri_frps_outfacul_prem_v b,
                    giac_premium_colln_v c,
                    gipi_polbasic d,
                    giis_issource e,
                    giis_line f
              WHERE a.policy_id = b.policy_id
                AND a.policy_id = d.policy_id
                AND a.iss_cd = c.iss_cd
                AND a.iss_cd = e.iss_cd
                AND b.line_cd = f.line_cd
                AND a.prem_seq_no = c.prem_seq_no
                AND b.line_cd = NVL (p_line_cd, d.line_cd)
                AND DECODE (p_bop, 1, b.cred_branch, b.iss_cd) = NVL (p_branch_cd, d.iss_cd)
                AND DECODE (p_cut_off_param, 1, c.tran_date, c.posting_date)
                    BETWEEN p_from_date AND p_to_date
                AND b.balance > 0)
   LOOP

      --UTL_FILE.put_line (f,c.iss_name||','||c.line_name||','||c.policy_no||','||c.binder_no||','||c.reinsurer ||','||c.ref_no||','||c.tran_date);
      --added REPLACE function for field reinsurer to handle commas vin 6.16.2010
      UTL_FILE.put_line (f,c.iss_name||','||c.line_name||','||c.policy_no||','||c.binder_no||','|| REPLACE(c.reinsurer,',',' ') ||','||c.ref_no||','||c.tran_date);

   END LOOP;

   UTL_FILE.fclose (f);
END;
/


