CREATE OR REPLACE PACKAGE BODY CPI.gicl_item_peril_pkg
AS
   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 10.10.2011
   **  Reference By  : (GICLS010 - Basic Information)
   **  Description   : check if gicl_item_peril exist
   */
   FUNCTION get_gicl_item_peril_exist (
      p_claim_id   gicl_item_peril.claim_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                           FROM gicl_item_peril
                          WHERE claim_id = p_claim_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exists; 
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 08.22.2011
   **  Reference By  : (GICLS015 - Fire Item Information), GICLS014 - MC Item Information
   **  Description   : check if gicl_item_peril exist
   */
   FUNCTION get_gicl_item_peril_exist (
      p_item_no    gicl_item_peril.item_no%TYPE,
      p_claim_id   gicl_item_peril.claim_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                           FROM gicl_item_peril
                          WHERE item_no = p_item_no AND claim_id = p_claim_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exists;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 08.22.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : Get gicl_item_peril records
   */
   FUNCTION get_gicl_item_peril (
      p_claim_id   gicl_item_peril.claim_id%TYPE,
      p_item_no    gicl_item_peril.item_no%TYPE,
      p_line_cd    gicl_item_peril.line_cd%TYPE
   )
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.user_id,
                       a.last_update, a.ann_tsi_amt, a.cpi_rec_no,
                       a.cpi_branch_cd, a.motshop_tag, a.loss_cat_cd,
                       a.line_cd, a.close_date, a.close_flag, a.close_flag2,
                       a.close_date2, a.aggregate_sw, a.grouped_item_no,
                       a.allow_tsi_amt, a.base_amt, a.no_of_days,
                       a.allow_no_of_days,
                       DECODE (a.close_flag,
                               'AP', 'OPEN',
                               'CC', 'CLOSED',
                               'WD', 'WITHDRAWN',
                               'CP', 'CLOSED',
                               'DN', 'DENIED',
                               'DC', 'CLOSED',
                               'OPEN'
                              ) nbt_close_flag,
                       DECODE (a.close_flag2,
                               'AP', 'OPEN',
                               'CC', 'CLOSED',
                               'WD', 'WITHDRAWN',
                               'CP', 'CLOSED',
                               'DN', 'DENIED',
                               'DC', 'CLOSED',
                               'OPEN'
                              ) nbt_close_flag2
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id AND a.item_no = p_item_no)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.ann_tsi_amt := i.ann_tsi_amt;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.motshop_tag := i.motshop_tag;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.line_cd := i.line_cd;
         v_list.close_date := i.close_date;
         v_list.close_flag := i.close_flag;
         v_list.close_flag2 := i.close_flag2;
         v_list.close_date2 := i.close_date2;
         v_list.aggregate_sw := i.aggregate_sw;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.allow_tsi_amt := i.allow_tsi_amt;
         v_list.base_amt := i.base_amt;
         v_list.no_of_days := i.no_of_days;
         v_list.allow_no_of_days := i.allow_no_of_days;
         v_list.nbt_close_flag := i.nbt_close_flag;
         v_list.nbt_close_flag2 := i.nbt_close_flag2;
         v_list.hist_indicator := 'D';

         FOR chk_res_hist IN
            (SELECT '1'
               FROM gicl_clm_res_hist
              WHERE claim_id = p_claim_id
                AND item_no = p_item_no
                AND grouped_item_no = v_list.grouped_item_no    --added by gmi
                AND peril_cd = v_list.peril_cd)
         LOOP
            v_list.hist_indicator := 'U';
            EXIT;
         END LOOP;

         --retrive loss category description using database function
         v_list.dsp_loss_cat_des :=
                              get_loss_cat_des (v_list.loss_cat_cd, p_line_cd);
         --retrive peril name using database function
         v_list.dsp_peril_name := get_peril_name (p_line_cd, v_list.peril_cd);
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 08.25.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  Validation to check whether perils with reserve exist
   */
   PROCEDURE validate_peril_reserve (
      p_item_no           IN       gicl_item_peril.item_no%TYPE,
      p_claim_id          IN       gicl_item_peril.claim_id%TYPE,
      p_grouped_item_no   IN       gicl_item_peril.grouped_item_no%TYPE,
      --belle 02.13.2012 to handle PA line
      p_msg_alert         OUT      VARCHAR2
   )
   IS
      v_perilres   NUMBER       := 0;
      v_peril      NUMBER       := 0;
      v_alrt       NUMBER;
      v_ans        VARCHAR2 (1);
   BEGIN
      FOR peril IN (SELECT peril_cd
                      FROM gicl_item_peril
                     WHERE claim_id = p_claim_id
                       AND item_no = p_item_no
                       AND grouped_item_no = p_grouped_item_no
                       -- 0 --added by gmi
                       AND peril_cd IN (
                              SELECT peril_cd
                                FROM gicl_clm_res_hist
                               WHERE claim_id = p_claim_id
                                 AND item_no = p_item_no))
      LOOP
         v_perilres := 1;
      END LOOP;

      IF v_perilres < 1
      THEN                                                /* NO RESERVE YET */
         FOR prl IN (SELECT peril_cd
                       FROM gicl_item_peril
                      WHERE claim_id = p_claim_id
                        AND grouped_item_no = p_grouped_item_no
                        --0 --added by gmi
                        AND item_no = p_item_no)
         LOOP
            /* to check whether peril (w/ or w/o reserve) exists */
            v_peril := 1;
         END LOOP;

         --belle 02.17.2012
         FOR ben IN (SELECT item_no
                       FROM gicl_beneficiary_dtl
                      WHERE claim_id = p_claim_id
                        AND item_no = p_item_no
                        AND grouped_item_no = p_grouped_item_no)
         LOOP
            /* to check whether beneficiary exists */
            v_peril := 1;
         END LOOP;

         IF v_peril > 0
         THEN                   /* WITH PERIL RECORDS, THEREFORE SHOW ALERT */
            p_msg_alert := '1';
            RETURN;
         ELSE              /* NO PERIL YET, THEREFORE, CONTINUE WITH DELETE */
            p_msg_alert := '2';
            RETURN;
         END IF;
      ELSIF v_perilres > 0
      THEN                                          -- WIth peril with reserve
         p_msg_alert := '3';
         RETURN;
      END IF;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 09.16.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  populate_allow_tsi_amt program unit
   */
   FUNCTION populate_allow_tsi_amt (
      p_aggregate_sw      VARCHAR2,
      p_base_amt          NUMBER,
      p_no_of_days        NUMBER,
      p_peril_cd          NUMBER,
      p_item_no           NUMBER,
      p_grouped_item_no   NUMBER,
      p_ann_tsi_amt       NUMBER,
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_allow_tsi_amt   NUMBER;
      v_sum_units       NUMBER;
      v_comp_tsi_amt    NUMBER; 
      v_prorate_flag    VARCHAR2(1);    --start kenneth SR4855 100715
      v_eff_date        DATE;
      v_expiry_date     DATE;
      v_short_rate      NUMBER;         --end kenneth SR4855 100715
   BEGIN
      --start kenneth SR4855 100715
      FOR x IN (SELECT prorate_flag, eff_date, expiry_date, short_rt_percent
                                FROM gipi_polbasic a
                               WHERE a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_cd
                                 AND a.iss_cd = p_pol_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.renew_no = p_renew_no
                                 AND a.endt_seq_no = (SELECT MAX (b.endt_seq_no) endt_seq_no
                                                        FROM gipi_polbasic b, gipi_itmperil c -- rai SR 22591: added gipi_itmperil
                                                       WHERE b.line_cd = p_line_cd
                                                         AND b.subline_cd = p_subline_cd
                                                         AND b.iss_cd = p_pol_iss_cd
                                                         AND b.issue_yy = p_issue_yy
                                                         AND b.pol_seq_no = p_pol_seq_no
                                                         AND b.renew_no = p_renew_no
                                                         AND b.policy_id = c.policy_id -- start rai SR 22591
                                                         AND c.item_no = p_item_no
                                                         AND c.peril_cd = p_peril_cd))-- end
                                                         
      LOOP
         v_prorate_flag := x.prorate_flag;
         v_eff_date := x.eff_date;
         v_expiry_date := x.expiry_date;
         v_short_rate := x.short_rt_percent;
         EXIT;
      END LOOP;
      
      IF v_prorate_flag = '1'
      THEN
        v_comp_tsi_amt := p_ann_tsi_amt * ((TRUNC(v_expiry_date) - TRUNC(v_eff_date))/(check_duration(v_eff_date, v_expiry_date)));
      ELSIF v_prorate_flag = '3'
      THEN
        v_comp_tsi_amt := p_ann_tsi_amt * (NVL (v_short_rate, 1) / 100);
      ELSE
        v_comp_tsi_amt := p_ann_tsi_amt;
      END IF; 
      --end kenneth SR4855 100715  
      
      IF p_aggregate_sw = 'Y'
      THEN
         SELECT NVL (SUM (paid_amt), 0)
           INTO v_sum_units
           FROM gicl_clm_loss_exp b, gicl_claims a
          WHERE NVL (b.cancel_sw, 'N') = 'N'
            AND NVL (b.dist_sw, 'N') = 'Y'
            AND b.claim_id = a.claim_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no
            AND peril_cd = p_peril_cd
            AND line_cd = p_line_cd
            AND subline_cd = p_subline_cd
            AND issue_yy = p_issue_yy
            AND pol_seq_no = p_pol_seq_no
            AND renew_no = p_renew_no
            AND pol_iss_cd = p_pol_iss_cd;

         v_allow_tsi_amt := v_comp_tsi_amt - v_sum_units;   --kenneth SR4855 100715
      ELSE
         v_allow_tsi_amt := v_comp_tsi_amt; --kenneth SR4855 100715
      END IF;

      RETURN (v_allow_tsi_amt);
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 09.14.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  getting LOV for peril
   */
   FUNCTION get_peril_list (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_loss_date       gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date    gipi_polbasic.eff_date%TYPE,
      p_expiry_date     gipi_polbasic.expiry_date%TYPE,
      p_item_no         gipi_itmperil.item_no%TYPE,
      p_peril_cd        gipi_itmperil.peril_cd%TYPE,
      p_loss_cat_cd     giis_loss_ctgry.loss_cat_cd%TYPE,
      p_loss_cat_desc   giis_loss_ctgry.loss_cat_des%TYPE,
      p_find_text       VARCHAR2
   )
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN
         (select * from (SELECT   d.peril_cd peril_cd, e.peril_name peril_name,
                   d.refund refund, d.aggregate_sw, d.no_of_days, d.base_amt,
                   DECODE
                        (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                         'Y', p_loss_cat_cd,
                         NULL
                        ) loss_cat_cd,
                   DECODE
                      (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                       'Y', p_loss_cat_desc,
                       NULL
                      ) loss_cat_desc
              FROM (SELECT   c.peril_cd, SUM (c.tsi_amt) refund,
                             NVL(c.aggregate_sw, 'N') aggregate_sw, NVL(c.no_of_days, 0) no_of_days, NVL(c.base_amt, 0) base_amt -- marco/koks - 07.10.2013 - @ucpb added NVL
                        FROM (SELECT b.peril_cd, b.item_no, b.tsi_amt,
                                     a.policy_id, NVL(b.aggregate_sw, 'N') aggregate_sw, 
                                     NVL(b.no_of_days, 0) no_of_days, NVL(b.base_amt, 0) base_amt -- marco/koks - 07.10.2013 - @ucpb added NVL
                                FROM gipi_polbasic a,
                                     gipi_itmperil b,
                                     gipi_item f
                               WHERE f.item_no = b.item_no
                                 AND f.policy_id = b.policy_id
                                 AND b.line_cd = a.line_cd
                                 AND b.item_no = p_item_no
                                 AND b.policy_id = a.policy_id
                                 AND TRUNC (DECODE (TRUNC (NVL (f.from_date,
                                                                a.eff_date
                                                               )
                                                          ),
                                                    TRUNC (a.incept_date), NVL
                                                               (f.from_date,
                                                                p_pol_eff_date
                                                               ),
                                                    NVL (f.from_date,
                                                         a.eff_date
                                                        )
                                                   )
                                           ) <= p_loss_date
                                 AND TRUNC
                                        (DECODE
                                              (NVL (f.TO_DATE,
                                                    (NVL (a.endt_expiry_date,
                                                          a.expiry_date
                                                         )
                                                    )
                                                   ),
                                               a.expiry_date, NVL
                                                                (f.TO_DATE,
                                                                 p_expiry_date
                                                                ),
                                               NVL (f.TO_DATE,
                                                    a.endt_expiry_date
                                                   )
                                              )
                                        ) >= p_loss_date
                                 AND a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_cd
                                 AND a.iss_cd = p_pol_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.renew_no = p_renew_no
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.pol_flag IN ('1', '2', '3', '4', 'X')) c --kenneth SR4855 100715
                    GROUP BY c.peril_cd,
                             c.aggregate_sw,
                             c.no_of_days,
                             c.base_amt) d,
                   giis_peril e
             WHERE d.refund > 0
               AND e.line_cd = p_line_cd
               AND e.peril_cd = d.peril_cd
               AND DECODE (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                           'Y', NVL (p_peril_cd, e.peril_cd),
                           e.peril_cd
                          ) = e.peril_cd
          ORDER BY d.peril_cd)
               where (   UPPER (peril_cd) LIKE
                                         UPPER (NVL (p_find_text, peril_cd))
                    OR UPPER (peril_name) LIKE
                                       UPPER (NVL (p_find_text, peril_name))
                    or upper(loss_cat_cd) like UPPER(nvl(p_find_text, loss_cat_cd))               
                    or upper(loss_cat_desc) like UPPER(Nvl(p_find_text, loss_cat_desc))
                   )
          )
      LOOP
         v_list.item_no := p_item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.dsp_peril_name := i.peril_name;
         v_list.ann_tsi_amt := i.refund;
         v_list.aggregate_sw := i.aggregate_sw;
         v_list.no_of_days := i.no_of_days;
         v_list.base_amt := i.base_amt;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.dsp_loss_cat_des := i.loss_cat_desc;
         v_list.hist_indicator := 'D';
         v_list.grouped_item_no := 0;
         v_list.close_flag := 'AP';
         v_list.close_flag2 := 'AP';
         v_list.allow_tsi_amt :=
            populate_allow_tsi_amt (i.aggregate_sw,
                                    i.base_amt,
                                    i.no_of_days,
                                    i.peril_cd,
                                    p_item_no,
                                    v_list.grouped_item_no,
                                    i.refund,
                                    p_line_cd,
                                    p_subline_cd,
                                    p_pol_iss_cd,
                                    p_issue_yy,
                                    p_pol_seq_no,
                                    p_renew_no
                                   );

         SELECT check_total_loss_settlement2 (0,
                                              i.peril_cd,
                                              p_item_no,
                                              p_line_cd,
                                              p_subline_cd,
                                              p_pol_iss_cd,
                                              p_issue_yy,
                                              p_pol_seq_no,
                                              p_renew_no,
                                              p_loss_date,
                                              p_pol_eff_date,
                                              p_expiry_date
                                             )
           INTO v_list.tloss_fl
           FROM DUAL;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

    /*
   **  Created by    : Irwin Tabisora
   **  Reference By  : (GICLS014 - Motorcar Item Information)
   **  Description   :  Retrieves peril list in gicl_item_peril
   */
   FUNCTION get_mc_peril_list (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_loss_date       gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date    gipi_polbasic.eff_date%TYPE,
      p_expiry_date     gipi_polbasic.expiry_date%TYPE,
      p_item_no         gipi_itmperil.item_no%TYPE,
      p_peril_cd        gipi_itmperil.peril_cd%TYPE,
      p_loss_cat_cd     giis_loss_ctgry.loss_cat_cd%TYPE,
      p_loss_cat_desc   giis_loss_ctgry.loss_cat_des%TYPE,
      p_find_text       VARCHAR2
   )
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN
         (SELECT * FROM (SELECT d.peril_cd peril_cd, e.peril_name peril_name,
                 d.refund refund, NVL (d.aggregate_sw, 'N') aggregate_sw,
                 d.no_of_days, d.base_amt,
                 DECODE (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                         'Y', p_loss_cat_cd,
                         NULL
                        ) loss_cat_cd,
                 DECODE
                      (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                       'Y', p_loss_cat_desc,
                       NULL
                      ) loss_cat_desc
            FROM (SELECT   c.peril_cd, SUM (c.tsi_amt) refund,
                           NVL (c.aggregate_sw, 'N') aggregate_sw,
                           NVL (c.no_of_days, 0) no_of_days,
                           NVL (c.base_amt, 0) base_amt
                      FROM (SELECT b.peril_cd, b.item_no, b.tsi_amt,
                                   a.policy_id,
                                   NVL (b.aggregate_sw, 'N') aggregate_sw,
                                   b.no_of_days, b.base_amt
                              FROM gipi_polbasic a,
                                   gipi_itmperil b,
                                   gipi_item f
                             WHERE f.item_no = b.item_no
                               AND f.policy_id = b.policy_id
                               AND b.line_cd = a.line_cd
                               AND b.item_no = p_item_no
                               AND b.policy_id = a.policy_id
                               AND TRUNC (DECODE (TRUNC (a.eff_date),
                                                  TRUNC (a.incept_date), p_pol_eff_date,
                                                  a.eff_date
                                                 )
                                         ) <= TRUNC (p_loss_date)
                               AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                                       a.expiry_date
                                                      ),
                                                  a.expiry_date, p_expiry_date,
                                                  a.endt_expiry_date
                                                 )
                                         ) >= TRUNC (p_loss_date)
                               AND a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.iss_cd = p_pol_iss_cd
                               AND a.issue_yy = p_issue_yy
                               AND a.renew_no = p_renew_no
                               AND a.pol_seq_no = p_pol_seq_no
                               AND a.pol_flag IN ('1', '2', '3', '4', 'X')) c   --kenneth SR4855 100815
                  GROUP BY c.peril_cd,
                           NVL (c.aggregate_sw, 'N'),
                           NVL (c.no_of_days, 0),
                           NVL (c.base_amt, 0)) d,
                 giis_peril e
           WHERE d.refund > 0
             AND e.line_cd = p_line_cd
             AND e.peril_cd = d.peril_cd
             AND DECODE (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                         'Y', NVL (p_peril_cd, e.peril_cd),
                         e.peril_cd
                        ) = e.peril_cd
             AND d.peril_cd NOT IN (
                           SELECT peril_cd
                             FROM gicl_item_peril
                            WHERE claim_id = p_claim_id
                                  AND item_no = p_item_no)
            
                 ) WHERE (   UPPER (peril_cd) LIKE
                                         UPPER (NVL (p_find_text, peril_cd))
                  OR UPPER (peril_name) LIKE
                                       UPPER (NVL (p_find_text, peril_name))
            OR UPPER(LOSS_CAT_CD) LIKE UPPER (NVL (p_find_text, LOSS_CAT_CD))    
            OR UPPER(LOSS_CAT_DESC) LIKE UPPER (NVL (p_find_text, LOSS_CAT_DESC))                   
                 )
         )
      LOOP
         v_list.item_no := p_item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.dsp_peril_name := i.peril_name;
         v_list.ann_tsi_amt := i.refund;
         v_list.aggregate_sw := i.aggregate_sw;
         v_list.no_of_days := i.no_of_days;
         v_list.base_amt := i.base_amt;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.dsp_loss_cat_des := i.loss_cat_desc;
         v_list.hist_indicator := 'D';
         v_list.grouped_item_no := 0;
         v_list.close_flag := 'AP';
         v_list.close_flag2 := 'AP';

         SELECT check_total_loss_settlement2 (0,
                                              i.peril_cd,
                                              p_item_no,
                                              p_line_cd,
                                              p_subline_cd,
                                              p_pol_iss_cd,
                                              p_issue_yy,
                                              p_pol_seq_no,
                                              p_renew_no,
                                              p_loss_date,
                                              p_pol_eff_date,
                                              p_expiry_date
                                             )
           INTO v_list.tloss_fl
           FROM DUAL;

         PIPE ROW (v_list);
      END LOOP;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 09.15.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  delete record in gicl_item_peril
   */
   PROCEDURE del_gicl_item_peril (
      p_claim_id   gicl_item_peril.claim_id%TYPE,
      p_item_no    gicl_item_peril.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_item_peril
            WHERE claim_id = p_claim_id AND item_no = p_item_no;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 09.15.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  delete record in gicl_item_peril
   */
   PROCEDURE del_gicl_item_peril (
      p_claim_id   gicl_item_peril.claim_id%TYPE,
      p_item_no    gicl_item_peril.item_no%TYPE,
      p_peril_cd   gicl_item_peril.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_item_peril
            WHERE claim_id = p_claim_id
              AND item_no = p_item_no
              AND peril_cd = p_peril_cd;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 09.16.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  insert/update records in gicl_item_peril
   */
   PROCEDURE set_gicl_item_peril (
      p_claim_id           gicl_item_peril.claim_id%TYPE,
      p_item_no            gicl_item_peril.item_no%TYPE,
      p_peril_cd           gicl_item_peril.peril_cd%TYPE,
      p_user_id            gicl_item_peril.user_id%TYPE,
      p_last_update        gicl_item_peril.last_update%TYPE,
      p_ann_tsi_amt        gicl_item_peril.ann_tsi_amt%TYPE,
      p_cpi_rec_no         gicl_item_peril.cpi_rec_no%TYPE,
      p_cpi_branch_cd      gicl_item_peril.cpi_branch_cd%TYPE,
      p_motshop_tag        gicl_item_peril.motshop_tag%TYPE,
      p_loss_cat_cd        gicl_item_peril.loss_cat_cd%TYPE,
      p_line_cd            gicl_item_peril.line_cd%TYPE,
      p_close_date         gicl_item_peril.close_date%TYPE,
      p_close_flag         gicl_item_peril.close_flag%TYPE,
      p_close_flag2        gicl_item_peril.close_flag2%TYPE,
      p_close_date2        gicl_item_peril.close_date2%TYPE,
      p_aggregate_sw       gicl_item_peril.aggregate_sw%TYPE,
      p_grouped_item_no    gicl_item_peril.grouped_item_no%TYPE,
      p_allow_tsi_amt      gicl_item_peril.allow_tsi_amt%TYPE,
      p_base_amt           gicl_item_peril.base_amt%TYPE,
      p_no_of_days         gicl_item_peril.no_of_days%TYPE,
      p_allow_no_of_days   gicl_item_peril.allow_no_of_days%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_item_peril
         USING DUAL
         ON (    claim_id = p_claim_id
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (claim_id, item_no, peril_cd, user_id, last_update,
                    ann_tsi_amt, cpi_rec_no, cpi_branch_cd, motshop_tag,
                    loss_cat_cd, line_cd, close_date, close_flag, close_flag2,
                    close_date2, aggregate_sw, grouped_item_no, allow_tsi_amt,
                    base_amt, no_of_days, allow_no_of_days)
            VALUES (p_claim_id, p_item_no, p_peril_cd,
                    giis_users_pkg.app_user, SYSDATE, p_ann_tsi_amt,
                    p_cpi_rec_no, p_cpi_branch_cd, p_motshop_tag,
                    p_loss_cat_cd, p_line_cd, p_close_date, p_close_flag,
                    p_close_flag2, p_close_date2, p_aggregate_sw,
                    p_grouped_item_no, p_allow_tsi_amt, p_base_amt,
                    p_no_of_days, p_allow_no_of_days)
         WHEN MATCHED THEN
            UPDATE
               SET user_id = giis_users_pkg.app_user, last_update = SYSDATE,
                   ann_tsi_amt = p_ann_tsi_amt, cpi_rec_no = p_cpi_rec_no,
                   cpi_branch_cd = p_cpi_branch_cd,
                   motshop_tag = p_motshop_tag, loss_cat_cd = p_loss_cat_cd,
                   line_cd = p_line_cd, close_date = p_close_date,
                   close_flag = p_close_flag, close_flag2 = p_close_flag2,
                   close_date2 = p_close_date2, aggregate_sw = p_aggregate_sw,
                   grouped_item_no = p_grouped_item_no,
                   allow_tsi_amt = p_allow_tsi_amt, base_amt = p_base_amt,
                   no_of_days = p_no_of_days,
                   allow_no_of_days = p_allow_no_of_days
            ;
   END;

   /*
   **  Created by   : Belle Bebing
   **  Date Created : 09.22.2011
   **  Reference By : (GICLS041 - Print Claims Documents)
   **  Description  : Get gicl_item_peril records
   */
   FUNCTION get_gicl_item_peril2 (
      p_claim_id   gicl_item_peril.claim_id%TYPE,
      p_line_cd    gicl_item_peril.line_cd%TYPE
   )
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN (SELECT claim_id, item_no, grouped_item_no, peril_cd
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         FOR j IN (SELECT DISTINCT LTRIM (TO_CHAR (a.item_no, '0000009')
                                         ) item_no,
                                   a.peril_cd, c.item_title, d.currency_desc,
                                   e.peril_name, c.currency_cd
                              FROM gicl_item_peril a,
                                   gicl_clm_item c,
                                   giis_currency d,
                                   giis_peril e
                             WHERE a.claim_id = c.claim_id
                               AND a.item_no = c.item_no
                               AND a.grouped_item_no = c.grouped_item_no
                               --added by dexter 09/05/06
                               AND c.currency_cd = d.main_currency_cd
                               AND a.peril_cd = e.peril_cd
                               AND a.claim_id = p_claim_id
                               AND e.line_cd = p_line_cd
                               AND a.item_no = i.item_no
                               AND a.grouped_item_no = i.grouped_item_no
                               -- added by dexter 09/05/06
                               AND a.peril_cd = i.peril_cd
                               AND EXISTS (
                                      SELECT 'X'
                                        FROM gicl_clm_res_hist b
                                       WHERE b.peril_cd = i.peril_cd
                                         AND b.item_no = i.item_no
                                         AND b.claim_id = i.claim_id
                                         AND b.dist_sw = 'Y'))
         LOOP
            v_list.dsp_item_no := j.item_no;
            v_list.dsp_item_title := j.item_title;
            v_list.dsp_peril_cd := j.peril_cd;
            v_list.dsp_peril_name := j.peril_name;
            v_list.dsp_curr_desc := j.currency_desc;
            v_list.currency_cd  := j.currency_cd;
            v_list.grouped_item_no := i.grouped_item_no;

            IF p_line_cd = 'MC'
            THEN
               FOR item IN (SELECT *
                              FROM gicl_motor_car_dtl
                             WHERE claim_id = i.claim_id)
               LOOP
                  v_list.color := item.color;
                  v_list.model_year := item.model_year;
                  v_list.serial_no := item.serial_no;
                  v_list.motor_no := item.motor_no;
                  v_list.plate_no := item.plate_no;
                  v_list.mv_file_no := item.mv_file_no;
                  v_list.drvr_name := item.drvr_name;

                  BEGIN
                     SELECT a.make, b.subline_type_desc
                       INTO v_list.dsp_make, v_list.dsp_subline_type
                       FROM giis_mc_make a,
                            giis_mc_subline_type b,
                            gicl_motor_car_dtl c
                      WHERE c.claim_id = item.claim_id
                        AND c.item_no = item.item_no
                        AND a.car_company_cd = item.motcar_comp_cd
                        AND a.make_cd = item.make_cd
                        AND b.subline_cd = item.subline_type_cd
                        AND b.subline_type_cd = item.subline_type_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_list.dsp_make := NULL;
                        v_list.dsp_subline_type := NULL;
                  END;
               END LOOP;
            END IF;

            PIPE ROW (v_list);
         END LOOP;
      END LOOP;

      RETURN;
   END;

/*
**  Created by    : Belle Bebing
**  Date Created  : 01.11.2012
**  Reference By  : (GICLS017- Personal Accident Item Information)
**  Description   :  gpopulate allowable tsi amount for PA
*/
   FUNCTION populate_allow_tsi_amt_pa (
      p_aggregate_sw      VARCHAR2,
      p_base_amt          NUMBER,
      p_no_of_days        NUMBER,
      p_peril_cd          NUMBER,
      p_item_no           NUMBER,
      p_grouped_item_no   NUMBER,
      p_ann_tsi_amt       NUMBER,
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_allow_tsi_amt   NUMBER;
      v_sum_units       NUMBER;
   BEGIN
      IF p_aggregate_sw = 'Y'
      THEN
         SELECT NVL (SUM (NVL (b.losses_paid, 0) + NVL (b.expenses_paid, 0)),
                     0)                          -- Modified by Marlo 02262010
           INTO v_sum_units
           FROM gicl_clm_res_hist b, gicl_claims a
          WHERE NVL (b.cancel_tag, 'N') = 'N'
            AND b.tran_id IS NOT NULL
            AND b.claim_id = a.claim_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no
            AND peril_cd = p_peril_cd
            AND line_cd = p_line_cd
            AND subline_cd = p_subline_cd
            AND issue_yy = p_issue_yy
            AND pol_seq_no = p_pol_seq_no
            AND renew_no = p_renew_no
            AND pol_iss_cd = p_pol_iss_cd;

         v_allow_tsi_amt := p_ann_tsi_amt - v_sum_units;
      ELSE
         v_allow_tsi_amt := p_ann_tsi_amt;
      END IF;

      RETURN (v_allow_tsi_amt);
   END;

   /*
   **  Created by    : Belle Bebing
   **  Date Created  : 01.11.2012
   **  Reference By  : (GICLS017- Personal Accident Item Information)
   **  Description   :  getting LOV for peril
   */
   FUNCTION get_peril_list_pa (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_loss_date         gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date      gipi_polbasic.eff_date%TYPE,
      p_expiry_date       gipi_polbasic.expiry_date%TYPE,
      p_item_no           gipi_itmperil.item_no%TYPE,
      p_peril_cd          gipi_itmperil.peril_cd%TYPE,
      p_loss_cat_cd       giis_loss_ctgry.loss_cat_cd%TYPE,
      p_loss_cat_desc     giis_loss_ctgry.loss_cat_des%TYPE,
      p_cat_peril_cd      giis_loss_ctgry.peril_cd%TYPE,
      p_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE,
      p_find_text         VARCHAR2
   )
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list    gicl_item_peril_type;
      v_exist   VARCHAR2 (2);
   BEGIN
      SELECT gipi_itmperil_grouped_pkg.get_itmperil_grouped_exist
                                                            (p_line_cd,
                                                             p_subline_cd,
                                                             p_pol_iss_cd,
                                                             p_issue_yy,
                                                             p_pol_seq_no,
                                                             p_renew_no,
                                                             p_item_no,
                                                             p_grouped_item_no
                                                            )
        INTO v_exist
        FROM DUAL;

      IF v_exist = 'Y'
      THEN
         --PERIL GROUP LOV
         FOR i IN
            (SELECT a.peril_cd, e.peril_name
                    , SUM (NVL (a.tsi_amt, 0)) tsi_amt,
                      NVL (a.aggregate_sw, 'N') aggregate_sw,
                      SUM (NVL (a.no_of_days, 0)) no_of_days, 
                      DECODE
                         (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                          'Y', p_loss_cat_cd,
                          NULL
                         ) loss_cat_cd,
                      DECODE
                         (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                          'Y', p_loss_cat_desc,
                          NULL
                         ) loss_cat_desc
                 /* mike jason end 08/10/2006 */
             FROM gipi_itmperil_grouped a,
                      gipi_item b,
                      gipi_polbasic c,
                      giis_peril e,
                      gipi_grouped_items d 
                WHERE 1 = 1
                  AND c.line_cd = p_line_cd
                  AND c.subline_cd = p_subline_cd
                  AND c.iss_cd = p_pol_iss_cd
                  AND c.issue_yy = p_issue_yy
                  AND c.pol_seq_no = p_pol_seq_no
                  AND c.renew_no = p_renew_no
                  AND b.item_no = p_item_no
                  AND a.grouped_item_no = p_grouped_item_no 
                 AND a.peril_cd NOT IN (
                         SELECT peril_cd
                           FROM gicl_item_peril
                          WHERE claim_id = p_claim_id
                            AND item_no = p_item_no
                            AND grouped_item_no = p_grouped_item_no
                            AND peril_cd <> NVL (p_peril_cd, 0)) 
                   /*AND peril_cd <> NVL(gicl_item_peril.peril_cd,0))*/
                  /*AND peril_cd <> NVL(:C006.peril_cd,0))*/
                  AND c.pol_flag IN ('1', '2', '3', '4', 'X') --kenneth SR4855 100715
                  AND TRUNC (DECODE (TRUNC (NVL (NVL (d.from_date,
                                                      b.from_date),
                                                 c.eff_date
                                                )
                                           ),
                                     TRUNC (c.incept_date), p_pol_eff_date,
                                     TRUNC (NVL (NVL (d.from_date,
                                                      b.from_date),
                                                 c.eff_date
                                                )
                                           )
                                    )
                            ) <= TRUNC (p_loss_date)
                  AND TRUNC (NVL (d.TO_DATE,
                                  NVL (b.TO_DATE,
                                       DECODE (NVL (c.endt_expiry_date,
                                                    c.expiry_date
                                                   ),
                                               c.expiry_date, p_expiry_date,
                                               c.endt_expiry_date
                                              )
                                      )
                                 )
                            ) >= p_loss_date 
                  AND a.grouped_item_no = d.grouped_item_no
                  AND a.item_no = d.item_no
                  AND a.policy_id = d.policy_id
                  AND d.item_no = b.item_no
                  AND d.policy_id = b.policy_id
                  AND b.policy_id = c.policy_id
                  AND a.peril_cd = e.peril_cd
                  AND a.line_cd = e.line_cd
                  /* mike begin 08102006 */
                  AND DECODE (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                              'Y', NVL (p_cat_peril_cd, e.peril_cd),
                              e.peril_cd
                             ) = e.peril_cd 
                  --AND d.policy_id = --edited by Aliza G. 03/09/2016 SR 21776
                  AND d.policy_id in --added by Aliza G. 03/09/2016 SR 21776
                         --(SELECT MAX (in_ggi.policy_id) --edited by Aliza G. 03/09/2016 SR 21776
                         (SELECT in_ggi.policy_id --added by Aliza G. 03/09/2016 SR 21776 
                            FROM gipi_grouped_items in_ggi,
                                 gipi_polbasic in_gp
                           WHERE in_ggi.policy_id = in_gp.policy_id
                             AND in_ggi.item_no = d.item_no
                             AND in_ggi.grouped_item_no = d.grouped_item_no
                             AND in_gp.renew_no = p_renew_no
                             AND in_gp.pol_seq_no = p_pol_seq_no
                             AND in_gp.issue_yy = p_issue_yy
                             AND in_gp.iss_cd = p_pol_iss_cd
                             AND in_gp.subline_cd = p_subline_cd
                             AND in_gp.line_cd = p_line_cd
                             AND TRUNC (DECODE (TRUNC (in_gp.eff_date),
                                                TRUNC (in_gp.incept_date), p_pol_eff_date,
                                                in_gp.eff_date
                                               )
                                       ) <= p_loss_date
                             AND TRUNC (DECODE (NVL (in_gp.endt_expiry_date,
                                                     in_gp.expiry_date
                                                    ),
                                                in_gp.expiry_date, p_expiry_date,
                                                in_gp.endt_expiry_date
                                               )
                                       ) >= p_loss_date)
                  AND ( UPPER (a.peril_cd) LIKE
                                         UPPER (NVL (p_find_text, a.peril_cd))
                       OR UPPER (e.peril_name) LIKE
                                       UPPER (NVL (p_find_text, e.peril_name))
                      )
             GROUP BY a.peril_cd, e.peril_name, NVL (a.aggregate_sw, 'N'))
         LOOP
            v_list.item_no := p_item_no;
            v_list.peril_cd := i.peril_cd;
            v_list.dsp_peril_name := i.peril_name;
            v_list.ann_tsi_amt := i.tsi_amt;
            v_list.aggregate_sw := i.aggregate_sw;
            v_list.no_of_days := i.no_of_days;
            --  v_list.base_amt         := i.base_amt;
            v_list.loss_cat_cd := i.loss_cat_cd;
            v_list.dsp_loss_cat_des := i.loss_cat_desc;
            v_list.hist_indicator := 'D';
            v_list.grouped_item_no := p_grouped_item_no;
            v_list.close_flag := 'AP';
            v_list.close_flag2 := 'AP';

            /* v_list.allow_tsi_amt    := gicl_item_peril_pkg.populate_allow_tsi_amt_PA(i.aggregate_sw,
                                                                                      i.base_amt,
                                                                                      i.no_of_days,
                                                                                      i.peril_cd,
                                                                                      p_item_no,
                                                                                      v_list.grouped_item_no,
                                                                                      i.tsi_amt,
                                                                                      p_line_cd,
                                                                                      p_subline_cd,
                                                                                      p_pol_iss_cd,
                                                                                      p_issue_yy,
                                                                                      p_pol_seq_no,
                                                                                      p_renew_no); */
            SELECT check_total_loss_settlement2 (v_list.grouped_item_no, --0, kenneth SR 18895 07212015
                                                 i.peril_cd,
                                                 p_item_no,
                                                 p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                )
              INTO v_list.tloss_fl
              FROM DUAL;

            PIPE ROW (v_list);
         END LOOP;
      ELSE
         --PERIL_LOV
         FOR i IN
            (SELECT   a.peril_cd, e.peril_name,
                      SUM (NVL (a.tsi_amt, 0)) tsi_amt,
                      NVL (a.aggregate_sw, 'N') aggregate_sw,
                      SUM (NVL (a.no_of_days, 0)) no_of_days,
                      
                      /* mike jason begin 08/10/2006 */
                      DECODE
                         (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                          'Y', p_loss_cat_cd,
                          NULL
                         ) loss_cat_cd,
                      DECODE
                         (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                          'Y', p_loss_cat_desc,
                          NULL
                         ) loss_cat_desc
                 /* mike jason end 08/10/2006 */
             FROM     gipi_itmperil a,
                      gipi_item b,
                      gipi_polbasic c,
                      giis_peril e
                WHERE 1 = 1
                  AND c.line_cd = p_line_cd
                  AND c.subline_cd = p_subline_cd
                  AND c.iss_cd = p_pol_iss_cd
                  AND c.issue_yy = p_issue_yy
                  AND c.pol_seq_no = p_pol_seq_no
                  AND c.renew_no = p_renew_no
                  AND b.item_no = p_item_no
                  AND a.peril_cd NOT IN (
                           SELECT peril_cd
                             FROM gicl_item_peril
                            WHERE claim_id = p_claim_id
                                  AND item_no = p_item_no)
                   /*AND peril_cd <> NVL(gicl_item_peril.peril_cd,0))*/
                  /*AND peril_cd <> NVL(:C006.peril_cd,0))*/
                  AND c.pol_flag IN ('1', '2', '3', '4', 'X')    --kenneth SR4855 100715
                  AND TRUNC (NVL (b.from_date,
                                  DECODE (TRUNC (c.eff_date),
                                          TRUNC (c.incept_date), p_pol_eff_date,
                                          c.eff_date
                                         )
                                 )
                            ) <= p_loss_date
                  AND TRUNC (NVL (b.TO_DATE,
                                  DECODE (NVL (c.endt_expiry_date,
                                               c.expiry_date
                                              ),
                                          c.expiry_date, p_expiry_date,
                                          c.endt_expiry_date
                                         )
                                 )
                            ) >= p_loss_date
                  AND a.item_no = b.item_no
                  AND a.policy_id = b.policy_id
                  AND b.policy_id = c.policy_id
                  AND a.peril_cd = e.peril_cd
                  AND a.line_cd = e.line_cd
                  /* mike begin 08102006 */
                  AND DECODE (giisp.v ('VALIDATE_PERIL_LOSS_CATEGORY'),
                              'Y', NVL (p_cat_peril_cd, e.peril_cd),
                              e.peril_cd
                             ) = e.peril_cd
                  /* mike end 08102006 */
                  AND (   UPPER (a.peril_cd) LIKE
                                         UPPER (NVL (p_find_text, a.peril_cd))
                       OR UPPER (e.peril_name) LIKE
                                       UPPER (NVL (p_find_text, e.peril_name))
                      )
             GROUP BY a.peril_cd, e.peril_name, NVL (a.aggregate_sw, 'N'))
         LOOP
            v_list.item_no := p_item_no;
            v_list.peril_cd := i.peril_cd;
            v_list.dsp_peril_name := i.peril_name;
            v_list.ann_tsi_amt := i.tsi_amt;
            v_list.aggregate_sw := i.aggregate_sw;
            v_list.no_of_days := i.no_of_days;
            --  v_list.base_amt         := i.base_amt;
            v_list.loss_cat_cd := i.loss_cat_cd;
            v_list.dsp_loss_cat_des := i.loss_cat_desc;
            v_list.hist_indicator := 'D';
            v_list.grouped_item_no := p_grouped_item_no;
            v_list.close_flag := 'AP';
            v_list.close_flag2 := 'AP';

            /* v_list.allow_tsi_amt    := gicl_item_peril_pkg.populate_allow_tsi_amt_PA(i.aggregate_sw,
                                                                                     i.base_amt,
                                                                                     i.no_of_days,
                                                                                     i.peril_cd,
                                                                                     p_item_no,
                                                                                     v_list.grouped_item_no,
                                                                                     i.tsi_amt,
                                                                                     p_line_cd,
                                                                                     p_subline_cd,
                                                                                     p_pol_iss_cd,
                                                                                     p_issue_yy,
                                                                                     p_pol_seq_no,
                                                                                     p_renew_no); */
            SELECT check_total_loss_settlement2 (0,
                                                 i.peril_cd,
                                                 p_item_no,
                                                 p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                )
              INTO v_list.tloss_fl
              FROM DUAL;

            PIPE ROW (v_list);
         END LOOP;
      END IF;

      RETURN;
   END;

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 01.12.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Gets the list of gicl_item_perils given the claim_id
   */
   FUNCTION get_gicl_item_peril3 (p_claim_id IN gicl_item_peril.claim_id%TYPE)
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no,
                       NVL (a.grouped_item_no, 0) grouped_item_no,
                       a.no_of_days, a.user_id, a.last_update, a.ann_tsi_amt,
                       a.allow_tsi_amt, a.base_amt, a.motshop_tag,
                       a.close_flag, a.close_flag2, a.line_cd, a.peril_cd
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id
                   AND EXISTS (
                          SELECT 'X'
                            FROM gicl_clm_res_hist b
                           WHERE b.peril_cd = a.peril_cd
                             AND b.item_no = a.item_no
                             AND b.claim_id = a.claim_id
                             AND b.dist_sw = 'Y'))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.no_of_days := i.no_of_days;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.ann_tsi_amt := i.ann_tsi_amt;
         v_list.base_amt := i.base_amt;
         v_list.motshop_tag := i.motshop_tag;
         v_list.close_flag := i.close_flag;
         v_list.close_flag2 := i.close_flag2;
         v_list.line_cd := i.line_cd;
         v_list.peril_cd := i.peril_cd;

         IF NVL (i.no_of_days, 0) != 0
         THEN
            v_list.allow_tsi_amt := i.base_amt;
         ELSE
            v_list.allow_tsi_amt := NVL (i.allow_tsi_amt, i.ann_tsi_amt);
         END IF;

         FOR dsp IN (SELECT DISTINCT a.item_no, NVL (a.grouped_item_no, 0),
                                     a.peril_cd, c.item_title,
                                     d.currency_desc, e.peril_name
                                FROM gicl_item_peril a,
                                     gicl_clm_item c,
                                     giis_currency d,
                                     giis_peril e
                               WHERE a.claim_id = c.claim_id
                                 AND a.item_no = c.item_no
                                 AND c.currency_cd = d.main_currency_cd
                                 AND a.peril_cd = e.peril_cd
                                 AND a.claim_id = i.claim_id
                                 AND e.line_cd = i.line_cd
                                 AND a.item_no = i.item_no
                                 AND a.peril_cd = i.peril_cd
                                 AND a.grouped_item_no = c.grouped_item_no
                                 AND a.grouped_item_no = i.grouped_item_no)
         LOOP
            v_list.dsp_item_no := dsp.item_no;
            v_list.dsp_item_title := dsp.item_title;
            v_list.dsp_peril_cd := dsp.peril_cd;
            v_list.dsp_curr_desc := dsp.currency_desc;
            v_list.dsp_peril_name := dsp.peril_name;
         END LOOP;

         DECLARE
            v_menu_line_cd   giis_line.menu_line_cd%TYPE;
         BEGIN
            BEGIN
               SELECT NVL (menu_line_cd, line_cd)
                 INTO v_menu_line_cd
                 FROM giis_line
                WHERE line_cd = i.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_menu_line_cd := NULL;
            END;

            IF    v_menu_line_cd = giisp.v ('LINE_CODE_AC')
               OR v_menu_line_cd = 'AC'
            THEN
               SELECT grouped_item_title
                 INTO v_list.dsp_grp_itm_title
                 FROM gicl_accident_dtl
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND grouped_item_no = i.grouped_item_no;
            ELSIF    v_menu_line_cd = giisp.v ('LINE_CODE_CA')
                  OR v_menu_line_cd = 'CA'
            THEN
               SELECT grouped_item_title
                 INTO v_list.dsp_grp_itm_title
                 FROM gicl_casualty_dtl
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND grouped_item_no = i.grouped_item_no;
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END;

/*
**  Created by    : Belle Bebing
**  Date Created  : 01.13.2011
**  Reference By  : GICLS017- Personal Accident Item- Information
**  Description   : This funtion extracts the latest base_amt(grp) in order to retrieve data in case of endt. of base_amt (with grouped-item)
*/
   FUNCTION extract_base_amt_grp (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_loss_date         gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date      gipi_polbasic.eff_date%TYPE,
      p_expiry_date       gipi_polbasic.expiry_date%TYPE,
      p_item_no           gipi_itmperil.item_no%TYPE,
      p_peril_cd          gipi_itmperil.peril_cd%TYPE,
      p_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_max_eff_date   gipi_polbasic.eff_date%TYPE;
      v_base_amt       gipi_itmperil_grouped.base_amt%TYPE;
      v_max_endt_seq   gipi_polbasic.endt_seq_no%TYPE;
      v_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
   BEGIN
      FOR a1 IN
         (SELECT   a.endt_seq_no, c.base_amt
              FROM gipi_polbasic a,
                   gipi_grouped_items b,
                   gipi_itmperil_grouped c
             WHERE a.policy_id = c.policy_id
               AND a.policy_id = b.policy_id
               AND b.item_no = c.item_no
               AND b.grouped_item_no = c.grouped_item_no
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd = p_pol_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
               AND a.pol_flag NOT IN ('4', '5')
               AND c.grouped_item_no = p_grouped_item_no
               AND c.item_no = p_item_no
               AND c.peril_cd = p_peril_cd
               AND TRUNC (DECODE (TRUNC (NVL (b.from_date, a.eff_date)),
                                  TRUNC (NVL (b.from_date, a.incept_date)), TRUNC
                                                          (NVL (b.from_date,
                                                                p_pol_eff_date
                                                               )
                                                          ),
                                  TRUNC (NVL (b.from_date, a.eff_date))
                                 )
                         ) <= TRUNC (p_loss_date)
               AND TRUNC (DECODE (TRUNC (NVL (b.TO_DATE,
                                              NVL (a.endt_expiry_date,
                                                   a.expiry_date
                                                  )
                                             )
                                        ),
                                  TRUNC (NVL (b.TO_DATE, a.expiry_date)), TRUNC
                                                           (NVL (b.TO_DATE,
                                                                 p_expiry_date
                                                                )
                                                           ),
                                  TRUNC (NVL (b.TO_DATE, a.endt_expiry_date))
                                 )
                         ) >= TRUNC (p_loss_date)
          ORDER BY a.eff_date DESC)
      LOOP
         v_endt_seq_no := a1.endt_seq_no;
         v_base_amt := a1.base_amt;

         FOR b1 IN
            (SELECT   c.base_amt
                 FROM gipi_polbasic a,
                      gipi_grouped_items b,
                      gipi_itmperil_grouped c
                WHERE a.policy_id = c.policy_id
                  AND a.policy_id = b.policy_id
                  AND b.item_no = c.item_no
                  AND b.grouped_item_no = c.grouped_item_no
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd = p_pol_iss_cd
                  AND a.issue_yy = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no = p_renew_no
                  AND c.grouped_item_no = p_grouped_item_no
                  AND c.item_no = p_item_no
                  AND c.peril_cd = p_peril_cd
                  AND TRUNC (DECODE (TRUNC (NVL (b.from_date, a.eff_date)),
                                     TRUNC (NVL (b.from_date, a.incept_date)), TRUNC
                                                          (NVL (b.from_date,
                                                                p_pol_eff_date
                                                               )
                                                          ),
                                     TRUNC (NVL (b.from_date, a.eff_date))
                                    )
                            ) <= TRUNC (p_loss_date)
                  AND TRUNC (DECODE (TRUNC (NVL (b.TO_DATE,
                                                 NVL (a.endt_expiry_date,
                                                      a.expiry_date
                                                     )
                                                )
                                           ),
                                     TRUNC (NVL (b.TO_DATE, a.expiry_date)), TRUNC
                                                           (NVL (b.TO_DATE,
                                                                 p_expiry_date
                                                                )
                                                           ),
                                     TRUNC (NVL (b.TO_DATE,
                                                 a.endt_expiry_date)
                                           )
                                    )
                            ) >= TRUNC (p_loss_date)
                  AND NVL (a.back_stat, 5) = 2
                  AND a.endt_seq_no > v_endt_seq_no
             ORDER BY a.endt_seq_no DESC)
         LOOP
            v_base_amt := b1.base_amt;
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

      RETURN (v_base_amt);
   END;

/*
**  Created by    : Belle Bebing
**  Date Created  : 01.13.2011
**  Reference By  : GICLS017- Personal Accident Item- Information
**  Description   : This funtion extracts the latest base_amt(grp) in order to retrieve data in case of endt. of base_amt
*/
   FUNCTION extract_base_amt (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_loss_date         gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date      gipi_polbasic.eff_date%TYPE,
      p_expiry_date       gipi_polbasic.expiry_date%TYPE,
      p_item_no           gipi_itmperil.item_no%TYPE,
      p_peril_cd          gipi_itmperil.peril_cd%TYPE,
      p_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_max_eff_date   gipi_polbasic.eff_date%TYPE;
      v_base_amt       gipi_itmperil_grouped.base_amt%TYPE;
      v_max_endt_seq   gipi_polbasic.endt_seq_no%TYPE;
      v_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
   BEGIN
      FOR a1 IN
         (SELECT   a.endt_seq_no, c.base_amt
              FROM gipi_polbasic a, gipi_item b, gipi_itmperil c
             WHERE a.policy_id = c.policy_id
               AND a.policy_id = b.policy_id
               AND b.item_no = c.item_no
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd = p_pol_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
               AND a.pol_flag NOT IN ('4', '5')
               AND c.item_no = p_item_no
               AND c.peril_cd = p_peril_cd
               AND TRUNC (DECODE (TRUNC (NVL (b.from_date, a.eff_date)),
                                  TRUNC (NVL (b.from_date, a.incept_date)), TRUNC
                                                          (NVL (b.from_date,
                                                                p_pol_eff_date
                                                               )
                                                          ),
                                  TRUNC (NVL (b.from_date, a.eff_date))
                                 )
                         ) <= TRUNC (p_loss_date)
               AND TRUNC (DECODE (TRUNC (NVL (b.TO_DATE,
                                              NVL (a.endt_expiry_date,
                                                   a.expiry_date
                                                  )
                                             )
                                        ),
                                  TRUNC (NVL (b.TO_DATE, a.expiry_date)), TRUNC
                                                           (NVL (b.TO_DATE,
                                                                 p_expiry_date
                                                                )
                                                           ),
                                  TRUNC (NVL (b.TO_DATE, a.endt_expiry_date))
                                 )
                         ) >= TRUNC (p_loss_date)
          ORDER BY a.eff_date DESC)
      LOOP
         v_endt_seq_no := a1.endt_seq_no;
         v_base_amt := a1.base_amt;

         FOR b1 IN
            (SELECT   c.base_amt
                 FROM gipi_polbasic a, gipi_item b, gipi_itmperil c
                WHERE a.policy_id = c.policy_id
                  AND a.policy_id = b.policy_id
                  AND b.item_no = c.item_no
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd = p_pol_iss_cd
                  AND a.issue_yy = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no = p_renew_no
                  AND c.item_no = p_item_no
                  AND c.peril_cd = p_peril_cd
                  AND TRUNC (DECODE (TRUNC (NVL (b.from_date, a.eff_date)),
                                     TRUNC (NVL (b.from_date, a.incept_date)), TRUNC
                                                          (NVL (b.from_date,
                                                                p_pol_eff_date
                                                               )
                                                          ),
                                     TRUNC (NVL (b.from_date, a.eff_date))
                                    )
                            ) <= TRUNC (p_loss_date)
                  AND TRUNC (DECODE (TRUNC (NVL (b.TO_DATE,
                                                 NVL (a.endt_expiry_date,
                                                      a.expiry_date
                                                     )
                                                )
                                           ),
                                     TRUNC (NVL (b.TO_DATE, a.expiry_date)), TRUNC
                                                           (NVL (b.TO_DATE,
                                                                 p_expiry_date
                                                                )
                                                           ),
                                     TRUNC (NVL (b.TO_DATE,
                                                 a.endt_expiry_date)
                                           )
                                    )
                            ) >= TRUNC (p_loss_date)
                  AND NVL (a.back_stat, 5) = 2
                  AND a.endt_seq_no > v_endt_seq_no
             ORDER BY a.endt_seq_no DESC)
         LOOP
            v_base_amt := b1.base_amt;
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

      RETURN (v_base_amt);
   END;

/*
**  Created by    : Belle Bebing
**  Date Created  : 01.13.2011
**  Reference By  : GICLS017- Personal Accident Item- Information
**  Description   : Checking of endt and backwrd endt for base_amt of peril
*/
   PROCEDURE check_agg_peril (
      p_aggregate_sw             gicl_item_peril.aggregate_sw%TYPE,
      p_line_cd                  gipi_polbasic.line_cd%TYPE,
      p_subline_cd               gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd               gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                 gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no               gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                 gipi_polbasic.renew_no%TYPE,
      p_loss_date                gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date             gipi_polbasic.eff_date%TYPE,
      p_expiry_date              gipi_polbasic.expiry_date%TYPE,
      p_item_no                  gipi_itmperil.item_no%TYPE,
      p_grouped_item_no          gicl_item_peril.grouped_item_no%TYPE,
      p_peril_cd                 gipi_itmperil.peril_cd%TYPE,
      p_no_of_days               NUMBER,
      p_ann_tsi_amt              NUMBER,
      p_agg_peril          OUT   VARCHAR2,
      p_base_amt           OUT   gicl_item_peril.base_amt%TYPE,
      p_allow_tsi_amt      OUT   gicl_item_peril.allow_tsi_amt%TYPE,
      -- p_nbt_allow_tsi    OUT  gicl_item_peril.allow_tsi_amt%TYPE,
      p_allow_no_of_days   OUT   gicl_item_peril.allow_no_of_days%TYPE
   )
   IS
      v_exist       VARCHAR2 (1);
      v_sum_units   NUMBER;
   BEGIN
      SELECT gipi_itmperil_grouped_pkg.get_itmperil_grouped_exist
                                                            (p_line_cd,
                                                             p_subline_cd,
                                                             p_pol_iss_cd,
                                                             p_issue_yy,
                                                             p_pol_seq_no,
                                                             p_renew_no,
                                                             p_item_no,
                                                             p_grouped_item_no
                                                            )
        INTO v_exist
        FROM DUAL;

      p_agg_peril := 'N';

      IF NVL (p_aggregate_sw, 'N') = 'Y'
      THEN
         FOR b IN (SELECT a.close_date, a.close_date2
                     FROM gicl_item_peril a, gicl_claims b
                    WHERE a.claim_id = b.claim_id
                      AND b.line_cd = p_line_cd
                      AND b.subline_cd = p_subline_cd
                      AND b.iss_cd = p_pol_iss_cd
                      AND b.issue_yy = p_issue_yy
                      AND b.pol_seq_no = p_pol_seq_no
                      AND b.renew_no = p_renew_no
                      AND a.item_no = p_item_no
                      AND grouped_item_no = p_grouped_item_no
                      AND peril_cd = p_peril_cd)
         LOOP
            IF b.close_date IS NULL OR b.close_date2 IS NULL
            THEN
               p_agg_peril := 'Y';
               EXIT;
            END IF;
         END LOOP;
      END IF;

      IF p_agg_peril = 'N'
      THEN
         IF v_exist = 'Y'
         THEN
            p_base_amt :=
               gicl_item_peril_pkg.extract_base_amt_grp (p_line_cd,
                                                         p_subline_cd,
                                                         p_pol_iss_cd,
                                                         p_issue_yy,
                                                         p_pol_seq_no,
                                                         p_renew_no,
                                                         p_loss_date,
                                                         p_pol_eff_date,
                                                         p_expiry_date,
                                                         p_item_no,
                                                         p_peril_cd,
                                                         p_grouped_item_no
                                                        );
         ELSE
            p_base_amt :=
               gicl_item_peril_pkg.extract_base_amt (p_line_cd,
                                                     p_subline_cd,
                                                     p_pol_iss_cd,
                                                     p_issue_yy,
                                                     p_pol_seq_no,
                                                     p_renew_no,
                                                     p_loss_date,
                                                     p_pol_eff_date,
                                                     p_expiry_date,
                                                     p_item_no,
                                                     p_peril_cd,
                                                     p_grouped_item_no
                                                    );
         END IF;

         p_allow_tsi_amt :=
            gicl_item_peril_pkg.populate_allow_tsi_amt_pa (p_aggregate_sw,
                                                           p_base_amt,
                                                           p_no_of_days,
                                                           p_peril_cd,
                                                           p_item_no,
                                                           p_grouped_item_no,
                                                           p_ann_tsi_amt,
                                                           p_line_cd,
                                                           p_subline_cd,
                                                           p_pol_iss_cd,
                                                           p_issue_yy,
                                                           p_pol_seq_no,
                                                           p_renew_no
                                                          );

         IF NVL (p_no_of_days, 0) <> 0
         THEN
            p_allow_tsi_amt := p_base_amt;
         /*ELSE
                    p_nbt_allow_tsi := p_allow_tsi_amt;*/
         END IF;

         SELECT NVL (SUM (no_of_units), 0)
           INTO v_sum_units
           FROM gicl_loss_exp_dtl a, gicl_clm_loss_exp b, gicl_claims c
          WHERE a.claim_id = b.claim_id
            AND a.clm_loss_id = b.clm_loss_id
            AND a.line_cd = c.line_cd
            AND c.claim_id = b.claim_id
            AND NVL (b.cancel_sw, 'N') = 'N'
            AND NVL (b.dist_sw, 'N') = 'Y'
            AND b.item_no = p_item_no
            AND b.peril_cd = p_peril_cd
            AND b.grouped_item_no = p_grouped_item_no
            AND c.line_cd = p_line_cd
            AND c.subline_cd = p_subline_cd
            AND c.issue_yy = p_issue_yy
            AND c.pol_seq_no = p_pol_seq_no
            AND c.renew_no = p_renew_no
            AND c.pol_iss_cd = p_pol_iss_cd;

         p_allow_no_of_days := p_no_of_days - v_sum_units;
      END IF;
   END;

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  02.20.2012
   **  Reference By : (GICLS032 - Claim Advice)
   **  Description  : Checks whether peril is still active or not.
   **
   */
   FUNCTION gicls032_check_peril_status (
      p_claim_id          gicl_item_peril.claim_id%TYPE,
      p_item_no           gicl_item_peril.item_no%TYPE,
      p_peril_cd          gicl_item_peril.peril_cd%TYPE,
      p_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE
   )
      RETURN gicl_item_peril.close_flag%TYPE
   IS
      v_close_flag   gicl_item_peril.close_flag%TYPE;
   BEGIN
      FOR m IN (SELECT close_flag
                  FROM gicl_item_peril
                 WHERE claim_id = p_claim_id
                   AND item_no = p_item_no
                   AND peril_cd = p_peril_cd
                   AND grouped_item_no = p_grouped_item_no)
      LOOP                                                    --modfied by gmi
         v_close_flag := NVL (m.close_flag, 'AP');
      END LOOP;

      RETURN v_close_flag;
   END;

   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Procedure to update the status of gicl_item_peril record
   */
   PROCEDURE gicls024_update_status (
      p_claim_id            gicl_item_peril.claim_id%TYPE,
      p_item_no             gicl_item_peril.item_no%TYPE,
      p_peril_cd            gicl_item_peril.peril_cd%TYPE,
      p_grouped_item_no     gicl_item_peril.grouped_item_no%TYPE,
      p_close_flag          gicl_item_peril.close_flag%TYPE,
      p_close_flag2         gicl_item_peril.close_flag2%TYPE,
      p_update_xol          VARCHAR2,
      p_distribution_date   gicl_clm_res_hist.distribution_date%TYPE,
      p_loss_reserve        gicl_clm_reserve.loss_reserve%TYPE,
      p_expense_reserve     gicl_clm_reserve.expense_reserve%TYPE
   )
   IS
      v_hist_seq_no   gicl_clm_res_hist.hist_seq_no%TYPE   := 1;
      v_clm_res_hist_id     gicl_clm_res_hist.clm_res_hist_id%TYPE   := 1;  --added by Halley 09.13.2013
   BEGIN
      IF p_close_flag IS NOT NULL AND p_close_flag2 IS NULL
      THEN
         UPDATE gicl_item_peril
            SET close_flag = p_close_flag,
                close_date = SYSDATE
          WHERE claim_id = p_claim_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd
            AND grouped_item_no = p_grouped_item_no;
      ELSIF p_close_flag IS NULL AND p_close_flag2 IS NOT NULL
      THEN
         UPDATE gicl_item_peril
            SET close_flag2 = p_close_flag2,
                close_date2 = SYSDATE
          WHERE claim_id = p_claim_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd
            AND grouped_item_no = p_grouped_item_no;
      ELSIF p_close_flag IS NOT NULL AND p_close_flag2 IS NOT NULL
      THEN
         UPDATE gicl_item_peril
            SET close_flag = p_close_flag,
                close_date = SYSDATE,
                close_flag2 = p_close_flag2,
                close_date2 = SYSDATE
          WHERE claim_id = p_claim_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd
            AND grouped_item_no = p_grouped_item_no;
      END IF;

      IF p_close_flag = 'AP' OR p_close_flag2 = 'AP'
      THEN
         IF p_close_flag is NULL --Added by: Jerome Bautista 05.28.2015 SR 4261 @line 1745 - 1774
            THEN
              UPDATE gicl_item_peril
                 SET close_flag2 = p_close_flag2,
                     close_date2 = null
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no
                 AND peril_cd = p_peril_cd
                 AND grouped_item_no = p_grouped_item_no;
          ELSIF p_close_flag2 IS NULL
            THEN
              UPDATE gicl_item_peril
                 SET close_flag = p_close_flag,
                     close_date = null
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no
                 AND peril_cd = p_peril_cd
                 AND grouped_item_no = p_grouped_item_no;
          ELSIF p_close_flag IS NOT NULL AND p_close_flag2 IS NOT NULL
            THEN
              UPDATE gicl_item_peril
                 SET close_flag = p_close_flag,
                     close_date = null,
                     close_flag2 = p_close_flag2,
                     close_date2 = null
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no
                 AND peril_cd = p_peril_cd
                 AND grouped_item_no = p_grouped_item_no;   
      END IF; 
         create_new_reserve (p_claim_id,
                             p_item_no,
                             p_peril_cd,
                             p_grouped_item_no,
                             p_distribution_date,
                             p_loss_reserve,
                             p_expense_reserve,
                             v_hist_seq_no,
                             v_clm_res_hist_id  --added by Halley 09.13.2013
                            );
         update_clm_dist_tag (p_claim_id);
      END IF;

      IF p_update_xol = 'Y'
      THEN
         giis_dist_share_pkg.gicls024_update_xol (p_claim_id, p_peril_cd);
      END IF;
   END gicls024_update_status;

   PROCEDURE check_peril_status_gicls024 (
      p_claim_id      IN       gicl_item_peril.claim_id%TYPE,
      p_peril_cd      IN       gicl_item_peril.peril_cd%TYPE,
      p_item_no       IN       gicl_item_peril.item_no%TYPE,
      p_grp_item_no   IN       gicl_item_peril.grouped_item_no%TYPE,
      v_close_flag    OUT      gicl_item_peril.close_flag%TYPE,
      v_close_flag2   OUT      gicl_item_peril.close_flag2%TYPE
   )
   IS
   BEGIN
      FOR m IN (SELECT close_flag, close_flag2
                  FROM gicl_item_peril
                 WHERE claim_id = p_claim_id
                   AND NVL (grouped_item_no, 0) = NVL (p_grp_item_no, 0)
                   --added by gmi 02/28/06
                   AND item_no = p_item_no
                   AND peril_cd = p_peril_cd)
      LOOP
         v_close_flag := NVL (m.close_flag, 'AP');
         v_close_flag2 := NVL (m.close_flag2, 'AP');
      END LOOP;
   END;

   /*
   **  Created by    : Roy Encela
   **  Date Created  : 04.20.2012
   **  Reference By  : GICLS024 - Claim Reserve
   **  Description   : Gets the list of gicl_item_perils given the claim_id
   **                  Almost exactly the same as get_gicl_item_peril3 minus the check in in gicl_clm_res_hist
   */
   FUNCTION get_gicl_item_peril4 (p_claim_id IN gicl_item_peril.claim_id%TYPE)
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no,
                       NVL (a.grouped_item_no, 0) grouped_item_no,
                       a.no_of_days, a.user_id, a.last_update, a.ann_tsi_amt,
                       a.allow_tsi_amt, a.base_amt, a.motshop_tag,
                       a.close_flag, a.close_flag2, a.line_cd, a.peril_cd
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.no_of_days := i.no_of_days;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.ann_tsi_amt := i.ann_tsi_amt;
         v_list.base_amt := i.base_amt;
         v_list.motshop_tag := i.motshop_tag;
         v_list.close_flag := i.close_flag;
         v_list.close_flag2 := i.close_flag2;
         v_list.line_cd := i.line_cd;
         v_list.peril_cd := i.peril_cd;

         IF NVL (i.no_of_days, 0) != 0
         THEN
            v_list.allow_tsi_amt := i.base_amt;
         ELSE
            v_list.allow_tsi_amt := NVL (i.allow_tsi_amt, i.ann_tsi_amt);
         END IF;

         FOR dsp IN (SELECT DISTINCT a.item_no, NVL (a.grouped_item_no, 0),
                                     a.peril_cd, c.item_title,
                                     d.currency_desc, e.peril_name
                                FROM gicl_item_peril a,
                                     gicl_clm_item c,
                                     giis_currency d,
                                     giis_peril e
                               WHERE a.claim_id = c.claim_id
                                 AND a.item_no = c.item_no
                                 AND c.currency_cd = d.main_currency_cd
                                 AND a.peril_cd = e.peril_cd
                                 AND a.claim_id = i.claim_id
                                 AND e.line_cd = i.line_cd
                                 AND a.item_no = i.item_no
                                 AND a.peril_cd = i.peril_cd
                                 AND a.grouped_item_no = c.grouped_item_no
                                 AND a.grouped_item_no = i.grouped_item_no)
         LOOP
            v_list.dsp_item_no := dsp.item_no;
            v_list.dsp_item_title := dsp.item_title;
            v_list.dsp_peril_cd := dsp.peril_cd;
            v_list.dsp_curr_desc := dsp.currency_desc;
            v_list.dsp_peril_name := dsp.peril_name;
         END LOOP;

         DECLARE
            v_menu_line_cd   giis_line.menu_line_cd%TYPE;
         BEGIN
            BEGIN
               SELECT NVL (menu_line_cd, line_cd)
                 INTO v_menu_line_cd
                 FROM giis_line
                WHERE line_cd = i.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_menu_line_cd := NULL;
            END;

            IF    v_menu_line_cd = giisp.v ('LINE_CODE_AC')
               OR v_menu_line_cd = 'AC'
            THEN
               SELECT grouped_item_title
                 INTO v_list.dsp_grp_itm_title
                 FROM gicl_accident_dtl
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND grouped_item_no = i.grouped_item_no;
            ELSIF    v_menu_line_cd = giisp.v ('LINE_CODE_CA')
                  OR v_menu_line_cd = 'CA'
            THEN
               SELECT grouped_item_title
                 INTO v_list.dsp_grp_itm_title
                 FROM gicl_casualty_dtl
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND grouped_item_no = i.grouped_item_no;
            END IF;
         END;
         
         -- robert 07/31/2012
         v_list.reserve_dtl_exist := 'N';
         v_list.payment_dtl_exist := 'N';

         -- check if reserve exist. -- irwin 6/21/2012
         FOR chk IN (SELECT 'Y'
                       FROM gicl_clm_res_hist
                      WHERE claim_id = v_list.claim_id
                        AND grouped_item_no = v_list.grouped_item_no
                        AND item_no = v_list.item_no
                        AND peril_cd = v_list.peril_cd
                        AND (   NVL (loss_reserve, 0) != 0
                             OR NVL (expense_reserve, 0) != 0
                            ))
         LOOP
            v_list.reserve_dtl_exist := 'Y';
            EXIT;
         END LOOP;

         -- check if payment exist.  -- irwin 6/21/2012
         FOR chk IN (SELECT 'Y'
                       FROM gicl_clm_res_hist
                      WHERE claim_id = v_list.claim_id
                        AND grouped_item_no = v_list.grouped_item_no
                        AND item_no = v_list.item_no
                        AND peril_cd = v_list.peril_cd
                        AND (   NVL (losses_paid, 0) != 0
                             OR NVL (expenses_paid, 0) != 0
                            ))
         LOOP
            v_list.payment_dtl_exist := 'Y';
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END;
   
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 03.21.2013
   **  Reference By  : GICLS0260 - Claim Information
   **  Description   : Gets the list of gicl_item_perils used in Claims Information module
   **                  
   */
   FUNCTION get_gicl_item_peril5 (p_claim_id IN gicl_item_peril.claim_id%TYPE)
      RETURN gicl_item_peril_tab PIPELINED
   IS
      v_list   gicl_item_peril_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no,
                       NVL (a.grouped_item_no, 0) grouped_item_no,
                       a.no_of_days, a.user_id, a.last_update, a.ann_tsi_amt,
                       a.allow_tsi_amt, a.base_amt, a.motshop_tag,
                       a.close_flag, a.close_flag2, a.line_cd, a.peril_cd,
					   DECODE (a.close_flag,
							   'AP', 'ACTIVE',
							   'CC', 'CLOSED',
							   'WD', 'WITHDRAWN',
							   'CP', 'CLOSED',
							   'DN', 'DENIED',
							   'DC', 'CLOSED',
							   'OPEN'
							  ) nbt_close_flag,
						DECODE (a.close_flag2,
							   'AP', 'ACTIVE',
							   'CC', 'CLOSED',
							   'WD', 'WITHDRAWN',
							   'CP', 'CLOSED',
							   'DN', 'DENIED',
							   'DC', 'CLOSED',
							   'OPEN'
							  ) nbt_close_flag2
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.no_of_days := i.no_of_days;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.ann_tsi_amt := i.ann_tsi_amt;
         v_list.base_amt := i.base_amt;
         v_list.motshop_tag := i.motshop_tag;
         v_list.close_flag := i.close_flag;
         v_list.close_flag2 := i.close_flag2;
		 v_list.nbt_close_flag := i.nbt_close_flag;
         v_list.nbt_close_flag2 := i.nbt_close_flag2;
         v_list.line_cd := i.line_cd;
         v_list.peril_cd := i.peril_cd;
         v_list.sdf_last_update := TO_CHAR(i.last_update,'MM-DD-YYYY HH:MI:SS AM'); --added by steven 06.03.2013

         IF NVL (i.no_of_days, 0) != 0
         THEN
            v_list.allow_tsi_amt := i.base_amt;
         ELSE
            v_list.allow_tsi_amt := NVL (i.allow_tsi_amt, i.ann_tsi_amt);
         END IF;

         FOR dsp IN (SELECT DISTINCT a.item_no, NVL (a.grouped_item_no, 0),
                                     a.peril_cd, c.item_title,
                                     d.currency_desc, e.peril_name
                                FROM gicl_item_peril a,
                                     gicl_clm_item c,
                                     giis_currency d,
                                     giis_peril e
                               WHERE a.claim_id = c.claim_id
                                 AND a.item_no = c.item_no
                                 AND c.currency_cd = d.main_currency_cd
                                 AND a.peril_cd = e.peril_cd
                                 AND a.claim_id = i.claim_id
                                 AND e.line_cd = i.line_cd
                                 AND a.item_no = i.item_no
                                 AND a.peril_cd = i.peril_cd
                                 AND a.grouped_item_no = c.grouped_item_no
                                 AND a.grouped_item_no = i.grouped_item_no)
         LOOP
            v_list.dsp_item_no := dsp.item_no;
            v_list.dsp_item_title := dsp.item_title;
            v_list.dsp_peril_cd := dsp.peril_cd;
            v_list.dsp_curr_desc := dsp.currency_desc;
            v_list.dsp_peril_name := dsp.peril_name;
         END LOOP;

         DECLARE
            v_menu_line_cd   giis_line.menu_line_cd%TYPE;
         BEGIN
            BEGIN
               SELECT NVL (menu_line_cd, line_cd)
                 INTO v_menu_line_cd
                 FROM giis_line
                WHERE line_cd = i.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_menu_line_cd := NULL;
            END;

            IF    v_menu_line_cd = giisp.v ('LINE_CODE_AC')
               OR v_menu_line_cd = 'AC'
            THEN
               SELECT grouped_item_title
                 INTO v_list.dsp_grp_itm_title
                 FROM gicl_accident_dtl
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND grouped_item_no = i.grouped_item_no;
            ELSIF    v_menu_line_cd = giisp.v ('LINE_CODE_CA')
                  OR v_menu_line_cd = 'CA'
            THEN
               SELECT grouped_item_title
                 INTO v_list.dsp_grp_itm_title
                 FROM gicl_casualty_dtl
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND grouped_item_no = i.grouped_item_no;
            END IF;
         END;
         
         v_list.reserve_dtl_exist := 'N';
         v_list.payment_dtl_exist := 'N';

         FOR chk IN (SELECT 'Y'
                       FROM gicl_clm_res_hist
                      WHERE claim_id = v_list.claim_id
                        AND grouped_item_no = v_list.grouped_item_no
                        AND item_no = v_list.item_no
                        AND peril_cd = v_list.peril_cd
                        AND (   NVL (loss_reserve, 0) != 0
                             OR NVL (expense_reserve, 0) != 0
                            ))
         LOOP
            v_list.reserve_dtl_exist := 'Y';
            EXIT;
         END LOOP;


         FOR chk IN (SELECT 'Y'
                       FROM gicl_clm_res_hist
                      WHERE claim_id = v_list.claim_id
                        AND grouped_item_no = v_list.grouped_item_no
                        AND item_no = v_list.item_no
                        AND peril_cd = v_list.peril_cd
                        AND (   NVL (losses_paid, 0) != 0
                             OR NVL (expenses_paid, 0) != 0
                            ))
         LOOP
            v_list.payment_dtl_exist := 'Y';
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END;
   
   /*
   **  Created by    : Carlo Rubenecia
   **  Date Created  : 01-06-2017
   **  Reference By  : GICLS021 - Item Information
   **  Description   : check if share percentage is over 100 %
   */
   FUNCTION check_share_percentage(
       p_claim_id   IN  GICL_ITEM_PERIL.claim_id%TYPE,
       p_peril_cd   IN  GICL_ITEM_PERIL.peril_cd%TYPE,
       p_item_no    IN  GICL_ITEM_PERIL.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_check      VARCHAR2 (1) := 'N';
      v_total      NUMBER := 0;
      v_check_zero VARCHAR2 (1) := 'N';
   BEGIN
     FOR rec IN (SELECT A2.INTRMDRY_INTM_NO,
                   A2.share_percentage,
                   AVG(A2.TOT_PREM_AMT) TOT_PREM_AMT,
                   SUM(A2.PREM_AMT) PREM_AMT  
              FROM (SELECT A1.policy_id,
                           A1.tot_prem_amt,
                           d.iss_cd,
                           d.prem_seq_no,
                           SUM(b.prem_amt) prem_amt,
                           a10.intrmdry_intm_no,
                           a10.share_percentage
                      FROM gipi_itmperil b,
                           gipi_item c,
                           gipi_comm_invoice a10,
                           gipi_invoice d,
                           (SELECT b250.policy_id     policy_id,
                                   TOT_PREM_AMT(p_claim_id, p_peril_cd, p_item_no) TOT_PREM_AMT
                              FROM gipi_polbasic B250,
                                   GICL_CLAIMS   C250,
                                   GIPI_ITMPERIL B380
                             WHERE 1=1
                               AND C250.claim_id    = p_claim_id     
                               AND b380.peril_cd    = p_peril_cd
                               AND b380.item_no     = p_item_no
                               AND B250.line_cd     = C250.line_cd   
                               AND B250.subline_cd  = C250.subline_cd 
                               AND B250.iss_cd      = C250.POL_ISS_CD 
                               AND B250.issue_yy    = C250.ISSUE_YY   
                               AND B250.pol_seq_no  = C250.POL_SEQ_NO 
                               AND B250.renew_no    = C250.renew_no  
                               AND B250.pol_flag   IN ('1','2','3','X' )
                               AND TRUNC(DECODE(b250.eff_date, 
                                                b250.incept_date, C250.pol_eff_date, 
                                                b250.eff_date)) <= C250.loss_date    
                               AND TRUNC(DECODE(b250.expiry_date,
                                                NVL(b250.endt_expiry_date,b250.expiry_date), C250.expiry_date,  
                                                b250.endt_expiry_date)) >= TRUNC(C250.loss_date)               
                               AND b250.dist_flag   = '3'
                               AND b380.policy_id   = b250.policy_id
                             GROUP BY b250.policy_id) A1
                     WHERE 1=1 
                       AND c.item_no          = b.item_no
                       AND c.policy_id        = b.policy_id
                       AND c.item_grp         = d.item_grp
                       AND c.policy_id        = d.policy_id
                       AND b.peril_cd         = p_peril_cd
                       AND b.item_no          = p_item_no
                       AND c.policy_id        = A1.policy_id
                       AND a10.prem_seq_no  =  d.prem_seq_no   
                       AND a10.iss_cd       =  d.iss_cd       
                       AND a10.policy_id    =  A1.policy_id    
                     GROUP BY d.item_grp,d.iss_cd,d.prem_seq_no, A1.policy_id, A1.tot_prem_amt
                             ,a10.intrmdry_intm_no, a10.share_percentage) A2
             GROUP BY A2.INTRMDRY_INTM_NO, A2.share_percentage)
    LOOP     
       v_total := v_total + rec.share_percentage;
       
       IF rec.prem_amt = 0 THEN
          v_check_zero := 'Y';
       END IF;
       
    END LOOP;
    
    IF v_total > 100 AND v_check_zero = 'Y' THEN
        v_check := 'Y'; 
    END IF;
    
      RETURN v_check;
   END;
END gicl_item_peril_pkg;
/
