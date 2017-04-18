DROP PROCEDURE CPI.GET_FIXED_FLAG_LT;

CREATE OR REPLACE PROCEDURE CPI.get_fixed_flag_lt (
   p_par_id        IN       gipi_wpolbas.par_id%TYPE,
   p_subline_cd    OUT      gipi_wpolbas.subline_cd%TYPE,
   p_clause_type   OUT      gipi_wbond_basic.clause_type%TYPE,
   p_class_no      OUT      giis_bond_class_subline.class_no%TYPE,
   p_fixed_flag    OUT      giis_bond_class.fixed_flag%TYPE,
   p_prem_amt      IN OUT   gipi_wpolbas.prem_amt%TYPE,
   p_bond_rate     IN OUT   gipi_winvoice.bond_rate%TYPE,
   p_bond_amt      IN       gipi_wpolbas.prem_amt%TYPE,
   p_message       OUT      VARCHAR2,
   p_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
   p_issue_yy      IN       gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no    IN       gipi_polbasic.pol_seq_no%TYPE,
   p_renew_no      IN       gipi_polbasic.renew_no%TYPE,
   p_ann_prem_amt  OUT      gipi_wpolbas.ann_prem_amt%TYPE --added by robert GENQA 4825 08.19.15
)
IS
   v_line_cd    gipi_wpolbas.line_cd%TYPE;
   v_prem_amt   NUMBER;
   v_policy_id  gipi_polbasic.policy_id%TYPE;	-- marco - 05.21.2015 - GENQA SR 4456
   v_bond_rate  gipi_invoice.bond_rate%TYPE;	--
   v_prorate_flag       gipi_wpolbas.prorate_flag%TYPE; -- added by robert GENQA SR 4825 08.03.15
   v_ann_tsi_amt        gipi_wpolbas.ann_tsi_amt%TYPE;  -- added by robert GENQA SR 4825 08.12.15
   v_manual_cancel      VARCHAR2(1)    := 'N';			-- added by robert GENQA SR 4825 08.12.15
