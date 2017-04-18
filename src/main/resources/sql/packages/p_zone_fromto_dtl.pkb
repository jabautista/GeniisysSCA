CREATE OR REPLACE PACKAGE BODY CPI.P_Zone_Fromto_Dtl AS
-- editted
  /* rollie june092004
  ** to show the details of firestat
  ** based on package P_ZONE_FROMTO
  */

  /* Modified by :  Aaron
  ** Modified on :  October 23, 2008 
  ** Remarks     :  Modified to correct the amounts extracted.
  **                Added the following parameters: 
  **           i.  p_inc_endt   --> parameter to determine whether to include endorsements
  **                    beyond the given date of extraction
  **          ii.  p_inc_exp    --> parameter to determine whether to include expired policies or not
  **         iii.  p_peril_type --> parameter to determine the type of peril to be included;
  **                A (allied only) B (basic only ) AB (both)            
  **          iv.   p_risk_cnt  ---> parameter to determine whether count will be per risk ('R') or per policy ('P')          
  */
  

PROCEDURE EXTRACT(
  p_from       IN DATE,
  p_to         IN DATE,
  p_dt_type    IN VARCHAR2,
  p_bus_cd     IN NUMBER,
  P_Zone       IN VARCHAR2,
  p_type       IN VARCHAR2,
  p_inc_endt   IN VARCHAR2,
  p_inc_exp    IN VARCHAR2,
  p_peril_type IN VARCHAR2,
  p_user       IN VARCHAR2) --edgar 03/09/2015
AS
  TYPE fd_zone_tab     IS TABLE OF GIPI_FIREITEM.flood_zone%TYPE;
  TYPE share_cd_tab    IS TABLE OF GIUW_ITEMPERILDS_DTL.share_cd%TYPE;
  TYPE tsi_tab         IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE;
  TYPE prem_tab        IS TABLE OF GIUW_ITEMPERILDS_DTL.dist_prem%TYPE;
  TYPE policy_tab      IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
  TYPE item_no_tab     IS TABLE OF GIPI_FIREITEM.item_no%TYPE;
  TYPE assd_no_tab     IS TABLE OF GIIS_ASSURED.assd_no%TYPE;
  TYPE fi_grp_type_tab IS TABLE OF GIIS_FI_ITEM_TYPE.fi_item_grp%TYPE;
  TYPE occupancy_tab IS TABLE OF GIIS_FIRE_OCCUPANCY.occupancy_cd%TYPE;
  vv_policy_id         policy_tab;
  vv_item_no           item_no_tab;
  vv_assd_no           assd_no_tab;
  vv_fd_zone           fd_zone_tab;
  vv_share_cd          share_cd_tab;
  vv_occupancy     occupancy_tab;
  vv_tsi               tsi_tab;
  vv_prem              prem_tab;
  vv_fd_zone2          fd_zone_tab;   -- USED FOR RECORDS NOT EXTRACTED; 2ND SELECT
  vv_share_cd2         share_cd_tab;  -- USED FOR RECORDS NOT EXTRACTED; 2ND SELECT
  vv_fi_grp_type       fi_grp_type_tab; --jenny vi lim 05062005
  v_ri_cd              GIPI_POLBASIC.iss_cd%TYPE;
   
BEGIN
  DELETE
    FROM GIPI_FIRESTAT_EXTRACT_DTL
   WHERE as_of_sw = 'N'
     AND user_id = /*USER*/p_user; --edgar 03/09/2015

  COMMIT;
  v_ri_cd := Giisp.v('ISS_CD_RI');
    /* START EXTRACTING RECORDS HERE AND INSERT IN GIPI_FIRESTAT_EXTRACT_dtl */
    /* Modified by:  Aaron
    Remarks:  The codes below were modified to extract policies only (exclude endorsements) 
              that are within the date parameters. The computation of TSI and premium were also corrected.*/
 
  SELECT A.policy_id policy_id,
         d.item_no item_no,
         h.assd_no assd_no,
         DECODE(p_type,'1', d.flood_zone, '2', d.typhoon_zone, '3', d.eq_zone,'5',NVL(d.typhoon_zone,d.flood_zone)) zone_type,
   --get_zone(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.endt_iss_cd, A.endt_yy, A.endt_seq_no, A.renew_no, d.item_no, p_dt_type,p_from,p_to,p_inc_endt, p_type) zone_type,
         f.share_cd share_cd,
   SUM(NVL(get_prem_tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
         A.pol_seq_no, A.renew_no,d.item_no, C.peril_cd,f.share_cd,f.dist_no,
         p_from, p_to, p_dt_type,p_inc_endt,'P'),0)* b.currency_rt) prem_amount,
         SUM(NVL(get_prem_tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
         A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,
         p_from, p_to, p_dt_type,p_inc_endt,'T'),0)* b.currency_rt) tsi_amount,
         NVL(i.fi_item_grp,'B'), -- jenny vi lim 05062005
         d.occupancy_cd
  -- SUM(F.DIST_TSI  * B.CURRENCY_RT) TSI_AMOUNT
    BULK COLLECT INTO
         vv_policy_id,
         vv_item_no,
         vv_assd_no,
         vv_fd_zone,
         vv_share_cd,
         vv_prem,
         vv_tsi,
         vv_fi_grp_type, --jenny vi lim 05062005
         vv_occupancy
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
             AND line_cd = 'FI') g,
         GIIS_FI_ITEM_TYPE i
   WHERE A.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
     AND A.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, A.iss_cd)
       --> modified by bdarusin 11222002 to include spoiled policies
       --  if policy is spoiled, check the spld_acct_ent_date
     AND date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
                   A.spld_acct_ent_date, A.pol_flag, p_dt_type, p_from, p_to) =  1
     AND A.policy_id = b.policy_id  --  POLBASIC   = GIPI_ITEM
     AND C.item_no   = b.item_no    --  ITEMPERILDS_DTL = GIPI_ITEM
     AND e.dist_no   = f.dist_no    --  POL_DIST   = ITEMPERILDS_DTL
     AND C.item_no   = f.item_no    --  POL_DIST   = ITEMPERILDS_DTL
     AND C.peril_cd  = f.peril_cd   --  POL_DIST   = ITEMPERILDS_DTL
     AND f.dist_seq_no >= 0       --  POL_DIST   = ITEMPERILDS_DTL
       --AND e.dist_flag = '3'       --  POL_DIST
     AND e.dist_flag = DECODE(A.pol_flag,'5','4','3')--if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
     AND A.par_id    = e.par_id     --  POLBASIC   = POL_DIST
     AND A.policy_id = d.policy_id  --  POLBASIC   = FIREITEM
     AND C.item_no   = d.item_no    --  ITEMPERIL  = FIREITEM
     AND C.policy_id = A.policy_id  --  ITEMPERIL  = POLBASIC
     AND g.line_cd   = C.line_cd    --  GIIS_PERIL = ITEM_PERIL
     AND g.peril_cd  = C.peril_cd   --  GIIS_PERIL = ITEM_PERIL
     AND A.line_cd   = g.line_cd
     AND h.par_id    = A.par_id
     AND g.peril_type = DECODE(p_peril_type,'A','A','B','B','AB',g.peril_type)
     AND DECODE (P_Zone, 'ALL', NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,
                  '2',d.typhoon_zone,'5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1'),
           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
          '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-2'))
           IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
           '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1')
     AND d.fr_item_type = i.fr_item_type(+)  -- aaron 041108 added outer join to correct summary and details amounts
     AND A.endt_seq_no = 0 -- aaron
     AND (p_inc_exp = 'N' AND A.pol_flag IN ('1','2','3') 
          OR p_inc_exp = 'Y' AND A.pol_flag IN ('1','2','3','X'))
    --AND (pol_flag IN ('1','2','3','5') AND 'N' = p_inc_exp 
    -- OR pol_flag IN ('1','2','3','5','X') AND 'Y'= p_inc_exp)
   GROUP BY A.policy_id,
            d.item_no,h.assd_no,
            DECODE(p_type,'1', d.flood_zone, '2', d.typhoon_zone, '3', d.eq_zone,'5',NVL(d.typhoon_zone,d.flood_zone)),
   --get_zone(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.endt_iss_cd, A.endt_yy, A.endt_seq_no, A.renew_no, d.item_no, p_dt_type,p_from,p_to,p_inc_endt, p_type),
            f.share_cd, 
            i.fi_item_grp,
   d.occupancy_cd;
  
  IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_fd_zone.FIRST..vv_fd_zone.LAST
      -- modified by jenny vi lim 05062005 added fi_item_grp
         INSERT INTO GIPI_FIRESTAT_EXTRACT_DTL
           (policy_id,                  item_no,                    assd_no,
            extract_dt,                 zone_type,                  zone_no,
            share_cd,                   share_tsi_amt,              share_prem_amt,
            tariff_cd,                  as_of_sw,                   date_from,
            date_to,                    user_id,                    fi_item_grp,
   occupancy_cd)
         VALUES
           (vv_policy_id(cnt),          vv_item_no(cnt),            vv_assd_no(cnt),
            SYSDATE,                    DECODE(p_type,'1',1,'2',2,'3',3,'5',5,'4',4),                          vv_fd_zone(cnt),
            vv_share_cd(cnt),           NVL(vv_tsi(cnt),0),         NVL(vv_prem(cnt),0),
            '7',                        'N',                        p_from,
            p_to,                       /*USER*/p_user,/*edgar 03/09/2015*/                       NVL(vv_fi_grp_type(cnt),NULL),
   vv_occupancy(cnt));
    END IF;
    COMMIT;
  
    /* This part will extract the endorsements of the policies selected above. The parameter
    ** p_inc_endt will determine whether endorsements beyond the given period will be included.
    ** Aron 
 */
    
FOR X IN (SELECT b.policy_id, A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no
            FROM GIPI_POLBASIC A, GIPI_FIRESTAT_EXTRACT_DTL b
           WHERE 1=1
             AND A.policy_id = b.policy_id
             AND b.as_of_sw = 'N'
             AND b.user_id = /*USER*/p_user --edgar 03/09/2015
           GROUP BY b.policy_id, A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no)
