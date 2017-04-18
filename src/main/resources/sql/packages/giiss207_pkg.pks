CREATE OR REPLACE PACKAGE CPI.GIISS207_pkg AS

  TYPE giis_user_type IS RECORD(
    user_id     giis_users.user_id%TYPE,
    user_name   giis_users.user_name%TYPE
  );
          
  TYPE giis_user_tab IS TABLE OF giis_user_type;
  
  TYPE giis_issue_source_type IS RECORD(
    iss_cd      giis_issource.iss_cd%TYPE,
    iss_name    giis_issource.iss_name%TYPE
  );
      
  TYPE giis_issue_source_tab IS TABLE OF giis_issue_source_type;
  
  TYPE giis_posting_limit_type IS RECORD(
    posting_user    giis_posting_limit.posting_user%TYPE,
    iss_cd          giis_posting_limit.iss_cd%TYPE,
    iss_name        giis_issource.iss_name%TYPE,
    line_cd         giis_posting_limit.line_cd%TYPE,
    line_name       giis_line.line_name%TYPE,
    all_amt_sw      giis_posting_limit.all_amt_sw%TYPE,
    post_limit      giis_posting_limit.post_limit%TYPE,
    user_id         giis_posting_limit.user_id%TYPE,
    last_update     VARCHAR2(100),
    endt_post_limit giis_posting_limit.endt_post_limit%TYPE,
    endt_all_amt_sw giis_posting_limit.endt_all_amt_sw%TYPE
  );
  
  TYPE giis_posting_limit_tab IS TABLE OF giis_posting_limit_type;
  
  TYPE giis_line_type IS RECORD(
    line_cd      giis_line.line_cd%TYPE,
    line_name    giis_line.line_name%TYPE
  );
        
  TYPE giis_line_tab IS TABLE OF giis_line_type;
  
  FUNCTION get_giis_users (p_user_id GIIS_USERS.user_id%TYPE,
                           p_user_id_from VARCHAR2)
      RETURN giis_user_tab PIPELINED;
            
  FUNCTION get_issue_sources (p_user_id GIIS_USERS.user_id%TYPE,
                              --p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE,
                              p_maintenance_user VARCHAR2)
      RETURN giis_issue_source_tab PIPELINED;

  FUNCTION get_lines(p_user_id GIIS_USERS.user_id%TYPE,
                     p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE,
                     --p_line_name GIIS_LINE.line_name%TYPE,
                     p_maintenance_user VARCHAR2)
      RETURN giis_line_tab PIPELINED;
      

  PROCEDURE val_add_rec(
    p_line_cd giis_line.line_name%TYPE,
    p_user_id   giis_users.user_id%TYPE,
    p_iss_cd    giis_issource.iss_cd%TYPE
  );      

  FUNCTION get_posting_limits(p_user_id GIIS_USERS.user_id%TYPE,
                              p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE,
                              p_maintenance_user VARCHAR2)
      RETURN giis_posting_limit_tab PIPELINED;
      
  PROCEDURE set_posting_limits(
    p_post_limits giis_posting_limit%ROWTYPE
  );
  
  PROCEDURE delete_posting_limit(p_post_limits GIIS_POSTING_LIMIT%ROWTYPE);
  
  
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 27, 2012
**  Reference By : (GIISS207 - Maintenance - Posting Limit)
**  Description  : validate copy-to-user if existing - new version of lov
*/
  FUNCTION validate_copy_user(p_user_id  GIIS_USERS.user_id%TYPE)
     RETURN VARCHAR2;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  December 18, 2012
**  Reference By : (GIISS207 - Maintenance - Posting Limit)
**  Description  : validate copy-branch if existing - new version of lov
*/
  FUNCTION validate_copy_branch(p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE)
     RETURN VARCHAR2;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  December 21, 2012
**  Reference By : (GIISS207 - Maintenance - Posting Limit)
**  Description  : validate line name if existing - new version of lov 
*/     
  FUNCTION validate_line_name(p_line_name  GIIS_LINE.line_name%TYPE,
                              p_user_id GIIS_USERS.user_id%TYPE,
                              p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE)
    RETURN VARCHAR2;
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 29, 2012
**  Reference By : (GIISS207 - Maintenance - Posting Limit)
**  Description  : program unit in GIISS207 
**  Modified By : Gzelle SR13166 - added parameter userid 
*/  
  PROCEDURE set_copy_to_another_user(p_copy_to_user GIIS_USERS.user_id%TYPE,
                                      p_copy_to_branch GIIS_ISSOURCE.iss_cd%TYPE,
                                      p_copy_from_user GIIS_USERS.user_id%TYPE,
                                      p_copy_from_branch GIIS_ISSOURCE.iss_cd%TYPE,
                                      p_populate_all_sw VARCHAR2,
                                      p_user_id GIIS_USERS.user_id%TYPE);

END GIISS207_pkg;
/


