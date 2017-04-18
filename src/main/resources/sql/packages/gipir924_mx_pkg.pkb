CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924_MX_PKG
AS
   /*
   **  Created by   :  Christian Santos
   **  Date Created : 01.18.2013
   **  Reference By : GIPIR924_MX
   */
      
   FUNCTION populate_gipir924_mx(
    p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    p_iss_cd       GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    p_scope        GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
    p_line_cd      GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
    p_subline_cd   GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
    p_assd_no      GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
    p_intm_no      GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE,
    p_user_id      GIPI_UWREPORTS_EXT.user_id%TYPE  
    )
      RETURN report_tab PIPELINED
    AS
      rep              report_type;
      v_param_date     NUMBER (1);
      v_from_date      DATE;
      v_to_date        DATE;
      heading3         VARCHAR2 (150);

      v_based_on       VARCHAR2 (100);
      v_scope          NUMBER (1);
      v_policy_label   VARCHAR2 (300);
      
    BEGIN  
        FOR I IN 
            (SELECT a.line_cd, 
                    a.subline_cd,                                               
                    DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd,                                                 
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,NVL(a.total_tsi,0),0)) total_tsi, 
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,NVL(a.total_prem,0),0)) total_prem,
                    SUM(NVL(DECODE(spld_date,NULL,a.other_charges),0)) other_charges,
                    SUM(NVL(DECODE(spld_date,NULL,a.total_prem),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax1),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax2),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax3),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax4),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax5),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax6),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax7),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax8),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax9),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax10),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax11),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax12),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax13),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax14),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax15),0))+ 
                    SUM(NVL(DECODE(spld_date,NULL,a.other_charges),0)) total,
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,1,0)) pol_count,
                    SUM(NVL(DECODE(spld_date,NULL,a.tax1),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax2),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax3),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax4),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax5),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax6),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax7),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax8),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax9),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax10),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax11),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax12),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax13),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax14),0))+
                    SUM(NVL(DECODE(spld_date,NULL,a.tax15),0)) total_taxes,
                    SUM(NVL(DECODE(spld_date,NULL,a.comm_amt),0)) comm_amt,
                    b.subline_name
               FROM GIPI_UWREPORTS_EXT a, giis_subline b
              WHERE a.user_id = USER
                AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                AND a.line_cd =NVL( p_line_cd, a.line_cd)
                AND a.subline_cd =NVL( p_subline_cd, a.subline_cd)
                AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                 OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                 OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                 OR  (p_scope=4 AND POL_FLAG = '5'))
                AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
           GROUP BY a.line_cd,a.subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd), b.subline_name 
           ORDER BY 3,a.line_cd, b.subline_name)
           
        LOOP
            rep.line_cd         := i.line_cd;
            rep.subline_cd      := i.subline_cd;
            rep.subline_name    := i.subline_name;
            rep.iss_cd          := i.iss_cd;
            rep.total_tsi       := i.total_tsi;
            rep.total_prem      := i.total_prem;
            rep.other_charges   := i.other_charges;
            rep.total           := i.total;
            rep.polcount        := i.pol_count;
            rep.total_taxes     := i.total_taxes;
            rep.commission      := i.comm_amt;
            
            -- cf_heading3formula
            BEGIN
              SELECT DISTINCT param_date, from_date, TO_DATE
                         INTO v_param_date, v_from_date, v_to_date
                         FROM gipi_uwreports_intm_ext
                        WHERE user_id = p_user_id;

              IF v_param_date IN (1, 2, 4)
              THEN
                 IF v_from_date = v_to_date
                 THEN
                    rep.cf_heading3 := 'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
                 ELSE
                    rep.cf_heading3 :=
                          'For the Period of '
                       || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                       || ' to '
                       || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
                 END IF;
              ELSE
                 IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
                 THEN
                    rep.cf_heading3 :=
                        'For the Month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
                 ELSE
                    rep.cf_heading3 :=
                          'For the Period of '
                       || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                       || ' to '
                       || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
                 END IF;
              END IF;
            END; 
            
            -- cf_companyformula
            BEGIN
              SELECT param_value_v
                INTO rep.cf_company
                FROM giis_parameters
               WHERE UPPER (param_name) = 'COMPANY_NAME';
            END; 
            
            -- cf_company_addressformula
            BEGIN
              SELECT param_value_v
                INTO rep.cf_company_address
                FROM giis_parameters
               WHERE param_name = 'COMPANY_ADDRESS';
            EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 NULL;
            END;
            
            -- cf_based_onformula
            BEGIN
              SELECT param_date
                INTO v_param_date
                FROM gipi_uwreports_intm_ext
               WHERE user_id = p_user_id AND ROWNUM = 1;

              IF v_param_date = 1
              THEN
                 v_based_on := 'Based on Issue Date';
              ELSIF v_param_date = 2
              THEN
                 v_based_on := 'Based on Inception Date';
              ELSIF v_param_date = 3
              THEN
                 v_based_on := 'Based on Booking month - year';
              ELSIF v_param_date = 4
              THEN
                 v_based_on := 'Based on Acctg Entry Date';
              END IF;

              v_scope := p_scope;

              IF v_scope = 1
              THEN
                 v_policy_label := v_based_on || ' / ' || 'Policies Only';
              ELSIF v_scope = 2
              THEN
                 v_policy_label := v_based_on || ' / ' || 'Endorsements Only';
              ELSIF v_scope = 3
              THEN
                 v_policy_label := v_based_on || ' / ' || 'Policies and Endorsements';
              END IF;

              rep.cf_based_on := v_policy_label;
            END; 
             
            BEGIN
              SELECT param_value_v
                INTO rep.show_total_taxes
                FROM giac_parameters
               WHERE param_name = 'SHOW_TOTAL_TAXES';
            END;
                             
        PIPE ROW (rep);
        END LOOP;
    END populate_gipir924_mx;
    
   FUNCTION get_gipir924_mx_taxes(
      p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      p_iss_cd       GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      p_scope        GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
      p_line_cd      GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
      p_subline_cd   GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
      p_assd_no      GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
      p_intm_no       GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE
      )
   RETURN taxes_tab PIPELINED
    AS
      tax     taxes_type;
      v_exist VARCHAR2(1);
   BEGIN
  
     FOR i IN (SELECT DISTINCT a.tax_cd,INITCAP(a.tax_desc) tax_name
               FROM giis_tax_charges a
              WHERE EXISTS (SELECT 1
                              FROM gipi_inv_tax
                             WHERE tax_cd = a.tax_cd)
              ORDER BY tax_cd)

     LOOP 
        v_exist := 'N';               
        FOR j IN (SELECT line_cd, 
                         subline_cd,                                               
                         iss_cd,                                  
                         tax_amt
                    FROM
                   (SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax1),0)) tax_amt
                      , 1 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax2),0)) tax2
                      , 2 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd)  
                UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax3),0)) tax3
                      , 3 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd)
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax4),0)) tax4
                      , 4 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd)  
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax5),0)) tax5
                      , 5 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax6),0)) tax6
                      , 6 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax7),0)) tax7
                      , 7 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax8),0)) tax8
                      , 8 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax9),0)) tax9
                      , 9 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax10),0)) tax10
                      , 10 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax11),0)) tax11
                      , 11 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax12),0)) tax12
                      , 12 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax13),0)) tax13
                      , 13 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax14),0)) tax14
                      , 14 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) 
                 UNION
                SELECT line_cd 
                      ,subline_cd                                               
                      ,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd                                  
                      ,SUM(NVL(DECODE(spld_date,NULL,a.tax15),0)) tax15
                      , 15 AS tax_cd
                      FROM GIPI_UWREPORTS_EXT a 
                 WHERE a.user_id = USER
                   AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
                    OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
                    OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
                    OR  (p_scope=4 AND POL_FLAG = '5'))
                 GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd)) x
                             WHERE x.tax_cd = i.tax_cd)
          LOOP
              v_exist               := 'Y';
              tax.tax_cd            := i.tax_cd;
              tax.tax_name          := i.tax_name;
              tax.line_cd           := j.line_cd;
              tax.subline_cd        := j.subline_cd;
              tax.iss_cd            := j.iss_cd;
              tax.tax_amt           := j.tax_amt;
          END LOOP;
          
          IF v_exist = 'N' THEN
              tax.tax_cd            := i.tax_cd;
              tax.tax_name          := i.tax_name;
              tax.line_cd           := NULL;
              tax.subline_cd        := NULL;
              tax.iss_cd            := NULL;
              tax.tax_amt           := NULL;
          END IF;
     PIPE ROW (tax);   
     END LOOP;
   END;
END;
/


