DROP PROCEDURE CPI.CREATE_NEGATED_RECORDS_FLAT2;

CREATE OR REPLACE PROCEDURE CPI.Create_Negated_Records_Flat2 (
	p_par_id				IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd				IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd			IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd				IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy				IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no			IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no				IN GIPI_WPOLBAS.renew_no%TYPE,
	p_co_insurance_sw		IN GIPI_WPOLBAS.co_insurance_sw%TYPE,
	p_pack_pol_flag			IN VARCHAR2,
	p_eff_date				OUT VARCHAR,
	p_b240_par_status		OUT GIPI_PARLIST.par_status%TYPE,
	p_tsi_amt				OUT GIPI_WPOLBAS.tsi_amt%TYPE,
	p_prem_amt				OUT GIPI_WPOLBAS.prem_amt%TYPE,
    p_ann_tsi_amt           OUT GIPI_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt          OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
    p_v_expiry_date         OUT VARCHAR2,
    p_incept_date           OUT VARCHAR2,
    p_expiry_date           OUT VARCHAR2,
    p_endt_expiry_date      OUT VARCHAR2,
    p_gipi_witem            OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_witem,
    p_gipi_wfireitm         OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wfireitm,
    p_gipi_wvehicle         OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wvehicle,
    p_gipi_waccident_item   OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_waccident_item,
    p_gipi_waviation_item   OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_waviation_item,
    p_gipi_wcargo           OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wcargo,
    p_gipi_wcasualty_item   OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wcasualty_item,
    p_gipi_wengg_basic      OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wengg_basic,
    p_gipi_witem_ves        OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_witem_ves,
    p_gipi_witmperl         OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_witmperl,
    p_msg_alert             OUT VARCHAR2)
AS
    /*
    **  Created by        : Emman
    **  Date Created     : 03.20.2011
    **  Reference By     : (GIPIS031A - Pack Endt Basic Information)
    **  Description     : This procedure create records in gipi_witem and
    **                  : gipi_witmperl which will negate all the policy's 
    **                  : peril and tsi (Original Description)
    */
    v_max_eff_date1        GIPI_WPOLBAS.eff_date%TYPE;
    v_max_eff_date2        GIPI_WPOLBAS.eff_date%TYPE;
    v_max_eff_date         GIPI_WPOLBAS.eff_date%TYPE;
    v_eff_date             GIPI_WPOLBAS.eff_date%TYPE;
    v_max_endt_seq_no      GIPI_WPOLBAS.endt_seq_no%TYPE;
    v_max_endt_seq_no1     GIPI_WPOLBAS.endt_seq_no%TYPE;
    
    v_policy_id        GIPI_POLBASIC.policy_id%TYPE;
