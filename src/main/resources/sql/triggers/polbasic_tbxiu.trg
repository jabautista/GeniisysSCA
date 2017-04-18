DROP TRIGGER CPI.POLBASIC_TBXIU;

CREATE OR REPLACE TRIGGER CPI.POLBASIC_TBXIU
  BEFORE INSERT OR UPDATE
  ON CPI.GIPI_POLBASIC REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
DECLARE
--
-- Generate the next sequence of pol_seq_no per line_cd, subline_cd,
-- iss_cd, issue_yy and renew_no or the next sequence of endt_seq_no per
-- line_cd, subline_cd, iss_cd, issue_yy, renew_no, endt_iss_cd
-- and endt_yy to be use in policy/endorsement creation. Updated the tables
-- below based on the amounts of the policy/endorsement.
--
-- TABLES AFFECTED         TRANSACTION TYPE    COLUMNS
--
-- giis_pol_seq            update/insert    pol_seq_no
--                                 user_id
--                                 last_update
--
-- giis_endt_seq            update/insert    endt_seq_no
--                                 user_id
--                                 last_update
--
-- giin_intm_prod_hdr       update        tsi_amt
--                                    prem_amt
--
-- giin_intm_prod_line_dtl  update        tsi_amt
--                                    prem_amt
--
-- giin_intm_prod_pol_dtl   update        tsi_amt
--                                    prem_amt
--
--
-- giac_aging_totals         update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_summaries     update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_soa_summaries        update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_assd_line     update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_line_totals   update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_soa_details   delete        all
--
  v_par_type        GIPI_PARLIST.par_type%TYPE;
  same_sw           VARCHAR2 (1)                         := 'N';
  p_exist           VARCHAR2 (1)                         := 'N';
  -- for policy
  p_exist1          VARCHAR2 (1)                         := 'N';
  -- for endorsement
  p_exist2          VARCHAR2 (1)                         := 'N';
  -- for assured
  p_exist3          VARCHAR2 (1)                         := 'N';
  -- for issource
  p_pol_seq_no      NUMBER                               := 9999999;
  p_endt_seq_no     NUMBER                               := 999999;
  p_year            NUMBER;
  p_mm              NUMBER;
  p_val             NUMBER;
  p_ind             VARCHAR2 (1)                         := 'N';
  p_prem            GIPI_POLBASIC.prem_amt%TYPE;
  p_tsi             GIPI_POLBASIC.tsi_amt%TYPE;
  p_yr              DATE;
  p_old_tsi         GIPI_POLBASIC.tsi_amt%TYPE           := :OLD.tsi_amt;
  p_old_prem        GIPI_POLBASIC.prem_amt%TYPE          := :OLD.prem_amt;
  p_old_flag        GIPI_POLBASIC.pol_flag%TYPE          := :OLD.pol_flag;
  v_ri              GIIS_PARAMETERS.param_value_v%TYPE;
  v_rb              GIIS_PARAMETERS.param_value_v%TYPE;
  v_gif             GIIS_PARAMETERS.param_value_v%TYPE;
  v_gr              GIIS_PARAMETERS.param_value_v%TYPE;
  v_iss_cd          GIPI_POLBASIC.iss_cd%TYPE;
  v_prem_seq_no     GIPI_INVOICE.prem_seq_no%TYPE;
  v_assd_no         GIPI_PARLIST.assd_no%TYPE;
  /*ppmk*/
  v_line_cd_sw      VARCHAR2 (1)                         := 'Y';
  v_subline_cd_sw   VARCHAR2 (1)                         := 'Y';
  v_iss_cd_sw       VARCHAR2 (1)                         := 'Y';
  v_issue_yy_sw     VARCHAR2 (1)                         := 'Y';
   -- jhing REPUBLICFULLWEB 21977 -- added new variables 
  v_correct_iss_yy  gipi_polbasic.issue_yy%TYPE ;      
  v_msg_out         VARCHAR2(5) := NULL ;    
  v_booking_mth     gipi_polbasic.booking_mth%TYPE;
  v_booking_year    gipi_polbasic.booking_year%TYPE ; 
  v_incept_date     gipi_polbasic.incept_date%TYPE;
  v_issue_date      gipi_polbasic.issue_date%TYPE;                  
  
