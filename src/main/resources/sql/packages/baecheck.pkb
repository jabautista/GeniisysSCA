CREATE OR REPLACE PACKAGE BODY CPI.Baecheck AS
/*
  Created By: Michaell
  Created On: 11-21-2002
  Remarks   : This is the package body of package BAECHECK. These are the codes for
     the functions that are being used to check the data of the policies to be taken up.

  (Most recent modifications should precede the old modifications
  Modified By: Michaell
  Modified On: 01-13-2003
  Remarks    : Added the checking check_notendttax for the checking of policies not existing
               in gipi_comm_invoice and/or gipi_comm_invperil but are not tax endorsements
*/

FUNCTION check_binder_flag
   (p_date VARCHAR2) RETURN NUMBER AS
   v_exists_frps_k  BOOLEAN := FALSE;
   ctr NUMBER := 0;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_BAD_BINDERS';
   --Loop in the polbasic
   FOR pol IN (
      SELECT policy_id
        FROM GIPI_POLBASIC
       WHERE 1=1
  AND TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') <= TO_DATE(p_date,'MONTH YYYY')-- added lesser than to include previous records : SR-4619 shan 06.16.2015 
         AND ACCT_ENT_DATE IS NULL)                                             -- added to exclude records with acct entries : SR-4619 shan 06.16.2015
   LOOP
      --reset the variable
   v_exists_frps_k := FALSE;
      --select the distinct frps for the negated
   --distribution
   FOR frps IN (SELECT DISTINCT a.fnl_binder_id,a.replaced_flag
                     FROM GIRI_BINDER a,
                          GIRI_FRPS_RI b,
                          GIRI_DISTFRPS c,
                       GIUW_POL_DIST d
                    WHERE 1=1
                      AND a.fnl_binder_id = b.fnl_binder_id
                      AND b.line_cd = c.line_cd
                      AND b.frps_yy = c.frps_yy
                      AND b.frps_seq_no = c.frps_seq_no
                      AND c.dist_no = d.dist_no
                      AND d.policy_id = pol.policy_id
       AND NVL(a.replaced_flag, 'N') <> 'Y' -- added NVL SR-4618 : shan 06.17.2015
                AND a.acc_ent_date IS NOT NULL
                      AND d.dist_flag = '4')
   LOOP
      --MUST CHECK FRPS WHERE DIST IS 3
   FOR frps_k IN (SELECT a.fnl_binder_id
                      FROM GIRI_BINDER a,
                           GIRI_FRPS_RI b,
                           GIRI_DISTFRPS c,
                        GIUW_POL_DIST d
                     WHERE 1=1
                       AND a.fnl_binder_id = b.fnl_binder_id
                       AND b.line_cd = c.line_cd
                       AND b.frps_yy = c.frps_yy
                       AND b.frps_seq_no = c.frps_seq_no
                       AND c.dist_no = d.dist_no
                       AND d.policy_id = pol.policy_id
                       AND a.fnl_binder_id = frps.fnl_binder_id
                       AND d.dist_flag = '3')
         LOOP
      --IF EXISTS THEN THE REPLACED FLAG MAY NOT BE CHECKED
   v_exists_frps_k := TRUE;
      END LOOP; --FRPS_K
         --CHECK HERE IF EXISTS IN DIST = 3
   --IF SO ITS THEN THE REPLACED FLAG MAY NOT BE CHECKED
   IF v_exists_frps_k THEN
      --FNL_BINDER IS OK
   NULL;
      ELSE
                /*Correct the data*/
                UPDATE GIRI_BINDER
                SET replaced_flag = 'Y'
                WHERE fnl_binder_id = frps.fnl_binder_id;

   INSERT INTO GIAC_BATCH_BAD_BINDERS(
                   policy_id, binder_id, old_rep_flag, new_rep_flag)
      VALUES(
                   pol.policy_id,frps.fnl_binder_id,
                   frps.replaced_flag,'Y');
   ctr := ctr + 1;
   END IF;
      END LOOP; --FRPS
   END LOOP; --POL
   COMMIT;
   RETURN(ctr);
END check_binder_flag;

