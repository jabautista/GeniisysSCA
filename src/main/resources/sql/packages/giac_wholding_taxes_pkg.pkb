CREATE OR REPLACE PACKAGE BODY CPI.GIAC_WHOLDING_TAXES_PKG
AS

  /*
  **  Created by	: Emman
  **  Date Created 	: 12.02.2010
  **  Reference By 	: (GIACS022 - Other Trans Withholding Tax)
  **  Description 	: Gets the LOV list of for Whtax Code field on GIACS022, based on specified branch cd 
  */
  
  FUNCTION get_whtax_code_listing (p_gacc_branch_cd	  GIAC_WHOLDING_TAXES.gibr_branch_cd%TYPE)
    RETURN whtax_code_tab PIPELINED
  IS
    v_whtax_code		  		 whtax_code_type;
  BEGIN
    FOR i IN (SELECT gibr_branch_cd, whtax_code, bir_tax_cd,
		  	 		 percent_rate,	 whtax_desc, whtax_id
				FROM GIAC_WHOLDING_TAXES
			   WHERE gibr_branch_cd IN (p_gacc_branch_cd, 'HO')
			ORDER BY whtax_code)
	LOOP
		v_whtax_code.gibr_branch_cd	  					 := i.gibr_branch_cd;
		v_whtax_code.whtax_code	   	  					 := i.whtax_code;
		v_whtax_code.bir_tax_cd							 := i.bir_tax_cd;
		v_whtax_code.percent_rate						 := i.percent_rate;
		v_whtax_code.whtax_desc							 := i.whtax_desc;
		v_whtax_code.whtax_id							 := i.whtax_id;
	
		PIPE ROW(v_whtax_code);
	END LOOP;
  END get_whtax_code_listing;
  
    PROCEDURE check_whtax_code_fk(p_whtax_code				IN     GIAC_WHOLDING_TAXES.whtax_code%TYPE,
			  					  p_bir_tax_cd				IN	   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
								  p_percent_rate			IN	   GIAC_WHOLDING_TAXES.percent_rate%TYPE,
								  p_whtax_desc				IN	   GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
								  p_field_level				IN	   BOOLEAN,
								  p_whtax_id				   OUT GIAC_WHOLDING_TAXES.whtax_id%TYPE,
								  p_message				       OUT VARCHAR2)
	IS
	      /*
		  **  Created by	: Emman
		  **  Date Created 	: 12.02.2010
		  **  Reference By 	: (GIACS022 - Other Trans Withholding Tax)
		  **  Description 	: This validates the foreign key via the non-table lookup item(s), an 
		  **  				  selects the foreign key column(s) into the hidden base table item(s)
		  */
	BEGIN
	  p_message := 'SUCCESS';
	  IF ( p_whtax_code IS NOT NULL
	      OR p_bir_tax_cd IS NOT NULL
	      OR p_percent_rate IS NOT NULL
	      OR p_whtax_desc IS NOT NULL) THEN
	    DECLARE
	      CURSOR C IS
	        SELECT gwta.whtax_id
	        FROM   GIAC_WHOLDING_TAXES gwta
	        WHERE  (gwta.whtax_code = p_whtax_code OR 
	               (gwta.whtax_code IS NULL AND    
	                p_whtax_code IS NULL ))
	        AND    (gwta.bir_tax_cd = p_bir_tax_cd OR 
	               (gwta.bir_tax_cd IS NULL AND    
	                p_bir_tax_cd IS NULL ))
	        AND    (gwta.percent_rate = p_percent_rate OR 
	               (gwta.percent_rate IS NULL AND    
	                p_percent_rate IS NULL ))
	        AND    (gwta.whtax_desc = p_whtax_desc OR 
	               (gwta.whtax_desc IS NULL AND    
	                p_whtax_desc IS NULL ));
	    BEGIN
	      OPEN C;
	      FETCH C
	      INTO   p_whtax_id;
	      IF C%NOTFOUND THEN
	        RAISE NO_DATA_FOUND;
	      END IF;
	      CLOSE C;
	    EXCEPTION
	      WHEN OTHERS THEN
	        NULL;
	    END;
	  ELSE
	    IF (P_FIELD_LEVEL) THEN
	      p_message := 'Warning: Tax Code,BIR Tax Code,Rate,Withholding Tax must be entered';
	    ELSE
	      p_message :=  'Error: Tax Code,BIR Tax Code,Rate,Withholding Tax must be entered';
	    END IF;
	  END IF;
	END check_whtax_code_fk;
  
    PROCEDURE validate_giacs022_whtax_code(p_whtax_code				IN     GIAC_WHOLDING_TAXES.whtax_code%TYPE,
			  							   p_bir_tax_cd				IN	   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
										   p_percent_rate			IN	   GIAC_WHOLDING_TAXES.percent_rate%TYPE,
										   p_whtax_desc				IN	   GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
										   p_whtax_id				   OUT GIAC_WHOLDING_TAXES.whtax_id%TYPE,
										   p_sl_required			   OUT VARCHAR2,
										   p_message				   OUT VARCHAR2)
	IS
	      /*
		  **  Created by	: Emman
		  **  Date Created 	: 12.02.2010
		  **  Reference By 	: (GIACS022 - Other Trans Withholding Tax)
		  **  Description 	: Executes WHEN-VALIDATE-ITEM trigger of WHTAX_CODE in GIACS022 
		  */
	BEGIN
		p_message := 'SUCCESS';
		 /* Check that foreign key value exists in referenced table */
		BEGIN
		  BEGIN
		    /**
			  The Procedure CGFK$LKP_GTWH_GTWH_GWTX_FK
			**/
			check_whtax_code_fk(p_whtax_code, p_bir_tax_cd, p_percent_rate, p_whtax_desc, TRUE, p_whtax_id, p_message);
		  EXCEPTION
		    WHEN NO_DATA_FOUND THEN
		      p_message := 'Warning: This Tax Code,BIR Tax Code,Rate,Withholding Tax does not exist';
		    WHEN OTHERS THEN
		      NULL;
		  END;
		END;
		
		/*validate sl code*/
		DECLARE
		    v_exist    varchar2(1);
		begin
		 BEGIN
		  SELECT distinct 'x'
		    INTO v_exist
		    FROM giac_wholding_taxes a, giac_sl_lists b
		   WHERE a.sl_type_cd = b.sl_type_cd
		     AND a.whtax_code = p_whtax_code;
		
			p_sl_required := 'Y';	    
		 EXCEPTION
		   WHEN no_data_found then 
		     p_sl_required := 'N';
		 END;
		end;
	END validate_giacs022_whtax_code;

END GIAC_WHOLDING_TAXES_PKG;
/


