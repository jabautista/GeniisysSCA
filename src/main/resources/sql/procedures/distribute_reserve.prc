DROP PROCEDURE CPI.DISTRIBUTE_RESERVE;

CREATE OR REPLACE PROCEDURE CPI.DISTRIBUTE_RESERVE (v1_claim_id        gicl_clm_res_hist.claim_id%TYPE,
                                                v1_clm_res_hist_id gicl_clm_res_hist.clm_res_hist_id%TYPE) IS

--Cursor for item/peril loss amount
 CURSOR cur_clm_res IS
   SELECT claim_id, clm_res_hist_id, hist_seq_no,
          item_no, peril_cd, loss_reserve,
          expense_reserve, convert_rate,
          grouped_item_no 
     FROM gicl_clm_res_hist
    WHERE claim_id        = v1_claim_id
      AND clm_res_hist_id = v1_clm_res_hist_id
      FOR UPDATE OF DIST_SW;

--Cursor for peril distribution in underwriting table.
 CURSOR cur_perilds(v_peril_cd      giri_ri_dist_item_v.peril_cd%type,
                    v_item_no       giri_ri_dist_item_v.item_no%type,
                    p_pol_eff_date  gicl_claims.pol_eff_date%TYPE,
                    p_loss_date     gicl_claims.loss_date%TYPE,
                    p_expiry_date   gicl_claims.expiry_date%TYPE,
                    p_line_cd       gicl_claims.line_cd%TYPE,
                    p_subline_cd    gicl_claims.subline_cd%TYPE,
                    p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
                    p_issue_yy      gicl_claims.issue_yy%TYPE,
                    p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
                    p_renew_no      gicl_claims.renew_no%TYPE) IS
   SELECT d.share_cd, f.share_type, f.trty_yy,
          f.prtfolio_sw, f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi,
          f.expiry_date
     FROM gipi_polbasic a, gipi_item b,
          giuw_pol_dist c, giuw_itemperilds_dtl d,
            giis_dist_share f, giis_parameters e
    WHERE f.share_cd   = d.share_cd
      AND f.line_cd    = d.line_cd
      AND d.peril_cd   = v_peril_cd
      AND d.item_no    = v_item_no
      AND d.item_no    = b.item_no
      AND d.dist_no    = c.dist_no
      AND e.param_type = 'V'
      AND c.dist_flag  = e.param_value_v
      AND e.param_name = 'DISTRIBUTED'
      AND c.policy_id  = b.policy_id
      AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
          DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_pol_eff_date, a.eff_date ),c.eff_date)) 
          <= p_loss_date 
      AND TRUNC(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),DECODE(NVL(a.endt_expiry_date, a.expiry_date),
          a.expiry_date, p_expiry_date, a.endt_expiry_date), c.expiry_date))  
          >= p_loss_date
--      AND trunc(c.eff_date) <= trunc(:cg$ctrl.loss_date)
--      AND trunc(a.expiry_date) >= trunc(:cg$ctrl.loss_date)
      AND b.policy_id  = a.policy_id
      AND a.pol_flag   IN ('1','2','3','X')
      AND a.line_cd    = p_line_cd
      AND a.subline_cd = p_subline_cd
      AND a.iss_cd     = p_pol_iss_cd
      AND a.issue_yy   = p_issue_yy
      AND a.pol_seq_no = p_pol_seq_no
      AND a.renew_no   = p_renew_no
 GROUP BY a.line_cd, a.subline_cd, a.iss_cd,
          a.issue_yy, a.pol_seq_no, a.renew_no,
          d.share_cd, f.share_type, f.trty_yy,
          f.acct_trty_type, d.item_no, d.peril_cd,
          f.prtfolio_sw, f.expiry_date;

--Cursor for peril distribution in treaty table.
 CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%TYPE,
                 v_trty_yy  giis_dist_share.trty_yy%TYPE,
                 p_line_cd  gicl_claims.line_cd%TYPE) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM giis_trty_panel
    WHERE line_cd     = p_line_cd
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;

