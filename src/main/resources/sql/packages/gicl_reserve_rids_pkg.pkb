CREATE OR REPLACE PACKAGE BODY CPI.GICL_RESERVE_RIDS_PKG
AS
    /*
    **  Created by   :  Roy Encela
    **  Date Created :  April 10, 2012 
    **  Reference By :  GICLS024 - Claim Reserve 
    **  Description :   get Rreserve rids 
	**  modified by irwin, added more parameters. 6.25.2012
    */
    FUNCTION get_res_rids (
       p_claim_id   gicl_reserve_rids.claim_id%TYPE,
       p_line_cd    gicl_reserve_rids.line_cd%TYPE,
       p_item_no    gicl_reserve_rids.item_no%TYPE,
       p_hist_seq_no gicl_reserve_rids.hist_seq_no%TYPE,
	   p_clm_dist_no           gicl_reserve_ds.clm_dist_no%TYPE,
	   p_grp_seq_no           gicl_reserve_ds.grp_seq_no%TYPE,
	   p_clm_res_hist_id           gicl_reserve_ds.clm_res_hist_id %TYPE
    ) RETURN gicl_res_rids_tab PIPELINED IS
        v gicl_res_rids_type;
    BEGIN 
        FOR i IN (
            SELECT  ri_cd, shr_ri_pct, shr_loss_ri_res_amt, shr_exp_ri_res_amt,
                        claim_id, peril_cd, line_cd, item_no
              FROM gicl_reserve_rids 
			  WHERE clm_dist_no = p_clm_dist_no
             AND claim_id = p_claim_id
             AND grp_seq_no = p_grp_seq_no
             AND clm_res_hist_id = p_clm_res_hist_id
            /* WHERE line_cd = p_line_cd
             AND claim_id = p_claim_id
             AND item_no = p_item_no
             AND hist_seq_no = p_hist_seq_no*/
        )LOOP
            v.ri_cd := i.ri_cd;
            v.shr_ri_pct := i.shr_ri_pct;
            v.shr_loss_ri_res_amt := i.shr_loss_ri_res_amt;
            v.shr_exp_ri_res_amt := i.shr_exp_ri_res_amt;
            v.claim_id := p_claim_id;
            v.item_no := p_item_no;
            v.hist_seq_no := p_hist_seq_no;
            
            BEGIN
              SELECT ri_sname
                INTO v.ri_name
                FROM giis_reinsurer
               WHERE ri_cd = i.ri_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            PIPE ROW(v);
        END LOOP;
        RETURN;
    END;
    
    PROCEDURE save_reserve_rids(
        p_claim_id  IN gicl_reserve_rids.claim_id%TYPE,
        p_clm_res_hist_id  IN gicl_reserve_rids.clm_res_hist_id%TYPE,
        p_clm_dist_no  IN gicl_reserve_rids.clm_dist_no%TYPE,
        p_grp_seq_no  IN gicl_reserve_rids.grp_seq_no%TYPE,
        p_ri_cd  IN gicl_reserve_rids.ri_cd%TYPE,
        p_line_cd  IN gicl_reserve_rids.line_cd%TYPE,
        p_dist_year  IN gicl_reserve_rids.dist_year%TYPE,
        p_item_no  IN gicl_reserve_rids.item_no%TYPE,
        p_peril_cd  IN gicl_reserve_rids.peril_cd%TYPE,
        p_hist_seq_no  IN gicl_reserve_rids.hist_seq_no%TYPE,
        p_user_id  IN gicl_reserve_rids.user_id%TYPE,
        p_acct_trty_type  IN gicl_reserve_rids.acct_trty_type%TYPE,
        p_prnt_ri_cd  IN gicl_reserve_rids.prnt_ri_cd%TYPE,
        p_shr_ri_pct  IN gicl_reserve_rids.shr_ri_pct%TYPE,
        p_shr_loss_ri_res_amt  IN gicl_reserve_rids.shr_loss_ri_res_amt%TYPE,
        p_shr_exp_ri_res_amt  IN gicl_reserve_rids.shr_exp_ri_res_amt%TYPE,
        p_share_type  IN gicl_reserve_rids.share_type%TYPE,
        --p_cpi_rec_no  IN gicl_reserve_rids.cpi_rec_no%TYPE,
        --p_cpi_branch_cd  IN gicl_reserve_rids.cpi_branch_cd%TYPE,
        p_pla_id  IN gicl_reserve_rids.pla_id%TYPE,
        p_shr_ri_pct_real  IN gicl_reserve_rids.shr_ri_pct_real%TYPE,
        p_res_pla_id  IN gicl_reserve_rids.res_pla_id%TYPE,
        p_grouped_item_no  IN gicl_reserve_rids.grouped_item_no%TYPE
    )AS
    BEGIN
        INSERT INTO gicl_reserve_rids(claim_id, clm_res_hist_id, clm_dist_no,
            grp_seq_no, ri_cd, line_cd, dist_year, item_no, peril_cd,
            hist_seq_no, user_id, acct_trty_type, prnt_ri_cd,
            shr_ri_pct, shr_loss_ri_res_amt, shr_exp_ri_res_amt, share_type,
            /*cpi_rec_no, cpi_branch_cd, */pla_id, shr_ri_pct_real, res_pla_id, grouped_item_no, last_update)
        VALUES(p_claim_id, p_clm_res_hist_id, p_clm_dist_no, p_grp_seq_no, p_ri_cd, p_line_cd,
            p_dist_year, p_item_no, p_peril_cd, p_hist_seq_no, p_user_id, p_acct_trty_type,
            p_prnt_ri_cd, p_shr_ri_pct, p_shr_loss_ri_res_amt, p_shr_exp_ri_res_amt, p_share_type,
            /*p_cpi_rec_no, p_cpi_branch_cd, */p_pla_id, p_shr_ri_pct_real, p_res_pla_id, p_grouped_item_no, SYSDATE);
    END save_reserve_rids;
END GICL_RESERVE_RIDS_PKG;
/


