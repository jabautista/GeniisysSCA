DROP PROCEDURE CPI.CREATE_DISTRIBUTION_ITEM_ENDT;

CREATE OR REPLACE PROCEDURE CPI.CREATE_DISTRIBUTION_ITEM_ENDT (
	p_par_id	IN gipi_parlist.par_id%TYPE,
	p_dist_no	IN giuw_pol_dist.dist_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.06.2010
	**  Reference By 	: (GIPI061 - Endt Item Information - Casualty)
	**  Description 	: Procedure to create distribution
	*/
	v_exist1		NUMBER;	-- b_exist
	v_exist2		NUMBER;	-- p_exist
	v_tsi_amt		gipi_witem.tsi_amt%TYPE      := 0;
	v_ann_tsi_amt	gipi_witem.ann_tsi_amt%TYPE  := 0;
	v_prem_amt		gipi_witem.prem_amt%TYPE     := 0;
	v_but			NUMBER;
	v_dist_cnt		NUMBER := 0;
	v_dist_max		giuw_pol_dist.dist_no%TYPE;
	
	CURSOR C1 IS
		SELECT DISTINCT  frps_yy , frps_seq_no
		  FROM giri_wdistfrps
		 WHERE dist_no = p_dist_no;
	CURSOR  C2 IS
		SELECT DISTINCT  frps_yy , frps_seq_no
		  FROM giri_distfrps
		 WHERE dist_no = p_dist_no;
BEGIN
	SELECT SUM(tsi_amt     * currency_rt),
           SUM(ann_tsi_amt * currency_rt),
           SUM(prem_amt    * currency_rt)
	  INTO v_tsi_amt,
		   v_ann_tsi_amt,
		   v_prem_amt
	  FROM gipi_witem
	 WHERE par_id = p_par_id;

    IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)) THEN
        Gipis010_Delete_Ri_Tables(p_dist_no);
        Gipis010_Del_Wrkng_Dist_Tables(p_dist_no);
        Gipis010_Del_Main_Dist_Tables(p_dist_no);
        Giuw_Distrel_Pkg.del_giuw_distrel(p_dist_no);
        Giuw_Pol_Dist_Pkg.del_giuw_pol_dist(p_dist_no);          
    END IF;
    
    BEGIN
        SELECT DISTINCT 1
          INTO v_exist1
          FROM giuw_policyds
         WHERE dist_no  =  p_dist_no;
         
        IF SQL%FOUND THEN
            -- confirmation
            -- see alert REC_EXISTS_IN_POST_POL_TAB in GIPIS061
            Gipis010_Delete_Ri_Tables(p_dist_no);
            Gipis010_Del_Wrkng_Dist_Tables(p_dist_no);
            Gipis010_Del_Main_Dist_Tables(p_dist_no);
            
            UPDATE GIUW_POL_DIST
               SET user_id = USER,
                   last_upd_date = SYSDATE,
                   dist_type = NULL,
                   dist_flag = '1'
             WHERE dist_no = p_dist_no;

            UPDATE GIPI_WPOLBAS
               SET user_id = USER
             WHERE par_id  = p_par_id;
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    BEGIN
        SELECT DISTINCT 1
          INTO v_exist2
          FROM giuw_wpolicyds
         WHERE dist_no  =  p_dist_no;
        
        -- confirmation
        -- see alert DISTRIBUTION in GIPIS061        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_but := 1;
    END;
    
    IF v_but = 1 THEN
        FOR C1_rec IN C1
        LOOP
            Gipis010_Delete_Ri_Tables(p_dist_no);
            Giri_Wfrperil_Pkg.del_giri_wfrperil_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
            Giri_Wfrps_Ri_Pkg.del_giri_wfrps_ri_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
            Giri_Wdistfrps_Pkg.del_giri_wdistfrps(p_dist_no);
        END LOOP;
        
        FOR C2_rec IN C2
        LOOP
            RAISE_APPLICATION_ERROR(20000, 'This PAR has corresponding records in the posted tables for RI.'||
                    ' Could not proceed.');
        END LOOP;
        
        DELETE_WORKING_DIST_TABLES(p_dist_no);
    END IF;
    
    -------------------------------------------------------------
    
    FOR a IN (
        SELECT SUM(tsi_amt     * currency_rt) tsi_amt,
               SUM(ann_tsi_amt * currency_rt) ann_tsi_amt,
               SUM(prem_amt    * currency_rt) prem_amt,
               item_grp
          FROM gipi_witem
         WHERE par_id = p_par_id
      GROUP BY item_grp)
    LOOP
        BEGIN 
            IF v_but = 1 THEN
                BEGIN
                    SELECT COUNT(dist_no), MAX(dist_no)
                      INTO v_dist_cnt, v_dist_max
                      FROM giuw_pol_dist
                     WHERE par_id = p_par_id
                       AND NVL(item_grp, a.item_grp) = a.item_grp;
                END; 

                IF v_dist_cnt > 1 THEN
                    v_tsi_amt     := a.tsi_amt;
                    v_prem_amt    := a.prem_amt;
                    v_ann_tsi_amt := a.ann_tsi_amt;
                END IF;
              
                IF p_dist_no = v_dist_max THEN 
                    UPDATE giuw_pol_dist
                       SET tsi_amt = NVL(v_tsi_amt,0) , 
                           prem_amt = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/v_dist_cnt),2) * (v_dist_cnt - 1)),
                           ann_tsi_amt = NVL(v_ann_tsi_amt,0),
                           last_upd_date =  SYSDATE,
                           user_id =  USER
                     WHERE par_id  =  p_par_id
                       AND dist_no =  p_dist_no
                       AND NVL(item_grp,a.item_grp) = a.item_grp;     
                
                ELSE
                    UPDATE giuw_pol_dist
                       SET tsi_amt = NVL(v_tsi_amt,0), 
                           prem_amt = NVL(v_prem_amt,0) / v_dist_cnt,
                           ann_tsi_amt = NVL(v_ann_tsi_amt,0),
                           last_upd_date =  SYSDATE,
                           user_id=  USER
                     WHERE par_id  =  p_par_id
                       AND dist_no =  p_dist_no
                       AND NVL(item_grp,a.item_grp) = a.item_grp;
                END IF;    
            END IF;
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(20000, 'There are too many distribution numbers ' ||
                                'assigned for this item. Please call your administrator to rectify the matter. Check '||
                                'records in the policy table with par_id = ' || TO_CHAR(p_par_id) || '.');
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;  
    END LOOP;
    
    DELETE FROM giuw_pol_dist a
     WHERE par_id = p_par_id
       AND dist_no = p_dist_no
       AND NOT EXISTS (
            SELECT 1 
              FROM gipi_witem b
             WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
            AND b.par_id = a.par_id);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(20000, 'Pls. be adviced that there are no items for this PAR.');
END CREATE_DISTRIBUTION_ITEM_ENDT;
/


