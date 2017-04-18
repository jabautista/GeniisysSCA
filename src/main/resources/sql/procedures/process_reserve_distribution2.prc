DROP PROCEDURE CPI.PROCESS_RESERVE_DISTRIBUTION2;

CREATE OR REPLACE PROCEDURE CPI.Process_Reserve_Distribution2(p_claim_id     	gicl_claims.claim_id%TYPE,
		  									             p_item_no			gicl_item_peril.item_no%TYPE,
														 p_grouped_item_no  gicl_item_peril.grouped_item_no%TYPE,
													  	 p_peril_cd		    gicl_item_peril.peril_cd%TYPE,
														 p_evaluation_amt   GICL_CLM_RES_HIST.prev_loss_res%TYPE,
                                                      	 p_expense_amt      GICL_CLM_RES_HIST.prev_loss_res%TYPE,
                                                      	 p_clm_res_hist	    GICL_CLM_RES_HIST.clm_res_hist_id%TYPE,
													  	 p_hist_seq_no      GICL_CLM_RES_HIST.hist_seq_no%TYPE,
  													  	 p_line_cd	  	 	gipi_polbasic.line_cd%TYPE,
													  	 p_subline_cd	  	gipi_polbasic.subline_cd%TYPE,
  													  	 p_iss_cd	  	 	gipi_polbasic.iss_cd%TYPE,
  													  	 p_issue_yy  	 	gipi_polbasic.issue_yy%TYPE,
  													  	 p_pol_seq_no	    gipi_polbasic.pol_seq_no%TYPE,
  													  	 p_renew_no	   	    gipi_polbasic.renew_no%TYPE,
  													  	 p_pol_eff_date	    gicl_claims.pol_eff_date%TYPE,
  													  	 p_expiry_date	  	gicl_claims.expiry_date%TYPE,
  													  	 p_loss_date	  	gicl_claims.loss_date%TYPE,
  													  	 p_file_date	  	gicl_claims.clm_file_date%TYPE,
														 p_cat_cd           gicl_claims.catastrophic_cd%TYPE)IS
  --indicate if distribution is portfolio or natural expiry
  v_prtf_sw     	NUMBER := 0;
  --temp. storage of loss_reserve amount for gicl_claims update
  v_loss_amt			   gicl_claims.loss_res_amt%TYPE;
  v_exp_amt		           gicl_claims.exp_res_amt%TYPE;   --temp. storage of exp_reserve amount for gicl_claims update
  sum_tsi_amt              giri_basic_info_item_sum_v.tsi_amt%TYPE;
  ann_ri_pct               NUMBER(12,9);
  ann_dist_spct            gicl_reserve_ds.shr_pct%TYPE := 0;
  me                       NUMBER := 0;
  v_facul_share_cd 		   giuw_perilds_dtl.share_cd%TYPE := Giisp.v('FACULTATIVE');
  v_trty_share_type        giis_dist_share.share_type%TYPE := Giacp.v('TRTY_SHARE_TYPE');
  v_facul_share_type       giis_dist_share.share_type%TYPE := Giacp.v('FACUL_SHARE_TYPE');
  v_loss_res_amt           gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_exp_res_amt            gicl_reserve_ds.shr_exp_res_amt%TYPE;
  v_trty_limit			   giis_dist_share.trty_limit%TYPE;
  v_facul_amt			   gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_net_amt				   gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_treaty_amt			   gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_qs_shr_pct			   giis_dist_share.qs_shr_pct%TYPE;
  v_acct_trty_type		   giis_dist_share.acct_trty_type%TYPE := Giacp.v('QS_ACCT_TRTY_TYPE');
  v_share_cd               giis_dist_share.share_cd%TYPE;
  v_policy				   VARCHAR2(2000);
  counter				   NUMBER := 0;
  v_switch				   NUMBER := 0;
  v_policy_id			   NUMBER;
  v_clm_dist_no            NUMBER:=0;
  v_peril_sname			   giis_peril.peril_sname%TYPE;
  v_trty_peril             giis_peril.peril_sname%TYPE := Giacp.v('TRTY_PERIL');
  --switch to determine if shate_cd is already existing
  v_share_exist            VARCHAR2(1);
  --this variable will be used to store the value of distributed distribution flag
  v_dist_param             giis_parameters.param_value_v%TYPE := Giisp.v('DISTRIBUTED');
  --the following variable would be used in XOL distribution porcessing
  v_retention			   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_retention_orig		   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_running_retention	   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_total_retention		   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_allowed_retention 	   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_total_xol_share		   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_overall_xol_share	   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_overall_allowed_share  gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_old_xol_share		   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_allowed_ret			   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_shr_pct				   gicl_reserve_ds.shr_pct%TYPE;
  --  offsetting variables
  offset_loss  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_exp  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_loss1  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_exp1  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  --Cursor for item/peril loss amount
  CURSOR cur_clm_res IS
   SELECT claim_id, clm_res_hist_id,
          hist_seq_no, item_no, peril_cd,
          loss_reserve, expense_reserve,
          convert_rate, grouped_item_no --added by gmi 02/23/06
     FROM GICL_CLM_RES_HIST
    WHERE claim_id        = p_claim_id
      AND clm_res_hist_id = p_clm_res_hist
      FOR UPDATE OF DIST_SW;
  --Cursor for peril distribution in underwriting table.
  CURSOR cur_perilds(v_peril_cd giri_ri_dist_item_v.peril_cd%TYPE,
		    v_item_no  giri_ri_dist_item_v.item_no%TYPE) IS
   SELECT d.share_cd, f.share_type, f.trty_yy,f.prtfolio_sw,
          f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi,
          f.expiry_date
     FROM gipi_polbasic A, gipi_item b,
          giuw_pol_dist c, giuw_itemperilds_dtl d,
	        giis_dist_share f
    WHERE f.share_cd   = d.share_cd
      AND f.line_cd    = d.line_cd
      AND d.peril_cd   = v_peril_cd
      AND d.item_no    = v_item_no
      AND d.item_no    = b.item_no
      AND d.dist_no    = c.dist_no
      AND c.dist_flag  = v_dist_param
      AND c.policy_id  = b.policy_id
      AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(A.eff_date),
          DECODE(TRUNC(A.eff_date),TRUNC(A.incept_date), p_pol_eff_date, A.eff_date ),c.eff_date))
          <= p_loss_date
      AND TRUNC(DECODE(TRUNC(c.expiry_date),TRUNC(A.expiry_date),DECODE(NVL(A.endt_expiry_date, A.expiry_date),
          A.expiry_date,p_expiry_date,A.endt_expiry_date),c.expiry_date))
          >= p_loss_date
      AND b.policy_id  = A.policy_id
      AND A.pol_flag   IN ('1','2','3','X')
      AND A.line_cd    = p_line_cd
      AND A.subline_cd = p_subline_cd
      AND A.iss_cd     = p_iss_cd
      AND A.issue_yy   = p_issue_yy
      AND A.pol_seq_no = p_pol_seq_no
      AND A.renew_no   = p_renew_no
  GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
          A.pol_seq_no, A.renew_no, d.share_cd, f.share_type,
          f.trty_yy, f.acct_trty_type, d.item_no, d.peril_cd,f.prtfolio_sw,
          f.expiry_date;
  --Cursor for peril distribution in treaty table.
  CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%TYPE,
                  v_trty_yy  giis_dist_share.trty_yy%TYPE) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM giis_trty_panel
    WHERE line_cd     = p_line_cd
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;
  --Cursor for peril distribution in ri table.
  CURSOR cur_frperil(v_peril_cd giri_ri_dist_item_v.peril_cd%TYPE,
		    v_item_no  giri_ri_dist_item_v.item_no%TYPE)IS
   SELECT t2.ri_cd,
          SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt
     FROM gipi_polbasic t5, gipi_itmperil t8, giuw_pol_dist t4,
          giuw_itemperilds t6, giri_distfrps t3, giri_frps_ri t2
    WHERE 1                       = 1
      AND t5.line_cd              = p_line_cd
      AND t5.subline_cd           = p_subline_cd
      AND t5.iss_cd               = p_iss_cd
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
          t5.expiry_date,p_expiry_date,t5.endt_expiry_date),t4.expiry_date))
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
  --Cursor for quota share limit
  CURSOR QUOTA_SHARE_TREATIES IS
     SELECT trty_limit, qs_shr_pct, share_cd
       FROM giis_dist_share
      WHERE line_cd        = p_line_cd
        AND eff_date       <= SYSDATE
        AND expiry_date    >= SYSDATE
        AND acct_trty_type = v_acct_trty_type
        AND qs_shr_pct     IS NOT NULL;
