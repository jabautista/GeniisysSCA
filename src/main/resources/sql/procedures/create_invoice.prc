DROP PROCEDURE CPI.CREATE_INVOICE;

CREATE OR REPLACE PROCEDURE CPI.CREATE_INVOICE (p_par_id IN NUMBER, p_line_cd IN VARCHAR2, p_iss_cd IN VARCHAR2) IS
CURSOR a1 IS
     SELECT   nvl(eff_date,incept_date)
       FROM   gipi_wpolbas
      WHERE   par_id  =  p_par_id;
CURSOR c1 IS
     SELECT   B.item_grp,
              A.peril_cd,
              B.currency_cd,
              B.currency_rt,
              SUM(NVL(A.prem_amt,0)) prem_amt,
              SUM(NVL(A.tsi_amt,0)) tsi_amt,
              SUM(NVL(A.ri_comm_amt,0)) ri_comm_amt
       FROM   gipi_witmperl A, gipi_witem B
      WHERE   A.par_id  = p_par_id
        AND   A.par_id  = B.par_id
        AND   A.item_no = B.item_no
   GROUP BY B.par_id, B.item_grp, A.peril_cd;
     comm_amt_per_group  gipi_winvoice.ri_comm_amt%TYPE;
     prem_amt_per_peril  gipi_winvoice.prem_amt%TYPE;
     prem_amt_per_group  gipi_winvoice.prem_amt%TYPE;
     tax_amt_per_peril   gipi_winvoice.tax_amt%TYPE;
     tax_amt_per_group1  gipi_winvoice.tax_amt%TYPE;
     tax_amt_per_group2  gipi_winvoice.tax_amt%TYPE;
     p_tax_amt           gipi_winvoice.tax_amt%TYPE;
     prev_item_grp       gipi_winvoice.item_grp%TYPE;
     prev_currency_cd    gipi_winvoice.currency_cd%TYPE;
     prev_currency_rt    gipi_winvoice.currency_rt%TYPE;
     p_assd_name         giis_assured.assd_name%TYPE;
     dummy               varchar2(1);
     p_incept_date       gipi_wpolbas.incept_date%TYPE;
