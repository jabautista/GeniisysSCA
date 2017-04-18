DROP PROCEDURE CPI.COPY_POL_WPOLGENIN_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpolgenin_2(
    p_old_pol_id     IN  gipi_polgenin.policy_id%TYPE,
    p_new_policy_id  IN  gipi_polgenin.policy_id%TYPE,
    p_long          OUT  gipi_polgenin.gen_info%TYPE,
    p_msg           OUT  VARCHAR2
)
IS
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wpolgenin program unit 
  */
  p_first_info      gipi_wpolgenin.first_info%TYPE;
  p_user_id         gipi_wpolgenin.user_id%TYPE;
  p_last_update     gipi_wpolgenin.last_update%TYPE;
  
  p_GEN_INFO01      gipi_wpolgenin.GEN_INFO01%TYPE;
  p_GEN_INFO02      gipi_wpolgenin.GEN_INFO02%TYPE;
  p_GEN_INFO03      gipi_wpolgenin.GEN_INFO03%TYPE;
  p_GEN_INFO04      gipi_wpolgenin.GEN_INFO04%TYPE;
  p_GEN_INFO05      gipi_wpolgenin.GEN_INFO05%TYPE;
  p_GEN_INFO06      gipi_wpolgenin.GEN_INFO06%TYPE;
  p_GEN_INFO07      gipi_wpolgenin.GEN_INFO07%TYPE;
  p_GEN_INFO08      gipi_wpolgenin.GEN_INFO08%TYPE;
  p_GEN_INFO09      gipi_wpolgenin.GEN_INFO09%TYPE;
  p_GEN_INFO10      gipi_wpolgenin.GEN_INFO10%TYPE;
  p_GEN_INFO11      gipi_wpolgenin.GEN_INFO11%TYPE;
  p_GEN_INFO12      gipi_wpolgenin.GEN_INFO12%TYPE;
  p_GEN_INFO13      gipi_wpolgenin.GEN_INFO13%TYPE;
  p_GEN_INFO14      gipi_wpolgenin.GEN_INFO14%TYPE;
  p_GEN_INFO15      gipi_wpolgenin.GEN_INFO15%TYPE;
  p_GEN_INFO16      gipi_wpolgenin.GEN_INFO16%TYPE;
  p_GEN_INFO17      gipi_wpolgenin.GEN_INFO17%TYPE; 
  
  p_INITIAL_INFO01      gipi_wpolgenin.INITIAL_INFO01%TYPE;
  p_INITIAL_INFO02      gipi_wpolgenin.INITIAL_INFO02%TYPE;
  p_INITIAL_INFO03      gipi_wpolgenin.INITIAL_INFO03%TYPE;
  p_INITIAL_INFO04      gipi_wpolgenin.INITIAL_INFO04%TYPE;
  p_INITIAL_INFO05      gipi_wpolgenin.INITIAL_INFO05%TYPE;
  p_INITIAL_INFO06      gipi_wpolgenin.INITIAL_INFO06%TYPE;
  p_INITIAL_INFO07      gipi_wpolgenin.INITIAL_INFO07%TYPE;
  p_INITIAL_INFO08      gipi_wpolgenin.INITIAL_INFO08%TYPE;
  p_INITIAL_INFO09      gipi_wpolgenin.INITIAL_INFO09%TYPE;
  p_INITIAL_INFO10      gipi_wpolgenin.INITIAL_INFO10%TYPE;
  p_INITIAL_INFO11      gipi_wpolgenin.INITIAL_INFO11%TYPE;
  p_INITIAL_INFO12      gipi_wpolgenin.INITIAL_INFO12%TYPE;
  p_INITIAL_INFO13      gipi_wpolgenin.INITIAL_INFO13%TYPE;
  p_INITIAL_INFO14      gipi_wpolgenin.INITIAL_INFO14%TYPE;
  p_INITIAL_INFO15      gipi_wpolgenin.INITIAL_INFO15%TYPE;
  p_INITIAL_INFO16      gipi_wpolgenin.INITIAL_INFO16%TYPE;
  p_INITIAL_INFO17      gipi_wpolgenin.INITIAL_INFO17%TYPE;
  
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Policy''s general info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
   BEGIN
    SELECT  gen_info,first_info,user_id,last_update, 
            GEN_INFO01, GEN_INFO02, GEN_INFO03, GEN_INFO04, GEN_INFO05, GEN_INFO06, 
            GEN_INFO07, GEN_INFO08, GEN_INFO09, GEN_INFO10, GEN_INFO11, GEN_INFO12, 
            GEN_INFO13, GEN_INFO14, GEN_INFO15, GEN_INFO16, GEN_INFO17, 
            INITIAL_INFO03, INITIAL_INFO04, INITIAL_INFO05, INITIAL_INFO06, 
            INITIAL_INFO07, INITIAL_INFO08, INITIAL_INFO09, INITIAL_INFO10, 
            INITIAL_INFO11, INITIAL_INFO12, INITIAL_INFO13, INITIAL_INFO14, 
            INITIAL_INFO15, INITIAL_INFO16, INITIAL_INFO17, INITIAL_INFO01, 
            INITIAL_INFO02
      INTO  p_long,p_first_info,p_user_id,p_last_update,
            p_GEN_INFO01, p_GEN_INFO02, p_GEN_INFO03, p_GEN_INFO04, p_GEN_INFO05, p_GEN_INFO06, 
            p_GEN_INFO07, p_GEN_INFO08, p_GEN_INFO09, p_GEN_INFO10, p_GEN_INFO11, p_GEN_INFO12, 
            p_GEN_INFO13, p_GEN_INFO14, p_GEN_INFO15, p_GEN_INFO16, p_GEN_INFO17, 
            p_INITIAL_INFO03, p_INITIAL_INFO04, p_INITIAL_INFO05, p_INITIAL_INFO06, 
            p_INITIAL_INFO07, p_INITIAL_INFO08, p_INITIAL_INFO09, p_INITIAL_INFO10, 
            p_INITIAL_INFO11, p_INITIAL_INFO12, p_INITIAL_INFO13, p_INITIAL_INFO14, 
            p_INITIAL_INFO15, p_INITIAL_INFO16, p_INITIAL_INFO17, p_INITIAL_INFO01, 
            p_INITIAL_INFO02 
      FROM gipi_polgenin
     WHERE policy_id = p_old_pol_id;
     INSERT INTO gipi_polgenin(policy_id,gen_info,first_info,user_id,last_update,
                               GEN_INFO01, GEN_INFO02, GEN_INFO03, GEN_INFO04, GEN_INFO05, GEN_INFO06, 
                                                   GEN_INFO07, GEN_INFO08, GEN_INFO09, GEN_INFO10, GEN_INFO11, GEN_INFO12, 
                                                   GEN_INFO13, GEN_INFO14, GEN_INFO15, GEN_INFO16, GEN_INFO17, 
                                                   INITIAL_INFO03, INITIAL_INFO04, INITIAL_INFO05, INITIAL_INFO06, 
                                                   INITIAL_INFO07, INITIAL_INFO08, INITIAL_INFO09, INITIAL_INFO10, 
                                                   INITIAL_INFO11, INITIAL_INFO12, INITIAL_INFO13, INITIAL_INFO14, 
                                                   INITIAL_INFO15, INITIAL_INFO16, INITIAL_INFO17, INITIAL_INFO01, 
                                                   INITIAL_INFO02)
          VALUES (p_new_policy_id,p_long,p_first_info,user,sysdate,
                          p_GEN_INFO01, p_GEN_INFO02, p_GEN_INFO03, p_GEN_INFO04, p_GEN_INFO05, p_GEN_INFO06, 
                        p_GEN_INFO07, p_GEN_INFO08, p_GEN_INFO09, p_GEN_INFO10, p_GEN_INFO11, p_GEN_INFO12, 
                        p_GEN_INFO13, p_GEN_INFO14, p_GEN_INFO15, p_GEN_INFO16, p_GEN_INFO17,
                        p_INITIAL_INFO03, p_INITIAL_INFO04, p_INITIAL_INFO05, p_INITIAL_INFO06, 
                        p_INITIAL_INFO07, p_INITIAL_INFO08, p_INITIAL_INFO09, p_INITIAL_INFO10, 
                        p_INITIAL_INFO11, p_INITIAL_INFO12, p_INITIAL_INFO13, p_INITIAL_INFO14, 
                        p_INITIAL_INFO15, p_INITIAL_INFO16, p_INITIAL_INFO17, p_INITIAL_INFO01, 
                        p_INITIAL_INFO02 );
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN TOO_MANY_ROWS THEN
     p_msg := 'General information has more than one record for a single PAR, cannot proceed.';
   END;
END;
/


