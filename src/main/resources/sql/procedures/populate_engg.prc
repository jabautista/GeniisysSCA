DROP PROCEDURE CPI.POPULATE_ENGG;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ENGG(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wengg_basic.par_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  v_policy_id                 gipi_polbasic.policy_id%TYPE;
  v_engg_basic_infonum        gipi_engg_basic.engg_basic_infonum%TYPE;                 
  v_contract_proj_buss_title  gipi_engg_basic.contract_proj_buss_title%TYPE;           
  v_site_location             gipi_engg_basic.site_location%TYPE;                      
  v_construct_start_date      gipi_engg_basic.construct_start_date%TYPE;               
  v_construct_end_date        gipi_engg_basic.construct_end_date%TYPE;                 
  v_maintain_start_date       gipi_engg_basic.maintain_start_date%TYPE;                
  v_maintain_end_date         gipi_engg_basic.maintain_end_date%TYPE;                  
  v_testing_start_date        gipi_engg_basic.testing_start_date%TYPE;                
  v_testing_end_date          gipi_engg_basic.testing_end_date%TYPE;                  
  v_weeks_test                gipi_engg_basic.weeks_test%TYPE;                         
  v_time_excess               gipi_engg_basic.time_excess%TYPE;                        
  v_mbi_policy_no             gipi_engg_basic.mbi_policy_no%TYPE;                    
  --rg_id                       RECORDGROUP;
  rg_count                    NUMBER;
  rg_name                     VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col                      VARCHAR2(50) := rg_name || '.policy_id';
  item_exist                  VARCHAR2(1) := 'N';
  exist1                      VARCHAR2(1) := 'N';
  
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
  **  Description  : POPULATE_OPEN_POLICY program unit 
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
      FOR engg IN (
          SELECT engg_basic_infonum, contract_proj_buss_title,       
                 site_location,      construct_start_date,           
                 construct_end_date, maintain_start_date,            
                 maintain_end_date,  weeks_test,                     
                 time_excess,        mbi_policy_no,
                 testing_end_date,   testing_start_date                  
            FROM gipi_engg_basic
           WHERE policy_id = v_policy_id)
       LOOP
         exist1 := 'Y';
         v_engg_basic_infonum        := NVL(engg.engg_basic_infonum,v_engg_basic_infonum);                 
         v_contract_proj_buss_title  := NVL(engg.contract_proj_buss_title,v_contract_proj_buss_title);           
         v_site_location             := NVL(engg.site_location,v_site_location);                      
         v_construct_start_date      := NVL(engg.construct_start_date,v_construct_start_date);               
         v_construct_end_date        := NVL(engg.construct_end_date,v_construct_end_date);                 
         v_maintain_start_date       := NVL(engg.maintain_start_date,v_maintain_start_date);            
         v_maintain_end_date         := NVL(engg.maintain_end_date,v_maintain_end_date);                      
         v_testing_end_date          := NVL(engg.testing_end_date,v_testing_end_date);                  
         v_testing_start_date        := NVL(engg.testing_start_date,v_testing_start_date);                
         v_weeks_test                := NVL(engg.weeks_test,v_weeks_test);                         
         v_time_excess               := NVL(engg.time_excess,v_time_excess);                        
         v_mbi_policy_no             := NVL(engg.mbi_policy_no,v_mbi_policy_no);                  
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
      FOR engg IN (
          SELECT engg_basic_infonum, contract_proj_buss_title,       
                 site_location,      construct_start_date,           
                 construct_end_date, maintain_start_date,            
                 maintain_end_date,  weeks_test,                     
                 time_excess,        mbi_policy_no,
                 testing_end_date,   testing_start_date                  
            FROM gipi_engg_basic
           WHERE policy_id = v_policy_id)
       LOOP
         exist1 := 'Y';
         v_engg_basic_infonum        := NVL(engg.engg_basic_infonum,v_engg_basic_infonum);                 
         v_contract_proj_buss_title  := NVL(engg.contract_proj_buss_title,v_contract_proj_buss_title);           
         v_site_location             := NVL(engg.site_location,v_site_location);                      
         v_construct_start_date      := NVL(engg.construct_start_date,v_construct_start_date);               
         v_construct_end_date        := NVL(engg.construct_end_date,v_construct_end_date);                 
         v_maintain_start_date       := NVL(engg.maintain_start_date,v_maintain_start_date);            
         v_maintain_end_date         := NVL(engg.maintain_end_date,v_maintain_end_date);                      
         v_testing_end_date          := NVL(engg.testing_end_date,v_testing_end_date);                  
         v_testing_start_date        := NVL(engg.testing_start_date,v_testing_start_date);                
         v_weeks_test                := NVL(engg.weeks_test,v_weeks_test);                         
         v_time_excess               := NVL(engg.time_excess,v_time_excess);                        
         v_mbi_policy_no             := NVL(engg.mbi_policy_no,v_mbi_policy_no);                  
       END LOOP;
     END LOOP;
   END IF;
      
  IF exist1 = 'Y' THEN
     --CLEAR_MESSAGE;
     --MESSAGE('Copying engineering info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE;
     INSERT INTO gipi_wengg_basic(
                 engg_basic_infonum,   contract_proj_buss_title,       
                 site_location,        construct_start_date,
                 construct_end_date,   maintain_start_date,
                 maintain_end_date,    weeks_test,
                 time_excess,          mbi_policy_no,
                 par_id,               testing_start_date,
                 testing_end_date) 
         VALUES( v_engg_basic_infonum, v_contract_proj_buss_title,       
                 v_site_location,      v_construct_start_date,
                 v_construct_end_date, v_maintain_start_date,
                 v_maintain_end_date,  v_weeks_test,
                 v_time_excess,        v_mbi_policy_no,
                 p_new_par_id,         v_testing_start_date,
                 v_testing_end_date) ;
     POPULATE_PRINCIPAL(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
  END IF; 
END;
/