--Cursor for peril distribution in ri table.
 CURSOR cur_frperil(v_peril_cd giri_ri_dist_item_v.peril_cd%TYPE,
                    v_item_no  giri_ri_dist_item_v.item_no%TYPE,
                    p_expiry_date   gicl_claims.expiry_date%TYPE,
                    p_loss_date     gicl_claims.loss_date%TYPE,
                    p_pol_eff_date  gicl_claims.pol_eff_date%TYPE,
                    p_issue_yy      gicl_claims.issue_yy%TYPE,
                    p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
                    p_renew_no      gicl_claims.renew_no%TYPE,
                    p_line_cd       gicl_claims.line_cd%TYPE,
                    p_subline_cd    gicl_claims.subline_cd%TYPE,
                    p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE)IS
   SELECT t2.ri_cd,
          SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt 
     FROM gipi_polbasic    t5, gipi_itmperil    t8, giuw_pol_dist    t4,
          giuw_itemperilds t6, giri_distfrps    t3, giri_frps_ri     t2       
    WHERE 1                       = 1
      AND t5.line_cd              = p_line_cd
      AND t5.subline_cd           = p_subline_cd
      AND t5.iss_cd               = p_pol_iss_cd
      AND t5.issue_yy             = p_issue_yy
      AND t5.pol_seq_no           = p_pol_seq_no
      AND t5.renew_no             = p_renew_no
      AND t5.pol_flag             IN ('1','2','3','X')   
      AND t5.policy_id            = t8.policy_id
      AND t8.peril_cd             = v_peril_cd
      AND t8.item_no              = v_item_no
      AND t5.policy_id            = t4.policy_id   
      AND TRUNC(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
          DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), p_pol_eff_date, t5.eff_date ),t4.eff_date)) 
          <= p_loss_date 
      AND TRUNC(DECODE(TRUNC(t4.expiry_date),TRUNC(t5.expiry_date),
          DECODE(NVL(t5.endt_expiry_date, t5.expiry_date),
          t5.expiry_date, p_expiry_date, t5.endt_expiry_date),t4.expiry_date))
          >= p_loss_date       
      AND t4.dist_flag            = '3'
      AND t4.dist_no              = t6.dist_no
      AND t8.item_no              = t6.item_no
      AND t8.peril_cd             = t6.peril_cd
      AND t4.dist_no              = t3.dist_no
      AND t6.dist_seq_no          = t3.dist_seq_no
      AND t3.line_cd              = t2.line_cd
      AND t3.frps_yy              = t2.frps_yy
      AND t3.frps_seq_no          = t2.frps_seq_no
      AND NVL(t2.reverse_sw, 'N') = 'N'
      AND NVL(t2.delete_sw, 'N')  = 'N'
      AND t3.ri_flag              = '2'   
     GROUP BY  t2.ri_cd;
  
  sum_tsi_amt           giri_basic_info_item_sum_v.tsi_amt%TYPE;
  ann_ri_pct            NUMBER(12,9);
  ann_dist_spct         gicl_reserve_ds.shr_pct%type := 0;
  me                    NUMBER := 0;
  v_facul_share_cd      giuw_perilds_dtl.share_cd%TYPE;
  v_trty_share_type     giis_dist_share.share_type%TYPE;
  v_facul_share_type    giis_dist_share.share_type%TYPE;
  v_loss_res_amt        gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_exp_res_amt         gicl_reserve_ds.shr_exp_res_amt%TYPE;
  v_trty_limit          giis_dist_share.trty_limit%TYPE;
  v_facul_amt           gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_net_amt             gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_treaty_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_qs_shr_pct          giis_dist_share.qs_shr_pct%TYPE;
  v_acct_trty_type      giis_dist_share.acct_trty_type%TYPE;
  v_share_cd            giis_dist_share.share_cd%TYPE;
  v_policy              VARCHAR2(2000);
  counter               NUMBER := 0;
  v_switch              NUMBER := 0;
  v_policy_id           NUMBER;
  v_clm_dist_no         NUMBER:=0;
  v_peril_sname         giis_peril.peril_sname%TYPE;
  v_trty_peril          giis_peril.peril_sname%TYPE;  
  v_share_exist         VARCHAR2(1);
  v_pol_eff_date        GICL_CLAIMS.POL_EFF_DATE%TYPE;
  v_loss_date           GICL_CLAIMS.LOSS_DATE%TYPE;
  v_expiry_date         GICL_CLAIMS.EXPIRY_DATE%TYPE;
  v_line_cd             GICL_CLAIMS.LINE_CD%TYPE;             
  v_subline_cd          GICL_CLAIMS.SUBLINE_CD%TYPE;
  v_pol_iss_cd          GICL_CLAIMS.POL_ISS_CD%TYPE;
  v_issue_yy            GICL_CLAIMS.ISSUE_YY%TYPE;
  v_pol_seq_no          GICL_CLAIMS.POL_SEQ_NO%TYPE;
  v_renew_no            GICL_CLAIMS.RENEW_NO%TYPE;
  v_catastrophic_cd     GICL_CLAIMS.CATASTROPHIC_CD%TYPE;
  v_message             VARCHAR2(500);
      