FUNCTION check_comm_prem
   (p_date VARCHAR2) RETURN NUMBER AS
   ctr NUMBER := 0;
   v_new_amt  NUMBER := 0;
   v_prev_amt NUMBER;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_PREM_CHECK';
   FOR c IN (
      SELECT a.iss_cd, a.prem_seq_no, a.prem_amt inv_prem
     FROM  GIPI_INVOICE a, GIPI_POLBASIC b
    WHERE 1=1
   AND TO_DATE(b.booking_mth||' '||b.booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
      AND a.policy_id = b.policy_id)
   LOOP
      --Check in gipi_comm_invoice for that
   FOR m IN (SELECT iss_cd, prem_seq_no, SUM(premium_amt) comm_prem
        FROM GIPI_COMM_INVOICE
       WHERE 1=1
                       AND intrmdry_intm_no >= 0
         AND iss_cd = c.iss_cd
         AND prem_seq_no = c.prem_seq_no
       GROUP BY iss_cd, prem_seq_no)
   LOOP
             --Set the previous amt
             v_prev_amt := m.comm_prem;
      IF c.inv_prem != m.comm_prem THEN
                --Correct the records in gipi_comm_inv_peril
                --and gipi_comm_invoice before inserting the old
                --and the new value
                --
                --For the correction of the data
                --look at the record in gipi_invperil,
                --then set the amount in gipi_comm_invperil,
                --then in gipi_comm_invoice
                FOR shr IN ( SELECT b.iss_cd, b.prem_seq_no,
                                    a.share_percentage, b.intrmdry_intm_no, b.peril_cd,
                                    b.premium_amt, c.prem_amt,c.prem_amt*(a.share_percentage/100) sure_amt
                               FROM GIPI_COMM_INVOICE a, GIPI_COMM_INV_PERIL b, GIPI_INVPERIL c
                              WHERE 1=1
                                AND b.iss_cd = c.iss_cd
                                AND b.prem_seq_no = c.prem_seq_no
                                AND b.peril_cd = c.peril_cd
                                AND a.iss_cd = b.iss_cd
                                AND a.prem_seq_no = b.prem_seq_no
                                AND a.intrmdry_intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = m.iss_cd
                                AND b.prem_seq_no = m.prem_seq_no)
                LOOP
                   IF shr.premium_amt != shr.sure_amt THEN
            --Set the amount in gipi_comm_inv_peril to the sure amount
        UPDATE GIPI_COMM_INV_PERIL
           SET premium_amt = shr.sure_amt
         WHERE iss_cd = shr.iss_cd
           AND prem_seq_no = shr.prem_seq_no
           AND intrmdry_intm_no = shr.intrmdry_intm_no;
            END IF;
                END LOOP; --end loop shr
                --Select the updated amount of gipi_comm_inv_peril
                FOR upd_gci IN (SELECT iss_cd, prem_seq_no, intrmdry_intm_no,
                                       SUM(premium_amt) prem_amt
                                  FROM GIPI_COMM_INV_PERIL
            WHERE 1=1
       AND iss_cd = m.iss_cd
       AND prem_seq_no = m.prem_seq_no
     GROUP BY iss_cd, prem_seq_no, intrmdry_intm_no)
                LOOP
                   --and then set it as the amount in gipi_comm_invoice
                   UPDATE GIPI_COMM_INVOICE
               SET premium_amt = upd_gci.prem_amt
             WHERE 1=1
                      AND iss_cd = upd_gci.iss_cd
        AND prem_seq_no = upd_gci.prem_seq_no
        AND intrmdry_intm_no = upd_gci.intrmdry_intm_no;
                   --Pass the value of the new amount
                   v_new_amt := v_new_amt + upd_gci.prem_amt;
                END LOOP; --end loop upd_gci
  INSERT INTO GIAC_BATCH_PREM_CHECK(
     iss_cd, prem_seq_no, prev_prem_amt, new_prem_amt)
  VALUES(
     m.iss_cd, m.prem_seq_no, v_prev_amt, v_new_amt);
      ctr := ctr + 1;
      END IF;
   END LOOP;  --end loop m
   END LOOP;  -- end loop c
   COMMIT;
   RETURN(ctr);
END check_comm_prem;

FUNCTION check_parent_intm
   RETURN NUMBER AS
   /*This was taken from the script that is used
      to populate the parent_intermediary in
      gipi_comm_invoice*/
   v_share_percentage         GIPI_COMM_INVOICE.share_percentage%TYPE;
   v_intm_no                  GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
   v_parent_intm_no           GIIS_INTERMEDIARY.parent_intm_no%TYPE;
   v_intm_type                GIIS_INTM_TYPE.intm_type%TYPE;
   v_acct_intm_cd             GIIS_INTM_TYPE.acct_intm_cd%TYPE;
   v_lic_tag                  GIIS_INTERMEDIARY.lic_tag%TYPE;
   var_lic_tag                GIIS_INTERMEDIARY.lic_tag%TYPE:='N';
   var_intm_type              GIIS_INTM_TYPE.intm_type%TYPE;
   var_intm_no                GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
   var_parent_intm_no         GIIS_INTERMEDIARY.parent_intm_no%TYPE;
   /*Added to handle the reporting capabilities of batch
     production*/
   ctr NUMBER := 0;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_CHECK_PARENT';
  BEGIN << OUTER >>
     FOR rec IN (SELECT DISTINCT policy_id
                   FROM GIPI_COMM_INVOICE
                  WHERE parent_intm_no IS NULL
                    AND parent_intm_no IS NULL)
     LOOP
        BEGIN << share_percentage >>      -- gets the maximum share percentage
           SELECT MAX(share_percentage)   -- if policy has multiple agent
             INTO v_share_percentage
             FROM GIPI_COMM_INVOICE
            WHERE policy_id = rec.policy_id;
           IF v_share_percentage IS NOT NULL
           THEN
              BEGIN << get_min_intm >>
                 SELECT MIN(intrmdry_intm_no)  -- select the intm_no which
                   INTO v_intm_no              -- has the minumum intm_no
                   FROM GIPI_COMM_INVOICE      -- having the maximum share percentage
                  WHERE share_percentage = v_share_percentage
                    AND policy_id = rec.policy_id;
                 IF v_intm_no IS NULL
                 THEN
                    NULL;
                    DBMS_OUTPUT.PUT_LINE('NO INTERMEDIARY FOUND FOR POLICY'
       ||TO_CHAR(rec.policy_id));
                 END IF;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    DBMS_OUTPUT.PUT_LINE('NO SHARE PERCENTAGE FOUND FOR POLICY                                          '||TO_CHAR(rec.policy_id));
              END get_min_intm;
           ELSE
              DBMS_OUTPUT.PUT_LINE('NO SHARE PERCENTAGE FOUND FOR POLICY         '||TO_CHAR(rec.policy_id));
           END IF;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              DBMS_OUTPUT.PUT_LINE('NO SHARE PERCENTAGE FOUND FOR THIS POLICY');
        END share_percentage;
        BEGIN << license >>
           SELECT parent_intm_no,    -- find out if intm_no is licensed
                  intm_type,         -- or has parent
                  NVL(lic_tag,'N')
             INTO v_parent_intm_no,
                  v_intm_type,
                  v_lic_tag
             FROM GIIS_INTERMEDIARY
            WHERE intm_no = v_intm_no;
           IF v_lic_tag  = 'Y'
           THEN
              v_parent_intm_no := v_intm_no;
           ELSIF v_lic_tag  = 'N'
           THEN
              IF v_parent_intm_no IS NULL
              THEN
                 v_parent_intm_no := v_intm_no;
              ELSE  -- check for the nearest licensed parent intm no --
                 var_lic_tag := v_lic_tag;
                 WHILE var_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL
                 LOOP                            -- loop procedure searches
                    BEGIN << find_out >>         -- the nearest parent which is
                       SELECT intm_no,           -- licensed
                              parent_intm_no,
                              intm_type,
                              lic_tag
                         INTO var_intm_no,
                              var_parent_intm_no,
                              var_intm_type,
                              var_lic_tag
                         FROM GIIS_INTERMEDIARY
                         WHERE intm_no = v_parent_intm_no;
                        v_parent_intm_no := var_parent_intm_no;
                        v_intm_type      := var_intm_type;
                        v_lic_tag        := var_lic_tag;
                        IF var_parent_intm_no IS NULL
                        THEN
                           v_parent_intm_no := var_intm_no;
                           EXIT;
                        ELSE
                           var_lic_tag := 'N';
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_parent_intm_no)||
                                          ' HAS NO_DATA_FOUND IN GIIS INTERMEDIARY');
                           v_parent_intm_no := var_intm_no;
                           EXIT;
                     END find_out;
                  END LOOP;  -- while loop
               END IF;
            END IF;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              DBMS_OUTPUT.PUT_LINE( TO_CHAR(rec.policy_id)|| ' POLICY HAS NO RECORD IN                                        GIIS_INTERMEDIARY.');
              DBMS_OUTPUT.PUT_LINE('INTERMEDIARY ' || TO_CHAR(v_intm_no)|| ' HAS NO RECORD IN     GIIS_INTERMEDIARY.');
              DBMS_OUTPUT.PUT_LINE('INTM TYPE :  ' || var_intm_type);
              DBMS_OUTPUT.PUT_LINE('LIC TAG   :  ' || var_lic_tag);
              DBMS_OUTPUT.PUT_LINE('PARENT_INTM NO :  ' || TO_CHAR(v_parent_intm_no));
        END license;
        BEGIN << acct_intm_cd >>
           SELECT acct_intm_cd
             INTO v_acct_intm_cd
             FROM GIIS_INTM_TYPE
            WHERE intm_type = v_intm_type;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              DBMS_OUTPUT.PUT_LINE( v_intm_type||' HAS NO RECORD IN GIIS_INTM_TYPE.');
        END acct_intm_cd;
        -- do the necessary changes to gipi_comm_invoice
        UPDATE GIPI_COMM_INVOICE
           SET parent_intm_no =   v_parent_intm_no
         WHERE policy_id  =   rec.policy_id;
        --Insert the record in the batch report table
        INSERT INTO GIAC_BATCH_CHECK_PARENT(
           policy_id)
        VALUES(
           rec.policy_id);
        ctr := ctr + 1;
     END LOOP rec;  -- main cursor for loop
  END OUTER;
  COMMIT;
  RETURN(ctr);
