DROP PROCEDURE CPI.GET_NUMBERING_SCHEME;

CREATE OR REPLACE PROCEDURE CPI.get_numbering_scheme 
(p_fund_cd      IN   GIAC_PAYT_REQ_DOCS.gibr_gfun_fund_cd%TYPE,
 p_iss_cd       IN   GIAC_PAYT_REQ_DOCS.gibr_branch_cd%TYPE,
 p_document_cd  IN   GIAC_PAYT_REQ_DOCS.document_cd%TYPE,
 p_yy_tag       OUT  GIAC_PAYT_REQ_DOCS.yy_tag%TYPE,
 p_mm_tag       OUT  GIAC_PAYT_REQ_DOCS.mm_tag%TYPE,
 p_msg_alert    OUT  VARCHAR2) 

IS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes get_numbering_scheme program unit in GICLS043
   **                 
   */

 v_yy_tag       GIAC_PAYT_REQ_DOCS.yy_tag%TYPE;
 v_mm_tag       GIAC_PAYT_REQ_DOCS.mm_tag%TYPE;

BEGIN
  FOR a1 IN (SELECT yy_tag, mm_tag
               FROM GIAC_PAYT_REQ_DOCS
              WHERE gibr_gfun_fund_cd = p_fund_cd
                AND gibr_branch_cd = p_iss_cd
                AND document_cd = p_document_cd) 
  LOOP
    v_yy_tag := a1.yy_tag;
    v_mm_tag := a1.mm_tag;
    EXIT;
  END LOOP;

  if v_yy_tag is null OR
     v_mm_tag is null then
    p_msg_alert := 'The numbering scheme of this document is not' ||
                   ' defined.'||' Please check existence of document code' ||
                   ' in GIAC_PAYT_REQ_DOCS.';
  END IF;
  
  p_yy_tag := v_yy_tag;
  p_mm_tag := v_mm_tag;
      
END;
/


