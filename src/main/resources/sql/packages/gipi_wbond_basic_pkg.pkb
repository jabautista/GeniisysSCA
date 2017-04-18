CREATE OR REPLACE PACKAGE BODY CPI.gipi_wbond_basic_pkg
AS
   FUNCTION get_gipi_wbond_basic (p_par_id gipi_wbond_basic.par_id%TYPE)
      RETURN gipi_wbond_basic_tab PIPELINED
   IS
      v_wbond   gipi_wbond_basic_type;
   BEGIN
      FOR i IN (SELECT a.par_id,        a.obligee_no,    a.bond_dtl,      a.indemnity_text,
                       a.clause_type,   a.waiver_limit,  a.contract_date, a.contract_dtl,
                       a.prin_id,       a.co_prin_sw,    a.np_no,         a.coll_flag,
                       a.plaintiff_dtl, a.defendant_dtl, a.civil_case_no
                  FROM gipi_wbond_basic a
                 WHERE a.par_id = p_par_id)
      LOOP
         BEGIN
            SELECT prin_signor, designation
              INTO v_wbond.prin_signor, v_wbond.designation
              FROM giis_prin_signtry
             WHERE prin_id = i.prin_id;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS THEN
               RAISE;
         END;

         BEGIN
            SELECT np_name
              INTO v_wbond.np_name
              FROM giis_notary_public
             WHERE np_no = i.np_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS THEN
               RAISE;
         END;

         BEGIN
            SELECT incept_date
              INTO v_wbond.contract_date
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS THEN
               RAISE;
         END;

         FOR j IN (SELECT *
                     FROM TABLE (gipi_parlist_pkg.get_gipi_parlist (p_par_id)))
         LOOP
            IF i.coll_flag = 'W'
            THEN
               BEGIN
                  SELECT waiver_limit
                    INTO v_wbond.waiver_limit
                    FROM giis_bond_class_subline
                   WHERE line_cd = j.line_cd
                     AND subline_cd = j.subline_cd
                     AND clause_type = i.clause_type;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     NULL;
               END;
            ELSE
               v_wbond.waiver_limit := 0.00;
            END IF;
         END LOOP;

         v_wbond.par_id         := i.par_id;
         v_wbond.obligee_no     := i.obligee_no;
         v_wbond.obligee_name   := giis_obligee_pkg.get_obligee_name (i.obligee_no);
         v_wbond.bond_dtl       := i.bond_dtl;
         v_wbond.indemnity_text := i.indemnity_text;
         v_wbond.clause_type    := i.clause_type;
         v_wbond.waiver_limit   := i.waiver_limit;
         v_wbond.contract_date  := i.contract_date;
         v_wbond.contract_dtl   := i.contract_dtl;
         v_wbond.prin_id        := i.prin_id;
