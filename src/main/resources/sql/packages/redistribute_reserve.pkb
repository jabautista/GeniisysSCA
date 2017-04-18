CREATE OR REPLACE PACKAGE BODY CPI.REDISTRIBUTE_RESERVE
AS
--GET_BOOKING_DATE (CALL FROM CREATE_NEW_RESERVE)
PROCEDURE GET_BOOKING_DATE(P_LOSS_DATE      IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                           P_CLM_FILE_DATE  IN  GICL_CLAIMS.CLM_FILE_DATE%TYPE,
                           P_MONTH          OUT VARCHAR2,
                           P_YEAR           OUT NUMBER)
AS  
  v_max_acct_date  GICL_TAKE_UP_HIST.ACCT_DATE%TYPE;
  v_max_post_date  GICL_TAKE_UP_HIST.ACCT_DATE%TYPE;
BEGIN
  FOR MAX_ACCT_DATE IN(SELECT trunc(max(acct_date), 'MONTH') acct_date
                             FROM gicl_take_up_hist d, giac_acctrans e
                        WHERE d.acct_tran_id = e.tran_id 
                            AND e.tran_class = 'OL'
                            AND e.tran_flag not in ('D','P'))
  LOOP
    v_max_acct_date   := max_acct_date.acct_date;
  END LOOP;
  -- retrieve maximum acct_date from giac_acctrans for outstanding loss
  -- transactions
  FOR MAX_POST_DATE IN(SELECT trunc(max(acct_date), 'MONTH') acct_date
                          FROM gicl_take_up_hist d, giac_acctrans e
                        WHERE d.acct_tran_id = e.tran_id 
                            AND e.tran_class = 'OL'
                            AND e.tran_flag = 'P')
  LOOP
    v_max_post_date   := max_post_date.acct_date;
  END LOOP;

  IF v_max_post_date IS NOT NULL THEN
     FOR booking_date IN (SELECT decode(a.tran_mm,1,'JANUARY',     2,'FEBRUARY',
                                                  3,'MARCH',       4,'APRIL',
                                                  5, 'MAY',        6,'JUNE',
                                                  7, 'JULY',       8,'AUGUST',
                                                  9, 'SEPTEMBER', 10, 'OCTOBER',
                                                  11, 'NOVEMBER', 12,'DECEMBER') booking_month,
                                   a.tran_yr booking_year, a.tran_mm
                            FROM giac_tran_mm a
                           WHERE a.closed_tag = 'N'
                               AND a.branch_cd = giacp.v('BRANCH_CD')
                             AND Last_day(TO_DATE(to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'MM-YYYY')) >=
                                   TRUNC(DECODE(giacp.v('RESERVE BOOKING'),'L',p_loss_date,p_clm_file_date), 'MONTH')
                                AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY')
                                   >= NVL(v_max_acct_date,
                                          TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY'))
                               AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY')
                                   >  v_max_post_date
                              ORDER BY a.tran_yr ASC, a.tran_mm ASC)
     LOOP
       p_month := booking_date.booking_month;
       p_year  := booking_date.booking_year;   
       EXIT; 
     END LOOP; -- end loop booking_date
  ELSE
       FOR booking_date IN (SELECT DECODE(a.tran_mm,1,'JANUARY',     2,'FEBRUARY',
                                                    3,'MARCH',       4,'APRIL', 
                                                  5, 'MAY',        6,'JUNE',
                                                  7, 'JULY',       8,'AUGUST',
                                                  9, 'SEPTEMBER', 10, 'OCTOBER',
                                                  11, 'NOVEMBER', 12,'DECEMBER') booking_month, 
                                 a.tran_yr booking_year, a.tran_mm
                            FROM GIAC_TRAN_MM a
                            WHERE a.closed_tag = 'N'
                                AND a.branch_cd = giacp.v('BRANCH_CD')
                                AND LAST_DAY(TO_DATE(TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'MM-YYYY')) >=
                                 TRUNC(DECODE(giacp.v('RESERVE BOOKING'),'L',p_loss_date,p_clm_file_date), 'MONTH')
                               AND TO_DATE('01-'||TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY')
                                  >= NVL(v_max_acct_date, TO_DATE('01-'||TO_CHAR( a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY'))
                            ORDER BY a.tran_yr ASC, a.tran_mm ASC) 
     LOOP
       p_month := booking_date.booking_month;
       p_year  := booking_date.booking_year;   
       EXIT; 
     END LOOP; -- end loop booking_date  
  END IF;
  IF p_month IS NULL OR
     p_year IS NULL THEN
     RAISE_APPLICATION_ERROR(-20210, 'There is no booking date available.');
  END IF;
END GET_BOOKING_DATE; -- end get_booking_date


--OFFSET_AMT (CALL FROM DISTRIBUTE_RESERVE)
PROCEDURE OFFSET_AMT (P_CLM_DIST_NO     IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                      P_CLAIM_ID        IN  GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                      P_CLM_RES_HIST_ID IN  GICL_RESERVE_DS.CLM_RES_HIST_ID%TYPE)
IS
  offset_loss  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_exp  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_loss1  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_exp1  gicl_reserve_ds.shr_loss_res_amt%TYPE;
BEGIN
-- OFFSET FROM BASE AMOUNT
  FOR OFFSET IN (
     SELECT  loss_reserve, expense_reserve
       FROM gicl_clm_res_hist
      WHERE claim_id        = P_CLAIM_ID
        AND clm_res_hist_id = P_CLM_RES_HIST_ID)
  LOOP      
    FOR offset2 IN (
      SELECT SUM(shr_loss_res_amt)sum_loss, SUM(shr_exp_res_amt) sum_exp
        FROM gicl_reserve_ds
       WHERE claim_id = P_CLAIM_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND clm_res_hist_id = P_CLM_RES_HIST_ID)
    LOOP
      offset_loss1:= nvl(offset.loss_reserve,0) - nvl(offset2.sum_loss,0);
      offset_exp1  := nvl(offset.expense_reserve,0) - nvl(offset2.sum_exp,0);
    END LOOP;
  END LOOP;
  IF NVL(offset_loss1,0) <> 0 OR NVL(offset_exp1,0) <> 0 THEN
       FOR get_cd IN (
         SELECT grp_seq_no
           FROM gicl_reserve_ds
          WHERE claim_id = P_CLAIM_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND clm_res_hist_id = P_CLM_RES_HIST_ID
       ORDER BY grp_seq_no)
     LOOP
         UPDATE gicl_reserve_ds
            SET shr_loss_res_amt = shr_loss_res_amt + offset_loss1,
                shr_exp_res_amt = shr_exp_res_amt + offset_exp1
          WHERE claim_id = P_CLAIM_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND grp_seq_no = get_cd.grp_seq_no
         AND clm_res_hist_id = P_CLM_RES_HIST_ID;
      EXIT;
     END LOOP;
  END IF;   
  -- extract amounts from gicl_reserve_rids
  FOR A IN (SELECT grp_seq_no
                      , peril_cd
                 , item_no
                 , nvl(grouped_item_no,0) grouped_item_no
                 , SUM(shr_loss_ri_res_amt) loss_amt
                 , SUM(shr_exp_ri_res_amt) exp_amt
              FROM gicl_reserve_rids
             WHERE claim_id = P_CLAIM_ID
               AND clm_dist_no = P_CLM_DIST_NO
               AND clm_res_hist_id= P_CLM_RES_HIST_ID
          GROUP BY grp_seq_no, item_no, peril_cd, grouped_item_no)
  LOOP
    offset_loss := 0;
    offset_exp  := 0;

-- extract amounts from gicl_reserve_ds to link with the values in A.
    FOR B IN (SELECT shr_loss_res_amt, shr_exp_res_amt
                FROM gicl_reserve_ds
               WHERE claim_id = P_CLAIM_ID
                 AND clm_dist_no = P_CLM_DIST_NO
                 AND grp_seq_no = a.grp_seq_no
                 AND clm_res_hist_id = P_CLM_RES_HIST_ID
                 AND item_no = a.item_no  
                 AND peril_cd = a.peril_cd
                 AND nvl(grouped_item_no,0) = nvl(a.grouped_item_no,0)) 
    LOOP

/* subtract sum of amounts in A from B, if <> 0 IF statement executes.
   otherwise, null. */
      offset_loss := nvl(b.shr_loss_res_amt,0) - nvl(a.loss_amt,0);
      offset_exp  := nvl(b.shr_exp_res_amt,0) - nvl(a.exp_amt,0);

    END LOOP;

-- if <> 0 update gicl_reserve_rids using ri_cd.
    IF NVL(offset_loss,0) <> 0 OR NVL(offset_exp,0) <> 0 THEN
       FOR C IN (SELECT ri_cd
                   FROM gicl_reserve_rids
                  WHERE claim_id = P_CLAIM_ID
                    AND clm_dist_no = P_CLM_DIST_NO
                    AND grp_seq_no = a.grp_seq_no
                    AND clm_res_hist_id  = P_CLM_RES_HIST_ID
                    AND item_no = a.item_no  
                    AND peril_cd = a.peril_cd
                    AND nvl(grouped_item_no,0) = nvl(a.grouped_item_no,0))
       LOOP
/* add offset_loss/offset_exp to 
   amounts in A then assign back to the same amounts 
   (shr_loss_ri_res_amount, shr_exp_ri_res_amt) */ 

        UPDATE gicl_reserve_rids
            SET shr_loss_ri_res_amt = nvl(shr_loss_ri_res_amt,0) + nvl(offset_loss,0),
                shr_exp_ri_res_amt  = nvl(shr_exp_ri_res_amt,0) + nvl(offset_exp,0)
          WHERE claim_id    = P_CLAIM_ID
            AND clm_dist_no = P_CLM_DIST_NO
            AND grp_seq_no  = a.grp_seq_no
            AND clm_res_hist_id = P_CLM_RES_HIST_ID
            AND ri_cd       = c.ri_cd  
            AND item_no     = a.item_no
            AND nvl(grouped_item_no,0) = nvl(a.grouped_item_no,0) 
            AND peril_cd    = a.peril_cd;
         EXIT;
       END LOOP;
    END IF;
  END LOOP;
END OFFSET_AMT; 


--DISTRIBUTE_RESERVE (CALL FROM PROCESS_DISTRIBUTION)
PROCEDURE DISTRIBUTE_RESERVE (P_CLAIM_ID            IN   GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                              P_HIST_SEQ_NO         IN   GICL_CLM_RES_HIST.HIST_SEQ_NO%TYPE,  
                              P_CLM_RES_HIST_ID     IN   GICL_CLM_RES_HIST.CLM_RES_HIST_ID%TYPE,
                              P_ITEM_NO             IN   GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                              P_PERIL_CD            IN   GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                              P_GROUPED_ITEM_NO     IN   GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                              P_EFF_DATE            IN   GIPI_POLBASIC.EFF_DATE%TYPE,
                              P_EXPIRY_DATE         IN   GIPI_POLBASIC.EXPIRY_DATE%TYPE,
                              P_LOSS_DATE           IN   GICL_CLAIMS.LOSS_DATE%TYPE,
                              P_LINE_CD             IN   GIPI_POLBASIC.LINE_CD%TYPE,
                              P_SUBLINE_CD          IN   GIPI_POLBASIC.SUBLINE_CD%TYPE,
                              P_POL_ISS_CD          IN   GIPI_POLBASIC.ISS_CD%TYPE,
                              P_ISSUE_YY            IN   GIPI_POLBASIC.ISSUE_YY%TYPE,
                              P_POL_SEQ_NO          IN   GIPI_POLBASIC.POL_SEQ_NO%TYPE,
                              P_RENEW_NO            IN   GIPI_POLBASIC.RENEW_NO%TYPE,
                              P_CATASTROPHIC_CD     IN   GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                              P_DISTRIBUTION_DATE   IN   GICL_CLM_RES_HIST.DISTRIBUTION_DATE%TYPE,
                              P_MESSAGE             OUT  VARCHAR2)  
AS
--Cursor for item/peril loss amount
 CURSOR cur_clm_res IS
   SELECT claim_id, clm_res_hist_id,
          hist_seq_no, item_no, peril_cd, 
          loss_reserve, expense_reserve,
          convert_rate, nvl(grouped_item_no,0) grouped_item_no
     FROM gicl_clm_res_hist
    WHERE claim_id        = P_CLAIM_ID
      AND clm_res_hist_id = P_CLM_RES_HIST_ID
      FOR UPDATE OF DIST_SW;

--Cursor for peril distribution in underwriting table.
 CURSOR cur_perilds(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
            v_item_no  giri_ri_dist_item_v.item_no%type) IS
   SELECT d.share_cd, f.share_type, f.trty_yy,f.prtfolio_sw,
          f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi,
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
      AND trunc(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
          DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), P_EFF_DATE, a.eff_date ),c.eff_date)) 
          <= P_LOSS_DATE 
      AND trunc(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),DECODE(NVL(a.endt_expiry_date, a.expiry_date),
          a.expiry_date, P_EXPIRY_DATE,a.endt_expiry_date),c.expiry_date))  
          >= P_LOSS_DATE
      AND b.policy_id  = a.policy_id
      AND a.pol_flag   IN ('1','2','3','X')
      AND a.line_cd    = P_LINE_CD
      AND a.subline_cd = P_SUBLINE_CD
      AND a.iss_cd     = P_POL_ISS_CD
      AND a.issue_yy   = P_ISSUE_YY
      AND a.pol_seq_no = P_POL_SEQ_NO
      AND a.renew_no   = P_RENEW_NO
 GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
          a.pol_seq_no, a.renew_no, d.share_cd, f.share_type, 
          f.trty_yy, f.acct_trty_type, d.item_no, d.peril_cd,f.prtfolio_sw,
          f.expiry_date;