END check_parent_intm ;

FUNCTION check_trty_100
    RETURN NUMBER AS
   ctr NUMBER := 0;
   v_exists BOOLEAN := FALSE;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_PANEL_100';
   FOR c IN (SELECT a.line_cd, a.trty_yy, a.trty_seq_no, SUM(a.trty_shr_pct)
               FROM GIIS_TRTY_PANEL a,
                    giis_dist_share b   --added by albert 03242014
              WHERE 1=1
                --added by albert 03242014
                AND a.line_cd = b.line_cd
                AND a.trty_yy = b.trty_yy
                AND a.trty_seq_no = b.share_cd
                AND b.share_type = 2    --should not include XOL
                --end albert 03242014
             HAVING SUM(trty_shr_pct) != 100
              GROUP BY a.line_cd, a.trty_yy, a.trty_seq_no
              UNION -- added to check if treaties have maintained reinsurers : SR-4662 shan 06.16.2015
             SELECT DISTINCT line_cd, trty_yy, share_cd, 0
               FROM giis_dist_share a
              WHERE share_type = 2
                AND (line_cd, trty_yy, share_cd) NOT IN(SELECT line_cd, trty_yy, trty_seq_no
                                                          FROM giis_trty_panel))
   LOOP
      INSERT INTO GIAC_BATCH_PANEL_100(
      line_cd, trty_yy, trty_seq_no)
   VALUES(
      c.line_cd, c.trty_yy, c.trty_seq_no);
      ctr := ctr + 1;
   END LOOP;
   COMMIT;
   RETURN(ctr);
