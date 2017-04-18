DROP PROCEDURE CPI.VALIDATE_MC_DETAILS;

CREATE OR REPLACE PROCEDURE CPI.validate_mc_details(
                    p_par_id                IN  GIPI_PARLIST.par_id%TYPE,
                    p_line_cd               IN  GIPI_PARLIST.line_cd%TYPE,
                    p_iss_cd                IN  GIPI_PARLIST.iss_cd%TYPE,
                    p_user_id               IN  VARCHAR2,
                    p_MSG_ALERT             OUT VARCHAR2,    
                    p_change_stat           OUT VARCHAR2,
                    p_msg_icon1             OUT VARCHAR2,
                    p_msg_alert1            OUT VARCHAR2,
                    p_msg_alert2            OUT VARCHAR2,
                    p_msg_alert3            OUT VARCHAR2,
                    p_msg_alert4            OUT VARCHAR2,
                    p_msg_alert5            OUT VARCHAR2
                    )
       IS
    v_eff_date                          DATE;
    v_peril_name                        GIIS_PERIL.peril_name%TYPE;
    v_line_cd                           GIPI_POLBASIC.line_cd%TYPE;
    v_subline_cd                        GIPI_POLBASIC.subline_cd%TYPE;
    v_iss_cd                            GIPI_POLBASIC.iss_cd%TYPE;
    v_issue_yy                          GIPI_POLBASIC.issue_yy%TYPE;
    v_pol_seq_no                        GIPI_POLBASIC.pol_seq_no%TYPE;
    v_renew_no                          GIPI_POLBASIC.renew_no%TYPE;
    v_pol_flag                          GIPI_POLBASIC.pol_flag%TYPE;
    v_ann_tsi_amt                       GIPI_POLBASIC.ann_tsi_amt%TYPE;
    v_endt_type                         GIPI_POLBASIC.endt_type%TYPE;
    v_allow                             GIIS_PARAMETERS.param_value_v%TYPE := 'Y';
    v_dist                              GIUW_POL_DIST.auto_dist%TYPE;
    alert_button                        NUMBER;
    v_par_type                          GIPI_PARLIST.par_type%TYPE;
    v_exist                             VARCHAR2(1)                        := 'N';
    v_op_switch                         VARCHAR2(1)                        := 'N';
    v_booking_year                      GIPI_POLBASIC.booking_year%TYPE;          -- added by kim 01/05/05
    v_booking_mth                       GIPI_POLBASIC.booking_mth%TYPE;              -- added by kim 01/05/05
    v_update                            GIIS_PARAMETERS.param_value_v%TYPE;       -- added by kim 01/05/05
    v_booked_tag                        GIIS_BOOKING_MONTH.booked_tag%TYPE;       -- added by kim 01/05/05
    v_req_deduct                        GIIS_PARAMETERS.param_value_v%TYPE;       -- added by ohwver 06/20/06 parameter container variable
    v_ver_flag                          NUMBER;                                   --ver flag variable
    v_ver_flag1                         NUMBER                              := 0; --ver flag variable
    v_deduct_msg                        VARCHAR2(32767); --issa@fpac06.23.2006, changed size from 100 to max to prevent error
    v_post_limit                        GIIS_POSTING_LIMIT.post_limit%TYPE;                -- connie 09/22/06
    v_all_amt_sw                        GIIS_POSTING_LIMIT.all_amt_sw%TYPE;                -- connie 09/22/06
    v_item_no                           GIPI_WITEM.item_no%TYPE;                                    -- connie 09/22/06
    v_underwriter                       GIPI_PARLIST.underwriter%TYPE; -- added by aaron 060507
    v_amt1                              NUMBER;    -- mark jm 01.05.09 for amount comparison
    v_amt2                              NUMBER; -- mark jm 01.05.09 for amount comparison
    v_pol_id                            GIPI_WPOLBAS.cancelled_endt_id%TYPE;
    v_cancel_type                       VARCHAR2(1); -- aaron 050409
    v_line                              GIPI_PARLIST.line_cd%TYPE;                --added by ailene 12/17/08 
    v_open_policy                       GIIS_SUBLINE.open_policy_sw%TYPE;              --added by ailene 12/17/08 
    v_valid                             NUMBER;   
    v_menu_line                         GIIS_LINE.line_cd%TYPE;
    v_msg_alert                         VARCHAR2(32000);
    v_msg_icon                          VARCHAR2(1); 
    v_takeup_term                        gipi_wpolbas.takeup_term%type;
    v_pack_par_id                       gipi_wpolbas.pack_par_id%type;
    v_load_tag                          gipi_parlist.load_tag%TYPE; -- bonok :: 1.11.2017 :: for quick policy issuance
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : WHEN-BUTTON-PRESSED trigger in post_button
  */
     --A.R.C. 11.23.2006
     --to check if co-insurer exists
     IF NVL(Giisp.V('CHECK_CO_INSURER'),'N') = 'Y' THEN
        FOR c2 IN (SELECT 1
                                  FROM GIPI_WPOLBAS A
                                WHERE 1=1
                                  AND co_insurance_sw <> 1
                                  AND par_id = p_par_id
                                  AND NOT EXISTS (SELECT 1
                                                    FROM GIPI_MAIN_CO_INS z
                                                   WHERE z.par_id = A.par_id))
        LOOP
          p_MSG_ALERT := 'The PAR has no Co-insurance.';
          p_msg_icon1 := 'E';
          RETURN;
        END LOOP;     
     END IF;

    -- mark jm 01.05.09 compare the amounts if they are the reverse of each other starts here (like pcic enhancement implementation)
     
    BEGIN  -- aaron 050409
      FOR X IN (SELECT cancel_type, cancelled_endt_id
                  FROM GIPI_WPOLBAS
                 WHERE par_id = p_par_id)
      LOOP
          v_cancel_type := X.cancel_type;
          v_pol_id := X.cancelled_endt_id;           
      END LOOP;
    END;
     
         
     IF v_cancel_type IN ('1','2','3','4') THEN
         -- get the policy_id / cancelled_endt_id
         SELECT    cancelled_endt_id
         INTO        v_pol_id
         FROM        GIPI_WPOLBAS
         WHERE        par_id = p_par_id;
         
         
         -- gipi_witem v. gipi_item
         SELECT    SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt
         INTO        v_amt1, v_amt2
         FROM        GIPI_ITEM
         WHERE        policy_id = v_pol_id;
     
         FOR A IN (SELECT     SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt
                             FROM         GIPI_WITEM
                             WHERE        par_id = p_par_id) LOOP
             IF ((A.tsi_amt + v_amt1) != 0) THEN 
                 p_MSG_ALERT := 'TSI Amounts of Item/s are not equal.';    
                 p_msg_icon1 := 'E';
                 RETURN;
             ELSE
                 IF ((A.prem_amt + v_amt2) != 0) THEN
                     p_MSG_ALERT := 'Premium Amounts of Item/s are not equal.';
                     p_msg_icon1 := 'E';    
                     RETURN;   
                 END IF;
             END IF;         
         END LOOP;
         
         -- gipi_witmperl v. gipi_itmperil
         SELECT    SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt
         INTO        v_amt1, v_amt2
         FROM        GIPI_ITMPERIL
         WHERE        policy_id = v_pol_id;
     
         FOR A IN (SELECT     SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt
                             FROM         GIPI_WITMPERL
                             WHERE        par_id = p_par_id) LOOP
             IF ((A.tsi_amt + v_amt1) != 0) THEN 
                 p_MSG_ALERT := 'TSI Amounts of Item Peril are not equal.';   
                 p_msg_icon1 := 'E'; 
                 RETURN;
             ELSE
                 IF ((A.prem_amt + v_amt2) != 0) THEN
                     p_MSG_ALERT := 'Premium Amounts of Item Peril are not equal.';    
                     p_msg_icon1 := 'E';
                     RETURN;
                 END IF;
             END IF;
         END LOOP;
         
         -- gipi_winvoice v. gipi_invoice
         SELECT    SUM(tax_amt) tax_amt, SUM(prem_amt) prem_amt
         INTO        v_amt1, v_amt2
         FROM        GIPI_INVOICE
         WHERE        policy_id = v_pol_id;
     
         FOR A IN (SELECT     SUM(tax_amt) tax_amt, SUM(prem_amt) prem_amt
                             FROM         GIPI_WINVOICE
                             WHERE        par_id = p_par_id) LOOP
             IF ((A.tax_amt + v_amt1) != 0) THEN
                 p_MSG_ALERT := 'Tax Amounts of Invoice are not equal.';    
                 p_msg_icon1 := 'E';
                 RETURN;
             ELSE
                 IF ((A.prem_amt + v_amt2) != 0) THEN
                     p_MSG_ALERT := 'Premium Amounts of Invoice are not equal.';
                     p_msg_icon1 := 'E';    
                     RETURN;
                 END IF;
             END IF;             
         END LOOP;         
         
         -- gipi_wcomm_invoices v. gipi_comm_invoice
         SELECT    SUM(commission_amt) commission_amt, SUM(premium_amt) premium_amt
         INTO        v_amt1, v_amt2
         FROM        GIPI_COMM_INVOICE
         WHERE        policy_id = v_pol_id;
     
         FOR A IN (SELECT     SUM(commission_amt) commission_amt, SUM(premium_amt) premium_amt
                             FROM         GIPI_WCOMM_INVOICES
                             WHERE        par_id = p_par_id) LOOP
             IF ((A.commission_amt + v_amt1) != 0) THEN
                 p_MSG_ALERT := 'Commission Amounts of Commission Invoice are not equal.';    
                 p_msg_icon1 := 'E';
                 RETURN;
             ELSE
                 IF ((A.premium_amt + v_amt2) != 0) THEN
                     p_MSG_ALERT := 'Premium Amounts of Commission Invoice are not equal.';
                     p_msg_icon1 := 'E';    
                     RETURN;
                 END IF;
             END IF;
         END LOOP;         
     END IF;    
     
     -- mark jm 01.05.09 compare the amounts if they are the reverse of each other ends here (like pcic enhancement implementation)

