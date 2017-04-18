DROP PROCEDURE CPI.VALIDATE_BACK_ALLIED;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_BACK_ALLIED(
    p_line_cd                   GIPI_QUOTE.line_cd%TYPE,
    p_peril_cd                  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
    p_peril_type                GIIS_PERIL.peril_type%TYPE,
    p_basc_perl_cd              GIIS_PERIL.basc_perl_cd%TYPE,
    p_tsi_amt                   GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
    p_prem_amt                  GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
    
    p_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd        GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy      GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no    GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no      GIPI_WPOLBAS.renew_no%TYPE,
    
    p_item_no           GIPI_WITMPERL_GROUPED.item_no%TYPE,
    p_grouped_item_no   GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
    
    p_eff_date      VARCHAR2,
    p_expiry_date   VARCHAR2,
    
    p_tsi_limit_sw  VARCHAR2,
    
    p_peril_list    VARCHAR2,
    p_peril_count   NUMBER,
    
    p_message       IN OUT     VARCHAR2
)
IS
    v_eff_date      DATE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
    v_expiry_date   DATE := TO_DATE(p_expiry_date, 'mm-dd-yyyy');

    cnt_basic      NUMBER := 0;
    cnt_basic3      NUMBER := 0;
    cnt_allied     NUMBER := 0;
    attach_exist   VARCHAR2(1) := 'N';
    allied_exist   VARCHAR2(1) := 'N';
    allied_rg      VARCHAR2(1) := 'N';
    cnt            NUMBER;
    cnt2           NUMBER;
    cnt3           NUMBER := 0;
    b_type         VARCHAR2(1);
    b_peril        NUMBER;
    b_item         NUMBER;
    b_grouped_item         NUMBER;
    b_tsi          NUMBER;
    b_line         VARCHAR2(5);
    p_peril        NUMBER;
    p_item         NUMBER;
    p_grouped_item         NUMBER;
    p_tsi          NUMBER;
    p_line         VARCHAR2(5);
    b3_peril       NUMBER;
    b3_item        NUMBER;
    b3_grouped_item        NUMBER;
    b3_tsi         NUMBER;
    b3_tsi1        NUMBER  := 0;
    b3_line        VARCHAR2(5);
    dum_tsi        NUMBER  := NULL;
    rg_tsi         NUMBER  := NULL;
    sel_tsi        NUMBER  := NULL;
    prem_tsi       NUMBER  := NULL;
    att_tsi        NUMBER  := 0;
    fin_tsi        NUMBER  := 0;
    basc_tsi       NUMBER  := NULL;
    exist_sw       VARCHAR2(1);
    comp_tsi       NUMBER ;
    curr_exist     VARCHAR2(1);
    
    act_allied_exist   VARCHAR2(1) := 'N';  --robert
    act_tsi_amt        NUMBER  := 0;  --robert
