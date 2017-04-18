DROP PROCEDURE CPI.POP_PACK;

CREATE OR REPLACE PROCEDURE CPI.POP_PACK(p_par_id           IN  GIPI_WITEM.par_id%TYPE,
                                         p_item_no          IN  GIPI_WITEM.item_no%TYPE,
                                         p_pack_line_cd     IN  GIPI_WITEM.pack_line_cd%TYPE,
                                         p_pack_subline_cd  IN  GIPI_WITEM.pack_line_cd%TYPE,
                                         p_line_cd          IN  GIPI_WPOLBAS.line_cd%TYPE,
                                         p_subline_cd       IN  GIPI_WPOLBAS.subline_cd%TYPE,
                                         p_iss_cd           IN  GIPI_WPOLBAS.iss_cd%TYPE,
                                         p_issue_yy         IN  GIPI_WPOLBAS.issue_yy%TYPE,
                                         p_pol_seq_no       IN  GIPI_WPOLBAS.pol_seq_no%TYPE,
                                         p_renew_no         IN  GIPI_WPOLBAS.renew_no%TYPE) 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 21, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Equivalent to the Program Unit POP_PACK in GIPIS096 module
*/

 b540_pack_par_id    GIPI_WPOLBAS.pack_par_id%TYPE;
 b540_assd_no        GIPI_WPOLBAS.assd_no%TYPE;
 b540_line_cd        GIPI_WPOLBAS.line_cd%TYPE;
 b540_subline_cd     GIPI_WPOLBAS.subline_cd%TYPE;
 b540_iss_cd         GIPI_WPOLBAS.iss_cd%TYPE;
 b540_issue_yy       GIPI_WPOLBAS.issue_yy%TYPE;
 b540_pol_seq_no     GIPI_WPOLBAS.pol_seq_no%TYPE;
 b540_renew_no       GIPI_WPOLBAS.renew_no%TYPE;
 b540_eff_date       GIPI_WPOLBAS.eff_date%TYPE;
 b540_expiry_date    GIPI_WPOLBAS.expiry_date%TYPE;
    
BEGIN
    FOR c1 IN (SELECT b.pack_par_id, b.assd_no,    b.line_cd,    b.subline_cd,   
                      b.iss_cd,      b.issue_yy,   b.pol_seq_no,     
                      b.renew_no,    b.eff_date,   b.expiry_date
                FROM GIPI_WPOLBAS b, GIPI_PACK_WPOLBAS a 
               WHERE 1=1
                 AND b.pack_par_id  = a.pack_par_id
                 AND b.line_cd      = p_pack_line_cd
                 AND b.subline_cd   = p_pack_subline_cd
                 AND a.line_cd      = p_line_cd
                 AND a.subline_cd   = p_subline_cd
                 AND a.iss_cd       = p_iss_cd
                 AND a.issue_yy     = p_issue_yy
                 AND a.pol_seq_no   = p_pol_seq_no
                 AND a.renew_no     = p_renew_no)    
    LOOP 
         b540_pack_par_id := c1.pack_par_id;  
         b540_assd_no     := c1.assd_no;         
         b540_line_cd     := c1.line_cd;
         b540_subline_cd  := c1.subline_cd;
         b540_iss_cd      := c1.iss_cd;
         b540_issue_yy    := c1.issue_yy;
         b540_pol_seq_no  := c1.pol_seq_no;
         b540_renew_no    := c1.renew_no;
         b540_eff_date    := c1.eff_date;                  
         b540_expiry_date := c1.expiry_date;
     
     IF p_pack_line_cd = GIISP.V('LINE_CODE_MC') THEN
          
          POP_PACK_MC(p_par_id,    p_item_no , p_pack_line_cd, p_pack_subline_cd, b540_line_cd,  b540_subline_cd,        
                      b540_iss_cd, b540_issue_yy, b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                      
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_FI') THEN
          
          POP_PACK_FI(b540_pack_par_id, b540_assd_no,  p_par_id, p_item_no , b540_line_cd, b540_subline_cd,        
                      b540_iss_cd,      b540_issue_yy, b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                      
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_EN') THEN
     
          POP_PACK_EN(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                      b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_MN') THEN
     
          POP_PACK_MN(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                      b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_MH') THEN
          
          POP_PACK_MH(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                      b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_CA') THEN
          
          POP_PACK_CA(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                      b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_AV') THEN
          
          POP_PACK_AV(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                      b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_AC') THEN
          
          POP_PACK_PA(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                      b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                       
     ELSE
          
          POP_PACK_OTH(p_par_id, p_item_no , b540_line_cd, b540_subline_cd, b540_iss_cd, b540_issue_yy,       
                       b540_pol_seq_no, b540_renew_no, b540_eff_date, b540_expiry_date);
                        
     END IF;
     
    END LOOP;
END;
/


