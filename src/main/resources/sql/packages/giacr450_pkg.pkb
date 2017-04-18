CREATE OR REPLACE PACKAGE BODY CPI.GIACR450_PKG
AS

   FUNCTION get_giacr450_records(
      p_line_cd               GIXX_PROD_BUDGET.line_cd%TYPE,
      p_user_id               GIIS_USERS.user_id%TYPE
   )
     RETURN giacr450_tab PIPELINED
   IS
      v_row                   giacr450_type;
      v_company_name          GIIS_PARAMETERS.param_value_v%TYPE;
      v_company_address       GIIS_PARAMETERS.param_value_v%TYPE;
      v_found                 BOOLEAN := FALSE;
   BEGIN
      BEGIN
         SELECT GIISP.v('COMPANY_NAME')
           INTO v_company_name
           FROM DUAL;
      EXCEPTION
         WHEN OTHERS THEN
            v_company_name := NULL;
      END;
   
      BEGIN
         SELECT GIISP.v('COMPANY_ADDRESS')
           INTO v_company_address
           FROM DUAL;
      EXCEPTION
         WHEN OTHERS THEN
            v_company_address := NULL;
      END;
   
      FOR i IN(SELECT AVG(prev_year) prev_year,  
                      AVG(curr_year) curr_year, line_name,
                      SUM(NVL(curr_prem,0)) curr_prem, 
                      SUM(NVL(prev_prem,0)) prev_prem,
                      SUM(NVL(curr_prem,0)) - SUM(NVL(prev_prem,0)) prem_diff, 
                      (SUM(NVL(curr_prem,0)) - SUM(NVL(prev_prem,0)))/DECODE(SUM(NVL(curr_prem,0)),0,DECODE(SUM(NVL(prev_prem,0)),0,1,SUM(NVL(prev_prem,0))),SUM(NVL(curr_prem,0))) *100 prem_pct, 
                      SUM(NVL(budget,0)) budget, 
                      SUM(NVL(curr_prem,0)) - SUM(NVL(budget,0)) budget_diff, 
                      (SUM(NVL(curr_prem,0)) - SUM(NVL(budget,0)))/ DECODE(SUM(NVL(budget,0)),0,1,SUM(NVL(budget,0))) *100 budget_pct
                 FROM GIXX_PROD_BUDGET bud,
                      GIIS_ISSOURCE iss,
                      GIIS_LINE LINE
                WHERE bud.iss_cd = iss.iss_cd
                  AND bud.user_id = p_user_id
                  AND bud.line_cd = line.line_cd  
                  AND bud.line_cd = NVL(p_line_cd,bud.line_cd)
                GROUP BY line_name)
      LOOP
         v_row := NULL;
         v_row.company_name := v_company_name;
         v_row.company_address := v_company_address;
         v_row.prev_year := i.prev_year;
         v_row.curr_year := i.curr_year;
         v_row.line_name := i.line_name;
         v_row.curr_prem := i.curr_prem;
         v_row.prev_prem := i.prev_prem;
         v_row.prem_diff := i.prem_diff;
         v_row.prem_pct := i.prem_pct;
         v_row.budget := i.budget;
         v_row.budget_diff := i.budget_diff;
         v_row.budget_pct := i.budget_pct;
         v_found := TRUE;
         
         PIPE ROW(v_row);
      END LOOP;
      
--      IF NOT v_found THEN
--         v_row.company_name := v_company_name;
--         v_row.company_address := v_company_address;
--         PIPE ROW(v_row);
--      END IF;
   END;

END;
/