BEGIN
  p_exist := 'N';
  p_exist1 := 'N';
  same_sw := 'N';
  :NEW.user_id := NVL (giis_users_pkg.app_user, USER); -- andrew 07.20.2011 - use the application user (geniisys web), if null use the database user 

  FOR a IN (SELECT par_type
              FROM GIPI_PARLIST
             WHERE par_id = :NEW.par_id) LOOP
    v_par_type := a.par_type;
    EXIT;
  END LOOP;

  IF ((v_par_type = 'P') AND (INSERTING) AND (:NEW.pack_policy_id IS NULL))
                                                                           -- petermkaw 04282010
                                                                           -- added :NEW.pack_policy_id IS NOT NULL condition to execute only if
                                                                           -- the policy to be inserted is not from a package policy.
                                                                           -- will not be called in package policies!
  THEN
    --BETH 102299 for renewal which will use same policy no
    --            by pass extract and update of pol_seq_no
    FOR renew IN (SELECT '1'
                    FROM GIPI_WPOLBAS
                   WHERE par_id = :NEW.par_id AND NVL (same_polno_sw, 'N') = 'Y' AND NVL (pol_flag, '1') IN ('2', '3')) LOOP
      same_sw := 'Y';
    END LOOP;

    IF same_sw = 'N' THEN        
       
       -- jhing REPUBLICFULLWEB 21977 added code to setup issue year before record pol_seq_no is set 
       Get_Issue_Yy_Gipis002(:NEW.booking_mth, :NEW.booking_year, TO_CHAR (:NEW.incept_date,'MM-DD-YYYY'), TO_CHAR (:NEW.issue_date, 'MM-DD-YYYY'), v_correct_iss_yy, v_msg_out ) ; 
       
       IF NVL(v_msg_out,'N') = 'Y' THEN       
         RAISE_APPLICATION_ERROR (-20010, 'Error in generating the issue year for the policy.', TRUE); 
       ELSE
         :NEW.issue_yy := v_correct_iss_yy ; 
       END IF; 
       -- jhing REPUBLICFULLWEB 21977 end of added code 
       
      /*this was commented out and replaced with the package
        PACKAGE_POSTING_PKG by petermkaw 03/24/2011 */
      /*
      FOR a1 IN (SELECT        pol_seq_no, ROWID
                          FROM giis_pol_seq
                         WHERE line_cd = :NEW.line_cd
                           AND subline_cd = :NEW.subline_cd
                           AND iss_cd = :NEW.iss_cd
                           AND issue_yy = :NEW.issue_yy
                 -- removed 02/09/2001 by rbd
                         -- AND renew_no   =  :NEW.renew_no
                 FOR UPDATE OF pol_seq_no) LOOP
        IF a1.pol_seq_no < p_pol_seq_no THEN
          :NEW.pol_seq_no := a1.pol_seq_no + 1;

          UPDATE giis_pol_seq
             SET pol_seq_no = :NEW.pol_seq_no,
                 user_id = :NEW.user_id,
                 last_update = :NEW.last_upd_date
           WHERE ROWID = a1.ROWID;

          p_exist := 'Y';
        ELSE
          :NEW.pol_seq_no := 1;

          UPDATE giis_pol_seq
             SET pol_seq_no = 1,
                 user_id = :NEW.user_id,
                 last_update = :NEW.last_upd_date
           WHERE ROWID = a1.ROWID;

          p_exist := 'Y';
        END IF;
      END LOOP;
      */
      
      /*petermkaw 03/23/2011
        added to accomodate giis_company_seq beginaa */
      package_posting_pkg.get_company_pol_seq ('P', :NEW.line_cd, :NEW.subline_cd, :NEW.iss_cd, :NEW.issue_yy , :NEW.user_id,  
                                               :NEW.last_upd_date, :NEW.pol_seq_no, p_exist);

      --endaa      
      IF p_exist = 'N' THEN
        :NEW.pol_seq_no := 1;

        INSERT INTO GIIS_POL_SEQ
                    (line_cd, iss_cd, issue_yy, subline_cd, pol_seq_no, renew_no, user_id,
                     last_update)
             VALUES (:NEW.line_cd, :NEW.iss_cd, :NEW.issue_yy, :NEW.subline_cd, :NEW.pol_seq_no, :NEW.renew_no, :NEW.user_id,  
                     :NEW.last_upd_date);
      END IF;
    END IF;
  ELSIF ((v_par_type = 'E') AND (INSERTING) AND (:NEW.pack_policy_id IS NULL))
                                                                              -- petermkaw 04282010
                                                                              -- added :NEW.pack_policy_id IS NOT NULL condition to execute only if
                                                                              -- the policy to be inserted is not from a package policy.
                                                                              -- will not be called in package policies!
  THEN
    FOR a1 IN (SELECT MAX (endt_seq_no) endt_seq_no
                 FROM GIIS_ENDT_SEQ
                WHERE line_cd = :NEW.line_cd
                  AND subline_cd = :NEW.subline_cd
                  AND iss_cd = :NEW.iss_cd
                  AND issue_yy = :NEW.issue_yy
                  AND pol_seq_no = :NEW.pol_seq_no
                  AND renew_no = :NEW.renew_no
                  AND endt_iss_cd = :NEW.endt_iss_cd) LOOP
      FOR a2 IN (SELECT        endt_seq_no, ROWID
                          FROM GIIS_ENDT_SEQ
                         WHERE line_cd = :NEW.line_cd
                           AND subline_cd = :NEW.subline_cd
                           AND iss_cd = :NEW.iss_cd
                           AND issue_yy = :NEW.issue_yy
                           AND pol_seq_no = :NEW.pol_seq_no
                           AND renew_no = :NEW.renew_no
                           AND endt_iss_cd = :NEW.endt_iss_cd
                           AND endt_yy = :NEW.endt_yy
                 FOR UPDATE OF endt_seq_no) LOOP
