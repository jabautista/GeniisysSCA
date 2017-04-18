CREATE OR REPLACE PACKAGE BODY CPI.P_Tariff_Asof_Dtl AS
  /* rollie june102004
  ** to show the details of firestat
  ** based on package P_TARIFF_ASOF
  */
  /* jenny vi lim 05092005
     included fi_item_grp in the extraction and insert.*/
  PROCEDURE EXTRACT(
    p_as_of      IN DATE,
    p_bus_cd     IN NUMBER,
    p_zone       IN VARCHAR2,
 p_type       IN VARCHAR2,
 p_inc_endt   IN VARCHAR2, -- aron
 p_inc_exp    IN VARCHAR2, --aron
 p_peril_type IN VARCHAR2, --aron
 p_user       IN VARCHAR2) --edgar 03/09/2015
  AS
    TYPE line_tab     IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE subline_tab  IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE iss_cd_tab   IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE issue_tab    IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE pol_seq_tab  IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE renew_tab    IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE endt_seq_tab IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE tariff_tab   IS TABLE OF GIPI_ITMPERIL.tarf_cd%TYPE;
    TYPE zone_tab     IS TABLE OF GIPI_FIREITEM.eq_zone%TYPE;
    TYPE peril_tab    IS TABLE OF GIPI_ITMPERIL.peril_cd%TYPE;
    TYPE tsi_tab      IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
    TYPE prem_tab     IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
 TYPE policy_tab   IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE item_no_tab  IS TABLE OF GIPI_FIREITEM.item_no%TYPE;
    TYPE assd_no_tab  IS TABLE OF GIIS_ASSURED.assd_no%TYPE;
 TYPE fi_grp_tab   IS TABLE OF GIIS_FI_ITEM_TYPE.fi_item_grp%TYPE;
    vv_policy_id   policy_tab;
 vv_item_no    item_no_tab;
 vv_assd_no    assd_no_tab;
    vv_line_cd        line_tab;
    vv_subline_cd     subline_tab;
    vv_iss_cd         iss_cd_tab;
    vv_issue_yy       issue_tab;
    vv_pol_seq_no     pol_seq_tab;
    vv_renew_no       renew_tab;
    vv_endt_seq_no    endt_seq_tab;
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
      FROM GIXX_FIRESTAT_SUMMARY_DTL
     WHERE as_of_sw = 'Y'
       AND user_id = /*USER*/p_user; /*modified edgar 02/24/2015*/
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* start extracting records here and insert in giix_firestat_summary_dtl */
    SELECT a.policy_id,
     d.item_no,
     h.assd_no,
        a.line_cd,
           a.subline_cd,
           a.iss_cd,
           a.issue_yy,
           a.pol_seq_no,
           a.renew_no,
           a.endt_seq_no,
           NVL(c.tarf_cd,d.tarf_cd)tarf_cd,
           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
                       '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0') zonetype,
           c.peril_cd,
           SUM(NVL(Get_Dist_prem_Tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_type,p_as_of,'T',p_inc_endt),0)* b.currency_rt) tsi_amount,
