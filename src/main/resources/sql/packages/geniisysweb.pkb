CREATE OR REPLACE PACKAGE BODY CPI.Geniisysweb AS
FUNCTION Extract_Incept_Date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                              p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                              p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                              p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                              p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                              p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
         p_loss_date   IN GICL_CLAIMS.loss_date%TYPE)
RETURN DATE IS
  v_pol_eff_date      DATE;
  v_incept_date       GIPI_POLBASIC.incept_date%TYPE;
  v_subline_time      VARCHAR2(11);
BEGIN
 -- annabelle 02.03.06
  FOR v IN (SELECT SUBSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MI AM'), INSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'),'/',1, 2)+6) stime,
                   TO_DATE(TO_CHAR(TO_DATE(subline_time,'SSSSS'),'HH:MI AM'),'HH:MI AM') stime2
        FROM GIIS_SUBLINE
        WHERE line_cd    = p_line_cd
          AND subline_cd = p_subline_cd)
  LOOP
    v_subline_time := v.stime;
    EXIT;
  END LOOP;

-- get first the effectivity date of the policy
  FOR A1 IN
    (SELECT incept_date
       FROM GIPI_POLBASIC
      WHERE line_cd    = p_line_cd
        AND subline_cd = p_subline_cd
        AND iss_cd     = p_iss_cd
        AND issue_yy   = p_issue_yy
        AND pol_seq_no = p_pol_seq_no
        AND renew_no   = p_renew_no
        AND pol_flag IN ('1','2','3','X')
        AND NVL(endt_seq_no,0) = 0)
  LOOP
    v_incept_date  := a1.incept_date;
    EXIT;
  END LOOP;
  -- then check and retrieve for any change of incept in case there is
  -- endorsement of incept date
  FOR B1 IN
    (SELECT incept_date, endt_seq_no
       FROM GIPI_POLBASIC
      WHERE line_cd            = p_line_cd
        AND subline_cd         = p_subline_cd
        AND iss_cd             = p_iss_cd
        AND issue_yy           = p_issue_yy
        AND pol_seq_no         = p_pol_seq_no
        AND renew_no           = p_renew_no
        AND pol_flag           IN ('1','2','3','X')
        AND TRUNC(eff_date)    <= TRUNC(NVL(p_loss_date,SYSDATE))
        AND NVL(endt_seq_no,0) > 0
        AND incept_date        <> v_incept_date
        AND expiry_date         = endt_expiry_date
      ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_incept_date := b1.incept_date;
    --check for change in expiry using backward endt.
    FOR C IN
      (SELECT incept_date
         FROM GIPI_POLBASIC
        WHERE line_cd              = p_line_cd
          AND subline_cd           = p_subline_cd
          AND iss_cd               = p_iss_cd
          AND issue_yy             = p_issue_yy
          AND pol_seq_no           = p_pol_seq_no
          AND renew_no             = p_renew_no
          AND pol_flag             IN ('1','2','3','X')
          AND TRUNC(eff_date)      <= TRUNC(NVL(p_loss_date,SYSDATE))
          AND NVL(endt_seq_no,0)   > 0
          AND incept_date          <> b1.incept_date
          AND expiry_date          = endt_expiry_date
          AND NVL(back_stat,5)     = 2
          AND NVL(endt_seq_no,0)   > b1.endt_seq_no
        ORDER BY endt_seq_no DESC)
    LOOP
      v_incept_date  := C.incept_date;
      EXIT;
    END LOOP;
    EXIT;
  END LOOP;

 IF v_incept_date IS NULL THEN
   v_pol_eff_date := v_incept_date;
 ELSIF v_incept_date IS NOT NULL THEN
   --edited by annabelle 02.03.06
    -- commented by gmi :c003.pol_eff_date := to_date(to_char(v_incept_date, 'MM/DD/RRRR')||' '||v_subline_time, 'MM/DD/RRRR HH:MI AM');
    v_pol_eff_date := TO_DATE(TO_CHAR(v_incept_date, 'MM/DD/RRRR')||v_subline_time, 'MM/DD/RRRR HH:MI AM');
 END IF;
 RETURN(v_pol_eff_date);
END;


FUNCTION extract_expiry_date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                              p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                              p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                              p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                              p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                              p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
            p_loss_date   IN GICL_CLAIMS.loss_date%TYPE)
RETURN DATE IS
  v_pol_expiry_date   DATE;
  v_max_eff_date      GIPI_POLBASIC.eff_date%TYPE;
  v_expiry_date       GIPI_POLBASIC.expiry_date%TYPE;
  v_max_endt_seq      GIPI_POLBASIC.endt_seq_no%TYPE;
  v_subline_time   GIIS_SUBLINE.subline_time%TYPE;
