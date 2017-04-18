CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Mortgagee_Pkg AS         
   
   FUNCTION get_pol_doc_mortgagee 
     RETURN pol_doc_mortgagee_tab PIPELINED IS
   
     v_mortgagee pol_doc_mortgagee_type;
   
   BEGIN
     FOR i IN (          
        SELECT NULL norec, 
               a.extract_id extract_id4, 
               a.iss_cd     mortgagee_iss_cd,
               b.mortg_name mortgagee_name, 
               a.item_no    mortgagee_item_no,
               a.amount     mortgagee_amount
          FROM GIXX_MORTGAGEE a, 
               GIIS_MORTGAGEE b, 
               GIXX_POLBASIC c
         WHERE a.extract_id = c.extract_id
           AND a.iss_cd     = b.iss_cd
           AND a.mortg_cd   = b.mortg_cd
        UNION
        SELECT 'NONE' norec, 
               NULL extract_id4, 
               NULL mortgagee_iss_cd, 
               NULL mortgagee_name,
               NULL mortgagee_item_no, 
               NULL mortgagee_amount
          FROM DUAL)
     LOOP
        v_mortgagee.extract_id4         := i.extract_id4; 
        v_mortgagee.mortgagee_iss_cd    := i.mortgagee_iss_cd;
        v_mortgagee.mortgagee_name      := i.mortgagee_name;
        v_mortgagee.mortgagee_item_no   := i.mortgagee_item_no;
        v_mortgagee.mortgagee_amount    := i.mortgagee_amount;
       PIPE ROW(v_mortgagee);
     END LOOP;
     RETURN;
   END get_pol_doc_mortgagee;
   
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 04.21.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This function returns record of a particular extract_id
	*/
	FUNCTION get_pol_doc_mort (p_extract_id IN GIXX_MORTGAGEE.extract_id%TYPE,
		p_report_id IN GIIS_DOCUMENT.report_id%TYPE,
		p_print_mort_amt IN GIIS_DOCUMENT.text%TYPE)
	RETURN pol_doc_mort_tab PIPELINED
	IS
		v_mortgagee pol_doc_mortgagee_type2;
	BEGIN
		FOR i IN (
			SELECT A.EXTRACT_ID,
				   A.ISS_CD MORTGAGEE_ISS_CD,
				   B.MORTG_NAME MORTGAGEE_NAME ,
				   A.ITEM_NO MORTGAGEE_ITEM_NO, 
				   A.AMOUNT MORTGAGEE_AMOUNT
			  FROM GIXX_MORTGAGEE A,
				   GIIS_MORTGAGEE B,
				   GIXX_POLBASIC C
			 WHERE A.EXTRACT_ID = C.EXTRACT_ID
			   AND A.ISS_CD = B.ISS_CD
			   AND A.MORTG_CD = B.MORTG_CD
			   AND A.EXTRACT_ID = p_extract_id
		  ORDER BY A.ITEM_NO DESC)
		LOOP
			v_mortgagee.extract_id         	:= i.extract_id; 
			v_mortgagee.mortgagee_iss_cd    := i.mortgagee_iss_cd;
			v_mortgagee.mortgagee_name      := i.mortgagee_name;
			v_mortgagee.mortgagee_item_no   := i.mortgagee_item_no;
			v_mortgagee.mortgagee_amount    := i.mortgagee_amount;			
			v_mortgagee.f_mortgagee_amount	:= Gixx_Mortgagee_Pkg.get_mortgagee_amount(p_extract_id, i.mortgagee_amount);
			v_mortgagee.show_mortgagee_amt	:= Gixx_Mortgagee_Pkg.pol_doc_show_mortgagee_amt(p_report_id, p_print_mort_amt, i.mortgagee_amount);
			PIPE ROW(v_mortgagee);
		END LOOP;
		RETURN;
	END get_pol_doc_mort;
	
	FUNCTION get_mortgagee_amount (
		p_extract_id 		IN GIXX_MORTGAGEE.extract_id%TYPE,
		p_mortgagee_amount 	IN GIXX_MORTGAGEE.amount%TYPE)
	RETURN NUMBER
	IS
		v_mort_amt				GIXX_MORTGAGEE.amount%TYPE;
		v_currency_rt			GIXX_ITEM.currency_rt%TYPE;
		v_policy_currency		GIXX_INVOICE.policy_currency%TYPE;
	BEGIN
		FOR A IN (
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM a, GIXX_INVOICE b
			 WHERE a.extract_id = p_extract_id
			   AND a.extract_id = b.extract_id)
		LOOP
			v_currency_rt     := A.currency_rt;
			v_policy_currency := a.policy_currency;
			EXIT;
		END LOOP;
		
		IF NVL(v_policy_currency,'N') = 'Y' THEN
			v_mort_amt := NVL(p_mortgagee_amount,0);
		ELSE  	 
			v_mort_amt := NVL(p_mortgagee_amount,0) * NVL(v_currency_rt,1);
		END IF;
  
		IF v_mort_amt = 0 THEN
			RETURN (NVL(p_mortgagee_amount,0));
		ELSE
			RETURN (v_mort_amt);
		END IF;
	END get_mortgagee_amount;
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.07.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This function checks if the mortgagee_amount will be displayed in policy documents
	*/
	FUNCTION pol_doc_show_mortgagee_amt(
		p_report_id IN GIIS_DOCUMENT.report_id%TYPE,
		p_print_mort_amt IN GIIS_DOCUMENT.text%TYPE,
		p_mort_amount IN GIXX_MORTGAGEE.amount%TYPE)
	RETURN VARCHAR2
	IS
		v_show_mort_amt VARCHAR2(1) := 'N';
	BEGIN
		IF p_report_id = 'FIRE' THEN
			IF p_print_mort_amt = 'N' OR p_mort_amount IS NULL THEN
				v_show_mort_amt := 'N';
			ELSE
				v_show_mort_amt := 'Y';
			END IF;
		ELSIF p_report_id = 'AVIATION' THEN
			IF p_print_mort_amt = 'Y' THEN
				v_show_mort_amt := 'Y';
			ELSE
				v_show_mort_amt := 'N';
			END IF;
		END IF;
		RETURN v_show_mort_amt;
	END pol_doc_show_mortgagee_amt;
    
    /*
    **  Created by		: Veronica V. Raymundo
    **  Date Created 	: 03.25.2011
    **  Reference By 	: Package Policy Documents
    **  Description 	: This function returns mortgagee record with the given extract_id.
    */

    FUNCTION get_pack_pol_doc_mort (p_extract_id IN GIXX_MORTGAGEE.extract_id%TYPE,
                                    p_report_id IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN pol_doc_mort_tab PIPELINED
        IS
            v_mortgagee pol_doc_mortgagee_type2;
        BEGIN
            FOR i IN (
                SELECT A.extract_id,
                       A.iss_cd mortgagee_iss_cd,
                       B.mortg_name mortgagee_name ,
                       A.item_no mortgagee_item_no, 
                       A.amount mortgagee_amount,
                       A.remarks mortgagee_remarks
                  FROM GIXX_MORTGAGEE A,
                       GIIS_MORTGAGEE B,
                       GIXX_PACK_POLBASIC C
                 WHERE A.extract_id = C.extract_id
                   AND A.iss_cd = B.iss_cd
                   AND A.mortg_cd = B.mortg_cd
                   AND A.item_no = 0
                   AND A.extract_id = p_extract_id
              ORDER BY A.item_no DESC)
            LOOP
                v_mortgagee.extract_id         	:= i.extract_id; 
                v_mortgagee.mortgagee_iss_cd    := i.mortgagee_iss_cd;
                v_mortgagee.mortgagee_name      := i.mortgagee_name;
                v_mortgagee.mortgagee_item_no   := i.mortgagee_item_no;
                v_mortgagee.mortgagee_amount    := i.mortgagee_amount;
                v_mortgagee.mortgagee_remarks   := i.mortgagee_remarks;			
                v_mortgagee.f_mortgagee_amount	:= Gixx_Mortgagee_Pkg.get_pack_mortgagee_amount(p_extract_id, i.mortgagee_amount);
                PIPE ROW(v_mortgagee);
            END LOOP;
            RETURN;
    END get_pack_pol_doc_mort;
    
    /*
	**  Created by		: Veronica V. Raymundo
	**  Date Created 	: 03.25.2011
	**  Reference By 	: Package Policy Documents
	**  Description 	: This function returns mortgagee amount with the given extract_id.
	*/
	FUNCTION get_pack_mortgagee_amount (
		p_extract_id 		IN GIXX_MORTGAGEE.extract_id%TYPE,
		p_mortgagee_amount 	IN GIXX_MORTGAGEE.amount%TYPE)
	RETURN NUMBER
	IS
		v_mort_amt				GIXX_MORTGAGEE.amount%TYPE;
		v_currency_rt			GIXX_ITEM.currency_rt%TYPE;
		v_policy_currency		GIXX_PACK_INVOICE.policy_currency%TYPE;
	BEGIN
		FOR A IN (
			SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
			  FROM GIXX_ITEM a, GIXX_PACK_INVOICE b
			 WHERE a.extract_id = p_extract_id
			   AND a.extract_id = b.extract_id)
		LOOP
			v_currency_rt     := A.currency_rt;
			v_policy_currency := a.policy_currency;
			EXIT;
		END LOOP;
		
		IF NVL(v_policy_currency,'N') = 'Y' THEN
			v_mort_amt := NVL(p_mortgagee_amount,0);
		ELSE  	 
			v_mort_amt := NVL(p_mortgagee_amount,0) * NVL(v_currency_rt,1);
		END IF;
  
		IF v_mort_amt = 0 THEN
			RETURN (NVL(p_mortgagee_amount,0));
		ELSE
			RETURN (v_mort_amt);
		END IF;
	END get_pack_mortgagee_amount;
	
	
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  February 20, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves Mortgagee List
  */
  FUNCTION get_mortgagee_list(
        p_extract_id    gixx_mortgagee.extract_id%TYPE
    ) RETURN mortg_list_tab PIPELINED
    IS
        v_mortgagee     mortg_list_type;
    BEGIN
        FOR gixx IN (SELECT extract_id, iss_cd, item_no,
                            mortg_cd, amount, remarks,
                            delete_sw, policy_id
                       FROM gixx_mortgagee
                      WHERE extract_id = p_extract_id)
        LOOP
            FOR mort IN (SELECT mortg_name
                           FROM giis_mortgagee
                          WHERE mortg_cd = gixx.mortg_cd
                            AND iss_cd = gixx.iss_cd)
            LOOP
                v_mortgagee.mortg_name := mort.mortg_name;                
            END LOOP;
            
            
            FOR c IN (SELECT SUM(amount) amt
                        FROM gixx_mortgagee
                       WHERE extract_id = p_extract_id
                       GROUP BY extract_id)
            LOOP
                v_mortgagee.total_amount := nvl(c.amt,0);
            END LOOP;
            
            v_mortgagee.mortg_cd := gixx.mortg_cd;
            v_mortgagee.iss_cd := gixx.iss_cd;
            v_mortgagee.item_no := gixx.item_no;
            v_mortgagee.extract_id  := gixx.extract_id;
            v_mortgagee.amount := nvl(gixx.amount,0);
            v_mortgagee.remarks := gixx.remarks;
            v_mortgagee.delete_sw := NVL(gixx.delete_sw, 'N');
            v_mortgagee.policy_id := gixx.policy_id;     
            
            PIPE ROW(v_mortgagee); 
            
        END LOOP;
        
    END get_mortgagee_list;
    
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 6, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves Mortgagee Information for an item
  */
  FUNCTION get_item_mortgagee_info(
        p_extract_id    gixx_mortgagee.extract_id%TYPE,
        p_item_no       gixx_mortgagee.item_no%TYPE
    ) RETURN mortg_list_tab PIPELINED
    IS
        v_mortgagee mortg_list_type;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, mortg_cd, iss_cd,
                           amount, remarks
                      FROM gixx_mortgagee
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            IF (rec.iss_cd IS NULL) AND (rec.mortg_cd IS NULL) THEN 
                v_mortgagee.dsp_item_no := NULL;
            ELSE
                v_mortgagee.dsp_item_no := rec.item_no;
            END IF;
            
            FOR a IN (SELECT mortg_name
                        FROM giis_mortgagee
                       WHERE mortg_cd = rec.mortg_cd
                         AND iss_cd = rec.mortg_cd)
            LOOP
                v_mortgagee.mortg_name := a.mortg_name;
            END LOOP;
            
            FOR b IN (SELECT SUM(amount) amt
                        FROM gixx_mortgagee
                       WHERE extract_id = p_extract_id
                         AND item_no = p_item_no
                       GROUP BY extract_id, item_no)
            LOOP
                v_mortgagee.total_amount := b.amt;
            END LOOP;
            
            v_mortgagee.extract_id := rec.extract_id;
            v_mortgagee.item_no := rec.item_no;
            v_mortgagee.mortg_cd := rec.mortg_cd;
            v_mortgagee.iss_cd := rec.iss_cd;
            v_mortgagee.amount := rec.amount;
            v_mortgagee.remarks := rec.remarks;
            
            PIPE ROW(v_mortgagee);
        END LOOP;
    
    END get_item_mortgagee_info;
	
END Gixx_Mortgagee_Pkg;
/


