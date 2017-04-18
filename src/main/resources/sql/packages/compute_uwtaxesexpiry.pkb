CREATE OR REPLACE PACKAGE BODY CPI.COMPUTE_UWTaxesExpiry AS
/*
**  Created by :    Sherry
**  Date Created:   06-06-2013
**  Created to correct the tax amount generated by Process_Expiring_Policies to be inserted in giex_old_group_tax (PROCEDURE compute_old_group_tax)
**  and to compute tax amount to be inserted in giex_new_group_tax basing on the data from giex_itmperil in GIEXS007 (PROCEDURE compute_new_group_tax)
*/  

FUNCTION recompute_prem_amt (p_policy_id NUMBER,
                             p_tax_cd NUMBER,
                             p_tax_id NUMBER,
                             p_line_cd VARCHAR2,
                             p_iss_cd VARCHAR2)
    RETURN NUMBER     
IS
    v_prem_amt1 giex_old_group_peril.prem_amt%TYPE;
    
BEGIN

    SELECT a.prem_amt
    INTO v_prem_amt1
    FROM giex_old_group_peril a, giis_tax_peril b
    WHERE a.line_cd = b.line_cd
    AND a.peril_cd = b.peril_cd
    AND a.policy_id = p_policy_id
    AND b.tax_cd = p_tax_cd
    AND b.tax_id = p_tax_id
    AND b.line_cd = p_line_cd
    AND b.iss_cd = p_iss_cd; 

RETURN v_prem_amt1;

END;

FUNCTION get_tax_range (p_amount NUMBER,        -- FUNCTION EDGAR
                        p_currency_rt NUMBER,
                        p_line_cd VARCHAR2,
                        p_iss_cd VARCHAR2,
                        p_tax_cd NUMBER,
                        p_tax_id NUMBER)
RETURN NUMBER IS 

v_amount NUMBER := p_amount;
v_currency_rt NUMBER := p_currency_rt;
v_tax_amt NUMBER;

BEGIN   

  
    SELECT tax_amount/NVL(v_currency_rt,1) 
      INTO v_tax_amt
      FROM giis_tax_range
     WHERE line_cd = p_line_cd
       AND iss_cd = p_iss_cd
       AND tax_cd = p_tax_cd
       AND tax_id = p_tax_id
       AND (v_amount*v_currency_rt) BETWEEN min_value AND max_value;
       
    RETURN (v_tax_amt);  
      
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).', TRUE);
       
   

END;

PROCEDURE compute_old_group_tax (
    p_from_month    VARCHAR2,
    p_to_month      VARCHAR2,
    p_from_year     NUMBER,
    p_to_year       NUMBER,
    p_from_date     DATE,
    p_to_date       DATE,
    p_line_cd       VARCHAR2,
    p_subline_cd    VARCHAR2,
    p_iss_cd        VARCHAR2,
    p_issue_yy      NUMBER,
    p_pol_seq_no    NUMBER,
    p_renew_no      NUMBER)
IS
    v_policy_id         giex_old_group_peril.policy_id%TYPE;
    v_prem_amt          giex_old_group_peril.prem_amt%TYPE;
    v_tsi_amt           giex_old_group_peril.tsi_amt%TYPE;
    v_vat_tag           giis_assured.vat_tag%TYPE;
    v_tax_cd            giis_tax_charges.tax_cd%TYPE;
    v_tax_id            giis_tax_charges.tax_id%TYPE;
    v_iss_cd            giis_tax_charges.iss_cd%TYPE;
    v_line_cd           giis_tax_charges.line_cd%TYPE;
    v_rate              giis_tax_charges.rate%TYPE;
    v_tax_type          giis_tax_charges.tax_type%TYPE;
    v_tax_amount        giis_tax_charges.tax_amount%TYPE;   
    v_peril_sw          giis_tax_charges.peril_sw%TYPE;
    v_menu_line_cd      giis_line.menu_line_cd%TYPE;
    v_assd_no           giis_assured.assd_no%TYPE;
    v_min               giis_tax_range.min_value%TYPE;
    v_max               giis_tax_range.max_value%TYPE;
    v_currency_rt       NUMBER;
    v_tax_desc          giis_tax_charges.tax_desc%TYPE;
    v_currency_prem_amt giex_expiry.currency_prem_amt%TYPE;
    

