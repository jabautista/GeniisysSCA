DROP PROCEDURE CPI.CREATE_QUOTE_INVOICE;

CREATE OR REPLACE PROCEDURE CPI.create_quote_invoice (p_quote_id IN NUMBER, p_line_cd IN VARCHAR2, p_iss_cd IN VARCHAR2) IS
-- created by loth 020100
-- automatically create invoice records and get the required taxes for quotation.
/***
**   Modified by Udel 08312012
**   Removed restricting of taxes that has 0 tax amount to be inserted into table.
*/
--Modified by Gzelle 09172014 @lines 417,452 and 479 changed tax_cd IN (number) to varchar 
CURSOR a1 IS
     SELECT   incept_date, expiry_date, line_cd /* jhing 08.10.2012 added line_cd */ 
       FROM   gipi_quote
      WHERE   quote_id  =  p_quote_id;
CURSOR c1 IS
     SELECT   a.peril_cd,
              b.currency_cd,b.currency_rate,
              SUM(NVL(a.prem_amt,0)) prem_amt, SUM(NVL(a.tsi_amt,0)) tsi_amt
       FROM   gipi_quote_itmperil a, gipi_quote_item b
      WHERE   a.quote_id  = p_quote_id
        AND   a.quote_id  = b.quote_id
        AND   a.item_no   = b.item_no
   GROUP BY b.quote_id, b.currency_cd, b.currency_rate,
        a.peril_cd;
CURSOR d1 IS
   SELECT param_value_n
      FROM giac_parameters
   WHERE param_name = 'DOC_STAMPS';
CURSOR e1 IS
 SELECT param_value_v
      FROM giis_parameters
   WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS';
     p_doc_stamps         giis_tax_charges.tax_cd%TYPE;
     v_param_old_doc   giis_parameters.param_value_v%TYPE;
     prem_amt_per_peril  gipi_quote_invoice.prem_amt%TYPE;
     prem_amt_per_group  gipi_quote_invoice.prem_amt%TYPE;
     tax_amt_per_peril   gipi_quote_invoice.tax_amt%TYPE;
     tax_amt_per_group1  NUMBER;--gipi_quote_invoice.tax_amt%TYPE;  changed by Gzelle 01142015
     tax_amt_per_group2  gipi_quote_invoice.tax_amt%TYPE;
     p_tax_amt           REAL;
     prev_currency_cd    gipi_quote_invoice.currency_cd%TYPE;
     prev_currency_rt    gipi_quote_invoice.currency_rt%TYPE;
     v_quote_inv_no     gipi_quote_invoice.quote_inv_no%TYPE;
     p_assd_name         giis_assured.assd_name%TYPE;
     p_incept_date       gipi_quote.incept_date%TYPE;
     p_exists            VARCHAR2(1) := 'N';
     p_exists2           VARCHAR2(1) := 'N';
     p_exists_c1         VARCHAR2(1) := 'N'; --added by steven 12/06/2012 to see if it has a record in cursor C1
     p_expiry_date       gipi_quote.expiry_date%TYPE;
     p_mnu_line_cd       gipi_quote.line_cd%TYPE; -- jhing 08.10.2012 
     v_line_cd           giis_line.menu_line_cd%TYPE ; -- jhing 08.10.2012 
     v_total_prem        gipi_quote_item.prem_amt%TYPE; -- jhing 08.10.2012
     v_total_tsi         gipi_quote_item.tsi_amt%TYPE; -- jhing 08.10.2012
     v_param_pa_doc      giis_parameters.param_value_v%TYPE:=giisp.v('COMPUTE_PA_DOC_STAMPS');  -- jhing 08.10.2012
     v_currency_rate     gipi_quote_item.currency_rate%TYPE; 
     v_tax_range_amt     giis_tax_range.tax_amount%TYPE ; -- jhing 08.10.2012
     v_assd_vat_type     giis_assured.vat_tag%TYPE; -- jhing 08.10.2012
     v_assured_no        giis_assured.assd_no%TYPE; -- jhing 08.10.2012
     v_vat_tax_cd        giis_tax_charges.tax_cd%TYPE := Giacp.n('EVAT') ; -- jhing 08.10.2012
     v_vat_tag           giis_assured.vat_tag%TYPE := '3';   -- jhing 08.10.2012  --changed from 3 to '3' Gzelle 09172014
