DROP PROCEDURE CPI.COPY_POL_WPACK_LINE_SUBLINE_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpack_line_subline_2(
    p_old_pol_id        gipi_pack_line_subline.policy_id%TYPE,
    p_new_policy_id     gipi_pack_line_subline.policy_id%TYPE
)
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wpack_line_subline program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Covered line packages...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_pack_line_subline
    (policy_id,pack_line_cd,pack_subline_cd,line_cd,remarks)
       SELECT p_new_policy_id,pack_line_cd,pack_subline_cd,
              line_cd,remarks
         FROM gipi_pack_line_subline
        WHERE policy_id = p_old_pol_id;
END;
/