END check_trty_100 ;

FUNCTION check_trty_exists
   (p_date DATE) RETURN NUMBER AS
   ctr NUMBER := 0;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_CHCK_TRTYEXIST';
   FOR c IN (
     SELECT DISTINCT a.line_cd, a.share_cd, 
                     a.peril_cd, b.peril_name, c.trty_name
           FROM giuw_itemperilds_dtl a,
                giis_peril b,
                giis_dist_share c,
                giuw_pol_dist d, 
                gipi_polbasic e
          WHERE 1 = 1
            AND a.line_cd = b.line_cd
            AND a.peril_cd = b.peril_cd
            AND a.line_cd = c.line_cd
            AND a.share_cd = c.share_cd
            AND c.share_type = 2
            AND a.dist_no = d.dist_no
            AND (   (d.dist_flag <> '4' AND d.acct_ent_date IS NULL)
                 OR (    d.dist_flag = '4'
                    AND d.acct_ent_date IS NOT NULL
                    AND d.acct_neg_date IS NULL
                   )
                )
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giis_trty_peril
                    WHERE line_cd = a.line_cd
                      AND trty_seq_no = a.share_cd
                      AND peril_cd = a.peril_cd)
            AND  d.policy_id  =  e.policy_id
            AND TO_DATE((booking_mth||' 01, '||booking_year),'FMMONTH DD, YYYY') 
                       <=  p_date
            AND reg_policy_sw  = 'Y'
               --AND  pol_flag  <>  '5'  -- mildred 07202011 include production date as parameter
)
   LOOP
      INSERT INTO GIAC_BATCH_CHCK_TRTYEXIST(
      line_cd, share_cd, peril_cd,
      peril_name, trty_name)
   VALUES(
      c.line_cd, c.share_cd, c.peril_cd,
      c.peril_name, c.trty_name);
      ctr := ctr + 1;
   END LOOP;
   COMMIT;
   RETURN(ctr);
END check_trty_exists;

FUNCTION check_trty_type
   (p_date DATE) RETURN NUMBER AS
   ctr NUMBER := 0;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_CHECK_TRTYTYPE';
   FOR c IN (
      SELECT line_cd, share_cd
        FROM GIIS_DIST_SHARE
       WHERE share_cd NOT IN (1,999)
         AND acct_trty_type IS NULL
         AND TRUNC(p_date) BETWEEN TRUNC(eff_date) AND TRUNC(expiry_date))
   LOOP
      INSERT INTO GIAC_BATCH_CHECK_TRTYTYPE(
      line_cd, share_cd)
   VALUES(
      c.line_cd, c.share_cd);
   ctr := ctr +1;
   END LOOP;
   COMMIT;
   RETURN(ctr);
END check_trty_type;

FUNCTION check_undist_pol
   (p_date VARCHAR2)  RETURN NUMBER AS
   ctr NUMBER := 0;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_CHECK_UNDIST';
   FOR c IN (SELECT policy_id, Get_Policy_No(policy_id) pol_no
               FROM GIPI_POLBASIC
              WHERE TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
              AND dist_flag = 1)
   LOOP
      INSERT INTO GIAC_BATCH_CHECK_UNDIST(
      policy_id, policy_no)
   VALUES(
      c.policy_id, c.pol_no);
   ctr := ctr + 1;
   END LOOP;
      COMMIT;
      RETURN(ctr);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-200666,'CHECK_UNDIST_POL FUNCTION HAS ENCOUNTERED AN ERROR.');
END check_undist_pol;

