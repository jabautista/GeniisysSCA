DROP PROCEDURE CPI.GIPIS060_CREATE_INVOICE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_CREATE_INVOICE_ITEM(
	   p_par_id	  GIPI_WPOLBAS.par_id%TYPE,
	   p_message  OUT VARCHAR2)
IS
   v_exist    NUMBER;
BEGIN
   p_message := 'SUCCESS';
   SELECT   distinct 1
     INTO   v_exist
     FROM   gipi_witmperl a, gipi_witem b
    WHERE   a.par_id   =  b.par_id
      AND   a.par_id   =  p_par_id
      AND   a.item_no  =  b.item_no
 GROUP BY   b.par_id,b.item_grp,a.peril_cd;
   
   POPULATE_ORIG_ITMPERIL_2(p_par_id, p_message);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DELETE   gipi_winvperl
     WHERE   par_id = p_par_id;
    DELETE   gipi_winv_tax
     WHERE   par_id = p_par_id;
    DELETE   gipi_wpackage_inv_tax
     WHERE   par_id = p_par_id;
    DELETE   gipi_winstallment
     WHERE   par_id = p_par_id;
    DELETE   gipi_wcomm_invoices
     WHERE   par_id = p_par_id;
    DELETE   gipi_winvoice
     WHERE   par_id = p_par_id;
END;
/


