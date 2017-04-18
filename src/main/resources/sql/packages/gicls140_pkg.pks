CREATE OR REPLACE PACKAGE CPI.gicls140_pkg
AS
   TYPE rec_type IS RECORD (
      eval_sw                giis_payee_class.eval_sw%TYPE,
      loa_sw                 giis_payee_class.loa_sw%TYPE, 
      payee_class_cd         giis_payee_class.payee_class_cd%TYPE,
      class_desc 	         giis_payee_class.class_desc%TYPE,
      payee_class_tag        giis_payee_class.payee_class_tag%TYPE,
      dsp_pc_tag_desc        VARCHAR2 (30),
      master_payee_class_cd  giis_payee_class.master_payee_class_cd%TYPE,
      sl_type_tag            giis_payee_class.sl_type_tag%TYPE,
      sl_type_cd             giis_payee_class.sl_type_cd%TYPE,
      clm_vat_cd             giis_payee_class.clm_vat_cd%TYPE, 
      remarks     	         giis_payee_class.remarks%TYPE,
      user_id     	         giis_payee_class.user_id%TYPE,
      last_update 	         VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_payee_class_cd     giis_payee_class.payee_class_cd%TYPE,
      p_class_desc  giis_payee_class.class_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_payee_class%ROWTYPE);

   PROCEDURE del_rec (p_payee_class_cd giis_payee_class.payee_class_cd%TYPE);

   PROCEDURE val_del_rec (p_payee_class_cd giis_payee_class.payee_class_cd%TYPE);
   
   PROCEDURE val_add_rec(p_payee_class_cd giis_payee_class.payee_class_cd%TYPE);
   
END;
/


