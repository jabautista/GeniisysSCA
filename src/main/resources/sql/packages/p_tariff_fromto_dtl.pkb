CREATE OR REPLACE PACKAGE BODY CPI.P_Tariff_Fromto_Dtl AS
  /* rollie june102004
  ** to show the details of firestat
  ** based on package P_TARIFF_FROMTO
  */
  /* jenny vi lim 05092005
     included fi_item_grp in the extraction and insert.*/
  
   /* Modified by :  Aaron
  ** Modified on :  October 10, 2008 
  ** Remarks     :  Modified to correct the amounts extracted.
  **                Added the following parameters: 
  **           i.  p_inc_endt   --> parameter to determine whether to include endorsements
  **                    beyond the given date of extraction
  **       ii.  p_inc_exp    --> parameter to determine whether to include expired policies or not
  **         iii.  p_peril_type --> parameter to determine the type of peril to be included;
  **                A (allied only) B (basic only ) AB (both) 
  **           
  */
  
  FUNCTION date_ok (
   /*revised by bdarusin, 11222002,
   if extract is by acct_ent_date, include spoiled policies but
   check the spld_acct_ent_date*/
    p_ad       IN DATE,
    p_ed       IN DATE,
    p_id       IN DATE,
    p_mth      IN VARCHAR2,
    p_year     IN NUMBER,
    p_spld_ad  IN DATE,
    p_pol_flag IN VARCHAR2,
    p_dt_type  IN VARCHAR2,
    p_fmdate   IN DATE,
    p_todate   IN DATE)
  RETURN NUMBER IS
    v_booking_fmdate  DATE;
    v_booking_todate  DATE;
  BEGIN
    IF p_pol_flag = '5' THEN
      IF p_dt_type = 'AD' AND TRUNC(p_spld_ad) >= p_fmdate
        AND TRUNC(p_spld_ad) <= p_todate THEN
        RETURN (1);
      ELSE
        RETURN (0);
      END IF;
    ELSE
       IF p_dt_type = 'AD' AND TRUNC(p_ad) >= p_fmdate AND TRUNC(p_ad) <= p_todate THEN
          RETURN (1);
       ELSIF p_dt_type = 'ED' AND TRUNC(p_ed) >= p_fmdate AND TRUNC(p_ed) <= p_todate THEN
          RETURN (1);
       ELSIF p_dt_type = 'ID' AND TRUNC(p_id) >= p_fmdate AND TRUNC(p_id) <= p_todate THEN
          RETURN (1);
       ELSIF p_dt_type = 'BD' THEN
          v_booking_fmdate := TO_DATE('01-'||SUBSTR(p_mth,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY');
          v_booking_todate := LAST_DAY(TO_DATE('01-'||SUBSTR(p_mth,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY'));
          IF v_booking_fmdate >= p_fmdate AND v_booking_todate <= p_todate THEN
             RETURN (1);
          ELSE
             RETURN (0);
          END IF;
       ELSE
          RETURN (0);
       END IF;
       RETURN(0);
   END IF;
   END;
  PROCEDURE EXTRACT(
    p_from     IN DATE,
    p_to       IN DATE,
    p_bus_cd   IN NUMBER,
    P_Zone     IN VARCHAR2,
    p_type     IN VARCHAR2,
    p_dt_type  IN VARCHAR2,
  p_inc_endt IN VARCHAR2,
  p_peril_type IN VARCHAR2,
  p_inc_exp  IN VARCHAR2,
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
    TYPE peril_tab    IS TABLE OF GIPI_ITMPERIL.peril_cd%TYPE;
    TYPE zone_tab     IS TABLE OF GIPI_FIREITEM.eq_zone%TYPE;
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
    vv_peril_cd       peril_tab;
    vv_zone_type      zone_tab;
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
     WHERE as_of_sw = 'N'
       AND user_id = /*USER*/p_user; --edgar 03/09/2015
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* start extracting records here and insert in giix_firestat_summary_dtl */
    /* start extracting policy records only (non endorsement) aaron
 */
 
 SELECT A.policy_id,
         d.item_no,
         h.assd_no,
           A.line_cd,
           A.subline_cd,
           A.iss_cd,
           A.issue_yy,
           A.pol_seq_no,
           A.renew_no,
           NVL(c.tarf_cd,d.tarf_cd) tarf_cd,
    --  NVL(c.tarf_cd,get_tarf_cd(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
       --  A.pol_seq_no,
       --    A.renew_no, C.item_no, p_dt_type, p_from, p_to, p_type, p_inc_endt)) tarf_cd,
           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,
                       '2',d.typhoon_zone,'5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0') zonetype,
           C.peril_cd,
           SUM(NVL(Get_Dist_prem_Tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
         A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,p_type,
         p_from, p_to, p_dt_type, 'T', p_inc_endt),0)* b.currency_rt) tsi_amount,
--           sum(f.dist_tsi* b.currency_rt) tsi_amount,
           SUM(NVL(Get_Dist_prem_Tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
         A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,p_type,
         p_from, p_to, p_dt_type, 'P', p_inc_endt),0)* b.currency_rt) prem_amount,
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
           GIPI_POLBASIC         A,
         GIPI_ITMPERIL         C,
         GIPI_PARLIST    h,
           (SELECT line_cd, peril_cd, peril_type
              FROM GIIS_PERIL
             WHERE INSTR(DECODE(p_type,'3','567','1','1','2','2','4','4','5','12','XX'),zone_type) > 0
      AND line_cd = giisp.v('LINE_CODE_FI')) g,
         GIIS_FI_ITEM_TYPE   i
     WHERE A.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
       AND A.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, A.iss_cd)
      --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
    --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
       AND date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
                   A.spld_acct_ent_date, A.pol_flag, p_dt_type, p_from, p_to) =  1
       AND A.policy_id = b.policy_id --
       AND C.item_no   = b.item_no   --
       AND e.dist_no   = f.dist_no    --  POL_DIST   = ITEMPERILDS_DTL
       AND C.item_no   = f.item_no    --  POL_DIST   = ITEMPERILDS_DTL
       AND C.peril_cd  = f.peril_cd   --  POL_DIST   = ITEMPERILDS_DTL
       AND f.dist_seq_no >= 0       --  POL_DIST   = ITEMPERILDS_DTL
       AND e.dist_flag = DECODE(A.pol_flag,'5','4','3')--IF POL_FLAG IS 5, DIST_FLAG SHLD BE 4, ELSE DIST_FLAG SHLD BE 3
       AND A.par_id    = e.par_id     --  POLBASIC   = POL_DIST
       AND A.policy_id = d.policy_id  --  POLBASIC   = FIREITEM
       AND C.item_no   = d.item_no    --  ITEMPERIL  = FIREITEM
       AND C.policy_id = A.policy_id  --  ITEMPERIL  = POLBASIC
       AND C.line_cd   = A.line_cd    --  ITEMPERIL  = POLBASIC
       AND g.line_cd   = C.line_cd    --  GIIS_PERIL = ITEM_PERIL
       AND g.peril_cd  = C.peril_cd   --  GIIS_PERIL = ITEM_PERIL
       AND A.line_cd   = g.line_cd
       AND h.par_id    = A.par_id
     AND (p_inc_exp = 'N' AND A.pol_flag IN ('1','2','3') 
           OR p_inc_exp = 'Y' AND A.pol_flag IN ('1','2','3','X'))
     AND A.endt_seq_no = 0
     AND g.peril_type = DECODE(p_peril_type,'A','A','B','B','AB',g.peril_type)
       AND DECODE (P_Zone, 'ALL', NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,
                  '2',d.typhoon_zone,'5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1'),
           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
          '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-2'))
           IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
           '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1')
       AND d.fr_item_type = i.fr_item_type(+)
     GROUP BY A.policy_id,
              d.item_no,
         h.assd_no,
              A.line_cd,
              A.subline_cd,
              A.iss_cd,
              A.issue_yy,
              A.pol_seq_no,
              A.renew_no,
              C.peril_cd,
              NVL(c.tarf_cd,d.tarf_cd),
     --NVL(C.tarf_cd,get_tarf_cd(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
           --  A.pol_seq_no,
           --     A.renew_no, C.item_no, p_dt_type, p_from, p_to, p_type,p_inc_endt)),
              NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
               '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0'),
         i.fi_item_grp ;
    IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_tariff_cd.FIRST..vv_tariff_cd.LAST
         INSERT INTO GIXX_FIRESTAT_SUMMARY_DTL
                (policy_id,             item_no,               assd_no,
         line_cd,                     subline_cd,                 iss_cd,
                 issue_yy,                    pol_seq_no,                 renew_no,
                 tarf_cd,                     tariff_zone,                peril_cd,
                 tsi_amt,                     prem_amt,                   extract_dt,
                 user_id,                     as_of_sw,                   date_from,
                 date_to,                     fi_item_grp)
                VALUES
                 (vv_policy_id(cnt),          vv_item_no(cnt),            vv_assd_no(cnt),
           vv_line_cd(cnt),            vv_subline_cd(cnt),         vv_iss_cd(cnt),
                  vv_issue_yy(cnt),           vv_pol_seq_no(cnt),         vv_renew_no(cnt),
                  NVL(vv_tariff_cd(cnt),'0'), vv_zone_type(cnt),          NVL(vv_peril_cd(cnt),0),
                  vv_tsi_amt(cnt),            vv_prem_amt(cnt),           v_extract_dt,
                  /*USER*/p_user,/*edgar 03/09/2015*/                       'N',                        p_from,
                  p_to,        NVL(vv_fi_grp_type(cnt), NULL));
    END IF;
    COMMIT;
  
   
    FOR X IN (SELECT b.policy_id, A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no
                FROM GIPI_POLBASIC A, GIXX_FIRESTAT_SUMMARY_DTL b
               WHERE 1=1
                 AND A.policy_id = b.policy_id
                 AND b.as_of_sw = 'N'
                 AND b.user_id = /*USER*/p_user --edgar 03/09/2015
               GROUP BY b.policy_id, A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no)
    LOOP  -- endt loop aaron
      SELECT A.policy_id,
          d.item_no,
        h.assd_no,
          A.line_cd,
             A.subline_cd,
             A.iss_cd,
             A.issue_yy,
             A.pol_seq_no,
             A.renew_no,
       NVL(C.tarf_cd,get_tarf_cd(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
           A.pol_seq_no,
           A.renew_no, C.item_no, p_dt_type, p_from, p_to, p_type,p_inc_endt)) tarf_cd,
             NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,
                       '2',d.typhoon_zone,'5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0') zonetype,
             C.peril_cd,
             SUM(NVL(Get_Dist_prem_Tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
        A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,p_type,
        p_from, p_to, p_dt_type, 'T', p_inc_endt),0)* b.currency_rt) tsi_amount,
    -- sum(f.dist_tsi* b.currency_rt) tsi_amount,
             SUM(NVL(Get_Dist_prem_Tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
        A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,p_type,
        p_from, p_to, p_dt_type, 'P', p_inc_endt),0)* b.currency_rt) prem_amount,
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
             GIPI_POLBASIC         A,
        GIPI_ITMPERIL         C,
        GIPI_PARLIST    h,
            (SELECT line_cd, peril_cd, peril_type
               FROM GIIS_PERIL
               WHERE INSTR(DECODE(p_type,'3','567','1','1','2','2','4','4','5','12','XX'),zone_type) > 0) g,
          GIIS_FI_ITEM_TYPE   i
       WHERE A.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
         AND A.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, A.iss_cd)
         --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
         --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
         AND DECODE(p_inc_endt, 'Y', 1, date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
                   A.spld_acct_ent_date, A.pol_flag, p_dt_type, p_from, p_to)) =  1
         AND A.policy_id = b.policy_id --
      AND C.item_no   = b.item_no   --
      AND e.dist_no   = f.dist_no    --  POL_DIST   = ITEMPERILDS_DTL
         AND C.item_no   = f.item_no    --  POL_DIST   = ITEMPERILDS_DTL
         AND C.peril_cd  = f.peril_cd   --  POL_DIST   = ITEMPERILDS_DTL
      AND f.dist_seq_no >= 0       --  POL_DIST   = ITEMPERILDS_DTL
         AND e.dist_flag = DECODE(A.pol_flag,'5','4','3')--IF POL_FLAG IS 5, DIST_FLAG SHLD BE 4, ELSE DIST_FLAG SHLD BE 3
      AND A.par_id    = e.par_id     --  POLBASIC   = POL_DIST
         AND A.policy_id = d.policy_id  --  POLBASIC   = FIREITEM
      AND C.item_no   = d.item_no    --  ITEMPERIL  = FIREITEM
      AND C.policy_id = A.policy_id  --  ITEMPERIL  = POLBASIC
      AND C.line_cd   = A.line_cd    --  ITEMPERIL  = POLBASIC
      AND g.line_cd   = C.line_cd    --  GIIS_PERIL = ITEM_PERIL
      AND g.peril_cd  = C.peril_cd   --  GIIS_PERIL = ITEM_PERIL
      AND A.line_cd   = g.line_cd
      AND h.par_id    = A.par_id
    AND (p_inc_exp = 'N' AND A.pol_flag IN ('1','2','3') 
           OR p_inc_exp = 'Y' AND A.pol_flag IN ('1','2','3','X'))
    AND g.peril_type = DECODE(p_peril_type,'A','A','B','B','AB',g.peril_type)
         AND DECODE (P_Zone, 'ALL', NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,
                  '2',d.typhoon_zone,'5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1'),
             NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
             '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-2'))
             IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
             '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1')
         AND d.fr_item_type = i.fr_item_type(+)
    AND A.line_cd = X.line_cd
      AND A.subline_cd = X.subline_cd
      AND A.iss_cd = X.iss_cd
      AND A.issue_yy = X.issue_yy
      AND A.pol_seq_no = X.pol_seq_no
      AND A.renew_no = X.renew_no
      AND NOT EXISTS (SELECT 1
                           FROM GIPI_POLBASIC z
              WHERE z.policy_id = A.policy_id
                            AND z.policy_id = X.policy_id)
       GROUP BY A.policy_id,
              d.item_no,
        h.assd_no,
             A.line_cd,
                A.subline_cd,
                A.iss_cd,
                A.issue_yy,
                A.pol_seq_no,
                A.renew_no,
                C.peril_cd,
          NVL(C.tarf_cd,get_tarf_cd(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
           A.pol_seq_no,
              A.renew_no, C.item_no, p_dt_type, p_from, p_to, p_type,p_inc_endt)),
                NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
             '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'0'),
        i.fi_item_grp ;

      IF NOT SQL%NOTFOUND THEN

        FORALL cnt IN vv_tariff_cd.FIRST..vv_tariff_cd.LAST
          INSERT INTO GIXX_FIRESTAT_SUMMARY_DTL
                (policy_id,            item_no,                    assd_no,
         line_cd,                     subline_cd,                 iss_cd,
                 issue_yy,                    pol_seq_no,                 renew_no,
                 tarf_cd,                     tariff_zone,                peril_cd,
                 tsi_amt,                     prem_amt,                   extract_dt,
                 user_id,                     as_of_sw,                   date_from,
                 date_to,            fi_item_grp)
           VALUES
                 (vv_policy_id(cnt),       vv_item_no(cnt),         vv_assd_no(cnt),
           vv_line_cd(cnt),            vv_subline_cd(cnt),         vv_iss_cd(cnt),
                  vv_issue_yy(cnt),           vv_pol_seq_no(cnt),         vv_renew_no(cnt),
                  NVL(vv_tariff_cd(cnt),'0'), vv_zone_type(cnt),          NVL(vv_peril_cd(cnt),0),
                  vv_tsi_amt(cnt),            vv_prem_amt(cnt),           v_extract_dt,
                  /*USER*/p_user,/*edgar 03/09/2015*/                       'N',                        p_from,
                  p_to,              NVL(vv_fi_grp_type(cnt),    NULL));
      END IF;
      COMMIT;

  END LOOP; -- endt loop aaron
  END;