--         v_wbond.prin_signor    := v_prin.prin_signor;
--         v_wbond.designation    := v_prin.designation;
         v_wbond.co_prin_sw     := i.co_prin_sw;
         v_wbond.np_no          := i.np_no;
         v_wbond.coll_flag      := i.coll_flag;
         v_wbond.plaintiff_dtl  := i.plaintiff_dtl;
         v_wbond.defendant_dtl  := i.defendant_dtl;
         v_wbond.civil_case_no  := i.civil_case_no;
         
         PIPE ROW (v_wbond);
      END LOOP;

      RETURN;
   END get_gipi_wbond_basic;

   PROCEDURE set_gipi_wbond_basic (
      p_par_id           IN   gipi_wbond_basic.par_id%TYPE,
      p_obligee_no       IN   gipi_wbond_basic.obligee_no%TYPE,
      p_bond_dtl         IN   gipi_wbond_basic.bond_dtl%TYPE,
      p_indemnity_text   IN   gipi_wbond_basic.indemnity_text%TYPE,
      p_clause_type      IN   gipi_wbond_basic.clause_type%TYPE,
      p_waiver_limit     IN   gipi_wbond_basic.waiver_limit%TYPE,
      p_contract_date    IN   gipi_wbond_basic.contract_date%TYPE,
      p_contract_dtl     IN   gipi_wbond_basic.contract_dtl%TYPE,
      p_prin_id          IN   gipi_wbond_basic.prin_id%TYPE,
      p_co_prin_sw       IN   gipi_wbond_basic.co_prin_sw%TYPE,
      p_np_no            IN   gipi_wbond_basic.np_no%TYPE,
      p_coll_flag        IN   gipi_wbond_basic.coll_flag%TYPE,
      p_plaintiff_dtl    IN   gipi_wbond_basic.plaintiff_dtl%TYPE,
      p_defendant_dtl    IN   gipi_wbond_basic.defendant_dtl%TYPE,
      p_civil_case_no    IN   gipi_wbond_basic.civil_case_no%TYPE,
      p_val_period       IN   gipi_wbond_basic.VAL_PERIOD%TYPE,
      p_val_period_unit  IN   gipi_wbond_basic.VAL_PERIOD_UNIT%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_wbond_basic
         USING DUAL
         ON (par_id = p_par_id)
         WHEN NOT MATCHED THEN
           INSERT (par_id,          obligee_no,         bond_dtl,        indemnity_text,
                   clause_type,     waiver_limit,       contract_date,   contract_dtl,
                   prin_id,         co_prin_sw,         np_no,           coll_flag,
                   plaintiff_dtl,   defendant_dtl,      civil_case_no,
                   val_period,      val_period_unit )       -- shan 10.13.2014
          VALUES ( p_par_id,        p_obligee_no,       p_bond_dtl,      p_indemnity_text,
                   p_clause_type,   p_waiver_limit,     p_contract_date, p_contract_dtl,
                   p_prin_id,       p_co_prin_sw,       p_np_no,         p_coll_flag,
                   p_plaintiff_dtl, p_defendant_dtl,    p_civil_case_no,
                   p_val_period,    p_val_period_unit )     -- shan 10.13.2014
         WHEN MATCHED THEN
           UPDATE SET obligee_no    = p_obligee_no,
                     bond_dtl       = p_bond_dtl,
                     indemnity_text = p_indemnity_text,
                     clause_type    = p_clause_type,    
                     waiver_limit   = p_waiver_limit,
                     contract_date  = p_contract_date,
                     contract_dtl   = p_contract_dtl,
                     prin_id        = p_prin_id,
                     co_prin_sw     = p_co_prin_sw,
                     np_no          = p_np_no,
                     coll_flag      = p_coll_flag,
                     plaintiff_dtl  = p_plaintiff_dtl,
                     defendant_dtl  = p_defendant_dtl,
                     civil_case_no  = p_civil_case_no,
                     val_period     = p_val_period,     -- shan 10.13.2014
                     val_period_unit = p_val_period_unit;   -- shan 10.13.2014
   END set_gipi_wbond_basic;

   PROCEDURE del_gipi_wbond_basic (p_par_id IN gipi_wbond_basic.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_wbond_basic
            WHERE par_id = p_par_id;
   END del_gipi_wbond_basic;

   FUNCTION get_bond_basic_new_record (p_par_id gipi_wbond_basic.par_id%TYPE)
      RETURN gipi_wbond_basic_tab PIPELINED
   IS
      v_bond   gipi_wbond_basic_type;
   BEGIN
      FOR par IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                         renew_no
                    FROM gipi_wpolbas
                   WHERE par_id = p_par_id)
      LOOP
         FOR b IN (SELECT   b.obligee_no ob_no, c.obligee_name ob_name,
                            b.clause_type ct, b.coll_flag, b.bond_dtl,
                            b.indemnity_text, b.contract_dtl, b.np_no,
                            b.plaintiff_dtl, b.defendant_dtl, b.civil_case_no
                       FROM gipi_polbasic a,
                            gipi_bond_basic b,
                            giis_obligee c
                      WHERE a.line_cd = par.line_cd
                        AND a.subline_cd = par.subline_cd
                        AND a.iss_cd = par.iss_cd
                        AND a.issue_yy = par.issue_yy
                        AND a.pol_seq_no = par.pol_seq_no
                        AND a.renew_no = par.renew_no
                        AND a.policy_id = b.policy_id
                        AND b.obligee_no = c.obligee_no
                        AND b.obligee_no IS NOT NULL
                   ORDER BY eff_date DESC)
         LOOP
            IF v_bond.par_id IS NULL THEN   
               v_bond.par_id := p_par_id;
               v_bond.coll_flag := b.coll_flag;
               v_bond.obligee_no := b.ob_no;
               v_bond.obligee_name := b.ob_name;               
               v_bond.bond_dtl := b.bond_dtl;
               v_bond.indemnity_text := b.indemnity_text;
               v_bond.contract_dtl := b.contract_dtl;
               v_bond.np_no := b.np_no;
               v_bond.plaintiff_dtl := b.plaintiff_dtl;
               v_bond.defendant_dtl := b.defendant_dtl;
               v_bond.civil_case_no := b.civil_case_no;

               BEGIN
                  IF b.coll_flag = 'W'
                  THEN
                     BEGIN
                        SELECT waiver_limit
                          INTO v_bond.waiver_limit
                          FROM giis_bond_class_subline
                         WHERE line_cd = par.line_cd
                           AND subline_cd = par.subline_cd
                           AND clause_type = b.ct;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           NULL;
                     END;
                  ELSE
                     v_bond.waiver_limit := 0.00;
                  END IF;
               END;
            END IF;
            v_bond.clause_type := b.ct;
         END LOOP;

         EXIT;
      END LOOP;

      PIPE ROW (v_bond);
   END get_bond_basic_new_record;
   
   -- shan 10.13.2014
   FUNCTION get_land_carrier_dtl(
        p_par_id        gipi_wc20_dtl.PAR_ID%type
    ) RETURN gipi_wc20_dtl_tab PIPELINED
    AS
        v_rec   gipi_wc20_dtl_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM gipi_wc20_dtl
                   WHERE par_id = p_par_id)
        LOOP
            v_rec.par_id        := i.par_id;
            v_rec.item_no       := i.item_no;  
            v_rec.plate_no      := i.plate_no;
            v_rec.motor_no      := i.motor_no;
            v_rec.make          := i.make;
            v_rec.psc_case_no   := i.psc_case_no;  
        
            PIPE ROW(v_rec);
        END LOOP;
    END get_land_carrier_dtl;
    
    
    PROCEDURE set_land_carrier_dtl (p_rec gipi_wc20_dtl%ROWTYPE)
    AS
    BEGIN
        MERGE INTO gipi_wc20_dtl
         USING DUAL
         ON (par_id = p_rec.par_id
             AND item_no = p_rec.item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, plate_no, motor_no, make, psc_case_no)
            VALUES (p_rec.par_id, p_rec.item_no, p_rec.plate_no, p_rec.motor_no, p_rec.make, p_rec.psc_case_no)
         WHEN MATCHED THEN
            UPDATE
               SET plate_no     = p_rec.plate_no,
                   motor_no     = p_rec.motor_no,
                   make         = p_rec.make,
                   psc_case_no  = p_rec.psc_case_no;
    END set_land_carrier_dtl;


    PROCEDURE del_land_carrier_dtl (
        p_par_id        gipi_wc20_dtl.PAR_ID%type,
        p_item_no       gipi_wc20_dtl.ITEM_NO%type
    )AS
    BEGIN
        DELETE FROM gipi_wc20_dtl
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
    END del_land_carrier_dtl;
   
   
    PROCEDURE val_add_land_carrier_dtl(
        p_par_id        gipi_wc20_dtl.PAR_ID%type,
        p_item_no       gipi_wc20_dtl.ITEM_NO%type
    )
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIPI_WC20_dtl a
                   WHERE a.par_id = p_par_id
                     AND a.item_no = p_item_no)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y'
        THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Record already exists with the same item_no.'
                                    );
        END IF;
    END val_add_land_carrier_dtl;
    
END gipi_wbond_basic_pkg;
/


