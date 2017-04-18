CREATE OR REPLACE PACKAGE CPI.gicl_clm_recovery_pkg
AS

    TYPE gicl_clm_recovery_type IS RECORD(
        recovery_id                 gicl_clm_recovery.recovery_id%TYPE,
        claim_id                    gicl_clm_recovery.claim_id%TYPE,
        line_cd                     gicl_clm_recovery.line_cd%TYPE,
        rec_year                    gicl_clm_recovery.rec_year%TYPE,
        rec_seq_no                  gicl_clm_recovery.rec_seq_no%TYPE,
        rec_type_cd                 gicl_clm_recovery.rec_type_cd%TYPE,
        recoverable_amt             gicl_clm_recovery.recoverable_amt%TYPE,
        recovered_amt               gicl_clm_recovery.recovered_amt%TYPE,
        tp_item_desc                gicl_clm_recovery.tp_item_desc%TYPE,
        plate_no                    gicl_clm_recovery.plate_no%TYPE,
        currency_cd                 gicl_clm_recovery.currency_cd%TYPE,
        convert_rate                gicl_clm_recovery.convert_rate%TYPE,
        lawyer_class_cd             gicl_clm_recovery.lawyer_class_cd%TYPE,
        lawyer_cd                   gicl_clm_recovery.lawyer_cd%TYPE,
        cpi_rec_no                  gicl_clm_recovery.cpi_rec_no%TYPE,
        cpi_branch_cd               gicl_clm_recovery.cpi_branch_cd%TYPE,
        user_id                     gicl_clm_recovery.user_id%TYPE,
        last_update                 gicl_clm_recovery.last_update%TYPE,
        cancel_tag                  gicl_clm_recovery.cancel_tag%TYPE,
        iss_cd                      gicl_clm_recovery.iss_cd%TYPE,
        rec_file_date               gicl_clm_recovery.rec_file_date%TYPE,
        demand_letter_date          gicl_clm_recovery.demand_letter_date%TYPE,
        demand_letter_date2         gicl_clm_recovery.demand_letter_date2%TYPE,
        demand_letter_date3         gicl_clm_recovery.demand_letter_date3%TYPE,
        tp_driver_name              gicl_clm_recovery.tp_driver_name%TYPE,
        tp_drvr_add                 gicl_clm_recovery.tp_drvr_add%TYPE,
        tp_plate_no                 gicl_clm_recovery.tp_plate_no%TYPE,
        case_no                     gicl_clm_recovery.case_no%TYPE,
        court                       gicl_clm_recovery.court%TYPE,
        dsp_lawyer_name             VARCHAR2(32000),
        dsp_rec_stat_desc           VARCHAR2(32000),
        dsp_rec_type_desc           giis_recovery_type.rec_type_desc%TYPE,
        dsp_currency_desc           giis_currency.currency_desc%TYPE,
        msg_alert                   VARCHAR2(32000),
        dsp_check_valid             VARCHAR2(1),
        dsp_check_all               VARCHAR2(1)
        );
        
    TYPE gicl_clm_recovery_tab IS TABLE OF gicl_clm_recovery_type;
    
    TYPE gicl_clm_recovery_dist_type IS RECORD(
        dsp_line_cd                 gicl_clm_recovery.line_cd%TYPE,
        dsp_iss_cd                  gicl_clm_recovery.iss_cd%TYPE,
        dsp_rec_year                gicl_clm_recovery.rec_year%TYPE,
        dsp_rec_seq_no              gicl_clm_recovery.rec_seq_no%TYPE,
        dsp_ref_no                  VARCHAR2(100),
        recovery_id                 gicl_clm_recovery.recovery_id%TYPE,
        claim_id                    gicl_clm_recovery.claim_id%TYPE,
        recovery_payt_id            NUMBER,
        payor_class_cd              VARCHAR2(10),
        payor_cd                    NUMBER,
        dsp_payor_name              VARCHAR2(600),
        recovered_amt               gicl_clm_recovery.recovered_amt%TYPE,
        acct_tran_id                NUMBER,
        tran_date                   VARCHAR2(20),
        cancel_tag                  gicl_clm_recovery.cancel_tag%TYPE,
        cancel_date                 VARCHAR2(20),
        entry_tag                   VARCHAR2(20),
        dist_sw                     VARCHAR2(20),
        acct_tran_id2               NUMBER,
        tran_date2                  VARCHAR2(20),
        stat_sw                     VARCHAR2(20),
        recovery_acct_id			NUMBER,
        
--      pol cruz, 10.17.2013
         pol_eff_date   gicl_claims.pol_eff_date%TYPE,
         expiry_date    gicl_claims.expiry_date%TYPE,
         loss_date      gicl_claims.loss_date%TYPE
	);
        
    TYPE gicl_clm_recovery_dist_tab IS TABLE OF gicl_clm_recovery_dist_type;
	
	TYPE gicls025_variables_type IS RECORD(
		assd_class_cd				GIIS_PAYEE_CLASS.payee_class_cd%TYPE,
		assd_no						GIIS_ASSURED.assd_no%TYPE,
		assd_name					GIIS_ASSURED.assd_name%TYPE,
		plate_no					GICL_MOTOR_CAR_DTL.plate_no%TYPE
	);
	
	TYPE gicls025_variables_tab IS TABLE OF gicls025_variables_type;
    
    FUNCTION get_gicl_clm_recovery(
        p_claim_id          gicl_clm_recovery.claim_id%TYPE,
        p_recovery_id       gicl_clm_recovery.recovery_id%TYPE
        )
    RETURN gicl_clm_recovery_tab PIPELINED;        

    PROCEDURE populate_module_variables(
        v_closed_cd         OUT giis_parameters.param_value_v%TYPE,
        v_cancel_cd         OUT giis_parameters.param_value_v%TYPE,
        v_writeoff_cd       OUT giis_parameters.param_value_v%TYPE,
        v_reopen_cd         OUT giis_parameters.param_value_v%TYPE,
        v_msg_alert         OUT VARCHAR2
        );
        
    FUNCTION get_gicl_clm_recovery(
        p_claim_id          gicl_clm_recovery.claim_id%TYPE
        )
    RETURN gicl_clm_recovery_tab PIPELINED;
    
    FUNCTION gen_rec_seq_no(
        p_line_cd IN gicl_clm_recovery.line_cd%TYPE,
        p_rec_year IN gicl_clm_recovery.rec_year%TYPE,
        p_iss_cd IN gicl_clm_recovery.iss_cd%TYPE
        ) 
    RETURN NUMBER;
    
    FUNCTION gen_rec_id RETURN NUMBER;
    
    FUNCTION gen_rec_hist_no(p_rec_id IN gicl_rec_hist.recovery_id%TYPE) 
    RETURN NUMBER;
        
    PROCEDURE save_recoverable(
        p_line_cd         IN   gicl_clm_recovery.line_cd%TYPE,
        p_iss_cd          IN   gicl_clm_recovery.iss_cd%TYPE,
        p_rec_year        OUT  gicl_clm_recovery.rec_year%TYPE,
        p_rec_seq_no      OUT  gicl_clm_recovery.rec_seq_no%TYPE,
        p_recovery_id     OUT  gicl_clm_recovery.recovery_id%TYPE,
        p_rec_file_date   OUT  gicl_clm_recovery.rec_file_date%TYPE
        );

    PROCEDURE save_recoverable2(
        p_chk_choose            VARCHAR2,
        p_item_no               gicl_clm_recovery_dtl.item_no%TYPE,
        p_peril_cd              gicl_clm_recovery_dtl.peril_cd%TYPE,
        p_nbt_paid_amt          gicl_clm_recovery_dtl.recoverable_amt%TYPE,
        p_clm_loss_id           gicl_clm_recovery_dtl.clm_loss_id%TYPE,
        p_recovery_id           gicl_clm_recovery_dtl.recovery_id%TYPE,
        p_claim_id              gicl_clm_recovery_dtl.claim_id%TYPE,
        p_rec_amt           OUT gicl_clm_recovery_dtl.recoverable_amt%TYPE
        );
        
    PROCEDURE set_gicl_clm_recovery(
        p_recovery_id                 gicl_clm_recovery.recovery_id%TYPE,
        p_claim_id                    gicl_clm_recovery.claim_id%TYPE,
        p_line_cd                     gicl_clm_recovery.line_cd%TYPE,
        p_rec_year                    gicl_clm_recovery.rec_year%TYPE,
        p_rec_seq_no                  gicl_clm_recovery.rec_seq_no%TYPE,
        p_rec_type_cd                 gicl_clm_recovery.rec_type_cd%TYPE,
        p_recoverable_amt             gicl_clm_recovery.recoverable_amt%TYPE,
        p_recovered_amt               gicl_clm_recovery.recovered_amt%TYPE,
        p_tp_item_desc                gicl_clm_recovery.tp_item_desc%TYPE,
        p_plate_no                    gicl_clm_recovery.plate_no%TYPE,
        p_currency_cd                 gicl_clm_recovery.currency_cd%TYPE,
        p_convert_rate                gicl_clm_recovery.convert_rate%TYPE,
        p_lawyer_class_cd             gicl_clm_recovery.lawyer_class_cd%TYPE,
        p_lawyer_cd                   gicl_clm_recovery.lawyer_cd%TYPE,
        p_cpi_rec_no                  gicl_clm_recovery.cpi_rec_no%TYPE,
        p_cpi_branch_cd               gicl_clm_recovery.cpi_branch_cd%TYPE,
        p_user_id                     gicl_clm_recovery.user_id%TYPE,
        p_last_update                 gicl_clm_recovery.last_update%TYPE,
        p_cancel_tag                  gicl_clm_recovery.cancel_tag%TYPE,
        p_iss_cd                      gicl_clm_recovery.iss_cd%TYPE,
        p_rec_file_date               gicl_clm_recovery.rec_file_date%TYPE,
        p_demand_letter_date          gicl_clm_recovery.demand_letter_date%TYPE,
        p_demand_letter_date2         gicl_clm_recovery.demand_letter_date2%TYPE,
        p_demand_letter_date3         gicl_clm_recovery.demand_letter_date3%TYPE,
        p_tp_driver_name              gicl_clm_recovery.tp_driver_name%TYPE,
        p_tp_drvr_add                 gicl_clm_recovery.tp_drvr_add%TYPE,
        p_tp_plate_no                 gicl_clm_recovery.tp_plate_no%TYPE,
        p_case_no                     gicl_clm_recovery.case_no%TYPE,
        p_court                       gicl_clm_recovery.court%TYPE
        );

    PROCEDURE check_recovery_recovered_amt(
        p_claim_id               IN gicl_clm_recovery.claim_id%TYPE,
        p_recovery_id            IN gicl_clm_recovery.recovery_id%TYPE,
        p_count1                OUT NUMBER,
        p_count2                OUT NUMBER,
        p_count3                OUT NUMBER
        );
             
    PROCEDURE write_off_recovery(
        p_claim_id              gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
        al_button               VARCHAR2
        );

    PROCEDURE cancel_recovery(
        p_claim_id              gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
        al_button               VARCHAR2
        );

    PROCEDURE close_recovery(
        p_claim_id              gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
        al_button               VARCHAR2
        );

    FUNCTION get_recovery_dist_info(p_claim_id       gicl_clm_recovery.claim_id%TYPE)
      RETURN gicl_clm_recovery_dist_tab PIPELINED;
  
    PROCEDURE update_demand_letter_dates(   
      p_claim_id            gicl_clm_recovery.claim_id%TYPE,
      p_recovery_id         gicl_clm_recovery.recovery_id%TYPE,
      p_demand_letter_date  VARCHAR2,
      p_demand_letter_date2 VARCHAR2,
      p_demand_letter_date3 VARCHAR2
    );
	
	FUNCTION get_gicls025_variables(
		p_claim_id			GICL_CLM_RECOVERY.claim_id%TYPE
	)
	  RETURN gicls025_variables_tab PIPELINED;
	  
	FUNCTION get_gicl_clm_recovery_2(
        p_claim_id          gicl_clm_recovery.claim_id%TYPE)
    RETURN gicl_clm_recovery_tab PIPELINED;
    
END gicl_clm_recovery_pkg;
/