BEGIN

 FOR gc IN (
    SELECT * FROM gicl_claims WHERE claim_id = v1_claim_id
 ) LOOP
    v_pol_eff_date      := gc.pol_eff_date;
    v_loss_date         := gc.loss_date;
    v_expiry_date       := gc.expiry_date;
    v_line_cd           := gc.line_cd;
    v_subline_cd        := gc.subline_cd;
    v_pol_iss_cd        := gc.pol_iss_cd;
    v_issue_yy          := gc.issue_yy;
    v_pol_seq_no        := gc.pol_seq_no;
    v_renew_no          := gc.renew_no;
 END LOOP;

 v_clm_dist_no := 1;  

 FOR c1 in cur_clm_res LOOP        /*Using Item-peril cursor */
  BEGIN
   SELECT param_value_n
     INTO v_facul_share_cd
     FROM giis_parameters
    WHERE param_name = 'FACULTATIVE';
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        --MSG_ALERT('There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.','I',TRUE);
        v_message := 'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table';
   END;

   BEGIN
     SELECT param_value_v
       INTO v_trty_share_type
       FROM giac_parameters
      WHERE param_name = 'TRTY_SHARE_TYPE';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         --MSG_ALERT('There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table.','I',TRUE);
         v_message := 'There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table';
   END;

   BEGIN
     SELECT param_value_v
       INTO v_facul_share_type
       FROM giac_parameters
      WHERE param_name = 'FACUL_SHARE_TYPE';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         --MSG_ALERT('There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table.','I',TRUE);
         v_message := 'There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table';
   END;

   BEGIN
     SELECT param_value_n
       INTO v_acct_trty_type
       FROM giac_parameters
      WHERE param_name = 'QS_ACCT_TRTY_TYPE';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         --MSG_ALERT('There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table.','I',TRUE);
         v_message := 'There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table';
   END;

   BEGIN
     SELECT sum(a.tsi_amt)
       INTO sum_tsi_amt
       FROM giri_basic_info_item_sum_v a, giuw_pol_dist b
      WHERE a.policy_id = b.policy_id
        --AND trunc(a.eff_date) <= trunc(:cg$ctrl.loss_date)
        --AND trunc(a.expiry_date) >= trunc(:cg$ctrl.loss_date)
        AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date),
            DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), v_pol_eff_date, a.eff_date ),b.eff_date)) 
            <= v_loss_date 
        AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date),
            DECODE(NVL(a.endt_expiry_date, a.expiry_date),
            a.expiry_date, v_expiry_date, a.endt_expiry_date), b.expiry_date)) 
            >= v_loss_date
        AND a.item_no    = c1.item_no
        AND a.peril_cd   = c1.peril_cd
        AND a.line_cd    = v_line_cd
        AND a.subline_cd = v_subline_cd
        AND a.iss_cd     = v_pol_iss_cd
        AND a.issue_yy   = v_issue_yy
        AND a.pol_seq_no = v_pol_seq_no
        AND a.renew_no   = v_renew_no
        AND b.dist_flag  = (SELECT param_value_v
                              FROM giis_parameters
                             WHERE param_name = 'DISTRIBUTED');
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        --msg_alert('The TSI for this policy is Zero...','I',TRUE);
        v_message := 'The TSI for this policy is Zero...';
   END;

   DECLARE
     CURSOR QUOTA_SHARE_TREATIES IS
       SELECT trty_limit, qs_shr_pct, share_cd
         FROM giis_dist_share
        WHERE line_cd        = v_line_cd
          AND eff_date       <= SYSDATE
          AND expiry_date    >= SYSDATE
          AND acct_trty_type = v_acct_trty_type
          AND qs_shr_pct     IS NOT NULL;
   BEGIN
     FOR QUOTA_SHARE_REC IN QUOTA_SHARE_TREATIES LOOP
       BEGIN
         SELECT QUOTA_SHARE_REC.TRTY_LIMIT,
                QUOTA_SHARE_REC.QS_SHR_PCT,
                QUOTA_SHARE_REC.SHARE_CD
           INTO v_trty_limit, v_qs_shr_pct, v_share_cd
           FROM DUAL;
         EXCEPTION
           WHEN OTHERS THEN
             NULL;
       END;
     END LOOP;
   END;

   FOR me IN cur_perilds(c1.peril_cd, c1.item_no,v_pol_eff_date,v_loss_date,v_expiry_date,v_line_cd,v_subline_cd,v_pol_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no) LOOP
     IF me.acct_trty_type = v_acct_trty_type THEN
        v_switch  := 1;
     ELSIF ((me.acct_trty_type = v_acct_trty_type) OR
        (me.acct_trty_type IS NULL)) AND (v_switch <> 1) THEN
         v_switch := 0;
     END IF;
   END LOOP;
   
   SELECT pol_eff_date,loss_date,expiry_date,line_cd,subline_cd,pol_iss_cd,issue_yy,pol_seq_no,renew_no,catastrophic_cd
     INTO v_pol_eff_date,v_loss_date,v_expiry_date,v_line_cd,v_subline_cd,v_pol_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no,v_catastrophic_cd
     FROM gicl_claims
    WHERE claim_id = v1_claim_id;

   SELECT peril_sname
     INTO v_peril_sname
     FROM giis_peril
    WHERE peril_cd = c1.peril_cd
      AND line_cd  = v_line_cd;
 
   SELECT param_value_v
     INTO v_trty_peril
     FROM giac_parameters
    WHERE param_name = 'TRTY_PERIL';

   IF v_peril_sname = v_trty_peril THEN
     SELECT param_value_n
       INTO v_trty_limit
       FROM giac_parameters
      WHERE param_name = 'TRTY_PERIL_LIMIT';
   END IF;     

   IF sum_tsi_amt > v_trty_limit THEN 
      FOR I IN CUR_PERILDS(C1.PERIL_CD, C1.ITEM_NO,v_pol_eff_date,v_loss_date,v_expiry_date,v_line_cd,v_subline_cd,v_pol_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no) LOOP
        IF I.SHARE_TYPE = V_FACUL_SHARE_TYPE THEN
           v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi/sum_tsi_amt);
        END IF;
      END LOOP;
      v_net_amt    := (sum_tsi_amt - NVL(v_facul_amt,0))* ((100 - v_qs_shr_pct)/100);  
      v_treaty_amt := (sum_tsi_amt - NVL(v_facul_amt,0))* (v_qs_shr_pct/100);  
   ELSE
      v_net_amt    := sum_tsi_amt * ((100 - v_qs_shr_pct)/100);
      v_treaty_amt := sum_tsi_amt * (v_qs_shr_pct/100);     
   END IF;


