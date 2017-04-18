DROP PROCEDURE CPI.NEGATE_DELETE_ITEM_ENDT;

CREATE OR REPLACE PROCEDURE CPI.NEGATE_DELETE_ITEM_ENDT (
	p_par_id		IN gipi_wpolbas.par_id%TYPE,
	p_item_no		IN gipi_witem.item_no%TYPE,
	p_prem_amt		OUT gipi_witem.prem_amt%TYPE,
	p_tsi_amt		OUT gipi_witem.tsi_amt%TYPE,
	p_ann_prem_amt	OUT gipi_witem.ann_prem_amt%TYPE,
	p_ann_tsi_amt	OUT gipi_witem.ann_tsi_amt%TYPE,
	p_gipi_witmperl	OUT gipi_witmperl_pkg.rc_gipi_witmperl)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 11.05.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - Casualty)
	**  Description     : This procedure is used for negating records in GIPI_WITMPERL table
    */
    v_comp_var        NUMBER;
    v_prorate        NUMBER;
    v_short_rt        NUMBER;
    v_tsi_amt        gipi_witmperl.tsi_amt%TYPE;
    v_prem_amt        gipi_witmperl.prem_amt%TYPE;
    v_ann_tsi_amt    gipi_witmperl.ann_tsi_amt%TYPE;
    v_ann_prem_amt    gipi_witmperl.ann_prem_amt%TYPE;
    v_prem_rt        gipi_witmperl.prem_rt%TYPE;
    --additional variables : edgar 01/21/2015
    v_ri_comm_rate   gipi_witmperl.ri_comm_rate%TYPE;
    v_tolerance      NUMBER := 1;
    v_comm_diff      gipi_witmperl.prem_amt%TYPE;
