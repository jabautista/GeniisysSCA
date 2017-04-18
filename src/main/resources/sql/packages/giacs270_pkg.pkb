CREATE OR REPLACE PACKAGE BODY CPI.giacs270_pkg
AS
   /*
   **  Created by        : Mikel Razon
   **  Date Created      : 06.05.2013
   **  Reference By      : GIACS270 - RI BILL PAYMENTS
   */
   FUNCTION get_gipi_invoice (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN gipi_invoice_tab PIPELINED
   AS
      v_rec   gipi_invoice_type;
   BEGIN
      FOR i IN
         (SELECT a.iss_cd bill_iss_cd, a.prem_seq_no, a.policy_id,
                 a.due_date, h.ri_cd, UPPER (h.ri_name) ri_name, c.assd_no,
                 UPPER (c.assd_name) assd_name, b.line_cd, b.subline_cd,
                 b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no,
                 b.endt_iss_cd, b.endt_yy, b.endt_seq_no, b.endt_type,
                 e.line_cd pack_line_cd, e.subline_cd pack_subline_cd,
                 e.iss_cd pack_iss_cd, e.issue_yy pack_issue_yy,
                 e.pol_seq_no pack_pol_seq_no, e.renew_no pack_renew_no,
                 e.endt_iss_cd pack_endt_iss_cd, e.endt_yy pack_endt_yy,
                 e.endt_seq_no pack_endt_seq_no, b.incept_date,
                 b.expiry_date, b.issue_date, b.pol_flag,
                 UPPER (a.property) property, a.payt_terms, a.currency_rt,
                 a.currency_cd, NVL (a.prem_amt, 0) prem_amt,
                 NVL (a.tax_amt, 0) tax_amt,
                 NVL (a.other_charges, 0) other_charges,
                 NVL (a.ri_comm_amt, 0) ri_comm_amt,
                 NVL (a.ri_comm_vat, 0) ri_comm_vat
            FROM gipi_invoice a,
                 gipi_polbasic b,
                 giis_assured c,
                 gipi_parlist d,
                 gipi_pack_polbasic e,
                 gipi_pack_invoice f,
                 giri_inpolbas g,
                 giis_reinsurer h
           WHERE 1 = 1
             AND a.policy_id = b.policy_id
             AND b.policy_id = g.policy_id
             AND g.ri_cd = h.ri_cd
             AND b.assd_no = c.assd_no
             AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
             AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
             AND b.assd_no = c.assd_no(+)
             AND c.assd_no = d.assd_no
             AND b.par_id = d.par_id
             AND b.pack_policy_id = e.pack_policy_id(+)
             AND b.pack_policy_id = f.policy_id(+)
             AND a.iss_cd =
                    DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                          a.iss_cd,
                                                          p_module_id,
                                                          NVL (p_user_id,
                                                               USER)
                                                         ),
                            1, a.iss_cd,
                            NULL
                           ))
      LOOP
         v_rec.bill_iss_cd := i.bill_iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.policy_id := i.policy_id;
         v_rec.due_date := i.due_date;
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.endt_type := i.endt_type;
         v_rec.pack_line_cd := i.pack_line_cd;
         v_rec.pack_subline_cd := i.pack_subline_cd;
         v_rec.pack_iss_cd := i.pack_iss_cd;
         v_rec.pack_issue_yy := i.pack_issue_yy;
         v_rec.pack_pol_seq_no := i.pack_pol_seq_no;
         v_rec.pack_renew_no := i.pack_renew_no;
         v_rec.pack_endt_iss_cd := i.pack_endt_iss_cd;
         v_rec.pack_endt_yy := i.pack_endt_yy;
         v_rec.pack_endt_seq_no := i.pack_endt_seq_no;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.issue_date := i.issue_date;
         v_rec.pol_flag := i.pol_flag;
         v_rec.property := i.property;
         v_rec.payt_terms := i.payt_terms;
         v_rec.currency_cd := i.currency_cd;
         v_rec.currency_rt := i.currency_rt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.tax_amt := i.tax_amt;
         v_rec.other_charges := i.other_charges;
         v_rec.comm_amt := i.ri_comm_amt;
         v_rec.comm_vat := i.ri_comm_vat;
         v_rec.due_date_char := TO_CHAR (v_rec.due_date, 'MM-DD-YYYY');
         v_rec.incept_date_char := TO_CHAR (v_rec.incept_date, 'MM-DD-YYYY');
         v_rec.expiry_date_char := TO_CHAR (v_rec.expiry_date, 'MM-DD-YYYY');
         v_rec.issue_date_char := TO_CHAR (v_rec.issue_date, 'MM-DD-YYYY');

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 30)
              INTO v_rec.policy_status
              FROM cg_ref_codes
             WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
               AND rv_low_value = i.pol_flag;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.policy_status := NULL;
         END;

         v_rec.local_prem := v_rec.prem_amt * i.currency_rt;
         v_rec.local_tax := v_rec.tax_amt * i.currency_rt;
         v_rec.local_charges := v_rec.other_charges * i.currency_rt;
         v_rec.local_comm := v_rec.comm_amt * i.currency_rt;
         v_rec.local_comm_vat := v_rec.comm_vat * i.currency_rt;
         v_rec.local_tot_amt_due :=
              (  NVL (v_rec.local_prem, 0)
               + NVL (v_rec.local_tax, 0)
               + NVL (v_rec.local_charges, 0)
              )
            - (v_rec.local_comm + v_rec.local_comm_vat);

         BEGIN
            SELECT currency_desc
              INTO v_rec.curr_desc
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.curr_desc := NULL;
         END;

         v_rec.foreign_prem := i.prem_amt;
         v_rec.foreign_tax := i.tax_amt;
         v_rec.foreign_charges := i.other_charges;
         v_rec.foreign_comm := i.ri_comm_amt;
         v_rec.foreign_comm_vat := i.ri_comm_vat;
         v_rec.foreign_tot_amt_due :=
              (v_rec.foreign_prem + v_rec.foreign_tax + v_rec.foreign_charges
              )
            - (v_rec.foreign_comm + v_rec.foreign_comm_vat);
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_inwfacul_prem_collns (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN giac_inwfacul_prem_collns_tab PIPELINED
   IS
      v_rec   giac_inwfacul_prem_collns_type;
   BEGIN
   
      BEGIN  -- Added by Jerome Bautista 06.07.2016 SR 22132
        FOR a IN (SELECT SUM(balance_due) balance_due
                    FROM giac_aging_ri_soa_details
                   WHERE prem_seq_no = p_prem_seq_no)
        LOOP
            v_rec.balance_due := NVL(v_rec.balance_due,0) + a.balance_due;
        END LOOP;
      END;

      FOR i IN (SELECT   a.b140_iss_cd iss_cd,
                         a.b140_prem_seq_no prem_seq_no,
                         b.gibr_branch_cd branch_cd, b.tran_class,
                         b.tran_class_no, b.jv_no, b.tran_year, b.tran_month,
                         b.tran_seq_no, b.tran_date,
                         get_ref_no (b.tran_id) ref_no, a.transaction_type,
                         SUM(a.collection_amt) collection_amt, c.short_name currency_desc,
                         a.currency_cd, a.convert_rate, SUM(a.foreign_curr_amt) foreign_curr_amt, --marks added fix by Sir Albert 8.10.16 sr22132
                         /*d.balance_due,*/ e.currency_rt -- balance_due commented out by Jerome Bautista 05.25.2016 SR 22132
                    FROM giac_inwfacul_prem_collns a,
                         giac_acctrans b,
                         giis_currency c,
                         --giac_aging_ri_soa_details d, -- Commented out by Jerome Bautista 05.25.2016 SR 22132
                         gipi_invoice e
                   WHERE 1 = 1
                     AND a.gacc_tran_id = b.tran_id
                     AND a.currency_cd = c.main_currency_cd
                     --AND a.b140_prem_seq_no = d.prem_seq_no -- Commented out by Jerome Bautista 05.25.2016 SR 22132
                     AND a.b140_iss_cd = e.iss_cd
                     AND a.b140_prem_seq_no = e.prem_seq_no
                     AND b.tran_flag != 'D'
                     AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_reversals x, giac_acctrans y
                             WHERE x.reversing_tran_id = y.tran_id
                               AND y.tran_flag != 'D'
                               AND x.gacc_tran_id = a.gacc_tran_id)
                     AND a.b140_prem_seq_no = p_prem_seq_no
                     AND a.b140_iss_cd = p_iss_cd
                     GROUP BY b.tran_seq_no,a.b140_iss_cd,
                                 a.b140_prem_seq_no,
                                 b.gibr_branch_cd, b.tran_class,
                                 b.tran_class_no, b.jv_no, b.tran_year, b.tran_month,
                                 b.tran_seq_no, b.tran_date,
                                 get_ref_no (b.tran_id), a.transaction_type,
                                 /*a.collection_amt,*/ c.short_name, --edited by MarkS sr22132 8.10.16
                                 a.currency_cd, a.convert_rate, /*a.foreign_curr_amt,*/ e.currency_rt --marks added fix by Sir Albert 8.10.16 sr22132
               ORDER BY b.tran_date)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.branch_cd := i.branch_cd;
         v_rec.tran_class := i.tran_class;
         v_rec.tran_class_no := i.tran_class_no;
         v_rec.jv_no := i.jv_no;
         v_rec.tran_year := i.tran_year;
         v_rec.tran_month := i.tran_month;
         v_rec.tran_seq_no := i.tran_seq_no;
         v_rec.tran_date := i.tran_date;
         v_rec.tran_date_char := TO_CHAR(i.tran_date, 'MM-DD-YYYY');
         v_rec.ref_no := i.ref_no;
         v_rec.transaction_type := i.transaction_type;
         v_rec.collection_amt := i.collection_amt;
         v_rec.currency_desc := i.currency_desc;
         v_rec.currency_cd := i.currency_cd;
         v_rec.convert_rate := i.convert_rate;
         v_rec.foreign_curr_amt := i.collection_amt / i.currency_rt;
         v_rec.total_colln_amt :=
                         NVL (v_rec.total_colln_amt, 0)
                        + v_rec.collection_amt;                
