CREATE OR REPLACE PACKAGE CPI.giex_pack_expiry_pkg AS
    FUNCTION check_pack_policy_id_giexs006 (
        p_pack_policy_id    giex_pack_expiry.pack_policy_id%TYPE
    )
    RETURN VARCHAR2;
    TYPE giex_pack_expiry_type IS RECORD (
    pack_policy_id    giex_pack_expiry.pack_policy_id%TYPE
);
    TYPE giex_pack_expiry_tab IS TABLE OF giex_pack_expiry_type;
    FUNCTION get_pack_policy_id (
		p_dsp_policy_id		giex_pack_expiry.pack_policy_id%TYPE,
        p_fr_rn_seq_no      giex_pack_rn_no.rn_seq_no%TYPE,
        p_to_rn_seq_no      giex_pack_rn_no.rn_seq_no%TYPE,
        p_assd_no           giex_pack_expiry.assd_no%TYPE,
        p_intm_no           giex_pack_expiry.intm_no%TYPE,
        p_iss_cd            giex_pack_expiry.iss_cd%TYPE,
        p_subline_cd        giex_pack_expiry.subline_cd%TYPE,
        p_line_cd           giex_pack_expiry.line_cd%TYPE,
        p_start_date        VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
        p_end_date          VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
		p_renew_flag		giex_pack_expiry.renew_flag%TYPE,
        p_user_id           giis_users.user_id%TYPE,
		p_req_renewal_no	VARCHAR2
    )
    RETURN giex_pack_expiry_tab PIPELINED;
    FUNCTION check_pack_record_user (
        p_pack_policy_id	giex_pack_expiry.pack_policy_id%TYPE,
        p_assd_no		giex_pack_expiry.assd_no%TYPE,
        p_intm_no		giex_pack_expiry.intm_no%TYPE,
        p_iss_cd		giex_pack_expiry.iss_cd%TYPE,
        p_subline_cd	giex_pack_expiry.subline_cd%TYPE,
        p_line_cd		giex_pack_expiry.line_cd%TYPE,
        p_start_date    VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
        p_end_date      VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
        p_fr_rn_seq_no	giex_pack_rn_no.rn_seq_no%TYPE,
        p_to_rn_seq_no	giex_pack_rn_no.rn_seq_no%TYPE,
        p_user_id		giis_users.user_id%TYPE 
    )
    RETURN VARCHAR2;
END giex_pack_expiry_pkg;
/


