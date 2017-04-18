DROP TRIGGER CPI.GIIS_DEDUCTIBLE_DESC_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIIS_DEDUCTIBLE_DESC_TAIUD
AFTER INSERT OR DELETE OR UPDATE
ON CPI.GIIS_DEDUCTIBLE_DESC FOR EACH ROW
DECLARE
BEGIN
  BEGIN
    DECLARE
      v_line_cd          GIIS_LOSS_EXP.line_cd%TYPE         := NVL(:NEW.line_cd, :OLD.line_cd);
      v_subline_cd       GIIS_LOSS_EXP.subline_cd%TYPE      := NVL(:NEW.subline_cd, :OLD.subline_cd);
      v_deductible_cd    GIIS_LOSS_EXP.loss_exp_cd%TYPE     := NVL(:NEW.deductible_cd, :OLD.deductible_cd);
      v_deductible_title GIIS_LOSS_EXP.loss_exp_desc%TYPE   := NVL(:NEW.deductible_title, :OLD.deductible_title);
    BEGIN
      IF UPDATING THEN
        UPDATE GIIS_LOSS_EXP
           SET loss_exp_desc = v_deductible_title
         WHERE line_cd = v_line_cd
           AND subline_cd = v_subline_cd
           AND loss_exp_cd = v_deductible_cd;
     ELSIF INSERTING THEN
       INSERT INTO GIIS_LOSS_EXP(line_cd, subline_cd, loss_exp_cd,
                                 loss_exp_desc, loss_exp_type, user_id, last_update, comp_sw)
                          VALUES(v_line_cd, v_subline_cd, v_deductible_cd,
                                 v_deductible_title, 'L', NVL (giis_users_pkg.app_user, USER), SYSDATE, '-');
     ELSIF DELETING THEN
       DELETE FROM GIIS_LOSS_EXP
        WHERE line_cd = v_line_cd
          AND subline_cd = v_subline_cd
          AND loss_exp_cd = v_deductible_cd;
     END IF;
    END;
  END;
END;
/