BEGIN
   FOR A1 IN 
      ( SELECT b250.policy_id, b380.ann_tsi_amt, b250.line_cd, b250.iss_cd, b250.subline_cd,
               b250.pol_seq_no, b250.issue_yy, b250.renew_no, b250.eff_date,
               b250.endt_iss_cd||'-'||to_char(b250.endt_yy,'09')||to_char(b250.endt_seq_no,'099999') endt_no
          FROM gipi_itmperil_grouped b380,
               gipi_polbasic b250
         WHERE b250.line_cd      =  p_line_cd
           AND b250.subline_cd   =  p_subline_cd
           AND b250.iss_cd       =  p_iss_cd
           AND b250.issue_yy     =  p_issue_yy
           AND b250.pol_seq_no   =  p_pol_seq_no
           AND b250.renew_no     =  p_renew_no
           AND b250.policy_id    =  b380.policy_id
           AND b380.item_no      =  p_item_no
           AND b380.grouped_item_no      =  p_grouped_item_no
           AND b380.peril_cd     =  p_peril_cd
           AND b250.pol_flag     in('1','2','3','X')
           AND TRUNC(b250.eff_date)     >  v_eff_date  -- Dren 10.07.2015 SR 0020370 : Added TRUNC on b250.eff_date to allow negative TSI
           AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
               v_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= v_eff_date
        ORDER BY b250.eff_date )
    LOOP
        comp_tsi := NVL(a1.ann_tsi_amt,0) + NVL(p_tsi_amt,0);   -- XXXXXX
        IF p_peril_type = 'B'  THEN
            SELECT count(*)
              INTO cnt_allied  
              FROM giis_peril a170
             WHERE a170.line_cd        = p_line_cd
               AND a170.peril_type     = 'A'
               AND a170.basc_perl_cd   = p_peril_cd;
               
            IF cnt_allied > 0 THEN
                FOR ALLIED1 IN(SELECT a170.peril_cd 
                                 FROM giis_peril a170
                                WHERE a170.line_cd        = p_line_cd
                                  AND a170.peril_type     = 'A'
                                  AND (a170.basc_perl_cd   = p_peril_cd OR a170.basc_perl_cd IS NULL))
                LOOP 
                    prem_tsi := null; 
                    sel_tsi := null;
                    FOR C1 IN(SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                FROM gipi_itmperil_grouped a
                               WHERE a.policy_id    =  A1.policy_id
                                 AND a.item_no      =  p_item_no
                                 AND a.grouped_item_no      =  p_grouped_item_no
                                 AND a.peril_cd     =  ALLIED1.peril_cd)
                    LOOP
                        sel_tsi := c1.ann_tsi_amt;
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            b_peril      :=  i.peril_cd;
                            b_tsi        :=  i.tsi_amt;
                            IF b_peril   = allied1.peril_cd THEN
                                sel_tsi := nvl(sel_tsi,0)+ nvl(i.tsi_amt,0);
                            END IF;
                        END LOOP;
                        if nvl(sel_tsi ,0) > 0 THEN
                            allied_exist := 'Y' ;
                        end if;
                        EXIT;
                    END LOOP;
                    prem_tsi := nvl(sel_tsi,0);
                    IF fin_tsi < prem_tsi THEN
                       fin_tsi := prem_tsi;
                    END IF;
                END LOOP;
                /* check for existence of other basic perils in policy and it's endorsements  */
                IF allied_exist = 'Y' THEN
                    FOR CHK_BASIC IN(SELECT a170.peril_cd 
                                       FROM giis_peril a170
                                      WHERE a170.line_cd        = p_line_cd
                                        AND a170.peril_type     = 'B'
                                        AND peril_cd           <> p_peril_cd)
                    LOOP
                        allied_rg := 'N';
                        b3_peril      :=  NULL;
                        b3_tsi        :=  0;
                        b3_tsi1       :=  0;
                        b3_item       :=  NULL;
                        b3_grouped_item       :=  NULL;
                        b3_line       :=  NULL;
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            b3_peril      := i.peril_cd;
                            b3_tsi        := i.tsi_amt;
                            b3_tsi1       := i.tsi_amt1;
                        
                            IF b3_peril  = CHK_BASIC.peril_cd THEN
                                IF NVL(b3_tsi, 0) = 0 THEN 
                                    exit;
                                ELSIF NVL(b3_tsi,0) >= NVL(fin_tsi,0) THEN
                                    allied_rg := 'Y';
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit;
                                END IF;
                            END IF;
                        END LOOP;
                        
                        IF allied_rg = 'N'  then
                            curr_exist := 'N';
                            FOR C3 IN (SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                         FROM gipi_itmperil_grouped a
                                        WHERE a.policy_id    =  a1.policy_id
                                          AND a.item_no      =  p_item_no
                                          AND a.grouped_item_no      =  p_grouped_item_no
                                          AND a.peril_cd     =  CHK_BASIC.peril_cd)
                            LOOP
                                curr_exist := 'Y';
                                IF NVL(c3.ann_tsi_amt,0) = 0 THEN
                                    EXIT;
                                ELSIF NVL(c3.ann_tsi_amt ,0) + NVL(b3_tsi1,0)  >= NVL(fin_tsi,0)  THEN                              
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit; 
                                END IF;
                            END LOOP;
                            IF curr_exist = 'N' THEN
                                FOR C4 IN(SELECT b380.ann_tsi_amt
                                            FROM gipi_itmperil_grouped b380,
                                                 gipi_polbasic b250
                                           WHERE b250.line_cd      =  a1.line_cd
                                             AND b250.subline_cd   =  a1.subline_cd
                                             AND b250.iss_cd       =  a1.iss_cd
                                             AND b250.issue_yy     =  a1.issue_yy
                                             AND b250.pol_seq_no   =  a1.pol_seq_no
                                             AND b250.renew_no     =  a1.renew_no
                                             AND b250.policy_id    =  b380.policy_id
                                             AND b380.item_no      =  p_item_no
                                             AND b380.grouped_item_no      =  p_grouped_item_no
                                             AND b380.peril_cd     =  CHK_BASIC.peril_cd
                                             AND b250.pol_flag    IN ('1','2','3','X')
                                             AND b250.eff_date     >  v_eff_date 
                                             AND b250.eff_date     <  a1.eff_date
                                             AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                                 v_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= v_eff_date
                                           ORDER BY b250.eff_date DESC)
                                LOOP
                                    curr_exist := 'Y';
                                    IF NVL(c4.ann_tsi_amt,0) = 0 THEN
                                        EXIT;
                                    ELSIF NVL(c4.ann_tsi_amt,0) + NVL(b3_tsi1,0)  > NVL(fin_tsi,0)THEN                                 
                                        cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                        exit; 
                                    END IF;
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    /* check if the attached allied peril for this basic peril is existing */
                    FOR ALLIED_CHK IN (SELECT a170.peril_cd peril_cd
                                         FROM giis_peril a170
                                        WHERE a170.line_cd        = p_line_cd
                                          AND a170.peril_type     = 'A'
                                          AND a170.basc_perl_cd   = p_peril_cd)
                    LOOP
                        FOR C3 IN(SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                    FROM gipi_itmperil_grouped a
                                   WHERE a.policy_id    =  A1.policy_id
                                     AND a.item_no      =  p_item_no
                                     AND a.grouped_item_no      =  p_grouped_item_no
                                     AND a.peril_cd     =  ALLIED_CHK.peril_cd)
                        LOOP
                            b_peril      :=  NULL;
                            b_tsi        :=  0;
                            b_item       :=  NULL;
                            b_grouped_item       :=  NULL;
                            b_line       :=  NULL;
                            FOR i IN(SELECT *
                                       FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                            LOOP
                                b_peril      :=  i.peril_cd;
                                b_tsi        :=  i.tsi_amt;
                                IF b_peril   = allied_chk.peril_cd THEN
                                    c3.ann_tsi_amt := nvl(c3.ann_tsi_amt,0)+ nvl(b_tsi,0);
                                END IF;
                            END LOOP;
                            IF NVL(c3.ann_tsi_amt,0) = 0 THEN
                                EXIT;
                            ELSE 
                                attach_exist := 'Y';
                                att_tsi := c3.ann_tsi_amt;
                                exit; 
                            END IF;
                        END LOOP;
                    END LOOP;
                END IF;
                
                IF p_tsi_limit_sw = 'Y' THEN
                    IF comp_tsi != 0 AND comp_tsi < fin_tsi AND NVL(cnt_basic3,0) <= 0 THEN  
                        p_message := 'TSI Amount Entered will cause the Ann TSI Amount of this peril in endt no ' ||a1.endt_no||' to be less than an allied peril in the same endorsement.';
                        RETURN;
                    ELSIF NVL(comp_tsi,0) = 0 AND NVL(cnt_basic3,0) <= 0 AND allied_exist = 'Y' THEN
                        p_message := 'This basic peril cannot be zero out because there is an existing allied peril in endt no '||a1.endt_no||' which has an effecitivity date later than '||
                                      to_char(v_eff_date , 'fmMonth DD, YYYY');
                        RETURN;
                    ELSIF NVL(comp_tsi,0) = 0 AND allied_exist = 'Y' and ATTACH_EXIST = 'Y' THEN
                        p_message := 'This basic peril cannot be zero out because there is an existing allied peril attached to it in endt no '||a1.endt_no||' which has an effecitivity date later than '||
                                      to_char(v_eff_date , 'fmMonth DD, YYYY');
                        RETURN;
                    ELSIF comp_tsi != 0     AND comp_tsi < att_tsi AND allied_exist = 'Y' and ATTACH_EXIST = 'Y' THEN
                        p_message := 'TSI Amount Entered will cause the Ann TSI Amount of this peril in endt no ' ||a1.endt_no||' to be less than allied peril attached to it in the same endorsement.';
                        RETURN;
                    END IF;
                END IF;    
            ELSE
                /*Basic peril has an existing open allied peril*/
                FOR ALLIED2 IN (SELECT a170.peril_cd  peril_cd
                                  FROM giis_peril a170
                                 WHERE a170.line_cd        = p_line_cd
                                   AND a170.peril_type     = 'A'
                                   AND a170.basc_perl_cd   IS NULL)
                LOOP
                    prem_tsi  := 0;
                    FOR C1 IN ( SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                  FROM gipi_itmperil_grouped a
                                 WHERE a.policy_id    =  a1.policy_id
                                   AND a.item_no      =  p_item_no
                                   AND a.grouped_item_no      =  p_grouped_item_no
                                   AND a.peril_cd     =  allied2.peril_cd)
                    LOOP
                        sel_tsi := c1.ann_tsi_amt;
                        IF NVL(sel_tsi,0) = 0 THEN
                            EXIT;
                        ELSE
                            allied_exist := 'Y';                  
                            EXIT;
                        END IF;
                    END LOOP;
                    b_peril      :=  NULL;
                    b_tsi        :=  0;
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        b_peril      :=  i.peril_cd;
                        b_tsi        :=  i.tsi_amt1;
                        IF b_peril   = allied2.peril_cd THEN
                            sel_tsi := nvl(sel_tsi,0)+ nvl(b_tsi,0);
                        END IF;
                    END LOOP;
                    fin_tsi  := 0; --bdarusin  02182002
                    prem_tsi := nvl(sel_tsi,0);
                    IF NVL(fin_tsi,0) < prem_tsi THEN
                        fin_tsi := prem_tsi;
                    END IF;
                END LOOP;
                IF allied_exist = 'Y' THEN
                    FOR CHK_BASIC IN(SELECT a170.peril_cd 
                                       FROM giis_peril a170
                                      WHERE a170.line_cd        = p_line_cd
                                        AND a170.peril_type     = 'B'
                                        AND a170.peril_cd       <> p_peril_cd)
                    LOOP
                        b3_peril      :=  NULL;
                        b3_tsi        :=  0;
                        b3_tsi1       :=  0;
                        allied_rg := 'N';
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            b3_peril      :=  i.peril_cd;
                            b3_tsi        :=  i.tsi_amt;
                            b3_tsi1       :=  i.tsi_amt1;
                            IF b3_peril   = CHK_BASIC.peril_cd THEN                       
                                IF NVL(b3_tsi, 0) = 0 THEN 
                                    exit;
                                ELSIF NVL(b3_tsi, 0) >= NVL(fin_tsi,0) THEN
                                    allied_rg := 'Y';
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit;
                                END IF;
                            END IF;
                        END LOOP;
                        
                        IF allied_rg = 'N' then
                            curr_exist := 'N';
                            FOR C3 IN( SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                         FROM gipi_itmperil_grouped a
                                        WHERE a.policy_id    =  a1.policy_id
                                          AND a.item_no      =  p_item_no
                                          AND a.grouped_item_no      =  p_grouped_item_no
                                          AND a.peril_cd     =  CHK_BASIC.peril_cd)
                            LOOP
                                curr_exist := 'Y';
                                IF NVL(c3.ann_tsi_amt,0) = 0 THEN
                                    EXIT;
                                ELSIF NVL(c3.ann_tsi_amt,0) + NVL(b3_tsi1,0) >= NVL(fin_tsi,0) THEN                      
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit; 
                                END IF;
                            END LOOP;
                            
                            IF curr_exist = 'N' THEN
                                FOR C4 IN( SELECT b380.ann_tsi_amt
                                           FROM gipi_itmperil_grouped b380,
                                                gipi_polbasic b250
                                          WHERE b250.line_cd      =  a1.line_cd
                                            AND b250.subline_cd   =  a1.subline_cd
                                            AND b250.iss_cd       =  a1.iss_cd
                                            AND b250.issue_yy     =  a1.issue_yy
                                            AND b250.pol_seq_no   =  a1.pol_seq_no
                                            AND b250.renew_no     =  a1.renew_no
                                            AND b250.policy_id    =  b380.policy_id
                                            AND b380.item_no      =  p_item_no
                                            AND b380.grouped_item_no      =  p_grouped_item_no
                                            AND b380.peril_cd     =  CHK_BASIC.peril_cd
                                            AND b250.pol_flag     in('1','2','3','X')
                                            AND b250.eff_date     >  v_eff_date
                                            AND b250.eff_date     <  a1.eff_date
                                            AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                                v_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= v_eff_date
                                        ORDER BY b250.eff_date DESC)
                                LOOP
                                    IF NVL(c4.ann_tsi_amt,0) = 0 THEN
                                        EXIT;
                                    ELSIF NVL(c4.ann_tsi_amt,0)+ NVL(b3_tsi1,0) >= NVL(fin_tsi,0) THEN
                                        curr_exist := 'Y';
                                        cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                        exit; 
                                    END IF;
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                END IF;
                --added by rvirrey as commented by aliza  03052013
                FOR x1 IN( SELECT DISTINCT peril_cd, eff_date, b380.policy_id
                                       FROM gipi_itmperil_grouped b380, gipi_polbasic b250
                                      WHERE b250.line_cd = p_line_cd
                                        AND b250.subline_cd = p_subline_cd
                                        AND b250.iss_cd = p_iss_cd
                                        AND b250.issue_yy = p_issue_yy
                                        AND b250.pol_seq_no = p_pol_seq_no
                                        AND b250.renew_no = p_renew_no
                                        AND b250.policy_id = b380.policy_id
                                        AND b380.item_no = p_item_no
                                        AND b380.grouped_item_no = p_grouped_item_no
                                        AND b250.pol_flag IN ('1', '2', '3', 'X')
                                        AND b250.eff_date < v_eff_date --robert
                                        AND TRUNC (DECODE (NVL (b250.endt_expiry_date, b250.expiry_date),
                                                           b250.expiry_date, v_expiry_date,
                                                           b250.endt_expiry_date, b250.endt_expiry_date
                                                          )
                                                  ) >= v_eff_date
                                   ORDER BY b250.eff_date)
                LOOP
                    SELECT SUM (tsi_amt)
                      INTO act_tsi_amt
                      FROM gipi_itmperil_grouped
                     WHERE peril_cd = x1.peril_cd
                       AND policy_id = x1.policy_id
                       AND item_no = p_item_no
                       AND grouped_item_no = p_grouped_item_no;
                       
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            IF i.peril_cd   = x1.peril_cd THEN
                                act_tsi_amt := nvl(act_tsi_amt,0)+ nvl(i.tsi_amt,0);
                            END IF;
                        END LOOP;
                        IF NVL(act_tsi_amt,0) <> 0 THEN
                            act_allied_exist := 'Y';
                            EXIT;
                        END IF;
                END LOOP;
                
                --end of code added by rvirrey as commented by aliza  03052013
                IF p_tsi_limit_sw = 'Y' THEN
                    IF comp_tsi != 0  THEN 
                        IF comp_tsi < fin_tsi AND NVL(cnt_basic3,0) < 1 THEN  
                            p_message := 'Tsi Amount Entered will cause the Ann TSI Amount of this peril in endt no ' ||a1.endt_no||' to be less than an allied peril in the same endorsement.';
                            RETURN;
                        END IF;
                    --ELSIF NVL(comp_tsi,0) = 0 AND NVL(cnt_basic3,0)  AND allied_exist = 'Y' THEN    --comment out by rvirrey  
                    ELSIF NVL(comp_tsi,0) = 0 AND (NVL(cnt_basic3,0) < 1 AND act_allied_exist = 'Y') AND allied_exist = 'Y' THEN 
                    --added by rvirrey as commented by aliza  03052013
                        p_message := 'This basic peril cannot be zero out because there is an existing allied peril in endt no '||
                                      a1.endt_no||' which has an effecitivity date later than '||
                                      to_char(v_eff_date , 'fmMonth DD, YYYY');
                        RETURN;
                    END IF;
                END IF;
            END IF;
        ELSIF p_peril_type = 'A'  THEN
            IF p_basc_perl_cd IS NULL  THEN
                /*Open allied peril*/
                FOR BASIC1 IN( SELECT distinct b380.peril_cd
                                 FROM giis_peril    a170,
                                      gipi_itmperil_grouped b380,
                                      gipi_polbasic b250
                                 WHERE b250.policy_id    =  a1.policy_id
                                   AND b250.policy_id    =  b380.policy_id
                                   AND b380.line_cd      =  a170.line_cd      
                                   AND b380.peril_cd     =  a170.peril_cd                
                                   AND b380.item_no      =  p_item_no                
                                   AND b380.grouped_item_no      =  p_grouped_item_no                
                                   AND a170.peril_type   = 'B'                
                                   AND b250.pol_flag     in('1','2','3','X')) 
                LOOP
                    prem_tsi  := null;
                    FOR C1 IN ( SELECT A.ann_tsi_amt     ann_tsi_amt
                                  FROM gipi_itmperil_grouped A
                                 WHERE A.policy_id    =  A1.policy_id
                                   AND A.item_no      =  p_item_no
                                   AND A.grouped_item_no      =  p_grouped_item_no
                                   AND A.peril_cd     =  BASIC1.peril_cd)
                    LOOP
                        sel_tsi := c1.ann_tsi_amt;
                        b_peril      :=  NULL;
                        b_tsi        :=  0;
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            b_peril      :=  i.peril_cd;
                            b_tsi        :=  i.tsi_amt;
                            IF b_peril   = basic1.peril_cd THEN
                                sel_tsi := nvl(sel_tsi,0)+ nvl(b_tsi,0);
                            END IF;
                        END LOOP;
                        
                        IF nvl(sel_tsi,0) > 0 THEN
                            cnt_basic := NVL(cnt_basic, 0) + 1;
                        END IF;
                        EXIT;
                    END LOOP;
                    prem_tsi := sel_tsi;
                    IF NVL(fin_tsi,0) = 0  AND NVL(prem_tsi,0) > 0 THEN
                        fin_tsi := prem_tsi;
                    END IF;
                    IF nvl(fin_tsi,0) < prem_tsi AND NVL(fin_tsi,0) > 0 and NVL(prem_tsi,0) > 0 THEN
                        fin_tsi := prem_tsi;
                    END IF;
                END LOOP;
                IF COMP_TSI > FIN_TSI AND p_tsi_limit_sw = 'Y' THEN  
                    p_message := 'Tsi Amount entered will cause the Ann TSI Amount of this peril '||
                             '    to be greater than one of the basic peril in '||a1.endt_no||'.';
                    RETURN;
                END IF;
            ELSE
                /*Existing allied peril with basic*/
                prem_tsi  := null;
                FOR C1 IN ( SELECT A.ann_tsi_amt     ann_tsi_amt
                              FROM gipi_itmperil_grouped A
                             WHERE A.policy_id    =  A1.policy_id
                               AND A.item_no      =  p_item_no
                               AND A.grouped_item_no      =  p_grouped_item_no
                               AND A.peril_cd     =  p_basc_perl_cd)  -- XXXXXXXXXXXXX
                LOOP
                    sel_tsi := c1.ann_tsi_amt;
                    b_peril      :=  NULL;
                    b_tsi        :=  0;
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        b_peril      :=  i.peril_cd;
                        b_tsi        :=  i.tsi_amt;
                        IF b_peril   = p_basc_perl_cd THEN -- XXXXXXXXXX
                            sel_tsi := nvl(sel_tsi,0)+ nvl(b_tsi,0);
                        END IF;
                    END LOOP;
                    EXIT;
                END LOOP;
                prem_tsi := sel_tsi;
                IF fin_tsi < prem_tsi THEN
                    fin_tsi := prem_tsi;
                END IF;
                IF COMP_TSI > FIN_TSI AND p_tsi_limit_sw = 'Y' THEN  
                    p_message := 'Tsi Amount entered will cause the Ann TSI Amount of this peril '||
                                 'to be greater than the basic peril attached to it in '||a1.endt_no||'.';
                    RETURN;
                END IF;
            END IF;
        END IF; -- peril_type    
    END LOOP;
    p_message := 'SUCCESS';
END;
/


