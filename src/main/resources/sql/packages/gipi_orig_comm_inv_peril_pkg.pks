CREATE OR REPLACE PACKAGE CPI.GIPI_ORIG_COMM_INV_PERIL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_comm_inv_peril (p_par_id 	GIPI_ORIG_COMM_INV_PERIL.par_id%TYPE);
    
    TYPE gipi_orig_comm_inv_peril_type IS RECORD(
        par_id                GIPI_ORIG_COMM_INV_PERIL.par_id%TYPE,
        intrmdry_intm_no      GIPI_ORIG_COMM_INV_PERIL.intrmdry_intm_no%TYPE,
        item_grp              GIPI_ORIG_COMM_INV_PERIL.item_grp%TYPE,
        peril_cd              GIPI_ORIG_COMM_INV_PERIL.peril_cd%TYPE,
        peril_name            GIIS_PERIL.peril_name%TYPE,
        premium_amt           GIPI_ORIG_COMM_INV_PERIL.premium_amt%TYPE,
        policy_id             GIPI_ORIG_COMM_INV_PERIL.policy_id%TYPE,
        iss_cd                GIPI_ORIG_COMM_INV_PERIL.iss_cd%TYPE,
        prem_seq_no           GIPI_ORIG_COMM_INV_PERIL.prem_seq_no%TYPE,
        commission_amt        GIPI_ORIG_COMM_INV_PERIL.commission_amt%TYPE,
        commission_rt         GIPI_ORIG_COMM_INV_PERIL.commission_rt%TYPE,
        wholding_tax          GIPI_ORIG_COMM_INV_PERIL.wholding_tax%TYPE,
        net_commission        NUMBER,
        share_premium_amt     GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
        share_commission_rt   GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
        share_commission_amt  GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
        share_wholding_tax    GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
        share_net_commission  NUMBER
    );
    
    TYPE gipi_orig_comm_inv_peril_tab IS TABLE OF gipi_orig_comm_inv_peril_type;
    
    FUNCTION get_gipi_orig_comm_inv_peril(p_par_id    GIPI_ORIG_COMM_INV_PERIL.par_id%TYPE,
                                          p_line_cd   GIIS_LINE.line_cd%TYPE)
    RETURN gipi_orig_comm_inv_peril_tab PIPELINED;
    
    TYPE comm_inv_peril_type IS RECORD(

        par_id              gipi_orig_comm_inv_peril.par_id%TYPE,
        iss_cd              gipi_orig_comm_inv_peril.iss_cd%TYPE,
        item_grp            gipi_orig_comm_inv_peril.item_grp%TYPE,
        peril_cd            gipi_orig_comm_inv_peril.peril_cd%TYPE,
        policy_id           gipi_orig_comm_inv_peril.policy_id%TYPE,
        prem_seq_no         gipi_orig_comm_inv_peril.prem_seq_no%TYPE,
        intrmdry_intm_no    gipi_orig_comm_inv_peril.intrmdry_intm_no%TYPE,

        full_peril_name         giis_peril.peril_name%TYPE,
        full_peril_sname        giis_peril.peril_sname%TYPE,
        full_premium_amt        gipi_orig_comm_inv_peril.premium_amt%TYPE,
        full_wholding_tax       gipi_orig_comm_inv_peril.wholding_tax%TYPE,
        full_commission_rt      gipi_orig_comm_inv_peril.commission_rt%TYPE,
        full_commission_amt     gipi_orig_comm_inv_peril.commission_amt%TYPE,
        full_net_commission     gipi_orig_comm_inv_peril.commission_amt%TYPE,

        your_peril_name         giis_peril.peril_name%TYPE,
        your_peril_sname        giis_peril.peril_sname%TYPE,
        your_premium_amt        gipi_orig_comm_inv_peril.premium_amt%TYPE,
        your_wholding_tax       gipi_orig_comm_inv_peril.wholding_tax%TYPE,
        your_commission_rt      gipi_orig_comm_inv_peril.commission_rt%TYPE,
        your_commission_amt     gipi_orig_comm_inv_peril.commission_amt%TYPE,
        your_net_commission     gipi_orig_comm_inv_peril.commission_amt%TYPE

    );
    
    TYPE comm_inv_peril_tab IS TABLE OF comm_inv_peril_type;    

    FUNCTION get_comm_inv_perils (
           p_policy_id          gipi_orig_comm_inv_peril.policy_id%TYPE,
           p_item_grp           gipi_orig_comm_inv_peril.item_grp%TYPE,
           p_intrmdry_intm_no   gipi_orig_comm_inv_peril.intrmdry_intm_no%TYPE
        )
           RETURN comm_inv_peril_tab PIPELINED;
    
END GIPI_ORIG_COMM_INV_PERIL_PKG;
/


