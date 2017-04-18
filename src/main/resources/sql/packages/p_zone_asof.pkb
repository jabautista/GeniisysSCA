CREATE OR REPLACE PACKAGE BODY CPI.P_Zone_Asof AS

PROCEDURE EXTRACT(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
    p_dsp_zone IN VARCHAR2,
    p_inc_endt  IN VARCHAR2,
    p_inc_exp   IN VARCHAR2,
    p_peril_type IN VARCHAR2,
    p_risk_cnt   IN VARCHAR2,
    p_user       IN VARCHAR2) --edgar 03/09/2015
AS
 
TYPE eq_zone_tab  IS TABLE OF GIPI_FIREITEM.eq_zone%TYPE;
TYPE share_cd_tab IS TABLE OF GIUW_ITEMPERILDS_DTL.share_cd%TYPE;
TYPE no_risk_tab  IS TABLE OF GIPI_FIRESTAT_EXTRACT.no_of_risk%TYPE;
TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
vv_no_of_risk     no_risk_tab;
vv_eq_zone        eq_zone_tab;
vv_share_cd       share_cd_tab;
vv_tsi            tsi_tab;
vv_prem           prem_tab;
vv_eq_zone2       eq_zone_tab;   -- used for records not extracted; 2nd select
vv_share_cd2      share_cd_tab;  -- used for records not extracted; 2nd select
v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE; 
 
BEGIN
 
 DELETE
   FROM GIPI_FIRESTAT_EXTRACT
  WHERE as_of_sw = 'Y'
    AND user_id = /*USER*/p_user; /*modified edgar 02/24/2015*/
  COMMIT;
 
 /*
 IF p_dsp_zone = '1' THEN --like '%flood%' then
    zone_flood(p_as_of, p_bus_cd,p_zone, p_inc_endt, p_inc_exp, p_risk_cnt);
 ELSIF p_dsp_zone = '2' THEN --like '%typhoon%' then
    zone_typhn(p_as_of, p_bus_cd,p_zone, p_inc_endt, p_inc_exp, p_risk_cnt);
 ELSIF p_dsp_zone = '3' THEN --like '%earthquake%' then
    zone_earth(p_as_of, p_bus_cd,p_zone, p_inc_endt, p_inc_exp, p_risk_cnt);
 ELSIF p_dsp_zone = '5' THEN --like '%earthquake%' then
    zone_tf(p_as_of, p_bus_cd,p_zone, p_inc_endt, p_inc_exp, p_risk_cnt);
 END IF;
 */
 
 SELECT p_zone_asof.risk_count(zone_no,share_cd, p_dsp_zone, p_risk_cnt, p_user), --added p_user : edgar 03/09/2015
        zone_no, 
         share_cd, 
           SUM(share_prem_amt),
         SUM(share_tsi_amt) 
      BULK COLLECT INTO 
           vv_no_of_risk,
           vv_eq_zone,
           vv_share_cd,
           vv_prem,
           vv_tsi
      FROM gipi_firestat_extract_dtl
     WHERE user_id = /*USER*/p_user /*modified edgar 02/24/2015*/
       AND NVL(as_of_sw,'N') = 'Y'
     GROUP BY share_cd, zone_no;
  
    IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_eq_zone.FIRST..vv_eq_zone.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,                 zone_type,                  zone_no,
         share_cd,                   no_of_risk,                 share_tsi_amt,
         share_prem_amt,             tariff_cd,                  as_of_sw,
         as_of_date,                 user_id)
      VALUES
        (SYSDATE,                    p_dsp_zone,                          nvl(vv_eq_zone(cnt),0),
         vv_share_cd(cnt),           NVL(vv_no_of_risk(cnt),0),  NVL(vv_tsi(cnt),0),
         NVL(vv_prem(cnt),0),        '7',                        'Y',
         p_as_of,                    /*USER*/p_user /*modified edgar 02/24/2015*/);
    END IF;
    COMMIT;
 
 
 END;
  
 PROCEDURE zone_earth(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2, 
 p_risk_cnt IN VARCHAR2)
  AS
    TYPE eq_zone_tab  IS TABLE OF GIPI_FIREITEM.eq_zone%TYPE;
    TYPE share_cd_tab IS TABLE OF GIUW_ITEMPERILDS_DTL.share_cd%TYPE;
    TYPE no_risk_tab  IS TABLE OF GIPI_FIRESTAT_EXTRACT.no_of_risk%TYPE;
    TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
    TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
    vv_no_of_risk     no_risk_tab;
    vv_eq_zone        eq_zone_tab;
    vv_share_cd       share_cd_tab;
    vv_tsi            tsi_tab;
    vv_prem           prem_tab;
    vv_eq_zone2       eq_zone_tab;   -- used for records not extracted; 2nd select
    vv_share_cd2      share_cd_tab;  -- used for records not extracted; 2nd select
    v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE;
  BEGIN
    DELETE
      FROM GIPI_FIRESTAT_EXTRACT
     WHERE as_of_sw = 'Y'
       AND user_id = USER;
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* start extracting records here and insert in gipi_firestat_extract */
    --SELECT COUNT(DISTINCT a.line_cd
    --               || a.subline_cd
    --               || a.iss_cd
    --               || TO_CHAR(a.issue_yy)
    --               || TO_CHAR(a.pol_seq_no)
    --               || TO_CHAR(a.renew_no)) risk_cnt,
    --       NVL(get_eq_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
    --       a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0) eq_zone,
    --       f.share_cd share_cd,
    --       SUM(f.dist_prem * b.currency_rt) prem_amount,
    --       SUM(NVL(get_eq_tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
--     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_as_of),0)* b.currency_rt) tsi_amount
----     sum(f.dist_tsi  * b.currency_rt) tsi_amount
  --    BULK COLLECT INTO
  --         vv_no_of_risk,
  --         vv_eq_zone,
  --         vv_share_cd,
  --         vv_prem,
  --         vv_tsi
  --    FROM GIPI_ITEM             b,
  --         GIUW_ITEMPERILDS_DTL  f,
  --         GIUW_POL_DIST         e,
  --         GIPI_FIREITEM         d,
  --         GIPI_POLBASIC         a,
  --     GIPI_ITMPERIL         c,
  ---      (SELECT line_cd, peril_cd--, peril_type
--        FROM GIIS_PERIL
--             WHERE zone_type IN ('5','6','7')) g
--     WHERE a.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
--       AND a.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, a.iss_cd)
--       AND NVL(a.pol_flag,'A') IN ('1','2','3','4','X')
 --      AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
 --      AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
 --      AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--    AND a.policy_id = b.policy_id
--    AND c.item_no   = b.item_no
--    AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
--       AND c.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
--       AND c.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
--    AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
--       AND e.dist_flag = '3'       --  pol_dist
--    AND a.par_id    = e.par_id     --  polbasic   = pol_dist
 --      AND a.policy_id = d.policy_id  --  polbasic   = fireitem
