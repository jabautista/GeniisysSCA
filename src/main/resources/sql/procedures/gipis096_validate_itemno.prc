DROP PROCEDURE CPI.GIPIS096_VALIDATE_ITEMNO;

CREATE OR REPLACE PROCEDURE CPI.GIPIS096_VALIDATE_ITEMNO
(p_pack_par_id     IN      GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
 p_item_no         IN      GIPI_WITEM.item_no%TYPE,
 p_line_cd         IN      GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd      IN      GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd          IN      GIPI_POLBASIC.iss_cd%TYPE, 
 p_issue_yy        IN      GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no      IN      GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no        IN      GIPI_POLBASIC.renew_no%TYPE,
 p_eff_date        IN      GIPI_POLBASIC.eff_date%TYPE,
 p_expiry_date     IN      GIPI_POLBASIC.expiry_date%TYPE,
 p_msg_alert       OUT     VARCHAR2,
 p_par_id         IN OUT   GIPI_WITEM.par_id%TYPE,
 p_rec_flag        OUT     GIPI_WITEM.rec_flag%TYPE,    
 p_item_title      OUT     GIPI_WITEM.item_title%TYPE,
 p_pack_line_cd    OUT     GIPI_WITEM.pack_line_cd%TYPE, 
 p_pack_subline_cd OUT     GIPI_WITEM.pack_subline_cd%TYPE,
 p_currency_cd     OUT     GIPI_WITEM.currency_cd%TYPE,
 p_currency_rt     OUT     GIPI_WITEM.currency_rt%TYPE,
 p_ann_tsi_amt     OUT     GIPI_WITEM.ann_tsi_amt%TYPE, 
 p_ann_prem_amt    OUT     GIPI_WITEM.ann_prem_amt%TYPE) 
 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 26, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Equivalent to the Program Unit VALIDATE_ITEMNO in GIPIS096 module
