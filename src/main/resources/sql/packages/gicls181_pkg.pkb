CREATE OR REPLACE PACKAGE BODY CPI.GICLS181_PKG
AS
   FUNCTION get_documents_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN documents_tab PIPELINED IS 
      v_rec          documents_type;
   BEGIN
      FOR i IN (SELECT report_id, report_name, remarks, user_id, last_update,
                       report_no, line_cd, document_tag, branch_cd, document_cd
                  FROM giac_documents
                 WHERE check_user_per_iss_cd2(line_cd, branch_cd, p_module_id, p_user_id) = 1
                   AND (UPPER(report_id) LIKE NVL(UPPER(p_keyword),'%')
                        OR UPPER(report_name) LIKE NVL(UPPER(p_keyword),'%')
                        OR report_no LIKE NVL(UPPER(p_keyword),'%'))
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
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_rep_signatory_list(
      p_report_id    giac_rep_signatory.report_id%TYPE,
      p_report_no    giac_rep_signatory.report_no%TYPE
   ) RETURN rep_signatory_tab PIPELINED AS
      v_rec          rep_signatory_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_rep_signatory
                 WHERE report_id = p_report_id
                   AND report_no = p_report_no)
      LOOP
         v_rec.report_id := i.report_id;
         v_rec.item_no := i.item_no;
         v_rec.label := i.label;
         v_rec.signatory_id := i.signatory_id;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.sname_flag := i.sname_flag;
         v_rec.report_no := i.report_no;
         
         FOR sig IN (SELECT signatory, designation
                       FROM giis_signatory_names
                      WHERE signatory_id = i.signatory_id)
         LOOP
            v_rec.signatory := sig.signatory;
            v_rec.designation := sig.designation;
         END LOOP;
         
         FOR line IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = (SELECT line_cd
                                          FROM giac_documents
                                         WHERE report_id = p_report_id
                                           AND report_no = p_report_no))
         LOOP
            v_rec.line_name := line.line_name;
         END LOOP;
         
         FOR branch IN (SELECT iss_name
	 		                 FROM giis_issource
	                      WHERE iss_cd = (SELECT branch_cd
                                           FROM giac_documents
                                          WHERE report_id = p_report_id
                                            AND report_no = p_report_no))
         LOOP
            v_rec.branch_name := branch.iss_name;
         END LOOP;
         
         FOR doc IN (SELECT DISTINCT document_name
	 		              FROM giac_payt_req_docs  
	                   WHERE document_cd = (SELECT document_cd
                                             FROM giac_documents
                                            WHERE report_id = p_report_id
                                              AND report_no = p_report_no))
         LOOP
            v_rec.document_name := doc.document_name;
         END LOOP;
         
         v_rec.readonly := 'Y';
         
         PIPE ROW(v_rec);
      END LOOP;
   END;
   
   FUNCTION get_signatory_lov(p_keyword VARCHAR2)
   RETURN rep_signatory_tab PIPELINED AS
      v_list         rep_signatory_type;
   BEGIN
      FOR i IN (SELECT signatory_id, signatory, designation 
                  FROM giis_signatory_names
                 WHERE status = 1
                   AND (signatory_id LIKE NVL(p_keyword, '%')
                        OR UPPER(signatory) LIKE NVL(UPPER(p_keyword), '%')
                        OR UPPER(designation) LIKE NVL(UPPER(p_keyword), '%'))
                 ORDER BY signatory)
      LOOP
         v_list.signatory_id := i.signatory_id;
         v_list.signatory := i.signatory;
         v_list.designation := i.designation;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   PROCEDURE val_add_rec(
      p_report_id    giac_rep_signatory.report_id%TYPE,
      p_item_no      giac_rep_signatory.item_no%TYPE,
      p_report_no    giac_rep_signatory.report_no%TYPE
   ) AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_rep_signatory
                 WHERE report_id = p_report_id
                   AND item_no = p_item_no
                   AND report_no = p_report_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same item_no.'
                                 );
      END IF;
   END;

   PROCEDURE set_rec (p_rec giac_rep_signatory%ROWTYPE) IS
   BEGIN
      MERGE INTO giac_rep_signatory
         USING DUAL
         ON (report_no = p_rec.report_no
             AND report_id = p_rec.report_id
             AND item_no = p_rec.item_no)
         WHEN NOT MATCHED THEN
            INSERT (report_id, item_no, label, signatory_id, 
                    remarks, user_id, last_update, report_no)
            VALUES (p_rec.report_id, p_rec.item_no, p_rec.label, p_rec.signatory_id, 
                    p_rec.remarks, p_rec.user_id, p_rec.last_update, p_rec.report_no)
         WHEN MATCHED THEN
            UPDATE
               SET label = p_rec.label, 
                   signatory_id = p_rec.signatory_id, 
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE;
   END;

   PROCEDURE del_rec(p_rec giac_rep_signatory%ROWTYPE) AS
   BEGIN
      DELETE FROM giac_rep_signatory
            WHERE report_no = p_rec.report_no
              AND report_id = p_rec.report_id
              AND item_no = p_rec.item_no;
   END;
END;
/