--         v_rec.balance_due := NVL(v_rec.balance_due,0) + i.balance_due; 
         v_rec.total_foreign_colln_amt :=
                                        v_rec.total_colln_amt / i.currency_rt;
         v_rec.foreign_balance_due := v_rec.balance_due / i.currency_rt;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_gipi_invoice_lov (
      p_prem_seq_no   VARCHAR2,
      p_ri_cd         VARCHAR2,
      p_assd_no       VARCHAR2,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date     VARCHAR2,
      p_issue_date      VARCHAR2,
      p_expiry_date     VARCHAR2
   )
      RETURN gipi_invoice_lov_tab PIPELINED
   IS
      v_rec           gipi_invoice_lov_type;
      v_ri_cd         NUMBER;
      v_assd_no       NUMBER;
      v_prem_seq_no   NUMBER;
   BEGIN
      IF p_prem_seq_no != '%'
      THEN
         v_prem_seq_no := TO_NUMBER (p_prem_seq_no);
      END IF;

      IF p_ri_cd != '%'
      THEN
         v_ri_cd := TO_NUMBER (p_ri_cd);
      END IF;

      IF p_assd_no != '%'
      THEN
         v_assd_no := TO_NUMBER (p_assd_no);
      END IF;

      FOR i IN (SELECT DISTINCT a.iss_cd,
                                LPAD (a.prem_seq_no, 12, '0') prem_seq_no
                           FROM gipi_invoice a,
                                gipi_polbasic b,
                                giri_inpolbas c,
                                giis_reinsurer d
                          WHERE 1 = 1
                            AND a.iss_cd = 'RI'
                            AND a.policy_id = b.policy_id
                            AND b.policy_id = c.policy_id
                            AND c.ri_cd = d.ri_cd
                            AND a.prem_seq_no LIKE NVL (v_prem_seq_no, a.prem_seq_no)
                            AND c.ri_cd = NVL (v_ri_cd, c.ri_cd)
                            AND b.assd_no = NVL (v_assd_no, b.assd_no)
                            AND b.line_cd LIKE NVL (p_line_cd, b.line_cd)
                            AND TRUNC(a.DUE_DATE) = NVL(TO_DATE(p_due_date, 'MM-DD-RRRR'), TRUNC(a.DUE_DATE))
                            AND TRUNC(b.INCEPT_DATE) = NVL(TO_DATE(p_incept_date, 'MM-DD-RRRR'), TRUNC(b.INCEPT_DATE))
                            AND TRUNC(b.ISSUE_DATE) = NVL(TO_DATE(p_issue_date, 'MM-DD-RRRR'), TRUNC(b.ISSUE_DATE))
                            AND TRUNC(b.EXPIRY_DATE) = NVL(TO_DATE(p_expiry_date, 'MM-DD-RRRR'), TRUNC(b.EXPIRY_DATE))
                       ORDER BY 2)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_reinsurer_lov (
      p_ri_cd     VARCHAR2,
      p_assd_no   VARCHAR2,
      p_line_cd   gipi_polbasic.line_cd%TYPE
   )
      RETURN giis_reinsurer_lov_tab PIPELINED
   IS
      v_rec       giis_reinsurer_lov_type;
      v_ri_cd     NUMBER;
      v_assd_no   NUMBER;
   BEGIN
      IF p_ri_cd != '%'
      THEN
         v_ri_cd := TO_NUMBER (p_ri_cd);
      END IF;

      IF p_assd_no != '%'
      THEN
         v_assd_no := TO_NUMBER (p_assd_no);
      END IF;

      FOR i IN (SELECT DISTINCT a.ri_cd, UPPER (a.ri_name) ri_name
                           FROM giis_reinsurer a,
                                gipi_polbasic b,
                                giri_inpolbas c
                          WHERE 1 = 1
                            AND a.ri_cd = c.ri_cd
                            AND b.policy_id = c.policy_id
                            AND a.ri_cd LIKE NVL (v_ri_cd, a.ri_cd)
                            AND b.assd_no LIKE NVL (v_assd_no, b.assd_no)
                            AND b.line_cd LIKE NVL (p_line_cd, b.line_cd)
                       ORDER BY 2)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giis_assured_lov2 (
      p_assd_no   VARCHAR2,
      p_ri_cd     VARCHAR2,
      p_line_cd   gipi_polbasic.line_cd%TYPE
   )
      RETURN giis_assured_lov_tab PIPELINED
   IS
      v_rec       giis_assured_lov_type;
      v_ri_cd     NUMBER;
      v_assd_no   NUMBER;
   BEGIN
      IF p_ri_cd != '%'
      THEN
         v_ri_cd := TO_NUMBER (p_ri_cd);
      END IF;

      IF p_assd_no != '%'
      THEN
         v_assd_no := TO_NUMBER (p_assd_no);
      END IF;

      FOR i IN (SELECT DISTINCT a.assd_no, UPPER (a.assd_name) assd_name
                           FROM giis_assured a,
                                gipi_polbasic b,
                                giri_inpolbas c
                          WHERE 1 = 1
                            AND a.assd_no >= 0
                            AND a.assd_no = b.assd_no
                            AND b.policy_id = c.policy_id
                            AND a.assd_no = NVL (v_assd_no, a.assd_no)
                            AND b.line_cd LIKE NVL (p_line_cd, b.line_cd)
                            AND c.ri_cd LIKE NVL (v_ri_cd, c.ri_cd)
                       ORDER BY 2)
      LOOP
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_policy_no_lov (
      p_prem_seq_no   VARCHAR2,
      p_ri_cd         VARCHAR2,
      p_assd_no       VARCHAR2,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      VARCHAR2,
      p_pol_seq_no    VARCHAR2,
      p_renew_no      VARCHAR2
   )
      RETURN gipi_polbasic_lov_tab PIPELINED
   IS
      v_rec           gipi_polbasic_lov_type;
      v_ri_cd         NUMBER;
      v_assd_no       NUMBER;
      v_prem_seq_no   NUMBER;
      v_issue_yy      NUMBER;
      v_pol_seq_no    NUMBER;
      v_renew_no      NUMBER;
   BEGIN
      IF p_prem_seq_no != '%'
      THEN
         v_prem_seq_no := TO_NUMBER (p_prem_seq_no);
      END IF;

      IF p_ri_cd != '%'
      THEN
         v_ri_cd := TO_NUMBER (p_ri_cd);
      END IF;

      IF p_assd_no != '%'
      THEN
         v_assd_no := TO_NUMBER (p_assd_no);
      END IF;

      IF p_issue_yy != '%'
      THEN
         v_issue_yy := TO_NUMBER (p_issue_yy);
      END IF;

      IF p_pol_seq_no != '%'
      THEN
         v_pol_seq_no := TO_NUMBER (p_pol_seq_no);
      END IF;

      IF p_renew_no != '%'
      THEN
         v_renew_no := TO_NUMBER (p_renew_no);
      END IF;

      FOR i IN (SELECT DISTINCT get_policy_no (a.policy_id) policy_no,
                                b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
                                b.pol_seq_no, b.renew_no, b.endt_iss_cd,
                                b.endt_yy, b.endt_seq_no, b.endt_type,
                                a.prem_seq_no, a.iss_cd||'-'||LPAD(a.prem_seq_no, 12, '0') bill_no
                           FROM gipi_invoice a,
                                gipi_polbasic b,
                                giri_inpolbas c,
                                giis_reinsurer d
                          WHERE 1 = 1
                            AND a.iss_cd = 'RI'
                            AND a.policy_id = b.policy_id
                            AND b.policy_id = c.policy_id
                            AND c.ri_cd = d.ri_cd
                            AND a.prem_seq_no LIKE
                                            NVL (v_prem_seq_no, a.prem_seq_no)
                            AND c.ri_cd LIKE NVL (v_ri_cd, c.ri_cd)
                            AND b.assd_no = NVL (v_assd_no, b.assd_no)
                            AND b.line_cd LIKE NVL (p_line_cd, b.line_cd)
                            AND b.subline_cd LIKE
                                              NVL (p_subline_cd, b.subline_cd)
                            AND b.issue_yy LIKE NVL (p_issue_yy, b.issue_yy)
                            AND LPAD(b.pol_seq_no,7,'0') LIKE
                                              NVL (p_pol_seq_no, b.pol_seq_no)
                            AND LPAD(b.renew_no,2,'0') LIKE NVL (p_renew_no, b.renew_no)
                       ORDER BY b.line_cd,
                                b.subline_cd,
                                b.iss_cd,
                                b.issue_yy,
                                b.pol_seq_no,
                                b.renew_no,
                                b.endt_seq_no,
                                a.prem_seq_no)
      LOOP
         v_rec.policy_no := i.policy_no;
         v_rec.bill_no := i.bill_no;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.endt_type := i.endt_type;
         v_rec.prem_seq_no := i.prem_seq_no;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


