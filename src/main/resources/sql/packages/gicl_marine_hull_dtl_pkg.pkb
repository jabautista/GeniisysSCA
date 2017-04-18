CREATE OR REPLACE PACKAGE BODY CPI.GICL_MARINE_HULL_DTL_PKG
AS
/**
* Rey Jadlocon 11-29-2011
* created GICL_MARINE_HULL_DTL_PKG
**/
FUNCTION get_gicl_marine_hull_dtl(p_claim_id            gicl_hull_dtl.claim_id%TYPE)
        RETURN gicl_marine_hull_dtl_tab PIPELINED
      IS 
        v_list      gicl_marine_hull_dtl_type;
        v_exist     VARCHAR2(1);
  BEGIN
        FOR rec IN(SELECT DISTINCT a.claim_id,a.item_no,a.currency_cd,a.last_update,a.item_title,a.vessel_cd,a.geog_limit,a.deduct_text,a.dry_date,a.dry_place,a.loss_date,a.currency_rate
                     FROM gicl_hull_dtl a
                    WHERE a.claim_id = p_claim_id
                    ORDER BY 2 ASC)
        LOOP
                v_list.claim_id                 := rec.claim_id;
                v_list.item_no                  := rec.item_no;
                v_list.currency_cd              := rec.currency_cd;
                v_list.last_update              := rec.last_update;
                v_list.item_title               := rec.item_title;
                v_list.vessel_cd                := rec.vessel_cd;
                v_list.geog_limit               := rec.geog_limit;
                v_list.deduct_text              := rec.deduct_text;
                v_list.dry_date                 := rec.dry_date;
                v_list.dry_place                := rec.dry_place;
                v_list.loss_date                := rec.loss_date;
                v_list.currency_rate            := rec.currency_rate;
                v_list.loss_date_char           := TO_CHAR(rec.loss_date, 'MM-DD-YYYY HH:MI AM');
                
            BEGIN
              SELECT item_desc, item_desc2
                INTO v_list.item_desc, v_list.item_desc2
                FROM gicl_clm_item
               WHERE 1=1
                 AND claim_id = p_claim_id
                 AND item_no = v_list.item_no
                 AND grouped_item_no = 0;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.item_desc   := NULL;
                v_list.item_desc2  := NULL;
            END;
            
            FOR c IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = v_list.currency_cd) 
            LOOP
               v_list.currency_desc := c.currency_desc;
            END LOOP;
            
            FOR v IN(SELECT VESSEL_NAME,VESTYPE_CD,VESSEL_OLD_NAME,PROPEL_SW,HULL_TYPE_CD,REG_OWNER,
                            REG_PLACE,GROSS_TON,NET_TON,DEADWEIGHT,YEAR_BUILT,VESS_CLASS_CD,CREW_NAT,
                            NO_CREW,VESSEL_LENGTH,VESSEL_BREADTH,VESSEL_DEPTH
                       FROM GIIS_VESSEL
                      WHERE VESSEL_CD = v_list.vessel_cd)
            LOOP
                v_list.vessel_name              := v.vessel_name;
                v_list.vestype_cd               := v.vestype_cd;
                v_list.vessel_old_name          := v.vessel_old_name;
                v_list.propel_sw                := v.propel_sw;
                v_list.hull_type_cd             := v.hull_type_cd;
                v_list.reg_owner                := v.reg_owner;
                v_list.reg_place                := v.reg_place;
                v_list.gross_ton                := v.gross_ton;
                v_list.net_ton                  := v.net_ton;
                v_list.deadweight               := v.deadweight;
                v_list.year_built               := v.year_built;
                v_list.vess_class_cd            := v.vess_class_cd;
                v_list.crew_nat                 := v.crew_nat;
                v_list.no_crew                  := v.no_crew;
                v_list.vessel_length            := v.vessel_length;
                v_list.vessel_breadth           := v.vessel_breadth;
                v_list.vessel_depth             := v.vessel_depth;
            END LOOP;
            
            FOR des IN(SELECT vestype_desc
                         FROM giis_vestype
                        WHERE vestype_cd = v_list.vestype_cd)
            LOOP
                v_list.vestype_desc             := des.vestype_desc;
            END LOOP;
            
            FOR hull IN(SELECT hull_desc
                          FROM giis_hull_type
                         WHERE hull_type_cd = v_list.hull_type_cd)
            LOOP
                v_list.hull_desc            := hull.hull_desc;
            END LOOP;
            
            FOR vcd IN(SELECT vess_class_desc
                         FROM giis_vess_class
                        WHERE vess_class_cd = v_list.vess_class_cd)
            LOOP
                v_list.vess_class_desc          := vcd.vess_class_desc;
            END LOOP;
            
            SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist(v_list.item_no, v_list.claim_id)
              INTO v_list.gicl_item_peril_exist
              FROM dual;
              
            SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist(v_list.item_no, v_list.claim_id)
              INTO v_list.gicl_mortgagee_exist
              FROM dual;
                
            gicl_item_peril_pkg.validate_peril_reserve(v_list.item_no, 
                                                       v_list.claim_id, 
                                                       0, --belle grouped item no 02.13.2012
                                                       v_list.gicl_item_peril_msg);    
                
             PIPE ROW(v_list);   
       END LOOP;

  END;
  
  /**
  * Rey Jadlocon
  * 01-12-2011
  **/
  FUNCTION get_marine_hull_item_info(p_claim_id       gicl_claims.claim_id%TYPE)
            RETURN get_marine_hull_item_info_tab  PIPELINED
          IS
            v_marine_hull_item_info get_marine_hull_item_info_type;
     BEGIN
              FOR i IN(SELECT DISTINCT a.line_cd
                                    || '-'
                                    || a.subline_cd
                                    || '-'
                                    || a.iss_cd
                                    || '-'
                                    || LTRIM (TO_CHAR (a.clm_yy, '00'))
                                    || '-'
                                    || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                        claim_no,
                                       a.line_cd
                                    || '-'
                                    || a.subline_cd
                                    || '-'
                                    || a.pol_iss_cd
                                    || '-'
                                    || LTRIM (TO_CHAR (a.issue_yy, '00'))
                                    || '-'
                                    || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                    || '-'
                                    || LTRIM (TO_CHAR (a.renew_no, '00'))
                                                                       policy_no,
                                      a.line_cd, a.dsp_loss_date,
                                      a.assured_name,
                                       b.loss_cat_cd
                                    || '-'
                                    || b.loss_cat_des loss_ctgry,
                                    a.renew_no, a.pol_seq_no, a.issue_yy,
                                    a.pol_iss_cd, a.subline_cd, a.expiry_date,
                                    a.pol_eff_date, a.claim_id, c.clm_stat_desc,
                                    a.catastrophic_cd, a.clm_file_date,
                                    a.loss_cat_cd, d.item_no, d.peril_cd,
                                    d.close_flag,f.item_title,
                                    f.currency_cd, g.currency_desc,
                                    f.currency_rate,h.item_desc,
                                    h.item_desc2,f.last_update,f.vessel_cd,f.geog_limit,f.deduct_text,
                                    f.dry_date,f.dry_place,f.loss_date
                               FROM gicl_claims a,
                                    giis_loss_ctgry b,
                                    giis_clm_stat c,
                                    gicl_item_peril d,
                                    gicl_hull_dtl f,
                                    giis_currency g,
                                    gicl_clm_item h
                              WHERE a.loss_cat_cd = b.loss_cat_cd(+)
                                AND a.claim_id = f.claim_id
                                AND d.claim_id = h.claim_id(+)
                                AND d.item_no = h.item_no(+)
                                AND d.grouped_item_no = h.grouped_item_no(+)
                                AND f.currency_cd = g.main_currency_cd(+)
                                AND d.item_no = f.item_no(+)
                                AND a.line_cd = b.line_cd(+)
                                AND a.clm_stat_cd = c.clm_stat_cd(+)
                                AND a.claim_id = d.claim_id(+)
                                AND a.claim_id = p_claim_id)
               LOOP
                      FOR itm IN(SELECT 1
                                   FROM gicl_item_peril
                                  WHERE item_no = i.item_no
                                    AND claim_id = i.claim_id)
                      LOOP
                        v_marine_hull_item_info.itm := 'X';
                      END LOOP;
                      
                      v_marine_hull_item_info.claim_no          := i.claim_no;
                      v_marine_hull_item_info.policy_no         := i.policy_no;
                      v_marine_hull_item_info.line_cd           := i.line_cd;
                      v_marine_hull_item_info.dsp_loss_date     := i.dsp_loss_date;
                      v_marine_hull_item_info.loss_date         := i.loss_date;
                      v_marine_hull_item_info.assured_name      := i.assured_name;
                      v_marine_hull_item_info.renew_no          := i.renew_no;
                      v_marine_hull_item_info.pol_seq_no        := i.pol_seq_no;
                      v_marine_hull_item_info.issue_yy          := i.issue_yy;
                      v_marine_hull_item_info.pol_iss_cd        := i.pol_iss_cd;
                      v_marine_hull_item_info.subline_cd        := i.subline_cd;
                      v_marine_hull_item_info.expiry_date       := i.expiry_date;
                      v_marine_hull_item_info.pol_eff_date      := i.pol_eff_date;
                      v_marine_hull_item_info.claim_id          := i.claim_id;
                      v_marine_hull_item_info.clm_stat_desc     := i.clm_stat_desc;
                      v_marine_hull_item_info.catastrophic_cd   := i.catastrophic_cd;
                      v_marine_hull_item_info.clm_file_date     := i.clm_file_date;
                      v_marine_hull_item_info.loss_cat_cd       := i.loss_cat_cd;
                      v_marine_hull_item_info.item_no           := i.item_no;
                      v_marine_hull_item_info.peril_cd          := i.peril_cd;
                      v_marine_hull_item_info.close_flag        := i.close_flag;
                      v_marine_hull_item_info.item_title        := i.item_title;
                      v_marine_hull_item_info.currency_cd       := i.currency_cd;
                      v_marine_hull_item_info.currency_desc     := i.currency_desc;
                      v_marine_hull_item_info.currency_rate     := i.currency_rate;
                      v_marine_hull_item_info.item_desc         := i.item_desc;
                      v_marine_hull_item_info.item_desc2        := i.item_desc2;
                      v_marine_hull_item_info.last_update       := i.last_update;
                      v_marine_hull_item_info.vessel_cd         := i.vessel_cd;
                      v_marine_hull_item_info.geog_limit        := i.geog_limit;
                      v_marine_hull_item_info.deduct_text       := i.deduct_text;
                      v_marine_hull_item_info.dry_date          := i.dry_date;
                      v_marine_hull_item_info.dry_place         := i.dry_place;
                      v_marine_hull_item_info.loss_date         := i.loss_date;
                      v_marine_hull_item_info.last_update       := i.last_update;
                      
                        FOR c IN (SELECT currency_desc
                                    FROM giis_currency
                                   WHERE main_currency_cd = v_marine_hull_item_info.currency_cd) 
                        LOOP
                           v_marine_hull_item_info.currency_desc := c.currency_desc;
                        END LOOP;
                        
                        FOR v IN(SELECT VESSEL_NAME,VESTYPE_CD,VESSEL_OLD_NAME,PROPEL_SW,HULL_TYPE_CD,REG_OWNER,
                                        REG_PLACE,GROSS_TON,NET_TON,DEADWEIGHT,YEAR_BUILT,VESS_CLASS_CD,CREW_NAT,
                                        NO_CREW,VESSEL_LENGTH,VESSEL_BREADTH,VESSEL_DEPTH
                                   FROM GIIS_VESSEL
                                  WHERE VESSEL_CD = v_marine_hull_item_info.vessel_cd)
                        LOOP
                            v_marine_hull_item_info.vessel_name              := v.vessel_name;
                            v_marine_hull_item_info.vestype_cd               := v.vestype_cd;
                            v_marine_hull_item_info.vessel_old_name          := v.vessel_old_name;
                            v_marine_hull_item_info.propel_sw                := v.propel_sw;
                            v_marine_hull_item_info.hull_type_cd             := v.hull_type_cd;
                            v_marine_hull_item_info.reg_owner                := v.reg_owner;
                            v_marine_hull_item_info.reg_place                := v.reg_place;
                            v_marine_hull_item_info.gross_ton                := v.gross_ton;
                            v_marine_hull_item_info.net_ton                  := v.net_ton;
                            v_marine_hull_item_info.deadweight               := v.deadweight;
                            v_marine_hull_item_info.year_built               := v.year_built;
                            v_marine_hull_item_info.vess_class_cd            := v.vess_class_cd;
                            v_marine_hull_item_info.crew_nat                 := v.crew_nat;
                            v_marine_hull_item_info.no_crew                  := v.no_crew;
                            v_marine_hull_item_info.vessel_length            := v.vessel_length;
                            v_marine_hull_item_info.vessel_breadth           := v.vessel_breadth;
                            v_marine_hull_item_info.vessel_depth             := v.vessel_depth;
                        END LOOP;
                        
                        FOR des IN(SELECT vestype_desc
                                     FROM giis_vestype
                                    WHERE vestype_cd = v_marine_hull_item_info.vestype_cd)
                        LOOP
                            v_marine_hull_item_info.vestype_desc             := des.vestype_desc;
                        END LOOP;
                        
                        FOR hull IN(SELECT hull_desc
                                      FROM giis_hull_type
                                     WHERE hull_type_cd = v_marine_hull_item_info.hull_type_cd)
                        LOOP
                            v_marine_hull_item_info.hull_desc            := hull.hull_desc;
                        END LOOP;
                        
                        FOR vcd IN(SELECT vess_class_desc
                                     FROM giis_vess_class
                                    WHERE vess_class_cd = v_marine_hull_item_info.vess_class_cd)
                        LOOP
                            v_marine_hull_item_info.vess_class_desc          := vcd.vess_class_desc;
                        END LOOP;
                      
                      SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist(v_marine_hull_item_info.item_no, v_marine_hull_item_info.claim_id)
                        INTO v_marine_hull_item_info.gicl_item_peril_exist
                        FROM dual;
                          
                      SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist(v_marine_hull_item_info.item_no, v_marine_hull_item_info.claim_id)
                        INTO v_marine_hull_item_info.gicl_mortgagee_exist
                        FROM dual;
                            
                             gicl_item_peril_pkg.validate_peril_reserve(v_marine_hull_item_info.item_no, 
                                                                        v_marine_hull_item_info.claim_id, 
                                                                        0, --belle grouped item no 02.13.2012
                                                                        v_marine_hull_item_info.gicl_item_peril_msg);

                      PIPE ROW (v_marine_hull_item_info);
               END LOOP;
     END;
 /**
 * Rey Jadlocon
 * 01-12-2011
 **/
 FUNCTION check_marine_hull_item_no(
            p_claim_id          gicl_hull_dtl.claim_id%TYPE,
            p_item_no           gicl_hull_dtl.item_no%TYPE,
            p_start_row         VARCHAR2,
            p_end_row           VARCHAR2
            )
            RETURN VARCHAR2 IS
                   v_exist      VARCHAR2(1);
      BEGIN
                BEGIN
                    SELECT 'Y'
                      INTO v_exist
                      FROM (SELECT ROWNUM rownum_, a.item_no item_no
                              FROM (SELECT item_no
                                      FROM TABLE
                                                (gicl_marine_hull_dtl_pkg.get_marine_hull_item_info(p_claim_id)
                                                )) a)
                     WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
                       AND item_no = p_item_no;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_exist := 'N';
                END;
                RETURN v_exist;
      END;