FUNCTION Get_Dist_Prem_Tsi (
  /* Modified by Aaron
  ** Modified on: October 10, 2008
  ** Remarks: Modified the computation of tsi and premium amounts.
  **          The previous version includes only the maximum TSI.
  **    Current version already includes all TSI as long as the
  **          peril_Cd is within peril_type ('1' for flood, etc.).  The checking
  **          whether the peril_cd is within peril_type is in the main select
  **    statement in p_tariff_fromto_dtl.extract.
  */
  
  /* CREATED BY BDARUSIN 01/15/2002
  ** THIS FUNCTION RETURNS THE DIST TSI AMOUNT OF THE POLICY.
  ** THIS FUNCTION IS ONLY USED FOR THE PROCEDURES INVOLVING FIRE STAT
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
   p_from   IN DATE,
   p_to   IN DATE,
   p_dt_type  IN VARCHAR2,
   p_prem_tsi IN VARCHAR2,
   p_inc_endt IN VARCHAR2)
   RETURN NUMBER IS
   
   v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE := 0;
   v_peril_type      GIIS_PERIL.peril_type%TYPE;
   v_amt          GIPI_ITMPERIL.tsi_amt%TYPE;
   v_tsi2             GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE := 0;
   v_max_peril        GIPI_ITMPERIL.peril_cd%TYPE := 0;
   v_peril_cd         GIPI_ITMPERIL.peril_cd%TYPE := 0;

 
   BEGIN
 
   FOR X IN (SELECT SUM(DECODE(p_prem_tsi,'T',b.dist_tsi,'P',b.dist_prem)) dist_amt
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
                AND DECODE(p_inc_endt,'Y',1,P_Zone_Fromto.date_ok(C.acct_ent_date, C.eff_date, C.issue_date, C.booking_mth, C.booking_year,
                                  C.spld_acct_ent_date,C.pol_flag, p_dt_type, p_from, p_to)) = 1
                AND C.policy_id = A.policy_id)
                AND A.dist_no = b.dist_no
                AND b.peril_cd = p_peril_cd
                AND b.item_no = p_item_no
                AND b.dist_no = p_dist_no
                AND b.share_cd = p_share_cd)
   LOOP
     v_amt := X.dist_amt;
   END LOOP;                 
   RETURN(NVL(v_amt,0));
 
 /*
 CURSOR stat IS
    SELECT g.peril_type, C.peril_cd, C.tsi_amt tsi_peril
      FROM GIPI_FIREITEM         d,
              GIPI_ITMPERIL         C,
              GIIS_PERIL   g,
     GIPI_POLBASIC         A
        WHERE 1=1
          AND g.peril_cd    = C.peril_cd
          AND g.line_cd     = NVL(A.line_cd,A.line_cd)
          AND g.peril_cd    = C.peril_cd
    AND C.policy_id   = A.policy_id
          AND g.peril_cd    = C.peril_cd
          AND g.line_cd     = NVL(A.line_cd,A.line_cd)
          AND g.peril_cd    = C.peril_cd
    AND C.policy_id   = A.policy_id
    AND C.item_no     = d.item_no
    AND C.line_cd     = A.line_cd
    AND C.peril_cd    = g.peril_cd
          AND A.policy_id   = d.policy_id
       --AND A.DIST_FLAG = '3'
       AND A.dist_flag = DECODE(A.pol_flag,'5','4','3')--IF POL_FLAG IS 5, DIST_FLAG SHLD BE 4, ELSE DIST_FLAG SHLD BE 3
          AND A.policy_id   = C.policy_id
          AND d.item_no     = C.item_no
          AND NVL(A.line_cd,A.line_cd)     = C.line_cd
          --AND NVL(A.LINE_CD,A.LINE_CD)     = P_LINE_CD --TAGGED BY BDARUSIN, 11222002 FOR OPTIMIZATION PURPOSES
    AND A.line_cd     = p_line_cd                  --ADDED BY BDARUSIN, 11222002
    AND A.subline_cd  = p_subline_cd
          AND A.iss_cd      = p_iss_cd
          AND A.issue_yy    = p_issue_yy
          AND A.pol_seq_no  = p_pol_seq_no
          AND A.renew_no    = p_renew_no
          AND d.item_no     = p_item_no
      --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
   --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
          AND date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
                   A.spld_acct_ent_date, A.pol_flag, p_dt_type, p_from, p_to) =  1
          AND INSTR(DECODE(p_type,'3','3567','1','1','2','2','4','4','5','12','XX'),g.zone_type) > 0
  ORDER BY C.peril_cd;

  BEGIN

 FOR b IN stat LOOP
  IF b.tsi_peril > v_max_tsi OR
     v_max_tsi IS NULL THEN
     v_max_tsi := b.tsi_peril;
  END IF;
 END LOOP;

    FOR C IN stat LOOP
     IF C.tsi_peril     = v_max_tsi THEN
     IF C.peril_cd   > v_max_peril THEN
        v_max_peril := C.peril_cd;
        v_tsi2      := C.tsi_peril;
     END IF;
  EXIT;
  END IF;
 END LOOP;

    FOR d IN stat LOOP
     IF d.peril_cd  = v_max_peril AND
     d.tsi_peril = v_tsi2 THEN
        v_peril_cd := d.peril_cd;
  END IF;
 END LOOP;

    FOR e IN ( SELECT fa.dist_tsi
               FROM GIUW_ITEMPERILDS_DTL  fa
                 WHERE fa.dist_no     = p_dist_no
                AND fa.dist_seq_no >= 0
                AND fa.peril_cd    = p_peril_cd
                AND fa.share_cd    = p_share_cd
                AND fa.item_no   = p_item_no
                AND fa.peril_cd    = v_peril_cd
              ) LOOP
          v_tsi := e.dist_tsi;
 END LOOP;
 RETURN(NVL(v_tsi,0));

*/
END;
  FUNCTION get_tarf_cd
  /*
  ** THIS FUNCTION RETURNS THE tarf_cd OF THE LATEST ENDT_SEQ_NO.
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
     p_type         VARCHAR2,
     p_inc_endt     VARCHAR2)
  RETURN VARCHAR2 IS
    v_tarf_cd     GIPI_FIREITEM.tarf_cd%TYPE;
  BEGIN
    --dbms_output.put_line(p_line_cd||'-'||p_subline_Cd||'-'||p_iss_cd||'-'||p_issue_yy||'-'||p_pol_seq_no||'-'||p_renew_no);
 FOR cur1 IN (
      SELECT NVL(z.tarf_cd,y.tarf_cd) tarf_cd
        FROM GIPI_POLBASIC X,
             GIPI_FIREITEM y,
             GIPI_ITMPERIL z,
             GIIS_PERIL    g
       WHERE 1=1
         AND DECODE(p_inc_endt,'Y', 1, date_ok(X.acct_ent_date, X.eff_date, X.issue_date, X.booking_mth, X.booking_year,
                     X.spld_acct_ent_date, X.pol_flag, p_dt_type, p_from, p_to)) =  1
        /* AND NOT EXISTS(SELECT 'X'
                          FROM GIPI_POLBASIC m,
                               GIPI_FIREITEM  n,
                  GIPI_ITMPERIL o,
                  GIIS_PERIL    g1
                         WHERE m.line_cd = p_line_cd
                           AND m.subline_cd = p_subline_cd
                           AND m.iss_cd     = p_iss_cd
                           AND m.issue_yy   = p_issue_yy
                           AND m.pol_seq_no = p_pol_seq_no
                           AND m.renew_no   = p_renew_no
                           AND DECODE(p_inc_endt,'Y',1,date_ok(m.acct_ent_date, m.eff_date, m.issue_date, m.booking_mth, m.booking_year,
                                       m.spld_acct_ent_date, m.pol_flag, p_dt_type, p_from, p_to)) =  1
                           AND m.endt_seq_no > X.endt_seq_no
                           AND NVL(m.back_stat,5) = 2
                           AND m.policy_id  = n.policy_id
                AND m.policy_id  = o.policy_id
                           AND n.item_no    = p_item_no
                AND o.item_no    = p_item_no
                AND o.peril_cd   = g1.peril_cd
    AND g1.line_cd = giisp.v('LINE_CODE_FI')
                AND INSTR(DECODE(p_type,'3','3567','1','1','2','2','4','4','5','12','XX'),g1.zone_type) > 0
                ) */
     AND NVL(x.back_stat,5) != 2
        AND X.policy_id  = y.policy_id
        AND X.policy_id  = z.policy_id
        AND y.item_no    = p_item_no
    AND z.item_no    = p_item_no
    AND z.peril_cd   = g.peril_cd
        AND INSTR(DECODE(p_type,'3','3567','1','1','2','2','4','4','5','12','XX'),g.zone_type) > 0
      AND g.line_cd = giisp.v('LINE_CODE_FI')
   AND X.line_cd    = p_line_cd
         AND X.subline_cd = p_subline_cd
         AND X.iss_cd     = p_iss_cd
         AND X.issue_yy   = p_issue_yy
         AND X.pol_seq_no = p_pol_seq_no
         AND X.renew_no   = p_renew_no
   ORDER BY X.eff_date DESC)
    LOOP
      v_tarf_cd := cur1.tarf_cd;
      EXIT;
    END LOOP;
    RETURN v_tarf_cd;
  END;

END;
/


