DROP PROCEDURE CPI.TAX_DEFAULT_VALUE_TYPE2;

CREATE OR REPLACE PROCEDURE CPI.Tax_Default_Value_Type2 (
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
  ,P_PREMIUM_AMT           OUT NUMBER--gdpc.premium_amt
  ,P_TAX_AMT               OUT NUMBER
  ,P_PREM_VAT_EXEMPT       IN OUT NUMBER --added by alfie 09.21.2011 
  ,P_GIAC_TAX_COLLNS_CUR   OUT giac_tax_collns_pkg.rc_giac_tax_collns_cur --added by alfie: 10.24.2010
  ) IS

    /*  if :parameter.collection_amt != tax collected amount
    **  then allocate tax collected amt to taxes other than EVAT, balance
    **  should be allocated to ratio of original premium_amt and evat amount
    **  (evat amount must first be determined)
    */
  param_value_evat         giac_parameters.param_value_n%TYPE; --for evat
  v_max_inst_no            gipi_installment.inst_no%TYPE;--holds the no of installment
  v_balance_amt_due        gipi_installment.prem_amt%TYPE;
  v_balance_due            gipi_installment.prem_amt%TYPE;
  v_tax_balance_due        gipi_installment.tax_amt%TYPE;
  v_collection_amt         giac_direct_prem_collns.collection_amt%TYPE;
  v_tax_inserted           giac_tax_collns.tax_amt%TYPE;
  v_curr_rt                gipi_invoice.currency_rt%TYPE;
  v_tax_alloc              gipi_inv_tax.tax_allocation%TYPE;
  SWITCH                   VARCHAR2(1) := 'N';
 
  v_colln_amt_less_prem_exempt NUMBER := 0; --added by alfie 09.22.2011

   /*  selects information of taxes in gipi_inv_tax per tax_cd per bill_no
   **  evat will always be retrieved last
   */
   CURSOR c1 IS
     SELECT A.iss_cd         , A.prem_seq_no     ,
            A.tax_cd         , NVL(A.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
            A.tax_allocation , b.fund_cd         ,
            A.line_cd        , c.currency_rt
     FROM   gipi_inv_tax A,
            giac_taxes   b,
            gipi_invoice c
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
     FROM   gipi_inv_tax A,
            giac_taxes   b,
            gipi_invoice c
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
     FROM   gipi_inv_tax A,
            giac_taxes   b,
            gipi_invoice c
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
     FROM   giac_tax_collns  A,
            giac_acctrans    b
     WHERE  A.gacc_tran_id = b.tran_id
     AND    A.b160_iss_cd = p_iss_cd
     AND    A.b160_prem_Seq_no = p_prem_Seq_no
     AND    b.tran_flag != 'D'
     AND    A.b160_tax_cd = p_tax_cd
     AND    A.gacc_tran_id = p_rev_tran_id
     AND    A.inst_no = p_inst_no
     AND    b.tran_id NOT IN (SELECT aa.gacc_tran_id
                              FROM giac_reversals aa,
                                   giac_acctrans  bb
                              WHERE aa.reversing_tran_id = bb.tran_id
                              AND bb.tran_flag != 'D') ;

   CURSOR c5 (p_tax_alloc  VARCHAR) IS
     SELECT A.iss_cd         , A.prem_seq_no     ,
            A.tax_cd         , NVL(A.tax_amt,0) * NVL(c.currency_rt,1) tax_amt   ,
            A.tax_allocation , b.fund_cd         ,
            A.line_cd        , c.currency_rt
     FROM   gipi_inv_tax A,
            giac_taxes   b,
            gipi_invoice c
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
--MESSAGE('TAX_DEFAULT_VALUE_type2');
--MESSAGE('TAX_DEFAULT_VALUE_type2');
--MESSAGE('parameter.collection_amt :  '|| to_char(:parameter.collection_amt));
--MESSAGE('parameter.premium_amt :  '|| to_char(:parameter.premium_amt));
--MESSAGE('parameter.tax_amt :  '|| to_char(:parameter.tax_amt));
  DELETE
  FROM giac_tax_collns
  WHERE gacc_tran_id = p_tran_id
  AND B160_iss_cd = p_iss_cd
  AND B160_prem_seq_no = p_prem_seq_no
  AND inst_no = p_inst_no
  AND transaction_type = p_tran_type;
  BEGIN
    SELECT param_value_n
    INTO param_value_evat
    FROM giac_parameters
    WHERE param_name LIKE 'EVAT';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      param_value_evat := NULL;
  END;

  /* to get the no of payments or inst_no */
  SELECT MAX(inst_no)
  INTO   v_max_inst_no
  FROM   gipi_installment
  WHERE  iss_cd = p_iss_Cd
  AND    prem_Seq_no = p_prem_seq_no;

  /* to get currency_rt for bill */
  SELECT DISTINCT currency_rt
  INTO v_curr_rt
  FROM GIPI_INVOICE
  WHERE iss_cd = p_iss_cd
  AND prem_seq_no = p_prem_Seq_no;
  v_curr_rt := NVL(v_curr_rt,1);

    IF P_TRAN_TYPE = 2  AND p_collection_amt < 0 THEN
       BEGIN
         SELECT DISTINCT tax_allocation
         INTO v_tax_alloc
         FROM gipi_inv_tax
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
           IF NVL(rec.tax_amt,0) != 0 THEN
             IF ABS(v_collection_amt) >= NVL(rec.tax_amt,0) THEN
               v_balance_due := NVL(rec.tax_amt,0) * -1 ;
             ELSE
               v_balance_due := v_collection_amt;
             END IF;
             v_collection_amt := v_collection_amt - v_balance_due;
             INSERT INTO giac_tax_collns
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
                 user                      ,sysdate                 ,
                 p_inst_no                      );
           END IF;
          END LOOP rec;
         END LOOP c1_rec;
         --FOR c1_rec IN c3 LOOP  --for evat only//
         --  SWITCH := 'Y';//
         --  FOR rec IN c4 (c1_rec.tax_cd) LOOP//
         --     v_balance_due := NVL(rec.tax_amt,0) + ABS(p_param_premium_amt);//

         --     IF v_balance_due != 0 THEN//
              
         --        v_balance_due := v_collection_amt * (NVL(rec.tax_amt,0) / v_balance_due);//
         --     END IF;//
         --     INSERT INTO giac_tax_collns//
         --       (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,//
         --        B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,//
         --        B160_TAX_CD                    ,TAX_AMT                        ,//
         --        FUND_CD                        ,REMARKS                        ,//
         --        USER_ID                        ,LAST_UPDATE                    ,//
         --        INST_NO                        )//
         --     VALUES//
         --       (p_tran_id                      ,p_tran_type                    ,//
         --        p_iss_cd                       ,p_prem_Seq_no                  ,//
         --        c1_rec.tax_cd                  ,v_balance_due                  ,//
         --        c1_rec.fund_cd                 ,NULL                           ,//
         --        user                      ,sysdate                  ,//
         --        p_inst_no                      );//
         --     p_premium_amt := v_collection_amt - v_balance_due;//
         --     p_tax_amt := p_collection_amt - p_premium_amt;//
         --  END LOOP;//
         --END LOOP c1_rec;//
         --IF SWITCH != 'Y' THEN//
            --p_premium_amt := v_collection_amt;//
            --p_tax_amt := p_collection_amt - p_premium_amt;//
         --END IF;//
       END IF;
       /**
       *** ALL SPREAD
       **/
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
           v_tax_balance_due  := 0;
           FOR c1_rec IN c2 LOOP
             FOR rec IN c4 (c1_rec.tax_cd) LOOP
               v_tax_balance_due := v_tax_balance_due + NVL(rec.tax_amt,0);
             END LOOP rec;
           END LOOP c1_rec;
           IF v_tax_balance_due != 0 THEN
            FOR c1_rec IN c2 LOOP
             FOR rec IN c4 (c1_rec.tax_cd) LOOP
               v_balance_due := v_collection_amt * ( NVL(rec.tax_amt,0) / v_tax_balance_due);
               IF NVL(rec.tax_amt,0) = 0 THEN
                  v_balance_due := 0;
               ELSE
                 IF ABS(v_balance_due) > NVL(rec.tax_amt,0) THEN
                    v_balance_due := NVL(rec.tax_amt,0) * -1 ;
                 END IF;
                 IF v_tax_inserted + v_balance_due < v_collection_amt THEN
                    v_balance_due := v_collection_amt - v_tax_inserted;
                 END IF;
               END IF;
               v_tax_inserted := v_tax_inserted + v_balance_due;
               INSERT INTO giac_tax_collns
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
            END LOOP c1_rec;
           END IF;
           v_collection_amt := v_collection_amt - v_tax_inserted;
           --FOR c1_rec IN c3 LOOP
             --SWITCH := 'Y'; --jason 1/20/2009//
    --FOR rec IN c4 (c1_rec.tax_cd) LOOP//
           --    v_tax_balance_due := NVL(rec.tax_amt,0) + ABS(p_param_premium_amt);//

           --    IF NVL(rec.tax_amt,0) != 0 THEN//
           --      v_balance_due := v_collection_amt * (NVL(rec.tax_amt,0) / v_tax_balance_due);//
           --    ELSE//
           --      v_balance_due := 0;//
           --    END IF;//
           --    p_premium_amt := v_collection_amt - v_balance_due;//
           --    p_tax_amt := p_collection_amt - p_premium_amt;//
           --    INSERT INTO giac_tax_collns//
           --        (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,
           --         B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,//
           --         B160_TAX_CD                    ,TAX_AMT                        ,//
           --         FUND_CD                        ,REMARKS                        ,//
           --         USER_ID                        ,LAST_UPDATE                    ,//
           --         INST_NO                        )//
           --    VALUES//
           --        (p_tran_id                      ,p_tran_type                    ,//
           --         p_iss_cd                       ,p_prem_Seq_no                  ,//
           --         c1_rec.tax_cd                  ,v_balance_due                  ,//
           --         c1_rec.fund_cd                 ,NULL                           ,//
           --         user                      ,sysdate                  ,//
           --         p_inst_no                      );//
           --  END LOOP;//
           --END LOOP c1_rec;//
     
     --added by jason start: 1/20/2009 without evat
     --IF SWITCH != 'Y' THEN//
     --        p_premium_amt := v_collection_amt;//
     --        p_tax_amt := p_collection_amt - p_premium_amt;//
     --      END IF;//
     --added by jason end: 1/20/2009 without evat
 
       END IF;  --if v_tax_alloc = 'S' then
    
       IF v_tax_alloc IS  NULL THEN
         /*
         **therefore there are mixed tax allocations in the bill
         **process everything the same as the normal process except for evat
         **the excess amount after the process should be allocated to evat 0
         */
         v_tax_inserted := 0;
         v_balance_amt_due := 0;
         v_collection_amt := p_collection_amt;
         IF p_inst_no = 1 THEN
         FOR c1_rec IN c5  ('F') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
             IF NVL(rec.tax_amt,0) != 0 THEN
                v_balance_due := NVL(rec.tax_amt,0) * -1;
                IF ABS(v_collection_amt) < rec.tax_amt THEN
                   v_balance_due := v_collection_amt;
                END IF;
             ELSIF NVL(rec.tax_amt,0) = 0 THEN
                v_balance_due := 0;
             END IF;
             v_collection_amt := v_collection_amt - v_balance_due;
             INSERT INTO giac_tax_collns
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
         END LOOP c1_rec;
         END IF;
         /**
         *** SPREAD - 'F''S''L'
         **/
         v_tax_balance_due := 0;
         FOR C1_REC IN c5 ('S') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
             v_tax_balance_due := v_tax_balance_due + NVL(rec.tax_amt,0);
           END LOOP rec;
         END LOOP c1_rec;
         IF v_tax_balance_due != 0 THEN
          FOR c1_rec IN c5 ('S') LOOP
           FOR rec IN c4 (c1_rec.tax_cd) LOOP
             IF NVL(rec.tax_amt,0) = 0 THEN
               v_balance_due := 0;
             ELSIF NVL(rec.tax_amt,0) != 0 THEN
               v_balance_due := v_collection_amt * (NVL(rec.tax_amt,0) / v_tax_balance_due);
               IF ABS(v_balance_due) > NVL(rec.tax_amt,0) THEN
                 v_balance_due := NVL(rec.tax_amt,0) * -1 ;
               END IF;
               IF ABS(v_tax_inserted) + ABS(v_balance_due) > ABS(v_collection_amt) THEN
                 v_balance_due := v_collection_amt - v_tax_inserted;
               END IF;
             END IF;
             v_tax_inserted := v_tax_inserted + v_balance_due;
             INSERT INTO giac_tax_collns
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
          END LOOP c1_rec;
         END IF;
         v_collection_amt := v_collection_amt - v_tax_inserted;
         /**
         *** LAST - 'F''S''L'
         **/
         FOR c1_rec IN c5  ('L') LOOP
            FOR rec IN c4 (c1_rec.tax_cd) LOOP
              IF NVL(rec.tax_amt,0) = 0 THEN
                v_balance_due := 0;
              ELSE
                v_balance_due := NVL(rec.tax_amt,0) * -1;
                IF ABS(v_collection_amt) < ABS(v_balance_due) THEN
                  v_balance_due := v_collection_amt;
                END IF;
              END IF;
              IF p_inst_no != v_max_inst_no THEN
                v_balance_due := 0;
              END IF;
              v_collection_amt := v_collection_amt - v_balance_due;
              INSERT INTO giac_tax_collns
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
         END LOOP c1_rec;
         --FOR c1_rec IN c3 LOOP//
         --  SWITCH := 'Y';//
         --  FOR rec IN c4 (c1_rec.tax_cd) LOOP//
         --    IF v_collection_amt != 0 THEN//
             
         --      IF SIGN(ABS(v_collection_amt) - ABS(p_prem_vat_exempt)) = -1 THEN//
         --        v_colln_amt_less_prem_exempt := 0;//
         --        p_prem_vat_exempt := v_collection_amt;//
         --      ELSIF SIGN(ABS(v_collection_amt) - ABS(p_prem_vat_exempt)) = 0 THEN//
         --        v_colln_amt_less_prem_exempt := 0;//
         --      ELSE//
         --        v_colln_amt_less_prem_exempt := -1 * (ABS(v_collection_amt) - ABS(p_prem_vat_exempt));//
         --      END IF;//
             
         --      v_balance_due := NVL(rec.tax_amt,0) + ABS(p_param_premium_amt);//

         --      IF NVL(rec.tax_amt,0) = 0 THEN//
         --        v_balance_due := 0;//
         --      ELSE//
         --        --v_balance_due := v_collection_amt * (NVL(rec.tax_amt,0) / v_balance_due);//
         --        v_balance_due := v_colln_amt_less_prem_exempt * (NVL(rec.tax_amt,0) / v_balance_due);//
         --      END IF;//
         --      INSERT INTO giac_tax_collns//
         --         (GACC_TRAN_ID                   ,TRANSACTION_TYPE               ,//
         --          B160_ISS_CD                    ,B160_PREM_SEQ_NO               ,//
         --          B160_TAX_CD                    ,TAX_AMT                        ,//
         --          FUND_CD                        ,REMARKS                        ,//
         --          USER_ID                        ,LAST_UPDATE                    ,//
         --          INST_NO                        )//
         --      VALUES//
         --         (p_tran_id                      ,p_tran_type                    ,//
         --          p_iss_cd                       ,p_prem_Seq_no                  ,//
         --          c1_rec.tax_cd                  ,v_balance_due                  ,//
         --          c1_rec.fund_cd                 ,NULL                           ,//
         --          user                      ,sysdate                  , //
         --          p_inst_no                      ); //
                   
         --      p_premium_amt := v_collection_amt - v_balance_due;  //
         --      p_tax_amt := p_collection_amt - p_premium_amt; //
         --    ELSE   --if v_collection_amt != 0 then //
         --      p_premium_amt := 0; //
         --      p_tax_amt := p_collection_amt; //
         --    END IF; //
         -- END LOOP rec; //
         --END LOOP c1_rec;  --L //
         --IF SWITCH != 'Y' THEN//
         --  p_premium_amt := v_collection_amt;//
         --  p_tax_amt := p_collection_amt - p_premium_amt;//
         --END IF; //
       END IF;  --v_tax_alloc is  null
    END IF; --P_TRAN_TYPE = 1  OR
    
    FOR c1_rec IN c3 LOOP
      SWITCH := 'Y';
      FOR rec IN c4 (c1_rec.tax_cd) LOOP
        IF v_collection_amt != 0 THEN
             
          IF SIGN(ABS(v_collection_amt) - ABS(p_prem_vat_exempt)) = -1 THEN
            v_colln_amt_less_prem_exempt := 0;
            p_prem_vat_exempt := v_collection_amt;
          ELSIF SIGN(ABS(v_collection_amt) - ABS(p_prem_vat_exempt)) = 0 THEN
            v_colln_amt_less_prem_exempt := 0;
          ELSE
            v_colln_amt_less_prem_exempt := -1 * (ABS(v_collection_amt) - ABS(p_prem_vat_exempt));
          END IF;
             
          v_balance_due := NVL(rec.tax_amt,0) + ABS(p_param_premium_amt);

          IF NVL(rec.tax_amt,0) = 0 THEN
            v_balance_due := 0;
          ELSE
            v_balance_due := v_colln_amt_less_prem_exempt * (NVL(rec.tax_amt,0) / v_balance_due);
          END IF;
          INSERT INTO giac_tax_collns
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
                   
          p_premium_amt := v_collection_amt - v_balance_due;
          p_tax_amt := p_collection_amt - p_premium_amt;
        ELSE   --if v_collection_amt != 0 then
          p_premium_amt := 0;
          p_tax_amt := p_collection_amt;
        END IF;
      END LOOP rec;
    END LOOP c1_rec;  --L
    IF SWITCH != 'Y' THEN
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


