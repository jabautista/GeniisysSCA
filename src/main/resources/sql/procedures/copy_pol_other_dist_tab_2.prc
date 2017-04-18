DROP PROCEDURE CPI.COPY_POL_OTHER_DIST_TAB_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_other_dist_tab_2(
    p_dist_no_old   giuw_policyds.dist_no%TYPE,
    p_dist_no_new   giuw_policyds.dist_no%TYPE
)
IS
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_other_dist_tab program unit 
  */
   CURSOR policyds
   IS
      SELECT a.dist_seq_no, a.item_grp, a.tsi_amt, a.prem_amt, a.ann_tsi_amt,
             b.line_cd, b.share_cd, b.dist_spct, b.dist_spct1,
             b.ann_dist_spct, b.dist_grp
        FROM giuw_policyds a, giuw_policyds_dtl b
       WHERE a.dist_no = b.dist_no
         AND a.dist_seq_no = b.dist_seq_no
         AND a.dist_no = p_dist_no_old;

   CURSOR itemds
   IS
      SELECT a.dist_seq_no, a.item_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt,
             a.display_sw, b.line_cd, b.share_cd, b.dist_spct, b.dist_spct1,
             b.ann_dist_spct, b.dist_grp
        FROM giuw_itemds a, giuw_itemds_dtl b
       WHERE a.dist_no = b.dist_no
         AND a.dist_seq_no = b.dist_seq_no
         AND a.item_no = b.item_no
         AND a.dist_no = p_dist_no_old;

   CURSOR itemperilds
   IS
      SELECT a.dist_seq_no, a.item_no, a.peril_cd, a.line_cd, a.tsi_amt,
             a.prem_amt, a.ann_tsi_amt, b.share_cd, b.dist_spct, b.dist_spct1,
             b.ann_dist_spct, b.dist_grp
        FROM giuw_itemperilds a, giuw_itemperilds_dtl b
       WHERE a.dist_no = b.dist_no
         AND a.dist_seq_no = b.dist_seq_no
         AND a.item_no = b.item_no
         AND a.line_cd = b.line_cd
         AND a.peril_cd = b.peril_cd
         AND a.dist_no = p_dist_no_old;

   CURSOR perilds
   IS
      SELECT a.dist_seq_no, a.peril_cd, a.line_cd, a.tsi_amt, a.prem_amt,
             a.ann_tsi_amt, b.share_cd, b.dist_comm_amt, b.dist_spct,
             b.dist_spct1, b.ann_dist_spct, b.dist_grp
        FROM giuw_perilds a, giuw_perilds_dtl b
       WHERE a.dist_no = b.dist_no
         AND a.dist_seq_no = b.dist_seq_no
         AND a.line_cd = b.line_cd
         AND a.peril_cd = b.peril_cd
         AND a.dist_no = p_dist_no_old;
BEGIN
   FOR a IN policyds
   LOOP
      INSERT INTO cpi.giuw_policyds
                  (dist_no, dist_seq_no, tsi_amt,
                   prem_amt, item_grp, ann_tsi_amt
                  )
           VALUES (p_dist_no_new, a.dist_seq_no, a.tsi_amt,
                   a.prem_amt, a.item_grp, a.ann_tsi_amt
                  );

      INSERT INTO cpi.giuw_policyds_dtl
                  (dist_no, dist_seq_no, line_cd,
                   share_cd, dist_tsi, dist_prem, dist_spct,
                   ann_dist_spct, ann_dist_tsi, dist_grp
                  )
           VALUES (p_dist_no_new, a.dist_seq_no, a.line_cd,
                   a.share_cd, a.tsi_amt, a.prem_amt, a.dist_spct,
                   a.ann_dist_spct, a.ann_tsi_amt, a.dist_grp
                  );
   END LOOP;
   
   FOR b IN itemds
   LOOP
      INSERT INTO cpi.giuw_itemds
                  (dist_no, dist_seq_no, item_no,
                   tsi_amt, prem_amt, ann_tsi_amt
                  )
           VALUES (p_dist_no_new, b.dist_seq_no, b.item_no,
                   b.tsi_amt, b.prem_amt, b.ann_tsi_amt
                  );

      INSERT INTO cpi.giuw_itemds_dtl
                  (dist_no, dist_seq_no, item_no,
                   line_cd, share_cd, dist_spct, dist_tsi, dist_prem,
                   ann_dist_spct, ann_dist_tsi, dist_grp
                  )
           VALUES (p_dist_no_new, b.dist_seq_no, b.item_no,
                   b.line_cd, b.share_cd, b.dist_spct, b.tsi_amt, b.prem_amt,
                   b.ann_dist_spct, b.ann_tsi_amt, b.dist_grp
                  );
   END LOOP;
   
   FOR c IN itemperilds
   LOOP
      INSERT INTO cpi.giuw_itemperilds
                  (dist_no, dist_seq_no, item_no,
                   peril_cd, line_cd, tsi_amt, prem_amt,
                   ann_tsi_amt
                  )
           VALUES (p_dist_no_new, c.dist_seq_no, c.item_no,
                   c.peril_cd, c.line_cd, c.tsi_amt, c.prem_amt,
                   c.ann_tsi_amt
                  );

      INSERT INTO cpi.giuw_itemperilds_dtl
                  (dist_no, dist_seq_no, item_no,
                   peril_cd, line_cd, share_cd, dist_tsi, dist_prem,
                   dist_spct, ann_dist_spct, ann_dist_tsi, dist_grp
                  )
           VALUES (p_dist_no_new, c.dist_seq_no, c.item_no,
                   c.peril_cd, c.line_cd, c.share_cd, c.tsi_amt, c.prem_amt,
                   c.dist_spct, c.ann_dist_spct, c.ann_tsi_amt, c.dist_grp
                  );
   END LOOP;
   
   FOR d IN itemperilds
   LOOP
      INSERT INTO cpi.giuw_perilds
                  (dist_no, dist_seq_no, peril_cd,
                   line_cd, tsi_amt, prem_amt, ann_tsi_amt
                  )
           VALUES (p_dist_no_new, d.dist_seq_no, d.peril_cd,
                   d.line_cd, d.tsi_amt, d.prem_amt, d.ann_tsi_amt
                  );

      INSERT INTO cpi.giuw_perilds_dtl
                  (dist_no, dist_seq_no, peril_cd,
                   line_cd, share_cd, dist_tsi, dist_prem, dist_spct,
                   ann_dist_spct, ann_dist_tsi, dist_grp
                  )
           VALUES (p_dist_no_new, d.dist_seq_no, d.peril_cd,
                   d.line_cd, d.share_cd, d.tsi_amt, d.prem_amt, d.dist_spct,
                   d.ann_dist_spct, d.ann_tsi_amt, d.dist_grp
                  );
   END LOOP;
  
END;
/


