DROP PROCEDURE CPI.POPULATE_PACK_POLNREP2;

CREATE OR REPLACE PROCEDURE CPI.populate_pack_polnrep2(
    p_new_par_id    gipi_pack_polnrep.pack_policy_id%TYPE,
    p_old_pol_id    gipi_pack_polnrep.old_pack_policy_id%TYPE,
    p_new_policy_id gipi_pack_polnrep.new_pack_policy_id%TYPE,
    p_user          gipi_pack_polnrep.user_id%TYPE
) 
IS
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : populate_pack_polnrep2 program unit 
  */
  INSERT INTO gipi_pack_polnrep
             (pack_policy_id,         old_pack_policy_id,    rec_flag, 
              user_id,                last_update,           ren_rep_sw, 
              new_pack_policy_id)
       VALUES(p_new_par_id,   p_old_pol_id,  'A',
              p_user,                   sysdate,               '1',    
              p_new_policy_id);
END;
/