--    AND c.item_no   = d.item_no    --  itemperil  = fireitem
--    AND c.policy_id = a.policy_id  --  itemperil  = polbasic
--    AND g.line_cd   = c.line_cd    --  giis_peril = item_peril
--    AND g.peril_cd  = c.peril_cd   --  giis_peril = item_peril
--    AND a.line_cd  = g.line_cd
--       AND DECODE (p_zone, 'ALL', NVL(d.eq_zone,-1), NVL(d.eq_zone,-2)) IN (d.eq_zone,-1)
--     GROUP BY NVL(get_eq_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
--                              a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0), f.share_cd;
  

    SELECT p_zone_asof.risk_count_eq(zone_no,share_cd, p_risk_cnt),
        zone_no, 
         share_cd, 
           SUM(share_prem_amt),
         SUM(share_tsi_amt) 
      BULK COLLECT INTO 
           vv_no_of_risk,
           vv_eq_zone,
           vv_share_cd,
           vv_prem,
           vv_tsi
      FROM gipi_firestat_extract_dtl
     WHERE user_id = USER
       AND NVL(as_of_sw,'N') = 'Y'
     GROUP BY share_cd, zone_no;
  
    IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_eq_zone.FIRST..vv_eq_zone.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,                 zone_type,                  zone_no,
         share_cd,                   no_of_risk,                 share_tsi_amt,
         share_prem_amt,             tariff_cd,                  as_of_sw,
         as_of_date,                 user_id)
      VALUES
        (SYSDATE,                    3,                          vv_eq_zone(cnt),
         vv_share_cd(cnt),           NVL(vv_no_of_risk(cnt),0),  NVL(vv_tsi(cnt),0),
         NVL(vv_prem(cnt),0),        '7',                        'Y',
         p_as_of,                    USER);
 END IF;
    /* insert also those distinct eq_zone and share_cd which has no records of extract.
    ** initialize those amounts with zeros.
    */
    SELECT DISTINCT a.eq_zone,
           b.share_cd
      BULK COLLECT INTO
           vv_eq_zone2,
           vv_share_cd2
      FROM GIIS_EQZONE       a,
           GIIS_DIST_SHARE   b
     WHERE NOT EXISTS(SELECT 'X'
                        FROM GIPI_FIRESTAT_EXTRACT c
                       WHERE c.user_id  = USER
                         AND c.as_of_sw = 'Y'
                         AND c.zone_no     = a.eq_zone
                         AND c.share_cd    = b.share_cd
                         AND c.extract_dt >= TO_DATE('1','J'));
    IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_eq_zone2.FIRST..vv_eq_zone2.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,       zone_type,         zone_no,
         share_cd,         no_of_risk,        share_tsi_amt,
         share_prem_amt,   tariff_cd,         as_of_sw,
         as_of_date,       user_id)
      VALUES
    (SYSDATE,           3,                 vv_eq_zone2(cnt),
     vv_share_cd2(cnt),  0,                 0,
        0,                 '7',               'Y',
        p_as_of,           USER);
 END IF;
    COMMIT;
  END;
  PROCEDURE zone_flood(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2, 
 p_risk_cnt IN VARCHAR2)
  AS
    TYPE fd_zone_tab  IS TABLE OF GIPI_FIREITEM.flood_zone%TYPE;
    TYPE share_cd_tab IS TABLE OF GIUW_ITEMPERILDS_DTL.share_cd%TYPE;
    TYPE no_risk_tab  IS TABLE OF GIPI_FIRESTAT_EXTRACT.no_of_risk%TYPE;
    TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
    TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
    vv_no_of_risk     no_risk_tab;
    vv_fd_zone        fd_zone_tab;
    vv_share_cd       share_cd_tab;
    vv_tsi            tsi_tab;
    vv_prem           prem_tab;
    vv_fd_zone2       fd_zone_tab;   -- used for records not extracted; 2nd select
    vv_share_cd2      share_cd_tab;  -- used for records not extracted; 2nd select
    v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE;
  BEGIN
    DELETE
      FROM GIPI_FIRESTAT_EXTRACT
     WHERE as_of_sw = 'Y'
       AND user_id = USER;
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* start extracting records here and insert in gipi_firestat_extract */
  --  SELECT COUNT(DISTINCT a.line_cd
  --                 || a.subline_cd
  --                 || a.iss_cd
  --                 || TO_CHAR(a.issue_yy)
  --                 || TO_CHAR(a.pol_seq_no)
  --                 || TO_CHAR(a.renew_no)) risk_cnt,
  --         NVL(get_fd_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
  --         a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0) fd_zone,
  --         f.share_cd share_cd,
  --         SUM(f.dist_prem * b.currency_rt) prem_amount,
  --         SUM(NVL(get_fd_tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
--     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_as_of),0)* b.currency_rt) tsi_amount
----     sum(f.dist_tsi  * b.currency_rt) tsi_amount
 --     BULK COLLECT INTO
 --          vv_no_of_risk,
 --          vv_fd_zone,
  --         vv_share_cd,
   --        vv_prem,
   --        vv_tsi
   --   FROM GIPI_ITEM             b,
   --        GIUW_ITEMPERILDS_DTL  f,
   --        GIUW_POL_DIST         e,
   --        GIPI_FIREITEM         d,
   --        GIPI_POLBASIC         a,
--     GIPI_ITMPERIL         c,
--     (SELECT line_cd, peril_cd--, peril_type
--        FROM GIIS_PERIL
 --            WHERE zone_type = '1') g
  --   WHERE a.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
  --     AND a.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, a.iss_cd)
  --     AND NVL(a.pol_flag,'A') IN ('1','2','3','4','X')
  --     AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
  --     AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
  --     AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--    AND a.policy_id = b.policy_id
--    AND c.item_no   = b.item_no
--    AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
 --      AND c.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
  --     AND c.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
--    AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
 --      AND e.dist_flag = '3'       --  pol_dist
--    AND a.par_id    = e.par_id     --  polbasic   = pol_dist
 --      AND a.policy_id = d.policy_id  --  polbasic   = fireitem
