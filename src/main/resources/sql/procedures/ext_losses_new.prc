DROP PROCEDURE CPI.EXT_LOSSES_NEW;

CREATE OR REPLACE PROCEDURE CPI.ext_losses_new IS

/** Created by : Lhen Valderrama
    Date Created : 09/10/03
	Date Modified: 10/02/03
    This procedure will extract the losses summary (includes reserve_amt, settled_amt,
    outstanding_losses and cancelled_amt) of a claim by item/peril.
**/

  v_os_loss      NUMBER(20,2);
  v_can_loss     NUMBER(20,2);

BEGIN

/**to delete previous data before extraction of current data**/
DELETE eim_os_loss
 WHERE user_id = USER;

FOR os IN(
  SELECT SUM(NVL(f.res_amt,0)) res_amt,
       	 SUM(NVL(g.paid_amt,0)) set_amt,
       	 SUM(NVL(b.ann_tsi_amt,0)) tsi_loss,
       	 SUM((DECODE(SIGN((NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) +
                        (NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))),-1,0,
                        (NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) +
                        (NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))))) loss_amt,
       	 b.close_date peril_close_dt,
       	 a.close_date claim_close_dt,
       	 DECODE(a.clm_stat_cd, 'CC', 'CANCELLED', 'DN', 'CANCELLED', 'WD', 'CANCELLED',
                             'CD', 'CLOSED', 'IN PROGRESS') clm_stat,
         a.clm_stat_cd,
       	 TRUNC(a.clm_file_date) rep_date,
       	 a.line_cd,
      	 a.subline_cd,
       	 a.iss_cd,
       	 c.intm_no,
       	 i.intm_type,
       	 a.assd_no,
       	 b.claim_id,
       	 b.item_no,
       	 p.peril_name
    FROM gicl_claims a,
       	 gicl_item_peril b,
       	 giis_peril p,
       	 gicl_intm_itmperil c,
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
	       		 SUM(NVL(a.expenses_paid,0) + NVL(a.losses_paid,0)) paid_amt
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
	       		 a.peril_cd) g
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
   	 AND a.line_cd = p.line_cd
   	 AND c.intm_no = i.intm_no
   	 AND a.claim_id>0
   GROUP BY b.close_date,
       	 a.close_date,
       	 DECODE(a.clm_stat_cd, 'CC', 'CANCELLED', 'DN', 'CANCELLED', 'WD', 'CANCELLED',
                             'CD', 'CLOSED', 'IN PROGRESS'),
         a.clm_stat_cd,
       	 TRUNC(a.clm_file_date),
      	 a.line_cd,
       	 a.subline_cd,
       	 a.iss_cd,
       	 c.intm_no,
       	 i.intm_type,
       	 a.assd_no,
       	 b.claim_id,
       	 b.item_no,
       	 p.peril_name)
LOOP
  v_os_loss    :=0;
  v_can_loss   :=0;

  /**whenever close_date(by claim) is not null, then amt is considered as cancelled or
     closed else amt is considered as outstanding losses (os_loss).**/
  IF TRUNC(NVL(os.claim_close_dt, SYSDATE+1)) < TRUNC(SYSDATE) THEN
     IF os.clm_stat_cd = 'CD' OR v_can_loss < 0 THEN
        v_can_loss    := 0;
     ELSE
        v_can_loss    := os.loss_amt;
     END IF;
  ELSE
     v_os_loss	 := os.loss_amt;
  END IF;

  INSERT INTO eim_os_loss (
    loss_date,			    settled_date,
    line_cd,  				subline_cd,
    branch_cd,  			intm_no,
    intm_type,				assd_no,
    reserve_amt,			settled_amt,
    tsi_loss_amt,			os_loss_amt,
    cancelled_loss,			claim_stat,
    line_name,				subline_name,
    branch_name,			intm_name,
    intm_type_desc,			assd_name,
    claim_id,				item_no,
    peril_name,				extraction_date,
    user_id)
  VALUES (
    os.rep_date,			os.claim_close_dt,
    os.line_cd,  			os.subline_cd,
    os.iss_cd,				os.intm_no,
    os.intm_type,			os.assd_no,
    os.res_amt,				os.set_amt,
    os.tsi_loss,			v_os_loss,
    v_can_loss,				os.clm_stat,
    Get_Line_Name(os.line_cd),		Get_Subline_Name(os.subline_cd),
    Get_Iss_Name(os.iss_cd),		DECODE(os.intm_no, 0, NULL, Get_Intm_Name(os.intm_no)),
    Get_Intm_Type_Desc(os.intm_type),	Get_Assd_Name(os.assd_no),
    os.claim_id,			os.item_no,
    os.peril_name,			SYSDATE,
   USER);

END LOOP;
COMMIT;
END;
/

DROP PROCEDURE CPI.EXT_LOSSES_NEW;
