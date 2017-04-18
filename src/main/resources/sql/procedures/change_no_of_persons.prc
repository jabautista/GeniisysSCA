DROP PROCEDURE CPI.CHANGE_NO_OF_PERSONS;

CREATE OR REPLACE PROCEDURE CPI.CHANGE_NO_OF_PERSONS (
    p_par_id IN gipi_witem.par_id%TYPE,
    p_item_no IN gipi_witem.item_no%TYPE)
AS
/*    Date        Author            Description
**    ==========    ===============    ============================
**    10.27.2011    mark jm            delete/update records on related tables 
**                                Reference : GIPIS012 - Item Info (Accident)
*/    
BEGIN
    DELETE FROM gipi_wgrp_items_beneficiary
     WHERE par_id = p_par_id
       AND item_no = p_item_no;
     
    DELETE FROM gipi_wgrouped_items
     WHERE par_id = p_par_id
       AND item_no = p_item_no;
    
    FOR i IN (
        SELECT 1
          FROM gipi_witmperl_grouped
         WHERE par_id = p_par_id
           AND item_no = p_item_no)
    LOOP
        DELETE FROM gipi_witmperl
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
        EXIT;
    END LOOP;
    
    DELETE FROM gipi_witmperl_grouped
     WHERE par_id = p_par_id
       AND item_no = p_item_no;
    
    DELETE FROM gipi_witmperl_beneficiary
     WHERE par_id = p_par_id
       AND item_no = p_item_no;
       
    UPDATE gipi_parlist
       SET upload_no = NULL
     WHERE par_id = p_par_id;
    
    UPDATE gipi_load_hist
       SET par_id = NULL
     WHERE par_id = p_par_id;
END CHANGE_NO_OF_PERSONS;
/