LOOP
  SELECT A.policy_id policy_id,
         d.item_no item_no,
         h.assd_no assd_no,
         --DECODE(p_type,'1', d.flood_zone, '2', d.typhoon_zone, '3', d.eq_zone,'5',NVL(d.typhoon_zone,d.flood_zone)) zone_type,
   get_zone(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.endt_iss_cd, A.endt_yy, A.endt_seq_no, A.renew_no, d.item_no, p_dt_type,p_from,p_to,p_inc_endt, p_type) zone_type,
         f.share_cd share_cd,
             --SUM(f.dist_prem * b.currency_rt) prem_amount, --comment out by aaron
         SUM(NVL(get_prem_tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
             A.pol_seq_no, A.renew_no,d.item_no, C.peril_cd,f.share_cd,f.dist_no,
             p_from, p_to, p_dt_type,p_inc_endt,'P'),0)* b.currency_rt) prem_amount,
         SUM(NVL(get_prem_tsi(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
             A.pol_seq_no, A.renew_no,d.item_no,C.peril_cd,f.share_cd,f.dist_no,
             p_from, p_to, p_dt_type,p_inc_endt,'T'),0)* b.currency_rt) tsi_amount,
         NVL(i.fi_item_grp,get_fi_item_grp(X.line_cd, X.subline_cd,X.iss_cd,X.issue_yy,X.pol_seq_no,X.renew_no,d.item_no)), -- jenny vi lim 05062005
         get_occupancy(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.endt_iss_cd, A.endt_yy, A.endt_seq_no, A.renew_no, d.item_no, p_dt_type,p_from,p_to,p_inc_endt, p_type) occupancy 
    -- SUM(F.DIST_TSI  * B.CURRENCY_RT) TSI_AMOUNT
    BULK COLLECT INTO
           vv_policy_id,
           vv_item_no,
           vv_assd_no,
           vv_fd_zone,
           vv_share_cd,
           vv_prem,
           vv_tsi,
           vv_fi_grp_type,
     vv_occupancy --jenny vi lim 05062005
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
      AND line_cd = 'FI') g,
     --(SELECT line_cd, peril_cd, peril_type
           --   FROM GIIS_PERIL
           --  WHERE zone_type = '1') g,
           GIIS_FI_ITEM_TYPE i
     WHERE A.iss_cd <> DECODE(p_bus_cd, 1, v_ri_cd,'XX')
       AND A.iss_cd  = DECODE(p_bus_cd, 2, v_ri_cd, A.iss_cd)
       --> modified by bdarusin 11222002 to include spoiled policies
       --  if policy is spoiled, check the spld_acct_ent_date
       --AND date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
       --            A.spld_acct_ent_date, A.pol_flag, p_dt_type, p_from, p_to) =  1
       AND DECODE(p_inc_endt,'Y',1,date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
                                  A.spld_acct_ent_date,A.pol_flag, p_dt_type, p_from, p_to)) = 1 
       AND A.policy_id = b.policy_id  --  POLBASIC   = GIPI_ITEM
       AND C.item_no   = b.item_no    --  ITEMPERILDS_DTL = GIPI_ITEM
       AND e.dist_no   = f.dist_no    --  POL_DIST   = ITEMPERILDS_DTL
       AND C.item_no   = f.item_no    --  POL_DIST   = ITEMPERILDS_DTL
       AND C.peril_cd  = f.peril_cd   --  POL_DIST   = ITEMPERILDS_DTL
       AND f.dist_seq_no >= 0       --  POL_DIST   = ITEMPERILDS_DTL
       --AND e.dist_flag = '3'       --  POL_DIST
       AND e.dist_flag = DECODE(A.pol_flag,'5','4','3')--if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
       AND A.par_id    = e.par_id     --  POLBASIC   = POL_DIST
       AND A.policy_id = d.policy_id  --  POLBASIC   = FIREITEM
       AND C.item_no   = d.item_no    --  ITEMPERIL  = FIREITEM
       AND C.policy_id = A.policy_id  --  ITEMPERIL  = POLBASIC
       AND g.line_cd   = C.line_cd    --  GIIS_PERIL = ITEM_PERIL
       AND g.peril_cd  = C.peril_cd   --  GIIS_PERIL = ITEM_PERIL
       AND A.line_cd   = g.line_cd
       AND h.par_id    = A.par_id
       AND g.peril_type = DECODE(p_peril_type,'A','A','B','B','AB',g.peril_type)
    AND DECODE (P_Zone, 'ALL', NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,
                  '2',d.typhoon_zone,'5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1'),
           NVL(DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
          '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-2'))
           IN (DECODE(p_type,'3',d.eq_zone,'1',d.flood_zone,'2',d.typhoon_zone,
           '5',NVL(d.typhoon_zone,d.flood_zone),'X'),'-1')
       AND d.fr_item_type = i.fr_item_type(+)  -- aaron 041108 added outer join to correct summary and details amounts
       AND (p_inc_exp = 'N' AND A.pol_flag IN ('1','2','3') 
            OR p_inc_exp = 'Y' AND A.pol_flag IN ('1','2','3','X'))
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
      --DECODE(p_type,'1', d.flood_zone, '2', d.typhoon_zone, '3', d.eq_zone,'5',NVL(d.typhoon_zone,d.flood_zone)),
   get_zone(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.endt_iss_cd, A.endt_yy, A.endt_seq_no, A.renew_no, d.item_no, p_dt_type,p_from,p_to,p_inc_endt, p_type),
      f.share_cd, i.fi_item_grp,
   get_occupancy(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.endt_iss_cd, A.endt_yy, A.endt_seq_no, A.renew_no, d.item_no, p_dt_type,p_from,p_to,p_inc_endt, p_type);
     
  
  IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_fd_zone.FIRST..vv_fd_zone.LAST
      
         INSERT INTO GIPI_FIRESTAT_EXTRACT_DTL
           (policy_id,                item_no,           assd_no,
            extract_dt,               zone_type,         zone_no,
            share_cd,             share_tsi_amt,     share_prem_amt,
            tariff_cd,            as_of_sw,          date_from,
            date_to,                  user_id,           fi_item_grp,
   occupancy_cd)
         VALUES
           (vv_policy_id(cnt),        vv_item_no(cnt),            vv_assd_no(cnt),
            SYSDATE,                  DECODE(p_type,'1',1,'2',2,'3',3,'5',5),                          vv_fd_zone(cnt),
            vv_share_cd(cnt),         NVL(vv_tsi(cnt),0),         NVL(vv_prem(cnt),0),
            '7',                      'N',                        p_from,
            p_to,                     /*USER*/p_user/*edgar 03/09/2015*/,                       vv_fi_grp_type(cnt),
   vv_occupancy(cnt));
    END IF;
    COMMIT; 
 END LOOP;
  
  END;
    /*  THIS FUNCTION CHECKS IF THE ACCT_ENT_DATE, EFF_DATE, ISSUE_DATE OR BOOKING DATE
      OF THE POLICY IS WITHIN THE GIVEN DATE RANGE
   revised by bdarusin, 11222002,
   if extract is by acct_ent_date, include spoiled policies but
   check the spld_acct_ent_date*/
  FUNCTION date_ok (
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
    IF p_dt_type = 'AD' AND TRUNC(p_ad) >= p_fmdate
    AND TRUNC(p_ad) <= p_todate THEN
    RETURN (1);
       ELSIF p_dt_type = 'ED' AND (TRUNC(p_ed)) >= p_fmdate AND (TRUNC(p_ed)) <= p_todate THEN
          RETURN (1);
       ELSIF p_dt_type = 'ID' AND (TRUNC(p_id)) >= p_fmdate AND (TRUNC(p_id)) <= p_todate THEN
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
    RETURN (0);
  END IF;
  END;
    
  FUNCTION get_zone
  /* CREATED BY BOYET 10/23/2001
  ** THIS FUNCTION RETURNS THE EQ_ZONE OF THE LATEST ENDT_SEQ_NO. THIS FUNCTION IS ONLY USED
  ** FOR THE PACKAGE THE PROCESSES ZONE NOT NULL.
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
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
     p_inc_endt     VARCHAR2,
     p_type          VARCHAR2)
--  RETURN NUMBER IS
  RETURN VARCHAR2 AS--vj 031907
    v_fi_zone     GIPI_FIREITEM.eq_zone%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT --DECODE(p_type,'1', y.flood_zone) ZONE_type
   DECODE(p_type,'1', y.flood_zone, '2', y.typhoon_zone, '3', y.eq_zone,'5',NVL(y.typhoon_zone,y.flood_zone)) zone_type
        FROM GIPI_POLBASIC X,
             GIPI_FIREITEM y
       WHERE 1=1
      --> modified by bdarusin 11222002 to include spoiled policies
   --  if policy is spoiled, check the spld_acct_ent_date
          AND DECODE(p_inc_endt, 'Y', 1, date_ok(X.acct_ent_date, X.eff_date, X.issue_date, X.booking_mth, X.booking_year,
                     X.spld_acct_ent_date, X.pol_flag, p_dt_type, p_from, p_to)) =  1
         --AND NOT EXISTS(SELECT 'X'
          --                FROM GIPI_POLBASIC m,
          --                     GIPI_FIREITEM  n
           --              WHERE m.line_cd = p_line_cd
            --               AND m.subline_cd = p_subline_cd
            --               AND m.iss_cd     = p_iss_cd
            --               AND m.issue_yy   = p_issue_yy
            --               AND m.pol_seq_no = p_pol_seq_no
          --AND m.endt_iss_cd = p_endt_iss_cd
          --AND m.endt_yy     = p_endt_yy
          --AND m.endt_seq_no = p_endt_seq_no
            --               AND m.renew_no   = p_renew_no
           --> modified by bdarusin 11222002 to include spoiled policies
        --  if policy is spoiled, check the spld_acct_ent_date
           --                AND DECODE(p_inc_endt, 'Y', 1, date_ok(X.acct_ent_date, X.eff_date, X.issue_date, X.booking_mth, X.booking_year,
           --          X.spld_acct_ent_date, X.pol_flag, p_dt_type, p_from, p_to)) =  1
           --                AND m.endt_seq_no > X.endt_seq_no
           --                AND NVL(m.back_stat,5) = 2
           --                AND m.policy_id  = n.policy_id
           --                AND n.item_no    = p_item_no
            --               /*AND n.eq_zone IS NOT NULL*/)
        AND NVL(x.back_stat,5) != 2
  AND X.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
  AND X.line_cd    = p_line_cd
         AND X.subline_cd = p_subline_cd
         AND X.iss_cd     = p_iss_cd
         AND X.issue_yy   = p_issue_yy
         AND X.pol_seq_no = p_pol_seq_no
   --AND X.endt_iss_cd = p_endt_iss_cd
   --AND X.endt_yy     = p_endt_yy
   --AND X.endt_seq_no = p_endt_seq_no
         AND X.renew_no   = p_renew_no
        --AND y.eq_zone IS NOT NULL
        ORDER BY X.eff_date DESC)
    LOOP
      v_fi_zone := cur1.zone_type;
      IF v_fi_zone is not null then
   EXIT;
   end if;
    END LOOP;
    RETURN v_fi_zone;
  END;

FUNCTION get_occupancy
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
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
     p_inc_endt     VARCHAR2,
     p_type          VARCHAR2)
  RETURN VARCHAR2 AS--vj 031907
    v_occupancy     GIPI_FIREITEM.occupancy_cd%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT y.occupancy_cd
     FROM GIPI_POLBASIC X,
             GIPI_FIREITEM y
       WHERE 1=1
          AND DECODE(p_inc_endt, 'Y', 1, date_ok(X.acct_ent_date, X.eff_date, X.issue_date, X.booking_mth, X.booking_year,
                     X.spld_acct_ent_date, X.pol_flag, p_dt_type, p_from, p_to)) =  1
        AND NVL(x.back_stat,5) != 2
  AND X.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
  AND X.line_cd    = p_line_cd
         AND X.subline_cd = p_subline_cd
         AND X.iss_cd     = p_iss_cd
         AND X.issue_yy   = p_issue_yy
         AND X.pol_seq_no = p_pol_seq_no
         AND X.renew_no   = p_renew_no
        ORDER BY X.eff_date DESC)
    LOOP
      v_occupancy := cur1.occupancy_cd;
      IF v_occupancy is not null then
   EXIT;
   end if;
    END LOOP;
    RETURN v_occupancy;
  END;
  
FUNCTION get_prem_tsi (
  /* Created by: Aaron 
  ** Created on: 09/10/2008
  ** Remarks: to replace old function get_fd_tsi (refer to get_fd_tsi_old)
  ** 
  */
   p_line_cd     IN VARCHAR2,
   p_subline_cd  IN VARCHAR2,
   p_iss_cd      IN VARCHAR2,
   p_issue_yy    IN NUMBER,
   p_pol_seq_no  IN NUMBER,
   p_renew_no    IN NUMBER,
   p_item_no     IN NUMBER,
   p_peril_cd    IN NUMBER,
   p_share_cd    IN NUMBER,
   p_dist_no     IN NUMBER,
   p_from        IN DATE,
   p_to          IN DATE,
   p_dt_type     IN VARCHAR2,
   p_inc_endt    IN VARCHAR2,
   p_prem_tsi    IN VARCHAR2)
  RETURN NUMBER IS
    v_amt    GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE := 0;
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
               --AND EXISTS (SELECT '1'
               --              FROM GIIS_PERIL
               --             WHERE line_cd = 'FI'
           -- AND peril_cd = b.peril_cd
           --                   AND zone_type = '1')
              AND b.share_cd = p_share_cd)
  LOOP
    v_amt := X.dist_amt;
  END LOOP;                 
  RETURN(NVL(v_amt,0));
  END;
   
