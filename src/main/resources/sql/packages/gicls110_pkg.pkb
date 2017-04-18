CREATE OR REPLACE PACKAGE BODY CPI.GICLS110_PKG
AS
   FUNCTION get_line_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN line_tab PIPELINED AS
      v_rec          line_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name 
                  FROM giis_line 
                 WHERE check_user_per_iss_cd2(line_cd, NULL, p_module_id, p_user_id) = 1
                   AND (UPPER(line_cd) LIKE NVL(UPPER(p_keyword), '%')
                        OR UPPER(line_name) LIKE NVL(UPPER(p_keyword), '%'))
                 ORDER BY line_cd, line_name)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         
         PIPE ROW(v_rec);
      END LOOP;
   END;
   
   FUNCTION get_subline_lov(
      p_line_cd      giis_subline.line_cd%TYPE,
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN subline_tab PIPELINED AS
      v_rec          subline_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name 
                  FROM giis_subline 
                 WHERE line_cd = p_line_cd
                   AND (UPPER(subline_cd) LIKE NVL(UPPER(p_keyword), '%')
                        OR UPPER(subline_name) LIKE NVL(UPPER(p_keyword), '%'))
                 ORDER BY subline_cd, subline_name)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         
         PIPE ROW(v_rec);
      END LOOP;
   END;
   
   FUNCTION get_clm_docs_list(
      p_line_cd      gicl_clm_docs.line_cd%TYPE,
      p_subline_cd   gicl_clm_docs.subline_cd%TYPE
   ) RETURN clm_docs_tab PIPELINED AS
      v_rec          clm_docs_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_clm_docs
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                 ORDER BY priority_cd, clm_doc_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.dsp_clm_doc_cd := i.clm_doc_cd;
         v_rec.clm_doc_desc := i.clm_doc_desc;
         v_rec.priority_cd := i.priority_cd;
         v_rec.clm_doc_remark := i.clm_doc_remark;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW(v_rec);
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec gicl_clm_docs%ROWTYPE) IS
      v_clm_doc_cd   gicl_clm_docs.clm_doc_cd%TYPE;    
   BEGIN
      IF p_rec.clm_doc_cd IS NULL THEN
         SELECT NVL(MAX(TO_NUMBER(clm_doc_cd)),0) + 1
           INTO v_clm_doc_cd
           FROM gicl_clm_docs
          WHERE line_cd = p_rec.line_cd
            AND subline_cd = p_rec.subline_cd;
      END IF;

      MERGE INTO gicl_clm_docs
         USING DUAL
         ON (line_cd = p_rec.line_cd
             AND subline_cd = p_rec.subline_cd
             AND clm_doc_cd = p_rec.clm_doc_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, subline_cd, clm_doc_cd, clm_doc_desc, 
                    clm_doc_remark, user_id, last_update, priority_cd)
            VALUES (p_rec.line_cd, p_rec.subline_cd, v_clm_doc_cd, p_rec.clm_doc_desc, 
                    p_rec.clm_doc_remark, p_rec.user_id, p_rec.last_update, p_rec.priority_cd)
         WHEN MATCHED THEN
            UPDATE
               SET clm_doc_desc = p_rec.clm_doc_desc, 
                   clm_doc_remark = p_rec.clm_doc_remark,
                   priority_cd = p_rec.priority_cd,
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE;
   END;
   
   PROCEDURE val_delete_rec (
      p_line_cd      gicl_clm_docs.line_cd%TYPE,
      p_subline_cd   gicl_clm_docs.subline_cd%TYPE,
      p_clm_doc_cd   gicl_clm_docs.clm_doc_cd%TYPE
   ) AS
   BEGIN
      FOR i IN (SELECT '1' 
                  FROM gicl_clm_req_docs
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND clm_doc_cd = p_clm_doc_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GICL_CLM_DOCS while dependent record(s) in GICL_CLM_REQ_DOCS exists.'); 
      END LOOP; 
   END;

   PROCEDURE del_rec(p_rec gicl_clm_docs%ROWTYPE) AS
   BEGIN
      DELETE FROM gicl_clm_docs
            WHERE line_cd = p_rec.line_cd
              AND subline_cd = p_rec.subline_cd
              AND clm_doc_cd = p_rec.clm_doc_cd;
   END;
END;
/


