DROP PROCEDURE CPI.CREATE_WINVOICE_PACK;

CREATE OR REPLACE PROCEDURE CPI.Create_Winvoice_Pack(p_policy_id  IN NUMBER,
                                            p_pol_id_n   IN NUMBER,
                                            p_old_par_id IN NUMBER,
											p_par_id     IN NUMBER,
                                            p_line_cd    IN VARCHAR2,
                                            p_iss_cd     IN VARCHAR2) IS
/*
** parameter p_policy_id, p_pol_id_n and p_old_par_id added so as to handle fetching of the proper tax_cd
** of the old policy or old par per item grouping(s)
** added by : aivhie
** date     : 112301
*/
/* last modified by bdarusin, 12022002
** all codes re validation of doc stamps parameter were added,
** as compared with old create winvoice
*/

--
-- used by item-peril module to create an initial value for invoice module.
-- taxes selection from maintenace tables are also performed.
--
  CURSOR a1 IS
    SELECT nvl(eff_date,incept_date), issue_date, place_cd
      FROM gipi_wpolbas
     WHERE par_id  =  p_par_id;
  CURSOR c1 IS
    SELECT b.item_grp,     A.peril_cd,
           b.currency_cd,  b.currency_rt,
           sum(nvl(A.prem_amt,0)) prem_amt,
           sum(nvl(A.tsi_amt,0)) tsi_amt,
           sum(nvl(A.ri_comm_amt,0)) ri_comm_amt,
           decode(sum(nvl(A.prem_amt,0)), 0,
           avg(A.ri_comm_rate),
           (sum(nvl(A.prem_amt,0) * nvl(A.ri_comm_rate,0) / 100)/sum(nvl(A.prem_amt,0)) * 100)) ri_comm_rt
      FROM gipi_witmperl A, gipi_witem b
     WHERE A.par_id  = p_par_id
       AND A.par_id  = b.par_id
       AND A.item_no = b.item_no
     GROUP BY b.par_id,      b.item_grp,   A.peril_cd,
              b.currency_cd, b.currency_rt;
  CURSOR d1 IS --added by bdarusin, copied from old create_winvoice
    SELECT param_value_n
      FROM giac_parameters
     WHERE param_name = 'DOC_STAMPS';

  CURSOR e1 IS
    SELECT param_value_v
      FROM giis_parameters
     WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS';

  p_doc_stamps        giis_tax_charges.tax_cd%TYPE;
  v_param_old_doc     giis_parameters.param_value_v%TYPE; --end of added codes, bdarusin, 12022002
  comm_amt_per_group  gipi_winvoice.ri_comm_amt%TYPE;
  prem_amt_per_peril  gipi_winvoice.prem_amt%TYPE;
  prem_amt_per_group  gipi_winvoice.prem_amt%TYPE;
  tax_amt_per_peril   gipi_winvoice.tax_amt%TYPE;
  tax_amt_per_group1  REAL;
  tax_amt_per_group2  REAL;
  p_tax_amt           REAL;
  v_prem_amt          REAL; --added by bdarusin, copied from old create_winvoice
  prev_item_grp       gipi_winvoice.item_grp%TYPE;
  prev_currency_cd    gipi_winvoice.currency_cd%TYPE;
  prev_currency_rt    gipi_winvoice.currency_rt%TYPE;
  p_assd_name         giis_assured.assd_name%TYPE;
  dummy               VARCHAR2(1);
  p_issue_date        gipi_wpolbas.issue_date%TYPE;
  p_eff_date          gipi_wpolbas.eff_date%TYPE;
  p_place_cd          gipi_wpolbas.place_cd%TYPE;
  p_pack              gipi_wpolbas.pack_pol_flag%TYPE;
