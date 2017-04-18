CREATE OR REPLACE PACKAGE BODY CPI.GIPIR801_PKG AS

/* Formatted on 2013/05/14 16:21 (Formatter Plus v4.8.8) */
FUNCTION cf_comp_nameformula
   RETURN CHAR
IS
   v_name   VARCHAR2 (200);
BEGIN
   SELECT param_value_v
     INTO v_name
     FROM giis_parameters
    WHERE param_name = 'COMPANY_NAME';

   RETURN (v_name);
   RETURN NULL;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
      RETURN (v_name);
   WHEN TOO_MANY_ROWS
   THEN
      v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
      RETURN (v_name);
END;

/* Formatted on 2013/05/14 16:22 (Formatter Plus v4.8.8) */
FUNCTION cf_comp_addformula
   RETURN CHAR
IS
   v_add   VARCHAR2 (350);
BEGIN
   SELECT param_value_v
     INTO v_add
     FROM giis_parameters
    WHERE param_name = 'COMPANY_ADDRESS';

   RETURN (v_add);
   RETURN NULL;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
      RETURN (v_add);
   WHEN TOO_MANY_ROWS
   THEN
      v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
      RETURN (v_add);
END;

 FUNCTION populate_gipir801
      RETURN gipir801_tab PIPELINED 
    AS
      v_rec gipir801_type;
    BEGIN
      v_rec.company_name := cf_comp_nameformula;
      v_rec.company_address := cf_comp_addformula;
      PIPE ROW(v_rec);
      RETURN;
    END populate_gipir801;
    
        FUNCTION populate_gipir801_details
       RETURN gipir801_details_tab PIPELINED
    AS
       v_rec   gipir801_details_type;
    BEGIN
       FOR i IN (SELECT a.line_cd || '-' || b.line_name line, a.peril_cd code,
       a.peril_sname short_name, a.peril_name peril,
       DECODE (a.peril_type, 'A', 'Allied', 'Basic') TYPE,
       a.ri_comm_rt commission
       FROM giis_peril a, giis_line b
       WHERE a.line_cd = b.line_cd)
       LOOP
            v_rec.line_name := i.line;
            v_rec.peril_type := i.type;
            v_rec.peril_cd := i.code;
            v_rec.peril_sname := i.short_name;
            v_rec.peril_name := i.peril;
            v_rec.ri_comm_rt:= i.commission;
            PIPE ROW (v_rec);
          
       END LOOP;

       RETURN;
    END;

END GIPIR801_PKG;
/


