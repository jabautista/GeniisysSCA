CREATE OR REPLACE PACKAGE CPI.gipi_witmperl_beneficiary_pkg
AS
  TYPE gipi_witmperl_ben_type IS RECORD(
          par_id                    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
        item_no                    GIPI_WITMPERL_BENEFICIARY.item_no%TYPE,
        grouped_item_no            GIPI_WITMPERL_BENEFICIARY.grouped_item_no%TYPE,
        beneficiary_no            GIPI_WITMPERL_BENEFICIARY.beneficiary_no%TYPE,
        line_cd                    GIPI_WITMPERL_BENEFICIARY.line_cd%TYPE,
        peril_cd                GIPI_WITMPERL_BENEFICIARY.peril_cd%TYPE,
        rec_flag                GIPI_WITMPERL_BENEFICIARY.rec_flag%TYPE,
        prem_rt                    GIPI_WITMPERL_BENEFICIARY.prem_rt%TYPE,
        tsi_amt                    GIPI_WITMPERL_BENEFICIARY.tsi_amt%TYPE,
        prem_amt                GIPI_WITMPERL_BENEFICIARY.prem_amt%TYPE,
        ann_tsi_amt                GIPI_WITMPERL_BENEFICIARY.ann_tsi_amt%TYPE,    
        ann_prem_amt            GIPI_WITMPERL_BENEFICIARY.ann_prem_amt%TYPE,
        peril_name                GIIS_PERIL.peril_name%TYPE
        );
  
  TYPE gipi_witmperl_ben_tab IS TABLE OF gipi_witmperl_ben_type;    
  
  FUNCTION get_gipi_witmperl_benificiary(p_par_id    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
                                               p_item_no   GIPI_WITMPERL_BENEFICIARY.item_no%TYPE)
    RETURN gipi_witmperl_ben_tab PIPELINED;    
    
  PROCEDURE set_gipi_witmperl_benificiary(
              p_par_id                  GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
                 p_item_no                   GIPI_WITMPERL_BENEFICIARY.item_no%TYPE,
            p_grouped_item_no          GIPI_WITMPERL_BENEFICIARY.grouped_item_no%TYPE,                         
            p_beneficiary_no          GIPI_WITMPERL_BENEFICIARY.beneficiary_no%TYPE,        
            p_line_cd                  GIPI_WITMPERL_BENEFICIARY.line_cd%TYPE,
            p_peril_cd                  GIPI_WITMPERL_BENEFICIARY.peril_cd%TYPE,
            p_rec_flag                  GIPI_WITMPERL_BENEFICIARY.rec_flag%TYPE,
            p_prem_rt                  GIPI_WITMPERL_BENEFICIARY.prem_rt%TYPE,
            p_tsi_amt                  GIPI_WITMPERL_BENEFICIARY.tsi_amt%TYPE,
            p_prem_amt                  GIPI_WITMPERL_BENEFICIARY.prem_amt%TYPE,
            p_ann_tsi_amt              GIPI_WITMPERL_BENEFICIARY.ann_tsi_amt%TYPE,
            p_ann_prem_amt              GIPI_WITMPERL_BENEFICIARY.ann_prem_amt%TYPE
              );    
            
  PROCEDURE del_gipi_witmperl_benificiary(p_par_id    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
                                                p_item_no   GIPI_WITMPERL_BENEFICIARY.item_no%TYPE);        
                                          
  FUNCTION get_gipi_witmperl_benificiary2(p_par_id    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE)
    RETURN gipi_witmperl_ben_tab PIPELINED;    

    FUNCTION get_gipi_witmperl_ben_tg(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_ben_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN gipi_witmperl_ben_tab PIPELINED;

    PROCEDURE del_gipi_witmperl_beneficiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE);
    
    PROCEDURE del_gipi_witmperl_beneficiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_beneficiary_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE);
        
    PROCEDURE del_gipi_witmperl_beneficiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_beneficiary_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE,
        p_peril_cd IN gipi_witmperl_beneficiary.peril_cd%TYPE);
    
    FUNCTION get_witmperl_ben_listing(
        p_par_id            GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
        p_item_no           GIPI_WITMPERL_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   GIPI_WITMPERL_BENEFICIARY.grouped_item_no%TYPE,
        p_beneficiary_no    GIPI_WITMPERL_BENEFICIARY.beneficiary_no%TYPE,
        p_tsi_amt           GIPI_WITMPERL_BENEFICIARY.tsi_amt%TYPE,
        p_peril_name        GIIS_PERIL.peril_name%TYPE           
    )
      RETURN gipi_witmperl_ben_tab PIPELINED;

END;
/