BEGIN
  OPEN a1;
  FETCH a1
   INTO p_eff_date,
        p_issue_date,
        p_place_cd;
  CLOSE a1;
  OPEN d1; --added by bdarusin, copied from old create_winvoice
  FETCH d1
   INTO p_doc_stamps;
  CLOSE d1;
  OPEN e1;
  FETCH e1
   INTO v_param_old_doc;
  CLOSE e1; --end of added codes, bdarusin, 12022002
  DELETE FROM gipi_winstallment
   WHERE par_id = p_par_id;
  DELETE FROM gipi_wcomm_inv_perils
   WHERE par_id = p_par_id;
  DELETE FROM gipi_wcomm_invoices
   WHERE par_id = p_par_id;
  DELETE FROM gipi_winvperl
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WPACKAGE_INV_TAX
   WHERE par_id = p_par_id;
  DELETE FROM gipi_winv_tax
   WHERE par_id = p_par_id;
  DELETE FROM gipi_winvoice
   WHERE par_id = p_par_id;
  BEGIN
    FOR a1 IN (
      SELECT substr(b.assd_name,1,30) assd_name
        FROM gipi_parlist A, giis_assured b
       WHERE A.assd_no    =  b.assd_no
         AND A.par_id     =  p_par_id
         AND A.line_cd    =  p_line_cd)
    LOOP
      p_assd_name  := a1.assd_name;
    END LOOP;
    IF p_assd_name IS NULL THEN
       p_assd_name:='NULL';
    END IF;
  END;
  FOR A IN (
    SELECT pack_pol_flag
      FROM gipi_wpolbas
     WHERE par_id  =  p_par_id)
  LOOP
    p_pack  :=  A.pack_pol_flag;
    EXIT;
  END LOOP;
  FOR c1_rec IN c1
  LOOP
  DBMS_OUTPUT.PUT_LINE('C1_REC');
    BEGIN
  	  IF nvl(prev_item_grp,c1_rec.item_grp) != c1_rec.item_grp THEN
        BEGIN
          DECLARE
            CURSOR c2 IS
               SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate, b.tax_id
                 FROM giis_tax_peril A, giis_tax_charges b
                WHERE b.line_cd    = p_line_cd
                  AND b.iss_cd  (+)= p_iss_cd
                  AND b.primary_sw = 'Y'
                  AND b.peril_sw   = 'N'
                  -- peril switch equal to 'n' suggests that the
                  -- specified tax does not need any tax peril
                  AND b.eff_start_date < p_issue_date
                  AND b.eff_end_date > p_issue_date
                  -- the tax fetched should have been in effect before the
                  -- par has been created. (loth 032200)
 		              AND nvl(b.issue_date_tag,'N') = 'Y';
 		        CURSOR d1 IS
 		           SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate,b.tax_id
                 FROM giis_tax_peril A, giis_tax_charges b, giis_tax_issue_place c
                WHERE b.line_cd    = p_line_cd
                  AND b.iss_cd  (+)= p_iss_cd
                  AND b.iss_cd = c.iss_cd(+)
                  AND b.line_cd = c.line_cd(+)
                  AND b.tax_cd = c.tax_cd(+)
                  AND c.place_cd(+) = p_place_cd
                  AND b.primary_sw = 'Y'
                  AND b.peril_sw   = 'N'
                  AND b.eff_start_date < p_issue_date
                  AND b.eff_end_date > p_issue_date
                  AND nvl(b.issue_date_tag,'N') = 'Y';
		  -- if issue_date_tag = 'y', tax will be considered based
		  -- on issue_date else on eff_date (loth 032200)
            CURSOR c2a IS
               SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate, b.tax_id
                 FROM giis_tax_peril A, giis_tax_charges b
                WHERE b.line_cd    = p_line_cd
                  AND b.iss_cd  (+)= p_iss_cd
                  AND b.primary_sw = 'Y'
                  AND b.peril_sw   = 'N'
                  -- peril switch equal to 'n' suggests that the
                  -- specified tax does not need any tax peril
                  AND b.eff_start_date < p_eff_date
                  AND b.eff_end_date > p_eff_date
                  -- the tax fetched should have been in effect before the
                  -- par has been created. (loth 032200)
 		              AND nvl(b.issue_date_tag,'N') = 'N';
 		        CURSOR d2 IS
 		           SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate, b.tax_id
                 FROM giis_tax_peril A, giis_tax_charges b, giis_tax_issue_place c
                WHERE b.line_cd     = p_line_cd
                  AND b.iss_cd   (+)= p_iss_cd
                  AND b.iss_cd      = c.iss_cd(+)
                  AND b.line_cd     = c.line_cd(+)
                  AND b.tax_cd      = c.tax_cd(+)
                  AND c.place_cd (+)= p_place_cd
                  AND b.primary_sw  = 'Y'
                  AND b.peril_sw    = 'N'
                  AND b.eff_start_date < p_eff_date
                  AND b.eff_end_date > p_eff_date
                  AND nvl(b.issue_date_tag,'N') = 'N';
		  -- if issue_date_tag = 'y', tax will be considered based
		  -- on issue_date else on eff_date (loth 032200)
		     BEGIN
		  	   IF p_place_cd IS NOT NULL THEN
	  	        FOR d1_rec IN d1
                LOOP
                  BEGIN
                    p_tax_amt          := nvl(prem_amt_per_group,0) * nvl(d1_rec.rate,0)/100;
					IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from old create_winvoice
	                   IF prem_amt_per_group > 0 THEN
  					      p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
					   ELSE
					      p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
					   END IF;
	                END IF;		 							  	   														   --end of added codes, bdarusin, 12022002
                    tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
                  END;
                END LOOP;
                FOR d2_rec IN d2
                LOOP
                  BEGIN
                    p_tax_amt          := nvl(prem_amt_per_group,0) * nvl(d2_rec.rate,0)/100;
                    IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                       IF prem_amt_per_group > 0 THEN
    					  p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
					   ELSE
					      p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
					   END IF;
                    END IF;
                    tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
                  END;
                END LOOP;
            ELSE
              FOR c2_rec IN c2
              LOOP
                BEGIN
                  p_tax_amt          := nvl(prem_amt_per_group,0) * nvl(c2_rec.rate,0)/100;
                  IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                     IF prem_amt_per_group > 0 THEN
   					    p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
					 ELSE
					    p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
				     END IF;
                  END IF;
                  tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
                END;
              END LOOP;
              FOR c2a_rec IN c2a
              LOOP
                BEGIN
                  p_tax_amt          := nvl(prem_amt_per_group,0) * nvl(c2a_rec.rate,0)/100;
                  IF c2a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                     IF prem_amt_per_group > 0 THEN
                        p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
				 	 ELSE
					    p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
					 END IF;
                  END IF;
                  tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
                END;
              END LOOP;
           END IF;
		   DBMS_OUTPUT.PUT_LINE(1);
           INSERT INTO  gipi_winvoice
                 (par_id,              item_grp,
                  payt_terms,          prem_seq_no,
                  prem_amt,            tax_amt,
                  property,            insured,
                  due_date,            notarial_fee,
                  ri_comm_amt,         currency_cd,
                  currency_rt)
            VALUES
                 (p_par_id,            prev_item_grp,
                  NULL,                NULL,
                  prem_amt_per_group,  nvl(tax_amt_per_group1,0) + nvl(tax_amt_per_group2,0),
                  NULL,                p_assd_name,
                  NULL,                0,
                  comm_amt_per_group,  prev_currency_cd,
                  prev_currency_rt);
            p_tax_amt          := 0;
            prem_amt_per_group := 0;
            tax_amt_per_group1 := 0;
            tax_amt_per_group2 := 0;
            comm_amt_per_group := 0;
          END;
        END;
      END IF;
	  DBMS_OUTPUT.PUT_LINE('item group'||c1_rec.item_grp);
      prev_item_grp      := c1_rec.item_grp;
      prev_currency_cd   := c1_rec.currency_cd;
      prev_currency_rt   := c1_rec.currency_rt;
      prem_amt_per_group := nvl(prem_amt_per_group,0) + c1_rec.prem_amt;
      comm_amt_per_group := nvl(comm_amt_per_group,0) + c1_rec.ri_comm_amt;
      DECLARE
      CURSOR c2 IS
         SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate
           FROM giis_tax_peril A, giis_tax_charges b
          WHERE A.line_cd    = p_line_cd
            AND A.iss_cd  (+)= p_iss_cd
            AND A.line_cd    = b.line_cd
            AND A.iss_cd  (+)= b.iss_cd
            AND A.tax_cd     = b.tax_cd
            -- the tax fetched should have been in effect before the
            -- par has been created. (loth 032200)
            AND b.eff_start_date < p_issue_date
            AND b.eff_end_date > p_issue_date
            -- if issue_date_tag = 'y', TAX WILL BE CONSIDERED BASED
	          -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
	          AND nvl(b.issue_date_tag,'N') = 'Y'
            AND b.primary_sw = 'Y'
            AND b.peril_sw   = 'Y'
            AND A.peril_cd IN ( SELECT peril_cd
                                  FROM gipi_witmperl
                                 WHERE par_id = p_par_id)
            AND A.peril_cd   = c1_rec.peril_cd;
      CURSOR d1 IS
         SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate
           FROM giis_tax_peril A, giis_tax_charges b, giis_tax_issue_place c
          WHERE A.line_cd    = p_line_cd
            AND A.iss_cd  (+)= p_iss_cd
            AND A.line_cd    = b.line_cd
            AND A.iss_cd  (+)= b.iss_cd
            AND A.tax_cd     = b.tax_cd
            AND A.iss_cd     = c.iss_cd(+)
            AND A.line_cd    = c.line_cd(+)
            AND A.tax_cd     = c.tax_cd(+)
            AND c.place_cd  (+)= p_place_cd
            AND b.eff_start_date < p_issue_date
            AND b.eff_end_date > p_issue_date
            AND nvl(b.issue_date_tag,'N') = 'Y'
            AND b.primary_sw = 'Y'
            AND b.peril_sw   = 'Y'
            AND A.peril_cd IN ( SELECT peril_cd
                                  FROM gipi_witmperl
                                 WHERE par_id = p_par_id)
            AND A.peril_cd   = c1_rec.peril_cd;
      CURSOR c2a IS
         SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate
           FROM giis_tax_peril A, giis_tax_charges b
          WHERE A.line_cd    = p_line_cd
            AND A.iss_cd  (+)= p_iss_cd
            AND A.line_cd    = b.line_cd
            AND A.iss_cd  (+)= b.iss_cd
            AND A.tax_cd     = b.tax_cd
            -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
            -- PAR HAS BEEN CREATED. (LOTH 032200)
            AND b.eff_start_date < p_eff_date
            AND b.eff_end_date > p_eff_date
	          -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
            -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
	          AND nvl(b.issue_date_tag,'N') = 'N'
            AND b.primary_sw = 'Y'
            AND b.peril_sw   = 'Y'
            AND A.peril_cd IN ( SELECT peril_cd
                                  FROM gipi_witmperl
                                 WHERE par_id = p_par_id)
            AND A.peril_cd   = c1_rec.peril_cd;
      CURSOR d2 IS
         SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate
           FROM giis_tax_peril A, giis_tax_charges b, giis_tax_issue_place c
          WHERE A.line_cd    = p_line_cd
            AND A.iss_cd  (+)= p_iss_cd
            AND A.line_cd    = b.line_cd
            AND A.iss_cd  (+)= b.iss_cd
            AND A.tax_cd     = b.tax_cd
            AND A.iss_cd     = c.iss_cd(+)
            AND A.line_cd    = c.line_cd(+)
            AND A.tax_cd     = c.tax_cd(+)
            AND c.place_cd(+)= p_place_cd
            AND b.eff_start_date < p_eff_date
            AND b.eff_end_date > p_eff_date
	          AND nvl(b.issue_date_tag,'N') = 'N'
            AND b.primary_sw = 'Y'
            AND b.peril_sw   = 'Y'
            AND A.peril_cd IN ( SELECT peril_cd
                                  FROM gipi_witmperl
                                 WHERE par_id = p_par_id)
            AND A.peril_cd   = c1_rec.peril_cd;
      BEGIN
        IF p_place_cd IS NOT NULL THEN
           FOR d1_rec IN d1
           LOOP
             BEGIN
               p_tax_amt          := nvl(c1_rec.prem_amt,0) * nvl(d1_rec.rate,0)/ 100;
               IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                  IF c1_rec.prem_amt > 0 THEN
				     p_tax_amt := ceil(c1_rec.prem_amt / 4) * (0.5);
				  ELSE
				     p_tax_amt := floor(c1_rec.prem_amt / 4) * (0.5);
				  END IF;
               END IF;
               tax_amt_per_peril  := nvl(tax_amt_per_peril,0) + nvl(p_tax_amt,0);
               tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
             END;
           END LOOP;
           FOR d2_rec IN d2
           LOOP
             BEGIN
               p_tax_amt          := nvl(c1_rec.prem_amt,0) * nvl(d2_rec.rate,0)/ 100;
               IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                  IF c1_rec.prem_amt > 0 THEN
    	    		 p_tax_amt := ceil(c1_rec.prem_amt / 4) * (0.5);
				  ELSE
				  	  p_tax_amt := floor(c1_rec.prem_amt / 4) * (0.5);
				  END IF;
               END IF;
               tax_amt_per_peril  := nvl(tax_amt_per_peril,0) + nvl(p_tax_amt,0);
               tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
             END;
           END LOOP;
       ELSE
           FOR c2_rec IN c2
           LOOP
             BEGIN
               p_tax_amt          := nvl(c1_rec.prem_amt,0) * nvl(c2_rec.rate,0)/ 100;
               IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                  IF c1_rec.prem_amt > 0 THEN
   				     p_tax_amt := ceil(c1_rec.prem_amt / 4) * (0.5);
				  ELSE
				     p_tax_amt := floor(c1_rec.prem_amt / 4) * (0.5);
				  END IF;
               END IF;
               tax_amt_per_peril  := nvl(tax_amt_per_peril,0) + nvl(p_tax_amt,0);
               tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
             END;
           END LOOP;
           FOR c2a_rec IN c2a
           LOOP
             BEGIN
               p_tax_amt          := nvl(c1_rec.prem_amt,0) * nvl(c2a_rec.rate,0)/ 100;
         	   IF c2a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                  IF c1_rec.prem_amt > 0 THEN
   				     p_tax_amt := ceil(c1_rec.prem_amt / 4) * (0.5);
				  ELSE
				     p_tax_amt := floor(c1_rec.prem_amt / 4) * (0.5);
				  END IF;
               END IF;
               tax_amt_per_peril  := nvl(tax_amt_per_peril,0) + nvl(p_tax_amt,0);
               tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
             END;
	         END LOOP;
	      END IF;
      END;
    END;
  END LOOP;
  DECLARE
  CURSOR c2 IS
     SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate
       FROM giis_tax_peril A, giis_tax_charges b
      WHERE b.line_cd = p_line_cd
        AND b.iss_cd (+)      = p_iss_cd
        AND b.primary_sw      = 'Y'
        AND b.peril_sw        = 'N'
        -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
        -- PAR HAS BEEN CREATED. (LOTH 032200)
        AND b.eff_start_date <= p_issue_date
        AND b.eff_end_date   >= p_issue_date
        -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
        -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
        AND nvl(b.issue_date_tag, 'N') = 'Y';
  CURSOR d1 IS
     SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate
       FROM giis_tax_peril A, giis_tax_charges b, giis_tax_issue_place c
      WHERE b.line_cd         = p_line_cd
        AND b.iss_cd (+)      = p_iss_cd
        AND b.iss_cd          = c.iss_cd(+)
        AND b.line_cd         = c.line_cd(+)
        AND b.tax_cd          = c.tax_cd(+)
        AND b.primary_sw      = 'Y'
        AND b.peril_sw        = 'N'
        AND c.place_cd     (+)= p_place_cd
        AND b.eff_start_date <= p_issue_date
        AND b.eff_end_date   >= p_issue_date
        AND nvl(b.issue_date_tag, 'N') = 'Y';
  CURSOR c2a IS
     SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate
       FROM giis_tax_peril A, giis_tax_charges b
      WHERE b.line_cd = p_line_cd
        AND b.iss_cd (+)      = p_iss_cd
        AND b.primary_sw      = 'Y'
        AND b.peril_sw        = 'N'
        -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
        -- PAR HAS BEEN CREATED. (LOTH 032200)
        AND b.eff_start_date <= p_eff_date
        AND b.eff_end_date   >= p_eff_date
        -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
        -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
        AND nvl(b.issue_date_tag, 'N') = 'N';
  CURSOR d2 IS
     SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate
       FROM giis_tax_peril A, giis_tax_charges b, giis_tax_issue_place c
      WHERE b.line_cd     = p_line_cd
        AND b.iss_cd   (+)= p_iss_cd
        AND b.iss_cd      = c.iss_cd(+)
        AND b.line_cd     = c.line_cd(+)
        AND b.tax_cd      = c.tax_cd(+)
        AND c.place_cd (+)= p_place_cd
        AND b.primary_sw  = 'Y'
        AND b.peril_sw    = 'N'
        AND b.eff_start_date <= p_eff_date
        AND b.eff_end_date   >= p_eff_date
        AND nvl(b.issue_date_tag, 'N') = 'N';
  BEGIN
    IF p_place_cd IS NOT NULL THEN
       FOR d1_rec IN d1
       LOOP
         BEGIN
           p_tax_amt := nvl(prem_amt_per_group,0) * nvl(d1_rec.rate,0)/100;
           IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
              IF prem_amt_per_group > 0 THEN
			     p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
			  ELSE
			     p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
			  END IF;
           END IF;
           tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
         END;
       END LOOP;
       FOR d2_rec IN d2
       LOOP
         BEGIN
           p_tax_amt := nvl(prem_amt_per_group,0) * nvl(d2_rec.rate,0)/100;
           IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
              IF prem_amt_per_group > 0 THEN
  			     p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
			  ELSE
			     p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
			  END IF;
           END IF;
           tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
         END;
       END LOOP;
    ELSE
      FOR c2_rec IN c2
      LOOP
        BEGIN
          p_tax_amt := nvl(prem_amt_per_group,0) * nvl(c2_rec.rate,0)/100;
          IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
             IF prem_amt_per_group > 0 THEN
   			    p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
			 ELSE
     	  	    p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
			 END IF;
          END IF;
          tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
        END;
      END LOOP;
      FOR c2a_rec IN c2a
      LOOP
        BEGIN
          p_tax_amt := nvl(prem_amt_per_group,0) * nvl(c2a_rec.rate,0)/100;
          IF c2a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
             IF prem_amt_per_group > 0 THEN
    	        p_tax_amt := ceil(prem_amt_per_group / 4) * (0.5);
			 ELSE
			    p_tax_amt := floor(prem_amt_per_group / 4) * (0.5);
			 END IF;
          END IF;
          tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + nvl(p_tax_amt,0);
        END;
      END LOOP;
    END IF;
	DBMS_OUTPUT.PUT_LINE(2);
    INSERT INTO  gipi_winvoice
        (par_id,               item_grp,
         payt_terms,           prem_seq_no,
         prem_amt,             tax_amt,
         property,             insured,
         due_date,             notarial_fee,
         ri_comm_amt,          currency_cd,
         currency_rt)
    VALUES
        (p_par_id,             prev_item_grp,
         NULL,                 NULL,
         prem_amt_per_group,   nvl(tax_amt_per_group1,0)+ nvl(tax_amt_per_group2,0),
         NULL,                 p_assd_name,
         NULL,                 0,
         comm_amt_per_group,   prev_currency_cd,
         prev_currency_rt);
  END;
  tax_amt_per_group1 := 0;
