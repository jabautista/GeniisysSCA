DROP PROCEDURE CPI.UPDATE_GIPI_QUOTE_ITMPERIL;

CREATE OR REPLACE PROCEDURE CPI.update_gipi_quote_itmperil(
    p_quote_id              GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              GIPI_QUOTE_ITMPERIL.peril_cd%TYPE
)
IS
    v_prorate_flag          GIPI_QUOTE.prorate_flag%TYPE;
    v_comp_sw               GIPI_QUOTE.comp_sw%TYPE;
    v_expiry                GIPI_QUOTE.expiry_date%TYPE;
    v_incept                GIPI_QUOTE.incept_date%TYPE;
    v_short_rt              GIPI_QUOTE.short_rt_percent%TYPE;
    v_ann_tsi_amt           GIPI_QUOTE_ITMPERIL.ann_tsi_amt%TYPE;
    v_ann_prem_amt          GIPI_QUOTE_ITMPERIL.ann_prem_amt%TYPE;
    v_prem_rt               GIPI_QUOTE_ITMPERIL.prem_rt%TYPE;
    v_no_of_days            NUMBER;
    v_denominator           NUMBER;
BEGIN
    FOR i IN(SELECT prorate_flag, comp_sw, expiry_date, incept_date, short_rt_percent
  	           FROM GIPI_QUOTE
              WHERE quote_id = p_quote_id)
    LOOP
        v_prorate_flag := i.prorate_flag;
        v_comp_sw      := i.comp_sw;
        v_expiry       := i.expiry_date;
        v_incept       := i.incept_date;
        v_short_rt     := i.short_rt_percent / 100;
        v_no_of_days   := i.expiry_date - i.incept_date;
    END LOOP;
    
    v_denominator := check_duration(v_incept, v_expiry);
    
    FOR s IN (SELECT tsi_amt, prem_rt, peril_cd, prem_amt
	    	    FROM GIPI_QUOTE_ITMPERIL
	   		   WHERE quote_id = p_quote_id
	             AND item_no = p_item_no
	             AND peril_cd = p_peril_cd)
    LOOP
        v_ann_tsi_amt := s.tsi_amt;
        v_prem_rt := (s.prem_rt / 100);
        
        IF s.prem_rt = 0 AND s.prem_amt != 0 THEN
            v_ann_prem_amt := s.prem_amt;
        ELSE
            --v_ann_prem_amt := s.tsi_amt * v_prem_rt;
            v_ann_prem_amt := TRUNC(s.tsi_amt * v_prem_rt, 2); -- bonok :: 04.21.2014 :: solution for ORA-01438: value larger than specified precision allowed for this column
        END IF;
        
        IF v_prorate_flag = '1' THEN
            IF v_comp_sw = 'Y' THEN
                v_ann_prem_amt := (v_ann_prem_amt * (v_no_of_days + 1)) / v_denominator;
            ELSIF v_comp_sw = 'M' THEN
                v_ann_prem_amt := (v_ann_prem_amt * (v_no_of_days - 1)) / v_denominator;
            ELSIF v_comp_sw NOT IN ('M','Y') OR v_comp_sw IS NULL THEN
                v_ann_prem_amt := (v_ann_prem_amt * v_no_of_days) / v_denominator;
            END IF;
        ELSIF v_prorate_flag = '2' OR v_prorate_flag IS NULL THEN
            v_ann_prem_amt := v_ann_prem_amt;
        ELSIF v_prorate_flag = '3' THEN
            v_ann_prem_amt := v_ann_prem_amt * v_short_rt;
        END IF;
        
        UPDATE GIPI_QUOTE_ITMPERIL
	       SET ann_tsi_amt = v_ann_tsi_amt,
		       ann_prem_amt = v_ann_prem_amt
		 WHERE quote_id = p_quote_id
	       AND item_no = p_item_no
	       AND peril_cd = p_peril_cd;
        
    END LOOP;
END;
/


