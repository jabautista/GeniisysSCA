DROP PROCEDURE CPI.DISTRIBUTE_BY_RESERVE;

CREATE OR REPLACE PROCEDURE CPI.DISTRIBUTE_BY_RESERVE 
 (v1_claim_id         IN      GICL_CLM_RES_HIST.claim_id%TYPE,
  v1_clm_loss_id      IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,                           
  v1_item_no          IN      GICL_CLM_RES_HIST.item_no%TYPE,
  v1_peril_cd         IN      GICL_CLM_RES_HIST.peril_cd%TYPE,
  v1_grouped_item_no  IN OUT  GICL_CLM_RES_HIST.grouped_item_no%TYPE,
  p_claim_id          IN     GICL_CLAIMS.claim_id%TYPE,
  p_pol_eff_date      IN     GICL_CLAIMS.pol_eff_date%TYPE,
  p_expiry_date       IN     GICL_CLAIMS.expiry_date%TYPE,
  p_loss_date         IN     GICL_CLAIMS.loss_date%TYPE,
  p_line_cd           IN     GICL_CLAIMS.line_cd%TYPE,
  p_subline_cd        IN     GICL_CLAIMS.subline_cd%TYPE,
  p_pol_iss_cd        IN     GICL_CLAIMS.pol_iss_cd%TYPE,
  p_issue_yy          IN     GICL_CLAIMS.issue_yy%TYPE,
  p_pol_seq_no        IN     GICL_CLAIMS.pol_seq_no%TYPE,
  p_renew_no          IN     GICL_CLAIMS.renew_no%TYPE,
  p_nbt_dist_date     IN     GICL_CLAIMS.expiry_date%TYPE,
  p_payee_cd          IN     GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
  p_clm_dist_no       IN OUT GICL_LOSS_EXP_DS.clm_dist_no%TYPE) IS

 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.27.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes DISTRIBUTE_BY_RESERVE Program unit in GICLS030
 **                  
 */
 
  --Cursor for item/peril loss amount
  CURSOR cur_clm_res IS
    SELECT claim_id, hist_seq_no, item_no, peril_cd, 
           paid_amt, net_amt, advise_amt,
           grouped_item_no 
      FROM GICL_CLM_LOSS_EXP
     WHERE claim_id    = v1_claim_id
       AND clm_loss_id = v1_clm_loss_id;
  
  --Cursor for peril distribution in underwriting table.
  CURSOR cur_perilds(v_peril_cd  giri_ri_dist_item_v.peril_cd%TYPE,
                     v_item_no   giri_ri_dist_item_v.item_no%TYPE) IS
    SELECT d.share_cd,    f.share_type,     f.trty_yy,
           f.prtfolio_sw, f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi, 
           f.eff_date, f.expiry_date
      FROM GIPI_POLBASIC a,        GIPI_ITEM b,       GIUW_POL_DIST c,
           GIUW_ITEMPERILDS_DTL d, GIIS_DIST_SHARE f, GIIS_PARAMETERS e
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
           DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_pol_eff_date, a.eff_date ), c.eff_date)) 
           <= TRUNC(p_loss_date)
       AND TRUNC(DECODE(TRUNC(c.expiry_date), TRUNC(a.expiry_date), DECODE(NVL(a.endt_expiry_date, a.expiry_date),
           a.expiry_date, p_expiry_date, a.endt_expiry_date), c.expiry_date))  
           >= TRUNC(p_loss_date)
       AND b.policy_id  = a.policy_id
       AND a.line_cd    = p_line_cd
       AND a.subline_cd = p_subline_cd
       AND a.iss_cd     = p_pol_iss_cd
       AND a.issue_yy   = p_issue_yy
       AND a.pol_seq_no = p_pol_seq_no
       AND a.renew_no   = p_renew_no
       AND a.pol_flag   IN ('1','2','3','4','X')    --kenneth SR 4855 100715
  GROUP BY d.share_cd,       f.share_type,  f.trty_yy,
           f.acct_trty_type, f.prtfolio_sw, f.eff_date, f.expiry_date
  ORDER BY f.share_type DESC;
  
  --Cursor for peril distribution in treaty table.
   CURSOR cur_trty(v_share_cd  GIIS_DIST_SHARE.share_cd%TYPE,
                   v_trty_yy   GIIS_DIST_SHARE.trty_yy%TYPE) IS
   
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM GIIS_TRTY_PANEL
    WHERE line_cd     = p_line_cd
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;

  --Cursor for peril distribution in ri table.
  
   CURSOR cur_frperil(v_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
                      v_item_no    giri_ri_dist_item_v.item_no%TYPE)is
   SELECT t2.ri_cd,
          SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt 
     FROM GIPI_POLBASIC    t5, GIPI_ITMPERIL    t8, GIUW_POL_DIST    t4,
          GIUW_ITEMPERILDS t6, GIRI_DISTFRPS    t3, GIRI_FRPS_RI     t2       
    WHERE 1=1
      AND t5.line_cd      = p_line_cd
      AND t5.subline_cd   = p_subline_cd
      AND t5.iss_cd       = p_pol_iss_cd
      AND t5.issue_yy     = p_issue_yy
      AND t5.pol_seq_no   = p_pol_seq_no
      AND t5.renew_no     = p_renew_no
      AND t5.pol_flag    IN ('1','2','3','4','X')   --kenneth SR 4855 100715
      AND t5.policy_id    = t8.policy_id
      AND t8.peril_cd     = v_peril_cd
      AND t8.item_no      = v_item_no
      AND t5.policy_id    = t4.policy_id   
      AND TRUNC(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
          DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), p_pol_eff_date, t5.eff_date ), t4.eff_date)) 
          <= TRUNC(p_loss_date)
      AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t5.expiry_date),
          DECODE(NVL(t5.endt_expiry_date, t5.expiry_date),
          t5.expiry_date, p_expiry_date, t5.endt_expiry_date), t4.expiry_date))
          >= TRUNC(p_loss_date)
      AND t4.dist_flag    = '3'
      AND t4.dist_no      = t6.dist_no
      AND t8.item_no      = t6.item_no
      AND t8.peril_cd     = t6.peril_cd
      AND t4.dist_no      = t3.dist_no
      AND t6.dist_seq_no  = t3.dist_seq_no
      AND t3.line_cd      = t2.line_cd
      AND t3.frps_yy      = t2.frps_yy
      AND t3.frps_seq_no  = t2.frps_seq_no
      AND NVL(t2.reverse_sw, 'N') = 'N'
      AND NVL(t2.delete_sw, 'N')  = 'N'
      AND t3.ri_flag              = '2'   
     GROUP BY  t2.ri_cd;

  sum_tsi_amt           giri_basic_info_item_sum_v.tsi_amt%TYPE;
  ann_ri_pct            NUMBER(12,9);
  ann_dist_spct         GICL_LOSS_EXP_DS.shr_loss_exp_pct%TYPE := 0;
  me                    NUMBER := 0;
  v_facul_share_cd      GIUW_PERILDS_DTL.share_cd%TYPE;
  v_trty_share_type     GIIS_DIST_SHARE.share_type%TYPE;
  v_facul_share_type    GIIS_DIST_SHARE.share_type%TYPE;
  v_paid_amt            GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  v_advise_amt          GICL_LOSS_EXP_DS.shr_le_adv_amt%TYPE;
  v_net_amt             GICL_LOSS_EXP_DS.shr_le_net_amt%TYPE;
  v_trty_limit          GIIS_DIST_SHARE.trty_limit%TYPE;  
  v_facul_amt           GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  v_orig_net_amt        GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  v_treaty_amt          GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  v_qs_shr_pct          GIIS_DIST_SHARE.qs_shr_pct%TYPE;
  v_acct_trty_type      GIIS_DIST_SHARE.acct_trty_type%TYPE;
  v_share_cd            GIIS_DIST_SHARE.share_cd%TYPE;
  v_policy              VARCHAR2(2000);
  counter               NUMBER := 0;
  v_switch              NUMBER := 0;
  v_policy_id           NUMBER;
  v_clm_dist_no         NUMBER := 0;
  v_peril_sname         GIIS_PERIL.peril_sname%TYPE;
  v_trty_peril          GIIS_PERIL.peril_sname%TYPE;
  p_dist_flag           GIIS_PARAMETERS.param_value_v%TYPE;
