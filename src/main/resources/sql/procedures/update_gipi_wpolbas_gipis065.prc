DROP PROCEDURE CPI.UPDATE_GIPI_WPOLBAS_GIPIS065;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIPI_WPOLBAS_GIPIS065(
    p_par_id            GIPI_WPOLBAS.par_id%TYPE,
    p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
    p_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE,
    p_comp_sw           GIPI_WPOLBAS.comp_sw%TYPE,
    p_endt_expiry_date  GIPI_WPOLBAS.endt_expiry_date%TYPE,
    p_eff_date          GIPI_WPOLBAS.eff_date%TYPE,
    p_short_rt_percent  GIPI_WPOLBAS.short_rt_percent%TYPE
)
IS
    v_tsi               GIPI_WPOLBAS.tsi_amt%TYPE :=0;
    v_ann_tsi           GIPI_WPOLBAS.ann_tsi_amt%TYPE :=0;
    v_prem              GIPI_WPOLBAS.prem_amt%TYPE:=0;
    v_ann_prem          GIPI_WPOLBAS.ann_prem_amt%TYPE :=0;  
    v_ann_tsi2          GIPI_WPOLBAS.ann_tsi_amt%TYPE :=0;
    v_ann_prem2         GIPI_WPOLBAS.ann_prem_amt%TYPE :=0;  
    v_prorate           NUMBER(12,9);
    v_no_of_items       NUMBER;
    v_comp_prem         GIPI_WPOLBAS.prem_amt%TYPE  := 0;
    expired_sw          VARCHAR2(1) := 'N';
    v_exist             VARCHAR2(1);
    
    v_expiry_date       DATE; 
    v_incept_date       DATE; 
