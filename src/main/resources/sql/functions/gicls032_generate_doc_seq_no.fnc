DROP FUNCTION CPI.GICLS032_GENERATE_DOC_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.gicls032_generate_doc_seq_no (
   p_fund_cd     IN   VARCHAR2,
   p_branch_cd   IN   VARCHAR2,
   p_doc_cd      IN   VARCHAR2,
   p_line_cd     IN   VARCHAR2,
   p_payt_year   IN   NUMBER,
   p_payt_mm     IN   NUMBER
)
   RETURN NUMBER
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  2.28.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted function from GICLS032 - generate_doc_seq_no
   **
   */
   v_doc_seq_no   NUMBER (6);
   v_request_id   NUMBER (9);

   CURSOR c
   IS
      SELECT payt_seq_no + 1
        FROM giac_payt_req_seq gprs
       WHERE fund_cd = p_fund_cd
         AND branch_cd = p_branch_cd
         AND doc_cd = p_doc_cd
         AND NVL (line_cd, '-') = NVL (p_line_cd, NVL (gprs.line_cd, '-'))
         AND NVL (payt_year, 0) = NVL (p_payt_year, NVL (gprs.payt_year, 0))
         AND NVL (payt_mm, 0) = NVL (p_payt_mm, NVL (gprs.payt_mm, 0));
BEGIN
   OPEN c;

   FETCH c
    INTO v_doc_seq_no;

   IF c%FOUND
   THEN
      UPDATE giac_payt_req_seq gprs
         SET payt_seq_no = v_doc_seq_no
       WHERE fund_cd = p_fund_cd
         AND branch_cd = p_branch_cd
         AND doc_cd = p_doc_cd
         AND NVL (line_cd, '-') = NVL (p_line_cd, NVL (gprs.line_cd, '-'))
         AND NVL (payt_year, 0) = NVL (p_payt_year, NVL (gprs.payt_year, 0))
         AND NVL (payt_mm, 0) = NVL (p_payt_mm, NVL (gprs.payt_mm, 0));
   ELSE
      BEGIN
         SELECT gprs_request_id_s.NEXTVAL
           INTO v_request_id
           FROM DUAL;

         v_doc_seq_no := 1;

         INSERT INTO giac_payt_req_seq
                     (request_id, fund_cd, branch_cd, doc_cd, line_cd, payt_year, payt_mm, payt_seq_no
                     )
              VALUES (v_request_id, p_fund_cd, p_branch_cd, p_doc_cd, p_line_cd, p_payt_year, p_payt_mm, v_doc_seq_no
                     );
      END;
   END IF;

   RETURN v_doc_seq_no;
END;
/


