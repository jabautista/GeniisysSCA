DROP PROCEDURE CPI.DISTNO_SEQ_RETRIEVER_GIUTS021;

CREATE OR REPLACE PROCEDURE CPI.DISTNO_SEQ_RETRIEVER_GIUTS021(p_dist_no        IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_temp_distno    IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_neg_distno     IN     GIUW_POL_DIST.dist_no%TYPE,
                                        p_var_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_msg_alert         OUT VARCHAR2)
IS
BEGIN
  p_msg_alert := 'SUCCESS';
  
  p_var_neg_distno :=  p_neg_distno;
  
  FOR c1 IN (SELECT POL_DIST_DIST_NO_S.NEXTVAL dist_no
               FROM dual)
  LOOP
    p_dist_no := c1.dist_no; 
    EXIT;
  END LOOP;
  
  FOR c1 IN (SELECT POL_DIST_DIST_NO_S.NEXTVAL dist_no
               FROM dual)
  LOOP
    p_temp_distno := c1.dist_no;
    EXIT;
  END LOOP;
  
  IF p_temp_distno IS NULL THEN
     p_msg_alert := 'Cannot generate a new distribution number, please contact your DBA.';
  END IF;
  
END DISTNO_SEQ_RETRIEVER_GIUTS021;
/


