CREATE OR REPLACE PACKAGE BODY CPI.CSV_REPORTED_CLMS AS
   /* Modified by Edison 02.29.2012
   ** Changed PROCEDURE to FUNCTION
   ** This is changed because of PIPE syntax that can only be used in FUNCTION.
   ** Changed UTL_FILE package to PIPE function.
   */ 
   FUNCTION get_loss_amt(p_claim_id     gicl_claims.claim_id%TYPE,
                         p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                         p_loss_exp     VARCHAR2,
                         p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                         RETURN NUMBER
   IS
     v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
   BEGIN
      --considered item number for peril that exists in more than one item by MAC 11/09/2012.
      FOR item IN (  SELECT DISTINCT b.item_no
                       FROM giis_peril a, gicl_item_peril b
                      WHERE a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.claim_id = p_claim_id
                        AND b.peril_cd = p_peril_cd  ) 
      LOOP
          v_amount := v_amount + get_loss_amount_per_item_peril(p_claim_id, item.item_no, p_peril_cd, p_loss_exp, p_clm_stat_cd);
      END LOOP;
     RETURN (v_amount);
   END;
   
   /*
   ** Created by   : MAC
   ** Date Created : 11/09/2012
   ** Descriptions : Created a function that will return loss amount per payee type, item code, and peril code.
   */
   FUNCTION get_loss_amount_per_item_peril(p_claim_id     gicl_claims.claim_id%TYPE,
                                           p_item_no      gicl_loss_exp_ds.item_no%TYPE,
                                           p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                           p_loss_exp     VARCHAR2,
                                           p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                                           RETURN NUMBER
   IS
        v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_exist        VARCHAR2 (1);
   BEGIN
     IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD' THEN
        v_amount := 0;
     ELSE
        FOR i IN (SELECT DISTINCT 1
                        FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                       WHERE a.tran_id IS NOT NULL
                         AND NVL(a.cancel_tag,'N') = 'N' 
                         AND a.claim_id = p_claim_id
                         AND a.item_no = p_item_no --considered item number by MAC 11/09/2012.
                         AND a.peril_cd = p_peril_cd
                         AND DECODE(p_loss_exp,'E',expenses_paid,losses_paid) <> 0
                          --AND TRUNC(date_paid) BETWEEN p_start_dt AND p_end_dt) jen.20121025
                         AND a.claim_id = b.claim_id
                         AND a.item_no = b.item_no       
                         AND a.peril_cd = b.peril_cd
                         AND a.grouped_item_no = b.grouped_item_no
                         AND a.clm_loss_id = b.clm_loss_id)       
        LOOP
          v_exist := 'Y';
          EXIT;
        END LOOP;
        
        /*Modified by: Jen.20121029 
        ** Get the paid amt if claim has payment, else get the reserve amount.*/
        FOR p IN (SELECT SUM(DECODE (NVL (cancel_tag, 'N'),
                                     'N', DECODE (tran_id,
                                                  NULL, DECODE(p_loss_exp, 'E',NVL (convert_rate * expense_reserve, 0),
                                                               NVL (convert_rate * loss_reserve, 0)), 
                                                  DECODE(p_loss_exp, 'E',NVL (convert_rate * expenses_paid, 0),
                                                         NVL (convert_rate * losses_paid, 0))),
                                     DECODE(p_loss_exp, 'E',NVL (convert_rate * expense_reserve, 0),
                                            NVL (convert_rate * loss_reserve, 0)))) paid
                    FROM gicl_clm_res_hist
                   WHERE claim_id = p_claim_id 
                     AND item_no = p_item_no --considered item number by MAC 11/09/2012.
                     AND peril_cd = p_peril_cd 
                     AND NVL(dist_sw,'!') = DECODE (v_exist, NULL, 'Y',NVL(dist_sw,'!'))               
                     AND NVL(tran_id,-1) = DECODE (v_exist, 'Y', tran_id, -1))               
        LOOP
          v_amount :=  NVL(p.paid,0);
        END LOOP;
     END IF;
        RETURN (v_amount);
   END;
   
   /*
   ** Created by   : MAC
   ** Date Created : 10/31/2012
   ** Descriptions : Created a function that will return loss amount per share type, payee type and peril code..
   */
   FUNCTION AMOUNT_PER_SHARE_TYPE(p_claim_id     gicl_claims.claim_id%TYPE,
                                  p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                  p_share_type   gicl_loss_exp_ds.share_type%TYPE,
                                  p_loss_exp     VARCHAR2,
                                  p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                         RETURN NUMBER
   IS
       v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
   BEGIN
      --considered item number for peril that exists in more than one item.
      FOR item IN (  SELECT DISTINCT b.item_no
                       FROM giis_peril a, gicl_item_peril b
                      WHERE a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.claim_id = p_claim_id
                        AND b.peril_cd = p_peril_cd  ) 
      LOOP
         v_amount := v_amount + get_amount_per_item_peril(p_claim_id, item.item_no, p_peril_cd, p_share_type, p_loss_exp, p_clm_stat_cd);
      END LOOP;
      RETURN (v_amount);
   END;
  
   /*
   ** Created by   : MAC
   ** Date Created : 11/09/2012
   ** Descriptions : Created a function that will return loss amount per share type, payee type, item code, and peril code.
   */
   FUNCTION get_amount_per_item_peril(p_claim_id     gicl_claims.claim_id%TYPE,
                                      p_item_no      gicl_loss_exp_ds.item_no%TYPE,
                                      p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                      p_share_type   gicl_loss_exp_ds.share_type%TYPE,
                                      p_loss_exp     VARCHAR2,
                                      p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE) RETURN NUMBER
   IS
       v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
       v_exist        VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD' THEN
          v_amount := 0;
      ELSE
         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.item_no = p_item_no --considered item number
                        AND a.peril_cd = p_peril_cd
                        --added additional condition to check what particular type has payment
                        AND DECODE (p_loss_exp, 'E', a.expenses_paid, a.losses_paid) <> 0
                        AND a.claim_id = b.claim_id
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_exist := NULL;
         END;

         --get amount per type (Loss or Expense)
         IF v_exist IS NOT NULL THEN
            FOR p IN (SELECT SUM (c.convert_rate * NVL (shr_le_net_amt, 0)) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND b.claim_id = p_claim_id
                         AND b.item_no = p_item_no --considered item number
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = p_share_type
                         AND a.payee_type = DECODE (p_loss_exp, 'L', 'L', 'E') )
            LOOP
               v_amount := NVL(p.paid,0);
            END LOOP;
         ELSE
            FOR r IN (SELECT DECODE (p_loss_exp,
                                            'L', SUM (  b.convert_rate * NVL (a.shr_loss_res_amt, 0) ),
                                                 SUM (  b.convert_rate * NVL (a.shr_exp_res_amt, 0) )
                                    ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND b.item_no = p_item_no --considered item number
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = p_share_type)
            LOOP
               v_amount := NVL(r.reserve,0);
            END LOOP;
         END IF;
      END IF;
      RETURN (v_amount);
   END;
   FUNCTION CSV_GICLR540(p_line_cd   VARCHAR2,
                         p_iss_cd    VARCHAR2,
                         p_start_dt  DATE,
                         p_end_dt    DATE,
                         p_loss_exp  VARCHAR2)RETURN giclr540_type PIPELINED --Edison 02.29.2012
                       --  p_file_name VARCHAR2
   IS
     v_giclr540        giclr540_rec_type; --Edison 02.29.2012
     v_intm            VARCHAR2(300);
     v_exist2          VARCHAR2(1);
     v_loss_exp        VARCHAR2(1);
     ctr               NUMBER :=0;
   BEGIN
     FOR rec IN (SELECT a.line_cd, line_name, a.iss_cd,
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0') CLAIM_NO,
                        a.line_cd ||'-' || a.subline_cd ||'-'|| a.pol_iss_cd ||'-'||
                        LTRIM(TO_CHAR(a.issue_yy,'00')) ||'-'|| 
                        LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))  ||'-'||
                        LTRIM(TO_CHAR(a.renew_no,'00')) POLICY_NO,
                        a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                        a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                        a.assured_name, a.claim_id, a.clm_stat_cd, c.clm_stat_desc, a.old_stat_cd, close_date
                   FROM gicl_claims a,
                        giis_line b,
                        giis_clm_stat c
                  WHERE TRUNC(a.clm_file_date) BETWEEN NVL(p_start_dt, a.clm_file_date) AND NVL(p_end_dt, a.clm_file_date)
                    AND a.clm_stat_cd = c.clm_stat_cd
                    AND a.line_cd = b.line_cd
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)--Edison 05.23.2012, to filter iss_cd and line_cd allowed to user
                    AND iss_cd IN NVL(DECODE(p_iss_cd,'D',iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_iss_cd), iss_cd)
                    AND iss_cd NOT IN DECODE(p_iss_cd,'D','RI','*')
                    --AND a.line_cd = NVL(p_line_cd, decode(check_user_per_iss_cd2(a.line_cd,null,'GICLS540',user),1,a.line_cd,0,'')) 
                    --AND a.iss_cd =  NVL(p_iss_cd, decode(check_user_per_iss_cd2(null,a.iss_cd,'GICLS540',user),1,a.iss_cd,0,''))
                    --comment out above codes replace by codes below by Edison 05.23.2012
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,a.iss_cd, 'GICLS540') = 1
               ORDER BY a.line_cd,
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0'))
     LOOP
       v_exist2 := NULL;    
       v_intm   := NULL;
        
        IF rec.pol_iss_cd = 'RI' THEN
           FOR j IN (SELECT DISTINCT g.ri_name, a.ri_cd
                       FROM gicl_claims a, giis_reinsurer g
                      WHERE a.claim_id = rec.claim_id
                        AND a.ri_cd    = g.ri_cd(+))
           LOOP
             IF v_intm IS NULL THEN
                v_intm := TO_CHAR(j.ri_cd)||'/'||j.ri_name;
             ELSE
                v_intm := v_intm||','||TO_CHAR(j.ri_cd)||'/'||j.ri_name;
             END IF;
           END LOOP;
        ELSE
          FOR j IN (SELECT DISTINCT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM gicl_intm_itmperil a, giis_intermediary b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id) 
          LOOP
            IF v_intm IS NULL THEN
               v_intm := TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||'/'||j.intm_name;
            ELSE
               v_intm := v_intm||','||TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||'/'||j.intm_name;
            END IF;
          END LOOP;
        END IF;
     
                
        FOR rec2 IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                       FROM gicl_item_peril b, giis_peril c 
                      WHERE b.peril_cd = c.peril_cd
                        AND c.line_cd = rec.line_cd
                        AND b.claim_id = rec.claim_id)
        LOOP
          v_exist2   := 'Y';
          select decode(p_loss_exp,'E','E','L'), decode(p_loss_exp,'LE',2,1)
            into v_loss_exp, ctr
            from dual;
            
          FOR i IN 1..ctr
          LOOP
            v_giclr540.line_name      := rec.line_name; --replaced rec.line_cd by rec.line_name to display line name instead of line code by MAC 11/05/2012.
            v_giclr540.claim_no       := rec.claim_no;
            v_giclr540.policy_no      := rec.policy_no;
            v_giclr540.assured_name   := rec.assured_name;
            v_giclr540.intm_name      := v_intm;
            v_giclr540.pol_eff_date   := rec.pol_eff_date;
            v_giclr540.dsp_loss_date  := rec.dsp_loss_date;
            v_giclr540.clm_file_date  := rec.clm_file_date;
            v_giclr540.status         := rec.clm_stat_desc;
            v_giclr540.peril_sname    := rec2.peril_sname;
            v_giclr540.loss_amt       := get_loss_amt(rec.claim_id,rec2.peril_cd,v_loss_exp,rec.clm_stat_cd);
            v_giclr540.net_ret        := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,1,v_loss_exp,rec.clm_stat_cd),0);
            v_giclr540.trty           := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,2,v_loss_exp,rec.clm_stat_cd),0);
            v_giclr540.xol            := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,4,v_loss_exp,rec.clm_stat_cd),0);
            v_giclr540.facul          := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,3,v_loss_exp,rec.clm_stat_cd),0);
            PIPE ROW(v_giclr540);   
            
            v_loss_exp := 'E';
          END LOOP;
        END LOOP;
        
        
        IF NVL(v_exist2, 'N') = 'N' THEN
          
          --added by Edison 02.29.2012
          v_giclr540.line_name      := rec.line_name;
          v_giclr540.claim_no       := rec.claim_no;
          v_giclr540.policy_no      := rec.policy_no;
          v_giclr540.assured_name   := rec.assured_name;
          v_giclr540.intm_name      := v_intm;
          v_giclr540.pol_eff_date   := rec.pol_eff_date;
          v_giclr540.dsp_loss_date  := rec.dsp_loss_date;
          v_giclr540.clm_file_date  := rec.clm_file_date;
          v_giclr540.status         := rec.clm_stat_desc;
          v_giclr540.peril_sname    := NULL;
          v_giclr540.loss_amt       := 0;
          v_giclr540.net_ret        := 0;
          v_giclr540.trty           := 0;
          v_giclr540.xol            := 0;
          v_giclr540.facul          := 0;
          
          PIPE ROW(v_giclr540);
          --end 02.29.2012
        END IF;
           
     END LOOP;  
     RETURN; --added 02.29.2012
   END;   
   
   FUNCTION CSV_GICLR541(p_line_cd   VARCHAR2,
                          p_iss_cd    VARCHAR2,
                          p_start_dt  DATE,
                          p_end_dt    DATE,
                          p_loss_exp  VARCHAR2) RETURN giclr541_type PIPELINED--Edison 02.29.2012
                      --    p_file_name VARCHAR2
   IS
     --v_file            UTL_FILE.FILE_TYPE; --Edison 02.29.2012
     v_giclr541        giclr541_rec_type; --Edison 02.29.2012
     v_count           NUMBER(8);
     v_loss_amt        GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE;
     v_net_ret         GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_trty            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_xol             GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_facul           GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_loss_exp        VARCHAR2(1);
     ctr               NUMBER:=0;
   BEGIN
     
       
     FOR rec1 IN (SELECT DISTINCT a.line_cd, b.line_name
                   FROM gicl_claims a,
                        giis_line b
                  WHERE TRUNC(a.clm_file_date) BETWEEN NVL(p_start_dt,a.clm_file_date) AND NVL(p_end_dt,a.clm_file_date)
                    AND a.line_cd = b.line_cd
                    AND a.line_cd = NVL(p_line_cd,a.line_cd)
                    AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)--Edison 05.23.2012, to filter iss_cd and line_cd allowed to user
                    AND a.iss_cd IN NVL(DECODE(p_iss_cd,'D',a.iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_iss_cd),a.iss_cd)
                    AND a.iss_cd NOT IN DECODE(p_iss_cd,'D','RI','*')
                    --AND a.line_cd = NVL(p_line_cd, decode(check_user_per_iss_cd2(a.line_cd,null,'GICLS540',user),1,a.line_cd,0,'')) 
                    --AND a.iss_cd = NVL(p_iss_cd, decode(check_user_per_iss_cd2(null,a.iss_cd,'GICLS540',user),1,a.iss_cd,0,''))
                    --comment out above codes replace by codes below by Edison 05.23.2012
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,a.iss_cd, 'GICLS540') = 1
               ORDER BY a.line_cd)
     LOOP
       v_count := 0;
       v_loss_amt := 0;
       v_net_ret:=0;
       v_trty :=0;
       v_facul := 0;
       v_xol := 0;
       FOR rec IN (SELECT a.line_cd,
                           DECODE(a.pol_iss_cd,'RI','ASSUMED','DIRECT') ISSOURCE,
                           a.line_cd||'-'||a.subline_cd||'-'||
                           a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(a.clm_seq_no,'0000009')) CLAIM_NO,
                           a.loss_date, a.clm_file_date,
                           A.ASSD_NO, A.CLAIM_ID, A.CLM_STAT_CD
                      FROM GICL_CLAIMS A
                     WHERE TRUNC(A.CLM_FILE_DATE) BETWEEN NVL(P_START_DT,A.CLM_FILE_DATE) AND NVL(P_END_DT,A.CLM_FILE_DATE)
                       AND A.LINE_CD = NVL(P_LINE_CD,A.LINE_CD)
                       AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)--Edison 05.23.2012, to filter iss_cd and line_cd allowed to user
                       AND a.iss_cd IN NVL(DECODE(p_iss_cd,'D',a.iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_iss_cd),a.iss_cd)
                       AND a.iss_cd NOT IN DECODE(p_iss_cd,'D','RI','*')
                       --AND a.line_cd = NVL(p_line_cd, decode(check_user_per_iss_cd2(a.line_cd,null,'GICLS540',user),1,a.line_cd,0,'')) 
                       --AND a.iss_cd = NVL(p_iss_cd, decode(check_user_per_iss_cd2(null,a.iss_cd,'GICLS540',user),1,a.iss_cd,0,''))
                       --comment out above codes replace by codes below by Edison 05.23.2012
                       AND CHECK_USER_PER_ISS_CD(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540') = 1
                       AND CHECK_USER_PER_ISS_CD(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540') = 1
                       AND CHECK_USER_PER_ISS_CD(a.line_cd ,a.iss_cd, 'GICLS540') = 1
                       AND a.line_cd = rec1.line_cd
                  ORDER BY a.line_cd||'-'||a.subline_cd||'-'||
                           a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(a.clm_seq_no,'0000009')))
       LOOP
         v_count := nvl(v_count, 0) + 1;
         
         FOR rec2 IN (SELECT DISTINCT b.peril_cd,b.claim_id
                        FROM gicl_item_peril b
                       WHERE b.line_cd = rec.line_cd
                         AND b.claim_id = rec.claim_id)
         LOOP
           select decode(p_loss_exp,'E','E','L'), DECODE(p_loss_exp,'LE',2,1)
             into v_loss_exp, ctr
             from dual;
           
           FOR i IN 1..ctr
           LOOP
             v_loss_amt := v_loss_amt+get_loss_amt(rec.claim_id, rec2.peril_cd, v_loss_exp,rec.clm_stat_cd);
             v_net_ret  := v_net_ret+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 1,v_loss_exp,rec.clm_stat_cd),0);
             v_trty     := v_trty+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 2,v_loss_exp,rec.clm_stat_cd),0);
             v_xol      := v_xol+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 4,v_loss_exp,rec.clm_stat_cd),0);
             v_facul    := v_facul+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 3,v_loss_exp,rec.clm_stat_cd),0);
             v_loss_exp := 'E';
           END LOOP;
         END LOOP;                
       END LOOP;  
       --added by Edison 02.29.2012
       v_giclr541.line_name      := rec1.line_name;
       v_giclr541.cnt            := v_count;
       v_giclr541.loss_amt_line  := v_loss_amt;
       v_giclr541.net_ret_line   := v_net_ret;
       v_giclr541.trty_line      := v_trty;
       v_giclr541.xol_line       := v_xol;
       v_giclr541.facul_line     := v_facul;
          
       PIPE ROW(v_giclr541);
       --end 02.29.2012

     END LOOP;             
     RETURN;--added 02.29.2012
       --comment out 02.29.2012
     /*v_totals := 'TOTAL,'||v_total_count||','||v_total_loss_amt||','||
                 v_total_net_ret||','||v_total_trty||','||v_total_xol||','||v_total_facul;
     utl_file.put_line(v_file, v_totals);
     utl_file.fclose(v_file);*/
     --end 02.29.2012
   END; 
   
   FUNCTION CSV_GICLR544(p_line_cd   VARCHAR2,
                          p_iss_cd    VARCHAR2,
                          p_start_dt  DATE,
                          p_end_dt    DATE,
                          p_loss_exp  VARCHAR2) RETURN giclr544_type PIPELINED--Edison 02.29.2012
                      --    p_file_name VARCHAR2
   IS
     v_giclr544        giclr544_rec_type;--Edison 02.29.2012
     v_intm            VARCHAR2(300);
     v_exist2          VARCHAR2(1);
     ctr               NUMBER := 0;
     v_loss_exp        VARCHAR2(1);
   BEGIN
     /*Modified by: Jen.20121029
     ** Include line name, branch name, and claim status in the query and 
     **  removed the separate for loop that retrieves the values of the said columns .*/
     FOR rec IN (SELECT a.line_cd, b.line_name, c.iss_name,
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0') CLAIM_NO,
                        a.line_cd ||'-' || a.subline_cd ||'-'|| a.pol_iss_cd ||'-'||
                        LTRIM(TO_CHAR(a.issue_yy,'00')) ||'-'|| 
                        LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))  ||'-'||
                        LTRIM(TO_CHAR(a.renew_no,'00')) POLICY_NO,
                        a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                        a.pol_iss_cd,a.assured_name, a.claim_id, clm_stat_desc, a.clm_stat_cd
                   FROM gicl_claims a,
                        giis_line b,
                        giis_issource c,
                        giis_clm_stat d
                  WHERE TRUNC(a.clm_file_date) BETWEEN NVL(p_start_dt, a.clm_file_date) AND NVL(p_end_dt, a.clm_file_date)
                    and a.clm_stat_cd = d.clm_stat_cd
                    and a.iss_cd = c.iss_cd
                    and a.line_cd = b.line_cd
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)--Edison 05.23.2012, to filter iss_cd and line_cd allowed to user
                    AND a.iss_cd IN NVL(DECODE(p_iss_cd,'D',a.iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_iss_cd), a.iss_cd)
                    AND a.iss_cd NOT IN DECODE(p_iss_cd,'D','RI','*')
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,a.iss_cd, 'GICLS540') = 1
                  ORDER BY a.iss_cd,
                        a.line_cd,
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0'))
     LOOP
        v_exist2 := NULL;    
        v_intm   := NULL;
        
        
        IF rec.pol_iss_cd = 'RI' THEN
           FOR j IN (SELECT DISTINCT g.ri_name, a.ri_cd
                       FROM gicl_claims a, giis_reinsurer g
                      WHERE a.claim_id = rec.claim_id
                        AND a.ri_cd    = g.ri_cd(+))
           LOOP
             IF v_intm IS NULL THEN
                v_intm := TO_CHAR(j.ri_cd)||'/'||j.ri_name;
             ELSE
                v_intm := v_intm||','||TO_CHAR(j.ri_cd)||'/'||j.ri_name;
             END IF;
           END LOOP;
        ELSE
          FOR j IN (SELECT DISTINCT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM gicl_intm_itmperil a, giis_intermediary b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id) 
          LOOP
            IF v_intm IS NULL THEN
               v_intm := TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||'/'||j.intm_name;
            ELSE
               v_intm := v_intm||','||TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||'/'||j.intm_name;
            END IF;
          END LOOP;
        END IF;
     
        FOR rec2 IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                       FROM gicl_item_peril b, giis_peril c 
                      WHERE b.peril_cd = c.peril_cd
                        AND c.line_cd = rec.line_cd
                        AND b.claim_id = rec.claim_id)
        LOOP
          v_exist2   := 'Y';
          SELECT decode(p_loss_exp,'E','E','L'),decode(p_loss_exp,'LE',2,1)
            INTO v_loss_exp, ctr
            FROM dual;
            
            
          FOR i IN 1..ctr
          LOOP
            --added by Edison 02.29.2012
            v_giclr544.branch         := rec.iss_name;
            v_giclr544.line_name      := rec.line_name;
            v_giclr544.claim_no       := rec.claim_no;
            v_giclr544.policy_no      := rec.policy_no;
            v_giclr544.assured_name   := rec.assured_name;
            v_giclr544.intm           := v_intm;
            v_giclr544.pol_eff_date   := rec.pol_eff_date;
            v_giclr544.dsp_loss_date  := rec.dsp_loss_date;
            v_giclr544.clm_file_date  := rec.clm_file_date;
            v_giclr544.status         := rec.clm_stat_desc;
            v_giclr544.peril_sname    := rec2.peril_sname;
            v_giclr544.payee_type     := v_loss_exp;
            v_giclr544.loss_amt       := get_loss_amt(rec.claim_id, rec2.peril_cd,v_giclr544.payee_type,rec.clm_stat_cd);
            v_giclr544.net_ret        := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,1,v_giclr544.payee_type,rec.clm_stat_cd),0);
            v_giclr544.trty           := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,2,v_giclr544.payee_type,rec.clm_stat_cd),0);
            v_giclr544.xol            := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,4,v_giclr544.payee_type,rec.clm_stat_cd),0);
            v_giclr544.facul          := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,3,v_giclr544.payee_type,rec.clm_stat_cd),0);
             
            PIPE ROW(v_giclr544);
          
          v_loss_exp := 'E';
          END LOOP;
        END LOOP;
        
        IF NVL(v_exist2, 'N') = 'N' THEN
   
          v_giclr544.branch         := rec.iss_name;
          v_giclr544.line_name      := rec.line_name;
          v_giclr544.claim_no       := rec.claim_no;
          v_giclr544.policy_no      := rec.policy_no;
          v_giclr544.assured_name   := rec.assured_name;
          v_giclr544.intm           := v_intm;
          v_giclr544.pol_eff_date   := rec.pol_eff_date;
          v_giclr544.dsp_loss_date  := rec.dsp_loss_date;
          v_giclr544.clm_file_date  := rec.clm_file_date;
          v_giclr544.status         := rec.clm_stat_desc;
          v_giclr544.peril_sname    := null;
          v_giclr544.loss_amt       := 0;
          v_giclr544.net_ret        := 0;
          v_giclr544.trty           := 0;
          v_giclr544.xol            := 0;
          v_giclr544.facul          := 0;
          v_giclr544.payee_type     := null;
          PIPE ROW(v_giclr544);
          --end 02.29.2012
        END IF;
           
     END LOOP;   
     RETURN;--added 02.29.2012
     --comment out 02.29.2012       
     /*v_totals := ',,,,,,,,,,TOTALS,'||v_total_loss_amt||','||v_total_net_ret||','||v_total_trty||
                 ','||v_total_xol||','||v_total_facul;
     utl_file.put_line(v_file, v_totals);
     utl_file.fclose(v_file);*/
     --end 02.29.2012
   END;   
   
   
  FUNCTION CSV_GICLR544B(p_line_cd   VARCHAR2,
                          p_iss_cd    VARCHAR2,
                          p_start_dt  DATE,
                          p_end_dt    DATE,
                          p_loss_exp  VARCHAR2) RETURN giclr544b_type PIPELINED --Edison 02.29.2012
                      --    p_file_name VARCHAR2
   IS
     --v_file            UTL_FILE.FILE_TYPE; --Edison 02.29.2012
     v_giclr544b       giclr544b_rec_type;--Edison 02.29.2012
     v_count           NUMBER(8);
     v_loss_amt        GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE;
     v_net_ret         GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_trty            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_xol             GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_facul           GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     
     v_loss_exp        VARCHAR2(1);
     ctr               number:=0;
   BEGIN
     FOR rec1 IN (SELECT DISTINCT a.iss_cd, b.iss_name
                   FROM gicl_claims a,
                        giis_issource b
                  WHERE TRUNC(a.clm_file_date) BETWEEN NVL(p_start_dt,a.clm_file_date) AND NVL(p_end_dt,a.clm_file_date)
                    and a.iss_cd = b.iss_cd
                    AND a.iss_cd = NVL(p_iss_cd,a.iss_cd)
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)--Edison 05.23.2012, to filter iss_cd and line_cd allowed to use
                    AND a.iss_cd IN NVL(DECODE(p_iss_cd,'D',a.iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_iss_cd),a.iss_cd)
                    AND a.iss_cd NOT IN DECODE(p_iss_cd,'D','RI','*')
                    --AND a.line_cd = NVL(p_line_cd, decode(check_user_per_iss_cd2(a.line_cd,null,'GICLS540',user),1,a.line_cd,0,'')) 
                    --AND a.iss_cd = NVL(p_iss_cd, decode(check_user_per_iss_cd2(null,a.iss_cd,'GICLS540',user),1,a.iss_cd,0,''))
                    --comment out above codes replace by codes below by Edison 05.23.2012
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540') = 1
                    AND CHECK_USER_PER_ISS_CD(a.line_cd ,a.iss_cd, 'GICLS540') = 1
               ORDER BY a.iss_cd)
     LOOP
       v_count := 0;
       v_loss_amt := 0;
       v_net_ret := 0;
       v_trty := 0;
       v_xol := 0;
       v_facul := 0;
       
       FOR rec IN (SELECT a.line_cd,
                          A.CLAIM_ID, A.CLM_STAT_CD
                      FROM GICL_CLAIMS A
                     WHERE TRUNC(A.CLM_FILE_DATE) BETWEEN NVL(P_START_DT,A.CLM_FILE_DATE) AND NVL(P_END_DT,A.CLM_FILE_DATE)
                       AND A.LINE_CD = NVL(P_LINE_CD,A.LINE_CD)
                       AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)--Edison 05.23.2012, to filter iss_cd and line_cd allowed to user
                       AND a.iss_cd IN NVL(DECODE(p_iss_cd,'D',a.iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_iss_cd),a.iss_cd)
                       AND a.iss_cd NOT IN DECODE(p_iss_cd,'D','RI','*')
                       --AND a.line_cd = NVL(p_line_cd, decode(check_user_per_iss_cd2(a.line_cd,null,'GICLS540',user),1,a.line_cd,0,'')) 
                       --AND a.iss_cd = NVL(p_iss_cd, decode(check_user_per_iss_cd2(null,a.iss_cd,'GICLS540',user),1,a.iss_cd,0,''))
                       --comment out above codes replace by codes below by Edison 05.23.2012
                       AND CHECK_USER_PER_ISS_CD(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540') = 1
                       AND CHECK_USER_PER_ISS_CD(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540') = 1
                       AND CHECK_USER_PER_ISS_CD(a.line_cd ,a.iss_cd, 'GICLS540') = 1
                       AND a.iss_cd = rec1.iss_cd
                  ORDER BY a.line_cd||'-'||a.subline_cd||'-'||
                           a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(a.clm_seq_no,'0000009')))
       LOOP
         v_count := nvl(v_count, 0) + 1;
         
         FOR rec2 IN (SELECT DISTINCT b.peril_cd,  b.claim_id, b.line_cd
                        FROM gicl_item_peril b
                       WHERE b.line_cd = rec.line_cd
                         AND b.claim_id = rec.claim_id)
         LOOP
           SELECT decode(p_loss_exp,'E','E','L'), decode(p_loss_exp,'LE',2,1)
             INTO v_loss_exp, ctr
             FROM DUAL;
             
           FOR i IN 1..ctr
           LOOP
             v_loss_amt := v_loss_amt+get_loss_amt(rec.claim_id, rec2.peril_cd, v_loss_exp,rec.clm_stat_cd);
             v_net_ret  := v_net_ret+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 1,v_loss_exp,rec.clm_stat_cd),0);
             v_trty     := v_trty+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 2,v_loss_exp,rec.clm_stat_cd),0);
             v_xol      := v_xol+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 4,v_loss_exp,rec.clm_stat_cd),0);
             v_facul    := v_facul+nvl(amount_per_share_type(rec.claim_id, rec2.peril_cd, 3,v_loss_exp,rec.clm_stat_cd),0);
             v_loss_exp := 'E';
           END LOOP;
         END LOOP;                
       END LOOP;  
       
       --added by Edison 02.29.2012
       v_giclr544b.branch           := rec1.iss_name;
       v_giclr544b.cnt              := v_count;
       v_giclr544b.loss_amt_line    := v_loss_amt;
       v_giclr544b.net_ret_line     := v_net_ret;
       v_giclr544b.trty_line        := v_trty;
       v_giclr544b.xol_line         := v_xol;
       v_giclr544b.facul_line       := v_facul;
       
       PIPE ROW(v_giclr544b);
       --end 02.29.2012
       
     END LOOP;             
     RETURN;--added 02.29.2012
     
   END;
   
   FUNCTION CSV_GICLR543(p_intm_no   NUMBER,
                          p_start_dt  DATE,
                          p_end_dt    DATE,
                          p_loss_exp  VARCHAR2) RETURN giclr543_type PIPELINED --Edison 02.29.2012
                       --   p_file_name VARCHAR2
   IS
     --v_file            UTL_FILE.FILE_TYPE; --Edison 02.29.2012
     v_giclr543        giclr543_rec_type; --Edison 02.29.2012
     v_columns         VARCHAR2(32767);
     v_totals          VARCHAR2(32767);
     v_headers         VARCHAR2(32767);
     v_loss_type       VARCHAR2(20);
     v_intm_type       VARCHAR2(50);
     v_intm_name       VARCHAR2(100);
     v_subagent_name   VARCHAR2(100);
     v_status          VARCHAR2(100); --Edison 02.29.2012 to avoid ORA-06502
     v_exist           VARCHAR2(1);
     v_exist2          VARCHAR2(1);
     v_loss_amt        GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE;
     v_net_ret         GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_trty            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_xol             GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_facul           GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_total_loss_amt  GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE;
     v_total_net_ret   GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_total_trty      GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_total_xol       GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     v_total_facul     GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE;
     
     v_loss_exp        VARCHAR2(1);
     ctr               NUMBER:=0;
   BEGIN
     FOR rec IN (SELECT NVL(b.parent_intm_no, b.intrmdry_intm_no) intm_no, 
                        DECODE(b.parent_intm_no, null, null, b.intrmdry_intm_no) subagent,
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'|| 
                        LTRIM (TO_CHAR (a.clm_yy, '09'))||'-'||
                        LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) "CLAIM_NO",
                        a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||
                        LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||
                        LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'|| 
                        LTRIM (TO_CHAR (a.renew_no, '09')) "POLICY_NO",
                        a.dsp_loss_date, 
                        a.clm_file_date, 
                        a.pol_eff_date, 
                        a.assd_no,
                        a.assured_name,
                        a.claim_id, 
                        a.clm_stat_cd,
                        a.line_cd
                   FROM gicl_claims a, 
                        gicl_basic_intm_v1 b
                  WHERE a.claim_id = b.claim_id
                    AND TRUNC (a.clm_file_date) BETWEEN NVL (p_start_dt, a.clm_file_date) AND NVL (p_end_dt, a.clm_file_date)
                    AND (b.intrmdry_intm_no = NVL(p_intm_no, b.intrmdry_intm_no)
                         OR b.parent_intm_no = NVL(p_intm_no, b.parent_intm_no))
                    --added condition by Edison 05.22.2012, to filter the records to print by the user based on its
                    AND CHECK_USER_PER_ISS_CD(a.line_cd, a.iss_cd, 'GICLS540') = 1 --Branch and Line Code maintained in security
                  ORDER BY NVL(b.parent_intm_no, b.intrmdry_intm_no),
                         DECODE(b.parent_intm_no, null, 0, b.intrmdry_intm_no),
                         a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                         LTRIM (TO_CHAR (a.clm_yy, '09'))||'-'||
                         LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
     LOOP
        v_exist2 := NULL;    
         
        FOR i IN (SELECT a.intm_desc, a.intm_type, b.intm_name
                    FROM giis_intm_type a, giis_intermediary b 
                   WHERE a.intm_type = b.intm_type
                     AND b.intm_no =  rec.intm_no)
        LOOP
          v_intm_type := i.intm_type||'-'||i.intm_desc;
          v_intm_name := rec.intm_no||'-'||i.intm_name;
        END LOOP;
        
        FOR i IN (SELECT intm_name
                    FROM giis_intermediary
                   WHERE intm_no = rec.subagent)
        LOOP
          v_subagent_name := rec.subagent||'-'||i.intm_name;
        END LOOP;
        
        FOR i IN (SELECT clm_stat_desc
                    FROM giis_clm_stat
                   WHERE clm_stat_cd = rec.clm_stat_cd)
        LOOP
          v_status := i.clm_stat_desc;
        END LOOP;
        
        
        FOR rec2 IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                       FROM gicl_item_peril b, giis_peril c 
                      WHERE b.peril_cd = c.peril_cd
                        AND c.line_cd = rec.line_cd
                        AND b.claim_id = rec.claim_id)
        LOOP
          v_exist2   := 'Y';
          v_loss_amt := 0;
          v_net_ret  := 0;
          v_trty     := 0;
          v_xol      := 0;
          v_facul    := 0;
             
          SELECT DECODE(p_loss_exp,'E','E','L'), DECODE(p_loss_exp,'LE',2,1)
            INTO v_loss_exp, ctr
            FROM DUAL;
          
          FOR i IN 1..ctr
          LOOP 
            --added by Edison 02.29.2012
            v_giclr543.intm_type      := v_intm_type;
            v_giclr543.intm_name      := v_intm_name;
            v_giclr543.subagent_name  := v_subagent_name;
            v_giclr543.claim_no       := rec.claim_no;
            v_giclr543.policy_no      := rec.policy_no;
            v_giclr543.assured_name   := rec.assured_name;
            v_giclr543.pol_eff_date   := rec.pol_eff_date;
            v_giclr543.dsp_loss_date  := rec.dsp_loss_date;
            v_giclr543.clm_file_date  := rec.clm_file_date;
            v_giclr543.status         := v_status;
            v_giclr543.peril_sname    := rec2.peril_sname;
            v_giclr543.loss_amt       := get_loss_amt(rec.claim_id,rec2.peril_cd,v_loss_exp,rec.clm_stat_cd);
            v_giclr543.net_ret        := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,1,v_loss_exp,rec.clm_stat_cd),0);
            v_giclr543.trty           := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,2,v_loss_exp,rec.clm_stat_cd),0);
            v_giclr543.xol            := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,4,v_loss_exp,rec.clm_stat_cd),0);
            v_giclr543.facul          := nvl(amount_per_share_type(rec.claim_id,rec2.peril_cd,3,v_loss_exp,rec.clm_stat_cd),0);
              
            PIPE ROW(v_giclr543);
            v_loss_exp := 'E';
          END LOOP;
        END LOOP;
        
        IF NVL(v_exist2, 'N') = 'N' THEN
            --comment out Edison 02.29.2012
           /*v_columns := '"'||v_intm_type||'","'||v_intm_name||'","'||v_subagent_name||'","'||rec.claim_no||'","'||rec.policy_no||'","'
                        ||rec.assured_name||'",'||rec.pol_eff_date||','||rec.dsp_loss_date||','||rec.clm_file_date||',"'||v_status||'"';
           utl_file.put_line(v_file, v_columns);*/
          
          --added by Edison 02.29.2012 
          v_giclr543.intm_type      := v_intm_type;
          v_giclr543.intm_name      := v_intm_name;
          v_giclr543.subagent_name  := v_subagent_name;
          v_giclr543.claim_no       := rec.claim_no;
          v_giclr543.policy_no      := rec.policy_no;
          v_giclr543.assured_name   := rec.assured_name;
          v_giclr543.pol_eff_date   := rec.pol_eff_date;
          v_giclr543.dsp_loss_date  := rec.dsp_loss_date;
          v_giclr543.clm_file_date  := rec.clm_file_date;
          v_giclr543.status         := v_status;
          v_giclr543.peril_sname    := NULL;
          v_giclr543.loss_amt       := 0;
          v_giclr543.net_ret        := 0;
          v_giclr543.trty           := 0;
          v_giclr543.xol            := 0;
          v_giclr543.facul          := 0;
          
          PIPE ROW(v_giclr543);
          --end 02.29.2012
        END IF;
           
     END LOOP;             
     RETURN; --added 02.29.2012
     --comment out 02.29.2012
     /*v_totals := ',,,,,,,,,,TOTALS,'||v_total_loss_amt||','||v_total_net_ret||','||v_total_trty||
                 ','||v_total_xol||','||v_total_facul;
     utl_file.put_line(v_file, v_totals);
     utl_file.fclose(v_file);*/
     --end 02.29.2012
   END; 
   
   FUNCTION csv_giclr542b (
      p_assd_no   NUMBER, 
      p_assured   VARCHAR2, 
      p_end_dt    VARCHAR2, 
      p_iss_cd    VARCHAR2, 
      p_line_cd   VARCHAR2, 
      p_loss_exp  VARCHAR2, 
      p_start_dt  VARCHAR2, 
      p_user_id   VARCHAR2
   )
      RETURN giclr542b_type PIPELINED
   IS
      v_giclr542   giclr542b_rec_type;
   BEGIN
      FOR i IN (SELECT   cf_assured assured, COUNT (DISTINCT claim_id) cnt, SUM (loss_amt) loss_amt, SUM (RETENTION) net_ret, SUM (treaty) trty, SUM (xol) xol, SUM (facultative) facul
                       FROM TABLE (giclr542b_pkg.get_giclr_542b_report (p_assd_no, p_assured, p_end_dt, p_iss_cd, p_line_cd, p_loss_exp, p_start_dt, p_user_id))
                   GROUP BY cf_assured
                   ORDER BY cf_assured)
      LOOP
         v_giclr542.assured   := i.assured;
         v_giclr542.cnt       := i.cnt;
         v_giclr542.loss_amt  := i.loss_amt;
         v_giclr542.net_ret   := i.net_ret;
         v_giclr542.trty      := i.trty;
         v_giclr542.xol       := i.xol;
         v_giclr542.facul     := i.facul;
         PIPE ROW(v_giclr542);
      END LOOP;
   END;
   
   FUNCTION csv_giclr542 (
      p_assd_no   NUMBER, 
      p_assured   VARCHAR2,
      p_branch_cd  VARCHAR2, 
      p_end_dt    VARCHAR2,
      p_iss_cd    VARCHAR2, 
      p_line_cd   VARCHAR2, 
      p_loss_exp  VARCHAR2,
      p_start_dt  VARCHAR2, 
      p_user_id   VARCHAR2
    )
      RETURN giclr542_type PIPELINED
   IS
      v_giclr542   giclr542_rec_type;
   BEGIN
   
    
    
      FOR i IN (SELECT   cf_assured, claim_no, policy_no, cf_intm, eff_date, loss_date, file_date, cf_clm_stat, line_cd, claim_id, clm_stat_cd
                    FROM TABLE (giclr542_pkg.get_giclr_542_report (p_assd_no, p_assured, p_branch_cd, p_end_dt, p_iss_cd, p_line_cd, p_loss_exp, p_start_dt, p_user_id))
                ORDER BY cf_assured)
      LOOP
         v_giclr542.assured   := i.cf_assured;
         v_giclr542.claim_no  := i.claim_no;
         v_giclr542.policy_no := i.policy_no;
         v_giclr542.cf_intm   := i.cf_intm;
         v_giclr542.eff_date  := i.eff_date;
         v_giclr542.loss_date := i.loss_date;
         v_giclr542.file_date := i.file_date;
         v_giclr542.status    := i.cf_clm_stat;
         
         if p_loss_exp IN ('L', 'E')
         THEN
            FOR j IN (SELECT peril_sname, (decode(p_loss_exp, 'L', loss_amt, exp_amt)) loss_amt, (decode(p_loss_exp, 'L', RETENTION, exp_retention)) net_ret,
                             (decode(p_loss_exp, 'L', treaty, exp_treaty)) trty, (decode(p_loss_exp, 'L', xol, exp_xol)) xol,
                             (decode(p_loss_exp, 'L', facultative, exp_facultative)) facul   
                       FROM TABLE (giclr542_pkg.get_giclr_542_dtls (i.line_cd, i.claim_id, p_loss_exp, i.clm_stat_cd)))
            LOOP
               v_giclr542.peril_sname  :=  j.peril_sname;
               v_giclr542.claim_amt    :=  j.loss_amt;
               v_giclr542.net_ret      :=  j.net_ret;
               v_giclr542.trty         :=  j.trty;
               v_giclr542.xol          :=  j.xol;
               v_giclr542.facul        :=  j.facul;
               v_giclr542.payee_type   :=  p_loss_exp;
               PIPE ROW (v_giclr542);
            END LOOP;
         ELSE
            FOR j IN (SELECT peril_sname, loss_amt loss_amt, RETENTION net_ret, treaty trty, xol xol, facultative facul, 'L' v_payee_type
                       FROM TABLE (giclr542_pkg.get_giclr_542_dtls (i.line_cd, i.claim_id, 'L', i.clm_stat_cd))
                     UNION ALL
                     SELECT peril_sname, exp_amt loss_amt, exp_retention net_ret, exp_treaty trty, exp_xol xol, exp_facultative facul, 'E' v_payee_type
                       FROM TABLE (giclr542_pkg.get_giclr_542_dtls (i.line_cd, i.claim_id, 'E', i.clm_stat_cd)))
            LOOP
               v_giclr542.peril_sname  :=  j.peril_sname;
               v_giclr542.claim_amt    :=  j.loss_amt;
               v_giclr542.net_ret      :=  j.net_ret;
               v_giclr542.trty         :=  j.trty;
               v_giclr542.xol          :=  j.xol;
               v_giclr542.facul        :=  j.facul;
               v_giclr542.payee_type   :=  j.v_payee_type;
               PIPE ROW (v_giclr542);
            END LOOP;
         end if;   
      END LOOP;
   END;
END;
/
