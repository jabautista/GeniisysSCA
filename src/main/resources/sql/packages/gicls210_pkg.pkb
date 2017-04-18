CREATE OR REPLACE PACKAGE BODY CPI.gicls210_pkg
AS
   FUNCTION get_rec_list (
      p_adj_company_cd          giis_adjuster.adj_company_cd%TYPE,
      p_priv_adj_cd             giis_adjuster.priv_adj_cd%TYPE,
      p_payee_name              giis_adjuster.payee_name%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.adj_company_cd, a.priv_adj_cd, a.payee_name,
                       a.mail_addr, a.bill_addr, a.contact_pers, a.designation, a.phone_no,
                       a.remarks, a.user_id, a.last_update
                  FROM giis_adjuster a
                 WHERE a.adj_company_cd = p_adj_company_cd 
                   AND a.priv_adj_cd = nvl(p_priv_adj_cd, a.priv_Adj_cd)
                   AND UPPER (NVL(a.payee_name, '%')) LIKE UPPER (NVL (p_payee_name, '%'))
--                 WHERE TO_CHAR(a.adj_company_cd) LIKE NVL (p_adj_company_cd, '%')
--                   AND TO_CHAR(a.priv_adj_cd) LIKE NVL (p_priv_adj_cd, '%')
--                   AND UPPER (NVL(a.payee_name, '%')) LIKE UPPER (NVL (p_payee_name, '%'))
                 ORDER BY a.adj_company_cd
                   )                   
      LOOP
         v_rec.adj_company_cd := i.adj_company_cd;
         v_rec.priv_adj_cd := i.priv_adj_cd;
         v_rec.payee_name := i.payee_name;
         v_rec.mail_addr := i.mail_addr;
         v_rec.bill_addr := i.bill_addr;
         v_rec.contact_pers := i.contact_pers;
         v_rec.designation := i.designation;
         v_rec.phone_no := i.phone_no;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_adjuster%ROWTYPE)
   IS
        v_priv_adj_cd       giis_adjuster.priv_adj_cd%TYPE;
   BEGIN
   
      IF p_rec.priv_adj_cd IS NULL THEN
      
        v_priv_adj_cd := Gicls210_pkg.get_next_priv_adj(p_rec.adj_company_cd);
      
      ELSE
        v_priv_adj_cd := p_rec.priv_adj_cd;
      
      END IF;
   
      MERGE INTO giis_adjuster
         USING DUAL
         ON (    adj_company_cd = p_rec.adj_company_cd
             AND priv_adj_cd = v_priv_adj_cd)
         WHEN NOT MATCHED THEN
            INSERT (adj_company_cd,       priv_adj_cd,       payee_name, 
                    mail_addr,            bill_addr,         contact_pers, payee_class_cd,
                    designation,          phone_no,          entry_date,
                    remarks,              user_id,           last_update)
            VALUES (p_rec.adj_company_cd, v_priv_adj_cd, p_rec.payee_name, 
                    p_rec.mail_addr,      p_rec.bill_addr,   p_rec.contact_pers, p_rec.payee_class_cd,
                    p_rec.designation,    p_rec.phone_no,    SYSDATE,
                    p_rec.remarks,        p_rec.user_id,     SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET payee_name   = p_rec.payee_name,
                   mail_addr    = p_rec.mail_addr,
                   bill_addr    = p_rec.bill_addr,
                   contact_pers = p_rec.contact_pers,
                   designation  = p_rec.designation,
                   phone_no     = p_rec.phone_no,
                   remarks      = p_rec.remarks, 
                   user_id      = p_rec.user_id, 
                   last_update  = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
        p_adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
        p_priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_adjuster
            WHERE adj_company_cd    = p_adj_company_cd
              AND priv_adj_cd       = p_priv_adj_cd;
   END;

   PROCEDURE val_del_rec (
        p_adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
        p_priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      NULL;
   END;

   PROCEDURE val_add_rec(
        p_adj_company_cd        giis_adjuster.adj_company_cd%TYPE,
        p_priv_adj_cd           giis_adjuster.priv_adj_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_adjuster a
                 WHERE a.adj_company_cd = p_adj_company_cd
                   AND a.priv_adj_cd    = p_priv_adj_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with same adj_company_cd and priv_adj_cd.');
      END IF;
      
   END;
   
   FUNCTION get_next_priv_adj(p_adj_company_cd  giis_adjuster.adj_company_cd%TYPE)
     RETURN NUMBER
   IS
        v_next  NUMBER(3);
   BEGIN
   
        SELECT MAX(priv_adj_cd) 
          INTO v_next
	      FROM giis_adjuster
	     WHERE adj_company_cd = p_adj_company_cd;

        RETURN NVL(v_next, 0) + 1;
        
   END get_next_priv_adj;
   
END;
/