/**
* Rey Jadlocon
* 02-12-2011
**/
PROCEDURE extract_mh_details(p_renew_no         gicl_claims.renew_no%TYPE,
                             p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                             p_issue_yy         gicl_claims.issue_yy%TYPE,
                             p_pol_iss_cd       gicl_claims.pol_iss_cd%TYPE,
                             p_subline_cd       gicl_claims.subline_cd%TYPE,
                             p_line_cd          gicl_claims.line_cd%TYPE,
                             p_pol_eff_date     gicl_claims.pol_eff_date%TYPE,
                             p_loss_date        gicl_claims.loss_date%TYPE,
                             p_expiry_date      gicl_claims.expiry_date%TYPE,
                             p_item_no          gicl_hull_dtl.item_no%TYPE,
                             p_claim_id         gicl_hull_dtl.claim_id%TYPE,
                             MHdata     IN OUT  gicl_marine_hull_dtl_type)
                           IS
            v_vestype_cd                        giis_vessel.vestype_cd%TYPE;
            v_hull_type_cd                      giis_vessel.hull_type_cd%TYPE;
            v_vess_class_cd                     giis_vessel.vess_class_cd%TYPE;
            v_currency_cd                       gipi_item.currency_cd%TYPE;
            v_currency_rt                       gipi_item.currency_rt%TYPE;
            v_vessel_cd                         gipi_item_ves.vessel_cd%TYPE;
            v_geog_limit                        gipi_item_ves.geog_limit%TYPE;
            v_deduct_text                       gipi_item_ves.deduct_text%TYPE;
            v_dry_date                          gipi_item_ves.dry_date%TYPE;
            v_dry_place                         gipi_item_ves.dry_place%TYPE;
            v_loss_date                         gicl_claims.loss_date%TYPE;
            v_max_endt_seq_no                   gipi_polbasic.endt_seq_no%TYPE;
            v_item_desc                         gipi_item.item_desc%TYPE; 
            v_item_desc2                        gipi_item.item_desc2%TYPE;
  BEGIN    
            FOR v1 IN(SELECT d.claim_id,c.endt_seq_no endt_seq_no, 
                             b.item_title item_title,
                             b.currency_cd currency_cd,
                             b.currency_rt currency_rt,
                             b.item_desc item_desc,  
                             b.item_desc2 item_desc2,
                             a.vessel_cd vessel_cd,
                             a.geog_limit geog_limit,
                             a.deduct_text deduct_text,
                             a.dry_date dry_date,
                             a.dry_place dry_place,
                             d.loss_date loss_date
                        FROM gicl_claims d,gipi_polbasic c,
                             gipi_item b,gipi_item_ves a    
                       WHERE c.policy_id     = b.policy_id
                         AND b.policy_id     = a.policy_id(+) 
                         AND b.item_no       = a.item_no(+)   
                         AND c.renew_no      = p_renew_no
                         AND c.pol_seq_no    = p_pol_seq_no
                         AND c.issue_yy      = p_issue_yy
                         AND c.iss_cd        = p_pol_iss_cd
                         AND c.subline_cd    = p_subline_cd
                         AND c.line_cd       = p_line_cd
                         AND trunc(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date), p_pol_eff_date, c.eff_date )) 
                             <= trunc(p_loss_date)   
                         AND c.eff_date <= d.loss_date 
                         AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date), 
                             c.expiry_date,p_expiry_date,c.endt_expiry_date)) >= trunc(p_loss_date) 
                         AND c.pol_flag      NOT IN ('4','5')
                         AND b.item_no       = p_item_no
                         AND d.claim_id      = p_claim_id)
                LOOP
                        v_currency_cd                    := v1.currency_cd;
                        v_currency_rt                    := v1.currency_rt;
                        v_vessel_cd                      := v1.vessel_cd;
                        v_geog_limit                     := v1.geog_limit;
                        v_deduct_text                    := v1.deduct_text;
                        v_dry_date                       := v1.dry_date;
                        v_dry_place                      := v1.dry_place;
                        v_loss_date                      := v1.loss_date;
                        v_max_endt_seq_no                := v1.endt_seq_no;
                        v_item_desc                      := v1.item_desc; 
                        v_item_desc2                     := v1.item_desc2;
                END LOOP;
                
          FOR v2 IN(SELECT b.item_title item_title,
                           b.currency_cd currency_cd,
                           b.currency_rt currency_rt,
                           b.item_desc item_desc,  
                           b.item_desc2 item_desc2,
                           a.vessel_cd vessel_cd,
                           a.geog_limit geog_limit,
                           a.deduct_text deduct_text,
                           a.dry_date dry_date,
                           a.dry_place dry_place,
                           d.loss_date loss_date
                      FROM gicl_claims d,gipi_polbasic c,
                           gipi_item b,gipi_item_ves a    
                     WHERE c.policy_id     = b.policy_id
                       AND b.policy_id     = a.policy_id
                       AND b.item_no       = a.item_no
                       AND c.renew_no      = p_renew_no
                       AND c.pol_seq_no    = p_pol_seq_no
                       AND c.issue_yy      = p_issue_yy
                       AND c.iss_cd        = p_pol_iss_cd
                       AND c.subline_cd    = p_subline_cd
                       AND c.line_cd       = p_line_cd
                       AND trunc(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date), p_pol_eff_date, c.eff_date )) 
                           <= trunc(p_loss_date)   
                       AND c.eff_date <= d.loss_date 
                       AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date), 
                           c.expiry_date,p_expiry_date,c.endt_expiry_date)) >= trunc(p_loss_date)  
                       AND c.pol_flag      NOT IN ('4','5')
                       AND b.item_no       = p_item_no
                       AND d.claim_id      = p_claim_id
                       AND NVL(c.back_stat, 5) = 2
                       AND c.endt_seq_no   = v_max_endt_seq_no)
               LOOP
                            v_currency_cd                    := v2.currency_cd;
                            v_currency_rt                    := v2.currency_rt;
                            v_vessel_cd                      := v2.vessel_cd;
                            v_geog_limit                     := v2.geog_limit;
                            v_deduct_text                    := v2.deduct_text;
                            v_dry_date                       := v2.dry_date;
                            v_dry_place                      := v2.dry_place;
                            v_loss_date                      := v2.loss_date;
                            v_item_desc                      := v2.item_desc; 
                            v_item_desc2                     := v2.item_desc2;
               END LOOP;
                        MHdata.item_no                    := p_item_no;
                        MHdata.currency_cd                := v_currency_cd;
                        MHdata.currency_rate              := v_currency_rt;
                        MHdata.vessel_cd                  := v_vessel_cd;
                        MHdata.geog_limit                 := v_geog_limit;
                        MHdata.deduct_text                := v_deduct_text;
                        MHdata.dry_date                   := v_dry_date;
                        MHdata.dry_place                  := v_dry_place;
                        MHdata.loss_date                  := v_loss_date;
                        MHdata.item_desc                  := v_item_desc; 
                        MHdata.item_desc2                 := v_item_desc2;
                        
          FOR c IN(SELECT DISTINCT item_title 
                     FROM gipi_item
                    WHERE item_no = MHdata.item_no 
                      AND policy_id IN (SELECT DISTINCT a.policy_id
                                          FROM gipi_polbasic a, gicl_claims b
                                         WHERE b.claim_id = p_claim_id
                                           AND a.line_cd = b.line_cd
                                           AND a.subline_cd = b.subline_cd
                                           AND a.pol_seq_no = b.pol_seq_no
                                           AND a.iss_cd = b.pol_iss_cd
                                           AND a.issue_yy = b.issue_yy
                                           AND a.renew_no = b.renew_no))
              LOOP
                        MHdata.item_title := c.item_title;
              END LOOP;
              
              FOR d IN (SELECT currency_desc               
                          FROM giis_currency
                         WHERE main_currency_cd = MHdata.currency_cd) 
              LOOP
                        MHdata.currency_desc := d.currency_desc;
              END LOOP;
              
              FOR e IN (SELECT vessel_name
                          FROM giis_vessel
                         WHERE vessel_cd = MHdata.vessel_cd) 
              LOOP
                        MHdata.vessel_name := e.vessel_name;
              END LOOP;
              
           FOR f IN(SELECT vestype_cd,
                           vessel_old_name,
                           propel_sw,
                           hull_type_cd,
                           reg_owner,
                           reg_place,
                           gross_ton,
                           net_ton,
                           deadweight,
                           year_built,
                           vess_class_cd,
                           crew_nat,
                           no_crew,
                           vessel_length,
                           vessel_breadth,
                           vessel_depth
                      FROM giis_vessel
                     WHERE vessel_cd = MHdata.vessel_cd)
          LOOP
                        v_vestype_cd                        := f.vestype_cd;
                        v_hull_type_cd                      := f.hull_type_cd;
                        v_vess_class_cd                     := f.vess_class_cd;
                        MHdata.vessel_old_name              := f.vessel_old_name;
                        MHdata.propel_sw                    := f.propel_sw;
                        MHdata.reg_owner                    := f.reg_owner;
                        MHdata.reg_place                    := f.reg_place;
                        MHdata.gross_ton                    := f.gross_ton;
                        MHdata.net_ton                      := f.net_ton;
                        MHdata.deadweight                   := f.deadweight;
                        MHdata.year_built                   := f.year_built;                      
                        MHdata.crew_nat                     := f.crew_nat;
                        MHdata.no_crew                      := f.no_crew;
                        MHdata.vessel_length                := f.vessel_length;
                        MHdata.vessel_breadth               := f.vessel_breadth;
                        MHdata.vessel_depth                 := f.vessel_depth;
          END LOOP;
          
          FOR g IN (SELECT vestype_desc
                      FROM giis_vestype
                     WHERE vestype_cd   = v_vestype_cd) 
          LOOP
                    MHdata.vestype_desc := g.vestype_desc;
          END LOOP;
          
          FOR h IN (SELECT hull_desc
                      FROM giis_hull_type
                     WHERE hull_type_cd  = v_hull_type_cd) 
          LOOP
                    MHdata.hull_desc := h.hull_desc;
          END LOOP;

          FOR i IN (SELECT vess_class_desc
                      FROM giis_vess_class
                     WHERE vess_class_cd  = v_vess_class_cd) 
          LOOP
                    MHdata.vess_class_desc := i.vess_class_desc;
          END LOOP;
  END;
  /**
  * Rey Jadlocon
  *02-12-2011
  **/
  FUNCTION get_marine_hull_dtl(p_renew_no         gicl_claims.renew_no%TYPE,
                             p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                             p_issue_yy         gicl_claims.issue_yy%TYPE,
                             p_pol_iss_cd       gicl_claims.pol_iss_cd%TYPE,
                             p_subline_cd       gicl_claims.subline_cd%TYPE,
                             p_line_cd          gicl_claims.line_cd%TYPE,
                             p_pol_eff_date     gicl_claims.pol_eff_date%TYPE,
                             p_loss_date        gicl_claims.loss_date%TYPE,
                             p_expiry_date      gicl_claims.expiry_date%TYPE,
                             p_item_no          gicl_hull_dtl.item_no%TYPE,
                             p_claim_id         gicl_hull_dtl.claim_id%TYPE)
          RETURN gicl_marine_hull_dtl_tab PIPELINED IS 
                 marine_hull     gicl_marine_hull_dtl_type;
          BEGIN
                GICL_MARINE_HULL_DTL_PKG.extract_mh_details(p_renew_no,p_pol_seq_no,p_issue_yy,p_pol_iss_cd,p_subline_cd,
                                                            p_line_cd,p_pol_eff_date,p_loss_date,p_expiry_date,p_item_no,p_claim_id,marine_hull);
                PIPE ROW(marine_hull);
                RETURN;                                           
          END;
 /**
 * Rey Jadlocon
 * 02-12-2011
 **/
 PROCEDURE validate_gicl_marine_hull_dtl(
                                p_line_cd               gipi_polbasic.line_cd%TYPE,
                                p_subline_cd            gipi_polbasic.subline_cd%TYPE,
                                p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
                                p_issue_yy              gipi_polbasic.issue_yy%TYPE,
                                p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
                                p_renew_no              gipi_polbasic.renew_no%TYPE,
                                p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
                                p_expiry_date           gipi_polbasic.expiry_date%TYPE,
                                p_loss_date             gipi_polbasic.expiry_date%TYPE,
                                p_incept_date           gipi_polbasic.incept_date%TYPE,
                                p_item_no               gipi_item.item_no%TYPE,
                                p_claim_id              gicl_hull_dtl.claim_id%TYPE,
                                p_from                  VARCHAR2,
                                p_to                    VARCHAR2,
                                marine_hull         OUT GICL_MARINE_HULL_DTL_PKG.gicl_marine_hull_dtl_cur,
                                p_item_exist        OUT NUMBER,
                                p_override_fl       OUT VARCHAR2,
                                p_tloss_fl          OUT VARCHAR2,
                                p_item_exist2       OUT VARCHAR2)
                   IS
        BEGIN
             SELECT GICL_MARINE_HULL_DTL_PKG.check_marine_hull_item_no(p_claim_id,p_item_no, p_from, p_to) 
               INTO p_item_exist2
               FROM dual;
               
             SELECT Giac_Validate_User_Fn(giis_users_pkg.app_user, 'TL', 'GICLS022')
               INTO p_override_fl
               FROM dual;
               
             SELECT GIPI_ITEM_PKG.check_existing_item(p_line_cd, p_subline_cd, p_pol_iss_cd, 
                                                      p_issue_yy, p_pol_seq_no, p_renew_no, 
                                                      p_pol_eff_date, p_expiry_date, p_loss_date,p_item_no) 
               INTO p_item_exist      
               FROM dual;
            
             SELECT Check_Total_Loss_Settlement2(
                    0, NULL, p_item_no, 
                    p_line_cd, p_subline_cd, p_pol_iss_cd,
                    p_issue_yy, p_pol_seq_no, p_renew_no, 
                    p_loss_date, p_pol_eff_date, p_expiry_date)
               INTO p_tloss_fl          
               FROM dual; 
               
            OPEN marine_hull FOR
            SELECT * 
              FROM TABLE(GICL_MARINE_HULL_DTL_PKG.get_marine_hull_dtl(p_renew_no,p_pol_seq_no,p_issue_yy,p_pol_iss_cd,
                                                                p_subline_cd,p_line_cd,p_pol_eff_date,p_loss_date,p_expiry_date,
                                                                p_item_no,p_claim_id));
        END;
        
