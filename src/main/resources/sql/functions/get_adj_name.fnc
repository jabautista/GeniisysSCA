DROP FUNCTION CPI.GET_ADJ_NAME;

CREATE OR REPLACE FUNCTION CPI.Get_Adj_Name (p_priv_adj_cd    IN GICL_EXP_PAYEES.priv_adj_cd%TYPE,
                    p_adj_company_cd IN GICL_EXP_PAYEES.adj_company_cd%TYPE)
          RETURN VARCHAR2 AS
 --created by Herbert 120501
 CURSOR c1 (p_priv_adj_cd    IN GICL_EXP_PAYEES.priv_adj_cd%TYPE,
       p_adj_company_cd IN GICL_EXP_PAYEES.adj_company_cd%TYPE) IS
    SELECT payee_name
      FROM giis_adjuster
     WHERE priv_adj_cd = p_priv_adj_cd
       AND adj_company_cd = p_adj_company_cd;
  p_adj_name         giis_adjuster.payee_name%TYPE;
 BEGIN
   OPEN c1 (p_priv_adj_cd, p_adj_company_cd);
   FETCH c1 INTO p_adj_name;
   IF c1%FOUND THEN
     CLOSE c1;
     RETURN p_adj_name;
   ELSE
     CLOSE c1;
     RETURN NULL;
   END IF;
 END;
/


