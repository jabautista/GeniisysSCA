CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_POLBASIC_PKG
AS

  TYPE gipi_pack_polbasic_type IS RECORD (
    pack_par_id                GIPI_PACK_POLBASIC.pack_par_id%TYPE, 
    line_cd                    GIPI_PACK_POLBASIC.line_cd%TYPE,
    subline_cd                 GIPI_PACK_POLBASIC.subline_cd%TYPE,
    iss_cd                     GIPI_PACK_POLBASIC.iss_cd%TYPE,
    issue_yy              	   GIPI_PACK_POLBASIC.issue_yy%TYPE,
    pol_seq_no                 GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
    renew_no              	   GIPI_PACK_POLBASIC.renew_no%TYPE,
    endt_iss_cd                GIPI_PACK_POLBASIC.endt_iss_cd%TYPE,
    endt_yy                    GIPI_PACK_POLBASIC.endt_yy%TYPE,
    endt_seq_no                GIPI_PACK_POLBASIC.endt_seq_no%TYPE,
    endt_type                  GIPI_PACK_POLBASIC.endt_type%TYPE,
    eff_date              	   GIPI_PACK_POLBASIC.eff_date%TYPE,
    expiry_date                GIPI_PACK_POLBASIC.expiry_date%TYPE,
    assd_no                    GIPI_PACK_POLBASIC.assd_no%TYPE,
    assd_name              	   GIIS_ASSURED.assd_name%TYPE,
    dist_no                    GIUW_POL_DIST.dist_no%TYPE,
    dist_flag              	   GIPI_PACK_POLBASIC.dist_flag%TYPE,
    pack_policy_id             GIPI_PACK_POLBASIC.pack_policy_id%TYPE,
    ref_pol_no                 GIPI_PACK_POLBASIC.ref_pol_no%TYPE,
    incept_date                GIPI_PACK_POLBASIC.incept_date%TYPE);
	
  TYPE gipi_pack_polbasic_lov_type IS RECORD (
  	policy_id				   GIPI_PACK_POLBASIC.pack_policy_id%TYPE,
  	subline_cd                 GIPI_PACK_POLBASIC.subline_cd%TYPE,
    iss_cd                     GIPI_PACK_POLBASIC.iss_cd%TYPE,
    issue_yy              	   GIPI_PACK_POLBASIC.issue_yy%TYPE,
    pol_seq_no                 GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
    renew_no              	   GIPI_PACK_POLBASIC.renew_no%TYPE);
	
  TYPE gipi_pack_polbasic_tab IS TABLE OF gipi_pack_polbasic_type;
  
  --jmm SR-22834
  TYPE pack_polbasic_endt_lov_type IS RECORD (
    policy_id                   GIPI_PACK_POLBASIC.pack_policy_id%TYPE,
     subline_cd                 GIPI_PACK_POLBASIC.subline_cd%TYPE,
    iss_cd                     GIPI_PACK_POLBASIC.iss_cd%TYPE,
    issue_yy                     GIPI_PACK_POLBASIC.issue_yy%TYPE,
    pol_seq_no                 GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
    renew_no                     GIPI_PACK_POLBASIC.renew_no%TYPE,
    assd_no                    GIPI_PACK_POLBASIC.assd_no%TYPE,
    assd_name                  GIIS_ASSURED.assd_name%TYPE,
    ri_cd                      GIIS_REINSURER.ri_cd%TYPE
  );
  
  TYPE gipi_pack_polbasic_lov_tab IS TABLE OF pack_polbasic_endt_lov_type;

  FUNCTION extract_expiry (
    p_line_cd		IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
  RETURN DATE;
  
  Procedure get_amt_from_latest_endt (
        p_line_cd           IN GIPI_PACK_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN GIPI_PACK_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN GIPI_PACK_POLBASIC.iss_cd%TYPE,
        p_issue_yy          IN GIPI_PACK_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN GIPI_PACK_POLBASIC.renew_no%TYPE,
        p_eff_date          IN GIPI_PACK_POLBASIC.eff_date%TYPE,
        p_field_name        IN VARCHAR2,
        p_ann_tsi_amt       OUT GIPI_PACK_POLBASIC.ann_tsi_amt%TYPE,
        p_ann_prem_amt      OUT GIPI_PACK_POLBASIC.ann_prem_amt%TYPE,
        p_amt_sw            OUT VARCHAR2);
		
  Procedure get_amt_from_pol_wout_endt (
        p_line_cd           IN GIPI_PACK_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN GIPI_PACK_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN GIPI_PACK_POLBASIC.iss_cd%TYPE,
        p_issue_yy          IN GIPI_PACK_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN GIPI_PACK_POLBASIC.renew_no%TYPE,        
        p_ann_tsi_amt       OUT GIPI_PACK_POLBASIC.ann_tsi_amt%TYPE,
        p_ann_prem_amt      OUT GIPI_PACK_POLBASIC.ann_prem_amt%TYPE);
		
  PROCEDURE gipis031A_search_for_assured(
			  				    p_assd_no       IN OUT GIPI_PACK_WPOLBAS.assd_no%TYPE,
								p_line_cd		IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
								p_subline_cd	IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
								p_iss_cd		IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
								p_issue_yy		IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
								p_pol_seq_no	IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
								p_renew_no		IN GIPI_PACK_WPOLBAS.renew_no%TYPE);
								
  Procedure gipis031A_search_for_address (
	p_add1 			IN OUT GIPI_WPOLBAS.address1%TYPE,
	p_add2 			IN OUT GIPI_WPOLBAS.address2%TYPE,
	p_add3 			IN OUT GIPI_WPOLBAS.address3%TYPE,
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE);
	
  FUNCTION get_policy_for_pack_endt(p_line_cd GIPI_PACK_WPOLBAS.line_cd%TYPE,
  		   							p_iss_cd  GIPI_PACK_WPOLBAS.iss_cd%TYPE, 
    								p_subline GIPI_PACK_WPOLBAS.subline_cd%TYPE,
                                    p_issue_yy GIPI_PACK_WPOLBAS.issue_yy%TYPE, --lbeltran SR2576 091115
                                    p_pol_seq_no GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
                                    p_renew_no GIPI_PACK_WPOLBAS.renew_no%TYPE,
									p_keyword VARCHAR2)
    RETURN gipi_pack_polbasic_lov_tab PIPELINED;
    
  FUNCTION get_pack_policy_id (
      p_line_cd      GIPI_PACK_POLBASIC.line_cd%TYPE,
      p_subline_cd   GIPI_PACK_POLBASIC.subline_cd%TYPE,
      p_iss_cd       GIPI_PACK_POLBASIC.iss_cd%TYPE,
      p_issue_yy     GIPI_PACK_POLBASIC.issue_yy%TYPE,
      p_pol_seq_no   GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
      p_renew_no     GIPI_PACK_POLBASIC.renew_no%TYPE
   )                                              
      RETURN NUMBER;

  FUNCTION get_pol_flag (p_pack_policy_id GIPI_PACK_POLBASIC.pack_policy_id%TYPE)
      RETURN GIPI_PACK_POLBASIC.pol_flag%TYPE;

    TYPE pack_policies_type IS RECORD(
        line_cd         GIPI_PACK_POLBASIC.line_cd%TYPE,
        subline_cd      GIPI_PACK_POLBASIC.subline_cd%TYPE,
        iss_cd          GIPI_PACK_POLBASIC.iss_cd%TYPE,
        issue_yy        GIPI_PACK_POLBASIC.issue_yy%TYPE,
        pol_seq_no      GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        renew_no        GIPI_PACK_POLBASIC.renew_no%TYPE,
        pack_policy_id  GIPI_PACK_POLBASIC.pack_policy_id%TYPE,
        nbt_pk_pol      VARCHAR2(3200)
        );
        
    TYPE pack_policies_tab IS TABLE OF pack_policies_type;    

    FUNCTION get_pack_policies_list(
        p_line_cd      GIPI_PACK_POLBASIC.line_cd%TYPE,
        p_subline_cd   GIPI_PACK_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd   GIPI_PACK_POLBASIC.iss_cd%TYPE,
        p_issue_yy     GIPI_PACK_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        p_renew_no     GIPI_PACK_POLBASIC.renew_no%TYPE
        )
    RETURN pack_policies_tab PIPELINED;
    
    FUNCTION get_package_binders(
        p_line_cd           gipi_pack_polbasic.line_cd%TYPE,
        p_iss_cd            gipi_pack_polbasic.iss_cd%TYPE,
        p_module            VARCHAR2,
        p_endt_seq_no       gipi_pack_polbasic.endt_seq_no%TYPE,
        p_endt_iss_cd       gipi_pack_polbasic.endt_iss_cd%TYPE,
        p_endt_yy           gipi_pack_polbasic.endt_yy%TYPE
        )
    RETURN gipi_pack_polbasic_tab PIPELINED;
    
    TYPE check_pack_pol_giexs006_type IS RECORD(
        pack_policy_id	 gipi_pack_polbasic.pack_policy_id%TYPE,
        pack_pol_flag    gipi_pack_polbasic.pack_pol_flag%TYPE
    );
    TYPE check_pack_pol_giexs006_tab IS TABLE OF check_pack_pol_giexs006_type;

    FUNCTION check_pack_pol_giexs006 (
        p_line_cd       gipi_pack_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_pack_polbasic.subline_cd%TYPE,
        p_iss_cd        gipi_pack_polbasic.iss_cd%TYPE,
        p_issue_yy      gipi_pack_polbasic.issue_yy%TYPE,
        p_pol_seq_no    gipi_pack_polbasic.pol_seq_no%TYPE,
        p_renew_no	    gipi_pack_polbasic.renew_no%TYPE
    )
       RETURN check_pack_pol_giexs006_tab PIPELINED;
	   
	PROCEDURE copy_pack_polbasic_giuts008a (
		p_policy_id   IN gipi_polbasic.policy_id%TYPE,
		p_copy_pol_id IN gipi_pack_polbasic.pack_par_id%TYPE,
		p_par_iss_cd  IN gipi_pack_polbasic.iss_cd%TYPE,
		p_pol_iss_cd  IN gipi_pack_polbasic.iss_cd%TYPE,
		p_line_cd     IN gipi_pack_polbasic.line_cd%TYPE,
		p_subline_cd  IN gipi_pack_polbasic.subline_cd%TYPE,
		p_iss_cd      IN gipi_pack_polbasic.iss_cd%TYPE,
		p_issue_yy    IN gipi_pack_polbasic.issue_yy%TYPE,
		p_pol_seq_no  IN gipi_pack_polbasic.pol_seq_no%TYPE,
		p_renew_no    IN gipi_pack_polbasic.renew_no%TYPE,
		p_user_id     IN giis_users.user_id%TYPE,
		message		 OUT VARCHAR2
	);	
        
    
    FUNCTION check_if_with_mc (
        p_pack_par_id       gipi_pack_parlist.pack_par_id%TYPE
    ) RETURN VARCHAR2;
    
END GIPI_PACK_POLBASIC_PKG;
/
