DROP PROCEDURE CPI.UPDATE_QUOTE_INVOICE_DTLS;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_QUOTE_INVOICE_DTLS
 (p_quote_id         GIPI_QUOTE_INVOICE.quote_id%TYPE,
  p_currency_cd      GIPI_QUOTE_INVOICE.currency_cd%TYPE,
  p_currency_rt      GIPI_QUOTE_INVOICE.currency_rt%TYPE)
  
AS

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 8, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Procedure INSERT/UPDATES records in  
**                  GIPI_QUOTE_INVOICE and GIPI_QUOTE_INVTAX tables
*/
  
  CURSOR CUR_A IS (SELECT param_value_n
                     FROM giac_parameters
                    WHERE param_name = 'DOC_STAMPS');
  CURSOR CUR_B IS (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS'); 
                                                                  
                                                                                             
  v_line_cd           GIPI_QUOTE.line_cd%TYPE;
  v_iss_cd            GIPI_QUOTE.iss_cd%TYPE;
  v_incept_date       GIPI_QUOTE.incept_date%TYPE;                                                                  
  v_doc_stamps        giis_tax_charges.tax_cd%TYPE;  
  v_param_doc         giis_parameters.param_value_v%TYPE; 
  v_currency          NUMBER := 0;
  v_prem_amt          GIPI_QUOTE_ITEM.PREM_AMT%TYPE;
  v_prem_amt2         GIPI_QUOTE_ITEM.PREM_AMT%TYPE; 
  v_quote_inv_no      GIPI_QUOTE_INVOICE.QUOTE_INV_NO%TYPE;
  v_quote             GIPI_QUOTE_INVOICE.quote_id%TYPE;
  v_max_quote_inv_no  NUMBER;
  v_tax_amt           GIPI_QUOTE_INVTAX.tax_amt%TYPE;
  v_sum_tax_amt       GIPI_QUOTE_INVOICE.tax_amt%TYPE; 
  v_tax               gipi_quote_invoice.tax_amt%TYPE;  
  v_exists            VARCHAR2(1) := 'N';    
  
  
BEGIN
    FOR i IN (SELECT line_cd, iss_cd, incept_date
              FROM gipi_quote
              WHERE quote_id = p_quote_id)
    
    LOOP
        
        v_line_cd := i.line_cd;
        v_iss_cd  := i.iss_cd;
        v_incept_date := i.incept_date;
        
    END LOOP;
              
    
    FOR v IN (SELECT quote_inv_no
              FROM gipi_quote_invoice
              WHERE currency_cd = p_currency_cd
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
		   AND b.currency_cd = p_currency_cd
		   AND a.quote_id = p_quote_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_prem_amt := 0;
    END;

    IF v_currency = 1 THEN
        
        UPDATE gipi_quote_invoice
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
           
           FOR V IN (SELECT rate, tax_cd, peril_sw
                     FROM giis_tax_charges 
                     WHERE line_cd = v_line_cd
                     AND iss_cd = v_iss_cd
                     AND primary_sw = 'Y'
                     AND eff_start_date <=  v_incept_date                                     
                     AND eff_end_date   >=  v_incept_date) 
           LOOP
                
               IF MOD(v_prem_amt,4) <> 0 AND v.tax_cd = v_doc_stamps 
                   AND v_param_doc = 'Y' THEN
                  v_tax_amt := TRUNC(v_prem_amt / 4) * (0.5) + (0.5);
               
               ELSIF MOD(v_prem_amt,4) = 0 AND v.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
                 v_tax_amt := TRUNC(v_prem_amt / 4) * (0.5);
    	       
               ELSIF v.tax_cd = v_doc_stamps AND v_param_doc = 'N' THEN
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
                            FOR M IN (SELECT prem_amt
                                      FROM GIPI_QUOTE_ITMPERIL
                                      WHERE quote_id = p_quote_id
                                      AND peril_cd = i.peril_cd)
                                      
                            LOOP
                                v_prem_amt2 := v_prem_amt2 + m.prem_amt; 	      
                            END LOOP;
                 	    
                        END LOOP; 
        	       	  
                      v_tax_amt := NVL(v.rate,0) * NVL(v_prem_amt2,0) / 100;
        	       	
                    ELSE
                      v_tax_amt := NVL(v.rate,0) * NVL(v_prem_amt,0) / 100;
        	       	
                    END IF;
        	       		       
               END IF;   

              UPDATE GIPI_QUOTE_INVTAX
                 SET tax_amt = v_tax_amt
              WHERE quote_inv_no = v_quote_inv_no
              AND iss_cd = v_iss_cd
              AND tax_cd = v.tax_cd
              AND line_cd = v_line_cd;

            END LOOP;
            
            SELECT SUM(tax_amt) tax  
              INTO v_sum_tax_amt
            FROM gipi_quote_invtax
            WHERE quote_inv_no = v_quote_inv_no
              AND iss_cd = v_iss_cd
              AND line_cd = v_line_cd; 
    			
            v_tax := v_sum_tax_amt; 

            UPDATE gipi_quote_invoice  
              SET tax_amt = v_tax
            WHERE quote_inv_no = v_quote_inv_no;
        END;
    
    ELSIF v_currency = 0 THEN
        
        FOR b1 IN (SELECT 1 
                   FROM gipi_quote_invoice 
                   WHERE quote_id = p_quote_id) 
        LOOP
            v_exists := 'Y';
        END LOOP;
        
        FOR J IN (SELECT quote_inv_no
                  FROM giis_quote_inv_seq
                  WHERE iss_cd = v_iss_cd) 
        LOOP
            v_max_quote_inv_no := J.quote_inv_no + 1;
            EXIT;
        END LOOP;
        
        IF v_max_quote_inv_no IS NULL THEN
			v_max_quote_inv_no := 0;
		END IF;
        
        IF v_exists = 'N' THEN           
 	      INSERT INTO gipi_quote_invoice(quote_id, iss_cd, quote_inv_no, currency_cd, currency_rt, prem_amt)
		  VALUES (p_quote_id, v_iss_cd, v_max_quote_inv_no +1, p_currency_cd, p_currency_rt, v_prem_amt); 
        END IF;
        
        create_quote_invoice(p_quote_id,v_line_cd, v_iss_cd);
        
    END IF;    
    
END;
/


