CREATE OR REPLACE PACKAGE BODY CPI.giexr106_pkg
AS

    FUNCTION get_details(p_extract_id           gixx_inw_tran.extract_id%TYPE
                        -- p_expiry_month         varchar2,
                        -- p_expiry_year          VARCHAR2
                        )
            RETURN get_details_tab PIPELINED
            IS
            details        get_details_type;
         BEGIN
             FOR i IN(SELECT a.ri_cd, a.extract_id, a.line_cd, a.policy_no, a.ri_policy_no,
                             a.orig_tsi_amt, a.our_tsi_amt, a.accept_date, a.expiry_date,
                             a.assd_no, c.assd_name, b.ri_name, b.mail_address1, b.mail_address2,
                             b.mail_address3,
                             ROUND (  (  (NVL (DECODE (a.our_tsi_amt, 0, 1, a.our_tsi_amt), 0))
                                       / NVL (a.orig_tsi_amt, 1)
                                      )
                                    * 100,
                                    9
                                   ) pct_accepted,
                                   TO_CHAR(a.expiry_date,'Month') expiry_month,TO_CHAR(a.expiry_date,'yyyy') expiry_year
                        FROM giis_reinsurer b, gixx_inw_tran a, giis_assured c
                       WHERE extract_id = p_extract_id
                         --AND TRIM(UPPER(TO_CHAR(a.expiry_date,'Month'))) = TRIM(UPPER(p_expiry_month))
                        -- AND TRIM(TO_CHAR(a.expiry_date,'yyyy')) = TRIM(p_expiry_year)
                         AND b.ri_cd = a.ri_cd
                         AND a.assd_no = c.assd_no
                         AND a.orig_tsi_amt > 0
                    ORDER BY a.line_cd, a.policy_no)
                LOOP
                    details.ri_cd           := i.ri_cd;
                    details.extract_id      := i.extract_id;
                    details.line_cd         := i.line_cd;
                    details.policy_no       := i.policy_no;
                    details.ri_policy_no    := i.ri_policy_no;
                    details.orig_tsi_amt    := i.orig_tsi_amt;
                    details.our_tsi_amt     := i.our_tsi_amt;
                    details.accept_date     := i.accept_date;
                    details.expiry_date     := i.expiry_date;
                    details.assd_no         := i.assd_no;
                    details.assd_name       := i.assd_name;
                    details.ri_name         := i.ri_name;
                    details.mail_address1   := i.mail_address1;
                    details.mail_address2   := i.mail_address2;
                    details.mail_address3   := i.mail_address3;
                    details.pct_accepted    := i.pct_accepted;
                    details.expiry_month    := i.expiry_month;
                    details.expiry_year     := i.expiry_year;
                      FOR c IN (SELECT param_value_v
                                  FROM giis_parameters
                                 WHERE param_name = 'COMPANY_NAME')
                      LOOP
                        details.company_name := c.param_value_v;
                      END LOOP;
                      
                      FOR ad IN(SELECT param_value_v
                                  FROM giis_parameters
                                 WHERE param_name = 'COMPANY_ADDRESS')
                      LOOP
                            details.company_address  := ad.param_value_v;
                      END LOOP;
                      
                       FOR a IN (SELECT line_name
                                   FROM giis_line
                                  WHERE line_cd = i.line_cd)
                       LOOP
                          details.line_name := a.line_name;
                       END LOOP;
                       
                       details.policy_id := cf_policy_idformula(i.policy_no);
                       
                       FOR q IN (SELECT ri_binder_no
                                   FROM giri_inpolbas
                                  --WHERE policy_id = cf_policy_idformula(i.policy_no))
                                  WHERE policy_id = details.policy_id)
                       LOOP
                          details.ri_binder_no := q.ri_binder_no;
                       END LOOP;
                       
                       IF i.line_cd = 'FI' THEN
                          details.location     := cf_locationformula(details.policy_id);
                       END IF;
                       IF i.line_cd = 'MN' THEN
                          details.destn        := cf_destnformula(details.policy_id);
                          details.vessel       := cf_vesselformula(details.policy_id);
                       END IF;
                       
                       details.incept_date  := cf_incept_dateformula(details.policy_id);
                       details.remarks      := cf_remarksformula(details.policy_id);
                       
                    PIPE ROW(details);
                    
                END LOOP;
             
         END;


    FUNCTION cf_policy_idformula (p_policy_no VARCHAR2)
       RETURN NUMBER
    IS
       v_policy_id   gipi_polbasic.policy_id%TYPE;
    BEGIN
       FOR a IN (
       SELECT policy_id
                   FROM gipi_polbasic
                  WHERE trim(   line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '099999999'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09'))
                        ) = trim(p_policy_no))
       LOOP
          v_policy_id := a.policy_id;
          EXIT;
       END LOOP;

       RETURN (v_policy_id);
    END;

    FUNCTION cf_loc_risk1formula(p_policy_id        gipi_polbasic.policy_id%TYPE)
       RETURN VARCHAR2
    IS
       v_loc_risk1   gipi_fireitem.loc_risk1%TYPE;
    BEGIN
          FOR c IN (SELECT loc_risk1,
                           SUBSTR (loc_risk1, LENGTH (loc_risk1)) comma,
                           SUBSTR (loc_risk1, 1, LENGTH (loc_risk1) - 1) FINAL
                      FROM gipi_fireitem
                     WHERE policy_id = p_policy_id)
          LOOP
             IF c.comma = ','
             THEN
                v_loc_risk1 := c.FINAL;
             ELSE
                v_loc_risk1 := c.loc_risk1;
             END IF;
          END LOOP;

       RETURN (v_loc_risk1);
    END;


    FUNCTION cf_loc_risk2formula(p_policy_id        gipi_polbasic.policy_id%TYPE)
       RETURN VARCHAR2
    IS
       v_loc_risk2   gipi_fireitem.loc_risk2%TYPE;
    BEGIN
          FOR c IN (SELECT loc_risk2,
                           SUBSTR (loc_risk2, LENGTH (loc_risk2)) comma,
                           SUBSTR (loc_risk2, 1, LENGTH (loc_risk2) - 1) FINAL
                      FROM gipi_fireitem
                     WHERE policy_id = p_policy_id)
          LOOP
             IF c.comma = ','
             THEN
                v_loc_risk2 := c.FINAL;
             ELSE
                v_loc_risk2 := c.loc_risk2;
             END IF;
          END LOOP;

       RETURN (v_loc_risk2);
    END;

    FUNCTION cf_loc_risk3formula(p_policy_id        gipi_polbasic.policy_id%TYPE)
       RETURN VARCHAR2
    IS
       v_loc_risk3   gipi_fireitem.loc_risk3%TYPE;
    BEGIN
          FOR c IN (SELECT loc_risk3,
                           SUBSTR (loc_risk3, LENGTH (loc_risk3)) comma,
                           SUBSTR (loc_risk3, 1, LENGTH (loc_risk3) - 1) FINAL
                      FROM gipi_fireitem
                     WHERE policy_id = p_policy_id)
          LOOP
             IF c.comma = ','
             THEN
                v_loc_risk3 := c.FINAL;
             ELSE
                v_loc_risk3 := c.loc_risk3;
             END IF;
          END LOOP;

       RETURN (v_loc_risk3);
    END;
    
   FUNCTION cf_locationformula(p_policy_id         gipi_polbasic.policy_id%TYPE)
   RETURN VARCHAR2
    IS
       v_location   VARCHAR2 (200);
   BEGIN
       SELECT    DECODE (cf_loc_risk1formula(p_policy_id), NULL, NULL, cf_loc_risk1formula(p_policy_id))
              || DECODE (cf_loc_risk2formula(p_policy_id), NULL, NULL, ',' || cf_loc_risk2formula(p_policy_id))
              || DECODE (cf_loc_risk3formula(p_policy_id), NULL, NULL, ',' || cf_loc_risk3formula(p_policy_id))
         INTO v_location
         FROM DUAL;

       RETURN (v_location);
   END;
    
   FUNCTION cf_destnformula(p_policy_id            gipi_polbasic.policy_id%TYPE)
       RETURN VARCHAR2
    IS
       v_destn   gipi_cargo.destn%TYPE;
    BEGIN
          FOR c IN (SELECT destn
                      FROM gipi_cargo
                     WHERE policy_id = p_policy_id)
          LOOP
             v_destn := c.destn;
          END LOOP;

       RETURN (v_destn);
    END;
    
    FUNCTION cf_vessel_cdformula(p_policy_id        gipi_polbasic.policy_id%TYPE)
    RETURN VARCHAR2
    IS
       v_vessel_cd   gipi_cargo.vessel_cd%TYPE;
    BEGIN
          FOR c IN (SELECT vessel_cd
                      FROM gipi_cargo
                     WHERE policy_id = p_policy_id)
          LOOP
             v_vessel_cd := c.vessel_cd;
          END LOOP;

       RETURN (v_vessel_cd);
    END;
    
    FUNCTION cf_vessel_nameformula(/*p_policy_id      gipi_polbasic.policy_id%TYPE*/ --benjo 10.26.2015 comment out
                                   p_vessel_cd      giis_vessel.vessel_cd%TYPE) --benjo 10.26.2015 GENQA-SR-5059
    RETURN VARCHAR2
    IS
       v_vessel_name   giis_vessel.vessel_name%TYPE;
    BEGIN
          FOR c IN (SELECT vessel_name
                      FROM giis_vessel
                     WHERE vessel_cd = /*p_policy_id*/p_vessel_cd) --benjo 10.26.2015 GENQA-SR-5059 replaced p_policy_id -> p_vessel_cd
          LOOP
             v_vessel_name := c.vessel_name;
          END LOOP;

       RETURN (v_vessel_name);
    END;
    
    FUNCTION cf_vesselformula(p_policy_id       gipi_polbasic.policy_id%TYPE)
    RETURN CHAR
    IS
       v_vessel   VARCHAR2 (60);
       v_vessel_cd  giis_vessel.vessel_cd%TYPE; --benjo 10.26.2015 GENQA-SR-5059
    BEGIN
       --v_vessel := cf_vessel_cdformula(p_policy_id) || '-' || cf_vessel_nameformula(p_policy_id); --benjo 10.26.2015 comment out
       v_vessel_cd := cf_vessel_cdformula(p_policy_id); --benjo 10.26.2015 GENQA-SR-5059
       v_vessel := v_vessel_cd || '-' || cf_vessel_nameformula(v_vessel_cd); --benjo 10.26.2015 GENQA-SR-5059
       
       RETURN (v_vessel);
    END;
    
    
    FUNCTION cf_incept_dateformula(p_policy_id  gipi_polbasic.policy_id%TYPE)
    RETURN DATE
    IS
       v_incept_date   gipi_polbasic.incept_date%TYPE;
    BEGIN
       FOR a IN (SELECT incept_date
                   FROM gipi_polbasic
                  WHERE policy_id = p_policy_id)
       LOOP
          v_incept_date := a.incept_date;
          EXIT;
       END LOOP;

       RETURN (v_incept_date);
    END;
    
    FUNCTION cf_remarksformula(p_policy_id   gipi_polbasic.policy_id%TYPE)
    RETURN CHAR
    IS
       v_remarks   giri_inpolbas.remarks%TYPE;
    BEGIN
       FOR a IN (SELECT remarks
                   FROM giri_inpolbas
                  WHERE policy_id = p_policy_id)
       LOOP
          v_remarks := a.remarks;
          EXIT;
       END LOOP;

       RETURN (v_remarks);
    END;


END giexr106_pkg;
/


