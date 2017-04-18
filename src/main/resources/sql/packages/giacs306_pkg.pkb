CREATE OR REPLACE PACKAGE BODY CPI.giacs306_pkg
AS
   FUNCTION get_rec_list (
      p_fund_cd         giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd       giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd     giac_payt_req_docs.document_cd%TYPE,
      p_document_name   giac_payt_req_docs.document_name%TYPE,
      p_line_cd_tag     giac_payt_req_docs.line_cd_tag%TYPE,
      p_yy_tag          giac_payt_req_docs.yy_tag%TYPE,
      p_mm_tag          giac_payt_req_docs.mm_tag%TYPE,
      p_purchase_tag    giac_payt_req_docs.purchase_tag%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.doc_id, a.document_cd, a.document_name, a.line_cd_tag, a.yy_tag,
                         a.mm_tag, a.purchase_tag, a.remarks, a.user_id, a.last_update
                    FROM giac_payt_req_docs a
                   WHERE UPPER (a.document_cd) LIKE UPPER (NVL (p_document_cd, '%'))
                     AND UPPER (a.document_name) LIKE UPPER (NVL (p_document_name, '%'))                      
                     AND UPPER (NVL(a.purchase_tag, 'N')) LIKE UPPER (NVL (p_purchase_tag, '%'))
                     AND UPPER (a.line_cd_tag) LIKE UPPER (NVL (p_line_cd_tag, '%'))
                     AND UPPER (a.yy_tag) LIKE UPPER (NVL (p_yy_tag, '%'))
                     AND UPPER (a.mm_tag) LIKE UPPER (NVL (p_mm_tag, '%'))
                     AND a.gibr_gfun_fund_cd = p_fund_cd
                     AND a.gibr_branch_cd = p_branch_cd
                ORDER BY document_cd)
      LOOP
         v_rec.doc_id := i.doc_id;
         v_rec.document_cd := i.document_cd;
         v_rec.document_name := i.document_name;
         v_rec.line_cd_tag := i.line_cd_tag;
         v_rec.yy_tag := i.yy_tag;
         v_rec.mm_tag := i.mm_tag;
         v_rec.purchase_tag := nvl(i.purchase_tag, 'N');
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_payt_req_docs%ROWTYPE)
   IS
      v_rec_id   giac_payt_req_docs.doc_id%TYPE;
   BEGIN
      IF p_rec.doc_id IS NULL
      THEN
         SELECT gprd_document_id_s.NEXTVAL
           INTO v_rec_id
           FROM DUAL;
      END IF;

      MERGE INTO giac_payt_req_docs
         USING DUAL
         ON (gibr_gfun_fund_cd = p_rec.gibr_gfun_fund_cd
        AND  gibr_branch_cd = p_rec.gibr_branch_cd
        AND  document_cd = p_rec.document_cd)
         WHEN NOT MATCHED THEN
            INSERT (doc_id, gibr_gfun_fund_cd, gibr_branch_cd, document_cd, document_name,
                    line_cd_tag, yy_tag, mm_tag, purchase_tag, remarks, user_id, last_update)
            VALUES (v_rec_id, p_rec.gibr_gfun_fund_cd, p_rec.gibr_branch_cd, p_rec.document_cd,
                    p_rec.document_name, p_rec.line_cd_tag, p_rec.yy_tag, p_rec.mm_tag,
                    p_rec.purchase_tag, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET document_name = p_rec.document_name, line_cd_tag = p_rec.line_cd_tag,
                   yy_tag = p_rec.yy_tag, mm_tag = p_rec.mm_tag, purchase_tag = p_rec.purchase_tag,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giac_payt_req_docs
            WHERE gibr_gfun_fund_cd = p_fund_cd
              AND gibr_branch_cd = p_branch_cd
              AND document_cd = p_document_cd;
   END;

   PROCEDURE val_del_rec (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_payt_req_seq g
                 WHERE g.doc_cd = p_document_cd
                   AND g.fund_cd = p_fund_cd
                   AND g.branch_cd = p_branch_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_PAYT_REQ_DOCS while dependent record(s) in GIAC_PAYT_REQ_SEQ exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_payt_requests g
                 WHERE g.document_cd = p_document_cd
                   AND g.fund_cd = p_fund_cd
                   AND g.branch_cd = p_branch_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_PAYT_REQ_DOCS while dependent record(s) in GIAC_PAYT_REQUESTS exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_payt_req_docs a
                 WHERE a.document_cd = p_document_cd
                   AND a.gibr_branch_cd = p_branch_cd
                   AND a.gibr_gfun_fund_cd = p_fund_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Row already exists with the same gibr_gfun_fund_cd, gibr_branch_cd, document_cd.'
                                 );
      END IF;
   END;
END;
/


