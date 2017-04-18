CREATE OR REPLACE PACKAGE BODY CPI.REDISTRIBUTE_LOSS_EXP
AS
--DIST_CLM_RECORDS (CALL FROM GICLR038)
PROCEDURE DIST_CLM_RECORDS(P_CLAIM_ID           IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                           P_CLM_LOSS_ID        IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                           P_DIST_RG            IN  GICL_CLM_LOSS_EXP.DIST_SW%TYPE,
                           P_ITEM_NO            IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                           P_PERIL_CD           IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                           P_GROUPED_ITEM_NO    IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                           P_LOSS_DATE          IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                           P_POL_EFF_DATE       IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                           P_EXPIRY_DATE        IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE, 
                           P_LINE_CD            IN  GICL_CLAIMS.LINE_CD%TYPE, 
                           P_SUBLINE_CD         IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                           P_POL_ISS_CD         IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                           P_ISSUE_YY           IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                           P_POL_SEQ_NO         IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                           P_RENEW_NO           IN  GICL_CLAIMS.RENEW_NO%TYPE,
                           P_DISTRIBUTION_DATE  IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                           P_PAYEE_CD           IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                           P_HIST_SEQ_NO        IN  GICL_CLM_LOSS_EXP.HIST_SEQ_NO%TYPE,
                           P_PAYEE_TYPE         IN  GICL_CLM_LOSS_EXP.PAYEE_TYPE%TYPE,
                           P_CATASTROPHIC_CD    IN  GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                           P_MESSAGE            OUT VARCHAR2)              
IS
  v_close_flag   gicl_item_peril.close_flag%TYPE;
  v_close_flag2  gicl_item_peril.close_flag2%TYPE;
  --v_dist_sw      gicl_clm_res_hist.dist_sw%TYPE;
  v_switch       varchar2(1);
  v_error        varchar2(1);
  v_dist_sw      gicl_clm_loss_exp.dist_sw%type;
  v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
  v_xol         VARCHAR2(1) := 'N';
  v_curr_xol    VARCHAR2(1) := 'N';
  v_clm_dist_no GICL_LOSS_EXP_DS.CLM_DIST_NO%TYPE;
   FUNCTION DIST_BY_RISK_LOC (v_claim_id           gicl_claims.claim_id%TYPE,
                               v_item_no            gicl_clm_res_hist.item_no%TYPE,
                               v_peril_cd           gicl_clm_res_hist.peril_cd%TYPE,
                               v_grouped_item_no    gicl_clm_res_hist.grouped_item_no%TYPE)
    RETURN BOOLEAN
    IS
    BEGIN
        FOR a IN (SELECT '1'
                    FROM gicl_clm_res_hist
                   WHERE dist_sw = 'Y'
                     AND peril_cd = v_peril_cd
                     AND item_no = v_item_no
                     AND claim_id = v_claim_id
                     AND grouped_item_no = NVL(v_grouped_item_no,0)
                     AND dist_type IN (2, 3))
        LOOP
            RETURN (TRUE);
        END LOOP;
       RETURN (FALSE);
    END;
BEGIN
  -- check peril_status first
  FOR peril_status IN (SELECT close_flag,close_flag2
                         FROM gicl_item_peril
                        WHERE claim_id = P_CLAIM_ID
                          AND item_no  = P_ITEM_NO
                          AND NVL(grouped_item_no,0) = NVL(P_GROUPED_ITEM_NO,0)
                          AND peril_cd = P_PERIL_CD)

  LOOP
    v_close_flag  := NVL(peril_status.close_flag, 'AP');
    v_close_flag2 := NVL(peril_status.close_flag2, 'AP');
  END LOOP;
 
    CHK_XOL(P_CLAIM_ID, P_CLM_LOSS_ID, P_CATASTROPHIC_CD, V_XOL_SHARE_TYPE, V_XOL, V_CURR_XOL); 

       UPDATE gicl_clm_loss_exp
        SET dist_sw     = 'N'
      WHERE claim_id    = P_CLAIM_ID
        AND clm_loss_id = P_CLM_LOSS_ID; 
 
     UPDATE gicl_loss_exp_ds
        SET negate_tag  = 'Y'
      WHERE claim_id    = P_CLAIM_ID
        AND clm_loss_id = P_CLM_LOSS_ID; 

 IF v_xol = 'Y' OR  v_curr_xol = 'Y' THEN
   BEGIN
        FOR update_xol_paid IN(
            SELECT SUM(NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt, grp_seq_no
              FROM gicl_loss_exp_ds a,  gicl_clm_loss_exp b
             WHERE a.claim_id = b.claim_id
               AND a.clm_loss_id = b.clm_loss_id
               AND NVL(b.cancel_sw, 'N') = 'N'
               AND NVL(a.negate_tag, 'N') = 'N'
               AND a.share_type = V_XOL_SHARE_TYPE
               AND a.line_cd = P_LINE_CD
             GROUP BY a.grp_seq_no)
        LOOP     
            UPDATE giis_dist_share 
               SET xol_allocated_amount = update_xol_paid.ret_amt
             WHERE share_cd = update_xol_paid.grp_seq_no
               AND line_cd = P_LINE_CD;
        END LOOP;             
   END;
 END IF;       
 --COMMIT; 
      
  -- Disallows update of tables when peril is not anymore active.
 IF P_PAYEE_TYPE = 'L' AND v_close_flag <> 'AP' THEN
    P_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P_CLAIM_ID)|| ' ' || 'ITEM NO: '||P_ITEM_NO|| ' PERIL CD: '||P_PERIL_CD|| ' GROUPED ITEM NO: '||P_GROUPED_ITEM_NO
                              || ' Status: ' || 'Cannot be updated, Loss for this peril has been closed/withdrawn/denied.';
    v_switch := 'Y';
 ELSIF P_PAYEE_TYPE = 'E' AND v_close_flag <> 'AP' THEN
       P_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P_CLAIM_ID)|| ' ' || 'ITEM NO: '||P_ITEM_NO|| ' PERIL CD: '||P_PERIL_CD|| ' GROUPED ITEM NO: '||P_GROUPED_ITEM_NO
                                 || ' Status: ' || 'Cannot be updated, Expense for this peril has been closed/withdrawn/denied.';
       v_switch := 'Y';
 END IF;
  
 IF nvl(v_switch,'N') != 'Y' THEN
 --insert into cpi.test values('ENTER VALIDATE_EXISTING_DIST'); COMMIT;
 VALIDATE_EXISTING_DIST(P_LINE_CD, P_SUBLINE_CD, P_POL_ISS_CD, P_ISSUE_YY, P_POL_SEQ_NO, P_RENEW_NO, P_MESSAGE, V_ERROR);
    P_MESSAGE :=  'CLAIM NO: ' || GET_CLM_NO(P_CLAIM_ID)|| ' ' || 'ITEM NO: '||P_ITEM_NO|| ' PERIL CD: '||P_PERIL_CD|| ' GROUPED ITEM NO: '||P_GROUPED_ITEM_NO
                                     || ' Status: ' || P_MESSAGE;                    
   -- insert into cpi.test values('EXIT VALIDATE_EXISTING_DIST'); COMMIT;
    IF nvl(V_ERROR,'N') != 'Y' THEN
     
     SELECT DIST_SW 
       INTO V_DIST_SW
       FROM GICL_CLM_LOSS_EXP
      WHERE CLAIM_ID = P_CLAIM_ID
        AND CLM_LOSS_ID = P_CLM_LOSS_ID;  
    
    BEGIN
      SELECT MAX (clm_dist_no)
        INTO v_clm_dist_no
        FROM gicl_loss_exp_ds
       WHERE claim_id = P_CLAIM_ID
         AND clm_loss_id = P_CLM_LOSS_ID;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_clm_dist_no := 0;
    END;
   
   BEGIN     
        SAVEPOINT A;
       IF NVL (P_DIST_RG, 1) = 1 THEN -- record group 1(UW), 2(RES)  
            IF NVL (V_DIST_SW, 'N') = 'N'  THEN
     --       insert into cpi.test values('ENTER DISTRIBUTE_LOSS_EXP'); COMMIT;
            DISTRIBUTE_LOSS_EXP (P_CLAIM_ID, P_CLM_LOSS_ID, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO,
                                 P_LOSS_DATE, P_POL_EFF_DATE, P_EXPIRY_DATE, P_LINE_CD, P_SUBLINE_CD,
                                 P_POL_ISS_CD, P_ISSUE_YY, P_POL_SEQ_NO, P_RENEW_NO, P_DISTRIBUTION_DATE,
                                 P_PAYEE_CD, V_CLM_DIST_NO, P_MESSAGE );
       --     insert into cpi.test values('EXIT DISTRIBUTE_LOSS_EXP'); COMMIT;
            END IF;
       ELSIF NVL (P_DIST_RG, 1) = 2 THEN
           IF DIST_BY_RISK_LOC (P_CLAIM_ID, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO) 
                AND NVL (V_DIST_SW, 'N') = 'N' 
                AND GIISP.V ('ORA2010_SW') = 'Y' THEN
         --    insert into cpi.test values('ENTER DIST_BY_RESERVE_RISK_LOC');commit;
             DIST_BY_RESERVE_RISK_LOC (P_CLAIM_ID, P_CLM_LOSS_ID, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO,
                                       P_LINE_CD, P_DISTRIBUTION_DATE, NVL (V_CLM_DIST_NO, 0) + 1, P_PAYEE_CD,
                                       P_POL_EFF_DATE, P_EXPIRY_DATE, P_MESSAGE);
           --  insert into cpi.test values('EXIT DIST_BY_RESERVE_RISK_LOC');commit;
           ELSIF NVL (V_DIST_SW, 'N') = 'N' THEN
             --insert into cpi.test values('ENTER DISTRIBUTE_BY_RESERVE');commit;
             DISTRIBUTE_BY_RESERVE (P_CLAIM_ID, P_CLM_LOSS_ID, P_ITEM_NO, P_PERIL_CD, P_GROUPED_ITEM_NO,
                                    P_LOSS_DATE, P_POL_EFF_DATE, P_EXPIRY_DATE, P_LINE_CD, P_SUBLINE_CD,
                                    P_POL_ISS_CD, P_ISSUE_YY, P_POL_SEQ_NO, P_RENEW_NO, P_DISTRIBUTION_DATE,
                                    P_PAYEE_CD, V_CLM_DIST_NO, P_MESSAGE);
           --insert into cpi.test values('EXIT DISTRIBUTE_BY_RESERVE');commit;
           END IF;
       END IF;
           
       EXCEPTION 
            WHEN ZERO_DIVIDE THEN
               ROLLBACK TO A;
               P_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P_CLAIM_ID)|| ' ' || 'ITEM NO: '||P_ITEM_NO|| ' PERIL CD: '||P_PERIL_CD|| ' GROUPED ITEM NO: '||P_GROUPED_ITEM_NO
                                         || ' Status: ' ||'The TSI for this policy is Zero... ';
     END;
     --insert into cpi.test values('ENTER DISTRIBUTE_LOSS_EXP_XOL');commit;
     DISTRIBUTE_LOSS_EXP_XOL (P_CLAIM_ID, P_CLM_LOSS_ID, P_HIST_SEQ_NO, P_LINE_CD, P_ITEM_NO, P_PERIL_CD,
                              P_GROUPED_ITEM_NO, NVL(V_CLM_DIST_NO,0) + 1, P_LOSS_DATE, P_CATASTROPHIC_CD, P_PAYEE_CD);
     --insert into cpi.test values('EXIT DISTRIBUTE_LOSS_EXP_XOL');commit;
        COMMIT;
   END IF;
  END IF;     
END DIST_CLM_RECORDS;

--VALIDATE_EXISTING_DIST (CALL FROM DIST_CLM_RECORDS)
PROCEDURE VALIDATE_EXISTING_DIST (P_LINE_CD            IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                  P_SUBLINE_CD         IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                                  P_POL_ISS_CD         IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                                  P_ISSUE_YY           IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                                  P_POL_SEQ_NO         IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                                  P_RENEW_NO           IN  GICL_CLAIMS.RENEW_NO%TYPE,
                                  P_MESSAGE            OUT  VARCHAR2,
                                  P_ERROR              OUT  VARCHAR2)
IS
  v_dist_param  giis_parameters.param_value_v%TYPE;
  v_hdr_sw        VARCHAR2(1);
  v_dtl_sw        VARCHAR2(1);