/* Modified by        : aaron
** Date Modified    : 060507
** Remarks                : validate if user = gipi_parlist.underwriter, before posting...
*/

FOR X IN (SELECT underwriter, load_tag
            FROM GIPI_PARLIST
           WHERE par_id = p_par_id)
LOOP
    v_underwriter := X.underwriter;
    v_load_tag := x.load_tag; -- bonok :: 1.11.2017 :: for quick policy issuance
END LOOP;

IF v_underwriter <> p_user_id THEN --USER THEN
  p_MSG_ALERT := 'Unable to post PAR. The PAR should be re-assigned to you before you could continue with the posting.';
  p_msg_icon1 := 'E';
  RETURN;
END IF;

----------------------------------


/*
** Modified by     : connie
** Date Modified : 09/22/06
** Modifications : validate if user is allowed to post a policy
*/
  BEGIN
      SELECT post_limit, all_amt_sw
        INTO v_post_limit, v_all_amt_sw
      FROM GIIS_POSTING_LIMIT
     WHERE line_cd = p_line_cd
       AND iss_cd = p_iss_cd
       AND UPPER(posting_user) = p_user_id; --USER;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_MSG_ALERT := 'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user '||USER||'.';
          p_msg_icon1 := 'E';
          RETURN;
  END;
  IF v_all_amt_sw IS NULL OR v_all_amt_sw = 'N' THEN --unchecked or 'N'
      IF v_post_limit IS NULL OR v_post_limit = 0 THEN
          p_MSG_ALERT := 'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user '||USER||'.';
          p_msg_icon1 := 'E';
          RETURN;
      ELSIF v_post_limit IS NOT NULL OR v_post_limit <> 0 THEN
          --A.R.C. 11.23.2006
          --FOR p1 IN (SELECT item_no, ann_tsi_amt
          FOR p1 IN (SELECT SUM(ann_tsi_amt*currency_rt) ann_tsi_amt          
                                    FROM GIPI_WITEM
                                    WHERE par_id = p_par_id)
            LOOP
                --v_item_no := p1.item_no;
                v_ann_tsi_amt := p1.ann_tsi_amt;
                IF NVL(v_ann_tsi_amt,0) > NVL(v_post_limit,0) THEN
                   p_MSG_ALERT := 'Total TSI amount exceeds the allowable TSI amount of the user '||USER||'. Reassign the PAR to another user with higher authority.';
                   p_msg_icon1 := 'E';                     
                   RETURN;
                END IF;
            END LOOP;
        END IF;
  END IF; 
  
  
  
  --added by iris bordey (09.20.2002)
  --Validation for posting policy with pending claims on particular item and peril(s).
  --Disallow posting if there are pending claims on specified item and peril(s).
  FOR  dt IN (SELECT TRUNC(eff_date) eff_date, line_cd, subline_cd, iss_cd, 
                     pol_seq_no, issue_yy, renew_no, pol_flag,
                     ann_tsi_amt, endt_type,
                     booking_year, booking_mth, -- added by kim 01/05/05
                     nvl(takeup_term,'ST') takeup_term,/*vjp 08032011*/
                     pack_par_id /*niknok 11042011*/
                FROM GIPI_WPOLBAS
               WHERE par_id = p_par_id)
  LOOP
      v_eff_date     := dt.eff_date;
      v_line_cd      := dt.line_cd;
      v_subline_cd   := dt.subline_cd;
      v_iss_cd       := dt.iss_cd;
      v_issue_yy     := dt.issue_yy;
      v_pol_seq_no   := dt.pol_seq_no;
      v_renew_no     := dt.renew_no;
      v_pol_flag     := dt.pol_flag;
      v_ann_tsi_amt  := dt.ann_tsi_amt;
      v_endt_type    := dt.endt_type;
      v_booking_year := dt.booking_year;
      v_booking_mth  := dt.booking_mth;
      v_takeup_term  := dt.takeup_term;/*vjp 08032011*/    
      v_pack_par_id  := dt.pack_par_id; /*niknok 11042011 para sa pag update ng booking month ng gipi_pack_wpolbas*/
      EXIT;
  END LOOP;
  

   
  -- Added by gracey 061604
    -- check if posting is allowed for undistributed policies
        
    -- modified by gmi 020608
    /* 
         Revise checking of parameter ALLOW_POSTING_OF UNDIST.  Before, if value = 'N', the 
       user is not allowed to post if the policy is not fully distributed.  For multi-year, 
       even if the policy is not yet fully distributed (since this is possible), posting 
       should be allowed if the distribution for the current year/effective year is distributed   
    */    
    /*FOR a IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'ALLOW_POSTING_OF_UNDIST')
    LOOP*/
   IF NVL(v_load_tag, 'XX') <> 'Q' THEN -- bonok :: 1.11.2017 :: for quick policy issuance.  if load_tag is Q, skip checking of ALLOW_POSTING_OF_UNDIST
      v_allow := Giisp.v('ALLOW_POSTING_OF_UNDIST');
   END IF;
    /*    EXIT;
    END LOOP;    */

  FOR b IN (SELECT NVL(auto_dist,'N') auto_dist, eff_date, expiry_date
                FROM GIUW_POL_DIST
               WHERE par_id = p_par_id
                 AND 
                  (TRUNC(SYSDATE) > TRUNC(expiry_date)
                              OR TRUNC(SYSDATE) BETWEEN TRUNC(eff_date) AND TRUNC(expiry_date)) 
                              OR dist_no = (SELECT MIN(dist_no)
                                              FROM GIUW_POL_DIST
                                             WHERE par_id = p_par_id)) -- long term add ons..
    LOOP        
        v_dist := b.auto_dist;
        IF v_dist = 'N' THEN
            EXIT;
        END IF;    
    END LOOP;    
  FOR d IN (SELECT A.par_type par_type, c.op_flag op_flag
                FROM GIPI_PARLIST A, GIPI_WPOLBAS b, GIIS_SUBLINE c
               WHERE A.par_id = b.par_id
                 AND b.subline_cd = c.subline_cd
                 AND b.line_cd = c.line_cd
                 AND A.par_id = p_par_id)
    LOOP
        v_par_type := d.par_type;
      v_op_switch := d.op_flag;
        EXIT;
    END LOOP;    

  FOR d IN (SELECT 1
              FROM GIPI_WITMPERL
             WHERE par_id = p_par_id)
    LOOP
        v_exist := 'Y';
        EXIT;
    END LOOP;
    --**-- gmi 09/26/05 --**--
    FOR d1 IN (SELECT 1
              FROM GIPI_WITMPERL_GROUPED
             WHERE par_id = p_par_id)
    LOOP
        v_exist := 'Y';
        EXIT;
    END LOOP;
  --** --gmi-- **--

/*Modified by : John Oliver Mendoza
**    date    : 062020006
**Modification: this validates if all the items of the given PAR have at least 1 record
                              in GIPI_DEDUCTIBLES, if not posting will not continue.
*/
  --added by VJ, 111709
  BEGIN
      SELECT NVL(menu_line_cd,line_cd) line_cd
        INTO v_menu_line
        FROM GIIS_LINE
       WHERE line_cd = v_line_cd;
  END;
  IF v_menu_line <> 'SU' THEN

    -- ohwver start 062006--
    
    /*FOR ver_rec1 in (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'REQUIRE_DEDUCTIBLES')
    LOOP*/
   IF NVL(v_load_tag, 'XX') <> 'Q' THEN -- bonok :: 1.11.2017 :: for quick policy issuance.  if load_tag is Q, skip checking of REQUIRE_DEDUCTIBLES
      v_req_deduct := Giisp.v('REQUIRE_DEDUCTIBLES');--ver_rec1.param_value_v;
   END IF;
    --END LOOP;
    
  IF v_par_type = 'P' THEN
    IF NVL(v_req_deduct,'N') = 'Y' AND v_op_switch = 'N' THEN --VJP 062711
         FOR ver_rec2 IN (SELECT item_no 
                                    FROM GIPI_WITEM
                                   WHERE par_id = p_par_id)
             LOOP
                 FOR ver_rec3 IN (SELECT 'VER'
                                                      FROM GIPI_WDEDUCTIBLES
                                                     WHERE par_id = p_par_id
                                                       AND item_no = ver_rec2.item_no)
                 LOOP
                         v_ver_flag:=1;
                 END LOOP;
                 IF v_ver_flag = 1 THEN
                        v_ver_flag :=0;                       
                 ELSE
                         v_deduct_msg:=v_deduct_msg||ver_rec2.item_no||', ';
                       v_ver_flag :=0;
                       v_ver_flag1 := v_ver_flag1+1;
                 END IF;
             END LOOP;
             IF v_ver_flag1 > 0 THEN
               v_deduct_msg:=SUBSTR(v_deduct_msg,1,INSTR(v_deduct_msg,', ',-1)-1);
               p_MSG_ALERT := 'The ff. must have at least 1 deductible: Item no(s) '||v_deduct_msg||'.';
               p_msg_icon1 := 'E';
               RETURN;           
             END IF;--end if v_ver_flag1 > 0
    END IF;--end if nvl(v_req_deduct,'N') = 'Y'
  ELSIF v_par_type = 'E' THEN
    IF NVL(v_req_deduct,'N') = 'Y' AND v_op_switch = 'N' THEN  --VJP 062711
         FOR ver_rec2 IN (SELECT item_no 
                                FROM GIPI_WITEM
                               WHERE par_id = p_par_id
                                 AND rec_flag = 'A')
             LOOP
                 FOR ver_rec3 IN (SELECT 'VER'
                                                      FROM GIPI_WDEDUCTIBLES
                                                   WHERE par_id = p_par_id
                                                       AND item_no = ver_rec2.item_no)
                 LOOP
                     v_ver_flag:=1;
                 END LOOP;
                 IF v_ver_flag = 1 THEN
                   v_ver_flag :=0;                       
                 ELSE
                     v_deduct_msg:=v_deduct_msg||ver_rec2.item_no||', ';
                     v_ver_flag :=0;
                     v_ver_flag1 := v_ver_flag1+1;
                 END IF;
             END LOOP;
             IF v_ver_flag1 > 0 THEN
               v_deduct_msg:=SUBSTR(v_deduct_msg,1,INSTR(v_deduct_msg,', ',-1)-1);
               p_MSG_ALERT := 'The ff. must have at least 1 deductible: Item no(s) '||v_deduct_msg||'.';
               p_msg_icon1 := 'E';
               RETURN;               
             END IF;--end if v_ver_flag1 > 0
    END IF;--end if nvl(v_req_deduct,'N') = 'Y'
  END IF;--end if v_par_type
  END IF;
  --end vj
  --ohwver end--   
  
  --glyza 060608
    FOR X IN (SELECT NVL(auto_dist,'N') auto_dist, eff_date, expiry_date
                FROM GIUW_POL_DIST
               WHERE par_id = p_par_id)
    LOOP
        IF NVL(v_allow,'Y') = 'N' THEN
            IF X.auto_dist = 'N' THEN 
                p_MSG_ALERT := 'Distribute the PAR before posting the policy.';
                p_msg_icon1 := 'E';
                RETURN;
                EXIT;
            END IF;
        END IF;
    END LOOP;
    
  IF v_par_type = 'P' THEN
     IF NVL(v_allow,'Y') = 'N' AND NVL(v_dist,'N') = 'N' AND v_op_switch = 'N' THEN
        p_MSG_ALERT := 'Distribute the PAR before posting the policy.';
        p_msg_icon1 := 'E';
        RETURN;
     END IF;    
  ELSIF v_par_type = 'E' AND v_exist = 'Y' THEN
     IF NVL(v_allow,'Y') = 'N' AND NVL(v_dist,'N') = 'N' AND v_op_switch = 'N' THEN
        p_MSG_ALERT := 'Distribute the PAR before posting the policy.';
        p_msg_icon1 := 'E';
        RETURN;
     END IF;    
  END IF;   
 
    v_update := Giisp.v('UPDATE_BOOKING');--a.param_value_v;

    -- Added by kim 01/05/05
    -- checks if the value of the booked tag of the PAR
    FOR A IN (SELECT booked_tag
                            FROM GIIS_BOOKING_MONTH
                         WHERE booking_year = v_booking_year
                           AND booking_mth  = v_booking_mth)
    LOOP
        v_booked_tag := A.booked_tag;
        EXIT;
    END LOOP;

    -- added by kim 01/05/05
    -- if the value of the parameter update_booking is set to Y
    -- and the booked_tag of the booking date is set to Y
    -- then it updates the booking date to the next available booking date    
    
    p_msg_alert5 := '';
    IF v_update = 'Y' AND v_booked_tag = 'Y' THEN
        FOR C IN (SELECT BOOKING_YEAR, 
                         TO_CHAR(TO_DATE('01-' || SUBSTR(booking_mth,1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MM'), 
                         BOOKING_MTH 
                    FROM GIIS_BOOKING_MONTH
                   WHERE (NVL(BOOKED_TAG, 'N') != 'Y')
                        AND (BOOKING_YEAR > v_booking_year
                      OR (BOOKING_YEAR = v_booking_year 
                 AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)||'-'|| booking_year, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(v_booking_mth,1, 3)||'-'||v_booking_year, 'DD-MON-YYYY'), 'MM')))) 
              ORDER BY 1, 2 ) 
      LOOP
        v_booking_year := TO_NUMBER(C.BOOKING_YEAR);       
        v_booking_mth  := C.BOOKING_MTH;       
        EXIT;   
      END LOOP; 
        p_msg_alert5 := 'Booking date has been closed. Will now update the booking date to the next available booking month.';
        
        UPDATE GIPI_WPOLBAS 
           SET booking_mth  = v_booking_mth,
               booking_year = v_booking_year
         WHERE par_id = p_par_id;
         
        /*niknok 11042011*/ 
        IF v_pack_par_id IS NOT NULL THEN 
          UPDATE GIPI_PACK_WPOLBAS 
             SET booking_mth  = v_booking_mth,
                 booking_year = v_booking_year
           WHERE pack_par_id = v_pack_par_id; 
        END IF; 
         
      /*vjp 08032011*/        
      IF v_takeup_term = 'ST' THEN
        UPDATE gipi_winvoice
           SET multi_booking_mm  = v_booking_mth,
               multi_booking_yy  = v_booking_year
         WHERE par_id = p_par_id;
      END IF;
        
      COMMIT;    
    END IF;
    
    /*added by dannel 10162006
        validation for plate_no,serial_no and motor_no    */
    IF p_line_cd='MC' THEN
       IF v_msg_alert IS NULL THEN
          Validate_Carnap(p_par_id,v_msg_alert);
          IF v_msg_alert IS NOT NULL THEN
            p_MSG_ALERT := v_msg_alert;
            p_msg_icon1 := 'E';
            RETURN;
          END IF;
       END IF;
       IF v_msg_alert IS NULL THEN
             Validate_Plate_No(p_par_id,v_msg_alert, v_msg_icon, v_par_type);
          IF v_msg_icon = 'E' THEN
            p_MSG_ALERT := v_msg_alert;
            p_msg_icon1 := 'E';
            RETURN;
          END IF;
       END IF;
       IF v_msg_alert IS NULL THEN
             Validate_Serial_Motor(p_par_id,v_msg_alert);
          IF v_msg_alert IS NOT NULL THEN
            p_MSG_ALERT := v_msg_alert;
            p_msg_icon1 := 'E';
            RETURN;
          END IF;
       END IF;
       
      /*
      **  Created by   : Jerome Orio
      **  Date Created : June 27, 2011
      **  Reference By : (GIPIS055 - POST PAR)
      **  Description  : WHEN-BUTTON-PRESSED trigger in post_button validate MC details 
      */
       Validate_Plate_No(p_par_id,p_msg_alert1, p_msg_icon1, v_par_type);
       Validate_Serial_No(p_par_id,p_msg_alert2,v_par_type);
       Validate_Motor_No(p_par_id,p_msg_alert3,v_par_type);
       Validate_Coc_Serial_No(p_par_id,p_msg_alert4,v_par_type);
       IF SUBSTR(p_msg_alert4, 1, 6) = 'ERROR#' THEN
               p_msg_alert4 := SUBSTR(p_msg_alert4, 7);
               p_msg_icon1 := 'E';
       END IF;
    END IF;
 
END;
/


