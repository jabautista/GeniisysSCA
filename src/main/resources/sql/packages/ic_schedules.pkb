CREATE OR REPLACE PACKAGE BODY CPI.ic_schedules
AS
   FUNCTION get_ctpl_pct (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_ctpl          NUMBER
   )
      RETURN NUMBER
   AS
      CURSOR ctpl_prem
      IS
         SELECT prem_amt
           FROM gipi_invperil h
          WHERE h.iss_cd = p_iss_cd
            AND h.prem_seq_no = p_prem_seq_no
            AND h.peril_cd = p_ctpl;

      CURSOR total_prem
      IS
         SELECT SUM (prem_amt) prem_amt
           FROM gipi_invperil h
          WHERE h.iss_cd = p_iss_cd AND h.prem_seq_no = p_prem_seq_no;

      v_pct          NUMBER;
      v_ctpl_prem    NUMBER;
      v_total_prem   NUMBER;
   BEGIN
      OPEN ctpl_prem;

      FETCH ctpl_prem
       INTO v_ctpl_prem;

      CLOSE ctpl_prem;

      OPEN total_prem;

      FETCH total_prem
       INTO v_total_prem;

      CLOSE total_prem;

      IF v_total_prem = 0
      THEN
         v_total_prem := 1;
      END IF;

      v_pct := v_ctpl_prem / v_total_prem;
      RETURN v_pct;
   END;

   FUNCTION get_or_no (p_gacc_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
      RETURN VARCHAR2
   AS
      CURSOR or_no
      IS
         SELECT    or_pref_suf
                || '-'
                || LTRIM (TO_CHAR (or_no, '0000000000')) or_no
           FROM giac_order_of_payts
          WHERE gacc_tran_id = p_gacc_tran_id;

      v_or_no   VARCHAR2 (50);
   BEGIN
      FOR rec IN or_no
      LOOP
         v_or_no := rec.or_no;
      END LOOP;

      RETURN v_or_no;
   END;

   FUNCTION get_prev_prem_colln (
      p_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no   giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_tran_date     DATE,
      p_tran_type     giac_direct_prem_collns.transaction_type%TYPE,
      p_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE
   )
      RETURN NUMBER
   AS
      CURSOR prev_colln
      IS
         SELECT NVL (SUM (premium_amt), 0) prem_amt
           FROM giac_direct_prem_collns a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND a.b140_iss_cd = p_iss_cd
            AND a.b140_prem_seq_no = p_prem_seq_no
            AND b.tran_flag != 'D'
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giac_reversals x, giac_acctrans y
                    WHERE x.reversing_tran_id = y.tran_id
                      AND y.tran_flag != 'D'
                      AND x.gacc_tran_id = a.gacc_tran_id
                      AND TRUNC (y.tran_date) >= p_tran_date)
            AND tran_date <= p_tran_date
            AND transaction_type =
                   DECODE (p_tran_type,
                           1, transaction_type,
                           3, transaction_type,
                           p_tran_type
                          )
            AND gacc_tran_id != p_tran_id;

      v_prev_prem   giac_direct_prem_collns.premium_amt%TYPE;
   BEGIN
      OPEN prev_colln;

      FETCH prev_colln
       INTO v_prev_prem;

      CLOSE prev_colln;

      RETURN v_prev_prem;
   END;

   FUNCTION get_ctpl_prem (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_ctpl          NUMBER
   )
      RETURN NUMBER
   AS
      CURSOR ctpl_prem
      IS
         SELECT h.prem_amt * i.currency_rt
           FROM gipi_invperil h, gipi_invoice i
          WHERE 1 = 1
            AND h.iss_cd = i.iss_cd
            AND h.prem_seq_no = i.prem_seq_no
            AND h.iss_cd = p_iss_cd
            AND h.prem_seq_no = p_prem_seq_no
            AND h.peril_cd = p_ctpl;

      v_ctpl_prem   gipi_invperil.prem_amt%TYPE;
   BEGIN
      OPEN ctpl_prem;

      FETCH ctpl_prem
       INTO v_ctpl_prem;

      CLOSE ctpl_prem;

      RETURN v_ctpl_prem;
   END;

   FUNCTION get_ctpl_collection (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN collection_type PIPELINED
   IS
      CURSOR colln (
         p_line_mc        VARCHAR2,
         p_ctpl           NUMBER,
         p_dst            NUMBER,
         p_fst            NUMBER,
         p_vat            NUMBER,
         p_lgt            NUMBER,
         p_intercon_fee   VARCHAR2,
         p_ctpl_tax1      NUMBER,
         p_ctpl_tax2      NUMBER,
         p_ctpl_tax3      NUMBER,
         p_ctpl_tax4      NUMBER,
         p_ctpl_tax5      NUMBER
      )
      IS
         SELECT   g.assd_name, get_policy_no (d.policy_id) policy_no,
                  h.line_name, d.policy_id, a.b140_iss_cd iss_cd,
                  a.b140_prem_seq_no prem_seq_no,
                  TRUNC (c.tran_date) tran_date,
                  TRUNC (c.posting_date) posting_date, a.gacc_tran_id,
                  get_ref_no (a.gacc_tran_id) ref_no, a.transaction_type,
                  DECODE (a.transaction_type,
                          2, 'REV',
                          4, 'REV',
                          'COLLN'
                         ) tran_type,
                    SUM ((SELECT tsi_amt
                            FROM gipi_invperil i
                           WHERE i.iss_cd = a.b140_iss_cd
                             AND i.prem_seq_no = a.b140_prem_seq_no
                             AND i.peril_cd = p_ctpl)
                        )
                  * d.currency_rt tsi_amt,
                  SUM ((SELECT prem_amt
                          FROM gipi_invperil i
                         WHERE i.iss_cd = a.b140_iss_cd
                           AND i.prem_seq_no = a.b140_prem_seq_no
                           AND i.peril_cd = p_ctpl)
                      ) ctpl_prem_amt,
                  SUM (a.collection_amt) collection_amt,
                  SUM (a.premium_amt) premium_amt, SUM (dst) dst,
                  SUM (fst) fst, SUM (vat) vat, SUM (lgt) lgt,
                  SUM (intercon_fee) intercon_fee,
                  SUM (other_taxes) other_taxes
             FROM giac_direct_prem_collns a,
                  (SELECT   gacc_tran_id, b160_iss_cd, b160_prem_seq_no,
                            inst_no, transaction_type,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_dst)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) dst,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_fst)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) fst,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_vat)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) vat,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_lgt)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) lgt,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd IN (
                                          SELECT COLUMN_VALUE
                                            FROM TABLE
                                                    (split_comma_separated
                                                               (p_intercon_fee)
                                                    ))
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) intercon_fee,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd NOT IN
                                          (p_dst,
                                           p_fst,
                                           p_vat,
                                           p_lgt,
                                           p_ctpl_tax1,
                                           p_ctpl_tax2,
                                           p_ctpl_tax3,
                                           p_ctpl_tax4,
                                           p_ctpl_tax5
                                          )
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) other_taxes
                       FROM giac_tax_collns
                   GROUP BY gacc_tran_id,
                            b160_iss_cd,
                            b160_prem_seq_no,
                            inst_no,
                            transaction_type) b,
                  giac_acctrans c,
                  gipi_invoice d,
                  gipi_polbasic e,
                  gipi_parlist f,
                  giis_assured g,
                  giis_line h
            WHERE 1 = 1
              AND a.gacc_tran_id = c.tran_id
              AND a.gacc_tran_id = b.gacc_tran_id(+)
              AND a.b140_iss_cd = b.b160_iss_cd(+)
              AND a.b140_prem_seq_no = b.b160_prem_seq_no(+)
              AND a.inst_no = b.inst_no(+)
              AND a.transaction_type = b.transaction_type(+)
              AND a.b140_iss_cd = d.iss_cd
              AND a.b140_prem_seq_no = d.prem_seq_no
              AND d.policy_id = e.policy_id
              AND e.par_id = f.par_id
              AND f.assd_no = g.assd_no
              AND e.line_cd = h.line_cd
              AND NVL (h.menu_line_cd, h.line_cd) = p_line_mc
              AND c.tran_flag != 'D'
              AND NOT EXISTS (
                     SELECT 'X'
                       FROM giac_reversals x, giac_acctrans y
                      WHERE x.reversing_tran_id = y.tran_id
                        AND y.tran_flag != 'D'
                        AND x.gacc_tran_id = a.gacc_tran_id
                        AND DECODE (p_post_tran,
                                    'T', TRUNC (y.tran_date),
                                    TRUNC (y.posting_date)
                                   ) BETWEEN p_from_date AND p_to_date)
              AND EXISTS (
                     SELECT DISTINCT 'x'
                                FROM gipi_invperil z
                               WHERE z.iss_cd = a.b140_iss_cd
                                 AND z.prem_seq_no = a.b140_prem_seq_no
                                 AND z.peril_cd = p_ctpl
                                 AND z.prem_amt != 0)
              AND DECODE (p_post_tran,
                          'T', TRUNC (c.tran_date),
                          TRUNC (c.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
         GROUP BY g.assd_name,
                  d.policy_id,
                  h.line_name,
                  a.b140_iss_cd,
                  a.b140_prem_seq_no,
                  a.gacc_tran_id,
                  c.tran_date,
                  c.posting_date,
                  a.transaction_type,
                  d.currency_rt
--           HAVING SUM (collection_amt) != 0
         ORDER BY policy_no, c.tran_date;

      v_colln              collection_rec_type;
      v_line_mc            VARCHAR2 (2)                      := giisp.v ('MC');
      v_ctpl               NUMBER (2)                      := giisp.n ('CTPL');
      v_dst                NUMBER (2)                := giacp.n ('DOC_STAMPS');
      v_fst                NUMBER (2)                       := giacp.n ('FST');
      v_vat                NUMBER (2)                      := giacp.n ('EVAT');
      v_lgt                NUMBER (2)                       := giacp.n ('LGT');
      v_intercon_fee       VARCHAR2 (100) := giacp.v ('INTERCONNECTIVITY_FEE');
      v_ctpl_tax1          NUMBER (2)                                 := 0;
      v_ctpl_tax2          NUMBER (2)                                 := 0;
      v_ctpl_tax3          NUMBER (2)                                 := 0;
      v_ctpl_tax4          NUMBER (2)                                 := 0;
      v_ctpl_tax5          NUMBER (2)                                 := 0;
      v_ctpl_pct           NUMBER;
      v_or_no              VARCHAR2 (50);
      v_prem_amt           giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_dst_amt            giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_fst_amt            giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_vat_amt            giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_lgt_amt            giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_other_taxes_amt    giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_intercon_fee_amt   giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_old_policy_id      gipi_invoice.policy_id%TYPE;
      v_ctpl_prem_due      gipi_invperil.prem_amt%TYPE                := 0;
      v_ctpl_prev_colln    giac_direct_prem_collns.premium_amt%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax1
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax2
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax3
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 3;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax4
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 4;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax5
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 5;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      FOR rec IN colln (v_line_mc,
                        v_ctpl,
                        v_dst,
                        v_fst,
                        v_vat,
                        v_lgt,
                        v_intercon_fee,
                        v_ctpl_tax1,
                        v_ctpl_tax2,
                        v_ctpl_tax3,
                        v_ctpl_tax4,
                        v_ctpl_tax5
                       )
      LOOP
         v_ctpl_prem_due :=
                          get_ctpl_prem (rec.iss_cd, rec.prem_seq_no, v_ctpl);
         v_ctpl_prev_colln :=
            get_prev_prem_colln (rec.iss_cd,
                                 rec.prem_seq_no,
                                 rec.tran_date,
                                 rec.transaction_type,
                                 rec.gacc_tran_id
                                );
         v_ctpl_pct := get_ctpl_pct (rec.iss_cd, rec.prem_seq_no, v_ctpl);

         IF ABS (v_ctpl_prem_due) <= ABS (v_ctpl_prev_colln)
         THEN
            v_prem_amt := 0;
         ELSIF ABS (v_ctpl_prem_due) > ABS (v_ctpl_prev_colln)
         THEN
            IF ABS (v_ctpl_prem_due) =
                                    ABS (v_ctpl_prev_colln + rec.premium_amt)
            THEN
               v_prem_amt := rec.premium_amt;
            ELSIF ABS (v_ctpl_prem_due) >
                                     ABS (v_ctpl_prev_colln + rec.premium_amt)
            THEN
               v_prem_amt := rec.premium_amt;
            ELSIF ABS (v_ctpl_prem_due) <
                                     ABS (v_ctpl_prev_colln + rec.premium_amt)
            THEN
               v_prem_amt := v_ctpl_prem_due - v_ctpl_prev_colln;
            END IF;
         END IF;

         v_or_no := get_or_no (rec.gacc_tran_id);
         v_colln.assured_name := rec.assd_name;
         v_colln.policy_no := rec.policy_no;
         v_colln.line_name := rec.line_name;
         v_colln.iss_cd := rec.iss_cd;
         v_colln.prem_seq_no := rec.prem_seq_no;

         IF rec.tran_type = 'REV'
         THEN
            v_colln.tsi_amt := NULL;
         ELSE
            v_colln.tsi_amt := rec.tsi_amt;
         END IF;

         v_colln.prem_amt := v_prem_amt;
         v_colln.dst := rec.dst * v_ctpl_pct;
         v_colln.fst := rec.fst * v_ctpl_pct;
         v_colln.vat := rec.vat * v_ctpl_pct;
         v_colln.lgt := rec.lgt * v_ctpl_pct;
         v_colln.other_taxes :=
                             (rec.other_taxes * v_ctpl_pct) + rec.intercon_fee;
         v_colln.collection_amt :=
              v_colln.prem_amt
            + v_colln.dst
            + v_colln.fst
            + v_colln.vat
            + v_colln.lgt
            + v_colln.other_taxes;
         v_colln.transaction_date := rec.tran_date;
         v_colln.posting_date := rec.posting_date;
         v_colln.or_no := v_or_no;
         v_colln.reference_no := rec.ref_no;
         v_old_policy_id := rec.policy_id;
         PIPE ROW (v_colln);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_prem_rec_collection (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN collection_type PIPELINED
   IS
      CURSOR colln (
         p_dst        NUMBER,
         p_fst        NUMBER,
         p_vat        NUMBER,
         p_lgt        NUMBER,
         p_prem_tax   NUMBER,
         p_notarial   NUMBER
      )
      IS
         SELECT   g.assd_name, get_policy_no (d.policy_id) policy_no,
                  h.line_name, d.policy_id, a.b140_iss_cd iss_cd,
                  a.b140_prem_seq_no prem_seq_no,
                  TRUNC (c.tran_date) tran_date,
                  TRUNC (c.posting_date) posting_date, a.gacc_tran_id,
                  get_ref_no (a.gacc_tran_id) ref_no, a.transaction_type,
                  DECODE (a.transaction_type,
                          2, 'REV',
                          4, 'REV',
                          'COLLN'
                         ) tran_type,
                  SUM (e.tsi_amt) tsi_amt,
                  SUM (a.collection_amt) collection_amt,
                  SUM (a.premium_amt) premium_amt, SUM (a.tax_amt) tax_amt,
                  SUM (dst) dst, SUM (fst) fst, SUM (vat) vat, SUM (lgt) lgt,
                  SUM (prem_tax) prem_tax, SUM (notarial) notarial_fee,
                  SUM (other_taxes) other_taxes
             FROM giac_direct_prem_collns a,
                  (SELECT   gacc_tran_id, b160_iss_cd, b160_prem_seq_no,
                            inst_no, transaction_type,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_dst)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) dst,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_fst)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) fst,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_vat)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) vat,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_lgt)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) lgt,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd IN (p_prem_tax)
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) prem_tax,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd IN (p_notarial)
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) notarial,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd NOT IN
                                          (p_dst,
                                           p_fst,
                                           p_vat,
                                           p_lgt,
                                           p_prem_tax,
                                           p_notarial
                                          )
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) other_taxes
                       FROM giac_tax_collns
                   GROUP BY gacc_tran_id,
                            b160_iss_cd,
                            b160_prem_seq_no,
                            inst_no,
                            transaction_type) b,
                  giac_acctrans c,
                  gipi_invoice d,
                  gipi_polbasic e,
                  gipi_parlist f,
                  giis_assured g,
                  giis_line h
            WHERE 1 = 1
              AND a.gacc_tran_id = c.tran_id
              AND a.gacc_tran_id = b.gacc_tran_id(+)
              AND a.b140_iss_cd = b.b160_iss_cd(+)
              AND a.b140_prem_seq_no = b.b160_prem_seq_no(+)
              AND a.inst_no = b.inst_no(+)
              AND a.transaction_type = b.transaction_type(+)
              AND a.b140_iss_cd = d.iss_cd
              AND a.b140_prem_seq_no = d.prem_seq_no
              AND d.policy_id = e.policy_id
              AND e.par_id = f.par_id
              AND f.assd_no = g.assd_no
              AND e.line_cd = h.line_cd
              --and e.line_cd = 'FI'
              AND c.tran_flag != 'D'
              AND DECODE (p_post_tran,
                          'T', TRUNC (c.tran_date),
                          TRUNC (c.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
         GROUP BY g.assd_name,
                  d.policy_id,
                  h.line_name,
                  a.b140_iss_cd,
                  a.b140_prem_seq_no,
                  a.gacc_tran_id,
                  c.tran_date,
                  c.posting_date,
                  a.transaction_type,
                  d.currency_rt
         UNION
         SELECT   g.assd_name, get_policy_no (d.policy_id) policy_no,
                  h.line_name, d.policy_id, a.b140_iss_cd iss_cd,
                  a.b140_prem_seq_no prem_seq_no,
                  TRUNC (c.tran_date) tran_date,
                  TRUNC (c.posting_date) posting_date, a.gacc_tran_id,
                  (SELECT get_ref_no (j.reversing_tran_id)
                     FROM giac_reversals j
                    WHERE j.gacc_tran_id = a.gacc_tran_id) ref_no,
                  a.transaction_type,
                  DECODE (a.transaction_type,
                          2, 'REV',
                          4, 'REV',
                          'COLLN'
                         ) tran_type,
                  SUM (e.tsi_amt) * -1 tsi_amt,
                  SUM (a.collection_amt) * -1 collection_amt,
                  SUM (a.premium_amt) * -1 premium_amt,
                  SUM (a.tax_amt) tax_amt, SUM (dst) * -1 dst,
                  SUM (fst) * -1 fst, SUM (vat) * -1 vat, SUM (lgt) * -1 lgt,
                  SUM (prem_tax) * -1 prem_tax,
                  SUM (notarial) * -1 notarial_fee,
                  SUM (other_taxes) * -1 other_taxes
             FROM giac_direct_prem_collns a,
                  (SELECT   gacc_tran_id, b160_iss_cd, b160_prem_seq_no,
                            inst_no, transaction_type,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_dst)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) dst,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_fst)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) fst,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_vat)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) vat,
                            SUM (CASE
                                    WHEN b160_tax_cd IN (p_lgt)
                                       THEN tax_amt
                                    ELSE 0
                                 END
                                ) lgt,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd IN (p_prem_tax)
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) prem_tax,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd IN (p_notarial)
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) notarial,
                            SUM
                               (CASE
                                   WHEN b160_tax_cd NOT IN
                                          (p_dst,
                                           p_fst,
                                           p_vat,
                                           p_lgt,
                                           p_prem_tax,
                                           p_notarial
                                          )
                                      THEN tax_amt
                                   ELSE 0
                                END
                               ) other_taxes
                       FROM giac_tax_collns
                   GROUP BY gacc_tran_id,
                            b160_iss_cd,
                            b160_prem_seq_no,
                            inst_no,
                            transaction_type) b,
                  giac_acctrans c,
                  gipi_invoice d,
                  gipi_polbasic e,
                  gipi_parlist f,
                  giis_assured g,
                  giis_line h,
                  giac_reversals i
            WHERE 1 = 1
              AND a.gacc_tran_id = i.gacc_tran_id
              AND i.reversing_tran_id = c.tran_id
              AND a.gacc_tran_id = b.gacc_tran_id(+)
              AND a.b140_iss_cd = b.b160_iss_cd(+)
              AND a.b140_prem_seq_no = b.b160_prem_seq_no(+)
              AND a.inst_no = b.inst_no(+)
              AND a.transaction_type = b.transaction_type(+)
              AND a.b140_iss_cd = d.iss_cd
              AND a.b140_prem_seq_no = d.prem_seq_no
              AND d.policy_id = e.policy_id
              AND e.par_id = f.par_id
              AND f.assd_no = g.assd_no
              AND e.line_cd = h.line_cd
              --and e.line_cd = 'FI'
              AND c.tran_flag != 'D'
              AND DECODE (p_post_tran,
                          'T', TRUNC (c.tran_date),
                          TRUNC (c.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
         GROUP BY g.assd_name,
                  d.policy_id,
                  h.line_name,
                  a.b140_iss_cd,
                  a.b140_prem_seq_no,
                  a.gacc_tran_id,
                  c.tran_date,
                  c.posting_date,
                  a.transaction_type,
                  d.currency_rt
         ORDER BY 2, 6;

      v_colln             collection_rec_type;
      v_dst               NUMBER (2)                 := giacp.n ('DOC_STAMPS');
      v_fst               NUMBER (2)                        := giacp.n ('FST');
      v_vat               NUMBER (2)                       := giacp.n ('EVAT');
      v_lgt               NUMBER (2)                        := giacp.n ('LGT');
      v_notarial          NUMBER (2)               := giacp.n ('NOTARIAL_FEE');
      v_prem_tax          NUMBER (2)                  := giacp.n ('5PREM_TAX');
      v_or_no             VARCHAR2 (50);
      v_prem_amt          giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_dst_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_fst_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_vat_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_lgt_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_other_taxes_amt   giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_multiplier        NUMBER                                     := 1;
   BEGIN
      FOR rec IN colln (v_dst, v_fst, v_vat, v_lgt, v_prem_tax, v_notarial)
      LOOP
         v_or_no := get_or_no (rec.gacc_tran_id);
         v_colln.assured_name := rec.assd_name;
         v_colln.policy_no := rec.policy_no;
         v_colln.line_name := rec.line_name;
         v_colln.iss_cd := rec.iss_cd;
         v_colln.prem_seq_no := rec.prem_seq_no;

         IF rec.tran_type = 'REV'
         THEN
            v_colln.tsi_amt := NULL;
         ELSE
            v_colln.tsi_amt := rec.tsi_amt;
         END IF;

         v_colln.prem_amt := rec.premium_amt;
         v_multiplier := 1;

         IF rec.tax_amt = 0
         THEN
            v_multiplier := 0;
         END IF;

         v_colln.dst := NVL (rec.dst, 0) * v_multiplier;
         v_colln.fst := NVL (rec.fst, 0) * v_multiplier;
         v_colln.vat := NVL (rec.vat, 0) * v_multiplier;
         v_colln.lgt := NVL (rec.lgt, 0) * v_multiplier;
         v_colln.prem_tax := NVL (rec.prem_tax, 0) * v_multiplier;
         v_colln.notarial_fee := NVL (rec.notarial_fee, 0) * v_multiplier;
         v_colln.other_taxes := NVL (rec.other_taxes, 0) * v_multiplier;
         v_colln.collection_amt := rec.collection_amt;
         v_colln.transaction_date := rec.tran_date;
         v_colln.posting_date := rec.posting_date;
         v_colln.or_no := v_or_no;
         v_colln.reference_no := rec.ref_no;
         PIPE ROW (v_colln);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_comm_payments (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN collection_type PIPELINED
   IS
      CURSOR payt
      IS
         SELECT   g.assd_name, get_policy_no (d.policy_id) policy_no,
                  h.line_name, d.policy_id, a.iss_cd, a.prem_seq_no,
                  TRUNC (c.tran_date) tran_date,
                  TRUNC (c.posting_date) posting_date, a.gacc_tran_id,
                  get_ref_no (a.gacc_tran_id) ref_no,
                  a.tran_type transaction_type,
                  DECODE (a.tran_type, 2, 'REV', 4, 'REV', 'PAYT') tran_type,
                  SUM (comm_amt) comm_amt, SUM (wtax_amt) wtax_amt,
                  SUM (input_vat_amt) input_vat,
                  SUM (comm_amt + input_vat_amt - wtax_amt) net_comm
             FROM giac_comm_payts a,
                  giac_acctrans c,
                  gipi_invoice d,
                  gipi_polbasic e,
                  gipi_parlist f,
                  giis_assured g,
                  giis_line h
            WHERE 1 = 1
              AND a.gacc_tran_id = c.tran_id
              AND a.iss_cd = d.iss_cd
              AND a.prem_seq_no = d.prem_seq_no
              AND d.policy_id = e.policy_id
              AND e.par_id = f.par_id
              AND f.assd_no = g.assd_no
              AND e.line_cd = h.line_cd
              --and e.line_cd = 'FI'
              AND c.tran_flag != 'D'
              AND DECODE (p_post_tran,
                          'T', TRUNC (c.tran_date),
                          TRUNC (c.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
         GROUP BY g.assd_name,
                  d.policy_id,
                  h.line_name,
                  a.iss_cd,
                  a.prem_seq_no,
                  a.gacc_tran_id,
                  c.tran_date,
                  c.posting_date,
                  a.tran_type,
                  d.currency_rt
         UNION
         SELECT   g.assd_name, get_policy_no (d.policy_id) policy_no,
                  h.line_name, d.policy_id, a.iss_cd, a.prem_seq_no,
                  TRUNC (c.tran_date) tran_date,
                  TRUNC (c.posting_date) posting_date, a.gacc_tran_id,
                  get_ref_no (a.gacc_tran_id) ref_no,
                  a.tran_type transaction_type,
                  DECODE (a.tran_type, 2, 'REV', 4, 'REV', 'PAYT') tran_type,
                  SUM (comm_amt) * -1 comm_amt, SUM (wtax_amt) * -1 wtax_amt,
                  SUM (input_vat_amt) * -1 input_vat,
                  SUM (comm_amt + input_vat_amt - wtax_amt) * -1 net_comm
             FROM giac_comm_payts a,
                  giac_acctrans c,
                  gipi_invoice d,
                  gipi_polbasic e,
                  gipi_parlist f,
                  giis_assured g,
                  giis_line h,
                  giac_reversals b
            WHERE 1 = 1
              AND a.gacc_tran_id = b.gacc_tran_id
              AND b.reversing_tran_id = c.tran_id
              AND a.iss_cd = d.iss_cd
              AND a.prem_seq_no = d.prem_seq_no
              AND d.policy_id = e.policy_id
              AND e.par_id = f.par_id
              AND f.assd_no = g.assd_no
              AND e.line_cd = h.line_cd
              --and e.line_cd = 'FI'
              AND c.tran_flag != 'D'
              AND DECODE (p_post_tran,
                          'T', TRUNC (c.tran_date),
                          TRUNC (c.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
         GROUP BY g.assd_name,
                  d.policy_id,
                  h.line_name,
                  a.iss_cd,
                  a.prem_seq_no,
                  a.gacc_tran_id,
                  c.tran_date,
                  c.posting_date,
                  a.tran_type,
                  d.currency_rt
         ORDER BY 2, 6;

      v_payt              collection_rec_type;
      v_or_no             VARCHAR2 (50);
      v_prem_amt          giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_dst_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_fst_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_vat_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_lgt_amt           giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_other_taxes_amt   giac_direct_prem_collns.tax_amt%TYPE       := 0;
      v_multiplier        NUMBER                                     := 1;
   BEGIN
      FOR rec IN payt
      LOOP
         v_payt.assured_name := rec.assd_name;
         v_payt.policy_no := rec.policy_no;
         v_payt.line_name := rec.line_name;
         v_payt.iss_cd := rec.iss_cd;
         v_payt.prem_seq_no := rec.prem_seq_no;
         v_payt.commission_amt := rec.comm_amt;
         v_payt.wtax_amt := rec.wtax_amt;
         v_payt.input_vat_amt := rec.input_vat;
         v_payt.net_comm_amt := rec.net_comm;
         v_payt.transaction_date := rec.tran_date;
         v_payt.posting_date := rec.posting_date;
         v_payt.reference_no := rec.ref_no;
         PIPE ROW (v_payt);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_losses_paid (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN losses_paid_type PIPELINED
   IS
      v_clm_payt   losses_paid_rec_type;
   BEGIN
      FOR clm_payt IN
         (SELECT b.assd_name claimant, get_claim_number (a.claim_id)
                                                                    claim_no,
                 TO_CHAR (a.clm_file_date, 'MM/DD/RRRR') clm_file_date,
                    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LPAD (a.issue_yy, 2, 0)
                 || '-'
                 || LPAD (a.pol_seq_no, 7, 0)
                 || '-'
                 || LPAD (a.renew_no, 2, 0) policy_no,
                 TO_CHAR (a.dsp_loss_date, 'MM/DD/RRRR HHMISS AM') loss_date,
                 c.reserve_amt, d.paid_amt,
                 DECODE (SIGN (d.paid_amt),
                         -1, 0,
                         NVL (c.reserve_amt, 0) - d.paid_amt
                        ) difference,
                 d.date_paid, d.check_no, d.tran_class
            FROM gicl_claims a,
                 giis_assured b,
                 (SELECT   a2.claim_id, a2.peril_cd,
                           SUM (  (  NVL (a2.loss_reserve, 0)
                                   + NVL (a2.expense_reserve, 0)
                                  )
                                * NVL (a2.convert_rate, 1)
                               ) reserve_amt
                      FROM gicl_clm_res_hist a2
                     WHERE NVL (a2.dist_sw, 'N') = 'Y'
                  GROUP BY a2.claim_id, a2.item_no, a2.peril_cd) c,
                 (SELECT   a1.claim_id, a1.peril_cd,
                           SUM (  (  NVL (a1.losses_paid, 0)
                                   + NVL (a1.expenses_paid, 0)
                                  )
                                * NVL (a1.convert_rate, 1)
                               ) paid_amt,
                           wm_concat (TO_CHAR (a1.date_paid, 'MM/DD/RRRR')
                                     ) date_paid,
                           wm_concat (DECODE (b1.tran_class,
                                              'DV', c1.check_pref_suf
                                               || '-'
                                               || LPAD (c1.check_no, 10, 0),
                                              get_ref_no (a1.tran_id)
                                             )
                                     ) check_no,
                           b1.tran_class
                      FROM gicl_clm_res_hist a1,
                           giac_acctrans b1,
                           giac_chk_disbursement c1
                     WHERE a1.tran_id = b1.tran_id
                       AND b1.tran_flag != 'D'
                       AND DECODE (p_post_tran,
                                   'T', a1.date_paid,
                                   'P', b1.posting_date
                                  ) BETWEEN p_from_date AND p_to_date
                       AND a1.tran_id = c1.gacc_tran_id(+)
                  GROUP BY a1.claim_id,
                           a1.item_no,
                           a1.peril_cd,
                           a1.tran_id,
                           b1.tran_class
                  UNION
                  SELECT   a1.claim_id, a1.peril_cd,
                           SUM (  (  NVL (a1.losses_paid, 0)
                                   + NVL (a1.expenses_paid, 0)
                                  )
                                * NVL (a1.convert_rate, 1)
                                * -1
                               ) paid_amt,
                           wm_concat (TO_CHAR (a1.date_paid, 'MM/DD/RRRR')
                                     ) date_paid,
                           wm_concat (DECODE (b1.tran_class,
                                              'DV', c1.check_pref_suf
                                               || '-'
                                               || LPAD (c1.check_no, 10, 0),
                                              get_ref_no (a1.tran_id)
                                             )
                                     ) check_no,
                           b1.tran_class
                      FROM gicl_clm_res_hist a1,
                           giac_acctrans b1,
                           giac_chk_disbursement c1,
                           giac_reversals d1
                     WHERE a1.tran_id = d1.gacc_tran_id
                       AND b1.tran_id = d1.gacc_tran_id
                       AND b1.tran_flag != 'D'
                       AND DECODE (p_post_tran,
                                   'T', b1.tran_date,
                                   'P', b1.posting_date
                                  ) BETWEEN p_from_date AND p_to_date
                       AND a1.tran_id = c1.gacc_tran_id(+)
                  GROUP BY a1.claim_id,
                           a1.item_no,
                           a1.peril_cd,
                           a1.tran_id,
                           b1.tran_class) d
           WHERE a.assd_no = b.assd_no
             AND a.line_cd = 'MC'
             AND a.claim_id = d.claim_id
             AND c.claim_id(+) = d.claim_id
             AND c.peril_cd(+) = d.peril_cd
             AND d.peril_cd = giisp.n ('CTPL'))
      LOOP
         v_clm_payt.claimant := clm_payt.claimant;
         v_clm_payt.claim_no := clm_payt.claim_no;
         v_clm_payt.clm_file_date := clm_payt.clm_file_date;
         v_clm_payt.policy_no := clm_payt.policy_no;
         v_clm_payt.loss_date := clm_payt.loss_date;
         v_clm_payt.reserve_amt := clm_payt.reserve_amt;
         v_clm_payt.paid_amt := clm_payt.paid_amt;
         v_clm_payt.difference := clm_payt.difference;
         v_clm_payt.date_paid := clm_payt.date_paid;
         v_clm_payt.check_no := clm_payt.check_no;
         v_clm_payt.tran_class := clm_payt.tran_class;
         PIPE ROW (v_clm_payt);
      END LOOP;

      RETURN;
   END get_losses_paid;

--end of MAC 04/10/2014.
   FUNCTION get_ctpl_production (p_from_date DATE, p_to_date DATE)
      RETURN prod_type PIPELINED
   IS
      v_rec            prod_rec_type;
      v_line_mc        VARCHAR2 (2)   := giisp.v ('MC');
      v_ctpl           NUMBER (2)     := giisp.n ('CTPL');
      v_dst            NUMBER (2)     := giacp.n ('DOC_STAMPS');
      v_fst            NUMBER (2)     := giacp.n ('FST');
      v_vat            NUMBER (2)     := giacp.n ('EVAT');
      v_lgt            NUMBER (2)     := giacp.n ('LGT');
      v_intercon_fee   VARCHAR2 (100) := giacp.v ('INTERCONNECTIVITY_FEE');
      v_ctpl_tax1      NUMBER (2)     := 0;
      v_ctpl_tax2      NUMBER (2)     := 0;
      v_ctpl_tax3      NUMBER (2)     := 0;
      v_ctpl_tax4      NUMBER (2)     := 0;
      v_ctpl_tax5      NUMBER (2)     := 0;
      v_ctpl_pct       NUMBER;
   BEGIN
      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax1
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax2
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax3
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 3;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax4
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 4;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT COLUMN_VALUE
           INTO v_ctpl_tax5
           FROM (SELECT COLUMN_VALUE, ROWNUM rnum
                   FROM TABLE (split_comma_separated (v_intercon_fee)))
          WHERE rnum = 5;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      FOR i IN
         (SELECT   get_assd_name (a.assd_no) assured_name,
                   get_policy_no (a.policy_id) policy_no,
                   get_line_name (a.line_cd) line_name, b.currency_rt,
                   c.tsi_amt tsi_amt, c.prem_amt prem_amt,
                   (SELECT tax_amt
                      FROM gipi_inv_tax
                     WHERE iss_cd = b.iss_cd
                       AND prem_seq_no = b.prem_seq_no
                       AND tax_cd = v_dst) dst,
                   (SELECT tax_amt
                      FROM gipi_inv_tax
                     WHERE iss_cd = b.iss_cd
                       AND prem_seq_no = b.prem_seq_no
                       AND tax_cd = v_fst) fst,
                   (SELECT tax_amt
                      FROM gipi_inv_tax
                     WHERE iss_cd = b.iss_cd
                       AND prem_seq_no = b.prem_seq_no
                       AND tax_cd = v_vat) vat,
                   (SELECT tax_amt
                      FROM gipi_inv_tax
                     WHERE iss_cd = b.iss_cd
                       AND prem_seq_no = b.prem_seq_no
                       AND tax_cd = v_lgt) lgt,
                   (SELECT SUM (tax_amt)
                      FROM gipi_inv_tax
                     WHERE iss_cd = b.iss_cd
                       AND prem_seq_no = b.prem_seq_no
                       AND tax_cd NOT IN
                              (v_dst,
                               v_fst,
                               v_vat,
                               v_lgt,
                               v_ctpl_tax1,
                               v_ctpl_tax2,
                               v_ctpl_tax3,
                               v_ctpl_tax4,
                               v_ctpl_tax5
                              )) other_tax,
                   (SELECT SUM (tax_amt)
                      FROM gipi_inv_tax
                     WHERE iss_cd = b.iss_cd
                       AND prem_seq_no = b.prem_seq_no
                       AND tax_cd IN (
                              SELECT COLUMN_VALUE
                                FROM TABLE
                                        (split_comma_separated (v_intercon_fee)
                                        ))) intercon_fee,
                   b.iss_cd, b.prem_seq_no, a.policy_id
              FROM gipi_polbasic a, gipi_invoice b, gipi_invperil c
             WHERE a.policy_id = b.policy_id
               AND b.iss_cd = c.iss_cd
               AND b.prem_seq_no = c.prem_seq_no
               AND a.line_cd = v_line_mc
               AND c.peril_cd = v_ctpl
               AND TRUNC (b.acct_ent_date) BETWEEN p_from_date AND p_to_date
          GROUP BY a.assd_no,
                   a.policy_id,
                   a.line_cd,
                   c.tsi_amt,
                   c.prem_amt,
                   b.iss_cd,
                   b.prem_seq_no,
                   b.currency_rt
          UNION
          SELECT   get_assd_name (a.assd_no) assured_name,
                   get_policy_no (a.policy_id) policy_no,
                   get_line_name (a.line_cd) line_name, b.currency_rt,
                   c.tsi_amt * -1 tsi_amt, c.prem_amt * -1 prem_amt,
                     (SELECT tax_amt
                        FROM gipi_inv_tax
                       WHERE iss_cd = b.iss_cd
                         AND prem_seq_no = b.prem_seq_no
                         AND tax_cd = v_dst)
                   * -1 dst,
                     (SELECT tax_amt
                        FROM gipi_inv_tax
                       WHERE iss_cd = b.iss_cd
                         AND prem_seq_no = b.prem_seq_no
                         AND tax_cd = v_fst)
                   * -1 fst,
                     (SELECT tax_amt
                        FROM gipi_inv_tax
                       WHERE iss_cd = b.iss_cd
                         AND prem_seq_no = b.prem_seq_no
                         AND tax_cd = v_vat)
                   * -1 vat,
                     (SELECT tax_amt
                        FROM gipi_inv_tax
                       WHERE iss_cd = b.iss_cd
                         AND prem_seq_no = b.prem_seq_no
                         AND tax_cd = v_lgt)
                   * -1 lgt,
                     (SELECT SUM (tax_amt)
                        FROM gipi_inv_tax
                       WHERE iss_cd = b.iss_cd
                         AND prem_seq_no = b.prem_seq_no
                         AND tax_cd NOT IN
                                (v_dst,
                                 v_fst,
                                 v_vat,
                                 v_lgt,
                                 v_ctpl_tax1,
                                 v_ctpl_tax2,
                                 v_ctpl_tax3,
                                 v_ctpl_tax4,
                                 v_ctpl_tax5
                                ))
                   * -1 other_tax,
                     (SELECT SUM (tax_amt)
                        FROM gipi_inv_tax
                       WHERE iss_cd = b.iss_cd
                         AND prem_seq_no = b.prem_seq_no
                         AND tax_cd IN (
                                SELECT COLUMN_VALUE
                                  FROM TABLE
                                          (split_comma_separated
                                                               (v_intercon_fee)
                                          )))
                   * -1 intercon_fee,
                   b.iss_cd, b.prem_seq_no, a.policy_id
              FROM gipi_polbasic a, gipi_invoice b, gipi_invperil c
             WHERE a.policy_id = b.policy_id
               AND b.iss_cd = c.iss_cd
               AND b.prem_seq_no = c.prem_seq_no
               AND a.line_cd = v_line_mc
               AND c.peril_cd = v_ctpl
               AND b.acct_ent_date IS NOT NULL
               AND TRUNC (b.spoiled_acct_ent_date) BETWEEN p_from_date
                                                       AND p_to_date
          GROUP BY a.assd_no,
                   a.policy_id,
                   a.line_cd,
                   c.tsi_amt,
                   c.prem_amt,
                   b.iss_cd,
                   b.prem_seq_no,
                   b.currency_rt
          ORDER BY 1, 2)
      LOOP
         v_ctpl_pct := get_ctpl_pct (i.iss_cd, i.prem_seq_no, v_ctpl);
         v_rec.assured_name := i.assured_name;
         v_rec.policy_no := i.policy_no;
         v_rec.line_name := i.line_name;
         v_rec.tsi_amt := NVL (i.tsi_amt, 0);
         v_rec.prem_amt := NVL (i.prem_amt, 0) * i.currency_rt;
         v_rec.dst := ROUND (NVL (i.dst, 0) * i.currency_rt * v_ctpl_pct, 2);
         v_rec.fst := ROUND (NVL (i.fst, 0) * i.currency_rt * v_ctpl_pct, 2);
         v_rec.vat := ROUND (NVL (i.vat, 0) * i.currency_rt * v_ctpl_pct, 2);
         v_rec.lgt := ROUND (NVL (i.lgt, 0) * i.currency_rt * v_ctpl_pct, 2);
         v_rec.other_taxes :=
              ROUND ((NVL (i.other_tax, 0) * i.currency_rt * v_ctpl_pct), 2)
            + (NVL (i.intercon_fee, 0) * i.currency_rt);
         v_rec.total_amt_due :=
              v_rec.prem_amt
            + v_rec.dst
            + v_rec.fst
            + v_rec.vat
            + v_rec.lgt
            + v_rec.other_taxes;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_ctpl_production;
--End Deo [04.11.2014]
END;
/


