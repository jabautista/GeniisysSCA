DROP PROCEDURE CPI.COPY_POL_WPOLWC_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpolwc_2(
    p_old_pol_id     IN  gipi_polwc.policy_id%TYPE,
    p_new_policy_id  IN  gipi_polwc.policy_id%TYPE, 
    p_long          OUT  gipi_polwc.wc_text01%TYPE
)
IS
  CURSOR polwc_cur IS SELECT line_cd,wc_cd,swc_seq_no,print_seq_no,
                             wc_title,wc_text02,wc_text03,wc_text04,wc_text05,
                             wc_text06,wc_text07,wc_text08,wc_text09,wc_text10,
                              wc_text11,wc_text12,wc_text13,wc_text14,wc_text15,
                             wc_text16,wc_text17,
                             wc_remarks,rec_flag,print_sw,change_tag 
                        FROM gipi_polwc
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
  **  Description  : copy_pol_wpolwc program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Warranties and clauses info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  FOR polwc_cur_rec IN polwc_cur LOOP
      SELECT wc_text01
        INTO p_long
        FROM gipi_polwc
       WHERE policy_id = p_old_pol_id AND
             line_cd    = polwc_cur_rec.line_cd AND
             wc_cd    = polwc_cur_rec.wc_cd AND
             swc_seq_no = polwc_cur_rec.swc_seq_no;
      INSERT INTO gipi_polwc
                 (policy_id,line_cd,wc_cd,swc_seq_no,print_seq_no,
                  wc_title,wc_remarks,wc_text01,
                  wc_text02,wc_text03,
                  wc_text04,wc_text05,
                  wc_text06,wc_text07,
                  wc_text08,wc_text09,
                  wc_text10,wc_text11,
                  wc_text12,wc_text13,
                  wc_text14,wc_text15,
                  wc_text16,wc_text17, 
                  rec_flag, print_sw,
                  change_tag) 
           VALUES(p_new_policy_id,polwc_cur_rec.line_cd,
                  polwc_cur_rec.wc_cd,polwc_cur_rec.swc_seq_no,
                  polwc_cur_rec.print_seq_no,polwc_cur_rec.wc_title,
                  polwc_cur_rec.wc_remarks,p_long,
                  polwc_cur_rec.wc_text02,polwc_cur_rec.wc_text03,
                  polwc_cur_rec.wc_text04,polwc_cur_rec.wc_text05,
                  polwc_cur_rec.wc_text06,polwc_cur_rec.wc_text07,
                  polwc_cur_rec.wc_text08,polwc_cur_rec.wc_text09,
                  polwc_cur_rec.wc_text10,polwc_cur_rec.wc_text11,
                  polwc_cur_rec.wc_text12,polwc_cur_rec.wc_text13,
                  polwc_cur_rec.wc_text14,polwc_cur_rec.wc_text15,
                  polwc_cur_rec.wc_text16,polwc_cur_rec.wc_text17,
                  polwc_cur_rec.rec_flag, polwc_cur_rec.print_sw,
                  polwc_cur_rec.change_tag);

  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
END;
/


