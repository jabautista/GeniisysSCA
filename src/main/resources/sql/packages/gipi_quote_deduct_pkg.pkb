CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Deduct_Pkg AS

  FUNCTION get_gipi_quote_deduct (v_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_deduct_tab PIPELINED  IS
    
    v_gipi_quote_deduct      gipi_quote_deduct_type;
    
  BEGIN  
    FOR i IN (
      SELECT A.quote_id,          A.item_no,          A.peril_cd,        d.peril_name,      A.ded_deductible_cd,
             b.deductible_title,  A.deductible_text,  A.deductible_amt,  A.deductible_rt, b.ded_type         
        FROM GIPI_QUOTE_DEDUCTIBLES A,
             GIIS_DEDUCTIBLE_DESC B,
             GIPI_QUOTE C,
             GIIS_PERIL D
       WHERE A.quote_id = c.quote_id
         AND b.line_cd = c.line_cd
         AND b.subline_cd = c.subline_cd
         AND A.ded_deductible_cd = b.deductible_cd
         AND c.line_cd = d.line_cd
         AND A.peril_cd = d.peril_cd
         AND c.quote_id = v_quote_id)
    LOOP
      v_gipi_quote_deduct.quote_id          := i.quote_id;           
      v_gipi_quote_deduct.item_no           := i.item_no;           
      v_gipi_quote_deduct.peril_cd          := i.peril_cd;      
      v_gipi_quote_deduct.peril_name        := i.peril_name;      
      v_gipi_quote_deduct.ded_deductible_cd := i.ded_deductible_cd;
      v_gipi_quote_deduct.deductible_title  := i.deductible_title;
      v_gipi_quote_deduct.deductible_text   := i.deductible_text;
      v_gipi_quote_deduct.deductible_amt    := i.deductible_amt;
      v_gipi_quote_deduct.deductible_rt     := i.deductible_rt;    
      v_gipi_quote_deduct.ded_type          := i.ded_type;        
      PIPE ROW (v_gipi_quote_deduct);
    END LOOP;
    RETURN;  
  END get_gipi_quote_deduct;
  
  
  PROCEDURE set_gipi_quote_deduct (p_gipi_quote_deduct          IN GIPI_QUOTE_DEDUCTIBLES%ROWTYPE)
  IS                                   
    v_quote_id      gipi_quote.quote_id%TYPE; -- added nieko 0407016 UW-SPECS-2015-086 Quotation Deductibles
    v_subline_cd    gipi_quote.subline_cd%TYPE; -- added nieko 0407016 UW-SPECS-2015-086 Quotation Deductibles
  BEGIN
    
    IF p_gipi_quote_deduct.quote_id = 0 
    THEN
       SELECT last_number - 1
         INTO v_quote_id
         FROM all_sequences
        WHERE sequence_name = 'QUOTE_QUOTE_ID_S';
    ELSE
        v_quote_id := p_gipi_quote_deduct.quote_id;
    END IF;
    
       
    MERGE INTO GIPI_QUOTE_DEDUCTIBLES
         USING dual ON (quote_id           = v_quote_id -- added nieko 0407016 UW-SPECS-2015-086 Quotation Deductibles, from p_gipi_quote_deduct.quote_id to v_quote_id
                    AND item_no            = p_gipi_quote_deduct.item_no
                    AND peril_cd           = p_gipi_quote_deduct.peril_cd
                    AND ded_deductible_cd  = p_gipi_quote_deduct.ded_deductible_cd)
     WHEN NOT MATCHED THEN
         INSERT(quote_id,item_no, peril_cd, ded_deductible_cd, 
                deductible_text,deductible_amt,deductible_rt,
                -- added nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                ded_line_cd, ded_subline_cd, aggregate_sw, ceiling_sw, max_amt, min_amt, range_sw
                -- added nieko 02172016 end
               )
         VALUES (v_quote_id,p_gipi_quote_deduct.item_no,p_gipi_quote_deduct.peril_cd, -- added nieko 0407016 UW-SPECS-2015-086 Quotation Deductibles, from p_gipi_quote_deduct.quote_id to v_quote_id
                 p_gipi_quote_deduct.ded_deductible_cd,p_gipi_quote_deduct.deductible_text, 
                 p_gipi_quote_deduct.deductible_amt, p_gipi_quote_deduct.deductible_rt,
                 -- added nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                 p_gipi_quote_deduct.ded_line_cd,
                 p_gipi_quote_deduct.ded_subline_cd,
                 p_gipi_quote_deduct.aggregate_sw,
                 p_gipi_quote_deduct.ceiling_sw,
                 p_gipi_quote_deduct.max_amt,
                 p_gipi_quote_deduct.min_amt,
                 p_gipi_quote_deduct.range_sw
                 -- added nieko 02172016 end
                )
     WHEN MATCHED THEN
         UPDATE SET deductible_text = p_gipi_quote_deduct.deductible_text,       
                    deductible_amt  = p_gipi_quote_deduct.deductible_amt,       
                    deductible_rt   = p_gipi_quote_deduct.deductible_rt,
                    -- added nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                    aggregate_sw = p_gipi_quote_deduct.aggregate_sw,
                    ceiling_sw = p_gipi_quote_deduct.ceiling_sw,
                    max_amt = p_gipi_quote_deduct.max_amt,
                    min_amt = p_gipi_quote_deduct.min_amt,
                    range_sw = p_gipi_quote_deduct.range_sw
                    -- added nieko 02172016 end
                    ;                     
     -- added nieko 0407016 UW-SPECS-2015-086 Quotation Deductibles,
     SELECT subline_cd
       INTO v_subline_cd
       FROM gipi_quote
      WHERE quote_id = v_quote_id;
     
     DELETE FROM gipi_quote_deductibles
           WHERE quote_id = v_quote_id
             AND ded_subline_cd <> v_subline_cd;
     -- added nieko 0407016 end
             
  END set_gipi_quote_deduct;                                       
    

  PROCEDURE del_gipi_quote_deduct (p_quote_id                  GIPI_QUOTE_DEDUCTIBLES.quote_id%TYPE )
  IS
  
  BEGIN
  
      DELETE FROM GIPI_QUOTE_DEDUCTIBLES
     WHERE quote_id          = p_quote_id;
  
  END del_gipi_quote_deduct;
  
  /*
  **  Created by        : D.Alcantara
  **  Date Created     : 1.03.2011
  **  Reference By     : (GIIMM002 - Quotation Information)
  **  Description     : Retrieves saved item deductibles with ded_type of 'T'    
  */
  FUNCTION get_quote_deduct_with_tsi (p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_deduct_tab PIPELINED
  IS
    v_deduct    gipi_quote_deduct_type;
  BEGIN    
    FOR i IN (
        SELECT A.quote_id, A.item_no, A.peril_cd, A.ded_deductible_cd, ESCAPE_VALUE(A.deductible_text) deductible_text        
        FROM GIPI_QUOTE_DEDUCTIBLES A,
             GIIS_DEDUCTIBLE_DESC B,
             GIPI_QUOTE C,
             GIIS_PERIL D
       WHERE A.quote_id = C.quote_id
         AND B.line_cd = C.line_cd
         AND B.subline_cd = C.subline_cd
         AND A.ded_deductible_cd = B.deductible_cd
         AND C.line_cd = D.line_cd
         AND A.peril_cd = D.peril_cd 
         AND B.ded_type = 'T'
         AND A.quote_id = p_quote_id)
    LOOP
        v_deduct.quote_id          := i.quote_id;           
        v_deduct.item_no           := i.item_no;           
        v_deduct.peril_cd          := i.peril_cd;            
        v_deduct.ded_deductible_cd := i.ded_deductible_cd;
        v_deduct.deductible_text   := i.deductible_text;   
        PIPE ROW (v_deduct);
    END LOOP;
    RETURN;
  END get_quote_deduct_with_tsi;
  
  /*
  **  Created by        : D.Alcantara
  **  Date Created     : 1.03.2011
  **  Reference By     : (GIIMM002 - Quotation Information)
  **  Description     :     
  */    
  PROCEDURE del_gipi_quote_deduct2 (p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                    p_peril_cd GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
                                    p_item_no  GIPI_QUOTE_DEDUCTIBLES.item_no%TYPE)
  IS
  BEGIN
    DELETE FROM GIPI_QUOTE_DEDUCTIBLES
     WHERE quote_id          = p_quote_id
           AND item_no       = p_item_no
           AND peril_cd      = p_peril_cd;
  END del_gipi_quote_deduct2;
  
  /*
  **  Created by        : Veronica V. Raymundo
  **  Date Created     : 05.10.2011
  **  Reference By     : (GIIMM002 - Quotation Information)
  **  Description     : Deletes quote deductible given the quote_id, item_no,
  **                    peril_cd and deductible_cd    
  */ 
  PROCEDURE del_gipi_quote_deduct3 (p_quote_id  GIPI_QUOTE.quote_id%TYPE,
                                    p_item_no   GIPI_QUOTE_DEDUCTIBLES.item_no%TYPE,
                                    p_peril_cd  GIPI_QUOTE_DEDUCTIBLES.peril_cd%TYPE,
                                    p_deduct_cd GIPI_QUOTE_DEDUCTIBLES.ded_deductible_cd%TYPE)
  IS
                                  
  BEGIN
    DELETE FROM GIPI_QUOTE_DEDUCTIBLES
         WHERE quote_id          = p_quote_id
           AND item_no           = p_item_no
           AND peril_cd          = p_peril_cd
           AND ded_deductible_cd = p_deduct_cd;
  END;
  
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 30, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Function returns details of deductibles under a Package Quotation 
*/
 FUNCTION get_gipi_quote_deduct_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_deduct_tab PIPELINED  IS
    
    v_gipi_quote_deduct      gipi_quote_deduct_type;
    
  BEGIN  
    FOR i IN (
      SELECT A.quote_id,          A.item_no,          A.peril_cd,        d.peril_name,      A.ded_deductible_cd,
             b.deductible_title,  A.deductible_text,  A.deductible_amt,  A.deductible_rt, b.ded_type         
        FROM GIPI_QUOTE_DEDUCTIBLES A,
             GIIS_DEDUCTIBLE_DESC B,
             GIPI_QUOTE C,
             GIIS_PERIL D
       WHERE A.quote_id = c.quote_id
         AND b.line_cd = c.line_cd
         AND b.subline_cd = c.subline_cd
         AND A.ded_deductible_cd = b.deductible_cd
         AND c.line_cd = d.line_cd
         AND A.peril_cd = d.peril_cd
         AND c.quote_id IN (SELECT quote_id
                            FROM GIPI_QUOTE
                            WHERE pack_quote_id = p_pack_quote_id))
    LOOP
      v_gipi_quote_deduct.quote_id          := i.quote_id;           
      v_gipi_quote_deduct.item_no           := i.item_no;           
      v_gipi_quote_deduct.peril_cd          := i.peril_cd;      
      v_gipi_quote_deduct.peril_name        := i.peril_name;      
      v_gipi_quote_deduct.ded_deductible_cd := i.ded_deductible_cd;
      v_gipi_quote_deduct.deductible_title  := i.deductible_title;
      v_gipi_quote_deduct.deductible_text   := i.deductible_text;
        v_gipi_quote_deduct.deductible_amt    := i.deductible_amt;
        v_gipi_quote_deduct.deductible_rt     := i.deductible_rt;    
      v_gipi_quote_deduct.ded_type             := i.ded_type;        
      PIPE ROW (v_gipi_quote_deduct);
    END LOOP;
    RETURN;  
  END get_gipi_quote_deduct_for_pack;
  
    FUNCTION get_deductible_info_tg(
        p_quote_id 	gipi_quote_deductibles.quote_id%TYPE,
        p_item_no	gipi_quote_deductibles.item_no%TYPE,
        p_peril_cd	gipi_quote_deductibles.peril_cd%TYPE,
		p_line_cd giis_deductible_desc.line_cd%TYPE,
        p_subline_cd giis_deductible_desc.subline_cd%TYPE
    )
    RETURN deductible_info_tg_tab PIPELINED
    IS
        v_ded_info	deductible_info_tg_type;

    BEGIN
        FOR i IN(SELECT a.quote_id, a.item_no, a.peril_cd, a.ded_deductible_cd, a.deductible_text, a.deductible_amt, a.deductible_rt, b.deductible_title, b.ded_type --added by steven 1/3/2013 "ded_type"
                   FROM gipi_quote_deductibles a, giis_deductible_desc b
                  WHERE a.quote_id = p_quote_id
                    AND a.item_no = p_item_no
                    AND a.peril_cd = p_peril_cd
					AND b.line_cd = p_line_cd
					AND b.subline_cd = p_subline_cd
					AND a.ded_deductible_cd = b.deductible_cd)
        LOOP
			v_ded_info.quote_id := i.quote_id;
			v_ded_info.item_no := i.item_no;
			v_ded_info.peril_cd := i.peril_cd;
            v_ded_info.ded_deductible_cd := i.ded_deductible_cd;
        	v_ded_info.deductible_text := i.deductible_text;
	        v_ded_info.deductible_title := i.deductible_title;
	        v_ded_info.deductible_amt := i.deductible_amt;
	        v_ded_info.deductible_rt := i.deductible_rt;
			v_ded_info.ded_type := i.ded_type;
            PIPE ROW(v_ded_info);
        END LOOP;
    END get_deductible_info_tg;
	
	PROCEDURE set_deductible_info_giimm002(
		p_quote_id			IN gipi_quote_deductibles.quote_id%TYPE,
		p_item_no			IN gipi_quote_deductibles.item_no%TYPE,
		p_peril_cd			IN gipi_quote_deductibles.peril_cd%TYPE,
		p_deductible_cd		IN gipi_quote_deductibles.ded_deductible_cd%TYPE,
		p_deductible_amt	IN gipi_quote_deductibles.deductible_amt%TYPE,
		p_deductible_rt		IN gipi_quote_deductibles.deductible_rt%TYPE,
		p_deductible_text	IN gipi_quote_deductibles.deductible_text%TYPE
	)
	IS
	BEGIN
		MERGE INTO gipi_quote_deductibles
		
		USING dual
		   ON (quote_id = p_quote_id
		  AND item_no = p_item_no
		  AND peril_cd = p_peril_cd
		  AND ded_deductible_cd = p_deductible_cd)
		  
		 WHEN NOT MATCHED THEN
	   INSERT (quote_id, item_no, peril_cd, ded_deductible_cd, deductible_amt, deductible_rt, last_update, deductible_text)
	   VALUES (p_quote_id, p_item_no, p_peril_cd, p_deductible_cd, p_deductible_amt, p_deductible_rt, SYSDATE, p_deductible_text)
	   
	     WHEN MATCHED THEN
	   UPDATE
	      SET deductible_amt = p_deductible_amt,
		      deductible_rt = p_deductible_rt,
			  last_update = SYSDATE,
			  deductible_text = p_deductible_text;
	END;
	
	PROCEDURE del_deductible_info_giimm002(
		p_quote_id			IN gipi_quote_deductibles.quote_id%TYPE,
		p_item_no			IN gipi_quote_deductibles.item_no%TYPE,
		p_peril_cd			IN gipi_quote_deductibles.peril_cd%TYPE,
		p_deductible_cd		IN gipi_quote_deductibles.ded_deductible_cd%TYPE
	)
	IS
	BEGIN
		DELETE
		  FROM GIPI_QUOTE_DEDUCTIBLES
		 WHERE quote_id = p_quote_id
		   AND item_no = p_item_no
		   AND peril_cd = p_peril_cd
		   AND ded_deductible_cd = p_deductible_cd;
	END;
    
    /*
   **  Created by        : Nieko B.
   **  Date Created     : 02172016
   **  Reference By     : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Retrieves all quote deductibles
   */
   FUNCTION get_all_gipi_quote_deduct (v_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_deduct_tab PIPELINED
   IS
      v_gipi_quote_deduct   gipi_quote_deduct_type;
   BEGIN
      FOR i IN (SELECT a.quote_id, a.item_no, a.peril_cd,
                       a.ded_deductible_cd, b.deductible_title,
                       a.deductible_text, a.deductible_amt, a.deductible_rt,
                       b.ded_type,
                       a.aggregate_sw, a.ceiling_sw,
                       a.create_date, a.create_user, a.max_amt, a.min_amt,
                       a.range_sw
                FROM   gipi_quote_deductibles a,
                       giis_deductible_desc b,
                       gipi_quote c
                 WHERE a.quote_id = c.quote_id
                   AND b.line_cd = c.line_cd
                   AND b.subline_cd = c.subline_cd
                   AND a.ded_deductible_cd = b.deductible_cd
                   AND c.quote_id = v_quote_id
                   AND a.item_no = 0
                   AND a.peril_cd = 0)
      LOOP
         v_gipi_quote_deduct.quote_id := i.quote_id;
         v_gipi_quote_deduct.item_no := i.item_no;
         v_gipi_quote_deduct.peril_cd := i.peril_cd;
         v_gipi_quote_deduct.ded_deductible_cd := i.ded_deductible_cd;
         v_gipi_quote_deduct.deductible_title := i.deductible_title;
         v_gipi_quote_deduct.deductible_text := i.deductible_text;
         v_gipi_quote_deduct.deductible_amt := i.deductible_amt;
         v_gipi_quote_deduct.deductible_rt := i.deductible_rt;
         v_gipi_quote_deduct.ded_type := i.ded_type;
         v_gipi_quote_deduct.aggregate_sw := i.aggregate_sw;
         v_gipi_quote_deduct.ceiling_sw := i.ceiling_sw;
         v_gipi_quote_deduct.create_date := i.create_date;
         v_gipi_quote_deduct.create_user := i.create_user;
         v_gipi_quote_deduct.max_amt := i.max_amt;
         v_gipi_quote_deduct.min_amt := i.min_amt;
         v_gipi_quote_deduct.range_sw := i.range_sw;
         PIPE ROW (v_gipi_quote_deduct);
      END LOOP;

      RETURN;
   END get_all_gipi_quote_deduct;

   /*
   **  Created by        : Nieko B.
   **  Date Created     : 02172016
   **  Reference By     : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Retrieves item quote deductibles
   */
   FUNCTION get_item_gipi_quote_deduct (
      v_quote_id   gipi_quote.quote_id%TYPE,
      v_item_no    gipi_quote_deductibles.item_no%TYPE
   )
      RETURN gipi_quote_deduct_tab PIPELINED
   IS
      v_gipi_quote_deduct   gipi_quote_deduct_type;
   BEGIN
      FOR i IN (SELECT a.quote_id, a.item_no, a.peril_cd,
                       a.ded_deductible_cd, b.deductible_title,
                       a.deductible_text, a.deductible_amt, a.deductible_rt,
                       b.ded_type, a.aggregate_sw, a.ceiling_sw,
                       a.create_date, a.create_user, a.max_amt, a.min_amt,
                       a.range_sw
                  FROM gipi_quote_deductibles a,
                       giis_deductible_desc b,
                       gipi_quote c
                 WHERE a.quote_id = c.quote_id
                   AND b.line_cd = c.line_cd
                   AND b.subline_cd = c.subline_cd
                   AND a.ded_deductible_cd = b.deductible_cd
                   AND c.quote_id = v_quote_id
                   AND a.item_no = v_item_no
                   AND a.peril_cd = 0)
      LOOP
         v_gipi_quote_deduct.quote_id := i.quote_id;
         v_gipi_quote_deduct.item_no := i.item_no;
         v_gipi_quote_deduct.peril_cd := i.peril_cd;
         v_gipi_quote_deduct.ded_deductible_cd := i.ded_deductible_cd;
         v_gipi_quote_deduct.deductible_title := i.deductible_title;
         v_gipi_quote_deduct.deductible_text := i.deductible_text;
         v_gipi_quote_deduct.deductible_amt := i.deductible_amt;
         v_gipi_quote_deduct.deductible_rt := i.deductible_rt;
         v_gipi_quote_deduct.ded_type := i.ded_type;
         v_gipi_quote_deduct.aggregate_sw := i.aggregate_sw;
         v_gipi_quote_deduct.ceiling_sw := i.ceiling_sw;
         v_gipi_quote_deduct.create_date := i.create_date;
         v_gipi_quote_deduct.create_user := i.create_user;
         v_gipi_quote_deduct.max_amt := i.max_amt;
         v_gipi_quote_deduct.min_amt := i.min_amt;
         v_gipi_quote_deduct.range_sw := i.range_sw;
         PIPE ROW (v_gipi_quote_deduct);
      END LOOP;

      RETURN;
   END get_item_gipi_quote_deduct;

   /*
   **  Created by        : Nieko B.
   **  Date Created     : 02172016
   **  Reference By     : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Retrieves peril item quote deductibles
   */
   FUNCTION get_peril_gipi_quote_deduct (
      v_quote_id   gipi_quote.quote_id%TYPE,
      v_item_no    gipi_quote_deductibles.item_no%TYPE,
      v_peril_cd   gipi_quote_deductibles.peril_cd%TYPE
   )
      RETURN gipi_quote_deduct_tab PIPELINED
   IS
      v_gipi_quote_deduct   gipi_quote_deduct_type;
   BEGIN
      FOR i IN (SELECT a.quote_id, a.item_no, a.peril_cd,
                       a.ded_deductible_cd, b.deductible_title,
                       a.deductible_text, a.deductible_amt, a.deductible_rt,
                       b.ded_type, a.aggregate_sw, a.ceiling_sw,
                       a.create_date, a.create_user, a.max_amt, a.min_amt,
                       a.range_sw
                  FROM gipi_quote_deductibles a,
                       giis_deductible_desc b,
                       gipi_quote c
                 WHERE a.quote_id = c.quote_id
                   AND b.line_cd = c.line_cd
                   AND b.subline_cd = c.subline_cd
                   AND a.ded_deductible_cd = b.deductible_cd
                   AND c.quote_id = v_quote_id
                   AND a.item_no = v_item_no
                   AND a.peril_cd = v_peril_cd)
      LOOP
         v_gipi_quote_deduct.quote_id := i.quote_id;
         v_gipi_quote_deduct.item_no := i.item_no;
         v_gipi_quote_deduct.peril_cd := i.peril_cd;
         v_gipi_quote_deduct.ded_deductible_cd := i.ded_deductible_cd;
         v_gipi_quote_deduct.deductible_title := i.deductible_title;
         v_gipi_quote_deduct.deductible_text := i.deductible_text;
         v_gipi_quote_deduct.deductible_amt := i.deductible_amt;
         v_gipi_quote_deduct.deductible_rt := i.deductible_rt;
         v_gipi_quote_deduct.ded_type := i.ded_type;
         v_gipi_quote_deduct.aggregate_sw := i.aggregate_sw;
         v_gipi_quote_deduct.ceiling_sw := i.ceiling_sw;
         v_gipi_quote_deduct.create_date := i.create_date;
         v_gipi_quote_deduct.create_user := i.create_user;
         v_gipi_quote_deduct.max_amt := i.max_amt;
         v_gipi_quote_deduct.min_amt := i.min_amt;
         v_gipi_quote_deduct.range_sw := i.range_sw;
         PIPE ROW (v_gipi_quote_deduct);
      END LOOP;

      RETURN;
   END get_peril_gipi_quote_deduct;
    
    /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Checking of deductible type
   */
   PROCEDURE check_quote_deductible (
      p_quote_id           IN       gipi_quote_deductibles.quote_id%TYPE,
      p_item_no            IN       gipi_quote_deductibles.item_no%TYPE,
      p_ded_type           IN       giis_deductible_desc.ded_type%TYPE,
      p_deductible_level   IN       NUMBER,
      p_message            OUT      VARCHAR2
   )
   IS
      v_items            VARCHAR2 (32767);
      v_currency_count   NUMBER;
      v_curr_rt_count    NUMBER;
   BEGIN
      p_message := 'SUCCESS';

      IF p_ded_type = 'T'
      THEN
         IF p_deductible_level = 1
         THEN
            IF NOT gipi_quote_item_pkg.quote_has_item (p_quote_id)
            THEN
               p_message :=
                  'There is still no item for this QUOTE. This type of deductible cannot be used. Please enter item first.';
            ELSE
               v_items :=
                    gipi_quote_item_pkg.get_quote_items_wo_peril (p_quote_id);
               v_currency_count :=
                  gipi_quote_item_pkg.get_quote_items_currency_count
                                                                  (p_quote_id);
               v_curr_rt_count :=
                  gipi_quote_item_pkg.get_quote_items_curr_rt_count
                                                                  (p_quote_id);

               IF v_items IS NOT NULL
               THEN
                  p_message :=
                        'There is still no TSI amount for item/s '
                     || SUBSTR (RTRIM (LTRIM (v_items)),
                                1,
                                LENGTH (RTRIM (LTRIM (v_items))) - 1
                               )
                     || '. This type of deductible cannot be used. Please enter perils first.';
               ELSIF v_currency_count > 1
               THEN
                  p_message :=
                     'You are only allowed to use this type of deductible for a single-currency policy.';
               ELSIF v_curr_rt_count > 1
               THEN
                  p_message :=
                     'You are only allowed to use this type of deductible for a single-currency policy.';
               END IF;
            END IF;
         ELSIF p_deductible_level = 2 THEN
            IF NOT gipi_quote_item_pkg.quote_item_has_peril(p_quote_id, p_item_no) THEN
               p_message := 'There is still no TSI amount for this item. Please enter peril(s) first before using the deductible';
            END IF;               
         END IF;
      END IF;
   END check_quote_deductible;
   
   /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : List of quote item perils
   */
   FUNCTION get_quote_itmperl_list (
      p_quote_id           IN       gipi_quote_deductibles.quote_id%TYPE
   ) 
      RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.item_no, b.peril_name, b.peril_cd, b.peril_type,
                                a.tsi_amt
                           FROM gipi_quote_itmperil a, giis_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND a.quote_id = p_quote_id
                            AND a.prem_amt > 0
                       ORDER BY 1, 2)
      LOOP
         v_peril.item_no := i.item_no;
         v_peril.peril_name := i.peril_name;
         v_peril.peril_cd := i.peril_cd;
         v_peril.peril_type := i.peril_type;
         v_peril.tsi_amt := i.tsi_amt;         
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_quote_itmperl_list;
   
   
   /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Delete policy level deductibles base on TSI amount
   */
   PROCEDURE del_quote_deduct_base_tsi (
      p_quote_id   gipi_quote_deductibles.quote_id%TYPE
   )
   IS
       BEGIN
          DELETE FROM gipi_quote_deductibles a
          WHERE quote_id = p_quote_id
            AND item_no = '0'
            AND peril_cd = '0'
            AND ded_deductible_cd IN (
                   SELECT deductible_cd
                     FROM giis_deductible_desc b
                    WHERE b.line_cd = a.ded_line_cd
                      AND b.subline_cd = a.ded_subline_cd
                      AND ded_type = 'T');
   END del_quote_deduct_base_tsi;
                                    
END Gipi_Quote_Deduct_Pkg;
/


