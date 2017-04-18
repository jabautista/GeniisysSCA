CREATE OR REPLACE PACKAGE BODY CPI.gipi_witmperl_pkg
AS
   FUNCTION get_gipi_witmperl (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE
   )
      RETURN gipi_witmperl_tab PIPELINED
   IS
      v_witmperl   gipi_witmperl_type;
   BEGIN
      FOR i IN (SELECT a.discount_sw, a.surcharge_sw, a.prt_flag, a.peril_cd,
                       b.peril_name, a.prem_rt, a.tsi_amt, a.prem_amt,
                       NVL (a.no_of_days, 0) no_of_days,
                       NVL (a.base_amt, 0) base_amt, a.aggregate_sw,
                       a.ri_comm_rate, a.ri_comm_amt, a.par_id, a.item_no,
                       a.line_cd, a.ann_tsi_amt, a.ann_prem_amt,
                       b.peril_type, a.tarf_cd, a.comp_rem, b.basc_perl_cd,
                       a.rec_flag
                  FROM gipi_witmperl a, giis_peril b
                 WHERE a.par_id = p_par_id
                   AND a.item_no = NVL (p_item_no, a.item_no)
                   AND a.peril_cd = b.peril_cd
                   AND b.line_cd = a.line_cd)
      LOOP
         v_witmperl.discount_sw := i.discount_sw;
         v_witmperl.surcharge_sw := i.surcharge_sw;
         v_witmperl.prt_flag := i.prt_flag;
         v_witmperl.peril_cd := i.peril_cd;
         v_witmperl.peril_name := i.peril_name;
         v_witmperl.prem_rt := i.prem_rt;
         v_witmperl.tsi_amt := i.tsi_amt;
         v_witmperl.prem_amt := i.prem_amt;
         v_witmperl.no_of_days := i.no_of_days;
         v_witmperl.base_amt := i.base_amt;
         v_witmperl.aggregate_sw := i.aggregate_sw;
         v_witmperl.ri_comm_rate := i.ri_comm_rate;
         v_witmperl.ri_comm_amt := i.ri_comm_amt;
         v_witmperl.par_id := i.par_id;
         v_witmperl.item_no := i.item_no;
         v_witmperl.line_cd := i.line_cd;
         v_witmperl.ann_tsi_amt := i.ann_tsi_amt;
         v_witmperl.ann_prem_amt := i.ann_prem_amt;
         v_witmperl.peril_type := i.peril_type;
         v_witmperl.tarf_cd := i.tarf_cd;
         v_witmperl.comp_rem := i.comp_rem;
         v_witmperl.basc_perl_cd := i.basc_perl_cd;
         v_witmperl.rec_flag := i.rec_flag;
         PIPE ROW (v_witmperl);
      END LOOP;

      RETURN;
   END get_gipi_witmperl;

   FUNCTION get_gipi_witmperl (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE,
      p_line_cd   gipi_witmperl.line_cd%TYPE
   )
      RETURN gipi_witmperl_tab PIPELINED
   IS
      v_witmperl   gipi_witmperl_type;
   BEGIN
      FOR i IN (SELECT a.discount_sw, a.surcharge_sw, a.prt_flag, a.peril_cd,
                       b.peril_name, a.prem_rt, a.tsi_amt, a.prem_amt,
                       a.no_of_days, a.base_amt, a.aggregate_sw,
                       a.ri_comm_rate, a.ri_comm_amt, a.par_id, a.item_no,
                       a.line_cd, a.ann_tsi_amt, a.ann_prem_amt,
                       b.peril_type, a.tarf_cd, a.comp_rem
                  FROM gipi_witmperl a, giis_peril b
                 WHERE a.par_id = p_par_id
                   AND a.item_no = p_item_no
                   AND a.line_cd = p_line_cd
                   AND a.peril_cd = b.peril_cd)
      LOOP
         v_witmperl.discount_sw := i.discount_sw;
         v_witmperl.surcharge_sw := i.surcharge_sw;
         v_witmperl.prt_flag := i.prt_flag;
         v_witmperl.peril_cd := i.peril_cd;
         v_witmperl.peril_name := i.peril_name;
         v_witmperl.prem_rt := i.prem_rt;
         v_witmperl.tsi_amt := i.tsi_amt;
         v_witmperl.prem_amt := i.prem_amt;
         v_witmperl.no_of_days := i.no_of_days;
         v_witmperl.base_amt := i.base_amt;
         v_witmperl.aggregate_sw := i.aggregate_sw;
         v_witmperl.ri_comm_rate := i.ri_comm_rate;
         v_witmperl.ri_comm_amt := i.ri_comm_amt;
         v_witmperl.par_id := i.par_id;
         v_witmperl.item_no := i.item_no;
         v_witmperl.line_cd := i.line_cd;
         v_witmperl.ann_tsi_amt := i.ann_tsi_amt;
         v_witmperl.ann_prem_amt := i.ann_prem_amt;
         v_witmperl.peril_type := i.peril_type;
         v_witmperl.tarf_cd := i.tarf_cd;
         v_witmperl.comp_rem := i.comp_rem;
         PIPE ROW (v_witmperl);
      END LOOP;

      RETURN;
   END get_gipi_witmperl;

   /*
   * emman - 060110
   * checks if item in specified par exists
   */
   FUNCTION is_exist_gipi_witmperl (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      SELECT DISTINCT 'Y'
                 INTO v_exist
                 FROM gipi_witmperl
                WHERE par_id = p_par_id AND item_no = p_item_no;

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END is_exist_gipi_witmperl;

   FUNCTION is_exist_par_item_peril (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      IF gipi_witmperl_pkg.par_item_has_peril (p_par_id, p_item_no)
      THEN
         v_exist := 'Y';
      END IF;

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END is_exist_par_item_peril;

   PROCEDURE set_gipi_witmperl (p_witmperl IN gipi_witmperl%ROWTYPE)
   IS
     v_par_type GIPI_PARLIST.par_type%TYPE;
   BEGIN
      MERGE INTO gipi_witmperl
         USING DUAL
         ON (    par_id = p_witmperl.par_id
             AND item_no = p_witmperl.item_no
             AND line_cd = p_witmperl.line_cd
             AND peril_cd = p_witmperl.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (discount_sw, surcharge_sw, prt_flag, peril_cd, prem_rt,
                    tsi_amt, prem_amt, no_of_days, base_amt, aggregate_sw,
                    ri_comm_rate, ri_comm_amt, par_id, item_no, line_cd,
                    ann_tsi_amt, ann_prem_amt, tarf_cd, comp_rem, rec_flag) -- andrew - 09.27.2012 - added rec_flag in inserting, for endt peril
            VALUES (p_witmperl.discount_sw, p_witmperl.surcharge_sw,
                    p_witmperl.prt_flag, p_witmperl.peril_cd,
                    p_witmperl.prem_rt, p_witmperl.tsi_amt,
                    p_witmperl.prem_amt, p_witmperl.no_of_days,
                    p_witmperl.base_amt, p_witmperl.aggregate_sw,
                    p_witmperl.ri_comm_rate, p_witmperl.ri_comm_amt,
                    p_witmperl.par_id, p_witmperl.item_no, p_witmperl.line_cd,
                    p_witmperl.ann_tsi_amt, p_witmperl.ann_prem_amt,
                    p_witmperl.tarf_cd, p_witmperl.comp_rem, p_witmperl.rec_flag)
         WHEN MATCHED THEN
            UPDATE
               SET discount_sw = p_witmperl.discount_sw,
                   surcharge_sw = p_witmperl.surcharge_sw,
                   prt_flag = p_witmperl.prt_flag,
                   prem_rt = p_witmperl.prem_rt, tsi_amt = p_witmperl.tsi_amt,
                   prem_amt = p_witmperl.prem_amt,
                   no_of_days = p_witmperl.no_of_days,
                   base_amt = p_witmperl.base_amt,
                   aggregate_sw = p_witmperl.aggregate_sw,
                   ri_comm_rate = p_witmperl.ri_comm_rate,
                   ri_comm_amt = p_witmperl.ri_comm_amt,
                   ann_tsi_amt = p_witmperl.ann_tsi_amt,
                   ann_prem_amt = p_witmperl.ann_prem_amt,
                   tarf_cd = p_witmperl.tarf_cd,
                   comp_rem = p_witmperl.comp_rem,
                   rec_flag = p_witmperl.rec_flag -- andrew - 09.27.2012 - added rec_flag in updating, for endt peril
            ;
      --COMMIT;
      SELECT par_type
        INTO v_par_type
        FROM GIPI_PARLIST
       WHERE par_id = p_witmperl.par_id;

      IF v_par_type <> 'E' THEN
        gipi_witem_pkg.update_amt_details (p_witmperl.par_id, p_witmperl.item_no);
      END IF;
   END set_gipi_witmperl;

   PROCEDURE set_gipi_witmperl (
      p_discount_sw    IN   gipi_witmperl.discount_sw%TYPE,
      p_surcharge_sw   IN   gipi_witmperl.surcharge_sw%TYPE,
      p_prt_flag       IN   gipi_witmperl.prt_flag%TYPE,
      p_peril_cd       IN   gipi_witmperl.peril_cd%TYPE,
      p_prem_rt        IN   gipi_witmperl.prem_rt%TYPE,
      p_tsi_amt        IN   gipi_witmperl.tsi_amt%TYPE,
      p_prem_amt       IN   gipi_witmperl.prem_amt%TYPE,
      p_no_of_days     IN   gipi_witmperl.no_of_days%TYPE,
      p_base_amt       IN   gipi_witmperl.base_amt%TYPE,
      p_aggregate_sw   IN   gipi_witmperl.aggregate_sw%TYPE,
      p_ri_comm_rate   IN   gipi_witmperl.ri_comm_rate%TYPE,
      p_ri_comm_amt    IN   gipi_witmperl.ri_comm_amt%TYPE,
      p_par_id         IN   gipi_witmperl.par_id%TYPE,
      p_item_no        IN   gipi_witmperl.item_no%TYPE,
      p_line_cd        IN   gipi_witmperl.line_cd%TYPE,
      p_ann_tsi_amt    IN   gipi_witmperl.ann_tsi_amt%TYPE,
      p_ann_prem_amt   IN   gipi_witmperl.ann_prem_amt%TYPE,
      p_tarf_cd        IN   gipi_witmperl.tarf_cd%TYPE,
      p_comp_rem       IN   gipi_witmperl.comp_rem%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_witmperl
         USING DUAL
         ON (    par_id = p_par_id
             AND item_no = p_item_no
             AND line_cd = p_line_cd
             AND peril_cd = p_peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (discount_sw, surcharge_sw, prt_flag, peril_cd, prem_rt,
                    tsi_amt, prem_amt, no_of_days, base_amt, aggregate_sw,
                    ri_comm_rate, ri_comm_amt, par_id, item_no, line_cd,
                    ann_tsi_amt, ann_prem_amt, tarf_cd, comp_rem)
            VALUES (p_discount_sw, p_surcharge_sw, p_prt_flag, p_peril_cd,
                    p_prem_rt, p_tsi_amt, p_prem_amt, p_no_of_days,
                    p_base_amt, p_aggregate_sw, p_ri_comm_rate, p_ri_comm_amt,
                    p_par_id, p_item_no, p_line_cd, p_ann_tsi_amt,
                    p_ann_prem_amt, p_tarf_cd, p_comp_rem)
         WHEN MATCHED THEN
            UPDATE
               SET discount_sw = p_discount_sw, surcharge_sw = p_surcharge_sw,
                   prt_flag = p_prt_flag, prem_rt = p_prem_rt,
                   tsi_amt = p_tsi_amt, prem_amt = p_prem_amt,
                   no_of_days = p_no_of_days, base_amt = p_base_amt,
                   aggregate_sw = p_aggregate_sw,
                   ri_comm_rate = p_ri_comm_rate, ri_comm_amt = p_ri_comm_amt,
                   ann_tsi_amt = p_ann_tsi_amt, ann_prem_amt = p_ann_prem_amt,
                   tarf_cd = p_tarf_cd, comp_rem = p_comp_rem
            ;
      COMMIT;
   END set_gipi_witmperl;

   PROCEDURE del_gipi_witmperl (
      p_par_id     IN   gipi_witmperl.par_id%TYPE,
      p_item_no    IN   gipi_witmperl.item_no%TYPE,
      p_line_cd    IN   gipi_witmperl.line_cd%TYPE,
      p_peril_cd   IN   gipi_witmperl.peril_cd%TYPE
   )
   IS
      v_par_type GIPI_PARLIST.par_type%TYPE;
   BEGIN
        --added by Gzelle 09122014 - delete default warranties and clauses of deleted peril in gipi_wpolwc
        FOR i IN (SELECT main_wc_cd
                    FROM giis_peril_clauses
                   WHERE line_cd = p_line_cd
                     AND peril_cd = p_peril_cd)
        LOOP
            DELETE FROM gipi_wpolwc
             WHERE par_id = p_par_id
               AND line_cd = p_line_cd
               AND wc_cd = i.main_wc_cd;
        END LOOP;

      DELETE FROM gipi_witmperl
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND line_cd = p_line_cd
              AND peril_cd = p_peril_cd;
      SELECT par_type
        INTO v_par_type
        FROM GIPI_PARLIST
       WHERE par_id = p_par_id;

      IF v_par_type <> 'E' THEN
        gipi_witem_pkg.update_amt_details (p_par_id, p_item_no);
      END IF;
   --COMMIT;
   END del_gipi_witmperl;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Constains delete procedure on GIPI_WITMPERL based on par_id, and item_no
   */
   PROCEDURE del_gipi_witmperl_1 (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE,
      p_line_cd    GIPI_WITMPERL.line_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_witmperl
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND line_cd = p_line_cd;

      gipi_witem_pkg.update_amt_details(p_par_id, p_item_no);
   END del_gipi_witmperl_1;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (SET_LIMIT_INTO_GIPI_WITMPERL)
**  Description  : Procedure to delete witmperl record
*/
   PROCEDURE del_gipi_witmperl2 (p_par_id gipi_witmperl.par_id%TYPE)
                                               --par_id to limit the deletion.
   IS
   BEGIN
      DELETE FROM gipi_witmperl
            WHERE par_id = p_par_id;
   END del_gipi_witmperl2;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (CHECK_WDEDUCTIBLE)
**  Description  : This returns true if the par item has perils and false if the par item has no perils.
*/
   FUNCTION par_item_has_peril (
      p_par_id    gipi_wpolbas.par_id%TYPE,             --par_id to be checked
      p_item_no   gipi_witmperl.item_no%TYPE
   )                                                   --item_no to be checked
      RETURN BOOLEAN
   IS
      v_result   BOOLEAN := FALSE;
   BEGIN
      FOR a IN (SELECT peril_cd
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_result := TRUE;
         EXIT;
      END LOOP;

      RETURN v_result;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END par_item_has_peril;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS169 - Peril Deductible)
**  Description  : This returns the item peril records of the given par_id and line_cd.
*/
   FUNCTION get_witmperl_list (
      p_par_id    gipi_witmperl.par_id%TYPE,       --par_id to limit the query
      p_line_cd   gipi_witmperl.line_cd%TYPE
   )                                              --line_cd to limit the query
      RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.peril_name, b.peril_cd, b.peril_type,
                                a.item_no, a.tsi_amt
                           FROM gipi_witmperl a, giis_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND a.par_id = p_par_id
                            AND a.line_cd = p_line_cd
                            AND a.prem_amt > 0
                       ORDER BY 1, 2)
      LOOP
         v_peril.peril_name := i.peril_name;
         v_peril.peril_cd := i.peril_cd;
         v_peril.peril_type := i.peril_type;
         v_peril.item_no := i.item_no;
         v_peril.tsi_amt := i.tsi_amt;
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_witmperl_list;

   /*
   **  Created by   :  Whofeih
   **  Date Created :  February 03, 2010
   **  Reference By : Copy PAR)
   **  Description  : This returns the item peril records of the given par_id
   */
   FUNCTION get_witmperl_list (p_par_id gipi_witmperl.par_id%TYPE)
      RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.peril_name, b.peril_cd, a.item_no,
                                a.tsi_amt
                           FROM gipi_witmperl a, giis_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND a.par_id = p_par_id
                            AND a.prem_amt > 0
                       ORDER BY 1, 2)
      LOOP
         v_peril.peril_name := i.peril_name;
         v_peril.peril_cd := i.peril_cd;
         v_peril.item_no := i.item_no;
         v_peril.tsi_amt := i.tsi_amt;
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_witmperl_list;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  February 09, 2010
   **  Reference By : (GIPIS002-Basic Info)
   **  Description  : This returns if par_id is existing in GIPI_WITMPERL.
   */
   PROCEDURE get_gipi_witmperl_exist (
      p_par_id   IN       gipi_witmperl.par_id%TYPE,
      p_exist    OUT      NUMBER
   )
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id)
      LOOP
         v_exist := 1;
      END LOOP;

      p_exist := v_exist;
   END;

   /*
   **  Created by   :  Bryan Joseph G. Abuluyan
   **  Date Created :  March 11, 2010
   **  Reference By : (GIPIS038-Peril info Info)
   **  Description  : This returns if par_id and item_no is existing in GIPI_WITMPERL.
   */
   FUNCTION get_gipi_witmperl_exist (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_exist := 'Y';
      END LOOP;

      RETURN v_exist;
   END;

   /*
    **  Created by    : Bryan Joseph Abuluyan
    **  Date Created  : 02.25.2010
    **  Reference By  : (GIPIS038 - Peril Information)
    **  Description   : Deducts discount from table
    */
   PROCEDURE set_delete_discount (
      p_par_id              IN       gipi_witmperl.par_id%TYPE,
      p_item_no             IN       gipi_witmperl.item_no%TYPE,
      p_item_prem_amt       OUT      VARCHAR2 --OUT   GIPI_WITEM.prem_amt%TYPE
                                             ,
      p_item_ann_prem_amt   OUT      VARCHAR2
   )                                    --OUT   GIPI_WITEM.ann_prem_amt%TYPE);
   IS
      v_item_prem_amt       gipi_witem.prem_amt%TYPE;
      v_item_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE;
      new_peril_prem_amt    gipi_witmperl.prem_amt%TYPE;
      v_discount_sw         gipi_witmperl.discount_sw%TYPE;
      v_ri_comm_amt         gipi_witmperl.ri_comm_amt%TYPE;
      v_ann_prem_amt        gipi_witmperl.ann_prem_amt%TYPE;
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_no, a.prem_amt, b.peril_cd,
                       b.prem_amt peril_prem_amt, b.ri_comm_rate, b.line_cd
                  FROM gipi_witem a, gipi_witmperl b
                 WHERE b.par_id = a.par_id
                   AND b.item_no = a.item_no
                   AND a.par_id = p_par_id
                   AND a.item_no = p_item_no)
      LOOP
         gipi_wperil_discount_pkg.get_peril_discount (i.par_id,
                                                      i.item_no,
                                                      i.prem_amt,
                                                      i.peril_cd,
                                                      i.peril_prem_amt,
                                                      i.ri_comm_rate,
                                                      v_item_prem_amt,
                                                      new_peril_prem_amt,
                                                      v_discount_sw,
                                                      v_ri_comm_amt,
                                                      v_ann_prem_amt
                                                     );

         UPDATE gipi_witmperl
            SET prem_amt = new_peril_prem_amt,
                discount_sw = v_discount_sw,
                ri_comm_amt = v_ri_comm_amt,
                ann_prem_amt = v_ann_prem_amt
          WHERE par_id = i.par_id
            AND item_no = i.item_no
            AND line_cd = i.line_cd
            AND peril_cd = i.peril_cd;
      END LOOP;

      v_item_ann_prem_amt :=
         gipi_wperil_discount_pkg.get_orig_item_ann_prem_amt (p_par_id,
                                                              p_item_no
                                                             );
      gipi_witem_pkg.set_amts (p_par_id,
                               p_item_no,
                               v_item_prem_amt,
                               v_item_ann_prem_amt
                              );
      --COMMIT;
      p_item_prem_amt := TO_CHAR (v_item_prem_amt, '999,999,999,999.99');
      p_item_ann_prem_amt :=
                           TO_CHAR (v_item_ann_prem_amt, '999,999,999,999.99');
   END set_delete_discount;

   PROCEDURE update_witem (
      p_par_id    IN   gipi_witmperl.par_id%TYPE,
      p_item_no   IN   gipi_witmperl.item_no%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT   SUM (NVL (prem_amt, 0)) prem,
                         SUM (NVL (ann_prem_amt, 0)) ann_prem, item_no
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id AND item_no = p_item_no
                GROUP BY item_no)
      LOOP
         --Gipi_Witem_Pkg.set_amts(p_par_id, p_item_no, i.prem, i.ann_prem);
         UPDATE gipi_witem
            SET prem_amt = i.prem,                               --p_prem_amt,
                ann_prem_amt = i.ann_prem                     --p_ann_prem_amt
          WHERE par_id = p_par_id AND item_no = i.item_no;
      END LOOP;

      FOR j IN (SELECT   SUM (NVL (a.tsi_amt, 0)) tsi,
                         SUM (NVL (a.ann_tsi_amt, 0)) ann_tsi, a.item_no
                    FROM gipi_witmperl a, giis_peril b
                   WHERE a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                     AND b.peril_type = 'B'
                     AND a.par_id = p_par_id
                     AND item_no = p_item_no
                GROUP BY a.item_no)
      LOOP
         --Gipi_Witem_Pkg.set_tsi(p_par_id, p_item_no, j.tsi, j.ann_tsi);
         UPDATE gipi_witem
            SET tsi_amt = j.tsi,                                  --p_tsi_amt,
                ann_tsi_amt = j.ann_tsi                        --p_ann_tsi_amt
          WHERE par_id = p_par_id AND item_no = j.item_no;
      END LOOP;

      gipi_witem_pkg.update_wpolbas (p_par_id);
   END;

   PROCEDURE create_winvoice_for_par (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_line_cd   gipi_witmperl.line_cd%TYPE,
      p_iss_cd    gipi_parlist.iss_cd%TYPE
   )
   IS
   BEGIN
      FOR a IN (SELECT '1'
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id)
      LOOP
         create_winvoice (0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
         EXIT;
      END LOOP;
   END create_winvoice_for_par;

   /*
   **  Created by  : Menandro G.C. Robes
   **  Date Created   : March 22, 2010
   **  Reference By   : (SET_LIMIT_INTO_GIPI_WITMPERL)
   **  Description    : Procedure to insert witmperl record
   */
   PROCEDURE set_gipi_witmperl2 (
      p_par_id         IN   gipi_witmperl.par_id%TYPE,
      p_item_no        IN   gipi_witmperl.item_no%TYPE,
      p_line_cd        IN   gipi_witmperl.line_cd%TYPE,
      p_peril_cd       IN   gipi_witmperl.peril_cd%TYPE,
      p_discount_sw    IN   gipi_witmperl.discount_sw%TYPE,
      p_prem_rt        IN   gipi_witmperl.prem_rt%TYPE,
      p_tsi_amt        IN   gipi_witmperl.tsi_amt%TYPE,
      p_prem_amt       IN   gipi_witmperl.prem_amt%TYPE,
      p_ann_tsi_amt    IN   gipi_witmperl.ann_tsi_amt%TYPE,
      p_ann_prem_amt   IN   gipi_witmperl.ann_prem_amt%TYPE
   )
   IS
   BEGIN
      INSERT INTO gipi_witmperl
                  (par_id, item_no, line_cd, peril_cd,
                   discount_sw, prem_rt, tsi_amt, prem_amt,
                   ann_tsi_amt, ann_prem_amt
                  )
           VALUES (p_par_id, p_item_no, p_line_cd, p_peril_cd,
                   p_discount_sw, p_prem_rt, p_tsi_amt, p_prem_amt,
                   p_ann_tsi_amt, p_ann_prem_amt
                  );
   END set_gipi_witmperl2;

   FUNCTION get_peril_details (
      p_par_id     gipi_parlist.par_id%TYPE,
      p_item_no    gipi_witem.item_no%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_prem_amt   gipi_witmperl.prem_amt%TYPE,
      p_comp_rem   gipi_witmperl.comp_rem%TYPE
   )
      RETURN peril_details_tab PIPELINED
   IS
      v   peril_details_type;
   BEGIN
      validate_peril_name (p_par_id,
                           p_item_no,
                           p_peril_cd,
                           p_prem_amt,
                           p_comp_rem,
                           v.prem_rt,
                           v.tsi_amt,
                           v.prem_amt,
                           v.ann_tsi_amt,
                           v.ann_prem_amt,
                           v.ri_comm_rate,
                           v.ri_comm_amt
                          );
      PIPE ROW (v);
      RETURN;
   END;

   /*
   **  Created by  : Andrew Robes
   **  Date Created   : May 14, 2010
   **  Reference By   : (GIPIS097 - Endorsement Item Peril)
   **  Description    : Function to retrieve endorsement item peril record/s.
   */
   FUNCTION get_endt_peril (p_par_id gipi_witmperl.par_id%TYPE)
      RETURN endt_peril_tab PIPELINED
   IS
      v_endtperl   endt_peril_type;
      v_dummy VARCHAR2(100);
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_no, a.line_cd, a.peril_cd,
                       b.peril_name, NVL (a.prem_rt, 0) prem_rt,
                       NVL (a.tsi_amt, 0) tsi_amt,
                       NVL (a.prem_amt, 0) prem_amt,
                       NVL (a.ann_tsi_amt, 0) ann_tsi_amt,
                       NVL (a.ann_prem_amt, 0) ann_prem_amt,
                       NVL (a.ri_comm_rate, 0) ri_comm_rate,
                       NVL (a.ri_comm_amt, 0) ri_comm_amt, a.no_of_days,
                       a.base_amt, b.peril_type, a.comp_rem, a.rec_flag,
                       a.tarf_cd, b.basc_perl_cd
                  FROM gipi_witmperl a, giis_peril b
                 WHERE a.par_id = p_par_id
                   AND a.peril_cd = b.peril_cd
                   AND b.line_cd = a.line_cd)
      LOOP
         v_endtperl.peril_cd := i.peril_cd;
         v_endtperl.peril_name := i.peril_name;
         v_endtperl.prem_rt := i.prem_rt;
         v_endtperl.tsi_amt := i.tsi_amt;
         v_endtperl.prem_amt := i.prem_amt;
         v_endtperl.par_id := i.par_id;
         v_endtperl.item_no := i.item_no;
         v_endtperl.line_cd := i.line_cd;
         v_endtperl.ann_tsi_amt := i.ann_tsi_amt;
         v_endtperl.ann_prem_amt := i.ann_prem_amt;
         v_endtperl.ri_comm_rate := i.ri_comm_rate;
         v_endtperl.ri_comm_amt := i.ri_comm_amt;
         v_endtperl.comp_rem := i.comp_rem;
         v_endtperl.rec_flag := i.rec_flag;
         v_endtperl.no_of_days := i.no_of_days;
         v_endtperl.base_amt := i.base_amt;
		 v_endtperl.basc_perl_cd := i.basc_perl_cd;
         v_endtperl.disc_sum :=
            gipi_wperil_discount_pkg.get_peril_sum_discount (i.par_id,
                                                             i.item_no,
                                                             i.peril_cd
                                                            );
         v_endtperl.tarf_cd := i.tarf_cd;
         v_endtperl.peril_type := i.peril_type;

         gipis097_when_val_peril(i.par_id, i.item_no, i.peril_cd, i.peril_type, v_dummy, i.prem_rt, i.tsi_amt, v_endtperl.endt_ann_tsi_amt, i.prem_amt, v_endtperl.endt_ann_prem_amt, v_endtperl.base_ann_prem_amt, v_dummy, v_dummy, v_dummy, i.no_of_days, v_dummy);
         PIPE ROW (v_endtperl);
      END LOOP;

      RETURN;
   END get_endt_peril;

   FUNCTION get_post_tsi_details (
      p_par_id         IN   gipi_parlist.par_id%TYPE,
      p_item_no        IN   gipi_witem.item_no%TYPE,
      p_peril_cd       IN   gipi_witmperl.peril_cd%TYPE,
      p_prem_rt        IN   gipi_witmperl.prem_rt%TYPE,
      p_tsi_amt        IN   gipi_witmperl.tsi_amt%TYPE,
      p_prem_amt       IN   gipi_witmperl.prem_amt%TYPE,
      p_ann_tsi_amt    IN   gipi_witmperl.ann_tsi_amt%TYPE,
      p_ann_prem_amt   IN   gipi_witmperl.ann_prem_amt%TYPE,
      i_tsi_amt        IN   gipi_witem.tsi_amt%TYPE,
      i_prem_amt       IN   gipi_witem.prem_amt%TYPE,
      i_ann_tsi_amt    IN   gipi_witem.ann_tsi_amt%TYPE,
      i_ann_prem_amt   IN   gipi_witem.ann_prem_amt%TYPE
   )
      RETURN item_and_peril_amounts_tab PIPELINED
   IS
      det   item_and_peril_amounts_type;
   BEGIN
      post_text_tsi_amt_gipis038 (p_par_id,
                                  p_item_no,
                                  p_peril_cd,
                                  p_prem_rt,
                                  p_tsi_amt,
                                  p_prem_amt,
                                  p_ann_tsi_amt,
                                  p_ann_prem_amt,
                                  i_tsi_amt,
                                  i_prem_amt,
                                  i_ann_tsi_amt,
                                  i_ann_prem_amt,
                                  det.peril_prem_amt,
                                  det.peril_ann_prem_amt,
                                  det.peril_ann_tsi_amt,
                                  det.item_prem_amt,
                                  det.item_ann_prem_amt,
                                  det.item_tsi_amt,
                                  det.item_ann_tsi_amt,
                                  det.peril_tsi_amt --added by Gzelle 11262014
                                 );
      PIPE ROW (det);
      RETURN;
   END get_post_tsi_details;

   /*
   **  Created by    : Menandro G.C. Robes
   **  Date Created  : June 29, 2010
   **  Reference By  : (GIPIS097 - Endt Item Peril Information)
   **  Description   : Procedure to update amounts when the discount is to be deleted.
   */
   PROCEDURE update_gipi_witmperl_discount (
      p_par_id                    gipi_witmperl.par_id%TYPE,
      p_item_no                   gipi_witmperl.item_no%TYPE,
      p_peril_cd                  gipi_witmperl.peril_cd%TYPE,
      p_disc_amt                  gipi_wperil_discount.disc_amt%TYPE,
      p_orig_peril_ann_prem_amt   gipi_wperil_discount.orig_peril_ann_prem_amt%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_witmperl
         SET prem_amt = prem_amt + p_disc_amt,
             ann_prem_amt = NVL (p_orig_peril_ann_prem_amt, ann_prem_amt),
             discount_sw = 'N'
       WHERE par_id = p_par_id AND item_no = p_item_no
             AND peril_cd = p_peril_cd;
   END update_gipi_witmperl_discount;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 07.07.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This function checks if a record exists in GIPI_WITMPERL using p_par_id
   */
   FUNCTION get_gipi_witmperl_exist (p_par_id IN gipi_witmperl.par_id%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR a IN (SELECT '1'
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END get_gipi_witmperl_exist;

   /* Added by reymon 04222013
    ** for package endorsement
    */
    FUNCTION get_pack_gipi_witmperl_exist (pack_par_id IN GIPI_PARLIST.pack_par_id%TYPE)
        RETURN VARCHAR2
    IS
        v_exist     VARCHAR2 (1) := 'N';
    BEGIN
        FOR b IN (SELECT 1
                    FROM gipi_witmperl a
                   WHERE  EXISTS (SELECT 1
                                    FROM gipi_parlist b
                                   WHERE b.par_id = a.par_id
                                     AND b.pack_par_id = 58))
        LOOP
            v_exist := 'Y';
            EXIT;
        END LOOP;

        RETURN v_exist;
    END get_pack_gipi_witmperl_exist;

   /*
   **  Created by    : Bryan
   **  Date Created  : 11.03.2010
   **  Description   : This function obtains negated values of item perils for endorsement
   */
   FUNCTION get_negate_itmperls (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE
   )
      RETURN gipi_witmperl_tab PIPELINED
   IS
      v_witmperl       gipi_witmperl_type;
      v_prorate        NUMBER;
      v_short_rt       NUMBER;
      v_comp_var       NUMBER;
      v_ann_tsi_amt    gipi_witmperl.ann_tsi_amt%TYPE;
      v_ann_prem_amt   gipi_witmperl.ann_prem_amt%TYPE;
      v_tsi_amt        gipi_witmperl.tsi_amt%TYPE;
      v_prem_amt       gipi_witmperl.prem_amt%TYPE;
   BEGIN
      FOR b540 IN (SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
                          renew_no, eff_date, prorate_flag, comp_sw,
                          endt_expiry_date, incept_date, expiry_date,
                          short_rt_percent
                     FROM gipi_wpolbas
                    WHERE par_id = p_par_id)
      LOOP
         IF b540.prorate_flag <> '2'
         THEN
            IF NVL (b540.comp_sw, 'N') = 'N'
            THEN
               v_comp_var := 0;
            ELSIF NVL (b540.comp_sw, 'N') = 'Y'
            THEN
               v_comp_var := 1;
            ELSE
               v_comp_var := -1;
            END IF;

            v_prorate :=
                 TRUNC (b540.endt_expiry_date - b540.eff_date + v_comp_var)
               / check_duration (b540.incept_date, b540.expiry_date);
            v_short_rt := NVL (b540.short_rt_percent, 1) / 100;

            FOR a1 IN (SELECT   b.line_cd, b.peril_cd, SUM (b.tsi_amt)
                                                                      tsi_amt,
                                SUM (b.prem_amt) prem_amt, c.peril_name
                           FROM gipi_itmperil b, giis_peril c
                          WHERE EXISTS (
                                   SELECT '1'
                                     FROM gipi_polbasic a
                                    WHERE a.line_cd = b540.line_cd
                                      AND a.iss_cd = b540.iss_cd
                                      AND a.subline_cd = b540.subline_cd
                                      AND a.issue_yy = b540.issue_yy
                                      AND a.pol_seq_no = b540.pol_seq_no
                                      AND a.renew_no = b540.renew_no
                                      AND a.pol_flag IN ('1', '2', '3')
                                      AND TRUNC (a.eff_date) <=
                                                         TRUNC (b540.eff_date)
                                      AND a.policy_id = b.policy_id)
                            AND b.item_no = p_item_no
                            AND b.peril_cd = c.peril_cd
                            AND b.line_cd = c.line_cd
                       GROUP BY b.line_cd, b.peril_cd)
            LOOP
               IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0
               THEN
                  IF b540.prorate_flag = '1'
                  THEN
                     v_prem_amt := a1.prem_amt * v_prorate;
                     v_tsi_amt := a1.tsi_amt * v_prorate;
                  ELSE
                     v_prem_amt := a1.prem_amt * v_short_rt;
                     v_tsi_amt := a1.tsi_amt * v_short_rt;
                  END IF;

                  IF TRUNC (b540.endt_expiry_date) <> TRUNC (b540.expiry_date)
                  THEN
                     v_ann_prem_amt := a1.prem_amt - v_prem_amt;
                     v_ann_tsi_amt := a1.tsi_amt - v_tsi_amt;
                  ELSE
                     v_ann_prem_amt := 0;
                     v_ann_tsi_amt := 0;
                     v_tsi_amt := a1.tsi_amt;
                  END IF;

                  v_witmperl.par_id := p_par_id;
                  v_witmperl.item_no := p_item_no;
                  v_witmperl.line_cd := a1.line_cd;
                  v_witmperl.peril_cd := a1.peril_cd;
                  v_witmperl.peril_name := a1.peril_name;
                  v_witmperl.discount_sw := 'N';
                  v_witmperl.prem_rt := 0;
                  v_witmperl.tsi_amt := - (v_tsi_amt);
                  v_witmperl.prem_amt := - (v_prem_amt);
                  v_witmperl.ann_tsi_amt := v_ann_tsi_amt;
                  v_witmperl.ann_prem_amt := v_ann_prem_amt;
                  v_witmperl.prt_flag := '1';
                  v_witmperl.rec_flag := 'D';
                  PIPE ROW (v_witmperl);
               END IF;
            END LOOP;
         ELSE
            FOR a1 IN (SELECT   b.line_cd, b.peril_cd,
                                SUM (b.tsi_amt) tsi_amt,
                                SUM (b.prem_amt) prem_amt,
                                c.peril_name
                           FROM gipi_itmperil b, giis_peril c
                          WHERE EXISTS (
                                   SELECT '1'
                                     FROM gipi_polbasic a
                                    WHERE a.line_cd = b540.line_cd
                                      AND a.iss_cd = b540.iss_cd
                                      AND a.subline_cd = b540.subline_cd
                                      AND a.issue_yy = b540.issue_yy
                                      AND a.pol_seq_no = b540.pol_seq_no
                                      AND a.renew_no = b540.renew_no
                                      AND a.pol_flag IN ('1', '2', '3')
                                      AND TRUNC (a.eff_date) <=
                                                         TRUNC (b540.eff_date)
                                      --AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  b540.eff_date
                                      AND a.policy_id = b.policy_id)
                            AND b.item_no = p_item_no
                            AND b.peril_cd = c.peril_cd
                            AND b.line_cd = c.line_cd
                       GROUP BY b.line_cd, b.peril_cd, c.peril_name)
            LOOP
               IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0
               THEN
                  v_witmperl.par_id := p_par_id;
                  v_witmperl.item_no := p_item_no;
                  v_witmperl.line_cd := a1.line_cd;
                  v_witmperl.peril_cd := a1.peril_cd;
                  v_witmperl.peril_name := a1.peril_name;
                  v_witmperl.discount_sw := 'N';
                  v_witmperl.prem_rt := 0;
                  v_witmperl.tsi_amt := - (a1.tsi_amt);
                  v_witmperl.prem_amt := - (a1.prem_amt);
                  v_witmperl.ann_tsi_amt := 0;
                  v_witmperl.ann_prem_amt := 0;
                  v_witmperl.prt_flag := '1';
                  v_witmperl.rec_flag := 'D';
                  PIPE ROW (v_witmperl);
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      RETURN;
   END get_negate_itmperls;

   /*   Created by           : Bryan Joseph g. Abuluyan
   *   Date Created          : November 9, 2010
   *   Module              : GIPIS038
   */
  FUNCTION get_giis_plan_dtls(
             p_par_id              GIPI_PARLIST.par_id%TYPE,
           p_pack_par_id      GIPI_PARLIST.pack_par_id%TYPE,
           p_pack_line_cd      GIPI_WITEM.pack_line_cd%TYPE,
           p_pack_subline_cd  GIPI_WITEM.pack_subline_cd%TYPE)
    RETURN giis_plan_dtl_tab PIPELINED IS

    v_plan_dtl                 giis_plan_dtl_type;
    --v_pack_par_id             gipi_parlist.pack_par_id%TYPE;

  BEGIN

    IF p_pack_par_id IS NULL THEN

        FOR i IN (
             SELECT a.peril_cd, a.aggregate_sw, nvl(a.base_amt,0) base_amt, a.line_cd,
                     nvl(a.no_of_days,0) no_of_days, nvl(a.prem_amt,0) prem_amt, nvl(a.prem_rt,0) prem_rt,
                    nvl(a.tsi_amt,0) tsi_amt, c.peril_type, c.peril_name
               FROM GIIS_PLAN_DTL a, GIPI_WPOLBAS b, GIIS_PERIL c
              WHERE a.plan_cd = b.plan_cd
                AND a.peril_cd = c.peril_cd
                AND a.line_cd = c.line_cd
                AND b.par_id = p_par_id
              ORDER BY c.peril_type DESC)
        LOOP
          v_plan_dtl.peril_cd             := i.peril_cd;
          v_plan_dtl.aggregate_sw         := i.aggregate_sw;
          v_plan_dtl.base_amt             := i.base_amt;
          v_plan_dtl.line_cd             := i.line_cd;
          v_plan_dtl.no_of_days         := i.no_of_days;
          v_plan_dtl.prem_amt             := i.prem_amt;
          v_plan_dtl.prem_rt             := i.prem_rt;
          v_plan_dtl.tsi_amt             := i.tsi_amt;
          v_plan_dtl.peril_type         := i.peril_type;
          v_plan_dtl.peril_name           := i.peril_name;
          PIPE ROW(v_plan_dtl);
        END LOOP;

    ELSE

     FOR i IN (
             SELECT a.peril_cd, a.aggregate_sw, NVL(a.base_amt,0) base_amt, a.pack_line_cd line_cd,
                    NVL(a.no_of_days,0) no_of_days, NVL(a.prem_amt,0) prem_amt, NVL(a.prem_rt,0) prem_rt,
                    NVL(a.tsi_amt,0) tsi_amt , c.peril_type, c.peril_name
               FROM GIIS_PACK_PLAN_COVER_DTL a, GIPI_PACK_WPOLBAS b , GIIS_PERIL c
              WHERE a.plan_cd = b.plan_cd
                AND a.peril_cd = c.peril_cd
                AND a.pack_line_cd = c.line_cd
                AND a.pack_line_cd = p_pack_line_cd
                AND a.pack_subline_cd = p_pack_subline_cd
                AND b.pack_par_id = p_pack_par_id
              ORDER BY c.peril_type DESC)
        LOOP
          v_plan_dtl.peril_cd             := i.peril_cd;
          v_plan_dtl.aggregate_sw         := i.aggregate_sw;
          v_plan_dtl.base_amt             := i.base_amt;
          v_plan_dtl.line_cd             := i.line_cd;
          v_plan_dtl.no_of_days         := i.no_of_days;
          v_plan_dtl.prem_amt             := i.prem_amt;
          v_plan_dtl.prem_rt             := i.prem_rt;
          v_plan_dtl.tsi_amt             := i.tsi_amt;
          v_plan_dtl.peril_type         := i.peril_type;
          v_plan_dtl.peril_name           := i.peril_name;
          PIPE ROW(v_plan_dtl);
        END LOOP;

    END IF;

  RETURN;

  END get_giis_plan_dtls;

/*
**  Created by   :  Jerome Orio
**  Date Created :  February 07, 2011
**  Reference By : (GIPIS143 - Bill discount/surcharge)
**  Description  : This returns the item peril records of the given par_id and line_cd.
*/
   FUNCTION get_witmperl_list3 (
        p_par_id    gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE
        ) RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.peril_name, b.peril_cd, b.peril_type,
                                a.item_no, a.tsi_amt, a.prem_amt
                           FROM gipi_witmperl a, giis_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND a.par_id = p_par_id
                            AND a.line_cd = p_line_cd
                            --AND a.prem_amt > 0
                       ORDER BY 1, 2)
      LOOP
         v_peril.peril_name     := i.peril_name;
         v_peril.peril_cd       := i.peril_cd;
         v_peril.peril_type     := i.peril_type;
         v_peril.item_no        := i.item_no;
         v_peril.tsi_amt        := i.tsi_amt;
         v_peril.prem_amt       := i.prem_amt;
         PIPE ROW (v_peril);
      END LOOP;
      RETURN;
   END get_witmperl_list3;

/*
**  Created by   :  Jerome Orio
**  Date Created :  February 07, 2011
**  Reference By : (GIPIS143 - Bill discount/surcharge)
**  Description  : This returns the item peril records of the given par_id and line_cd.
*/
   FUNCTION get_witmperl_list4 (
        p_par_id    gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE
        ) RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.peril_name, b.peril_cd, b.peril_type,
                                a.item_no, a.tsi_amt, a.prem_amt
                           FROM gipi_witmperl a, giis_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND a.par_id = p_par_id
                            AND a.line_cd = p_line_cd
                            AND a.item_no = p_item_no
                            AND a.prem_amt > 0
                       ORDER BY 1, 2)
      LOOP
         v_peril.peril_name     := i.peril_name;
         v_peril.peril_cd       := i.peril_cd;
         v_peril.peril_type     := i.peril_type;
         v_peril.item_no        := i.item_no;
         v_peril.tsi_amt        := i.tsi_amt;
         v_peril.prem_amt       := i.prem_amt;
         PIPE ROW (v_peril);
      END LOOP;
      RETURN;
   END get_witmperl_list4;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.21.2011
    **  Reference By     : (GIPIS095 - Package Policy Items)
    **  Description     : Retireve records from gipi_witmperl based on the given parameters
    */
    FUNCTION get_gipi_witmperl_pack_pol (
        p_par_id IN gipi_witmperl.par_id%TYPE,
        p_item_no IN gipi_witmperl.item_no%TYPE)
    RETURN gipi_witmperl_tab PIPELINED
    IS
        v_peril gipi_witmperl_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_witmperl
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_peril.par_id    := i.par_id;
            v_peril.item_no    := i.item_no;

            PIPE ROW(v_peril);
        END LOOP;

        RETURN;
    END get_gipi_witmperl_pack_pol;

    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 04.28.2011
    **  Reference By     : (GIPIS152 - enter co insurer)
    **  Description     : Retrieves sum of tsi_amt and prem_amt
    */
    PROCEDURE get_prem_tsi_sum (
        p_par_id    IN  GIPI_WITMPERL.par_id%TYPE,
        p_prem      OUT GIPI_WITMPERL.prem_amt%TYPE,
        p_tsi       OUT GIPI_WITMPERL.tsi_amt%TYPE
    ) IS
    BEGIN
        SELECT SUM(a.prem_amt) prem, SUM(a.tsi_amt) tsi
          INTO p_prem, p_tsi
            FROM gipi_witmperl a,
                 giis_peril b
        WHERE par_id = p_par_id
              AND a.line_cd = b.line_cd
              AND a.peril_cd = b.peril_cd
              AND b.peril_type = 'B';
    END get_prem_tsi_sum;

    FUNCTION check_peril_exist (p_par_id     GIPI_WITEM.par_id%TYPE)
    RETURN NUMBER
    IS
        v_itmperl_count         NUMBER(3) := 0;
    BEGIN
        FOR A IN (SELECT '1'
                 FROM gipi_witmperl
                WHERE par_id = p_par_id)
        LOOP
            v_itmperl_count := v_itmperl_count + 1;
        END LOOP;
        RETURN v_itmperl_count;
    END check_peril_exist;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 25, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Delete the corresponding gipi_witmperl records
**                 of the given par_id and item_no.
*/

    PROCEDURE del_witmperl_per_item ( p_par_id   IN  GIPI_WITMPERL.par_id%TYPE,
                                      p_item_no  IN  GIPI_WITMPERL.item_no%TYPE)
    IS

    BEGIN
      DELETE FROM gipi_witmperl
            WHERE par_id = p_par_id
              AND item_no = p_item_no;

    END del_witmperl_per_item;

    /*    Date        Author            Description
    *    ==========    ===============    ================================
    *    08.25.2011    mark jm            retrieve records from gipi_witmperl based on given parameters
    */
    FUNCTION get_gipi_witmperl_tg (
        p_par_id IN gipi_witmperl.par_id%TYPE,
        p_item_no IN gipi_witmperl.item_no%TYPE,
        p_peril_name IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_witmperl_tab PIPELINED
    IS
        v_witmperl   gipi_witmperl_type;
    BEGIN
        FOR i IN (
            SELECT a.discount_sw, a.surcharge_sw, a.prt_flag, a.peril_cd,
                   b.peril_name, a.prem_rt, a.tsi_amt, a.prem_amt,
                   NVL (a.no_of_days, 0) no_of_days,
                   NVL (a.base_amt, 0) base_amt, a.aggregate_sw,
                   a.ri_comm_rate, a.ri_comm_amt, a.par_id, a.item_no,
                   a.line_cd, a.ann_tsi_amt, a.ann_prem_amt,
                   b.peril_type, a.tarf_cd, a.comp_rem, b.basc_perl_cd,
                   a.rec_flag
              FROM gipi_witmperl a, giis_peril b
             WHERE a.par_id = p_par_id
               AND a.item_no = NVL (p_item_no, a.item_no)
               AND a.peril_cd = b.peril_cd
               AND b.line_cd = a.line_cd
               AND UPPER(b.peril_name) LIKE NVL(UPPER(p_peril_name), '%%')
               AND UPPER(NVL(a.comp_rem, '***')) LIKE NVL(UPPER(p_remarks), '%%')
          ORDER BY b.peril_name)
        LOOP
            v_witmperl.discount_sw         := i.discount_sw;
            v_witmperl.surcharge_sw     := i.surcharge_sw;
            v_witmperl.prt_flag         := i.prt_flag;
            v_witmperl.peril_cd         := i.peril_cd;
            v_witmperl.peril_name         := i.peril_name;
            v_witmperl.prem_rt             := i.prem_rt;
            v_witmperl.tsi_amt             := i.tsi_amt;
            v_witmperl.prem_amt         := i.prem_amt;
            v_witmperl.no_of_days         := i.no_of_days;
            v_witmperl.base_amt         := i.base_amt;
            v_witmperl.aggregate_sw     := i.aggregate_sw;
            v_witmperl.ri_comm_rate     := i.ri_comm_rate;
            v_witmperl.ri_comm_amt         := i.ri_comm_amt;
            v_witmperl.par_id             := i.par_id;
            v_witmperl.item_no             := i.item_no;
            v_witmperl.line_cd             := i.line_cd;
            v_witmperl.ann_tsi_amt         := i.ann_tsi_amt;
            v_witmperl.ann_prem_amt     := i.ann_prem_amt;
            v_witmperl.peril_type         := i.peril_type;
            v_witmperl.tarf_cd             := i.tarf_cd;
            v_witmperl.comp_rem         := i.comp_rem;
            v_witmperl.basc_perl_cd     := i.basc_perl_cd;
            v_witmperl.rec_flag         := i.rec_flag;
            PIPE ROW (v_witmperl);
        END LOOP;

        RETURN;
    END get_gipi_witmperl_tg;

     /*    Date        Author            Description
    *    ==========    ===============    ================================
    *    06.13.2012    robert            recreates invoice and delete corresponding data on group information both ITEM and GROUP level
    */
    PROCEDURE update_change_in_assured(
        p_par_id     IN NUMBER,
        p_line_cd    IN VARCHAR2,
        p_iss_cd     IN VARCHAR2
    )
    IS
    BEGIN
       UPDATE gipi_witem
          SET group_cd = NULL
        WHERE par_id = p_par_id;

       UPDATE gipi_wgrouped_items
          SET group_cd = NULL
        WHERE par_id = p_par_id;

       FOR a IN (SELECT '1'
                   FROM gipi_witmperl
                  WHERE par_id = p_par_id)
       LOOP
          create_winvoice (0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
       END LOOP;
    END;

    /*FUNCTION check_peril_on_witems (
        p_par_id        IN gipi_witmperl.par_id%TYPE,
        p_pack_par_id   IN gipi_pack_parlist.pack_par_id%TYPE
    ) RETURN VARCHAR2 IS
        v_exist         VARCHAR2(1);
    BEGIN
        IF p_pack_par_id IS NULL THEN
            FOR i IN (
                SELECT item_no FROM gipi_witem
                 WHERE par_id = p_par_id
            ) LOOP
                BEGIN
                    SELECT 'Y' INTO v_exist
                      FROM gipi_witmperl
                     WHERE par_id = p_par_id
                       AND item_no = i.item_no;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_exist := 'N';
                        EXIT;
                END;
            END LOOP;
        ELSE
            FOR h IN (
                SELECT par_id FROM gipi_parlist
                 WHERE pack_par_id = p_pack_par_id
                ) LOOP
                    FOR i IN (
                    SELECT item_no FROM gipi_witem
                     WHERE par_id = h.par_id
                ) LOOP
                    BEGIN
                        SELECT 'Y' INTO v_exist
                          FROM gipi_witmperl
                         WHERE par_id = p_par_id
                           AND item_no = i.item_no;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_exist := 'N';
                            EXIT;
                    END;
                END LOOP;
            END LOOP;
        END IF;
        RETURN v_exist;
    END check_peril_on_witems;*/

	FUNCTION get_items_without_perils (
        p_par_id        IN gipi_witmperl.par_id%TYPE,
        p_pack_par_id   IN gipi_pack_parlist.pack_par_id%TYPE
    ) RETURN noperil_item_list_tab PIPELINED IS
		v_items 		noperil_item_list_type;
	BEGIN
		IF p_pack_par_id IS NOT NULL THEN
			FOR i IN (
				SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
                  FROM gipi_parlist
				 WHERE pack_par_id = p_pack_par_id
			) LOOP
				FOR j IN (
					SELECT item_no FROM gipi_witem a
					 WHERE par_id = i.par_id
				       AND NOT EXISTS(
				   		   SELECT 1 FROM gipi_witmperl
						    WHERE par_id = i.par_id
						      AND item_no = a.item_no
				   )
				) LOOP
					v_items.par_id := i.par_id;
					v_items.item_no := j.item_no;
                    v_items.par_no := i.line_cd||'-'||i.iss_cd||'-'||
                                TO_CHAR(i.par_yy, '09')||'-'||
                                TO_CHAR(i.par_seq_no,'000009')||'-'||
                                TO_CHAR(i.quote_seq_no, '09'); -- nilagyan muna nito para kung sakaling kailangang idisplay sa package
					PIPE ROW(v_items);
				END LOOP;
			END LOOP;
		ELSE
			FOR i IN (
				SELECT a.item_no FROM gipi_witem a
				 WHERE par_id = p_par_id
				   AND NOT EXISTS(
				   		SELECT 1 FROM gipi_witmperl
						 WHERE par_id = p_par_id
						   AND item_no = a.item_no
				   )
			) LOOP
				v_items.par_id := p_par_id;
				v_items.item_no := i.item_no;
				PIPE ROW(v_items);
			END LOOP;
		END IF;
	END get_items_without_perils;

	FUNCTION get_peril_default_tag (
        p_line_cd       GIIS_PERIL.line_cd%TYPE,
        p_subline_cd    GIIS_PERIL.subline_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_tag       VARCHAR2(1) := 'N';
    BEGIN
        FOR P1 IN (SELECT '1'
                     FROM giis_peril
                    WHERE default_tag = 'Y'
                      AND NVL(subline_cd, p_subline_cd) = p_subline_cd
                      AND line_cd = p_line_cd)LOOP
            v_tag := 'Y';
            EXIT;
        END LOOP;
        RETURN v_tag;
    END get_peril_default_tag;

	 /*    Date        Author             Description
    *    ==========    ===============    ================================
    *    10.23.2012    steven             to save the copied item peril
    */
	PROCEDURE SAVE_COPY_PERIL (p_witmperl IN gipi_witmperl%ROWTYPE)
   	IS
    BEGIN
        INSERT INTO gipi_witmperl
                    (par_id,            item_no,            line_cd,           peril_cd,
                     tarf_cd,           prem_rt,            tsi_amt,           prem_amt,
                     ann_tsi_amt,       ann_prem_amt,       rec_flag,          comp_rem,
                     discount_sw,       ri_comm_rate,       ri_comm_amt,       prt_flag,
                     as_charge_sw)
             VALUES (p_witmperl.par_id, 	p_witmperl.item_no, 	p_witmperl.line_cd,     p_witmperl.peril_cd,
                     p_witmperl.tarf_cd,     p_witmperl.prem_rt,      p_witmperl.tsi_amt,     p_witmperl.prem_amt,
                     p_witmperl.ann_tsi_amt, p_witmperl.ann_prem_amt, p_witmperl.rec_flag,    p_witmperl.comp_rem,
                     p_witmperl.discount_sw, p_witmperl.ri_comm_rate, p_witmperl.ri_comm_amt, p_witmperl.prt_flag,
                     p_witmperl.as_charge_sw);
    END SAVE_COPY_PERIL;

	 /*    Date        Author             Description
    *    ==========    ===============    ================================
    *    10.23.2012    steven             copy the tsi_amt,ann_tsi_amt,prem_amt and ann_prem_amt of the item.
    */
	PROCEDURE SAVE_COPY_PERIL_AMT (
        p_par_id            GIPI_WITMPERL.par_id%TYPE,
        p_from_item_no      GIPI_WITMPERL.item_no%TYPE,
        p_to_item_no        GIPI_WITMPERL.item_no%TYPE
    )
   	IS
        v_prem_amt          GIPI_WPOLBAS.prem_amt%TYPE;
        v_ann_prem_amt      GIPI_WPOLBAS.ann_prem_amt%TYPE;
        v_tsi_amt           GIPI_WPOLBAS.tsi_amt%TYPE;
        v_ann_tsi_amt       GIPI_WPOLBAS.ann_tsi_amt%TYPE;
    BEGIN
        FOR AMT IN (SELECT prem_amt, ann_prem_amt, tsi_amt, ann_tsi_amt
                      FROM gipi_witem
                     WHERE par_id = p_par_id
                       AND item_no = p_from_item_no)
        LOOP
            UPDATE gipi_witem
			   SET tsi_amt      = amt.tsi_amt,
				   ann_tsi_amt  = amt.ann_tsi_amt,
				   prem_amt     = amt.prem_amt,
				   ann_prem_amt = amt.ann_prem_amt
			 WHERE par_id = p_par_id
			   AND item_no = p_to_item_no;
			EXIT;
		END LOOP;

        -- marco - 04.10.2013
        -- delete policy level % of tsi deductibles
        FOR d IN(SELECT par_id, item_no, peril_cd, ded_deductible_cd
                   FROM GIPI_WDEDUCTIBLES a,
                        GIIS_DEDUCTIBLE_DESC b
                  WHERE a.par_id = p_par_id
                    AND NVL(a.item_no, 0) = 0
                    AND NVL(a.peril_cd, 0) = 0
                    AND a.ded_line_cd = b.line_cd
                    AND a.ded_subline_cd = b.subline_cd
                    AND a.ded_deductible_cd = b.deductible_cd
                    AND b.ded_type = 'T')
        LOOP
            DELETE
              FROM GIPI_WDEDUCTIBLES
             WHERE par_id = d.par_id
               AND item_no = d.item_no
               AND peril_cd = d.peril_cd
               AND ded_deductible_cd = d.ded_deductible_cd;
        END LOOP;

        -- update amounts in GIPI_WPOLBAS
        FOR item IN(SELECT prem_amt, ann_prem_amt, tsi_amt, ann_tsi_amt
                      FROM GIPI_WITEM
                     WHERE par_id = p_par_id)
        LOOP
            v_prem_amt := NVL(v_prem_amt, 0) + NVL(item.prem_amt, 0);
            v_ann_prem_amt := NVL(v_ann_prem_amt, 0) + NVL(item.ann_prem_amt, 0);
            v_tsi_amt := NVL(v_tsi_amt, 0) + NVL(item.tsi_amt, 0);
            v_ann_tsi_amt :=NVL(v_ann_tsi_amt, 0) + NVL(item.ann_tsi_amt, 0);
        END LOOP;

        UPDATE GIPI_WPOLBAS
           SET prem_amt = NVL(v_prem_amt, 0),
               ann_prem_amt = NVL(v_ann_prem_amt, 0),
               tsi_amt = NVL(v_tsi_amt, 0),
               ann_tsi_amt = NVL(v_ann_tsi_amt, 0)
         WHERE par_id = p_par_id;
        -- end - 04.10.2013

    END SAVE_COPY_PERIL_AMT;

	/*
    **  Created by   : Marco Paolo Rebong
    **  Date Created : November 12, 2012
    **  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
    **  Description  : insert_into_gipi_witmperl program unit
    */
    PROCEDURE insert_into_gipi_witmperl(
        p_par_id            GIPI_WITMPERL.par_id%TYPE,
        p_limit_liability   GIPI_WITMPERL.tsi_amt%TYPE,
        p_line_cd           GIPI_WITMPERL.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_user_id           GIPI_WPOLBAS.user_id%TYPE
    )
    IS
        p_dist_no           NUMBER;
        p_exist             NUMBER;
        v_ann_prem_amt      NUMBER(16, 2) := 0;
        v_ann_tsi_amt       NUMBER(16, 2) := 0;
        v_tot_prem_amt      NUMBER(16, 2) := 0;
        v_tot_tsi_amt       NUMBER(16, 2) := 0;
        v_tot_prem_amt1     NUMBER(16, 2) := 0;
        v_tot_tsi_amt1      NUMBER(16, 2) := 0;
        v_prem_amt          NUMBER(16, 2) := 0;
        v_prem_amt1         NUMBER(16, 2) := 0;
        v_tsi_amt1          NUMBER(16, 2) := 0;
        v_tsi_amt           NUMBER(16, 2) := 0;
        v_exist             VARCHAR2(1) := 'N';
        v_exist1            VARCHAR2(1) := 'N';
        v_switch            VARCHAR2(1) := 'N';
        tsi_amt_tag         VARCHAR2(1) := 'N';
        v_ctr               NUMBER := 0;
        v_cnt               NUMBER := 0;
        v_cnt1              NUMBER := 0;

        v_peril             GIPI_WITMPERL.peril_cd%TYPE;
    BEGIN
        GIPI_WCOMM_INV_PERILS_PKG.del_gipi_wcomm_inv_perils1(p_par_id);
        GIPI_WCOMM_INVOICES_PKG.del_gipi_wcomm_invoices_1(p_par_id);
        GIPI_WINVPERL_PKG.del_gipi_winvperl_1(p_par_id);
        GIPI_WINV_TAX_PKG.del_gipi_winv_tax_1(p_par_id);
        GIPI_WINSTALLMENT_PKG.del_gipi_winstallment_1(p_par_id);
        GIPI_WINVOICE_PKG.del_gipi_winvoice1(p_par_id);

        FOR b1 IN(SELECT dist_no
                    FROM GIUW_POL_DIST
                   WHERE par_id = p_par_id)
        LOOP
            GIUW_ITEMPERILDS_DTL_PKG.del_giuw_itemperilds_dtl(b1.dist_no);
            GIUW_WPERILDS_DTL_PKG.del_giuw_wperilds_dtl(b1.dist_no);
            GIUW_WITEMDS_DTL_PKG.del_giuw_witemds_dtl(b1.dist_no);
            GIUW_WPOLICYDS_DTL_PKG.del_giuw_wpolicyds_dtl(b1.dist_no);
            GIUW_WITEMPERILDS_PKG.del_giuw_witemperilds(b1.dist_no);
            GIUW_WPERILDS_PKG.del_giuw_wperilds(b1.dist_no);
            GIUW_WITEMDS_PKG.del_giuw_witemds(b1.dist_no);
            GIUW_WPOLICYDS_PKG.del_giuw_wpolicyds(b1.dist_no);

            FOR c1 IN(SELECT frps_seq_no,
                             frps_yy
                        FROM GIRI_WDISTFRPS
                       WHERE dist_no = b1.dist_no)
            LOOP
                GIRI_WDISTFRPS_PKG.del_giri_wdistfrps1(c1.frps_seq_no, c1.frps_yy);
            END LOOP;

            GIUW_POL_DIST_PKG.del_giuw_pol_dist(b1.dist_no);

            p_dist_no := b1.dist_no;
        END LOOP;

        GIPI_WITMPERL_PKG.del_gipi_witmperl2(p_par_id);

        FOR cnt IN(SELECT COUNT(*) cnt
                     FROM GIPI_WOPEN_PERIL
                    WHERE par_id = p_par_id)
        LOOP
            v_cnt := cnt.cnt;
        END LOOP;

        FOR cnt1 IN(SELECT COUNT(*) cnt
                      FROM GIPI_WOPEN_PERIL
                     WHERE par_id = p_par_id
                       AND prem_rate IS NOT NULL)
        LOOP
            v_cnt1 := cnt1.cnt;
        END LOOP;

        FOR a1 IN(SELECT peril_cd, prem_rate
                    FROM GIPI_WOPEN_PERIL
                   WHERE par_id = p_par_id)
        LOOP
            FOR late IN(SELECT a.policy_id, a.line_cd
                          FROM GIPI_POLBASIC a,
                               GIPI_WPOLBAS b
                         WHERE a.line_cd = b.line_cd
                           AND a.subline_cd = b.subline_cd
                           AND a.iss_cd = b.iss_cd
                           AND a.issue_yy = b.issue_yy
                           AND a.pol_seq_no = b.pol_seq_no
                           AND b.par_id = p_par_id
                         ORDER BY a.eff_date DESC)
            LOOP
                FOR ann IN(SELECT ann_tsi_amt, ann_prem_amt, peril_cd, line_cd
                             FROM GIPI_ITMPERIL
                            WHERE policy_id = late.policy_id
                              AND line_cd = late.line_cd)
                LOOP
                    FOR perl IN(SELECT peril_type
                                  FROM GIIS_PERIL
                                 WHERE line_cd = ann.line_cd
                                   AND peril_cd = ann.peril_cd)
                    LOOP
                        IF ann.peril_cd = a1.peril_cd THEN
                            v_exist1 := 'Y';
                            v_ann_prem_amt := ann.ann_prem_amt;
                            IF perl.peril_type = 'B' THEN
                                v_ann_tsi_amt  := ann.ann_tsi_amt;
                            END IF;
                        END IF;

                        /* FOR l IN(SELECT peril_cd
                                   FROM GIPI_WITMPERL
                                  WHERE par_id = p_par_id)
                        LOOP
                            IF l.peril_cd = ann.peril_cd THEN
                                v_switch := 'Y';
                                EXIT;
                            END IF;
                        END LOOP;

                        IF v_switch = 'N' THEN
                            v_tot_prem_amt1 := NVL(v_tot_prem_amt1, 0) + NVL(ann.ann_prem_amt, 0);
                            IF perl.peril_type = 'B' THEN
                                v_tot_tsi_amt1 := NVL(v_tot_tsi_amt1, 0)  + NVL(ann.ann_tsi_amt, 0);
                            END IF;
                        ELSE
                            v_switch := 'N';
                        END IF; */
                    END LOOP;
                END LOOP;
            END LOOP;

            IF a1.prem_rate IS NOT NULL THEN
                v_tsi_amt := p_limit_liability;
            ELSE
                IF v_cnt = 1 THEN
                    v_tsi_amt := p_limit_liability;
                ELSIF v_cnt1 = 0 THEN
                    IF tsi_amt_tag = 'N' THEN
                        v_tsi_amt := p_limit_liability;
                        tsi_amt_tag := 'Y';
                    ELSE
                        v_tsi_amt := 0;
                    END IF;
                ELSE
                    v_tsi_amt := 0;
                END IF;
            END IF;

            IF v_exist1 = 'Y' THEN
                v_prem_amt := ROUND(NVL(a1.prem_rate,0) * NVL(v_tsi_amt,0) / 100,2);
                v_ann_prem_amt := NVL(v_ann_prem_amt,0) + NVL(v_prem_amt,0);
                v_ann_tsi_amt := NVL(v_ann_tsi_amt,0) + NVL(v_tsi_amt,0);
                v_tot_prem_amt := NVL(v_tot_prem_amt,0) + NVL(v_ann_prem_amt,0);
                v_tot_tsi_amt := NVL(v_tot_tsi_amt,0)  + NVL(v_ann_tsi_amt,0);
                v_exist1 := 'N';
            ELSE
                v_prem_amt := ROUND(NVL(a1.prem_rate,0) * NVL(v_tsi_amt,0) / 100,2);
                v_ann_prem_amt := NVL(v_prem_amt,0);
                v_ann_tsi_amt := NVL(v_tsi_amt,0);
                v_tot_prem_amt := NVL(v_tot_prem_amt,0) + v_ann_prem_amt;
                v_tot_tsi_amt := NVL(v_tot_tsi_amt,0)  + v_ann_tsi_amt;
            END IF;

            IF v_ann_tsi_amt > 99999999999999.99 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#The computed annual TSI amount exceeds the maximum allowable value. Please enter a different TSI amount.');
            END IF;

            IF v_prem_amt > 9999999999.99 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#The computed premium amount exceeds the maximum allowable value. Please enter a different Premium Rate or different TSI amount.');
            END IF;

            IF v_ann_prem_amt > 9999999999.99 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#The computed annual premium amount exceeds the maximum allowable value. Please enter a different Premium Rate or different TSI amount.');
            END IF;

            IF v_ann_prem_amt < -9999999999.99 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#The computed annual premium amount is beyond the minimum allowable value. Please enter a different Premium Rate or different TSI amount.');
            END IF;

            INSERT INTO GIPI_WITMPERL
                   (par_id, item_no, line_cd, peril_cd, discount_sw, prem_rt,
                    tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt)
            VALUES (p_par_id, 1, p_line_cd, a1.peril_cd, 'N' , a1.prem_rate,
                    v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt);

            IF a1.prem_rate IS NOT NULL THEN
                v_exist := 'Y';
            END IF;

            v_prem_amt := 0;
            v_ann_prem_amt := 0;
            v_ann_tsi_amt := 0;
            v_tot_prem_amt := 0;
            v_tot_tsi_amt := 0;
        END LOOP;

        BEGIN
            v_tot_tsi_amt1 := 0;
            v_tot_prem_amt1 := 0;

            FOR i IN(SELECT tsi_amt,
                            prem_amt,
                            a.peril_cd,
                            b.peril_type
                       FROM GIPI_ITMPERIL a,
                            GIIS_PERIL b
                      WHERE a.peril_cd = b.peril_cd
                        AND a.line_cd = b.line_cd
                        AND policy_id IN (SELECT a.policy_id
                                           FROM GIPI_POLBASIC a,
                                                GIPI_WPOLBAS b
                                          WHERE a.line_cd = b.line_cd
                                            AND a.subline_cd = b.subline_cd
                                            AND a.iss_cd = b.iss_cd
                                            AND a.issue_yy = b.issue_yy
                                            AND a.pol_seq_no = b.pol_seq_no
                                            AND b.par_id = p_par_id))
            LOOP
                v_tot_prem_amt1 := v_tot_prem_amt1 + NVL(i.prem_amt, 0);
                v_peril := 0;
                FOR w IN (SELECT peril_cd
                            FROM GIPI_WITMPERL
                           WHERE par_id = p_par_id
                             AND line_cd = p_line_cd
                             AND peril_cd IN (SELECT peril_cd
                                                FROM GIPI_ITMPERIL
                                               WHERE policy_id IN (SELECT a.policy_id
                                                                     FROM GIPI_POLBASIC a,
                                                                          GIPI_WPOLBAS b
                                                                    WHERE a.line_cd = b.line_cd
                                                                      AND a.subline_cd = b.subline_cd
                                                                      AND a.iss_cd = b.iss_cd
                                                                      AND a.issue_yy = b.issue_yy
                                                                      AND a.pol_seq_no = b.pol_seq_no
                                                                      AND b.par_id = p_par_id)))
                LOOP
                    v_peril := 1;
                    EXIT;
                END LOOP;

                IF v_peril = 1 THEN
                    FOR w IN(SELECT peril_cd
                               FROM GIPI_WITMPERL
                              WHERE par_id = p_par_id
                                AND line_cd = p_line_cd)
                    LOOP
                        IF i.peril_type = 'B' AND w.peril_cd = i.peril_cd THEN
                            v_tot_tsi_amt1 := v_tot_tsi_amt1 + NVL(i.tsi_amt, 0);
                        END IF;
                    END LOOP;
                ELSE
                    IF i.peril_type = 'B' THEN
                        v_tot_tsi_amt1 := v_tot_tsi_amt1 + NVL(i.tsi_amt, 0);
                    END IF;
                END IF;

--                FOR w IN(SELECT peril_cd
--                           FROM GIPI_WITMPERL
--                          WHERE par_id = p_par_id
--                            AND line_cd = p_line_cd)
--                LOOP
--                    IF i.peril_type = 'B' AND w.peril_cd = i.peril_cd THEN
--                        v_tot_tsi_amt1 := v_tot_tsi_amt1 + NVL(i.tsi_amt, 0);
--                    ELSIF i.peril_type = 'B' and w.peril_cd != i.peril_cd THEN
--                        v_tot_tsi_amt1 := v_tot_tsi_amt1 + NVL(i.tsi_amt, 0);
--                    END IF;
--                END LOOP;
            END LOOP;
        END;

        FOR item IN(SELECT item_no, SUM(prem_amt) prem_amt, SUM(ann_prem_amt) ann_prem_amt
                      FROM GIPI_WITMPERL
                     WHERE par_id = p_par_id
                     GROUP BY item_no)
        LOOP
            FOR tsi IN(SELECT SUM(a.tsi_amt) tsi, SUM(a.ann_tsi_amt) ann_tsi
                         FROM GIPI_WITMPERL a,
                              GIIS_PERIL b
                        WHERE a.par_id = p_par_id
                          AND a.item_no = item.item_no
                          AND a.peril_cd = b.peril_cd
                          AND a.line_cd = b.line_cd
                          AND b.peril_type = 'B')
            LOOP
                v_tot_tsi_amt1 := NVL(v_tot_tsi_amt1, 0) + NVL(tsi.ann_tsi, 0);
                v_tsi_amt1 := tsi.tsi;
                EXIT;
            END LOOP;
            v_tot_prem_amt1 := NVL(v_tot_prem_amt1,0) + NVL(item.ann_prem_amt,0);

            UPDATE GIPI_WITEM
               SET prem_amt = item.prem_amt,
                   tsi_amt = v_tsi_amt1,
                   ann_prem_amt = v_tot_prem_amt1,
                   ann_tsi_amt = v_tot_tsi_amt1
             WHERE par_id = p_par_id
               AND item_no = item.item_no;
            EXIT;
        END LOOP;

        IF v_exist = 'Y' THEN
            CREATE_WINVOICE(0, 0, 0, p_par_id, p_line_cd, p_iss_cd);

            CREATE_DISTRIBUTION_GIPIS078(p_par_id, p_dist_no, p_user_id);

            FOR a IN(SELECT par_id, par_status
                       FROM GIPI_PARLIST
                      WHERE par_id = p_par_id
                        FOR UPDATE OF par_id, par_status)
            LOOP
                UPDATE GIPI_PARLIST
                   SET par_status = 5
                 WHERE par_id = A.par_id;
                EXIT;
            END LOOP;
        ELSE
            FOR a IN(SELECT par_id, par_status
                       FROM GIPI_PARLIST
                      WHERE par_id = p_par_id
                        FOR UPDATE OF par_id, par_status)
            LOOP
                UPDATE GIPI_PARLIST
                   SET par_status = 6
                 WHERE par_id =  A.par_id;
                EXIT;
            END LOOP;
        END IF;
    END;

END gipi_witmperl_pkg;
/


