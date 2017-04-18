CREATE OR REPLACE PACKAGE BODY CPI.gicls256_pkg
AS

   FUNCTION populate_gicls256_details (
      p_line_cd       giis_line.line_cd%TYPE,
      p_loss_cat      giis_loss_ctgry.loss_cat_cd%TYPE,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_date    VARCHAR2,
      p_search_by     VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN gicls256_details_tab PIPELINED
   AS
      ntt   gicls256_details_type;
   BEGIN
      FOR i IN (SELECT   f.line_cd || '-' || f.line_name line_name,
                         d.loss_cat_des loss_cat_des,
                            e.line_cd
                         || '-'
                         || e.subline_cd
                         || '-'
                         || e.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (e.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (e.clm_seq_no, '0000009'))
                                                                claim_number,
                            e.line_cd
                         || '-'
                         || e.subline_cd
                         || '-'
                         || e.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (e.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (e.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (e.renew_no, '09')) policy_number,
                         e.assured_name assuredname,
                         e.dsp_loss_date dsp_loss_date,
                            --LTRIM (TO_CHAR (b.item_no, '00009'))
                         --|| '-'
                         --|| 
                         b.item_title item,
                         clm_file_date,
                         b.item_title item_title, c.peril_name peril_name,
                         e.claim_id, b.item_no, a.peril_cd,
                         (NVL(g.convert_rate,0) * nvl(g.loss_reserve,0)) loss_reserve,
                         NVL(g.losses_paid,0) losses_paid,
                         (NVL(g.convert_rate,0) * nvl(g.expense_reserve,0)) exp_reserve, 
                         NVL(g.expenses_paid,0) exp_paid, h.clm_stat_desc
                    FROM gicl_item_peril a,
                         gicl_clm_item b,
                         giis_peril c,
                         giis_loss_ctgry d,
                         gicl_claims e,
                         giis_line f,
                         gicl_clm_reserve g,
                         giis_clm_stat h
                   WHERE a.claim_id = b.claim_id
                     AND a.grouped_item_no = b.grouped_item_no
                     AND e.claim_id = a.claim_id
                     AND d.line_cd = a.line_cd
                     AND e.line_cd = a.line_cd
                     AND d.loss_cat_cd = a.loss_cat_cd
                     AND a.peril_cd = c.peril_cd
                     AND a.line_cd = c.line_cd
                     AND d.line_cd = p_line_cd
                     AND f.line_cd = p_line_cd
                     AND d.loss_cat_cd = p_loss_cat
                     AND a.item_no = b.item_no
                     AND g.claim_id(+) = a.claim_id
                     AND g.peril_cd(+) = a.peril_cd
                     AND g.item_no(+) = a.item_no
                     AND h.clm_stat_cd = e.clm_stat_cd
                     AND check_user_per_iss_cd2(a.line_cd, iss_cd, 'GICLS256',p_user) = 1
                     AND ((DECODE (p_search_by,'lossDate', TO_DATE(e.loss_date),'claimFileDate', TO_DATE(e.clm_file_date)) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
                          AND (DECODE (p_search_by,'lossDate', TO_DATE(e.loss_date),'claimFileDate', TO_DATE(e.clm_file_date)) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
                           OR (DECODE (p_search_by,'lossDate', TO_DATE(e.loss_date),'claimFileDate', TO_DATE(e.clm_file_date)) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
                     )
                ORDER BY claim_number, policy_number)
      LOOP
         ntt.line_name      := i.line_name;
         ntt.loss_cat_des   := i.loss_cat_des;
         ntt.claim_number   := i.claim_number;
         ntt.policy_number  := i.policy_number;
         ntt.assured_name   := i.assuredname;
         ntt.dsp_loss_date  := i.dsp_loss_date;
         ntt.clm_file_date  := i.clm_file_date;
         ntt.item           := i.item;
         ntt.peril_name     := i.peril_name;
         ntt.loss_reserve   := i.loss_reserve;
         ntt.exp_reserve    := i.exp_reserve;
         ntt.loss_paid      := i.losses_paid;
         ntt.exp_paid       := i.exp_paid;
         ntt.item_no        :=  TO_CHAR(i.item_no,'00009');
         ntt.clm_stat_desc  := i.clm_stat_desc;
         
         IF ntt.tot_loss_reserve IS NULL
           AND ntt.tot_exp_reserve IS NULL
           AND ntt.tot_loss_paid IS NULL
           AND ntt.tot_exp_paid IS NULL
         THEN
            FOR i IN (
                   SELECT
                         SUM((NVL(g.convert_rate,0) * NVL(g.loss_reserve,0))) tot_loss_reserve,
                         SUM(NVL(g.losses_paid,0)) tot_losses_paid,
                         SUM((NVL(g.convert_rate,0) * NVL(g.expense_reserve,0))) tot_exp_reserve, 
                         SUM(NVL(g.expenses_paid,0)) tot_exp_paid
                    FROM gicl_item_peril a,
                         gicl_clm_item b,
                         giis_peril c,
                         giis_loss_ctgry d,
                         gicl_claims e,
                         giis_line f,
                         gicl_clm_reserve g
                   WHERE a.claim_id = b.claim_id
                     AND a.grouped_item_no = b.grouped_item_no
                     AND e.claim_id = a.claim_id
                     AND d.line_cd = a.line_cd
                     AND e.line_cd = a.line_cd
                     AND d.loss_cat_cd = a.loss_cat_cd
                     AND a.peril_cd = c.peril_cd
                     AND a.line_cd = c.line_cd
                     AND d.line_cd = p_line_cd
                     AND f.line_cd = p_line_cd
                     AND d.loss_cat_cd = p_loss_cat
                     AND a.item_no = b.item_no
                     AND g.claim_id(+) = a.claim_id
                     AND g.peril_cd(+) = a.peril_cd
                     AND g.item_no(+) = a.item_no
                     AND check_user_per_line (a.line_cd, iss_cd, 'GICLS256') = 1
                     AND ((DECODE (p_search_by,'lossDate', e.loss_date,'claimFileDate', e.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
                          AND (DECODE (p_search_by,'lossDate', e.loss_date,'claimFileDate', e.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
                           OR (DECODE (p_search_by,'lossDate', e.loss_date,'claimFileDate', e.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
                     ))
                     
           LOOP
                 ntt.tot_loss_reserve   := i.tot_loss_reserve;
                 ntt.tot_exp_reserve    := i.tot_exp_reserve;
                 ntt.tot_loss_paid      := i.tot_losses_paid;
                 ntt.tot_exp_paid       := i.tot_exp_paid;
           END LOOP;
          END IF;
         
         PIPE ROW (ntt);
      END LOOP;

      RETURN;
   END populate_gicls256_details;
   
   FUNCTION validate_line_per_linename(
      p_line_name     GIIS_LINE.line_name%TYPE
   )
      RETURN VARCHAR2
   IS
      temp_x   VARCHAR2(5);
   BEGIN
   
        SELECT TO_CHAR(SUM(1))
          INTO temp_x
          FROM (
             SELECT DISTINCT line_cd
               FROM giis_line
              WHERE UPPER(line_name) LIKE UPPER(p_line_name)
                 OR UPPER(line_cd) LIKE UPPER(p_line_name)
          );
          
          IF temp_x IS NOT NULL
          THEN
            RETURN '1';
          ELSE
            RETURN '0';
          END IF;
   
   END validate_line_per_linename;
   
  
   FUNCTION validate_loss_cat_desc(
      p_line_cd       giis_line.line_cd%TYPE,
      p_loss_cat_des  giis_loss_ctgry.loss_cat_des%TYPE
   )
      RETURN VARCHAR2
   IS
      v_temp_x    VARCHAR2(1);
   BEGIN
   
    SELECT(
        /*SELECT 'X'
          FROM giis_loss_ctgry a, gicl_item_peril b 
         WHERE a.line_cd = b.line_cd 
           AND a.line_cd = NVL(p_line_cd,b.line_cd) 
           AND a.loss_cat_cd = b.loss_cat_cd
           AND (UPPER(a.loss_cat_des) LIKE UPPER(NVL(p_loss_cat_des,'%')) OR UPPER(b.loss_cat_cd) LIKE UPPER(NVL(p_loss_cat_des,'%')))*/
           
           SELECT 'X'
              FROM giis_loss_ctgry a
             WHERE a.line_cd = nvl(p_line_cd,A.line_cd) 
               AND (UPPER(a.loss_cat_des) LIKE UPPER(NVL(p_loss_cat_des,'%')) OR UPPER(a.loss_cat_cd) LIKE UPPER(NVL(p_loss_cat_des,'%')))
    )
      INTO v_temp_x
      FROM DUAL;
     
    
    IF v_temp_x IS NOT NULL
    THEN
        RETURN '1';
    ELSE
        RETURN '0';
    END IF;
   
   END validate_loss_cat_desc;
   
   FUNCTION fetch_valid_loss_cat(
      p_line_cd       giis_line.line_cd%TYPE
   )
      RETURN loss_cat_det_tab PIPELINED
   IS
      ntt     loss_cat_det_type;
      v_count NUMBER(5);
   BEGIN
   
      SELECT ( 
       SELECT DISTINCT COUNT(a.loss_cat_cd)
        FROM giis_loss_ctgry a, gicl_item_peril b 
       WHERE a.line_cd = b.line_cd 
         AND a.line_cd = NVL(p_line_cd,b.line_cd)
         AND a.loss_cat_cd = b.loss_cat_cd
      )
        INTO v_count
        FROM DUAL;
        
        IF v_count = 1
         THEN
           SELECT a.loss_cat_cd,a.loss_cat_des
             INTO ntt.loss_cat_cd, ntt.loss_cat_desc
             FROM giis_loss_ctgry a, gicl_item_peril b 
            WHERE a.line_cd = b.line_cd 
              AND a.line_cd = NVL(p_line_cd,b.line_cd)
              AND a.loss_cat_cd = b.loss_cat_cd;
        ELSE
         ntt.loss_cat_desc := 'F';
        END IF;
       
      PIPE ROW(ntt); 
   
   END fetch_valid_loss_cat;
   
   FUNCTION fetch_valid_lines(
      p_module_id         VARCHAR2
   )
      RETURN line_cd_list_tab PIPELINED
   IS
      ntt line_cd_list_type;
   
   BEGIN
   
    FOR i IN (
      SELECT DISTINCT  f.line_cd
        FROM gicl_item_peril a,
             gicl_clm_item b,
        --     giis_peril c,
             giis_loss_ctgry d,
             gicl_claims e,
             giis_line f,
             gicl_clm_reserve g
       WHERE a.claim_id = b.claim_id
         AND a.grouped_item_no = b.grouped_item_no
         AND e.claim_id = a.claim_id
         AND d.line_cd = a.line_cd
         AND e.line_cd = a.line_cd
         AND d.loss_cat_cd = a.loss_cat_cd
     --    AND a.peril_cd = c.peril_cd
      --   AND a.line_cd = c.line_cd
         AND e.claim_id = a.claim_id  -- grace 03.14.2016 added missing links. UCPB SR 21853
         AND G.CLAIM_ID = a.claim_id
         AND g.item_no  = a.item_no 
         AND g.peril_cd = a.peril_cd
         AND f.line_cd = a.line_cd
         AND check_user_per_line (a.line_cd, iss_cd, p_module_id) = 1
    )
    
    LOOP
        IF LENGTH(i.line_cd) > 0
        THEN
            ntt.line_cd := i.line_cd;
        END IF;
    PIPE ROW(ntt);
    END LOOP;
    RETURN;
   
   END;
   
   
   PROCEDURE populate_gicls256_totals (
      p_line_cd               IN     giis_line.line_cd%TYPE,
      p_loss_cat              IN     giis_loss_ctgry.loss_cat_cd%TYPE,
      p_from_date             IN     VARCHAR2,
      p_to_date               IN     VARCHAR2,
      p_as_of_date            IN     VARCHAR2,
      p_search_by             IN     VARCHAR2,
      p_user                  IN     VARCHAR2,
      tot_loss_reserve           OUT NUMBER,
      tot_exp_reserve            OUT NUMBER,
      tot_loss_paid              OUT NUMBER,
      tot_exp_paid               OUT NUMBER
    )
    IS
    BEGIN
        SELECT SUM(NVL(g.convert_rate,0) * nvl(g.loss_reserve,0)) loss_reserve,
               SUM(NVL(g.losses_paid,0)) losses_paid,
               SUM(NVL(g.convert_rate,0) * nvl(g.expense_reserve,0)) exp_reserve, 
               SUM(NVL(g.expenses_paid,0)) exp_paid
          INTO tot_loss_reserve, tot_loss_paid, tot_exp_reserve, tot_exp_paid
          FROM   gicl_item_peril a,
                 gicl_clm_item b,
                 giis_peril c,
                 giis_loss_ctgry d,
                 gicl_claims e,
                 giis_line f,
                 gicl_clm_reserve g,
                 giis_clm_stat h
         WHERE a.claim_id = b.claim_id
           AND a.grouped_item_no = b.grouped_item_no
           AND e.claim_id = a.claim_id
           AND d.line_cd = a.line_cd
           AND e.line_cd = a.line_cd
           AND d.loss_cat_cd = a.loss_cat_cd
           AND a.peril_cd = c.peril_cd
           AND a.line_cd = c.line_cd
           AND d.line_cd = p_line_cd
           AND f.line_cd = p_line_cd
           AND d.loss_cat_cd = p_loss_cat
           AND a.item_no = b.item_no
           AND g.claim_id(+) = a.claim_id
           AND g.peril_cd(+) = a.peril_cd
           AND g.item_no(+) = a.item_no
           AND h.clm_stat_cd = e.clm_stat_cd
           AND check_user_per_iss_cd2(a.line_cd, iss_cd, 'GICLS256',p_user) = 1
           AND ((DECODE (p_search_by,'lossDate', TO_DATE(e.loss_date),'claimFileDate', TO_DATE(e.clm_file_date)) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
           AND (DECODE (p_search_by,'lossDate', TO_DATE(e.loss_date),'claimFileDate', TO_DATE(e.clm_file_date)) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
            OR (DECODE (p_search_by,'lossDate', TO_DATE(e.loss_date),'claimFileDate', TO_DATE(e.clm_file_date)) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
         );
    EXCEPTION
        WHEN OTHERS THEN
            tot_loss_reserve := 0;
            tot_exp_reserve  := 0;
            tot_loss_paid    := 0;
            tot_exp_paid     := 0;
    END;
   
END gicls256_pkg;
/


