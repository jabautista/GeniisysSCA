CREATE OR REPLACE PACKAGE BODY CPI.P_Tariff_Asof AS
  /* jenny vi lim 05092005
     include fi_item_grp in the extraction and insert.*/
  PROCEDURE EXTRACT(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    P_Zone     IN VARCHAR2,
 p_type     IN VARCHAR2,
 p_user     IN VARCHAR2) --edgar 03/09/2015
  AS
    TYPE line_tab     IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE subline_tab  IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE iss_cd_tab   IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE issue_tab    IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE pol_seq_tab  IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE renew_tab    IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE endt_seq_tab IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE item_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.item_no%TYPE;
    TYPE tariff_tab   IS TABLE OF GIPI_ITMPERIL.tarf_cd%TYPE;
    TYPE zone_tab     IS TABLE OF GIPI_FIREITEM.eq_zone%TYPE;
    TYPE peril_tab    IS TABLE OF GIPI_ITMPERIL.peril_cd%TYPE;
    TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
    TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
 TYPE fi_grp_tab   IS TABLE OF GIIS_FI_ITEM_TYPE.fi_item_grp%TYPE;
    vv_line_cd        line_tab;
    vv_subline_cd     subline_tab;
    vv_iss_cd         iss_cd_tab;
    vv_issue_yy       issue_tab;
    vv_pol_seq_no     pol_seq_tab;
    vv_renew_no       renew_tab;
    vv_endt_seq_no    endt_seq_tab;
    vv_item_no        item_tab;
    vv_tariff_cd      tariff_tab;
    vv_zone_type      zone_tab;
    vv_peril_cd       peril_tab;
    vv_tsi_amt        tsi_tab;
    vv_prem_amt       prem_tab;
    vv_tariff_cd2     tariff_tab;
    vv_peril_cd2      peril_tab;
 vv_fi_grp_type   fi_grp_tab;
    v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE;
    v_extract_dt      DATE := SYSDATE;
  BEGIN
    DELETE
      FROM GIXX_FIRESTAT_SUMMARY
     WHERE as_of_sw = 'Y'
       AND user_id = /*USER*/p_user; /*modified edgar 02/24/2015*/
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');



 SELECT line_cd,
   subline_cd,
  iss_cd,
  issue_yy,
  pol_seq_no,
  renew_no,
  tarf_cd,
  tariff_zone,
  peril_cd,
  tariff_cd,
  SUM(tsi_amt),
  SUM(prem_amt),
  fi_item_grp 
   BULK COLLECT INTO 
        vv_line_cd,
        vv_subline_cd,
        vv_iss_cd,
        vv_issue_yy,
        vv_pol_seq_no,
        vv_renew_no,
        vv_tariff_cd,
        vv_zone_type,
        vv_peril_cd,
        vv_tariff_cd2,
  vv_tsi_amt,
        vv_prem_amt,
        vv_fi_grp_type
   FROM GIXX_FIRESTAT_SUMMARY_DTL
  WHERE user_id = USER
    AND NVL(as_of_sw,'N') = 'Y'
  GROUP BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, tarf_cd,tariff_zone,
       peril_cd, tariff_cd, fi_item_grp;

    /* start extracting records here and insert in giix_firestat_summary */
  --  SELECT A.line_cd,
