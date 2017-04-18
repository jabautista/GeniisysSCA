CREATE OR REPLACE PACKAGE CPI.COMPUTE_UWTAXES AS
FUNCTION compute_dst (p_par_id NUMBER,
                       p_int_premium NUMBER,
                       p_int_tsi NUMBER,
                       p_tax_type VARCHAR2,
                       p_line_cd VARCHAR2,
                       p_iss_cd VARCHAR2,
                       p_tax_cd NUMBER,
                       p_tax_id NUMBER,
                       p_rate NUMBER,
                       p_peril_sw VARCHAR2,
                       p_currency_rt NUMBER,
                       p_item_grp NUMBER,
                       p_takeup_seq_no NUMBER
                       --p_takeup_term NUMBER
                       )
RETURN NUMBER;
FUNCTION compute_evat (p_par_id NUMBER,
                      p_vat_tag VARCHAR2,
                      p_rate NUMBER,
                      p_int_prem NUMBER,
                      p_peril_sw VARCHAR2,
                      p_line_cd VARCHAR2,
                      p_iss_cd VARCHAR2,
                      p_tax_cd NUMBER,
                      p_tax_id NUMBER,
                      p_item_grp NUMBER,
                      p_takeup_seq_no NUMBER)
RETURN NUMBER;
FUNCTION get_fixed_rate (p_par_id NUMBER,
                         p_item_grp NUMBER,
                         p_takeup_seq_no NUMBER,
                         --p_takeup_term NUMBER,
                         p_int_prem NUMBER,
                         p_rate NUMBER,
                         p_peril_sw VARCHAR2,
                         p_line_cd VARCHAR2,
                         p_iss_cd VARCHAR2,
                         p_tax_cd NUMBER,
                         p_tax_id NUMBER)
RETURN NUMBER;
FUNCTION get_tax_range (p_amount NUMBER,
                        p_currency_rt NUMBER,
                        p_line_cd VARCHAR2,
                        p_iss_cd VARCHAR2,
                        p_tax_cd NUMBER,
                        p_tax_id NUMBER)
RETURN NUMBER;
PROCEDURE compute_tax (p_par_id IN NUMBER);
PROCEDURE compute_longtermtax (p_par_id IN NUMBER);
PROCEDURE compute_taxes (p_par_id IN NUMBER);
    PROCEDURE get_prorate_tax (
       p_par_id        IN       gipi_polbasic.par_id%TYPE,
       p_tax_cd        IN       gipi_winv_tax.tax_cd%TYPE,
       p_iss_cd        IN       gipi_winv_tax.iss_cd%TYPE,
       p_line_cd       IN       gipi_winv_tax.line_cd%TYPE,
       p_eff_date      IN       gipi_polbasic.eff_date%TYPE,
       p_item_grp      IN       gipi_invoice.item_grp%TYPE,
       p_currency_cd   IN       gipi_invoice.currency_cd%TYPE,
       p_currency_rt   IN       gipi_invoice.currency_rt%TYPE,
       p_prorate_tax   OUT      gipi_winv_tax.tax_amt%TYPE
    );
    PROCEDURE get_prorate_tax2 ( -- Dren 12.11.2015 SR-0020357 : Wrong prorate computation for manual cancellation. - Start
       p_par_id        IN       gipi_polbasic.par_id%TYPE,
       p_tax_cd        IN       gipi_winv_tax.tax_cd%TYPE,
       p_iss_cd        IN       gipi_winv_tax.iss_cd%TYPE,
       p_line_cd       IN       gipi_winv_tax.line_cd%TYPE,
       p_eff_date      IN       gipi_polbasic.eff_date%TYPE,
       p_item_grp      IN       gipi_invoice.item_grp%TYPE,
       p_currency_cd   IN       gipi_invoice.currency_cd%TYPE,
       p_currency_rt   IN       gipi_invoice.currency_rt%TYPE,
       p_rate          IN       gipi_winv_tax.rate%TYPE,
       p_prorate_tax   OUT      gipi_winv_tax.tax_amt%TYPE
    ); -- Dren 12.11.2015 SR-0020357 : Wrong prorate computation for manual cancellation. - End
END;
/


