DROP PROCEDURE CPI.UPDATE_POLICY_ITEM_PERIL_PREM;

CREATE OR REPLACE PROCEDURE CPI.update_policy_item_peril_prem (
   p_quote_id   gipi_quote.quote_id%TYPE
)
IS
   sum_peril_discount   NUMBER := 0;
   peril_discount_Count NUMBER :=0;
   item_discount_Count NUMBER :=0;
   policy_discount_Count NUMBER :=0;
BEGIN
   --dbms_output.put_line(v_counter);
   FOR i IN (SELECT   quote_id, item_no, orig_prem_amt,
                      SUM (disc_amt) disc_total
                 FROM gipi_quote_item_discount
                WHERE quote_id = p_quote_id
             GROUP BY quote_id, item_no, orig_prem_amt)
   LOOP
      UPDATE gipi_quote_itmperil
         SET prem_amt =
                  ann_prem_amt
                - (i.disc_total * (ann_prem_amt / i.orig_prem_amt))
       WHERE quote_id = p_quote_id AND item_no = i.item_no;

      UPDATE gipi_quote_item_discount
         SET net_prem_amt = orig_prem_amt - i.disc_total
       WHERE quote_id = p_quote_id AND item_no = i.item_no;
   END LOOP;

   FOR i IN (SELECT   quote_id, item_no, peril_cd, SUM (disc_amt) disc_total
                 FROM gipi_quote_peril_discount
                WHERE quote_id = p_quote_id
             GROUP BY quote_id, item_no, peril_cd)
   LOOP
   	  peril_discount_Count := peril_discount_Count + 1;
      UPDATE gipi_quote_itmperil
         SET prem_amt = ann_prem_amt - i.disc_total
       WHERE quote_id = i.quote_id
         AND item_no = i.item_no
         AND peril_cd = i.peril_cd;

      UPDATE gipi_quote_peril_discount
         SET net_prem_amt = orig_peril_prem_amt - i.disc_total
       WHERE quote_id = p_quote_id
         AND item_no = i.item_no
         AND peril_cd = i.peril_cd;
   END LOOP;
   
   IF peril_discount_Count = 0 AND item_discount_Count = 0 AND policy_discount_Count = 0 THEN
   	  FOR i IN (SELECT quote_id, item_no, peril_cd from gipi_quote_itmperil WHERE quote_id = p_quote_id)
	  LOOP
		  UPDATE gipi_quote_itmperil
	         SET prem_amt = ann_prem_amt 
	       WHERE quote_id = i.quote_id
	         AND item_no = i.item_no
	         AND peril_cd = i.peril_cd;
	  END LOOP; 	 
   END IF;

   FOR i IN (SELECT quote_id, item_no
               FROM gipi_quote_item
              WHERE quote_id = p_quote_id)
   LOOP
      UPDATE gipi_quote_item
         SET prem_amt =
                  ann_prem_amt
                - (  (SELECT nvl(SUM (disc_amt),0)
                        FROM gipi_quote_peril_discount
                       WHERE quote_id = p_quote_id)
                   + (SELECT nvl(SUM (disc_amt),0)
                        FROM gipi_quote_item_discount
                       WHERE quote_id = p_quote_id)
                  )
       WHERE quote_id = i.quote_id AND item_no = i.item_no;
   END LOOP;

   --Update policy level
   UPDATE gipi_quote
      SET prem_amt = (SELECT SUM (prem_amt)
                        FROM gipi_quote_item
                       WHERE quote_id = p_quote_id)
    WHERE quote_id = p_quote_id;
END;
/


