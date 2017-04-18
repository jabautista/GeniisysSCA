DROP TRIGGER CPI.PACK_PARLIST_TBXIX;

CREATE OR REPLACE TRIGGER CPI.PACK_PARLIST_TBXIX
BEFORE INSERT
ON CPI.GIPI_PACK_PARLIST FOR EACH ROW
DECLARE
BEGIN
  DECLARE
      p_exist    NUMBER;
      p_par_seq  NUMBER  := 999999;
  BEGIN
         :NEW.underwriter := NVL (giis_users_pkg.app_user, USER);
         IF (:NEW.quote_seq_no = 0) THEN
           FOR A1 IN (
              SELECT   PAR_SEQ_NO,ROWID
                FROM   GIIS_PACK_PAR_SEQ
               WHERE   LINE_CD     =  :NEW.LINE_CD
                 AND   ISS_CD      =  :NEW.ISS_CD
                 AND   PAR_YY      =  :NEW.PAR_YY
                 FOR UPDATE OF PAR_SEQ_NO) LOOP
                 IF A1.PAR_SEQ_NO < p_par_seq  THEN
                    :NEW.par_seq_no  :=  A1.par_seq_no + 1;
                     UPDATE   GIIS_PACK_PAR_SEQ
                        SET   PAR_SEQ_NO  =  :NEW.par_seq_no
                      WHERE   ROWID       =  A1.ROWID;
                     p_exist          :=  1;
                 ELSE
                    :NEW.par_seq_no  :=  1;
                     UPDATE   GIIS_PACK_PAR_SEQ
                        SET   PAR_SEQ_NO  =  :NEW.par_seq_no
                      WHERE   ROWID       =  A1.ROWID;
                     p_exist          :=  1;
                 END IF;
                 EXIT;
            END LOOP;
            IF p_exist IS NULL THEN
                  :NEW.par_seq_no := 1;
                  INSERT INTO GIIS_PACK_PAR_SEQ
                     (LINE_CD,ISS_CD,PAR_YY,PAR_SEQ_NO)
                  VALUES
                     (:NEW.line_cd, :NEW.iss_cd,
                      :NEW.par_yy, 1);
            END IF;
         END IF;
         IF ((:NEW.par_seq_no IS NULL) AND (:NEW.quote_seq_no != 0)) THEN
           RAISE_APPLICATION_ERROR(-20005,'Cannot create new PAR with quote not equal to zero.');
         END IF;
  END;
END;
/