BEGIN
  --update negate_tag on table gicl_reserve_ds to 'Y' to indicate
  --that it is already negated
  UPDATE gicl_reserve_ds
     SET negate_tag = 'Y'
   WHERE claim_id = p_claim_id
     AND hist_seq_no < p_hist_seq_no
     AND item_no = p_item_no
     AND grouped_item_no = p_grouped_item_no
     AND peril_cd = p_peril_cd;
  -- get distribution no
  DBMS_OUTPUT.PUT_LINE(p_clm_res_hist - 1||'-'||p_claim_id);
  FOR get_dist_no IN
    (SELECT MAX(clm_dist_no) clm_dist_no
       FROM gicl_reserve_ds
      WHERE claim_id = p_claim_id
        AND clm_res_hist_id = p_clm_res_hist - 1)
  LOOP
    v_clm_dist_no := NVL(get_dist_no.clm_dist_no,0); --emchang
	EXIT;
  END LOOP;
  FOR c1 IN cur_clm_res LOOP        /*begin c1 loop Using Item-peril cursor */
    BEGIN
      SELECT SUM(A.tsi_amt)
        INTO sum_tsi_amt
        FROM giri_basic_info_item_sum_v A, giuw_pol_dist b
       WHERE A.policy_id  = b.policy_id
         AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(A.eff_date),
             DECODE(TRUNC(A.eff_date),TRUNC(A.incept_date), p_pol_eff_date, A.eff_date ),b.eff_date))
             <= p_loss_date
         AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(A.expiry_date),
             DECODE(NVL(A.endt_expiry_date, A.expiry_date),
             A.expiry_date,p_expiry_date,A.endt_expiry_date ),b.expiry_date))
             >= p_loss_date
         AND A.item_no    = p_item_no
         AND A.peril_cd   = p_peril_cd
         AND A.line_cd    = p_line_cd
         AND A.subline_cd = p_subline_cd
         AND A.iss_cd     = p_iss_cd
         AND A.issue_yy   = p_issue_yy
         AND A.pol_seq_no = p_pol_seq_no
         AND A.renew_no   = p_renew_no
         AND b.dist_flag  = v_dist_param;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-200001,'THE TSI FOR THIS POLICY IS ZERO...');
    END;
    -- get  quota share treaty limits
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
    FOR me IN cur_perilds(c1.peril_cd, c1.item_no)
	LOOP
      IF me.acct_trty_type = v_acct_trty_type THEN
         v_switch  := 1;
      ELSIF ((me.acct_trty_type = v_acct_trty_type) OR
        (me.acct_trty_type IS NULL)) AND (v_switch <> 1) THEN
         v_switch := 0;
      END IF;
    END LOOP;
    BEGIN
      SELECT peril_sname
        INTO v_peril_sname
        FROM giis_peril
       WHERE peril_cd = c1.peril_cd
         AND line_cd = p_line_cd;
    END;
    IF v_peril_sname = v_trty_peril THEN
       v_trty_limit := Giacp.n('TRTY_PERIL_LIMIT');
    END IF;
    IF sum_tsi_amt > v_trty_limit THEN
       FOR I IN CUR_PERILDS(C1.PERIL_CD, C1.ITEM_NO) LOOP
         IF I.SHARE_TYPE = V_FACUL_SHARE_TYPE THEN
            v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi/sum_tsi_amt);
         END IF;
       END LOOP;
       v_net_amt := (sum_tsi_amt - NVL(v_facul_amt,0))* ((100 - v_qs_shr_pct)/100);
       v_treaty_amt := (sum_tsi_amt - NVL(v_facul_amt,0))* (v_qs_shr_pct/100);
    ELSE
       v_net_amt    := sum_tsi_amt * ((100 - v_qs_shr_pct)/100);
       v_treaty_amt := sum_tsi_amt * (v_qs_shr_pct/100);
    END IF;
   --validates prtfolio_sw before inserting and updating */
    FOR c2 IN cur_perilds(c1.peril_cd,c1.item_no) LOOP /*Underwriting peril distribution*/
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
              AND TRUNC(c2.expiry_date) < TRUNC(SYSDATE) THEN
     	      WHILE TRUNC(c2.expiry_date) < TRUNC(SYSDATE) LOOP
                BEGIN
          	      SELECT share_cd, trty_yy, NVL(prtfolio_sw, 'N'),
                         acct_trty_type, share_type, expiry_date
                    INTO v_share_cd, v_treaty_yy2, v_prtf_sw,
                         v_acct_trty, v_share_type, v_expiry_date
          	        FROM giis_dist_share
          	       WHERE line_cd	       = p_line_cd
          	         AND old_trty_seq_no =  c2.share_cd;
                EXCEPTION
           	      WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-200001,'NO NEW TREATY SET-UP FOR YEAR'|| TO_CHAR(SYSDATE,'YYYY'));
          	      WHEN TOO_MANY_ROWS THEN
                     RAISE_APPLICATION_ERROR(-200001,'TOO MANY TREATIES SET-UP FOR YEAR'|| TO_CHAR(SYSDATE,'YYYY'));
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
      IF ((c2.acct_trty_type <> v_acct_trty_type) OR (c2.acct_trty_type IS NULL))
         AND v_switch = 0 THEN
         ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
         v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
         v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
      ELSE
         IF (c2.share_type = v_trty_share_type) AND (c2.share_cd = v_share_cd) THEN
            ann_dist_spct  := (v_treaty_amt/sum_tsi_amt) * 100;
            v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
            v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
         ELSIF (c2.share_type != v_trty_share_type) AND
         	  (c2.share_type != v_facul_share_type) AND
         	  (v_net_amt IS NOT NULL) THEN
            ann_dist_spct  := (v_net_amt/sum_tsi_amt) * 100;
            v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
            v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
         ELSE
            ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
            v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
            v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
         END IF;
      END IF;
   /*checks if share_cd is already existing if existing updates gicl_reserve_ds
   if not existing then inserts record to gicl_reserve_ds*/
      v_share_exist := 'N';
      FOR i IN
        (SELECT '1'
           FROM gicl_reserve_ds
          WHERE claim_id    = c1.claim_id
            AND hist_seq_no = c1.hist_seq_no
            AND grouped_item_no = c1.grouped_item_no
            AND item_no     = c1.item_no
            AND peril_cd    = c1.peril_cd
            AND grp_seq_no  = c2.share_cd
            AND line_cd     = p_line_cd)
      LOOP
        v_share_exist :='Y';
      END LOOP;
      IF ann_dist_spct <> 0 THEN
         IF v_share_exist = 'N' THEN
		    DBMS_OUTPUT.PUT_LINE('E'||v_clm_dist_no);--++
            INSERT INTO gicl_reserve_ds(claim_id,        clm_res_hist_id,
                                        dist_year,       clm_dist_no,
                                        item_no,         peril_cd,
                                        grouped_item_no,
                                        grp_seq_no,      share_type,
                                        shr_pct,         shr_loss_res_amt,
                                        shr_exp_res_amt, line_cd,
				                                acct_trty_type,  user_id,
                                        last_update,     hist_seq_no)
                                VALUES (c1.claim_id, 		      c1.clm_res_hist_id,
                                        TO_CHAR(SYSDATE,'YYYY'),
                                        v_clm_dist_no,        c1.item_no,
                                        c1.peril_cd,          c1.grouped_item_no,
                                        c2.share_cd,
                                        c2.share_type, 	      ann_dist_spct,
                                        v_loss_res_amt,       v_exp_res_amt,
                                        p_line_cd,            c2.acct_trty_type,
                                        USER, 		           SYSDATE,
                                        c1.hist_seq_no);
         ELSE
            UPDATE gicl_reserve_ds
               SET shr_pct          = NVL(shr_pct,0) + NVL(ann_dist_spct,0),
                   shr_loss_res_amt = NVL(shr_loss_res_amt,0) + NVL(v_loss_res_amt,0),
                   shr_exp_res_amt  = NVL(shr_exp_res_amt,0) + NVL(v_exp_res_amt,0)
             WHERE claim_id    = c1.claim_id
               AND hist_seq_no = c1.hist_seq_no
               AND grouped_item_no = c1.grouped_item_no
               AND item_no     = c1.item_no
               AND peril_cd    = c1.peril_cd
               AND grp_seq_no  = c2.share_cd
               AND line_cd     = p_line_cd;
         END IF;
         me := TO_NUMBER(c2.share_type) - TO_NUMBER(v_trty_share_type);
         IF me = 0 THEN
            FOR c_trty IN cur_trty(c2.share_cd, c2.trty_yy) LOOP
              IF v_share_exist = 'N' THEN
			     DBMS_OUTPUT.PUT_LINE('2');--++
                 INSERT INTO gicl_reserve_rids(claim_id,    			 clm_res_hist_id,
                                               dist_year, 	       clm_dist_no,
                                               item_no,            peril_cd,
                                               grp_seq_no,         share_type,
                                               ri_cd,   	  		   shr_ri_pct,
                                               shr_ri_pct_real,	   shr_loss_ri_res_amt,
		         	                                 shr_exp_ri_res_amt, line_cd,
                                               acct_trty_type,     prnt_ri_cd,
                                               hist_seq_no, 			 grouped_item_no)
              		                      VALUES(c1.claim_id,         c1.clm_res_hist_id,
                                               TO_CHAR(SYSDATE,'YYYY'),
                                               v_clm_dist_no,       c1.item_no,
                                               c1.peril_cd,         c2.share_cd,
                                               v_trty_share_type, 	c_trty.ri_cd,
                                               (ann_dist_spct  * c_trty.trty_shr_pct/100),
                                               c_trty.trty_shr_pct, (v_loss_res_amt * c_trty.trty_shr_pct/100),
                    		                       (v_exp_res_amt  * c_trty.trty_shr_pct/100), p_line_cd,
                                               c2.acct_trty_type,   c_trty.prnt_ri_cd,
                                               c1.hist_seq_no,     c1.grouped_item_no);
              ELSE
                 UPDATE gicl_reserve_rids
                    SET shr_exp_ri_res_amt  = NVL(shr_exp_ri_res_amt,0) + (NVL(v_exp_res_amt,0)* c_trty.trty_shr_pct/100),
                        shr_loss_ri_res_amt = NVL(shr_loss_ri_res_amt,0) + (NVL(v_loss_res_amt,0)* c_trty.trty_shr_pct/100),
                        shr_ri_pct          = NVL(shr_ri_pct,0) + (NVL(ann_dist_spct,0)* c_trty.trty_shr_pct/100)
                  WHERE claim_id    = c1.claim_id
                    AND hist_seq_no = c1.hist_seq_no
                    AND item_no     = c1.item_no
                    AND peril_cd    = c1.peril_cd
                    AND grouped_item_no = c1.grouped_item_no
                    AND grp_seq_no  = c2.share_cd
                    AND ri_cd       = c_trty.ri_cd
                    AND line_cd     = p_line_cd;
              END IF;
            END LOOP; /*end of c_trty loop*/
         ELSIF c2.share_type = v_facul_share_type THEN
            FOR c3 IN cur_frperil(c1.peril_cd,c1.item_no) LOOP /*RI peril distribution*/
              IF (c2.acct_trty_type <> v_acct_trty_type) OR (c2.acct_trty_type IS NULL) THEN
                 ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
              ELSE
                 ann_ri_pct := (v_facul_amt /sum_tsi_Amt) * 100;
              END IF;
			  DBMS_OUTPUT.PUT_LINE('3');--++
              INSERT INTO gicl_reserve_rids(claim_id, 	         clm_res_hist_id,
                                            dist_year,          clm_dist_no,
                                            item_no,            peril_cd,
                                            grp_seq_no,         share_type,
                                            ri_cd,              shr_ri_pct,
                                            shr_ri_pct_real,    shr_loss_ri_res_amt,
                                            shr_exp_ri_res_amt, line_cd,
                                            acct_trty_type,     prnt_ri_cd,
                                            hist_seq_no, 			  grouped_item_no)
              		                   VALUES(c1.claim_id, 	       c1.clm_res_hist_id,
                                            TO_CHAR(SYSDATE, 'YYYY'),
				                                    v_clm_dist_no,        c1.item_no,
				                                    c1.peril_cd,          c2.share_cd,
				                                    v_facul_share_type,   c3.ri_cd,
				                                    ann_ri_pct,           ann_ri_pct*100/ann_dist_spct,
				                                    (c1.loss_reserve * ann_ri_pct/100),
	             		                          (c1.expense_reserve * ann_ri_pct/100),
	             		                          p_line_cd, c2.acct_trty_type,
	             		                          c3.ri_cd,		c1.hist_seq_no, c1.grouped_item_no);
            END LOOP; /*End of c3 loop */
         END IF;
      ELSE
         NULL;
      END IF;
    END LOOP; /*End of c2 loop*/
    --EXCESS OF LOSS
  	IF p_cat_cd IS NULL THEN
   	   FOR NET_SHR IN
    	 (SELECT (shr_loss_res_amt * c1.convert_rate) loss_reserve,
      	         (shr_exp_res_amt* c1.convert_rate) exp_reserve,
      	          shr_pct
    	     FROM gicl_reserve_ds
       	     WHERE claim_id    = c1.claim_id
       	       AND grouped_item_no = c1.grouped_item_no
		           AND hist_seq_no = c1.hist_seq_no
        		   AND item_no     = c1.item_no
            	 AND peril_cd    = c1.peril_cd
            	 AND share_type  = '1')
    	   LOOP
    		   v_retention      := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
           v_retention_orig := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
    	     FOR TOT_NET IN
    	   	   (SELECT SUM(NVL(A.shr_loss_res_amt,0) + NVL( A.shr_exp_res_amt,0)) ret_amt
           	    FROM gicl_reserve_ds A, gicl_item_peril b
         	     WHERE A.claim_id              = c1.claim_id
         	       AND A.claim_id              = b.claim_id
         	       AND A.grouped_item_no       = b.grouped_item_no
         	       AND A.item_no               = b.item_no
         	       AND A.peril_cd              = b.peril_cd
         	       AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                 AND NVL(A.negate_tag,'N')   = 'N'
                 AND A.share_type            = '1'
                 AND (A.item_no  <> c1.item_no OR A.peril_cd <> c1.peril_cd OR A.grouped_item_no <> c1.grouped_item_no))
           LOOP
             v_total_retention := v_retention + NVL(tot_net.ret_amt,0);
           END LOOP;
           FOR CHK_XOL IN
             (SELECT A.share_cd,   acct_trty_type,  xol_allowed_amount,
                     xol_base_amount, xol_reserve_amount, trty_yy,
                     xol_aggregate_sum, A.line_cd, A.share_type
                FROM giis_dist_share A, giis_trty_peril b
               WHERE A.line_cd            = b.line_cd
                 AND A.share_cd           = b.trty_seq_no
                 AND A.share_type         = '4'
                 AND TRUNC(A.eff_date)    <= TRUNC(p_loss_date)
                 AND TRUNC(A.expiry_date) >= TRUNC(p_loss_date)
                 AND b.peril_cd           = c1.peril_cd
                 AND A.line_cd            = p_line_cd
               ORDER BY xol_base_amount ASC)
           LOOP
        	   v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
        	   IF v_allowed_retention < 1 THEN
           	    EXIT;
        	   END IF;
        	   FOR get_all_xol IN
        	     (SELECT SUM(NVL(A.shr_loss_res_amt,0) + NVL( A.shr_exp_res_amt,0)) ret_amt
          	     FROM gicl_reserve_ds A, gicl_item_peril b
         	      WHERE NVL(A.negate_tag,'N')   = 'N'
         	        AND A.item_no               = b.item_no
         	        AND A.grouped_item_no       = b.grouped_item_no
         	        AND A.peril_cd              = b.peril_cd
         	        AND A.claim_id              = b.claim_id
         	        AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                  AND A.grp_seq_no            = chk_xol.share_cd
                  AND A.line_cd               = chk_xol.line_cd)
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
        	   v_old_xol_share := 0;
        	   FOR TOTAL_XOL IN
      	       (SELECT SUM(NVL(A.shr_loss_res_amt,0) + NVL( A.shr_exp_res_amt,0)) ret_amt
          	      FROM gicl_reserve_ds A, gicl_item_peril b
         	       WHERE A.claim_id              = c1.claim_id
         	         AND A.claim_id              = b.claim_id
         	         AND A.grouped_item_no  	 = b.grouped_item_no
         	         AND A.item_no               = b.item_no
         	         AND A.peril_cd              = b.peril_cd
         	         AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                   AND NVL(A.negate_tag,'N')   = 'N'
                   AND A.grp_seq_no            = chk_xol.share_cd)
             LOOP
          	   v_total_xol_share := NVL(total_xol.ret_amt,0);
          	   v_old_xol_share    := NVL(total_xol.ret_amt,0);
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
							  DBMS_OUTPUT.PUT_LINE('4');--++
                INSERT INTO gicl_reserve_ds (claim_id,         clm_res_hist_id,
                                             dist_year,        clm_dist_no,
                                             item_no,          peril_cd,
                                             grouped_item_no,
                                             grp_seq_no,      share_type,
                                             shr_pct,         shr_loss_res_amt,
                                             shr_exp_res_amt, line_cd,
                                             acct_trty_type,  user_id,
                                             last_update,     hist_seq_no)
                                     VALUES (c1.claim_id, 	        c1.clm_res_hist_id,
                                             TO_CHAR(SYSDATE,'YYYY'),
                                             v_clm_dist_no,        c1.item_no,
                                             c1.peril_cd,          c1.grouped_item_no, --added by gmi 02/28/06
                                             chk_xol.share_cd,
                                             chk_xol.share_type,   net_shr.shr_pct * v_shr_pct,
                                             net_shr.loss_reserve * v_shr_pct,
                                             net_shr.exp_reserve * v_shr_pct,
                                             p_line_cd, chk_xol.acct_trty_type,
                                             USER, 		    SYSDATE,
                                             c1.hist_seq_no);
                FOR update_xol_trty IN
        	        (SELECT SUM((NVL(A.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
          	         FROM gicl_reserve_ds A, GICL_CLM_RES_HIST b, gicl_item_peril c
         	          WHERE NVL(A.negate_tag,'N')   = 'N'
         	            AND A.claim_id              = b.claim_id
         	            AND A.clm_res_hist_id       = b.clm_res_hist_id
         	            AND A.claim_id              = c.claim_id
         	            AND A.item_no               = c.item_no
         	            AND A.peril_cd              = c.peril_cd
         	            AND A.grouped_item_no 		= c.grouped_item_no
         	            AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
                      AND A.grp_seq_no            = chk_xol.share_cd
                      AND A.line_cd               = chk_xol.line_cd)
                LOOP
                  UPDATE giis_dist_share
                     SET xol_reserve_amount = update_xol_trty.ret_amt
                   WHERE share_cd           = chk_xol.share_cd
                     AND line_cd            = chk_xol.line_cd;
                END LOOP;
                FOR xol_trty IN
                  cur_trty(chk_xol.share_cd, chk_xol.trty_yy)
                LOOP
							  DBMS_OUTPUT.PUT_LINE('5');--++
							  DBMS_OUTPUT.PUT_LINE(c1.claim_id||', '||c1.clm_res_hist_id||', '||
							                       v_clm_dist_no||', '||TO_CHAR(SYSDATE,'YYYY')||', '||xol_trty.ri_cd);
				  --++
				  FOR i IN (SELECT 1
				              FROM gicl_reserve_rids
							 WHERE claim_id = c1.claim_id
							   AND clm_res_hist_id = c1.clm_res_hist_id
							   AND clm_dist_no = v_clm_dist_no
							   AND ri_cd = xol_trty.ri_cd
							   AND dist_year = TO_CHAR(SYSDATE,'YYYY'))
			      LOOP
				    DBMS_OUTPUT.PUT_LINE('PUMASOK');
				  END LOOP;
				  --++
                  INSERT INTO gicl_reserve_rids (claim_id,           clm_res_hist_id,
                                                 dist_year,          clm_dist_no,
                                                 item_no,            peril_cd,
                                                 grp_seq_no,         share_type,
                                                 ri_cd,              shr_ri_pct,
                                                 shr_ri_pct_real,    shr_loss_ri_res_amt,
                                                 shr_exp_ri_res_amt, line_cd,
                                                 acct_trty_type,     prnt_ri_cd,
                                                 hist_seq_no,        grouped_item_no)
              		                       VALUES (c1.claim_id,          c1.clm_res_hist_id,
              		                               TO_CHAR(SYSDATE,'YYYY'),
              		                               v_clm_dist_no,        c1.item_no,
              		                               c1.peril_cd,          chk_xol.share_cd,
              		                               chk_xol.share_type,   xol_trty.ri_cd,
              		                               ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
              		                               xol_trty.trty_shr_pct,
              		                               ((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100)),
              		                               ((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100)),
              		                               p_line_cd, chk_xol.acct_trty_type,
              		                               xol_trty.prnt_ri_cd,  c1.hist_seq_no, c1.grouped_item_no);
                END LOOP;
             END IF;
             v_retention := v_retention - v_total_xol_share;
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
    		   v_retention := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
           v_retention_orig :=NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
    	     FOR TOT_NET IN
    	   	   (SELECT SUM(NVL(shr_loss_res_amt,0) + NVL( shr_exp_res_amt,0)) ret_amt
           	    FROM gicl_reserve_ds A, gicl_claims c, gicl_item_peril b
         	     WHERE A.claim_id = c.claim_id
         	       AND A.claim_id = b.claim_id
         	       AND A.grouped_item_no = b.grouped_item_no --added by gmi 02/28/06
         	       AND A.item_no = b.item_no
         	       AND A.peril_cd = b.peril_cd
         	       AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
         	       AND c.catastrophic_cd = p_cat_cd
                 AND NVL(negate_tag,'N') = 'N'
                 AND share_type = '1'
                 AND (A.claim_id <> p_claim_id
                   OR A.item_no <> c1.item_no
                   OR A.peril_cd <> c1.peril_cd ))
           LOOP
             v_total_retention := v_retention + NVL(tot_net.ret_amt,0);
           END LOOP;
           FOR CHK_XOL IN
             (SELECT A.share_cd,   acct_trty_type,  xol_allowed_amount,
                     xol_base_amount, xol_reserve_amount, trty_yy,
                     xol_aggregate_sum, A.line_cd, A.share_type
                FROM giis_dist_share A, giis_trty_peril b
               WHERE A.line_cd            = b.line_cd
                 AND A.share_cd           = b.trty_seq_no
                 AND A.share_type         = '4'
                 AND TRUNC(A.eff_date)    <= TRUNC(p_loss_date)
                 AND TRUNC(A.expiry_date) >= TRUNC(p_loss_date)
                 AND b.peril_cd           = c1.peril_cd
                 AND A.line_cd            = p_line_cd
               ORDER BY xol_base_amount ASC)
           LOOP
        	   v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
        	   IF v_allowed_retention < 1 THEN
           	    EXIT;
        	   END IF;
        	   FOR get_all_xol IN
        	     (SELECT SUM(NVL(shr_loss_res_amt,0) + NVL( shr_exp_res_amt,0)) ret_amt
          	     FROM gicl_reserve_ds A, gicl_item_peril b
         	      WHERE NVL(negate_tag,'N')     = 'N'
         	        AND A.claim_id              = b.claim_id
         	        AND A.item_no               = b.item_no
         	        AND A.peril_cd              = b.peril_cd
         	        AND A.grouped_item_no  			= b.grouped_item_no
         	        AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                  AND grp_seq_no              = chk_xol.share_cd
                  AND A.line_cd               = chk_xol.line_cd)
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
          	      FROM gicl_reserve_ds A, gicl_claims c, gicl_item_peril b
         	       WHERE c.claim_id              = A.claim_id
         	         AND A.grouped_item_no  	 = b.grouped_item_no
         	         AND A.claim_id              = b.claim_id
         	         AND A.item_no               = b.item_no
         	         AND A.peril_cd              = b.peril_cd
         	         AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
         	         AND c.catastrophic_cd       = p_cat_cd
                   AND NVL(negate_tag,'N')     = 'N'
                   AND grp_seq_no              = chk_xol.share_cd)
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
                v_shr_pct := v_total_xol_share/v_retention_orig;
                v_running_retention := v_running_retention + v_total_xol_share;
							  DBMS_OUTPUT.PUT_LINE('6');--++
                INSERT INTO gicl_reserve_ds (claim_id,        clm_res_hist_id,
                                             dist_year,       clm_dist_no,
                                             item_no, 	      peril_cd,
                                             grouped_item_no,
                                             grp_seq_no,      share_type,
                                             shr_pct,         shr_loss_res_amt,
                                             shr_exp_res_amt, line_cd,
                                             acct_trty_type,   user_id,
                                             last_update,      hist_seq_no)
                                     VALUES (c1.claim_id,          c1.clm_res_hist_id,
                                             TO_CHAR(SYSDATE,'YYYY'),
                                             v_clm_dist_no,        c1.item_no,
                                             c1.peril_cd,          c1.grouped_item_no,
                                             chk_xol.share_cd,
                                             chk_xol.share_type,   net_shr.shr_pct * v_shr_pct,
                                             net_shr.loss_reserve * v_shr_pct,
                                             net_shr.exp_reserve * v_shr_pct,
                                             p_line_cd, chk_xol.acct_trty_type,
                                             USER, 		   SYSDATE,
                                             c1.hist_seq_no);
                FOR update_xol_trty IN
        	        (SELECT SUM((NVL(A.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
          	         FROM gicl_reserve_ds A, GICL_CLM_RES_HIST b, gicl_item_peril c
         	          WHERE NVL(A.negate_tag,'N')   = 'N'
         	            AND A.claim_id              = b.claim_id
         	            AND A.clm_res_hist_id       = b.clm_res_hist_id
         	            AND A.claim_id              = c.claim_id
         	            AND A.item_no               = c.item_no
         	            AND A.peril_cd              = c.peril_cd
         	            AND A.grouped_item_no  		  = c.grouped_item_no
         	            AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
                      AND A.grp_seq_no            = chk_xol.share_cd
                      AND A.line_cd               = chk_xol.line_cd)
                LOOP
                  UPDATE giis_dist_share
                     SET xol_reserve_amount = update_xol_trty.ret_amt
                   WHERE share_cd = chk_xol.share_cd
                     AND line_cd  = chk_xol.line_cd;
                END LOOP;
                FOR xol_trty IN
                  cur_trty(chk_xol.share_cd, chk_xol.trty_yy)
                LOOP
							  DBMS_OUTPUT.PUT_LINE('7');--++
                  INSERT INTO gicl_reserve_rids (claim_id,           clm_res_hist_id,
                                                 dist_year, 	       clm_dist_no,
                                                 item_no,            peril_cd,
                                                 grp_seq_no,         share_type,
                                                 ri_cd,              shr_ri_pct,
                                                 shr_ri_pct_real,    shr_loss_ri_res_amt,
                                                 shr_exp_ri_res_amt, line_cd,
                                                 acct_trty_type,     prnt_ri_cd,
                                                 hist_seq_no, 			 grouped_item_no)
              		                       VALUES (c1.claim_id,          c1.clm_res_hist_id,
              		                               TO_CHAR(SYSDATE,'YYYY'),
              		                               v_clm_dist_no,        c1.item_no,
              		                               c1.peril_cd,          chk_xol.share_cd,
              		                               chk_xol.share_type,   xol_trty.ri_cd,
              		                               ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
              		                               xol_trty.trty_shr_pct,
              		                               ((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100)),
              		                               ((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100)),
              		                               p_line_cd, chk_xol.acct_trty_type,
              		                               xol_trty.prnt_ri_cd,  c1.hist_seq_no, c1.grouped_item_no);
                END LOOP;
             END IF;
             v_retention := v_retention - v_total_xol_share;
             v_total_retention := v_total_retention +  v_old_xol_share;
           END LOOP; --CHK_XOL
         END LOOP; -- NET_SHR
      END IF;
      IF v_retention = 0 THEN
      	 DELETE FROM gicl_reserve_ds
      	  WHERE claim_id    = c1.claim_id
		        AND hist_seq_no = c1.hist_seq_no
    		    AND item_no     = c1.item_no
         	  AND peril_cd    = c1.peril_cd
         	  AND grouped_item_no = c1.grouped_item_no
         	  AND share_type  = '1';
      ELSIF v_retention <> v_retention_orig THEN
      	 UPDATE gicl_reserve_ds
      	    SET shr_loss_res_amt = shr_loss_res_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
      	        shr_exp_res_amt  = shr_exp_res_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
      	        shr_pct          =  shr_pct * (v_retention_orig-v_running_retention)/v_retention_orig
      	  WHERE claim_id    = c1.claim_id
		        AND hist_seq_no = c1.hist_seq_no
    		    AND item_no     = c1.item_no
         	  AND peril_cd    = c1.peril_cd
         	  AND grouped_item_no = c1.grouped_item_no
         	  AND share_type  = '1';
        END IF;
    UPDATE GICL_CLM_RES_HIST
       SET dist_sw = 'Y',
           dist_no = v_clm_dist_no
     WHERE CURRENT OF cur_clm_res;
    UPDATE GICL_CLM_RES_HIST
       SET dist_sw = 'Y',
           dist_no = v_clm_dist_no
     WHERE CURRENT OF cur_clm_res;
  END LOOP; /*End of c1 loop */
-- offset distribution amounts
  FOR OFFSET IN (
    SELECT  loss_reserve, expense_reserve
      FROM GICL_CLM_RES_HIST
     WHERE claim_id        = p_claim_id
       AND clm_res_hist_id = p_clm_res_hist)
  LOOP
    FOR offset2 IN (
      SELECT SUM(shr_loss_res_amt)sum_loss, SUM(shr_exp_res_amt) sum_exp
        FROM gicl_reserve_ds
       WHERE claim_id = p_claim_id
         AND clm_dist_no = v_clm_dist_no
         AND clm_res_hist_id = p_clm_res_hist)
    LOOP
      offset_loss1:= NVL(offset.loss_reserve,0) - NVL(offset2.sum_loss,0);
      offset_exp1  := NVL(offset.expense_reserve,0) - NVL(offset2.sum_exp,0);
    END LOOP;
  END LOOP;
  IF NVL(offset_loss1,0) <> 0 OR NVL(offset_exp1,0) <> 0 THEN
  	 FOR get_cd IN (
  	   SELECT grp_seq_no
  	     FROM gicl_reserve_ds
  	    WHERE claim_id = p_claim_id
         AND clm_dist_no = v_clm_dist_no
         AND clm_res_hist_id = p_clm_res_hist
       ORDER BY grp_seq_no)
     LOOP
     	UPDATE gicl_reserve_ds
     	   SET shr_loss_res_amt = shr_loss_res_amt + offset_loss1,
     	       shr_exp_res_amt = shr_exp_res_amt + offset_exp1
  	    WHERE claim_id = p_claim_id
         AND clm_dist_no = v_clm_dist_no
         AND grp_seq_no = get_cd.grp_seq_no
         AND clm_res_hist_id = p_clm_res_hist;
      EXIT;
     END LOOP;
  END IF;
  -- extract amounts from gicl_reserve_rids
  FOR A IN (SELECT grp_seq_no
 	                 , peril_cd
                 , item_no
                 , grouped_item_no
                 , SUM(shr_loss_ri_res_amt) loss_amt
                 , SUM(shr_exp_ri_res_amt) exp_amt
              FROM gicl_reserve_rids
             WHERE claim_id = p_claim_id
               AND clm_dist_no = v_clm_dist_no
               AND clm_res_hist_id= p_clm_res_hist
          GROUP BY grp_seq_no, item_no, peril_cd, grouped_item_no)
  LOOP
    offset_loss := 0;
    offset_exp  := 0;
  -- extract amounts from gicl_reserve_ds to link with the values in A.
    FOR B IN (SELECT shr_loss_res_amt, shr_exp_res_amt
                FROM gicl_reserve_ds
               WHERE claim_id = p_claim_id
                 AND clm_dist_no = v_clm_dist_no
                 AND grp_seq_no = A.grp_seq_no
                 AND clm_res_hist_id = p_clm_res_hist
                 AND item_no = A.item_no
                 AND peril_cd = A.peril_cd
                 AND grouped_item_no = A.grouped_item_no)
    LOOP
/* subtract sum of amounts in A from B, if <> 0 IF statement executes.
   otherwise, null. */
      offset_loss := NVL(b.shr_loss_res_amt,0) - NVL(A.loss_amt,0);
      offset_exp  := NVL(b.shr_exp_res_amt,0) - NVL(A.exp_amt,0);
    END LOOP;
-- if <> 0 update gicl_reserve_rids using ri_cd.
    IF NVL(offset_loss,0) <> 0 OR NVL(offset_exp,0) <> 0 THEN
       FOR C IN (SELECT ri_cd
                   FROM gicl_reserve_rids
                  WHERE claim_id = p_claim_id
                    AND clm_dist_no = v_clm_dist_no
                    AND grp_seq_no = A.grp_seq_no
                    AND clm_res_hist_id  = p_clm_res_hist
                    AND item_no = A.item_no
                    AND peril_cd = A.peril_cd
                    AND grouped_item_no = A.grouped_item_no)
       LOOP
   /* add offset_loss/offset_exp to
   amounts in A then assign back to the same amounts
   (shr_loss_ri_res_amount, shr_exp_ri_res_amt) */
        UPDATE gicl_reserve_rids
            SET shr_loss_ri_res_amt = NVL(shr_loss_ri_res_amt,0) + NVL(offset_loss,0),
                shr_exp_ri_res_amt  = NVL(shr_exp_ri_res_amt,0) + NVL(offset_exp,0)
          WHERE claim_id    = p_claim_id
            AND clm_dist_no = v_clm_dist_no
            AND grp_seq_no  = A.grp_seq_no
            AND clm_res_hist_id = p_clm_res_hist
            AND ri_cd       = c.ri_cd
            AND item_no     = A.item_no
            AND grouped_item_no = A.grouped_item_no
            AND peril_cd    = A.peril_cd;
         EXIT;
       END LOOP;
    END IF;
  END LOOP;
--- end offset process
  --     summation of reserves for update in table gicl_claims should consider
  --     that the record is not denied,cancelled or withdrawn
  FOR sum_res IN
    (SELECT SUM(loss_reserve) loss_reserve,
            SUM(expense_reserve) exp_reserve
      FROM gicl_clm_reserve A, gicl_item_peril b
     WHERE A.claim_id = b.claim_id
       AND A.grouped_item_no = b.grouped_item_no
       AND A.item_no  = b.item_no
       AND A.peril_cd = b.peril_cd
       AND A.claim_id = p_claim_id
       AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP'))
  LOOP
    v_loss_amt :=  sum_res.loss_reserve;
    v_exp_amt  :=  sum_res.exp_reserve;
    EXIT;
  END LOOP;  --end sum_res loop
  --update table  gicl_claims for correct reserve amounts
  UPDATE gicl_claims
     SET loss_res_amt = NVL(v_loss_amt,0),
         exp_res_amt  = NVL(v_exp_amt,0)
   WHERE claim_id     = p_claim_id;
  --COMMIT;
END;  -- process_distribution procedure
/


