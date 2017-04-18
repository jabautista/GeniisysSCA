CREATE OR REPLACE PACKAGE CPI.giacs302_pkg
AS
   TYPE rec_type IS RECORD (
      fund_cd       giis_funds.fund_cd%TYPE,
      fund_desc     giis_funds.fund_desc%TYPE,
      remarks       giis_funds.remarks%TYPE,
      user_id       giis_funds.user_id%TYPE,
      last_update   VARCHAR2(30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_fund_desc   giis_funds.fund_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_funds%ROWTYPE);

   PROCEDURE del_rec (p_fund_cd giis_funds.fund_cd%TYPE);

   PROCEDURE val_del_rec (p_fund_cd giis_funds.fund_cd%TYPE);

   PROCEDURE val_add_rec (p_fund_cd giis_funds.fund_cd%TYPE);
END;
/


