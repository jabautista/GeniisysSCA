CREATE OR REPLACE PACKAGE BODY CPI.GIPIS173_PKG AS

    /*
    ** Created by   : Marie Kris N. Felipe  
    ** Date Created: December 12, 2012
    ** Reference by: GIPIS173 - Endorsement - Limits of Liability Data Entry
    ** Description: Updates/Inserts Witem record using the INSERT_INTO_GIPI_WITEM program unit
    **              Invoked by POST_FORMS_COMMIT Procedure
    */
    PROCEDURE insert_into_gipi_witem(
        p_wopen_liab    IN      GIPI_WOPEN_LIAB%ROWTYPE
    ) IS 
        p_item_no   GIPI_WITEM.ITEM_NO%TYPE;
    BEGIN
        FOR A IN (SELECT   item_no
                    FROM   gipi_witem
                   WHERE   par_id  =  p_wopen_liab.par_id)
        LOOP
              p_item_no  :=  A.item_no;
              
              DELETE  gipi_witem
               WHERE  par_id      =  p_wopen_liab.par_id
                 AND  item_no    !=  1;
                 
              GIPI_WITEM_PKG.update_tsi_and_currency(p_wopen_liab, 1);   
              
              EXIT;
        
        END LOOP;   
        
        IF p_item_no IS NULL THEN
        
            GIPI_WITEM_PKG.insert_limit(p_wopen_liab);
            
        END IF;
                
    
    END insert_into_gipi_witem;
    
    /*
    ** Created by   : Marie Kris N. Felipe  
    ** Date Created: December 12, 2012
    ** Reference by: GIPIS173 - Endorsement - Limits of Liability Data Entry
    ** Description: Inserts/Updates witemperl record using the INSERT_INTO_GIPI_WITMPERL program unit
    **              Invoked by POST_FORMS_COMMIT Procedure
    */
    PROCEDURE insert_into_gipi_witmperl(
        p_par_id            IN      GIPI_WOPEN_LIAB.par_id%type,
        p_limit_liability   IN      GIPI_WOPEN_LIAB.limit_liability%type,
        p_line_cd           IN      GIPI_WOPEN_PERIL.line_cd%type,
        p_iss_cd            IN      GIPI_WPOLBAS.iss_cd%type 
    ) IS
          p_dist_no  NUMBER;
          p_exist            NUMBER;
          v_ann_prem_amt     gipi_polbasic.ann_prem_amt%TYPE;
          v_ann_tsi_amt      gipi_polbasic.ann_prem_amt%TYPE;
          v_tot_prem_amt     gipi_polbasic.ann_prem_amt%TYPE;
          v_tot_tsi_amt      gipi_polbasic.ann_prem_amt%TYPE;
          v_tot_prem_amt1    gipi_polbasic.ann_prem_amt%TYPE;
          v_tot_tsi_amt1     gipi_polbasic.ann_prem_amt%TYPE;
          v_prem_amt         gipi_polbasic.prem_amt%TYPE;
          v_prem_amt1        gipi_polbasic.prem_amt%TYPE;
          v_tsi_amt1         gipi_polbasic.tsi_amt%TYPE;
          v_tsi_amt          gipi_polbasic.tsi_amt%TYPE;
          v_exist            VARCHAR2(1) := 'N';
          v_exist1           VARCHAR2(1) := 'N';
          v_switch           VARCHAR2(1) := 'N';
          tsi_amt_tag        VARCHAR2(1) := 'N';
          
          v_cnt              NUMBER;
          v_cnt1             NUMBER;
          
          CURSOR A IS
            SELECT   peril_cd, prem_rate
              FROM   gipi_wopen_peril
             WHERE   par_id   =  p_par_id;
             
          CURSOR B(p_peril_cd  gipi_witmperl.peril_cd%TYPE) IS
            SELECT   peril_cd
              FROM   gipi_witmperl
             WHERE   par_id   =  p_par_id
               AND   tsi_amt  =  p_limit_liability;
               
          CURSOR C IS
            SELECT  dist_no
              FROM  giuw_pol_dist
             WHERE  par_id   =  p_par_id;
             
          CURSOR D IS
            SELECT  dist_no
              FROM  giuw_pol_dist
             WHERE  par_id   = p_par_id;
             
          CURSOR E(p_dist_no   giri_wdistfrps.dist_no%TYPE) IS
            SELECT  frps_seq_no,
                    frps_yy
              FROM  giri_wdistfrps
             WHERE  dist_no  =  p_dist_no;
    
    BEGIN
           
           DELETE_WINVOICE(p_par_id); -- this is a procedure outside this package
           
           FOR B1 IN D LOOP
                GIUW_WITEMPERILDS_DTL_PKG.del_giuw_witemperilds_dtl(B1.dist_no);
                GIUW_WITEMPERILDS_PKG.del_giuw_witemperilds(B1.dist_no);
                GIUW_WPERILDS_DTL_PKG.del_giuw_wperilds_dtl(B1.dist_no);
                GIUW_WPERILDS_PKG.del_giuw_wperilds(B1.dist_no);
                GIUW_WITEMDS_DTL_PKG.del_giuw_witemds_dtl(B1.dist_no);
                GIUW_WPOLICYDS_DTL_PKG.del_giuw_wpolicyds_dtl(B1.dist_no);
                GIUW_WITEMDS_PKG.del_giuw_witemds(B1.dist_no);
                GIUW_WPOLICYDS_PKG.del_giuw_wpolicyds(B1.dist_no);
                
                FOR C1 IN E(B1.dist_no) LOOP
                    GIRI_WDISTFRPS_PKG.del_giri_wdistfrps1(C1.frps_seq_no, C1.frps_yy);
                END LOOP; -- End C1 cursor
                
                GIUW_POL_DIST_PKG.del_giuw_pol_dist(B1.dist_no);
                
           END LOOP;   -- End B1 cursor
           
           GIPI_WITMPERL_PKG.del_gipi_witmperl2(p_par_id);
           
          FOR cnt IN (SELECT   COUNT(*) cnt
                        FROM   gipi_wopen_peril
                       WHERE   par_id   =  p_par_id)
          LOOP
               v_cnt := cnt.cnt;
          END LOOP;

          FOR cnt1 IN (SELECT   COUNT(*) cnt
                         FROM   gipi_wopen_peril
                        WHERE   par_id   =  p_par_id
                          AND   prem_rate IS NOT NULL)
          LOOP 
               v_cnt1 := cnt1.cnt;
          END LOOP;
           
           
           FOR A1 IN A LOOP
                 IF a1.prem_rate IS NOT NULL THEN
                    v_tsi_amt      := p_limit_liability;
                 ELSE
                    IF v_cnt = 1 THEN 
                        v_tsi_amt      := p_limit_liability;
                    ELSIF v_cnt1 = 0 THEN
                        IF tsi_amt_tag = 'N' THEN
                            v_tsi_amt      := p_limit_liability;
                            tsi_amt_tag    := 'Y';
                        ELSE
                            v_tsi_amt      := 0;
                        END IF; 
                    ELSE
                        v_tsi_amt      := 0;
                    END IF;
                 END IF;
                 ---
                 
                 IF v_exist1 = 'Y' THEN 
                    v_prem_amt     := ROUND(nvl(a1.prem_rate,0) * nvl(v_tsi_amt,0) / 100,2);
                    v_ann_prem_amt := NVL(v_ann_prem_amt,0) + nvl(v_prem_amt,0);
                    v_ann_tsi_amt  := NVL(v_ann_tsi_amt,0) + nvl(v_tsi_amt,0);
                    v_tot_prem_amt := NVL(v_tot_prem_amt,0) + NVL(v_ann_prem_amt,0);   
                    v_tot_tsi_amt  := NVL(v_tot_tsi_amt,0)  + NVL(v_ann_tsi_amt,0);
                    v_exist1       := 'N';   
                 ELSE
                    v_prem_amt     := ROUND(nvl(a1.prem_rate,0) * nvl(v_tsi_amt,0) / 100,2);
                    v_ann_prem_amt := nvl(v_prem_amt,0);
                    v_ann_tsi_amt  := nvl(v_tsi_amt,0);
                    v_tot_prem_amt := NVL(v_tot_prem_amt,0) + v_ann_prem_amt;   
                    v_tot_tsi_amt  := NVL(v_tot_tsi_amt,0)  + v_ann_tsi_amt;   
                 END IF;  
                 ---
                 GIPI_WITMPERL_PKG.SET_GIPI_WITMPERL2(p_par_id, 1, p_line_cd, A1.peril_cd, 'N', a1.prem_rate,
                                                      v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt);
                 ---
                
                IF a1.prem_rate IS NOT NULL THEN
                    v_exist := 'Y';
                END IF; 

                v_prem_amt     := 0;
                v_ann_prem_amt := 0;
                v_ann_tsi_amt  := 0;
                v_tot_prem_amt := 0;
                v_tot_tsi_amt  := 0;
           
           END LOOP; -- end of cursor A1
           
           FOR item IN (SELECT item_no, 
                               SUM(prem_amt) prem_amt,
                               SUM(ann_prem_amt) ann_prem_amt
                          FROM gipi_witmperl
                         WHERE par_id = p_par_id
                         GROUP BY item_no)
           LOOP
                FOR tsi IN(SELECT sum(a.tsi_amt) tsi,
                                  sum(a.ann_tsi_amt) ann_tsi
                             FROM gipi_witmperl a, giis_peril B
                            WHERE a.par_id     = p_par_id
                              AND a.item_no    = item.item_no 
                              AND a.peril_cd   = b.peril_cd
                              AND a.line_cd    = b.line_cd
                              AND b.peril_type = 'B')
                LOOP
                      v_tot_tsi_amt1    := nvl(v_tot_tsi_amt1,0)  + nvl(tsi.tsi,0);
                      v_tsi_amt1        := tsi.tsi;       
                      EXIT;
                END LOOP;
                
                v_tot_prem_amt1 := NVL(v_tot_prem_amt1,0) + NVL(item.ann_prem_amt,0);
              
                GIPI_WITEM_PKG.UPDATE_ITEM_VALUE(v_tsi_amt1, item.prem_amt, 
                                                 v_tot_tsi_amt1, v_tot_prem_amt1, 
                                                 p_par_id, item.item_no);  
                EXIT;
           END LOOP;  -- end of cursor item loop
           ------ *********************
           IF v_exist = 'Y' THEN 
                create_winvoice(0, 0, 0, p_par_id, p_line_cd, p_iss_cd); -- procedure outside of this package
                GIPIS173_PKG.CREATE_DISTRIBUTION(p_par_id, p_dist_no); -- procedure included in this package 
                
                FOR A IN (SELECT   par_id,par_status
                            FROM   gipi_parlist
                           WHERE   par_id  =  p_par_id
                             FOR   UPDATE OF par_id, par_status) 
                LOOP
                    GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(A.par_id, 5);
                    EXIT;
                END LOOP;       
           
           ELSE
                FOR A IN (SELECT   par_id,par_status
                            FROM   gipi_parlist
                           WHERE   par_id  =  p_par_id
                             FOR   UPDATE OF par_id, par_status) 
                LOOP
                    GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(A.par_id, 6);
                    EXIT;
                END LOOP;       
           END IF;
    
    END insert_into_gipi_witmperl;
    
    
    /*
    ** Created by   : Marie Kris N.. Felipe
    ** Date Created: December 12, 2012
    ** Reference by: GIPIS173 - Endorsement - Limits of Liability Data Entry
    ** Description: Created distribution using the CREATE_DISTRIBUTION program unit
    **              Invoked by INSERT_INTO_GIPI_WITMPERL Procedure 
    **              and POST-FORMS-COMMIT Trigger      
    */
   PROCEDURE create_distribution(
        b_par_id    IN  NUMBER,
        p_dist_no   IN  NUMBER
    ) IS
                                  
        -----------                            
        TYPE NUMBER_VARRAY IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
        vv_tsi_amt          NUMBER_VARRAY;
        vv_ann_tsi_amt  NUMBER_VARRAY;
        vv_prem_amt     NUMBER_VARRAY;
        vv_item_grp       NUMBER_VARRAY;
        varray_cnt          NUMBER:=0;
        -----------
                                
        b_exist        NUMBER;
        p_exist        NUMBER;
        pi_dist_no     giuw_pol_dist.dist_no%TYPE;
        p_frps_yy      giri_wdistfrps.frps_yy%TYPE;
        p_frps_seq_no  giri_wdistfrps.frps_seq_no%TYPE;
        p2_dist_no     giuw_pol_dist.dist_no%TYPE;
        p_eff_date     gipi_polbasic.eff_date%TYPE;
        p_expiry_date  gipi_polbasic.expiry_date%TYPE;
        p_endt_type    gipi_polbasic.endt_type%TYPE;
        p_policy_id    gipi_polbasic.policy_id%TYPE;
        p_tsi_amt      gipi_witem.tsi_amt%TYPE;
        p_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE;
        p_prem_amt     gipi_witem.prem_amt%TYPE;
        v_tsi_amt      gipi_witem.tsi_amt%TYPE      := 0;
        v_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE  := 0;
        v_prem_amt     gipi_witem.prem_amt%TYPE     := 0;
        x_but          NUMBER;
        dist_cnt       NUMBER:=0;
        dist_max       giuw_pol_dist.dist_no%TYPE;
        dist_min       giuw_pol_dist.dist_no%TYPE;
        
        p_message      VARCHAR2(3000); -- kris : where all msg_alert(s) are assigned.
        
        CURSOR  C1 IS
            SELECT distinct  frps_yy,
                             frps_seq_no
              FROM giri_wdistfrps
             WHERE dist_no = p_dist_no;
        CURSOR  C2 IS
            SELECT distinct  frps_yy,
                             frps_seq_no
              FROM giri_distfrps
             WHERE dist_no = p_dist_no;

    /*main*/
    BEGIN
          BEGIN--1--
            /*  SELECT    sum(tsi_amt     * currency_rt),
                        sum(ann_tsi_amt * currency_rt),
                        sum(prem_amt    * currency_rt)
                INTO    v_tsi_amt,
                        v_ann_tsi_amt,
                        v_prem_amt
                FROM    gipi_witem
               WHERE    par_id = b_par_id;
               IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL)
                  OR (v_prem_amt IS NULL)) THEN
                  SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
                  MSG_ALERT('Insufficient information on the TSI amount, annual TSI amount '||
                            'and premium amount for this ITEM.','E',TRUE);
               END IF;
              EXCEPTION
               WHEN NO_DATA_FOUND THEN
                   SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
                   SHOW_VIEW('CG$STACKED_HEADER_1');
                 MSG_ALERT('Pls. be adviced that there are no items for this PAR.','E',TRUE); */
            -------------------------------------------------------03.05.08
            FOR array_loop IN (SELECT sum(tsi_amt     * currency_rt) tsi_amt,
                                                    sum(ann_tsi_amt * currency_rt) ann_tsi_amt,
                                      sum(prem_amt    * currency_rt) prem_amt,
                                                    item_grp
                                                 FROM gipi_witem
                                                   WHERE par_id = b_par_id
                                            GROUP BY item_grp)
            LOOP
                IF ((array_loop.tsi_amt IS NULL) OR (array_loop.ann_tsi_amt IS NULL)
                OR (array_loop.prem_amt IS NULL)) THEN
                    p_message := 'Insufficient information on the TSI amount, annual TSI amount '||
                              'and premium amount for this ITEM.';
                END IF;
                
                varray_cnt                 := varray_cnt + 1;
                vv_tsi_amt(varray_cnt)     := array_loop.tsi_amt;
                vv_ann_tsi_amt(varray_cnt) := array_loop.ann_tsi_amt;
                vv_prem_amt(varray_cnt)    := array_loop.prem_amt;
                vv_item_grp(varray_cnt)    := array_loop.item_grp;
            END LOOP;    
                
            IF varray_cnt = 0 THEN
                p_message := 'Pls. be adviced that there are no items for this PAR.';
            END IF;
            -------------------------------------------------------  
          END;--1--
      
          SELECT   distinct dist_no
            INTO   pi_dist_no
            FROM   giuw_pol_dist
           WHERE   par_id   =   b_par_id;
      
          BEGIN--2--
            SELECT    distinct 1
              INTO    b_exist
              FROM    giuw_policyds
             WHERE    dist_no  =  pi_dist_no;
            IF  sql%FOUND THEN
                p_message := 'This PAR has an existing records in the posted POLICY table. Could not proceed.';
            ELSE
                RAISE NO_DATA_FOUND;
            END IF;
            
          EXCEPTION--2--
            WHEN NO_DATA_FOUND THEN
                NULL;
          END;--2--
      
          BEGIN--3--
            SELECT   distinct 1
              INTO   p_exist
              FROM   giuw_wpolicyds
             WHERE   dist_no  =  pi_dist_no;
           
            /*alert_id   := FIND_ALERT('DISTRIBUTION');
            alert_but  := SHOW_ALERT(ALERT_ID);
            
            IF alert_but = ALERT_BUTTON1 THEN
                x_but := 1;
            ELSE
                x_but := 2;
            END IF;*/ -- commented out by Kris 12.11.2012
            
          EXCEPTION--3--
            WHEN NO_DATA_FOUND THEN
              --x_but := 1;
              p_exist := 1; -- added by Kris 12.11.2012
          END;--3--
      
          /*IF x_but = 2 THEN
          
            HIDE_VIEW('WARNING');
            SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
            SHOW_VIEW('CG$STACKED_HEADER_1');
            RAISE FORM_TRIGGER_FAILURE;
          ELSE*/      -- commented out by Kris 12.11.2012
          
          IF p_exist = 1 THEN
            FOR C1_rec IN C1 LOOP
              DELETE   giri_wfrperil
               WHERE   frps_yy     =   C1_rec.frps_yy
                 AND   frps_seq_no =   C1_rec.frps_seq_no;
              DELETE   giri_wfrps_ri
               WHERE   frps_yy     =   C1_rec.frps_yy
                 AND   frps_seq_no =   C1_rec.frps_seq_no;
              DELETE   giri_wdistfrps
               WHERE   dist_no = pi_dist_no;  
            END LOOP;
            
            FOR C2_rec IN C2 LOOP
              p_message := 'This PAR has corresponding records in the posted tables for RI. Could not proceed.';
            END LOOP;
              
            DELETE   giuw_wperilds_dtl
             WHERE   dist_no  =  pi_dist_no;
            DELETE   giuw_witemds_dtl
             WHERE   dist_no  =  pi_dist_no;
            DELETE   giuw_wpolicyds_dtl
             WHERE   dist_no  =  pi_dist_no;
            DELETE   giuw_wperilds
             WHERE   dist_no  =  pi_dist_no;
            DELETE   giuw_witemds
             WHERE   dist_no  =  pi_dist_no;
            DELETE   giuw_wpolicyds
             WHERE   dist_no  =  pi_dist_no;
              
            ------------------------------------------------------
            IF vv_item_grp.exists(1) THEN
                  FOR cnt IN vv_item_grp.FIRST.. vv_item_grp.LAST LOOP                         
                        BEGIN--4--
                                  SELECT count(dist_no), max(dist_no), min(dist_no)    --add min(dist_no) and filter item_grp
                                    INTO dist_cnt, dist_max, dist_min
                                    FROM giuw_pol_dist
                                   WHERE par_id = b_par_id
                                     AND NVL(item_grp, vv_item_grp(cnt)) = vv_item_grp(cnt);
                        END;--4--

                        IF dist_cnt = 1 THEN
                            v_tsi_amt     := v_tsi_amt + vv_tsi_amt(cnt);
                            v_ann_tsi_amt := v_ann_tsi_amt + vv_ann_tsi_amt(cnt);
                            v_prem_amt    := v_prem_amt + vv_prem_amt(cnt);
                        ELSIF pi_dist_no BETWEEN dist_min AND dist_max THEN
                            v_tsi_amt     := vv_tsi_amt(cnt);
                            v_ann_tsi_amt := vv_ann_tsi_amt(cnt);
                            v_prem_amt    := vv_prem_amt(cnt);                          
                            EXIT;               
                        END IF;
                                      
                  END LOOP;
                  
            END IF;
            -------------------------------------------------------
            IF pi_dist_no = dist_max THEN 
                UPDATE giuw_pol_dist
                   SET tsi_amt         = NVL(v_tsi_amt,0) - (ROUND((NVL(v_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)), 
                       prem_amt      = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                       ann_tsi_amt   = NVL(v_ann_tsi_amt,0) - (ROUND((NVL(v_ann_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                       last_upd_date =  sysdate,
                       user_id       =  user
                 WHERE par_id  =  b_par_id
                   AND dist_no =  pi_dist_no;                     
            ELSE
                UPDATE giuw_pol_dist
                   SET tsi_amt         = NVL(v_tsi_amt,0) / dist_cnt, 
                       prem_amt      = NVL(v_prem_amt,0) / dist_cnt,
                       ann_tsi_amt   = NVL(v_ann_tsi_amt,0) / dist_cnt,
                       last_upd_date =  sysdate,
                       user_id       =  user
                 WHERE par_id  =  b_par_id
                   AND dist_no =  pi_dist_no;
            END IF;
            
          END IF;

    EXCEPTION/*main*/
          WHEN TOO_MANY_ROWS THEN
            p_message := 'There are too many distribution numbers assigned for this item. '||
                         'Please call your administrator to rectify the matter. Check '||
                         'records in the policy table with par_id = '||to_char(b_par_id)||'.';
                      
          WHEN NO_DATA_FOUND THEN
            -----------------------
                DECLARE                  
                  p_no_of_takeup          GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
                  p_yearly_tag            GIIS_TAKEUP_TERM.yearly_tag%TYPE;
                  p_takeup_term           GIPI_WPOLBAS.takeup_term%TYPE;                              
                
                  v_policy_days           NUMBER:=0;
                  v_no_of_payment         NUMBER:=1;
                  v_duration_frm          DATE;
                  v_duration_to           DATE;    
                  v_days_interval         NUMBER:=0;
        
                BEGIN--5--
                    SELECT eff_date,
                           expiry_date,
                           endt_type,
                           takeup_term
                      INTO p_eff_date,
                           p_expiry_date,
                           p_endt_type,
                           p_takeup_term
                      FROM gipi_wpolbas
                     WHERE par_id  =  b_par_id;
                  
                        IF ((p_eff_date IS NULL ) OR (p_expiry_date IS NULL)) THEN
                            p_message := 'Could not proceed. The effectivity date or expiry date had not been updated.';
                        END IF;
                  
                        IF TRUNC(p_expiry_date - p_eff_date) = 31 THEN
                            v_policy_days      := 30;
                        ELSE
                            v_policy_days      := TRUNC(p_expiry_date - p_eff_date);
                        END IF;
                                            
                        FOR b1 IN (SELECT no_of_takeup, yearly_tag
                                     FROM giis_takeup_term
                                    WHERE takeup_term = p_takeup_term)
                        LOOP
                            p_no_of_takeup := b1.no_of_takeup;
                            p_yearly_tag   := b1.yearly_tag;
                        END LOOP;
                                            
                        IF p_yearly_tag = 'Y' THEN
                            IF TRUNC((v_policy_days)/365,2) * p_no_of_takeup >
                                TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) THEN
                                    v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) + 1;
                            ELSE
                                    v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup);
                            END IF;
                        ELSE
                            IF v_policy_days < p_no_of_takeup THEN
                                v_no_of_payment := v_policy_days;
                            ELSE
                                v_no_of_payment := p_no_of_takeup;
                            END IF;
                        END IF;
                                            
                        IF v_no_of_payment < 1 THEN
                            v_no_of_payment := 1;
                        END IF;
                                            
                        v_days_interval := ROUND(v_policy_days/v_no_of_payment);
                        p_policy_id := NULL;
                        
                        IF v_no_of_payment = 1 THEN -------------------------------------------------------- IF: Single takeup (x)                            
                            DECLARE
                              CURSOR C IS
                                SELECT POL_DIST_DIST_NO_S.NEXTVAL
                                  FROM SYS.DUAL;
                            BEGIN--6--
                              OPEN C;
                              FETCH C
                              INTO    p2_dist_no;
                                IF C%NOTFOUND THEN
                                  p_message := 'No row in table SYS.DUAL';
                                END IF;
                              CLOSE C;
                            EXCEPTION--6--
                              WHEN OTHERS THEN
                                  --CGTE$OTHER_EXCEPTIONS;
                                  NULL;
                            END;--6--
                      
                            INSERT INTO giuw_pol_dist
                                        (dist_no, par_id, policy_id, endt_type, tsi_amt,
                                         prem_amt, ann_tsi_amt, dist_flag, redist_flag,
                                         eff_date, expiry_date, create_date, user_id,
                                         last_upd_date)
                            VALUES      (p2_dist_no,b_par_id,p_policy_id,p_endt_type,NVL(v_tsi_amt,0),
                                         NVL(v_prem_amt,0),NVL(v_ann_tsi_amt,0),1,1,
                                         p_eff_date,p_expiry_date,sysdate,user,
                                         sysdate);
                        ELSE --------------------------------------------------------------------------------- ELSE: MULTI TAKE-UP (x)
                        --------------------------------------------------------------------------------- LONG TERM LOOP start
                            v_duration_frm := NULL;
                            v_duration_to  := NULL;                                    
                            
                            FOR takeup_val IN 1.. v_no_of_payment LOOP 
                               
                                IF v_duration_frm IS NULL THEN
                                    v_duration_frm := TRUNC(p_eff_date);                                             
                                ELSE
                                    v_duration_frm := TRUNC(v_duration_frm + v_days_interval);                           
                                END IF;
                                
                                v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
                                
                                DECLARE
                                    CURSOR C IS
                                      SELECT    POL_DIST_DIST_NO_S.NEXTVAL
                                        FROM    SYS.DUAL;
                      
                                BEGIN--7--
                                    OPEN C;
                                    FETCH C
                                    INTO    p2_dist_no;
                                    
                                        IF C%NOTFOUND THEN
                                                p_message :=  'No row in table SYS.DUAL';
                                        END IF;
                                    
                                    CLOSE C;
                                EXCEPTION--7--
                                    WHEN OTHERS THEN
                                      --CGTE$OTHER_EXCEPTIONS;
                                      NULL;
                                END;--7--
                                
                                IF takeup_val = v_no_of_payment THEN --------------------------------------------- IF: last loop record (y)
                                    INSERT INTO giuw_pol_dist
                                           (dist_no, par_id, policy_id, endt_type, 
                                            dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                            last_upd_date, post_flag, auto_dist,
                                            tsi_amt, 
                                            prem_amt, 
                                            ann_tsi_amt)
                                    VALUES (p2_dist_no,b_par_id,p_policy_id,p_endt_type,                                                            
                                            1, 1, v_duration_frm,v_duration_to,sysdate,user,
                                            sysdate, 'O', 'N',
                                            NVL(v_tsi_amt,0) - (ROUND((NVL(v_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                            NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                            NVL(v_ann_tsi_amt,0) - (ROUND((NVL(v_ann_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)));
                                ELSE ----------------------------------------------------------------------------- ELSE: other loop records (y)
                                    INSERT INTO giuw_pol_dist
                                           (dist_no, par_id, policy_id, endt_type, 
                                            dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                            last_upd_date, post_flag, auto_dist,
                                            tsi_amt, 
                                            prem_amt, 
                                            ann_tsi_amt)
                                    VALUES (p2_dist_no,b_par_id,p_policy_id,p_endt_type,                                                            
                                            1,1,v_duration_frm,v_duration_to,sysdate,user,
                                            sysdate, 'O', 'N',
                                            (NVL(v_tsi_amt,0)/ v_no_of_payment),
                                            (NVL(v_prem_amt,0)/ v_no_of_payment),
                                            (NVL(v_ann_tsi_amt,0)/ v_no_of_payment));
                                END IF; -------------------------------------------------------------------------- END IF: loop record (y)
                            END LOOP;
                            ------------------------------------------------------------------------------------ LONG TERM LOOP end        
                        END IF; ------------------------------------------------------------------------------ END IF TAKEUPS (x)    
                
                EXCEPTION--5--                   
                  WHEN NO_DATA_FOUND THEN
                    p_message := 'You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.';
                  
                  WHEN TOO_MANY_ROWS THEN              
                    p_message := 'Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||
                                 'to rectify the matter. Check record with par_id = '||to_char(b_par_id);
                END; --5--
        --------------------------------------------------------------03.05.08                                                    
        --MESSAGE('Deleting non-existent item group for distribution...', NO_ACKNOWLEDGE);
            DELETE FROM giuw_pol_dist a
             WHERE par_id = b_par_id
               AND dist_no = pi_Dist_no
               AND NOT EXISTS (SELECT 1 
                                 FROM gipi_witem b
                                WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
                                  AND b.par_id = a.par_id);
        --------------------------------------------------------------
        
    END create_distribution; /*main*/ 

    
    
   
    
    
    /*
    ** Created by       : Marie Kris N. Felipe
    ** Date Created     : December 10, 2012
    ** Reference by     : GIPIS173 - Endorsement - Limits of Liabilities Data Entry
    ** Description      : To delete the related records of the limit of liability using the 
    **                      Pre-Delete Trigger of B920 
    **                      Invoked by DEL_WOPEN_LIAB Procedure 
    */
    PROCEDURE B920_pre_delete(
        p_par_id    IN  gipi_wopen_liab.par_id%TYPE,
        p_geog_cd   IN  gipi_wopen_liab.geog_cd%TYPE
    ) IS
        CURSOR A IS
          SELECT dist_no
            FROM giuw_pol_dist
           WHERE par_id   = p_par_id;
        CURSOR B (p_dist_no   giri_wdistfrps.dist_no%TYPE) IS
          SELECT frps_seq_no,
                 frps_yy
            FROM giri_wdistfrps
           WHERE dist_no  =  p_dist_no;
           
     BEGIN 
     
        FOR A1 IN A LOOP
              GIUW_WPERILDS_DTL_PKG.DEL_GIUW_WPERILDS_DTL(A1.dist_no);
              GIUW_WITEMDS_DTL_PKG.DEL_GIUW_WITEMDS_DTL(A1.dist_no);
              GIUW_WPOLICYDS_DTL_PKG.DEL_GIUW_WPOLICYDS_DTL(A1.dist_no);
              GIUW_WPERILDS_PKG.DEL_GIUW_WPERILDS(A1.dist_no);
              GIUW_WITEMDS_PKG.DEL_GIUW_WITEMDS(A1.dist_no);
              GIUW_WPOLICYDS_PKG.DEL_GIUW_WPOLICYDS(A1.dist_no);              
               
            FOR B1 IN B(A1.dist_no) LOOP
              
               GIRI_WDISTFRPS_PKG.DEL_GIRI_WDISTFRPS1(B1.frps_seq_no, B1.frps_yy);
              
            END LOOP;
            
            GIUW_POL_DIST_PKG.DEL_GIUW_POL_DIST(A1.dist_no);
             
        END LOOP;
           
        
        GIPI_WITMPERL_PKG.DEL_GIPI_WITMPERL2(p_par_id);
        GIPI_WITEM_PKG.DEL_ALL_GIPI_WITEM(p_par_id);
        
        GIPI_WOPEN_PERIL_PKG.del_all_gipi_wopen_peril(p_par_id, p_geog_cd);
        
     END B920_pre_delete;
     
    
    
    
    /*
    ** Created by       : Marie Kris Felipe
    ** Date Created     : December 18, 2012
    ** Reference by     : GIPIS173 - Endorsement - Limits of Liabilities Data Entry
    ** Description      : Gets the default value of currency code and currency rate
    **                    from original policy
    */

    PROCEDURE get_default_currency(
        p_line_cd       IN          GIPI_WPOLBAS.line_cd%type,
        p_subline_cd    IN          GIPI_WPOLBAS.subline_cd%type,
        p_iss_cd        IN          GIPI_WPOLBAS.iss_cd%type,
        p_issue_yy      IN          GIPI_WPOLBAS.issue_yy%type,
        p_pol_seq_no    IN          GIPI_WPOLBAS.pol_seq_no%type,
        p_renew_no      IN          GIPI_WPOLBAS.renew_no%type,
        p_currency_cd   OUT         GIPI_WOPEN_LIAB.currency_cd%type,
        p_currency_rt   IN OUT      GIPI_WOPEN_LIAB.currency_rt%type,
        p_currency_desc IN OUT      GIIS_CURRENCY.currency_desc%type
    ) IS

    BEGIN
        IF p_currency_rt IS NULL AND p_currency_desc IS NULL THEN
            FOR CURRENCY IN ( SELECT currency_cd, currency_rt
                               FROM gipi_open_liab
                              WHERE policy_id = ( SELECT policy_id
                                                    FROM gipi_polbasic
                                                   WHERE line_cd = p_line_cd
                                                     AND subline_cd = p_subline_cd
                                                     AND iss_cd = p_iss_cd
                                                     AND issue_yy = p_issue_yy
                                                     AND pol_seq_no = p_pol_seq_no
                                                     AND renew_no = p_renew_no
                                                     AND NVL(endt_seq_no, 0) = 0) ) LOOP
               p_currency_rt     := currency.currency_rt;
               p_currency_cd     := currency.currency_cd;
                           
               FOR DESCRIPTION IN ( SELECT currency_desc
                                      FROM giis_currency
                                     WHERE main_currency_cd = currency.currency_cd ) LOOP
                   p_currency_desc    := description.currency_desc;
                   EXIT;
                   
               END LOOP;
            END LOOP;        
        END IF;      
    END get_default_currency;      
    
    
    
     /*
    ** Created by       : Marie Kris Felipe
    ** Date Created     : December 18, 2012
    ** Reference by     : GIPIS173 - Endorsement - Limits of Liabilities Data Entry
    ** Description      : Deletes the limit of liability and all its related records
    */
    PROCEDURE del_wopen_liab(
        p_par_id    IN  gipi_wopen_liab.par_id%TYPE,
        p_geog_cd   IN  gipi_wopen_liab.geog_cd%TYPE
    ) IS
        v_wrn_delete    VARCHAR2(100) := '';
    BEGIN
        
         GIPIS173_PKG.B920_pre_delete(p_par_id, p_geog_cd);
         
         DELETE FROM GIPI_WOPEN_LIAB
          WHERE PAR_ID = p_par_id 
            AND GEOG_CD = p_geog_cd; 
         
    END del_wopen_liab;
    
    -----------------------------------
    
    
    /*
    ** Created by       : Marie Kris Felipe
    ** Date Created     : December 12, 2012
    ** Reference by     : GIPIS173 - Endorsement - Limits of Liabilities Data Entry
    ** Description      : To get the record flag.  
    **                      Based from the WHEN-VALIDATE-RECORD Trigger of B970 in GIPIS173
    */
    PROCEDURE get_rec_flag(
        p_geog_cd         IN GIPI_WOPEN_LIAB.geog_cd%TYPE,
        p_line_cd         IN GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd      IN GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd          IN GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy        IN GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no      IN GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_peril_cd        IN GIPI_WOPEN_PERIL.peril_cd%type,
        p_rec_flag        IN OUT GIPI_WOPEN_LIAB.rec_flag%TYPE,
        p_message         IN OUT VARCHAR2
    ) IS
    
    BEGIN
        p_message := 'SUCCESS'; -- Kris
        
     /* IF :SYSTEM.BLOCK_STATUS='CHANGED' OR 
         :SYSTEM.BLOCK_STATUS='NEW' THEN
         :CG$CTRL.sup_post_form := 'Y';*/ -- commented out by Kris 12.12.2012
        DECLARE
          v_eff_date DATE;
          v_peril_cd NUMBER(2);
          v_rec_flag VARCHAR2(1);
         BEGIN
               IF p_rec_flag='D' THEN
                  BEGIN
                    DECLARE
                        CURSOR c1 IS SELECT MAX(a.eff_date),
                                         a.peril_cd
                                    FROM gipi_open_peril_v a
                                   WHERE a.geog_cd    = p_geog_cd
                                     AND a.line_cd    = p_line_cd
                                     AND a.subline_cd = p_subline_cd
                                     AND a.iss_cd     = p_iss_cd
                                     AND a.issue_yy   = p_issue_yy
                                     AND a.pol_seq_no = p_pol_seq_no
                                     AND a.rec_flag <>'D'
                                GROUP BY a.peril_cd;
                        v_response NUMBER(2);
                     BEGIN 
                            SELECT MAX(a.eff_date),a.peril_cd
                              INTO v_eff_date,v_peril_cd
                              FROM gipi_open_peril_v a
                             WHERE a.geog_cd    = p_geog_cd
                               AND a.line_cd    = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.iss_cd     = p_iss_cd
                               AND a.issue_yy   = p_issue_yy
                               AND a.pol_seq_no = p_pol_seq_no
                               AND a.peril_cd   = p_peril_cd
                               AND a.rec_flag <>'D'
                          GROUP BY a.peril_cd;                                       
                           BEGIN
                                 /*v_response :=SHOW_ALERT('DELETE_PERIL_ALERT');
                                 IF v_response=89 THEN
                                    RAISE FORM_TRIGGER_FAILURE;
                                 END IF; */  -- commented out by Kris 12.12.2012
                                 p_rec_flag:='D';
                           END;
                     END;
                  END;
               END IF;
                
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_rec_flag:='A';
         END;     
      
         DECLARE
              v_eff_date DATE;
              v_peril_cd NUMBER(2);
              v_rec_flag VARCHAR2(1);
              
         BEGIN 
              v_eff_date:=null;
              SELECT MAX(b.eff_date),
                     a.rec_flag
                INTO v_eff_date,
                     v_rec_flag   
                FROM gipi_open_peril_v2 a, gipi_polbasic b
               WHERE a.peril_cd      = p_peril_cd
                 AND a.geog_cd       = p_geog_cd
                 AND a.line_cd       = p_line_cd
                 AND a.op_subline_cd = p_subline_cd
                 AND a.op_iss_cd     = p_iss_cd
                 AND a.op_pol_seqno  = p_pol_seq_no
                 AND a.policy_id     = b.policy_id     
            GROUP BY a.rec_flag;
             BEGIN  
               IF (v_rec_flag='D') THEN
                  p_rec_flag:='A';
               ELSE
                  BEGIN
                    IF p_rec_flag='D' THEN
                       p_message := 'There is an existing Risk Note using this peril';                                           
                    END IF;
                  END;
               END IF;
                
             EXCEPTION
               WHEN NO_DATA_FOUND THEN 
                  NULL;
             END;
         END;
     /* END IF; */ -- commented out by Kris 12.12.2012
      
    EXCEPTION
       WHEN NO_DATA_FOUND THEN        
          NULL;
    END get_rec_flag;
    
    
    
    /*
    ** Created by       : Marie Kris Felipe
    ** Date Created     : December 12, 2012
    ** Reference by     : GIPIS173 - Endorsement - Limits of Liabilities Data Entry
    ** Description      : Executes post actions from Post-Forms-Commit Trigger of GIPIS173
    */
    PROCEDURE post_forms_commit(
        p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE,
        p_iss_cd     IN GIPI_WPOLBAS.iss_cd%TYPE,
        p_line_cd    IN GIPI_WPOLBAS.line_cd%TYPE
    ) IS
      p_dist_no     NUMBER;
      p_exist2      NUMBER;
      v_exist       VARCHAR2(1) := 'N';
      v_exist1      VARCHAR2(1) := 'N';
      CURSOR A IS
         SELECT  dist_no
           FROM  giuw_pol_dist
          WHERE  par_id   =  p_wopen_liab.par_id;
      CURSOR B IS
         SELECT dist_no
           FROM giuw_pol_dist
          WHERE par_id   = p_wopen_liab.par_id;
      CURSOR C(p_dist_no   giri_wdistfrps.dist_no%TYPE) IS
         SELECT frps_seq_no,
                frps_yy
           FROM giri_wdistfrps
          WHERE dist_no  =  p_dist_no;
    BEGIN
        
         /* IF :cg$ctrl.post IS NOT NULL THEN
             RETURN;
          END IF;

          IF :CG$CTRL.sup_post_form != 'Y' OR 
             :CG$CTRL.sup_post_form IS NULL THEN
             RETURN;
          END IF;*/ -- commented out by Kris

           GIPIS173_PKG.INSERT_INTO_GIPI_WITEM(p_wopen_liab);
           
           /*OPEN A;
           FETCH A INTO p_dist_no;
           IF A%notfound THEN
               p_dist_no  :=  0;
           END IF;
           CLOSE A;*/
           
           BEGIN
             SELECT   distinct 1
               INTO   p_exist2
               FROM   gipi_wopen_peril
              WHERE   par_id  =  p_wopen_liab.par_id;
              
             GIPIS173_PKG.INSERT_INTO_GIPI_WITMPERL(p_wopen_liab.par_id, p_wopen_liab.limit_liability, p_line_cd, p_iss_cd);
             
             FOR A1 in A
             LOOP
                 GIPIS173_PKG.CREATE_DISTRIBUTION(p_wopen_liab.par_id, A1.dist_no);
                 
             END LOOP;     
            /* :CG$CTRL.sup_post_form  := 'N';
             :cg$ctrl.dsp_limit_liab := :b920.limit_liability;*/ -- commented out by Kris
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
                GIPI_WINVPERL_PKG.del_gipi_winvperl_1(p_wopen_liab.par_id);
                GIPI_WINV_TAX_PKG.del_all_gipi_winv_tax(p_wopen_liab.par_id);
                GIPI_WINSTALLMENT_PKG.del_gipi_winstallment_1(p_wopen_liab.par_id);
                GIPI_WCOMM_INV_PERILS_PKG.del_gipi_wcomm_inv_perils1(p_wopen_liab.par_id);
                GIPI_WCOMM_INVOICES_PKG.del_gipi_wcomm_invoices_1(p_wopen_liab.par_id);
                GIPI_WINVOICE_PKG.del_gipi_winvoice(p_wopen_liab.par_id);
                
                FOR B1 IN B LOOP
                    GIUW_WPERILDS_DTL_PKG.del_giuw_wperilds_dtl(B1.dist_no);
                    GIUW_WITEMDS_DTL_PKG.del_giuw_witemds_dtl(B1.dist_no);
                    GIUW_WPOLICYDS_DTL_PKG.del_giuw_wpolicyds_dtl(B1.dist_no);
                    GIUW_WPERILDS_PKG.del_giuw_wperilds(B1.dist_no);
                    GIUW_WITEMDS_PKG.del_giuw_witemds(B1.dist_no);
                    GIUW_WPOLICYDS_PKG.del_giuw_wpolicyds(B1.dist_no);
                 
                    FOR C1 IN C(B1.dist_no) LOOP
                    
                       GIRI_WDISTFRPS_PKG.del_giri_wdistfrps1(C1.frps_seq_no, C1.frps_yy);
                       
                    END LOOP;
                   
                   GIUW_POL_DIST_PKG.del_giuw_pol_dist(B1.dist_no); 
                   
                END LOOP;
                   GIPI_WITMPERL_PKG.DEL_GIPI_WITMPERL2(p_wopen_liab.par_id);
                   GIPI_WITEM_PKG.del_all_gipi_witem(p_wopen_liab.par_id);
                   
              FOR A IN (SELECT   par_id,par_status
                          FROM   gipi_parlist
                         WHERE   par_id  =  p_wopen_liab.par_id
                        FOR UPDATE OF par_id, par_status) 
              LOOP
                GIPI_PARLIST_PKG.update_par_status(A.par_id, 3);
                EXIT;
              END LOOP;  -- End a cursor
           END;
           
           UPD_GIPI_WPOLBAS(p_wopen_liab.PAR_ID); --  This is a procedure outside of the package
           
    END post_forms_commit;
    
    
    /*
    ** Created by   : Marie Kris Felipe
    ** Date Created: December 6, 2012
    ** Reference by: GIPIS173 - Endorsement - Limits of Liabilities Data Entry
    ** Description: Executes WHEN-NEW-FORM-INSTANCE Trigger of GIPIS173
    */
    PROCEDURE select_item_gipi (
        p_par_id        IN      GIPI_WPOLBAS.PAR_ID%type,
        p_msg_alert     OUT     VARCHAR2
    ) 
    IS
        v_open_policy_sw      giis_subline.open_policy_sw%TYPE;
        v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
    BEGIN
    
      SELECT     a.op_flag, a.subline_cd
        INTO     v_open_policy_sw, v_subline_cd
        FROM     giis_subline a, gipi_wpolbas b
       WHERE     a.line_cd  =  b.line_cd
         AND     a.subline_cd  =  b.subline_cd
         AND     b.par_id      =  p_par_id;
         
      IF v_open_policy_sw = 'Y' THEN
         NULL;
      ELSE
         p_msg_alert := 'The subline_cd ( '||v_subline_cd||' ) used for par_id ( '||p_par_id||
                   ' ) is not validated to enter this module.';
      END IF;
      
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg_alert := 'You are not validated to enter this module.';
    END;
    
END GIPIS173_PKG;
/


