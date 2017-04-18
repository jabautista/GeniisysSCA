DROP PROCEDURE CPI.COPY_POL_PACK_WPOLGENIN;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_pack_wpolgenin(
    p_old_pol_id    IN  gipi_pack_polgenin.pack_policy_id%TYPE,
    p_msg           OUT VARCHAR2,
    p_new_policy_id IN  gipi_pack_polgenin.pack_policy_id%TYPE,
    p_user          IN  gipi_pack_polgenin.user_id%TYPE
) 
IS  
  /* 
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** created by   : gmi
  ** date  : 060507
  */
  pack_genin_cnt NUMBER:=0;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_pack_wpolgenin program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Package Policy''s general info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  SELECT COUNT(*)
    INTO pack_genin_cnt
    FROM gipi_pack_polgenin
   WHERE pack_policy_id = p_old_pol_id;
  
  IF pack_genin_cnt > 1 THEN
   p_msg := 'General information has more than one record for a single PACK PAR, '||
               'cannot proceed.';
   RETURN;
  END IF;
  
    INSERT INTO gipi_pack_polgenin(
         pack_policy_id, USER_ID, LAST_UPDATE,
         GEN_INFO01,     GEN_INFO02,     GEN_INFO03,     GEN_INFO04,     GEN_INFO05,     GEN_INFO06,     GEN_INFO07, 
         GEN_INFO08,     GEN_INFO09,     GEN_INFO10,     GEN_INFO11,     GEN_INFO12,     GEN_INFO13,     GEN_INFO14, 
         GEN_INFO15,     GEN_INFO16,     GEN_INFO17,     GENIN_INFO_CD,  INITIAL_INFO01, INITIAL_INFO02, INITIAL_INFO03, 
         INITIAL_INFO04, INITIAL_INFO05, INITIAL_INFO06, INITIAL_INFO07, INITIAL_INFO08, INITIAL_INFO09, INITIAL_INFO10, 
         INITIAL_INFO11, INITIAL_INFO12, INITIAL_INFO13, INITIAL_INFO14, INITIAL_INFO15, INITIAL_INFO16, INITIAL_INFO17, 
         ENDT_TEXT01,    ENDT_TEXT02,    ENDT_TEXT03,    ENDT_TEXT04,    ENDT_TEXT05,    ENDT_TEXT06,    ENDT_TEXT07, 
         ENDT_TEXT08,    ENDT_TEXT09,    ENDT_TEXT10,    ENDT_TEXT11,    ENDT_TEXT12,    ENDT_TEXT13,    ENDT_TEXT14, 
         ENDT_TEXT15,    ENDT_TEXT16,    ENDT_TEXT17)          
  SELECT p_new_policy_id, p_user, SYSDATE,
         GEN_INFO01,     GEN_INFO02,     GEN_INFO03,     GEN_INFO04,     GEN_INFO05,     GEN_INFO06,     GEN_INFO07, 
         GEN_INFO08,     GEN_INFO09,     GEN_INFO10,     GEN_INFO11,     GEN_INFO12,     GEN_INFO13,     GEN_INFO14, 
         GEN_INFO15,     GEN_INFO16,     GEN_INFO17,     GENIN_INFO_CD,  INITIAL_INFO01, INITIAL_INFO02, INITIAL_INFO03, 
         INITIAL_INFO04, INITIAL_INFO05, INITIAL_INFO06, INITIAL_INFO07, INITIAL_INFO08, INITIAL_INFO09, INITIAL_INFO10, 
         INITIAL_INFO11, INITIAL_INFO12, INITIAL_INFO13, INITIAL_INFO14, INITIAL_INFO15, INITIAL_INFO16, INITIAL_INFO17, 
         ENDT_TEXT01,    ENDT_TEXT02,    ENDT_TEXT03,    ENDT_TEXT04,    ENDT_TEXT05,    ENDT_TEXT06,    ENDT_TEXT07, 
         ENDT_TEXT08,    ENDT_TEXT09,    ENDT_TEXT10,    ENDT_TEXT11,    ENDT_TEXT12,    ENDT_TEXT13,    ENDT_TEXT14, 
         ENDT_TEXT15,    ENDT_TEXT16,    ENDT_TEXT17
    FROM gipi_pack_polgenin
   WHERE pack_policy_id = p_old_pol_id;       
END copy_pol_pack_wpolgenin;
/