BEGIN
   BEGIN
      SELECT subline_cd, line_cd, prorate_flag, ann_tsi_amt -- added by robert GENQA SR 4825 08.03.15
        INTO p_subline_cd, v_line_cd, v_prorate_flag, v_ann_tsi_amt -- added by robert GENQA SR 4825 08.03.15
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   DBMS_OUTPUT.put_line ('subline: ' || p_subline_cd);
   
   -- marco - 05.21.2015 - GENQA SR 4456 - copied from UCPB version
   -- bonok :: 06.06.2014 :: retrieve the policy_id of the latest affecting endorsement or policy_id of the original policy 
   FOR i IN (SELECT policy_id 
               FROM gipi_polbasic
              WHERE subline_cd = p_subline_cd
                AND iss_cd = p_iss_cd
                AND issue_yy = p_issue_yy
                AND pol_seq_no = p_pol_seq_no
                AND renew_no = p_renew_no
                AND NVL(endt_type, 'x') = DECODE(endt_type, NULL, 'x', 'A')
              ORDER by endt_seq_no DESC)
   LOOP
      v_policy_id := i.policy_id;
      EXIT;
   END LOOP;
 
   -- bonok :: 06.06.2014 :: retrieves the bond_rate of the latest affecting endorsement or bond_rate of the original policy
   BEGIN
      SELECT bond_rate 
        INTO v_bond_rate
        FROM gipi_invoice 
       WHERE policy_id = v_policy_id;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
   END;
   -- added by robert GENQA SR 4825 08.12.15
   IF v_ann_tsi_amt + p_bond_amt = 0 THEN
      v_manual_cancel := 'Y';
   END IF;
   -- end robert GENQA SR 4825 08.12.15
   /*added by irwin 11.8.11
     get the latest clause_type*/
   FOR a IN (SELECT b.clause_type
               FROM gipi_bond_basic b, gipi_polbasic a
              WHERE a.line_cd = line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND a.policy_id = b.policy_id)
   LOOP
      p_clause_type := NVL (p_clause_type, a.clause_type);
   END LOOP;

   FOR clause IN (SELECT clause_type
                    FROM gipi_wbond_basic
                   WHERE par_id = p_par_id)
   LOOP
      p_clause_type := NVL (p_clause_type, clause.clause_type);
                                                       --bdarusin, july222003
   --variables.clause_type := clause.clause_type; --bdarusin, july222003
   END LOOP;

   /* BEGIN
       SELECT clause_type
         INTO p_clause_type
         FROM gipi_wbond_basic
        WHERE par_id = p_par_id;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          NULL;
    END;*/
   FOR c1_rec IN (SELECT class_no
                    FROM giis_bond_class_subline
                   WHERE line_cd = v_line_cd
                     AND subline_cd = p_subline_cd
                     AND clause_type = p_clause_type --) robert GENQA SR 4825 08.06.15
				   ORDER BY class_no) -- robert GENQA SR 4825 08.06.15
   LOOP
      p_class_no := c1_rec.class_no;
	  EXIT; -- added by robert GENQA SR 4825 08.06.15
   END LOOP;

   IF p_class_no IS NULL
   THEN
      p_message :=
               'This policy has no Bond Class yet. Please create Bond Class.';
      v_prem_amt := 0;
	  -- added by robert GENQA SR 4825 08.03.15
	  IF p_bond_rate != 0 THEN
            IF V_PRORATE_FLAG = 1 THEN
                SELECT p_bond_amt
                       * (p_bond_rate / 100)
                       * (  TRUNC (DECODE (par_type,'P', expiry_date, endt_expiry_date))
						   - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
						   + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
						  )
						/ check_duration (DECODE (par_type, 'P', incept_date, eff_date),
										  DECODE (par_type, 'P', expiry_date, endt_expiry_date)
										 ) 
                  INTO p_prem_amt
                  FROM gipi_wpolbas a, gipi_parlist b
			     WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
            ELSIF V_PRORATE_FLAG = 2 THEN
                p_prem_amt := p_bond_amt*p_bond_rate/100;
            ELSIF V_PRORATE_FLAG = 3 THEN
                SELECT p_bond_amt*(p_bond_rate/100)*(short_rt_percent/100)
                  INTO p_prem_amt
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id;
            END IF;
		ELSE 
			p_prem_amt := 0;   
      END IF;
	  -- end  robert GENQA SR 4825 08.03.15
   ELSE
      v_prem_amt := 0;

      BEGIN
         FOR c2_rec IN (SELECT fixed_flag
                          FROM giis_bond_class
                         WHERE class_no = p_class_no)
         LOOP
            p_fixed_flag := c2_rec.fixed_flag;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END IF;

   IF p_fixed_flag = 'A'
   THEN
      BEGIN
         FOR a IN (SELECT fixed_amt
                     FROM giis_bond_class
                    WHERE class_no = p_class_no)
         LOOP
            p_prem_amt := a.fixed_amt;
            EXIT;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      p_bond_rate := 0;
   ELSIF p_fixed_flag = 'R'
   THEN
   	  IF p_bond_rate = 0 THEN -- added condition by robert GENQA SR 4825 08.03.15
		  BEGIN
			 FOR e IN (SELECT fixed_rt
						 FROM giis_bond_class
						WHERE class_no = p_class_no)
			 LOOP
				p_bond_rate := e.fixed_rt;
				
				IF v_policy_id IS NOT NULL AND v_manual_cancel = 'Y' THEN --added condition by robert GENQA SR 4825 08.12.15 marco - 06.04.2015 - GENQA SR 4456 - added condition for PAR 
					p_bond_rate := v_bond_rate; -- bonok :: 06.16.2014 :: use the retrieved bond_rate from previous policies instead of the fixed_rt
				END IF;
				EXIT;
			 END LOOP;
		  END;
	   END IF; --end robert GENQA SR 4825 08.03.15

      p_prem_amt := p_bond_rate / 100 * p_bond_amt;

      IF p_bond_rate IS NULL
      THEN
         p_message := 'Bond Amount is beyond range in Bond Class';
      END IF;
   ELSIF p_fixed_flag = 'C'
   THEN
      DECLARE
         v_min_amt      giis_bond_class.min_amt%TYPE;
         v_fixed_amt    giis_bond_class.fixed_amt%TYPE;
         v_range_high   giis_bond_class_rt.range_high%TYPE;
         v_fixed_rt     giis_bond_class.fixed_rt%TYPE;
         v_switch       VARCHAR2 (1)                         := 'N';
      BEGIN
         BEGIN
		 	IF p_bond_rate = 0 THEN -- added condition by robert GENQA SR 4825 08.03.15
				FOR a IN (SELECT default_rt
							FROM giis_bond_class_rt
						   WHERE class_no = p_class_no
							 AND abs(p_bond_amt) BETWEEN range_low AND range_high) --adpascual - 03.06.2012 - added the abs function; applicable if p_bond_amt is negative
				LOOP
				   p_bond_rate := a.default_rt;
				   
				   IF v_policy_id IS NOT NULL AND v_manual_cancel = 'Y' THEN --added condition by robert GENQA SR 4825 08.12.15 marco - 06.04.2015 - GENQA SR 4456 - added condition for PAR
					   p_bond_rate := v_bond_rate; -- bonok :: 06.16.2014 :: use the retrieved bond_rate from previous policies instead of the default_rt
				   END IF;
				   
				   -- v_switch := 'Y'; removed by robert GENQA SR 4825 08.05.15
				   EXIT;
				END LOOP;
			 ELSE 
			    v_switch := 'Y'; --added by robert GENQA SR 4825 08.05.15
			 END IF; --end robert GENQA SR 4825 08.03.15

            --IF v_switch = 'N' removed by robert GENQA SR 4825 08.05.15
            --THEN removed by robert GENQA SR 4825 08.05.15
               FOR b IN (SELECT NVL (MAX (range_high), 0) range_high
                           FROM giis_bond_class_rt
                          WHERE class_no = p_class_no)
               LOOP
                  v_range_high := b.range_high;
                  EXIT;
               END LOOP;
            --END IF; removed by robert GENQA SR 4825 08.05.15
         END;

         IF p_bond_rate IS NOT NULL
         THEN
            p_prem_amt := p_bond_amt * NVL (p_bond_rate, 0) / 100;
         ELSE
            BEGIN
               FOR c IN (SELECT fixed_rt, fixed_amt, min_amt
                           FROM giis_bond_class
                          WHERE class_no = p_class_no)
               LOOP
                  p_bond_rate := c.fixed_rt;
                  v_fixed_amt := c.fixed_amt;
                  v_min_amt := c.min_amt;
                  EXIT;
               END LOOP;
            END;

			-- marco - 05.21.2015 - GENQA SR 4456 - copied from UCPB version
            -- bonok :: 06.16.2014 
            IF p_bond_rate = v_bond_rate THEN
                p_prem_amt :=
                     (  (NVL (p_bond_amt, 0) - NVL (v_range_high, 0))
                      * NVL (p_bond_rate, 0)
                      / 100
                     )
                   + NVL (v_fixed_amt, 0);
            ELSIF p_bond_rate != v_bond_rate THEN
               p_bond_rate := v_bond_rate;
               p_prem_amt := p_bond_amt * NVL (p_bond_rate, 0) / 100;
            END IF;
         END IF;

         IF abS(p_bond_amt) > v_range_high --adpascual - 03.06.2012 - added the abs function; applicable if p_bond_amt is negative
         THEN
            BEGIN
               FOR d IN (SELECT DECODE(v_switch, 'Y', p_bond_rate, fixed_rt) fixed_rt, fixed_amt, min_amt -- robert GENQA SR 4825 08.03.15
                           FROM giis_bond_class
                          WHERE class_no = p_class_no)
               LOOP
                  p_bond_rate := d.fixed_rt;
                  v_fixed_amt := d.fixed_amt;
                  v_min_amt := d.min_amt;
                  EXIT;
               END LOOP;
            END;
            
            -- marco - 05.21.2015 - GENQA SR 4456 - copied from UCPB version
            -- bonok :: 06.16.2014 
            --IF p_bond_rate = v_bond_rate THEN --removed by robert GENQA SR 4825 08.12.15
                p_prem_amt :=
                     (  (NVL (p_bond_amt, 0) - NVL (v_range_high, 0))
                      * NVL (p_bond_rate, 0)
                      / 100
                     )
                   + NVL (v_fixed_amt, 0);
            --ELSIF p_bond_rate != v_bond_rate THEN --removed by robert GENQA SR 4825 08.12.15
            --   p_bond_rate := v_bond_rate; --removed by robert GENQA SR 4825 08.12.15
            --   p_prem_amt := p_bond_amt * NVL (p_bond_rate, 0) / 100; --removed by robert GENQA SR 4825 08.12.15
            --END IF;  --removed by robert GENQA SR 4825 08.12.15
         END IF;
      END;
   END IF;
   
   p_bond_rate := NVL(p_bond_rate, 0);
   
  -- added by robert GENQA SR 4825 08.03.15
  IF p_fixed_flag IN ('C', 'R') THEN
	  IF v_prorate_flag = 1 THEN
		 SELECT p_prem_amt
				* (  TRUNC (DECODE (par_type,'P', expiry_date, endt_expiry_date))
				   - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
				   + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
				  )
				/ check_duration (DECODE (par_type, 'P', incept_date, eff_date),
								  DECODE (par_type, 'P', expiry_date, endt_expiry_date)
								 ) 
		   INTO p_prem_amt
		   FROM gipi_wpolbas a, gipi_parlist b
		  WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
	  ELSIF v_prorate_flag = 3
	  THEN
		 SELECT p_prem_amt * (short_rt_percent / 100)
		   INTO p_prem_amt
		   FROM gipi_wpolbas
		  WHERE par_id = p_par_id;
	  END IF;
   END IF;
   IF p_fixed_flag = 'A'
   THEN
      IF v_prorate_flag = 1
      THEN
         SELECT   p_prem_amt
                / (  TRUNC (DECODE (par_type,
                                    'P', expiry_date,
                                    endt_expiry_date
                                   )
                           )
                   - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
                   + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
                  )
                * check_duration (DECODE (par_type,
                                          'P', incept_date,
                                          eff_date
                                         ),
                                  DECODE (par_type,
                                          'P', expiry_date,
                                          endt_expiry_date
                                         )
                                 )
           INTO p_ann_prem_amt
           FROM gipi_wpolbas a, gipi_parlist b
          WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
      ELSIF v_prorate_flag = 2
      THEN
         SELECT   p_prem_amt
                * (  TRUNC (DECODE (par_type,
                                    'P', expiry_date,
                                    endt_expiry_date
                                   )
                           )
                   - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
                   + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
                  )
                / check_duration (DECODE (par_type,
                                          'P', incept_date,
                                          eff_date
                                         ),
                                  DECODE (par_type,
                                          'P', expiry_date,
                                          endt_expiry_date
                                         )
                                 )
           INTO p_ann_prem_amt
           FROM gipi_wpolbas a, gipi_parlist b
          WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
      ELSIF v_prorate_flag = 3
      THEN
         SELECT p_prem_amt / (short_rt_percent / 100)
           INTO p_ann_prem_amt
           FROM gipi_wpolbas
          WHERE par_id = p_par_id;
      END IF;
   ELSE
      p_ann_prem_amt := p_bond_amt * (p_bond_rate / 100);
   END IF;
   -- end robert GENQA SR 4825 08.03.15
END get_fixed_flag_lt;
/


