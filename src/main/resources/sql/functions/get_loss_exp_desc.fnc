DROP FUNCTION CPI.GET_LOSS_EXP_DESC;

CREATE OR REPLACE FUNCTION CPI.Get_Loss_Exp_Desc
                           (p_line_cd IN giis_loss_exp.line_cd%TYPE,
          p_le_cd   IN giis_loss_exp.loss_exp_cd%TYPE)
                  RETURN VARCHAR2 AS
/* Created by Pia 01/03/03.
** Return loss_exp_desc, using line_cd and loss_exp_cd;
** where loss_exp_desc is not a base-table item. */
CURSOR c1 (p_line_cd IN giis_loss_exp.line_cd%TYPE,
     p_le_cd   IN giis_loss_exp.loss_exp_cd%TYPE) IS
   SELECT loss_exp_desc
     FROM giis_loss_exp
    WHERE line_cd = p_line_cd
      AND loss_exp_cd = p_le_cd;
 p_le_desc  giis_loss_exp.loss_exp_desc%TYPE;
BEGIN
  OPEN c1 (p_line_cd, p_le_cd);
  FETCH c1 INTO p_le_desc;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_le_desc;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


