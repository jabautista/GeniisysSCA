DROP PROCEDURE CPI.CREATE_DISTRIBUTION_GIPIS078;

CREATE OR REPLACE PROCEDURE CPI.CREATE_DISTRIBUTION_GIPIS078(
    b_par_id            NUMBER,
    p_dist_no           NUMBER,
    p_user_id           VARCHAR2
)
IS
/*
**  Created by   : Marco Paolo Rebong
**  Date Created : November 08, 2012
**  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
**  Description  : CREATE_DISTRIBUTION program unit for GIPIS078
*/

    TYPE NUMBER_VARRAY IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    
    vv_tsi_amt          NUMBER_VARRAY;
    vv_ann_tsi_amt      NUMBER_VARRAY;
    vv_prem_amt         NUMBER_VARRAY;
    vv_item_grp         NUMBER_VARRAY;
    varray_cnt          NUMBER := 0;
  
    b_exist             NUMBER;
    p_exist             NUMBER;
    pi_dist_no          GIUW_POL_DIST.dist_no%TYPE;
    p_frps_yy           GIRI_WDISTFRPS.frps_yy%TYPE;
    p_frps_seq_no       GIRI_WDISTFRPS.frps_seq_no%TYPE;
    p2_dist_no          GIUW_POL_DIST.dist_no%TYPE;
    p_eff_date          GIPI_POLBASIC.eff_date%TYPE;
    p_expiry_date       GIPI_POLBASIC.expiry_date%TYPE;
    p_endt_type         GIPI_POLBASIC.endt_type%TYPE;
    p_policy_id         GIPI_POLBASIC.policy_id%TYPE;
    p_tsi_amt           GIPI_WITEM.tsi_amt%TYPE;
    p_ann_tsi_amt       GIPI_WITEM.ann_tsi_amt%TYPE;
    p_prem_amt          GIPI_WITEM.prem_amt%TYPE;
    v_tsi_amt           GIPI_WITEM.tsi_amt%TYPE := 0;
    v_ann_tsi_amt       GIPI_WITEM.ann_tsi_amt%TYPE := 0;
    v_prem_amt          GIPI_WITEM.prem_amt%TYPE := 0;
    x_but               NUMBER;
    dist_cnt 			NUMBER := 0;
    dist_max 			GIUW_POL_DIST.dist_no%TYPE;
    dist_min 			GIUW_POL_DIST.dist_no%TYPE;
    v_dist_exist        VARCHAR2(1) := 'N';
