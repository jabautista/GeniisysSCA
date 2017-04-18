CREATE OR REPLACE PACKAGE CPI.gicls210_pkg
AS
   TYPE rec_type IS RECORD (
      adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
      priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE,
      payee_name            giis_adjuster.payee_name%TYPE,
      mail_addr             giis_adjuster.mail_addr%TYPE,
      bill_addr             giis_adjuster.bill_addr%TYPE,
      designation           giis_adjuster.designation%TYPE,
      contact_pers          giis_adjuster.contact_pers%TYPE,
      phone_no              giis_adjuster.phone_no%TYPE,
      remarks               giis_adjuster.remarks%TYPE,
      user_id               giis_adjuster.user_id%TYPE,
      last_update           VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_adj_company_cd          giis_adjuster.adj_company_cd%TYPE,
      p_priv_adj_cd             giis_adjuster.priv_adj_cd%TYPE,
      p_payee_name              giis_adjuster.payee_name%TYPE
   )  RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_adjuster%ROWTYPE);

   PROCEDURE del_rec (
        p_adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
        p_priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE
   );

   PROCEDURE val_del_rec (
        p_adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
        p_priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE
   );
   
   PROCEDURE val_add_rec(
        p_adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
        p_priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE
   );
   
   FUNCTION get_next_priv_adj(p_adj_company_cd  giis_adjuster.adj_company_cd%TYPE)
     RETURN NUMBER;
   
END;
/


