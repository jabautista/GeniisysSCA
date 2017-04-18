CREATE OR REPLACE PACKAGE BODY CPI.GIPIR800_PKG AS


    FUNCTION cf_company_addresformula
       RETURN CHAR
    IS
       v_company_name   giis_parameters.param_name%TYPE;
    BEGIN
       FOR c IN (SELECT param_value_v
                   FROM giis_parameters
                  WHERE param_name = 'COMPANY_NAME')
       LOOP
          v_company_name := c.param_value_v;
       END LOOP;

       RETURN (v_company_name);
    END;
    
    FUNCTION cf_company_addressformula
       RETURN CHAR
    IS
       v_address   VARCHAR2 (500);
    BEGIN
       SELECT param_value_v
         INTO v_address
         FROM giis_parameters
        WHERE param_name = 'COMPANY_ADDRESS';

       RETURN (v_address);
       RETURN NULL;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          NULL;
          RETURN (v_address);
    END;


    FUNCTION populate_gipir800
       RETURN gipir800_tab PIPELINED
    AS
       v_rec   gipir800_type;
    BEGIN
       v_rec.company_name := cf_company_addresformula;
       v_rec.company_address := cf_company_addressformula;
       PIPE ROW (v_rec);
       RETURN;
       
    END populate_gipir800;

   FUNCTION populate_gipir800_details
       RETURN gipir800_details_tab PIPELINED
    AS
       v_rec   gipir800_details_type;
    BEGIN
        FOR i IN (SELECT a.assd_no num, a.assd_name name,
               a.mail_addr1 || ' ' || a.mail_addr2 || ' ' || a.mail_addr3 address,
               b.rv_meaning meaning
          FROM giis_assured a, cg_ref_codes b
         WHERE b.rv_low_value = a.corporate_tag
           AND b.rv_domain = 'GIIS_ASSURED.CORPORATE_TAG')
           
       LOOP
          v_rec.B_ASSD_NO  := i.num;
          v_rec.B_ASSD_NAME := i.name;
          v_rec.B_MAIL_ADDR1 := i.address;
          v_rec.B_RV_MEANING :=i.meaning;
          PIPE ROW (v_rec);
       END LOOP;
   
       RETURN;
    END;

END GIPIR800_PKG;
/