BEGIN   

FOR h IN (SELECT policy_id
          FROM giex_expiry
          WHERE line_cd = p_line_cd
          AND subline_cd = p_subline_cd
          AND iss_cd = p_iss_cd
          AND issue_yy  = p_issue_yy
          AND pol_seq_no = p_pol_seq_no
          AND renew_no = p_renew_no)
    LOOP
        v_policy_id := h.policy_id;
         
        BEGIN         
        DELETE FROM giex_old_group_tax
        WHERE policy_id = v_policy_id;
        COMMIT;
        END;
        
        FOR i IN (SELECT prem_amt, tsi_amt
                  FROM giex_old_group_peril
                  WHERE policy_id = h.policy_id)
          
       LOOP
          
          v_prem_amt :=  i.prem_amt;
          v_tsi_amt := i.tsi_amt;   

        FOR j IN (SELECT a.tax_cd,
                         a.tax_id,
                         a.iss_cd,
                         a.line_cd,
                         NVL(a.rate,0) rate,
                         a.tax_type,
                         a.tax_amount,
                         a.peril_sw,    
                         a.tax_desc, 
                         b.currency_prem_amt
                    FROM giis_tax_charges a, giex_expiry b
                   WHERE a.primary_sw = 'Y'                   
                     AND b.incept_date BETWEEN a.eff_start_date AND  a.eff_end_date
                     AND a.line_cd = b.line_cd
                     AND a.iss_cd = b.iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND b.subline_cd = p_subline_cd
                     AND b.issue_yy = p_issue_yy
                     AND b.pol_seq_no = p_pol_seq_no
                     AND b.renew_no = p_renew_no)
          
         LOOP
          
                    v_tax_cd            :=  j.tax_cd;
                    v_tax_id            :=  j.tax_id;
                    v_iss_cd            :=  j.iss_cd;
                    v_line_cd           :=  j.line_cd;
                    v_rate              :=  j.rate;
                    v_tax_type          :=  j.tax_type;
                    v_peril_sw          :=  j.peril_sw;
                    v_tax_desc          :=  j.tax_desc;
                    v_currency_prem_amt :=  j.currency_prem_amt;         
                                  
                        SELECT NVL(b.vat_tag,3)
                        INTO v_vat_tag
                        FROM giex_expiry a, giis_assured b
                        WHERE  a.assd_no = b.assd_no
                        AND a.policy_id = v_policy_id;
                                
           IF v_tax_cd = giacp.n('DOC_STAMPS') THEN -- FOR DOC STAMPS
                      
                    SELECT NVL(menu_line_cd, line_cd)
                    INTO v_menu_line_cd
                    FROM giis_line
                    WHERE line_cd = p_line_cd;
                    
                    SELECT prem_amt/currency_prem_amt
                    INTO v_currency_rt
                    FROM giex_old_group_peril
                    WHERE policy_id = v_policy_id;
                     
                IF v_menu_line_cd = 'AC' THEN -- FOR PA
            
                    IF giisp.v('COMPUTE_PA_DOC_STAMPS') = '3' AND  v_tax_type = 'N' THEN    --RANGE
                       v_tax_amount := COMPUTE_UWTaxesExpiry.get_tax_range(v_tsi_amt, 
                                                                           v_currency_rt,
                                                                           v_line_cd,
                                                                           v_iss_cd,
                                                                           v_tax_cd,
                                                                           v_tax_id); 
                                                         
                    ELSIF giisp.v('COMPUTE_PA_DOC_STAMPS') = '2' THEN   --OLD DST COMPUTATION (CEIL(v_prem_amt/200) * 0.5)
                        v_tax_amount := (CEIL(v_prem_amt/200) * 0.5)/v_currency_rt;
                
                    ELSE --RATE (total premium)
                    
                        IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN 
                            v_tax_amount := (CEIL(v_prem_amt/200) * 0.5)/v_currency_rt;
                            
                        ELSE
                        
                        v_tax_amount := v_prem_amt * (v_rate/100);
                        
                        END IF;
             
                    END IF;
             
                ELSE --FOR NON-PA
                                 
                    IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN --OLD DST COMPUTATION (CEIL(v_prem_amt/4) * 0.5)
                        v_tax_amount := (CEIL(v_prem_amt/4) * 0.5)/NVL(v_currency_rt,1);
                    
                    ELSE
                        v_tax_amount := (v_prem_amt * (v_rate/100))/NVL(v_currency_rt,1);  --RATE (total premium)
                    
                    END IF;
                                
          
                END IF;  
                   
            ELSIF v_tax_cd = giacp.n('EVAT') THEN   -- FOR EVAT
            
                IF v_vat_tag IN ('1','2') THEN  --VAT EXEMPT/ZERO RATED
           
                    FOR k IN(SELECT a.assd_no 
                             FROM giex_expiry a, giis_assured b
                             WHERE  a.assd_no = b.assd_no)
                         
                        LOOP
                        
                            v_assd_no := k.assd_no;
                 
                        END LOOP;
                
                            UPDATE giex_expiry
                            SET tax_amt = 0
                            WHERE  assd_no = v_assd_no;
                
                ELSE    --RATE (consider peril dependent)
                
                    IF v_peril_sw = 'Y' THEN
                    
                    v_prem_amt := (COMPUTE_UWTaxesExpiry.recompute_prem_amt(v_policy_id, v_tax_cd, v_tax_id, p_line_cd, p_iss_cd))/v_currency_rt;
                    v_tax_amount := (v_prem_amt/v_currency_rt) * (v_rate/100);
                    
                    ELSE
                    
                    v_tax_amount := (v_prem_amt/v_currency_rt) * (v_rate/100);
                    
                    END IF;
                    
                END IF;
          
            ELSE    --OTHERS
            
                IF v_tax_type = 'N' THEN    --RANGE (based on premium)

                     v_tax_amount := COMPUTE_UWTaxesExpiry.get_tax_range(v_prem_amt, 
                                                                         v_currency_rt,
                                                                         v_line_cd,
                                                                         v_iss_cd,
                                                                         v_tax_cd,
                                                                         v_tax_id); 
                     
                ELSIF v_tax_type = 'A' THEN --FIXED AMOUNT
                                
                    v_tax_amount := v_tax_amount;
            
                ELSE    --RATE (consider peril dependent)
                
                    IF v_peril_sw = 'Y' THEN
                
                        v_prem_amt := (COMPUTE_UWTaxesExpiry.recompute_prem_amt(v_policy_id, v_tax_cd, v_tax_id, p_line_cd, p_iss_cd))/v_currency_rt;
                        v_tax_amount :=  v_prem_amt * (v_rate/100);
                        
                    ELSE
                    
                        v_tax_amount :=  (v_prem_amt/NVL(v_currency_rt,1)) * (v_rate/100);
                   
                    END IF;
            
                END IF;
          
           END IF;             
            
            BEGIN
            INSERT INTO giex_old_group_tax (policy_id,line_cd,iss_cd,tax_cd,tax_id,tax_desc,tax_amt,currency_tax_amt)
            VALUES (v_policy_id, v_line_cd, v_iss_cd, v_tax_cd, v_tax_id, v_tax_desc, NVL(v_tax_amount,0), NVL(v_tax_amount,0)/NVL(v_currency_rt,1));
          --  COMMIT;  -- jhing 06.29.2013 commented out 
            END;
    
         END LOOP;
         
       END LOOP;  
           
    END LOOP;
    
