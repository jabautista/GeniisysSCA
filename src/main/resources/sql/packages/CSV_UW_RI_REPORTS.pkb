CREATE OR REPLACE PACKAGE BODY CPI.CSV_UW_RI_REPORTS
AS
    /** Created By:     Carlo De guzman
     ** Date Created:   02.10.2016
     ** Referenced By:  GIRIR036 - Outstanding Binders Report
     **/
     
    FUNCTION get_girir036(
        p_ri_cd         GIRI_BINDER.RI_CD%TYPE,
        p_line_cd       GIRI_BINDER.LINE_CD%TYPE,
        p_from_date     GIRI_BINDER.BINDER_DATE%TYPE,
        p_to_date       GIRI_BINDER.BINDER_DATE%TYPE
    ) RETURN get_girir036_tab PIPELINED
    AS
        rep     get_girir036_type;
    BEGIN       
        FOR i IN  ( SELECT DISTINCT  I.assd_name, A.ri_cd, A.fnl_binder_id, H.line_cd,
                           E.LINE_CD || '-' ||  E.SUBLINE_CD || '-' || E.ISS_CD || '-' || LTRIM(TO_CHAR(E.ISSUE_YY, '09')) || '-' || 
                                    LTRIM(TO_CHAR(E.POL_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(E.RENEW_NO, '09'))||DECODE(E.REG_POLICY_SW,'N',' **') POLICY_NO, 
                           E.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(E.ENDT_YY, '09')) || '-' || LTRIM(TO_CHAR(E.ENDT_SEQ_NO, '099999')) ENDT_NO, 
                           E.ENDT_SEQ_NO, 
                           A.line_cd || '-' || LTRIM(TO_CHAR(A.binder_yy, '09')) || '-'  || LTRIM(TO_CHAR(A.binder_seq_no, '09999')) BINDER_NUMBER, 
                           NVL(p_ri_cd, A.ri_cd) RI_CD2, 
                           NVL(p_line_cd, A.line_cd) LINE_CD2 , 
                           C.line_name LINE_NAME, B.ri_name RI_NAME, A.binder_date, A.fnl_binder_id fnl_binder_id2, 
                           B.mail_address1, B.mail_address2, B.mail_address3
                      FROM gipi_parlist D,
                           gipi_polbasic E,
                           giuw_pol_dist F, 
                           giri_frps_ri H,
                           giri_distfrps G,
                           giri_binder A, 
                           giis_assured I,
                           giis_reinsurer B,
                           giis_line C  
                     WHERE A.binder_date >= (SELECT MIN(binder_date) FROM giri_binder) 
                       AND A.binder_date >=NVL(p_from_date, A.binder_date)
                       AND A.binder_date <= p_to_date
                       AND A.ri_cd = B.ri_cd
                       AND A.line_cd = C.line_cd
                       AND A.reverse_date is null
                       AND (A.confirm_no is null OR A.confirm_date is null)
                       AND A.ri_cd = NVL( p_ri_cd, A.ri_cd)
                       AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                       AND D.par_id = E.par_id
                       AND I.assd_no = D.assd_no
                       AND E.policy_id = F.policy_id
                       AND F.dist_no = G.dist_no
                       AND G.line_cd = H.line_cd
                       AND G.frps_yy = H.frps_yy
                       AND G.frps_seq_no = H.frps_seq_no
                       AND A.fnl_binder_id = H.fnl_binder_id 
                       AND E.pol_flag IN ('1', '2', '3')
                       AND F.negate_date IS NULL
                       AND E.REG_POLICY_SW <> 'N'
                     ORDER BY A.RI_CD, C.LINE_NAME )
        LOOP
            rep.assd_name       := i.assd_name;
            rep.ri_name         := i.ri_name;
            rep.line_name       := i.line_name;
            rep.address         := i.mail_address1 || ' ' || i.mail_address2 || ' ' || i.mail_address3;
            rep.policy_endt_no  := i.policy_no;
            rep.binder_number   := i.binder_number;
        
            PIPE ROW(rep);
        END LOOP;
        
    END get_girir036;
    /** Created By:     Carlo De Guzman
    ** Date Created:   02.11.2016
    **/
    FUNCTION csv_girir101 (
      p_ri_cd            giri_inpolbas.ri_cd%TYPE,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_oar_print_date   VARCHAR2,
      p_morethan         NUMBER,
      p_lessthan         NUMBER,
      p_date_sw          VARCHAR2
   )
      RETURN get_girir101_tab_y PIPELINED
   AS
      rep   get_girir101_type_y;
   BEGIN
      FOR i IN
         (SELECT   e.oar_print_date, 1, e.accept_no,
                   (TRUNC (SYSDATE) - TRUNC (e.accept_date)) no_of_days,
                   e.ri_cd ri_cd, a.line_cd line_cd, c.line_name,
                   b.ri_name reinsurer, d.assd_name,
                   TO_NUMBER ('0.00') amount_offered,
                   a.tsi_amt our_acceptance, a.incept_date, a.expiry_date,
                   e.accept_date date_accepted
              FROM gipi_parhist g,
                   gipi_parlist f,
                   giis_assured d,
                   gipi_polbasic a,
                   giri_inpolbas e,
                   giis_reinsurer b,
                   giis_line c
             WHERE b.ri_cd = e.ri_cd
               AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
               AND a.line_cd = c.line_cd
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.policy_id = e.policy_id
               AND a.pol_flag IN ('1', '2', '3')
               AND a.assd_no = d.assd_no
               AND a.reg_policy_sw <> 'N'
               AND e.accept_date <= TRUNC (SYSDATE)
               AND e.ri_binder_no IS NULL
               AND (   (NVL (TRUNC (e.oar_print_date), TO_DATE('01-01-1990','MM-DD-YYYY')) =
                           NVL (TO_DATE (p_oar_print_date, 'MM-DD-RRRR'),
                                NVL (TRUNC (e.oar_print_date), TO_DATE('01-01-1990','MM-DD-YYYY'))
                               )
                       )
                    OR (p_date_sw = 1 AND e.oar_print_date IS NOT NULL)
                   )
               AND ((  NVL (TRUNC (TO_DATE (p_oar_print_date, 'MM-DD-RRRR')),
                            TRUNC (SYSDATE)
                           )
                     - TRUNC (e.accept_date)
                    ) BETWEEN TO_NUMBER (p_morethan) AND TO_NUMBER (p_lessthan)
                   )
               AND a.par_id = f.par_id
               AND a.line_cd = f.line_cd
               AND f.line_cd = c.line_cd
               AND f.assd_no = d.assd_no
               AND f.par_id = g.par_id
               AND f.iss_cd = (SELECT param_value_v
                                 FROM giis_parameters
                                WHERE param_name = 'ISS_CD_RI')
               AND g.parstat_cd = '1'
          UNION
          SELECT   e.oar_print_date, 2, e.accept_no,
                   (TRUNC (SYSDATE) - TRUNC (e.accept_date)) no_of_days,
                   e.ri_cd ri_cd, a.line_cd line_cd, c.line_name,
                   b.ri_name reinsurer, d.assd_name,
                   NVL (e.amount_offered, 0.00) amount_offered,
                   a.tsi_amt our_acceptance, a.incept_date, a.expiry_date,
                   e.accept_date date_accepted
              FROM gipi_parhist g,
                   gipi_parlist f,
                   giis_assured d,
                   gipi_wpolbas a,
                   giri_winpolbas e,
                   giis_reinsurer b,
                   giis_line c
             WHERE b.ri_cd = e.ri_cd
               AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
               AND a.line_cd = c.line_cd
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.par_id = e.par_id
               AND a.pol_flag IN ('1', '2', '3')
               AND a.assd_no = d.assd_no
               AND e.accept_date <= TRUNC (SYSDATE)
               AND e.ri_binder_no IS NULL
               AND a.reg_policy_sw <> 'N'
               AND (   (NVL (TRUNC (e.oar_print_date), TO_DATE('01-01-1990','MM-DD-YYYY')) =
                           NVL (TO_DATE (p_oar_print_date, 'MM-DD-RRRR'),
                                NVL (TRUNC (e.oar_print_date), TO_DATE('01-01-1990','MM-DD-YYYY'))
                               )
                       )
                    OR (p_date_sw = 1 AND e.oar_print_date IS NOT NULL)
                   )
               AND ((  NVL (TRUNC (TO_DATE (p_oar_print_date, 'MM-DD-RRRR')),
                            TRUNC (SYSDATE)
                           )
                     - TRUNC (e.accept_date)
                    ) BETWEEN TO_NUMBER (p_morethan) AND TO_NUMBER (p_lessthan)
                   )
               AND a.par_id = f.par_id
               AND a.line_cd = f.line_cd
               AND f.line_cd = c.line_cd
               AND f.assd_no = d.assd_no
               AND f.par_id = g.par_id
               AND f.iss_cd = (SELECT param_value_v
                                 FROM giis_parameters
                                WHERE param_name = 'ISS_CD_RI')
               AND g.parstat_cd = '1'
          UNION
          SELECT   e.oar_print_date, 3, e.accept_no,
                   (TRUNC (SYSDATE) - TRUNC (e.accept_date)) no_of_days,
                   e.ri_cd ri_cd, f.line_cd line_cd, c.line_name,
                   b.ri_name reinsurer, d.assd_name,
                   NVL (e.amount_offered, 0.00) amount_offered,
                   NULL our_acceptance, NULL, NULL,
                   e.accept_date date_accepted
              FROM gipi_parhist g,
                   gipi_parlist f,
                   giis_assured d,
                   giri_winpolbas e,
                   giis_reinsurer b,
                   giis_line c
             WHERE b.ri_cd = e.ri_cd
               AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
               AND f.line_cd = c.line_cd
               AND f.line_cd = NVL (p_line_cd, f.line_cd)
               AND f.assd_no = d.assd_no
               AND e.accept_date <= TRUNC (SYSDATE)
               AND e.ri_binder_no IS NULL
               AND (   (NVL (TRUNC (e.oar_print_date), TO_DATE('01-01-1990','MM-DD-YYYY')) =
                           NVL (TO_DATE (p_oar_print_date, 'MM-DD-RRRR'),
                                NVL (TRUNC (e.oar_print_date), TO_DATE('01-01-1990','MM-DD-YYYY'))
                               )
                       )
                    OR (p_date_sw = 1 AND e.oar_print_date IS NOT NULL)
                   )
               AND ((  NVL (TRUNC (TO_DATE (p_oar_print_date, 'MM-DD-RRRR')),
                            TRUNC (SYSDATE)
                           )
                     - TRUNC (e.accept_date)
                    ) BETWEEN TO_NUMBER (p_morethan) AND TO_NUMBER (p_lessthan)
                   )
               AND e.par_id = f.par_id
               AND f.par_id = g.par_id
               AND f.iss_cd = (SELECT param_value_v
                                 FROM giis_parameters
                                WHERE param_name = 'ISS_CD_RI')
               AND f.par_status = 2
               AND g.parstat_cd = '1'
               AND NOT EXISTS (SELECT c.par_id
                                 FROM gipi_wpolbas c
                                WHERE e.par_id = c.par_id)
          ORDER BY ri_cd)
      LOOP
         rep.cedant := i.reinsurer;
         rep.line := i.line_name;
         rep.original_assured := i.assd_name;
         rep.amount_offered :=
                              TO_CHAR (i.amount_offered, '99,999,999,999.99');
         rep.our_acceptance :=
                              TO_CHAR (i.our_acceptance, '99,999,999,999.99');
         rep.term_of_cover_from := TO_CHAR (i.incept_date, 'MM-DD-YYYY');
         rep.term_of_cover_to := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         rep.date_accepted := TO_CHAR (i.date_accepted, 'MM-DD-YYYY');
         IF GIISP.V('ORA2010_SW') = 'Y' THEN
             rep.no_of_days := i.no_of_days;
             rep.as_no := i.accept_no;
         END IF;
         PIPE ROW (rep);
      END LOOP;
   END csv_girir101;
END CSV_UW_RI_REPORTS;
/
