CREATE OR REPLACE PACKAGE BODY CPI.giis_adjuster_pkg
AS

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  11.04.2011 
    **  Reference By : (GICLS010 - Basic Info) 
    **  Description :  
    */
    FUNCTION check_priv_adj_exist(p_adj_company_cd  giis_adjuster.adj_company_cd%TYPE)
    RETURN VARCHAR2 IS
      v_exist       VARCHAR2(1) := 'N';
    BEGIN
        FOR priv IN
          (SELECT a.priv_adj_cd
             FROM giis_adjuster a
            WHERE a.adj_company_cd = p_adj_company_cd)
        LOOP
          v_exist := 'Y';
          EXIT;
        END LOOP;
      RETURN (v_exist);  
    END;
     
END giis_adjuster_pkg;
/


