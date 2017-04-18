DROP TRIGGER CPI.GIAC_PAYT_REQUESTS_TBXIX;

CREATE OR REPLACE TRIGGER CPI.GIAC_PAYT_REQUESTS_TBXIX
BEFORE INSERT
ON CPI.GIAC_PAYT_REQUESTS FOR EACH ROW
DECLARE
    v_exists        VARCHAR2(1) := 'N';
    v_request_id    GIAC_PAYT_REQ_SEQ.request_id%TYPE;
 BEGIN /* BOYET (create) 03-09-2001 */
    /* fund_cd, branch_cd, document_cd should not be null */
    IF :NEW.fund_cd     IS NULL OR
       :NEW.branch_cd   IS NULL OR
       :NEW.document_cd IS NULL THEN
       RAISE_APPLICATION_ERROR(-20101,'CANNOT CREATE NEW REQUEST WITH SOME REQUIRED DATA EQUAL TO NULL.');
    END IF;
    /* check if a record of doc_seq_no is already existing to be incremented
       and used as the new doc_seq_no of the the new record to be inserted   */
    FOR c1 IN (SELECT payt_seq_no + 1 nxt_payt_seq_no
                FROM GIAC_PAYT_REQ_SEQ gprs
               WHERE fund_cd           = :NEW.fund_cd
                 AND branch_cd         = :NEW.branch_cd
                 AND doc_cd            = :NEW.document_cd
                 AND NVL(line_cd, '-') = NVL(:NEW.line_cd, NVL(gprs.line_cd, '-'))
                 AND NVL(payt_year, 0) = NVL(:NEW.doc_year, NVL(gprs.payt_year, 0))
                 AND NVL(payt_mm, 0)   = NVL(:NEW.doc_mm, NVL(gprs.payt_mm, 0))
                 FOR UPDATE
    )LOOP
       :NEW.doc_seq_no := c1.nxt_payt_seq_no;
       v_exists := 'Y';
    END LOOP;
    /* if there exists a sequence number, then update the record with the incremented value */
    IF v_exists = 'Y' THEN
       UPDATE GIAC_PAYT_REQ_SEQ gprs
          SET payt_seq_no = :NEW.doc_seq_no
        WHERE fund_cd           = :NEW.fund_cd
          AND branch_cd         = :NEW.branch_cd
          AND doc_cd            = :NEW.document_cd
          AND NVL(line_cd, '-') = NVL(:NEW.line_cd, NVL(gprs.line_cd, '-'))
          AND NVL(payt_year, 0) = NVL(:NEW.doc_year, NVL(gprs.payt_year, 0))
          AND NVL(payt_mm, 0)   = NVL(:NEW.doc_mm, NVL(gprs.payt_mm, 0));
    ELSE
       /* if a sequence number does not exist, then create a new record for the sequence
          with the value of the sequence starting with 1                                 */
       BEGIN
          SELECT gprs_request_id_s.NEXTVAL
            INTO v_request_id
            FROM dual;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20102,'NO SEQUENCE NUMBER FOR REQUEST_ID FROM DUAL. PLEASE CONTACT SYSTEM ADMINISTRATOR ABOUT THIS.');
       END;
       :NEW.doc_seq_no := 1;
       INSERT INTO GIAC_PAYT_REQ_SEQ(request_id,
                                     fund_cd,
                                     branch_cd,
                                     doc_cd,
                                     line_cd,
                                     payt_year,
                                     payt_mm,
                                     payt_seq_no)
                              VALUES(v_request_id,
                                     :NEW.fund_cd,
                                     :NEW.branch_cd,
                                     :NEW.document_cd,
                                     :NEW.line_cd,
                                     :NEW.doc_year,
                                     :NEW.doc_mm,
                                     :NEW.doc_seq_no);
   END IF;
END;
/


