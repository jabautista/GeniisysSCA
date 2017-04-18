CREATE OR REPLACE PACKAGE BODY CPI.GIACR191P_PKG AS

    FUNCTION cf_company_nameformula
       RETURN VARCHAR2
    IS
       v_company_name   giis_parameters.param_name%TYPE;
    BEGIN
       SELECT param_value_v
       INTO v_company_name
       FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';
       
       RETURN (v_company_name);
       RETURN NULL;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          v_company_name := '(NO EXISTING COMPANY NAME IN GIIS_PARAMETERS)';
          RETURN (v_company_name);
       WHEN TOO_MANY_ROWS THEN
          v_company_name := '(TOO MANY VALUES FOR COMPANY NAME IN GIAC_PARAMETERS)';
          RETURN(v_company_name);   
    END;
    
    FUNCTION cf_company_addressformula
       RETURN VARCHAR2
    IS
       v_address   VARCHAR2 (500);
    BEGIN
       SELECT param_value_v
         INTO v_address
         FROM giis_parameters
        WHERE param_name = 'COMPANY_ADDRESS';

       RETURN (v_address);
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_address := '(NO EXISTING COMPANY ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_address);
       WHEN TOO_MANY_ROWS THEN
         v_address := '(TOO MANY VALUES FOR COMPANY ADDRESS IN GIAC_PARAMETERS)';
         RETURN(v_address);
    END;
    
    FUNCTION cf_soa_date_labelformula
       RETURN VARCHAR2
    IS
       v_date_label  giis_parameters.param_value_v%TYPE;-- VARCHAR2(100);	-- SR-4040 : shan 06.19.2015
    BEGIN
       SELECT param_value_v
         INTO v_date_label
         FROM giis_parameters
        WHERE param_name = 'SOA_DATE_LABEL';

      RETURN INITCAP(v_date_label);
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_date_label := '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
         RETURN(v_date_label);
       WHEN TOO_MANY_ROWS THEN
         v_date_label := '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
         RETURN(v_date_label);
    END;

    FUNCTION cf_dateformula (
        p_user      VARCHAR2
    ) RETURN VARCHAR2 IS
      v_date DATE;
    begin
      FOR i IN (SELECT param_date
                FROM giac_soa_rep_ext
                WHERE user_id = P_USER --USER
                AND ROWNUM =1)
      LOOP
        v_date := i.param_date;
        EXIT;
      END LOOP;
      
      IF v_date IS NULL THEN
        v_date := SYSDATE;
      END IF;
      RETURN TO_CHAR(v_date, 'fmMonth DD, RRRR');
    END;

    FUNCTION cf_titleformula RETURN VARCHAR2 IS
      v_title           giac_parameters.param_value_v%TYPE;-- VARCHAR2(100);	-- SR-4040 : shan 06.19.2015

    BEGIN
      SELECT param_value_v
      INTO v_title
      FROM giac_parameters
      WHERE param_name = 'SOA_TITLE';

      RETURN(v_title);

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN(v_title);
      
    END;

    FUNCTION cf_date_tagformula (
        p_user      VARCHAR2
    ) RETURN VARCHAR2 IS
       v_tag            VARCHAR2(5);
       v_name           VARCHAR2(100);
       v_from_date1     DATE; 
       v_to_date1       DATE;
       v_as_of_date     DATE;
       dsp_name         VARCHAR2(300);
    BEGIN
      SELECT date_tag, from_date1, to_date1, as_of_date
      INTO v_tag, v_from_date1, v_to_date1, v_as_of_date
      FROM giac_soa_rep_ext
      WHERE user_id = P_USER -- USER
      AND ROWNUM = 1;
      
      IF v_as_of_date IS NOT NULL THEN
        v_name := NULL;
      ELSIF v_tag = 'BK' THEN
        v_name := 'Booking Date from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
      ELSIF v_tag = 'IN' THEN
        v_name := 'Incept Date from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
      ELSIF v_tag = 'IS' THEN
        v_name := 'Issue Date from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
      ELSIF v_tag = 'BKIN' THEN
        v_name := 'Booking Date from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
      ELSIF v_tag = 'BKIS' THEN
        v_name := 'Booking Date from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
      ELSE
        dsp_name := '(Unknown Basis of Extraction)';
      END IF;

     RETURN (v_name); 
    END;
 
    FUNCTION cf_date_tag2formula (
        p_user      VARCHAR2
    ) RETURN VARCHAR2 IS
       v_tag            VARCHAR2(5);
       v_name           VARCHAR2(100);
       v_from_date2     DATE;
       v_to_date2       DATE;
       v_as_of_date     DATE;
       dsp_name         VARCHAR2(300);
    BEGIN
      SELECT date_tag, from_date2, to_date2, as_of_date
      INTO v_tag, v_from_date2, v_to_date2, v_as_of_date
      FROM giac_soa_rep_ext
      WHERE user_id = P_USER -- USER
      AND ROWNUM = 1;

      IF v_as_of_date IS NOT NULL THEN
        v_name := NULL;  
      ELSIF v_tag = 'BKIN' THEN
        v_name := 'Incept Date from '||TO_CHAR(v_from_date2,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date2,'fmMonth DD, YYYY');
      ELSIF v_tag = 'BKIS' THEN
        v_name := 'Issue Date from '||TO_CHAR(v_from_date2,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date2,'fmMonth DD, YYYY');
      ELSE
        dsp_name := '(Unknown Basis of Extraction)';
      END IF;

     RETURN (v_name); 
    END;
       
    FUNCTION cf_signatoryformula RETURN VARCHAR2 IS
      v_signatory   giis_signatory_names.SIGNATORY%TYPE;-- VARCHAR2(100);	-- SR-4040 : shan 06.19.2015
      
    BEGIN

      FOR I IN (SELECT signatory 
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR191P'
                 ORDER BY item_no)
      LOOP
       v_signatory := i.signatory;

      EXIT;
      END LOOP;

    RETURN(v_signatory);
      
    END;
    
    FUNCTION cf_designationformula RETURN VARCHAR2 IS
      v_designation   giis_signatory_names.DESIGNATION%TYPE;-- VARCHAR2(100);	-- SR-4040 : shan 06.19.2015

    BEGIN

      FOR I IN (SELECT designation 
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR191P'
                 ORDER BY item_no)
      LOOP
       v_designation := i.designation;

      EXIT;
      END LOOP;

    RETURN(v_designation);
      
    END;
    
    FUNCTION cf_sign_labelformula RETURN VARCHAR2 IS

    v_label   giac_rep_signatory.LABEL%TYPE;-- VARCHAR2(100);	-- SR-4040 : shan 06.19.2015

    BEGIN

      FOR I IN (SELECT label
                  FROM giac_rep_signatory 
                 WHERE report_id = 'GIACR191P'
                 ORDER BY item_no)
      LOOP
       v_label := i.label;

      EXIT;
      END LOOP;

    RETURN(v_label);
      
    END;
    FUNCTION populate_giacr191p(
        p_user      VARCHAR2
    ) RETURN giacr191p_tab PIPELINED
    AS
       v_rec   giacr191p_type;
    BEGIN
       v_rec.company_name    := cf_company_nameformula;
       v_rec.company_address := cf_company_addressformula;
       v_rec.soa_date_label  := cf_soa_date_labelformula;
       v_rec.cutoff_date     := cf_dateformula(p_user);
       v_rec.title           := cf_titleformula;
       v_rec.date_tag        := cf_date_tagformula(p_user);
       v_rec.date_tag2       := cf_date_tag2formula(p_user);
       v_rec.signatory       := cf_signatoryformula;
       v_rec.designation     := cf_designationformula;
       v_rec.sign_label      := cf_sign_labelformula;
       
       SELECT NVL(giacp.v('SOA_SIGNATORY'), 'N')
         INTO v_rec.print_signatory
         FROM DUAL;
         
       PIPE ROW (v_rec);
       RETURN;
       
    END populate_giacr191p;

    FUNCTION populate_giacr191p_details( 	-- SR-4040 : shan 06.19.2015
        p_branch_cd     VARCHAR2,
        p_assd_no       VARCHAR2,
        p_inc_overdue   VARCHAR2,
        p_intm_type     VARCHAR2,
        p_user          VARCHAR2
    )  RETURN giacr191p_details_tab PIPELINED
    AS
       v_rec             giacr191p_details_type;
    BEGIN
       FOR i IN (SELECT policy_no,   
                   a.branch_cd, 
                   UPPER(intm_name) intm_name,
                   intm_type,
                   assd_no,
                   ref_pol_no,
                   assd_name,
                   a.iss_cd||'-'||a.prem_seq_no||'-'||a.inst_no bill_no,
                   prem_bal_due,
                   tax_bal_due,
                   balance_amt_due,
                   aging_id,
                   no_of_days,
                   due_date,
                   column_no,
                   column_title,
                   'PDC'||' '||to_char(check_no)||' '||to_char(check_date,'MM-DD-YY')||' '||TO_CHAR(PDC_AMT,'999,999.90') remarks,
                   c.branch_name,
                   a.user_id,
                   due_tag
                FROM giac_soa_rep_ext a, giac_soa_pdc_ext b, giac_branches c
                WHERE balance_amt_due  != 0
                   AND a.iss_cd  = b.iss_cd(+)
                   AND a.prem_seq_no = b.prem_seq_no(+)
                   AND a.inst_no = b.inst_no(+)
                   AND a.branch_cd = c.branch_cd
                   AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)	-- start SR-4040 : shan 06.19.2015
                   AND assd_no = NVL(p_assd_no, assd_no)
                   AND due_tag = DECODE(P_INC_OVERDUE,'I',due_tag,'N','Y')
                   AND a.user_id = UPPER(p_user)
                   AND a.intm_type LIKE NVL (p_intm_type, '%')		-- end SR-4040 : shan 06.19.2015
                ORDER BY 2,UPPER(intm_name),1,4 ,a.inst_no)
             
       LOOP
            v_rec.policy_no       := i.policy_no;
            v_rec.branch_cd       := i.branch_cd;
            v_rec.intm_name       := i.intm_name;
            v_rec.intm_type       := i.intm_type;
            v_rec.assd_no         := i.assd_no;
            v_rec.ref_pol_no      := i.ref_pol_no;
            v_rec.assd_name       := i.assd_name;
            v_rec.bill_no         := i.bill_no;
            v_rec.prem_bal_due    := i.prem_bal_due;
            v_rec.tax_bal_due     := i.tax_bal_due;
            v_rec.balance_amt_due := i.balance_amt_due;
            v_rec.aging_id        := i.aging_id;
            v_rec.no_of_days      := i.no_of_days;
            v_rec.due_date        := i.due_date;
            v_rec.column_no       := i.column_no;
            v_rec.column_title    := i.column_title;
            v_rec.remarks         := i.remarks;
            v_rec.branch_name     := i.branch_name;
            v_rec.user_id         := i.user_id;
            v_rec.due_tag         := i.due_tag;
              
            PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;
    
    -- transfer from GIACR191_PKG -- shan 02.25.2015	-- SR-4040 : shan 06.19.2015
    FUNCTION get_report_apdc_details (
      p_branch_cd   giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no     giac_soa_rep_ext.assd_no%TYPE,
      p_user        giac_soa_rep_ext.user_id%TYPE,
      p_cut_off     VARCHAR2
   )
      RETURN apdc_details_tab PIPELINED
   AS
      rep   apdc_details_type;
   BEGIN
      FOR i IN (SELECT      d.apdc_pref
                         || '-'
                         || d.branch_cd
                         || '-'
                         || d.apdc_no apdc_number,
                         d.apdc_date, c.bank_cd, e.bank_sname, c.bank_branch,
                         c.check_no, c.check_date,
                            'PHP'
                         || ' '
                         || LTRIM (TO_CHAR (c.check_amt, '999,999,990.90'))
                                                                   check_amt,
                         b.iss_cd, b.prem_seq_no, b.inst_no,
                            b.iss_cd
                         || '-'
                         || b.prem_seq_no
                         || '-'
                         || b.inst_no bill_no,
                            'PHP'
                         || ' '
                         || LTRIM (TO_CHAR (b.collection_amt,
                                            '999,999,990.90')
                                  ) collection_amt,
                         a.intm_type, d.apdc_pref, d.branch_cd, d.apdc_no,
                         a.assd_no
                    FROM giac_soa_rep_ext a,
                         giac_pdc_prem_colln b,
                         giac_apdc_payt_dtl c,
                         giac_apdc_payt d,
                         giac_banks e
                   WHERE b.pdc_id = c.pdc_id
                     AND c.apdc_id = d.apdc_id
                     AND c.bank_cd = e.bank_cd
                     AND d.apdc_flag = 'P'
                     AND c.check_flag NOT IN ('C', 'R')
                     AND TRUNC (d.apdc_date) <=
                                             TO_DATE (p_cut_off, 'MM-DD-RRRR')
                     AND a.iss_cd = b.iss_cd
                     AND a.prem_seq_no = b.prem_seq_no
                     AND a.inst_no = b.inst_no
                     AND a.balance_amt_due <> 0
                     AND a.user_id = UPPER (p_user)
                     AND a.assd_no = NVL (p_assd_no, a.assd_no)
                     AND d.branch_cd = NVL (p_branch_cd, d.branch_cd)
                ORDER BY d.apdc_pref, d.branch_cd, d.apdc_no)
      LOOP
         rep.apdc_number := i.apdc_number;
         rep.apdc_date := TO_CHAR (i.apdc_date, 'MM-DD-RRRR');
         rep.bank_cd := i.bank_cd;
         rep.bank_sname := i.bank_sname;
         rep.bank_branch := i.bank_branch;
         rep.check_no := i.check_no;
         rep.check_date :=
                         TO_CHAR (i.check_date, 'MM-DD-RRRR');
         rep.check_amt := i.check_amt;
         rep.iss_cd := i.iss_cd;
         rep.prem_seq_no := i.prem_seq_no;
         rep.inst_no := i.inst_no;
         rep.bill_no := i.bill_no;
         rep.collection_amt := i.collection_amt;
         rep.intm_type := i.intm_type;
         rep.apdc_pref := i.apdc_pref;
         rep.branch_cd := i.branch_cd;
         rep.apdc_no := i.apdc_no;
         rep.assd_no := i.assd_no;
         PIPE ROW (rep);
      END LOOP;
   END get_report_apdc_details;

END GIACR191P_PKG; 