/*Start of distribution - Marge 4-15-2k*/
  /* modified by mon
  ** date modified: apr. 24, 2002
  ** description:validates prtfolio_sw before inserting and updating */
   FOR c2 in cur_perilds(c1.peril_cd,c1.item_no,v_pol_eff_date,v_loss_date,v_expiry_date,v_line_cd,v_subline_cd,v_pol_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no) LOOP /*Underwriting peril distribution*/
     IF c2.share_type = v_trty_share_type THEN
       DECLARE 
         v_share_cd     giis_dist_share.share_cd%TYPE := c2.share_cd;
         v_treaty_yy2   giis_dist_share.trty_yy%TYPE  := c2.trty_yy;
         v_prtf_sw      giis_dist_share.prtfolio_sw%TYPE;
         v_acct_trty    giis_dist_share.acct_trty_type%TYPE;
         v_share_type   giis_dist_share.share_type%TYPE;
         v_expiry_date  giis_dist_share.expiry_date%TYPE;
       BEGIN               
         IF NVL(c2.prtfolio_sw, 'N') = 'P'
           --AND c2.trty_yy <> to_number(TO_CHAR(SYSDATE,'YY')) THEN    
             AND TRUNC(c2.expiry_date) < TRUNC(sysdate) THEN    
            --WHILE v_treaty_yy2 <> to_number(TO_CHAR(SYSDATE,'YY')) 
           WHILE TRUNC(c2.expiry_date) < TRUNC(sysdate)
               LOOP
               BEGIN
                   SELECT share_cd, trty_yy, NVL(prtfolio_sw, 'N'),
                          acct_trty_type, share_type, expiry_date 
                     INTO v_share_cd, v_treaty_yy2, v_prtf_sw,
                          v_acct_trty, v_share_type, v_expiry_date
                     FROM giis_dist_share
                    WHERE line_cd            = v_line_cd
                      AND old_trty_seq_no =  c2.share_cd;                    
                 EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                       --MSG_ALERT('No new treaty set-up for year'|| to_char(sysdate,'YYYY'), 'I', true);
                       v_message := 'No new treaty set-up for year '|| to_char(sysdate,'YYYY');
                     EXIT;
                     WHEN TOO_MANY_ROWS THEN
                       --MSG_ALERT('Too many treaty set-up for year'|| to_char(sysdate,'YYYY'), 'I', true);   
                       v_message := 'Too many treaty set-up for year '|| to_char(sysdate,'YYYY');
               END;
               c2.share_cd       := v_share_cd;
               c2.share_type     := v_share_type;
               c2.acct_trty_type := v_acct_trty;  
               c2.trty_yy        := v_treaty_yy2;                    
               c2.expiry_date    := v_expiry_date;
               IF v_prtf_sw = 'N' THEN
                    EXIT;
               END IF;
            END LOOP;
          END IF;
        END;
      END IF;
     
     ann_dist_spct := 0;
     IF ((c2.acct_trty_type <> v_acct_trty_type) OR
           (c2.acct_trty_type IS NULL)) AND
           v_switch = 0 THEN 
        ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
        v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
        v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
     ELSE
        IF (c2.share_type = v_trty_share_type) AND (c2.share_cd = v_share_cd) THEN
           ann_dist_spct  := (v_treaty_amt/sum_tsi_amt) * 100;
           v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
           v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
        ELSIF (c2.share_type != v_trty_share_type) AND  (c2.share_type != v_facul_share_type)
           AND (v_net_amt IS NOT NULL) THEN
           ann_dist_spct  := (v_net_amt/sum_tsi_amt) * 100;
           v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
          v_exp_res_amt   := c1.expense_reserve * ann_dist_spct/100;
        ELSE
           ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
           v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
           v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
        END IF;
     END IF;

