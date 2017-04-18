CREATE OR REPLACE PACKAGE CPI.GIIS_LOSS_TAXES_PKG AS

    TYPE giis_loss_taxes_type IS RECORD(
        loss_tax_id     GIIS_LOSS_TAXES.loss_tax_id%TYPE, 
        tax_type        GIIS_LOSS_TAXES.tax_type%TYPE,
        tax_cd          GIIS_LOSS_TAXES.tax_cd%TYPE,
        tax_name        GIIS_LOSS_TAXES.tax_name%TYPE,
        branch_cd       GIIS_LOSS_TAXES.branch_cd%TYPE,
        tax_rate        GIIS_LOSS_TAXES.tax_rate%TYPE,
        start_date      GIIS_LOSS_TAXES.start_date%TYPE,
        end_date        GIIS_LOSS_TAXES.end_date%TYPE,
        gl_acct_id      GIIS_LOSS_TAXES.gl_acct_id%TYPE,
        sl_type_cd      GIIS_LOSS_TAXES.sl_type_cd%TYPE,
        remarks         GIIS_LOSS_TAXES.remarks%TYPE,
        user_id         GIIS_LOSS_TAXES.user_id%TYPE,
        last_update     GIIS_LOSS_TAXES.last_update%TYPE
    );

    TYPE giis_loss_taxes_tab IS TABLE OF giis_loss_taxes_type;
    
    FUNCTION get_giis_loss_taxes(p_tax_type     IN  GIIS_LOSS_TAXES.tax_type%TYPE,
                                 p_branch_cd    IN  GIIS_LOSS_TAXES.branch_cd%TYPE,
                                 p_keyword      IN  VARCHAR2)
    RETURN giis_loss_taxes_tab PIPELINED;

END GIIS_LOSS_TAXES_PKG;
/


