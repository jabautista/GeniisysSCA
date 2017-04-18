CREATE OR REPLACE PACKAGE BODY CPI.EDST_PKG
AS
   FUNCTION edst (p_scope           edst_param.SCOPE%TYPE,
                  p_from_date       VARCHAR2,--edst_param.FROM_DATE%TYPE,
                  p_to_date         VARCHAR2,--edst_EXT.TO_DATE1%TYPE,
                  p_negative_amt    VARCHAR2,
                  p_ctpl_pol        NUMBER,
                  p_inc_spo         VARCHAR2,
                  p_user_id         edst_param.user_id%TYPE,
                  p_line_cd         VARCHAR2,
                  p_subline_cd      VARCHAR2,
                  p_iss_cd          VARCHAR2,
                  p_iss_param       NUMBER)
        RETURN edst_type
        PIPELINED
    IS
    v_edst  edst_rec_type;
    v_flag  BOOLEAN := FALSE;

    BEGIN
      v_edst.v_flag := 'N';
      
      v_edst.company_name := EDST_PKG.get_comp_name;
      v_edst.company_address := EDST_PKG.get_comp_address;
    
      FOR rec IN (SELECT   gs.assd_no AS assd_no,
                     NVL (gs.assd_tin, ' ') AS tin,
                     gp.iss_cd AS branch,
                     DECODE (NVL (gs.assd_tin, 'X'), 'X', 'X', ' ') AS "NO_TIN",
                     giis.branch_tin_cd AS branch_tin_cd,
                     --vin 7.2.2010 added branch_tin_cd
                     gs.no_tin_reason AS reason,
                     DECODE (gs.corporate_tag,
                             'C', gs.assd_name,
                             'J', gs.assd_name,
                             NULL)
                        AS company,
                     DECODE (gs.corporate_tag, 'I', gs.first_name)
                        AS first_name,
                     DECODE (gs.corporate_tag, 'I', gs.middle_initial)
                        AS middle_initial,
                     DECODE (gs.corporate_tag, 'I', gs.last_name) AS last_name,
                     gpb.line_cd AS line_cd,      --added line_cd vin 7.1.2010
                     SUM (gu.total_prem) tax_base,
                     --sum of prem per assured rose
                     SUM (gu.total_tsi) tsi_amt          --vin added 7.14.2010
              FROM   edst_ext gp,
                     giis_assured gs,
                     gipi_polbasic gpb,
                     giis_issource giis,                        --vin 7.2.2010
                     giis_line gl,                           --Dean 05.28.2012
                     (SELECT   assd_no,
                               policy_id,
                               total_Prem,
                               total_tsi                --vin added 07.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user_id
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND acct_ent_date BETWEEN p_FROM_date
                                                     AND p_TO_DATE
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol = 3
                                      AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN
                                                 ('1', '2', 'X', '5', '4'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X', '5')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X')
                                        AND total_prem > 0)
                                    -- vin added 7.8.2010
                                    OR (    p_scope = 2
                                        AND total_prem < 0
                                        AND p_ctpl_pol = 3))
                      UNION ALL
                      SELECT   assd_no,
                               policy_id,
                               (DECODE (pol_flag,
                                        '5', (total_Prem * -1),
                                        total_prem))
                                  total_prem,
                               (DECODE (pol_flag,
                                        '5', (total_tsi * -1),
                                        total_tsi))
                                  total_tsi             --vin added 07.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user_id
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND spld_acct_ent_date BETWEEN p_FROM_date
                                                          AND p_TO_DATE
                               AND ( (    p_scope = 1
                                      AND p_negative_amt = 'Y'
                                      AND p_inc_spo = 'Y'
                                      AND p_ctpl_pol = 3
                                      AND pol_flag IN ('1', '2', 'X', '4', '5'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem < 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag = '5'))
                      UNION ALL                                    --WITH CTPL
                      SELECT   assd_no,
                               policy_id,
                               total_Prem,
                               total_tsi                 --vin added 7.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user_id
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND acct_ent_date BETWEEN p_FROM_date
                                                     AND p_TO_DATE
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol IN (1, 2)
                                      AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN
                                                 ('1', '2', 'X', '5', '4'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X', '5')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X')
                                        AND total_prem > 0)
                                    -- vin added 7.8.2010
                                    OR (    p_scope = 2
                                        AND p_ctpl_pol IN (1, 2)
                                        AND total_prem < 0))
                      UNION ALL
                      SELECT   assd_no,
                               policy_id,
                               (DECODE (pol_flag,
                                        '5', (total_Prem * -1),
                                        total_prem))
                                  total_prem,
                               (DECODE (pol_flag,
                                        '5', (total_tsi * -1),
                                        total_tsi))
                                  total_tsi             --vin added 07.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user_id
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND spld_acct_ent_date BETWEEN p_FROM_date
                                                          AND p_TO_DATE
                               AND ( (    p_scope = 1
                                      AND p_negative_amt = 'Y'
                                      AND p_inc_spo = 'Y'
                                      AND p_ctpl_pol IN (1, 2)
                                      AND pol_flag IN ('1', '2', 'X', '5', '4'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem < 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag = '5'))
                      UNION ALL
                      --this is now for policy level CTPL policies vin 7.1.2010
                      SELECT   assd_no,
                               policy_id,
                               prem_amt * -1 AS total_prem,
                               tsi_amt * -1 AS tsi_amt
                        --vin added 7.14.2010 to match the number of columns
                        FROM   mc_pol_ext
                       WHERE   1 = 1 AND user_id = p_user_id
                               AND acct_ent_date BETWEEN p_from_date
                                                     AND  p_to_date
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol = 1
                                      AND   /*prem_amt>0 AND ctpl_prem_amt>0*/
                                         ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.26.2010
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.23.2010 commented out and replaced with the statement after it
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- since we will only get/compute those MC policies that have CTPL premiums
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- vin added 7.8.2010
                                    OR (p_scope = 2 AND p_ctpl_pol = 1 /*AND prem_amt<0 */
                                                                      AND ctpl_prem_amt < 0)) -- vin 7.26.2010 commented out
                      UNION ALL
                      --vin 7.1.2010 added these for peril level CTPL policies
                      SELECT   assd_no,
                               policy_id,
                               ctpl_prem_amt * -1 AS total_prem,
                               ctpl_tsi_amt * -1 AS tsi_amt
                        --vin added 7.14.2010 to match the number of columns
                        FROM   mc_pol_ext
                       WHERE   1 = 1 AND user_id = p_user_id
                               AND TRUNC (acct_ent_date) BETWEEN p_from_date
                                                     AND p_to_date
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol = 2
                                      AND   /*prem_amt>0 AND ctpl_prem_amt>0*/
                                         ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.26.2010
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.23.2010 commented out
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL) -- vin added 7.8.2010
                                                                     --OR  (p_scope=2 AND p_ctpl_pol = 2 /*AND prem_amt<0 */ AND ctpl_prem_amt<0) -- JHING 08/10/2011 commented out since this cause incorrect amounts in the retrieval of negative amounts
                                  )) gu         -- vin 7.26.2010 commented out
             WHERE       gp.user_id = p_USER_id
                     AND gpb.line_cd = gl.line_cd            --Dean 05.08.2012
                     AND gp.assd_no = gs.assd_no
                     AND gpb.policy_id = gp.policy_id
                     AND gp.assd_no = gu.assd_no
                     AND gp.policy_id = gu.policy_id
                     AND giis.iss_cd = gp.iss_cd
                     AND gpb.line_cd = NVL (p_line_cd, gpb.line_cd)
          --Dean 05.28.2012
          --AND tax_base <> 0
          /*added by rose in order to group the assd*/
          GROUP BY   gs.assd_no,
                     DECODE (gl.menu_line_cd, 'AC', gpb.policy_id),
                     --Dean 05.28.2012
                     DECODE (gpb.line_cd, 'AC', gpb.policy_id),
                     --Dean 05.28.2012
                     gpb.line_cd,
                     gs.assd_tin,
                     gp.iss_cd,
                     giis.branch_tin_cd,
                     gs.assd_name,
                     gs.no_tin_reason,
                     gs.last_name,
                     gs.first_name,
                     gs.middle_initial,
                     gs.corporate_tag                                      --,
            --gp.total_tsi
            HAVING   SUM (gu.total_prem) <> SUM (gu.total_tsi)
          -- Jayson 08.03.2010
          --ORDER BY  gs.assd_no, gpb.line_cd) LOOP                      -- vin commented out 7.8.2010 and replaced by the line below
          ORDER BY   gs.corporate_tag DESC,
                     gpb.line_cd,
                     gs.assd_tin,
                     gp.iss_cd,
                     giis.branch_tin_cd,
                     gs.assd_name)
      LOOP
         v_flag := TRUE;
         v_edst.line_cd := rec.line_cd;
         v_edst.tin := rec.tin;
         v_edst.branch := rec.branch;
         v_edst.branch_tin_cd := rec.branch_tin_cd;
         v_edst.no_tin := rec.no_tin;
         v_edst.reason := rec.reason;
         v_edst.company := rec.company;
         v_edst.first_name := rec.first_name;
         v_edst.last_name := rec.last_name;
         v_edst.middle_initial := rec.middle_initial;
         v_edst.tax_base := rec.tax_base;
         v_edst.tsi_amt := rec.tsi_amt;
          
         PIPE ROW (v_edst);
      END LOOP;
      
      IF v_flag = FALSE
      THEN
      PIPE ROW(v_edst);
      END IF;
    END;
    
    FUNCTION get_comp_name
        RETURN VARCHAR
    IS
        v_company_name VARCHAR2(500);
    BEGIN
        SELECT param_value_v
          INTO v_company_name
          FROM giis_parameters
         WHERE UPPER(param_name) = 'COMPANY_NAME';

    RETURN(v_company_name);
    END;
    
    FUNCTION get_comp_address 
    RETURN VARCHAR2 
    IS
	    v_company_address	VARCHAR2(500);
    
    BEGIN
       SELECT param_value_v
         INTO v_company_address
         FROM giis_parameters
        WHERE UPPER(param_name) = 'COMPANY_ADDRESS';
        
    RETURN (v_company_address);
    END;
END;
/


