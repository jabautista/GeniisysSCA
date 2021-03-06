DROP TRIGGER CPI.GIAC_GACC_OCV_TAXUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_GACC_OCV_TAXUD
AFTER UPDATE ON CPI.GIAC_ACCTRANS FOR EACH ROW
begin
  if :new.tran_flag = 'D' THEN
    begin
     delete from giac_parent_comm_voucher
     where gacc_tran_id = :NEW.tran_id
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
     where gacc_tran_id = :NEW.tran_id
       and print_date is not null
       and ocv_no is not null
       and ocv_pref_suf is not null;
    exception
     when no_data_found then
       null;
    end;
  end if;
end;
/


