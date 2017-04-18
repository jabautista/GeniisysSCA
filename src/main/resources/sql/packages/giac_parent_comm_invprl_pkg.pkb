CREATE OR REPLACE PACKAGE BODY CPI.GIAC_PARENT_COMM_INVPRL_PKG AS
/**
* Rey Jadlocon
* 08.08.2011
* get the commission details
**/
FUNCTION get_commission_details(p_iss_cd      giac_parent_comm_invprl.iss_cd%TYPE,
                                p_prem_seq_no giac_parent_comm_invprl.prem_seq_no%TYPE,
                                p_intm_no     giac_parent_comm_invprl.intm_no%TYPE,
                                p_peril_cd    giis_peril.peril_cd%TYPE,
                                p_line_cd     giis_peril.line_cd%TYPE)
                RETURN commission_details_tab PIPELINED
              IS 
                v_commission_details commission_details_type;
         BEGIN
              FOR i IN(SELECT *
                         FROM (SELECT c.peril_name,a.commission_rt prnt_detail_rt, a.commission_amt prnt_detail_amt, b.commission_rt comm_detail_rt, b.commission_amt comm_detail_amt, b.policy_id,
                                      b.commission_rt-a.commission_rt child_comm_rt,b.commission_amt-a.commission_amt child_comm_amt
                                 FROM giac_parent_comm_invprl a, gipi_comm_inv_peril b, giis_peril c
                                WHERE a.iss_cd = b.iss_cd
                                  AND a.prem_seq_no = b.prem_seq_no
                                  AND a.chld_intm_no = b.intrmdry_intm_no
                                  AND a.peril_cd = b.peril_cd
                                  AND b.peril_cd = c.peril_cd
                                  AND a.iss_cd = p_iss_cd
                                  AND a.prem_seq_no = p_prem_seq_no
                                  AND a.chld_intm_no = p_intm_no
                                  AND c.peril_cd = p_peril_cd
                                  AND c.line_cd  = p_line_cd))
             LOOP
                v_commission_details.peril_name               := i.peril_name;
                v_commission_details.prnt_detail_rt           := i.prnt_detail_rt;
                v_commission_details.prnt_detail_amt          := i.prnt_detail_amt;
                v_commission_details.child_comm_rt            := i.child_comm_rt;
                v_commission_details.child_comm_amt           := i.child_comm_amt;
                PIPE ROW(v_commission_details);
            END LOOP
            
            RETURN;
 END get_commission_details;
 
END GIAC_PARENT_COMM_INVPRL_PKG;
/


