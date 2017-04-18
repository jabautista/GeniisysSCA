CREATE OR REPLACE PACKAGE CPI.GIRI_PACK_BINDER_HDR_PKG
AS

    TYPE giri_pack_binder_hdr_type IS RECORD(
        pack_policy_id          giri_pack_binder_hdr.pack_policy_id%TYPE,
        pack_binder_id          giri_pack_binder_hdr.pack_binder_id%TYPE,
        line_cd                 giri_pack_binder_hdr.line_cd%TYPE,
        binder_yy               giri_pack_binder_hdr.binder_yy%TYPE,
        binder_seq_no           giri_pack_binder_hdr.binder_seq_no%TYPE,
        ri_cd                   giri_pack_binder_hdr.ri_cd%TYPE,
        ri_tsi_amt              giri_pack_binder_hdr.ri_tsi_amt%TYPE,
        ri_prem_amt             giri_pack_binder_hdr.ri_prem_amt%TYPE,
        ri_shr_pct              giri_pack_binder_hdr.ri_shr_pct%TYPE,
        ri_comm_rt              giri_pack_binder_hdr.ri_comm_rt%TYPE,
        ri_comm_amt             giri_pack_binder_hdr.ri_comm_amt%TYPE,
        prem_tax                giri_pack_binder_hdr.prem_tax%TYPE,
        ri_prem_vat             giri_pack_binder_hdr.ri_prem_vat%TYPE,
        ri_comm_vat             giri_pack_binder_hdr.ri_comm_vat%TYPE,
        ri_wholding_vat         giri_pack_binder_hdr.ri_wholding_vat%TYPE,
        reverse_tag             giri_pack_binder_hdr.reverse_tag%TYPE,
        accept_by               giri_pack_binder_hdr.accept_by%TYPE,
        accept_date             giri_pack_binder_hdr.accept_date%TYPE,
        attention               giri_pack_binder_hdr.attention%TYPE,
        remarks                 giri_pack_binder_hdr.remarks%TYPE,
        user_id                 giri_pack_binder_hdr.user_id%TYPE,
        last_update             giri_pack_binder_hdr.last_update%TYPE,
        currency_cd             giri_pack_binder_hdr.currency_cd%TYPE,
        currency_rt             giri_pack_binder_hdr.currency_rt%TYPE,
        tsi_amt                 giri_pack_binder_hdr.tsi_amt%TYPE,
        binder_date             giri_pack_binder_hdr.binder_date%TYPE,
        as_no                   giri_pack_binder_hdr.as_no%TYPE,
        prem_amt                giri_pack_binder_hdr.prem_amt%TYPE,
        dsp_pack_binder_no      VARCHAR2(3200)
        );
        
    TYPE giri_pack_binder_hdr_tab IS TABLE OF giri_pack_binder_hdr_type;    

    FUNCTION get_giri_pack_binder_hdr(
        p_pack_policy_id        giri_pack_binder_hdr.pack_policy_id%TYPE
    ) 
    RETURN giri_pack_binder_hdr_tab PIPELINED;        

    PROCEDURE set_giri_pack_binder_hdr(
        p_pack_policy_id          giri_pack_binder_hdr.pack_policy_id%TYPE,
        p_pack_binder_id          giri_pack_binder_hdr.pack_binder_id%TYPE,
        p_line_cd                 giri_pack_binder_hdr.line_cd%TYPE,
        p_binder_yy               giri_pack_binder_hdr.binder_yy%TYPE,
        p_binder_seq_no           giri_pack_binder_hdr.binder_seq_no%TYPE,
        p_ri_cd                   giri_pack_binder_hdr.ri_cd%TYPE,
        p_ri_tsi_amt              giri_pack_binder_hdr.ri_tsi_amt%TYPE,
        p_ri_prem_amt             giri_pack_binder_hdr.ri_prem_amt%TYPE,
        p_ri_shr_pct              giri_pack_binder_hdr.ri_shr_pct%TYPE,
        p_ri_comm_rt              giri_pack_binder_hdr.ri_comm_rt%TYPE,
        p_ri_comm_amt             giri_pack_binder_hdr.ri_comm_amt%TYPE,
        p_prem_tax                giri_pack_binder_hdr.prem_tax%TYPE,
        p_ri_prem_vat             giri_pack_binder_hdr.ri_prem_vat%TYPE,
        p_ri_comm_vat             giri_pack_binder_hdr.ri_comm_vat%TYPE,
        p_ri_wholding_vat         giri_pack_binder_hdr.ri_wholding_vat%TYPE,
        p_reverse_tag             giri_pack_binder_hdr.reverse_tag%TYPE,
        p_accept_by               giri_pack_binder_hdr.accept_by%TYPE,
        p_accept_date             giri_pack_binder_hdr.accept_date%TYPE,
        p_attention               giri_pack_binder_hdr.attention%TYPE,
        p_remarks                 giri_pack_binder_hdr.remarks%TYPE,
        p_user_id                 giri_pack_binder_hdr.user_id%TYPE,
        p_last_update             giri_pack_binder_hdr.last_update%TYPE,
        p_currency_cd             giri_pack_binder_hdr.currency_cd%TYPE,
        p_currency_rt             giri_pack_binder_hdr.currency_rt%TYPE,
        p_tsi_amt                 giri_pack_binder_hdr.tsi_amt%TYPE,
        p_binder_date             giri_pack_binder_hdr.binder_date%TYPE,
        p_as_no                   giri_pack_binder_hdr.as_no%TYPE,
        p_prem_amt                giri_pack_binder_hdr.prem_amt%TYPE
    );
    
END;
/