--     sum(f.dist_tsi  * b.currency_rt) tsi_amount
           SUM(NVL(Get_Dist_prem_Tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_type,p_as_of,'P',p_inc_endt),0)* b.currency_rt) prem_amount,
     --SUM(f.dist_prem* b.currency_rt) prem_amount,
     i.fi_item_grp
      BULK COLLECT INTO
           vv_policy_id,
     vv_item_no,
     vv_assd_no,
     vv_line_cd,
           vv_subline_cd,
           vv_iss_cd,
           vv_issue_yy,
           vv_pol_seq_no,
           vv_renew_no,
           vv_endt_seq_no,
           vv_tariff_cd,
           vv_zone_type,
           vv_peril_cd,
           vv_tsi_amt,
           vv_prem_amt,
     vv_fi_grp_type
      FROM GIPI_ITEM             b,
           GIUW_ITEMPERILDS_DTL  f,
           GIUW_POL_DIST         e,
           GIPI_FIREITEM         d,
           GIPI_POLBASIC         a,
     GIPI_ITMPERIL         c,
     GIPI_PARLIST          h,
           (SELECT line_cd, peril_cd--, peril_type
              FROM GIIS_PERIL
             WHERE INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','4','4','XX'),zone_type) > 0
      and line_cd = giisp.v('LINE_CODE_FI')) g,
     GIIS_FI_ITEM_TYPE     i
     WHERE a.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
       AND a.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, a.iss_cd)
      -- AND a.pol_flag IN ('1','2','3','4','X')
       AND TRUNC(a.incept_date) <=  TRUNC(to_date(p_as_of))
       AND TRUNC(a.eff_date) <= TRUNC(to_date(p_as_of))
       AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(to_date(p_as_of))
    AND a.policy_id = b.policy_id --
    AND c.item_no   = b.item_no   --
    AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
       AND c.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
       AND c.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
    AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
       AND e.dist_flag = '3'       --  pol_dist
    AND a.par_id    = e.par_id     --  polbasic   = pol_dist
       AND a.policy_id = d.policy_id  --  polbasic   = fireitem
    AND c.item_no   = d.item_no    --  itemperil  = fireitem
    AND c.policy_id = a.policy_id  --  itemperil  = polbasic
    AND c.line_cd   = a.line_cd    --  itemperil  = polbasic
    AND g.line_cd   = c.line_cd    --  giis_peril = item_peril
    AND g.peril_cd  = c.peril_cd   --  giis_peril = item_peril
    AND a.line_cd   = g.line_cd
    AND a.par_id    = h.par_id
       AND DECODE (p_zone, 'ALL',
                        NVL(DECODE(p_type,'3',d.eq_zone,
                                   '1',d.flood_zone,
                                   '2',d.typhoon_zone,
            '5',NVL(d.typhoon_zone,d.flood_zone),
            'X'),'-1'),
          NVL(DECODE(p_type,'3',d.eq_zone,
                '1',d.flood_zone,'2',d.typhoon_zone,
             '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-2'))
         IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
                           '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1')
    AND A.endt_seq_no = 0 -- aaron
       AND (p_inc_exp = 'N' AND A.pol_flag IN ('1','2','3') 
           OR p_inc_exp = 'Y' AND A.pol_flag IN ('1','2','3','X'))
    AND d.fr_item_type = i.fr_item_type(+)
     GROUP BY a.policy_id,
         d.item_no,
     h.assd_no,
           a.line_cd,
              a.subline_cd,
              a.iss_cd,
              a.issue_yy,
              a.pol_seq_no,
              a.renew_no,
              a.endt_seq_no,
              c.peril_cd,
              NVL(c.tarf_cd,d.tarf_cd),
              NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
                       '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0'),
     i.fi_item_grp ;

    IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO GIXX_FIRESTAT_SUMMARY_DTL
                (policy_id,       item_no,       assd_no,
     line_cd,                     subline_cd,                 iss_cd,
                 issue_yy,                    pol_seq_no,                 renew_no,
                 tarf_cd,                     tariff_zone,                peril_cd,
                 tsi_amt,                     prem_amt,                   extract_dt,
                 user_id,                     as_of_sw,                   as_of_date,
     fi_item_grp)
                VALUES
                 (vv_policy_id(cnt),    vv_item_no(cnt),     vv_assd_no(cnt),
      vv_line_cd(cnt),            vv_subline_cd(cnt),         vv_iss_cd(cnt),
                  vv_issue_yy(cnt),           vv_pol_seq_no(cnt),         vv_renew_no(cnt),
                  NVL(vv_tariff_cd(cnt),'0'), vv_zone_type(cnt),          NVL(vv_peril_cd(cnt),0),
                  vv_tsi_amt(cnt),            vv_prem_amt(cnt),           v_extract_dt,
                  /*USER*/p_user /*modified edgar 02/24/2015*/,                       'Y',                        p_as_of,
      NVL(vv_fi_grp_type(cnt),NULL));
 
 END IF;
    COMMIT;
 
 FOR X IN (SELECT b.policy_id, A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no
                FROM GIPI_POLBASIC A, GIXX_FIRESTAT_SUMMARY_DTL b
               WHERE 1=1
              AND A.policy_id = b.policy_id
           AND b.as_of_sw = 'Y'
         AND b.user_id = /*USER*/p_user /*modified edgar 02/24/2015*/
         GROUP BY b.policy_id, A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no)
    LOOP
   SELECT a.policy_id,
     d.item_no,
     h.assd_no,
        a.line_cd,
           a.subline_cd,
           a.iss_cd,
           a.issue_yy,
           a.pol_seq_no,
           a.renew_no,
           a.endt_seq_no,
           NVL(c.tarf_cd,d.tarf_cd)tarf_cd,
           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
                       '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0') zonetype,
           c.peril_cd,
            SUM(NVL(Get_Dist_prem_Tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_type,p_as_of,'T', p_inc_endt),0)* b.currency_rt) tsi_amount,
