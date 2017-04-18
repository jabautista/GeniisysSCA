CREATE OR REPLACE PACKAGE CPI.GICLS060_PKG
AS
   TYPE rec_type IS RECORD (
      le_stat_cd      gicl_le_stat.le_stat_cd%TYPE,
      le_stat_desc    gicl_le_stat.le_stat_desc%TYPE,
      remarks         gicl_le_stat.remarks%TYPE,
      user_id         gicl_le_stat.user_id%TYPE,
      last_update     VARCHAR2(30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec gicl_le_stat%ROWTYPE);

   PROCEDURE del_rec (p_le_stat_cd gicl_le_stat.le_stat_cd%TYPE);

   FUNCTION val_del_rec (p_le_stat_cd gicl_le_stat.le_stat_cd%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_le_stat_cd gicl_le_stat.le_stat_cd%TYPE);
   
END;
/


