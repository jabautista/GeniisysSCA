CREATE OR REPLACE PACKAGE CPI.giis_adjuster_pkg
AS

    FUNCTION check_priv_adj_exist(p_adj_company_cd  giis_adjuster.adj_company_cd%TYPE)
    RETURN VARCHAR2;

END giis_adjuster_pkg;
/


