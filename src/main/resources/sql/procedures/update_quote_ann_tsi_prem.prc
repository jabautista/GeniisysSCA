DROP PROCEDURE CPI.UPDATE_QUOTE_ANN_TSI_PREM;

CREATE OR REPLACE PROCEDURE CPI.update_quote_ann_tsi_prem
(p_quote_id         GIPI_QUOTE.quote_id%TYPE,
 p_item_no          GIPI_QUOTE_ITEM.item_no%TYPE,
 p_line_cd          GIPI_QUOTE.line_cd%TYPE)
 
 AS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 26, 2011
**  Reference By  : GIIMM002 - Quotation / Package Quotation Information
**  Description   : Procedure updates values of ann_tsi_amt and ann_prem_amt
**                  in GIPI_QUOTE_ITEM and GIPI_QUOTE tables
*/
  
  v_tsi                     NUMBER;
  v_prem                    NUMBER;
  v_tsi_amt                 NUMBER;
  v_prem_amt                NUMBER;
  v_ann_tsi					NUMBER;
  v_ann_prem				NUMBER;
  v_ann_tsi_q				NUMBER;
  v_ann_prem_q				NUMBER;
 
BEGIN
    
    BEGIN
        SELECT SUM (a.tsi_amt) tsi_amt
          INTO v_tsi_amt
          FROM gipi_quote_itmperil a, giis_peril b
         WHERE a.quote_id = p_quote_id
           AND a.item_no  = p_item_no
           AND b.line_cd  = p_line_cd 
           AND a.peril_cd = b.peril_cd
           AND b.peril_type = 'B';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
    END;
    
    BEGIN
        SELECT SUM(prem_amt)
          INTO v_prem_amt
          FROM gipi_quote_itmperil 
          WHERE quote_id = p_quote_id 
            AND item_no  = p_item_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
    END;
    
    
    BEGIN
        SELECT SUM(ann_prem_amt)
          INTO v_ann_prem
          FROM gipi_quote_itmperil 
          WHERE quote_id = p_quote_id 
            AND item_no  = p_item_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
    END;
    
    BEGIN
        SELECT SUM(a.ann_tsi_amt)
          INTO v_ann_tsi
          FROM gipi_quote_itmperil a, giis_peril b 
          WHERE a.quote_id  = p_quote_id
            AND a.item_no  	= p_item_no
	 	   AND b.line_cd  	= p_line_cd
	 	   AND a.peril_cd   = b.peril_cd
	 	   AND b.peril_type = 'B';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL;
	END;

	UPDATE gipi_quote_item
	   SET tsi_amt        = v_tsi_amt, 
	       prem_amt       = v_prem_amt,
           ann_tsi_amt    = v_ann_tsi, 
	       ann_prem_amt   = v_ann_prem
	 WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no;
       
    BEGIN
		SELECT SUM(tsi_amt), SUM(prem_amt), SUM(ann_tsi_amt), SUM(ann_prem_amt)
	  	INTO v_tsi, v_prem, v_ann_tsi_q, v_ann_prem_q
	  	FROM gipi_quote_item 
	 	 WHERE quote_id =  p_quote_id;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL;
	END;	

	UPDATE gipi_quote
	   SET tsi_amt      = v_tsi, 
	       prem_amt     = v_prem,
	       ann_tsi_amt  = v_ann_tsi_q, 
	       ann_prem_amt = v_ann_prem_q
 	 WHERE quote_id =  p_quote_id; 	

END update_quote_ann_tsi_prem;
/


