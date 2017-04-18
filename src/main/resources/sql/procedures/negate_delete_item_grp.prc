DROP PROCEDURE CPI.NEGATE_DELETE_ITEM_GRP;

CREATE OR REPLACE PROCEDURE CPI.NEGATE_DELETE_ITEM_GRP (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
	p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
	p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
	p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
	p_renew_no IN gipi_wpolbas.renew_no%TYPE,
	p_eff_date IN gipi_wpolbas.eff_date%TYPE,
	p_comp_sw IN gipi_wpolbas.comp_sw%TYPE,
	p_prorate_flag IN gipi_wpolbas.prorate_flag%TYPE,
	p_endt_expiry_date IN gipi_wpolbas.endt_expiry_date%TYPE,
    p_item_no IN gipi_witem.item_no%TYPE,
    p_changed_tag IN gipi_witem.changed_tag%TYPE,
    p_item_prorate_flag IN gipi_witem.prorate_flag%TYPE,
    p_item_comp_sw IN gipi_witem.comp_sw%TYPE,
    p_item_from_date IN gipi_witem.from_date%TYPE,
    p_item_to_date IN gipi_witem.to_date%TYPE,
    p_grouped_item_no IN gipi_wgrouped_items.grouped_item_no%TYPE,
    p_grp_from_date IN gipi_wgrouped_items.from_date%TYPE,
    p_grp_to_date IN gipi_wgrouped_items.to_date%TYPE,
    p_prem_amt OUT gipi_wgrouped_items.prem_amt%TYPE,
    p_tsi_amt OUT gipi_wgrouped_items.tsi_amt%TYPE,
    p_ann_prem_amt OUT gipi_wgrouped_items.ann_prem_amt%TYPE,
    p_ann_tsi_amt OUT gipi_wgrouped_items.ann_tsi_amt%TYPE,
    p_gipi_witmperl_grouped OUT endt_ref_cursor_pkg.rc_gipi_witmperl_grouped)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 05.09.2011
    **  Reference By     : (GIPIS065 - Endt Item Information - Accident)
    **  Description     : This procedure is used for negating/deleting records in gipi_witmperl_grouped table
    */
    v_short_rt_percent gipi_witem.short_rt_percent%TYPE;
    v_prorate NUMBER:=0;
    v_prem_amt NUMBER:=0;
