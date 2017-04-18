CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wengg_Item_Pkg
AS
    /*
    **  Created by        : D. Alcantara
    **  Date Created     : 10.19.2010
    **  Reference By     : (GIPIS004- Item Information - Engineering)
    **  Description     : Returns PAR record listing for ENGINEERING
    */

    FUNCTION get_gipi_wengg_item (p_par_id GIPI_WITEM.par_id%TYPE)
    RETURN gipi_wengineering_tab PIPELINED IS
        v_gipi_par_en   gipi_wengineering_type;
    BEGIN
        FOR i IN (SELECT a.par_id,                a.item_no,                a.item_title,            a.item_grp,
                         a.item_desc,            a.item_desc2,            a.tsi_amt,                a.prem_amt,
                         a.ann_prem_amt,        a.ann_tsi_amt,            a.rec_flag,                a.currency_cd,
                         a.currency_rt,            a.group_cd,                a.from_date,            a.TO_DATE,
                         a.pack_line_cd,        a.pack_subline_cd,        a.discount_sw,            a.coverage_cd,
                         a.other_info,            a.surcharge_sw,            a.region_cd,            a.changed_tag,
                         a.prorate_flag,        a.comp_sw,                a.short_rt_percent,        a.pack_ben_cd,
                         a.payt_terms,            a.risk_no,                a.risk_item_no,            b.currency_desc
                 FROM gipi_witem a,
                      giis_currency b,
                      giis_coverage c
                 WHERE  a.par_id = p_par_id
                        AND  a.currency_cd = b.main_currency_cd(+)
                        AND  a.coverage_cd = c.coverage_cd(+)
                    ORDER BY     a.par_id, a.item_no)
        LOOP
            v_gipi_par_en.par_id            := i.par_id;
            v_gipi_par_en.item_no            := i.item_no;
            v_gipi_par_en.item_title        := i.item_title;
            v_gipi_par_en.item_grp            := i.item_grp;
            v_gipi_par_en.item_desc            := i.item_desc;
            v_gipi_par_en.item_desc2        := i.item_desc2;
            v_gipi_par_en.tsi_amt            := NVL(i.tsi_amt, 0);
            v_gipi_par_en.prem_amt            := NVL(i.prem_amt, 0);
            v_gipi_par_en.ann_prem_amt        := NVL(i.ann_prem_amt, 0);
            v_gipi_par_en.ann_tsi_amt        := NVL(i.ann_tsi_amt, 0);
            v_gipi_par_en.rec_flag            := i.rec_flag;
            v_gipi_par_en.currency_cd        := i.currency_cd;
            v_gipi_par_en.currency_rt        := i.currency_rt;
            v_gipi_par_en.group_cd            := i.group_cd;
            v_gipi_par_en.from_date            := i.from_date;
            v_gipi_par_en.TO_DATE            := i.TO_DATE;
            v_gipi_par_en.pack_line_cd        := i.pack_line_cd;
            v_gipi_par_en.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_par_en.discount_sw        := i.discount_sw;
            v_gipi_par_en.coverage_cd        := i.coverage_cd;
            v_gipi_par_en.other_info        := i.other_info;
            v_gipi_par_en.surcharge_sw        := i.surcharge_sw;
            v_gipi_par_en.region_cd            := i.region_cd;
            v_gipi_par_en.changed_tag        := i.changed_tag;
            v_gipi_par_en.prorate_flag        := i.prorate_flag;
            v_gipi_par_en.comp_sw            := i.comp_sw;
            v_gipi_par_en.short_rt_percent    := i.short_rt_percent;
            v_gipi_par_en.pack_ben_cd        := i.pack_ben_cd;
            v_gipi_par_en.payt_terms        := i.payt_terms;
            v_gipi_par_en.risk_no            := i.risk_no;
            v_gipi_par_en.risk_item_no        := i.risk_item_no;
            v_gipi_par_en.currency_desc      := i.currency_desc;
            v_gipi_par_en.itmperl_grouped_exists := GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_exist(p_par_id, i.item_no);
          PIPE ROW (v_gipi_par_en);
        END LOOP;
        RETURN;
    END get_gipi_wengg_item;

END;
/


