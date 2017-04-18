CREATE OR REPLACE PACKAGE BODY CPI.GIUW_POL_DIST_POLBASIC_V_PKG AS

/**
** Created by:      Veronica V. Raymundo
** Date Created:    August 11, 2011
** Reference by:    GIUWS015 - Batch Distribution
** Description :    Function returns query details from GIUW_POL_DIST_POLBASIC_V.
**
**/

    FUNCTION get_giuw_pol_dist_polbasic_v 
        (p_module_id            GIIS_USER_GRP_MODULES.module_id%TYPE,
         p_line_cd              GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
         p_iss_cd               GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
         p_subline_cd           GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
         p_issue_yy             GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE,
         p_pol_seq_no           GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
         p_renew_no             GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE,
         p_endt_iss_cd          GIUW_POL_DIST_POLBASIC_V.endt_iss_cd%TYPE,
         p_endt_yy              GIUW_POL_DIST_POLBASIC_V.endt_yy%TYPE,
         p_endt_seq_no          GIUW_POL_DIST_POLBASIC_V.endt_seq_no%TYPE,
         p_dist_no              GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
         p_user_id              GIIS_USER_GRP_MODULES.user_id%TYPE
         )
    RETURN giuw_pol_dist_polbasic_v_tab PIPELINED IS
    
    v_pol_dist            giuw_pol_dist_polbasic_v_type;
    
    BEGIN
       IF p_line_cd IS NULL AND p_iss_cd IS NULL AND p_subline_cd IS NULL  -- optimization
           AND p_issue_yy IS NULL AND p_pol_seq_no IS NULL 
           AND p_renew_no IS NULL AND p_endt_iss_cd IS NULL 
           AND p_endt_yy IS NULL AND p_endt_seq_no IS NULL
           AND p_dist_no IS NULL THEN
            FOR i IN (SELECT a.policy_id,          a.line_cd,            a.subline_cd,         a.iss_cd,
                            a.issue_yy,           a.par_id,             a.pol_seq_no,         a.assd_no,
                            a.endt_iss_cd,        a.spld_flag,          a.dist_flag,          a.dist_no,
                            a.eff_date_polbas,    a.issue_date,         a.expiry_date_polbas, TRUNC(a.eff_date) eff_date,
                            a.endt_expiry_date,   a.expiry_date_poldist,a.endt_yy,            a.dist_type,
                            a.acct_ent_date,      a.endt_seq_no,        a.renew_no,           a.pol_flag,
                            a.negate_date,        a.acct_neg_date,      a.incept_date,        a.last_upd_date,
                            a.user_id,            a.batch_id,           a.tsi_amt,            a.prem_amt,
                            a.user_id2,
                              LTRIM(a.line_cd)
                            || '-'
                            || LTRIM(a.subline_cd)
                            || '-'
                            || LTRIM(a.iss_cd)
                            || '-'
                            || LTRIM(TO_CHAR(a.issue_yy,'99'))
                            || '-'
                            || LPAD(LTRIM(TO_CHAR(a.pol_seq_no,'9999999')),7,'0')
                            || '-'
                            || LPAD(LTRIM(TO_CHAR(a.renew_no,'99')),2,'0') policy_no,
                             LTRIM(a.line_cd)
                            || '-'
                            || LTRIM(a.subline_cd)
                            || '-'
                            || LTRIM(a.endt_iss_cd)
                            || '-'
                            || LTRIM(TO_CHAR(a.endt_yy,'99'))
                            || '-'
                            || LPAD(LTRIM(TO_CHAR(a.endt_seq_no,'9999999')),6,'0') endt_no
                            FROM GIUW_POL_DIST_POLBASIC_V a
                    WHERE  EXISTS
                          (SELECT  'A'
                             FROM  GIPI_POLBASIC B250
                            WHERE  EXISTS
                                  (SELECT  'A'
                                     FROM  GIIS_USER_GRP_LINE grp
                                    WHERE  EXISTS
                                          (SELECT 'A'
                                             FROM GIIS_USERS b
                                            WHERE b.user_grp = grp.user_grp
                                              AND b.user_id  = p_user_id)
                                      AND grp.line_cd = B250.line_cd)
                              AND  B250.dist_flag = '1'
                              AND  B250.pol_flag NOT IN ('4', '5')
                              AND  B250.policy_id = policy_id)
                    AND dist_flag IN ('1','2')
                    /*AND CHECK_USER_PER_LINE1 (a.line_cd,         -- replaced by code below : shan 08.27.2014
                                             UPPER(NVL (:p_iss_cd, a.iss_cd)),
                                              :p_user_id, :p_module_id) = 1*/
                    AND ((SELECT c.access_tag
                            FROM GIIS_USERS a
                                , GIIS_USER_GRP_LINE b
                                , GIIS_USER_GRP_MODULES c
                           WHERE a.user_grp  = b.user_grp
                             AND a.user_grp  = c.user_grp
                             AND a.user_id   = p_user_id
                             AND b.iss_cd    = NVL(UPPER(NVL (p_iss_cd, a.iss_cd)),b.iss_cd)
                             AND b.line_cd   = NVL(a.line_cd, b.line_cd)
                             AND b.tran_cd   = c.tran_cd
                             AND c.module_id = p_module_id) = 1
                         OR ( SELECT c.access_tag
                                FROM GIIS_USERS a
                                    , GIIS_USER_LINE b
                                    , GIIS_USER_MODULES c
                               WHERE a.user_id  = b.userid
                                 AND a.user_id  = c.userid
                                 AND a.user_id   = p_user_id
                                 AND b.iss_cd    = NVL(UPPER(NVL (p_iss_cd, a.iss_cd)),b.iss_cd)
                                 AND b.line_cd   = NVL(a.line_cd, b.line_cd)
                                 AND b.tran_cd   = c.tran_cd
                                 AND c.module_id = p_module_id) = 1)
                    /*AND CHECK_USER_PER_ISS_CD1(UPPER(NVL (:p_line_cd, a.line_cd)),    -- replaced by code below : shan 08.27.2014
                                               a.iss_cd,
                                               :p_user_id,
                                               :p_module_id
                                              ) = 1*/
                    AND ((  SELECT c.access_tag
                              FROM GIIS_USERS a,
                                   GIIS_USER_GRP_DTL b,
                                   GIIS_USER_GRP_MODULES c
                             WHERE a.user_grp  = b.user_grp
                               AND a.user_grp  = c.user_grp
                               AND a.user_id   = p_user_id
                               AND b.iss_cd    = NVL(a.iss_cd, b.iss_cd)
                               AND b.tran_cd   = c.tran_cd
                               AND c.module_id = p_module_id
                               AND EXISTS (SELECT 1
                                             FROM GIIS_USER_GRP_LINE
                                            WHERE user_grp = b.user_grp
                                              AND iss_cd   = b.iss_cd
                                              AND tran_cd  = c.tran_cd
                                              AND line_cd  = NVL(UPPER(NVL (p_line_cd, a.line_cd)),line_cd))) = 1
                         OR 
                         (  SELECT c.access_tag
                              FROM GIIS_USERS a,
                                   GIIS_USER_ISS_CD b,
                                   GIIS_USER_MODULES c
                             WHERE a.user_id  = b.userid
                               AND a.user_id  = c.userid
                               AND a.user_id   = p_user_id
                               AND b.iss_cd    = NVL(a.iss_cd, b.iss_cd)
                               AND b.tran_cd   = c.tran_cd
                               AND c.module_id = p_module_id
                               AND EXISTS (SELECT 1
                                             FROM GIIS_USER_LINE
                                            WHERE userid = b.userid
                                              AND iss_cd = b.iss_cd
                                              AND tran_cd  = c.tran_cd
                                              AND line_cd  = NVL(UPPER(NVL (p_line_cd, a.line_cd)),line_cd))) = 1
                         )
                    AND a.dist_no NOT IN (SELECT dist_no 
                                            FROM giri_distfrps)--edgar 10/31/2014 to exclude records with posted binders
                    ORDER BY a.batch_id,
                             a.line_cd,
                             a.subline_cd
           )
           LOOP
                v_pol_dist.policy_id            := i.policy_id;
                v_pol_dist.line_cd                := i.line_cd;
                v_pol_dist.subline_cd            := i.subline_cd;
                v_pol_dist.iss_cd                := i.iss_cd;
                v_pol_dist.issue_yy                := i.issue_yy;
                v_pol_dist.par_id                := i.par_id;
                v_pol_dist.pol_seq_no            := i.pol_seq_no;
                v_pol_dist.policy_no             := i.policy_no;
                v_pol_dist.assd_no                := i.assd_no;
                v_pol_dist.endt_iss_cd            := i.endt_iss_cd;
                v_pol_dist.spld_flag			:= i.spld_flag;
                v_pol_dist.dist_flag			:= i.dist_flag;
                v_pol_dist.dist_no				:= i.dist_no;
                v_pol_dist.eff_date				:= i.eff_date;
                v_pol_dist.eff_date_polbas		:= i.eff_date_polbas;
                v_pol_dist.issue_date			:= i.issue_date;
                v_pol_dist.expiry_date_polbas	:= i.expiry_date_polbas;
                v_pol_dist.endt_expiry_date		:= i.endt_expiry_date;
                v_pol_dist.expiry_date_poldist	:= i.expiry_date_poldist;
                v_pol_dist.endt_yy				:= i.endt_yy;
                v_pol_dist.dist_type			:= i.dist_type;
                v_pol_dist.acct_ent_date		:= i.acct_ent_date;
                v_pol_dist.endt_seq_no			:= i.endt_seq_no;
                v_pol_dist.renew_no				:= i.renew_no;
                v_pol_dist.pol_flag				:= i.pol_flag;
                v_pol_dist.negate_date			:= i.negate_date;
                v_pol_dist.acct_neg_date		:= i.acct_neg_date;
                v_pol_dist.incept_date			:= i.incept_date;
                v_pol_dist.last_upd_date		:= i.last_upd_date;
                v_pol_dist.user_id				:= i.user_id;
                v_pol_dist.batch_id				:= i.batch_id;
                v_pol_dist.tsi_amt				:= i.tsi_amt;
                v_pol_dist.prem_amt				:= i.prem_amt;
                v_pol_dist.user_id2 			:= i.user_id2;

                IF(i.endt_seq_no > 0) THEN
                     v_pol_dist.endt_no			:= i.endt_no;
                ELSE
                     v_pol_dist.endt_no			:= NULL;
                END IF;

                PIPE ROW(v_pol_dist);

           END LOOP;    
        ELSE
           FOR i IN (SELECT a.policy_id,          a.line_cd,            a.subline_cd,         a.iss_cd,
                            a.issue_yy,           a.par_id,             a.pol_seq_no,         a.assd_no,
                            a.endt_iss_cd,        a.spld_flag,          a.dist_flag,          a.dist_no,
                            a.eff_date_polbas,    a.issue_date,         a.expiry_date_polbas, TRUNC(a.eff_date) eff_date,
                            a.endt_expiry_date,   a.expiry_date_poldist,a.endt_yy,            a.dist_type,
                            a.acct_ent_date,      a.endt_seq_no,        a.renew_no,           a.pol_flag,
                            a.negate_date,        a.acct_neg_date,      a.incept_date,        a.last_upd_date,
                            a.user_id,            a.batch_id,           a.tsi_amt,            a.prem_amt,
                            a.user_id2,
                              LTRIM(a.line_cd)
                            || '-'
                            || LTRIM(a.subline_cd)
                            || '-'
                            || LTRIM(a.iss_cd)
                            || '-'
                            || LTRIM(TO_CHAR(a.issue_yy,'99'))
                            || '-'
                            || LPAD(LTRIM(TO_CHAR(a.pol_seq_no,'9999999')),7,'0')
                            || '-'
                            || LPAD(LTRIM(TO_CHAR(a.renew_no,'99')),2,'0') policy_no,
                             LTRIM(a.line_cd)
                            || '-'
                            || LTRIM(a.subline_cd)
                            || '-'
                            || LTRIM(a.endt_iss_cd)
                            || '-'
                            || LTRIM(TO_CHAR(a.endt_yy,'99'))
                            || '-'
                            || LPAD(LTRIM(TO_CHAR(a.endt_seq_no,'9999999')),6,'0') endt_no
                            FROM GIUW_POL_DIST_POLBASIC_V a
                    WHERE  EXISTS
                          (SELECT  'A'
                             FROM  GIPI_POLBASIC B250
                            WHERE  EXISTS
                                  (SELECT  'A'
                                     FROM  GIIS_USER_GRP_LINE grp
                                    WHERE  EXISTS
                                          (SELECT 'A'
                                             FROM GIIS_USERS b
                                            WHERE b.user_grp = grp.user_grp
                                              AND b.user_id  = p_user_id)
                                      AND grp.line_cd = B250.line_cd)
                              AND  B250.dist_flag = '1'
                              AND  B250.pol_flag NOT IN ('4', '5')
                              AND  B250.policy_id = policy_id)
                    AND dist_flag IN ('1','2')
                    /*AND CHECK_USER_PER_LINE1 (a.line_cd,         -- replaced by code below : shan 08.27.2014
                                             UPPER(NVL (:p_iss_cd, a.iss_cd)),
                                              :p_user_id, :p_module_id) = 1*/
                    AND ((SELECT c.access_tag
                            FROM GIIS_USERS a
                                , GIIS_USER_GRP_LINE b
                                , GIIS_USER_GRP_MODULES c
                           WHERE a.user_grp  = b.user_grp
                             AND a.user_grp  = c.user_grp
                             AND a.user_id   = p_user_id
                             AND b.iss_cd    = NVL(UPPER(NVL (p_iss_cd, a.iss_cd)),b.iss_cd)
                             AND b.line_cd   = NVL(a.line_cd, b.line_cd)
                             AND b.tran_cd   = c.tran_cd
                             AND c.module_id = p_module_id) = 1
                         OR ( SELECT c.access_tag
                                FROM GIIS_USERS a
                                    , GIIS_USER_LINE b
                                    , GIIS_USER_MODULES c
                               WHERE a.user_id  = b.userid
                                 AND a.user_id  = c.userid
                                 AND a.user_id   = p_user_id
                                 AND b.iss_cd    = NVL(UPPER(NVL (p_iss_cd, a.iss_cd)),b.iss_cd)
                                 AND b.line_cd   = NVL(a.line_cd, b.line_cd)
                                 AND b.tran_cd   = c.tran_cd
                                 AND c.module_id = p_module_id) = 1)
                    /*AND CHECK_USER_PER_ISS_CD1(UPPER(NVL (:p_line_cd, a.line_cd)),    -- replaced by code below : shan 08.27.2014
                                               a.iss_cd,
                                               :p_user_id,
                                               :p_module_id
                                              ) = 1*/
                    AND ((  SELECT c.access_tag
                              FROM GIIS_USERS a,
                                   GIIS_USER_GRP_DTL b,
                                   GIIS_USER_GRP_MODULES c
                             WHERE a.user_grp  = b.user_grp
                               AND a.user_grp  = c.user_grp
                               AND a.user_id   = p_user_id
                               AND b.iss_cd    = NVL(a.iss_cd, b.iss_cd)
                               AND b.tran_cd   = c.tran_cd
                               AND c.module_id = p_module_id
                               AND EXISTS (SELECT 1
                                             FROM GIIS_USER_GRP_LINE
                                            WHERE user_grp = b.user_grp
                                              AND iss_cd   = b.iss_cd
                                              AND tran_cd  = c.tran_cd
                                              AND line_cd  = NVL(UPPER(NVL (p_line_cd, a.line_cd)),line_cd))) = 1
                         OR 
                         (  SELECT c.access_tag
                              FROM GIIS_USERS a,
                                   GIIS_USER_ISS_CD b,
                                   GIIS_USER_MODULES c
                             WHERE a.user_id  = b.userid
                               AND a.user_id  = c.userid
                               AND a.user_id   = p_user_id
                               AND b.iss_cd    = NVL(a.iss_cd, b.iss_cd)
                               AND b.tran_cd   = c.tran_cd
                               AND c.module_id = p_module_id
                               AND EXISTS (SELECT 1
                                             FROM GIIS_USER_LINE
                                            WHERE userid = b.userid
                                              AND iss_cd = b.iss_cd
                                              AND tran_cd  = c.tran_cd
                                              AND line_cd  = NVL(UPPER(NVL (p_line_cd, a.line_cd)),line_cd))) = 1
                         )
                    AND a.line_cd     LIKE UPPER (NVL (p_line_cd, a.line_cd))
                    AND a.iss_cd      LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
                    AND a.subline_cd  LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
                    AND a.issue_yy    LIKE UPPER (NVL (p_issue_yy, a.issue_yy))
                    AND a.pol_seq_no  LIKE UPPER (NVL (p_pol_seq_no, a.pol_seq_no))
                    AND a.renew_no    LIKE UPPER (NVL (p_renew_no, a.renew_no))
                    AND a.endt_iss_cd LIKE UPPER (NVL (p_endt_iss_cd, a.endt_iss_cd))
                    AND a.endt_yy     LIKE UPPER (NVL (p_endt_yy, a.endt_yy))
                    AND a.endt_seq_no LIKE UPPER (NVL (p_endt_seq_no, a.endt_seq_no))
                    AND a.dist_no     LIKE UPPER (NVL (p_dist_no, a.dist_no))
                    AND a.dist_no NOT IN (SELECT dist_no 
                                            FROM giri_distfrps)--edgar 10/31/2014 to exclude records with posted binders
                    ORDER BY a.batch_id,
                             a.line_cd,
                             a.subline_cd
           )
           LOOP
                v_pol_dist.policy_id			:= i.policy_id;
                v_pol_dist.line_cd				:= i.line_cd;
                v_pol_dist.subline_cd			:= i.subline_cd;
                v_pol_dist.iss_cd				:= i.iss_cd;
                v_pol_dist.issue_yy				:= i.issue_yy;
                v_pol_dist.par_id				:= i.par_id;
                v_pol_dist.pol_seq_no			:= i.pol_seq_no;
                v_pol_dist.policy_no 			:= i.policy_no;
                v_pol_dist.assd_no				:= i.assd_no;
                v_pol_dist.endt_iss_cd			:= i.endt_iss_cd;
                v_pol_dist.spld_flag			:= i.spld_flag;
                v_pol_dist.dist_flag			:= i.dist_flag;
                v_pol_dist.dist_no				:= i.dist_no;
                v_pol_dist.eff_date				:= i.eff_date;
                v_pol_dist.eff_date_polbas		:= i.eff_date_polbas;
                v_pol_dist.issue_date			:= i.issue_date;
                v_pol_dist.expiry_date_polbas	:= i.expiry_date_polbas;
                v_pol_dist.endt_expiry_date		:= i.endt_expiry_date;
                v_pol_dist.expiry_date_poldist	:= i.expiry_date_poldist;
                v_pol_dist.endt_yy				:= i.endt_yy;
                v_pol_dist.dist_type			:= i.dist_type;
                v_pol_dist.acct_ent_date		:= i.acct_ent_date;
                v_pol_dist.endt_seq_no			:= i.endt_seq_no;
                v_pol_dist.renew_no				:= i.renew_no;
                v_pol_dist.pol_flag				:= i.pol_flag;
                v_pol_dist.negate_date			:= i.negate_date;
                v_pol_dist.acct_neg_date		:= i.acct_neg_date;
                v_pol_dist.incept_date			:= i.incept_date;
                v_pol_dist.last_upd_date		:= i.last_upd_date;
                v_pol_dist.user_id				:= i.user_id;
                v_pol_dist.batch_id				:= i.batch_id;
                v_pol_dist.tsi_amt				:= i.tsi_amt;
                v_pol_dist.prem_amt				:= i.prem_amt;
                v_pol_dist.user_id2 			:= i.user_id2;

                IF(i.endt_seq_no > 0) THEN
                     v_pol_dist.endt_no			:= i.endt_no;
                ELSE
                     v_pol_dist.endt_no			:= NULL;
                END IF;

                PIPE ROW(v_pol_dist);

           END LOOP;
        END IF;
    END;
    
