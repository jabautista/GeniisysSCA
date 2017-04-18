DROP PROCEDURE CPI.GIPIS061_CREATE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.GIPIS061_CREATE_DISTRIBUTION (
	p_par_id	IN gipi_parlist.par_id%TYPE,
	p_dist_no	IN giuw_policyds.dist_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.06.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - Casualty)
	**  Description 	: Procedure to create distribution
	*/
	-----------                            
	TYPE NUMBER_VARRAY IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
	vv_tsi_amt		NUMBER_VARRAY;
	vv_ann_tsi_amt  NUMBER_VARRAY;
	vv_prem_amt     NUMBER_VARRAY;
    vv_item_grp       NUMBER_VARRAY;
    varray_cnt        NUMBER:=0;
    -----------
    
    v_exist1        NUMBER;    -- b_exist
    v_exist2        NUMBER;    -- p_exist
    v_dist_no1        giuw_pol_dist.dist_no%TYPE;    --pi_dist_no
    v_dist_no2        giuw_pol_dist.dist_no%TYPE;    --p2_dist_no
    v_eff_date        gipi_polbasic.eff_date%TYPE;
    v_expiry_date    gipi_polbasic.expiry_date%TYPE;
    v_endt_type        gipi_polbasic.endt_type%TYPE;
    v_policy_id        gipi_polbasic.policy_id%TYPE;
    v_tsi_amt        gipi_witem.tsi_amt%TYPE := 0;
    v_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE := 0;
    v_prem_amt        gipi_witem.prem_amt%TYPE := 0;
    v_but            NUMBER;    -- x_but
    v_dist_cnt        NUMBER := 0;
    v_dist_max        giuw_pol_dist.dist_no%TYPE;
    v_dist_min        giuw_pol_dist.dist_no%TYPE;
    v_dist_exist    VARCHAR2(1) := 'N';
    
    CURSOR C1 IS
        SELECT DISTINCT frps_yy,
               frps_seq_no
          FROM giri_wdistfrps       
         WHERE dist_no = v_dist_no1;
         
    CURSOR C2 IS
        SELECT DISTINCT frps_yy,
               frps_seq_no
          FROM giri_distfrps       
         WHERE dist_no = v_dist_no1;
