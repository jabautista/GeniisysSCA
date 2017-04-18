CREATE OR REPLACE PACKAGE CPI.giex_new_group_tax_pkg
AS
   TYPE giex_new_group_tax_type IS RECORD (
     policy_id              giex_new_group_tax.policy_id%TYPE,
     line_cd                giex_new_group_tax.line_cd%TYPE,
     iss_cd                 giex_new_group_tax.iss_cd%TYPE,
     tax_cd                 giex_new_group_tax.tax_cd%TYPE,
     tax_id                 giex_new_group_tax.tax_id%TYPE,
     tax_desc               giex_new_group_tax.tax_desc%TYPE,
     tax_amt                giex_new_group_tax.tax_amt%TYPE,
     rate                   giex_new_group_tax.rate%TYPE,
     currency_tax_amt       giex_new_group_tax.currency_tax_amt%TYPE,
     ------------------------------------
     nbt_primary_sw         giis_tax_charges.primary_sw%TYPE,
     peril_sw               giis_tax_charges.peril_sw%TYPE,
     allocation_tag         giis_tax_charges.allocation_tag%TYPE,
     ---------added by joanne 01.17.14---------
     no_rate_tag            giis_tax_charges.no_rate_tag%TYPE
   );

   TYPE giex_new_group_tax_tab IS TABLE OF giex_new_group_tax_type;

   FUNCTION get_giexs007_b880_info (
        p_policy_id   giex_new_group_tax.policy_id%TYPE
    )
    RETURN giex_new_group_tax_tab PIPELINED;

    PROCEDURE set_b880_dtls (
        p_policy_id         giex_new_group_tax.policy_id%TYPE,
        p_line_cd           giex_new_group_tax.line_cd%TYPE,
        p_iss_cd            giex_new_group_tax.iss_cd%TYPE,
        p_tax_cd            giex_new_group_tax.tax_cd%TYPE,
        p_tax_id            giex_new_group_tax.tax_id%TYPE,
        p_tax_desc          giex_new_group_tax.tax_desc%TYPE,
        p_tax_amt           giex_new_group_tax.tax_amt%TYPE,
        p_rate              giex_new_group_tax.rate%TYPE,
        p_currency_tax_amt  giex_new_group_tax.currency_tax_amt%TYPE --added by joanne 060214
    );

END;
/


