DROP PROCEDURE CPI.COPY_POL_WREQDOCS_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wreqdocs_2(
    p_old_pol_id     gipi_reqdocs.policy_id%TYPE,
    p_proc_line_cd   VARCHAR2,
    p_line_su        VARCHAR2,
    p_new_policy_id  gipi_reqdocs.policy_id%TYPE,
    p_user           gipi_reqdocs.user_id%TYPE,
    p_msg        OUT VARCHAR2
)
IS
  CURSOR reqdocs_cur IS SELECT doc_cd,doc_sw,line_cd,
                               date_submitted,user_id,last_update,remarks
                          FROM gipi_reqdocs
                         WHERE policy_id = p_old_pol_id;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wreqdocs program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying required documents info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
 IF p_proc_line_cd = p_line_su THEN
      FOR cur_rec IN REQDOCS_CUR LOOP
             IF cur_rec.doc_sw = 'Y' AND cur_rec.date_submitted IS NULL THEN
               p_msg :='Dates should not be null for required document.';
             END IF;
      END LOOP;        
   END IF;
   
  for REQDOCS_cur_rec in REQDOCS_cur loop
  INSERT INTO gipi_reqdocs(doc_cd,policy_id,doc_sw,line_cd,date_submitted,user_id,
                           last_update,remarks)
       VALUES(reqdocs_cur_rec.doc_cd,p_new_policy_id,reqdocs_cur_rec.doc_sw,
          reqdocs_cur_rec.line_cd,reqdocs_cur_rec.date_submitted,p_user,
              sysdate,reqdocs_cur_rec.remarks);
  end loop;
END;
/