--    AND c.item_no   = d.item_no    --  itemperil  = fireitem
--    AND c.policy_id = a.policy_id  --  itemperil  = polbasic
--    AND g.line_cd   = c.line_cd    --  giis_peril = item_peril
--    AND g.peril_cd  = c.peril_cd   --  giis_peril = item_peril
--    AND a.line_cd  = g.line_cd
 --      AND DECODE (p_zone, 'ALL', NVL(d.flood_zone,-1), NVL(d.flood_zone,-2)) IN (d.flood_zone,-1)
  --   GROUP BY NVL(get_fd_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
   --                           a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0), f.share_cd;
    
 
 SELECT p_zone_asof.risk_count_fd(zone_no,share_cd, p_risk_cnt),
        zone_no, 
         share_cd, 
           SUM(share_prem_amt),
         SUM(share_tsi_amt) 
      BULK COLLECT INTO 
           vv_no_of_risk,
           vv_fd_zone,
           vv_share_cd,
           vv_prem,
           vv_tsi
      FROM gipi_firestat_extract_dtl
     WHERE user_id = USER
       AND NVL(as_of_sw,'N') = 'Y'
     GROUP BY share_cd, zone_no;
 
 
 IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_fd_zone.FIRST..vv_fd_zone.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,                 zone_type,                  zone_no,
         share_cd,                   no_of_risk,                 share_tsi_amt,
         share_prem_amt,             tariff_cd,                  as_of_sw,
         as_of_date,                 user_id)
      VALUES
        (SYSDATE,                    1,                          vv_fd_zone(cnt),
         vv_share_cd(cnt),           NVL(vv_no_of_risk(cnt),0),  NVL(vv_tsi(cnt),0),
         NVL(vv_prem(cnt),0),        '7',                        'Y',
         p_as_of,                    USER);
 END IF;
    /* insert also those distinct flood_zone and share_cd which has no records of extract.
    ** initialize those amounts with zeros.
    */
    SELECT DISTINCT a.flood_zone,
           b.share_cd
      BULK COLLECT INTO
           vv_fd_zone2,
           vv_share_cd2
      FROM GIIS_FLOOD_ZONE   a,
           GIIS_DIST_SHARE   b
     WHERE NOT EXISTS(SELECT 'X'
                        FROM GIPI_FIRESTAT_EXTRACT c
                       WHERE c.user_id  = USER
                         AND c.as_of_sw = 'Y'
                         AND c.zone_no     = a.flood_zone
                         AND c.share_cd    = b.share_cd
                         AND c.extract_dt >= TO_DATE('1','J'));
    IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_fd_zone2.FIRST..vv_fd_zone2.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,         zone_type,         zone_no,
         share_cd,           no_of_risk,        share_tsi_amt,
         share_prem_amt,     tariff_cd,         as_of_sw,
         as_of_date,         user_id)
      VALUES
    (SYSDATE,             1,                 vv_fd_zone2(cnt),
     vv_share_cd2(cnt),   0,                 0,
        0,                   '7',               'Y',
        p_as_of,             USER);
 END IF;
    COMMIT;
  END;
  /* policies with typhoon zone */
  PROCEDURE zone_typhn(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2,
 p_risk_cnt IN VARCHAR2)
  AS
    TYPE ty_zone_tab  IS TABLE OF GIPI_FIREITEM.flood_zone%TYPE;
    TYPE share_cd_tab IS TABLE OF GIUW_ITEMPERILDS_DTL.share_cd%TYPE;
    TYPE no_risk_tab  IS TABLE OF GIPI_FIRESTAT_EXTRACT.no_of_risk%TYPE;
    TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
    TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
    vv_no_of_risk     no_risk_tab;
    vv_ty_zone        ty_zone_tab;
    vv_share_cd       share_cd_tab;
    vv_tsi            tsi_tab;
    vv_prem           prem_tab;
    vv_ty_zone2       ty_zone_tab;   -- used for records not extracted; 2nd select
    vv_share_cd2      share_cd_tab;  -- used for records not extracted; 2nd select
    v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE;
  BEGIN
    DELETE
      FROM GIPI_FIRESTAT_EXTRACT
     WHERE as_of_sw = 'Y'
       AND user_id = USER;
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* start extracting records here and insert in gipi_firestat_extract */
  
  
  --  SELECT COUNT(DISTINCT a.line_cd
  --                 || a.subline_cd
  --                 || a.iss_cd
   --                || TO_CHAR(a.issue_yy)
   --                || TO_CHAR(a.pol_seq_no)
   --                || TO_CHAR(a.renew_no)) risk_cnt,
   --        NVL(get_ty_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
   --        a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0) ty_zone,
   --        f.share_cd share_cd,
   --        SUM(f.dist_prem * b.currency_rt) prem_amount,
    ---       SUM(NVL(get_ty_tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
--     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_as_of),0)* b.currency_rt) tsi_amount
----     sum(f.dist_tsi  * b.currency_rt) tsi_amount
 --     BULK COLLECT INTO
  --         vv_no_of_risk,
   --        vv_ty_zone,
   --        vv_share_cd,
    --       vv_prem,
    --       vv_tsi
    --  FROM GIPI_ITEM             b,
    --       GIUW_ITEMPERILDS_DTL  f,
    --       GIUW_POL_DIST         e,
    --       GIPI_FIREITEM         d,
    --       GIPI_POLBASIC         a,
 --    GIPI_ITMPERIL         c,
 --    (SELECT line_cd, peril_cd--, peril_type
 --       FROM GIIS_PERIL
     --        WHERE zone_type = '2') g
    -- WHERE a.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
    --   AND a.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, a.iss_cd)
    --   AND NVL(a.pol_flag,'A') IN ('1','2','3','4','X')
    --   AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
    --   AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
    --   AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
 --   AND a.policy_id = b.policy_id
 --   AND c.item_no   = b.item_no
 --   AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
    --   AND c.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
    --   AND c.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
 --   AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
    --   AND e.dist_flag = '3'       --  pol_dist
 --   AND a.par_id    = e.par_id     --  polbasic   = pol_dist
    --   AND a.policy_id = d.policy_id  --  polbasic   = fireitem
 --   AND c.item_no   = d.item_no    --  itemperil  = fireitem
 --   AND c.policy_id = a.policy_id  --  itemperil  = polbasic
 --   AND g.line_cd   = c.line_cd    --  giis_peril = item_peril
 --   AND g.peril_cd  = c.peril_cd   --  giis_peril = item_peril
 --   AND a.line_cd  = g.line_cd
    --   AND DECODE (p_zone, 'ALL', NVL(d.typhoon_zone,-1), NVL(d.typhoon_zone,-2)) IN (d.typhoon_zone,-1)
    -- GROUP BY NVL(get_ty_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
    --                          a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0), f.share_cd;
    
 SELECT p_zone_asof.risk_count_ty(zone_no,share_cd, p_risk_cnt),
        zone_no, 
         share_cd, 
           SUM(share_prem_amt),
         SUM(share_tsi_amt) 
      BULK COLLECT INTO 
           vv_no_of_risk,
           vv_ty_zone,
           vv_share_cd,
           vv_prem,
           vv_tsi
      FROM gipi_firestat_extract_dtl
     WHERE user_id = USER
       AND NVL(as_of_sw,'N') = 'Y'
     GROUP BY share_cd, zone_no;
 
 IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_ty_zone.FIRST..vv_ty_zone.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,                 zone_type,                  zone_no,
         share_cd,                   no_of_risk,                 share_tsi_amt,
         share_prem_amt,             tariff_cd,                  as_of_sw,
         as_of_date,                 user_id)
      VALUES
        (SYSDATE,                    2,                          vv_ty_zone(cnt),
         vv_share_cd(cnt),           NVL(vv_no_of_risk(cnt),0),  NVL(vv_tsi(cnt),0),
         NVL(vv_prem(cnt),0),        '7',                        'Y',
         p_as_of,                    USER);
 END IF;
    /* insert also those distinct typhoon_zone and share_cd which has no records of extract.
    ** initialize those amounts with zeros.
    */
    SELECT DISTINCT a.typhoon_zone,
           b.share_cd
      BULK COLLECT INTO
           vv_ty_zone2,
           vv_share_cd2
      FROM GIIS_TYPHOON_ZONE   a,
           GIIS_DIST_SHARE     b
     WHERE NOT EXISTS(SELECT 'X'
                        FROM GIPI_FIRESTAT_EXTRACT c
                       WHERE c.user_id  = USER
                         AND c.as_of_sw = 'Y'
                         AND c.zone_no     = a.typhoon_zone
                         AND c.share_cd    = b.share_cd
                         AND c.extract_dt >= TO_DATE('1','J'));
    IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_ty_zone2.FIRST..vv_ty_zone2.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,         zone_type,         zone_no,
         share_cd,           no_of_risk,        share_tsi_amt,
         share_prem_amt,     tariff_cd,         as_of_sw,
         as_of_date,         user_id)
      VALUES
    (SYSDATE,             2,                 vv_ty_zone2(cnt),
     vv_share_cd2(cnt),   0,                 0,
        0,                   '7',               'Y',
        p_as_of,             USER);
 END IF;
    COMMIT;
  END;
  PROCEDURE zone_tf(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2,
 p_risk_cnt IN VARCHAR2)
  AS
    TYPE tf_zone_tab  IS TABLE OF GIPI_FIREITEM.flood_zone%TYPE;
    TYPE share_cd_tab IS TABLE OF GIUW_ITEMPERILDS_DTL.share_cd%TYPE;
    TYPE no_risk_tab  IS TABLE OF GIPI_FIRESTAT_EXTRACT.no_of_risk%TYPE;
    TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
    TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
    vv_no_of_risk     no_risk_tab;
    vv_tf_zone        tf_zone_tab;
    vv_share_cd       share_cd_tab;
    vv_tsi            tsi_tab;
    vv_prem           prem_tab;
    vv_tf_zone2       tf_zone_tab;   -- used for records not extracted; 2nd select
    vv_share_cd2      share_cd_tab;  -- used for records not extracted; 2nd select
    v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE;
  BEGIN
    DELETE
      FROM GIPI_FIRESTAT_EXTRACT
     WHERE as_of_sw = 'Y'
       AND user_id = USER;
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* start extracting records here and insert in gipi_firestat_extract */
    --SELECT COUNT(DISTINCT a.line_cd
    --               || a.subline_cd
    --               || a.iss_cd
    --               || TO_CHAR(a.issue_yy)
    --               || TO_CHAR(a.pol_seq_no)
    --               || TO_CHAR(a.renew_no)) risk_cnt,
    --       NVL(get_tf_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
    --       a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0) tf_zone,
    --       f.share_cd share_cd,
    --       SUM(f.dist_prem * b.currency_rt) prem_amount,
    --       SUM(NVL(get_tf_tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
--     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_as_of),0)* b.currency_rt) tsi_amount
-- --     sum(f.dist_tsi  * b.currency_rt) tsi_amount
  --    BULK COLLECT INTO
  --         vv_no_of_risk,
  --         vv_tf_zone,
  --         vv_share_cd,
  --         vv_prem,
  --         vv_tsi
  --    FROM GIPI_ITEM             b,
  --         GIUW_ITEMPERILDS_DTL  f,
  --         GIUW_POL_DIST         e,
  --         GIPI_FIREITEM         d,
  --         GIPI_POLBASIC         a,
--     GIPI_ITMPERIL         c,
--     (SELECT line_cd, peril_cd--, peril_type
--        FROM GIIS_PERIL
 --            WHERE zone_type IN ('1','2')) g
  --   WHERE a.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
   --    AND a.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, a.iss_cd)
    --   AND NVL(a.pol_flag,'A') IN ('1','2','3','4','X')
    --   AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
   --    AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
   --    AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--    AND a.policy_id = b.policy_id
--    AND c.item_no   = b.item_no
--    AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
 --      AND c.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
 --      AND c.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
--    AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
 --      AND e.dist_flag = '3'       --  pol_dist
