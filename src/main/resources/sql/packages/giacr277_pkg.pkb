CREATE OR REPLACE PACKAGE BODY CPI.GIACR277_PKG
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.020.2013
    **  Reference By : GIACR277_PKG - SCHEDULE ON MONTHLY COMMISION INCOME
    **  Modified by : Kevin S. for SR-18635 7-11-2016
    */
    FUNCTION CF_iss_tot_titleFormula(
    x_iss_param VARCHAR2,
    x_iss_cd    VARCHAR2,
    x_line_cd   VARCHAR2
    )
    return Char is
    BEGIN
        IF x_iss_param = 1 THEN
           RETURN('Totals per Crediting Branch ('||(x_iss_cd)||') per Line ('||(x_line_cd)||') :');
      ELSIF x_iss_param = 2 THEN
          RETURN('Totals per Issue Source ('||(x_iss_cd)||') per Line ('||(x_line_cd)||') :');
      ELSE 
         RETURN NULL;
      END IF;
   END;

    FUNCTION cf_iss_headerformula(
        p_iss_param VARCHAR2
    )
       RETURN CHAR
    IS
    BEGIN
       IF p_iss_param = 1
       THEN
          RETURN ('Crediting Branch :');
       ELSIF p_iss_param = 2
       THEN
          RETURN ('Issue Source     :');
       ELSE
          RETURN NULL;
       END IF;
    END;
 

    FUNCTION get_giacr277_record(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_line_cd_all   VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER,
        p_grand_total_prem NUMBER,
        p_grand_total_comm NUMBER,
        p_print_grand_total VARCHAR2,
        p_grand_total_prem_amt NUMBER,
        p_grand_total_nr_prem_amt NUMBER
    )
    RETURN
            giacr277_tab PIPELINED
    IS 
            v_rec giacr277_type;
            v_line_count NUMBER;
            v_trty_no    NUMBER := 2;
            v_trty_count NUMBER;
            v_current_trty NUMBER := -1;
            v_value_holder NUMBER;
    BEGIN
        SELECT COUNT(DISTINCT trty_acct_type)+1 INTO v_trty_count
        FROM giac_comm_income_ext_v
        WHERE trty_acct_type IS NOT NULL;
        
        v_line_count := ROUND((v_trty_count+4)/5);
        
        FOR line_count IN 1..v_line_count
        LOOP
            v_rec.line_count := line_count;
            IF line_count > 1 AND (v_trty_count-5) >= 0
            THEN
                v_trty_no := 1;
                v_trty_count := v_trty_count - 5;
                v_current_trty := v_value_holder;
            ELSIF line_count > 1
            THEN
                v_trty_no := 0;
                v_trty_count := v_trty_count - 5;
            END IF;
            v_rec.trty1 := null;
            v_rec.trty2 := null;
            v_rec.trty3 := null;
            v_rec.trty4 := null;
            v_rec.trty5 := null;
            FOR i IN ( 
                        SELECT DISTINCT peril_cd,
                                        line_cd,
                                       DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd, 
                                       assd_no, 
                                       policy_id, 
                                       incept_date,
                                       acct_ent_date,
                                       nvl(to_number(total_prem_amt),0)total_prem_amt, 
                                       nvl(to_number(nr_prem_amt),0)nr_prem_amt,
                                       nvl(to_number(facul_prem),0)facul_prem, 
                                       nvl(to_number(facul_comm),0)facul_comm
                              FROM giac_comm_income_ext_v
                              WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                         AND to_date(p_to, 'MM-DD-YYYY')
                              AND line_cd = nvl(p_line_cd, line_cd)
                              AND user_id = p_user_id
                              AND policy_id = nvl(p_policy_id, policy_id)
                              AND peril_cd = nvl(p_peril_cd,peril_cd)
                              --AND (nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0 --remove by Kevin SR-18635
                              AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0 --added by Kevin SR-18635
                              order by line_cd,iss_cd,policy_id,peril_cd
                        )
                LOOP
                    v_rec.line_cd := i.line_cd;
                    v_rec.iss_cd := i.iss_cd;
                    v_rec.assd_no := i.assd_no;
                    v_rec.policy_id := i.policy_id;
                    v_rec.incept_date := i.incept_date;
                    v_rec.acct_ent_date := i.acct_ent_date;
                    v_rec.peril_cd := i.peril_cd;
                    v_rec.total_prem_amt := i.total_prem_amt;
                    v_rec.nr_prem_amt := i.nr_prem_amt; 
                    v_rec.facul_prem := i.facul_prem;
                    v_rec.facul_comm := i.facul_comm;
                    v_rec.iss_header := cf_iss_headerformula(p_iss_param);
                    v_rec.title_formula := CF_iss_tot_titleFormula(p_iss_param,i.iss_cd,i.line_cd);
            
                      FOR rec IN (SELECT iss_name
                                     FROM giis_issource
                                 WHERE iss_cd  = i.iss_cd)
                      LOOP
                        v_rec.iss_source := i.iss_cd||' - '||rec.iss_name;
                        EXIT;
                      END LOOP;
                      
                      FOR rec IN (SELECT assd_name 
                               FROM giis_assured
                             WHERE assd_no = i.assd_no)
                      LOOP
                        v_rec.assd_name := rec.assd_name;
                        EXIT;
                      END LOOP;
                      
                      FOR rec IN(SELECT    line_cd
                                     || '-'
                                     || subline_cd
                                     || '-'
                                     || iss_cd
                                     || '-'
                                     || ltrim (to_char (issue_yy, '09'))
                                     || '-'
                                     || ltrim (to_char (pol_seq_no, '0999999'))
                                     || '-'
                                     || ltrim (to_char (renew_no, '09'))
                                     || decode (
                                           nvl (endt_seq_no, 0),
                                           0, '',
                                              ' / '
                                           || endt_iss_cd
                                           || '-'
                                           || ltrim (to_char (endt_yy, '09'))
                                           || '-'
                                           || ltrim (to_char (endt_seq_no, '9999999'))
                                        ) POLICY
                                FROM gipi_polbasic
                                WHERE policy_id = i.policy_id)
                      LOOP
                        v_rec.policy_no := rec.policy;
                        EXIT;
                      END LOOP;
                      
                         FOR rec IN (SELECT peril_name
                                     FROM giis_peril 
                                 WHERE line_cd  = i.line_cd
                                   AND peril_cd = i.peril_cd)
                      LOOP
                        v_rec.peril_name := rec.peril_name;
                        EXIT;
                      END LOOP;

                      v_rec.name_per_line := 'Totals per Line ('||(i.line_cd)||') :'; 
                      IF p_print_grand_total = '1'
                      THEN
                          v_rec.grand_total1 := p_grand_total_prem_amt;
                          v_rec.grand_total2 := p_grand_total_nr_prem_amt;
                          FOR total IN (SELECT nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty_prem,
                                               nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm
                                        FROM giac_comm_income_ext_v
                                        WHERE acct_ent_date BETWEEN to_date(P_FROM, 'MM-DD-YYYY')
                                               AND to_date(P_TO, 'MM-DD-YYYY')
                                               AND line_cd = nvl(p_line_cd_all,line_cd)
                                               AND user_id =P_USER_ID
                                        AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                                    )
                           LOOP
                                IF line_count = 1
                                THEN
                                    IF v_trty_count = 2
                                    THEN
                                        v_rec.grand_total5 := p_grand_total_prem;
                                        v_rec.grand_total6 := p_grand_total_comm;
                                        v_rec.grand_total7 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total8 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 3
                                    THEN
                                        v_rec.grand_total7 := p_grand_total_prem;
                                        v_rec.grand_total8 := p_grand_total_comm;
                                        v_rec.grand_total9 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total10 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 4
                                    THEN
                                        v_rec.grand_total9 := p_grand_total_prem;
                                        v_rec.grand_total10 := p_grand_total_comm;
                                    END IF;
                                ELSE
                                    IF v_trty_count < 0
                                    THEN
                                        v_rec.grand_total1 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total2 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 0
                                    THEN
                                        v_rec.grand_total1 := p_grand_total_prem;
                                        v_rec.grand_total2 := p_grand_total_comm;
                                        v_rec.grand_total3 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total4 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 1
                                    THEN
                                        v_rec.grand_total3 := p_grand_total_prem;
                                        v_rec.grand_total4 := p_grand_total_comm;
                                        v_rec.grand_total5 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total6 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 2
                                    THEN
                                        v_rec.grand_total5 := p_grand_total_prem;
                                        v_rec.grand_total6 := p_grand_total_comm;
                                        v_rec.grand_total7 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total8 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 3
                                    THEN
                                        v_rec.grand_total7 := p_grand_total_prem;
                                        v_rec.grand_total8 := p_grand_total_comm;
                                        v_rec.grand_total9 := total.TOTAL_treaty_prem + p_grand_total_prem;
                                        v_rec.grand_total10 := total.TOTAL_treaty_comm + p_grand_total_comm;
                                    ELSIF v_trty_count = 4
                                    THEN
                                        v_rec.grand_total9 := p_grand_total_prem;
                                        v_rec.grand_total10 := p_grand_total_comm;
                                    END IF;
                                END IF;
                           END LOOP;
                      END IF;
                   -- for treaty
                   IF line_count = 1
                   THEN
                        v_trty_no := 2;
                        v_rec.header1 := 'Premium Per Peril';
                        v_rec.header2 := 'Net Ret Per Peril';
                        v_rec.detail1 := i.total_prem_amt;
                        v_rec.detail2 := i.nr_prem_amt;
                        
                        IF v_trty_count = 2
                        THEN
                            v_rec.trty3 := 'Facultative';
                            v_rec.header5 := 'Premium Ceded';
                            v_rec.header6 := 'Comm. Income';
                            v_rec.trty4 := 'Total';
                            v_rec.header7 := 'Premium Ceded';
                            v_rec.header8 := 'Comm. Income';
                        ELSIF v_trty_count = 3
                        THEN
                            v_rec.trty4 := 'Facultative';
                            v_rec.header7 := 'Premium Ceded';
                            v_rec.header8 := 'Comm. Income';
                            v_rec.trty5 := 'Total';
                            v_rec.header9 := 'Premium Ceded';
                            v_rec.header10 := 'Comm. Income';
                        ELSIF v_trty_count = 4
                        THEN
                            v_rec.trty5 := 'Facultative';
                            v_rec.header9 := 'Premium Ceded';
                            v_rec.header10 := 'Comm. Income';
                        END IF;
                   ELSE
                        IF v_trty_no <> 0
                        THEN
                            v_trty_no := 1;
                        END IF;
                        
                        IF v_trty_count < 0
                        THEN
                            v_rec.trty1 := 'Total';
                            v_rec.header1 := 'Premium Ceded';
                            v_rec.header2 := 'Comm. Income';
                        ELSIF v_trty_count = 0
                        THEN
                            v_rec.trty1 := 'Facultative';
                            v_rec.header1 := 'Premium Ceded';
                            v_rec.header2 := 'Comm. Income';
                            v_rec.trty2 := 'Total';
                            v_rec.header3 := 'Premium Ceded';
                            v_rec.header4 := 'Comm. Income';
                        ELSIF v_trty_count = 1
                        THEN
                            v_rec.trty2 := 'Facultative';
                            v_rec.header3 := 'Premium Ceded';
                            v_rec.header4 := 'Comm. Income';
                            v_rec.trty3 := 'Total';
                            v_rec.header5 := 'Premium Ceded';
                            v_rec.header6 := 'Comm. Income';
                        ELSIF v_trty_count = 2
                        THEN
                            v_rec.trty3 := 'Facultative';
                            v_rec.header5 := 'Premium Ceded';
                            v_rec.header6 := 'Comm. Income';
                            v_rec.trty4 := 'Total';
                            v_rec.header7 := 'Premium Ceded';
                            v_rec.header8 := 'Comm. Income';
                        ELSIF v_trty_count = 3
                        THEN
                            v_rec.trty4 := 'Facultative';
                            v_rec.header7 := 'Premium Ceded';
                            v_rec.header8 := 'Comm. Income';
                            v_rec.trty5 := 'Total';
                            v_rec.header9 := 'Premium Ceded';
                            v_rec.header10 := 'Comm. Income';
                        ELSIF v_trty_count = 4
                        THEN
                            v_rec.trty5 := 'Facultative';
                            v_rec.header9 := 'Premium Ceded';
                            v_rec.header10 := 'Comm. Income';
                        END IF;
                   END IF;
                   
                   FOR a IN (
                            SELECT DISTINCT trty_acct_type FROM giac_comm_income_ext_v 
                                WHERE trty_acct_type IS NOT NULL
                                ORDER BY trty_acct_type
                            )
                                
                    LOOP
                        IF v_current_trty < a.trty_acct_type
                        THEN
                            IF p_print_grand_total = '1'
                            THEN
                                FOR total IN (
                                    SELECT nvl(SUM(treaty_prem),to_number(0)) total_treaty_prem,
                                           nvl(SUM(treaty_comm),to_number(0)) total_treaty_comm
                                    FROM giac_comm_income_ext_v
                                    WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')
                                           AND to_date(p_to, 'MM-DD-YYYY')
                                           AND line_cd = nvl(p_line_cd_all,line_cd)
                                           AND user_id = p_user_id
                                           AND trty_acct_type = a.trty_acct_type
                                           AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                                )
                                LOOP
                                    IF v_trty_no = 1
                                    THEN
                                        v_rec.grand_total1 := total.total_treaty_prem;
                                        v_rec.grand_total2 := total.total_treaty_comm;
                                    ELSIF v_trty_no = 2
                                    THEN
                                        v_rec.grand_total3 := total.total_treaty_prem;
                                        v_rec.grand_total4 := total.total_treaty_comm;
                                    ELSIF v_trty_no = 3
                                    THEN
                                        v_rec.grand_total5 := total.total_treaty_prem;
                                        v_rec.grand_total6 := total.total_treaty_comm;
                                    ELSIF v_trty_no = 4
                                    THEN
                                        v_rec.grand_total7 := total.total_treaty_prem;
                                        v_rec.grand_total8 := total.total_treaty_comm;
                                    ELSIF v_trty_no = 5
                                    THEN
                                        v_rec.grand_total9 := total.total_treaty_prem;
                                        v_rec.grand_total10 := total.total_treaty_comm;
                                    END IF;
                                    
                                END LOOP;
                            END IF;
                        END IF;
                        
                        FOR x IN (
                                    SELECT line_cd,
                                       DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,                                                
                                       policy_id,                                                
                                       peril_cd,                                              
                                       nvl(treaty_prem,to_number(0.00)) treaty_prem, 
                                       nvl(treaty_comm,to_number(0.00)) treaty_comm, 
                                       trty_acct_type,
                                       nvl(facul_prem,0.00) facul_prem,
                                       nvl(facul_comm,0.00) facul_comm
                                    FROM giac_comm_income_ext_v
                                    WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                         AND to_date(p_to, 'MM-DD-YYYY')
                                      AND line_cd = nvl(p_line_cd, line_cd)
                                      AND user_id = p_user_id
                                      AND policy_id = nvl(i.policy_id, policy_id)
                                      AND peril_cd = nvl(i.peril_cd,peril_cd)
                                      AND iss_cd = nvl(i.iss_cd, iss_cd)
                                      AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                                    )
                         LOOP
                            IF v_current_trty < a.trty_acct_type
                            THEN
                                IF a.trty_acct_type = x.trty_acct_type THEN
                                    IF v_trty_no = 1
                                    THEN
                                        v_rec.detail1 := x.treaty_prem;
                                        v_rec.detail2 := x.treaty_comm;
                                        v_value_holder := a.trty_acct_type;
                                    ELSIF v_trty_no = 2
                                    THEN
                                        v_rec.detail3 := x.treaty_prem;
                                        v_rec.detail4 := x.treaty_comm;
                                        v_value_holder := a.trty_acct_type;
                                    ELSIF v_trty_no = 3
                                    THEN
                                        v_rec.detail5 := x.treaty_prem;
                                        v_rec.detail6 := x.treaty_comm;
                                        v_value_holder := a.trty_acct_type;
                                    ELSIF v_trty_no = 4
                                    THEN
                                        v_rec.detail7 := x.treaty_prem;
                                        v_rec.detail8 := x.treaty_comm;
                                        v_value_holder := a.trty_acct_type;
                                    ELSIF v_trty_no = 5
                                    THEN
                                        v_rec.detail9 := x.treaty_prem;
                                        v_rec.detail10 := x.treaty_comm;
                                        v_value_holder := a.trty_acct_type;
                                    END IF;
                                END IF;
                            END IF;
                            
                            IF v_trty_count < 5
                            THEN
                                FOR total_t_prem IN (
                                                        SELECT line_cd,
                                                        DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                             policy_id,
                                                             peril_cd,
                                                             nvl(facul_prem,to_number(0)) TOTAL_f_prem,
                                                             nvl(facul_comm,to_number(0)) TOTAL_f_comm,
                                                             nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty,
                                                             nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm,
                                                             nvl(facul_prem,to_number(0))+nvl(SUM(treaty_prem),to_number(0)) GRAND_TOTAL_PREM,
                                                             nvl(facul_comm,to_number(0))+ nvl(SUM(treaty_comm),to_number(0)) GRAND_TOTAL_COMM
                                                        FROM giac_comm_income_ext_v
                                                        WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')
                                                             AND to_date(p_to, 'MM-DD-YYYY')
                                                             AND line_cd = nvl(x.line_cd,0)
                                                             AND iss_cd = nvl(x.iss_cd,0)
                                                             AND user_id = p_user_id
                                                             AND policy_id = nvl(x.policy_id,0)
                                                             AND peril_cd = nvl(x.peril_cd,0)
                                                             AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                                                       GROUP BY line_cd,DECODE(p_iss_param, 1, cred_branch, iss_cd),policy_id,peril_cd,facul_prem,facul_comm
                                                    )
                               LOOP
                                IF line_count = 1
                                THEN
                                    IF v_trty_count = 2
                                    THEN
                                        v_rec.detail5 := x.facul_prem;
                                        v_rec.detail6 := x.facul_comm;
                                        v_rec.detail7 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail8 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 3
                                    THEN
                                        v_rec.detail7 := x.facul_prem;
                                        v_rec.detail8 := x.facul_comm;
                                        v_rec.detail9 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail10 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 4
                                    THEN
                                        v_rec.detail9 := x.facul_prem;
                                        v_rec.detail10 := x.facul_comm;
                                    END IF;
                                ELSE
                                    IF v_trty_count < 0
                                    THEN
                                        v_rec.detail1 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail2 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 0
                                    THEN
                                        v_rec.detail1 := x.facul_prem;
                                        v_rec.detail2 := x.facul_comm;
                                        v_rec.detail3 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail4 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 1
                                    THEN
                                        v_rec.detail3 := x.facul_prem;
                                        v_rec.detail4 := x.facul_comm;
                                        v_rec.detail5 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail6 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 2
                                    THEN
                                        v_rec.detail5 := x.facul_prem;
                                        v_rec.detail6 := x.facul_comm;
                                        v_rec.detail7 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail8 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 3
                                    THEN
                                        v_rec.detail7 := x.facul_prem;
                                        v_rec.detail8 := x.facul_comm;
                                        v_rec.detail9 := total_t_prem.GRAND_TOTAL_PREM;
                                        v_rec.detail10 := total_t_prem.GRAND_TOTAL_COMM;
                                    ELSIF v_trty_count = 4
                                    THEN
                                        v_rec.detail9 := x.facul_prem;
                                        v_rec.detail10 := x.facul_comm;
                                    END IF;
                                END IF;
                               
                               END LOOP;
                            END IF;

                         END LOOP;
                         
                         FOR rec IN (SELECT trty_sname
                          FROM giis_ca_trty_type
                           WHERE ca_trty_type = a.trty_acct_type
                           )
                        LOOP
                            IF v_trty_no = 1
                            THEN
                                v_rec.trty1 := rec.trty_sname;
                                v_rec.header1 := 'Premium Ceded';
                                v_rec.header2 := 'Comm. Income';
                                v_trty_no := 2;
                            ELSIF v_trty_no = 2
                            THEN
                                v_rec.trty2 := rec.trty_sname;
                                v_rec.header3 := 'Premium Ceded';
                                v_rec.header4 := 'Comm. Income';
                                v_trty_no := 3;
                            ELSIF v_trty_no = 3
                            THEN
                                v_rec.trty3 := rec.trty_sname;
                                v_rec.header5 := 'Premium Ceded';
                                v_rec.header6 := 'Comm. Income';
                                v_trty_no := 4;
                            ELSIF v_trty_no = 4
                            THEN
                                v_rec.trty4 := rec.trty_sname;
                                v_rec.header7 := 'Premium Ceded';
                                v_rec.header8 := 'Comm. Income';
                                v_trty_no := 5;
                            ELSIF v_trty_no = 5
                            THEN
                                v_rec.trty5 := rec.trty_sname;
                                v_rec.header9 := 'Premium Ceded';
                                v_rec.header10 := 'Comm. Income';
                            END IF;
                            EXIT;
                        END LOOP;
                    END LOOP;
                    PIPE ROW(v_rec);
                    v_rec.detail1 := 0.00;
                    v_rec.detail2 := 0.00;
                    v_rec.detail3 := 0.00;
                    v_rec.detail4 := 0.00;
                    v_rec.detail5 := 0.00;
                    v_rec.detail6 := 0.00;
                    v_rec.detail7 := 0.00;
                    v_rec.detail8 := 0.00;
                    v_rec.detail9 := 0.00;
                    v_rec.detail10 := 0.00;
                END LOOP;
        END LOOP;
    END get_giacr277_record;
    
    
    FUNCTION get_giacr277_line(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER
    )
    RETURN
            giacr277_line_tab PIPELINED
    IS 
            v_rec giacr277_line_type;
            times2pipe NUMBER := 0;
            v_line_max_count NUMBER := 0;
            v_current_count NUMBER := 0;
            v_grand_total_prem NUMBER := 0;
            v_grand_total_comm NUMBER := 0;
            v_facul_prem       NUMBER;
            v_facul_comm       NUMBER;
            v_grand_total_nr_prem_amt NUMBER := 0;
            v_grand_total_prem_amt NUMBER := 0;
    BEGIN
        SELECT COUNT(DISTINCT line_cd) INTO v_line_max_count
                      FROM giac_comm_income_ext_v
                      WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                 AND to_date(p_to, 'MM-DD-YYYY')
                      AND line_cd = nvl(p_line_cd, line_cd)
                      AND user_id = p_user_id
                      AND policy_id = nvl(p_policy_id, policy_id)
                      AND peril_cd = nvl(p_peril_cd,peril_cd)
                      AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0;
        FOR i IN ( 
                SELECT DISTINCT peril_cd,
                                line_cd,
                               DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd, 
                               assd_no, 
                               policy_id,
                               nvl(to_number(total_prem_amt),0)total_prem_amt, 
                               nvl(to_number(nr_prem_amt),0)nr_prem_amt,
                               nvl(to_number(facul_prem),0)facul_prem, 
                               nvl(to_number(facul_comm),0)facul_comm
                      FROM giac_comm_income_ext_v
                      WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                 AND to_date(p_to, 'MM-DD-YYYY')
                      AND line_cd = nvl(p_line_cd, line_cd)
                      AND user_id = p_user_id
                      AND policy_id = nvl(p_policy_id, policy_id)
                      AND peril_cd = nvl(p_peril_cd,peril_cd)
                      AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0 --added by Kevin SR-18635
                )
        LOOP
            v_grand_total_nr_prem_amt := v_grand_total_nr_prem_amt + i.nr_prem_amt;
            v_grand_total_prem_amt := v_grand_total_prem_amt + i.total_prem_amt;
                FOR x IN (
                            SELECT line_cd,
                               DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,                                                
                               policy_id,                                                
                               peril_cd,                                              
                               nvl(treaty_prem,to_number(0.00)) treaty_prem, 
                               nvl(treaty_comm,to_number(0.00)) treaty_comm, 
                               trty_acct_type,
                               nvl(facul_prem,0.00) facul_prem,
                               nvl(facul_comm,0.00) facul_comm
                            FROM giac_comm_income_ext_v
                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                 AND to_date(p_to, 'MM-DD-YYYY')
                              AND line_cd = nvl(i.line_cd, line_cd)
                              AND user_id = p_user_id
                              AND policy_id = nvl(i.policy_id, policy_id)
                              AND peril_cd = nvl(i.peril_cd,peril_cd)
                              AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                            )
                LOOP
                    v_facul_prem := x.facul_prem;
                    v_facul_comm := x.facul_comm;
                END LOOP;
                v_grand_total_prem := v_grand_total_prem + v_facul_prem;
                v_grand_total_comm := v_grand_total_comm + v_facul_comm;
        END LOOP;
        v_rec.facul_prem := v_grand_total_prem;
        v_rec.facul_comm := v_grand_total_comm;
        v_rec.grand_total_nr_prem_amt := v_grand_total_nr_prem_amt;
        v_rec.grand_total_prem_amt := v_grand_total_prem_amt;
        FOR i IN ( 
                SELECT DISTINCT line_cd
                      FROM giac_comm_income_ext_v
                      WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                 AND to_date(p_to, 'MM-DD-YYYY')
                      AND line_cd = nvl(p_line_cd, line_cd)
                      AND user_id = p_user_id
                      AND policy_id = nvl(p_policy_id, policy_id)
                      AND peril_cd = nvl(p_peril_cd,peril_cd)
                      AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0 --added by Kevin SR-18635
                      order by line_cd
                )
        LOOP
              v_current_count := v_current_count + 1;
              v_rec.line_cd := i.line_cd;
            
              FOR rec IN (SELECT upper(param_value_v) param_value_v
                            FROM giis_parameters
               WHERE param_name = 'COMPANY_NAME') 
              LOOP
                v_rec.comp_name := rec.param_value_v;
                EXIT;
              END LOOP;
              
              FOR rec IN (SELECT upper(param_value_v) address            
                            FROM giis_parameters 
                            WHERE param_name = 'COMPANY_ADDRESS')
              LOOP
                v_rec.address := rec.address;
                EXIT;
              END LOOP;
              
              IF p_from = p_to THEN
                    v_rec.from_to := 'For '||to_char(to_date(p_from, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
              ELSE    
                      v_rec.from_to := 'For the period of '||to_char(to_date(p_from, 'MM-DD-RRRR'),'fmMonth DD, RRRR')||' to '||to_char(to_date(p_to, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
              END IF;
              
              FOR rec IN (SELECT line_name
                            FROM giis_line
                            WHERE line_cd  = i.line_cd)
              LOOP
                v_rec.line := i.line_cd||' - '||rec.line_name;
                EXIT;
              END LOOP;
              
              IF v_current_count = v_line_max_count
              THEN
                v_rec.print_grand_total := 1;
              END IF;
              
              PIPE ROW(v_rec);
        END LOOP;
        
    END get_giacr277_line;
END;
/


