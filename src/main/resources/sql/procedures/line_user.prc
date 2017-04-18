DROP PROCEDURE CPI.LINE_USER;

CREATE OR REPLACE PROCEDURE CPI.LINE_USER(p_line_cd    IN OUT GIIS_USER_GRP_LINE.line_cd%TYPE) IS
  p_count        NUMBER  :=  0;
  p_user_grp     GIIS_USER_GRP_LINE.user_grp%TYPE;
  CURSOR A IS
     SELECT USER_GRP
       FROM GIIS_USERS
      WHERE USER_ID = USER;
  CURSOR B(p_user_grp  giis_user_grp_line.user_grp%TYPE) IS
     SELECT LINE_CD
       FROM GIIS_USER_GRP_LINE
      WHERE USER_GRP = p_user_grp;
BEGIN
  OPEN A;
  FETCH A INTO p_user_grp;
  CLOSE A;
  IF p_user_grp IS NOT NULL THEN
     FOR B1 IN B(p_user_grp) LOOP
        p_count    :=  p_count + 1;
        p_line_cd  :=  B1.line_cd;
        IF p_count >= 2 THEN
           EXIT;
        ELSE
           NULL;
        END IF;
     END LOOP;
     IF p_count >= 2 THEN
         p_line_cd   :=  'XX';
     END IF;
  ELSE
     p_line_cd   :=  'XX';
  END IF;
END;
/


