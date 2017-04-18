DROP PROCEDURE CPI.COMPUTE_DOCSTAMPS;

CREATE OR REPLACE PROCEDURE CPI.COMPUTE_DOCSTAMPS (p_par_id IN NUMBER) IS
/* 
/* last modified by bhev  9/12/2011
** modification : include effectivity and expiry date condition for tax_charges
*/
/**/
/* last modified by jhing  01/19/2012
** modification : include parameter 'ALLOW_NEGATIVE_DST' in updating gipi_inv_tax for negative EDST
                : considers currency_rt in setting up the correct tax amount for range 
*/
/*
**  Modified by Udel 09062012
**  Commented out COMMIT codes to prevent commiting changes if the user did not save changes.
*/


/*
**  Modified by Jeff 05.27.2013
**  Revised script in retrieving tax range at line 233
*/
   
CURSOR a1 IS
    SELECT A.line_cd line_cd, A.iss_cd iss_cd, b.tsi_amt tsi_amt
                , d.currency_rt --added by jhing 01.19.2012 
                , b.prem_amt prem_amt,c.peril_type
                -- 09092011 - to check for tax_cd
                , a.incept_date
            FROM gipi_wpolbas A,gipi_witmperl b, giis_peril c 
                , gipi_witem D -- jhing 12/21/2011 added this link to consider currency rates in the checking of TSI
        WHERE 1=1
           AND A.par_id = b.par_id
           AND b.line_cd = c.line_cd
           AND b.peril_cd = c.peril_cd
           AND A.PAR_ID = p_par_id
           -- jhing 12/21/2011 added the following link conditions to gipi_witem
           AND b.item_no = d.item_no
           and b.par_id = d.par_id; 
 
v_param_old_doc     giis_parameters.param_value_v%TYPE:=giisp.v('COMPUTE_OLD_DOC_STAMPS');
v_param_pa_doc      giis_parameters.param_value_v%TYPE:=giisp.v('COMPUTE_PA_DOC_STAMPS');
v_line_cd           giis_line.line_cd%TYPE;
v_mline_cd          giis_line.line_cd%TYPE;
v_iss_cd            giis_issource.iss_cd%TYPE;
v_tsi_amt           gipi_polbasic.tsi_amt%TYPE:=0;
v_prem_amt          gipi_polbasic.prem_amt%TYPE:=0;

v_tax               gipi_invoice.tax_amt%TYPE:=0;
v_tax_amt           gipi_invoice.tax_amt%TYPE:=0;
v_tax_rt            giis_tax_charges.rate%TYPE:=0;
v_sum_tax_amt       GIPI_WINVOICE.tax_amt%TYPE; -- grace 05.27.2011

--09092011
v_incept_date       gipi_wpolbas.incept_date%TYPE;
v_tax_id            giis_tax_charges.tax_id%TYPE;
v_currency_rt       gipi_witem.currency_rt%TYPE;  -- jhing 01.19.2012 
v_takeup_alloc_tag  giis_tax_charges.takeup_alloc_tag%TYPE; -- belle 12.20.2012
v_max_takeup        gipi_winvoice.takeup_seq_no%TYPE; -- belle 12.20.2012
 
