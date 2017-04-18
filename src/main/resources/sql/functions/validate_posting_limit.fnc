DROP FUNCTION CPI.VALIDATE_POSTING_LIMIT;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_POSTING_LIMIT( p_user_id VARCHAR2,
                                                       p_issue_code VARCHAR2, 
                                                       p_line_code VARCHAR2, 
                                                       p_par_type VARCHAR2,
                                                       p_tsi_amt NUMBER) 
  RETURN NUMBER IS
  
  /* created by: Paul
  ** dated: 3-23-2011
  ** function vadiates user posting limit based on user_id, iss_cd, line_cd, par_type
  ** and tsi_amt.
  ** Returns 1 when validated correctly or return 0 when invalidated or when no data found.
  */

  v_all_amt_sw      VARCHAR2(1);   -- user all_amt_sw
  v_post_limit      NUMBER(16,2);  -- user posting limit
  v_endt_all_amt_sw VARCHAR2(1);   -- endorsement all_amt_sw
  v_endt_post_limit NUMBER(16,2);  -- endorsement posting limit
  v_return          NUMBER(1);     -- return variable 
  
BEGIN
    
   SELECT   all_amt_sw,
            post_limit,
            endt_all_amt_sw,
            endt_post_limit
     INTO   v_all_amt_sw,
            v_post_limit,
            v_endt_all_amt_sw,
            v_endt_post_limit
     FROM   giis_posting_limit
    WHERE   /* user_id   = p_user_id  -- replaced by jhing 03.22.2012 since this condition causes too many rows when user assigned posting limit to other users */ posting_user = p_user_id
      AND   iss_cd    = p_issue_code
      AND   line_cd   = p_line_code;
      
   IF p_par_type = 'P' THEN    
       IF v_all_amt_sw ='Y' OR v_post_limit >= p_tsi_amt THEN
           v_return := 1;
       ELSE 
           v_return := 0;
       END IF;        
   ELSIF p_par_type = 'E' THEN    
       IF v_endt_all_amt_sw ='Y' OR v_endt_post_limit >= p_tsi_amt THEN
           v_return := 1;
       ELSE 
           v_return := 0;
       END IF;        
   ELSE    
       v_return := 3; --0; replaced by benjo 10.08.2015 GENQA-SR-4992 to display proper message
   END IF;

   RETURN v_return;

EXCEPTION WHEN NO_DATA_FOUND THEN
   v_return := 3; --0; replaced by benjo 10.08.2015 GENQA-SR-4992 to display proper message
   RETURN v_return;

END;
/