--       IF A2.ENDT_SEQ_NO < p_endt_seq_no THEN
        :NEW.endt_seq_no := a1.endt_seq_no + 1;

        UPDATE GIIS_ENDT_SEQ
           SET endt_seq_no = :NEW.endt_seq_no,
               user_id = :NEW.user_id,
               last_update = :NEW.last_upd_date
         WHERE ROWID = a2.ROWID;

        p_exist1 := 'Y';
--        ELSE
--          :NEW.endt_seq_no  := A1.endt_seq_no + 1;
--          UPDATE giis_endt_seq
--             SET endt_seq_no  = :NEW.endt_seq_no,
--                 user_id      = :NEW.user_id,
--                 last_update  = :NEW.last_upd_date
--           WHERE rowid        =  A2.rowid;
--          p_exist1 := 'Y';
--        END IF;
        EXIT;
      END LOOP;

      IF p_exist1 = 'N' THEN
        :NEW.endt_seq_no := NVL (a1.endt_seq_no, 0) + 1;

        INSERT INTO GIIS_ENDT_SEQ
                    (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                     endt_iss_cd, endt_yy, endt_seq_no, user_id, last_update)
             VALUES (:NEW.line_cd, :NEW.subline_cd, :NEW.iss_cd, :NEW.issue_yy, :NEW.pol_seq_no, :NEW.renew_no,
                     :NEW.endt_iss_cd, :NEW.endt_yy, :NEW.endt_seq_no, :NEW.user_id, :NEW.last_upd_date);

        p_exist1 := 'Y';
      END IF;

      EXIT;
    END LOOP;

    IF p_exist1 = 'N' THEN
      :NEW.endt_seq_no := 1;

      INSERT INTO GIIS_ENDT_SEQ
                  (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd,
                   endt_yy, endt_seq_no, user_id, last_update)
           VALUES (:NEW.line_cd, :NEW.subline_cd, :NEW.iss_cd, :NEW.issue_yy, :NEW.pol_seq_no, :NEW.renew_no, :NEW.endt_iss_cd,
                   :NEW.endt_yy, 1, :NEW.user_id, :NEW.last_upd_date);
    END IF;
  ELSIF ((INSERTING) AND (:NEW.pack_policy_id IS NOT NULL)) THEN
    --petermkaw 03/24/2011
    --added third elsif condition containing (inserting) and
    --(:new.pack_policy_id is not null) for sequence update.
    --will only be called for package policies! this is in reference
    --to package_posting_pkg.get_pkg_pol_seq database package.
    FOR pk IN (SELECT   pol_seq_no, endt_seq_no, ROWID
                   FROM GIIS_PACK_POL_SEQ_TEMP
                  WHERE par_id = :NEW.par_id
               ORDER BY pol_seq_no DESC) LOOP
      :NEW.pol_seq_no := pk.pol_seq_no;
      :NEW.endt_seq_no := pk.endt_seq_no;
      EXIT;
    END LOOP;
  END IF;

  /* Determine IF record exists for giac_parameters which identifies which date
    ** should be used in populating the GIIN inquiry tables.
    */
  BEGIN
    SELECT param_value_n
      INTO p_val
      FROM GIIS_PARAMETERS
     WHERE param_name = 'EIM_DAILY_TAKE_UP';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20010, 'CANNOT FIND PARAMETER EIM_DAILY_TAKE_UP; PLEASE DO NECESSARY CHANGES!', TRUE);
  END;

  /******* Pol_stat = 5 is spoiled *******/
  IF p_val IN (1, 3) THEN
    p_yr := NVL (:NEW.issue_date, SYSDATE);
  ELSIF p_val IN (2, 4) THEN
    IF NVL (:NEW.issue_date, SYSDATE) < NVL (:NEW.incept_date, SYSDATE) THEN
      p_yr := NVL (:NEW.incept_date, SYSDATE);
    ELSE
      p_yr := NVL (:NEW.issue_date, SYSDATE);
    END IF;
  ELSE
    IF :NEW.booking_mth IS NULL OR :NEW.booking_year IS NULL THEN
      IF NVL (:NEW.issue_date, SYSDATE) < NVL (:NEW.incept_date, SYSDATE) THEN
        p_yr := NVL (:NEW.incept_date, SYSDATE);
      ELSE
        p_yr := NVL (:NEW.issue_date, SYSDATE);
      END IF;
    ELSE
      p_yr := NULL;
    END IF;
  END IF;

  IF p_yr IS NULL THEN
    p_year := :NEW.booking_year;
    Repl_Booking_Mth (:NEW.booking_mth, p_mm);
  ELSE
    p_year := TO_NUMBER (TO_CHAR (p_yr, 'YYYY'));
    p_mm := TO_NUMBER (TO_CHAR (p_yr, 'MM'));
  END IF;

  FOR assd IN (SELECT assd_no
                 FROM GIPI_PARLIST
                WHERE par_id = :NEW.par_id) LOOP
    v_assd_no := assd.assd_no;
  END LOOP;

  /******** For giin_assd_prod_hdr **********/
  FOR hdr IN (SELECT assd_no, uw_year, tsi_amt, prem_amt, ROWID
                FROM GIIN_ASSD_PROD_HDR
               WHERE assd_no = v_assd_no AND uw_mm = p_mm AND uw_year = p_year) LOOP
    p_exist2 := 'Y';

    IF :NEW.pol_flag != '5' THEN
      p_tsi := NVL (hdr.tsi_amt, 0) + NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) + NVL (:NEW.prem_amt, 0);
    ELSE
      p_tsi := NVL (hdr.tsi_amt, 0) - NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) - NVL (:NEW.prem_amt, 0);
    END IF;

    IF (INSERTING OR (UPDATING AND (p_old_tsi != :NEW.tsi_amt OR p_old_prem != :NEW.prem_amt OR :NEW.pol_flag = '5'))) THEN
      /*UPDATE    giin_assd_prod_hdr
         SET    tsi_amt  =  NVL(p_tsi,0),
                prem_amt =  NVL(p_prem,0)
       WHERE    ROWID    =  hdr.ROWID;*/
      NULL;
    END IF;

    EXIT;
  END LOOP;

  IF p_exist2 = 'N' THEN
    /*INSERT INTO   giin_assd_prod_hdr
       (assd_no,   uw_year, tsi_amt,
        prem_amt,  uw_mm)
    VALUES
       (v_assd_no, p_year,  NVL(:NEW.tsi_amt,0),
        NVL(:NEW.prem_amt,0), p_mm);*/
    NULL;
  END IF;

  p_exist2 := 'N';

  /******** For giin_iss_prod_hdr **********/
  FOR hdr IN (SELECT iss_cd, uw_year, tsi_amt, prem_amt, ROWID
                FROM GIIN_ISS_PROD_HDR
               WHERE iss_cd = :NEW.iss_cd AND assd_no = v_assd_no AND uw_mm = p_mm AND uw_year = p_year) LOOP
    p_exist3 := 'Y';

    IF :NEW.pol_flag != '5' THEN
      p_tsi := NVL (hdr.tsi_amt, 0) + NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) + NVL (:NEW.prem_amt, 0);
    ELSE
      p_tsi := NVL (hdr.tsi_amt, 0) - NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) - NVL (:NEW.prem_amt, 0);
    END IF;

    IF (INSERTING OR (UPDATING AND (p_old_tsi != :NEW.tsi_amt OR p_old_prem != :NEW.prem_amt OR :NEW.pol_flag = '5'))) THEN
      /*UPDATE    giin_iss_prod_hdr
         SET    tsi_amt  =  NVL(p_tsi,0),
                prem_amt =  NVL(p_prem,0)
       WHERE    ROWID    =  hdr.ROWID;*/
      NULL;
    END IF;

    EXIT;
  END LOOP;

  IF p_exist3 = 'N' THEN
    /*INSERT INTO   giin_iss_prod_hdr
       (iss_cd,   uw_year, tsi_amt,
        prem_amt, uw_mm,   assd_no)
    VALUES
       (:NEW.iss_cd, p_year,  NVL(:NEW.tsi_amt,0),
        NVL(:NEW.prem_amt,0), p_mm, v_assd_no);*/
    NULL;
  END IF;

  p_exist3 := 'N';

  /********* For giin_assd_prod_line_dtl **********/
  FOR hdr IN (SELECT assd_no, uw_year, uw_mm, tsi_amt, prem_amt, ROWID
                FROM GIIN_ASSD_PROD_LINE_DTL
               WHERE assd_no = v_assd_no AND uw_year = p_year AND uw_mm = p_mm AND line_cd = :NEW.line_cd) LOOP
    p_exist2 := 'Y';

    IF :NEW.pol_flag != '5' THEN
      p_tsi := NVL (hdr.tsi_amt, 0) + NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) + NVL (:NEW.prem_amt, 0);
    ELSE
      p_tsi := NVL (hdr.tsi_amt, 0) - NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) - NVL (:NEW.prem_amt, 0);
    END IF;

    IF (INSERTING OR (UPDATING AND (p_old_tsi != :NEW.tsi_amt OR p_old_prem != :NEW.prem_amt OR :NEW.pol_flag = '5'))) THEN
      /*UPDATE    giin_assd_prod_line_dtl
         SET    tsi_amt  =  NVL(p_tsi,0),
                prem_amt =  NVL(p_prem,0)
       WHERE    ROWID    =  hdr.ROWID;*/
      NULL;
    END IF;

    EXIT;
  END LOOP;

  IF p_exist2 = 'N' THEN
    /*INSERT INTO   giin_assd_prod_line_dtl
        (assd_no,      uw_year,      line_cd,
         tsi_amt,      prem_amt,     uw_mm)
    VALUES
        (v_assd_no,    p_year,       :NEW.line_cd,
        NVL(:NEW.tsi_amt,0),  NVL(:NEW.prem_amt,0), p_mm );*/
    NULL;
  END IF;

  p_exist2 := 'N';

  /********** For giin_assd_prod_pol_dtl ***********/
  FOR hdr IN (SELECT assd_no, uw_year, tsi_amt, prem_amt, ROWID
                FROM GIIN_ASSD_PROD_POL_DTL
               WHERE assd_no = v_assd_no
                 AND uw_year = p_year
                 AND uw_mm = p_mm
                 AND line_cd = :NEW.line_cd
                 AND subline_cd = :NEW.subline_cd
                 AND iss_cd = :NEW.iss_cd
                 AND issue_yy = :NEW.issue_yy
                 AND pol_seq_no = :NEW.pol_seq_no
                 AND renew_no = :NEW.renew_no) LOOP
    p_exist2 := 'Y';

    IF :NEW.pol_flag != '5' THEN
      p_tsi := NVL (hdr.tsi_amt, 0) + NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) + NVL (:NEW.prem_amt, 0);
    ELSE
      p_tsi := NVL (hdr.tsi_amt, 0) - NVL (:NEW.tsi_amt, 0);
      p_prem := NVL (hdr.prem_amt, 0) - NVL (:NEW.prem_amt, 0);
    END IF;

    IF (INSERTING OR (UPDATING AND (p_old_tsi != :NEW.tsi_amt OR p_old_prem != :NEW.prem_amt OR :NEW.pol_flag = '5'))) THEN
      /*UPDATE    giin_assd_prod_pol_dtl
         SET    tsi_amt  =  NVL(p_tsi,0),
                prem_amt =  NVL(p_prem,0)
       WHERE    ROWID    =  hdr.ROWID;*/
      NULL;
    END IF;

    EXIT;
  END LOOP;

  IF p_exist2 = 'N' THEN
    /*INSERT INTO   giin_assd_prod_pol_dtl
           (record_id,        assd_no,         uw_year,
            line_cd,          subline_cd,      iss_cd,
            issue_yy,         pol_seq_no,      tsi_amt,
            prem_amt,         renew_no,        inception_dt,
            expiry_dt,        renewed_tag,     uw_mm)
    VALUES (1,                v_assd_no,       p_year,
            :NEW.line_cd,     :NEW.subline_cd, :NEW.iss_cd,
            :NEW.issue_yy,    :NEW.pol_seq_no, NVL(:NEW.tsi_amt,0),
            NVL(:NEW.prem_amt,0),    :NEW.renew_no,   :NEW.incept_date,
            :NEW.expiry_date, 'N',             p_mm);*/
    NULL;
  END IF;

  p_exist2 := 'N';

  --Dagdag po muna para lang maiwasan ang laging pagtagpo ng napakabagal na part na to
  --Michaell 04042003
  IF :NEW.tsi_amt != :OLD.tsi_amt OR :NEW.prem_amt != :OLD.prem_amt OR :NEW.pol_flag = '5' THEN
    /********** For giin_prod_item_dtl ***********/
    FOR hdr IN (SELECT item_no, tsi_amt, prem_amt, ROWID
                  FROM GIIN_PROD_ITEM_DTL
                 WHERE line_cd = :NEW.line_cd
                   AND subline_cd = :NEW.subline_cd
                   AND iss_cd = :NEW.iss_cd
                   AND issue_yy = :NEW.issue_yy
                   AND pol_seq_no = :NEW.pol_seq_no
                   AND renew_no = :NEW.renew_no) LOOP
      FOR itm IN (SELECT tsi_amt, prem_amt
                    FROM GIPI_ITEM
                   WHERE policy_id = :NEW.policy_id AND item_no = hdr.item_no) LOOP
        IF :NEW.pol_flag = '5' THEN
          p_tsi := NVL (hdr.tsi_amt, 0) - NVL (itm.tsi_amt, 0);
          p_prem := NVL (hdr.prem_amt, 0) - NVL (itm.prem_amt, 0);
          /*UPDATE giin_prod_item_dtl
             SET tsi_amt  =  NVL(p_tsi,0),
                 prem_amt =  NVL(p_prem,0)
           WHERE line_cd    =  :NEW.line_cd
             AND subline_cd =  :NEW.subline_cd
             AND iss_cd     =  :NEW.iss_cd
             AND issue_yy   =  :NEW.issue_yy
             AND pol_seq_no =  :NEW.pol_seq_no
             AND renew_no   =  :NEW.renew_no
             AND item_no    =  hdr.item_no;*/
          NULL;
        END IF;
      END LOOP;
    END LOOP;
  END IF;   --End ng nilagay ni Mike

  --
  IF :NEW.pol_flag = '5' THEN
    BEGIN
      FOR inv IN (SELECT intrmdry_intm_no, share_percentage, premium_amt
                    FROM GIPI_COMM_INVOICE
                   WHERE policy_id = :NEW.policy_id) LOOP
        /******** For giin_intm_prod_hdr **********/
        FOR intm IN (SELECT tsi_amt, prem_amt, ROWID
                       FROM GIIN_INTM_PROD_HDR
                      WHERE intm_no = inv.intrmdry_intm_no AND uw_mm = p_mm AND uw_year = p_year) LOOP
          p_tsi := NVL (intm.tsi_amt, 0) - ROUND (NVL (:NEW.tsi_amt, 0) * (inv.share_percentage / 100), 2);
          p_prem := NVL (intm.prem_amt, 0) - NVL (inv.premium_amt, 0);
          /*UPDATE giin_intm_prod_hdr
             SET tsi_amt  =  NVL(p_tsi,0),
                 prem_amt =  NVL(p_prem,0)
           WHERE ROWID    =  intm.ROWID;*/
          NULL;
          EXIT;
        END LOOP;

        /******** For giin_intm_prod_line_dtl **********/
        FOR LINE IN (SELECT tsi_amt, prem_amt, ROWID
                       FROM GIIN_INTM_PROD_LINE_DTL
                      WHERE line_cd = :NEW.line_cd AND intm_no = inv.intrmdry_intm_no AND uw_year = p_year) LOOP
          p_tsi := NVL (LINE.tsi_amt, 0) - ROUND (NVL (:NEW.tsi_amt, 0) * (inv.share_percentage / 100), 2);
          p_prem := NVL (LINE.prem_amt, 0) - NVL (inv.premium_amt, 0);
          /*UPDATE giin_intm_prod_line_dtl
             SET tsi_amt  =  NVL(p_tsi,0),
                 prem_amt =  NVL(p_prem,0)
           WHERE ROWID    =  line.ROWID;*/
          NULL;
          EXIT;
        END LOOP;

        /******** For giin_intm_prod_pol_dtl **********/
        FOR pol IN (SELECT tsi_amt, prem_amt, ROWID
                      FROM GIIN_INTM_PROD_POL_DTL
                     WHERE intm_no = inv.intrmdry_intm_no
                       AND uw_year = p_year
                       AND uw_mm = p_mm
                       AND line_cd = :NEW.line_cd
                       AND subline_cd = :NEW.subline_cd
                       AND iss_cd = :NEW.iss_cd
                       AND issue_yy = :NEW.issue_yy
                       AND pol_seq_no = :NEW.pol_seq_no) LOOP
          p_tsi := NVL (pol.tsi_amt, 0) - ROUND (NVL (:NEW.tsi_amt, 0) * (inv.share_percentage / 100), 2);
          p_prem := NVL (pol.prem_amt, 0) - NVL (inv.premium_amt, 0);
          /*UPDATE giin_intm_prod_pol_dtl
             SET tsi_amt  =  NVL(p_tsi,0),
                 prem_amt =  NVL(p_prem,0)
           WHERE ROWID    =  pol.ROWID;*/
          NULL;
          EXIT;
        END LOOP;
      END LOOP;
    END;

    /* For update of giac_aging_soa_details &
    ** giac_aging_ri_soa_details
    */
    BEGIN
      FOR x IN (SELECT param_name, param_value_v
                  FROM GIIS_PARAMETERS
                 WHERE param_name IN ('RI', 'RB', 'ACCTG_FOR_FUND_CODE', 'ACCTG_ISS_CD_GR')) LOOP
        IF x.param_name = 'RI' THEN
          v_ri := x.param_value_v;
        ELSIF x.param_name = 'RB' THEN
          v_rb := x.param_value_v;
        /* Parameter used to identIFy the fund code used for acctg
        */
        ELSIF x.param_name = 'ACCTG_FOR_FUND_CODE' THEN
          v_gif := x.param_value_v;
        /* Parameter used to identIFy specIFic accounting iss_cds
        ** for report use.
        */
        ELSIF x.param_name = 'ACCTG_ISS_CD_GR' THEN
          v_gr := x.param_value_v;
        END IF;
      END LOOP;

      IF v_ri IS NULL THEN
        RAISE_APPLICATION_ERROR (-20010, 'PARAMETER RI DOES NOT EXIST IN GIAC PARAMETERS.', TRUE);
      END IF;

      IF v_rb IS NULL THEN
        RAISE_APPLICATION_ERROR (-20010, 'PARAMETER RB DOES NOT EXIST IN GIAC PARAMETERS.', TRUE);
      END IF;

      IF v_gif IS NULL THEN
        RAISE_APPLICATION_ERROR (-20010, 'PARAMETER ACCTG_FOR_FUND_CODE DOES NOT EXIST IN GIAC PARAMETERS.', TRUE);
      END IF;

      IF v_gr IS NULL THEN
        RAISE_APPLICATION_ERROR (-20010, 'PARAMETER ACCTG_ISS_CD_GR DOES NOT EXIST IN GIAC PARAMETERS.',                           TRUE);
      END IF;

      ---
      DECLARE
        CURSOR a IS
          SELECT iss_cd, prem_seq_no
            FROM GIPI_INVOICE
           WHERE policy_id = :OLD.policy_id;

        --
        CURSOR b (v_iss_cd GIPI_POLBASIC.iss_cd%TYPE, v_prem_seq_no GIPI_INVOICE.prem_seq_no%TYPE) IS
          SELECT gagp_aging_id, balance_amt_due, prem_balance_due, tax_balance_due
            FROM GIAC_AGING_SOA_DETAILS
           WHERE iss_cd = v_iss_cd AND prem_seq_no = v_prem_seq_no;
      BEGIN
        FOR a_rec IN a LOOP
          v_iss_cd := a_rec.iss_cd;
          v_prem_seq_no := a_rec.prem_seq_no;

          IF :NEW.iss_cd IN (v_ri, v_gr, v_rb) THEN
            DELETE FROM GIAC_AGING_RI_SOA_DETAILS
                  WHERE prem_seq_no = a_rec.prem_seq_no;
          ELSE
