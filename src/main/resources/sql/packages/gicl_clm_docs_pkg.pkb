CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_docs_pkg
AS
   FUNCTION get_gicl_clm_docs (
         p_line_cd      gicl_clm_docs.line_cd%TYPE,
      p_subline_cd   gicl_clm_docs.subline_cd%TYPE,
      p_claim_id     gicl_claims.claim_id%type,
      p_find_text varchar2
   )
      RETURN gicl_clm_docs_tab PIPELINED
   IS
      v_clm_docs   gicl_clm_docs_type;
   BEGIN
      FOR i IN (SELECT clm_doc_cd, clm_doc_desc
                  FROM gicl_clm_docs
                 WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd
                   AND clm_doc_cd not in (SELECT clm_doc_cd FROM gicl_reqd_docs WHERE CLAIM_ID = P_CLAIM_ID)
                   AND (UPPER (clm_doc_desc) LIKE NVL (UPPER (p_find_text), '%%')
                    OR  UPPER (clm_doc_cd) LIKE NVL (UPPER (p_find_text), '%%') )
                )
      LOOP
         v_clm_docs.clm_doc_cd := i.clm_doc_cd;
         v_clm_docs.clm_doc_desc := i.clm_doc_desc;
         PIPE ROW (v_clm_docs);
      END LOOP;
   END;
END;
/


