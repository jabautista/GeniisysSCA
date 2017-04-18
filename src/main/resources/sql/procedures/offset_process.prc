DROP PROCEDURE CPI.OFFSET_PROCESS;

CREATE OR REPLACE PROCEDURE CPI.OFFSET_PROCESS(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                         p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                         p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE)
IS
  v_poldtl_diff         giuw_policyds_dtl.dist_prem%type;
  v_item_diff           giuw_policyds_dtl.dist_prem%type;
  v_itemdtl_diff        giuw_policyds_dtl.dist_prem%type;
  v_itemdtl_diff1       giuw_policyds_dtl.dist_prem%type;
  v_itemdtl_diff2       giuw_policyds_dtl.dist_prem%type;
  v_iperl_diff          giuw_policyds_dtl.dist_prem%type;
  v_iperldtl_diff       giuw_policyds_dtl.dist_prem%type;
  v_iperldtl_diff1      giuw_policyds_dtl.dist_prem%type;
  v_iperldtl_diff2      giuw_policyds_dtl.dist_prem%type;
BEGIN
  FOR POL1 IN
      (SELECT dist_seq_no, prem_amt
         FROM giuw_policyds 
        WHERE dist_no = p_var_v_neg_distno
      )LOOP
       -- adjust at policy level 
       FOR POL2 IN (SELECT prem_amt
                      FROM giuw_wpolicyds
                     WHERE dist_seq_no = pol1.dist_seq_no
                       AND dist_no = p_dist_no
           )LOOP
           v_poldtl_diff := 0;
           FOR POLDTL2 IN
              (SELECT sum(dist_prem) prem
                FROM giuw_wpolicyds_dtl
               WHERE dist_no = p_dist_no
                 AND dist_seq_no = pol1.dist_seq_no
              )LOOP
              IF pol2.prem_amt != poldtl2.prem THEN
                 v_poldtl_diff := pol2.prem_amt - poldtl2.prem;
                 FOR A1 IN(SELECT MIN(share_cd) code
                             FROM giuw_wpolicyds_dtl
                            WHERE dist_no = p_dist_no
                                 AND dist_seq_no = pol1.dist_seq_no
                    )LOOP
                    UPDATE giuw_wpolicyds_dtl
                       SET dist_prem = dist_prem + v_poldtl_diff
                     WHERE dist_no = p_dist_no
                       AND dist_seq_no = pol1.dist_seq_no
                       AND share_cd = a1.code;
                    UPDATE giuw_wpolicyds_dtl
                       SET dist_prem = dist_prem - v_poldtl_diff
                     WHERE dist_no = p_temp_distno
                       AND dist_seq_no = pol1.dist_seq_no
                       AND share_cd = a1.code;
                    EXIT;
                 END LOOP;
              END IF;
          END LOOP;
          /* update at item level */
          FOR ITEM1 IN 
              (SELECT SUM(prem_amt) prem
                 FROM giuw_witemds
                WHERE dist_no = p_dist_no
                 AND dist_seq_no = pol1.dist_seq_no
              )LOOP
              FOR ITEM2 IN
                  (SELECT SUM(prem_amt) prem
                     FROM giuw_witemds
                    WHERE dist_no = p_temp_distno
                      AND dist_seq_no = pol1.dist_seq_no
                  )LOOP 
                  IF pol1.prem_amt = item1.prem + item2.prem  AND
                     item1.prem != pol2.prem_amt THEN
                     v_item_diff := pol2.prem_amt - item1.prem;
                     FOR A1 IN (SELECT MIN(item_no) item_no
                                  FROM giuw_witemds
                                 WHERE dist_no = p_dist_no
                                   AND dist_seq_no = pol1.dist_seq_no
                         )LOOP
                         UPDATE giuw_witemds
                            SET prem_amt = prem_amt + v_item_diff
                          WHERE dist_no = p_dist_no
                            AND dist_seq_no = pol1.dist_seq_no
                            AND item_no = a1.item_no;
                         UPDATE giuw_witemds
                            SET prem_amt = prem_amt - v_item_diff
                          WHERE dist_no = p_temp_distno
                            AND dist_seq_no = pol1.dist_seq_no
                            AND item_no = a1.item_no;
                         EXIT;
                     END LOOP;
                  END IF;
              END LOOP;
          END LOOP;
          /* end of update at item level*/
      END LOOP;
      /* update at item detail level */
      FOR ITEM3 IN 
          (SELECT item_no, prem_amt
             FROM giuw_witemds
            WHERE dist_no = p_dist_no
              AND dist_seq_no = pol1.dist_seq_no
          )LOOP
          v_itemdtl_diff  := 0;
          v_itemdtl_diff1 := 0;
          v_itemdtl_diff2 := 0;
          FOR ITEMDTL1 IN
              (SELECT SUM(dist_prem) prem 
                 FROM giuw_witemds_dtl 
                WHERE dist_no = p_dist_no
                  AND dist_seq_no = pol1.dist_seq_no
                  AND item_no = item3.item_no
          )LOOP                                         
          IF item3.prem_amt != itemdtl1.prem THEN
             v_itemdtl_diff := item3.prem_amt - itemdtl1.prem;
             FOR POLDTL3 IN
                (SELECT share_cd, dist_prem 
                   FROM giuw_wpolicyds_dtl
                  WHERE dist_no = p_dist_no
                    AND dist_seq_no = pol1.dist_seq_no
                )LOOP
                FOR ITEMDTL2 IN
                    (SELECT SUM(dist_prem) prem
                      FROM giuw_witemds_dtl
                     WHERE dist_no = p_dist_no
                       AND dist_seq_no = pol1.dist_seq_no
                       AND share_cd = poldtl3.share_cd)LOOP
                    IF (poldtl3.dist_prem > itemdtl2.prem AND
                       v_itemdtl_diff > 0) OR 
                       ( poldtl3.dist_prem < itemdtl2.prem AND
                       v_itemdtl_diff < 0) THEN
                       v_itemdtl_diff1 := poldtl3.dist_prem - itemdtl2.prem ;
                       IF v_itemdtl_diff1 > v_itemdtl_diff THEN
                          v_itemdtl_diff2 := v_itemdtl_diff;
                          v_itemdtl_diff := 0;
                       ELSIF v_itemdtl_diff >= v_itemdtl_diff1 THEN
                          v_itemdtl_diff2 := v_itemdtl_diff1;
                          v_itemdtl_diff := v_itemdtl_diff - v_itemdtl_diff1;
                       END IF;         
                       UPDATE giuw_witemds_dtl
                          SET dist_prem = dist_prem + v_itemdtl_diff2
                        WHERE dist_no = p_dist_no
                          AND dist_seq_no = pol1.dist_seq_no
                          AND share_cd = poldtl3.share_cd
                          AND item_no   = item3.item_no;
                       UPDATE giuw_witemds_dtl
                          SET dist_prem = dist_prem - v_itemdtl_diff2
                        WHERE dist_no = p_temp_distno
                          AND dist_seq_no = pol1.dist_seq_no
                          AND share_cd = poldtl3.share_cd
                          AND item_no  =  item3.item_no; 
                      IF v_itemdtl_diff = 0 THEN
                         EXIT;
                      END IF;
                   END IF;
                END LOOP;
           END LOOP;
          END IF;
          END LOOP;
      END LOOP;        -- end of update at item detail level 
      -- update at itemperil level 
      FOR ITEM4 IN 
          (SELECT item_no, prem_amt
             FROM giuw_witemds
            WHERE dist_no = p_dist_no
              AND dist_seq_no = pol1.dist_seq_no
          )LOOP
          v_iperl_diff := 0;     
          FOR IPERL1 IN 
              (SELECT SUM(prem_amt) prem_amt 
                 FROM giuw_witemperilds
                WHERE dist_no = p_dist_no 
                  AND dist_seq_no = pol1.dist_seq_no
                  AND item_no = item4.item_no
              )LOOP
              IF item4.prem_amt != iperl1.prem_amt THEN
                 v_iperl_diff := item4.prem_amt - iperl1.prem_amt;
                 FOR A1 IN
                     (SELECT MIN(peril_cd) peril
                        FROM giuw_witemperilds
                       WHERE dist_no = p_dist_no 
                         AND dist_seq_no = pol1.dist_seq_no
                         AND item_no = item4.item_no
                      )LOOP
                      UPDATE giuw_witemperilds
                         SET prem_amt = prem_amt + v_iperl_diff
                       WHERE dist_no = p_dist_no 
                         AND dist_seq_no = pol1.dist_seq_no
                         AND item_no = item4.item_no
                         AND peril_cd = a1.peril;
                      UPDATE giuw_witemperilds
                         SET prem_amt = prem_amt - v_iperl_diff
                       WHERE dist_no = p_temp_distno
                         AND dist_seq_no = pol1.dist_seq_no
                         AND item_no = item4.item_no
                         AND peril_cd = a1.peril;      
                     EXIT;
                 END LOOP;   
              END IF;  
         END LOOP;
     END LOOP; --end of update at itemperil level
      /* update at item peril detail level */
      FOR IPERL2 IN (SELECT item_no,peril_cd, prem_amt
                      FROM giuw_witemperilds
                     WHERE dist_no = p_dist_no
                       AND dist_seq_no = pol1.dist_seq_no
          )LOOP
          v_iperldtl_diff  := 0;
          v_iperldtl_diff1 := 0;
          v_iperldtl_diff2 := 0;
          FOR IPERLDTL1 IN
              (SELECT SUM(dist_prem) prem 
                 FROM giuw_witemperilds_dtl 
                WHERE dist_no = p_dist_no
                  AND dist_seq_no = pol1.dist_seq_no
                  AND item_no = iperl2.item_no
                  AND peril_cd = iperl2.peril_cd
          )LOOP                                         
          IF iperl2.prem_amt != iperldtl1.prem THEN
             v_iperldtl_diff := iperl2.prem_amt - iperldtl1.prem;
             FOR ITEMDTL3 IN
                (SELECT share_cd, dist_prem 
                   FROM giuw_witemds_dtl
                  WHERE dist_no = p_dist_no
                    AND dist_seq_no = pol1.dist_seq_no
                    AND item_no = iperl2.item_no
                )LOOP
                FOR IPERLDTL2 IN
                    (SELECT SUM(dist_prem) prem
                      FROM giuw_witemperilds_dtl
                     WHERE dist_no = p_dist_no
                       AND dist_seq_no = pol1.dist_seq_no
                       AND item_no = iperl2.item_no
                       AND share_cd = itemdtl3.share_cd)LOOP
                    IF (itemdtl3.dist_prem > iperldtl2.prem AND
                       v_iperldtl_diff > 0) OR 
                       ( itemdtl3.dist_prem < iperldtl2.prem AND
                       v_iperldtl_diff < 0) THEN
                       v_iperldtl_diff1 := itemdtl3.dist_prem - iperldtl2.prem ;
                       IF v_iperldtl_diff1 > v_iperldtl_diff THEN
                          v_iperldtl_diff2 := v_iperldtl_diff;
                          v_iperldtl_diff := 0;
                       ELSIF v_iperldtl_diff >= v_iperldtl_diff1 THEN
                          v_iperldtl_diff2 := v_iperldtl_diff1;
                          v_iperldtl_diff := v_iperldtl_diff - v_iperldtl_diff1;
                       END IF;         
                       UPDATE giuw_witemperilds_dtl
                          SET dist_prem = dist_prem + v_iperldtl_diff2
                        WHERE dist_no = p_dist_no
                          AND dist_seq_no = pol1.dist_seq_no
                          AND share_cd = itemdtl3.share_cd
                          AND item_no   = iperl2.item_no
                          AND peril_cd = iperl2.peril_cd;
                       UPDATE giuw_witemperilds_dtl
                          SET dist_prem = dist_prem - v_iperldtl_diff2
                        WHERE dist_no = p_temp_distno
                          AND dist_seq_no = pol1.dist_seq_no
                          AND share_cd = itemdtl3.share_cd
                          AND item_no   = iperl2.item_no
                          AND peril_cd = iperl2.peril_cd;
                      IF v_iperldtl_diff = 0 THEN
                         EXIT;
                      END IF;
                   END IF;
                END LOOP;
           END LOOP;
          END IF;
          END LOOP;
      END LOOP;        -- end of update at item detail level 
  END LOOP;
  FOR PERL IN 
      (SELECT dist_no, dist_seq_no,peril_cd, sum(dist_prem) prem
         FROM giuw_witemperilds_dtl
        WHERE dist_no = p_dist_no
       GROUP BY dist_no, dist_seq_no, peril_cd
       )LOOP
       UPDATE giuw_perilds
          SET prem_amt = perl.prem
        WHERE dist_no = perl.dist_no
          AND dist_seq_no = perl.dist_seq_no
          AND peril_cd = perl.peril_cd;
  END LOOP;
  FOR WPERL IN 
      (SELECT dist_no, dist_seq_no,peril_cd, sum(dist_prem) prem
         FROM giuw_witemperilds_dtl
        WHERE dist_no = p_temp_distno
       GROUP BY dist_no, dist_seq_no, peril_cd
       )LOOP
       UPDATE giuw_wperilds
          SET prem_amt = wperl.prem
        WHERE dist_no = wperl.dist_no
          AND dist_seq_no = wperl.dist_seq_no
          AND peril_cd = wperl.peril_cd;
  END LOOP;
  FOR PERLDTL IN 
      (SELECT dist_no, dist_seq_no,peril_cd,share_cd, sum(dist_prem) prem
         FROM giuw_witemperilds_dtl
        WHERE dist_no = p_dist_no
       GROUP BY dist_no, dist_seq_no, peril_cd, share_cd
       )LOOP
       UPDATE giuw_perilds_dtl
          SET dist_prem = perldtl.prem
        WHERE dist_no = perldtl.dist_no
          AND dist_seq_no = perldtl.dist_seq_no
          AND peril_cd = perldtl.peril_cd
          AND share_cd = perldtl.share_cd;
  END LOOP;
  FOR WPERLDTL IN 
      (SELECT dist_no, dist_seq_no,peril_cd,share_cd, sum(dist_prem) prem
         FROM giuw_witemperilds_dtl
        WHERE dist_no = p_temp_distno
       GROUP BY dist_no, dist_seq_no, peril_cd,share_cd
       )LOOP
       UPDATE giuw_wperilds_dtl
          SET dist_prem = wperldtl.prem
        WHERE dist_no = wperldtl.dist_no
          AND dist_seq_no = wperldtl.dist_seq_no
          AND peril_cd = wperldtl.peril_cd
          AND share_cd = wperldtl.share_cd;
  END LOOP;                
 END;
/


