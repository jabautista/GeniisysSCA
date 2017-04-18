DROP PROCEDURE CPI.POSTING_PROCESS_C;

CREATE OR REPLACE PROCEDURE CPI.posting_process_c(
                  p_par_id           IN  gipi_parlist.par_id%TYPE,
                  p_line_cd          IN  gipi_parlist.line_cd%TYPE,                            
                  p_iss_cd           IN  GIPI_WPOLBAS.iss_cd%TYPE,
                  p_policy_id        IN  GIPI_POLBASIC.policy_id%TYPE,    
                  p_user_id          IN  VARCHAR2, 
                  p_dist_no          OUT giuw_pol_dist.dist_no%TYPE,
                  p_msg_alert        OUT VARCHAR2,
                  p_module_id        giis_modules.module_id%TYPE DEFAULT NULL    
                       )
       IS
  v_msg_alert   VARCHAR2(2000);
  v_dist_no     giuw_pol_dist.dist_no%TYPE;
  v_par_type    gipi_parlist.par_type%TYPE;
  v_affecting   VARCHAR2(2);                    
  v_exist       VARCHAR2(2000);       
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : a part of Posting_process program unit
  */
    /*
    **  Modified by  : Gzelle
    **  Date Created : 09.04.2013
    **  Modification : Added p_module_id parameter to determine if procedure is called from Batch Posting.
    **              If called from Batch Posting, insert error to giis_post_error_log
    */      
  FOR a IN (SELECT par_type
                  FROM gipi_parlist
             WHERE par_id = p_par_id)
  LOOP
    v_par_type := a.par_type;
  END LOOP;                   

  BEGIN
    FOR A IN (SELECT 1
                FROM GIPI_WINVOICE
               WHERE par_id = p_par_id) 
    LOOP
      v_affecting  := 'A';
    END LOOP;
    IF v_affecting IS NULL THEN
      v_affecting := 'N';
    END IF;
  END;
      
  IF v_par_type = 'E' THEN
     IF v_affecting = 'A' THEN
        process_distribution(p_par_id,p_line_cd,p_iss_cd,p_policy_id,p_user_id,v_dist_no,v_msg_alert);    
        --BETH 04112001 to ensure data integrity for distribution tables
           --     for records with TSI or premium not equal to 0 get if it is
           --     tagged as auto_dist or not
           --     -if auto_dist = 'Y' delete existing records in preliminary dist. tables
        --     -if auto_dist = 'N' check if records are existing in all preliminary dist. tables
           FOR A IN (SELECT dist_no, auto_dist
                    FROM giuw_pol_dist
                   WHERE par_id = p_par_id
                     AND (NVL(tsi_amt,0) <> 0 
                      OR NVL(prem_amt, 0) <> 0))
        LOOP
            IF NVL(a.auto_dist, 'N') = 'Y' THEN
                 delete_dist_working_tables(a.dist_no); --delete records in preliminary dist. tables 
            ELSE 
                 validate_existing_working_dist(a.dist_no,p_par_id,p_line_cd,p_iss_cd); -- check for records in preliminary dist. tables
            END IF;
        END LOOP;    
     END IF;
     IF v_msg_alert IS NULL THEN
       copy_pol_wendttext(p_par_id,p_policy_id,v_msg_alert);
     END IF;
     /*BETH 02132001 for tax endorsement update dist_flag to '3'
     **     in table gipi_polbasic which will indicate that it is 
     **     already distributed since this kind of record does not
     **     need distribution
     */
     -- check first for the existence of records in giuw_pol_dist
     FOR A IN (SELECT '1' 
                FROM giuw_pol_dist
               WHERE par_id = p_par_id)
     LOOP
       v_exist := 'Y';
         EXIT;
     END LOOP;
     -- for endt. with no records in table giuw_pol_dist 
     -- check if it is an endorsement of tax
     IF v_exist = 'N' THEN
           FOR B IN (SELECT '1'
                       FROM gipi_wendttext
                      WHERE par_id = p_par_id
                        AND nvl(endt_tax ,'N') = 'Y')
           LOOP
               -- for tax endt. update dist_flag of gipi_polbasic to '3'
             UPDATE gipi_polbasic
             SET dist_flag = '3'
           WHERE policy_id = p_policy_id;
          EXIT;
           END LOOP;
     END IF;      
     --beth 02132001 for records in giuw_pol_dist with 0 tsi_amt, and 0 prem_amt
     --     update dist_flag of table giuw_pol_dist and gipi_polbasic to '3'
     --     which will make it distributed   
 
     FOR A IN (SELECT '1' 
                 FROM giuw_pol_dist a       
                WHERE a.par_id = p_par_id
                  AND NVL(a.tsi_amt,0) = 0 
                  AND NVL(a.prem_amt, 0) = 0
                  /* jhing 11.07.2014 dded condition to check if there are any peril records in the 
                    gipi_witmperl for the par. Records with perils should not be tagged as distributed. */
                  AND NOT EXISTS (
                        SELECT 1 FROM gipi_witmperl b
                            WHERE b.par_id = a.par_id
                    ))             
     LOOP             
       -- update dist_flag to '3' for table giuw_pol_dist and gipi_polbasic
       UPDATE giuw_pol_dist
          SET dist_flag = '3',
              user_id   = p_user_id,    
              last_upd_date =SYSDATE
        WHERE par_id = p_par_id;
       UPDATE gipi_polbasic
          SET dist_flag = '3'
        WHERE policy_id = p_policy_id;
       EXIT;
     END LOOP;    
     
     -- jhing 11.07.2014 added codes to delete working dist records or populate dist working tables of 
     -- endorsements with zero TSI and premium as long as this PAR has peril records
      FOR A IN (SELECT a.dist_no , a.auto_dist
                 FROM giuw_pol_dist a       
                WHERE a.par_id = p_par_id
                  AND NVL(a.tsi_amt,0) = 0 
                  AND NVL(a.prem_amt, 0) = 0
                  AND EXISTS (
                        SELECT 1 FROM gipi_witmperl b
                            WHERE b.par_id = a.par_id
                    ))
      LOOP
            IF NVL(a.auto_dist, 'N') = 'Y' THEN
                 delete_dist_working_tables(a.dist_no); --delete records in preliminary dist. tables if record is already distributed prior to posting
            ELSE 
                 validate_existing_working_dist(a.dist_no,p_par_id,p_line_cd,p_iss_cd); -- check for records in preliminary dist. tables, and populate it if no records are found
            END IF;
      END LOOP;         
     
 ELSE
   
   process_distribution(p_par_id,p_line_cd,p_iss_cd,p_policy_id,p_user_id,v_dist_no,v_msg_alert);
     --BETH 04112001 to ensure data integrity for distribution tables
       --     for records with TSI or premium not equal to 0 get if it is
     --     tagged as auto_dist or not
     --     -if auto_dist = 'Y' delete existing records in preliminary dist. tables
     --     -if auto_dist = 'N' check if records are existing in all preliminary dist. tables
     FOR A IN (SELECT dist_no, auto_dist
                 FROM giuw_pol_dist
                WHERE par_id = p_par_id
                  AND (NVL(tsi_amt,0) <> 0 
                   OR NVL(prem_amt, 0) <> 0))
     LOOP
       IF NVL(a.auto_dist, 'N') = 'Y' THEN
         delete_dist_working_tables(a.dist_no); --delete records in preliminary dist. tables 
       ELSE 
            validate_existing_working_dist(a.dist_no,p_par_id,p_line_cd,p_iss_cd); -- check for records in preliminary dist. tables
       END IF;
     END LOOP;
  END IF;
  --gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);
  --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  IF p_module_id = 'GIPIS207'
  THEN
     gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);    
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);      
  ELSE
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  END IF;
  p_dist_no   := v_dist_no;
END;
/


