CREATE OR REPLACE PROCEDURE CPI.validate_tax_entry (
   p_par_id          IN     gipi_wpolbas.par_id%TYPE,
   p_line_cd         IN     gipi_winv_tax.line_cd%TYPE,
   p_iss_cd          IN     gipi_winv_tax.iss_cd%TYPE,
   p_item_grp        IN     gipi_winvoice.item_grp%TYPE,
   p_takeup_seq_no   IN     gipi_winvoice.takeup_seq_no%TYPE,
   p_tax_cd          IN     gipi_winv_tax.tax_cd%TYPE,
   p_tax_id          IN     gipi_winv_tax.tax_id%TYPE,
   p_tax_amt         IN OUT gipi_winv_tax.tax_amt%TYPE,
   p_orig_tax_amt    IN     gipi_winv_tax.tax_amt%TYPE,
   p_prem_amt        IN OUT gipi_winvoice.prem_amt%TYPE,
   p_message            OUT VARCHAR2)
IS
   d               NUMBER := 0;
   v_rate          NUMBER;
   v_no_rate_tag   giis_tax_charges.no_rate_tag%TYPE;
   v_primary_sw    giis_tax_charges.primary_sw%TYPE;
   v_peril_sw      giis_tax_charges.peril_sw%TYPE;
   v_edit_tag      giis_parameters.param_value_v%TYPE;
   v_pol_flag      gipi_wpolbas.pol_flag%TYPE;
   v_vat_tag       giis_assured.vat_tag%TYPE;
   v_endt_tax_sw   VARCHAR2 (10);
   -- jhing 11.09.2014 added variables 
   v_param_gtr_tax giis_parameters.param_value_v%TYPE := NVL(giisp.v('ALLOW_TAX_GREATER_THAN_PREMIUM'),'N');  
   v_expect_tax_amt gipi_winv_tax.tax_amt%TYPE ;
   v_doc_stamps    giac_parameters.param_value_n%TYPE := giacp.n('DOC_STAMPS');
   v_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE; 
   v_tax_type           giis_tax_charges.tax_type%TYPE ;
   v_tax_amount         giis_tax_charges.tax_amount%TYPE ;
   v_par_type           gipi_parlist.par_type%TYPE; 
   p_val_tax_vs_prem    VARCHAR2(1) ;
   v_line_cd            GIPI_WPOLBAS.line_cd%TYPE; --kenneth SR22090 5.12.2016
   
