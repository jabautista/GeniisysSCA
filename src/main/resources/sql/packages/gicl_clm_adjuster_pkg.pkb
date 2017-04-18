CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_adjuster_pkg
AS
   /*
   *  CREATED BY ANTHONY SANTOS AUG 24, 2011
   *  MODULE ID: GICLS010 CLAIMS BASIC INFO
   */
   FUNCTION get_clm_adjuster_listing (
      p_claim_id   gicl_clm_adjuster.claim_id%TYPE
   )
      RETURN gicl_clm_adjuster_tab PIPELINED
   IS
      v_adj   gicl_clm_adjuster_type;
   BEGIN
      FOR i IN (SELECT   claim_id, clm_adj_id, adj_company_cd, priv_adj_cd,
                         TO_CHAR (assign_date, 'mm-dd-yyyy') assign_date,
                         NVL (cancel_tag, 'N') cancel_tag,
                         TO_CHAR (complt_date, 'mm-dd-yyyy') complt_date,
                         NVL (delete_tag, 'N') delete_tag, remarks,
                         NVL (surveyor_sw, 'N') surveyor_sw
                    FROM gicl_clm_adjuster
                   WHERE claim_id = p_claim_id
                ORDER BY adj_company_cd, priv_adj_cd)
      LOOP
         v_adj.dsp_adj_co_name := '';

         FOR adj IN (SELECT    payee_last_name
                            || DECODE (payee_first_name,
                                       NULL, NULL,
                                       ', ' || payee_first_name
                                      )
                            || DECODE (payee_middle_name,
                                       NULL, NULL,
                                       ' ' || payee_middle_name
                                      ) nm
                       FROM giis_payees
                      WHERE payee_class_cd = giacp.v ('ADJP_CLASS_CD')
                        AND payee_no = i.adj_company_cd)
         LOOP
            v_adj.dsp_adj_co_name := adj.nm;
            EXIT;
         END LOOP;

         -- get private adjuster name
         v_adj.dsp_priv_adj_name := '';

         FOR priv IN (SELECT payee_name nm
                        FROM giis_adjuster
                       WHERE adj_company_cd = i.adj_company_cd
                         AND priv_adj_cd = i.priv_adj_cd)
         LOOP
            v_adj.dsp_priv_adj_name := priv.nm;
            EXIT;
         END LOOP;

         v_adj.claim_id := i.claim_id;
         v_adj.clm_adj_id := i.clm_adj_id;
         v_adj.adj_company_cd := i.adj_company_cd;
         v_adj.priv_adj_cd := i.priv_adj_cd;
         v_adj.assign_date := i.assign_date;
         v_adj.cancel_tag := i.cancel_tag;
         v_adj.complt_date := i.complt_date;
         v_adj.delete_tag := i.delete_tag;
         v_adj.remarks := i.remarks;
         v_adj.surveyor_sw := i.surveyor_sw;
         PIPE ROW (v_adj);
      END LOOP;
   END get_clm_adjuster_listing;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 11.08.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : key-delrec trigger in adjuster
    **/
   PROCEDURE pre_del_adjuster (
      p_claim_id               gicl_clm_loss_exp.claim_id%TYPE,
      p_adj_company_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_cancel           OUT   VARCHAR2,
      p_cnt_exist        OUT   VARCHAR2
   )
   IS
   BEGIN
      p_cancel := 'A';
      p_cnt_exist := 0;

      FOR chk IN (SELECT cancel_sw
                    FROM gicl_clm_loss_exp
                   WHERE claim_id = p_claim_id
                     AND payee_class_cd = giacp.v ('ADJP_CLASS_CD')
                     AND payee_cd = p_adj_company_cd
                     AND payee_type = 'E')
      LOOP
         p_cancel := NVL (chk.cancel_sw, 'N');
         EXIT;
      END LOOP;

      FOR cnt IN (SELECT COUNT (*) exist
                    FROM gicl_clm_adjuster
                   WHERE claim_id = p_claim_id
                     AND adj_company_cd = p_adj_company_cd
                     AND NVL (delete_tag, 'N') = 'N'
                     AND NVL (cancel_tag, 'N') = 'N')
      LOOP
         p_cnt_exist := cnt.exist;
         EXIT;
      END LOOP;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 11.08.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : Insert/Update record
    **/
   PROCEDURE set_gicl_clm_adjuster (
      p_clm_adj_id       gicl_clm_adjuster.clm_adj_id%TYPE,
      p_claim_id         gicl_clm_adjuster.claim_id%TYPE,
      p_adj_company_cd   gicl_clm_adjuster.adj_company_cd%TYPE,
      p_priv_adj_cd      gicl_clm_adjuster.priv_adj_cd%TYPE,
      p_assign_date      gicl_clm_adjuster.assign_date%TYPE,
      p_cancel_tag       gicl_clm_adjuster.cancel_tag%TYPE,
      p_complt_date      gicl_clm_adjuster.complt_date%TYPE,
      p_delete_tag       gicl_clm_adjuster.delete_tag%TYPE,
      p_user_id          gicl_clm_adjuster.user_id%TYPE,
      p_last_update      gicl_clm_adjuster.last_update%TYPE,
      p_remarks          gicl_clm_adjuster.remarks%TYPE,
      p_surveyor_sw      gicl_clm_adjuster.surveyor_sw%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_clm_adjuster
         USING DUAL
         ON (claim_id = p_claim_id AND clm_adj_id = p_clm_adj_id)
         WHEN NOT MATCHED THEN
            INSERT (clm_adj_id, claim_id, adj_company_cd, priv_adj_cd,
                    assign_date, cancel_tag, complt_date, delete_tag,
                    user_id, last_update, remarks, surveyor_sw)
            VALUES (p_clm_adj_id, p_claim_id, p_adj_company_cd,
                    p_priv_adj_cd, p_assign_date, p_cancel_tag,
                    p_complt_date, p_delete_tag, p_user_id, SYSDATE,
                    p_remarks, p_surveyor_sw)
         WHEN MATCHED THEN
            UPDATE
               SET adj_company_cd = p_adj_company_cd,
                   priv_adj_cd = p_priv_adj_cd, assign_date = p_assign_date,
                   cancel_tag = p_cancel_tag, complt_date = p_complt_date,
                   delete_tag = p_delete_tag, user_id = p_user_id,
                   last_update = SYSDATE, remarks = p_remarks,
                   surveyor_sw = p_surveyor_sw
            ;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 11.09.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : Delete record
    **/
   PROCEDURE del_gicl_clm_adjuster (
      p_clm_adj_id   gicl_clm_adjuster.clm_adj_id%TYPE,
      p_claim_id     gicl_clm_adjuster.claim_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_clm_adjuster
            WHERE clm_adj_id = p_clm_adj_id AND claim_id = p_claim_id;
   END;

   /**
   **  Created by      : Irwin Tabisora
   **  Date Created    : 01.21.2012
   **  Reference By    : (GICLS070 - MC EVALUATION REPORT)
   **  Description     : GET CLAIM ADJUSTER LISTING
   **/
   FUNCTION get_mc_evaluation_adjuster (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN mc_evaluation_adjuster_tab PIPELINED
   IS
      v_adj   mc_evaluation_adjuster_type;
   BEGIN
      FOR i IN (select * from(SELECT DISTINCT DECODE (a.payee_name,
                                        NULL, c.payee_last_name,
                                        a.payee_name
                                       ) payee_name_full,
                                b.clm_adj_id
                           FROM giis_adjuster a,
                                gicl_clm_adjuster b,
                                giis_payees c
                          WHERE 1 = 1
                            AND b.adj_company_cd = a.adj_company_cd(+)
                            AND NVL (b.priv_adj_cd, 0) = a.priv_adj_cd(+)
                            AND b.claim_id = p_claim_id
                            AND c.payee_class_cd = giisp.v ('ADJUSTER_CD')
                            AND c.payee_no = b.adj_company_cd
   AND nvl(cancel_tag,'N') <> 'Y'
   AND nvl(delete_tag,'N')<>'Y'
                        
                              )
                            where UPPER (payee_name_full) LIKE 
                                  NVL (UPPER (p_find_text), '%%')  
                              )
                             
                              
      LOOP
         v_adj.payee_name := i.payee_name_full;
         v_adj.clm_adj_id := i.clm_adj_id;
         PIPE ROW (v_adj);
      END LOOP;
   END;
   
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets list of adjusters for Loss/Expense History 
    */

    FUNCTION get_loss_exp_adjuster_list(p_claim_id  IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN gicl_clm_adjuster_tab PIPELINED AS
          
    v_adj   gicl_clm_adjuster_type;

    BEGIN
        FOR i IN (SELECT DISTINCT(a.adj_company_cd) adj_company_cd, b.payee_last_name||
                     DECODE(b.payee_first_name, NULL, NULL, ','||b.payee_first_name)||
                     DECODE(b.payee_middle_name, NULL, NULL, '-'||
                     b.payee_middle_name) adj_co_name
                 FROM GICL_CLM_ADJUSTER a, GIIS_PAYEES b
                WHERE a.claim_id             = p_claim_id
                  AND b.allow_tag = 'Y'
                  AND NVL(a.delete_tag, 'N') = 'N'
                  AND NVL(a.cancel_tag, 'N') = 'N'
                  AND b.payee_class_cd       = GIACP.v('ADJP_CLASS_CD')
                  AND a.adj_company_cd       = b.payee_no)
        LOOP
        
         v_adj.adj_company_cd  := i.adj_company_cd;
         v_adj.dsp_adj_co_name := i.adj_co_name;
            
         PIPE ROW(v_adj);
            
        END LOOP;
        
    END;
END gicl_clm_adjuster_pkg;
/


