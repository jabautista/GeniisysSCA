DROP FUNCTION CPI.COUNT_PERIL_ITEM;

CREATE OR REPLACE FUNCTION CPI.count_peril_item(p_extract_id	gixx_item.extract_id%TYPE,
	   	  		  		   					p_item_no		gixx_item.item_no%type) RETURN VARCHAR2 IS
	v_show varchar2(1):= 'N';
	v_co_ins_sw VARCHAR2(1);
BEGIN

	BEGIN
	  SELECT co_insurance_sw
	    INTO v_co_ins_sw
		FROM GIXX_POLBASIC
	   WHERE extract_id = p_extract_id;
	EXCEPTION
	  WHEN NO_DATA_FOUND THEN NULL;
	END;
	

	IF v_co_ins_sw = 1 THEN 
		 FOR a IN (
		   SELECT extract_id
		     FROM gixx_itmperil
		    WHERE extract_id = p_extract_id
		    	AND item_no    = p_item_no)
		 LOOP
		 	 v_show := 'Y';
		 	 EXIT;
		 END LOOP;
	ELSE
		 FOR a IN (
		   SELECT count(extract_id) count
		     FROM gixx_orig_itmperil
		    WHERE extract_id = p_extract_id
		      AND item_no    = p_item_no)
		 LOOP
		 	 v_show := 'Y';
		 	 EXIT;
		 END LOOP;
	END IF;
	

		 RETURN (v_show);
	
  
END;
/


