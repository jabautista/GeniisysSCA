/*
Created by: Gzelle
Date      : 12012015
Remarks   : referenced by GIACR167 and GIACR169
            get_giacr168a_all_rec functions is also used in csv_acctg.officialreceiptsregister_ap_a
            apply changes accordingly.
*/

CREATE OR REPLACE PACKAGE BODY cpi.giacr168a_pkg
AS
   FUNCTION get_giacr168a_parent_rec (
      p_date        DATE,
      p_date2       DATE,
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2,
      p_posted      VARCHAR2
   )
      RETURN parent_rec_tab PIPELINED
   IS
      v_rec            parent_rec_type;
      v_payor          giac_order_of_payts.payor%TYPE;
      v_amt_received   giac_collection_dtl.amount%TYPE;
      v_short_name     giis_currency.short_name%TYPE;

      TYPE cur_type IS REF CURSOR;

      c                cur_type;
      v_sql            VARCHAR2 (16000);
   BEGIN
      v_sql :=
         'SELECT f.branch_cd || '' - '' || f.branch_name branch, a.or_pref_suf, a.or_no,
                  a.or_flag, a.particulars, a.last_update,
                  a.or_pref_suf || ''-'' || LPAD (a.or_no, 9, ''0'') or_number, a.or_date,
                  a.cancel_date, TO_CHAR (a.dcb_no) dcb_number,
                  TO_CHAR (a.cancel_dcb_no) cancel_dcb_number, b.tran_date,
                  b.posting_date,
                  DECODE (a.or_flag,
                          ''C'', ''CANCELLED'',
                          ''R'', ''REPLACED'',
                          a.payor
                         ) payor_name,
                  SUM (c.amount) amount, d.short_name currency,
                  SUM (DECODE (c.currency_cd,
                               1, c.amount,
                               c.fcurrency_amt
                              )) foreign_currency,
                  DECODE (a.or_pref_suf,
                          NULL, ''Z'',
                          SUBSTR (a.or_pref_suf, 1, 1)
                         ) or_type, b.tran_id
             FROM giac_order_of_payts a,
                  giac_acctrans b,
                  giac_collection_dtl c,
                  giis_currency d,
                  giac_branches f
            WHERE a.gacc_tran_id = b.tran_id
              AND a.gibr_gfun_fund_cd = b.gfun_fund_cd
              AND a.gibr_branch_cd = b.gibr_branch_cd
              AND b.tran_id = c.gacc_tran_id
              AND b.gibr_branch_cd = f.branch_cd
              AND a.gibr_branch_cd = f.branch_cd
              AND b.gfun_fund_cd = f.gfun_fund_cd
              AND a.gibr_gfun_fund_cd = f.gfun_fund_cd
              AND c.currency_cd = d.main_currency_cd
              AND check_user_per_iss_cd_acctg2 (NULL,
                                                a.gibr_branch_cd,
                                                ''GIACS160'',
                                                :p_user_id
                                               ) = 1
              AND TRUNC (a.or_date) BETWEEN :p_date AND :p_date2
              AND f.branch_cd = DECODE (:p_branch_cd, NULL, f.branch_cd, :p_branch_cd) ';

      IF p_posted = '1'
      THEN
         v_sql :=
               v_sql
            || ' AND tran_flag = ''P''
                  AND or_flag != ''N''';
      ELSIF p_posted = '2'
      THEN
         v_sql := v_sql || ' AND or_flag != ''N''';
      ELSE
         v_sql :=
               v_sql
            || ' AND tran_flag != ''P''
                  AND or_flag != ''N''';
      END IF;

      v_sql :=
            v_sql
         || '    AND (   (    (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no = a.cancel_dcb_no)
                          )
                       OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no = a.cancel_dcb_no)
                          )
                       OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no <> a.cancel_dcb_no)
                          )
                       OR (a.cancel_date IS NULL)
                       OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no <> a.cancel_dcb_no)
                          )
                      )
                  AND (   (a.or_flag NOT IN (''C'', ''R''))
                       OR (    (a.or_flag IN (''C'', ''R''))
                           AND (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no = a.cancel_dcb_no)
                          )
                       OR (    (a.or_flag IN (''C'', ''R''))
                           AND (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no <> a.cancel_dcb_no)
                          )
                       OR (    (a.or_flag IN (''C'', ''R''))
                           AND (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no = a.cancel_dcb_no)
                          )
                       OR (    (a.or_flag IN (''C'', ''R''))
                           AND (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                                        TRUNC (b.tran_date)
                               )
                           AND (a.dcb_no <> a.cancel_dcb_no)
                          )
                      )
             GROUP BY f.branch_cd || '' - '' || f.branch_name,
                      a.or_pref_suf,
                      a.or_no,
                      a.or_flag,
                      a.particulars,
                      a.last_update,
                      a.or_pref_suf || ''-'' || LPAD (a.or_no, 9, ''0''),
                      a.or_date,
                      a.cancel_date,
                      a.dcb_no,
                      a.cancel_dcb_no,
                      b.tran_date,
                      b.posting_date,
                      DECODE (a.or_flag, ''C'', ''CANCELLED'', ''R'', ''REPLACED'', a.payor),
                      d.short_name,
                      DECODE (a.or_pref_suf, NULL, ''Z'', SUBSTR (a.or_pref_suf, 1, 1)), 
                      b.tran_id ';

      IF p_posted = '1'
      THEN
         v_sql := v_sql || 'ORDER BY 1, 18, 2, 3 ';

         OPEN c FOR v_sql
         USING p_user_id, p_date, p_date2, p_branch_cd, p_branch_cd;
      ELSE
         v_sql :=
               v_sql
            || ' UNION
                  SELECT   f.branch_cd || '' - '' || f.branch_name branch, 
                           e.or_pref, e.or_no, '''' or_flag, '''' particulars, SYSDATE last_update, 
                           e.or_pref || ''-'' || LPAD (e.or_no, 9, ''0'') or_number,
                           e.or_date, SYSDATE cancel_date, 
                           ''      '' dcb_number, 
                           '''' cancel_dcb_number, b.tran_date,
                           b.posting_date,
                           ''SPOILED'' payor_name,
                           TO_NUMBER (NULL) amount, NULL currency,
                           TO_NUMBER (NULL) foreign_currency,
                           DECODE (g.or_type, NULL, ''Z'', g.or_type) or_type, b.tran_id
                      FROM giac_acctrans b,
                           giac_collection_dtl c,
                           giis_currency d,
                           giac_spoiled_or e,
                           giac_branches f,
                           giac_or_pref g
                     WHERE e.tran_id = b.tran_id
                       AND b.tran_id = c.gacc_tran_id
                       AND b.gibr_branch_cd = f.branch_cd
                       AND c.currency_cd = d.main_currency_cd
                       AND e.branch_cd = g.branch_cd(+)
                       AND e.or_pref = g.or_pref_suf(+)
                       AND e.or_date BETWEEN :p_date AND :p_date2
                       AND f.branch_cd = DECODE (:p_branch_cd, NULL, f.branch_cd, :p_branch_cd)
                       AND check_user_per_iss_cd_acctg2 (NULL,
                                                         f.branch_cd,
                                                         ''GIACS160'',
                                                         :p_user_id
                                                        ) = 1
                  GROUP BY f.branch_cd || '' - '' || f.branch_name,
                           e.or_pref,
                           e.or_no,
                           e.or_pref || ''-'' || LPAD (e.or_no, 9, ''0''),
                           e.or_date,
                           b.tran_date,
                           b.posting_date,
                           ''SPOILED'',
                           DECODE (g.or_type, NULL, ''Z'', g.or_type),
                           b.tran_id 
                  UNION
                  SELECT   f.branch_cd || '' - '' || f.branch_name branch, 
                           e.or_pref, e.or_no, '''' or_flag, '''' particulars, SYSDATE last_update, 
                           e.or_pref || ''-'' || LPAD (e.or_no, 9, ''0'') or_number,
                           e.or_date, SYSDATE cancel_date, 
                           ''      '' dcb_number, 
                           '''' cancel_dcb_number, TO_DATE (NULL) tran_date, 
                           TO_DATE (NULL) posting_date,
                           ''SPOILED'' payor_name, 
                           TO_NUMBER (NULL) amount, NULL currency,
                           TO_NUMBER (NULL) foreign_currency,
                           DECODE (g.or_type, NULL, ''Z'', g.or_type) or_type, e.tran_id
                      FROM giac_spoiled_or e, giac_branches f, giac_or_pref g
                     WHERE e.fund_cd = f.gfun_fund_cd
                       AND e.branch_cd = f.branch_cd
                       AND e.tran_id IS NULL
                       AND e.branch_cd = g.branch_cd(+)
                       AND e.or_pref = g.or_pref_suf(+)
                       AND DECODE (e.or_date, NULL, e.spoil_date, e.or_date) BETWEEN :p_date
                                                                                 AND :p_date2
                       AND f.branch_cd = DECODE (:p_branch_cd, NULL, f.branch_cd, :p_branch_cd)
                       AND check_user_per_iss_cd_acctg2 (NULL,
                                                         f.branch_cd,
                                                         ''GIACS160'',
                                                         :p_user_id
                                                        ) = 1
                  GROUP BY f.branch_cd || '' - '' || f.branch_name,
                           e.or_pref,
                           e.or_no,
                           e.or_pref || ''-'' || LPAD (e.or_no, 9, ''0''),
                           e.or_date,
                           ''SPOILED'',
                           DECODE (g.or_type, NULL, ''Z'', g.or_type),
                           e.tran_id
                  ORDER BY 1, 18, 2, 3 ';

         OPEN c FOR v_sql
         USING p_user_id,
               p_date,
               p_date2,
               p_branch_cd,
               p_branch_cd,
               p_date,
               p_date2,
               p_branch_cd,
               p_branch_cd,
               p_user_id,
               p_date,
               p_date2,
               p_branch_cd,
               p_branch_cd,
               p_user_id;
      END IF;

      LOOP
         FETCH c
          INTO v_rec.branch, v_rec.or_pref_suf, v_rec.or_no, v_rec.or_flag,
               v_rec.particulars, v_rec.last_update, v_rec.or_number,
               v_rec.or_date, v_rec.cancel_date, v_rec.dcb_number,
               v_rec.cancel_dcb_number, v_rec.tran_date, v_rec.posting_date,
               v_rec.payor, v_rec.amt_received, v_rec.currency,
               v_rec.foreign_curr_amt, v_rec.or_type, v_rec.tran_id;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_giacr168a_parent_rec;

   FUNCTION get_giacr168a_tax_amt (
      p_tran_id   giac_acctrans.tran_id%TYPE,
      p_tax_cd    giac_tax_collns.b160_tax_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_tax_amt   giac_tax_collns.tax_amt%TYPE   := 0;
   BEGIN
      FOR x IN (SELECT SUM(tax_amt) tax_amt
                  FROM giac_tax_collns
                 WHERE gacc_tran_id = p_tran_id AND b160_tax_cd = p_tax_cd)
      LOOP
         v_tax_amt := x.tax_amt;
      END LOOP;

      RETURN v_tax_amt;
   END get_giacr168a_tax_amt;

   FUNCTION get_giacr168a_prem_amt (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN NUMBER
   IS
      v_prem_amt   giac_direct_prem_collns.premium_amt%TYPE   := 0;
   BEGIN
      FOR x IN (SELECT SUM(premium_amt) premium_amt
                  FROM giac_direct_prem_collns
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_prem_amt := x.premium_amt;
      END LOOP;

      IF v_prem_amt IS NULL OR v_prem_amt = 0
      THEN
         FOR x IN (SELECT SUM(premium_amt) premium_amt
                     FROM giac_inwfacul_prem_collns
                    WHERE gacc_tran_id = p_tran_id)
         LOOP
            v_prem_amt := x.premium_amt;
         END LOOP;
      END IF;

      RETURN v_prem_amt;
   END get_giacr168a_prem_amt;

   FUNCTION get_or_tag (p_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
      RETURN VARCHAR2
   IS
      v_or_tag   giac_order_of_payts.or_tag%TYPE;
   BEGIN
      FOR y IN (SELECT DECODE (or_tag, '*', 'M', NULL, 'S') or_tag
                  FROM giac_order_of_payts
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_or_tag := y.or_tag;
         EXIT;
      END LOOP;

      RETURN v_or_tag;
   END;

   FUNCTION get_giacr168a_all_rec (
      p_date        VARCHAR2,
      p_date2       VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2,
      p_posted      VARCHAR2,
      p_or_tag      VARCHAR2
   )
      RETURN parent_rec_tab PIPELINED
   IS
      v_row            parent_rec_type;
      v_tax_amt        giac_tax_collns.tax_amt%TYPE;
      v_payor          giac_order_of_payts.payor%TYPE;
      v_amt_received   giac_collection_dtl.amount%TYPE;
      v_top_date       VARCHAR2 (1060)                   := '';
      v_print_all      BOOLEAN;
      v_date           DATE                 := TO_DATE (p_date, 'MM-DD-YYYY');
      v_date2          DATE                := TO_DATE (p_date2, 'MM-DD-YYYY');
      v_cnt            NUMBER                            := 0;
   BEGIN
      SELECT UPPER (param_value_v)
        INTO v_row.company_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      SELECT UPPER (param_value_v)
        INTO v_row.company_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      IF v_date = v_date2
      THEN
         v_top_date := TO_CHAR (v_date, 'fmMonth DD, YYYY');
      ELSE
         v_top_date :=
               'From '
            || TO_CHAR (v_date, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_date2, 'fmMonth DD, YYYY');
      END IF;

      IF p_posted = '1'
      THEN
         v_row.posted := 'Posted Official Receipts';
      ELSIF p_posted = '2'
      THEN
         v_row.posted := 'All Posted and Unposted Official Receipts';
      ELSE
         v_row.posted := 'Unposted Official Receipts';
      END IF;

      v_row.top_date := v_top_date;
      v_print_all := FALSE;

      FOR x IN
         (SELECT a.*
            FROM TABLE (giacr168a_pkg.get_giacr168a_parent_rec (v_date,
                                                                v_date2,
                                                                p_branch_cd,
                                                                p_user_id,
                                                                p_posted
                                                               )
                       ) a)
      LOOP
         v_print_all                := TRUE;
         v_row.branch               := x.branch;
         v_row.or_pref_suf          := x.or_pref_suf;
         v_row.or_no                := x.or_no;
         v_row.or_flag              := x.or_flag;
         v_row.particulars          := x.particulars;
         v_row.last_update          := x.last_update;
         v_row.or_number            := x.or_number;
         v_row.or_date              := x.or_date;
         v_row.cancel_date          := x.cancel_date;
         v_row.dcb_number           := x.dcb_number;
         v_row.cancel_dcb_number    := x.cancel_dcb_number;
         v_row.tran_date            := x.tran_date;
         v_row.posting_date         := x.posting_date;

         IF     x.cancel_date IS NOT NULL
            AND x.payor <> 'SPOILED'
            AND x.payor <> 'REPLACED'
         THEN
            IF TRUNC (x.cancel_date) <> TRUNC (x.or_date)
            THEN
               v_payor :=
                     x.payor
                  || ' ON '
                  || TO_CHAR (x.cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || x.cancel_dcb_number;
            ELSIF     TRUNC (x.cancel_date) = TRUNC (x.or_date)
                  AND x.dcb_number <> x.cancel_dcb_number
            THEN
               v_payor :=
                     x.payor
                  || ' ON '
                  || TO_CHAR (x.cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || x.cancel_dcb_number;
            ELSE
               v_payor := x.payor;
            END IF;
         ELSIF     x.cancel_date IS NOT NULL
               AND x.payor <> 'SPOILED'
               AND x.payor = 'REPLACED'
         THEN
            v_payor :=
                  x.payor
               || ' ON '
               || TO_CHAR (x.last_update, 'MM-DD-RRRR')
               || ' WITH OR DATE '
               || TO_CHAR (x.or_date, 'MM-DD-RRRR');
         ELSE
            v_payor := x.payor;
         END IF;

         IF x.payor IN ('CANCELLED', 'REPLACED')
         THEN
            IF     x.payor IN ('CANCELLED', 'REPLACED')
               AND TRUNC (x.or_date) <> TRUNC (x.cancel_date)
            THEN
               v_amt_received := x.amt_received;
            ELSIF     x.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (x.or_date) = TRUNC (x.cancel_date))
                  AND (x.dcb_number <> x.cancel_dcb_number)
            THEN
               v_amt_received := x.amt_received;
            ELSIF     x.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (x.or_date) = TRUNC (x.cancel_date))
                  AND (x.dcb_number = x.cancel_dcb_number)
            THEN
               v_amt_received := 0;
            ELSIF     x.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (x.or_date) = TRUNC (x.cancel_date))
            THEN
               v_amt_received := 0;
            ELSE
               v_amt_received := x.amt_received;
            END IF;
         ELSE
            v_amt_received := x.amt_received;
         END IF;

         IF x.currency = giacp.v ('DEFAULT_CURRENCY')
         THEN
            v_row.foreign_curr_amt := v_amt_received;
         ELSE
            v_row.foreign_curr_amt := x.foreign_curr_amt;
         END IF;

         v_row.payor        := v_payor;
         v_row.amt_received := v_amt_received;
         v_row.currency     := x.currency;
         v_row.or_type      := x.or_type;
         v_row.tran_id      := x.tran_id;
         v_row.or_tag       := giacr168a_pkg.get_or_tag (x.tran_id);

         IF x.payor <> 'SPOILED'
         THEN
            v_row.prem_amt    := NVL(giacr168a_pkg.get_giacr168a_prem_amt (x.tran_id), 0);
            v_row.vat_tax_amt := NVL(giacr168a_pkg.get_giacr168a_tax_amt (x.tran_id,giacp.n ('EVAT')), 0);
            v_row.lgt_tax_amt := NVL(giacr168a_pkg.get_giacr168a_tax_amt (x.tran_id, giacp.n ('LGT')), 0);
            v_row.dst_tax_amt := NVL(giacr168a_pkg.get_giacr168a_tax_amt (x.tran_id, giacp.n ('DOC_STAMPS')), 0);
            v_row.fst_tax_amt := NVL(giacr168a_pkg.get_giacr168a_tax_amt (x.tran_id, giacp.n ('FST')), 0);

            FOR y IN
               (SELECT SUM (tax_amt) tax_amt
                  FROM giac_tax_collns
                 WHERE gacc_tran_id = x.tran_id
                   AND NOT EXISTS (
                          SELECT param_value_n
                            FROM giac_parameters
                           WHERE param_name IN
                                         ('EVAT', 'LGT', 'DOC_STAMPS', 'FST')
                             AND param_value_n = b160_tax_cd))
            LOOP
               v_row.other_tax_amt := NVL (y.tax_amt, 0);
            END LOOP;
         ELSE
            v_row.prem_amt := NULL;
            v_row.vat_tax_amt := NULL;
            v_row.lgt_tax_amt := NULL;
            v_row.dst_tax_amt := NULL;
            v_row.fst_tax_amt := NULL;
            v_row.other_tax_amt := NULL;
            v_row.foreign_curr_amt := NULL;
         END IF;

         IF NVL (p_or_tag, 'X') = 'X'
         THEN
            v_row.or_tag := 'X';
         END IF;

         IF NVL (p_or_tag, 'X') = v_row.or_tag
         THEN
            v_cnt := v_cnt + 1;
            v_row.v_print_all := 'TRUE';
            PIPE ROW (v_row);
         END IF;
      END LOOP;

      IF v_cnt = 0
      THEN
         v_print_all := FALSE;
      END IF;

      IF v_print_all = FALSE
      THEN
         v_row.foreign_curr_amt := NULL;
         v_row.amt_received     := NULL;
         v_row.currency         := NULL;
         v_row.or_tag           := 'M';
         v_row.v_print_all      := 'FALSE';
         PIPE ROW (v_row);
      END IF;
   END get_giacr168a_all_rec;
END;                                              -- end of GIACR168A_PKG body
/