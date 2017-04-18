DROP PROCEDURE CPI.POPULATE_POLNREP;

CREATE OR REPLACE PROCEDURE CPI.populate_polnrep(
    p_new_par_id    gipi_wpolnrep.par_id%TYPE,
    p_old_pol_id    gipi_wpolnrep.old_policy_id%TYPE,
    p_user          gipi_wpolnrep.user_id%TYPE
) 
IS
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : populate_polnrep program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Inserting policy''s renewal/replacement info ...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  
  INSERT INTO gipi_wpolnrep
             (par_id,         old_policy_id,    rec_flag,
              user_id,        last_update,      ren_rep_sw)
       VALUES(p_new_par_id,   p_old_pol_id,     'A',
              p_user,         sysdate,          '1');
END;
/


