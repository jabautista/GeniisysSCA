CREATE OR REPLACE PACKAGE CPI.GIPI_LOAD_HIST_PKG 
AS
  TYPE gipi_load_hist_type IS RECORD(
         upload_no            GIPI_LOAD_HIST.upload_no%TYPE,
       filename                GIPI_LOAD_HIST.filename%TYPE,
       par_id                GIPI_LOAD_HIST.par_id%TYPE,
       date_loaded            GIPI_LOAD_HIST.date_loaded%TYPE,
       no_of_records        GIPI_LOAD_HIST.no_of_records%TYPE,
       user_id                GIPI_LOAD_HIST.user_id%TYPE,
       last_update            GIPI_LOAD_HIST.last_update%TYPE
         );
       
  TYPE gipi_load_hist_tab IS TABLE OF gipi_load_hist_type;

  FUNCTION get_gipi_load_hist
    RETURN gipi_load_hist_tab PIPELINED;  
    
  PROCEDURE insert_values(p_upload_no  GIPI_LOAD_HIST.upload_no%TYPE,
                            p_parid       GIPI_PARLIST.par_id%TYPE,                                                
                            p_itmnum       GIPI_WITEM.item_no%TYPE,
                          p_polid       GIPI_POLBASIC.policy_id%TYPE);

    PROCEDURE CREATE_INVOICE_ITEM(
        p_par_id            gipi_wpolbas.par_id%TYPE,
        p_line_cd           gipi_wpolbas.line_cd%TYPE,
        p_iss_cd            gipi_wpolbas.iss_cd%TYPE
        );
        
    PROCEDURE insert_recgrp_witem(
        p_par_id            gipi_witem.par_id%TYPE,
        p_line_cd           gipi_wpolbas.line_cd%TYPE,
        p_item_no           gipi_witem.item_no%TYPE
        );
        
    FUNCTION get_gipi_load_hist_tg (p_filename IN VARCHAR2)
    RETURN gipi_load_hist_tab PIPELINED;
END;
/


