BEGIN
   FOR i IN (SELECT claim_id, clm_res_hist_id, last_update
               FROM GICL_CLM_RES_HIST
              WHERE setup_date IS NULL)
   LOOP
      UPDATE GICL_CLM_RES_HIST
         SET setup_date = i.last_update
       WHERE claim_id = i.claim_id
         AND clm_res_hist_id = i.clm_res_hist_id;
   END LOOP;

   FOR i IN (SELECT claim_id, clm_res_hist_id, item_no, peril_cd, user_id
               FROM GICL_CLM_RES_HIST
              WHERE setup_by IS NULL)
   LOOP
      FOR a IN(
              SELECT clm_stat_cd
                FROM gicl_claims a, gicl_item_peril b
               WHERE a.claim_id = b.claim_id
                 AND a.claim_id = i.claim_id
                 AND b.item_no = i.item_no
                 AND b.peril_cd = i.peril_cd
                 AND clm_stat_cd = 'CD'
                 AND old_stat_cd IS NULL)
      LOOP
        UPDATE gicl_claims
           SET old_stat_cd = 'CD'
         WHERE claim_id = i.claim_id;
      END LOOP;
      
      UPDATE GICL_CLM_RES_HIST
         SET setup_by = i.user_id
       WHERE claim_id = i.claim_id
         AND clm_res_hist_id = i.clm_res_hist_id;
   END LOOP;
   
   COMMIT;
END;