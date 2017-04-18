DROP PROCEDURE CPI.GIEXS004_PRE_FORM;

CREATE OR REPLACE PROCEDURE CPI.giexs004_pre_form(
    p_user_id   IN   giis_users.user_id%TYPE,
    p_all_user  OUT  VARCHAR2,
    p_mis       OUT  VARCHAR2,
    p_exist     OUT  VARCHAR2
)
IS
    /*
    **  Created by      : Robert Virrey
    **  Date Created 	: 09.19.2011
	**  Reference By 	: (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
	**  Description 	: This procedure returns value for the variables
	*/
    v_mis	    VARCHAR2(1);
    v_all_user  VARCHAR2(1);
    v_mgr 		VARCHAR2(1);
BEGIN
  FOR a IN (
    SELECT nvl(mgr_sw,'N') mgr,
           nvl(mis_sw,'N') mis,
           nvl(all_user_sw,'N') all_user
      FROM giis_users
     WHERE user_id = p_user_id)
  LOOP
      v_all_user := a.all_user;
      v_mis      := a.mis;
      v_mgr      := a.mgr;
      EXIT;
  END LOOP;

  --v_all_user := 'N'; --added by joanne 06.25.14, default all_user_sw is N --Commented out by Jerome Bautista 03.14.2016 SR 21944

  IF v_all_user = 'Y' THEN --AND (v_mis = 'Y' OR v_mgr = 'Y') THEN
       p_all_user := 'Y';
  ELSE
       p_all_user := 'N';
  END IF;
  IF (v_mis = 'Y' OR v_mgr = 'Y') THEN
       p_mis := 'Y';
  ELSE
       p_mis := 'N';
  END IF;

    FOR b IN (SELECT 1
                FROM GIEX_EXPIRY)
    LOOP
          p_exist  :=  1;
          EXIT;
    END LOOP;

END giexs004_pre_form;
/