FUNCTION check_inv_tax
   (p_date VARCHAR2) RETURN NUMBER AS
   ctr NUMBER := 0;
   v_prev_amt NUMBER := 0;
   v_new_amt  NUMBER := 0;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_TAX_CHECK';
   FOR c IN (SELECT a.iss_cd, a.prem_seq_no, a.tax_amt
               FROM GIPI_INVOICE a, GIPI_POLBASIC c
              WHERE 1=1
                AND c.policy_id = a.policy_id
                AND TO_DATE(c.booking_mth||' '||TO_CHAR(booking_year),'MONTH YYYY') <= TO_DATE(p_date,'MONTH YYYY') -- added lesser than to include previous records : SR-4619 shan 06.16.2015 
                AND a.ACCT_ENT_DATE IS NULL                                             -- added to exclude records with acct entries : SR-4619 shan 06.16.2015
                AND a.tax_amt != (SELECT SUM(b.tax_amt)
                                    FROM GIPI_INV_TAX b
            WHERE 1=1
            AND b.iss_cd = a.iss_cd
         AND b.prem_seq_no = a.prem_seq_no
       GROUP BY b.iss_cd, b.prem_seq_no))
   LOOP
      --Do the data correction
      --update gipi_invoice set the tax amt equal to the total tax in
      --gipi_inv_tax
      v_prev_amt := c.tax_amt;
      FOR m IN (SELECT SUM(b.tax_amt) new_tax
                  FROM GIPI_INV_TAX b
                 WHERE 1=1
                   AND b.iss_cd = c.iss_cd
            AND b.prem_seq_no = c.prem_seq_no
                 GROUP BY b.iss_cd, b.prem_seq_no)
      LOOP
         v_new_amt := m.new_tax;
      END LOOP;
      --Update gipi_invoice to correct the data
      UPDATE GIPI_INVOICE
         SET tax_amt = v_new_amt
       WHERE 1=1
         AND iss_cd = c.iss_cd
         AND prem_seq_no = c.prem_seq_no;
      --Insert the bills that have unequal tax amts in gipi_inv_tax and
      --and gipi_invoice
      INSERT INTO GIAC_BATCH_TAX_CHECK(
      iss_cd, prem_seq_no, prev_tax_amt, new_tax_amt)
   VALUES(
      c.iss_cd, c.prem_seq_no, v_prev_amt, v_new_amt);
   ctr := ctr + 1;
   END LOOP;
   COMMIT;
   RETURN (ctr);
END check_inv_tax;

