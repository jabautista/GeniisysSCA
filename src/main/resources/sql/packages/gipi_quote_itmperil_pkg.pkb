/* Formatted on 2016/04/07 09:13 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY cpi.gipi_quote_itmperil_pkg
AS
                               /***  PERIL THE PLATYPUS  ***/
/*
                                 /////////////////////////
                                ///                      ///
                               ///   ///                   ///
                       /////////                           /////////
                     ///                                    ///     //////
                      //////////////////////////////////////////          //////
                                ////                ////        ////////////////
                               ////                ////

*/
   FUNCTION get_gipi_quote_itmperil (
      p_quote_id   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    gipi_quote_itmperil.item_no%TYPE
   )
      RETURN gipi_quote_itmperil_tab PIPELINED
   IS
      v_itmperil   gipi_quote_itmperil_type;
   BEGIN
      FOR i IN (SELECT a.quote_id, a.item_no, a.peril_cd, b.peril_name,
                       a.prem_rt, a.tsi_amt, a.prem_amt, a.comp_rem
                  FROM gipi_quote_itmperil a, giis_peril b
                 WHERE a.peril_cd = b.peril_cd
                   AND a.line_cd = b.line_cd
                   AND a.quote_id = p_quote_id
                   AND a.item_no = p_item_no)
      LOOP
         v_itmperil.quote_id := i.quote_id;
         v_itmperil.item_no := i.item_no;
         v_itmperil.peril_cd := i.peril_cd;
         v_itmperil.peril_name := i.peril_name;
         v_itmperil.prem_rt := i.prem_rt;
         v_itmperil.tsi_amt := i.tsi_amt;
         v_itmperil.prem_amt := i.prem_amt;
         v_itmperil.comp_rem := i.comp_rem;
         PIPE ROW (v_itmperil);
      END LOOP;

      RETURN;
   END get_gipi_quote_itmperil;

   PROCEDURE set_gipi_quote_itmperil (
      p_quote_id   IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    IN   gipi_quote_itmperil.item_no%TYPE,
      p_peril_cd   IN   gipi_quote_itmperil.peril_cd%TYPE,
      p_prem_rt    IN   gipi_quote_itmperil.prem_rt%TYPE,
      p_tsi_amt    IN   gipi_quote_itmperil.tsi_amt%TYPE,
      p_prem_amt   IN   gipi_quote_itmperil.prem_amt%TYPE,
      p_comp_rem   IN   gipi_quote_itmperil.comp_rem%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_quote_itmperil
         USING DUAL
         ON (    quote_id = p_quote_id
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (quote_id, item_no, peril_cd, prem_rt, tsi_amt, prem_amt,
                    comp_rem)
            VALUES (p_quote_id, p_item_no, p_peril_cd, p_prem_rt, p_tsi_amt,
                    p_prem_amt, p_comp_rem)
         WHEN MATCHED THEN
            UPDATE
               SET prem_rt = p_prem_rt, tsi_amt = p_tsi_amt,
                   prem_amt = p_prem_amt, comp_rem = p_comp_rem
            ;
      COMMIT;
   END set_gipi_quote_itmperil;

   PROCEDURE del_gipi_quote_itmperil (
      p_quote_id   IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    IN   gipi_quote_itmperil.item_no%TYPE,
      p_peril_cd   IN   gipi_quote_itmperil.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_quote_itmperil
            WHERE quote_id = p_quote_id
              AND item_no = p_item_no
              AND peril_cd = p_peril_cd;

      COMMIT;
   END del_gipi_quote_itmperil;

   FUNCTION get_item_peril_listing (
      p_quote_id       IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no        IN   gipi_quote_itmperil.item_no%TYPE,
      p_line_cd        IN   gipi_quote_itmperil.line_cd%TYPE,
      p_pack_line_cd   IN   gipi_quote_item.pack_line_cd%TYPE,
      p_peril_name     IN   giis_peril.peril_name%TYPE,
      p_rate           IN   gipi_quote_itmperil.prem_rt%TYPE,
      p_tsi_amt        IN   gipi_quote_itmperil.tsi_amt%TYPE,
      p_prem_amt       IN   gipi_quote_itmperil.prem_amt%TYPE,
      p_remarks        IN   gipi_quote_itmperil.comp_rem%TYPE
   )
      RETURN item_peril_tab PIPELINED
   IS
      v_item            item_peril_type;
      v_pack_pol_flag   giis_line.pack_pol_flag%TYPE;
   BEGIN
      SELECT a.pack_pol_flag
        INTO v_pack_pol_flag
        FROM giis_line a, gipi_quote b
       WHERE b.quote_id = p_quote_id AND a.line_cd = b.line_cd;

      FOR i IN
         (SELECT a.*
            FROM gipi_quote_itmperil a, giis_peril b
           WHERE a.quote_id = p_quote_id
             AND a.item_no = p_item_no
             AND a.peril_cd = b.peril_cd
             AND b.line_cd = p_line_cd
             AND NVL (a.line_cd, b.line_cd) = b.line_cd
             AND UPPER (b.peril_name) LIKE
                                      UPPER (NVL (p_peril_name, b.peril_name))
             AND a.prem_rt = NVL (p_rate, a.prem_rt)
             AND a.tsi_amt = NVL (p_tsi_amt, a.tsi_amt)
             AND a.prem_amt = NVL (p_prem_amt, a.prem_amt)
             AND UPPER (NVL (a.comp_rem, '*')) LIKE
                                UPPER (NVL (p_remarks, NVL (a.comp_rem, '*'))))
      LOOP
         v_item.quote_id := i.quote_id;
         v_item.item_no := i.item_no;
         v_item.peril_cd := i.peril_cd;
         v_item.prem_rt := i.prem_rt;
         v_item.tsi_amt := i.tsi_amt;
         v_item.prem_amt := i.prem_amt;
         v_item.comp_rem := i.comp_rem;
         v_item.prt_flag := i.prt_flag;
         v_item.line_cd := i.line_cd;

         BEGIN
            SELECT peril_name, peril_type,
                   basc_perl_cd, peril_sname
              INTO v_item.peril_name, v_item.peril_type,
                   v_item.basic_peril_cd, v_item.peril_sname
              FROM giis_peril
             WHERE peril_cd = i.peril_cd
               AND line_cd =
                      DECODE (NVL (v_pack_pol_flag, 'N'),
                              'Y', p_pack_line_cd,
                              p_line_cd
                             );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item.peril_name := NULL;
         END;

         BEGIN
            SELECT 'Y'
              INTO v_item.ded_flag
              FROM gipi_quote_itmperil a, gipi_quote_deductibles b
             WHERE a.quote_id = b.quote_id
               AND a.item_no = b.item_no
               AND a.peril_cd = b.peril_cd
               AND a.quote_id = i.quote_id
               AND a.item_no = i.item_no
               AND a.peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item.ded_flag := 'N';
            WHEN TOO_MANY_ROWS
            THEN
               v_item.ded_flag := 'Y';
         END;

         PIPE ROW (v_item);
      END LOOP;
   END;

   PROCEDURE set_giimm002_peril_info (
      p_quote_id         IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no          IN   gipi_quote_itmperil.item_no%TYPE,
      p_peril_cd         IN   gipi_quote_itmperil.peril_cd%TYPE,
      p_prem_rt          IN   gipi_quote_itmperil.prem_rt%TYPE,
      p_tsi_amt          IN   gipi_quote_itmperil.tsi_amt%TYPE,
      p_prem_amt         IN   gipi_quote_itmperil.prem_amt%TYPE,
      p_comp_rem         IN   gipi_quote_itmperil.comp_rem%TYPE,
      p_peril_type       IN   gipi_quote_itmperil.peril_type%TYPE,
      p_basic_peril_cd   IN   gipi_quote_itmperil.basic_peril_cd%TYPE,
      p_prt_flag         IN   gipi_quote_itmperil.prt_flag%TYPE,
      p_line_cd          IN   gipi_quote_itmperil.line_cd%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_quote_itmperil
         USING DUAL
         ON (    quote_id = p_quote_id
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (quote_id, item_no, peril_cd, prem_rt, tsi_amt, prem_amt,
                    comp_rem, peril_type, basic_peril_cd, prt_flag, line_cd)
            VALUES (p_quote_id, p_item_no, p_peril_cd, p_prem_rt, p_tsi_amt,
                    p_prem_amt, p_comp_rem, p_peril_type, p_basic_peril_cd,
                    p_prt_flag, p_line_cd)
         WHEN MATCHED THEN
            UPDATE
               SET prem_rt = p_prem_rt, tsi_amt = p_tsi_amt,
                   prem_amt = p_prem_amt, comp_rem = p_comp_rem
            ;
      -- update GIPI_QUOTE_ITMPERIL -  prorated tsi_amt and prem_amt
      update_gipi_quote_itmperil (p_quote_id, p_item_no, p_peril_cd);
      -- update GIPI_QUOTE, GIPI_QUOTE_ITEM - tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
      gipi_quote_itmperil_pkg.update_quote_and_item (p_quote_id, p_item_no);
      -- update GIPI_QUOTE_INVOICE, GIPI_QUOTE_INVTAX
      set_giimm002_invoice (p_quote_id, p_item_no);
      -- added nieko 04062016 UW-SPECS-2015-086 Quotation Deductibles, update tsi based deductibles
      gipi_quote_itmperil_pkg.update_quote_deductibles (p_quote_id,
                                                        p_item_no,
                                                        p_peril_cd
                                                       );
   END;

   PROCEDURE del_giimm002_peril_info (
      p_quote_id   IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    IN   gipi_quote_itmperil.item_no%TYPE,
      p_peril_cd   IN   gipi_quote_itmperil.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_quote_itmperil
            WHERE quote_id = p_quote_id
              AND item_no = p_item_no
              AND peril_cd = p_peril_cd;

      DELETE FROM gipi_quote_peril_discount
            WHERE quote_id = p_quote_id
              AND item_no = p_item_no
              AND peril_cd = p_peril_cd;

      -- deletes deductible of deleted peril
      gipi_quote_deduct_pkg.del_gipi_quote_deduct2 (p_quote_id,
                                                    p_peril_cd,
                                                    p_item_no
                                                   );
      -- update GIPI_QUOTE_ITMPERIL -  prorated tsi_amt and prem_amt
      update_gipi_quote_itmperil (p_quote_id, p_item_no, p_peril_cd);
      -- update GIPI_QUOTE, GIPI_QUOTE_ITEM - tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
      gipi_quote_itmperil_pkg.update_quote_and_item (p_quote_id, p_item_no);
      -- update GIPI_QUOTE_INVOICE, GIPI_QUOTE_INVTAX
      set_giimm002_invoice (p_quote_id, p_item_no);
      
      -- added nieko 04062016 UW-SPECS-2015-086 Quotation Deductibles, update tsi based deductibles
      gipi_quote_itmperil_pkg.delete_quote_deductibles (p_quote_id,
                                                        p_item_no,
                                                        p_peril_cd
                                                       );
   END;

   PROCEDURE update_quote_and_item (
      p_quote_id   IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    IN   gipi_quote_itmperil.item_no%TYPE
   )
   IS
      v_tsi_amt        gipi_quote_itmperil.tsi_amt%TYPE;
      v_prem_amt       gipi_quote_itmperil.prem_amt%TYPE;
      v_ann_tsi_amt    gipi_quote_itmperil.ann_tsi_amt%TYPE;
      v_ann_prem_amt   gipi_quote_itmperil.ann_prem_amt%TYPE;
   BEGIN
      BEGIN
         SELECT SUM (tsi_amt), SUM (ann_tsi_amt)
           INTO v_tsi_amt, v_ann_tsi_amt
           FROM gipi_quote_itmperil
          WHERE quote_id = p_quote_id
            AND item_no = p_item_no
            AND peril_type = 'B';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
            v_ann_tsi_amt := 0;
      END;

      BEGIN
         SELECT SUM (prem_amt), SUM (ann_prem_amt)
           INTO v_prem_amt, v_ann_prem_amt
           FROM gipi_quote_itmperil
          WHERE quote_id = p_quote_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_prem_amt := 0;
            v_ann_prem_amt := 0;
      END;

      UPDATE gipi_quote_item
         SET tsi_amt = v_tsi_amt,
             prem_amt = v_prem_amt,
             ann_tsi_amt = v_ann_tsi_amt,
             ann_prem_amt = v_ann_prem_amt
       WHERE quote_id = p_quote_id AND item_no = p_item_no;

      BEGIN
         SELECT SUM (tsi_amt), SUM (prem_amt), SUM (ann_tsi_amt),
                SUM (ann_prem_amt)
           INTO v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                v_ann_prem_amt
           FROM gipi_quote_item
          WHERE quote_id = p_quote_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
            v_prem_amt := 0;
            v_ann_tsi_amt := 0;
            v_ann_prem_amt := 0;
      END;

      UPDATE gipi_quote
         SET tsi_amt = v_tsi_amt,
             prem_amt = v_prem_amt,
             ann_tsi_amt = v_ann_tsi_amt,
             ann_prem_amt = v_ann_prem_amt
       WHERE quote_id = p_quote_id;
   END;

   /*
   **  Created by      : Nieko B.
   **  Date Created    : 04062016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Update tsi based deductibles
   */
   PROCEDURE update_quote_deductibles (
      p_quote_id   IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    IN   gipi_quote_itmperil.item_no%TYPE,
      p_peril_cd   IN   gipi_quote_itmperil.peril_cd%TYPE
   )
   IS
      v_tsi_amt    gipi_quote_itmperil.tsi_amt%TYPE;
      v_prem_amt   gipi_quote_itmperil.prem_amt%TYPE;
      v_rate       gipi_quote_itmperil.prem_rt%TYPE;
   BEGIN
      --policy level
      BEGIN
         SELECT SUM (tsi_amt)
           INTO v_tsi_amt
           FROM gipi_quote
          WHERE quote_id = p_quote_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
      END;

      FOR rec IN (SELECT a.*
                    FROM gipi_quote_deductibles a, giis_deductible_desc b
                   WHERE quote_id = p_quote_id
                     AND item_no = 0
                     AND peril_cd = 0
                     AND a.ded_line_cd = b.line_cd
                     AND a.ded_subline_cd = b.subline_cd
                     AND a.ded_deductible_cd = b.deductible_cd
                     AND b.ded_type = 'T')
      LOOP
         v_rate := rec.deductible_rt / 100;
         v_prem_amt := v_tsi_amt * v_rate;

         IF v_rate IS NOT NULL
         THEN
            IF rec.min_amt IS NOT NULL AND rec.max_amt IS NOT NULL
            THEN
               IF rec.range_sw = 'H'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSIF rec.range_sw = 'L'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSE
                  v_prem_amt := rec.min_amt;
               END IF;
            ELSIF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := GREATEST (v_prem_amt, rec.min_amt);
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := LEAST (v_prem_amt, rec.max_amt);
            END IF;
         ELSE
            IF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := rec.min_amt;
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := rec.max_amt;
            END IF;
         END IF;

         UPDATE gipi_quote_deductibles
            SET deductible_amt = v_prem_amt
          WHERE quote_id = rec.quote_id
            AND item_no = 0
            AND peril_cd = 0
            AND ded_deductible_cd = rec.ded_deductible_cd;
      END LOOP;

      --item level
      BEGIN
         SELECT SUM (tsi_amt)
           INTO v_tsi_amt
           FROM gipi_quote_item
          WHERE quote_id = p_quote_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
      END;

      FOR rec IN (SELECT a.*
                    FROM gipi_quote_deductibles a, giis_deductible_desc b
                   WHERE quote_id = p_quote_id
                     AND item_no = p_item_no
                     AND peril_cd = 0
                     AND a.ded_line_cd = b.line_cd
                     AND a.ded_subline_cd = b.subline_cd
                     AND a.ded_deductible_cd = b.deductible_cd
                     AND b.ded_type = 'T')
      LOOP
         v_rate := rec.deductible_rt / 100;
         v_prem_amt := v_tsi_amt * v_rate;

         IF v_rate IS NOT NULL
         THEN
            IF rec.min_amt IS NOT NULL AND rec.max_amt IS NOT NULL
            THEN
               IF rec.range_sw = 'H'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSIF rec.range_sw = 'L'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSE
                  v_prem_amt := rec.min_amt;
               END IF;
            ELSIF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := GREATEST (v_prem_amt, rec.min_amt);
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := LEAST (v_prem_amt, rec.max_amt);
            END IF;
         ELSE
            IF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := rec.min_amt;
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := rec.max_amt;
            END IF;
         END IF;

         UPDATE gipi_quote_deductibles
            SET deductible_amt = v_prem_amt
          WHERE quote_id = rec.quote_id
            AND item_no = rec.item_no
            AND peril_cd = 0
            AND ded_deductible_cd = rec.ded_deductible_cd;
      END LOOP;

      --peril level
      BEGIN
         SELECT SUM (tsi_amt)
           INTO v_tsi_amt
           FROM gipi_quote_itmperil
          WHERE quote_id = p_quote_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
      END;

      FOR rec IN (SELECT a.*
                    FROM gipi_quote_deductibles a, giis_deductible_desc b
                   WHERE quote_id = p_quote_id
                     AND item_no = p_item_no
                     AND peril_cd = p_peril_cd
                     AND a.ded_line_cd = b.line_cd
                     AND a.ded_subline_cd = b.subline_cd
                     AND a.ded_deductible_cd = b.deductible_cd
                     AND b.ded_type = 'T')
      LOOP
         v_rate := rec.deductible_rt / 100;
         v_prem_amt := v_tsi_amt * v_rate;

         IF v_rate IS NOT NULL
         THEN
            IF rec.min_amt IS NOT NULL AND rec.max_amt IS NOT NULL
            THEN
               IF rec.range_sw = 'H'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSIF rec.range_sw = 'L'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSE
                  v_prem_amt := rec.min_amt;
               END IF;
            ELSIF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := GREATEST (v_prem_amt, rec.min_amt);
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := LEAST (v_prem_amt, rec.max_amt);
            END IF;
         ELSE
            IF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := rec.min_amt;
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := rec.max_amt;
            END IF;
         END IF;

         UPDATE gipi_quote_deductibles
            SET deductible_amt = v_prem_amt
          WHERE quote_id = rec.quote_id
            AND item_no = rec.item_no
            AND peril_cd = rec.peril_cd
            AND ded_deductible_cd = rec.ded_deductible_cd;
      END LOOP;
   END update_quote_deductibles;

   /*
   **  Created by      : Nieko B.
   **  Date Created    : 04062016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Delete tsi based deductibles
   */
   PROCEDURE delete_quote_deductibles (
      p_quote_id   IN   gipi_quote_itmperil.quote_id%TYPE,
      p_item_no    IN   gipi_quote_itmperil.item_no%TYPE,
      p_peril_cd   IN   gipi_quote_itmperil.peril_cd%TYPE
   )
   IS
      v_tsi_amt    gipi_quote_itmperil.tsi_amt%TYPE;
      v_prem_amt   gipi_quote_itmperil.prem_amt%TYPE;
      v_rate       gipi_quote_itmperil.prem_rt%TYPE;
   BEGIN
      --peril level
      DELETE FROM gipi_quote_deductibles
            WHERE quote_id = p_quote_id
              AND item_no = p_item_no
              AND peril_cd = p_peril_cd;

      --policy level
      BEGIN
         SELECT SUM (tsi_amt)
           INTO v_tsi_amt
           FROM gipi_quote
          WHERE quote_id = p_quote_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
      END;

      FOR rec IN (SELECT a.*
                    FROM gipi_quote_deductibles a, giis_deductible_desc b
                   WHERE quote_id = p_quote_id
                     AND item_no = 0
                     AND peril_cd = 0
                     AND a.ded_line_cd = b.line_cd
                     AND a.ded_subline_cd = b.subline_cd
                     AND a.ded_deductible_cd = b.deductible_cd
                     AND b.ded_type = 'T')
      LOOP
         v_rate := rec.deductible_rt / 100;
         v_prem_amt := v_tsi_amt * v_rate;

         IF v_rate IS NOT NULL
         THEN
            IF rec.min_amt IS NOT NULL AND rec.max_amt IS NOT NULL
            THEN
               IF rec.range_sw = 'H'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSIF rec.range_sw = 'L'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSE
                  v_prem_amt := rec.min_amt;
               END IF;
            ELSIF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := GREATEST (v_prem_amt, rec.min_amt);
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := LEAST (v_prem_amt, rec.max_amt);
            END IF;
         ELSE
            IF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := rec.min_amt;
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := rec.max_amt;
            END IF;
         END IF;

         UPDATE gipi_quote_deductibles
            SET deductible_amt = v_prem_amt
          WHERE quote_id = rec.quote_id
            AND item_no = 0
            AND peril_cd = 0
            AND ded_deductible_cd = rec.ded_deductible_cd;
      END LOOP;

      --item level
      BEGIN
         SELECT SUM (tsi_amt)
           INTO v_tsi_amt
           FROM gipi_quote_item
          WHERE quote_id = p_quote_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tsi_amt := 0;
      END;

      FOR rec IN (SELECT a.*
                    FROM gipi_quote_deductibles a, giis_deductible_desc b
                   WHERE quote_id = p_quote_id
                     AND item_no = p_item_no
                     AND peril_cd = 0
                     AND a.ded_line_cd = b.line_cd
                     AND a.ded_subline_cd = b.subline_cd
                     AND a.ded_deductible_cd = b.deductible_cd
                     AND b.ded_type = 'T')
      LOOP
         v_rate := rec.deductible_rt / 100;
         v_prem_amt := v_tsi_amt * v_rate;

         IF v_rate IS NOT NULL
         THEN
            IF rec.min_amt IS NOT NULL AND rec.max_amt IS NOT NULL
            THEN
               IF rec.range_sw = 'H'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSIF rec.range_sw = 'L'
               THEN
                  v_prem_amt :=
                      LEAST (GREATEST (v_prem_amt, rec.min_amt), rec.max_amt);
               ELSE
                  v_prem_amt := rec.min_amt;
               END IF;
            ELSIF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := GREATEST (v_prem_amt, rec.min_amt);
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := LEAST (v_prem_amt, rec.max_amt);
            END IF;
         ELSE
            IF rec.min_amt IS NOT NULL
            THEN
               v_prem_amt := rec.min_amt;
            ELSIF rec.max_amt IS NOT NULL
            THEN
               v_prem_amt := rec.max_amt;
            END IF;
         END IF;

         UPDATE gipi_quote_deductibles
            SET deductible_amt = v_prem_amt
          WHERE quote_id = rec.quote_id
            AND item_no = rec.item_no
            AND peril_cd = 0
            AND ded_deductible_cd = rec.ded_deductible_cd;
      END LOOP;
   END;
END gipi_quote_itmperil_pkg;
/