--           A.subline_cd,
--           A.iss_cd,
--           A.issue_yy,
--           A.pol_seq_no,
--           A.renew_no,
--           A.endt_seq_no,
--           b.item_no,
--           NVL(C.tarf_cd,d.tarf_cd)tarf_cd,
--           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
--                       '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0') zonetype,
--           C.peril_cd,
--           SUM(NVL(Get_Dist_Tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
--     A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,p_type,p_as_of),0)* b.currency_rt) tsi_amount,
--     sum(f.dist_tsi  * b.currency_rt) tsi_amount
--           SUM(f.dist_prem* b.currency_rt) prem_amount,
--     h.fi_item_grp
--      BULK COLLECT INTO
--           vv_line_cd,
--           vv_subline_cd,
--           vv_iss_cd,
--           vv_issue_yy,
--           vv_pol_seq_no,
--           vv_renew_no,
--           vv_endt_seq_no,
--           vv_item_no,
--           vv_tariff_cd,
--           vv_zone_type,
--           vv_peril_cd,
--           vv_tsi_amt,
--           vv_prem_amt,
--     vv_fi_grp_type
--      FROM GIPI_ITEM             b,
--           GIUW_ITEMPERILDS_DTL  f,
--           GIUW_POL_DIST         e,
--           GIPI_FIREITEM         d,
--           GIPI_POLBASIC         A,
--     GIPI_ITMPERIL         C,
--           (SELECT line_cd, peril_cd--, peril_type
--              FROM GIIS_PERIL
--             WHERE INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','XX'),zone_type) > 0) g,
--     GIIS_FI_ITEM_TYPE h
--     WHERE A.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
--       AND A.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, A.iss_cd)
--       AND A.pol_flag IN ('1','2','3','4','X')
--       AND TRUNC(A.incept_date) <=  TRUNC(p_as_of)
--       AND TRUNC(A.eff_date) <= TRUNC(p_as_of)
--       AND NVL(TRUNC(A.endt_expiry_date), TRUNC(A.expiry_date)) >= TRUNC(p_as_of)
--    AND A.policy_id = b.policy_id --
--    AND C.item_no   = b.item_no   --
--    AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
--       AND C.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
--       AND C.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
--    AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
--       AND e.dist_flag = '3'       --  pol_dist
--    AND A.par_id    = e.par_id     --  polbasic   = pol_dist
--       AND A.policy_id = d.policy_id  --  polbasic   = fireitem
--    AND C.item_no   = d.item_no    --  itemperil  = fireitem
--    AND C.policy_id = A.policy_id  --  itemperil  = polbasic
--    AND C.line_cd   = A.line_cd    --  itemperil  = polbasic
--    AND g.line_cd   = C.line_cd    --  giis_peril = item_peril
--   AND g.peril_cd  = C.peril_cd   --  giis_peril = item_peril
--    AND A.line_cd  = g.line_cd
--       AND DECODE (P_Zone, 'ALL',
--                        NVL(DECODE(p_type,'3',d.eq_zone,
--                                   '1',d.flood_zone,
--                                   '2',d.typhoon_zone,
--            '5',NVL(d.typhoon_zone,d.flood_zone),
--            'X'),-1),
--          NVL(DECODE(p_type,'3',d.eq_zone,
--                '1',d.flood_zone,'2',d.typhoon_zone,
--             '5',NVL(d.typhoon_zone,d.flood_zone),'X'),-2))
--         IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
--                           '5',NVL(d.typhoon_zone,d.flood_zone),'X'),-1)
--    AND d.fr_item_type = h.fr_item_type
--     GROUP BY A.line_cd,
--              A.subline_cd,
--              A.iss_cd,
--              A.issue_yy,
--              A.pol_seq_no,
--              A.renew_no,
--              A.endt_seq_no,
--              b.item_no,
--              C.peril_cd,
--              NVL(C.tarf_cd,d.tarf_cd),
--              NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
--                       '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0'),
--     h.fi_item_grp     ;
    IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO GIXX_FIRESTAT_SUMMARY
                (line_cd,                     subline_cd,                 iss_cd,
                 issue_yy,                    pol_seq_no,                 renew_no,
                 tarf_cd,                     tariff_zone,                peril_cd,
                 tsi_amt,                     prem_amt,                   extract_dt,
                 user_id,                     as_of_sw,                   as_of_date,
     fi_item_grp)
                VALUES
                 (vv_line_cd(cnt),            vv_subline_cd(cnt),         vv_iss_cd(cnt),
                  vv_issue_yy(cnt),           vv_pol_seq_no(cnt),         vv_renew_no(cnt),
                  NVL(vv_tariff_cd(cnt),'0'), vv_zone_type(cnt),          NVL(vv_peril_cd(cnt),0),
                  vv_tsi_amt(cnt),            vv_prem_amt(cnt),           v_extract_dt,
                  /*USER*/p_user /*modified edgar 02/24/2015*/,                       'Y',                        p_as_of,
      NVL(vv_fi_grp_type(cnt),NULL));
    END IF;
    /* insert also those distinct eq_zone and share_cd which has no records of extract.
    ** initialize those amounts with zeros.
    */
    SELECT tarf_cd, b.peril_cd
      BULK COLLECT INTO
           vv_tariff_cd2, vv_peril_cd2
      FROM GIIS_PERIL_TARIFF A,
           GIIS_PERIL        b
     WHERE NOT EXISTS(SELECT 'X'
                        FROM GIXX_FIRESTAT_SUMMARY b
                       WHERE b.tariff_cd = A.tarf_cd)
       AND A.peril_cd =   b.peril_cd
       AND b.line_cd = 'FI'
       AND INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','XX'),b.zone_type) > 0;
    IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_tariff_cd2.FIRST..vv_tariff_cd2.LAST
         INSERT INTO GIXX_FIRESTAT_SUMMARY
                 (line_cd,             subline_cd,               iss_cd,
                  issue_yy,            pol_seq_no,                renew_no,
                  tarf_cd,             tariff_zone,              peril_cd,
                  tariff_cd,           tsi_amt,                 prem_amt,
                  extract_dt,          user_id,                   as_of_sw,
                     as_of_date,    fi_item_grp)
              VALUES('XX',                'XXXXXXX',                 'XX',
                     99,                  999999,                    99,
                     vv_tariff_cd2(cnt),  '00',                      vv_peril_cd2(cnt),
                     0,                   0,                         0,
                     v_extract_dt,        /*USER*/p_user /*modified edgar 02/24/2015*/,                      'Y',
                     p_as_of,     NULL);
    END IF;
    COMMIT;
  END;