BEGIN
   OPEN a1;
  FETCH a1
   INTO p_incept_date;
  CLOSE a1;
  DELETE FROM gipi_winstallment
    WHERE par_id = p_par_id;
  DELETE FROM gipi_wcomm_invoices
    WHERE par_id = p_par_id;
  DELETE FROM gipi_winvperl
    WHERE par_id = p_par_id;
  DELETE FROM gipi_winv_tax
    WHERE par_id = p_par_id;
  DELETE FROM gipi_winvoice
    WHERE par_id = p_par_id;
  BEGIN
    FOR A1 IN (
       SELECT   substr(b.assd_name,1,30)    ASSD_NAME
         FROM   gipi_parlist a, giis_assured b
        WHERE   a.assd_no    =  b.assd_no
          AND   a.par_id     =  p_par_id
          AND   a.line_cd    =  p_line_cd) LOOP
         p_assd_name  := A1.assd_name;
    END LOOP;
    IF p_assd_name IS NULL THEN
          p_assd_name:='Null';
    END IF;
  END;
  FOR c1_rec in c1 LOOP
    BEGIN
      IF NVL(prev_item_grp,c1_rec.item_grp) != c1_rec.item_grp THEN
        BEGIN
          DECLARE
            CURSOR c2 IS SELECT DISTINCT B.tax_cd, B.rate
                           FROM giis_tax_peril A, giis_tax_charges B
                          WHERE B.line_cd    = p_line_cd
                            AND B.iss_cd  (+)= p_iss_cd
                            AND B.primary_sw = 'Y'
                            AND B.peril_sw   = 'N'
                            AND B.eff_start_date < p_incept_date;
          BEGIN
            FOR c2_rec IN c2 LOOP
              BEGIN
                p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c2_rec.rate,0)/100;
                tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
              END;
            END LOOP;
            INSERT INTO  gipi_winvoice
                         (par_id,     item_grp,     payt_terms,     prem_seq_no,
                          prem_amt,   tax_amt,      property,       insured,
                          due_date,   notarial_fee, ri_comm_amt,    currency_cd,
                          currency_rt)
                 VALUES  (p_par_id,           prev_item_grp,     null,      null,
                          prem_amt_per_group, NVL(tax_amt_per_group1,0) +                           NVL(tax_amt_per_group2,0),
                          null,               p_assd_name,       null,
                          0,                  comm_amt_per_group,prev_currency_cd,
                          prev_currency_rt);
            p_tax_amt := 0;
            prem_amt_per_group := 0;
            tax_amt_per_group1 := 0;
            tax_amt_per_group2 := 0;
            comm_amt_per_group := 0;
          END;
        END;
      END IF;
      prev_item_grp      := c1_rec.item_grp;
      prev_currency_cd   := c1_rec.currency_cd;
      prev_currency_rt   := c1_rec.currency_rt;
      prem_amt_per_group := NVL(prem_amt_per_group,0) + c1_rec.prem_amt;
      comm_amt_per_group := NVL(comm_amt_per_group,0) + c1_rec.ri_comm_amt;
      DECLARE
      CURSOR c2 IS SELECT DISTINCT B.tax_cd, B.rate
                     FROM giis_tax_peril A, giis_tax_charges B
                    WHERE A.line_cd    = p_line_cd
                      AND A.iss_cd  (+)= p_iss_cd
                      AND A.line_cd    = B.line_cd
                      AND A.iss_cd  (+)= B.iss_cd
                      AND A.tax_cd     = B.tax_cd
                      AND B.eff_start_date < p_incept_date
                      AND B.primary_sw = 'Y'
                      AND B.peril_sw   = 'Y'
                      AND A.peril_cd IN ( SELECT peril_cd
                                            FROM gipi_witmperl
                                           WHERE par_id = p_par_id)
                      AND A.peril_cd   = c1_rec.peril_cd;
      BEGIN
        FOR c2_rec IN c2 LOOP
          BEGIN
            p_tax_amt := NVL(c1_rec.prem_amt,0) * NVL(c2_rec.rate,0)/ 100;
            tax_amt_per_peril  := NVL(tax_amt_per_peril,0) + NVL(p_tax_amt,0);
            tax_amt_per_group2 := TAX_AMT_PER_PERIL; --NVL(tax_amt_per_group2,0) +                                   tax_amt_per_peril;
          END;
        END LOOP;
      END;
    END;
  END LOOP;
  DECLARE
  CURSOR c2 IS SELECT DISTINCT B.tax_cd, B.rate
                 FROM giis_tax_peril A, giis_tax_charges B
                WHERE B.line_cd = p_line_cd
                  AND B.iss_cd  (+)= p_iss_cd
                  AND B.primary_sw = 'Y'
                  AND B.peril_sw   = 'N'
                  AND B.eff_start_date < p_incept_date;
  BEGIN
    FOR c2_rec IN c2 LOOP
      BEGIN
        p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c2_rec.rate,0)/100;
        tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
      END;
    END LOOP;
    INSERT INTO  gipi_winvoice
                (par_id,     item_grp,      payt_terms,      prem_seq_no,
                 prem_amt,   tax_amt,       property,        insured,
                 due_date,   notarial_fee,  ri_comm_amt,     currency_cd,
                 currency_rt)
         VALUES (p_par_id,   prev_item_grp, null,            null,
                 prem_amt_per_group,        NVL(tax_amt_per_group1,0)+
                 NVL(tax_amt_per_group2,0), null,            p_assd_name,
                 null,       0,             comm_amt_per_group,
                 prev_currency_cd,          prev_currency_rt);
  END;
  tax_amt_per_group1 := 0;
  DECLARE
    CURSOR c4 IS SELECT DISTINCT item_grp
                   FROM gipi_witem
                  WHERE par_id = p_par_id;
  BEGIN
    FOR c4_rec IN c4 LOOP
      BEGIN
        DECLARE
          CURSOR c1 IS SELECT DISTINCT B.tax_cd, B.rate, B.peril_sw
                         FROM giis_tax_peril A, giis_tax_charges B
                        WHERE B.line_cd = p_line_cd
                          AND B.iss_cd  (+)= p_iss_cd
                          AND B.primary_sw = 'Y'
                          AND B.eff_start_date < p_incept_date;
        BEGIN
          FOR c1_rec IN c1 LOOP
            BEGIN
              DECLARE
                CURSOR c3 IS SELECT B.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                                    SUM(NVL(A.tsi_amt,0)) tsi_amt
                               FROM gipi_witmperl A, gipi_witem B
                              WHERE A.par_id   = p_par_id
                                AND A.par_id   = B.par_id
                                AND A.item_no  = B.item_no
                                AND B.item_grp = c4_rec.item_grp
                           GROUP BY B.item_grp, A.peril_cd;
                CURSOR c5 IS SELECT B.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                                    SUM(NVL(A.tsi_amt,0)) tsi_amt
                               FROM gipi_witmperl A, gipi_witem B
                              WHERE A.par_id   = p_par_id
                                AND A.par_id   = B.par_id
                                AND A.item_no  = B.item_no
                                AND B.item_grp = c4_rec.item_grp
                                AND A.peril_cd IN (SELECT peril_cd
                                                     FROM giis_tax_peril
                                                    WHERE line_cd = p_line_cd
                                                      AND iss_cd  = p_iss_cd
                                                      AND tax_cd  = c1_rec.tax_cd)
                           GROUP BY B.item_grp, A.peril_cd;
              BEGIN
                IF c1_rec.peril_sw = 'N' THEN
                  BEGIN
                    FOR c3_rec IN c3 LOOP
                      BEGIN
                        p_tax_amt := c3_rec.prem_amt * c1_rec.rate / 100;
                        tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                      END;
                    END LOOP;
                  END;
                ELSE
                  BEGIN
                    FOR c5_rec IN c5 LOOP
                      BEGIN
                        p_tax_amt := c5_rec.prem_amt * c1_rec.rate / 100;
                        tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                      END;
                    END LOOP;
                  END;
                END IF;
                IF tax_amt_per_group1 != 0 THEN
         INSERT INTO gipi_winv_tax
                     (par_id,item_grp,tax_cd,line_cd,iss_cd,rate,
                      tax_amt)
              VALUES (p_par_id,c4_rec.item_grp,c1_rec.tax_cd,c1_rec.rate,
                      p_line_cd,p_iss_cd,tax_amt_per_group1);
                END IF;
              END;
              p_tax_amt := 0;
              tax_amt_per_group1 := 0;
            END;
          END LOOP;
        END;
      END;
    END LOOP;
  END;
  FOR c1_rec IN c1 LOOP
    BEGIN
      INSERT INTO gipi_winvperl
                  (par_id,peril_cd,item_grp,tsi_amt,prem_amt,ri_comm_amt)
           VALUES (p_par_id,c1_rec.peril_cd,c1_rec.item_grp,
                   c1_rec.tsi_amt,c1_rec.prem_amt,c1_rec.ri_comm_amt);
    END;
  END LOOP;
  COMMIT;
END;
/


