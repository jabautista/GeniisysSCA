DROP PROCEDURE CPI.AEG_CHECK_CHART_OF_ACCTS2;

CREATE OR REPLACE PROCEDURE CPI.AEG_Check_Chart_Of_Accts2
    (cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
     p_message        IN OUT VARCHAR2 ) IS

     ws_leaf_tag         GIAC_CHART_OF_ACCTS.leaf_tag%TYPE;

BEGIN
     /*
    **  Created by      : D.Alcantara 
    **  Date Created    : 02.10.2012
    **  Reference By    : AEG_CHECK_CHART_OF_ACCTS from various modules
    **  Description     :  This procedure checks the existence of GL codes in GIAC_CHART_OF_ACCTS
    **                     and return an appropriate message if no data is found   
    */
 BEGIN                           
  SELECT DISTINCT(gl_acct_id)
    INTO cca_gl_acct_id
    FROM giac_chart_of_accts
   WHERE gl_acct_category  = cca_gl_acct_category
     AND gl_control_acct   = cca_gl_control_acct
     AND gl_sub_acct_1     = cca_gl_sub_acct_1
     AND gl_sub_acct_2     = cca_gl_sub_acct_2
     AND gl_sub_acct_3     = cca_gl_sub_acct_3
     AND gl_sub_acct_4     = cca_gl_sub_acct_4
     AND gl_sub_acct_5     = cca_gl_sub_acct_5
     AND gl_sub_acct_6     = cca_gl_sub_acct_6
     AND gl_sub_acct_7     = cca_gl_sub_acct_7;
 
 
     BEGIN
      SELECT leaf_tag
        INTO ws_leaf_tag
        FROM giac_chart_of_accts
       WHERE gl_acct_id = cca_gl_acct_id;
      --IF nvl(ws_leaf_tag, 'N') = 'N' THEN --replaced by Kenneth L. 11.13.2013
      IF ws_leaf_tag = 'N' THEN
         p_message := 'GL account code '||to_char(cca_gl_acct_category)
                    ||'-'||to_char(cca_gl_control_acct,'09') 
                    ||'-'||to_char(cca_gl_sub_acct_1,'09')
                    ||'-'||to_char(cca_gl_sub_acct_2,'09')
                    ||'-'||to_char(cca_gl_sub_acct_3,'09')
                    ||'-'||to_char(cca_gl_sub_acct_4,'09')
                    ||'-'||to_char(cca_gl_sub_acct_5,'09')
                    ||'-'||to_char(cca_gl_sub_acct_6,'09')
                    ||'-'||to_char(cca_gl_sub_acct_7,'09')
                    ||' is not a posting account.';
      END IF; 
     EXCEPTION    
       WHEN no_data_found THEN
          p_message := 'GL account code '||to_char(cca_gl_acct_category)
                    ||'-'||to_char(cca_gl_control_acct,'09') 
                    ||'-'||to_char(cca_gl_sub_acct_1,'09')
                    ||'-'||to_char(cca_gl_sub_acct_2,'09')
                    ||'-'||to_char(cca_gl_sub_acct_3,'09')
                    ||'-'||to_char(cca_gl_sub_acct_4,'09')
                    ||'-'||to_char(cca_gl_sub_acct_5,'09')
                    ||'-'||to_char(cca_gl_sub_acct_6,'09')
                    ||'-'||to_char(cca_gl_sub_acct_7,'09')
                    ||' is not a posting account.';  
     END;
 
 EXCEPTION
   WHEN no_data_found THEN
     p_message := 'GL account code '||to_char(cca_gl_acct_category)
                ||'-'||to_char(cca_gl_control_acct,'09') 
                ||'-'||to_char(cca_gl_sub_acct_1,'09')
                ||'-'||to_char(cca_gl_sub_acct_2,'09')
                ||'-'||to_char(cca_gl_sub_acct_3,'09')
                ||'-'||to_char(cca_gl_sub_acct_4,'09')
                ||'-'||to_char(cca_gl_sub_acct_5,'09')
                ||'-'||to_char(cca_gl_sub_acct_6,'09')
                ||'-'||to_char(cca_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans).';
 END;
END;
/


