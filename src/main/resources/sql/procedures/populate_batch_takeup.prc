DROP PROCEDURE CPI.POPULATE_BATCH_TAKEUP;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_BATCH_TAKEUP(v_date number, v_year number) as
begin
  delete from GICL_BATCH_TAKEUP;
  for i in (select a.claim_id, a.clm_res_hist_id, a.item_no, a.peril_cd,
                   nvl(a.loss_reserve,0) losses,
                   nvl(a.expense_reserve,0) expenses,
                   d.dsp_loss_date, d.clm_file_date
              from gicl_clm_res_hist a,
                   (select claim_id,
                           item_no, peril_cd
                      from gicl_clm_res_hist
                     where tran_id is null
                       and dist_sw = 'Y'
                     minus
                   select claim_id, item_no, peril_cd
                      from gicl_clm_res_hist
                     where 1 = 1
                       and tran_id is not null
                       and nvl(cancel_tag,'N') = 'N'
                       and (to_number(to_char(date_paid, 'MM')) <= v_date
                       and to_number(to_char(date_paid, 'RRRR')) <= v_year)
                        or (to_number(to_char(date_paid, 'MM')) >= v_date
                           and to_number(to_char(date_paid, 'RRRR')) < v_year)) c,
                   gicl_claims d
             where 1 = 1
               and a.claim_id = d.claim_id
               and a.claim_id = c.claim_id
               and a.item_no = c.item_no
               and a.peril_cd = c.peril_cd
               and a.dist_sw = 'Y'
               and a.tran_id is null
               and d.clm_stat_cd not in ('WD','DN','CC','CD')
               and (nvl(a.loss_reserve,0) >= 0
                or nvl(a.expense_reserve,0) >= 0)
             minus
            select a.claim_id, a.clm_res_hist_id, a.item_no, a.peril_cd,
                   a.os_loss, a.os_expense, b.dsp_loss_date, b.clm_file_date
              from gicl_take_up_hist a, gicl_claims b
             where 1 = 1
               and a.claim_id = b.claim_id
               and decode(acct_date, null, to_char(sysdate,'MONTH'),
                   to_char(acct_date,'MONTH')) = to_char(sysdate,'MONTH')
               and decode(acct_date, null, to_char(sysdate,'YYYY'),
                   to_char(acct_date,'YYYY')) = to_char(sysdate,'YYYY')) loop
  insert into GICL_BATCH_TAKEUP( claim_id,
     clm_res_hist_id,
     item_no,
     peril_cd,
     losses,
     expenses,
     dsp_loss_date,
     clm_file_date)
  values(i.claim_id,
   i.clm_res_hist_id,
  i.item_no,
  i.peril_cd,
  i.losses,
  i.expenses,
  i.dsp_loss_date,
  i.clm_file_date);
  end loop;
  commit;
end;
/


