DROP PROCEDURE CPI.CREATE_NEGATED_RECORDS_ENDT01;

CREATE OR REPLACE PROCEDURE CPI.CREATE_NEGATED_RECORDS_ENDT01 (
	p_gipi_wpolbas IN OUT gipi_wpolbas%ROWTYPE,
	p_b240_par_status OUT gipi_parlist.par_status%TYPE,
	p_v_expiry_date OUT VARCHAR2)
AS
	/*	Date        Author			Description
    **	==========	===============	============================
    **	01.19.2012	mark jm			This procedure create records in gipi_witem and
	**								gipi_witmperl which will negate all the policy's
	**								peril and tsi (Original Description)
	**								Reference By : (GIPIS031 - Endt Basic Information)
    */    
    v_max_eff_date1		gipi_wpolbas.eff_date%TYPE;
    v_max_eff_date2		gipi_wpolbas.eff_date%TYPE;
    v_max_eff_date		gipi_wpolbas.eff_date%TYPE;
    v_eff_date            gipi_wpolbas.eff_date%TYPE;
    v_max_endt_seq_no    gipi_wpolbas.endt_seq_no%TYPE;
    v_max_endt_seq_no1    gipi_wpolbas.endt_seq_no%TYPE;
    
    v_policy_id        gipi_polbasic.policy_id%TYPE;
    v_message VARCHAR2(2000);
