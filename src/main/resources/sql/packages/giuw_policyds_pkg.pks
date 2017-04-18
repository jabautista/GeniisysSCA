CREATE OR REPLACE PACKAGE CPI.GIUW_POLICYDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_policyds (p_dist_no 	GIUW_POLICYDS.dist_no%TYPE);
	
	PROCEDURE post_wpolicyds_dtl (
		  p_dist_no	  GIUW_POL_DIST.dist_no%TYPE,
		  p_endt_seq_no GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
		  p_eff_date GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
		  p_message OUT VARCHAR2
	);
    
    PROCEDURE post_wpolicyds_dtl_giuws016 (
		  p_dist_no	 IN   GIUW_POL_DIST.dist_no%TYPE,
		  p_eff_date IN   GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
		  p_message  OUT  VARCHAR2
	);
    
    TYPE giuw_policyds_type IS RECORD(
        dist_no             GIUW_POLICYDS.dist_no%TYPE,
        dist_seq_no         GIUW_POLICYDS.dist_seq_no%TYPE,
        tsi_amt             GIUW_POLICYDS.tsi_amt%TYPE,
        prem_amt            GIUW_POLICYDS.prem_amt%TYPE,
        item_grp            GIUW_POLICYDS.item_grp%TYPE,
        ann_tsi_amt         GIUW_POLICYDS.ann_tsi_amt%TYPE,
        cpi_rec_no          GIUW_POLICYDS.cpi_rec_no%TYPE,
        cpi_branch_cd       GIUW_POLICYDS.cpi_branch_cd%TYPE,
        arc_ext_data        GIUW_POLICYDS.arc_ext_data%TYPE,
        currency_cd         giis_currency.main_currency_cd%TYPE,
        currency_desc       giis_currency.currency_desc%TYPE,
        nbt_line_cd         giuw_wperilds.line_cd%TYPE
        );
        
    TYPE giuw_policyds_tab IS TABLE OF giuw_policyds_type;
    
    FUNCTION get_giuw_policyds(    
        p_dist_no           giuw_policyds.dist_no%TYPE,
        p_policy_id         gipi_invoice.policy_id%TYPE,
        p_takeup_seq_no     giuw_pol_dist.takeup_seq_no%TYPE  
        )
    RETURN giuw_policyds_tab PIPELINED;
    
    FUNCTION get_giuw_policyds_exist(
    p_dist_no     giuw_policyds.dist_no%TYPE)
   RETURN VARCHAR2;
    
END GIUW_POLICYDS_PKG;
/


