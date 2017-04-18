CREATE OR REPLACE PACKAGE BODY CPI.GIEXS008_PKG
AS
   /*
   **  Created by   :  Kenneth Mark Labrador
   **  Date Created : 08.02.2013
   **  Description  : For GIEXS008 - Assign Extracted Expiry Record to a New User
   */
   FUNCTION get_expiry_record (     --modified by Gzelle 06302015 SR3933
     p_user_id        VARCHAR2,
     p_policy_no      VARCHAR2,
     p_assd_name      VARCHAR2,
     p_expiry_date    VARCHAR2,
     p_extract_user   VARCHAR2,
     p_order_by       VARCHAR2,
     p_asc_desc_flag  VARCHAR2,
     p_from           NUMBER,
     p_to             NUMBER,
     p_from_date      VARCHAR2,
     p_to_date        VARCHAR2,
     p_line_cd        giex_expiry.line_cd%TYPE,
     p_subline_cd     giex_expiry.subline_cd%TYPE,
     p_iss_cd         giex_expiry.iss_cd%TYPE,
     p_cred_branch    giex_expiry.iss_cd%TYPE,
     p_intm_no        giis_intermediary.intm_no%TYPE,
     p_by_date        VARCHAR2      
   )                                --end Gzelle 06302015 SR3933
      RETURN giexs008_expiry_record_tab PIPELINED
   IS
      --v_rec           giexs008_expiry_record_type;    Gzelle 06302015 SR3933 replaced with codes below - start
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec giexs008_expiry_record_type;
      v_sql VARCHAR2(9000);         --end Gzelle 06302015 SR3933                     
      v_all_user_sw     VARCHAR2(1);

   BEGIN
      SELECT all_user_sw
        INTO v_all_user_sw
        FROM giis_users
       WHERE user_id = p_user_id;
      
      v_sql := 'SELECT mainsql.*
                       FROM (
                        SELECT COUNT (1) OVER () count_, outersql.* 
                          FROM (
                                SELECT ROWNUM rownum_, innersql.*
                                  FROM (
                                        SELECT   x.line_cd, x.subline_cd, x.iss_cd, x.intm_no, x.issue_yy, x.pol_seq_no, x.renew_no, 
                                                 x.assd_name, x.expiry_date, TO_CHAR(x.expiry_date,''MM-dd-YYYY'') expiry_date_string,
                                                 TO_CHAR(x.extract_date,''MM-dd-YYYY'') extract_date_string, x.extract_user, x.tsi_amt,
                                                 x.policy_id, x.pack_policy_id, x.assd_no,
                                                 NVL (x.is_package, ''Y'') is_package,
                                                 (   x.line_cd
                                                  || '' - ''
                                                  || x.subline_cd
                                                  || '' - ''
                                                  || x.iss_cd
                                                  || '' - ''
                                                  || LTRIM (TO_CHAR (x.issue_yy, ''09''))
                                                  || '' - ''
                                                  || LTRIM (TO_CHAR (x.pol_seq_no, ''0999999''))
                                                  || '' - ''
                                                  || LTRIM (TO_CHAR (x.renew_no, ''09''))
                                                 ) policy_no, NVL(x.post_flag, ''N'') post_flag, x.cred_branch
                                            FROM giex_expiries_v x
                                           WHERE NVL (x.post_flag, ''N'') = ''N''
                                             AND (x.line_cd, x.iss_cd) IN 
                                                    (SELECT line_cd, branch_cd
                                                       FROM TABLE(security_access.get_branch_line(''UW'',''GIEXS008'',:p_user_id)))
                                            ';

      IF v_all_user_sw <> 'Y' THEN
        v_sql := v_sql || ' AND x.extract_user = '''||p_user_id||''''; --change to extract_user by carlo  01-30-2017 SR 23540
      END IF;

      IF p_line_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (x.line_cd) LIKE '''||UPPER(p_line_cd)||'''';
      END IF; 

      IF p_subline_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (x.subline_cd) LIKE '''||UPPER(p_subline_cd)||'''';
      END IF;  

      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (x.iss_cd) LIKE '''||UPPER(p_iss_cd)||'''';
      END IF;         
      
      IF p_cred_branch IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (x.cred_branch) LIKE '''||UPPER(p_cred_branch)||'''';
      END IF;        

      IF p_intm_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND x.intm_no = '||p_intm_no;
      END IF;  
      
      IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND DECODE ('''||p_by_date||''',
                                            ''BYEXPIRY'', TRUNC (expiry_date),
                                            TRUNC (extract_date)) >= TRUNC (TO_DATE ('''||p_from_date||''', ''MM-DD-YYYY''))
                            AND DECODE ('''||p_by_date||''',
                                            ''BYEXPIRY'', TRUNC (expiry_date),
                                            TRUNC (extract_date)) <= TRUNC (TO_DATE ('''||p_to_date||''', ''MM-DD-YYYY''))';
      END IF;                                              

      IF p_policy_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (x.line_cd
                                      || '' - ''
                                      || x.subline_cd
                                      || '' - ''
                                      || x.iss_cd
                                      || '' - ''
                                      || LTRIM (TO_CHAR (x.issue_yy, ''09''))
                                      || '' - ''
                                      || LTRIM (TO_CHAR (x.pol_seq_no, ''0999999''))
                                      || '' - ''
                                      || LTRIM (TO_CHAR (x.renew_no, ''09''))
                                     ) LIKE '''|| UPPER(p_policy_no)||'''';
      END IF; 

      IF p_assd_name IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (assd_name) LIKE '''||UPPER(p_assd_name)||'''';
      END IF;    

      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND expiry_date = '''||TO_DATE(p_expiry_date,'MM-DD-RRRR')||'''';
      END IF;      

      IF p_extract_user IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (extract_user) LIKE '''||UPPER(p_extract_user)||'''';
      END IF;  
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'policyNo'
        THEN     
          v_sql := v_sql || ' ORDER BY policy_no ';
        ELSIF p_order_by = 'dspAssured'
        THEN 
          v_sql := v_sql || ' ORDER BY assd_name ';    
        ELSIF p_order_by = 'expiryDateString'
        THEN 
          v_sql := v_sql || ' ORDER BY expiry_date ';
        ELSIF p_order_by = 'extractUser'
        THEN 
          v_sql := v_sql || ' ORDER BY extract_user ';                      
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      ELSE 
        v_sql := v_sql || ' ORDER BY x.line_cd,
                                     x.subline_cd,
                                     x.iss_cd,
                                     x.issue_yy,
                                     x.pol_seq_no,
                                     x.renew_no'; 
      END IF;
                                       
      v_sql := v_sql || '       ) innersql 
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                                       
                     
      OPEN c FOR v_sql USING p_user_id;
      LOOP
         FETCH c INTO 
            v_rec.count_,
            v_rec.rownum_,
            v_rec.line_cd,
            v_rec.subline_cd,
            v_rec.iss_cd,
            v_rec.intm_no,
            v_rec.issue_yy,
            v_rec.pol_seq_no,
            v_rec.renew_no,
            v_rec.dsp_assured,
            v_rec.expiry_date,
            v_rec.expiry_date_string,
            v_rec.extract_date_string,
            v_rec.extract_user,
            v_rec.tsi_amt,
            v_rec.policy_id,
            v_rec.pack_policy_id,
            v_rec.assd_no,
            v_rec.is_package,
            v_rec.policy_no,
            v_rec.post_flag,
            v_rec.cred_branch
            ;

         EXIT WHEN c%NOTFOUND; 

         PIPE ROW (v_rec);
      END LOOP;
      CLOSE c;
   END get_expiry_record;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_iss_cd VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_line   line_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name                         --start Gzelle 08052015 SR4744
                  FROM giis_line a
                 WHERE EXISTS (
                          SELECT 1
                            FROM giis_issource
                           WHERE check_user_per_iss_cd2 (line_cd,
                                                         NVL (p_iss_cd, iss_cd),
                                                         'GIEXS008',
                                                         p_user_id
                                                        ) = 1))   --end Gzelle 08052015 SR4744
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;
   END get_line_lov;

   FUNCTION get_subline_lov (p_line_cd VARCHAR2)
      RETURN subline_lov_tab PIPELINED
   IS
      v_subline   subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = NVL (p_line_cd, line_cd))
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.subline_name := i.subline_name;
         PIPE ROW (v_subline);
      END LOOP;
   END get_subline_lov;

   FUNCTION get_iss_lov (p_user_id VARCHAR2, p_line_cd VARCHAR2)
      RETURN iss_lov_tab PIPELINED
   IS
      v_iss   iss_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE iss_cd =
                          DECODE (check_user_per_iss_cd2 (p_line_cd,
                                                          iss_cd,
                                                          'GIEXS008',
                                                          p_user_id
                                                         ),
                                  1, iss_cd,
                                  NULL
                                 ))
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
   END get_iss_lov;
   
   FUNCTION get_cred_branch_lov        --start - Gzelle 07102015 SR4744
      RETURN iss_lov_tab PIPELINED
   IS
      v_cred   iss_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource)
      LOOP
         v_cred.iss_cd := i.iss_cd;
         v_cred.iss_name := i.iss_name;
         PIPE ROW (v_cred);
      END LOOP;
   END get_cred_branch_lov;           --end -  Gzelle 07102015 SR4744

   FUNCTION get_intm_lov
      RETURN intm_lov_tab PIPELINED
   IS
      v_intm   intm_lov_type;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name
                  FROM giis_intermediary
                 WHERE NVL (active_tag, 'I') <> 'I')    --modified by Gzelle 07092015 restrict query to active intm
      LOOP
         v_intm.intm_no := i.intm_no;
         v_intm.intm_name := i.intm_name;
         PIPE ROW (v_intm);
      END LOOP;
   END get_intm_lov;

    FUNCTION get_user_lov (                      --added by Gzelle 06252015 SR3935
       p_policy_id    VARCHAR2,
       p_line_cd      VARCHAR2,
       p_iss_cd       VARCHAR2,
       p_status_tag   VARCHAR2,
       p_user_id      VARCHAR2,
       p_to           VARCHAR2
    )                                                                        --end
       RETURN user_lov_tab PIPELINED
    IS
       v_user              user_lov_type;

       TYPE v_type IS RECORD (                  --added by Gzelle 06292015 SR3935
          user_id     giis_users.user_id%TYPE,
          user_name   giis_users.user_name%TYPE,
          user_grp    giis_users.user_grp%TYPE
       );

       TYPE v_tab IS TABLE OF v_type;

       TYPE v_type1 IS RECORD (
          policy_id   gipi_polbasic.policy_id%TYPE
       );

       TYPE v_tab1 IS TABLE OF v_type1;

       v_list_bulk         v_tab;
       v_list_bulk1        v_tab1;
       v_query             VARCHAR2 (30000);
       v_dyn_query         VARCHAR2 (30000);
       v_temp              VARCHAR2 (30000) := p_policy_id;
       v_policy_id         VARCHAR2 (30000);
       v_temp_line         VARCHAR2 (30000);
       v_temp_iss          VARCHAR2 (30000);
       v_untagged_pol_id   VARCHAR2 (30000);                                 --end
       
       --nieko 04042017, SR 23540
       v_temp2             VARCHAR2 (30000);
       v_temp3             VARCHAR2 (30000);
       v_policy_id2        VARCHAR2 (30000);
       v_policy_id3        VARCHAR2 (30000);
    BEGIN
       /*FOR i IN (SELECT   user_id, user_name, user_grp --start Gzelle 06292015 SR3935
                     FROM giis_users
                    WHERE active_flag = 'Y'
                 ORDER BY user_id)
       LOOP
          v_user.user_id := i.user_id;
          v_user.user_name := i.user_name;
          v_user.user_grp := i.user_grp;
          PIPE ROW (v_user);
       END LOOP; modified by Gzelle 06292015 SR3935 replaced with codes below*/
       IF p_status_tag = '4T'
       THEN
          FOR a IN
             (SELECT line_cd, iss_cd
                FROM (SELECT ROW_NUMBER () OVER (PARTITION BY line_cd, iss_cd ORDER BY line_cd,
                              iss_cd) AS rno,
                             line_cd, iss_cd
                        FROM TABLE (giexs008_pkg.get_expiry_record (p_user_id,
                                                                    NULL,
                                                                    NULL,
                                                                    NULL,
                                                                    NULL,
                                                                    NULL,
                                                                    NULL,
                                                                    1,
                                                                    p_to,
                                                                    NULL,
                                                                    NULL,
                                                                    p_line_cd,
                                                                    NULL,
                                                                    p_iss_cd,
                                                                    NULL,
                                                                    NULL,
                                                                    NULL
                                                                   )
                                   )) a
               WHERE rno = 1)
          LOOP
             v_temp_line := '''' || a.line_cd || ''',' || v_temp_line;
             v_temp_iss := '''' || a.iss_cd || ''',' || v_temp_iss;
          END LOOP;
       ELSIF p_status_tag = '4S' AND v_temp IS NOT NULL
       THEN
          v_untagged_pol_id := REGEXP_REPLACE (v_temp, ',$', '');
          v_query :=
                'SELECT policy_id
                              FROM TABLE(GIEXS008_PKG.get_expiry_record('''
             || p_user_id
             || ''',NULL,NULL,NULL,NULL,NULL,NULL,1,'''
             || p_to
             || ''',NULL,NULL,'''
             || p_line_cd
             || ''',NULL,'''
             || p_iss_cd
             || ''',NULL,NULL,NULL))
                             WHERE policy_id NOT IN ('
             || v_untagged_pol_id
             || ')';

          EXECUTE IMMEDIATE v_query
          BULK COLLECT INTO v_list_bulk1;

          v_temp  := '';
          v_temp2 := '';
          v_temp3 := '';

          IF v_list_bulk1.LAST > 0
          THEN
             FOR g IN v_list_bulk1.FIRST .. v_list_bulk1.LAST
             LOOP
                --v_temp := v_list_bulk1 (g).policy_id || ',' || v_temp;
                
                --nieko 04042017, SR 23540
                IF (LENGTH(v_temp) + LENGTH(v_list_bulk1 (g).policy_id)) < 30000
                THEN
                    v_temp := v_list_bulk1 (g).policy_id || ',' || v_temp;
                ELSIF (LENGTH(v_temp2) + LENGTH(v_list_bulk1 (g).policy_id)) < 30000
                THEN
                    v_temp2 := v_list_bulk1 (g).policy_id || ',' || v_temp2;
                ELSIF (LENGTH(v_temp3) + LENGTH(v_list_bulk1 (g).policy_id)) < 30000
                THEN
                    v_temp3 := v_list_bulk1 (g).policy_id || ',' || v_temp3;    
                END IF;
             END LOOP;
          END IF;
       END IF;

       v_policy_id := REGEXP_REPLACE (v_temp, ',$', '');
       v_temp_line := REGEXP_REPLACE (v_temp_line, ',$', '');
       v_temp_iss := REGEXP_REPLACE (v_temp_iss, ',$', '');

       IF v_policy_id IS NULL
       THEN
          IF p_status_tag = '4T'
          THEN
             v_dyn_query :=
                   'AND (b.iss_cd) IN ('
                || v_temp_iss
                || ') AND (b.line_cd) IN ( '
                || v_temp_line
                || ')';
          ELSE
             v_dyn_query :=
                   'AND b.iss_cd = NVL('''|| p_iss_cd || ''',b.iss_cd)
                      AND b.line_cd = NVL('''|| p_line_cd || ''',b.line_cd)';
          END IF;
       ELSE
          v_dyn_query :=
                'AND (b.iss_cd, b.line_cd) IN (SELECT d.iss_cd, d.line_cd
                                                 FROM giex_expiries_v d
                                                WHERE d.policy_id IN ('
             || v_policy_id
             || ')) ';
       END IF;

       --nieko 04042017, SR 23540
       v_policy_id2 := REGEXP_REPLACE (v_temp2, ',$', '');
       v_policy_id3 := REGEXP_REPLACE (v_temp3, ',$', '');
       IF v_policy_id2 IS NOT NULL
       THEN
            v_dyn_query :=
                'AND (b.iss_cd, b.line_cd) IN (SELECT d.iss_cd, d.line_cd
                                                 FROM giex_expiries_v d
                                                WHERE d.policy_id IN ('
             || v_policy_id2
             || ')) ';
       END IF;
       
       IF v_policy_id3 IS NOT NULL
       THEN
            v_dyn_query :=
                'AND (b.iss_cd, b.line_cd) IN (SELECT d.iss_cd, d.line_cd
                                                 FROM giex_expiries_v d
                                                WHERE d.policy_id IN ('
             || v_policy_id3
             || ')) ';
       END IF;
       --nieko 04042017, end  
    
       v_query :=
             'SELECT a.user_id, a.user_name, a.user_grp
                             FROM giis_users a, giis_user_grp_line b, giis_user_grp_modules c
                            WHERE a.user_grp = b.user_grp
                              AND a.user_grp = c.user_grp '
          || v_dyn_query
          || 'AND b.tran_cd = c.tran_cd
                              AND c.module_id IN (''GIEXS004'', ''GIEXS008'')
                              AND a.active_flag = ''Y''
                           UNION
                           SELECT a.user_id, a.user_name, a.user_grp
                             FROM giis_users a, giis_user_line b, giis_user_modules c
                            WHERE a.user_id = b.userid
                              AND a.user_id = c.userid '
          || v_dyn_query
          || 'AND b.tran_cd = c.tran_cd
                              AND c.module_id IN (''GIEXS004'', ''GIEXS008'')
                              AND a.active_flag = ''Y''
            ';

       EXECUTE IMMEDIATE v_query
       BULK COLLECT INTO v_list_bulk;

       IF v_list_bulk.LAST > 0
       THEN
          FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
          LOOP
             v_user.user_id := v_list_bulk (i).user_id;
             v_user.user_name := v_list_bulk (i).user_name;
             v_user.user_grp := v_list_bulk (i).user_grp;
             PIPE ROW (v_user);
          END LOOP;
       END IF;                                            --Gzelle 06292015 SR3935
    END get_user_lov;

   PROCEDURE update_extracted_expiries (
      p_extract_user   giex_expiry.extract_user%TYPE,
      p_policy_id      giex_expiry.policy_id%TYPE,
      p_is_package     giex_expiries_v.is_package%TYPE
   )
   IS
   BEGIN
      IF p_is_package = 'Y'
      THEN
         UPDATE giex_pack_expiry
            SET extract_user = p_extract_user,
                last_update = SYSDATE
          WHERE pack_policy_id = p_policy_id;

         UPDATE giex_expiry
            SET extract_user = p_extract_user,
                last_update = SYSDATE
          WHERE pack_policy_id = p_policy_id;
      ELSE
         UPDATE giex_expiry
            SET extract_user = p_extract_user,
                last_update = SYSDATE
          WHERE policy_id = p_policy_id;
      END IF;
   END update_extracted_expiries;

    /*Modified by Gzelle 07162015 SR4744*/
    FUNCTION policy_id_to_array (
       p_policy_id1   VARCHAR2,
       p_policy_id2   VARCHAR2,
       p_policy_id3   VARCHAR2
    )
       RETURN policy_id_array
    IS
       i          NUMBER           := 0;
       POSITION   NUMBER           := 0;
       p_input    VARCHAR2 (30000)
                                  := p_policy_id1 || p_policy_id2 || p_policy_id3;
       output     policy_id_array;
    BEGIN
       POSITION := INSTR (p_input, ',', 1, 1);
    
       IF POSITION = 0
       THEN
          output (1) := p_input;
       END IF;
    
       WHILE (POSITION != 0)
       LOOP
          i := i + 1;
          output (i) := SUBSTR (p_input, 1, POSITION - 1);
          p_input := SUBSTR (p_input, POSITION + 1, LENGTH (p_input));
          POSITION := INSTR (p_input, ',', 1, 1);
    
          IF POSITION = 0
          THEN
             output (i + 1) := p_input;
          END IF;
       END LOOP;
    
       RETURN output;
    END policy_id_to_array;

    PROCEDURE update_expiries_by_batch (
       p_extract_user   giex_expiry.extract_user%TYPE,
       p_policy_id1     VARCHAR2,
       p_policy_id2     VARCHAR2,
       p_policy_id3     VARCHAR2,
       p_status_tag     VARCHAR2,
       p_user_id        VARCHAR2,
       p_from_date      VARCHAR2,
       p_to_date        VARCHAR2,
       p_line_cd        giex_expiry.line_cd%TYPE,
       p_subline_cd     giex_expiry.subline_cd%TYPE,
       p_iss_cd         giex_expiry.iss_cd%TYPE,
       p_cred_branch    giex_expiry.iss_cd%TYPE,
       p_intm_no        giis_intermediary.intm_no%TYPE,
       p_by_date        VARCHAR2,
       p_to             VARCHAR2
    )
    IS
       TYPE v_type IS RECORD (
          policy_id    giex_expiry.policy_id%TYPE,
          is_package   VARCHAR2 (1)
       );

       TYPE v_tab IS TABLE OF v_type;

       v_list_bulk         v_tab;
       v_policy_id         policy_id_array;
       v_ctr               NUMBER           := 0;
       v_update            BOOLEAN          := FALSE; 
       v_untagged_pol_id   VARCHAR2 (30000);
       v_query             VARCHAR2 (9000);
    BEGIN
       /* Legend for p_status_flag
        * 2S  - policy ids of the records to be reassigned will be passed through p_policy_id1, p_policy_id2, 
        *     - this happens when a user tags a record (Selected Policies)
        * 42T - all records are tagged (Tag All); policy ids will not be passed
        *     - this happens when Tag All is used or Query parameters is used without any modifications in the tagged records
        * 42S - policy ids passed are the untagged records
        *     - this happens when Tag All/Query is used then a user manually untagged other records (Selected Policies)
        */
       IF p_status_tag = '2S'
       THEN
          v_policy_id := policy_id_to_array (p_policy_id1, p_policy_id2, p_policy_id3);
          IF v_policy_id.COUNT > 0
          THEN
             v_update := TRUE;
          END IF;
       ELSIF p_status_tag = '42T'
       THEN
          FOR f IN (SELECT policy_id, is_package
                      FROM TABLE (giexs008_pkg.get_expiry_record (p_user_id,
                                                                  NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  1,
                                                                  p_to,
                                                                  p_from_date,
                                                                  p_to_date,
                                                                  p_line_cd,
                                                                  p_subline_cd,
                                                                  p_iss_cd,
                                                                  p_cred_branch,
                                                                  p_intm_no,
                                                                  p_by_date
                                                                 )
                                 ))
          LOOP
             v_ctr := v_ctr + 1;
             v_policy_id (v_ctr) := f.policy_id||'*'|| f.is_package;
          END LOOP;
          
          IF v_ctr > 0
          THEN
             v_update := TRUE;
          END IF;          
       ELSIF p_status_tag = '42S'
       THEN
          v_untagged_pol_id :=
             REGEXP_REPLACE ((p_policy_id1 || p_policy_id2 || p_policy_id3),
                             ',$',
                             ''
                            );
          v_query :=
                'SELECT policy_id, is_package 
                          FROM TABLE(GIEXS008_PKG.get_expiry_record('''
             || p_user_id
             || ''',NULL,NULL,NULL,NULL,NULL,NULL,1,'''
             || p_to
             || ''','''
             || p_from_date
             || ''','''
             || p_to_date
             || ''','''
             || p_line_cd
             || ''','''
             || p_subline_cd
             || ''','''
             || p_iss_cd
             || ''','''
             || p_cred_branch
             || ''','''
             || p_intm_no
             || ''','''
             || p_by_date
             || '''))';

          --nieko 04042017, SR 23540   
          IF v_untagged_pol_id IS NOT NULL
          THEN
            v_query := v_query || ' WHERE policy_id NOT IN ('
             || v_untagged_pol_id
             || ')';
          END IF;

          EXECUTE IMMEDIATE v_query
          BULK COLLECT INTO v_list_bulk;

          IF v_list_bulk.LAST > 0
          THEN
             FOR g IN v_list_bulk.FIRST .. v_list_bulk.LAST
             LOOP
                v_ctr := v_ctr + 1;
                v_policy_id (v_ctr) := v_list_bulk (g).policy_id ||'*'|| v_list_bulk (g).is_package;
             END LOOP;
          END IF;

          IF v_ctr > 0
          THEN
             v_update := TRUE;
          END IF;           
       END IF;

       IF v_update
       THEN
           FORALL i IN v_policy_id.FIRST .. v_policy_id.LAST
              UPDATE giex_pack_expiry
                 SET extract_user = p_extract_user,
                     last_update = SYSDATE,
                     user_id = p_user_id
               WHERE SUBSTR (v_policy_id (i), ((INSTR (v_policy_id (i), '*', 1, 1)) + 1), LENGTH (v_policy_id (i))) = 'Y' 
                 AND pack_policy_id = SUBSTR (v_policy_id (i), 1, ((INSTR (v_policy_id (i), '*', 1, 1)) - 1));
           FORALL i IN v_policy_id.FIRST .. v_policy_id.LAST
              UPDATE giex_expiry
                 SET extract_user = p_extract_user,
                     last_update = SYSDATE
               WHERE SUBSTR (v_policy_id (i), ((INSTR (v_policy_id (i), '*', 1, 1)) + 1), LENGTH (v_policy_id (i))) = 'Y' 
                 AND pack_policy_id = SUBSTR (v_policy_id (i), 1, ((INSTR (v_policy_id (i), '*', 1, 1)) - 1));
           FORALL i IN v_policy_id.FIRST .. v_policy_id.LAST
              UPDATE giex_expiry
                 SET extract_user = p_extract_user,
                     last_update = SYSDATE
               WHERE SUBSTR (v_policy_id (i), ((INSTR (v_policy_id (i), '*', 1, 1)) + 1), LENGTH (v_policy_id (i))) != 'Y' 
                 AND policy_id = SUBSTR (v_policy_id (i), 1, ((INSTR (v_policy_id (i), '*', 1, 1)) - 1));
       END IF;
    END update_expiries_by_batch;
    /*end Gzelle 07162015 SR4744*/

   FUNCTION check_data_by_date (
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2,
      p_by_date      VARCHAR2,
      p_mis_sw       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_intm_no      giis_intermediary.intm_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists    VARCHAR2 (1)  := 'N';
      v_mis       VARCHAR2 (1)  := p_mis_sw;
      v_by_date   VARCHAR2 (10) := p_by_date;
   BEGIN
      FOR a IN (SELECT 1
                  FROM giex_expiry
                 WHERE NVL (post_flag, 'N') = 'N'
                   AND extract_user =
                                  DECODE (v_mis,
                                          'Y', extract_user,
                                          p_user_id
                                         )
                   AND (   TRUNC (expiry_date) >=
                                   TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXPIRY', 'Y', 'N') = 'N'
                       )
                   AND (   TRUNC (expiry_date) <=
                                     TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXPIRY', 'Y', 'N') = 'N'
                       )
                   AND (   TRUNC (extract_date) >=
                                   TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXTRACT', 'Y', 'N') = 'N'
                       )
                   AND (   TRUNC (extract_date) <=
                                     TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXTRACT', 'Y', 'N') = 'N'
                       )
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND intm_no = NVL (p_intm_no, intm_no))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      FOR b IN (SELECT 1
                  FROM giex_pack_expiry
                 WHERE NVL (post_flag, 'N') = 'N'
                   AND extract_user =
                                  DECODE (v_mis,
                                          'Y', extract_user,
                                          p_user_id
                                         )
                   AND (   TRUNC (expiry_date) >=
                                   TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXPIRY', 'Y', 'N') = 'N'
                       )
                   AND (   TRUNC (expiry_date) <=
                                     TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXPIRY', 'Y', 'N') = 'N'
                       )
                   AND (   TRUNC (extract_date) >=
                                   TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXTRACT', 'Y', 'N') = 'N'
                       )
                   AND (   TRUNC (extract_date) <=
                                     TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY'))
                        OR DECODE (v_by_date, 'BYEXTRACT', 'Y', 'N') = 'N'
                       )
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND NVL (intm_no, 1) = NVL (p_intm_no, NVL (intm_no, 1)))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN (v_exists);
   END;

   FUNCTION check_data_by_user (
      p_user_id      VARCHAR2,
      p_mis_sw       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_intm_no      giis_intermediary.intm_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1) := 'N';
      v_mis      VARCHAR2 (1) := p_mis_sw;
   BEGIN
      FOR a IN (SELECT 1
                  FROM giex_expiry
                 WHERE NVL (post_flag, 'N') = 'N'
                   AND extract_user =
                                  DECODE (v_mis,
                                          'Y', extract_user,
                                          p_user_id
                                         )
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND intm_no = NVL (p_intm_no, intm_no))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN (v_exists);
   END;

   FUNCTION check_records (
      p_extract_user   VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_user_id        VARCHAR2,
      p_by_date        VARCHAR2,
      p_mis_sw         VARCHAR2,
      p_line_cd        VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_intm_no        giis_intermediary.intm_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_line_exists   VARCHAR2 (1) := 'N';
      v_exists        VARCHAR2 (1) := 'N';
      v_line_access   NUMBER;
      v_data_exists   VARCHAR2 (1);
   BEGIN
      FOR a IN (SELECT DISTINCT 1
                           FROM giex_expiries_v
                          WHERE line_cd = NVL (p_line_cd, line_cd))
      LOOP
         v_line_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_line_exists = 'N'
      THEN
         -- msg_alert('No records can be reassign using the given filters','I',TRUE);
         raise_application_error
            (-20001,
             'Geniisys Exception#I#No records can be reassign using the given filters.'
            );
      END IF;

      IF p_extract_user IS NOT NULL AND p_from_date IS NOT NULL
      THEN
         FOR a IN (SELECT user_id
                     FROM giis_users
                    WHERE user_id = p_extract_user)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'N'
         THEN
            -- MSG_ALERT('User ID does not exist in the maintenance table.','I',TRUE);
            raise_application_error
               (-20001,
                'Geniisys Exception#I#User ID does not exist in the maintenance table.'
               );
         END IF;

         SELECT check_user_per_line2 (p_line_cd,
                                      p_iss_cd,
                                      'GIEXS008',
                                      p_extract_user
                                     )
           INTO v_line_access
           FROM DUAL;

         IF v_line_access = 0
         THEN
            --msg_alert('User '||initcap(v_user)||' cannot access the given line code.', 'I', TRUE);
            raise_application_error (-20001,
                                        'Geniisys Exception#I#User '
                                     || UPPER (p_extract_user) --INITCAP (p_extract_user) changed by kenneth L. 01.22.2014
                                     || ' cannot access the given line code.'
                                    );
         ELSE
            v_data_exists :=
               check_data_by_date (p_from_date,
                                   p_to_date,
                                   p_user_id,
                                   p_by_date,
                                   p_mis_sw,
                                   p_line_cd,
                                   p_subline_cd,
                                   p_iss_cd,
                                   p_intm_no
                                  );

            IF v_data_exists = 'N'
            THEN
               IF p_mis_sw = 'Y'
               THEN
                  --msg_alert('No records can be reassign using the given filters.', 'I', TRUE);
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#I#No records can be reassign using the given filters.'
                     );
               ELSE
                  --msg_alert ('You must have MIS access or a Manager access.', 'I', TRUE);
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#I#You must have MIS access or a Manager access.'
                     );
               END IF;
            END IF;

            RETURN 'UPDATE WITH DATE';
         END IF;
      ELSIF p_extract_user IS NOT NULL AND p_from_date IS NULL
      THEN
         SELECT check_user_per_line2 (p_line_cd,
                                      p_iss_cd,
                                      'GIEXS008',
                                      p_extract_user
                                     )
           INTO v_line_access
           FROM DUAL;

         IF v_line_access = 0
         THEN
            --msg_alert('User '||initcap(v_user)||' cannot access the given line code.', 'I', TRUE);
            raise_application_error (-20001,
                                        'Geniisys Exception#I#User '
                                     || UPPER (p_extract_user) --INITCAP (p_extract_user) changed by kenneth L. 01.22.2014
                                     || ' cannot access the given line code.'
                                    );
         ELSE
            v_data_exists :=
               check_data_by_user (p_user_id,
                                   p_mis_sw,
                                   p_line_cd,
                                   p_subline_cd,
                                   p_iss_cd,
                                   p_intm_no
                                  );

            IF v_data_exists = 'N'
            THEN
               IF p_mis_sw = 'Y'
               THEN
                  --msg_alert('No records can be reassign using the given filters.', 'I', TRUE);
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#I#No records can be reassign using the given filters.'
                     );
               /*ELSE       commented out by start - Gzelle 07222015 SR4744
                  --msg_alert ('You must have MIS access or a Manager access.', 'I', TRUE);
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#I#You must have MIS access or a Manager access.'
                     );                       end - Gzelle 07222015 SR4744*/
               END IF;
            END IF;

            RETURN 'UPDATE WITHOUT DATE';
         END IF;
      ELSIF p_from_date IS NOT NULL AND p_extract_user IS NULL    
      THEN
         --msg_alert ('Please assign a user.', 'I', TRUE);
         RETURN 'EMPTY';   --Gzelle 07102015 SR4744
         /*raise_application_error      --start commented out by Gzelle 07102015 SR4744
                                (-20001,
                                 'Geniisys Exception#I#Please assign a user.'
                                );      --end commented out by Gzelle 07102015 SR4744*/                                  
      ELSIF p_from_date IS NULL AND p_extract_user IS NULL
      THEN
         -- msg_alert ('Please assign a user.', 'I', TRUE);
         RETURN 'EMPTY';   --Gzelle 07102015 SR4744
         /*raise_application_error      --start commented out by Gzelle 07102015 SR4744
                                (-20001,
                                 'Geniisys Exception#I#Please assign a user.'
                                );      --end commented out by Gzelle 07102015 SR4744*/                                  
      END IF;
   END check_records;

   FUNCTION check_subline_list (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_subline   VARCHAR2 (30);
   BEGIN
      SELECT subline_name
        INTO v_subline
        FROM giis_subline
       WHERE line_cd = NVL (p_line_cd, line_cd) AND subline_cd = p_subline_cd;

      RETURN (v_subline);
   EXCEPTION
      WHEN TOO_MANY_ROWS
      THEN
         v_subline := 'Y';
         RETURN (v_subline);
   END check_subline_list;
END GIEXS008_PKG;
/


