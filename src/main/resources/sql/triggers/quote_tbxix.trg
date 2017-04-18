DROP TRIGGER CPI.QUOTE_TBXIX;

CREATE OR REPLACE TRIGGER CPI.QUOTE_TBXIX
BEFORE INSERT
ON CPI.GIPI_QUOTE FOR EACH ROW
DECLARE
        p_exist       VARCHAR2(1)  := 'N';
        P_QUOTATION_NO  NUMBER  := 999999;
  BEGIN
    p_exist  := 'N';
     IF (:NEW.proposal_no = 0) THEN
       FOR quote_no IN (
         SELECT  quotation_no ,ROWID
              FROM  GIIS_QUOTATION_NO
             WHERE  line_cd        =  :NEW.line_cd
               AND  subline_cd     =  :NEW.subline_cd
               AND  iss_cd         =  :NEW.iss_cd
               AND  quotation_yy   =  :NEW.quotation_yy
              FOR UPDATE OF quotation_no)
       LOOP
         IF quote_no.quotation_no < P_QUOTATION_NO THEN
           :NEW.quotation_no := quote_no.quotation_no + 1;
           UPDATE  GIIS_QUOTATION_NO
              SET  quotation_no = :NEW.quotation_no
            WHERE  ROWID        = quote_no.ROWID;
           p_exist := 'Y';
         ELSE
           :NEW.quotation_no := 1;
           UPDATE  GIIS_QUOTATION_NO
              SET  quotation_no = 1
            WHERE  ROWID        = quote_no.ROWID;
           p_exist := 'Y';
         END IF;
       END LOOP;
       IF p_exist = 'N' THEN
          :NEW.quotation_no := 1;
          INSERT INTO GIIS_QUOTATION_NO
             (LINE_CD,SUBLINE_CD,ISS_CD,QUOTATION_YY,QUOTATION_NO)
          VALUES (:NEW.line_cd,:NEW.subline_cd,:NEW.iss_cd,:NEW.quotation_yy,
                  :NEW.quotation_no);
       END IF;
     END IF;
     IF ((:NEW.quotation_no IS NULL) AND (:NEW.proposal_no != 0)) THEN
         RAISE_APPLICATION_ERROR(-20005,'Cannot create new QUOTATION with proposal not equal to zero.');
     END IF;
  END;
/


