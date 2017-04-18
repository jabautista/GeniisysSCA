CREATE OR REPLACE PACKAGE BODY CPI.GIACB004S_PKG
AS
   FUNCTION populate_giacb004s_main (
      p_date      DATE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN giacb004s_tab_main PIPELINED
   AS
      v_rec    giacb004s_type_main;
      v_flag   BOOLEAN             := FALSE;
   BEGIN
      v_rec.company_name := giacp.v ('COMPANY_NAME');
      v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.v_flag := 'N';

      FOR a IN (SELECT   a.line_cd, a.subline_cd, c.peril_cd,
                         NVL (b.prem_amt, 0) prem_invoice,
                         NVL (b.ri_comm_amt, 0) comm_invoice,
                         NVL (b.tax_amt, 0) tax_amt,
                         NVL (b.ri_comm_vat, 0) ri_comm_vat,
                         NVL (b.currency_rt, 0) currency_rt,
                         SUM (DECODE (TO_CHAR (p_date, 'MM-YYYY'),
                                      TO_CHAR (a.acct_ent_date, 'MM-YYYY'), c.prem_amt
                                       * b.currency_rt,
                                      c.prem_amt * b.currency_rt * -1
                                     )
                             ) prem_amt,
                         SUM (DECODE (TO_CHAR (p_date, 'MM-YYYY'),
                                      TO_CHAR (a.acct_ent_date, 'MM-YYYY'), c.tsi_amt
                                       * b.currency_rt,
                                      c.tsi_amt * b.currency_rt * -1
                                     )
                             ) tsi_amt,
                         SUM (DECODE (TO_CHAR (p_date, 'MM-YYYY'),
                                      TO_CHAR (a.acct_ent_date, 'MM-YYYY'), c.ri_comm_amt
                                       * b.currency_rt,
                                      c.ri_comm_amt * b.currency_rt * -1
                                     )
                             ) ri_comm_amt,
                         DECODE (e.peril_type,
                                 'B', e.peril_name || '  *',
                                 e.peril_name
                                ) peril_name,
                         f.subline_name, g.line_name
                    FROM gipi_polbasic a,
                         gipi_invoice b,
                         gipi_invperil c,
                         giri_inpolbas d,
                         giis_peril e,
                         giis_subline f,
                         giis_line g
                   WHERE 1 = 1
                     AND a.policy_id = b.policy_id
                     AND e.line_cd = a.line_cd
                     AND e.peril_cd = c.peril_cd
                     AND a.policy_id = d.policy_id
                     AND b.iss_cd = c.iss_cd
                     AND b.prem_seq_no = c.prem_seq_no
                     AND f.subline_cd = a.subline_cd
                     AND g.line_cd = f.line_cd
                     AND g.line_cd = a.line_cd
                     AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                                   TO_CHAR (p_date, 'MM-YYYY')
                          OR TO_CHAR (a.spld_acct_ent_date, 'MM-YYYY') =
                                                   TO_CHAR (p_date, 'MM-YYYY')
                         )
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       b.iss_cd,
                                                       'GIARPR001',
                                                       p_user_id
                                                      ) = 1
                GROUP BY a.line_cd,
                         a.subline_cd,
                         c.peril_cd,
                         b.prem_amt,
                         b.ri_comm_amt,
                         b.tax_amt,
                         b.ri_comm_vat,
                         b.currency_rt,
                         e.peril_type,
                         e.peril_name,
                         f.subline_name,
                         g.line_name
                ORDER BY a.line_cd, a.subline_cd, c.peril_cd)
      LOOP
         v_flag := TRUE;
         v_rec.v_flag := 'Y';
         v_rec.line_cd := a.line_cd;
         v_rec.subline_cd := a.subline_cd;
         v_rec.peril_cd := a.peril_cd;
         v_rec.prem_invoice := a.prem_invoice;
         v_rec.comm_invoice := a.comm_invoice;
         v_rec.tax_amt := a.tax_amt;
         v_rec.ri_comm_vat := a.ri_comm_vat;
         v_rec.currency_rt := a.currency_rt;
         v_rec.prem_amt := a.prem_amt;
         v_rec.tsi_amt := a.tsi_amt;
         v_rec.ri_comm_amt := a.ri_comm_amt;
         v_rec.peril_name := a.peril_name;
         v_rec.prem_vat :=
            giacb004s_pkg.get_prem_vat (a.prem_invoice,
                                        a.prem_amt,
                                        a.tax_amt,
                                        a.currency_rt
                                       );
         v_rec.comm_vat :=
            giacb004s_pkg.get_comm_vat (a.ri_comm_amt, 
                                        a.comm_invoice,
                                        a.currency_rt,
                                        a.ri_comm_vat
                                       );
         v_rec.subline_name := a.subline_name;
         v_rec.line_name := a.line_name;
         v_rec.tsi_basic_amt :=
            giacb004s_pkg.get_tsi_basic (p_date,
                                         a.line_cd,
                                         a.subline_cd,
                                         a.peril_cd
                                        );
                                        
         PIPE ROW (v_rec);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_rec);
      END IF;
   END populate_giacb004s_main;

   FUNCTION populate_giacb004s_sub (
      p_date      DATE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN giacb004s_tab_sub PIPELINED
   AS
      v_rec    giacb004s_type_sub;
      v_flag   BOOLEAN            := FALSE;
   BEGIN
      v_rec.company_name := giacp.v ('COMPANY_NAME');
      v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.v_flag := 'N';

      FOR a IN (SELECT      LTRIM (TO_CHAR (b.gl_acct_category))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09'))
                                                                "GL_ACCT_NO",
                         b.gl_acct_name "ACCT_NAME", SUM (a.debit_amt) debit,
                         SUM (a.credit_amt) credit
                    FROM giac_acctrans c,
                         giac_chart_of_accts b,
                         giac_acct_entries a
                   WHERE c.tran_id = a.gacc_tran_id
                     AND b.gl_acct_id = a.gl_acct_id
                     AND c.tran_class = 'INF'
                     AND c.tran_flag != 'D'
                     AND c.tran_month = TO_NUMBER (TO_CHAR (p_date, 'MM'))
                     AND c.tran_year = TO_NUMBER (TO_CHAR (p_date, 'YYYY'))
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       c.gibr_branch_cd,
                                                       'GIARPR001',
                                                       p_user_id
                                                      ) = 1
                GROUP BY b.gl_acct_name,
                            LTRIM (TO_CHAR (b.gl_acct_category))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09')))
      LOOP
         v_flag := TRUE;
         v_rec.v_flag := 'Y';
         v_rec.gl_acct_no := a.gl_acct_no;
         v_rec.acct_name := a.acct_name;
         v_rec.debit := a.debit;
         v_rec.credit := a.credit;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_rec);
      END IF;
   END populate_giacb004s_sub;

   FUNCTION get_prem_vat (
      p_prem_invoice   gipi_invoice.prem_amt%TYPE,
      p_prem_amt       gipi_invperil.prem_amt%TYPE,
      p_tax_amt        gipi_invoice.tax_amt%TYPE,
      p_currency_rt    gipi_invoice.currency_rt%TYPE
   )
      RETURN NUMBER
   IS
      v_prem_vat    NUMBER (16, 3);
      v_prem_vat1   NUMBER (16, 3);
      v_prem_vat2   NUMBER (16, 2);
      v_prem_inv    NUMBER (16, 2);
   BEGIN
      v_prem_inv := p_prem_invoice;

      IF v_prem_inv = 0
      THEN
         v_prem_inv := 1;
      END IF;

      v_prem_vat := p_prem_amt / v_prem_inv;
      v_prem_vat1 := v_prem_vat * p_tax_amt;
      v_prem_vat2 := v_prem_vat1 * p_currency_rt;
      RETURN (v_prem_vat2);
   END get_prem_vat;

   FUNCTION get_comm_vat (
      p_ri_comm_amt    gipi_invoice.prem_amt%TYPE,
      p_comm_invoice   gipi_invoice.ri_comm_amt%TYPE,
      p_currency_rt    gipi_invoice.currency_rt%TYPE,
      p_ri_comm_vat    gipi_invoice.ri_comm_vat%TYPE
   )
      RETURN NUMBER
   IS
      v_comm_vat2   NUMBER;
   BEGIN
      IF p_comm_invoice <> 0
      THEN
         v_comm_vat2 :=
              p_ri_comm_amt
            / (p_comm_invoice * p_currency_rt)
            * p_ri_comm_vat
            * p_currency_rt;
      ELSE
         v_comm_vat2 := 0;
      END IF;

      RETURN (v_comm_vat2);
   END get_comm_vat;

   FUNCTION get_tsi_basic (
      p_date         DATE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_peril_cd     giis_peril.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_tsi_amt   NUMBER (16, 3);
      v_cnt       NUMBER;
   BEGIN
      v_cnt := 0;
      v_tsi_amt := 0;

      FOR i IN (SELECT     SUM (DECODE (TO_CHAR (p_date, 'MM-YYYY'),
                                        TO_CHAR (a.acct_ent_date, 'MM-YYYY'), c.tsi_amt
                                         * d.currency_rt,
                                        c.tsi_amt * d.currency_rt * -1
                                       )
                               )
                         / 10 tsi_amt
                    FROM gipi_polbasic a,
                         giri_inpolbas b,
                         gipi_itmperil c,
                         gipi_item d,
                         giis_peril e
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = c.policy_id
                     AND c.policy_id = d.policy_id
                     AND c.item_no = d.item_no
                     AND c.line_cd = e.line_cd
                     AND e.line_cd = a.line_cd
                     AND c.peril_cd = e.peril_cd
                     AND e.peril_type = 'B'
                     AND c.peril_cd = p_peril_cd
                     AND e.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                                   TO_CHAR (p_date, 'MM-YYYY')
                          OR TO_CHAR (a.spld_acct_ent_date, 'MM-YYYY') =
                                                   TO_CHAR (p_date, 'MM-YYYY')
                         )
                GROUP BY a.line_cd, a.subline_cd, c.peril_cd)
      LOOP
         v_tsi_amt := i.tsi_amt;
      END LOOP;

      RETURN (v_tsi_amt);
   END;
END GIACB004S_PKG;
/


