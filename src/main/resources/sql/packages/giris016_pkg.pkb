CREATE OR REPLACE PACKAGE BODY CPI.GIRIS016_PKG AS

    FUNCTION get_binders(
        p_line_cd               GIRI_BINDER.line_cd%TYPE,
        p_binder_yy             GIRI_BINDER.binder_yy%TYPE,
        p_binder_seq_no         GIRI_BINDER.binder_seq_no%TYPE,
        p_module_id             GIIS_MODULES.module_id%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
    )
      RETURN binder_tab PIPELINED
    IS
        v_row                   binder_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIRI_BINDER_POLBASIC_V
                  WHERE UPPER(line_cd) = UPPER(p_line_cd)
                    AND binder_yy = NVL(p_binder_yy, binder_yy)
                    AND binder_seq_no = NVL(p_binder_seq_no, binder_seq_no)
                    AND line_cd = DECODE(check_user_per_line2(line_cd, iss_cd, p_module_id, p_user_id), 1, line_cd, NULL)
                    AND iss_cd = DECODE(check_user_per_iss_cd2(line_cd, iss_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
        LOOP
            v_row.fnl_binder_id := i.fnl_binder_id;
            v_row.line_cd := i.line_cd;
            v_row.binder_seq_no := i.binder_seq_no;
            v_row.binder_yy := i.binder_yy;
            v_row.ri_sname := i.ri_sname;
            v_row.pol_line_cd := i.line_cd;
            v_row.subline_cd := i.subline_cd;
            v_row.iss_cd := i.iss_cd;
            v_row.issue_yy := i.issue_yy;
            v_row.pol_seq_no := i.pol_seq_no;
            v_row.renew_no := i.renew_no;
            v_row.assd_name := i.assd_name;
            v_row.tsi_amt := i.tsi_amt;
            v_row.ri_tsi_amt := i.ri_tsi_amt;
            v_row.ri_prem_amt := i.ri_prem_amt;
            v_row.ri_prem_vat := i.ri_prem_vat;
            v_row.prem_tax := i.prem_tax;
            v_row.frps_yy := i.frps_yy;
            v_row.frps_seq_no := i.frps_seq_no;
            v_row.currency_desc := i.currency_desc;
            v_row.currency_rt := i.currency_rt;
            v_row.prem_amt := i.prem_amt;
            v_row.ri_shr_pct := i.ri_shr_pct;
            v_row.ri_comm_amt := i.ri_comm_amt;
            v_row.ri_comm_vat := i.ri_comm_vat;
            v_row.ri_comm_rt := i.ri_comm_rt;
            v_row.remarks := i.remarks;
            v_row.bndr_remarks1 := i.bndr_remarks1;
            v_row.bndr_remarks2 := i.bndr_remarks2;
            v_row.bndr_remarks3 := i.bndr_remarks3;
            v_row.ri_accept_by := i.ri_accept_by;
            v_row.ri_as_no := i.ri_as_no;
            v_row.binder_date := TO_CHAR(i.binder_date, 'mm-dd-yyyy');
            v_row.reverse_date := TO_CHAR(i.reverse_date, 'mm-dd-yyyy');
            v_row.ri_accept_date := TO_CHAR(i.ri_accept_date, 'mm-dd-yyyy');
            v_row.binder_number := i.line_cd || '-' || i.binder_yy || '-' || LTRIM(TO_CHAR(i.binder_seq_no, '09999'));
            v_row.policy_number := i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd || '-' || LTRIM(TO_CHAR(i.issue_yy, '09')) || '-'|| 
                                    LTRIM(TO_CHAR(i.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(i.renew_no, '09'));
        
            IF i.endt_seq_no = 0 THEN
                v_row.endt_iss_cd := NULL;
                v_row.endt_yy := NULL;
                v_row.endt_seq_no := NULL;
            ELSE
                v_row.endt_iss_cd := i.endt_iss_cd;
                v_row.endt_yy := i.endt_yy;
                v_row.endt_seq_no := i.endt_seq_no;
            END IF;
            
            IF i.local_foreign_sw = 'L' THEN
                v_row.ri_wholding_vat := 0;
                v_row.net_due_ri := (i.ri_prem_amt + i.ri_prem_vat ) - (i.ri_comm_amt + i.ri_comm_vat ) - i.prem_tax;
            ELSE
                v_row.ri_wholding_vat := i.ri_wholding_vat * -1;
                v_row.net_due_ri := (i.ri_prem_amt + i.ri_prem_vat ) - (i.ri_comm_amt + i.ri_comm_vat ) - i.prem_tax - i.ri_wholding_vat;
            END IF;
        
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    --Daniel Marasigan SR 5941 03.07.2017, modified to optimize query and to allow filtering in table grid
    FUNCTION get_binder_perils(
        p_fnl_binder_id         GIRI_BINDER_PERIL.fnl_binder_id%TYPE,
        p_filter_peril_name     VARCHAR2,
        p_filter_ri_shr_pct     NUMBER,
        p_filter_ri_tsi_amt     NUMBER,
        p_filter_ri_comm_amt    NUMBER,
        p_filter_ri_prem_amt    NUMBER,
        p_from                  NUMBER,
        p_to                    NUMBER,
        p_asc_desc_flag         VARCHAR2,
        p_sort_column           VARCHAR2
    )
      RETURN binder_peril_tab PIPELINED
    IS
        v_row                   binder_peril_type;
        
        TYPE cur IS REF CURSOR;
        
        v_cur                   cur;
        v_query                 VARCHAR2(10000);
    BEGIN
        IF p_fnl_binder_id IS NOT NULL THEN
            v_query := 'SELECT * 
                          FROM (
                                SELECT ROWNUM rownum_,
                                       COUNT(1) OVER() count_,
                                       z.*
                                  FROM (';
            
            v_query := v_query || 'SELECT a.ri_prem_amt, a.ri_tsi_amt, a.ri_comm_amt, 
                                          a.ri_shr_pct, a.fnl_binder_id, a.peril_seq_no,
                                          b.peril_title
                                     FROM GIRI_BINDER_PERIL a,
                                          GIRI_FRPS_PERIL_GRP b,
                                          GIRI_FRPS_RI c
                                    WHERE c.line_cd = b.line_cd
                                      AND c.frps_yy = b.frps_yy
                                      AND c.frps_seq_no = b.frps_seq_no
                                      AND a.fnl_binder_id = c.fnl_binder_id
                                      AND a.peril_seq_no = b.peril_seq_no
                                      AND a.fnl_binder_id = '||p_fnl_binder_id;
                           
            IF p_filter_peril_name IS NOT NULL THEN
                v_query := v_query || ' AND UPPER(b.peril_title) LIKE UPPER('''||p_filter_peril_name||''')';
            END IF;
            
            IF p_filter_ri_shr_pct IS NOT NULL THEN
                v_query := v_query || ' AND a.ri_shr_pct = '||p_filter_ri_shr_pct;
            END IF;
            
            IF p_filter_ri_tsi_amt IS NOT NULL THEN
                v_query := v_query || ' AND a.ri_tsi_amt = '||p_filter_ri_tsi_amt;
            END IF;
            
            IF p_filter_ri_comm_amt IS NOT NULL THEN
                v_query := v_query || ' AND a.ri_comm_amt = '||p_filter_ri_comm_amt;
            END IF;
            
            IF p_filter_ri_prem_amt IS NOT NULL THEN
                v_query := v_query || ' AND a.ri_prem_amt = '||p_filter_ri_prem_amt;
            END IF; 
        
            IF p_sort_column IS NOT NULL THEN
                IF p_sort_column = 'perilName' THEN
                     v_query := v_query || ' ORDER BY b.peril_title ';
                ELSIF p_sort_column = 'riShrPct' THEN
                    v_query := v_query || ' ORDER BY a.ri_shr_pct ';
                ELSIF p_sort_column = 'riTsiAmt' THEN
                    v_query := v_query || ' ORDER BY a.ri_tsi_amt ';
                ELSIF p_sort_column = 'riCommAmt' THEN
                    v_query := v_query || ' ORDER BY a.ri_comm_amt ';
                ELSIF p_sort_column = 'riPremAmt' THEN
                    v_query := v_query || ' ORDER BY a.ri_prem_amt ';
                END IF;
                
                IF p_asc_desc_flag IS NOT NULL THEN
                    v_query := v_query ||' '||p_asc_desc_flag;
                ELSE
                    v_query := v_query ||' ASC';
                END IF;
            END IF;
            
            v_query := v_query || ') z ) WHERE rownum_ BETWEEN '|| p_from|| ' AND ' || p_to;
            
            
            OPEN v_cur FOR v_query;
            
            LOOP
                FETCH v_cur INTO v_row.rownum_, v_row.count_, v_row.ri_prem_amt, v_row.ri_tsi_amt, v_row.ri_comm_amt,
                                 v_row.ri_shr_pct, v_row.fnl_binder_id, v_row.peril_seq_no, v_row.peril_name;
                
                EXIT WHEN v_cur%NOTFOUND;
                
                PIPE ROW(v_row);
            END LOOP;
            
            CLOSE v_cur;
        END IF;
        
--        FOR i IN(SELECT a.ri_prem_amt, a.ri_tsi_amt, a.ri_comm_amt, 
--                        a.ri_shr_pct, a.fnl_binder_id, a.peril_seq_no,
--                        b.peril_title
--                   FROM GIRI_BINDER_PERIL a,
--                        GIRI_FRPS_PERIL_GRP b,
--                        GIRI_FRPS_RI c
--                  WHERE c.line_cd = b.line_cd
--                    AND c.frps_yy = b.frps_yy
--                    AND c.frps_seq_no = b.frps_seq_no
--                    AND a.fnl_binder_id = c.fnl_binder_id
--                    AND a.peril_seq_no = b.peril_seq_no
--                    AND a.fnl_binder_id = p_fnl_binder_id)
--        LOOP
--            v_row.fnl_binder_id := i.fnl_binder_id;
--            v_row.peril_seq_no := i.peril_seq_no;
--            v_row.ri_prem_amt := i.ri_prem_amt;
--            v_row.ri_tsi_amt := i.ri_tsi_amt;
--            v_row.ri_comm_amt := i.ri_comm_amt;
--            v_row.ri_shr_pct := i.ri_shr_pct;
--            v_row.peril_name := i.peril_title;
--            PIPE ROW(v_row);
--        END LOOP;
    END;

FUNCTION get_policy_no_lov (
   p_line_cd      VARCHAR2,
   p_subline_cd   VARCHAR2,
   p_iss_cd       VARCHAR2,
   p_issue_yy     VARCHAR2,
   p_pol_seq_no   VARCHAR2,
   p_renew_no     VARCHAR2,
   p_module_id    giis_modules.module_id%TYPE,
   p_user_id      giis_users.user_id%TYPE
)
   RETURN policy_no_tab PIPELINED
IS
   v   policy_no_type;
BEGIN
   FOR i IN (SELECT *
               FROM giri_binder_polbasic_v
              WHERE UPPER (line_cd) = UPPER (p_line_cd)
                AND UPPER (subline_cd) LIKE
                                        UPPER (NVL (p_subline_cd, subline_cd))
                AND UPPER (iss_cd) LIKE UPPER (NVL (p_iss_cd, iss_cd))
                AND issue_yy = NVL (p_issue_yy, issue_yy)
                AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                AND renew_no = NVL (p_renew_no, renew_no)
                AND line_cd =
                       DECODE (check_user_per_line2 (line_cd,
                                                     iss_cd,
                                                     p_module_id,
                                                     p_user_id
                                                    ),
                               1, line_cd,
                               NULL
                              )
                AND iss_cd =
                       DECODE (check_user_per_iss_cd2 (line_cd,
                                                       iss_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ),
                               1, iss_cd,
                               NULL
                              ))
   LOOP
      v.fnl_binder_id := i.fnl_binder_id;
      v.line_cd := i.line_cd;
      v.binder_seq_no := i.binder_seq_no;
      v.binder_yy := i.binder_yy;
      v.ri_sname := i.ri_sname;
      v.pol_line_cd := i.line_cd;
      v.subline_cd := i.subline_cd;
      v.iss_cd := i.iss_cd;
      v.issue_yy := i.issue_yy;
      v.pol_seq_no := i.pol_seq_no;
      v.renew_no := i.renew_no;
      v.assd_name := i.assd_name;
      v.tsi_amt := i.tsi_amt;
      v.ri_tsi_amt := i.ri_tsi_amt;
      v.ri_prem_amt := i.ri_prem_amt;
      v.ri_prem_vat := i.ri_prem_vat;
      v.prem_tax := i.prem_tax;
      v.frps_yy := i.frps_yy;
      v.frps_seq_no := i.frps_seq_no;
      v.currency_desc := i.currency_desc;
      v.currency_rt := i.currency_rt;
      v.prem_amt := i.prem_amt;
      v.ri_shr_pct := i.ri_shr_pct;
      v.ri_comm_amt := i.ri_comm_amt;
      v.ri_comm_vat := i.ri_comm_vat;
      v.ri_comm_rt := i.ri_comm_rt;
      v.remarks := i.remarks;
      v.bndr_remarks1 := i.bndr_remarks1;
      v.bndr_remarks2 := i.bndr_remarks2;
      v.bndr_remarks3 := i.bndr_remarks3;
      v.ri_accept_by := i.ri_accept_by;
      v.ri_as_no := i.ri_as_no;
      v.binder_date := TO_CHAR (i.binder_date, 'mm-dd-yyyy');
      v.reverse_date := TO_CHAR (i.reverse_date, 'mm-dd-yyyy');
      v.ri_accept_date := TO_CHAR (i.ri_accept_date, 'mm-dd-yyyy');
      v.binder_number :=
            i.line_cd
         || '-'
         || i.binder_yy
         || '-'
         || LTRIM (TO_CHAR (i.binder_seq_no, '09999'));
      v.policy_number :=
            i.line_cd
         || '-'
         || i.subline_cd
         || '-'
         || i.iss_cd
         || '-'
         || LTRIM (TO_CHAR (i.issue_yy, '09'))
         || '-'
         || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
         || '-'
         || LTRIM (TO_CHAR (i.renew_no, '09'));
         
      IF i.endt_seq_no = 0 THEN
         v.endt_iss_cd := NULL;
         v.endt_yy := NULL;
         v.endt_seq_no := NULL;
         v.endt_number := NULL;
      ELSE
         v.endt_iss_cd := i.endt_iss_cd;
         v.endt_yy := i.endt_yy;
         v.endt_seq_no := i.endt_seq_no;
         v.endt_number :=
           i.endt_iss_cd
         || ' - '
         || LTRIM (TO_CHAR (i.endt_yy, '09'))
         || ' - '
         || LTRIM (TO_CHAR (i.endt_seq_no, '0000009'));
      END IF;
      

      IF i.local_foreign_sw = 'L'
      THEN
         v.ri_wholding_vat := 0;
         v.net_due_ri :=
              (i.ri_prem_amt + i.ri_prem_vat)
            - (i.ri_comm_amt + i.ri_comm_vat)
            - i.prem_tax;
      ELSE
         v.ri_wholding_vat := i.ri_wholding_vat * -1;
         v.net_due_ri :=
              (i.ri_prem_amt + i.ri_prem_vat)
            - (i.ri_comm_amt + i.ri_comm_vat)
            - i.prem_tax
            - i.ri_wholding_vat;
      END IF;

      PIPE ROW (v);
   END LOOP;
END;
END GIRIS016_PKG;
/