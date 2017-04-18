DROP FUNCTION CPI.GET_SHARE_PERCENTAGE_GIPIS085;

CREATE OR REPLACE FUNCTION CPI.GET_SHARE_PERCENTAGE_GIPIS085(
	p_par_id		gipi_wcomm_invoices.par_id%TYPE
	--p_item_grp  	gipi_wcomm_invoices.item_grp%TYPE,
	--p_takeup_seq_no	gipi_wcomm_invoices.takeup_seq_no%TYPE
)
RETURN VARCHAR2
AS
	v_sum_share_percentage	NUMBER;
	v_type                  gipi_parlist.par_type%TYPE;
  	v_endt_tax              gipi_wendttext.endt_tax%type;
	v_enable_post			VARCHAR(1) := 'N';
BEGIN
	SELECT SUM(share_percentage)
      INTO v_sum_share_percentage
      FROM gipi_wcomm_invoices
     WHERE par_id   	 = p_par_id;
       --AND item_grp 	 = p_item_grp
       --AND takeup_seq_no = p_takeup_seq_no;
	   
	SELECT par_type
      INTO v_type
	  FROM gipi_parlist
     WHERE par_id = p_par_id;
	 
	FOR endttax IN (SELECT endt_tax    
          			  FROM gipi_wendttext
         			 WHERE par_id = p_par_id)
	LOOP
		v_endt_tax := endttax.endt_tax;
	END LOOP;

	IF NVL(v_sum_share_percentage,0) < 100 THEN  
   		IF v_type = 'E' AND v_endt_tax = 'Y' THEN	      
    		v_enable_post := 'Y';
   		ELSE
   			v_enable_post := 'N';
   		END IF;   
	ELSE
 		v_enable_post := 'Y';
	END IF;
	
	RETURN v_enable_post;
END;
/


