DROP PROCEDURE CPI.CREATE_ORIG_INVOICE;

CREATE OR REPLACE PROCEDURE CPI.create_orig_invoice (p_par_id IN NUMBER, p_line_cd IN VARCHAR2, p_iss_cd IN VARCHAR2) IS
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
              SUM(NVL(A.ri_comm_amt,0)) ri_comm_amt,
              DECODE(SUM(NVL(A.prem_amt,0)), 0, AVG(A.ri_comm_rate),
                    (SUM(NVL(A.prem_amt,0) * NVL(A.ri_comm_rate,0) / 100)/SUM(NVL(A.prem_amt,0))* 100)) ri_comm_rt
       FROM   gipi_orig_itmperil A, gipi_witem B
      WHERE   A.par_id  = p_par_id
        AND   A.par_id  = B.par_id
        AND   A.item_no = B.item_no
   GROUP BY B.par_id, B.item_grp, A.peril_cd,
            B.currency_cd, B.currency_rt;
CURSOR Z1 IS
     SELECT   B.item_grp,
              A.peril_cd,
              B.currency_cd,
              B.currency_rt,
              SUM(NVL(A.prem_amt,0)) prem_amt,
              SUM(NVL(A.tsi_amt,0)) tsi_amt,
              SUM(NVL(A.ri_comm_amt,0)) ri_comm_amt
       FROM   gipi_orig_itmperil A, gipi_witem B
      WHERE   A.par_id  = p_par_id
        AND   A.par_id  = B.par_id
        AND   A.item_no = B.item_no
   GROUP BY B.par_id, B.item_grp, A.peril_cd,
            B.currency_cd, B.currency_rt,B.pack_line_cd,B.pack_subline_cd;
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
     p_pack              gipi_wpolbas.pack_pol_flag%TYPE;
     v_exist             varchar2(1) := 'N';
     v_peril_sw          giis_tax_charges.peril_sw%TYPE;
     v_tax_amt           gipi_orig_inv_tax.tax_amt%TYPE;
     v_sum_tax           gipi_orig_inv_tax.tax_amt%TYPE;
     v_prem_amt          gipi_orig_invoice.prem_amt%TYPE;
     v_other_amt         gipi_orig_invoice.other_charges%TYPE;
     v_rate              gipi_co_insurer.co_ri_shr_pct%TYPE;--added by cherrie 07092012
BEGIN
  OPEN a1;
  FETCH a1
   INTO p_incept_date;
  CLOSE a1;
  DELETE FROM gipi_orig_comm_inv_peril
    WHERE par_id = p_par_id;
  DELETE FROM gipi_orig_comm_invoice
    WHERE par_id = p_par_id;
  DELETE FROM gipi_orig_invperl
    WHERE par_id = p_par_id;
  IF v_exist = 'N' THEN
    DELETE FROM gipi_orig_inv_tax
     WHERE par_id = p_par_id;
  END IF;
  DELETE FROM gipi_orig_invoice
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
  FOR A IN (SELECT pack_pol_flag
              FROM gipi_wpolbas
              WHERE par_id  =  p_par_id) LOOP
    p_pack  :=  A.pack_pol_flag;
    EXIT;
  END LOOP;
  
  --added by cherrie 07092012
  FOR co_ri IN (
        SELECT param_value_n co_ri_cd
          FROM giis_parameters
         WHERE param_name = 'CO_INSURER_DEFAULT')
  LOOP
      FOR rate IN (
          SELECT co_ri_shr_pct
            FROM gipi_co_insurer
           WHERE par_id   = p_par_id
             AND co_ri_cd = co_ri.co_ri_cd)
      LOOP
           v_rate := rate.co_ri_shr_pct;
      END LOOP;
  END LOOP;
  --end cherrie
    
  FOR c1_rec in c1 LOOP
    BEGIN
      IF NVL(prev_item_grp,c1_rec.item_grp) != c1_rec.item_grp THEN
        BEGIN
          DECLARE
            CURSOR c2 IS SELECT DISTINCT B.tax_cd, B.rate, B.tax_id
                           FROM giis_tax_peril A, giis_tax_charges B
                          WHERE B.line_cd    = p_line_cd
                            AND B.iss_cd  (+)= p_iss_cd
                            AND B.primary_sw = 'Y'
                            AND B.peril_sw   = 'N'
                                -- Peril switch equal to 'N' suggests that the
                                -- specified tax does not need any tax peril
                            AND B.eff_start_date <= p_incept_date
                            AND B.eff_end_date   >= p_incept_date;