--
-- Commented by Loth 072500
-- Attached codings to trigger aging_soa_tbdix
--
--                  FOR B_REC IN B (a_rec.iss_cd, a_rec.prem_seq_no)
--                  LOOP
--                    UPDATE giac_aging_totals
--                      SET balance_amt_due  = balance_amt_due  - b_rec.balance_amt_due,
--                          prem_balance_due = prem_balance_due - b_rec.prem_balance_due,
--                          tax_balance_due  = tax_balance_due  - b_rec.tax_balance_due
--                    WHERE gagp_aging_id  = b_rec.gagp_aging_id;
                    --
--                    UPDATE giac_aging_summaries
--                       SET balance_amt_due  = balance_amt_due  - b_rec.balance_amt_due,
--                           prem_balance_due = prem_balance_due - b_rec.prem_balance_due,
--                           tax_balance_due  = tax_balance_due  - b_rec.tax_balance_due
--                     WHERE gagp_aging_id  = b_rec.gagp_aging_id
--                       AND a020_assd_no   = :OLD.assd_no;
                    --
--                    UPDATE giac_soa_summaries
--                       SET balance_amt_due  = balance_amt_due  - b_rec.balance_amt_due,
--                           prem_balance_due = prem_balance_due - b_rec.prem_balance_due,
--                           tax_balance_due  = tax_balance_due  - b_rec.tax_balance_due
--                     WHERE a020_assd_no   = :OLD.assd_no;
                    --