BEGIN
    p_v_expiry_date := extract_expiry(p_gipi_wpolbas.par_id);
    delete_other_info(p_gipi_wpolbas.par_id);
    delete_records(p_gipi_wpolbas.par_id, p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd, p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no,
        v_eff_date, p_gipi_wpolbas.co_insurance_sw, p_gipi_wpolbas.ann_tsi_amt, p_gipi_wpolbas.ann_prem_amt, v_message);
    
    p_gipi_wpolbas.eff_date := v_eff_date;    
    
    gipi_polbasic_pkg.get_eff_date_policy_id(p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd,
        p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, v_eff_date, v_policy_id);
    
    v_max_endt_seq_no := gipi_polbasic_pkg.get_max_endt_seq_no(p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd,
        p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, NULL, 'ENDT_CANCELLATION');
    
    IF v_max_endt_seq_no > 0 THEN
        v_max_endt_seq_no1 := gipi_polbasic_pkg.get_max_endt_seq_no_back_stat(p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd,
            p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, NULL, 'ENDT_CANCELLATION');
        
        IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN
            v_max_eff_date1 := gipi_polbasic_pkg.get_max_eff_date_back_stat(p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd,
                p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, NULL, v_max_endt_seq_no1, 'ENDT_CANCELLATION');
            
            v_max_eff_date2 := gipi_polbasic_pkg.get_endt_max_eff_date(p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd,
                p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, NULL, 'ENDT_CANCELLATION');
            
            v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);
        ELSE
            v_max_eff_date := gipi_polbasic_pkg.get_max_eff_date_back_stat(p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd,
                p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, NULL, v_max_endt_seq_no1, 'ENDT_CANCELLATION2');
        END IF;
    ELSE
        v_max_eff_date := v_eff_date;
    END IF;
    
    -- get latest data for dates coming from latest endt. 
    -- (backward endt. is considered)
    FOR DT IN (
        SELECT b250.incept_date, b250.expiry_date
          FROM gipi_polbasic b250
         WHERE b250.line_cd    = p_gipi_wpolbas.line_cd
           AND b250.subline_cd = p_gipi_wpolbas.subline_cd
           AND b250.iss_cd     = p_gipi_wpolbas.iss_cd
           AND b250.issue_yy   = p_gipi_wpolbas.issue_yy
           AND b250.pol_seq_no = p_gipi_wpolbas.pol_seq_no
           AND b250.renew_no   = p_gipi_wpolbas.renew_no
           AND b250.pol_flag   IN ('1','2','3','X') 
           AND b250.eff_date   = v_max_eff_date 
      ORDER BY b250.endt_seq_no DESC)
    LOOP
        p_gipi_wpolbas.eff_date         := dt.incept_date;
        p_gipi_wpolbas.incept_date      := dt.incept_date;
        p_gipi_wpolbas.expiry_date      := dt.expiry_date;
        p_gipi_wpolbas.endt_expiry_date := dt.expiry_date;        
        EXIT;
    END LOOP;
    
    --create negated records in table gipi_witem,gipi_witmperl
    --select first all existing item from policy and all it's endt.              
    FOR A1 IN (
        SELECT DISTINCT b340.item_no item_no
          FROM gipi_polbasic b250, gipi_item b340
         WHERE b250.line_cd    = p_gipi_wpolbas.line_cd
           AND b250.subline_cd = p_gipi_wpolbas.subline_cd
           AND b250.iss_cd     = p_gipi_wpolbas.iss_cd
           AND b250.issue_yy   = p_gipi_wpolbas.issue_yy
           AND b250.pol_seq_no = p_gipi_wpolbas.pol_seq_no
           AND b250.renew_no   = p_gipi_wpolbas.renew_no
           AND b250.policy_id  = b340.policy_id
           AND b250.pol_flag   IN ('1','2','3','X'))
    LOOP
        --call procedure that will get latest info. for every item
        --and insert it in table gipi_witem        
        get_neg_item(p_gipi_wpolbas.par_id, p_gipi_wpolbas.line_cd, p_gipi_wpolbas.subline_cd, p_gipi_wpolbas.iss_cd, p_gipi_wpolbas.issue_yy, p_gipi_wpolbas.pol_seq_no, p_gipi_wpolbas.renew_no, a1.item_no);
        --change item grouping        
        change_item_grp(p_gipi_wpolbas.par_id, p_gipi_wpolbas.pack_pol_flag);
        --summarized all peril for a particular item
        --and insert records in table gipi_witmperl        
        
        FOR A2 IN (
            SELECT b380.peril_cd peril_cd, SUM(b380.prem_amt) prem, SUM(b380.tsi_amt) tsi,
                   SUM(NVL(b380.ri_comm_amt,0)) comm
              FROM gipi_polbasic b250, gipi_itmperil b380
             WHERE b250.line_cd    = p_gipi_wpolbas.line_cd
               AND b250.subline_cd = p_gipi_wpolbas.subline_cd
               AND b250.iss_cd     = p_gipi_wpolbas.iss_cd
               AND b250.issue_yy   = p_gipi_wpolbas.issue_yy
               AND b250.pol_seq_no = p_gipi_wpolbas.pol_seq_no
               AND b250.renew_no   = p_gipi_wpolbas.renew_no
               AND b250.pol_flag   IN ('1','2','3','X') 
               AND b250.policy_id  = b380.policy_id
               AND b380.item_no    = A1.item_no
          GROUP BY b380.peril_cd)
        LOOP
            IF NVL(a2.comm,0) <> 0 THEN
                a2.comm := -a2.comm;
            END IF;                   

            INSERT INTO gipi_witmperl (
                par_id,           item_no,    line_cd,       peril_cd,
                tsi_amt,          prem_amt,   ann_tsi_amt,   ann_prem_amt,    rec_flag,
                ri_comm_rate,     ri_comm_amt)
            VALUES (
                p_gipi_wpolbas.par_id,         a1.item_no, p_gipi_wpolbas.line_cd, a2.peril_cd,          
                -a2.tsi,          -a2.prem,   0,             0,               'D',
                0,                a2.comm);                  
        END LOOP;
        
    END LOOP;
    
    --update amounts of table gipi_witem, gipi_wpolbas refering to the created
    --records in tanle gipi_witmperl
    FOR ITEM IN (
        SELECT item_no
          FROM gipi_witem
         WHERE par_id = p_gipi_wpolbas.par_id)
    LOOP
        FOR PERIL IN (
            SELECT SUM(NVL(prem_amt,0)) prem
              FROM gipi_witmperl
             WHERE par_id = p_gipi_wpolbas.par_id
               AND item_no = item.item_no)
        LOOP
            UPDATE gipi_witem
               SET prem_amt = peril.prem
             WHERE par_id = p_gipi_wpolbas.par_id
               AND item_no = item.item_no;
        END LOOP;
      
        FOR PERIL2 IN (
            SELECT SUM(NVL(tsi_amt,0)) tsi
              FROM gipi_witmperl a, giis_peril b
             WHERE a.par_id = p_gipi_wpolbas.par_id
               AND a.peril_cd = b.peril_cd
               AND a.line_cd  = b.line_cd
               AND b.peril_type = 'B'
               AND item_no = item.item_no)
        LOOP
            UPDATE gipi_witem
               SET tsi_amt = peril2.tsi
             WHERE par_id = p_gipi_wpolbas.par_id
               AND item_no = item.item_no;
        END LOOP;
    END LOOP;
    
    /* Update invoice records */    
    BEGIN
        IF p_gipi_wpolbas.pack_pol_flag = 'Y' THEN
            FOR PACK IN (
                SELECT pack_line_cd, item_no
                  FROM gipi_witem
                 WHERE par_id = p_gipi_wpolbas.par_id)
            LOOP
                FOR A IN (
                    SELECT '1'
                      FROM gipi_witmperl
                     WHERE par_id  = p_gipi_wpolbas.par_id)
                LOOP
                    create_winvoice(0, 0, 0, p_gipi_wpolbas.par_id, pack.pack_line_cd, p_gipi_wpolbas.iss_cd);
                    EXIT;
                END LOOP;
            END LOOP;
        ELSE
            FOR A IN (
                SELECT '1'
                  FROM gipi_witmperl
                 WHERE par_id  = p_gipi_wpolbas.par_id)
            LOOP
                create_winvoice(0, 0, 0, p_gipi_wpolbas.par_id, p_gipi_wpolbas.line_cd, p_gipi_wpolbas.iss_cd);
                EXIT;
            END LOOP;
        END IF;

        FOR UPD_POLBAS IN (
            SELECT SUM(tsi_amt*currency_rt) tsi, 
                   SUM(prem_amt*currency_rt) prem
              FROM gipi_witem
             WHERE par_id = p_gipi_wpolbas.par_id)
        LOOP
            p_gipi_wpolbas.tsi_amt        := upd_polbas.tsi;
            p_gipi_wpolbas.prem_amt        := upd_polbas.prem;
--robert 11.14.2012
--            p_gipi_wpolbas.ann_tsi_amt     := 0; 
--            p_gipi_wpolbas.ann_prem_amt     := 0;
        END LOOP;
        
        cr_bill_dist.get_tsi(p_gipi_wpolbas.par_id);
        p_b240_par_status := '5';
    END;   
    
    
    UPDATE gipi_parlist
       SET par_status = 5
     WHERE par_id = p_gipi_wpolbas.par_id;     
    
END CREATE_NEGATED_RECORDS_ENDT01;
/


