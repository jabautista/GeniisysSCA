CREATE OR REPLACE PACKAGE BODY CPI.P_Zone_Fromto AS
 
  /*  THIS FUNCTION CHECKS IF THE ACCT_ENT_DATE, EFF_DATE, ISSUE_DATE OR BOOKING DATE
      OF THE POLICY IS WITHIN THE GIVEN DATE RANGE
   revised by bdarusin, 11222002,
   if extract is by acct_ent_date, include spoiled policies but
   check the spld_acct_ent_date*/
   
   /* Modified by :  Aaron
  ** Modified on :  October 23, 2008 
  ** Remarks     :  Modified to correct the amounts extracted.
  **                Added the following parameters: 
  **           i.  p_inc_endt   --> parameter to determine whether to include endorsements
  **                    beyond the given date of extraction
  **          ii.  p_inc_exp    --> parameter to determine whether to include expired policies or not
  **         iii.  p_peril_type --> parameter to determine the type of peril to be included;
  **                A (allied only) B (basic only ) AB (both)            
  **          iv.   p_risk_cnt  ---> parameter to determine whether count will be per risk('R') or per policy ('P')         
  */
 
  PROCEDURE EXTRACT(
    p_from       IN DATE,
    p_to         IN DATE,
    p_dt_type    IN VARCHAR2,
    p_bus_cd     IN NUMBER,
    p_zone       IN VARCHAR2,
    p_dsp_zone   IN VARCHAR2,
    p_inc_endt   IN VARCHAR2,
    p_inc_exp    IN VARCHAR2,
    p_peril_type IN VARCHAR2,
    p_risk_cnt   IN VARCHAR2, -- aaron included p_inc_endt
    p_user       IN VARCHAR2)  --edgar 03/09/2015
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
    vv_fd_zone2       fd_zone_tab;   -- USED FOR RECORDS NOT EXTRACTED; 2ND SELECT
    vv_share_cd2      share_cd_tab;  -- USED FOR RECORDS NOT EXTRACTED; 2ND SELECT
    v_ri_cd           GIPI_POLBASIC.iss_cd%TYPE;
    vv_rownum    NUMBER(3);
  
  BEGIN
 
 DELETE
      FROM GIPI_FIRESTAT_EXTRACT
     WHERE as_of_sw = 'N'
       AND user_id = /*USER*/p_user; --edgar 03/09/2015
    COMMIT;
    v_ri_cd := Giisp.v('ISS_CD_RI');
    /* START EXTRACTING RECORDS HERE AND INSERT IN GIPI_FIRESTAT_EXTRACT */
    
 
 /*  This part will summarize the table gipi_firestat_extract_dtl (aaron) */  
 
 SELECT p_zone_fromto.risk_count(zone_no,share_cd,p_dsp_zone, p_risk_cnt, p_user), --edgar 03/09/2015
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
  WHERE user_id = /*USER*/p_user --edgar 03/09/2015
    AND NVL(as_of_sw,'N') = 'N'
  GROUP BY share_cd, zone_no;
 
 IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_fd_zone.FIRST..vv_fd_zone.LAST
         INSERT INTO GIPI_FIRESTAT_EXTRACT
           (extract_dt,                 zone_type,                  zone_no,
            share_cd,                   no_of_risk,                 share_tsi_amt,
            share_prem_amt,             tariff_cd,                  as_of_sw,
            date_from,                  date_to,                    user_id)
         VALUES
           (SYSDATE,                    p_dsp_zone,                          NVL(vv_fd_zone(cnt),0),
            vv_share_cd(cnt),           NVL(vv_no_of_risk(cnt),0),  NVL(vv_tsi(cnt),0),
            NVL(vv_prem(cnt),0),        '7',                        'N',
            p_from,                     p_to,                       /*USER*/p_user);--edgar 03/09/2015
    END IF;
 
 COMMIT;
 /*
 SELECT DISTINCT
      A.flood_zone,
           b.share_cd
      BULK COLLECT INTO
       vv_fd_zone2,
           vv_share_cd2
      FROM GIIS_FLOOD_ZONE   A,
           GIIS_DIST_SHARE   b
     WHERE NOT EXISTS(SELECT 'X'
                        FROM GIPI_FIRESTAT_EXTRACT C
                       WHERE C.user_id  = USER
                         AND C.as_of_sw = 'N'
                         AND C.zone_no     = A.flood_zone
                         AND C.share_cd    = b.share_cd
                         AND TRUNC(C.extract_dt) >= TO_DATE('1','J'));

    IF SQL%FOUND THEN
       FORALL cnt2 IN vv_fd_zone2.FIRST..vv_fd_zone2.LAST
         INSERT INTO GIPI_FIRESTAT_EXTRACT
           (extract_dt,         zone_type,         zone_no,
            share_cd,           no_of_risk,        share_tsi_amt,
            share_prem_amt,     tariff_cd,         as_of_sw,
            date_from,          date_to,           user_id)
         VALUES
       (SYSDATE,             1,                 vv_fd_zone2(cnt2),
        vv_share_cd2(cnt2),   0,                 0.00,
           0.00,                '7',               'N',
           p_from,              p_to,              USER);
    END IF;
    COMMIT;
*/
  
  END;

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
    
FUNCTION risk_count(
    p_fi_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_type IN VARCHAR2,
 p_risk_cnt IN VARCHAR2,
 p_user     IN VARCHAR2) --edgar 03/09/2015
 RETURN NUMBER IS
    v_cnt NUMBER;
 BEGIN
 
 
 IF p_risk_cnt = 'P' THEN  -- risk count will be per policy  (aaron) 
 
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
     AND DECODE(p_type, '1', NVL (c.flood_zone, '@@@'), '2',NVL(c.typhoon_zone,'@@@') ,'3',NVL(c.eq_zone,'@@@'),'5', NVL(NVL(c.typhoon_zone,c.flood_zone),'@@@'),'@@@') = NVL (p_fi_zone, '@@@')
     AND b.user_id = /*USER*/p_user --edgar 03/09/2015
  AND b.as_of_sw = 'N'
   GROUP BY A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no, A.renew_no; 
  
 ELSIF p_risk_cnt = 'R' THEN -- risk count will be per policy  (aaron) 
   
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
     AND DECODE(p_type, '1', NVL (c.flood_zone, '@@@'), '2',NVL(c.typhoon_zone,'@@@') ,'3',NVL(c.eq_zone,'@@@'),'5', NVL(NVL(c.typhoon_zone,c.flood_zone),'@@@'),'@@@') = NVL (p_fi_zone, '@@@')
     AND b.user_id = /*USER*/p_user --edgar 03/09/2015
  AND b.as_of_sw = 'N'
   GROUP BY c.block_id||NVL(c.risk_cd,'@@@'); 
 END IF;
 
 RETURN(NVL(v_cnt,0));

 END;
 
 

END;
/