---***---
    DECLARE
    p_tax_id     giis_tax_charges.tax_id%TYPE;
    v_line_cd     gipi_polbasic.line_cd%TYPE;
	v_subline_cd  gipi_polbasic.subline_cd%TYPE;
	v_iss_cd      gipi_polbasic.iss_cd%TYPE;
	v_issue_yy    gipi_polbasic.issue_yy%TYPE;
	v_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
	v_renew_no    gipi_polbasic.renew_no%TYPE;

    /*Modified by Iris Bordey 12.09.2003
	**Problem : ORA-02291 on table gipi_winv_tax (parent rec, from gipi_winvoice not found)
	**Resolution : Since at this point necessary insert/update were made already to
	**           : to gipi_winvoice and since it is "non-existing" item_grp from gipi_winvoice
    **           : that causes the ora error, query for item_grp will come from gipi_winvoice.
	**Note       : ORA-02291 error on table gipi_winvperl will be handled.
	*/
	CURSOR c4 IS
      SELECT item_grp
        FROM gipi_winvoice A
       WHERE par_id = p_par_id
         AND (
              (nvl(p_pack,'N') = 'Y'
               AND EXISTS (SELECT '1'
                             FROM gipi_witmperl b, gipi_witem c
                            WHERE c.par_id   = A.par_id
							  AND c.item_grp = A.item_grp
							  AND b.par_id   = c.par_id
                              AND b.item_no  = c.item_no))
               OR
               (nvl(p_pack,'N') = 'N'));
	/*Modified by Iris Bordey 09.30.03
	**To resolve ora-02291 on gipi_winvperl for package policies.
	**Checks if item_grp (from gipi_witem) has corresponding peril on
	**gipi_witmperl*/
	/*CURSOR c4 IS
       SELECT DISTINCT a.item_grp
         FROM gipi_witem a
        WHERE a.par_id   = p_par_id
          AND (
              (NVL(p_pack,'N') = 'Y'
               AND EXISTS (SELECT '1'
                             FROM gipi_witmperl b
                            WHERE b.par_id = a.par_id
                              AND b.item_no = a.item_no))
               OR
               (NVL(p_pack,'N') = 'N'));*/
	/*CURSOR c4 IS
       SELECT DISTINCT item_grp
         FROM gipi_witem
        WHERE par_id   = p_par_id;*/
          --AND ITEM_GRP = PREV_ITEM_GRP;--AIVHIE 120601
		  				   				 --REQUIRED TAX MUST BE INSERTED
										 --PER ITEM_GRP AND NOT JUST ON THE
										 --LAST ITEM_GRP
