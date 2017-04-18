CREATE OR REPLACE PACKAGE BODY CPI.giacr286_pkg AS

  /*
   **  Created by   : Benedict Castillo
   **  Date Created : 07.10. 2013
   **  Description : GIACR268_PKG
   */

FUNCTION populate_giacr286(
    p_cut_off_param     VARCHAR2,
    p_from_date         VARCHAR2,
    p_to_date           VARCHAR2,
    p_intm_no           VARCHAR2,
    p_line_cd           VARCHAR2,
    p_branch_cd         VARCHAR2,
    p_module_id         VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr286_tab PIPELINED AS

v_rec       giacr286_type;
v_from_date DATE := TO_DATE(p_from_date, 'MM/DD/RRRR');
v_to_date   DATE := TO_DATE(p_to_date, 'MM/DD/RRRR');
v_not_exist BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      := UPPER(giisp.v('COMPANY_NAME'));
    v_rec.company_address   := UPPER(giisp.v('COMPANY_ADDRESS'));
    IF p_cut_off_param = 1 THEN
        v_rec.from_to   := 'Transaction Date'||' from '||TO_CHAR(v_from_date,'fmMonth DD, RRRR')
                            ||' to '||TO_CHAR(v_to_date,'fmMonth DD, RRRR');
    ELSIF p_cut_off_param = 2 THEN
        v_rec.from_to   := 'Posting Date'||' from '||TO_CHAR(v_from_date,'fmMonth DD, RRRR')
                            ||' to '||TO_CHAR(v_to_date,'fmMonth DD, RRRR');
    ELSE v_rec.from_to := null;
    END IF;
    
    FOR i IN(SELECT gpcv.branch_cd||' - '|| giss.iss_name iss_cd1,   -- jhing GENQA 5298,5299 changed from  gpol.iss_cd to branch_cd
                    gpol.line_cd||' - '||glin.line_name line,
                   -- gci.intrmdry_intm_no||' - '||gint.ref_intm_cd||' - '||gint.intm_name intm, -- jhing GENQA 5298 
                    gci.intrmdry_intm_no|| DECODE(gint.ref_intm_cd,NULL, '', ' - '||gint.ref_intm_cd) ||' - '||gint.intm_name intm,
                    decode(p_cut_off_param,1,gpcv.tran_date,gpcv.posting_date) ref_date,
                    gpcv.ref_no,
                    gpol.line_cd || '-' || gpol.subline_cd || '-' || gpol.iss_cd || '-'
                                 || ltrim (to_char (gpol.issue_yy, '09')) || '-'
                                 || ltrim (to_char (gpol.pol_seq_no, '0999999')) || '-'
                                 || ltrim (to_char (gpol.renew_no, '09'))
                                 || decode (nvl (gpol.endt_seq_no, 0), 0, '',
                                 ' / ' || gpol.endt_iss_cd || '-'
                                 || ltrim (to_char (gpol.endt_yy, '09')) || '-'
                                 || ltrim (to_char (gpol.endt_seq_no, '9999999'))) policy_no,
                    gass.assd_name,
                    gpol.incept_date,
                    gci.iss_cd||'-'||TO_CHAR (gci.prem_seq_no , '099999999999') bill_no,
                    gci.iss_cd,
                    gci.prem_seq_no,
                    gpcv.collection_amt * gci.share_percentage/100 collection_amt,
                    gpcv.premium_amt * gci.share_percentage/100 premium_amt,
                    gpcv.tax_amt * gci.share_percentage/100 tax_amt,
                    gpcv.tran_id
            FROM giis_assured gass,
                 giis_intermediary gint,
                 giis_line glin,
                 giis_issource giss,
                 gipi_parlist gpar,       
                 gipi_polbasic gpol,
                 gipi_comm_invoice gci,     
                 giac_premium_colln_v gpcv
            WHERE 1 = 1
            AND gpar.assd_no = gass.assd_no
            AND gci.intrmdry_intm_no = gint.intm_no
            AND gpol.line_cd = glin.line_cd
           -- AND gpol.iss_cd = giss.iss_cd -- jhing commented out GENQA 5298,5299 [04.06.2016]
            AND gpcv.branch_cd = giss.iss_cd 
            AND gpar.par_id = gpol.par_id
            AND gpol.policy_id = gci.policy_id
            AND gci.iss_cd = gpcv.iss_cd
            AND gci.prem_seq_no = gpcv.prem_seq_no
            AND gci.intrmdry_intm_no = nvl (p_intm_no, gci.intrmdry_intm_no)     
            AND gpol.line_cd = nvl (p_line_cd, gpol.line_cd)
            --AND gpol.iss_cd = nvl(p_branch_cd,gpol.iss_cd) -- jhing commented out GENQA 5298,5299
            AND gpcv.branch_cd = nvl(p_branch_cd,gpcv.branch_cd) 
            AND decode(p_cut_off_param,1,TRUNC(gpcv.tran_date),TRUNC(gpcv.posting_date)) BETWEEN v_from_date AND v_to_date  -- jhing 04.06.2016 added trunc GENQA 5298,5299
            /*AND giss.iss_cd in (SELECT ISS_CD FROM GIIS_ISSOURCE 
                                WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(null,iss_cd,p_module_id,p_user_id),1,iss_cd,NULL))*/ -- commented out jhing 04.06.2016
            AND NOT EXISTS (
                 select 1 from gipi_endttext tx01
                                    WHERE tx01.policy_id = gpol.policy_id
                                         AND NVL(tx01.endt_tax,'N') = 'Y'
            ) 
            AND EXISTS
                             (SELECT 'X'
                                FROM TABLE (
                                        security_access.get_branch_line (
                                           'AC',
                                           'GIACS286',
                                           p_user_id))
                               WHERE branch_cd = gpcv.branch_cd)   
            UNION ALL
          SELECT gacc.gibr_branch_cd || ' - ' || giss.iss_name iss_cd1,
                 gpol.line_cd || ' - ' || glin.line_name line,
                    gci.intrmdry_intm_no
                 || DECODE (gint.ref_intm_cd, NULL, ' ', ' - ' || gint.ref_intm_cd)
                 || ' - '
                 || gint.intm_name
                    intm,
                 DECODE (p_cut_off_param, 1, gacc.tran_date, gacc.posting_date)
                    ref_date,
                 get_ref_no (gacc.tran_id) ref_no,
                    gpol.line_cd
                 || '-'
                 || gpol.subline_cd
                 || '-'
                 || gpol.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (gpol.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (gpol.renew_no, '09'))
                 || DECODE (
                       NVL (gpol.endt_seq_no, 0),
                       0, '',
                          ' / '
                       || gpol.endt_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gpol.endt_seq_no, '9999999')))
                    policy_no,
                 gass.assd_name,
                 gpol.incept_date,
                 gpinv.iss_cd || '-' || TO_CHAR(gpinv.prem_seq_no, '099999999999') bill_no,
                 gpinv.iss_cd,
                 gpinv.prem_seq_no,
                 SUM (NVL (gpcv.collection_amt * gci.share_percentage / 100, 0))
                    collection_amt,
                 SUM (NVL (gpcv.premium_amt * gci.share_percentage / 100, 0))
                    premium_amt,
                 SUM (NVL (gpcv.tax_amt * gci.share_percentage / 100, 0)) tax_amt,
                 gacc.tran_id
            FROM giis_assured gass,
                 giis_intermediary gint,
                 giis_line glin,
                 giis_issource giss,
                 gipi_parlist gpar,
                 gipi_polbasic gpol,
                 gipi_endttext gendt,
                 (SELECT b.line_cd,
                         b.subline_cd,
                         b.iss_cd,
                         b.issue_yy,
                         b.pol_seq_no,
                         b.renew_no,
                         b.endt_seq_no,
                         a.intrmdry_intm_no,
                         a.share_percentage
                    FROM gipi_comm_invoice a, gipi_polbasic b, gipi_invoice c
                   WHERE     a.policy_id = b.policy_id
                         AND b.endt_seq_no = 0
                         AND b.policy_id = c.policy_id
                         AND a.iss_cd = c.iss_cd
                         AND a.prem_seq_no = c.prem_seq_no
                         AND NVL (c.item_grp, 1) = 1
                         AND NVL (c.takeup_seq_no, 1) = 1) gci,
                 giac_direct_prem_collns gpcv,
                 gipi_invoice gpinv,
                 giac_acctrans gacc
           WHERE     1 = 1
                 AND gendt.policy_id = gpol.policy_id
                 AND NVL (gendt.endt_tax, 'N') = 'Y'
                 AND gpol.policy_id = gpinv.policy_id
                 AND gpinv.iss_cd = gpcv.b140_iss_cd
                 AND gpinv.prem_seq_no = gpcv.b140_prem_seq_no
                 AND gpar.assd_no = gass.assd_no
                 AND gpol.line_cd = glin.line_cd
                 AND gacc.gibr_branch_cd = giss.iss_cd
                 AND gpar.par_id = gpol.par_id
                 AND gci.line_cd = gpol.line_cd
                 AND gci.subline_cd = gpol.subline_cd
                 AND gci.iss_cd = gpol.iss_cd
                 AND gci.issue_yy = gpol.issue_yy
                 AND gci.pol_seq_no = gpol.pol_seq_no
                 AND gci.renew_no = gpol.renew_no
                 AND gpcv.gacc_tran_id = gacc.tran_id
                 AND gacc.tran_flag <> 'D'
                 AND NOT EXISTS
                            (SELECT 'X'
                               FROM giac_reversals x, giac_acctrans y
                              WHERE     x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag <> 'D'
                                    AND x.gacc_tran_id = gpcv.gacc_tran_id
                                    -- if parameter is posting date, consider posting date of transaction
                                    AND (   (    y.posting_date BETWEEN v_from_date
                                                                    AND v_to_date
                                             AND DECODE (p_cut_off_param, '1', 0, 1) =
                                                    1)
                                         OR (DECODE (p_cut_off_param, '1', 1, 0) = 1)))
                 AND gci.intrmdry_intm_no = NVL (p_intm_no, gci.intrmdry_intm_no)
                 AND gint.intm_no = gci.intrmdry_intm_no
                 AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                 AND gacc.gibr_branch_cd = NVL (p_branch_cd, gacc.gibr_branch_cd)
                 AND DECODE (p_cut_off_param, 1, TRUNC(gacc.tran_date), TRUNC(gacc.posting_date)) BETWEEN v_from_date
                                                                                         AND v_to_date
                 AND EXISTS
                        (SELECT 'X'
                           FROM TABLE (
                                   security_access.get_branch_line ('AC',
                                                                    'GIACS286',
                                                                    p_user_id))
                          WHERE branch_cd = gacc.gibr_branch_cd)
        GROUP BY gacc.gibr_branch_cd,
                 giss.iss_name,
                 gpol.line_cd,
                 gpol.subline_cd,
                 gpol.iss_cd,
                 gpol.issue_yy,
                 gpol.pol_seq_no,
                 gpol.renew_no,
                 gpol.endt_yy,
                 gpol.endt_seq_no,
                 gpinv.iss_cd,
                 gpinv.prem_seq_no,
                 glin.line_name,
                 gci.intrmdry_intm_no,
                 gint.ref_intm_cd,
                 gint.intm_name,
                 gacc.tran_id,
                 gacc.tran_date,
                 gacc.posting_date,
                 gpol.endt_iss_cd,
                 gass.assd_name,
                 gpol.incept_date                                                            
            ORDER BY ref_date, ref_no
            )
    LOOP
        v_not_exist         := FALSE;
        v_rec.iss_cd        := i.iss_cd1;
        v_rec.line          := i.line;
        v_rec.intm          := i.intm;
        v_rec.ref_date      := i.ref_date;
       -- v_rec.ref_no        := i.ref_no; -- jhing commented out GENQA 5298,5299
        v_rec.ref_no        := get_ref_no(i.tran_id);
        v_rec.policy_no     := i.policy_no;
        v_rec.assd_name     := i.assd_name;
        v_rec.incept_date   := i.incept_date;
        v_rec.bill_no       := i.bill_no;
        v_rec.collection_amt:= i.collection_amt;
        v_rec.premium_amt   := i.premium_amt;
        v_rec.tax_amt       := i.tax_amt;
        PIPE ROW(v_rec);
    END LOOP;
    
    IF v_not_exist THEN
        v_rec.flag  := 'T';
        PIPE ROW(v_rec);
    ELSE null;
    END IF;
END populate_giacr286;

END giacr286_pkg;
/


