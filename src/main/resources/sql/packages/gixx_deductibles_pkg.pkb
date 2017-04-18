CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Deductibles_Pkg AS

   FUNCTION get_pol_doc_deductible(p_extract_id IN GIXX_DEDUCTIBLES.extract_id%TYPE,
                                   p_item_no    IN GIXX_DEDUCTIBLES.item_no%TYPE)
     RETURN pol_doc_deductible_tab PIPELINED IS
     
     v_deductibles pol_doc_deductible_type;
     
   BEGIN
     FOR i IN (
       SELECT ALL deductibles.extract_id   extract_id,
              deductibles.item_no          deductibles_item_no,
              deduct_desc.deductible_title deductdesc_deductible_title, 
              DECODE(deductibles.deductible_text, NULL, deduct_desc.deductible_text, 
                                                        deductibles.deductible_text) deductibles_deductible_text, 
              DECODE(deductibles.deductible_amt, NULL, deduct_desc.deductible_amt, 
                                                       deductibles.deductible_amt) deductibles_deductible_amt, 
              deductibles.ded_line_cd         deductibles_ded_line_cd, 
              deductibles.ded_subline_cd       deductibles_ded_subline_cd,  
              deductibles.ded_deductible_cd deductibles_ded_deductible_cd, 
              DECODE(deductibles.deductible_rt, NULL, deduct_desc.deductible_rt, 
                                                      deductibles.deductible_rt) deductibles_deductible_rt, 
              peril.peril_sname             deductibles_peril_sname,
              DECODE(deductibles.deductible_amt, NULL, deduct_desc.deductible_amt, 
                                                       deductibles.deductible_amt) deductible_amount,
			  deduct_desc.ded_type deductdesc_ded_type
         FROM GIXX_DEDUCTIBLES     DEDUCTIBLES, 
              GIIS_DEDUCTIBLE_DESC DEDUCT_DESC,
              GIIS_PERIL           PERIL
        WHERE deductibles.extract_id         = p_extract_id
          AND deductibles.item_no            = p_item_no
          AND deductibles.ded_deductible_cd  = deduct_desc.deductible_cd (+)
          AND deductibles.ded_subline_cd     = deduct_desc.subline_cd (+)
          AND deductibles.ded_line_cd        = deduct_desc.line_cd (+)
          AND deductibles.ded_line_cd        = peril.line_cd (+)
          AND deductibles.peril_cd           = peril.peril_cd (+))
     LOOP
        v_deductibles.extract_id                      := i.extract_id;
        v_deductibles.deductibles_item_no             := i.deductibles_item_no;
        v_deductibles.deductdesc_deductible_title     := i.deductdesc_deductible_title;
        v_deductibles.deductibles_deductible_text     := i.deductibles_deductible_text;
        v_deductibles.deductibles_deductible_amt      := i.deductibles_deductible_amt;
        v_deductibles.deductibles_ded_line_cd         := i.deductibles_ded_line_cd;
        v_deductibles.deductibles_ded_subline_cd      := i.deductibles_ded_subline_cd;
        v_deductibles.deductibles_ded_deductible_cd   := i.deductibles_ded_deductible_cd;
        v_deductibles.deductibles_deductible_rt       := i.deductibles_deductible_rt;
        v_deductibles.deductibles_peril_sname         := i.deductibles_peril_sname;
        v_deductibles.deductible_amount               := i.deductible_amount;
        v_deductibles.f_deductible_amount             := Gixx_Deductibles_Pkg.get_deductible_amount(p_extract_id, p_item_no, i.deductible_amount);
		v_deductibles.deductdesc_ded_type             := i.deductdesc_ded_type; --marco - 11.22.2012
       PIPE ROW(v_deductibles);
     END LOOP;
     RETURN;
   END get_pol_doc_deductible;


   FUNCTION get_pol_doc_policy_deductible 
     RETURN pol_doc_policy_deductible_tab PIPELINED IS
     
     v_deductible pol_doc_policy_deductible_type;
     
   BEGIN
     FOR i IN (  
        SELECT ALL deductibles.extract_id       extract_id21,
                   deductibles.item_no          deduct_item_no,
                   deductibles.peril_cd         deduct_peril_cd,
                   deduct_desc.deductible_title deductdesc_deduct_title,
                   DECODE (deductibles.deductible_text,
                           NULL, deduct_desc.deductible_text,
                           deductibles.deductible_text
                          ) deductibles_deduct_text,
                   DECODE (deductibles.deductible_amt,
                           NULL, deduct_desc.deductible_amt,
                           deductibles.deductible_amt
                          ) deductibles_deduct_amt,
                   deductibles.ded_line_cd      deduct_ded_line_cd,
                   deductibles.ded_subline_cd   deduct_ded_subline_cd,
                   deductibles.ded_deductible_cd deduct_ded_deductible_cd,
                   TO_CHAR (DECODE (deductibles.deductible_rt,
                                    NULL, NULL,
                                    deductibles.deductible_rt
                                   ),
                            '99.999'
                           ) deduct_deductible_rt,
                   peril.peril_sname deduct_peril_sname,
                   TO_NUMBER (DECODE (deductibles.deductible_amt,
                                      NULL, NULL,
                                      deductibles.deductible_amt
                                     )
                             ) deduct_amount
              FROM GIXX_DEDUCTIBLES deductibles,
                   GIIS_DEDUCTIBLE_DESC deduct_desc,
                   GIIS_PERIL peril
             WHERE deductibles.ded_deductible_cd = deduct_desc.deductible_cd(+)
               AND deductibles.ded_subline_cd    = deduct_desc.subline_cd(+)
               AND deductibles.ded_line_cd       = deduct_desc.line_cd(+)
               AND deductibles.ded_line_cd       = peril.line_cd(+)
               AND deductibles.peril_cd          = peril.peril_cd(+)
               AND deductibles.item_no           = 0
               AND (deductibles.peril_cd = 0 OR deductibles.peril_cd IS NULL))
     LOOP
        v_deductible.extract_id21             := i.extract_id21;
        v_deductible.deduct_item_no           := i.deduct_item_no;
        v_deductible.deduct_peril_cd          := i.deduct_peril_cd;    
        v_deductible.deductdesc_deduct_title  := i.deductdesc_deduct_title;
        v_deductible.deductibles_deduct_text  := i.deductibles_deduct_text;
        v_deductible.deductibles_deduct_amt   := i.deductibles_deduct_amt;
        v_deductible.deduct_ded_line_cd       := i.deduct_ded_line_cd;
        v_deductible.deduct_ded_subline_cd    := i.deduct_ded_subline_cd;
        v_deductible.deduct_ded_deductible_cd := i.deduct_ded_deductible_cd;
        v_deductible.deduct_deductible_rt     := i.deduct_deductible_rt;
        v_deductible.deduct_peril_sname       := i.deduct_peril_sname;
        v_deductible.deduct_amount            := i.deduct_amount;
       PIPE ROW(v_deductible);
     END LOOP;
     RETURN;          
   END get_pol_doc_policy_deductible;  
   
   /* Function retrieves summation of deductible amounts per extract id and item number
    * Created by: Bryan Joseph Abuluyan
	* Created on: April 16, 2010
	*/
   FUNCTION get_ded_amt_total(p_extract_id    GIXX_DEDUCTIBLES.extract_id%TYPE,
   							  p_item_no		  GIXX_DEDUCTIBLES.item_no%TYPE)
	 RETURN NUMBER IS
	 v_total	   GIXX_DEDUCTIBLES.deductible_amt%TYPE;
   BEGIN
     FOR i IN (SELECT SUM(DECODE(a.deductible_amt, NULL, b.deductible_amt, a.deductible_amt)) deductibles_deductible_amt
				 FROM GIXX_DEDUCTIBLES a
				    , GIIS_DEDUCTIBLE_DESC b
				WHERE a.extract_id       = p_extract_id
				  AND a.item_no 		 = p_item_no
				  AND b.deductible_cd(+) = a.ded_deductible_cd
				  AND b.subline_cd(+) 	 = a.ded_subline_cd
				  AND b.line_cd(+) 	  	 = a.ded_line_cd)
	 LOOP
	 	 v_total  	  := i.deductibles_deductible_amt;
	 END LOOP;
	 RETURN (v_total);
   END get_ded_amt_total;
   
   FUNCTION is_exist(p_extract_id    GIXX_DEDUCTIBLES.extract_id%TYPE,
   					 p_item_no		 GIXX_DEDUCTIBLES.item_no%TYPE)
	 RETURN VARCHAR2 IS
	 v_ded_text	VARCHAR2(5000):=NULL;
   BEGIN
	  FOR count_rec IN (SELECT deductible_text
      	 		   	  	  FROM GIXX_DEDUCTIBLES
     					 WHERE extract_id = p_extract_id
       					   AND item_no    = p_item_no) 
      LOOP
         v_ded_text := count_rec.deductible_text;
         EXIT;
      END LOOP;
     
	  IF v_ded_text IS NULL THEN
  	     RETURN('N');
      ELSE
         RETURN('Y');
      END IF;
   END is_exist;
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 04.22.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This function returns the deductible_amount of a record based on its extract_id and item_no
	*/
	FUNCTION get_deductible_amount (
		p_extract_id		IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no			IN GIXX_ITEM.item_no%TYPE,
		p_deductible_amt	IN GIXX_DEDUCTIBLES.deductible_amt%TYPE)
	RETURN NUMBER
	IS
		v_currency_rt		GIPI_ITEM.currency_rt%TYPE;
		v_policy_currency   GIPI_INVOICE.policy_currency%TYPE;
	BEGIN
		FOR A IN (
			SELECT b.currency_rt,NVL(a.policy_currency,'N') policy_currency
				FROM GIXX_ITEM b, GIXX_INVOICE a
			   WHERE b.extract_id = p_extract_id
				 AND a.extract_id = b.extract_id
				 AND b.item_no      = p_item_no)
		LOOP
			v_currency_rt := A.currency_rt;
			v_policy_currency := A.policy_currency;
		END LOOP;  
		
		IF NVL(v_policy_currency,'N') = 'Y' THEN
			RETURN(NVL(p_deductible_amt , 0));
		ELSE
			RETURN(NVL((p_deductible_amt  * NVL(v_currency_rt,1)), 0));
		END IF;
	END get_deductible_amount;
    
   FUNCTION get_pack_pol_doc_deductible(p_extract_id  IN GIXX_DEDUCTIBLES.extract_id%TYPE,
                                        p_item_no     IN GIXX_DEDUCTIBLES.item_no%TYPE,
                                        p_policy_id   IN GIXX_DEDUCTIBLES.policy_id%TYPE)
     RETURN pol_doc_deductible_tab PIPELINED IS
     
     v_deductibles pol_doc_deductible_type;
     
   BEGIN
     FOR i IN (
       SELECT ALL deductibles.extract_id   extract_id,
              deductibles.policy_id        deductibles_policy_id,
              deductibles.item_no          deductibles_item_no,
              deduct_desc.deductible_title deductdesc_deductible_title, 
              DECODE(deductibles.deductible_text, NULL, deduct_desc.deductible_text, 
                                                        deductibles.deductible_text) deductibles_deductible_text, 
              DECODE(deductibles.deductible_amt, NULL, deduct_desc.deductible_amt, 
                                                       deductibles.deductible_amt) deductibles_deductible_amt, 
              deductibles.ded_line_cd         deductibles_ded_line_cd, 
              deductibles.ded_subline_cd       deductibles_ded_subline_cd,  
              deductibles.ded_deductible_cd deductibles_ded_deductible_cd, 
              DECODE(deductibles.deductible_rt, NULL, deduct_desc.deductible_rt, 
                                                      deductibles.deductible_rt) deductibles_deductible_rt, 
              peril.peril_sname             deductibles_peril_sname,
              DECODE(deductibles.deductible_amt, NULL, deduct_desc.deductible_amt, 
                                                       deductibles.deductible_amt) deductible_amount,
              deduct_desc.ded_type -- marco - 02.08.2013 - ucpb specific enhancement                 
         FROM GIXX_DEDUCTIBLES     DEDUCTIBLES, 
              GIIS_DEDUCTIBLE_DESC DEDUCT_DESC,
              GIIS_PERIL           PERIL
        WHERE deductibles.extract_id         = p_extract_id
          AND deductibles.item_no            = p_item_no
          AND deductibles.policy_id          = p_policy_id
          AND deductibles.ded_deductible_cd  = deduct_desc.deductible_cd (+)
          AND deductibles.ded_subline_cd     = deduct_desc.subline_cd (+)
          AND deductibles.ded_line_cd        = deduct_desc.line_cd (+)
          AND deductibles.ded_line_cd        = peril.line_cd (+)
          AND deductibles.peril_cd           = peril.peril_cd (+))
     LOOP
        v_deductibles.extract_id                      := i.extract_id;
        v_deductibles.deductibles_item_no             := i.deductibles_item_no;
        v_deductibles.deductdesc_deductible_title     := i.deductdesc_deductible_title;
        v_deductibles.deductibles_deductible_text     := i.deductibles_deductible_text;
        v_deductibles.deductibles_deductible_amt      := i.deductibles_deductible_amt;
        v_deductibles.deductibles_ded_line_cd         := i.deductibles_ded_line_cd;
        v_deductibles.deductibles_ded_subline_cd      := i.deductibles_ded_subline_cd;
        v_deductibles.deductibles_ded_deductible_cd   := i.deductibles_ded_deductible_cd;
        v_deductibles.deductibles_deductible_rt       := i.deductibles_deductible_rt;
        v_deductibles.deductibles_peril_sname         := i.deductibles_peril_sname;
        v_deductibles.deductible_amount               := i.deductible_amount;
        v_deductibles.f_deductible_amount             := Gixx_Deductibles_Pkg.get_deductible_amount(p_extract_id, p_item_no, i.deductible_amount);
        v_deductibles.deductdesc_ded_type             := i.ded_type; -- marco - 02.08.2013 - ucpb specific enhancement
       PIPE ROW(v_deductibles);
     END LOOP;
     RETURN;
   END get_pack_pol_doc_deductible;
   
   
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  February 27, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves item deductibles  
  */
   FUNCTION get_item_deductibles (
      p_extract_id  gixx_deductibles.extract_id%TYPE,
      p_item_no     gixx_deductibles.item_no%TYPE
   )
   RETURN item_deductible_tab PIPELINED
   IS
        v_deductible    item_deductible_type;
   BEGIN
        FOR rec IN (SELECT extract_id, item_no, ded_deductible_cd, 
                           ded_line_cd, ded_subline_cd,
                           deductible_rt, deductible_text, 
                           deductible_amt
                      FROM gixx_deductibles
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no
                     ORDER BY ded_deductible_cd)
        LOOP
            FOR a IN (SELECT deductible_title
                        FROM giis_deductible_desc
                       WHERE line_cd       = rec.ded_line_cd
                         AND subline_cd    = rec.ded_subline_cd
                         AND deductible_cd = rec.ded_deductible_cd)
            LOOP
                v_deductible.deductible_name := a.deductible_title;
            END LOOP;
            
            FOR b IN (SELECT SUM(deductible_amt) amt
                        FROM gixx_deductibles
                       WHERE extract_id = rec.extract_id
                         AND item_no    = rec.item_no)
            LOOP
                v_deductible.total_deductible_amt := b.amt;
            END LOOP;
            
            v_deductible.extract_id := rec.extract_id;
            v_deductible.item_no := rec.item_no;
            v_deductible.ded_deductible_cd := rec.ded_deductible_cd;
            v_deductible.deductible_amt := rec.deductible_amt;
            v_deductible.deductible_rt := rec.deductible_rt;
            v_deductible.deductible_text := rec.deductible_text;
            
            PIPE ROW(v_deductible);        
        END LOOP;
   
   END get_item_deductibles;
   
   
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  February 27, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves engineering item deductibles  
  */
  FUNCTION get_en_deductibles (
      p_extract_id  gixx_deductibles.extract_id%TYPE,
      p_item_no     gixx_deductibles.item_no%TYPE
   )
   RETURN item_deductible_tab PIPELINED
   IS
        v_deductible    item_deductible_type;        
   BEGIN
        FOR rec IN (SELECT extract_id, item_no, ded_deductible_cd, 
                           ded_line_cd, ded_subline_cd,
                           deductible_rt, deductible_text, 
                           deductible_amt
                      FROM gixx_deductibles
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            FOR a IN (SELECT deductible_title
                        FROM giis_deductible_desc
                       WHERE deductible_cd = rec.ded_deductible_cd)
            LOOP
                v_deductible.deductible_name := a.deductible_title;
            END LOOP;
            
            v_deductible.extract_id := rec.extract_id;
            v_deductible.item_no := rec.item_no;
            v_deductible.ded_deductible_cd := rec.ded_deductible_cd;
            v_deductible.ded_line_cd := rec.ded_line_cd;
            v_deductible.ded_subline_cd := rec.ded_subline_cd;
            v_deductible.deductible_rt := rec.deductible_rt;
            v_deductible.deductible_text := rec.deductible_text;
            v_deductible.deductible_amt := rec.deductible_amt;
            
            PIPE ROW(v_deductible);
        END LOOP;
   END get_en_deductibles;


END Gixx_Deductibles_Pkg;
/