/* checks if share_cd is already existing if existing updates gicl_reserve_ds
** if not existing then inserts record to gicl_reserve_ds*/
    v_share_exist := 'N';
    FOR i IN
      (SELECT '1'
         FROM gicl_reserve_ds
        WHERE claim_id        = c1.claim_id
          AND hist_seq_no     = c1.hist_seq_no
          AND item_no         = c1.item_no
          AND grouped_item_no = c1.grouped_item_no
          AND peril_cd        = c1.peril_cd
          AND grp_seq_no      = c2.share_cd
          AND line_cd         = v_line_cd)
    LOOP
      v_share_exist :='Y';
    END LOOP;

    IF ann_dist_spct <> 0 THEN
       IF v_share_exist = 'N' THEN
          INSERT INTO gicl_reserve_ds(claim_id,         clm_res_hist_id, dist_year,
                                      clm_dist_no,      item_no,         peril_cd,
                                      grp_seq_no,       share_type,      shr_pct,
                                      shr_loss_res_amt, shr_exp_res_amt, line_cd, 
                                      acct_trty_type,   user_id,         last_update,
                                      hist_seq_no,
                                      grouped_item_no)
                              VALUES (c1.claim_id,       c1.clm_res_hist_id, to_char(sysdate,'YYYY'),
                                      v_clm_dist_no,     c1.item_no,         c1.peril_cd,
                                      c2.share_cd,       c2.share_type,      ann_dist_spct,
                                      v_loss_res_amt,    v_exp_res_amt,      v_line_cd,
                                      c2.acct_trty_type, user,               sysdate,
                                      c1.hist_seq_no,
                                      c1.grouped_item_no);
        ELSE
          UPDATE gicl_reserve_ds
             SET shr_pct          = NVL(shr_pct,0) + NVL(ann_dist_spct,0),
                 shr_loss_res_amt = NVL(shr_loss_res_amt,0) + NVL(v_loss_res_amt,0),
                 shr_exp_res_amt  = NVL(shr_exp_res_amt,0) + NVL(v_exp_res_amt,0)
           WHERE claim_id         = c1.claim_id
             AND hist_seq_no      = c1.hist_seq_no
             AND item_no          = c1.item_no
             AND grouped_item_no  = c1.grouped_item_no
             AND peril_cd         = c1.peril_cd
             AND grp_seq_no       = c2.share_cd
             AND line_cd          = v_line_cd;
       END IF;

       me := to_number(c2.share_type) - to_number(v_trty_share_type);

       IF me = 0 THEN
          FOR c_trty in cur_trty(c2.share_cd, c2.trty_yy,v_line_cd) LOOP
            IF v_share_exist = 'N' THEN 
               INSERT INTO gicl_reserve_rids(claim_id,                 clm_res_hist_id,  dist_year,
                                             clm_dist_no,        item_no,          peril_cd, 
                                             grp_seq_no,         share_type,       ri_cd,
                                             shr_ri_pct,         shr_ri_pct_real,  shr_loss_ri_res_amt,
                                             shr_exp_ri_res_amt, line_cd,          acct_trty_type,
                                             prnt_ri_cd,         hist_seq_no,
                                             grouped_item_no)
                                           VALUES(c1.claim_id,       c1.clm_res_hist_id, to_char(sysdate,'YYYY'),
                                                  v_clm_dist_no,     c1.item_no, c1.peril_cd,
                                                 c2.share_cd,       v_trty_share_type, c_trty.ri_cd,
                                                 (ann_dist_spct  * c_trty.trty_shr_pct/100), c_trty.trty_shr_pct, (v_loss_res_amt * c_trty.trty_shr_pct/100), 
                                                 (v_exp_res_amt  * c_trty.trty_shr_pct/100), v_line_cd, c2.acct_trty_type,
                                                 c_trty.prnt_ri_cd, c1.hist_seq_no,
                                                 c1.grouped_item_no);
            ELSE 
              UPDATE gicl_reserve_rids
                 SET shr_exp_ri_res_amt  = NVL(shr_exp_ri_res_amt,0) + (NVL(v_exp_res_amt,0)* c_trty.trty_shr_pct/100),
                     shr_loss_ri_res_amt = NVL(shr_loss_ri_res_amt,0) + (NVL(v_loss_res_amt,0)* c_trty.trty_shr_pct/100),
                     shr_ri_pct          = NVL(shr_ri_pct,0) + (NVL(ann_dist_spct,0)* c_trty.trty_shr_pct/100)
               WHERE claim_id            = c1.claim_id
                 AND hist_seq_no         = c1.hist_seq_no
                 AND item_no             = c1.item_no
                 AND grouped_item_no     = c1.grouped_item_no
                 AND peril_cd            = c1.peril_cd
                 AND grp_seq_no          = c2.share_cd
                 AND ri_cd               = c_trty.ri_cd
                 AND line_cd             = v_line_cd;
            END IF;           
          END LOOP; /*end of c_trty loop*/
          
       ELSIF c2.share_type = v_facul_share_type THEN
          FOR c3 IN cur_frperil(c1.peril_cd,c1.item_no,v_expiry_date,v_loss_date,v_pol_eff_date,v_issue_yy,v_pol_seq_no,v_renew_no,v_line_cd,v_subline_cd,v_pol_iss_cd) LOOP /*RI peril distribution*/
            IF (c2.acct_trty_type <> v_acct_trty_type) OR (c2.acct_trty_type IS NULL) THEN
               ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
            ELSE
               ann_ri_pct := (v_facul_amt /sum_tsi_Amt) * 100;
            END IF; 
            INSERT INTO gicl_reserve_rids(claim_id,           clm_res_hist_id,    dist_year,
                                          clm_dist_no,        item_no,            peril_cd,
                                          grp_seq_no,         share_type,         ri_cd, 
                                          shr_ri_pct,         shr_ri_pct_real,    shr_loss_ri_res_amt, 
                                          shr_exp_ri_res_amt, line_cd,            acct_trty_type,
                                          prnt_ri_cd,         hist_seq_no,        grouped_item_no)
                                   VALUES(c1.claim_id,        c1.clm_res_hist_id, to_char(sysdate, 'YYYY'), 
                                          v_clm_dist_no,      c1.item_no,         c1.peril_cd,
                                          c2.share_cd,        v_facul_share_type, c3.ri_cd,
                                          ann_ri_pct,         ann_ri_pct*100/ann_dist_spct,   (c1.loss_reserve * ann_ri_pct/100),
                                          (c1.expense_reserve * ann_ri_pct/100), v_line_cd, c2.acct_trty_type, 
                                          c3.ri_cd,           c1.hist_seq_no,
                                          c1.grouped_item_no);
          END LOOP; /*End of c3 loop */
       END IF;
    ELSE 
       NULL;
    END IF;
  END LOOP; /*End of c2 loop*/

