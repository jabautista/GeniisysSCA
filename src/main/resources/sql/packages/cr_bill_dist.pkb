CREATE OR REPLACE PACKAGE BODY CPI.Cr_Bill_Dist AS
/* 051796  CALIGAEN    -  created create_winvoice based on NIIS
**         WPANGANIBAN -  created create_invoice based on the above procedure
**         MBISMARK    -  revise create_winvoice based on the needed information
** 031298  MBISMARK    -  created create_bill_dist that combines create_winvoice
**                        and create_distribution
*/
 -- Do the bill processing
 -- Determine the date coming from gipi_wpolbas
    PROCEDURE  GET_EFF_DATE(p_par_id NUMBER) IS
      BEGIN
        FOR A IN (SELECT NVL(eff_date,incept_date) incept-- jhing 11.07.2014 discrep between CS and web version is only on the variable used. Instead of a, CS used x
                    FROM GIPI_WPOLBAS
                   WHERE par_id = p_par_id) LOOP
            p_incept_date := A.incept;
            EXIT;
        END LOOP;
      END;
  -- Delete the related bill tables
    PROCEDURE  Delete_Bill(p_par_id NUMBER) IS
      BEGIN
         DELETE FROM GIPI_WINSTALLMENT
           WHERE  par_id  =  p_par_id;
         DELETE FROM GIPI_WCOMM_INVOICES
           WHERE  par_id  =  p_par_id;
         DELETE FROM GIPI_WINVPERL
           WHERE  par_id  =  p_par_id;
         DELETE FROM GIPI_WINV_TAX
           WHERE  par_id  =  p_par_id;
         DELETE FROM GIPI_WINVOICE
           WHERE  par_id  =  p_par_id;
      END;
  -- Get assured
    PROCEDURE Get_Assd_Name(p_par_id NUMBER,p_line_cd VARCHAR2) IS
      BEGIN
         -- jhing 11.07.2014 disregarded discrep between CS and web version. Discrep is only on variable name used. Instead of A, CS version used Y 
         FOR A IN (SELECT SUBSTR(b.assd_name,1,30) ASSD_NAME
                     FROM GIPI_PARLIST a, GIIS_ASSURED b
                    WHERE a.assd_no = b.assd_no
                      AND a.par_id  = p_par_id
                      AND a.line_cd = p_line_cd) LOOP
             p_assd_name := A.assd_name;
         END LOOP;
         IF p_assd_name IS NULL THEN
            p_assd_name := 'NULL';
         END IF;
      END;
  -- Get tax charges
    PROCEDURE GET_TAX(p_line_cd VARCHAR2,p_iss_cd VARCHAR2,p_incept_date DATE) IS
      BEGIN
          FOR A IN (SELECT B.tax_cd tax_cd,B.rate rate,B.tax_id tax_id
                      FROM GIIS_TAX_CHARGES B
                     WHERE B.eff_start_date < p_incept_date
                       AND B.peril_sw  = 'Y'
		       AND B.line_cd   = p_line_cd
                       AND B.iss_cd (+)= p_iss_cd) LOOP
                p_tax_amt          := NVL(prem_amt_per_group,0) + NVL(A.rate,0)/100;
                tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
          END LOOP;
      END;
  -- Insert invoice record
    PROCEDURE INS_WINV(p_par_id NUMBER) IS
      BEGIN
          INSERT INTO GIPI_WINVOICE
            (par_id,item_grp,payt_terms,prem_seq_no,prem_amt,tax_amt,property,
             insured,due_date,notarial_fee,ri_comm_amt,currency_cd,currency_rt,
             remarks,other_charges)
          VALUES
            (p_par_id,prev_item_grp,NULL,NULL,prem_amt_per_group,
             NVL(tax_amt_per_group1,0)+NVL(tax_amt_per_group2,0),NULL,p_assd_name,
             NULL,0,comm_amt_per_grp,prev_currency_cd,prev_currency_rt,NULL,NULL);
      END;
  -- Get tax charges (second option)
    PROCEDURE GET_TAX2(p_line_cd VARCHAR2,p_iss_cd VARCHAR2,
                       p_peril_cd NUMBER,p_par_id NUMBER) IS
      BEGIN
          FOR A IN (SELECT   B.tax_cd tax_cd,B.rate rate
                      FROM   GIIS_TAX_PERIL A, GIIS_TAX_CHARGES B
                     WHERE   A.peril_cd IN (SELECT   peril_cd
          				      FROM   GIPI_WITMPERL
				             WHERE   par_id  =  p_par_id)
			                       AND   A.iss_cd (+)=  B.iss_cd
			                       AND   A.line_cd   =  p_line_cd
			                       AND   A.iss_cd (+)=  p_iss_cd
			                       AND   A.line_cd   =  B.line_cd
			                       AND   A.tax_cd    =  B.tax_cd
			                       AND   A.peril_sw  =  'Y'
			                       AND   A.peril_cd  =  p_peril_cd
			                       AND   B.eff_start_date < p_incept_date
        			               AND   B.primary_sw=  'Y'
			                  GROUP BY   B.tax_cd,B.rate) LOOP
                p_tax_amt  :=  NVL(prem_amt_per_group,0) * NVL(a.rate,0)/100;
                tax_amt_per_peril := NVL(tax_amt_per_peril,0)+NVL(p_tax_amt,0);
                tax_amt_per_group2:= tax_amt_per_peril;
                 --NVL(tax_amt_per_group2,0)+tax_amt_per_peril
          END LOOP;
      END;
  -- Get tax charges (third option)
    PROCEDURE GET_TAX3(p_line_cd  VARCHAR2,p_iss_cd  VARCHAR2) IS
      BEGIN
          FOR A IN (SELECT   B.tax_cd,B.rate
                      FROM   GIIS_TAX_CHARGES B
                     WHERE   B.line_cd    =  p_line_cd
                       AND   B.eff_start_date < p_incept_date
                       AND   B.primary_sw = 'Y'
                       AND   B.peril_sw   = 'N'
                  GROUP BY   B.tax_cd, B.rate) LOOP
                  p_tax_amt  := NVL(prem_amt_per_group,0) * NVL(A.rate,0)/100;
                  tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
          END LOOP;
      END;
  -- Get tax
    PROCEDURE GET_TAX4(p_par_id  NUMBER,p_line_cd VARCHAR2,p_iss_cd VARCHAR2) IS
       CURSOR A IS SELECT  item_grp
                     FROM  GIPI_WITEM
                    WHERE  par_id  =  p_par_id
                 GROUP BY  item_grp;
       CURSOR B IS SELECT  tax_cd,rate,peril_sw,tax_id
                     FROM  GIIS_TAX_CHARGES
                    WHERE  eff_start_date < p_incept_date
                      AND  primary_sw     = 'Y'
                      AND  line_cd        = p_line_cd
                      AND  iss_cd      (+)= p_iss_cd;
       CURSOR C(p_item_grp GIPI_WITEM.item_grp%TYPE,p_tax_cd GIIS_TAX_CHARGES.tax_cd%TYPE)
                IS SELECT  B.item_grp item_grp,A.peril_cd peril_cd,
                           SUM(NVL(A.prem_amt,0)) prem_amt,SUM(NVL(A.tsi_amt,0)) tsi_amt
                     FROM  GIPI_WITMPERL A,GIPI_WITEM B
                    WHERE  A.peril_cd IN (SELECT peril_cd
					    FROM GIIS_TAX_PERIL
					   WHERE line_cd  =  p_line_cd
				             AND iss_cd   =  p_iss_cd
				             AND tax_cd   =  p_tax_cd)
                      AND  A.par_id   = B.par_id
                      AND  A.item_no  = B.item_no
                      AND  A.par_id   = p_par_id
                      AND  B.item_grp = p_item_grp
                 GROUP BY  B.item_grp,A.peril_cd;
       CURSOR D(p_tax_cd GIIS_TAX_CHARGES.tax_cd%TYPE,
                p_item_grp GIPI_WITEM.item_grp%TYPE)
              IS SELECT  B.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                           SUM(NVL(A.tsi_amt,0)) tsi_amt
                     FROM  GIPI_WITMPERL A, GIPI_WITEM B
                    WHERE  A.peril_cd IN (SELECT peril_cd
					    FROM   GIIS_TAX_PERIL
				           WHERE iss_cd  =  p_iss_cd
				             AND line_cd =  p_line_cd
				             AND tax_cd  =  p_tax_cd)
                      AND  A.par_id   =  B.par_id
                      AND  A.item_no  =  B.item_no
                      AND  A.par_id   =  p_par_id
                      AND  B.item_grp =  p_item_grp
                 GROUP BY  B.item_grp,A.peril_cd;
      BEGIN
       FOR A1 IN A LOOP
         FOR B1 IN B LOOP
           IF B1.peril_sw = 'N' THEN
             FOR C1 IN C(A1.item_grp,B1.tax_cd) LOOP
               p_tax_amt          :=  C1.prem_amt * B1.rate / 100;
               tax_amt_per_group1 :=  NVL(tax_amt_per_group1,0) + p_tax_amt;
             END LOOP;
           ELSE
             FOR D1 IN D(B1.tax_cd,A1.item_grp) LOOP
               p_tax_amt          :=  D1.prem_amt * B1.rate / 100;
               tax_amt_per_group1 :=  NVL(tax_amt_per_group1,0) + p_tax_amt;
             END LOOP;
           END IF;
           IF tax_amt_per_group1 != 0 THEN
             INSERT INTO GIPI_WINV_TAX
                (PAR_ID,ITEM_GRP,TAX_CD,LINE_CD,ISS_CD,TAX_AMT,TAX_ID)
             VALUES
                (p_par_id,A1.item_grp,B1.tax_cd,p_line_cd,p_iss_cd,
                 tax_amt_per_group1,B1.tax_id);
           END IF;
         END LOOP;
       END LOOP;
      END;
  -- Get grouping
    PROCEDURE GET_GROUPING(p_par_id NUMBER,p_line_cd VARCHAR2,p_iss_cd VARCHAR2) IS
      BEGIN
         FOR A IN (SELECT    B.item_grp,A.peril_cd,B.currency_cd,
                             B.currency_rt,SUM(NVL(A.tsi_amt,0)) tsi_amt,
                             SUM(NVL(A.prem_amt,0)) prem_amt,SUM(NVL(A.ri_comm_amt,0))
                             ri_comm_amt
                     FROM    GIPI_WITMPERL A, GIPI_WITEM B
                    WHERE    A.par_id   =  B.par_id
                      AND    A.item_no  =  B.item_no
                      AND    A.par_id   =  p_par_id
                 GROUP BY    B.par_id,B.item_grp,A.peril_cd,B.currency_cd,B.currency_rt) LOOP
             Cr_Bill_Dist.GET_TAX(p_line_cd,p_iss_cd,p_incept_date);
             Cr_Bill_Dist.INS_WINV(p_par_id);
             p_tax_amt  :=  0;
             prem_amt_per_group := 0;
             tax_amt_per_group1 := 0;
             tax_amt_per_group2 := 0;
             comm_amt_per_grp := 0;
             prem_amt_per_group := NVL(prem_amt_per_group,0) + A.prem_amt;
             comm_amt_per_grp := NVL(comm_amt_per_grp,0) + A.ri_comm_amt;
             Cr_Bill_Dist.GET_TAX2(p_line_cd,p_iss_cd,A.peril_cd,p_par_id);
             Cr_Bill_Dist.GET_TAX3(p_line_cd,p_iss_cd);
             Cr_Bill_Dist.GET_TAX4(p_par_id,p_line_cd,p_iss_cd);
         END LOOP;
      END;
  -- Insert into peril distribution table
    PROCEDURE WINVPERL(p_par_id  NUMBER,p_peril_cd NUMBER,p_item_grp NUMBER,
              p_tsi_amt NUMBER,p_prem_amt NUMBER,p_ri_comm_amt NUMBER,
              p_ri_comm_rt NUMBER) IS
      BEGIN
        INSERT INTO GIPI_WINVPERL
         (par_id,peril_cd,item_grp,tsi_amt,prem_amt,ri_comm_amt,ri_comm_rt)
        VALUES
         (p_par_id,p_peril_cd,p_item_grp,p_tsi_amt,p_prem_amt,p_ri_comm_amt,
          p_ri_comm_rt);
      END;
  -- Main program
    PROCEDURE PERIL(p_par_id NUMBER,p_line_cd NUMBER,p_iss_cd VARCHAR2) IS
      BEGIN
        Cr_Bill_Dist.GET_EFF_DATE(p_par_id);
        Cr_Bill_Dist.Delete_Bill(p_par_id);
        Cr_Bill_Dist.Get_Assd_Name(p_par_id,p_line_cd);
        Cr_Bill_Dist.GET_GROUPING(p_par_id,p_line_cd,p_iss_cd);
      END;
  -- Determine the tsi, annual tsi, and the premium of the items for that par
    PROCEDURE GET_TSI(p_par_id NUMBER) IS
    /* Modified by : Jhing 11.05.2014 consolidated CS and Web Versions to prevent NULL Takeup Seq No */       
        p_detect    VARCHAR2(1) := 'N';
        p_dist_no   GIUW_POL_DIST.dist_no%TYPE;
        v_line_cd   gipi_parlist.line_cd%TYPE;  -- jhing 11.05.2014 

        CURSOR B IS
               SELECT  pol_dist_dist_no_s.NEXTVAL
                 FROM  sys.dual;
      
      BEGIN
        FOR A IN (SELECT SUM(tsi_amt*NVL(currency_rt,1)) tsi,
                         SUM(prem_amt*NVL(currency_rt,1)) prem,
                         SUM(ann_tsi_amt*NVL(currency_rt,1)) ann_tsi
                    FROM GIPI_WITEM
                   WHERE par_id = p_par_id) LOOP
           v_tsi_amt     := A.tsi;
           v_prem_amt    := A.prem;
           v_ann_tsi_amt := A.ann_tsi;
           EXIT;
        END LOOP;
      
      -- jhing 11.05.2014   
      FOR LN IN (SELECT line_cd
                   FROM gipi_parlist
                  WHERE par_id = p_par_id)
      LOOP
         v_line_cd := LN.line_cd;
      END LOOP; 
      
      FOR a IN (SELECT   SUM (tsi_amt * NVL (currency_rt, 1)) tsi_amt,  --------------------------------------------A
                         SUM (prem_amt * NVL (currency_rt, 1)) prem_amt,
                         SUM (ann_tsi_amt * NVL (currency_rt, 1)) ann_tsi_amt,
                         item_grp
                    FROM gipi_witem
                   WHERE par_id = p_par_id
                GROUP BY item_grp)
      LOOP  
            p_detect := 'N';              
        
            IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)) THEN
               RAISE_APPLICATION_ERROR(-20001,'The tsi, premium, or annual tsi has no value.');
               --p_message := 'The tsi, premium, or annual tsi has no value.';
            END IF;
            
        FOR e IN
            (SELECT item_grp     --------------------------------------------------------E
               FROM giuw_pol_dist
              WHERE par_id = p_par_id)
         LOOP
            IF e.item_grp IS NULL  --------------------- SINGLE TAKEUP (ST ) 
            THEN                                                        
               FOR a1 IN
                  (SELECT dist_no   ---------------------------------------A1
                     FROM giuw_pol_dist
                    WHERE par_id = p_par_id)
               LOOP
                  FOR b1 IN (SELECT        dist_no, dist_seq_no ---------------------B1
                             FROM          giuw_policyds
                                     WHERE dist_no = a1.dist_no
                             FOR UPDATE OF dist_no, dist_seq_no)
                  LOOP
                     FOR c1 IN
                        (SELECT frps_yy,         ------------------------C1
                                frps_seq_no,      
                                line_cd
                           FROM giri_distfrps
                          WHERE dist_no = b1.dist_no
                            AND dist_seq_no = b1.dist_seq_no)
                     LOOP

                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has corresponding records in the posted tables for RI. '||
                                                    'Could not proceed.');
                       /* DELETE      giri_frps_peril_grp
                              WHERE line_cd = c1.line_cd --added line_cd. apignas_jr. 12.20.13 ( consolidated from CS version 11.05.2014) 
                                AND frps_yy = c1.frps_yy 
                                AND frps_seq_no = c1.frps_seq_no;  */ -- jhing 11.18.2014 commented out 
                     END LOOP;   --- end loop ------------------------ C1 
            
                     /*DELETE      giri_distfrps
                           WHERE dist_no = b1.dist_no 
                             AND dist_seq_no = b1.dist_seq_no;*/ -- jhing 11.18.2014 commented out 
                     DELETE      giuw_itemperilds_dtl
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_perilds_dtl
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_itemds_dtl
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_policyds_dtl
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_perilds
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_itemperilds
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_itemds
                           WHERE dist_no = a1.dist_no;

                     DELETE      giuw_policyds
                           WHERE dist_no = a1.dist_no;
                  END LOOP;   --- end loop ------------------------------------------- B1          
                  
                  cr_bill_dist.delete_dist (a1.dist_no, p_par_id);
                  p_detect := 'Y';
                  EXIT;
               END LOOP;  --- end loop -------------------------------------- A1             
            END IF;                                  --end if item_grp is null   (  SINGLE TAKEUP (ST )        )
            
            EXIT;
         END LOOP; --- end loop ---------------------------------------------------------------- E                  

      
         FOR ax IN
            (SELECT dist_no     --------------------------------------------Ax
               FROM giuw_pol_dist
              WHERE par_id = p_par_id AND item_grp(+) = a.item_grp)
         LOOP
            FOR bx IN (SELECT        dist_no, dist_seq_no ------------------------------Bx
                       FROM          giuw_policyds
                               WHERE dist_no = ax.dist_no
                       FOR UPDATE OF dist_no, dist_seq_no)
            LOOP

               FOR cx IN (SELECT frps_yy,
                                 frps_seq_no,    ---------------------------Cx
                                 line_cd
                            FROM giri_distfrps
                           WHERE dist_no = bx.dist_no
                             AND dist_seq_no = bx.dist_seq_no)
               LOOP
               
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has corresponding records in the posted tables for RI. '||
                                                    'Could not proceed.');    -- jhing 11.19.2014         
               
                 /* DELETE      giri_frps_peril_grp
                        WHERE line_cd = cx.line_cd --added line_cd. apignas_jr. 12.20.13 ( consolidated from CS 11.05.2014 ) 
                          AND frps_yy = cx.frps_yy
                          AND frps_seq_no = cx.frps_seq_no; */ -- jhing commented out 11.19.2014. There should be no action that can delete posted binders
               END LOOP;-------------------end loop -------------------------------------Cx



              /* DELETE      giri_distfrps
                     WHERE dist_no = bx.dist_no
                       AND dist_seq_no = bx.dist_seq_no; */ -- jhing commented out 11.19.2014 
               DELETE      giuw_itemperilds_dtl
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_perilds_dtl
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_itemds_dtl
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_policyds_dtl
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_perilds
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_itemperilds
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_itemds
                     WHERE dist_no = ax.dist_no;

               DELETE      giuw_policyds
                     WHERE dist_no = ax.dist_no;
            END LOOP;  ------------------end loop ----------------------------------------Bx


            v_tsi_amt := a.tsi_amt;
            v_prem_amt := a.prem_amt;
            v_ann_tsi_amt := a.ann_tsi_amt;
            cr_bill_dist.delete_dist (ax.dist_no, p_par_id);
            p_detect := 'Y';
         -- EXIT;
         END LOOP;------------------------end loop ------------------------------------Ax


         IF p_detect = 'N'
         THEN
                      /*FOR A IN (SELECT eff_date,expiry_date,endt_type
                                  FROM gipi_wpolbas WHERE par_id = p_par_id) LOOP*/
            --------------------- MODIFIED BY GMI 01/23/08 from here -----------------------------
            DECLARE
               p_no_of_takeup    giis_takeup_term.no_of_takeup%TYPE;
               p_yearly_tag      giis_takeup_term.yearly_tag%TYPE;
               p_takeup_term     gipi_wpolbas.takeup_term%TYPE;
               p_eff_date        gipi_wpolbas.eff_date%TYPE;
               p_expiry_date     gipi_wpolbas.expiry_date%TYPE;
               p_endt_type       gipi_wpolbas.endt_type%TYPE;
               p_policy_id       gipi_polbasic.policy_id%TYPE;
               v_policy_days     NUMBER                               := 0;
               v_no_of_payment   NUMBER                               := 1;
               v_duration_frm    DATE;
               v_duration_to     DATE;
               v_days_interval   NUMBER                               := 0;
               v_exist           VARCHAR2 (1)                         := 'N';
            --added by glyza 03.24.08
            BEGIN
               SELECT eff_date, expiry_date, endt_type, takeup_term
                 INTO p_eff_date, p_expiry_date, p_endt_type, p_takeup_term
                 FROM gipi_wpolbas
                WHERE par_id = p_par_id;

               IF ((p_eff_date IS NULL) OR (p_expiry_date IS NULL))
               THEN
                  raise_application_error
                               (-20003,
                                'Effectivity or expiry has not been updated.'
                               );
               END IF;

               --added by glyza 03.24.08 to check if par_id is in giuw_pol_dist
               --applicable only for Single takeup
               FOR i IN
                  (SELECT 1  ------------------------------------------------I
                     FROM giuw_pol_dist
                    WHERE par_id = p_par_id)
               LOOP
                  v_exist := 'Y';
                  EXIT;
               END LOOP; ------------end loop ----------------------------------------------I

               ----------------------------------------------------------------
               IF TRUNC (p_expiry_date - p_eff_date) = 31
               THEN
                  v_policy_days := 30;
               ELSE
                  v_policy_days := TRUNC (p_expiry_date - p_eff_date);
               END IF;

               FOR b1 IN (SELECT no_of_takeup, yearly_tag
                            FROM giis_takeup_term
                           WHERE takeup_term = p_takeup_term)
               LOOP
                  p_no_of_takeup := b1.no_of_takeup;
                  p_yearly_tag := b1.yearly_tag;
               END LOOP;

               IF p_yearly_tag = 'Y'
               THEN
                  IF TRUNC ((v_policy_days) / 365, 2) * p_no_of_takeup >
                        TRUNC (  TRUNC ((v_policy_days) / 365, 2)
                               * p_no_of_takeup
                              )
                  THEN
                     v_no_of_payment :=
                          TRUNC (  TRUNC ((v_policy_days) / 365, 2)
                                 * p_no_of_takeup
                                )
                        + 1;
                  ELSE
                     v_no_of_payment :=
                        TRUNC (  TRUNC ((v_policy_days) / 365, 2)
                               * p_no_of_takeup
                              );
                  END IF;
               ELSE
                  IF v_policy_days < p_no_of_takeup
                  THEN
                     v_no_of_payment := v_policy_days;
                  ELSE
                     v_no_of_payment := p_no_of_takeup;
                  END IF;
               END IF;

               IF NVL (v_no_of_payment, 0) < 1
               THEN
                  v_no_of_payment := 1;
               END IF;

               v_days_interval := ROUND (v_policy_days / v_no_of_payment);
               p_policy_id := NULL;

               IF v_no_of_payment = 1  -------------------------------------------------------- IF: Single takeup (x)
               THEN 

                  IF v_exist = 'N'
                  THEN
                     OPEN b;

                     FETCH b
                      INTO p_dist_no;

                     IF b%NOTFOUND
                     THEN
                        raise_application_error (-20004,
                                                 'No row in table DUAL.'
                                                );
                     END IF;

                     CLOSE b;

                     INSERT INTO giuw_pol_dist
                                 (dist_no, par_id, policy_id,
                                  endt_type, tsi_amt,
                                  prem_amt,
                                  ann_tsi_amt, dist_flag, redist_flag,
                                  eff_date, expiry_date, create_date,
                                  user_id, last_upd_date, post_flag,
                                  auto_dist,
                                            -- longterm --
                                            item_grp, takeup_seq_no
                                 )
                          VALUES (p_dist_no, p_par_id, p_policy_id,
                                  p_endt_type, NVL (v_tsi_amt, 0),
                                  NVL (v_prem_amt, 0),
                                  NVL (v_ann_tsi_amt, 0), 1, 1,
                                  p_eff_date, p_expiry_date, SYSDATE,
                                  USER, SYSDATE, 'O',
                                  'N',
                                      -- longterm --
                                      --NULL, NULL);
                                  NULL, v_no_of_payment
                                 );                              --VJPS 053112
                  -- EXIT;
                  ELSE              --if v_exist = 'Y' added by glyza 03.24.08
   
                     UPDATE giuw_pol_dist
                        SET tsi_amt = NVL (v_tsi_amt, 0),
                            prem_amt = NVL (v_prem_amt, 0),
                            ann_tsi_amt = NVL (v_ann_tsi_amt, 0)
                      WHERE par_id = p_par_id;
                  END IF;

                  EXIT;
               ELSE  --------------------------------------------------------------------------------- ELSE: MULTI TAKE-UP (x)

                  v_duration_frm := NULL;
                  v_duration_to := NULL;

                  FOR takeup_val IN 1 .. v_no_of_payment  ---------------------------------- LONG TERM LOOP start
                  LOOP
                     IF v_duration_frm IS NULL
                     THEN
                        v_duration_frm := TRUNC (p_eff_date);
                     ELSE
                        v_duration_frm :=
                                     TRUNC (v_duration_frm + v_days_interval);
                     END IF;

                     v_duration_to :=
                                   TRUNC (v_duration_frm + v_days_interval)
                                   - 1;

                     OPEN b;

                     FETCH b
                      INTO p_dist_no;

                     IF b%NOTFOUND
                     THEN
                        raise_application_error (-20004,
                                                 'No row in table DUAL.'
                                                );
                     END IF;

                     CLOSE b;

                     IF takeup_val = v_no_of_payment
                     THEN
                        --------------------------------------------- IF: last loop record (y)
                                        --aron 06302008
                                        -- modified select statement so that only the premium and not the tsi amount is divided by the no of payment
                        FOR xyz IN
                           (SELECT SUM
                                      (  (  NVL (DECODE (c.peril_type,
                                                         'B', x.tsi_amt,
                                                         0
                                                        ),
                                                 0
                                                )
                                          * NVL (currency_rt, 1)
                                         )
                                       - (  ROUND
                                               ((  (  NVL
                                                         (DECODE
                                                                (c.peril_type,
                                                                 'B', x.tsi_amt,
                                                                 0
                                                                ),
                                                          0
                                                         )
                                                    * NVL (currency_rt, 1)
                                                   )
                                                 / 1       /*v_no_of_payment*/
                                                ),
                                                2
                                               )
                                          * ( /*v_no_of_payment*/ 1 - 1)
                                         )
                                      ) tsi_amt,
                                   SUM
                                      (  (  NVL (x.prem_amt, 0)
                                          * NVL (currency_rt, 1)
                                         )
                                       - (  ROUND ((  (  NVL (x.prem_amt, 0)
                                                       * NVL (currency_rt, 1)
                                                      )
                                                    / v_no_of_payment
                                                   ),
                                                   2
                                                  )
                                          * (v_no_of_payment - 1)
                                         )
                                      ) prem_amt,
                                   SUM
                                      (  (  NVL (DECODE (c.peril_type,
                                                         'B', x.ann_tsi_amt,
                                                         0
                                                        ),
                                                 0
                                                )
                                          * NVL (currency_rt, 1)
                                         )
                                       - (  ROUND
                                               ((  (  NVL
                                                         (DECODE
                                                               (c.peril_type,
                                                                'B', x.ann_tsi_amt,
                                                                0
                                                               ),
                                                          0
                                                         )
                                                    * NVL (currency_rt, 1)
                                                   )
                                                 / 1       /*v_no_of_payment*/
                                                ),
                                                2
                                               )
                                          * (1 /*v_no_of_payment*/ - 1)
                                         )
                                      ) ann_tsi_amt
                              FROM gipi_witmperl x,
                                   gipi_witem b,
                                   giis_peril c
                             WHERE x.par_id = b.par_id
                               AND x.item_no = b.item_no
                               AND x.par_id = p_par_id
                               AND b.item_grp = a.item_grp
                               AND x.peril_cd = c.peril_cd
                               AND c.line_cd = v_line_cd)
                        --NVL(:c080.item_grp, p_item_grp))*/
                        LOOP
                           INSERT INTO giuw_pol_dist
                                       (dist_no, par_id, policy_id,
                                        endt_type, dist_flag, redist_flag,
                                        eff_date, expiry_date,
                                        create_date, user_id, last_upd_date,
                                        post_flag, auto_dist, tsi_amt,
                                        prem_amt, ann_tsi_amt,
                                        -- longterm --
                                        item_grp, takeup_seq_no
                                       )
                                VALUES (p_dist_no, p_par_id, p_policy_id,
                                        p_endt_type, 1, 1,
                                        v_duration_frm, v_duration_to,
                                        SYSDATE, USER, SYSDATE,
                                        'O', 'N', xyz.tsi_amt,
                                        --NVL(a.tsi_amt,0) - (ROUND((NVL(a.tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                        xyz.prem_amt,
                                        --NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                                     xyz.ann_tsi_amt,
                                        --NVL(a.ann_tsi_amt,0) - (ROUND((NVL(a.ann_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                        -- longterm --
                                        a.item_grp, takeup_val
                                       );
                        END LOOP;
                     ELSE  ----------------------------------------------------------------------------- ELSE: other loop records (y)
                          --aron 06302008
                        -- modified select statement so that only the premium and not the tsi amount is divided by the no of payment
                        FOR xyz IN
                           (SELECT SUM
                                      (ROUND ((  (  NVL
                                                       (DECODE (c.peril_type,
                                                                'B', x.tsi_amt,
                                                                0
                                                               ),
                                                        0
                                                       )
                                                  * NVL (currency_rt, 1)
                                                 )
                                               / 1         /*v_no_of_payment*/
                                              ),
                                              2
                                             )
                                      ) tsi_amt,
                                   SUM (ROUND ((  (  NVL (x.prem_amt, 0)
                                                   * NVL (currency_rt, 1)
                                                  )
                                                / v_no_of_payment
                                               ),
                                               2
                                              )
                                       ) prem_amt,
                                   SUM
                                      (ROUND
                                            ((  (  NVL
                                                      (DECODE (c.peril_type,
                                                               'B', x.ann_tsi_amt,
                                                               0
                                                              ),
                                                       0
                                                      )
                                                 * NVL (currency_rt, 1)
                                                )
                                              / 1          /*v_no_of_payment*/
                                             ),
                                             2
                                            )
                                      ) ann_tsi_amt
                              FROM gipi_witmperl x,
                                   gipi_witem b,
                                   giis_peril c
                             WHERE x.par_id = b.par_id
                               AND x.item_no = b.item_no
                               AND x.par_id = p_par_id
                               AND b.item_grp = a.item_grp
                               AND x.peril_cd = c.peril_cd
                               AND c.line_cd = v_line_cd)
                        --NVL(:c080.item_grp, p_item_grp))*/
                        LOOP
                           INSERT INTO giuw_pol_dist
                                       (dist_no, par_id, policy_id,
                                        endt_type, dist_flag, redist_flag,
                                        eff_date, expiry_date,
                                        create_date, user_id, last_upd_date,
                                        post_flag, auto_dist, tsi_amt,
                                        prem_amt, ann_tsi_amt,
                                        -- longterm --
                                        item_grp, takeup_seq_no
                                       )
                                VALUES (p_dist_no, p_par_id, p_policy_id,
                                        p_endt_type, 1, 1,
                                        v_duration_frm, v_duration_to,
                                        SYSDATE, USER, SYSDATE,
                                        'O', 'N', xyz.tsi_amt,
                                        --(NVL(a.tsi_amt,0)/ v_no_of_payment),
                                        xyz.prem_amt,
                                                     --(NVL(a.prem_amt,0)/ v_no_of_payment),
                                                     xyz.ann_tsi_amt,
                                        --(NVL(a.ann_tsi_amt,0)/ v_no_of_payment),
                                            -- longterm --
                                        a.item_grp, takeup_val
                                       );
                        END LOOP;
                     END IF;  -------------------------------------------------------------------------- END IF: loop record (y)

                  END LOOP;   ------------------------------------------------------------------------------------ LONG TERM LOOP end

               END IF;   ------------------------------------------------------------------------------ END IF TAKEUPS (x)

            EXCEPTION
               WHEN TOO_MANY_ROWS
               THEN
                  raise_application_error
                     (-20004,
                         'Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '
                      || 'to rectify the matter. Check record with par_id = '
                      || TO_CHAR (p_par_id)
                     );
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20004,
                      'You have committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.'
                     );
            END;
         --------------------- MODIFIED BY GMI 01/23/08 upto here -----------------------------
         END IF;
      END LOOP;
      /*added by edgar 08/14/2014*/ -- consolidated from CS version 
      DECLARE
        v_takeup        gipi_polbasic.takeup_term%TYPE;
        v_takeup_seq_no giuw_pol_dist.takeup_seq_no%TYPE;
      BEGIN
        BEGIN
            SELECT takeup_seq_no
              INTO v_takeup_seq_no
              FROM giuw_pol_dist
             WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN  --added by robert GENQA 4844 09.02.15
            NULL; --added by robert GENQA 4844 09.02.15
			WHEN TOO_MANY_ROWS THEN
            v_takeup_seq_no := 1;
        END;
        IF v_takeup_seq_no IS NULL THEN
            FOR par IN (SELECT par_status, par_id
                          FROM gipi_parlist
                         WHERE par_id = p_par_id)
            LOOP
                IF par.par_status = 10 THEN
                    SELECT NVL(takeup_term,'ST')
                      INTO v_takeup
                      FROM gipi_polbasic
                     WHERE par_id = par.par_id;
                    
                    IF v_takeup = 'ST'
                    THEN
                        UPDATE giuw_pol_dist
                           SET takeup_seq_no = 1
                         WHERE par_id = par.par_id;
                    ELSE
                        NULL;
                    END IF;
                ELSE
                    SELECT NVL(takeup_term,'ST')
                      INTO v_takeup
                      FROM gipi_wpolbas
                     WHERE par_id = par.par_id;
                    
                    IF v_takeup = 'ST'
                    THEN
                        UPDATE giuw_pol_dist
                           SET takeup_seq_no = 1
                         WHERE par_id = par.par_id;
                    ELSE
                        NULL;
                    END IF;                
                END IF;
            END LOOP;
        END IF;
        
        UPDATE giuw_pol_dist
           SET special_dist_sw = NULL
         WHERE par_id = p_par_id;
      END;
      /*ended edgar 08/14/2014*/      

            
    --   // ****************************************************************************************************************************** 
	-- jhing 11.05.2014 commented out and replaced with codes from CS version to properly handle long term distribution 	
    /*    FOR A IN (SELECT dist_no FROM GIUW_POL_DIST
                   WHERE par_id = p_par_id) LOOP
            FOR B IN (SELECT dist_no,dist_seq_no FROM GIUW_POLICYDS WHERE dist_no = A.dist_no
                         FOR UPDATE OF dist_no,dist_seq_no) LOOP
              --RAISE_APPLICATION_ERROR(-20001,'Posted distribution record exists,
              --cannot proceed.');
                 FOR C IN (SELECT frps_yy,frps_seq_no FROM GIRI_DISTFRPS
                            WHERE dist_no  =  B.dist_no AND dist_seq_no = B.dist_seq_no) LOOP
                    DELETE   GIRI_FRPS_PERIL_GRP
                     WHERE   frps_yy     =  C.frps_yy
                       AND   frps_seq_no =  C.frps_seq_no;
                 END LOOP;
                 DELETE    GIRI_DISTFRPS
                  WHERE    dist_no     =  B.dist_no
                    AND    dist_seq_no =  B.dist_seq_no;
            DELETE   GIUW_ITEMPERILDS_DTL
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_PERILDS_DTL
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_ITEMDS_DTL
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_POLICYDS_DTL
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_PERILDS
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_ITEMPERILDS
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_ITEMDS
             WHERE   dist_no  =  A.dist_no;
            DELETE   GIUW_POLICYDS
             WHERE   dist_no  =  A.dist_no;
            END LOOP;
            Cr_Bill_Dist.DELETE_DIST(A.dist_no,p_par_id);
            p_detect := 'Y';
            EXIT;
        END LOOP;
		
        IF p_detect = 'N' THEN
            FOR A IN (SELECT eff_date,expiry_date,endt_type
                        FROM GIPI_WPOLBAS WHERE par_id = p_par_id) LOOP
              IF ((A.eff_date IS NULL) OR (A.expiry_date IS NULL)) THEN
                RAISE_APPLICATION_ERROR(-20003,'Effectivity or expiry has not been updated.');
				--p_message := 'Effectivity or expiry has not been updated.';
              END IF;
              OPEN B;
              FETCH B INTO p_dist_no;
              IF B%NOTFOUND THEN
                RAISE_APPLICATION_ERROR(-20004,'No row in table DUAL.');
				--p_message := 'No row in table DUAL.';
				--EXIT;
              END IF;
              CLOSE B;
              INSERT INTO GIUW_POL_DIST(dist_no,par_id,policy_id,endt_type,tsi_amt,
                     prem_amt,ann_tsi_amt,dist_flag,redist_flag,eff_date,expiry_date,
                     create_date,user_id,last_upd_date)
              VALUES(p_dist_no,p_par_id,NULL,A.endt_type,NVL(v_tsi_amt,0),NVL(v_prem_amt,0),
                     NVL(v_ann_tsi_amt,0),1,1,A.eff_date,A.expiry_date,SYSDATE,USER,SYSDATE);
            END LOOP;
        END IF; */
		
      END;
  -- Determine the response of the user if he wants to continue to replace existing
  -- distribution records or not
    FUNCTION CHANGE_DIST(p_dist_no NUMBER) RETURN VARCHAR2 IS
        p_ans     VARCHAR2(1);
      BEGIN
        FOR A IN (SELECT 1 FROM GIUW_WPOLICYDS WHERE dist_no = p_dist_no) LOOP
            p_alert := 'Y';
            p_ans   := p_alert;
            EXIT;
        END LOOP;
        RETURN(p_ans);
        -- After this procedure, an alert should be called by the application to state that
        -- an existing distribution record exists to notify the user whether he wants to
        -- update his record or not.
      END;
  -- Delete the distribution records with the same distribution number
    PROCEDURE DELETE_DIST(p_dist_no NUMBER,p_par_id NUMBER) IS
       -- jhing 11.07.2014 integrated from CS version 
      dist_cnt   NUMBER                        := 0;
      dist_max   giuw_pol_dist.dist_no%TYPE;
      dist_min   giuw_pol_dist.dist_no%TYPE;
      dist_grp   giuw_pol_dist.item_grp%TYPE;
   
      BEGIN
      
       -- jhing 11.07.2014 integrated from CS version
      FOR xxx IN (SELECT   COUNT (dist_no) cnt_dist_no,
                           MAX (dist_no) max_dist_no,
                           MIN (dist_no) min_dist_no, item_grp
                      FROM giuw_pol_dist
                     WHERE par_id = p_par_id
                  GROUP BY item_grp)
      LOOP
         IF p_dist_no BETWEEN xxx.min_dist_no AND xxx.max_dist_no
         THEN
            dist_cnt := xxx.cnt_dist_no;
            dist_max := xxx.max_dist_no;
            dist_min := xxx.min_dist_no;
            dist_grp := xxx.item_grp;
            EXIT;
         END IF;
      END LOOP;     
       -- end of integrated codes ( jhing 11.07.2014 )
       
        DELETE   GIUW_WPERILDS_DTL
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WITEMDS_DTL
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WPOLICYDS_DTL
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WPERILDS
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WITEMPERILDS_DTL
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WITEMPERILDS
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WITEMDS
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIRI_WDISTFRPS
         WHERE   dist_no  =  p_dist_no;
        DELETE   GIUW_WPOLICYDS
         WHERE   dist_no  =  p_dist_no;
        
        -- jhing 11.07.2014 commented out to be replaced by the codes from CS version ( to handle long term)
       /* UPDATE   GIUW_POL_DIST
           SET   tsi_amt  =  NVL(v_tsi_amt,0), prem_amt  = NVL(v_prem_amt,0),
                 ann_tsi_amt = NVL(v_ann_tsi_amt,0), last_upd_date = SYSDATE,
                 user_id     = USER
         WHERE   par_id      = p_par_id
           AND   dist_no     = p_dist_no; */
           
       -- begin of codes integrated from CS version - jhing 11.07.2014
      IF p_dist_no = dist_max
      THEN
         IF dist_grp IS NULL
         THEN
            FOR xyz IN
               (SELECT SUM ((  NVL (DECODE (d.peril_type, 'B', a.tsi_amt, 0),
                                    0
                                   )
                             * NVL (currency_rt, 1)
                            )
                           ) tsi_amt,
                       SUM (  (NVL (a.prem_amt, 0) * NVL (currency_rt, 1))
                            - (  ROUND ((  (  NVL (a.prem_amt, 0)
                                            * NVL (currency_rt, 1)
                                           )
                                         / dist_cnt
                                        ),
                                        2
                                       )
                               * (dist_cnt - 1)
                              )
                           ) prem_amt,
                       SUM ((  NVL (DECODE (d.peril_type,
                                            'B', a.ann_tsi_amt,
                                            0
                                           ),
                                    0
                                   )
                             * NVL (currency_rt, 1)
                            )
                           ) ann_tsi_amt
                  FROM gipi_witmperl a,
                       gipi_witem b,
                       giuw_pol_dist c,
                       giis_peril d
                 WHERE a.par_id = b.par_id
                   AND a.item_no = b.item_no
                   AND a.par_id = p_par_id
                   AND a.par_id = c.par_id
                   AND d.line_cd = a.line_cd
                   AND a.peril_cd = d.peril_cd
                   AND c.item_grp IS NULL)
                   --NVL(:c080.item_grp, p_item_grp))*/
            LOOP
               UPDATE giuw_pol_dist
                  SET tsi_amt = xyz.tsi_amt,
                      --NVL(v_tsi_amt,0) - (ROUND((NVL(v_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                      prem_amt = xyz.prem_amt,
                      --NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                      ann_tsi_amt = xyz.ann_tsi_amt,
                      --NVL(v_ann_tsi_amt,0) - (ROUND((NVL(v_ann_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                      last_upd_date = SYSDATE,
                      user_id = USER
                WHERE par_id = p_par_id AND dist_no = p_dist_no;
            END LOOP;
         ELSE
            /*modified by VJ 062708, to consider basic perils only*/
            FOR xyz IN (SELECT SUM ((  NVL (DECODE (c.peril_type,
                                                    'B', a.tsi_amt,
                                                    0
                                                   ),
                                            0
                                           )
                                     * NVL (currency_rt, 1)
                                    )
                                   ) tsi_amt,
                               SUM (  (  NVL (a.prem_amt, 0)
                                       * NVL (currency_rt, 1)
                                      )
                                    - (  ROUND ((  (  NVL (a.prem_amt, 0)
                                                    * NVL (currency_rt, 1)
                                                   )
                                                 / dist_cnt
                                                ),
                                                2
                                               )
                                       * (dist_cnt - 1)
                                      )
                                   ) prem_amt,
                               SUM ((  NVL (a.ann_tsi_amt, 0)
                                     * NVL (currency_rt, 1)
                                    )
                                   ) ann_tsi_amt
                          FROM gipi_witmperl a, gipi_witem b, giis_peril c
                         WHERE a.par_id = b.par_id
                           AND a.item_no = b.item_no
                           /*added by VJ 062708, to consider basic perils only*/
                           AND a.line_cd = c.line_cd
                           AND a.peril_cd = c.peril_cd
                           /*end mod VJ*/
                           AND a.par_id = p_par_id
                           AND b.item_grp = dist_grp)
                           --NVL(:c080.item_grp, p_item_grp))*/
            LOOP
               UPDATE giuw_pol_dist
                  SET tsi_amt = xyz.tsi_amt,
                      --NVL(v_tsi_amt,0) - (ROUND((NVL(v_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                      prem_amt = xyz.prem_amt,
                      --NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                      ann_tsi_amt = xyz.ann_tsi_amt,
                      --NVL(v_ann_tsi_amt,0) - (ROUND((NVL(v_ann_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                      last_upd_date = SYSDATE,
                      user_id = USER
                WHERE par_id = p_par_id AND dist_no = p_dist_no;
            END LOOP;
         END IF;
      ELSE
         IF dist_grp IS NULL
         THEN
            /*modified by VJ 062708, to consider basic perils only*/
            FOR xyz IN
               (SELECT SUM (ROUND (((  NVL (DECODE (d.peril_type,
                                                    'B', a.tsi_amt,
                                                    0
                                                   ),
                                            0
                                           )
                                     * NVL (currency_rt, 1)
                                    )
                                   ),
                                   2
                                  )
                           ) tsi_amt,
                       SUM (ROUND ((  (  NVL (a.prem_amt, 0)
                                       * NVL (currency_rt, 1)
                                      )
                                    / dist_cnt
                                   ),
                                   2
                                  )
                           ) prem_amt,
                       SUM (ROUND (((  NVL (a.ann_tsi_amt, 0)
                                     * NVL (currency_rt, 1)
                                    )
                                   ),
                                   2
                                  )
                           ) ann_tsi_amt
                  FROM gipi_witmperl a,
                       gipi_witem b,
                       giuw_pol_dist c,
                       giis_peril d
                 WHERE a.par_id = b.par_id
                   AND a.item_no = b.item_no
                   /*added by VJ 062708, to consider basic perils only*/
                   AND a.line_cd = d.line_cd
                   AND a.peril_cd = d.peril_cd
                   /*end mod VJ*/
                   AND a.par_id = p_par_id
                   AND a.par_id = c.par_id
                   AND c.item_grp IS NULL)
            --NVL(:c080.item_grp, p_item_grp))*/
            LOOP
               UPDATE giuw_pol_dist
                  SET tsi_amt = xyz.tsi_amt,
                      --NVL(v_tsi_amt,0)     / dist_cnt,
                      prem_amt = xyz.prem_amt,
                      --NVL(v_prem_amt,0)    / dist_cnt,
                      ann_tsi_amt = xyz.ann_tsi_amt,
                      --NVL(v_ann_tsi_amt,0) / dist_cnt,
                      last_upd_date = SYSDATE,
                      user_id = USER
                WHERE par_id = p_par_id AND dist_no = p_dist_no;
            END LOOP;
         ELSE
            /*modified by VJ 062708, to consider basic perils only*/
            FOR xyz IN
               (SELECT SUM (ROUND (((  NVL (DECODE (c.peril_type,
                                                    'B', a.tsi_amt,
                                                    0
                                                   ),
                                            0
                                           )
                                     * NVL (currency_rt, 1)
                                    )
                                   ),
                                   2
                                  )
                           ) tsi_amt,
                       SUM (ROUND ((  (  NVL (a.prem_amt, 0)
                                       * NVL (currency_rt, 1)
                                      )
                                    / dist_cnt
                                   ),
                                   2
                                  )
                           ) prem_amt,
                       SUM (ROUND (((  NVL (a.ann_tsi_amt, 0)
                                     * NVL (currency_rt, 1)
                                    )
                                   ),
                                   2
                                  )
                           ) ann_tsi_amt
                  FROM gipi_witmperl a, gipi_witem b, giis_peril c
                 WHERE a.par_id = b.par_id
                   AND a.item_no = b.item_no
                   /*added by VJ 062708, to consider basic perils only*/
                   AND a.line_cd = c.line_cd
                   AND a.peril_cd = c.peril_cd
                   /*end mod VJ*/
                   AND a.par_id = p_par_id
                   AND b.item_grp = dist_grp)
                   --NVL(:c080.item_grp, p_item_grp))*/
            LOOP
               UPDATE giuw_pol_dist
                  SET tsi_amt = xyz.tsi_amt,
                      --NVL(v_tsi_amt,0)     / dist_cnt,
                      prem_amt = xyz.prem_amt,
                      --NVL(v_prem_amt,0)    / dist_cnt,
                      ann_tsi_amt = xyz.ann_tsi_amt,
                      --NVL(v_ann_tsi_amt,0) / dist_cnt,
                      last_upd_date = SYSDATE,
                      user_id = USER
                WHERE par_id = p_par_id AND dist_no = p_dist_no;
            END LOOP;
         END IF;
      END IF;
      -- end of integrated codes from CS - jhing 11.07.2014               
           
      END;
  -- Derive the values for the distribution tables
    PROCEDURE DISTRIBUTE(p_par_id NUMBER,p_dist_no NUMBER) IS
      BEGIN
        Cr_Bill_Dist.GET_TSI(p_par_id);
        Cr_Bill_Dist.DELETE_DIST(p_dist_no,p_par_id);
      END;
END;
/


