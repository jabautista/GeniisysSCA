DROP PROCEDURE CPI.UPDATE_TRAN_DATE;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_TRAN_DATE is
  v_date	date;
begin
  for i in (select claim_id, clm_loss_id, tran_id
              from gicl_clm_loss_exp
             where tran_id is not null) loop
    begin
      select dv_print_date
        into v_date
        from giac_disb_vouchers
       where gacc_tran_id = i.tran_id
         and print_tag = 6;
    exception
      when NO_DATA_FOUND then
        null;
    end;
    update gicl_clm_loss_exp
      set tran_date = v_date
     where claim_id = i.claim_id
       and clm_loss_id = i.clm_loss_id
       and tran_id = i.tran_id;
  end loop;
end;
/


