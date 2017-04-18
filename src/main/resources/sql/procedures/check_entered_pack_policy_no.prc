DROP PROCEDURE CPI.CHECK_ENTERED_PACK_POLICY_NO;

CREATE OR REPLACE PROCEDURE CPI.check_entered_pack_policy_no(
	p_line_cd			IN     GIPI_PACK_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN     GIPI_PACK_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN     GIPI_PACK_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN     GIPI_PACK_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN     GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN     GIPI_PACK_WPOLBAS.renew_no%TYPE,
	p_pack_pol_flag		OUT gipi_pack_wpolbas.pack_pol_flag%TYPE,
	p_msg_alert			   OUT VARCHAR2)
AS
	/*	Date        Author			Description
    **	==========	===============	============================
    **	11.12.2010	Emman			This procedure Checks the validity of the entered policy
    **                              Reference by : (GIPIS031A - Pack Endt Basic Information)
	**	11.02.2011	mark jm			added p_pack_pol_flag to be returned
    */
    
  /* Search the gipi_polbasic to determine if the */
  /* policy number entered exist in gipi_polbasic */        
   CURSOR A IS
      SELECT    pack_pol_flag
        FROM    gipi_pack_polbasic
       WHERE    line_cd      = p_line_cd
         AND    subline_cd   = p_subline_cd
         AND    iss_cd       = p_iss_cd
         AND    issue_yy     = p_issue_yy
         AND    pol_seq_no   = p_pol_seq_no
           AND    renew_no   = p_renew_no
            AND    dist_flag   NOT IN ('5','X');

  /* Search the gipi_wpolbas table to see if another */
  /* par is endorsing the entered policy number      */
   CURSOR B IS
     SELECT   user_id
       FROM   gipi_pack_wpolbas  --A.R.C. 07.27.2006
      WHERE   line_cd     =  p_line_cd
        AND   subline_cd  =  p_subline_cd
        AND   iss_cd      =  p_iss_cd
        AND   issue_yy    =  p_issue_yy
        AND   pol_seq_no  =  p_pol_seq_no
          AND   renew_no    =  p_renew_no;

  /* Search the gipi_wpolbas table to see if another */
  /* par is endorsing the entered policy number      */
   CURSOR C IS
     SELECT   pol_flag
       FROM   gipi_pack_polbasic  --A.R.C. 07.27.2006
      WHERE   line_cd     =  p_line_cd
        AND   subline_cd  =  p_subline_cd
        AND   iss_cd      =  p_iss_cd
        AND   issue_yy    =  p_issue_yy
        AND   pol_seq_no  =  p_pol_seq_no
          AND   renew_no    =  p_renew_no;

   userid       VARCHAR(8);
   p_exist1     VARCHAR2(3);
   p_exist2     NUMBER;
   p_exist3     gipi_polbasic.pol_flag%TYPE;
BEGIN
   OPEN A;
   FETCH A INTO p_exist1;
      IF A%FOUND THEN
         p_pack_pol_flag  :=  p_exist1;
         p_msg_alert := NULL;
      ELSE
         --p_subline_cd  := NULL;
         --p_iss_cd    := NULL;
         --p_issue_yy    := NULL;
         --p_pol_seq_no  := NULL;
           --p_renew_no    := NULL;
         p_msg_alert := 'Policy specified does not exist. Cannot endorse a non-existing policy.';
      END IF;
   CLOSE A;
   
   IF p_msg_alert IS NOT NULL THEN                
        RETURN;
   END IF;

   OPEN B;
   FETCH B INTO userid;
      IF B%found THEN
         IF userid is not null then
             p_msg_alert := 'Policy is currently being endorsed by ' || userid || ', cannot endorse the same policy '||
                   'at the same time.';
         ELSE
             p_msg_alert := 'Policy is currently being endorsed, cannot endorse the same policy at the same time.';
         END IF;
         --p_subline_cd  := NULL;
         --p_iss_cd      := NULL;
         --p_issue_yy      := NULL;
         --p_pol_seq_no  := NULL;
          --p_renew_no    := NULL;
      ELSE    
         p_msg_alert := NULL;
      END IF;
      
      IF p_msg_alert IS NOT NULL THEN                
        RETURN;
         END IF;
   CLOSE B;

   OPEN C;
   FETCH C INTO p_exist3;
   CLOSE C;
   IF p_exist3 != 'X' AND p_exist3 != 4 THEN
      NULL;
   ELSIF p_exist3 = '4' THEN -- GRACE 05/18/2000 to check for cancelled policy 
         p_msg_alert := 'Policy specified has been cancelled. Cannot endorse a cancelled policy.';
      --p_subline_cd  := NULL;
      --p_issue_yy      := NULL;
      --p_pol_seq_no  := NULL;
      --p_renew_no    := NULL;
      RETURN;        
   ELSIF p_exist3 = 'X' THEN
      p_msg_alert := 'Policy specified has been renewed.';-- ';  --Deo [03.07.2017]: remove space after period (SR-23910)
   ELSE
      p_msg_alert := 'Policy has already expired.';
   END IF;
   
   IF p_msg_alert IS NULL THEN
      BEGIN
         FOR i IN (SELECT 1
                     FROM gipi_pack_polnrep
                    WHERE old_pack_policy_id IN (SELECT pack_policy_id
                                                   FROM gipi_pack_polbasic
                                                  WHERE line_cd     =  p_line_cd
                                                    AND subline_cd  =  p_subline_cd
                                                    AND iss_cd      =  p_iss_cd
                                                    AND issue_yy    =  p_issue_yy
                                                    AND pol_seq_no  =  p_pol_seq_no
                                                    AND renew_no    =  p_renew_no))
         LOOP
            p_msg_alert := 'Policy specified has been renewed.';     
         END LOOP;                      
      END;
   END IF;
END check_entered_pack_policy_no;
/