--switch to determine if share_cd is already existing 
  v_share_exist         VARCHAR2(1);
  v_xol_share_type      GIAC_PARAMETERS.param_value_v%TYPE := NVL(giacp.v('XOL_TRTY_SHARE_TYPE'), 4);

  v_res_dist_yr         GICL_RESERVE_DS.dist_year%TYPE;
  v_res_shr_type        GICL_RESERVE_DS.share_type%TYPE;
  v_res_acct_trty_type  GICL_RESERVE_DS.acct_trty_type%TYPE;
  v_port_trty_exist     VARCHAR2(1);


BEGIN

  FOR rec IN
    (SELECT param_value_v
       FROM GIIS_PARAMETERS
      WHERE param_name = 'DISTRIBUTED')
  LOOP
    p_dist_flag := rec.param_value_v;
  END LOOP;

  p_clm_dist_no := NVL(p_clm_dist_no,0) + 1;
  v_clm_dist_no := p_clm_dist_no;  

  FOR c1 in cur_clm_res LOOP        /*Using Item-peril cursor */
    BEGIN
      SELECT param_value_n
        INTO v_facul_share_cd
        FROM GIIS_PARAMETERS
       WHERE param_name = 'FACULTATIVE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.');
    END;

    BEGIN
      SELECT param_value_v
        INTO v_trty_share_type
        FROM GIAC_PARAMETERS
      WHERE param_name = 'TRTY_SHARE_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table.');
    END;

    BEGIN
      SELECT param_value_v
        INTO v_facul_share_type
        FROM GIAC_PARAMETERS
       WHERE param_name = 'FACUL_SHARE_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table.');
    END;

    BEGIN
      SELECT param_value_n
        INTO v_acct_trty_type
        FROM GIAC_PARAMETERS
       WHERE param_name = 'QS_ACCT_TRTY_TYPE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table.');
    END;

    BEGIN
      SELECT SUM(T1.TSI_AMT) TSI_AMT 
        INTO sum_tsi_amt
        FROM GIPI_POLBASIC T2, GIPI_ITEM T3, GIPI_ITMPERIL T1,
             GIUW_POL_DIST T4
       WHERE T2.policy_id = T3.policy_id
         AND T3.policy_id = T1.policy_id 
         AND T3.item_no   = T1.item_no
         AND T2.policy_id = T4.policy_id
         AND TRUNC(DECODE(TRUNC(t4.eff_date), TRUNC(t2.eff_date),
             DECODE(TRUNC(t2.eff_date), TRUNC(t2.incept_date), p_pol_eff_date, t2.eff_date ), t4.eff_date)) 
             <= TRUNC(p_loss_date)
         AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t2.expiry_date),
             DECODE(NVL(t2.endt_expiry_date, t2.expiry_date),
             t2.expiry_date, p_expiry_date, t2.endt_expiry_date), t4.expiry_date))
             >= TRUNC(p_loss_date)
         AND T1.item_no    = c1.item_no
         AND T1.peril_cd   = c1.peril_cd
         AND T2.line_cd    = p_line_cd
         AND T2.subline_cd = p_subline_cd
         AND T2.iss_cd     = p_pol_iss_cd
         AND T2.issue_yy   = p_issue_yy
         AND T2.pol_seq_no = p_pol_seq_no
         AND T2.renew_no   = p_renew_no
         AND t2.pol_flag   IN ('1','2','3','4','X') --kenneth SR 4855 100715
         AND T4.dist_flag  = p_dist_flag; 
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'The TSI for this policy is Zero.');
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
      FROM GIIS_PERIL
     WHERE peril_cd = c1.peril_cd
       AND line_cd  = p_line_cd;
 
    SELECT param_value_v
      INTO v_trty_peril
      FROM GIAC_PARAMETERS
     WHERE param_name = 'TRTY_PERIL';

    IF v_peril_sname = v_trty_peril THEN
       SELECT param_value_n
         INTO v_trty_limit
         FROM GIAC_PARAMETERS
        WHERE param_name = 'TRTY_PERIL_LIMIT';
    END IF;     
    
    IF sum_tsi_amt!=0 AND sum_tsi_amt IS NOT NULL THEN -- adrel 05102007 added to handle division if sum_tsi_amt is zero (ERROR ORA-01476)

      IF sum_tsi_amt > v_trty_limit THEN

       FOR I IN CUR_PERILDS(C1.PERIL_CD, C1.ITEM_NO) LOOP
         
         IF I.SHARE_TYPE = V_FACUL_SHARE_TYPE THEN
            v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi/sum_tsi_amt);
         END IF;
         
       END LOOP;
         v_orig_net_amt := (sum_tsi_amt - NVL(v_facul_amt,0))* ((100 - v_qs_shr_pct)/100);  
         v_treaty_amt   := (sum_tsi_amt - NVL(v_facul_amt,0))* (v_qs_shr_pct/100);

      ELSE
       v_orig_net_amt := sum_tsi_amt * ((100 - v_qs_shr_pct)/100);
       v_treaty_amt   := sum_tsi_amt * (v_qs_shr_pct/100);
            
      END IF;

      BEGIN
       SELECT MAX(dist_year) dist_year
         INTO v_res_dist_yr
         FROM GICL_RESERVE_DS
       WHERE claim_id = v1_claim_id
         AND item_no  = v1_item_no
         AND peril_cd = v1_peril_cd
         AND grouped_item_no = v1_grouped_item_no
         AND NVL(negate_tag,'N')<> 'Y';
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
        v_res_dist_yr := TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR');
      END;