--Cursor for peril distribution in treaty table.

 CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%type,
                 v_trty_yy  giis_dist_share.trty_yy%type) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM giis_trty_panel
    WHERE line_cd     = P_LINE_CD
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;

--Cursor for peril distribution in ri table.

 CURSOR cur_frperil(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
            v_item_no  giri_ri_dist_item_v.item_no%type)is
   SELECT t2.ri_cd,
          SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt 
     FROM gipi_polbasic t5, gipi_itmperil t8, giuw_pol_dist t4,
          giuw_itemperilds t6, giri_distfrps t3, giri_frps_ri t2       
    WHERE 1                       = 1
      AND t5.line_cd              = P_LINE_CD
      AND t5.subline_cd           = P_SUBLINE_CD
      AND t5.iss_cd               = P_POL_ISS_CD
      AND t5.issue_yy             = P_ISSUE_YY
      AND t5.pol_seq_no           = P_POL_SEQ_NO
      AND t5.renew_no             = P_RENEW_NO
      AND t5.pol_flag             IN ('1','2','3','X')   
      AND t5.policy_id            = t8.policy_id
      AND t8.peril_cd             = v_peril_cd
      AND t8.item_no              = v_item_no
      AND t5.policy_id            = t4.policy_id   
      AND trunc(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
          DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), P_EFF_DATE, t5.eff_date ),t4.eff_date)) 
          <= P_LOSS_DATE 
      AND TRUNC(DECODE(TRUNC(t4.expiry_date),TRUNC(t5.expiry_date),
          DECODE(NVL(t5.endt_expiry_date, t5.expiry_date),
          t5.expiry_date, P_EXPIRY_DATE,t5.endt_expiry_date),t4.expiry_date))
          >= P_LOSS_DATE       
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
  v_trty_limit          giis_dist_share.trty_limit%type;  
  v_facul_amt           gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_net_amt             gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_treaty_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE;
  v_qs_shr_pct          giis_dist_share.qs_shr_pct%type;
  v_acct_trty_type      giis_dist_share.acct_trty_type%type;
  v_share_cd            giis_dist_share.share_cd%type;
  v_policy              VARCHAR2(2000);
  counter               NUMBER := 0;
  v_switch              NUMBER := 0;
  v_policy_id           NUMBER;
  v_clm_dist_no         NUMBER:=0;
  v_peril_sname         giis_peril.peril_sname%type;
  v_trty_peril          giis_peril.peril_sname%type;
  v_share_exist         VARCHAR2(1);
  v_max_hist_seq_no     gicl_clm_res_hist.hist_seq_no%TYPE;
  v_clm_res_hist_id     gicl_clm_res_hist.clm_res_hist_id%TYPE;

