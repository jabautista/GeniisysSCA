DROP PROCEDURE CPI.AUTO_DIST_NET_RET_2;

CREATE OR REPLACE PROCEDURE CPI.AUTO_DIST_NET_RET_2 (
   p_dist_no             giuw_pol_dist.dist_no%TYPE,
   p_new_policy_id   OUT NUMBER)
/**
 created by: irwin tabisora
 date: 8.23.2012
 description: procedure for giexs004
**/
IS
   v_dist_seq             NUMBER := 0;
   v_share_cd             NUMBER;
   v_dist_spct            NUMBER := 100;                 -- 100% Net Retention
   v_dist_grp             NUMBER := 1;                                      --
   v_item_dist_spct       NUMBER;
   v_itmperil_dist_spct   NUMBER;
BEGIN
   -- DELETE RECORDS
   DELETE giuw_wpolicyds
    WHERE dist_no = p_dist_no;

   DELETE giuw_policyds
    WHERE dist_no = p_dist_no;

   DELETE giuw_policyds_dtl
    WHERE dist_no = p_dist_no;

   DELETE giuw_itemds
    WHERE dist_no = p_dist_no;

   DELETE giuw_itemds_dtl
    WHERE dist_no = p_dist_no;

   DELETE giuw_itemperilds
    WHERE dist_no = p_dist_no;

   DELETE giuw_itemperilds_dtl
    WHERE dist_no = p_dist_no;

   DELETE giuw_perilds
    WHERE dist_no = p_dist_no;

   DELETE giuw_perilds_dtl
    WHERE dist_no = p_dist_no;

   v_share_cd := giisp.n ('NET_RETENTION');

   FOR dista
      IN (  SELECT SUM (NVL (DECODE (c.peril_type, 'B', a.tsi_amt, 0), 0))
                      tsi_amt,
                   SUM (NVL (a.prem_amt, 0)) prem_amt--, SUM(NVL(DECODE(C.PERIL_TYPE,'B',A.ANN_TSI_AMT,0),0) ) ANN_TSI_AMT
                   ,
                   b.item_grp,
                   a.line_cd
              FROM gipi_itmperil a, gipi_item b, giis_peril c
             WHERE     1 = 1
                   AND a.policy_id = b.policy_id
                   AND a.item_no = b.item_no
                   AND a.peril_cd = c.peril_cd
                   AND a.line_cd = c.line_cd
                   AND a.policy_id = p_new_policy_id
          GROUP BY b.item_grp, a.line_cd)
   LOOP
      v_dist_seq := v_dist_seq + 1;

      -- POPULATE GIUW_POLICYDS

      INSERT INTO giuw_policyds (dist_no,
                                 dist_seq_no,
                                 tsi_amt,
                                 prem_amt,
                                 item_grp,
                                 ann_tsi_amt)
           VALUES (p_dist_no,
                   v_dist_seq,
                   dista.tsi_amt,
                   dista.prem_amt,
                   dista.item_grp,
                   dista.tsi_amt);

      -- POPULATE GIUW_POLICYDS_DTL
      INSERT INTO giuw_policyds_dtl (dist_no,
                                     dist_seq_no,
                                     line_cd,
                                     share_cd,
                                     dist_tsi,
                                     dist_prem,
                                     dist_spct,
                                     dist_spct1,
                                     ann_dist_spct,
                                     ann_dist_tsi,
                                     dist_grp)
           VALUES (p_dist_no,
                   v_dist_seq,
                   dista.line_cd,
                   v_share_cd,
                   dista.tsi_amt,
                   dista.prem_amt,
                   v_dist_spct,
                   v_dist_spct,
                   v_dist_spct,
                   dista.tsi_amt,
                   v_dist_grp);

      -- POPULATE GIUW_ITEMDS - GIUW_ITEMDS_DTL
      FOR distb
         IN (SELECT a.item_no, a.tsi_amt, a.prem_amt
               FROM gipi_item a
              WHERE     1 = 1
                    AND policy_id = p_new_policy_id
                    AND a.item_grp = dista.item_grp)
      LOOP
         -- GIUW_ITEMDS
         INSERT INTO giuw_itemds (dist_no,
                                  dist_seq_no,
                                  item_no,
                                  tsi_amt,
                                  prem_amt,
                                  ann_tsi_amt)
              VALUES (p_dist_no,
                      v_dist_seq,
                      distb.item_no,
                      distb.tsi_amt,
                      distb.prem_amt,
                      distb.tsi_amt);

         -- GIUW_ITEMDS_DTL
         INSERT INTO giuw_itemds_dtl (dist_no,
                                      dist_seq_no,
                                      item_no,
                                      line_cd,
                                      share_cd,
                                      dist_spct,
                                      dist_tsi,
                                      dist_prem,
                                      ann_dist_spct,
                                      ann_dist_tsi,
                                      dist_grp)
              VALUES (p_dist_no,
                      v_dist_seq,
                      distb.item_no,
                      dista.line_cd,
                      v_share_cd,
                      v_item_dist_spct,
                      distb.tsi_amt,
                      distb.prem_amt,
                      v_dist_spct,
                      distb.tsi_amt,
                      1);

         -- POPULATE GIUW_ITEMPERILDS - GIUW_ITEMPERILDS_DTL
         FOR distc
            IN (SELECT peril_cd, tsi_amt, prem_amt
                  FROM gipi_itmperil b
                 WHERE     1 = 1
                       AND b.policy_id = p_new_policy_id
                       AND b.item_no = distb.item_no)
         LOOP
            -- GIUW_ITEMPERILDS
            INSERT INTO giuw_itemperilds (dist_no,
                                          dist_seq_no,
                                          item_no,
                                          peril_cd,
                                          line_cd,
                                          tsi_amt,
                                          prem_amt,
                                          ann_tsi_amt)
                 VALUES (p_dist_no,
                         v_dist_seq,
                         distb.item_no,
                         distc.peril_cd,
                         dista.line_cd,
                         distc.tsi_amt,
                         distc.prem_amt,
                         distc.tsi_amt);

            -- GIUW_ITEMPERILDS_DTL
            INSERT INTO giuw_itemperilds_dtl (dist_no,
                                              dist_seq_no,
                                              item_no,
                                              peril_cd,
                                              line_cd,
                                              share_cd,
                                              dist_tsi,
                                              dist_prem,
                                              dist_spct,
                                              ann_dist_spct,
                                              ann_dist_tsi,
                                              dist_grp)
                 VALUES (p_dist_no,
                         v_dist_seq,
                         distb.item_no,
                         distc.peril_cd,
                         dista.line_cd,
                         v_share_cd,
                         distc.tsi_amt,
                         distc.prem_amt,
                         v_dist_spct,
                         v_dist_spct,
                         distc.tsi_amt,
                         1);
         END LOOP;
      END LOOP;
	  
	  -- POPULATE GIUW_PERILDS - GIUW_PERILDS_DTL
      FOR distd IN (SELECT   b.peril_cd, SUM (b.prem_amt) prem_amt,
                             SUM (b.tsi_amt) tsi_amt
                        FROM gipi_item a, gipi_itmperil b
                       WHERE 1 = 1
                         AND a.policy_id = b.policy_id
                         AND a.item_no = b.item_no
                         AND a.item_grp = dista.item_grp
                         AND b.policy_id = p_new_policy_id
                    GROUP BY peril_cd)
      LOOP
         INSERT INTO giuw_perilds
                     (dist_no, dist_seq_no, peril_cd,
                      line_cd, tsi_amt, prem_amt,
                      ann_tsi_amt
                     )
              VALUES (p_dist_no, v_dist_seq, distd.peril_cd,
                      dista.line_cd, distd.tsi_amt, distd.prem_amt,
                      distd.tsi_amt
                     );

         INSERT INTO giuw_perilds_dtl
                     (dist_no, dist_seq_no, peril_cd,
                      line_cd, share_cd, dist_tsi,
                      dist_prem, dist_spct, ann_dist_spct,
                      ann_dist_tsi, dist_grp
                     )
              VALUES (p_dist_no, v_dist_seq, distd.peril_cd,
                      dista.line_cd, v_share_cd, distd.tsi_amt,
                      distd.prem_amt, v_dist_spct, v_dist_spct,
                      distd.tsi_amt, 1
                     );
      END LOOP;
   END LOOP;
END;
/


