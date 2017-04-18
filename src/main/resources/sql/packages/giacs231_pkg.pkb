CREATE OR REPLACE PACKAGE BODY CPI.GIACS231_PKG AS
    /*
    **  Modified by  :  Maria Gzelle Ison
    **  Date Created :  03.01.2013
    **  Reference By :  program units from GIACR211_latest
    */
	FUNCTION get_actg_transaction_status (
          p_fund_cd     GIAC_ACCTRANS.gfun_fund_cd%TYPE,   
		  p_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
		  p_tran_flag   GIAC_ACCTRANS.tran_flag%TYPE,
          p_user_id     GIIS_USERS.user_id%TYPE
	) 
        RETURN actg_list_transaction_tab PIPELINED 
	IS
		v_list actg_list_transaction_status;
	BEGIN
	    FOR i IN (
            SELECT a.tran_class, 
                   d.rv_meaning tran_class_desc,
                   a.tran_year 
                    || DECODE(a.tran_month,
                                NULL, '', '-' || TRIM(TO_CHAR (a.tran_month, '09'))) 
                    || DECODE(a.tran_seq_no, 
                                NULL, '', '-' || TRIM(TO_CHAR (a.tran_seq_no, '000009'))) tran_no,
                   a.tran_date,
                   a.posting_date,
                   a.tran_id,
                   c.rv_meaning AS TRAN_FLAG,
                   a.particulars, 
                   a.user_id,
                   TO_CHAR(a.last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update,
                   c.rv_low_value,
                   a.tran_class_no,
                   a.gibr_branch_cd
 			  FROM GIAC_ACCTRANS a, CG_REF_CODES c, CG_REF_CODES d
 			 WHERE a.tran_flag <> 'D'
--   		       AND a.gibr_branch_cd IN (SELECT iss_cd
--       						            FROM GIIS_ISSOURCE
--          						       WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS231', p_user_id),
--                           				                        1, iss_cd, NULL)) -- access was already checked in branch lov
   			   AND c.rv_low_value = a.tran_flag
               AND c.rv_domain = 'GIAC_ACCTRANS.TRAN_FLAG'
               AND d.rv_low_value = a.tran_class
               AND d.rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS'
               AND a.gibr_branch_cd = p_branch_cd
			   AND a.tran_flag = NVL(p_tran_flag, a.tran_flag)
               AND UPPER(gfun_fund_cd) = UPPER(p_fund_cd)
	    )
        LOOP	  				
		  	v_list.tran_id      := i.tran_id;
            v_list.tran_class   := i.tran_class;
            v_list.tran_class_desc := UPPER(i.tran_class_desc);
            v_list.tran_no      := i.tran_no;
            v_list.tran_date    := TO_CHAR(i.tran_date,'MM-DD-YYYY');
            v_list.posting_date := i.posting_date;			
            v_list.tran_flag    := i.tran_flag;
            v_list.particulars  := i.particulars;
			v_list.user_id      := i.user_id;
			v_list.last_update  := i.last_update;
            v_list.rv_low_value := i.rv_low_value;
            
            IF i.tran_class IN ('DV', 'COL') THEN
                v_list.ref_no       := get_ref_no(i.tran_id);
            ELSE 
                v_list.ref_no       := LTRIM(TO_CHAR(i.tran_class_no, '0000000000')); 
            END IF;
            
			PIPE ROW(v_list);
		END LOOP;
		
        RETURN;
		
	END get_actg_transaction_status;

    FUNCTION get_tran_stat_hist(
       p_tran_id   GIAC_ACCTRANS.tran_id%TYPE   
    ) 
        RETURN actg_list_transaction_tab PIPELINED
    IS
        v_list actg_list_transaction_status;
    BEGIN
        FOR j IN (SELECT a.tran_flag,
                         RTRIM(LTRIM(b.rv_meaning)) rv_meaning,
                         a.user_id,
                         TO_CHAR(a.last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
                    FROM GIAC_TRAN_STAT_HIST a, CG_REF_CODES b
                   WHERE tran_id = p_tran_id
                     AND rv_low_value = a.tran_flag
                     AND rv_domain = 'GIAC_ACCTRANS.TRAN_FLAG'
                ORDER BY last_update DESC)
        LOOP
            v_list.hist_tran_flag   := j.tran_flag;
            v_list.hist_rv_meaning  := j.rv_meaning;
            v_list.hist_user_id     := j.user_id;
            v_list.hist_last_update := j.last_update;
            PIPE ROW(v_list);
        END LOOP;
        
    END get_tran_stat_hist; 

    FUNCTION get_all_branch(
        p_module_id     GIIS_MODULES.module_id%TYPE,    
        p_branch        GIAC_BRANCHES.branch_name%TYPE,
        p_gfun_fund_cd 	GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        p_user_id       GIIS_USERS.user_id%TYPE
    )
        RETURN branch_lov_tab PIPELINED
    IS
        v_branch branch_lov_type;
    
    BEGIN
        FOR i IN (
--            SELECT *
--                FROM (
                      SELECT a.branch_cd branch_cd,a.branch_name branch_name 
                        FROM GIAC_BRANCHES a, giis_funds b 
                       WHERE b.fund_cd = a.gfun_fund_cd 
                         --AND b.fund_cd LIKE NVL(p_gfun_fund_cd,'%') 
                         AND a.branch_cd IN (SELECT iss_cd 
                                               FROM GIIS_ISSOURCE 
                                              WHERE iss_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(NULL,iss_cd,p_module_id, p_user_id),
                                                                      1,iss_cd,NULL))
                          AND (UPPER(branch_cd) LIKE UPPER(NVL(p_branch,'%')) 
                        OR UPPER(branch_name) LIKE UPPER(NVL(p_branch,'%'))
                        OR UPPER(branch_cd || ' - ' || branch_name) LIKE UPPER(NVL(p_branch,'%'))))      
--              WHERE (UPPER(branch_cd) LIKE UPPER(NVL(p_branch,'%')) 
--                        OR UPPER(branch_name) LIKE UPPER(NVL(p_branch,'%'))
--                        OR UPPER(branch_cd || ' - ' || branch_name) LIKE UPPER(NVL(p_branch,'%')))                    
--        )
        LOOP
            v_branch.branch_cd   := i.branch_cd;
            v_branch.branch_name := i.branch_name;
            
            PIPE ROW(v_branch);
        END LOOP;
        
        RETURN;
        
    END get_all_branch;
    
    FUNCTION get_all_tran_class(
        p_class     CG_REF_CODES.RV_MEANING%TYPE
    )
        RETURN tran_status_lov_tab PIPELINED
    IS
        v_tran_class tran_status_lov_type;
    
    BEGIN
        FOR i IN (
            SELECT rv_low_value ,UPPER(rv_meaning) rv_meaning 
              FROM (SELECT DISTINCT tran_class 
                      FROM GIAC_ACCTRANS
                   ) a, 
                   (SELECT rv_low_value, rv_meaning 
                      FROM CG_REF_CODES
                     WHERE rv_domain IN ('GIAC_ACCTRANS.TRAN_CLASS')
                   ) b 
             WHERE a.tran_class = b.rv_low_value (+)
               AND (UPPER(rv_low_value) LIKE UPPER(NVL(p_class,'%')) 
               OR UPPER(rv_meaning) LIKE UPPER(NVL(p_class,'%'))
               OR UPPER(rv_low_value || ' - ' || rv_meaning) LIKE UPPER(NVL(p_class,'%')))              
--               AND (UPPER(rv_low_value) LIKE UPPER(NVL(p_class,'%')) 
--                    OR UPPER(rv_meaning) LIKE UPPER(NVL(p_class,'%')) 
--                    OR UPPER(rv_low_value || ' - ' || rv_meaning) LIKE UPPER(NVL(p_class, '%')))
        )
        LOOP
            v_tran_class.rv_low_value   := i.rv_low_value;
            v_tran_class.rv_meaning     := i.rv_meaning;
            
            PIPE ROW(v_tran_class);
        END LOOP;
        
    END get_all_tran_class;

    FUNCTION get_all_status(
        p_status     CG_REF_CODES.RV_MEANING%TYPE
    )
        RETURN tran_status_lov_tab PIPELINED
    IS
        v_stat tran_status_lov_type;
    
    BEGIN
        FOR i IN (
            SELECT *
                FROM (
                      SELECT UPPER(rv_low_value) rv_low_value, UPPER(rv_meaning) rv_meaning
                        FROM (SELECT DISTINCT tran_flag 
                                FROM giac_acctrans
                             ) a,
                             (SELECT rv_low_value, rv_meaning 
                                FROM cg_ref_codes 
                               WHERE rv_domain IN ('GIAC_ACCTRANS.TRAN_FLAG')
                             ) b 
                       WHERE a.tran_flag = b.rv_low_value (+)
                       UNION ALL 
                      SELECT 'ALL','ALL' 
                        FROM DUAL)
               WHERE (UPPER(rv_low_value) LIKE UPPER(NVL(p_status,'%')) 
                  OR UPPER(rv_meaning) LIKE UPPER(NVL(p_status,'%')))
        )
        LOOP
            v_stat.rv_meaning := i.rv_meaning;
            v_stat.rv_low_value := i.rv_low_value;
            PIPE ROW(v_stat);
        END LOOP;
        
    END get_all_status; 
	
        --optimized query --john 2.26.2015
    FUNCTION get_actg_transaction_status2 (
          p_fund_cd     GIAC_ACCTRANS.gfun_fund_cd%TYPE,   
          p_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
          p_tran_flag   GIAC_ACCTRANS.tran_flag%TYPE,
          p_from        NUMBER,
          p_to          NUMBER,
          p_tran_class  GIAC_ACCTRANS.tran_class%TYPE,
          p_tran_no     VARCHAR2,
          p_tran_date   VARCHAR2,--GIAC_ACCTRANS.tran_date%TYPE,
          p_posting_date  VARCHAR2,--GIAC_ACCTRANS.posting_date%TYPE,
          p_tran_flag2  GIAC_ACCTRANS.tran_flag%TYPE,
          p_ref_no      VARCHAR2,
          p_order_by      	VARCHAR2,
          p_asc_desc_flag   VARCHAR2
    ) 
        RETURN actg_list_transaction_tab2 PIPELINED 
    IS
        v_list actg_list_transaction_status2;
        
        TYPE cur_type IS REF CURSOR;
        c       cur_type;
        v_rec   actg_list_transaction_status2;
        v_sql   VARCHAR2(9000);
    BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.tran_class, 
                                       d.rv_meaning tran_class_desc,
                                       a.tran_year 
                                        || DECODE(a.tran_month,
                                                    NULL, '''', ''-'' || TRIM(TO_CHAR (a.tran_month, ''09''))) 
                                        || DECODE(a.tran_seq_no, 
                                                    NULL, '''', ''-'' || TRIM(TO_CHAR (a.tran_seq_no, ''000009''))) tran_no,
                                       a.tran_date,
                                       a.posting_date,
                                       a.tran_id,
                                       c.rv_meaning AS TRAN_FLAG,
                                       a.particulars, 
                                       a.user_id,
                                       TO_CHAR(a.last_update, ''MM-DD-YYYY HH:MI:SS AM'') last_update,
                                       c.rv_low_value, tran_class_no
                                  FROM GIAC_ACCTRANS a, CG_REF_CODES c, CG_REF_CODES d
                                 WHERE a.tran_flag <> ''D''
                                   AND c.rv_low_value = a.tran_flag
                                   AND c.rv_domain = ''GIAC_ACCTRANS.TRAN_FLAG''
                                   AND d.rv_low_value = a.tran_class
                                   AND d.rv_domain = ''GIAC_ACCTRANS.TRAN_CLASS''
                                   AND a.gibr_branch_cd = :p_branch_cd
                                   AND a.tran_flag = NVL(:p_tran_flag, a.tran_flag)
                                   AND UPPER(gfun_fund_cd) = UPPER(:p_fund_cd) ';
      
      IF p_tran_class IS NOT NULL THEN
       v_sql := v_sql || ' AND a.tran_class LIKE UPPER('''|| p_tran_class ||''')';
      END IF;
      
      IF p_tran_no IS NOT NULL THEN
       v_sql := v_sql || ' AND a.tran_year || DECODE (a.tran_month, NULL, '''', ''-'' || TRIM (TO_CHAR (a.tran_month, ''09'')))
                    || DECODE (a.tran_seq_no, NULL, '''', ''-'' || TRIM (TO_CHAR (a.tran_seq_no, ''000009'')))  LIKE UPPER('''|| p_tran_no || ''')' ;
      END IF;
      
      IF  p_tran_date IS NOT NULL THEN
       v_sql := v_sql || ' AND TRUNC(a.tran_date) LIKE TO_DATE('''||p_tran_date||''',''MM-DD-YYYY'') ';
      END IF;
      
      IF  p_posting_date IS NOT NULL THEN
       v_sql := v_sql || ' AND TRUNC(a.posting_date) LIKE TO_DATE('''||p_posting_date||''',''MM-DD-YYYY'') ';
      END IF;
      
      IF  p_tran_flag2 IS NOT NULL THEN
       v_sql := v_sql || ' AND UPPER(c.rv_meaning) LIKE UPPER('''||p_tran_flag2||''') ';
      END IF;
      
      IF  p_ref_no IS NOT NULL THEN
       v_sql := v_sql || ' AND get_ref_no(a.tran_id) LIKE UPPER('''||p_ref_no||''') ';
      END IF;
      
      IF p_order_by IS NOT NULL AND p_order_by != 'refNo' THEN
        IF p_order_by = 'tranClass' THEN        
          v_sql := v_sql || ' ORDER BY tran_class ';
        ELSIF p_order_by = 'tranNo' THEN
          v_sql := v_sql || ' ORDER BY tran_no ';
        ELSIF p_order_by = 'tranDate' THEN
          v_sql := v_sql || ' ORDER BY tran_date ';
        ELSIF p_order_by = 'postingDate' THEN
          v_sql := v_sql || ' ORDER BY posting_date ';
        ELSIF p_order_by = 'tranFlag' THEN
          v_sql := v_sql || ' ORDER BY tran_flag ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
      
                                            
      v_sql := v_sql || ' )innersql  ) outersql) mainsql WHERE rownum_ BETWEEN ' || p_from ||' AND ' || p_to;
      
      OPEN c FOR v_sql USING p_branch_cd, p_tran_flag, p_fund_cd;
      LOOP    
        FETCH c INTO
            v_rec.count_,            
            v_rec.rownum_,
            v_rec.tran_class,            
            v_rec.tran_class_desc, 
            v_rec.tran_no,           
            v_rec.tran_date,         
            v_rec.posting_date,   
            v_rec.tran_id,        
            v_rec.tran_flag,         
            v_rec.particulars,       
            v_rec.user_id,           
            v_rec.last_update,       
            v_rec.rv_low_value,
            v_rec.tran_class_no;   
        
            v_rec.ref_no       := get_ref_no(v_rec.tran_id);
        
        EXIT WHEN c%NOTFOUND;  
        PIPE ROW (v_rec);
      END LOOP;      
      
      CLOSE c;
                         
        
    END get_actg_transaction_status2;
    
END;
/


