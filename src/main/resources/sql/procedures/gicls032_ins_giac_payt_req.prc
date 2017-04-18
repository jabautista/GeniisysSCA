DROP PROCEDURE CPI.GICLS032_INS_GIAC_PAYT_REQ;

CREATE OR REPLACE PROCEDURE CPI.gicls032_ins_giac_payt_req (
   p_line_cd         gicl_advice.line_cd%TYPE,
   p_iss_cd          gicl_advice.iss_cd%TYPE,
   p_user_id         gicl_advice.user_id%TYPE,
   p_ref_id    OUT   giac_payt_requests.ref_id%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  2.28.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure procedure from GICLS032 - insert_into_giac_payt_requests
   */
   v_doc_year        NUMBER                               := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));
   v_doc_mm          NUMBER                               := TO_NUMBER (TO_CHAR (SYSDATE, 'MM'));
   v_gouc_ouc_id     giac_oucs.ouc_id%TYPE;
   v_fund_cd         giac_parameters.param_value_v%TYPE;
   v_document_cd     giac_parameters.param_value_v%TYPE;
   v_doc_seq_param   giac_parameters.param_value_v%TYPE;
   v_doc_seq_no      NUMBER;
   v_yy_tag          giac_payt_req_docs.yy_tag%TYPE;
   v_mm_tag          giac_payt_req_docs.mm_tag%TYPE;
BEGIN
   BEGIN
      SELECT gprq_ref_id_s.NEXTVAL
        INTO p_ref_id
        FROM DUAL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'No sequence in dual. Please contact your system administrator.');
   END;

   BEGIN
      FOR a1 IN (SELECT ouc_id
                   FROM giac_oucs
                  WHERE claim_tag = 'Y' AND gibr_branch_cd = p_iss_cd)
      LOOP
         v_gouc_ouc_id := a1.ouc_id;
         EXIT;
      END LOOP;

      IF v_gouc_ouc_id IS NULL
      THEN
         raise_application_error (-20001, 'No department tagged for CSR in GIAC_OUCS');
      END IF;

      v_fund_cd := giacp.v ('FUND_CD');

      IF v_fund_cd IS NULL
      THEN
         raise_application_error (-20001, 'FUND_CD not in GIAC_PARAMETERS');
      END IF;

      v_document_cd := giacp.v ('CLM_PAYT_REQ_DOC');

      IF v_document_cd IS NULL
      THEN
         raise_application_error (-20001, 'CLM_PAYT_REQ_DOC not in GIAC_PARAMETERS');
      END IF;
   END;

-- generate a value for gprq.doc_seq_no.
-- parameter added by judyann 10032001
   BEGIN
      SELECT param_value_v
        INTO v_doc_seq_param
        FROM giac_parameters
       WHERE param_name LIKE 'GEN_DOC_SEQ_NO';

      IF v_doc_seq_param = 'N'
      THEN
         v_doc_seq_no := gicls032_generate_doc_seq_no (v_fund_cd, p_iss_cd, v_document_cd, p_line_cd, v_doc_year, v_doc_mm);

         IF v_doc_seq_no IS NULL
         THEN
            raise_application_error (-20001, 'Document sequence no is not found');
         END IF;

         gicls032_get_numbering_scheme (v_fund_cd, p_iss_cd, v_document_cd, v_yy_tag, v_mm_tag);

         INSERT INTO giac_payt_requests
                     (gouc_ouc_id, ref_id, fund_cd, request_date, branch_cd, document_cd, line_cd, doc_year, doc_mm,
                      doc_seq_no, user_id, last_update, with_dv, create_by
                     )
              VALUES (v_gouc_ouc_id, p_ref_id, v_fund_cd, SYSDATE, p_iss_cd, v_document_cd, p_line_cd, v_doc_year, v_doc_mm,
                      v_doc_seq_no, p_user_id, SYSDATE, 'N', p_user_id
                     );
      ELSIF v_doc_seq_param = 'Y'
      THEN
         gicls032_get_numbering_scheme (v_fund_cd, p_iss_cd, v_document_cd, v_yy_tag, v_mm_tag);

         INSERT INTO giac_payt_requests
                     (gouc_ouc_id, ref_id, fund_cd, request_date, branch_cd, document_cd, line_cd, doc_year, doc_mm,
                      user_id, last_update, with_dv, create_by
                     )
              VALUES (v_gouc_ouc_id, p_ref_id, v_fund_cd, SYSDATE, p_iss_cd, v_document_cd, p_line_cd, v_doc_year, v_doc_mm,
                      p_user_id, SYSDATE, 'N', p_user_id
                     );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'No GEN_DOC_SEQ_NO parameter found in GIAC_PARAMETERS');
   END;

   IF SQL%NOTFOUND
   THEN
      raise_application_error (-20001, 'Cannot insert into GIAC_PAYT_REQUESTS');
   ELSE
      RETURN;
   END IF;
END;
/


