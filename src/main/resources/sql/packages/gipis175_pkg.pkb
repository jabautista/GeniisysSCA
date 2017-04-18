CREATE OR REPLACE PACKAGE BODY CPI.GIPIS175_PKG
AS

   FUNCTION get_policy_lov (
      p_user_id       VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_issue_yy      VARCHAR2,
      p_pol_seq_no    VARCHAR2,
      p_renew_no      VARCHAR2,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       VARCHAR2,
      p_endt_seq_no   VARCHAR2,
      p_assd_name     VARCHAR2
   )
      RETURN policy_lov_tab PIPELINED
   IS
      v_list policy_lov_type;
      v_collection NUMBER;
      v_where VARCHAR2(32767);
      
      TYPE v_type IS RECORD (
         policy_id          gipi_polbasic.policy_id%TYPE,
         line_cd            gipi_polbasic.line_cd%TYPE,
         subline_cd         gipi_polbasic.subline_cd%TYPE,
         iss_cd             gipi_polbasic.iss_cd%TYPE,
         issue_yy           gipi_polbasic.issue_yy%TYPE,
         pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
         renew_no           gipi_polbasic.renew_no%TYPE,
         par_id             gipi_polbasic.par_id%TYPE,
         pol_flag           gipi_polbasic.pol_flag%TYPE,
         pack_pol_flag      gipi_polbasic.pack_pol_flag%TYPE,
         co_insurance_sw    gipi_polbasic.co_insurance_sw%TYPE,
         expiry_date        gipi_polbasic.expiry_date%TYPE,
         acct_ent_date      gipi_polbasic.acct_ent_date%TYPE,
         assd_no            giis_assured.assd_no%TYPE,
         prorate_flag       gipi_polbasic.prorate_flag%TYPE,
         short_rt_percent   gipi_polbasic.short_rt_percent%TYPE,
         prov_prem_pct      gipi_polbasic.prov_prem_pct%TYPE,
         endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
         endt_yy            gipi_polbasic.endt_yy%TYPE,
         endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
         assd_name          giis_assured.assd_name%TYPE
      );
      
      TYPE v_tab IS TABLE OF v_type;
      v_list2 v_tab;
      
   BEGIN
   
      IF p_endt_iss_cd IS NOT NULL THEN
         v_where := ' AND UPPER(endt_iss_cd) LIKE UPPER(''' || p_endt_iss_cd || ''')
                      AND endt_seq_no > 0';
      END IF;
      
      IF p_endt_yy IS NOT NULL THEN
         v_where := v_where || ' AND endt_yy = ' || p_endt_yy || '
                    AND endt_seq_no > 0';
      END IF;
      
      IF p_endt_seq_no IS NOT NULL THEN
         v_where := v_where || ' AND endt_seq_no =  ' || p_endt_seq_no || '
                    AND endt_seq_no > 0';
      END IF;
      
      EXECUTE IMMEDIATE
         'SELECT policy_id, line_cd, subline_cd, iss_cd,
                 issue_yy, pol_seq_no, renew_no, par_id,
                 pol_flag, pack_pol_flag, co_insurance_sw,
                 expiry_date, acct_ent_date, a.assd_no,
                 prorate_flag, short_rt_percent, prov_prem_pct,
                 endt_iss_cd, endt_yy, endt_seq_no,
                 b.assd_name
            FROM gipi_polbasic a, giis_assured b    
           WHERE iss_cd IN (SELECT param_value_v
                              FROM giis_parameters
                             WHERE param_name = ''ISS_CD_RI'')
             AND pol_flag IN (''1'', ''2'', ''3'')
             AND a.assd_no = b.assd_no
             AND NVL(endt_type, ''A'') = ''A'''
