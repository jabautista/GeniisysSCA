CREATE OR REPLACE PACKAGE BODY CPI.GICL_RECOVERY_RIDS_PKG AS

    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  01-04-2011 
    **  Reference By : (GICLS055 - Generate Acct. Entries - Loss Recovery)  
    **  Description  :  get recovery rids record
    */ 
    FUNCTION get_recovery_rids (  
        p_recovery_id             GICL_RECOVERY_RIDS.recovery_id%TYPE,
        p_recovery_payt_id        GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        p_rec_dist_no             GICL_RECOVERY_RIDS.rec_dist_no%TYPE, --added by  
        p_grp_seq_no              GICL_RECOVERY_RIDS.grp_seq_no%TYPE   --Halley 01.14.15
    ) RETURN gicl_recovery_rids_tab PIPELINED IS
        v_rec_rids                gicl_recovery_rids_type;
    BEGIN
        FOR i IN (
            SELECT * FROM gicl_recovery_rids 
             WHERE recovery_id = p_recovery_id
               AND recovery_payt_id = p_recovery_payt_id
               AND rec_dist_no = p_rec_dist_no  --added by
               AND grp_seq_no = p_grp_seq_no    --Halley
               AND NVL(negate_tag,'N') = 'N'    --01.14.15
        ) LOOP
            v_rec_rids.recovery_id                 := i.recovery_id;
            v_rec_rids.recovery_payt_id            := i.recovery_payt_id;
            v_rec_rids.rec_dist_no                 := i.rec_dist_no;
            v_rec_rids.line_cd                     := i.line_cd;
            v_rec_rids.grp_seq_no                  := i.grp_seq_no;
            v_rec_rids.dist_year                   := i.dist_year;
            v_rec_rids.share_type                  := i.share_type;
            v_rec_rids.acct_trty_type              := i.acct_trty_type;
            v_rec_rids.ri_cd                       := i.ri_cd;
            v_rec_rids.share_ri_pct                := i.share_ri_pct;
            v_rec_rids.shr_ri_recovery_amt         := i.shr_ri_recovery_amt;
            v_rec_rids.share_ri_pct_real           := i.share_ri_pct_real;
            v_rec_rids.negate_tag                  := i.negate_tag;
            v_rec_rids.negate_date                 := i.negate_date;
            FOR r iN (SELECT ri_name
                          FROM giis_reinsurer
                         WHERE ri_cd = i.ri_cd)
            LOOP
                v_rec_rids.dsp_ri_name := r.ri_name;
            END LOOP;
            
        PIPE ROW(v_rec_rids);
        END LOOP;
    END get_recovery_rids;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03-30-2012 
    **  Reference By : (GICLS025 - Recovery Information)  
    **  Description  :  get recovery rids record
    **  Modified by  : Halley Pates - renamed function from get_gicl_recovery_rids to get_recovery_rids
    */ 
    FUNCTION get_gicl_recovery_rids (
        p_recovery_id               GICL_RECOVERY_RIDS.recovery_id%TYPE,
        p_recovery_payt_id          GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        p_rec_dist_no               GICL_RECOVERY_RIDS.rec_dist_no%TYPE,
        p_grp_seq_no                GICL_RECOVERY_RIDS.grp_seq_no%TYPE           
        ) 
    RETURN gicl_recovery_rids_tab PIPELINED IS
      v_rec_rids        gicl_recovery_rids_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM gicl_recovery_rids 
                   WHERE recovery_id = p_recovery_id
                     AND recovery_payt_id = p_recovery_payt_id
                     AND rec_dist_no = p_rec_dist_no
                     AND grp_seq_no = p_grp_seq_no) 
        LOOP
            v_rec_rids.recovery_id                 := i.recovery_id;
            v_rec_rids.recovery_payt_id            := i.recovery_payt_id;
            v_rec_rids.rec_dist_no                 := i.rec_dist_no;
            v_rec_rids.line_cd                     := i.line_cd;
            v_rec_rids.grp_seq_no                  := i.grp_seq_no;
            v_rec_rids.dist_year                   := i.dist_year;
            v_rec_rids.share_type                  := i.share_type;
            v_rec_rids.acct_trty_type              := i.acct_trty_type;
            v_rec_rids.ri_cd                       := i.ri_cd;
            v_rec_rids.share_ri_pct                := i.share_ri_pct;
            v_rec_rids.shr_ri_recovery_amt         := i.shr_ri_recovery_amt;
            v_rec_rids.share_ri_pct_real           := i.share_ri_pct_real;
            v_rec_rids.negate_tag                  := i.negate_tag;
            v_rec_rids.negate_date                 := i.negate_date;
            v_rec_rids.dsp_ri_name                 := NULL;
              
            FOR r iN (SELECT ri_name
                          FROM giis_reinsurer
                         WHERE ri_cd = i.ri_cd)
            LOOP
                v_rec_rids.dsp_ri_name := r.ri_name;
            END LOOP;
            
        PIPE ROW(v_rec_rids);
        END LOOP;
    END;
    
    /*
    **  Created by   :  Marco Paolo Rebong
    **  Date Created :  04-11-2012 
    **  Reference By : (GICLS033 - Generate FLA)  
    **  Description  :  retrieves recovery amt per ri for claim
    */ 
    FUNCTION get_fla_recovery(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_adv_fla_id            GICL_ADVS_FLA.adv_fla_id%TYPE
    )
    RETURN recovery_tab PIPELINED AS
        v_recovery              recovery_type;
    BEGIN
        FOR i IN (SELECT ri_cd
  				    FROM GICL_ADVS_FLA
 				   WHERE CLAIM_ID = p_claim_id
   					 AND adv_fla_id = p_adv_fla_id)
        LOOP
   	        FOR x IN (SELECT e.cancel_tag, d.recovery_id, e.recovered_amt
  					    FROM GICL_CLM_RECOVERY e, 
       					     GICL_CLM_RECOVERY_DTL d 
 					   WHERE e.cancel_tag IS NULL
   						 AND e.claim_id = d.claim_id
   						 AND e.recovery_id = d.recovery_id
   						 AND e.claim_id = p_claim_id)
            LOOP
   		        --CHECKS IF RECOVERY IS DISTRIBUTED, HAS RI AND IS NOT NEGATED
    	        FOR rcvry_w_dist IN (SELECT recovery_id, recovery_payt_id, rec_dist_no, grp_seq_no, shr_recovery_amt
  	  			   	  	   		 	   FROM GICL_RECOVERY_DS
						  			  WHERE recovery_id = x.recovery_id
						    			AND share_type <> 1
						    			AND NVL(negate_tag, 'N') <> 'Y') 
			    LOOP
      	            --FETCHES RI_CD AND SHR_RI_RECOVERY_AMT
      	            FOR ri_shr_amt IN (SELECT ri_cd, shr_ri_recovery_amt, grp_seq_no, share_type
				   	  	   				 FROM GICL_RECOVERY_RIDS
						   				WHERE recovery_id = rcvry_w_dist.recovery_id
						    			  AND recovery_payt_id = rcvry_w_dist.recovery_payt_id
						    			  AND rec_dist_no = rcvry_w_dist.rec_dist_no
						    			  AND grp_seq_no = rcvry_w_dist.grp_seq_no
						    			  AND ri_cd = i.ri_cd) 
				    LOOP
                        v_recovery.ri_cd := ri_shr_amt.ri_cd;
                        v_recovery.shr_ri_recovery_amt := ri_shr_amt.shr_ri_recovery_amt;
                        v_recovery.shr_recovery_amt := rcvry_w_dist.shr_recovery_amt;
                        v_recovery.recovered_amt := x.recovered_amt;
                        v_recovery.grp_seq_no := ri_shr_amt.grp_seq_no;
                        v_recovery.share_type := ri_shr_amt.share_type;
                        PIPE ROW(v_recovery);
				    END LOOP;
                END LOOP;
   	        END LOOP;
        END LOOP;
    END;
	
	/*
	**  Created by   :  Belle Bebing
	**  Date Created :  04.20.2012
	**  Reference By : GICLS054 - Recovery Distribution
	**  Description :  get recovery RI distribution
	*/	
	FUNCTION get_recovery_ri_dist (
		p_recovery_id		gicl_recovery_rids.recovery_id%TYPE,
		p_recovery_payt_id	gicl_recovery_rids.recovery_payt_id%TYPE,
		p_rec_dist_no		gicl_recovery_rids.rec_dist_no%TYPE,
		p_grp_seq_no		gicl_recovery_rids.grp_seq_no%TYPE
	)
	  RETURN gicl_recovery_ri_dist_tab PIPELINED IS
  		rec gicl_recovery_ri_dist_type;

	BEGIN
		FOR i IN ( SELECT *
				     FROM GICL_RECOVERY_RIDS
				    WHERE NVL(negate_tag,'N') = 'N'
				      AND recovery_id = p_recovery_id 
					  AND recovery_payt_id = p_recovery_payt_id 
					  AND rec_dist_no = p_rec_dist_no 
					  AND grp_seq_no = p_grp_seq_no
				 ORDER BY ri_cd)
		LOOP
			rec.recovery_id			:= i.recovery_id;
			rec.recovery_payt_id	:= i.recovery_payt_id;
			rec.rec_dist_no			:= i.rec_dist_no;
			rec.dsp_line_cd			:= i.line_cd;
			rec.dist_year			:= i.dist_year;
			rec.grp_seq_no			:= i.grp_seq_no;
			rec.share_type			:= i.share_type;
			rec.acct_trty_type		:= i.acct_trty_type;
			rec.ri_cd				:= i.ri_cd;
			rec.share_ri_pct		:= i.share_ri_pct;
			rec.share_ri_pct_real	:= i.share_ri_pct_real;
			rec.shr_ri_recovery_amt := i.shr_ri_recovery_amt;
			rec.negate_tag			:= i.negate_tag;
			rec.negate_date			:= i.negate_date;
			
			  FOR r iN (SELECT ri_name
						  FROM giis_reinsurer
						 WHERE ri_cd = i.ri_cd)
			  LOOP
			  		rec.dsp_ri_name := r.ri_name;
			  END LOOP;
		   PIPE ROW(rec);
		END LOOP;
	END;
    
    
    /*
	**  Created by   :  Belle Bebing
	**  Date Created :  05.06.2012
	**  Reference By : (GICLS054 - Recovery Distribution)  
	**  Description  :  Save Changes (share ri rate and share ri recovery amount) Distribution Recovery
	*/ 
	PROCEDURE upd_ridist_recovery (
		p_recovery_id           gicl_recovery_rids.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_rids.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_rids.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_rids.grp_seq_no%TYPE,
        p_ri_cd                 gicl_recovery_rids.ri_cd%TYPE,
        p_share_ri_pct             gicl_recovery_rids.share_ri_pct%TYPE,
		p_shr_ri_recovery_amt      gicl_recovery_rids.shr_ri_recovery_amt%TYPE
	)
	IS
	BEGIN
          UPDATE gicl_recovery_rids
             SET share_ri_pct = p_share_ri_pct,
                 shr_ri_recovery_amt = p_shr_ri_recovery_amt
           WHERE recovery_id = p_recovery_id  
             AND recovery_payt_id = p_recovery_payt_id
             AND rec_dist_no = p_rec_dist_no
             AND grp_seq_no = p_grp_seq_no
             AND ri_cd = p_ri_cd
             AND NVL(negate_tag, 'N') = 'N'; 
	END;
    
    /*
	**  Created by   :  Belle Bebing
	**  Date Created :  05.082012
	**  Reference By : (GICLS054 - Recovery Distribution)  
	**  Description  :  Delete RI share dist recovery.
	*/ 
	PROCEDURE del_ridist_recovery (
		p_recovery_id           gicl_recovery_rids.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_rids.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_rids.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_rids.grp_seq_no%TYPE
    )
	IS
	BEGIN
          DELETE FROM gicl_recovery_rids
           WHERE recovery_id = p_recovery_id  
             AND recovery_payt_id = p_recovery_payt_id
             AND rec_dist_no = p_rec_dist_no
             AND grp_seq_no = p_grp_seq_no
             AND NVL(negate_tag, 'N') = 'N'; 
	END;
    
END GICL_RECOVERY_RIDS_PKG;
/