END;

PROCEDURE compute_new_group_tax (
    p_policy_id     NUMBER,
    p_line_cd       VARCHAR2,
    p_subline_cd    VARCHAR2,
    p_iss_cd        VARCHAR2,
    p_item_no       NUMBER,
    p_peril_cd      NUMBER)

IS
    v_policy_id     giex_itmperil.policy_id%TYPE;
    v_prem_amt      giex_itmperil.prem_amt%TYPE;
    v_tsi_amt       giex_itmperil.tsi_amt%TYPE;
    v_currency_rt   giex_itmperil.currency_rt%TYPE;
    v_iss_cd        giis_tax_charges.iss_cd%TYPE;
    v_tax_cd        giis_tax_charges.tax_cd%TYPE;
    v_tax_id        giis_tax_charges.tax_id%TYPE;
    v_menu_line_cd  giis_line.menu_line_cd%TYPE;
    v_vat_tag       giis_assured.vat_tag%TYPE;
    v_tax_type      giis_tax_charges.tax_type%TYPE;
    v_tax_amount    giis_tax_charges.tax_amount%TYPE;
    v_line_cd       giis_tax_charges.line_cd%TYPE   :=  p_line_cd;
    v_rate          giis_tax_charges.rate%TYPE;   
    v_assd_no       giis_assured.assd_no%TYPE;
    v_peril_sw      giis_tax_charges.peril_sw%TYPE;
    v_tax_desc      giis_tax_charges.tax_desc%TYPE;
    v_incept_date   giex_expiry.incept_date%TYPE;
        
