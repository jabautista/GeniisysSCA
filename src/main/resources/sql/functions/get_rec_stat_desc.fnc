DROP FUNCTION CPI.GET_REC_STAT_DESC;

CREATE OR REPLACE FUNCTION CPI.Get_Rec_Stat_Desc(p_rec_stat_cd IN giis_recovery_status.rec_stat_cd%TYPE)
                  RETURN VARCHAR2 AS
 p_stat_desc  giis_recovery_status.rec_stat_desc%TYPE;
BEGIN
 p_stat_desc := NULL;
 FOR i IN (SELECT rec_stat_desc
        FROM giis_recovery_status
       WHERE rec_stat_cd = p_rec_stat_cd) LOOP
     p_stat_desc := i.rec_stat_desc;
 END LOOP;
 RETURN(p_stat_desc);
END;
/