BEGIN

    FOR a1_rec IN a1 LOOP
        v_mline_cd   := a1_rec.line_cd;
        v_iss_cd    := a1_rec.iss_cd;
        v_incept_date   := a1_rec.incept_date;   -- 09092011
        v_currency_rt := a1_rec.currency_rt ; -- jhing 01.19.2012  used in computation of total TSI and also with computation in tax amount to be stored in gipi_winv_tax in later co
        IF a1_rec.peril_type = 'B' THEN
            v_tsi_amt   := v_tsi_amt + ( a1_rec.tsi_amt * NVL(v_currency_rt , 1 ));
        END IF;
        --v_prem_amt:= v_prem_amt+a1_rec.prem_amt; commented by: Nica 10.23.2012

    END LOOP;
     
    dbms_output.put_line(v_mline_cd);    
        SELECT NVL(menu_line_cd,line_cd) line_cd
          INTO v_line_cd
          FROM GIIS_LINE
         WHERE line_cd = v_mline_cd;
    
    dbms_output.put_line(v_line_cd||'-'||v_iss_cd||'-'||v_tsi_amt||'-'||v_prem_amt);
    
    IF v_iss_cd <> 'RI' THEN
        BEGIN
        SELECT RATE, TAKEUP_ALLOC_TAG, TAX_ID 
          INTO v_tax_rt, v_takeup_alloc_tag, v_tax_id --belle 12.20.2012 
          FROM giis_tax_charges
         WHERE line_cd  = v_mline_cd
           AND iss_cd   = v_iss_cd
           -- 09122011 - include effectivity and expiry date condition for tax_charges
           AND v_incept_date between eff_start_date and eff_end_date
           AND TAX_CD   = GIACP.N('DOC_STAMPS');
        EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE  (GIIS_TAX_CHARGES).');
         END;
                  
       -- belle12.20.2012
       SELECT MAX(takeup_seq_no)
         INTO v_max_takeup
         FROM GIPI_WINVOICE
        WHERE par_id = p_par_id;      
       
       -- belle 12.20.2012 consider takeup_seq_no   
       FOR a IN (SELECT *
                   FROM GIPI_WINVOICE
                  WHERE par_id = p_par_id)
       LOOP 
           -- added by: Nica 10.23.2012 to consider item group of item      
           FOR c IN (SELECT SUM(b.prem_amt) sum_prem_amt, 
                             d.currency_rt,
                             NVL(d.item_grp, 1) item_grp
                        FROM GIPI_WITMPERL b, 
                             GIPI_WITEM d
                       WHERE 1=1
                         AND b.par_id = p_par_id
                         AND b.item_no = d.item_no
                         AND b.par_id = d.par_id
                    GROUP BY d.item_grp, d.currency_rt)
            LOOP
                v_prem_amt    := c.sum_prem_amt;
                   
                SELECT SUM(tax_amt) tax_amt
                  INTO v_tax
                  FROM GIPI_WINV_TAX
                 WHERE tax_cd = GIACP.N('DOC_STAMPS')
                   AND par_id = p_par_id
                   AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp
                   AND takeup_seq_no = a.takeup_seq_no; -- belle 12.20.2012
                      
            dbms_output.put_line('RATE: '||v_tax_rt);
                IF v_prem_amt < 0 THEN                       
                    DELETE FROM GIPI_WINV_TAX
                     WHERE PAR_ID = P_PAR_ID
                       AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp
                       AND takeup_seq_no = a.takeup_seq_no -- belle 12.20.2012
                       AND TAX_CD = GIACP.N('DOC_STAMPS');
                    -- COMMIT; commented out by rjvirrey 10.24.2012
                        
                    UPDATE GIPI_WINVOICE
                       SET TAX_AMT = TAX_AMT-v_tax
                     WHERE par_id = p_par_id
                       AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp
                       AND takeup_seq_no = a.takeup_seq_no; -- belle 12.20.2012
                     -- COMMIT; commented out by rjvirrey 10.24.2012
                       
                    UPDATE gipi_winstallment
                       set tax_amt = TAX_AMT-v_tax
                     WHERE 1=1
                       AND inst_no = 1
                       AND par_id = p_par_id 
                       AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp 
                       AND takeup_seq_no = a.takeup_seq_no; -- belle 12.20.2012
                      -- COMMIT; commented out by rjvirrey 10.24.2012
                ELSE
                    IF v_param_old_doc = 'Y' THEN
                        IF v_line_cd = 'AC' THEN  --IF ACCIDENT / LIFE INSURANCE
                            IF v_param_pa_doc = 1 THEN  -- COMPUTATION is based on Premium amount time tax rate
                                v_tax_amt := (v_prem_amt*v_tax_rt/100);
                            ELSIF v_param_pa_doc = 2 THEN  -- COMPUTATION IS 50cents for every 200 pesos of total premium
                               v_tax_amt := CEIL(v_prem_amt / 200) * (0.5);
                            ELSIF v_param_pa_doc = 3 THEN  -- COMPUTATION IS  within the range maintain and basis is the totaL sum insured
                                    
                                -- added by: Nica 10.31.2012 to consider item_grp for computing tsi_amt
                                BEGIN
                                    SELECT SUM(a.tsi_amt * b.currency_rt) sum_tsi_amt
                                      INTO v_tsi_amt
                                      FROM GIPI_WITMPERL a, 
                                           GIPI_WITEM b,
                                           GIIS_PERIL d
                                    WHERE a.par_id = p_par_id
                                      AND b.item_grp = c.item_grp
                                      AND a.item_no = b.item_no
                                      AND a.par_id = b.par_id
                                      AND a.line_cd = d.line_cd
                                      AND a.peril_cd = d.peril_cd
                                      AND d.peril_type = 'B'
                                    GROUP BY b.item_grp;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                       v_tsi_amt := 0;    
                                END;
                                     
                                BEGIN
                                    /* SELECT tax_amount
                                      INTO v_tax_amt
                                      FROM giis_tax_range gtr
                                     WHERE 1=1
                                       AND gtr.line_cd  = v_mline_cd
                                       AND gtr.iss_cd   = v_iss_cd
                                       AND tax_cd       = giacp.n('DOC_STAMPS')
                                       AND v_tsi_amt BETWEEN min_value AND max_value
									   AND tax_id <> 0; --added by steven 1.29.2013; para hindi niya ma-fetch ung nadelete na tax range. error din siya sa CS.kapag nadelete ka kasi dun ginagawa niyang zero ung tax_id. */
                                       
                                       SELECT gtr.tax_amount
                                         INTO v_tax_amt
                                         FROM giis_tax_range gtr,
                                              giis_tax_charges gtc
                                        WHERE 1=1
                                          AND gtr.line_cd = v_mline_cd
                                          AND gtr.iss_cd = v_iss_cd
                                          AND gtr.tax_cd = giacp.n('DOC_STAMPS')
                                          AND v_tsi_amt BETWEEN gtr.min_value AND gtr.max_value
                                          AND gtr.tax_id <> 0
                                          AND gtr.line_cd = gtc.line_cd
                                          AND gtr.iss_cd = gtc.iss_cd
                                          AND gtr.tax_cd = gtc.tax_cd
                                          AND gtr.tax_id = gtc.tax_id
                                          AND NVL(gtc.expired_sw, 'N') <> 'Y'; -- 07.08.2013 - @ucpb - koks/marco
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        RAISE_APPLICATION_ERROR(-20002, 'Geniisys Exception#E#NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).');
                                END; 
                           
                                v_tax_amt := v_tax_amt / c.currency_rt; -- 07.08.2013 - @ucpb - koks/marco --change by steven 08.01.2014 mali ung pagconvert niya pag multiple items.
                        
                            END IF;
                        ELSE
                            v_tax_amt := CEIL(v_prem_amt / 4) * (0.5);
                        END IF;
                        
                    ELSE
                        --v_tax_amt := (v_prem_amt*v_tax_rt/100);
                        
                        IF v_line_cd = 'AC' THEN  --IF ACCIDENT / LIFE INSURANCE
                            IF v_param_pa_doc = 1 THEN  -- COMPUTATION is based on Premium amount time tax rate
                                v_tax_amt := (v_prem_amt*v_tax_rt/100);
                            ELSIF v_param_pa_doc = 2 THEN  -- COMPUTATION IS 50cents for every 200 pesos of total premium
                               v_tax_amt := CEIL(v_prem_amt / 200) * (0.5);
                            ELSIF v_param_pa_doc = 3 THEN  -- COMPUTATION IS  within the range maintain and basis is the totaL sum insured
                                    
                                -- added by: Nica 10.31.2012 to consider item_grp for computing tsi_amt
                                BEGIN
                                    SELECT SUM(a.tsi_amt * b.currency_rt) sum_tsi_amt
                                      INTO v_tsi_amt
                                      FROM GIPI_WITMPERL a, 
                                           GIPI_WITEM b,
                                           GIIS_PERIL d
                                    WHERE a.par_id = p_par_id
                                      AND b.item_grp = c.item_grp
                                      AND a.item_no = b.item_no
                                      AND a.par_id = b.par_id
                                      AND a.line_cd = d.line_cd
                                      AND a.peril_cd = d.peril_cd
                                      AND d.peril_type = 'B'
                                    GROUP BY b.item_grp;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                       v_tsi_amt := 0;    
                                END;
                                     
                                BEGIN
