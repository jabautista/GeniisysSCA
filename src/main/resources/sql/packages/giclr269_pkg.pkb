CREATE OR REPLACE PACKAGE BODY CPI.GICLR269_PKG AS

    
    FUNCTION cf_comp_nameformula
       RETURN VARCHAR2
    IS
       --V_NAME VARCHAR2(200);
       v_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       SELECT param_value_v
         INTO v_name
         FROM giis_parameters
        WHERE param_name = 'COMPANY_NAME';

       RETURN (v_name);
       RETURN NULL;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
          RETURN (v_name);
       WHEN TOO_MANY_ROWS
       THEN
          v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
          RETURN (v_name);
    END;
    
    FUNCTION cf_comp_addformula
       RETURN CHARACTER
    IS
       --V_ADD VARCHAR2(350);
       v_add   giis_parameters.param_value_v%TYPE;
    BEGIN
       SELECT param_value_v
         INTO v_add
         FROM giis_parameters
        WHERE param_name = 'COMPANY_ADDRESS';

       RETURN (v_add);
       RETURN NULL;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
          RETURN (v_add);
       WHEN TOO_MANY_ROWS
       THEN
          v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
          RETURN (v_add);
    END;


    FUNCTION cf_datetype (
      P_FROM_DATE       DATE,
      P_TO_DATE         DATE,
      P_AS_OF_DATE      DATE,
      P_FROM_LDATE      DATE,
      P_TO_LDATE        DATE,
      P_AS_OF_LDATE     DATE
    )
       RETURN CHAR
    IS
    BEGIN
       IF p_as_of_date IS NOT NULL
       THEN
          RETURN (   'Claim File Date As of '
                  || TO_CHAR (p_as_of_date, 'fmMonth DD, RRRR')
                 );
       ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
       THEN
          RETURN (   'Claim File Date From '
                  || TO_CHAR (p_from_date, 'fmMonth DD, RRRR')
                  || ' To '
                  || TO_CHAR (p_to_date, 'fmMonth DD, RRRR')
                 );
       ELSIF p_as_of_ldate IS NOT NULL
       THEN
          RETURN (   'Loss Date As of '
                  || TO_CHAR (p_as_of_ldate, 'fmMonth DD, RRRR')
                 );
       ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL
       THEN
          RETURN (   'Loss Date From '
                  || TO_CHAR (p_from_ldate, 'fmMonth DD, RRRR')
                  || ' To '
                  || TO_CHAR (p_to_ldate, 'fmMonth DD, RRRR')
                 );
       ELSE 
       RETURN NULL;
       END IF;
    END;

    FUNCTION populate_giclr269 (
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_FROM_LDATE      VARCHAR2,
      P_TO_LDATE        VARCHAR2,
      P_AS_OF_LDATE     VARCHAR2
    )
       RETURN giclr269_tab PIPELINED
    AS
       v_rec   giclr269_type;
    BEGIN
       v_rec.company_name := cf_comp_nameformula;
       v_rec.company_address := cf_comp_addformula;
       v_rec.date_type := cf_datetype (TO_DATE(p_from_date, 'MM-DD-YYYY'), 
                                       TO_DATE(p_to_date, 'MM-DD-YYYY'), 
                                       TO_DATE(p_as_of_date, 'MM-DD-YYYY'), 
                                       TO_DATE(p_from_ldate, 'MM-DD-YYYY'), 
                                       TO_DATE(p_to_ldate, 'MM-DD-YYYY'),
                                        TO_DATE(p_as_of_ldate, 'MM-DD-YYYY')
                                       );
       PIPE ROW (v_rec);
       RETURN;
    END populate_giclr269;

    FUNCTION populate_giclr269_details (
       p_status        VARCHAR2,
       p_from_date     VARCHAR2,
       p_to_date       VARCHAR2,
       p_as_of_date    VARCHAR2,
       p_from_ldate    VARCHAR2,
       p_to_ldate      VARCHAR2,
       p_as_of_ldate   VARCHAR2,
       p_user_id       VARCHAR2
    )
       RETURN giclr269_details_tab PIPELINED
    IS
       v_rec         giclr269_details_type;
       v_list_bulk   giclr269_details_tab;
       v_where       VARCHAR2(20000);
       v_cancel_tag  VARCHAR2(2000);
       
       BEGIN

              IF p_status = 'A' OR p_status IS NULL THEN
                   v_where := ' AND a.claim_id = b.claim_id ';
                ELSIF p_status = 'P' THEN
                   v_where := ' AND cancel_tag IS NULL '||
                        'AND a.claim_id = b.claim_id ';          
               ELSE
                   v_where := ' AND cancel_tag = ''' || p_status ||
                        ''' AND a.claim_id = b.claim_id ';
                END IF;

       EXECUTE IMMEDIATE 'SELECT a.line_cd
                               || ''-''
                               || a.subline_cd
                               || ''-''
                               || a.iss_cd
                               || ''-''
                               || TRIM (TO_CHAR (a.clm_yy, ''09''))
                               || ''-''
                               || TRIM (TO_CHAR (a.clm_seq_no, ''0000009'')) claim_no,
                                  a.line_cd
                               || ''-''
                               || a.subline_cd
                               || ''-''
                               || a.pol_iss_cd
                               || ''-''
                               || TRIM (TO_CHAR (a.issue_yy, ''09''))
                               || ''-''
                               || TRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                               || ''-''
                               || LTRIM (TO_CHAR (a.renew_no, ''09'')) pol_no,
                               a.dsp_loss_date, a.assured_name,
                                  b.line_cd
                               || ''-''
                               || b.iss_cd
                               || ''-''
                               || SUBSTR (TO_CHAR (b.rec_year), 3, 2)
                               || ''-''
                               || TRIM (TO_CHAR (b.rec_seq_no, ''009'')) rec_no,
                               b.cancel_tag, b.rec_type_cd, b.recoverable_amt, b.recovered_amt,
                               b.lawyer_cd,                               
                               a.clm_file_date, a.loss_date, b.claim_id, b.recovery_id 
                          FROM gicl_claims a, gicl_clm_recovery b
                         WHERE  check_user_per_line2 (a.line_cd, a.iss_cd, ''GICLS269'', '''|| p_user_id ||''') = 1
                           AND (   (       TRUNC (a.clm_file_date) >= TO_DATE(''' || p_from_date || ''', ''MM-DD-YYYY'')
                                       AND TRUNC (a.clm_file_date) <= TO_DATE(''' || p_to_date || ''', ''MM-DD-YYYY'')
                                    OR TRUNC (a.clm_file_date) <= TO_DATE(''' || p_as_of_date || ''', ''MM-DD-YYYY'')
                                   )
                                OR (       TRUNC (a.loss_date) >= TO_DATE(''' || p_from_ldate || ''', ''MM-DD-YYYY'')
                                       AND TRUNC (a.loss_date) <= TO_DATE(''' || p_to_ldate || ''', ''MM-DD-YYYY'')
                                    OR TRUNC (a.loss_date) <= TO_DATE(''' || p_as_of_ldate || ''', ''MM-DD-YYYY'')
                                   )
                               ) 
                                '
                                || v_where                        

       BULK COLLECT INTO v_list_bulk;

       IF v_list_bulk.LAST > 0
       THEN
          FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
          LOOP       
          
             v_rec.claim_no := v_list_bulk (i).claim_no;
             v_rec.pol_no := v_list_bulk (i).pol_no;
             v_rec.dsp_loss_date := v_list_bulk (i).dsp_loss_date;
             v_rec.assured_name := v_list_bulk (i).assured_name;
             v_rec.rec_no := v_list_bulk (i).rec_no;
              
             IF 
                  UPPER(v_list_bulk (i).cancel_tag) = 'CD' THEN
                     v_cancel_tag :=  'CLOSED';
                  ELSIF UPPER(v_list_bulk (i).cancel_tag) = 'CC' THEN
                     v_cancel_tag := 'CANCELLED';
                  ELSIF UPPER(v_list_bulk (i).cancel_tag) = 'WO' THEN
                     v_cancel_tag := 'WRITTEN OFF';
                  ELSE
                    v_cancel_tag := 'IN PROGRESS';
                  
              END IF;

             v_rec.cancel_tag := v_cancel_tag;
             v_rec.rec_type_cd := giclr269_pkg.CF_rec_type_descFormula(v_list_bulk (i).rec_type_cd);
             v_rec.recoverable_amt := v_list_bulk (i).recoverable_amt;
             v_rec.recovered_amt := v_list_bulk (i).recovered_amt;
             v_rec.lawyer_cd := v_list_bulk (i).lawyer_cd;
             v_rec.clm_file_date := v_list_bulk (i).clm_file_date;
             v_rec.loss_date := v_list_bulk (i).loss_date;
             v_rec.claim_id := v_list_bulk (i).claim_id;
             v_rec.recovery_id := v_list_bulk (i).recovery_id;
             
             PIPE ROW (v_rec);
          END LOOP;
       END IF;

       RETURN;
    END;

    FUNCTION cf_rec_type_descformula (
       p_rec_type_cd   giis_recovery_type.rec_type_cd%TYPE
    )
       RETURN CHAR
    IS
    BEGIN
       FOR rec IN (SELECT rec_type_desc
                     FROM giis_recovery_type
                    WHERE rec_type_cd = p_rec_type_cd)
       LOOP
          RETURN rec.rec_type_desc;
       END LOOP;
    END;

    FUNCTION cf_payorformula(
        p_claim_id           gicl_recovery_payor.claim_id%TYPE,
        p_recovery_id        gicl_recovery_payor.recovery_id%TYPE          
    )
       RETURN payor_tab PIPELINED
    IS
        v_rec                   payor_type;
    BEGIN
       FOR rec IN (SELECT    payee_last_name
                          || DECODE (payee_first_name, NULL, '', ', ')
                          || payee_first_name
                          || DECODE (payee_middle_name, NULL, '', ' ')
                          || payee_middle_name pname,
                          b.recovered_amt
                     FROM giis_payees a, gicl_recovery_payor b
                    WHERE a.payee_no = b.payor_cd
                      AND a.payee_class_cd = b.payor_class_cd
                      AND b.claim_id = p_claim_id
                      AND b.recovery_id = p_recovery_id
                      )
       LOOP
          v_rec.payor_name := rec.pname;
          v_rec.recovered_amt := rec.recovered_amt;
          PIPE ROW(v_rec);
       END LOOP;
    END;

END GICLR269_PKG;
/


