CREATE OR REPLACE PACKAGE CPI.GIACS157_PKG
AS

    TYPE giac_comm_fund_ext_type IS RECORD(
        rec_id                      GIAC_COMM_FUND_EXT.rec_id%TYPE,
        gacc_tran_id                GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        iss_cd                      GIAC_COMM_FUND_EXT.iss_cd%TYPE,
        prem_seq_no                 GIAC_COMM_FUND_EXT.prem_seq_no%TYPE,
        intm_no                     GIAC_COMM_FUND_EXT.intm_no%TYPE,
        comm_amt                    GIAC_COMM_FUND_EXT.comm_amt%TYPE,
        wtax_amt                    GIAC_COMM_FUND_EXT.wtax_amt%TYPE,
        input_vat_amt               GIAC_COMM_FUND_EXT.input_vat_amt%TYPE,
        comm_slip_pref              GIAC_COMM_FUND_EXT.comm_slip_pref%TYPE,
        comm_slip_no                GIAC_COMM_FUND_EXT.comm_slip_no%TYPE,
        user_id                     GIAC_COMM_FUND_EXT.user_id%TYPE,
        last_update                 GIAC_COMM_FUND_EXT.last_update%TYPE,
        comm_slip_tag               GIAC_COMM_FUND_EXT.comm_slip_tag%TYPE,
        comm_slip_date              GIAC_COMM_FUND_EXT.comm_slip_date%TYPE,
        comm_slip_flag              GIAC_COMM_FUND_EXT.comm_slip_flag%TYPE,
        or_no                       GIAC_COMM_FUND_EXT.or_no%TYPE,
        parent_intm_no              GIAC_COMM_FUND_EXT.parent_intm_no%TYPE,
        policy_id                   GIAC_COMM_FUND_EXT.policy_id%TYPE,
        prem_amt                    GIAC_COMM_FUND_EXT.prem_amt%TYPE,
        or_date                     GIAC_COMM_FUND_EXT.or_date%TYPE,
        spoiled_tag                 GIAC_COMM_FUND_EXT.spoiled_tag%TYPE,
        comm_tag                    GIAC_COMM_FUND_EXT.comm_tag%TYPE,
        record_no                   GIAC_COMM_FUND_EXT.record_no%TYPE,
        bill_no                     VARCHAR2(50),
        net_amt                     NUMBER(16, 2),
        dsp_comm_slip_date          VARCHAR2(20)
    );
    TYPE giac_comm_fund_ext_tab IS TABLE OF giac_comm_fund_ext_type;    

    FUNCTION get_giac_comm_fund_listing(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE
    )
      RETURN giac_comm_fund_ext_tab PIPELINED;
    
    PROCEDURE extract_comm_slip(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_user_id                   GIAC_COMM_FUND_EXT.user_id%TYPE
    );
    
    PROCEDURE update_giac_comm_fund_ext(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_intm_no                   GIAC_COMM_FUND_EXT.intm_no%TYPE,
        p_iss_cd                    GIAC_COMM_FUND_EXT.iss_cd%TYPE,
        p_prem_seq_no               GIAC_COMM_FUND_EXT.prem_seq_no%TYPE,
        p_rec_id                    GIAC_COMM_FUND_EXT.rec_id%TYPE
    );
    
    PROCEDURE check_comm_fund_slip(
        p_gacc_tran_id      IN      GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_in_rec_id         IN      VARCHAR2,                               -- shan 10.30.2014
        p_comm_slip_pref    OUT     GIAC_COMM_FUND_EXT.comm_slip_pref%TYPE,
        p_comm_slip_no      OUT     GIAC_COMM_FUND_EXT.comm_slip_no%TYPE,
        p_comm_slip_date    OUT     VARCHAR2
    );
    
    PROCEDURE save_slip_no(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_comm_slip_pref            GIAC_COMM_FUND_EXT.comm_slip_pref%TYPE,
        p_comm_slip_no              GIAC_COMM_FUND_EXT.comm_slip_no%TYPE
    );
    
    PROCEDURE proccess_after_printing(
        p_gacc_tran_id              giac_comm_fund_ext.gacc_tran_id%TYPE,
        p_sw                        NUMBER
    );
    
END;
/