--             AND line_cd = DECODE(check_user_per_line2(line_cd, iss_cd, ''GIPIS175'',''' || p_user_id || '''), 1, line_cd, NULL)
--             AND iss_cd = ''RI''  
             || 'AND iss_cd = DECODE(check_user_per_iss_cd2(line_cd, iss_cd ,''GIPIS175'',''' || p_user_id || ''') ,1, iss_cd, NULL)
             AND UPPER(line_cd) LIKE UPPER(NVL(''' || p_line_cd || ''', line_cd))
             AND UPPER(subline_cd) LIKE UPPER(NVL(''' || p_subline_cd || ''', subline_cd))
             AND UPPER(iss_cd) LIKE UPPER(NVL(''' || p_iss_cd || ''', iss_cd))
             AND issue_yy = NVL(''' || p_issue_yy || ''', issue_yy)
             AND pol_seq_no = NVL(''' || p_pol_seq_no || ''', pol_seq_no)
             AND renew_no = NVL(''' || p_renew_no || ''', renew_no)
             AND UPPER(b.assd_name) LIKE UPPER(NVL(''' || p_assd_name || ''',b.assd_name))'
             || v_where ||
        'ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no'
      BULK COLLECT
      INTO v_list2;
      
      IF v_list2.LAST > 0 THEN
      
         FOR i IN v_list2.FIRST..v_list2.LAST
         LOOP
            v_list.policy_id        := v_list2(i).policy_id;
            v_list.line_cd          := v_list2(i).line_cd;
            v_list.subline_cd       := v_list2(i).subline_cd;
            v_list.iss_cd           := v_list2(i).iss_cd;
            v_list.issue_yy         := v_list2(i).issue_yy;
            v_list.pol_seq_no       := v_list2(i).pol_seq_no;
            v_list.renew_no         := v_list2(i).renew_no;
            v_list.par_id           := v_list2(i).par_id;
            v_list.pol_flag         := v_list2(i).pol_flag;
            v_list.pack_pol_flag    := v_list2(i).pack_pol_flag;
            v_list.co_insurance_sw  := v_list2(i).co_insurance_sw;
            v_list.expiry_date      := v_list2(i).expiry_date;
            v_list.acct_ent_date    := v_list2(i).acct_ent_date;
            v_list.assd_no          := v_list2(i).assd_no;
            v_list.prorate_flag     := v_list2(i).prorate_flag;
            v_list.short_rt_percent := v_list2(i).short_rt_percent;
            v_list.prov_prem_pct    := v_list2(i).prov_prem_pct;
            v_list.assd_name        := v_list2(i).assd_name;
               
            
            IF NVL(v_list2(i).endt_seq_no,0) = 0 THEN
               v_list.endt_iss_cd := NULL;
               v_list.endt_yy     := NULL;
               v_list.endt_seq_no := NULL;
            ELSE     
               v_list.endt_iss_cd := v_list2(i).endt_iss_cd;
               v_list.endt_yy := v_list2(i).endt_yy;
               v_list.endt_seq_no := v_list2(i).endt_seq_no;
            END IF;
            
--            BEGIN
--               SELECT assd_name
--                 INTO v_list.assd_name
--                 FROM giis_assured
--                WHERE assd_no = i.assd_no;
--            EXCEPTION WHEN NO_DATA_FOUND THEN
--               v_list.assd_name := NULL;     
--            END;
            
            IF v_list2(i).expiry_date < SYSDATE THEN
               v_list.expired_sw := 'N';
            ELSE
               v_list.expired_sw := 'Y';   
            END IF;
            
            FOR a IN(SELECT a.incept_date, a.eff_date, a.acct_ent_date, a.expiry_date,
                            a.issue_date, a.booking_mth, a.booking_year, ri_name, c.ri_cd
                       FROM gipi_polbasic a,
                            giri_inpolbas b,
                             giis_reinsurer c
                      WHERE a.policy_id = b.policy_id
                        AND b.ri_cd = c.ri_cd    
                        AND b.policy_id = v_list2(i).policy_id)
            LOOP
               v_list.nbt_incept_date         :=   a.incept_date;
               v_list.nbt_eff_date            :=   a.eff_date;
               v_list.nbt_acct_ent_date      :=   a.acct_ent_date;
               v_list.nbt_expiry_date         :=   a.expiry_date;
               v_list.nbt_issue_date         :=   a.issue_date;
               v_list.nbt_booking_mth         :=   a.booking_mth;
               v_list.nbt_booking_year      :=   a.booking_year;
               v_list.nbt_ceding_company   :=   a.ri_name;
               v_list.ri_cd                  :=  a.ri_cd; 
            END LOOP;
            
            BEGIN
               SELECT SUM(a.collection_amt)
                 INTO v_collection
                 FROM giac_inwfacul_prem_collns a, 
                      giac_acctrans b, 
                      gipi_invoice x
                WHERE a.gacc_tran_id = b.tran_id 
                  AND b.tran_flag <> 'D' 
                  AND a.b140_iss_cd = x.iss_cd
                  AND a.b140_prem_seq_no = x.prem_seq_no
                  AND x.iss_cd = 'RI'
                  AND x.prem_seq_no IN (SELECT prem_seq_no
                                          FROM gipi_invoice
                                         WHERE policy_id = v_list2(i).policy_id)
                  AND a.gacc_tran_id NOT IN (SELECT  c.gacc_tran_id 
                                               FROM  giac_reversals c, 
                                                        giac_acctrans d 
                                                 WHERE  c.reversing_tran_id = d.tran_id 
                                                   AND  d.tran_flag <> 'D');
            END;
            
            IF NVL(v_collection,0) = 0 THEN
               v_list.updatable_sw := 'Y';
            ELSE
               v_list.updatable_sw := 'N';
            END IF;
            
            FOR j IN(SELECT a.policy_id,
                            SUM(a.ri_comm_amt) ri_comm_amt
                     FROM GIPI_ITMPERIL a,
                            giri_inpolbas b,
                              gipi_polbasic c,
                              gipi_invoice d,
                              giis_reinsurer e
                     WHERE a.policy_id = b.policy_id
                       AND b.policy_id = c.policy_id
                       AND c.policy_id = d.policy_id
                       AND b.ri_cd	   = e.ri_cd
                       AND d.policy_id = v_list2(i).policy_id
                   GROUP BY a.policy_id) 
            LOOP
               v_list.prev_ri_comm_amt := j.ri_comm_amt;
            END LOOP;
            
            BEGIN
               FOR ii IN(SELECT a.policy_id,
                               item_no,
                               SUM(a.ri_comm_amt) ri_comm_amt,
                               d.ri_comm_vat ri_comm_vat_GI,
                               d.ri_comm_amt ri_comm_amt_GI
                          FROM gipi_itmperil a,
                               giri_inpolbas b,
                               gipi_polbasic c,
                               gipi_invoice d,
                               giis_reinsurer e
                         WHERE a.policy_id = b.policy_id
                           AND b.policy_id = c.policy_id
                           AND c.policy_id = d.policy_id
                           AND b.ri_cd	   = e.ri_cd
                           AND d.policy_id = v_list2(i).policy_id
                      GROUP BY a.policy_id,
                               item_no,
                               input_vat_rate,
                               d.ri_comm_vat,
                               d.ri_comm_amt)
               LOOP
                  v_list.v480_policy_id			:= ii.policy_id;
                  v_list.v480_item_no				:= ii.item_no;
                  v_list.v480_ri_comm_amt		:= ii.ri_comm_amt;
                  
                  IF ii.ri_comm_vat_gi = 0 AND ii.ri_comm_amt_gi = 0 THEN
                     v_list.v480_ri_comm_vat := 0.00;
                  ELSE	
                     v_list.v480_ri_comm_vat := (v_list.v480_ri_comm_amt*(((ii.ri_comm_vat_gi*100)/ii.ri_comm_amt_gi)/100));
                  END IF;
                  v_list.old_ri_comm_vat := v_list.v480_ri_comm_vat; --Added by MarkS 9.14.2016 SR23053
               END LOOP;
            END;
            
            BEGIN
               SELECT DISTINCT NVL (b.cred_branch, b.iss_cd) iss_cd
                          INTO v_list.v_iss_cd
                          FROM giri_inpolbas a, gipi_polbasic b, gipi_invoice c
                         WHERE a.policy_id = b.policy_id
                           AND b.policy_id = c.policy_id
                           AND b.line_cd != 'BB'
                           AND b.policy_id = v_list2(i).policy_id;
      		
               IF UPPER (v_list.v_iss_cd) = 'RI'
               THEN
                  SELECT param_value_v
                    INTO v_list.branch_cd
                    FROM giac_parameters
                   WHERE param_name = 'RI_ISS_CD';
      		
                  IF v_list.branch_cd = 'RI'
                  THEN
                     SELECT param_value_v
                       INTO v_list.branch_cd
                       FROM giac_parameters
                      WHERE param_name = 'BRANCH_CD';
                  END IF;
               ELSE
                  SELECT branch_cd
                    INTO v_list.branch_cd
                    FROM giis_issource a, giac_branches b
                   WHERE a.acct_iss_cd = b.acct_branch_cd
                     AND b.gfun_fund_cd = v_list.fund_cd
                     AND a.iss_cd = v_list.v_iss_cd;
               END IF;
            END;
            
            BEGIN
               SELECT input_vat_rate
                 INTO v_list.input_vat_rate
                 FROM giis_reinsurer
                WHERE ri_cd IN (SELECT ri_cd
                                  FROM giri_inpolbas
                                 WHERE policy_id = v_list2(i).policy_id);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Input VAT Rate not found!');
            END;
         
            PIPE ROW(v_list);
         END LOOP;
      
      END IF;
      
   END get_policy_lov;
   
   FUNCTION get_items (
      p_policy_id VARCHAR2
   )
      RETURN item_tab PIPELINED
   IS
      v_list item_type;
      v_old_ri_comm_vat NUMBER(16, 2);
   BEGIN
      FOR i IN (SELECT item_grp, item_desc, item_desc2,
                       rec_flag, currency_cd, pack_line_cd,
                       pack_subline_cd, item_no, item_title
                  FROM gipi_item
                 WHERE policy_id = p_policy_id
              ORDER BY item_no)
      LOOP
         v_list.item_grp := i.item_grp;
         v_list.item_desc := i.item_desc;
         v_list.item_desc2 := i.item_desc2;
         v_list.rec_flag := i.rec_flag;
         v_list.currency_cd := i.currency_cd;
         v_list.pack_line_cd := i.pack_line_cd;
         v_list.pack_subline_cd := i.pack_subline_cd;
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         
         BEGIN
            SELECT currency_desc
              INTO v_list.dsp_currency_desc
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         END;
      
         BEGIN
            SELECT prem_seq_no 
              INTO v_list.prem_seq_no
               FROM gipi_invoice
             WHERE policy_id = p_policy_id
                AND item_grp = i.item_grp; 
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.prem_seq_no := NULL;
         END;
         
         BEGIN
            SELECT SUM(ri_comm_amt) ri_comm_amt
              INTO v_list.sum_comm_amt
              FROM gipi_itmperil
             WHERE policy_id = p_policy_id
               AND item_no   = i.item_no;
         END;
         
         FOR i IN (SELECT ri_comm_vat
                     FROM gipi_invoice
                    WHERE policy_id = P_policy_id)
         LOOP
            v_old_ri_comm_vat  	:= i.ri_comm_vat;
         END LOOP;
         
         FOR ii IN (SELECT SUM (NVL(a.ri_comm_amt,0)) ri_comm_amt_per_invoice
                      FROM gipi_invoice a
                     WHERE a.policy_id = p_policy_id)
         LOOP
            FOR iii IN (SELECT SUM (NVL(b.ri_comm_amt,0)) ri_comm_amt_per_item
                         FROM gipi_itmperil b
                        WHERE b.policy_id  = p_policy_id
                          AND b.item_no    = i.item_no)
            LOOP
   		      IF ii.ri_comm_amt_per_invoice = 0 THEN
    			      v_list.ri_comm_vat :=  0;
    		      ELSE
        	         v_list.ri_comm_vat :=  iii.ri_comm_amt_per_item * v_old_ri_comm_vat / ii.ri_comm_amt_per_invoice;
    		END IF;
    END LOOP;
         
         END LOOP;
      
         PIPE ROW(v_list);
      END LOOP;
   END get_items;
   
   FUNCTION get_perils (
      p_policy_id VARCHAR2,
      p_item_no   VARCHAR2   
   )
      RETURN peril_tab PIPELINED
   IS
      v_list peril_type;
   BEGIN
      FOR i IN (SELECT policy_id, line_cd, peril_cd, item_no,
                       rec_flag, tarf_cd, tsi_amt, prem_rt, ann_tsi_amt,
                       ann_prem_amt, discount_sw, as_charge_sw, prem_amt,
                       ri_comm_rate, ri_comm_amt
                  FROM gipi_itmperil
                 WHERE policy_id = p_policy_id
                   AND   item_no = p_item_no)
      LOOP
         v_list.policy_id := i.policy_id;
         v_list.line_cd := i.line_cd;
         v_list.peril_cd := i.peril_cd;
         v_list.item_no := i.item_no;
         v_list.rec_flag := i.rec_flag;
         v_list.tarf_cd := i.tarf_cd;
         v_list.tsi_amt := i.tsi_amt;
         v_list.prem_rt := i.prem_rt;
         v_list.ann_tsi_amt := i.ann_tsi_amt;
         v_list.ann_prem_amt := i.ann_prem_amt;
         v_list.discount_sw := i.discount_sw;
         v_list.as_charge_sw := i.as_charge_sw;
         v_list.prem_amt := i.prem_amt;
         v_list.ri_comm_rate := i.ri_comm_rate;
         v_list.ri_comm_amt := i.ri_comm_amt;
         
         BEGIN 
            SELECT peril_name
              INTO v_list.dsp_peril_name
              FROM giis_peril
             WHERE peril_cd = i.peril_cd
               AND line_cd = i.line_cd; 
         END;
         
         FOR x IN (SELECT ri_comm_rate, ri_comm_amt
                     FROM gipi_itmperil
                    WHERE policy_id = p_policy_id
                      AND item_no = p_item_no
                      AND peril_cd = i.peril_cd)
         LOOP
            v_list.old_ri_comm_rate := x.ri_comm_rate;
            v_list.ri_comm_rate := x.ri_comm_rate;
            v_list.old_ri_comm_amt := x.ri_comm_amt;
            v_list.ri_comm_amt := x.ri_comm_amt;
         END LOOP;
         
         FOR ii IN (SELECT ri_comm_vat
						    FROM gipi_invoice
					      WHERE policy_id = p_policy_id)
         LOOP
	         v_list.old_ri_comm_vat  	:= ii.ri_comm_vat;
--	         v_list.v490_old_ri_comm_vat := ii.ri_comm_vat;
         END LOOP;
         
         FOR ii IN (SELECT SUM (NVL(a.ri_comm_amt,0)) ri_comm_amt_per_invoice
                      FROM gipi_invoice a
                     WHERE a.policy_id = p_policy_id)
         LOOP 
               
            FOR iii IN (SELECT SUM (NVL(b.ri_comm_amt,0)) ri_comm_amt_per_item
                          FROM gipi_itmperil b
                         WHERE b.policy_id  = p_policy_id
                           AND b.item_no    = p_item_no)
            LOOP
            
               IF ii.ri_comm_amt_per_invoice = 0 THEN
                  v_list.ri_comm_vat := 0;
                  --variables.v_ri_comm_vat :=  0;
               ELSE
                  v_list.ri_comm_vat := iii.ri_comm_amt_per_item * v_list.old_ri_comm_vat / ii.ri_comm_amt_per_invoice;
                  --variables.v_ri_comm_vat :=  iii.ri_comm_amt_per_item * i.old_ri_comm_vat / ii.ri_comm_amt_per_invoice;
               END IF;
               
            END LOOP;
            
         END LOOP;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   PROCEDURE pre_commit (
      p_policy_id          IN       VARCHAR2,
      p_item_grp           IN       VARCHAR2,
      p_iss_cd             OUT      VARCHAR2,
      p_prem_seq_no        OUT      VARCHAR2,
      p_prem_amt           OUT      VARCHAR2,
      p_prev_ri_comm_amt   OUT      VARCHAR2,
      p_tax_amt            OUT      VARCHAR2
   )
   IS
   BEGIN
      
      BEGIN
		   SELECT iss_cd, 
			       prem_seq_no,
			       NVL(prem_amt,0), 
			       NVL(ri_comm_amt,0) 
		  	INTO p_iss_cd,
		  		  p_prem_seq_no,
		  	     p_prem_amt, 
		  	     p_prev_ri_comm_amt
		  	FROM gipi_invoice
		  WHERE policy_id = p_policy_id
		    AND item_grp  = p_item_grp;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invoice not found!');
		END;
      
  	   BEGIN
  		   FOR a IN ( SELECT a.iss_cd||'-'||a.prem_seq_no invoice_no,
 									SUM(a.tax_amt*b.currency_rt) tax_amt
   						 FROM gipi_inv_tax a,
   								gipi_invoice b,
									gipi_polbasic c
  							WHERE a.iss_cd 	  = b.iss_cd
    						  AND a.prem_seq_no = b.prem_seq_no
							  AND b.policy_id   = c.policy_id		
							  AND c.policy_id   = p_policy_id
							  AND b.item_grp    = p_item_grp
						GROUP BY a.iss_cd||'-'||a.prem_seq_no)
			LOOP
				p_tax_amt := a.tax_amt;
			END LOOP;
  	   END;
  
   END pre_commit;
   
   PROCEDURE pop_ri_comm_vat (
      p_policy_id       IN    VARCHAR2,
      p_sum_comm_amt      IN    VARCHAR2,
      p_ri_comm_vat       OUT   VARCHAR2,
      p_ri_comm_rate    IN    VARCHAR2,
      p_ri_comm_amt     IN    VARCHAR2,
      p_item_no         IN    VARCHAR2,
      p_peril_cd        IN    VARCHAR2,
      p_co_insurance_sw IN    VARCHAR2,
      p_item_grp        IN    VARCHAR2
   )
   IS
      v_rate 					giis_reinsurer.input_vat_rate%TYPE;
	   v_ri_comm_gipi	gipi_invoice.ri_comm_vat%TYPE;
   BEGIN
      BEGIN
         SELECT input_vat_rate
           INTO v_rate
           FROM giis_reinsurer
          WHERE ri_cd IN (SELECT ri_cd
                            FROM giri_inpolbas
                           WHERE policy_id = p_policy_id);
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#No record found.');
		END;
      
      IF p_sum_comm_amt IS NOT NULL THEN
			p_ri_comm_vat 	:= nvl((p_sum_comm_amt * (v_rate/100)),0);
		END IF;
      
      UPDATE gipi_itmperil
		   SET ri_comm_rate = p_ri_comm_rate,
		   		 ri_comm_amt  = p_ri_comm_amt
		 WHERE policy_id		= p_policy_id
		   AND item_no			= p_item_no
		   AND peril_cd			= p_peril_cd;
         
      IF p_co_insurance_sw = '2' THEN
         GIPIS175_PKG.update_orig_itmperl_inv_tables(p_policy_id, p_item_no, p_peril_cd, p_ri_comm_rate, p_item_grp);
      END IF;
      
   END pop_ri_comm_vat;
   
   PROCEDURE create_records_in_acctrans (
      p_fund_cd      IN VARCHAR2,
      p_branch_cd    IN VARCHAR2,
      p_tran_class   IN VARCHAR2,
      p_user_id      IN VARCHAR2,
      p_tran_flag    IN VARCHAR2,
      p_particulars  IN VARCHAR2,
      p_tran_id      OUT VARCHAR2
   )
   IS
      CURSOR c1 IS
         SELECT '1'
           FROM giis_funds
          WHERE fund_cd = p_fund_cd;
          
      CURSOR c2 IS
         SELECT '1'
           FROM giac_branches
          WHERE branch_cd = p_branch_cd
            AND gfun_fund_cd = p_fund_cd;
            
      v_c1              VARCHAR2(1);
      v_c2              VARCHAR2(1);
      v_year  	         NUMBER;
      v_month	         NUMBER;
      v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
      v_tran_class_no   giac_acctrans.tran_class_no%TYPE;    
          
   BEGIN
   
      OPEN c1;
      FETCH c1 INTO v_c1;  
         IF c1%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Invalid fund code.');
         ELSE
            OPEN c2;
            FETCH c2 INTO  v_c2;  
               IF c2%NOTFOUND THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Invalid branch code.');
               END IF;
            CLOSE c2;
         END IF;
      CLOSE c1;
     
      BEGIN
  	      SELECT acctran_tran_id_s.NEXTVAL
    	   INTO p_tran_id
         FROM dual;
      EXCEPTION
   	   WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#ACCTRAN_TRAN_ID sequence not found.');
      END;  
   
      v_year  := to_number(to_char(SYSDATE, 'YYYY'));
      v_month := to_number(to_char(SYSDATE, 'MM'));
      
      v_tran_seq_no := giac_sequence_generation(p_fund_cd, p_branch_cd, 'TRAN_SEQ_NO', v_year, v_month);
      
      v_tran_class_no := giac_sequence_generation(p_fund_cd, p_branch_cd, p_tran_class, v_year, 0);
      
      INSERT INTO giac_acctrans
         (tran_id,            gfun_fund_cd,           gibr_branch_cd, 
          tran_date,          tran_flag,              tran_year,
          tran_month,         tran_seq_no,            tran_class,                                           
          tran_class_no,      particulars,            user_id,          
          last_update)
      VALUES
         (p_tran_id,       p_fund_cd,     p_branch_cd,
          SYSDATE,         p_tran_flag,   v_year,      
          v_month,         v_tran_seq_no, p_tran_class,
          v_tran_class_no, p_particulars, p_user_id,              
          SYSDATE);
     
   END create_records_in_acctrans;
   
   PROCEDURE aeg_delete_acct_entries (
      p_tran_id      IN VARCHAR2,
      p_gen_type     IN VARCHAR2   
   )
   IS
      dummy  VARCHAR2(1);

      CURSOR ae is
         SELECT '1'
           FROM giac_acct_entries
          WHERE gacc_tran_id    = p_tran_id
            AND generation_type = p_gen_type;
   BEGIN
   
      OPEN ae;
      FETCH ae INTO dummy;
      IF SQL%FOUND THEN
         DELETE FROM giac_acct_entries
          WHERE gacc_tran_id    = p_tran_id
            AND generation_type = p_gen_type;
      END IF;
   END aeg_delete_acct_entries;
   
   PROCEDURE aeg_create_acct_entries (
      p_aeg_module_id          IN VARCHAR2,
      p_aeg_item_no            IN VARCHAR2,
      p_aeg_acct_amt           IN VARCHAR2,
      p_aeg_gen_type           IN VARCHAR2,
      p_aeg_line_cd            IN VARCHAR2,
      p_aeg_trty_type          IN VARCHAR2,
      p_aeg_acct_intm_cd       IN VARCHAR2,
      p_ri_cd                  IN VARCHAR2,
      p_branch_cd          IN   VARCHAR2,
      p_fund_cd            IN   VARCHAR2,
      p_tran_id            IN   VARCHAR2,
      p_user_id            IN VARCHAR2
   )
   IS
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
      ws_trty_type_level		    	   GIAC_MODULE_ENTRIES.ca_treaty_type_level%TYPE;
      ws_sl_type_cd					    	GIAC_MODULE_ENTRIES.sl_type_cd%TYPE; 
      ws_sl_cd					    			GIAC_ACCT_ENTRIES.sl_cd%TYPE;
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
           FROM giac_module_entries
          WHERE module_id = p_aeg_module_id
            AND item_no   = p_aeg_item_no
         FOR UPDATE of gl_sub_acct_1;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No data found in giac_module_entries: GIPIS175 - Update RI Commission (Inward).');
      END;
      
      IF ws_intm_type_level != 0 THEN

         ws_acct_intm_cd := p_aeg_acct_intm_cd;

         GIPIS175_PKG.aeg_check_level(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                                      ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                      ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;
      
      IF ws_line_dep_level != 0 THEN      
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = p_aeg_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
               --Msg_Alert('No data found in giis_line.','E',true);      
         END;
         
         GIPIS175_PKG.aeg_check_level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                                      ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                      ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;
      
      
      IF ws_trty_type_level != 0 THEN      
         GIPIS175_PKG.aeg_check_level(ws_trty_type_level, p_aeg_trty_type   , ws_gl_sub_acct_1,
                                      ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                      ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;
      
      GIPIS175_PKG.aeg_check_chart_of_accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                            ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                            ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                            ws_gl_acct_id);
                                            
      IF ws_sl_type_cd != 0 THEN
      ws_sl_cd := p_ri_cd;
      END IF;             
      
      IF ws_dr_cr_tag = 'D' THEN
         IF p_aeg_acct_amt > 0 THEN
            ws_debit_amt  := abs(p_aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt  := 0;
            ws_credit_amt := abs(p_aeg_acct_amt);
         END IF;
      ELSE
         IF p_aeg_acct_amt > 0 THEN
            ws_debit_amt  := 0;
            ws_credit_amt := abs(p_aeg_acct_amt);
         ELSE
            ws_debit_amt  := abs(p_aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;
      
      GIPIS175_PKG.aeg_insert_update_acct_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                                  p_aeg_gen_type       , ws_gl_acct_id     , ws_debit_amt    , 
                                                  ws_credit_amt,
                                                  ws_sl_type_cd, ws_sl_cd, p_branch_cd, p_fund_cd, p_tran_id,
                                                  p_user_id);
   
   END aeg_create_acct_entries;
   
   PROCEDURE aeg_check_level (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   )
   IS
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
   
   PROCEDURE aeg_check_chart_of_accts (
      p_cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      p_cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      p_cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      p_cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      p_cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      p_cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      p_cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      p_cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      p_cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      p_cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE
   )
   IS
   BEGIN
      SELECT DISTINCT(gl_acct_id)
        INTO p_cca_gl_acct_id
        FROM giac_chart_of_accts
       WHERE gl_acct_category  = p_cca_gl_acct_category
         AND gl_control_acct   = p_cca_gl_control_acct
         AND gl_sub_acct_1     = p_cca_gl_sub_acct_1
         AND gl_sub_acct_2     = p_cca_gl_sub_acct_2
         AND gl_sub_acct_3     = p_cca_gl_sub_acct_3
         AND gl_sub_acct_4     = p_cca_gl_sub_acct_4
         AND gl_sub_acct_5     = p_cca_gl_sub_acct_5
         AND gl_sub_acct_6     = p_cca_gl_sub_acct_6
         AND gl_sub_acct_7     = p_cca_gl_sub_acct_7;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#GL account code '||to_char(p_cca_gl_acct_category)
                 ||'-'||to_char(p_cca_gl_control_acct,'09') 
                 ||'-'||to_char(p_cca_gl_sub_acct_1,'09')
                 ||'-'||to_char(p_cca_gl_sub_acct_2,'09')
                 ||'-'||to_char(p_cca_gl_sub_acct_3,'09')
                 ||'-'||to_char(p_cca_gl_sub_acct_4,'09')
                 ||'-'||to_char(p_cca_gl_sub_acct_5,'09')
                 ||'-'||to_char(p_cca_gl_sub_acct_6,'09')
                 ||'-'||to_char(p_cca_gl_sub_acct_7,'09')
                 ||' does not exist in Chart of Accounts (Giac_Acctrans).');
   END aeg_check_chart_of_accts;
   
   PROCEDURE aeg_insert_update_acct_entries (
   iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
   iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
   iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
   iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
   iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
   iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
   iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
   iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
   iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
   iuae_generation_type    giac_acct_entries.generation_type%TYPE,
   iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
   iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
   iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
   iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
   iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
   p_branch_cd             VARCHAR2,
   p_fund_cd               VARCHAR2,
   p_tran_id               VARCHAR2,
   p_user_id               VARCHAR2
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_branch_cd
         AND gacc_gfun_fund_cd = p_fund_cd
         AND gacc_tran_id = p_tran_id
         AND gl_acct_id = iuae_gl_acct_id
         AND generation_type = iuae_generation_type;

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                      acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, sl_cd, sl_type_cd,
                      debit_amt, credit_amt, generation_type,
                      user_id, last_update
                     )
              VALUES (p_tran_id, p_fund_cd, p_branch_cd,
                      iuae_acct_entry_id, iuae_gl_acct_id,
                      iuae_gl_acct_category, iuae_gl_control_acct,
                      iuae_gl_sub_acct_1, iuae_gl_sub_acct_2,
                      iuae_gl_sub_acct_3, iuae_gl_sub_acct_4,
                      iuae_gl_sub_acct_5, iuae_gl_sub_acct_6,
                      iuae_gl_sub_acct_7, iuae_sl_cd, iuae_sl_type_cd,
                      iuae_debit_amt, iuae_credit_amt, iuae_generation_type,
                      p_user_id, SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE generation_type = iuae_generation_type
            AND gl_acct_id = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_branch_cd
            AND gacc_gfun_fund_cd = p_fund_cd
            AND gacc_tran_id = p_tran_id;
      END IF;
   END aeg_insert_update_acct_entries;
   
   PROCEDURE aeg_parameters_rev (
      aeg_tran_id          giac_acctrans.tran_id%TYPE,
      aeg_module_nm        giac_modules.module_name%TYPE,
      p_tran_id            VARCHAR2,
      p_line_cd            VARCHAR2,
      p_prem_amt           VARCHAR2,
      p_ri_cd              VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_fund_cd            VARCHAR2,
      p_tax_amt            VARCHAR2,
      p_prev_ri_comm_amt   VARCHAR2,
      p_old_ri_comm_vat    VARCHAR2,
      p_user_id            VARCHAR2
   )
   IS
      v_module_id    giac_modules.module_id%TYPE;
      v_gen_type     giac_modules.generation_type%TYPE;
   BEGIN
   
      BEGIN
         SELECT module_id,
                generation_type
           INTO v_module_id,
                v_gen_type
           FROM giac_modules
          WHERE module_name  = 'GIPIS175';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
      END;
      
      GIPIS175_PKG.aeg_delete_acct_entries(p_tran_id, v_gen_type);
      
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                           1, 
                           p_prem_amt * -1,
                           v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);
                           
--      RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#' || p_old_ri_comm_vat);                           
                           
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                           2, 
                           ((p_prem_amt + p_tax_amt)-(p_prev_ri_comm_amt + p_old_ri_comm_vat)) *-1,
                           v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);
                           
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                           3, 
                           p_prev_ri_comm_amt * -1,
                           v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);
                           
      IF NVL(GIACP.V('GEN_VAT_ON_RI'),'Y') = 'Y' THEN                                       
	   
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                              4, 
                              p_tax_amt * -1 ,
                              v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);                                               

	   GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                              5,
                              p_old_ri_comm_vat * -1 ,
                              v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);    
      END IF;                                                                                 
      
   END aeg_parameters_rev;
   
   PROCEDURE generate_icr_entry (
      p_iss_cd                 IN       VARCHAR2,
      p_prem_seq_no            IN       VARCHAR2,
      p_fund_cd                IN       VARCHAR2,
      p_branch_cd              IN       VARCHAR2,
      p_user_id                IN       VARCHAR2,
      p_tran_flag              IN       VARCHAR2,                          --,
      p_line_cd                IN       VARCHAR2,
      p_prem_amt               IN       VARCHAR2,
      p_ri_cd                  IN       VARCHAR2,
      p_tax_amt                IN       VARCHAR2,
      p_prev_ri_comm_amt       IN       VARCHAR2,
      p_old_ri_comm_vat        IN       VARCHAR2,
      p_rev_tran_id            OUT      VARCHAR2
   )
   IS
      v_tran_class  VARCHAR2(3);
      v_particulars giac_acctrans.particulars%TYPE;
      v_tran_id     giac_acctrans.tran_id%TYPE;
   BEGIN
      v_tran_class := 'ICR';
      v_particulars := 'REVERSAL ACCT ENTRIES FOR '||p_iss_cd||'-'||TO_CHAR(p_prem_seq_no);
      GIPIS175_PKG.create_records_in_acctrans(p_fund_cd, p_branch_cd, v_tran_class, p_user_id, p_tran_flag, v_particulars, v_tran_id);
      
      GIPIS175_PKG.aeg_parameters_rev(v_tran_id, 'GIPIS175',
      v_tran_id,
      p_line_cd,
      p_prem_amt,
      p_ri_cd,
      p_branch_cd,
      p_fund_cd, 
      p_tax_amt, 
      p_prev_ri_comm_amt,
      p_old_ri_comm_vat,
      p_user_id);
      
      p_rev_tran_id := v_tran_id;
      
   END generate_icr_entry;
   
   PROCEDURE post_commit(
      p_policy_id              IN       VARCHAR2,
      p_item_grp               IN       VARCHAR2,
      p_iss_cd                 IN       VARCHAR2,
      p_prem_seq_no            IN       VARCHAR2,
      p_branch_cd              IN       VARCHAR2,
      p_user_id                IN       VARCHAR2,
      p_line_cd                IN       VARCHAR2,
      p_ri_cd                  IN       VARCHAR2,
      p_prev_ri_comm_amt       IN       VARCHAR2,
      p_old_ri_comm_vat        IN       VARCHAR2, --removed comment by MarkS SR23053 9.13.2016
      p_rev_tran_id            OUT      VARCHAR2,
      p_sum_ri_comm_vat        IN       VARCHAR2,
      p_new_tran_id            OUT      VARCHAR2,
      p_sum_ri_comm_amt        IN       VARCHAR2,
      p_acct_ent_date          IN       VARCHAR2    
   )
   IS
      v_iss_cd       gipi_invoice.iss_cd%TYPE;
      v_prem_seq_no  gipi_invoice.prem_seq_no%TYPE;
      v_prem_amt     gipi_invoice.prem_amt%TYPE;
      v_tax_amt      NUMBER(16, 2);
      v_ri_comm_amt  NUMBER(16, 2);
      v_fund_cd      giac_acct_entries.gacc_gfun_fund_cd%TYPE := giacp.v('FUND_CD');
      v_tran_flag    giac_acctrans.tran_flag%TYPE := 'C';
      v_old_ri_comm_vat NUMBER;
   BEGIN
          
      BEGIN
         SELECT iss_cd, 
                prem_seq_no,
                NVL(prem_amt,0) 
           INTO v_iss_cd,
                v_prem_seq_no,
                v_prem_amt
           FROM gipi_invoice
          WHERE policy_id = p_policy_id
            AND item_grp  = p_item_grp;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invoice not found!');
      END;
            
      BEGIN
         FOR a IN (SELECT a.iss_cd||'-'||a.prem_seq_no invoice_no,
                          SUM(NVL(a.tax_amt,0) * b.currency_rt) tax_amt
                     FROM gipi_inv_tax a,
                          gipi_invoice b,
                          gipi_polbasic c
                    WHERE a.iss_cd (+) = b.iss_cd
                      AND a.prem_seq_no(+) = b.prem_seq_no
                      AND b.policy_id = c.policy_id		
                      AND c.policy_id = p_policy_id
                      AND b.item_grp = p_item_grp
                 GROUP BY a.iss_cd||'-'||a.prem_seq_no)
            LOOP
               v_tax_amt := a.tax_amt;
            END LOOP;
      END;
      
      FOR ii IN (SELECT ri_comm_vat
						 FROM gipi_invoice
					   WHERE policy_id = p_policy_id)
      LOOP
	      v_old_ri_comm_vat 	:= ii.ri_comm_vat;
      END LOOP;
      
      BEGIN
	      SELECT NVL(ri_comm_amt,0) 
		  	  INTO v_ri_comm_amt
		  	  FROM gipi_invoice
		 	 WHERE policy_id = p_policy_id
		   	AND item_grp  = p_item_grp;
	  EXCEPTION
	     WHEN NO_DATA_FOUND THEN
	        NULL;
	  END;
     
     GIPIS175_PKG.generate_icr_entry(p_iss_cd, p_prem_seq_no, v_fund_cd, p_branch_cd, p_user_id, v_tran_flag, p_line_cd, v_prem_amt, p_ri_cd, v_tax_amt, p_prev_ri_comm_amt, v_old_ri_comm_vat, p_rev_tran_id);
     GIPIS175_PKG.generate_ic_entry(p_line_cd, v_prem_amt, v_tax_amt, v_ri_comm_amt, p_sum_ri_comm_vat, p_ri_cd, p_branch_cd, v_fund_cd, p_user_id, v_tran_flag, p_iss_cd, p_prem_seq_no, p_new_tran_id);
     GIPIS175_PKG.insert_update_ri_comm_hist(p_rev_tran_id, p_new_tran_id, p_policy_id, p_user_id, p_sum_ri_comm_amt, p_prev_ri_comm_amt, p_acct_ent_date, p_sum_ri_comm_vat, p_old_ri_comm_vat); --edited by MarkS SR23053 9.13.2016
      
   END post_commit;
   
   PROCEDURE update_orig_itmperl_inv_tables (
      p_policy_id       IN VARCHAR2,
      p_item_no         IN VARCHAR2,
      p_peril_cd        IN VARCHAR2,
      p_ri_comm_rate    IN VARCHAR2,
      p_item_grp        IN VARCHAR2
   )
   IS
      v_ri_sum    gipi_invoice.ri_comm_amt%TYPE;
      v_prem_amt  gipi_invoice.prem_amt%TYPE;
      v_prem_amt1 gipi_invoice.prem_amt%TYPE;
      v_ri_amt    gipi_invoice.ri_comm_amt%TYPE;
      v_ri_amt1   gipi_invoice.ri_comm_amt%TYPE;
   BEGIN
   
--      RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#' || p_policy_id || ' - ' || p_item_no || ' - ' || p_peril_cd);
   
      SELECT prem_amt
 		  INTO v_prem_amt1
        FROM gipi_orig_itmperil
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND peril_cd = p_peril_cd;
         
      v_ri_amt1 :=  NVL(v_prem_amt1,0) * NVL(p_ri_comm_rate,0) / 100;
      
      UPDATE gipi_orig_itmperil
         SET ri_comm_amt = v_ri_amt1,
             ri_comm_rate = p_ri_comm_rate
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND peril_cd = p_peril_cd;
         
      SELECT sum(ri_comm_amt)
	     INTO v_ri_sum
	     FROM gipi_orig_itmperil
	    WHERE policy_id = p_policy_id
	      AND item_no IN (SELECT item_no
                           FROM gipi_item
                          WHERE item_grp = p_item_grp
                            AND policy_id = p_policy_id
                            AND item_no != p_item_no);
                            
      SELECT prem_amt
        INTO v_prem_amt
        FROM gipi_orig_invoice
       WHERE policy_id = p_policy_id
         AND item_grp = p_item_grp;
         
      v_ri_amt := nvl(v_prem_amt,0) * nvl(p_ri_comm_rate,0) / 100;
      
      UPDATE  gipi_orig_invoice
         SET  ri_comm_amt  = nvl(v_ri_sum,0) + nvl(v_ri_amt,0)
       WHERE  policy_id    = p_policy_id
         AND  item_grp     = p_item_grp;         
         
   END update_orig_itmperl_inv_tables;
   
   PROCEDURE update_giac_table (
      p_policy_id       IN VARCHAR2,
      p_prem_seq_no     IN VARCHAR2,
      p_iss_cd          IN VARCHAR2
   )
   IS
      v_policy_id            gipi_polbasic.policy_id%TYPE;
      v_prem_seq_no          gipi_invoice.prem_seq_no%TYPE;
      v_total_amount_due     giac_aging_soa_details.total_amount_due%TYPE;
      v_ri_cd                giri_inpolbas.ri_cd%TYPE;
      v_ri                   giis_parameters.param_value_v%TYPE;
      v_rb                   giis_parameters.param_value_v%TYPE;
      v_gif                  giis_parameters.param_value_v%TYPE;
      v_gr                   giis_parameters.param_value_v%TYPE;
      v_curr_rt              gipi_invoice.currency_rt%TYPE;
      v_curr_cd1             gipi_invoice.currency_cd%TYPE;
      v_curr_cd2             giac_parameters.param_value_n%TYPE;
      v_ri_comm              gipi_invoice.ri_comm_amt%TYPE;
      v_comm                 gipi_invoice.ri_comm_amt%TYPE;
      v_comm1                gipi_invoice.ri_comm_amt%TYPE;
      v_comm_amt				  gipi_invoice.ri_comm_amt%TYPE;
      v_comm_diff				  gipi_invoice.ri_comm_amt%TYPE;         
      v_sum_comm             gipi_invoice.ri_comm_amt%TYPE;
      v_comm_excess          gipi_invoice.ri_comm_amt%TYPE;
      v_comm_alloc           giac_parameters.param_value_v%TYPE;
      v_inst_no              NUMBER;
      v_prem                 gipi_invoice.prem_amt%TYPE;
      v_prem_amt             giac_aging_ri_soa_details.prem_balance_due%TYPE;
      v_tax_amt				  giac_aging_ri_soa_details.tax_amount%TYPE;
      v_no_of_payt           giis_payterm.no_of_payt%TYPE;
      v_rate                 giis_reinsurer.input_vat_rate%TYPE;
   BEGIN
     
      BEGIN
         FOR x IN (SELECT param_name, param_value_v
                     FROM  giis_parameters
                    WHERE  param_name IN ('RI', 'RB', 'ACCTG_FOR_FUND_CODE', 'ACCTG_ISS_CD_GR'))
         LOOP
            IF x.param_name = 'RI' THEN
               v_ri  := x.param_value_v;
            ELSIF x.param_name = 'RB' THEN
               v_rb  := x.param_value_v;
            ELSIF x.param_name = 'ACCTG_FOR_FUND_CODE' THEN
               v_gif := x.param_value_v;
            ELSIF x.param_name = 'ACCTG_ISS_CD_GR' THEN
               v_gr := x.param_value_v;
            END IF;
         END LOOP;
      
         IF v_ri IS  NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Parameter RI does not exist in giac parameters.');
         END IF;
         
         IF v_rb IS  NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Parameter RB does not exist in giac parameters.');
         END IF;
         
         IF v_gif IS  NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Parameter ACCTG_FOR_FUND_CODE does not exist in giac parameters.');
         END IF;
         
         IF v_gr IS  NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Parameter ACCTG_ISS_CD_GR does not exist in giac parameters.');
         END IF;
      END;
      
      BEGIN
         SELECT param_value_n
           INTO v_curr_cd2
           FROM giac_parameters
          WHERE param_type = 'N'
            AND UPPER(param_name) = 'CURRENCY_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Currency code not found on GIAC_PARAMETERS');
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Too many rows found on GIAC_PARAMETERS');
      END;
      
      BEGIN
         SELECT param_value_v
           INTO v_comm_alloc
           FROM giac_parameters
          WHERE param_type = 'V'
            AND UPPER(param_name) = 'RI_COMM_ALLOC';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#RI_COMM_ALLOC not found on GIAC_PARAMETERS');
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Too many rows found on GIAC_PARAMETERS');
      END;
      
      BEGIN
         
         FOR a IN (SELECT ri_cd
                     FROM giri_inpolbas
                    WHERE policy_id = p_policy_id)
         LOOP
            v_ri_cd := a.ri_cd;
            EXIT;
         END LOOP;
         
         BEGIN
            FOR x1 IN (SELECT  inst_no
                         FROM  giac_aging_ri_soa_details
             		      WHERE  prem_seq_no = p_prem_seq_no)
            LOOP
      	      v_inst_no := x1.inst_no;
               
               SELECT policy_id, 
                      NVL(ri_comm_amt,0) * NVL(currency_rt,1) commission,
                      NVL(currency_rt,1) curr_rt,
                      prem_amt * NVL(currency_rt,1) prem,
                      currency_cd 
     				  INTO v_policy_id, v_comm, v_curr_rt, v_prem, v_curr_cd1
     				  FROM gipi_invoice
    			    WHERE iss_cd      = p_iss_cd
      		      AND prem_seq_no = p_prem_seq_no;
                  
               SELECT  prem_balance_due, tax_amount
  	  		        INTO	 v_prem_amt, v_tax_amt
  	  		        FROM  giac_aging_ri_soa_details
  	 			    WHERE  prem_seq_no = p_prem_seq_no
  	 			      AND  inst_no = v_inst_no;     
                  
               SELECT  NVL(sum(NVL(comm_balance_due, 0)),0) comm_balance_due
                 INTO  v_sum_comm 
                 FROM  giac_aging_ri_soa_details
                WHERE  prem_seq_no = p_prem_seq_no;
                
               SELECT input_vat_rate
                 INTO v_rate
                 FROM giis_reinsurer
                WHERE ri_cd IN (SELECT ri_cd
                                  FROM giri_inpolbas
                                 WHERE policy_id = p_policy_id);
                                 
               IF p_iss_cd IN (v_ri, v_gr, v_rb) THEN

                  IF v_comm_alloc = 'F' THEN
                  
                     v_comm1 := (NVL(v_comm, 0)- v_sum_comm);
                     v_comm_excess := nvl(v_comm1,0) - (NVL(v_prem_amt,0));
                     
                     SELECT DECODE(SIGN(v_comm_excess),-1,v_comm1,
                            1,(v_comm1 - v_comm_excess),v_comm1)
                       INTO v_comm1
                       FROM DUAL;
                       
                     v_total_amount_due :=  NVL(v_prem_amt,0) + NVL(v_tax_amt,0)  - nvl(v_comm1,0)- (nvl(v_comm1,0) * (v_rate/100));
                  ELSE
                     SELECT a.no_of_payt
                       INTO v_no_of_payt
                       FROM giis_payterm a, gipi_invoice b
                      WHERE a.payt_terms = b.payt_terms
                        AND b.iss_cd = p_iss_cd
                        AND b.prem_seq_no = p_prem_seq_no;
                  
                     v_comm1 := NVL(v_comm,0) / NVL(v_no_of_payt,0);
                     v_comm_amt := NVL(v_comm1,0) * nvl(v_no_of_payt,0);
                     v_comm_diff := NVL(v_comm,0) - nvl(v_comm_amt,0);
                  
                     IF v_inst_no = 1 THEN
                        v_comm1 := nvl(v_comm1,0);
                     ELSIF v_inst_no = v_no_of_payt THEN
                        v_comm1 := nvl(v_comm1,0) + nvl(v_comm_diff,0);
                     ELSE
                        v_comm1 := nvl(v_comm1,0);
                     END IF;
                          				
                     v_total_amount_due := NVL(v_prem_amt,0)+ NVL(v_tax_amt,0)- NVL(v_comm1,0)- (nvl(v_comm1,0) * (v_rate/100));
                  END IF;
                  
               ELSE
                  v_total_amount_due := NVL(v_prem_amt,0) + NVL(v_tax_amt,0);
               END IF; 
               
               UPDATE giac_aging_ri_soa_details
                  SET total_amount_due = NVL (v_total_amount_due, 0),
                      comm_balance_due = NVL (v_comm1, 0),
                      balance_due = NVL (v_total_amount_due, 0),
                      comm_vat = NVL (v_comm1, 0) * (v_rate / 100)
                WHERE prem_seq_no = p_prem_seq_no
                  AND inst_no = v_inst_no;
               
            END LOOP;    
         END;
      END;
   END update_giac_table;
   
   PROCEDURE update_invperl (
      p_policy_id    IN VARCHAR2,
      p_iss_cd       IN VARCHAR2,
      p_prem_seq_no  IN VARCHAR2
   )
   IS
   BEGIN
      FOR x IN  (SELECT b.item_grp, a.peril_cd, AVG(NVL(a.ri_comm_rate,0))ri_comm_rate, SUM(NVL(a.ri_comm_amt,0)) ri_comm_amt
						 FROM  gipi_itmperil a, gipi_item b
		 			   WHERE  a.policy_id = p_policy_id
  		 				  AND  a.policy_id = b.policy_id
			 		     AND  a.item_no = b.item_no
					GROUP BY  b.policy_id, b.item_grp, a.peril_cd)
      LOOP
         UPDATE gipi_invperil
     	      SET ri_comm_amt  = x.ri_comm_amt,
                ri_comm_rt   = x.ri_comm_rate
   	    WHERE iss_cd       = p_iss_cd
     	      AND prem_seq_no  = p_prem_seq_no
     	      AND item_grp     = x.item_grp
     	      AND peril_cd     = x.peril_cd;
      END LOOP;
   END update_invperl;
   
   PROCEDURE update_orig_invperl (
      p_policy_id    IN VARCHAR2,
      p_iss_cd       IN VARCHAR2,
      p_prem_seq_no  IN VARCHAR2
   )
   IS
   BEGIN
      FOR x IN (SELECT  b.item_grp, a.peril_cd, AVG(NVL(a.ri_comm_rate,0)) ri_comm_rate, SUM(NVL(a.ri_comm_amt,0)) ri_comm_amt
                  FROM  gipi_orig_itmperil a, gipi_item b
                 WHERE  a.policy_id = p_policy_id
                   AND  a.policy_id = b.policy_id
                   AND  a.item_no = b.item_no
              GROUP BY  b.policy_id, b.item_grp, a.peril_cd)
      LOOP
              	
         UPDATE gipi_invperil
            SET ri_comm_amt  = x.ri_comm_amt,
                ri_comm_rt   = x.ri_comm_rate
          WHERE iss_cd       = p_iss_cd
            AND prem_seq_no  = p_prem_seq_no
            AND item_grp     = x.item_grp
            AND peril_cd     = x.peril_cd;
      END LOOP;
   END;
   
   PROCEDURE update_v490 (
      p_co_insurance_sw   IN   VARCHAR2,
      p_policy_id         IN   VARCHAR2,
      p_item_no           IN   VARCHAR2,
      --p_peril_cd          IN   VARCHAR2,
      --p_ri_comm_rate      IN   VARCHAR2,
      p_item_grp          IN   VARCHAR2,
      p_prem_seq_no       IN   VARCHAR2,
      p_iss_cd            IN   VARCHAR2
   )
   IS
      v_policy_id				GIPI_ITMPERIL_RI_COMM_HIST.POLICY_ID%TYPE;
      v_item_no				GIPI_ITMPERIL_RI_COMM_HIST.ITEM_NO%TYPE;
      v_peril_cd				GIPI_ITMPERIL_RI_COMM_HIST.PERIL_CD%TYPE;
      v_old_ri_comm_rate	GIPI_ITMPERIL_RI_COMM_HIST.OLD_RI_COMM_RATE%TYPE;
      v_old_ri_comm_amt		GIPI_ITMPERIL_RI_COMM_HIST.OLD_RI_COMM_AMT%TYPE;
      v_ri_comm_rate			GIPI_ITMPERIL_RI_COMM_HIST.NEW_RI_COMM_RATE%TYPE;
      v_ri_comm_amt			GIPI_ITMPERIL_RI_COMM_HIST.NEW_RI_COMM_AMT%TYPE;
   BEGIN
   
--      IF p_co_insurance_sw = '2' THEN
--		   GIPIS175_PKG.update_orig_itmperl_inv_tables(p_policy_id, p_item_no, p_peril_cd, p_ri_comm_rate, p_item_grp);
--	   END IF;
            
      GIPIS175_PKG.update_giac_table(p_policy_id, p_prem_seq_no, p_iss_cd);
      GIPIS175_PKG.update_invperl(p_policy_id, p_iss_cd, p_prem_seq_no);
      
      IF p_co_insurance_sw = '2' THEN
		   GIPIS175_PKG.update_orig_invperl(p_policy_id, p_iss_cd, p_prem_seq_no);
	   END IF;
   
   END;
   
   PROCEDURE insert_hist (
      p_policy_id          IN VARCHAR2,
      p_item_no            IN VARCHAR2,
      p_peril_cd           IN VARCHAR2,
      p_old_ri_comm_rate   IN VARCHAR2,
      p_old_ri_comm_amt    IN VARCHAR2,
      p_ri_comm_rate       IN VARCHAR2,
      p_ri_comm_amt        IN VARCHAR2,
      p_user_id            IN VARCHAR2,
      p_acct_ent_date      IN VARCHAR2
   )
   IS
      v_acct_ent_date VARCHAR2(100);
   BEGIN
   
      
   
      IF p_acct_ent_date IS NULL OR p_acct_ent_date = '' THEN
         v_acct_ent_date := NULL;
      ELSE
         v_acct_ent_date := p_acct_ent_date;
      END IF;
      
--      RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#' || v_acct_ent_date);
      
      IF v_acct_ent_date IS NULL THEN
      
         INSERT INTO gipi_itmperil_ri_comm_hist
               (policy_id,               item_no,                peril_cd, 
               old_ri_comm_rate,        old_ri_comm_amt,		    new_ri_comm_rate, 
               new_ri_comm_amt,         user_id,                create_date)
         VALUES
               (p_policy_id,         		p_item_no,          		p_peril_cd, 
               p_old_ri_comm_rate,  		p_old_ri_comm_amt,  		p_ri_comm_rate, 
               p_ri_comm_amt,       		p_user_id,              sysdate);
                 		 
      ELSE
      
         INSERT INTO gipi_itmperil_ri_comm_hist
               (policy_id,               item_no,                peril_cd, 
               old_ri_comm_rate,        old_ri_comm_amt,		    new_ri_comm_rate, 
               new_ri_comm_amt,         user_id,                create_date,
               acct_ent_date,           post_date,              tran_id_rev,
               tran_id)
         VALUES
               (p_policy_id,         		p_item_no,          		p_peril_cd, 
               p_old_ri_comm_rate,  		p_old_ri_comm_amt,  		p_ri_comm_rate, 
               p_ri_comm_amt,       		p_user_id,              SYSDATE,
               TO_DATE(v_acct_ent_date, 'MM-DD-YYYY'),     SYSDATE,                -1,
               -1); 
                   		 
      END IF;
      
   END insert_hist;
   
   PROCEDURE update_gipi_invoice (
      p_policy_id         IN       VARCHAR2,
      p_item_grp          IN       VARCHAR2,
      p_sum_ri_comm_vat   OUT      VARCHAR2,
      p_sum_ri_comm_amt   OUT      VARCHAR2
   )
   IS
   BEGIN
      FOR i IN (SELECT SUM (a.ri_comm_amt) ri_comm_amt,
		      		     SUM (a.ri_comm_amt * NVL (c.input_vat_rate, 0) / 100) ri_comm_vat
					   FROM gipi_itmperil a, giri_inpolbas b, giis_reinsurer c, gipi_item d
					  WHERE a.policy_id 	= b.policy_id
					    AND b.ri_cd 			= c.ri_cd
					    AND a.policy_id 	= d.policy_id
					    AND a.item_no 		= d.item_no
					    AND a.policy_id 	= p_policy_id
					    AND d.item_grp 	= p_item_grp)
		LOOP
         p_sum_ri_comm_vat := i.ri_comm_vat;
			p_sum_ri_comm_amt := i.ri_comm_amt;
			 
			 UPDATE gipi_invoice
			   SET ri_comm_vat = i.ri_comm_vat,
			   		 ri_comm_amt = i.ri_comm_amt
		 	 WHERE policy_id = p_policy_id
		   	 AND item_grp  = p_item_grp;
             
		END LOOP;
   END update_gipi_invoice;
   
   
   PROCEDURE aeg_parameters (
      p_line_cd         IN   VARCHAR2,
      p_prem_amt        IN   VARCHAR2,
      p_tax_amt         IN   VARCHAR2,
      p_ri_comm_amt     IN   VARCHAR2,
      p_sum_ri_comm_vat   IN   VARCHAR2,
      p_tran_id         IN   VARCHAR2,
      p_ri_cd           IN   VARCHAR2,
      p_branch_cd       IN   VARCHAR2,
      p_fund_cd         IN   VARCHAR2,
      p_user_id         IN   VARCHAR2
   )
   IS
      v_module_id giac_modules.module_id%TYPE;
      v_gen_type giac_modules.generation_type%TYPE;
   BEGIN
      BEGIN
         SELECT module_id,
                generation_type
           INTO v_module_id,
                v_gen_type
           FROM giac_modules
          WHERE module_name  = 'GIPIS175';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No data found in GIAC MODULES.');
      END;
      
      GIPIS175_PKG.aeg_delete_acct_entries(p_tran_id, v_gen_type);
      
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                           1, 
                           p_prem_amt,
                           v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);
                           
	   GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                           2, 
                           (p_prem_amt + p_tax_amt)-(p_ri_comm_amt + p_sum_ri_comm_vat),
                           v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);
                           
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                           3, 
                           p_ri_comm_amt,
                           v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);
                           
      IF NVL(GIACP.V('GEN_VAT_ON_RI'),'Y') = 'Y' THEN 
	      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                              4, 
                              p_tax_amt,
                              v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id); 
	
      GIPIS175_PKG.aeg_create_acct_entries (v_module_id,
                              5, 
                              p_sum_ri_comm_vat,
                              v_gen_type,
                           p_line_cd,
                           null,
                           null,
                           p_ri_cd,
                           p_branch_cd,
                           p_fund_cd,
                           p_tran_id,
                           p_user_id);                                                                                                                       
      END IF;  
                                                                                
      
   END aeg_parameters;
   
   PROCEDURE generate_ic_entry(
      p_line_cd           IN       VARCHAR2,
      p_prem_amt          IN       VARCHAR2,
      p_tax_amt           IN       VARCHAR2,
      p_ri_comm_amt       IN       VARCHAR2,
      p_sum_ri_comm_vat   IN       VARCHAR2,
      p_ri_cd             IN       VARCHAR2,
      p_branch_cd         IN       VARCHAR2,
      p_fund_cd           IN       VARCHAR2,
      p_user_id           IN       VARCHAR2,
      p_tran_flag         IN       VARCHAR2,
      p_iss_cd            IN       VARCHAR2,
      p_prem_seq_no       IN       VARCHAR2,
      p_tran_id           OUT      VARCHAR2
   )
   IS
      v_tran_class  VARCHAR2(3);
      v_particulars giac_acctrans.particulars%TYPE;
      v_tran_id     giac_acctrans.tran_id%TYPE;
   BEGIN
      v_tran_class := 'IC';  
      v_particulars := 'TAKE-UP OF CHANGES TO BILL '||p_iss_cd||'-'||to_char(p_prem_seq_no);
      
      GIPIS175_PKG.create_records_in_acctrans(p_fund_cd, p_branch_cd, v_tran_class, p_user_id, p_tran_flag, v_particulars, v_tran_id);
      
      GIPIS175_PKG.aeg_parameters(p_line_cd, p_prem_amt, p_tax_amt, p_ri_comm_amt, p_sum_ri_comm_vat, v_tran_id, p_ri_cd, p_branch_cd, p_fund_cd, p_user_id);
      
      p_tran_id := v_tran_id;
      
   END;
   
   PROCEDURE insert_update_ri_comm_hist (
      p_rev_tran_id        IN   VARCHAR2,
      p_new_tran_id        IN   VARCHAR2,
      p_policy_id          IN   VARCHAR2,
      p_user_id            IN   VARCHAR2,
      p_sum_ri_comm_amt    IN   VARCHAR2,
      p_prev_ri_comm_amt   IN   VARCHAR2,
      p_acct_ent_date      IN   VARCHAR2,
      p_sum_ri_comm_vat    IN   VARCHAR2,
      p_old_ri_comm_vat    IN   VARCHAR2
   )
   IS
   BEGIN
   
--      RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#' || p_prev_ri_comm_amt);
      
      UPDATE gipi_itmperil_ri_comm_hist
         SET tran_id_rev = p_rev_tran_id,
             tran_id     = p_new_tran_id     
       WHERE policy_id = p_policy_id
         AND tran_id = -1
         AND tran_id_rev = -1
         AND user_id = p_user_id;
         
      INSERT INTO giac_ri_comm_hist
             (policy_id, tran_id, tran_id_rev, new_ri_comm_amt,
              old_ri_comm_amt, acct_ent_date, post_date, user_id,
              new_ri_comm_vat, old_ri_comm_vat)
      VALUES (p_policy_id, p_new_tran_id, p_rev_tran_id, p_sum_ri_comm_amt,
              p_prev_ri_comm_amt, TO_DATE(p_acct_ent_date, 'mm-dd-yyyy'), SYSDATE, p_user_id,
              p_sum_ri_comm_vat, p_old_ri_comm_vat);
   END;
      
END;
/