BEGIN
     BEGIN
     DELETE FROM giex_new_group_tax
     WHERE policy_id = p_policy_id;
     
     commit;
    END;
     
     FOR dat IN (SELECT /*incept_date*/ expiry_date  --jongs 06282013
                 FROM giex_expiry 
                 WHERE policy_id = p_policy_id)
     LOOP
        v_incept_date := dat.expiry_date;--dat.incept_date;
     END LOOP;
                      
        FOR l IN (SELECT policy_id, prem_amt, tsi_amt, currency_rt 
              FROM giex_itmperil
              WHERE policy_id = p_policy_id
              AND line_cd = p_line_cd
              AND subline_cd = p_subline_cd
              AND item_no = p_item_no
              AND peril_cd = p_peril_cd)
             
        LOOP
            v_policy_id     :=  l.policy_id;
            v_prem_amt      :=  l.prem_amt;
            v_tsi_amt       :=  l.tsi_amt;
            v_currency_rt   :=  l.currency_rt;
        END LOOP;
        
        FOR m IN (SELECT a.iss_cd, a.tax_cd, a.tax_desc, a.tax_id, a.tax_type, NVL(a.rate , 0) rate
                    FROM giis_tax_charges a, giex_itmperil b
                   WHERE b.policy_id = v_policy_id
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.line_cd = b.line_cd
                     AND b.item_no = p_item_no
                     AND /*ADD_MONTHS (v_incept_date, 12)*/ v_incept_date BETWEEN a.eff_start_date AND  a.eff_end_date
                     AND a.primary_sw = 'Y'
                     ) 
        LOOP
            v_iss_cd    :=  m.iss_cd;
            v_tax_cd    :=  m.tax_cd;
            v_tax_desc  :=  m.tax_desc;
            v_tax_id    :=  m.tax_id;
            v_tax_type  :=  m.tax_type;
            v_rate      :=  m.rate;

            
        IF v_tax_cd = giacp.n('DOC_STAMPS') THEN -- FOR DOC STAMPS
                      
            SELECT NVL(menu_line_cd, line_cd)
            INTO v_menu_line_cd
            FROM giis_line
            WHERE line_cd = p_line_cd;
                                        
                IF v_menu_line_cd = 'AC' THEN -- FOR PA 
                                    
                    IF giisp.v('COMPUTE_PA_DOC_STAMPS') = '3' AND  v_tax_type = 'N' THEN    --RANGE
                       v_tax_amount := COMPUTE_UWTaxesExpiry.get_tax_range(v_tsi_amt, 
                                                                           v_currency_rt,
                                                                           v_line_cd,
                                                                           v_iss_cd,
                                                                           v_tax_cd,
                                                                           v_tax_id);                                                                             
                                                         
                    ELSIF giisp.v('COMPUTE_PA_DOC_STAMPS') = '2' THEN   --OLD DST COMPUTATION (CEIL(v_prem_amt/200) * 0.5)
                        v_tax_amount := (CEIL(v_prem_amt/200) * 0.5)/v_currency_rt;
                
                    ELSE --RATE (total premium)
                    
                        IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN 
                            v_tax_amount := (CEIL(v_prem_amt/200) * 0.5)/v_currency_rt;
                            
                        ELSE
                            v_tax_amount := v_prem_amt * (v_rate/100);
                        
                        END IF;
             
                    END IF;
                    
                ELSE --FOR NON-PA
                                 
                    IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN --OLD DST COMPUTATION (CEIL(v_prem_amt/4) * 0.5) 
                        v_tax_amount := (CEIL(v_prem_amt/4) * 0.5)/v_currency_rt;
                    
                    ELSE
                        v_tax_amount := (v_prem_amt * (v_rate/100))/v_currency_rt;  --RATE (total premium)
                    
                    END IF;
                                
          
                END IF;  
                
                ELSIF v_tax_cd = giacp.n('EVAT') THEN   --FOR EVAT
            
                IF v_vat_tag IN ('1','2') THEN  --VAT EXEMPT/ZERO RATED
           
                    FOR k IN(SELECT a.assd_no 
                             FROM giex_expiry a, giis_assured b
                             WHERE  a.assd_no = b.assd_no)
                         
                        LOOP
                        
                            v_assd_no := k.assd_no;
                 
                        END LOOP;
                
                            UPDATE giex_expiry
                            SET tax_amt = 0
                            WHERE  assd_no = v_assd_no;
                
                ELSE    --RATE (consider peril dependent)
           
                    IF v_peril_sw = 'Y' THEN
                
                        v_prem_amt := (COMPUTE_UWTaxesExpiry.recompute_prem_amt(v_policy_id, v_tax_cd, v_tax_id, p_line_cd, p_iss_cd))/v_currency_rt;
                        v_tax_amount :=  v_prem_amt * (v_rate/100);
                        
                    ELSE
                    
                        v_tax_amount :=  (v_prem_amt/v_currency_rt) * (v_rate/100);
                   
                    END IF;
            
                END IF;
          
            ELSE    --OTHERS
            
                IF v_tax_type = 'N' THEN --RANGE

                     v_tax_amount := COMPUTE_UWTaxesExpiry.get_tax_range(v_prem_amt, 
                                                                         v_currency_rt,
                                                                         v_line_cd,
                                                                         v_iss_cd,
                                                                         v_tax_cd,
                                                                         v_tax_id); 
                     
                ELSIF v_tax_type = 'A' THEN --FIXED AMOUNT (based on premium)
                                
                    v_tax_amount := v_tax_amount;
            
                ELSE    --RATE (consider peril dependent)
                
                    IF v_peril_sw = 'Y' THEN
                
                        v_prem_amt := (COMPUTE_UWTaxesExpiry.recompute_prem_amt(v_policy_id, v_tax_cd, v_tax_id, p_line_cd, p_iss_cd))/v_currency_rt;
                        v_tax_amount :=  v_prem_amt * (v_rate/100);
                        
                    ELSE
                    
                        v_tax_amount :=  (v_prem_amt/v_currency_rt) * (v_rate/100);
                   
                    END IF;
            
                END IF;
          
           END IF; 
           
   
    BEGIN    
        INSERT INTO giex_new_group_tax (policy_id, line_cd, iss_cd, tax_cd, tax_id, tax_desc, tax_amt, rate, currency_tax_amt)
        VALUES (p_policy_id, p_line_cd, p_iss_cd, v_tax_cd, v_tax_id, v_tax_desc, v_tax_amount, v_rate, v_tax_amount/v_currency_rt);
        
        COMMIT;
    END;          
                    
        
        
    END LOOP;    