BEGIN
    -- 1 --
    BEGIN
        FOR array_loop IN (
            SELECT SUM(tsi_amt * currency_rt) tsi_amt,
                   SUM(ann_tsi_amt * currency_rt) ann_tsi_amt,
                   SUM(prem_amt * currency_rt) prem_amt,
                   item_grp
              FROM gipi_witem
             WHERE par_id = p_par_id
          GROUP BY item_grp)
        LOOP
            varray_cnt                 := varray_cnt + 1;
            vv_tsi_amt(varray_cnt)     := array_loop.tsi_amt;
            vv_ann_tsi_amt(varray_cnt) := array_loop.ann_tsi_amt;
            vv_prem_amt(varray_cnt)    := array_loop.prem_amt;
            vv_item_grp(varray_cnt)    := array_loop.item_grp;
        END LOOP;
        
        IF varray_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(20000, 'Pls. be adviced that there are no items for this PAR.');            
        END IF;
    END;
    -- 1 --
    
    FOR x IN (
        SELECT dist_no
          FROM giuw_pol_dist
         WHERE par_id = p_par_id)
    LOOP
        v_dist_no1 := x.dist_no;
        v_dist_exist := 'Y';
        
        -- 2 --
        BEGIN
            SELECT DISTINCT 1
              INTO v_exist1
              FROM giuw_policyds
             WHERE dist_no  =  v_dist_no1;
             
            IF SQL%FOUND THEN
                -- confirmation
                -- see alert REC_EXISTS_IN_POST_POL_TAB in GIPIS061
                Gipis010_Delete_Ri_Tables(v_dist_no1);
                Gipis010_Del_Wrkng_Dist_Tables(v_dist_no1);
                Gipis010_Del_Main_Dist_Tables(v_dist_no1);
                
                UPDATE giuw_pol_dist
                   SET user_id       = USER,
                       last_upd_date = SYSDATE,
                       dist_type     = NULL,
                       dist_flag     = '1'
                 WHERE par_id  = p_par_id
                   AND dist_no = v_dist_no1;
                
                UPDATE gipi_wpolbas
                   SET user_id = USER
                 WHERE par_id  = p_par_id;
            ELSE
                RAISE NO_DATA_FOUND;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        -- 2 --
        
        -- 3 --
        BEGIN
            SELECT   distinct 1
              INTO   v_exist2
              FROM   giuw_wpolicyds
             WHERE   dist_no  =  v_dist_no1;
             
            -- confirmation
            -- see alert DISTRIBUTION in GIPIS061
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_but := 1;
        END;
        -- 3 --
        
        IF v_but = 1 THEN
            FOR C1_rec IN C1
            LOOP
                Giri_Wfrperil_Pkg.del_giri_wfrperil_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
                Giri_Wfrps_Ri_Pkg.del_giri_wfrps_ri_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
                Giri_Wdistfrps_Pkg.del_giri_wdistfrps(v_dist_no1);
            END LOOP;
            
            FOR C2_rec IN C2 
            LOOP
                RAISE_APPLICATION_ERROR(20001, 'This PAR has corresponding records in the posted tables for RI.'||
                    ' Could not proceed.');
            END LOOP;
            
            DELETE_WORKING_DIST_TABLES(v_dist_no1);
            
            ------------------------------------------------------
            IF vv_item_grp.EXISTS(1) THEN
                FOR cnt IN vv_item_grp.FIRST.. vv_item_grp.LAST 
                LOOP
                    -- 4 --
                    BEGIN
                        SELECT COUNT(dist_no), MAX(dist_no), MIN(dist_no)
                          INTO v_dist_cnt, v_dist_max, v_dist_min
                          FROM giuw_pol_dist
                         WHERE par_id = p_par_id
                           AND NVL(item_grp, vv_item_grp(cnt)) = vv_item_grp(cnt);
                    END;
                    -- 4 --

                    IF v_dist_cnt = 1 THEN
                        v_tsi_amt     := v_tsi_amt + vv_tsi_amt(cnt);
                        v_ann_tsi_amt := v_ann_tsi_amt + vv_ann_tsi_amt(cnt);
                        v_prem_amt    := v_prem_amt + vv_prem_amt(cnt);
                    ELSIF v_dist_no1 BETWEEN v_dist_min AND v_dist_max THEN
                        v_tsi_amt     := vv_tsi_amt(cnt);
                        v_ann_tsi_amt := vv_ann_tsi_amt(cnt);
                        v_prem_amt    := vv_prem_amt(cnt);                          
                        EXIT;               
                    END IF;              
                END LOOP;
            END IF;
            ------------------------------------------------------
            
            IF v_dist_no1 = v_dist_max THEN 
                UPDATE giuw_pol_dist
                   SET tsi_amt = NVL(v_tsi_amt,0) , 
                       prem_amt = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/v_dist_cnt),2) * (v_dist_cnt - 1)),
                       ann_tsi_amt = NVL(v_ann_tsi_amt,0) ,
                       last_upd_date = SYSDATE,
                       user_id = USER
                 WHERE par_id = p_par_id
                   AND dist_no = v_dist_no1;                     
            ELSE
                UPDATE giuw_pol_dist
                   SET tsi_amt = NVL(v_tsi_amt,0)     , 
                       prem_amt = NVL(v_prem_amt,0)    / v_dist_cnt,
                       ann_tsi_amt = NVL(v_ann_tsi_amt,0) ,
                       last_upd_date = SYSDATE,
                       user_id = USER
                 WHERE par_id = p_par_id
                   AND dist_no = v_dist_no1;
            END IF;
        END IF;
    END LOOP;    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(20000, 'There are too many distribution numbers assigned for this item. '||
                                        'Please contact your database administrator to rectify the matter. Check '||
                                        'records in the policy table with par_id = ' || TO_CHAR(p_par_id) || '.');
    WHEN NO_DATA_FOUND THEN
        DECLARE
            v_no_of_takeup    giis_takeup_term.no_of_takeup%TYPE;
            v_yearly_tag    giis_takeup_term.yearly_tag%TYPE;
            v_takeup_term    gipi_wpolbas.takeup_term%TYPE;

            v_policy_days    NUMBER := 0;
            v_no_of_payment    NUMBER := 1;
            v_duration_frm    DATE;
            v_duration_to    DATE;    
            v_days_interval    NUMBER := 0;
        BEGIN
            SELECT eff_date,
                   expiry_date, 
                   endt_type,
                   takeup_term
              INTO v_eff_date,
                   v_expiry_date,
                   v_endt_type,
                   v_takeup_term
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;
            
            IF ((v_eff_date IS NULL ) OR (v_expiry_date IS NULL)) THEN
                RAISE_APPLICATION_ERROR(20000, 'Could not proceed. The effectivity date or expiry date had not been updated.');
            END IF;
            
            IF TRUNC(v_expiry_date - v_eff_date) = 31 THEN
                v_policy_days  := 30;
            ELSE
                v_policy_days  := TRUNC(v_expiry_date - v_eff_date);
            END IF;
            
            FOR b1 IN (
                SELECT no_of_takeup, yearly_tag
                  FROM giis_takeup_term
                 WHERE takeup_term = v_takeup_term)
            LOOP
                v_no_of_takeup := b1.no_of_takeup;
                v_yearly_tag   := b1.yearly_tag;
            END LOOP;
            
            IF v_yearly_tag = 'Y' THEN
                IF TRUNC((v_policy_days)/365,2) * v_no_of_takeup > TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) THEN
                    v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) + 1;
                ELSE
                    v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup);
                END IF;
            ELSE
                IF v_policy_days < v_no_of_takeup THEN
                    v_no_of_payment := v_policy_days;
                ELSE
                    v_no_of_payment := v_no_of_takeup;
                END IF;
            END IF;
            
            IF v_no_of_payment < 1 THEN
                v_no_of_payment := 1;
            END IF;

            v_days_interval := ROUND(v_policy_days / v_no_of_payment);
            v_policy_id := NULL;
            
            IF v_no_of_payment = 1 THEN
                -- Single takeup (x)
                DECLARE
                    CURSOR C IS
                        SELECT POL_DIST_DIST_NO_S.NEXTVAL
                          FROM SYS.DUAL;

                BEGIN
                    OPEN C;
                    FETCH C
                    INTO v_dist_no2;
                    
                    IF C%NOTFOUND THEN
                        RAISE_APPLICATION_ERROR(20000, 'No row in table SYS.DUAL');
                    END IF;
                    CLOSE C;
                EXCEPTION
                    WHEN OTHERS THEN
                        IF (SQLCODE = 100) THEN
                            RAISE NO_DATA_FOUND;
                        ELSIF (SQLCODE = -100501) THEN
                            RAISE_APPLICATION_ERROR(20000, SQLERRM);
                        ELSE
                            RAISE_APPLICATION_ERROR(20000, SQLERRM);
                        END IF;
                END;
                
                INSERT INTO giuw_pol_dist (
                    dist_no,         par_id,         policy_id,         endt_type,         
                    tsi_amt,        prem_amt,         ann_tsi_amt,     dist_flag,
                    redist_flag,    eff_date,         expiry_date,     create_date,
                    user_id,        last_upd_date,     post_flag,         auto_dist)
                VALUES (
                    v_dist_no2,            p_par_id,            v_policy_id,            v_endt_type,    
                    NVL(v_tsi_amt,0),    NVL(v_prem_amt,0),    NVL(v_ann_tsi_amt,0),    1,
                    1,                    v_eff_date,            v_expiry_date,            SYSDATE,
                    USER,                SYSDATE,             'O',                     'N');
            ELSE
                -- MULTI TAKE-UP (x)
                v_duration_frm := NULL;
                v_duration_to  := NULL;
                
                FOR takeup_val IN 1.. v_no_of_payment
                LOOP 
                    IF v_duration_frm IS NULL THEN
                        v_duration_frm := TRUNC(v_eff_date);
                    ELSE
                        v_duration_frm := TRUNC(v_duration_frm + v_days_interval);
                    END IF;
                                    
                    v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
                    
                    DECLARE
                        CURSOR C IS
                        SELECT POL_DIST_DIST_NO_S.NEXTVAL
                          FROM SYS.DUAL;

                    BEGIN
                        OPEN C;
                        FETCH C
                        INTO v_dist_no2;
                        IF C%NOTFOUND THEN
                            RAISE_APPLICATION_ERROR(20000, 'No row in table SYS.DUAL');
                        END IF;
                        CLOSE C;
                    EXCEPTION
                        WHEN OTHERS THEN
                            IF (SQLCODE = 100) THEN
                                RAISE NO_DATA_FOUND;
                            ELSIF (SQLCODE = -100501) THEN
                                RAISE_APPLICATION_ERROR(20000, SQLERRM);
                            ELSE
                                RAISE_APPLICATION_ERROR(20000, SQLERRM);    
                            END IF;
                    END;
                    
                    IF takeup_val = v_no_of_payment THEN
                        -- last loop record (y)
                        INSERT INTO giuw_pol_dist ( 
                            dist_no,         par_id,         policy_id,         endt_type, 
                            dist_flag,         redist_flag,     eff_date,         expiry_date, 
                            create_date,     user_id,        last_upd_date,     post_flag,
                            auto_dist,        tsi_amt,         prem_amt,         ann_tsi_amt)
                        VALUES (
                            v_dist_no2,        p_par_id,            v_policy_id,    v_endt_type,                                                            
                            1,                1,                    v_duration_frm,    v_duration_to,
                            SYSDATE,        USER,                SYSDATE,         'O',
                            'N',            NVL(v_tsi_amt,0),
                        NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                        NVL(v_ann_tsi_amt,0));
                    ELSE
                        -- other loop records (y)
                        INSERT INTO giuw_pol_dist (
                            dist_no,         par_id,         policy_id,         endt_type, 
                            dist_flag,         redist_flag,     eff_date,         expiry_date,
                            create_date,     user_id,        last_upd_date,     post_flag,
                            auto_dist,        tsi_amt,         prem_amt,         ann_tsi_amt)
                        VALUES (
                            v_dist_no2,        p_par_id,        v_policy_id,    v_endt_type,                                                            
                            1,                1,                v_duration_frm,    v_duration_to,
                            SYSDATE,        USER,            SYSDATE,         'O',
                            'N',            (NVL(v_tsi_amt,0)),
                            (NVL(v_prem_amt,0)/ v_no_of_payment),
                            (NVL(v_ann_tsi_amt,0)));
                    END IF;
                END LOOP;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(20000, 'You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.');
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(20000, 'Multiple rows were found to exist in GIPI_WPOLBAS. '||
                                        'Please contact your database administrator ' ||
                                        'to rectify the matter. Check record with par_id = ' || TO_CHAR(p_par_id));
        END;
        
        DELETE FROM giuw_pol_dist a
         WHERE par_id = p_par_id
          AND dist_no = v_dist_no1
          AND NOT EXISTS (
                SELECT 1 
                  FROM gipi_witem b
                 WHERE b.item_grp = NVL(a.item_grp, b.item_grp)
                  AND b.par_id = a.par_id);
END GIPIS061_CREATE_DISTRIBUTION;
/


