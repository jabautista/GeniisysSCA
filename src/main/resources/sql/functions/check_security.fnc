DROP FUNCTION CPI.CHECK_SECURITY;

CREATE OR REPLACE FUNCTION CPI.CHECK_SECURITY(p_module_id   IN  VARCHAR2,
                                          p_user_id     IN  GIIS_USERS.user_id%TYPE)

RETURN GIPI_PARLIST_PKG.parlist_security_tab PIPELINED

/**
** Created by:      Veronica V. Raymundo
** Date Created:    July 6, 2011
** Description :    Function checks user access to modules.
**                  Equivalent to "SECURITY" program unit in FORMS.
**/

AS
  
  v_security              GIPI_PARLIST_PKG.parlist_security_type;
    
BEGIN
    FOR i in (
          SELECT d.line_cd, B.iss_cd
            FROM GIIS_USERS         a
                , GIIS_USER_ISS_CD  b
                , GIIS_MODULES_TRAN c
                , GIIS_USER_LINE    d
           WHERE 1=1
             AND a.user_id  = b.userid
             AND a.user_id   = NVL(p_user_id, USER)
             AND b.tran_cd   = c.tran_cd
             AND c.module_id = p_module_id
             AND d.userid    = b.userid
             AND d.iss_cd    = b.iss_cd
             AND d.tran_cd   = b.tran_cd
          UNION
          SELECT d.line_cd, b.iss_cd
            FROM GIIS_USERS          a
                , GIIS_USER_GRP_DTL  b
                , GIIS_MODULES_TRAN  c
                , GIIS_USER_GRP_LINE d
           WHERE 1=1
             AND a.user_id   = NVL(p_user_id, USER)
             AND a.user_grp  = b.user_grp
             AND b.tran_cd   = c.tran_cd
             AND c.module_id = p_module_id
             AND d.user_grp  = b.user_grp
             AND d.iss_cd    = b.iss_cd
             AND d.tran_cd   = b.tran_cd)
      
  LOOP
        
    v_security.line_cd :=   i.line_cd;
    v_security.iss_cd  :=   i.iss_cd;
            
    PIPE ROW(v_security); 
        
  END LOOP;

END check_security;
/


