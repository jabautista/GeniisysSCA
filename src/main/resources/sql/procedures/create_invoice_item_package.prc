DROP PROCEDURE CPI.CREATE_INVOICE_ITEM_PACKAGE;

CREATE OR REPLACE PROCEDURE CPI.CREATE_INVOICE_ITEM_PACKAGE (p_pack_par_id IN NUMBER)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Create winvoice and delete records on the following table based on the given paack_par_id
	*/
	v_exist VARCHAR2(1) := 'N';
BEGIN
	FOR A IN (
		SELECT c.par_id, c.line_cd, c.iss_cd
		  FROM gipi_witmperl a, gipi_witem b, gipi_parlist c
		 WHERE a.par_id = b.par_id
		   AND b.par_id = c.par_id
		   AND c.pack_par_id = p_pack_par_id
           AND a.item_no = b.item_no
      GROUP BY c.par_id, c.line_cd, c.iss_cd)
    LOOP
        CREATE_WINVOICE(0, 0, 0, a.par_id, a.line_cd, a.iss_cd);
        v_exist := 'Y';
    END LOOP;
    
    IF v_exist = 'N' THEN
        FOR A IN (
            SELECT par_id
              FROM gipi_parlist
             WHERE pack_par_id = p_pack_par_id)
        LOOP
            gipi_winvperl_pkg.del_gipi_winvperl_1(a.par_id);
            gipi_winv_tax_pkg.del_gipi_winv_tax_1(a.par_id);
            gipi_wpackage_inv_tax_pkg.del_gipi_wpackage_inv_tax(a.par_id);            
            gipi_winstallment_pkg.del_gipi_winstallment_1(a.par_id);
            gipi_wcomm_invoices_pkg.del_gipi_wcomm_invoices_1(a.par_id);
            gipi_winvoice_pkg.del_gipi_winvoice1(a.par_id);
            gipi_pack_winstallment_pkg.del_gipi_pack_winstallment(p_pack_par_id);
            gipi_pack_winvperl_pkg.del_gipi_pack_winvperl(p_pack_par_id);
            gipi_pack_winv_tax_pkg.del_gipi_pack_winv_tax(p_pack_par_id);
            gipi_pack_winvoice_pkg.del_gipi_pack_winvoice(p_pack_par_id);            
        END LOOP;
    END IF;
END CREATE_INVOICE_ITEM_PACKAGE;
/


