CREATE OR REPLACE PACKAGE CPI.GIRI_RIREPORTS_PKG
AS
    
    TYPE bndr_peril_dtls_type IS RECORD (
        peril_sname         giis_peril.PERIL_SNAME%TYPE ,
        fnl_binder_id       giri_binder_peril.FNL_BINDER_ID%TYPE ,
        peril_seq_no        giri_binder_peril.PERIL_SEQ_NO%TYPE ,
        ri_share_pct        giri_binder_peril.RI_SHR_PCT%TYPE ,
        ri_tsi_amt          giri_binder_peril.RI_TSI_AMT%TYPE ,
        ri_prem_amt         giri_binder_peril.RI_PREM_AMT%TYPE ,
        ri_comm_rt          giri_binder_peril.RI_COMM_RT%TYPE ,
        ri_comm_amt         giri_binder_peril.RI_COMM_AMT%TYPE ,
        ri_comm_vat         giri_binder_peril.RI_COMM_VAT%TYPE ,
        ri_wholding_vat     giri_binder.RI_WHOLDING_VAT%TYPE ,
        ri_prem_vat         giri_binder.RI_PREM_VAT%TYPE ,
        ri_prem_tax         giri_binder_peril.PREM_TAX%TYPE ,
        gross_prem          giri_frps_peril_grp.PREM_AMT%TYPE 
    );
    
    TYPE bndr_peril_dtls_tab IS TABLE OF bndr_peril_dtls_type;
    
    FUNCTION get_binder_peril_dtls (
        p_line_cd   		giri_binder.line_cd%TYPE, 
        p_binder_yy    	    giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     giri_binder.binder_seq_no%TYPE
    ) RETURN bndr_peril_dtls_tab PIPELINED;
    
    
    PROCEDURE CHECK_RIREPORTS_BINDER (
        p_line_cd           IN VARCHAR2,
        p_binder_yy         IN NUMBER,
        p_binder_seq_no     IN NUMBER,
        p_is_line_cd        IN VARCHAR2,
        p_remarks_sw        IN VARCHAR2,
        p_local_curr        IN NUMBER,
        v_reversed          OUT VARCHAR2,
        v_replaced          OUT VARCHAR2,
        v_nbt_grp           OUT VARCHAR2,
        v_negated           OUT VARCHAR2,
        v_attention         OUT VARCHAR2,
        v_remarks           OUT VARCHAR2,
        v_bndr_remarks1     OUT VARCHAR2,
        v_bndr_remarks2     OUT VARCHAR2,
        v_bndr_remarks3     OUT VARCHAR2,
        v_read_only_attn    OUT VARCHAR2,
        --v_enable_nbt_grp    OUT VARCHAR2,
        v_enable_replaced   OUT VARCHAR2,
        v_enable_negated    OUT VARCHAR2,
        v_enable_local_curr OUT VARCHAR2,
        v_visible_prnt_opt  OUT VARCHAR2,
        v_giri_binder       OUT VARCHAR2,
        v_giri_group_binder OUT VARCHAR2 
    );
    
    PROCEDURE validate_bond_rnwl (
        p_line_cd           VARCHAR2, 
        p_binder_yy         NUMBER, 
        p_binder_seq_no     NUMBER,
        p_valid             OUT VARCHAR2, 
        p_old_fnl_binder_id OUT NUMBER, 
        p_fnl_binder_id     OUT NUMBER,
        p_return            OUT NUMBER
    );
   
    FUNCTION check_binder_replaced(
        p_line_cd           VARCHAR2, 
        p_binder_yy         NUMBER, 
        p_binder_seq_no     NUMBER        
    ) RETURN NUMBER;
    
    FUNCTION check_binder_negated(
        p_line_cd           VARCHAR2, 
        p_binder_yy         NUMBER, 
        p_binder_seq_no     NUMBER
    ) RETURN NUMBER;
    
    PROCEDURE update_binder_remarks(
        p_line_cd   		giri_binder.line_cd%TYPE, 
        p_binder_yy    	    giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     giri_binder.binder_seq_no%TYPE,
        p_attention         GIRI_BINDER.ATTENTION%TYPE,
        p_remarks           giri_frps_ri.REMARKS%TYPE,
        p_bndr_remarks1     giri_frps_ri.BNDR_REMARKS1%TYPE,
        p_bndr_remarks2     giri_frps_ri.BNDR_REMARKS2%TYPE,
        p_bndr_remarks3     giri_frps_ri.BNDR_REMARKS3%TYPE
    );
    
    PROCEDURE update_giri_bnder(
        p_line_cd   		IN OUT giri_binder.line_cd%TYPE, 
        p_binder_yy    	    IN OUT giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     IN OUT giri_binder.binder_seq_no%TYPE,
        p_reversed                 VARCHAR2,
        p_replaced                 VARCHAR2,
        p_negated                  VARCHAR2,
        p_attention                GIRI_BINDER.ATTENTION%TYPE,
        p_remarks                  giri_frps_ri.REMARKS%TYPE,
        p_bndr_remarks1            giri_frps_ri.BNDR_REMARKS1%TYPE,
        p_bndr_remarks2            giri_frps_ri.BNDR_REMARKS2%TYPE,
        p_bndr_remarks3            giri_frps_ri.BNDR_REMARKS3%TYPE
    );
    
    PROCEDURE update_giri_group_bnder(
        p_line_cd   		IN OUT giri_binder.line_cd%TYPE, 
        p_binder_yy    	    IN OUT giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     IN OUT giri_binder.binder_seq_no%TYPE,
        p_reversed                 VARCHAR2,
        p_replaced                 VARCHAR2,
        p_remarks                  giri_frps_ri.REMARKS%TYPE,
        p_bndr_remarks1            giri_frps_ri.BNDR_REMARKS1%TYPE,
        p_bndr_remarks2            giri_frps_ri.BNDR_REMARKS2%TYPE,
        p_bndr_remarks3            giri_frps_ri.BNDR_REMARKS3%TYPE    
    );
    
    PROCEDURE add_binder_peril_print_hist (
        p_fnl_binder_id         GIRI_BINDER_PERIL_PRINT_HIST.FNL_BINDER_ID%TYPE ,
        p_peril_seq_no          GIRI_BINDER_PERIL_PRINT_HIST.PERIL_SEQ_NO%TYPE ,                       
        p_ri_share_pct          GIRI_BINDER_PERIL_PRINT_HIST.RI_SHR_PCT%TYPE ,
        p_ri_tsi_amt            GIRI_BINDER_PERIL_PRINT_HIST.RI_TSI_AMT%TYPE ,
        p_ri_prem_amt           GIRI_BINDER_PERIL_PRINT_HIST.RI_PREM_AMT%TYPE ,
        p_ri_comm_rt            GIRI_BINDER_PERIL_PRINT_HIST.RI_COMM_RT%TYPE ,
        p_ri_comm_amt           GIRI_BINDER_PERIL_PRINT_HIST.RI_COMM_AMT%TYPE ,
        p_ri_comm_vat           GIRI_BINDER_PERIL_PRINT_HIST.RI_COMM_VAT%TYPE ,
        p_ri_wholding_vat       GIRI_BINDER_PERIL_PRINT_HIST.RI_WHOLDING_VAT%TYPE,
        p_ri_prem_vat           GIRI_BINDER_PERIL_PRINT_HIST.RI_PREM_VAT%TYPE ,
        p_ri_prem_tax           GIRI_BINDER_PERIL_PRINT_HIST.PREM_TAX%TYPE ,
        p_gross_prem            GIRI_BINDER_PERIL_PRINT_HIST.GROSS_PREM_AMT%TYPE
    );
    
    PROCEDURE get_girir121_fnl_binder_id(
        p_version           giis_reports.VERSION%TYPE,
        p_line_cd   		giri_binder.line_cd%TYPE, 
        p_binder_yy    	    giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     giri_binder.binder_seq_no%TYPE,
        v_fnl_binder_id OUT giri_frps_ri.FNL_BINDER_ID%TYPE,
        v_policy_id     OUT giuw_pol_dist.POLICY_ID%TYPE
    );
    
    FUNCTION check_oar_print_date(
        p_ri_cd         giri_inpolbas.RI_CD%TYPE,
        p_line_cd       gipi_polbasic.LINE_CD%TYPE,
        p_as_of_date    giri_inpolbas.OAR_PRINT_DATE%TYPE,
        p_more_than     NUMBER,
        p_less_than     NUMBER
    ) RETURN VARCHAR2;
    
    PROCEDURE update_oar_print_date(
        p_ri_cd         NUMBER,
        p_line_cd       VARCHAR2,
        p_as_of_date    DATE,
        p_more_than     NUMBER,
        p_less_than     NUMBER,
        p_print_chk     VARCHAR2
    );
    
    PROCEDURE validate_ri_sname(
        p_ri_sname      GIIS_REINSURER.RI_SNAME%TYPE,
        v_ri_cd     OUT GIIS_REINSURER.RI_CD%TYPE,
        v_stat      OUT VARCHAR2,
        v_msg       OUT VARCHAR2
    );
    
    PROCEDURE extract_inw_tran(
        p_line_cd           GIIS_LINE.LINE_CD%TYPE,
        p_ri_cd             GIIS_REINSURER.RI_CD%TYPE,
        p_expiry_month      VARCHAR2,
        p_expiry_year       NUMBER,
        p_accept_month      VARCHAR2,
        p_accept_year       NUMBER,
        p_user_id           GIXX_INW_TRAN.USER_ID%TYPE,
        v_extract_id    OUT gixx_inw_tran.extract_id%TYPE
    );
    
    PROCEDURE get_reciprocity_details1(
        p_user_id       IN  GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_inward_param  OUT GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        v_outward_param OUT GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        v_from_date     OUT GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        v_to_date       OUT GIRI_FAC_RECIPROCITY.TO_DATE%TYPE
    );
    
    PROCEDURE get_reciprocity_details2(
        p_user_id   IN  GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_ri_cd     OUT GIRI_FAC_RECIPROCITY.RI_CD%TYPE,
        v_ri_sname  OUT GIIS_REINSURER.RI_SNAME%TYPE
    );
    
    PROCEDURE get_reciprocity_initial_values(
        p_user_id       IN  GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_inward_param  OUT GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        v_outward_param OUT GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        v_from_date     OUT GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        v_to_date       OUT GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        v_ri_cd         OUT GIRI_FAC_RECIPROCITY.RI_CD%TYPE,
        v_ri_sname      OUT GIIS_REINSURER.RI_SNAME%TYPE
    );    
    
    FUNCTION get_reciprocity_ri_cd(
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE extract_reciprocity(
        p_ri_cd             GIRI_BINDER.RI_CD%TYPE,
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        v_count1        OUT NUMBER,
        v_count2        OUT NUMBER
    );
    
    FUNCTION get_extracted_reciprocity(
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE update_aprem(
        p_ri_cd             GIRI_INPOLBAS.RI_CD%TYPE,
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_local_curr        VARCHAR2,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_msg           OUT VARCHAR2
    );
    
    PROCEDURE update_cprem(
        p_ri_cd             GIRI_INPOLBAS.RI_CD%TYPE,
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_local_curr        VARCHAR2,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE        
    );
    
END GIRI_RIREPORTS_PKG;
/