--                                    SELECT tax_amount
--                                      INTO v_tax_amt
--                                      FROM giis_tax_range gtr
--                                     WHERE 1=1
--                                       AND gtr.line_cd  = v_mline_cd
--                                       AND gtr.iss_cd   = v_iss_cd
--                                       AND tax_cd       = giacp.n('DOC_STAMPS')
--                                       AND v_tsi_amt BETWEEN min_value AND max_value
--                                       AND tax_id <> 0; --added by steven 1.29.2013; para hindi niya ma-fetch ung nadelete na tax range. error din siya sa CS.kapag nadelete ka kasi dun ginagawa niyang zero ung tax_id.
                                        --commented out by jeff dojello 05.28.2013
                                        --added by jeff dojello 05.28.2013
                                        SELECT gtr.tax_amount
                                          INTO v_tax_amt
                                          FROM giis_tax_range gtr,
                                               giis_tax_charges gtc
                                         WHERE 1=1
                                           AND gtr.line_cd  = v_mline_cd
                                           AND gtr.iss_cd   = v_iss_cd
                                           AND gtc.tax_type  = 'N'
                                           AND gtr.tax_cd   = giacp.n('DOC_STAMPS')
                                           AND gtc.line_cd  = gtr.line_cd
                                           AND gtc.iss_cd   = gtr.iss_cd
                                           AND gtc.tax_cd   = gtr.tax_cd
                                           AND gtc.tax_id   = gtr.tax_id   
                                           AND v_tsi_amt BETWEEN min_value AND max_value
                                           AND gtr.tax_id <> 0;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        RAISE_APPLICATION_ERROR(-20002, 'Geniisys Exception#E#NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).');
                                    WHEN TOO_MANY_ROWS THEN
                                        RAISE_APPLICATION_ERROR(-20002, 'Geniisys Exception#E#TOO MANY ROWS RETRIEVED.');
                                END; 
                                
                                v_tax_amt := v_tax_amt / c.currency_rt; --added by steven 08.01.2014
                           
                            END IF;
                        ELSE
                            v_tax_amt := (v_prem_amt*v_tax_rt/100);
                        END IF;
                        
                    END IF; 
                    
                    -- belle 12.20.2012
                    IF v_takeup_alloc_tag = 'F' AND a.takeup_seq_no = 1 THEN
                        v_tax_amt := v_tax_amt;
                    ELSIF v_takeup_alloc_tag = 'L' AND a.takeup_seq_no = v_max_takeup THEN
                        v_tax_amt := v_tax_amt;
                    ELSIF v_takeup_alloc_tag = 'S'THEN
                        v_tax_amt := v_tax_amt / v_max_takeup;
                    ELSE
                        v_tax_amt := 0;                    
                    END IF;
                       
                    UPDATE GIPI_WINV_TAX
                       SET TAX_AMT = v_tax_amt
                     WHERE PAR_ID = P_PAR_ID
                       AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp
                       AND takeup_seq_no = a.takeup_seq_no -- belle 12.20.2012
                       AND TAX_CD = GIACP.N('DOC_STAMPS');
                     -- COMMIT; commented out by rjvirrey 10.24.2012
                        
                    UPDATE GIPI_WINVOICE
                       SET TAX_AMT = v_tax+v_tax_amt
                     WHERE par_id = p_par_id
                       AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp
                       AND takeup_seq_no = a.takeup_seq_no; -- belle 12.20.2012
                     -- COMMIT; commented out by rjvirrey 10.24.2012
                        
                    UPDATE gipi_winstallment
                       set tax_amt = v_tax+v_tax_amt
                     WHERE 1=1
                       AND inst_no = 1
                       AND par_id = p_par_id
                       AND item_grp = c.item_grp -- added by: Nica 10.23.2012 to consider item_grp 
                       AND takeup_seq_no = a.takeup_seq_no; -- belle 12.20.2012 
                    -- COMMIT; commented out by rjvirrey 10.24.2012                      
                END IF;
            END LOOP;  
       END LOOP;      
        
        FOR i IN (SELECT SUM(tax_amt) tax_amt, par_id, takeup_seq_no, item_grp
                   FROM GIPI_WINV_TAX
                  WHERE par_id = p_par_id
                  GROUP BY par_id, item_grp, takeup_seq_no)
        LOOP
          v_sum_tax_amt := i.tax_amt;
         
          UPDATE GIPI_WINVOICE
             SET tax_amt   = v_sum_tax_amt
           WHERE par_id     = p_par_id
             AND takeup_seq_no = i.takeup_seq_no
             AND item_grp      = i.item_grp;
        END LOOP;
        --COMMIT; commented out by rjvirrey 10.24.2012
        dbms_output.put_line('tax_amt: '||v_tax_amt);        
    END IF;

END COMPUTE_DOCSTAMPS;
/


