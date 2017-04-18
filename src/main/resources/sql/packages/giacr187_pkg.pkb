CREATE OR REPLACE PACKAGE BODY CPI.giacr187_pkg
AS
   FUNCTION get_giacr187_details (
      p_ri_cd          giac_due_from_ext.ri_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_cut_off_date   DATE
   )
      RETURN giacr187_tab PIPELINED
   IS
      v_rec         giacr187_type;
      v_not_exist   BOOLEAN       := TRUE;
   BEGIN
      v_rec.cf_company := giacp.v ('COMPANY_NAME');
      v_rec.cf_company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.cf_from_date := TO_CHAR (p_from_date, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_to_date, 'FMMonth DD, YYYY');
      v_rec.cf_cut_off_date := TO_CHAR (p_cut_off_date, 'FMMonth DD, YYYY');

      FOR i IN (SELECT   a.ri_sname, c.line_name, a.policy_no, b.incept_date,
                         b.ref_pol_no,
                         a.iss_cd || '-' || a.prem_seq_no invoice_no,
                         a.inst_no, d.ri_policy_no, d.ri_binder_no,
                         a.amt_insured, a.gross_prem_amt, a.ri_comm_exp,
                         (  (a.gross_prem_amt + a.prem_vat)
                          - (a.ri_comm_exp + a.comm_vat)
                         ) net_premium,
                         a.prem_vat, a.comm_vat
                    FROM giac_due_from_ext a,
                         gipi_polbasic b,
                         giis_line c,
                         giri_inpolbas d
                   WHERE a.policy_id = b.policy_id
                     AND b.line_cd = c.line_cd
                     AND a.policy_id = d.policy_id
                     AND a.from_date = p_from_date
                     AND a.TO_DATE = p_to_date
                     AND a.cut_off_date = p_cut_off_date
                ORDER BY a.ri_sname,
                         c.line_name,
                         b.incept_date,
                         a.iss_cd,
                         a.prem_seq_no)
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_sname := i.ri_sname;
         v_rec.line_name := i.line_name;
         v_rec.policy_no := i.policy_no;
         v_rec.incept_date := i.incept_date;
         v_rec.ref_pol_no := i.ref_pol_no;
         v_rec.invoice_no := i.invoice_no;
         v_rec.inst_no := i.inst_no;
         v_rec.ri_policy_no := i.ri_policy_no;
         v_rec.ri_binder_no := i.ri_binder_no;
         v_rec.amt_insured := i.amt_insured;
         v_rec.gross_prem_amt := i.gross_prem_amt;
         v_rec.ri_comm_exp := i.ri_comm_exp;
         v_rec.net_premium := i.net_premium;
         v_rec.prem_vat := i.prem_vat;
         v_rec.comm_vat := i.comm_vat;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;

      RETURN;
   END;
END;
/


