DROP PROCEDURE CPI.POPULATE_POLGENIN;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_POLGENIN(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wpolgenin.par_id%TYPE,
    p_user             IN  gipi_wpolgenin.user_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  v_policy_id         gipi_polbasic.policy_id%TYPE;
  v_gen_info          gipi_polgenin.gen_info%TYPE;
  v_first_info        gipi_wpolgenin.first_info%TYPE;   
  
  /* added by gmi 08/29/08 */
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
  /* gmi end */
  
  --rg_id               RECORDGROUP;
  rg_count            NUMBER;
  rg_name             VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col              VARCHAR2(50) := rg_name || '.policy_id';
  exist               VARCHAR2(1) := 'N';
  
  v_long              gipi_polgenin.gen_info%TYPE := NULL;
  v_long2             gipi_polgenin.gen_info%TYPE := NULL;
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_POLGENIN program unit 
  */

   GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;      
          FOR INFO IN 
              ( SELECT first_info
                  FROM gipi_polgenin
                 WHERE policy_id = v_policy_id
              ) LOOP
              v_long2 := NULL;
              SELECT gen_info,
                     NVL(GEN_INFO01, p_GEN_INFO01),         NVL(GEN_INFO02, p_GEN_INFO02),                  NVL(GEN_INFO03, p_GEN_INFO03),         NVL(GEN_INFO04, p_GEN_INFO04),         NVL(GEN_INFO05, p_GEN_INFO05), NVL(GEN_INFO06, p_GEN_INFO06),
                     NVL(GEN_INFO07, p_GEN_INFO07),         NVL(GEN_INFO08, p_GEN_INFO08),                  NVL(GEN_INFO09, p_GEN_INFO09),         NVL(GEN_INFO10, p_GEN_INFO10),         NVL(GEN_INFO11, p_GEN_INFO11), NVL(GEN_INFO12, p_GEN_INFO12),
                     NVL(GEN_INFO13, p_GEN_INFO13),         NVL(GEN_INFO14, p_GEN_INFO14),         NVL(GEN_INFO15, p_GEN_INFO15),         NVL(GEN_INFO16, p_GEN_INFO16),         NVL(GEN_INFO17, p_GEN_INFO17),
                     NVL(INITIAL_INFO03, p_INITIAL_INFO03), NVL(INITIAL_INFO04, p_INITIAL_INFO04), NVL(INITIAL_INFO05, p_INITIAL_INFO05), NVL(INITIAL_INFO06, p_INITIAL_INFO06),
                     NVL(INITIAL_INFO07, p_INITIAL_INFO07), NVL(INITIAL_INFO08, p_INITIAL_INFO08), NVL(INITIAL_INFO09, p_INITIAL_INFO09), NVL(INITIAL_INFO10, p_INITIAL_INFO10),
                     NVL(INITIAL_INFO11, p_INITIAL_INFO11), NVL(INITIAL_INFO12, p_INITIAL_INFO12), NVL(INITIAL_INFO13, p_INITIAL_INFO13), NVL(INITIAL_INFO14, p_INITIAL_INFO14),
                     NVL(INITIAL_INFO15, p_INITIAL_INFO15), NVL(INITIAL_INFO16, p_INITIAL_INFO16), NVL(INITIAL_INFO17, p_INITIAL_INFO17), NVL(INITIAL_INFO01, p_INITIAL_INFO01),
                     NVL(INITIAL_INFO02, p_INITIAL_INFO02)
                INTO v_long,
                     p_GEN_INFO01, p_GEN_INFO02, p_GEN_INFO03, p_GEN_INFO04, p_GEN_INFO05, p_GEN_INFO06, 
                     p_GEN_INFO07, p_GEN_INFO08, p_GEN_INFO09, p_GEN_INFO10, p_GEN_INFO11, p_GEN_INFO12, 
                     p_GEN_INFO13, p_GEN_INFO14, p_GEN_INFO15, p_GEN_INFO16, p_GEN_INFO17, 
                     p_INITIAL_INFO03, p_INITIAL_INFO04, p_INITIAL_INFO05, p_INITIAL_INFO06, 
                     p_INITIAL_INFO07, p_INITIAL_INFO08, p_INITIAL_INFO09, p_INITIAL_INFO10, 
                     p_INITIAL_INFO11, p_INITIAL_INFO12, p_INITIAL_INFO13, p_INITIAL_INFO14, 
                     p_INITIAL_INFO15, p_INITIAL_INFO16, p_INITIAL_INFO17, p_INITIAL_INFO01, 
                     p_INITIAL_INFO02
                FROM gipi_polgenin
               WHERE policy_id = v_policy_id;
              v_first_info := NVL(info.first_info, v_first_info);
              v_long := NVL(v_long2, v_long);
              exist := 'Y';
          END LOOP;
     END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;      
          FOR INFO IN 
              ( SELECT first_info
                  FROM gipi_polgenin
                 WHERE policy_id = v_policy_id
              ) LOOP
              v_long2 := NULL;
              SELECT gen_info,
                     NVL(GEN_INFO01, p_GEN_INFO01),         NVL(GEN_INFO02, p_GEN_INFO02),                  NVL(GEN_INFO03, p_GEN_INFO03),         NVL(GEN_INFO04, p_GEN_INFO04),         NVL(GEN_INFO05, p_GEN_INFO05), NVL(GEN_INFO06, p_GEN_INFO06),
                     NVL(GEN_INFO07, p_GEN_INFO07),         NVL(GEN_INFO08, p_GEN_INFO08),                  NVL(GEN_INFO09, p_GEN_INFO09),         NVL(GEN_INFO10, p_GEN_INFO10),         NVL(GEN_INFO11, p_GEN_INFO11), NVL(GEN_INFO12, p_GEN_INFO12),
                     NVL(GEN_INFO13, p_GEN_INFO13),         NVL(GEN_INFO14, p_GEN_INFO14),         NVL(GEN_INFO15, p_GEN_INFO15),         NVL(GEN_INFO16, p_GEN_INFO16),         NVL(GEN_INFO17, p_GEN_INFO17),
                     NVL(INITIAL_INFO03, p_INITIAL_INFO03), NVL(INITIAL_INFO04, p_INITIAL_INFO04), NVL(INITIAL_INFO05, p_INITIAL_INFO05), NVL(INITIAL_INFO06, p_INITIAL_INFO06),
                     NVL(INITIAL_INFO07, p_INITIAL_INFO07), NVL(INITIAL_INFO08, p_INITIAL_INFO08), NVL(INITIAL_INFO09, p_INITIAL_INFO09), NVL(INITIAL_INFO10, p_INITIAL_INFO10),
                     NVL(INITIAL_INFO11, p_INITIAL_INFO11), NVL(INITIAL_INFO12, p_INITIAL_INFO12), NVL(INITIAL_INFO13, p_INITIAL_INFO13), NVL(INITIAL_INFO14, p_INITIAL_INFO14),
                     NVL(INITIAL_INFO15, p_INITIAL_INFO15), NVL(INITIAL_INFO16, p_INITIAL_INFO16), NVL(INITIAL_INFO17, p_INITIAL_INFO17), NVL(INITIAL_INFO01, p_INITIAL_INFO01),
                     NVL(INITIAL_INFO02, p_INITIAL_INFO02)
                INTO v_long,
                     p_GEN_INFO01, p_GEN_INFO02, p_GEN_INFO03, p_GEN_INFO04, p_GEN_INFO05, p_GEN_INFO06, 
                     p_GEN_INFO07, p_GEN_INFO08, p_GEN_INFO09, p_GEN_INFO10, p_GEN_INFO11, p_GEN_INFO12, 
                     p_GEN_INFO13, p_GEN_INFO14, p_GEN_INFO15, p_GEN_INFO16, p_GEN_INFO17, 
                     p_INITIAL_INFO03, p_INITIAL_INFO04, p_INITIAL_INFO05, p_INITIAL_INFO06, 
                     p_INITIAL_INFO07, p_INITIAL_INFO08, p_INITIAL_INFO09, p_INITIAL_INFO10, 
                     p_INITIAL_INFO11, p_INITIAL_INFO12, p_INITIAL_INFO13, p_INITIAL_INFO14, 
                     p_INITIAL_INFO15, p_INITIAL_INFO16, p_INITIAL_INFO17, p_INITIAL_INFO01, 
                     p_INITIAL_INFO02
                FROM gipi_polgenin
               WHERE policy_id = v_policy_id;
              v_first_info := NVL(info.first_info, v_first_info);
              v_long := NVL(v_long2, v_long);
              exist := 'Y';
          END LOOP;
     END LOOP;
   END IF;

  IF exist = 'Y' THEN    
     --CLEAR_MESSAGE;
     --MESSAGE('Copying policy''s general info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE; 
     INSERT INTO gipi_wpolgenin(par_id,gen_info,first_info,user_id,last_update,
                                GEN_INFO01, GEN_INFO02, GEN_INFO03, GEN_INFO04, GEN_INFO05, GEN_INFO06, 
                                GEN_INFO07, GEN_INFO08, GEN_INFO09, GEN_INFO10, GEN_INFO11, GEN_INFO12, 
                                GEN_INFO13, GEN_INFO14, GEN_INFO15, GEN_INFO16, GEN_INFO17, 
                                INITIAL_INFO03, INITIAL_INFO04, INITIAL_INFO05, INITIAL_INFO06, 
                                INITIAL_INFO07, INITIAL_INFO08, INITIAL_INFO09, INITIAL_INFO10, 
                                INITIAL_INFO11, INITIAL_INFO12, INITIAL_INFO13, INITIAL_INFO14, 
                                INITIAL_INFO15, INITIAL_INFO16, INITIAL_INFO17, INITIAL_INFO01, 
                                INITIAL_INFO02)
          VALUES(p_new_par_id,v_long,v_first_info,p_user,sysdate,
                 p_GEN_INFO01, p_GEN_INFO02, p_GEN_INFO03, p_GEN_INFO04, p_GEN_INFO05, p_GEN_INFO06, 
                 p_GEN_INFO07, p_GEN_INFO08, p_GEN_INFO09, p_GEN_INFO10, p_GEN_INFO11, p_GEN_INFO12, 
                 p_GEN_INFO13, p_GEN_INFO14, p_GEN_INFO15, p_GEN_INFO16, p_GEN_INFO17, 
                 p_INITIAL_INFO03, p_INITIAL_INFO04, p_INITIAL_INFO05, p_INITIAL_INFO06, 
                 p_INITIAL_INFO07, p_INITIAL_INFO08, p_INITIAL_INFO09, p_INITIAL_INFO10, 
                 p_INITIAL_INFO11, p_INITIAL_INFO12, p_INITIAL_INFO13, p_INITIAL_INFO14, 
                 p_INITIAL_INFO15, p_INITIAL_INFO16, p_INITIAL_INFO17, p_INITIAL_INFO01, 
                 p_INITIAL_INFO02);
  END IF;        
END;
/


