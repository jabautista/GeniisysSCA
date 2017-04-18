--DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_DTL; -- benjo 06.02.2015 commented out to avoid ORA-04043

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation_Dtl(p_from_date DATE, p_to_date DATE)
  AS
    TYPE tab_region_cd            IS TABLE OF GIXX_RECAPITULATION_DTL.region_cd%TYPE;
    TYPE tab_ind_grp_cd           IS TABLE OF GIXX_RECAPITULATION_DTL.ind_grp_cd%TYPE;
    TYPE tab_line_cd              IS TABLE OF GIXX_RECAPITULATION_DTL.line_cd%TYPE;
    TYPE tab_policy_id            IS TABLE OF GIXX_RECAPITULATION_DTL.policy_id%TYPE;
    TYPE tab_premium_amt          IS TABLE OF GIXX_RECAPITULATION_DTL.premium_amt%TYPE;
    TYPE tab_assd_no              IS TABLE OF GIIS_ASSURED.assd_no%TYPE;
    v_region_cd                   tab_region_cd;
    v_ind_grp_cd                  tab_ind_grp_cd;
    v_line_cd                     tab_line_cd;
    v_policy_id                   tab_policy_id;
    v_premium_amt                 tab_premium_amt;
    v_todate                      DATE;
    v_fromdate                    DATE;
    v_assd_no                     tab_assd_no;
    v_micro_sw                    giis_subline.micro_sw%TYPE;
