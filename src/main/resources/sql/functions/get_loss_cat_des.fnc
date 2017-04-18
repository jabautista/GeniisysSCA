DROP FUNCTION CPI.GET_LOSS_CAT_DES;

CREATE OR REPLACE FUNCTION CPI.Get_Loss_Cat_Des
                           (p_cat_cd  IN giis_loss_ctgry.loss_cat_cd%TYPE,
                            p_line_cd IN giis_loss_ctgry.line_cd%TYPE)
                  RETURN VARCHAR2 AS
/* Created by Pia 09/20/02.
** Return loss_cat_des, using line_cd and loss_cat_cd;
** where loss_cat_des is not a base-table item. */
CURSOR c1 (p_cat_cd IN giis_loss_ctgry.loss_cat_cd%TYPE,
           p_line_cd IN giis_loss_ctgry.line_cd%TYPE) IS
   SELECT loss_cat_des
     FROM giis_loss_ctgry
    WHERE line_cd = p_line_cd
      AND loss_cat_cd = p_cat_cd;
 p_cat_des  giis_loss_ctgry.loss_cat_des%TYPE;
BEGIN
  OPEN c1 (p_cat_cd, p_line_cd);
  FETCH c1 INTO p_cat_des;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_cat_des;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