BEGIN

  IF P_RENEW_NO IS NOT NULL THEN
     FOR rec IN
       (SELECT param_value_v
            FROM giis_parameters
            WHERE param_name = 'DISTRIBUTED')
     LOOP
       v_dist_param  := rec.param_value_v;
       EXIT; 
     END LOOP;
  END IF;

  FOR chk IN
    (SELECT b.dist_no dist_no, a.policy_id policy_id
       FROM gipi_polbasic a, giuw_pol_dist b
      WHERE a.line_cd     = P_LINE_CD 
        AND a.subline_cd  = P_SUBLINE_CD 
        AND a.iss_cd      = P_POL_ISS_CD 
        AND a.issue_yy    = P_ISSUE_YY 
        AND a.pol_seq_no  = P_POL_SEQ_NO 
        AND a.renew_no    = P_RENEW_NO
        AND a.endt_seq_no IN (SELECT NVL(MAX(ENDT_SEQ_NO),0) ENDT_SEQ_NO
                                FROM GIPI_POLBASIC
                               WHERE line_cd     = P_LINE_CD 
                                 AND subline_cd  = P_SUBLINE_CD 
                                 AND iss_cd      = P_POL_ISS_CD 
                                 AND issue_yy    = P_ISSUE_YY 
                                 AND pol_seq_no  = P_POL_SEQ_NO 
                                 AND renew_no    = P_RENEW_NO) 
        AND a.policy_id   = b.policy_id 
        AND b.dist_flag   = v_dist_param
        AND a.pol_flag    IN ('1','2','3','X')
        AND b.negate_date IS NULL
        AND NOT EXISTS    (SELECT c.policy_id
                             FROM gipi_endttext c
                            WHERE c.endt_tax = 'Y'
                              AND c.policy_id = a.policy_id))
  LOOP    
    v_hdr_sw := 'N';
    FOR a IN
      (SELECT gpolds.dist_no, gpolds.dist_seq_no
         FROM giuw_policyds gpolds
        WHERE gpolds.dist_no = chk.dist_no)
    LOOP
      v_hdr_sw := 'Y';
      v_dtl_sw := 'N';
      FOR b in
        (SELECT    '1'
              FROM    giuw_policyds_dtl gpoldtl
            WHERE    gpoldtl.dist_no     = a.dist_no
              AND    gpoldtl.dist_seq_no = a.dist_seq_no)
      LOOP
        v_dtl_sw := 'Y';
          EXIT;
      END LOOP;
      IF v_dtl_sw = 'N' THEN
           EXIT;
      END IF;
    END LOOP;
    IF v_hdr_sw = 'N' OR
       v_dtl_sw = 'N' THEN
       P_MESSAGE := 'There was an error encountered in Distribution Number' || TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
       P_ERROR := 'Y';                              
    ELSE
       FOR item IN
         (SELECT gitm.item_no
               FROM gipi_item gitm
             WHERE gitm.policy_id = chk.policy_id
               AND EXISTS (SELECT '1'
                                 FROM    gipi_itmperil gitmp
                                WHERE    gitmp.policy_id = gitm.policy_id
                                   AND    gitmp.item_no   = gitm.item_no))
       LOOP
         v_hdr_sw := 'N';
           FOR a IN
           (SELECT gids.dist_no, gids.dist_seq_no
                FROM giuw_itemds gids
               WHERE gids.dist_no = chk.dist_no
                 AND gids.item_no = item.item_no)
           LOOP
             v_hdr_sw := 'Y';
             v_dtl_sw := 'N';
             FOR b IN
             (SELECT '1'
                    FROM giuw_itemds_dtl gidtl
                 WHERE gidtl.dist_no     = a.dist_no
                     AND gidtl.dist_seq_no = a.dist_seq_no
                     AND gidtl.item_no     = item.item_no)
             LOOP
               v_dtl_sw := 'Y';
               EXIT;
             END LOOP;
             IF v_dtl_sw = 'N' THEN
                EXIT;
             END IF;
           END LOOP;
           IF v_hdr_sw = 'N' THEN
              EXIT;
           END IF;
       END LOOP;
       IF v_hdr_sw = 'N' OR
          v_dtl_sw = 'N' THEN
            P_MESSAGE := 'There was an error encountered in Distribution Number' || TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
            P_ERROR := 'Y';      
       ELSE
            FOR perl IN
            (SELECT gitmp.item_no, gitmp.peril_cd
                 FROM gipi_itmperil gitmp
                 WHERE gitmp.policy_id = chk.policy_id)
            LOOP
              v_hdr_sw := 'N';
              FOR a IN
              (SELECT gpids.dist_no, gpids.dist_seq_no, gpids.item_no,
                      gpids.peril_cd
                     FROM giuw_itemperilds gpids
                  WHERE gpids.dist_no  = chk.dist_no
                      AND gpids.item_no  = perl.item_no
                      AND gpids.peril_cd = perl.peril_cd)
              LOOP
                v_hdr_sw := 'Y';
                v_dtl_sw := 'N';
                FOR b IN
                (SELECT '1'
                       FROM    giuw_itemperilds_dtl gipdtl    
                      WHERE    gipdtl.dist_no     = a.dist_no
                        AND    gipdtl.dist_seq_no = a.dist_seq_no
                        AND    gipdtl.item_no     = a.item_no
                        AND    gipdtl.peril_cd    = a.peril_cd)
                LOOP
                  v_dtl_sw := 'Y';
                    EXIT;
                END LOOP;
                IF v_dtl_sw = 'N' THEN
                     EXIT;
                END IF;
              END LOOP;
              IF v_hdr_sw = 'N' THEN
                 EXIT;
              END IF;
            END LOOP;
            IF v_hdr_sw = 'N' OR
             v_dtl_sw = 'N' THEN
               P_MESSAGE := 'There was an error encountered in Distribution Number' || TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
               P_ERROR := 'Y';
            ELSE
               FOR perl IN
               (SELECT    DISTINCT gpids.peril_cd peril_cd, gpids.dist_seq_no
                  FROM    giuw_itemperilds gpids
                     WHERE     gpids.dist_no = chk.dist_no) 
             LOOP
                 v_hdr_sw := 'N';
                 FOR a IN
                 (SELECT gpds.dist_no, gpds.dist_seq_no, gpds.peril_cd
                        FROM giuw_perilds gpds
                       WHERE gpds.dist_no     = chk.dist_no
                         AND gpds.dist_seq_no = perl.dist_seq_no
                         AND gpds.peril_cd    = perl.peril_cd)
                 LOOP
                   v_hdr_sw := 'Y';
                     v_dtl_sw := 'N';
                     FOR b IN
                   (SELECT '1'
                          FROM giuw_perilds_dtl gpd
                         WHERE gpd.dist_no     = a.dist_no
                           AND gpd.dist_seq_no = a.dist_seq_no
                           AND gpd.peril_cd    = a.peril_cd)
                     LOOP
                       v_dtl_sw := 'Y';
                       EXIT;
                   END LOOP;
                   IF v_dtl_sw = 'N' THEN
                        EXIT;
                     END IF;
                 END LOOP;
                 IF v_hdr_sw = 'N' THEN
                      EXIT;
                 END IF;
               END LOOP;
               IF v_hdr_sw = 'N' OR
                v_dtl_sw = 'N' THEN
                     P_MESSAGE := 'There was an error encountered in Distribution Number' || TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
                    P_ERROR := 'Y';
               END IF;
            END IF;
       END IF;
    END IF;
  END LOOP;
END;

--DISTRIBUTE_LOSS_EXP (CALL FROM DIST_CLM_RECORDS)
PROCEDURE DISTRIBUTE_LOSS_EXP (P1_CLAIM_ID          IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                                   P1_CLM_LOSS_ID       IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                   P1_ITEM_NO           IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                                   P1_PERIL_CD          IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                                   P1_GROUPED_ITEM_NO   IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                                   P1_LOSS_DATE         IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                                   P1_POL_EFF_DATE      IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                                   P1_EXPIRY_DATE       IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE, 
                                   P1_LINE_CD           IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                   P1_SUBLINE_CD        IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                                   P1_POL_ISS_CD        IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                                   P1_ISSUE_YY          IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                                   P1_POL_SEQ_NO        IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                                   P1_RENEW_NO          IN  GICL_CLAIMS.RENEW_NO%TYPE,
                                   P1_DISTRIBUTION_DATE IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                                   P1_PAYEE_CD          IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                                   V1_CLM_DIST_NO       IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                                   P1_MESSAGE           OUT VARCHAR2)
IS
  --Cursor for item/peril loss amount
  CURSOR cur_clm_res IS
    SELECT claim_id, hist_seq_no, item_no,grouped_item_no, peril_cd, 
           paid_amt, net_amt, advise_amt 
      FROM gicl_clm_loss_exp
     WHERE claim_id    = P1_CLAIM_ID
       AND clm_loss_id = P1_CLM_LOSS_ID;
  
  --Cursor for peril distribution in underwriting table.
  CURSOR cur_perilds(v_peril_cd giri_ri_dist_item_v.peril_cd%TYPE,
                     v_item_no  giri_ri_dist_item_v.item_no%TYPE) IS
    SELECT d.share_cd,    f.share_type,     f.trty_yy,
           f.prtfolio_sw, f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi, 
           f.eff_date, f.expiry_date
      FROM gipi_polbasic a,        gipi_item b,       giuw_pol_dist c,
           giuw_itemperilds_dtl d, giis_dist_share f, giis_parameters e
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
           DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), P1_POL_EFF_DATE, a.eff_date ), c.eff_date)) 
           <= trunc(P1_LOSS_DATE)
       AND TRUNC(DECODE(TRUNC(c.expiry_date), TRUNC(a.expiry_date), DECODE(NVL(a.endt_expiry_date, a.expiry_date),
           a.expiry_date, P1_EXPIRY_DATE, a.endt_expiry_date), c.expiry_date))  
           >= trunc(P1_LOSS_DATE)
       AND b.policy_id  = a.policy_id
       AND a.line_cd    = P1_LINE_CD
       AND a.subline_cd = P1_SUBLINE_CD
       AND a.iss_cd     = P1_POL_ISS_CD
       AND a.issue_yy   = P1_ISSUE_YY
       AND a.pol_seq_no = P1_POL_SEQ_NO
       AND a.renew_no   = P1_RENEW_NO
       AND a.pol_flag   IN ('1','2','3','X')
  GROUP BY d.share_cd,       f.share_type,  f.trty_yy,
           f.acct_trty_type, f.prtfolio_sw, f.eff_date, f.expiry_date;
  
  --Cursor for peril distribution in treaty table.
   CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%type,
                   v_trty_yy  giis_dist_share.trty_yy%type) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM giis_trty_panel
    WHERE line_cd     = P1_LINE_CD
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;

  --Cursor for peril distribution in ri table.
  
   CURSOR cur_frperil(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
                          v_item_no  giri_ri_dist_item_v.item_no%type)is
   SELECT t2.ri_cd,
          SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt 
     FROM gipi_polbasic    t5, gipi_itmperil    t8, giuw_pol_dist    t4,
          giuw_itemperilds t6, giri_distfrps    t3, giri_frps_ri     t2       
    WHERE 1=1
      AND t5.line_cd              = P1_LINE_CD
      AND t5.subline_cd           = P1_SUBLINE_CD
      AND t5.iss_cd               = P1_POL_ISS_CD
      AND t5.issue_yy             = P1_ISSUE_YY
      AND t5.pol_seq_no           = P1_POL_SEQ_NO
      AND t5.renew_no             = P1_RENEW_NO
      AND t5.pol_flag             IN ('1','2','3','X')   
      AND t5.policy_id            = t8.policy_id
      AND t8.peril_cd             = v_peril_cd
      AND t8.item_no              = v_item_no
      AND t5.policy_id            = t4.policy_id   
      AND TRUNC(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
          DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), P1_POL_EFF_DATE, t5.eff_date ), t4.eff_date)) 
          <= trunc(P1_LOSS_DATE)
      AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t5.expiry_date),
          DECODE(NVL(t5.endt_expiry_date, t5.expiry_date),
          t5.expiry_date, P1_EXPIRY_DATE, t5.endt_expiry_date), t4.expiry_date))
          >= trunc(P1_LOSS_DATE)
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

  sum_tsi_amt         giri_basic_info_item_sum_v.tsi_amt%TYPE;
  ann_ri_pct          NUMBER(12,9);
  ann_dist_spct       gicl_loss_exp_ds.shr_loss_exp_pct%TYPE := 0;
  me                  NUMBER := 0;
  v_facul_share_cd       giuw_perilds_dtl.share_cd%TYPE;
  v_trty_share_type   giis_dist_share.share_type%TYPE;
  v_facul_share_type  giis_dist_share.share_type%TYPE;
  v_paid_amt          gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_advise_amt        gicl_loss_exp_ds.shr_le_adv_amt%TYPE;
  v_net_amt           gicl_loss_exp_ds.shr_le_net_amt%TYPE;
  v_trty_limit            giis_dist_share.trty_limit%TYPE;  
  v_facul_amt              gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_orig_net_amt        gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_treaty_amt            gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_qs_shr_pct            giis_dist_share.qs_shr_pct%TYPE;
  v_acct_trty_type      giis_dist_share.acct_trty_type%TYPE;
  v_share_cd          giis_dist_share.share_cd%TYPE;
  v_policy                VARCHAR2(2000);
  counter                  NUMBER := 0;
  v_switch                NUMBER := 0;
  v_policy_id              NUMBER;
  v_clm_dist_no       NUMBER := 0;
  V1_CLM_DIST_NO2       NUMBER := 0;
  v_peril_sname            giis_peril.peril_sname%TYPE;
  v_trty_peril        giis_peril.peril_sname%TYPE;
  v_dist_flag         giis_parameters.param_value_v%TYPE;
--switch to determine if share_cd is already existing 
  v_share_exist       VARCHAR2(1);