--                    UPDATE giac_aging_assd_line
--                       SET balance_amt_due  = balance_amt_due  - b_rec.balance_amt_due,
--                           prem_balance_due = prem_balance_due - b_rec.prem_balance_due,
--                           tax_balance_due  = tax_balance_due  - b_rec.tax_balance_due
--                     WHERE gagp_aging_id  = b_rec.gagp_aging_id
--                       AND a150_line_cd   = :OLD.line_cd
--                       AND a020_assd_no   = :OLD.assd_no;
                    --
--                    UPDATE giac_aging_line_totals
--                       SET balance_amt_due  = balance_amt_due  - b_rec.balance_amt_due,
--                           prem_balance_due = prem_balance_due - b_rec.prem_balance_due,
--                           tax_balance_due  = tax_balance_due  - b_rec.tax_balance_due
--                     WHERE gagp_aging_id  = b_rec.gagp_aging_id
--                       AND a150_line_cd   = :OLD.line_cd;
--                  END LOOP;
--
-- End of Comments
--
                  --
            DELETE FROM GIAC_AGING_FC_SOA_DETAILS
                  WHERE iss_cd = a_rec.iss_cd AND prem_seq_no = a_rec.prem_seq_no;

            DELETE FROM GIAC_AGING_SOA_DETAILS
                  WHERE iss_cd = a_rec.iss_cd AND prem_seq_no = a_rec.prem_seq_no;
          END IF;
        END LOOP;
      END;
    END;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR (-20203, 'sqlcode = ' || SQLCODE || ', SQLERRM = ' || SQLERRM || ',');
END;
/


