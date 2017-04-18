CREATE OR REPLACE PACKAGE CPI.GIPI_ORIG_COMM_INVOICE_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_comm_invoice (p_par_id 	GIPI_ORIG_COMM_INVOICE.par_id%TYPE);
    
    TYPE gipi_orig_comm_invoice_type IS RECORD(
        par_id                      GIPI_ORIG_COMM_INVOICE.par_id%TYPE,
        intrmdry_intm_no            GIPI_ORIG_COMM_INVOICE.intrmdry_intm_no%TYPE,
        intm_name                   GIIS_INTERMEDIARY.intm_name%TYPE,
        parent_intm_no              GIIS_INTERMEDIARY.parent_intm_no%TYPE,
        parent_intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
        item_grp                    GIPI_ORIG_COMM_INVOICE.item_grp%TYPE,
        premium_amt                 GIPI_ORIG_COMM_INVOICE.premium_amt%TYPE,
        share_percentage            GIPI_ORIG_COMM_INVOICE.share_percentage%TYPE,
        commission_amt              GIPI_ORIG_COMM_INVOICE.commission_amt%TYPE,
        wholding_tax                GIPI_ORIG_COMM_INVOICE.wholding_tax%TYPE,
        net_comm                    NUMBER,
        share_premium_amt           GIPI_ORIG_COMM_INVOICE.premium_amt%TYPE,
        share_share_percentage      GIPI_ORIG_COMM_INVOICE.share_percentage%TYPE,
        share_commission_amt        GIPI_ORIG_COMM_INVOICE.commission_amt%TYPE,
        share_wholding_tax          GIPI_ORIG_COMM_INVOICE.wholding_tax%TYPE,
        share_net_comm              NUMBER
    );

    TYPE gipi_orig_comm_invoice_tab IS TABLE OF gipi_orig_comm_invoice_type;

    FUNCTION get_gipi_orig_comm_invoice(p_par_id        GIPI_ORIG_COMM_INVOICE.par_id%TYPE)
    RETURN gipi_orig_comm_invoice_tab PIPELINED;
    
        TYPE comm_invoice_type IS RECORD(

        par_id                  gipi_orig_comm_invoice.par_id%TYPE,
        iss_cd                  gipi_orig_comm_invoice.iss_cd%TYPE,
        item_grp                gipi_orig_comm_invoice.item_grp%TYPE,
        policy_id               gipi_orig_comm_invoice.policy_id%TYPE,
        prem_seq_no             gipi_orig_comm_invoice.prem_seq_no%TYPE,

        full_intm_name          giis_intermediary.intm_name%TYPE,
        full_prnt_intm_name     giis_intermediary.intm_name%TYPE,
        full_prnt_intm_no       giis_intermediary.parent_intm_no%TYPE,
        full_premium_amt        gipi_orig_comm_invoice.premium_amt%TYPE,
        full_wholding_tax       gipi_orig_comm_invoice.wholding_tax%TYPE,
        full_net_commission     gipi_orig_comm_invoice.commission_amt%TYPE,
        full_commission_amt     gipi_orig_comm_invoice.commission_amt%TYPE,
        full_intm_no            gipi_orig_comm_invoice.intrmdry_intm_no%TYPE,
        full_share_percentage   gipi_orig_comm_invoice.share_percentage%TYPE,

        your_intm_name          giis_intermediary.intm_name%TYPE,
        your_prnt_intm_name     giis_intermediary.intm_name%TYPE,
        your_premium_amt        gipi_comm_invoice.premium_amt%TYPE,
        your_wholding_tax       gipi_comm_invoice.wholding_tax%TYPE,
        your_prnt_intm_no       giis_intermediary.parent_intm_no%TYPE,
        your_commission_amt     gipi_comm_invoice.commission_amt%TYPE,
        your_share_percentage   gipi_comm_invoice.share_percentage%TYPE,
        your_intm_no            gipi_comm_invoice.intrmdry_intm_no%TYPE,
        your_net_premium        gipi_orig_comm_invoice.commission_amt%TYPE
        
    );
    
    TYPE comm_invoice_tab IS TABLE OF comm_invoice_type;
    
    FUNCTION get_invoice_commissions (
       p_policy_id   gipi_orig_comm_invoice.policy_id%TYPE,
       p_item_grp    gipi_orig_comm_invoice.item_grp%TYPE
    )
       RETURN comm_invoice_tab PIPELINED;
    
END GIPI_ORIG_COMM_INVOICE_PKG;
/


