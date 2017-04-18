DROP TRIGGER CPI.GIAC_ORDER_PAYTS_TAUXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_ORDER_PAYTS_TAUXX
after update of OR_FLAG ON CPI.GIAC_ORDER_OF_PAYTS for each row
declare
  v_tran_id           giac_order_of_payts.gacc_tran_id%type;
  v_acct_ent_date     gipi_polbasic.acct_ent_date%type;
begin
  if :new.or_flag = 'C' then
      for rec in (select policy_id,             line_cd,
                         subline_cd,            pol_prem_amt,
                         iss_cd,                prem_seq_no,
                         inst_no,               premium_amt,
                         tax_amt,               tran_date,
                         acct_ent_date,         reverse_tag,
                         currency_rt,           other_charges
        from giac_sc_collns
        where gacc_tran_id = :new.gacc_tran_id ) LOOP
        if rec.acct_ent_date is null then
          delete
            from giac_sc_collns
            where gacc_tran_id = :new.gacc_tran_id;
        else
          update giac_sc_collns
            set reverse_tag = 'Y'
            where gacc_tran_id = :new.gacc_tran_id;
          insert into giac_sc_collns
            (gacc_tran_id,       policy_id,      line_cd,
             subline_cd,         pol_prem_amt,   iss_cd,
             prem_seq_no,        inst_no,        premium_amt,
             tax_amt,            tran_date,      acct_ent_date,
             reverse_tag,        currency_rt,    other_charges)
          values
            (:new.gacc_tran_id,  rec.policy_id,        rec.line_cd,
             rec.subline_cd,     -1 * rec.pol_prem_amt, rec.iss_cd,
             rec.prem_seq_no,    rec.inst_no,          -1 * rec.premium_amt,
             -1 * rec.tax_amt,   sysdate,              null,
             null,                rec.currency_rt,     -1 * rec.other_charges);
        end if;
      END LOOP;
  end if;
end;
/


