CREATE OR REPLACE PACKAGE BODY CPI.giex_new_group_tax_pkg
AS

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.24.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves B880 data block
    */
    FUNCTION get_giexs007_b880_info (
        p_policy_id   giex_new_group_tax.policy_id%TYPE
    )
    RETURN giex_new_group_tax_tab PIPELINED
    IS
        v_tab       giex_new_group_tax_type;
        v_iss_cd    GIEX_EXPIRY.iss_cd%TYPE;
        v_line_cd   GIEX_EXPIRY.line_cd%TYPE;
    BEGIN
      SELECT iss_cd, line_cd
        INTO v_iss_cd, v_line_cd
        FROM GIEX_EXPIRY
       WHERE policy_id = p_policy_id;

      FOR i IN (SELECT a.tax_cd tax_cd, a.line_cd LINE_CD, a.iss_cd iss_cd,
                       a.tax_desc tax_desc, a.rate rate, b.peril_sw peril_sw,
		               a.tax_id tax_id, b.allocation_tag allocation_tag,
                       a.policy_id policy_id, a.tax_amt tax_amt,
                       a.currency_tax_amt -- added by joanne 060214
                  FROM giex_new_group_tax a, giis_tax_charges b
                 WHERE a.line_cd = b.line_cd
                   AND a.iss_cd = b.iss_cd
                   AND a.tax_cd = b.tax_cd
                   AND a.tax_id = b.tax_id --gmi taxes
                   AND a.policy_id = p_policy_id
                 ORDER BY tax_cd)
        LOOP
            v_tab.tax_cd            := i.tax_cd;
            v_tab.line_cd           := i.line_cd;
            v_tab.iss_cd            := i.iss_cd;
            v_tab.tax_desc          := i.tax_desc;
            v_tab.rate              := i.rate;
            v_tab.peril_sw          := i.peril_sw;
            v_tab.tax_id            := i.tax_id;
            v_tab.allocation_tag    := i.allocation_tag;
            v_tab.policy_id         := i.policy_id;
            v_tab.tax_amt           := i.tax_amt;
            v_tab.currency_tax_amt  := i.currency_tax_amt; --added by joanne 060214

            FOR C IN (SELECT primary_sw, no_rate_tag --added by joanne 01.17.14, for w/o rate taxes
                        FROM giis_tax_charges
                       WHERE iss_cd  = nvl(i.iss_cd, v_iss_cd)
                         AND line_cd = nvl(i.line_cd,v_line_cd)
                         AND tax_cd  = i.tax_cd
                         AND tax_id  = i.tax_id -- gmi taxes
                       /*AND eff_start_date <= (select nvl(eff_date,incept_date)
                                                from gipi_wpolbas
                                               where par_id = :b240.par_id)
                       AND eff_end_date >= (select nvl(eff_date,incept_date)
                                                from gipi_wpolbas
                                               where par_id = :b240.par_id)*/)
            LOOP
               v_tab.nbt_primary_sw := NVL(c.primary_sw,'N');
               v_tab.no_rate_tag    := NVL(c.no_rate_tag,'N'); --added by joanne 01.17.14, for w/o rate taxes
            END LOOP;

            PIPE ROW (v_tab);
        END LOOP;
    END get_giexs007_b880_info;

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
    )
    IS
    BEGIN
        MERGE INTO giex_new_group_tax
        USING dual ON (policy_id    = p_policy_id   AND
                       tax_cd       = p_tax_cd )
         WHEN NOT MATCHED THEN
            INSERT (
                policy_id,      line_cd,        iss_cd,     tax_cd,
                tax_id,         tax_desc,       tax_amt,    rate,
                currency_tax_amt --added by joanne 060214
            )
            VALUES (
                p_policy_id,    p_line_cd,      p_iss_cd,   p_tax_cd,
                p_tax_id,       p_tax_desc,     p_tax_amt,  p_rate,
                p_currency_tax_amt --added by joanne 060214
            )
            WHEN MATCHED THEN
            UPDATE SET  line_cd   = p_line_cd,
                        iss_cd    = p_iss_cd,
                        tax_id    = p_tax_id,
                        tax_desc  = p_tax_desc,
                        tax_amt   = p_tax_amt,
                        rate      = p_rate,
                        currency_tax_amt = p_currency_tax_amt; --added by joanne 060214
    END set_b880_dtls;

END;
/


