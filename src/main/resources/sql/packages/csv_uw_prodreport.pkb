CREATE OR REPLACE PACKAGE BODY cpi.csv_uw_prodreport 
AS
   /* ===============================================================================================================
   * Created by:     Apollo Cruz
   * Date Created:   05.27.2015
   * Purpose:        UW-SPECS-2015-056-CSV FOR UW Production Report
   *                 AFPGEN-IMPLEM-SR 4564
   *                 Breakdown of csv_undrwrtng package. Package will hold all underwriting production report CSVs.
   * ============================================================================================================== */
   FUNCTION get_gipir930 (p_iss_cd        VARCHAR2,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_scope         VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       VARCHAR2)
      RETURN gipir930_tab
      PIPELINED
   IS
      v_gipir930     gipir930_type;
      v_iss_name     VARCHAR2 (50);
      v_total_si     gipi_uwreports_ri_ext.total_si%TYPE := 0;
      v_total_prem   gipi_uwreports_ri_ext.total_prem%TYPE := 0;
   BEGIN
      FOR rec
         IN (  SELECT DECODE (p_iss_param,
                              1, NVL (cred_branch, iss_cd),
                              iss_cd)
                         iss_cd,
                      line_cd,
                      INITCAP (line_name) line_name,
                      subline_cd,
                      INITCAP (subline_name) subline_name,
                      policy_no,
                      assd_name,
                      incept_date,
                      expiry_date,
                      frps_line_cd,
                      frps_seq_no,
                      frps_yy,
                      total_si,
                      total_prem,
                      binder_no,
                      ri_short_name,
                      ri_cd,
                      SUM (NVL (sum_reinsured, 0)) sum_reinsured,
                      SUM (NVL (share_premium, 0)) share_premium,
                      SUM (NVL (ri_comm_amt, 0)) ri_comm_amt,
                      SUM (NVL (net_due, 0)) net_due,
                      SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
                      SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
                      SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat,
                      SUM (NVL (ri_premium_tax, 0)) ri_premium_tax
                 FROM gipi_uwreports_ri_ext
                WHERE     user_id = p_user_id
                      AND DECODE (p_iss_param,
                                  1, NVL (cred_branch, iss_cd),
                                  iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (cred_branch, iss_cd),
                                        iss_cd))
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             GROUP BY DECODE (p_iss_param,
                              1, NVL (cred_branch, iss_cd),
                              iss_cd),
                      line_cd,
                      INITCAP (line_name),
                      subline_cd,
                      INITCAP (subline_name),
                      policy_no,
                      assd_name,
                      incept_date,
                      expiry_date,
                      frps_line_cd,
                      frps_seq_no,
                      frps_yy,
                      total_si,
                      total_prem,
                      binder_no,
                      ri_short_name,
                      ri_cd
             ORDER BY iss_cd,
                      line_cd,
                      subline_cd,
                      policy_no,
                      frps_line_cd,
                      frps_seq_no,
                      frps_yy,
                      binder_no)
      LOOP
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir930.iss_name := v_iss_name;
         v_gipir930.line := rec.line_cd || ' - ' || rec.line_name;
         v_gipir930.subline := rec.subline_cd || ' - ' || rec.subline_name;
         v_gipir930.policy_no := rec.policy_no;
         v_gipir930.assured := rec.assd_name;
         v_gipir930.incept_date := rec.incept_date;
         v_gipir930.expiry_date := rec.expiry_date;
         v_gipir930.total_si := rec.total_si;
         v_gipir930.tot_premium := rec.total_prem;
         v_gipir930.binder_no := rec.binder_no;
         v_gipir930.ri_short_name := rec.ri_short_name;
         v_gipir930.sum_reinsured := rec.sum_reinsured;
         v_gipir930.share_prem := rec.share_premium;
         v_gipir930.share_prem_vat := rec.ri_prem_vat;
         v_gipir930.ri_comm := rec.ri_comm_amt;
         v_gipir930.comm_vat := rec.ri_comm_vat;
         v_gipir930.wholding_vat := rec.ri_wholding_vat;
         v_gipir930.net_due := rec.net_due;
         PIPE ROW (v_gipir930);
      END LOOP;
   END get_gipir930;

   FUNCTION get_gipir930a (p_iss_cd        VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_scope         VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       VARCHAR2)
      RETURN gipir930a_tab
      PIPELINED
   IS
      v              gipir930a_type;
      v_iss_name     VARCHAR2 (50);
      v_total_si     gipi_uwreports_ri_ext.total_si%TYPE := 0;
      v_total_prem   gipi_uwreports_ri_ext.total_prem%TYPE := 0;
      v_reinsured    gipi_uwreports_ri_ext.sum_reinsured%TYPE := 0;
      v_param_v      VARCHAR2 (1);
      v_total        NUMBER (38, 2);
   BEGIN
      FOR i
         IN (  SELECT line_cd,
                      subline_cd,
                      iss_cd,
                      line_name,
                      subline_name,
                      SUM (total_si) total_si,
                      SUM (total_prem) total_prem,
                      SUM (sum_reinsured) sum_reinsured,
                      SUM (share_premium) share_premium,
                      SUM (ri_comm_amt) ri_comm_amt,
                      SUM (net_due) net_due,
                      SUM (binder_count) binder_count,
                      SUM (ri_prem_vat) ri_prem_vat,
                      SUM (ri_comm_vat) ri_comm_vat,
                      SUM (ri_wholding_vat) ri_wholding_vat,
                      SUM (ri_premium_tax) ri_premium_tax
                 FROM (  SELECT line_cd,
                                subline_cd,
--                                DECODE (p_iss_param, -- Commented out and replaced by Jerome 10.14.2016 SR 5650
--                                        1, NVL (cred_branch, iss_cd),
--                                        iss_cd),
--                                   iss_cd,
                                NVL(cred_branch,iss_cd) iss_cd,
                                INITCAP (line_name) line_name,
                                INITCAP (subline_name) subline_name,
                                NVL (total_si, 0) total_si,
                                NVL (total_prem, 0) total_prem,
                                SUM (NVL (sum_reinsured, 0)) sum_reinsured,
                                SUM (NVL (share_premium, 0)) share_premium,
                                SUM (NVL (ri_comm_amt, 0)) ri_comm_amt,
                                SUM (NVL (net_due, 0)) net_due,
                                COUNT (DISTINCT binder_no) binder_count,
                                SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
                                SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
                                SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat,
                                SUM (NVL (ri_premium_tax, 0)) ri_premium_tax
                           FROM gipi_uwreports_ri_ext
                          WHERE     user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, NVL (cred_branch, iss_cd),
                                            iss_cd) =
                                       NVL (
                                          p_iss_cd,
                                          DECODE (p_iss_param,
                                                  1, NVL (cred_branch, iss_cd),
                                                  iss_cd))
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd = NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 3
                                         AND endt_seq_no = endt_seq_no)
                                     OR (p_scope = 1 AND endt_seq_no = 0)
                                     OR (p_scope = 2 AND endt_seq_no > 0))
                       GROUP BY line_cd,
                                subline_cd,
