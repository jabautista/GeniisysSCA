DROP PROCEDURE CPI.CONFIRM_PRINTING_GIACS154;

CREATE OR REPLACE PROCEDURE CPI.CONFIRM_PRINTING_GIACS154 (
    p_tran_id           GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
    p_comm_slip_pref    GIAC_COMM_SLIP_EXT.comm_slip_pref%TYPE,
    p_comm_slip_no      GIAC_COMM_SLIP_EXT.comm_slip_no%TYPE,
    p_comm_slip_date    GIAC_COMM_SLIP_EXT.comm_slip_date%TYPE
) IS
    v_doc_seq   VARCHAR2(1);
BEGIN
   /*
   **   Created By:     D.Alcantara
   **   Date Created:   03/24/2011
   **   Description:    Updates giac_comm_slip_ext and  giac_doc_sequence if 
   **                   comm slip printing is successful
   */
   UPDATE giac_comm_slip_ext
     SET comm_slip_flag = 'P',
         comm_slip_pref = p_comm_slip_pref,
         comm_slip_no = p_comm_slip_no,
         comm_slip_date = p_comm_slip_date
   WHERE gacc_tran_id  = p_tran_id
         AND comm_slip_tag = 'Y';
     
   FOR doc IN (SELECT param_value_v
                FROM giac_parameters
             WHERE param_name = 'CS_PER_USER')
    LOOP
        v_doc_seq := doc.param_value_v;
    END LOOP;
    
   IF v_doc_seq = 'N' THEN
      UPDATE giac_doc_sequence
                   SET doc_seq_no = doc_seq_no + 1                                
           WHERE fund_cd     = (SELECT gibr_gfun_fund_cd
                                   FROM giac_order_of_payts
                                    WHERE gacc_tran_id = p_tran_id)
           AND branch_cd = (SELECT gibr_branch_cd
                                   FROM giac_order_of_payts
                                    WHERE gacc_tran_id = p_tran_id)                                                         
           AND doc_name = 'COMM_SLIP';
    END IF;    
END CONFIRM_PRINTING_GIACS154;
/


