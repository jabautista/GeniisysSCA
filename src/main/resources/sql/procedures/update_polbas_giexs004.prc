DROP PROCEDURE CPI.UPDATE_POLBAS_GIEXS004;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_POLBAS_GIEXS004(p_new_par_id gipi_wgrouped_items.par_id%TYPE)
IS
  v_no_itm        gipi_wpolbas.no_of_items%TYPE;
  v_tsi_amt       gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt      gipi_wpolbas.prem_amt%TYPE;
  v_ann_prem_amt  gipi_wpolbas.prem_amt%TYPE;
  v_ann_prem_amt1 gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt   gipi_wpolbas.ann_tsi_amt%TYPE;
  v_tsi_amt1      gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt1     gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt1  gipi_wpolbas.ann_tsi_amt%TYPE;

  /*FOR GPA*/
  v_ann_prem_amt2 gipi_wpolbas.prem_amt%TYPE;
  v_tsi_amt2      gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt2     gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt2  gipi_wpolbas.ann_tsi_amt%TYPE;
  /*END GPA*/
  v_dep_pct                NUMBER(3,2) := Giisp.n('MC_DEP_PCT')/100;
BEGIN
  FOR item IN (
       SELECT item_no, currency_rt
         FROM gipi_witem
        WHERE par_id = p_new_par_id
        ORDER BY item_no)
  LOOP
    v_prem_amt1 := 0;
    v_tsi_amt1  := 0;
    v_ann_tsi_amt1 := 0;
    v_ann_prem_amt1 := 0; --joanne 07.02.14
    /*FOR GPA*/
    FOR grp_item IN (
           SELECT grouped_item_no
             FROM gipi_wgrouped_items
            WHERE par_id  = p_new_par_id
              AND item_no = item.item_no
            ORDER BY item_no)
      LOOP
        v_prem_amt2     := 0;
        v_tsi_amt2      := 0;
        v_ann_tsi_amt2  := 0;
        v_ann_prem_amt2 := 0;
        FOR grp_peril IN (
            SELECT a.item_no, a.tsi_amt, a.prem_amt, b.line_cd line_cd, b.peril_cd peril_cd,
                 NVL(a.ann_prem_amt, a.prem_amt) ann_prem_amt, b.peril_type,a.prem_rt
              FROM gipi_witmperl_grouped a, giis_peril b
             WHERE a.line_cd         = b.line_cd
               AND a.peril_cd        = b.peril_cd
               AND a.grouped_item_no = grp_item.grouped_item_no
               AND a.item_no         = item.item_no
               AND par_id            = p_new_par_id)
          LOOP
          v_prem_amt2     := NVL(v_prem_amt2,0) + grp_peril.prem_amt;
          v_ann_prem_amt2 := NVL(v_ann_prem_amt2,0) + grp_peril.ann_prem_amt;
          IF grp_peril.peril_type = 'B' THEN
             v_tsi_amt2      := NVL(v_tsi_amt2,0)  + grp_peril.tsi_amt;
             v_ann_tsi_amt2  := NVL(v_ann_tsi_amt2,0)  + grp_peril.tsi_amt;
          END IF;
          END LOOP;
          IF NVL(v_ann_tsi_amt2,0) = 0 THEN
             DELETE FROM gipi_wgrp_items_beneficiary -- added by MGM to resolve SR 20770 
                   WHERE item_no = item.item_no
                     AND grouped_item_no = grp_item.grouped_item_no
                     AND par_id = p_new_par_id;

              DELETE FROM gipi_wgrouped_items
                    WHERE item_no         = item.item_no
                      AND grouped_item_no = grp_item.grouped_item_no
                      AND par_id          = p_new_par_id;
            ELSE
                UPDATE gipi_wgrouped_items
                 SET prem_amt     = v_prem_amt2,
                     ann_prem_amt = v_ann_prem_amt2,
                     tsi_amt      = v_tsi_amt2,
                     ann_tsi_amt  = v_ann_tsi_amt2
               WHERE item_no         = item.item_no
                 AND grouped_item_no = grp_item.grouped_item_no
                 AND par_id          = p_new_par_id;
             END IF;
            --forms_ddl('COMMIT');
      END LOOP;
    /*END GPA*/


      FOR peril IN (
        SELECT a.item_no, a.tsi_amt, a.prem_amt, b.line_cd line_cd, b.peril_cd peril_cd,
             NVL(a.ann_prem_amt, a.prem_amt) ann_prem_amt, b.peril_type,a.prem_rt
          FROM gipi_witmperl a, giis_peril b
         WHERE a.line_cd  = b.line_cd
           AND a.peril_cd = b.peril_cd
           AND a.item_no  = item.item_no
           AND par_id     = p_new_par_id)
      LOOP
      v_prem_amt1     := NVL(v_prem_amt1,0) + peril.prem_amt;
      v_ann_prem_amt1 := NVL(v_ann_prem_amt1,0) + peril.ann_prem_amt;
      IF peril.peril_type = 'B' THEN
         v_tsi_amt1      := NVL(v_tsi_amt1,0)  + peril.tsi_amt;
         v_ann_tsi_amt1  := NVL(v_ann_tsi_amt1,0)  + peril.tsi_amt;
      END IF;
      /*FOR a IN (
        SELECT '1'
                  FROM giex_dep_perl b
               WHERE b.line_cd  = peril.line_cd
                 AND b.peril_cd = peril.peril_cd
                 AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
          LOOP
              v_tsi_amt1      := v_tsi_amt1 - (v_tsi_amt1*v_dep_pct);
                v_ann_tsi_amt1  := v_tsi_amt1 - (v_tsi_amt1*v_dep_pct);
                v_prem_amt1     := v_tsi_amt1 * (peril.prem_rt/100);
                v_ann_prem_amt1 := v_tsi_amt1 * (peril.prem_rt/100);
            END LOOP;*/
      END LOOP;
      IF NVL(v_ann_tsi_amt1,0) = 0 THEN
          DELETE FROM gipi_witem
                WHERE item_no = item.item_no
                  AND par_id  = p_new_par_id;
      ELSE
          UPDATE gipi_witem
             SET prem_amt     = v_prem_amt1,
                 ann_prem_amt = v_ann_prem_amt1,
                 tsi_amt      = v_tsi_amt1,
                 ann_tsi_amt  = v_ann_tsi_amt1
           WHERE item_no = item.item_no
             AND par_id  = p_new_par_id;
         END IF;
     v_no_itm      := NVL(v_no_itm,0)   + 1;
     v_prem_amt    := NVL(v_prem_amt,0) + (v_prem_amt1 * item.currency_rt);
     v_ann_prem_amt:= NVL(v_ann_prem_amt,0) + (v_ann_prem_amt1 * item.currency_rt);
     v_tsi_amt     := NVL(v_tsi_amt,0) + (v_tsi_amt1 * item.currency_rt);
     v_ann_tsi_amt := NVL(v_ann_tsi_amt,0) + (v_ann_tsi_amt1 * item.currency_rt);
     --message(v_tsi_amt||'-'||variables.new_par_id);pause;
  END LOOP;
  --forms_ddl('COMMIT');
  UPDATE gipi_wpolbas
     SET prem_amt     = v_prem_amt,
         tsi_amt      = v_tsi_amt,
         no_of_items  = v_no_itm,
         ann_tsi_amt  = v_ann_tsi_amt,
         ann_prem_amt = v_ann_prem_amt
   WHERE par_id  = p_new_par_id;

   --forms_ddl('COMMIT');
   --message(v_tsi_amt);pause;
END;
/