/*Start of distribution - Marge 4-15-2k*/
    FOR c2 in cur_perilds(c1.peril_cd,c1.item_no) LOOP /*Underwriting peril distribution*/
      IF c2.share_type = v_trty_share_type THEN

         DECLARE 
           v_share_cd     GIIS_DIST_SHARE.share_cd%TYPE := c2.share_cd;
           v_treaty_yy2   GIIS_DIST_SHARE.trty_yy%TYPE  := c2.trty_yy;
           v_prtf_sw      GIIS_DIST_SHARE.prtfolio_sw%TYPE;
           v_acct_trty    GIIS_DIST_SHARE.acct_trty_type%TYPE;
           v_share_type   GIIS_DIST_SHARE.share_type%TYPE;
           v_expiry_date  GIIS_DIST_SHARE.expiry_date%TYPE;
         BEGIN               
           IF NVL(c2.prtfolio_sw, 'N') = 'P' AND TRUNC(c2.expiry_date) < NVL(p_nbt_dist_date, SYSDATE) THEN

              WHILE TRUNC(c2.expiry_date) < NVL(p_nbt_dist_date, SYSDATE) LOOP
                BEGIN
                  SELECT share_cd,       trty_yy,    NVL(prtfolio_sw, 'N'),
                         acct_trty_type, share_type, expiry_date
                    INTO v_share_cd,  v_treaty_yy2, v_prtf_sw,
                         v_acct_trty, v_share_type, v_expiry_date
                    FROM GIIS_DIST_SHARE
                     WHERE line_cd          = p_line_cd
                       AND old_trty_seq_no  = c2.share_cd;                    
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                      RAISE_APPLICATION_ERROR(-20006, 'No new treaty set-up for year '|| TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR'));
                    EXIT;
                    WHEN TOO_MANY_ROWS THEN
                      RAISE_APPLICATION_ERROR(-20007, 'Too many treaty set-up for year '|| TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR'));
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
      v_port_trty_exist := 'N';
      --Kenneth 03.16.2015
      FOR i IN 
        (SELECT '1'
           FROM GICL_LOSS_EXP_DS a,  GIIS_DIST_SHARE b
          WHERE a.claim_id    = p_claim_id
            AND a.item_no     = c1.item_no
            AND a.grouped_item_no = C1.grouped_item_no
            AND a.peril_cd    = c1.peril_cd
            AND a.grp_seq_no  = c2.share_cd
            AND a.line_cd     = p_line_cd
            AND a.clm_dist_no = v_clm_dist_no             
            AND a.clm_loss_id = v1_clm_loss_id
            AND a.grp_seq_no = b.share_cd
            AND a.line_cd = b.line_cd
            AND b.prtfolio_sw = 'P')        
      LOOP
         v_port_trty_exist:='Y';
      END LOOP;
      
      IF v_port_trty_exist != 'Y' --Kenneth 03.16.2015
         THEN
      FOR res_pct IN
        (SELECT a.share_type, a.shr_pct, a.acct_trty_type
           FROM GICL_RESERVE_DS a
          WHERE a.dist_year       = v_res_dist_yr
            AND a.peril_cd        = v1_peril_cd
            AND a.item_no         = v1_item_no
            AND a.grouped_item_no = v1_grouped_item_no
            AND a.claim_id        = v1_claim_id
            AND a.share_type  NOT IN (v_xol_share_type, '1')
            and a.share_type      = c2.share_type
            AND NVL(a.acct_trty_type, 0) = NVL(c2.acct_trty_type, 0)
            AND NVL(a.negate_tag, 'N') <> 'Y'
            AND a.hist_seq_no     = (SELECT MAX(b.hist_seq_no)
                                       FROM GICL_RESERVE_DS B
                                      WHERE b.dist_year       = a.dist_year
                                        AND b.peril_cd        = a.peril_cd
                                        AND b.item_no         = a.item_no
                                        AND b.grouped_item_no = a.grouped_item_no
                                        AND b.claim_id        = a.claim_id
                                        AND NVL(b.negate_tag, 'N') <> 'Y'))
      LOOP
          ann_dist_spct := res_pct.shr_pct;
      END LOOP;

      IF ((c2.acct_trty_type <> v_acct_trty_type) OR
          (c2.acct_trty_type IS NULL)) AND v_switch = 0 THEN 

         IF ann_dist_spct = 0 THEN
            ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100; -- 500000/1000000 = 50
         END IF;
         
         v_paid_amt     := c1.paid_amt * ann_dist_spct/100; --5000 * 50/100 = 2500
         v_advise_amt   := c1.advise_amt * ann_dist_spct/100; -- 5000 * .5 = 2500
         v_net_amt      := c1.net_amt * ann_dist_spct/100; -- 2500
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
               ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100; -- 500,000/1,000,000 * 100 = 50
            END IF;
            
            v_paid_amt     := c1.paid_amt * ann_dist_spct/100; -- 5,000 * .5 = 2500
            v_advise_amt   := c1.advise_amt * ann_dist_spct/100; -- 2500
            v_net_amt      := c1.net_amt * ann_dist_spct/100; -- 2500
            
         END IF;
      END IF;
      /*checks if share_cd is already existing if existing updates gicl_reserve_ds
      if not existing then inserts record to gicl_reserve_ds*/ 
      
      v_share_exist := 'N';
      
      FOR i IN 
        (SELECT '1'
           FROM GICL_LOSS_EXP_DS
          WHERE claim_id    = p_claim_id
            AND item_no     = c1.item_no
            AND grouped_item_no = C1.grouped_item_no
            AND peril_cd    = c1.peril_cd
            AND grp_seq_no  = c2.share_cd
            AND line_cd     = p_line_cd
            AND clm_dist_no = v_clm_dist_no             
            AND clm_loss_id = v1_clm_loss_id)        
      LOOP
        v_share_exist :='Y';
      END LOOP;

      IF ann_dist_spct <> 0 THEN
         IF v_share_exist = 'N' THEN
             
            INSERT INTO GICL_LOSS_EXP_DS(claim_id,             dist_year,           clm_loss_id,
                                         clm_dist_no,          item_no,             peril_cd,
                                         payee_cd,             grp_seq_no,          share_type,
                                         shr_loss_exp_pct,     shr_le_pd_amt,       shr_le_adv_amt,
                                         shr_le_net_amt,       line_cd,             acct_trty_type,
                                         distribution_date,    grouped_item_no)
                                 VALUES (p_claim_id,           TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR'), v1_clm_loss_id,
                                         v_clm_dist_no,        c1.item_no,          c1.peril_cd,
                                         p_payee_cd,           c2.share_cd,         c2.share_type,
                                         ann_dist_spct,        v_paid_amt,          v_advise_amt,
                                         v_net_amt,            p_line_cd,           c2.acct_trty_type,
                                         NVL(p_nbt_dist_date, SYSDATE),             C1.grouped_item_no);
         ELSE
            UPDATE GICL_LOSS_EXP_DS
               SET shr_le_pd_amt     = NVL(shr_le_pd_amt,0) + NVL(v_paid_amt,0),
                   shr_le_adv_amt    = NVL(shr_le_adv_amt,0) + NVL(v_advise_amt,0),
                   shr_le_net_amt    = NVL(shr_le_net_amt,0) + NVL(v_net_amt,0),
                   shr_loss_exp_pct  = NVL(shr_loss_exp_pct,0) + NVL(ann_dist_spct,0),
                   dist_year         = TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR'),
                   distribution_date = NVL(p_nbt_dist_date, SYSDATE)
             WHERE claim_id    = p_claim_id
               AND item_no     = c1.item_no
               AND grouped_item_no = c1.grouped_item_no
               AND peril_cd    = c1.peril_cd
               AND grp_seq_no  = c2.share_cd
               AND line_cd     = p_line_cd
               AND clm_dist_no = v_clm_dist_no                      
               AND clm_loss_id = v1_clm_loss_id;
         END IF;           
         me := TO_NUMBER(c2.share_type) - TO_NUMBER(v_trty_share_type);
         
         IF me = 0 THEN

            FOR c_trty IN cur_trty(c2.share_cd, c2.trty_yy) LOOP
              IF v_share_exist = 'N' THEN

                 INSERT INTO GICL_LOSS_EXP_RIDS(claim_id,            dist_year,               clm_loss_id,
                                                clm_dist_no,         item_no,                 peril_cd, 
                                                payee_cd,            grp_seq_no,              share_type,
                                                ri_cd,               shr_loss_exp_ri_pct,     shr_le_ri_pd_amt,
                                                shr_le_ri_adv_amt,   shr_le_ri_net_amt,       line_cd,         
                                                acct_trty_type,      prnt_ri_cd,              grouped_item_no)
                                      VALUES  ( p_claim_id,          TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR'), v1_clm_loss_id,
                                                v_clm_dist_no,       c1.item_no,              c1.peril_cd,
                                                p_payee_cd,          c2.share_cd,             v_trty_share_type,
                                                c_trty.ri_cd,        (ann_dist_spct  * (c_trty.trty_shr_pct/100)), (v_paid_amt * (c_trty.trty_shr_pct/100)),
                                                (v_advise_amt  * (c_trty.trty_shr_pct/100)),  (v_net_amt  * (c_trty.trty_shr_pct/100)), p_line_cd,     
                                                c2.acct_trty_type,   c_trty.prnt_ri_cd,       c1.grouped_item_no);
              ELSE

                 UPDATE GICL_LOSS_EXP_RIDS
                    SET shr_loss_exp_ri_pct = NVL(shr_loss_exp_ri_pct,0) + (NVL(ann_dist_spct,0)  * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_pd_amt    = NVL(shr_le_ri_pd_amt,0) + (NVL(v_paid_amt,0) * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_adv_amt   = NVL(shr_le_ri_adv_amt,0) + (NVL(v_advise_amt,0)  * (c_trty.trty_shr_pct/100)),
                        shr_le_ri_net_amt   = NVL(shr_le_ri_net_amt,0) + (NVL(v_net_amt,0)  * (c_trty.trty_shr_pct/100)),
                        dist_year           = TO_CHAR(NVL(p_nbt_dist_date, SYSDATE), 'RRRR')
                  WHERE claim_id    = p_claim_id
                    AND item_no     = c1.item_no
                    AND grouped_item_no = c1.grouped_item_no
                    AND peril_cd    = c1.peril_cd
                    AND grp_seq_no  = c2.share_cd
                    AND line_cd     = p_line_cd
                    AND ri_cd       = c_trty.ri_cd 
                    AND clm_dist_no = v_clm_dist_no             
                    AND clm_loss_id = v1_clm_loss_id;
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
               
              INSERT INTO GICL_LOSS_EXP_RIDS(claim_id,          dist_year,                 clm_loss_id, 
                                             clm_dist_no,       item_no,                   peril_cd,
                                             payee_cd,          grp_seq_no,                share_type,
                                             ri_cd,             shr_loss_exp_ri_pct,       shr_le_ri_pd_amt,
                                             shr_le_ri_adv_amt, shr_le_ri_net_amt,         line_cd,                   
                                             acct_trty_type,    prnt_ri_cd,                grouped_item_no)
                                      VALUES(p_claim_id,        TO_CHAR(SYSDATE, 'YYYY'),  v1_clm_loss_id,
                                             v_clm_dist_no,     c1.item_no,                c1.peril_cd,
                                             p_payee_cd,        c2.share_cd,               v_facul_share_type,
                                             c3.ri_cd,          ann_ri_pct,                (c1.paid_amt * ann_ri_pct/100),
                                             (c1.advise_amt * ann_ri_pct/100),(c1.net_amt * ann_ri_pct/100), p_line_cd,       
                                             c2.acct_trty_type, c3.ri_cd,                   c1.grouped_item_no);
            END LOOP; /*End of c3 loop */
         END IF;
      ELSE 
         NULL;
      END IF;
      ELSE
         NULL;
      END IF;
    END LOOP; /*End of c2 loop*/    
   ELSIF sum_tsi_amt = 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'TSI for this peril is zero... Cannot distribute loss/exp history.');
   END IF; -- end of IF sum_tsi_amt!=0 THEN
  END LOOP; /*End of c1 loop */

  UPDATE gicl_clm_loss_exp
     SET dist_sw     = 'Y'
   WHERE claim_id    = v1_claim_id
     AND clm_loss_id = v1_clm_loss_id;
  
  gicls030_offset_amt(v_clm_dist_no, v1_claim_id, v1_clm_loss_id);
  
END;
/


