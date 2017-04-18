DROP PROCEDURE CPI.CHECK_TAX_AMOUNT;

CREATE OR REPLACE PROCEDURE CPI.CHECK_TAX_AMOUNT(
    p_tax_cd        IN      GIIS_TAX_CHARGES.tax_cd%TYPE,
    p_tax_id        IN      GIIS_TAX_CHARGES.tax_id%TYPE,
    p_line_cd       IN      GIIS_TAX_CHARGES.line_cd%TYPE,
    p_iss_cd        IN      GIIS_TAX_CHARGES.iss_cd%TYPE,
    p_prem_amt      IN      GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
    p_currency_rate IN      GIPI_QUOTE_ITEM.currency_rate%TYPE,
    p_tax_amount    OUT     GIIS_TAX_CHARGES.tax_amount%TYPE,
    p_message       OUT     VARCHAR2
)
AS
    v_rate                  GIIS_TAX_CHARGES.rate%TYPE;
    v_tax_type              GIIS_TAX_CHARGES.tax_type%TYPE;
    v_tax_amount            GIIS_TAX_CHARGES.tax_amount%TYPE;
    v_temp_tax              GIPI_QUOTE_INVTAX.tax_amt%TYPE;
BEGIN
    p_message := 'SUCCESS';

    FOR i IN (SELECT rate, tax_type, tax_amount
                FROM GIIS_TAX_CHARGES
               WHERE line_cd = p_line_cd
                 AND iss_cd = p_iss_cd
                 AND tax_cd = p_tax_cd)
    LOOP
        v_rate := i.rate;
        v_tax_type := i.tax_type;
        v_tax_amount := i.tax_amount; 
    END LOOP;
    
    IF v_tax_type = 'A' THEN
        --v_tax_amount := ROUND(v_tax_amount / NVL(p_currency_rate, 1), 2);
        
        IF v_tax_amount > p_prem_amt  THEN
            p_message := 'Tax amount cannot be greater than premium amount.';
        ELSE
            p_tax_amount := ROUND(v_tax_amount / NVL(p_currency_rate, 1), 2);          
        END IF;
    ELSIF v_tax_type = 'N' THEN
        BEGIN
            SELECT tax_amount  
              INTO v_temp_tax
              FROM GIIS_TAX_RANGE
             WHERE iss_cd = p_iss_cd
               AND line_cd = p_line_cd
               AND tax_cd = p_tax_cd
               AND tax_id = p_tax_id
               AND p_prem_amt * NVL(p_currency_rate, 1) BETWEEN min_value and max_value;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_message := 'No record exists for this line, issuing source and tax code(GIIS_TAX_RANGE).';
        END;
        
        v_tax_amount := ROUND(v_temp_tax / NVL(p_currency_rate, 1), 2);
        
        IF v_tax_amount > p_prem_amt  THEN
            p_message := 'Tax amount cannot be greater than premium amount.';
        ELSE
            p_tax_amount := ROUND(v_tax_amount / NVL(p_currency_rate, 1), 2);          
        END IF;
    ELSE
        p_tax_amount := p_prem_amt * (v_rate / 100);
    END IF;
END;
/


