DROP TRIGGER CPI.QUOTE_TBXIX2;

CREATE OR REPLACE TRIGGER CPI.QUOTE_TBXIX2
BEFORE INSERT
ON CPI.GIPI_QUOTE FOR EACH ROW
DECLARE
        p_exist       varchar2(1)  := 'N';
        P_QUOTATION_NO  NUMBER  := 999999;
  BEGIN
	p_exist  := 'N';
     IF (:new.proposal_no = 0) or (:new.pack_quote_id is not null) THEN
       FOR quote_no IN (
         SELECT  quotation_no ,rowid
              FROM  giis_quotation_no
             WHERE  line_cd        =  :new.line_cd
               AND  subline_cd     =  :new.subline_cd
               AND  iss_cd         =  :new.iss_cd
               AND  quotation_yy   =  :new.quotation_yy
              FOR UPDATE OF quotation_no)
       LOOP
         IF quote_no.quotation_no < P_QUOTATION_NO THEN
           :new.quotation_no := quote_no.quotation_no + 1;
           UPDATE  giis_quotation_no
              SET  quotation_no = :new.quotation_no
            WHERE  rowid        = quote_no.rowid;
           p_exist := 'Y';
         ELSE
           :new.quotation_no := 1;
           UPDATE  giis_quotation_no
              SET  quotation_no = 1
            WHERE  rowid        = quote_no.rowid;
           p_exist := 'Y';
         END IF;
       END LOOP;
       IF p_exist = 'N' THEN
          :new.quotation_no := 1;
          INSERT INTO GIIS_QUOTATION_NO
             (LINE_CD,SUBLINE_CD,ISS_CD,QUOTATION_YY,QUOTATION_NO)
          VALUES (:new.line_cd,:new.subline_cd,:new.iss_cd,:new.quotation_yy,
                  :new.quotation_no);
       END IF;
     END IF;
     IF ((:new.quotation_no IS NULL) AND (:new.proposal_no != 0) AND (:new.pack_quote_id is null)) THEN
         RAISE_APPLICATION_ERROR(-20005,'Cannot create new QUOTATION with proposal not equal to zero.');
     END IF;
  END;
/

ALTER TRIGGER CPI.QUOTE_TBXIX2 DISABLE;