--    AND a.par_id    = e.par_id     --  polbasic   = pol_dist
--       AND a.policy_id = d.policy_id  --  polbasic   = fireitem
--    AND c.item_no   = d.item_no    --  itemperil  = fireitem
--    AND c.policy_id = a.policy_id  --  itemperil  = polbasic
--    AND g.line_cd   = c.line_cd    --  giis_peril = item_peril
--    AND g.peril_cd  = c.peril_cd   --  giis_peril = item_peril
--    AND a.line_cd  = g.line_cd
 --      AND DECODE (p_zone, 'ALL', NVL(d.flood_zone,-1), NVL(d.flood_zone,-2)) IN (d.flood_zone,-1)
 --    GROUP BY NVL(get_tf_zone(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
  --                            a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no, d.item_no, p_as_of),0), f.share_cd;
    
 SELECT p_zone_asof.risk_count_tf(zone_no,share_cd, p_risk_cnt),
        zone_no, 
         share_cd, 
           SUM(share_prem_amt),
         SUM(share_tsi_amt) 
      BULK COLLECT INTO 
           vv_no_of_risk,
           vv_tf_zone,
           vv_share_cd,
           vv_prem,
           vv_tsi
      FROM gipi_firestat_extract_dtl
     WHERE user_id = USER
       AND NVL(as_of_sw,'N') = 'Y'
     GROUP BY share_cd, zone_no;
 
 IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_tf_zone.FIRST..vv_tf_zone.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,                 zone_type,                  zone_no,
         share_cd,                   no_of_risk,                 share_tsi_amt,
         share_prem_amt,             tariff_cd,                  as_of_sw,
         as_of_date,                 user_id)
      VALUES
        (SYSDATE,                    5,                 vv_tf_zone(cnt),
         vv_share_cd(cnt),           NVL(vv_no_of_risk(cnt),0),  NVL(vv_tsi(cnt),0),
         NVL(vv_prem(cnt),0),        '7',                        'Y',
         p_as_of,                    USER);
 END IF;
    /* insert also those distinct flood_zone and share_cd which has no records of extract.
    ** initialize those amounts with zeros.
    */
    SELECT DISTINCT a.flood_zone,
           b.share_cd
      BULK COLLECT INTO
           vv_tf_zone2,
           vv_share_cd2
      FROM GIIS_FLOOD_ZONE   a,
           GIIS_DIST_SHARE   b
     WHERE NOT EXISTS(SELECT 'X'
                        FROM GIPI_FIRESTAT_EXTRACT c
                       WHERE c.user_id  = USER
                         AND c.as_of_sw = 'Y'
                         AND c.zone_no     = a.flood_zone
                         AND c.share_cd    = b.share_cd
                         AND c.extract_dt >= TO_DATE('1','J'));
    IF NOT SQL%NOTFOUND THEN
    FORALL cnt IN vv_tf_zone2.FIRST..vv_tf_zone2.LAST
      INSERT INTO GIPI_FIRESTAT_EXTRACT
        (extract_dt,         zone_type,         zone_no,
         share_cd,           no_of_risk,        share_tsi_amt,
         share_prem_amt,     tariff_cd,         as_of_sw,
         as_of_date,         user_id)
      VALUES
    (SYSDATE,             5,           vv_tf_zone2(cnt),
     vv_share_cd2(cnt),   0,                 0,
        0,                   '7',               'Y',
        p_as_of,             USER);
 END IF;
    COMMIT;
  END;
  FUNCTION get_eq_zone
  /* created by boyet 10/23/2001
  ** this function returns the eq_zone of the latest endt_seq_no. this function is only used
  ** for the package the processes zone not null.
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
  p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_as_of        DATE)
  RETURN VARCHAR2 IS
    v_eq_zone     GIPI_FIREITEM.eq_zone%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT y.eq_zone
        FROM GIPI_POLBASIC x,
             GIPI_FIREITEM y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
   AND x.endt_iss_cd = p_endt_iss_cd
   AND x.endt_yy     = p_endt_yy
   AND x.endt_seq_no = p_endt_seq_no
         AND x.renew_no   = p_renew_no
         AND x.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(x.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(x.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(x.endt_expiry_date), TRUNC(x.expiry_date)) >= TRUNC(p_as_of)
         AND NOT EXISTS(SELECT 'X'
                          FROM GIPI_POLBASIC m,
                               GIPI_FIREITEM  n
                         WHERE m.line_cd = p_line_cd
                           AND m.subline_cd = p_subline_cd
                           AND m.iss_cd     = p_iss_cd
                           AND m.issue_yy   = p_issue_yy
                           AND m.pol_seq_no = p_pol_seq_no
          AND m.endt_iss_cd = p_endt_iss_cd
                           AND m.endt_yy     = p_endt_yy
          AND m.endt_seq_no = p_endt_seq_no
                           AND m.renew_no   = p_renew_no
                           AND m.pol_flag IN ('1','2','3','4','X')
                           AND TRUNC(m.incept_date) <=  TRUNC(p_as_of)
                           AND TRUNC(m.eff_date) <= TRUNC(p_as_of)
                           AND NVL(TRUNC(m.endt_expiry_date), TRUNC(m.expiry_date)) >= TRUNC(p_as_of)
                           AND m.endt_seq_no > x.endt_seq_no
                           AND NVL(m.back_stat,5) = 2
                           AND m.policy_id  = n.policy_id
                           AND n.item_no    = p_item_no
                           AND n.eq_zone IS NOT NULL)
        AND x.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
        AND y.eq_zone IS NOT NULL
        ORDER BY x.eff_date DESC)
    LOOP
      v_eq_zone := cur1.eq_zone;
      EXIT;
    END LOOP;
    RETURN v_eq_zone;
  END;
  FUNCTION get_fd_zone
  /* created by boyet 10/23/2001
  ** this function returns the flood_zone of the latest endt_seq_no.
  ** this function is only used for the package the processes zone not null.
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
  p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_as_of        DATE)
  RETURN VARCHAR2 IS
    v_fd_zone     GIPI_FIREITEM.eq_zone%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT y.flood_zone
        FROM GIPI_POLBASIC x,
             GIPI_FIREITEM y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
   AND x.endt_iss_cd = p_endt_iss_cd
   AND x.endt_yy     = p_endt_yy
   AND x.endt_seq_no = p_endt_seq_no
         AND x.renew_no   = p_renew_no
         AND x.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(x.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(x.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(x.endt_expiry_date), TRUNC(x.expiry_date)) >= TRUNC(p_as_of)
         AND NOT EXISTS(SELECT 'X'
                          FROM GIPI_POLBASIC m,
                               GIPI_FIREITEM  n
                         WHERE m.line_cd = p_line_cd
                           AND m.subline_cd = p_subline_cd
                           AND m.iss_cd     = p_iss_cd
                           AND m.issue_yy   = p_issue_yy
                           AND m.pol_seq_no = p_pol_seq_no
          AND m.endt_iss_cd = p_endt_iss_cd
          AND m.endt_yy     = p_endt_yy
          AND m.endt_seq_no = p_endt_seq_no
                           AND m.renew_no   = p_renew_no
                           AND m.pol_flag IN ('1','2','3','4','X')
                           AND TRUNC(m.incept_date) <=  TRUNC(p_as_of)
                           AND TRUNC(m.eff_date) <= TRUNC(p_as_of)
                           AND NVL(TRUNC(m.endt_expiry_date), TRUNC(m.expiry_date)) >= TRUNC(p_as_of)
                           AND m.endt_seq_no > x.endt_seq_no
                           AND NVL(m.back_stat,5) = 2
                           AND m.policy_id  = n.policy_id
                           AND n.item_no    = p_item_no
                           AND n.flood_zone IS NOT NULL)
        AND x.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
        AND y.flood_zone IS NOT NULL
        ORDER BY x.eff_date DESC)
    LOOP
      v_fd_zone := cur1.flood_zone;
      EXIT;
    END LOOP;
    RETURN v_fd_zone;
  END;
  FUNCTION get_ty_zone
  /* created by boyet 10/23/2001
  ** this function returns the typhoon_zone of the latest endt_seq_no.
  ** this function is only used for the package the processes zone not null.
  */
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
   p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no   NUMBER,
     p_item_no    NUMBER,
     p_as_of      DATE)
  RETURN VARCHAR2 IS
    v_ty_zone     GIPI_FIREITEM.typhoon_zone%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT y.typhoon_zone typhoon_zone
        FROM GIPI_POLBASIC x,
             GIPI_FIREITEM y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
   AND x.endt_iss_cd = p_endt_iss_cd
   AND x.endt_yy     = p_endt_yy
   AND x.endt_seq_no = p_endt_seq_no
         AND x.renew_no   = p_renew_no
         AND x.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(x.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(x.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(x.endt_expiry_date), TRUNC(x.expiry_date)) >= TRUNC(p_as_of)
         AND NOT EXISTS(SELECT 'X'
                          FROM GIPI_POLBASIC m,
                               GIPI_FIREITEM  n
                         WHERE m.line_cd = p_line_cd
                           AND m.subline_cd = p_subline_cd
                           AND m.iss_cd     = p_iss_cd
                           AND m.issue_yy   = p_issue_yy
                           AND m.pol_seq_no = p_pol_seq_no
          AND m.endt_iss_cd = p_endt_iss_cd
          AND m.endt_yy     = p_endt_yy
          AND m.endt_seq_no = p_endt_seq_no
                           AND m.renew_no   = p_renew_no
                           AND m.pol_flag IN ('1','2','3','4','X')
                           AND TRUNC(m.incept_date) <=  TRUNC(p_as_of)
                           AND TRUNC(m.eff_date) <= TRUNC(p_as_of)
                           AND NVL(TRUNC(m.endt_expiry_date), TRUNC(m.expiry_date)) >= TRUNC(p_as_of)
                           AND m.endt_seq_no > x.endt_seq_no
                           AND NVL(m.back_stat,5) = 2
                           AND m.policy_id  = n.policy_id
                           AND n.item_no    = p_item_no
                           AND n.typhoon_zone IS NOT NULL)
        AND x.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
        AND y.typhoon_zone IS NOT NULL
        ORDER BY x.eff_date DESC)
    LOOP
      v_ty_zone := cur1.typhoon_zone;
      EXIT;
    END LOOP;
    RETURN v_ty_zone;
  END;
  FUNCTION get_tf_zone
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
  p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_as_of        DATE)
  RETURN VARCHAR2 IS
    v_tf_zone     GIPI_FIREITEM.eq_zone%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT NVL(y.typhoon_zone,y.flood_zone) tf_zone
        FROM GIPI_POLBASIC x,
             GIPI_FIREITEM y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
   AND x.endt_iss_cd = p_endt_iss_cd
   AND x.endt_yy     = p_endt_yy
   AND x.endt_seq_no = p_endt_seq_no
         AND x.renew_no   = p_renew_no
         AND x.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(x.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(x.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(x.endt_expiry_date), TRUNC(x.expiry_date)) >= TRUNC(p_as_of)
         AND NOT EXISTS(SELECT 'X'
                          FROM GIPI_POLBASIC m,
                               GIPI_FIREITEM  n
                         WHERE m.line_cd = p_line_cd
                           AND m.subline_cd = p_subline_cd
                           AND m.iss_cd     = p_iss_cd
                           AND m.issue_yy   = p_issue_yy
                           AND m.pol_seq_no = p_pol_seq_no
          AND m.endt_iss_cd = p_endt_iss_cd
          AND m.endt_yy     = p_endt_yy
          AND m.endt_seq_no = p_endt_seq_no
                           AND m.renew_no   = p_renew_no
                           AND m.pol_flag IN ('1','2','3','4','X')
                           AND TRUNC(m.incept_date) <=  TRUNC(p_as_of)
                           AND TRUNC(m.eff_date) <= TRUNC(p_as_of)
                           AND NVL(TRUNC(m.endt_expiry_date), TRUNC(m.expiry_date)) >= TRUNC(p_as_of)
                           AND m.endt_seq_no > x.endt_seq_no
                           AND NVL(m.back_stat,5) = 2
                           AND m.policy_id  = n.policy_id
                           AND n.item_no    = p_item_no
                           AND NVL(n.typhoon_zone,n.flood_zone) IS NOT NULL)
        AND x.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
        AND NVL(y.typhoon_zone,y.flood_zone) IS NOT NULL
        ORDER BY x.eff_date DESC)
    LOOP
      v_tf_zone := cur1.tf_zone;
      EXIT;
    END LOOP;
    RETURN v_tf_zone;
  END;
