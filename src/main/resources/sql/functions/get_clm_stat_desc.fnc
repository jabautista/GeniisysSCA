DROP FUNCTION CPI.GET_CLM_STAT_DESC;

CREATE OR REPLACE FUNCTION CPI.Get_Clm_Stat_Desc (p_stat_cd IN giis_clm_stat.clm_stat_cd%TYPE)
                  RETURN VARCHAR2 AS
/* Created by Pia 12/01/01.
** Return clm_stat_desc, using clm_stat_cd; where clm_stat_desc is not ** a base-table item. */
CURSOR c1 (p_stat_cd IN giis_clm_stat.clm_stat_cd%TYPE) IS
   SELECT a.clm_stat_desc
     FROM giis_clm_stat a
    WHERE a.clm_stat_cd = p_stat_cd;
 p_stat_desc  giis_clm_stat.clm_stat_desc%TYPE;
BEGIN
  OPEN c1 (p_stat_cd);
  FETCH c1 INTO p_stat_desc;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_stat_desc;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