BEGIN
	 FOR var IN (SELECT a.par_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
	               FROM gipi_wpolbas b, gipi_parlist a 
	              WHERE 1=1
	                AND b.par_id = a.par_id
	                AND a.pack_par_id = p_par_id
	                AND a.par_status NOT IN (98,99))
	 LOOP
	    --p_v_expiry_date := Extract_Expiry(var.par_id); -- replace by: Nica 11.16.2011
        p_v_expiry_date := pack_endt_extract_expiry(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
        
	    Pack_endt_Delete_Other_Info(var.par_id);
	    Pack_Endt_Delete_Records(var.par_id, var.line_cd, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	                             v_eff_date, p_co_insurance_sw, p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert);
	    
	    IF NOT p_msg_alert IS NULL THEN
	        GOTO RAISE_FORM_TRIGGER_FAILURE;
	    END IF;
	    
	    Gipi_Polbasic_Pkg.get_eff_date_policy_id(var.line_cd, var.subline_cd, var.iss_cd,
	        var.issue_yy, var.pol_seq_no, var.renew_no, v_eff_date, v_policy_id);    
	    
	    v_max_endt_seq_no := Gipi_Polbasic_Pkg.get_max_endt_seq_no(var.line_cd, var.subline_cd, var.iss_cd,
	        var.issue_yy, var.pol_seq_no, var.renew_no, NULL, 'FLAT_CANCELLATION');
	    
	    IF v_max_endt_seq_no > 0 THEN
	        v_max_endt_seq_no1 := Gipi_Polbasic_Pkg.get_max_endt_seq_no_back_stat(var.line_cd, var.subline_cd, var.iss_cd,
	            var.issue_yy, var.pol_seq_no, var.renew_no, NULL, 'FLAT_CANCELLATION');
	        
	        IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN             
	            v_max_eff_date1 := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(var.line_cd, var.subline_cd, var.iss_cd,
	                var.issue_yy, var.pol_seq_no, var.renew_no, NULL, v_max_endt_seq_no1, 'FLAT_CANCELLATION');
	            
	            v_max_eff_date2 := Gipi_Polbasic_Pkg.get_endt_max_eff_date(var.line_cd, var.subline_cd, var.iss_cd,
	                var.issue_yy, var.pol_seq_no, var.renew_no, NULL, 'FLAT_CANCELLATION');
	                
	            v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1); 
	        ELSE
	            v_max_eff_date := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(var.line_cd, var.subline_cd, var.iss_cd,
	                var.issue_yy, var.pol_seq_no, var.renew_no, NULL, v_max_endt_seq_no1, 'FLAT_CANCELLATION2');
	        END IF;
	    ELSE
	        v_max_eff_date := v_eff_date;                
	    END IF;    
	    
	    -- get latest data for dates coming from latest endt. 
	    -- (backward endt. is considered)
	    FOR DT IN (
	        SELECT b250.incept_date, b250.expiry_date
	          FROM GIPI_POLBASIC b250
	         WHERE b250.line_cd    = var.line_cd
	           AND b250.subline_cd = var.subline_cd
	           AND b250.iss_cd     = var.iss_cd
	           AND b250.issue_yy   = var.issue_yy
	           AND b250.pol_seq_no = var.pol_seq_no
	           AND b250.renew_no   = var.renew_no
	           AND b250.pol_flag   IN ('1','2','3','X') 
	           AND b250.eff_date   = v_max_eff_date 
	      ORDER BY b250.endt_seq_no DESC)
	    LOOP
	        p_eff_date         := TO_CHAR(dt.incept_date, 'MM-DD-RRRR HH24:MI:SS');
	        p_incept_date      := TO_CHAR(dt.incept_date, 'MM-DD-RRRR HH24:MI:SS');
	        p_expiry_date      := TO_CHAR(dt.expiry_date, 'MM-DD-RRRR HH24:MI:SS');
	        p_endt_expiry_date := TO_CHAR(dt.expiry_date, 'MM-DD-RRRR HH24:MI:SS');
			
			UPDATE gipi_wpolbas        
			   SET eff_date         = dt.incept_date,
		           incept_date      = dt.incept_date,
		           expiry_date      = dt.expiry_date,
		           endt_expiry_date = dt.expiry_date
			 WHERE par_id = var.par_id; 
	        EXIT;
	    END LOOP;
	    
	    --create negated records in table gipi_witem,gipi_witmperl
	    --select first all existing item from policy and all it's endt.              
	    FOR A1 IN (
	        SELECT DISTINCT b340.item_no item_no
	          FROM GIPI_POLBASIC b250, GIPI_ITEM b340
	         WHERE b250.line_cd    = var.line_cd
	           AND b250.subline_cd = var.subline_cd
	           AND b250.iss_cd     = var.iss_cd
	           AND b250.issue_yy   = var.issue_yy
	           AND b250.pol_seq_no = var.pol_seq_no
	           AND b250.renew_no   = var.renew_no
	           AND b250.policy_id  = b340.policy_id
	           AND b250.pol_flag   IN ('1','2','3','X'))
	    LOOP
	        --call procedure that will get latest info. for every item
	        --and insert it in table gipi_witem
	        Pack_Endt_Get_Neg_Item(var.par_id, a1.item_no, var.line_cd);
	        --change item grouping
	        Change_Item_Grp(var.par_id, p_pack_pol_flag);
	        --summarized all peril for a particular item
	        --and insert records in table gipi_witmperl
	        
	        FOR A2 IN(
	            SELECT b380.peril_cd peril_cd, SUM(b380.prem_amt) prem, SUM(b380.tsi_amt) tsi,
	                   SUM(NVL(b380.ri_comm_amt,0)) comm
	              FROM GIPI_POLBASIC b250, GIPI_ITMPERIL b380
	             WHERE b250.line_cd    = var.line_cd
	               AND b250.subline_cd = var.subline_cd
	               AND b250.iss_cd     = var.iss_cd
	               AND b250.issue_yy   = var.issue_yy
	               AND b250.pol_seq_no = var.pol_seq_no
	               AND b250.renew_no   = var.renew_no
	               AND b250.pol_flag   IN ('1','2','3','X') 
	               AND b250.policy_id  = b380.policy_id
	               AND b380.item_no    = A1.item_no
	          GROUP BY b380.peril_cd) 
	        LOOP
	            IF NVL(a2.comm,0) <> 0 THEN
	                a2.comm := -a2.comm;
	            END IF;
	            
	            INSERT INTO GIPI_WITMPERL (
	                par_id,        item_no,        line_cd,       peril_cd,
	                tsi_amt,    prem_amt,        ann_tsi_amt,   ann_prem_amt,
	                rec_flag,    ri_comm_rate,     ri_comm_amt)
	            VALUES (
	                var.par_id,     a1.item_no,     var.line_cd,         a2.peril_cd,          
	                -a2.tsi,    -a2.prem,        0,                0,
	                'D',        0,                a2.comm);            
	        END LOOP;
	    END LOOP;
	    
	    --update amounts of table gipi_witem, gipi_wpolbas refering to the created
	    --records in tanle gipi_witmperl
	    FOR ITEM IN (
	        SELECT item_no
	          FROM GIPI_WITEM
	         WHERE par_id = var.par_id)
	    LOOP
	        FOR PERIL IN (
	            SELECT SUM(NVL(prem_amt,0)) prem
	              FROM GIPI_WITMPERL
	             WHERE par_id = var.par_id
	               AND item_no = item.item_no)
	        LOOP
	            UPDATE GIPI_WITEM
	               SET prem_amt = peril.prem
	             WHERE par_id = var.par_id
	               AND item_no = item.item_no;
	        END LOOP;
	        
	        FOR PERIL2 IN (
	            SELECT SUM(NVL(tsi_amt,0)) tsi
	              FROM GIPI_WITMPERL a, GIIS_PERIL b
	             WHERE a.par_id = var.par_id
	               AND a.peril_cd = b.peril_cd
	               AND a.line_cd  = b.line_cd
	               AND b.peril_type = 'B'
	               AND item_no = item.item_no)
	        LOOP
	            UPDATE GIPI_WITEM
	               SET tsi_amt  = peril2.tsi
	             WHERE par_id = var.par_id
	               AND item_no = item.item_no;
	        END LOOP;
	    END LOOP;
	    
	    /* Update invoice records */
	    BEGIN
	        IF p_pack_pol_flag = 'Y' THEN
	            FOR PACK IN (
	                SELECT pack_line_cd, item_no
	                  FROM GIPI_WITEM
	                 WHERE par_id = var.par_id)
	            LOOP
	                FOR A IN (
	                    SELECT '1'
	                      FROM GIPI_WITMPERL
	                     WHERE par_id  = var.par_id)
	                LOOP
	                    Create_Winvoice(0, 0, 0, var.par_id, pack.pack_line_cd, var.iss_cd);
	                    EXIT;
	                END LOOP;
	            END LOOP;
	        ELSE
	            FOR A IN (
	                SELECT '1'
	                  FROM GIPI_WITMPERL
	                 WHERE par_id  = var.par_id)
	            LOOP
	               Create_Winvoice(0, 0, 0, var.par_id, var.line_cd, var.iss_cd);
	               EXIT;
	            END LOOP;
	        END IF;
			
			Gipi_Witem_Pkg.GET_TSI_PREM_AMT(var.par_id, p_tsi_amt, p_prem_amt);        
	        p_ann_tsi_amt  := 0;
	        p_ann_prem_amt := 0;
			
			UPDATE gipi_wpolbas        
			   SET tsi_amt = p_tsi_amt,
			       prem_amt = p_prem_amt,
			       ann_tsi_amt = 0,
			       ann_prem_amt = 0
			 WHERE par_id = var.par_id;
			 
			FOR UPD_PACK_POLBAS IN(SELECT SUM(tsi_amt) tsi, 
		                            SUM(prem_amt) prem
		                       FROM gipi_wpolbas
		                      WHERE pack_par_id = p_par_id) LOOP
		       p_tsi_amt      := upd_pack_polbas.tsi;
		       p_prem_amt     := upd_pack_polbas.prem;
		       p_ann_tsi_amt  := 0;
		       p_ann_prem_amt := 0;           
		    END LOOP;         
	        
	        Cr_Bill_Dist.get_tsi(var.par_id);
	    END;
		
		UPDATE GIPI_PARLIST
	       SET par_status = 5
	     WHERE par_id = var.par_id;
	END LOOP;
 
    p_b240_par_status := '5';
	
	UPDATE gipi_wpolbas
       SET prorate_flag = 2,
           comp_sw      = NULL,
           pol_flag     = '4'
     WHERE pack_par_id = p_par_id;
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
    
    OPEN p_gipi_witem FOR
    SELECT *
      FROM GIPI_WITEM
     WHERE par_id IN (SELECT a.par_id FROM GIPI_PARLIST a
                      WHERE a.pack_par_id = p_par_id
                      AND a.par_status NOT IN (98,99));
    
    OPEN p_gipi_wfireitm FOR
    SELECT *
      FROM GIPI_WFIREITM
     WHERE par_id IN (SELECT a.par_id FROM GIPI_PARLIST a
                      WHERE a.pack_par_id = p_par_id
                      AND a.par_status NOT IN (98,99));
     
    OPEN p_gipi_wvehicle FOR
    SELECT *
      FROM GIPI_WVEHICLE
     WHERE par_id = p_par_id;
     
    OPEN p_gipi_waccident_item FOR
    SELECT *
      FROM GIPI_WACCIDENT_ITEM
     WHERE par_id = p_par_id;
    
    OPEN p_gipi_waviation_item FOR
    SELECT *
      FROM GIPI_WAVIATION_ITEM
     WHERE par_id = p_par_id;
    
    OPEN p_gipi_wcargo FOR
    SELECT *
      FROM GIPI_WCARGO
     WHERE par_id = p_par_id;
    
    OPEN p_gipi_wcasualty_item FOR
    SELECT *
      FROM GIPI_WCASUALTY_ITEM
     WHERE par_id = p_par_id;
    
    OPEN p_gipi_wengg_basic FOR
    SELECT *
      FROM GIPI_WENGG_BASIC
     WHERE par_id = p_par_id;
    
    OPEN p_gipi_witem_ves FOR
    SELECT *
      FROM GIPI_WITEM_VES
     WHERE par_id = p_par_id;    
    
    OPEN p_gipi_witmperl FOR
    SELECT *
      FROM GIPI_WITMPERL
     WHERE par_id IN (SELECT a.par_id FROM GIPI_PARLIST a
                      WHERE a.pack_par_id = p_par_id
                      AND a.par_status NOT IN (98,99));
     
END Create_Negated_Records_Flat2;
/


