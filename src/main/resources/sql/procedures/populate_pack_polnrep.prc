DROP PROCEDURE CPI.POPULATE_PACK_POLNREP;

CREATE OR REPLACE PROCEDURE CPI.populate_pack_polnrep(
    p_new_par_id    gipi_pack_wpolnrep.pack_par_id%TYPE,
    p_old_pol_id    gipi_pack_wpolnrep.old_pack_policy_id%TYPE,
    p_user          gipi_pack_wpolnrep.user_id%TYPE
) 
IS
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : populate_pack_polnrep program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Inserting package policy''s renewal/replacement info ...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  
  /*BEGIN
    variables.new_par_id := NULL;
    SELECT gipi_pack_parlist_par_id.nextval
      INTO variables.new_par_id
      FROM DUAL;            
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BELL;
        MESSAGE('Cannot generate new PACKAGE PAR ID.',ACKNOWLEDGE);
        RAISE FORM_TRIGGER_FAILURE;
  END;*/
  
  INSERT INTO gipi_pack_wpolnrep
             (pack_par_id,            old_pack_policy_id,    rec_flag,
              user_id,                last_update,           ren_rep_sw)
       VALUES(p_new_par_id,           p_old_pol_id,          'A',
              p_user,                 sysdate,               '1');
END;
/


