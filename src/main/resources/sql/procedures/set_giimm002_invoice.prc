DROP PROCEDURE CPI.SET_GIIMM002_INVOICE;

CREATE OR REPLACE PROCEDURE CPI.set_giimm002_invoice(
    p_quote_id          GIPI_QUOTE.quote_id%TYPE,
    p_item_no           GIPI_QUOTE_ITEM.item_no%TYPE
)
IS
    CURSOR CUR_A IS (SELECT param_value_n
                       FROM GIAC_PARAMETERS
                      WHERE param_name = 'DOC_STAMPS');
    CURSOR CUR_B IS (SELECT param_value_v
                       FROM GIIS_PARAMETERS
                      WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS');

    v_currency          NUMBER := 0;
    v_max_quote_inv_no  NUMBER := 0;
    v_exists            VARCHAR2(1) := 'N';
    v_line_cd           GIPI_QUOTE.line_cd%TYPE;
    v_iss_cd            GIPI_QUOTE.iss_cd%TYPE;
    v_incept_date       GIPI_QUOTE.incept_date%TYPE;
    v_doc_stamps        GIIS_TAX_CHARGES.tax_cd%TYPE;
    v_param_doc         GIIS_PARAMETERS.param_value_v%TYPE;
    v_item_title        GIPI_QUOTE_ITEM.item_title%TYPE;
    v_prem_amt          GIPI_QUOTE_ITEM.prem_amt%TYPE;
    v_prem_amt2         GIPI_QUOTE_ITEM.prem_amt%TYPE;
    v_currency_cd       GIPI_QUOTE_ITEM.currency_cd%TYPE;
    v_currency_rate     GIPI_QUOTE_ITEM.currency_rate%TYPE;
    v_quote_inv_no      GIPI_QUOTE_INVOICE.quote_inv_no%TYPE;
    v_tax_amt           GIPI_QUOTE_INVOICE.tax_amt%TYPE;
    v_sum_tax_amt       GIPI_QUOTE_INVOICE.tax_amt%TYPE;
    v_temp_tax          GIPI_QUOTE_INVTAX.tax_amt%TYPE; -- marco - 08.31.2012
    v_tsi_amt           GIPI_QUOTE.tsi_amt%TYPE; -- marco - 08.31.2012
    v_peril_exist       VARCHAR2(1) := 'N'; -- Nica 11.06.2012
BEGIN
    BEGIN
        SELECT line_cd, iss_cd, incept_date, tsi_amt
          INTO v_line_cd, v_iss_cd, v_incept_date, v_tsi_amt
          FROM GIPI_QUOTE
         WHERE quote_id = p_quote_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT currency_cd, item_title, currency_rate
          INTO v_currency_cd, v_item_title, v_currency_rate
          FROM GIPI_QUOTE_ITEM
         WHERE quote_id = p_quote_id
           AND item_no = p_item_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    FOR v IN (SELECT quote_inv_no
                FROM GIPI_QUOTE_INVOICE
			   WHERE currency_cd = v_currency_cd
				 AND quote_id = p_quote_id)
    LOOP 
	 	v_currency := 1;				 
	 	v_quote_inv_no := v.quote_inv_no;
	END LOOP;
    
    BEGIN
--        SELECT SUM(prem_amt)
--          INTO v_prem_amt
--          FROM GIPI_QUOTE_ITMPERIL
--         WHERE quote_id = p_quote_id;
        SELECT SUM(a.prem_amt)
          INTO v_prem_amt
          FROM GIPI_QUOTE_ITMPERIL a,
               GIPI_QUOTE_ITEM b
         WHERE a.quote_id = b.quote_id
           AND a.item_no = b.item_no
           AND b.currency_cd = v_currency_cd
           AND a.quote_id = p_quote_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_prem_amt := 0;
    END;
    
    IF v_currency = 1 THEN
        UPDATE GIPI_QUOTE_INVOICE
           SET prem_amt = v_prem_amt  
         WHERE quote_inv_no = v_quote_inv_no;
    
        BEGIN
            OPEN CUR_A;
                FETCH CUR_A
                 INTO v_doc_stamps;
            CLOSE CUR_A;
            OPEN CUR_B;
                FETCH CUR_B
                 INTO v_param_doc;
            CLOSE CUR_B;
            
            FOR v IN(SELECT rate, tax_cd, peril_sw, tax_type, tax_amount, tax_id
                       FROM GIIS_TAX_CHARGES
                      WHERE line_cd = v_line_cd
                        AND iss_cd = v_iss_cd
                        AND primary_sw = 'Y'
                        AND eff_start_date <= v_incept_date                                     
                        AND eff_end_date   >= v_incept_date)
            LOOP
                /* IF MOD(v_prem_amt,4) <> 0 AND v.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
                    v_tax_amt := TRUNC(v_prem_amt / 4) * (0.5) + (0.5);
                ELSIF MOD(v_prem_amt,4) = 0 AND v.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
                    v_tax_amt := TRUNC(v_prem_amt / 4) * (0.5);
                ELSIF v.tax_cd = v_doc_stamps AND v_param_doc = 'N' THEN
                    v_tax_amt := NVL(v.rate,0) * NVL(v_prem_amt,0) / 100; */
                IF v.tax_cd = v_doc_stamps AND v_param_doc = 'N' THEN
                    v_tax_amt := NVL(v.rate,0) * NVL(v_prem_amt,0) / 100;
                ELSE
                    IF v.peril_sw = 'Y' THEN
                        v_prem_amt2 := 0;
                        FOR i IN (SELECT peril_cd
                                    FROM GIIS_TAX_PERIL                                   
                                   WHERE iss_cd = v_iss_cd
                                     AND line_cd = v_line_cd
                                     AND tax_cd = v.tax_cd)
                        LOOP
                            FOR m IN (SELECT prem_amt
                                        FROM GIPI_QUOTE_ITMPERIL
                                       WHERE quote_id = p_quote_id 
                                         AND peril_cd = i.peril_cd)
                            LOOP
                                v_prem_amt2 := v_prem_amt2 + m.prem_amt;           
                            END LOOP;
                        END LOOP;
                        v_tax_amt := NVL(v.rate,0) * NVL(v_prem_amt2,0) / 100;
                    ELSE
                        --v_tax_amt := NVL(v.rate,0) * NVL(v_prem_amt,0) / 100;
                        
                        -- marco - 08.31.2012 - modified to include tax enhancement
                        IF v.tax_type = 'A' THEN
                            v_tax_amt := ROUND(v.tax_amount / NVL(v_currency_rate, 1), 2);
                        ELSIF v.tax_type = 'N' THEN
                            BEGIN
                                SELECT tax_amount  
                                  INTO v_temp_tax
                                  FROM GIIS_TAX_RANGE
                                 WHERE iss_cd = v_iss_cd
                                   AND line_cd = v_line_cd
                                   AND tax_cd = v.tax_cd
                                   AND tax_id = v.tax_id
                                   --AND v_prem_amt * NVL(v_currency_rate, 1) BETWEEN min_value and max_value;
                                   AND v_tsi_amt * NVL(v_currency_rate, 1) BETWEEN min_value and max_value;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    v_temp_tax := 0;
                            END;
                            v_tax_amt := ROUND(v_temp_tax / NVL(v_currency_rate, 1), 2);
                            
                            --v_tax_amt := ROUND(v_tax_amt / NVL(v_currency_rate, 1), 2);   
                        ELSE
                            v_tax_amt := v_prem_amt * (v.rate / 100);
                        END IF;
                        -- end of tax enhancement
                        
                    END IF;
                END IF;
                
                UPDATE GIPI_QUOTE_INVTAX
                   SET tax_amt = v_tax_amt
                 WHERE quote_inv_no = v_quote_inv_no
                   AND iss_cd = v_iss_cd
                   AND tax_cd = v.tax_cd
		   		   AND line_cd = v_line_cd;
            END LOOP;
			
			-- check if perils exist before calling create_quote_invoice 
            -- to prevent ORA-1400 - Nica 11.06.2012
            FOR i IN (SELECT 'Y'
                        FROM GIPI_QUOTE_ITMPERIL
                       WHERE quote_id = p_quote_id
                         AND item_no = p_item_no)
            LOOP
                v_peril_exist := 'Y';
            END LOOP;
            
            IF(v_peril_exist = 'Y') THEN
                create_quote_invoice(p_quote_id, v_line_cd, v_iss_cd); -- added by Nica 09.27.2012
            END IF;
            
            BEGIN
                SELECT SUM(tax_amt) tax
                  INTO v_sum_tax_amt
                  FROM GIPI_QUOTE_INVTAX
                 WHERE quote_inv_no = v_quote_inv_no
                   AND iss_cd = v_iss_cd
                   AND line_cd = v_line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_sum_tax_amt := 0;
            END;
               
            UPDATE GIPI_QUOTE_INVOICE
               SET tax_amt = v_sum_tax_amt
             WHERE quote_inv_no = v_quote_inv_no;
        END;
    ELSIF v_currency = 0 AND v_item_title IS NOT NULL THEN
        FOR b1 IN (SELECT 1 
                     FROM GIPI_QUOTE_INVOICE 
                    WHERE quote_id = p_quote_id) 
        LOOP
           v_exists := 'Y';
        END LOOP;
        
        BEGIN
            SELECT NVL(MAX(quote_inv_no), 0)
              INTO v_max_quote_inv_no
              FROM GIIS_QUOTE_INV_SEQ
             WHERE iss_cd = v_iss_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_max_quote_inv_no := 0;
        END;
        
        IF v_exists = 'N' THEN
 	        INSERT INTO GIPI_QUOTE_INVOICE(quote_id, iss_cd, quote_inv_no, currency_cd, currency_rt, prem_amt)
				   VALUES(p_quote_id, v_iss_cd, v_max_quote_inv_no + 1, v_currency_cd, v_currency_rate, v_prem_amt);
        END IF;
        
        create_quote_invoice(p_quote_id, v_line_cd, v_iss_cd);
    END IF;
	
	--added codes by robert 10.11.2013 to set the default intm no
    BEGIN
       BEGIN
          FOR x IN (SELECT intm_no, quote_inv_no, iss_cd
                      FROM gipi_quote_invoice
                     WHERE quote_id = p_quote_id)
          LOOP
             IF x.intm_no IS NULL
             THEN
                UPDATE gipi_quote_invoice
                   SET intm_no = gipi_quote_invoice_pkg.get_default_intermediary(p_quote_id)
                 WHERE quote_inv_no = x.quote_inv_no AND iss_cd = x.iss_cd;
             END IF;
          END LOOP;
       END;
    END;
END;
/