FUNCTION get_fd_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     IN VARCHAR2,
   p_subline_cd  IN VARCHAR2,
   p_iss_cd   IN VARCHAR2,
   p_issue_yy   IN NUMBER,
   p_pol_seq_no  IN NUMBER,
      p_renew_no  IN NUMBER,
      p_item_no   IN NUMBER,
   p_peril_cd IN NUMBER,
   p_share_cd IN NUMBER,
   p_dist_no     IN NUMBER,
   p_as_of  IN DATE)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
  BEGIN
  BEGIN
   SELECT DISTINCT g.peril_type
   INTO v_peril_type
      FROM GIPI_POLBASIC         a,
           GIPI_FIREITEM         d,
           GIPI_ITMPERIL         c,
           GIUW_POL_DIST         e,
           GIUW_ITEMPERILDS_DTL  f,
           GIIS_PERIL      g
     WHERE 1=1
       AND a.policy_id   = d.policy_id
       AND a.par_id      = e.par_id
       AND e.dist_flag   = '3'
       AND a.policy_id   = c.policy_id
       AND d.item_no     = c.item_no
       AND a.line_cd     = c.line_cd
       AND e.dist_no     = f.dist_no
       AND f.dist_seq_no >= 0
       AND d.item_no     = f.item_no
       AND c.peril_cd    = f.peril_cd
       AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
       AND a.issue_yy    = p_issue_yy
       AND a.pol_seq_no  = p_pol_seq_no
       AND a.renew_no    = p_renew_no
       AND d.item_no     = p_item_no
       AND a.pol_flag IN ('1','2','3','4','X')
       AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
       AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
       AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--       and f.share_cd    = p_share_cd
       AND g.peril_cd    = f.peril_cd
       AND g.line_cd     = a.line_cd
       AND g.peril_cd    = c.peril_cd
       AND g.zone_type   = '1'
    AND g.peril_type  = 'B';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    v_peril_type := 'A';
  END;
  IF v_peril_type = 'B' THEN
 SELECT fb.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fb,
     GIIS_PERIL    gb
     WHERE 1=1
    AND fb.dist_no     = p_dist_no
    AND gb.line_cd   = p_line_cd
    AND gb.peril_cd   = fb.peril_cd
    AND fb.peril_cd    = p_peril_cd
    AND fb.share_cd    = p_share_cd
    AND fb.item_no     = p_item_no
     AND gb.zone_type   = '1'
       AND gb.peril_type  = 'B';
  ELSE
 SELECT fa.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fa
     WHERE 1=1
    AND fa.dist_no     = p_dist_no
    AND fa.dist_seq_no >= 0
    AND fa.line_cd   = p_line_cd
    AND fa.peril_cd    = p_peril_cd
    AND fa.share_cd    = p_share_cd
    AND fa.item_no   = p_item_no
    AND fa.peril_cd IN (
        SELECT peril_cd
       FROM GIPI_ITMPERIL b1,
         GIPI_POLBASIC a1
      WHERE b1.item_no     = p_item_no
        AND a1.line_cd     = p_line_cd
     AND a1.subline_cd  = p_subline_cd
        AND a1.iss_cd      = p_iss_cd
        AND a1.issue_yy    = p_issue_yy
        AND a1.pol_seq_no  = p_pol_seq_no
        AND a1.renew_no    = p_renew_no
              AND a1.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(a1.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(a1.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(a1.endt_expiry_date), TRUNC(a1.expiry_date)) >= TRUNC(p_as_of)
        AND b1.policy_id   = a1.policy_id
        AND b1.line_cd     = a1.line_cd
        AND (b1.peril_cd, b1.tsi_amt) IN (
            SELECT MAX(c2.peril_cd),c2.tsi_amt
              FROM GIPI_POLBASIC         a2,
                         GIPI_FIREITEM         d2,
                         GIPI_ITMPERIL         c2,
                         GIUW_POL_DIST         e2,
                        GIIS_PERIL   g2
                   WHERE 1=1
                     AND a2.policy_id   = d2.policy_id
                     AND a2.par_id      = e2.par_id
                     AND e2.dist_flag   = '3'
                     AND a2.policy_id   = c2.policy_id
                     AND d2.item_no     = c2.item_no
                     AND a2.line_cd     = c2.line_cd
      AND e2.dist_no >= 0
                     AND a2.line_cd     = p_line_cd
                     AND a2.subline_cd  = p_subline_cd
                     AND a2.iss_cd      = p_iss_cd
                     AND a2.issue_yy    = p_issue_yy
                     AND a2.pol_seq_no  = p_pol_seq_no
                     AND a2.renew_no    = p_renew_no
                     AND d2.item_no     = p_item_no
                     AND a2.pol_flag IN ('1','2','3','4','X')
            AND TRUNC(a2.incept_date) <=  TRUNC(p_as_of)
            AND TRUNC(a2.eff_date) <= TRUNC(p_as_of)
            AND NVL(TRUNC(a2.endt_expiry_date), TRUNC(a2.expiry_date)) >= TRUNC(p_as_of)
                     AND g2.line_cd     = a2.line_cd
                     AND g2.peril_cd    = c2.peril_cd
         AND g2.zone_type   IN ('1')
      AND c2.tsi_amt IN
       (SELECT MAX(c3.tsi_amt)
                  FROM GIPI_POLBASIC         a3,
                                 GIPI_FIREITEM         d3,
                                 GIPI_ITMPERIL         c3,
                                 GIUW_POL_DIST         e3,
                              GIIS_PERIL      g3
                           WHERE 1=1
                             AND a3.policy_id   = d3.policy_id
                             AND a3.par_id      = e3.par_id
                             AND e3.dist_flag   = '3'
                             AND a3.policy_id   = c3.policy_id
                             AND d3.item_no     = c3.item_no
                             AND a3.line_cd     = c3.line_cd
        AND e3.dist_no >= 0
                             AND a3.line_cd     = p_line_cd
                             AND a3.subline_cd  = p_subline_cd
                          AND a3.iss_cd      = p_iss_cd
                          AND a3.issue_yy    = p_issue_yy
                          AND a3.pol_seq_no  = p_pol_seq_no
                          AND a3.renew_no    = p_renew_no
                             AND d3.item_no     = p_item_no
              AND NVL(a3.pol_flag,'A') IN ('1','2','3','4','X')
              AND TRUNC(a3.incept_date) <=  TRUNC(p_as_of)
              AND TRUNC(a3.eff_date) <= TRUNC(p_as_of)
              AND NVL(TRUNC(a3.endt_expiry_date), TRUNC(a3.expiry_date)) >= TRUNC(p_as_of)
                             AND g3.line_cd     = a3.line_cd
                             AND g3.peril_cd    = c3.peril_cd
        AND g3.zone_type   IN ('1'))
        GROUP BY c2.tsi_amt));
  END IF;
 RETURN(NVL(v_tsi,0));
   END;
FUNCTION get_ty_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     IN VARCHAR2,
   p_subline_cd  IN VARCHAR2,
   p_iss_cd   IN VARCHAR2,
   p_issue_yy   IN NUMBER,
   p_pol_seq_no  IN NUMBER,
      p_renew_no  IN NUMBER,
      p_item_no   IN NUMBER,
   p_peril_cd IN NUMBER,
   p_share_cd IN NUMBER,
   p_dist_no     IN NUMBER,
   p_as_of  IN DATE)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
  BEGIN
  BEGIN
   SELECT DISTINCT g.peril_type
   INTO v_peril_type
      FROM GIPI_POLBASIC         a,
           GIPI_FIREITEM         d,
           GIPI_ITMPERIL         c,
           GIUW_POL_DIST         e,
           GIUW_ITEMPERILDS_DTL  f,
           GIIS_PERIL      g
     WHERE 1=1
       AND a.policy_id   = d.policy_id
       AND a.par_id      = e.par_id
       AND e.dist_flag   = '3'
       AND a.policy_id   = c.policy_id
       AND d.item_no     = c.item_no
       AND a.line_cd     = c.line_cd
       AND e.dist_no     = f.dist_no
       AND f.dist_seq_no >= 0
       AND d.item_no     = f.item_no
       AND c.peril_cd    = f.peril_cd
       AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
       AND a.issue_yy    = p_issue_yy
       AND a.pol_seq_no  = p_pol_seq_no
       AND a.renew_no    = p_renew_no
       AND d.item_no     = p_item_no
       AND a.pol_flag IN ('1','2','3','4','X')
       AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
       AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
       AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--       and f.share_cd    = p_share_cd
       AND g.peril_cd    = f.peril_cd
       AND g.line_cd     = a.line_cd
       AND g.peril_cd    = c.peril_cd
       AND g.zone_type   = '2'
    AND g.peril_type  = 'B';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    v_peril_type := 'A';
  END;
  IF v_peril_type = 'B' THEN
 SELECT fb.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fb,
     GIIS_PERIL    gb
     WHERE 1=1
    AND fb.dist_no     = p_dist_no
    AND gb.line_cd   = p_line_cd
    AND gb.peril_cd   = fb.peril_cd
    AND fb.peril_cd    = p_peril_cd
    AND fb.share_cd    = p_share_cd
    AND fb.item_no     = p_item_no
     AND gb.zone_type   = '2'
       AND gb.peril_type  = 'B';
  ELSE
 SELECT fa.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fa
     WHERE 1=1
    AND fa.dist_no     = p_dist_no
    AND fa.dist_seq_no >= 0
    AND fa.line_cd   = p_line_cd
    AND fa.peril_cd    = p_peril_cd
    AND fa.share_cd    = p_share_cd
    AND fa.item_no   = p_item_no
    AND fa.peril_cd IN (
        SELECT peril_cd
       FROM GIPI_ITMPERIL b1,
         GIPI_POLBASIC a1
      WHERE b1.item_no     = p_item_no
        AND a1.line_cd     = p_line_cd
     AND a1.subline_cd  = p_subline_cd
        AND a1.iss_cd      = p_iss_cd
        AND a1.issue_yy    = p_issue_yy
        AND a1.pol_seq_no  = p_pol_seq_no
        AND a1.renew_no    = p_renew_no
              AND a1.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(a1.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(a1.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(a1.endt_expiry_date), TRUNC(a1.expiry_date)) >= TRUNC(p_as_of)
        AND b1.policy_id   = a1.policy_id
        AND b1.line_cd     = a1.line_cd
        AND (b1.peril_cd, b1.tsi_amt) IN (
            SELECT MAX(c2.peril_cd),c2.tsi_amt
              FROM GIPI_POLBASIC         a2,
                         GIPI_FIREITEM         d2,
                         GIPI_ITMPERIL         c2,
                         GIUW_POL_DIST         e2,
                        GIIS_PERIL   g2
                   WHERE 1=1
                     AND a2.policy_id   = d2.policy_id
                     AND a2.par_id      = e2.par_id
                     AND e2.dist_flag   = '3'
                     AND a2.policy_id   = c2.policy_id
                     AND d2.item_no     = c2.item_no
                     AND a2.line_cd     = c2.line_cd
      AND e2.dist_no >= 0
                     AND a2.line_cd     = p_line_cd
                     AND a2.subline_cd  = p_subline_cd
                     AND a2.iss_cd      = p_iss_cd
                     AND a2.issue_yy    = p_issue_yy
                     AND a2.pol_seq_no  = p_pol_seq_no
                     AND a2.renew_no    = p_renew_no
                     AND d2.item_no     = p_item_no
                     AND a2.pol_flag IN ('1','2','3','4','X')
            AND TRUNC(a2.incept_date) <=  TRUNC(p_as_of)
            AND TRUNC(a2.eff_date) <= TRUNC(p_as_of)
            AND NVL(TRUNC(a2.endt_expiry_date), TRUNC(a2.expiry_date)) >= TRUNC(p_as_of)
                     AND g2.line_cd     = a2.line_cd
                     AND g2.peril_cd    = c2.peril_cd
         AND g2.zone_type   IN ('2')
      AND c2.tsi_amt IN
       (SELECT MAX(c3.tsi_amt)
                  FROM GIPI_POLBASIC         a3,
                                 GIPI_FIREITEM         d3,
                                 GIPI_ITMPERIL         c3,
                                 GIUW_POL_DIST         e3,
                              GIIS_PERIL      g3
                           WHERE 1=1
                             AND a3.policy_id   = d3.policy_id
                             AND a3.par_id      = e3.par_id
                             AND e3.dist_flag   = '3'
                             AND a3.policy_id   = c3.policy_id
                             AND d3.item_no     = c3.item_no
                             AND a3.line_cd     = c3.line_cd
        AND e3.dist_no >= 0
                             AND a3.line_cd     = p_line_cd
                             AND a3.subline_cd  = p_subline_cd
                          AND a3.iss_cd      = p_iss_cd
                          AND a3.issue_yy    = p_issue_yy
                          AND a3.pol_seq_no  = p_pol_seq_no
                          AND a3.renew_no    = p_renew_no
                             AND d3.item_no     = p_item_no
              AND NVL(a3.pol_flag,'A') IN ('1','2','3','4','X')
              AND TRUNC(a3.incept_date) <=  TRUNC(p_as_of)
              AND TRUNC(a3.eff_date) <= TRUNC(p_as_of)
              AND NVL(TRUNC(a3.endt_expiry_date), TRUNC(a3.expiry_date)) >= TRUNC(p_as_of)
                             AND g3.line_cd     = a3.line_cd
                             AND g3.peril_cd    = c3.peril_cd
        AND g3.zone_type   IN ('2'))
        GROUP BY c2.tsi_amt));
  END IF;
 RETURN(NVL(v_tsi,0));
   END;
FUNCTION get_eq_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     IN VARCHAR2,
   p_subline_cd  IN VARCHAR2,
   p_iss_cd   IN VARCHAR2,
   p_issue_yy   IN NUMBER,
   p_pol_seq_no  IN NUMBER,
      p_renew_no  IN NUMBER,
      p_item_no   IN NUMBER,
   p_peril_cd IN NUMBER,
   p_share_cd IN NUMBER,
   p_dist_no     IN NUMBER,
   p_as_of  IN DATE)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
  BEGIN
  BEGIN
   SELECT DISTINCT g.peril_type
   INTO v_peril_type
      FROM GIPI_POLBASIC         a,
           GIPI_FIREITEM         d,
           GIPI_ITMPERIL         c,
           GIUW_POL_DIST         e,
           GIUW_ITEMPERILDS_DTL  f,
           GIIS_PERIL      g
     WHERE 1=1
       AND a.policy_id   = d.policy_id
       AND a.par_id      = e.par_id
       AND e.dist_flag   = '3'
       AND a.policy_id   = c.policy_id
       AND d.item_no     = c.item_no
       AND a.line_cd     = c.line_cd
       AND e.dist_no     = f.dist_no
       AND f.dist_seq_no >= 0
       AND d.item_no     = f.item_no
       AND c.peril_cd    = f.peril_cd
       AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
       AND a.issue_yy    = p_issue_yy
       AND a.pol_seq_no  = p_pol_seq_no
       AND a.renew_no    = p_renew_no
       AND d.item_no     = p_item_no
       AND a.pol_flag IN ('1','2','3','4','X')
       AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
       AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
       AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--       and f.share_cd    = p_share_cd
       AND g.peril_cd    = f.peril_cd
       AND g.line_cd     = a.line_cd
       AND g.peril_cd    = c.peril_cd
       AND g.zone_type   IN ('5','6','7')
    AND g.peril_type  = 'B';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    v_peril_type := 'A';
  END;
  IF v_peril_type = 'B' THEN
 SELECT fb.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fb,
     GIIS_PERIL    gb
     WHERE 1=1
    AND fb.dist_no     = p_dist_no
    AND gb.line_cd   = p_line_cd
    AND gb.peril_cd   = fb.peril_cd
    AND fb.peril_cd    = p_peril_cd
    AND fb.share_cd    = p_share_cd
    AND fb.item_no     = p_item_no
     AND gb.zone_type   IN ('5','6','7')
       AND gb.peril_type  = 'B';
  ELSE
 SELECT fa.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fa
     WHERE 1=1
    AND fa.dist_no     = p_dist_no
    AND fa.dist_seq_no >= 0
    AND fa.line_cd   = p_line_cd
    AND fa.peril_cd    = p_peril_cd
    AND fa.share_cd    = p_share_cd
    AND fa.item_no   = p_item_no
    AND fa.peril_cd IN (
        SELECT peril_cd
       FROM GIPI_ITMPERIL b1,
         GIPI_POLBASIC a1
      WHERE b1.item_no     = p_item_no
        AND a1.line_cd     = p_line_cd
     AND a1.subline_cd  = p_subline_cd
        AND a1.iss_cd      = p_iss_cd
        AND a1.issue_yy    = p_issue_yy
        AND a1.pol_seq_no  = p_pol_seq_no
        AND a1.renew_no    = p_renew_no
              AND a1.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(a1.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(a1.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(a1.endt_expiry_date), TRUNC(a1.expiry_date)) >= TRUNC(p_as_of)
        AND b1.policy_id   = a1.policy_id
        AND b1.line_cd     = a1.line_cd
        AND (b1.peril_cd, b1.tsi_amt) IN (
            SELECT MAX(c2.peril_cd),c2.tsi_amt
              FROM GIPI_POLBASIC         a2,
                         GIPI_FIREITEM         d2,
                         GIPI_ITMPERIL         c2,
                         GIUW_POL_DIST         e2,
                        GIIS_PERIL   g2
                   WHERE 1=1
                     AND a2.policy_id   = d2.policy_id
                     AND a2.par_id      = e2.par_id
                     AND e2.dist_flag   = '3'
                     AND a2.policy_id   = c2.policy_id
                     AND d2.item_no     = c2.item_no
                     AND a2.line_cd     = c2.line_cd
      AND e2.dist_no >= 0
                     AND a2.line_cd     = p_line_cd
                     AND a2.subline_cd  = p_subline_cd
                     AND a2.iss_cd      = p_iss_cd
                     AND a2.issue_yy    = p_issue_yy
                     AND a2.pol_seq_no  = p_pol_seq_no
                     AND a2.renew_no    = p_renew_no
                     AND d2.item_no     = p_item_no
                     AND a2.pol_flag IN ('1','2','3','4','X')
            AND TRUNC(a2.incept_date) <=  TRUNC(p_as_of)
            AND TRUNC(a2.eff_date) <= TRUNC(p_as_of)
            AND NVL(TRUNC(a2.endt_expiry_date), TRUNC(a2.expiry_date)) >= TRUNC(p_as_of)
                     AND g2.line_cd     = a2.line_cd
                     AND g2.peril_cd    = c2.peril_cd
         AND g2.zone_type   IN ('5','6','7')
      AND c2.tsi_amt IN
       (SELECT MAX(c3.tsi_amt)
                  FROM GIPI_POLBASIC         a3,
                                 GIPI_FIREITEM         d3,
                                 GIPI_ITMPERIL         c3,
                                 GIUW_POL_DIST         e3,
                              GIIS_PERIL      g3
                           WHERE 1=1
                             AND a3.policy_id   = d3.policy_id
                             AND a3.par_id      = e3.par_id
                             AND e3.dist_flag   = '3'
                             AND a3.policy_id   = c3.policy_id
                             AND d3.item_no     = c3.item_no
                             AND a3.line_cd     = c3.line_cd
        AND e3.dist_no >= 0
                             AND a3.line_cd     = p_line_cd
                             AND a3.subline_cd  = p_subline_cd
                          AND a3.iss_cd      = p_iss_cd
                          AND a3.issue_yy    = p_issue_yy
                          AND a3.pol_seq_no  = p_pol_seq_no
                          AND a3.renew_no    = p_renew_no
                             AND d3.item_no     = p_item_no
                             AND a3.pol_flag IN ('1','2','3','4','X')
              AND TRUNC(a3.incept_date) <=  TRUNC(p_as_of)
              AND TRUNC(a3.eff_date) <= TRUNC(p_as_of)
              AND NVL(TRUNC(a3.endt_expiry_date), TRUNC(a3.expiry_date)) >= TRUNC(p_as_of)
                             AND g3.line_cd     = a3.line_cd
                             AND g3.peril_cd    = c3.peril_cd
        AND g3.zone_type   IN ('5','6','7'))
        GROUP BY c2.tsi_amt));
  END IF;
 RETURN(NVL(v_tsi,0));
   END;
FUNCTION get_tf_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     IN VARCHAR2,
   p_subline_cd  IN VARCHAR2,
   p_iss_cd   IN VARCHAR2,
   p_issue_yy   IN NUMBER,
   p_pol_seq_no  IN NUMBER,
      p_renew_no  IN NUMBER,
      p_item_no   IN NUMBER,
   p_peril_cd IN NUMBER,
   p_share_cd IN NUMBER,
   p_dist_no     IN NUMBER,
   p_as_of  IN DATE)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
  BEGIN
  BEGIN
   SELECT DISTINCT g.peril_type
   INTO v_peril_type
      FROM GIPI_POLBASIC         a,
           GIPI_FIREITEM         d,
           GIPI_ITMPERIL         c,
           GIUW_POL_DIST         e,
           GIUW_ITEMPERILDS_DTL  f,
           GIIS_PERIL      g
     WHERE 1=1
       AND a.policy_id   = d.policy_id
       AND a.par_id      = e.par_id
       AND e.dist_flag   = '3'
       AND a.policy_id   = c.policy_id
       AND d.item_no     = c.item_no
       AND a.line_cd     = c.line_cd
       AND e.dist_no     = f.dist_no
       AND f.dist_seq_no >= 0
       AND d.item_no     = f.item_no
       AND c.peril_cd    = f.peril_cd
       AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
       AND a.issue_yy    = p_issue_yy
       AND a.pol_seq_no  = p_pol_seq_no
       AND a.renew_no    = p_renew_no
       AND d.item_no     = p_item_no
       AND a.pol_flag IN ('1','2','3','4','X')
       AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
       AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
       AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
