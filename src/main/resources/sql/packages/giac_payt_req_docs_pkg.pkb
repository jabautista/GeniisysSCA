CREATE OR REPLACE PACKAGE BODY CPI.giac_payt_req_docs_pkg
AS
   /*
   **  Created by   : Jerome Orio
   **  Date Created : 06.05.2012
   **  Reference By : (GIACS016 - Disbursement)
   **  Description  : rg_document_cd_claim record_group
   */
   FUNCTION get_rg_document_cd_claim (
      p_fund_cd     giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_payt_req_docs.gibr_branch_cd%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED
   IS
      v_list   giac_payt_req_docs_type;
   BEGIN
      FOR i IN
         (SELECT gprd.document_cd document_cd /* cg$fk */,
                 gprd.gibr_branch_cd branch_cd,
                 gprd.gibr_gfun_fund_cd fund_cd,
                 gprd.document_name dsp_document_name,
                 gprd.line_cd_tag dsp_line_cd_tag, gprd.yy_tag dsp_yy_tag,
                 gprd.mm_tag dsp_mm_tag
            FROM giac_payt_req_docs gprd
           WHERE gprd.gibr_gfun_fund_cd = p_fund_cd
             AND gprd.gibr_branch_cd = p_branch_cd
             AND gprd.document_cd IN (
                     SELECT param_value_v
                       FROM giac_parameters
                      WHERE param_name IN
                                        ('CLM_PAYT_REQ_DOC', 'BATCH_CSR_DOC','SPECIAL_CSR_DOC'))) --added by steven 09.22.2014
      LOOP
         v_list.document_cd := i.document_cd;
         v_list.gibr_branch_cd := i.branch_cd;
         v_list.gibr_gfun_fund_cd := i.fund_cd;
         v_list.document_name := i.dsp_document_name;
         v_list.line_cd_tag := i.dsp_line_cd_tag;
         v_list.yy_tag := i.dsp_yy_tag;
         v_list.mm_tag := i.dsp_mm_tag;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 06.05.2012
   **  Reference By : (GIACS016 - Disbursement)
   **  Description  : rg_document_cd_non_claim record_group
   */
   FUNCTION get_rg_document_cd_non_claim (
      p_fund_cd      giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd    giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_param_name   giac_parameters.param_value_v%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED
   IS
      v_list   giac_payt_req_docs_type;
   BEGIN
      FOR i IN (SELECT gprd.document_cd document_cd /* cg$fk */,
                       gprd.gibr_branch_cd branch_cd,
                       gprd.gibr_gfun_fund_cd fund_cd,
                       gprd.document_name dsp_document_name,
                       gprd.line_cd_tag dsp_line_cd_tag,
                       gprd.yy_tag dsp_yy_tag, gprd.mm_tag dsp_mm_tag
                  FROM giac_payt_req_docs gprd
                 WHERE gprd.gibr_gfun_fund_cd = p_fund_cd
                   AND gprd.gibr_branch_cd = p_branch_cd
                   AND gprd.document_cd IN (SELECT param_value_v
                                              FROM giac_parameters
                                             WHERE param_name = p_param_name))
      LOOP
         v_list.document_cd := i.document_cd;
         v_list.gibr_branch_cd := i.branch_cd;
         v_list.gibr_gfun_fund_cd := i.fund_cd;
         v_list.document_name := i.dsp_document_name;
         v_list.line_cd_tag := i.dsp_line_cd_tag;
         v_list.yy_tag := i.dsp_yy_tag;
         v_list.mm_tag := i.dsp_mm_tag;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 06.05.2012
   **  Reference By : (GIACS016 - Disbursement)
   **  Description  : rg_document_cd_other record_group
   */
   FUNCTION get_rg_document_cd_other (
      p_fund_cd     giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_payt_req_docs.gibr_branch_cd%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED
   IS
      v_list   giac_payt_req_docs_type;
   BEGIN
      FOR i IN
         (SELECT gprd.document_cd document_cd /* cg$fk */,
                 gprd.gibr_branch_cd branch_cd,
                 gprd.gibr_gfun_fund_cd fund_cd,
                 gprd.document_name dsp_document_name,
                 gprd.line_cd_tag dsp_line_cd_tag, gprd.yy_tag dsp_yy_tag,
                 gprd.mm_tag dsp_mm_tag
            FROM giac_payt_req_docs gprd
           WHERE gprd.gibr_gfun_fund_cd = p_fund_cd
             AND gprd.gibr_branch_cd = p_branch_cd
             AND gprd.document_cd NOT IN (
                    SELECT param_value_v
                      FROM giac_parameters
                     WHERE param_name IN
                              ('CLM_PAYT_REQ_DOC', 'FACUL_RI_PREM_PAYT_DOC',
                               'COMM_PAYT_DOC', 'BATCH_CSR_DOC','SPECIAL_CSR_DOC'))) --added by steven 09.22.2014
      LOOP
         v_list.document_cd := i.document_cd;
         v_list.gibr_branch_cd := i.branch_cd;
         v_list.gibr_gfun_fund_cd := i.fund_cd;
         v_list.document_name := i.dsp_document_name;
         v_list.line_cd_tag := i.dsp_line_cd_tag;
         v_list.yy_tag := i.dsp_yy_tag;
         v_list.mm_tag := i.dsp_mm_tag;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 06.05.2012
   **  Reference By : (GIACS016 - Disbursement)
   **  Description  : rg_document_cd_all record_group
   */
   FUNCTION get_rg_document_cd_all
      RETURN giac_payt_req_docs_tab PIPELINED
   IS
      v_list   giac_payt_req_docs_type;
   BEGIN
      FOR i IN (SELECT gprd.document_cd document_cd /* cg$fk */,
                       gprd.gibr_branch_cd branch_cd,
                       gprd.gibr_gfun_fund_cd fund_cd,
                       gprd.document_name dsp_document_name,
                       gprd.line_cd_tag dsp_line_cd_tag,
                       gprd.yy_tag dsp_yy_tag, gprd.mm_tag dsp_mm_tag
                  FROM giac_payt_req_docs gprd
                 WHERE gprd.document_cd IS NOT NULL)
      LOOP
         v_list.document_cd := i.document_cd;
         v_list.gibr_branch_cd := i.branch_cd;
         v_list.gibr_gfun_fund_cd := i.fund_cd;
         v_list.document_name := i.dsp_document_name;
         v_list.line_cd_tag := i.dsp_line_cd_tag;
         v_list.yy_tag := i.dsp_yy_tag;
         v_list.mm_tag := i.dsp_mm_tag;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : 04.15.2013
   **  Reference By : GIACS002 - Generate Disbursement Voucher
   **  Description  :  Retrieves the tags for line_cd, year, and month
   **                  If any of these (line_cd_tag, yy_tag, mm_tag) = 'Y
   **                  then set their corresponding field/s (dsp_line_cd, dsp_year, dsp_mm)
   **                  to enterable
   */
   --PROCEDURE get_payt_req_numbering_scheme(
   FUNCTION get_payt_req_numbering_scheme (
      p_fund_cd       IN   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     IN   giac_disb_vouchers.gibr_branch_cd%TYPE,
      p_document_cd   IN   giac_payt_requests.document_cd%TYPE
--        p_nbt_line_cd_tag   OUT        giac_payt_req_docs.line_cd_tag%TYPE,
--        p_nbt_yy_tag        OUT        giac_payt_req_docs.yy_tag%TYPE,
--        p_nbt_mm_tag        OUT        giac_payt_req_docs.mm_tag%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED
   IS
--        v_nbt_line_cd_tag   giac_payt_req_docs.line_cd_tag%TYPE;
      v_scheme   giac_payt_req_docs_type;
   BEGIN
      FOR a IN (SELECT line_cd_tag, yy_tag, mm_tag
                  FROM giac_payt_req_docs
                 WHERE gibr_gfun_fund_cd = p_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND document_cd = p_document_cd)
      LOOP
         v_scheme.line_cd_tag := a.line_cd_tag;
         v_scheme.yy_tag := a.yy_tag;
         v_scheme.mm_tag := a.mm_tag;
         PIPE ROW (v_scheme);
--            EXIT;
      END LOOP;
--        p_nbt_line_cd_tag := 'P';--v_nbt_line_cd_tag;
--        p_nbt_yy_tag := 'P';
--        p_nbt_mm_tag := 'P';
   END get_payt_req_numbering_scheme;

   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : 04.16.2013
   **  Reference By : GIACS002 - Generate Disbursement Voucher
   **  Description  :  Retrieves the list of document_cd specified in document_cd record_group
   */
   FUNCTION get_document_cd_list (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_fund_cd     giac_payt_requests.fund_cd%TYPE,
      p_branch_cd   giac_payt_requests.branch_cd%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED
   IS
      v_doc_list   giac_payt_req_docs_type;
   BEGIN
      FOR rec IN
         (SELECT DISTINCT gprq.document_cd, gprd.document_name, gprq.fund_cd,
                          gprq.branch_cd
                     FROM giac_payt_requests gprq,
                          giac_payt_req_docs gprd,
                          giac_payt_requests_dtl grqd
                    WHERE gprq.ref_id = grqd.gprq_ref_id
                      AND gprq.document_cd = gprd.document_cd
                      AND gprq.branch_cd = gprd.gibr_branch_cd
                      AND grqd.payt_req_flag = 'C'
                      /*AND gprd.gibr_branch_cd =
                             DECODE
                                (check_user_per_iss_cd_acctg2
                                                         (NULL,
                                                          gprd.gibr_branch_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ),
                                 1, gprd.gibr_branch_cd,
                                 NULL
                                )*/
                      AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) NOT IN (
                             SELECT gidv.gprq_ref_id, gidv.req_dtl_no,
                                    gidv.gacc_tran_id
                               FROM giac_disb_vouchers gidv
                              WHERE gidv.dv_flag NOT IN ('D', 'C')
                                AND gidv.gprq_ref_id = gprq.ref_id
                                AND gidv.req_dtl_no = grqd.req_dtl_no
                                AND gidv.gacc_tran_id = grqd.tran_id)
                      AND gprq.fund_cd = p_fund_cd
                      /*AND gprq.branch_cd =
                             DECODE
                                (check_user_per_iss_cd_acctg2
                                                         (NULL,
                                                          gprd.gibr_branch_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ),
                                 1, gprq.branch_cd,
                                 NULL
                                )*/
                        AND ((SELECT access_tag
                                FROM giis_user_modules
                               WHERE userid = NVL (p_user_id, USER)
                                 AND module_id = p_module_id
                                 AND tran_cd IN ( SELECT b.tran_cd 
                                                    FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                                   WHERE a.user_id = b.userid
                                                     AND a.user_id = NVL (p_user_id, USER)
                                                     AND b.iss_cd = gprd.gibr_branch_cd
                                                     AND b.tran_cd = c.tran_cd
                                                     AND c.module_id = p_module_id)) = 1
                              OR (SELECT access_tag
                                    FROM giis_user_grp_modules
                                   WHERE module_id = p_module_id
                                     AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                                   WHERE a.user_grp = b.user_grp
                                                                     AND a.user_id = NVL (p_user_id, USER)
                                                                     AND b.iss_cd = gprd.gibr_branch_cd
                                                                     AND b.tran_cd = c.tran_cd
                                                                     AND c.module_id = p_module_id)) = 1
                        )
                      AND gprq.branch_cd = p_branch_cd)
      -- added by Kris 05.10.2013 [PF SR_13021]
      LOOP
         v_doc_list.document_cd := rec.document_cd;
         v_doc_list.document_name := rec.document_name;
         v_doc_list.gibr_gfun_fund_cd := rec.fund_cd;
         v_doc_list.gibr_branch_cd := rec.branch_cd;
         PIPE ROW (v_doc_list);
      END LOOP;
   END get_document_cd_list;

   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : 04.22.2013
   **  Reference By : GIACS002 - Generate Disbursement Voucher
   **  Description  : Execures the WHEN-VALIDATE-ITEM Trigger of dsp_document_cd IN gidv block
   */
   PROCEDURE validate_document_cd (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE
   )
   IS
      CURSOR doc_cd
      IS
         SELECT gprq.document_cd, gprd.document_name
           FROM giac_payt_requests gprq,
                giac_payt_req_docs gprd,
                giac_payt_requests_dtl grqd
          WHERE gprq.ref_id = grqd.gprq_ref_id
            AND gprq.document_cd = gprd.document_cd
            AND grqd.payt_req_flag = 'C'
            AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) NOT IN (
                   SELECT gidv.gprq_ref_id, gidv.req_dtl_no,
                          gidv.gacc_tran_id
                     FROM giac_disb_vouchers gidv
                    WHERE gidv.dv_flag NOT IN ('D', 'C')
                      AND gidv.gprq_ref_id = gprq.ref_id
                      AND gidv.req_dtl_no = grqd.req_dtl_no
                      AND gidv.gacc_tran_id = grqd.tran_id)
            AND gprq.fund_cd = p_fund_cd
            AND gprq.branch_cd = p_branch_cd
            AND gprq.document_cd = p_document_cd;

      v_document_cd     giac_payt_req_docs.document_cd%TYPE;
      v_document_name   giac_payt_req_docs.document_name%TYPE;
   BEGIN
      OPEN doc_cd;

      FETCH doc_cd
       INTO v_document_cd, v_document_name;

      IF doc_cd%NOTFOUND
      THEN
         DECLARE
            v_exists   VARCHAR2 (1) := 'N';
         BEGIN
            FOR a IN (SELECT document_cd, document_name
                        FROM giac_payt_req_docs
                       WHERE document_cd = p_document_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               --msg_alert('There is no Payment Request that has this ' || 'Document Code.', 'I', TRUE);
               raise_application_error
                  (-20001,
                   'Geniisys Exception#imgMessage.INFO#There is no Payment Request that has this Document Code.'
                  );
            ELSE
               --msg_alert('This is an invalid Document Code.', 'I', TRUE);
               raise_application_error
                  (-20001,
                   'Geniisys Exception#imgMessage.INFO#This is an invalid Document Code.'
                  );
            END IF;
         END;
      END IF;

      CLOSE doc_cd;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END validate_document_cd;

   FUNCTION fetch_document_list (
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN giac_payt_req_docs_tab PIPELINED
   AS
      lov   giac_payt_req_docs_type;
   BEGIN
      FOR i IN (SELECT DISTINCT document_cd, document_name
                           FROM giac_payt_req_docs
                          WHERE NVL (p_branch_cd, gibr_branch_cd) =
                                                               gibr_branch_cd
                            AND UPPER (document_cd) LIKE
                                   '%' || UPPER (NVL (p_keyword, document_cd))
                                   || '%'
                       ORDER BY document_cd)
      LOOP
         lov.document_cd := i.document_cd;
         lov.document_name := i.document_name;
         PIPE ROW (lov);
      END LOOP;
   END fetch_document_list;
   
   FUNCTION validate_document_cd2(
        p_document_cd   giac_payt_req_docs.DOCUMENT_CD%type,
        p_branch_cd     giac_payt_req_docs.GIBR_BRANCH_CD%type
    ) RETURN VARCHAR2
    AS
        v_doc_name     giac_payt_req_docs.DOCUMENT_NAME%type;
    BEGIN
        SELECT DISTINCT document_name
          INTO v_doc_name
          FROM giac_payt_req_docs
         WHERE NVL (p_branch_cd, gibr_branch_cd) = gibr_branch_cd
           AND document_cd = p_document_cd;
           
        RETURN (v_doc_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END validate_document_cd2;
   
   
END;
/