BEGIN
IF p_policy_id  = 0 AND
   p_pol_id_n   = 0 AND
   p_old_par_id = 0 THEN -- CONDITION ADDED BY AIVHIE 120301
    FOR c4_rec IN c4
    LOOP
	  BEGIN
        DECLARE
          CURSOR c1 IS
             SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate, b.peril_sw,
                    b.tax_id,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM --GIIS_TAX_PERIL A,
	                  giis_tax_charges b
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd  (+)     = p_iss_cd
                AND b.primary_sw      = 'Y'
	              -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
	              -- PAR HAS BEEN CREATED. (LOTH 032200)
	            AND b.eff_start_date  <= p_issue_date
	            AND b.eff_end_date    >= p_issue_date
	              -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
	              -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
	            AND nvl(b.issue_date_tag, 'N') = 'Y';
	        CURSOR d1 IS
             SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate, b.tax_id, b.peril_sw,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM giis_tax_charges b, giis_tax_issue_place c
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd       (+)= p_iss_cd
                AND b.iss_cd          = c.iss_cd(+)
                AND b.line_cd         = c.line_cd(+)
                AND b.tax_cd          = c.tax_cd(+)
                AND c.place_cd     (+)= p_place_cd
                AND b.primary_sw      = 'Y'
                AND b.eff_start_date <= p_issue_date
	            AND b.eff_end_date   >= p_issue_date
	            AND nvl(b.issue_date_tag, 'N') = 'Y';
          CURSOR c1a IS
             SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate, b.peril_sw,
                    b.tax_id,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM --GIIS_TAX_PERIL A,
	                  giis_tax_charges b
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd  (+)     = p_iss_cd
                AND b.primary_sw      = 'Y'
	              -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
	              -- PAR HAS BEEN CREATED. (LOTH 032200)
	            AND b.eff_start_date <= p_eff_date
	            AND b.eff_end_date   >= p_eff_date
	              -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
	              -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
	            AND nvl(b.issue_date_tag, 'N') = 'N';
	        CURSOR d2 IS
             SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate, b.peril_sw,b.tax_id,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM giis_tax_charges b, giis_tax_issue_place c
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd       (+)= p_iss_cd
                AND b.iss_cd          = c.iss_cd(+)
                AND b.line_cd         = c.line_cd(+)
                AND b.tax_cd          = c.tax_cd(+)
                AND c.place_cd     (+)= p_place_cd
                AND b.primary_sw      = 'Y'
                AND b.eff_start_date <= p_eff_date
	            AND b.eff_end_date   >= p_eff_date
	            AND nvl(b.issue_date_tag, 'N') = 'N';
	      BEGIN
	        IF p_place_cd IS NOT NULL THEN
	         	 FOR d1_rec IN d1
             LOOP
               BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                        sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = d1_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  d1_rec.tax_id;
                   IF d1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * nvl(d1_rec.rate,0) / 100;
                            IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c3_rec.prem_amt > 0 THEN
 							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
						   	      p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                            END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * nvl(d1_rec.rate,0) / 100;
          					IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c5_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   ELSE
						   	      p_tax_amt := floor(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
                      		END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
	                 END IF;
	                 INSERT INTO gipi_winv_tax
                      (par_id,              item_grp,          tax_cd,
                       line_cd,             iss_cd,            rate,
                       tax_amt,             tax_id,            tax_allocation,
                       fixed_tax_allocation)
                     VALUES
                      (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
                       p_line_cd,           p_iss_cd,          d1_rec.rate,
                       tax_amt_per_group1,  p_tax_id,          d1_rec.tax_alloc,
                       d1_rec.fixed_tax_alloc);
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
           	 FOR d2_rec IN d2
             LOOP
               BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = d2_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  d2_rec.tax_id;
                   IF d2_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * nvl(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c3_rec.prem_amt > 0 THEN
 							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
							      p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                            END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * nvl(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c5_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
                               ELSE
							      p_tax_amt := floor(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
							   tax_amt_per_group1 := p_tax_amt;
                            END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                      END LOOP;
                    END;
                   END IF;
                   INSERT INTO gipi_winv_tax
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          d2_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
                        d2_rec.fixed_tax_alloc);
                   END;
                   p_tax_amt          := 0;
                   tax_amt_per_group1 := 0;
                 END;
               END LOOP;
           ELSE
          	 FOR c1_rec IN c1
             LOOP
             	 BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = c1_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  c1_rec.tax_id;
                   IF c1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * c1_rec.rate / 100;
            				IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                     		   IF c3_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
 						   	      p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                     		END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * c1_rec.rate / 100;
							IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
               				   IF c5_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   ELSE
							      p_tax_amt := floor(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
                            END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
--                IF TAX_AMT_PER_GROUP1 != 0 THEN
	                 INSERT INTO gipi_winv_tax
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                      c1_rec.fixed_tax_alloc);
   --                END IF;
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
             FOR c1a_rec IN c1a
             LOOP
               BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = c1a_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  c1a_rec.tax_id;
                   IF c1a_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            v_prem_amt := c3_rec.prem_amt + nvl(v_prem_amt,0); ----ADDED BY BDARUSIN, COPIED FROM OLD CREATE_WINVOICE
                            p_tax_amt          := c3_rec.prem_amt * c1a_rec.rate / 100;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            v_prem_amt := c5_rec.prem_amt + nvl(v_prem_amt,0); --B
                            p_tax_amt := c5_rec.prem_amt * c1a_rec.rate / 100;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
                   IF c1a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                      IF v_prem_amt > 0 THEN
					     tax_amt_per_group1 := ceil(v_prem_amt / 4) * (0.5);
					  ELSE
					     tax_amt_per_group1 := floor(v_prem_amt / 4) * (0.5);
					  END IF;
                   END IF;
--                IF TAX_AMT_PER_GROUP1 != 0 THEN
	                 INSERT INTO gipi_winv_tax
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1a_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc);
     --               END IF;
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
				 v_prem_amt         := 0; --bdarusin 12022002
               END;
             END LOOP;
          END IF;
        END;
      END;
    END LOOP;
---***---
ELSE
---***---
  DECLARE
    p_tax_id     giis_tax_charges.tax_id%TYPE;
    v_line_cd     gipi_polbasic.line_cd%TYPE;
	v_subline_cd  gipi_polbasic.subline_cd%TYPE;
	v_iss_cd      gipi_polbasic.iss_cd%TYPE;
	v_issue_yy    gipi_polbasic.issue_yy%TYPE;
	v_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
	v_renew_no    gipi_polbasic.renew_no%TYPE;
    /*Modified by Iris Bordey 12.09.2003
	**Problem : ORA-02291 on table gipi_winv_tax (parent rec, from gipi_winvoice not found)
	**Resolution : Since at this point necessary insert/update were made already to
	**           : to gipi_winvoice and since it is "non-existing" item_grp from gipi_winvoice
    **           : that causes the ora error, query for item_grp will come from gipi_winvoice.
	**Note       : ORA-02291 error on table gipi_winvperl will be handled.
	*/
	CURSOR c4 IS
      SELECT item_grp
        FROM gipi_winvoice A
       WHERE par_id = p_par_id
         AND (
              (nvl(p_pack,'N') = 'Y'
               AND EXISTS (SELECT '1'
                             FROM gipi_witmperl b, gipi_witem c
                            WHERE c.par_id   = A.par_id
							  AND c.item_grp = A.item_grp
							  AND b.par_id   = c.par_id
                              AND b.item_no  = c.item_no))
               OR
               (nvl(p_pack,'N') = 'N'));
	/** Modified by : Iris Bordey 09.30.03
	    To resolve ora-02291 on gipi_winvperil for package policies.
		Checks if item_grp (from gipi_witem) has corresponding peril on
		gipi_witemperil**/
    /*CURSOR c4 IS
	  SELECT DISTINCT a.item_grp
	    FROM gipi_witem a
	   WHERE a.par_id = p_par_id
	     AND (NVL(p_pack,'N') = 'Y'
		      AND EXISTS (SELECT '1'
			                FROM gipi_witmperl b
						   WHERE b.par_id = a.par_id
						     AND b.item_no = a.item_no))
		  OR (NVL(p_pack,'N') = 'N');*/
       /**SELECT DISTINCT item_grp
         FROM gipi_witem
        WHERE par_id = p_par_id;**/
         -- AND ITEM_GRP = PREV_ITEM_GRP; -- COMMENTED BY : AIVHIE 112301
		                                  -- IF NOT COMMENTED WILL INSERT ONLY ONE ITEM_GRP
										  -- TO GIPI_INV_TAX
  BEGIN
/*
** ADDED BY : AIVHIE 112401
** TO HANDLE POLICY SUMMARY DETAILS
*/
	FOR pol IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
	              FROM gipi_polbasic
				 WHERE policy_id = p_policy_id)
    LOOP
      v_line_cd    := pol.line_cd;
   	  v_subline_cd := pol.subline_cd;
	  v_iss_cd     := pol.iss_cd;
	  v_issue_yy   := pol.issue_yy;
	  v_pol_seq_no := pol.pol_seq_no;
	  v_renew_no   := pol.renew_no;
	  EXIT;
    END LOOP;
    FOR c4_rec IN c4
    LOOP
	  BEGIN
        DECLARE
          CURSOR c1 IS
             SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate, b.peril_sw,
                    b.tax_id,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM --GIIS_TAX_PERIL A,
	                  giis_tax_charges b
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd  (+)     = p_iss_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
				                              -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
											  -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
											  -- TAX_CD (WHICH ARE OPTIONAL)
											  -- FROM THE COPIED POLICY OR PAR
	              -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
	              -- PAR HAS BEEN CREATED. (LOTH 032200)
	            AND b.eff_start_date  <= p_issue_date
	            AND b.eff_end_date    >= p_issue_date
	              -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
				  -- PER ITEM_GRP.
				  -- ADDED BY : AIVHIE 112301
				AND b.tax_cd IN (SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id IN (SELECT policy_id
														                       FROM gipi_polbasic
																			  WHERE line_cd    = v_line_cd
																			    AND subline_cd = v_subline_cd
																				AND iss_cd     = v_iss_cd
																				AND issue_yy   = v_issue_yy
																				AND pol_seq_no = v_pol_seq_no
																				AND renew_no   = v_renew_no))
							      UNION
								 SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id = p_pol_id_n)
								  UNION
							     SELECT tax_cd
				                   FROM gipi_winv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND par_id   = p_old_par_id)
	              -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
	              -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
	            AND nvl(b.issue_date_tag, 'N') = 'Y';
	        CURSOR d1 IS
             SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate, b.tax_id, b.peril_sw,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM giis_tax_charges b, giis_tax_issue_place c
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd       (+)= p_iss_cd
                AND b.iss_cd          = c.iss_cd(+)
                AND b.line_cd         = c.line_cd(+)
                AND b.tax_cd          = c.tax_cd(+)
                AND c.place_cd     (+)= p_place_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
				                              -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
											  -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
											  -- TAX_CD (WHICH ARE OPTIONAL)
											  -- FROM THE COPIED POLICY OR PAR
                AND b.eff_start_date <= p_issue_date
	            AND b.eff_end_date   >= p_issue_date
	              -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
				  -- PER ITEM_GRP.
				  -- ADDED BY : AIVHIE 112301
				AND b.tax_cd IN (SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id IN (SELECT policy_id
														                       FROM gipi_polbasic
																			  WHERE line_cd    = v_line_cd
																			    AND subline_cd = v_subline_cd
																				AND iss_cd     = v_iss_cd
																				AND issue_yy   = v_issue_yy
																				AND pol_seq_no = v_pol_seq_no
																				AND renew_no   = v_renew_no))
       						      UNION
								 SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id = p_pol_id_n)
								  UNION
							     SELECT tax_cd
				                   FROM gipi_winv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND par_id   = p_old_par_id)
	            AND nvl(b.issue_date_tag, 'N') = 'Y';
          CURSOR c1a IS
             SELECT DISTINCT b.tax_cd, nvl(b.rate,0) rate, b.peril_sw,
                    b.tax_id,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM --GIIS_TAX_PERIL A,
	                  giis_tax_charges b
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd  (+)     = p_iss_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
				                              -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
											  -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
											  -- TAX_CD (WHICH ARE OPTIONAL)
											  -- FROM THE COPIED POLICY OR PAR
	              -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
	              -- PAR HAS BEEN CREATED. (LOTH 032200)
	            AND b.eff_start_date <= p_eff_date
	            AND b.eff_end_date   >= p_eff_date
	              -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
				  -- PER ITEM_GRP.
				  -- ADDED BY : AIVHIE 112301
				AND b.tax_cd IN (SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id IN (SELECT policy_id
														                       FROM gipi_polbasic
																			  WHERE line_cd    = v_line_cd
																			    AND subline_cd = v_subline_cd
																				AND iss_cd     = v_iss_cd
																				AND issue_yy   = v_issue_yy
																				AND pol_seq_no = v_pol_seq_no
																				AND renew_no   = v_renew_no))
							      UNION
								 SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id = p_pol_id_n)
								  UNION
							     SELECT tax_cd
				                   FROM gipi_winv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND par_id   = p_old_par_id)
	              -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
	              -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
	            AND nvl(b.issue_date_tag, 'N') = 'N';
	        CURSOR d2 IS
             SELECT DISTINCT b.tax_cd, nvl(nvl(c.rate, b.rate),0) rate, b.peril_sw,b.tax_id,
                    decode(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    decode(b.allocation_tag,'N','N','Y') fixed_tax_alloc
               FROM giis_tax_charges b, giis_tax_issue_place c
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd       (+)= p_iss_cd
                AND b.iss_cd          = c.iss_cd(+)
                AND b.line_cd         = c.line_cd(+)
                AND b.tax_cd          = c.tax_cd(+)
                AND c.place_cd     (+)= p_place_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
				                              -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
											  -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
											  -- TAX_CD (WHICH ARE OPTIONAL)
											  -- FROM THE COPIED POLICY OR PAR
                AND b.eff_start_date <= p_eff_date
	            AND b.eff_end_date   >= p_eff_date
	              -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
				  -- PER ITEM_GRP.
				  -- ADDED BY : AIVHIE 112301
				AND b.tax_cd IN (SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id IN (SELECT policy_id
														                       FROM gipi_polbasic
																			  WHERE line_cd    = v_line_cd
																			    AND subline_cd = v_subline_cd
																				AND iss_cd     = v_iss_cd
																				AND issue_yy   = v_issue_yy
																				AND pol_seq_no = v_pol_seq_no
																				AND renew_no   = v_renew_no))
							      UNION
								 SELECT tax_cd
				                   FROM gipi_inv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND prem_seq_no IN (SELECT prem_seq_no
							                              FROM gipi_invoice
							     					     WHERE policy_id = p_pol_id_n)
								  UNION
							     SELECT tax_cd
				                   FROM gipi_winv_tax
							      WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
								                          --08222002
								                          --FOR OPTIMIZATION PURPOSES
								    AND item_grp = c4_rec.item_grp
							        AND par_id   = p_old_par_id)
	            AND nvl(b.issue_date_tag, 'N') = 'N';
	      BEGIN
	        IF p_place_cd IS NOT NULL THEN
	         	 FOR d1_rec IN d1
             LOOP
               BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                        sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = d1_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  d1_rec.tax_id;
                   IF d1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * nvl(d1_rec.rate,0) / 100;
           					IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                 			   IF c3_rec.prem_amt > 0 THEN
 							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
						   	      p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                            END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * nvl(d1_rec.rate,0) / 100;
							IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                 			   IF c5_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   ELSE
						   	      p_tax_amt := floor(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
               				END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
	                 END IF;
	                 INSERT INTO gipi_winv_tax
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          d1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          d1_rec.tax_alloc,
                      d1_rec.fixed_tax_alloc);
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
           	 FOR d2_rec IN d2
             LOOP
               BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = d2_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  d2_rec.tax_id;
                   IF d2_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * nvl(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
              		           IF c3_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
							      p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                            END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * nvl(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
              		           IF c5_rec.prem_amt > 0 THEN
 							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   ELSE
						   	      p_tax_amt := floor(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
               		        END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                      END LOOP;
                    END;
                   END IF;
                   INSERT INTO gipi_winv_tax
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          d2_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
                        d2_rec.fixed_tax_alloc);
                   END;
                   p_tax_amt          := 0;
                   tax_amt_per_group1 := 0;
                 END;
               END LOOP;
           ELSE
          	 FOR c1_rec IN c1
             LOOP
             	 BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = c1_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  c1_rec.tax_id;
                   IF c1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * c1_rec.rate / 100;
							IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                       		   IF c3_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
						          p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                     		END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * c1_rec.rate / 100;
                            IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c5_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   ELSE
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
                	        END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
--                IF TAX_AMT_PER_GROUP1 != 0 THEN
	                 INSERT INTO gipi_winv_tax
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                      c1_rec.fixed_tax_alloc);
   --                END IF;
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
             FOR c1a_rec IN c1a
             LOOP
               BEGIN
                 DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, sum(nvl(A.prem_amt,0)) prem_amt,
                            sum(nvl(A.tsi_amt,0)) tsi_amt
                       FROM gipi_witmperl A, gipi_witem b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM giis_tax_peril
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = c1a_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;
                 BEGIN
                   p_tax_id   :=  c1a_rec.tax_id;
                   IF c1a_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * c1a_rec.rate / 100;
							IF c1a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c3_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c3_rec.prem_amt / 4) * (0.5);
							   ELSE
							   	  p_tax_amt := floor(c3_rec.prem_amt / 4) * (0.5);
							   END IF;
                  			END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * c1a_rec.rate / 100;
							IF c1a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                        	   IF c5_rec.prem_amt > 0 THEN
							      p_tax_amt := ceil(c5_rec.prem_amt / 4) * (0.5);
							   ELSE
							      p_tax_amt := floor(c5_rec.prem_amt / 4) * (0.5);
							   END IF;
                     		END IF;
                            tax_amt_per_group1 := nvl(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
--                IF TAX_AMT_PER_GROUP1 != 0 THEN
	                 INSERT INTO gipi_winv_tax
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1a_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc);
     --               END IF;
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
          END IF;
        END;
      END;
    END LOOP;
  END;
  END IF;
  END;
