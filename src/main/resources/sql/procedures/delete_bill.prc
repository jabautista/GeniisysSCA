CREATE OR REPLACE PROCEDURE CPI.Delete_Bill
  (p_par_id IN gipi_parlist.par_id%TYPE) IS
  BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: DELETE_BILL program unit
	*/
     DELETE FROM GIPI_WINSTALLMENT
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WCOMM_INV_PERILS
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WCOMM_INVOICES
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WINVPERL
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WINV_TAX
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WPACKAGE_INV_TAX
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WINVOICE
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WCOMM_INV_DTL --added by Jdiago 09.09.2014
       WHERE  par_id  =  p_par_id;
  END; 
/

