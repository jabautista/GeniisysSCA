CREATE OR REPLACE PACKAGE CPI.GIUTS009_PKG AS

    policy_line_cd              GIPI_POLBASIC.line_cd%TYPE;
    policy_subline_cd           GIPI_POLBASIC.subline_cd%TYPE;
    policy_iss_cd               GIPI_POLBASIC.iss_cd%TYPE;
    policy_issue_yy             GIPI_POLBASIC.issue_yy%TYPE;
    policy_pol_seq_no           GIPI_POLBASIC.pol_seq_no%TYPE;
    policy_renew_no             GIPI_POLBASIC.renew_no%TYPE;
    par_iss_cd		            GIPI_POLBASIC.iss_cd%TYPE;
	policy_spld_pol_sw			VARCHAR2(1);
	policy_spld_endt_sw			VARCHAR2(1);
	policy_cancel_sw			VARCHAR2(1);
	policy_expired_sw			VARCHAR2(1);
    
    copy_par_id                 GIPI_POLBASIC.par_id%TYPE;
    copy_par_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE ;   -- jhing 10.17.2015 GENQA 5033 
    
    var_line_AC                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_AV                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_CA                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_EN                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_FI                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_MC                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_MH                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_MN                 GIIS_PARAMETERS.param_value_v%TYPE;
    var_line_SU                 GIIS_PARAMETERS.param_value_v%TYPE;
    
    var_subline_CAR             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_EAR             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_MBI             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_MLOP            GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_DOS             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_BPV             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_EEI             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_PCP             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_OP              GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_BBI             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_MOP             GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_open            GIIS_PARAMETERS.param_value_v%TYPE;
    var_subline_OTH             VARCHAR2(5);
    
    var_vessel_cd               GIIS_PARAMETERS.param_value_v%TYPE;

    PROCEDURE populate_summary (
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no     		IN  GIPI_POLBASIC.renew_no%TYPE,
		p_par_iss_cd		IN  GIPI_POLBASIC.iss_cd%TYPE,
		p_spld_pol_sw		IN  VARCHAR2,
		p_spld_endt_sw		IN  VARCHAR2,
		p_cancel_sw			IN  VARCHAR2,
		p_expired_sw		IN  VARCHAR2,
        p_par_id            OUT GIPI_POLBASIC.par_id%TYPE
    );
    
    TYPE policy_group_type IS RECORD (
        policy_id       GIPI_POLBASIC.policy_id%TYPE,
        endt_seq_no     GIPI_POLBASIC.endt_seq_no%TYPE,
        pol_flag        GIPI_POLBASIC.pol_flag%TYPE,
        eff_date        GIPI_POLBASIC.eff_date%TYPE  -- jhing 10.14.2015 GENQA 5033
    );
    
    TYPE policy_group_tab IS TABLE OF policy_group_type;
    
    FUNCTION get_policy_group (
        p_line_cd      		GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no     		GIPI_POLBASIC.renew_no%TYPE,
		p_spld_pol_sw		VARCHAR2,
		p_spld_endt_sw		VARCHAR2,
		p_cancel_sw			VARCHAR2,
		p_expired_sw		VARCHAR2
    ) RETURN policy_group_tab PIPELINED;
  
    PROCEDURE insert_into_parlist (
		p_policy_id 	IN  gipi_polbasic.policy_id%type,
		p_par_iss_cd	IN gipi_parlist.iss_cd%type,
		p_par_id		OUT gipi_parlist.par_id%type
	);
    
    PROCEDURE insert_into_parhist (
		p_par_id	GIPI_PARLIST.par_id%TYPE
	);
    
    PROCEDURE populate_open_policy (
		v_policy_id		GIPI_POLBASIC.policy_id%TYPE,
		v_par_id		GIPI_POLBASIC.par_id%TYPE
	);
    
    -- jhing 10.10.2015 GENQA 5033 added parameters 
    PROCEDURE POPULATE_ITEM_INFO1 (  p_spld_pol_sw        IN  VARCHAR2,
        p_spld_endt_sw        IN  VARCHAR2,
        p_cancel_sw            IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2
    ) ;
    
    PROCEDURE change_item_grp(p_par_id IN gipi_parlist.par_id%TYPE);
    
    PROCEDURE initialize_line_cd (
		p_fire_cd       OUT   giis_line.line_cd%TYPE,
		p_motor_cd      OUT   giis_line.line_cd%TYPE,
		p_accident_cd   OUT   giis_line.line_cd%TYPE,
		p_hull_cd       OUT   giis_line.line_cd%TYPE,
		p_cargo_cd      OUT   giis_line.line_cd%TYPE,
		p_casualty_cd   OUT   giis_line.line_cd%TYPE,
		p_engrng_cd     OUT   giis_line.line_cd%TYPE,
		p_surety_cd     OUT   giis_line.line_cd%TYPE,
		p_aviation_cd   OUT   giis_line.line_cd%TYPE
	);
    
    PROCEDURE initialize_subline_cd(
		p_subline_CAR          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_EAR          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_MBI          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_MLOP         OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_DOS          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_BPV          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_EEI          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_PCP          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_OP           OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_BBI          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_MOP          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_OTH          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_open         OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_vessel_cd            OUT GIIS_PARAMETERS.param_value_v%TYPE
	);
    
    PROCEDURE POPULATE_OTHER_INFO(
		p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no     		IN  GIPI_POLBASIC.renew_no%TYPE,
		p_spld_pol_sw		IN  VARCHAR2,
		p_spld_endt_sw		IN  VARCHAR2,
		p_cancel_sw		    IN  VARCHAR2,
		p_expired_sw		IN  VARCHAR2
	);
    
    PROCEDURE POPULATE_PERIL (
        p_item_no   		   NUMBER
    );
    
    PROCEDURE POPULATE_DEDUCTIBLES ( 
		p_item_no   		   NUMBER
    );

    PROCEDURE populate_accident (
        p_item_no   		   NUMBER
    );
            
    PROCEDURE POPULATE_BENEFICIARY (
		p_item_no   		   NUMBER
	);        
    
    PROCEDURE POPULATE_GROUP_ITEMS (
		p_item_no   		   NUMBER
	);
    
    PROCEDURE populate_grp_items_beneficiary (
		p_item_no   		   NUMBER,
		p_grouped_item_no	   NUMBER
	);
    
    PROCEDURE POPULATE_AVIATION (
		p_item_no   		   NUMBER
	);
    
    PROCEDURE POPULATE_CASUALTY (
		p_item_no   		   NUMBER
	);
    
    PROCEDURE POPULATE_PERSONNEL (
		p_item_no   		   NUMBER
	);
	
	PROCEDURE POPULATE_FIRE (
        p_item_no              NUMBER
    );
	
	PROCEDURE POPULATE_MOTORCAR (
        p_item_no              NUMBER
    );
	
	PROCEDURE POPULATE_ACCESSORY (
        p_item_no              NUMBER
    );
	
	PROCEDURE POPULATE_CARGO (
        p_item_no              NUMBER
    );
	
	PROCEDURE POPULATE_CARRIER (
        p_item_no              NUMBER
    );
	
	PROCEDURE POPULATE_VESSEL;
	
	PROCEDURE POPULATE_HULL (
        p_item_no          GIPI_WITEM.item_no%TYPE
    );
	
	PROCEDURE POPULATE_LOCATION (
        p_item_no              NUMBER
    );
	
	PROCEDURE POPULATE_OPEN_LIAB;
	
	PROCEDURE POPULATE_OPEN_PERIL;
	
	PROCEDURE POPULATE_OPEN_CARGO;
	
	PROCEDURE POPULATE_OPEN_POLICY;
	
	PROCEDURE POPULATE_ENGG;
	
	PROCEDURE populate_bond;
    
    PROCEDURE POPULATE_WARRANTIES;
    
    PROCEDURE POPULATE_REQDOCS;
    
    PROCEDURE POPULATE_MORTGAGEE;
    
    PROCEDURE POPULATE_POLGENIN;
    
    PROCEDURE update_polbas (
		p_par_id 	    gipi_parlist.par_id%TYPE
	);
    
    PROCEDURE continue_summary (
		p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_par_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
        p_par_id            IN GIPI_PARLIST.par_id%TYPE
    );
    
    PROCEDURE populate_bank_schedule;
     
    PROCEDURE update_summarized_par (
        p_par_id            IN    GIPI_PARLIST.par_id%TYPE,
        p_par_seq_no        OUT GIPI_PARLIST.par_seq_no%TYPE,
        p_quote_seq_no        OUT GIPI_PARLIST.quote_seq_no%TYPE
    );
	
	PROCEDURE check_policy(
		p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2
	);
	
	PROCEDURE validate_line (
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
		p_user_id			IN 	GIIS_USERS.user_id%TYPE
    );
	
	PROCEDURE check_if_policy_exists(
		p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE
	);
	
	PROCEDURE validate_iss_cd (
		p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
		p_user_id			IN 	GIIS_USERS.user_id%TYPE
	);
    
    PROCEDURE validate_par_iss_cd (
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_par_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
		p_user_id			IN 	GIIS_USERS.user_id%TYPE
    );
    
   -- added by jhing 10.12.2015 GENQA 5033  
  PROCEDURE POPULATE_PERIL_GRP (
        p_item_no              GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    );     
    
  PROCEDURE update_bond_invoice  (
        p_par_id            IN    GIPI_PARLIST.par_id%TYPE
  ); 
    
END GIUTS009_PKG;
/


