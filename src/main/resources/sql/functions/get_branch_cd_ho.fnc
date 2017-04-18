DROP FUNCTION CPI.GET_BRANCH_CD_HO;

CREATE OR REPLACE FUNCTION CPI.get_branch_cd_ho(
    p_user_id GIIS_USERS.user_id%TYPE) RETURN VARCHAR2 IS
  v_branch_cd    GIAC_BRANCHES.branch_cd%TYPE;       
  BEGIN
  
    /*
    **  Created by        : d.Alcantara
    **  Date Created     : 01.27.2011
    **  Reference By     : GIACS156 - Branch OR
    **  Description     : Returns the branch_cd based on the current user
    */
    FOR c IN (SELECT grp_iss_cd
              FROM giis_users a,
                   giis_user_grp_hdr b 
             WHERE a.user_grp=b.user_grp
               AND a.user_id= NVL(p_user_id, USER)) 
  LOOP
      v_branch_cd := c.grp_iss_cd;               
    EXIT;
  END LOOP;
  RETURN(v_branch_cd);
END get_branch_cd_ho;
/