BEGIN
   p_message := 'SUCCESS';
   IF p_tax_amt IS NULL
   THEN
      p_tax_amt := 0;
   END IF;
   IF p_prem_amt <> 0
   THEN
      v_rate := (p_tax_amt / p_prem_amt) * 100;
   END IF;
   FOR v1 IN (SELECT NVL (b.vat_tag, 3) vat_tag , c.par_type
                FROM giis_assured b, gipi_parlist c 
               WHERE b.assd_no = c.assd_no 
                     AND c.par_id = p_par_id)
   LOOP
      v_vat_tag := v1.vat_tag;
      v_par_type := v1.par_type;
   END LOOP;
   IF p_tax_cd = giacp.n ('EVAT') AND v_vat_tag = 2
   THEN
      IF p_tax_amt <> 0
      THEN
         p_tax_amt := 0;
         p_message := 'This assured is zero VAT rated.';
      END IF;
   ELSE
      FOR par IN (SELECT pol_flag, line_cd
                    FROM gipi_wpolbas
                   WHERE par_id = p_par_id)
      LOOP
         v_pol_flag := par.pol_flag;
         v_line_cd := par.line_cd;
         EXIT;
      END LOOP;
      
      FOR a
         IN (SELECT rate,
                    no_rate_tag,
                    primary_sw,
                    peril_sw,
                    NVL(tax_type,'R') tax_type
               FROM giis_tax_charges
              WHERE     iss_cd = p_iss_cd
                    AND line_cd = v_line_cd
                    AND tax_cd = p_tax_cd
                    AND tax_id = p_tax_id)
      LOOP
         v_no_rate_tag := a.no_rate_tag;
         v_primary_sw := a.primary_sw;
         v_peril_sw := a.peril_sw;
         v_tax_type := a.tax_type;
         EXIT;
      END LOOP;
     
      FOR tag IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'EDIT_TAX_TO_ZERO')
      LOOP
         v_edit_tag := tag.param_value_v;
         EXIT;
      END LOOP;
      BEGIN
         FOR c IN (SELECT endt_tax
                     FROM gipi_wendttext
                    WHERE par_id = p_par_id)
         LOOP
            v_endt_tax_sw := c.endt_tax;
            EXIT;
         END LOOP;
         -- jhing 11.08.2014 added validation on allow tax greater than premium. This parameter will only be applicable on 
         -- policy and not on endorsement. Validation will only fire on fixed amount tax type.     
         p_val_tax_vs_prem := 'N'; 
         -- Removed by Apollo Cruz 02.17.2015 - as per ma'am vj, a confirmation message must be displayed instead of not allowing the user to continue 
         /* IF v_pol_flag <> '4' THEN 
             IF v_tax_type = 'A' AND v_par_type = 'P' AND v_param_gtr_tax <> 'Y' THEN 
                    p_val_tax_vs_prem := 'Y';    
             ELSIF v_tax_type = 'A' AND v_par_type = 'E' THEN  
                    p_val_tax_vs_prem := 'Y';           
             END IF;    
         END IF; */ 
         IF NVL(v_endt_tax_sw,'N') <> 'Y' AND ABS(p_tax_amt) > ABS(p_prem_amt) AND  p_val_tax_vs_prem = 'Y'
         THEN
           p_message := 'Invalid Tax Amount. Tax Amount should not be greater than the Premium.';
         ELSE            
             IF NVL (v_rate, 0) != 0
             THEN            
                IF v_peril_sw = 'Y'
                THEN 
                   FOR v
                      IN (SELECT peril_cd
                            FROM giis_tax_peril
                           WHERE     iss_cd = p_iss_cd
                                 AND line_cd = v_line_cd
                                 AND tax_cd = p_tax_cd
                                 AND tax_id = p_tax_id /* jhing 11.08.2014 */ )
                   LOOP
                      FOR m
                         IN (SELECT peril_cd, prem_amt
                               FROM gipi_winvperl
                              WHERE     par_id = p_par_id
                                    AND item_grp = p_item_grp
                                    AND takeup_seq_no = p_takeup_seq_no
                                    AND peril_cd = v.peril_cd)
                      LOOP
                         IF     NVL (p_tax_amt, 0) <= 0
                            AND m.prem_amt > 0
                            AND NVL (v_endt_tax_sw, 'N') != 'Y'
                            AND NVL (v_edit_tag, 'N') = 'N'
                         THEN
                            p_message :=
                               'Tax Amount must not be less than or equal to zero';
                         END IF;
                         EXIT;
                      END LOOP;
                   END LOOP;
                ELSIF     NVL (p_tax_amt, 0) <= 0
                      AND NVL (p_prem_amt, 0) > 0
                      AND v_peril_sw = 'N'
                      AND NVL (v_endt_tax_sw, 'N') != 'Y'
                      AND NVL (v_edit_tag, 'N') = 'N'
                THEN
                   p_message :=
                      'Tax Amount must not be less than or equal to zero';
                END IF;
                -- jhing 11.09.2014 added re-computation for expected tax amount 
                v_expect_tax_amt := 0 ;
                IF NVL (v_no_rate_tag, 'N') != 'Y'  
                   AND NVL (v_endt_tax_sw, 'N') != 'Y'
                   AND v_pol_flag != '4' THEN
                    --added exception to avoid sql error kenneth SR 22090 04.20.2016
                    BEGIN
                        SELECT NVL(takeup_alloc_tag,'F'), NVL(tax_type,'R') , NVL(tax_amount,0) 
                          INTO v_takeup_alloc_tag, v_tax_type, v_tax_amount
                          FROM giis_tax_charges 
                         WHERE iss_cd = p_iss_cd
                           AND line_cd = v_line_cd
                           AND tax_cd = p_tax_cd
                           AND tax_id = p_tax_id ; 
                    EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                            p_message := 'No records exist in this line and issue source (GIIS_TAX_CHARGES).';
                    END;  
                                   
                    IF p_tax_cd = v_doc_stamps THEN                 
                       BEGIN
                              SELECT gipi_winvoice_pkg.get_DocStamps_TaxAmt
                                           (   p_tax_cd  ,
                                               p_tax_id ,
                                               p_par_id  ,
                                               0 , /* premium amount would be recomputed inside the function */
                                               p_item_grp   ,
                                               p_takeup_seq_no,
                                               v_takeup_alloc_tag 
                                               ) INTO v_expect_tax_amt FROM dual;
                       EXCEPTION
                            WHEN OTHERS THEN 
                                p_message := sqlerrm ; 
                       END ;
                    ELSE
                        IF v_tax_type = 'A' THEN
                              BEGIN
                                 SELECT gipi_winvoice_pkg.get_Fixed_Amount_Tax
                                           (   p_tax_cd  ,
                                               p_tax_id ,
                                               p_par_id  ,
                                               p_prem_amt,--0 , /* premium amount would be recomputed inside the function */
                                               0 /* tax amount is requeried inside function */ ,
                                               p_item_grp   ,
                                               p_takeup_seq_no,
                                               v_takeup_alloc_tag 
                                               ) INTO v_expect_tax_amt FROM dual;
                               EXCEPTION
                                    WHEN OTHERS THEN 
                                        p_message := sqlerrm ; 
                               END ;
                        ELSIF v_tax_type = 'N' THEN
                              BEGIN
                               SELECT gipi_winvoice_pkg.get_range_amt
                                           (   p_tax_cd  ,
                                               p_tax_id ,
                                               p_par_id  ,
                                               0 , /* premium amount would be recomputed inside the function */
                                               p_item_grp   ,
                                               p_takeup_seq_no,
                                               v_takeup_alloc_tag 
                                               ) INTO v_expect_tax_amt FROM dual;
                               EXCEPTION
                                    WHEN OTHERS THEN 
                                        p_message := sqlerrm ; 
                               END ;
                        ELSE
                              BEGIN
                               SELECT gipi_winvoice_pkg.get_rate_amt
                                           (   p_tax_cd  ,
                                               p_tax_id ,
                                               p_par_id  ,
                                               p_item_grp   ,
                                               p_takeup_seq_no
                                               ) INTO v_expect_tax_amt FROM dual;
                               EXCEPTION
                                    WHEN OTHERS THEN 
                                        p_message := sqlerrm ; 
                               END ;                        
                        END IF;
                    END IF;
                END IF ;                
             ELSE
               IF     NVL (p_tax_amt, 0) <= 0
                   AND NVL (v_no_rate_tag, 'N') = 'N'
                   AND NVL (v_edit_tag, 'N') = 'N'
                THEN
                   p_message :=
                      'Tax Amount should not be less than or equal to zero';
                   p_tax_amt := NVL (p_orig_tax_amt, 0);
                END IF;
             END IF;
         END IF;    
      END;
   END IF;
END;
/


