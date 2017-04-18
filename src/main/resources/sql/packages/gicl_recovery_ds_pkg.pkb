CREATE OR REPLACE PACKAGE BODY CPI.GICL_RECOVERY_DS_PKG AS
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  01-04-2011 
    **  Reference By : (GICLS055 - Generate Acct. Entries - Loss Recovery)  
    **  Description  :  get recovery ds record
    */ 
    FUNCTION get_gicl_recovery_ds (
        p_recovery_id             GICL_RECOVERY_DS.recovery_id%TYPE,
        p_recovery_payt_id        GICL_RECOVERY_DS.recovery_payt_id%TYPE           
    ) RETURN gicl_recovery_ds_tab PIPELINED IS
        v_rec_ds                  gicl_recovery_ds_type;
    BEGIN
        FOR i IN (
            SELECT * FROM gicl_recovery_ds
             WHERE recovery_id = p_recovery_id
               AND recovery_payt_id = p_recovery_payt_id
               AND NVL(negate_tag,'N') = 'N') 
		LOOP
            v_rec_ds.recovery_id             := i.recovery_id;
            v_rec_ds.recovery_payt_id        := i.recovery_payt_id;
            v_rec_ds.rec_dist_no             := i.rec_dist_no;
            v_rec_ds.line_cd                 := i.line_cd;
            v_rec_ds.grp_seq_no              := i.grp_seq_no;
            v_rec_ds.dist_year               := i.dist_year;
            v_rec_ds.share_type              := i.share_type;
            v_rec_ds.acct_trty_type          := i.acct_trty_type;
            v_rec_ds.share_pct               := i.share_pct;
            v_rec_ds.shr_recovery_amt        := i.shr_recovery_amt;
            v_rec_ds.negate_tag              := i.negate_tag;
            v_rec_ds.negate_date             := i.negate_date;
            
            FOR s iN (SELECT trty_name
                        FROM giis_dist_share
                       WHERE line_cd = i.line_cd
                         AND share_cd = i.grp_seq_no)
            LOOP
               v_rec_ds.dsp_share_name := s.trty_name;
            END LOOP;
          PIPE ROW(v_rec_ds);    
        END LOOP;
    END get_gicl_recovery_ds;

	/*
	**  Created by   :  Belle Bebing
	**  Date Created :  04.19.2012
	**  Reference By : GICLS054 - Recovery Distribution
	**  Description :  get recovery distribution
	*/
	FUNCTION get_recovery_distribution(
		p_recovery_id       gicl_recovery_ds.recovery_id%TYPE,
		p_recovery_payt_id   gicl_recovery_ds.recovery_payt_id%TYPE
	)   
	  RETURN gicl_recovery_ds_tab PIPELINED IS
		rec     gicl_recovery_ds_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GICL_RECOVERY_DS
                   WHERE NVL(negate_tag,'N') = 'N'
                     AND recovery_id = p_recovery_id
                     AND recovery_payt_id = p_recovery_payt_id
                ORDER BY share_type )
        LOOP
            rec.recovery_id         := i.recovery_id;
            rec.recovery_payt_id    := i.recovery_payt_id;
            rec.rec_dist_no         := i.rec_dist_no;
            rec.dsp_line_cd         := i.line_cd;
            rec.grp_seq_no          := i.grp_seq_no;
            rec.acct_trty_type      := i.acct_trty_type;
            rec.share_type          := i.share_type;
            rec.share_pct           := i.share_pct;
            rec.dist_year           := i.dist_year;
            rec.shr_recovery_amt    := i.shr_recovery_amt;
            rec.negate_tag          := i.negate_tag;
            rec.negate_date         := i.negate_date; 
            
            BEGIN
                FOR s iN (SELECT trty_name
                            FROM giis_dist_share
                           WHERE line_cd  = i.line_cd
                             AND share_cd = i.grp_seq_no)
                LOOP
                    rec.dsp_share_name := s.trty_name;
                END LOOP;
            END;
            PIPE ROW(rec);
        END LOOP;
    END;
    
    PROCEDURE update_gicls054_ri_shares (
      p_recovery_id        VARCHAR2,
      p_recovery_payt_id   VARCHAR2
   )
   IS
   BEGIN
      FOR i IN (SELECT rec_dist_no, grp_seq_no,
                       share_pct, shr_recovery_amt
                  FROM GICL_RECOVERY_DS
                 WHERE NVL(negate_tag,'N') = 'N'
                   AND recovery_id = p_recovery_id
                   AND recovery_payt_id = p_recovery_payt_id)
      LOOP
         --modified by jdiago 08012014 : added * 100
         UPDATE gicl_recovery_rids
            SET share_ri_pct = (i.share_pct * share_ri_pct_real / 100) * 100,
                shr_ri_recovery_amt = (i.shr_recovery_amt * share_ri_pct_real / 100) * 100
          WHERE recovery_id = p_recovery_id  
            AND recovery_payt_id = p_recovery_payt_id
            AND rec_dist_no = i.rec_dist_no
            AND grp_seq_no = i.grp_seq_no
            AND NVL(negate_tag, 'N') = 'N';      
         
      END LOOP;                
   END update_gicls054_ri_shares;
	
	/*
	**  Created by   :  Belle Bebing
	**  Date Created :  04.26.2012 
	**  Reference By : (GICLS054 - Recovery Distribution)  
	**  Description  :  Distribute recovery
	*/ 
	PROCEDURE DISTRIBUTE_RECOVERY (
		p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_payt.recovery_payt_id%TYPE,
		p_dsp_line_cd           gipi_polbasic.line_cd%TYPE,
		p_dsp_subline_cd        gipi_polbasic.subline_cd%TYPE,
		p_dsp_iss_cd            gipi_polbasic.iss_cd%TYPE,
		p_dsp_issue_yy          gipi_polbasic.issue_yy%TYPE,
		p_dsp_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
		p_dsp_renew_no          gipi_polbasic.renew_no%TYPE,
		p_eff_date              gipi_polbasic.eff_date%TYPE,
		p_expiry_date           gipi_polbasic.expiry_date%TYPE,
		p_loss_date             gicl_claims.loss_date%TYPE                        
	) IS
	  sum_tsi_amt           giri_basic_info_item_sum_v.tsi_amt%TYPE;
	  ann_ri_pct            NUMBER(12,9);
	  ann_dist_spct         gicl_loss_exp_ds.shr_loss_exp_pct%type := 0;
	  shr                   NUMBER := 0;
	  v_facul_share_cd      giuw_perilds_dtl.share_cd%TYPE;
	  v_trty_share_type     giis_dist_share.share_type%TYPE;
	  v_facul_share_type    giis_dist_share.share_type%TYPE;
	  v_recovered_amt       gicl_recovery_payt.recovered_amt%TYPE;
	  v_trty_limit          giis_dist_share.trty_limit%type;  
	  v_facul_amt           gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
	  v_orig_net_amt        gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
	  v_treaty_amt          gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
	  v_qs_shr_pct          giis_dist_share.qs_shr_pct%type;
	  v_acct_trty_type      giis_dist_share.acct_trty_type%type;
	  v_share_cd            giis_dist_share.share_cd%type;
	  v_policy              VARCHAR2(2000);
	  counter               NUMBER := 0;
	  v_switch              NUMBER := 0;
	  v_policy_id           NUMBER;
	  v_rec_dist_no         NUMBER := 0;
	  v_peril_sname         giis_peril.peril_sname%type;
	  v_trty_peril          giis_peril.peril_sname%type;
	  v_dist_flag           giis_parameters.param_value_v%type;
	  v_item                gicl_item_peril.item_no%type;
	  v_peril               gicl_item_peril.peril_cd%type; 
	  v1_share_cd           giis_dist_share.share_cd%TYPE; 
	  v1_share_type         giis_dist_share.share_type%TYPE;
	  v1_acct_trty_type     giis_dist_share.acct_trty_type%TYPE;
	  v1_trty_yy            giis_dist_share.trty_yy%TYPE;  
	  v1_expiry_date        giis_dist_share.expiry_date%TYPE;
	  var_rec_dist_no       NUMBER := 0;
	BEGIN
	  FOR d IN (SELECT param_value_v
				  FROM giis_parameters
				 WHERE param_name = 'DISTRIBUTED') 
	  LOOP
		v_dist_flag := d.param_value_v;
	  END LOOP;
	
	  BEGIN
		SELECT param_value_n
		  INTO v_facul_share_cd
		  FROM giis_parameters
		 WHERE param_name = 'FACULTATIVE';
	  EXCEPTION
		WHEN NO_DATA_FOUND THEN
			raise_application_error (-20001, 'Geniisys Exception#I#There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.');
	  END;
	
	  BEGIN
		SELECT param_value_v
		  INTO v_trty_share_type
		  FROM giac_parameters
		 WHERE param_name = 'TRTY_SHARE_TYPE';
	  EXCEPTION
		WHEN NO_DATA_FOUND THEN
		  raise_application_error (-20001, 'Geniisys Exception#I#There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table.');
	  END;
	
	  BEGIN
		SELECT param_value_v
		  INTO v_facul_share_type
		  FROM giac_parameters
		 WHERE param_name = 'FACUL_SHARE_TYPE';
	  EXCEPTION
		WHEN NO_DATA_FOUND THEN
		  raise_application_error (-20001, 'Geniisys Exception#I#There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table.');
	  END;
	
	  BEGIN
		SELECT param_value_n
		  INTO v_acct_trty_type
		  FROM giac_parameters
		 WHERE param_name = 'QS_ACCT_TRTY_TYPE';
	  EXCEPTION
		WHEN NO_DATA_FOUND THEN
		  raise_application_error (-20001, 'Geniisys Exception#I#There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table.');
	  END;
	
	  BEGIN 
		 SELECT max(rec_dist_no)
		   INTO var_rec_dist_no
		   FROM gicl_recovery_ds
		  WHERE recovery_id = p_recovery_id
			AND recovery_payt_id = p_recovery_payt_id;
	  EXCEPTION
		WHEN NO_DATA_FOUND THEN
		   var_rec_dist_no := 0;
	  END;
	  
	--    variables.rec_dist_no := NVL(var_rec_dist_no,0) + 1;
	--    v_rec_dist_no := variables.rec_dist_no;   //belle 04.26.2012
		  v_rec_dist_no := NVL(var_rec_dist_no,0) + 1;
	  
	  FOR rec IN 
		(SELECT claim_id, recovery_id, recovery_payt_id, recovered_amt
		   FROM gicl_recovery_payt
		  WHERE recovery_id = p_recovery_id
			AND recovery_payt_id = p_recovery_payt_id)
	  LOOP 
		FOR itm IN
		  (SELECT d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
				  f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi, 
				  f.eff_date, f.expiry_date
			 FROM gipi_polbasic a, gipi_item b,
				  giuw_pol_dist c, giuw_itemperilds_dtl d,  
				  giis_dist_share f
			WHERE f.share_cd = d.share_cd
			  AND f.line_cd  = d.line_cd
			  AND d.item_no IN (SELECT item_no
								  FROM gicl_clm_recovery_dtl
								 WHERE claim_id = rec.claim_id
								   AND recovery_id = rec.recovery_id)    
			  AND d.peril_cd IN (SELECT peril_cd 
								   FROM gicl_clm_recovery_dtl
								  WHERE claim_id = rec.claim_id
									AND recovery_id = rec.recovery_id)    
			  AND d.item_no = b.item_no
			  AND d.dist_no = c.dist_no
			  AND c.dist_flag = 3
			  AND c.policy_id = b.policy_id
			  AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
						DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_eff_date, a.eff_date ),c.eff_date)) <= p_loss_date 
			  AND TRUNC(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),
						DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date,p_expiry_date,a.endt_expiry_date),c.expiry_date)) >= p_loss_date
			  AND b.policy_id = a.policy_id
			  AND a.line_cd = p_dsp_line_cd
			  AND a.subline_cd = p_dsp_subline_cd
			  AND a.iss_cd = p_dsp_iss_cd
			  AND a.issue_yy = p_dsp_issue_yy
			  AND a.pol_seq_no = p_dsp_pol_seq_no
			  AND a.renew_no = p_dsp_renew_no
			  AND a.pol_flag IN ('1','2','3','X')
			GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
					 a.pol_seq_no, a.renew_no, d.share_cd, f.share_type, 
					 f.trty_yy, f.acct_trty_type, --d.item_no, d.peril_cd, 
					 f.prtfolio_sw, f.eff_date, f.expiry_date)
		LOOP
		  v1_share_cd := itm.share_cd; 
		  v1_share_type := itm.share_type; 
		  v1_trty_yy := itm.trty_yy;  
		  v1_acct_trty_type := itm.acct_trty_type;  
		  v1_expiry_date := itm.expiry_date;
		  BEGIN
			SELECT SUM(c.tsi_amt) tsi_amt
			  INTO sum_tsi_amt 
			  FROM gipi_polbasic a, gipi_item b, 
				   gipi_itmperil c, giuw_pol_dist d 
			 WHERE a.policy_id = b.policy_id
			   AND b.policy_id = c.policy_id
			   AND b.item_no   = c.item_no
			   AND a.policy_id = d.policy_id
			   AND TRUNC(DECODE(TRUNC(d.eff_date),TRUNC(a.eff_date),
						 DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_eff_date,a.eff_date),d.eff_date)) <= p_loss_date 
			   --AND TRUNC(DECODE(TRUNC(a.expiry_date),TRUNC(a.expiry_date),
			    AND TRUNC(DECODE(TRUNC(d.expiry_date),TRUNC(a.expiry_date), --added by steven 12.07.2012 replaced codes above,basis for expiry should be expiry_date in giuw_pol_dist not in gipi_polbasic
						 DECODE(NVL(a.endt_expiry_date,a.expiry_date), a.expiry_date,p_expiry_date,a.endt_expiry_date),d.expiry_date)) >= p_loss_date
			   AND c.item_no IN (SELECT item_no
								   FROM gicl_clm_recovery_dtl
								  WHERE claim_id = rec.claim_id
									AND recovery_id = rec.recovery_id)    
			   AND c.peril_cd IN (SELECT peril_cd 
									FROM gicl_clm_recovery_dtl
								   WHERE claim_id = rec.claim_id
									 AND recovery_id = rec.recovery_id)    
			   AND a.line_cd = p_dsp_line_cd
			   AND a.subline_cd = p_dsp_subline_cd
			   AND a.iss_cd = p_dsp_iss_cd
			   AND a.issue_yy = p_dsp_issue_yy
			   AND a.pol_seq_no = p_dsp_pol_seq_no
			   AND a.renew_no = p_dsp_renew_no
			   AND a.pol_flag IN ('1','2','3','X')
			   AND d.dist_flag = v_dist_flag; 
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN
			  raise_application_error (-20001, 'Geniisys Exception#I#The TSI for this policy is Zero...');
		  END; 
	
		  IF itm.acct_trty_type = v_acct_trty_type THEN
			 v_switch  := 1;
		  ELSIF ((itm.acct_trty_type = v_acct_trty_type) OR
			 (itm.acct_trty_type is null)) and (v_switch <> 1) THEN
			 v_switch := 0;
		  END IF;
	
		  IF itm.share_type = v_trty_share_type THEN
			 DECLARE 
			   v_share_cd          giis_dist_share.share_cd%TYPE; 
			   v_treaty_yy2        giis_dist_share.trty_yy%TYPE; 
			   v_prtf_sw           giis_dist_share.prtfolio_sw%TYPE;
			   v_acct_trty         giis_dist_share.acct_trty_type%TYPE;
			   v_share_type        giis_dist_share.share_type%TYPE;
			   v_expiry_date       giis_dist_share.expiry_date%TYPE;
			 BEGIN              
			   IF NVL(itm.prtfolio_sw, 'N') = 'P' AND
				  TRUNC(itm.expiry_date) < TRUNC(SYSDATE) THEN
				  WHILE TRUNC(v1_expiry_date) < TRUNC(SYSDATE) 
				  LOOP 
					BEGIN
					  SELECT share_cd, trty_yy, NVL(prtfolio_sw, 'N'),
							 acct_trty_type, share_type, expiry_date
						INTO v_share_cd, v_treaty_yy2, v_prtf_sw,
							 v_acct_trty, v_share_type, v_expiry_date
						FROM giis_dist_share
					  WHERE line_cd     = p_dsp_line_cd
					   AND old_trty_seq_no =  v1_share_cd;                    
					EXCEPTION 
					  WHEN NO_DATA_FOUND THEN
					  	raise_application_error (-20001, 'Geniisys Exception#I#No new treaty set-up for year'|| TO_CHAR(SYSDATE,'YYYY'));
						EXIT;
					  WHEN TOO_MANY_ROWS THEN
					  	raise_application_error (-20001, 'Geniisys Exception#I#Too many treaty set-up for year'|| TO_CHAR(SYSDATE,'YYYY'));
					END;
					
					v1_share_cd       := v_share_cd;
					v1_share_type     := v_share_type;
					v1_acct_trty_type := v_acct_trty;  
					v1_trty_yy        := v_treaty_yy2;                    
					v1_expiry_date    := v_expiry_date;
					IF v_prtf_sw = 'N' THEN
					   EXIT;
					END IF;
				  END LOOP;
			   END IF;
			 END;
		  END IF;
	
		  ann_dist_spct := 0;
          IF sum_tsi_amt > 0 THEN -- add by jess 11.10.2010 to handle ORA-01476:divisor is equal to zero
              IF ((itm.acct_trty_type <> v_acct_trty_type) or (itm.acct_trty_type IS NULL)) 
                 AND v_switch = 0 THEN 
                 ann_dist_spct := (itm.ann_dist_tsi / sum_tsi_amt) * 100;
                 v_recovered_amt := rec.recovered_amt * ann_dist_spct/100;
              ELSE
                 IF (itm.share_type = v_trty_share_type) AND (itm.share_cd = v_share_cd) THEN
                    ann_dist_spct := (v_treaty_amt/sum_tsi_amt) * 100;
                    v_recovered_amt := rec.recovered_amt * ann_dist_spct/100;
                 ELSIF (itm.share_type != v_trty_share_type) AND  (itm.share_type != v_facul_share_type)
                    AND (v_recovered_amt IS NOT NULL) THEN
                    ann_dist_spct := (v_recovered_amt/sum_tsi_amt) * 100;
                    v_recovered_amt := rec.recovered_amt * ann_dist_spct/100;
                 ELSE
                    ann_dist_spct := (itm.ann_dist_tsi / sum_tsi_amt) * 100;
                    v_recovered_amt := rec.recovered_amt * ann_dist_spct/100;
                 END IF;
              END IF;
          ELSE --     jess 11.10.2010
              raise_application_error (-20001, 'Geniisys Exception#I#The TSI for this policy is Zero...');
          END IF;               
	
		  IF ann_dist_spct <> 0 THEN
			 INSERT INTO gicl_recovery_ds(recovery_id, recovery_payt_id,        
										  rec_dist_no, line_cd,         
										  grp_seq_no,  dist_year,        
										  share_type,  acct_trty_type,
										  share_pct,   shr_recovery_amt)
								  VALUES (p_recovery_id, p_recovery_payt_id,
										  v_rec_dist_no, p_dsp_line_cd,         
										  v1_share_cd,   TO_CHAR(SYSDATE,'YYYY'),  
										  v1_share_type, v1_acct_trty_type,
										  ann_dist_spct, v_recovered_amt);
	
			 shr := TO_NUMBER(itm.share_type) - TO_NUMBER(v_trty_share_type);
			 IF shr = 0 THEN
				FOR trty IN (SELECT ri_cd, trty_shr_pct, prnt_ri_cd
						  FROM giis_trty_panel
						 WHERE line_cd = p_dsp_line_cd
						   AND trty_yy = v1_trty_yy
						   AND trty_seq_no = v1_share_cd)
				LOOP
				  INSERT INTO gicl_recovery_rids(recovery_id, recovery_payt_id,         
												 rec_dist_no, line_cd,        
												 grp_seq_no,  dist_year,
												 share_type,  acct_trty_type,
												 ri_cd,       share_ri_pct,
												 shr_ri_recovery_amt,
												 share_ri_pct_real)
										 VALUES (p_recovery_id,     p_recovery_payt_id,
												 v_rec_dist_no,     p_dsp_line_cd,        
												 v1_share_cd,       TO_CHAR(SYSDATE,'YYYY'),          
												 v_trty_share_type, v1_acct_trty_type,
												 trty.ri_cd,          
												 (ann_dist_spct  * (trty.trty_shr_pct/100)),
												 (v_recovered_amt  * (trty.trty_shr_pct/100)),
												 trty.trty_shr_pct);
				END LOOP; 
			 ELSIF itm.share_type = v_facul_share_type THEN
				FOR facul IN 
				  (SELECT f.ri_cd,
						  SUM(NVL((f.ri_shr_pct/100) * b.tsi_amt,0)) sum_ri_tsi_amt 
					 FROM gipi_polbasic a, gipi_itmperil b, giuw_pol_dist c,
						  giuw_itemperilds d, giri_distfrps e, giri_frps_ri f       
					WHERE a.line_cd              = p_dsp_line_cd
					  AND a.subline_cd           = p_dsp_subline_cd
					  AND a.iss_cd               = p_dsp_iss_cd
					  AND a.issue_yy             = p_dsp_issue_yy
					  AND a.pol_seq_no           = p_dsp_pol_seq_no
					  AND a.renew_no             = p_dsp_renew_no
					  AND a.pol_flag IN ('1','2','3','X')   
					  AND a.policy_id            = b.policy_id
					  AND b.item_no IN (SELECT item_no
										  FROM gicl_clm_recovery_dtl
										 WHERE claim_id = rec.claim_id
										   AND recovery_id = rec.recovery_id)    
					  AND b.peril_cd IN (SELECT peril_cd 
										   FROM gicl_clm_recovery_dtl
										  WHERE claim_id = rec.claim_id
											AND recovery_id = rec.recovery_id)    
					  AND a.policy_id = c.policy_id   
					  AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
								DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),p_eff_date, a.eff_date),c.eff_date)) <= p_loss_date 
					  AND TRUNC(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),
								DECODE(NVL(a.endt_expiry_date,a.expiry_date),a.expiry_date, p_expiry_date,a.endt_expiry_date),c.expiry_date)) >= p_loss_date       
					  AND c.dist_flag            = '3'
					  AND c.dist_no              = d.dist_no
					  AND b.item_no              = d.item_no
					  AND b.peril_cd             = d.peril_cd
					  AND c.dist_no              = e.dist_no
					  AND d.dist_seq_no          = e.dist_seq_no
					  AND e.line_cd              = f.line_cd
					  AND e.frps_yy              = f.frps_yy
					  AND e.frps_seq_no          = f.frps_seq_no
					  AND NVL(f.reverse_sw, 'N') = 'N'
					  AND NVL(f.delete_sw, 'N')  = 'N'
					  AND e.ri_flag              = '2'   
					GROUP BY f.ri_cd)
				LOOP 
				  IF (itm.acct_trty_type <> v_acct_trty_type) or (itm.acct_trty_type is null) then 
					 ann_ri_pct := (facul.sum_ri_tsi_amt / sum_tsi_amt) * 100;
				  ELSE
					 ann_ri_pct := (v_facul_amt /sum_tsi_amt) * 100;
				  END IF; 
				  INSERT INTO gicl_recovery_rids(recovery_id, recovery_payt_id,         
												 rec_dist_no, line_cd,        
												 grp_seq_no,  dist_year,
												 share_type,  acct_trty_type,
												 ri_cd,       share_ri_pct,
												 shr_ri_recovery_amt,
												 share_ri_pct_real)
										 VALUES (p_recovery_id,      p_recovery_payt_id,
												 v_rec_dist_no,      p_dsp_line_cd,        
												 v1_share_cd,        TO_CHAR(SYSDATE,'YYYY'),          
												 v_facul_share_type, v1_acct_trty_type,
												 facul.ri_cd,        ann_ri_pct,
												 (rec.recovered_amt * ann_ri_pct/100),
												 ann_ri_pct/ann_dist_spct);
				END LOOP;   
			 END IF;
		   ELSE 
			  NULL;
		   END IF;
		END LOOP; 
	  END LOOP; 
	
	  UPDATE gicl_recovery_payt
		 SET dist_sw = 'Y'
	   WHERE recovery_id = p_recovery_id
		 AND recovery_payt_id = p_recovery_payt_id;  
	END;

	/*
	**  Created by   :  Belle Bebing
	**  Date Created :  05.02.2012 
	**  Reference By : (GICLS054 - Recovery Distribution)  
	**  Description  :  Negate Distribution Recovery
	*/ 
	PROCEDURE negate_dist_recovery (
		p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_payt.recovery_payt_id%TYPE
	)
	IS
	BEGIN
		UPDATE gicl_recovery_payt
             SET dist_sw = 'N'
           WHERE recovery_id = p_recovery_id 
             AND recovery_payt_id = p_recovery_payt_id;
   
          UPDATE gicl_recovery_ds
             SET negate_tag = 'Y',
                 negate_date = SYSDATE
           WHERE recovery_id = p_recovery_id  
             AND recovery_payt_id = p_recovery_payt_id; 
 
          UPDATE gicl_recovery_rids
             SET negate_tag = 'Y',
                 negate_date = SYSDATE
           WHERE recovery_id = p_recovery_id  
             AND recovery_payt_id = p_recovery_payt_id; 
	END;
    
    /*
	**  Created by   :  Belle Bebing
	**  Date Created :  05.06.2012
	**  Reference By : (GICLS054 - Recovery Distribution)  
	**  Description  :  Save Changes (share rate and share recovery amount) Distribution Recovery
	*/ 
	PROCEDURE upd_dist_recovery (
		p_recovery_id           gicl_recovery_ds.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_ds.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_ds.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_ds.grp_seq_no%TYPE,
        p_share_pct             gicl_recovery_ds.share_pct%TYPE,
		p_shr_recovery_amt      gicl_recovery_ds.shr_recovery_amt%TYPE
	)
	IS
	BEGIN
          UPDATE gicl_recovery_ds
             SET share_pct = p_share_pct,
                 shr_recovery_amt = p_shr_recovery_amt
           WHERE recovery_id = p_recovery_id  
             AND recovery_payt_id = p_recovery_payt_id
             AND rec_dist_no = p_rec_dist_no
             AND grp_seq_no = p_grp_seq_no
             AND NVL(negate_tag, 'N') = 'N';
	END;
    
    /*
	**  Created by   :  Belle Bebing
	**  Date Created :  05.08.2012
	**  Reference By : (GICLS054 - Recovery Distribution)  
	**  Description  :  Delete share dist recovery.
	*/ 
	PROCEDURE del_dist_recovery (
		p_recovery_id           gicl_recovery_ds.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_ds.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_ds.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_ds.grp_seq_no%TYPE
    )
	IS
	BEGIN
          DELETE FROM gicl_recovery_ds
           WHERE recovery_id = p_recovery_id  
             AND recovery_payt_id = p_recovery_payt_id
             AND rec_dist_no = p_rec_dist_no
             AND grp_seq_no = p_grp_seq_no
             AND NVL(negate_tag, 'N') = 'N'; 
	END;
		  
END GICL_RECOVERY_DS_PKG;
/