BEGIN
    v_expiry_date := extract_expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    v_incept_date := extract_incept(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    
    FOR A1 IN(SELECT SUM(NVL(tsi_amt,0) * NVL(currency_rt,1)) TSI,
                     SUM(NVL(prem_amt,0) * NVL(currency_rt,1)) PREM,
                     COUNT(item_no) NO_OF_ITEMS
                FROM gipi_witem
               WHERE par_id = p_par_id) 
    LOOP
        v_ann_tsi        := v_ann_tsi +  A1.tsi;
        v_tsi            := v_tsi +  A1.tsi;
        v_prem           := v_prem +  A1.prem;
        v_no_of_items    := nvl(A1.no_of_items,0);
        
        IF p_prorate_flag = 2 THEN
            v_ann_prem := v_ann_prem + A1.prem; 
        ELSIF p_prorate_flag = 1 THEN
            IF p_comp_sw = 'Y' THEN
                v_prorate  :=  ((TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date )) + 1 )
                              / (ADD_MONTHS(p_eff_date,12) - p_eff_date);
            ELSIF p_comp_sw = 'M' THEN
                v_prorate  :=  ((TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date )) - 1 )
                              / (ADD_MONTHS(p_eff_date,12) - p_eff_date);
            ELSE
                v_prorate  :=  (TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date ))
                              / (ADD_MONTHS(p_eff_date,12) - p_eff_date);
            END IF;
            
            IF TRUNC(p_eff_date) = TRUNC(p_endt_expiry_date) THEN
       	        v_prorate := 1;
            END IF;	  
            v_ann_prem := v_ann_prem +(A1.prem / (v_prorate));
        ELSE
            v_ann_prem :=  v_ann_prem +(A1.prem / (NVL(p_short_rt_percent,1)/100));
        END IF;
    END LOOP;
    
    expired_sw := 'N';
    FOR SW IN(SELECT '1'
                FROM GIPI_ITMPERIL A,
                     GIPI_POLBASIC B
               WHERE B.line_cd      =  p_line_cd
                 AND B.subline_cd   =  p_subline_cd
                 AND B.iss_cd       =  p_iss_cd
                 AND B.issue_yy     =  p_issue_yy
                 AND B.pol_seq_no   =  p_pol_seq_no
                 AND B.renew_no     =  p_renew_no
                 AND B.policy_id    =  A.policy_id
                 AND B.pol_flag     in ('1','2','3','X')
                 AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
                 AND TRUNC(B.eff_date) <=  TRUNC(p_eff_date)
                 AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                     v_expiry_date, b.expiry_date,b.endt_expiry_date)) < TRUNC(p_eff_date)
               ORDER BY B.eff_date DESC)
    LOOP
        expired_sw := 'Y';
        EXIT;
    END LOOP;
    
    IF NVL(expired_sw , 'N') = 'N' THEN
        v_exist := 'N';
        FOR A2 IN ( SELECT b250.ann_tsi_amt  ANN_TSI,
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
                       AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                           v_expiry_date, b250.expiry_date,b250.endt_expiry_date)) >= TRUNC(b.eff_date)
                       AND NVL(b250.endt_seq_no,0) > 0
                     ORDER BY b250.eff_date DESC)
        LOOP
            UPDATE GIPI_WPOLBAS
               SET tsi_amt      = nvl(v_tsi,0),
                   prem_amt     = nvl(v_prem,0),
                   ann_tsi_amt  = A2.ann_tsi  +nvl(v_ann_tsi,0),
                   ann_prem_amt = A2.ann_prem + nvl(v_ann_prem,0),
                   no_of_items  = nvl(v_no_of_items,0)
             WHERE par_id = p_par_id;
            v_exist := 'Y';
            EXIT;
        END LOOP;
        
        IF v_exist = 'N' THEN
            FOR A2 IN (SELECT b250.tsi_amt      TSI,
                              b250.prem_amt     PREM,
                              b250.ann_tsi_amt  ANN_TSI,
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
                          AND NVL(b250.endt_seq_no,0) = 0
                        ORDER BY B.EFF_DATE DESC)
            LOOP
                UPDATE GIPI_WPOLBAS
                   SET tsi_amt      = NVL(v_tsi,0),
                       prem_amt     = NVL(v_prem,0),
                       ann_tsi_amt  = A2.ann_tsi  + NVL(v_ann_tsi,0),
                       ann_prem_amt = A2.ann_prem + NVL(v_ann_prem,0),
                       no_of_items  = nvl(v_no_of_items,0)
                 WHERE par_id = p_par_id;           
                EXIT;
            END LOOP;
        END IF;
    ELSE
        FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                         (C.prem_amt * a.currency_rt) prem,       
                         B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                         B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                         B.short_rt_percent   short_rt,
                         C.peril_cd
                    FROM GIPI_ITEM A,
                         GIPI_POLBASIC B,  
                         GIPI_ITMPERIL C
                   WHERE B.line_cd      =  p_line_cd
                     AND B.subline_cd   =  p_subline_cd
                     AND B.iss_cd       =  p_iss_cd
                     AND B.issue_yy     =  p_issue_yy
                     AND B.pol_seq_no   =  p_pol_seq_no
                     AND B.renew_no     =  p_renew_no
                     AND B.policy_id    =  A.policy_id
                     AND B.policy_id    =  C.policy_id
                     AND A.item_no      =  C.item_no
                     AND B.pol_flag     in ('1','2','3','X') 
                     AND TRUNC(b.eff_date) <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                     AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                         v_expiry_date, b.expiry_date,b.endt_expiry_date)) < TRUNC(p_eff_date)
                   ORDER BY B.eff_date DESC) 
        LOOP
            v_comp_prem := 0;
            IF A2.prorate_flag = 1 THEN
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
                IF TRUNC(p_eff_date) = TRUNC(p_endt_expiry_date) THEN
	       	        v_prorate := 1;
	            END IF;
                v_comp_prem  := A2.prem/v_prorate;
            ELSIF A2.prorate_flag = 2 THEN
                v_comp_prem  :=  A2.prem;
            ELSE
                v_comp_prem :=  A2.prem/(A2.short_rt/100);  
            END IF;
            v_ann_prem2 := v_ann_prem2 + v_comp_prem;
            FOR TYPE IN(SELECT peril_type
                          FROM giis_peril
                         WHERE line_cd  = p_line_cd
                           AND peril_cd = A2.peril_cd)
            LOOP
                IF type.peril_type = 'B' THEN
                    v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
                END IF;
            END LOOP;
        END LOOP;
        UPDATE GIPI_WPOLBAS
           SET tsi_amt      = NVL(v_tsi,0),
               prem_amt     = NVL(v_prem,0),
               ann_tsi_amt  = NVL(v_ann_tsi,0) + NVL(v_ann_tsi2,0) ,
               ann_prem_amt = NVL(v_ann_prem,0) + NVL(v_ann_prem2,0) ,
               no_of_items  = nvl(v_no_of_items,0)
         WHERE par_id = p_par_id;
    END IF;
END;
/


