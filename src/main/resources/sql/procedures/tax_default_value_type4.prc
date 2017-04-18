DROP PROCEDURE CPI.TAX_DEFAULT_VALUE_TYPE4;

CREATE OR REPLACE PROCEDURE CPI.Tax_Default_Value_Type4 (
   P_TRAN_ID               IN NUMBER
  ,P_REV_TRAN_ID           IN NUMBER --added by alfie 09.22.2011
  ,P_TRAN_TYPE             IN NUMBER
  ,P_ISS_CD                IN VARCHAR2
  ,P_PREM_SEQ_NO           IN NUMBER
  --,P_USER_ID               IN VARCHAR2
  --,P_LAST_UPDATE           IN DATE
  ,P_INST_NO               IN NUMBER
  ,P_FUND_CD               IN VARCHAR2--global.fund_cd
  ,P_PARAM_PREMIUM_AMT     IN NUMBER --PARAMETER.PREMIUM_AMT
  ,P_COLLECTION_AMT        IN NUMBER --gdpc.collection_amt
  ,P_PREMIUM_AMT           IN OUT NUMBER--gdpc.premium_amt
  ,P_TAX_AMT               OUT NUMBER
  ,P_PREM_VAT_EXEMPT       IN OUT NUMBER -- added by alfie 09.22.2011
  ,P_GIAC_TAX_COLLNS_CUR   OUT giac_tax_collns_pkg.rc_giac_tax_collns_cur --added by alfie: 10.24.2010
  ) IS

    /*  if giac_aging_soa_details.tax_balance_due != tax collected amount
    **  then allocate tax collected amt to taxes other than EVAT, balance
    **  should be allocated to ratio of original premium_amt and evat amount
    **  (evat amount must first be determined)
    */
  param_value_evat         GIAC_PARAMETERS.param_value_n%TYPE; --for evat
  v_max_inst_no            GIPI_INSTALLMENT.inst_no%TYPE;--holds the no of installment
  v_balance_amt_due        GIPI_INSTALLMENT.prem_amt%TYPE;
  v_balance_due            GIPI_INSTALLMENT.prem_amt%TYPE;
  v_tax_balance_due        GIPI_INSTALLMENT.tax_amt%TYPE;
  v_collection_amt         GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
  v_tax_inserted           GIAC_TAX_COLLNS.tax_amt%TYPE;
  v_curr_rt                GIPI_INVOICE.currency_rt%TYPE;
  v_tax_alloc              GIPI_INV_TAX.tax_allocation%TYPE;
  SWITCH                   VARCHAR2(1) := 'N';
  last_tax_inserted        GIPI_INV_TAX.tax_cd%TYPE;
  x                        NUMBER := 0;

  v_colln_amt_less_prem_exempt NUMBER := 0; --added by alfie 09.22.2011
  v_tax_amt NUMBER := 0; --added by alfie 09.22.2011

   /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
   **  evat will always be retrieved last
   */
   CURSOR c1 IS
     SELECT A.iss_cd         , A.prem_seq_no     ,
            A.tax_cd         , NVL(A.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
            A.tax_allocation , b.fund_cd         ,
            A.line_cd        , c.currency_rt
     FROM   GIPI_INV_TAX A,
            GIAC_TAXES   b,
            GIPI_INVOICE c
     WHERE  A.tax_cd = b.tax_cd
     AND    A.iss_cd = c.iss_cd
     AND    A.prem_seq_no = c.prem_seq_no
     AND    A.iss_cd = p_iss_cd
     AND    A.prem_seq_no = p_prem_seq_no
     AND    b.fund_Cd = p_fund_cd
     ORDER BY A.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c2 IS
     SELECT A.iss_cd         , A.prem_seq_no     ,
            A.tax_cd         , NVL(A.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
            A.tax_allocation , b.fund_cd         ,
            A.line_cd        , c.currency_rt
     FROM   GIPI_INV_TAX A,
            GIAC_TAXES   b,
            GIPI_INVOICE c
     WHERE  A.tax_cd = b.tax_cd
     AND    A.iss_cd = c.iss_cd
     AND    A.prem_seq_no = c.prem_seq_no
     AND    A.iss_cd = p_iss_cd
     AND    A.prem_seq_no = p_prem_seq_no
     AND    A.tax_cd != param_value_evat
     AND    b.fund_Cd = p_fund_cd
     ORDER BY A.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c3 IS
     SELECT A.iss_cd         , A.prem_seq_no     ,
            A.tax_cd         , NVL(A.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
            A.tax_allocation , b.fund_cd         ,
            A.line_cd        , c.currency_rt
     FROM   GIPI_INV_TAX A,
            GIAC_TAXES   b,
            GIPI_INVOICE c
     WHERE  A.tax_cd = b.tax_cd
     AND    A.iss_cd = c.iss_cd
     AND    A.prem_seq_no = c.prem_seq_no
     AND    A.iss_cd = p_iss_cd
     AND    A.prem_seq_no = p_prem_seq_no
     AND    A.tax_cd = param_value_evat
     AND    b.fund_Cd = p_fund_cd
     ORDER BY A.tax_cd DESC, b.tax_type, b.priority_cd;

   CURSOR c4  (P_TAX_CD NUMBER)  IS
     SELECT SUM(NVL(A.tax_amt,0)) tax_amt
     FROM   GIAC_TAX_COLLNS  A,
            GIAC_ACCTRANS    b
     WHERE  A.gacc_tran_id = b.tran_id
     AND    A.b160_iss_cd = p_iss_cd
     AND    A.b160_prem_Seq_no = p_prem_Seq_no
     AND    b.tran_flag != 'D'
     AND    A.b160_tax_cd = p_tax_cd
     --AND    A.gacc_tran_id != p_tran_id
     AND    A.gacc_tran_id = p_rev_tran_id
     AND    A.inst_no = p_inst_no
     AND    b.tran_id NOT IN (SELECT aa.gacc_tran_id
                              FROM GIAC_REVERSALS aa,
                                   GIAC_ACCTRANS  bb
                              WHERE aa.reversing_tran_id = bb.tran_id
                              AND bb.tran_flag != 'D') ;

   CURSOR c4a  (P_TAX_CD NUMBER)  IS
     SELECT SUM(NVL(A.tax_amt,0)) tax_amt
     FROM   GIAC_TAX_COLLNS  A,
            GIAC_ACCTRANS    b
     WHERE  A.gacc_tran_id = b.tran_id
     AND    A.b160_iss_cd = p_iss_cd
     AND    A.b160_prem_Seq_no = p_prem_Seq_no
     AND    b.tran_flag != 'D'
     AND    A.b160_tax_cd = p_tax_cd
     --AND    A.gacc_tran_id != p_tran_id
     AND a.gacc_tran_id = p_rev_tran_id
--     AND    a.inst_no = p_inst_no
     AND    b.tran_id NOT IN (SELECT aa.gacc_tran_id
                              FROM GIAC_REVERSALS aa,
                                   GIAC_ACCTRANS  bb
                              WHERE aa.reversing_tran_id = bb.tran_id
                              AND bb.tran_flag != 'D');

  CURSOR c5 (p_tax_alloc  VARCHAR) IS
     SELECT A.iss_cd         , A.prem_seq_no     ,
            A.tax_cd         , NVL(A.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
            A.tax_allocation , b.fund_cd         ,
            A.line_cd        , c.currency_rt
     FROM   GIPI_INV_TAX A,
            GIAC_TAXES   b,
            GIPI_INVOICE c
     WHERE  A.tax_cd = b.tax_cd
     AND    A.iss_cd = c.iss_cd
     AND    A.prem_seq_no = c.prem_seq_no
     AND    A.iss_cd = p_iss_cd
     AND    A.prem_seq_no = p_prem_seq_no
     AND    b.fund_Cd = p_fund_cd
     AND    A.tax_allocation = p_tax_alloc
     AND    A.tax_cd != param_value_evat
     ORDER BY A.tax_cd DESC, b.tax_type, b.priority_cd;

BEGIN
--MESSAGE('TAX_DEFAULT_VALUE_2');
--MESSAGE('TAX_DEFAULT_VALUE_2');
---MESSAGE('parameter.collection_amt :  '|| to_char(:parameter.collection_amt));
--MESSAGE('parameter.tax_amt :  '|| to_char(:parameter.tax_amt));
--  msg_alert('prem_amt_2' || to_char(:gdpc.premium_amt),'i',false);
--  msg_alert('tax_amt_2' || to_char(:gdpc.tax_amt),'i',false);

  DELETE
  FROM GIAC_TAX_COLLNS
  WHERE gacc_tran_id = p_tran_id
  AND B160_iss_cd = p_iss_cd
  AND B160_prem_seq_no = p_prem_seq_no
  AND inst_no = p_inst_no
  AND transaction_type = p_tran_type;
  BEGIN
    SELECT param_value_n
    INTO param_value_evat
    FROM GIAC_PARAMETERS
    WHERE param_name LIKE 'EVAT';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      param_value_evat := NULL;
  END;

  /* to get the no of payments or inst_no */
  SELECT MAX(inst_no)
  INTO   v_max_inst_no
  FROM   GIPI_INSTALLMENT
  WHERE  iss_cd = p_iss_Cd
  AND    prem_Seq_no = p_prem_seq_no;

  /* to get currency_rt for bill */
  SELECT DISTINCT currency_rt
  INTO v_curr_rt
  FROM GIPI_INVOICE
  WHERE iss_cd = p_iss_cd
  AND prem_seq_no = p_prem_Seq_no;
  v_curr_rt := NVL(v_curr_rt,1);

  v_collection_amt := p_collection_amt;
       BEGIN
         SELECT DISTINCT tax_allocation
         INTO v_tax_alloc
         FROM GIPI_INV_TAX
         WHERE iss_cd = p_iss_cd
         AND prem_Seq_no = p_prem_Seq_no;
       EXCEPTION
         WHEN TOO_MANY_ROWS THEN
           v_tax_alloc := NULL;
       END;


       IF (v_tax_alloc = 'F' AND p_inst_no != 1 )
         OR (v_tax_alloc = 'L' AND p_inst_no != v_max_inst_no) THEN
         p_tax_amt := 0;
         p_premium_amt := p_collection_amt;
       END IF;
       IF (v_tax_alloc = 'F' AND p_inst_no = 1)
         OR (v_tax_alloc = 'L' AND p_inst_no = v_max_inst_no) THEN
         v_collection_amt := p_collection_amt;
         FOR c1_rec IN c2 LOOP
          FOR rec IN c4 (c1_rec.tax_cd) LOOP
            
            --added by alfie 09.22.2011
            --FOR f IN paid_taxes (c1_rec.tax_cd) LOOP
            --  v_tax_amt := NVL(f.tax_amt,0);
            --END LOOP;
            /*
            v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
            IF v_balance_due > v_collection_amt THEN
              v_balance_due := v_collection_amt;
            END IF;
            v_collection_amt := v_collection_amt - v_balance_due;
            */ --commented by jason 1/20/2009: replaced by the code below

            --v_tax_amt := ABS(NVL(rec.tax_amt,0)) - v_tax_amt;
            IF NVL(rec.tax_amt,0) != 0 THEN
            --IF v_tax_amt != 0 THEN
              IF ABS(v_collection_amt) >= NVL(rec.tax_amt,0) THEN
              --IF ABS(v_collection_amt) >= v_tax_amt THEN
                v_balance_due := NVL(rec.tax_amt,0) * -1 ;
                --v_balance_due := v_tax_amt * -1;
              ELSE
                v_balance_due := v_collection_amt;
              END IF;
              v_collection_amt := v_collection_amt - v_balance_due;

              INSERT INTO GIAC_TAX_COLLNS
                  (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
                   B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
                   B160_TAX_CD                    ,TAX_AMT                        ,
                   FUND_CD                        ,REMARKS                        ,
                   USER_ID                        ,LAST_UPDATE                    ,
                   INST_NO                        )
              VALUES
                  (p_tran_id                      ,p_tran_type                    ,
                   p_iss_cd                       ,p_prem_Seq_no                  ,
                   c1_rec.tax_cd                  ,v_balance_due                  ,
                   c1_rec.fund_cd                 ,NULL                           ,
                   user                      ,sysdate                  ,
                   p_inst_no                      );
            END IF;
            --v_tax_amt := 0;
          END LOOP rec;
         END LOOP c1_rec;
         --FOR c1_rec IN c3 LOOP  --for evat only//
         --   SWITCH := 'Y';  --jason 1/20/2009//

          --Vincent 03022006: removed IF condtn added by lina to insert 0 evat values in giac_tax_collns
          --IF C1_REC.TAX_AMT != 0 THEN --to check if the evat amount is not equal to 0, lina, 12292005
           --FOR rec IN c4 (c1_rec.tax_cd) LOOP//
              /*v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(REC.tax_amt,0) + p_param_premium_amt;
              IF v_balance_due != 0 THEN
                v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0)) / v_balance_due);
              END IF;
              IF v_balance_due > NVL(c1_rec.tax_amt,0) - NVL(REC.tax_amt,0)  THEN
                v_balance_due := NVL(c1_rec.tax_amt,0) - NVL(REC.tax_amt,0) ;
              END IF;
              */ --commented by jason 1/20/2009: replaced by the code below
              --v_balance_due := (NVL(rec.tax_amt,0)*-1) + ABS(p_param_premium_amt); --modified by alfie: 05/31/2011:rec.tax_amt is multiply by -1 to get the positive value of tax amt //
              --IF v_balance_due != 0 THEN//
                 --v_balance_due := v_collection_amt * ((NVL(rec.tax_amt,0)*-1) / v_balance_due); --modified by alfie: 05/31/2011 //
              --END IF;//

          --    p_premium_amt := v_collection_amt - v_balance_due;//
          --    p_tax_amt := p_collection_amt - p_premium_amt;//

          --    INSERT INTO GIAC_TAX_COLLNS //
          --      (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,//
          --       B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,//
          --       B160_TAX_CD                    ,TAX_AMT                        ,//
          --       FUND_CD                        ,REMARKS                        ,//
          --       USER_ID                        ,LAST_UPDATE                    ,//
          --       INST_NO                        )//
          --    VALUES//
          --     (p_tran_id                      ,p_tran_type                    ,//
          --       p_iss_cd                       ,p_prem_Seq_no                  ,//
          --       c1_rec.tax_cd                  ,v_balance_due                  ,//
          --       c1_rec.fund_cd                 ,NULL                           ,//
          --       user                      ,sysdate                  ,//
          --       p_inst_no                      );//
          -- END LOOP rec;//
           --end if;--lina
         --END LOOP c1_rec;//

         --jason 1/20/2009 start: without evat
        -- IF SWITCH != 'Y' THEN//
        --   p_premium_amt := v_collection_amt;//
        --   p_tax_amt := p_collection_amt - p_premium_amt;//
        -- END IF;
         --jason 1/20/2009 end--
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
         FOR c1_rec IN c2 LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
           
             --FOR f IN paid_taxes (c1_rec.tax_cd) LOOP --added by alfie 09.22.2011
             --  v_tax_amt := NVL(f.tax_amt,0);
             --END LOOP;
             
             --v_tax_amt := NVL(rec.tax_amt,0) - (v_tax_amt * -1);
             /** receivable **/
             --v_tax_balance_due := v_tax_balance_due + (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0); --commented bu jason 1/20/2009: replaced by the code below
           
             v_tax_balance_due := v_tax_balance_due + NVL(rec.tax_amt,0);
             --v_tax_balance_due := v_tax_balance_due + v_tax_amt; --alfie 09.22.2011
           END LOOP rec;
         END LOOP c1_rec;

         IF v_tax_balance_due != 0 THEN
          FOR c1_rec IN c2 LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
           
             --FOR f IN paid_taxes (c1_rec.tax_cd) LOOP --added by alfie 09.22.2011
             --  v_tax_amt := NVL(f.tax_amt,0);
             --END LOOP;
             
             --v_tax_amt := NVL(rec.tax_amt,0) - (v_tax_amt * -1);
             --v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);  --commented by jason 1/20/2009: replaced
             v_balance_due := v_collection_amt * ( NVL(rec.tax_amt,0) / v_tax_balance_due);
             --v_balance_due := v_collection_amt * (v_tax_amt / v_tax_balance_due);


            IF v_balance_due > (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) THEN
               --v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - nvl(rec.tax_amt,0);--Vincent 060305: comment out
       --Vincent 060305: replaced the formula for v_balance_due with the select stmt below,
       --to correct the error in amounts inserted for tax
               SELECT DECODE(p_inst_no,v_max_inst_no,
                             DECODE(v_max_inst_no, 1, NVL(c1_rec.tax_amt,0),
                             (NVL(c1_rec.tax_amt,0) - (ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2) * v_max_inst_no)) + ROUND(NVL(c1_rec.tax_amt,0)/v_max_inst_no,2)),
                       NVL(c1_rec.tax_amt,0) / v_max_inst_no) * -1  -- - NVL(rec.tax_amt,0) --commented by jason 1/21/2009
               INTO v_balance_due
               FROM DUAL;
        --**vfm**--
             END IF;

              IF v_balance_due + v_tax_inserted > v_collection_amt THEN
               v_balance_due := v_collection_amt - v_tax_inserted;
             END IF;


--msg_alert('gacc_tran_id' || to_char(p_tran_id ),'i',false);
--msg_alert('b160_tax_cd' || to_char(c1_rec.tax_cd),'i',false);
--msg_alert('tax_amt' || to_char(v_balance_due),'i',false);



             INSERT INTO GIAC_TAX_COLLNS
                  (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
                   B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
                   B160_TAX_CD                    ,TAX_AMT                        ,
                   FUND_CD                        ,REMARKS                        ,
                   USER_ID                        ,LAST_UPDATE                    ,
                   INST_NO                        )
             VALUES
                  (p_tran_id                      ,p_tran_type                    ,
                   p_iss_cd                       ,p_prem_Seq_no                  ,
                   c1_rec.tax_cd                  ,v_balance_due                  ,
                   c1_rec.fund_cd                 ,NULL                           ,
                   user                      ,sysdate                  ,
                   p_inst_no                      );
            v_tax_inserted := v_tax_inserted + v_balance_due;
           END LOOP rec;
           last_tax_inserted := c1_rec.tax_cd;
          END LOOP c1_rec;
         END IF;

         v_collection_amt := v_Collection_amt - v_tax_inserted;

       --  FOR c1_rec IN c3 LOOP//
       --    SWITCH := 'Y';//
       --    FOR rec IN c4 (c1_rec.tax_cd) LOOP//

       --      v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + p_param_premium_amt;//
       --      IF v_balance_due != 0 THEN//
       --         v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0)) / v_balance_due);//
       --      END IF;//
       --      v_collection_amt := v_collection_amt - v_balance_due;//
       --      IF v_collection_amt > p_param_premium_amt THEN//
       --        v_balance_due := v_balance_due - (v_collection_amt - p_param_premium_amt);//
       --        p_premium_amt := p_param_premium_amt;//
       --      ELSE//
       --        p_premium_amt := v_collection_amt;//
       --      END IF;//
       --      p_tax_amt := p_collection_amt - p_premium_amt;//

       --      INSERT INTO GIAC_TAX_COLLNS//
       --           (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,//
       --            B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,//
       --            B160_TAX_CD                    ,TAX_AMT                        ,//
       --            FUND_CD                        ,REMARKS                        ,//
       --            USER_ID                        ,LAST_UPDATE                    ,//
       --            INST_NO                        )//
       --      VALUES//
       --           (p_tran_id                      ,p_tran_type                    ,//
       --            p_iss_cd                       ,p_prem_Seq_no                  ,//
       --            c1_rec.tax_cd                  ,v_balance_due                  ,//
       --            c1_rec.fund_cd                 ,NULL                           ,//
       --            user                      ,sysdate                  ,//
       --            p_inst_no                      );//
       --    END LOOP rec;
       --    last_tax_inserted := c1_rec.tax_cd;//
       --  END LOOP c1_rec;//
       --  IF SWITCH != 'Y' THEN//
       --    IF v_collection_amt > p_param_premium_amt THEN//
       --      p_premium_amt := v_collection_amt - ( v_collection_amt - p_param_premium_amt);//
       --      UPDATE GIAC_TAX_COLLNS//
       --      SET tax_amt = tax_amt + (v_collection_amt - p_param_premium_amt)//
       --      WHERE gacc_tran_id = p_tran_id//
       --      AND b160_iss_cd = p_iss_Cd//
       --      AND b160_prem_Seq_no = p_prem_Seq_no//
       --      AND inst_no = p_inst_no//
       --      AND transaction_type = p_tran_type//
       --      AND b160_tax_cd = last_tax_inserted;//
       --    ELSE
       --      p_premium_amt := v_collection_amt;
       --    END IF;
       --    p_tax_amt := p_collection_amt - p_premium_amt;
       --  END IF;
       END IF;  --v_tax_alloc = 'S' then

       IF v_tax_alloc IS  NULL THEN
         /*
         **therefore there are mixed tax allocations in the bill
         **process everything the same as the normal process except for evat
         **the excess amount after the process should be allocated to evat 0
         */
         v_tax_inserted := 0;
         v_collection_amt := p_collection_amt;
         FOR c1_rec IN c5  ('F') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP

             v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
             IF v_balance_due > v_collection_amt THEN
                v_balance_due := v_collection_amt;
             END IF;
             IF p_inst_no != 1 THEN
                v_balance_due := 0;
             END IF;
             v_collection_amt := v_collection_amt - v_balance_due;
             INSERT INTO GIAC_TAX_COLLNS
                  (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
                   B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
                   B160_TAX_CD                    ,TAX_AMT                        ,
                   FUND_CD                        ,REMARKS                        ,
                   USER_ID                        ,LAST_UPDATE                    ,
                   INST_NO                        )
             VALUES
                  (p_tran_id                      ,p_tran_type                    ,
                   p_iss_cd                       ,p_prem_Seq_no                  ,
                   c1_rec.tax_cd                  ,v_balance_due                  ,
                   c1_rec.fund_cd                 ,NULL                           ,
                   user                      ,sysdate                  ,
                   p_inst_no                      );
           END LOOP rec;
         END LOOP c1_rec; --for 'F'
         v_tax_balance_due := 0;
         v_tax_inserted := 0;
         FOR c1_rec IN c5 ('S') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
             v_tax_balance_due := (c1_rec.tax_amt / v_max_inst_no) - NVL(rec.tax_amt,0);
           END LOOP rec;
         END LOOP c1_rec;
         IF v_tax_balance_due != 0 THEN
          FOR c1_rec IN c5 ('S') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
             v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_tax_balance_due);
             IF v_balance_due > (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) THEN
               v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0);
             END IF;
             IF v_balance_due + v_tax_inserted > v_collection_amt THEN
               v_balance_due := v_collection_amt - v_tax_inserted;
             END IF;
             INSERT INTO GIAC_TAX_COLLNS
                  (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
                   B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
                   B160_TAX_CD                    ,TAX_AMT                        ,
                   FUND_CD                        ,REMARKS                        ,
                   USER_ID                        ,LAST_UPDATE                    ,
                   INST_NO                        )
             VALUES
                  (p_tran_id                      ,p_tran_type                    ,
                   p_iss_cd                       ,p_prem_Seq_no                  ,
                   c1_rec.tax_cd                  ,v_balance_due                  ,
                   c1_rec.fund_cd                 ,NULL                           ,
                   user                      ,sysdate                  ,
                   p_inst_no                      );
             v_tax_inserted := v_tax_inserted + v_balance_due;
           END LOOP;
           last_tax_inserted := c1_rec.tax_cd;
          END LOOP c1_rec;
         END IF;
         v_collection_amt := v_collection_amt - v_tax_inserted;
         FOR c1_rec IN c5  ('L') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
             IF p_inst_no != v_max_inst_no THEN
               v_balance_due := 0;
             ELSE
               v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0);
               IF v_balance_due > v_collection_amt THEN
                  v_balance_due := v_collection_amt;
               END IF;
               v_collection_amt := v_collection_amt - v_balance_due;
               INSERT INTO GIAC_TAX_COLLNS
                  (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
                   B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
                   B160_TAX_CD                    ,TAX_AMT                        ,
                   FUND_CD                        ,REMARKS                        ,
                   USER_ID                        ,LAST_UPDATE                    ,
                   INST_NO                        )
               VALUES
                  (p_tran_id                      ,p_tran_type                    ,
                   p_iss_cd                       ,p_prem_Seq_no                  ,
                   c1_rec.tax_cd                  ,v_balance_due                  ,
                   c1_rec.fund_cd                 ,NULL                           ,
                   user                      ,sysdate                  ,
                   p_inst_no                      );
             END IF;
           END LOOP rec;
         END LOOP c1_rec;

        -- FOR c1_rec IN c3 LOOP//
        --   SWITCH := 'Y'; --to check if bill has evat//
        --   IF (c1_rec.tax_allocation = 'F' AND p_inst_no = 1) OR//
        --      (c1_rec.tax_allocation = 'L' AND p_inst_no = v_max_inst_no) THEN//
        --     FOR rec IN c4a (c1_rec.tax_cd) LOOP//
        --       v_balance_due := c1_rec.tax_amt - NVL(rec.tax_amt,0) + p_param_premium_amt;//
        --       IF v_balance_due != 0 THEN//
        --         v_balance_due := v_collection_amt * ((c1_rec.tax_amt - NVL(rec.tax_amt,0))/v_balance_due);//
        --       END IF;//
        --       IF v_collection_amt - v_balance_due > p_param_premium_amt THEN//
        --         p_premium_amt := p_param_premium_amt;//
        --         v_balance_due := v_collection_amt - p_param_premium_amt;//
        --       ELSE//
        --         p_premium_amt := v_collection_amt - v_balance_due;//
        --       END IF;//
        --       p_tax_amt := p_collection_amt - p_premium_amt;//
        --     END LOOP rec;//

        --   ELSIF c1_rec.tax_allocation = 'S' THEN//

        --     FOR rec IN c4 (c1_rec.tax_cd) LOOP//
        --       v_balance_due := (c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0) + NVL(p_param_premium_amt,0);//
        --       IF v_balance_due != 0 THEN//
        --          v_balance_due := v_collection_amt * (((c1_rec.tax_amt/v_max_inst_no) - NVL(rec.tax_amt,0))/v_balance_due);//
        --       END IF;//
        --       v_collection_amt := v_collection_amt - v_balance_due;//
        --       IF v_collection_amt > NVL(p_param_premium_amt,0) THEN//
        --         p_premium_amt := p_param_premium_amt;//
        --         V_BALANCE_DUE := V_BALANCE_DUE + (V_COLLECTION_AMT - p_param_PREMIUM_AMT);//
        --       ELSE//
        --         p_premium_amt := v_collection_amt;//
        --       END IF;//
        --       p_tax_amt := p_collection_amt - p_premium_amt;//
        --     END LOOP rec;//
        --END IF;//

         --  INSERT INTO GIAC_TAX_COLLNS//
         --         (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,//
         --/          B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,//
         --          B160_TAX_CD                    ,TAX_AMT                        ,//
         --          FUND_CD                        ,REMARKS                        ,//
         --          USER_ID                        ,LAST_UPDATE                    ,//
         --          INST_NO                        )//
         --  VALUES//
         --         (p_tran_id                      ,p_tran_type                    ,//
         --          p_iss_cd                       ,p_prem_Seq_no                  ,//
         --          c1_rec.tax_cd                  ,v_balance_due                  ,//
         --          c1_rec.fund_cd                 ,NULL                           ,//
         --          user                      ,sysdate                  ,//
         --          p_inst_no                      );//
         --END LOOP c1_rec;//
         --IF SWITCH != 'Y' THEN --no evat/
         --  p_premium_amt := v_collection_amt;//
         --  p_tax_amt := p_collection_amt - p_premium_amt;//
         --END IF;//
       END IF;  --v_tax_alloc is  null
    
    FOR c1_rec IN c3 LOOP
      SWITCH := 'Y'; --to check if bill has evat
      FOR rec IN c4 (c1_rec.tax_cd) LOOP
        
        --FOR f IN paid_taxes (c1_rec.tax_cd) LOOP --alfie 09.22.2011 : to query for the paid taxes to be subtract from rec.tax_amt
        --  v_tax_amt := NVL(f.tax_amt,0);
        --END LOOP;  
        --v_tax_amt := NVL(rec.tax_amt,0) - (v_tax_amt*-1);
        
        v_balance_due := (NVL(rec.tax_amt,0)*-1) + p_param_premium_amt;
        --v_balance_due := (v_tax_amt * -1) + p_param_premium_amt;
        
        
        IF v_balance_due != 0 THEN
          IF SIGN(v_collection_amt - p_prem_vat_exempt) = -1 THEN
            v_colln_amt_less_prem_exempt := 0;
            p_prem_vat_exempt := v_collection_amt;
          ELSIF SIGN(v_collection_amt - p_prem_vat_exempt) = 0 THEN
            v_colln_amt_less_prem_exempt := 0;
          ELSE
            v_colln_amt_less_prem_exempt := v_collection_amt - p_prem_vat_exempt;
          END IF;
          v_balance_due := v_colln_amt_less_prem_exempt * ( (NVL(rec.tax_amt,0)*-1)/v_balance_due);
          --v_balance_due := v_colln_amt_less_prem_exempt * ((v_tax_amt*-1)/v_balance_due); --alfie 09.22.2011
          
        END IF;
        IF v_colln_amt_less_prem_exempt - v_balance_due > p_param_premium_amt THEN
          p_premium_amt := p_param_premium_amt;
          v_balance_due := v_colln_amt_less_prem_exempt - p_param_premium_amt;
        ELSE
          p_premium_amt := (v_colln_amt_less_prem_exempt - v_balance_due) + p_prem_vat_exempt;
        END IF;
        p_tax_amt := p_collection_amt - p_premium_amt;
      END LOOP rec;
      INSERT INTO GIAC_TAX_COLLNS
        (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
         B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,
         B160_TAX_CD                    ,TAX_AMT                        ,
         FUND_CD                        ,REMARKS                        ,
         USER_ID                        ,LAST_UPDATE                    ,
         INST_NO                        )
      VALUES
        (p_tran_id                      ,p_tran_type                    ,
         p_iss_cd                       ,p_prem_Seq_no                  ,
         c1_rec.tax_cd                  ,v_balance_due                  ,
         c1_rec.fund_cd                 ,NULL                           ,
         user                           ,sysdate                  ,
         p_inst_no                      );
    END LOOP c1_rec;

    IF SWITCH != 'Y' THEN --no evat
      p_premium_amt := v_collection_amt;
      p_tax_amt := p_collection_amt - p_premium_amt;
      p_prem_vat_exempt := p_premium_amt; --added by alfie 09.23.2011
    END IF;
    
       --added by alfie 10.24.2010: to fetch out the selected records to webpage (JSON variable)
    OPEN P_GIAC_TAX_COLLNS_CUR FOR
      SELECT gtc.gacc_tran_id,
             gtc.transaction_type,
             gtc.b160_iss_cd,
             gtc.b160_prem_seq_no,
             gtc.b160_tax_cd,
             gtc.inst_no,
             gtc.fund_cd,
             gtc.tax_amt,
             gt.tax_name
        FROM giac_tax_collns gtc, giac_taxes gt
       WHERE gtc.gacc_tran_id     = p_tran_id
         AND gtc.b160_iss_cd      = p_iss_cd
         AND gtc.b160_prem_seq_no = p_prem_seq_no
         AND gtc.inst_no          = p_inst_no
         AND gt.tax_cd            = gtc.b160_tax_cd;
       --add ends
END;
/


