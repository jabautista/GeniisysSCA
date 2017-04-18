CREATE OR REPLACE PACKAGE CPI.GIAC_PARENT_COMM_INVPRL_PKG AS
/**
* Rey Jadlocon
*08.08.2011
* get the commission details
**/
TYPE commission_details_type IS RECORD(
        peril_name              GIIS_PERIL.PERIL_NAME%TYPE,
        prnt_detail_rt          GIAC_PARENT_COMM_INVPRL.COMMISSION_RT%TYPE,
        prnt_detail_amt         GIAC_PARENT_COMM_INVPRL.COMMISSION_AMT%TYPE,
        child_comm_rt           GIAC_PARENT_COMM_INVPRL.COMMISSION_RT%TYPE,
        child_comm_amt          GIAC_PARENT_COMM_INVPRL.COMMISSION_AMT%TYPE
        );
        TYPE commission_details_tab IS TABLE OF commission_details_type;
        
FUNCTION get_commission_details(p_iss_cd      giac_parent_comm_invprl.iss_cd%TYPE,
                                p_prem_seq_no giac_parent_comm_invprl.prem_seq_no%TYPE,
                                p_intm_no     giac_parent_comm_invprl.intm_no%TYPE,
                                p_peril_cd    giis_peril.peril_cd%TYPE,
                                p_line_cd     giis_peril.line_cd%TYPE)
                                
                RETURN commission_details_tab PIPELINED;
                
END GIAC_PARENT_COMM_INVPRL_PKG;
/