--       and f.share_cd    = p_share_cd
       AND g.peril_cd    = f.peril_cd
       AND g.line_cd     = a.line_cd
       AND g.peril_cd    = c.peril_cd
       AND g.zone_type   IN ('1','2')
    AND g.peril_type  = 'B';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    v_peril_type := 'A';
  END;
  IF v_peril_type = 'B' THEN
 SELECT fb.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fb,
     GIIS_PERIL    gb
     WHERE 1=1
    AND fb.dist_no     = p_dist_no
    AND gb.line_cd   = p_line_cd
    AND gb.peril_cd   = fb.peril_cd
    AND fb.peril_cd    = p_peril_cd
    AND fb.share_cd    = p_share_cd
    AND fb.item_no     = p_item_no
       AND gb.zone_type   IN ('1','2')
       AND gb.peril_type  = 'B';
  ELSE
 SELECT fa.dist_tsi
      INTO v_tsi
   FROM GIUW_ITEMPERILDS_DTL  fa
     WHERE 1=1
    AND fa.dist_no     = p_dist_no
    AND fa.dist_seq_no >= 0
    AND fa.line_cd   = p_line_cd
    AND fa.peril_cd    = p_peril_cd
    AND fa.share_cd    = p_share_cd
    AND fa.item_no   = p_item_no
    AND fa.peril_cd IN (
        SELECT peril_cd
       FROM GIPI_ITMPERIL b1,
         GIPI_POLBASIC a1
      WHERE b1.item_no     = p_item_no
        AND a1.line_cd     = p_line_cd
     AND a1.subline_cd  = p_subline_cd
        AND a1.iss_cd      = p_iss_cd
        AND a1.issue_yy    = p_issue_yy
        AND a1.pol_seq_no  = p_pol_seq_no
        AND a1.renew_no    = p_renew_no
              AND a1.pol_flag IN ('1','2','3','4','X')
         AND TRUNC(a1.incept_date) <=  TRUNC(p_as_of)
         AND TRUNC(a1.eff_date) <= TRUNC(p_as_of)
         AND NVL(TRUNC(a1.endt_expiry_date), TRUNC(a1.expiry_date)) >= TRUNC(p_as_of)
        AND b1.policy_id   = a1.policy_id
        AND b1.line_cd     = a1.line_cd
        AND (b1.peril_cd, b1.tsi_amt) IN (
            SELECT MAX(c2.peril_cd),c2.tsi_amt
              FROM GIPI_POLBASIC         a2,
                         GIPI_FIREITEM         d2,
                         GIPI_ITMPERIL         c2,
                         GIUW_POL_DIST         e2,
                        GIIS_PERIL   g2
                   WHERE 1=1
                     AND a2.policy_id   = d2.policy_id
                     AND a2.par_id      = e2.par_id
                     AND e2.dist_flag   = '3'
                     AND a2.policy_id   = c2.policy_id
                     AND d2.item_no     = c2.item_no
                     AND a2.line_cd     = c2.line_cd
      AND e2.dist_no >= 0
                     AND a2.line_cd     = p_line_cd
                     AND a2.subline_cd  = p_subline_cd
                     AND a2.iss_cd      = p_iss_cd
                     AND a2.issue_yy    = p_issue_yy
                     AND a2.pol_seq_no  = p_pol_seq_no
                     AND a2.renew_no    = p_renew_no
                     AND d2.item_no     = p_item_no
                     AND a2.pol_flag IN ('1','2','3','4','X')
            AND TRUNC(a2.incept_date) <=  TRUNC(p_as_of)
            AND TRUNC(a2.eff_date) <= TRUNC(p_as_of)
            AND NVL(TRUNC(a2.endt_expiry_date), TRUNC(a2.expiry_date)) >= TRUNC(p_as_of)
                     AND g2.line_cd     = a2.line_cd
                     AND g2.peril_cd    = c2.peril_cd
         --AND g2.zone_type   IN ('1','2')
      AND g2.zone_type IN (SELECT MAX(zone_type)
                          FROM GIIS_PERIL
             WHERE line_cd = 'FI'
               AND zone_type IN ('1','2'))--where max is 2(typhoon)
      AND c2.tsi_amt IN
       (SELECT MAX(c3.tsi_amt)
                  FROM GIPI_POLBASIC         a3,
                                 GIPI_FIREITEM         d3,
                                 GIPI_ITMPERIL         c3,
                                 GIUW_POL_DIST         e3,
                              GIIS_PERIL      g3
                           WHERE 1=1
                             AND a3.policy_id   = d3.policy_id
                             AND a3.par_id      = e3.par_id
                             AND e3.dist_flag   = '3'
                             AND a3.policy_id   = c3.policy_id
                             AND d3.item_no     = c3.item_no
                             AND a3.line_cd     = c3.line_cd
        AND e3.dist_no >= 0
                             AND a3.line_cd     = p_line_cd
                             AND a3.subline_cd  = p_subline_cd
                          AND a3.iss_cd      = p_iss_cd
                          AND a3.issue_yy    = p_issue_yy
                          AND a3.pol_seq_no  = p_pol_seq_no
                          AND a3.renew_no    = p_renew_no
                             AND d3.item_no     = p_item_no
              AND NVL(a3.pol_flag,'A') IN ('1','2','3','4','X')
              AND TRUNC(a3.incept_date) <=  TRUNC(p_as_of)
              AND TRUNC(a3.eff_date) <= TRUNC(p_as_of)
              AND NVL(TRUNC(a3.endt_expiry_date), TRUNC(a3.expiry_date)) >= TRUNC(p_as_of)
                             AND g3.line_cd     = a3.line_cd
                             AND g3.peril_cd    = c3.peril_cd
           AND g3.zone_type   IN ('1','2'))
        GROUP BY c2.tsi_amt));
  END IF;
 RETURN(NVL(v_tsi,0));
   END;

