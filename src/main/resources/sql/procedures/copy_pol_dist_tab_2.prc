DROP PROCEDURE CPI.COPY_POL_DIST_TAB_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_dist_tab_2(
    p_old_pol_id        giuw_pol_dist.policy_id%TYPE,
    p_new_par_id        giuw_pol_dist.par_id%TYPE,
    p_new_policy_id     giuw_pol_dist.policy_id%TYPE,
    p_dist_no_new  OUT  giuw_pol_dist.dist_no%TYPE,
    p_dist_no_old  OUT  giuw_pol_dist.dist_no%TYPE  
)
IS
   CURSOR pol_dist
   IS
      SELECT dist_flag, redist_flag, post_flag, endt_type,
             tsi_amt, prem_amt, ann_tsi_amt, dist_type, item_posted_sw,
             ex_loss_sw, batch_id, auto_dist, old_dist_no, iss_cd,
             prem_seq_no, item_grp, takeup_seq_no, user_id, last_upd_date
        FROM giuw_pol_dist
       WHERE policy_id = p_old_pol_id;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_dist_tab program unit 
  */
   SELECT pol_dist_dist_no_s.NEXTVAL
     INTO p_dist_no_new
     FROM DUAL;

   SELECT dist_no
     INTO p_dist_no_old
     FROM giuw_pol_dist
    WHERE policy_id = p_old_pol_id;

   FOR a IN pol_dist
   LOOP
      INSERT INTO giuw_pol_dist
                  (dist_no, par_id,
                   dist_flag, redist_flag, eff_date,
                   expiry_date, create_date, post_flag,
                   policy_id, endt_type, tsi_amt, prem_amt,
                   ann_tsi_amt, dist_type, item_posted_sw,
                   ex_loss_sw, batch_id, auto_dist, old_dist_no,
                   iss_cd, prem_seq_no, item_grp, takeup_seq_no,
                   user_id, last_upd_date
                  )
           VALUES (p_dist_no_new, p_new_par_id,
                   a.dist_flag, a.redist_flag, SYSDATE,
                   ADD_MONTHS (SYSDATE, 12), SYSDATE, a.post_flag,
                   p_new_policy_id, a.endt_type, a.tsi_amt, a.prem_amt,
                   a.ann_tsi_amt, a.dist_type, a.item_posted_sw,
                   a.ex_loss_sw, a.batch_id, a.auto_dist, a.old_dist_no,
                   a.iss_cd, a.prem_seq_no, a.item_grp, a.takeup_seq_no,
                   a.user_id, a.last_upd_date
                  );
   END LOOP;
   
   --CLEAR_MESSAGE;
   --MESSAGE('Copying policy distribution ...',NO_ACKNOWLEDGE);
   --SYNCHRONIZE;
END;
/