--     sum(f.dist_tsi  * b.currency_rt) tsi_amount
           SUM(NVL(Get_Dist_prem_Tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
     a.pol_seq_no, a.renew_no,d.item_no,c.peril_cd,f.share_cd,f.dist_no,p_type,p_as_of,'P',p_inc_endt),0)* b.currency_rt) prem_amount,
     --SUM(f.dist_prem* b.currency_rt) prem_amount,
     i.fi_item_grp
      BULK COLLECT INTO
           vv_policy_id,
     vv_item_no,
     vv_assd_no,
     vv_line_cd,
           vv_subline_cd,
           vv_iss_cd,
           vv_issue_yy,
           vv_pol_seq_no,
           vv_renew_no,
           vv_endt_seq_no,
           vv_tariff_cd,
           vv_zone_type,
           vv_peril_cd,
           vv_tsi_amt,
           vv_prem_amt,
     vv_fi_grp_type
      FROM GIPI_ITEM             b,
           GIUW_ITEMPERILDS_DTL  f,
           GIUW_POL_DIST         e,
           GIPI_FIREITEM         d,
           GIPI_POLBASIC         a,
     GIPI_ITMPERIL         c,
     GIPI_PARLIST          h,
           (SELECT line_cd, peril_cd--, peril_type
              FROM GIIS_PERIL
             WHERE INSTR(DECODE(p_type,'3','567','1','1','2','2','5','12','4','4','XX'),zone_type) > 0
      AND line_cd = giisp.v('LINE_CODE_FI')) g,
     GIIS_FI_ITEM_TYPE     i
     WHERE a.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
       AND a.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, a.iss_cd)
      -- AND a.pol_flag IN ('1','2','3','4','X')
       AND ((p_inc_endt = 'N' AND TRUNC(A.incept_date) <=  TRUNC(to_date(p_as_of))) OR (p_inc_endt = 'Y' AND A.incept_date = A.incept_date))
         AND ((p_inc_endt = 'N' AND TRUNC(A.eff_date) <= TRUNC(to_date(p_as_of)))  OR (p_inc_endt = 'Y' AND A.eff_date = A.eff_date))
         AND ((p_inc_Endt = 'N' AND NVL(TRUNC(A.endt_expiry_date), TRUNC(A.expiry_date)) >= TRUNC(p_as_of)) OR (p_inc_endt = 'Y' AND A.expiry_date = A.expiry_date) )
    --AND TRUNC(a.incept_date) <=  TRUNC(p_as_of)
       --AND TRUNC(a.eff_date) <= TRUNC(p_as_of)
       --AND NVL(TRUNC(a.endt_expiry_date), TRUNC(a.expiry_date)) >= TRUNC(p_as_of)
    AND a.policy_id = b.policy_id --
    AND c.item_no   = b.item_no   --
    AND e.dist_no   = f.dist_no    --  pol_dist   = itemperilds_dtl
       AND c.item_no   = f.item_no    --  pol_dist   = itemperilds_dtl
       AND c.peril_cd  = f.peril_cd   --  pol_dist   = itemperilds_dtl
    AND f.dist_seq_no >= 0       --  pol_dist   = itemperilds_dtl
       AND e.dist_flag = '3'       --  pol_dist
    AND a.par_id    = e.par_id     --  polbasic   = pol_dist
       AND a.policy_id = d.policy_id  --  polbasic   = fireitem
    AND c.item_no   = d.item_no    --  itemperil  = fireitem
    AND c.policy_id = a.policy_id  --  itemperil  = polbasic
    AND c.line_cd   = a.line_cd    --  itemperil  = polbasic
    AND g.line_cd   = c.line_cd    --  giis_peril = item_peril
    AND g.peril_cd  = c.peril_cd   --  giis_peril = item_peril
    AND a.line_cd   = g.line_cd
    AND a.par_id    = h.par_id
       AND DECODE (p_zone, 'ALL',
                        NVL(DECODE(p_type,'3',d.eq_zone,
                                   '1',d.flood_zone,
                                   '2',d.typhoon_zone,
            '5',NVL(d.typhoon_zone,d.flood_zone),
            'X'),'-1'),
          NVL(DECODE(p_type,'3',d.eq_zone,
                '1',d.flood_zone,'2',d.typhoon_zone,
             '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-2'))
         IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
                           '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1')
       AND (p_inc_exp = 'N' AND A.pol_flag IN ('1','2','3') 
           OR p_inc_exp = 'Y' AND A.pol_flag IN ('1','2','3','X'))
    AND A.line_cd = X.line_cd
   AND A.subline_cd = X.subline_cd
   AND A.iss_cd = X.iss_cd
   AND A.issue_yy = X.issue_yy
   AND A.pol_seq_no = X.pol_seq_no
   AND A.renew_no = X.renew_no
   AND A.policy_id != X.policy_id
    AND d.fr_item_type = i.fr_item_type(+)
     GROUP BY a.policy_id,
         d.item_no,
     h.assd_no,
           a.line_cd,
              a.subline_cd,
              a.iss_cd,
              a.issue_yy,
              a.pol_seq_no,
              a.renew_no,
              a.endt_seq_no,
              c.peril_cd,
              NVL(c.tarf_cd,d.tarf_cd),
              NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
                       '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0'),
     i.fi_item_grp ;

 
     IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO GIXX_FIRESTAT_SUMMARY_DTL
                (policy_id,       item_no,       assd_no,
     line_cd,                     subline_cd,                 iss_cd,
                 issue_yy,                    pol_seq_no,                 renew_no,
                 tarf_cd,                     tariff_zone,                peril_cd,
                 tsi_amt,                     prem_amt,                   extract_dt,
                 user_id,                     as_of_sw,                   as_of_date,
     fi_item_grp)
                VALUES
                 (vv_policy_id(cnt),    vv_item_no(cnt),     vv_assd_no(cnt),
      vv_line_cd(cnt),            vv_subline_cd(cnt),         vv_iss_cd(cnt),
                  vv_issue_yy(cnt),           vv_pol_seq_no(cnt),         vv_renew_no(cnt),
                  NVL(vv_tariff_cd(cnt),'0'), vv_zone_type(cnt),          NVL(vv_peril_cd(cnt),0),
                  vv_tsi_amt(cnt),            vv_prem_amt(cnt),           v_extract_dt,
                  /*USER*/p_user /*modified edgar 02/24/2015*/,                       'Y',                        p_as_of,
      NVL(vv_fi_grp_type(cnt),NULL));
 
 END IF;
    COMMIT;
  
  END LOOP; 
  END;
