CREATE OR REPLACE PACKAGE CPI.giiss016_pkg
AS
   TYPE main_type IS RECORD (
      np_no         giis_notary_public.np_no%TYPE,
      np_name       giis_notary_public.np_name%TYPE,
      ptr_no        giis_notary_public.ptr_no%TYPE,
      issue_date    giis_notary_public.issue_date%TYPE,
      expiry_date   giis_notary_public.expiry_date%TYPE,
      place_issue   giis_notary_public.place_issue%TYPE,
      user_id       giis_notary_public.user_id%TYPE,
      last_update   VARCHAR2(50),
      remarks       giis_notary_public.remarks%TYPE
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_rec_list
      RETURN main_tab PIPELINED;
      
   PROCEDURE set_rec (p_rec giis_notary_public%ROWTYPE);
   
   PROCEDURE val_del_rec (p_np_no VARCHAR2);
   
   PROCEDURE del_rec (p_np_no VARCHAR2);
         
END;
/