BEGIN
 -- annabelle 02.03.06
  FOR v IN (SELECT SUBSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MI AM'), INSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'),'/',1, 2)+6) stime
        FROM GIIS_SUBLINE
        WHERE line_cd    = p_line_cd
          AND subline_cd = p_subline_cd)
  LOOP
    v_subline_time := v.stime;
  END LOOP;

  -- first get the expiry_date of the policy
  FOR A1 IN (SELECT expiry_date
              FROM GIPI_POLBASIC A
             WHERE A.line_cd    = p_line_cd
               AND A.subline_cd = p_subline_cd
               AND A.iss_cd     = p_iss_cd
               AND A.issue_yy   = p_issue_yy
               AND A.pol_seq_no = p_pol_seq_no
               AND A.renew_no   = p_renew_no
               AND A.pol_flag IN ('1','2','3','X')
               AND NVL(A.endt_seq_no,0) = 0)
  LOOP
    v_expiry_date  := a1.expiry_date;
    -- then check and retrieve for any change of expiry in case there is
    -- endorsement of expiry date
    FOR B1 IN (SELECT expiry_date, endt_seq_no
                FROM GIPI_POLBASIC A
               WHERE A.line_cd    = p_line_cd
                 AND A.subline_cd = p_subline_cd
                 AND A.iss_cd     = p_iss_cd
                 AND A.issue_yy   = p_issue_yy
                 AND A.pol_seq_no = p_pol_seq_no
                 AND A.renew_no   = p_renew_no
                 AND A.pol_flag IN ('1','2','3','X')
                 AND A.eff_date   <= NVL(p_loss_date,SYSDATE)
                 AND NVL(A.endt_seq_no,0) > 0
                 AND expiry_date <> a1.expiry_date
                 AND expiry_date = endt_expiry_date
            ORDER BY A.eff_date DESC)
    LOOP
      v_expiry_date  := b1.expiry_date;
      v_max_endt_seq := b1.endt_seq_no;
      --check if changes again occured in expiry date
      FOR B2 IN (SELECT expiry_date, endt_seq_no
                   FROM GIPI_POLBASIC A
                  WHERE A.line_cd    = p_line_cd
                    AND A.subline_cd = p_subline_cd
                    AND A.iss_cd     = p_iss_cd
                    AND A.issue_yy   = p_issue_yy
                    AND A.pol_seq_no = p_pol_seq_no
                    AND A.renew_no   = p_renew_no
                    AND A.pol_flag IN ('1','2','3','X')
                    AND A.eff_date   <= NVL(p_loss_date,SYSDATE)
                    AND NVL(A.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> b1.expiry_date
                    AND expiry_date = endt_expiry_date
               ORDER BY A.eff_date DESC)
     LOOP
       v_expiry_date  := b2.expiry_date;
       v_max_endt_seq :=b2.endt_seq_no;
       EXIT;
     END LOOP;
      --check for change in expiry using backward endt.
      FOR C IN (SELECT expiry_date
                  FROM GIPI_POLBASIC A
                 WHERE A.line_cd    = p_line_cd
                   AND A.subline_cd = p_subline_cd
                   AND A.iss_cd     = p_iss_cd
                   AND A.issue_yy   = p_issue_yy
                   AND A.pol_seq_no = p_pol_seq_no
                   AND A.renew_no   = p_renew_no
                   AND A.pol_flag IN ('1','2','3','X')
                   AND A.eff_date   <= NVL(p_loss_date,SYSDATE)
                   AND NVL(A.endt_seq_no,0) > 0
                   AND expiry_date <> a1.expiry_date
                   AND expiry_date = endt_expiry_date
                   AND NVL(A.back_stat,5) = 2
                   AND NVL(A.endt_seq_no,0) > v_max_endt_seq
              ORDER BY A.endt_seq_no DESC)
      LOOP
        v_expiry_date  := C.expiry_date;
        EXIT;
      END LOOP;
      EXIT;
    END LOOP;
  END LOOP;
  IF v_expiry_date IS NULL THEN
    v_expiry_date := v_expiry_date;
  ELSIF v_expiry_date IS NOT NULL THEN
    v_expiry_date := TO_DATE(TO_CHAR(v_expiry_date, 'MM/DD/RRRR')||v_subline_time, 'MM/DD/RRRR HH:MI AM');
  END IF;
  RETURN(v_expiry_date);
END;
FUNCTION get_dsp_loss_date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
          p_loss_date   IN VARCHAR2)
