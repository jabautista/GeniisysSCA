CREATE OR REPLACE PACKAGE CPI.GIPI_ORIG_ITMPERIL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_itmperil (p_par_id 	GIPI_ORIG_ITMPERIL.par_id%TYPE);
    
     TYPE gipi_orig_itmperil_type IS RECORD(
        par_id                GIPI_ORIG_ITMPERIL.par_id%TYPE,   
        item_no               GIPI_ORIG_ITMPERIL.item_no%TYPE,   
        line_cd               GIPI_ORIG_ITMPERIL.line_cd%TYPE, 
        peril_cd              GIPI_ORIG_ITMPERIL.peril_cd%TYPE,       
        rec_flag              GIPI_ORIG_ITMPERIL.rec_flag%TYPE, 
        policy_id             GIPI_ORIG_ITMPERIL.policy_id%TYPE, 
        prem_rt               GIPI_ORIG_ITMPERIL.prem_rt%TYPE, 
        prem_amt              GIPI_ORIG_ITMPERIL.prem_amt%TYPE,      
        tsi_amt               GIPI_ORIG_ITMPERIL.tsi_amt%TYPE,  
        ann_prem_amt          GIPI_ORIG_ITMPERIL.ann_prem_amt%TYPE, 
        ann_tsi_amt           GIPI_ORIG_ITMPERIL.ann_tsi_amt%TYPE,    
        comp_rem              GIPI_ORIG_ITMPERIL.comp_rem%TYPE, 
        discount_sw           GIPI_ORIG_ITMPERIL.discount_sw%TYPE,  
        ri_comm_rate          GIPI_ORIG_ITMPERIL.ri_comm_rate%TYPE,  
        ri_comm_amt           GIPI_ORIG_ITMPERIL.ri_comm_amt%TYPE, 
        surcharge_sw          GIPI_ORIG_ITMPERIL.surcharge_sw%TYPE, 
        peril_sname           GIIS_PERIL.peril_sname%TYPE, 
        peril_name			  GIIS_PERIL.peril_name%TYPE,
        share_prem_rate       NUMBER,
        share_prem_amt        NUMBER,
        share_tsi_amt         NUMBER
    );

    TYPE gipi_orig_itmperil_tab IS TABLE OF gipi_orig_itmperil_type;
    
    FUNCTION get_gipi_orig_itmperil(p_par_id	GIPI_ORIG_ITMPERIL.par_id%TYPE,
								    p_item_no	GIPI_ORIG_ITMPERIL.item_no%TYPE)					
    RETURN gipi_orig_itmperil_tab PIPElINED;
    
    PROCEDURE get_share_tsi_prem_amt
        (p_par_id	            GIPI_ORIG_ITMPERIL.par_id%TYPE,
         p_item_no	            GIPI_ORIG_ITMPERIL.item_no%TYPE,
         p_line_cd              GIPI_ORIG_ITMPERIL.line_cd%TYPE,
         p_peril_cd             GIPI_ORIG_ITMPERIL.peril_cd%TYPE,
         p_share_rate      OUT  NUMBER,
         p_share_prem_amt  OUT  NUMBER,
         p_share_tsi_amt   OUT  NUMBER);
         
    TYPE gipi_orig_itmperil_type2 IS RECORD(
  
    policy_id           gipi_item.policy_id%TYPE,
    item_no             gipi_item.item_no%TYPE,
    peril_desc          giis_peril.peril_name%TYPE,
    comp_rem            gipi_orig_itmperil.comp_rem%TYPE,
    your_peril_code     giis_peril.peril_sname%TYPE,
    your_prem_rt        gipi_itmperil.prem_rt%TYPE,
    your_prem_amt       gipi_itmperil.prem_amt%TYPE,
    your_tsi_amt        gipi_itmperil.tsi_amt%TYPE,
    your_discount_sw    gipi_itmperil.discount_sw%TYPE,
    full_peril_code     giis_peril.peril_sname%TYPE,
    full_prem_rt        gipi_orig_itmperil.prem_rt%TYPE,
    full_prem_amt       gipi_orig_itmperil.prem_amt%TYPE,
    full_tsi_amt        gipi_orig_itmperil.tsi_amt%TYPE,
    full_discount_sw    gipi_orig_itmperil.discount_sw%TYPE,
    dsp_full_prem_amt   gipi_orig_itmperil.prem_amt%TYPE,
    dsp_full_tsi_amt    gipi_orig_itmperil.tsi_amt%TYPE
    );
    
    TYPE gipi_orig_itmperil_tab2 IS TABLE OF gipi_orig_itmperil_type2;

    FUNCTION get_orig_itmperil(p_policy_id   gipi_item.policy_id%TYPE,
                               p_item_no     gipi_item.item_no%TYPE)
                               
    RETURN gipi_orig_itmperil_tab2 PIPELINED;
    
END GIPI_ORIG_ITMPERIL_PKG;
/


