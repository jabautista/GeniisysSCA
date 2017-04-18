CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wcasualty_Item_Pkg
AS
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.30.2010
    **  Reference By     : (GIPIS011- Item Information - Casualty)
    **  Description     : Returns PAR record listing for CASUALTY
    */
    FUNCTION get_gipi_wcasualty_items (p_par_id GIPI_WCASUALTY_ITEM.par_id%TYPE)
    RETURN gipi_wcasualty_item_tab PIPELINED  IS
        v_gipi_par_ca      gipi_wcasualty_item_type;
    BEGIN
        FOR i IN (SELECT a.par_id,                a.item_no,                a.item_title,            a.item_grp,
                         a.item_desc,            a.item_desc2,            a.tsi_amt,                a.prem_amt,
                         a.ann_prem_amt,        a.ann_tsi_amt,            a.rec_flag,                a.currency_cd,
                         a.currency_rt,            a.group_cd,                a.from_date,            a.TO_DATE,
                         a.pack_line_cd,        a.pack_subline_cd,        a.discount_sw,            a.coverage_cd,
                         a.other_info,            a.surcharge_sw,            a.region_cd,            a.changed_tag,
                         a.prorate_flag,        a.comp_sw,                a.short_rt_percent,        a.pack_ben_cd,
                         a.payt_terms,            a.risk_no,                a.risk_item_no,            b.currency_desc,
                         c.section_line_cd,        c.section_subline_cd,    c.section_or_hazard_cd, c.property_no_type,
                         c.capacity_cd,            c.property_no,            c.LOCATION,                c.conveyance_info,
                         c.limit_of_liability,    c.interest_on_premises,    c.section_or_hazard_info, c.location_cd,
                         d.coverage_desc
                   FROM  GIPI_WITEM a,
                           GIIS_CURRENCY b,
                         GIPI_WCASUALTY_ITEM c,
                         GIIS_COVERAGE d
                    WHERE  a.par_id = p_par_id
                    AND  a.currency_cd = b.main_currency_cd(+)
                    AND  a.par_id = c.par_id(+)
                       AND  a.item_no = c.item_no(+)
                       AND  a.coverage_cd = d.coverage_cd(+)
                    ORDER BY     a.par_id, a.item_no)
        LOOP
            v_gipi_par_ca.par_id            := i.par_id;
            v_gipi_par_ca.item_no            := i.item_no;
            v_gipi_par_ca.item_title        := i.item_title;
            v_gipi_par_ca.item_grp            := i.item_grp;
            v_gipi_par_ca.item_desc            := i.item_desc;
            v_gipi_par_ca.item_desc2        := i.item_desc2;
            v_gipi_par_ca.tsi_amt            := NVL(i.tsi_amt, 0);
            v_gipi_par_ca.prem_amt            := NVL(i.prem_amt, 0);
            v_gipi_par_ca.ann_prem_amt        := NVL(i.ann_prem_amt, 0);
            v_gipi_par_ca.ann_tsi_amt        := NVL(i.ann_tsi_amt, 0);
            v_gipi_par_ca.rec_flag            := i.rec_flag;
            v_gipi_par_ca.currency_cd        := i.currency_cd;
            v_gipi_par_ca.currency_rt        := i.currency_rt;
            v_gipi_par_ca.group_cd            := i.group_cd;
            v_gipi_par_ca.from_date            := i.from_date;
            v_gipi_par_ca.TO_DATE            := i.TO_DATE;
            v_gipi_par_ca.pack_line_cd        := i.pack_line_cd;
            v_gipi_par_ca.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_par_ca.discount_sw        := i.discount_sw;
            v_gipi_par_ca.coverage_cd        := i.coverage_cd;
            v_gipi_par_ca.other_info        := i.other_info;
            v_gipi_par_ca.surcharge_sw        := i.surcharge_sw;
            v_gipi_par_ca.region_cd            := i.region_cd;
            v_gipi_par_ca.changed_tag        := i.changed_tag;
            v_gipi_par_ca.prorate_flag        := i.prorate_flag;
            v_gipi_par_ca.comp_sw            := i.comp_sw;
            v_gipi_par_ca.short_rt_percent    := i.short_rt_percent;
            v_gipi_par_ca.pack_ben_cd        := i.pack_ben_cd;
            v_gipi_par_ca.payt_terms        := i.payt_terms;
            v_gipi_par_ca.risk_no            := i.risk_no;
            v_gipi_par_ca.risk_item_no        := i.risk_item_no;
            v_gipi_par_ca.section_line_cd          := i.section_line_cd;
            v_gipi_par_ca.section_subline_cd      := i.section_subline_cd;
            v_gipi_par_ca.section_or_hazard_cd    := i.section_or_hazard_cd;
            v_gipi_par_ca.property_no_type          := i.property_no_type;
            v_gipi_par_ca.capacity_cd              := i.capacity_cd;
            v_gipi_par_ca.property_no              := i.property_no;
            v_gipi_par_ca.LOCATION                  := i.LOCATION;
            v_gipi_par_ca.conveyance_info          := i.conveyance_info;
            v_gipi_par_ca.limit_of_liability      := i.limit_of_liability;
            v_gipi_par_ca.interest_on_premises      := i.interest_on_premises;
            v_gipi_par_ca.section_or_hazard_info  := i.section_or_hazard_info;
            v_gipi_par_ca.location_cd              := i.location_cd;
            v_gipi_par_ca.currency_desc        := i.currency_desc;
            v_gipi_par_ca.coverage_desc        := i.coverage_desc;
            v_gipi_par_ca.itmperl_grouped_exists := GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_exist(p_par_id, i.item_no);
        PIPE ROW (v_gipi_par_ca);
        END LOOP;
        RETURN;
    END;

    /*
    **  Created by        : mark jm
    **  Date Created     : 02.21.2011
    **  Reference By     : (GIPIS011- Item Information - Casualty)
    **  Description     : Returns PAR record listing for CASUALTY
    */
    FUNCTION get_gipi_wcasualty_items1 (
        p_par_id     IN gipi_wcasualty_item.par_id%TYPE,
        p_item_no    IN gipi_wcasualty_item.item_no%TYPE)
    RETURN gipi_wcasualty_item_par_tab PIPELINED
    IS
        v_gipi_wcasualty_item gipi_wcasualty_item_par_type;
    BEGIN
        FOR i IN (
              SELECT a.par_id,                     a.item_no,             a.section_line_cd,         a.section_subline_cd,
                     a.section_or_hazard_cd,     a.property_no_type, a.capacity_cd,             a.property_no,
                     a.location,                 a.conveyance_info,     a.limit_of_liability,    a.interest_on_premises,
                     a.section_or_hazard_info,     a.location_cd
                FROM gipi_wcasualty_item a
               WHERE a.par_id = p_par_id
                 AND a.item_no = p_item_no
            ORDER BY a.par_id, a.item_no)
        LOOP
            v_gipi_wcasualty_item.par_id                    := i.par_id;
            v_gipi_wcasualty_item.item_no                    := i.item_no;
            v_gipi_wcasualty_item.section_line_cd            := i.section_line_cd;
            v_gipi_wcasualty_item.section_subline_cd        := i.section_subline_cd;
            v_gipi_wcasualty_item.section_or_hazard_cd        := i.section_or_hazard_cd;
            v_gipi_wcasualty_item.property_no_type            := i.property_no_type;
            v_gipi_wcasualty_item.capacity_cd                := i.capacity_cd;
            v_gipi_wcasualty_item.property_no                := i.property_no;
            v_gipi_wcasualty_item.location                    := i.location;
            v_gipi_wcasualty_item.conveyance_info            := i.conveyance_info;
            v_gipi_wcasualty_item.limit_of_liability        := i.limit_of_liability;
            v_gipi_wcasualty_item.interest_on_premises        := i.interest_on_premises;
            v_gipi_wcasualty_item.section_or_hazard_info    := i.section_or_hazard_info;
            v_gipi_wcasualty_item.location_cd                := i.location_cd;
            PIPE ROW(v_gipi_wcasualty_item);
        END LOOP;

        RETURN;
    END get_gipi_wcasualty_items1;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.05.2010
    **  Reference By     : (GIPIS011- Item Information - Casualty)
    **  Description     : Inserts PAR record listing for CASUALTY
    */
    Procedure set_gipi_wcasualty_item(
              p_par_id                      GIPI_WCASUALTY_ITEM.par_id%TYPE,
              p_item_no                      GIPI_WCASUALTY_ITEM.item_no%TYPE,
              p_section_line_cd              GIPI_WCASUALTY_ITEM.section_line_cd%TYPE,
              p_section_subline_cd          GIPI_WCASUALTY_ITEM.section_subline_cd%TYPE,
              p_section_or_hazard_cd      GIPI_WCASUALTY_ITEM.section_or_hazard_cd%TYPE,
              p_property_no_type          GIPI_WCASUALTY_ITEM.property_no_type%TYPE,
              p_capacity_cd                  GIPI_WCASUALTY_ITEM.capacity_cd%TYPE,
              p_property_no                  GIPI_WCASUALTY_ITEM.property_no%TYPE,
              p_location                  GIPI_WCASUALTY_ITEM.LOCATION%TYPE,
              p_conveyance_info              GIPI_WCASUALTY_ITEM.conveyance_info%TYPE,
              p_limit_of_liability          GIPI_WCASUALTY_ITEM.limit_of_liability%TYPE,
              p_interest_on_premises      GIPI_WCASUALTY_ITEM.interest_on_premises%TYPE,
              p_section_or_hazard_info      GIPI_WCASUALTY_ITEM.section_or_hazard_info%TYPE,
              p_location_cd                  GIPI_WCASUALTY_ITEM.location_cd%TYPE
              )
        IS
    BEGIN
       MERGE INTO GIPI_WCASUALTY_ITEM
        USING dual ON (par_id       = p_par_id
                    AND item_no   = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                       item_no,                 section_line_cd,
                    section_subline_cd,         section_or_hazard_cd,    property_no_type,
                    capacity_cd,            property_no,             LOCATION,
                    conveyance_info,         limit_of_liability,         interest_on_premises,
                    section_or_hazard_info, location_cd)
            VALUES (p_par_id,                       p_item_no,                   p_section_line_cd,
                    p_section_subline_cd,         p_section_or_hazard_cd,    p_property_no_type,
                    p_capacity_cd,                p_property_no,               p_location,
                    p_conveyance_info,             p_limit_of_liability,       p_interest_on_premises,
                    p_section_or_hazard_info,     p_location_cd)
        WHEN MATCHED THEN
            UPDATE SET
                    section_line_cd             = p_section_line_cd,
                    section_subline_cd          = p_section_subline_cd,
                    section_or_hazard_cd        = p_section_or_hazard_cd,
                    property_no_type            = p_property_no_type,
                    capacity_cd                    = p_capacity_cd,
                    property_no                    = p_property_no,
                    LOCATION                    = p_location,
                    conveyance_info                = p_conveyance_info,
                    limit_of_liability            = p_limit_of_liability,
                    interest_on_premises        = p_interest_on_premises,
                    section_or_hazard_info        = p_section_or_hazard_info,
                    location_cd                    = p_location_cd;
    END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.05.2010
    **  Reference By     : (GIPIS011- Item Information - Casualty)
    **  Description     : Delete per item no PAR record listing for CASUALTY
    */
    Procedure del_gipi_wcasualty_item(
              p_par_id    GIPI_WCASUALTY_ITEM.par_id%TYPE,
                p_item_no   GIPI_WCASUALTY_ITEM.item_no%TYPE
              )
        IS
    BEGIN
      DELETE GIPI_WCASUALTY_ITEM
       WHERE PAR_ID  =  p_par_id
         AND ITEM_NO =  p_item_no;
    END;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id
    */
    Procedure del_gipi_wcasualty_item (p_par_id IN GIPI_WCASUALTY_ITEM.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WCASUALTY_ITEM
         WHERE par_id = p_par_id;
    END del_gipi_wcasualty_item;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve rows from gipi_wcasualty_item based on the given parameters
    */
    FUNCTION get_gipi_wcasualty_pack_pol (
        p_par_id IN gipi_wcasualty_item.par_id%TYPE,
        p_item_no IN gipi_wcasualty_item.item_no%TYPE)
    RETURN gipi_wcasualty_item_par_tab PIPELINED
    IS
        v_gipi_wcasualty_item gipi_wcasualty_item_par_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wcasualty_item
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_gipi_wcasualty_item.par_id    := i.par_id;
            v_gipi_wcasualty_item.item_no    := i.item_no;

            PIPE ROW(v_gipi_wcasualty_item);
        END LOOP;

        RETURN;
    END get_gipi_wcasualty_pack_pol;
END;
/


