CREATE OR REPLACE PACKAGE BODY CPI.giac_colln_batch_pkg
AS
   PROCEDURE set_dcb_details (
      p_dcb_no      giac_colln_batch.dcb_no%TYPE,
      p_dcb_year    giac_colln_batch.dcb_year%TYPE,
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_date   giac_colln_batch.tran_date%TYPE,
      p_dcb_flag    giac_colln_batch.dcb_flag%TYPE,
      p_remarks     giac_colln_batch.remarks%TYPE
   )
   IS
      v_tran_date   VARCHAR2 (20);
   BEGIN
      BEGIN
         SELECT tran_date
           INTO v_tran_date
           FROM giac_colln_batch
          WHERE dcb_no = p_dcb_no
            AND dcb_year = p_dcb_year
            AND fund_cd = p_fund_cd
            AND branch_cd = p_branch_cd;
            --AND TRUNC (tran_date) = TRUNC (sysdate);

         IF SQL%FOUND
         THEN
            UPDATE giac_colln_batch
               SET tran_date = p_tran_date,
                   user_id = NVL (giis_users_pkg.app_user, USER),
                   last_update = SYSDATE
             WHERE dcb_no = p_dcb_no
               AND dcb_year = p_dcb_year
               AND fund_cd = p_fund_cd
               AND branch_cd = p_branch_cd;
               --AND TRUNC (tran_date) = TRUNC (sysdate);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            INSERT INTO giac_colln_batch
                        (dcb_no, dcb_year, fund_cd, branch_cd,
                         tran_date, dcb_flag, remarks, user_id, last_update
                        )
                 VALUES (p_dcb_no, p_dcb_year, p_fund_cd, p_branch_cd,
                         p_tran_date, p_dcb_flag, p_remarks, NVL (giis_users_pkg.app_user, USER), SYSDATE
                        );
      END;
   /* MERGE INTO giac_colln_batch
       USING DUAL
       ON (    dcb_no = p_dcb_no
           AND dcb_year = p_dcb_year
           AND fund_cd = p_fund_cd
           AND branch_cd = p_branch_cd
        AND TRUNC (tran_date) = TRUNC (p_tran_date))
       WHEN NOT MATCHED THEN
          INSERT (dcb_no, dcb_year, fund_cd, branch_cd, tran_date, dcb_flag,
                  remarks, user_id, last_update)
          VALUES (p_dcb_no, p_dcb_year, p_fund_cd, p_branch_cd, SYSDATE,
                  p_dcb_flag, p_remarks, USER, SYSDATE)
       WHEN MATCHED THEN
          UPDATE
             SET tran_date = SYSDATE, user_id = USER, last_update = SYSDATE*/
   END set_dcb_details;

   FUNCTION get_dcb_no (
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_date   giac_colln_batch.tran_date%TYPE
      
   )
      RETURN giac_colln_batch_tab PIPELINED
   IS
      v_dcb   giac_colln_batch_type;
   BEGIN
      FOR dcb IN (SELECT   MIN (dcb_no) min_dcb
                      --, TRUNC (tran_date) tran_date
                  FROM     giac_colln_batch
                     WHERE fund_cd = p_fund_cd
                       AND branch_cd = p_branch_cd
                       AND dcb_year = TO_NUMBER (TO_CHAR (p_tran_date, 'YYYY'))
                       AND TRUNC (tran_date) = TRUNC (p_tran_date)
                       AND dcb_flag = 'O'
                  GROUP BY TRUNC (tran_date))
      LOOP
         v_dcb.dcb_no := dcb.min_dcb;
         PIPE ROW (v_dcb);
      END LOOP;

      RETURN;
   END get_dcb_no;

   FUNCTION get_new_dcb_no (
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_date   giac_colln_batch.tran_date%TYPE
   )
      RETURN giac_colln_batch_tab PIPELINED
   IS
      v_dcb   giac_colln_batch_type;
   BEGIN
      FOR dcb IN (SELECT MAX (dcb_no) max_dcb
                    FROM giac_colln_batch
                   WHERE fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd
                     AND dcb_year = TO_NUMBER (TO_CHAR (p_tran_date, 'YYYY')))
      LOOP
         v_dcb.dcb_no := dcb.max_dcb;
         PIPE ROW (v_dcb);
      END LOOP;

      RETURN;
   END get_new_dcb_no;
   
   FUNCTION get_dcb_date_lov (p_gfun_fund_cd       GIAC_COLLN_BATCH.fund_cd%TYPE,
                                 p_gibr_branch_cd       GIAC_COLLN_BATCH.branch_cd%TYPE,
                              p_keyword               VARCHAR2)
     RETURN dcb_date_lov_tab PIPELINED
   IS
     v_dcb_date                 dcb_date_lov_type;
     v_date_search             DATE;
   BEGIN
     -- check first if search key is in date format. if yes, store it to v_date_search
     BEGIN
        v_date_search := TO_DATE (p_keyword, 'MM-DD-RRRR');
     EXCEPTION
        WHEN OTHERS THEN
           v_date_search := NULL;
     END;

     IF v_date_search IS NULL THEN
        BEGIN
           v_date_search := TO_DATE (p_keyword, 'RRRR-MM-DD');
        EXCEPTION
           WHEN OTHERS THEN
              v_date_search := NULL;
        END;
     END IF;
      
     FOR i IN (SELECT trunc(a.tran_date) tran_date, to_char(a.tran_date, 'MM-DD-YYYY') dcb_date,
                      to_number(to_char(a.tran_date, 'YYYY')) dcb_year 
                 FROM giac_colln_batch a
                WHERE a.fund_cd = p_gfun_fund_cd 
                  AND a.branch_cd = p_gibr_branch_cd                  
                  AND a.dcb_flag IN ('O' , 'X')
                  AND TRUNC (a.tran_date) = NVL (v_date_search, TRUNC (a.tran_date))
             ORDER BY 1 DESC)
     LOOP
          v_dcb_date.tran_date     := i.tran_date;
         v_dcb_date.dcb_date         := i.dcb_date;
         v_dcb_date.dcb_year         := i.dcb_year;
         
         PIPE ROW(v_dcb_date);
     END LOOP;
   END get_dcb_date_lov;
   
   FUNCTION get_dcb_no_lov (p_gfun_fund_cd           GIAC_COLLN_BATCH.fund_cd%TYPE,
                               p_gibr_branch_cd       GIAC_COLLN_BATCH.branch_cd%TYPE,
                            p_dcb_date               VARCHAR2,
                            p_dcb_year               GIAC_COLLN_BATCH.dcb_year%TYPE,
                            p_keyword               VARCHAR2)
     RETURN dcb_no_lov_tab PIPELINED
   IS
     v_dcb_no               dcb_no_lov_type;
     v_date_search           DATE;
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_date_search
     BEGIN
        v_date_search := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
     EXCEPTION
        WHEN OTHERS THEN
           v_date_search := NULL;
     END;

     IF v_date_search IS NULL THEN
        BEGIN
           v_date_search := TO_DATE (p_dcb_date, 'RRRR-MM-DD');
        EXCEPTION
           WHEN OTHERS THEN
              v_date_search := NULL;
        END;
     END IF;
     
     FOR i IN (SELECT a.dcb_no
                 FROM giac_colln_batch a
                WHERE to_char(a.tran_date,'MM-DD-RRRR') = TO_CHAR(v_date_search,'MM-DD-RRRR')
                  AND a.dcb_year = p_dcb_year
                  AND a.branch_cd = p_gibr_branch_cd
                  AND a.fund_cd = p_gfun_fund_cd
                  AND a.dcb_flag in ('O', 'X')
                  AND a.dcb_no NOT IN (SELECT gacc.tran_class_no
                                                  FROM giac_acctrans gacc 
                                          WHERE gacc.tran_class = 'CDC'
                                              AND gacc.gfun_fund_cd = p_gfun_fund_cd
                                              AND gacc.gibr_branch_cd = p_gibr_branch_cd
                                              AND trunc(gacc.tran_date) = v_date_search
                                              AND gacc.tran_year = p_dcb_year
                                              AND gacc.tran_flag <> 'D')
                  AND a.dcb_no LIKE '%' || p_keyword || '%'                  
                ORDER BY a.dcb_no DESC)
     LOOP
          v_dcb_no.dcb_no           := i.dcb_no;
     
          PIPE ROW(v_dcb_no);
     END LOOP;
   END get_dcb_no_lov;
   
   
  /*
  **    Created by:     D.alcantara
  **    Date Created:   04/08/2011
  **    Description:    Retrieves records for DCB Number Maintenance
  */
   FUNCTION get_dcb_no_details (
       p_fund_cd           GIAC_COLLN_BATCH.fund_cd%TYPE,
          p_branch_cd           GIAC_COLLN_BATCH.branch_cd%TYPE,
       p_dcb_flag          GIAC_COLLN_BATCH.dcb_flag%TYPE           
   ) RETURN colln_batch_tab PIPELINED IS
        v_dcb   colln_batch_type;
   BEGIN
      FOR i IN ( SELECT gcb.dcb_no, gcb.dcb_year, gcb.fund_cd, gcb.branch_cd,
                        gcb.tran_date, gcb.dcb_flag, gcb.remarks, user_id,
                        (SELECT rv_meaning FROM cg_ref_codes 
                            WHERE rv_domain like 'GIAC_COLLN_BATCH.DCB_FLAG'
                                 AND UPPER(rv_low_value) = UPPER(gcb.dcb_flag)) dcb_status   
                     FROM GIAC_COLLN_BATCH gcb
                   WHERE gcb.fund_cd like p_fund_cd
                         AND gcb.branch_cd like p_branch_cd
                         AND gcb.dcb_flag like p_dcb_flag)
      LOOP
        v_dcb.dcb_no      :=    i.dcb_no;
        v_dcb.dcb_year    :=    i.dcb_year;
        v_dcb.fund_cd     :=    i.fund_cd;
        v_dcb.branch_cd   :=    i.branch_cd;
        v_dcb.tran_date   :=    TRUNC(i.tran_date); -- andrew - 08.03.2012 - added trunc to remove time in display, to avoid +1day issue in formatting date in javascript
        v_dcb.dcb_flag    :=    i.dcb_flag;
        v_dcb.remarks     :=    i.remarks;  
        v_dcb.dcb_status  :=    i.dcb_status;
        v_dcb.user_id     :=    i.user_id;  
        PIPE ROW(v_dcb);
      END LOOP;  
   END get_dcb_no_details;
      
  /*
  **    Created by:     D.alcantara
  **    Date Created:   04/12/2011
  **    Description:    Retrieves the largest dcb_no value
  */
   FUNCTION get_max_dcb_no(
       p_dcb_year          GIAC_COLLN_BATCH.dcb_year%TYPE,
       p_fund_cd           GIAC_COLLN_BATCH.fund_cd%TYPE,
          p_branch_cd           GIAC_COLLN_BATCH.branch_cd%TYPE
   ) RETURN NUMBER IS
        v_num   NUMBER(6);
   BEGIN
        select nvl(max(dcb_no),0)+1
          into v_num
          from giac_colln_batch
         where dcb_year = p_dcb_year
           and branch_cd = p_branch_cd
           and fund_cd = p_fund_cd;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
            v_num := 0;
   END get_max_dcb_no;
   
  /*
  **    Created by:     D.alcantara
  **    Date Created:   04/13/2011
  **    Used in:        GIACS333 (DCB No. Maintenance)
  **    Description:    Saves/updates records to giac_colln_batch from GIACS333
  */
   PROCEDURE set_giac_colln_batch(
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_tran_date   GIAC_COLLN_BATCH.tran_date%TYPE,
        p_dcb_flag    GIAC_COLLN_BATCH.dcb_flag%TYPE,
        p_remarks     GIAC_COLLN_BATCH.remarks%TYPE,
        p_user_id     GIAC_COLLN_BATCH.user_id%TYPE
   ) IS
        v_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE;  
   BEGIN
        IF (p_dcb_no = 0 or p_dcb_no is null) THEN
            BEGIN
                select nvl(max(dcb_no),0)+1
                  into v_dcb_no
                  from giac_colln_batch
                 where dcb_year = p_dcb_year
                   and branch_cd = p_branch_cd
                   and fund_cd = p_fund_cd;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                    v_dcb_no := 1;
             END;
        ELSE
             v_dcb_no := p_dcb_no;
        END IF;
        
        MERGE INTO giac_colln_batch
            USING DUAL
        ON(dcb_year = p_dcb_year
           and branch_cd = p_branch_cd
           and fund_cd = p_fund_cd
           and dcb_no = p_dcb_no)
        WHEN NOT MATCHED THEN
            INSERT (dcb_no, dcb_year, fund_cd, branch_cd, tran_date,
                    dcb_flag, remarks, user_id, last_update)
            VALUES (v_dcb_no, p_dcb_year, p_fund_cd, p_branch_cd,
                    p_tran_date, p_dcb_flag, p_remarks, NVL(p_user_id, USER),
                    sysdate)
        WHEN MATCHED THEN
            UPDATE
              SET dcb_flag        = p_dcb_flag,
                  remarks         = p_remarks,
                  user_id         = NVL(p_user_id, USER),
                  last_update     = sysdate;
   END set_giac_colln_batch;
   
  /*
  **    Created by:     D.alcantara
  **    Date Created:   04/13/2011
  **    Used in:        GIACS333 (DCB No. Maintenance)
  **    Description:    deletes records in giac_colln_batch
  */
   PROCEDURE del_giac_colln_batch(
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE
   ) IS
   BEGIN
        DELETE FROM giac_colln_batch
        WHERE dcb_no = p_dcb_no
              AND dcb_year = p_dcb_year
              AND fund_cd = p_fund_cd
              AND branch_cd = p_branch_cd;
   END del_giac_colln_batch;
   
   /*
   **    Created By: D.Alcantara
   **    Date Created:   05/14/2011
   **    Used in:        GIACS035
   **    Description:    checks if dcb is valid for closing
   */
   FUNCTION check_valid_close_dcb (
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE 
   ) RETURN VARCHAR2 IS
        v_valid       VARCHAR2(30);
        v_dcb_flag    GIAC_COLLN_BATCH.dcb_flag%TYPE;
   BEGIN
       v_valid := 'Y';
       FOR a IN (SELECT dcb_flag
              FROM giac_colln_batch
              WHERE dcb_no = p_dcb_no
              AND dcb_year = p_dcb_year
               AND branch_cd = p_branch_cd
              AND fund_cd = p_fund_cd) 
       LOOP
        v_dcb_flag := a.dcb_flag;
            
       END LOOP; 
       
       IF v_dcb_flag = 'C' THEN
        v_valid := 'This DCB No. is already closed.';
       ELSIF v_dcb_flag IN ('O', 'X') THEN
        v_valid := 'Invalid status for DCB No. It should be T';
       END IF;
       
       RETURN v_valid;
   END check_valid_close_dcb;
   
   /*
   **    Created By: D.Alcantara
   **    Date Created:   05/16/2011
   **    Used in:        GIACS035
   **    Description:    updates dcb_flag when saving / closing a dcb
   */
   PROCEDURE update_dcb_for_closing (
        p_dcb_flag    GIAC_COLLN_BATCH.dcb_flag%TYPE,
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_user_id     GIIS_USERS.user_id%TYPE 
   ) IS
   BEGIN
        UPDATE giac_colln_batch
            SET dcb_flag = p_dcb_flag,
                user_id = NVL(p_user_id, USER),
                last_update = sysdate
        WHERE dcb_no = p_dcb_no
            AND dcb_year = p_dcb_year        
            AND branch_cd = p_branch_cd
            AND fund_cd = p_fund_cd;
   END update_dcb_for_closing;
   
   FUNCTION get_closed_tag(
           p_fund_cd      giac_tran_mm.fund_cd%TYPE,
          p_date       giac_acctrans.tran_date%TYPE,
        p_branch_cd giac_tran_mm.branch_cd%TYPE)
    RETURN VARCHAR2 IS
          v_closed_tag  giac_tran_mm.closed_tag%TYPE;
        v_param_value giac_parameters.param_value_v%TYPE;  
        v_check VARCHAR(2);      
    BEGIN
        BEGIN -- SR#18447; John Dolon; 05.25.2015
            SELECT closed_tag
              INTO v_closed_tag
              FROM giac_tran_mm
             WHERE fund_cd = p_fund_cd
               AND branch_cd = p_branch_cd
               AND tran_yr = TO_CHAR (p_date, 'YYYY')
               AND tran_mm = TO_CHAR (p_date, 'MM');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_closed_tag := 'N';
        END;
        
           
         SELECT param_value_v
         INTO  v_param_value
         FROM giac_parameters
         WHERE PARAM_NAME ='ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH'; 
         
         v_check := 'N';
         IF (v_closed_tag ='T' AND NVL(v_param_value,'Y') ='N') THEN
              v_check := 'T'; 
         ELSIF (v_closed_tag='Y' AND NVL(v_param_value,'Y')='N') THEN
            v_check := 'Y';
         END IF; 
           
      RETURN v_check;
    END get_closed_tag;
    
    FUNCTION get_dcb_date_lov2 (
       p_gfun_fund_cd     giac_colln_batch.fund_cd%TYPE,
       p_gibr_branch_cd   giac_colln_batch.branch_cd%TYPE,
       p_keyword          VARCHAR2
    )
       RETURN dcb_date_lov_tab PIPELINED
    IS
       v_dcb_date   dcb_date_lov_type;
       v_param_date VARCHAR2(20); -- SR#18447; John Dolon; 05.25.2015
    BEGIN
       BEGIN
          v_param_date := TO_DATE(p_keyword, 'MM-DD-YYYY'); 
       EXCEPTION
          WHEN OTHERS
          THEN
             v_param_date := p_keyword;
       END;

   FOR i IN (SELECT   TRUNC (a.tran_date) tran_date,
                          TO_CHAR (a.tran_date, 'MM-DD-YYYY') dcb_date,
                          TO_NUMBER (TO_CHAR (a.tran_date, 'YYYY')) dcb_year
                     FROM giac_colln_batch a
                    WHERE a.fund_cd = p_gfun_fund_cd
                      AND a.branch_cd = p_gibr_branch_cd
                      AND a.dcb_flag IN ('O', 'X')
                      AND TRUNC (a.tran_date) LIKE
                              NVL(v_param_date, TRUNC(a.tran_date)) -- SR#18447; John Dolon; 05.25.2015
                 ORDER BY 1 DESC)
       LOOP
          v_dcb_date.tran_date := i.tran_date;
          v_dcb_date.dcb_date := i.dcb_date;
          v_dcb_date.dcb_year := i.dcb_year;
          PIPE ROW (v_dcb_date);
       END LOOP;
    END get_dcb_date_lov2;
    
    /* Formatted on 2013/10/07 12:20 (Formatter Plus v4.8.8) */
    /* Formatted on 2013/10/07 12:22 (Formatter Plus v4.8.8) */
    FUNCTION get_dcb_no_lov2 (
       p_gfun_fund_cd     giac_colln_batch.fund_cd%TYPE,
       p_gibr_branch_cd   giac_colln_batch.branch_cd%TYPE,
       p_dcb_date         VARCHAR2,
       p_dcb_year         giac_colln_batch.dcb_year%TYPE,
       p_keyword          VARCHAR2
    )
       RETURN dcb_no_lov_tab PIPELINED
    IS
       v_dcb_no   dcb_no_lov_type;
    BEGIN
       FOR i IN (SELECT   a.dcb_no
                     FROM giac_colln_batch a
                    WHERE 1 =1 
                      AND TRUNC(a.tran_date) = TO_DATE (p_dcb_date, 'MM-DD-RRRR')
                      AND a.dcb_year = p_dcb_year
                      AND a.branch_cd = p_gibr_branch_cd
                      AND a.fund_cd = p_gfun_fund_cd
                      AND a.dcb_flag IN ('O', 'X')
                      AND a.dcb_no NOT IN (
                             SELECT gacc.tran_class_no
                               FROM giac_acctrans gacc
                              WHERE gacc.tran_class = 'CDC'
                                AND gacc.gfun_fund_cd = p_gfun_fund_cd
                                AND gacc.gibr_branch_cd = p_gibr_branch_cd
                                AND TRUNC (gacc.tran_date) = TO_DATE(p_dcb_date, 'MM-DD-RRRR')
                                AND gacc.tran_year = p_dcb_year
                                AND gacc.tran_flag <> 'D')
                      AND a.dcb_no LIKE '%' || p_keyword || '%'
                 ORDER BY a.dcb_no DESC)
       LOOP
          v_dcb_no.dcb_no := i.dcb_no;
          PIPE ROW (v_dcb_no);
       END LOOP;

       RETURN;
    END get_dcb_no_lov2;
   
END giac_colln_batch_pkg;
/
