CREATE OR REPLACE PROCEDURE CPI.Create_Negated_Records_Prorate (
	p_par_id				IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd				IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd			IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd				IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy				IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no			IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no				IN GIPI_WPOLBAS.renew_no%TYPE,
	p_co_insurance_sw		IN GIPI_WPOLBAS.co_insurance_sw%TYPE,
	p_pack_pol_flag			IN VARCHAR2,
	p_prorate_flag			IN GIPI_WPOLBAS.prorate_flag%TYPE,
	p_comp_sw				IN GIPI_WPOLBAS.comp_sw%TYPE,
	p_nbt_short_rt_pct		IN GIPI_WPOLBAS.short_rt_percent%TYPE,
	p_in_eff_date			IN GIPI_WPOLBAS.eff_date%TYPE,	
    p_in_incept_date        IN GIPI_POLBASIC.incept_date%TYPE,
	p_v_expiry_date			OUT VARCHAR2,
	p_v_incept_date            OUT    VARCHAR2,
    p_incept_date            OUT    VARCHAR2,
    p_expiry_date            OUT VARCHAR2,
    p_endt_expiry_date        OUT VARCHAR2,
    p_tsi_amt                OUT GIPI_WPOLBAS.tsi_amt%TYPE,
    p_prem_amt                OUT GIPI_WPOLBAS.prem_amt%TYPE,
    p_ann_tsi_amt            OUT GIPI_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt            OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
    p_msg_alert                OUT VARCHAR2)
AS
    v_max_eff_date1        GIPI_WPOLBAS.eff_date%TYPE;
    v_max_eff_date2        GIPI_WPOLBAS.eff_date%TYPE;
    v_max_eff_date        GIPI_WPOLBAS.eff_date%TYPE;
    v_eff_date            GIPI_WPOLBAS.eff_date%TYPE;
    v_max_endt_seq_no    GIPI_WPOLBAS.endt_seq_no%TYPE;
    v_max_endt_seq_no1    GIPI_WPOLBAS.endt_seq_no%TYPE;
    v_no_of_days        NUMBER;
    v_days_of_policy    NUMBER;
    v_prorate_prem        GIPI_ITMPERIL.prem_amt%TYPE;
    v_prorate_tsi        GIPI_ITMPERIL.tsi_amt%TYPE;
    v_peril                GIPI_WITMPERL.peril_cd%TYPE;
    v_comm_amt            GIPI_WITMPERL.ri_comm_amt%TYPE;
    
    v_policy_id            GIPI_POLBASIC.policy_id%TYPE;
    v_v_expiry_date        DATE;
    v_v_incept_date        DATE;
    v_menu_line	GIIS_LINE.menu_line_cd%TYPE;
