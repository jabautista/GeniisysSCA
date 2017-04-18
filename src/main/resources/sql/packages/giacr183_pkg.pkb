CREATE OR REPLACE PACKAGE BODY CPI.giacr183_pkg
AS
   FUNCTION get_giacr183_details (
      p_ri_cd          giac_due_from_ext.ri_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_cut_off_date   DATE
   )
      RETURN giacr183_tab PIPELINED
   IS
      v_rec         giacr183_type;
      v_not_exist   BOOLEAN       := TRUE;
   BEGIN
      v_rec.cf_company := giacp.v ('COMPANY_NAME');
      v_rec.cf_company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.cf_from_date := TO_CHAR (p_from_date, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_to_date, 'FMMonth DD, YYYY');
      v_rec.cf_cut_off_date := TO_CHAR (p_cut_off_date, 'FMMonth DD, YYYY');
      v_rec.run_time  := TO_CHAR(SYSDATE,'HH12:MI:SS AM'); -- dren 06.17.2015 SR 0003851: Modify runtime to display properly in Excel

      FOR i IN (SELECT   d.ri_name, d.ri_cd,
                         SUM ((  (a.gross_prem_amt + a.prem_vat)
                               - (a.ri_comm_exp + a.comm_vat)
                              )
                             ) net_amount,
                         c.line_name
                    FROM giac_due_from_ext a,
                         gipi_polbasic b,
                         giis_line c,
                         giis_reinsurer d
                   WHERE a.policy_id = b.policy_id
                     AND b.line_cd = c.line_cd
                     AND a.ri_cd = d.ri_cd
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.from_date = p_from_date
                     AND a.TO_DATE = p_to_date
                     AND a.cut_off_date = p_cut_off_date
                GROUP BY c.line_name, d.ri_name, d.ri_cd)
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.net_amount := i.net_amount;
         v_rec.line_name := i.line_name;

         FOR j IN (SELECT SUM ((  (a.gross_prem_amt + a.prem_vat)
                                - (a.ri_comm_exp + a.comm_vat)
                               )
                              ) net_amount
                     FROM giac_due_from_ext a,
                          gipi_polbasic b,
                          giis_line c,
                          giis_reinsurer d
                    WHERE a.policy_id = b.policy_id
                      AND b.line_cd = c.line_cd
                      AND a.ri_cd = d.ri_cd
                      AND a.ri_cd = i.ri_cd
                      AND a.from_date = p_from_date
                      AND a.TO_DATE = p_to_date
                      AND a.cut_off_date = p_cut_off_date)
         LOOP
            v_rec.total_net_amount_per_line := j.net_amount;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;

      RETURN;
   END;

   FUNCTION get_giacr183_summary (
      p_ri_cd          giac_due_from_ext.ri_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_cut_off_date   DATE
   )
      RETURN giacr183_tab PIPELINED
   IS
      v_rec   giacr183_type;
   BEGIN
      FOR i IN (SELECT   SUM ((  (a.gross_prem_amt + a.prem_vat)
                               - (a.ri_comm_exp + a.comm_vat)
                              )
                             ) net_amount,
                         c.line_name
                    FROM giac_due_from_ext a,
                         gipi_polbasic b,
                         giis_line c,
                         giis_reinsurer d
                   WHERE a.policy_id = b.policy_id
                     AND b.line_cd = c.line_cd
                     AND a.ri_cd = d.ri_cd
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.from_date = p_from_date
                     AND a.TO_DATE = p_to_date
                     AND a.cut_off_date = p_cut_off_date
                GROUP BY c.line_name)
      LOOP
         v_rec.net_amount := i.net_amount;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
END;
/


