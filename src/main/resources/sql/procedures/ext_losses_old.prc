DROP PROCEDURE CPI.EXT_LOSSES_OLD;

CREATE OR REPLACE PROCEDURE CPI.ext_losses_old IS

BEGIN

DELETE eim_os_loss
 WHERE user_id = USER;

FOR os IN(
SELECT NVL(f.res_amt,0) res_amt,
       	 NVL(g.paid_amt,0) set_amt,
       	 NVL(b.ann_tsi_amt,0) tsi_loss,
       	 DECODE(SIGN(DECODE(a.clm_stat_cd, 'WD', 0, 'CC', 0,'DN', 0, 'CD', 0,
		     (SUM(NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + SUM(NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))))), -1, 0,
		 	  DECODE(a.clm_stat_cd, 'WD', 0, 'CC', 0,'DN', 0, 'CD', 0,
		     (SUM(NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + SUM(NVL(f.reserve_losses,0) - NVL(g.losses_paid,0)))))  os_loss,
	   	 DECODE(a.clm_stat_cd, 'WD', (SUM(NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + SUM(NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))),
	                         'CC', (SUM(NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + SUM(NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))),
		  					 'DN', (SUM(NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + SUM(NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))), 0) can_loss,
	     DECODE(a.clm_stat_cd, 'CC', 'CANCELLED', 'DN', 'CANCELLED', 'WD', 'CANCELLED', 'CD', 'CLOSED', 'IN PROGRESS') clm_stat,
	   	 TRUNC(a.clm_file_date) rep_date,
		 g.date_paid,
	  	 a.line_cd,
	   	 a.subline_cd,
	   	 a.iss_cd,
	   	 c.intm_no,
		 i.intm_type,
	   	 h.assd_no,
		 RTRIM(Get_Line_Name(a.line_cd)) line_name,
		 RTRIM(Get_Subline_Name(a.subline_cd)) subline_name,
		 RTRIM(Get_Iss_Name(a.iss_cd)) branch_name,
		 RTRIM(Get_Intm_Name(c.intm_no)) intm_name,
		 Get_Intm_Type_Desc(intm_type) intm_type_desc,
		 RTRIM(Get_Assd_Name(h.assd_no)) assd_name,
		 b.claim_id,
		 b.item_no,
		 p.peril_name
    FROM gicl_claims a,
       	 gicl_item_peril b,
		 giis_peril p,
       	 gicl_intm_itmperil c,
	   	 gipi_parlist h,
       	 gipi_polbasic e,
		 giis_intermediary i,
         (SELECT SUM(NVL(expense_reserve,0)) reserve_expenses,
		 	  	 SUM(NVL(loss_reserve,0)) reserve_losses,
				 SUM(NVL(loss_reserve,0) + NVL(expense_reserve,0)) res_amt,
               	 claim_id,
  		   	   	 item_no,
			   	 peril_cd
            FROM gicl_clm_res_hist
           WHERE 1=1
             AND NVL(dist_sw, 'N') = 'Y'
             AND claim_id >0
           GROUP BY claim_id,
			   	  item_no,
			   	  peril_cd) f,
		  (SELECT a.claim_id,
	   		   	  a.item_no,
			   	  a.peril_cd,
               	  SUM(NVL(a.losses_paid,0)) losses_paid,
               	  SUM(NVL(a.expenses_paid,0)) exp_paid,
				  SUM(NVL(a.expenses_paid,0) + NVL(a.losses_paid,0)) paid_amt,
				  TRUNC(date_paid) date_paid
             FROM gicl_clm_res_hist a ,
		  	   	  gicl_item_peril b
            WHERE 1 = 1
		      AND a.claim_id = b.claim_id
		   	  AND a.item_no = b.item_no
		   	  AND a.peril_cd = b.peril_cd
           	  AND a.tran_id IS NOT NULL
           	  AND NVL(a.cancel_tag,'N') = 'N'
			GROUP BY a.claim_id,
		 	   	  a.item_no,
			   	  a.peril_cd,
				  TRUNC(date_paid)) g
   WHERE 1=1
     AND a.claim_id = b.claim_id+0
   	 AND a.claim_id = b.claim_id+0
	 AND b.peril_cd = p.peril_cd
   	 AND b.claim_id = f.claim_id(+)
   	 AND b.claim_id = g.claim_id(+)
   	 AND b.item_no  = g.item_no(+)
   	 AND b.peril_cd = g.peril_cd(+)
   	 AND b.item_no = f.item_no(+)
   	 AND b.peril_cd = f.peril_cd(+)
   	 AND b.claim_id = c.claim_id
   	 AND b.peril_cd = c.peril_cd
   	 AND b.item_no =  c.item_no
   	 AND h.par_id = e.par_id
   	 AND a.line_cd = e.line_cd
	 AND a.line_cd = p.line_cd
   	 AND a.subline_cd = e.subline_cd
   	 AND a.pol_iss_cd = e.iss_cd
   	 AND a.issue_yy = e.issue_yy
   	 AND a.pol_seq_no = e.pol_seq_no
   	 AND a.renew_no = e.renew_no
	 AND c.intm_no = i.intm_no
   	 AND a.claim_id>0
   	 AND e.endt_seq_no = 0
   GROUP BY NVL(f.res_amt,0),
       	 NVL(g.paid_amt,0),
		 NVL(b.ann_tsi_amt,0),
         TRUNC(a.clm_file_date),
   		 g.date_paid,
 	  	 a.line_cd,
	   	 a.subline_cd,
	   	 a.iss_cd,
	   	 c.intm_no,
		 i.intm_type,
	   	 h.assd_no,
	   	 a.clm_stat_cd,
		 RTRIM(Get_Line_Name(a.line_cd)),
		 RTRIM(Get_Subline_Name(a.subline_cd)),
		 RTRIM(Get_Iss_Name(a.iss_cd)),
		 RTRIM(Get_Intm_Name(c.intm_no)),
		 Get_Intm_Type_Desc(intm_type),
		 RTRIM(Get_Assd_Name(h.assd_no)),
		 b.claim_id,
		 b.item_no,
		 p.peril_name)
LOOP

  INSERT INTO eim_os_loss (
    loss_date,			settled_date,
	line_cd,  			subline_cd,
	branch_cd,  		intm_no,
	intm_type,			assd_no,
	reserve_amt,		settled_amt,
	tsi_loss_amt,		os_loss_amt,
	cancelled_loss,		claim_stat,
	line_name,			subline_name,
	branch_name,		intm_name,
	intm_type_desc,		assd_name,
	claim_id,			item_no,
	peril_name,			extraction_date,
	user_id)
  VALUES (
  	os.rep_date,		os.date_paid,
	os.line_cd,  		os.subline_cd,
	os.iss_cd,			os.intm_no,
	os.intm_type,		os.assd_no,
	os.res_amt,			os.set_amt,
	os.tsi_loss,		os.os_loss,
	os.can_loss,		os.clm_stat,
	os.line_name,		os.subline_name,
	os.branch_name,		os.intm_name,
	os.intm_type_desc,	os.assd_name,
	os.claim_id,		os.item_no,
	os.peril_name,		SYSDATE,
	USER);

END LOOP;
COMMIT;
END;
/

DROP PROCEDURE CPI.EXT_LOSSES_OLD;
