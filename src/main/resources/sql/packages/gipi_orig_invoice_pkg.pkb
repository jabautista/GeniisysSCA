CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ORIG_INVOICE_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_invoice (p_par_id 	GIPI_ORIG_INVOICE.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_ORIG_INVOICE
		 WHERE par_id  = p_par_id;
	END del_gipi_orig_invoice;

    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 04.30.2011
    **  Reference By     : (GIPIS154 - Lead Policy Information)
    **  Description     : Retrieves gipi_orig_invoice records of a given par_id and item_grp
    */
    FUNCTION get_gipi_orig_invoice
        (p_par_id               GIPI_ORIG_INVOICE.par_id%TYPE,
         p_item_grp             GIPI_ORIG_INVOICE.item_grp%TYPE)
    RETURN gipi_orig_invoice_tab PIPELINED

    AS
     v_orig_inv            gipi_orig_invoice_type;

    BEGIN
        FOR i IN(SELECT a.par_id, a.item_grp, a.property,
                        a.insured, a.ref_inv_no, a.prem_amt,
                        a.tax_amt, a.other_charges,
                        a.currency_cd, b.currency_desc,
                        NVL (a.prem_amt, 0)+ NVL (a.tax_amt, 0)
                        + NVL (a.other_charges, 0) amount_due
                FROM GIPI_ORIG_INVOICE a, GIIS_CURRENCY b
                WHERE a.par_id = p_par_id
                  AND a.item_grp = p_item_grp
                  AND a.currency_cd =  b.main_currency_cd)
        LOOP
            v_orig_inv.par_id		 :=	 i.par_id;
            v_orig_inv.item_grp 	 :=	 i.item_grp;
            v_orig_inv.property		 :=	 i.property;
            v_orig_inv.insured		 :=	 i.insured;
            v_orig_inv.ref_inv_no	 :=	 i.ref_inv_no;
            v_orig_inv.prem_amt		 :=	 i.prem_amt;
            v_orig_inv.tax_amt		 :=	 i.tax_amt;
            v_orig_inv.other_charges :=	 i.other_charges;
            v_orig_inv.currency_cd	 :=	 i.currency_cd;
            v_orig_inv.currency_desc :=  i.currency_desc;
            v_orig_inv.amount_due	 :=	 i.amount_due;

            PIPE ROW(v_orig_inv);
        END LOOP;
    END;





END GIPI_ORIG_INVOICE_PKG;
/