/**
* Rey Jadlocon
* 02-12-2011
**/        
FUNCTION get_marine_hull_item_lov(p_claim_id        gicl_claims.claim_id%TYPE)
         RETURN gicl_marine_hull_dtl_tab PIPELINED
       IS
         v_marine_hull_item_info gicl_marine_hull_dtl_type;
 BEGIN
      FOR marine_hull IN(SELECT line_cd, subline_cd, pol_iss_cd,issue_yy, pol_seq_no, renew_no, loss_date, pol_eff_date, expiry_date, claim_id
                           FROM gicl_claims
                          WHERE claim_id = p_claim_id)
        LOOP
                v_marine_hull_item_info.line_cd            := marine_hull.line_cd;
                v_marine_hull_item_info.subline_cd         := marine_hull.subline_cd;
                v_marine_hull_item_info.pol_iss_cd         := marine_hull.pol_iss_cd;
                v_marine_hull_item_info.issue_yy           := marine_hull.issue_yy;
                v_marine_hull_item_info.pol_seq_no         := marine_hull.pol_seq_no;
                v_marine_hull_item_info.renew_no           := marine_hull.renew_no;
                v_marine_hull_item_info.loss_date          := marine_hull.loss_date;
                v_marine_hull_item_info.pol_eff_date       := marine_hull.pol_eff_date;
                v_marine_hull_item_info.expiry_date        := marine_hull.expiry_date;
                v_marine_hull_item_info.claim_id           := marine_hull.claim_id;
                                 SELECT DISTINCT b.item_no, Get_Latest_Item_Title(marine_hull.line_cd,marine_hull.subline_cd,marine_hull.pol_iss_cd,marine_hull.issue_yy,marine_hull.pol_seq_no,marine_hull.renew_no,b.item_no,marine_hull.loss_date,marine_hull.pol_eff_date,marine_hull.expiry_date) item_title 
                                   INTO v_marine_hull_item_info.item_no,v_marine_hull_item_info.item_title
                                   FROM gipi_polbasic a, gipi_item b
                                  WHERE a.line_cd = marine_hull.line_cd 
                                    AND a.subline_cd = marine_hull.subline_cd 
                                    AND a.iss_cd = marine_hull.pol_iss_cd 
                                    AND a.issue_yy = marine_hull.issue_yy 
                                    AND a.pol_seq_no = marine_hull.pol_seq_no 
                                    AND a.renew_no = marine_hull.renew_no 
                                    AND a.pol_flag in ('1','2','3', 'X') 
                                    AND TRUNC(DECODE(TRUNC(nvl(b.from_date,eff_date)),TRUNC(a.incept_date), nvl(b.from_date,marine_hull.pol_eff_date), nvl(b.from_date,a.eff_date ))) <= marine_hull.loss_date 
                                    AND TRUNC(DECODE(nvl(b.to_date,nvl(a.endt_expiry_date, a.expiry_date)), a.expiry_date,nvl(b.to_date,marine_hull.expiry_date), nvl(b.to_date,a.endt_expiry_date))) >=marine_hull.loss_date 
                                    AND a.policy_id = b.policy_id;
                PIPE ROW(v_marine_hull_item_info);
        END LOOP;
     RETURN;
 END;
 
 /**
 * Rey Jadlocon
 * 05-12-2011
 **/
 
 PROCEDURE set_gicl_marine_hull_dtl(p_claim_id           gicl_hull_dtl.claim_id%TYPE,
                                   p_item_no            gicl_hull_dtl.item_no%TYPE,
                                   p_currency_cd        gicl_hull_dtl.currency_cd%TYPE,
                                   p_user_id            gicl_hull_dtl.user_id%TYPE,
                                   p_last_update        gicl_hull_dtl.last_update%TYPE,
                                   p_item_title         gicl_hull_dtl.item_title%TYPE,
                                   p_vessel_cd          gicl_hull_dtl.vessel_cd%TYPE,
                                   p_geog_limit         gicl_hull_dtl.geog_limit%TYPE,
                                   p_deduct_text        gicl_hull_dtl.deduct_text%TYPE,
                                   p_dry_date           gicl_hull_dtl.dry_date%TYPE,
                                   p_dry_place          gicl_hull_dtl.dry_place%TYPE,
                                   p_cpi_rec_no         gicl_hull_dtl.cpi_rec_no%TYPE,
                                   p_cpi_branch_cd      gicl_hull_dtl.cpi_branch_cd%TYPE,
                                   p_loss_date          gicl_hull_dtl.loss_date%TYPE,
                                   p_currency_rate      gicl_hull_dtl.currency_rate%TYPE)
                                 IS
        BEGIN
                    MERGE INTO gicl_hull_dtl
                         USING dual
                            ON (claim_id = p_claim_id
                           AND item_no = p_item_no)        
              WHEN NOT MATCHED THEN 
                        INSERT (claim_id,item_no,currency_cd,user_id,last_update,item_title,vessel_cd,geog_limit,deduct_text,dry_date,dry_place,cpi_rec_no,cpi_branch_cd,loss_date,currency_rate)
                        VALUES (p_claim_id,p_item_no,p_currency_cd,p_user_id,p_last_update,p_item_title,p_vessel_cd,p_geog_limit,p_deduct_text,p_dry_date,p_dry_place,p_cpi_rec_no,p_cpi_branch_cd,p_loss_date,p_currency_rate)    
                  WHEN MATCHED THEN
                        UPDATE
                           SET
                                currency_cd             = p_currency_cd,
                                user_id                 = p_user_id,
                                last_update             = p_last_update,
                                item_title              = p_item_title,
                                vessel_cd               = p_vessel_cd,
                                geog_limit              = p_geog_limit,
                                deduct_text             = p_deduct_text,
                                dry_date                = p_dry_date,
                                dry_place               = p_dry_place,
                                cpi_rec_no              = p_cpi_rec_no,
                                cpi_branch_cd           = p_cpi_branch_cd,
                                loss_date               = p_loss_date,
                                currency_rate           = p_currency_rate;
        END;
   
