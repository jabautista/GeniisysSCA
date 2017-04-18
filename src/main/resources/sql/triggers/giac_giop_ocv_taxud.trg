DROP TRIGGER CPI.GIAC_GIOP_OCV_TAXUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_GIOP_OCV_TAXUD
AFTER UPDATE ON CPI.GIAC_ORDER_OF_PAYTS FOR EACH ROW
begin
  if :new.or_flag = 'C' then
    begin
     delete from giac_parent_comm_voucher
     where gacc_tran_id = :new.gacc_tran_id
       and print_date is null
       and ocv_no is null
       and ocv_pref_suf is null;
    exception
     when no_data_found then
       null;
    end;

    begin
     update giac_parent_comm_voucher
     set cancel_tag = 'Y'
     where gacc_tran_id = :new.gacc_tran_id
       and print_date is not null
       and ocv_no is not null
       and ocv_pref_suf is not null
       and tran_class = 'COL';
    exception
     when no_data_found then
       null;
    end;
  end if;
end;
/