BEGIN
    BEGIN
        FOR array_loop IN (SELECT SUM(tsi_amt * currency_rt) tsi_amt,
                				  SUM(ann_tsi_amt * currency_rt) ann_tsi_amt,
                                  SUM(prem_amt * currency_rt) prem_amt,
                                  item_grp
        					 FROM GIPI_WITEM
                            WHERE par_id = b_par_id
       				        GROUP BY item_grp)
        LOOP
            IF ((array_loop.tsi_amt IS NULL) OR (array_loop.ann_tsi_amt IS NULL) OR (array_loop.prem_amt IS NULL)) THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Insufficient information on the TSI amount, annual TSI amount ' ||
                    'and premium amount for this ITEM.');
            END IF;
            
            varray_cnt := varray_cnt + 1;
			vv_tsi_amt(varray_cnt) := array_loop.tsi_amt;
			vv_ann_tsi_amt(varray_cnt) := array_loop.ann_tsi_amt;
			vv_prem_amt(varray_cnt) := array_loop.prem_amt;
			vv_item_grp(varray_cnt) := array_loop.item_grp;
        END LOOP;
    
        IF varray_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Pls. be adviced that there are no items for this PAR.');
		END IF;
    END;
    
    FOR x IN(SELECT dist_no
               FROM GIUW_POL_DIST
              WHERE par_id = b_par_id)
    LOOP
        pi_dist_no := x.dist_no;
  	    v_dist_exist := 'Y';
        
        BEGIN
            SELECT DISTINCT 1
              INTO b_exist
              FROM GIUW_POLICYDS
             WHERE dist_no = pi_dist_no;
        
            IF SQL%FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has an existing records in the posted POLICY table. Could not proceed.');
            ELSE
                RAISE NO_DATA_FOUND;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        BEGIN
            SELECT DISTINCT 1
              INTO p_exist
              FROM GIUW_WPOLICYDS
             WHERE dist_no = pi_dist_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        FOR C1_rec IN(SELECT DISTINCT frps_yy,
                             frps_seq_no
                        FROM GIRI_WDISTFRPS
                       WHERE dist_no = pi_dist_no)
        LOOP
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
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has corresponding records in the posted tables for RI. Could not proceed.');
        END LOOP;
        
        GIUW_WPERILDS_DTL_PKG.del_giuw_wperilds_dtl(pi_dist_no);
        GIUW_WITEMDS_DTL_PKG.del_giuw_witemds_dtl(pi_dist_no);
        GIUW_WPOLICYDS_DTL_PKG.del_giuw_wpolicyds_dtl(pi_dist_no);
        GIUW_WPERILDS_PKG.del_giuw_wperilds(pi_dist_no);
        GIUW_WITEMDS_PKG.del_giuw_witemds(pi_dist_no);
        GIUW_WPOLICYDS_PKG.del_giuw_wpolicyds(pi_dist_no);
        
        IF vv_item_grp.exists(1) THEN
            FOR cnt IN vv_item_grp.FIRST.. vv_item_grp.LAST LOOP               	 	 
                BEGIN
                    SELECT COUNT(dist_no), MAX(dist_no), MIN(dist_no)
					  INTO dist_cnt, dist_max, dist_min
					  FROM GIUW_POL_DIST
					 WHERE par_id = b_par_id
					   AND NVL(item_grp, vv_item_grp(cnt)) = vv_item_grp(cnt);
                END;
            
                IF dist_cnt = 1 THEN
                    v_tsi_amt := v_tsi_amt + vv_tsi_amt(cnt);
                    v_ann_tsi_amt := v_ann_tsi_amt + vv_ann_tsi_amt(cnt);
                    v_prem_amt := v_prem_amt + vv_prem_amt(cnt);
                ELSIF pi_dist_no BETWEEN dist_min AND dist_max THEN
                    v_tsi_amt := vv_tsi_amt(cnt);
                    v_ann_tsi_amt := vv_ann_tsi_amt(cnt);
                    v_prem_amt := vv_prem_amt(cnt);               	 	  
                    EXIT;     	 	 
                END IF;
            END LOOP;
        END IF;
        
        IF pi_dist_no = dist_max THEN 
    	    UPDATE GIUW_POL_DIST
               SET tsi_amt = NVL(v_tsi_amt,0), 
			       prem_amt = NVL(v_prem_amt, 0) - (ROUND((NVL(v_prem_amt, 0) / dist_cnt), 2) * (dist_cnt - 1)),
                   ann_tsi_amt = NVL(v_ann_tsi_amt,0) ,
                   last_upd_date = SYSDATE,
                   user_id = p_user_id
             WHERE par_id = b_par_id
               AND dist_no = pi_dist_no;
        ELSE
            UPDATE GIUW_POL_DIST
               SET tsi_amt = NVL(v_tsi_amt, 0)     , 
			       prem_amt = NVL(v_prem_amt, 0) / dist_cnt,
	               ann_tsi_amt = NVL(v_ann_tsi_amt, 0),
                   last_upd_date = SYSDATE,
                   user_id = p_user_id
             WHERE par_id = b_par_id
               AND dist_no = pi_dist_no;
        END IF;
    END LOOP;
    
    IF v_dist_exist = 'N' THEN
        DECLARE
            p_no_of_takeup      	GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
            p_yearly_tag            GIIS_TAKEUP_TERM.yearly_tag%TYPE;
		    p_takeup_term       	GIPI_WPOLBAS.takeup_term%TYPE;
		    v_policy_days           NUMBER := 0;
		    v_no_of_payment         NUMBER := 1;
		    v_duration_frm          DATE;
			v_duration_to           DATE;	
		    v_days_interval         NUMBER := 0;
        BEGIN
            SELECT eff_date, expiry_date, endt_type, takeup_term
			  INTO p_eff_date, p_expiry_date, p_endt_type, p_takeup_term
              FROM GIPI_WPOLBAS
             WHERE par_id = b_par_id;
            
            IF ((p_eff_date IS NULL ) OR (p_expiry_date IS NULL)) THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Could not proceed. The effectivity date or expiry date had not been updated.');
            END IF;
            
            IF TRUNC(p_expiry_date - p_eff_date) = 31 THEN
                v_policy_days := 30;
			ELSE
				v_policy_days := TRUNC(p_expiry_date - p_eff_date);
			END IF;
            
            FOR b1 IN (SELECT no_of_takeup, yearly_tag
						 FROM GIIS_TAKEUP_TERM
                        WHERE takeup_term = p_takeup_term)
			LOOP
                p_no_of_takeup := b1.no_of_takeup;
                p_yearly_tag := b1.yearly_tag;
			END LOOP;
            
            IF p_yearly_tag = 'Y' THEN
				IF TRUNC((v_policy_days) / 365, 2) * p_no_of_takeup > TRUNC(TRUNC((v_policy_days) / 365, 2) * p_no_of_takeup) THEN
                    v_no_of_payment := TRUNC(TRUNC((v_policy_days) / 365, 2) * p_no_of_takeup) + 1;
				ELSE
					v_no_of_payment := TRUNC(TRUNC((v_policy_days) / 365, 2) * p_no_of_takeup);
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
            
            v_days_interval := ROUND(v_policy_days / v_no_of_payment);
			p_policy_id := NULL;
            
            IF v_no_of_payment = 1 THEN
                BEGIN
                    SELECT POL_DIST_DIST_NO_S.NEXTVAL
                      INTO p2_dist_no
                      FROM DUAL;
       	        EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No row in table SYS.DUAL.');
                    WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No row in table SYS.DUAL.');
       	        END;
                
                INSERT INTO GIUW_POL_DIST
                       (dist_no, par_id, policy_id, endt_type, tsi_amt,
                        prem_amt, ann_tsi_amt, dist_flag, redist_flag,
                        eff_date, expiry_date, create_date, user_id, last_upd_date)
                VALUES (p2_dist_no, b_par_id, p_policy_id, p_endt_type, NVL(v_tsi_amt, 0),
                        NVL(v_prem_amt, 0), NVL(v_ann_tsi_amt, 0), 1, 1,
					    p_eff_date, p_expiry_date, SYSDATE, p_user_id, SYSDATE);
            ELSE
                v_duration_frm := NULL;
				v_duration_to  := NULL;
                
                FOR takeup_val IN 1.. v_no_of_payment LOOP
                    IF v_duration_frm IS NULL THEN
			            v_duration_frm := TRUNC(p_eff_date);
					ELSE
					    v_duration_frm := TRUNC(v_duration_frm + v_days_interval);						   
					END IF;
					v_duration_to := TRUNC(v_duration_frm + v_days_interval) - 1;
                        
                    BEGIN
                        SELECT POL_DIST_DIST_NO_S.NEXTVAL
                          INTO p2_dist_no
                          FROM DUAL;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No row in table SYS.DUAL.');
                        WHEN OTHERS THEN
                            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No row in table SYS.DUAL.');
                    END;
                    
                    IF takeup_val = v_no_of_payment THEN
                        INSERT INTO GIUW_POL_DIST
                               (dist_no, par_id, policy_id, endt_type, 
                                dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                last_upd_date, post_flag, auto_dist, tsi_amt, prem_amt, ann_tsi_amt)
                        VALUES (p2_dist_no,b_par_id,p_policy_id,p_endt_type,													        
                                1,1,v_duration_frm,v_duration_to,sysdate,user,
                                sysdate, 'O', 'N', NVL(v_tsi_amt,0) , NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                NVL(v_ann_tsi_amt,0));
                    ELSE
                        INSERT INTO GIUW_POL_DIST
                               (dist_no, par_id, policy_id, endt_type, 
                                dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                last_upd_date, post_flag, auto_dist, tsi_amt, prem_amt, ann_tsi_amt)
                        VALUES (p2_dist_no, b_par_id, p_policy_id, p_endt_type,													        
                                1, 1, v_duration_frm, v_duration_to, sysdate, p_user_id,
                                SYSDATE, 'O', 'N', (NVL(v_tsi_amt, 0)), (NVL(v_prem_amt, 0) / v_no_of_payment), (NVL(v_ann_tsi_amt, 0)));
                    END IF;
                END LOOP;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.');
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator ' ||
                    'to rectify the matter. Check record with par_id = ' || TO_CHAR(b_par_id));
        END;
        
        DELETE FROM GIUW_POL_DIST a
	     WHERE par_id = b_par_id
	       AND dist_no = pi_dist_no
	       AND NOT EXISTS(SELECT 1 
                            FROM GIPI_WITEM b
                           WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
                             AND b.par_id = a.par_id);
    END IF;
END;
/