--EXCESS OF LOSS    
  DECLARE
    v_retention                     gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_retention_orig                gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_running_retention             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_total_retention               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_allowed_retention             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_total_xol_share               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_overall_xol_share             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_overall_allowed_share         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_old_xol_share                 gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;        
    v_allowed_ret                   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    v_shr_pct                       gicl_reserve_ds.shr_pct%TYPE;

  BEGIN    
    IF v_catastrophic_cd IS NULL THEN
       FOR NET_SHR IN 
        (SELECT (shr_loss_res_amt * c1.convert_rate) loss_reserve, 
                  (shr_exp_res_amt* c1.convert_rate) exp_reserve, 
                  shr_pct
           FROM gicl_reserve_ds
          WHERE claim_id        = c1.claim_id
            AND hist_seq_no     = c1.hist_seq_no
            AND grouped_item_no = c1.grouped_item_no
            AND item_no         = c1.item_no
            AND peril_cd        = c1.peril_cd
            AND share_type      = '1')        
         LOOP
             v_retention  := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
         v_retention_orig := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
           FOR TOT_NET IN
             (SELECT SUM(NVL(a.shr_loss_res_amt,0) + NVL( a.shr_exp_res_amt,0)) ret_amt
                FROM gicl_reserve_ds a, gicl_item_peril b
               WHERE a.claim_id                = c1.claim_id
                 AND a.claim_id                = b.claim_id
                 AND a.grouped_item_no         = b.grouped_item_no
                 AND a.item_no                 = b.item_no
                 AND a.peril_cd                = b.peril_cd
                 AND NVL(b.close_flag, 'AP')   IN ('AP','CC','CP')
                 AND NVL(a.negate_tag,'N')     = 'N'
                 AND a.share_type              = '1'
                 AND (a.item_no  <> c1.item_no
                  OR a.peril_cd <> c1.peril_cd ))
         LOOP
           v_total_retention := v_retention + NVL(tot_net.ret_amt,0);
         END LOOP;          
         FOR CHK_XOL IN
           (SELECT a.share_cd,   acct_trty_type,  xol_allowed_amount,
                   xol_base_amount, xol_reserve_amount, trty_yy,
                   xol_aggregate_sum, a.line_cd, a.share_type
              FROM giis_dist_share a, giis_trty_peril b
             WHERE a.line_cd            = b.line_cd
               AND a.share_cd           = b.trty_seq_no
               AND a.share_type         = '4'
               AND TRUNC(a.eff_date)    <= TRUNC(v_loss_date)
               AND TRUNC(a.expiry_date) >= TRUNC(v_loss_date)
               AND b.peril_cd           = c1.peril_cd             
               AND a.line_cd            = v_line_cd                
             ORDER BY xol_base_amount ASC)
           LOOP
               v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
               IF v_allowed_retention < 1 THEN             
                   EXIT;
               END IF;
               FOR get_all_xol IN
                 (SELECT SUM(NVL(a.shr_loss_res_amt,0) + NVL( a.shr_exp_res_amt,0)) ret_amt
                    FROM gicl_reserve_ds a, gicl_item_peril b
                   WHERE NVL(a.negate_tag,'N')   = 'N'
                     AND a.item_no               = b.item_no
                     AND a.grouped_item_no       = b.grouped_item_no
                     AND a.peril_cd              = b.peril_cd
                     AND a.claim_id              = b.claim_id
                     AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                     AND a.grp_seq_no            = chk_xol.share_cd
                     AND a.line_cd               = chk_xol.line_cd)
             LOOP
               v_overall_xol_share := chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
             END LOOP;     
             IF v_allowed_retention > v_overall_xol_share THEN
                   v_allowed_retention := v_overall_xol_share;
             END IF;           
               IF v_allowed_retention > v_retention THEN
                    v_allowed_retention := v_retention;     
               END IF;     
               v_total_xol_share := 0;
               v_old_xol_share   := 0;
               FOR TOTAL_XOL IN
                 (SELECT SUM(NVL(a.shr_loss_res_amt,0) + NVL( a.shr_exp_res_amt,0)) ret_amt
                    FROM gicl_reserve_ds a, gicl_item_peril b
                   WHERE a.claim_id              = c1.claim_id
                     AND a.claim_id              = b.claim_id
                     AND a.grouped_item_no       = b.grouped_item_no
                     AND a.item_no               = b.item_no
                     AND a.peril_cd              = b.peril_cd
                     AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                     AND NVL(a.negate_tag,'N')   = 'N'
                     AND a.grp_seq_no            = chk_xol.share_cd)
             LOOP
                 v_total_xol_share := NVL(total_xol.ret_amt,0);
                 v_old_xol_share   := NVL(total_xol.ret_amt,0);              
             END LOOP;

             IF v_total_xol_share <= chk_xol.xol_allowed_amount THEN
                v_total_xol_share := chk_xol.xol_allowed_amount - v_total_xol_share;
             END IF;

             IF v_total_xol_share >= v_allowed_retention THEN
                v_total_xol_share := v_allowed_retention;
             END IF;                    

             IF v_total_xol_share <> 0 THEN
                v_shr_pct           := v_total_xol_share/v_retention_orig;
                v_running_retention := v_running_retention + v_total_xol_share;      
                INSERT INTO gicl_reserve_ds (claim_id,         clm_res_hist_id, dist_year, 
                                             clm_dist_no,      item_no,         peril_cd,
                                             grp_seq_no,       share_type,      shr_pct, 
                                             shr_loss_res_amt, shr_exp_res_amt, line_cd,
                                             acct_trty_type,   user_id,         last_update,
                                             hist_seq_no,
                                             grouped_item_no)
                                     VALUES (c1.claim_id,            c1.clm_res_hist_id, TO_CHAR(SYSDATE,'YYYY'), 
                                             v_clm_dist_no,          c1.item_no,         c1.peril_cd,
                                             chk_xol.share_cd,       chk_xol.share_type, net_shr.shr_pct * v_shr_pct,
                                             net_shr.loss_reserve * v_shr_pct, net_shr.exp_reserve * v_shr_pct, v_line_cd,
                                             chk_xol.acct_trty_type, user,               sysdate,
                                             c1.hist_seq_no,
                                             c1.grouped_item_no);                 
                FOR update_xol_trty IN
                    (SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
                       FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
                      WHERE NVL(a.negate_tag,'N')   = 'N'
                        AND a.claim_id              = b.claim_id
                        AND a.clm_res_hist_id       = b.clm_res_hist_id
                        AND a.claim_id              = c.claim_id
                        AND a.grouped_item_no       = c.grouped_item_no
                        AND a.item_no               = c.item_no
                        AND a.peril_cd              = c.peril_cd                       
                        AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
                        AND a.grp_seq_no            = chk_xol.share_cd
                        AND a.line_cd               = chk_xol.line_cd)
                LOOP
                  UPDATE giis_dist_share 
                     SET xol_reserve_amount = update_xol_trty.ret_amt
                   WHERE share_cd = chk_xol.share_cd
                     AND line_cd  = chk_xol.line_cd;
                END LOOP;    
                FOR xol_trty IN
                  cur_trty(chk_xol.share_cd, chk_xol.trty_yy,v_line_cd) 
                LOOP
                  INSERT INTO gicl_reserve_rids (claim_id,           clm_res_hist_id, dist_year,
                                                 clm_dist_no,        item_no,         peril_cd,
                                                 grp_seq_no,         share_type,      ri_cd,
                                                 shr_ri_pct,         shr_ri_pct_real, shr_loss_ri_res_amt,
                                                 shr_exp_ri_res_amt, line_cd,         acct_trty_type, 
                                                 prnt_ri_cd,         hist_seq_no,
                                                 grouped_item_no)
                                             VALUES (c1.claim_id,         c1.clm_res_hist_id, TO_CHAR(SYSDATE,'YYYY'),
                                                     v_clm_dist_no,       c1.item_no,         c1.peril_cd,
                                                     chk_xol.share_cd,    chk_xol.share_type, xol_trty.ri_cd,
                                                     ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), xol_trty.trty_shr_pct, ((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100)),
                                                     ((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100)), v_line_cd,   chk_xol.acct_trty_type, 
                                                     xol_trty.prnt_ri_cd, c1.hist_seq_no,
                                                     c1.grouped_item_no);       
                END LOOP;
             END IF;         
             v_retention       := v_retention - v_total_xol_share;
             v_total_retention := v_total_retention +  v_old_xol_share;        
           END LOOP; --CHK_XOL
         END LOOP; -- NET_SHR
      ELSE
         FOR NET_SHR IN 
             (SELECT (shr_loss_res_amt * c1.convert_rate) loss_reserve, 
                     (shr_exp_res_amt* c1.convert_rate) exp_reserve, 
                     shr_pct
                  FROM gicl_reserve_ds
                WHERE claim_id    = c1.claim_id
                   AND hist_seq_no = c1.hist_seq_no
                   AND grouped_item_no = c1.grouped_item_no
                   AND item_no     = c1.item_no
                 AND peril_cd    = c1.peril_cd
                 AND share_type  = '1')        
           LOOP
               v_retention      := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
           v_retention_orig := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
             FOR TOT_NET IN
                  (SELECT SUM(NVL(shr_loss_res_amt,0) + NVL( shr_exp_res_amt,0)) ret_amt
                     FROM gicl_reserve_ds a, gicl_claims c, gicl_item_peril b
                    WHERE a.claim_id              = c.claim_id
                      AND a.claim_id              = b.claim_id
                      AND a.grouped_item_no       = b.grouped_item_no
                      AND a.item_no               = b.item_no
                      AND a.peril_cd              = b.peril_cd
                      AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                      AND c.catastrophic_cd       = v_catastrophic_cd
                      AND NVL(negate_tag,'N')     = 'N'
                      AND share_type              = '1'
                      AND (a.claim_id             <> v1_claim_id
                       OR a.item_no               <> c1.item_no
                       OR a.grouped_item_no       <> c1.grouped_item_no
                       OR a.peril_cd              <> c1.peril_cd))
           LOOP
             v_total_retention := v_retention + NVL(tot_net.ret_amt,0);
           END LOOP;
           FOR CHK_XOL IN
             (SELECT a.share_cd,   acct_trty_type,  xol_allowed_amount,
                     xol_base_amount, xol_reserve_amount, trty_yy,
                     xol_aggregate_sum, a.line_cd, a.share_type
                FROM giis_dist_share a, giis_trty_peril b
               WHERE a.line_cd            = b.line_cd
                 AND a.share_cd           = b.trty_seq_no
                 AND a.share_type         = '4'
                 AND TRUNC(a.eff_date)    <= TRUNC(v_loss_date)
                 AND TRUNC(a.expiry_date) >= TRUNC(v_loss_date)
                 AND b.peril_cd           = c1.peril_cd             
                 AND a.line_cd            = v_line_cd                
               ORDER BY xol_base_amount ASC)
           LOOP
               v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
               IF v_allowed_retention < 1 THEN             
                   EXIT;
               END IF;

               FOR get_all_xol IN
                 (SELECT SUM(NVL(shr_loss_res_amt,0) + NVL( shr_exp_res_amt,0)) ret_amt
                    FROM gicl_reserve_ds a, gicl_item_peril b
                   WHERE NVL(negate_tag,'N')     = 'N'
                     AND a.claim_id              = b.claim_id
                     AND a.grouped_item_no       = b.grouped_item_no
                     AND a.item_no               = b.item_no
                     AND a.peril_cd              = b.peril_cd
                     AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')  
                     AND grp_seq_no              = chk_xol.share_cd
                     AND a.line_cd               = chk_xol.line_cd)
             LOOP     
               v_overall_xol_share := chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
             END LOOP;     

             IF v_allowed_retention > v_overall_xol_share THEN
                v_allowed_retention := v_overall_xol_share;
             END IF;

               IF v_allowed_retention > v_retention THEN
                  v_allowed_retention := v_retention;     
               END IF;     

               v_total_xol_share := 0;
               v_old_xol_share   := 0;
               FOR TOTAL_XOL IN
                 (SELECT SUM(NVL(shr_loss_res_amt,0) + NVL( shr_exp_res_amt,0)) ret_amt
                    FROM gicl_reserve_ds a, gicl_claims c, gicl_item_peril b
                   WHERE c.claim_id              = a.claim_id
                     AND a.claim_id              = b.claim_id
                     AND a.grouped_item_no       = b.grouped_item_no
                     AND a.item_no               = b.item_no
                     AND a.peril_cd              = b.peril_cd
                     AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                     AND c.catastrophic_cd       = v_catastrophic_cd
                     AND NVL(negate_tag,'N')     = 'N'
                     AND grp_seq_no              = chk_xol.share_cd)
             LOOP
                 v_total_xol_share :=NVL(total_xol.ret_amt,0);
                 v_old_xol_share   :=NVL(total_xol.ret_amt,0);              
             END LOOP;

             IF v_total_xol_share <= chk_xol.xol_allowed_amount THEN
                v_total_xol_share := chk_xol.xol_allowed_amount - v_total_xol_share;
             END IF;     
    
             IF v_total_xol_share >= v_allowed_retention THEN
                v_total_xol_share := v_allowed_retention;
             END IF;                    

             IF v_total_xol_share <> 0 THEN
                v_shr_pct           := v_total_xol_share/v_retention_orig;
                v_running_retention := v_running_retention + v_total_xol_share;      
                INSERT INTO gicl_reserve_ds (claim_id,         clm_res_hist_id, dist_year,
                                             clm_dist_no,      item_no,         peril_cd,
                                             grp_seq_no,       share_type,      shr_pct,
                                             shr_loss_res_amt, shr_exp_res_amt, line_cd,
                                             acct_trty_type,   user_id,         last_update,
                                             hist_seq_no,
                                             grouped_item_no)
                                     VALUES (c1.claim_id,            c1.clm_res_hist_id, TO_CHAR(SYSDATE,'YYYY'),
                                             v_clm_dist_no,          c1.item_no, c1.peril_cd,
                                             chk_xol.share_cd,       chk_xol.share_type, net_shr.shr_pct * v_shr_pct,
                                             net_shr.loss_reserve * v_shr_pct, net_shr.exp_reserve * v_shr_pct, v_line_cd,
                                             chk_xol.acct_trty_type, user,               sysdate,
                                             c1.hist_seq_no,
                                             c1.grouped_item_no);                 
                FOR update_xol_trty IN
                    (SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
                       FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
                      WHERE NVL(a.negate_tag,'N')   = 'N'
                        AND a.claim_id              = b.claim_id
                        AND a.clm_res_hist_id       = b.clm_res_hist_id
                        AND a.claim_id              = c.claim_id
                        AND a.grouped_item_no       = c.grouped_item_no
                        AND a.item_no               = c.item_no
                        AND a.peril_cd              = c.peril_cd                       
                        AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
                        AND a.grp_seq_no            = chk_xol.share_cd
                        AND a.line_cd               = chk_xol.line_cd)
                LOOP     
                  UPDATE giis_dist_share
                     SET xol_reserve_amount = update_xol_trty.ret_amt
                   WHERE share_cd = chk_xol.share_cd
                     AND line_cd  = chk_xol.line_cd;
                END LOOP;         
                FOR xol_trty IN
                  cur_trty(chk_xol.share_cd, chk_xol.trty_yy,v_line_cd) 
                LOOP
                  INSERT INTO gicl_reserve_rids (claim_id,           clm_res_hist_id, dist_year,
                                                 clm_dist_no,        item_no,         peril_cd,
                                                 grp_seq_no,         share_type,      ri_cd,
                                                 shr_ri_pct,         shr_ri_pct_real, shr_loss_ri_res_amt,
                                                 shr_exp_ri_res_amt, line_cd,         acct_trty_type,
                                                 prnt_ri_cd,         hist_seq_no,
                                                 grouped_item_no)
                                             VALUES (c1.claim_id,         c1.clm_res_hist_id, TO_CHAR(SYSDATE,'YYYY'),
                                                     v_clm_dist_no,       c1.item_no,         c1.peril_cd, 
                                                     chk_xol.share_cd,    chk_xol.share_type, xol_trty.ri_cd,
                                                     ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                                                     xol_trty.trty_shr_pct,
                                                     ((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100)),
                                                     ((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100)),
                                                     v_line_cd,    chk_xol.acct_trty_type,
                                                     xol_trty.prnt_ri_cd, c1.hist_seq_no,
                                                     c1.grouped_item_no);       
                END LOOP;
             END IF;
             v_retention       := v_retention - v_total_xol_share;
             v_total_retention := v_total_retention +  v_old_xol_share;        
           END LOOP; --CHK_XOL         
         END LOOP; -- NET_SHR         
      END IF;

      IF v_retention = 0 THEN
           DELETE FROM gicl_reserve_ds
            WHERE claim_id        = c1.claim_id
              AND hist_seq_no     = c1.hist_seq_no
              AND grouped_item_no = c1.grouped_item_no
              AND item_no         = c1.item_no
              AND peril_cd        = c1.peril_cd
              AND share_type      = '1';
      ELSIF v_retention <> v_retention_orig THEN          
           UPDATE gicl_reserve_ds
              SET shr_loss_res_amt = shr_loss_res_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
                  shr_exp_res_amt  = shr_exp_res_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
                  shr_pct          =  shr_pct * (v_retention_orig-v_running_retention)/v_retention_orig
            WHERE claim_id         = c1.claim_id
              AND hist_seq_no      = c1.hist_seq_no
              AND grouped_item_no  = c1.grouped_item_no
              AND item_no          = c1.item_no
              AND peril_cd         = c1.peril_cd
              AND share_type       = '1';
        END IF;
    END;

    UPDATE gicl_clm_res_hist
       SET dist_sw = 'Y'
     WHERE current of cur_clm_res;
     --MESSAGE('UPDATED DIST_SW IN DIST_RES'); PAUSE;

    UPDATE gicl_clm_res_hist
       SET dist_sw = 'Y'
     WHERE current of cur_clm_res;
     --MESSAGE('UPDATED DIST_SW IN DIST_RES'); PAUSE;

  END LOOP; /*End of c1 loop */

  --MESSAGE('Distribution Complete.',no_acknowledge);
  v_message := 'Distribution Complete';
  offset_amt(v_clm_dist_no,v1_claim_id, v1_clm_res_hist_id);
  --forms_ddl('COMMIT');
  --CLEAR_MESSAGE;

END;
/