FUNCTION Get_Dist_Tsi (
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
   p_type        IN VARCHAR2,
   p_as_of  IN DATE)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
  BEGIN
  BEGIN
   SELECT DISTINCT g.peril_type
   INTO v_peril_type
      FROM GIPI_POLBASIC         A,
           GIPI_FIREITEM         d,
           GIPI_ITMPERIL         C,
           GIUW_POL_DIST         e,
           GIUW_ITEMPERILDS_DTL  f,
           GIIS_PERIL      g
     WHERE 1=1
       AND A.policy_id   = d.policy_id
       AND A.par_id      = e.par_id
       AND e.dist_flag   = '3'
       AND A.policy_id   = C.policy_id
       AND d.item_no     = C.item_no
       AND A.line_cd     = C.line_cd
       AND e.dist_no     = f.dist_no
       AND f.dist_seq_no >= 0
       AND d.item_no     = f.item_no
       AND C.peril_cd    = f.peril_cd
       AND A.line_cd     = p_line_cd
       AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
       AND A.issue_yy    = p_issue_yy
       AND A.pol_seq_no  = p_pol_seq_no
       AND A.renew_no    = p_renew_no
       AND d.item_no     = p_item_no
       AND A.pol_flag IN ('1','2','3','4','X')
       AND TRUNC(A.incept_date) <=  TRUNC(p_as_of)
       AND TRUNC(A.eff_date) <= TRUNC(p_as_of)
       AND NVL(TRUNC(A.endt_expiry_date), TRUNC(A.expiry_date)) >= TRUNC(p_as_of)
--       and f.share_cd    = p_share_cd
       AND g.peril_cd    = f.peril_cd
       AND g.line_cd     = A.line_cd
       AND g.peril_cd    = C.peril_cd
    AND g.peril_type  = 'B'
    AND INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','XX'),g.zone_type) > 0;
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
       AND gb.peril_type  = 'B'
    AND INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','XX'),gb.zone_type) > 0;
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
         AND INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','XX'),g2.zone_type) > 0
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
           AND INSTR(DECODE(p_type,'3','567',
                '1','1',
              '2','2',
              '5','12','XX'),g3.zone_type) > 0)
        GROUP BY c2.tsi_amt));
  END IF;
 RETURN(NVL(v_tsi,0));
   END;

END;
/