--                                DECODE (p_iss_param, -- Commented out and replaced by Jerome 10.14.2016 SR 5650
--                                        1, NVL (cred_branch, iss_cd),
--                                        iss_cd),
                                NVL(cred_branch,iss_cd),
                                line_name,
                                subline_name,
                                frps_line_cd,
                                frps_yy,
                                frps_seq_no,
                                NVL (total_si, 0),
                                NVL (total_prem, 0))
             GROUP BY line_cd,
                      subline_cd,
                      iss_cd,
                      line_name,
                      subline_name
             ORDER BY iss_cd)
      LOOP
         BEGIN
         IF p_iss_param = 1 THEN --Added by Jerome 10.14.2016 SR 5650
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;

            v_iss_name := i.iss_cd || ' - ' || v_iss_name;
         ELSE
            FOR a IN (SELECT iss_cd
                           FROM gipi_uwreports_ri_ext
                          WHERE     user_id = p_user_id
                                AND DECODE (p_iss_param,
                                            1, NVL (cred_branch, iss_cd),
                                            iss_cd) =
                                       NVL (
                                          p_iss_cd,
                                          DECODE (p_iss_param,
                                                  1, NVL (cred_branch, iss_cd),
                                                  iss_cd))
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND subline_cd = NVL (p_subline_cd, subline_cd)
                                AND (   (    p_scope = 3
                                         AND endt_seq_no = endt_seq_no)
                                     OR (p_scope = 1 AND endt_seq_no = 0)
                                     OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
                SELECT iss_name
                  INTO v_iss_name
                  FROM giis_issource
                 WHERE iss_cd = a.iss_cd;

            v_iss_name := i.iss_cd || ' - ' || v_iss_name;
            END LOOP;
         END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         BEGIN
              SELECT COUNT (DISTINCT binder_no)
                INTO v.bndr_count
                FROM gipi_uwreports_ri_ext
               WHERE     user_id = p_user_id
                     AND DECODE (p_iss_param,
                                 1, NVL (cred_branch, iss_cd),
                                 iss_cd) = i.iss_cd
                     AND line_cd = i.line_cd
                     AND subline_cd = i.subline_cd
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
            GROUP BY iss_cd, line_cd, subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v.bndr_count := 0;
         END;

         v.iss_name := v_iss_name;
         v.line := i.line_name;
         v.subline := i.subline_name;
         v.bndr_count := i.binder_count;
         v.sum_insured := i.total_si;
         v.premium := i.total_prem;
         v.sum_reinsured := v_reinsured;
         v.share_prem := i.share_premium;
         v.share_prem_vat := i.ri_prem_vat;
         v.ri_comm := i.ri_comm_amt;
         v.comm_vat := i.ri_comm_vat;
         v.wholding_vat := i.ri_wholding_vat;
         v.net_due := i.net_due;
         PIPE ROW (v);
      END LOOP;
   END get_gipir930a;

   FUNCTION get_date_format (p_date DATE)
      RETURN VARCHAR2
   AS
      v_date   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT TO_CHAR (p_date, giisp.v ('REP_DATE_FORMAT'))
        INTO v_date
        FROM DUAL;

      RETURN v_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_date := TO_CHAR (p_date, 'MM/DD/RRRR');
         RETURN v_date;
   END;


   FUNCTION get_gipir924k (p_tab           VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_scope         VARCHAR2,
                           p_user_id       VARCHAR2,
                           p_param_date    VARCHAR2,
                           p_from_date     VARCHAR2,
                           p_to_date       VARCHAR2,
                           p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED
   IS
      v                    dynamic_csv_rec_type;

      TYPE col_type IS RECORD
      (
         col_id     VARCHAR2 (100),
         col_name   VARCHAR2 (100)
      );

      TYPE col_tab IS TABLE OF col_type
         INDEX BY BINARY_INTEGER;

      v_tab                col_tab;

      TYPE row_type IS RECORD
      (
         iss_cd                giis_issource.iss_cd%TYPE,
         iss_name              giis_issource.iss_name%TYPE,
         cred_branch           giis_issource.iss_cd%TYPE,
         cred_branch_name      giis_issource.iss_name%TYPE,
         line_cd               giis_line.line_cd%TYPE,
         line_name             giis_line.line_name%TYPE,
         subline_cd            giis_subline.subline_cd%TYPE,
         subline_name          giis_subline.subline_name%TYPE,
         policy_no             VARCHAR2 (500),
         policy_id             gipi_polbasic.policy_id%TYPE,
         invoice_no            VARCHAR2 (500),
         issue_date            DATE,
         incept_date           DATE,
         expiry_date           DATE,
         booking_date          VARCHAR2 (100),
         acct_ent_date         DATE,
         spld_acct_ent_date    DATE,
         assd_no               giis_assured.assd_no%TYPE,
         assd_name             giis_assured.assd_name%TYPE,
         assd_tin              giis_assured.assd_tin%TYPE,
         gross_premium         NUMBER (38, 2),
         retention_premium     NUMBER (38, 2),
         facultative_premium   NUMBER (38, 2),
         facul_ri_comm         NUMBER (38, 2),
         facul_ri_comm_vat     NUMBER (38, 2),
         treaty_premium        NUMBER (38, 2),
         treaty_ri_comm        NUMBER (38, 2),
         treaty_ri_comm_vat    NUMBER (38, 2),
         evatprem              NUMBER (38, 2),
         lgt                   NUMBER (38, 2),
         doc_stamps            NUMBER (38, 2),
         fst                   NUMBER (38, 2),
         other_taxes           NUMBER (38, 2),
         taxes                 VARCHAR2 (32767),
         intm_no               giis_intermediary.intm_no%TYPE,
         intm_name             giis_intermediary.intm_name%TYPE,
         commission_amt        NUMBER (38, 2)
      );

      TYPE row_tab IS TABLE OF row_type;

      v_row                row_tab;
      v_rep_date_format    giis_parameters.param_value_v%TYPE;
      v_line_name          giis_line.line_name%TYPE;
      v_subline_name       giis_subline.subline_name%TYPE;
      v_cred_branch_name   giis_issource.iss_name%TYPE;
      v_iss_name           giis_issource.iss_name%TYPE;

      v_invoice_no         VARCHAR2 (100);
      v_assd_name          giis_assured.assd_name%TYPE;
      v_index              NUMBER;
      v_query              VARCHAR2 (32767);
      v_ri_cd              giis_reinsurer.ri_cd%TYPE;
      v_ri_name            giis_reinsurer.ri_name%TYPE;
      v_exists             NUMBER;
   BEGIN 
      BEGIN
         SELECT giisp.v ('REP_DATE_FORMAT') INTO v_rep_date_format FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      DECLARE
         v_dummy   VARCHAR2 (100);
      BEGIN
         SELECT TO_CHAR (SYSDATE, v_rep_date_format) INTO v_dummy FROM DUAL;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      v_tab (1).col_name := 'ISSUING CODE';
      v_tab (2).col_name := 'ISSUE SOURCE NAME';
      v_tab (3).col_name := 'CRED BRANCH';
      v_tab (4).col_name := 'CRED BRANCH NAME';
      v_tab (5).col_name := 'LINE CODE';
      v_tab (6).col_name := 'LINE NAME';
      v_tab (7).col_name := 'SUBLINE CODE ';
      v_tab (8).col_name := 'SUBLINE NAME';
      v_tab (9).col_name := 'REFERENCE NO. ';
      v_tab (10).col_name := 'INVOICE NO. ';
      v_tab (11).col_name := 'ISSUE DATE ';
      v_tab (12).col_name := 'INCEPT DATE ';
      v_tab (13).col_name := 'EXPIRY DATE';
      v_tab (14).col_name := 'BOOKING DATE';
      v_tab (15).col_name := 'ACCT ENTRY DATE';

      v_index := v_tab.LAST;

      IF p_scope = 4 THEN
         v_tab (v_index + 1).col_name := 'SPLD ACCT ENTRY DATE';
         v_index := v_index + 1;
      END IF;

      v_tab (v_index + 1).col_name := 'ASSURED NO.';
      v_tab (v_index + 2).col_name := 'ASSURED NAME';
      v_tab (v_index + 3).col_name := 'ASSURED TIN';
      v_tab (v_index + 4).col_name := 'GROSS PREMIUM';
      v_index := v_tab.LAST;

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
      THEN
         v_tab (v_index + 1).col_name := 'VAT / PREMIUM TAX';
         v_tab (v_index + 2).col_name := 'LGT';
         v_tab (v_index + 3).col_name := 'DOC. STAMPS';
         v_tab (v_index + 4).col_name := 'FST';
         v_tab (v_index + 5).col_name := 'OTHER  CHARGES';
      ELSE
         FOR i
            IN (  SELECT DISTINCT c.tax_cd, c.tax_name
                    FROM gipi_uwreports_dist_ext a,
                         gipi_uwreports_polinv_tax_ext b,
                         giac_taxes c
                   WHERE     a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.user_id = b.user_id
                         AND b.tax_cd = c.tax_cd
                         AND a.user_id = p_user_id
                         AND a.tab_number = p_tab
                         AND a.line_cd LIKE NVL (p_line_cd, '%')
                         AND DECODE (p_iss_param,
                                     1, NVL (a.cred_branch, a.iss_cd),
                                     a.iss_cd) LIKE
                                NVL (p_iss_cd, '%')
                         AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                         AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                              OR (p_scope = 2 AND a.endt_seq_no > 0)
                              OR (p_scope = 3 AND a.pol_flag = '4')
                              OR (p_scope = 4 AND a.pol_flag = '5')
                              OR (p_scope = 5 AND pol_flag <> '5')
                              OR p_scope = 6)--Added by pjsantos 03/14/2017, GENQA 5955
                         AND a.tab_number = p_tab
                ORDER BY c.tax_cd)
         LOOP
            IF i.tax_cd IS NOT NULL
            THEN
               v_index := v_index + 1;
               v_tab (v_index).col_id := i.tax_cd;
               v_tab (v_index).col_name := i.tax_name;
            END IF;
         END LOOP;
      END IF;

      v_index := v_tab.LAST;
      v_tab (v_index + 1).col_name := 'RETENTION PREMIUM';
      v_tab (v_index + 2).col_name := 'FACULTATIVE PREMIUM';
      v_tab (v_index + 3).col_name := 'FACULTATIVE RI COMM';
      v_tab (v_index + 4).col_name := 'FACULTATIVE RI COMM VAT';
      v_tab (v_index + 5).col_name := 'TREATY PREMIUM';
      v_tab (v_index + 6).col_name := 'TREATY RI COMM';
      v_tab (v_index + 7).col_name := 'TREATY RI COMM VAT';
      v_tab (v_index + 8).col_name := 'INTM NO';
      v_tab (v_index + 9).col_name := 'INTM NAME';
      v_tab (v_index + 10).col_name := 'RI CODE';
      v_tab (v_index + 11).col_name := 'CEDANT';
      v_tab (v_index + 12).col_name := 'COMMISSION AMT';

      FOR i IN 1 .. v_tab.LAST
      LOOP
         v.rec := v.rec || v_tab (i).col_name || ',';
      END LOOP;

      PIPE ROW (v);

      -- build up query
      v_query :=
            'SELECT'
         || ' a.iss_cd, get_iss_name(a.iss_cd) issue_name'
         || ', a.cred_branch, get_iss_name(a.cred_branch) cred_branch_name'
         || ', a.line_cd, get_line_name(a.line_cd) line_name'
         || ', a.subline_cd, get_subline_name(a.subline_cd) subline_name'
         || ', get_policy_no(a.policy_id) reference_no , a.policy_id  '
         || ', a.iss_cd || ''-'' || TO_CHAR (a.prem_seq_no, ''099999999999'') invoice_no'
         || ', a.issue_date issue_date'
         || ', a.incept_date incept_date'
         || ',a.expiry_date expiry_date'
         || ', DECODE ( a.multi_booking_mm, NULL, NULL,  a.multi_booking_mm || ''  '' || TO_CHAR(a.multi_booking_yy ) ) booking_date '
         || ', DECODE(a.acct_ent_date, NULL, NULL, a.acct_ent_date )  acct_ent_date'
         || ', DECODE(a.spld_acct_ent_date, NULL , NULL , a.spld_acct_ent_date )  spld_acct_ent_date'
         || ', a.assd_no, b.assd_name, b.assd_tin'
         || ', a.prem_amt gross_premium'
         || ', a.retention retention_premium'
         || ', a.facultative facultative_premium'
         || ', a.ri_comm facultative_ri_comm'
         || ', a.ri_comm_vat facultative_ri_comm_vat'
         || ', a.treaty treaty_premium'
         || ', a.trty_ri_comm treaty_ri_comm'
         || ', a.trty_ri_comm_vat treaty_ri_comm_vat'
         || ',  NVL (a.vat, 0) + NVL (a.prem_tax, 0) AS vatprem '
         || ',  NVL (a.lgt, 0) lgt '
         || ',  NVL (a.doc_stamps, 0) doc_stamps '
         || ' ,   NVL (a.fst, 0) fst  '
         || ',  NVL (a.other_taxes, 0)  other_taxes ,  ';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
      THEN
         v_query := v_query || ' (0) taxes';
      ELSE
         v_exists := 0;
         FOR i IN 1 .. v_tab.LAST
         LOOP
            IF v_tab (i).col_id IS NOT NULL
            THEN
               v_query :=
                     v_query
                  || 'SUM(DECODE(e.tax_cd, '
                  || v_tab (i).col_id
                  || ', e.tax_amt, 0)) || '','' ||';
               v_exists := 1;
            END IF;
         END LOOP;
         
         IF v_exists = 0
         THEN
            v_query := v_query || 'SUM(0) || '','' ||';
         END IF;

         v_query := SUBSTR (v_query, 0, LENGTH (v_query) - 9);
      END IF;

      -- add the from clause depends on parameter

      v_query :=
            v_query
         || ', c.intm_no intm_no, d.intm_name'
         || ', DECODE (a.iss_cd, giisp.v (''ISS_CD_RI''), a.comm, c.commission_amt) commission_amt'
         || ' FROM gipi_uwreports_dist_ext a, giis_assured b ,   '
         || '      (  SELECT t.user_id,  t.tab_number,   t.policy_id,  t.iss_cd,   t.prem_seq_no, '
         || '       t.item_grp,  t.takeup_seq_no, t.intm_no, SUM (NVL (t.premium_amt, 0)) premium_amt, '
         || '      SUM (NVL (t.commission_amt, 0)) commission_amt,    SUM (NVL (t.wholding_tax, 0)) wholding_tax '
         || '    FROM gipi_uwreports_comm_invperil t '
         || '   WHERE t.user_id ='''
         || p_user_id
         || ''''
         || '  GROUP BY t.user_id,     t.tab_number,      t.policy_id,       t.iss_cd,  t.prem_seq_no, '
         || '      t.item_grp,         t.takeup_seq_no,  t.intm_no) c,  giis_intermediary d ';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 2
      THEN
         v_query := v_query || ' , gipi_uwreports_polinv_tax_ext e  ';
      END IF;

      v_query :=
            v_query
         || ' WHERE a.user_id = '''
         || p_user_id
         || ''''
         || ' AND DECODE('
         || p_iss_param
         || ', 1, a.cred_branch, a.iss_cd) = NVL('''
         || p_iss_cd
         || ''', DECODE('
         || p_iss_param
         || ', 1, a.cred_branch, a.iss_cd))'
         || ' AND a.line_cd = NVL('''
         || p_line_cd
         || ''', a.line_cd)'
         || ' AND a.subline_cd = NVL('''
         || p_subline_cd
         || ''', a.subline_cd)'
         || ' AND (('
         || p_scope
         || ' = 1 AND a.endt_seq_no = 0)'
         || ' OR ('
         || p_scope
         || ' = 2 AND a.endt_seq_no <> 0)'
         || ' OR ('
         || p_scope
         || ' = 3 AND a.pol_flag = ''4'')'
         || ' OR ('
         || p_scope
         || ' = 4 AND a.pol_flag = ''5'')'
         || ' OR ('
         || p_scope
         || ' = 5 AND a.pol_flag <> ''5'')'
         || ' OR '
         || p_scope
         || ' = 6)'--Added by pjsantos 03/14/2017,p_scope = 6 GENQA 5955
         || ' AND a.tab_number = '
         || p_tab
         -- marker
         || '   AND ( '
         || p_scope
         || '  <> 4  '
         || '         OR NVL('''
         || p_reinstated
         || ''', '''
         || 'N'
         || ''') = '''
         || 'N'
         || ''' '
         || '         OR EXISTS ( '
         || '                  SELECT 1 FROM gipi_uwreports_ext t '
         || '                         where t.user_id =  '''
         || p_user_id
         || ''''
         || '                          and t.tab_number = '
         || p_tab
         || '                        and t.policy_id = a.policy_id  '
         || '                       and NVL(t.reinstate_tag, '''
         || 'N'
         || ''' ) = DECODE (NVL('''
         || p_reinstated
         || ''',  '''
         || 'N'
         || '''), '''
         || 'N'
         || ''', t.reinstate_tag , '''
         || 'Y'
         || ''')  ))  '
         -- end marker
         || ' AND a.assd_no = b.assd_no'
         || ' AND a.policy_id = c.policy_id(+)'
         || ' AND a.prem_seq_no = c.prem_seq_no(+)'
         || ' AND a.iss_cd = c.iss_cd(+)'
         || ' AND c.intm_no = d.intm_no (+)';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 2
      THEN
         v_query :=
               v_query
            || ' AND a.user_id = e.user_id(+)'
            || ' AND a.tab_number = e.tab_number(+)'
            || ' AND a.policy_id = e.policy_id(+)'
            || ' AND a.prem_seq_no = e.prem_seq_no(+)'
            || ' AND a.iss_cd = e.iss_cd(+)'
            || ' GROUP BY a.iss_cd, a.cred_branch, a.line_cd, a.subline_cd'
            || ', a.policy_id, a.prem_seq_no, a.issue_date, a.incept_date'
            || ', a.expiry_date, a.multi_booking_mm, a.multi_booking_yy'
            || ', a.acct_ent_date, a.spld_acct_ent_date, a.assd_no, b.assd_name'
            || ', b.assd_tin, a.prem_amt, a.retention, a.facultative, a.ri_comm'
            || ', a.ri_comm_vat, a.treaty, a.trty_ri_comm, a.trty_ri_comm_vat'
            || ', a.vat, a.prem_tax, a.lgt, a.doc_stamps, a.fst, a.other_taxes'
            || ', a.other_charges, c.intm_no, d.intm_name, a.comm, c.commission_amt  ';
      END IF;



      v_query := v_query || '  ORDER BY iss_cd, line_cd, reference_no ';

      EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_row;

      IF SQL%FOUND
      THEN
         FOR i IN 1 .. v_row.LAST
         LOOP
            v_ri_cd := NULL;
            v_ri_name := NULL;

            IF v_row (i).iss_cd = giisp.v ('ISS_CD_RI')
            THEN
               FOR t
                  IN (SELECT a.ri_cd, b.ri_name
                        FROM giri_inpolbas a, giis_reinsurer b
                       WHERE     a.ri_cd = b.ri_cd
                             AND a.policy_id = v_row (i).policy_id)
               LOOP
                  v_ri_cd := t.ri_cd;
                  v_ri_name := t.ri_name;
                  EXIT;
               END LOOP;
            END IF;

            v.rec :=
                  v_row (i).iss_cd
               || ','
               || escape_string (v_row (i).iss_name)
               || ','
               || v_row (i).cred_branch
               || ','
               || escape_string (v_row (i).cred_branch_name)
               || ','
               || v_row (i).line_cd
               || ','
               || escape_string (v_row (i).line_name)
               || ','
               || v_row (i).subline_cd
               || ','
               || escape_string (v_row (i).subline_name)
               || ','
               || escape_string (v_row (i).policy_no)
               || ','
               || escape_string (v_row (i).invoice_no)
               || ','
               || v_row (i).issue_date
               || ','
               || v_row (i).incept_date
               || ','
               || v_row (i).expiry_date
               || ','
               || v_row (i).booking_date
               || ','
               || v_row (i).acct_ent_date;
               
            IF p_scope = 4 THEN
               v.rec :=
                     v.rec
                  || ','
                  || v_row (i).spld_acct_ent_date;
            END IF;
           
            v.rec :=
                  v.rec
               || ','
               || v_row (i).assd_no
               || ','
               || escape_string (v_row (i).assd_name)
               || ','
               || escape_string (v_row (i).assd_tin)
               || ','
               || v_row (i).gross_premium;

            IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
            THEN
               v.rec :=
                     v.rec
                  || ','
                  || v_row (i).evatprem
                  || ','
                  || v_row (i).lgt
                  || ','
                  || v_row (i).doc_stamps
                  || ','
                  || v_row (i).fst
                  || ','
                  || v_row (i).other_taxes;
            ELSE
               IF v_exists = 1
               THEN
                  v.rec := v.rec || ',' || v_row (i).taxes;
               eND IF;
            END IF;

            v.rec :=
                  v.rec
               || ','
               || v_row (i).retention_premium
               || ','
               || v_row (i).facultative_premium
               || ','
               || v_row (i).facul_ri_comm
               || ','
               || v_row (i).facul_ri_comm_vat
               || ','
               || v_row (i).treaty_premium
               || ','
               || v_row (i).treaty_ri_comm
               || ','
               || v_row (i).treaty_ri_comm_vat
               || ','
               || v_row (i).intm_no
               || ','
               || escape_string (v_row (i).intm_name)
               || ','
               || v_ri_cd
               || ','
               || escape_string (v_ri_name)
               || ','
               || v_row (i).commission_amt;
            PIPE ROW (v);
         END LOOP;
      END IF;
   END get_gipir924k;

   -- END MUMOWANTED2007

   /** ====================================================================================================================================
    **            D  I  S  T  R  I  B  U  T  I  O  N   R  E  G  I  S  T E  R   ( T A B  2 ) r e p o r t s
    ** ================================================================================================================================== */
   FUNCTION get_gipir928 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928_type
      PIPELINED
   IS
      v_gipir928      gipir928_rec_type;
      v_cred_branch   giis_issource.iss_name%TYPE;
   BEGIN
      FOR rec
         IN (  SELECT DECODE (c.peril_type,
                              'B', '*' || c.peril_sname,
                              ' ' || c.peril_sname)
                         peril_sname,
                      c.peril_type,
                      g.iss_name,
                      b.line_cd,
                      e.line_name,
                      b.subline_cd,
                      f.subline_name,
                      b.policy_no policy_no,
                      NVL (b.cred_branch, b.iss_cd) cred_branch,
                      b.iss_cd,
                      b.trty_name, --benjo 02.03.2016 MAC-SR-21220
                      SUM (NVL (b.tr_dist_tsi, 0)) tr_peril_tsi,
                      SUM (NVL (b.tr_dist_prem, 0)) tr_peril_prem
                 FROM gipi_uwreports_dist_peril_ext b,
                      giis_peril c,
                      giis_subline f,
                      giis_dist_share d,
                      giis_issource g,
                      giis_line e
                WHERE     1 = 1
                      AND b.line_cd = c.line_cd
                      AND b.peril_cd = c.peril_cd
                      AND b.line_cd = f.line_cd
                      AND b.subline_cd = f.subline_cd
                      AND b.line_cd = d.line_cd
                      AND b.share_cd = d.share_cd
                      AND b.line_cd = e.line_cd
                      AND DECODE (p_iss_param,
                                  1, NVL (b.cred_branch, b.iss_cd),
                                  b.iss_cd) = g.iss_cd
                      AND DECODE (p_iss_param,
                                  1, NVL (b.cred_branch, b.iss_cd),
                                  b.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (b.cred_branch, b.iss_cd),
                                        b.iss_cd))
                      AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                      AND b.share_type = 2
                      AND b.user_id = p_user_id
                      AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                           OR (p_scope = 1 AND b.endt_seq_no = 0)
                           OR (p_scope = 2 AND b.endt_seq_no > 0))
                      AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
             GROUP BY b.iss_cd,
                      NVL (b.cred_branch, b.iss_cd),
                      DECODE (c.peril_type,
                              'B', '*' || c.peril_sname,
                              ' ' || c.peril_sname),
                      g.iss_name,
                      b.line_cd,
                      e.line_name,
                      b.subline_cd,
                      f.subline_name,
                      b.policy_no,
                      c.peril_type,
                      b.trty_name --benjo 02.03.2016 MAC-SR-21220
             ORDER BY g.iss_name,
                      e.line_name,
                      f.subline_name,
                      b.policy_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_cred_branch
              FROM giis_issource
             WHERE iss_cd = rec.cred_branch;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir928.iss_name := rec.iss_name;
         v_gipir928.line_name := rec.line_name;
         v_gipir928.line_cd := rec.line_cd;
         v_gipir928.subline_cd := rec.subline_cd;
         v_gipir928.cred_branch := rec.cred_branch;
         v_gipir928.cred_branch_name := v_cred_branch;
         v_gipir928.subline_name := rec.subline_name;
         v_gipir928.policy_no := rec.policy_no;
         v_gipir928.peril_sname := rec.peril_sname;
         v_gipir928.tsi_amt := rec.tr_peril_tsi;
         v_gipir928.peril_type := rec.peril_type;
         v_gipir928.prem_amt := rec.tr_peril_prem;
         v_gipir928.iss_cd := rec.iss_cd; --benjo 02.03.2016 MAC-SR-21220
         v_gipir928.trty_name := rec.trty_name; --benjo 02.03.2016 MAC-SR-21220
         PIPE ROW (v_gipir928);
      END LOOP;

      RETURN;
   END get_gipir928;

   FUNCTION get_gipir928a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928a_type
      PIPELINED
   IS
      v_gipir928a     gipir928a_rec_type;
      v_iss_name      VARCHAR2 (100);
      v_cred_branch   giis_issource.iss_name%TYPE;
   BEGIN
      FOR rec
         IN (  SELECT b.iss_cd iss_cd,
                      NVL (b.cred_branch, b.iss_cd) cred_branch,
                      b.line_cd line_cd,
                      INITCAP (e.line_name) line_name,
                      b.subline_cd subline_cd,
                      INITCAP (f.subline_name) subline_name,
                      b.policy_no policy_no,
                      DECODE (c.peril_type,
                              'B', '*' || c.peril_sname,
                              ' ' || c.peril_sname)
                         peril_sname,
                      c.peril_type,
                      SUM (
                         DECODE (c.peril_type,
                                 'B', NVL (b.nr_dist_tsi, 0),
                                 '0'))
                         f_nr_dist_tsi,
                      SUM (
                         DECODE (c.peril_type,
                                 'B', NVL (b.tr_dist_tsi, 0),
                                 '0'))
                         f_tr_dist_tsi,
                      SUM (
                         DECODE (c.peril_type,
                                 'B', NVL (b.fa_dist_tsi, 0),
                                 '0'))
                         f_fa_dist_tsi,
                      SUM (NVL (b.nr_dist_tsi, 0)) nr_peril_tsi,
                      SUM (NVL (b.nr_dist_prem, 0)) nr_peril_prem,
                      SUM (NVL (b.tr_dist_tsi, 0)) tr_peril_tsi,
                      SUM (NVL (b.tr_dist_prem, 0)) tr_peril_prem,
                      SUM (NVL (b.fa_dist_tsi, 0)) fa_peril_tsi,
                      SUM (NVL (b.fa_dist_prem, 0)) fa_peril_prem
                 FROM gipi_uwreports_dist_peril_ext b,
                      giis_peril c,
                      giis_subline f,
                      giis_dist_share d,
                      giis_issource g,
                      giis_line e
                WHERE     1 = 1
                      AND b.line_cd = c.line_cd
                      AND b.peril_cd = c.peril_cd
                      AND b.line_cd = f.line_cd
                      AND b.subline_cd = f.subline_cd
                      AND DECODE (p_iss_param,
                                  1, NVL (b.cred_branch, b.iss_cd),
                                  b.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (b.cred_branch, b.iss_cd),
                                        b.iss_cd))
                      AND b.line_cd = d.line_cd
                      AND b.share_cd = d.share_cd
                      AND b.line_cd = e.line_cd
                      AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                             g.iss_cd
                      AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                      AND b.user_id = p_user_id
                      AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                           OR (p_scope = 1 AND b.endt_seq_no = 0)
                           OR (p_scope = 2 AND b.endt_seq_no > 0))
                      AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
             GROUP BY b.iss_cd,
                      b.cred_branch,
                      b.iss_cd,
                      b.line_cd,
                      e.line_name,
                      b.subline_cd,
                      f.subline_name,
                      b.policy_no,
                      c.peril_sname,
                      c.peril_type,
                      c.peril_sname
             ORDER BY b.iss_cd,
                      e.line_name,
                      f.subline_name,
                      b.policy_no,
                      c.peril_sname)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_cred_branch
              FROM giis_issource
             WHERE iss_cd = rec.cred_branch;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir928a.iss_source_name := v_iss_name;
         v_gipir928a.iss_cd := rec.iss_cd;
         v_gipir928a.cred_branch_name := v_cred_branch;
         v_gipir928a.cred_branch := rec.cred_branch;
         v_gipir928a.line_cd := rec.line_cd;
         v_gipir928a.line_name := rec.line_name;
         v_gipir928a.subline_cd := rec.subline_cd;
         v_gipir928a.subline_name := rec.subline_name;
         v_gipir928a.policy_no := rec.policy_no;
         v_gipir928a.peril_sname := rec.peril_sname;
         v_gipir928a.net_retention_risk := rec.nr_peril_tsi;
         v_gipir928a.net_retention_premium := rec.nr_peril_prem;
         v_gipir928a.treaty_risk := rec.tr_peril_tsi;
         v_gipir928a.treaty_prem := rec.tr_peril_prem;
         --v_gipir928a.facultative_risk := rec.f_fa_dist_tsi; -- jhing 03.21.2016 REPUBLICFULLWEB 21882 commented out and replaced with :
         v_gipir928a.facultative_risk := rec.fa_peril_tsi;    -- jhing 03.21.2016 REPUBLICFULLWEB 21882
         v_gipir928a.facultative_prem := rec.fa_peril_prem;
         v_gipir928a.peril_type := rec.peril_type;
         PIPE ROW (v_gipir928a);
      END LOOP;

      RETURN;
   END get_gipir928a;

   FUNCTION get_gipir928b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928b_type
      PIPELINED
   IS
      v_gipir928b   gipir928b_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT b.line_name line_name,
                      c.subline_cd subline_cd,
                      c.subline_name,
                      a.iss_cd,
                      NVL (a.cred_branch, a.iss_cd) cred_branch,
                      a.policy_no policy_no,
                      SUM (
                         DECODE (a.peril_type, 'A', 0, NVL (a.nr_dist_tsi, 0)))
                         net_ret_tsi,
                      SUM (NVL (a.nr_dist_prem, 0)) net_ret_prem,
                      SUM (
                         DECODE (a.peril_type, 'A', 0, NVL (a.tr_dist_tsi, 0)))
                         treaty_tsi,
                      SUM (NVL (a.tr_dist_prem, 0)) treaty_prem,
                      SUM (
                         DECODE (a.peril_type, 'A', 0, NVL (a.fa_dist_tsi, 0)))
                         facultative_tsi,
                      SUM (NVL (a.fa_dist_prem, 0)) facultative_prem,
                        SUM (
                           DECODE (a.peril_type,
                                   'A', 0,
                                   NVL (a.nr_dist_tsi, 0)))
                      + SUM (
                           DECODE (a.peril_type,
                                   'A', 0,
                                   NVL (a.tr_dist_tsi, 0)))
                      + SUM (
                           DECODE (a.peril_type,
                                   'A', 0,
                                   NVL (a.fa_dist_tsi, 0)))
                         total_tsi,
                        SUM (NVL (a.nr_dist_prem, 0))
                      + SUM (NVL (a.tr_dist_prem, 0))
                      + SUM (NVL (a.fa_dist_prem, 0))
                         total_premium
                 FROM gipi_uwreports_dist_peril_ext a,
                      giis_line b,
                      giis_subline c
                WHERE     a.line_cd = b.line_cd
                      AND a.subline_cd = c.subline_cd
                      AND a.line_cd = c.line_cd
                      AND DECODE (p_iss_param,
                                  1, NVL (a.cred_branch, a.iss_cd),
                                  a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (a.cred_branch, a.iss_cd),
                                        a.iss_cd))
                      AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                      AND a.user_id = p_user_id
                      AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                           OR (p_scope = 1 AND a.endt_seq_no = 0)
                           OR (p_scope = 2 AND a.endt_seq_no > 0))
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
             GROUP BY a.iss_cd,
                      NVL (a.cred_branch, a.iss_cd),
                      b.line_name,
                      c.subline_cd,
                      c.subline_name,
                      a.policy_no
             ORDER BY a.iss_cd,
                      NVL (a.cred_branch, a.iss_cd),
                      b.line_name,
                      c.subline_cd,
                      a.policy_no)
      LOOP
         v_gipir928b.line_name := rec.line_name;
         v_gipir928b.subline_cd := rec.subline_cd;
         v_gipir928b.subline_name := rec.subline_name;
         v_gipir928b.iss_cd := rec.iss_cd;
         v_gipir928b.iss_name := get_iss_name (rec.iss_cd);
         v_gipir928b.cred_branch_name := get_iss_name (rec.cred_branch);
         v_gipir928b.cred_branch := rec.cred_branch;
         v_gipir928b.policy_no := rec.policy_no;
         v_gipir928b.net_ret_tsi := rec.net_ret_tsi;
         v_gipir928b.net_ret_prem := rec.net_ret_prem;
         v_gipir928b.treaty_tsi := rec.treaty_tsi;
         v_gipir928b.treaty_prem := rec.treaty_prem;
         v_gipir928b.facultative_tsi := rec.facultative_tsi;
         v_gipir928b.facultative_prem := rec.facultative_prem;
         v_gipir928b.total_tsi := rec.total_tsi;
         v_gipir928b.total_prem := rec.total_premium;
         PIPE ROW (v_gipir928b);
      END LOOP;

      RETURN;
   END get_gipir928b;

   FUNCTION get_gipir928c (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928c_type
      PIPELINED
   IS
      v_gipir928c   gipir928c_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT b.line_name line_name,
                      c.subline_cd subline_cd,
                      b.line_cd,
                      a.peril_type,
                      d.peril_sname,
                      c.subline_name,
                      d.peril_name peril_name,
                      DECODE (a.peril_type,
                              'A', 0,
                              SUM (NVL (a.nr_dist_tsi, 0)))
                         nrdisttsi,
                      SUM (NVL (a.nr_dist_prem, 0)) nrdistprem,
                      DECODE (a.peril_type,
                              'A', 0,
                              SUM (NVL (a.tr_dist_tsi, 0)))
                         trdisttsi,
                      SUM (NVL (a.tr_dist_prem, 0)) trdistprem,
                      DECODE (a.peril_type,
                              'A', 0,
                              SUM (NVL (a.fa_dist_tsi, 0)))
                         fadisttsi,
                      SUM (NVL (a.fa_dist_prem, 0)) fadistprem,
                        DECODE (a.peril_type,
                                'A', 0,
                                SUM (NVL (a.nr_dist_tsi, 0)))
                      + DECODE (a.peril_type,
                                'A', 0,
                                SUM (NVL (a.tr_dist_tsi, 0)))
                      + DECODE (a.peril_type,
                                'A', 0,
                                SUM (NVL (a.fa_dist_tsi, 0)))
                         totaltsi,
                        SUM (NVL (a.nr_dist_prem, 0))
                      + SUM (NVL (a.tr_dist_prem, 0))
                      + SUM (NVL (a.fa_dist_prem, 0))
                         totalprem
                 FROM gipi_uwreports_dist_peril_ext a,
                      giis_line b,
                      giis_subline c,
                      giis_peril d
                WHERE     a.line_cd = b.line_cd
                      AND a.line_cd = c.line_cd
                      AND a.subline_cd = c.subline_cd
                      AND a.line_cd = d.line_cd
                      AND a.peril_cd = d.peril_cd
                      AND DECODE (p_iss_param,
                                  1, NVL (a.cred_branch, a.iss_cd),
                                  a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (a.cred_branch, a.iss_cd),
                                        a.iss_cd))
                      AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                      AND a.user_id = p_user_id
                      AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                           OR (p_scope = 1 AND a.endt_seq_no = 0)
                           OR (p_scope = 2 AND a.endt_seq_no > 0))
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
             GROUP BY b.line_cd,
                      b.line_name,
                      c.subline_cd,
                      c.subline_name,
                      d.peril_name,
                      d.peril_sname,
                      a.peril_type
             ORDER BY b.line_name, c.subline_cd, d.peril_name)
      LOOP
         v_gipir928c.line_name := rec.line_name;
         v_gipir928c.line_cd := rec.line_cd;
         v_gipir928c.subline_cd := rec.subline_cd;
         v_gipir928c.subline_name := rec.subline_name;
         v_gipir928c.peril_sname := rec.peril_sname;
         v_gipir928c.peril_name := rec.peril_name;
         v_gipir928c.peril_type := rec.peril_type;
         v_gipir928c.net_ret_tsi := rec.nrdisttsi;
         v_gipir928c.net_ret_prem := rec.nrdistprem;
         v_gipir928c.treaty_tsi := rec.trdisttsi;
         v_gipir928c.treaty_prem := rec.trdistprem;
         v_gipir928c.facultative_tsi := rec.fadisttsi;
         v_gipir928c.facultative_prem := rec.fadistprem;
         v_gipir928c.total_tsi := rec.totaltsi;
         v_gipir928c.total_prem := rec.totalprem;
         PIPE ROW (v_gipir928c);
      END LOOP;

      RETURN;
   END get_gipir928c;

   FUNCTION get_gipir928d (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928d_type
      PIPELINED
   IS
      v_gipir928d   gipir928d_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT INITCAP (b.line_name) line_name,
                      b.line_cd,
                      c.subline_cd,
                      INITCAP (c.subline_name) subline_name,
                      COUNT (DISTINCT a.policy_no) policies,
                      SUM (
                         DECODE (a.peril_type, 'A', 0, NVL (a.nr_dist_tsi, 0)))
                         net_ret_tsi,
                      SUM (NVL (a.nr_dist_prem, 0)) net_ret_premium,
                      SUM (
                         DECODE (a.peril_type, 'A', 0, NVL (a.tr_dist_tsi, 0)))
                         treaty_tsi,
                      SUM (NVL (a.tr_dist_prem, 0)) treaty_premium,
                      SUM (
                         DECODE (a.peril_type, 'A', 0, NVL (a.fa_dist_tsi, 0)))
                         facultative_tsi,
                      SUM (NVL (a.fa_dist_prem, 0)) facultative_premium,
                        SUM (
                           DECODE (a.peril_type,
                                   'A', 0,
                                   NVL (a.nr_dist_tsi, 0)))
                      + SUM (
                           DECODE (a.peril_type,
                                   'A', 0,
                                   NVL (a.tr_dist_tsi, 0)))
                      + SUM (
                           DECODE (a.peril_type,
                                   'A', 0,
                                   NVL (a.fa_dist_tsi, 0)))
                         total_sum_sinsured,
                        SUM (NVL (a.nr_dist_prem, 0))
                      + SUM (NVL (a.tr_dist_prem, 0))
                      + SUM (NVL (a.fa_dist_prem, 0))
                         total_premium
                 FROM gipi_uwreports_dist_peril_ext a,
                      giis_line b,
                      giis_subline c
                WHERE     a.line_cd = b.line_cd
                      AND a.subline_cd = c.subline_cd
                      AND a.line_cd = c.line_cd
                      AND DECODE (p_iss_param,
                                  1, NVL (a.cred_branch, a.iss_cd),
                                  a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (a.cred_branch, a.iss_cd),
                                        a.iss_cd))
                      AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                      AND a.user_id = p_user_id
                      AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                           OR (p_scope = 1 AND a.endt_seq_no = 0)
                           OR (p_scope = 2 AND a.endt_seq_no > 0))
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
             GROUP BY b.line_cd,
                      b.line_name,
                      c.subline_cd,
                      c.subline_name
             ORDER BY b.line_cd,
                      b.line_name,
                      c.subline_cd,
                      c.subline_name)
      LOOP
         v_gipir928d.line_cd := rec.line_cd;
         v_gipir928d.line_name := rec.line_name;
         v_gipir928d.subline_name := rec.subline_name;
         v_gipir928d.subline_cd := rec.subline_cd;
         v_gipir928d.pol_count := rec.policies;
         v_gipir928d.net_ret_tsi := rec.net_ret_tsi;
         v_gipir928d.net_ret_prem := rec.net_ret_premium;
         v_gipir928d.treaty_tsi := rec.treaty_tsi;
         v_gipir928d.treaty_prem := rec.treaty_premium;
         v_gipir928d.facultative_tsi := rec.facultative_tsi;
         v_gipir928d.facultative_prem := rec.facultative_premium;
         v_gipir928d.total_tsi := rec.total_sum_sinsured;
         v_gipir928d.total_prem := rec.total_premium;
         PIPE ROW (v_gipir928d);
      END LOOP;

      RETURN;
   END get_gipir928d;

   FUNCTION get_gipir928e (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928e_type
      PIPELINED
   IS
      v_gipir928e   gipir928e_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT DISTINCT
                      DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd,
                      DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                         iss_cd_header,
                      g.iss_name iss_name,
                      b.line_cd line_cd,
                      e.line_name line_name,
                      b.subline_cd subline_cd,
                      f.subline_name subline_name,
                      SUM (NVL (b.nr_dist_tsi, 0)) nr_tsi,
                      SUM (NVL (b.tr_dist_tsi, 0)) tr_tsi,
                      SUM (
                         DECODE (c.peril_type, 'B', NVL (b.fa_dist_tsi, 0), 0))
                         fa_tsi,
                      SUM (
                           DECODE (c.peril_type,
                                   'B', NVL (b.nr_dist_tsi, 0),
                                   0)
                         + DECODE (c.peril_type,
                                   'B', NVL (b.tr_dist_tsi, 0),
                                   0)
                         + DECODE (c.peril_type,
                                   'B', NVL (b.fa_dist_tsi, 0),
                                   0))
                         total_tsi,
                      SUM (NVL (b.nr_dist_prem, 0)) nr_prem,
                      SUM (NVL (b.tr_dist_prem, 0)) tr_prem,
                      SUM (NVL (b.fa_dist_prem, 0)) fa_prem,
                      SUM (
                           NVL (b.nr_dist_prem, 0)
                         + NVL (b.tr_dist_prem, 0)
                         + NVL (b.fa_dist_prem, 0))
                         total_prem
                 FROM gipi_uwreports_dist_peril_ext b,
                      giis_peril c,
                      giis_subline f,
                      giis_dist_share d,
                      giis_issource g,
                      giis_line e
                WHERE     1 = 1
                      AND b.line_cd = c.line_cd
                      AND b.peril_cd = c.peril_cd
                      AND b.line_cd = f.line_cd
                      AND b.subline_cd = f.subline_cd
                      AND b.line_cd = d.line_cd
                      AND b.share_cd = d.share_cd
                      AND b.line_cd = e.line_cd
                      AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                             g.iss_cd
                      AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, b.cred_branch,
                                        b.iss_cd))
                      AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                      AND b.user_id = p_user_id
                      AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                           OR (p_scope = 1 AND b.endt_seq_no = 0)
                           OR (p_scope = 2 AND b.endt_seq_no > 0))
                      AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
             GROUP BY DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                      g.iss_name,
                      b.line_cd,
                      e.line_name,
                      b.subline_cd,
                      f.subline_name
             ORDER BY g.iss_name, e.line_name, f.subline_name)
      LOOP
         v_gipir928e.iss_name := rec.iss_name;
         v_gipir928e.line := rec.line_name;
         v_gipir928e.subline := rec.subline_name;
         v_gipir928e.nr_tsi := rec.nr_tsi;
         v_gipir928e.tr_tsi := rec.tr_tsi;
         v_gipir928e.fa_tsi := rec.fa_tsi;
         v_gipir928e.total_tsi := rec.total_tsi;
         v_gipir928e.nr_prem := rec.nr_prem;
         v_gipir928e.tr_prem := rec.tr_prem;
         v_gipir928e.fa_prem := rec.fa_prem;
         v_gipir928e.total_prem := rec.total_prem;
         PIPE ROW (v_gipir928e);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir928f (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928f_type
      PIPELINED
   IS
      v_gipir928f   gipir928f_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT DISTINCT
                      b.iss_cd,
                      INITCAP (g.iss_name) iss_name,
                      b.line_cd,
                      INITCAP (e.line_name) line_name,
                      b.subline_cd,
                      INITCAP (f.subline_name) subline_name,
                      b.policy_no policy_no2,
                      b.policy_id policy_id,
                      DECODE (c.peril_type,
                              'B', '*' || c.peril_sname,
                              ' ' || c.peril_sname)
                         peril_sname,
                      SUM (DECODE (b.peril_type, 'B', NVL (nr_dist_tsi, 0), 0))
                         nr_tsi,
                      SUM (NVL (nr_dist_prem, 0)) nr_prem,
                      SUM (DECODE (b.peril_type, 'B', NVL (tr_dist_tsi, 0), 0))
                         tr_tsi,
                      SUM (NVL (tr_dist_prem, 0)) tr_prem,
                      SUM (DECODE (b.peril_type, 'B', NVL (fa_dist_tsi, 0), 0))
                         fa_tsi,
                      SUM (NVL (fa_dist_prem, 0)) fa_prem,
                      SUM (
                           DECODE (b.peril_type, 'B', NVL (nr_dist_tsi, 0), 0)
                         + DECODE (b.peril_type, 'B', NVL (tr_dist_tsi, 0), 0)
                         + DECODE (b.peril_type, 'B', NVL (fa_dist_tsi, 0), 0))
                         tsi_amt,
                      SUM (
                           NVL (nr_dist_prem, 0)
                         + NVL (tr_dist_prem, 0)
                         + NVL (fa_dist_prem, 0))
                         prem_amt
                 FROM gipi_uwreports_dist_peril_ext b,
                      giis_peril c,
                      giis_subline f,
                      giis_issource g,
                      giis_line e
                WHERE     1 = 1
                      AND b.line_cd = c.line_cd
                      AND b.peril_cd = c.peril_cd
                      AND b.line_cd = f.line_cd
                      AND b.subline_cd = f.subline_cd
                      AND b.line_cd = e.line_cd
                      AND b.iss_cd = g.iss_cd
                      AND b.iss_cd = NVL (UPPER (p_iss_cd), b.iss_cd)
                      AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                      AND b.user_id = p_user_id
                      AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                           OR (p_scope = 1 AND b.endt_seq_no = 0)
                           OR (p_scope = 2 AND b.endt_seq_no > 0))
                      AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
             GROUP BY b.iss_cd,
                      g.iss_name,
                      b.line_cd,
                      e.line_name,
                      b.subline_cd,
                      f.subline_name,
                      b.policy_no,
                      b.policy_id,
                      DECODE (c.peril_type,
                              'B', '*' || c.peril_sname,
                              ' ' || c.peril_sname) --edited by MarkS 8.18.2016 SR21060 was included in the select but was not present in the group by clause
             ORDER BY INITCAP (g.iss_name),
                      INITCAP (e.line_name),
                      INITCAP (f.subline_name),
                      b.policy_no)
      LOOP
         v_gipir928f.iss_name := rec.iss_name;
         v_gipir928f.line := rec.line_name;
         v_gipir928f.subline := rec.subline_name;
         v_gipir928f.policy_no := rec.policy_no2;
         v_gipir928f.peril_sname := rec.peril_sname;
         v_gipir928f.nr_tsi := rec.nr_tsi;
         v_gipir928f.nr_prem := rec.nr_prem;
         v_gipir928f.tr_tsi := rec.tr_tsi;
         v_gipir928f.tr_prem := rec.tr_prem;
         v_gipir928f.fa_tsi := rec.fa_tsi;
         v_gipir928f.fa_prem := rec.fa_prem;
         v_gipir928f.total_tsi := rec.tsi_amt;
         v_gipir928f.total_prem := rec.prem_amt;
         PIPE ROW (v_gipir928f);
      END LOOP;

      RETURN;
   END;

   /** ====================================================================================================================================
    **            P  E  R   P  E  R  I  L  /  A  G  E  N T ( T A B 4 ) R e p o r t s
    ** ================================================================================================================================== */
   FUNCTION get_gipir946b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946b_type
      PIPELINED
   IS
      v_gipir946b        gipir946b_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (30);
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE:= giacp.v ('FUND_CD');      --Modified by pjsantos 03/08/2017, for optimization GENQA 5912
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE:= giacp.v ('BRANCH_CD');  --Modified by pjsantos 03/08/2017, for optimization GENQA 5912
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
            --Moved here by pjsantos 03/08/2017, for optimization GENQA 5912
            SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id;
            --pjsantos end
      FOR rec
         IN (  SELECT DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                      line_cd,
                      line_name,
                      subline_cd,
                      peril_cd,
                      peril_name,
                      peril_type,
                      SUM (DECODE (peril_type, 'B', tsi_amt, 0)) tsi_basic,
                      SUM (tsi_amt) tsi_amt,
                      SUM (prem_amt) prem_amt,
                      SUM(commission_amt) commission_amt --Added by pjsantos 03/08/2017, for optimization GENQA 5912
                 FROM gipi_uwreports_peril_ext
                WHERE     user_id = p_user_id
                      AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                             NVL (p_iss_cd,
                                  DECODE (p_iss_param, 1, cred_branch, iss_cd))
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             GROUP BY DECODE (p_iss_param, 1, cred_branch, iss_cd),
                      line_cd,
                      line_name,
                      subline_cd,
                      peril_cd,
                      peril_name,
                      peril_type
             ORDER BY peril_name)
      LOOP
         --v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
            IN (SELECT subline_name
                  FROM giis_subline
                 WHERE line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get COMM_AMT
       /* BEGIN
            SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

           FOR rc
               IN (SELECT b.intrmdry_intm_no,
                          b.iss_cd,
                          b.prem_seq_no,
                          b.policy_id,
                          b.peril_cd,
                          a.iss_cd a_iss_cd,
                          d.ri_comm_amt,
                          a.commission_amt,
                          e.currency_rt
                     FROM gipi_uwreports_peril_ext a,
                          gipi_comm_inv_peril b,
                          gipi_invperil d,
                          gipi_invoice e
                    WHERE     a.policy_id = b.policy_id
                          AND a.peril_cd = b.peril_cd
                          AND a.policy_id = e.policy_id
                          AND e.iss_cd = d.iss_cd
                          AND e.prem_seq_no = d.prem_seq_no
                          AND a.user_id = p_user_id
                          AND d.peril_cd = a.peril_cd
                          AND DECODE (p_iss_param,
                                      1, a.cred_branch,
                                      a.iss_cd) = rec.iss_cd
                          AND a.line_cd = rec.line_cd
                          AND subline_cd = rec.subline_cd
                          AND a.peril_cd = rec.peril_cd
                          AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                               OR (p_scope = 1 AND endt_seq_no = 0)
                               OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
               IF rc.a_iss_cd = 'RI'
               THEN
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               ELSE
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                     IN (  SELECT a.acct_ent_date,
                                  b.commission_amt,
                                  b.comm_rec_id,
                                  b.intm_no,
                                  b.comm_peril_id
                             FROM giac_new_comm_inv_peril b,
                                  giac_new_comm_inv a
                            WHERE     1 = 1
                                  AND b.fund_cd = a.fund_cd
                                  AND b.branch_cd = a.branch_cd
                                  AND b.comm_rec_id = a.comm_rec_id
                                  AND b.intm_no = a.intm_no
                                  AND b.peril_cd = rc.peril_cd
                                  AND a.iss_cd = rc.iss_cd
                                  AND a.prem_seq_no = rc.prem_seq_no
                                  AND a.fund_cd = v_fund_cd
                                  AND a.branch_cd = v_branch_cd
                                  AND a.tran_flag = 'P'
                                  AND NVL (a.delete_sw, 'N') = 'N'
                         ORDER BY a.comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                           IN (SELECT commission_amt
                                 FROM giac_prev_comm_inv_peril
                                WHERE     fund_cd = v_fund_cd
                                      AND branch_cd = v_branch_cd
                                      AND comm_rec_id = c1.comm_rec_id
                                      AND intm_no = c1.intm_no
                                      AND comm_peril_id = c1.comm_peril_id)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;
            END LOOP;
         END;*/--Comment out by pjsantos 03/08/2017, for optimization GENQA 5912

         v_gipir946b.iss_name := v_iss_name;
         v_gipir946b.line := rec.line_name;
         v_gipir946b.subline := v_subline;
         v_gipir946b.peril_name := rec.peril_name;
         v_gipir946b.peril_type := rec.peril_type;
         v_gipir946b.tsi_amt := rec.tsi_amt;
         v_gipir946b.prem_amt := rec.prem_amt;
         v_gipir946b.comm_amt := rec.commission_amt/*v_commission*/;--Modified by pjsantos 03/08/2017, for optimization GENQA 5912
         PIPE ROW (v_gipir946b);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir946 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946_type
      PIPELINED
   IS
      v_gipir946         gipir946_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (30);
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE:= giacp.v ('FUND_CD');      --Modified by pjsantos, for optimization GENQA 5912
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE:= giacp.v ('BRANCH_CD');  --Modified by pjsantos, for optimization GENQA 5912
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
   
      --Moved here by pjsants 03/08/2017, for optimization
       SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id;
       --pjsantos end
      FOR rec
         IN (  SELECT DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                      line_cd,
                      line_name,
                      subline_cd,
                      peril_cd,
                      peril_name,
                      peril_type,
                      intm_no,
                      intm_name,
                      SUM (DECODE (peril_type, 'B', tsi_amt, 0)),
                      SUM (tsi_amt) tsi_amt,
                      SUM (prem_amt) prem_amt,
                      SUM(commission_amt) commission_amt--Added by pjsants 03/08/2017, for optimization GENQA 5912
                 FROM gipi_uwreports_peril_ext
                WHERE     user_id = p_user_id
                      AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                             NVL (p_iss_cd,
                                  DECODE (p_iss_param, 1, cred_branch, iss_cd))
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             GROUP BY DECODE (p_iss_param, 1, cred_branch, iss_cd),
                      line_cd,
                      line_name,
                      subline_cd,
                      peril_cd,
                      peril_name,
                      peril_type,
                      intm_no,
                      intm_name)
      LOOP
         --v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
            IN (SELECT subline_name
                  FROM giis_subline
                 WHERE line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get COMM_AMT
         /*BEGIN
            SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
               IN (SELECT b.intrmdry_intm_no,
                          b.iss_cd,
                          b.prem_seq_no,
                          b.policy_id,
                          b.peril_cd,
                          a.iss_cd a_iss_cd,
                          d.ri_comm_amt,
                          commission_amt,
                          e.currency_rt
                     FROM gipi_uwreports_peril_ext a,
                          gipi_comm_inv_peril b,
                          gipi_invperil d,
                          gipi_invoice e
                    WHERE     a.policy_id = b.policy_id
                          AND a.peril_cd = b.peril_cd
                          AND a.policy_id = e.policy_id
                          AND e.iss_cd = d.iss_cd
                          AND e.prem_seq_no = d.prem_seq_no
                          AND a.user_id = p_user_id
                          AND d.peril_cd = a.peril_cd
                          AND DECODE (p_iss_param,
                                      1, a.cred_branch,
                                      a.iss_cd) = rec.iss_cd
                          AND a.line_cd = rec.line_cd
                          AND subline_cd = rec.subline_cd
                          AND a.peril_cd = rec.peril_cd
                          AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                               OR (p_scope = 1 AND endt_seq_no = 0)
                               OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
               IF rc.a_iss_cd = 'RI'
               THEN
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               ELSE
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                     IN (  SELECT a.acct_ent_date,
                                  b.commission_amt,
                                  b.comm_rec_id,
                                  b.intm_no,
                                  b.comm_peril_id
                             FROM giac_new_comm_inv_peril b,
                                  giac_new_comm_inv a
                            WHERE     1 = 1
                                  AND b.fund_cd = a.fund_cd
                                  AND b.branch_cd = a.branch_cd
                                  AND b.comm_rec_id = a.comm_rec_id
                                  AND b.intm_no = a.intm_no
                                  AND b.peril_cd = rc.peril_cd
                                  AND a.iss_cd = rc.iss_cd
                                  AND a.prem_seq_no = rc.prem_seq_no
                                  AND a.fund_cd = v_fund_cd
                                  AND a.branch_cd = v_branch_cd
                                  AND a.tran_flag = 'P'
                                  AND NVL (a.delete_sw, 'N') = 'N'
                         ORDER BY a.comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                           IN (SELECT commission_amt
                                 FROM giac_prev_comm_inv_peril
                                WHERE     fund_cd = v_fund_cd
                                      AND branch_cd = v_branch_cd
                                      AND comm_rec_id = c1.comm_rec_id
                                      AND intm_no = c1.intm_no
                                      AND comm_peril_id = c1.comm_peril_id)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;
            END LOOP;
         END;*/

         v_gipir946.iss_name := v_iss_name;
         v_gipir946.line := rec.line_name;
         v_gipir946.subline := v_subline;
         v_gipir946.peril_name := rec.peril_name;
         v_gipir946.peril_type := rec.peril_type;
         v_gipir946.intm_name := rec.intm_name;
         v_gipir946.tsi_amt := rec.tsi_amt;
         v_gipir946.prem_amt := rec.prem_amt;
         v_gipir946.comm_amt := rec.commission_amt/*v_commission*/;--Modified by pjsantos 03/08/2017, for optimization GENQA 5912
         PIPE ROW (v_gipir946);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir946f (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946f_type
      PIPELINED
   IS
      v_gipir946f   gipir946f_rec_type;
      v_iss_name    VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
      v_intm        VARCHAR2 (275);
   BEGIN
      FOR rec
         IN (  SELECT DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                      a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.intm_no,
                      a.intm_name,
                      SUM (DECODE (a.peril_type, 'B', a.tsi_amt, 0)) tsi_basic,
                      SUM (a.tsi_amt) tsi_amt,
                      SUM (a.prem_amt) prem_amt,
                      b.ref_intm_cd
                 FROM gipi_uwreports_peril_ext a, giis_intermediary b
                WHERE     a.iss_cd <> giacp.v ('RI_ISS_CD')
                      AND a.user_id = p_user_id
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, a.cred_branch,
                                        a.iss_cd))
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
                      AND a.intm_no = b.intm_no
             GROUP BY DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                      a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.intm_no,
                      a.intm_name,
                      b.ref_intm_cd
             ORDER BY b.ref_intm_cd)
      LOOP
         v_intm :=
            rec.ref_intm_cd || '/' || rec.intm_no || ' ' || rec.intm_name;

         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
            IN (SELECT subline_name
                  FROM giis_subline
                 WHERE line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         v_gipir946f.iss_name := v_iss_name;
         v_gipir946f.line := rec.line_name;
         v_gipir946f.subline := v_subline;
         v_gipir946f.agent := v_intm;
         v_gipir946f.tsi_amt := rec.tsi_amt;
         v_gipir946f.prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir946f);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir946d (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946d_type
      PIPELINED
   IS
      v_gipir946d   gipir946d_rec_type;
      v_iss_name    VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
   BEGIN
      FOR rec
         IN (  SELECT line_cd,
                      subline_cd,
                      DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                      line_name,
                      SUM (DECODE (peril_type, 'B', tsi_amt, 0)) tsi_basic,
                      SUM (tsi_amt) tsi_amt,
                      SUM (prem_amt) prem_amt,
                      peril_cd,
                      peril_name,
                      peril_type,
                      intm_no,
                      intm_name
                 FROM gipi_uwreports_peril_ext
                WHERE     user_id = p_user_id
                      AND iss_cd <> giacp.v ('RI_ISS_CD')
                      AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                             NVL (p_iss_cd,
                                  DECODE (p_iss_param, 1, cred_branch, iss_cd))
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             GROUP BY line_cd,
                      subline_cd,
                      DECODE (p_iss_param, 1, cred_branch, iss_cd),
                      line_name,
                      peril_cd,
                      peril_name,
                      peril_type,
                      intm_no,
                      intm_name
             ORDER BY peril_name ASC)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
            IN (SELECT subline_name
                  FROM giis_subline
                 WHERE line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         v_gipir946d.iss_name := v_iss_name;
         v_gipir946d.line := rec.line_name;
         v_gipir946d.subline := v_subline;
         v_gipir946d.agent := rec.intm_name;
         v_gipir946d.peril_name := rec.peril_name;
         v_gipir946d.peril_type := rec.peril_type;
         v_gipir946d.tsi_amt := rec.tsi_amt;
         v_gipir946d.prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir946d);
      END LOOP;

      RETURN;
   END;

   /** ====================================================================================================================================
    **            P  E  R   A  S  S  D  /  I  N  T  M  ( T A B 5 ) R e p o r t s
    ** ================================================================================================================================== */
   FUNCTION get_gipir924a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924a_v2_type
      PIPELINED
   IS
      v_gipir924a       gipir924a_v2_rec_type;
      v_iss_name        VARCHAR2 (50);
      v_extract_basis   VARCHAR2 (100);
   BEGIN
      IF p_iss_param = 1
      THEN
         v_extract_basis := 'Based on Crediting Branch';
      ELSE
         v_extract_basis := 'Based on Issue Source';
      END IF;

      FOR rec
         IN (  SELECT ab.assd_no,
                      ab.assd_name,
                      ab.line_name,
                      ab.subline_name,
                      ab.line_cd,
                      ab.subline_cd,
                      ab.iss_cd,
                      COUNT (DISTINCT ab.policy_id) pol_count,
                      SUM (NVL (ab.total_tsi, 0)) total_tsi,
                      SUM (NVL (ab.total_prem, 0)) total_prem,
                      SUM (NVL (ab.evatprem, 0)) evatprem,
                      SUM (NVL (ab.fst, 0)) fst,
                      SUM (NVL (ab.lgt, 0)) lgt,
                      SUM (NVL (ab.doc_stamps, 0)) doc_stamps,
                      SUM (NVL (ab.other_taxes, 0)) other_taxes,
                      SUM (NVL (ab.total_charges, 0)) total_charges,
                      SUM (NVL (ab.other_charges, 0)) other_charges
                 FROM (SELECT DISTINCT
                              x.assd_no,
                              TRIM (x.assd_name) assd_name,
                              x.line_name,
                              x.subline_name,
                              x.issue_date,
                              x.incept_date,
                              x.expiry_date,
                              x.total_tsi,
                              x.total_prem,
                              x.evatprem,
                              x.fst,
                              x.lgt,
                              x.doc_stamps,
                              x.other_taxes,
                              x.line_cd,
                              x.subline_cd,
                              DECODE (p_iss_param,
                                      1, NVL (x.cred_branch, x.iss_cd),
                                      x.iss_cd)
                                 iss_cd,
                              x.iss_cd actual_iss_cd,
                              x.issue_yy,
                              x.pol_seq_no,
                              x.renew_no,
                              x.endt_seq_no,
                              x.endt_iss_cd,
                              x.endt_yy,
                              x.policy_id,
                              x.prem_seq_no,
                              get_policy_no (x.policy_id) policy_no,
                                NVL (x.total_prem, 0)
                              + NVL (x.evatprem, 0)
                              + NVL (x.fst, 0)
                              + NVL (x.lgt, 0)
                              + NVL (x.doc_stamps, 0)
                              + NVL (x.other_taxes, 0)
                                 total_charges,
                              NVL (x.other_charges, 0) other_charges,
                              x.rec_type,
                              1 pol_cnt
                         FROM gipi_uwreports_intm_ext x
                        WHERE     x.user_id = p_user_id
                              AND DECODE (p_iss_param,
                                          1, NVL (x.cred_branch, x.iss_cd),
                                          x.iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd))
                              AND line_cd = NVL (p_line_cd, line_cd)
                              AND subline_cd = NVL (p_subline_cd, subline_cd)
                              AND assd_no = NVL (p_assd_no, assd_no)
                              AND intm_no = NVL (p_intm_no, intm_no)
                              AND (   (    p_scope = 3
                                       AND endt_seq_no = endt_seq_no)
                                   OR (p_scope = 1 AND endt_seq_no = 0)
                                   OR (p_scope = 2 AND endt_seq_no > 0))) ab
             GROUP BY ab.assd_no,
                      ab.assd_name,
                      ab.line_name,
                      ab.subline_name,
                      ab.line_cd,
                      ab.subline_cd,
                      ab.iss_cd)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir924a.assd_no := rec.assd_no;
         v_gipir924a.extract_basis := v_extract_basis;
         v_gipir924a.assd_name := rec.assd_name;
         v_gipir924a.branch_name := v_iss_name;
         v_gipir924a.line_cd := rec.line_cd;
         v_gipir924a.line_name := rec.line_name;
         v_gipir924a.subline_cd := rec.subline_cd;
         v_gipir924a.subline_name := rec.subline_name;
         v_gipir924a.pol_count := rec.pol_count;
         v_gipir924a.total_tsi := rec.total_tsi;
         v_gipir924a.total_prem := rec.total_prem;
         v_gipir924a.evatprem := rec.evatprem;
         v_gipir924a.lgt := rec.lgt;
         v_gipir924a.doc_stamps := rec.doc_stamps;
         v_gipir924a.fire_service_tax := rec.fst;
         v_gipir924a.other_charges := rec.other_taxes;
         v_gipir924a.total_amt_due :=
              rec.total_prem
            + rec.evatprem
            + rec.lgt
            + rec.doc_stamps
            + rec.fst
            + rec.other_taxes;
         PIPE ROW (v_gipir924a);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir923a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir923a_type
      PIPELINED
   IS
      v_gipir923a          gipir923a_rec_type;
      v_iss_name           giis_issource.iss_name%TYPE;
      v_cred_branch_name   giis_issource.iss_name%TYPE;
   BEGIN
      FOR rec
         IN (  SELECT ab.assd_no,
                      ab.assd_name,
                      ab.line_name,
                      ab.subline_name,
                      ab.issue_date,
                      ab.incept_date,
                      ab.expiry_date,
                      ab.line_cd,
                      ab.subline_cd,
                      ab.iss_cd,
                      ab.actual_iss_cd,
                      ab.issue_yy,
                      ab.pol_seq_no,
                      ab.renew_no,
                      ab.endt_seq_no,
                      ab.endt_iss_cd,
                      ab.endt_yy,
                      ab.policy_id,
                      ab.policy_no,
                      SUM (NVL (ab.total_tsi, 0)) total_tsi,
                      SUM (NVL (ab.total_prem, 0)) total_prem,
                      SUM (NVL (ab.evatprem, 0)) evatprem,
                      SUM (NVL (ab.fst, 0)) fst,
                      SUM (NVL (ab.lgt, 0)) lgt,
                      SUM (NVL (ab.doc_stamps, 0)) doc_stamps,
                      SUM (NVL (ab.other_taxes, 0)) other_taxes,
                      SUM (NVL (ab.total_charges, 0)) total_charges,
                      ab.rec_type,
                      ab.cred_branch
                 FROM (SELECT DISTINCT
                              x.assd_no,
                              TRIM (x.assd_name) assd_name,
                              x.line_name,
                              x.subline_name,
                              x.issue_date,
                              x.incept_date,
                              x.expiry_date,
                              x.total_tsi,
                              x.total_prem,
                              x.evatprem,
                              x.fst,
                              x.lgt,
                              x.doc_stamps,
                              x.other_taxes,
                              x.line_cd,
                              x.subline_cd,
                              DECODE (p_iss_param,
                                      1, NVL (x.cred_branch, x.iss_cd),
                                      x.iss_cd)
                                 iss_cd,
                              x.iss_cd actual_iss_cd,
                              x.issue_yy,
                              x.pol_seq_no,
                              x.renew_no,
                              x.endt_seq_no,
                              x.endt_iss_cd,
                              x.endt_yy,
                              x.policy_id,
                              x.prem_seq_no,
                              get_policy_no (x.policy_id) policy_no,
                                NVL (x.total_prem, 0)
                              + NVL (x.evatprem, 0)
                              + NVL (x.fst, 0)
                              + NVL (x.lgt, 0)
                              + NVL (x.doc_stamps, 0)
                              + NVL (x.other_taxes, 0)
                                 total_charges,
                              x.rec_type,
                              x.cred_branch
                         FROM gipi_uwreports_intm_ext x
                        WHERE     x.user_id = p_user_id
                              AND DECODE (p_iss_param,
                                          1, NVL (x.cred_branch, x.iss_cd),
                                          x.iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd))
                              AND line_cd = NVL (p_line_cd, line_cd)
                              AND subline_cd = NVL (p_subline_cd, subline_cd)
                              AND assd_no = NVL (p_assd_no, assd_no)
                              AND intm_no = NVL (p_intm_no, intm_no)
                              AND (   (    p_scope = 3
                                       AND endt_seq_no = endt_seq_no)
                                   OR (p_scope = 1 AND endt_seq_no = 0)
                                   OR (p_scope = 2 AND endt_seq_no > 0))) ab
             GROUP BY ab.assd_no,
                      ab.assd_name,
                      ab.line_name,
                      ab.subline_name,
                      ab.issue_date,
                      ab.incept_date,
                      ab.expiry_date,
                      ab.line_cd,
                      ab.subline_cd,
                      ab.iss_cd,
                      ab.actual_iss_cd,
                      ab.issue_yy,
                      ab.pol_seq_no,
                      ab.renew_no,
                      ab.endt_seq_no,
                      ab.endt_iss_cd,
                      ab.endt_yy,
                      ab.policy_id,
                      ab.policy_no,
                      ab.rec_type,
                      ab.cred_branch
             ORDER BY ab.assd_name,
                      ab.assd_no,
                      ab.iss_cd,
                      ab.line_cd,
                      ab.subline_cd,
                      ab.actual_iss_cd,
                      ab.issue_yy,
                      ab.pol_seq_no,
                      ab.renew_no,
                      ab.endt_seq_no,
                      ab.rec_type)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.actual_iss_cd;

            v_iss_name := v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;


         --get CRED_BRANCH_NAME
         BEGIN
            SELECT iss_name
              INTO v_cred_branch_name
              FROM giis_issource
             WHERE iss_cd = rec.cred_branch;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_cred_branch_name := '';
         END;

         v_gipir923a.assd_name := rec.assd_name;
         v_gipir923a.assd_no := rec.assd_no;
         v_gipir923a.iss_cd := rec.iss_cd;
         v_gipir923a.iss_name := v_iss_name;
         v_gipir923a.cred_branch := rec.cred_branch;
         v_gipir923a.cred_branch_name := v_cred_branch_name;
         v_gipir923a.line_cd := rec.line_cd;
         v_gipir923a.line_name := rec.line_name;
         v_gipir923a.subline_cd := rec.subline_cd;
         v_gipir923a.subline_name := rec.subline_name;
         v_gipir923a.policy_no := rec.policy_no;
         v_gipir923a.issue_date := rec.issue_date;
         v_gipir923a.incept_date := rec.incept_date;
         v_gipir923a.expiry_date := rec.expiry_date;
         v_gipir923a.total_tsi := rec.total_tsi;
         v_gipir923a.total_prem := rec.total_prem;
         v_gipir923a.evatprem := rec.evatprem;
         v_gipir923a.lgt := rec.lgt;
         v_gipir923a.doc_stamps := rec.doc_stamps;
         v_gipir923a.fire_service_tax := rec.fst;
         v_gipir923a.other_charges := rec.other_taxes;
         v_gipir923a.total_amt_due := rec.total_charges;
         PIPE ROW (v_gipir923a);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir924b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924b_type
      PIPELINED
   IS
      v_gipir924b       gipir924b_rec_type;
      v_iss_name        VARCHAR2 (50);
      v_intm_type       VARCHAR2 (20);
      --commission
      v_to_date         DATE;
      v_extract_basis   VARCHAR2 (100);
   BEGIN
      IF p_iss_param = 1
      THEN
         v_extract_basis := 'Based on Crediting Branch';
      ELSE
         v_extract_basis := 'Based on Issue Source';
      END IF;

      FOR rec
         IN (  SELECT a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.subline_name,
                      DECODE (p_iss_param,
                              1, NVL (a.cred_branch, a.iss_cd),
                              a.iss_cd)
                         iss_cd,
                      SUM (NVL (a.total_tsi, 0)) total_tsi,
                      SUM (NVL (a.total_prem, 0)) total_prem,
                      SUM (NVL (a.evatprem, 0)) evatprem,
                      SUM (NVL (a.lgt, 0)) lgt,
                      SUM (NVL (a.doc_stamps, 0)) doc_stamps,
                      SUM (NVL (a.fst, 0)) fst,
                      SUM (NVL (a.other_taxes, 0)) other_taxes,
                      SUM (NVL (a.other_charges, 0)) other_charges,
                      a.param_date,
                      a.from_date,
                      a.TO_DATE,
                      a.scope,
                      a.user_id,
                      a.intm_no,
                      a.intm_name,
                        SUM (NVL (a.total_prem, 0))
                      + SUM (NVL (a.evatprem, 0))
                      + SUM (NVL (a.lgt, 0))
                      + SUM (NVL (a.doc_stamps, 0))
                      + SUM (NVL (a.fst, 0))
                      + SUM (NVL (a.other_taxes, 0))
                      + SUM (NVL (a.other_charges, 0))
                         total,
                      COUNT (DISTINCT a.policy_id) polcount,
                      SUM (NVL (a.comm_amt, 0)) commission,
                      a.intm_type,
                      SUM (NVL (a.prem_share_amt, 0)) prem_share_amt
                 FROM gipi_uwreports_intm_ext a
                WHERE     a.user_id = p_user_id
                      AND assd_no = NVL (p_assd_no, assd_no)
                      AND intm_no = NVL (p_intm_no, intm_no)
                      AND intm_type = NVL (p_intm_type, intm_type)
                      AND DECODE (p_iss_param,
                                  1, NVL (a.cred_branch, a.iss_cd),
                                  a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, NVL (a.cred_branch, a.iss_cd),
                                        a.iss_cd))
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             GROUP BY line_cd,
                      line_name,
                      subline_cd,
                      subline_name,
                      DECODE (p_iss_param,
                              1, NVL (a.cred_branch, a.iss_cd),
                              a.iss_cd),
                      param_date,
                      a.from_date,
                      a.TO_DATE,
                      scope,
                      a.user_id,
                      intm_no,
                      intm_name,
                      a.intm_type
             ORDER BY DECODE (p_iss_param,
                              1, NVL (a.cred_branch, a.iss_cd),
                              a.iss_cd),
                      intm_type,
                      intm_no,
                      intm_name,
                      line_name,
                      subline_name)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get INTM_TYPE
         BEGIN
            SELECT intm_desc
              INTO v_intm_type
              FROM giis_intm_type
             WHERE intm_type = rec.intm_type;
         END;


         v_gipir924b.extract_basis := v_extract_basis;
         v_gipir924b.branch_name := v_iss_name;
         v_gipir924b.intm_type := v_intm_type;

         v_gipir924b.intm_no := rec.intm_no;
         v_gipir924b.intm_name := rec.intm_name;
         v_gipir924b.line_cd := rec.line_cd;
         v_gipir924b.line_name := rec.line_name;
         v_gipir924b.subline_cd := rec.subline_cd;
         v_gipir924b.subline_name := rec.subline_name;
         v_gipir924b.pol_count := rec.polcount;
         v_gipir924b.total_tsi := rec.total_tsi;
         v_gipir924b.total_prem := rec.total_prem;
         v_gipir924b.prem_share_amt := rec.prem_share_amt;
         v_gipir924b.vatprem := rec.evatprem;
         v_gipir924b.lgt := rec.lgt;
         v_gipir924b.doc_stamps := rec.doc_stamps;
         v_gipir924b.fire_service_tax := rec.fst;
         v_gipir924b.other_charges := rec.other_taxes;
         v_gipir924b.total_amt_due := rec.total;
         v_gipir924b.commission := rec.commission;
         PIPE ROW (v_gipir924b);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir923b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir923b_type
      PIPELINED
   IS
      v_gipir923b          gipir923b_rec_type;
      v_iss_name           VARCHAR2 (50);
      v_intm_type          VARCHAR2 (20);
      --policy_no
      v_policy_no          VARCHAR2 (150);
      v_endt_no            VARCHAR2 (100);
      v_ref_pol_no         VARCHAR2 (100) := NULL;
      --commission
      v_to_date            DATE;
      v_comm_amt           NUMBER (20, 2);
      v_cred_branch_name   giis_issource.iss_name%TYPE;
   BEGIN
      FOR rec
         IN (  SELECT a.assd_no,
                      a.assd_name,
                      a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.subline_name,
                      DECODE (p_iss_param,
                              1, NVL (a.cred_branch, a.iss_cd),
                              a.iss_cd)
                         iss_cd,
                      a.iss_cd iss_cd2,
                      a.cred_branch,
                      a.issue_yy,
                      a.pol_seq_no,
                      a.renew_no,
                      a.endt_iss_cd,
                      a.endt_yy,
                      a.endt_seq_no,
                      a.incept_date,
                      a.expiry_date,
                      a.total_tsi,
                      a.total_prem,
                      a.evatprem,
                      a.lgt,
                      a.doc_stamps,
                      a.fst,
                      a.other_taxes,
                      a.other_charges,
                      a.param_date,
                      a.from_date,
                      a.TO_DATE,
                      a.scope,
                      a.user_id,
                      a.policy_id,
                      a.intm_name,
                      a.intm_no,
                        a.total_prem
                      + a.evatprem
                      + a.lgt
                      + a.doc_stamps
                      + a.fst
                      + a.other_taxes
                         total,
                      a.comm_amt commission,
                         a.iss_cd
                      || '-'
                      || a.prem_seq_no
                      || DECODE (NVL (a.ref_inv_no, ' '),
                                 ' ', ' ',
                                 ' / ' || a.ref_inv_no)
                         ref_inv_no,
                      a.intm_type,
                      a.prem_share_amt
                 FROM gipi_uwreports_intm_ext a
                WHERE     1 = 1
                      AND a.user_id = p_user_id
                      AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, a.cred_branch,
                                        a.iss_cd))
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND assd_no = NVL (p_assd_no, assd_no)
                      AND intm_no = NVL (p_intm_no, intm_no)
                      AND intm_type = NVL (p_intm_type, intm_type)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             ORDER BY DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                      a.intm_type,
                      a.intm_no,
                      a.line_cd,
                      subline_cd,
                      issue_yy,
                      pol_seq_no,
                      renew_no,
                      endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd2;

            v_iss_name := v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;


         --get CRED_BRANCH
         BEGIN
            SELECT iss_name
              INTO v_cred_branch_name
              FROM giis_issource
             WHERE iss_cd = rec.cred_branch;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_cred_branch_name := '';
         END;

         --get INTM_TYPE
         BEGIN
            SELECT intm_desc
              INTO v_intm_type
              FROM giis_intm_type
             WHERE intm_type = rec.intm_type;
         END;

         --get POLICY_NO
         BEGIN
            v_policy_no :=
                  rec.line_cd
               || '-'
               || rec.subline_cd
               || '-'
               || LTRIM (rec.iss_cd2)
               || '-'
               || LTRIM (TO_CHAR (rec.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.pol_seq_no))
               || '-'
               || LTRIM (TO_CHAR (rec.renew_no, '09'));

            IF rec.endt_seq_no <> 0
            THEN
               v_endt_no :=
                     rec.endt_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (rec.endt_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.endt_seq_no));
            END IF;

            BEGIN
               SELECT ref_pol_no
                 INTO v_ref_pol_no
                 FROM gipi_polbasic
                WHERE policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         v_gipir923b.iss_name := v_iss_name;
         v_gipir923b.iss_cd := rec.iss_cd2;
         v_gipir923b.cred_branch := rec.cred_branch;
         v_gipir923b.cred_branch_name := v_cred_branch_name;
         v_gipir923b.invoice_no := rec.ref_inv_no;
         v_gipir923b.intm_type := v_intm_type;
         v_gipir923b.incept_date := rec.incept_date;
         v_gipir923b.intm_no := rec.intm_no;
         v_gipir923b.expiry_date := rec.expiry_date;
         v_gipir923b.intm_no := rec.intm_no;
         v_gipir923b.intm_name := rec.intm_name;
         v_gipir923b.line_cd := rec.line_cd;
         v_gipir923b.line_name := rec.line_name;
         v_gipir923b.subline_cd := rec.subline_cd;
         v_gipir923b.subline_name := rec.subline_name;
         v_gipir923b.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir923b.assured_name := rec.assd_name;
         v_gipir923b.assd_no := rec.assd_no;


         v_gipir923b.total_tsi := rec.total_tsi;
         v_gipir923b.total_prem := rec.total_prem;
         v_gipir923b.premium_shr_amt := rec.prem_share_amt;
         v_gipir923b.evatprem := rec.evatprem;
         v_gipir923b.lgt := rec.lgt;
         v_gipir923b.doc_stamps := rec.doc_stamps;
         v_gipir923b.fire_service_tax := rec.fst;
         v_gipir923b.other_charges := rec.other_taxes;
         v_gipir923b.total_amt_due := rec.total;
         v_gipir923b.commission := rec.commission;

         PIPE ROW (v_gipir923b);
      END LOOP;

      RETURN;
   END;

   /** ====================================================================================================================================
    **            I  N  W  A  R  D   R  I   ( T A B  8)
    ** ================================================================================================================================== */
   FUNCTION get_gipir929b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir929b_type
      PIPELINED
   IS
      v_gipir929b    gipir929b_rec_type;
      v_iss_name     VARCHAR2 (50);
      --policy_no
      v_policy_no    VARCHAR2 (150);
      v_endt_no      VARCHAR2 (100);
      v_ref_pol_no   VARCHAR2 (100) := NULL;
   BEGIN
      FOR rec
         IN (  SELECT a.ri_name,
                      a.ri_cd,
                      a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.subline_name,
                      DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                      a.issue_yy,
                      a.pol_seq_no,
                      a.renew_no,
                      a.endt_iss_cd,
                      a.endt_yy,
                      a.endt_seq_no,
                      a.incept_date,
                      a.expiry_date,
                      a.total_tsi,
                      a.total_prem,
                      a.evatprem,
                      a.lgt,
                      a.doc_stamps,
                      a.fst,
                      a.other_taxes,
                      a.other_charges,
                      a.param_date,
                      a.from_date,
                      a.TO_DATE,
                      a.scope,
                      a.user_id,
                      a.policy_id,
                        a.total_prem
                      + a.evatprem
                      + a.lgt
                      + a.doc_stamps
                      + a.fst
                      + a.other_taxes 
                      - NVL(a.ri_comm_amt, 0) --added by gab 03.14. 2016 SR 21513
                      - NVL(a.ri_comm_vat, 0) 
                         total,
--                      SUM (b.ri_comm_amt) commission,
--                      c.ri_comm_vat ri_comm_vat
                      NVL(a.ri_comm_amt,0) commission,
                      NVL(a.ri_comm_vat,0) ri_comm_vat --modified by gab 02.29.2016 SR 21513 
                 FROM gipi_uwreports_inw_ri_ext a
--                      gipi_itmperil b,
--                      gipi_invoice c 
--                WHERE     a.policy_id = b.policy_id(+)
--                      AND a.policy_id = c.policy_id
--                      AND a.user_id = p_user_id
                    WHERE a.user_id = p_user_id --modified by gab 03.21.2016 SR 21513
                      AND NVL (a.cred_branch, 'x') =
                             NVL (p_iss_cd, NVL (a.cred_branch, 'x'))
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND ri_cd = NVL (p_ri_cd, ri_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
                           --commented out by gab 03.23.2016 SR 21513
--             GROUP BY a.ri_name,
--                      a.ri_cd,
--                      a.line_cd,
--                      a.line_name,
--                      a.subline_cd,
--                      a.subline_name,
--                      DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
--                      a.issue_yy,
--                      a.pol_seq_no,
--                      a.renew_no,
--                      a.endt_iss_cd,
--                      a.endt_yy,
--                      a.endt_seq_no,
--                      a.incept_date,
--                      a.expiry_date,
--                      a.total_tsi,
--                      a.total_prem,
--                      a.evatprem,
--                      a.lgt,
--                      a.doc_stamps,
--                      a.fst,
--                      a.other_taxes,
--                      a.other_charges,
--                      a.param_date,
--                      a.from_date,
--                      a.TO_DATE,
--                      a.scope,
--                      a.user_id,
--                      a.policy_id,
--                        a.total_prem
--                      + a.evatprem
--                      + a.lgt
--                      + a.doc_stamps
--                      + a.fst
--                      + a.other_taxes,
--                      a.cred_branch,
--                      c.ri_comm_vat
                        --end
             ORDER BY a.ri_cd,
                      a.line_name,
                      a.subline_name,
                      a.cred_branch,
                      issue_yy,
                      pol_seq_no,
                      renew_no,
                      endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get POLICY_NO
         BEGIN
            v_policy_no :=
                  rec.line_cd
               || '-'
               || rec.subline_cd
               || '-'
               || rec.iss_cd
               || '-'
               || LPAD (TO_CHAR (rec.issue_yy), 2, '0')
               || '-'
               || LPAD (TO_CHAR (rec.pol_seq_no), 7, '0')
               || '-'
               || LPAD (TO_CHAR (rec.renew_no), 2, '0');

            IF rec.endt_seq_no <> 0
            THEN
               v_endt_no :=
                     rec.endt_iss_cd
                  || '-'
                  || LPAD (TO_CHAR (rec.endt_yy), 2, '0')
                  || '-'
                  || LPAD (TO_CHAR (rec.endt_seq_no), 7, '0');
            END IF;

            BEGIN
               SELECT ref_pol_no
                 INTO v_ref_pol_no
                 FROM gipi_polbasic
                WHERE policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         v_gipir929b.iss_name := v_iss_name;
         v_gipir929b.intm_name := rec.ri_cd || ' - ' || rec.ri_name;
         v_gipir929b.line := rec.line_name;
         v_gipir929b.subline := rec.subline_name;
         v_gipir929b.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir929b.incept_date := rec.incept_date;
         v_gipir929b.total_tsi := rec.total_tsi;
         v_gipir929b.total_prem := rec.total_prem;
         v_gipir929b.evatprem := rec.evatprem;
         v_gipir929b.lgt := rec.lgt;
         v_gipir929b.doc_stamps := rec.doc_stamps;
         v_gipir929b.fire_service_tax := rec.fst;
         v_gipir929b.other_charges := rec.other_taxes;
         v_gipir929b.total := rec.total;
         v_gipir929b.commission := rec.commission;
         v_gipir929b.ri_comm_vat := rec.ri_comm_vat;
         PIPE ROW (v_gipir929b);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir929a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir929a_type
      PIPELINED
   IS
      v_gipir929a    gipir929a_rec_type;
      v_iss_name     VARCHAR2 (50);
      --policy_no
      v_policy_no    VARCHAR2 (150);
      v_endt_no      VARCHAR2 (100);
      v_ref_pol_no   VARCHAR2 (100) := NULL;
   BEGIN
      FOR rec
         IN (  SELECT a.ri_cd,
                      a.ri_name,
                      a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.subline_name,
                      a.cred_branch iss_cd,
                      SUM (a.total_tsi) total_tsi,
                      SUM (a.total_prem) total_prem,
                      SUM (a.evatprem) evatprem,
                      SUM (a.lgt) lgt,
                      SUM (a.doc_stamps) doc_stamps,
                      SUM (a.fst) fst,
                      SUM (a.other_taxes) other_taxes,
                      SUM (a.other_charges) other_charges,
                      a.param_date,
                      a.from_date,
                      a.TO_DATE,
                      a.scope,
                      a.user_id,
                        SUM (a.total_prem)
                      + SUM (a.evatprem)
                      + SUM (a.lgt)
                      + SUM (a.doc_stamps)
                      + SUM (a.fst)
                      + SUM (a.other_taxes)
                      + SUM (a.other_charges)
                      - NVL(a.ri_comm_amt, 0)
                      - NVL(a.ri_comm_vat, 0) --added by gab 03.14.2016 SR 21513
                         total,
                      COUNT (a.policy_id) pol_count,
                      --SUM (B.commission) commission, -- modified by gab 02.29.2016 SR 21513
                      --SUM (c.ri_comm_vat) ri_comm_vat
                      SUM (a.ri_comm_amt) commission,
                      SUM (a.ri_comm_vat) ri_comm_vat
                 FROM gipi_uwreports_inw_ri_ext a
                /*,
                       (  SELECT   x.policy_id,
                                   x.line_cd,
                                   x.subline_cd,
                                   SUM (y.ri_comm_amt) commission
                            FROM   gipi_uwreports_inw_ri_ext x, gipi_itmperil y
                           WHERE   x.policy_id = y.policy_id AND x.user_id = p_user_id --added by aliza 03/24/2013 to avoide adding comm of policies extracted by multiple users
                        GROUP BY   x.line_cd, x.subline_cd, x.policy_id) b,
                       gipi_invoice c
               WHERE       a.policy_id = b.policy_id(+)
                       AND a.policy_id = c.policy_id
                       AND*/
                WHERE     a.user_id = p_user_id
                      AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                      AND NVL (a.cred_branch, 'x') =
                             NVL (p_iss_cd, NVL (a.cred_branch, 'x'))
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
             GROUP BY a.line_cd,
                      a.line_name,
                      a.subline_cd,
                      a.subline_name,
                      a.cred_branch,
                      param_date,
                      a.from_date,
                      a.TO_DATE,
                      scope,
                      a.user_id,
                      a.ri_cd,
                      a.ri_name,
                      a.ri_comm_amt,
                      a.ri_comm_vat --added by gab 03.21.2016 SR 21513
             ORDER BY a.cred_branch,
                      a.ri_name,
                      a.line_name,
                      a.subline_name)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir929a.iss_name := v_iss_name;
         v_gipir929a.intm_name := rec.ri_name;
         v_gipir929a.line := rec.line_name;
         v_gipir929a.subline := rec.subline_name;
         v_gipir929a.pol_count := rec.pol_count;
         v_gipir929a.total_tsi := rec.total_tsi;
         v_gipir929a.total_prem := rec.total_prem;
         v_gipir929a.evatprem := rec.evatprem;
         v_gipir929a.lgt := rec.lgt;
         v_gipir929a.doc_stamps := rec.doc_stamps;
         v_gipir929a.fire_service_tax := rec.fst;
         v_gipir929a.other_charges := rec.other_taxes;
         v_gipir929a.total := rec.total;
         v_gipir929a.commission := rec.commission;
         v_gipir929a.ri_comm_vat := rec.ri_comm_vat;
         PIPE ROW (v_gipir929a);
      END LOOP;

      RETURN;
   END;

   /** ====================================================================================================================================
    **            U N D I S T R I B U T E D
    ** ================================================================================================================================== */
   FUNCTION get_gipir924c (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924c_type
      PIPELINED
   IS
      v_gipir924c   gipir924c_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT c.dist_flag,
                      r.rv_meaning,
                      l.line_name,
                      s.subline_name,
                      DECODE (
                         b.endt_seq_no,
                         0,    b.line_cd
                            || '-'
                            || b.subline_cd
                            || '-'
                            || b.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (b.issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM (TO_CHAR (b.renew_no, '09')),
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09'))
                         || '/'
                         || b.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.endt_seq_no, '099999')))
                         policy_no,
                      b.issue_date,
                      b.incept_date,
                      SUBSTR (a.assd_name, 1, 50) assd_name,
                      b.tsi_amt,
                      b.prem_amt,
                      b.policy_id
                 FROM cg_ref_codes r,
                      giis_line l,
                      gipi_polbasic b,
                      giuw_pol_dist c,
                      giis_subline s,
                      giis_assured a,
                      gipi_parlist p
                WHERE     r.rv_low_value = b.dist_flag
                      AND r.rv_low_value IN ('1', '2')
                      AND c.dist_flag IN ('1', '2')
                      AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'
                      AND b.iss_cd IN
                             (SELECT iss_cd
                                FROM giis_issource
                               WHERE (   (    iss_cd = giacp.v ('REINSURER')
                                          AND p_direct <> 1
                                          AND p_ri = 1)
                                      OR (    iss_cd <> giacp.v ('REINSURER')
                                          AND p_direct = 1
                                          AND p_ri <> 1)
                                      OR (1 = 1 AND p_direct = 1 AND p_ri = 1)))
                      AND l.line_cd = b.line_cd
                      AND b.policy_id = c.policy_id
                      AND s.subline_cd = b.subline_cd
                      AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, b.cred_branch,
                                        b.iss_cd))
                      AND s.line_cd = l.line_cd
                      AND a.assd_no = b.assd_no
                      AND p.par_id = b.par_id
                      AND b.pol_flag <> '5'
                      AND NVL (b.endt_type, 0) <> 'N'
                      AND s.op_flag <> 'Y'
                      AND p.line_cd = NVL (p_line_cd, p.line_cd)
                      AND b.policy_id > 0
             ORDER BY r.rv_meaning,
                      l.line_name,
                      s.subline_name,
                      b.line_cd,
                      b.subline_cd,
                      b.iss_cd,
                      b.issue_yy,
                      b.pol_seq_no,
                      b.renew_no,
                      a.assd_name)
      LOOP
         v_gipir924c.rv_meaning := rec.rv_meaning;
         v_gipir924c.line := rec.line_name;
         v_gipir924c.subline := rec.subline_name;
         v_gipir924c.policy_no := rec.policy_no;
         v_gipir924c.assured := rec.assd_name;
         v_gipir924c.issue_date := rec.issue_date;
         v_gipir924c.incept_date := rec.incept_date;
         v_gipir924c.tsi_amt := rec.tsi_amt;
         v_gipir924c.prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir924c);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir924d (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924d_type
      PIPELINED
   IS
      v_gipir924d   gipir924d_rec_type;
      v_iss_name    VARCHAR2 (50);
   BEGIN
      FOR rec
         IN (  SELECT c.dist_flag,
                      r.rv_meaning,
                      l.line_name,
                      s.subline_name,
                      DECODE (
                         b.endt_seq_no,
                         0,    b.line_cd
                            || '-'
                            || b.subline_cd
                            || '-'
                            || b.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (b.issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM (TO_CHAR (b.renew_no, '09')),
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09'))
                         || '/'
                         || b.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.endt_seq_no, '099999')))
                         policy_no,
                      b.issue_date,
                      b.incept_date,
                      SUBSTR (a.assd_name, 1, 50) assd_name,
                      b.tsi_amt,
                      b.prem_amt,
                      DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd
                 FROM cg_ref_codes r,
                      giis_line l,
                      gipi_polbasic b,
                      giuw_pol_dist c,
                      giis_subline s,
                      giis_assured a,
                      gipi_parlist p
                WHERE     r.rv_low_value = b.dist_flag
                      AND r.rv_low_value IN ('1', '2', '4')
                      AND c.dist_flag IN ('1', '2', '4')
                      AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'
                      AND b.iss_cd IN
                             (SELECT iss_cd
                                FROM giis_issource
                               WHERE (   (    iss_cd = giacp.v ('REINSURER')
                                          AND p_direct <> 1
                                          AND p_ri = 1)
                                      OR (    iss_cd <> giacp.v ('REINSURER')
                                          AND p_direct = 1
                                          AND p_ri <> 1)
                                      OR (1 = 1 AND p_direct = 1 AND p_ri = 1)))
                      AND l.line_cd = b.line_cd
                      AND s.subline_cd = b.subline_cd
                      AND s.line_cd = l.line_cd
                      AND a.assd_no = b.assd_no
                      AND p.par_id = b.par_id
                      AND b.policy_id = c.policy_id
                      AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, b.cred_branch,
                                        b.iss_cd))
                      AND b.pol_flag <> '5'
                      AND NVL (b.endt_type, 0) <> 'N'
                      AND b.subline_cd <> 'MOP'
                      AND b.line_cd = NVL (p_line_cd, b.line_cd)
             ORDER BY DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                      r.rv_meaning,
                      l.line_name,
                      s.subline_name,
                      b.line_cd,
                      b.subline_cd,
                      b.iss_cd,
                      b.issue_yy,
                      b.pol_seq_no,
                      b.renew_no,
                      a.assd_name)
      LOOP
         --get ISS_NAME
         BEGIN
            BEGIN
               SELECT iss_name
                 INTO v_iss_name
                 FROM giis_issource
                WHERE iss_cd = rec.iss_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_iss_name := 'No branch name';
            END;
         END;

         v_gipir924d.iss_name := v_iss_name;
         v_gipir924d.rv_meaning := rec.rv_meaning;
         v_gipir924d.line := rec.line_name;
         v_gipir924d.subline := rec.subline_name;
         v_gipir924d.policy_no := rec.policy_no;
         v_gipir924d.assured := rec.assd_name;
         v_gipir924d.issue_date := rec.issue_date;
         v_gipir924d.incept_date := rec.incept_date;
         v_gipir924d.tsi_amt := rec.tsi_amt;
         v_gipir924d.prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir924d);
      END LOOP;

      RETURN;
   END;

   /** ====================================================================================================================================
    **            P  O  L  I  C  Y   R  E  G  I  S  T  E  R
    ** ================================================================================================================================== */
   FUNCTION get_gipir924f (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924f_type
      PIPELINED
   IS
      v_gipir924f        gipir924f_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (50);
      v_param_v          VARCHAR2 (1);
      v_total            NUMBER (38, 2);
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
         IN (  SELECT line_cd,
                      subline_cd,
                      SUM (NVL (DECODE (spld_date, NULL, a.total_tsi, 0), 0))
                         total_si,
                      DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                      SUM (NVL (DECODE (spld_date, NULL, a.total_prem, 0), 0))
                         total_prem,
                      SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                         evatprem,
                      SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0)) fst,
                      SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0)) lgt,
                      SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                         doc_stamps,
                      SUM (NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0))
                         other_taxes,
                      SUM (
                         NVL (DECODE (spld_date, NULL, a.other_charges, 0), 0))
                         other_charges,
                        SUM (
                           NVL (DECODE (spld_date, NULL, a.total_prem, 0), 0))
                      + SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                      + SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0))
                      + SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0))
                      + SUM (
                           NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                      + SUM (
                           NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0))
                      + SUM (
                           NVL (DECODE (spld_date, NULL, a.other_charges, 0),
                                0))
                         total,
                      COUNT (DECODE (spld_date, NULL, 1, 0)) pol_count,
                        SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                      + SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0))
                      + SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0))
                      + SUM (
                           NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                      + SUM (
                           NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0))
                      + SUM (
                           NVL (DECODE (spld_date, NULL, a.other_charges, 0),
                                0))
                         total_taxes,
                      SUM (NVL (DECODE (spld_date, NULL, b.commission, 0), 0))
                         commission
                 FROM gipi_uwreports_ext a,
                      (  SELECT SUM (
                                   DECODE (
                                      c.ri_comm_amt * c.currency_rt,
                                      0, NVL (b.commission_amt * c.currency_rt,
                                              0),
                                      c.ri_comm_amt * c.currency_rt))
                                   commission,
                                c.policy_id policy_id
                           FROM gipi_comm_invoice b, gipi_invoice c
                          WHERE b.policy_id = c.policy_id
                       GROUP BY c.policy_id) b
                WHERE     a.policy_id = b.policy_id(+)
                      AND a.user_id = p_user_id
                      AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, a.cred_branch,
                                        a.iss_cd))
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
             GROUP BY line_cd,
                      subline_cd,
                      DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd))
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
            IN (SELECT subline_name
                  FROM giis_subline
                 WHERE line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get TOTAL
         SELECT giacp.v ('SHOW_TOTAL_TAXES') INTO v_param_v FROM DUAL;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total;
         END IF;

         --get COMMISSION
         BEGIN
            SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_ext
             WHERE user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
               IN (SELECT b.intrmdry_intm_no,
                          b.iss_cd,
                          b.prem_seq_no,
                          c.ri_comm_amt,
                          c.currency_rt,
                          b.commission_amt,
                          a.spld_date
                     FROM gipi_comm_invoice b,
                          gipi_invoice c,
                          gipi_uwreports_ext a
                    WHERE     a.policy_id = b.policy_id
                          AND a.policy_id = c.policy_id
                          AND a.user_id = p_user_id
                          AND DECODE (p_iss_param,
                                      1, a.cred_branch,
                                      a.iss_cd) = rec.iss_cd
                          AND a.line_cd = rec.line_cd
                          AND a.subline_cd = rec.subline_cd)
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                     IN (  SELECT acct_ent_date,
                                  commission_amt,
                                  comm_rec_id,
                                  intm_no
                             FROM giac_new_comm_inv
                            WHERE     iss_cd = rc.iss_cd
                                  AND prem_seq_no = rc.prem_seq_no
                                  AND fund_cd = v_fund_cd
                                  AND branch_cd = v_branch_cd
                                  AND tran_flag = 'P'
                                  AND NVL (delete_sw, 'N') = 'N'
                         ORDER BY comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                           IN (SELECT commission_amt
                                 FROM giac_prev_comm_inv
                                WHERE     fund_cd = v_fund_cd
                                      AND branch_cd = v_branch_cd
                                      AND comm_rec_id = c1.comm_rec_id
                                      AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;

               IF rc.spld_date IS NOT NULL
               THEN
                  v_commission := 0;
                  EXIT;
               END IF;
            END LOOP;
         END;

         v_gipir924f.iss_name := v_iss_name;
         v_gipir924f.line := rec.line_cd;
         v_gipir924f.subline := v_subline;
         v_gipir924f.pol_count := rec.pol_count;
         v_gipir924f.tot_sum_insured := rec.total_si;
         v_gipir924f.tot_premium := rec.total_prem;
         v_gipir924f.evat := rec.evatprem;
         v_gipir924f.lgt := rec.lgt;
         v_gipir924f.doc_stamps := rec.doc_stamps;
         v_gipir924f.fire_service_tax := rec.fst;
         v_gipir924f.other_charges := rec.other_taxes;
         v_gipir924f.total := v_total;
         v_gipir924f.commission := v_commission;
         PIPE ROW (v_gipir924f);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir924e (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924e_type
      PIPELINED
   IS
      v_gipir924e        gipir924e_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_line             VARCHAR2 (50);
      v_subline          VARCHAR2 (50);
      v_pol_flag         cg_ref_codes.rv_meaning%TYPE;
      v_assured          VARCHAR2 (500);
      v_param_v          VARCHAR2 (1);
      v_total            NUMBER (38, 2);
      --policy_no
      v_policy_no        VARCHAR2 (100);
      v_endt_no          VARCHAR2 (30);
      v_ref_pol_no       VARCHAR2 (35) := NULL;
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
         IN (  SELECT DECODE (spld_date,
                              NULL, DECODE (a.dist_flag, 3, 'D', 'U'),
                              'S')
                         dist_flag,
                      a.line_cd,
                      a.subline_cd,
                      DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                         iss_cd_header,
                      a.iss_cd,
                      a.issue_yy,
                      a.pol_seq_no,
                      a.renew_no,
                      a.endt_iss_cd,
                      a.endt_yy,
                      a.endt_seq_no,
                      a.issue_date,
                      a.incept_date,
                      a.expiry_date,
                      DECODE (spld_date, NULL, a.total_tsi, 0) total_tsi,
                      DECODE (spld_date, NULL, a.total_prem, 0) total_prem,
                      DECODE (spld_date, NULL, a.evatprem, 0) evatprem,
                      DECODE (spld_date, NULL, a.lgt, 0) lgt,
                      DECODE (spld_date, NULL, a.doc_stamps, 0) doc_stamp,
                      DECODE (spld_date, NULL, a.fst, 0) fst,
                      DECODE (spld_date, NULL, a.other_taxes, 0) other_taxes,
                      DECODE (
                         spld_date,
                         NULL, (  a.total_prem
                                + a.evatprem
                                + a.lgt
                                + a.doc_stamps
                                + a.fst
                                + a.other_taxes),
                         0)
                         total_charges,
                      DECODE (
                         spld_date,
                         NULL, (  a.evatprem
                                + a.lgt
                                + a.doc_stamps
                                + a.fst
                                + a.other_taxes),
                         0)
                         total_taxes,
                      a.param_date,
                      a.from_date,
                      a.TO_DATE,
                      scope,
                      a.user_id,
                      a.policy_id,
                      a.assd_no,
                      DECODE (
                         spld_date,
                         NULL, NULL,
                            ' S   P  O  I  L  E  D       /       '
                         || TO_CHAR (spld_date, 'MM-DD-YYYY'))
                         spld_date,
                      DECODE (spld_date, NULL, 1, 0) pol_count,
                      DECODE (spld_date, NULL, b.commission_amt, 0)
                         commission_amt,
                      DECODE (spld_date, NULL, b.wholding_tax, 0) wholding_tax,
                      DECODE (spld_date, NULL, b.net_comm, 0) net_comm,
                      a.pol_flag
                 FROM gipi_uwreports_ext a,
                      (  SELECT SUM (
                                   DECODE (
                                      c.ri_comm_amt * c.currency_rt,
                                      0, NVL (b.commission_amt * c.currency_rt,
                                              0),
                                      c.ri_comm_amt * c.currency_rt))
                                   commission_amt,
                                SUM (NVL (b.wholding_tax, 0)) wholding_tax,
                                SUM (
                                   (  NVL (b.commission_amt, 0)
                                    - NVL (b.wholding_tax, 0)))
                                   net_comm,
                                c.policy_id policy_id
                           FROM gipi_comm_invoice b, gipi_invoice c
                          WHERE c.policy_id = b.policy_id
                       GROUP BY c.policy_id) b
                WHERE     a.policy_id = b.policy_id(+)
                      AND a.user_id = p_user_id
                      AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                             NVL (
                                p_iss_cd,
                                DECODE (p_iss_param,
                                        1, a.cred_branch,
                                        a.iss_cd))
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
             ORDER BY a.line_cd,
                      a.subline_cd,
                      a.iss_cd,
                      a.issue_yy,
                      a.pol_seq_no,
                      a.renew_no,
                      a.endt_iss_cd,
                      a.endt_yy,
                      a.endt_seq_no)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = rec.iss_cd;

            v_iss_name := rec.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR c IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = rec.line_cd)
         LOOP
            v_line := c.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
            IN (SELECT subline_name
                  FROM giis_subline
                 WHERE line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get POL_FLAG
         BEGIN
            FOR c1
               IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE     rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                          AND rv_low_value = rec.pol_flag)
            LOOP
               v_pol_flag := c1.rv_meaning;
            END LOOP;
         END;

         --get POLICY_NO
         BEGIN
            v_policy_no :=
                  rec.line_cd
               || '-'
               || rec.subline_cd
               || '-'
               || LTRIM (rec.iss_cd)
               || '-'
               || LTRIM (TO_CHAR (rec.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.pol_seq_no))
               || '-'
               || LTRIM (TO_CHAR (rec.renew_no, '09'));

            IF rec.endt_seq_no <> 0
            THEN
               v_endt_no :=
                     rec.endt_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (rec.endt_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.endt_seq_no));
            END IF;

            BEGIN
               SELECT ref_pol_no
                 INTO v_ref_pol_no
                 FROM gipi_polbasic
                WHERE policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_pol_no := NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         --get ASSURED
         FOR c IN (SELECT SUBSTR (assd_name, 1, 50) assd_name
                     FROM giis_assured
                    WHERE assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         --get TOTAL
         SELECT giacp.v ('SHOW_TOTAL_TAXES') INTO v_param_v FROM DUAL;

         IF v_param_v = 'Y'
         THEN
            IF rec.spld_date IS NULL
            THEN
               v_total := rec.total_taxes;
            ELSE
               v_total := rec.total_charges;
            END IF;
         ELSE
            v_total := rec.total_charges;
         END IF;

         --get COMMISSION
         BEGIN
            SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_ext
             WHERE user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
               IN (SELECT b.intrmdry_intm_no,
                          b.iss_cd,
                          b.prem_seq_no,
                          c.ri_comm_amt,
                          c.currency_rt,
                          b.commission_amt,
                          a.spld_date
                     FROM gipi_comm_invoice b,
                          gipi_invoice c,
                          gipi_uwreports_ext a
                    WHERE     a.policy_id = b.policy_id
                          AND a.policy_id = c.policy_id
                          AND a.user_id = p_user_id
                          AND DECODE (p_iss_param,
                                      1, a.cred_branch,
                                      a.iss_cd) = rec.iss_cd
                          AND a.line_cd = rec.line_cd
                          AND a.subline_cd = rec.subline_cd
                          AND a.policy_id = rec.policy_id)
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                     IN (  SELECT acct_ent_date,
                                  commission_amt,
                                  comm_rec_id,
                                  intm_no
                             FROM giac_new_comm_inv
                            WHERE     iss_cd = rc.iss_cd
                                  AND prem_seq_no = rc.prem_seq_no
                                  AND fund_cd = v_fund_cd
                                  AND branch_cd = v_branch_cd
                                  AND tran_flag = 'P'
                                  AND NVL (delete_sw, 'N') = 'N'
                         ORDER BY comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                           IN (SELECT commission_amt
                                 FROM giac_prev_comm_inv
                                WHERE     fund_cd = v_fund_cd
                                      AND branch_cd = v_branch_cd
                                      AND comm_rec_id = c1.comm_rec_id
                                      AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;

               IF rc.spld_date IS NOT NULL
               THEN
                  v_commission := 0;
               END IF;
            END LOOP;
         END;

         v_gipir924e.iss_name := v_iss_name;
         v_gipir924e.line := v_line;
         v_gipir924e.subline := v_subline;
         v_gipir924e.pol_flag := v_pol_flag;
         v_gipir924e.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir924e.assured := v_assured;
         v_gipir924e.issue_date := rec.issue_date;
         v_gipir924e.incept_date := rec.incept_date;
         v_gipir924e.expiry_date := rec.expiry_date;
         v_gipir924e.tot_sum_insured := rec.total_tsi;
         v_gipir924e.tot_premium := rec.total_prem;
         v_gipir924e.evat := rec.evatprem;
         v_gipir924e.lgt := rec.lgt;
         v_gipir924e.doc_stamps := rec.doc_stamp;
         v_gipir924e.fire_service_tax := rec.fst;
         v_gipir924e.other_charges := rec.other_taxes;
         v_gipir924e.total := v_total;
         v_gipir924e.commission := v_commission;
         PIPE ROW (v_gipir924e);
      END LOOP;

      RETURN;
   END;

   /** ====================================================================================================================================
    **            E D S T
    ** ================================================================================================================================== */
   FUNCTION get_edst (p_scope           edst_param.scope%TYPE,
                      p_from_date       edst_param.from_date%TYPE,
                      p_to_date         edst_ext.to_date1%TYPE,
                      p_negative_amt    VARCHAR2,
                      p_ctpl_pol        NUMBER,
                      p_inc_spo         VARCHAR2,
                      p_user            edst_param.user_id%TYPE,
                      p_line_cd         VARCHAR2,
                      p_subline_cd      VARCHAR2,
                      p_iss_cd          VARCHAR2,
                      p_iss_param       NUMBER)
      RETURN edst_type
      PIPELINED
   IS
      v_edst   edst_rec_type;
   --v_no_tin_reason giis_parameters.param_value_v%TYPE;
   BEGIN
      -- vin 7.8.2010 commented-out since these lines are no longer of any use
      /*SELECT param_value_v
        INTO v_no_tin_reason
        FROM giis_parameters
      WHERE param_name = 'DEFAULT_NO_TIN_REASON';*/
      FOR rec
         IN (  SELECT gs.assd_no AS assd_no,
                      NVL (gs.assd_tin, ' ') AS tin,
                      gp.iss_cd AS branch,
                      DECODE (NVL (gs.assd_tin, 'X'), 'X', 'X', ' ')
                         AS "NO_TIN",
                      giis.branch_tin_cd AS branch_tin_cd,
                      --vin 7.2.2010 added branch_tin_cd
                      gs.no_tin_reason AS reason,
                      DECODE (gs.corporate_tag,
                              'C', gs.assd_name,
                              'J', gs.assd_name,
                              NULL)
                         AS company,
                      DECODE (gs.corporate_tag, 'I', gs.first_name)
                         AS first_name,
                      DECODE (gs.corporate_tag, 'I', gs.middle_initial)
                         AS middle_initial,
                      DECODE (gs.corporate_tag, 'I', gs.last_name) AS last_name,
                      gpb.line_cd AS line_cd,     --added line_cd vin 7.1.2010
                      SUM (gu.total_prem) tax_base,
                      --sum of prem per assured rose
                      SUM (gu.total_tsi) tsi_amt         --vin added 7.14.2010
                 FROM edst_ext gp,
                      giis_assured gs,
                      gipi_polbasic gpb,
                      giis_issource giis,                       --vin 7.2.2010
                      giis_line gl,                          --Dean 05.28.2012
                      (SELECT assd_no,
                              policy_id,
                              total_prem,
                              total_tsi                 --vin added 07.14.2010
                         FROM edst_ext
                        WHERE     1 = 1
                              AND user_id = p_user
                              AND line_cd = NVL (p_line_cd, line_cd)
                              AND subline_cd = NVL (p_subline_cd, subline_cd)
                              AND iss_cd = NVL (p_iss_cd, iss_cd)
                              AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd))
                              AND acct_ent_date BETWEEN p_from_date
                                                    AND p_to_date
                              AND DECODE (iss_cd,  'BB', 0,  'RI', 0,  1) = 1
                              AND (   (    p_scope = 1
                                       AND p_ctpl_pol = 3
                                       AND total_prem > 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag IN
                                              ('1', '2', 'X', '5', '4'))
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag IN ('1', '2', 'X', '4')
                                       AND total_prem > 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag IN ('1', '2', 'X', '5')
                                       AND total_prem > 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag IN ('1', '2', 'X')
                                       AND total_prem > 0)
                                   -- vin added 7.8.2010
                                   OR (    p_scope = 2
                                       AND total_prem < 0
                                       AND p_ctpl_pol = 3))
                       UNION ALL
                       SELECT assd_no,
                              policy_id,
                              (DECODE (pol_flag,
                                       '5', (total_prem * -1),
                                       total_prem))
                                 total_prem,
                              (DECODE (pol_flag,
                                       '5', (total_tsi * -1),
                                       total_tsi))
                                 total_tsi              --vin added 07.14.2010
                         FROM edst_ext
                        WHERE     1 = 1
                              AND user_id = p_user
                              AND line_cd = NVL (p_line_cd, line_cd)
                              AND subline_cd = NVL (p_subline_cd, subline_cd)
                              AND iss_cd = NVL (p_iss_cd, iss_cd)
                              AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd))
                              AND DECODE (iss_cd,  'BB', 0,  'RI', 0,  1) = 1
                              AND spld_acct_ent_date BETWEEN p_from_date
                                                         AND p_to_date
                              AND (   (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag IN
                                              ('1', '2', 'X', '4', '5'))
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag IN ('1', '2', 'X', '4')
                                       AND total_prem < 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 3
                                       AND pol_flag = '5'))
                       UNION ALL                                   --WITH CTPL
                       SELECT assd_no,
                              policy_id,
                              total_prem,
                              total_tsi                  --vin added 7.14.2010
                         FROM edst_ext
                        WHERE     1 = 1
                              AND user_id = p_user
                              AND line_cd = NVL (p_line_cd, line_cd)
                              AND subline_cd = NVL (p_subline_cd, subline_cd)
                              AND iss_cd = NVL (p_iss_cd, iss_cd)
                              AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd))
                              AND acct_ent_date BETWEEN p_from_date
                                                    AND p_to_date
                              AND DECODE (iss_cd,  'BB', 0,  'RI', 0,  1) = 1
                              AND (   (    p_scope = 1
                                       AND p_ctpl_pol IN (1, 2)
                                       AND total_prem > 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag IN
                                              ('1', '2', 'X', '5', '4'))
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag IN ('1', '2', 'X', '4')
                                       AND total_prem > 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag IN ('1', '2', 'X', '5')
                                       AND total_prem > 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag IN ('1', '2', 'X')
                                       AND total_prem > 0)
                                   -- vin added 7.8.2010
                                   OR (    p_scope = 2
                                       AND p_ctpl_pol IN (1, 2)
                                       AND total_prem < 0))
                       UNION ALL
                       SELECT assd_no,
                              policy_id,
                              (DECODE (pol_flag,
                                       '5', (total_prem * -1),
                                       total_prem))
                                 total_prem,
                              (DECODE (pol_flag,
                                       '5', (total_tsi * -1),
                                       total_tsi))
                                 total_tsi              --vin added 07.14.2010
                         FROM edst_ext
                        WHERE     1 = 1
                              AND user_id = p_user
                              AND line_cd = NVL (p_line_cd, line_cd)
                              AND subline_cd = NVL (p_subline_cd, subline_cd)
                              AND iss_cd = NVL (p_iss_cd, iss_cd)
                              AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd))
                              AND DECODE (iss_cd,  'BB', 0,  'RI', 0,  1) = 1
                              AND spld_acct_ent_date BETWEEN p_from_date
                                                         AND p_to_date
                              AND (   (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag IN
                                              ('1', '2', 'X', '5', '4'))
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag IN ('1', '2', 'X', '4')
                                       AND total_prem < 0)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol IN (1, 2)
                                       AND pol_flag = '5'))
                       UNION ALL
                       --this is now for policy level CTPL policies vin 7.1.2010
                       SELECT assd_no,
                              policy_id,
                              prem_amt * -1 AS total_prem,
                              tsi_amt * -1 AS tsi_amt
                         --vin added 7.14.2010 to match the number of columns
                         FROM mc_pol_ext
                        WHERE     1 = 1
                              AND user_id = p_user
                              AND acct_ent_date BETWEEN p_from_date
                                                    AND p_to_date
                              AND (   (    p_scope = 1
                                       AND p_ctpl_pol = 1
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   -- vin 7.26.2010
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 1
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   -- vin 7.23.2010 commented out and replaced with the statement after it
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 1
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   -- since we will only get/compute those MC policies that have CTPL premiums
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 1
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 1
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   -- vin added 7.8.2010
                                   OR (    p_scope = 2
                                       AND p_ctpl_pol = 1  /*AND prem_amt<0 */
                                       AND ctpl_prem_amt < 0)) -- vin 7.26.2010 commented out
                       UNION ALL
                       --vin 7.1.2010 added these for peril level CTPL policies
                       SELECT assd_no,
                              policy_id,
                              ctpl_prem_amt * -1 AS total_prem,
                              ctpl_tsi_amt * -1 AS tsi_amt
                         --vin added 7.14.2010 to match the number of columns
                         FROM mc_pol_ext
                        WHERE     1 = 1
                              AND user_id = p_user
                              AND acct_ent_date BETWEEN p_from_date
                                                    AND p_to_date
                              AND (   (    p_scope = 1
                                       AND p_ctpl_pol = 2
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   -- vin 7.26.2010
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 2
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   -- vin 7.23.2010 commented out
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'Y'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 2
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'Y'
                                       AND p_ctpl_pol = 2
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL)
                                   OR (    p_scope = 1
                                       AND p_negative_amt = 'N'
                                       AND p_inc_spo = 'N'
                                       AND p_ctpl_pol = 2
                                       AND  /*prem_amt>0 AND ctpl_prem_amt>0*/
                                          ctpl_prem_amt IS NOT NULL) -- vin added 7.8.2010
                                                                    --OR  (p_scope=2 AND p_ctpl_pol = 2 /*AND prem_amt<0 */ AND ctpl_prem_amt<0) -- JHING 08/10/2011 commented out since this cause incorrect amounts in the retrieval of negative amounts
                                  )) gu         -- vin 7.26.2010 commented out
                WHERE     gp.user_id = p_user
                      AND gpb.line_cd = gl.line_cd           --Dean 05.08.2012
                      AND gp.assd_no = gs.assd_no
                      AND gpb.policy_id = gp.policy_id
                      AND gp.assd_no = gu.assd_no
                      AND gp.policy_id = gu.policy_id
                      AND giis.iss_cd = gp.iss_cd
                      AND gpb.line_cd = NVL (p_line_cd, gpb.line_cd)
             --Dean 05.28.2012
             --AND tax_base <> 0
             /*added by rose in order to group the assd*/
             GROUP BY gs.assd_no,
                      DECODE (gl.menu_line_cd, 'AC', gpb.policy_id),
                      --Dean 05.28.2012
                      DECODE (gpb.line_cd, 'AC', gpb.policy_id),
                      --Dean 05.28.2012
                      gpb.line_cd,
                      gs.assd_tin,
                      gp.iss_cd,
                      giis.branch_tin_cd,
                      gs.assd_name,
                      gs.no_tin_reason,
                      gs.last_name,
                      gs.first_name,
                      gs.middle_initial,
                      gs.corporate_tag                                     --,
               --gp.total_tsi
               HAVING SUM (gu.total_prem) <> SUM (gu.total_tsi)
             -- Jayson 08.03.2010
             --ORDER BY  gs.assd_no, gpb.line_cd) LOOP                      -- vin commented out 7.8.2010 and replaced by the line below
             ORDER BY gs.corporate_tag DESC,
                      gpb.line_cd,
                      gs.assd_tin,
                      gp.iss_cd,
                      giis.branch_tin_cd,
                      gs.assd_name)
      LOOP
         v_edst.line_cd := rec.line_cd;
         v_edst.tin := rec.tin;
         v_edst.branch := rec.branch;
         v_edst.branch_tin_cd := rec.branch_tin_cd;
         v_edst.no_tin := rec.no_tin;
         v_edst.reason := rec.reason;
         v_edst.company := rec.company;
         v_edst.first_name := rec.first_name;
         v_edst.last_name := rec.last_name;
         v_edst.middle_name := rec.middle_initial;
         v_edst.tax_base := rec.tax_base;
         v_edst.tsi_amt := rec.tsi_amt;
         PIPE ROW (v_edst);
      END LOOP;

      RETURN;
   END;

   -- animone2
   FUNCTION get_gipir923c (p_tab           VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_scope         VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_user_id       VARCHAR2,
                           p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED
   IS
      v                    dynamic_csv_rec_type;

      --      v2                               dyn_sql_query;

      TYPE col_type IS RECORD
      (
         col_id     VARCHAR2 (100),
         col_name   VARCHAR2 (100)
      );

      TYPE col_tab IS TABLE OF col_type
         INDEX BY BINARY_INTEGER;

      v_tab                col_tab;

      TYPE row_type IS RECORD
      (
         acctg_seq        NUMBER,
         acctg_seq_year   NUMBER,
         acct_ent_date    VARCHAR2 (100),
         line_cd          giis_line.line_cd%TYPE,
         subline_cd       giis_subline.subline_cd%TYPE,
         iss_cd           giis_issource.iss_cd%TYPE,
         iss_cd_header    giis_issource.iss_cd%TYPE,
         cred_branch      giis_issource.iss_cd%TYPE,
         issue_yy         gipi_polbasic.issue_yy%TYPE,
         pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
         renew_no         gipi_polbasic.renew_no%TYPE,
         endt_is_cd       gipi_polbasic.endt_iss_cd%TYPE,
         endt_yy          gipi_polbasic.endt_yy%TYPE,
         endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
         policy_no        VARCHAR2 (100),
         issue_date       DATE,
         incept_date      DATE,
         expiry_date      DATE,
         spld_date        DATE,
         total_tsi        NUMBER (38, 2),
         total_prem       NUMBER (38, 2),
         evatprem         NUMBER (38, 2),
         lgt              NUMBER (38, 2),
         doc_stamps       NUMBER (38, 2),
         fst              NUMBER (38, 2),
         other_charges    NUMBER (38, 2),
         total_charges    NUMBER (38, 2),
         taxes            VARCHAR2 (32767),
         param_date       gipi_uwreports_ext.param_date%TYPE,
         from_date        gipi_uwreports_ext.from_date%TYPE,
         TO_DATE          gipi_uwreports_ext.TO_DATE%TYPE,
         scope            gipi_uwreports_ext.scope%TYPE,
         user_id          gipi_uwreports_ext.user_id%TYPE,
         policy_id        gipi_polbasic.policy_id%TYPE,
         assd_no          giis_assured.assd_no%TYPE,
         record_flag      VARCHAR2 (1)
      );

      TYPE row_tab IS TABLE OF row_type;

      v_row                row_tab;
      v_rep_date_format    giis_parameters.param_value_v%TYPE;
      v_line_name          giis_line.line_name%TYPE;
      v_subline_name       giis_subline.subline_name%TYPE;
      v_cred_branch_name   giis_issource.iss_name%TYPE;
      v_iss_name           giis_issource.iss_name%TYPE;
      v_assd_name          giis_assured.assd_name%TYPE;
      v_index              NUMBER;
      v_query              VARCHAR2 (32767);
      v_exists             NUMBER;
   BEGIN
      BEGIN
         SELECT giisp.v ('REP_DATE_FORMAT') INTO v_rep_date_format FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      DECLARE
         v_dummy   VARCHAR2 (100);
      BEGIN
         SELECT TO_CHAR (SYSDATE, v_rep_date_format) INTO v_dummy FROM DUAL;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;


      v_tab (1).col_name := 'CRED BRANCH';
      v_tab (2).col_name := 'CRED BRANCH NAME';
      v_tab (3).col_name := 'ISSUE CODE';
      v_tab (4).col_name := 'ISSUE SOURCE NAME';
      v_tab (5).col_name := 'LINE CODE';
      v_tab (6).col_name := 'LINE NAME';
      v_tab (7).col_name := 'SUBLINE CODE';
      v_tab (8).col_name := 'SUBLINE NAME';
      v_tab (9).col_name := 'ACCT ENTRY DATE';
      v_tab (10).col_name := 'POLICY NO.';
      v_tab (11).col_name := 'ASSD NO';
      v_tab (12).col_name := 'ASSURED NAME';
      v_tab (13).col_name := 'ISSUE DATE';
      v_tab (14).col_name := 'INCEPT DATE';
      v_tab (15).col_name := 'EXPIRY DATE';

      IF p_scope = 4
      THEN
         v_tab (16).col_name := 'SPOILED DATE';
      END IF;

      v_index := v_tab.LAST;
      v_tab (v_index + 1).col_name := 'TOTAL SUM INSURED';
      v_tab (v_index + 2).col_name := 'TOTAL PREMIUM';
      v_index := v_tab.LAST;

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
      THEN
         v_tab (v_index + 1).col_name := 'VAT / PREMIUM TAX';
         v_tab (v_index + 2).col_name := 'LGT';
         v_tab (v_index + 3).col_name := 'DOC. STAMPS';
         v_tab (v_index + 4).col_name := 'FST';
         v_tab (v_index + 5).col_name := 'OTHER  CHARGES';
      ELSE
         FOR i
            IN (  SELECT DISTINCT c.tax_cd, c.tax_name
                    FROM gipi_uwreports_ext a,
                         gipi_uwreports_polinv_tax_ext b,
                         giac_taxes c
                   WHERE     a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.rec_type = b.rec_type
                         AND a.user_id = b.user_id
                         AND b.tax_cd = c.tax_cd
                         AND a.user_id = p_user_id
                         AND a.line_cd LIKE NVL (p_line_cd, '%')
                         AND DECODE (p_iss_param,
                                     1, NVL (a.cred_branch, a.iss_cd),
                                     a.iss_cd) LIKE
                                NVL (p_iss_cd, '%')
                         AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                         AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                              OR (p_scope = 2 AND a.endt_seq_no > 0)
                              OR (p_scope = 3 AND a.pol_flag = '4')
                              OR (    p_scope = 4
                                  AND a.pol_flag = '5'
                                  AND NVL (a.reinstate_tag, 'N') =
                                         DECODE (
                                            p_reinstated,
                                            'Y', 'Y',
                                            'N', NVL (a.reinstate_tag, 'N')))
                              OR (p_scope = 5 AND pol_flag <> '5')
                              OR p_scope = 6)--Added by pjsantos 03/15/2017, GENQA 5955
                         AND a.tab_number = p_tab
                ORDER BY c.tax_cd)
         LOOP
            IF i.tax_cd IS NOT NULL
            THEN
               v_index := NVL (v_index, 0) + 1;
               v_tab (v_index).col_id := i.tax_cd;
               v_tab (v_index).col_name := i.tax_name;
            END IF;
         END LOOP;
      END IF;

      v_index := v_tab.LAST;
      v_tab (v_index + 1).col_name := 'TOTAL_AMOUNT_DUE';

      FOR i IN 1 .. v_tab.LAST
      LOOP
         v.rec := v.rec || v_tab (i).col_name || ',';
      END LOOP;

      PIPE ROW (v);



      v_query :=
            '  SELECT tx.acctg_seq,   tx.acctg_seq_year,  tx.acct_ent_date,   tx.line_cd, '
         || '     tx.subline_cd,    tx.iss_cd,    tx.iss_cd_header,   tx.cred_branch, '
         || '    tx.issue_yy,   tx.pol_seq_no,   tx.renew_no,   tx.endt_iss_cd,  tx.endt_yy, '
         || '      tx.endt_seq_no,  tx.policy_no, tx.issue_date,  tx.incept_date, '
         || '      tx.expiry_date, tx.spld_date, (tx.total_tsi) total_tsi,  (tx.total_prem) total_prem,  (tx.evatprem) evatprem, '
         || '     (tx.lgt) lgt,  (tx.doc_stamps) doc_stamps,  (tx.fst) fst,          (tx.other_taxes) other_taxes, '
         || '      (tx.total_charges) total_charges, ';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
      THEN
         v_query := v_query || ' (0) taxes ';
      ELSE
         v_exists := 0;
         FOR i IN 1 .. v_tab.LAST
         LOOP
            IF v_tab (i).col_id IS NOT NULL
            THEN
               v_query :=
                     v_query
                  || 'DECODE(tx.record_flag,''R'',-1 , 1 ) * SUM(DECODE(ty.tax_cd, '
                  || v_tab (i).col_id
                  || ', ty.tax_amt, 0)) || '','' ||';
               v_exists := 1;
            END IF;
         END LOOP;
         
         IF v_exists = 0
         THEN
            v_query := v_query || 'SUM(0) || '','' ||';
         END IF;

         v_query := SUBSTR (v_query, 0, LENGTH (v_query) - 9);
      END IF;


      v_query :=
            v_query
         || '   ,   tx.param_date,  tx.from_date,  tx.TO_DATE,  tx.scope, '
         || '     tx.user_id,  tx.policy_id,   tx.assd_no,    tx.record_flag '
         || '   FROM (  SELECT TO_NUMBER (NVL (TO_CHAR (acct_ent_date, ''MM''), ''13''))   acctg_seq,  '
         || '              TO_NUMBER (NVL (TO_CHAR (acct_ent_date, ''YYYY''), ''9999''))     acctg_seq_year, '
         || '              NVL (TO_CHAR (acct_ent_date, ''FmMonth, RRRR''), ''NOT TAKEN UP'')  acct_ent_date, '
         || '              line_cd,  subline_cd,  iss_cd,  cred_branch,  '
         || '             DECODE ('
         || p_iss_param
         || ' , 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd) iss_cd_header,  '
         || '              issue_yy,  pol_seq_no,  renew_no,  endt_iss_cd,   endt_yy,  endt_seq_no,  '
         || '             get_policy_no (policy_id) policy_no,  issue_date,  incept_date,  expiry_date, spld_date , '
         || '            SUM (NVL (total_tsi, 0)) total_tsi,  '
         || '            SUM (NVL (total_prem, 0)) total_prem,  '
         || '            SUM (NVL (evatprem, 0)) evatprem,  '
         || '            SUM (NVL (lgt, 0)) lgt,  '
         || '           SUM (NVL (doc_stamps, 0)) doc_stamps,  '
         || '            SUM (NVL (fst, 0)) fst,  '
         || '            SUM (NVL (other_taxes, 0)) other_taxes, '
         || '            SUM (  '
         || '              (  NVL (total_prem, 0)  '
         || '              + NVL (evatprem, 0)  '
         || '               + NVL (lgt, 0)  '
         || '              + NVL (doc_stamps, 0)  '
         || '            + NVL (fst, 0)  '
         || '              + NVL (other_taxes, 0)))   total_charges,  '
         || '          param_date,  from_date,  TO_DATE,   scope, user_id,  policy_id,  assd_no,   ''O'' record_flag,  '
         || '          tab_number  '
         || '       FROM gipi_uwreports_ext a  '
         || '       WHERE     user_id = '''
         || p_user_id
         || ''''
         || '          AND DECODE ('
         || p_iss_param
         || ',  '
         || '                      1, NVL (a.cred_branch, a.iss_cd),  '
         || '                    a.iss_cd) =  '
         || '              NVL (  '
         || '                 '''
         || p_iss_cd
         || ''',  '
         || '                DECODE ('
         || p_iss_param
         || ',  '
         || '                       1, NVL (a.cred_branch, a.iss_cd),  '
         || '                        a.iss_cd))  '
         || '        AND line_cd = NVL ('''
         || p_line_cd
         || ''', line_cd)  '
         || '        AND subline_cd = NVL ('''
         || p_subline_cd
         || ''', subline_cd)  '
         || '        AND (       '
         || p_scope
         || ' = 6 OR (' --Added by pjsantos 03/15/2017, GENQA 5955
         || p_scope
         || '  = 5  '
         || '               AND endt_seq_no = endt_seq_no  '
         || '                AND spld_date IS NULL)  '
         || '            OR (    '
         || p_scope
         || '  = 1  '
         || '               AND endt_seq_no = 0  '
         || '                AND spld_date IS NULL)  '
         || '            OR (    '
         || p_scope
         || ' = 2  '
         || '              AND endt_seq_no > 0  '
         || '             AND spld_date IS NULL)  '
         || '        OR (    '
         || p_scope
         || ' = 3  '
         || '            AND spld_date IS NULL  '
         || '           AND pol_flag = ''4'' )      '
         || '       OR ('
         || p_scope
         || '  = 4 AND pol_flag = ''5'' AND NVL(reinstate_tag,''N'') = DECODE(nvl('''
         || p_reinstated
         || ''', ''N''), ''N'', NVL(reinstate_tag, ''N'') , ''Y'' )) )  '
         || '    GROUP BY acct_ent_date,  line_cd,  subline_cd, iss_cd,  '
         || '      cred_branch, DECODE ('
         || p_iss_param
         || ' ,  1, NVL (a.cred_branch, a.iss_cd),    a.iss_cd),  '
         || '         issue_yy,    pol_seq_no,  renew_no,  endt_iss_cd, endt_yy, endt_seq_no,  get_policy_no (policy_id),  '
         || '          issue_date,    incept_date,  expiry_date, spld_date,  param_date,   from_date,  TO_DATE,   scope,  '
         || '          user_id, policy_id,    assd_no,  tab_number  '
         || '     UNION  '
         || '     SELECT TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, ''MM''), ''13'')) acctg_seq,  '
         || '            TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, ''YYYY''), ''9999''))   acctg_seq_year,  '
         || '            NVL (TO_CHAR (spld_acct_ent_date, ''FmMonth, RRRR''),   ''NOT TAKEN UP'')  acct_ent_date,  '
         || '            line_cd,   subline_cd, iss_cd, cred_branch, DECODE ('
         || p_iss_param
         || ', 1, NVL (a.cred_branch, a.iss_cd),  a.iss_cd)  iss_cd_header,  '
         || '             issue_yy,  pol_seq_no,  renew_no,   endt_iss_cd,  endt_yy,   endt_seq_no,  get_policy_no (policy_id)   '
         || ' policy_no,   issue_date, '
         || '              incept_date,  expiry_date, spld_date,   -1 * SUM (NVL (total_tsi, 0)) total_tsi, '
         || '             -1 * SUM (NVL (total_prem, 0)) total_prem,       -1 * SUM (NVL (evatprem, 0)) evatprem,  '
         || '              -1 * SUM (NVL (lgt, 0)) lgt,     -1 * SUM (NVL (doc_stamps, 0)) doc_stamps,  '
         || '             -1 * SUM (NVL (fst, 0)) fst,    -1 * SUM (NVL (other_taxes, 0)) other_taxes,  '
         || '               -1  * SUM (   (  NVL (total_prem, 0)  + NVL (evatprem, 0)   + NVL (lgt, 0) + NVL (doc_stamps, 0)  + NVL (fst, 0) + NVL (other_taxes, 0))) total_charges,  '
         || '           param_date,  from_date,    TO_DATE, scope,  user_id, policy_id,    assd_no,  ''R'' record_flag,  tab_number  '
         || '         FROM gipi_uwreports_ext a '
         || '        WHERE     user_id = '''
         || p_user_id
         || ''''
         || '             AND DECODE ('
         || p_iss_param
         || ',  1, NVL (a.cred_branch, a.iss_cd),  a.iss_cd) = '
         || '                    NVL (  '''
         || p_iss_cd
         || ''',  DECODE ('
         || p_iss_param
         || ', 1, NVL (a.cred_branch, a.iss_cd),  a.iss_cd))  '
         || '            AND line_cd = NVL ('''
         || p_line_cd
         || ''', line_cd)  '
         || '           AND subline_cd = NVL ('''
         || p_subline_cd
         || ''', subline_cd)  '
         || '           AND (       '
         || p_scope
         || ' = 6 OR (' --Added by pjsantos 03/15/2017, GENQA 5955
         || p_scope
         || ' = 5  '
         || '                   AND endt_seq_no = endt_seq_no  '
         || '                   AND spld_date IS NULL)  '
         || '               OR (     '
         || p_scope
         || ' = 1 '
         || '                 AND endt_seq_no = 0  '
         || '                  AND spld_date IS NULL) '
         || '              OR (   '
         || p_scope
         || ' = 2  '
         || '                 AND endt_seq_no > 0  '
         || '                 AND spld_date IS NULL) '
         || '                    OR (   '
         || p_scope
         || ' = 3  '
         || '                 AND spld_date IS NULL  '
         || '                 AND pol_flag = ''4'' )      '
         || '               OR ( '
         || p_scope
         || ' = 4 AND pol_flag = ''5'' AND NVL( reinstate_tag,''N'') = DECODE(nvl('''
         || p_reinstated
         || ''', ''N''), ''N'', NVL(reinstate_tag, ''N'') , ''Y'' ) ))  '
         || '         AND spld_acct_ent_date IS NOT NULL  '
         || '    GROUP BY acct_ent_date, line_cd,  '
         || '            subline_cd,  iss_cd,  cred_branch,  '
         || '           DECODE ('
         || p_iss_param
         || ', 1, NVL (a.cred_branch, a.iss_cd),a.iss_cd),  '
         || '           issue_yy, pol_seq_no, renew_no, endt_iss_cd,  endt_yy, endt_seq_no, get_policy_no (policy_id),  '
         || '          issue_date,  incept_date,  expiry_date,  spld_date, param_date,   from_date,   TO_DATE,  '
         || '           scope,  user_id,  policy_id,   assd_no, spld_acct_ent_date,   tab_number) tx   ';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 2
      THEN
         v_query := v_query || '   ,   gipi_uwreports_polinv_tax_ext ty  ';
      END IF;



      v_query :=
         v_query || '    WHERE     tx.user_id =''' || p_user_id || '''';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 2
      THEN
         v_query :=
               v_query
            || '        AND tx.tab_number = ty.tab_number(+)  '
            || '        AND tx.user_id = ty.user_id(+)  '
            || '        AND tx.policy_id = ty.policy_id(+)  ';
      END IF;


      v_query :=
            v_query
         || '  GROUP BY tx.policy_id,    tx.acctg_seq,  tx.acctg_seq_year,   tx.acct_ent_date,     tx.line_cd,  tx.subline_cd,  '
         || '         tx.iss_cd,  tx.iss_cd_header, tx.cred_branch, tx.issue_yy,   tx.pol_seq_no,    tx.renew_no,  '
         || '        tx.endt_iss_cd,  tx.endt_yy,   tx.endt_seq_no,    tx.policy_no,  tx.issue_date,    tx.incept_date,  '
         || '       tx.expiry_date,  tx.spld_date,  tx.param_date,   tx.from_date,    tx.TO_DATE,   tx.scope,  '
         || '        tx.user_id,   tx.policy_id,  tx.assd_no,   tx.record_flag, (tx.total_tsi), '
         || '       (tx.total_prem),    (tx.evatprem),    (tx.lgt),   (tx.doc_stamps), '
         || '       (tx.fst),      (tx.other_taxes),   (tx.total_charges) '
         || '  ORDER BY tx.acctg_seq,    tx.acctg_seq_year,   tx.line_cd, '
         || '        tx.subline_cd,   tx.iss_cd,  tx.issue_yy,   tx.pol_seq_no, '
         || '      tx.renew_no,    tx.endt_iss_cd, tx.endt_yy,  tx.endt_seq_no,'
         || '       tx.record_flag ';

      EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_row;


      IF SQL%FOUND
      THEN
         FOR i IN 1 .. v_row.LAST
         LOOP
            BEGIN
               SELECT line_name
                 INTO v_line_name
                 FROM giis_line
                WHERE line_cd = v_row (i).line_cd;
            END;

            BEGIN
               SELECT subline_name
                 INTO v_subline_name
                 FROM giis_subline
                WHERE     line_cd = v_row (i).line_cd
                      AND subline_cd = v_row (i).subline_cd;
            END;

            IF v_row (i).cred_branch IS NOT NULL
            THEN
               BEGIN
                  SELECT iss_name
                    INTO v_cred_branch_name
                    FROM giis_issource
                   WHERE iss_cd = v_row (i).cred_branch;
               END;
            ELSE
               v_cred_branch_name := NULL;
            END IF;

            BEGIN
               SELECT iss_name
                 INTO v_iss_name
                 FROM giis_issource
                WHERE iss_cd = v_row (i).iss_cd;
            END;



            BEGIN
               SELECT assd_name
                 INTO v_assd_name
                 FROM giis_assured
                WHERE assd_no = v_row (i).assd_no;
            END;

            v.rec :=
                  v_row (i).cred_branch
               || ','
               || csv_uw_prodreport.escape_string (v_cred_branch_name)
               || ','
               || v_row (i).iss_cd
               || ','
               || csv_uw_prodreport.escape_string (v_iss_name)
               || ','
               || csv_uw_prodreport.escape_string (v_row (i).line_cd)
               || ','
               || csv_uw_prodreport.escape_string (v_line_name)
               || ','
               || csv_uw_prodreport.escape_string (v_row (i).subline_cd)
               || ','
               || csv_uw_prodreport.escape_string (v_subline_name)
               || ','
               || csv_uw_prodreport.escape_string (v_row (i).acct_ent_date)
               || ','
               || csv_uw_prodreport.escape_string (v_row (i).policy_no)
               || ','
               || v_row (i).assd_no
               || ','
               || csv_uw_prodreport.escape_string (v_assd_name)
               || ','
               || csv_uw_prodreport.escape_string (
                     TO_CHAR (v_row (i).issue_date, v_rep_date_format))
               || ','
               || csv_uw_prodreport.escape_string (
                     TO_CHAR (v_row (i).incept_date, v_rep_date_format))
               || ','
               || csv_uw_prodreport.escape_string (
                     TO_CHAR (v_row (i).expiry_date, v_rep_date_format));

            IF p_scope = 4
            THEN
               v.rec :=
                     v.rec
                  || ','
                  || csv_uw_prodreport.escape_string (
                        TO_CHAR (v_row (i).spld_date, v_rep_date_format));
            END IF;

            v.rec :=
                  v.rec
               || ','
               || v_row (i).total_tsi
               || ','
               || v_row (i).total_prem;

            IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
            THEN
               v.rec :=
                     v.rec
                  || ','
                  || v_row (i).evatprem
                  || ','
                  || v_row (i).lgt
                  || ','
                  || v_row (i).doc_stamps
                  || ','
                  || v_row (i).fst
                  || ','
                  || v_row (i).other_charges;
            ELSE
               IF v_exists = 1
               THEN
                  v.rec := v.rec || ',' || v_row (i).taxes;
               END IF;
            END IF;

            v.rec := v.rec || ',' || v_row (i).total_charges;



            PIPE ROW (v);
         END LOOP;
      END IF;
   END get_gipir923c;

   /*for handling of special characters*/
   FUNCTION escape_string (p_string VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN '"' || REPLACE (p_string, '"', '""') || '"';
   END;

   FUNCTION get_gipir923 (p_iss_cd        VARCHAR2,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_scope         VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       VARCHAR2,
                          p_tab           VARCHAR2,
                          p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED
   IS
      v                                dynamic_csv_rec_type;
      v_text              VARCHAR2(1); --added by gab 11.25.2015
      v_ref_pol_no        VARCHAR2(30); --added by gab 11.25.2015
      v_pol_no            VARCHAR2(100); --added by gab 11.26.2015

      TYPE col_type IS RECORD
      (
         col_id     VARCHAR2 (100),
         col_name   VARCHAR2 (100)
      );

      TYPE col_tab IS TABLE OF col_type
         INDEX BY BINARY_INTEGER;

      v_tab                            col_tab;

      TYPE row_type IS RECORD
      (
         policy_id            VARCHAR2(100), --added by gab 11.26.2015
         line_cd              giis_line.line_cd%TYPE,
         subline_cd           giis_subline.subline_cd%TYPE,
         cred_branch          giis_issource.iss_cd%TYPE,
         iss_cd               giis_issource.iss_cd%TYPE,
         pol_flag             gipi_polbasic.pol_flag%TYPE,
         dist_flag            gipi_polbasic.dist_flag%TYPE,
         policy_no            VARCHAR2 (50),
         assd_no              giis_assured.assd_no%TYPE,
         prem_seq_no          gipi_invoice.prem_seq_no%TYPE,
         ref_inv_no           gipi_invoice.ref_inv_no%TYPE,
         issue_date           VARCHAR2 (100),
         incept_date          VARCHAR2 (100),
         expiry_date          VARCHAR2 (100),
         booking_date         VARCHAR2 (100),
         acct_ent_date        VARCHAR2 (100),
         spld_date            VARCHAR2 (100),
         spld_acct_ent_date   VARCHAR2 (100),
         policy_type          VARCHAR2 (20),
         total_tsi            NUMBER,
         total_prem           NUMBER,
         comm_amt             NUMBER,
         wholding_tax         NUMBER,
         total_taxes          NUMBER,
         total_amount_due     NUMBER,
         vat                  NUMBER,
         prem_tax             NUMBER,
         lgt                    NUMBER ,
         doc_stamps     NUMBER ,
         fst                    NUMBER , 
         other_taxes     NUMBER , 
         taxes                VARCHAR2 (32767)
      );

      TYPE row_tab IS TABLE OF row_type;

      v_row                            row_tab;
      v_rep_date_format                giis_parameters.param_value_v%TYPE;
      v_print_ref_inv                  giis_document.text%TYPE;
      v_display_separate_premtax_vat   giis_document.text%TYPE;
      v_display_wholding_tax           giis_document.text%TYPE;
      v_display_total_taxes           giis_document.text%TYPE;
      v_line_name                      giis_line.line_name%TYPE;
      v_subline_name                   giis_subline.subline_name%TYPE;
      v_cred_branch_name               giis_issource.iss_name%TYPE;
      v_iss_name                       giis_issource.iss_name%TYPE;
      v_policy_status                  VARCHAR2 (20);
      v_invoice_no                     VARCHAR2 (500);
      v_assd_name                      giis_assured.assd_name%TYPE;
      v_index                          NUMBER;
      v_query                          VARCHAR2 (32767);
      v_prod_ext                    giis_parameters.param_value_n%TYPE := NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) ; 
      v_exists                         NUMBER;
   BEGIN
      BEGIN
         SELECT giisp.v ('REP_DATE_FORMAT') INTO v_rep_date_format FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      DECLARE
         v_dummy   VARCHAR2 (100);
      BEGIN
         SELECT TO_CHAR (SYSDATE, v_rep_date_format) INTO v_dummy FROM DUAL;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_rep_date_format := 'MM/DD/RRRR';
      END;

      BEGIN
         SELECT NVL(text,'N')
           INTO v_print_ref_inv
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'PRINT_REF_INV';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_print_ref_inv := 'N';
      END;

      BEGIN
         SELECT NVL(text,'N')
           INTO v_display_separate_premtax_vat
           FROM giis_document
          WHERE     report_id = 'GIPIR923'
                AND title = 'DISPLAY_SEPARATE_PREMTAX_VAT';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_display_separate_premtax_vat := 'N';
      END;

      BEGIN
         SELECT NVL(text,'N')
           INTO v_display_wholding_tax
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'DISPLAY_WHOLDING_TAX';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_display_wholding_tax := 'N';
      END;
      
     BEGIN
         SELECT NVL(text,'N')
           INTO v_display_total_taxes
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'SHOW_TOTAL_TAXES';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_display_total_taxes := 'N';
      END;      
      
      --added by gab 11.25.2015
      BEGIN
          SELECT NVL(text,'N')
          INTO v_text
          FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'INCLUDE_REF_POL_NO';
      EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            v_text := 'N';
      END;
      

      v_tab (1).col_name := 'LINE CODE';
      v_tab (2).col_name := 'LINE NAME';
      v_tab (3).col_name := 'SUBLINE CODE';
      v_tab (4).col_name := 'SUBLINE NAME';
      v_tab (5).col_name := 'CRED BRANCH';
      v_tab (6).col_name := 'CRED BRANCH NAME';
      v_tab (7).col_name := 'ISS SOURCE CODE';
      v_tab (8).col_name := 'ISS SOURCE NAME';
      v_tab (9).col_name := 'POLICY STATUS';
      v_tab (10).col_name := 'POLICY NO.';
      v_tab (11).col_name := 'ASSURED NO.';
      v_tab (12).col_name := 'ASSURED NAME';
      v_tab (13).col_name := 'INVOICE NO.';
      v_tab (14).col_name := 'ISSUE DATE';
      v_tab (15).col_name := 'INCEPT DATE';
      v_tab (16).col_name := 'EXPIRY DATE';
      v_tab (17).col_name := 'BOOKING DATE';
      v_tab (18).col_name := 'ACCT ENT DATE';
      v_tab (19).col_name := 'SPOILED DATE';
      v_tab (20).col_name := 'SPLD ACCT ENT DATE';
      v_tab (21).col_name := 'POLICY TYPE';
      v_tab (22).col_name := 'TOTAL SUM INSURED';
      v_tab (23).col_name := 'TOTAL PREMIUM';
      v_index := v_tab.LAST;

      IF  v_prod_ext  = 1
      THEN
         IF v_display_separate_premtax_vat = 'Y'
         THEN
            v_tab (v_index + 1).col_name := 'VAT';
            v_tab (v_index + 2).col_name := 'PREMIUM TAX';
         ELSE
            v_tab (v_index + 1).col_name := 'VAT/PREMIUM TAX';
         END IF;
         
         v_index := v_tab.LAST;
         v_tab (v_index + 1).col_name := 'LGT';
         v_tab (v_index + 2).col_name := 'Doc. Stamps';
         v_tab (v_index + 3).col_name := 'FST';
         v_tab (v_index + 4).col_name := 'Other Charges';
      ELSE
         FOR i
            IN (  SELECT DISTINCT c.tax_cd, c.tax_name
                    FROM gipi_uwreports_ext a,
                         gipi_uwreports_polinv_tax_ext b,
                         giac_taxes c
                   WHERE     a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.rec_type = b.rec_type
                         AND a.user_id = b.user_id
                         AND b.tax_cd = c.tax_cd
                         AND a.user_id = p_user_id
                         AND a.line_cd LIKE NVL (p_line_cd, '%')
                         AND DECODE (p_iss_param,
                                     1, NVL (a.cred_branch, a.iss_cd),
                                     a.iss_cd) LIKE
                                NVL (p_iss_cd, '%')
                         AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                         AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                              OR (p_scope = 2 AND a.endt_seq_no > 0)
                              OR (p_scope = 3 AND a.pol_flag = '4')
                              OR (    p_scope = 4
                                  AND a.pol_flag = '5'
                                  AND NVL (a.reinstate_tag, 'N') =
                                         DECODE (
                                            p_reinstated,
                                            'Y', 'Y',
                                            'N', NVL (a.reinstate_tag, 'N')))
                              OR (p_scope = 5 AND pol_flag <> '5')
                              OR p_scope = 6)--Added by pjsantos 03/14/2017, GENQA 5955
                         AND a.tab_number = p_tab
                ORDER BY c.tax_cd)
         LOOP
            IF i.tax_cd IS NOT NULL
            THEN
               v_index := v_index + 1;
               v_tab (v_index).col_id := i.tax_cd;
               v_tab (v_index).col_name := i.tax_name;
            END IF;
         END LOOP;
      END IF;

      
      
      IF v_display_total_taxes = 'Y' THEN 
            v_index := v_tab.LAST;
            v_tab (v_index + 1).col_name := 'TOTAL TAXES';
     END IF; 
     
      v_index := v_tab.LAST;       
      v_tab (v_index + 1).col_name := 'TOTAL AMOUNT DUE';
      v_tab (v_index + 2).col_name := 'COMMISSION AMOUNT';

      IF v_display_wholding_tax = 'Y'
      THEN
         v_index := v_tab.LAST;
         v_tab (v_index + 1).col_name := 'WHOLDING_TAX';
      END IF;

      FOR i IN 1 .. v_tab.LAST
      LOOP
         v.rec := v.rec || v_tab (i).col_name || ',';
      END LOOP;

      PIPE ROW (v);
      v_query :=
            'SELECT a.policy_id, a.line_cd, a.subline_cd, a.cred_branch, a.iss_cd,a.pol_flag, 
                 a.dist_flag, 
                 a.line_cd
                       || ''-''
                       || a.subline_cd
                       || ''-''
                       || a.iss_cd
                       || ''-''
                       || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                       || ''-''
                       || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                       || ''-''
                       || LTRIM (TO_CHAR (a.renew_no, ''09''))
                       || DECODE (NVL (a.endt_seq_no, 0),
                                  0, '''',
                                     '' / ''
                                  || a.endt_iss_cd
                                  || ''-''
                                  || LTRIM (TO_CHAR (a.endt_yy, ''09''))
                                  || ''-''
                                  || LTRIM (TO_CHAR (a.endt_seq_no, ''0999999''))
                                 ) policy_no,                 
                 a.assd_no, a.prem_seq_no, a.ref_inv_no,
                 TO_CHAR (a.issue_date, '''
         || v_rep_date_format
         || ''') issue_date,
                 TO_CHAR (a.incept_date, '''
         || v_rep_date_format
         || ''') incept_date,
                 TO_CHAR (a.expiry_date, '''
         || v_rep_date_format
         || ''') expiry_date,
                 a.multi_booking_mm || '' '' || a.multi_booking_yy booking_date,
                 TO_CHAR (a.acct_ent_date, '''
         || v_rep_date_format
         || ''') acct_ent_date,
                 TO_CHAR (a.spld_date, '''
         || v_rep_date_format
         || ''') spld_date,
                 TO_CHAR (a.spld_acct_ent_date, '''
         || v_rep_date_format
         || ''') spld_acct_ent_date,
                 DECODE(NVL(a.reg_policy_sw, ''Y''), ''N'', ''Special Policy'', ''Regular Policy''),
                 NVL(a.total_tsi,0) total_tsi, NVL(a.total_prem,0) total_prem, NVL(a.comm_amt,0) comm_amt, NVL(a.wholding_tax,0) wholding_tax,
                 ((NVL(a.vat, 0) + NVL(a.prem_tax, 0) + NVL(a.lgt, 0) + NVL(a.doc_stamps, 0) + NVL(a.fst, 0) + NVL(a.other_taxes, 0))) total_taxes,
                 ((a.total_prem + NVL(a.vat, 0) + NVL(a.prem_tax, 0) + NVL(a.lgt, 0) + NVL(a.doc_stamps, 0) + NVL(a.fst, 0) + NVL(a.other_taxes, 0))) total_amount_due,
                 (NVL(a.vat, 0)) vat, (NVL(a.prem_tax, 0)) prem_tax,   (NVL(a.lgt, 0)) lgt,  (NVL(a.doc_stamps, 0)) doc_stamps, (NVL(a.fst, 0)) fst , (NVL(a.other_taxes, 0)) other_taxes ,';

      IF v_prod_ext = 1
      THEN
         v_query := v_query || 'sum(0) taxes';
      ELSE
         v_exists := 0;
         FOR i IN 1 .. v_tab.LAST
         LOOP
            IF v_tab (i).col_id IS NOT NULL
            THEN
               v_query :=
                     v_query
                  || 'SUM(DECODE(c.tax_cd, '
                  || v_tab (i).col_id
                  || ', b.tax_amt, 0)) || '','' ||';
               v_exists := 1;
            END IF;
         END LOOP;
         
         IF v_exists = 0
         THEN
            v_query := v_query || 'SUM(0) || '','' ||';
         END IF;

         v_query := SUBSTR (v_query, 0, LENGTH (v_query) - 9);
      END IF;

      v_query := v_query || ' FROM gipi_uwreports_ext a   ';

      IF v_prod_ext = 2
      THEN
         v_query :=
               v_query
            || ' , gipi_uwreports_polinv_tax_ext b,      giac_taxes c  ';
      END IF;

      v_query := v_query || '    WHERE 1 = 1    ';

      IF v_prod_ext = 2
      THEN
         v_query :=
               v_query
            || '  AND  a.policy_id = b.policy_id (+)
                   AND a.iss_cd = b.iss_cd (+) 
                   AND a.prem_seq_no = b.prem_seq_no (+)
                   AND a.rec_type = b.rec_type (+)
                   AND a.user_id = b.user_id (+)
                   AND b.tax_cd = c.tax_cd (+) ';
      END IF;

      v_query :=
            v_query
         || '    AND a.user_id = '''
         || p_user_id
         || '''
                   AND a.line_cd LIKE NVL ('''
         || p_line_cd
         || ''', ''%'')
                   AND DECODE ('
         || p_iss_param
         || ', 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd ) LIKE NVL ('''
         || p_iss_cd
         || ''', ''%'')
                   AND a.subline_cd LIKE NVL ('''
         || p_subline_cd
         || ''', ''%'')
                               AND (   ('
         || p_scope
         || ' = 1 AND a.endt_seq_no = 0)
                                    OR ('
         || p_scope
         || ' = 2 AND a.endt_seq_no > 0)
                                    OR ('
         || p_scope
         || ' = 3 AND a.pol_flag = ''4'')
                                    OR ('
         || p_scope
         || ' = 4
                                        AND a.pol_flag = ''5''
                                        AND NVL (a.reinstate_tag, ''N'') =
                                               DECODE ('''
         || p_reinstated
         || ''',
                                                       ''Y'', ''Y'',
                                                       ''N'', NVL
                                                             (a.reinstate_tag,
                                                              ''N''
                                                             )
                                                      )
                                       )
                                    OR ('
         || p_scope
         || ' = 5 AND pol_flag <> ''5'') OR '
         || p_scope
         ||' = 6) AND a.tab_number = '--Modified by pjsantos 03/14/2017,added p_scope = 6 GENQA 5955
         || p_tab
         || ' GROUP BY a.policy_id, a.line_cd, a.subline_cd, a.cred_branch, a.iss_cd,a.pol_flag,
                 a.dist_flag, 
                 a.line_cd
                       || ''-''
                       || a.subline_cd
                       || ''-''
                       || a.iss_cd
                       || ''-''
                       || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                       || ''-''
                       || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                       || ''-''
                       || LTRIM (TO_CHAR (a.renew_no, ''09''))
                       || DECODE (NVL (a.endt_seq_no, 0),
                                  0, '''',
                                     '' / ''
                                  || a.endt_iss_cd
                                  || ''-''
                                  || LTRIM (TO_CHAR (a.endt_yy, ''09''))
                                  || ''-''
                                  || LTRIM (TO_CHAR (a.endt_seq_no, ''0999999''))
                                 ) ,                 
                 a.assd_no, a.prem_seq_no, a.ref_inv_no,
                 a.issue_date,
                 a.incept_date,
                 a.expiry_date,
                 a.multi_booking_mm || '' '' || a.multi_booking_yy,
                 a.acct_ent_date,
                 a.spld_date,
                 a.spld_acct_ent_date, a.reg_policy_sw, a.total_tsi, a.total_prem,  a.comm_amt, a.wholding_tax, a.vat, a.prem_tax, a.lgt, 
                 a.doc_stamps, a.fst, a.other_taxes, a.rec_type
        ORDER by a.line_cd
                       || ''-''
                       || a.subline_cd
                       || ''-''
                       || a.iss_cd
                       || ''-''
                       || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                       || ''-''
                       || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                       || ''-''
                       || LTRIM (TO_CHAR (a.renew_no, ''09''))
                       || DECODE (NVL (a.endt_seq_no, 0),
                                  0, '''',
                                     '' / ''
                                  || a.endt_iss_cd
                                  || ''-''
                                  || LTRIM (TO_CHAR (a.endt_yy, ''09''))
                                  || ''-''
                                  || LTRIM (TO_CHAR (a.endt_seq_no, ''0999999''))
                                 ), ref_inv_no';

      EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_row;

      IF SQL%FOUND
      THEN
         FOR i IN 1 .. v_row.LAST
         LOOP
            BEGIN
               SELECT line_name
                 INTO v_line_name
                 FROM giis_line
                WHERE line_cd = v_row (i).line_cd;
            END;

            BEGIN
               SELECT subline_name
                 INTO v_subline_name
                 FROM giis_subline
                WHERE     line_cd = v_row (i).line_cd
                      AND subline_cd = v_row (i).subline_cd;
            END;

            IF v_row (i).cred_branch IS NOT NULL
            THEN
               BEGIN
                  SELECT iss_name
                    INTO v_cred_branch_name
                    FROM giis_issource
                   WHERE iss_cd = v_row (i).cred_branch;
               END;
            ELSE
               v_cred_branch_name := NULL;
            END IF;

            BEGIN
               SELECT iss_name
                 INTO v_iss_name
                 FROM giis_issource
                WHERE iss_cd = v_row (i).iss_cd;
            END;

            IF v_row (i).pol_flag = '5'
            THEN
               v_policy_status := 'SPOILED';
            ELSE
               IF v_row (i).dist_flag = 3
               THEN
                  v_policy_status := 'DISTRIBUTED';
               ELSE
                  v_policy_status := 'UNDISTRIBUTED';
               END IF;
            END IF;

            IF v_row (i).prem_seq_no IS NULL
            THEN
               v_invoice_no := NULL;
            ELSE
               v_invoice_no :=
                     v_row (i).iss_cd
                  || '-'
                  || TRIM (TO_CHAR (v_row (i).prem_seq_no, '000000000000'));

               IF v_print_ref_inv = 'Y' AND v_row (i).ref_inv_no IS NOT NULL
               THEN
                  v_invoice_no :=
                     v_invoice_no || ' / ' || v_row (i).ref_inv_no;
               END IF;
            END IF;

            BEGIN
               SELECT assd_name
                 INTO v_assd_name
                 FROM giis_assured
                WHERE assd_no = v_row (i).assd_no;
            END;
            
            --added by gab 11.26.2015
            BEGIN
                SELECT ref_pol_no
                INTO v_ref_pol_no
                FROM gipi_polbasic
                WHERE policy_id = v_row (i).policy_id;
            END;
            
            --added by gab 11.26.2015
            IF v_text = 'N'
            THEN
                v_pol_no := v_row (i).policy_no;
            ELSIF v_text = 'Y' AND v_ref_pol_no IS NOT NULL OR v_ref_pol_no = ''
            THEN
                v_pol_no := v_row (i).policy_no || ' / ' || v_ref_pol_no;
            ELSE
                v_pol_no := v_row (i).policy_no;
            END IF; 

            v.rec :=
                  v_row (i).line_cd
               || ','
               || escape_string (v_line_name)
               || ','
               || v_row (i).subline_cd
               || ','
               || escape_string (v_subline_name)
               || ','
               || v_row (i).cred_branch
               || ','
               || escape_string (v_cred_branch_name)
               || ','
               || v_row (i).iss_cd
               || ','
               || escape_string (v_iss_name)
               || ','
               || v_policy_status
               || ','
             --  || v_row (i).policy_no
               || v_pol_no --edited by gab 11.26.2015
               || ','
               || v_row (i).assd_no
               || ','
               || escape_string (v_assd_name)
               || ','
               || v_invoice_no
               || ','
               || v_row (i).issue_date
               || ','
               || v_row (i).incept_date
               || ','
               || v_row (i).expiry_date
               || ','
               || v_row (i).booking_date
               || ','
               || v_row (i).acct_ent_date
               || ','
               || v_row (i).spld_date
               || ','
               || v_row (i).spld_acct_ent_date
               || ','
               || v_row (i).policy_type
               || ','
               || v_row (i).total_tsi
               || ','
               || v_row (i).total_prem
               || ',';

            IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
            THEN
               IF v_display_separate_premtax_vat = 'Y'
               THEN
                  v.rec := v.rec || v_row (i).vat || ',' || v_row (i).prem_tax;
               ELSE
                  v.rec := v.rec || (v_row (i).vat + v_row (i).prem_tax);
               END IF;
               
                v.rec := v.rec || ',' ||  v_row (i).lgt || ',' || v_row (i).doc_stamps || ',' || v_row (i).fst || ',' || v_row (i).other_taxes || ',';
            ELSE
               IF v_exists = 1
               THEN
                  v.rec := v.rec || v_row (i).taxes || ',';
               END IF;
            END IF;

            IF v_display_total_taxes = 'Y' THEN 
                     v.rec := v.rec || v_row (i).total_taxes || ',';
            END IF; 
            v.rec :=
                  v.rec
               || v_row (i).total_amount_due
               || ','
               || v_row (i).comm_amt;

            IF v_display_wholding_tax = 'Y'
            THEN
               v.rec := v.rec || ',' || v_row (i).wholding_tax;
            END IF;

            PIPE ROW (v);
         END LOOP;
      END IF;
   END get_gipir923;

   FUNCTION get_gipir924 (p_iss_cd        VARCHAR2,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_scope         VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       VARCHAR2,
                          p_tab           VARCHAR2,
                          p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED
   IS
      v                                dynamic_csv_rec_type;
      v_display_separate_premtax_vat   giis_document.text%TYPE;
      v_display_wholding_tax           giis_document.text%TYPE;
      v_show_total_taxes               giis_document.text%TYPE;
      v_query                          VARCHAR2 (32767);
      v_exists                         NUMBER;

      TYPE row_type IS RECORD
      (
         iss_cd             giis_issource.iss_cd%TYPE,
         iss_name           giis_issource.iss_name%TYPE,
         line_cd            giis_line.line_cd%TYPE,
         line_name          giis_line.line_name%TYPE,
         subline_cd         giis_subline.subline_cd%TYPE,
         subline_name       giis_subline.subline_name%TYPE,
         pol_count          NUMBER,
         total_tsi          NUMBER,
         total_prem         NUMBER,
         vat                NUMBER,
         prem_tax           NUMBER,
         lgt                NUMBER,
         doc_stamps         NUMBER,
         fst                NUMBER,
         other_charges      NUMBER,
         comm_amt           NUMBER,
         wholding_tax       NUMBER,
         total_taxes        NUMBER,
         total_amount_due   NUMBER,
         taxes              VARCHAR2 (32767)
      );

      TYPE row_tab IS TABLE OF row_type;

      v_row                            row_tab;
   BEGIN
      BEGIN
         SELECT text
           INTO v_display_separate_premtax_vat
           FROM giis_document
          WHERE     report_id = 'GIPIR923'
                AND title = 'DISPLAY_SEPARATE_PREMTAX_VAT';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_display_separate_premtax_vat := 'N';
      END;

      BEGIN
         SELECT text
           INTO v_display_wholding_tax
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'DISPLAY_WHOLDING_TAX';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_display_wholding_tax := 'N';
      END;

      BEGIN
         SELECT text
           INTO v_show_total_taxes
           FROM giis_document
          WHERE report_id = 'GIPIR923' AND title = 'SHOW_TOTAL_TAXES';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_show_total_taxes := 'N';
      END;

      IF p_iss_param = 1
      THEN
         v.rec := 'CRED BRANCH,CRED BRANCH NAME,';
      ELSE
         v.rec := 'ISS SOURCE CODE,ISS SOURCE NAME,';
      END IF;

      v.rec :=
            v.rec
         || 'LINE CODE,LINE NAME,SUBLINE CODE,SUBLINE NAME,POLICY COUNT,TOTAL SUM INSURED,TOTAL PREMIUM,';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
      THEN
         IF v_display_separate_premtax_vat = 'N'
         THEN
            v.rec := v.rec || 'VAT/PREMIUM TAX,';
         ELSE
            v.rec := v.rec || 'VAT,PREMIUM TAX,';
         END IF;

         v.rec := v.rec || 'LGT,DOC. STAMPS,FIRE SERVICE TAX,OTHER CHARGES,';
      ELSE
         FOR i
            IN (  SELECT DISTINCT c.tax_cd, c.tax_name
                    FROM gipi_uwreports_ext a,
                         gipi_uwreports_polinv_tax_ext b,
                         giac_taxes c
                   WHERE     a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.rec_type = b.rec_type
                         AND a.user_id = b.user_id
                         AND b.tax_cd = c.tax_cd
                         AND a.user_id = p_user_id
                         AND a.line_cd LIKE NVL (p_line_cd, '%')
                         AND DECODE (p_iss_param,
                                     1, NVL (a.cred_branch, a.iss_cd),
                                     a.iss_cd) LIKE
                                NVL (p_iss_cd, '%')
                         AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                         AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                              OR (p_scope = 2 AND a.endt_seq_no > 0)
                              OR (p_scope = 3 AND a.pol_flag = '4')
                              OR (    p_scope = 4
                                  AND a.pol_flag = '5'
                                  AND NVL (a.reinstate_tag, 'N') =
                                         DECODE (
                                            p_reinstated,
                                            'Y', 'Y',
                                            'N', NVL (a.reinstate_tag, 'N')))
                              OR (p_scope = 5 AND pol_flag <> '5')
                              OR p_scope = 6) --Added by pjsantos 03/14/2017, GENQA 5955
                         AND a.tab_number = p_tab
                ORDER BY c.tax_cd)
         LOOP
            IF i.tax_cd IS NOT NULL
            THEN
               v.rec := v.rec || i.tax_name || ',';
            END IF;
         END LOOP;
      END IF;

      IF v_show_total_taxes = 'N'
      THEN
         v.rec := v.rec || 'TOTAL AMOUNT DUE,';
      ELSE
         v.rec := v.rec || 'TOTAL TAXES,';
      END IF;

      v.rec := v.rec || 'COMMISSION AMOUNT,';

      IF v_display_wholding_tax = 'Y'
      THEN
         v.rec := v.rec || 'WHOLDING TAX,';
      END IF;

      v.rec := SUBSTR (v.rec, 0, LENGTH (v.rec) - 1);
      PIPE ROW (v);
      v_query :=
         'SELECT a.iss_cd, a.iss_name, a.line_cd, a.line_name, a.subline_cd,
                         a.subline_name, SUM (a.pol_count) pol_count,
                         SUM (a.total_tsi) total_tsi, SUM (a.total_prem) total_prem,
                         SUM (a.vat) vat, SUM (a.prem_tax) prem_tax, SUM (a.lgt) lgt,
                         SUM (a.doc_stamps) doc_stamps, SUM (a.fst) fst,
                         SUM (a.other_charges) other_charges, SUM (a.comm_amt) comm_amt,
                         SUM (a.wholding_tax) wholding_tax,
                         SUM((NVL(a.vat, 0) + NVL(a.prem_tax, 0) + NVL(a.lgt, 0) + NVL(a.doc_stamps, 0) + NVL(a.fst, 0) + NVL(a.other_taxes, 0))) total_taxes,
                         SUM((a.total_prem + NVL(a.vat, 0) + NVL(a.prem_tax, 0) + NVL(a.lgt, 0) + NVL(a.doc_stamps, 0) + NVL(a.fst, 0) + NVL(a.other_taxes, 0))) total_amount_due,';

      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
      THEN
         v_query := v_query || 'SUM(0) taxes';
      ELSE
         v_exists := 0;
         FOR i
            IN (  SELECT DISTINCT c.tax_cd, c.tax_name
                    FROM gipi_uwreports_ext a,
                         gipi_uwreports_polinv_tax_ext b,
                         giac_taxes c
                   WHERE     a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.rec_type = b.rec_type
                         AND a.user_id = b.user_id
                         AND b.tax_cd = c.tax_cd
                         AND a.user_id = p_user_id
                         AND a.line_cd LIKE NVL (p_line_cd, '%')
                         AND DECODE (p_iss_param,
                                     1, NVL (a.cred_branch, a.iss_cd),
                                     a.iss_cd) LIKE
                                NVL (p_iss_cd, '%')
                         AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                         AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                              OR (p_scope = 2 AND a.endt_seq_no > 0)
                              OR (p_scope = 3 AND a.pol_flag = '4')
                              OR (    p_scope = 4
                                  AND a.pol_flag = '5'
                                  AND NVL (a.reinstate_tag, 'N') =
                                         DECODE (
                                            p_reinstated,
                                            'Y', 'Y',
                                            'N', NVL (a.reinstate_tag, 'N')))
                              OR (p_scope = 5 AND pol_flag <> '5')
                              OR p_scope = 6) --Added by pjsantos 03/14/2017, GENQA 5955
                         AND a.tab_number = p_tab
                ORDER BY c.tax_cd)
         LOOP
            IF i.tax_cd IS NOT NULL
            THEN
               v_query :=
                     v_query
                  || 'SUM(DECODE(c.tax_cd, '
                  || i.tax_cd
                  || ', b.tax_amt, 0)) || '','' ||';
               v_exists := 1;
            END IF;
         END LOOP;
         
         IF v_exists = 0
         THEN
            v_query := v_query || 'SUM(0) || '','' ||';
         END IF;

         v_query := SUBSTR (v_query, 0, LENGTH (v_query) - 9);
      END IF;

      v_query :=
            v_query
         || ' FROM TABLE (gipir923_pkg.get_details ('''
         || p_iss_cd
         || ''', '''
         || p_line_cd
         || ''', '''
         || p_subline_cd
         || ''','
         || p_scope
         || ','
         || p_iss_param
         || ' , '''
         || p_user_id
         || ''', '
         || p_tab
         || ', '''
         || p_reinstated
         || ''')) a';
         
      
      IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) <> 1
      THEN
          v_query :=
                v_query
             || ', gipi_uwreports_polinv_tax_ext b, giac_taxes c
                WHERE a.policy_id = b.policy_id (+)
                  AND a.iss_cd2 = b.iss_cd (+)
                  AND a.prem_seq_no = b.prem_seq_no (+)
                  AND a.rec_type = b.rec_type (+)
                  AND a.user_id = b.user_id (+)
                  AND b.tax_cd = c.tax_cd (+)';
      END IF;
      
      v_query :=
            v_query
         ||' GROUP BY a.iss_cd, a.iss_name, a.line_cd, a.line_name, a.subline_cd, a.subline_name';

      EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_row;

      IF SQL%FOUND
      THEN
         FOR i IN 1 .. v_row.LAST
         LOOP
            v.rec :=
                  v_row (i).iss_cd
               || ','
               || escape_string (v_row (i).iss_name)
               || ','
               || v_row (i).line_cd
               || ','
               || escape_string (v_row (i).line_name)
               || ','
               || v_row (i).subline_cd
               || ','
               || escape_string (v_row (i).subline_name)
               || ','
               || v_row (i).pol_count
               || ','
               || v_row (i).total_tsi
               || ','
               || v_row (i).total_prem
               || ',';

            IF NVL (giisp.n ('PROD_REPORT_EXTRACT'), 1) = 1
            THEN
               IF v_display_separate_premtax_vat = 'Y'
               THEN
                  v.rec :=
                        v.rec
                     || v_row (i).vat
                     || ','
                     || v_row (i).prem_tax
                     || ',';
               ELSE
                  v.rec :=
                     v.rec || (v_row (i).vat + v_row (i).prem_tax) || ',';
               END IF;

               v.rec :=
                     v.rec
                  || v_row (i).lgt
                  || ','
                  || v_row (i).doc_stamps
                  || ','
                  || v_row (i).fst
                  || ','
                  || v_row (i).other_charges
                  || ',';
            ELSE
               IF v_exists = 1
               THEN
                  v.rec := v.rec || v_row (i).taxes || ',';
               END IF;
            END IF;

            IF v_show_total_taxes = 'Y'
            THEN
               v.rec := v.rec || v_row (i).total_taxes || ',';
            ELSE
               v.rec := v.rec || v_row (i).total_amount_due || ',';
            END IF;

            v.rec := v.rec || v_row (i).comm_amt;

            IF v_display_wholding_tax = 'Y'
            THEN
               v.rec := v.rec || ',' || v_row (i).wholding_tax;
            END IF;
            PIPE ROW (v);
         END LOOP;
      END IF;
   END get_gipir924;
END csv_uw_prodreport;