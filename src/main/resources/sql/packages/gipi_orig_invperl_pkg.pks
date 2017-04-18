CREATE OR REPLACE PACKAGE CPI.GIPI_ORIG_INVPERL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_invperl (p_par_id 	GIPI_ORIG_INVPERL.par_id%TYPE);
    
    TYPE gipi_orig_invperl_type IS RECORD(
        par_id              GIPI_ORIG_INVPERL.par_id%TYPE,
        item_grp            GIPI_ORIG_INVPERL.item_grp%TYPE,
        peril_cd            GIPI_ORIG_INVPERL.peril_cd%TYPE,
        peril_name          GIIS_PERIL.peril_name%TYPE,
        tsi_amt             GIPI_ORIG_INVPERL.tsi_amt%TYPE,
        prem_amt            GIPI_ORIG_INVPERL.prem_amt%TYPE,
        share_tsi_amt       GIPI_WINVPERL.tsi_amt%TYPE,
        share_prem_amt      GIPI_WINVPERL.prem_amt%TYPE,
        policy_id           GIPI_ORIG_INVPERL.policy_id%TYPE,
        ri_comm_amt         GIPI_ORIG_INVPERL.ri_comm_amt%TYPE,
        ri_comm_rt          GIPI_ORIG_INVPERL.ri_comm_rt%TYPE   
    );

    TYPE gipi_orig_invperl_tab IS TABLE OF gipi_orig_invperl_type;
    
    FUNCTION get_gipi_orig_invperl(p_par_id         GIPI_ORIG_INVPERL.par_id%TYPE,
                                   p_line_cd        GIIS_PERIL.line_cd%TYPE)
    RETURN gipi_orig_invperl_tab PIPELINED;
    
    
        TYPE inv_peril_type IS RECORD(

        par_id          gipi_orig_invperl.par_id%TYPE,
        item_grp        gipi_orig_invperl.item_grp%TYPE,
        peril_cd        gipi_orig_invperl.peril_cd%TYPE,
        policy_id       gipi_orig_invperl.policy_id%TYPE,
        ri_comm_rt      gipi_orig_invperl.ri_comm_rt%TYPE,
        ri_comm_amt     gipi_orig_invperl.ri_comm_amt%TYPE,
        full_prem_amt   gipi_orig_invperl.prem_amt%TYPE,
        full_tsi_amt    gipi_orig_invperl.tsi_amt%TYPE,
        your_prem_amt   gipi_invperil.prem_amt%TYPE,
        your_tsi_amt    gipi_invperil.tsi_amt%TYPE,
        full_peril_code giis_peril.peril_name%TYPE,
        your_peril_code giis_peril.peril_name%TYPE
        
    );
 
    TYPE inv_peril_tab IS TABLE OF inv_peril_type;
    
    FUNCTION get_inv_perils(p_policy_id   gipi_orig_invperl.policy_id%TYPE,
                            p_item_grp    gipi_orig_invperl.item_grp%TYPE
                           )
    RETURN inv_peril_tab PIPELINED;  
    
END GIPI_ORIG_INVPERL_PKG;
/