BEGIN
    v_v_expiry_date := Extract_Expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    v_v_incept_date := Extract_Incept(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    
    Delete_Other_Info(p_par_id);
    Delete_Records(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
        p_in_eff_date, p_co_insurance_sw, p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert);    
    
    IF NOT p_msg_alert IS NULL THEN
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    Gipi_Polbasic_Pkg.get_eff_date_policy_id(p_line_cd, p_subline_cd, p_iss_cd,
        p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date, v_policy_id);
    
    v_max_endt_seq_no := Gipi_Polbasic_Pkg.get_max_endt_seq_no(p_line_cd, p_subline_cd, p_iss_cd,
        p_issue_yy, p_pol_seq_no, p_renew_no, p_in_eff_date, 'PRORATE_CANCELLATION');
    
    IF v_max_endt_seq_no > 0 THEN
        v_max_endt_seq_no1 := Gipi_Polbasic_Pkg.get_max_endt_seq_no_back_stat(p_line_cd, p_subline_cd, p_iss_cd,
            p_issue_yy, p_pol_seq_no, p_renew_no, p_in_eff_date, 'PRORATE_CANCELLATION');
        
        IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN
            v_max_eff_date1 := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd,
                p_issue_yy, p_pol_seq_no, p_renew_no, p_in_eff_date, v_max_endt_seq_no1, 'PRORATE_CANCELLATION');
            
            v_max_eff_date2 := Gipi_Polbasic_Pkg.get_endt_max_eff_date(p_line_cd, p_subline_cd, p_iss_cd,
                p_issue_yy, p_pol_seq_no, p_renew_no, p_in_eff_date, 'PRORATE_CANCELLATION');
            
            v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);
        ELSE
            v_max_eff_date := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd,
                p_issue_yy, p_pol_seq_no, p_renew_no, p_in_eff_date, v_max_endt_seq_no1, 'PRORATE_CANCELLATION');
        END IF;
    ELSE
        v_max_eff_date := v_eff_date;
    END IF;
    
    -- get latest data for dates coming from latest endt. 
    -- (backward endt. is considered)
    FOR DT IN (
        SELECT b250.incept_date, b250.expiry_date
          FROM GIPI_POLBASIC b250
         WHERE b250.line_cd    = p_line_cd
           AND b250.subline_cd = p_subline_cd
           AND b250.iss_cd     = p_iss_cd
           AND b250.issue_yy   = p_issue_yy
           AND b250.pol_seq_no = p_pol_seq_no
           AND b250.renew_no   = p_renew_no
           AND b250.pol_flag   IN ('1','2','3','X') 
           AND b250.eff_date   = v_max_eff_date 
      ORDER BY b250.endt_seq_no DESC)
    LOOP        
        p_incept_date      := TO_CHAR(dt.incept_date, 'MM-DD-RRRR HH:MI:SS AM');
        p_expiry_date      := TO_CHAR(dt.expiry_date, 'MM-DD-RRRR HH:MI:SS AM');
        p_endt_expiry_date := TO_CHAR(dt.expiry_date, 'MM-DD-RRRR HH:MI:SS AM');        
        EXIT;
    END LOOP;
    
    --d.alcantara, nilipat muna dito mula GIPIS031_CREATE_ITEM_FOR_LINE 
    --hindi naman kasi item related ang pag-insert sa gipi_wengg_basic; nagkakaerror pag more than 1 item yung kinacancel sa web
    BEGIN
		SELECT NVL(menu_line_cd, line_cd) menu_line
		  INTO v_menu_line
		  FROM GIIS_LINE
		 WHERE line_cd = p_line_cd;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_menu_line := NULL;
	END;
    
    IF p_line_cd = 'EN' OR v_menu_line = 'EN' THEN 
        GIPIS031_CREATE_ENGR_ITEM(p_par_id, null);
    END IF;
    -- 
    
    --create negated records in table gipi_witem,gipi_witmperl
    --select first all existing item from policy and all it's endt.                          
    FOR A1 IN (
        SELECT DISTINCT b340.item_no item_no, MAX(endt_seq_no) endt_seq_no
          FROM GIPI_POLBASIC b250, GIPI_ITEM b340
         WHERE b250.line_cd    = p_line_cd
           AND b250.subline_cd = p_subline_cd
           AND b250.iss_cd     = p_iss_cd
           AND b250.issue_yy   = p_issue_yy
           AND b250.pol_seq_no = p_pol_seq_no
           AND b250.renew_no   = p_renew_no
           AND b250.policy_id  = b340.policy_id
           AND TRUNC(
                    DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), 
                        b250.expiry_date, v_v_expiry_date, 
                        expiry_date, b250.endt_expiry_date)) >= TRUNC(p_in_eff_date)
           AND  b250.pol_flag IN ('1','2','3','X')
      GROUP BY item_no
      ORDER BY item_no)
    LOOP
        --call procedure that will get latest info. for every item
        --and insert it in table gipi_witem        
        Get_Neg_Item(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, a1.item_no);
        --change item grouping        
        Change_Item_Grp(p_par_id, p_pack_pol_flag);
        --summarized all peril for a particular item
        --and insert records in table gipi_witmperl
        
        IF p_prorate_flag = 1 THEN
            v_peril          := NULL;
            v_no_of_days     := NULL;
            v_days_of_policy := NULL;
            v_prorate_prem   := 0;
            v_prorate_tsi    := 0;
            v_comm_amt       := 0;
            
            BEGIN      -- AFPGEN SR-18683 : shan 07.16.2015
                SELECT endt_expiry_date  
                  INTO v_v_expiry_date
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
                 
            FOR A2 IN (
                SELECT b380.peril_cd peril, b380.prem_amt prem, b380.tsi_amt tsi, b380.ri_comm_amt comm,
                       b380.prem_rt rate, b380.ann_prem_amt, b380.ann_tsi_amt,
                       TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), 
                            b250.expiry_date, v_v_expiry_date, 
                            expiry_date,b250.endt_expiry_date)) expiry_date,
                       TRUNC(DECODE(b250.incept_date, 
                            b250.incept_date, v_v_incept_date, incept_date)) eff_date,
                       b250.prorate_flag, DECODE(NVL(comp_sw,'N'),'Y',1,'M',-1,0) comp_sw    
                  FROM GIPI_POLBASIC b250, GIPI_ITMPERIL b380
                 WHERE b250.line_cd    = p_line_cd
                   AND b250.subline_cd = p_subline_cd
                   AND b250.iss_cd     = p_iss_cd
                   AND b250.issue_yy   = p_issue_yy
                   AND b250.pol_seq_no = p_pol_seq_no
                   AND b250.renew_no   = p_renew_no                  
                   AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date),
                            b250.expiry_date, v_v_expiry_date,
                            expiry_date,b250.endt_expiry_date)) >= TRUNC(p_in_eff_date)
                   AND  b250.pol_flag   IN ('1','2','3','X') 
                   AND  b250.policy_id  = b380.policy_id
                   AND  b380.item_no    = A1.item_no
                   AND  b250.endt_seq_no = A1.endt_seq_no
              ORDER BY   b380.peril_cd) 
            LOOP
                v_no_of_days     := NULL;
                v_days_of_policy := NULL;
                
                IF v_peril IS NULL THEN
                    v_peril := a2.peril;             
                ELSIF v_peril  <> a2.peril THEN
                    INSERT INTO GIPI_WITMPERL (
                        par_id,            item_no,        line_cd,        peril_cd,        prem_rt,
                        tsi_amt,        prem_amt,        ann_tsi_amt,    ann_prem_amt,    rec_flag,
                        ri_comm_amt,    ri_comm_rate)
                    VALUES (
                        p_par_id,          a1.item_no,     p_line_cd,         v_peril,          0,
                        v_prorate_tsi,     v_prorate_prem, 0,                0,                'D',
                        v_comm_amt,        0);
                    v_peril        := a2.peril;
                    v_prorate_tsi  := 0;
                    v_prorate_prem := 0;
                    v_comm_amt     := 0;
                END IF;
                
                -- get no of days that a particular record exists
                -- in order to get correct computation of perm. per day
                --v_days_of_policy := TRUNC(a2.expiry_date) - TRUNC(a2.eff_date);    
                v_days_of_policy := TRUNC(a2.expiry_date) - TRUNC(p_in_incept_date);
                IF p_prorate_flag = 1 THEN
                   v_days_of_policy := v_days_of_policy + a2.comp_sw;    
                END IF;      
                --get no. of days that will be returned 
                IF p_comp_sw = 'Y' THEN
                    v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(p_in_eff_date))+ 1;             
                ELSIF p_comp_sw = 'M' THEN
                    v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(p_in_eff_date)) - 1;             
                ELSE
                    v_no_of_days  :=  TRUNC(a2.expiry_date) - TRUNC(p_in_eff_date);
                END IF;
                
                --for policy or endt with no of days less than the no. of days of cancelling
                --endt. no_of days of cancelling endt. should be equal to the no_of days
                --of policy/endt. on process
                IF NVL(v_no_of_days,0)> NVL(v_days_of_policy,0) THEN
                    v_no_of_days := v_days_of_policy;
                END IF;      
                --compute for negated premium for records with premium <> 0
                IF NVL(a2.prem,0) <> 0 THEN
                    -- reverted the codes below, apollo cruz, 11.04.2015 - sr#20590
                    --v_prorate_prem := v_prorate_prem + (-(a2.prem /v_days_of_policy)*(v_no_of_days));  -- replaced with code below :: AFPGEN SR-18683 : shan 07.16.2015
                    --v_prorate_prem := v_prorate_prem + (-(a2.tsi) * (v_no_of_days / check_duration(p_in_eff_date, v_v_expiry_date)) * (a2.rate / 100));
                    v_prorate_prem := (-(a2.ann_prem_amt) * (v_no_of_days / check_duration(p_in_eff_date, v_v_expiry_date))); -- Added by Jerome 01.31.2017
                END IF;
                --compute for negated commision_amt for records with commission <> 0
                IF NVL(a2.comm,0) <> 0 THEN
                    v_comm_amt := NVL(v_comm_amt,0) + (-(a2.comm /v_days_of_policy)*(v_no_of_days));
                END IF;
                --accumulate tsi amount
                --IF NVL(a2.tsi,a2.ann_tsi_amt) <> 0 THEN --Commented out by Jerome 01.31.2017
                    v_prorate_tsi  := v_prorate_tsi + -(NVL(a2.ann_tsi_amt, 0)); -- Modified by Jerome 01.31.2017
                --END IF;
            END LOOP;
            
            INSERT INTO GIPI_WITMPERL (
                par_id,        item_no,        line_cd,       peril_cd,        prem_rt,
                tsi_amt,       prem_amt,       ann_tsi_amt,   ann_prem_amt,    rec_flag,
                ri_comm_amt,   ri_comm_rate)
             VALUES (
                p_par_id,          a1.item_no,     p_line_cd,         v_peril,      0,
                v_prorate_tsi,    v_prorate_prem, 0,                0,            'D',
                v_comm_amt,        0);
        ELSE
            --for short rate cancellation premium for each peril for a particular item
            --would be summarized and computed based on entered short rate percent
            FOR A2 IN(
                SELECT b380.peril_cd peril_cd, SUM(b380.prem_amt) prem, SUM(b380.tsi_amt) tsi,
                       SUM(NVL(ri_comm_amt,0)) comm
                  FROM GIPI_POLBASIC b250, GIPI_ITMPERIL b380
                 WHERE b250.line_cd    = p_line_cd
                   AND b250.subline_cd = p_subline_cd
                   AND b250.iss_cd     = p_iss_cd
                   AND b250.issue_yy   = p_issue_yy
                   AND b250.pol_seq_no = p_pol_seq_no
                   AND b250.renew_no   = p_renew_no
                   AND b250.pol_flag   IN ('1','2','3','X') 
                   AND b250.policy_id  = b380.policy_id
                   AND b380.item_no    = A1.item_no
              GROUP BY b380.peril_cd) 
            LOOP
                v_prorate_prem := NVL(a2.prem,0)*(NVL(p_nbt_short_rt_pct,1)/100);
                v_comm_amt     := NVL(a2.comm,0)*(NVL(p_nbt_short_rt_pct,1)/100);
                IF NVL(v_comm_amt,0) <> 0 THEN
                  v_comm_amt := -v_comm_amt;
                END IF;
                
                INSERT INTO GIPI_WITMPERL (
                    par_id,       item_no,        line_cd,       peril_cd,        prem_rt,
                    tsi_amt,      prem_amt,       ann_tsi_amt,   ann_prem_amt,    rec_flag,
                    ri_comm_amt,  ri_comm_rate)
                VALUES (
                    p_par_id,    a1.item_no,            p_line_cd,    a2.peril_cd,     0,
                    -a2.tsi,    -v_prorate_prem,    0,            0,                'D',
                    v_comm_amt,    0);
            END LOOP;
        END IF;
    END LOOP;
    
    --update amounts of table gipi_witem, gipi_wpolbas refering to the created
    --records in table gipi_witmperl
    FOR ITEM IN (
        SELECT item_no
          FROM GIPI_WITEM
         WHERE par_id = p_par_id)
    LOOP
        FOR PERIL IN (
            SELECT SUM(NVL(prem_amt,0)) prem
              FROM GIPI_WITMPERL
             WHERE par_id = p_par_id
               AND item_no = item.item_no)
        LOOP
            UPDATE GIPI_WITEM
               SET prem_amt = peril.prem
             WHERE par_id = p_par_id
               AND item_no = item.item_no;
        END LOOP;
        
        FOR PERIL2 IN (
            SELECT SUM(NVL(tsi_amt,0)) tsi
              FROM GIPI_WITMPERL a, GIIS_PERIL b
             WHERE a.par_id = p_par_id
               AND a.peril_cd = b.peril_cd
               AND a.line_cd  = b.line_cd
               AND b.peril_type = 'B'
               AND item_no = item.item_no)
        LOOP
            UPDATE GIPI_WITEM
               SET tsi_amt  = peril2.tsi
             WHERE par_id = p_par_id
               AND item_no = item.item_no;
        END LOOP;
    END LOOP;
    
    /* Update invoice records 
    */
    BEGIN
        IF p_pack_pol_flag = 'Y' THEN
            FOR PACK IN (
                SELECT pack_line_cd, item_no
                  FROM GIPI_WITEM
                 WHERE par_id = p_par_id)
            LOOP
                FOR A IN (
                    SELECT '1'
                      FROM GIPI_WITMPERL
                     WHERE par_id  = p_par_id)
                LOOP
                    Create_Winvoice(0, 0, 0, p_par_id, pack.pack_line_cd, p_iss_cd);
                    EXIT;
                END LOOP;
            END LOOP;
        ELSE
            FOR A IN (
                SELECT '1'
                  FROM GIPI_WITMPERL
                 WHERE par_id  = p_par_id)
            LOOP
               Create_Winvoice(0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
               EXIT;
            END LOOP;
        END IF;
        
        FOR UPD_POLBAS IN (
            SELECT SUM(tsi_amt*currency_rt) tsi, 
                   SUM(prem_amt*currency_rt) prem
              FROM GIPI_WITEM
             WHERE par_id = p_par_id)
        LOOP
            p_tsi_amt        := upd_polbas.tsi;
            p_prem_amt        := upd_polbas.prem;
            p_ann_tsi_amt     := 0;
            p_ann_prem_amt     := 0;
        END LOOP;
        
        Cr_Bill_Dist.get_tsi(p_par_id);
    END;
    
    p_v_expiry_date := v_v_expiry_date;    
    p_v_incept_date := v_v_incept_date;
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
END Create_Negated_Records_Prorate;
/