FUNCTION check_prem_invprl
   (p_date VARCHAR2) RETURN NUMBER AS
   ctr NUMBER := 0;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_PREMINV_CHECK';
   FOR c IN (SELECT a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no
               FROM GIPI_COMM_INVOICE a, GIPI_POLBASIC b
              WHERE 1=1
                AND a.policy_id = b.policy_id
                AND TO_DATE(booking_mth||'-'||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
                AND a.premium_amt != (SELECT SUM(c.premium_amt)
                                        FROM GIPI_COMM_INV_PERIL c
                       WHERE 1=1
                                         AND c.policy_id = a.policy_id
                    AND c.iss_cd = a.iss_cd
                    AND c.prem_seq_no = a.prem_seq_no
                    AND c.intrmdry_intm_no = a.intrmdry_intm_no
                     GROUP BY c.policy_id, c.iss_cd, c.prem_seq_no, c.intrmdry_intm_no))
   LOOP
      INSERT INTO GIAC_BATCH_PREMINV_CHECK(
      iss_cd, prem_seq_no, intrmdry_intm_no)
   VALUES(
      c.iss_cd, c.prem_seq_no, c.intrmdry_intm_no);
   ctr := ctr + 1;
   END LOOP;
   COMMIT;
   RETURN (ctr);
END check_prem_invprl;

FUNCTION check_notendttax
   (p_date VARCHAR2) RETURN NUMBER IS
   ctr NUMBER := 0;
   comm_inv_exs BOOLEAN;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_NOTENDTTAX';
   FOR tax_chck IN (SELECT a.policy_id
                      FROM GIPI_ENDTTEXT c,GIPI_POLBASIC a, GIIS_SUBLINE c
                     WHERE 1=1
                       AND TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
                       AND a.policy_id = c.policy_id
        AND a.line_cd = c.line_cd
        AND a.subline_cd = c.subline_cd
        AND a.pol_flag <> '5' --mikel 11.04.2011; added condition to exclude spoiled endorsements 
        AND c.op_flag != 'Y'
                       AND a.endt_type = 'A'
                       AND NVL(c.endt_tax, 'N') != 'Y'
        AND a.iss_cd <> Giisp.v('ISS_CD_RI'))
   LOOP
      --Set the swithc to false
      comm_inv_exs := FALSE;
      --Check if it does not exist in gipi_comm_invoice
      FOR m IN (SELECT 'X'
                  FROM GIPI_COMM_INVOICE
           WHERE 1=1
          AND policy_id = tax_chck.policy_id)
      LOOP
         comm_inv_exs := TRUE;
      EXIT;
      END LOOP;
      --Insert the policy_id if it does not exists
      IF comm_inv_exs = TRUE THEN
         NULL;
      ELSE
         INSERT INTO GIAC_BATCH_NOTENDTTAX
         (policy_id)
         VALUES
         (tax_chck.policy_id);
        ctr := ctr + 1;
      END IF;
   END LOOP;  --tax_chck end loop
   COMMIT;
   RETURN(ctr);
END check_notendttax;

FUNCTION check_dist_data(
   p_date VARCHAR2) RETURN NUMBER AS
   ctr NUMBER := 0;
BEGIN
   /*This checking incorporates all the checking for the distribution part
     and puts the result in one table GIAC_BATCH_DIST_CHECK
   */
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_DIST_CHECK';
   --1st part: GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL
   FOR m1 IN (SELECT line_cd,subline_cd, iss_cd, issue_yy,
                     pol_seq_no, policy_id
                FROM GIPI_POLBASIC
               WHERE 1=1
                 AND TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
                 AND acct_ent_date IS NULL
                 AND policy_id IN (SELECT policy_id
                                     FROM GIUW_POL_DIST
                                    WHERE dist_flag = '3'
           AND dist_no IN (SELECT DISTINCT a.dist_no
                                                        FROM (SELECT dist_no, dist_seq_no, item_no,
                                                   peril_cd, line_cd,
                                                   NVL(tsi_amt,0) tsi_amt,
                                                   NVL(prem_amt,0) prem_amt
                                              FROM GIUW_ITEMPERILDS) a,
                                              (SELECT dist_no, dist_seq_no, item_no,
                                                   peril_cd, line_cd,
                                                   SUM(NVL(dist_tsi,0)) dist_tsi,
                                                   SUM(NVL(dist_prem,0)) dist_prem
                                              FROM GIUW_ITEMPERILDS_DTL
                                                GROUP BY dist_no, dist_seq_no, item_no,
                                                      peril_cd, line_cd) b
                                     WHERE a.dist_no = b.dist_no
                                       AND a.dist_seq_no = b.dist_seq_no
                                       AND a.item_no = b.item_no
                                       AND a.peril_cd = b.peril_cd
                                       AND a.line_cd = b.line_cd
                                       AND (a.tsi_amt <> b.dist_tsi
                                                              OR a.prem_amt <> b.dist_prem))))
   LOOP
      --Insert the record found into the table
   ctr := ctr + 1;
   INSERT INTO GIAC_BATCH_DIST_CHECK(
      policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,record_class)
      VALUES(
      m1.policy_id, m1.line_cd, m1.subline_cd, m1.iss_cd, m1.issue_yy, m1.pol_seq_no,'GIUW_ITEMPERILDS AND GIUW_ITEMPERILDS_DTL NOT EQUAL');
   END LOOP;
   --2nd part: GIUW_POLICYDS and GIUW_POLICYDS_DTL
   FOR m2 IN (SELECT line_cd,subline_cd, iss_cd, issue_yy,
                     pol_seq_no, policy_id
                FROM GIPI_POLBASIC
               WHERE 1=1
                 AND TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
                 AND acct_ent_date IS NULL
                 AND policy_id IN (SELECT policy_id
                                     FROM GIUW_POL_DIST
                                    WHERE dist_flag = '3'
           AND dist_no IN (SELECT DISTINCT a.dist_no
                                                        FROM (SELECT dist_no, dist_seq_no,
                                                   NVL(tsi_amt,0) tsi_amt,
                                                   NVL(prem_amt,0) prem_amt
                                              FROM GIUW_POLICYDS) a,
                                              (SELECT dist_no, dist_seq_no,
                                                   SUM(NVL(dist_tsi,0)) dist_tsi,
                                                   SUM(NVL(dist_prem,0)) dist_prem
                                              FROM GIUW_POLICYDS_DTL
                                                GROUP BY dist_no, dist_seq_no) b
                                     WHERE a.dist_no = b.dist_no
                                       AND a.dist_seq_no = b.dist_seq_no
                                       AND (a.tsi_amt <> b.dist_tsi
                                           OR a.prem_amt <> b.dist_prem))))
   LOOP
      --Insert the record found into the table
   ctr := ctr + 1;
   INSERT INTO GIAC_BATCH_DIST_CHECK(
      policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,record_class)
      VALUES(
      m2.policy_id, m2.line_cd, m2.subline_cd, m2.iss_cd, m2.issue_yy, m2.pol_seq_no,'GIUW_POLICYDS AND GIUW_POLICYDS_DTL NOT EQUAL');
   END LOOP;
   --3rd Part:GIUW_PERILDS and GIUW_PERILDS_DTL
   FOR m3 IN (SELECT line_cd,subline_cd, iss_cd, issue_yy,
                     pol_seq_no, policy_id
                FROM GIPI_POLBASIC
               WHERE 1=1
                 AND TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
                 AND acct_ent_date IS NULL
                 AND policy_id IN (SELECT policy_id
                                     FROM GIUW_POL_DIST
                                    WHERE dist_flag = '3'
           AND dist_no IN (SELECT DISTINCT a.dist_no
                                                        FROM (SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                                   NVL(tsi_amt,0) tsi_amt,
                                                   NVL(prem_amt,0) prem_amt
                                              FROM GIUW_PERILDS) a,
                                              (SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                                   SUM(NVL(dist_tsi,0)) dist_tsi,
                                                   SUM(NVL(dist_prem,0)) dist_prem
                                              FROM GIUW_PERILDS_DTL
                                                GROUP BY dist_no, dist_seq_no, peril_cd, line_cd) b
                                     WHERE a.dist_no = b.dist_no
                                       AND a.dist_seq_no = b.dist_seq_no
                                       AND a.peril_cd = b.peril_cd
                                       AND a.line_cd = b.line_cd
                                       AND (a.tsi_amt <> b.dist_tsi
                                           OR a.prem_amt <> b.dist_prem))))
   LOOP
      --Insert the record found into the table
   ctr := ctr + 1;
   INSERT INTO GIAC_BATCH_DIST_CHECK(
      policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,record_class)
      VALUES(
      m3.policy_id, m3.line_cd, m3.subline_cd, m3.iss_cd, m3.issue_yy, m3.pol_seq_no,'GIUW_PERILDS AND GIUW_PERILDS_DTL NOT EQUAL');
   END LOOP;
   --4th part: GIUW_ITEMDS and GIUW_ITEMDS_DTL
   FOR m4 IN (SELECT line_cd,subline_cd, iss_cd, issue_yy,
                     pol_seq_no, policy_id
                FROM GIPI_POLBASIC
               WHERE 1=1
                 AND TO_DATE(booking_mth||' '||booking_year,'MONTH YYYY') = TO_DATE(p_date,'MONTH YYYY')
                 AND acct_ent_date IS NULL
                 AND policy_id IN (SELECT policy_id
                                     FROM GIUW_POL_DIST
                                    WHERE dist_flag = '3'
         AND dist_no IN (SELECT DISTINCT a.dist_no
                                                      FROM (SELECT dist_no, dist_seq_no, item_no,
                                                 NVL(tsi_amt,0) tsi_amt,
                                                 NVL(prem_amt,0) prem_amt
                                            FROM GIUW_ITEMDS) a,
                                            (SELECT dist_no, dist_seq_no, item_no,
                                                 SUM(NVL(dist_tsi,0)) dist_tsi,
                                                 SUM(NVL(dist_prem,0)) dist_prem
                                            FROM GIUW_ITEMDS_DTL
                                              GROUP BY dist_no, dist_seq_no, item_no) b
                                   WHERE a.dist_no = b.dist_no
                                     AND a.dist_seq_no = b.dist_seq_no
                                     AND a.item_no = b.item_no
                                     AND (a.tsi_amt <> b.dist_tsi
                                         OR a.prem_amt <> b.dist_prem))))
   LOOP
      --Insert the record found into the table
   ctr := ctr + 1;
   INSERT INTO GIAC_BATCH_DIST_CHECK(
      policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,record_class)
      VALUES(
      m4.policy_id, m4.line_cd, m4.subline_cd, m4.iss_cd, m4.issue_yy, m4.pol_seq_no,'GIUW_ITEMDS AND GIUW_ITEMDS_DTL NOT EQUAL');
   END LOOP;
   COMMIT;
   RETURN(ctr);
END check_dist_data;

FUNCTION check_invcomm_exs(
   p_date VARCHAR2) RETURN NUMBER AS
   ctr NUMBER := 0;
BEGIN
   --truncate the table here
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_INVCOMM_CHECK';
   FOR m1 IN (SELECT a.policy_id, a.iss_cd, a.prem_seq_no, a.prem_amt inv_prem, b.par_id
             FROM GIPI_INVOICE a, GIPI_POLBASIC b
            WHERE 1=1
           AND TO_DATE(b.booking_mth||' '||b.booking_year,'MONTH YYYY') <= TO_DATE(p_date,'MONTH YYYY')  -- added lesser than to include previous records : SR-4619 shan 06.16.2015 
              AND a.ACCT_ENT_DATE IS NULL                                             -- added to exclude records with acct entries : SR-4619 shan 06.16.2015
              AND a.policy_id = b.policy_id
              AND b.iss_cd != 'RI'
            AND a.prem_amt != 0
           AND NOT EXISTS (SELECT 'X'
                             FROM GIPI_COMM_INVOICE c
                   WHERE c.policy_id = b.policy_id))
   LOOP
      --Insert the record
   ctr := ctr + 1;
   INSERT INTO GIAC_BATCH_INVCOMM_CHECK(
      policy_id, iss_cd, prem_seq_no, par_id)
      VALUES(
      m1.policy_id, m1.iss_cd, m1.prem_seq_no, m1.par_id);
   END LOOP;
   COMMIT;
   RETURN(ctr);
END check_invcomm_exs;

FUNCTION check_negated_dist(p_date DATE)
  RETURN NUMBER AS
  ctr  NUMBER := 0;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_NEGATE_CHECK';
  FOR A IN (SELECT a.dist_no, a.policy_id, a.dist_flag, a.negate_date,
                a.acct_neg_date, c.dist_no_new, 
                (SELECT dist_flag
                   FROM giuw_pol_dist
                  WHERE dist_no = c.dist_no_new) dist_flag_new
              FROM giuw_pol_dist a, gipi_polbasic b, giuw_distrel c ,
              GIPI_INVOICE d  -- jhing 08.13.2012 added (integration from seici baecheck) 
             WHERE a.policy_id = b.policy_id
               AND a.dist_no = c.dist_no_old
               --AND    b.pol_flag = '1'   
               AND a.policy_id =d.policy_id -- jhing 08.13.2012 integrated from seici baecheck
               AND b.pol_flag <> '5'    --belle 11112010    
               AND a.dist_flag IN ('4', '5') -- added '5' : SR-4843 shan 08.03.2015
               AND DECODE(d.multi_booking_mm||d.multi_booking_yy, null,null,
                                                                       TO_DATE ((d.multi_booking_mm  || ' 01, ' || d.multi_booking_yy ),      'FMMONTH DD, YYYY'    )) <= p_date --commented out the code below. steven 02.07.2014 - added to handle null values for multi_booking_mm and multi_booking_yy
               --AND TO_DATE ((d.multi_booking_mm  || ' 01, ' || d.multi_booking_yy ),      'FMMONTH DD, YYYY'    ) <= p_date  -- jhing 08.13.2012 - integration from seici baecheck - added to restrict retrieval of records whose booking month is greater than current target booking month for batch
               AND a.acct_ent_date IS NOT NULL
               AND a.dist_no = (SELECT MAX (dist_no)
                                  FROM giuw_pol_dist d
                                 WHERE a.policy_id = d.policy_id 
                                   AND dist_flag IN ('4', '5')) -- added '5' : SR-4843 shan 08.03.2015
               AND EXISTS (SELECT 'x'
                             FROM giuw_pol_dist e
                            WHERE c.dist_no_new = e.dist_no 
               AND dist_flag IN ('1','2')))   -- judyann 07202011; include policies distributed w/ facul 
  LOOP
      ctr := ctr + 1;
 INSERT INTO GIAC_BATCH_NEGATE_CHECK ( dist_no_old, dist_flag_old,
                                       dist_no_new, policy_id,
            negate_date, acct_neg_date,
            dist_flag_new)
    VALUES                              (a.dist_no, a.dist_flag,
                                      a.dist_no_new, a.policy_id,
           a.negate_date, a.acct_neg_date,
           a.dist_flag_new);
  END LOOP;
  COMMIT;	-- SR-4793 : shan 07.20.2015
  RETURN (ctr);
END;

/*
FUNCTION list_of_endorsements(p_date DATE)
  RETURN NUMBER AS
  ctr NUMBER := 0;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_LIST_OF_ENDT';
  FOR A IN (SELECT a.cred_branch, a.policy_id endt_policy_id, Get_Policy_No(a.policy_id) endt_policy_no, f.acct_ent_date endt_acct_ent_date,
                   g.policy_no main_policy_no, g.acct_ent_date main_pol_booking_dt
            FROM   GIPI_POLBASIC a,
                   GIPI_INVOICE f,
                (SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, b.acct_ent_date, Get_Policy_No(a.policy_id) policy_no
                    FROM   GIPI_POLBASIC a,
                           GIPI_INVOICE b
                    WHERE  a.policy_id = b.policy_id
                    AND    a.endt_seq_no = 0) g
            WHERE   1=1
            AND ((f.acct_ent_date IS NOT NULL
            AND a.pol_flag <>  '5'
            AND a.dist_flag = '3')
            OR (a.pol_flag = '5'
            AND f.spoiled_acct_ent_date IS NOT NULL
            AND f.acct_ent_date IS NOT NULL
            AND a.spld_date IS NOT NULL
            AND a.dist_flag = '4'))
            AND a.iss_cd <> 'RI'
            AND a.line_cd <> 'BB'
            AND NVL(a.endt_type, 'A') = 'A'
            AND a.policy_id = f.policy_id
            AND a.line_cd = g.line_cd
            AND a.subline_cd = g.subline_cd
            AND a.iss_cd = g.iss_cd
            AND a.issue_yy = g.issue_yy
            AND a.pol_seq_no = g.pol_seq_no
            AND a.endt_seq_no != 0
            AND NVL(a.endt_type, 'A') = 'A'
            AND a.reg_policy_sw = 'Y'
            AND a.ENDT_SEQ_NO != 0
   AND g.acct_ent_date IS NULL ) LOOP
 ctr := ctr +1;
 INSERT INTO GIAC_BATCH_LIST_OF_ENDT (cred_branch, endt_policy_id,
                                      endt_policy_no, main_policy_no,
           main_pol_booking_dt)
    VALUES                              (a.cred_branch, a.endt_policy_id,
                                      a.endt_policy_no, a.main_policy_no,
           a.main_pol_booking_dt);
  END LOOP;
  RETURN (ctr);
END;
*/

    -- SR-4619 : shan 07.06.2015
    FUNCTION check_null_booking_mth
        RETURN NUMBER
    AS
       ctr NUMBER := 0;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_BATCH_NULL_BOOKINGMTH';
        FOR c IN (SELECT policy_id, Get_Policy_No(policy_id) pol_no
                    FROM GIPI_POLBASIC
                   WHERE booking_mth IS NULL
                     AND spld_flag IN (1,2))
        LOOP
            INSERT INTO GIAC_BATCH_NULL_BOOKINGMTH(policy_id, policy_no)
                 VALUES (c.policy_id, c.pol_no);
                 
            ctr := ctr + 1;
        END LOOP;
        
        COMMIT;
        RETURN(ctr);
    END check_null_booking_mth;
   -- end 07.06.2015

END;
/


