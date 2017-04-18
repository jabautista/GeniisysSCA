CREATE OR REPLACE PACKAGE BODY CPI.Upload_Dpc AS

  PROCEDURE set_fixed_variables (
     p_fund_cd   VARCHAR2
    ,p_branch_cd VARCHAR2
    ,p_evat_cd   NUMBER
    ) IS

  BEGIN
    pvar_fund_cd := p_fund_cd;
    pvar_branch_cd := p_branch_cd;
    pvar_evat_cd := p_evat_cd;
  END set_fixed_variables;


  /* Created By   : Vincent
  ** Date Created : 12232005
  ** Description  : Check if tran_mm is closed/temporarily closed.
  */
  PROCEDURE check_tran_mm (
     p_date   IN GIAC_ACCTRANS.tran_date%TYPE
    ) IS

   v_closed_tag  GIAC_TRAN_MM.closed_tag%TYPE;

  BEGIN
   FOR a1 IN
      (SELECT closed_tag
         FROM GIAC_TRAN_MM
        WHERE fund_cd   = pvar_fund_cd
          AND branch_cd = Giacp.v('BRANCH_CD')
          AND tran_yr   = TO_NUMBER(TO_CHAR(p_date, 'YYYY'))
          AND tran_mm   = TO_NUMBER(TO_CHAR(p_date, 'MM')))
   LOOP
      v_closed_tag := a1.closed_tag;
      EXIT;
   END LOOP;

   IF v_closed_tag = 'T' THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#You are no longer allowed to create a transaction for '
                                    ||TO_CHAR(p_date, 'fmMonth')||' '||TO_CHAR(p_date, 'RRRR')
                                    ||'. This transaction month is temporarily closed.');
   ELSIF v_closed_tag = 'Y' AND NVL(Giacp.v('ALLOW_TRAN_FOR_CLOSED_MONTH'),'N') = 'N' THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#You are no longer allowed to create a transaction for '
                                    ||TO_CHAR(p_date, 'fmMonth')||' '||TO_CHAR(p_date, 'RRRR')
                                    ||'. This transaction month is already closed.');
   END IF;
  END check_tran_mm;


  /* Created By   : Vincent
  ** Date Created : 12222005
  ** Description  : Check if uploading user is a DCB user.
  **                Effectivity and expiry dates are also checked vs OR date or sysdate.
  */
  PROCEDURE Check_Dcb_User (
    p_date   IN GIAC_ACCTRANS.tran_date%TYPE
    ) IS

    CURSOR C IS
      SELECT cashier_cd    , dcb_user_id, valid_tag,
             effectivity_dt, expiry_dt
        FROM GIAC_DCB_USERS
       WHERE gibr_fund_cd = pvar_fund_cd
         AND gibr_branch_cd = pvar_branch_cd
         AND dcb_user_id = USER;

   v_cashier_cd    GIAC_DCB_USERS.cashier_cd%TYPE;
    v_dcb_user_id   GIAC_DCB_USERS.dcb_user_id%TYPE;
   v_valid_tag     GIAC_DCB_USERS.valid_tag%TYPE;
   v_eff_dt      GIAC_DCB_USERS.effectivity_dt%TYPE;
   v_exp_dt      GIAC_DCB_USERS.expiry_dt%TYPE;

  BEGIN
    OPEN C;
   FETCH C
   INTO v_cashier_cd, v_dcb_user_id, v_valid_tag,
         v_eff_dt    , v_exp_dt;
   IF C%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#You are not authorized to issue an O.R. for '
                                    ||'this company/branch ('||pvar_fund_cd||'/'||pvar_branch_cd||').');
   END IF;
    CLOSE C;

    --check first if you're a valid user
    IF v_valid_tag = 'N' THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#You are not authorized to issue an O.R. for '
                                    ||'this company/branch ('||pvar_fund_cd||'/'||pvar_branch_cd||').');
    END IF;

    IF v_eff_dt > p_date OR v_eff_dt > TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#Your authority to issue an O.R. for '
                                    ||'this company/branch ('||pvar_fund_cd||'/'||pvar_branch_cd||') '
                                    ||'starts on '||TO_CHAR(v_eff_dt, 'fmMonth dd, YYYY')||'.');
    END IF;

    IF v_exp_dt < p_date OR v_exp_dt < TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#You are not authorized to issue an O.R. for '
                                    ||'this company/branch ('||pvar_fund_cd||'/'||pvar_branch_cd||') '
                                    ||'beyond '||TO_CHAR(v_exp_dt, 'fmMonth dd, YYYY') ||'.');
    END IF;
  END Check_Dcb_User;


  /* Created By   : Vincent
  ** Date Created : 12232005
  ** Description  : Check for an open DCB for the specified or_date and get the dcb_no.
  */
  PROCEDURE get_dcb_no (
     p_date    IN  GIAC_ACCTRANS.tran_date%TYPE
    ,p_dcb_no   OUT GIAC_COLLN_BATCH.dcb_no%TYPE
    ) IS

  BEGIN
   p_dcb_no := NULL;

    FOR dcb IN
     (SELECT MIN(dcb_no) min_dcb, tran_date
      FROM GIAC_COLLN_BATCH
     WHERE fund_cd          = pvar_fund_cd
      AND branch_cd        = pvar_branch_cd
      AND dcb_year         = TO_NUMBER(TO_CHAR(p_date, 'YYYY'))
      AND TO_CHAR(tran_date, 'MM-DD-YYYY') = TO_CHAR(p_date, 'MM-DD-YYYY')
      AND dcb_flag         = 'O'
     GROUP BY tran_date)
    LOOP
      p_dcb_no := dcb.min_dcb;
      EXIT;
    END LOOP;

    IF p_dcb_no IS NULL THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#There is no open DCB No. dated '
                                    || TO_CHAR(p_date, 'fmMonth DD, YYYY')
                                    ||' for this company/branch ('||pvar_fund_cd||'/'||pvar_branch_cd||').');
    END IF;
  END get_dcb_no;

  --Deo [10.05.2016]: add start
  PROCEDURE create_dcb_no (
     p_dcb_no      NUMBER,
     p_or_date     giac_upload_prem_refno.tran_date%TYPE,
     p_fund_cd     VARCHAR2,
     p_branch_cd   VARCHAR2,
     p_user_id     VARCHAR2
  )
  IS
  BEGIN
     INSERT INTO giac_colln_batch
                 (dcb_no, dcb_year,
                  fund_cd, branch_cd, tran_date, dcb_flag,
                  remarks, user_id, last_update
                 )
          VALUES (p_dcb_no, TO_NUMBER (TO_CHAR (p_or_date, 'YYYY')),
                  p_fund_cd, p_branch_cd, p_or_date, 'O',
                  'Inserted from GIACS001.', p_user_id, SYSDATE
                 );

     IF SQL%NOTFOUND
     THEN
        raise_application_error
              (-20210,
               'Geniisys Exception#I#Unable to insert into giac_colln_batch.'
              );
     END IF;
  END;
  
  PROCEDURE get_dcb_no2 (
     p_date        IN       giac_acctrans.tran_date%TYPE,
     p_dcb_no      OUT      giac_colln_batch.dcb_no%TYPE,
     p_with_open   OUT      VARCHAR2
  )
  IS
  BEGIN
     p_dcb_no := NULL;

     FOR dcb IN (SELECT   MIN (dcb_no) min_dcb, tran_date
                     FROM giac_colln_batch
                      WHERE fund_cd = pvar_fund_cd
                      AND branch_cd = pvar_branch_cd
                      AND dcb_year = TO_NUMBER (TO_CHAR (p_date, 'YYYY'))
                      AND TO_CHAR (tran_date, 'MM-DD-YYYY') =
                                                  TO_CHAR (p_date, 'MM-DD-YYYY')
                      AND dcb_flag = 'O'
                 GROUP BY tran_date)
     LOOP
        p_dcb_no := dcb.min_dcb;
        EXIT;
     END LOOP;

     IF p_dcb_no IS NULL
     THEN
        p_with_open := 'N';
     ELSE
        p_with_open := 'Y';
     END IF;
  END get_dcb_no2;
  --Deo [10.05.2016]: add ends
  
  /* Created By   : Vincent
  ** Date Created : 02132006
  ** Description  : Separates the premium and tax amounts based on the collection amount for transaction type 1.
  */
  PROCEDURE tax_alloc_type1 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    ) IS

    /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
    **  then allocate tax collected amt to taxes other than EVAT, balance
    **  should be allocated to ratio of original premium_amt and evat amount
    **  (evat amount must first be determined)
    */
    v_max_inst_no            GIPI_INSTALLMENT.inst_no%TYPE;
    v_balance_due            GIPI_INSTALLMENT.prem_amt%TYPE;
    v_tax_balance_due        GIPI_INSTALLMENT.tax_amt%TYPE;
    v_collection_amt         GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
    v_tax_inserted           GIAC_TAX_COLLNS.tax_amt%TYPE;
    v_tax_alloc              GIPI_INV_TAX.tax_allocation%TYPE;
    v_switch                 VARCHAR2(1);
    last_tax_inserted        GIPI_INV_TAX.tax_cd%TYPE;

    /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
    **  evat will always be retrieved last
    */
    CURSOR c1 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c2 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd != pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c3 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd = pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c4 (p_tax_cd  NUMBER) IS
    SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND a.inst_no = p_inst_no
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

    CURSOR c4a (p_tax_cd  NUMBER) IS
      SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

    CURSOR c5 (p_tax_alloc  VARCHAR) IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND b.fund_cd = pvar_fund_cd
         AND a.tax_allocation = p_tax_alloc
         AND a.tax_cd != pvar_evat_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

  BEGIN

    DELETE FROM GIAC_TAX_COLLNS
     WHERE gacc_tran_id = p_tran_id
       AND b160_iss_cd = p_iss_cd
       AND b160_prem_seq_no = p_prem_seq_no
       AND inst_no = p_inst_no
       AND transaction_type = p_tran_type;

    /* to get the no of payments or inst_no */
    SELECT MAX(inst_no)
      INTO v_max_inst_no
      FROM GIPI_INSTALLMENT
     WHERE iss_cd = p_iss_cd
       AND prem_seq_no = p_prem_seq_no;

    v_collection_amt := p_collection_amt;

   BEGIN
    SELECT DISTINCT tax_allocation
       INTO v_tax_alloc
       FROM GIPI_INV_TAX
      WHERE iss_cd = p_iss_cd
        AND prem_seq_no = p_prem_seq_no;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_tax_alloc := NULL;
   END;

   IF (v_tax_alloc = 'F' AND p_inst_no != 1) OR
       (v_tax_alloc = 'L' AND p_inst_no != v_max_inst_no) THEN
    p_tax_amt := 0;
    p_premium_amt := p_collection_amt;
   END IF;

   IF (v_tax_alloc = 'F' AND p_inst_no = 1) OR
     (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no) THEN

    v_collection_amt := p_collection_amt;

    FOR c1_rec IN c2 --for taxes other than EVAT
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
      IF v_balance_due > v_collection_amt THEN
       v_balance_due := v_collection_amt;
      END IF;
      v_collection_amt := v_collection_amt - v_balance_due;
          INSERT INTO GIAC_TAX_COLLNS
              (gacc_tran_id                   ,transaction_type               ,
               b160_iss_cd                    ,b160_prem_seq_no               ,
               b160_tax_cd                    ,tax_amt                        ,
               fund_cd                        ,remarks                        ,
               user_id                        ,last_update                    ,
               inst_no                        )
           VALUES
              (p_tran_id                      ,p_tran_type                    ,
               p_iss_cd                       ,p_prem_seq_no                  ,
               c1_rec.tax_cd                  ,v_balance_due                  ,
               c1_rec.fund_cd                 ,NULL                           ,
               p_user_id                      ,p_last_update                  ,
               p_inst_no                      );
        END LOOP rec;
    END LOOP c1_rec;

    FOR c1_rec IN c3 --for EVAT only
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
      IF v_balance_due > NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) THEN
       v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) ;
      END IF;
      p_premium_amt := v_collection_amt - v_balance_due;
      p_tax_amt := p_collection_amt - p_premium_amt;
          INSERT INTO GIAC_TAX_COLLNS
             (gacc_tran_id                   ,transaction_type               ,
              b160_iss_cd                    ,b160_prem_seq_no               ,
              b160_tax_cd                    ,tax_amt                        ,
              fund_cd                        ,remarks                        ,
              user_id                        ,last_update                    ,
              inst_no                        )
            VALUES
             (p_tran_id                      ,p_tran_type                    ,
              p_iss_cd                       ,p_prem_seq_no                  ,
              c1_rec.tax_cd                  ,v_balance_due                  ,
              c1_rec.fund_cd                 ,NULL                           ,
              p_user_id                      ,p_last_update                  ,
              p_inst_no                      );
     END LOOP rec;
    END LOOP c1_rec;
   END IF;

   IF v_tax_alloc = 'S' THEN
    -- paano kung 1000 collected amount, total tax for that
      -- inst is 1000 including evat... should i pay the full
      -- amount for the other taxes??? and the eg. 100 left
      -- be divided proportionately to the premium and evat
      -- tapus the next time bayad siya check first kung fully
      -- paid na ung other taxes...????

    v_collection_amt := p_collection_amt; --new collection_amt

    /* only processes taxes other than evat first */
    v_tax_inserted := 0;  --to inititalize
    v_tax_balance_due := 0;
    FOR c1_rec IN c2
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      /** receivable **/
         v_tax_balance_due := v_tax_balance_due + (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
     END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c2
     LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF v_balance_due > (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) THEN
        SELECT DECODE(p_inst_no,v_max_inst_no,
                       DECODE(v_max_inst_no, 1,
                              NVL(c1_rec.tax_amt,0),
                              (NVL(c1_rec.tax_amt,0) - (ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2) * v_max_inst_no)) + ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2)),
                       NVL(c1_rec.tax_amt,0) / v_max_inst_no)
               - NVL(rec.tax_amt,0)
         INTO v_balance_due
         FROM dual;
       END IF;
       IF v_balance_due + v_tax_inserted > v_collection_amt THEN
         v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       INSERT INTO GIAC_TAX_COLLNS
           (gacc_tran_id                   ,transaction_type               ,
            b160_iss_cd                    ,b160_prem_seq_no               ,
            b160_tax_cd                    ,tax_amt                        ,
            fund_cd                        ,remarks                        ,
            user_id                        ,last_update                    ,
            inst_no                        )
        VALUES
           (p_tran_id                      ,p_tran_type                    ,
            p_iss_cd                       ,p_prem_seq_no                  ,
            c1_rec.tax_cd                  ,v_balance_due                  ,
            c1_rec.fund_cd                 ,NULL                           ,
            p_user_id                      ,p_last_update                  ,
            p_inst_no                      );
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP rec;
      last_tax_inserted := c1_rec.tax_cd;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c3
    LOOP
     v_switch := 'Y';
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
      v_collection_amt := v_collection_amt - v_balance_due;
      IF v_collection_amt > p_max_premium_amt THEN
       v_balance_due := v_balance_due - (v_collection_amt - p_max_premium_amt);
       p_premium_amt := p_max_premium_amt;
      ELSE
       p_premium_amt := v_collection_amt;
      END IF;
      p_tax_amt := p_collection_amt - p_premium_amt;
      INSERT INTO GIAC_TAX_COLLNS
          (gacc_tran_id                   ,transaction_type               ,
           b160_iss_cd                    ,b160_prem_seq_no               ,
           b160_tax_cd                    ,tax_amt                        ,
           fund_cd                        ,remarks                        ,
           user_id                        ,last_update                    ,
           inst_no                        )
       VALUES
          (p_tran_id                      ,p_tran_type                    ,
           p_iss_cd                       ,p_prem_seq_no                  ,
           c1_rec.tax_cd                  ,v_balance_due                  ,
           c1_rec.fund_cd                 ,NULL                           ,
           p_user_id                      ,p_last_update                  ,
           p_inst_no                      );
     END LOOP rec;
     last_tax_inserted := c1_rec.tax_cd;
    END LOOP c1_rec;

    IF v_switch != 'Y' THEN
     IF v_collection_amt > p_max_premium_amt THEN
      p_premium_amt := v_collection_amt - ( v_collection_amt - p_max_premium_amt);
      UPDATE GIAC_TAX_COLLNS
        SET tax_amt = tax_amt + (v_collection_amt - p_max_premium_amt)
           WHERE gacc_tran_id = p_tran_id
        AND b160_iss_cd = p_iss_cd
        AND b160_prem_seq_no = p_prem_seq_no
        AND inst_no = p_inst_no
        AND transaction_type = p_tran_type
        AND b160_tax_cd = last_tax_inserted;
     ELSE
      p_premium_amt := v_collection_amt;
     END IF;
     p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;--v_tax_alloc = 'S' then

   IF v_tax_alloc IS NULL THEN
    /*
    **therefore there are mixed tax allocations in the bill
    **process everything the same as the normal process except for evat
    **the excess amount after the process should be allocated to evat and premium
    */
    v_tax_inserted := 0;
    v_collection_amt := p_collection_amt;
    FOR c1_rec IN c5 ('F')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
      IF v_balance_due > v_collection_amt THEN
        v_balance_due := v_collection_amt;
      END IF;
      IF p_inst_no != 1 THEN
        v_balance_due := 0;
      END IF;
      v_collection_amt := v_collection_amt - v_balance_due;
      INSERT INTO GIAC_TAX_COLLNS
          (gacc_tran_id                   ,transaction_type               ,
           b160_iss_cd                    ,b160_prem_seq_no               ,
           b160_tax_cd                    ,tax_amt                        ,
           fund_cd                        ,remarks                        ,
           user_id                        ,last_update                    ,
           inst_no                        )
       VALUES
          (p_tran_id                      ,p_tran_type                    ,
           p_iss_cd                       ,p_prem_seq_no                  ,
           c1_rec.tax_cd                  ,v_balance_due                  ,
           c1_rec.fund_cd                 ,NULL                           ,
           p_user_id                      ,p_last_update                  ,
           p_inst_no                      );
     END LOOP rec;
    END LOOP c1_rec; --for 'F'

    v_tax_balance_due := 0;
    v_tax_inserted := 0;

    FOR c1_rec IN c5 ('S')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_tax_balance_due := (c1_rec.tax_amt / v_max_inst_no) - NVL(rec.tax_amt,0);
     END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c5 ('S')
     LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF v_balance_due > (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) THEN
        v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
       END IF;
       IF v_balance_due + v_tax_inserted > v_collection_amt THEN
        v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       INSERT INTO GIAC_TAX_COLLNS
           (gacc_tran_id                   ,transaction_type               ,
            b160_iss_cd                    ,b160_prem_seq_no               ,
            b160_tax_cd                    ,tax_amt                        ,
            fund_cd                        ,remarks                        ,
            user_id                        ,last_update                    ,
            inst_no                        )
        VALUES
           (p_tran_id                      ,p_tran_type                    ,
            p_iss_cd                       ,p_prem_seq_no                  ,
            c1_rec.tax_cd                  ,v_balance_due                  ,
            c1_rec.fund_cd                 ,NULL                           ,
            p_user_id                      ,p_last_update                  ,
            p_inst_no                      );
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP;
      last_tax_inserted := c1_rec.tax_cd;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c5 ('L')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      IF p_inst_no != v_max_inst_no THEN
       v_balance_due := 0;
      ELSE
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
       IF v_balance_due > v_collection_amt THEN
        v_balance_due := v_collection_amt;
       END IF;
       v_collection_amt := v_collection_amt - v_balance_due;
       INSERT INTO GIAC_TAX_COLLNS
         (gacc_tran_id                   ,transaction_type               ,
          b160_iss_cd                    ,b160_prem_seq_no               ,
          b160_tax_cd                    ,tax_amt                        ,
          fund_cd                        ,remarks                        ,
          user_id                        ,last_update                    ,
          inst_no                        )
        VALUES
         (p_tran_id                      ,p_tran_type                    ,
          p_iss_cd                       ,p_prem_seq_no                  ,
          c1_rec.tax_cd                  ,v_balance_due                  ,
          c1_rec.fund_cd                 ,NULL                           ,
          p_user_id                      ,p_last_update                  ,
          p_inst_no                      );
      END IF;
     END LOOP rec;
    END LOOP c1_rec;

    FOR c1_rec IN c3
    LOOP
     v_switch := 'Y'; --to check if bill has evat
     IF (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) OR
       (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no) THEN
      FOR rec IN c4a (c1_rec.tax_cd)
      LOOP
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0) + p_max_premium_amt;
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
        IF v_collection_amt - v_balance_due > p_max_premium_amt THEN
          p_premium_amt := p_max_premium_amt;
        v_balance_due := v_collection_amt - p_max_premium_amt;
       ELSE
        p_premium_amt := v_collection_amt - v_balance_due;
       END IF;
        p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;

     ELSIF c1_rec.tax_allocation = 'S' THEN
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + NVL(p_max_premium_amt,0);
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
       v_collection_amt := v_collection_amt - v_balance_due;
       IF v_collection_amt > NVL(p_max_premium_amt,0) THEN
        p_premium_amt := p_max_premium_amt;
        v_balance_due := v_balance_due + (v_collection_amt - p_max_premium_amt);
       ELSE
        p_premium_amt := v_collection_amt;
       END IF;
       p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
     END IF;

     INSERT INTO GIAC_TAX_COLLNS
            (gacc_tran_id                   ,transaction_type               ,
             b160_iss_cd                    ,b160_prem_seq_no               ,
             b160_tax_cd                    ,tax_amt                        ,
             fund_cd                        ,remarks                        ,
             user_id                        ,last_update                    ,
             inst_no                        )
       VALUES
          (p_tran_id                      ,p_tran_type                    ,
           p_iss_cd                       ,p_prem_seq_no                  ,
           c1_rec.tax_cd                  ,v_balance_due                  ,
           c1_rec.fund_cd                 ,NULL                           ,
           p_user_id                      ,p_last_update                  ,
           p_inst_no                      );
    END LOOP c1_rec;

    IF v_switch != 'Y' THEN --no evat
     p_premium_amt := v_collection_amt;
     p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;  --v_tax_alloc is  null
  END tax_alloc_type1;


  /* Created By   : Vincent
  ** Date Created : 02142006
  ** Description  : Separates the premium and tax amounts based on the collection amount for transaction type 3.
  */
  PROCEDURE tax_alloc_type3 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    ) IS

    /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
    **  then allocate tax collected amt to taxes other than EVAT, balance
    **  should be allocated to ratio of original premium_amt and evat amount
    **  (evat amount must first be determined)
    */
    v_max_inst_no            GIPI_INSTALLMENT.inst_no%TYPE;
    v_balance_due            GIPI_INSTALLMENT.prem_amt%TYPE;
    v_tax_balance_due        GIPI_INSTALLMENT.tax_amt%TYPE;
    v_collection_amt         GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
    v_tax_inserted           GIAC_TAX_COLLNS.tax_amt%TYPE;
    v_tax_alloc              GIPI_INV_TAX.tax_allocation%TYPE;
    v_switch                 VARCHAR2(1);

   /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
   **  evat will always be retrieved last
   */
    CURSOR c1 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c2 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd != pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c3 IS
    SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
     FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd = pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c4 (p_tax_cd  NUMBER) IS
      SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND a.inst_no = p_inst_no
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

   CURSOR c4a (p_tax_cd  NUMBER) IS
    SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

   CURSOR c5 (p_tax_alloc  VARCHAR) IS
       SELECT a.iss_cd         , a.prem_seq_no     ,
              a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
              a.tax_allocation , b.fund_cd         ,
              a.line_cd        , c.currency_rt
         FROM GIPI_INV_TAX a,
              GIAC_TAXES   b,
              GIPI_INVOICE c
        WHERE a.tax_cd = b.tax_cd
          AND a.iss_cd = c.iss_cd
          AND a.prem_seq_no = c.prem_seq_no
          AND a.iss_cd = p_iss_cd
          AND a.prem_seq_no = p_prem_seq_no
          AND b.fund_cd = pvar_fund_cd
          AND a.tax_allocation = p_tax_alloc
          AND a.tax_cd != pvar_evat_cd
        ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

  BEGIN

    DELETE FROM GIAC_TAX_COLLNS
     WHERE gacc_tran_id = p_tran_id
       AND b160_iss_cd = p_iss_cd
       AND b160_prem_seq_no = p_prem_seq_no
       AND inst_no = p_inst_no
       AND transaction_type = p_tran_type;

    /* to get the no of payments or inst_no */
    SELECT MAX(inst_no)
      INTO v_max_inst_no
      FROM GIPI_INSTALLMENT
     WHERE iss_cd = p_iss_cd
       AND prem_seq_no = p_prem_seq_no;

    v_collection_amt := p_collection_amt;

   BEGIN
    SELECT DISTINCT tax_allocation
       INTO v_tax_alloc
       FROM GIPI_INV_TAX
      WHERE iss_cd = p_iss_cd
        AND prem_seq_no = p_prem_seq_no;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_tax_alloc := NULL;
   END;

   IF (v_tax_alloc = 'F' AND p_inst_no != 1) OR
       (v_tax_alloc = 'L' AND p_inst_no != v_max_inst_no) THEN
    p_tax_amt := 0;
    p_premium_amt := p_collection_amt;
   END IF;

   IF (v_tax_alloc = 'F' AND p_inst_no = 1) OR
     (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no) THEN

    v_collection_amt := p_collection_amt;

      FOR c1_rec IN c2
      LOOP
        FOR rec IN c4 (c1_rec.tax_cd)
        LOOP
          v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
          IF ABS(v_balance_due) > ABS(v_collection_amt) THEN
            v_balance_due := v_collection_amt;
          END IF;
          v_collection_amt := v_collection_amt - v_balance_due;
          INSERT INTO GIAC_TAX_COLLNS
              (gacc_tran_id                   ,transaction_type               ,
               b160_iss_cd                    ,b160_prem_seq_no               ,
               b160_tax_cd                    ,tax_amt                        ,
               fund_cd                        ,remarks                        ,
               user_id                        ,last_update                    ,
               inst_no                        )
            VALUES
              (p_tran_id                      ,p_tran_type                    ,
               p_iss_cd                       ,p_prem_seq_no                  ,
               c1_rec.tax_cd                  ,v_balance_due                  ,
               c1_rec.fund_cd                 ,NULL                           ,
               p_user_id                      ,p_last_update                  ,
               p_inst_no                      );
        END LOOP rec;
      END LOOP c1_rec;

    FOR c1_rec IN c3
    LOOP  --for evat only
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
          IF ABS(v_balance_due) > ABS(NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0)) THEN
            v_balance_due := v_collection_amt;
          END IF;
          p_premium_amt := v_collection_amt - v_balance_due;
          p_tax_amt := p_collection_amt - p_premium_amt;
      INSERT INTO GIAC_TAX_COLLNS
        (gacc_tran_id                   ,transaction_type               ,
               b160_iss_cd                    ,b160_prem_seq_no               ,
               b160_tax_cd                    ,tax_amt                        ,
               fund_cd                        ,remarks                        ,
               user_id                        ,last_update                    ,
               inst_no                        )
       VALUES
              (p_tran_id                      ,p_tran_type                    ,
               p_iss_cd                       ,p_prem_seq_no                  ,
               c1_rec.tax_cd                  ,v_balance_due                  ,
               c1_rec.fund_cd                 ,NULL                           ,
               p_user_id                      ,p_last_update                  ,
               p_inst_no                      );
     END LOOP rec;
    END LOOP c1_rec;
   END IF;

   IF v_tax_alloc = 'S' THEN
    -- paano kung 1000 collected amount, total tax for that
    -- inst is 1000 including evat... should i pay the full
    -- amount for the other taxes??? and the eg. 100 left
    -- be divided proportionately to the premium and evat
    -- tapus the next time bayad siya check first kung fully
    -- paid na ung other taxes...????

    v_collection_amt := p_collection_amt; --new collection_amt

    /* only processes taxes other that evat first */
    v_tax_inserted := 0;  --to inititalize
    v_tax_balance_due := 0;
    FOR c1_rec IN c2
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      /** receivable **/
      v_tax_balance_due := v_tax_balance_due + (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
     END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c2
     LOOP
       FOR rec IN c4 (c1_rec.tax_cd)
       LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
             --v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - nvl(rec.tax_amt,0);--comment out
        --replaced the formula for v_balance_due with the select stmt below,
        --to correct the error in amounts inserted for tax
        SELECT DECODE(p_inst_no,v_max_inst_no,
                      DECODE(v_max_inst_no, 1,
                             NVL(c1_rec.tax_amt,0),
                             (NVL(c1_rec.tax_amt,0) - (ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2) * v_max_inst_no)) + ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2)),
                      NVL(c1_rec.tax_amt,0) / v_max_inst_no)
                   - NVL(rec.tax_amt,0)
          INTO v_balance_due
          FROM dual;
       END IF;
       IF ABS(v_balance_due + v_tax_inserted) > ABS(v_collection_amt) THEN
         v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       INSERT INTO GIAC_TAX_COLLNS
           (gacc_tran_id                   ,transaction_type               ,
            b160_iss_cd                    ,b160_prem_seq_no               ,
            b160_tax_cd                    ,tax_amt                        ,
            fund_cd                        ,remarks                        ,
            user_id                        ,last_update                    ,
            inst_no                        )
        VALUES
           (p_tran_id                      ,p_tran_type                    ,
            p_iss_cd                       ,p_prem_seq_no                  ,
            c1_rec.tax_cd                  ,v_balance_due                  ,
            c1_rec.fund_cd                 ,NULL                           ,
            p_user_id                      ,p_last_update                  ,
            p_inst_no                      );
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP rec;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c3
    LOOP
      v_switch := 'Y';
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * ABS(((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
      IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
      END IF;
      p_premium_amt := v_collection_amt - v_balance_due;
      p_tax_amt := p_collection_amt - p_premium_amt;
      INSERT INTO GIAC_TAX_COLLNS
          (gacc_tran_id                   ,transaction_type               ,
           b160_iss_cd                    ,b160_prem_seq_no               ,
           b160_tax_cd                    ,tax_amt                        ,
           fund_cd                        ,remarks                        ,
           user_id                        ,last_update                    ,
           inst_no                        )
       VALUES
          (p_tran_id                      ,p_tran_type                    ,
           p_iss_cd                       ,p_prem_seq_no                  ,
           c1_rec.tax_cd                  ,v_balance_due                  ,
           c1_rec.fund_cd                 ,NULL                           ,
           p_user_id                      ,p_last_update                  ,
           p_inst_no                      );
     END LOOP rec;
    END LOOP c1_rec;

    IF v_switch != 'Y' THEN
     p_premium_amt := v_collection_amt;
     p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;  --v_tax_alloc = 'S' then

   IF v_tax_alloc IS  NULL THEN
   /*
   **therefore there are mixed tax allocations in the bill
   **process everything the same as the normal process except for evat
   **the excess amount after the process should be allocated to evat and premium
   */
    v_tax_inserted := 0;
    v_collection_amt := p_collection_amt;

    FOR c1_rec IN c5 ('F')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
      IF ABS(v_balance_due) > ABS(v_collection_amt) THEN
       v_balance_due := v_collection_amt;
      END IF;
      IF p_inst_no != 1 THEN
       v_balance_due := 0;
      END IF;
        v_collection_amt := v_collection_amt - v_balance_due;
      INSERT INTO GIAC_TAX_COLLNS
          (gacc_tran_id                   ,transaction_type               ,
           b160_iss_cd                    ,b160_prem_seq_no               ,
           b160_tax_cd                    ,tax_amt                        ,
           fund_cd                        ,remarks                        ,
           user_id                        ,last_update                    ,
           inst_no                        )
       VALUES
          (p_tran_id                      ,p_tran_type                    ,
           p_iss_cd                       ,p_prem_seq_no                  ,
           c1_rec.tax_cd                  ,v_balance_due                  ,
           c1_rec.fund_cd                 ,NULL                           ,
           p_user_id                      ,p_last_update                  ,
           p_inst_no                      );
     END LOOP rec;
    END LOOP c1_rec; --for 'F'

    v_tax_balance_due := 0;
    v_tax_inserted := 0;

    FOR c1_rec IN c5 ('S')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
        v_tax_balance_due := (c1_rec.tax_amt / v_max_inst_no) - NVL(rec.tax_amt,0);
      END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c5 ('S')
     LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
         v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
       END IF;
       IF ABS(v_balance_due + v_tax_inserted) > ABS(v_collection_amt) THEN
         v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       INSERT INTO GIAC_TAX_COLLNS
           (gacc_tran_id                   ,transaction_type               ,
            b160_iss_cd                    ,b160_prem_seq_no               ,
            b160_tax_cd                    ,tax_amt                        ,
            fund_cd                        ,remarks                        ,
            user_id                        ,last_update                    ,
            inst_no                        )
        VALUES
           (p_tran_id                      ,p_tran_type                    ,
            p_iss_cd                       ,p_prem_seq_no                  ,
            c1_rec.tax_cd                  ,v_balance_due                  ,
            c1_rec.fund_cd                 ,NULL                           ,
            p_user_id                      ,p_last_update                  ,
            p_inst_no                      );
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c5  ('L')
    LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
      IF p_inst_no != v_max_inst_no THEN
        v_balance_due := 0;
      ELSE
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
          IF ABS(v_balance_due) > ABS(v_collection_amt) THEN
           v_balance_due := v_collection_amt;
          END IF;
       v_collection_amt := v_collection_amt - v_balance_due;
       INSERT INTO GIAC_TAX_COLLNS
          (gacc_tran_id                   ,transaction_type               ,
           b160_iss_cd                    ,b160_prem_seq_no               ,
           b160_tax_cd                    ,tax_amt                        ,
           fund_cd                        ,remarks                        ,
           user_id                        ,last_update                    ,
           inst_no                        )
        VALUES
          (p_tran_id                      ,p_tran_type                    ,
           p_iss_cd                       ,p_prem_seq_no                  ,
            c1_rec.tax_cd                  ,v_balance_due                  ,
            c1_rec.fund_cd                 ,NULL                           ,
            p_user_id                      ,p_last_update                  ,
            p_inst_no                      );
      END IF;
     END LOOP rec;
    END LOOP c1_rec;

    FOR c1_rec IN c3
    LOOP
     v_switch := 'Y'; --to check if bill has evat
     IF (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) OR
       (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no) THEN
      FOR rec IN c4a (c1_rec.tax_cd)
      LOOP
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0) + p_max_premium_amt;
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
       p_premium_amt := v_collection_amt - v_balance_due;
       p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
     ELSIF c1_rec.tax_allocation = 'S' THEN
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_max_premium_amt;
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
       p_premium_amt := v_collection_amt - v_balance_due;
       p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
     END IF;
     INSERT INTO GIAC_TAX_COLLNS
         (gacc_tran_id                   ,transaction_type               ,
          b160_iss_cd                    ,b160_prem_seq_no               ,
          b160_tax_cd                    ,tax_amt                        ,
          fund_cd                        ,remarks                        ,
          user_id                        ,last_update                    ,
          inst_no                        )
       VALUES
         (p_tran_id                      ,p_tran_type                    ,
          p_iss_cd                       ,p_prem_seq_no                  ,
          c1_rec.tax_cd                  ,v_balance_due                  ,
          c1_rec.fund_cd                 ,NULL                           ,
          p_user_id                      ,p_last_update                  ,
          p_inst_no                      );
    END LOOP c1_rec;
    IF v_switch != 'Y' THEN --no evat
      p_premium_amt := v_collection_amt;
      p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;  --v_tax_alloc is  null
  END tax_alloc_type3;


  /* Created By   : Vincent
  ** Date Created : 02062006
  ** Description  : This procedure determines the GL Account code that will handle the
  **                line number, intermediary number and old/new account code.
  */
  PROCEDURE aeg_check_level (
     cl_level         IN NUMBER
    ,cl_value         IN NUMBER
    ,cl_sub_acct1 IN OUT NUMBER
    ,cl_sub_acct2 IN OUT NUMBER
    ,cl_sub_acct3 IN OUT NUMBER
    ,cl_sub_acct4 IN OUT NUMBER
    ,cl_sub_acct5 IN OUT NUMBER
    ,cl_sub_acct6 IN OUT NUMBER
    ,cl_sub_acct7 IN OUT NUMBER
    ) IS

  BEGIN
    IF cl_level = 1 THEN
      cl_sub_acct1 := cl_value;
    ELSIF cl_level = 2 THEN
      cl_sub_acct2 := cl_value;
    ELSIF cl_level = 3 THEN
      cl_sub_acct3 := cl_value;
    ELSIF cl_level = 4 THEN
      cl_sub_acct4 := cl_value;
    ELSIF cl_level = 5 THEN
      cl_sub_acct5 := cl_value;
    ELSIF cl_level = 6 THEN
      cl_sub_acct6 := cl_value;
    ELSIF cl_level = 7 THEN
      cl_sub_acct7 := cl_value;
    END IF;
  END aeg_check_level;


  /* Created By   : Vincent
  ** Date Created : 02062006
  ** Description  : This procedure checks the existence of GL codes in GIAC_CHART_OF_ACCTS.
  */
  PROCEDURE aeg_check_chart_of_accts (
     cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ) IS

  BEGIN
    SELECT DISTINCT(gl_acct_id)
      INTO cca_gl_acct_id
      FROM GIAC_CHART_OF_ACCTS
     WHERE gl_acct_category  = cca_gl_acct_category
       AND gl_control_acct   = cca_gl_control_acct
       AND gl_sub_acct_1     = cca_gl_sub_acct_1
       AND gl_sub_acct_2     = cca_gl_sub_acct_2
       AND gl_sub_acct_3     = cca_gl_sub_acct_3
       AND gl_sub_acct_4     = cca_gl_sub_acct_4
       AND gl_sub_acct_5     = cca_gl_sub_acct_5
       AND gl_sub_acct_6     = cca_gl_sub_acct_6
       AND gl_sub_acct_7     = cca_gl_sub_acct_7;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#GL account code: '||trim(TO_CHAR(cca_gl_acct_category))
                                    ||'-'||trim(TO_CHAR(cca_gl_control_acct,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_1,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_2,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_3,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_4,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_5,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_6,'09'))
                                    ||'-'||trim(TO_CHAR(cca_gl_sub_acct_7,'09'))
                                    ||' does not exist in Chart of Accounts (Giac_Acctrans).');
  END aeg_check_chart_of_accts;


  /* Created By   : Vincent
  ** Date Created : 02062006
  ** Description  : Generates acct entries for the collection in the O.R.
  */

  /* Modified By   : Jason
  ** Date Modifies : 07/23/2007
  ** Description   : Modified the generation of acct entries. Cash on Hand (item 1) will now be cash in bank
  */
  PROCEDURE aeg_parameters(aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
           aeg_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
          aeg_fund_cd     GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                           aeg_module_nm   GIAC_MODULES.module_name%TYPE) IS

    /*CURSOR pr_cur IS
      SELECT amount, pay_mode
        FROM giac_collection_dtl
       WHERE gacc_tran_id = aeg_tran_id;*/ --commented out and replaced by the code below (jason 07/23/2007)

 --jason 072307
 CURSOR pr_cur IS
    SELECT amount, pay_mode, dcb_bank_cd, dcb_bank_acct_cd
      FROM GIAC_COLLECTION_DTL
     WHERE 1=1
       AND gacc_tran_id = aeg_tran_id
       AND pay_mode NOT IN ('PDC', 'CMI', 'CW');

 --jason 072307: cursor for 'PDC'
    CURSOR PR_cur_pdc IS
    SELECT amount, pay_mode
      FROM GIAC_COLLECTION_DTL
     WHERE gacc_tran_id = aeg_tran_id
       AND pay_mode = 'PDC';

 --jason 072307: cursor for 'CMI'
 CURSOR pr_cur_cmi IS
    SELECT amount, pay_mode
      FROM GIAC_COLLECTION_DTL
     WHERE gacc_tran_id = aeg_tran_id
       AND pay_mode = 'CMI';

 --jason 072307: cursor for 'CW'
 CURSOR pr_cur_cw IS
    SELECT amount, pay_mode
      FROM GIAC_COLLECTION_DTL
     WHERE gacc_tran_id = aeg_tran_id
       AND pay_mode = 'CW';


  BEGIN

   pvar_tran_id := aeg_tran_id;

    BEGIN
      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||aeg_module_nm||'.');
    END;


    --Jason 07/27/2007: Call the deletion of accounting entry procedure.

    Upload_Dpc.AEG_Delete_Acct_Entries(aeg_tran_id,
                                    pvar_gen_type);

    --call the accounting entry generation procedure.
    /*FOR pr_rec IN pr_cur
    LOOP
    Upload_Dpc.aeg_create_acct_entries(pvar_module_id,
                                         1,
                                       pr_rec.amount,
                                       pvar_gen_type);
   END LOOP;*/  --jason 07/25/2007: commented out and replaced by the code below

 FOR pr_rec IN pr_cur LOOP
   Upload_Dpc.aeg_create_cib_acct_entries(aeg_tran_id,
                             aeg_branch_cd,
                            aeg_fund_cd,
                                          pr_rec.dcb_bank_cd,
                                             pr_rec.dcb_bank_acct_cd,
                                          pr_rec.amount,
                                          pvar_gen_type);
    END LOOP;

    --Jason 07/25/2007: generation of AE for 'PDC'
    FOR PR_rec_pdc IN PR_cur_pdc LOOP
   Upload_Dpc.aeg_create_acct_entries( pvar_module_id  ,
                                       2,
                                       PR_rec_pdc.amount,
                                       pvar_gen_type);
    END LOOP;

 --Jason 07/25/2007: generation of AE for 'CMI'
 FOR pr_rec_cmi IN pr_cur_cmi LOOP
   Upload_Dpc.aeg_create_acct_entries( pvar_module_id  ,
                                       3,
                                       pr_rec_cmi.amount,
                                       pvar_gen_type);
    END LOOP;

 --Jason 07/25/2007: generation of AE for 'CW'
 FOR pr_rec_cw IN pr_cur_cw LOOP
   Upload_Dpc.aeg_create_acct_entries( pvar_module_id  ,
                                       4,
                                       pr_rec_cw.amount,
                                       pvar_gen_type);
    END LOOP;

  END aeg_parameters;


  /* Created By   : Vincent
  ** Date Created : 02062006
  ** Description  : Part of the generation of acct entries for the collection in the O.R.
  **        Refer to procedure: aeg_parameters
  */
  /*****************************************************************************
  * This procedure handles the creation of accounting entries per transaction. *
  *****************************************************************************/

  PROCEDURE aeg_create_acct_entries (
     aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE
    ,aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_acct_amt           GIPI_INVOICE.prem_amt%TYPE
    ,aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE
    ) IS

    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;

  BEGIN

    /***********************************************************
    * Populate the GL Account Code used in every transactions. *
    ***********************************************************/

   BEGIN
     SELECT gl_acct_category, gl_control_acct   ,
            gl_sub_acct_1   , gl_sub_acct_2     ,
            gl_sub_acct_3   , gl_sub_acct_4     ,
            gl_sub_acct_5   , gl_sub_acct_6     ,
            gl_sub_acct_7   , pol_type_tag      ,
            intm_type_level , old_new_acct_level,
            dr_cr_tag       , line_dependency_level
       INTO ws_gl_acct_category, ws_gl_control_acct   ,
            ws_gl_sub_acct_1   , ws_gl_sub_acct_2     ,
            ws_gl_sub_acct_3   , ws_gl_sub_acct_4     ,
            ws_gl_sub_acct_5   , ws_gl_sub_acct_6     ,
            ws_gl_sub_acct_7   , ws_pol_type_tag      ,
            ws_intm_type_level , ws_old_new_acct_level,
            ws_dr_cr_tag       , ws_line_dep_level
       FROM GIAC_MODULE_ENTRIES
      WHERE module_id = aeg_module_id
        AND item_no   = aeg_item_no
     FOR UPDATE OF gl_sub_acct_1;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_module_entries: '
                                      ||'GIACS001 - Enter O.P./O.R. Information.');
   END;

    /********************************************************************
    * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table. *
    ********************************************************************/

   Upload_Dpc.aeg_check_chart_of_accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                       ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                       ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                       ws_gl_acct_id);

    /****************************************************************************
    * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
    * debit-credit tag to determine whether the positive amount will be debited *
    * or credited.                                                              *
    ****************************************************************************/

   IF ws_dr_cr_tag = 'D' THEN
     IF aeg_acct_amt > 0 THEN
       ws_debit_amt  := ABS(aeg_acct_amt);
       ws_credit_amt := 0;
     ELSE
       ws_debit_amt  := 0;
       ws_credit_amt := ABS(aeg_acct_amt);
     END IF;
   ELSE
     IF aeg_acct_amt > 0 THEN
       ws_debit_amt  := 0;
       ws_credit_amt := ABS(aeg_acct_amt);
     ELSE
       ws_debit_amt  := ABS(aeg_acct_amt);
       ws_credit_amt := 0;
     END IF;
   END IF;

    /****************************************************************************
    * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
    * same transaction id.  Insert the record if it does not exists else update *
    * the existing record.                                                      *
    ****************************************************************************/

   Upload_Dpc.aeg_insert_update_acct_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                             ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                             aeg_gen_type       , ws_gl_acct_id     , ws_debit_amt    ,
                                             ws_credit_amt);

  END aeg_create_acct_entries;


  /* Created By   : Vincent
  ** Date Created : 02062006
  ** Description  : Part of the generation of acct entries for the collection in the O.R.
  **        Refer to procedure: aeg_create_acct_entries
  */
  /*****************************************************************************
  * This procedure determines whether the records will be updated or inserted  *
  * in GIAC_ACCT_ENTRIES.                                                      *
  *****************************************************************************/
  PROCEDURE aeg_insert_update_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
   ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
   ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
   ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
   ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
   ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
   ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
   ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
   ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
   ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
   ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
   ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
   ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ) IS

   iuae_acct_entry_id  GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id
       AND gl_acct_id          = iuae_gl_acct_id
       AND generation_type     = iuae_generation_type;

    IF NVL(iuae_acct_entry_id,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;

      INSERT INTO GIAC_ACCT_ENTRIES
      (gacc_tran_id       , gacc_gfun_fund_cd,
       gacc_gibr_branch_cd, acct_entry_id    ,
       gl_acct_id         , gl_acct_category ,
       gl_control_acct    , gl_sub_acct_1    ,
       gl_sub_acct_2      , gl_sub_acct_3    ,
       gl_sub_acct_4      , gl_sub_acct_5    ,
       gl_sub_acct_6      , gl_sub_acct_7    ,
       sl_cd              , debit_amt        ,
       credit_amt         , generation_type  ,
       user_id            , last_update)
     VALUES
      (pvar_tran_id        , pvar_fund_cd         ,
       pvar_branch_cd      , iuae_acct_entry_id   ,
       iuae_gl_acct_id     , iuae_gl_acct_category,
       iuae_gl_control_acct, iuae_gl_sub_acct_1   ,
       iuae_gl_sub_acct_2  , iuae_gl_sub_acct_3   ,
       iuae_gl_sub_acct_4  , iuae_gl_sub_acct_5   ,
       iuae_gl_sub_acct_6  , iuae_gl_sub_acct_7   ,
       NULL                , iuae_debit_amt       ,
       iuae_credit_amt     , iuae_generation_type ,
       USER               , SYSDATE);
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
    END IF;
  END aeg_insert_update_acct_entries;


  /* Created By   : Vincent
  ** Date Created : 02152006
  ** Description  : Generates acct entries for the premium collections.
  */
  PROCEDURE gen_dpc_acct_entries (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ) IS

  BEGIN
    pvar_tran_id := aeg_tran_id;

   IF NVL(Giacp.v('PREM_REC_GROSS_TAG'),'Y') = 'Y' THEN
    IF NVL(Giacp.v('ENTER_ADVANCED_PAYT'),'N') = 'Y' THEN
      Upload_Dpc.aeg_parameters_y_prem_rec(aeg_tran_id, aeg_module_nm);
      Upload_Dpc.aeg_parameters_y_prem_dep(aeg_tran_id, aeg_module_nm);
    ELSE
     Upload_Dpc.aeg_parameters_y(aeg_tran_id, aeg_module_nm);
    END IF;
   ELSE
     Upload_Dpc.aeg_parameters_n(aeg_tran_id, aeg_module_nm);
   END IF;
  END;


  /* Created By   : Vincent
  ** Date Created : 02152006
  ** Description  : Generates acct entries for premium receivables.
  */
  PROCEDURE aeg_parameters_y_prem_rec (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ) IS

    CURSOR pr_cur IS
      SELECT c.b140_iss_cd iss_cd,
             SUM(c.collection_amt) collection_amt,
        c.b140_prem_seq_no bill_no,
        a.line_cd,
             d.assd_no,
             a.type_cd
        FROM GIPI_POLBASIC a,
             GIPI_INVOICE  b,
             GIAC_DIRECT_PREM_COLLNS c,
             GIPI_PARLIST d
       WHERE a.policy_id    = b.policy_id
         AND b.iss_cd       = c.b140_iss_cd
         AND b.prem_seq_no  = c.b140_prem_seq_no
         AND a.par_id       = d.par_id
         AND c.gacc_tran_id = aeg_tran_id
         AND NOT EXISTS (SELECT '1'
                           FROM GIAC_ADVANCED_PAYT
                          WHERE iss_cd = c.b140_iss_cd
                       AND prem_seq_no = c.b140_prem_seq_no
                       AND inst_no = c.inst_no
                       AND gacc_tran_id = aeg_tran_id)
     GROUP BY c.b140_iss_cd,
             c.b140_prem_seq_no,
             a.line_cd,
            d.assd_no,
            a.type_cd;

    CURSOR evat_cur (p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
                     p_bill_no     GIPI_INVOICE.prem_seq_no%TYPE) IS
    SELECT SUM(tax_amt) tax_amt,
           b160_iss_cd,
           b160_prem_seq_no
        FROM GIAC_TAX_COLLNS
       WHERE b160_iss_cd = p_iss_cd
         AND b160_prem_seq_no = p_bill_no
         AND gacc_tran_id = aeg_tran_id
         AND b160_tax_cd = pvar_evat_cd
       GROUP BY b160_iss_cd, b160_prem_seq_no
      HAVING NVL(SUM(tax_amt),0) <> 0;

  BEGIN
    BEGIN
      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||aeg_module_nm||'.');
    END;

    FOR pr_rec IN pr_cur
    LOOP
      --call the accounting entry generation procedure.
      Upload_Dpc.aeg_create_dpc_acct_entries (pr_rec.assd_no,  pvar_module_id       ,
                                              1             ,  pr_rec.iss_cd        ,
                                              pr_rec.bill_no,  pr_rec.line_cd       ,
                                              pr_rec.type_cd,  pr_rec.collection_amt,
                                              pvar_gen_type);

    IF NVL(Giacp.v('OUTPUT_VAT_COLLN_ENTRY'),'N') = 'Y' THEN
     FOR evat_rec IN evat_cur (pr_rec.iss_cd, pr_rec.bill_no)
     LOOP
       /* item_no 7 - deferred output vat*/
       Upload_Dpc.aeg_create_dpc_acct_entries (NULL          ,  pvar_module_id  ,
                                               7             ,  pr_rec.iss_cd   ,
                                               pr_rec.bill_no,  pr_rec.line_cd  ,
                                               pr_rec.type_cd,  evat_rec.tax_amt,
                                               pvar_gen_type);

       /* item_no 6 - output vat payable*/
       Upload_Dpc.aeg_create_dpc_acct_entries (NULL          ,  pvar_module_id  ,
                                               6             ,  pr_rec.iss_cd   ,
                                               pr_rec.bill_no,  pr_rec.line_cd  ,
                                               pr_rec.type_cd,  evat_rec.tax_amt,
                                               pvar_gen_type);
     END LOOP;
    END IF;
    END LOOP;
  END aeg_parameters_y_prem_rec;


  /* Created By   : Vincent
  ** Date Created : 02152006
  ** Description  : Generates acct entries for advanced premium payments.
  */
  PROCEDURE aeg_parameters_y_prem_dep (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ) IS

    CURSOR pr_cur IS
      SELECT c.b140_iss_cd iss_cd,
             c.collection_amt,
             c.b140_prem_seq_no bill_no,
             a.line_cd,
             d.assd_no,
             a.type_cd,
             c.inst_no --added by alfie 11042009
        FROM GIPI_POLBASIC a,
             GIPI_INVOICE  b,
             GIAC_DIRECT_PREM_COLLNS c,
             GIPI_PARLIST d
       WHERE a.policy_id    = b.policy_id
         AND b.iss_cd       = c.b140_iss_cd
         AND b.prem_seq_no  = c.b140_prem_seq_no
         AND a.par_id       = d.par_id
         AND c.gacc_tran_id = aeg_tran_id
         AND EXISTS (SELECT '1'
             FROM GIAC_ADVANCED_PAYT
                      WHERE iss_cd = c.b140_iss_cd
                        AND prem_seq_no = c.b140_prem_seq_no
                        AND inst_no = c.inst_no
                        AND gacc_tran_id = aeg_tran_id);

     --added cursor  alfie  11042009
    CURSOR pd_cur (p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
                   p_bill_no     GIPI_INVOICE.prem_seq_no%TYPE,
                   p_inst_no     GIAC_DIRECT_PREM_COLLNS.inst_no%TYPE) IS
      SELECT SUM(a.tax_amt) tax_amt, a.b160_iss_cd iss_cd, a.b160_prem_seq_no bill_no
        FROM GIAC_TAX_COLLNS a, GIAC_DIRECT_PREM_COLLNS b
          WHERE a.B160_PREM_SEQ_NO = b.B140_PREM_SEQ_NO
            AND a.inst_no = b.inst_no
            AND a.b160_iss_cd = p_iss_cd
            AND a.b160_prem_seq_no = p_bill_no
            AND a.gacc_tran_id = aeg_tran_id
            AND a.b160_tax_cd = pvar_evat_cd
            AND a.inst_no = p_inst_no
            AND EXISTS (SELECT '1'
                          FROM GIAC_ADVANCED_PAYT
                            WHERE iss_cd = b.b140_iss_cd
                              AND prem_seq_no = b.b140_prem_seq_no
                              AND inst_no = b.inst_no
                              AND gacc_tran_id = b.gacc_tran_id)
              GROUP BY a.b160_iss_cd, a.b160_prem_seq_no
                HAVING NVL(SUM(a.tax_amt),0) <> 0;

  BEGIN
      FOR pr_rec IN pr_cur
      LOOP
        --call the accounting entry generation procedure.
        Upload_Dpc.aeg_create_dpc_acct_entries (pr_rec.assd_no,  pvar_module_id       ,
                                                5             ,  pr_rec.iss_cd        ,
                                                pr_rec.bill_no,  pr_rec.line_cd       ,
                                                pr_rec.type_cd,  pr_rec.collection_amt,
                                                pvar_gen_type);

        --added by alfie 11042009:  for VAT prem deposit and VAT payable
        IF NVL(Giacp.V('ENTER_PREPAID_COMM'),'N') = 'Y' THEN --for comm payments of policies that are not yet booked
          FOR vat_rec IN pd_cur(pr_rec.iss_cd, pr_rec.bill_no, pr_rec.inst_no)
          LOOP
            /** generate VAT for premium deposits only if EVAT_ENTRY_ON_PREM_COLLN parameter is set to 'B'
            */
            IF Giacp.v('EVAT_ENTRY_ON_PREM_COLLN') = 'B' THEN
                  -- item_no 8 - vat premium deposits
              Upload_Dpc.aeg_create_dpc_acct_entries(NULL,           pvar_module_id,
                                                     8,              pr_rec.iss_cd,
                                                     pr_rec.bill_no, pr_rec.line_cd,
                                                     pr_rec.type_cd, vat_rec.tax_amt,
                                                     pvar_gen_type);

                -- item_no 9 - vat payable
              Upload_Dpc.aeg_create_dpc_acct_entries(NULL,           pvar_module_id,
                                                     9,              pr_rec.iss_cd,
                                                     pr_rec.bill_no, pr_rec.line_cd,
                                                     pr_rec.type_cd, vat_rec.tax_amt,
                                                     pvar_gen_type);
            END IF;
          END LOOP;
       END IF;
    END LOOP;
  END aeg_parameters_y_prem_dep;


  /* Created By   : Vincent
  ** Date Created : 02152006
  ** Description  : Generates acct entries for premium receivables.
  */
  PROCEDURE aeg_parameters_y (
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ) IS

    CURSOR pr_cur IS
      SELECT c.b140_iss_cd iss_cd,
             SUM(c.collection_amt) collection_amt,
             c.b140_prem_seq_no bill_no,
             a.line_cd,
             d.assd_no,
             a.type_cd
        FROM GIPI_POLBASIC a,
             GIPI_INVOICE  b,
             GIAC_DIRECT_PREM_COLLNS c,
             GIPI_PARLIST d
       WHERE a.policy_id    = b.policy_id
         AND b.iss_cd       = c.b140_iss_cd
         AND b.prem_seq_no  = c.b140_prem_seq_no
         AND a.par_id       = d.par_id
         AND c.gacc_tran_id = aeg_tran_id
       GROUP BY c.b140_iss_cd,
             c.b140_prem_seq_no,
             a.line_cd,
            d.assd_no,
            a.type_cd;

    CURSOR evat_cur (p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
                     p_bill_no     GIPI_INVOICE.prem_seq_no%TYPE) IS
      SELECT SUM(tax_amt) tax_amt,
             b160_iss_cd,
             b160_prem_seq_no
        FROM GIAC_TAX_COLLNS
       WHERE b160_iss_cd = p_iss_cd
         AND b160_prem_seq_no = p_bill_no
         AND gacc_tran_id = aeg_tran_id
         AND b160_tax_cd = pvar_evat_cd
       GROUP BY b160_iss_cd, b160_prem_seq_no
      HAVING NVL(SUM(tax_amt),0) <> 0;

  BEGIN
    BEGIN
      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||aeg_module_nm||'.');
    END;


    FOR pr_rec IN pr_cur LOOP
      --call the accounting entry generation procedure.
      Upload_Dpc.aeg_create_dpc_acct_entries (pr_rec.assd_no,  pvar_module_id       ,
                                              1             ,  pr_rec.iss_cd        ,
                                              pr_rec.bill_no,  pr_rec.line_cd       ,
                                              pr_rec.type_cd,  pr_rec.collection_amt,
                                              pvar_gen_type);

    IF NVL(Giacp.v('OUTPUT_VAT_COLLN_ENTRY'),'N') = 'Y' THEN
       FOR evat_rec IN evat_cur (pr_rec.iss_cd, pr_rec.bill_no)
       LOOP
         /* item_no 7 - deferred output vat*/
         Upload_Dpc.aeg_create_dpc_acct_entries (NULL          ,  pvar_module_id  ,
                                                 7             ,  pr_rec.iss_cd   ,
                                                 pr_rec.bill_no,  pr_rec.line_cd  ,
                                                 pr_rec.type_cd,  evat_rec.tax_amt,
                                                 pvar_gen_type);

         /* item_no 6 - output vat payable*/
         Upload_Dpc.aeg_create_dpc_acct_entries (NULL,            pvar_module_id  ,
                                                 6             ,  pr_rec.iss_cd   ,
                                                 pr_rec.bill_no,  pr_rec.line_cd  ,
                                                 pr_rec.type_cd,  evat_rec.tax_amt,
                                                 pvar_gen_type);
       END LOOP;
    END IF;
    END LOOP;
  END aeg_parameters_y;


  /* Created By   : Vincent
  ** Date Created : 02152006
  ** Description  : Part of the generation of acct entries for direct premium collns.
  */
  /*****************************************************************************
  * This procedure handles the creation of accounting entries per transaction. *
  *****************************************************************************/
  PROCEDURE aeg_create_dpc_acct_entries (
     aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE
    ,aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE
    ,aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE
    ,aeg_line_cd            GIIS_LINE.line_cd%TYPE
    ,aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE
    ,aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE
    ,aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE
    ) IS

    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    ws_sl_type_cd                    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;

  BEGIN
    /***********************************************************
    * Populate the GL Account Code used in every transactions. *
    ***********************************************************/

   BEGIN
     SELECT gl_acct_category      ,  gl_control_acct             ,
            gl_sub_acct_1         ,  gl_sub_acct_2               ,
            gl_sub_acct_3         ,  gl_sub_acct_4               ,
            gl_sub_acct_5         ,  gl_sub_acct_6               ,
            gl_sub_acct_7         ,  pol_type_tag                ,
            NVL(intm_type_level,0),  NVL(old_new_acct_level,0)   ,
            dr_cr_tag             ,  NVL(line_dependency_level,0),
             sl_type_cd
       INTO ws_gl_acct_category,  ws_gl_control_acct   ,
            ws_gl_sub_acct_1   ,  ws_gl_sub_acct_2     ,
            ws_gl_sub_acct_3   ,  ws_gl_sub_acct_4     ,
            ws_gl_sub_acct_5   ,  ws_gl_sub_acct_6     ,
            ws_gl_sub_acct_7   ,  ws_pol_type_tag      ,
            ws_intm_type_level ,  ws_old_new_acct_level,
            ws_dr_cr_tag       ,  ws_line_dep_level,
             ws_sl_type_cd
       FROM GIAC_MODULE_ENTRIES
      WHERE module_id = aeg_module_id
        AND item_no   = aeg_item_no
     FOR UPDATE OF gl_sub_acct_1;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_module_entries.');
   END;

    /************************************************************************
    * Validate the INTM_TYPE_LEVEL value which indicates the segment of the *
    * GL account code that holds the intermediary type.                     *
    ************************************************************************/

   IF ws_intm_type_level != 0 THEN
     BEGIN
       SELECT DISTINCT(c.acct_intm_cd)
         INTO ws_acct_intm_cd
         FROM GIPI_COMM_INVOICE a,
              GIIS_INTERMEDIARY b,
              GIIS_INTM_TYPE c
        WHERE a.intrmdry_intm_no = b.intm_no
          AND b.intm_type        = c.intm_type
          AND a.iss_cd           = aeg_iss_cd
          AND a.prem_seq_no      = aeg_bill_no;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giis_intm_type.');
     END;
     Upload_Dpc.aeg_check_level(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
   END IF;

    /**************************************************************************
    * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
    * the GL account code that holds the line number.                         *
    **************************************************************************/

   IF ws_line_dep_level != 0 THEN
     BEGIN
       SELECT acct_line_cd
         INTO ws_line_cd
         FROM GIIS_LINE
        WHERE line_cd = aeg_line_cd;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giis_line.');
     END;
    Upload_Dpc.aeg_check_level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
   END IF;

    /**************************************************************************
    * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
    * the GL account code that holds the old and new account values.          *
    **************************************************************************/

    IF ws_old_new_acct_level != 0 THEN
      BEGIN
        BEGIN
          SELECT param_value_n
            INTO ws_new_acct_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'NEW_ACCT_CD';
        END;
        Upload_Dpc.aeg_check_level(ws_old_new_acct_level, ws_new_acct_cd  , ws_gl_sub_acct_1,
                                   ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                   ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_parameters.');
      END;
    END IF;

    /**************************************************************************
    * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
    * segments will be attached to this GL account.                           *
    **************************************************************************/

    IF ws_pol_type_tag = 'Y' THEN
      BEGIN
        SELECT NVL(gl_sub_acct_1,0), NVL(gl_sub_acct_2,0),
               NVL(gl_sub_acct_3,0), NVL(gl_sub_acct_4,0),
               NVL(gl_sub_acct_5,0), NVL(gl_sub_acct_6,0),
               NVL(gl_sub_acct_7,0)
          INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
               pt_gl_sub_acct_3, pt_gl_sub_acct_4,
               pt_gl_sub_acct_5, pt_gl_sub_acct_6,
               pt_gl_sub_acct_7
          FROM GIAC_POLICY_TYPE_ENTRIES
         WHERE line_cd = aeg_line_cd
           AND type_cd = aeg_type_cd;
        IF pt_gl_sub_acct_1 != 0 THEN
          ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
        END IF;
        IF pt_gl_sub_acct_2 != 0 THEN
          ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
        END IF;
        IF pt_gl_sub_acct_3 != 0 THEN
          ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
        END IF;
        IF pt_gl_sub_acct_4 != 0 THEN
          ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
        END IF;
        IF pt_gl_sub_acct_5 != 0 THEN
          ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
        END IF;
        IF pt_gl_sub_acct_6 != 0 THEN
          ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
        END IF;
        IF pt_gl_sub_acct_7 != 0 THEN
          ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_policy_type_entries.');
      END;
    END IF;

    /**************************************************************************
    * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
    **************************************************************************/

    Upload_Dpc.aeg_check_chart_of_accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                        ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                        ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                        ws_gl_acct_id);

    /****************************************************************************
    * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
    * debit-credit tag to determine whether the positive amount will be debited *
    * or credited.                                                              *
    ****************************************************************************/

    IF ws_dr_cr_tag = 'D' THEN
      IF aeg_acct_amt > 0 THEN
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      END IF;
    ELSE
      IF aeg_acct_amt > 0 THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      ELSE
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      END IF;
    END IF;

    /****************************************************************************
    * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
    * same transaction id.  Insert the record if it does not exists else update *
    * the existing record.                                                      *
    ****************************************************************************/

   Upload_Dpc.aeg_ins_upd_dpc_acct_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                           ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                           ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                           aeg_sl_cd          , ws_sl_type_cd     , aeg_gen_type    ,
                                           ws_gl_acct_id      , ws_debit_amt      , ws_credit_amt);
  END aeg_create_dpc_acct_entries;


  /* Created By   : Vincent
  ** Date Created : 02152006
  ** Description  : Part of the generation of acct entries for direct premium collns.
  */
  /*****************************************************************************
  * This procedure determines whether the records will be updated or inserted  *
  * in GIAC_ACCT_ENTRIES.                                                      *
  *****************************************************************************/
  PROCEDURE aeg_ins_upd_dpc_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ) IS

   iuae_acct_entry_id  GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id
       --AND sl_cd               = iuae_sl_cd  --alfie 11062009
       AND NVL2(iuae_sl_cd, sl_cd,0) = NVL(iuae_sl_cd,0) --include NVL to the columns to handle NULL
       AND generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id;

    IF NVL(iuae_acct_entry_id,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
      INSERT INTO GIAC_ACCT_ENTRIES
      (gacc_tran_id       ,  gacc_gfun_fund_cd,
       gacc_gibr_branch_cd,  acct_entry_id    ,
       gl_acct_id         ,  gl_acct_category ,
       gl_control_acct    ,  gl_sub_acct_1    ,
       gl_sub_acct_2      ,  gl_sub_acct_3    ,
       gl_sub_acct_4      ,  gl_sub_acct_5    ,
       gl_sub_acct_6      ,  gl_sub_acct_7    ,
       sl_cd              ,  sl_type_cd       ,
       debit_amt          ,  credit_amt       ,
       generation_type    ,  user_id          ,
       last_update)
     VALUES
      (pvar_tran_id        ,  pvar_fund_cd         ,
       pvar_branch_cd      ,  iuae_acct_entry_id   ,
       iuae_gl_acct_id     ,  iuae_gl_acct_category,
       iuae_gl_control_acct,  iuae_gl_sub_acct_1   ,
       iuae_gl_sub_acct_2  ,  iuae_gl_sub_acct_3   ,
       iuae_gl_sub_acct_4  ,  iuae_gl_sub_acct_5   ,
       iuae_gl_sub_acct_6  ,  iuae_gl_sub_acct_7   ,
       iuae_sl_cd          ,  iuae_sl_type_cd      ,
       iuae_debit_amt      ,  iuae_credit_amt      ,
       iuae_generation_type,  USER                 ,
       SYSDATE);
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE NVL2(iuae_sl_cd, sl_cd,0) = NVL(iuae_sl_cd,0) --modified by alfie 11052009, include NVL2 and NVL to the columns
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
    END IF;
  END aeg_ins_upd_dpc_acct_entries;


  /* Created By   : Vincent
  ** Date Created : 02162006
  ** Description  : Generates acct entries for premium receivables.
  */
  PROCEDURE aeg_parameters_n (
     p_tran_id   GIAC_ACCTRANS.tran_id%TYPE
    ,p_module_nm  GIAC_MODULES.module_name%TYPE
    ) IS

    v_rec_gross_tag   VARCHAR2(1);
    v_item_no         GIAC_MODULE_ENTRIES.item_no%TYPE;
    v_assd_no         GIPI_PARLIST.assd_no%TYPE;

  BEGIN
    BEGIN
      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = p_module_nm;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||p_module_nm||'.');
    END;

    FOR pr_rec IN
      (SELECT c.transaction_type,
              c.b140_iss_cd iss_cd,
              c.b140_prem_seq_no bill_no,
              a.line_cd,
             a.assd_no,
              a.type_cd,
              a.par_id,
              SUM(c.collection_amt) collection_amt,
             SUM(c.premium_amt)    premium_amt,
              SUM(c.tax_amt)        tax_amt
         FROM GIPI_POLBASIC a,
              GIPI_INVOICE  b,
              GIAC_DIRECT_PREM_COLLNS c
        WHERE 1=1
          AND a.policy_id    = b.policy_id
          AND a.iss_cd       = c.b140_iss_cd
          AND c.b140_iss_cd  = c.b140_iss_cd
          AND b.iss_cd       = c.b140_iss_cd
          AND b.prem_seq_no  = c.b140_prem_seq_no
          AND c.gacc_tran_id = p_tran_id
        GROUP BY c.b140_iss_cd,
              c.b140_prem_seq_no,
              a.line_cd,
              a.assd_no,
              a.type_cd,
              c.transaction_type,
              a.par_id)
    LOOP
      -- call the accounting entry generation procedure.
      BEGIN
        IF pr_rec.transaction_type IN (3,4) THEN
          v_item_no := 5;
        ELSE
          v_item_no := 1;
        END IF;
      END;

      -- to determine whether there should only be one acctg entry for premium and tax
      -- or separate acctg entries respectively.
      v_rec_gross_tag := Giacp.v('PREM_REC_GROSS_TAG');

    -- assd_no is sometimes null therefore look into GIPI_PARLIST
      IF pr_rec.assd_no IS NULL THEN
     BEGIN
      SELECT assd_no
       INTO v_assd_no
       FROM GIPI_PARLIST
       WHERE par_id = pr_rec.par_id;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20210, pr_rec.iss_cd||'-'||TO_CHAR(pr_rec.bill_no)||' has no assured.');
     END;
      END IF;

      IF v_rec_gross_tag = 'Y' THEN
     Upload_Dpc.aeg_create_dpc_acct_entries(NVL(pr_rec.assd_no,v_assd_no), pvar_module_id  ,
                                            v_item_no                    , pr_rec.iss_cd        ,
                                            pr_rec.bill_no               , pr_rec.line_cd       ,
                                            pr_rec.type_cd               , pr_rec.collection_amt,
                                           pvar_gen_type);
      ELSE
     Upload_Dpc.aeg_create_dpc_acct_entries(NVL(pr_rec.assd_no,v_assd_no), pvar_module_id,
                                            v_item_no                    , pr_rec.iss_cd      ,
                                            pr_rec.bill_no               , pr_rec.line_cd     ,
                                            pr_rec.type_cd               , pr_rec.premium_amt ,
                                            pvar_gen_type);
     IF pr_rec.tax_amt != 0 THEN
      FOR rec IN (SELECT b160_tax_cd tax_cd,
                         SUM(tax_amt) tax_amt
                     FROM GIAC_TAX_COLLNS
                     WHERE b160_prem_seq_no = pr_rec.bill_no
                      AND b160_iss_cd      = pr_rec.iss_cd
                      AND gacc_tran_id     = p_tran_id
                       GROUP BY b160_tax_cd)
      LOOP
       Upload_Dpc.aeg_create_acct_entries_tax_n(rec.tax_cd,rec.tax_amt, pvar_gen_type);
          END LOOP; -- end of rec
        END IF; -- end of pr_rec.tax_amt
      END IF; -- end of v_rec_gross_tag
    END LOOP pr_rec;
  END aeg_parameters_n;


  /* Created By   : Vincent
  ** Date Created : 02162006
  ** Description  : Generates acct entries for tax of premium receivable.
  */
  /*************************************************************************************
  * This procedure handles the creation of accounting entries per transaction for tax. *
  *************************************************************************************/
  PROCEDURE aeg_create_acct_entries_tax_n (
     aeg_tax_cd    GIAC_TAXES.tax_cd%TYPE
    ,aeg_tax_amt    GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE
    ,aeg_gen_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ) IS

    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    dummy       VARCHAR2(1);

  BEGIN
    /**************************************************************************
    * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
    **************************************************************************/

    SELECT gl_acct_category   ,  gl_control_acct,
           gl_sub_acct_1      ,  gl_sub_acct_2  ,
           gl_sub_acct_3      ,  gl_sub_acct_4  ,
           gl_sub_acct_5      ,  gl_sub_acct_6  ,
           gl_sub_acct_7      ,  gl_acct_id
      INTO ws_gl_acct_category,  ws_gl_control_acct,
       ws_gl_sub_acct_1   ,  ws_gl_sub_acct_2  ,
       ws_gl_sub_acct_3   ,  ws_gl_sub_acct_4  ,
           ws_gl_sub_acct_5   ,  ws_gl_sub_acct_6  ,
       ws_gl_sub_acct_7   ,  ws_gl_acct_id
     FROM GIAC_TAXES
     WHERE tax_cd = aeg_tax_cd;

    BEGIN
      SELECT 'x'
        INTO dummy
        FROM GIAC_CHART_OF_ACCTS
       WHERE gl_acct_id = ws_gl_acct_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#GL account code '
                                        ||trim(TO_CHAR(ws_gl_acct_category))
                                        ||'-'||trim(TO_CHAR(ws_gl_control_acct,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_1,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_2,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_3,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_4,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_5,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_6,'09'))
                                        ||'-'||trim(TO_CHAR(ws_gl_sub_acct_7,'09'))
                                        ||' does not exist in Chart of Accounts (Giac_Acctrans).');
        END;
    END;

    /****************************************************************************
    * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
    * debit-credit tag to determine whether the positive amount will be debited *
    * or credited.                                                              *
    ****************************************************************************/

   IF ws_dr_cr_tag = 'D' THEN
     IF aeg_tax_amt > 0 THEN
       ws_debit_amt  := ABS(aeg_tax_amt);
       ws_credit_amt := 0;
     ELSE
       ws_debit_amt  := 0;
       ws_credit_amt := ABS(aeg_tax_amt);
     END IF;
   ELSE
     IF aeg_tax_amt > 0 THEN
       ws_debit_amt  := 0;
       ws_credit_amt := ABS(aeg_tax_amt);
     ELSE
       ws_debit_amt  := ABS(aeg_tax_amt);
       ws_credit_amt := 0;
     END IF;
   END IF;

    /****************************************************************************
    * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
    * same transaction id.  Insert the record if it does not exists else update *
    * the existing record.                                                      *
    ****************************************************************************/

   Upload_Dpc.aeg_ins_upd_acct_tax_n(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                     ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                     ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                     NULL               , aeg_gen_type      , ws_gl_acct_id   ,
                                     ws_debit_amt       , ws_credit_amt);
  END aeg_create_acct_entries_tax_n;


  /* Created By   : Vincent
  ** Date Created : 02162006
  ** Description  : Part of the acct entry generation for tax of premium receivable.
  */
  /*****************************************************************************
  * This procedure determines whether the records will be updated or inserted  *
  * in GIAC_ACCT_ENTRIES.                                                      *
  *****************************************************************************/
  PROCEDURE aeg_ins_upd_acct_tax_n (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ) IS

    iuae_acct_entry_id     GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id
       AND generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id;

    IF NVL(iuae_acct_entry_id,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
      INSERT INTO GIAC_ACCT_ENTRIES
      (gacc_tran_id       , gacc_gfun_fund_cd,
       gacc_gibr_branch_cd, acct_entry_id    ,
       gl_acct_id         , gl_acct_category ,
       gl_control_acct    , gl_sub_acct_1    ,
       gl_sub_acct_2      , gl_sub_acct_3    ,
       gl_sub_acct_4      , gl_sub_acct_5    ,
       gl_sub_acct_6      , gl_sub_acct_7    ,
       sl_cd              , debit_amt        ,
       credit_amt         , generation_type  ,
       user_id            , last_update)
     VALUES
      (pvar_tran_id        , pvar_fund_cd         ,
       pvar_branch_cd      , iuae_acct_entry_id   ,
       iuae_gl_acct_id     , iuae_gl_acct_category,
       iuae_gl_control_acct, iuae_gl_sub_acct_1   ,
       iuae_gl_sub_acct_2  , iuae_gl_sub_acct_3   ,
       iuae_gl_sub_acct_4  , iuae_gl_sub_acct_5   ,
       iuae_gl_sub_acct_6  , iuae_gl_sub_acct_7   ,
       iuae_sl_cd          , iuae_debit_amt       ,
       iuae_credit_amt     , iuae_generation_type ,
       USER                , SYSDATE);
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
    END IF;
  END aeg_ins_upd_acct_tax_n;


  /* Created By   : Vincent
  ** Date Created : 02062006
  ** Description  : Generates acct entries for premium deposits.
  */
  PROCEDURE aeg_parameters_pdep (
     aeg_tran_id  GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm GIAC_MODULES.module_name%TYPE
    ) IS

    v_debit_amt    GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    v_credit_amt   GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_sl_cd     GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    ws_sl_type_cd   GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
    ws_sl_source_cd  GIAC_ACCT_ENTRIES.sl_source_cd%TYPE  := 1 ; -- 1 if sl_cd is from giac_sl_list and 2 if from giis_payees

    loc_flag GIAC_ACCTRANS.tran_flag%TYPE;
    loc_tag GIAC_PREM_DEPOSIT.or_print_tag%TYPE;

    --for bank collns
    CURSOR prem_deposit_cur IS
      SELECT collection_amt, ri_cd, assd_no
        FROM GIAC_PREM_DEPOSIT
       WHERE gacc_tran_id = aeg_tran_id;

    CURSOR sl_type_cur IS
      SELECT sl_type_cd
        FROM GIAC_SL_TYPES
       WHERE sl_type_name = 'ASSURED';

   v_item_no  NUMBER;

  BEGIN
    pvar_tran_id := aeg_tran_id;

    BEGIN
      OPEN sl_type_cur;
      FETCH sl_type_cur INTO ws_sl_type_cd;
      CLOSE sl_type_cur;

      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||aeg_module_nm||'.');
    END;

    FOR prem_deposit_rec IN prem_deposit_cur LOOP
    /*IF prem_deposit_rec.ri_cd IS NULL THEN
     v_item_no := 1;
     ws_sl_cd := prem_deposit_rec.assd_no;
      ELSE
     v_item_no := 2;
     ws_sl_cd := prem_deposit_rec.assd_no;
      END IF;*/ --Deo [10.05.2016]: comment out
      
      v_item_no := 3; --Deo [10.05.2016]: prem deposit gl account
      
      --call the accounting entry generation procedure.
      Upload_Dpc.aeg_create_pdep_acct_entries(prem_deposit_rec.collection_amt, pvar_gen_type,  pvar_module_id,
                                  v_item_no                      , ws_sl_cd     ,  ws_sl_type_cd ,
                                              ws_sl_source_cd);
    END LOOP;
  END aeg_parameters_pdep;


  /* Created By   : Vincent
  ** Date Created : 03022006
  ** Description  : Part of the acct entry generation for premium deposit.
  */
  PROCEDURE aeg_create_pdep_acct_entries (
     aeg_collection_amt   GIAC_BANK_COLLNS.collection_amt%TYPE
    ,aeg_gen_type         GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,aeg_module_id        GIAC_MODULES.module_id%TYPE
    ,aeg_item_no          GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_sl_cd            GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,aeg_sl_type_cd       GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,aeg_sl_source_cd     GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ) IS

    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    ws_sl_cd                        GIAC_ACCT_ENTRIES.sl_cd%TYPE;

  BEGIN
    /***********************************************************
    * Populate the GL Account Code used in every transactions. *
    ***********************************************************/

    BEGIN
      SELECT gl_acct_category, gl_control_acct,
             gl_sub_acct_1   , gl_sub_acct_2  ,
             gl_sub_acct_3   , gl_sub_acct_4  ,
             gl_sub_acct_5   , gl_sub_acct_6  ,
             gl_sub_acct_7   , pol_type_tag   ,
             intm_type_level , old_new_acct_level,
             dr_cr_tag       , line_dependency_level
        INTO ws_gl_acct_category, ws_gl_control_acct,
             ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
             ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
             ws_gl_sub_acct_7   , ws_pol_type_tag   ,
             ws_intm_type_level , ws_old_new_acct_level,
             ws_dr_cr_tag       , ws_line_dep_level
        FROM GIAC_MODULE_ENTRIES
       WHERE module_id = aeg_module_id
         AND item_no   = aeg_item_no
      FOR UPDATE OF gl_sub_acct_1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_module_entries.');
    END;

    /************************************************************
    * Determine whether the amount will be debited or credited. *
    ************************************************************/

    IF aeg_collection_amt > 0 THEN
       ws_debit_amt  := 0;
       ws_credit_amt := ABS(aeg_collection_amt);
    ELSE
       ws_debit_amt  := ABS(aeg_collection_amt);
       ws_credit_amt := 0;
    END IF;

    /****************************************************************************
    * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
    * same transaction id.  Insert the record if it does not exists else update *
    * the existing record.                                                      *
    ****************************************************************************/
    BEGIN
      SELECT DISTINCT(gl_acct_id)
        INTO ws_gl_acct_id
        FROM GIAC_CHART_OF_ACCTS
       WHERE gl_acct_category  = ws_gl_acct_category
         AND gl_control_acct   = ws_gl_control_acct
         AND gl_sub_acct_1     = ws_gl_sub_acct_1
         AND gl_sub_acct_2     = ws_gl_sub_acct_2
         AND gl_sub_acct_3     = ws_gl_sub_acct_3
         AND gl_sub_acct_4     = ws_gl_sub_acct_4
         AND gl_sub_acct_5     = ws_gl_sub_acct_5
         AND gl_sub_acct_6     = ws_gl_sub_acct_6
         AND gl_sub_acct_7     = ws_gl_sub_acct_7;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#GL account code '||trim(TO_CHAR(ws_gl_acct_category))
                                      ||'-'||trim(TO_CHAR(ws_gl_control_acct,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_1,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_2,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_3,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_4,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_5,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_6,'09'))
                                      ||'-'||trim(TO_CHAR(ws_gl_sub_acct_7,'09'))
                                      ||' does not exist in Chart of Accounts (Giac_Acctrans).');
    END;

    BEGIN
      SELECT gl_acct_category,
         gl_control_acct     ,
         gl_sub_acct_1       ,
         gl_sub_acct_2       ,
         gl_sub_acct_3       ,
         gl_sub_acct_4       ,
         gl_sub_acct_5       ,
         gl_sub_acct_6       ,
         gl_sub_acct_7       ,
         gl_acct_id
      INTO ws_gl_acct_category,
         ws_gl_control_acct   ,
         ws_gl_sub_acct_1     ,
         ws_gl_sub_acct_2     ,
         ws_gl_sub_acct_3     ,
         ws_gl_sub_acct_4     ,
         ws_gl_sub_acct_5     ,
         ws_gl_sub_acct_6     ,
         ws_gl_sub_acct_7     ,
         ws_gl_acct_id
      FROM GIAC_CHART_OF_ACCTS
     WHERE gl_acct_id = ws_gl_acct_id;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#GL account code '||trim(TO_CHAR(ws_gl_acct_category))
                                     ||'-'||trim(TO_CHAR(ws_gl_control_acct,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_1,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_2,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_3,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_4,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_5,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_6,'09'))
                                     ||'-'||trim(TO_CHAR(ws_gl_sub_acct_7,'09'))
                                     ||' does not exist in Chart of Accounts (Giac_Acctrans).');
    END;

     Upload_Dpc.aeg_ins_upd_pdep_acct_entries (ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                               ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                               aeg_sl_cd          , aeg_sl_type_cd    , aeg_sl_source_cd,
                                               aeg_gen_type       , ws_gl_acct_id     , ws_debit_amt    ,
                                               ws_credit_amt);
  END;



  /* Created By   : Vincent
  ** Date Created : 03022006
  ** Description  : Part of the acct entry generation for premium deposit.
  */
  /****************************************************************************
  * This procedure determines whether the records will be updated or inserted *
  * in GIAC_ACCT_ENTRIES.                                                     *
  ****************************************************************************/
  PROCEDURE aeg_ins_upd_pdep_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ) IS

    iuae_acct_entry_id     GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
    iuae_count         NUMBER;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id
       AND NVL(sl_cd, 0) = NVL(iuae_sl_cd, NVL(sl_cd,0))
       AND generation_type = iuae_generation_type
       AND gl_acct_id = iuae_gl_acct_id;

    BEGIN
      SELECT NVL(COUNT(*),0)
        INTO iuae_count
        FROM GIAC_ACCT_ENTRIES
       WHERE gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id
         AND NVL(sl_cd, 0)       = NVL(iuae_sl_cd, NVL(sl_cd,0))
         AND generation_type   = iuae_generation_type
         AND gl_acct_category  = iuae_gl_acct_category
         AND gl_control_acct   = iuae_gl_control_acct
         AND gl_sub_acct_1     =  iuae_gl_sub_acct_1
         AND gl_sub_acct_2     = iuae_gl_sub_acct_2
         AND gl_sub_acct_3     = iuae_gl_sub_acct_2
         AND gl_sub_acct_4     = iuae_gl_sub_acct_2
         AND gl_sub_acct_5     = iuae_gl_sub_acct_2
         AND gl_sub_acct_6     = iuae_gl_sub_acct_2
         AND gl_sub_acct_7     = iuae_gl_sub_acct_2
         AND sl_cd             = iuae_sl_cd
         AND gl_acct_id        = iuae_gl_acct_id;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
           iuae_count :=0;

    END;

    IF NVL(iuae_count,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
      INSERT INTO GIAC_ACCT_ENTRIES
          (gacc_tran_id       , gacc_gfun_fund_cd,
           gacc_gibr_branch_cd, acct_entry_id    ,
           gl_acct_id         , gl_acct_category ,
           gl_control_acct    , gl_sub_acct_1    ,
           gl_sub_acct_2      , gl_sub_acct_3    ,
           gl_sub_acct_4      , gl_sub_acct_5    ,
           gl_sub_acct_6      , gl_sub_acct_7    ,
           sl_cd              , debit_amt        ,
           sl_type_cd         , sl_source_cd     ,
           credit_amt         , generation_type  ,
           user_id            , last_update)
         VALUES
           (pvar_tran_id        , pvar_fund_cd         ,
            pvar_branch_cd      , iuae_acct_entry_id   ,
            iuae_gl_acct_id     , iuae_gl_acct_category,
            iuae_gl_control_acct, iuae_gl_sub_acct_1   ,
            iuae_gl_sub_acct_2  , iuae_gl_sub_acct_3   ,
            iuae_gl_sub_acct_4  , iuae_gl_sub_acct_5   ,
            iuae_gl_sub_acct_6  , iuae_gl_sub_acct_7   ,
            iuae_sl_cd          , iuae_debit_amt       ,
            iuae_sl_type_cd     , iuae_sl_source_cd    ,
            iuae_credit_amt     , iuae_generation_type ,
            USER                , SYSDATE);
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE NVL(sl_cd,0)        = NVL(iuae_sl_cd, NVL(sl_cd,0))
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
    END IF;
  END;

  /* Created By   : Vincent
  ** Date Created : 05042006
  ** Description  : Generates acct entries for the miscellaneous acct entries (accounts payable, other income, etc.)
  */
  PROCEDURE aeg_parameters_misc (
     aeg_tran_id       GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm      GIAC_MODULES.module_name%TYPE
    ,aeg_item_no         GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_collection_amt  GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,aeg_sl_cd           GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ) IS

    ws_sl_cd     GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    ws_sl_type_cd   GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
    ws_sl_source_cd  GIAC_ACCT_ENTRIES.sl_source_cd%TYPE  := 1 ; -- 1 if sl_cd is from giac_sl_list and 2 if from giis_payees

   v_item_no  NUMBER;

  BEGIN
    pvar_tran_id := aeg_tran_id;

    BEGIN
      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||aeg_module_nm||'.');
    END;

    --call the accounting entry generation procedure.
    Upload_Dpc.aeg_create_misc_acct_entries(aeg_collection_amt,  pvar_gen_type,  pvar_module_id,
                                aeg_item_no,        aeg_sl_cd    ,  ws_sl_type_cd ,
                                            ws_sl_source_cd);
  END;

  /* Created By   : Vincent
  ** Date Created : 05042006
  ** Description  : Part of the acct entry generation for the miscellaneous acct entries (accounts payable, other income, etc.)
  */
  PROCEDURE aeg_create_misc_acct_entries (
     aeg_collection_amt   GIAC_BANK_COLLNS.collection_amt%TYPE
    ,aeg_gen_type         GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,aeg_module_id        GIAC_MODULES.module_id%TYPE
    ,aeg_item_no          GIAC_MODULE_ENTRIES.item_no%TYPE
    ,aeg_sl_cd            GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,aeg_sl_type_cd       GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,aeg_sl_source_cd     GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ) IS

    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    ws_sl_type_cd                    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;

  BEGIN
    /***********************************************************
    * Populate the GL Account Code used in every transactions. *
    ***********************************************************/

    BEGIN
      SELECT gl_acct_category, gl_control_acct,
             gl_sub_acct_1   , gl_sub_acct_2  ,
             gl_sub_acct_3   , gl_sub_acct_4  ,
             gl_sub_acct_5   , gl_sub_acct_6  ,
             gl_sub_acct_7   , pol_type_tag   ,
             intm_type_level , old_new_acct_level,
             dr_cr_tag       , line_dependency_level,
             sl_type_cd
        INTO ws_gl_acct_category, ws_gl_control_acct,
             ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
             ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
             ws_gl_sub_acct_7   , ws_pol_type_tag   ,
             ws_intm_type_level , ws_old_new_acct_level,
             ws_dr_cr_tag       , ws_line_dep_level,
             ws_sl_type_cd
        FROM GIAC_MODULE_ENTRIES
       WHERE module_id = aeg_module_id
         AND item_no   = aeg_item_no
      FOR UPDATE OF gl_sub_acct_1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_module_entries.');
    END;

    /************************************************************
    * Determine whether the amount will be debited or credited. *
    ************************************************************/

    IF ws_dr_cr_tag = 'D' THEN
      IF aeg_collection_amt > 0 THEN
        ws_debit_amt  := ABS(aeg_collection_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_collection_amt);
      END IF;
    ELSE
      IF aeg_collection_amt > 0 THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_collection_amt);
      ELSE
        ws_debit_amt  := ABS(aeg_collection_amt);
        ws_credit_amt := 0;
      END IF;
    END IF;

    /****************************************************************************
    * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
    * same transaction id.  Insert the record if it does not exists else update *
    * the existing record.                                                      *
    ****************************************************************************/
   Upload_Dpc.aeg_check_chart_of_accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                       ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                       ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                       ws_gl_acct_id);

    --insert or update the acct entries
    Upload_Dpc.aeg_ins_upd_misc_acct_entries (ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                              ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                              ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                              aeg_sl_cd          , ws_sl_type_cd     , aeg_sl_source_cd,
                                              aeg_gen_type       , ws_gl_acct_id     , ws_debit_amt    ,
                                              ws_credit_amt);
  END;

  /* Created By   : Vincent
  ** Date Created : 05042006
  ** Description  : Part of the acct entry generation for the miscellaneous acct entries (accounts payable, other income, etc.)
  */
  /*****************************************************************************
  * This procedure determines whether the records will be updated or inserted  *
  * in GIAC_ACCT_ENTRIES.                                                      *
  *****************************************************************************/
  PROCEDURE aeg_ins_upd_misc_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ) IS

   iuae_acct_entry_id  GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id
       AND NVL(sl_cd, 0)       = NVL(iuae_sl_cd, NVL(sl_cd,0))
       AND generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id;

    IF NVL(iuae_acct_entry_id,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
      INSERT INTO GIAC_ACCT_ENTRIES
      (gacc_tran_id       ,  gacc_gfun_fund_cd,
       gacc_gibr_branch_cd,  acct_entry_id    ,
       gl_acct_id         ,  gl_acct_category ,
           gl_control_acct    ,  gl_sub_acct_1    ,
       gl_sub_acct_2      ,  gl_sub_acct_3    ,
       gl_sub_acct_4      ,  gl_sub_acct_5    ,
       gl_sub_acct_6      ,  gl_sub_acct_7    ,
           sl_cd              ,  sl_type_cd       ,
           sl_source_cd       ,  debit_amt        ,
           credit_amt         ,  generation_type  ,
           user_id            ,  last_update)
     VALUES
      (pvar_tran_id        ,  pvar_fund_cd         ,
       pvar_branch_cd      ,  iuae_acct_entry_id   ,
       iuae_gl_acct_id     ,  iuae_gl_acct_category,
           iuae_gl_control_acct,  iuae_gl_sub_acct_1   ,
       iuae_gl_sub_acct_2  ,  iuae_gl_sub_acct_3   ,
       iuae_gl_sub_acct_4  ,  iuae_gl_sub_acct_5   ,
       iuae_gl_sub_acct_6  ,  iuae_gl_sub_acct_7   ,
       iuae_sl_cd          ,  iuae_sl_type_cd      ,
           iuae_sl_source_cd   ,  iuae_debit_amt       ,
           iuae_credit_amt     ,  iuae_generation_type ,
       USER                ,  SYSDATE);
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE NVL(sl_cd, 0)       = NVL(iuae_sl_cd, NVL(sl_cd,0))
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
    END IF;
  END aeg_ins_upd_misc_acct_entries;

  /* Created By   : Vincent
  ** Date Created : 06192006
  ** Description  : Simulates the separation of the premium and tax amounts based on the collection amount for transaction type 1.
  */
  PROCEDURE prem_to_be_pd_type1 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    ) IS

    /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
    **  then allocate tax collected amt to taxes other than EVAT, balance
    **  should be allocated to ratio of original premium_amt and evat amount
    **  (evat amount must first be determined)
    */
    v_max_inst_no            GIPI_INSTALLMENT.inst_no%TYPE;
    v_balance_due            GIPI_INSTALLMENT.prem_amt%TYPE;
    v_tax_balance_due        GIPI_INSTALLMENT.tax_amt%TYPE;
    v_collection_amt         GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
    v_tax_inserted           GIAC_TAX_COLLNS.tax_amt%TYPE;
    v_tax_alloc              GIPI_INV_TAX.tax_allocation%TYPE;
    v_switch                 VARCHAR2(1);
    last_tax_inserted        GIPI_INV_TAX.tax_cd%TYPE;

    /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
    **  evat will always be retrieved last
    */
    CURSOR c1 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c2 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd != pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c3 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd = pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c4 (p_tax_cd  NUMBER) IS
    SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND a.inst_no = p_inst_no
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

    CURSOR c4a (p_tax_cd  NUMBER) IS
      SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

    CURSOR c5 (p_tax_alloc  VARCHAR) IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND b.fund_cd = pvar_fund_cd
         AND a.tax_allocation = p_tax_alloc
         AND a.tax_cd != pvar_evat_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

  BEGIN

    /* to get the no of payments or inst_no */
    SELECT MAX(inst_no)
      INTO v_max_inst_no
      FROM GIPI_INSTALLMENT
     WHERE iss_cd = p_iss_cd
       AND prem_seq_no = p_prem_seq_no;

    v_collection_amt := p_collection_amt;

   BEGIN
    SELECT DISTINCT tax_allocation
       INTO v_tax_alloc
       FROM GIPI_INV_TAX
      WHERE iss_cd = p_iss_cd
        AND prem_seq_no = p_prem_seq_no;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_tax_alloc := NULL;
   END;

   IF (v_tax_alloc = 'F' AND p_inst_no != 1) OR
       (v_tax_alloc = 'L' AND p_inst_no != v_max_inst_no) THEN
    p_tax_amt := 0;
    p_premium_amt := p_collection_amt;
   END IF;

   IF (v_tax_alloc = 'F' AND p_inst_no = 1) OR
     (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no) THEN

    v_collection_amt := p_collection_amt;

    FOR c1_rec IN c2 --for taxes other than EVAT
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
      IF v_balance_due > v_collection_amt THEN
       v_balance_due := v_collection_amt;
      END IF;
      v_collection_amt := v_collection_amt - v_balance_due;
        END LOOP rec;
    END LOOP c1_rec;

    FOR c1_rec IN c3 --for EVAT only
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
      IF v_balance_due > NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) THEN
       v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) ;
      END IF;
      p_premium_amt := v_collection_amt - v_balance_due;
      p_tax_amt := p_collection_amt - p_premium_amt;
     END LOOP rec;
    END LOOP c1_rec;
   END IF;

   IF v_tax_alloc = 'S' THEN
    -- paano kung 1000 collected amount, total tax for that
      -- inst is 1000 including evat... should i pay the full
      -- amount for the other taxes??? and the eg. 100 left
      -- be divided proportionately to the premium and evat
      -- tapus the next time bayad siya check first kung fully
      -- paid na ung other taxes...????

    v_collection_amt := p_collection_amt; --new collection_amt

    /* only processes taxes other than evat first */
    v_tax_inserted := 0;  --to inititalize
    v_tax_balance_due := 0;
    FOR c1_rec IN c2
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      /** receivable **/
         v_tax_balance_due := v_tax_balance_due + (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
     END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c2
     LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF v_balance_due > (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) THEN
        SELECT DECODE(p_inst_no,v_max_inst_no,
                       DECODE(v_max_inst_no, 1,
                              NVL(c1_rec.tax_amt,0),
                              (NVL(c1_rec.tax_amt,0) - (ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2) * v_max_inst_no)) + ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2)),
                       NVL(c1_rec.tax_amt,0) / v_max_inst_no)
               - NVL(rec.tax_amt,0)
         INTO v_balance_due
         FROM dual;
       END IF;
       IF v_balance_due + v_tax_inserted > v_collection_amt THEN
         v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP rec;
      last_tax_inserted := c1_rec.tax_cd;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c3
    LOOP
     v_switch := 'Y';
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
      v_collection_amt := v_collection_amt - v_balance_due;
      IF v_collection_amt > p_max_premium_amt THEN
       v_balance_due := v_balance_due - (v_collection_amt - p_max_premium_amt);
       p_premium_amt := p_max_premium_amt;
      ELSE
       p_premium_amt := v_collection_amt;
      END IF;
      p_tax_amt := p_collection_amt - p_premium_amt;
     END LOOP rec;
     last_tax_inserted := c1_rec.tax_cd;
    END LOOP c1_rec;

    IF v_switch != 'Y' THEN
     IF v_collection_amt > p_max_premium_amt THEN
      p_premium_amt := v_collection_amt - ( v_collection_amt - p_max_premium_amt);
     ELSE
      p_premium_amt := v_collection_amt;
     END IF;
     p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;--v_tax_alloc = 'S' then

   IF v_tax_alloc IS NULL THEN
    /*
    **therefore there are mixed tax allocations in the bill
    **process everything the same as the normal process except for evat
    **the excess amount after the process should be allocated to evat and premium
    */
    v_tax_inserted := 0;
    v_collection_amt := p_collection_amt;
    FOR c1_rec IN c5 ('F')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
      IF v_balance_due > v_collection_amt THEN
        v_balance_due := v_collection_amt;
      END IF;
      IF p_inst_no != 1 THEN
        v_balance_due := 0;
      END IF;
      v_collection_amt := v_collection_amt - v_balance_due;
     END LOOP rec;
    END LOOP c1_rec; --for 'F'

    v_tax_balance_due := 0;
    v_tax_inserted := 0;

    FOR c1_rec IN c5 ('S')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_tax_balance_due := (c1_rec.tax_amt / v_max_inst_no) - NVL(rec.tax_amt,0);
     END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c5 ('S')
     LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF v_balance_due > (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) THEN
        v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
       END IF;
       IF v_balance_due + v_tax_inserted > v_collection_amt THEN
        v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP;
      last_tax_inserted := c1_rec.tax_cd;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c5 ('L')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      IF p_inst_no != v_max_inst_no THEN
       v_balance_due := 0;
      ELSE
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
       IF v_balance_due > v_collection_amt THEN
        v_balance_due := v_collection_amt;
       END IF;
       v_collection_amt := v_collection_amt - v_balance_due;
      END IF;
     END LOOP rec;
    END LOOP c1_rec;

    FOR c1_rec IN c3
    LOOP
     v_switch := 'Y'; --to check if bill has evat
     IF (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) OR
       (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no) THEN
      FOR rec IN c4a (c1_rec.tax_cd)
      LOOP
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0) + p_max_premium_amt;
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
        IF v_collection_amt - v_balance_due > p_max_premium_amt THEN
          p_premium_amt := p_max_premium_amt;
        v_balance_due := v_collection_amt - p_max_premium_amt;
       ELSE
        p_premium_amt := v_collection_amt - v_balance_due;
       END IF;
        p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;

     ELSIF c1_rec.tax_allocation = 'S' THEN
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + NVL(p_max_premium_amt,0);
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
       v_collection_amt := v_collection_amt - v_balance_due;
       IF v_collection_amt > NVL(p_max_premium_amt,0) THEN
        p_premium_amt := p_max_premium_amt;
        v_balance_due := v_balance_due + (v_collection_amt - p_max_premium_amt);
       ELSE
        p_premium_amt := v_collection_amt;
       END IF;
       p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
     END IF;

    END LOOP c1_rec;

    IF v_switch != 'Y' THEN --no evat
     p_premium_amt := v_collection_amt;
     p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;  --v_tax_alloc is  null
  END prem_to_be_pd_type1;

  /* Created By   : Vincent
  ** Date Created : 06192006
  ** Description  : Simulates the separation of the premium and tax amounts based on the collection amount for transaction type 3.
  */
  PROCEDURE prem_to_be_pd_type3 (
     p_tran_id               IN NUMBER
    ,p_tran_type             IN NUMBER
    ,p_iss_cd                IN VARCHAR2
    ,p_prem_seq_no           IN NUMBER
    ,p_inst_no               IN NUMBER
    ,p_collection_amt    IN OUT NUMBER
    ,p_premium_amt       IN OUT NUMBER
    ,p_tax_amt           IN OUT NUMBER
    ,p_max_premium_amt       IN NUMBER
    ,p_user_id               IN VARCHAR2
    ,p_last_update           IN DATE
    ) IS

    /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
    **  then allocate tax collected amt to taxes other than EVAT, balance
    **  should be allocated to ratio of original premium_amt and evat amount
    **  (evat amount must first be determined)
    */
    v_max_inst_no            GIPI_INSTALLMENT.inst_no%TYPE;
    v_balance_due            GIPI_INSTALLMENT.prem_amt%TYPE;
    v_tax_balance_due        GIPI_INSTALLMENT.tax_amt%TYPE;
    v_collection_amt         GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
    v_tax_inserted           GIAC_TAX_COLLNS.tax_amt%TYPE;
    v_tax_alloc              GIPI_INV_TAX.tax_allocation%TYPE;
    v_switch                 VARCHAR2(1);

   /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
   **  evat will always be retrieved last
   */
    CURSOR c1 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

    CURSOR c2 IS
      SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
        FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd != pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c3 IS
    SELECT a.iss_cd         , a.prem_seq_no     ,
             a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
             a.tax_allocation , b.fund_cd         ,
             a.line_cd        , c.currency_rt
     FROM GIPI_INV_TAX a,
             GIAC_TAXES   b,
             GIPI_INVOICE c
       WHERE a.tax_cd = b.tax_cd
         AND a.iss_cd = c.iss_cd
         AND a.prem_seq_no = c.prem_seq_no
         AND a.iss_cd = p_iss_cd
         AND a.prem_seq_no = p_prem_seq_no
         AND a.tax_cd = pvar_evat_cd
         AND b.fund_cd = pvar_fund_cd
       ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c4 (p_tax_cd  NUMBER) IS
      SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND a.inst_no = p_inst_no
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

   CURSOR c4a (p_tax_cd  NUMBER) IS
    SELECT SUM(NVL(a.tax_amt,0)) tax_amt
        FROM GIAC_TAX_COLLNS  a,
             GIAC_ACCTRANS    b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.b160_iss_cd = p_iss_cd
         AND a.b160_prem_seq_no = p_prem_seq_no
         AND b.tran_flag != 'D'
         AND a.b160_tax_cd = p_tax_cd
         AND a.gacc_tran_id != p_tran_id
         AND NOT EXISTS (SELECT 'x'
                           FROM GIAC_REVERSALS aa,
                                GIAC_ACCTRANS  bb
                          WHERE aa.reversing_tran_id = bb.tran_id
                            AND bb.tran_flag != 'D'
                            AND aa.gacc_tran_id = b.tran_id);

   CURSOR c5 (p_tax_alloc  VARCHAR) IS
       SELECT a.iss_cd         , a.prem_seq_no     ,
              a.tax_cd         , NVL(a.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
              a.tax_allocation , b.fund_cd         ,
              a.line_cd        , c.currency_rt
         FROM GIPI_INV_TAX a,
              GIAC_TAXES   b,
              GIPI_INVOICE c
        WHERE a.tax_cd = b.tax_cd
          AND a.iss_cd = c.iss_cd
          AND a.prem_seq_no = c.prem_seq_no
          AND a.iss_cd = p_iss_cd
          AND a.prem_seq_no = p_prem_seq_no
          AND b.fund_cd = pvar_fund_cd
          AND a.tax_allocation = p_tax_alloc
          AND a.tax_cd != pvar_evat_cd
        ORDER BY a.tax_cd DESC, b.tax_type, b.priority_cd;

  BEGIN

    /* to get the no of payments or inst_no */
    SELECT MAX(inst_no)
      INTO v_max_inst_no
      FROM GIPI_INSTALLMENT
     WHERE iss_cd = p_iss_cd
       AND prem_seq_no = p_prem_seq_no;

    v_collection_amt := p_collection_amt;

   BEGIN
    SELECT DISTINCT tax_allocation
       INTO v_tax_alloc
       FROM GIPI_INV_TAX
      WHERE iss_cd = p_iss_cd
        AND prem_seq_no = p_prem_seq_no;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_tax_alloc := NULL;
   END;

   IF (v_tax_alloc = 'F' AND p_inst_no != 1) OR
       (v_tax_alloc = 'L' AND p_inst_no != v_max_inst_no) THEN
    p_tax_amt := 0;
    p_premium_amt := p_collection_amt;
   END IF;

   IF (v_tax_alloc = 'F' AND p_inst_no = 1) OR
     (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no) THEN

    v_collection_amt := p_collection_amt;

      FOR c1_rec IN c2
      LOOP
        FOR rec IN c4 (c1_rec.tax_cd)
        LOOP
          v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
          IF ABS(v_balance_due) > ABS(v_collection_amt) THEN
            v_balance_due := v_collection_amt;
          END IF;
          v_collection_amt := v_collection_amt - v_balance_due;
        END LOOP rec;
      END LOOP c1_rec;

    FOR c1_rec IN c3
    LOOP  --for evat only
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
          IF ABS(v_balance_due) > ABS(NVL(c1_rec.tax_amt,0) - NVL(rec.tax_amt,0)) THEN
            v_balance_due := v_collection_amt;
          END IF;
          p_premium_amt := v_collection_amt - v_balance_due;
          p_tax_amt := p_collection_amt - p_premium_amt;
     END LOOP rec;
    END LOOP c1_rec;
   END IF;

   IF v_tax_alloc = 'S' THEN
    -- paano kung 1000 collected amount, total tax for that
    -- inst is 1000 including evat... should i pay the full
    -- amount for the other taxes??? and the eg. 100 left
    -- be divided proportionately to the premium and evat
    -- tapus the next time bayad siya check first kung fully
    -- paid na ung other taxes...????

    v_collection_amt := p_collection_amt; --new collection_amt

    /* only processes taxes other that evat first */
    v_tax_inserted := 0;  --to inititalize
    v_tax_balance_due := 0;
    FOR c1_rec IN c2
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      /** receivable **/
      v_tax_balance_due := v_tax_balance_due + (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
     END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c2
     LOOP
       FOR rec IN c4 (c1_rec.tax_cd)
       LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
             --v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - nvl(rec.tax_amt,0);--comment out
        --replaced the formula for v_balance_due with the select stmt below,
        --to correct the error in amounts inserted for tax
        SELECT DECODE(p_inst_no,v_max_inst_no,
                      DECODE(v_max_inst_no, 1,
                             NVL(c1_rec.tax_amt,0),
                             (NVL(c1_rec.tax_amt,0) - (ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2) * v_max_inst_no)) + ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2)),
                      NVL(c1_rec.tax_amt,0) / v_max_inst_no)
                   - NVL(rec.tax_amt,0)
          INTO v_balance_due
          FROM dual;
       END IF;
       IF ABS(v_balance_due + v_tax_inserted) > ABS(v_collection_amt) THEN
         v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP rec;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c3
    LOOP
      v_switch := 'Y';
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_max_premium_amt;
      IF v_balance_due != 0 THEN
       v_balance_due := v_collection_amt * ABS(((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) / v_balance_due);
      END IF;
      IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
      END IF;
      p_premium_amt := v_collection_amt - v_balance_due;
      p_tax_amt := p_collection_amt - p_premium_amt;
     END LOOP rec;
    END LOOP c1_rec;

    IF v_switch != 'Y' THEN
     p_premium_amt := v_collection_amt;
     p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;  --v_tax_alloc = 'S' then

   IF v_tax_alloc IS  NULL THEN
   /*
   **therefore there are mixed tax allocations in the bill
   **process everything the same as the normal process except for evat
   **the excess amount after the process should be allocated to evat and premium
   */
    v_tax_inserted := 0;
    v_collection_amt := p_collection_amt;

    FOR c1_rec IN c5 ('F')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
      v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
      IF ABS(v_balance_due) > ABS(v_collection_amt) THEN
       v_balance_due := v_collection_amt;
      END IF;
      IF p_inst_no != 1 THEN
       v_balance_due := 0;
      END IF;
        v_collection_amt := v_collection_amt - v_balance_due;
     END LOOP rec;
    END LOOP c1_rec; --for 'F'

    v_tax_balance_due := 0;
    v_tax_inserted := 0;

    FOR c1_rec IN c5 ('S')
    LOOP
     FOR rec IN c4 (c1_rec.tax_cd)
     LOOP
        v_tax_balance_due := (c1_rec.tax_amt / v_max_inst_no) - NVL(rec.tax_amt,0);
      END LOOP rec;
    END LOOP c1_rec;

    IF v_tax_balance_due != 0 THEN
     FOR c1_rec IN c5 ('S')
     LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
       IF ABS(v_balance_due) > ABS((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) THEN
         v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
       END IF;
       IF ABS(v_balance_due + v_tax_inserted) > ABS(v_collection_amt) THEN
         v_balance_due := v_collection_amt - v_tax_inserted;
       END IF;
       v_tax_inserted := v_tax_inserted + v_balance_due;
      END LOOP;
     END LOOP c1_rec;
    END IF;

    v_collection_amt := v_collection_amt - v_tax_inserted;

    FOR c1_rec IN c5  ('L')
    LOOP
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
      IF p_inst_no != v_max_inst_no THEN
        v_balance_due := 0;
      ELSE
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
          IF ABS(v_balance_due) > ABS(v_collection_amt) THEN
           v_balance_due := v_collection_amt;
          END IF;
       v_collection_amt := v_collection_amt - v_balance_due;
      END IF;
     END LOOP rec;
    END LOOP c1_rec;

    FOR c1_rec IN c3
    LOOP
     v_switch := 'Y'; --to check if bill has evat
     IF (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) OR
       (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no) THEN
      FOR rec IN c4a (c1_rec.tax_cd)
      LOOP
       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0) + p_max_premium_amt;
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
       p_premium_amt := v_collection_amt - v_balance_due;
       p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
     ELSIF c1_rec.tax_allocation = 'S' THEN
      FOR rec IN c4 (c1_rec.tax_cd)
      LOOP
       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_max_premium_amt;
       IF v_balance_due != 0 THEN
        v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_balance_due);
       END IF;
       p_premium_amt := v_collection_amt - v_balance_due;
       p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
     END IF;
    END LOOP c1_rec;
    IF v_switch != 'Y' THEN --no evat
      p_premium_amt := v_collection_amt;
      p_tax_amt := p_collection_amt - p_premium_amt;
    END IF;
   END IF;  --v_tax_alloc is  null
  END prem_to_be_pd_type3;

  /* Created By   : Vincent
  ** Date Created : 07172006
  ** Description  : Generates acct entries for the commission payments. Based from aeg_parameters_old of GIACS020.
  */
  PROCEDURE aeg_parameters_comm (
     aeg_tran_id    GIAC_ACCTRANS.tran_id%TYPE
    ,aeg_module_nm   GIAC_MODULES.module_name%TYPE
    ,aeg_sl_type_cd1  GIAC_PARAMETERS.param_name%TYPE
    ,aeg_sl_type_cd2  GIAC_PARAMETERS.param_name%TYPE
    ,aeg_sl_type_cd3  GIAC_PARAMETERS.param_name%TYPE
    ) IS

    CURSOR premium_cur IS
      SELECT c.iss_cd iss_cd,
             c.comm_amt,
             c.prem_seq_no bill_no,
             a.line_cd,
             c.intm_no,
             a.assd_no,
             x.acct_line_cd,
             a.type_cd,
             c.wtax_amt,
             c.input_vat_amt,
             DECODE(aeg_sl_type_cd1, 'ASSD_SL_TYPE', a.assd_no,
                                     'INTM_SL_TYPE', c.intm_no,
                                     'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd1,
             DECODE(aeg_sl_type_cd2, 'ASSD_SL_TYPE', a.assd_no,
                                     'INTM_SL_TYPE', c.intm_no,
                                     'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd2,
             DECODE(aeg_sl_type_cd3, 'ASSD_SL_TYPE', a.assd_no,
                                     'INTM_SL_TYPE', c.intm_no,
                                     'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd3
        FROM GIPI_POLBASIC a,
             GIPI_INVOICE  b,
             GIAC_COMM_PAYTS c,
             GIIS_LINE x
       WHERE a.policy_id    = b.policy_id
         AND b.iss_cd       = c.iss_cd
         AND b.prem_seq_no  = c.prem_seq_no
         AND c.tran_type   != 5
         AND c.gacc_tran_id = aeg_tran_id
         AND a.line_cd      = x.line_cd;

    --Negative factor used for collection amt
    negative_one  NUMBER := 1;
    w_sl_cd       GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    v_intm_no     GIAC_COMM_PAYTS.intm_no%TYPE;

  BEGIN
    pvar_tran_id := aeg_tran_id;
    pvar_sl_type_cd1 := aeg_sl_type_cd1;
    pvar_sl_type_cd2 := aeg_sl_type_cd2;
    pvar_sl_type_cd3 := aeg_sl_type_cd3;
    pvar_comm_take_up := Giacp.n('COMM_PAYABLE_TAKE_UP');

    BEGIN
      SELECT module_id,
             generation_type
        INTO pvar_module_id,
             pvar_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table GIAC_MODULES: '||aeg_module_nm||'.');
    END;

    IF pvar_comm_take_up IN (1,2) THEN
      BEGIN
        FOR premium_rec IN premium_cur
        LOOP
          pvar_item_num := pvar_comm_take_up; --added by alfie 11132009 start
          pvar_bill_no := premium_rec.bill_no;
          pvar_issue_cd := premium_rec.iss_cd; --end
          premium_rec.comm_amt := NVL(premium_rec.comm_amt, 0) * negative_one;
          IF premium_rec.assd_no IS NULL THEN
            FOR i IN
              (SELECT d.assd_no assd_no
                 FROM GIPI_POLBASIC a,
                      GIPI_INVOICE  b,
                      GIPI_PARLIST d,
                      GIAC_COMM_PAYTS c
                WHERE a.policy_id    = b.policy_id
                  AND b.iss_cd       = premium_rec.iss_cd
                  AND b.prem_seq_no  = premium_rec.bill_no
                  AND c.tran_type   != 5
                  AND a.par_id       = d.par_id
                  AND c.gacc_tran_id = pvar_tran_id)
            LOOP
              premium_rec.assd_no := i.assd_no;
            END LOOP;
          END IF;

          Upload_Dpc.comm_payable_proc (premium_rec.intm_no,       premium_rec.assd_no,
                                        premium_rec.acct_line_cd,  premium_rec.comm_amt,
                                        premium_rec.wtax_amt,      premium_rec.line_cd,
                                        premium_rec.input_vat_amt, premium_rec.sl_cd1,
                                        premium_rec.sl_cd2,        premium_rec.sl_cd3);
        END LOOP;
      /* Premium receivables has a DR_CR_TAG of 'D' which means that
      ** the normal take up is DEBIT.  It has to be multiplied by -1 to
      ** make it on the CREDIT side but the value is still POSITIVE.
      ** This is handled by the function ABS(). */
      END;
    ELSE
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#This module was designed to upload data only if the parameter: COMM_PAYABLE_TAKE_UP = 1 or 2.');
    END IF;
  END aeg_parameters_comm;

  /* Created By   : Vincent
  ** Date Created : 07172006
  ** Description  : Part of generation of acct entries for the commission payments. Based from get_sl_code_new of GIACS020.
  */
  PROCEDURE get_sl_code (
     p_intm_no           IN NUMBER
    ,p_assd_no           IN NUMBER
    ,p_acct_line_cd      IN NUMBER
    ,p_sl_cd_c          OUT NUMBER
    ,p_sl_cd_t          OUT NUMBER
    ,p_sl_cd_i          OUT NUMBER
    ,p_gl_intm_no       OUT NUMBER
    ) IS

    v_parent_intm_no  NUMBER;
    v_acct_intm_cd   NUMBER;
    v_lic_tag         VARCHAR2(1);
    v_loop            BOOLEAN;
    v_intm_no         NUMBER;
    p_sl_cd           NUMBER;
    l_sl_cd           NUMBER;

  BEGIN
    /* getting the sl_cd for the 1st item which is commission payable */
    IF pvar_sl_type_cd1 = 'LINE_SL_TYPE' THEN
      l_sl_cd := p_acct_line_cd;
      p_sl_cd_c := l_sl_cd;
    ELSIF pvar_sl_type_cd1 = 'ASSD_SL_TYPE' THEN
      p_sl_cd:= p_assd_no;
      p_sl_cd_c := p_sl_cd;
    ELSIF pvar_sl_type_cd1 = 'INTM_SL_TYPE' THEN
      BEGIN
        v_loop := TRUE;
        v_intm_no:= p_intm_no;
        WHILE v_loop LOOP
          BEGIN
            SELECT a.parent_intm_no, b.acct_intm_cd, a.lic_tag
              INTO v_parent_intm_no, v_acct_intm_cd, v_lic_tag
              FROM GIIS_INTERMEDIARY a, GIIS_INTM_TYPE b
             WHERE a.intm_type = b.intm_type
               AND a.intm_no   = v_intm_no;

            IF v_parent_intm_no IS NULL THEN
             p_sl_cd_c := v_intm_no;
             p_gl_intm_no := v_acct_intm_cd;
             v_loop := FALSE;
            ELSE
             p_sl_cd_c := v_intm_no;
              p_gl_intm_no := v_acct_intm_cd;
            v_loop := FALSE;
            END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#Parent Intermediary No. does not exist. Intermediary No. = '||TO_CHAR(v_intm_no));
          END;
        END LOOP;
      END;
    ELSE
      p_sl_cd_c := NULL;
    END IF;
  ---
  ---
  ---
    /* getting the sl_cd for the 2nd item which is witholding tax */
    IF pvar_sl_type_cd2 = 'LINE_SL_TYPE' THEN
      l_sl_cd := p_acct_line_cd;
      p_sl_cd_t := l_sl_cd;
    ELSIF pvar_sl_type_cd2 = 'ASSD_SL_TYPE' THEN
      p_sl_cd := p_assd_no;
      p_sl_cd_t := p_sl_cd;
    ELSIF pvar_sl_type_cd2 = 'INTM_SL_TYPE'  THEN
      BEGIN
        v_loop := TRUE;
        v_intm_no := p_intm_no;
        WHILE v_loop LOOP
          BEGIN
            SELECT a.parent_intm_no,b.acct_intm_cd,a.lic_tag
              INTO v_parent_intm_no,v_acct_intm_cd,v_lic_tag
              FROM GIIS_INTERMEDIARY a, GIIS_INTM_TYPE b
             WHERE a.intm_type = b.intm_type
               AND a.intm_no   = v_intm_no;

            IF v_parent_intm_no IS NULL THEN
             p_sl_cd_t := v_intm_no;
             p_gl_intm_no := v_acct_intm_cd;
             v_loop := FALSE;
          ELSE
              p_sl_cd_t := v_intm_no;
              p_gl_intm_no := v_acct_intm_cd;
              v_loop := FALSE;
           END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#Parent Intermediary No. does not exist. Intermediary No. = '||TO_CHAR(v_intm_no));
          END;
        END LOOP;
      END;
    ELSE
      p_sl_cd_t := NULL;
    END IF;
  ---
  ---
  ---
    /* getting the sl_cd for the 3rd item which is input_vat */
    IF pvar_sl_type_cd3 = 'LINE_SL_TYPE' THEN
      l_sl_cd := p_acct_line_cd;
      p_sl_cd_i := l_sl_cd;
    ELSIF pvar_sl_type_cd3 = 'ASSD_SL_TYPE' THEN
      p_sl_cd:= p_assd_no;
      p_sl_cd_I := p_sl_cd;
    ELSIF pvar_sl_type_cd3 = 'INTM_SL_TYPE' THEN
      BEGIN
        v_loop := TRUE;
        v_intm_no:= p_intm_no;
        WHILE v_loop LOOP
          BEGIN
            SELECT a.parent_intm_no, b.acct_intm_cd, a.lic_tag
              INTO v_parent_intm_no, v_acct_intm_cd, v_lic_tag
              FROM GIIS_INTERMEDIARY a, GIIS_INTM_TYPE b
             WHERE a.intm_type = b.intm_type
               AND a.intm_no   = v_intm_no;

            IF v_parent_intm_no IS NULL THEN
             p_sl_cd_i := v_intm_no;
             p_gl_intm_no := v_acct_intm_cd;
             v_loop := FALSE;
          ELSE
            p_sl_cd_i := v_intm_no;
             p_gl_intm_no := v_acct_intm_cd;
            v_loop := FALSE;
            END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#Parent Intermediary No. does not exist. Intermediary No. = '||TO_CHAR(v_intm_no));
          END;
        END LOOP;
      END;
    ELSE
      p_sl_cd_i := NULL;
    END IF;
  END get_sl_code;

  /* Created By   : Vincent
  ** Date Created : 07172006
  ** Description  : Part of generation of acct entries for the commission payments. Based from comm_payable_proc_old of GIACS020.
  */
  PROCEDURE comm_payable_proc (
     p_intm_no       IN GIAC_COMM_PAYTS.intm_no%TYPE
    ,p_assd_no       IN GIPI_POLBASIC.assd_no%TYPE
    ,p_acct_line_cd  IN GIIS_LINE.acct_line_cd%TYPE
    ,p_comm_amt      IN GIAC_COMM_PAYTS.comm_amt%TYPE
    ,p_wtax_amt      IN GIAC_COMM_PAYTS.wtax_amt%TYPE
    ,p_line_cd       IN GIIS_LINE.line_cd%TYPE
    ,p_input_vat_amt IN GIAC_COMM_PAYTS.input_vat_amt%TYPE
    ,p_sl_cd1        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,p_sl_cd2        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,p_sl_cd3        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ) IS

    w_sl_cd                  GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    y_sl_cd                  GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    z_sl_cd                  GIAC_ACCT_ENTRIES.sl_cd%TYPE;

    v_gl_acct_category       GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    v_gl_control_acct        GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    v_gl_sub_acct_1          GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    v_gl_sub_acct_2          GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    v_gl_sub_acct_3          GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    v_gl_sub_acct_4          GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    v_gl_sub_acct_5          GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    v_gl_sub_acct_6          GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_sub_acct_7          GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    v_intm_type_level        GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    v_line_dependency_level  GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    v_dr_cr_tag              GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    v_debit_amt             GIAC_ACCT_ENTRIES.debit_amt%TYPE := 0;
    v_credit_amt            GIAC_ACCT_ENTRIES.credit_amt%TYPE := 0;
    v_acct_entry_id         GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
    v_gen_type              GIAC_MODULES.generation_type%TYPE;
    v_gl_acct_id            GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    v_sl_type_cd            GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    v_sl_type_cd2            GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    v_sl_type_cd3            GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    ws_line_cd             GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_intm_no             GIAC_COMM_PAYTS.intm_no%TYPE;
    ws_acct_intm_cd          GIIS_INTM_TYPE.acct_intm_cd%TYPE;

    /*AC-SPECS-2009-059 reference module: GIACS020 (latest version ni sir jason)  alfie 11-16-2009*/
    v_epc_param     GIAC_PARAMETERS.param_value_v%TYPE := Giacp.v('ENTER_PREPAID_COMM');     --alfie 11-16-2009
    v_tax_ent_p  GIAC_PARAMETERS.param_value_v%TYPE := Giacp.v('TAX_ENTRY_ON_COMM_PAYT');     --alfie 11-16-2009
    v_wtax_item  GIAC_MODULE_ENTRIES.item_no%TYPE;  --alfie 11-16-2009: will hold the giac_module_entries item number for wtax entry generation
    v_invat_item GIAC_MODULE_ENTRIES.item_no%TYPE;  --alfie 11-16-2009: will hold the giac_module_entries item number for input vat entry generation
    v_adv_payt  VARCHAR2(1) := 'N';  --alfie 11-16-2009: Y - payment is advance

  BEGIN

    FOR m IN (SELECT 1 exist
                  FROM GIAC_ADVANCED_PAYT
                 WHERE prem_seq_no = pvar_bill_no
                   AND iss_cd = pvar_issue_cd)
    LOOP
     v_adv_payt := 'Y';
    END LOOP;

    --assign values for item no variables for wtax and input vat acct entry generation
    IF NVL(v_tax_ent_p,'A') = 'A' AND v_adv_payt = 'Y' THEN
      v_wtax_item := 9;
      v_invat_item := 8;
    ELSE
      v_wtax_item := 4;
      v_invat_item := 5;
    END IF;

    --assign values for item no variable for acctg entry generation of commission
    IF NVL(v_epc_param,'N') = 'Y' AND v_adv_payt = 'Y' THEN
      --: insert record in giac_prepaid_comm table
        FOR j IN (SELECT a.gacc_tran_id, b.policy_id, a.tran_type,
                         a.intm_no, a.iss_cd, a.prem_seq_no, a.comm_amt,
                         a.wtax_amt, a.input_vat_amt, c.multi_booking_mm,
                         c.multi_booking_yy
                    FROM GIAC_COMM_PAYTS a, GIPI_POLBASIC b, GIPI_INVOICE c
                      WHERE a.iss_cd = c.iss_cd
                        AND a.prem_seq_no = c.prem_seq_no
                        AND b.policy_id = c.policy_id
                        AND a.iss_cd = pvar_issue_cd
                        AND a.prem_seq_no = pvar_bill_no)
        LOOP
          --issue an update statement to avoid duplicate records since the table has no primary key constraint
          UPDATE giac_prepaid_comm
            SET gacc_tran_id = j.gacc_tran_id,
                comm_amt = j.comm_amt,
                wtax_amt = j.wtax_amt,
                input_vat_amt = j.input_vat_amt,
                user_id = USER,
                last_update = SYSDATE,
                booking_mth = j.multi_booking_mm,
                booking_year = j.multi_booking_yy
              WHERE policy_id = j.policy_id
                AND transaction_type = j.tran_type
                AND iss_cd = j.iss_cd
                AND prem_seq_no = j.prem_seq_no
                AND intm_no = j.intm_no;

         IF SQL%NOTFOUND THEN  --insert the record if there were no records updated
           INSERT INTO giac_prepaid_comm
                       (gacc_tran_id,   policy_id,   transaction_type,
                        intm_no,        iss_cd,      prem_seq_no,
                        comm_amt,       wtax_amt,    input_vat_amt,
                        user_id,        last_update, booking_mth,
                       booking_year)
              VALUES (j.gacc_tran_id,  j.policy_id,    j.tran_type,
                      j.intm_no,       j.iss_cd,       j.prem_seq_no,
                      j.comm_amt,      j.wtax_amt,     j.input_vat_amt,
                      USER,            SYSDATE,        j.multi_booking_mm,
                      j.multi_booking_yy);
        END IF;
      END LOOP;
    pvar_item_num := 7;  --generate prepaid comm
  ELSE
    pvar_item_num := pvar_comm_take_up; --generate comm payable
  END IF;

    Upload_Dpc.get_sl_code (p_intm_no,    p_assd_no,    p_acct_line_cd,
                            w_sl_cd,      y_sl_cd,      z_sl_cd,
                            v_gl_intm_no);

    BEGIN
      SELECT a.gl_acct_category, a.gl_control_acct,
             NVL(a.gl_sub_acct_1,0), NVL(a.gl_sub_acct_2,0), NVL(a.gl_sub_acct_3,0), NVL(a.gl_sub_acct_4,0),
             NVL(a.gl_sub_acct_5,0), NVL(a.gl_sub_acct_6,0), NVL(a.gl_sub_acct_7,0), NVL(a.intm_type_level,0),
             a.dr_cr_tag,b.generation_type,a.sl_type_cd,a.line_dependency_level
        INTO v_gl_acct_category, v_gl_control_acct,
             v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4,
             v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7, v_intm_type_level,
             v_dr_cr_tag,v_gen_type, v_sl_type_cd, v_line_dependency_level
          FROM GIAC_MODULE_ENTRIES a, GIAC_MODULES b
            WHERE b.module_name = 'GIACS020'
              AND a.item_no     = pvar_item_num
              AND b.module_id   = a.module_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table giac_module_entries. Item no. '||pvar_item_num||' for GIACS020.');
    END;

    IF v_intm_type_level != 0 THEN
      ws_acct_intm_cd := v_gl_intm_no;
      Upload_Dpc.aeg_check_level (v_intm_type_level, ws_acct_intm_cd,
                                  v_gl_sub_acct_1,   v_gl_sub_acct_2,
                                  v_gl_sub_acct_3,   v_gl_sub_acct_4,
                                  v_gl_sub_acct_5,   v_gl_sub_acct_6,
                                  v_gl_sub_acct_7);
    END IF;

    IF v_line_dependency_level != 0 THEN
      BEGIN
        SELECT acct_line_cd
          INTO ws_line_cd
          FROM GIIS_LINE
         WHERE line_cd = p_line_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table giis_line. Line code '||p_line_cd||'.');
      END;

      Upload_Dpc.aeg_check_level (v_line_dependency_level, ws_line_cd,
                                  v_gl_sub_acct_1,         v_gl_sub_acct_2,
                                  v_gl_sub_acct_3,         v_gl_sub_acct_4,
                                  v_gl_sub_acct_5,         v_gl_sub_acct_6,
                                  v_gl_sub_acct_7);
    END IF;

    Upload_Dpc.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
                                        v_gl_sub_acct_1,    v_gl_sub_acct_2,
                                        v_gl_sub_acct_3,    v_gl_sub_acct_4,
                                        v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                        v_gl_sub_acct_7,    v_gl_acct_id);

    IF p_comm_amt > 0 THEN
      IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := p_comm_amt;
        v_credit_amt := 0;
      ELSE
        v_debit_amt  := 0;
        v_credit_amt := p_comm_amt;
      END IF;
    ELSIF p_comm_amt < 0 THEN
      IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := 0;
        v_credit_amt := p_comm_amt * -1;
      ELSE
        v_debit_amt  := p_comm_amt * -1;
        v_credit_amt := 0;
      END IF;
    END IF;

    Upload_Dpc.aeg_ins_upd_comm_acct_entries (v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
                                              v_gl_sub_acct_3,    v_gl_sub_acct_4,   v_gl_sub_acct_5, v_gl_sub_acct_6,
                                              v_gl_sub_acct_7,    v_sl_type_cd,      '1',             w_sl_cd,
                                              v_gen_type,         v_gl_acct_id,      v_debit_amt,     v_credit_amt);

    --For Withholding Tax Payable
    BEGIN
      IF NVL(p_wtax_amt,0) <> 0 THEN
        BEGIN
          SELECT a.gl_acct_category, a.gl_control_acct,
                 NVL(a.gl_sub_acct_1,0), NVL(a.gl_sub_acct_2,0), NVL(a.gl_sub_acct_3,0), NVL(a.gl_sub_acct_4,0),
                 NVL(a.gl_sub_acct_5,0), NVL(a.gl_sub_acct_6,0), NVL(a.gl_sub_acct_7,0),a.sl_type_cd, NVL(a.intm_type_level,0), a.dr_cr_tag,
                 b.generation_type
            INTO v_gl_acct_category, v_gl_control_acct,
                 v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4,
                 v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7,v_sl_type_cd, v_intm_type_level, v_dr_cr_tag,
                 v_gen_type
              FROM GIAC_MODULE_ENTRIES a, GIAC_MODULES b
                WHERE b.module_name = 'GIACS020'
                  --AND a.item_no     = 4
                  AND a.item_no = v_wtax_item --alfie 11162009
                  AND b.module_id   = a.module_id; --:)
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table giac_module_entries. Item no. 4 for GIACS020.');
        END;

        Upload_Dpc.aeg_check_level (v_intm_type_level, p_sl_cd2,
                                    v_gl_sub_acct_1,   v_gl_sub_acct_2,
                                    v_gl_sub_acct_3,   v_gl_sub_acct_4,
                                    v_gl_sub_acct_5,   v_gl_sub_acct_6,
                                    v_gl_sub_acct_7);

        Upload_Dpc.aeg_check_chart_of_accts (v_gl_acct_category, v_gl_control_acct,
                                             v_gl_sub_acct_1,    v_gl_sub_acct_2,
                                             v_gl_sub_acct_3,    v_gl_sub_acct_4,
                                             v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                             v_gl_sub_acct_7,    v_gl_acct_id);

        --Intermediary as the SL code
        IF p_wtax_amt > 0 THEN
          IF v_dr_cr_tag = 'D' THEN
            v_debit_amt  := p_wtax_amt;
            v_credit_amt := 0;
          ELSE
            v_debit_amt  := 0;
            v_credit_amt := p_wtax_amt;
          END IF;
        ELSIF p_wtax_amt < 0 THEN
          IF v_dr_cr_tag = 'D' THEN
            v_debit_amt  := 0;
            v_credit_amt := p_wtax_amt * -1;
          ELSE
            v_debit_amt  := p_wtax_amt * -1;
            v_credit_amt := 0;
          END IF;
        END IF;

        Upload_Dpc.aeg_ins_upd_comm_acct_entries (v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
                                                  v_gl_sub_acct_3,    v_gl_sub_acct_4,   v_gl_sub_acct_5, v_gl_sub_acct_6,
                                                  v_gl_sub_acct_7,    v_sl_type_cd,      '1',             y_sl_cd,
                                                  v_gen_type,         v_gl_acct_id,      v_debit_amt,     v_credit_amt);
      END IF;
    END;

    --For Input VAT
    IF NVL(p_input_vat_amt,0) != 0 THEN
      BEGIN
        SELECT a.gl_acct_category, a.gl_control_acct,
               NVL(a.gl_sub_acct_1,0), NVL(a.gl_sub_acct_2,0), NVL(a.gl_sub_acct_3,0), NVL(a.gl_sub_acct_4,0),
               NVL(a.gl_sub_acct_5,0), NVL(a.gl_sub_acct_6,0), NVL(a.gl_sub_acct_7,0),a.sl_type_cd,
               NVL(a.intm_type_level,0), a.dr_cr_tag,
               b.generation_type, a.gl_acct_category, a.gl_control_acct
          INTO v_gl_acct_category, v_gl_control_acct,
               v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4,
               v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7,v_sl_type_cd,
               v_intm_type_level, v_dr_cr_tag,
               v_gen_type, v_gl_acct_category, v_gl_control_acct
            FROM GIAC_MODULE_ENTRIES a, GIAC_MODULES b
              WHERE b.module_name = 'GIACS020'
                --AND a.item_no     = 5 --alfie 11162009
                AND a.item_no = v_invat_item --:)
                AND b.module_id   = a.module_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in table giac_module_entries. Item no. 5 for GIACS020.');
      END;

      Upload_Dpc.aeg_check_chart_of_accts (v_gl_acct_category, v_gl_control_acct,
                                           v_gl_sub_acct_1,    v_gl_sub_acct_2,
                                           v_gl_sub_acct_3,    v_gl_sub_acct_4,
                                           v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                           v_gl_sub_acct_7,    v_gl_acct_id);

      IF p_input_vat_amt > 0 THEN
        IF v_dr_cr_tag = 'D' THEN
         v_debit_amt  := p_input_vat_amt;
         v_credit_amt := 0;
        ELSE
         v_debit_amt  := 0;
         v_credit_amt := p_input_vat_amt;
        END IF;
      ELSIF p_wtax_amt < 0 THEN
        IF v_dr_cr_tag = 'D' THEN
          v_debit_amt  := 0;
          v_credit_amt := p_input_vat_amt * -1;
        ELSE
          v_debit_amt  := p_input_vat_amt * -1;
          v_credit_amt := 0;
        END IF;
      END IF;

      Upload_Dpc.aeg_ins_upd_comm_acct_entries (v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
                                                v_gl_sub_acct_3,    v_gl_sub_acct_4,   v_gl_sub_acct_5, v_gl_sub_acct_6,
                                                v_gl_sub_acct_7,    v_sl_type_cd,      '1',             z_sl_cd,
                                                v_gen_type,         v_gl_acct_id,      v_debit_amt,     v_credit_amt);
    END IF;
  END comm_payable_proc;

  /* Created By   : Vincent
  ** Date Created : 07172006
  ** Description  : Part of generation of acct entries for the commission payments. Based from insert_update_acct_entries of GIACS020.
  */
  PROCEDURE aeg_ins_upd_comm_acct_entries (
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE
    ,iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE
    ,iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE
    ,iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE
    ,iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE
    ,iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE
    ,iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE
    ,iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE
    ,iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ,iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    ,iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE
    ,iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE
    ,iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
    ,iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE
    ,iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE
    ,iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE
    ) IS

    iuae_acct_entry_id     GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
       AND gl_sub_acct_2       = iuae_gl_sub_acct_2
       AND gl_sub_acct_3       = iuae_gl_sub_acct_3
       AND gl_sub_acct_4       = iuae_gl_sub_acct_4
       AND gl_sub_acct_5       = iuae_gl_sub_acct_5
       AND gl_sub_acct_6       = iuae_gl_sub_acct_6
       AND gl_sub_acct_7       = iuae_gl_sub_acct_7
       AND NVL(sl_cd,1)        = NVL(iuae_sl_cd,1)
       AND generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id
       AND gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id;

    IF NVL(iuae_acct_entry_id,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
      INSERT INTO GIAC_ACCT_ENTRIES
          (gacc_tran_id,         gacc_gfun_fund_cd,
           gacc_gibr_branch_cd,  acct_entry_id,
           gl_acct_id,           gl_acct_category,
           gl_control_acct,      gl_sub_acct_1,
           gl_sub_acct_2,        gl_sub_acct_3,
           gl_sub_acct_4,        gl_sub_acct_5,
           gl_sub_acct_6,        gl_sub_acct_7,
           sl_type_cd,           sl_source_cd,
           sl_cd,                debit_amt,
           credit_amt,           generation_type,
           user_id,              last_update)
        VALUES
          (pvar_tran_id,          pvar_fund_cd,
           pvar_branch_cd,        iuae_acct_entry_id,
           iuae_gl_acct_id,       iuae_gl_acct_category,
           iuae_gl_control_acct,  iuae_gl_sub_acct_1,
           iuae_gl_sub_acct_2,    iuae_gl_sub_acct_3,
           iuae_gl_sub_acct_4,    iuae_gl_sub_acct_5,
           iuae_gl_sub_acct_6,    iuae_gl_sub_acct_7,
           iuae_sl_type_cd,       '1',
           iuae_sl_cd,            iuae_debit_amt,
           iuae_credit_amt,       iuae_generation_type,
           USER,                  SYSDATE);
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  =  iuae_debit_amt + debit_amt,
             credit_amt =  iuae_credit_amt + credit_amt
       WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
         AND NVL(sl_cd,1)        =  NVL(iuae_sl_cd,1)
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
    END IF;
  END aeg_ins_upd_comm_acct_entries;

  /* Created By   : Vincent
  ** Date Created : 08222006
  ** Description  : Updates the file status in giac_upload_file. Used by GIACS001, GIACS050, GIACS053.
  */
  PROCEDURE upd_guf(
     p_gacc_tran_id GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    ) IS

   v_upload_tag  GIAC_ORDER_OF_PAYTS.upload_tag%TYPE := 'N';
    v_source_cd    GIAC_UPLOAD_FILE.source_cd%TYPE;
    v_file_no      GIAC_UPLOAD_FILE.file_no%TYPE;
    v_flag_ctr     NUMBER := 0;
    v_flag         VARCHAR2(1);
    v_module_name  VARCHAR2(10);

  BEGIN
   FOR rec IN (SELECT NVL(upload_tag,'N') upload_tag
            FROM GIAC_ORDER_OF_PAYTS
            WHERE gacc_tran_id = p_gacc_tran_id)
   LOOP
    v_upload_tag := rec.upload_tag;
   END LOOP;

   IF v_upload_tag = 'Y' THEN
      FOR a1 IN (SELECT source_cd, file_no, 'GIACS603' module_name
                   FROM GIAC_UPLOAD_PREM
                  WHERE tran_id = p_gacc_tran_id
                  UNION ALL
                 SELECT source_cd, file_no, 'GIACS604' module_name
                   FROM GIAC_UPLOAD_PREM_ATM
                  WHERE tran_id = p_gacc_tran_id
                  UNION ALL
                 SELECT source_cd, file_no, 'GIACS607' module_name
                   FROM GIAC_UPLOAD_PREM_COMM
                  WHERE tran_id = p_gacc_tran_id
                  )
      LOOP
        v_source_cd := a1.source_cd;
        v_file_no := a1.file_no;
        v_module_name := a1.module_name;
        EXIT;
      END LOOP a1;

      FOR b1 IN (SELECT COUNT(DISTINCT giop.or_flag) flag_ctr, giop.or_flag
                   FROM GIAC_ORDER_OF_PAYTS giop, GIAC_UPLOAD_PREM giup
                  WHERE 1=1
                    AND giop.or_flag IN ('P','N')
                    AND giop.gacc_tran_id = giup.tran_id
                    AND source_cd = v_source_cd
                    AND file_no = v_file_no
                    AND v_module_name = 'GIACS603'
                  GROUP BY giop.or_flag
                  UNION ALL
          SELECT COUNT(DISTINCT giop.or_flag), giop.or_flag
                   FROM GIAC_ORDER_OF_PAYTS giop, GIAC_UPLOAD_PREM_ATM gupa
                  WHERE 1=1
                    AND giop.or_flag IN ('P','N')
                    AND giop.gacc_tran_id = gupa.tran_id
                    AND source_cd = v_source_cd
                    AND file_no = v_file_no
                    AND v_module_name = 'GIACS604'
                  GROUP BY giop.or_flag
                  --Vincent 08222006
                  UNION ALL
          SELECT COUNT(DISTINCT giop.or_flag), giop.or_flag
                   FROM GIAC_ORDER_OF_PAYTS giop, GIAC_UPLOAD_PREM_COMM gupc
                  WHERE 1=1
                    AND giop.or_flag IN ('P','N')
                    AND giop.gacc_tran_id = gupc.tran_id
                    AND source_cd = v_source_cd
                    AND file_no = v_file_no
                    AND v_module_name = 'GIACS607'
                  GROUP BY giop.or_flag
                  )
      LOOP
     v_flag_ctr := v_flag_ctr + b1.flag_ctr;
     v_flag := b1.or_flag;
      END LOOP b1;

    IF v_flag_ctr > 1 THEN
     UPDATE GIAC_UPLOAD_FILE
        SET file_status = 3
      WHERE source_cd = v_source_cd
        AND file_no = v_file_no;
    ELSIF v_flag_ctr = 1 THEN
       IF v_flag = 'P' THEN
      UPDATE GIAC_UPLOAD_FILE
         SET file_status = 4
       WHERE source_cd = v_source_cd
         AND file_no = v_file_no;
       ELSIF v_flag = 'N' THEN
         UPDATE GIAC_UPLOAD_FILE
         SET file_status = 2
       WHERE source_cd = v_source_cd
         AND file_no = v_file_no;
       END IF;
    END IF;
   END IF;
  END upd_guf;

  /* Created By   : Vincent
  ** Date Created : 09072006
  ** Description  : Updates the file status in giac_upload_file (for JV tran). Used by GIACS030.
  */
  PROCEDURE upd_guf_jv(
     p_gacc_tran_id  GIAC_ACCTRANS.tran_id%TYPE
    ,p_tran_seq_no   GIAC_ACCTRANS.tran_seq_no%TYPE
    ) IS
  BEGIN
  FOR rec IN (SELECT source_cd, file_no
                FROM GIAC_UPLOAD_FILE
               WHERE tran_class = 'JV'
                 AND tran_id = p_gacc_tran_id
                 AND file_status = 2)
  LOOP
   UPDATE GIAC_UPLOAD_FILE
      SET file_status = 4
    WHERE source_cd = rec.source_cd
      AND file_no = rec.file_no;

   UPDATE GIAC_UPLOAD_JV_PAYT_DTL
      SET tran_seq_no = p_tran_seq_no
    WHERE source_cd = rec.source_cd
      AND file_no = rec.file_no;
   EXIT;
  END LOOP;
  END upd_guf_jv;

  /* Created By   : Vincent
  ** Date Created : 09072006
  ** Description  : Updates the file status in giac_upload_file (for DV tran). Used by GIACS016.
  */
  PROCEDURE upd_guf_dv(
     p_gacc_tran_id  GIAC_ACCTRANS.tran_id%TYPE
    ) IS
  BEGIN
  FOR rec IN (SELECT source_cd, file_no
                FROM GIAC_UPLOAD_FILE
               WHERE tran_class = 'DV'
                 AND tran_id = p_gacc_tran_id
                 AND file_status = 2)
  LOOP
   UPDATE GIAC_UPLOAD_FILE
      SET file_status = 4
    WHERE source_cd = rec.source_cd
      AND file_no = rec.file_no;
   EXIT;
  END LOOP;
  END upd_guf_dv;

  /* Added By    : Jason
  ** Date Added  : 07/27/2007
  ** Description  : Responsible for creation of Cash in Bank acct entries
  */
  PROCEDURE aeg_create_cib_acct_entries (
     aeg_tran_id         GIAC_ACCTRANS.tran_id%TYPE,
  aeg_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
  aeg_fund_cd         GIAC_ACCTRANS.gfun_fund_cd%TYPE,
     aeg_bank_cd       GIAC_BANKS.bank_cd%TYPE,
     aeg_bank_acct_cd    GIAC_BANK_ACCOUNTS.bank_acct_cd%TYPE,
     aeg_acct_amt      GIAC_COLLECTION_DTL.amount%TYPE,
  aeg_gen_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
 ) IS

    v_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    v_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    v_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    v_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    v_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    v_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    v_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    v_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    v_dr_cr_tag         GIAC_CHART_OF_ACCTS.dr_cr_tag%TYPE;
    v_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    v_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    v_gl_acct_id        GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    v_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    v_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
 v_acct_entry_id     GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
    v_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE := '1';

  BEGIN
    BEGIN
      SELECT gl_acct_id, sl_cd
        INTO v_gl_acct_id, v_sl_cd
        FROM GIAC_BANK_ACCOUNTS
        WHERE bank_cd = aeg_bank_cd
        AND bank_acct_cd = aeg_bank_acct_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#No data found in giac_bank_accounts for bank_cd/bank_acct_cd: '
                                 ||aeg_bank_cd||'/'||aeg_bank_acct_cd);
    END;

 BEGIN
  SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
           gl_sub_acct_2,    gl_sub_acct_3,   gl_sub_acct_4,
           gl_sub_acct_5,    gl_sub_acct_6,   gl_sub_acct_7,
           dr_cr_tag,        gslt_sl_type_cd
      INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,
       v_gl_sub_acct_2,    v_gl_sub_acct_3,   v_gl_sub_acct_4,
       v_gl_sub_acct_5,    v_gl_sub_acct_6,   v_gl_sub_acct_7,
       v_dr_cr_tag,        v_sl_type_cd
    FROM GIAC_CHART_OF_ACCTS
    WHERE gl_acct_id = v_gl_acct_id;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#No record in the Chart of Accounts for this GL ID '
                                 ||TO_CHAR(v_gl_acct_id,'fm999999'));
 END;

    /****************************************************************************
    * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
    * debit-credit tag to determine whether the positive amount will be debited *
    * or credited.                                                              *
    ****************************************************************************/

    IF v_dr_cr_tag = 'D' THEN
      v_debit_amt  := ABS(aeg_acct_amt);
      v_credit_amt := 0;
    ELSE
      v_debit_amt  := 0;
      v_credit_amt := ABS(aeg_acct_amt);
    END IF;

    /****************************************************************************
    * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
    * same transaction id.  Insert the record if it does not exists else update *
    * the existing record.                                                      *
    ****************************************************************************/

 BEGIN
   SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
     INTO v_acct_entry_id
     FROM GIAC_ACCT_ENTRIES
      WHERE gacc_gibr_branch_cd = aeg_branch_cd
        AND gacc_gfun_fund_cd   = aeg_fund_cd
        AND gacc_tran_id        = aeg_tran_id
        AND gl_acct_id          = v_gl_acct_id
        AND generation_type     = aeg_gen_type
     AND NVL(sl_cd, 0)          = NVL(v_sl_cd, NVL(sl_cd, 0))
     AND NVL(sl_type_cd, '-')   = NVL(v_sl_type_cd, NVL(sl_type_cd, '-'))
     AND NVL(sl_source_cd, '-') = NVL(v_sl_source_cd, NVL(sl_source_cd, '-'));

   IF NVL(v_acct_entry_id,0) = 0 THEN
     v_acct_entry_id := NVL(v_acct_entry_id,0) + 1;
     INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id,        gacc_gfun_fund_cd,
                                   gacc_gibr_branch_cd, acct_entry_id,
                                   gl_acct_id,          gl_acct_category,
                                   gl_control_acct,     gl_sub_acct_1,
                                   gl_sub_acct_2,       gl_sub_acct_3,
                                   gl_sub_acct_4,       gl_sub_acct_5,
                                   gl_sub_acct_6,       gl_sub_acct_7,
                                   sl_cd,               debit_amt,
                                   credit_amt,          generation_type,
                                   user_id,             last_update,
                                   sl_type_cd,          sl_source_cd)
          VALUES (aeg_tran_id,          aeg_fund_cd,
                  aeg_branch_cd,                  v_acct_entry_id,
                  v_gl_acct_id,                   v_gl_acct_category,
                  v_gl_control_acct,              v_gl_sub_acct_1,
                  v_gl_sub_acct_2,                v_gl_sub_acct_3,
                  v_gl_sub_acct_4,                v_gl_sub_acct_5,
                  v_gl_sub_acct_6,                v_gl_sub_acct_7,
                  v_sl_cd,                        v_debit_amt,
                  v_credit_amt,                   aeg_gen_type,
                  USER,                           SYSDATE,
                  v_sl_type_cd ,                  v_sl_source_cd);
   ELSE
     UPDATE GIAC_ACCT_ENTRIES
       SET debit_amt  = debit_amt  + v_debit_amt,
           credit_amt = credit_amt + v_credit_amt,
           user_id = USER,
           last_update = SYSDATE
     WHERE gacc_tran_id       = aeg_tran_id
       AND gacc_gibr_branch_cd  = aeg_branch_cd
       AND gacc_gfun_fund_cd    = aeg_fund_cd
       AND gl_acct_id           = v_gl_acct_id
       AND NVL(sl_cd, 0)        = NVL(v_sl_cd, NVL(sl_cd, 0))
       AND NVL(sl_type_cd, '-') = NVL(v_sl_type_cd, NVL(sl_type_cd, '-'))
       AND NVL(sl_source_cd, '-') = NVL(v_sl_source_cd, NVL(sl_source_cd, '-'))
       AND generation_type      = aeg_gen_type;
   END IF;
 END;
  END;

  /*
  ** Added By    : Jason
  ** Date Added  : 07/27/2007
  ** Description : Delete all records existing in GIAC_ACCT_ENTRIES table having the same tran_id as the aeg_tran_id.
  **               Copied from GIACS001.
  */
  PROCEDURE AEG_Delete_Acct_Entries(
    aeg_tran_id          GIAC_ACCTRANS.tran_id%TYPE,
 aeg_gen_type   GIAC_ACCT_ENTRIES.generation_type%TYPE
  ) IS

    dummy  VARCHAR2(1);
    CURSOR AE IS
    SELECT '1'
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_tran_id    = aeg_tran_id
       AND generation_type = aeg_gen_type;

  BEGIN
    OPEN ae;
    FETCH ae INTO dummy;
    IF SQL%FOUND THEN

    /**************************************************************************
    *                                                                         *
    * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
    * tran_id as :GLOBAL.cg$giop_gacc_tran_id.                                *
    *                                                                         *
    **************************************************************************/

      DELETE FROM GIAC_ACCT_ENTRIES
       WHERE gacc_tran_id    = aeg_tran_id
         AND generation_type = aeg_gen_type;

    END IF;
  END;


  /* Created By   : Jenny Vi Lim
  ** Date Created : 1122006
  ** Description  : Generates acct entries for the collection in the inward facul
  */
  PROCEDURE aeg_parameters_inwfacul( aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
                            aeg_module_nm    GIAC_MODULES.module_name%TYPE,
                            aeg_sl_type_cd1  GIAC_PARAMETERS.param_name%TYPE,
                            aeg_sl_type_cd2  GIAC_PARAMETERS.param_name%TYPE) IS
    CURSOR pr_cur IS
      SELECT c.b140_iss_cd iss_cd      , c.collection_amt,
             c.b140_prem_seq_no bill_no, a.line_cd       ,
             DECODE(aeg_sl_type_cd1, 'ASSD_SL_TYPE', g.a020_assd_no,
          'RI_SL_TYPE',g.a180_ri_cd, 'LINE_SL_TYPE',h.acct_line_cd)sl_cd,
       a.type_cd, c.tax_amount, c.comm_vat
        FROM GIPI_POLBASIC a,
             GIPI_INVOICE  b,
             GIAC_INWFACUL_PREM_COLLNS c,
       GIAC_AGING_RI_SOA_DETAILS g,
       GIIS_LINE h
       WHERE a.policy_id    = b.policy_id
         AND b.iss_cd       = c.b140_iss_cd
         AND b.prem_seq_no  = c.b140_prem_seq_no
         AND g.a150_line_cd = h.line_cd
         AND b.prem_seq_no = g.prem_seq_no
      AND c.gacc_tran_id = aeg_tran_id;

    CURSOR PREMIUM_cur IS
      SELECT c.b140_iss_cd iss_cd, (c.premium_amt + c.tax_amount) premium_amt,
             c.b140_prem_seq_no bill_no, a.line_cd,
       DECODE(aeg_sl_type_cd1,'ASSD_SL_TYPE', g.a020_assd_no,
             'RI_SL_TYPE',g.a180_ri_cd, 'LINE_SL_TYPE',h.acct_line_cd)sl_cd,
             a.type_cd
        FROM GIPI_POLBASIC a,
             GIPI_INVOICE  b,
             GIAC_INWFACUL_PREM_COLLNS c,
             GIAC_AGING_RI_SOA_DETAILS g,
             GIIS_LINE h
       WHERE a.policy_id    = b.policy_id
         AND b.iss_cd       = c.b140_iss_cd
         AND b.prem_seq_no  = c.b140_prem_seq_no
         AND g.a150_line_cd = h.line_cd
         AND b.prem_seq_no = g.prem_seq_no
      AND c.gacc_tran_id = aeg_tran_id;

    CURSOR COMMISSION_cur IS
       SELECT c.b140_iss_cd iss_cd, c.comm_amt,
              c.b140_prem_seq_no bill_no, a.line_cd,
        DECODE(aeg_sl_type_cd2,'ASSD_SL_TYPE', g.a020_assd_no,
              'RI_SL_TYPE',g.a180_ri_cd, 'LINE_SL_TYPE',h.acct_line_cd)sl_cd,
              a.type_cd
         FROM GIPI_POLBASIC a,
              GIPI_INVOICE  b,
              GIAC_INWFACUL_PREM_COLLNS c,
              GIAC_AGING_RI_SOA_DETAILS g,
              GIIS_LINE h
        WHERE a.policy_id    = b.policy_id
          AND b.iss_cd       = c.b140_iss_cd
          AND b.prem_seq_no  = c.b140_prem_seq_no
          AND g.a150_line_cd = h.line_cd
          AND b.prem_seq_no = g.prem_seq_no
          AND c.comm_amt != 0
    AND c.gacc_tran_id = aeg_tran_id;

    v_negative_one     NUMBER := -1;
   v_inwprem_take_up  GIAC_PARAMETERS.param_value_v%TYPE;
 v_module_id     GIAC_MODULES.module_id%TYPE;
 v_gen_type     GIAC_MODULES.generation_type%TYPE;

  BEGIN
   BEGIN
      SELECT param_value_v
        INTO v_inwprem_take_up
        FROM GIAC_PARAMETERS
       WHERE param_name = 'INWPREM_TAKE_UP';

    END;

 BEGIN
   SELECT module_id,
             generation_type
        INTO v_module_id,
             v_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
 END;

 IF v_inwprem_take_up = 1 THEN
   FOR pr_rec IN pr_cur
   LOOP
     aeg_create_inwfacul_entries(pr_rec.sl_cd, v_module_id, 1, pr_rec.iss_cd,
                                pr_rec.bill_no, pr_rec.line_cd,
                                pr_rec.type_cd, pr_rec.collection_amt,
           v_gen_type);

        IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
    IF pr_rec.tax_amount <> 0 THEN
   FOR tax_rec IN 3..4
   LOOP
     aeg_create_inwfacul_entries(pr_rec.sl_cd, v_module_id , tax_rec, pr_rec.iss_cd,
                                      pr_rec.bill_no, pr_rec.line_cd,
                                      pr_rec.type_cd , pr_rec.tax_amount,
                                      v_gen_type);
      END LOOP ;
    END IF;

    IF pr_rec.comm_vat <> 0 THEN
   FOR comm_vat_rec IN 5..6
   LOOP
     aeg_create_inwfacul_entries(pr_rec.sl_cd, v_module_id, comm_vat_rec, pr_rec.iss_cd,
                                     pr_rec.bill_no , pr_rec.line_cd,
                                      pr_rec.type_cd , pr_rec.comm_vat,
                                      v_gen_type);
   END LOOP ;
       END IF;
  END IF;
   END LOOP;
 ELSIF v_inwprem_take_up = 2 THEN
   FOR premium_rec IN premium_cur
   LOOP
        aeg_create_inwfacul_entries(premium_rec.sl_cd, v_module_id, 1, premium_rec.iss_cd,
                                premium_rec.bill_no, premium_rec.line_cd,
                                premium_rec.type_cd, premium_rec.premium_amt,
                                         v_gen_type);

      END LOOP;

   FOR commission_rec IN commission_cur
   LOOP
        aeg_create_inwfacul_entries(commission_rec.sl_cd, v_module_id, 2, commission_rec.iss_cd,
                                commission_rec.bill_no, commission_rec.line_cd,
                                commission_rec.type_cd, commission_rec.comm_amt,
                                v_gen_type);
      END LOOP;
 END IF;
  END aeg_parameters_inwfacul;

  /* Created By   : Jenny Vi Lim
  ** Date Created : 1122006
  ** Description  : Creates acct entries for inward facul collection.
  */
  PROCEDURE aeg_create_inwfacul_entries (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
             aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
             aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
             aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
             aeg_line_cd            GIIS_LINE.line_cd%TYPE,
             aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
             aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
             aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE) IS
    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_sl_cd                         GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    ws_sl_type_cd                    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;

  BEGIN
    BEGIN
      SELECT gl_acct_category, gl_control_acct,
             gl_sub_acct_1   , gl_sub_acct_2  ,
             gl_sub_acct_3   , gl_sub_acct_4  ,
             gl_sub_acct_5   , gl_sub_acct_6  ,
             gl_sub_acct_7   , pol_type_tag   ,
             intm_type_level , old_new_acct_level,
             dr_cr_tag       , line_dependency_level,
             sl_type_cd
        INTO ws_gl_acct_category, ws_gl_control_acct,
             ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
             ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
             ws_gl_sub_acct_7   , ws_pol_type_tag   ,
             ws_intm_type_level , ws_old_new_acct_level,
             ws_dr_cr_tag       , ws_line_dep_level,
             ws_sl_type_cd
        FROM GIAC_MODULE_ENTRIES
       WHERE module_id = aeg_module_id
         AND item_no   = aeg_item_no
      FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_module_entries: ');
    END;

 IF ws_intm_type_level != 0 THEN
      BEGIN
        SELECT DISTINCT(c.acct_intm_cd)
          INTO ws_acct_intm_cd
          FROM GIPI_COMM_INVOICE a,
               GIIS_INTERMEDIARY b,
               GIIS_INTM_TYPE c
         WHERE a.intrmdry_intm_no = b.intm_no
           AND b.intm_type        = c.intm_type
           AND a.iss_cd           = aeg_iss_cd
           AND a.prem_seq_no      = aeg_bill_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giis_intm_type. ');
      END;

   aeg_check_level(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                      ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                      ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
    END IF;

 IF ws_line_dep_level != 0 THEN
      BEGIN
        SELECT acct_line_cd
          INTO ws_line_cd
          FROM GIIS_LINE
         WHERE line_cd = aeg_line_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giis_line. ');
      END;

      aeg_check_level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                      ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                      ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
    END IF;

 IF ws_old_new_acct_level != 0 THEN
      BEGIN
        BEGIN
          SELECT param_value_v
            INTO ws_iss_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'OLD_ISS_CD';
        END;

        BEGIN
          SELECT param_value_n
            INTO ws_old_acct_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'OLD_ACCT_CD';
        END;

        BEGIN
          SELECT param_value_n
            INTO ws_new_acct_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'NEW_ACCT_CD';
        END;

        IF aeg_iss_cd = ws_iss_cd THEN
          aeg_check_level(ws_old_new_acct_level, ws_old_acct_cd  , ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
        ELSE
          aeg_check_level(ws_old_new_acct_level, ws_new_acct_cd  , ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac parameters. ');
      END;
    END IF;

 IF ws_pol_type_tag = 'Y' THEN
      BEGIN
        SELECT NVL(gl_sub_acct_1,0), NVL(gl_sub_acct_2,0),
               NVL(gl_sub_acct_3,0), NVL(gl_sub_acct_4,0),
               NVL(gl_sub_acct_5,0), NVL(gl_sub_acct_6,0),
               NVL(gl_sub_acct_7,0)
          INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
               pt_gl_sub_acct_3, pt_gl_sub_acct_4,
               pt_gl_sub_acct_5, pt_gl_sub_acct_6,
               pt_gl_sub_acct_7
          FROM GIAC_POLICY_TYPE_ENTRIES
         WHERE line_cd = aeg_line_cd
           AND type_cd = aeg_type_cd;

        IF pt_gl_sub_acct_1 != 0 THEN
          ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
        END IF;

        IF pt_gl_sub_acct_2 != 0 THEN
          ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
        END IF;

        IF pt_gl_sub_acct_3 != 0 THEN
          ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
        END IF;

        IF pt_gl_sub_acct_4 != 0 THEN
          ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
        END IF;

  IF pt_gl_sub_acct_5 != 0 THEN
          ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
        END IF;

  IF pt_gl_sub_acct_6 != 0 THEN
          ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
        END IF;

  IF pt_gl_sub_acct_7 != 0 THEN
          ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
        END IF;

       EXCEPTION
          WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in giac_policy_type_entries. ');
      END;
    END IF;

 AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                             ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                             ws_gl_acct_id);

    IF aeg_acct_amt > 0 THEN
      IF ws_dr_cr_tag = 'D' THEN
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      END IF;
    ELSIF aeg_acct_amt < 0 THEN
      IF ws_dr_cr_tag = 'D' THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      ELSE
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      END IF;
    END IF;

 aeg_ins_up_inwfacul_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                   ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                   ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                   aeg_sl_cd          , ws_sl_type_cd     , aeg_gen_type,
                                   ws_gl_acct_id      , ws_debit_amt       , ws_credit_amt);
  END aeg_create_inwfacul_entries;

  PROCEDURE aeg_ins_up_inwfacul_entries (iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                 iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                 iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                 iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                 iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                 iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                 iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                 iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                 iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                 iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
                 iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
                 iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                 iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                 iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE) IS
 iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
      INTO iuae_acct_entry_id
      FROM GIAC_ACCT_ENTRIES
     WHERE gacc_gibr_branch_cd = pvar_branch_cd
       AND gacc_gfun_fund_cd   = pvar_fund_cd
       AND gacc_tran_id        = pvar_tran_id
       AND sl_cd               = iuae_sl_cd
       AND generation_type     = iuae_generation_type
       AND gl_acct_id          = iuae_gl_acct_id;

 IF NVL(iuae_acct_entry_id,0) = 0 THEN
   iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;

   INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                  gacc_gibr_branch_cd, acct_entry_id    ,
                                  gl_acct_id         , gl_acct_category ,
                                  gl_control_acct    , gl_sub_acct_1    ,
                                  gl_sub_acct_2      , gl_sub_acct_3    ,
                                  gl_sub_acct_4      , gl_sub_acct_5    ,
                                  gl_sub_acct_6      , gl_sub_acct_7    ,
                                  sl_cd              , debit_amt        ,
                                  credit_amt         , generation_type  ,
                                  user_id            , last_update,
                                  sl_type_cd         , sl_source_cd)
       VALUES (pvar_tran_id        , pvar_fund_cd       ,
               pvar_branch_cd     , iuae_acct_entry_id          ,
               iuae_gl_acct_id               , iuae_gl_acct_category       ,
               iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
               iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
               iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
               iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
               iuae_sl_cd                    , iuae_debit_amt              ,
               iuae_credit_amt               , iuae_generation_type        ,
               USER                 , SYSDATE,
      iuae_sl_type_cd               , 1);
 ELSE
   UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE sl_cd               = iuae_sl_cd
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
 END IF;
  END aeg_ins_up_inwfacul_entries;

  /* Created By   : Jenny Vi Lim
  ** Date Created : 1122006
  ** Description  : Generates acct entries for the collection in the outward facul
  */
  PROCEDURE aeg_parameters_outfacul( aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
                         aeg_module_nm    GIAC_MODULES.module_name%TYPE) IS

    v_due_to_ri_local   GIAC_OUTFACUL_PREM_PAYTS.disbursement_amt%TYPE;
    v_due_to_ri_foreign      GIAC_OUTFACUL_PREM_PAYTS.disbursement_amt%TYPE;
    v_prem_vat     GIRI_BINDER.ri_prem_vat%TYPE;
    v_comm_vat     GIRI_BINDER.ri_comm_vat%TYPE;
    v_wholding_vat    GIRI_BINDER.ri_wholding_vat%TYPE;
    v_gen_type     GIAC_MODULES.generation_type%TYPE;
 v_module_id     GIAC_MODULES.module_id%TYPE;
 v_ri_sl_cd     GIAC_PARAMETERS.param_value_v%TYPE;

    CURSOR PR_cur IS
      SELECT b.a180_ri_cd,
             c.line_cd,
             a.type_cd,
             b.disbursement_amt,
             g.local_foreign_sw,
             ((c.ri_prem_amt*e.currency_rt)+ (NVL(c.ri_prem_vat,0)*e.currency_rt)) - ((NVL(c.ri_comm_amt,0)*e.currency_rt)+ (NVL(c.ri_comm_vat,0)*e.currency_rt)) due_to_ri_local,
             ((c.ri_prem_amt*e.currency_rt)+ (NVL(c.ri_prem_vat,0)*e.currency_rt)) - ((NVL(c.ri_comm_amt,0)*e.currency_rt)+ (NVL(c.ri_comm_vat,0)*e.currency_rt)+(NVL(c.ri_wholding_vat,0)*e.currency_rt)) due_to_ri_foreign,
             (NVL(c.ri_prem_vat,0)*e.currency_rt) ri_prem_vat,
             (NVL(c.ri_comm_vat,0)*e.currency_rt) ri_comm_vat,
             (NVL(c.ri_wholding_vat,0)*e.currency_rt) ri_wholding_vat
        FROM GIPI_POLBASIC a,
             GIAC_OUTFACUL_PREM_PAYTS b,
             GIRI_BINDER c,
             GIRI_FRPS_RI d,
             GIRI_DISTFRPS e,
             GIUW_POL_DIST f,
             GIIS_REINSURER g
       WHERE a.policy_id = f.policy_id
        AND b.a180_ri_cd = g.ri_cd
         AND c.ri_cd = g.ri_cd
       AND d.ri_cd = g.ri_cd
         AND f.dist_no = e.dist_no
         AND e.line_cd = d.line_cd
         AND e.frps_yy = d.frps_yy
         AND e.frps_seq_no = d.frps_seq_no
         AND d.ri_cd = c.ri_cd
         AND d.fnl_binder_id = c.fnl_binder_id
         AND d.line_cd = c.line_cd
         AND c.ri_cd = b.a180_ri_cd
         AND c.fnl_binder_id = b.d010_fnl_binder_id
         AND b.gacc_tran_id = aeg_tran_id
         AND f.dist_flag NOT IN (4,5);


  BEGIN
    BEGIN
      SELECT module_id,
             generation_type
        INTO v_module_id,
             v_gen_type
        FROM GIAC_MODULES
       WHERE module_name  = aeg_module_nm;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in GIAC MODULES.');
  END;

  BEGIN
    SELECT param_value_v
      INTO v_ri_sl_cd
      FROM GIAC_PARAMETERS
     WHERE param_name = 'RI_SL_CD';
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in GIAC PARAMETERS.');
  END;


  FOR PR_rec IN PR_cur LOOP

    PR_rec.disbursement_amt := NVL(PR_REC.disbursement_amt, 0);

    IF pr_rec.local_foreign_sw = 'L' THEN
       v_due_to_ri_local := pr_rec.due_to_ri_local*(pr_rec.disbursement_amt/pr_rec.due_to_ri_local);
       v_prem_vat := pr_rec.ri_prem_vat*(pr_rec.disbursement_amt/pr_rec.due_to_ri_local);
       v_comm_vat := pr_rec.ri_comm_vat*(pr_rec.disbursement_amt/pr_rec.due_to_ri_local);
    ELSE
       v_due_to_ri_foreign := pr_rec.due_to_ri_foreign*(pr_rec.disbursement_amt/pr_rec.due_to_ri_foreign);
       v_prem_vat := pr_rec.ri_prem_vat*(pr_rec.disbursement_amt/pr_rec.due_to_ri_foreign);
       v_comm_vat := pr_rec.ri_comm_vat*(pr_rec.disbursement_amt/pr_rec.due_to_ri_foreign);
       v_wholding_vat := pr_rec.ri_wholding_vat*(pr_rec.disbursement_amt/pr_rec.due_to_ri_foreign);
    END IF;

    IF PR_rec.local_foreign_sw = 'L' THEN
   aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                           1       , NULL                 ,
                             NULL                , PR_rec.line_cd       ,
                           PR_rec.type_cd      , v_due_to_ri_local    ,
                             v_gen_type);
    END IF;

    IF PR_rec.local_foreign_sw IN ('A','F') THEN
     aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                           1                   , NULL                 ,
                             NULL                , PR_rec.line_cd       ,
                           PR_rec.type_cd      , v_due_to_ri_foreign  ,
                             v_gen_type);
    END IF;


 IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
      aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                           2       , NULL   ,
                             NULL                , PR_rec.line_cd       ,
                           PR_rec.type_cd      , v_comm_vat           ,
                             v_gen_type);
    END IF;

    IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
      aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                              3       , NULL                 ,
                              NULL                , PR_rec.line_cd       ,
                              PR_rec.type_cd      , v_comm_vat           ,
                              v_gen_type);
 END IF;


 IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
   IF PR_rec.local_foreign_sw = 'L' THEN
     aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                            4     , NULL                 ,
                              NULL                , PR_rec.line_cd       ,
                            PR_rec.type_cd      , v_prem_vat           ,
                              v_gen_type);
   END IF;
 END IF;

    IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
      IF PR_rec.local_foreign_sw = 'L' THEN
     aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                             5     , NULL                 ,
                             NULL                , PR_rec.line_cd       ,
                             PR_rec.type_cd      , v_prem_vat           ,
                             v_gen_type);
      END IF;
    END IF;

 IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
   IF PR_rec.local_foreign_sw IN ('A','F') THEN
     aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                                6     , NULL                 ,
                                NULL                , PR_rec.line_cd       ,
                                PR_rec.type_cd      , v_wholding_vat       ,
                                v_gen_type);
       END IF;
   END IF;

     IF PR_rec.local_foreign_sw IN ('A','F') THEN
       aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                               7       , NULL                 ,
                               NULL                , PR_rec.line_cd       ,
                               PR_rec.type_cd      , v_wholding_vat       ,
                               v_gen_type);
    END IF;

    IF NVL(Giacp.v('DEF_RI_VAT_ENTRY'), 'Y') = 'Y' THEN
      IF PR_rec.local_foreign_sw IN ('A','F') THEN
     aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                             8     , NULL                 ,
                         NULL                , PR_rec.line_cd       ,
                             PR_rec.type_cd      , v_wholding_vat       ,
                         v_gen_type);
      END IF;
    END IF;

    IF PR_rec.local_foreign_sw IN ('A','F') THEN
      aeg_create_outfacul_entries(PR_rec.a180_ri_cd   , v_module_id  ,
                                  9       , NULL   ,
                                  NULL                , PR_rec.line_cd       ,
                                  PR_rec.type_cd      , v_wholding_vat       ,
                                  v_gen_type);
      END IF;
    END LOOP;
  END aeg_parameters_outfacul;

  PROCEDURE aeg_create_outfacul_entries (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
           aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
           aeg_iss_cd             GIAC_RI_REQ_PAYT_DTL.iss_cd%TYPE,
           aeg_bill_no            GIAC_RI_REQ_PAYT_DTL.prem_seq_no%TYPE,
           aeg_line_cd            GIIS_LINE.line_cd%TYPE,
           aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
             aeg_acct_amt           GIAC_OUTFACUL_PREM_PAYTS.disbursement_amt%TYPE,
           aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE) IS
    ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
    ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
    ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
    ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
    ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
    ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
    ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    ws_line_cd                       GIIS_LINE.line_cd%TYPE;
    ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
    ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    ws_sl_type_cd            GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;

  BEGIN
    BEGIN
      SELECT gl_acct_category, gl_control_acct,
             gl_sub_acct_1   , gl_sub_acct_2  ,
             gl_sub_acct_3   , gl_sub_acct_4  ,
             gl_sub_acct_5   , gl_sub_acct_6  ,
             gl_sub_acct_7   , pol_type_tag   ,
             intm_type_level , old_new_acct_level,
             dr_cr_tag       , line_dependency_level
        INTO ws_gl_acct_category, ws_gl_control_acct,
             ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
             ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
             ws_gl_sub_acct_7   , ws_pol_type_tag   ,
             ws_intm_type_level , ws_old_new_acct_level,
             ws_dr_cr_tag       , ws_line_dep_level
        FROM GIAC_MODULE_ENTRIES
       WHERE module_id = aeg_module_id
         AND item_no   = aeg_item_no
      FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#No data found in giac_module_entries.');
    END;

    IF ws_line_dep_level != 0 THEN
      BEGIN
        SELECT acct_line_cd
          INTO ws_line_cd
          FROM GIIS_LINE
         WHERE line_cd = aeg_line_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#No data found in giis_line.');
      END;

      AEG_Check_Level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                      ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                      ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
    END IF;

    IF ws_old_new_acct_level != 0 THEN
      BEGIN
        BEGIN
          SELECT param_value_v
            INTO ws_iss_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'OLD_ISS_CD';
        END;

        BEGIN
          SELECT param_value_n
            INTO ws_old_acct_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'OLD_ACCT_CD';
        END;

        BEGIN
          SELECT param_value_n
            INTO ws_new_acct_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'NEW_ACCT_CD';
        END;

        IF aeg_iss_cd = ws_iss_cd THEN
          aeg_Check_Level(ws_old_new_acct_level, ws_old_acct_cd  , ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
        ELSE
          aeg_Check_Level(ws_old_new_acct_level, ws_new_acct_cd  , ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
        END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#No data found in giac_parameters.');
        END;
      END IF;

      IF ws_pol_type_tag = 'Y' THEN
        BEGIN
          SELECT NVL(gl_sub_acct_1,0), NVL(gl_sub_acct_2,0),
                 NVL(gl_sub_acct_3,0), NVL(gl_sub_acct_4,0),
                 NVL(gl_sub_acct_5,0), NVL(gl_sub_acct_6,0),
                 NVL(gl_sub_acct_7,0)
            INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                 pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                 pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                 pt_gl_sub_acct_7
            FROM GIAC_POLICY_TYPE_ENTRIES
           WHERE line_cd = aeg_line_cd
             AND type_cd = aeg_type_cd;

          IF pt_gl_sub_acct_1 != 0 THEN
            ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
          END IF;

          IF pt_gl_sub_acct_2 != 0 THEN
            ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
          END IF;

          IF pt_gl_sub_acct_3 != 0 THEN
            ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
          END IF;

          IF pt_gl_sub_acct_4 != 0 THEN
            ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
          END IF;

          IF pt_gl_sub_acct_5 != 0 THEN
            ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
          END IF;

          IF pt_gl_sub_acct_6 != 0 THEN
            ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
          END IF;

          IF pt_gl_sub_acct_7 != 0 THEN
            ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
          END IF;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#No data found in giac_policy_type_entries.');
        END;
      END IF;


      AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                               ws_gl_acct_id);


      AEG_get_sl_type_leaf_tag(ws_gl_acct_id);

      IF ws_dr_cr_tag = 'D' THEN
        IF aeg_acct_amt > 0 THEN
          ws_debit_amt  := ABS(aeg_acct_amt);
          ws_credit_amt := 0;
        ELSE
          ws_debit_amt  := 0;
          ws_credit_amt := ABS(aeg_acct_amt);
        END IF;
      ELSE
        IF aeg_acct_amt > 0 THEN
          ws_debit_amt  := 0;
          ws_credit_amt := ABS(aeg_acct_amt);
        ELSE
          ws_debit_amt  := ABS(aeg_acct_amt);
          ws_credit_amt := 0;
        END IF;
      END IF;

    BEGIN
   SELECT DISTINCT(NVL(GSLT_SL_TYPE_CD, ' '))
        INTO ws_sl_type_cd
        FROM GIAC_CHART_OF_ACCTS
       WHERE gl_acct_category  = ws_gl_acct_category
         AND gl_control_acct   = ws_gl_control_acct
         AND gl_sub_acct_1     = ws_gl_sub_acct_1
         AND gl_sub_acct_2     = ws_gl_sub_acct_2
       AND gl_sub_acct_3     = ws_gl_sub_acct_3
   AND gl_sub_acct_4     = ws_gl_sub_acct_4
       AND gl_sub_acct_5     = ws_gl_sub_acct_5
       AND gl_sub_acct_6     = ws_gl_sub_acct_6
       AND gl_sub_acct_7     = ws_gl_sub_acct_7;

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#GL account code '||TO_CHAR(ws_gl_acct_category)
                        ||'-'||TO_CHAR(ws_gl_control_acct,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_1,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_2,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_3,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_4,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_5,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_6,'09')
                        ||'-'||TO_CHAR(ws_gl_sub_acct_7,'09')
                        ||' does not exist in Chart of Accounts (Giac_Acctrans).');
    END;

    aeg_ins_up_outfacul_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                   ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                   ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                   aeg_sl_cd          , aeg_gen_type      , ws_gl_acct_id   ,
                                   ws_debit_amt       , ws_credit_amt  , '1'               ,
                                   ws_sl_type_cd);


  END aeg_create_outfacul_entries;

  PROCEDURE aeg_get_sl_type_leaf_tag(aeg_gl_acct_id GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE) IS
    v_sl_type    GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;
    v_leaf_tag   GIAC_CHART_OF_ACCTS.leaf_tag%TYPE;
    v_ri_sl_cd   GIAC_PARAMETERS.param_value_v%TYPE;

  BEGIN
    BEGIN
      SELECT param_value_v
        INTO v_ri_sl_cd
        FROM GIAC_PARAMETERS
       WHERE param_name = 'RI_SL_CD';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#No data found in GIAC PARAMETERS.');
    END;

    SELECT gslt_sl_type_cd, leaf_tag
      INTO v_sl_type, v_leaf_tag
      FROM GIAC_CHART_OF_ACCTS
     WHERE gl_acct_id = aeg_gl_acct_id;

    IF v_sl_type <> v_ri_sl_cd THEN
      RAISE_APPLICATION_ERROR(-20210,'Geniisys Exception#E#The SL type of this account(gl_acct_id: ' ||
                         TO_CHAR(aeg_gl_acct_id) ||
          ') ' ||
                                     'does not match that in RI_SL_CD (GIAC PARAMETERS).');
    END IF;

    IF v_leaf_tag = 'N' THEN
      RAISE_APPLICATION_ERROR(-20210, 'Geniisys Exception#E#This account(gl_acct_id: ' ||
                                      TO_CHAR(aeg_gl_acct_id) ||
                                      ') ' ||
                                      'is not a posting account.');
    END IF;
  END aeg_get_sl_type_leaf_tag;

  PROCEDURE aeg_ins_up_outfacul_entries (iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                 iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
               iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
               iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
               iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
               iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
               iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
               iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
               iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
               iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
               iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
               iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
               iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
               iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
               iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE,
               iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE      )IS

    iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;

  BEGIN
    SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
    INTO iuae_acct_entry_id
    FROM GIAC_ACCT_ENTRIES
   WHERE gacc_gibr_branch_cd = pvar_branch_cd
     AND gacc_gfun_fund_cd   = pvar_fund_cd
     AND gl_acct_id          = iuae_gl_acct_id
     AND sl_cd               = iuae_sl_cd
     AND generation_type     = iuae_generation_type
     AND gacc_tran_id        = pvar_tran_id;

    IF NVL(iuae_acct_entry_id,0) = 0 THEN
      iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;

   INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                    gacc_gibr_branch_cd, acct_entry_id    ,
                                    gl_acct_id         , gl_acct_category ,
                                    gl_control_acct    , gl_sub_acct_1    ,
                                    gl_sub_acct_2      , gl_sub_acct_3    ,
                                    gl_sub_acct_4      , gl_sub_acct_5    ,
                                    gl_sub_acct_6      , gl_sub_acct_7    ,
                                    sl_cd              , debit_amt        ,
                                    credit_amt         , generation_type  ,
                                    user_id            , last_update ,
                                    SL_TYPE_CD         , SL_SOURCE_CD )
          VALUES (pvar_tran_id  , pvar_fund_cd,
                  pvar_branch_cd, iuae_acct_entry_id          ,
                  iuae_gl_acct_id               , iuae_gl_acct_category       ,
                  iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                  iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                  iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                  iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                  iuae_sl_cd                    , iuae_debit_amt              ,
                  iuae_credit_amt               , iuae_generation_type        ,
                  USER                          , SYSDATE      ,
               iuae_sl_type_cd       , iuae_sl_source_cd  );
    ELSE
      UPDATE GIAC_ACCT_ENTRIES
         SET debit_amt  = debit_amt  + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE sl_cd               = iuae_sl_cd
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = pvar_branch_cd
         AND gacc_gfun_fund_cd   = pvar_fund_cd
         AND gacc_tran_id        = pvar_tran_id;
   END IF;
  END aeg_ins_up_outfacul_entries;

END Upload_Dpc;
/