BEGIN

  FOR rec IN
    (SELECT param_value_v
       FROM giis_parameters
      WHERE param_name = 'DISTRIBUTED')
  LOOP
    v_dist_flag := rec.param_value_v;
  END LOOP;

  V1_CLM_DIST_NO2 := nvl(V1_CLM_DIST_NO,0) + 1;
  V_CLM_DIST_NO := V1_CLM_DIST_NO2;
  
  P1_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P1_CLAIM_ID)|| ' ' || 'ITEM NO: '||P1_ITEM_NO|| ' PERIL CD: '||P1_PERIL_CD|| ' GROUPED ITEM NO: '||P1_GROUPED_ITEM_NO;

  FOR c1 in cur_clm_res LOOP        /*Using Item-peril cursor */
    BEGIN
      SELECT param_value_n
        INTO v_facul_share_cd
        FROM giis_parameters
       WHERE param_name = 'FACULTATIVE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         P1_MESSAGE :=  P1_MESSAGE || ' Status: ' ||
                     'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.'; 
    END;

    BEGIN
      SELECT param_value_v
        INTO v_trty_share_type
        FROM giac_parameters
      WHERE param_name = 'TRTY_SHARE_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P1_MESSAGE :=  P1_MESSAGE || ' Status: ' ||
                     'There is no existing TRTY_SHARE_TYPE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT param_value_v
        INTO v_facul_share_type
        FROM giac_parameters
       WHERE param_name = 'FACUL_SHARE_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P1_MESSAGE :=  P1_MESSAGE || ' Status: ' ||
                     'There is no existing FACUL_SHARE_TYPE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT param_value_n
        INTO v_acct_trty_type
        FROM giac_parameters
       WHERE param_name = 'QS_ACCT_TRTY_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         P1_MESSAGE :=  P1_MESSAGE || ' Status: ' ||
                     'There is no existing QS_ACCT_TRTY_TYPE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT SUM(T1.TSI_AMT) TSI_AMT 
        INTO sum_tsi_amt
        FROM gipi_polbasic T2, gipi_item T3, gipi_itmperil T1,
             giuw_pol_dist T4
       WHERE T2.policy_id = T3.policy_id
         AND T3.policy_id = T1.policy_id 
         AND T3.item_no   = T1.item_no
         AND T2.policy_id = T4.policy_id
         AND TRUNC(DECODE(TRUNC(t4.eff_date), TRUNC(t2.eff_date),
             DECODE(TRUNC(t2.eff_date), TRUNC(t2.incept_date), P1_POL_EFF_DATE, t2.eff_date ), t4.eff_date)) 
             <= trunc(P1_LOSS_DATE)
         AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t2.expiry_date),
             DECODE(NVL(t2.endt_expiry_date, t2.expiry_date),
             t2.expiry_date, P1_EXPIRY_DATE, t2.endt_expiry_date), t4.expiry_date))
             >= trunc(P1_LOSS_DATE)
         AND T1.item_no    = c1.item_no
         AND T1.peril_cd   = c1.peril_cd
         AND T2.line_cd    = P1_LINE_CD
         AND T2.subline_cd = P1_SUBLINE_CD
         AND T2.iss_cd     = P1_POL_ISS_CD
         AND T2.issue_yy   = P1_ISSUE_YY
         AND T2.pol_seq_no = P1_POL_SEQ_NO
         AND T2.renew_no   = P1_RENEW_NO
         AND t2.pol_flag   IN ('1','2','3','X')
         AND T4.dist_flag  = v_dist_flag; 
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P1_MESSAGE := P1_MESSAGE || ' Status: ' ||'The TSI for this policy is Zero...';
    END; 

    FOR me IN cur_perilds(c1.peril_cd, c1.item_no) LOOP
      IF me.acct_trty_type = v_acct_trty_type THEN
         v_switch  := 1;
      ELSIF ((me.acct_trty_type = v_acct_trty_type) OR
        (me.acct_trty_type IS NULL)) and (v_switch <> 1) THEN
         v_switch := 0;
      END IF;
    END LOOP;

    SELECT peril_sname
      INTO v_peril_sname
      FROM giis_peril
     WHERE peril_cd = c1.peril_cd
       AND line_cd  = P1_LINE_CD;
 
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
        
    IF sum_tsi_amt!=0 AND sum_tsi_amt IS NOT NULL THEN 
            
    IF sum_tsi_amt > v_trty_limit THEN

       FOR I IN CUR_PERILDS(C1.PERIL_CD, C1.ITEM_NO) LOOP
         IF I.SHARE_TYPE = V_FACUL_SHARE_TYPE THEN
            v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi/sum_tsi_amt);
         END IF;
       END LOOP;
       v_orig_net_amt := (sum_tsi_amt - nvl(v_facul_amt,0))* ((100 - v_qs_shr_pct)/100);  
       v_treaty_amt   := (sum_tsi_amt - nvl(v_facul_amt,0))* (v_qs_shr_pct/100);
    ELSE
       v_orig_net_amt := sum_tsi_amt * ((100 - v_qs_shr_pct)/100);
       v_treaty_amt   := sum_tsi_amt * (v_qs_shr_pct/100);     
    END IF;

/*Start of distribution */
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
           IF NVL(c2.prtfolio_sw, 'N') = 'P' AND
              TRUNC(c2.expiry_date) < NVL(P1_DISTRIBUTION_DATE, SYSDATE) THEN
              WHILE TRUNC(c2.expiry_date) < NVL(P1_DISTRIBUTION_DATE, SYSDATE) LOOP
                BEGIN
                  SELECT share_cd,       trty_yy,    NVL(prtfolio_sw, 'N'),
                         acct_trty_type, share_type, expiry_date
                    INTO v_share_cd,  v_treaty_yy2, v_prtf_sw,
                         v_acct_trty, v_share_type, v_expiry_date
                       FROM giis_dist_share
                     WHERE line_cd            = P1_LINE_CD
             
                     AND old_trty_seq_no  =  c2.share_cd;                    
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                      P1_MESSAGE := P1_MESSAGE  || ' Status: ' ||'No new treaty set-up for year '|| TO_CHAR(NVL(P1_DISTRIBUTION_DATE, SYSDATE), 'RRRR');
                    EXIT;
                    WHEN TOO_MANY_ROWS THEN
                      P1_MESSAGE := P1_MESSAGE  || ' Status: ' ||'Too many treaty set-up for year '|| TO_CHAR(NVL(P1_DISTRIBUTION_DATE, SYSDATE), 'RRRR'); 
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
         v_paid_amt     := c1.paid_amt * ann_dist_spct/100; 
         v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
         v_net_amt      := c1.net_amt * ann_dist_spct/100;
      ELSE
         IF (c2.share_type = v_trty_share_type) AND
            (c2.share_cd = v_share_cd) THEN
            ann_dist_spct := (v_treaty_amt/sum_tsi_amt) * 100;
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100;
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
            v_net_amt      := c1.net_amt * ann_dist_spct/100;
         ELSIF (c2.share_type != v_trty_share_type) AND
               (c2.share_type != v_facul_share_type) AND
               (v_net_amt IS NOT NULL) THEN
            ann_dist_spct := (v_net_amt/sum_tsi_amt) * 100;
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100;
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
            v_net_amt      := c1.net_amt * ann_dist_spct/100;
         ELSE
            ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100; 
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100;
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
            v_net_amt      := c1.net_amt * ann_dist_spct/100;
         END IF;
      END IF;