*/
  
  v_new_item    VARCHAR2(1) := 'Y';
  expired_sw    VARCHAR2(1) := 'N';
  v_exist       VARCHAR2(1) := 'N'; 
  
  CURSOR A IS
    SELECT    b.policy_id
      FROM    GIPI_POLBASIC b,
              GIPI_PACK_POLBASIC a
     WHERE    a.line_cd     =  p_line_cd
       AND    a.iss_cd      =  p_iss_cd
       AND    a.subline_cd  =  p_subline_cd
       AND    a.issue_yy    =  p_issue_yy
       AND    a.pol_seq_no  =  p_pol_seq_no
       AND    a.renew_no    =  p_renew_no
       AND a.pol_flag   IN ('1','2','3','X')
       AND    TRUNC(a.eff_date)   <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
       AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                            a.expiry_date,p_expiry_date,a.endt_expiry_date)) >= TRUNC(p_eff_date)
       AND    b.pack_policy_id = a.pack_policy_id
       AND    EXISTS (SELECT '1'
                        FROM GIPI_ITEM z
                       WHERE z.item_no = p_item_no
                        AND z.policy_id = b.policy_id)      
     ORDER BY   a.eff_date DESC;
    
    CURSOR B(p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
       SELECT    currency_cd,
                 currency_rt,
                 item_title,
                 pack_line_cd,
                 pack_subline_cd,
                 ann_tsi_amt,
                 ann_prem_amt
         FROM    GIPI_ITEM
        WHERE    item_no   = p_item_no
          AND    policy_id = p_policy_id;

BEGIN
   FOR A1 IN A LOOP
      FOR B1 IN B(A1.policy_id) 
      LOOP
         FOR A IN (SELECT pack_line_cd,pack_subline_cd
                     FROM GIPI_WPACK_LINE_SUBLINE
                    WHERE pack_line_cd = b1.pack_line_cd
                      AND pack_subline_cd = b1.pack_subline_cd
                      AND pack_par_id = p_pack_par_id ) 
         LOOP
             v_exist := 'Y';
             EXIT;
         END LOOP;
             
        IF v_exist = 'N' THEN
               p_msg_alert := ('This item already exists in the policy with the line code '||
                ''''||b1.pack_line_cd||''''||' and subline code '||''''||b1.pack_subline_cd||''''||'. Combination of '||
                'line and subline must exist in the line\subline coverages before endorsing this item.');
               RETURN;
         ELSE       
           FOR SW IN 
             (SELECT  '1'
          FROM  GIPI_ITMPERIL A,
                GIPI_PACK_POLBASIC B,
                GIPI_POLBASIC C
         WHERE  B.line_cd      =  p_line_cd
           AND  B.subline_cd   =  p_subline_cd
           AND  B.iss_cd       =  p_iss_cd
           AND  B.issue_yy     =  p_issue_yy
           AND  B.pol_seq_no   =  p_pol_seq_no
           AND  B.renew_no     =  p_renew_no
           AND  C.pack_policy_id  =  B.pack_policy_id
           AND  C.policy_id    =  A.policy_id
           AND  B.pol_flag    IN ('1','2','3')
           AND  (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
          -- add this validation so that data that will be retrieved
          -- is only those from endorsement prior to the current endorsement
          -- this was consider because of the backward endorsement
           AND  A.item_no = p_item_no
           AND  TRUNC(B.eff_date)    <=  TRUNC(p_eff_date)
           AND  NVL(B.endt_expiry_date,B.expiry_date) < p_eff_date
         ORDER BY B.eff_date DESC ) 
         
         LOOP
           expired_sw := 'Y';
           EXIT;
         END LOOP;
         
         p_rec_flag        := 'C';
         p_item_title      := B1.item_title;
         p_pack_line_cd    := B1.pack_line_cd;
         p_pack_subline_cd := B1.pack_subline_cd;
         p_currency_cd     := B1.currency_cd;
         p_currency_rt     := B1.currency_rt;
         
           IF p_pack_line_cd IS NOT NULL AND p_pack_subline_cd IS NOT NULL AND p_par_id IS NULL THEN
               FOR rec in (SELECT a.par_id, a.line_cd, a.iss_cd, a.par_yy, a.par_seq_no, a.quote_seq_no
                             FROM GIPI_PARLIST a, 
                                  GIPI_WPACK_LINE_SUBLINE b
                            WHERE a.par_id = b.par_id
                              AND b.pack_par_id = p_pack_par_id
                              AND b.pack_line_cd = p_pack_line_cd
                              AND b.pack_subline_cd = p_pack_subline_cd)
               LOOP 
               p_par_id := rec.par_id;     
               /*p_drv_par_num := rec.LINE_CD || ' - ' ||
                                   RTRIM(rec.ISS_CD) || ' - ' ||
                                   TO_CHAR(rec.PAR_YY,'09') || ' - ' ||
                                   TO_CHAR(rec.PAR_SEQ_NO, '099999') || ' - ' ||
                                   TO_CHAR(rec.QUOTE_SEQ_NO, '09');*/
               END LOOP;
           END IF;         
 
         IF NVL(expired_sw, 'N') = 'N' THEN
            p_ann_tsi_amt := B1.ann_tsi_amt;
            p_ann_prem_amt:= B1.ann_prem_amt;
         ELSE 
            EXTRACT_ANN_AMT_PACK(p_item_no, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no,  
                                 p_renew_no, p_eff_date, p_expiry_date, p_ann_tsi_amt,  p_ann_prem_amt);
         END IF;
         v_new_item := 'N';
         p_msg_alert := 'EXISTING';
        END IF;     
      END LOOP;
     EXIT;
   END LOOP;
   
   IF v_new_item = 'Y' THEN
      p_rec_flag        := 'A';
      p_item_title      := NULL;
      p_pack_line_cd    := NULL;
      p_pack_subline_cd := NULL;
      p_ann_tsi_amt     := NULL;
      p_ann_prem_amt    := NULL;
      p_msg_alert       := 'NEW';
   END IF;
   
     
END;
/


