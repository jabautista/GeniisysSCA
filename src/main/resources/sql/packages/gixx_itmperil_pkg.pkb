CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Itmperil_Pkg AS   

	FUNCTION get_pol_doc_item_peril (
		p_extract_id IN GIXX_ITMPERIL.extract_id%TYPE,
		p_report_id  IN GIIS_DOCUMENT.report_id%TYPE,
		p_item_no    IN GIXX_ITMPERIL.item_no%TYPE)
	RETURN pol_doc_item_peril_tab PIPELINED
	IS     
		v_item_peril_table pol_doc_item_peril_type;   
	BEGIN
		FOR i IN (     
			SELECT ALL peril.SEQUENCE, itmperil.extract_id, 
					   itmperil.item_no item_no,
					   itmperil.line_cd line_cd, 
					   itmperil.peril_cd peril_cd,	   
					   itmperil.comp_rem comp_rem,
					   peril.peril_sname peril_sname,
					   NVL(peril.peril_lname, peril.peril_name) peril_lname, 
					   NVL(itmperil.tsi_amt, 0) tsi_amt, 
					   NVL(itmperil.prem_amt, 0) prem_amt, 
					   NVL(itmperil.prem_rt,0) prem_rt, 
					   peril_type peril_type,
					   peril.peril_name peril_name
				  FROM GIXX_ITMPERIL itmperil, 
					   GIIS_PERIL peril,
					   GIXX_POLBASIC pol
				 WHERE itmperil.peril_cd = peril.peril_cd
				   AND itmperil.line_cd = peril.line_cd
				   AND itmperil.extract_id = p_extract_id
				   AND itmperil.extract_id = pol.extract_id
				   AND pol.co_insurance_sw IN ('1','3')
				   AND itmperil.item_no = p_item_no
				UNION
				SELECT ALL peril.SEQUENCE, itmperil.extract_id, 
					   itmperil.item_no item_no,
					   itmperil.line_cd line_cd, 
					   itmperil.peril_cd peril_cd,	   
					   itmperil.comp_rem icomp_rem,
					   peril.peril_sname peril_sname, 
					   NVL(peril.peril_lname, peril.peril_name) peril_lname, 
					   NVL(itmperil.tsi_amt, 0) tsi_amt, 
					   NVL(itmperil.prem_amt, 0) prem_amt, 
					   NVL(itmperil.prem_rt, 0) prem_rt,
					   peril_type peril_type,
					   peril.peril_name peril_name
				  FROM GIXX_ORIG_ITMPERIL itmperil, 
					   GIIS_PERIL peril,
					   GIXX_POLBASIC pol
				 WHERE itmperil.peril_cd = peril.peril_cd
				   AND itmperil.line_cd = peril.line_cd
				   AND itmperil.extract_id = p_extract_id
				   AND itmperil.extract_id = pol.extract_id
				   AND pol.co_insurance_sw = '2'
				   AND itmperil.item_no = p_item_no
				ORDER BY 1)
		LOOP
			v_item_peril_table.SEQUENCE		:= i.SEQUENCE;
			v_item_peril_table.extract_id	:= i.extract_id;
			v_item_peril_table.item_no		:= i.item_no;
			v_item_peril_table.line_cd		:= i.line_cd;
			v_item_peril_table.peril_cd	    := i.peril_cd;
			v_item_peril_table.comp_rem	    := i.comp_rem;
			v_item_peril_table.peril_sname	:= i.peril_sname;
			v_item_peril_table.peril_lname	:= i.peril_lname;
			v_item_peril_table.tsi_amt		:= i.tsi_amt;
			v_item_peril_table.prem_amt	    := i.prem_amt;
			v_item_peril_table.prem_rt		:= i.prem_rt;
			v_item_peril_table.peril_type	:= i.peril_type;
			v_item_peril_table.peril_name	:= i.peril_name;

			v_item_peril_table.f_peril_name := Gixx_Itmperil_Pkg.get_peril_name(p_report_id, i.peril_lname, i.peril_sname, i.peril_name);
			v_item_peril_table.f_tsi_amt	:= Gixx_Itmperil_Pkg.get_tsi_amt(p_extract_id, i.item_no, i.tsi_amt);
			v_item_peril_table.f_prem_amt	:= Gixx_Itmperil_Pkg.get_premium_amt(p_extract_id, i.item_no, i.prem_amt);
			
			v_item_peril_table.f_item_prem_amt := Gixx_Itmperil_Pkg.get_item_premium_amt(p_extract_id, i.item_no, i.prem_amt);
			
			v_item_peril_table.f_item_short_name := Giis_Currency_Pkg.get_item_short_name(p_extract_id);
			v_item_peril_table.f_item_peril_short_name := Giis_Currency_Pkg.get_item_short_name2(p_extract_id, i.item_no);	
			PIPE ROW(v_item_peril_table);
		END LOOP;
		RETURN;
	END get_pol_doc_item_peril;   
   
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 04.14.2010
	**  Reference By 	: (POLICY DOCUMENTS)
	**  Description 	: This function is used for retrieving item_tsi_amt
	*/
	FUNCTION GET_ITEM_TSI_AMT (
		p_extract_id IN GIXX_ITMPERIL.extract_id%TYPE,
		p_item_no	 IN GIXX_ITMPERIL.item_no%TYPE) RETURN VARCHAR
	IS		
		v_tsi_amt   NUMBER;
	BEGIN
		FOR A IN (
			SELECT SUM(NVL(ITMPERIL.TSI_AMT,0)) ITMPERIL_TSI_AMT
			  FROM GIXX_ITMPERIL ITMPERIL, 
				   GIIS_PERIL PERIL,
				   GIXX_POLBASIC POL
			 WHERE ITMPERIL.PERIL_CD = PERIL.PERIL_CD
			   AND ITMPERIL.LINE_CD = PERIL.LINE_CD
			   AND ITMPERIL.EXTRACT_ID = POL.EXTRACT_ID
			   AND peril.peril_type = 'B'
			   AND ITMPERIL.EXTRACT_ID = p_extract_id
			   AND pol.co_insurance_sw IN ('1','3')
			   AND itmperil.item_no = NVL(p_item_no,1))
		LOOP
			v_tsi_amt := a.itmperil_tsi_amt;
		END LOOP;  
				 
		FOR B IN (
			SELECT SUM(NVL( ITMPERIL.TSI_AMT,0 )) ITMPERIL_TSI_AMT
			  FROM GIXX_ORIG_ITMPERIL ITMPERIL, 
				   GIIS_PERIL PERIL,
				   GIXX_POLBASIC POL
			 WHERE ITMPERIL.PERIL_CD = PERIL.PERIL_CD
			   AND ITMPERIL.LINE_CD = PERIL.LINE_CD
			   AND peril.peril_type = 'B'
			   AND ITMPERIL.EXTRACT_ID = p_extract_id  
			   AND ITMPERIL.EXTRACT_ID = POL.EXTRACT_ID
			   AND POL.CO_INSURANCE_SW = '2'
			   AND itmperil.item_no = NVL(p_item_no,1))
		LOOP            
			IF b.itmperil_tsi_amt IS NOT NULL THEN
			   v_tsi_amt := b.itmperil_tsi_amt;
			END IF;   
		END LOOP;  
	  
		RETURN(TO_CHAR(v_tsi_amt,'999,999,999,999,990.99'));
		
	END GET_ITEM_TSI_AMT;
	
  /* Function retrieves summation of tsi amounts per extract id and item number
   * Created by: Bryan Joseph Abuluyan
   * Created on: April 16, 2010
   */
  FUNCTION get_mn_tsi_amt_total(p_extract_id      GIXX_ITMPERIL.extract_id%TYPE,
   							    p_item_no		  GIXX_ITMPERIL.item_no%TYPE)
	RETURN NUMBER IS
	v_total		  				GIXX_ITMPERIL.tsi_amt%TYPE := 0.00;
	v_currency_rt				GIXX_ITEM.currency_rt%TYPE;
	v_policy_currency 			GIXX_INVOICE.policy_currency%TYPE;
  BEGIN
    FOR i IN (SELECT PERIL_TYPE ITEM_PERIL_TYPE,
		  	 		 NVL( ITMPERIL.TSI_AMT,0) ITMPERIL_TSI_AMT 
  				FROM GIXX_ITMPERIL ITMPERIL 
	 			   , GIIS_PERIL PERIL
     			   , GIXX_POLBASIC POL
 			   WHERE ITMPERIL.PERIL_CD		= PERIL.PERIL_CD
   			     AND ITMPERIL.LINE_CD		= PERIL.LINE_CD
   				 AND ITMPERIL.EXTRACT_ID 	= p_extract_id
   				 AND ITMPERIL.ITEM_NO 		= p_item_no
   				 AND ITMPERIL.EXTRACT_ID 	= POL.EXTRACT_ID
			   ORDER BY SEQUENCE
	  )
	LOOP
      IF i.ITEM_PERIL_TYPE = 'B' THEN
  	    FOR A IN (SELECT a.currency_rt,NVL(a.policy_currency,'N') policy_currency
	                FROM GIXX_ITEM b,
	                     GIXX_INVOICE a
	               WHERE a.extract_id = b.extract_id
	                 AND a.extract_id = p_extract_id
	                 AND b.item_no    = p_item_no )
        LOOP
  	      v_currency_rt := A.currency_rt;
  	      v_policy_currency := a.policy_currency;
        END LOOP;  
  	    IF NVL(v_policy_currency,'N') = 'Y' THEN
	  	  v_total := v_total + NVL(i.ITMPERIL_TSI_AMT , 0);
  	    ELSE
		  v_total := v_total + NVL((i.ITMPERIL_TSI_AMT  * NVL(v_currency_rt,1)), 0);
  	    END IF;  
      END IF;
	END LOOP;
	RETURN v_total;
  END get_mn_tsi_amt_total;
  
  FUNCTION get_mn_prem_amt_total(p_extract_id      GIXX_ITMPERIL.extract_id%TYPE,
   							     p_item_no		  GIXX_ITMPERIL.item_no%TYPE)
	RETURN NUMBER IS
	v_total		  				GIXX_ITMPERIL.tsi_amt%TYPE := 0.00;
	v_currency_rt				GIXX_ITEM.currency_rt%TYPE;
	v_policy_currency 			GIXX_INVOICE.policy_currency%TYPE;
  BEGIN
    FOR i IN (SELECT NVL( ITMPERIL.PREM_AMT,0) ITMPERIL_PREM_AMT 
  				FROM GIXX_ITMPERIL ITMPERIL 
	 			   , GIIS_PERIL PERIL
     			   , GIXX_POLBASIC POL
 			   WHERE ITMPERIL.PERIL_CD		= PERIL.PERIL_CD
   			     AND ITMPERIL.LINE_CD		= PERIL.LINE_CD
   				 AND ITMPERIL.EXTRACT_ID 	= p_extract_id
   				 AND ITMPERIL.ITEM_NO 		= p_item_no
   				 AND ITMPERIL.EXTRACT_ID 	= POL.EXTRACT_ID
			   ORDER BY SEQUENCE
	  )
	LOOP
      FOR A IN (SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
	              FROM GIXX_ITEM b,
	                   GIXX_INVOICE a
	             WHERE a.extract_id = b.extract_id
	               AND a.extract_id = p_extract_id
	               AND b.item_no    = p_item_no )
      LOOP
  	    v_currency_rt := A.currency_rt;
  	    V_policy_currency := a.policy_currency; 
      END LOOP;  
      IF NVL(v_policy_currency,'N') = 'Y' THEN
	    v_total := v_total + NVL(i.ITMPERIL_PREM_AMT , 0);
      ELSE
	    v_total := v_total + NVL((i.ITMPERIL_PREM_AMT  * NVL(v_currency_rt,1)), 0);
      END IF; 
	END LOOP;
	RETURN v_total;
  END get_mn_prem_amt_total;

	/* peril_name */
	FUNCTION get_peril_name (
		p_report_id		IN GIIS_DOCUMENT.report_id%TYPE,
		p_peril_lname 	IN GIIS_PERIL.peril_lname%TYPE,
		p_peril_sname 	IN GIIS_PERIL.peril_sname%TYPE,
		p_peril_name  	IN GIIS_PERIL.peril_name%TYPE)
	RETURN VARCHAR2
	IS
		v_text 			GIIS_DOCUMENT.text%TYPE;
		v_peril_name	VARCHAR2(500);
	BEGIN
		FOR a IN (
			SELECT text 
			  FROM GIIS_DOCUMENT
			 WHERE title = 'PRINT_PERIL_LONG_NAME'
			   AND report_id = p_report_id)
		LOOP
			v_text := a.text;
		END LOOP;
		
		IF v_text = 'Y' THEN
			v_peril_name := p_peril_lname;
		ELSE
			FOR a IN (
				SELECT text 
				  FROM GIIS_DOCUMENT
				 WHERE title = 'PRINT_SNAME'
				   AND report_id = p_report_id)
			LOOP
				v_text := a.text;
			END LOOP;
			
			IF v_text = 'Y' THEN
				v_peril_name := p_peril_sname;
			ELSE
				v_peril_name := p_peril_name;
			END IF;
		END IF;
		
		RETURN (v_peril_name);
	END;
	
	/* f_tsi_amt */
	FUNCTION get_tsi_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_tsi_amt		IN GIXX_ITMPERIL.tsi_amt%TYPE) 
	RETURN NUMBER
	IS
		v_currency_rt		GIPI_ITEM.currency_rt%TYPE;
		v_policy_currency	GIXX_INVOICE.policy_currency%TYPE;
	BEGIN
		FOR A IN (  	  
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM b,
				   GIXX_INVOICE a,
				   GIXX_POLBASIC c 
			 WHERE a.extract_id = b.extract_id
			   AND a.extract_id = c.extract_id
			   AND c.co_insurance_sw IN ('1','3')
			   AND a.extract_id = p_extract_id
			   AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp --added by steven 1.23.2013; for multiple items and different currency
			 UNION
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM b,
				   GIXX_ORIG_INVOICE a,
				   GIXX_POLBASIC c 
			 WHERE a.extract_id = b.extract_id
			   AND a.extract_id = c.extract_id
			   AND c.co_insurance_sw = '2'
			   AND a.extract_id = p_extract_id
			   AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp)--added by steven 1.23.2013; for multiple items and different currency
		LOOP
			v_currency_rt := A.currency_rt;
			v_policy_currency := A.policy_currency; 
		END LOOP;  
  
		IF NVL(v_policy_currency,'N') = 'Y' THEN
			RETURN(NVL(p_tsi_amt , 0));
		ELSE
			RETURN(NVL((p_tsi_amt * NVL(v_currency_rt,1)), 0));
		END IF;  
	END get_tsi_amt;
	
	/* f_prem_amt */
	FUNCTION get_premium_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_prem_amt		IN GIXX_ITMPERIL.prem_amt%TYPE) 
	RETURN NUMBER
	IS
		v_currency_rt		GIPI_ITEM.currency_rt%TYPE;
		v_policy_currency   GIXX_INVOICE.policy_currency%TYPE;		
	BEGIN
		FOR A IN (  	  
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM b,
				   GIXX_INVOICE a,
				   GIXX_POLBASIC c
			 WHERE a.extract_id = b.extract_id
			   AND a.extract_id = c.extract_id
			   AND c.co_insurance_sw IN ('1','3')
			   AND a.extract_id = p_extract_id
			   AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp --added by steven 1.23.2013; for multiple items and different currency
			 UNION
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM b,
				   GIXX_ORIG_INVOICE a,
				   GIXX_POLBASIC c
			 WHERE a.extract_id = b.extract_id
			   AND a.extract_id = c.extract_id
			   AND c.co_insurance_sw = '2'
			   AND a.extract_id = p_extract_id
			   AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp) --added by steven 1.23.2013; for multiple items and different currency
		LOOP
			v_currency_rt := A.currency_rt;
			v_policy_currency := A.policy_currency; 
		END LOOP;  
  
		IF NVL(v_policy_currency,'N') = 'Y' THEN
			RETURN(NVL(p_prem_amt , 0));
		ELSE
			RETURN(NVL((p_prem_amt * NVL(v_currency_rt,1)), 0));
		END IF;  
	END get_premium_amt;
	
	/* f_item_prem_amt */
	FUNCTION get_item_premium_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_prem_amt		IN GIXX_ITMPERIL.prem_amt%TYPE) 
	RETURN NUMBER
	IS
		v_currency_rt		GIPI_ITEM.currency_rt%TYPE;
		v_policy_currency   GIXX_INVOICE.policy_currency%TYPE;
		v_prem_amt			GIXX_ITMPERIL.prem_amt%TYPE;
	BEGIN
		FOR A IN (  	  
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM b,
				   GIXX_INVOICE a,
				   GIXX_POLBASIC c
			 WHERE a.extract_id = b.extract_id
			   AND a.extract_id = c.extract_id
			   AND c.co_insurance_sw IN ('1','3')
			   AND a.extract_id = p_extract_id
			   AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp --added by steven 1.23.2013; for multiple items and different currency
			 UNION
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM b,
				   GIXX_ORIG_INVOICE a,
				   GIXX_POLBASIC c
			 WHERE a.extract_id = b.extract_id
			   AND a.extract_id = c.extract_id
			   AND c.co_insurance_sw = '2'
			   AND a.extract_id = p_extract_id
			   AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp) --added by steven 1.23.2013; for multiple items and different currency
		LOOP
			v_currency_rt := A.currency_rt;
			v_policy_currency := A.policy_currency; 
		END LOOP;  
  
		IF NVL(v_policy_currency,'N') = 'Y' THEN			
			v_prem_amt := p_prem_amt;					
		ELSE			
			v_prem_amt := p_prem_amt * NVL(v_currency_rt, 1);					
		END IF;
		
		RETURN(v_prem_amt);
	END get_item_premium_amt;
    
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  February 26, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves related item peril info for GIPIS101 
    */
    FUNCTION get_itmperil (
        p_extract_id        gixx_itmperil.extract_id%TYPE,
        p_item_no           gixx_itmperil.item_no%TYPE,
        p_pack_pol_flag     gixx_polbasic.pack_pol_flag%TYPE,  -- x010.pack_pol_flag
        p_pack_line_cd      gixx_item.pack_line_cd%TYPE,       -- gixx_item.pack_line_cd
        p_line_cd           giis_line.line_cd%TYPE             -- X010.line_cd
    ) RETURN item_peril_tab PIPELINED
    IS
        v_peril             item_peril_type;
        v_line_cd           giis_line.line_cd%TYPE;
    BEGIN
        FOR rec IN (SELECT extract_id, policy_id,
                           item_no, peril_cd, line_cd, tarf_cd,
                           tsi_amt, prem_amt, prem_rt, comp_rem,
                           ri_comm_rate, ri_comm_amt, rec_flag
                      FROM gixx_itmperil
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            v_peril.extract_id := rec.extract_id;
            v_peril.policy_id := rec.policy_id;
            v_peril.item_no := rec.item_no;
            v_peril.peril_cd := rec.peril_cd;
            v_peril.line_cd := rec.line_cd;
            v_peril.tarf_cd := rec.tarf_cd;
            v_peril.tsi_amt := rec.tsi_amt;
            v_peril.prem_amt := rec.prem_amt;
            v_peril.prem_rt := rec.prem_rt;
            v_peril.comp_rem := rec.comp_rem;
            v_peril.ri_comm_rate := rec.ri_comm_rate;
            v_peril.ri_comm_amt := rec.ri_comm_amt;
            v_peril.rec_flag := rec.rec_flag;
            
            IF p_pack_pol_flag = 'Y' THEN
                v_line_cd := p_pack_line_cd;
            ELSE 
                v_line_cd := p_line_cd;
            END IF;
            
            FOR a IN (SELECT peril_name
                        FROM giis_peril
                       WHERE line_cd = v_line_cd --rec.line_cd
                         AND peril_cd = rec.peril_cd)
            LOOP
                v_peril.peril_name := a.peril_name;
            END LOOP;
            
            PIPE ROW(v_peril);
        END LOOP;
    END get_itmperil;
  
END Gixx_Itmperil_Pkg;
/