BEGIN
    FOR A1 IN (
        SELECT b.line_cd, b.peril_cd, sum(b.tsi_amt) tsi_amt, sum(b.prem_amt) prem_amt
          FROM gipi_itmperil_grouped b
         WHERE EXISTS (
                    SELECT '1'
                      FROM gipi_polbasic a
                     WHERE a.line_cd = p_line_cd
                       AND a.iss_cd = p_iss_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.issue_yy = p_issue_yy
                       AND a.pol_seq_no = p_pol_seq_no
                       AND a.renew_no = p_renew_no
                       AND a.pol_flag IN ( '1','2','3','X')
                       AND TRUNC(a.eff_date) <= TRUNC(p_eff_date)
                       AND NVL(a.endt_expiry_date, a.expiry_date) >= p_eff_date
                       AND a.policy_id = b.policy_id)
           AND b.item_no = p_item_no
           AND b.grouped_item_no = p_grouped_item_no
      GROUP BY b.line_cd, b.peril_cd)
    LOOP
        FOR i IN (
            SELECT short_rt_percent
              FROM gipi_witem
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_short_rt_percent := i.short_rt_percent;
        END LOOP;
        IF p_changed_tag = 'Y' THEN
            IF p_item_prorate_flag = '1' THEN
                IF p_item_comp_sw = 'Y' THEN
                    v_prorate := ((TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))) - TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date) ))) + 1 )/
                                   check_duration(TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date))),TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))));
                ELSIF p_comp_sw = 'M' THEN
                    v_prorate := ((TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))) - TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date) ))) - 1 )/
                                   check_duration(TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date))),TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))));
                ELSE
                    v_prorate := ((TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))) - TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date) ))) )/
                                   check_duration(TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date))),TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))));
                END IF;
                v_prem_amt := a1.prem_amt * v_prorate;
            ELSIF p_prorate_flag = 2 THEN
                v_prem_amt := a1.prem_amt;
            ELSE
                v_prem_amt :=  (NVL(a1.prem_amt,0) * NVL(v_short_rt_percent/100,1));
            END IF;
        ELSE
            IF p_prorate_flag = '1' THEN
                IF p_item_comp_sw = 'Y' THEN
                    v_prorate  :=  ((TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))) - TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date) ))) + 1 )/
                               check_duration(TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date))),TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))));
                ELSIF p_comp_sw = 'M' THEN
                    v_prorate  :=  ((TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))) - TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date) ))) - 1 )/
                               check_duration(TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date))),TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))));
                ELSE
                    v_prorate  :=  ((TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))) - TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date) ))) )/
                               check_duration(TRUNC(NVL(p_grp_from_date, NVL(p_item_from_date, p_eff_date))),TRUNC(NVL(p_grp_to_date, NVL(p_item_to_date, p_endt_expiry_date))));
                END IF;
                v_prem_amt := a1.prem_amt * v_prorate;
            ELSIF p_prorate_flag = 2 THEN
                v_prem_amt := a1.prem_amt;
            ELSE
                v_prem_amt :=  (NVL(a1.prem_amt,0) * NVL(v_short_rt_percent/100,1));
            END IF;
        END IF;
        IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0 THEN
            INSERT INTO gipi_witmperl_grouped (
                par_id ,    item_no,       grouped_item_no,        line_cd ,        peril_cd,
                prem_rt,    tsi_amt,       prem_amt,              ann_tsi_amt,    ann_prem_amt,
                rec_flag)
            VALUES (
                p_par_id,    p_item_no,         p_grouped_item_no,     a1.line_cd,     a1.peril_cd,
                0,            -(a1.tsi_amt),     -(v_prem_amt),         0,                 0,
                'D');
        END IF;
    END LOOP;
    FOR A IN (
        SELECT SUM(DECODE(b.peril_type, 'B',a.tsi_amt,0)) tsi, SUM(a.prem_amt) prem
          FROM gipi_witmperl_grouped a, giis_peril b
         WHERE a.par_id = p_par_id
           AND a.item_no = p_item_no
           AND a.grouped_item_no = p_grouped_item_no
           AND a.peril_cd = b.peril_cd
           AND a.line_cd = b.line_cd)
    LOOP
        p_prem_amt        := a.prem;
        p_tsi_amt        := a.tsi;
        p_ann_prem_amt     := 0;
        p_ann_tsi_amt      := 0;
    END LOOP;
	
	-- added by: Nica 10/12/2012 - to update the amount covered to zero when grouped item is negated
	UPDATE GIPI_WGROUPED_ITEMS 
	   SET amount_covered = 0
	 WHERE par_id = p_par_id
       AND item_no = p_item_no
       AND grouped_item_no = p_grouped_item_no;

    OPEN p_gipi_witmperl_grouped FOR
    SELECT a.par_id,         a.item_no,                a.grouped_item_no,
             a.line_cd,           a.peril_cd,                 a.rec_flag,
             a.no_of_days,       a.prem_rt,                a.tsi_amt,
             a.prem_amt,       a.ann_tsi_amt,            a.ann_prem_amt,
             a.aggregate_sw,   a.base_amt,                a.ri_comm_rate,
             a.ri_comm_amt,
             b.peril_name,        b.peril_type, c.grouped_item_title, b.peril_type
        FROM GIPI_WITMPERL_GROUPED a,
             GIIS_PERIL b,
             GIPI_WGROUPED_ITEMS c
       WHERE a.par_id = p_par_id
           AND a.item_no = p_item_no
           AND a.grouped_item_no = p_grouped_item_no
           AND a.par_id = c.par_id
           AND a.item_no = c.item_no
           AND a.grouped_item_no = c.grouped_item_no
           AND a.peril_cd = b.peril_cd
           AND a.line_cd = b.line_cd
       ORDER BY par_id,item_no,grouped_item_no;
END NEGATE_DELETE_ITEM_GRP;
/