/*checks if share_cd is already existing if existing updates gicl_reserve_ds
if not existing then inserts record to gicl_reserve_ds*/ 
      v_share_exist := 'N';
      FOR i IN 
        (SELECT '1'
           FROM gicl_loss_exp_ds
          WHERE claim_id    = P1_CLAIM_ID
            AND item_no     = c1.item_no
            AND grouped_item_no  = c1.grouped_item_no
            AND peril_cd    = c1.peril_cd
            AND grp_seq_no  = c2.share_cd
            AND line_cd     = P1_LINE_CD
            AND clm_dist_no = v_clm_dist_no             
            AND clm_loss_id = P1_CLM_LOSS_ID)        
      LOOP
        v_share_exist :='Y';
      END LOOP;

      IF ann_dist_spct <> 0 THEN
         IF v_share_exist = 'N' THEN
            INSERT INTO gicl_loss_exp_ds(claim_id,                  dist_year,     clm_loss_id,
                                         clm_dist_no,          item_no,         peril_cd,
                                         payee_cd,              grp_seq_no,       share_type,
                                         shr_loss_exp_pct, shr_le_pd_amt, shr_le_adv_amt,
                                         shr_le_net_amt,     line_cd,            acct_trty_type,
                                         grouped_item_no,
                                         distribution_date)
                                 VALUES (P1_CLAIM_ID,     TO_CHAR(NVL(P1_DISTRIBUTION_DATE, SYSDATE), 'RRRR'), P1_CLM_LOSS_ID,
                                         v_clm_dist_no,     c1.item_no,       c1.peril_cd,
                                                 P1_PAYEE_CD, c2.share_cd,   c2.share_type,
                                                 ann_dist_spct,  v_paid_amt,    v_advise_amt,
                                                 v_net_amt,             P1_LINE_CD, c2.acct_trty_type,
                                                 c1.grouped_item_no,
                                                 NVL(P1_DISTRIBUTION_DATE, SYSDATE));
         ELSE
            UPDATE gicl_loss_exp_ds
               SET shr_le_pd_amt     = NVL(shr_le_pd_amt,0) + NVL(v_paid_amt,0),
                   shr_le_adv_amt    = NVL(shr_le_adv_amt,0) + NVL(v_advise_amt,0),
                   shr_le_net_amt    = NVL(shr_le_net_amt,0) + NVL(v_net_amt,0),
                   shr_loss_exp_pct  = NVL(shr_loss_exp_pct,0) + NVL(ann_dist_spct,0),
                   dist_year         = TO_CHAR(NVL(P1_DISTRIBUTION_DATE, SYSDATE), 'RRRR'),
                   distribution_date = NVL(P1_DISTRIBUTION_DATE, SYSDATE)
             WHERE claim_id    = P1_CLAIM_ID
               AND item_no     = c1.item_no
               and grouped_item_no = c1.grouped_item_no
               AND peril_cd    = c1.peril_cd
               AND grp_seq_no  = c2.share_cd
                 AND line_cd     = P1_LINE_CD
               AND clm_dist_no = v_clm_dist_no                      
               AND clm_loss_id = P1_CLM_LOSS_ID;
         END IF;           
         me := TO_NUMBER(c2.share_type) - TO_NUMBER(v_trty_share_type);
         IF me = 0 THEN
            FOR c_trty IN cur_trty(c2.share_cd, c2.trty_yy) LOOP
              IF v_share_exist = 'N' THEN
                 INSERT INTO gicl_loss_exp_rids(claim_id,                  dist_year,               clm_loss_id,
                                                clm_dist_no,       item_no,                     peril_cd, 
                                                       payee_cd,            grp_seq_no,          share_type,
                                                      ri_cd,             shr_loss_exp_ri_pct, shr_le_ri_pd_amt,
                                                      shr_le_ri_adv_amt, shr_le_ri_net_amt,   line_cd,         
                                                      grouped_item_no,
                                                        acct_trty_type,         prnt_ri_cd)
                                              VALUES  (P1_CLAIM_ID, TO_CHAR(NVL(P1_DISTRIBUTION_DATE, SYSDATE), 'RRRR'), P1_CLM_LOSS_ID,
                                                           v_clm_dist_no,    c1.item_no,                   c1.peril_cd,
                                                          P1_PAYEE_CD, c2.share_cd,             v_trty_share_type,
                                                          c_trty.ri_cd,   
                                                          (ann_dist_spct  * (c_trty.trty_shr_pct/100)),
                                                          (v_paid_amt * (c_trty.trty_shr_pct/100)),(v_advise_amt  * (c_trty.trty_shr_pct/100)), 
                                                          (v_net_amt  * (c_trty.trty_shr_pct/100)),
                                                          P1_LINE_CD,     
                                                          c1.grouped_item_no,
                                                          c2.acct_trty_type,       c_trty.prnt_ri_cd);
              ELSE
                 UPDATE gicl_loss_exp_rids
                    SET shr_loss_exp_ri_pct = NVL(shr_loss_exp_ri_pct,0) + (NVL(ann_dist_spct,0)  * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_pd_amt    = NVL(shr_le_ri_pd_amt,0) + (NVL(v_paid_amt,0) * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_adv_amt   = NVL(shr_le_ri_adv_amt,0) + (NVL(v_advise_amt,0)  * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_net_amt   = NVL(shr_le_ri_net_amt,0) + (NVL(v_net_amt,0)  * (c_trty.trty_shr_pct/100)),
                        dist_year           = TO_CHAR(NVL(P1_DISTRIBUTION_DATE, SYSDATE), 'RRRR')
                  WHERE claim_id    = P1_CLAIM_ID
                    AND item_no     = c1.item_no
                    AND grouped_item_no = c1.grouped_item_no
                    AND peril_cd    = c1.peril_cd
                    AND grp_seq_no  = c2.share_cd
                      AND line_cd     = P1_LINE_CD
                    AND ri_cd       = c_trty.ri_cd 
                      AND clm_dist_no = v_clm_dist_no             
                    AND clm_loss_id = P1_CLM_LOSS_ID;
              END IF;            
            END LOOP; /*end of c_trty loop*/
         ELSIF c2.share_type = v_facul_share_type THEN
    
            FOR c3 IN cur_frperil(c1.peril_cd, c1.item_no) LOOP /*RI peril distribution*/
              IF (c2.acct_trty_type <> v_acct_trty_type) OR
                   (c2.acct_trty_type IS NULL) THEN
                 ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
              ELSE
                 ann_ri_pct := (v_facul_amt /sum_tsi_Amt) * 100;
              END IF; 
              INSERT INTO gicl_loss_exp_rids(claim_id,      dist_year,               clm_loss_id, 
                                             clm_dist_no, item_no,                 peril_cd,
                                             payee_cd,    grp_seq_no,               share_type,
                                             ri_cd,       shr_loss_exp_ri_pct, shr_le_ri_pd_amt,
                                             shr_le_ri_adv_amt,
                                             shr_le_ri_net_amt,
                                             grouped_item_no,
                                             line_cd,                   acct_trty_type, prnt_ri_cd)
                                          VALUES(P1_CLAIM_ID,         to_char(sysdate, 'YYYY'),  P1_CLM_LOSS_ID,
                                             v_clm_dist_no,          c1.item_no,                    c1.peril_cd,
                                                      P1_PAYEE_CD,     c2.share_cd,                    v_facul_share_type,
                                                      c3.ri_cd,               ann_ri_pct,                (c1.paid_amt * ann_ri_pct/100),
                                                  (c1.advise_amt * ann_ri_pct/100),
                                                  (c1.net_amt * ann_ri_pct/100),
                                                  c1.grouped_item_no,
                                                  P1_LINE_CD,       c2.acct_trty_type,         c3.ri_cd);
            END LOOP; /*End of c3 loop */
         END IF;
      ELSE 
         NULL;
      END IF;
    END LOOP; /*End of c2 loop*/
    P1_MESSAGE := P1_MESSAGE || ' Status: ' ||'Distribution Complete. ';
    
    ELSIF sum_tsi_amt = 0 THEN
    P1_MESSAGE := P1_MESSAGE || ' Status: ' ||'TSI for this peril is zero... Cannot distribute loss/exp history';
    END IF; -- end of IF sum_tsi_amt!=0 THEN
  END LOOP; /*End of c1 loop */

  UPDATE gicl_clm_loss_exp
     SET dist_sw     = 'Y'
   WHERE claim_id    = P1_CLAIM_ID
     AND clm_loss_id = P1_CLM_LOSS_ID;
  
  OFFSET_AMT(V_CLM_DIST_NO, P1_CLAIM_ID, P1_CLM_LOSS_ID);
  
END DISTRIBUTE_LOSS_EXP;
--OFFSET_AMT (CALL FROM DISTRIBUTE_LOSS_EXP)
PROCEDURE OFFSET_AMT (P_CLM_DIST_NO IN  GICL_LOSS_EXP_DS.CLM_DIST_NO%TYPE,
                      P_CLAIM_ID    IN  GICL_LOSS_EXP_DS.CLAIM_ID%TYPE,
                      P_CLM_LOSS_ID IN  GICL_LOSS_EXP_DS.CLM_LOSS_ID%TYPE)
IS
  offset_pd   gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  offset_adv  gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  offset_net  gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  offset_pd1   gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  offset_adv1  gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  offset_net1  gicl_loss_exp_ds.shr_le_pd_amt%TYPE;

BEGIN
-- OFFSET FROM BASE AMOUNT
  FOR OFFSET IN (
     SELECT  paid_amt, net_amt, advise_amt
       FROM gicl_clm_loss_exp
      WHERE claim_id        = P_CLAIM_ID
        AND clm_loss_id     = P_CLM_LOSS_ID)
  LOOP      
    FOR offset2 IN (
      SELECT SUM(shr_le_pd_amt)sum_pd, SUM(shr_le_adv_amt) sum_adv,
             SUM(shr_le_net_amt)sum_net
        FROM gicl_loss_exp_ds
       WHERE claim_id = P_CLAIM_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND clm_loss_id = P_CLM_LOSS_ID)
    LOOP
      offset_pd1:= nvl(offset.paid_amt,0) - nvl(offset2.sum_pd,0);
      offset_adv1:= nvl(offset.advise_amt,0) - nvl(offset2.sum_adv,0);
      offset_net1:= nvl(offset.net_amt,0) - nvl(offset2.sum_net,0);
    END LOOP;
  END LOOP;
  IF NVL(offset_pd1,0) <> 0 OR NVL(offset_adv1,0) <> 0 OR NVL(offset_net1,0) <> 0 THEN
       FOR get_cd IN (
         SELECT grp_seq_no
           FROM gicl_loss_exp_ds
          WHERE claim_id = P_CLAIM_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND clm_loss_id = P_CLM_LOSS_ID 
       ORDER BY grp_seq_no)
     LOOP
         UPDATE gicl_loss_exp_ds
            SET shr_le_pd_amt = shr_le_pd_amt + offset_pd1,
                shr_le_adv_amt = shr_le_adv_amt + offset_adv1,
                shr_le_net_amt = shr_le_net_amt + offset_net1
          WHERE claim_id = P_CLAIM_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND grp_seq_no = get_cd.grp_seq_no
         AND clm_loss_id = P_CLM_LOSS_ID;   
      EXIT;
     END LOOP;
  END IF;   
  
  -- extract amounts from gicl_loss_exp_rids
  FOR A IN
    (SELECT grp_seq_no, peril_cd, item_no,
            grouped_item_no,
            SUM(shr_le_ri_pd_amt) pd_amt,
            SUM(shr_le_ri_adv_amt) adv_amt,
            SUM(shr_le_ri_net_amt) net_amt
       FROM gicl_loss_exp_rids
      WHERE claim_id    = P_CLAIM_ID
        AND clm_dist_no = P_CLM_DIST_NO
        AND clm_loss_id = P_CLM_LOSS_ID   
      GROUP BY grp_seq_no, item_no, peril_cd, grouped_item_no)
  LOOP
    offset_pd  := 0;
    offset_adv := 0;
    offset_net := 0;
    -- extract amounts from gicl_loss_exp_ds to link with the values in A.
    FOR B IN
      (SELECT shr_le_pd_amt, shr_le_adv_amt, shr_le_net_amt
         FROM gicl_loss_exp_ds
        WHERE claim_id    = P_CLAIM_ID
          AND clm_dist_no = P_CLM_DIST_NO
          AND clm_loss_id = P_CLM_LOSS_ID   
          AND grp_seq_no  = a.grp_seq_no
          AND item_no     = a.item_no 
          AND grouped_item_no = a.grouped_item_no 
          AND peril_cd    = a.peril_cd)
    LOOP
    /* subtract sum of amounts in A from B, if <> 0 IF statement executes.
       otherwise, null. */
      offset_pd  := nvl(b.shr_le_pd_amt,0) - nvl(a.pd_amt,0);
      offset_adv := nvl(b.shr_le_adv_amt,0) - nvl(a.adv_amt,0);
      offset_net := nvl(b.shr_le_net_amt,0) - nvl(a.net_amt,0);
    END LOOP;

    -- if <> 0 update gicl_loss_exp_rids using ri_cd.
    IF offset_pd <> 0 OR
         offset_adv <> 0 OR
         offset_net <> 0 THEN
       FOR C IN
         (SELECT ri_cd
            FROM gicl_loss_exp_rids
           WHERE claim_id    = P_CLAIM_ID
             AND clm_dist_no = P_CLM_DIST_NO
             AND clm_loss_id = P_CLM_LOSS_ID   
             AND grp_seq_no  = a.grp_seq_no
             AND item_no     = a.item_no  
             and grouped_item_no = a.grouped_item_no
             AND peril_cd    = a.peril_cd) 
       LOOP
         UPDATE gicl_loss_exp_rids
            SET shr_le_ri_pd_amt  = nvl(shr_le_ri_pd_amt,0) + nvl(offset_pd,0),
                shr_le_ri_adv_amt = nvl(shr_le_ri_adv_amt,0) + nvl(offset_adv,0),
                shr_le_ri_net_amt = nvl(shr_le_ri_net_amt,0) + nvl(offset_net,0)
          WHERE claim_id    = P_CLAIM_ID
            AND clm_dist_no = P_CLM_DIST_NO
            AND clm_loss_id = P_CLM_LOSS_ID   
            AND grp_seq_no  = a.grp_seq_no
            AND ri_cd       = c.ri_cd  
            AND item_no     = a.item_no  
            AND grouped_item_no = a.grouped_item_no
            AND peril_cd    = a.peril_cd;
         EXIT;
       END LOOP;
    END IF;
    END LOOP;

END OFFSET_AMT;
--DIST_BY_RESERVE_RISK_LOC (CALL FROM DIST_CLM_RECORDS)
PROCEDURE DIST_BY_RESERVE_RISK_LOC (P2_CLAIM_ID          IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                                        P2_CLM_LOSS_ID       IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                        P2_ITEM_NO           IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                                        P2_PERIL_CD          IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                                        P2_GROUPED_ITEM_NO   IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                                        P2_LINE_CD           IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                        P2_DISTRIBUTION_DATE IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                                        V2_CLM_DIST_NO       IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                                        P2_PAYEE_CD          IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                                        P2_POL_EFF_DATE      IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                                        P2_EXPIRY_DATE       IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE,
                                        P2_MESSAGE           OUT VARCHAR2)
IS
   --Cursor for item/peril loss amount
   CURSOR cur_clm_res
   IS
      SELECT claim_id, hist_seq_no, item_no, peril_cd, paid_amt, net_amt,
             advise_amt, grouped_item_no
        FROM gicl_clm_loss_exp
       WHERE claim_id = P2_CLAIM_ID 
         AND clm_loss_id = P2_CLM_LOSS_ID;

   CURSOR cur_res_ds
   IS
      SELECT a.grp_seq_no, a.share_type, a.shr_pct, a.acct_trty_type
        FROM gicl_reserve_ds a
       WHERE a.peril_cd = P2_PERIL_CD
         AND a.item_no = P2_ITEM_NO
         AND a.grouped_item_no = NVL(P2_GROUPED_ITEM_NO,0)
         AND a.claim_id = P2_CLAIM_ID
         AND a.share_type NOT IN (giacp.v ('XOL_TRTY_SHARE_TYPE'))
         AND NVL (a.negate_tag, 'N') <> 'Y'
         AND a.hist_seq_no =
                (SELECT MAX (b.hist_seq_no)
                   FROM gicl_reserve_ds b
                  WHERE b.dist_year = a.dist_year
                    AND b.peril_cd = a.peril_cd
                    AND b.item_no = a.item_no
                    AND b.grouped_item_no = NVL(a.grouped_item_no,0)
                    AND b.claim_id = a.claim_id
                    AND NVL (b.negate_tag, 'N') <> 'Y');

   --Cursor for peril distribution in treaty table.
   CURSOR cur_trty (v_share_cd giis_dist_share.share_cd%TYPE)
   IS
      SELECT ri_cd, trty_shr_pct, prnt_ri_cd
        FROM giis_trty_panel tp, giis_dist_share ds
       WHERE tp.line_cd = ds.line_cd
         AND tp.trty_seq_no = ds.share_cd
         AND tp.line_cd = P2_LINE_CD
         AND tp.trty_yy = ds.trty_yy
         AND tp.trty_seq_no = v_share_cd;

   --Cursor for peril distribution in ri table.
   CURSOR cur_frperil (
      v_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
      v_item_no    giri_ri_dist_item_v.item_no%TYPE
   )
   IS
      SELECT t2.ri_cd, t2.ri_shr_pct
        FROM gipi_polbasic t5,
             gipi_itmperil t8,
             giuw_pol_dist t4,
             giuw_itemperilds t6,
             giri_distfrps t3,
             giri_frps_ri t2,
             gicl_claims t1
       WHERE t1.claim_id = P2_CLAIM_ID
         AND t5.line_cd = t1.line_cd
         AND t5.subline_cd = t1.subline_cd
         AND t5.iss_cd = t1.pol_iss_cd
         AND t5.issue_yy = t1.issue_yy
         AND t5.pol_seq_no = t1.pol_seq_no
         AND t5.renew_no = t1.renew_no
         AND t5.pol_flag IN ('1', '2', '3', 'X')
         AND t5.policy_id = t8.policy_id
         AND t8.peril_cd = v_peril_cd
         AND t8.item_no = v_item_no
         AND t5.policy_id = t4.policy_id
         AND TRUNC (DECODE (TRUNC (t4.eff_date),
                            TRUNC (t5.eff_date), DECODE
                                                       (TRUNC (t5.eff_date),
                                                        TRUNC (t5.incept_date), P2_POL_EFF_DATE,
                                                        t5.eff_date
                                                       ),
                            t4.eff_date
                           )
                   ) <= t1.loss_date
         AND TRUNC (DECODE (TRUNC (t4.expiry_date),
                            TRUNC (t5.expiry_date), DECODE
                                                   (NVL (t5.endt_expiry_date,
                                                         t5.expiry_date
                                                        ),
                                                    t5.expiry_date, P2_EXPIRY_DATE,
                                                    t5.endt_expiry_date
                                                   ),
                            t4.expiry_date
                           )
                   ) >= t1.loss_date
         AND t4.dist_flag = '3'
         AND t4.dist_no = t6.dist_no
         AND t8.item_no = t6.item_no
         AND t8.peril_cd = t6.peril_cd
         AND t4.dist_no = t3.dist_no
         AND t6.dist_seq_no = t3.dist_seq_no
         AND t3.line_cd = t2.line_cd
         AND t3.frps_yy = t2.frps_yy
         AND t3.frps_seq_no = t2.frps_seq_no
         AND NVL (t2.reverse_sw, 'N') = 'N'
         AND NVL (t2.delete_sw, 'N') = 'N'
         AND t3.ri_flag = '2';

   v_paid_amt      gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
   v_advise_amt    gicl_loss_exp_ds.shr_le_adv_amt%TYPE;
   v_net_amt       gicl_loss_exp_ds.shr_le_net_amt%TYPE;
   v_share_exist   VARCHAR2 (1);
--PORTFOLIO_SW FOR DIST_BY_RESERVE_RISK_LOC
   FUNCTION PORTFOLIO_SW (
      v_line_cd      giis_dist_share.line_cd%TYPE,
      v_share_cd     giis_dist_share.share_cd%TYPE,
      v1_dist_date   DATE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      FOR p_sw IN (SELECT '1'
                     FROM giis_dist_share
                    WHERE line_cd = v_line_cd
                      AND share_cd = v_share_cd
                      AND expiry_date < TRUNC (NVL (v1_dist_date, SYSDATE)))
      LOOP
         RETURN (TRUE);
      END LOOP;

      RETURN (FALSE);
   END PORTFOLIO_SW;
BEGIN
   FOR c1 IN cur_clm_res
   LOOP
      FOR c2 IN cur_res_ds
      LOOP
         IF     PORTFOLIO_SW (P2_LINE_CD, c2.grp_seq_no, P2_DISTRIBUTION_DATE)
            AND c2.share_type = giacp.v ('TRTY_SHARE_TYPE')
         THEN
            BEGIN
               SELECT share_cd, acct_trty_type, share_type
                 INTO c2.grp_seq_no, c2.acct_trty_type, c2.share_type
                 FROM giis_dist_share
                WHERE line_cd = P2_LINE_CD 
                  AND old_trty_seq_no = c2.grp_seq_no;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  P2_MESSAGE := P2_MESSAGE || ' Status: ' ||'No new treaty set-up for year '|| TO_CHAR (NVL (P2_DISTRIBUTION_DATE,SYSDATE),'RRRR');
                  EXIT;
               WHEN TOO_MANY_ROWS THEN
                  P2_MESSAGE := P2_MESSAGE || ' Status: ' ||'Too many treaty set-up for year '|| TO_CHAR (NVL (P2_DISTRIBUTION_DATE,SYSDATE),'RRRR');
            END;
         END IF;

         v_share_exist := 'N';

         FOR i IN (SELECT '1'
                     FROM gicl_loss_exp_ds
                    WHERE claim_id = c1.claim_id
                      AND item_no = c1.item_no
                      AND grouped_item_no = c1.grouped_item_no
                      AND peril_cd = c1.peril_cd
                      AND grp_seq_no = c2.grp_seq_no
                      AND line_cd = P2_LINE_CD
                      AND clm_dist_no = V2_CLM_DIST_NO
                      AND clm_loss_id = P2_CLM_LOSS_ID)
         LOOP
            v_share_exist := 'Y';
         END LOOP;

         v_paid_amt := c1.paid_amt * c2.shr_pct / 100;
         v_advise_amt := c1.advise_amt * c2.shr_pct / 100;
         v_net_amt := c1.net_amt * c2.shr_pct / 100;

         INSERT INTO gicl_loss_exp_ds
                     (claim_id,
                      dist_year,
                      clm_loss_id, clm_dist_no, item_no,
                      peril_cd, payee_cd, grp_seq_no, share_type,
                      shr_loss_exp_pct, shr_le_pd_amt, shr_le_adv_amt,
                      shr_le_net_amt, line_cd, acct_trty_type,
                      distribution_date, grouped_item_no
                     )
              VALUES (c1.claim_id,
                      TO_CHAR (NVL (P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'),
                      P2_CLM_LOSS_ID, V2_CLM_DIST_NO, c1.item_no,
                      c1.peril_cd, P2_PAYEE_CD, c2.grp_seq_no, c2.share_type,
                      c2.shr_pct, v_paid_amt, v_advise_amt,
                      v_net_amt, P2_LINE_CD, c2.acct_trty_type,
                      NVL (P2_DISTRIBUTION_DATE, SYSDATE), c1.grouped_item_no
                     );

         IF c2.share_type = giacp.v ('TRTY_SHARE_TYPE')
         THEN
            FOR c_trty IN cur_trty (c2.grp_seq_no)
            LOOP
               IF v_share_exist = 'N'
               THEN
                  INSERT INTO gicl_loss_exp_rids
                              (claim_id,
                               dist_year,
                               clm_loss_id, clm_dist_no, item_no,
                               peril_cd, payee_cd, grp_seq_no,
                               share_type, ri_cd,
                               shr_loss_exp_ri_pct,
                               shr_le_ri_pd_amt,
                               shr_le_ri_adv_amt,
                               shr_le_ri_net_amt,
                               line_cd, acct_trty_type,
                               prnt_ri_cd, grouped_item_no
                              )
                       VALUES (c1.claim_id,
                               TO_CHAR (NVL (P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'),
                               P2_CLM_LOSS_ID, V2_CLM_DIST_NO, c1.item_no,
                               c1.peril_cd, P2_PAYEE_CD, c2.grp_seq_no,
                               c2.share_type, c_trty.ri_cd,
                               (c2.shr_pct * (c_trty.trty_shr_pct / 100)
                               ),
                               (v_paid_amt * (c_trty.trty_shr_pct / 100)),
                               (v_advise_amt * (c_trty.trty_shr_pct / 100)
                               ),
                               (v_net_amt * (c_trty.trty_shr_pct / 100)),
                               P2_LINE_CD, c2.acct_trty_type,
                               c_trty.prnt_ri_cd, c1.grouped_item_no
                              );
               ELSE
                  UPDATE gicl_loss_exp_rids
                     SET shr_loss_exp_ri_pct =
                              NVL (shr_loss_exp_ri_pct, 0)
                            + (  NVL (c2.shr_pct, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         shr_le_ri_pd_amt =
                              NVL (shr_le_ri_pd_amt, 0)
                            + (  NVL (v_paid_amt, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         shr_le_ri_adv_amt =
                              NVL (shr_le_ri_adv_amt, 0)
                            + (  NVL (v_advise_amt, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         shr_le_ri_net_amt =
                              NVL (shr_le_ri_net_amt, 0)
                            + (  NVL (v_net_amt, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         dist_year =
                                 TO_CHAR (NVL (P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR')
                   WHERE claim_id = c1.claim_id
                     AND item_no = c1.item_no
                     AND grouped_item_no = nvl(c1.grouped_item_no,0)
                     AND peril_cd = c1.peril_cd
                     AND grp_seq_no = c2.grp_seq_no
                     AND line_cd = P2_LINE_CD
                     AND ri_cd = c_trty.ri_cd
                     AND clm_dist_no = V2_CLM_DIST_NO
                     AND clm_loss_id = P2_CLM_LOSS_ID;
               END IF;
            END LOOP;
         ELSIF c2.share_type = giacp.v ('FACUL_SHARE_TYPE')
         THEN
            FOR c3 IN cur_frperil (c1.peril_cd, c1.item_no)
            LOOP                                    /*RI peril distribution*/
               INSERT INTO gicl_loss_exp_rids
                           (claim_id,
                            dist_year,
                            clm_loss_id, clm_dist_no, item_no,
                            peril_cd, payee_cd, grp_seq_no,
                            share_type, ri_cd, shr_loss_exp_ri_pct,
                            shr_le_ri_pd_amt,
                            shr_le_ri_adv_amt,
                            shr_le_ri_net_amt, line_cd,
                            acct_trty_type, prnt_ri_cd, grouped_item_no
                           )
                    VALUES (c1.claim_id,
                            TO_CHAR (NVL (P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'),
                            P2_CLM_LOSS_ID, V2_CLM_DIST_NO, c1.item_no,
                            c1.peril_cd, P2_PAYEE_CD, c2.grp_seq_no,
                            c2.share_type, c3.ri_cd, c3.ri_shr_pct,
                            (c1.paid_amt * c3.ri_shr_pct / 100
                            ),
                            (c1.advise_amt * c3.ri_shr_pct / 100),
                            (c1.net_amt * c3.ri_shr_pct / 100
                            ), P2_LINE_CD,
                            c2.acct_trty_type, c3.ri_cd, c1.grouped_item_no
                           );
            END LOOP;                                      /*End of c3 loop */
            P2_MESSAGE :=  P2_MESSAGE || ' Status: ' ||'Distribution Complete. ';
         END IF;   
      END LOOP;
   END LOOP;

   UPDATE gicl_clm_loss_exp
      SET dist_sw = 'Y'
    WHERE claim_id = P2_CLAIM_ID 
      AND clm_loss_id = P2_CLM_LOSS_ID;
END DIST_BY_RESERVE_RISK_LOC;
--DISTRIBUTE_BY_RESERVE (CALL FROM DIST_CLM_RECORDS)
PROCEDURE DISTRIBUTE_BY_RESERVE (P2_CLAIM_ID          IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                                     P2_CLM_LOSS_ID       IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                     P2_ITEM_NO           IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                                     P2_PERIL_CD          IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                                     P2_GROUPED_ITEM_NO   IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                                     P2_LOSS_DATE         IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                                     P2_POL_EFF_DATE      IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                                     P2_EXPIRY_DATE       IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE, 
                                     P2_LINE_CD           IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                     P2_SUBLINE_CD        IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                                     P2_POL_ISS_CD        IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                                     P2_ISSUE_YY          IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                                     P2_POL_SEQ_NO        IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                                     P2_RENEW_NO          IN  GICL_CLAIMS.RENEW_NO%TYPE,
                                     P2_DISTRIBUTION_DATE IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                                     P2_PAYEE_CD          IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                                     V2_CLM_DIST_NO       IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                                     P2_MESSAGE           OUT VARCHAR2)
IS
  --Cursor for item/peril loss amount
  CURSOR cur_clm_res IS
    SELECT claim_id, hist_seq_no, item_no, peril_cd, 
           paid_amt, net_amt, advise_amt,
           grouped_item_no 
      FROM gicl_clm_loss_exp
     WHERE claim_id    = P2_CLAIM_ID
       AND clm_loss_id = P2_CLM_LOSS_ID;
  
  --Cursor for peril distribution in underwriting table.
  CURSOR cur_perilds(v_peril_cd giri_ri_dist_item_v.peril_cd%TYPE,
                        v_item_no  giri_ri_dist_item_v.item_no%TYPE) IS
    SELECT d.share_cd,    f.share_type,     f.trty_yy,
           f.prtfolio_sw, f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi, 
           f.eff_date, f.expiry_date
      FROM gipi_polbasic a,        gipi_item b,       giuw_pol_dist c,
           giuw_itemperilds_dtl d, giis_dist_share f, giis_parameters e
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
           DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), P2_POL_EFF_DATE, a.eff_date ), c.eff_date)) 
           <= trunc(P2_LOSS_DATE)
       AND TRUNC(DECODE(TRUNC(c.expiry_date), TRUNC(a.expiry_date), DECODE(NVL(a.endt_expiry_date, a.expiry_date),
           a.expiry_date, P2_EXPIRY_DATE, a.endt_expiry_date), c.expiry_date))  
           >= trunc(P2_LOSS_DATE)
       AND b.policy_id  = a.policy_id
       AND a.line_cd    = P2_LINE_CD
       AND a.subline_cd = P2_SUBLINE_CD
       AND a.iss_cd     = P2_POL_ISS_CD
       AND a.issue_yy   = P2_ISSUE_YY
       AND a.pol_seq_no = P2_POL_SEQ_NO
       AND a.renew_no   = P2_RENEW_NO
       AND a.pol_flag   IN ('1','2','3','X')
  GROUP BY d.share_cd,       f.share_type,  f.trty_yy,
           f.acct_trty_type, f.prtfolio_sw, f.eff_date, f.expiry_date
  ORDER BY f.share_type DESC;
  
  --Cursor for peril distribution in treaty table.
   CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%type,
                   v_trty_yy  giis_dist_share.trty_yy%type) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM giis_trty_panel
    WHERE line_cd     = P2_LINE_CD
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;

  --Cursor for peril distribution in ri table.
  
   CURSOR cur_frperil(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
                          v_item_no  giri_ri_dist_item_v.item_no%type)is
   SELECT t2.ri_cd,
          SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt 
     FROM gipi_polbasic    t5, gipi_itmperil    t8, giuw_pol_dist    t4,
          giuw_itemperilds t6, giri_distfrps    t3, giri_frps_ri     t2       
    WHERE 1=1
      AND t5.line_cd              = P2_LINE_CD
      AND t5.subline_cd           = P2_SUBLINE_CD
      AND t5.iss_cd               = P2_POL_ISS_CD
      AND t5.issue_yy             = P2_ISSUE_YY
      AND t5.pol_seq_no           = P2_POL_SEQ_NO
      AND t5.renew_no             = P2_RENEW_NO
      AND t5.pol_flag             IN ('1','2','3','X')   
      AND t5.policy_id            = t8.policy_id
      AND t8.peril_cd             = v_peril_cd
      AND t8.item_no              = v_item_no
      AND t5.policy_id            = t4.policy_id   
      AND TRUNC(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
          DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), P2_POL_EFF_DATE, t5.eff_date ), t4.eff_date)) 
          <= trunc(P2_LOSS_DATE)
      AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t5.expiry_date),
          DECODE(NVL(t5.endt_expiry_date, t5.expiry_date),
          t5.expiry_date, P2_EXPIRY_DATE, t5.endt_expiry_date), t4.expiry_date))
          >= trunc(P2_LOSS_DATE)
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
  ann_dist_spct         gicl_loss_exp_ds.shr_loss_exp_pct%TYPE := 0;
  me                    NUMBER := 0;
  v_facul_share_cd         giuw_perilds_dtl.share_cd%TYPE;
  v_trty_share_type     giis_dist_share.share_type%TYPE;
  v_facul_share_type    giis_dist_share.share_type%TYPE;
  v_paid_amt            gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_advise_amt          gicl_loss_exp_ds.shr_le_adv_amt%TYPE;
  v_net_amt             gicl_loss_exp_ds.shr_le_net_amt%TYPE;
  v_trty_limit              giis_dist_share.trty_limit%TYPE;  
  v_facul_amt                gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_orig_net_amt          gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_treaty_amt              gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
  v_qs_shr_pct              giis_dist_share.qs_shr_pct%TYPE;
  v_acct_trty_type        giis_dist_share.acct_trty_type%TYPE;
  v_share_cd            giis_dist_share.share_cd%TYPE;
  v_policy                  VARCHAR2(2000);
  counter                    NUMBER := 0;
  v_switch                  NUMBER := 0;
  v_policy_id                NUMBER;
  v_clm_dist_no         NUMBER := 0;
  V2_CLM_DIST_NO2       NUMBER := 0;
  v_peril_sname              giis_peril.peril_sname%TYPE;
  v_trty_peril          giis_peril.peril_sname%TYPE;
  v_dist_flag           giis_parameters.param_value_v%TYPE;
--switch to determine if share_cd is already existing 
  v_share_exist         VARCHAR2(1);

  v_res_dist_yr         gicl_reserve_ds.dist_year%TYPE;
  v_res_shr_type        gicl_reserve_ds.share_type%TYPE;
  v_res_acct_trty_type  gicl_reserve_ds.acct_trty_type%TYPE;
  v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
BEGIN

  FOR rec IN
    (SELECT param_value_v
       FROM giis_parameters
      WHERE param_name = 'DISTRIBUTED')
  LOOP
    v_dist_flag := rec.param_value_v;
  END LOOP;

  V2_CLM_DIST_NO2 := nvl(V2_CLM_DIST_NO,0) + 1;
  v_clm_dist_no   := V2_CLM_DIST_NO2;
  
  P2_MESSAGE := 'CLAIM NO: ' || GET_CLM_NO(P2_CLAIM_ID)|| ' ' || 'ITEM NO: '||P2_ITEM_NO|| ' PERIL CD: '||P2_PERIL_CD|| ' GROUPED ITEM NO: '||P2_GROUPED_ITEM_NO;

  FOR c1 in cur_clm_res LOOP        /*Using Item-peril cursor */
    BEGIN
      SELECT param_value_n
        INTO v_facul_share_cd
        FROM giis_parameters
       WHERE param_name = 'FACULTATIVE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P2_MESSAGE :=  P2_MESSAGE || ' Status: ' ||
                     'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT param_value_v
        INTO v_trty_share_type
        FROM giac_parameters
      WHERE param_name = 'TRTY_SHARE_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P2_MESSAGE :=  P2_MESSAGE || ' Status: ' ||
                     'There is no existing TRTY_SHARE_TYPE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT param_value_v
        INTO v_facul_share_type
        FROM giac_parameters
       WHERE param_name = 'FACUL_SHARE_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P2_MESSAGE :=  P2_MESSAGE || ' Status: ' ||
                     'There is no existing FACUL_SHARE_TYPE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT param_value_n
        INTO v_acct_trty_type
        FROM giac_parameters
       WHERE param_name = 'QS_ACCT_TRTY_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         P2_MESSAGE :=  P2_MESSAGE || ' Status: ' ||
                     'There is no existing QS_ACCT_TRTY_TYPE parameter in GIIS_PARAMETERS table.';
    END;

    BEGIN
      SELECT SUM(T1.TSI_AMT) TSI_AMT 
        INTO sum_tsi_amt
        FROM gipi_polbasic T2, gipi_item T3, gipi_itmperil T1,
             giuw_pol_dist T4
       WHERE T2.policy_id = T3.policy_id
         AND T3.policy_id = T1.policy_id 
         AND T3.item_no   = T1.item_no
         AND T2.policy_id = T4.policy_id
         AND TRUNC(DECODE(TRUNC(t4.eff_date), TRUNC(t2.eff_date),
             DECODE(TRUNC(t2.eff_date), TRUNC(t2.incept_date), P2_POL_EFF_DATE, t2.eff_date ), t4.eff_date)) 
             <= trunc(P2_LOSS_DATE)
         AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t2.expiry_date),
             DECODE(NVL(t2.endt_expiry_date, t2.expiry_date),
             t2.expiry_date, P2_EXPIRY_DATE, t2.endt_expiry_date), t4.expiry_date))
             >= trunc(P2_LOSS_DATE)
         AND T1.item_no    = c1.item_no
         AND T1.peril_cd   = c1.peril_cd
         AND T2.line_cd    = P2_LINE_CD
         AND T2.subline_cd = P2_SUBLINE_CD
         AND T2.iss_cd     = P2_POL_ISS_CD
         AND T2.issue_yy   = P2_ISSUE_YY
         AND T2.pol_seq_no = P2_POL_SEQ_NO
         AND T2.renew_no   = P2_RENEW_NO
         AND t2.pol_flag   IN ('1','2','3','X')
         AND T4.dist_flag  = v_dist_flag; 
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P2_MESSAGE := P2_MESSAGE || ' Status: ' ||'The TSI for this policy is Zero...';
    END; 

    FOR me IN cur_perilds(c1.peril_cd, c1.item_no) LOOP
      IF me.acct_trty_type = v_acct_trty_type THEN
         v_switch  := 1;
      ELSIF ((me.acct_trty_type = v_acct_trty_type) OR
        (me.acct_trty_type IS NULL)) and (v_switch <> 1) THEN
         v_switch := 0;
      END IF;
    END LOOP;

    SELECT peril_sname
      INTO v_peril_sname
      FROM giis_peril
     WHERE peril_cd = c1.peril_cd
       AND line_cd  = P2_LINE_CD;
 
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
    
    IF sum_tsi_amt!=0 AND sum_tsi_amt IS NOT NULL THEN 

    IF sum_tsi_amt > v_trty_limit THEN
       FOR I IN CUR_PERILDS(C1.PERIL_CD, C1.ITEM_NO) LOOP
         IF I.SHARE_TYPE = V_FACUL_SHARE_TYPE THEN
            v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi/sum_tsi_amt);
         END IF;
       END LOOP;
       v_orig_net_amt := (sum_tsi_amt - nvl(v_facul_amt,0))* ((100 - v_qs_shr_pct)/100);  
       v_treaty_amt   := (sum_tsi_amt - nvl(v_facul_amt,0))* (v_qs_shr_pct/100);
    ELSE
       v_orig_net_amt := sum_tsi_amt * ((100 - v_qs_shr_pct)/100);
       v_treaty_amt   := sum_tsi_amt * (v_qs_shr_pct/100);     
    END IF;

    BEGIN
      SELECT MAX(dist_year) dist_year
        INTO v_res_dist_yr
        FROM gicl_reserve_ds
       WHERE claim_id = P2_CLAIM_ID
         AND item_no  = P2_ITEM_NO
         AND peril_cd = P2_PERIL_CD
         AND grouped_item_no = NVL(P2_GROUPED_ITEM_NO,0)
         AND NVL(negate_tag,'N')<> 'Y';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_res_dist_yr := TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR');
    END;

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
           IF NVL(c2.prtfolio_sw, 'N') = 'P' AND
             TRUNC(c2.expiry_date) < NVL(P2_DISTRIBUTION_DATE, SYSDATE) THEN
              WHILE TRUNC(c2.expiry_date) < NVL(P2_DISTRIBUTION_DATE, SYSDATE) LOOP
                BEGIN
                  SELECT share_cd,       trty_yy,    NVL(prtfolio_sw, 'N'),
                         acct_trty_type, share_type, expiry_date
                    INTO v_share_cd,  v_treaty_yy2, v_prtf_sw,
                         v_acct_trty, v_share_type, v_expiry_date
                       FROM giis_dist_share
                     WHERE line_cd            = P2_LINE_CD
                       AND old_trty_seq_no  =  c2.share_cd;                    
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                      P2_MESSAGE := P2_MESSAGE  || ' Status: ' ||'No new treaty set-up for year '|| TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR');
                    EXIT;
                    WHEN TOO_MANY_ROWS THEN
                      P2_MESSAGE := P2_MESSAGE  || ' Status: ' ||'Too many treaty set-up for year '|| TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'); 
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

      ANN_DIST_SPCT := 0;

      FOR res_pct IN
        (SELECT a.share_type, a.shr_pct, a.acct_trty_type
           FROM gicl_reserve_ds a
          WHERE a.dist_year            = v_res_dist_yr
            AND a.peril_cd             = P2_PERIL_CD
            AND a.item_no              = P2_ITEM_NO
            AND a.grouped_item_no      = NVL(P2_GROUPED_ITEM_NO,0)
            AND a.claim_id             = P2_CLAIM_ID
            AND a.share_type           not in (v_xol_share_type, '1')
            and a.share_type           = c2.share_type
            AND NVL(a.acct_trty_type, 0) = NVL(c2.acct_trty_type, 0)
            AND NVL(a.negate_tag, 'N') <> 'Y'
            AND a.hist_seq_no          = (SELECT MAX(b.hist_seq_no)
                                            FROM gicl_reserve_ds B
                                           WHERE b.dist_year           = a.dist_year
                                             AND b.peril_cd            = a.peril_cd
                                             AND b.item_no             = a.item_no
                                             AND b.grouped_item_no     = a.grouped_item_no
                                             AND b.claim_id            = a.claim_id
                                             AND NVL(b.negate_tag, 'N') <> 'Y'))
      LOOP
          ann_dist_spct := res_pct.shr_pct;
      END LOOP;

      IF ((c2.acct_trty_type <> v_acct_trty_type) OR
            (c2.acct_trty_type IS NULL)) AND
             v_switch = 0 THEN 

          IF ann_dist_spct = 0 THEN
             ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
          END IF;
         v_paid_amt     := c1.paid_amt * ann_dist_spct/100; 
         v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
         v_net_amt      := c1.net_amt * ann_dist_spct/100;
      ELSE

         IF (c2.share_type = v_trty_share_type) AND
              (c2.share_cd = v_share_cd) THEN

            IF ann_dist_spct = 0 THEN
               ann_dist_spct := (v_treaty_amt/sum_tsi_amt) * 100;
            END IF;
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100;
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
            v_net_amt      := c1.net_amt * ann_dist_spct/100;
         ELSIF (c2.share_type != v_trty_share_type) AND
               (c2.share_type != v_facul_share_type) AND
               (v_net_amt IS NOT NULL) THEN

            IF ann_dist_spct = 0 THEN
               ann_dist_spct := (v_net_amt/sum_tsi_amt) * 100;
            END IF;
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100;
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
            v_net_amt      := c1.net_amt * ann_dist_spct/100;
         ELSE

            IF ann_dist_spct = 0 THEN
               ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
            END IF;
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100;
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100;
            v_net_amt      := c1.net_amt * ann_dist_spct/100;
         END IF;
      END IF;
/*checks if share_cd is already existing if existing updates gicl_reserve_ds
if not existing then inserts record to gicl_reserve_ds*/ 
      v_share_exist := 'N';
      FOR i IN 
        (SELECT '1'
           FROM gicl_loss_exp_ds
          WHERE claim_id    = P2_CLAIM_ID
            AND item_no     = c1.item_no
            AND grouped_item_no = NVL(c1.grouped_item_no,0)
            AND peril_cd    = c1.peril_cd
            AND grp_seq_no  = c2.share_cd
            AND line_cd     = P2_LINE_CD
            AND clm_dist_no = V_CLM_DIST_NO             
            AND clm_loss_id = P2_CLM_LOSS_ID)        
      LOOP
        v_share_exist :='Y';
      END LOOP;

      IF ann_dist_spct <> 0 THEN
         IF v_share_exist = 'N' THEN
            INSERT INTO gicl_loss_exp_ds(claim_id,                  dist_year,     clm_loss_id,
                                         clm_dist_no,          item_no,         peril_cd,
                                         payee_cd,              grp_seq_no,       share_type,
                                         shr_loss_exp_pct, shr_le_pd_amt, shr_le_adv_amt,
                                         shr_le_net_amt,     line_cd,            acct_trty_type,
                                         distribution_date,
                                         grouped_item_no)
                                 VALUES (P2_CLAIM_ID,     TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'), P2_CLM_LOSS_ID,
                                         v_clm_dist_no,     c1.item_no,       c1.peril_cd,
                                                 P2_PAYEE_CD, c2.share_cd,   c2.share_type,
                                                 ann_dist_spct,  v_paid_amt,    v_advise_amt,
                                                 v_net_amt,             P2_LINE_CD, c2.acct_trty_type,
                                                 NVL(P2_DISTRIBUTION_DATE, SYSDATE),
                                                 C1.grouped_item_no);
         ELSE
            UPDATE gicl_loss_exp_ds
               SET shr_le_pd_amt     = NVL(shr_le_pd_amt,0) + NVL(v_paid_amt,0),
                   shr_le_adv_amt    = NVL(shr_le_adv_amt,0) + NVL(v_advise_amt,0),
                   shr_le_net_amt    = NVL(shr_le_net_amt,0) + NVL(v_net_amt,0),
                   shr_loss_exp_pct  = NVL(shr_loss_exp_pct,0) + NVL(ann_dist_spct,0),
                   dist_year         = TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'),
                   distribution_date = NVL(P2_DISTRIBUTION_DATE, SYSDATE)
             WHERE claim_id    = P2_CLAIM_ID
               AND item_no     = c1.item_no
               AND grouped_item_no = nvl(c1.grouped_item_no,0)
               AND peril_cd    = c1.peril_cd
               AND grp_seq_no  = c2.share_cd
                 AND line_cd     = P2_LINE_CD
               AND clm_dist_no = v_clm_dist_no                      
               AND clm_loss_id = P2_CLM_LOSS_ID;
         END IF;           
         me := TO_NUMBER(c2.share_type) - TO_NUMBER(v_trty_share_type);
         IF me = 0 THEN
            FOR c_trty IN cur_trty(c2.share_cd, c2.trty_yy) LOOP
              IF v_share_exist = 'N' THEN
                 INSERT INTO gicl_loss_exp_rids(claim_id,                  dist_year,               clm_loss_id,
                                                clm_dist_no,       item_no,                     peril_cd, 
                                                       payee_cd,            grp_seq_no,          share_type,
                                                      ri_cd,             shr_loss_exp_ri_pct, shr_le_ri_pd_amt,
                                                      shr_le_ri_adv_amt, shr_le_ri_net_amt,   line_cd,         
                                                        acct_trty_type,         prnt_ri_cd,
                                                        grouped_item_no)
                                              VALUES  (P2_CLAIM_ID, TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR'), P2_CLM_LOSS_ID,
                                                           v_clm_dist_no,    c1.item_no,                   c1.peril_cd,
                                                          P2_PAYEE_CD, c2.share_cd,             v_trty_share_type,
                                                          c_trty.ri_cd,   
                                                          (ann_dist_spct  * (c_trty.trty_shr_pct/100)),
                                                          (v_paid_amt * (c_trty.trty_shr_pct/100)),(v_advise_amt  * (c_trty.trty_shr_pct/100)), 
                                                          (v_net_amt  * (c_trty.trty_shr_pct/100)),
                                                          P2_LINE_CD,     c2.acct_trty_type,       c_trty.prnt_ri_cd,
                                                          c1.grouped_item_no);
              ELSE
                 UPDATE gicl_loss_exp_rids
                    SET shr_loss_exp_ri_pct = NVL(shr_loss_exp_ri_pct,0) + (NVL(ann_dist_spct,0)  * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_pd_amt    = NVL(shr_le_ri_pd_amt,0) + (NVL(v_paid_amt,0) * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_adv_amt   = NVL(shr_le_ri_adv_amt,0) + (NVL(v_advise_amt,0)  * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_net_amt   = NVL(shr_le_ri_net_amt,0) + (NVL(v_net_amt,0)  * (c_trty.trty_shr_pct/100)),
                        dist_year           = TO_CHAR(NVL(P2_DISTRIBUTION_DATE, SYSDATE), 'RRRR')
                  WHERE claim_id    = P2_CLAIM_ID
                    AND item_no     = c1.item_no
                    AND grouped_item_no = nvl(c1.grouped_item_no,0)
                    AND peril_cd    = c1.peril_cd
                    AND grp_seq_no  = c2.share_cd
                      AND line_cd     = P2_LINE_CD
                    AND ri_cd       = c_trty.ri_cd 
                      AND clm_dist_no = v_clm_dist_no             
                    AND clm_loss_id = P2_CLM_LOSS_ID;
              END IF;            
            END LOOP; /*end of c_trty loop*/
         ELSIF c2.share_type = v_facul_share_type THEN
    
            FOR c3 IN cur_frperil(c1.peril_cd, c1.item_no) LOOP /*RI peril distribution*/
              IF (c2.acct_trty_type <> v_acct_trty_type) OR
                   (c2.acct_trty_type IS NULL) THEN
                 ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
              ELSE
                 ann_ri_pct := (v_facul_amt /sum_tsi_Amt) * 100;
              END IF; 
              INSERT INTO gicl_loss_exp_rids(claim_id,      dist_year,               clm_loss_id, 
                                             clm_dist_no, item_no,                 peril_cd,
                                             payee_cd,    grp_seq_no,               share_type,
                                             ri_cd,       shr_loss_exp_ri_pct, shr_le_ri_pd_amt,
                                             shr_le_ri_adv_amt,
                                             shr_le_ri_net_amt,
                                             line_cd,                   acct_trty_type, prnt_ri_cd,
                                             grouped_item_no)
                                          VALUES(P2_CLAIM_ID,         to_char(sysdate, 'YYYY'),  P2_CLM_LOSS_ID,
                                             v_clm_dist_no,          c1.item_no,                    c1.peril_cd,
                                                      P2_PAYEE_CD,     c2.share_cd,                    v_facul_share_type,
                                                      c3.ri_cd,               ann_ri_pct,                (c1.paid_amt * ann_ri_pct/100),
                                                  (c1.advise_amt * ann_ri_pct/100),
                                                  (c1.net_amt * ann_ri_pct/100),
                                                  P2_LINE_CD,       c2.acct_trty_type,         c3.ri_cd,
                                                  c1.grouped_item_no);
            END LOOP; /*End of c3 loop */
         END IF;
      ELSE 
         NULL;
      END IF;
    END LOOP; /*End of c2 loop*/ 
        P2_MESSAGE := P2_MESSAGE || ' Status: ' ||'Distribution Complete. ';   
    ELSIF sum_tsi_amt = 0 THEN
        P2_MESSAGE := P2_MESSAGE || ' Status: ' ||'TSI for this peril is zero... Cannot distribute loss/exp history';
    END IF; -- end of IF sum_tsi_amt!=0 THEN
  END LOOP; /*End of c1 loop */

  UPDATE gicl_clm_loss_exp
     SET dist_sw     = 'Y'
   WHERE claim_id    = P2_CLAIM_ID
     AND clm_loss_id = P2_CLM_LOSS_ID;
  
  OFFSET_AMT(V_CLM_DIST_NO, P2_CLAIM_ID, P2_CLM_LOSS_ID);

END DISTRIBUTE_BY_RESERVE;

--DISTRIBUTE_LOSS_EXP_XOL (CALL FROM DIST_CLM_RECORDS)
PROCEDURE DISTRIBUTE_LOSS_EXP_XOL (P_CLAIM_ID           IN  GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                                   P_CLM_LOSS_ID        IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                   P_HIST_SEQ_NO        IN  GICL_CLM_RES_HIST.HIST_SEQ_NO%TYPE, 
                                   P_LINE_CD            IN  GICL_CLAIMS.LINE_CD%TYPE,                          
                                   P_ITEM_NO            IN  GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                                   P_PERIL_CD           IN  GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                                   P_GROUPED_ITEM_NO    IN  GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                                   P_CLM_DIST_NO        IN  GICL_LOSS_EXP_DS.CLM_DIST_NO%TYPE,
                                   P_LOSS_DATE          IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                                   P_CATASTROPHIC_CD    IN  GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                                   P_PAYEE_CD           IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE)
IS
  v_retention                    gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_retention_orig                gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_running_retention            gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_total_retention                gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_allowed_retention             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_total_xol_share                gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_overall_xol_share            gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_overall_allowed_share        gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_old_xol_share                  gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;        
  v_allowed_ret                      gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
  v_shr_pct                        gicl_reserve_ds.shr_pct%TYPE;
  v_net_ret_shr_pct       gicl_loss_exp_ds.shr_loss_exp_pct%TYPE := 0;

  --Cursor for peril distribution in treaty table.
   CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%type,
                   v_trty_yy  giis_dist_share.trty_yy%type) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM giis_trty_panel
    WHERE line_cd     = P_LINE_CD
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;  
BEGIN
      FOR net_shr IN (SELECT a.dist_year, a.payee_cd, a.item_no, a.grouped_item_no,
                                         a.peril_cd, a.shr_le_pd_amt paid_amt, a.shr_le_net_amt net_amt, 
                                         a.shr_le_adv_amt adv_amt2, a.shr_loss_exp_pct shr_pct,
                                            (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) adv_amt
                                       FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                   WHERE a.claim_id    = b.claim_id
                                     AND a.clm_loss_id = b.clm_loss_id
                                     AND a.claim_id    = P_CLAIM_ID
                                     AND a.clm_loss_id = P_CLM_LOSS_ID
                                     AND a.clm_dist_no = P_CLM_DIST_NO
                       AND a.share_type  = 1)
      LOOP
          v_retention := NVL(net_shr.adv_amt,0);
        v_retention_orig := NVL(net_shr.adv_amt,0);
        v_total_retention := v_retention ;

        IF P_CATASTROPHIC_CD IS NULL THEN
        FOR TOT_NET IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                        FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                        WHERE a.claim_id             = b.claim_id
                                          AND a.clm_loss_id          = b.clm_loss_id
                                      AND a.claim_id             = P_CLAIM_ID
                                          AND a.share_type           = 1
                                          AND NVL(b.cancel_sw, 'N')  = 'N'
                                          AND NVL(a.negate_tag, 'N') = 'N'
                                          AND a.clm_loss_id         <> P_CLM_LOSS_ID)
           LOOP
          v_total_retention := v_total_retention + NVL(tot_net.ret_amt,0); 
           END LOOP;          
           
           FOR CHK_XOL IN (SELECT a.share_cd,   acct_trty_type,  xol_allowed_amount,
                                              xol_base_amount, xol_allocated_amount, trty_yy,
                                              xol_aggregate_sum, a.line_cd, a.share_type
                                           FROM giis_dist_share a, giis_trty_peril b
                                       WHERE a.line_cd             = b.line_cd
                                         AND a.share_cd            = b.trty_seq_no
                                         AND a.share_type          = '4'
                                         AND TRUNC(a.eff_date)    <= TRUNC(P_LOSS_DATE)
                                         AND TRUNC(a.expiry_date) >= TRUNC(P_LOSS_DATE)
                                         AND b.peril_cd            = P_PERIL_CD             
                                         AND a.line_cd             = P_LINE_CD                
                                       ORDER BY xol_base_amount ASC)
           LOOP
             v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;

            IF v_allowed_retention < 1 THEN             
            EXIT;
             END IF;
             v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum, 0);
             
             FOR get_all_xol IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                                  FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                                  WHERE a.claim_id             = b.claim_id
                                                  AND a.clm_loss_id          = b.clm_loss_id
                                                    AND NVL(b.cancel_sw, 'N')  = 'N'
                                                    AND NVL(a.negate_tag, 'N') = 'N'
                                                    AND grp_seq_no             = chk_xol.share_cd
                                                    AND line_cd                = chk_xol.line_cd)
             LOOP     
            v_overall_xol_share := v_overall_xol_share - NVL(get_all_xol.ret_amt,0);     
             END LOOP;     
             
             IF v_allowed_retention > v_overall_xol_share THEN
               v_allowed_retention := v_overall_xol_share;
             END IF;           
             IF v_allowed_retention > v_retention THEN
            v_allowed_retention := v_retention;     
             END IF;     
             v_total_xol_share := 0;
             v_old_xol_share := 0;
             FOR TOTAL_XOL IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                              FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                              WHERE a.claim_id             = P_CLAIM_ID
                                                AND a.claim_id             = b.claim_id
                                                AND a.clm_loss_id          = b.clm_loss_id
                                              AND NVL(b.cancel_sw, 'N')  = 'N'
                                                AND NVL(a.negate_tag, 'N') = 'N'
                                                AND grp_seq_no             = chk_xol.share_cd)
             LOOP
            v_total_xol_share :=NVL(total_xol.ret_amt,0);
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

            INSERT INTO gicl_loss_exp_ds(
              claim_id,                       dist_year,         clm_loss_id,
              clm_dist_no,                 item_no,              peril_cd,
              payee_cd,                   grp_seq_no,          share_type,
              shr_loss_exp_pct,       shr_le_pd_amt,     shr_le_adv_amt,
              shr_le_net_amt,            line_cd,                 acct_trty_type,
              grouped_item_no)
            VALUES (
              P_CLAIM_ID,  net_shr.dist_year, P_CLM_LOSS_ID,
              P_CLM_DIST_NO,     net_shr.item_no,          net_shr.peril_cd,
                      P_PAYEE_CD,         chk_xol.share_cd,  chk_xol.share_type,
                      net_shr.shr_pct * v_shr_pct,        
                      net_shr.paid_amt * v_shr_pct,  
                      net_shr.adv_amt2 * v_shr_pct,
                      net_shr.net_amt * v_shr_pct,      P_LINE_CD,     chk_xol.acct_trty_type,
                      net_shr.grouped_item_no);
                    FOR update_xol_trty IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                                             FROM gicl_loss_exp_ds a,  gicl_clm_loss_exp b
                                                            WHERE a.claim_id             = b.claim_id
                                                           AND a.clm_loss_id          = b.clm_loss_id
                                                           AND NVL(b.cancel_sw, 'N')  = 'N'
                                                           AND NVL(a.negate_tag, 'N') = 'N'
                                                           AND grp_seq_no             = chk_xol.share_cd
                                                           AND a.line_cd              = chk_xol.line_cd)
            LOOP     
              UPDATE giis_dist_share 
                 SET xol_allocated_amount = update_xol_trty.ret_amt
               WHERE share_cd = chk_xol.share_cd
                 AND line_cd  = chk_xol.line_cd;
            END LOOP;             
            FOR xol_trty In
              cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
            LOOP
              INSERT INTO gicl_loss_exp_rids
               (claim_id,                  dist_year,               clm_loss_id,
                clm_dist_no,       item_no,                     peril_cd, 
                payee_cd,            grp_seq_no,          share_type,
                ri_cd,             shr_loss_exp_ri_pct, shr_le_ri_pd_amt,
                shr_le_ri_adv_amt, shr_le_ri_net_amt,   line_cd,         
                        acct_trty_type,         prnt_ri_cd,
                        grouped_item_no)
              VALUES
                (P_CLAIM_ID, to_char(sysdate,'YYYY'), P_CLM_LOSS_ID,
                    P_CLM_DIST_NO,    net_shr.item_no,   net_shr.peril_cd,
                           P_PAYEE_CD, chk_xol.share_cd,  chk_xol.share_type,    xol_trty.ri_cd,   
                           ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                           ((net_shr.paid_amt * v_shr_pct) * (xol_trty.trty_shr_pct/100)),
                           ((net_shr.adv_amt2 * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), 
                           ((net_shr.net_amt * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                           P_LINE_CD,     chk_xol.acct_trty_type,       xol_trty.prnt_ri_cd,
                           net_shr.grouped_item_no);
                       END LOOP;    
          END IF;         
          v_retention := v_retention - v_total_xol_share;
          v_total_retention := v_total_retention +  v_old_xol_share;        
        END LOOP; --CHK_XOL          
        ELSE -- under catastrophic event
        FOR TOT_NET IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                        FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b, gicl_claims c
                                       WHERE a.claim_id             = b.claim_id
                                         AND a.clm_loss_id          = b.clm_loss_id
                                         AND a.claim_id             = c.claim_id
                                         AND c.catastrophic_cd      = P_CATASTROPHIC_CD
                                         AND a.share_type           = 1
                                         AND NVL(b.cancel_sw, 'N')  = 'N'
                                         AND NVL(a.negate_tag, 'N') = 'N'
                                         AND (a.claim_id <> P_CLAIM_ID OR
                                           a.clm_loss_id <> P_CLM_LOSS_ID))
           LOOP
          v_total_retention := v_total_retention + NVL(tot_net.ret_amt,0);  
           END LOOP;          
           FOR CHK_XOL IN (SELECT a.share_cd,   acct_trty_type,  xol_allowed_amount,
                                              xol_base_amount, xol_allocated_amount, trty_yy,
                                              xol_aggregate_sum, a.line_cd, a.share_type
                                           FROM giis_dist_share a, giis_trty_peril b
                                       WHERE a.line_cd             = b.line_cd
                                         AND a.share_cd            = b.trty_seq_no
                                         AND a.share_type          = '4'
                                         AND TRUNC(a.eff_date)    <= TRUNC(P_LOSS_DATE)
                                         AND TRUNC(a.expiry_date) >= TRUNC(P_LOSS_DATE)
                                         AND b.peril_cd            = P_PERIL_CD             
                                         AND a.line_cd             = P_LINE_CD                
                                       ORDER BY xol_base_amount ASC)
           LOOP
                v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
               IF v_allowed_retention < 1 THEN             
            EXIT;
             END IF;
             v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum,0);
             FOR get_all_xol IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                                  FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                                  WHERE a.claim_id             = b.claim_id
                                                    AND a.clm_loss_id          = b.clm_loss_id
                                                    AND NVL(b.cancel_sw, 'N')  = 'N'
                                                   AND NVL(a.negate_tag, 'N') = 'N'
                                                   AND grp_seq_no             = chk_xol.share_cd
                                                   AND line_cd                = chk_xol.line_cd)
             LOOP
               v_overall_xol_share := v_overall_xol_share - NVL(get_all_xol.ret_amt,0);          
             END LOOP;     
             IF v_allowed_retention > v_overall_xol_share THEN
               v_allowed_retention := v_overall_xol_share;
             END IF;           
             IF v_allowed_retention > v_retention THEN
            v_allowed_retention := v_retention;     
             END IF;     
             v_total_xol_share := 0;
             v_old_xol_share := 0;
             FOR TOTAL_XOL IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                              FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                              WHERE a.claim_id             = P_CLAIM_ID
                                                AND a.claim_id             = b.claim_id
                                                AND a.clm_loss_id          = b.clm_loss_id
                                               AND NVL(b.cancel_sw, 'N')  = 'N'
                                               AND NVL(a.negate_tag, 'N') = 'N'
                                               AND grp_seq_no             = chk_xol.share_cd)
             LOOP
               v_total_xol_share :=NVL(total_xol.ret_amt,0);
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
            INSERT INTO gicl_loss_exp_ds(
              claim_id,                       dist_year,         clm_loss_id,
              clm_dist_no,                 item_no,              peril_cd,
              payee_cd,                   grp_seq_no,          share_type,
              shr_loss_exp_pct,       shr_le_pd_amt,     shr_le_adv_amt,
              shr_le_net_amt,            line_cd,                 acct_trty_type,
              grouped_item_no)
            VALUES (
              P_CLAIM_ID, net_shr.dist_year, P_CLM_LOSS_ID,
              P_CLM_DIST_NO,     net_shr.item_no,          net_shr.peril_cd,
                      P_PAYEE_CD,         chk_xol.share_cd,  chk_xol.share_type,
                      net_shr.shr_pct * v_shr_pct,        
                      net_shr.paid_amt * v_shr_pct,  
                      net_shr.adv_amt2 * v_shr_pct,
                      net_shr.net_amt * v_shr_pct,      P_LINE_CD,     chk_xol.acct_trty_type,
                      net_shr.grouped_item_no);
                    FOR update_xol_trty IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                                             FROM gicl_loss_exp_ds a,  gicl_clm_loss_exp b
                                                            WHERE a.claim_id             = b.claim_id
                                       AND a.clm_loss_id          = b.clm_loss_id
                                                           AND NVL(b.cancel_sw, 'N')  = 'N'
                                                           AND NVL(a.negate_tag, 'N') = 'N'
                                                           AND grp_seq_no             = chk_xol.share_cd
                                                           AND a.line_cd              = chk_xol.line_cd)
            LOOP     
              UPDATE giis_dist_share 
                 SET xol_allocated_amount = update_xol_trty.ret_amt
               WHERE share_cd = chk_xol.share_cd
                 AND line_cd = chk_xol.line_cd;
            END LOOP;             
            FOR xol_trty IN cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
            LOOP
              INSERT INTO gicl_loss_exp_rids
               (claim_id,                  dist_year,               clm_loss_id,
                clm_dist_no,       item_no,                     peril_cd, 
                payee_cd,            grp_seq_no,          share_type,
                ri_cd,             shr_loss_exp_ri_pct, shr_le_ri_pd_amt,
                shr_le_ri_adv_amt, shr_le_ri_net_amt,   line_cd,         
                        acct_trty_type,         prnt_ri_cd,
                        grouped_item_no)
              VALUES
                (P_CLAIM_ID, to_char(sysdate,'YYYY'), P_CLM_LOSS_ID,
                    P_CLM_DIST_NO,    net_shr.item_no,                   net_shr.peril_cd,
                           P_PAYEE_CD, chk_xol.share_cd,             chk_xol.share_type,    xol_trty.ri_cd,   
                           ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                           ((net_shr.paid_amt * v_shr_pct) * (xol_trty.trty_shr_pct/100)),
                           ((net_shr.adv_amt2 * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), 
                           ((net_shr.net_amt * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                           P_LINE_CD,     chk_xol.acct_trty_type,       xol_trty.prnt_ri_cd,
                           net_shr.grouped_item_no);
                       END LOOP;
          END IF;    
          v_retention := v_retention - v_total_xol_share;
          v_total_retention := v_total_retention +  v_old_xol_share;        
        END LOOP; --CHK_XOL              
      END IF;    -- end catastrophic event condition     
    END LOOP; -- NET_SHR    

      IF v_retention = 0 THEN
        DELETE FROM gicl_loss_exp_ds
          WHERE claim_id    = P_CLAIM_ID
         AND clm_loss_id = P_CLM_LOSS_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND share_type  = 1;
    ELSIF v_retention <> v_retention_orig THEN          
         UPDATE gicl_loss_exp_ds
            SET shr_loss_exp_pct = shr_loss_exp_pct * (v_retention_orig-v_running_retention)/v_retention_orig,
                shr_le_pd_amt    = shr_le_pd_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
                shr_le_adv_amt   =  shr_le_adv_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
                shr_le_net_amt   =  shr_le_net_amt * (v_retention_orig-v_running_retention)/v_retention_orig
          WHERE claim_id    = P_CLAIM_ID
         AND clm_loss_id = P_CLM_LOSS_ID
         AND clm_dist_no = P_CLM_DIST_NO
         AND share_type  = 1;
      END IF;  

    FOR s IN (SELECT SUM(shr_loss_exp_pct) shr_pct
                        FROM gicl_loss_exp_ds
                       WHERE claim_id    = P_CLAIM_ID
                         AND clm_loss_id = P_CLM_LOSS_ID
                         AND clm_dist_no = P_CLM_DIST_NO)
      LOOP
        IF s.shr_pct != 100 THEN
            v_net_ret_shr_pct := 100 - s.shr_pct;
        END IF;
        FOR upd IN (SELECT paid_amt, net_amt, advise_amt 
                                 FROM gicl_clm_loss_exp
                             WHERE claim_id    = P_CLAIM_ID
                               AND clm_loss_id = P_CLM_LOSS_ID)
        LOOP
          UPDATE gicl_loss_exp_ds
             SET shr_loss_exp_pct = shr_loss_exp_pct + v_net_ret_shr_pct,
                 shr_le_pd_amt    = upd.paid_amt * (shr_loss_exp_pct + v_net_ret_shr_pct)/100,
                 shr_le_adv_amt   = upd.advise_amt * (shr_loss_exp_pct + v_net_ret_shr_pct)/100,
                 shr_le_net_amt   = upd.net_amt * (shr_loss_exp_pct + v_net_ret_shr_pct)/100
            WHERE claim_id    = P_CLAIM_ID
              AND clm_dist_no = P_CLM_DIST_NO
           AND clm_loss_id = P_CLM_LOSS_ID
           AND share_type  = 1;
        END LOOP;
      END LOOP;

      OFFSET_AMT(P_CLM_DIST_NO, P_CLAIM_ID, P_CLM_LOSS_ID);
END DISTRIBUTE_LOSS_EXP_XOL;

--CHK_XOL (CALL FROM DIST_CLM_RECORDS)
PROCEDURE CHK_XOL (P_CLAIM_ID           IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                   P_CLM_LOSS_ID        IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                   P_CATASTROPHIC_CD    IN  GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                   V_XOL_SHARE_TYPE    giac_parameters.param_value_v%TYPE,
                   V_EXISTS   IN OUT    VARCHAR2,
                   V_CURR_XOL IN OUT    VARCHAR2  ) IS
  v_other_xol   VARCHAR2(1) := 'N';
  v_other_net   VARCHAR2(1) := 'N';
  v_curr_net    VARCHAR2(1) := 'N';
BEGIN    
    FOR get_curr_xol IN(
      SELECT DISTINCT a.share_type share_type
      FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
     WHERE a.claim_id = b.claim_id
       AND a.clm_loss_id = b.clm_loss_id
       AND NVL(b.cancel_sw, 'N') = 'N'
       AND NVL(a.negate_tag, 'N') = 'N'
       AND a.share_type IN(V_XOL_SHARE_TYPE, 1)
       AND a.claim_id = P_CLAIM_ID 
       AND a.clm_loss_id = P_CLM_LOSS_ID)
  LOOP
  
      IF get_curr_xol.share_type = 1 THEN
       v_curr_net := 'Y';                 
    END IF;
    IF get_curr_xol.share_type = V_XOL_SHARE_TYPE THEN
          v_curr_xol := 'Y';                 
    END IF;                  
  END LOOP;     
    IF P_CATASTROPHIC_CD IS NULL THEN
       FOR get_all_xol IN(
       SELECT DISTINCT a.share_type share_type
         FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
        WHERE a.claim_id = b.claim_id
          AND a.clm_loss_id = b.clm_loss_id
          AND NVL(b.cancel_sw, 'N') = 'N'
          AND NVL(a.negate_tag, 'N') = 'N'
          AND a.claim_id = P_CLAIM_ID
          AND a.clm_loss_id <> P_CLM_LOSS_ID
          AND a.share_type IN(V_XOL_SHARE_TYPE, 1))
     LOOP     
          IF get_all_xol.share_type = 1 THEN
             v_other_net := 'Y';                 
          END IF;
          IF get_all_xol.share_type = V_XOL_SHARE_TYPE THEN
             v_other_xol := 'Y';                 
          END IF;             
     END LOOP;     
  ELSE
     FOR get_all_xol IN(
       SELECT DISTINCT a.share_type share_type
         FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b,
              gicl_claims c
        WHERE a.claim_id = b.claim_id
          AND a.clm_loss_id = b.clm_loss_id
          AND a.claim_id = c.claim_id
          AND NVL(b.cancel_sw, 'N') = 'N'
          AND NVL(a.negate_tag, 'N') = 'N'
          AND c.catastrophic_cd = P_CATASTROPHIC_CD
          AND a.share_type = V_XOL_SHARE_TYPE
          AND (a.claim_id <> P_CLAIM_ID OR a.clm_loss_id <> P_CLM_LOSS_ID))
     LOOP     
       IF get_all_xol.share_type = 1 THEN
             v_other_net := 'Y';                 
          END IF;
          IF get_all_xol.share_type = V_XOL_SHARE_TYPE THEN
             v_other_xol := 'Y';                 
          END IF;             
     END LOOP;              
  END IF;   
  --if current item peril has an existing net retention and 
  --other record has an existing xol share then validate for xol 
  IF v_other_net = 'Y' and v_curr_xol = 'Y' THEN
     v_exists := 'Y';
     
     --if current item peril has an existing xol share and 
     --other record has an existing net retention share then validate for xol       
  ELSIF v_curr_net = 'Y' and v_other_xol = 'Y' THEN
       v_exists := 'Y';
  ELSE                 
      v_exists := 'N';
  END IF;      
END CHK_XOL;
END REDISTRIBUTE_LOSS_EXP;
/