BEGIN
  OPEN a1;
  FETCH a1
   INTO p_incept_date, p_expiry_date , p_mnu_line_cd ;/* jhing 08.10.2012 added p_mnu_line_cd */ 
  CLOSE a1;
 OPEN d1;
    FETCH d1
         INTO p_doc_stamps;
    CLOSE d1;
    OPEN e1;
   FETCH e1
        INTO v_param_old_doc;
   CLOSE e1;
   /*  jhing 08.10.2012  */
   SELECT NVL(menu_line_cd, line_cd) 
    INTO v_line_cd
    FROM giis_line WHERE line_cd = p_mnu_line_cd;
   /* end jhing 08.10.2012  */ 
   
   -- jhing uncommented out 08.01.2012  
  for del in (
    select iss_cd, quote_inv_no
      from gipi_quote_invoice
     where quote_id = p_quote_id )
  loop
    delete from gipi_quote_invtax
     where iss_cd       = del.iss_cd
       and quote_inv_no = del.quote_inv_no;
  end loop;  -- end of del loop
--  delete from gipi_quote_invoice
--    where quote_id = p_quote_id;


  BEGIN
    FOR assd IN (
       SELECT   SUBSTR(assd_name,1,30)    assd_name , assd_no /* jhing 08.10.2012 added assd_no */
         FROM   gipi_quote
        WHERE   quote_id     =  p_quote_id)
    LOOP
      p_assd_name  := assd.assd_name;
      v_assured_no := assd.assd_no;  -- jhing 08.10.2012
      
    END LOOP;  -- end of assd loop
    IF p_assd_name IS NULL THEN
       p_assd_name:='NULL';
    END IF;
    
    -- jhing retrieve the VAT_TAG of the assured if the assured is already maintained in the Assured maintenance
    IF v_assured_no IS NOT NULL THEN
        SELECT NVL(vat_tag, 'X' ) vat_tag
            INTO v_vat_tag
                FROM GIIS_ASSURED 
        WHERE assd_no = v_assured_no ; 
    END IF;                                    
                                    
  END;
  
  FOR c1_rec IN c1 LOOP
    BEGIN
      IF NVL(prev_currency_cd,c1_rec.currency_cd) != c1_rec.currency_cd AND
         NVL(prev_currency_rt,c1_rec.currency_rate) != c1_rec.currency_rate THEN
        BEGIN
          DECLARE
            CURSOR c2 IS SELECT DISTINCT b.tax_cd, b.rate, b.tax_id
                           FROM giis_tax_peril a, giis_tax_charges b
                          WHERE b.line_cd    = p_line_cd
                            AND b.iss_cd  (+)= p_iss_cd
                            AND b.primary_sw = 'Y'
                            AND b.peril_sw   = 'N'
                                -- peril switch equal to 'n' suggests that the
                                -- specified tax does not need any tax peril
                            AND b.eff_start_date <= p_incept_date
                            AND b.eff_end_date >= p_expiry_date;
                                -- the tax fetched should have been in effect before the
                                -- par has been created.
          BEGIN
              FOR c2_rec IN c2 LOOP
                 BEGIN
                      p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c2_rec.rate,0)/100;
              -- jhing 08.16.2012 synchronize calculation with compute docstamps formula 
              /*
               IF MOD(prem_amt_per_group,4) <> 0 AND c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
                            p_tax_amt := TRUNC(prem_amt_per_group / 4) * (0.5) + (0.5); 
               END IF;
               */               
               -- jhing 08.16.2012 revised code
                     IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
                         IF v_line_cd = 'AC' THEN
                             p_tax_amt := CEIL (prem_amt_per_group / 200 ) * (0.5 ) ; 
                         ELSE
                             p_tax_amt := CEIL (prem_amt_per_group / 4   ) * (0.5 ) ; 
                         END IF;
               
                     END IF;
               -- end jhing revised code
               
                     tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
                  END;
              END LOOP;  -- end of c2_rec loop
              FOR exist IN (
                  SELECT 'A'
                    FROM gipi_quote_invoice
                   WHERE quote_id    = p_quote_id
                     AND currency_cd = prev_currency_cd
                     AND currency_rt = prev_currency_rt)
              LOOP
                  p_exists := 'Y';
                 EXIT;
              END LOOP;
              
              IF p_exists = 'N' THEN
                  INSERT INTO  gipi_quote_invoice
                               (quote_id,   iss_cd,     quote_inv_no,
                                prem_amt,   tax_amt,        currency_cd,
                                currency_rt)
                         VALUES (p_quote_id, p_iss_cd,         1,
                                 prem_amt_per_group, NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0),
                                prev_currency_cd, prev_currency_rt);
              ELSE
                  UPDATE gipi_quote_invoice
                     SET prem_amt = prem_amt_per_group,
                         tax_amt  = NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)
                   WHERE quote_id      = p_quote_id
                     AND currency_cd = prev_currency_cd
                     AND currency_rt = prev_currency_rt;
              END IF;
            p_exists  := 'N';
            p_tax_amt := 0;
            prem_amt_per_group := 0;
            tax_amt_per_group1 := 0;
            tax_amt_per_group2 := 0;
            tax_amt_per_peril  := 0;
          END;
         END;
      END IF;
      prev_currency_cd   := c1_rec.currency_cd;
      prev_currency_rt   := c1_rec.currency_rate;
      prem_amt_per_group := NVL(prem_amt_per_group,0) + c1_rec.prem_amt;
      p_exists_c1 := 'Y'; --added by steven 12/06/2012
      DECLARE
      CURSOR c3 IS SELECT DISTINCT b.tax_cd, b.rate
                     FROM giis_tax_peril a, giis_tax_charges b
                    WHERE a.line_cd    = p_line_cd
                      AND a.iss_cd  (+)= p_iss_cd
                      AND a.line_cd    = b.line_cd
                      AND a.iss_cd  (+)= b.iss_cd
                      AND a.tax_cd     = b.tax_cd
                      AND b.eff_start_date <= p_incept_date
                      AND b.eff_end_date <= p_expiry_date
                      AND b.primary_sw = 'Y'
                      AND b.peril_sw   = 'Y'
                      AND a.peril_cd IN ( SELECT peril_cd
                                            FROM gipi_quote_itmperil
                                           WHERE quote_id = p_quote_id)
                      AND a.peril_cd   = c1_rec.peril_cd;
      BEGIN
        FOR c3_rec IN c3 LOOP
          BEGIN
                 p_tax_amt := NVL(c1_rec.prem_amt,0) * NVL(c3_rec.rate,0)/ 100;
                  IF MOD(c1_rec.prem_amt,4) <> 0 AND c3_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
                           -- p_tax_amt := TRUNC(c1_rec.prem_amt / 4) * (0.5) + (0.5); -- jhing 08.10.2012 commented out and replaced with : to synch formula with create_winvoice and compute_docstamps
                              p_tax_amt := CEIL (c1_rec.prem_amt / 200) * (0.5); 
                  END IF;
                 tax_amt_per_peril := NVL(tax_amt_per_peril,0) + NVL(p_tax_amt,0);
                 tax_amt_per_group2 := tax_amt_per_peril;
          END;
        END LOOP;  -- end of c3_rec loop
      END;
    END;
  END LOOP; -- end of c1_rec loop
  DECLARE
  CURSOR c4 IS SELECT DISTINCT b.tax_cd, b.rate
                 FROM giis_tax_peril a, giis_tax_charges b
                WHERE b.line_cd = p_line_cd
                  AND b.iss_cd  (+)= p_iss_cd
                  AND b.primary_sw = 'Y'
                  AND b.peril_sw   = 'N'
                  AND b.eff_start_date <= p_incept_date
                  AND b.eff_end_date   >= p_expiry_date;
  BEGIN
    FOR c4_rec IN c4 LOOP
      BEGIN
           p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c4_rec.rate,0)/100;
            IF MOD(prem_amt_per_group,4) <> 0 AND c4_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
                             -- p_tax_amt := TRUNC(prem_amt_per_group / 4) * (0.5) + (0.5);  -- jhing 08.10.2012 commented out and replaced with  to synch formula with create_winvoice and compute_docstamps
                                p_tax_amt := CEIL (prem_amt_per_group / 200) * (0.5);
            END IF;
           tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
      END;
    END LOOP;  -- end of c4_rec loop
    FOR exist IN (
      SELECT 'A'
    FROM gipi_quote_invoice
       WHERE quote_id    = p_quote_id
     AND currency_cd = prev_currency_cd
     AND currency_rt = prev_currency_rt)
    LOOP
      p_exists := 'Y';
      EXIT;
    END LOOP;
	IF p_exists_c1 = 'Y' THEN --added by steven 12/06/2012 papasok siya dito kung ung dinilete niya ay galing sa database.
		IF p_exists = 'N' THEN
		   INSERT INTO  gipi_quote_invoice
					(quote_id,   iss_cd,        quote_inv_no,
					 prem_amt,   tax_amt,       currency_cd,      currency_rt)
			 VALUES (p_quote_id, p_iss_cd,      1,
					 prem_amt_per_group,        NVL(tax_amt_per_group1,0)+
					 NVL(tax_amt_per_group2,0), prev_currency_cd, prev_currency_rt);
		ELSE
			 FOR q_inv_rec IN (SELECT   b.currency_cd,b.currency_rate, --added by steven 12.10.2012; para yong ii-insert prem_amt ay according sa currency_cd niya.mali kasi ung pinapasang prem_amt_per_group
                        SUM(NVL(a.prem_amt,0)) prem_amt, SUM(NVL(a.tsi_amt,0)) tsi_amt
                            FROM   gipi_quote_itmperil a, gipi_quote_item b
                                WHERE   a.quote_id  = p_quote_id
                                    AND   a.quote_id  = b.quote_id
                                    AND   a.item_no   = b.item_no
                                GROUP BY b.quote_id, b.currency_cd, b.currency_rate) 
            LOOP
			 UPDATE gipi_quote_invoice
				  SET prem_amt = q_inv_rec.prem_amt, --edited by steve 12.10.2012 prem_amt_per_group,
					  tax_amt  = NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)
					WHERE quote_id       = p_quote_id
					  AND currency_cd = q_inv_rec.currency_cd--edited by steve 12.10.2012 prev_currency_cd
					   AND currency_rt = q_inv_rec.currency_rate;--edited by steve 12.10.2012 prev_currency_rt;
				END LOOP;
		END IF;
	END IF;
  END;
  p_exists := 'N';
  tax_amt_per_group1 := 0;
  
  DECLARE
    p_tax_id     giis_tax_charges.tax_id%TYPE;
    CURSOR c5 IS SELECT DISTINCT currency_cd, currency_rate
                   FROM gipi_quote_item
                  WHERE quote_id = p_quote_id
                  GROUP BY currency_cd, currency_rate;
  BEGIN
    FOR c5_rec IN c5 LOOP
      BEGIN     
        DECLARE
          CURSOR c6 IS SELECT DISTINCT b.tax_cd, b.rate, b.peril_sw,
                              b.tax_id /* jhing 08.10.2012  */ , b.tax_type , b.tax_amount 
                         FROM giis_tax_charges b
                        WHERE b.line_cd = p_line_cd
                          AND b.iss_cd  (+)= p_iss_cd
                          AND b.primary_sw = 'Y'
                          AND b.eff_start_date <= p_incept_date
                          AND b.eff_end_date   >= p_expiry_date;
        BEGIN
           FOR c6_rec IN c6 LOOP
            BEGIN
              DECLARE
                CURSOR c7 IS SELECT a.peril_cd, SUM(NVL(a.prem_amt,0)) prem_amt,
                                    SUM(NVL(a.tsi_amt,0)) tsi_amt  
                                    /*  jhing 08.10.2012 */,  b.currency_rate, d.peril_type
                               FROM gipi_quote_itmperil a, gipi_quote_item b
                               , /* jhing 08.17.2012 */ gipi_quote c , giis_peril d
                              WHERE a.quote_id      = p_quote_id
                                AND a.quote_id      = b.quote_id
                                AND a.item_no       = b.item_no
                                /* jhing 08.17.2012 */
                                AND a.quote_id = c.quote_id
                                AND c.line_cd  = d.line_cd
                                AND a.peril_cd = d.peril_cd
                                /* end jhing 08.17.2012 */
                                AND b.currency_cd   = c5_rec.currency_cd
                                AND b.currency_rate = c5_rec.currency_rate
                           GROUP BY b.currency_cd, b.currency_rate, a.peril_cd, d.peril_type;
                CURSOR c8 IS SELECT b.currency_cd, b.currency_rate, a.peril_cd, SUM(NVL(a.prem_amt,0)) prem_amt,
                                    SUM(NVL(a.tsi_amt,0)) tsi_amt
                               FROM gipi_quote_itmperil a, gipi_quote_item b
                              WHERE a.quote_id      = p_quote_id
                                AND a.quote_id      = b.quote_id
                                AND a.item_no       = b.item_no
                                AND b.currency_cd   = c5_rec.currency_cd
                                AND b.currency_rate = c5_rec.currency_rate
                                AND a.peril_cd IN (SELECT peril_cd
                                                     FROM giis_tax_peril
                                                    WHERE line_cd = p_line_cd
                                                      AND iss_cd  = p_iss_cd
                                                      AND tax_cd  = c6_rec.tax_cd)
                           GROUP BY b.currency_cd, currency_rate, a.peril_cd;
              BEGIN
                p_tax_id   :=  c6_rec.tax_id;
                IF c6_rec.peril_sw = 'N' THEN
                   BEGIN
                       IF c6_rec.tax_type = 'A' THEN 
                           tax_amt_per_group1 := c6_rec.tax_amount / NVL(c5_rec.currency_rate , 1 )   ; -- currency rate
                       ELSE 
                           v_total_tsi := 0 ;  -- jhing 08.10.2012
                           v_total_prem := 0 ;  -- jhing 08.10.2012
                           FOR c7_rec IN c7 LOOP
                             BEGIN
                             --    p_tax_amt := c7_rec.prem_amt * c6_rec.rate / 100;  -- jhing 08.10.2012
                                IF c7_rec.peril_type = 'B' THEN
                                    v_total_tsi := v_total_tsi + c7_rec.tsi_amt  ;  
                                END IF;                           
                                v_total_prem := v_total_prem + c7_rec.prem_amt ; 
                                v_currency_rate := c7_rec.currency_rate; 
                           -- IF MOD(c7_rec.prem_amt ,4) <> 0 AND c6_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN -- jhing 08.10.2012 
                                IF c6_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN -- jhing 08.10.2012
                               -- p_tax_amt := TRUNC(c7_rec.prem_amt / 4) * (0.5) + (0.5);  -- jhing 08.10.2012 commented out                           
                                   IF v_line_cd = 'AC' THEN 
                                      IF v_param_pa_doc = 1 THEN
                                          p_tax_amt := c7_rec.prem_amt * c6_rec.rate / 100;
                                      ELSIF v_param_pa_doc = 2 THEN
                                          p_tax_amt := CEIL(c7_rec.prem_amt / 200) * (0.5) ;-- jhing 08.10.2012                        
                                      END IF; 
                                   ELSE                                                                   
                                          p_tax_amt := CEIL(c7_rec.prem_amt / 4) * (0.5) ;-- jhing 08.10.2012   
                                   END IF;
                                ELSE
                                    p_tax_amt := c7_rec.prem_amt * c6_rec.rate / 100;

                                END IF;
                                
                                tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;                                                         --==/  of docstamps tax amt
                            
                            END;
                         END LOOP; -- end of c7_rec loop
                                       
                        IF c6_rec.tax_cd = p_doc_stamps  AND p_iss_cd <> 'RI' AND v_param_pa_doc = 3 AND v_line_cd = 'AC'  THEN 
                           BEGIN
                             SELECT tax_amount   / NVL(v_currency_rate , 1 ) 
                              INTO v_tax_range_amt 
                              FROM giis_tax_range gtr
                             WHERE 1=1
                               AND gtr.line_cd  = p_line_cd
                               AND gtr.iss_cd   = p_iss_cd
                               AND gtr.tax_id  = c6_rec.tax_id
                               AND tax_cd       = c6_rec.tax_cd
                               AND v_total_tsi * NVL(v_currency_rate , 1 )   BETWEEN min_value AND max_value;
                               tax_amt_per_group1 := v_tax_range_amt ;  
                           EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     RAISE_APPLICATION_ERROR(-20002, 'NO RECORDS EXIST FOR DOCSTAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).', TRUE);
                           END;   
                        ELSIF c6_rec.tax_type = 'N' AND c6_rec.tax_cd <> p_doc_stamps THEN 
                            BEGIN
                             SELECT tax_amount / NVL(v_currency_rate , 1 )  
                              INTO v_tax_range_amt
                              FROM giis_tax_range gtr
                             WHERE 1=1
                               AND gtr.line_cd  = p_line_cd
                               AND gtr.iss_cd   = p_iss_cd
                               AND gtr.tax_id  = c6_rec.tax_id
                               AND tax_cd       = c6_rec.tax_cd
                               AND v_total_prem *  NVL(v_currency_rate , 1 ) BETWEEN min_value AND max_value;
                               
                               tax_amt_per_group1 := v_tax_range_amt ; 
                               
                            EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                      RAISE_APPLICATION_ERROR(-20002, 'NO RECORDS EXIST FOR TAX IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).', TRUE);
                            END;                        
                        END IF ;                        

                      -- check if Assured is Vatable or not (if assured is already maintained in the tax charge maintenance
                      IF v_assured_no IS NOT NULL AND c6_rec.tax_cd = v_vat_tax_cd AND v_vat_tag IN ('1') THEN --change by steven 11.9.2012: '2'   this is base on SR 0011194
                            tax_amt_per_group1 :=  0 ;
                       END IF;   
                      -- END JHING 08.02.2012
                    END IF; 
                  -- -------------------------------------------------------
                  END;
                ELSE
                  BEGIN
                    FOR c8_rec IN c8 LOOP
                      BEGIN
                       p_tax_amt := c8_rec.prem_amt * c6_rec.rate / 100;
                       -- jhing 08.10.2012  replaced with to synch with create_winvoice and create_docstamps formula                      
                       /*
                       IF MOD(c8_rec.prem_amt ,4) <> 0 AND c6_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                        -- p_tax_amt := TRUNC(c8_rec.prem_amt / 4) * (0.5) + (0.5);    
                       END IF;
                       */
                       -- jhing 08.17.2012 revised code. did not integrate compute PA docstamps code                        
                        IF c6_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
                            IF v_line_cd = 'AC' THEN
                                p_tax_amt := CEIL (c8_rec.prem_amt  / 200 ) * (0.5 ) ; 
                            ELSE
                                p_tax_amt := CEIL (c8_rec.prem_amt  / 4   ) * (0.5 ) ; 
                            END IF;
               
                        END IF;  
                        -- jhing 08.17.2012                      
                        -- computation of tax based on range is not computed here since tax charge with tax type Range is 
                        -- always not peril dependent                       
                        tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                      END;
                    END LOOP; -- end of c8_rec loop
                  END;
                  -- check if Assured is Vatable or not (if assured is already maintained in the tax charge maintenance
                IF v_assured_no IS NOT NULL AND c6_rec.tax_cd = v_vat_tax_cd AND v_vat_tag IN ('1') THEN --change by steven 11.9.2012: '2'  this is base on SR 0011194
                            tax_amt_per_group1 :=  0 ;
                  END IF;   
                 -- END JHING 08.02.2012
                END IF;

                IF tax_amt_per_group1 != 0 THEN
                  FOR quote IN (
                    SELECT quote_inv_no
                      FROM gipi_quote_invoice
                     WHERE quote_id      = p_quote_id
                       AND currency_cd   = c5_rec.currency_cd
                       AND currency_rt   = c5_rec.currency_rate)
                  LOOP
                    v_quote_inv_no := quote.quote_inv_no;
                  END LOOP; -- end of quote loop

                  FOR exist IN (
                     SELECT 'A'
                       FROM gipi_quote_invtax
                      WHERE iss_cd       = p_iss_cd
                        AND quote_inv_no = v_quote_inv_no
                       AND tax_cd = c6_rec.tax_cd)
                  LOOP
                      p_exists2 := 'Y';
                      EXIT;
                  END LOOP;
                  IF v_assured_no IS NOT NULL AND c6_rec.tax_cd = v_vat_tax_cd AND v_vat_tag IN ('2') THEN --added by steven 11.9.2012: When Assured is Zero Vat, VAT should be automatically included in the taxes with zero value. This is base on SR 0011194
                            tax_amt_per_group1 :=  0 ;
                  END IF;
                  IF p_exists2 = 'N' THEN
                     INSERT INTO gipi_quote_invtax
                       (line_cd,       iss_cd,      quote_inv_no,
                        tax_cd,        rate,        tax_amt,
                        tax_id)
                     VALUES
                       (p_line_cd,     p_iss_cd,    v_quote_inv_no,
                        c6_rec.tax_cd, c6_rec.rate, tax_amt_per_group1,
                        p_tax_id);
                  ELSE
                      UPDATE gipi_quote_invtax
                         SET tax_amt = tax_amt_per_group1
                       WHERE iss_cd       = p_iss_cd
                         AND quote_inv_no = v_quote_inv_no
                         AND tax_cd       = c6_rec.tax_cd;

                  END IF;
                END IF;
              END;
              p_exists2 := 'N';
              p_tax_amt := 0;
              tax_amt_per_group1 := 0;
            END;
          END LOOP; -- end of c6_rec loop
        END;
      END;
    END LOOP; -- end of c5_rec loop
    FOR inv IN (
      SELECT iss_cd, quote_inv_no
        FROM gipi_quote_invoice
       WHERE quote_id = p_quote_id)
    LOOP
      FOR tot IN (
        SELECT SUM(NVL(tax_amt,0)) tax_amt
      FROM gipi_quote_invtax
     WHERE iss_cd       = inv.iss_cd
           AND quote_inv_no = inv.quote_inv_no)
      LOOP
          UPDATE gipi_quote_invoice
             SET tax_amt = tot.tax_amt
           WHERE iss_cd       = inv.iss_cd
             AND quote_inv_no = inv.quote_inv_no;
      END LOOP;
    END LOOP;
  END;
END;
/