RETURN VARCHAR2 IS
  v_dsp_loss_date     VARCHAR2(50);
  v_pol_eff_date      DATE;
  v_pol_exp_date      DATE;
BEGIN
  v_pol_eff_date:=Geniisysweb.Extract_Incept_Date (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,TO_DATE(p_loss_date,'MM-DD-YYYY'));
  v_pol_exp_date:=Geniisysweb.extract_expiry_date (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,TO_DATE(p_loss_date,'MM-DD-YYYY'));
  IF TO_DATE(p_loss_date,'MM-DD-YYYY') < v_pol_eff_date THEN
    v_dsp_loss_date :=TO_CHAR(v_pol_eff_date,'MM-DD-YYYY');
  ELSIF TO_DATE(p_loss_date,'MM-DD-YYYY') > v_pol_exp_date THEN
    v_dsp_loss_date :=TO_CHAR(v_pol_exp_date,'MM-DD-YYYY');
  ELSE
    v_dsp_loss_date :=p_loss_date;
  END IF;
  RETURN(v_dsp_loss_date);
END;  

/*Vincent 10.04.07: total loss validation*/
FUNCTION Check_Total_Loss (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE) RETURN VARCHAR2 IS   
  ctr1  NUMBER := 0;
  ctr2  NUMBER := 0;
  v_ann_tsi_amt  gipi_item.ann_tsi_amt%TYPE;
  tl_flag  VARCHAR2(1);
BEGIN
  --get the item(s) of the policy--
  FOR i IN (SELECT distinct a.item_no item_no
       FROM gipi_item a, gipi_polbasic b
     WHERE a.policy_id = b.policy_id
         AND b.line_cd     = p_line_cd
         AND b.subline_cd  = p_subline_cd
         AND b.iss_cd      = p_iss_cd     
         AND b.issue_yy    = p_issue_yy   
         AND b.pol_seq_no  = p_pol_seq_no
         AND b.renew_no    = p_renew_no
         AND b.pol_flag IN ('1','2','3','4'))
  LOOP
    ctr1:= ctr1+1;
    FOR tl IN (SELECT 'x' x
               FROM gicl_claims b,
             gicl_clm_item a
                WHERE b.line_cd = p_line_cd
                  AND b.subline_cd  = p_subline_cd
         AND b.pol_iss_cd  = p_iss_cd     
         AND b.issue_yy    = p_issue_yy   
         AND b.pol_seq_no  = p_pol_seq_no
         AND b.renew_no    = p_renew_no
         AND b.total_tag   = 'Y'
         AND a.claim_id    = b.claim_id
         AND a.item_no     = i.item_no
         AND b.clm_stat_cd NOT IN ('DN','WD','CC'))
    LOOP
      tl_flag := tl.x;
    END LOOP;
 IF tl_flag = 'x' THEN
   ctr2 := ctr2+1; --no of items tagged as total loss
   tl_flag := null;
 END IF;
  END LOOP;
  IF ctr1 = ctr2 AND ctr1 <> 0 AND ctr2 <> 0 THEN
 RETURN('totalloss'); 
  END IF;
  
  RETURN('ok');        
END; 

/*Vincent 09192007: policy no validation*/
FUNCTION Check_Policy_No (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                          p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                          p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                          p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                          p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                          p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE)
RETURN VARCHAR2 IS
  isPolicy BOOLEAN := FALSE;
  v_pol_flag GIPI_POLBASIC.pol_flag%TYPE;
  v_dist_flag GIPI_POLBASIC.dist_flag%TYPE;  
