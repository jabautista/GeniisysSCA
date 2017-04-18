CREATE OR REPLACE PACKAGE CPI.GIPI_POLBASIC_POL_DIST_V1_PKG IS

    TYPE gipi_polbasic_pol_dist_v1_type IS RECORD (
        policy_id               GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE, 
        line_cd                 GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE, 
        subline_cd              GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
        iss_cd                  GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE, 
        issue_yy                GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE, 
        pol_seq_no              GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE, 
        endt_iss_cd             GIPI_POLBASIC_POL_DIST_V1.endt_iss_cd%TYPE, 
        endt_yy                 GIPI_POLBASIC_POL_DIST_V1.endt_yy%TYPE, 
        endt_seq_no             GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE, 
        renew_no                GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE, 
        par_id                  GIPI_POLBASIC_POL_DIST_V1.par_id%TYPE, 
        pol_flag                GIPI_POLBASIC_POL_DIST_V1.pol_flag%TYPE, 
        assd_no                 GIPI_POLBASIC_POL_DIST_V1.assd_no%TYPE,
        assd_name               GIIS_ASSURED.assd_name%TYPE, 
        acct_ent_date           GIPI_POLBASIC_POL_DIST_V1.acct_ent_date%TYPE, 
        spld_flag               GIPI_POLBASIC_POL_DIST_V1.spld_flag%TYPE, 
        pack_pol_flag           GIPI_POLBASIC.pack_pol_flag%TYPE,
        dist_flag               GIUW_POL_DIST.dist_flag%TYPE, 
        dist_no                 GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE, 
        eff_date                GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE, 
        expiry_date             GIPI_POLBASIC_POL_DIST_V1.expiry_date%TYPE, 
        negate_date             GIPI_POLBASIC_POL_DIST_V1.negate_date%TYPE, 
        dist_type               GIPI_POLBASIC_POL_DIST_V1.dist_type%TYPE, 
        acct_neg_date           GIPI_POLBASIC_POL_DIST_V1.acct_neg_date%TYPE, 
        par_type                GIPI_POLBASIC_POL_DIST_V1.par_type%TYPE,
        mean_dist_flag          VARCHAR2(240),
        policy_no               VARCHAR2(50),
        endt_no                 VARCHAR2(50),
		batch_id			    GIUW_POL_DIST.batch_id%TYPE, --added by tonio july 22, 2011 
        multi_booking_mm        GIPI_INVOICE.multi_booking_mm%TYPE, 
        multi_booking_yy        GIPI_INVOICE.multi_booking_yy%TYPE,
        msg_alert               VARCHAR2(32000)
     );
     
    TYPE currency_type IS RECORD(
        currency_cd             GIIS_CURRENCY.main_currency_cd%TYPE,
        currency_desc           GIIS_CURRENCY.currency_desc%TYPE
     );
    
    TYPE gipi_polbasic_pol_dist_v1_tab IS TABLE OF gipi_polbasic_pol_dist_v1_type;
    
    TYPE currency_tab IS TABLE OF currency_type;
    
    FUNCTION get_polbasic_pol_dist_v1(p_module_id           GIIS_USER_GRP_MODULES.module_id%TYPE,
                                      p_user_id             GIIS_USERS.user_id%TYPE,
                                      p_line_cd             GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                      p_subline_cd          GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                      p_iss_cd              GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                      p_issue_yy            GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                      p_pol_seq_no          GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                      p_renew_no            GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                      p_endt_yy             GIPI_POLBASIC_POL_DIST_V1.endt_yy%TYPE,
                                      p_endt_seq_no         GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                                      p_assd_name           GIIS_ASSURED.assd_name%TYPE,
                                      p_dist_no             GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
	
	FUNCTION get_pol_dist_v1_for_peril_dist(p_line_cd             GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                      		p_subline_cd          GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                      		p_iss_cd              GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                      		p_issue_yy            GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                      		p_pol_seq_no          GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                      		p_renew_no            GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                      		p_endt_yy             GIPI_POLBASIC_POL_DIST_V1.endt_yy%TYPE,
                                      		p_endt_seq_no         GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                                      		p_assd_name           GIIS_ASSURED.assd_name%TYPE,
                                      		p_dist_no             GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
	
	FUNCTION get_pol_dist_v1_one_risk_dist(p_line_cd             GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                      		p_subline_cd          GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                      		p_iss_cd              GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                      		p_issue_yy            GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                      		p_pol_seq_no          GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                      		p_renew_no            GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                      		p_endt_yy             GIPI_POLBASIC_POL_DIST_V1.endt_yy%TYPE,
                                      		p_endt_seq_no         GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                                      		p_assd_name           GIIS_ASSURED.assd_name%TYPE,
                                      		p_dist_no             GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE,
											p_user_id       giis_users.user_id%type
											)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
    
    FUNCTION get_pol_dist_v1_tsi_prem_distr(p_module_id           GIIS_USER_GRP_MODULES.module_id%TYPE,
                                            p_user_id             GIIS_USERS.user_id%TYPE,
                                            p_line_cd             GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                            p_subline_cd          GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                            p_iss_cd              GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                            p_issue_yy            GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                            p_pol_seq_no          GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                            p_renew_no            GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                            p_endt_yy             GIPI_POLBASIC_POL_DIST_V1.endt_yy%TYPE,
                                            p_endt_seq_no         GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                                            p_assd_name           GIIS_ASSURED.assd_name%TYPE,
                                            p_dist_no             GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
    
    FUNCTION get_pol_dist_v1_neg_post_distr(p_line_cd             GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                      		p_subline_cd          GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                      		p_iss_cd              GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                      		p_issue_yy            GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                      		p_pol_seq_no          GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                      		p_renew_no            GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                      		p_endt_yy             GIPI_POLBASIC_POL_DIST_V1.endt_yy%TYPE,
                                      		p_endt_seq_no         GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                                      		p_assd_name           GIIS_ASSURED.assd_name%TYPE,
                                      		p_dist_no             GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE,
										    p_user_id       giis_users.user_id%type)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
    
    FUNCTION security(p_module_id VARCHAR2,
                      p_line_cd   VARCHAR2,
                      p_iss_cd    VARCHAR2,
                      p_user_id   VARCHAR2) 
    RETURN GIPI_PARLIST_PKG.parlist_security_tab PIPELINED;    
    
    FUNCTION get_v1_dist_by_tsi_prem_peril(
        p_module_id     VARCHAR2,
        p_line_cd       VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_user_id       VARCHAR2,
        p_endt_iss_cd   VARCHAR2,
        p_endt_yy       VARCHAR2)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
    
    FUNCTION get_giuws012_currency_desc(p_policy_id         GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                        p_dist_no           GIUW_WPERILDS.dist_no%TYPE,
                                        p_dist_seq_no       GIUW_WPERILDS.dist_seq_no%TYPE)
      RETURN currency_tab PIPELINED;
       
    FUNCTION get_v1_pop_missing_dist_rec(
        p_module_id     VARCHAR2,
        p_line_cd       VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_user_id       VARCHAR2,
        p_endt_iss_cd   VARCHAR2,
        p_endt_yy       VARCHAR2,
        p_endt_seq_no   VARCHAR2)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
    
    PROCEDURE DELETE_DIST_WORKING_TABLES(
        p_dist_no   giuw_pol_dist.dist_no%TYPE,
        p_ri_sw     VARCHAR2
        );        
    
    TYPE rg_type IS RECORD(
            line_cd         giis_default_dist_group.line_cd%TYPE,
            share_cd        giis_default_dist_group.share_cd%TYPE,
            share_pct       giis_default_dist_group.share_pct%TYPE,
            share_amt1      giis_default_dist_group.share_amt1%TYPE,
            peril_cd        giis_default_dist_group.peril_cd%TYPE,
            share_amt2      giis_default_dist_group.share_amt2%TYPE,
            true_pct        VARCHAR2(2000));
    TYPE rg_tab IS TABLE OF rg_type;
    rg_id                       rg_tab;
    rg_selection                rg_tab;
    rg_index                    INTEGER;    
    rg_count			        NUMBER;
    
    PROCEDURE  CREATE_POLICY_DIST_RECS
              (p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
               p_policy_id     IN gipi_polbasic.policy_id%TYPE,
               p_line_cd       IN gipi_polbasic.line_cd%TYPE,
               p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
               p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
               p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE,
               p_ri_sw         IN VARCHAR2);          
    
    PROCEDURE create_missing_dist_rec(
        p_dist_no           IN       giuw_pol_dist.dist_no%TYPE,
        p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
        p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
        p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN       GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN       GIPI_POLBASIC.iss_cd%TYPE,
        p_msg_alert         OUT      VARCHAR2
        );
		
   FUNCTION get_pol_dist_v1_giuts999(
        p_module_id     GIIS_USER_GRP_MODULES.module_id%TYPE,
        p_user_id       GIIS_USERS.user_id%TYPE,
        p_line_cd       GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
      	p_subline_cd    GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
      	p_iss_cd        GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
      	p_issue_yy      GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
      	p_pol_seq_no    GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
      	p_renew_no      GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
		p_dist_no       GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
	RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED;
            
END;
/


