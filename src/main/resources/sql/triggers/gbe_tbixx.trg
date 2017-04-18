DROP TRIGGER CPI.GBE_TBIXX;

CREATE OR REPLACE TRIGGER CPI.GBE_TBIXX
     before insert ON CPI.GIAC_BATCH_ENTRIES      for each row
declare
        cca_gl_acct_id  giac_chart_of_accts.gl_acct_id%type;
        cca_sl_type_cd  giac_chart_of_accts.gslt_sl_type_cd%type;
     begin
        bae_check_chart_of_accts (
           :new.gl_acct_category         ,:new.gl_control_acct      ,
           :new.gl_sub_acct_1            ,:new.gl_sub_acct_2        ,
           :new.gl_sub_acct_3            ,:new.gl_sub_acct_4        ,
           :new.gl_sub_acct_5            ,:new.gl_sub_acct_6        ,
           :new.gl_sub_acct_7            ,cca_gl_acct_id            ,
           cca_sl_type_cd       );
        :new.gl_acct_id := cca_gl_acct_id;
       :new.gslt_sl_type_cd := cca_sl_type_cd;
       select dr_cr_tag
         into :new.dr_cr_tag
         from  giac_module_entries
        where module_id = :new.module_id
          and item_no = :new.item_no;
    end;
/