BEGIN
  FOR polno IN (SELECT pol_flag, dist_flag
                  FROM GIPI_POLBASIC
     WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
  LOOP
    isPolicy := TRUE;
 v_pol_flag := polno.pol_flag;
 v_dist_flag := polno.dist_flag;
 EXIT;
  END LOOP;
  IF NOT isPolicy THEN
    RETURN('nopol');
  ELSIF (v_pol_flag = '4') THEN
    RETURN('cancelledpol');  
  ELSIF (v_pol_flag = '5') THEN
    RETURN('spoiledpol');  
  ELSIF (v_dist_flag = '1') THEN
    IF Giacp.v('ALLOW_CLM_FOR_UNDIST_POL') != 'Y' THEN
   RETURN('undistributedpol');
 END IF;    
  END IF;
  RETURN('ok');         
END;

/*Vincent 10092007: check if loss date and time is within the policy term*/
FUNCTION Check_Loss_Date_Term (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                               p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                               p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                               p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                               p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                               p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                               p_loss_date   IN VARCHAR2) RETURN VARCHAR2 IS
  v_dsp_loss_date     DATE;
  v_pol_eff_date      DATE;
  v_pol_exp_date      DATE;
  v_aep      GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
BEGIN
  v_dsp_loss_date := to_date(p_loss_date,'MM/DD/YYYY HH:MI AM'); 
  v_pol_eff_date:=Geniisysweb.Extract_Incept_Date (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,to_date(p_loss_date,'MM/DD/YYYY HH:MI AM'));
  v_pol_exp_date:=Geniisysweb.extract_expiry_date (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,to_date(p_loss_date,'MM/DD/YYYY HH:MI AM'));
  IF v_dsp_loss_date BETWEEN v_pol_eff_date AND v_pol_exp_date THEN
    RETURN('ok');
  ELSE
    v_aep := nvl(GIISP.V('ALLOW_EXPIRED_POLICY'),'N');  
    RETURN(v_aep);
  END IF;
END;          

/*Vincent 10102007: check loss date w/ plate no, If loss date is with-in the item's(plate no) policy term*/
FUNCTION Check_Loss_Date_Plate (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                                p_loss_date   IN VARCHAR2,
        p_plate_no    IN GICL_CLAIMS.plate_no%TYPE) RETURN VARCHAR2 IS
  v_dsp_loss_date     DATE;
  v_pol_eff_date      DATE;
  v_pol_exp_date      DATE;
  v_aep      GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
BEGIN
  v_dsp_loss_date := to_date(p_loss_date,'MM/DD/YYYY HH:MI AM'); 
  v_pol_eff_date:=Geniisysweb.Extract_Incept_Date (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,to_date(p_loss_date,'MM/DD/YYYY HH:MI AM'));
  v_pol_exp_date:=Geniisysweb.extract_expiry_date (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,to_date(p_loss_date,'MM/DD/YYYY HH:MI AM'));

  FOR rec IN (
 SELECT 1
   FROM gipi_vehicle gv,
       gipi_polbasic gp 
  WHERE gp.policy_id  = gv.policy_id
    AND gp.line_cd    = p_line_cd
    AND gp.subline_cd = p_subline_cd
    AND gp.iss_cd     = p_iss_cd
    AND gp.issue_yy   = p_issue_yy
    AND gp.pol_seq_no = p_pol_seq_no
    AND gp.renew_no   = p_renew_no
    AND gv.plate_no   = p_plate_no
    AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),trunc(v_pol_eff_date),eff_date)) <= trunc(v_dsp_loss_date)  
    AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,trunc(v_pol_exp_date),endt_expiry_date)) >= trunc(v_dsp_loss_date)
    AND DECODE(sign(TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),trunc(v_pol_eff_date),eff_date)) - trunc(v_dsp_loss_date)),
                  0,to_date(to_char(v_dsp_loss_date,'HH:MI AM'),'HH:MI AM'),sysdate+1) >= 
        DECODE(sign(TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),trunc(v_pol_eff_date),eff_date)) - trunc(v_dsp_loss_date)),
                   0,to_date(to_char(v_dsp_loss_date,'HH:MI AM'),'HH:MI AM'),sysdate)
    AND DECODE(sign(TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,trunc(v_pol_exp_date),endt_expiry_date)) - trunc(v_dsp_loss_date)),
                0,to_date(to_char(v_dsp_loss_date,'HH:MI AM'),'HH:MI AM'),sysdate) <= 
        DECODE(sign(TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,trunc(v_pol_exp_date),endt_expiry_date)) - trunc(v_dsp_loss_date)),
                   0,to_date(to_char(v_dsp_loss_date,'HH:MI AM'),'HH:MI AM'),sysdate+1)      
    AND NOT EXISTS (SELECT 1
                      FROM gipi_item gi
                     WHERE gi.policy_id = gp.policy_id
                       AND gi.ann_tsi_amt = 0)
  ORDER BY gp.policy_id DESC)
  LOOP
    RETURN('ok');
  END LOOP;

  RETURN('invalidlossdateplate');
END;          

/*Vincent 10102007: check duplicate claim*/
FUNCTION Check_Duplicate_Claim (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                                p_loss_date   IN VARCHAR2,
        p_plate_no    IN GICL_CLAIMS.plate_no%TYPE) RETURN VARCHAR2 IS
  v_dsp_loss_date     DATE;