END;

/*Created by: Joanne
**Date: 011314
**Desc: populate expiry tax for GENWEB*/
PROCEDURE compute_new_group_tax2 (
    p_policy_id     NUMBER,
    p_line_cd       VARCHAR2,
    p_subline_cd    VARCHAR2,
    p_iss_cd        VARCHAR2)

IS
    v_policy_id     giex_itmperil.policy_id%TYPE;
    v_prem_amt      giex_itmperil.prem_amt%TYPE;
    v_tsi_amt       giex_itmperil.tsi_amt%TYPE;
    v_currency_rt   giex_itmperil.currency_rt%TYPE;
    v_iss_cd        giis_tax_charges.iss_cd%TYPE;
    v_tax_cd        giis_tax_charges.tax_cd%TYPE;
    v_tax_id        giis_tax_charges.tax_id%TYPE;
    v_menu_line_cd  giis_line.menu_line_cd%TYPE;
    v_vat_tag       giis_assured.vat_tag%TYPE;
    v_tax_type      giis_tax_charges.tax_type%TYPE;
    v_tax_amount    giis_tax_charges.tax_amount%TYPE;
    v_line_cd       giis_tax_charges.line_cd%TYPE   :=  p_line_cd;
    v_rate          giis_tax_charges.rate%TYPE;   
    v_assd_no       giis_assured.assd_no%TYPE;
    v_peril_sw      giis_tax_charges.peril_sw%TYPE;
    v_tax_desc      giis_tax_charges.tax_desc%TYPE;
    v_incept_date   giex_expiry.incept_date%TYPE;
        