--                            AND B.eff_start_date < p_incept_date;
                                -- The tax fetched should have been in effect before the
                                -- PAR has been created.
         BEGIN
                FOR c2_rec IN c2 LOOP
                  BEGIN
                    p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c2_rec.rate,0)/100; 
                    tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
                  END;
                END LOOP;
                
                --added tax_amt in the select statement : cherrie 07092012
                FOR oth IN (
                  SELECT NVL(other_charges,0) other, NVL(tax_amt,0) tax_amt 
                    FROM gipi_winvoice
                   WHERE par_id   = p_par_id
                     AND item_grp = prev_item_grp)
                LOOP
                    v_other_amt := oth.other;
                    v_tax_amt   := oth.tax_amt;
                END LOOP;
                    
                --added by cherrie 07092012     
                IF NVL(prem_amt_per_group,0) = 0 AND v_tax_amt != 0 THEN 
                    p_tax_amt := v_tax_amt/v_rate * 100;
                    tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
                END IF;
                --end cherrie
                
                    INSERT INTO  gipi_orig_invoice
                             (par_id,      item_grp,     prem_seq_no,    prem_amt,
                              tax_amt,     property,     insured,        ri_comm_amt,
                              currency_cd, currency_rt,  other_charges)
                     VALUES  (p_par_id,           prev_item_grp,     null,      prem_amt_per_group,
                              NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0),
                              null,               p_assd_name,       null,
                              prev_currency_cd,   prev_currency_rt,  v_other_amt);
                p_tax_amt := 0;
                prem_amt_per_group := 0;
                tax_amt_per_group1 := 0;
                tax_amt_per_group2 := 0;
              END;
        END;
      END IF;
      prev_item_grp      := c1_rec.item_grp;
      prev_currency_cd   := c1_rec.currency_cd;
      prev_currency_rt   := c1_rec.currency_rt;
      prem_amt_per_group := NVL(prem_amt_per_group,0) + c1_rec.prem_amt; 
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
                                            FROM gipi_orig_itmperil
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
    
    --added tax_amt in the select statement : cherrie 07092012
    FOR oth IN (
      SELECT NVL(other_charges,0) other, NVL(tax_amt, 0) tax_amt
        FROM gipi_winvoice
       WHERE par_id   = p_par_id
         AND item_grp = prev_item_grp)
    LOOP
       v_other_amt := oth.other;
       v_tax_amt := oth.tax_amt;
    END LOOP;
    
    --added by cherrie 07092012           
    IF NVL(prem_amt_per_group,0) = 0 AND v_tax_amt != 0 THEN 
        p_tax_amt := v_tax_amt/v_rate * 100;
        tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
    END IF;
    --end cherrie
    
    INSERT INTO  gipi_orig_invoice
                (par_id,     item_grp,      prem_seq_no,
                 prem_amt,   tax_amt,       property,        insured,
                 currency_cd,currency_rt,   other_charges)
         VALUES (p_par_id,   NVL(prev_item_grp, 1), null,
                 prem_amt_per_group,        NVL(tax_amt_per_group1,0)+
                 NVL(tax_amt_per_group2,0), null,            p_assd_name,
                 prev_currency_cd,          prev_currency_rt, v_other_amt);
  END;
  tax_amt_per_group1 := 0;
  BEGIN
    FOR amt IN (
      SELECT prem_amt, item_grp, tax_amt 
        FROM gipi_orig_invoice
       WHERE par_id = p_par_id )
    LOOP
      FOR tax IN (
        SELECT item_grp, tax_cd,  line_cd, tax_allocation, fixed_tax_allocation,
               iss_cd,   tax_id,  rate, tax_amt
          FROM gipi_winv_tax
         WHERE par_id   = p_par_id
           AND item_grp = amt.item_grp)
      LOOP
        FOR C IN (
          SELECT peril_sw
            FROM giis_tax_charges
           WHERE iss_cd  = tax.iss_cd
             AND line_cd = tax.line_cd
             AND tax_cd  = tax.tax_cd)
        LOOP
          v_peril_sw := c.peril_sw;
        END LOOP;
        
        IF v_peril_sw = 'N' THEN
           v_tax_amt       := ROUND(tax.rate * amt.prem_amt / 100,2); 
        ELSE
          FOR D IN (
            SELECT SUM(NVL(A.prem_amt,0)) prem_amt
              FROM gipi_orig_itmperil A, gipi_witem B
             WHERE A.par_id   = p_par_id
               AND A.par_id   = B.par_id
               AND A.item_no  = B.item_no
               AND B.item_grp = amt.item_grp
               AND A.peril_cd IN (SELECT peril_cd
                                    FROM giis_tax_peril
                                   WHERE line_cd = tax.line_cd
                                     AND iss_cd  = tax.iss_cd
                                     AND tax_cd  = tax.tax_cd)
            GROUP BY B.item_grp, A.peril_cd)
          LOOP
            v_prem_amt  := NVL(v_prem_amt,0) + d.prem_amt;
          END LOOP;
            v_tax_amt   := ROUND(tax.rate * v_prem_amt / 100,2);
        END IF;
        --added by cherrie 07092012   
        IF amt.prem_amt = 0 AND amt.tax_amt != 0 THEN
            v_tax_amt   := tax.tax_amt/v_rate * 100; 
        END IF;
        --end cherrie
        
           INSERT INTO gipi_orig_inv_tax (
              par_id,         item_grp,     tax_cd,    line_cd,
              tax_allocation, fixed_tax_allocation,
              iss_cd,  tax_amt,  tax_id,  rate)
            VALUES (
              p_par_id,   tax.item_grp, tax.tax_cd, tax.line_cd,
              tax.tax_allocation, tax.fixed_tax_allocation,
              tax.iss_cd,     nvl(v_tax_amt,0), tax.tax_id, tax.rate);
            v_prem_amt := 0;
            v_tax_amt  := 0;
      END LOOP;
      FOR sum_tax IN (
        SELECT SUM(tax_amt) amt
          FROM gipi_orig_inv_tax
         WHERE par_id   = p_par_id
           AND item_grp = amt.item_grp)
      LOOP
         v_sum_tax := sum_tax.amt;
      END LOOP;
      UPDATE gipi_orig_invoice
         SET tax_amt = v_sum_tax
       WHERE par_id   = p_par_id
         AND item_grp = amt.item_grp;
    END LOOP;
  END;
  FOR c1_rec IN c1 LOOP
    BEGIN
      INSERT INTO gipi_orig_invperl
                  (par_id,peril_cd,item_grp,tsi_amt,prem_amt,ri_comm_amt,ri_comm_rt)
           VALUES (p_par_id,c1_rec.peril_cd,c1_rec.item_grp,
                   c1_rec.tsi_amt,c1_rec.prem_amt,c1_rec.ri_comm_amt,c1_rec.ri_comm_rt);
    END;
  END LOOP;
END;
/