BEGIN
  /* Modified by Grace 05272004
  ** Added the from-to date in the extraction
  */
  DELETE FROM GIXX_RECAPITULATION_DTL;
  COMMIT;
  
  v_fromdate := p_from_date;--TO_DATE('01-JAN-'||p_year);
  v_todate   := p_to_date;--TO_DATE('31-DEC-'||p_year);
  
  SELECT c.assd_no,
         g.region_cd,
         h.ind_grp_cd,
         a.line_cd,
         SUM(DECODE((SIGN(v_fromdate - a.acct_ent_date) * 4)
             + SIGN(NVL(a.spld_acct_ent_date, v_todate+60) - v_todate),
             1, 1,
            -3, 1,
             3,-1,
             4,-1, 0) * (NVL(b.prem_amt,0) * b.currency_rt)) premium_amt,
         a.policy_id
    BULK COLLECT INTO
         v_assd_no,
         v_region_cd,
         v_ind_grp_cd,
         v_line_cd,
         v_premium_amt,
         v_policy_id
    FROM GIPI_ITEM           b,
         GIIS_REGION         g,
         GIPI_PARLIST        d,
         GIIS_ASSURED        c,
         GIIS_INDUSTRY       f,
         GIIS_INDUSTRY_GROUP h,
         GIPI_POLBASIC       a,
         GIIS_SUBLINE        e,   -- Added by Wilmar 04.07.2015
         GIIS_ASSURED_GROUP  i --Dren 07.05.2016 SR-5336     
   WHERE 1=1
     AND c.assd_no = i.assd_no (+) --Dren 07.05.2016 SR-5336     
     AND i.group_cd IS NULL --Dren 07.05.2016 SR-5336        
  --LINK GIPI_POLBASIC AND GIPI_ITEM
     AND a.policy_id    = b.policy_id
  --LINK GIPI_ITEM AND GIIS_REGION
     --AND b.region_cd = g.region_cd --Dren 07.05.2016 SR-5336
     AND g.region_cd = NVL (b.region_cd, a.region_cd) --Dren 07.05.2016 SR-5336
  --LINK GIPI_POLBASIC AND GIPI_PARLIST
     AND a.par_id       = d.par_id
  --LINK GIPI_PARLIST AND GIIS_ASSURED
     AND d.assd_no      = c.assd_no
  --LINK GIIS_ASSURED AND GIIS_INDUSTRY
     AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
  --LINK GIIS_INDUSTRY AND GIIS_INDUSTRY_GRP
     AND f.ind_grp_cd   = h.ind_grp_cd
     AND a.iss_cd != Giisp.v('ISS_CD_RI')
  /* jhing 02.23.2013 added condition to add security rights ; */
     AND a.cred_branch != Giisp.v('ISS_CD_RI') 
  /* benjo 06.01.2015 commented out and replaced with code below for optimization: GENQA AFPGEN_IMPLEM SR 4150
  AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1 
    OR check_user_per_iss_cd (a.line_cd, a.cred_branch , 'GIPIS203') = 1 ) */
   /*AND EXISTS (SELECT 'X'
                  FROM TABLE(security_access.get_branch_line('UW', 'GIPIS203', NVL(giis_users_pkg.app_user, USER)))
                 WHERE branch_cd = NVL(a.cred_branch, a.iss_cd)
                   AND line_cd = a.line_cd)*/   --Dren 07.05.2016 SR-5336         
     AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1
           or check_user_per_iss_cd(a.line_cd, a.cred_branch, 'GIPIS203') = 1 )
     AND ((TRUNC(a.acct_ent_date) >= v_fromdate
           AND TRUNC(a.acct_ent_date) <= v_todate)
           OR(TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= v_fromdate
           AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= v_todate)) --Dren 07.05.2016 SR-5336                        
 -- LINK GIIS_SUBLINE
     AND a.line_cd = e.line_cd
     AND a.subline_cd = e.subline_cd
     AND (e.micro_sw <> 'Y' OR e.micro_sw IS NULL)
    /* Wilmar 04.07.2015 end added code */
  GROUP BY g.region_cd, h.ind_grp_cd, a.line_cd, a.policy_id, c.assd_no;
  
  IF SQL%FOUND THEN
      FOR cnt IN  v_region_cd.FIRST..v_region_cd.LAST
      
      LOOP
          INSERT INTO GIXX_RECAPITULATION_DTL
                      (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, premium_amt)
               VALUES (v_assd_no(cnt),v_region_cd(cnt), v_ind_grp_cd(cnt), v_line_cd(cnt), v_policy_id(cnt), v_premium_amt(cnt));
      END LOOP;
        
      COMMIT;
  END IF;
  
  --Start of code for micro insurance
  SELECT c.assd_no,
         g.region_cd,
         h.ind_grp_cd,
         a.line_cd,
         SUM(DECODE((SIGN(v_fromdate - a.acct_ent_date) * 4)
             + SIGN(NVL(a.spld_acct_ent_date, v_todate+60) - v_todate),
             1, 1,
            -3, 1,
             3,-1,
             4,-1, 0) * (NVL(b.prem_amt,0) * b.currency_rt)) premium_amt,
         a.policy_id
  BULK COLLECT INTO
         v_assd_no,
         v_region_cd,
         v_ind_grp_cd,
         v_line_cd,
         v_premium_amt,
         v_policy_id
    FROM GIPI_ITEM           b,
         GIIS_REGION         g,
         GIPI_PARLIST        d,
         GIIS_ASSURED        c,
         GIIS_INDUSTRY       f,
         GIIS_INDUSTRY_GROUP h,
         GIPI_POLBASIC       a,
         giis_subline     e
   WHERE 1=1
     AND a.policy_id    = b.policy_id
     --AND b.region_cd = g.region_cd
     AND g.region_cd = NVL (b.region_cd, a.region_cd)
     AND a.par_id       = d.par_id
     AND d.assd_no      = c.assd_no
     AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
     AND f.ind_grp_cd   = h.ind_grp_cd
     AND a.iss_cd != Giisp.v('ISS_CD_RI')
     AND a.cred_branch != Giisp.v('ISS_CD_RI')
     AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1 
           OR check_user_per_iss_cd (a.line_cd, a.cred_branch , 'GIPIS203') = 1 )
     AND ((TRUNC(a.acct_ent_date) >= v_fromdate
           AND TRUNC(a.acct_ent_date) <= v_todate)
           OR(TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= v_fromdate
           AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= v_todate))
     AND a.line_cd = e.line_cd
     AND a.subline_cd = e.subline_cd
     AND e.micro_sw = 'Y'
  GROUP BY g.region_cd, h.ind_grp_cd, a.line_cd, a.policy_id, c.assd_no;
  
  IF SQL%FOUND THEN
      FOR cnt IN  v_region_cd.FIRST..v_region_cd.LAST
      
      LOOP
      INSERT INTO GIXX_RECAPITULATION_DTL
                  (assd_no,region_cd, ind_grp_cd, line_cd, policy_id, premium_amt)
           VALUES (v_assd_no(cnt), v_region_cd(cnt), 0, v_line_cd(cnt), v_policy_id(cnt), v_premium_amt(cnt));
      END LOOP;
      
      COMMIT;
  END IF;
  /*wilmar 03.30.2015 end added code*/ 
END;
/