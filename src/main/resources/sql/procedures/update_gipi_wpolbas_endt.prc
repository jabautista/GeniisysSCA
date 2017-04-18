DROP PROCEDURE CPI.UPDATE_GIPI_WPOLBAS_ENDT;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIPI_WPOLBAS_ENDT (
    p_par_id		IN gipi_wpolbas.par_id%TYPE,
    p_negate_item	IN VARCHAR2,
    p_prorate_flag	IN gipi_wpolbas.prorate_flag%TYPE,
    p_comp_sw		IN VARCHAR2,
    p_endt_exp_date	IN gipi_wpolbas.endt_expiry_date%TYPE,
    p_eff_date		IN gipi_wpolbas.eff_date%TYPE,
    p_exp_date		IN gipi_wpolbas.expiry_date%TYPE,
    p_short_rt_pct	IN gipi_wpolbas.short_rt_percent%TYPE,
	p_message        OUT VARCHAR2,
    p_tsi_amt        OUT gipi_wpolbas.tsi_amt%TYPE,
    p_ann_tsi_amt    OUT gipi_wpolbas.ann_tsi_amt%TYPE,
    p_prem_amt        OUT gipi_wpolbas.prem_amt%TYPE,
    p_ann_prem_amt    OUT gipi_wpolbas.ann_prem_amt%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created    : 11.03.2010
    **  Reference By    : (GIPIS061 - Item Information - Casualty)
    **  Description     : Ann_tsi_amt and ann_prem_amt is computed based on the tsi_amt and
    **                    : prem_amt of the original policy and all it's suceeding endorsements
    */
    v_tsi            gipi_wpolbas.tsi_amt%TYPE := 0;
    v_ann_tsi        gipi_wpolbas.ann_tsi_amt%TYPE := 0;
    v_prem            gipi_wpolbas.prem_amt%TYPE := 0;
    v_ann_prem        gipi_wpolbas.ann_prem_amt%TYPE := 0;
    v_ann_tsi2        gipi_wpolbas.ann_tsi_amt%TYPE := 0;
    v_ann_prem2        gipi_wpolbas.ann_prem_amt%TYPE := 0;
    v_prorate        NUMBER(12, 9);
    v_no_of_items    NUMBER;
    v_comp_prem        gipi_wpolbas.prem_amt%TYPE := 0;
    v_expired_sw    VARCHAR2(1) := 'N';
    v_exist            VARCHAR2(1);
    v_expiry_date    gipi_wpolbas.expiry_date%TYPE;
    v_line_cd        gipi_wpolbas.line_cd%TYPE;
    v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
    v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
    v_issue_yy        gipi_wpolbas.issue_yy%TYPE;
    v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
    v_renew_no        gipi_wpolbas.renew_no%TYPE;
    v_eff_date        gipi_wpolbas.eff_date%TYPE;
BEGIN
    FOR i IN (
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        v_line_cd        := i.line_cd;
        v_subline_cd    := i.subline_cd;
        v_iss_cd        := i.iss_cd;
        v_issue_yy        := i.issue_yy;
        v_pol_seq_no    := i.pol_seq_no;
        v_renew_no        := i.renew_no;
        v_eff_date        := i.eff_date;
    END LOOP;
    
    v_expiry_date := extract_expiry(p_par_id);
    
    -- summarize amounts of all items for this record 
    FOR A1 IN (
        SELECT SUM(NVL(tsi_amt,0) * NVL(currency_rt,1)) tsi,
               SUM(NVL(prem_amt,0) * NVL(currency_rt,1)) prem,
               COUNT(item_no) no_of_items
          FROM gipi_witem
         WHERE par_id = p_par_id) 
    LOOP
        IF NVL(p_negate_item, 'N') = 'Y' THEN
            v_ann_prem := v_ann_prem + A1.prem;
        ELSE
            --Three conditions have to be considered for endt.
            -- 2 indicates that computation should be base on 1 year span
            
            IF p_prorate_flag = 3 THEN
               v_ann_prem := v_ann_prem + (A1.prem / (NVL(p_short_rt_pct, 1) / 100));
            ELSIF p_prorate_flag = 1 THEN
                IF p_comp_sw = 'Y' THEN
                    v_prorate := ((TRUNC(p_endt_exp_date) - TRUNC(p_eff_date)) + 1) 
                                    / (ADD_MONTHS(p_eff_date, 12) - p_eff_date);
                ELSIF p_comp_sw = 'M' THEN
                    v_prorate := ((TRUNC(p_endt_exp_date) - TRUNC(p_eff_date)) - 1) 
                                    / (ADD_MONTHS(p_eff_date, 12) - p_eff_date);
                ELSE
                    v_prorate := (TRUNC(p_endt_exp_date) - TRUNC(p_eff_date))
                                    / (ADD_MONTHS(p_eff_date, 12) - p_eff_date);
                END IF;
                
                IF TRUNC(p_eff_date) = TRUNC(p_endt_exp_date) THEN
                    v_prorate := 1;
                END IF;
                v_ann_prem := v_ann_prem + (A1.prem / v_prorate);
            ELSE
                v_ann_prem := v_ann_prem + A1.prem;
            END IF;
        END IF;
    END LOOP;
    
    v_expired_sw := 'N';
    
    FOR SW IN (
        SELECT '1'
          FROM GIPI_ITMPERIL A,
               GIPI_POLBASIC B
         WHERE B.line_cd      =  v_line_cd
           AND B.subline_cd   =  v_subline_cd
           AND B.iss_cd       =  v_iss_cd
           AND B.issue_yy     =  v_issue_yy
           AND B.pol_seq_no   =  v_pol_seq_no
           AND B.renew_no     =  v_renew_no
           AND B.policy_id    =  A.policy_id
           AND B.pol_flag     IN('1','2','3','X')
           AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
           AND TRUNC(B.eff_date) <=  TRUNC(v_eff_date)         
           AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
               p_exp_date, b.expiry_date, b.endt_expiry_date)) < TRUNC(p_eff_date)
      ORDER BY B.eff_date DESC)
    LOOP
        v_expired_sw := 'Y';
        EXIT;
    END LOOP;
    
    /* update amounts in gipi_wpolbas 
    ** for policy that have expired short term endorsement
    ** recompute annualized amounts, for policy that does not have 
    ** expired short term endorsements just get the amounts from the
    ** latest endorsements
    */ 
    -- there are no existing short-term endt.
    IF NVL(v_expired_sw, 'N') = 'N' THEN
        v_exist := 'N';
        
        -- query amounts from the latest endt
        FOR A2 IN (
            SELECT b250.ann_tsi_amt  ANN_TSI,
                   b250.ann_prem_amt ANN_PREM
              FROM gipi_wpolbas b, gipi_polbasic b250 
             WHERE b.par_id        = p_par_id
               AND b250.line_cd    = b.line_cd
               AND b250.subline_cd = b.subline_cd
               AND b250.iss_cd     = b.iss_cd
               AND b250.issue_yy   = b.issue_yy
               AND b250.pol_seq_no = b.pol_seq_no
               AND b250.renew_no   = b.renew_no
               AND b250.pol_flag   IN ('1','2','3','X') 
               AND TRUNC(b250.eff_date) <=  TRUNC(b.eff_date)               
               AND (TRUNC(DECODE(
                            NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                p_exp_date, b.expiry_date, b.endt_expiry_date)) >= TRUNC(v_eff_date) OR
                   p_negate_item = 'Y')
               AND NVL(b250.endt_seq_no,0) > 0
          ORDER BY b250.eff_date DESC)
        LOOP
            UPDATE gipi_wpolbas
               SET tsi_amt      = nvl(v_tsi,0),
                   prem_amt     = nvl(v_prem,0),
                   ann_tsi_amt  = A2.ann_tsi  +nvl(v_ann_tsi,0),
                   ann_prem_amt = A2.ann_prem + nvl(v_ann_prem,0),
                   no_of_items  = nvl(v_no_of_items,0)
             WHERE par_id = p_par_id;
            
            p_tsi_amt         := NVL(v_tsi, 0);
            p_prem_amt        := NVL(v_prem, 0);
            p_ann_tsi_amt    := A2.ann_tsi + NVL(v_ann_tsi, 0);
            p_ann_prem_amt    := A2.ann_prem + NVL(v_ann_prem, 0);
            
            v_exist := 'Y'; -- toggle switch that will indicate that amount is alredy retrieved
            EXIT;
        END LOOP;
        
        --for records with no endt. yet query it's amount from policy record
        IF v_exist = 'N' THEN
            FOR A2 IN (
                SELECT b250.tsi_amt      tsi,
                       b250.prem_amt     prem,
                       b250.ann_tsi_amt  ann_tsi,
                       b250.ann_prem_amt ann_prem
                  FROM gipi_wpolbas b, gipi_polbasic b250 
                 WHERE b.par_id        = p_par_id
                   AND b250.line_cd    = b.line_cd
                   AND b250.subline_cd = b.subline_cd
                   AND b250.iss_cd     = b.iss_cd
                   AND b250.issue_yy   = b.issue_yy
                   AND b250.pol_seq_no = b.pol_seq_no
                   AND b250.renew_no   = b.renew_no
                   AND b250.pol_flag   IN ('1','2','3','X') 
                   AND NVL(b250.endt_seq_no,0) = 0
              ORDER BY B.EFF_DATE DESC)
            LOOP
                UPDATE gipi_wpolbas
                   SET tsi_amt      = NVL(v_tsi,0),
                       prem_amt     = NVL(v_prem,0),
                       ann_tsi_amt  = A2.ann_tsi  + NVL(v_ann_tsi,0),
                       ann_prem_amt = A2.ann_prem + NVL(v_ann_prem,0),
                       no_of_items  = nvl(v_no_of_items,0)
                 WHERE par_id = p_par_id;
                
                p_tsi_amt         := NVL(v_tsi, 0);
                p_prem_amt        := NVL(v_prem, 0);
                p_ann_tsi_amt    := A2.ann_tsi + NVL(v_ann_tsi, 0);
                p_ann_prem_amt    := A2.ann_prem + NVL(v_ann_prem, 0);
                EXIT;
            END LOOP;
        END IF;
    ELSE
        --for records with existing short term endt. amounts will be recomputed
        --by adding all amounts of policy and endt. that is not yet expired
        FOR A2 IN (
            SELECT (C.tsi_amt * A.currency_rt) tsi,
                   (C.prem_amt * A.currency_rt) prem,       
                   B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                   B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                   B.short_rt_percent   short_rt,
                   C.peril_cd
              FROM gipi_item A,
                   gipi_polbasic B,  
                   gipi_itmperil C
             WHERE B.line_cd      =  v_line_cd
               AND B.subline_cd   =  v_subline_cd
               AND B.iss_cd       =  v_iss_cd
               AND B.issue_yy     =  v_issue_yy
               AND B.pol_seq_no   =  v_pol_seq_no
               AND B.renew_no     =  v_renew_no
               AND B.policy_id    =  A.policy_id
               AND B.policy_id    =  C.policy_id
               AND A.item_no      =  C.item_no
               AND B.pol_flag     IN('1','2','3','X') 
               AND TRUNC(b.eff_date) <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))               
               AND (TRUNC(DECODE(
                            NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                p_exp_date, b.expiry_date,b.endt_expiry_date)) >= TRUNC(v_eff_date) OR
                   p_negate_item = 'Y')
          ORDER BY B.eff_date DESC) 
        LOOP
            v_comp_prem := 0;
            
            IF NVL(p_negate_item,'N') = 'Y' THEN
                v_comp_prem := a2.prem;
            ELSE
                IF A2.prorate_flag = 1 THEN
                    IF A2.endt_expiry_date <= A2.eff_date THEN
                        p_message := 'Your endorsement expiry date is equal to or less than your effectivity date.' ||
                                         'Restricted condition.';
                        RETURN;
                    ELSE
                        IF A2.comp_sw = 'Y' THEN
                            v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                                            (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
                        ELSIF A2.comp_sw = 'M' THEN
                            v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                                            (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
                        ELSE 
                            v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                                            (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
                        END IF;
                    END IF;
                    
                    IF TRUNC(p_eff_date) = TRUNC(p_endt_exp_date) THEN
                        v_prorate := 1;
                    END IF;
                    
                    v_comp_prem  := A2.prem/v_prorate;
                    
                ELSIF A2.prorate_flag = 2 THEN
                    v_comp_prem  :=  A2.prem;
                ELSE
                    v_comp_prem :=  A2.prem/(A2.short_rt/100); 
                END IF;
            END IF;
            
            v_ann_prem2 := v_ann_prem2 + v_comp_prem;
            FOR TYPE IN (
                SELECT peril_type
                  FROM giis_peril
                 WHERE line_cd  = v_line_cd
                   AND peril_cd = A2.peril_cd)
            LOOP
                IF TYPE.peril_type = 'B' THEN
                    v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
                END IF;
            END LOOP;
        END LOOP;
        
        UPDATE gipi_wpolbas
           SET tsi_amt      = NVL(v_tsi,0),
               prem_amt     = NVL(v_prem,0),
               ann_tsi_amt  = NVL(v_ann_tsi,0) + NVL(v_ann_tsi2,0) ,
               ann_prem_amt = NVL(v_ann_prem,0) + NVL(v_ann_prem2,0) ,
               no_of_items  = nvl(v_no_of_items,0)
         WHERE par_id = p_par_id;
        
        p_tsi_amt         := NVL(v_tsi, 0);
        p_prem_amt        := NVL(v_prem, 0);
        p_ann_tsi_amt    := NVL(v_ann_tsi,0) + NVL(v_ann_tsi2,0);
        p_ann_prem_amt    := NVL(v_ann_prem,0) + NVL(v_ann_prem2,0);
    END IF;
END UPDATE_GIPI_WPOLBAS_ENDT;
/


