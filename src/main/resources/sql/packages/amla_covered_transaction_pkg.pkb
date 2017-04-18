CREATE OR REPLACE PACKAGE BODY CPI.AMLA_COVERED_TRANSACTION_PKG
AS
   /*
   **  Created by   :  Kenneth Mark Labrador
   **  Date Created : 10.01.2013
   **  Description  : For GIACS116 - AMLA - COvered Transaction Report
   */
   FUNCTION get_amla_details (
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE
   )
      RETURN amla_dtl_tab PIPELINED
   AS
      v_amla_dtl   amla_dtl_type;
   BEGIN
      FOR c IN (SELECT *
                  FROM giac_amla_ext
                 WHERE user_id = p_user_id AND branch_cd = p_branch_cd)
      LOOP
         v_amla_dtl.seq_no := c.seq_no;
         v_amla_dtl.branch_cd := c.branch_cd;
         v_amla_dtl.tran_date := c.tran_date;
         v_amla_dtl.tran_type := c.tran_type;
         v_amla_dtl.ref_no := c.ref_no;
         v_amla_dtl.local_amt := c.local_amt;
         v_amla_dtl.client_type := c.client_type;
         v_amla_dtl.foreign_amt := c.foreign_amt;
         v_amla_dtl.currency_sname := c.currency_sname;
         v_amla_dtl.payor_type := c.payor_type;
         v_amla_dtl.corporate_name := NVL (c.corporate_name, ' ');
         v_amla_dtl.last_name := NVL (c.last_name, ' ');
         v_amla_dtl.first_name := NVL (c.first_name, ' ');
         v_amla_dtl.middle_name := NVL (c.middle_name, ' ');
         v_amla_dtl.address1 := NVL (c.address1, ' ');
         v_amla_dtl.address2 := NVL (c.address2, ' ');
         v_amla_dtl.address3 := NVL (c.address3, ' ');
         v_amla_dtl.birthdate := NVL (c.birthdate, ' ');
             
         v_amla_dtl.policy_no := c.policy_no;
         v_amla_dtl.expiry_date := c.expiry_date;
         v_amla_dtl.eff_date := c.eff_date;            -- added by Mark C 07132015
         v_amla_dtl.tsi_amt := c.tsi_amt; --added by gab 04.08.2016 SR 21922
         v_amla_dtl.fc_tsi_amt := c.fc_tsi_amt; --added by gab 04.08.2016 SR 21922
         PIPE ROW (v_amla_dtl);
      END LOOP;
   END get_amla_details;

   PROCEDURE delete_amla_ext (p_user_id IN giis_users.user_id%TYPE)
   AS
   BEGIN
      DELETE      giac_amla_ext
            WHERE user_id = p_user_id;
   END delete_amla_ext;

   PROCEDURE insert_amla_ext (
      p_from_date    IN       VARCHAR2,
      p_to_date      IN       VARCHAR2,
      --p_tran_class   IN       giac_acctrans.tran_class%TYPE,
      p_user_id      IN       giis_users.user_id%TYPE,
      p_count        OUT      NUMBER,
      p_sum_amount   OUT      NUMBER
   )
   AS
     v_refno_cnt   NUMBER := 0;     -- added by Mark C. 07242015
   BEGIN
      FOR rec IN
         (SELECT *
            FROM TABLE (giacs116_pkg.get_amla_details (TO_DATE (p_from_date,
                                                                'MM-DD-RRRR'
                                                               ),
                                                       TO_DATE (p_to_date,
                                                                'MM-DD-RRRR'
                                                               )
                                                               --, p_tran_class
                                                      )
                       ))
      LOOP
         INSERT INTO giac_amla_ext
                     (seq_no, branch_cd, tran_date,
                      tran_type, ref_no, client_type,
                      local_amt, foreign_amt, currency_sname,
                      payor_type, corporate_name, last_name,
                      first_name, middle_name, address1,
                      address2, address3, birthdate, user_id,
                      last_update, policy_no, expiry_date, eff_date,      -- added by Mark C. 07132015, policy_no, expiry_date, eff_date
                      tsi_amt,fc_tsi_amt --added by gab 04.08.2016 SR 21922
                     )
              VALUES (rec.seq_no, rec.branch_cd, rec.tran_date,
                      rec.tran_type, 
                      --rec.ref_no, 
                      REPLACE(REPLACE(REPLACE(REPLACE(rec.ref_no,'('),')'),'_'),'&'),    -- replaced by Mark C. 07232015 to handle special characters
                      rec.client_type,
                      rec.local_amt, rec.foreign_amt, rec.currency_sname,
                      rec.payor_type, rec.corporate_name, rec.last_name,
                      rec.first_name, rec.middle_name, rec.address1,
                      rec.address2, rec.address3, rec.birthdate, p_user_id,
                      SYSDATE, REPLACE(REPLACE(REPLACE(REPLACE(rec.policy_no,'('),')'),'_'),'&'), 
                      rec.expiry_date, rec.eff_date,       -- added by Mark C. 07132015, rec.policy_no, rec.expiry_date, rec.eff_date
                      rec.tsi_amt, rec.fc_tsi_amt --added by gab 04.08.2016 SR 21922
                     );
      END LOOP;

        COMMIT;
        --Mark C. 07242015, added codes to update duplicate ref_no
        BEGIN
           FOR c_ref IN (SELECT   ref_no, COUNT (seq_no)
                           FROM cpi.giac_amla_ext
                          WHERE user_id = p_user_id
                       GROUP BY ref_no
                         HAVING COUNT (seq_no) > 1)
           LOOP
              FOR c_seq IN (SELECT   seq_no, ref_no
                              FROM cpi.giac_amla_ext
                             WHERE user_id = p_user_id AND ref_no = c_ref.ref_no
                          ORDER BY 1)
              LOOP
                 v_refno_cnt := v_refno_cnt + 1;

                 UPDATE cpi.giac_amla_ext
                    SET ref_no = c_seq.ref_no || '-' || TO_CHAR (v_refno_cnt)
                  WHERE user_id = p_user_id AND seq_no = c_seq.seq_no;
              END LOOP;

              v_refno_cnt := 0;
           END LOOP;
           
           COMMIT;
        END;
      --Mark C. 07242015, add ends
      
      BEGIN
         SELECT SUM (local_amt), MAX (seq_no)
           INTO p_sum_amount, p_count
           FROM giac_amla_ext
          WHERE user_id = p_user_id;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            p_sum_amount := 0;
            p_count := 0;
      END;
   END insert_amla_ext;
END AMLA_COVERED_TRANSACTION_PKG;
/


