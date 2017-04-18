DROP PROCEDURE CPI.GIPIS065_CREATE_DIST_ITEM2;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_CREATE_DIST_ITEM2(
    b_par_id        NUMBER,
    pi_dist_no      NUMBER,
    p_user_id       GIIS_USERS.user_id%TYPE
)
IS
    b_exist        NUMBER;
    p_exist        NUMBER;
    p_dist_no      giuw_pol_dist.dist_no%TYPE;
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
    x_but          NUMBER := 1;
BEGIN
    SELECT SUM(tsi_amt     * currency_rt),
           SUM(ann_tsi_amt * currency_rt),
           SUM(prem_amt    * currency_rt)
      INTO v_tsi_amt,
           v_ann_tsi_amt,
           v_prem_amt
      FROM GIPI_WITEM
     WHERE par_id = b_par_id;
     
    IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)) THEN
        FOR A IN (SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
                    FROM GIRI_WFRPS_RI a,
                         GIRI_WDISTFRPS b
                   WHERE a.line_cd = b.line_cd
                     AND a.frps_yy = b.frps_yy
                     AND a.frps_seq_no = b.frps_seq_no
                     AND b.dist_no = pi_dist_no)
        LOOP
            DELETE GIRI_WBINDER_PERIL
             WHERE pre_binder_id = a.pre_binder_id;

            DELETE GIRI_WBINDER
             WHERE pre_binder_id = a.pre_binder_id;

            DELETE GIRI_WFRPS_PERIL_GRP
             WHERE line_cd = a.line_cd
               AND frps_yy = a.frps_yy
               AND frps_seq_no = a.frps_seq_no;

            DELETE GIRI_WFRPERIL
             WHERE line_cd = a.line_cd
               AND frps_yy = a.frps_yy
               AND frps_seq_no = a.frps_seq_no;

            DELETE giri_wfrps_ri
             WHERE line_cd = a.line_cd
               AND frps_yy = a.frps_yy
               AND frps_seq_no = a.frps_seq_no;
        END LOOP;    
                
        DELETE GIRI_WDISTFRPS
         WHERE dist_no = pi_dist_no;    
    
    
	  	DELETE_WORKING_DIST_TABLES(pi_dist_no);
        DELETE_MAIN_DIST_TABLES(pi_dist_no);
        DELETE giuw_distrel
         WHERE dist_no_old = pi_dist_no;
        DELETE   giuw_pol_dist
         WHERE   dist_no  =  pi_dist_no;
    ELSE
        BEGIN
            SELECT DISTINCT dist_no
              INTO p_dist_no
              FROM GIUW_POL_DIST
             WHERE par_id = b_par_id;
            BEGIN
                SELECT DISTINCT 1
	              INTO b_exist
	              FROM GIUW_POLICYDS
	             WHERE dist_no = pi_dist_no;
                 
                IF SQL%FOUND THEN
                    FOR A IN (SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
                                FROM GIRI_WFRPS_RI a,
                                     GIRI_WDISTFRPS b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND b.dist_no = pi_dist_no)
                    LOOP
                        DELETE GIRI_WBINDER_PERIL
                         WHERE pre_binder_id = a.pre_binder_id;

                        DELETE GIRI_WBINDER
                         WHERE pre_binder_id = a.pre_binder_id;

                        DELETE GIRI_WFRPS_PERIL_GRP
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;

                        DELETE GIRI_WFRPERIL
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;

                        DELETE giri_wfrps_ri
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;
                    END LOOP;    
                
                    DELETE GIRI_WDISTFRPS
                     WHERE dist_no = pi_dist_no;
                
	                DELETE_WORKING_DIST_TABLES(pi_dist_no);
	                DELETE_MAIN_DIST_TABLES(pi_dist_no);
	                UPDATE GIUW_POL_DIST
	                   SET user_id = p_user_id,
	                       last_upd_date = SYSDATE,
	                       dist_type = NULL,
	                       dist_flag = '1'
	                 WHERE par_id  = b_par_id
	                   AND dist_no = pi_dist_no;
	           
	                UPDATE GIPI_WPOLBAS
	                   SET user_id = p_user_id
	                 WHERE par_id = b_par_id;
                ELSE     
                    RAISE NO_DATA_FOUND;  
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                    NULL;
            END;
            
            BEGIN
                SELECT distinct 1
	              INTO p_exist
	              FROM GIUW_WPOLICYDS
	             WHERE dist_no  =  pi_dist_no;
            EXCEPTION
	            WHEN NO_DATA_FOUND THEN
	                x_but := 1;
	        END;
            
            IF x_but = 1 THEN
                FOR C1_rec IN(SELECT DISTINCT frps_yy,
                                     frps_seq_no
                                FROM GIRI_WDISTFRPS
                               WHERE dist_no = pi_dist_no)
                LOOP
                    FOR A IN (SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
                                FROM GIRI_WFRPS_RI a,
                                     GIRI_WDISTFRPS b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND b.dist_no = pi_dist_no)
                    LOOP
                        DELETE GIRI_WBINDER_PERIL
                         WHERE pre_binder_id = a.pre_binder_id;

                        DELETE GIRI_WBINDER
                         WHERE pre_binder_id = a.pre_binder_id;

                        DELETE GIRI_WFRPS_PERIL_GRP
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;

                        DELETE GIRI_WFRPERIL
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;

                        DELETE giri_wfrps_ri
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;
                    END LOOP;    
                
                    DELETE GIRI_WDISTFRPS
                     WHERE dist_no = pi_dist_no;    
                
                    DELETE GIRI_WFRPERIL
                     WHERE frps_yy = C1_rec.frps_yy
                       AND frps_seq_no = C1_rec.frps_seq_no;
                    DELETE GIRI_WFRPS_RI
                     WHERE frps_yy = C1_rec.frps_yy
                       AND frps_seq_no = C1_rec.frps_seq_no;
                    DELETE GIRI_WDISTFRPS
                     WHERE dist_no = pi_dist_no;  
	            END LOOP;
                
	            FOR C2_rec IN(SELECT DISTINCT frps_yy,
                                     frps_seq_no
                                FROM GIRI_DISTFRPS
                               WHERE dist_no = pi_dist_no)
                LOOP
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has corresponding records in the posted tables for RI. '||
                                                    'Could not proceed.');
	            END LOOP;
                
                DELETE_WORKING_DIST_TABLES(pi_dist_no);
                
       	        UPDATE GIUW_POL_DIST
	               SET tsi_amt = NVL(v_tsi_amt,0),
	                   prem_amt = NVL(v_prem_amt,0),
	                   ann_tsi_amt = NVL(v_ann_tsi_amt,0),
	                   last_upd_date = SYSDATE,
	                   user_id = p_user_id
	             WHERE par_id = b_par_id
	               AND dist_no = pi_dist_no;
            END IF;
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#There are too many distribution numbers assigned for this item. '||
                        'Please call your administrator to rectify the matter. Check '||
                        'records in the policy table with par_id = '||to_char(b_par_id)||'.');
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT eff_date,
                           expiry_date,
                           endt_type
                      INTO p_eff_date,
                           p_expiry_date,
                           p_endt_type
                      FROM GIPI_WPOLBAS
                     WHERE par_id = b_par_id;
                     
                    IF ((p_eff_date IS NULL ) OR (p_expiry_date IS NULL)) THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Could not proceed. The effectivity date or expiry date had not been updated.');
                    END IF;
                    
                    BEGIN
                        SELECT POL_DIST_DIST_NO_S.NEXTVAL
                          INTO p2_dist_no
                          FROM DUAL;
                    END;
                    
                    BEGIN
                        p_policy_id := NULL;
                    END;
                    
                    INSERT INTO GIUW_POL_DIST(dist_no, par_id, policy_id, endt_type, tsi_amt,
       	                                      prem_amt, ann_tsi_amt, dist_flag, redist_flag,
               	                              eff_date, expiry_date, create_date, user_id,
                       	                      last_upd_date, post_flag , auto_dist)
                    VALUES (p2_dist_no,b_par_id,p_policy_id,p_endt_type,NVL(v_tsi_amt,0),
       	                   NVL(v_prem_amt,0),NVL(v_ann_tsi_amt,0),1,1,
               	           p_eff_date,p_expiry_date,SYSDATE,p_user_id,
                       	   SYSDATE, 'O', 'N');
                EXCEPTION
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||
               	             'to rectify the matter. Check record with par_id = '||to_char(b_par_id));
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You have committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.');
                END;
        END;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Pls. be adviced that there are no items for this PAR.');
END;
/