--FUNCTION get_fd_tsi (
  /* CREATED BY BDARUSIN 01/15/2002
  ** THIS FUNCTION RETURNS THE DIST TSI AMOUNT OF THE POLICY.
  ** THIS FUNCTION IS ONLY USED FOR THE PROCEDURES INVOLVING FIRE STAT
  */
 /*  p_line_cd     IN VARCHAR2,
   p_subline_cd  IN VARCHAR2,
   p_iss_cd   IN VARCHAR2,
   p_issue_yy   IN NUMBER,
   p_pol_seq_no  IN NUMBER,
      p_renew_no  IN NUMBER,
      p_item_no   IN NUMBER,
   p_peril_cd IN NUMBER,
   p_share_cd IN NUMBER,
   p_dist_no     IN NUMBER,
      p_from        IN DATE,
      p_to          IN DATE,
   p_dt_type     IN VARCHAR2)
  RETURN NUMBER IS
 v_tsi       GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE := 0;
 v_peril_type      GIIS_PERIL.peril_type%TYPE;
 v_max_tsi          GIPI_ITMPERIL.tsi_amt%TYPE;
 v_tsi2             GIUW_ITEMPERILDS_DTL.dist_tsi%TYPE := 0;
 v_max_peril        GIPI_ITMPERIL.peril_cd%TYPE := 0;
 v_peril_cd         GIPI_ITMPERIL.peril_cd%TYPE := 0;

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
          AND g.zone_type   IN ('1')
    AND C.policy_id   = A.policy_id
          AND g.peril_cd    = C.peril_cd
          AND g.line_cd     = NVL(A.line_cd,A.line_cd)
          AND g.peril_cd    = C.peril_cd
          AND g.zone_type   IN ('1')
    AND C.policy_id   = A.policy_id
    AND C.item_no     = d.item_no
    AND C.line_cd     = A.line_cd
    AND C.peril_cd    = g.peril_cd
          AND A.policy_id   = d.policy_id
          --AND a.dist_flag   = '3'
          AND A.dist_flag = DECODE(A.pol_flag,'5','4','3')--if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
          AND A.policy_id   = C.policy_id
          AND d.item_no     = C.item_no
          AND NVL(A.line_cd,A.line_cd)     = C.line_cd
          --AND NVL(a.line_cd,a.line_cd)     = p_line_cd --tagged by bdarusin, 11222002 for optimization purposes
    AND A.line_cd     = p_line_cd                  --added by bdarusin, 11222002
          AND A.subline_cd  = p_subline_cd
          AND A.iss_cd      = p_iss_cd
          AND A.issue_yy    = p_issue_yy
          AND A.pol_seq_no  = p_pol_seq_no
          AND A.renew_no    = p_renew_no
          AND d.item_no     = p_item_no
       --> modified by bdarusin 11222002 to include spoiled policies
    --  if policy is spoiled, check the spld_acct_ent_date
          AND date_ok(A.acct_ent_date, A.eff_date, A.issue_date, A.booking_mth, A.booking_year,
                      A.spld_acct_ent_date,A.pol_flag, p_dt_type, p_from, p_to) =  1
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
END; */
   
 FUNCTION Get_FI_Item_Grp (
  p_line_cd IN VARCHAR2,
  p_subline_cd IN VARCHAR2,
  p_iss_cd IN VARCHAR2,
  p_issue_yy IN NUMBER,
  p_pol_seq_no IN NUMBER,
  p_renew_no  IN NUMBER,
  p_item_no    IN NUMBER)
 RETURN VARCHAR2 IS
  v_item_grp VARCHAR2(2);
 BEGIN
 
 
 FOR X IN (SELECT C.fi_item_grp
             FROM GIPI_POLBASIC A, GIIS_FI_ITEM_TYPE C, GIPI_FIREITEM b
            WHERE A.policy_id = b.policy_id
     AND C.fr_item_type = b.fr_item_type
              AND A.line_cd = p_line_cd
     AND A.subline_cd = p_subline_cd
     AND A.iss_cd = p_iss_cd
     AND A.issue_yy = p_issue_yy 
     AND A.pol_seq_no = p_pol_seq_no
     AND A.renew_no = p_renew_no
     AND b.item_no = p_item_no
     AND NOT EXISTS (SELECT 1
               FROM GIPI_POLBASIC d
          WHERE A.policy_id = d.policy_id
            AND NVL(d.back_stat,5) = 2)
   ORDER BY endt_seq_no DESC)
 LOOP
   v_item_grp := X.fi_item_grp;
   
   IF v_item_grp IS NOT NULL THEN
     EXIT;
   END IF;    
 END LOOP;
 
 RETURN(NVL(v_item_grp,'B'));
 
 END;   

   /* ----------------------------------------------------------------------------------------
   ** jhing 03.17.2015 revised extraction for fire statistical reports. Changes were done not
   ** only on the queries but on the database structure and on the process.
   ** ----------------------------------------------------------------------------------------*/
   FUNCTION get_redist_date (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_item_grp        gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no   gipi_invoice.takeup_seq_no%TYPE
   )
      RETURN DATE
   IS
      /** Created by : Jhing Factor
      **  Purpose    : Get the Redistribution Date of the Policy.
      */
      v_redist_date   DATE := NULL;
   BEGIN
      FOR cur IN (SELECT   dist_no, eff_date
                      FROM giuw_pol_dist x
                     WHERE x.policy_id = p_policy_id
                       AND NVL (x.item_grp, NVL (p_item_grp, 1)) =
                                                           NVL (p_item_grp, 1)
                       AND NVL (x.takeup_seq_no, NVL (p_takeup_seq_no, 1)) =
                                                      NVL (p_takeup_seq_no, 1)
                       AND EXISTS (
                              SELECT 1
                                FROM giuw_pol_dist t, giuw_distrel y
                               WHERE t.policy_id = p_policy_id
                                 AND t.dist_flag = '5'
                                 AND t.dist_no = y.dist_no_old
                                 AND x.dist_no = y.dist_no_new
                                 AND NVL (t.item_grp, NVL (p_item_grp, 1)) =
                                                           NVL (p_item_grp, 1)
                                 AND NVL (t.takeup_seq_no,
                                          NVL (p_takeup_seq_no, 1)
                                         ) = NVL (p_takeup_seq_no, 1))
                  ORDER BY dist_no ASC)
      LOOP
         v_redist_date := cur.eff_date;
         EXIT;
      END LOOP;

      RETURN v_redist_date;
   END get_redist_date;

   FUNCTION get_max_redist_dist_no (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_item_grp        gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no   gipi_invoice.takeup_seq_no%TYPE,
      p_dt_type         VARCHAR2,
      p_from            DATE,
      p_to              DATE
   )
      RETURN NUMBER
   IS
      v_max_redist_no   NUMBER := 0;
   BEGIN
      FOR cur IN (SELECT MAX (dist_no) dist_no
                    FROM giuw_pol_dist x
                   WHERE x.policy_id = p_policy_id
                     AND NVL (x.item_grp, NVL (p_item_grp, 1)) =
                                                           NVL (p_item_grp, 1)
                     AND NVL (x.takeup_seq_no, NVL (p_takeup_seq_no, 1)) =
                                                      NVL (p_takeup_seq_no, 1)
                     AND (   p_dt_type <> 'ED'
                          OR (    (x.dist_flag = '3')
                              AND TRUNC (x.eff_date) BETWEEN p_from AND p_to
                             )
                         )
                     AND (p_dt_type IN ('BD', 'ID') OR (x.dist_flag = '3'))
                     AND (   p_dt_type <> 'AD'
                          OR (   TRUNC (NVL (x.acct_ent_date, p_to + 60))
                                    BETWEEN p_from
                                        AND p_to
                              OR TRUNC (NVL (x.acct_neg_date, p_to + 60))
                                    BETWEEN p_from
                                        AND p_to
                             )
                         ))
      LOOP
         v_max_redist_no := cur.dist_no;
         EXIT;
      END LOOP;

      RETURN v_max_redist_no;
   END get_max_redist_dist_no;

   FUNCTION get_latest_eff_per_field (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_item_no           gipi_itmperil.item_no%TYPE,
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_date_type    IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2,
      p_field_name   IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_max_endt       gipi_polbasic.endt_seq_no%TYPE   := 0;
      v_latest_endt    gipi_polbasic.endt_seq_no%TYPE   := 0;
      v_max_backward   gipi_polbasic.endt_seq_no%TYPE   := 0;
      v_targetpol      gipi_polbasic.endt_seq_no%TYPE   := 0;
      v_policy_id      gipi_polbasic.policy_id%TYPE     := 0;

      CURSOR get_latestdtl
      IS
         SELECT   a.policy_id, a.endt_seq_no, a.eff_date
             FROM gipi_polbasic a, gipi_fireitem b
            WHERE a.policy_id = b.policy_id
              AND a.line_cd = p_line_cd
              AND a.subline_cd = p_subline_cd
              AND a.iss_cd = p_iss_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.renew_no = p_renew_no
              AND b.item_no = p_item_no
              AND (   (b.block_id IS NOT NULL AND p_field_name = 'BLOCK_ID')
                   OR (b.risk_cd IS NOT NULL AND p_field_name = 'RISK_CD')
                   OR (    b.fr_item_type IS NOT NULL
                       AND p_field_name = 'FR_ITEM_TYPE'
                      )
                   OR (    b.occupancy_cd IS NOT NULL
                       AND p_field_name = 'OCCUPANCY_CD'
                      )
                   OR (b.tarf_cd IS NOT NULL AND p_field_name = 'TARF_CD')
                   OR (b.eq_zone IS NOT NULL AND p_field_name = 'EQ_ZONE')
                   OR (    b.typhoon_zone IS NOT NULL
                       AND p_field_name = 'TYPHOON_ZONE'
                      )
                   OR (b.flood_zone IS NOT NULL
                       AND p_field_name = 'FLOOD_ZONE'
                      )
                  )
              AND (   NVL (p_inc_exp, 'N') = 'Y'
                   OR TRUNC (NVL (a.endt_expiry_date, expiry_date)) >=
                                                               TRUNC (SYSDATE)
                  )
              AND (   p_date_type <> 'BD'
                   OR (a.booking_mth IS NOT NULL
                       AND a.booking_year IS NOT NULL
                      )
                  )
              AND (p_date_type = 'AD' OR a.pol_flag <> '5')
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'ED'
                   OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                   OR TRUNC (a.eff_date) BETWEEN p_from AND p_to
                  )
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'ID'
                   OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                   OR TRUNC (a.issue_date) BETWEEN p_from AND p_to
                  )
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'BD'
                   OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                   OR (LAST_DAY (TO_DATE (   a.booking_mth
                                          || ','
                                          || TO_CHAR (a.booking_year),
                                          'FMMONTH,YYYY'
                                         )
                                ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                      )
                   OR EXISTS (
                         SELECT 1
                           FROM gipi_polbasic t, gipi_invoice v
                          WHERE t.policy_id = a.policy_id
                            AND t.policy_id = v.policy_id
                            AND (LAST_DAY
                                        (TO_DATE (   v.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (v.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from)
                                              AND LAST_DAY (p_to)
                                ))
                  )
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'AD'
                   OR (    a.endt_seq_no > 0
                       AND NVL (p_inc_endt, 'N') = 'Y'
                       AND (   a.acct_ent_date IS NOT NULL
                            OR a.spld_acct_ent_date IS NOT NULL
                           )
                      )
                   OR (    NVL (a.endt_type, 'A') = 'N'
                       AND LAST_DAY (TO_DATE (   a.booking_mth
                                              || ','
                                              || TO_CHAR (a.booking_year),
                                              'FMMONTH,YYYY'
                                             )
                                    ) BETWEEN LAST_DAY (p_from)
                                          AND LAST_DAY (p_to)
                       AND a.pol_flag <> '5'
                      )
                   OR (   TRUNC (NVL (a.acct_ent_date, p_to + 60))
                             BETWEEN p_from
                                 AND p_to
                       OR TRUNC (NVL (a.spld_acct_ent_date, p_to + 60))
                             BETWEEN p_from
                                 AND p_to
                      )
                   OR EXISTS (
                         SELECT 1
                           FROM gipi_polbasic t, gipi_invoice v
                          WHERE t.policy_id = a.policy_id
                            AND t.policy_id = v.policy_id
                            AND (   TRUNC (NVL (v.acct_ent_date, p_to + 60))
                                       BETWEEN p_from
                                           AND p_to
                                 OR TRUNC (NVL (v.spoiled_acct_ent_date,
                                                p_to + 60
                                               )
                                          ) BETWEEN p_from AND p_to
                                ))
                  )
         ORDER BY a.eff_date DESC, a.endt_seq_no DESC;

      CURSOR get_max_endt
      IS
         SELECT MAX (a.endt_seq_no) endt_seq_no
           FROM gipi_polbasic a, gipi_fireitem b
          WHERE a.policy_id = b.policy_id
            AND a.line_cd = p_line_cd
            AND a.subline_cd = p_subline_cd
            AND a.iss_cd = p_iss_cd
            AND a.issue_yy = p_issue_yy
            AND a.pol_seq_no = p_pol_seq_no
            AND a.renew_no = p_renew_no
            AND b.item_no = p_item_no
            AND (   (b.block_id IS NOT NULL AND p_field_name = 'BLOCK_ID')
                 OR (b.risk_cd IS NOT NULL AND p_field_name = 'RISK_CD')
                 OR (    b.fr_item_type IS NOT NULL
                     AND p_field_name = 'FR_ITEM_TYPE'
                    )
                 OR (    b.occupancy_cd IS NOT NULL
                     AND p_field_name = 'OCCUPANCY_CD'
                    )
                 OR (b.tarf_cd IS NOT NULL AND p_field_name = 'TARF_CD')
                 OR (b.eq_zone IS NOT NULL AND p_field_name = 'EQ_ZONE')
                 OR (    b.typhoon_zone IS NOT NULL
                     AND p_field_name = 'TYPHOON_ZONE'
                    )
                 OR (b.flood_zone IS NOT NULL AND p_field_name = 'FLOOD_ZONE'
                    )
                )
            AND (   NVL (p_inc_exp, 'N') = 'Y'
                 OR TRUNC (NVL (a.endt_expiry_date, expiry_date)) >=
                                                               TRUNC (SYSDATE)
                )
            AND (   p_date_type <> 'BD'
                 OR (a.booking_mth IS NOT NULL AND a.booking_year IS NOT NULL
                    )
                )
            AND (p_date_type = 'AD' OR a.pol_flag <> '5')
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ED'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.eff_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ID'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.issue_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'BD'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR (LAST_DAY (TO_DATE (   a.booking_mth
                                        || ','
                                        || TO_CHAR (a.booking_year),
                                        'FMMONTH,YYYY'
                                       )
                              ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (LAST_DAY (TO_DATE (   v.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (v.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from)
                                              AND LAST_DAY (p_to)
                              ))
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'AD'
                 OR (    a.endt_seq_no > 0
                     AND NVL (p_inc_endt, 'N') = 'Y'
                     AND (   a.acct_ent_date IS NOT NULL
                          OR a.spld_acct_ent_date IS NOT NULL
                         )
                    )
                 OR (    NVL (a.endt_type, 'A') = 'N'
                     AND LAST_DAY (TO_DATE (   a.booking_mth
                                            || ','
                                            || TO_CHAR (a.booking_year),
                                            'FMMONTH,YYYY'
                                           )
                                  ) BETWEEN LAST_DAY (p_from) AND LAST_DAY
                                                                         (p_to)
                     AND a.pol_flag <> '5'
                    )
                 OR (   TRUNC (NVL (a.acct_ent_date, p_to + 60)) BETWEEN p_from
                                                                     AND p_to
                     OR TRUNC (NVL (a.spld_acct_ent_date, p_to + 60))
                           BETWEEN p_from
                               AND p_to
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (   TRUNC (NVL (v.acct_ent_date, p_to + 60))
                                     BETWEEN p_from
                                         AND p_to
                               OR TRUNC (NVL (v.spoiled_acct_ent_date,
                                              p_to + 60
                                             )
                                        ) BETWEEN p_from AND p_to
                              ))
                );

      CURSOR get_max_backward
      IS
         SELECT MAX (a.endt_seq_no) endt_seq_no
           FROM gipi_polbasic a, gipi_fireitem b
          WHERE a.policy_id = b.policy_id
            AND a.line_cd = p_line_cd
            AND a.subline_cd = p_subline_cd
            AND a.iss_cd = p_iss_cd
            AND a.issue_yy = p_issue_yy
            AND a.pol_seq_no = p_pol_seq_no
            AND a.renew_no = p_renew_no
            AND b.item_no = p_item_no
            AND (   (b.block_id IS NOT NULL AND p_field_name = 'BLOCK_ID')
                 OR (b.risk_cd IS NOT NULL AND p_field_name = 'RISK_CD')
                 OR (    b.fr_item_type IS NOT NULL
                     AND p_field_name = 'FR_ITEM_TYPE'
                    )
                 OR (    b.occupancy_cd IS NOT NULL
                     AND p_field_name = 'OCCUPANCY_CD'
                    )
                 OR (b.tarf_cd IS NOT NULL AND p_field_name = 'TARF_CD')
                 OR (b.eq_zone IS NOT NULL AND p_field_name = 'EQ_ZONE')
                 OR (    b.typhoon_zone IS NOT NULL
                     AND p_field_name = 'TYPHOON_ZONE'
                    )
                 OR (b.flood_zone IS NOT NULL AND p_field_name = 'FLOOD_ZONE'
                    )
                )
            AND NVL (a.back_stat, 5) = 2
            AND (   NVL (p_inc_exp, 'N') = 'Y'
                 OR TRUNC (NVL (a.endt_expiry_date, expiry_date)) >=
                                                               TRUNC (SYSDATE)
                )
            AND (   p_date_type <> 'BD'
                 OR (a.booking_mth IS NOT NULL AND a.booking_year IS NOT NULL
                    )
                )
            AND (p_date_type = 'AD' OR a.pol_flag <> '5')
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ED'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.eff_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ID'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.issue_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'BD'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR (LAST_DAY (TO_DATE (   a.booking_mth
                                        || ','
                                        || TO_CHAR (a.booking_year),
                                        'FMMONTH,YYYY'
                                       )
                              ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (LAST_DAY (TO_DATE (   v.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (v.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from)
                                              AND LAST_DAY (p_to)
                              ))
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'AD'
                 OR (    a.endt_seq_no > 0
                     AND NVL (p_inc_endt, 'N') = 'Y'
                     AND (   a.acct_ent_date IS NOT NULL
                          OR a.spld_acct_ent_date IS NOT NULL
                         )
                    )
                 OR (    NVL (a.endt_type, 'A') = 'N'
                     AND LAST_DAY (TO_DATE (   a.booking_mth
                                            || ','
                                            || TO_CHAR (a.booking_year),
                                            'FMMONTH,YYYY'
                                           )
                                  ) BETWEEN LAST_DAY (p_from) AND LAST_DAY
                                                                         (p_to)
                     AND a.pol_flag <> '5'
                    )
                 OR (   TRUNC (NVL (a.acct_ent_date, p_to + 60)) BETWEEN p_from
                                                                     AND p_to
                     OR TRUNC (NVL (a.spld_acct_ent_date, p_to + 60))
                           BETWEEN p_from
                               AND p_to
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (   TRUNC (NVL (v.acct_ent_date, p_to + 60))
                                     BETWEEN p_from
                                         AND p_to
                               OR TRUNC (NVL (v.spoiled_acct_ent_date,
                                              p_to + 60
                                             )
                                        ) BETWEEN p_from AND p_to
                              ))
                );
   BEGIN
      FOR a1 IN get_max_endt
      LOOP
         v_max_endt := a1.endt_seq_no;
         EXIT;
      END LOOP;

      FOR a2 IN get_max_backward
      LOOP
         v_max_backward := a2.endt_seq_no;
         EXIT;
      END LOOP;

      IF v_max_endt = v_max_backward
      THEN
         v_targetpol := v_max_backward;
      ELSE
         FOR a3 IN get_latestdtl
         LOOP
            v_targetpol := a3.endt_seq_no;
            EXIT;
         END LOOP;
      END IF;

      BEGIN
         SELECT policy_id
           INTO v_policy_id
           FROM gipi_polbasic
          WHERE line_cd = p_line_cd
            AND subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND issue_yy = p_issue_yy
            AND pol_seq_no = p_pol_seq_no
            AND renew_no = p_renew_no
            AND endt_seq_no = v_targetpol;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_policy_id := 0;
      END;

      RETURN v_policy_id;
   END get_latest_eff_per_field;

   FUNCTION get_latest_eff_polendt (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_date_type    IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_max_endt       gipi_polbasic.policy_id%TYPE   := 0;
      v_latest_endt    gipi_polbasic.policy_id%TYPE   := 0;
      v_max_backward   gipi_polbasic.policy_id%TYPE   := 0;
      v_targetpol      gipi_polbasic.policy_id%TYPE   := 0;
      v_target_polid   gipi_polbasic.policy_id%TYPE   := NULL;

      CURSOR get_latestdtl
      IS
         SELECT   a.policy_id, a.endt_seq_no, a.eff_date
             FROM gipi_polbasic a
            WHERE 1 = 1
              AND a.line_cd = p_line_cd
              AND a.subline_cd = p_subline_cd
              AND a.iss_cd = p_iss_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.renew_no = p_renew_no
              AND (   NVL (p_inc_exp, 'N') = 'Y'
                   OR TRUNC (NVL (a.endt_expiry_date, expiry_date)) >=
                                                               TRUNC (SYSDATE)
                  )
              AND (   p_date_type <> 'BD'
                   OR (a.booking_mth IS NOT NULL
                       AND a.booking_year IS NOT NULL
                      )
                  )
              AND (p_date_type = 'AD' OR a.pol_flag <> '5')
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'ED'
                   OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                   OR TRUNC (a.eff_date) BETWEEN p_from AND p_to
                  )
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'ID'
                   OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                   OR TRUNC (a.issue_date) BETWEEN p_from AND p_to
                  )
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'BD'
                   OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                   OR (LAST_DAY (TO_DATE (   a.booking_mth
                                          || ','
                                          || TO_CHAR (a.booking_year),
                                          'FMMONTH,YYYY'
                                         )
                                ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                      )
                   OR EXISTS (
                         SELECT 1
                           FROM gipi_polbasic t, gipi_invoice v
                          WHERE t.policy_id = a.policy_id
                            AND t.policy_id = v.policy_id
                            AND (LAST_DAY
                                        (TO_DATE (   v.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (v.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from)
                                              AND LAST_DAY (p_to)
                                ))
                  )
              AND (   a.endt_seq_no = 0
                   OR p_date_type <> 'AD'
                   OR (    a.endt_seq_no > 0
                       AND NVL (p_inc_endt, 'N') = 'Y'
                       AND (   a.acct_ent_date IS NOT NULL
                            OR a.spld_acct_ent_date IS NOT NULL
                           )
                      )
                   OR (    NVL (a.endt_type, 'A') = 'N'
                       AND LAST_DAY (TO_DATE (   a.booking_mth
                                              || ','
                                              || TO_CHAR (a.booking_year),
                                              'FMMONTH,YYYY'
                                             )
                                    ) BETWEEN LAST_DAY (p_from)
                                          AND LAST_DAY (p_to)
                       AND a.pol_flag <> '5'
                      )
                   OR (   TRUNC (NVL (a.acct_ent_date, p_to + 60))
                             BETWEEN p_from
                                 AND p_to
                       OR TRUNC (NVL (a.spld_acct_ent_date, p_to + 60))
                             BETWEEN p_from
                                 AND p_to
                      )
                   OR EXISTS (
                         SELECT 1
                           FROM gipi_polbasic t, gipi_invoice v
                          WHERE t.policy_id = a.policy_id
                            AND t.policy_id = v.policy_id
                            AND (   TRUNC (NVL (v.acct_ent_date, p_to + 60))
                                       BETWEEN p_from
                                           AND p_to
                                 OR TRUNC (NVL (v.spoiled_acct_ent_date,
                                                p_to + 60
                                               )
                                          ) BETWEEN p_from AND p_to
                                ))
                  )
         ORDER BY a.eff_date DESC, a.endt_seq_no DESC;

      CURSOR get_max_endt
      IS
         SELECT MAX (a.endt_seq_no) endt_seq_no
           FROM gipi_polbasic a
          WHERE 1 = 1
            AND a.line_cd = p_line_cd
            AND a.subline_cd = p_subline_cd
            AND a.iss_cd = p_iss_cd
            AND a.issue_yy = p_issue_yy
            AND a.pol_seq_no = p_pol_seq_no
            AND a.renew_no = p_renew_no
            AND (   NVL (p_inc_exp, 'N') = 'Y'
                 OR TRUNC (NVL (a.endt_expiry_date, expiry_date)) >=
                                                               TRUNC (SYSDATE)
                )
            AND (   p_date_type <> 'BD'
                 OR (a.booking_mth IS NOT NULL AND a.booking_year IS NOT NULL
                    )
                )
            AND (p_date_type = 'AD' OR a.pol_flag <> '5')
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ED'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.eff_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ID'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.issue_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'BD'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR (LAST_DAY (TO_DATE (   a.booking_mth
                                        || ','
                                        || TO_CHAR (a.booking_year),
                                        'FMMONTH,YYYY'
                                       )
                              ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (LAST_DAY (TO_DATE (   v.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (v.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from)
                                              AND LAST_DAY (p_to)
                              ))
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'AD'
                 OR (    a.endt_seq_no > 0
                     AND NVL (p_inc_endt, 'N') = 'Y'
                     AND (   a.acct_ent_date IS NOT NULL
                          OR a.spld_acct_ent_date IS NOT NULL
                         )
                    )
                 OR (    NVL (a.endt_type, 'A') = 'N'
                     AND LAST_DAY (TO_DATE (   a.booking_mth
                                            || ','
                                            || TO_CHAR (a.booking_year),
                                            'FMMONTH,YYYY'
                                           )
                                  ) BETWEEN LAST_DAY (p_from) AND LAST_DAY
                                                                         (p_to)
                     AND a.pol_flag <> '5'
                    )
                 OR (   TRUNC (NVL (a.acct_ent_date, p_to + 60)) BETWEEN p_from
                                                                     AND p_to
                     OR TRUNC (NVL (a.spld_acct_ent_date, p_to + 60))
                           BETWEEN p_from
                               AND p_to
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (   TRUNC (NVL (v.acct_ent_date, p_to + 60))
                                     BETWEEN p_from
                                         AND p_to
                               OR TRUNC (NVL (v.spoiled_acct_ent_date,
                                              p_to + 60
                                             )
                                        ) BETWEEN p_from AND p_to
                              ))
                );

      CURSOR get_max_backward
      IS
         SELECT MAX (a.endt_seq_no) endt_seq_no
           FROM gipi_polbasic a
          WHERE 1 = 1
            AND a.line_cd = p_line_cd
            AND a.subline_cd = p_subline_cd
            AND a.iss_cd = p_iss_cd
            AND a.issue_yy = p_issue_yy
            AND a.pol_seq_no = p_pol_seq_no
            AND a.renew_no = p_renew_no
            AND NVL (a.back_stat, 5) = 2
            AND (   NVL (p_inc_exp, 'N') = 'Y'
                 OR TRUNC (NVL (a.endt_expiry_date, expiry_date)) >=
                                                               TRUNC (SYSDATE)
                )
            AND (   p_date_type <> 'BD'
                 OR (a.booking_mth IS NOT NULL AND a.booking_year IS NOT NULL
                    )
                )
            AND (p_date_type = 'AD' OR a.pol_flag <> '5')
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ED'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.eff_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'ID'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR TRUNC (a.issue_date) BETWEEN p_from AND p_to
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'BD'
                 OR (a.endt_seq_no > 0 AND NVL (p_inc_endt, 'N') = 'Y')
                 OR (LAST_DAY (TO_DATE (   a.booking_mth
                                        || ','
                                        || TO_CHAR (a.booking_year),
                                        'FMMONTH,YYYY'
                                       )
                              ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (LAST_DAY (TO_DATE (   v.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (v.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from)
                                              AND LAST_DAY (p_to)
                              ))
                )
            AND (   a.endt_seq_no = 0
                 OR p_date_type <> 'AD'
                 OR (    a.endt_seq_no > 0
                     AND NVL (p_inc_endt, 'N') = 'Y'
                     AND (   a.acct_ent_date IS NOT NULL
                          OR a.spld_acct_ent_date IS NOT NULL
                         )
                    )
                 OR (    NVL (a.endt_type, 'A') = 'N'
                     AND LAST_DAY (TO_DATE (   a.booking_mth
                                            || ','
                                            || TO_CHAR (a.booking_year),
                                            'FMMONTH,YYYY'
                                           )
                                  ) BETWEEN LAST_DAY (p_from) AND LAST_DAY
                                                                         (p_to)
                     AND a.pol_flag <> '5'
                    )
                 OR (   TRUNC (NVL (a.acct_ent_date, p_to + 60)) BETWEEN p_from
                                                                     AND p_to
                     OR TRUNC (NVL (a.spld_acct_ent_date, p_to + 60))
                           BETWEEN p_from
                               AND p_to
                    )
                 OR EXISTS (
                       SELECT 1
                         FROM gipi_polbasic t, gipi_invoice v
                        WHERE t.policy_id = a.policy_id
                          AND t.policy_id = v.policy_id
                          AND (   TRUNC (NVL (v.acct_ent_date, p_to + 60))
                                     BETWEEN p_from
                                         AND p_to
                               OR TRUNC (NVL (v.spoiled_acct_ent_date,
                                              p_to + 60
                                             )
                                        ) BETWEEN p_from AND p_to
                              ))
                );
   BEGIN
      FOR a1 IN get_max_endt
      LOOP
         v_max_endt := a1.endt_seq_no;
         EXIT;
      END LOOP;

      FOR a2 IN get_max_backward
      LOOP
         v_max_backward := a2.endt_seq_no;
         EXIT;
      END LOOP;

      IF v_max_endt = v_max_backward
      THEN
         v_targetpol := v_max_backward;
      ELSE
         FOR a3 IN get_latestdtl
         LOOP
            v_targetpol := a3.endt_seq_no;
            EXIT;
         END LOOP;
      END IF;

      BEGIN
         SELECT policy_id
           INTO v_target_polid
           FROM gipi_polbasic
          WHERE line_cd = p_line_cd
            AND subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND issue_yy = p_issue_yy
            AND pol_seq_no = p_pol_seq_no
            AND renew_no = p_renew_no
            AND endt_seq_no = v_targetpol;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_target_polid := NULL;
      END;

      RETURN v_target_polid;
   END get_latest_eff_polendt;

   FUNCTION get_block_id (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_block_id   gipi_fireitem.block_id%TYPE   := NULL;
   BEGIN
      BEGIN
         SELECT block_id
           INTO v_block_id
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_block_id := NULL;
      END;

      RETURN v_block_id;
   END get_block_id;

   FUNCTION get_risk_cd (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_risk_cd   gipi_fireitem.risk_cd%TYPE;
   BEGIN
      BEGIN
         SELECT risk_cd
           INTO v_risk_cd
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_risk_cd := NULL;
      END;

      RETURN v_risk_cd;
   END get_risk_cd;

   FUNCTION get_fr_item_type (
      p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
      p_item_no     IN   gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_fr_item_type   gipi_fireitem.fr_item_type%TYPE;
   BEGIN
      BEGIN
         SELECT fr_item_type
           INTO v_fr_item_type
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_fr_item_type := NULL;
      END;

      RETURN v_fr_item_type;
   END get_fr_item_type;

   FUNCTION get_occupancy_cd (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_occupancy_cd   gipi_fireitem.occupancy_cd%TYPE;
   BEGIN
      BEGIN
         SELECT occupancy_cd
           INTO v_occupancy_cd
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_occupancy_cd := NULL;
      END;

      RETURN v_occupancy_cd;
   END get_occupancy_cd;

   FUNCTION get_tarf_cd (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_tarf_cd   gipi_fireitem.tarf_cd%TYPE;
   BEGIN
      BEGIN
         SELECT tarf_cd
           INTO v_tarf_cd
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tarf_cd := NULL;
      END;

      RETURN v_tarf_cd;
   END get_tarf_cd;

   FUNCTION get_eq_zone (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eq_zone   gipi_fireitem.eq_zone%TYPE;
   BEGIN
      BEGIN
         SELECT eq_zone
           INTO v_eq_zone
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_eq_zone := NULL;
      END;

      RETURN v_eq_zone;
   END get_eq_zone;

   FUNCTION get_flood_zone (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_flood_zone   gipi_fireitem.flood_zone%TYPE;
   BEGIN
      BEGIN
         SELECT flood_zone
           INTO v_flood_zone
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_flood_zone := NULL;
      END;

      RETURN v_flood_zone;
   END get_flood_zone;

   FUNCTION get_typhoon_zone (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_typhoon_zone   gipi_fireitem.typhoon_zone%TYPE;
   BEGIN
      BEGIN
         SELECT typhoon_zone
           INTO v_typhoon_zone
           FROM gipi_fireitem
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_typhoon_zone := NULL;
      END;

      RETURN v_typhoon_zone;
   END get_typhoon_zone;

   FUNCTION get_assd_no (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN NUMBER
   IS
      v_assd_no   gipi_polbasic.assd_no%TYPE;
   BEGIN
      BEGIN
         SELECT assd_no
           INTO v_assd_no
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_assd_no := NULL;
      END;

      RETURN v_assd_no;
   END get_assd_no;

   PROCEDURE update_non_affecting_info (
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_dt_type      IN   VARCHAR2,
      p_bus_cd       IN   NUMBER,
      p_zone         IN   VARCHAR2,
      p_type         IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_peril_type   IN   VARCHAR2,
      p_user_id      IN   giis_users.user_id%TYPE
   )
   IS
      TYPE fd_line_cd IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE fd_subline_cd IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE fd_iss_cd IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE fd_issue_yy IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE fd_pol_seq_no IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE fd_renew_no IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE fd_item_no IS TABLE OF giuw_itemperilds_dtl.item_no%TYPE;

      TYPE fd_block_id IS TABLE OF gipi_fireitem.block_id%TYPE;

      TYPE fd_risk_cd IS TABLE OF gipi_fireitem.risk_cd%TYPE;

      TYPE fd_fr_item_type IS TABLE OF gipi_fireitem.fr_item_type%TYPE;

      TYPE fd_occupancy_cd IS TABLE OF gipi_fireitem.occupancy_cd%TYPE;

      TYPE fd_tarf_cd IS TABLE OF gipi_fireitem.tarf_cd%TYPE;

      TYPE fd_eq_zone IS TABLE OF gipi_fireitem.eq_zone%TYPE;

      TYPE fd_flood_zone IS TABLE OF gipi_fireitem.flood_zone%TYPE;

      TYPE fd_typhoon_zone IS TABLE OF gipi_fireitem.typhoon_zone%TYPE;

      TYPE fd_assd_no IS TABLE OF giis_assured.assd_no%TYPE;

      vv_line_cd         fd_line_cd;
      vv_subline_cd      fd_subline_cd;
      vv_iss_cd          fd_iss_cd;
      vv_issue_yy        fd_issue_yy;
      vv_pol_seq_no      fd_pol_seq_no;
      vv_renew_no        fd_renew_no;
      vv_item_no         fd_item_no;
      vv_block_id        fd_block_id;
      vv_risk_cd         fd_risk_cd;
      vv_fr_item_type    fd_fr_item_type;
      vv_occupancy_cd    fd_occupancy_cd;
      vv_tarf_cd         fd_tarf_cd;
      vv_eq_zone         fd_eq_zone;
      vv_flood_zone      fd_flood_zone;
      vv_typhoon_zone    fd_typhoon_zone;
      vv_assd_no         fd_assd_no;
      v_temp_policy_id   gipi_polbasic.policy_id%TYPE;
   BEGIN
      NULL;

      SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy,
                      pol_seq_no, renew_no, item_no, NULL,
                      NULL, NULL, NULL,
                      NULL, NULL, NULL, NULL
      BULK COLLECT INTO vv_line_cd, vv_subline_cd, vv_iss_cd, vv_issue_yy,
                      vv_pol_seq_no, vv_renew_no, vv_item_no, vv_block_id,
                      vv_risk_cd, vv_fr_item_type, vv_occupancy_cd,
                      vv_tarf_cd, vv_eq_zone, vv_flood_zone, vv_typhoon_zone
                 FROM gipi_firestat_extract_dtl x
                WHERE x.zone_type = p_type
                  AND x.as_of_sw = 'N'
                  AND x.user_id = p_user_id;

      IF vv_line_cd.EXISTS (1)
      THEN
         FOR idx IN vv_line_cd.FIRST .. vv_line_cd.LAST
         LOOP
            -- get latest block_id
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field
                                                         (vv_line_cd (idx),
                                                          vv_subline_cd (idx),
                                                          vv_iss_cd (idx),
                                                          vv_issue_yy (idx),
                                                          vv_pol_seq_no (idx),
                                                          vv_renew_no (idx),
                                                          vv_item_no (idx),
                                                          p_from,
                                                          p_to,
                                                          p_dt_type,
                                                          p_inc_exp,
                                                          p_inc_endt,
                                                          'BLOCK_ID'
                                                         );
            vv_block_id (idx) :=
               p_zone_fromto_dtl.get_block_id (v_temp_policy_id,
                                               vv_item_no (idx)
                                              );
            -- get latest risk_cd
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'RISK_CD'
                                                          );
            vv_risk_cd (idx) :=
               p_zone_fromto_dtl.get_risk_cd (v_temp_policy_id,
                                              vv_item_no (idx)
                                             );
            -- get latest fr_item_type
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'FR_ITEM_TYPE'
                                                          );
            vv_fr_item_type (idx) :=
               p_zone_fromto_dtl.get_fr_item_type (v_temp_policy_id,
                                                   vv_item_no (idx)
                                                  );
            -- get latest occupancy_cd
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'OCCUPANCY_CD'
                                                          );
            vv_occupancy_cd (idx) :=
               p_zone_fromto_dtl.get_occupancy_cd (v_temp_policy_id,
                                                   vv_item_no (idx)
                                                  );
            -- get latest effective tariff code
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'TARF_CD'
                                                          );
            vv_tarf_cd (idx) :=
               p_zone_fromto_dtl.get_tarf_cd (v_temp_policy_id,
                                              vv_item_no (idx)
                                             );
            -- get latest EQ_ZONE
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'EQ_ZONE'
                                                          );
            vv_eq_zone (idx) :=
               p_zone_fromto_dtl.get_eq_zone (v_temp_policy_id,
                                              vv_item_no (idx)
                                             );
            -- get latest FLOOD_ZONE
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'FLOOD_ZONE'
                                                          );
            vv_flood_zone (idx) :=
               p_zone_fromto_dtl.get_flood_zone (v_temp_policy_id,
                                                 vv_item_no (idx)
                                                );
            -- get latest TYPHOON_ZONE
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_per_field (vv_line_cd (idx),
                                                           vv_subline_cd (idx),
                                                           vv_iss_cd (idx),
                                                           vv_issue_yy (idx),
                                                           vv_pol_seq_no (idx),
                                                           vv_renew_no (idx),
                                                           vv_item_no (idx),
                                                           p_from,
                                                           p_to,
                                                           p_dt_type,
                                                           p_inc_exp,
                                                           p_inc_endt,
                                                           'TYPHOON_ZONE'
                                                          );
            vv_typhoon_zone (idx) :=
               p_zone_fromto_dtl.get_typhoon_zone (v_temp_policy_id,
                                                   vv_item_no (idx)
                                                  );
         END LOOP;
      END IF;

      IF SQL%FOUND
      THEN
         FORALL rec IN vv_line_cd.FIRST .. vv_line_cd.LAST
            UPDATE gipi_firestat_extract_dtl xx
               SET xx.tarf_cd = vv_tarf_cd (rec),
                   xx.block_id = vv_block_id (rec),
                   xx.risk_cd = vv_risk_cd (rec),
                   xx.occupancy_cd = vv_occupancy_cd (rec),
                   xx.fr_item_type = vv_fr_item_type (rec),
                   xx.eq_zone = vv_eq_zone (rec),
                   xx.flood_zone = vv_flood_zone (rec),
                   xx.typhoon_zone = vv_typhoon_zone (rec)
             WHERE xx.zone_type = p_type
               AND xx.user_id = p_user_id
               AND xx.as_of_sw = 'N'
               AND xx.line_cd = vv_line_cd (rec)
               AND xx.subline_cd = vv_subline_cd (rec)
               AND xx.iss_cd = vv_iss_cd (rec)
               AND xx.issue_yy = vv_issue_yy (rec)
               AND xx.pol_seq_no = vv_pol_seq_no (rec)
               AND xx.renew_no = vv_renew_no (rec)
               AND xx.item_no = vv_item_no (rec);
      END IF;

      COMMIT;
      vv_line_cd := fd_line_cd ();
      vv_subline_cd := fd_subline_cd ();
      vv_iss_cd := fd_iss_cd ();
      vv_issue_yy := fd_issue_yy ();
      vv_pol_seq_no := fd_pol_seq_no ();
      vv_renew_no := fd_renew_no ();
      vv_assd_no := fd_assd_no ();

      SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy,
                      pol_seq_no, renew_no, NULL
      BULK COLLECT INTO vv_line_cd, vv_subline_cd, vv_iss_cd, vv_issue_yy,
                      vv_pol_seq_no, vv_renew_no, vv_assd_no
                 FROM gipi_firestat_extract_dtl x
                WHERE x.zone_type = p_type
                  AND x.as_of_sw = 'N'
                  AND x.user_id = p_user_id;

      IF vv_line_cd.EXISTS (1)
      THEN
         FOR idx IN vv_line_cd.FIRST .. vv_line_cd.LAST
         LOOP
            v_temp_policy_id :=
               p_zone_fromto_dtl.get_latest_eff_polendt (vv_line_cd (idx),
                                                         vv_subline_cd (idx),
                                                         vv_iss_cd (idx),
                                                         vv_issue_yy (idx),
                                                         vv_pol_seq_no (idx),
                                                         vv_renew_no (idx),
                                                         p_from,
                                                         p_to,
                                                         p_dt_type,
                                                         p_inc_exp,
                                                         p_inc_endt
                                                        );
            vv_assd_no (idx) :=
                              p_zone_fromto_dtl.get_assd_no (v_temp_policy_id);
         END LOOP;
      END IF;

      IF SQL%FOUND
      THEN
         FORALL rec2 IN vv_line_cd.FIRST .. vv_line_cd.LAST
            UPDATE gipi_firestat_extract_dtl xx
               SET xx.assd_no = vv_assd_no (rec2)
             WHERE xx.zone_type = p_type
               AND xx.user_id = p_user_id
               AND xx.as_of_sw = 'N'
               AND xx.line_cd = vv_line_cd (rec2)
               AND xx.subline_cd = vv_subline_cd (rec2)
               AND xx.iss_cd = vv_iss_cd (rec2)
               AND xx.issue_yy = vv_issue_yy (rec2)
               AND xx.pol_seq_no = vv_pol_seq_no (rec2)
               AND xx.renew_no = vv_renew_no (rec2);
      END IF;

      COMMIT;

       /* ================================================================================
      **   UPDATE TYPHOON AND FLOOD WITH CORRECT PRECEDENCE OF ZONE_NO
      ** ===============================================================================*/
      IF p_type = 5
      THEN
         UPDATE gipi_firestat_extract_dtl ab
            SET zone_no = NVL (ab.typhoon_zone, ab.flood_zone)
          WHERE ab.user_id = p_user_id
            AND ab.zone_type = p_type
            AND ab.as_of_sw = 'N';
      ELSIF p_type = 1
      THEN
         UPDATE gipi_firestat_extract_dtl ab
            SET zone_no = ab.flood_zone
          WHERE ab.user_id = p_user_id
            AND ab.zone_type = p_type
            AND ab.as_of_sw = 'N';
      ELSIF p_type = 2
      THEN
         UPDATE gipi_firestat_extract_dtl ab
            SET zone_no = ab.typhoon_zone
          WHERE ab.user_id = p_user_id
            AND ab.zone_type = p_type
            AND ab.as_of_sw = 'N';
      ELSIF p_type = 3
      THEN
         UPDATE gipi_firestat_extract_dtl ab
            SET zone_no = ab.eq_zone
          WHERE ab.user_id = p_user_id
            AND ab.zone_type = p_type
            AND ab.as_of_sw = 'N';
      END IF;

      COMMIT;

       /* ================================================================================
      **   UPDATE TYPHOON AND FLOOD WITH CORRECT PRECEDENCE OF ZONE_NO
      ** ===============================================================================*/
      UPDATE gipi_firestat_extract_dtl ab
         SET tariff_cd = SUBSTR (NVL (tarf_cd, ''), 1, 1)
       WHERE ab.user_id = p_user_id
         AND ab.zone_type = p_type
         AND ab.zone_type = 5
         AND ab.as_of_sw = 'N';

      COMMIT;
         /* ================================================================================
      **   MERGE  fire item group based on fr_item_type
      ** ===============================================================================*/
      MERGE INTO gipi_firestat_extract_dtl gfe
         USING (SELECT bx.fi_item_grp, bx.fr_item_type
                  FROM giis_fi_item_type bx) ext_tbl
         ON (    gfe.user_id = p_user_id
             AND gfe.zone_type = p_type
             AND gfe.as_of_sw = 'N'
             AND gfe.fr_item_type IS NOT NULL
             AND gfe.fr_item_type = ext_tbl.fr_item_type)
         WHEN MATCHED THEN
            UPDATE
               SET fi_item_grp = ext_tbl.fi_item_grp
            ;
      COMMIT;
   END update_non_affecting_info;

   PROCEDURE extract2 (
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_dt_type      IN   VARCHAR2,
      p_bus_cd       IN   NUMBER,
      p_zone         IN   VARCHAR2,
      p_type         IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_peril_type   IN   VARCHAR2,
      p_user_id      IN   giis_users.user_id%TYPE
   )
   /** Created by : Jhing Factor
   **  Purpose    : New Extraction to merge extraction by zone and extraction by tariff.
   **               The query for redistribution is intentionally separated since there would be additional conditions for the redistributed records.
   **
   **               Here is the current logic of the extraction:
   **                  1) Extract all policy records that meets the criteria/extract conditions. Endorsements are not yet included. Extract only un-redistributed records.
   **                  2) Extract all policy records that meets the critera/extract conditions and which are already REDISTRIBUTED ( dist_flag = 5 ).
   **                  3) Extract endorsements of the extracted policy records in step 1. Extract only un-redistributed records.
   **                  4) Extract endorsements of the extracted policy records in step 1. Extract REDISTRIBUTED records.
   **                  5) Retrieve the effective non-affecting details of the records and update it.
   **                  6) if the user did not choose to include null zone, delete records with null zone.
   */
   AS
      TYPE fd_policy_id IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE fd_assd_no IS TABLE OF gipi_polbasic.assd_no%TYPE;

      TYPE fd_line_cd IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE fd_subline_cd IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE fd_iss_cd IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE fd_issue_yy IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE fd_pol_seq_no IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE fd_renew_no IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE fd_endt_seq_no IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE fd_dist_no IS TABLE OF giuw_pol_dist.dist_no%TYPE;

      TYPE fd_dist_seq_no IS TABLE OF giuw_policyds.dist_seq_no%TYPE;

      TYPE fd_dist_flag IS TABLE OF giuw_pol_dist.dist_flag%TYPE;

      TYPE fd_dist_acct_ent_date IS TABLE OF giuw_pol_dist.acct_ent_date%TYPE;

      TYPE fd_dist_acct_neg_date IS TABLE OF giuw_pol_dist.acct_neg_date%TYPE;

      TYPE fd_dist_eff_date IS TABLE OF giuw_pol_dist.eff_date%TYPE;

      TYPE fd_gp_issue_date IS TABLE OF gipi_polbasic.issue_date%TYPE;

      TYPE fd_gp_eff_date IS TABLE OF gipi_polbasic.eff_date%TYPE;

      TYPE fd_gp_booking_mth IS TABLE OF gipi_polbasic.booking_mth%TYPE;

      TYPE fd_gp_booking_year IS TABLE OF gipi_polbasic.booking_year%TYPE;

      TYPE fd_gp_acct_ent_date IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE fd_gp_spld_acct_ent_date IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE fd_item_grp IS TABLE OF gipi_invoice.item_grp%TYPE;

      TYPE fd_takeup_seq_no IS TABLE OF gipi_invoice.takeup_seq_no%TYPE;

      TYPE fd_item_no IS TABLE OF giuw_itemperilds_dtl.item_no%TYPE;

      TYPE fd_peril_cd IS TABLE OF giuw_itemperilds_dtl.peril_cd%TYPE;

      TYPE fd_zone_type IS TABLE OF giis_peril.zone_type%TYPE;

      TYPE fd_eq_zone_type IS TABLE OF giis_peril.eq_zone_type%TYPE;

      TYPE fd_share_cd IS TABLE OF giuw_itemperilds_dtl.share_cd%TYPE;

      TYPE fd_share_tsi_amt IS TABLE OF giuw_policyds_dtl.dist_tsi%TYPE;

      TYPE fd_dist_prem IS TABLE OF giuw_itemperilds_dtl.dist_prem%TYPE;

      TYPE fd_redist_date IS TABLE OF giuw_pol_dist.eff_date%TYPE;

      TYPE fd_redist_max_dist_no IS TABLE OF giuw_pol_dist.dist_no%TYPE;

      vv_policy_id                fd_policy_id;
      vv_assd_no                  fd_assd_no;
      vv_line_cd                  fd_line_cd;
      vv_subline_cd               fd_subline_cd;
      vv_iss_cd                   fd_iss_cd;
      vv_issue_yy                 fd_issue_yy;
      vv_pol_seq_no               fd_pol_seq_no;
      vv_renew_no                 fd_renew_no;
      vv_endt_seq_no              fd_endt_seq_no;
      vv_dist_no                  fd_dist_no;
      vv_dist_seq_no              fd_dist_seq_no;
      vv_dist_flag                fd_dist_flag;
      vv_dist_acct_ent_date       fd_dist_acct_ent_date;
      vv_dist_acct_neg_date       fd_dist_acct_neg_date;
      vv_dist_eff_date            fd_dist_eff_date;
      vv_gp_issue_date            fd_gp_issue_date;
      vv_gp_eff_date              fd_gp_eff_date;
      vv_gp_booking_mth           fd_gp_booking_mth;
      vv_gp_booking_year          fd_gp_booking_year;
      vv_gp_acct_ent_date         fd_gp_acct_ent_date;
      vv_gp_spld_acct_ent_date    fd_gp_spld_acct_ent_date;
      vv_item_grp                 fd_item_grp;
      vv_takeup_seq_no            fd_takeup_seq_no;
      vv_item_no                  fd_item_no;
      vv_peril_cd                 fd_peril_cd;
      vv_zone_type                fd_zone_type;
      vv_eq_zone_type             fd_eq_zone_type;
      vv_share_cd                 fd_share_cd;
      vv_share_tsi_amt            fd_share_tsi_amt;
      vv_share_prem_amt           fd_dist_prem;
      vv_redist_date              fd_redist_date;
      vv_redist_max_dist_no       fd_redist_max_dist_no;
      -- for second collection
      v_cnt                       NUMBER;
      vv_policy_id2               fd_policy_id;
      vv_assd_no2                 fd_assd_no;
      vv_line_cd2                 fd_line_cd;
      vv_subline_cd2              fd_subline_cd;
      vv_iss_cd2                  fd_iss_cd;
      vv_issue_yy2                fd_issue_yy;
      vv_pol_seq_no2              fd_pol_seq_no;
      vv_renew_no2                fd_renew_no;
      vv_endt_seq_no2             fd_endt_seq_no;
      vv_dist_no2                 fd_dist_no;
      vv_dist_seq_no2             fd_dist_seq_no;
      vv_dist_flag2               fd_dist_flag;
      vv_dist_acct_ent_date2      fd_dist_acct_ent_date;
      vv_dist_acct_neg_date2      fd_dist_acct_neg_date;
      vv_dist_eff_date2           fd_dist_eff_date;
      vv_gp_issue_date2           fd_gp_issue_date;
      vv_gp_eff_date2             fd_gp_eff_date;
      vv_gp_booking_mth2          fd_gp_booking_mth;
      vv_gp_booking_year2         fd_gp_booking_year;
      vv_gp_acct_ent_date2        fd_gp_acct_ent_date;
      vv_gp_spld_acct_ent_date2   fd_gp_spld_acct_ent_date;
      vv_item_grp2                fd_item_grp;
      vv_takeup_seq_no2           fd_takeup_seq_no;
      vv_item_no2                 fd_item_no;
      vv_peril_cd2                fd_peril_cd;
      vv_zone_type2               fd_zone_type;
      vv_eq_zone_type2            fd_eq_zone_type;
      vv_share_cd2                fd_share_cd;
      vv_share_tsi_amt2           fd_share_tsi_amt;
      vv_share_prem_amt2          fd_dist_prem;
      vv_redist_date2             fd_redist_date;
      vv_redist_max_dist_no2      fd_redist_max_dist_no;
      v_ri_cd                     giis_issource.iss_cd%TYPE;
      v_multiplier                NUMBER;
      v_tsi_multiplier            NUMBER;
      v_display_rec               NUMBER;
   BEGIN
      -- delete the contents of the other extract tables. These tables will no longer be used by the Fire Statistical Reports and hence should be deleted or
      -- removed to reduce any possibility of error on the generated Reports
      DELETE FROM gipi_firestat_extract
            WHERE user_id = p_user_id AND as_of_sw = 'N';

      DELETE FROM gixx_firestat_summary_dtl
            WHERE user_id = p_user_id AND as_of_sw = 'N';

      DELETE FROM gixx_firestat_summary_dtl
            WHERE user_id = p_user_id AND as_of_sw = 'N';

      -- delete extracted data for the same zone type. GIPI_FIRESTAT_EXTRACT_TBL would be the only remaining table to be maintained
      DELETE FROM gipi_firestat_extract_dtl
            WHERE user_id = p_user_id AND zone_type = p_type
                  AND as_of_sw = 'N';

      COMMIT;
      v_ri_cd := giisp.v ('ISS_CD_RI');

      /* ==============================================================================================================================
      **    Extract the original policy first - non-redistributed.
      **
      ** =============================================================================================================================*/
      SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
             a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_seq_no,
             a.dist_no, a.dist_seq_no, a.poldist_dist_flag,
             a.poldist_acct_ent_date, a.poldist_acct_neg_date,
             a.poldist_eff_date, a.issue_date, a.polbasic_eff_date,
             a.booking_mth, a.booking_year, a.polbasic_acct_ent_date,
             a.spld_acct_ent_date, a.item_grp, a.takeup_seq_no,
             a.item_no, a.peril_cd, a.zone_type, a.eq_zone_type,
             a.share_cd,
             (NVL (a.dist_tsi, 0) * NVL (a.currency_rt, 1)) share_tsi_amt,
             (NVL (a.dist_prem, 0) * NVL (a.currency_rt, 1)
             ) prem_share
      BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd,
             vv_issue_yy, vv_pol_seq_no, vv_renew_no, vv_endt_seq_no,
             vv_dist_no, vv_dist_seq_no, vv_dist_flag,
             vv_dist_acct_ent_date, vv_dist_acct_neg_date,
             vv_dist_eff_date, vv_gp_issue_date, vv_gp_eff_date,
             vv_gp_booking_mth, vv_gp_booking_year, vv_gp_acct_ent_date,
             vv_gp_spld_acct_ent_date, vv_item_grp, vv_takeup_seq_no,
             vv_item_no, vv_peril_cd, vv_zone_type, vv_eq_zone_type,
             vv_share_cd,
             vv_share_tsi_amt,
             vv_share_prem_amt
        FROM giuw_gipi_firestat_vw a,
             (SELECT branch_cd iss_cd, line_cd
                FROM TABLE (security_access.get_branch_line ('UW',
                                                             'GIPIS901',
                                                             p_user_id
                                                            )
                           )) b
       WHERE 1 = 1
         AND a.iss_cd = b.iss_cd
         AND a.line_cd = b.line_cd
         AND a.iss_cd <> DECODE (p_bus_cd, 1, v_ri_cd, 'XXXXXX')
         AND a.iss_cd = DECODE (p_bus_cd, 2, v_ri_cd, a.iss_cd)
         AND (   NVL (p_inc_exp, 'N') = 'Y'
              OR TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                               TRUNC (SYSDATE)
             )
         AND a.endt_seq_no = 0
         AND a.zone_type = p_type
         AND (p_dt_type = 'AD' OR a.pol_flag IN ('1', '2', '3', 'X'))
         AND (p_dt_type = 'AD' OR a.poldist_dist_flag = '3')
         AND a.peril_type =
                 DECODE (p_peril_type,
                         'A', 'A',
                         'B', 'B',
                         'AB', a.peril_type
                        )
         AND (   TRUNC (a.issue_date) BETWEEN p_from AND p_to
              OR DECODE (p_dt_type, 'ID', 0, 1) = 1
             )
         AND (   TRUNC (a.polbasic_eff_date) BETWEEN p_from AND p_to
              OR DECODE (p_dt_type, 'ED', 0, 1) = 1
             )
         AND (   DECODE (p_dt_type, 'BD', 0, 1) = 1
              OR (    (a.booking_mth IS NOT NULL
                       AND a.booking_year IS NOT NULL
                      )
                  AND LAST_DAY (TO_DATE (   a.booking_mth
                                         || ','
                                         || TO_CHAR (a.booking_year),
                                         'FMMONTH,YYYY'
                                        )
                               ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                 )
             )
         AND (   (   TRUNC (a.polbasic_acct_ent_date) BETWEEN p_from AND p_to
                  OR (    (TRUNC (a.spld_acct_ent_date) BETWEEN p_from AND p_to
                          )
                      AND p_dt_type = 'AD'
                     )
                 )
              OR DECODE (p_dt_type, 'AD', 0, 1) = 1
             )
         AND NOT EXISTS (
                         SELECT 1
                           FROM giuw_pol_dist x
                          WHERE x.policy_id = a.policy_id
                                AND x.dist_flag = '5');

      IF vv_policy_id.EXISTS (1)
      THEN
         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            BEGIN
               v_multiplier := 1;

               IF p_dt_type = 'AD'
               THEN
                  IF     TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                 AND p_to
                     AND TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                 AND p_to
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := -1;
                  END IF;

                  vv_share_tsi_amt (idx) :=
                                          vv_share_tsi_amt (idx)
                                          * v_multiplier;
                  vv_share_prem_amt (idx) :=
                                         vv_share_prem_amt (idx)
                                         * v_multiplier;
               END IF;
            END;
         END LOOP;
      END IF;

      IF SQL%FOUND
      THEN
         FORALL rec IN vv_policy_id.FIRST .. vv_policy_id.LAST
            INSERT INTO gipi_firestat_extract_dtl
                        (policy_id, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_seq_no, as_of_date, as_of_sw,
                         item_no, peril_cd,
                         dist_no, dist_seq_no,
                         share_cd, zone_type,
                         eq_zone_type, extract_dt, date_from, date_to,
                         share_prem_amt, share_tsi_amt,
                         user_id, param_date, inc_expired, inc_endt,
                         inc_null_zone, param_iss_cd, param_peril
                        )
                 VALUES (vv_policy_id (rec), vv_line_cd (rec),
                         vv_subline_cd (rec), vv_iss_cd (rec),
                         vv_issue_yy (rec), vv_pol_seq_no (rec),
                         vv_renew_no (rec), vv_endt_seq_no (rec), NULL, 'N',
                         vv_item_no (rec), vv_peril_cd (rec),
                         vv_dist_no (rec), vv_dist_seq_no (rec),
                         vv_share_cd (rec), vv_zone_type (rec),
                         vv_eq_zone_type (rec), SYSDATE, p_from, p_to,
                         vv_share_prem_amt (rec), vv_share_tsi_amt (rec),
                         p_user_id, p_dt_type, p_inc_exp, p_inc_endt,
                         p_zone, p_bus_cd, p_peril_type
                        );
      END IF;

      COMMIT;
      /* ==============================================================================================================================
      **    Extract the original policy first -  redistributed
      **
      ** =============================================================================================================================*/
      vv_policy_id2 := fd_policy_id ();
      vv_line_cd2 := fd_line_cd ();
      vv_subline_cd2 := fd_subline_cd ();
      vv_iss_cd2 := fd_iss_cd ();
      vv_issue_yy2 := fd_issue_yy ();
      vv_pol_seq_no2 := fd_pol_seq_no ();
      vv_renew_no2 := fd_renew_no ();
      vv_endt_seq_no2 := fd_endt_seq_no ();
      vv_item_no2 := fd_item_no ();
      vv_peril_cd2 := fd_peril_cd ();
      vv_dist_no2 := fd_dist_no ();
      vv_dist_seq_no2 := fd_dist_seq_no ();
      vv_share_cd2 := fd_share_cd ();
      vv_zone_type2 := fd_zone_type ();
      vv_eq_zone_type2 := fd_eq_zone_type ();
      vv_share_tsi_amt2 := fd_share_tsi_amt ();
      vv_share_prem_amt2 := fd_dist_prem ();

      SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
             a.pol_seq_no, a.renew_no, a.endt_seq_no, a.dist_no,
             a.dist_seq_no, a.poldist_dist_flag, a.poldist_acct_ent_date,
             a.poldist_acct_neg_date, a.poldist_eff_date, a.issue_date,
             a.polbasic_eff_date, a.booking_mth, a.booking_year,
             a.polbasic_acct_ent_date, a.spld_acct_ent_date, a.item_grp,
             a.takeup_seq_no, a.item_no, a.peril_cd, a.zone_type,
             a.eq_zone_type, a.share_cd,
             (NVL (a.dist_tsi, 0) * NVL (a.currency_rt, 1)
             ) tsi_share,
             (NVL (a.dist_prem, 0) * NVL (a.currency_rt, 1)) prem_share,
             p_zone_fromto_dtl.get_redist_date (a.policy_id,
                                                a.item_grp,
                                                a.takeup_seq_no
                                               ) redist_date,
             p_zone_fromto_dtl.get_max_redist_dist_no (a.policy_id,
                                                       a.item_grp,
                                                       a.takeup_seq_no,
                                                       p_dt_type,
                                                       p_from,
                                                       p_to
                                                      ) redist_max_dist_no
      BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_issue_yy,
             vv_pol_seq_no, vv_renew_no, vv_endt_seq_no, vv_dist_no,
             vv_dist_seq_no, vv_dist_flag, vv_dist_acct_ent_date,
             vv_dist_acct_neg_date, vv_dist_eff_date, vv_gp_issue_date,
             vv_gp_eff_date, vv_gp_booking_mth, vv_gp_booking_year,
             vv_gp_acct_ent_date, vv_gp_spld_acct_ent_date, vv_item_grp,
             vv_takeup_seq_no, vv_item_no, vv_peril_cd, vv_zone_type,
             vv_eq_zone_type, vv_share_cd,
             vv_share_tsi_amt,
             vv_share_prem_amt,
             vv_redist_date,
             vv_redist_max_dist_no
        FROM giuw_gipi_firestat_vw a,
             (SELECT branch_cd iss_cd, line_cd
                FROM TABLE (security_access.get_branch_line ('UW',
                                                             'GIPIS901',
                                                             p_user_id
                                                            )
                           )) b
       WHERE 1 = 1
         AND a.line_cd = b.line_cd
         AND a.iss_cd = b.iss_cd
         AND a.endt_seq_no = 0
         AND EXISTS (SELECT 1
                       FROM giuw_pol_dist x
                      WHERE x.policy_id = a.policy_id AND x.dist_flag = '5')
         AND a.iss_cd <> DECODE (p_bus_cd, 1, v_ri_cd, 'XXXXXX')
         AND a.iss_cd = DECODE (p_bus_cd, 2, v_ri_cd, a.iss_cd)
         AND (   NVL (p_inc_exp, 'N') = 'Y'
              OR TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                               TRUNC (SYSDATE)
             )
         AND (p_dt_type = 'AD' OR a.pol_flag IN ('1', '2', '3', 'X'))
         AND (   p_dt_type = 'AD'
              OR (p_dt_type IN ('ID', 'BD') AND a.poldist_dist_flag = '3')
              OR (p_dt_type = 'ED' AND a.poldist_dist_flag IN ('3', '5'))
             )
         AND a.peril_type =
                 DECODE (p_peril_type,
                         'A', 'A',
                         'B', 'B',
                         'AB', a.peril_type
                        )
         AND a.zone_type = p_type
         AND (   TRUNC (a.issue_date) BETWEEN p_from AND p_to
              OR DECODE (p_dt_type, 'ID', 0, 1) = 1
             )
         AND (   TRUNC (a.polbasic_eff_date) BETWEEN p_from AND p_to
              OR DECODE (p_dt_type, 'ED', 0, 1) = 1
             )
         AND (   DECODE (p_dt_type, 'BD', 0, 1) = 1
              OR (    (a.booking_mth IS NOT NULL
                       AND a.booking_year IS NOT NULL
                      )
                  AND LAST_DAY (TO_DATE (   a.booking_mth
                                         || ','
                                         || TO_CHAR (a.booking_year),
                                         'FMMONTH,YYYY'
                                        )
                               ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                 )
             )
         AND (   (   TRUNC (a.polbasic_acct_ent_date) BETWEEN p_from AND p_to
                  OR (    (TRUNC (a.spld_acct_ent_date) BETWEEN p_from AND p_to
                          )
                      AND p_dt_type = 'AD'
                     )
                 )
              OR DECODE (p_dt_type, 'AD', 0, 1) = 1
             );

      IF vv_policy_id.EXISTS (1)
      THEN
         v_cnt := 0;

         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            BEGIN
               v_multiplier := 1;

               IF p_dt_type = 'AD'
               THEN
                  IF     TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                 AND p_to
                     AND TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                 AND p_to
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := -1;
                  END IF;

                  vv_share_tsi_amt (idx) :=
                                          vv_share_tsi_amt (idx)
                                          * v_multiplier;
                  vv_share_prem_amt (idx) :=
                                         vv_share_prem_amt (idx)
                                         * v_multiplier;
               END IF;

               v_display_rec := 1;

               IF p_dt_type IN ('BD', 'ID') AND vv_dist_flag (idx) = '5'
               THEN
                  v_display_rec := 0;
               ELSIF     p_dt_type = 'ED' THEN
                  IF TRUNC (p_to) < TRUNC (vv_redist_date (idx))
                     AND vv_dist_flag (idx) = '5'
                  THEN
                        v_display_rec := 1;
                  ELSIF TRUNC (p_to) >= TRUNC (vv_redist_date (idx))
                     AND vv_dist_flag (idx) = '5'
                  THEN
                        v_display_rec := 0;
                  ELSIF TRUNC (p_to) <= TRUNC (vv_redist_date (idx))
                     AND vv_dist_flag (idx) <> '5'
                  THEN
                        v_display_rec := 0;        
                  END IF;
               END IF;

               IF v_display_rec = 1
               THEN
                  v_cnt := v_cnt + 1;
                  vv_policy_id2.EXTEND (1);
                  vv_line_cd2.EXTEND (1);
                  vv_subline_cd2.EXTEND (1);
                  vv_iss_cd2.EXTEND (1);
                  vv_issue_yy2.EXTEND (1);
                  vv_pol_seq_no2.EXTEND (1);
                  vv_renew_no2.EXTEND (1);
                  vv_endt_seq_no2.EXTEND (1);
                  vv_item_no2.EXTEND (1);
                  vv_peril_cd2.EXTEND (1);
                  vv_dist_no2.EXTEND (1);
                  vv_dist_seq_no2.EXTEND (1);
                  vv_share_cd2.EXTEND (1);
                  vv_zone_type2.EXTEND (1);
                  vv_eq_zone_type2.EXTEND (1);
                  vv_share_prem_amt2.EXTEND (1);
                  vv_share_tsi_amt2.EXTEND (1);
                  vv_policy_id2 (v_cnt) := vv_policy_id (idx);
                  vv_line_cd2 (v_cnt) := vv_line_cd (idx);
                  vv_subline_cd2 (v_cnt) := vv_subline_cd (idx);
                  vv_iss_cd2 (v_cnt) := vv_iss_cd (idx);
                  vv_issue_yy2 (v_cnt) := vv_issue_yy (idx);
                  vv_pol_seq_no2 (v_cnt) := vv_pol_seq_no (idx);
                  vv_renew_no2 (v_cnt) := vv_renew_no (idx);
                  vv_endt_seq_no2 (v_cnt) := vv_endt_seq_no (idx);
                  vv_item_no2 (v_cnt) := vv_item_no (idx);
                  vv_peril_cd2 (v_cnt) := vv_peril_cd (idx);
                  vv_dist_no2 (v_cnt) := vv_dist_no (idx);
                  vv_dist_seq_no2 (v_cnt) := vv_dist_seq_no (idx);
                  vv_share_cd2 (v_cnt) := vv_share_cd (idx);
                  vv_zone_type2 (v_cnt) := vv_zone_type (idx);
                  vv_eq_zone_type2 (v_cnt) := vv_eq_zone_type (idx);
                  vv_share_prem_amt2 (v_cnt) := vv_share_prem_amt (idx);
                  -- GET MULTIPLIER FOR TSI OF REDIST
                  v_tsi_multiplier := 1;

                  IF p_dt_type = 'ED'
                  THEN
                     IF     TRUNC (p_to) < TRUNC (vv_redist_date (idx))
                        AND vv_dist_flag (idx) = '5'
                     THEN
                        v_tsi_multiplier := 1;
                     ELSIF     TRUNC (p_to) >= TRUNC (vv_redist_date (idx))
                           AND vv_dist_flag (idx) = '5'
                     THEN
                        v_tsi_multiplier := 0;
                     ELSIF     vv_dist_flag (idx) <> '5'
                           AND vv_dist_no (idx) <> vv_redist_max_dist_no (idx)
                     THEN
                        v_tsi_multiplier := 0;
                     END IF;
                  ELSIF p_dt_type IN ('ID', 'BD')
                  THEN
                     IF     vv_dist_flag (idx) <> '5'
                        AND vv_dist_no (idx) <> vv_redist_max_dist_no (idx)
                     THEN
                        v_tsi_multiplier := 0;
                     END IF;
                  ELSIF p_dt_type = 'AD'
                  THEN
                     IF     vv_dist_flag (idx) <> '5'
                        AND vv_dist_no (idx) <> vv_redist_max_dist_no (idx)
                     THEN
                        v_tsi_multiplier := 0;
                     END IF;
                  END IF;

                  vv_share_tsi_amt2 (v_cnt) :=
                                      vv_share_tsi_amt (idx)
                                      * v_tsi_multiplier;
               END IF;
            END;
         END LOOP;
      END IF;

      IF SQL%FOUND
      THEN
         FORALL rec IN vv_policy_id2.FIRST .. vv_policy_id2.LAST
            INSERT INTO gipi_firestat_extract_dtl
                        (policy_id, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_seq_no, as_of_date,
                         as_of_sw, item_no, peril_cd,
                         dist_no, dist_seq_no,
                         share_cd, zone_type,
                         eq_zone_type, extract_dt, date_from, date_to,
                         share_prem_amt, share_tsi_amt,
                         user_id, param_date, inc_expired, inc_endt,
                         inc_null_zone, param_iss_cd, param_peril
                        )
                 VALUES (vv_policy_id2 (rec), vv_line_cd2 (rec),
                         vv_subline_cd2 (rec), vv_iss_cd2 (rec),
                         vv_issue_yy2 (rec), vv_pol_seq_no2 (rec),
                         vv_renew_no2 (rec), vv_endt_seq_no2 (rec), NULL,
                         'N', vv_item_no2 (rec), vv_peril_cd2 (rec),
                         vv_dist_no2 (rec), vv_dist_seq_no2 (rec),
                         vv_share_cd2 (rec), vv_zone_type2 (rec),
                         vv_eq_zone_type2 (rec), SYSDATE, p_from, p_to,
                         vv_share_prem_amt2 (rec), vv_share_tsi_amt2 (rec),
                         p_user_id, p_dt_type, p_inc_exp, p_inc_endt,
                         p_zone, p_bus_cd, p_peril_type
                        );
      END IF;

      COMMIT;
      
      /* ==============================================================================================================================
       **    Extract the endorsements of the policies extracted  - non-redistributed.
       **
       ** =============================================================================================================================*/
      SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
             a.pol_seq_no, a.renew_no, a.endt_seq_no, a.dist_no,
             a.dist_seq_no, a.poldist_dist_flag, a.poldist_acct_ent_date,
             a.poldist_acct_neg_date, a.poldist_eff_date, a.issue_date,
             a.polbasic_eff_date, a.booking_mth, a.booking_year,
             a.polbasic_acct_ent_date, a.spld_acct_ent_date, a.item_grp,
             a.takeup_seq_no, a.item_no, a.peril_cd, a.zone_type,
             a.eq_zone_type, a.share_cd,
             (NVL (a.dist_tsi, 0) * NVL (a.currency_rt, 1)
             ) share_tsi_amt,
             (NVL (a.dist_prem, 0) * NVL (a.currency_rt, 1)) prem_share
      BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_issue_yy,
             vv_pol_seq_no, vv_renew_no, vv_endt_seq_no, vv_dist_no,
             vv_dist_seq_no, vv_dist_flag, vv_dist_acct_ent_date,
             vv_dist_acct_neg_date, vv_dist_eff_date, vv_gp_issue_date,
             vv_gp_eff_date, vv_gp_booking_mth, vv_gp_booking_year,
             vv_gp_acct_ent_date, vv_gp_spld_acct_ent_date, vv_item_grp,
             vv_takeup_seq_no, vv_item_no, vv_peril_cd, vv_zone_type,
             vv_eq_zone_type, vv_share_cd,
             vv_share_tsi_amt,
             vv_share_prem_amt
        FROM giuw_gipi_firestat_vw a
       WHERE 1 = 1
         AND a.endt_seq_no > 0
         AND a.zone_type = p_type
         AND EXISTS (
                SELECT 1
                  FROM gipi_firestat_extract_dtl b
                 WHERE b.user_id = p_user_id
                   AND b.zone_type = p_type
                   AND b.as_of_sw = 'N'
                   AND b.line_cd = a.line_cd
                   AND b.subline_cd = a.subline_cd
                   AND b.iss_cd = a.iss_cd
                   AND b.issue_yy = a.issue_yy
                   AND b.pol_seq_no = a.pol_seq_no
                   AND b.renew_no = a.renew_no
                   AND b.endt_seq_no = 0)
         AND (   NVL (p_inc_exp, 'N') = 'Y'
              OR TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                               TRUNC (SYSDATE)
             )
         AND (p_dt_type = 'AD' OR a.pol_flag IN ('1', '2', '3', 'X'))
         AND (p_dt_type = 'AD' OR a.poldist_dist_flag = '3')
         AND a.peril_type =
                 DECODE (p_peril_type,
                         'A', 'A',
                         'B', 'B',
                         'AB', a.peril_type
                        )
         AND (   p_inc_endt = 'Y'
              OR (TRUNC (a.issue_date) BETWEEN p_from AND p_to)
              OR DECODE (p_dt_type, 'ID', 0, 1) = 1
             )
         AND (   p_inc_endt = 'Y'
              OR (TRUNC (a.polbasic_eff_date) BETWEEN p_from AND p_to)
              OR DECODE (p_dt_type, 'ED', 0, 1) = 1
             )
         AND (   p_inc_endt = 'Y'
              OR DECODE (p_dt_type, 'BD', 0, 1) = 1
              OR (    (a.booking_mth IS NOT NULL
                       AND a.booking_year IS NOT NULL
                      )
                  AND LAST_DAY (TO_DATE (   a.booking_mth
                                         || ','
                                         || TO_CHAR (a.booking_year),
                                         'FMMONTH,YYYY'
                                        )
                               ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                 )
             )
         AND (   p_inc_endt = 'Y'
              OR (   TRUNC (a.polbasic_acct_ent_date) BETWEEN p_from AND p_to
                  OR (    (TRUNC (a.spld_acct_ent_date) BETWEEN p_from AND p_to
                          )
                      AND p_dt_type = 'AD'
                     )
                 )
              OR DECODE (p_dt_type, 'AD', 0, 1) = 1
             )
         AND NOT EXISTS (
                         SELECT 1
                           FROM giuw_pol_dist x
                          WHERE x.policy_id = a.policy_id
                                AND x.dist_flag = '5');

      IF vv_policy_id.EXISTS (1)
      THEN
         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            BEGIN
               v_multiplier := 1;

               IF p_dt_type = 'AD'
               THEN
                  IF     TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                 AND p_to
                     AND TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                 AND p_to
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := -1;
                  END IF;

                  vv_share_tsi_amt (idx) :=
                                          vv_share_tsi_amt (idx)
                                          * v_multiplier;
                  vv_share_prem_amt (idx) :=
                                         vv_share_prem_amt (idx)
                                         * v_multiplier;
               END IF;
            END;
         END LOOP;
      END IF;

      IF SQL%FOUND
      THEN
         FORALL rec IN vv_policy_id.FIRST .. vv_policy_id.LAST
            INSERT INTO gipi_firestat_extract_dtl
                        (policy_id, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_seq_no, as_of_date, as_of_sw,
                         item_no, peril_cd,
                         dist_no, dist_seq_no,
                         share_cd, zone_type,
                         eq_zone_type, extract_dt, date_from, date_to,
                         share_prem_amt, share_tsi_amt,
                         user_id, param_date, inc_expired, inc_endt,
                         inc_null_zone, param_iss_cd, param_peril
                        )
                 VALUES (vv_policy_id (rec), vv_line_cd (rec),
                         vv_subline_cd (rec), vv_iss_cd (rec),
                         vv_issue_yy (rec), vv_pol_seq_no (rec),
                         vv_renew_no (rec), vv_endt_seq_no (rec), NULL, 'N',
                         vv_item_no (rec), vv_peril_cd (rec),
                         vv_dist_no (rec), vv_dist_seq_no (rec),
                         vv_share_cd (rec), vv_zone_type (rec),
                         vv_eq_zone_type (rec), SYSDATE, p_from, p_to,
                         vv_share_prem_amt (rec), vv_share_tsi_amt (rec),
                         p_user_id, p_dt_type, p_inc_exp, p_inc_endt,
                         p_zone, p_bus_cd, p_peril_type
                        );
      END IF;

      COMMIT;
      /* ==============================================================================================================================
       **    Extract the original endorsement  -  redistributed
       **
       ** =============================================================================================================================*/
      vv_policy_id2 := fd_policy_id ();
      vv_line_cd2 := fd_line_cd ();
      vv_subline_cd2 := fd_subline_cd ();
      vv_iss_cd2 := fd_iss_cd ();
      vv_issue_yy2 := fd_issue_yy ();
      vv_pol_seq_no2 := fd_pol_seq_no ();
      vv_renew_no2 := fd_renew_no ();
      vv_endt_seq_no2 := fd_endt_seq_no ();
      vv_item_no2 := fd_item_no ();
      vv_peril_cd2 := fd_peril_cd ();
      vv_dist_no2 := fd_dist_no ();
      vv_dist_seq_no2 := fd_dist_seq_no ();
      vv_share_cd2 := fd_share_cd ();
      vv_zone_type2 := fd_zone_type ();
      vv_eq_zone_type2 := fd_eq_zone_type ();
      vv_share_tsi_amt2 := fd_share_tsi_amt ();
      vv_share_prem_amt2 := fd_dist_prem ();

      SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
             a.pol_seq_no, a.renew_no, a.endt_seq_no, a.dist_no,
             a.dist_seq_no, a.poldist_dist_flag, a.poldist_acct_ent_date,
             a.poldist_acct_neg_date, a.poldist_eff_date, a.issue_date,
             a.polbasic_eff_date, a.booking_mth, a.booking_year,
             a.polbasic_acct_ent_date, a.spld_acct_ent_date, a.item_grp,
             a.takeup_seq_no, a.item_no, a.peril_cd, a.zone_type,
             a.eq_zone_type, a.share_cd,
             (NVL (a.dist_tsi, 0) * NVL (a.currency_rt, 1)
             ) tsi_share,
             (NVL (a.dist_prem, 0) * NVL (a.currency_rt, 1)) prem_share,
             p_zone_fromto_dtl.get_redist_date (a.policy_id,
                                                a.item_grp,
                                                a.takeup_seq_no
                                               ) redist_date,
             p_zone_fromto_dtl.get_max_redist_dist_no (a.policy_id,
                                                       a.item_grp,
                                                       a.takeup_seq_no,
                                                       p_dt_type,
                                                       p_from,
                                                       p_to
                                                      ) redist_max_dist_no
      BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_issue_yy,
             vv_pol_seq_no, vv_renew_no, vv_endt_seq_no, vv_dist_no,
             vv_dist_seq_no, vv_dist_flag, vv_dist_acct_ent_date,
             vv_dist_acct_neg_date, vv_dist_eff_date, vv_gp_issue_date,
             vv_gp_eff_date, vv_gp_booking_mth, vv_gp_booking_year,
             vv_gp_acct_ent_date, vv_gp_spld_acct_ent_date, vv_item_grp,
             vv_takeup_seq_no, vv_item_no, vv_peril_cd, vv_zone_type,
             vv_eq_zone_type, vv_share_cd,
             vv_share_tsi_amt,
             vv_share_prem_amt,
             vv_redist_date,
             vv_redist_max_dist_no
        FROM giuw_gipi_firestat_vw a
       WHERE 1 = 1
         AND a.endt_seq_no > 0
         AND a.zone_type = p_type
         AND EXISTS (
                SELECT 1
                  FROM gipi_firestat_extract_dtl b
                 WHERE b.user_id = p_user_id
                   AND b.zone_type = p_type
                   AND b.as_of_sw = 'N'
                   AND b.line_cd = a.line_cd
                   AND b.subline_cd = a.subline_cd
                   AND b.iss_cd = a.iss_cd
                   AND b.issue_yy = a.issue_yy
                   AND b.pol_seq_no = a.pol_seq_no
                   AND b.renew_no = a.renew_no
                   AND b.endt_seq_no = 0)
         AND EXISTS (SELECT 1
                       FROM giuw_pol_dist x
                      WHERE x.policy_id = a.policy_id AND x.dist_flag = '5')
         AND a.iss_cd <> DECODE (p_bus_cd, 1, v_ri_cd, 'XXXXXX')
         AND a.iss_cd = DECODE (p_bus_cd, 2, v_ri_cd, a.iss_cd)
         AND (   NVL (p_inc_exp, 'N') = 'Y'
              OR TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                               TRUNC (SYSDATE)
             )
         AND (p_dt_type = 'AD' OR a.pol_flag IN ('1', '2', '3', 'X'))
         AND (   p_dt_type = 'AD'
              OR (p_dt_type IN ('ID', 'BD') AND a.poldist_dist_flag = '3')
              OR (p_dt_type = 'ED' AND a.poldist_dist_flag IN ('3', '5'))
             )
         AND a.peril_type =
                 DECODE (p_peril_type,
                         'A', 'A',
                         'B', 'B',
                         'AB', a.peril_type
                        )
         AND a.zone_type = p_type
         AND (   p_inc_endt = 'Y'
              OR (TRUNC (a.issue_date) BETWEEN p_from AND p_to)
              OR DECODE (p_dt_type, 'ID', 0, 1) = 1
             )
         AND (   p_inc_endt = 'Y'
              OR (TRUNC (a.polbasic_eff_date) BETWEEN p_from AND p_to)
              OR DECODE (p_dt_type, 'ED', 0, 1) = 1
             )
         AND (   p_inc_endt = 'Y'
              OR DECODE (p_dt_type, 'BD', 0, 1) = 1
              OR (    (a.booking_mth IS NOT NULL
                       AND a.booking_year IS NOT NULL
                      )
                  AND LAST_DAY (TO_DATE (   a.booking_mth
                                         || ','
                                         || TO_CHAR (a.booking_year),
                                         'FMMONTH,YYYY'
                                        )
                               ) BETWEEN LAST_DAY (p_from) AND LAST_DAY (p_to)
                 )
             )
         AND (   p_inc_endt = 'Y'
              OR (   TRUNC (a.polbasic_acct_ent_date) BETWEEN p_from AND p_to
                  OR (    (TRUNC (a.spld_acct_ent_date) BETWEEN p_from AND p_to
                          )
                      AND p_dt_type = 'AD'
                     )
                 )
              OR DECODE (p_dt_type, 'AD', 0, 1) = 1
             );

      IF vv_policy_id.EXISTS (1)
      THEN
         v_cnt := 0;

         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            BEGIN
               v_multiplier := 1;

               IF p_dt_type = 'AD'
               THEN
                  IF     TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                 AND p_to
                     AND TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                 AND p_to
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (vv_dist_acct_ent_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (vv_dist_acct_neg_date (idx)) BETWEEN p_from
                                                                AND p_to
                  THEN
                     v_multiplier := -1;
                  END IF;

                  vv_share_tsi_amt (idx) :=
                                          vv_share_tsi_amt (idx)
                                          * v_multiplier;
                  vv_share_prem_amt (idx) :=
                                         vv_share_prem_amt (idx)
                                         * v_multiplier;
               END IF;

               v_display_rec := 1;

               IF p_dt_type IN ('BD', 'ID') AND vv_dist_flag (idx) = '5'
               THEN
                  v_display_rec := 0;
               ELSIF     p_dt_type = 'ED' THEN
                  IF TRUNC (p_to) < TRUNC (vv_redist_date (idx))
                     AND vv_dist_flag (idx) = '5'
                  THEN
                        v_display_rec := 1;
                  ELSIF TRUNC (p_to) >= TRUNC (vv_redist_date (idx))
                     AND vv_dist_flag (idx) = '5'
                  THEN
                        v_display_rec := 0;
                  ELSIF TRUNC (p_to) <= TRUNC (vv_redist_date (idx))
                     AND vv_dist_flag (idx) <> '5'
                  THEN
                        v_display_rec := 0;        
                  END IF;
               END IF;

               IF v_display_rec = 1
               THEN
                  v_cnt := v_cnt + 1;
                  vv_policy_id2.EXTEND (1);
                  vv_line_cd2.EXTEND (1);
                  vv_subline_cd2.EXTEND (1);
                  vv_iss_cd2.EXTEND (1);
                  vv_issue_yy2.EXTEND (1);
                  vv_pol_seq_no2.EXTEND (1);
                  vv_renew_no2.EXTEND (1);
                  vv_endt_seq_no2.EXTEND (1);
                  vv_item_no2.EXTEND (1);
                  vv_peril_cd2.EXTEND (1);
                  vv_dist_no2.EXTEND (1);
                  vv_dist_seq_no2.EXTEND (1);
                  vv_share_cd2.EXTEND (1);
                  vv_zone_type2.EXTEND (1);
                  vv_eq_zone_type2.EXTEND (1);
                  vv_share_prem_amt2.EXTEND (1);
                  vv_share_tsi_amt2.EXTEND (1);
                  vv_policy_id2 (v_cnt) := vv_policy_id (idx);
                  vv_line_cd2 (v_cnt) := vv_line_cd (idx);
                  vv_subline_cd2 (v_cnt) := vv_subline_cd (idx);
                  vv_iss_cd2 (v_cnt) := vv_iss_cd (idx);
                  vv_issue_yy2 (v_cnt) := vv_issue_yy (idx);
                  vv_pol_seq_no2 (v_cnt) := vv_pol_seq_no (idx);
                  vv_renew_no2 (v_cnt) := vv_renew_no (idx);
                  vv_endt_seq_no2 (v_cnt) := vv_endt_seq_no (idx);
                  vv_item_no2 (v_cnt) := vv_item_no (idx);
                  vv_peril_cd2 (v_cnt) := vv_peril_cd (idx);
                  vv_dist_no2 (v_cnt) := vv_dist_no (idx);
                  vv_dist_seq_no2 (v_cnt) := vv_dist_seq_no (idx);
                  vv_share_cd2 (v_cnt) := vv_share_cd (idx);
                  vv_zone_type2 (v_cnt) := vv_zone_type (idx);
                  vv_eq_zone_type2 (v_cnt) := vv_eq_zone_type (idx);
                  vv_share_prem_amt2 (v_cnt) := vv_share_prem_amt (idx);
                  -- GET MULTIPLIER FOR TSI OF REDIST
                  v_tsi_multiplier := 1;

                  IF p_dt_type = 'ED'
                  THEN
                     IF     TRUNC (p_to) < TRUNC (vv_redist_date (idx))
                        AND vv_dist_flag (idx) = '5'
                     THEN
                        v_tsi_multiplier := 1;
                     ELSIF     TRUNC (p_to) >= TRUNC (vv_redist_date (idx))
                           AND vv_dist_flag (idx) = '5'
                     THEN
                        v_tsi_multiplier := 0;
                     ELSIF     vv_dist_flag (idx) <> '5'
                           AND vv_dist_no (idx) <> vv_redist_max_dist_no (idx)
                     THEN
                        v_tsi_multiplier := 0;
                     END IF;
                  ELSIF p_dt_type IN ('ID', 'BD')
                  THEN
                     IF     vv_dist_flag (idx) <> '5'
                        AND vv_dist_no (idx) <> vv_redist_max_dist_no (idx)
                     THEN
                        v_tsi_multiplier := 0;
                     END IF;
                  ELSIF p_dt_type = 'AD'
                  THEN
                     IF     vv_dist_flag (idx) <> '5'
                        AND vv_dist_no (idx) <> vv_redist_max_dist_no (idx)
                     THEN
                        v_tsi_multiplier := 0;
                     END IF;
                  END IF;

                  vv_share_tsi_amt2 (v_cnt) :=
                                      vv_share_tsi_amt (idx)
                                      * v_tsi_multiplier;
               END IF;
            END;
         END LOOP;
      END IF;

      IF SQL%FOUND
      THEN
         FORALL rec IN vv_policy_id2.FIRST .. vv_policy_id2.LAST
            INSERT INTO gipi_firestat_extract_dtl
                        (policy_id, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_seq_no, as_of_date,
                         as_of_sw, item_no, peril_cd,
                         dist_no, dist_seq_no,
                         share_cd, zone_type,
                         eq_zone_type, extract_dt, date_from, date_to,
                         share_prem_amt, share_tsi_amt,
                         user_id, param_date, inc_expired, inc_endt,
                         inc_null_zone, param_iss_cd, param_peril
                        )
                 VALUES (vv_policy_id2 (rec), vv_line_cd2 (rec),
                         vv_subline_cd2 (rec), vv_iss_cd2 (rec),
                         vv_issue_yy2 (rec), vv_pol_seq_no2 (rec),
                         vv_renew_no2 (rec), vv_endt_seq_no2 (rec), NULL,
                         'N', vv_item_no2 (rec), vv_peril_cd2 (rec),
                         vv_dist_no2 (rec), vv_dist_seq_no2 (rec),
                         vv_share_cd2 (rec), vv_zone_type2 (rec),
                         vv_eq_zone_type2 (rec), SYSDATE, p_from, p_to,
                         vv_share_prem_amt2 (rec), vv_share_tsi_amt2 (rec),
                         p_user_id, p_dt_type, p_inc_exp, p_inc_endt,
                         p_zone, p_bus_cd, p_peril_type
                        );
      END IF;

      COMMIT;
       /* ================================================================================
      **   Update Item Information - Non-Affecting Basic Info
      ** ===============================================================================*/
      p_zone_fromto_dtl.update_non_affecting_info (p_from,
                                                   p_to,
                                                   p_dt_type,
                                                   p_bus_cd,
                                                   p_zone,
                                                   p_type,
                                                   p_inc_endt,
                                                   p_inc_exp,
                                                   p_peril_type,
                                                   p_user_id
                                                  );

         /* ================================================================================
      **   IF INCLUDE NULL ZONE IS NOT TAGGED, REMOVE RECORDS WITH NULL ZONE
      ** ===============================================================================*/
      IF p_zone <> 'ALL'
      THEN
         DELETE FROM gipi_firestat_extract_dtl xy
               WHERE xy.user_id = p_user_id
                 AND xy.zone_type = p_type
                 AND xy.as_of_sw = 'N'
                 AND xy.zone_no IS NULL;
      END IF;

      COMMIT;
   END extract2;
END;
/