BEGIN
 
  BEGIN
    SELECT max(clm_dist_no)
      INTO v_clm_dist_no
      FROM gicl_reserve_ds
     WHERE claim_id = P_CLAIM_ID
       AND clm_res_hist_id = P_CLM_RES_HIST_ID;
       
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
           v_clm_dist_no := 0; 

  END;
  
  v_clm_dist_no := NVL(v_clm_dist_no,0) + 1;
    
  P_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P_CLAIM_ID)|| ' ' || 'ITEM NO: '||P_ITEM_NO|| ' PERIL CD: '||P_PERIL_CD|| ' GROUPED ITEM NO: '||P_GROUPED_ITEM_NO;
  
  
      

  FOR c1 in cur_clm_res LOOP        /*Using Item-peril cursor */
    BEGIN
      SELECT param_value_n
        INTO v_facul_share_cd
        FROM giis_parameters
       WHERE param_name = 'FACULTATIVE';
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table. ';   
    END;

    BEGIN
      SELECT param_value_v
        INTO v_trty_share_type
        FROM giac_parameters
       WHERE param_name = 'TRTY_SHARE_TYPE';
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table. ';   
    END;

    BEGIN
      SELECT param_value_v
        INTO v_facul_share_type
        FROM giac_parameters
       WHERE param_name = 'FACUL_SHARE_TYPE';
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table. ';   
    END;

    BEGIN
      SELECT param_value_n
        INTO v_acct_trty_type
        FROM giac_parameters
       WHERE param_name = 'QS_ACCT_TRTY_TYPE';
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table. ';   
    END;

    BEGIN
      SELECT SUM(a.tsi_amt)
        INTO sum_tsi_amt
        FROM giri_basic_info_item_sum_v a, giuw_pol_dist b
       WHERE a.policy_id  = b.policy_id
         AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date),
             DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), P_EFF_DATE, a.eff_date ),b.eff_date)) 
             <= P_LOSS_DATE 
         AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date),
             DECODE(NVL(a.endt_expiry_date, a.expiry_date),
             a.expiry_date, P_EXPIRY_DATE,a.endt_expiry_date ),b.expiry_date)) 
             >= P_LOSS_DATE
         AND a.item_no    = c1.item_no
         AND a.peril_cd   = c1.peril_cd
         AND a.line_cd    = P_LINE_CD
         AND a.subline_cd = P_SUBLINE_CD
         AND a.iss_cd     = P_POL_ISS_CD
         AND a.issue_yy   = P_ISSUE_YY
         AND a.pol_seq_no = P_POL_SEQ_NO
         AND a.renew_no   = P_RENEW_NO
         AND b.dist_flag  = (SELECT param_value_v
                               FROM giis_parameters
                              WHERE param_name = 'DISTRIBUTED');
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'The TSI for this policy is Zero... ';                          
    END; 

    DECLARE
      CURSOR QUOTA_SHARE_TREATIES IS
        SELECT trty_limit, qs_shr_pct, share_cd
          FROM giis_dist_share
         WHERE line_cd        = P_LINE_CD
           AND eff_date       <= NVL(P_DISTRIBUTION_DATE,sysdate)
           AND expiry_date    >= NVL(P_DISTRIBUTION_DATE,sysdate)
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
  
    FOR me IN cur_perilds(c1.peril_cd, c1.item_no) LOOP
      IF me.acct_trty_type = v_acct_trty_type THEN
         v_switch  := 1;
      ELSIF ((me.acct_trty_type = v_acct_trty_type) OR
        (me.acct_trty_type is null)) and (v_switch <> 1) THEN
         v_switch := 0;
      END IF;
    END LOOP;
    BEGIN
      SELECT peril_sname
        INTO v_peril_sname
        FROM giis_peril
       WHERE peril_cd = c1.peril_cd
         AND line_cd = P_LINE_CD;
    END;
 
    BEGIN
      SELECT param_value_v
        INTO v_trty_peril
        FROM giac_parameters
       WHERE param_name = 'TRTY_PERIL';
    END;
    
    IF v_peril_sname = v_trty_peril THEN
       SELECT param_value_n
         INTO v_trty_limit
         FROM giac_parameters
        WHERE param_name = 'TRTY_PERIL_LIMIT';
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
   /*Start of distribution*/
   
    FOR c2 in cur_perilds(c1.peril_cd,c1.item_no) LOOP /*Underwriting peril distribution*/
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
              AND TRUNC(c2.expiry_date) < TRUNC(NVL(P_DISTRIBUTION_DATE,sysdate)) THEN    
              WHILE TRUNC(c2.expiry_date) < TRUNC(NVL(P_DISTRIBUTION_DATE,sysdate)) LOOP
                BEGIN
                    SELECT share_cd, trty_yy, NVL(prtfolio_sw, 'N'),
                         acct_trty_type, share_type, expiry_date 
                    INTO v_share_cd, v_treaty_yy2, v_prtf_sw,
                         v_acct_trty, v_share_type, v_expiry_date
                      FROM giis_dist_share
                     WHERE line_cd           = P_LINE_CD
                       AND old_trty_seq_no =  c2.share_cd;
                EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'No new treaty set-up for year '|| TO_CHAR (NVL (P_DISTRIBUTION_DATE,SYSDATE),'YYYY');
                     EXIT;
                     WHEN TOO_MANY_ROWS
                     THEN P_MESSAGE := P_MESSAGE || ' Status: ' ||'Too many treaty set-up for year '|| TO_CHAR (NVL (P_DISTRIBUTION_DATE,SYSDATE),'YYYY');                           
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
            AND line_cd     = P_LINE_CD)
      LOOP
        v_share_exist :='Y';
      END LOOP;

      IF ann_dist_spct <> 0 THEN
         IF v_share_exist = 'N' THEN
               INSERT INTO gicl_reserve_ds(claim_id,        clm_res_hist_id,    
                                        dist_year,       clm_dist_no,         
                                        item_no,         peril_cd,
                                        grouped_item_no,  
                                        grp_seq_no,      share_type,         
                                        shr_pct,         shr_loss_res_amt,        
                                        shr_exp_res_amt, line_cd, 
                                                acct_trty_type,  user_id,         
                                        last_update,     hist_seq_no)
                                VALUES (c1.claim_id,               c1.clm_res_hist_id,     
                                        to_char(NVL(p_distribution_date,sysdate),'YYYY'),
                                        v_clm_dist_no,        c1.item_no,
                                        c1.peril_cd,          nvl(c1.grouped_item_no, 0),
                                        c2.share_cd,
                                        c2.share_type,        ann_dist_spct,
                                        v_loss_res_amt,       v_exp_res_amt,
                                        P_LINE_CD, c2.acct_trty_type,
                                        USER,             SYSDATE,
                                        c1.hist_seq_no);
                    
         ELSE 
            UPDATE gicl_reserve_ds
               SET shr_pct          = NVL(shr_pct,0) + NVL(ann_dist_spct,0),
                   shr_loss_res_amt = NVL(shr_loss_res_amt,0) + NVL(v_loss_res_amt,0),
                   shr_exp_res_amt  = NVL(shr_exp_res_amt,0) + NVL(v_exp_res_amt,0)
             WHERE claim_id    = c1.claim_id
               AND hist_seq_no = c1.hist_seq_no
               AND nvl(grouped_item_no, 0) = nvl(c1.grouped_item_no, 0)
               AND item_no     = c1.item_no
               AND peril_cd    = c1.peril_cd
               AND grp_seq_no  = c2.share_cd
               AND line_cd     = P_LINE_CD;
         END IF;           

         me := to_number(c2.share_type) - to_number(v_trty_share_type);

         IF me = 0 THEN
            FOR c_trty in cur_trty(c2.share_cd, c2.trty_yy) LOOP
              IF v_share_exist = 'N' THEN 
                 INSERT INTO gicl_reserve_rids(claim_id,                 clm_res_hist_id,             
                                               dist_year,            clm_dist_no, 
                                               item_no,            peril_cd,                                               
                                               grp_seq_no,         share_type,              
                                               ri_cd,                    shr_ri_pct,                  
                                               shr_ri_pct_real,       shr_loss_ri_res_amt, 
                                                      shr_exp_ri_res_amt, line_cd,              
                                               acct_trty_type,     prnt_ri_cd,                 
                                               hist_seq_no,              grouped_item_no) 
                                            VALUES(c1.claim_id,         c1.clm_res_hist_id,      
                                               to_char(nvl(P_DISTRIBUTION_DATE,sysdate),'YYYY'),
                                               v_clm_dist_no,       c1.item_no,
                                               c1.peril_cd,         c2.share_cd,
                                               v_trty_share_type,     c_trty.ri_cd,
                                               (ann_dist_spct  * c_trty.trty_shr_pct/100), 
                                               c_trty.trty_shr_pct, (v_loss_res_amt * c_trty.trty_shr_pct/100),
                                                   (v_exp_res_amt  * c_trty.trty_shr_pct/100), P_LINE_CD, 
                                               c2.acct_trty_type,   c_trty.prnt_ri_cd,     
                                               c1.hist_seq_no,     nvl(c1.grouped_item_no,0)); 
              ELSE 
                 UPDATE gicl_reserve_rids
                    SET shr_exp_ri_res_amt  = NVL(shr_exp_ri_res_amt,0) + (NVL(v_exp_res_amt,0)* c_trty.trty_shr_pct/100),
                        shr_loss_ri_res_amt = NVL(shr_loss_ri_res_amt,0) + (NVL(v_loss_res_amt,0)* c_trty.trty_shr_pct/100),
                        shr_ri_pct          = NVL(shr_ri_pct,0) + (NVL(ann_dist_spct,0)* c_trty.trty_shr_pct/100)
                  WHERE claim_id    = c1.claim_id
                    AND hist_seq_no = c1.hist_seq_no
                    AND item_no     = c1.item_no
                    AND peril_cd    = c1.peril_cd
                    AND nvl(grouped_item_no,0) = nvl(c1.grouped_item_no,0)
                    AND grp_seq_no  = c2.share_cd
                    AND ri_cd       = c_trty.ri_cd
                    AND line_cd     = P_LINE_CD;
              END IF;           
            END LOOP; /*end of c_trty loop*/
         ELSIF c2.share_type = v_facul_share_type THEN
            FOR c3 in cur_frperil(c1.peril_cd,c1.item_no) LOOP /*RI peril distribution*/
              IF (c2.acct_trty_type <> v_acct_trty_type) or (c2.acct_trty_type is null) then 
                 ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
              ELSE
                 ann_ri_pct := (v_facul_amt /sum_tsi_Amt) * 100;
              END IF; 
                 
               INSERT INTO gicl_reserve_rids(claim_id,              clm_res_hist_id,
                                            dist_year,          clm_dist_no,
                                            item_no,            peril_cd,
                                            grp_seq_no,         share_type,
                                            ri_cd,              shr_ri_pct,
                                            shr_ri_pct_real,    shr_loss_ri_res_amt,
                                            shr_exp_ri_res_amt, line_cd,
                                            acct_trty_type,     prnt_ri_cd,
                                            hist_seq_no,               grouped_item_no) 
                                         VALUES(c1.claim_id,            c1.clm_res_hist_id,
                                            to_char(NVL(P_DISTRIBUTION_DATE,sysdate), 'YYYY'),
                                                    v_clm_dist_no,        c1.item_no,
                                                    c1.peril_cd,          c2.share_cd, 
                                                    v_facul_share_type,   c3.ri_cd,
                                                    ann_ri_pct,           ann_ri_pct*100/ann_dist_spct,
                                                    (c1.loss_reserve * ann_ri_pct/100),
                                                   (c1.expense_reserve * ann_ri_pct/100),
                                                   P_LINE_CD, c2.acct_trty_type,
                                                   c3.ri_cd,        c1.hist_seq_no, nvl(c1.grouped_item_no,0));
            END LOOP; /*End of c3 loop */
         END IF;
      ELSE 
         NULL;
      END IF;
    END LOOP; /*End of c2 loop*/
  
    --EXCESS OF LOSS
    DECLARE
        v_retention               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_retention_orig          gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_running_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_total_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_allowed_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_total_xol_share         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_overall_xol_share       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_overall_allowed_share   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_old_xol_share           gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;        
        v_allowed_ret             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_shr_pct                 gicl_reserve_ds.shr_pct%TYPE;
    BEGIN    
        IF p_catastrophic_cd IS NULL THEN
           FOR NET_SHR IN 
             (SELECT (shr_loss_res_amt * c1.convert_rate) loss_reserve, 
                     (shr_exp_res_amt* c1.convert_rate) exp_reserve, 
                     shr_pct
                  FROM gicl_reserve_ds
                WHERE claim_id    = c1.claim_id
                  AND nvl(grouped_item_no,0) = nvl(c1.grouped_item_no,0) 
                   AND hist_seq_no = c1.hist_seq_no
                   AND item_no     = c1.item_no
                 AND peril_cd    = c1.peril_cd
                 AND share_type  = '1')        
           LOOP
               
           v_retention      := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
           v_retention_orig := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
             FOR TOT_NET IN
                  (SELECT SUM(NVL(a.shr_loss_res_amt * c.convert_rate,0) + NVL( a.shr_exp_res_amt* c.convert_rate,0)) ret_amt
                   FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
                  WHERE a.claim_id              = c1.claim_id
                    AND a.claim_id              = b.claim_id
                    AND nvl(a.grouped_item_no,0)= nvl(b.grouped_item_no,0)
                    AND a.item_no               = b.item_no
                    AND a.peril_cd              = b.peril_cd
                    AND a.claim_id              = c.claim_id
                    AND nvl(a.grouped_item_no,0)= nvl(c.grouped_item_no,0)
                    AND a.item_no               = c.item_no
                    AND a.peril_cd              = c.peril_cd
                    AND a.clm_dist_no           = c.dist_no
                    AND a.clm_res_hist_id       = c.clm_res_hist_id  
                    AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                 AND NVL(a.negate_tag,'N')   = 'N'
                 AND a.share_type            = '1'
                 AND (a.item_no  <> c1.item_no OR a.peril_cd <> c1.peril_cd OR a.grouped_item_no <> c1.grouped_item_no))
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
                 AND TRUNC(a.eff_date)    <= TRUNC(p_loss_date)
                 AND TRUNC(a.expiry_date) >= TRUNC(p_loss_date)
                 AND b.peril_cd           = c1.peril_cd             
                 AND a.line_cd            = P_LINE_CD                
               ORDER BY xol_base_amount ASC)
           LOOP
               v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
               IF v_allowed_retention < 1 THEN             
                   EXIT;
               END IF;

               FOR get_all_xol IN
                 (SELECT SUM(NVL(a.shr_loss_res_amt *c.convert_rate,0) + NVL( a.shr_exp_res_amt*c.convert_rate,0)) ret_amt
                   FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
                   WHERE NVL(a.negate_tag,'N')   = 'N'
                     AND a.item_no               = b.item_no
                     AND nvl(a.grouped_item_no,0)= nvl(b.grouped_item_no,0)
                     AND a.peril_cd              = b.peril_cd
                     AND a.claim_id              = b.claim_id
                     AND a.item_no               = c.item_no
                     AND nvl(a.grouped_item_no,0)= nvl(c.grouped_item_no,0)
                     AND a.peril_cd              = c.peril_cd
                     AND a.claim_id              = c.claim_id
                     AND NVL(a.clm_dist_no, -1)  = NVL(c.dist_no, -1)
                     AND a.clm_res_hist_id       = c.clm_res_hist_id  
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
               v_old_xol_share := 0;

               FOR TOTAL_XOL IN
                 (SELECT SUM(NVL(a.shr_loss_res_amt * c.convert_rate,0) + NVL( a.shr_exp_res_amt *c.convert_rate,0)) ret_amt
                    FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
                    WHERE a.claim_id              = c1.claim_id
                      AND a.claim_id              = b.claim_id
                      AND nvl(a.grouped_item_no,0)= nvl(b.grouped_item_no,0)
                      AND a.item_no               = b.item_no
                      AND a.peril_cd              = b.peril_cd
                      AND a.claim_id              = c.claim_id
                      AND a.item_no               = c.item_no
                      AND a.peril_cd              = c.peril_cd
                      AND nvl(a.grouped_item_no,0)= nvl(c.grouped_item_no,0)
                      AND a.clm_res_hist_id       = c.clm_res_hist_id  
                      AND a.clm_dist_no           = c.dist_no
                      AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                      AND NVL(a.negate_tag,'N')   = 'N'
                      AND a.grp_seq_no            = chk_xol.share_cd)
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
                       INSERT INTO gicl_reserve_ds (claim_id,         clm_res_hist_id,    
                                             dist_year,        clm_dist_no,
                                             item_no,          peril_cd,
                                             grouped_item_no,
                                             grp_seq_no,      share_type,
                                             shr_pct,         shr_loss_res_amt,
                                             shr_exp_res_amt, line_cd,
                                             acct_trty_type,  user_id,
                                             last_update,     hist_seq_no)
                                     VALUES (c1.claim_id,             c1.clm_res_hist_id,
                                             to_char(NVL(P_DISTRIBUTION_DATE, SYSDATE),'YYYY'),
                                             v_clm_dist_no,        c1.item_no,
                                             c1.peril_cd,          nvl(c1.grouped_item_no,0), 
                                             chk_xol.share_cd,
                                             chk_xol.share_type,  ( net_shr.shr_pct * v_shr_pct),
                                             (net_shr.loss_reserve * v_shr_pct)/ c1.convert_rate,
                                             (net_shr.exp_reserve * v_shr_pct) / c1.convert_rate,
                                             P_LINE_CD, chk_xol.acct_trty_type,
                                             USER,             SYSDATE,
                                             c1.hist_seq_no);                 
                       
                FOR update_xol_trty IN
                    (SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
                       FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
                       WHERE NVL(a.negate_tag,'N')   = 'N'
                         AND a.claim_id              = b.claim_id
                         AND a.clm_res_hist_id       = b.clm_res_hist_id
                         AND a.claim_id              = c.claim_id
                         AND a.item_no               = c.item_no
                         AND a.peril_cd              = c.peril_cd
                         AND nvl(a.grouped_item_no,0)= nvl(c.grouped_item_no,0)
                         AND a.clm_dist_no              = b.dist_no
                         AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
                         AND a.grp_seq_no            = chk_xol.share_cd
                         AND a.line_cd               = chk_xol.line_cd)
                LOOP     
                  UPDATE giis_dist_share 
                     SET xol_reserve_amount = update_xol_trty.ret_amt
                   WHERE share_cd           = chk_xol.share_cd
                     AND line_cd            = chk_xol.line_cd;
                END LOOP;

                FOR xol_trty IN
                  cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
                LOOP
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
                                                     TO_CHAR(nvl(P_DISTRIBUTION_DATE, SYSDATE),'YYYY'),
                                                     v_clm_dist_no,        c1.item_no,
                                                     c1.peril_cd,          chk_xol.share_cd,
                                                     chk_xol.share_type,   xol_trty.ri_cd,
                                                     ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                                                     xol_trty.trty_shr_pct,
                                                     ((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100))/ c1.convert_rate,
                                                     ((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100))/ c1.convert_rate,
                                                     P_LINE_CD, chk_xol.acct_trty_type,
                                                     xol_trty.prnt_ri_cd,  c1.hist_seq_no, nvl(c1.grouped_item_no,0));
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
                 WHERE claim_id               = c1.claim_id
                   AND hist_seq_no            = c1.hist_seq_no
                   AND nvl(grouped_item_no,0) = nvl(c1.grouped_item_no,0) 
                   AND item_no                = c1.item_no
                   AND peril_cd               = c1.peril_cd
                   AND share_type             = '1')        
           LOOP
               
               v_retention := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
           v_retention_orig :=NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
             FOR TOT_NET IN
                  (SELECT SUM(NVL(shr_loss_res_amt* d.convert_rate,0) + NVL( shr_exp_res_amt* d.convert_rate,0)) ret_amt
                   FROM gicl_reserve_ds a, gicl_claims c, gicl_item_peril b, gicl_clm_res_hist d
                  WHERE a.claim_id = c.claim_id
                    AND a.claim_id = b.claim_id
                    AND nvl(a.grouped_item_no,0) = nvl(b.grouped_item_no,0)
                    AND a.item_no = b.item_no
                    AND a.peril_cd = b.peril_cd
                    AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                    AND c.catastrophic_cd = P_CATASTROPHIC_CD
                    AND NVL(negate_tag,'N') = 'N'
                    AND share_type = '1'
                    AND a.claim_id              = d.claim_id
                    AND nvl(a.grouped_item_no,0)= nvl(d.grouped_item_no,0)
                    AND a.item_no               = d.item_no
                    AND a.peril_cd              = d.peril_cd
                    AND a.clm_dist_no           = d.dist_no
                    AND a.clm_res_hist_id       = d.clm_res_hist_id  
                    AND (a.claim_id <> P_CLAIM_ID
                     OR a.item_no <> c1.item_no
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
                 AND TRUNC(a.eff_date)    <= TRUNC(p_loss_date)
                 AND TRUNC(a.expiry_date) >= TRUNC(p_loss_date)
                 AND b.peril_cd           = c1.peril_cd             
                 AND a.line_cd            = p_line_cd                
               ORDER BY xol_base_amount ASC)
           LOOP
               v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
               IF v_allowed_retention < 1 THEN             
                   EXIT;
               END IF;
               
               FOR get_all_xol IN
                 (SELECT SUM(NVL(shr_loss_res_amt* c.convert_rate,0) + NVL( shr_exp_res_amt* c.convert_rate,0)) ret_amt
                   FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
                   WHERE NVL(negate_tag,'N')     = 'N'
                     AND a.claim_id              = b.claim_id
                     AND a.item_no               = b.item_no
                     AND a.peril_cd              = b.peril_cd
                     AND nvl(a.grouped_item_no,0)= nvl(b.grouped_item_no,0)
                     AND a.claim_id              = c.claim_id
                    AND nvl(a.grouped_item_no,0)= nvl(c.grouped_item_no,0)
                    AND a.item_no               = c.item_no
                    AND a.peril_cd              = c.peril_cd
                    AND a.clm_dist_no              = c.dist_no
                    AND a.clm_res_hist_id = c.clm_res_hist_id
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
                 (SELECT SUM(NVL(shr_loss_res_amt* d.convert_rate,0) + NVL( shr_exp_res_amt * d.convert_rate,0)) ret_amt
                    FROM gicl_reserve_ds a, gicl_claims c, gicl_item_peril b, gicl_clm_res_hist d
                    WHERE c.claim_id              = a.claim_id
                      AND nvl(a.grouped_item_no,0)= nvl(b.grouped_item_no,0)
                      AND a.claim_id              = b.claim_id
                      AND a.item_no               = b.item_no
                      AND a.peril_cd              = b.peril_cd
                      AND a.claim_id              = d.claim_id
                    AND nvl(a.grouped_item_no,0)= nvl(d.grouped_item_no,0)
                    AND a.item_no               = d.item_no
                    AND a.peril_cd              = d.peril_cd
                    AND a.clm_dist_no              = d.dist_no
                    AND a.clm_res_hist_id       = d.clm_res_hist_id  
                      AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
                      AND c.catastrophic_cd       = P_CATASTROPHIC_CD
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
                      INSERT INTO gicl_reserve_ds (claim_id,        clm_res_hist_id,
                                                         dist_year,       clm_dist_no,
                                                         item_no,           peril_cd,
                                                        grouped_item_no,
                                                         grp_seq_no,      share_type,
                                                         shr_pct,         shr_loss_res_amt,
                                                         shr_exp_res_amt, line_cd,
                                                         acct_trty_type,   user_id,
                                                         last_update,      hist_seq_no)
                                                 VALUES (c1.claim_id,          c1.clm_res_hist_id,     
                                                         TO_CHAR(NVL(P_DISTRIBUTION_DATE, SYSDATE),'YYYY'),
                                                         v_clm_dist_no,        c1.item_no,
                                                         c1.peril_cd,          nvl(c1.grouped_item_no,0),
                                                         chk_xol.share_cd,
                                                         chk_xol.share_type,   (net_shr.shr_pct * v_shr_pct),
                                                         (net_shr.loss_reserve * v_shr_pct)/ c1.convert_rate,
                                                         (net_shr.exp_reserve * v_shr_pct)/ c1.convert_rate,
                                                         P_LINE_CD, chk_xol.acct_trty_type,
                                                         USER,           SYSDATE,
                                                         c1.hist_seq_no); 
                FOR update_xol_trty IN
                    (SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
                       FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
                       WHERE NVL(a.negate_tag,'N')   = 'N'
                         AND a.claim_id              = b.claim_id
                         AND a.clm_res_hist_id       = b.clm_res_hist_id
                         AND a.claim_id              = c.claim_id
                         AND a.item_no               = c.item_no
                         AND a.peril_cd              = c.peril_cd                       
                         AND nvl(a.grouped_item_no,0)= nvl(c.grouped_item_no,0)
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
                  cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
                LOOP
                 
                        INSERT INTO gicl_reserve_rids (claim_id,           clm_res_hist_id,
                                                         dist_year,            clm_dist_no,
                                                         item_no,            peril_cd,                                                 
                                                         grp_seq_no,         share_type,
                                                         ri_cd,              shr_ri_pct,
                                                         shr_ri_pct_real,    shr_loss_ri_res_amt,
                                                         shr_exp_ri_res_amt, line_cd,
                                                         acct_trty_type,     prnt_ri_cd,
                                                         hist_seq_no,              grouped_item_no) 
                                                     VALUES (c1.claim_id,          c1.clm_res_hist_id,
                                                             TO_CHAR(nvl(P_DISTRIBUTION_DATE, SYSDATE),'YYYY'),
                                                             v_clm_dist_no,        c1.item_no,
                                                             c1.peril_cd,          chk_xol.share_cd,
                                                             chk_xol.share_type,   xol_trty.ri_cd,
                                                             ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                                                             xol_trty.trty_shr_pct,
                                                             ((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100))/ c1.convert_rate,
                                                             ((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100))/ c1.convert_rate,
                                                             P_LINE_CD, chk_xol.acct_trty_type,
                                                             xol_trty.prnt_ri_cd,  c1.hist_seq_no, nvl(c1.grouped_item_no,0)); 
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
               AND nvl(grouped_item_no,0)= nvl(c1.grouped_item_no,0)
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
               AND nvl(grouped_item_no,0)= nvl(c1.grouped_item_no,0)
               AND share_type  = '1';
      END IF;
    END;

    UPDATE gicl_clm_res_hist
       SET dist_sw = 'Y',
           dist_no = v_clm_dist_no
     WHERE current of cur_clm_res;
  P_MESSAGE := P_MESSAGE || ' Status: ' ||'Distribution Complete. ';
  END LOOP;

 OFFSET_AMT(V_CLM_DIST_NO, P_CLAIM_ID, P_CLM_RES_HIST_ID);

END DISTRIBUTE_RESERVE;


--PROCESS_DISTRIBUTION (CALL FROM CREATE_NEW_RESERVE)
PROCEDURE PROCESS_DISTRIBUTION (P_CLM_RES_HIST_ID   IN   GICL_CLM_RES_HIST.CLM_RES_HIST_ID%TYPE,
                                P_HIST_SEQ_NO       IN   GICL_CLM_RES_HIST.HIST_SEQ_NO%TYPE,
                                P_CLAIM_ID          IN   GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                                P_ITEM_NO           IN   GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                                P_PERIL_CD          IN   GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                                P_GROUPED_ITEM_NO   IN   GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                                P_DISTRIBUTION_DATE IN   GICL_CLM_RES_HIST.DISTRIBUTION_DATE%TYPE,
                                P_CATASTROPHIC_CD   IN   GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                                P_MESSAGE           OUT  VARCHAR2)
AS
  v_prtf_sw         NUMBER := 0;   --indicate if distribution is portfolio or natural expiry
  v_loss_amt        gicl_claims.loss_res_amt%TYPE;  --temp. storage of loss_reserve amount for gicl_claims update
  v_exp_amt         gicl_claims.exp_res_amt%TYPE;   --temp. storage of exp_reserve amount for gicl_claims update
  v_eff_date        gipi_polbasic.eff_date%type;
  v_expiry_date     gipi_polbasic.expiry_date%type;
  v_loss_date       gicl_claims.loss_date%TYPE;
  v_line_cd         gipi_polbasic.line_cd%type;
  v_subline_cd      gipi_polbasic.subline_cd%type;
  v_pol_iss_cd      gipi_polbasic.iss_cd%type;
  v_issue_yy        gipi_polbasic.issue_yy%type;
  v_pol_seq_no      gipi_polbasic.pol_seq_no%type;
  v_renew_no        gipi_polbasic.renew_no%type;
  --v_catastrophic_cd gicl_claims.catastrophic_cd%type;
BEGIN
SELECT a.pol_eff_date, a.expiry_date, a.loss_date, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no--, a.catastrophic_cd
  INTO v_eff_date,     v_expiry_date, v_loss_date, v_line_cd, v_subline_cd, v_pol_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no--, v_catastrophic_cd
  FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
 WHERE a.loss_cat_cd = b.loss_cat_cd
   AND a.line_cd     = b.line_cd
   AND a.claim_id    = P_CLAIM_ID
   AND c.clm_stat_cd = a.clm_stat_cd;
  
  --update negate_tag on table gicl_reserve_ds to 'Y' to indicate
  --that it is already negated
  UPDATE gicl_reserve_ds
     SET negate_tag = 'Y'
   WHERE claim_id = P_CLAIM_ID
     AND hist_seq_no < P_HIST_SEQ_NO
     AND item_no = P_ITEM_NO
     AND peril_cd = P_PERIL_CD
     AND nvl(grouped_item_no, 0) = nvl(P_GROUPED_ITEM_NO, 0); 
  --check if distribution is natural expiry or portfolio transfer
    
    DISTRIBUTE_RESERVE (P_CLAIM_ID, P_HIST_SEQ_NO, P_CLM_RES_HIST_ID, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO, V_EFF_DATE, V_EXPIRY_DATE,
                      V_LOSS_DATE, V_LINE_CD, V_SUBLINE_CD, V_POL_ISS_CD, V_ISSUE_YY, V_POL_SEQ_NO, V_RENEW_NO, P_CATASTROPHIC_CD,
                      P_DISTRIBUTION_DATE, P_MESSAGE);
   
  --     summation of reserves for update in table gicl_claims should consider
  --     that the record is not denied,cancelled or withdrawn
  FOR sum_res IN
    (SELECT SUM(loss_reserve) loss_reserve,
            SUM(expense_reserve) exp_reserve
      FROM gicl_clm_reserve a, gicl_item_peril b
     WHERE a.claim_id = b.claim_id
       AND nvl(a.grouped_item_no, 0) = nvl(b.grouped_item_no, 0)
       AND a.item_no  = b.item_no
       AND a.peril_cd = b.peril_cd
       AND a.claim_id = p_claim_id
       AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP'))
  LOOP
    v_loss_amt :=  sum_res.loss_reserve;
    v_exp_amt  :=  sum_res.exp_reserve;
    EXIT;
  END LOOP;  --end sum_res loop
  --update table  gicl_claims for correct reserve amounts
  UPDATE gicl_claims
     SET loss_res_amt = nvl(v_loss_amt,0),
         exp_res_amt  = nvl(v_exp_amt,0)
   WHERE claim_id     = p_claim_id;
END PROCESS_DISTRIBUTION;


--CREATE_NEW_RESERVE (CALL FROM DIST_CLM_RECORDS)
PROCEDURE CREATE_NEW_RESERVE (P_CLAIM_ID            IN   GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                              P_LOSS_DATE           IN   GICL_CLAIMS.LOSS_DATE%TYPE,
                              P_ITEM_NO             IN   GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                              P_PERIL_CD            IN   GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                              P_GROUPED_ITEM_NO     IN   GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                              P_LOSS_RESERVE        IN   GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                              P_EXPENSE_RESERVE     IN   GICL_CLM_RES_HIST.EXPENSE_RESERVE%TYPE,
                              P_CURRENCY_CD         IN   GICL_CLM_RES_HIST.CURRENCY_CD%TYPE,
                              P_CONVERT_RATE        IN   GICL_CLM_RES_HIST.CONVERT_RATE%TYPE,
                              P_DISTRIBUTION_DATE   IN   GICL_CLM_RES_HIST.DISTRIBUTION_DATE%TYPE,
                              P_CAT_CD              IN   GICL_CLAIMS.CATASTROPHIC_CD%TYPE,                                                
                              P_CLM_FILE_DATE       IN   GICL_CLAIMS.CLM_FILE_DATE%TYPE,
                              P_MESSAGE             OUT  VARCHAR2)
AS
  -- variable to be use for storing hist_seq_no to be used by new reserve record
  v_hist_seq_no      gicl_clm_res_hist.hist_seq_no%TYPE := 1;     
  -- variable to be use for storing old hist_seq_no to be used for update of prev reserve and payments
  v_hist_seq_no_old      gicl_clm_res_hist.hist_seq_no%TYPE := 0;
  -- variable to be use for storing clm_res_hist_id to be used by new reserve record
  v_clm_res_hist_id    gicl_clm_res_hist.clm_res_hist_id%TYPE := 1;
  -- variable to be use for storing previous loss reseve to be used by new reserve record  
  v_prev_loss_res       gicl_clm_res_hist.prev_loss_res%TYPE :=0;
  -- variable to be use for storing previous exp. reseve to be used by new reserve record  
  v_prev_exp_res        gicl_clm_res_hist.prev_loss_res%TYPE :=0;
  -- variable to be use for storing previous loss paid to be used by new reserve record  
  v_prev_loss_paid      gicl_clm_res_hist.prev_loss_res%TYPE :=0;
  -- variable to be use for storing previous exp.paid to be used by new reserve record  
  v_prev_exp_paid       gicl_clm_res_hist.prev_loss_res%TYPE :=0;
  v_month               gicl_clm_res_hist.booking_month%type;
  v_year                gicl_clm_res_hist.booking_year%type;
BEGIN
  -- get max hist_seq_no from gicl_clm_res_hist for insert of new reserve record
 FOR hist IN
    (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) + 1 seq_no
       FROM gicl_clm_res_hist
       WHERE claim_id = p_claim_id
         AND item_no  = p_item_no
         AND peril_cd = p_peril_cd
         AND nvl(grouped_item_no, 0) = nvl(p_grouped_item_no,0))
  LOOP
    v_hist_seq_no := hist.seq_no;
    EXIT;
  END LOOP; --end hist loop
  -- get prev hist_seq_no from gicl_clm_res_hist for update of previous amounts
  FOR old_hist IN
    (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) seq_no
       FROM gicl_clm_res_hist
       WHERE claim_id = p_claim_id
         AND item_no  = p_item_no
         AND peril_cd = p_peril_cd
         AND nvl(grouped_item_no, 0) = nvl(p_grouped_item_no,0)
         AND NVL(dist_sw,'N') = 'Y')
  LOOP
    v_hist_seq_no_old := old_hist.seq_no;
    EXIT;
  END LOOP; --end old_hist loop
  -- get max clm_res_hist_id from gicl_clm_res_hist for insert of new reserve record
  FOR hist_id IN
    (SELECT NVL(MAX(NVL(clm_res_hist_id,0)),0) + 1 hist_id
       FROM gicl_clm_res_hist
       WHERE claim_id = p_claim_id)
  LOOP
    v_clm_res_hist_id := hist_id.hist_id;
    EXIT;
  END LOOP; --end hist_id loop
  -- get prev amounts from gicl_clm_res_hist using old hist_seq_no 
  -- for insert of new reserve record
  FOR prev_amt IN
    (SELECT nvl(loss_reserve,0) loss_reserve, 
            nvl(expense_reserve,0) expense_reserve,
            nvl(losses_paid,0)  losses_paid, 
            nvl(expenses_paid,0) expenses_paid
       FROM gicl_clm_res_hist
      WHERE claim_id    = p_claim_id
        AND item_no     = p_item_no
        AND peril_cd    = p_peril_cd
        AND nvl(grouped_item_no, 0) = nvl(p_grouped_item_no,0)
        AND hist_seq_no = v_hist_seq_no_old)
  LOOP
    v_prev_loss_res  := prev_amt.loss_reserve;
    v_prev_exp_res   := prev_amt.expense_reserve;
    v_prev_loss_paid := prev_amt.losses_paid;
    v_prev_exp_paid  := prev_amt.expenses_paid;
  END LOOP;  -- end prev_amt loop
  
 
  -- retrieve valid booking date for this record

GET_BOOKING_DATE(P_LOSS_DATE, P_CLM_FILE_DATE, V_MONTH, V_YEAR);

 
  -- insert record into table gicl_clm_res_hist
    INSERT INTO GICL_CLM_RES_HIST
        (claim_id,             clm_res_hist_id,    hist_seq_no,
         item_no,              peril_cd,           grouped_item_no, 
         user_id,
         last_update,          loss_reserve,       expense_reserve,   
         dist_sw,              booking_month,      booking_year,
         currency_cd,          convert_rate,       prev_loss_res,
         prev_loss_paid,       prev_exp_res,       prev_exp_paid,
         distribution_date)
      VALUES
        (p_claim_id,           v_clm_res_hist_id,  v_hist_seq_no,
         p_item_no,            p_peril_cd,         p_grouped_item_no, 
         USER,
         SYSDATE,              p_loss_reserve,     p_expense_reserve,
         'Y',                  v_month,            v_year,
         p_currency_cd,        p_convert_rate,     v_prev_loss_res,
         v_prev_loss_paid,     v_prev_exp_res,     v_prev_exp_paid,
         NVL(p_distribution_date, SYSDATE));
                    
   -- update previous distributed record in gicl_clm_res_hist
  -- set its dist_sw = N and negate date = sysdate
  UPDATE GICL_CLM_RES_HIST
     SET dist_sw     = 'N',
         negate_date = SYSDATE
   WHERE claim_id = p_claim_id
     AND item_no  = p_item_no
     AND peril_cd = p_peril_cd
     AND nvl(grouped_item_no, 0) = nvl(p_grouped_item_no,0)
     AND NVL(dist_sw, 'N') = 'Y'
     AND hist_seq_no <> v_hist_seq_no;
  -- call procedure which will generate records in claims distribution tables
  -- gicl_reserve_ds and gicl_reserve_rids
  
  PROCESS_DISTRIBUTION(V_CLM_RES_HIST_ID, V_HIST_SEQ_NO, P_CLAIM_ID, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO, P_DISTRIBUTION_DATE, P_CAT_CD, P_MESSAGE);
  
END CREATE_NEW_RESERVE;


--UPDATE_CLM_DIST_TAG (CALL FROM DIST_CLM_RECORDS)
PROCEDURE UPDATE_CLM_DIST_TAG (P_CLAIM_ID   IN  GICL_CLM_RES_HIST.CLAIM_ID%TYPE)
AS
  V_EXISTS       VARCHAR2(1);
BEGIN
  BEGIN
    SELECT DISTINCT 'X'
      INTO V_EXISTS
      FROM GICL_CLM_RES_HIST
     WHERE DIST_SW   = 'Y'
       AND CLAIM_ID  = P_CLAIM_ID;
    UPDATE GICL_CLAIMS
       SET CLM_DIST_TAG  = 'N'
     WHERE CLAIM_ID      = P_CLAIM_ID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      UPDATE GICL_CLAIMS
         SET CLM_DIST_TAG  = 'Y'
       WHERE CLAIM_ID      = P_CLAIM_ID;
  END;
END UPDATE_CLM_DIST_TAG;
--DIST_CLM_RECORDS (CALL FROM GICLS038)
PROCEDURE DIST_CLM_RECORDS(P_CLAIM_ID            IN       GICL_CLAIMS.CLAIM_ID%TYPE,
                           P_LOSS_DATE           IN       GICL_CLAIMS.LOSS_DATE%TYPE,
                           P_ITEM_NO             IN       GICL_ITEM_PERIL.ITEM_NO%TYPE,
                           P_PERIL_CD            IN       GICL_ITEM_PERIL.PERIL_CD%TYPE,
                           P_GROUPED_ITEM_NO     IN       GICL_ITEM_PERIL.GROUPED_ITEM_NO%TYPE,
                           P_LOSS_RESERVE        IN       GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                           P_EXPENSE_RESERVE     IN       GICL_CLM_RES_HIST.EXPENSE_RESERVE%TYPE,
                           P_CURRENCY_CD         IN       GICL_CLM_RES_HIST.CURRENCY_CD%TYPE,
                           P_CONVERT_RATE        IN       GICL_CLM_RES_HIST.CONVERT_RATE%TYPE,  
                           P_DISTRIBUTION_DATE   IN       GIIS_DIST_SHARE.EFF_DATE%TYPE,
                           P_CAT_CD              IN       GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                           P_CLM_FILE_DATE       IN       GICL_CLAIMS.CLM_FILE_DATE%TYPE, 
                           P_MESSAGE             OUT      VARCHAR2)
AS
  BEGIN
   BEGIN
   SAVEPOINT A;
     
     CREATE_NEW_RESERVE(P_CLAIM_ID, P_LOSS_DATE, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO, P_LOSS_RESERVE,
                        P_EXPENSE_RESERVE, P_CURRENCY_CD, P_CONVERT_RATE, SYSDATE, P_CAT_CD, P_CLM_FILE_DATE, P_MESSAGE);
                        
     UPDATE_CLM_DIST_TAG(P_CLAIM_ID);
     
     EXCEPTION 
        WHEN ZERO_DIVIDE THEN
           ROLLBACK TO A;
           P_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P_CLAIM_ID)|| ' ' || 'ITEM NO: '||P_ITEM_NO|| ' PERIL CD: '||P_PERIL_CD|| ' GROUPED ITEM NO: '||P_GROUPED_ITEM_NO
                                     || ' Status: ' ||'The TSI for this policy is Zero... '; 
   END;
   COMMIT;  
  END DIST_CLM_RECORDS; 
END REDISTRIBUTE_RESERVE;
/


