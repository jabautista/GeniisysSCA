DROP PROCEDURE CPI.GICLS032_GET_NUMBERING_SCHEME;

CREATE OR REPLACE PROCEDURE CPI.gicls032_get_numbering_scheme (
   p_fund_cd       IN       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
   p_iss_cd        IN       giac_payt_req_docs.gibr_branch_cd%TYPE,
   p_document_cd   IN       giac_payt_req_docs.document_cd%TYPE,
   p_yy_tag        OUT      giac_payt_req_docs.yy_tag%TYPE,
   p_mm_tag        OUT      giac_payt_req_docs.mm_tag%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  2.28.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - get_numbering_scheme
   **
   */
   v_line_cd_tag   giac_payt_req_docs.line_cd_tag%TYPE;
   v_yy_tag        giac_payt_req_docs.yy_tag%TYPE;
   v_mm_tag        giac_payt_req_docs.mm_tag%TYPE;
BEGIN
   FOR a1 IN (SELECT line_cd_tag, yy_tag, mm_tag
                FROM giac_payt_req_docs
               WHERE gibr_gfun_fund_cd = p_fund_cd
                 AND gibr_branch_cd = p_iss_cd                                                                --variable.branch_cd
                 AND document_cd = p_document_cd)
   LOOP
      v_line_cd_tag := a1.line_cd_tag;
      v_yy_tag := a1.yy_tag;
      v_mm_tag := a1.mm_tag;
      EXIT;
   END LOOP;

   IF v_line_cd_tag IS NULL OR v_yy_tag IS NULL OR v_mm_tag IS NULL
   THEN
      raise_application_error (-20001,
                                  'The numbering scheme of this document is not'
                               || ' defined. Please check existence of document code in GIAC_PAYT_REQ_DOCS.'
                              );
   END IF;
END;
/


