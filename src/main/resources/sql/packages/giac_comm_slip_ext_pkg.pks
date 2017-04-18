CREATE OR REPLACE PACKAGE CPI.GIAC_COMM_SLIP_EXT_PKG AS

    TYPE giac_comm_slip_ext_type IS RECORD (
        rec_id              GIAC_COMM_SLIP_EXT.rec_id%TYPE,
        gacc_tran_id        GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        comm_slip_pref      GIAC_COMM_SLIP_EXT.comm_slip_pref%TYPE,
        comm_slip_no        GIAC_COMM_SLIP_EXT.comm_slip_no%TYPE,
        intm_no             GIAC_COMM_SLIP_EXT.intm_no%TYPE,
        ref_intm_cd         GIIS_INTERMEDIARY.ref_intm_cd%TYPE,
        iss_cd              GIAC_COMM_SLIP_EXT.iss_cd%TYPE,
        prem_seq_no         GIAC_COMM_SLIP_EXT.prem_seq_no%TYPE,
        bill_no             VARCHAR2(20),
        comm_amt            GIAC_COMM_SLIP_EXT.comm_amt%TYPE,
        wtax_amt            GIAC_COMM_SLIP_EXT.wtax_amt%TYPE,
        input_vat_amt       GIAC_COMM_SLIP_EXT.input_vat_amt%TYPE,
        net_amt             NUMBER(13,2),
        comm_slip_flag      GIAC_COMM_SLIP_EXT.comm_slip_flag%TYPE,
        comm_slip_tag       GIAC_COMM_SLIP_EXT.comm_slip_tag%TYPE,
        commission_slip_no  VARCHAR2(30)
    );
    
    TYPE giac_comm_slip_ext_tab IS TABLE OF giac_comm_slip_ext_type;
    
    FUNCTION get_comm_slip_ext (p_tran_id   GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE)
        RETURN giac_comm_slip_ext_tab PIPELINED;
        
    PROCEDURE extract_comm_slip (
        p_tran_id  IN GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        p_user     IN GIIS_USERS.user_id%TYPE,
        p_pdc      OUT VARCHAR2
    );
    
    PROCEDURE get_comm_print_values (
        p_tran_id             IN  GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        p_user                IN  GIIS_USERS.user_id%TYPE,
        p_pdc                 IN  VARCHAR2,
        p_comm_slip_pref      OUT  GIAC_COMM_SLIP_EXT.comm_slip_pref%TYPE,
        p_comm_slip_no        OUT GIAC_COMM_SLIP_EXT.comm_slip_no%TYPE,
        p_mesg                OUT VARCHAR2
    );
    
    PROCEDURE set_valid_comm_slip_tag (
        p_tran_id             GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        p_intm_no             GIAC_COMM_SLIP_EXT.intm_no%TYPE,
        p_rec_id              GIAC_COMM_SLIP_EXT.rec_id%TYPE,
        p_iss_cd              GIAC_COMM_SLIP_EXT.iss_cd%TYPE,
        p_prem_seq            GIAC_COMM_SLIP_EXT.prem_seq_no%TYPE
    );
    
    PROCEDURE reset_comm_slip_tag(p_tran_id     GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE);
END GIAC_COMM_SLIP_EXT_PKG;
/


