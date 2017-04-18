DROP FUNCTION CPI.GENERATE_DOC_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.generate_doc_seq_no (p_fund_cd    IN VARCHAR2,
                                                p_branch_cd  IN VARCHAR2,
                                                p_doc_cd     IN VARCHAR2,
                                                p_payt_year  IN NUMBER,
                                                p_payt_mm    IN NUMBER)
RETURN NUMBER IS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes generate_doc_seq_no program unit in GICLS043
   **
   */

  v_doc_seq_no   GIAC_PAYT_REQ_SEQ.payt_seq_no%TYPE;
  v_request_id   GIAC_PAYT_REQ_SEQ.request_id%TYPE;

  CURSOR c IS SELECT payt_seq_no + 1
                FROM GIAC_PAYT_REQ_SEQ gprs
               WHERE fund_cd   = p_fund_cd
                 AND branch_cd = p_branch_cd
                 AND doc_cd    = p_doc_cd
                 AND payt_year = p_payt_year
                 AND payt_mm   = p_payt_mm;
BEGIN
  OPEN c;
  FETCH c INTO v_doc_seq_no;
  IF c%FOUND THEN -- 1
    UPDATE GIAC_PAYT_REQ_SEQ gprs
       SET payt_seq_no = v_doc_seq_no
     WHERE fund_cd   = p_fund_cd
       AND branch_cd = p_branch_cd
       AND doc_cd    = p_doc_cd
       AND payt_year = p_payt_year
       AND payt_mm   = p_payt_mm;
  ELSE
    -- B2 --
    /* Added by Marlo
    ** 01272011
    ** To check if the payment request document to be generated exists*/
    DECLARE
        v_exist VARCHAR2(1);
    BEGIN
        SELECT 1
          INTO v_exist
        FROM GIAC_PAYT_REQ_DOCS
       WHERE gibr_gfun_fund_cd = p_fund_cd
         AND gibr_branch_cd    = p_branch_cd
         AND document_cd     = p_doc_cd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             --raise_application_error(-200001,'No data found in GIAC_PAYT_REQ_DOCS.');
             raise_application_error(-20001,'Geniisys Exception#E#No data found in GIAC_PAYT_REQ_DOCS.');  --replaced by jeffdojello 07.14.2014
    END;
      --end of modification 01272011

    BEGIN
      SELECT gprs_request_id_s.NEXTVAL
        INTO v_request_id
        FROM dual;
        v_doc_seq_no := 1;

        INSERT INTO GIAC_PAYT_REQ_SEQ(request_id, fund_cd,
                                      branch_cd, doc_cd,
                                      payt_year,
                                      payt_mm, payt_seq_no)
                               VALUES(v_request_id, p_fund_cd,
                                      p_branch_cd, p_doc_cd,
                                      p_payt_year,
                                      p_payt_mm, v_doc_seq_no);
        IF SQL%NOTFOUND THEN
           --raise_application_error(-200002,'Cannot insert into GIAC_PAYT_REQ_SEQ table. Please contact your DBA.');
           raise_application_error(-20002,'Geniisys Exception#E#Cannot insert into GIAC_PAYT_REQ_SEQ table. Please contact your DBA.'); --replaced by jeffdojello 07.14.2014
        END IF;

    END B2;
  END IF; -- 1
  RETURN v_doc_seq_no;
END generate_doc_seq_no;
/