BEGIN
    FOR i IN (
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
               incept_date, expiry_date, eff_date, endt_expiry_date, 
               prorate_flag, comp_sw, short_rt_percent
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        DELETE FROM gipi_witmperl
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
        IF i.prorate_flag <> '2' THEN
            /* pro-rated or short rate */
            IF NVL(i.comp_sw, 'N') = 'N' THEN
                v_comp_var := 0;
            ELSIF NVL(i.comp_sw, 'N') = 'Y' THEN
                v_comp_var := 1;
            ELSE
                v_comp_var := -1;
            END IF;
            --added NVL to i.endt_expiry_date : edgar 01/22/2015
            v_prorate := (TRUNC(NVL(i.endt_expiry_date,i.expiry_date)) - TRUNC(i.eff_date) + v_comp_var) / check_duration(i.incept_date, i.expiry_date);
            v_short_rt := NVL(i.short_rt_percent, 1) / 100;
            FOR A1 IN (
                SELECT b.line_cd, b.peril_cd, SUM(b.tsi_amt) tsi_amt, SUM(b.prem_amt) prem_amt, SUM(b.ri_comm_amt) ri_comm_amt --edgar 01/21/2015
                  FROM gipi_itmperil b
                 WHERE EXISTS (
                            SELECT '1'
                              FROM gipi_polbasic a
                             WHERE a.line_cd = i.line_cd
                               AND a.iss_cd = i.iss_cd
                               AND a.subline_cd = i.subline_cd
                               AND a.issue_yy = i.issue_yy
                               AND a.pol_seq_no = i.pol_seq_no
                               AND a.renew_no = i.renew_no
                               AND a.pol_flag IN ('1', '2', '3', 'X') --added expired policies : edgar 01/20/2015
                               AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                               AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >= TRUNC(i.eff_date) --edgar 01/20/2015
                               AND a.policy_id = b.policy_id)
                   AND b.item_no = p_item_no
              GROUP BY b.line_cd, b.peril_cd)
            LOOP
                IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0 THEN
                    /*added edgar 01/21/2015 to get the latest ri_comm_rate*/
                    FOR pol IN (
                        SELECT   a.endt_seq_no, a.policy_id, b.ri_comm_rate
                          FROM gipi_polbasic a, gipi_itmperil b
                         WHERE a.line_cd = i.line_cd
                           AND a.iss_cd = i.iss_cd
                           AND a.subline_cd = i.subline_cd
                           AND a.issue_yy = i.issue_yy
                           AND a.pol_seq_no = i.pol_seq_no
                           AND a.renew_no = i.renew_no
                           AND a.pol_flag IN ('1', '2', '3', 'X')
                           AND TRUNC (a.eff_date) <= TRUNC (i.eff_date)
                           AND TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                                               TRUNC (i.eff_date)
                           AND a.policy_id = b.policy_id
                           AND a.line_cd = b.line_cd
                           AND b.item_no = p_item_no
                           AND b.peril_cd = a1.peril_cd
                      ORDER BY a.eff_date DESC)
                    LOOP
                        v_ri_comm_rate := pol.ri_comm_rate;
                        EXIT;
                    END LOOP;
                    v_comm_diff := (a1.prem_amt*(v_ri_comm_rate/100))-a1.ri_comm_amt;
                    IF ABS(v_comm_diff) >  v_tolerance THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#RI commission amount cannot be greater than the accumulated RI commission net of endorsement.');
                    END IF;
                    /*ended edgar 01/21/2015*/   
                    BEGIN
                        IF i.prorate_flag = '1' THEN
                            v_prem_amt     := a1.prem_amt * v_prorate;
                            v_tsi_amt     := a1.tsi_amt * v_prorate;
                        ELSE
                            v_prem_amt     := a1.prem_amt * v_short_rt;
                            v_tsi_amt    := a1.tsi_amt * v_short_rt;
                        END IF;
                        IF TRUNC(i.endt_expiry_date) <> TRUNC(i.expiry_date) THEN
                            v_ann_prem_amt    := a1.prem_amt - v_prem_amt;
                            v_ann_tsi_amt    := a1.tsi_amt - v_tsi_amt;
                        ELSE
                            v_ann_prem_amt    := 0;
                            v_ann_tsi_amt    := 0;
                            v_tsi_amt        := a1.tsi_amt;                        
                        END IF;
                    END;
                    INSERT INTO gipi_witmperl (
                        par_id,     item_no,    line_cd,    peril_cd,        discount_sw,
                        prem_rt,    tsi_amt,    prem_amt,    ann_tsi_amt,    ann_prem_amt,
                        prt_flag,    rec_flag,      ri_comm_rate,       ri_comm_amt)--edgar 10/21/2014
                    VALUES (
                        p_par_id,    p_item_no,        a1.line_cd,        a1.peril_cd,    'N',
                        0,            -(v_tsi_amt),    -(v_prem_amt),    v_ann_tsi_amt,    v_ann_prem_amt,
                        '1',        'D',        v_ri_comm_rate,         -(a1.ri_comm_amt));--edgar 10/21/2014
                END IF;
            END LOOP;
        ELSE
            /* annual computation */
            FOR A1 IN (
                SELECT b.line_cd, b.peril_cd, SUM(b.tsi_amt) tsi_amt, SUM(b.prem_amt) prem_amt, SUM(b.ri_comm_amt) ri_comm_amt --edgar 01/21/2015
                  FROM gipi_itmperil b
                 WHERE EXISTS (
                            SELECT '1'
                              FROM gipi_polbasic a
                             WHERE a.line_cd = i.line_cd
                               AND a.iss_cd = i.iss_cd
                               AND a.subline_cd = i.subline_cd
                               AND a.issue_yy = i.issue_yy
                               AND a.pol_seq_no = i.pol_seq_no
                               AND a.renew_no = i.renew_no
                               AND a.pol_flag IN ('1', '2', '3', 'X') --added expired policies : edgar 01/20/2015
                               AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                               AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >= TRUNC(i.eff_date) --edgar 01/20/2015
                               AND a.policy_id = b.policy_id)
                   AND b.item_no = p_item_no
              GROUP BY b.line_cd, b.peril_cd)
            LOOP
                IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0 THEN
                    /*added edgar 01/21/2015 to get the latest ri_comm_rate*/
                    FOR pol IN (
                        SELECT   a.endt_seq_no, a.policy_id, b.ri_comm_rate
                          FROM gipi_polbasic a, gipi_itmperil b
                         WHERE a.line_cd = i.line_cd
                           AND a.iss_cd = i.iss_cd
                           AND a.subline_cd = i.subline_cd
                           AND a.issue_yy = i.issue_yy
                           AND a.pol_seq_no = i.pol_seq_no
                           AND a.renew_no = i.renew_no
                           AND a.pol_flag IN ('1', '2', '3', 'X')
                           AND TRUNC (a.eff_date) <= TRUNC (i.eff_date)
                           AND TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                                               TRUNC (i.eff_date)
                           AND a.policy_id = b.policy_id
                           AND a.line_cd = b.line_cd
                           AND b.item_no = p_item_no
                           AND b.peril_cd = a1.peril_cd
                      ORDER BY a.eff_date DESC)
                    LOOP
                        v_ri_comm_rate := pol.ri_comm_rate;
                        EXIT;
                    END LOOP;
                    v_comm_diff := (a1.prem_amt*(v_ri_comm_rate/100))-a1.ri_comm_amt;
                    IF ABS(v_comm_diff) >  v_tolerance THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#RI commission amount cannot be greater than the accumulated RI commission net of endorsement.');
                    END IF;
                    /*ended edgar 01/21/2015*/    
                    INSERT INTO gipi_witmperl (
                        par_id,        item_no,    line_cd,    peril_cd,         discount_sw,
                        prem_rt,    tsi_amt,    prem_amt,    ann_tsi_amt,    ann_prem_amt,
                        prt_flag,    rec_flag,      ri_comm_rate,       ri_comm_amt)--edgar 10/21/2014
                    VALUES (
                        p_par_id,    p_item_no,        a1.line_cd,        a1.peril_cd,    'N',
                        0,            -(a1.tsi_amt),    -(a1.prem_amt),    0,                0,
                        '1',        'D',        v_ri_comm_rate,         -(a1.ri_comm_amt));--edgar 10/21/2014
                END IF;
            END LOOP;
        END IF;
        IF i.prorate_flag <> '2' AND TRUNC(i.endt_expiry_date) <> TRUNC(i.expiry_date) THEN
            FOR A1 IN (
                SELECT b.line_cd, SUM(DECODE(a.peril_type, 'B', b.tsi_amt, 0)) tsi_amt, SUM(b.prem_amt) prem_amt
                  FROM gipi_itmperil b, giis_peril a
                 WHERE EXISTS (
                            SELECT '1'
                              FROM gipi_polbasic p
                             WHERE p.line_cd = i.line_cd
                               AND p.iss_cd = i.iss_cd
                               AND p.subline_cd = i.subline_cd
                               AND p.issue_yy = i.issue_yy
                               AND p.pol_seq_no = i.pol_seq_no
                               AND p.renew_no = i.renew_no
                               AND p.pol_flag IN ('1', '2', '3', 'X') --added expired policies : edgar 01/20/2015
                               AND TRUNC(p.eff_date) <= TRUNC(i.eff_date)
                               AND TRUNC(NVL(p.endt_expiry_date,p.expiry_date)) >= TRUNC(i.eff_date) --edgar 01/20/2015
                               AND p.policy_id = b.policy_id)
                   AND b.item_no = p_item_no
                   AND a.peril_cd = b.peril_cd
                   AND a.line_cd = b.line_cd
              GROUP BY b.line_cd)
            LOOP
                FOR A IN (
                    SELECT SUM(DECODE(b.peril_type, 'B', a.tsi_amt, 0)) tsi, SUM(a.prem_amt) prem_amt
                      FROM gipi_witmperl a, giis_peril b
                     WHERE a.par_id = p_par_id
                       AND a.item_no = p_item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.line_cd = b.line_cd)
                LOOP
                    p_prem_amt        := a.prem_amt;
                    p_tsi_amt        := a.tsi;
                    p_ann_prem_amt    := a1.prem_amt + a.prem_amt;
                    p_ann_tsi_amt    := a1.tsi_amt + a.tsi;
                END LOOP;
            END LOOP;
        ELSE
            FOR A IN (
                SELECT SUM(DECODE(b.peril_type, 'B', a.tsi_amt, 0)) tsi, SUM(a.prem_amt) prem
                  FROM gipi_witmperl a, giis_peril b
                 WHERE a.par_id = p_par_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = b.peril_cd
                   AND a.line_cd = b.line_cd)
            LOOP
                p_prem_amt        := a.prem;
                p_tsi_amt        := a.tsi;
                p_ann_prem_amt    := 0;
                p_ann_tsi_amt    := 0;
            END LOOP;
        END IF;
    END LOOP;
    OPEN p_gipi_witmperl FOR
    SELECT *
      FROM gipi_witmperl
     WHERE par_id = p_par_id
       --AND item_no = p_item_no; --commented out edgar 10/21/2014
  ORDER BY item_no; --edgar 10/21/2014
END NEGATE_DELETE_ITEM_ENDT;
/


