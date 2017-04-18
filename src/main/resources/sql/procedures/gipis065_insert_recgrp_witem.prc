DROP PROCEDURE CPI.GIPIS065_INSERT_RECGRP_WITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_INSERT_RECGRP_WITEM (
    p_par_id IN gipi_wpolbas.par_id%TYPE,
    p_item_no IN gipi_witem.item_no%TYPE,
    p_prem_amt OUT gipi_witem.prem_amt%TYPE,
    p_tsi_amt OUT gipi_witem.tsi_amt%TYPE,
    p_ann_prem_amt OUT gipi_witem.ann_prem_amt%TYPE,
    p_ann_tsi_amt OUT gipi_witem.ann_tsi_amt%TYPE,
    p_gipi_witmperl OUT gipi_witmperl_pkg.rc_gipi_witmperl)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : inserts records from grouped tables(witemperil_grouped, wgrouped_items)
    **                     : to witemperil and witem,
    **                     : created for distribution process(GIUWS004)
    */
    v_policy_id gipi_polbasic.policy_id%TYPE;
    v_exists NUMBER := 0;
    v_exists2 NUMBER := 0;
    v_exists3 NUMBER := 0;
    vtot_ann_tsi_amt  gipi_witmperl.ann_tsi_amt%TYPE;
    vtot_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE;
    vtot_item_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE :=0;
    vtot_item_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE :=0;
    vg1_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE := 0;
    vg1_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE := 0;
    v2_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE := 0;
    v2_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE := 0;
    v_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE := 0;
    v_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE := 0;
    v_tsi_amt gipi_witmperl.tsi_amt%TYPE :=0;
    v_prem_amt gipi_witmperl.prem_amt%TYPE :=0;
    v_item_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE := 0;
    v_item_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE := 0;
    v_prem_rt           gipi_witmperl.prem_rt%TYPE;
