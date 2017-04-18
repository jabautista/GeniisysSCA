CREATE OR REPLACE PACKAGE CPI.GIISS211_PKG
AS
   TYPE rec_type IS RECORD (
      takeup_term       GIIS_TAKEUP_TERM.TAKEUP_TERM%type,
      takeup_term_desc  GIIS_TAKEUP_TERM.TAKEUP_TERM_DESC%type,
      no_of_takeup      GIIS_TAKEUP_TERM.NO_OF_TAKEUP%type,
      yearly_tag        GIIS_TAKEUP_TERM.YEARLY_TAG%type,
      remarks           GIIS_TAKEUP_TERM.REMARKS%type,
      user_id           GIIS_TAKEUP_TERM.USER_ID%type,
      last_update       VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_takeup_term         GIIS_TAKEUP_TERM.TAKEUP_TERM%type,
      p_takeup_term_desc    GIIS_TAKEUP_TERM.TAKEUP_TERM_DESC%type,
      p_yearly_tag          GIIS_TAKEUP_TERM.YEARLY_TAG%type
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec GIIS_TAKEUP_TERM%ROWTYPE);

   PROCEDURE del_rec (p_takeup_term         GIIS_TAKEUP_TERM.TAKEUP_TERM%type);

   PROCEDURE val_del_rec (p_takeup_term         GIIS_TAKEUP_TERM.TAKEUP_TERM%type);
   
   PROCEDURE val_add_rec(
        p_takeup_term           GIIS_TAKEUP_TERM.TAKEUP_TERM%type,
        p_takeup_term_desc      GIIS_TAKEUP_TERM.TAKEUP_TERM_DESC%type
   );
   
END GIISS211_PKG;
/


