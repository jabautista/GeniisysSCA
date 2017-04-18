CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wcargo_Pkg
AS
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     : Returns PAR record listing for MARINE CARGO
    */
    FUNCTION get_gipi_wcargos (p_par_id      GIPI_WCARGO.par_id%TYPE)
    RETURN gipi_wcargo_tab PIPELINED  IS
        v_gipi_par_mn      gipi_wcargo_type;
    BEGIN
        FOR i IN (
            SELECT     a.par_id,                a.item_no,                a.item_title,            a.item_grp,
                    a.item_desc,            a.item_desc2,            a.tsi_amt,                a.prem_amt,
                    a.ann_prem_amt,            a.ann_tsi_amt,            a.rec_flag,                a.currency_cd,
                    a.currency_rt,            a.group_cd,                a.from_date,            a.TO_DATE,
                    a.pack_line_cd,            a.pack_subline_cd,        a.discount_sw,            a.coverage_cd,
                    a.other_info,            a.surcharge_sw,            a.region_cd,            a.changed_tag,
                    a.prorate_flag,            a.comp_sw,                a.short_rt_percent,        a.pack_ben_cd,
                    a.payt_terms,            a.risk_no,                a.risk_item_no,            b.currency_desc,
                    c.print_tag,            c.vessel_cd,            c.geog_cd,                c.cargo_class_cd,
                    c.voyage_no,            c.bl_awb,                c.origin,                c.destn,
                    c.etd,                    c.eta,                    c.cargo_type,            c.deduct_text,
                    c.pack_method,            c.tranship_origin,        c.tranship_destination,    c.lc_no,
                    c.invoice_value,        c.inv_curr_cd,            c.inv_curr_rt,            c.markup_rate,
                    c.rec_flag rec_flag_2,    c.cpi_rec_no,            c.cpi_branch_cd,        d.coverage_desc
              FROM     GIPI_WITEM a,
                      GIIS_CURRENCY b,
                    GIPI_WCARGO c,
                    GIIS_COVERAGE d
             WHERE  a.par_id = p_par_id
               AND  a.currency_cd = b.main_currency_cd(+)
               AND  a.par_id = c.par_id(+)
               AND  a.item_no = c.item_no(+)
               AND  a.coverage_cd = d.coverage_cd(+)
        ORDER BY     a.par_id, a.item_no)
        LOOP
            v_gipi_par_mn.par_id            := i.par_id;
            v_gipi_par_mn.item_no            := i.item_no;
            v_gipi_par_mn.item_title        := i.item_title;
            v_gipi_par_mn.item_grp            := i.item_grp;
            v_gipi_par_mn.item_desc            := i.item_desc;
            v_gipi_par_mn.item_desc2        := i.item_desc2;
            v_gipi_par_mn.tsi_amt            := NVL(i.tsi_amt, 0);
            v_gipi_par_mn.prem_amt            := NVL(i.prem_amt, 0);
            v_gipi_par_mn.ann_prem_amt        := NVL(i.ann_prem_amt, 0);
            v_gipi_par_mn.ann_tsi_amt        := NVL(i.ann_tsi_amt, 0);
            v_gipi_par_mn.rec_flag            := i.rec_flag;
            v_gipi_par_mn.currency_cd        := i.currency_cd;
            v_gipi_par_mn.currency_rt        := i.currency_rt;
            v_gipi_par_mn.group_cd            := i.group_cd;
            v_gipi_par_mn.from_date            := i.from_date;
            v_gipi_par_mn.TO_DATE            := i.TO_DATE;
            v_gipi_par_mn.pack_line_cd        := i.pack_line_cd;
            v_gipi_par_mn.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_par_mn.discount_sw        := i.discount_sw;
            v_gipi_par_mn.coverage_cd        := i.coverage_cd;
            v_gipi_par_mn.other_info        := i.other_info;
            v_gipi_par_mn.surcharge_sw        := i.surcharge_sw;
            v_gipi_par_mn.region_cd            := i.region_cd;
            v_gipi_par_mn.changed_tag        := i.changed_tag;
            v_gipi_par_mn.prorate_flag        := i.prorate_flag;
            v_gipi_par_mn.comp_sw            := i.comp_sw;
            v_gipi_par_mn.short_rt_percent    := i.short_rt_percent;
            v_gipi_par_mn.pack_ben_cd        := i.pack_ben_cd;
            v_gipi_par_mn.payt_terms        := i.payt_terms;
            v_gipi_par_mn.risk_no            := i.risk_no;
            v_gipi_par_mn.risk_item_no        := i.risk_item_no;
            v_gipi_par_mn.print_tag         := i.print_tag;
            v_gipi_par_mn.vessel_cd          := i.vessel_cd;
            v_gipi_par_mn.geog_cd              := i.geog_cd;
            v_gipi_par_mn.cargo_class_cd     := i.cargo_class_cd;
            v_gipi_par_mn.voyage_no         := i.voyage_no;
            v_gipi_par_mn.bl_awb             := i.bl_awb;
            v_gipi_par_mn.origin             := i.origin;
            v_gipi_par_mn.destn             := i.destn;
            v_gipi_par_mn.etd                 := i.etd;
            v_gipi_par_mn.eta                 := i.eta;
            v_gipi_par_mn.cargo_type         := i.cargo_type;
            v_gipi_par_mn.deduct_text         := i.deduct_text;
            v_gipi_par_mn.pack_method         := i.pack_method;
            v_gipi_par_mn.tranship_origin         := i.tranship_origin;
            v_gipi_par_mn.tranship_destination     := i.tranship_destination;
            v_gipi_par_mn.lc_no                 := i.lc_no;
            v_gipi_par_mn.invoice_value         := i.invoice_value;
            v_gipi_par_mn.inv_curr_cd             := i.inv_curr_cd;
            v_gipi_par_mn.inv_curr_rt             := i.inv_curr_rt;
            v_gipi_par_mn.markup_rate             := i.markup_rate;
            v_gipi_par_mn.rec_flag_wcargo         := i.rec_flag_2;
            v_gipi_par_mn.cpi_rec_no             := i.cpi_rec_no;
            v_gipi_par_mn.cpi_branch_cd         := i.cpi_branch_cd;
            v_gipi_par_mn.currency_desc            := i.currency_desc;
            v_gipi_par_mn.coverage_desc            := i.coverage_desc;
            v_gipi_par_mn.itmperl_grouped_exists := GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_exist(p_par_id, i.item_no);
            SELECT Gipi_Witmperl_Pkg.get_gipi_witmperl_exist(i.par_id, i.item_no)
              INTO v_gipi_par_mn.peril_exist
              FROM DUAL;
            PIPE ROW (v_gipi_par_mn);
        END LOOP;
        RETURN;
    END get_gipi_wcargos;

    /*    Date        Author                    Description
    **    ==========    ====================    ===================
    **    03.02.2011    xxxxxxxx                Retrieves record on GIPI_WCARGO based on the given par_id and item_no
    **    09.21.2011    mark jm                    added giis_cargo_type table to include cargo_type_desc in return
    */

    FUNCTION get_gipi_wcargos1 (
        p_par_id IN gipi_wcargo.par_id%TYPE,
        p_item_no IN gipi_wcargo.item_no%TYPE)
    RETURN gipi_wcargo_par_tab PIPELINED
    IS
        v_gipi_wcargo gipi_wcargo_par_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,                a.rec_flag,         a.print_tag,
                   a.vessel_cd,         a.geog_cd,                a.cargo_class_cd,    a.voyage_no,
                   a.bl_awb,            a.origin,                a.destn,            a.etd,
                   a.eta,                a.cargo_type,            a.deduct_text,        a.pack_method,
                   a.tranship_origin,    a.tranship_destination, a.lc_no,            a.cpi_rec_no,
                   a.cpi_branch_cd,        a.invoice_value,        a.inv_curr_cd,        a.inv_curr_rt,
                   a.markup_rate,        b.cargo_class_desc,        c.cargo_type_desc
              FROM gipi_wcargo a,
                   giis_cargo_class b,
                   giis_cargo_type c
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.cargo_class_cd = b.cargo_class_cd(+)
               AND a.cargo_type = c.cargo_type(+))
        LOOP
            v_gipi_wcargo.par_id                := i.par_id;
            v_gipi_wcargo.item_no                := i.item_no;
            v_gipi_wcargo.rec_flag                := i.rec_flag;
            v_gipi_wcargo.print_tag                := i.print_tag;
            v_gipi_wcargo.vessel_cd                := i.vessel_cd;
            v_gipi_wcargo.geog_cd                := i.geog_cd;
            v_gipi_wcargo.cargo_class_cd        := i.cargo_class_cd;
            v_gipi_wcargo.voyage_no                := i.voyage_no;
            v_gipi_wcargo.bl_awb                := i.bl_awb;
            v_gipi_wcargo.origin                := i.origin;
            v_gipi_wcargo.destn                    := i.destn;
            v_gipi_wcargo.etd                    := i.etd;
            v_gipi_wcargo.eta                    := i.eta;
            v_gipi_wcargo.cargo_type            := i.cargo_type;
            v_gipi_wcargo.cargo_type_desc        := i.cargo_type_desc;
            v_gipi_wcargo.deduct_text            := i.deduct_text;
            v_gipi_wcargo.pack_method            := i.pack_method;
            v_gipi_wcargo.tranship_origin        := i.tranship_origin;
            v_gipi_wcargo.tranship_destination    := i.tranship_destination;
            v_gipi_wcargo.lc_no                    := i.lc_no;
            v_gipi_wcargo.cpi_rec_no            := i.cpi_rec_no;
            v_gipi_wcargo.cpi_branch_cd            := i.cpi_branch_cd;
            v_gipi_wcargo.invoice_value            := i.invoice_value;
            v_gipi_wcargo.inv_curr_cd            := i.inv_curr_cd;
            v_gipi_wcargo.inv_curr_rt            := i.inv_curr_rt;
            v_gipi_wcargo.markup_rate            := i.markup_rate;
            v_gipi_wcargo.cargo_class_desc        := i.cargo_class_desc;

            PIPE ROW(v_gipi_wcargo);
        END LOOP;

        RETURN;
    END get_gipi_wcargos1;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     : Insert PAR record listing for MARINE CARGO
    */
    Procedure set_gipi_wcargo(
         p_par_id                 GIPI_WCARGO.par_id%TYPE,
         p_item_no                 GIPI_WCARGO.item_no%TYPE,
         p_print_tag            GIPI_WCARGO.print_tag%TYPE,
         p_vessel_cd            GIPI_WCARGO.vessel_cd%TYPE,
         p_geog_cd                GIPI_WCARGO.geog_cd%TYPE,
         p_cargo_class_cd        GIPI_WCARGO.cargo_class_cd%TYPE,
         p_voyage_no            GIPI_WCARGO.voyage_no%TYPE,
         p_bl_awb                GIPI_WCARGO.bl_awb%TYPE,
         p_origin                GIPI_WCARGO.origin%TYPE,
         p_destn                GIPI_WCARGO.destn%TYPE,
         p_etd                  GIPI_WCARGO.etd%TYPE,
         p_eta                    GIPI_WCARGO.eta%TYPE,
         p_cargo_type            GIPI_WCARGO.cargo_type%TYPE,
         p_deduct_text            GIPI_WCARGO.deduct_text%TYPE,
         p_pack_method            GIPI_WCARGO.pack_method%TYPE,
         p_tranship_origin        GIPI_WCARGO.tranship_origin%TYPE,
         p_tranship_destination    GIPI_WCARGO.tranship_destination%TYPE,
         p_lc_no                GIPI_WCARGO.lc_no%TYPE,
         p_invoice_value        GIPI_WCARGO.invoice_value%TYPE,
         p_inv_curr_cd          GIPI_WCARGO.inv_curr_cd%TYPE,
         p_inv_curr_rt            GIPI_WCARGO.inv_curr_rt%TYPE,
         p_markup_rate            GIPI_WCARGO.markup_rate%TYPE,
         p_rec_flag_wcargo        GIPI_WCARGO.rec_flag%TYPE,
         p_cpi_rec_no            GIPI_WCARGO.cpi_rec_no%TYPE,
         p_cpi_branch_cd        GIPI_WCARGO.cpi_branch_cd%TYPE
         )
      IS
    BEGIN
        MERGE INTO GIPI_WCARGO
        USING dual ON (par_id = p_par_id
                    AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (
                   par_id,            item_no,               print_tag,            vessel_cd,
                    geog_cd,       cargo_class_cd,     voyage_no,            bl_awb,
                    origin,           destn,               etd,                    eta,
                    cargo_type,       deduct_text,           pack_method,            tranship_origin,
                    tranship_destination,               lc_no,                invoice_value,
                    inv_curr_cd,   inv_curr_rt,           markup_rate,            rec_flag,
                    cpi_rec_no,       cpi_branch_cd
                   )
            VALUES (
                   p_par_id,      p_item_no,           p_print_tag,           p_vessel_cd,
                    p_geog_cd,      p_cargo_class_cd,    p_voyage_no,         p_bl_awb,
                   p_origin,       p_destn,                  p_etd,                 p_eta,
                   p_cargo_type,  p_deduct_text,        p_pack_method,         p_tranship_origin,
                   p_tranship_destination,                p_lc_no,               p_invoice_value,
                   p_inv_curr_cd, p_inv_curr_rt,        p_markup_rate,         p_rec_flag_wcargo,
                   p_cpi_rec_no,  p_cpi_branch_cd
                   )
        WHEN MATCHED THEN
            UPDATE SET
                   print_tag             =    p_print_tag,
                   vessel_cd               =    p_vessel_cd,
                    geog_cd                   =  p_geog_cd,
                   cargo_class_cd           =  p_cargo_class_cd,
                   voyage_no               =  p_voyage_no,
                   bl_awb                  =  p_bl_awb,
                    origin                   =  p_origin,
                   destn                   =  p_destn,
                   etd                   =  p_etd,
                   eta                      =  p_eta,
                    cargo_type             =  p_cargo_type,
                   deduct_text              =  p_deduct_text,
                   pack_method               =  p_pack_method,
                   tranship_origin          =  p_tranship_origin,
                    tranship_destination  =  p_tranship_destination,
                   lc_no                  =  p_lc_no,
                   invoice_value          =  p_invoice_value,
                    inv_curr_cd            =  p_inv_curr_cd,
                   inv_curr_rt           =  p_inv_curr_rt,
                   markup_rate           =  p_markup_rate,
                   rec_flag               =  p_rec_flag_wcargo,
                    cpi_rec_no                 =  p_cpi_rec_no,
                   cpi_branch_cd         =  p_cpi_branch_cd;
    END set_gipi_wcargo;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     : Delete PAR record listing for MARINE CARGO
    */
    Procedure del_gipi_wcargo(p_par_id    GIPI_WCARGO.par_id%TYPE,
                                p_item_no   GIPI_WCARGO.item_no%TYPE)
            IS
    BEGIN
       DELETE    GIPI_WCARGO
        WHERE    par_id   =   p_par_id
          AND    item_no  =   p_item_no;
    END;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id
    */
    Procedure DEL_GIPI_WCARGO (p_par_id IN GIPI_WCARGO.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WCARGO
         WHERE par_id = p_par_id;
    END DEL_GIPI_WCARGO;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve records from gipi_wcargo based on the given parameters
    */
    FUNCTION get_gipi_wcargo_pack_pol (
        p_par_id IN gipi_wcargo.par_id%TYPE,
        p_item_no IN gipi_wcargo.item_no%TYPE)
    RETURN gipi_wcargo_par_tab PIPELINED
    IS
        v_gipi_wcargo gipi_wcargo_par_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wcargo
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_gipi_wcargo.par_id := i.par_id;
            v_gipi_wcargo.item_no := i.item_no;

            PIPE ROW(v_gipi_wcargo);
        END LOOP;

        RETURN;
    END get_gipi_wcargo_pack_pol;
END Gipi_Wcargo_Pkg;
/


