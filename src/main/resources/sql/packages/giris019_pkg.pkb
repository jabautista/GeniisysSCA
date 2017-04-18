CREATE OR REPLACE PACKAGE BODY CPI.giris019_pkg
AS
   /*
   ** Created by: Steven
   ** Date Created: 10.21.2013
   ** Reference:   GIRIS019 - Inward RI/Outstanding Broker Accounts
   ** Description:
   */
   FUNCTION get_giis_reinsurer
      RETURN giis_ri_tab PIPELINED
   IS
      v_rec   giis_ri_type;
   BEGIN
      FOR i IN (SELECT ri_cd, ri_sname, ri_name
                  FROM giis_reinsurer)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.ri_sname := i.ri_sname;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_binder_list (
      p_ri_cd     giri_polbasic_inwfacul_v.ri_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN inward_ri_tab PIPELINED
   IS
      v_rec   inward_ri_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giri_polbasic_inwfacul_v
                 WHERE check_user_per_iss_cd2 (line_cd,
                                               iss_cd,
                                               'GIRIS019',
                                               p_user_id
                                              ) = 1
                   AND ri_cd = p_ri_cd)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.policy_id := i.policy_id;
         v_rec.line_cd := i.line_cd;
         v_rec.b250_iss_cd := i.b250_iss_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         v_rec.ri_sname := i.ri_sname;
         v_rec.accept_no := i.accept_no;
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.due_date := i.due_date;
         v_rec.dsp_due_date := TO_CHAR (i.due_date, 'MM-DD-YYYY');
         v_rec.prem_amt := i.prem_amt;
         v_rec.tax_amt := i.tax_amt;
         v_rec.ri_comm_amt := i.ri_comm_amt;
         v_rec.ri_comm_vat := i.ri_comm_vat;
         v_rec.currency_rt := i.currency_rt;
         v_rec.ri_policy_no := i.ri_policy_no;
         v_rec.ri_endt_no := i.ri_endt_no;
         v_rec.ri_binder_no := i.ri_binder_no;
         v_rec.eff_date := i.eff_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.dsp_eff_date := TO_CHAR (i.eff_date, 'MM-DD-YYYY');
         v_rec.dsp_expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_rec.currency_cd := i.currency_cd;
         v_rec.currency_desc := i.currency_desc;
         v_rec.total_amt := i.total_amt;
         v_rec.net_due := i.net_due;
         v_rec.total_amt_paid := i.total_amt_paid;
         v_rec.balance := i.balance;
         v_rec.drv_iss_cd :=
                 i.iss_cd || ' -' || TO_CHAR (i.prem_seq_no, '000000000009');

         IF v_rec.endt_seq_no != 0
         THEN
            v_rec.dsp_endt_iss_cd := v_rec.endt_iss_cd;
            v_rec.dsp_endt_yy := v_rec.endt_yy;
            v_rec.dsp_endt_seq_no := v_rec.endt_seq_no;
            v_rec.endt_no :=
                  v_rec.dsp_endt_iss_cd
               || '-'
               || LTRIM (TO_CHAR (v_rec.dsp_endt_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.dsp_endt_seq_no, '099999'));
         ELSE
            v_rec.dsp_endt_iss_cd := NULL;
            v_rec.dsp_endt_yy := NULL;
            v_rec.dsp_endt_seq_no := NULL;
            v_rec.endt_no := NULL;
         END IF;

         v_rec.policy_no :=
               v_rec.line_cd
            || '-'
            || v_rec.subline_cd
            || '-'
            || v_rec.iss_cd
            || '-'
            || LTRIM (TO_CHAR (v_rec.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (v_rec.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (v_rec.renew_no, '09'));
         PIPE ROW (v_rec);
      END LOOP;
   END get_binder_list;
END giris019_pkg;
/