/**
* Rey Jadlocon
* 05-12-2011
**/

FUNCTION check_existing_item (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR h IN
         (SELECT c.item_no
            FROM gipi_item c, gipi_polbasic b
           WHERE p_line_cd = b.line_cd
             AND p_subline_cd = b.subline_cd
             AND p_pol_iss_cd = b.iss_cd
             AND p_issue_yy = b.issue_yy
             AND p_pol_seq_no = b.pol_seq_no
             AND p_renew_no = b.renew_no
             AND b.policy_id = c.policy_id
             AND b.pol_flag IN ('1', '2', '3', 'X')
             AND TRUNC (DECODE (TRUNC (b.eff_date),
                                TRUNC (b.incept_date), p_pol_eff_date,
                                b.eff_date
                               )
                       ) <= p_loss_date
             AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                b.expiry_date, p_expiry_date,
                                b.endt_expiry_date
                               )
                       ) >= p_loss_date
             AND c.item_no = p_item_no)
      LOOP
         v_exist := 1;
      END LOOP;

      RETURN v_exist;
   END;
   
/**
* Rey Jadlocon
* 05-12-2011
**/   
PROCEDURE del_gicl_marine_hull_dtl(
            p_claim_id          gicl_hull_dtl.claim_id%TYPE,
            p_item_no           gicl_hull_dtl.item_no%TYPE
            )IS
     BEGIN  
            DELETE FROM gicl_hull_dtl
             WHERE claim_id = p_claim_id
               AND item_no = p_item_no;
     END;

/**
* Rey Jadlocon
* 05-12-2011
**/
FUNCTION get_gicl_marine_hull_dtl_exist( 
        p_claim_id          gicl_hull_dtl.claim_id%TYPE
        ) 
    RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_hull_dtl
                 WHERE claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;
  
END GICL_MARINE_HULL_DTL_PKG;
/


