DROP PROCEDURE CPI.GET_FIREITEM;

CREATE OR REPLACE PROCEDURE CPI.Get_Fireitem (v_item GIPI_WITEM.item_no%TYPE
                                          ,v_policy_id   GIPI_POLBASIC.policy_id%TYPE
										  ,p_line_cd  GIPI_POLBASIC.line_cd%TYPE
										  ,p_subline_cd GIPI_POLBASIC.subline_cd%TYPE
										  ,p_iss_cd   GIPI_POLBASIC.iss_cd%TYPE
										  ,p_issue_yy GIPI_POLBASIC.issue_yy%TYPE
										  ,p_pol_seq_no GIPI_POLBASIC.pol_seq_no%TYPE
										  ,p_renew_no GIPI_POLBASIC.renew_no%TYPE) IS

   p_eff_date           GIPI_POLBASIC.eff_date%TYPE;
   v_max_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE;
   v_max_endt_seq_no1   GIPI_POLBASIC.endt_seq_no%TYPE;

   CURSOR A IS
      SELECT      a.policy_id policy_id, a.eff_date eff_date
        FROM      GIPI_POLBASIC a
       WHERE      a.line_cd                 =  p_line_cd
         AND      a.iss_cd                  =  p_iss_cd
         AND      a.subline_cd              =  p_subline_cd
         AND      a.issue_yy                =  p_issue_yy
         AND      a.pol_seq_no              =  p_pol_seq_no
         AND      a.renew_no                =  p_renew_no
         AND      a.pol_flag                IN ('1','2','3','4','X')
         AND    EXISTS (SELECT '1'
                          FROM GIPI_FIREITEM b
                         WHERE b.item_no = v_item
                           AND b.policy_id = a.policy_id)
    ORDER BY     eff_date DESC;
   CURSOR B(p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
      SELECT      district_no
                 ,block_no
                 ,block_id
        FROM      GIPI_FIREITEM
       WHERE      policy_id   =  p_policy_id
         AND      item_no     =  v_item;
    CURSOR D IS
       SELECT    a.policy_id policy_id, a.eff_date eff_date
         FROM    GIPI_POLBASIC a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          AND    a.pol_flag    IN( '1','2','3','4','X')
          AND    NVL(a.back_stat,5) = 2
          AND    EXISTS (SELECT '1'
                           FROM GIPI_FIREITEM b
                          WHERE b.item_no = v_item
                            AND a.policy_id = b.policy_id)
          AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                    FROM GIPI_POLBASIC c
                                   WHERE line_cd     =  p_line_cd
                                     AND iss_cd      =  p_iss_cd
                                     AND subline_cd  =  p_subline_cd
                                     AND issue_yy    =  p_issue_yy
                                     AND pol_seq_no  =  p_pol_seq_no
                                     AND renew_no    =  p_renew_no
                                     AND      a.pol_flag                IN ('1','2','3','4','X')
                                     AND NVL(c.back_stat,5) = 2
                                     AND EXISTS (SELECT '1'
                                                   FROM GIPI_FIREITEM d
                                                  WHERE d.item_no = v_item
                                                    AND c.policy_id = d.policy_id))
     ORDER BY   eff_date DESC;

    v_new_item   VARCHAR2(1) := 'Y';
    expired_sw   VARCHAR2(1) := 'N';
BEGIN
   dbms_output.put_line('START');
   FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
              FROM GIPI_POLBASIC a
             WHERE line_cd     =  p_line_cd
               AND iss_cd      =  p_iss_cd
               AND subline_cd  =  p_subline_cd
               AND issue_yy    =  p_issue_yy
               AND pol_seq_no  =  p_pol_seq_no
               AND renew_no    =  p_renew_no
               AND pol_flag  IN( '1','2','3')
               AND EXISTS (SELECT '1'
                             FROM GIPI_FIREITEM b
                            WHERE b.item_no = v_item
                              AND a.policy_id = b.policy_id)) LOOP
      v_max_endt_seq_no := z.endt_seq_no;
      EXIT;
  END LOOP;
  FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
              FROM GIPI_POLBASIC a
             WHERE line_cd     =  p_line_cd
               AND iss_cd      =  p_iss_cd
               AND subline_cd  =  p_subline_cd
               AND issue_yy    =  p_issue_yy
               AND pol_seq_no  =  p_pol_seq_no
               AND renew_no    =  p_renew_no
               AND pol_flag  IN( '1','2','3')
               AND NVL(a.back_stat,5) = 2
               AND EXISTS (SELECT '1'
                             FROM GIPI_FIREITEM b
                            WHERE b.item_no = v_item
                              AND a.policy_id = b.policy_id)) LOOP
      v_max_endt_seq_no1 := x.endt_seq_no;
      EXIT;
  END LOOP;
  IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN
    FOR D1 IN D LOOP
     FOR B1 IN B(D1.policy_id) LOOP
       IF p_eff_date  IS NULL THEN
	      dbms_output.put_line('1-'||TO_CHAR(V_POLICY_ID));
          INSERT INTO GIPI_FIREITEM
                 (policy_id,         item_no,         district_no,
                  block_no,       block_id)
           VALUES(v_policy_id,   v_item,          b1.district_no,
                  b1.block_no, b1.block_id);
       END IF;
       IF D1.eff_date > p_eff_date THEN
	      dbms_output.put_line('2-'||TO_CHAR(V_POLICY_ID));
          INSERT INTO GIPI_FIREITEM
                 (policy_id,         item_no,         district_no,
                  block_no,       block_id)
           VALUES(v_policy_id,   v_item,          b1.district_no,
                  b1.block_no, b1.block_id);
       END IF;
     END LOOP;
     EXIT;
   END LOOP;
  ELSE
   FOR A1 IN A LOOP
     dbms_output.put_line('FOR-A');
     FOR B1 IN B(A1.policy_id) LOOP
       IF p_eff_date  IS NULL THEN
         p_eff_date  :=  A1.eff_date;
		 dbms_output.put_line('3-'||TO_CHAR(V_POLICY_ID));
         INSERT INTO GIPI_FIREITEM
                 (policy_id,         item_no,         district_no,
                  block_no,       block_id)
           VALUES(v_policy_id,   v_item,          b1.district_no,
                  b1.block_no, b1.block_id);
       END IF;
       IF A1.eff_date > p_eff_date THEN
         p_eff_date  :=  A1.eff_date;
		 dbms_output.put_line('4-'||TO_CHAR(V_POLICY_ID));
            INSERT INTO GIPI_FIREITEM
                 (policy_id,         item_no,         district_no,
                  block_no,       block_id)
           VALUES(v_policy_id,   v_item,          b1.district_no,
                  b1.block_no, b1.block_id);
       END IF;
     END LOOP;
     EXIT;
   END LOOP;
 END IF;
 END;
/