BEGIN
     BEGIN
     DELETE FROM giex_new_group_tax
     WHERE policy_id = p_policy_id;
     
     commit;
    END;
     
     FOR dat IN (SELECT /*incept_date*/ expiry_date  --jongs 06282013
                 FROM giex_expiry 
                 WHERE policy_id = p_policy_id)
     LOOP
        v_incept_date := dat.expiry_date;--dat.incept_date;
     END LOOP;
                      
       FOR l IN (SELECT policy_id, prem_amt, tsi_amt, currency_rt 
              FROM giex_itmperil
              WHERE policy_id = p_policy_id
              AND line_cd = p_line_cd
              AND subline_cd = p_subline_cd)
        LOOP
            v_policy_id     :=  l.policy_id;
            --v_prem_amt      :=  l.prem_amt;
            --v_tsi_amt       :=  l.tsi_amt;
            v_currency_rt   :=  l.currency_rt;
        END LOOP;
        
          FOR prem IN (SELECT  sum(NVL(prem_amt,0)) prem_amt
                      FROM  giex_itmperil
                     WHERE  policy_id   = p_policy_id)
                      -- AND  item_no     = NVL(p_item_no, item_no)) 
          LOOP
             v_prem_amt      :=  prem.prem_amt;
          END LOOP;
      
          FOR tsi IN (SELECT  sum(NVL(a.tsi_amt,0)) tsi_amt             
                      FROM  giex_itmperil a,giis_peril b
                     WHERE  a.line_cd    =  b.line_cd
                       AND  a.peril_cd   =  b.peril_cd
                       AND  b.peril_type =  'B'
                       AND  a.policy_id  =  p_policy_id)
                      -- AND  item_no      =  NVL(p_item_no, item_no)) 
          LOOP
             v_tsi_amt       :=  tsi.tsi_amt;            
          END LOOP;
        
        FOR m IN (SELECT DISTINCT a.tax_cd, a.iss_cd,  a.tax_desc, a.tax_id, a.tax_type, NVL(a.rate , 0) rate
                    FROM giis_tax_charges a, giex_itmperil b
                   WHERE b.policy_id = v_policy_id
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.line_cd = b.line_cd
                    -- AND b.item_no = NVL(p_item_no, item_no)
                     AND /*ADD_MONTHS (v_incept_date, 12)*/ v_incept_date BETWEEN a.eff_start_date AND  a.eff_end_date
                     AND a.primary_sw = 'Y'
                     ) 
        LOOP
            v_iss_cd    :=  m.iss_cd;
            v_tax_cd    :=  m.tax_cd;
            v_tax_desc  :=  m.tax_desc;
            v_tax_id    :=  m.tax_id;
            v_tax_type  :=  m.tax_type;
            v_rate      :=  m.rate;

            
        IF v_tax_cd = giacp.n('DOC_STAMPS') THEN -- FOR DOC STAMPS
                      
            SELECT NVL(menu_line_cd, line_cd)
            INTO v_menu_line_cd
            FROM giis_line
            WHERE line_cd = p_line_cd;
                                        
                IF v_menu_line_cd = 'AC' THEN -- FOR PA 
                                    
                    IF giisp.v('COMPUTE_PA_DOC_STAMPS') = '3' AND  v_tax_type = 'N' THEN    --RANGE
                       v_tax_amount := COMPUTE_UWTaxesExpiry.get_tax_range(v_tsi_amt, 
                                                                           v_currency_rt,
                                                                           v_line_cd,
                                                                           v_iss_cd,
                                                                           v_tax_cd,
                                                                           v_tax_id);                                                                             
                                                         
                    ELSIF giisp.v('COMPUTE_PA_DOC_STAMPS') = '2' THEN   --OLD DST COMPUTATION (CEIL(v_prem_amt/200) * 0.5)
                        v_tax_amount := (CEIL(v_prem_amt/200) * 0.5)/v_currency_rt;
                
                    ELSE --RATE (total premium)
                    
                        IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN 
                            v_tax_amount := (CEIL(v_prem_amt/200) * 0.5)/v_currency_rt;
                            
                        ELSE
                            v_tax_amount := v_prem_amt * (v_rate/100);
                        
                        END IF;
             
                    END IF;
                    
                ELSE --FOR NON-PA
                                 
                    IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN --OLD DST COMPUTATION (CEIL(v_prem_amt/4) * 0.5) 
                        v_tax_amount := (CEIL(v_prem_amt/4) * 0.5)/v_currency_rt;
                    
                    ELSE
                        v_tax_amount := (v_prem_amt * (v_rate/100))/v_currency_rt;  --RATE (total premium)
                    
                    END IF;
                                
          
                END IF;  
                
                ELSIF v_tax_cd = giacp.n('EVAT') THEN   --FOR EVAT
            
                IF v_vat_tag IN ('1','2') THEN  --VAT EXEMPT/ZERO RATED
           
                    FOR k IN(SELECT a.assd_no 
                             FROM giex_expiry a, giis_assured b
                             WHERE  a.assd_no = b.assd_no)
                         
                        LOOP
                        
                            v_assd_no := k.assd_no;
                 
                        END LOOP;
                
                            UPDATE giex_expiry
                            SET tax_amt = 0
                            WHERE  assd_no = v_assd_no;
                
                ELSE    --RATE (consider peril dependent)
           
                    IF v_peril_sw = 'Y' THEN
                
                        v_prem_amt := (COMPUTE_UWTaxesExpiry.recompute_prem_amt(v_policy_id, v_tax_cd, v_tax_id, p_line_cd, p_iss_cd))/v_currency_rt;
                        v_tax_amount :=  v_prem_amt * (v_rate/100);
                        
                    ELSE
                    
                        v_tax_amount :=  (v_prem_amt/v_currency_rt) * (v_rate/100);
                   
                    END IF;
            
                END IF;
          
            ELSE    --OTHERS
            
                IF v_tax_type = 'N' THEN --RANGE

                     v_tax_amount := COMPUTE_UWTaxesExpiry.get_tax_range(v_prem_amt, 
                                                                         v_currency_rt,
                                                                         v_line_cd,
                                                                         v_iss_cd,
                                                                         v_tax_cd,
                                                                         v_tax_id); 
                     
                ELSIF v_tax_type = 'A' THEN --FIXED AMOUNT (based on premium)
                                
                    v_tax_amount := v_tax_amount;
            
                ELSE    --RATE (consider peril dependent)
                
                    IF v_peril_sw = 'Y' THEN
                
                        v_prem_amt := (COMPUTE_UWTaxesExpiry.recompute_prem_amt(v_policy_id, v_tax_cd, v_tax_id, p_line_cd, p_iss_cd))/v_currency_rt;
                        v_tax_amount :=  v_prem_amt * (v_rate/100);
                        
                    ELSE
                    
                        v_tax_amount :=  (v_prem_amt/v_currency_rt) * (v_rate/100);
                   
                    END IF;
            
                END IF;
          
           END IF; 
           
   
    BEGIN    
        INSERT INTO giex_new_group_tax (policy_id, line_cd, iss_cd, tax_cd, tax_id, tax_desc, tax_amt, rate, currency_tax_amt)
        VALUES (p_policy_id, p_line_cd, p_iss_cd, v_tax_cd, v_tax_id, v_tax_desc, v_tax_amount, v_rate, v_tax_amount/v_currency_rt);
    END;          
   
    END LOOP;    
END;

          
END COMPUTE_UWTaxesExpiry;
/

DROP PACKAGE BODY CPI.COMPUTE_UWTAXESEXPIRY;
