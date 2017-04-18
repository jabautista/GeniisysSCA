CREATE OR REPLACE PACKAGE BODY CPI.P_BUS_CONSERVATION_DTL_WEB AS
  
 
  PROCEDURE get_data(
    p_line_cd     IN VARCHAR2,
    p_subline_cd  IN VARCHAR2,
    p_iss_cd      IN VARCHAR2,
    p_intm_no     IN NUMBER,
 p_from_date   IN DATE,
    p_to_date     IN DATE,
 p_del_table   IN VARCHAR2,
 p_inc_package IN VARCHAR2 DEFAULT 'Y',
 p_cred_cd     IN VARCHAR2,   --added by rose b.(cred_cd and  intm_type)08072008--
 p_intm_type   IN VARCHAR2,
 p_user_id  IN VARCHAR2)
 /* p_inc_package VALUES
 ** 'Y' = extracts package MAIN policies. and sets package SUBPOLICIES as child record
 **     = default value for diff lines
 **     = mandatory value if LINE_CD = 'PK' and ALL LINES
 ** 'X' = extracts package SUBPOLICIES as though it is treated as SEPERATE LINE. NO MAIN package policy is extracted here
 **     = value if LINE_CD <> 'PK' and check box tagged to include package for extraction . .
 ** 'N' = only NON-PACKAGE policies are to be extracted
 */
  AS
    TYPE line_tab        IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
 TYPE subline_tab   IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
 TYPE iss_tab        IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
 TYPE issue_yy_tab    IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
 TYPE pol_seq_no_tab  IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
 TYPE renew_tab      IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
 TYPE policy_tab      IS TABLE OF GIEX_REN_RATIO_DTL.policy_id%TYPE;
 TYPE policy_tab_pck  IS TABLE OF GIEX_REN_RATIO_DTL.pack_policy_id%TYPE; 
 TYPE prem_tab      IS TABLE OF GIEX_REN_RATIO_DTL.prem_amt%TYPE;
 TYPE assd_tab     IS TABLE OF GIEX_REN_RATIO_DTL.assd_no%TYPE;
 TYPE intm_tab      IS TABLE OF GIEX_REN_RATIO_DTL.intm_no%TYPE;
 TYPE exp_month_tab  IS TABLE OF GIEX_REN_RATIO_DTL.MONTH%TYPE;
 TYPE exp_year_tab  IS TABLE OF GIEX_REN_RATIO_DTL.YEAR%TYPE;
 TYPE renewal_tab  IS TABLE OF GIEX_REN_RATIO_DTL.renewal_tag%TYPE;
 TYPE region_tab   IS TABLE OF GIEX_REN_RATIO_DTL.region_cd%TYPE;
 TYPE pol_flag_tab  IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
 TYPE renew_prem_tab  IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
 vv_line_cd   line_tab;
 vv_subline_cd  subline_tab;
 vv_iss_cd   iss_tab;
 vv_issue_yy   issue_yy_tab;
 vv_pol_seq_no  pol_seq_no_tab;
 vv_renew_no   renew_tab;
 vv_policy_id  policy_tab;
 vv_policy_id_pck policy_tab_pck; 
 vv_prem_amt      prem_tab;
 vv_assd_no   assd_tab;
 vv_intm_no   intm_tab;
 vv_exp_month  exp_month_tab;
 vv_exp_year   exp_year_tab;
 vv_renewal_tag   renewal_tab;
 vv_region_cd  region_tab;
    vv_renew_prem    renew_prem_tab;
 v_ri_cd       GIPI_POLBASIC.iss_cd%TYPE;
 v_count    NUMBER;
 vv_expiry_year  exp_year_tab;
 vv_expiry_month  exp_month_tab;
 vv_pol_flag      pol_flag_tab ;
  BEGIN
    v_ri_cd := Giisp.v('ISS_CD_RI');
 IF v_ri_cd IS NULL THEN
       RAISE_APPLICATION_ERROR(2220,INITCAP('RI CODE HAS NOT BEEN SET UP IN GIIS_PARAMETERS.'));
    END IF;
 IF p_del_table = 'Y' THEN  --Y = delete old records of giex_ren_ratio_dtl
                 --N = additional records for giex_ren_ratio_dtl
    DELETE FROM GIEX_REN_RATIO_DTL
         WHERE user_id = p_user_id;
      COMMIT;
    DELETE FROM EXPIRY_POLBASIC
         WHERE user_id = p_user_id;
 ELSE
       DELETE FROM EXPIRY_POLBASIC_RETRO
         WHERE user_id = p_user_id;
 END IF;    
 /* getting template for list of expired policy */
 SELECT /*+ INDEX (x POLBASIC_U1) */ DISTINCT
        X.line_cd,
     X.subline_cd,
     X.iss_cd,
     X.issue_yy,
     X.pol_seq_no,
     X.renew_no,
     TO_CHAR(X.expiry_date,'YYYY') expiry_year,
     TO_CHAR(X.expiry_date,'MM') expiry_month
    BULK COLLECT INTO
        vv_line_cd,
     vv_subline_cd,
     vv_iss_cd,
     vv_issue_yy,
     vv_pol_seq_no,
     vv_renew_no,
     vv_expiry_year,
     vv_expiry_month
   FROM GIPI_POLBASIC X
  WHERE TRUNC(X.expiry_date) BETWEEN p_from_date AND p_to_date--vj 042407
    AND DECODE(p_inc_package, 'N', NVL(X.pack_policy_id,0), 1) = DECODE(p_inc_package, 'N', 0, 1) 
    AND X.iss_cd <> v_ri_cd
    AND endt_seq_no = (SELECT /*+ INDEX (a POLBASIC_U1) */ MAX(endt_seq_no) endt_seq_no
                         FROM GIPI_POLBASIC A
                           WHERE A.line_cd    = X.line_cd
                             AND A.subline_cd = X.subline_cd
                             AND A.iss_cd     = X.iss_cd
                             AND A.issue_yy   = X.issue_yy
                             AND A.pol_seq_no = X.pol_seq_no
                             AND A.renew_no   = X.renew_no)
  --commented by Jerome Sept 25, 2006 - for optimization, replaced with subquery above - Get_Endt_Seq_No(line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no);
  --  AND CHECK_USER_PER_ISS_CD2(x.line_cd, x.iss_cd, 'GIEXS009', p_user_id) = 1; --added by Daniel Marasigan 07.11.2016 SR 22330 replaced by codes below by pjsantos 10/24/2016 for optimization, GENQA 5795
     AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('UW', 'GIEXS009', p_user_id))
                                WHERE branch_cd = x.iss_cd AND line_cd = x.line_cd);
  IF NOT SQL%NOTFOUND THEN
    IF p_del_table = 'Y' THEN /* Y = delete old records of giex_ren_ratio_dtl
                 N = additional records for giex_ren_ratio_dtl*/ 
    /*DELETE FROM giex_ren_ratio_dtl
         WHERE user_id = USER;
      COMMIT;
    DELETE FROM expiry_polbasic
         WHERE user_id = USER;*/
          FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO EXPIRY_POLBASIC
        (line_cd,      subline_cd,    iss_cd,
      issue_yy,     pol_seq_no,    renew_no,
      expiry_year,       expiry_month,    user_id, last_update)
      VALUES
        (vv_line_cd(cnt),   vv_subline_cd(cnt),   vv_iss_cd(cnt),
      vv_issue_yy(cnt),   vv_pol_seq_no(cnt),   vv_renew_no(cnt),
      vv_expiry_year(cnt), vv_expiry_month(cnt), p_user_id, SYSDATE);
     ELSE
       /*DELETE FROM expiry_polbasic_retro
         WHERE user_id = USER;*/
          FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO EXPIRY_POLBASIC_RETRO
        (line_cd,      subline_cd,    iss_cd,
      issue_yy,     pol_seq_no,    renew_no,
      expiry_year,        expiry_month,    user_id,last_update)
      VALUES
        (vv_line_cd(cnt),       vv_subline_cd(cnt),   vv_iss_cd(cnt),
      vv_issue_yy(cnt),   vv_pol_seq_no(cnt),   vv_renew_no(cnt),
      vv_expiry_year(cnt),   vv_expiry_month(cnt), p_user_id, SYSDATE);
     END IF;
   END IF;
  COMMIT;
  --------------PACKAGE consideration-------------------------------
  SELECT /*+ INDEX (x POLBASIC_U1) */ DISTINCT
        X.line_cd,
     X.subline_cd,
     X.iss_cd,
     X.issue_yy,
     X.pol_seq_no,
     X.renew_no,
     TO_CHAR(X.expiry_date,'YYYY') expiry_year,
     TO_CHAR(X.expiry_date,'MM') expiry_month
    BULK COLLECT INTO
        vv_line_cd,
     vv_subline_cd, 
     vv_iss_cd,
     vv_issue_yy,
     vv_pol_seq_no,
     vv_renew_no,
     vv_expiry_year,
     vv_expiry_month
   FROM GIPI_PACK_POLBASIC X
  WHERE TRUNC(X.expiry_date) BETWEEN p_from_date AND p_to_date--vj 042407 
    AND X.iss_cd <> v_ri_cd
    AND endt_seq_no = (SELECT /*+ INDEX (a POLBASIC_U1) */ MAX(endt_seq_no) endt_seq_no
                         FROM GIPI_PACK_POLBASIC A
                           WHERE A.line_cd    = X.line_cd
                             AND A.subline_cd = X.subline_cd
                             AND A.iss_cd     = X.iss_cd
                             AND A.issue_yy   = X.issue_yy
                             AND A.pol_seq_no = X.pol_seq_no
                             AND A.renew_no   = X.renew_no)
  --commented by Jerome Sept 25, 2006 - for optimization, replaced with subquery above - Get_Endt_Seq_No(line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no);
   --  AND CHECK_USER_PER_ISS_CD2(x.line_cd, x.iss_cd, 'GIEXS009', p_user_id) = 1; --added by Daniel Marasigan 07.11.2016 SR 22330, replaced by code below by pjsantos 10/24/2016 for optimization, GENQA 5795
     AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('UW', 'GIEXS009', p_user_id))
                                WHERE branch_cd = x.iss_cd AND line_cd = x.line_cd);
    
  IF NOT SQL%NOTFOUND THEN
    IF p_del_table = 'Y' THEN /* Y = delete old records of giex_ren_ratio_dtl
                 N = additional records for giex_ren_ratio_dtl*/
    /*DELETE FROM giex_ren_ratio_dtl
         WHERE user_id = USER;
      COMMIT;*/
    /*DELETE FROM expiry_polbasic
         WHERE user_id = USER;*/
          FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO EXPIRY_POLBASIC
        (line_cd,      subline_cd,    iss_cd,
      issue_yy,     pol_seq_no,    renew_no,
      expiry_year,       expiry_month,    user_id, last_update)
      VALUES
        (vv_line_cd(cnt),       vv_subline_cd(cnt),   vv_iss_cd(cnt),
      vv_issue_yy(cnt),   vv_pol_seq_no(cnt),   vv_renew_no(cnt),
      vv_expiry_year(cnt),   vv_expiry_month(cnt), p_user_id, SYSDATE);
     ELSE
       /*DELETE FROM expiry_polbasic_retro
         WHERE user_id = USER;*/
          FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO EXPIRY_POLBASIC_RETRO
        (line_cd,      subline_cd,    iss_cd,
      issue_yy,     pol_seq_no,    renew_no,
      expiry_year,        expiry_month,    user_id,last_update)
      VALUES
        (vv_line_cd(cnt),       vv_subline_cd(cnt),   vv_iss_cd(cnt),
      vv_issue_yy(cnt),   vv_pol_seq_no(cnt),   vv_renew_no(cnt),
      vv_expiry_year(cnt),   vv_expiry_month(cnt), p_user_id, SYSDATE);
     END IF;
   END IF;
  COMMIT;
  ----------------------------------------PACKAGE end---------------
    DBMS_OUTPUT.PUT_LINE('START TEMP END:'||TO_CHAR(SYSDATE,'HH:MM:SS'));
 IF p_del_table = 'Y' THEN
    SELECT DISTINCT A.line_cd          line_cd,
          A.subline_cd       subline_cd,
        A.iss_cd           iss_cd,
     A.issue_yy         issue_yy,
     A.pol_seq_no       pol_seq_no,
     A.renew_no         renew_no,
             A.policy_id        policy_id,
     DECODE(p_inc_package, 'X', 0, NVL(A.pack_policy_id,0))   pack_policy_id,
     --      a.prem_amt       prem_amt,
        get_prem(A.line_cd,    A.subline_cd,
              A.iss_cd,     A.issue_yy,
        A.pol_seq_no, A.renew_no) prem_amt,
        c.assd_no    assd_no,
        d.intrmdry_intm_no intm_no,
           get_renew_tag(A.policy_id)  renewal_tag,
        NVL(A.region_cd,e.region_cd),
    --    TO_NUMBER(f.expiry_year),
    --    TO_NUMBER(f.expiry_month),
        /* Modified by pjsantos10/24/2016, for optimization GENQA 5795
        get_expiry_year(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                     A.pol_seq_no, A.renew_no),
           get_expiry_month(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                            A.pol_seq_no, A.renew_no),                            
     get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_prem*/
        (SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_yy,
(SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_mm,
                      a.pol_flag,                     
            get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_no 
    /*pjsantos end*/
        BULK COLLECT INTO
           vv_line_cd,
        vv_subline_cd,
        vv_iss_cd,
     vv_issue_yy,
     vv_pol_seq_no,
     vv_renew_no,
           vv_policy_id,
           vv_policy_id_pck,     
        vv_prem_amt,
        vv_assd_no,
        vv_intm_no,
        vv_renewal_tag,
        vv_region_cd,
        vv_exp_year,
        vv_exp_month,
     vv_pol_flag,
     vv_renew_prem
         FROM GIPI_POLBASIC A,
              GIIS_SUBLINE b,
        GIPI_PARLIST c,
        GIPI_COMM_INVOICE d,
        GIIS_ISSOURCE e,
        EXPIRY_POLBASIC f,
     GIIS_INTERMEDIARY i
        WHERE 1 = 1
       AND A.line_cd     = f.line_cd
          AND A.subline_cd  = f.subline_cd
       AND A.iss_cd      = f.iss_cd
       AND A.issue_yy    = f.issue_yy
       AND A.pol_seq_no  = f.pol_seq_no
       AND A.renew_no    = f.renew_no
       AND f.user_id     = p_user_id
      -- AND a.pol_flag    IN ('1','2','3')
   AND A.pol_flag  NOT  IN ('4','5')
         -- AND a.iss_cd      <> 'RI'
          AND A.endt_seq_no = 0
          AND A.expiry_tag  = 'N'
          AND a.expiry_date <= p_to_date --added by Daniel Marasigan SR 22330
          AND b.op_flag     = 'N'
          AND A.line_cd     = b.line_cd
       AND A.subline_cd  = b.subline_cd
       AND A.par_id      = c.par_id
       AND d.iss_cd  = A.iss_cd
       AND A.iss_cd      = e.iss_cd
       AND d.policy_id   = A.policy_id
       AND A.line_cd     = NVL(DECODE(p_line_cd, NULL, A.line_cd, DECODE(p_inc_package, 'Y', A.line_cd, p_line_cd)),A.line_cd)
    AND b.subline_cd  = NVL(DECODE(p_subline_cd, NULL, b.subline_cd, DECODE(p_inc_package, 'Y', b.subline_cd, p_subline_cd)),b.subline_cd)
    --AND a.line_cd = NVL(p_line_Cd, a.line_cd)
       --AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
       AND A.iss_cd      = NVL(p_iss_cd,A.iss_cd)
--    AND A.iss_cd = NVL(p_cred_cd,DECODE(e.CRED_BR_TAG,'Y',A.iss_cd))--rose b. 08072008
    AND A.cred_branch = NVL(p_cred_cd,a.cred_branch)--vj 032009--
    AND d.intrmdry_intm_no = i.intm_no --rose b. 08072008
       AND d.intrmdry_intm_no = NVL(p_intm_no,d.intrmdry_intm_no)
    AND i.intm_type =  NVL(p_intm_type,i.intm_type); --rose b 08072008
 ELSE
    SELECT A.line_cd          line_cd,
       A.subline_cd       subline_cd,
        A.iss_cd           iss_cd,
        A.issue_yy         issue_yy,
     A.pol_seq_no       pol_seq_no,
     A.renew_no         renew_no,
          A.policy_id        policy_id,
     DECODE(p_inc_package, 'X', 0, NVL(A.pack_policy_id,0))   pack_policy_id,     
     --      a.prem_amt       prem_amt,
        get_prem(A.line_cd,    A.subline_cd,
              A.iss_cd,     A.issue_yy,
        A.pol_seq_no, A.renew_no) prem_amt,
     c.assd_no    assd_no,
     d.intrmdry_intm_no intm_no,
        get_renew_tag(A.policy_id)  renewal_tag,
      NVL(A.region_cd,e.region_cd),
  --    TO_NUMBER(f.expiry_year),
  --    TO_NUMBER(f.expiry_month),
    /* Modified by pjsantos10/24/2016, for optimization GENQA 5795
        get_expiry_year(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                     A.pol_seq_no, A.renew_no),
           get_expiry_month(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                            A.pol_seq_no, A.renew_no),
            get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_prem*/
        (SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_yy,
(SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_mm,
      A.pol_flag,get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_no
   /*pjsantos end*/
   BULK COLLECT INTO
         vv_line_cd,
      vv_subline_cd,
      vv_iss_cd,
         vv_issue_yy,
      vv_pol_seq_no,
      vv_renew_no,
         vv_policy_id,
         vv_policy_id_pck,      
      vv_prem_amt,
      vv_assd_no,
      vv_intm_no,
      vv_renewal_tag,
      vv_region_cd,
      vv_exp_year,
      vv_exp_month,
      vv_pol_flag,
      vv_renew_prem
      FROM GIPI_POLBASIC A,
            GIIS_SUBLINE b,
      GIPI_PARLIST c,
      GIPI_COMM_INVOICE d,
      GIIS_ISSOURCE e,
      EXPIRY_POLBASIC_RETRO f,
      GIIS_INTERMEDIARY i  
      WHERE 1 = 1
     AND A.line_cd     = f.line_cd
        AND A.subline_cd  = f.subline_cd
     AND A.iss_cd      = f.iss_cd
     AND A.issue_yy    = f.issue_yy
     AND A.pol_seq_no  = f.pol_seq_no
     AND A.renew_no    = f.renew_no
     AND f.user_id     = p_user_id
--     AND a.pol_flag IN ('1','2','3')
     AND A.pol_flag  NOT  IN ('4','5')
--        AND a.iss_cd     <> 'RI'
        AND A.endt_seq_no = 0
        AND A.expiry_tag  = 'N'
        AND b.op_flag     = 'N'
        AND A.line_cd     = b.line_cd
     AND A.subline_cd  = b.subline_cd
     AND A.par_id      = c.par_id
     AND d.iss_cd   = A.iss_cd
     AND A.iss_cd      = e.iss_cd
     AND d.policy_id   = A.policy_id
     AND A.line_cd     = NVL(DECODE(p_line_cd, NULL, A.line_cd, DECODE(p_inc_package, 'Y', A.line_cd, p_line_cd)),A.line_cd)
     AND b.subline_cd  = NVL(DECODE(p_subline_cd, NULL, b.subline_cd, DECODE(p_inc_package, 'Y', b.subline_cd, p_subline_cd)),b.subline_cd)
     --AND a.line_cd = NVL(p_line_Cd, a.line_cd)     
     --AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
     AND A.iss_cd      = NVL(p_iss_cd,A.iss_cd)
     AND A.iss_cd = NVL(p_cred_cd,DECODE(e.CRED_BR_TAG,'Y',A.iss_cd))--rose b. 08072008
     AND d.intrmdry_intm_no = i.intm_no --rose 08072008
     AND d.intrmdry_intm_no = NVL(p_intm_no,d.intrmdry_intm_no)
           AND i.intm_type =  NVL(p_intm_type,i.intm_type); --rose b 08072008
     
    END IF;
 IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
    INSERT INTO GIEX_REN_RATIO_DTL
      (line_cd,      subline_cd,    iss_cd,
    issue_yy,            pol_seq_no,         renew_no,
    policy_id,           pack_policy_id,     
    prem_amt,     assd_no,
    intm_no,         MONTH,      YEAR,
    renewal_tag,        user_id,        last_update,
    region_cd,     pol_flag,           prem_renew_amt)
    VALUES
      (vv_line_cd(cnt),   vv_subline_cd(cnt), vv_iss_cd(cnt),
    vv_issue_yy(cnt),    vv_pol_seq_no(cnt), vv_renew_no(cnt),
    vv_policy_id(cnt),   vv_policy_id_pck(cnt),   
    vv_prem_amt(cnt),    vv_assd_no(cnt),
    vv_intm_no(cnt),     vv_exp_month(cnt),  vv_exp_year(cnt)  ,
    vv_renewal_tag(cnt), p_user_id,      SYSDATE,
    vv_region_cd(cnt),   vv_pol_flag(cnt),   vv_renew_prem(cnt));
 END IF;
 COMMIT;
  DBMS_OUTPUT.PUT_LINE('FINISH :'||TO_CHAR(SYSDATE,'HH:MM:SS'));
 ---------------------PACKAGE consideration-------------------------------
 IF p_del_table = 'Y' THEN
    SELECT DISTINCT A.line_cd          line_cd,
          A.subline_cd       subline_cd,
        A.iss_cd           iss_cd,
     A.issue_yy         issue_yy,
     A.pol_seq_no       pol_seq_no,
     A.renew_no         renew_no,
             A.pack_policy_id        policy_id,
             A.pack_policy_id        pack_policy_id,     
     --      a.prem_amt       prem_amt,
        get_prem(A.line_cd,    A.subline_cd,
              A.iss_cd,     A.issue_yy,
        A.pol_seq_no, A.renew_no) prem_amt,
        c.assd_no    assd_no,
        NULL intm_no,--d.intrmdry_intm_no intm_no,
           get_renew_tag(A.pack_policy_id,'Y')  renewal_tag,
        NVL(A.region_cd,e.region_cd),
    --    TO_NUMBER(f.expiry_year),
    --    TO_NUMBER(f.expiry_month),
        /* Modified by pjsantos10/24/2016, for optimization GENQA 5795
        get_expiry_year(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                     A.pol_seq_no, A.renew_no),
           get_expiry_month(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                            A.pol_seq_no, A.renew_no),
           get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_prem*/
        (SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_yy,
(SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_mm,
        A.pol_flag,get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_no
  /*pjsantos end*/
        BULK COLLECT INTO
           vv_line_cd,
        vv_subline_cd,
        vv_iss_cd,
     vv_issue_yy,
     vv_pol_seq_no,
     vv_renew_no,
           vv_policy_id,
           vv_policy_id_pck,     
        vv_prem_amt,
        vv_assd_no,
        vv_intm_no,
        vv_renewal_tag,
        vv_region_cd,
        vv_exp_year,
        vv_exp_month,
     vv_pol_flag,
     vv_renew_prem
         FROM GIPI_PACK_POLBASIC A,
              GIIS_SUBLINE b,
        GIPI_PACK_PARLIST c,
--        gipi_comm_invoice d,
        GIIS_ISSOURCE e,
        EXPIRY_POLBASIC f
        WHERE 1 = 1
       AND A.line_cd     = f.line_cd
          AND A.subline_cd  = f.subline_cd
       AND A.iss_cd      = f.iss_cd
       AND A.issue_yy    = f.issue_yy
       AND A.pol_seq_no  = f.pol_seq_no
       AND A.renew_no    = f.renew_no
       AND f.user_id     = p_user_id
      -- AND a.pol_flag    IN ('1','2','3')
   AND A.pol_flag  NOT  IN ('4','5')
         -- AND a.iss_cd      <> 'RI'
          AND A.endt_seq_no = 0
          AND A.expiry_tag  = 'N'
          AND a.expiry_date <= p_to_date --added by Daniel Marasigan SR 22330
          AND b.op_flag     = 'N'
          AND A.line_cd     = b.line_cd
       AND A.subline_cd  = b.subline_cd
       AND A.pack_par_id      = c.pack_par_id
   --    AND d.iss_cd  = a.iss_cd
       AND A.iss_cd      = e.iss_cd
 --      AND d.policy_id   = a.policy_id
       AND A.line_cd     = NVL(p_line_cd,A.line_cd)
       AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
       AND A.iss_cd      = NVL(p_iss_cd,A.iss_cd)
    AND A.iss_cd = NVL(p_cred_cd,DECODE(e.CRED_BR_TAG,'Y',A.iss_cd));--rose b. 08072008
   --  AND d.intrmdry_intm_no = NVL(p_intm_no,d.intrmdry_intm_no);
          
 ELSE
    SELECT A.line_cd          line_cd,
       A.subline_cd       subline_cd,
        A.iss_cd           iss_cd,
    -- A.iss_cd           cred_cd,
        A.issue_yy         issue_yy,
     A.pol_seq_no       pol_seq_no,
     A.renew_no         renew_no,
          A.pack_policy_id        policy_id,
          A.pack_policy_id        pack_policy_id,     
     --      a.prem_amt       prem_amt,
        get_prem(A.line_cd,    A.subline_cd,
              A.iss_cd,     A.issue_yy,
        A.pol_seq_no, A.renew_no) prem_amt,
     c.assd_no    assd_no,
     NULL intm_no,--d.intrmdry_intm_no intm_no,
        get_renew_tag(A.pack_policy_id,'Y')  renewal_tag,
      NVL(A.region_cd,e.region_cd),
  --    TO_NUMBER(f.expiry_year),
  --    TO_NUMBER(f.expiry_month),
         /* Modified by pjsantos10/24/2016, for optimization GENQA 5795
        get_expiry_year(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                     A.pol_seq_no, A.renew_no),
           get_expiry_month(A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                            A.pol_seq_no, A.renew_no),
         get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_prem*/
        (SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'YYYY')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_yy,
(SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_PACK_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_PACK_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)
UNION
SELECT TO_NUMBER (TO_CHAR (p.expiry_date, 'MM')) expiry_date
  FROM GIPI_POLBASIC p
 WHERE     p.line_cd = a.line_cd
       AND p.subline_cd = a.subline_cd
       AND p.iss_cd = a.iss_cd
       AND p.issue_yy = a.issue_yy
       AND p.pol_seq_no = a.pol_seq_no
       AND p.renew_no = a.renew_no
       AND p.endt_seq_no =
              (SELECT MAX (j.endt_seq_no)
                 FROM GIPI_POLBASIC j
                WHERE     p.line_cd = j.line_cd
                      AND p.subline_cd = j.subline_cd
                      AND p.iss_cd = j.iss_cd
                      AND p.issue_yy = j.issue_yy
                      AND p.pol_seq_no = j.pol_seq_no
                      AND p.renew_no = j.renew_no)) expiry_mm,
      A.pol_flag,get_prem_of_renew(A.line_cd,A.subline_cd,
                       A.iss_cd,A.issue_yy,
           A.pol_seq_no, A.renew_no) renew_no
     /*pjsantos end*/
   BULK COLLECT INTO
         vv_line_cd,
      vv_subline_cd,
      vv_iss_cd,
         vv_issue_yy,
      vv_pol_seq_no,
      vv_renew_no,
         vv_policy_id,
         vv_policy_id_pck,      
      vv_prem_amt,
      vv_assd_no,
      vv_intm_no,
      vv_renewal_tag,
      vv_region_cd,
      vv_exp_year,
      vv_exp_month,
      vv_pol_flag,
      vv_renew_prem
      FROM GIPI_PACK_POLBASIC A,
            GIIS_SUBLINE b,
      GIPI_PACK_PARLIST c,
--      gipi_comm_invoice d,
      GIIS_ISSOURCE e,
      EXPIRY_POLBASIC_RETRO f
      WHERE 1 = 1
     AND A.line_cd     = f.line_cd
        AND A.subline_cd  = f.subline_cd
     AND A.iss_cd      = f.iss_cd
     AND A.issue_yy    = f.issue_yy
     AND A.pol_seq_no  = f.pol_seq_no
     AND A.renew_no    = f.renew_no
     AND f.user_id     = p_user_id
--     AND a.pol_flag IN ('1','2','3')
     AND A.pol_flag  NOT  IN ('4','5')
--        AND a.iss_cd     <> 'RI'
        AND A.endt_seq_no = 0
        AND A.expiry_tag  = 'N'
        AND b.op_flag     = 'N'
        AND A.line_cd     = b.line_cd
     AND A.subline_cd  = b.subline_cd
     AND A.pack_par_id      = c.pack_par_id
 --    AND d.iss_cd   = a.iss_cd
     AND A.iss_cd      = e.iss_cd
  --   AND d.policy_id   = a.policy_id
     AND A.line_cd     = NVL(p_line_cd,A.line_cd)
     AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
     AND A.iss_cd      = NVL(p_iss_cd,A.iss_cd)
     AND A.iss_cd = NVL(p_cred_cd,DECODE(e.CRED_BR_TAG,'Y',A.iss_cd));--rose b. 08072008   
  -- AND d.intrmdry_intm_no = NVL(p_intm_no,d.intrmdry_intm_no);
          
 END IF;
 IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
    INSERT INTO GIEX_REN_RATIO_DTL
      (line_cd,      subline_cd,    iss_cd,
    issue_yy,            pol_seq_no,         renew_no,
    policy_id,           pack_policy_id,     
    prem_amt,     assd_no,
    intm_no,         MONTH,      YEAR,
    renewal_tag,        user_id,        last_update,
    region_cd,     pol_flag,           prem_renew_amt)
    VALUES
      (vv_line_cd(cnt),   vv_subline_cd(cnt), vv_iss_cd(cnt),
    vv_issue_yy(cnt),    vv_pol_seq_no(cnt), vv_renew_no(cnt),
    vv_policy_id(cnt),   vv_policy_id_pck(cnt),
    vv_prem_amt(cnt),    vv_assd_no(cnt),
    vv_intm_no(cnt),     vv_exp_month(cnt),  vv_exp_year(cnt)  ,
    vv_renewal_tag(cnt), p_user_id,      SYSDATE,
    vv_region_cd(cnt),   vv_pol_flag(cnt),   vv_renew_prem(cnt));
 END IF;
 COMMIT;
  DBMS_OUTPUT.PUT_LINE('FINISH :'||TO_CHAR(SYSDATE,'HH:MM:SS'));
 ------------------------------------------------PACKAGE end--------------
 IF p_inc_package = 'Y' THEN
  IF p_line_cd IS NOT NULL THEN 
   DELETE FROM GIEX_REN_RATIO_DTL
         WHERE pack_policy_id = 0
        AND USER_ID = p_user_id;
  END IF;
  DELETE FROM GIEX_REN_RATIO_DTL A
     WHERE NOT EXISTS (SELECT 1
                      FROM GIEX_REN_RATIO_DTL b
               WHERE A.pack_policy_id = b.pack_policy_id
           AND b.policy_id <> A.pack_policy_id)
       AND A.pack_policy_id = A.policy_id
       AND A.pack_policy_id > 0
    AND A.USER_ID = p_user_id; 
 END IF; 
     
 

  
------------UPDATE AMOUNTS portion for PACKAGE-------------------
UPDATE GIEX_REN_RATIO_DTL X
   SET (X.PREM_AMT, X.PREM_RENEW_AMT) = (SELECT SUM(z.PREM_AMT), SUM(z.PREM_RENEW_AMT)
                                           FROM GIEX_REN_RATIO_DTL z
                  WHERE z.policy_id <> z.pack_policy_id
                    AND z.pack_policy_id = X.pack_policy_id
           AND USER_ID = p_user_id)
 WHERE X.pack_policy_id = X.policy_id
   AND X.pack_policy_id > 0
   AND USER_ID = p_user_id; 
 COMMIT;
------------UPDATE AMOUNTS portion for PACKAGE (end)------------------- 
  
  END;
  FUNCTION get_renew_tag(
  /** rollie 24 june 2004
  *** validates if policy is renewed
  **/
   p_policy_id     GIPI_POLBASIC.policy_id%TYPE,
 p_pack_sw       VARCHAR2 DEFAULT 'N')
  RETURN VARCHAR2 AS
    v_renew_tag   VARCHAR2(1):= 'N';
  BEGIN
  --------------PACKAGE consideration------------
    FOR A IN (
   SELECT 'RENEWED'
     FROM GIPI_PACK_POLNREP b
    WHERE b.old_pack_policy_id = p_policy_id
      AND p_pack_sw = 'Y')
 LOOP
   v_renew_tag := 'Y';
 END LOOP;
  --------------PACKAGE end----------------------
    FOR A IN (
   SELECT 'RENEWED'
     FROM GIPI_POLNREP b
    WHERE b.old_policy_id = p_policy_id
      AND p_pack_sw = 'N')
 LOOP
   v_renew_tag := 'Y';
 END LOOP;
 RETURN (v_renew_tag);
  END;
  FUNCTION Check_Date(
  /** rollie 18 Feb 2004
  *** date parameter of the last endorsement of policy
  *** must not be within the date given, else it will
  *** be exluded
  **/
 p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no     GIPI_POLBASIC.renew_no%TYPE,
 p_from_date     DATE,
 p_to_date     DATE)
  RETURN DATE AS
   v_check_date  DATE;
  BEGIN
    --------------------PACKAGE consideration-----------
 FOR A IN (
      SELECT A.expiry_date expiry_date
        FROM GIPI_PACK_POLBASIC A
    WHERE A.line_cd     = p_line_cd
      AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
      AND A.issue_yy    = p_issue_yy
      AND A.pol_seq_no  = p_pol_seq_no
      AND A.renew_no    = p_renew_no
      AND A.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM GIPI_PACK_POLBASIC b
           WHERE A.line_cd     = b.line_cd
             AND A.subline_cd  = b.subline_cd
               AND A.iss_cd      = b.iss_cd
              AND A.issue_yy    = b.issue_yy
              AND A.pol_seq_no  = b.pol_seq_no
              AND A.renew_no    = b.renew_no))
      LOOP
  v_check_date := A.expiry_date;
  EXIT;
      END LOOP;
 -------------------PACKAGE end-------------------------    
 FOR A IN (
      SELECT A.expiry_date expiry_date
        FROM GIPI_POLBASIC A
    WHERE A.line_cd     = p_line_cd
      AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
      AND A.issue_yy    = p_issue_yy
      AND A.pol_seq_no  = p_pol_seq_no
      AND A.renew_no    = p_renew_no
      AND A.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM GIPI_POLBASIC b
           WHERE A.line_cd     = b.line_cd
             AND A.subline_cd  = b.subline_cd
               AND A.iss_cd      = b.iss_cd
              AND A.issue_yy    = b.issue_yy
              AND A.pol_seq_no  = b.pol_seq_no
              AND A.renew_no    = b.renew_no))
      LOOP
  v_check_date := A.expiry_date;
  EXIT;
      END LOOP;
   RETURN v_check_date;
  END;
  FUNCTION get_expiry_year(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
 p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no     GIPI_POLBASIC.renew_no%TYPE)
  RETURN NUMBER AS
   v_year          NUMBER(4):=0;
  BEGIN
    ------------------PACKAGE consideration--------------------
    FOR A IN (
   SELECT TO_NUMBER(TO_CHAR(A.expiry_date,'YYYY')) expiry_date
--     INTO v_year
        FROM GIPI_PACK_POLBASIC A
    WHERE A.line_cd     = p_line_cd
      AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
      AND A.issue_yy    = p_issue_yy
      AND A.pol_seq_no  = p_pol_seq_no
      AND A.renew_no    = p_renew_no
      AND A.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM GIPI_PACK_POLBASIC b
          WHERE A.line_cd     = b.line_cd
            AND A.subline_cd  = b.subline_cd
              AND A.iss_cd      = b.iss_cd
             AND A.issue_yy    = b.issue_yy
             AND A.pol_seq_no  = b.pol_seq_no
             AND A.renew_no    = b.renew_no))
 LOOP
   v_year := A.expiry_date;
   EXIT;
 END LOOP;
 --------------PACKAGE end------------------------------------
    FOR A IN (
   SELECT TO_NUMBER(TO_CHAR(A.expiry_date,'YYYY')) expiry_date
--     INTO v_year
        FROM GIPI_POLBASIC A
    WHERE A.line_cd     = p_line_cd
      AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
      AND A.issue_yy    = p_issue_yy
      AND A.pol_seq_no  = p_pol_seq_no
      AND A.renew_no    = p_renew_no
      AND A.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM GIPI_POLBASIC b
          WHERE A.line_cd     = b.line_cd
            AND A.subline_cd  = b.subline_cd
              AND A.iss_cd      = b.iss_cd
             AND A.issue_yy    = b.issue_yy
             AND A.pol_seq_no  = b.pol_seq_no
             AND A.renew_no    = b.renew_no))
 LOOP
   v_year := A.expiry_date;
   EXIT;
 END LOOP;
    RETURN v_year;
  END;
  FUNCTION get_expiry_month(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
 p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no     GIPI_POLBASIC.renew_no%TYPE)
  RETURN NUMBER AS
   v_month          NUMBER(2):=0;
  BEGIN
    ------------------------PACKAGE consideration-------------------
    FOR A IN (
   SELECT TO_NUMBER(TO_CHAR(A.expiry_date,'MM'))   expiry_date
--        INTO v_year
     FROM GIPI_PACK_POLBASIC A
    WHERE A.line_cd     = p_line_cd
      AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
      AND A.issue_yy    = p_issue_yy
      AND A.pol_seq_no  = p_pol_seq_no
      AND A.renew_no    = p_renew_no
      AND A.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM GIPI_PACK_POLBASIC b
          WHERE A.line_cd     = b.line_cd
            AND A.subline_cd  = b.subline_cd
              AND A.iss_cd      = b.iss_cd
             AND A.issue_yy    = b.issue_yy
             AND A.pol_seq_no  = b.pol_seq_no
             AND A.renew_no    = b.renew_no))
    LOOP
   v_month := A.expiry_date;
   EXIT;
 END LOOP;
 -------------------PACKAGE end----------------------  
    FOR A IN (
   SELECT TO_NUMBER(TO_CHAR(A.expiry_date,'MM'))   expiry_date
--        INTO v_year
     FROM GIPI_POLBASIC A
    WHERE A.line_cd     = p_line_cd
      AND A.subline_cd  = p_subline_cd
       AND A.iss_cd      = p_iss_cd
      AND A.issue_yy    = p_issue_yy
      AND A.pol_seq_no  = p_pol_seq_no
      AND A.renew_no    = p_renew_no
      AND A.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM GIPI_POLBASIC b
          WHERE A.line_cd     = b.line_cd
            AND A.subline_cd  = b.subline_cd
              AND A.iss_cd      = b.iss_cd
             AND A.issue_yy    = b.issue_yy
             AND A.pol_seq_no  = b.pol_seq_no
             AND A.renew_no    = b.renew_no))
    LOOP
   v_month := A.expiry_date;
   EXIT;
 END LOOP;
    RETURN v_month;
  END;
  
 FUNCTION get_prem(
  /** 
  *** get the total sum premium from all its endts...
  **/
 p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no     GIPI_POLBASIC.renew_no%TYPE)
  RETURN NUMBER AS
    v_prem NUMBER(18,2) := 0;
  BEGIN
  ------------------PACKAGE consideration---------------
    SELECT SUM(c.prem_amt)
   INTO v_prem
      FROM GIPI_PACK_POLBASIC c
     WHERE c.line_cd     = p_line_cd
    AND c.subline_cd  = p_subline_cd
    AND c.iss_cd      = p_iss_cd
    AND c.issue_yy    = p_issue_yy
    AND c.pol_seq_no  = p_pol_seq_no
    AND c.renew_no    = p_renew_no
    AND c.pol_flag NOT IN ('4','5');
  ------------------PACKAGE end-------------------------
   SELECT SUM(c.prem_amt)
   INTO v_prem
      FROM GIPI_POLBASIC c
     WHERE c.line_cd     = p_line_cd 
    AND c.subline_cd  = p_subline_cd
    AND c.iss_cd      = p_iss_cd
    AND c.issue_yy    = p_issue_yy
    AND c.pol_seq_no  = p_pol_seq_no
    AND c.renew_no    = p_renew_no
    AND c.pol_flag NOT IN ('4','5');
 RETURN v_prem;
  END;
  
  
  
  FUNCTION get_prem_of_renew(
  /* rollie 21 june 2004
  ** to get the prem of policy if it is renewed
  **/
   p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no      GIPI_POLBASIC.renew_no%TYPE)
  RETURN NUMBER AS
    v_prem_renew NUMBER(18,2) := 0;
  BEGIN
  ------------------PACKAGE consideration---------------
    SELECT SUM(A.prem_amt)
   INTO v_prem_renew
      FROM GIPI_PACK_POLBASIC A
     WHERE A.pack_policy_id IN (SELECT b.new_pack_policy_id
                       FROM GIPI_PACK_POLNREP b, GIPI_PACK_POLBASIC c
                WHERE b.old_pack_policy_id = c.pack_policy_id
         AND c.line_cd     = p_line_cd
         AND c.subline_cd  = p_subline_cd
         AND c.iss_cd      = p_iss_cd
         AND c.issue_yy    = p_issue_yy
         AND c.pol_seq_no  = p_pol_seq_no
         AND c.renew_no    = p_renew_no)
  AND pol_flag NOT IN ('4','5');    --added BY GMI 09/26/06
  ------------------PACKAGE end-------------------------
   SELECT SUM(A.prem_amt)
   INTO v_prem_renew
      FROM GIPI_POLBASIC A
     WHERE A.policy_id IN (SELECT b.new_policy_id
                       FROM GIPI_POLNREP b, GIPI_POLBASIC c
                WHERE b.old_policy_id = c.policy_id
         AND c.line_cd     = p_line_cd
         AND c.subline_cd  = p_subline_cd
         AND c.iss_cd      = p_iss_cd
         AND c.issue_yy    = p_issue_yy
         AND c.pol_seq_no  = p_pol_seq_no
         AND c.renew_no    = p_renew_no)
  AND pol_flag NOT IN ('4','5');    --added BY GMI 09/26/06
 RETURN v_prem_renew;
  END;
  FUNCTION Get_Endt_Seq_No(
    /** rollie 02/18/04
    *** get the latest endorsement number of a policy
    **/
    p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd  GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd      GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy    GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no    GIPI_POLBASIC.renew_no%TYPE)
  RETURN NUMBER AS
    v_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE;
  BEGIN
   -------------------PACKAGE consideration---------------
    FOR A IN (
   SELECT endt_seq_no
        FROM GIPI_PACK_POLBASIC A
       WHERE A.line_cd    = p_line_cd
         AND A.subline_cd = p_subline_cd
         AND A.iss_cd     = p_iss_cd
         AND A.issue_yy   = p_issue_yy
         AND A.pol_seq_no = p_pol_seq_no
         AND A.renew_no   = p_renew_no)
 LOOP
   v_endt_seq_no := A.endt_seq_no;
 END LOOP;
 --------------package end-----------------  
    FOR A IN (
   SELECT endt_seq_no
        FROM GIPI_POLBASIC A
       WHERE A.line_cd    = p_line_cd
         AND A.subline_cd = p_subline_cd
         AND A.iss_cd     = p_iss_cd
         AND A.issue_yy   = p_issue_yy
         AND A.pol_seq_no = p_pol_seq_no
         AND A.renew_no   = p_renew_no)
 LOOP
   v_endt_seq_no := A.endt_seq_no;
 END LOOP;
    RETURN (v_endt_seq_no);
  END;
END;
/


