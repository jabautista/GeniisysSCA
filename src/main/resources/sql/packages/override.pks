CREATE OR REPLACE PACKAGE CPI.OVERRIDE IS
   FUNCTION check_request_exist(p_module_id   VARCHAR2,
                                p_function_cd VARCHAR2,
                                p_columns     VARCHAR2)
   RETURN NUMBER;
   PROCEDURE generate_request(p_module_id    VARCHAR2,
                              p_function_cd  VARCHAR2,
                              p_line_cd      VARCHAR2,
                              p_iss_cd       VARCHAR2,
                              p_remarks      VARCHAR2,
                              p_display      VARCHAR2,
                              p_columns      VARCHAR2);     
   FUNCTION  generate_display(p_module_id    VARCHAR2,
                              p_function_cd  VARCHAR2,
                              p_columns      VARCHAR2)
   RETURN VARCHAR2; 
   FUNCTION generate_p_column(p_columns      VARCHAR2,
                              p_function_col NUMBER,
                              p_function_val VARCHAR2)
   RETURN VARCHAR2;            
  PROCEDURE generate_override_history(p_module_id      VARCHAR2,
                                   p_function_cd    VARCHAR2,
                                   p_line_cd        VARCHAR2,
                                   p_iss_cd         VARCHAR2,
                                   p_remarks        VARCHAR2,
                                   p_display        VARCHAR2,
                                   p_columns        VARCHAR2,
                                   p_override_user  VARCHAR2,
                                   p_override_date  VARCHAR2);                                                                                                                                    
END;
/


