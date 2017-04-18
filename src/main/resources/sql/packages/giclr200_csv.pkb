CREATE OR REPLACE PACKAGE BODY CPI.GICLR200_CSV AS

  FUNCTION CSV_GICLR200(p_session_id    VARCHAR2) RETURN giclr200_type PIPELINED
  IS
    v_giclr200     giclr200_rec_type;
	v_catastrophic VARCHAR2(100);
	v_loss_ctgry   giis_loss_ctgry.loss_cat_des%type;
	v_total_os	   gicl_os_pd_clm_extr.os_loss%type;
	v_total_pd	   gicl_os_pd_clm_extr.pd_loss%type;
	v_clm_status   giis_clm_stat.clm_stat_desc%type;
  BEGIN
    FOR rec IN (SELECT a.CATASTROPHIC_CD,
	                   a.ISS_CD,
					   a.LINE_CD,
					   a.CLM_CNT,
					   a.CLAIM_NO,
					   a.ASSURED_NAME,
					   a.LOSS_LOC,
					   a.POLICY_NO,
					   a.TSI_AMT,
					   a.LOSS_CAT_CD,
					   a.LOSS_DATE,
					   NVL(a.OS_LOSS, 0) os_loss,
					   NVL(a.OS_EXP, 0) os_exp,
                       NVL(a.GROSS_LOSS, 0) gross_loss,
					   NVL(a.PD_LOSS, 0) pd_loss,
					   NVL(a.PD_EXP, 0) pd_exp,
					   a.CLM_STAT_CD
				  FROM gicl_os_pd_clm_extr a
			  ORDER BY a.CATASTROPHIC_CD,
			           a.ISS_CD,
					   a.LINE_CD,
					   a.CLM_CNT,
					   a.CLAIM_NO)
	LOOP
	  FOR i IN (SELECT x.CATASTROPHIC_DESC, x.START_DATE, x.END_DATE
	              FROM gicl_cat_dtl x
				 WHERE x.CATASTROPHIC_CD = rec.CATASTROPHIC_CD)
	  LOOP
	    v_catastrophic := i.catastrophic_desc;
        IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
           v_catastrophic := v_catastrophic||'('||to_char(i.start_date, 'FmMonth DD, YYYY')||' - '||to_char(i.start_date, 'FmMonth DD, YYYY')||')';
        END IF;
	  END LOOP;

	  FOR i IN (SELECT x.LOSS_CAT_DES
	              FROM giis_loss_ctgry x
				 WHERE x.LOSS_CAT_CD = rec.LOSS_CAT_CD)
	  LOOP
	    v_loss_ctgry := i.loss_cat_des;
	  END LOOP;

	  FOR i IN (SELECT x.CLM_STAT_DESC
	              FROM giis_clm_stat x
				 WHERE x.CLM_STAT_CD = rec.CLM_STAT_CD)
	  LOOP
	    v_clm_status := i.clm_stat_desc;
	  END LOOP;

	  v_total_os := rec.os_loss + rec.os_exp;
	  v_total_pd := rec.pd_loss + rec.pd_exp;

	  v_giclr200.catastrophic_cd := v_catastrophic;
	  v_giclr200.clm_cnt         := rec.clm_cnt;
	  v_giclr200.claim_no        := rec.claim_no;
	  v_giclr200.assured		 := rec.assured_name;
	  v_giclr200.loss_loc		 := rec.loss_loc;
	  v_giclr200.policy_no		 := rec.policy_no;
	  v_giclr200.tsi_amt		 := rec.tsi_amt;
	  v_giclr200.loss_ctgry		 := v_loss_ctgry;
	  v_giclr200.loss_date       := rec.loss_date;
	  v_giclr200.os_loss		 := rec.os_loss;
	  v_giclr200.os_exp			 := rec.os_exp;
	  v_giclr200.total_os		 := v_total_os;
      v_giclr200.gross_loss      := rec.gross_loss;
	  v_giclr200.pd_loss		 := rec.pd_loss;
	  v_giclr200.pd_exp 		 := rec.pd_exp;
	  v_giclr200.total_pd		 := v_total_pd;
	  v_giclr200.clm_status 	 := v_clm_status;
	  PIPE ROW(v_giclr200);
	END LOOP;
	RETURN;
  END;

  FUNCTION CSV_GICLR200A(p_session_id   VARCHAR2) RETURN giclr200a_type PIPELINED
  IS
    v_giclr200a         giclr200a_rec_type;
    v_catastrophic      VARCHAR2(100);
    v_treaty_name       giis_dist_share.trty_name%type;
    v_total             gicl_os_pd_clm_ds_extr.os_exp%type;
  BEGIN
    FOR rec IN (SELECT b.catastrophic_cd, a.grp_seq_no, a.share_type, null line_cd,
                       SUM (NVL (a.os_loss, 0) + NVL (a.os_exp, 0)) os,
                       SUM (NVL (a.pd_loss, 0) + NVL (a.pd_exp, 0)) pd
                  FROM gicl_os_pd_clm_ds_extr a, gicl_os_pd_clm_extr b
                 WHERE b.session_id = P_SESSION_ID
                   AND a.session_id = b.session_id
                   AND a.os_pd_rec_id = b.os_pd_rec_id
                   AND a.claim_id = b.claim_id
                   AND a.share_type in (1, 3)
              GROUP BY a.grp_seq_no, b.catastrophic_cd, a.share_type
              UNION
                SELECT b.catastrophic_cd, a.grp_seq_no, a.share_type, b.line_cd,
                       SUM (NVL (a.os_loss, 0) + NVL (a.os_exp, 0)) os,
                       SUM (NVL (a.pd_loss, 0) + NVL (a.pd_exp, 0)) pd
                  FROM gicl_os_pd_clm_ds_extr a, gicl_os_pd_clm_extr b
                 WHERE b.session_id = P_SESSION_ID
                   AND a.session_id = b.session_id
                   AND a.os_pd_rec_id = b.os_pd_rec_id
                   AND a.claim_id = b.claim_id
                   AND a.share_type not in (1, 3)
              GROUP BY a.grp_seq_no, b.catastrophic_cd, a.share_type, b.line_cd
              ORDER BY catastrophic_cd, share_type, grp_seq_no, line_cd)
    LOOP
      FOR i IN (SELECT x.CATASTROPHIC_DESC, x.START_DATE, x.END_DATE
	              FROM gicl_cat_dtl x
				 WHERE x.CATASTROPHIC_CD = rec.CATASTROPHIC_CD)
	  LOOP
	    v_catastrophic := i.catastrophic_desc;
        IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
           v_catastrophic := v_catastrophic||'('||to_char(i.start_date, 'FmMonth DD, YYYY')||' - '||to_char(i.start_date, 'FmMonth DD, YYYY')||')';
        END IF;
	  END LOOP;

      FOR i IN (SELECT X.TRTY_NAME
                  FROM giis_dist_share x
                 WHERE X.SHARE_CD = rec.grp_seq_no
                   AND X.SHARE_TYPE IN (1, 3))
      LOOP
        v_treaty_name := i.trty_name;
      END LOOP;

      FOR i IN (SELECT X.TRTY_NAME
                  FROM giis_dist_share x
                 WHERE X.SHARE_CD = rec.grp_seq_no
                   AND X.SHARE_TYPE NOT IN (1, 3)
                   AND X.LINE_CD = rec.line_cd)
      LOOP
        v_treaty_name := i.trty_name;
      END LOOP;

      v_total := rec.os + rec.pd;

      v_giclr200a.catastrophic_cd := v_catastrophic;
      v_giclr200a.treaty_name     := v_treaty_name;
      v_giclr200a.paid            := rec.pd;
      v_giclr200a.outstanding     := rec.os;
      v_giclr200a.total           := v_total;
      PIPE ROW(v_giclr200a);
    END LOOP;
    RETURN;
  END;

  FUNCTION CSV_GICLR200B(p_session_id   VARCHAR2, p_ri_cd VARCHAR2) RETURN giclr200b_type PIPELINED
  IS
    v_giclr200b         giclr200b_rec_type;
    v_catastrophic      VARCHAR2(100);
    v_treaty_name       giis_dist_share.trty_name%type;
    v_total             gicl_os_pd_clm_ds_extr.os_exp%type;
  BEGIN
    FOR rec IN (SELECT a.catastrophic_cd, a.line_cd,
                       b.share_type, b.grp_seq_no,
                       c.ri_cd,c.shr_ri_pct,
                       SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                       SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds,
                       SUM (NVL (c.os_loss, 0) + NVL (c.os_exp, 0)) os_rids,
                       SUM (NVL (c.pd_loss, 0) + NVL (c.pd_exp, 0)) pd_rids
                  FROM gicl_os_pd_clm_extr a,
                       gicl_os_pd_clm_ds_extr b,
                       gicl_os_pd_clm_rids_extr c
                 WHERE a.session_id = b.session_id
                   AND a.claim_id = b.claim_id
                   AND a.os_pd_rec_id = b.os_pd_rec_id
                   AND b.session_id = c.session_id
                   AND b.claim_id = c.claim_id
                   AND b.os_pd_rec_id = c.os_pd_rec_id
                   AND b.os_pd_ds_rec_id = c.os_pd_ds_rec_id
                   AND b.grp_seq_no = c.grp_seq_no
                   AND b.share_type = 4
                   AND c.ri_cd = NVL (p_ri_cd, c.ri_cd)
                   AND a.session_id = p_session_id
              GROUP BY a.catastrophic_cd,
                       a.line_cd,
                       b.share_type,
                       b.grp_seq_no,
                       c.ri_cd,
                       c.shr_ri_pct
              UNION
                SELECT a.catastrophic_cd, DECODE(b.grp_seq_no, 1, NULL, 999, NULL, a.line_cd) line_cd,
                       b.share_type, b.grp_seq_no,
                       NULL ri_cd, NULL shr_ri_pct,
                       SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                       SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds,
                       NULL os_rids,
                       NULL pd_rids
                  FROM gicl_os_pd_clm_extr a,
                       gicl_os_pd_clm_ds_extr b
                 WHERE a.session_id = b.session_id
                   AND a.claim_id = b.claim_id
                   AND a.os_pd_rec_id = b.os_pd_rec_id
                   AND b.share_type <> 4
                   AND a.session_id = p_session_id
              GROUP BY a.catastrophic_cd,
                       DECODE(b.grp_seq_no, 1, NULL, 999, NULL, a.line_cd),
                       b.share_type,
                       b.grp_seq_no
              ORDER BY catastrophic_cd,
                       line_cd,
                       share_type,
                       grp_seq_no)
    LOOP
      FOR i IN (SELECT x.CATASTROPHIC_DESC, x.START_DATE, x.END_DATE
	              FROM gicl_cat_dtl x
				 WHERE x.CATASTROPHIC_CD = rec.CATASTROPHIC_CD)
	  LOOP
	    v_catastrophic := i.catastrophic_desc;
        IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
           v_catastrophic := v_catastrophic||'('||to_char(i.start_date, 'FmMonth DD, YYYY')||' - '||to_char(i.start_date, 'FmMonth DD, YYYY')||')';
        END IF;
	  END LOOP;

      FOR i IN (SELECT X.TRTY_NAME
                  FROM giis_dist_share x
                 WHERE X.SHARE_CD = rec.grp_seq_no
                   AND X.SHARE_TYPE IN (1, 3))
      LOOP
        v_treaty_name := i.trty_name;
      END LOOP;

      FOR i IN (SELECT X.TRTY_NAME
                  FROM giis_dist_share x
                 WHERE X.SHARE_CD = rec.grp_seq_no
                   AND X.SHARE_TYPE NOT IN (1, 3)
                   AND X.LINE_CD = rec.line_cd)
      LOOP
        v_treaty_name := i.trty_name;
      END LOOP;

      v_total := rec.os_ds + rec.pd_ds;

      v_giclr200b.catastrophic_cd := v_catastrophic;
      v_giclr200b.treaty_name     := v_treaty_name;
      v_giclr200b.paid            := rec.pd_ds;
      v_giclr200b.outstanding     := rec.os_ds;
      v_giclr200b.total           := v_total;
      v_giclr200b.ri_cd           := rec.ri_cd;
      v_giclr200b.os              := rec.os_rids;
      v_giclr200b.pd              := rec.pd_rids;
      PIPE ROW(v_giclr200b);
    END LOOP;
    RETURN;
  END;
END;
/


