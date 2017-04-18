CREATE OR REPLACE PACKAGE CPI.GIUW_WPOLICYDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_wpolicyds (p_dist_no 	GIUW_WPOLICYDS.dist_no%TYPE);
    
    TYPE giuw_wpolicyds_type IS RECORD(
        dist_no             GIUW_WPOLICYDS.dist_no%TYPE,
        dist_seq_no         GIUW_WPOLICYDS.dist_seq_no%TYPE,
        dist_flag           GIUW_WPOLICYDS.dist_flag%TYPE,
        tsi_amt             GIUW_WPOLICYDS.tsi_amt%TYPE,
        prem_amt            GIUW_WPOLICYDS.prem_amt%TYPE,
        item_grp            GIUW_WPOLICYDS.item_grp%TYPE,
        ann_tsi_amt         GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
        arc_ext_data        GIUW_WPOLICYDS.arc_ext_data%TYPE,
        currency_cd         giis_currency.main_currency_cd%TYPE,
        currency_desc       giis_currency.currency_desc%TYPE,
        nbt_line_cd         giuw_wperilds.line_cd%TYPE
        );
        
    TYPE giuw_wpolicyds_tab IS TABLE OF giuw_wpolicyds_type;
    
    FUNCTION get_giuw_wpolicyds(
        p_dist_no           GIUW_WPOLICYDS.dist_no%TYPE,
        p_par_id            gipi_winvoice.par_id%TYPE,
        p_takeup_seq_no    giuw_pol_dist.takeup_seq_no%TYPE  
        )
    RETURN giuw_wpolicyds_tab PIPELINED;
    
    PROCEDURE set_giuw_wpolicyds(
        p_dist_no           giuw_wpolicyds.dist_no%TYPE,      
        p_dist_seq_no       giuw_wpolicyds.dist_seq_no%TYPE,
        p_dist_flag         giuw_wpolicyds.dist_flag%TYPE,   
        p_tsi_amt           giuw_wpolicyds.tsi_amt%TYPE,
        p_prem_amt          giuw_wpolicyds.prem_amt%TYPE,      
        p_item_grp          giuw_wpolicyds.item_grp%TYPE,
        p_ann_tsi_amt       giuw_wpolicyds.ann_tsi_amt%TYPE,   
        p_arc_ext_data      giuw_wpolicyds.arc_ext_data%TYPE
        );
       
   FUNCTION get_giuw_wpolicyds_exist(p_dist_no     giuw_wpolicyds.dist_no%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION get_giuw_wpolicyds2(	
        p_dist_no           GIUW_WPOLICYDS.dist_no%TYPE,
        p_policy_id			gipi_invoice.policy_id%TYPE,
        p_takeup_seq_no     giuw_pol_dist.takeup_seq_no%TYPE  
        )RETURN giuw_wpolicyds_tab PIPELINED;
        
   FUNCTION get_giuw_wpolicyds3(	
        p_dist_no           GIUW_WPOLICYDS.dist_no%TYPE,
        p_policy_id			GIPI_INVOICE.policy_id%TYPE)
   RETURN giuw_wpolicyds_tab PIPELINED;
   
   PROCEDURE neg_policyds (
        p_dist_no     IN  giuw_policyds.dist_no%TYPE,
        p_temp_distno IN  giuw_policyds.dist_no%TYPE
   );
   
   PROCEDURE NEG_POLICYDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                   p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                   p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                   p_v_ratio          IN OUT NUMBER);
                                   
   PROCEDURE TRANSFER_WPOLICYDS (p_dist_no    IN GIUW_POL_DIST.dist_no%TYPE);
            
END GIUW_WPOLICYDS_PKG;
/


