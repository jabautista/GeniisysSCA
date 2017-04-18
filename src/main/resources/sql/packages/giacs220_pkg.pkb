CREATE OR REPLACE PACKAGE BODY CPI.GIACS220_PKG
AS

    FUNCTION check_for_prev_extract(
        p_line_cd       giac_treaty_extract.line_cd%TYPE,
        p_share_cd      giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_proc_year     giac_treaty_extract.proc_year%TYPE,
        p_proc_qtr      giac_treaty_extract.proc_qtr%TYPE
    ) RETURN VARCHAR
    IS
        v_is_prev_ext   VARCHAR(5) := 'FALSE';
    BEGIN
        
        FOR test IN (  SELECT 'X'
                         FROM giac_treaty_extract
                        WHERE line_cd   = p_line_cd
                          AND share_cd  = p_share_cd
                          AND trty_yy   = p_trty_yy
                          AND proc_year = p_proc_year
                          AND proc_qtr  = p_proc_qtr  )
        LOOP
            v_is_prev_ext := 'TRUE';
            --EXIT;
        END LOOP;
        
       RETURN v_is_prev_ext;
       
    END check_for_prev_extract;
    
     /* Description: Executes the PN_OK_EXTRACT When-Button-Pressed Trigger
     **              (1) Checks if data have been extracted previously.
     **              (2)   If TRUE - return
     **                    If FALSE - extract data          
     */ 
    PROCEDURE check_and_extract (
        p_line_cd       IN  giac_treaty_extract.line_cd%TYPE,
        p_share_cd      IN  giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_extract.proc_year%TYPE,
        p_qtr           IN  giac_treaty_extract.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_user_id       IN  giis_users.user_id%TYPE,
        p_prev_ext      OUT VARCHAR2,
        p_rec_cnt       OUT NUMBER
    ) IS
        v_prev_ext  VARCHAR2(5) := 'FALSE';
        v_rec_cnt   NUMBER(12) := 0;
    BEGIN
    
        -- Step 1: Check if data have been extracted previously
        SELECT GIACS220_PKG.check_for_prev_extract(p_line_cd, p_share_cd, p_trty_yy, p_year, p_qtr)
          INTO v_prev_ext
          FROM dual;
          
        p_prev_ext := v_prev_ext;
        
        -- Step 2: if TRUE - notify user if will proceed with extraction
        --         if FALSE - go to  extraction
        IF v_prev_ext = 'FALSE' THEN 
        
            GIACS220_PKG.pg_extract_all(p_line_cd, p_share_cd, p_trty_yy,
                                        p_year,    p_qtr,
                                        p_month1,  p_month2,   p_month3,
                                        v_rec_cnt);
                                        
            IF v_rec_cnt > 0 THEN            
                
                INSERT 
                  INTO giac_treaty_extract 
                       (line_cd,    trty_yy,    share_cd,
                        proc_year,  proc_qtr,   user_id,    last_extract)
                VALUES (p_line_cd,  p_trty_yy,  p_share_cd,
                        p_year,     p_qtr,      p_user_id,  SYSDATE);
            END IF;
                              
        END IF;
        
        p_rec_cnt := v_rec_cnt;
        
    END check_and_extract;
    
    
    PROCEDURE pg_extract_all(
        p_line_cd       IN  giac_treaty_extract.line_cd%TYPE,
        p_share_cd      IN  giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_extract.proc_year%TYPE,
        p_qtr           IN  giac_treaty_extract.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_rec_cnt       OUT NUMBER
    ) IS
        v_rec_cnt   NUMBER(12) := 0;
        v_rec_cnt2   NUMBER(12) := 0;
    BEGIN
        
        GIACS220_PKG.pg_extract_dist_share(p_line_cd,   p_share_cd,
                                           p_year,      p_qtr,
                                           p_month1,    p_month2,       p_month3,
                                           v_rec_cnt);
                                           
        
        IF v_rec_cnt > 0 THEN
        
            GIACS220_PKG.pg_extract_clm_loss(p_line_cd, p_share_cd, p_trty_yy,
                                             p_year,    p_qtr,
                                             p_month1,  p_month2,   p_month3,
                                             v_rec_cnt2);
            
        END IF;   
        
        p_rec_cnt := v_rec_cnt;                               
                     
    END pg_extract_all;
    
    PROCEDURE pg_extract_clm_loss(
        p_line_cd       IN  giac_treaty_extract.line_cd%TYPE,
        p_share_cd      IN  giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_extract.proc_year%TYPE,
        p_qtr           IN  giac_treaty_extract.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_rec_cnt       OUT NUMBER
    ) IS
        CURSOR clmrec IS
                  SELECT gc.line_cd,  
                         gler.grp_seq_no, gler.ri_cd,         
                         gc.claim_id, 
                         gled.peril_cd,
                         gcle.clm_loss_id, 
                         gled.clm_dist_no,
                         gc.line_cd||'-'|| gc.subline_cd||'-'|| gc.iss_cd||'-'|| TO_CHAR(gc.clm_yy)||'-'|| TO_CHAR(gc.clm_seq_no) claim_no,
                         gc.assd_no,
                         gc.line_cd||'-'|| gc.subline_cd||'-'|| gc.pol_iss_cd||'-'|| TO_CHAR(gc.issue_yy)||'-'|| TO_CHAR(gc.pol_seq_no)||'-'|| TO_CHAR(gc.renew_no) policy_no,
                         gcle.tran_date,
                         gcle.payee_type,
                         shr_loss_exp_ri_pct,
                         -- shr_le_ri_pd_amt,
                         -- shr_le_ri_net_amt,
                         ROUND((NVL(gleh.losses_paid,0) * (ROUND(shr_loss_exp_ri_pct/100,2))),2) losses_paid,
                         ROUND((NVL(gleh.expenses_paid,0) * (ROUND(shr_loss_exp_ri_pct/100,2))),2) expense_paid,    
                         gled.grp_seq_no share_cd
                    FROM GICL_CLAIMS  gc,
                         GICL_CLM_LOSS_EXP gcle,
                         GICL_LOSS_EXP_DS gled,
                         GICL_LOSS_EXP_RIDS gler,
                         GICL_CLM_RES_HIST  gleh,
                         GIAC_ACCTRANS gacc		 
                   WHERE gc.clm_stat_cd NOT IN ('CC','DN','WD','FN') 
                     AND gc.line_cd = p_line_cd
                     AND gc.claim_id = gcle.claim_id 
                     AND TO_NUMBER(TO_CHAR(gacc.tran_date,'YYYY')) = p_year
                     AND TO_NUMBER(TO_CHAR(gacc.tran_date,'MM')) IN (p_month1, p_month2, p_month3)
                     AND NVL(gcle.cancel_sw, 'N') <> 'Y'
                     AND gcle.tran_id IS NOT NULL
                     AND gc.claim_id = gled.claim_id
                     AND gleh.claim_id = gc.claim_id
                     AND gleh.claim_id = gcle.claim_id
                     AND gleh.item_no = gcle.item_no
                     AND gleh.peril_cd = gcle.peril_cd
                     AND gleh.tran_id = gacc.tran_id
                     AND gacc.tran_flag <> 'D'
                     AND NOT EXISTS (SELECT c.gacc_tran_id
                                       FROM giac_reversals c,
                                            giac_acctrans  d
                                      WHERE c.reversing_tran_id = d.tran_id
                                        AND d.tran_flag        <> 'D'
                                        AND c.gacc_tran_id = gleh.tran_id)
                     AND gcle.clm_loss_id = gled.clm_loss_id
                     AND gled.grp_seq_no = p_share_cd
                     AND gled.share_type = 2 -- only Treaty type
                     AND gc.claim_id = gler.claim_id
                     AND gcle.clm_loss_id = gler.clm_loss_id
                     AND gled.clm_dist_no = gler.clm_dist_no; 
                     
        v_rec_cnt       NUMBER(12) := 0;
    BEGIN 
    
          FOR cur1 IN clmrec   
          LOOP
          
            v_rec_cnt :=  v_rec_cnt + 1;
            --:nbt.status := 'Inserting Claim record: ' || TO_CHAR(variable.cntrec) || '.';
            
             IF cur1.payee_type = 'L' THEN
             
                INSERT 
                  INTO giac_treaty_claims 
                       (LINE_CD,         TRTY_YY, 	                TREATY_SEQ_NO,  
                        RI_CD,           PROC_YEAR,                 PROC_QTR,    
                        CLAIM_ID,        CLM_LOSS_ID,               CLM_DIST_NO,    
                        CLAIM_NO,        ASSD_NO,                   POLICY_NO,      
                        PAYT_DATE,       LOSS_EXP_RI_PCT,           LOSS_PAID_AMT,  
                        LOSS_EXP_AMT,    PAYEE_TYPE,                PERIL_CD, 
                        SHARE_CD)
                VALUES (cur1.LINE_CD,    p_trty_yy,                 cur1.GRP_SEQ_NO,  
                        cur1.RI_CD,      p_year,                    p_qtr,
                        cur1.CLAIM_ID,   cur1.CLM_LOSS_ID,          cur1.CLM_DIST_NO,    
                        cur1.CLAIM_NO,   cur1.ASSD_NO,              cur1.POLICY_NO,      
                        cur1.TRAN_DATE,  cur1.SHR_LOSS_EXP_RI_PCT,  /*     cur1.shr_le_ri_net_amt,*/     cur1.LOSSES_PAID,
                        0,               cur1.payee_type,           cur1.PERIL_CD,
                        cur1.share_cd);
                        
             ELSE
             
               INSERT 
                 INTO giac_treaty_claims 
                      (LINE_CD,                TRTY_YY, 	              TREATY_SEQ_NO,  
                       RI_CD,                  PROC_YEAR,                 PROC_QTR,    
                       CLAIM_ID,               CLM_LOSS_ID,               CLM_DIST_NO,    
                       CLAIM_NO,               ASSD_NO,                   POLICY_NO,      
                       PAYT_DATE,              LOSS_EXP_RI_PCT,           LOSS_PAID_AMT,  
                       LOSS_EXP_AMT,           payee_type,                PERIL_CD,
                       SHARE_CD)
               VALUES (cur1.LINE_CD,           p_trty_yy,                 cur1.GRP_SEQ_NO,  
                       cur1.RI_CD,             p_year,                    p_qtr,
                       cur1.CLAIM_ID,          cur1.CLM_LOSS_ID,          cur1.CLM_DIST_NO,    
                       cur1.CLAIM_NO,          cur1.ASSD_NO,              cur1.POLICY_NO,      
                       cur1.TRAN_DATE,         cur1.SHR_LOSS_EXP_RI_PCT,  /*    cur1.shr_le_ri_net_amt,*/         0,
                       cur1.EXPENSE_PAID,      cur1.payee_type,           cur1.PERIL_CD,
                       cur1.share_cd);  
                          
             END IF;
             
          END LOOP;
          
          p_rec_cnt := v_rec_cnt;
    
    END pg_extract_clm_loss;

    PROCEDURE pg_extract_dist_share(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_rec_cnt       OUT NUMBER
    ) IS
        CURSOR currec IS 
                 SELECT gds.line_cd, 
                        gds.share_cd, 
                        gds.trty_yy, 
                        gtc.ri_cd, 
                        gtc.cession_year, 
                        gtc.cession_mm,
                        gdtl.peril_cd,
                        --gdtl.premium_amt, --Vincent 012705: comment out
                        --gdtl.commission_amt,--Vincent 012705: comment out
                        SUM(gdtl.premium_amt) premium_amt,--Vincent 012705: added, fixes ora-00001
                        SUM(gdtl.commission_amt) commission_amt,--Vincent 012705: added, fixes ora-00001
                        gdtl.acct_ent_date,
                        gtp.trty_com_rt
                   FROM giis_trty_peril gtp,
                        giac_treaty_cession_dtl gdtl,
                        giac_treaty_cessions gtc,
                        giis_dist_share gds
                  WHERE 1=1 
                    AND gds.line_cd         = NVL(p_line_cd, gds.line_cd)
                    AND gds.share_cd        = NVL(p_share_cd, gds.share_cd)
                    AND gtc.cession_year    = p_year
                    AND gtc.cession_mm      IN (p_month1, p_month2, p_month3)
                    AND gds.share_cd        = gtc.share_cd
                    AND gds.line_cd         = gtc.line_cd
                    AND gds.trty_yy         = gtc.treaty_yy
                    AND gtc.cession_id      = gdtl.cession_id
                    AND gdtl.peril_cd       = gdtl.peril_cd
                    AND gds.line_cd         = gtp.line_cd
                    AND gds.share_cd        = gtp.trty_seq_no
                    AND gtp.peril_cd        = gdtl.peril_cd
                  GROUP BY gds.line_cd,--Vincent 012705: added group by, fixes ora-00001 
                        gds.share_cd, 
                        gds.trty_yy, 
                        gtc.ri_cd, 
                        gdtl.peril_cd,
                        gdtl.acct_ent_date,
                        gtc.cession_year, 
                        gtc.cession_mm,
                        gtp.trty_com_rt;   
                        
        v_rec_cnt       NUMBER(12) := 0; 
    BEGIN
    
        FOR cur1 IN currec
        LOOP
           
            INSERT 
              INTO giac_treaty_perils 
                   (line_cd, 
                    share_cd, 
                    trty_yy, 
                    proc_year, 
                    proc_qtr,
                    ri_cd, 
                    peril_cd, 
                    acct_ent_date, 
                    premium_amt, 
                    trty_comm_rt,
                    commission_amt)
            VALUES (cur1.line_cd,
                    cur1.share_cd,
                    cur1.trty_yy,
                    p_year,
                    p_qtr,
                    cur1.ri_cd,
                    cur1.peril_cd,
                    cur1.acct_ent_date,
                    cur1.premium_amt,
                    cur1.trty_com_rt,
                    cur1.commission_amt);
                    
            v_rec_cnt := v_rec_cnt + 1;
            
        END LOOP;
        
        p_rec_cnt := v_rec_cnt;
        
    END pg_extract_dist_share;
    
    
    /* Description: Executes the PN_OK_EXTRACT When-Button-Pressed Trigger
    **              If user decided to proceed with the extraction, even data have been extracted previously, 
    **              (1)   Delete previous extracted data
    **              (2)   Extract data          
    */ 
    PROCEDURE pg_delete_prev_extract(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_user_id       IN  giis_users.user_id%TYPE
    ) IS
    
    BEGIN
    
         DELETE 
           FROM giac_treaty_perils
          WHERE line_cd     = p_line_cd
            AND share_cd    = p_share_cd
            AND trty_yy     = p_trty_yy
            AND proc_year   = p_year
            AND proc_qtr    = p_qtr;
            
         DELETE 
           FROM giac_treaty_claims
          WHERE line_cd         = p_line_cd
            AND treaty_seq_no   = p_share_cd
            AND proc_year       = p_year
            AND proc_qtr        = p_qtr;
            
       UPDATE giac_treaty_extract
          SET user_id       = p_user_id,
              last_extract  = SYSDATE
        WHERE line_cd       = p_line_cd
          AND trty_yy       = p_trty_yy
          AND share_cd      = p_share_cd
          AND proc_year     = p_year
          AND proc_qtr      = p_qtr;
          
    END pg_delete_prev_extract;
    
    
    PROCEDURE pg_compute(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         IN  giis_reinsurer.ri_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_user_id       IN  giis_users.user_id%TYPE
    ) IS
        v_sumrec          giac_treaty_qtr_summary%ROWTYPE;
        v_clmrec          giac_treaty_claims%ROWTYPE;
        v_exist           BOOLEAN;
        
        v_line_cd         giac_treaty_qtr_summary.line_cd%TYPE;
        v_trty_yy         giac_treaty_qtr_summary.trty_yy%TYPE;
        v_share_cd        giac_treaty_qtr_summary.share_cd%TYPE;
        v_ri_cd           giac_treaty_qtr_summary.ri_cd%TYPE;
        v_proc_year       giac_treaty_qtr_summary.proc_year%TYPE;
        v_proc_qtr        giac_treaty_qtr_summary.proc_qtr%TYPE;
    BEGIN
    
        v_line_cd   := p_line_cd;
        v_trty_yy   := p_trty_yy;
        v_share_cd  := p_share_cd;
        v_ri_cd     := p_ri_cd;
        v_proc_year := p_year;
        v_proc_qtr  := p_qtr;
    
        v_exist                      := FALSE;
        v_sumrec.summary_id          := NULL;
        v_sumrec.line_cd             := NULL;
        v_sumrec.trty_yy             := NULL;
        v_sumrec.share_cd            := NULL;
        v_sumrec.ri_cd               := NULL;
        v_sumrec.proc_year           := NULL;
        v_sumrec.proc_qtr            := NULL;
        v_sumrec.premium_ceded_amt   := NULL;
        v_sumrec.commission_amt      := NULL;
        v_clmrec.loss_paid_amt       := NULL;
        v_clmrec.loss_exp_amt        := NULL;
        v_sumrec.prem_resv_retnd_amt := NULL;
        v_sumrec.prem_resv_relsd_amt := NULL;   
        
        v_sumrec.line_cd             := v_line_cd;
        v_sumrec.trty_yy             := v_trty_yy;
        v_sumrec.share_cd            := v_share_cd;
        v_sumrec.ri_cd               := v_ri_cd;
        v_sumrec.proc_year           := v_proc_year;
        v_sumrec.proc_qtr            := v_proc_qtr;     
        v_sumrec.user_id             := p_user_id;
        v_sumrec.last_update         := SYSDATE;
        
        FOR summ IN (SELECT SUM(premium_amt) premium_amt,
                            SUM(commission_amt) commission_amt
                       FROM giac_treaty_perils
                      WHERE line_cd   = v_line_cd
                        AND trty_yy   = v_trty_yy
                        AND share_cd  = v_share_cd
                        AND ri_cd     = v_ri_cd
                        AND proc_year = v_proc_year
                        AND proc_qtr  = v_proc_qtr)
        LOOP
            v_sumrec.premium_ceded_amt := summ.premium_amt;
            v_sumrec.commission_amt    := summ.commission_amt;
            EXIT;
        END LOOP;
        
        BEGIN
             SELECT SUM(NVL(loss_paid_amt, 0)), 
                    SUM(NVL(loss_exp_amt,0))
               INTO v_clmrec.loss_paid_amt,
                    v_clmrec.loss_exp_amt
               FROM giac_treaty_claims
              WHERE line_cd       = v_line_cd
                AND trty_yy       = v_trty_yy
                AND treaty_seq_no = v_share_cd
                AND ri_cd         = v_ri_cd
                AND proc_year     = v_proc_year
                AND proc_qtr      = v_proc_qtr;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;
        
        BEGIN
             SELECT (v_sumrec.premium_ceded_amt * funds_held_pct) / 100,
                    trty_shr_pct,
                    funds_held_pct,
                    int_on_prem_res,
                    whtax_rt 
               INTO v_sumrec.prem_resv_retnd_amt,
                    v_sumrec.trty_shr_pct,
                    v_sumrec.funds_held_pct,
                    v_sumrec.int_on_prem_pct,
                    v_sumrec.wht_tax_rt
               FROM giis_trty_panel
              WHERE line_cd     = v_line_cd
                AND trty_yy     = v_trty_yy
                AND trty_seq_no = v_share_cd
                AND ri_cd       = v_ri_cd;
                
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_sumrec.prem_resv_retnd_amt := 0;
        END;
        
        FOR cur1 IN (SELECT prem_resv_relsd_amt
                       FROM giac_treaty_qtr_summary
                      WHERE line_cd   = v_line_cd
                        AND trty_yy   = v_trty_yy
                        AND share_cd  = v_share_cd
                        AND ri_cd     = v_ri_cd
                        AND proc_year = v_proc_year
                        AND proc_qtr  = v_proc_qtr)
        LOOP
            v_sumrec.prem_resv_relsd_amt := NVL(cur1.prem_resv_relsd_amt,0);
            EXIT;
        END LOOP;
        
        v_sumrec.ending_bal_amt :=    NVL(v_sumrec.premium_ceded_amt,0) 
                                    - NVL(v_sumrec.commission_amt,0) 
                                    - NVL(v_clmrec.loss_paid_amt,0) 
                                    - NVL(v_clmrec.loss_exp_amt,0)
                                    - NVL(v_sumrec.prem_resv_retnd_amt,0)
                                    + NVL(v_sumrec.prem_resv_relsd_amt,0)
                                    + NVL(v_sumrec.released_int_amt,0)
                                    - NVL(v_sumrec.wht_tax_amt,0);
                                    
                                    
        BEGIN
             SELECT summary_seq.NEXTVAL
               INTO v_sumrec.summary_id
               FROM DUAL;
         
            INSERT 
              INTO giac_treaty_qtr_summary 
                   (summary_id,
                    line_cd,
                    trty_yy,
                    share_cd,
                    ri_cd,
                    proc_year,
                    proc_qtr,
                    premium_ceded_amt,
                    commission_amt,
                    clm_loss_paid_amt,
                    clm_loss_expense_amt,
                    prem_resv_retnd_amt,
                    trty_shr_pct,
                    funds_held_pct,
                    int_on_prem_pct,
                    ending_bal_amt,
                    wht_tax_rt,
                    user_id,
                    last_update)
            VALUES (v_sumrec.summary_id,
                    v_sumrec.line_cd,
                    v_sumrec.trty_yy,
                    v_sumrec.share_cd,
                    v_sumrec.ri_cd,
                    v_sumrec.proc_year,
                    v_sumrec.proc_qtr,
                    NVL(v_sumrec.premium_ceded_amt,0),
                    NVL(v_sumrec.commission_amt,0),
                    NVL(v_clmrec.loss_paid_amt,0),
                    NVL(v_clmrec.loss_exp_amt,0),
                    NVL(v_sumrec.prem_resv_retnd_amt,0),
                    NVL(v_sumrec.trty_shr_pct,0),
                    NVL(v_sumrec.funds_held_pct,0),
                    NVL(v_sumrec.int_on_prem_pct,0),
                    NVL(v_sumrec.ending_bal_amt,0),
                    NVL(v_sumrec.wht_tax_rt,0), 
                    v_sumrec.user_id,
                    v_sumrec.last_update);
                    
            GIACS220_PKG.PG_COMPUTE_CASH_ACCT(v_sumrec.summary_id,          v_sumrec.ending_bal_amt, 
                                              v_sumrec.prem_resv_retnd_amt, v_sumrec.prem_resv_relsd_amt,
                                              v_proc_qtr,                   v_proc_year);  
                                     
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               UPDATE giac_treaty_qtr_summary
                  SET premium_ceded_amt    = NVL(v_sumrec.premium_ceded_amt,0),
                      commission_amt       = NVL(v_sumrec.commission_amt,0),
                      clm_loss_paid_amt    = NVL(v_clmrec.loss_paid_amt,0),
                      clm_loss_expense_amt = NVL(v_clmrec.loss_exp_amt,0),
                      prem_resv_retnd_amt  = NVL(v_sumrec.prem_resv_retnd_amt,0),
                      trty_shr_pct         = NVL(v_sumrec.trty_shr_pct,0),
                      funds_held_pct       = NVL(v_sumrec.funds_held_pct,0),
                      int_on_prem_pct      = NVL(v_sumrec.int_on_prem_pct,0),
                      ending_bal_amt       = NVL(v_sumrec.ending_bal_amt,0),
                      released_int_amt     = NVL(prem_resv_relsd_amt * NVL(int_on_prem_pct,0) / 100,0),
                      wht_tax_rt           = NVL(v_sumrec.wht_tax_rt,0),
                      wht_tax_amt          = NVL((released_int_amt * wht_tax_rt) / 100,0),
                      user_id              = v_sumrec.user_id,
                      last_update          = v_sumrec.last_update
                WHERE line_cd   = v_line_cd
                  AND trty_yy   = v_trty_yy
                  AND share_cd  = v_share_cd
                  AND ri_cd     = v_ri_cd
                  AND proc_year = v_proc_year
                  AND proc_qtr  = v_proc_qtr;
                  
               SELECT summary_id 
                 INTO v_sumrec.summary_id
                 FROM giac_treaty_qtr_summary
                WHERE line_cd   = v_line_cd
                  AND trty_yy   = v_trty_yy
                  AND share_cd  = v_share_cd
                  AND ri_cd     = v_ri_cd
                  AND proc_year = v_proc_year
                  ANd proc_qtr  = v_proc_qtr;
                                 
               GIACS220_PKG.PG_COMPUTE_CASH_ACCT(v_sumrec.summary_id,          v_sumrec.ending_bal_amt,
                                                 v_sumrec.prem_resv_retnd_amt, v_sumrec.prem_resv_relsd_amt,
                                                 v_proc_qtr,                   v_proc_year);         
        END;         
    
    END pg_compute;
    
    
    PROCEDURE pg_compute_cash_acct(
        p_summary_id            NUMBER, 
        p_ending_bal_amt        NUMBER,
        p_prem_resv_retnd_amt   NUMBER,
        p_prem_resv_relsd_amt   NUMBER,
        p_qtr                   NUMBER,
        p_year                  NUMBER
    ) IS
        v_exists 	            BOOLEAN;
        v_as_of_date            DATE;
        v_resv_balance          giac_treaty_cash_acct.resv_balance%TYPE;
        v_prev_resv_balance     giac_treaty_cash_acct.prev_resv_balance%TYPE;
    BEGIN
    
        v_exists := FALSE;
        
        FOR cur1 IN (SELECT cash_bal_in_favor,
                            prev_balance,
                            our_remittance,
                            your_remittance,
                            cash_call_paid
                       FROM giac_treaty_cash_acct
                      WHERE summary_id = p_summary_id ) 
        LOOP
            cur1.cash_bal_in_favor :=   NVL(cur1.prev_balance,0)
                                      + NVL(p_ending_bal_amt,0)
                                      - NVL(cur1.our_remittance,0)
                                      + NVL(cur1.your_remittance,0)
                                      + NVL(cur1.cash_call_paid,0);

            UPDATE giac_treaty_cash_acct
               SET balance_as_above  = p_ending_bal_amt,
                   cash_bal_in_favor = cur1.cash_bal_in_favor,
                   resv_balance      =   NVL(prev_resv_balance,0) 
                                       + NVL(p_prem_resv_retnd_amt,0) 
                                       - NVL(p_prem_resv_relsd_amt,0),
                   user_id           = NVL(giis_users_pkg.app_user,USER),
                   last_update       = SYSDATE
             WHERE summary_id = p_summary_id;
        
            v_exists := TRUE;
            EXIT;
        END LOOP; -- end loop: cur1
        
        
        IF NOT v_exists THEN
        
            v_as_of_date        := LAST_DAY(TO_DATE(TO_CHAR(p_qtr * 3,'09')
                                    || '-01-' || TO_CHAR(p_year,'9999'),'MM-DD-YYYY'));
            v_prev_resv_balance := 0;
          
            /* Get previous reserve balance */
            FOR treaty IN (SELECT line_cd,  trty_yy,    share_cd, 
                                  ri_cd,    proc_year,  proc_qtr
                             FROM giac_treaty_qtr_summary 
                            WHERE summary_id = p_summary_id)
            LOOP
            
                BEGIN
                  SELECT b.resv_balance
                    INTO v_prev_resv_balance
                    FROM giac_treaty_qtr_summary a,
                         giac_treaty_cash_acct b
                   WHERE a.summary_id = b.summary_id
                     AND a.line_cd   = treaty.line_cd
                     AND a.trty_yy   = treaty.trty_yy
                     AND a.share_cd  = treaty.share_cd
                     AND a.ri_cd     = treaty.ri_cd
                     AND a.proc_year = treaty.proc_year - 1
                     AND a.proc_qtr  = treaty.proc_qtr;
                
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_prev_resv_balance := 0;
                END;
                
                EXIT;
            END LOOP; -- end of treaty
                
            v_resv_balance :=   NVL(v_prev_resv_balance,0) 
                              + NVL(p_prem_resv_retnd_amt,0) 
                              - NVL(p_prem_resv_relsd_amt,0);
            INSERT 
              INTO giac_treaty_cash_acct 
                   (summary_id,
                    balance_as_above,
                    cash_bal_in_favor,
                    prev_balance_dt,
                    prev_resv_bal_dt,
                    resv_balance_dt,
                    user_id,
                    last_update)
            VALUES (p_summary_id,
                    p_ending_bal_amt,
                    p_ending_bal_amt,
                    v_as_of_date,
                    v_as_of_date,
                    v_as_of_date,
                    NVL(giis_users_pkg.app_user,USER),
                    SYSDATE);
        END IF;
    
    END pg_compute_cash_acct;
    
    
    PROCEDURE pg_post(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         IN  giis_reinsurer.ri_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_exist         OUT VARCHAR2
    ) IS
        v_line_cd         giac_treaty_qtr_summary.line_cd%TYPE;
        v_trty_yy         giac_treaty_qtr_summary.trty_yy%TYPE;
        v_share_cd        giac_treaty_qtr_summary.share_cd%TYPE;
        v_ri_cd           giac_treaty_qtr_summary.ri_cd%TYPE;
        v_proc_year       giac_treaty_qtr_summary.proc_year%TYPE;
        v_proc_qtr        giac_treaty_qtr_summary.proc_qtr%TYPE;
    BEGIN
    
        v_line_cd   := p_line_cd;
        v_trty_yy   := p_trty_yy;
        v_share_cd  := p_share_cd;
        v_ri_cd     := p_ri_cd;
        v_proc_year := p_year;
        v_proc_qtr  := p_qtr;
        
        BEGIN
        
             SELECT 'X'
               INTO p_exist
               FROM giac_treaty_qtr_summary
              WHERE line_cd   = v_line_cd
                AND trty_yy   = v_trty_yy
                AND share_cd  = v_share_cd
                AND ri_cd     = v_ri_cd
                AND proc_year = v_proc_year
                AND proc_qtr  = v_proc_qtr;
                
             UPDATE giac_treaty_qtr_summary
                SET final_tag = 'Y'
              WHERE line_cd   = v_line_cd
                AND trty_yy   = v_trty_yy
                AND share_cd  = v_share_cd
                AND ri_cd     = v_ri_cd
                AND proc_year = v_proc_year
                AND proc_qtr  = v_proc_qtr;   
                       
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
               --p_exist := NULL;
               raise_application_error(-20001, 'Geniisys Exception#I#No record of Treaty Quarter Summary!');
        END;
    
    END pg_post;
    
    
    PROCEDURE check_bef_view(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         IN  giis_reinsurer.ri_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_found         OUT VARCHAR2     
    )
    IS
    BEGIN
    
       SELECT 'X' 
         INTO p_found
         FROM giac_treaty_qtr_summary
        WHERE line_cd   = p_line_cd
          AND trty_yy   = p_trty_yy
          AND share_cd  = p_share_cd
          AND ri_cd     = p_ri_cd
          AND proc_year = p_year
          AND proc_qtr  = p_qtr;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_found := NULL;
           
    END check_bef_view;
    
    FUNCTION get_peril_breakdown(
        p_line_cd             GIAC_TREATY_PERILS_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_PERILS_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_PERILS_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_PERILS_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_PERILS_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_PERILS_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED
    IS
        v_peril     summary_breakdown_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, trty_yy, share_cd, proc_year, proc_qtr,
                           peril_cd, premium_amt
                      FROM GIAC_TREATY_PERILS_V
                     WHERE line_cd = p_line_cd
                       AND share_cd = p_share_cd
                       AND trty_yy = p_trty_yy
                       AND ri_cd = p_ri_cd
                       AND proc_year = p_year
                       AND proc_qtr = p_qtr)
        LOOP
            BEGIN
              SELECT peril_name 
                INTO v_peril.peril_name
                FROM giis_peril
               WHERE line_cd  = rec.line_cd
                 AND peril_cd = rec.peril_cd;
            EXCEPTION
                 WHEN OTHERS THEN
                    v_peril.peril_name := NULL;
            END;
        
            v_peril.ri_cd       := rec.ri_cd;
            v_peril.line_cd     := rec.line_cd;
            v_peril.trty_yy     := rec.trty_yy;
            v_peril.share_cd    := rec.share_cd;
            v_peril.year        := rec.proc_year;
            v_peril.qtr         := rec.proc_qtr;
            v_peril.peril_cd    := rec.peril_cd;
            v_peril.premium_amt := rec.premium_amt;
            
            PIPE ROW(v_peril);
        END LOOP;
        
    END get_peril_breakdown;
    
    
    FUNCTION get_commission_breakdown(
        p_line_cd             GIAC_TREATY_COMM_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_COMM_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_COMM_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_COMM_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_COMM_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_COMM_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED
    IS
        v_comm     summary_breakdown_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, trty_yy, share_cd, proc_year, proc_qtr,
                           trty_comm_rt, premium_amt, commission_amt
                      FROM GIAC_TREATY_COMM_V
                     WHERE line_cd  = p_line_cd
                       AND share_cd = p_share_cd
                       AND trty_yy  = p_trty_yy
                       AND ri_cd    = p_ri_cd
                       AND proc_year = p_year
                       AND proc_qtr = p_qtr)
        LOOP
            
            v_comm.ri_cd            := rec.ri_cd;
            v_comm.line_cd          := rec.line_cd;
            v_comm.trty_yy          := rec.trty_yy;
            v_comm.share_cd         := rec.share_cd;
            v_comm.year             := rec.proc_year;
            v_comm.qtr              := rec.proc_qtr;
            v_comm.trty_comm_rt     := rec.trty_comm_rt;
            v_comm.premium_amt      := rec.premium_amt;
            v_comm.commission_amt   := rec.commission_amt;
            
            PIPE ROW(v_comm);
        END LOOP;
        
    END get_commission_breakdown;
    
    
    FUNCTION get_clm_loss_paid_breakdown(
        p_line_cd             GIAC_TREATY_COMM_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_COMM_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_COMM_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_COMM_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_COMM_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_COMM_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED
    IS
        v_clp     summary_breakdown_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, trty_yy, share_cd, proc_year, proc_qtr,
                           loss_paid_amt, treaty_seq_no, peril_cd
                      FROM GIAC_TREATY_CLAIMS_V
                     WHERE line_cd       = p_line_cd
                       AND treaty_seq_no = p_share_cd  -- changed from share_cd to treaty_seq_no
                       AND trty_yy       = p_trty_yy
                       AND ri_cd         = p_ri_cd
                       AND proc_year     = p_year
                       AND proc_qtr      = p_qtr)
        LOOP
        
            BEGIN
              SELECT peril_name 
                INTO v_clp.peril_name
                FROM giis_peril
               WHERE line_cd  = rec.line_cd
                 AND peril_cd = rec.peril_cd;
            EXCEPTION
                 WHEN OTHERS THEN
                    v_clp.peril_name := NULL;
            END;
            
            v_clp.ri_cd            := rec.ri_cd;
            v_clp.line_cd          := rec.line_cd;
            v_clp.trty_yy          := rec.trty_yy;
            v_clp.share_cd         := rec.share_cd;
            v_clp.year             := rec.proc_year;
            v_clp.qtr              := rec.proc_qtr;
            v_clp.peril_cd         := rec.peril_cd;
            v_clp.loss_paid_amt    := rec.loss_paid_amt;
            v_clp.treaty_seq_no    := rec.treaty_seq_no;
            
            PIPE ROW(v_clp);
        END LOOP;
        
    END get_clm_loss_paid_breakdown;
    
    
    FUNCTION get_clm_loss_exp_breakdown(
        p_line_cd             GIAC_TREATY_COMM_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_COMM_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_COMM_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_COMM_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_COMM_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_COMM_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED
    IS
        v_cle     summary_breakdown_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, trty_yy, share_cd, proc_year, proc_qtr,
                           loss_exp_amt, treaty_seq_no, peril_cd
                      FROM GIAC_TREATY_CLAIMS_V
                     WHERE line_cd       = p_line_cd
                       AND treaty_seq_no = p_share_cd  -- changed from share_cd to treaty_seq_no
                       AND trty_yy       = p_trty_yy
                       AND ri_cd         = p_ri_cd
                       AND proc_year     = p_year
                       AND proc_qtr      = p_qtr)
        LOOP
        
            BEGIN
              SELECT peril_name 
                INTO v_cle.peril_name
                FROM giis_peril
               WHERE line_cd  = rec.line_cd
                 AND peril_cd = rec.peril_cd;
            EXCEPTION
                 WHEN OTHERS THEN
                    v_cle.peril_name := NULL;
            END;
            
            v_cle.ri_cd            := rec.ri_cd;
            v_cle.line_cd          := rec.line_cd;
            v_cle.trty_yy          := rec.trty_yy;
            v_cle.share_cd         := rec.share_cd;
            v_cle.year             := rec.proc_year;
            v_cle.qtr              := rec.proc_qtr;
            v_cle.peril_cd         := rec.peril_cd;
            v_cle.loss_exp_amt     := rec.loss_exp_amt;
            v_cle.treaty_seq_no    := rec.treaty_seq_no;
            
            PIPE ROW(v_cle);
        END LOOP;
        
    END get_clm_loss_exp_breakdown;
    
    
    FUNCTION get_report_list_by_page(
        p_page      VARCHAR2
    ) RETURN report_tab PIPELINED
    IS
        v_report        report_type;
    BEGIN
    
        IF p_page = 'treatyStatement' THEN
        
            FOR rec IN (SELECT report_id, report_title
                          FROM giis_reports
                         WHERE report_id IN ('GIACR220','GIACR221','GIACR222','GIACR223'))
            LOOP
                v_report.report_id := rec.report_id;
                v_report.report_title := rec.report_title;
                PIPE ROW(v_report);
            END LOOP;
        
        ELSIF p_page = 'quarterlyTreatySummary' THEN
        
            FOR rec IN (SELECT report_id, report_title
                          FROM giis_reports
                         WHERE report_id IN ('GIACR221A','GIACR222A','GIACR223A'))
            LOOP
                v_report.report_id := rec.report_id;
                v_report.report_title := rec.report_title;
                PIPE ROW(v_report);
            END LOOP;
        
        END IF;
    
    END get_report_list_by_page;
    
    
END GIACS220_PKG;
/