FUNCTION Get_Dist_prem_Tsi (
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
   p_as_of  IN DATE,
   p_prem_tsi    IN VARCHAR2,
   p_inc_endt    IN VARCHAR2)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
  BEGIN
  NULL;
  
  
  FOR X IN (SELECT SUM(DECODE(p_prem_tsi, 'T', b.dist_tsi, 'P', b.dist_prem)) dist_amt
              FROM GIUW_POL_DIST A, GIUW_ITEMPERILDS_DTL b
             WHERE EXISTS (SELECT '1'
                             FROM GIPI_POLBASIC C
                            WHERE 1=1
                              AND C.dist_flag = DECODE(C.pol_flag,'5','4','3')--if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
               AND line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND issue_yy = p_issue_yy
               AND pol_seq_no = p_pol_seq_no
               AND renew_no = p_renew_no
   AND ((p_inc_endt = 'N' AND TRUNC(C.incept_date) <=  TRUNC(p_as_of)) OR (p_inc_endt = 'Y' AND C.incept_date = C.incept_date))
         AND ((p_inc_endt = 'N' AND TRUNC(C.eff_date) <= TRUNC(p_as_of))  OR (p_inc_endt = 'Y' AND C.eff_date = C.eff_date))
         AND ((p_inc_Endt = 'N' AND NVL(TRUNC(C.endt_expiry_date), TRUNC(C.expiry_date)) >= TRUNC(p_as_of)) OR (p_inc_endt = 'Y' AND C.expiry_date = C.expiry_date) )
               AND C.policy_id = A.policy_id)
             AND A.dist_no = b.dist_no
             AND b.peril_cd = p_peril_cd
               AND b.item_no = p_item_no
               AND b.dist_no = p_dist_no
              AND b.share_cd = p_share_cd)
  LOOP
    v_tsi := X.dist_amt;
  END LOOP;                 
  RETURN(NVL(v_tsi,0));
    
  
  /*
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
  */
   END;
  
END;
/