BEGIN
    IF GIPIS065_CHECK_PERILS(p_par_id, p_item_no) != 'Y' THEN
        FOR i IN (
            SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no,
                   eff_date
              FROM gipi_wpolbas
             WHERE par_id = p_par_id)
        LOOP
            FOR j IN (
                SELECT a.policy_id policy_id, ann_tsi_amt, ann_prem_amt
                  FROM gipi_polbasic a
                 WHERE a.line_cd     =  i.line_cd
                   AND a.iss_cd      =  i.iss_cd
                   AND a.subline_cd  =  i.subline_cd
                   AND a.issue_yy    =  i.issue_yy
                   AND a.pol_seq_no  =  i.pol_seq_no
                   AND a.renew_no    =  i.renew_no
                   AND a.pol_flag    IN ('1','2','3','X')
                   AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                   AND NVL(a.endt_expiry_date,a.expiry_date) >= i.eff_date
              ORDER BY endt_seq_no DESC)
            LOOP
                v_policy_id := j.policy_id;
                EXIT;
            END LOOP;

            FOR x IN (
                SELECT peril_cd
                  FROM gipi_witmperl
                 WHERE par_id  = p_par_id
                   AND item_no = p_item_no)
            LOOP
                v_exists3 := 1;
                FOR y IN (
                    SELECT peril_cd
                      FROM gipi_witmperl_grouped
                     WHERE par_id     = p_par_id
                       AND item_no  = p_item_no
                       AND peril_cd = x.peril_cd)
                LOOP
                    v_exists3 := 0;
                    EXIT;
                END LOOP;

                IF v_exists3 = 1 THEN
                    DELETE FROM gipi_witmperl
                     WHERE par_id   = p_par_id
                       AND item_no  = p_item_no
                       AND peril_cd = x.peril_cd;
                END IF;
            END LOOP;
            
            FOR j IN (
                SELECT SUM(tsi_amt) tsi_amt,SUM(prem_amt) prem_amt,a.peril_cd, item_no, b.peril_type peril_type
                  FROM gipi_witmperl_grouped a, GIIS_PERIL b
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND a.peril_cd = b.peril_cd
                   AND a.line_cd = b.line_cd
              GROUP BY a.peril_cd, a.item_no,b.peril_type)
            LOOP
                vtot_ann_tsi_amt    := NULL;
                vtot_ann_prem_amt    := NULL;
                vg1_ann_tsi_amt        := 0;
                vg1_ann_prem_amt    := 0;
                v2_ann_tsi_amt        := 0;
                v2_ann_prem_amt        := 0;
                v_exists2            := 1;
                v_ann_tsi_amt         := 0;
                v_ann_prem_amt         := 0;

                FOR exsts IN (
                    SELECT 1
                      FROM gipi_witmperl
                     WHERE par_id   = p_par_id
                       AND item_no  = p_item_no
                       AND peril_cd = j.peril_cd)
                LOOP
                    v_exists := 1;
                    EXIT;
                 END LOOP;

                FOR g1 IN (
                    SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt, grouped_item_no
                      FROM gipi_witmperl_grouped
                     WHERE par_id   = p_par_id
                       AND item_no  = p_item_no
                       AND peril_cd = j.peril_cd)
                LOOP
                     vg1_ann_tsi_amt  := vg1_ann_tsi_amt + g1.ann_tsi_amt;
                    vg1_ann_prem_amt := vg1_ann_prem_amt + g1.ann_prem_amt;
                     FOR g2 IN (
                        SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt
                          FROM gipi_itmperil_grouped
                         WHERE policy_id = v_policy_id
                           AND item_no = p_item_no
                           AND grouped_item_no = g1.grouped_item_no
                           AND peril_cd = j.peril_cd)
                    LOOP
                        vg1_ann_tsi_amt   := g1.ann_tsi_amt - g2.ann_tsi_amt;
                        vg1_ann_prem_amt  := g1.ann_prem_amt - g2.ann_prem_amt;
                        vtot_ann_tsi_amt  := NVL(vtot_ann_tsi_amt,0) + vg1_ann_tsi_amt;
                        vtot_ann_prem_amt := NVL(vtot_ann_prem_amt,0) + vg1_ann_prem_amt;
                    END LOOP;
                 END LOOP;

                FOR g IN (
                    SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt
                      FROM gipi_itmperil
                     WHERE policy_id = v_policy_id
                       AND item_no   = p_item_no
                       AND peril_cd  = j.peril_cd)
                LOOP
                    v2_ann_tsi_amt  := g.ann_tsi_amt;
                    v2_ann_prem_amt := g.ann_prem_amt;
                 END LOOP;

                v_ann_tsi_amt  := v2_ann_tsi_amt + NVL(vtot_ann_tsi_amt,vg1_ann_tsi_amt);
                v_ann_prem_amt := v2_ann_prem_amt + NVL(vtot_ann_prem_amt,vg1_ann_prem_amt);
                
                v_prem_rt := 0;
                IF NVL(j.TSI_AMT,0) != 0 THEN
                    v_prem_rt := (NVL(j.prem_amt,0)*100)/j.TSI_AMT;
                END IF;
                IF v_exists = 1 THEN
                    UPDATE gipi_witmperl
                       SET tsi_amt  = NVL(j.tsi_amt,0),
                                prem_amt = NVL(j.prem_amt,0),
                                ann_tsi_amt  = NVL(v_ann_tsi_amt,0),
                                ann_prem_amt = NVL(v_ann_prem_amt,0)
                     WHERE par_id   = p_par_id
                       AND item_no  = p_item_no
                       AND line_cd  = i.line_cd
                       AND peril_cd = j.peril_cd;
                     v_exists := 0;
                ELSE
                    INSERT INTO gipi_witmperl (
                        par_id, item_no, line_cd, peril_cd,
                        tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, prem_rt)
                    VALUES (
                        p_par_id, p_item_no, i.line_cd,j.peril_cd,
                        NVL(j.TSI_AMT,0), NVL(j.prem_amt,0), NVL(v_ann_tsi_amt,0), NVL(v_ann_prem_amt,0),
                        v_prem_rt);
                END IF;

                IF j.peril_type = 'B' THEN
                    v_tsi_amt := NVL(j.tsi_amt,0) + v_tsi_amt;
                    vtot_item_ann_tsi_amt := vtot_item_ann_tsi_amt + NVL(vtot_ann_tsi_amt,vg1_ann_tsi_amt); -- gmi 09/22/06
                END IF;

                v_prem_amt := NVL(j.prem_amt,0) + v_prem_amt;
                vtot_item_ann_prem_amt := vtot_item_ann_prem_amt + NVL(vtot_ann_prem_amt,vg1_ann_prem_amt); -- gmi 09/22/06
            END LOOP;

            IF v_exists2 = 1 THEN
                v_item_ann_tsi_amt  := 0;
                v_item_ann_prem_amt := 0;

                FOR g IN (
                    SELECT ann_tsi_amt, ann_prem_amt
                      FROM gipi_item
                     WHERE policy_id = v_policy_id
                       AND item_no   = p_item_no)
                LOOP
                    v_item_ann_tsi_amt  := g.ann_tsi_amt;
                    v_item_ann_prem_amt := g.ann_prem_amt;
                END LOOP;
                                
                p_tsi_amt        := v_tsi_amt;
                p_prem_amt        := v_prem_amt;
                p_ann_tsi_amt    := v_item_ann_tsi_amt + vtot_item_ann_tsi_amt;
                p_ann_prem_amt    := v_item_ann_prem_amt + vtot_item_ann_prem_amt;
                -- added by d.alcantara, 05-15-2012,to add values to amts in gipi_witem
                
                UPDATE gipi_witem
                   SET tsi_amt = p_tsi_amt,
                       prem_amt = p_prem_amt,
                       ann_tsi_amt = p_ann_tsi_amt,
                       ann_prem_amt = p_ann_prem_amt
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no;

                IF NVL(v_tsi_amt,0) <> 0 THEN
                    cr_bill_dist.get_tsi(p_par_id);
                END IF;
            ELSE
                p_tsi_amt        := 0;
                p_prem_amt        := 0;
                p_ann_tsi_amt    := 0;
                p_ann_prem_amt    := 0;
                
                UPDATE gipi_witem
                   SET tsi_amt = p_tsi_amt,
                       prem_amt = p_prem_amt,
                       ann_tsi_amt = p_ann_tsi_amt,
                       ann_prem_amt = p_ann_prem_amt
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no;

                IF NVL(v_tsi_amt,0) <> 0 THEN

                 cr_bill_dist.get_tsi(p_par_id);
                END IF;
            END IF;
        END LOOP;
    END IF;

    OPEN p_gipi_witmperl FOR
    SELECT *
      FROM gipi_witmperl
     WHERE par_id = p_par_id
       AND item_no = p_item_no;
END GIPIS065_INSERT_RECGRP_WITEM;
/


