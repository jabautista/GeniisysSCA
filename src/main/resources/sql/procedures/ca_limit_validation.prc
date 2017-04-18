DROP PROCEDURE CPI.CA_LIMIT_VALIDATION;

CREATE OR REPLACE PROCEDURE CPI.CA_LIMIT_VALIDATION (p_par_id            GIPI_PARLIST.par_id%TYPE,
                              p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
                              v_loc                  OUT VARCHAR2,
                                 v_type_exceed       OUT VARCHAR2,
                                 v_share_type        GIIS_DIST_SHARE.share_type%TYPE,
                                 v_Eff_Date          GIUW_POL_DIST.eff_date%TYPE,
                                 v_dist_spct         GIUW_WPOLICYDS_DTL.dist_spct%TYPE)
IS
 v_menu_line_cd     GIIS_LINE.menu_line_cd%TYPE:='&$';
 v_retn_lim_amt     GIIS_CA_LOCATION.RET_LIMIT%TYPE;
 v_trty_lim_amt     GIIS_CA_LOCATION.TREATY_LIMIT%TYPE;
 v_loc_cd            GIIS_CA_LOCATION.LOCATION_CD%TYPE;
 tot_by_type        NUMBER;
 tot_by_policy      NUMBER;
 tot_by_par         NUMBER;
 v_totals           NUMBER;
 v_items            NUMBER;
 v_rates            NUMBER;
BEGIN
  SELECT NVL(menu_line_cd,line_cd)
    INTO v_menu_line_cd
    FROM GIIS_LINE
   WHERE line_cd = p_line_cd;


    IF p_line_cd  = Giisp.v('LINE_CODE_CA') OR v_menu_line_cd = 'CA' THEN
            FOR x IN (
                       SELECT b.ret_limit,b.treaty_limit,a.location_cd,a.item_no,
                             b.loc_addr1||' '||b.loc_addr2||' '||b.loc_addr3 loc_desc
                       FROM GIPI_WCASUALTY_ITEM A, GIIS_CA_LOCATION B
                      WHERE a.location_cd = b.location_cd
                        AND a.par_id = p_par_id
                      )
            LOOP
                v_retn_lim_amt := x.ret_limit;
                v_trty_lim_amt := x.treaty_limit;
                v_loc_cd       := x.location_cd;
                v_loc           := x.loc_desc;
                
            IF v_retn_lim_amt IS NOT NULL OR v_trty_lim_amt IS NOT NULL THEN
                SELECT SUM(a.tsi_amt*a.currency_rt)
                  INTO tot_by_type
                  FROM GIPI_WITEM a, GIPI_WCASUALTY_ITEM B, GIPI_WPOLBAS C -- analyn 08/13/10 added gipi_wpolbas
                 WHERE a.par_id       = p_par_id
                   AND a.par_id       = b.par_id
                   AND a.item_no       = b.item_no
                   AND b.location_cd  = v_loc_cd
                   AND c.subline_cd = NVL(giisp.v('CA_SUBLINE_PFL'),'PFL') -- analyn 08/13/10
                   AND a.par_id = c.par_id; -- analyn 08/13/10
                   
             SELECT SUM(itmdtl.dist_tsi)
                INTO tot_by_policy
                FROM GIPI_POLBASIC polbsc, GIUW_POL_DIST poldist,
                     GIPI_ITEM gpitem, GIPI_CASUALTY_ITEM gpfitm, GIUW_ITEMDS_DTL itmdtl, GIIS_DIST_SHARE distshare
                WHERE polbsc.policy_id             = poldist.policy_id
                AND polbsc.policy_id             = gpitem.policy_id
                AND gpitem.policy_id             = gpfitm.policy_id
                AND gpitem.item_no                 = gpfitm.item_no
                AND poldist.dist_no                = itmdtl.dist_no
                AND gpitem.item_no                 = itmdtl.item_no
                AND itmdtl.line_cd                 = distshare.line_cd
                AND itmdtl.share_cd             = distshare.share_cd
                AND distshare.share_type        = v_share_type
                AND gpfitm.location_cd             = v_loc_cd
                AND polbsc.subline_cd            = NVL(giisp.v('CA_SUBLINE_PFL'),'PFL') -- analyn 08/13/10
                AND TRUNC(polbsc.eff_date)      <= TRUNC(v_Eff_Date)
                AND TRUNC(polbsc.expiry_date) >= TRUNC(v_Eff_Date);
                
            -----------totals of selected pars----------------
                SELECT SUM(wpolbs.tsi_amt)
                   INTO tot_by_par
                   FROM GIPI_WPOLBAS wpolbs, GIUW_POL_DIST poldist, GIPI_WITEM gpwitm, GIPI_WCASUALTY_ITEM gpwfitm,
                        GIUW_WITEMDS_DTL witmdtl, GIIS_DIST_SHARE distshare
                   WHERE wpolbs.par_id     = poldist.par_id
                   AND wpolbs.par_id     = gpwitm.par_id
                   AND gpwitm.par_id     = gpwfitm.par_id
                   AND gpwitm.item_no     = gpwfitm.item_no
                   AND poldist.dist_no     = witmdtl.dist_no
                   AND gpwitm.item_no     = witmdtl.item_no
                   AND witmdtl.line_cd     = distshare.line_cd
                   AND witmdtl.share_cd     = distshare.share_cd
                   AND distshare.share_type = v_share_type
                   AND gpwfitm.location_cd     = v_loc_cd
                   AND wpolbs.par_id             <> p_par_id
                   AND wpolbs.subline_cd            = NVL(giisp.v('CA_SUBLINE_PFL'),'PFL') -- analyn 08/13/10
                   AND TRUNC(wpolbs.eff_date)    <= TRUNC(v_eff_date)
                   AND TRUNC(wpolbs.expiry_date) >= TRUNC(v_eff_date);

        v_totals := (NVL(tot_by_type,0) + NVL(tot_by_policy,0) + NVL(tot_by_par,0)) * (v_dist_spct/100);
        IF v_share_type = 1 THEN
         IF v_retn_lim_amt < ROUND(v_totals,2) AND v_retn_lim_amt IS NOT NULL THEN
               v_type_exceed := 'NET';
         END IF;
        ELSIF v_share_type = 2 THEN
         IF v_trty_lim_amt < ROUND(v_totals,2) AND v_trty_lim_amt IS NOT NULL THEN
               v_type_exceed := 'TREATY';
         END IF;
        END IF;
    --END LOOP;
    END IF;
    END LOOP;
    END IF;
END;
/