---***---
  FOR c1_rec IN c1
  LOOP
    BEGIN
      INSERT INTO gipi_winvperl
           (par_id,         peril_cd,          item_grp,
            tsi_amt,        prem_amt,          ri_comm_amt,
            ri_comm_rt)
      VALUES
           (p_par_id,       c1_rec.peril_cd,   c1_rec.item_grp,
            c1_rec.tsi_amt, c1_rec.prem_amt,   c1_rec.ri_comm_amt,
            decode(c1_rec.prem_amt,0,0,c1_rec.ri_comm_rt));
    END;
  END LOOP;
  FOR c IN (
    SELECT  pack_pol_flag
      FROM  gipi_wpolbas
     WHERE  par_id        =  p_par_id
       AND  pack_pol_flag = 'Y')
  LOOP
    FOR d IN (
      SELECT DISTINCT item_grp
	FROM gipi_winvoice
       WHERE par_id = p_par_id)
    LOOP
    FOR A IN (
      SELECT  par_id,  prem_seq_no,   prem_amt,
              tax_amt, other_charges, item_grp
        FROM  gipi_winvoice
       WHERE  par_id  =  p_par_id
	 AND  item_grp =  d.item_grp)
    LOOP
      FOR b IN (
        SELECT  DISTINCT pack_line_cd
          FROM  gipi_witem
         WHERE  par_id   =  p_par_id
           AND  item_grp =  A.item_grp)
      LOOP
        INSERT INTO GIPI_WPACKAGE_INV_TAX
             (par_id,     item_grp,   line_cd,        prem_seq_no,
              prem_amt,   tax_amt,    other_charges)
        VALUES
             (A.par_id,   d.item_grp, b.pack_line_cd, A.prem_seq_no,
              A.prem_amt, A.tax_amt,  A.other_charges);
        END LOOP;
     END LOOP;
    END LOOP;
     EXIT;
  END LOOP;
  --06.14.2006
  --for processsing of package
  FOR c1 IN (SELECT b.pack_par_id, b.line_cd
               FROM GIPI_PACK_PARLIST b,
			        gipi_parlist A
			  WHERE b.pack_par_id = A.pack_par_id
			    AND A.par_id = p_par_id)
  LOOP
    IF c1.pack_par_id IS NOT NULL THEN
	   --to refresh the value of GIPI_PACK_WINVOICE
	   DELETE FROM GIPI_PACK_WINVOICE
	    WHERE pack_par_id = c1.pack_par_id;
       INSERT INTO GIPI_PACK_WINVOICE(pack_par_id, item_grp, payt_terms, prem_seq_no, prem_amt, tax_amt, property, insured, due_date, notarial_fee, ri_comm_amt, currency_cd, currency_rt, remarks, other_charges, ref_inv_no, policy_currency, bond_rate, bond_tsi_amt, pay_type, card_name, card_no, approval_cd, expiry_date, ri_comm_vat)
	   SELECT c1.pack_par_id, item_grp, payt_terms, prem_seq_no, sum(prem_amt), sum(tax_amt), property, insured, due_date, notarial_fee, sum(ri_comm_amt), currency_cd, currency_rt, remarks, sum(other_charges), ref_inv_no, policy_currency, bond_rate, sum(bond_tsi_amt), pay_type, card_name, card_no, approval_cd, expiry_date, sum(ri_comm_vat)
		 FROM gipi_winvoice A
		WHERE EXISTS (SELECT 1
		                FROM gipi_parlist gp
					   WHERE gp.par_id = A.par_id
						 AND gp.pack_par_id = c1.pack_par_id)
	    GROUP BY c1.pack_par_id, item_grp, payt_terms, prem_seq_no, property, insured, due_date, notarial_fee, currency_cd, currency_rt, remarks, ref_inv_no, policy_currency, bond_rate, pay_type, card_name, card_no, approval_cd, expiry_date;
	   --to refresh the value of GIPI_PACK_WINSTALLMENT
	   DELETE FROM GIPI_PACK_WINSTALLMENT
	    WHERE pack_par_id = c1.pack_par_id;
       INSERT INTO GIPI_PACK_WINSTALLMENT(pack_par_id, item_grp, inst_no, share_pct, prem_amt, tax_amt, due_date)
	   SELECT c1.pack_par_id, item_grp, inst_no, share_pct, sum(prem_amt), sum(tax_amt), due_date
		 FROM GIPI_WINSTALLMENT A
		WHERE EXISTS (SELECT 1
		                FROM gipi_parlist gp
					   WHERE gp.par_id = A.par_id
						 AND gp.pack_par_id = c1.pack_par_id)
	    GROUP BY c1.pack_par_id, item_grp, inst_no, share_pct, due_date;
	   --to refresh the value of GIPI_PACK_WINVPERL
	   DELETE FROM GIPI_PACK_WINVPERL
	    WHERE pack_par_id = c1.pack_par_id;
       INSERT INTO GIPI_PACK_WINVPERL(pack_par_id, line_cd, peril_cd, item_grp, tsi_amt, prem_amt, ri_comm_amt, ri_comm_rt)
	   SELECT c1.pack_par_id, c1.line_cd, peril_cd, item_grp, sum(tsi_amt), sum(prem_amt), sum(ri_comm_amt), ri_comm_rt
		 FROM GIPI_WINVPERL A
		WHERE EXISTS (SELECT 1
		                FROM gipi_parlist gp
					   WHERE gp.par_id = A.par_id
						 AND gp.pack_par_id = c1.pack_par_id)
	    GROUP BY c1.pack_par_id, c1.line_cd, peril_cd, item_grp, ri_comm_rt;
	   --to refresh the value of GIPI_PACK_WINV_TAX
	   DELETE FROM GIPI_PACK_WINV_TAX
	    WHERE pack_par_id = c1.pack_par_id;
       INSERT INTO GIPI_PACK_WINV_TAX(pack_par_id, item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_amt, tax_id, rate)
	   SELECT c1.pack_par_id, item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, sum(tax_amt), tax_id, rate
		 FROM GIPI_WINV_TAX A
		WHERE EXISTS (SELECT 1
		                FROM gipi_parlist gp
					   WHERE gp.par_id = A.par_id
						 AND gp.pack_par_id = c1.pack_par_id)
	    GROUP BY c1.pack_par_id, item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_id, rate;
	END IF;
  END LOOP;
END;
/