/**
** Created by:      Veronica V. Raymundo
** Date Created:    August 31, 2011
** Reference by:    GIUWS015 - Batch Distribution
** Description :    Function returns query details from GIUW_POL_DIST_POLBASIC_V
**                  with the given batch_id and dist_no.
**/
    
    FUNCTION get_giuw_pol_dist_polbasic_v_2 (p_batch_id          GIUW_POL_DIST_POLBASIC_V.batch_id%TYPE,
                                             p_dist_no           GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE)
    RETURN giuw_pol_dist_polbasic_v_tab PIPELINED IS
    
     v_pol_dist            giuw_pol_dist_polbasic_v_type;
    
    BEGIN
        FOR i IN (SELECT   a.policy_id, a.dist_no, a.batch_id, a.line_cd, a.subline_cd, 
                           a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, NVL(a.endt_seq_no,0) endt_seq_no, 
                           SUBSTR(LTRIM(a.line_cd || '-' || LTRIM(a.subline_cd) || '-' || a.iss_cd
                           || '-' || LTRIM(TO_CHAR(a.issue_yy,'99')) || '-' || 
                           LPAD(LTRIM(TO_CHAR(a.pol_seq_no,'9999999')),7,'0') || '-' || 
                           LPAD(LTRIM(TO_CHAR(a.renew_no,'99')),2,'0') || '  ' ||
                           DECODE(a.endt_seq_no,0,'', a.endt_iss_cd) || DECODE(a.endt_seq_no,0,'','-') || 
                           DECODE(a.endt_seq_no,0,'',LTRIM(TO_CHAR(a.endt_yy,'99'))) || DECODE(a.endt_seq_no,0,'','-') || 
                           DECODE(a.endt_seq_no,0,'',LTRIM(TO_CHAR(a.endt_seq_no,'999999')))),1,40) policy_no
                    FROM GIUW_POL_DIST_POLBASIC_V a
                    WHERE batch_id = p_batch_id
                      AND dist_no = p_dist_no)
        LOOP
            v_pol_dist.policy_id			:= i.policy_id;
            v_pol_dist.dist_no				:= i.dist_no;
            v_pol_dist.batch_id				:= i.batch_id; 
            v_pol_dist.line_cd				:= i.line_cd;
            v_pol_dist.subline_cd			:= i.subline_cd;
            v_pol_dist.iss_cd				:= i.iss_cd;
            v_pol_dist.issue_yy				:= i.issue_yy; 
            v_pol_dist.pol_seq_no			:= i.pol_seq_no;
            v_pol_dist.renew_no				:= i.renew_no;
            v_pol_dist.policy_no 			:= i.policy_no;
            v_pol_dist.endt_seq_no			:= i.endt_seq_no;
            
            PIPE ROW(v_pol_dist);
            
        END LOOP;  
    END;
	
	FUNCTION get_giuw_pol_dist_polbasic_v_3(    -- shan 08.28.2014
         p_module_id            GIIS_USER_GRP_MODULES.module_id%TYPE,         
         p_user_id              GIIS_USER_GRP_MODULES.user_id%TYPE,
         p_batch_id             GIUW_POL_DIST_POLBASIC_V.BATCH_ID%type
    )
    RETURN giuw_pol_dist_polbasic_v_tab PIPELINED IS

    v_pol_dist            giuw_pol_dist_polbasic_v_type;

    BEGIN
        
        FOR i IN (SELECT a.policy_id,          a.line_cd,            a.subline_cd,         a.iss_cd,
                        a.issue_yy,           a.par_id,             a.pol_seq_no,         a.assd_no,
                        a.endt_iss_cd,        a.spld_flag,          a.dist_flag,          a.dist_no,
                        a.eff_date_polbas,    a.issue_date,         a.expiry_date_polbas, TRUNC(a.eff_date) eff_date,
                        a.endt_expiry_date,   a.expiry_date_poldist,a.endt_yy,            a.dist_type,
                        a.acct_ent_date,      a.endt_seq_no,        a.renew_no,           a.pol_flag,
                        a.negate_date,        a.acct_neg_date,      a.incept_date,        a.last_upd_date,
                        a.user_id,            a.batch_id,           a.tsi_amt,            a.prem_amt,
                        a.user_id2,
                          LTRIM(a.line_cd)
                        || '-'
                        || LTRIM(a.subline_cd)
                        || '-'
                        || LTRIM(a.iss_cd)
                        || '-'
                        || LTRIM(TO_CHAR(a.issue_yy,'99'))
                        || '-'
                        || LPAD(LTRIM(TO_CHAR(a.pol_seq_no,'9999999')),7,'0')
                        || '-'
                        || LPAD(LTRIM(TO_CHAR(a.renew_no,'99')),2,'0') policy_no,
                         LTRIM(a.line_cd)
                        || '-'
                        || LTRIM(a.subline_cd)
                        || '-'
                        || LTRIM(a.endt_iss_cd)
                        || '-'
                        || LTRIM(TO_CHAR(a.endt_yy,'99'))
                        || '-'
                        || LPAD(LTRIM(TO_CHAR(a.endt_seq_no,'9999999')),6,'0') endt_no
                        FROM GIUW_POL_DIST_POLBASIC_V a
                WHERE  /*EXISTS
                      (SELECT  'A'
                         FROM  GIPI_POLBASIC B250
                        WHERE  EXISTS
                              (SELECT  'A'
                                 FROM  GIIS_USER_GRP_LINE grp
                                WHERE  EXISTS
                                      (SELECT 'A'
                                         FROM GIIS_USERS b
                                        WHERE b.user_grp = grp.user_grp
                                          AND b.user_id  = p_user_id)
                                  AND grp.line_cd = B250.line_cd)
                          AND  B250.dist_flag = '1'
                          AND  B250.pol_flag NOT IN ('4', '5')
                          AND  B250.policy_id = policy_id)
                AND ((SELECT c.access_tag
                        FROM GIIS_USERS a
                            , GIIS_USER_GRP_LINE b
                            , GIIS_USER_GRP_MODULES c
                       WHERE a.user_grp  = b.user_grp
                         AND a.user_grp  = c.user_grp
                         AND a.user_id   = p_user_id
                         AND b.iss_cd    = NVL(a.iss_cd,b.iss_cd)
                         AND b.line_cd   = NVL(a.line_cd, b.line_cd)
                         AND b.tran_cd   = c.tran_cd
                         AND c.module_id = p_module_id) = 1
                     OR ( SELECT c.access_tag
                            FROM GIIS_USERS a
                                , GIIS_USER_LINE b
                                , GIIS_USER_MODULES c
                           WHERE a.user_id  = b.userid
                             AND a.user_id  = c.userid
                             AND a.user_id   = p_user_id
                             AND b.iss_cd    = NVL(a.iss_cd,b.iss_cd)
                             AND b.line_cd   = NVL(a.line_cd, b.line_cd)
                             AND b.tran_cd   = c.tran_cd
                             AND c.module_id = p_module_id) = 1)
                AND ((  SELECT c.access_tag
                          FROM GIIS_USERS a,
                               GIIS_USER_GRP_DTL b,
                               GIIS_USER_GRP_MODULES c
                         WHERE a.user_grp  = b.user_grp
                           AND a.user_grp  = c.user_grp
                           AND a.user_id   = p_user_id
                           AND b.iss_cd    = NVL(a.iss_cd, b.iss_cd)
                           AND b.tran_cd   = c.tran_cd
                           AND c.module_id = p_module_id
                           AND EXISTS (SELECT 1
                                         FROM GIIS_USER_GRP_LINE
                                        WHERE user_grp = b.user_grp
                                          AND iss_cd   = b.iss_cd
                                          AND tran_cd  = c.tran_cd
                                          AND line_cd  = NVL(a.line_cd,line_cd))) = 1
                     OR 
                     (  SELECT c.access_tag
                          FROM GIIS_USERS a,
                               GIIS_USER_ISS_CD b,
                               GIIS_USER_MODULES c
                         WHERE a.user_id  = b.userid
                           AND a.user_id  = c.userid
                           AND a.user_id   = p_user_id
                           AND b.iss_cd    = NVL(a.iss_cd, b.iss_cd)
                           AND b.tran_cd   = c.tran_cd
                           AND c.module_id = p_module_id
                           AND EXISTS (SELECT 1
                                         FROM GIIS_USER_LINE
                                        WHERE userid = b.userid
                                          AND iss_cd = b.iss_cd
                                          AND tran_cd  = c.tran_cd
                                          AND line_cd  = NVL(a.line_cd,line_cd))) = 1
                     )
                  AND*/ a.batch_id = p_batch_id
                ORDER BY a.batch_id,
                         a.line_cd,
                         a.subline_cd
       )
       LOOP
            v_pol_dist.policy_id            := i.policy_id;
            v_pol_dist.line_cd                := i.line_cd;
            v_pol_dist.subline_cd            := i.subline_cd;
            v_pol_dist.iss_cd                := i.iss_cd;
            v_pol_dist.issue_yy                := i.issue_yy;
            v_pol_dist.par_id                := i.par_id;
            v_pol_dist.pol_seq_no            := i.pol_seq_no;
            v_pol_dist.policy_no             := i.policy_no;
            v_pol_dist.assd_no                := i.assd_no;
            v_pol_dist.endt_iss_cd            := i.endt_iss_cd;
            v_pol_dist.spld_flag			:= i.spld_flag;
            v_pol_dist.dist_flag			:= i.dist_flag;
            v_pol_dist.dist_no				:= i.dist_no;
            v_pol_dist.eff_date				:= i.eff_date;
            v_pol_dist.eff_date_polbas		:= i.eff_date_polbas;
            v_pol_dist.issue_date			:= i.issue_date;
            v_pol_dist.expiry_date_polbas	:= i.expiry_date_polbas;
            v_pol_dist.endt_expiry_date		:= i.endt_expiry_date;
            v_pol_dist.expiry_date_poldist	:= i.expiry_date_poldist;
            v_pol_dist.endt_yy				:= i.endt_yy;
            v_pol_dist.dist_type			:= i.dist_type;
            v_pol_dist.acct_ent_date		:= i.acct_ent_date;
            v_pol_dist.endt_seq_no			:= i.endt_seq_no;
            v_pol_dist.renew_no				:= i.renew_no;
            v_pol_dist.pol_flag				:= i.pol_flag;
            v_pol_dist.negate_date			:= i.negate_date;
            v_pol_dist.acct_neg_date		:= i.acct_neg_date;
            v_pol_dist.incept_date			:= i.incept_date;
            v_pol_dist.last_upd_date		:= i.last_upd_date;
            v_pol_dist.user_id				:= i.user_id;
            v_pol_dist.batch_id				:= i.batch_id;
            v_pol_dist.tsi_amt				:= i.tsi_amt;
            v_pol_dist.prem_amt				:= i.prem_amt;
            v_pol_dist.user_id2 			:= i.user_id2;

            IF(i.endt_seq_no > 0) THEN
                 v_pol_dist.endt_no			:= i.endt_no;
            ELSE
                 v_pol_dist.endt_no			:= NULL;
            END IF;

            PIPE ROW(v_pol_dist);

       END LOOP;
    END;

END GIUW_POL_DIST_POLBASIC_V_PKG;
/


