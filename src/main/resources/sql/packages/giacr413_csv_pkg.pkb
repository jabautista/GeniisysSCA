CREATE OR REPLACE PACKAGE BODY cpi.giacr413_csv_pkg
AS
   FUNCTION get_branch_name (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_iss_name   giis_issource.iss_name%TYPE;
   BEGIN
      SELECT iss_name
        INTO v_iss_name
        FROM giis_issource
       WHERE iss_cd = p_iss_cd;

      RETURN (v_iss_name);
   END;

   FUNCTION get_intm_desc (p_intm_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_intm_desc   giis_intm_type.intm_desc%TYPE;
   BEGIN
      SELECT intm_desc
        INTO v_intm_desc
        FROM giis_intm_type
       WHERE intm_type = p_intm_type;

      RETURN (v_intm_desc);
   END;
   
   FUNCTION get_reference_no (
      p_tran_id      NUMBER,
      p_tran_class   VARCHAR2,
      p_tran_date    DATE
   )
      RETURN VARCHAR2
   IS
      v_ref_no      VARCHAR2 (60);
      v_tran_date   DATE;
   BEGIN
      v_ref_no := get_ref_no (p_tran_id);

      IF p_tran_class = 'COL'
      THEN
         BEGIN
            SELECT or_date
              INTO v_tran_date
              FROM giac_order_of_payts
             WHERE gacc_tran_id = p_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tran_date := p_tran_date;
         END;
      ELSIF p_tran_class = 'DV'
      THEN
         BEGIN
            SELECT dv_date
              INTO v_tran_date
              FROM giac_disb_vouchers
             WHERE gacc_tran_id = p_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               BEGIN
                  SELECT request_date
                    INTO v_tran_date
                    FROM giac_payt_requests a, giac_payt_requests_dtl c
                   WHERE a.ref_id = c.gprq_ref_id AND c.tran_id = p_tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_tran_date := p_tran_date;
               END;
         END;
      ELSE
         v_tran_date := p_tran_date;
      END IF;
      
      IF SUBSTR (v_ref_no, 1, 1) = '-'
      THEN
         v_ref_no := '''' || v_ref_no;
      END IF;

      RETURN (v_ref_no || ' / ' || TO_CHAR (v_tran_date, 'MM-DD-YYYY'));
   END;

   FUNCTION escape_string (p_string VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN '"' || REPLACE (p_string, '"', '""') || '"';
   END;

   FUNCTION get_giacr413a (
      p_branch_cd   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED
   IS
      v             csv_rec_type;
      v_col_hdr     VARCHAR2 (1000);
      v_col_val     VARCHAR2 (32767);
      v_from_date   DATE             := TO_DATE (p_from_date, 'MM/DD/RRRR');
      v_to_date     DATE             := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      v_col_hdr :=
            'Branch,Intermediary Type,Intm No.,Intermediary Name,Line Code,'
         || 'Commission,Withholding Tax,Input VAT,Net';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   f.iss_cd, d.intm_type, a.intm_no, d.intm_name, e.line_cd,
                   TO_CHAR (SUM (a.comm_amt),
                            'fm999,999,999,990.00') comm_amt,
                   TO_CHAR (SUM (a.wtax_amt),
                            'fm999,999,999,990.00') wtax_amt,
                   TO_CHAR (SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) input_vat,
                   TO_CHAR (  SUM (a.comm_amt)
                            - SUM (a.wtax_amt)
                            + SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) net_amt
              FROM gipi_polbasic e,
                   giac_comm_payts a,
                   gipi_comm_invoice f,
                   giac_acctrans b,
                   giis_intermediary d
             WHERE d.intm_type = NVL (p_intm_type, d.intm_type)
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN v_from_date
                                                       AND v_to_date
                       )
                   )
               AND b.tran_flag <> 'D'
               AND b.tran_class NOT IN ('CP', 'CPR')
               AND b.tran_id > 0
               AND a.gacc_tran_id = b.tran_id
               AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
               AND EXISTS (
                      SELECT 'X'
                        FROM TABLE
                                (security_access.get_branch_line ('AC',
                                                                  p_module_id,
                                                                  p_user_id
                                                                 )
                                )
                       WHERE branch_cd = a.iss_cd)
               AND f.intrmdry_intm_no > 0
               AND f.iss_cd = a.iss_cd
               AND f.prem_seq_no = a.prem_seq_no
               AND f.intrmdry_intm_no = a.intm_no
               AND a.intm_no = d.intm_no
               AND e.policy_id = f.policy_id
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id)
          GROUP BY f.iss_cd, d.intm_type, a.intm_no, d.intm_name, e.line_cd
          ORDER BY 1, 2, 3, 4, 5)
      LOOP
         v_col_val :=
               escape_string (get_branch_name (i.iss_cd))
            || ','
            || escape_string (get_intm_desc (i.intm_type))
            || ','
            || i.intm_no
            || ','
            || escape_string (i.intm_name)
            || ','
            || i.line_cd
            || ','
            || escape_string (i.comm_amt)
            || ','
            || escape_string (i.wtax_amt)
            || ','
            || escape_string (i.input_vat)
            || ','
            || escape_string (i.net_amt);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END get_giacr413a;

   FUNCTION get_giacr413b (
      p_branch_cd   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED
   IS
      v             csv_rec_type;
      v_col_hdr     VARCHAR2 (1000);
      v_col_val     VARCHAR2 (32767);
      v_from_date   DATE             := TO_DATE (p_from_date, 'MM/DD/RRRR');
      v_to_date     DATE             := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      v_col_hdr :=
            'Branch,Intermediary Type,Intm No.,Intermediary Name,'
         || 'Commission,Withholding Tax,Input VAT,Net';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   a.iss_cd, d.intm_type, a.intm_no, d.intm_name,
                   TO_CHAR (SUM (a.comm_amt),
                            'fm999,999,999,990.00') comm_amt,
                   TO_CHAR (SUM (a.wtax_amt),
                            'fm999,999,999,990.00') wtax_amt,
                   TO_CHAR (SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) input_vat,
                   TO_CHAR (  SUM (a.comm_amt)
                            - SUM (a.wtax_amt)
                            + SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) net_amt
              FROM giac_comm_payts a, giac_acctrans b, giis_intermediary d
             WHERE a.gacc_tran_id = b.tran_id
               AND a.intm_no = d.intm_no
               AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
               AND EXISTS (
                      SELECT 'X'
                        FROM TABLE
                                (security_access.get_branch_line ('AC',
                                                                  p_module_id,
                                                                  p_user_id
                                                                 )
                                )
                       WHERE branch_cd = a.iss_cd)
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN v_from_date
                                                       AND v_to_date
                       )
                   )
               AND b.tran_flag <> 'D'
               AND b.tran_class NOT IN ('CP', 'CPR')
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND d.intm_type = NVL (p_intm_type, d.intm_type)
                         AND c.gacc_tran_id = a.gacc_tran_id)
          GROUP BY a.iss_cd, d.intm_type, a.intm_no, d.intm_name
          ORDER BY 1, 2, 4)
      LOOP
         v_col_val :=
               escape_string (get_branch_name (i.iss_cd))
            || ','
            || escape_string (get_intm_desc (i.intm_type))
            || ','
            || i.intm_no
            || ','
            || escape_string (i.intm_name)
            || ','
            || escape_string (i.comm_amt)
            || ','
            || escape_string (i.wtax_amt)
            || ','
            || escape_string (i.input_vat)
            || ','
            || escape_string (i.net_amt);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END get_giacr413b;

   FUNCTION get_giacr413c (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED
   IS
      v             csv_rec_type;
      v_col_hdr     VARCHAR2 (1000);
      v_col_val     VARCHAR2 (32767);
      v_from_date   DATE             := TO_DATE (p_from_date, 'MM/DD/RRRR');
      v_to_date     DATE             := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      v_col_hdr :=
            'Intermediary Type,Intm No.,Intermediary Name,Line Code,'
         || 'Commission,Withholding Tax,Input VAT,Net';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   d.intm_type, a.intm_no, e.line_cd, d.intm_name,
                   TO_CHAR (SUM (a.comm_amt),
                            'fm999,999,999,990.00') comm_amt,
                   TO_CHAR (SUM (a.wtax_amt),
                            'fm999,999,999,990.00') wtax_amt,
                   TO_CHAR (SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) input_vat,
                   TO_CHAR (  SUM (a.comm_amt)
                            - SUM (a.wtax_amt)
                            + SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) net_amt
              FROM gipi_polbasic e,
                   giac_comm_payts a,
                   gipi_comm_invoice f,
                   giac_acctrans b,
                   giis_intermediary d
             WHERE 1 = 1
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN v_from_date
                                                       AND v_to_date
                       )
                   )
               AND b.tran_flag <> 'D'
               AND b.tran_class NOT IN ('CP', 'CPR')
               AND b.tran_id > 0
               AND a.gacc_tran_id = b.tran_id
               AND d.intm_type = NVL (p_intm_type, d.intm_type)
               AND f.intrmdry_intm_no > 0
               AND f.iss_cd = a.iss_cd
               AND EXISTS (
                      SELECT 'X'
                        FROM TABLE
                                (security_access.get_branch_line ('AC',
                                                                  p_module_id,
                                                                  p_user_id
                                                                 )
                                )
                       WHERE branch_cd = a.iss_cd)
               AND f.prem_seq_no = a.prem_seq_no
               AND a.intm_no = d.intm_no
               AND a.intm_no = f.intrmdry_intm_no
               AND e.policy_id = f.policy_id
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id)
          GROUP BY d.intm_type, a.intm_no, e.line_cd, d.intm_name
          ORDER BY 1, 2, 3)
      LOOP
         v_col_val :=
               escape_string (get_intm_desc (i.intm_type))
            || ','
            || i.intm_no
            || ','
            || escape_string (i.intm_name)
            || ','
            || i.line_cd
            || ','
            || escape_string (i.comm_amt)
            || ','
            || escape_string (i.wtax_amt)
            || ','
            || escape_string (i.input_vat)
            || ','
            || escape_string (i.net_amt);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END get_giacr413c;

   FUNCTION get_giacr413d (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED
   IS
      v             csv_rec_type;
      v_col_hdr     VARCHAR2 (1000);
      v_col_val     VARCHAR2 (32767);
      v_from_date   DATE             := TO_DATE (p_from_date, 'MM/DD/RRRR');
      v_to_date     DATE             := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      v_col_hdr :=
            'Intermediary Type,Intm No.,Intermediary Name,'
         || 'Commission,Withholding Tax,Input VAT,Net';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   d.intm_type, a.intm_no, d.intm_name, c.intm_desc,
                   TO_CHAR (SUM (a.comm_amt),
                            'fm999,999,999,990.00') comm_amt,
                   TO_CHAR (SUM (a.wtax_amt),
                            'fm999,999,999,990.00') wtax_amt,
                   TO_CHAR (SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) input_vat,
                   TO_CHAR (  SUM (a.comm_amt)
                            - SUM (a.wtax_amt)
                            + SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) net_amt
              FROM giac_comm_payts a,
                   giac_acctrans b,
                   giis_intm_type c,
                   giis_intermediary d
             WHERE a.gacc_tran_id = b.tran_id
               AND c.intm_type = d.intm_type
               AND a.intm_no = d.intm_no
               AND d.intm_type = NVL (p_intm_type, d.intm_type)
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN v_from_date
                                                       AND v_to_date
                       )
                   )
               AND b.tran_flag <> 'D'
               AND b.tran_class NOT IN ('CP', 'CPR')
               AND EXISTS (
                      SELECT 'X'
                        FROM TABLE
                                 (security_access.get_branch_line ('AC',
                                                                   'GIACS413',
                                                                   p_user_id
                                                                  )
                                 )
                       WHERE branch_cd = a.iss_cd)
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id)
          GROUP BY d.intm_type, a.intm_no, d.intm_name, c.intm_desc
          ORDER BY 1, 3)
      LOOP
         v_col_val :=
               escape_string (get_intm_desc (i.intm_type))
            || ','
            || i.intm_no
            || ','
            || escape_string (i.intm_name)
            || ','
            || escape_string (i.comm_amt)
            || ','
            || escape_string (i.wtax_amt)
            || ','
            || escape_string (i.input_vat)
            || ','
            || escape_string (i.net_amt);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END get_giacr413d;

   FUNCTION get_giacr413e (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED
   IS
      v             csv_rec_type;
      v_col_hdr     VARCHAR2 (1000);
      v_col_val     VARCHAR2 (32767);
      v_from_date   DATE             := TO_DATE (p_from_date, 'MM/DD/RRRR');
      v_to_date     DATE             := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      v_col_hdr :=
            'Intermediary Type,Intm No.,Intermediary Name,Policy Number,'
         || 'Commission,Withholding Tax,Input VAT,Net';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   d.intm_type, a.intm_no, d.intm_name,
                   get_policy_no (f.policy_id) policy_no,
                   TO_CHAR (SUM (a.comm_amt),
                            'fm999,999,999,990.00') comm_amt,
                   TO_CHAR (SUM (a.wtax_amt),
                            'fm999,999,999,990.00') wtax_amt,
                   TO_CHAR (SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) input_vat,
                   TO_CHAR (  SUM (a.comm_amt)
                            - SUM (a.wtax_amt)
                            + SUM (input_vat_amt),
                            'fm999,999,999,990.00'
                           ) net_amt
              FROM giac_comm_payts a,
                   gipi_comm_invoice f,
                   giac_acctrans b,
                   giis_intermediary d
             WHERE 1 = 1
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN v_from_date
                                                       AND v_to_date
                       )
                   )
               AND b.tran_flag <> 'D'
               AND b.tran_class NOT IN ('CP', 'CPR')
               AND b.tran_id > 0
               AND a.gacc_tran_id = b.tran_id
               AND d.intm_type = NVL (p_intm_type, d.intm_type)
               AND f.intrmdry_intm_no > 0
               AND f.iss_cd = a.iss_cd
               AND EXISTS (
                      SELECT 'X'
                        FROM TABLE
                                (security_access.get_branch_line ('AC',
                                                                  p_module_id,
                                                                  p_user_id
                                                                 )
                                )
                       WHERE branch_cd = a.iss_cd)
               AND f.prem_seq_no = a.prem_seq_no
               AND a.intm_no = d.intm_no
               AND a.intm_no = f.intrmdry_intm_no
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id)
          GROUP BY d.intm_type,
                   a.intm_no,
                   d.intm_name,
                   get_policy_no (f.policy_id)
          ORDER BY 1, 2, 3, 4)
      LOOP
         v_col_val :=
               escape_string (get_intm_desc (i.intm_type))
            || ','
            || i.intm_no
            || ','
            || escape_string (i.intm_name)
            || ','
            || escape_string (i.policy_no)
            || ','
            || escape_string (i.comm_amt)
            || ','
            || escape_string (i.wtax_amt)
            || ','
            || escape_string (i.input_vat)
            || ','
            || escape_string (i.net_amt);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END get_giacr413e;

   FUNCTION get_giacr413f (
      p_branch_cd   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED
   IS
      v             csv_rec_type;
      v_col_hdr     VARCHAR2 (1000);
      v_col_val     VARCHAR2 (32767);
      v_from_date   DATE             := TO_DATE (p_from_date, 'MM/DD/RRRR');
      v_to_date     DATE             := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      v_col_hdr :=
            'Branch,Intermediary Type,Intm No.,Intermediary Name,Policy Number,'
         || 'Bill No.,Comm Voucher No. / Date,Reference No. / Date,Commission,'
         || 'Withholding Tax,Input VAT,Net';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   d.intm_type, a.intm_no, f.iss_cd,
                   f.iss_cd || '-' || LPAD (f.prem_seq_no, 12, 0) bill_no,
                   d.intm_name, get_policy_no (f.policy_id) policy_no,
                   b.tran_id, b.tran_class, b.tran_date,
                   TO_CHAR (a.comm_amt, 'fm999,999,999,990.00') a_comm,
                   TO_CHAR (a.wtax_amt, 'fm999,999,999,990.00') a_wtax,
                   TO_CHAR (a.input_vat_amt,
                            'fm999,999,999,990.00'
                           ) a_input_vat,
                   TO_CHAR (g.comm_amt, 'fm999,999,999,990.00') g_comm,
                   TO_CHAR (g.wtax_amt, 'fm999,999,999,990.00') g_wtax,
                   TO_CHAR (g.input_vat_amt,
                            'fm999,999,999,990.00'
                           ) g_input_vat,
                   TO_CHAR (  DECODE (g.comm_amt,
                                      NULL, a.comm_amt,
                                      g.comm_amt
                                     )
                            - a.wtax_amt
                            + a.input_vat_amt,
                            'fm999,999,999,990.00'
                           ) net_amt,
                   DECODE (g.comm_amt,
                           NULL, NULL,
                              g.ref_no
                           || ' / '
                           || TO_CHAR (g.comm_slip_date, 'MM-DD-YYYY')
                          ) comm_voucher
              FROM giac_comm_payts a,
                   gipi_comm_invoice f,
                   giac_acctrans b,
                   giis_intermediary d,
                   (SELECT gacc_tran_id,
                           comm_slip_pref || '-' || comm_slip_no ref_no,
                           iss_cd || '-' || prem_seq_no bill_no, comm_amt,
                           wtax_amt, input_vat_amt, comm_slip_date,
                              iss_cd
                           || '-'
                           || prem_seq_no
                           || '-'
                           || intm_no bill_no_intm
                      FROM giac_comm_fund_ext z
                     WHERE comm_slip_no IS NOT NULL
                       AND NVL (spoiled_tag, 'N') = 'N'
                       AND EXISTS (
                              SELECT 1
                                FROM giac_comm_payts
                               WHERE iss_cd = z.iss_cd
                                 AND prem_seq_no = z.prem_seq_no
                                 AND intm_no = z.intm_no)
                    UNION ALL
                    SELECT p2.gacc_tran_id,
                           cv_pref || '-' || LPAD (cv_no, 10, 0) ref_no,
                           y.iss_cd || '-' || y.prem_seq_no bill_no,
                           (commission_amt - p1.comm_amt) comm_amt,
                           (wholding_tax - p1.wtax_amt) wtax_amt,
                           (input_vat - p1.input_vat_amt) input_vat_amt,
                           cv_date,
                              y.iss_cd
                           || '-'
                           || y.prem_seq_no
                           || '-'
                           || y.intm_no bill_no_intm
                      FROM giac_comm_voucher_ext y,
                           (SELECT   gacc_tran_id, iss_cd, prem_seq_no,
                                     intm_no, SUM (comm_amt) comm_amt,
                                     SUM (wtax_amt) wtax_amt,
                                     SUM (input_vat_amt) input_vat_amt
                                FROM giac_comm_payts m1
                               WHERE EXISTS (
                                        SELECT '1'
                                          FROM giac_comm_fund_ext t1
                                         WHERE t1.gacc_tran_id =
                                                               m1.gacc_tran_id
                                           AND t1.iss_cd = m1.iss_cd
                                           AND t1.prem_seq_no = m1.prem_seq_no
                                           AND t1.intm_no = m1.intm_no
                                           AND comm_slip_no IS NOT NULL
                                        UNION ALL
                                        SELECT '1'
                                          FROM giac_comm_slip_ext s1
                                         WHERE s1.gacc_tran_id =
                                                               m1.gacc_tran_id
                                           AND s1.iss_cd = m1.iss_cd
                                           AND s1.prem_seq_no = m1.prem_seq_no
                                           AND s1.intm_no = m1.intm_no
                                           AND comm_slip_no IS NOT NULL)
                            GROUP BY gacc_tran_id,
                                     iss_cd,
                                     prem_seq_no,
                                     intm_no) p1,
                           (SELECT gacc_tran_id, iss_cd, prem_seq_no, intm_no
                              FROM giac_comm_payts m2
                             WHERE NOT EXISTS (
                                      SELECT '1'
                                        FROM giac_comm_fund_ext t2
                                       WHERE t2.gacc_tran_id = m2.gacc_tran_id
                                         AND t2.iss_cd = m2.iss_cd
                                         AND t2.prem_seq_no = m2.prem_seq_no
                                         AND t2.intm_no = m2.intm_no
                                         AND comm_slip_no IS NOT NULL
                                      UNION ALL
                                      SELECT '1'
                                        FROM giac_comm_slip_ext s2
                                       WHERE s2.gacc_tran_id = m2.gacc_tran_id
                                         AND s2.iss_cd = m2.iss_cd
                                         AND s2.prem_seq_no = m2.prem_seq_no
                                         AND s2.intm_no = m2.intm_no
                                         AND comm_slip_no IS NOT NULL)) p2
                     WHERE cv_no IS NOT NULL
                       AND y.iss_cd = p1.iss_cd
                       AND y.prem_seq_no = p1.prem_seq_no
                       AND y.intm_no = p1.intm_no
                       AND y.iss_cd = p2.iss_cd
                       AND y.prem_seq_no = p2.prem_seq_no
                       AND y.intm_no = p2.intm_no
                    UNION ALL
                    SELECT gacc_tran_id,
                           comm_slip_pref || '-' || comm_slip_no,
                           iss_cd || '-' || prem_seq_no bill_no, comm_amt,
                           wtax_amt, input_vat_amt, comm_slip_date,
                              iss_cd
                           || '-'
                           || prem_seq_no
                           || '-'
                           || intm_no bill_no_intm
                      FROM giac_comm_slip_ext x
                     WHERE comm_slip_no IS NOT NULL
                       AND EXISTS (
                              SELECT 1
                                FROM giac_comm_payts
                               WHERE iss_cd = x.iss_cd
                                 AND prem_seq_no = x.prem_seq_no
                                 AND intm_no = x.intm_no)) g
             WHERE d.intm_type = NVL (p_intm_type, d.intm_type)
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN v_from_date
                                                       AND v_to_date
                       )
                   )
               AND b.tran_flag <> 'D'
               AND b.tran_class NOT IN ('CP', 'CPR')
               AND b.tran_id > 0
               AND a.gacc_tran_id = b.tran_id
               AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
               AND EXISTS (
                      SELECT 'X'
                        FROM TABLE
                                (security_access.get_branch_line ('AC',
                                                                  p_module_id,
                                                                  p_user_id
                                                                 )
                                )
                       WHERE branch_cd = a.iss_cd)
               AND f.intrmdry_intm_no > 0
               AND f.iss_cd = a.iss_cd
               AND f.prem_seq_no = a.prem_seq_no
               AND a.intm_no = d.intm_no
               AND a.intm_no = f.intrmdry_intm_no
               AND a.iss_cd || '-' || a.prem_seq_no || '-' || a.intm_no = g.bill_no_intm(+)
               AND a.gacc_tran_id = g.gacc_tran_id(+)
               AND a.comm_amt = g.comm_amt(+)
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id)
          ORDER BY 3, 1, 2, 6)
      LOOP
         IF SUBSTR (i.comm_voucher, 1, 1) = '-'
         THEN
            i.comm_voucher := '''' || i.comm_voucher;
         END IF;
         
         v_col_val :=
               escape_string (get_branch_name (i.iss_cd))
            || ','
            || escape_string (get_intm_desc (i.intm_type))
            || ','
            || i.intm_no
            || ','
            || escape_string (i.intm_name)
            || ','
            || escape_string (i.policy_no)
            || ','
            || i.bill_no
            || ','
            || escape_string (i.comm_voucher)
            || ','
            || escape_string (get_reference_no (i.tran_id,
                                                i.tran_class,
                                                i.tran_date
                                               )
                             )
            || ','
            || escape_string (COALESCE (i.g_comm, i.a_comm))
            || ','
            || escape_string (i.a_wtax)
            || ','
            || escape_string (i.a_input_vat)
            || ','
            || escape_string (i.net_amt);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END get_giacr413f;
END giacr413_csv_pkg;
/