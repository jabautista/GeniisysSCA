DROP PROCEDURE CPI.CREATE_DISTRIBUTION_ITEM_PKG;

CREATE OR REPLACE PROCEDURE CPI.CREATE_DISTRIBUTION_ITEM_PKG (
	p_par_id IN gipi_parlist.par_id%TYPE,
	p_dist_no IN giuw_pol_dist.dist_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Delete all distribution tables if any affecting 
	**					: changes have been made to the records in gipi_witem
	*/
	CURSOR C1 IS
		SELECT DISTINCT frps_yy, frps_seq_no
		  FROM giri_wdistfrps
		 WHERE dist_no = p_dist_no;
    CURSOR C2 IS
        SELECT DISTINCT frps_yy, frps_seq_no
          FROM giri_distfrps
         WHERE dist_no = p_dist_no;

    v_tsi_amt       gipi_witem.tsi_amt%TYPE := 0;
    v_ann_tsi_amt   gipi_witem.ann_tsi_amt%TYPE := 0;
    v_prem_amt      gipi_witem.prem_amt%TYPE := 0;
    v_dist_no       giuw_pol_dist.dist_no%TYPE;
    v_exist         NUMBER;
    v_eff_date        gipi_polbasic.eff_date%TYPE;
    v_expiry_date    gipi_polbasic.expiry_date%TYPE;
    v_endt_type        gipi_polbasic.endt_type%TYPE;
    v_dist_no2         giuw_pol_dist.dist_no%TYPE;
    v_policy_id        gipi_polbasic.policy_id%TYPE;
BEGIN
    SELECT SUM(tsi_amt * currency_rt),
           SUM(ann_tsi_amt * currency_rt),
           SUM(prem_amt * currency_rt)
      INTO v_tsi_amt,
           v_ann_tsi_amt,
           v_prem_amt
      FROM gipi_witem
     WHERE par_id = p_par_id;    
    
    IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)) THEN
        FOR C1_rec IN C1
        LOOP
            delete_ri_tables_package(p_dist_no);
            giri_wfrperil_pkg.del_giri_wfrperil_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
            giri_wfrps_ri_pkg.del_giri_wfrps_ri_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
            giri_wdistfrps_pkg.del_giri_wdistfrps(p_dist_no);
        END LOOP;
        
        gipis010_del_wrkng_dist_tables(p_dist_no);
        giuw_pol_dist_pkg.del_giuw_pol_dist(p_dist_no);
    ELSE
        BEGIN
            SELECT DISTINCT dist_no
              INTO v_dist_no
              FROM giuw_pol_dist
             WHERE par_id = p_par_id;        
            
            BEGIN
                SELECT DISTINCT 1
                  INTO v_exist
                  FROM giuw_policyds
                 WHERE dist_no  =  p_dist_no;
                
                IF SQL%FOUND THEN                    
                    RAISE_APPLICATION_ERROR(-20001, 'This PAR has an existing record in the posted POLICY table. Could not proceed.');
                ELSE
                    RAISE NO_DATA_FOUND;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            FOR C1_rec IN C1 
            LOOP
                delete_ri_tables_package(p_dist_no);
                giri_wfrperil_pkg.del_giri_wfrperil_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
                giri_wfrps_ri_pkg.del_giri_wfrps_ri_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
                giri_wdistfrps_pkg.del_giri_wdistfrps(p_dist_no);
            END LOOP;
            
            FOR C2_rec IN C2 LOOP
                RAISE_APPLICATION_ERROR(-20001, 'This PAR has corresponding records in the posted tables for RI.'||
                          '  Could not proceed.');
            END LOOP;
            
            giuw_witemperilds_dtl_pkg.del_giuw_witemperilds_dtl(p_dist_no);
            giuw_witemperilds_pkg.del_giuw_witemperilds(p_dist_no);
            
            giuw_pol_dist_pkg.delete_dist1(p_par_id, p_dist_no, v_tsi_amt, v_prem_amt, v_ann_tsi_amt);
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN                
                RAISE_APPLICATION_ERROR(-20001, 'There are too many distribution numbers assigned for this item. '||
                        'Please call your administrator to rectify the matter. Check ' ||
                        'records in the policy table with par_id = ' || TO_CHAR(p_par_id) || '.');
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT eff_date, expiry_date, endt_type
                      INTO v_eff_date, v_expiry_date, v_endt_type
                      FROM gipi_wpolbas
                     WHERE par_id = p_par_id;
                    
                    IF ((v_eff_date IS NULL ) OR (v_expiry_date IS NULL)) THEN                        
                        RAISE_APPLICATION_ERROR(-20001, 'Could not proceed. The effectivity date or expiry date had not been updated.');
                    END IF;
                    
                    BEGIN
                        DECLARE
                            CURSOR C IS
                            SELECT pol_dist_dist_no_s.NEXTVAL
                              FROM SYS.DUAL;
                        BEGIN
                            OPEN C;
                            FETCH C
                            INTO v_dist_no2;
                            IF C%NOTFOUND THEN
                                RAISE_APPLICATION_ERROR(-20001, 'No row in table SYS.DUAL');
                            END IF;
                            CLOSE C;
                        EXCEPTION
                            WHEN OTHERS THEN
                                --CGTE$OTHER_EXCEPTIONS;
                                NULL;
                        END;
                    END;
                    
                    v_policy_id := NULL;
                    
                    INSERT INTO giuw_pol_dist (
                        dist_no,         par_id,            policy_id,         endt_type,
                        tsi_amt,        prem_amt,         ann_tsi_amt,    dist_flag,
                        redist_flag,    eff_date,         expiry_date,    create_date,
                        user_id,        last_upd_date,     post_flag)
                    VALUES (
                        v_dist_no2,            p_par_id,            v_policy_id,            v_endt_type,
                        NVL(v_tsi_amt,0),    NVL(v_prem_amt,0),    NVL(v_ann_tsi_amt,0),    1,
                        1,                    v_eff_date,            v_expiry_date,            SYSDATE,
                        NVL(giis_users_pkg.app_user, USER),        SYSDATE, '                O');
                EXCEPTION
                    WHEN TOO_MANY_ROWS THEN                        
                        RAISE_APPLICATION_ERROR(-20001, 'Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||
                             'to rectify the matter. Check record with par_id = ' || TO_CHAR(p_par_id));
                    WHEN NO_DATA_FOUND THEN                        
                        RAISE_APPLICATION_ERROR(-20001, 'You have committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.');
                END;
        END;        
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN        
        RAISE_APPLICATION_ERROR(-20001, 'Pls. be adviced that there are no items for this PAR.');
END CREATE_DISTRIBUTION_ITEM_PKG;
/


