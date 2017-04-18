CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Warrcla_Pkg AS

  FUNCTION get_gipi_quote_wc (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_wc_tab PIPELINED  IS
	
	v_gipi_quote_wc       gipi_quote_wc_type;
    
  BEGIN  
    FOR i IN (
      SELECT a.quote_id,                                a.line_cd,                                a.wc_cd,          
	         a.print_seq_no,                            a.wc_title,                               NVL(a.wc_text01, b.wc_text01) wc_text01,  
			 NVL(a.wc_text02, b.wc_text02) wc_text02,   NVL(a.wc_text03, b.wc_text03) wc_text03,  NVL(a.wc_text04, b.wc_text04) wc_text04,
       		 NVL(a.wc_text05, b.wc_text05) wc_text05,   NVL(a.wc_text06, b.wc_text06) wc_text06,  NVL(a.wc_text07, b.wc_text07) wc_text07,
			 NVL(a.wc_text08, b.wc_text08) wc_text08,   NVL(a.wc_text09, b.wc_text09) wc_text09,  NVL(a.wc_text10, b.wc_text10) wc_text10,      
             NVL(a.wc_text11, b.wc_text11) wc_text11,   NVL(a.wc_text12, b.wc_text12) wc_text12,  NVL(a.wc_text13, b.wc_text13) wc_text13, 
			 NVL(a.wc_text14, b.wc_text14) wc_text14,   NVL(a.wc_text15, b.wc_text15) wc_text15,  NVL(a.wc_text16, b.wc_text16) wc_text16,      
             NVL(a.wc_text17, b.wc_text17) wc_text17,   a.wc_remarks,                             a.print_sw,
			 a.change_tag,                              a.user_id,                                a.last_update,  
			 a.wc_title2,                               a.swc_seq_no,							  DECODE(b.wc_sw,'C','Clause','Warranty') wc_sw				       
        FROM GIPI_QUOTE_WC A,
             GIIS_WARRCLA b
       WHERE A.line_cd    = b.line_cd
         AND a.wc_cd      = b.main_wc_cd
         AND A.quote_id   = p_quote_id)
    LOOP
	  v_gipi_quote_wc.quote_id        := i.quote_id;      
	  v_gipi_quote_wc.line_cd         := i.line_cd;
 	  v_gipi_quote_wc.wc_cd           := i.wc_cd;
	  v_gipi_quote_wc.print_seq_no    := i.print_seq_no; 
	  v_gipi_quote_wc.wc_title        := i.wc_title; 
      v_gipi_quote_wc.wc_text         := i.wc_text01||i.wc_text02||i.wc_text03||i.wc_text04||i.wc_text05||i.wc_text06||i.wc_text07||
	  								  	 i.wc_text08||i.wc_text09||i.wc_text10||i.wc_text11||i.wc_text12||i.wc_text13||i.wc_text14||
										 i.wc_text15||i.wc_text16||i.wc_text17;
	  v_gipi_quote_wc.wc_remarks      := i.wc_remarks;
	  v_gipi_quote_wc.print_sw        := i.print_sw; 
	  v_gipi_quote_wc.change_tag      := i.change_tag;       
      v_gipi_quote_wc.user_id         := i.user_id;
	  v_gipi_quote_wc.last_update     := i.last_update;
	  v_gipi_quote_wc.wc_title2       := i.wc_title2;
	  v_gipi_quote_wc.swc_seq_no      := i.swc_seq_no;
  	  v_gipi_quote_wc.wc_sw           := i.wc_sw;  
	  PIPE ROW (v_gipi_quote_wc);
    END LOOP;
	RETURN;  
  END get_gipi_quote_wc;

  PROCEDURE set_gipi_quote_wc (p_gipi_quote_wc             IN GIPI_QUOTE_WC%ROWTYPE,
                               p_quote_id		          OUT GIPI_QUOTE.quote_id%TYPE ) 
  IS
   
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_WC
     USING dual ON (quote_id  = p_quote_id
	                AND wc_cd = p_gipi_quote_wc.wc_cd)
     WHEN NOT MATCHED THEN
              INSERT (quote_id,                        line_cd,                       wc_cd,                       print_seq_no,            
		              wc_title,  		 		       wc_text01,                     wc_text02,                   wc_text03,        
					  wc_text04,                       wc_text05,                     wc_text06,                   wc_text07,  
					  wc_text08,                       wc_text09,                     wc_text10, 				   wc_text11,
					  wc_text12,                       wc_text13,                     wc_text14,                   wc_text15,
					  wc_text16,                       wc_text17,                     wc_remarks,                  print_sw,   
					  change_tag,  					   user_id,                       last_update,                 wc_title2,   
					  swc_seq_no) 
		      VALUES (p_gipi_quote_wc.quote_id,        p_gipi_quote_wc.line_cd,       p_gipi_quote_wc.wc_cd,       p_gipi_quote_wc.print_seq_no,            
			          p_gipi_quote_wc.wc_title,		   p_gipi_quote_wc.wc_text01,     p_gipi_quote_wc.wc_text02,   p_gipi_quote_wc.wc_text03,
					  p_gipi_quote_wc.wc_text04,       p_gipi_quote_wc.wc_text05,     p_gipi_quote_wc.wc_text06,   p_gipi_quote_wc.wc_text07,
					  p_gipi_quote_wc.wc_text08,       p_gipi_quote_wc.wc_text09,     p_gipi_quote_wc.wc_text10,   p_gipi_quote_wc.wc_text11,
					  p_gipi_quote_wc.wc_text12,       p_gipi_quote_wc.wc_text13,     p_gipi_quote_wc.wc_text14,   p_gipi_quote_wc.wc_text15,
                      p_gipi_quote_wc.wc_text16,       p_gipi_quote_wc.wc_text17,     p_gipi_quote_wc.wc_remarks,  p_gipi_quote_wc.print_sw,
					  p_gipi_quote_wc.change_tag,	   p_gipi_quote_wc.user_id,       p_gipi_quote_wc.last_update, p_gipi_quote_wc.wc_title2,
					  p_gipi_quote_wc.swc_seq_no)   
     WHEN MATCHED THEN
         UPDATE SET line_cd        =  p_gipi_quote_wc.line_cd,        
                    print_seq_no   =  p_gipi_quote_wc.print_seq_no,        
                    wc_title       =  p_gipi_quote_wc.wc_title,        
                    wc_text01      =  p_gipi_quote_wc.wc_text01,        
                    wc_text02      =  p_gipi_quote_wc.wc_text02,        
                    wc_text03      =  p_gipi_quote_wc.wc_text03,        
                    wc_text04      =  p_gipi_quote_wc.wc_text04,        
                    wc_text05      =  p_gipi_quote_wc.wc_text05,        
                    wc_text06      =  p_gipi_quote_wc.wc_text06,        
                    wc_text07      =  p_gipi_quote_wc.wc_text07,        
                    wc_text08      =  p_gipi_quote_wc.wc_text08,        
                    wc_text09      =  p_gipi_quote_wc.wc_text09,        
                    wc_text10      =  p_gipi_quote_wc.wc_text10,        
                    wc_text11      =  p_gipi_quote_wc.wc_text11,        
                    wc_text12      =  p_gipi_quote_wc.wc_text12,        
                    wc_text13      =  p_gipi_quote_wc.wc_text13,        
                    wc_text14      =  p_gipi_quote_wc.wc_text14,        
                    wc_text15      =  p_gipi_quote_wc.wc_text15,        
                    wc_text16      =  p_gipi_quote_wc.wc_text16,        
                    wc_text17      =  p_gipi_quote_wc.wc_text17,        
                    wc_remarks     =  p_gipi_quote_wc.wc_remarks,        
                    print_sw       =  p_gipi_quote_wc.print_sw,        
                    change_tag     =  p_gipi_quote_wc.change_tag,        
                    user_id        =  p_gipi_quote_wc.user_id,        
                    last_update    =  p_gipi_quote_wc.last_update,        
                    wc_title2      =  p_gipi_quote_wc.wc_title2,        
                    swc_seq_no     =  p_gipi_quote_wc.swc_seq_no;                      
	
  END set_gipi_quote_wc;

  
  PROCEDURE del_gipi_quote_wc (p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                               p_wc_cd                      GIPI_QUOTE_WC.wc_cd%TYPE ) 
  IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_WC
	 WHERE quote_id = p_quote_id
	   AND wc_cd    = p_wc_cd;
	COMMIT;      
  
  END del_gipi_quote_wc;
  
  
  PROCEDURE del_gipi_quote_wc_all (p_quote_id				    GIPI_QUOTE.quote_id%TYPE) 
  IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_WC
	 WHERE quote_id = p_quote_id;
	COMMIT;      
  
  END del_gipi_quote_wc_all;
  
  PROCEDURE attach_warranty(p_quote_id  GIPI_QUOTE.quote_id%TYPE,
                            p_line_cd   GIPI_QUOTE.line_cd%TYPE,
                            p_peril_cd  GIIS_PERIL.peril_cd%TYPE) 
  IS
     /*
    **  Created by      : D.Alcantara
    **  Date Created 	: 12.27.2010
	**  Reference By 	: (GIIMM002 - Quotation Informaton)
	**  Description 	: This function attaches a warranty for a valid peril	
	*/
    v_print_seq_no         gipi_quote_wc.print_seq_no%TYPE; --added by christian 03/25/2013 
  BEGIN
     FOR rec IN ( SELECT b.main_wc_cd , c.wc_title
                        FROM giis_peril a, 
                             giis_peril_clauses b,
                             giis_warrcla c
                       WHERE a.peril_cd = b.peril_cd
                         AND a.line_cd = b.line_cd
				                 AND a.line_cd = c.line_cd
				                 AND b.main_wc_cd = c.main_wc_cd
				                 AND a.line_cd = p_line_cd
                         AND a.peril_cd = p_peril_cd)
     LOOP
     /*    INSERT INTO gipi_quote_wc (quote_id, line_cd, wc_cd, wc_title)
           VALUES(p_quote_id, p_line_cd, rec.main_wc_cd, rec.wc_title);*/
         --added by christian 03/25/2013
         SELECT count(quote_id)
           INTO v_print_seq_no
           FROM gipi_quote_wc
          WHERE quote_id = p_quote_id 
            AND line_cd = p_line_cd;
            
         MERGE INTO gipi_quote_wc
           USING DUAL ON (quote_id = p_quote_id 
                          AND line_cd = p_line_cd
                          AND wc_cd = rec.main_wc_cd) --added by christian 03/25/2013
           WHEN NOT MATCHED THEN
                INSERT (quote_id, line_cd, wc_cd, wc_title, print_seq_no) --added insert value for print_seq_no christian 03/25/2013
                VALUES (p_quote_id, p_line_cd, rec.main_wc_cd, rec.wc_title, v_print_seq_no+1);
           
     END LOOP; 
     
  END attach_warranty;
  
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 16, 2011
**  Reference By  : GIIMM008 - Quotation Warranties and Clauses
**  Description   : Inserts or updates quotation warranty/clause record.
*/

  PROCEDURE set_gipi_quote_warrcla (p_quote_id          IN       GIPI_QUOTE.quote_id%TYPE,
                                    p_gipi_quote_wc     IN       GIPI_QUOTE_WC%ROWTYPE ) 
  IS
   
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_WC
     USING dual ON (quote_id  = p_quote_id
	                AND wc_cd = p_gipi_quote_wc.wc_cd)
     WHEN NOT MATCHED THEN
              INSERT (quote_id,                        line_cd,                       wc_cd,                       print_seq_no,            
		              wc_title,  		 		       wc_text01,                     wc_text02,                   wc_text03,        
					  wc_text04,                       wc_text05,                     wc_text06,                   wc_text07,  
					  wc_text08,                       wc_text09,                     wc_text10, 				   wc_text11,
					  wc_text12,                       wc_text13,                     wc_text14,                   wc_text15,
					  wc_text16,                       wc_text17,                     wc_remarks,                  print_sw,   
					  change_tag,  					   user_id,                       last_update,                 wc_title2,   
					  swc_seq_no) 
		      VALUES (p_gipi_quote_wc.quote_id,        p_gipi_quote_wc.line_cd,       p_gipi_quote_wc.wc_cd,       p_gipi_quote_wc.print_seq_no,            
			          p_gipi_quote_wc.wc_title,		   p_gipi_quote_wc.wc_text01,     p_gipi_quote_wc.wc_text02,   p_gipi_quote_wc.wc_text03,
					  p_gipi_quote_wc.wc_text04,       p_gipi_quote_wc.wc_text05,     p_gipi_quote_wc.wc_text06,   p_gipi_quote_wc.wc_text07,
					  p_gipi_quote_wc.wc_text08,       p_gipi_quote_wc.wc_text09,     p_gipi_quote_wc.wc_text10,   p_gipi_quote_wc.wc_text11,
					  p_gipi_quote_wc.wc_text12,       p_gipi_quote_wc.wc_text13,     p_gipi_quote_wc.wc_text14,   p_gipi_quote_wc.wc_text15,
                      p_gipi_quote_wc.wc_text16,       p_gipi_quote_wc.wc_text17,     p_gipi_quote_wc.wc_remarks,  p_gipi_quote_wc.print_sw,
					  p_gipi_quote_wc.change_tag,	   p_gipi_quote_wc.user_id,       SYSDATE,                     p_gipi_quote_wc.wc_title2,
					  p_gipi_quote_wc.swc_seq_no)   
     WHEN MATCHED THEN
         UPDATE SET line_cd        =  p_gipi_quote_wc.line_cd,        
                    print_seq_no   =  p_gipi_quote_wc.print_seq_no,        
                    wc_title       =  p_gipi_quote_wc.wc_title,        
                    wc_text01      =  p_gipi_quote_wc.wc_text01,        
                    wc_text02      =  p_gipi_quote_wc.wc_text02,        
                    wc_text03      =  p_gipi_quote_wc.wc_text03,        
                    wc_text04      =  p_gipi_quote_wc.wc_text04,        
                    wc_text05      =  p_gipi_quote_wc.wc_text05,        
                    wc_text06      =  p_gipi_quote_wc.wc_text06,        
                    wc_text07      =  p_gipi_quote_wc.wc_text07,        
                    wc_text08      =  p_gipi_quote_wc.wc_text08,        
                    wc_text09      =  p_gipi_quote_wc.wc_text09,        
                    wc_text10      =  p_gipi_quote_wc.wc_text10,        
                    wc_text11      =  p_gipi_quote_wc.wc_text11,        
                    wc_text12      =  p_gipi_quote_wc.wc_text12,        
                    wc_text13      =  p_gipi_quote_wc.wc_text13,        
                    wc_text14      =  p_gipi_quote_wc.wc_text14,        
                    wc_text15      =  p_gipi_quote_wc.wc_text15,        
                    wc_text16      =  p_gipi_quote_wc.wc_text16,        
                    wc_text17      =  p_gipi_quote_wc.wc_text17,        
                    wc_remarks     =  p_gipi_quote_wc.wc_remarks,        
                    print_sw       =  p_gipi_quote_wc.print_sw,        
                    change_tag     =  p_gipi_quote_wc.change_tag,        
                    user_id        =  p_gipi_quote_wc.user_id,        
                    last_update    =  SYSDATE,        
                    wc_title2      =  p_gipi_quote_wc.wc_title2,        
                    swc_seq_no     =  p_gipi_quote_wc.swc_seq_no;                      
	
  END set_gipi_quote_warrcla;
  
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 21, 2011
**  Reference By  : GIIMM008 - Quotation Warranties and Clauses
**  Description   : Gets quotation warranty/clause record.
*/
  
  FUNCTION get_gipi_quote_warrcla (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_warrcla_tab PIPELINED  IS
	
	v_gipi_quote_wc       gipi_quote_warrcla_type;
    
  BEGIN  
    FOR i IN (
      SELECT a.quote_id,                                a.line_cd,                                a.wc_cd,          
	         a.print_seq_no,                            a.wc_title,                               a.wc_title2,
             a.change_tag,                              a.user_id,                                DECODE(NVL(wc_sw,'W'),'C','Clause','Warranty') wc_sw,  
			 a.swc_seq_no,							  	a.last_update,                             
             a.print_sw,                                a.wc_remarks,                             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text01, b.wc_text01) wc_text01,              
             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text02, b.wc_text02) wc_text02,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text03, b.wc_text03) wc_text03,  
             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text04, b.wc_text04) wc_text04,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text05, b.wc_text05) wc_text05,   
             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text06, b.wc_text06) wc_text06,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text07, b.wc_text07) wc_text07,
			 DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text08, b.wc_text08) wc_text08,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text09, b.wc_text09) wc_text09,  
             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text10, b.wc_text10) wc_text10,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text11, b.wc_text11) wc_text11,   
             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text12, b.wc_text12) wc_text12,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text13, b.wc_text13) wc_text13, 
			 DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text14, b.wc_text14) wc_text14,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text15, b.wc_text15) wc_text15,  
             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text16, b.wc_text16) wc_text16,             DECODE(NVL(a.change_tag, 'N'), 'Y', a.wc_text17, b.wc_text17) wc_text17                               	       
        FROM GIPI_QUOTE_WC A,
             GIIS_WARRCLA b
       WHERE A.line_cd    = b.line_cd
         AND a.wc_cd      = b.main_wc_cd
         AND A.quote_id   = p_quote_id)
    LOOP
	  v_gipi_quote_wc.quote_id        := i.quote_id;      
	  v_gipi_quote_wc.line_cd         := i.line_cd;
 	  v_gipi_quote_wc.wc_cd           := i.wc_cd;
	  v_gipi_quote_wc.print_seq_no    := i.print_seq_no; 
	  v_gipi_quote_wc.wc_title        := i.wc_title; 
      v_gipi_quote_wc.wc_text01       := i.wc_text01;
	  v_gipi_quote_wc.wc_text02       := i.wc_text02;
      v_gipi_quote_wc.wc_text03       := i.wc_text03;
      v_gipi_quote_wc.wc_text04       := i.wc_text04;
      v_gipi_quote_wc.wc_text05       := i.wc_text05;
      v_gipi_quote_wc.wc_text06       := i.wc_text06;
      v_gipi_quote_wc.wc_text07       := i.wc_text07;
      v_gipi_quote_wc.wc_text08       := i.wc_text08;
      v_gipi_quote_wc.wc_text09       := i.wc_text09;
      v_gipi_quote_wc.wc_text10       := i.wc_text10;
      v_gipi_quote_wc.wc_text11       := i.wc_text11;
      v_gipi_quote_wc.wc_text12       := i.wc_text12;
      v_gipi_quote_wc.wc_text13       := i.wc_text13;
      v_gipi_quote_wc.wc_text14       := i.wc_text14;
      v_gipi_quote_wc.wc_text15       := i.wc_text15;
      v_gipi_quote_wc.wc_text16       := i.wc_text16;
      v_gipi_quote_wc.wc_text17       := i.wc_text17;
      v_gipi_quote_wc.wc_remarks      := i.wc_remarks;
	  v_gipi_quote_wc.print_sw        := i.print_sw; 
	  v_gipi_quote_wc.change_tag      := i.change_tag;       
      v_gipi_quote_wc.user_id         := i.user_id;
	  v_gipi_quote_wc.last_update     := i.last_update;
	  v_gipi_quote_wc.wc_title2       := i.wc_title2;
	  v_gipi_quote_wc.swc_seq_no      := i.swc_seq_no;
  	  v_gipi_quote_wc.wc_sw           := i.wc_sw;  
	  PIPE ROW (v_gipi_quote_wc);
    END LOOP;
	RETURN;  
  END get_gipi_quote_warrcla;

  
END Gipi_Quote_Warrcla_Pkg;
/


