DROP PROCEDURE CPI.GIPIS039_CREATE_INVOICE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.gipis039_create_invoice_item(p_par_id GIPI_PARLIST.par_id%TYPE,
                                                         p_line_cd GIPI_PARLIST.line_cd%TYPE,
                                                         p_iss_cd GIPI_PARLIST.iss_cd%TYPE)
IS
   p_exist   NUMBER;
BEGIN
   SELECT DISTINCT 1
              INTO p_exist
              FROM gipi_witmperl a, gipi_witem b
             WHERE a.par_id = b.par_id
               AND a.par_id = p_par_id
               AND a.item_no = b.item_no
          GROUP BY b.par_id, b.item_grp, a.peril_cd;

   gipis039_populate_orig_itmperl(p_par_id);
   create_winvoice (0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
                                                  -- modified by aivhie 120601
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DELETE      gipi_winvperl
            WHERE par_id = p_par_id;

      DELETE      gipi_winv_tax
            WHERE par_id = p_par_id;

      DELETE      gipi_wpackage_inv_tax
            WHERE par_id = p_par_id;

      DELETE      gipi_winstallment
            WHERE par_id = p_par_id;

      DELETE      gipi_wcomm_invoices
            WHERE par_id = p_par_id;

      DELETE      gipi_winvoice
            WHERE par_id = p_par_id;
END;
/


