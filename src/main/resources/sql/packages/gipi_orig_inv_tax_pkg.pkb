CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ORIG_INV_TAX_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_inv_tax (p_par_id 	GIPI_ORIG_INV_TAX.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_ORIG_INV_TAX
		 WHERE par_id  = p_par_id;
	END del_gipi_orig_inv_tax;

    /*
    **  Created by		: Veronica V. Raymundo
    **  Date Created 	: 05.02.2011
    **  Reference By 	: (GIPIS154 - Lead Policy Information)
    **  Description 	: Retrieves gipi_orig_inv_tax record of a given par_id
    */

    FUNCTION get_gipi_orig_inv_tax
    (p_par_id     GIPI_ORIG_INV_TAX.par_id%TYPE,
     p_line_cd    GIPI_ORIG_INV_TAX.line_cd%TYPE,
     p_iss_cd     GIPI_ORIG_INV_TAX.iss_cd%TYPE)
    RETURN gipi_orig_inv_tax_tab PIPELINED

    IS

    v_orig_inv_tax          gipi_orig_inv_tax_type;

    BEGIN

        FOR i IN (SELECT a.par_id,
                         a.item_grp,a.tax_cd,
                         a.tax_amt, b.tax_desc
                    FROM GIPI_ORIG_INV_TAX a,
                         GIIS_TAX_CHARGES b
                    WHERE a.par_id  = p_par_id
                      AND b.iss_cd  = p_iss_cd
                      AND b.line_cd = p_line_cd
                      AND a.tax_cd  = b.tax_cd)
        LOOP
            v_orig_inv_tax.par_id   := i.par_id;
            v_orig_inv_tax.item_grp := i.item_grp;
            v_orig_inv_tax.tax_cd   := i.tax_cd;
            v_orig_inv_tax.tax_amt  := i.tax_amt;
            v_orig_inv_tax.tax_desc := i.tax_desc;

            v_orig_inv_tax.share_tax_amt  := GIPI_WINV_TAX_PKG.get_gipi_winv_tax_amt(i.par_id, i.item_grp,i.tax_cd);

            PIPE ROW(v_orig_inv_tax);

        END LOOP;
    END;

    /*
    **  Created by		: Moses Calma
    **  Date Created 	: 05.24.2011
    **  Reference By 	: (GIPIS100 - Policy Basic Information /Lead Policy)
    **  Description 	: Retrieves gipi_orig_inv_tax and gipi_inv_tax
    **                      based on policy_id and item_grp
    */

    FUNCTION get_inv_taxes (
       p_policy_id   gipi_orig_inv_tax.policy_id%TYPE,
       p_item_grp    gipi_orig_inv_tax.item_grp%TYPE
    )
       RETURN inv_taxes_tab PIPELINED
    IS
       v_inv_taxes   inv_taxes_type;
       v_line_cd     gipi_polbasic.line_cd%TYPE;
       v_iss_cd      gipi_polbasic.iss_cd%TYPE;
       v_tax_desc    giis_tax_charges.tax_desc%TYPE;

    BEGIN
       FOR i IN (SELECT policy_id,item_grp, tax_cd, tax_amt
                   FROM gipi_orig_inv_tax
                  WHERE policy_id = p_policy_id AND item_grp = p_item_grp)
       LOOP
          v_inv_taxes.full_tax_cd   := i.tax_cd;
          v_inv_taxes.full_tax_amt  := i.tax_amt;

          SELECT line_cd, iss_cd
            INTO v_line_cd, v_iss_cd
            FROM gipi_polbasic
           WHERE policy_id = i.policy_id;

          SELECT tax_desc
            INTO v_tax_desc
            FROM giis_tax_charges
           WHERE iss_cd = v_iss_cd AND line_cd = v_line_cd AND tax_cd = i.tax_cd;

          v_inv_taxes.full_tax_desc := v_tax_desc;

          SELECT a.tax_cd, a.tax_amt
            INTO v_inv_taxes.your_tax_cd, v_inv_taxes.your_tax_amt
            FROM gipi_inv_tax a, gipi_invoice b
           WHERE a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND a.item_grp = i.item_grp
             AND a.tax_cd = i.tax_cd
             AND b.policy_id = i.policy_id;

          v_inv_taxes.your_tax_desc := v_tax_desc;

          PIPE ROW (v_inv_taxes);
       END LOOP;
    END get_inv_taxes;

END GIPI_ORIG_INV_TAX_PKG;
/


