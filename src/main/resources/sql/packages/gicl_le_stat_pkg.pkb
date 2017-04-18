CREATE OR REPLACE PACKAGE BODY CPI.GICL_LE_STAT_PKG AS
  
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 01.27.2012
    **  Reference By  : GICLS030 - Loss/Recovery History
    **  Description   : Get all records of gicl_le_stat
    **                  
    */   
  
      FUNCTION get_all_gicl_le_stat(p_keyword IN VARCHAR)
        RETURN gicl_le_stat_tab PIPELINED AS
        
        le_stat           gicl_le_stat_type;
        
      BEGIN
        FOR i IN (SELECT a.le_stat_cd, a.le_stat_desc,
                         a.remarks, a.user_id, a.last_update
                  FROM GICL_LE_STAT a
                  WHERE UPPER(a.le_stat_cd) LIKE UPPER(NVL(p_keyword, a.le_stat_cd))
                     OR UPPER(a.le_stat_desc) LIKE UPPER(NVL(p_keyword, a.le_stat_desc))
                  ORDER BY le_stat_desc)
        
        LOOP
            le_stat.le_stat_cd   := i.le_stat_cd;
            le_stat.le_stat_desc := i.le_stat_desc;
            le_stat.remarks      := i.remarks;
            le_stat.user_id      := i.user_id;
            le_stat.last_update  := i.last_update;
            PIPE ROW(le_stat);
        END LOOP;
      
      END;

END GICL_LE_STAT_PKG;
/