FUNCTION risk_count_fd(
   p_fd_zone  IN VARCHAR2,
   p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
 RETURN NUMBER IS
    v_cnt NUMBER;
 BEGIN
  
 IF p_risk_cnt = 'P'  THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.flood_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.flood_zone, '@@@') = NVL (p_fd_zone, '@@@')
   AND b.user_id = USER
 GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no; 
 ELSIF p_risk_cnt = 'R' THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.flood_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.flood_zone, '@@@') = NVL (p_fd_zone, '@@@')
   AND b.user_id = USER
 GROUP BY c.risk_cd;
 END IF;
 
 
  
 RETURN(NVL(v_cnt,0));

 END;  

 FUNCTION risk_count_ty(
    p_ty_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
 RETURN NUMBER IS
    v_cnt NUMBER;
 BEGIN
 
 IF p_risk_cnt = 'P'  THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.typhoon_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.typhoon_zone, '@@@') = NVL (p_ty_zone, '@@@')
   AND b.user_id = USER
 GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no; 
 ELSIF p_risk_cnt = 'R' THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.typhoon_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.typhoon_zone, '@@@') = NVL (p_ty_zone, '@@@')
   AND b.user_id = USER
 GROUP BY c.risk_cd; 
 RETURN(NVL(v_cnt,0));
 END IF;
 
 END; 

 FUNCTION risk_count_eq(
    p_eq_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
 RETURN NUMBER IS
    v_cnt NUMBER;
 BEGIN
 
 
 IF p_risk_cnt = 'P' THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.eq_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.eq_zone, '@@@') = NVL (p_eq_zone, '@@@')
   AND b.user_id = USER
 GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no;
 ELSIF p_risk_cnt = 'R' THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.eq_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.eq_zone, '@@@') = NVL (p_eq_zone, '@@@')
   AND b.user_id = USER
 GROUP BY c.risk_cd;
 END IF; 
  
 RETURN(NVL(v_cnt,0));

 END; 
 
 FUNCTION risk_count_tf(
    p_tf_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
 RETURN NUMBER IS
    v_cnt NUMBER;
 BEGIN
 
 IF p_risk_cnt = 'P' THEN
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.typhoon_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.typhoon_zone, '@@@') = NVL (p_tf_zone, '@@@')
   AND b.user_id = USER
 GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no; 
 ELSIF p_risk_cnt = 'R' THEN 
 SELECT SUM(COUNT(DISTINCT NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
       gipi_fireitem c, 
     giuw_pol_dist d, 
     giuw_itemds_dtl e, 
     gipi_firestat_extract_dtl b
 WHERE a.policy_id = b.policy_id
   AND c.item_no = b.item_no
   AND c.policy_id = b.policy_id
   AND d.policy_id = b.policy_id
   AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
   AND d.dist_no = e.dist_no
   AND e.line_cd = 'FI'
   AND e.item_no = b.item_no
   AND A.pol_flag != '4'
   AND e.share_cd = b.share_cd
   and c.typhoon_zone = b.zone_no
   AND b.share_cd = p_share_cd
   AND NVL (c.typhoon_zone, '@@@') = NVL (p_tf_zone, '@@@')
   AND b.user_id = USER
 GROUP BY c.risk_cd;
 END IF;
 RETURN(NVL(v_cnt,0));

 END;
 
 FUNCTION risk_count(
   p_fi_zone  IN VARCHAR2,
   p_share_cd IN NUMBER,
   p_type IN VARCHAR2,
   p_risk_cnt IN VARCHAR2,
   p_user       IN VARCHAR2) --edgar 03/09/2015
 RETURN NUMBER IS
   v_cnt NUMBER;
 BEGIN

 IF p_risk_cnt = 'P' THEN
 SELECT SUM(COUNT(DISTINCT c.block_id||NVL(c.risk_cd,'@@@')))
   INTO v_cnt
   FROM gipi_polbasic a, 
        gipi_fireitem c, 
        giuw_pol_dist d, 
        giuw_itemds_dtl e, 
        gipi_firestat_extract_dtl b
  WHERE a.policy_id = b.policy_id
    AND c.item_no = b.item_no
    AND c.policy_id = b.policy_id
    AND d.policy_id = b.policy_id
    AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
    AND d.dist_no = e.dist_no
    AND e.line_cd = 'FI'
    AND e.item_no = b.item_no
    AND A.pol_flag != '4'
    AND e.share_cd = b.share_cd
    AND b.zone_type = p_type
    AND b.share_cd = p_share_cd
    AND DECODE(p_type, '1', NVL (c.flood_zone, '@@@'), '2',NVL(c.typhoon_zone,'@@@') ,'3',NVL(c.eq_zone,'@@@'),'5', NVL(NVL(c.typhoon_zone,c.flood_zone),'@@@'),'@@@') = NVL (p_fi_zone, '@@@') 
    AND b.user_id = /*USER*/p_user /*modified edgar 02/24/2015*/
 AND b.as_of_sw = 'Y'
  GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no; 
 ELSIF p_risk_cnt = 'R' THEN 
 SELECT SUM(COUNT(DISTINCT c.block_id||NVL(c.risk_cd,'@@@')))
     INTO v_cnt
     FROM gipi_polbasic a, 
         gipi_fireitem c, 
       giuw_pol_dist d, 
       giuw_itemds_dtl e, 
       gipi_firestat_extract_dtl b
   WHERE a.policy_id = b.policy_id
     AND c.item_no = b.item_no
     AND c.policy_id = b.policy_id
     AND d.policy_id = b.policy_id
     AND d.dist_flag = DECODE(a.pol_flag,'5','4','3')
     AND d.dist_no = e.dist_no
     AND e.line_cd = 'FI'
     AND e.item_no = b.item_no
     AND A.pol_flag != '4'
     AND e.share_cd = b.share_cd
     --and DECODE(p_type,'1',c.flood_zone, '2', c.typhoon_zone,'3',c.eq_zone,'5', NVL(c.typhoon_zone,c.flood_zone),0) = b.zone_no
     AND b.zone_type = p_type
  AND b.share_cd = p_share_cd
     --AND c.flood_zone = p_fi_Zone
  AND DECODE(p_type, '1', NVL (c.flood_zone, '@@@'), '2',NVL(c.typhoon_zone,'@@@') ,'3',NVL(c.eq_zone,'@@@'),'5', NVL(NVL(c.typhoon_zone,c.flood_zone),'@@@'),'@@@') = NVL (p_fi_zone, '@@@')
     AND b.user_id = /*USER*/p_user /*modified edgar 02/24/2015*/
  AND b.as_of_sw = 'Y'
   GROUP BY c.block_id, c.risk_cd; 

 END IF;
 RETURN(NVL(v_cnt,0));

 END;




END;
/


