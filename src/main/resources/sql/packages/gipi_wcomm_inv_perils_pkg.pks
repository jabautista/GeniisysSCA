CREATE OR REPLACE PACKAGE CPI.Gipi_Wcomm_Inv_Perils_Pkg AS

	TYPE gipi_wcomm_inv_perils_type IS RECORD (
		peril_cd			GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
		peril_name			GIIS_PERIL.peril_name%TYPE,
		item_grp			GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
		takeup_seq_no		GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
		par_id				GIPI_WCOMM_INV_PERILS.par_id%TYPE,
		intrmdry_intm_no	GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
        premium_amt            GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
        commission_rt        GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
        commission_amt        GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
        wholding_tax        GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
        net_commission        NUMBER);

    TYPE gipi_wcomm_inv_perils_tab IS TABLE OF gipi_wcomm_inv_perils_type;
    
    TYPE gipi_wcomm_inv_perils_cur IS REF CURSOR RETURN gipi_wcomm_inv_perils_type;
  
    FUNCTION get_gipi_wcomm_inv_perils (
        p_par_id                GIPI_WCOMM_INV_PERILS.par_id%TYPE,
        p_item_grp                GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
        p_intrmdry_intm_no        GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE)
    RETURN gipi_wcomm_inv_perils_tab PIPELINED;
    
    FUNCTION get_gipi_wcomm_inv_perils2 (
        p_par_id                GIPI_WCOMM_INV_PERILS.par_id%TYPE)
    RETURN gipi_wcomm_inv_perils_tab PIPELINED;
    
  
    PROCEDURE set_gipi_wcomm_inv_perils (
        p_peril_cd                IN  GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
        p_item_grp                IN  GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
        p_takeup_seq_no            IN  GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
        p_par_id                IN  GIPI_WCOMM_INV_PERILS.par_id%TYPE,
        p_intrmdry_intm_no        IN  GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
        p_premium_amt            IN  GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
        p_commission_rt            IN  GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
        p_commission_amt        IN  GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
        p_wholding_tax            IN  GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE);        
     

    PROCEDURE del_gipi_wcomm_inv_perils (
        p_par_id                GIPI_WCOMM_INV_PERILS.par_id%TYPE,
        p_item_grp                GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
        p_intrmdry_intm_no        GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
        p_takeup_seq_no            GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
        p_peril_cd                GIPI_WCOMM_INV_PERILS.peril_cd%TYPE);
    
    /*
    **  Modified by        : Mark JM
    **  Date Created     : 02.11.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record by supplying the par_id only
    */
    PROCEDURE del_gipi_wcomm_inv_perils1 (p_par_id    GIPI_WCOMM_INV_PERILS.par_id%TYPE);
    
    PROCEDURE del_gipi_wcomm_inv_perils2 (
        p_par_id IN gipi_wcomm_inv_perils.par_id%TYPE,
        p_item_grp IN gipi_wcomm_inv_perils.item_grp%TYPE);
        
    PROCEDURE get_wcomm_inv_perils_amt_colmn
    (p_par_id       IN       GIPI_WCOMM_INV_PERILS.par_id%TYPE,
     p_item_grp     IN       GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
     p_intrmdry_no  IN       GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
     p_peril_cd     IN       GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
     p_prem_amt     OUT      GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
     p_comm_rt      OUT      GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
     p_comm_amt     OUT      GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
     p_whold_tax    OUT      GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
     p_net_comm     OUT      NUMBER);
	 
	FUNCTION get_pack_gipi_wcomm_inv_perils (
        p_pack_par_id            GIPI_PARLIST.pack_par_id%TYPE)
    RETURN gipi_wcomm_inv_perils_tab PIPELINED;
     
END Gipi_Wcomm_Inv_Perils_Pkg;
/


