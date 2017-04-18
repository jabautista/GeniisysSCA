CREATE OR REPLACE PACKAGE BODY CPI.GICLS180_PKG
AS
   FUNCTION get_rec_list(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE
   ) RETURN rec_tab PIPELINED IS 
      v_rec          rec_type;
   BEGIN
      FOR i IN (SELECT report_id, report_name, remarks, user_id, last_update,
                       report_no, line_cd, document_tag, branch_cd, document_cd
                  FROM giac_documents
                 WHERE check_user_per_iss_cd2(line_cd, branch_cd, p_module_id, p_user_id) = 1
                 ORDER BY report_no)                   
      LOOP
         v_rec.report_id := i.report_id;
         v_rec.report_name := i.report_name;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.report_no := i.report_no;
         v_rec.line_cd := i.line_cd;
         v_rec.document_tag := i.document_tag;
         v_rec.branch_cd := i.branch_cd;
         v_rec.document_cd := i.document_cd;

         BEGIN 
            SELECT line_name
              INTO v_rec.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_rec.line_name := NULL;
         END;

         BEGIN 
            SELECT iss_name
              INTO v_rec.branch_name
              FROM giis_issource
             WHERE iss_cd = i.branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_rec.branch_name := NULL;
         END;
         
         BEGIN 
            SELECT DISTINCT document_name
              INTO v_rec.document_name
              FROM giac_payt_req_docs
             WHERE document_cd = i.document_cd
               AND rownum = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_rec.document_name := NULL;
         END;
         
         IF v_rec.branch_cd IS NOT NULL THEN
            v_rec.gicls181_iss := check_user_per_iss_cd2(NULL, v_rec.branch_cd, 'GICLS181', p_user_id);
         ELSE
            v_rec.gicls181_iss := 0;
         END IF;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_documents%ROWTYPE)
   IS
      v_report_no       NUMBER(5);
   BEGIN
      IF p_rec.report_no IS NULL THEN
         SELECT MAX(report_no) + 1
           INTO v_report_no
           FROM giac_documents;
      END IF;
      
      IF v_report_no IS NULL THEN
         v_report_no := 1;
      END IF;
   
      MERGE INTO giac_documents
         USING DUAL
         ON (report_no = p_rec.report_no
             AND report_id = p_rec.report_id)
         WHEN NOT MATCHED THEN
            INSERT (report_id, report_name, remarks, user_id, last_update,
                    report_no, line_cd, document_tag, branch_cd, document_cd)
            VALUES (p_rec.report_id, p_rec.report_name, p_rec.remarks, p_rec.user_id, SYSDATE,
                    v_report_no, p_rec.line_cd, p_rec.document_tag, p_rec.branch_cd, p_rec.document_cd)
         WHEN MATCHED THEN
            UPDATE
               SET report_name = p_rec.report_name, 
                   remarks = p_rec.remarks, 
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE, 
                   line_cd = p_rec.line_cd, 
                   document_tag = p_rec.document_tag, 
                   branch_cd = p_rec.branch_cd, 
                   document_cd = p_rec.document_cd;
   END;

   PROCEDURE del_rec(p_rec giac_documents%ROWTYPE) AS
   BEGIN
      DELETE FROM giac_documents
            WHERE report_no = p_rec.report_no
              AND report_id = p_rec.report_id;
   END;
   
   PROCEDURE val_del_rec(p_report_id giac_rep_signatory.report_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_rep_signatory
                 WHERE report_id = p_report_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIAC_DOCUMENTS while dependent record(s) in GIAC_REP_SIGNATORY exists.'
                                 );
      END IF;
   END;
   
   FUNCTION get_report_lov(
      p_keyword      VARCHAR2
   ) RETURN report_lov_tab PIPELINED AS
      v_list         report_lov_type;
   BEGIN
      FOR i IN (SELECT report_id, report_title 
                  FROM giis_reports
                 WHERE UPPER(report_id) LIKE NVL(UPPER(p_keyword),'%')
                    OR UPPER(report_title) LIKE NVL(UPPER(p_keyword),'%')
                 ORDER BY report_id)
      LOOP
         v_list.report_id := i.report_id;
         v_list.report_title := i.report_title;
         
         PIPE ROW(v_list);
      END LOOP;       
   END;
   
   FUNCTION get_line_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN line_lov_tab PIPELINED AS
      v_list         line_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name 
                  FROM giis_line
                 WHERE check_user_per_iss_cd2(line_cd, null, p_module_id, p_user_id) = 1
                   AND (UPPER(line_cd) LIKE NVL(UPPER(p_keyword),'%')
                        OR UPPER(line_name) LIKE NVL(UPPER(p_keyword),'%'))
                 ORDER BY line_name)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION get_document_lov(
      p_keyword      VARCHAR2
   ) RETURN document_lov_tab PIPELINED AS
      v_list         document_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT document_cd, document_name
                  FROM giac_payt_req_docs
                 WHERE UPPER(document_cd) LIKE NVL(UPPER(p_keyword),'%')
                    OR UPPER(document_name) LIKE NVL(UPPER(p_keyword),'%')
                 ORDER BY document_cd)
      LOOP
         v_list.document_cd := i.document_cd;
         v_list.document_name := i.document_name;
         
         PIPE ROW(v_list);
      END LOOP;       
   END;
      
   FUNCTION get_branch_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN branch_lov_tab PIPELINED AS
      v_list         branch_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name 
                  FROM giis_issource
                 WHERE check_user_per_iss_cd2(null, iss_cd, p_module_id, p_user_id) = 1
                   AND (UPPER(iss_cd) LIKE NVL(UPPER(p_keyword),'%')
                        OR UPPER(iss_name) LIKE NVL(UPPER(p_keyword),'%'))
                 ORDER BY iss_name)
      LOOP
         v_list.branch_cd := i.iss_cd;
         v_list.branch_name := i.iss_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
END;
/