BEGIN
  v_dsp_loss_date := to_date(p_loss_date,'MM/DD/YYYY HH:MI AM');
  
  FOR rec IN (
 SELECT 'ingeniisys' result
   FROM gicl_claims a
  WHERE line_cd = p_line_cd
    AND subline_cd = p_subline_cd
    AND pol_iss_cd = p_iss_cd
    AND issue_yy = p_issue_yy
    AND pol_seq_no = p_pol_seq_NO
    AND renew_no = p_renew_no
    AND loss_date = v_dsp_loss_date
    AND plate_no = p_plate_no)
  LOOP
    RETURN(rec.result);
  END LOOP;
  RETURN('ok');    
END;        
        
/*Vincent 10112007: validate loss date w/ policy issue date. if loss date is later than the issue date */
FUNCTION Check_Loss_Date_Issue_Date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                     p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                     p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                     p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                     p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                     p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                                     p_loss_date   VARCHAR2) RETURN VARCHAR2 IS
  v_issue_date  gipi_polbasic.ISSUE_DATE%TYPE;
  v_dsp_loss_date  DATE;
BEGIN
  v_dsp_loss_date := to_date(p_loss_date,'MM/DD/YYYY HH:MI AM');

  FOR i IN (SELECT issue_date
              FROM gipi_polbasic
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND issue_yy = p_issue_yy
               AND pol_seq_no = p_pol_seq_no
               AND renew_no = p_renew_no)
  LOOP
    v_issue_date := i.issue_date;
  END LOOP;     

  IF v_dsp_loss_date < v_issue_date THEN
    RETURN('beforeissuedate');
  END IF;
  RETURN('ok');
END;          

/*Vincent 10112007: unpaid premium validation */
FUNCTION Check_Unpaid_Prem (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE) RETURN VARCHAR2 IS
  v_due  NUMBER;
BEGIN
  SELECT SUM(C.balance_amt_due) due
    INTO v_due
    FROM GIPI_POLBASIC A, GIPI_INVOICE b, GIAC_AGING_SOA_DETAILS C
   WHERE A.line_cd     = p_line_cd
     AND A.subline_cd  = p_subline_cd
     AND A.iss_cd      = p_iss_cd
     AND A.issue_yy    = p_issue_yy
     AND A.pol_seq_no  = p_pol_seq_no
     AND A.renew_no    = p_renew_no
     AND A.pol_flag IN ('1','2','3')
     AND A.policy_id = b.policy_id
     AND b.iss_cd = C.iss_cd
     AND b.prem_seq_no = C.prem_seq_no
     AND (A.endt_seq_no = 0 
           OR
    (A.endt_seq_no > 0 AND
      TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date))
         )
     AND A.pack_policy_id IS NULL; 

  IF v_due = 0 THEN
    RETURN('ok');
  ELSE
    RETURN('unpaidprem');
  END IF;    
END;       

/*Vincent 10092007: check if plate no is valid*/        
FUNCTION Check_Plate_No (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                         p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                         p_plate_no    IN GICL_CLAIMS.plate_no%TYPE) RETURN VARCHAR2 IS
BEGIN
  FOR rec IN (SELECT 'x'
                FROM gipi_vehicle a,gipi_polbasic x, gipi_item y 
               WHERE x.policy_id = y.policy_id
                 AND a.policy_id = x.policy_id
                 AND a.item_no   = y.item_no
                 AND x.line_cd   = p_line_cd
                 AND x.subline_cd = p_subline_cd
                 AND x.iss_cd     = p_iss_cd
                 AND x.issue_yy   = p_issue_yy
                 AND x.pol_seq_no = p_pol_seq_no
                 AND x.renew_no   = p_renew_no
                 AND nvl(plate_no,'*') = nvl(p_plate_no,'*'))
  LOOP
    RETURN('ok');
  END LOOP;
  RETURN('invalidplate');
END;        

--Jeff 12/04/2008 check if assured no. is valid 
FUNCTION Check_Assured (p_assd_no     IN GIIS_ASSURED.assd_no%TYPE,
                           p_assd_name   IN GIIS_ASSURED.assd_name%TYPE) RETURN VARCHAR2 IS
BEGIN
  FOR rec IN (SELECT 'x'
                FROM giis_assured  
               WHERE assd_no = p_assd_no
      AND   assd_name = p_assd_name)
  LOOP
    RETURN('ok');
  END LOOP;
  RETURN('invalidassured');
END; 
        
END;
/

DROP PACKAGE BODY CPI.GENIISYSWEB;
