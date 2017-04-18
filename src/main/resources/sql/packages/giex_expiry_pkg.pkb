CREATE OR REPLACE PACKAGE BODY CPI.giex_expiry_pkg
AS

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 08.26.2011
    **  Reference By     : (GIEXS001- Extract Expiring Policies)
    **  Description      : Retrieves the extraction history
    */
    FUNCTION get_extraction_history (
        p_user_id   giex_expiry.extract_user%TYPE
    )
    RETURN giex_expiry_tab PIPELINED
    IS
        v_expiry   giex_expiry_type;
    BEGIN
      FOR dt IN (SELECT DISTINCT extract_user, extract_date
                   FROM giex_expiry
                  WHERE extract_user = NVL(p_user_id, extract_user))
        LOOP
         v_expiry.extract_user         := dt.extract_user;
         v_expiry.extract_date         := dt.extract_date;
         PIPE ROW (v_expiry);
        END LOOP;

    END get_extraction_history;

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 08.26.2011
    **  Reference By     : (GIEXS001- Extract Expiring Policies)
    **  Description      : Gets the last extraction history
    */

    FUNCTION check_record_user_nr (
        p_policy_id        giex_expiry.policy_id%TYPE,
        p_assd_no        giex_expiry.assd_no%TYPE,
        p_intm_no        giex_expiry.intm_no%TYPE,
        p_iss_cd        giex_expiry.iss_cd%TYPE,
        p_subline_cd    giex_expiry.subline_cd%TYPE,
        p_line_cd        giex_expiry.line_cd%TYPE,
        p_start_date    giex_expiry.expiry_date%TYPE,
        p_end_date        giex_expiry.expiry_date%TYPE,
        p_user_id        giis_users.user_id%TYPE
    )
        RETURN VARCHAR2 IS
        v_valid    VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN (SELECT policy_id
                      FROM giex_expiry
                   WHERE renew_flag         = '1'
                      AND policy_id             = NVL(p_policy_id, policy_id)
                     AND assd_no             = NVL(p_assd_no, assd_no)
                     AND NVL(intm_no,0)     = NVL(p_intm_no,NVL(intm_no,0))
                     AND UPPER(iss_cd)        = NVL(UPPER(p_iss_cd),UPPER(iss_cd))
                     AND UPPER(subline_cd)  = NVL(UPPER(p_subline_cd),UPPER(subline_cd))
                     AND UPPER(line_cd)        = NVL(UPPER(p_line_cd),UPPER(line_cd))
                     AND TRUNC(expiry_date) <= TRUNC(NVL(p_end_date, NVL(p_start_date, expiry_date)))
                       AND TRUNC(expiry_date) >= DECODE(p_end_date, NULL, TRUNC(expiry_date), TRUNC(NVL(p_start_date, expiry_date)))
                       AND extract_user         = p_user_id)
        LOOP
            v_valid := 'Y';
        END LOOP;
        RETURN v_valid;
    END check_record_user_nr;

    FUNCTION check_record_user (
    p_policy_id        giex_expiry.policy_id%TYPE,
    p_assd_no        giex_expiry.assd_no%TYPE,
    p_intm_no        giex_expiry.intm_no%TYPE,
    p_iss_cd        giex_expiry.iss_cd%TYPE,
    p_subline_cd    giex_expiry.subline_cd%TYPE,
    p_line_cd        giex_expiry.line_cd%TYPE,
    p_start_date    giex_expiry.expiry_date%TYPE,
    p_end_date        giex_expiry.expiry_date%TYPE,
    p_fr_rn_seq_no    giex_rn_no.rn_seq_no%TYPE,
    p_to_rn_seq_no    giex_rn_no.rn_seq_no%TYPE,
    p_user_id        giis_users.user_id%TYPE
)
    RETURN VARCHAR2 IS
    v_valid    VARCHAR2(1) := 'N';

    BEGIN
        FOR i IN(SELECT a.policy_id
                     FROM giex_expiry a, giex_rn_no b
                  WHERE a.renew_flag = 2
                      AND a.policy_id = b.policy_id
                     AND b.rn_seq_no BETWEEN NVL(p_fr_rn_seq_no,b.rn_seq_no) AND NVL(p_to_rn_seq_no,b.rn_seq_no)
                     AND a.policy_id = NVL(p_policy_id, a.policy_id)
                    AND a.assd_no = NVL(p_assd_no, a.assd_no)
                    AND NVL(a.intm_no,0) = NVL(p_intm_no,NVL(a.intm_no,0))
                    AND UPPER(a.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
                    AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
                    AND UPPER(a.line_cd) = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
                    AND TRUNC(a.expiry_date) <= TRUNC(NVL(p_end_date, NVL(p_start_date, a.expiry_date)))
                      AND TRUNC(a.expiry_date) >= DECODE(p_end_date, NULL, TRUNC(a.expiry_date), TRUNC(NVL(p_start_date, a.expiry_date)))
                    AND a.extract_user = p_user_id)
        LOOP
            v_valid := 'Y';
        END LOOP;
        RETURN v_valid;
    END check_record_user;

    PROCEDURE get_last_extraction_history (
        p_extract_user OUT   giex_expiry.extract_user%TYPE,
        p_extract_date OUT   VARCHAR2,
        p_iss_ri       OUT   giis_parameters.param_value_v%TYPE
    )
    IS
        v_expiry   giex_expiry_type;
    BEGIN
      FOR dt IN (SELECT extract_user, extract_date
                   FROM giex_expiry
                  ORDER BY extract_date DESC)

      LOOP
          p_extract_user         := dt.extract_user;
          p_extract_date         := to_char(dt.extract_date,'MM-DD-YYYY  HH:MI:SS PM');
          EXIT;
      END LOOP;


      SELECT param_value_v
        INTO p_iss_ri
        FROM giis_parameters
       WHERE param_name = 'ISS_CD_RI';

    END get_last_extraction_history;

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 09.13.2011
    **  Reference By     : (GIEXS001- Extract Expiring Policies)
    */
    PROCEDURE extract_expiring_policies(
        p_fm_mon                IN      VARCHAR2,
        p_fm_year               IN      NUMBER,
        p_to_mon                IN      VARCHAR2,
        p_to_year               IN      NUMBER,
        p_fm_date               IN      VARCHAR2,
        p_to_date               IN      VARCHAR2,
        p_range_type            IN      NUMBER,
        p_range                 IN      NUMBER,
        p_pol_line_cd           IN      gipi_polbasic.line_cd%TYPE,
        p_pol_subline_cd        IN      gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            IN      gipi_polbasic.iss_cd%TYPE,
        p_line_cd               IN      gipi_polbasic.line_cd%TYPE,
        p_subline_cd            IN      gipi_polbasic.subline_cd%TYPE,
        p_iss_cd                IN      gipi_polbasic.iss_cd%TYPE,
        p_cred_branch           IN      gipi_polbasic.cred_branch%TYPE, --benjo 11.12.2015 UW-SPECS-2015-087
        p_intm_no               IN      giex_expiry.intm_no%TYPE,
        p_plate_no              IN      gipi_vehicle.plate_no%TYPE,
        p_line_pack_pol_flag    IN      VARCHAR2,
        p_include_package       IN      VARCHAR2,
        p_pol_issue_yy          IN      NUMBER,
        p_pol_pol_seq_no        IN      NUMBER,
        p_pol_renew_no          IN      NUMBER,
        p_inc_special_sw        IN      VARCHAR2,
        p_def_is_pol_summ_sw    IN      VARCHAR2,
        p_def_same_polno_sw     IN      VARCHAR2,
        p_user_id               IN      giis_users.user_id%TYPE,
        p_msg                   OUT     VARCHAR2,
        p_policy_count          OUT     VARCHAR2
    )
    IS
      t_policy_id      dbms_sql.number_table;
      t_line_cd        dbms_sql.varchar2_table;
      t_subline_cd     dbms_sql.varchar2_table;
      t_iss_cd         dbms_sql.varchar2_table;
      t_issue_yy       dbms_sql.number_table;
      t_pol_seq_no     dbms_sql.number_table;
      t_renew_no       dbms_sql.number_table;
      t_expiry_date    dbms_sql.date_table;
      t_incept_date    dbms_sql.date_table;
      t_assd_no        dbms_sql.number_table;
      t_auto_sw        dbms_sql.varchar2_table;
      t_intm_no        dbms_sql.number_table;

      v_param          VARCHAR2(2000) := null;
      v_mess           VARCHAR2(2000) := null;
      v_fr_date        DATE;
      v_to_date        DATE;
      v_min_fr         DATE;
      v_max_fr         DATE;
      v_max_to         DATE;
      v_line_cd        gipi_polbasic.line_cd%TYPE;
      v_subline_cd     gipi_polbasic.subline_cd%TYPE;
      v_iss_cd         gipi_polbasic.iss_cd%TYPE;
      v_intm_no        giex_expiry.intm_no%TYPE;
      v_plate_no       gipi_vehicle.plate_no%TYPE;
      v_pol_exists       VARCHAR2(1) := 'N';
      v_cnt             NUMBER := 0; --joanne 120313

      --cnt_ext    NUMBER  := 0;
      --rg_id      RECORDGROUP;
      --rg_name    VARCHAR2(20):='EXPIRED_POLICY';
      --rg_col     GROUPCOLUMN;
      --rg_0       VARCHAR2(40):=rg_name||'.policy_id';
      --rg_1       VARCHAR2(40):=rg_name||'.expiry_date';
      --rg_2       VARCHAR2(40):=rg_name||'.assd_no';
      --rg_3       VARCHAR2(40):=rg_name||'.incept_date';
      --rg_5       VARCHAR2(40):=rg_name||'.auto_sw';
      --rg_6       VARCHAR2(40):=rg_name||'.intm_no';

        CURSOR MIN_FR_DATE IS
            SELECT TO_DATE(NVL(p_fm_mon,'JANUARY')||'-'||NVL(p_fm_year,1900),'MM-YYYY') FR_DATE
            FROM DUAL;
        CURSOR MAX_FR_DATE IS
            SELECT LAST_DAY(TO_DATE(NVL(p_fm_mon,'DECEMBER')||'-'||NVL(p_fm_year,2100),'MM-YYYY')) FR_DATE
            FROM DUAL;
        CURSOR MAX_TO_DATE IS
            SELECT LAST_DAY(TO_DATE(NVL(p_to_mon,'DECEMBER')||'-'||NVL(p_to_year,2100),'MM-YYYY')) TO_DATE
            FROM DUAL;

      --al_id      Alert;
      --al_button  Number;

    BEGIN

         FOR A IN MIN_FR_DATE
         LOOP
           v_min_fr := a.fr_date;
         END LOOP;

         FOR B IN MAX_FR_DATE
         LOOP
           v_max_fr := b.fr_date;
         END LOOP;

         FOR C IN MAX_TO_DATE
         LOOP
             v_max_to := c.to_date;
         END LOOP;

         IF p_range_type = '1' THEN
           IF p_range = '3' THEN
                v_fr_date := TO_DATE('01-01-1900','MM-DD-YYYY');
                v_to_date := TO_DATE(p_fm_date,'MM-DD-YYYY');
           ELSE
                v_fr_date := TO_DATE('01-01-1900','MM-DD-YYYY');
                v_to_date := v_max_fr;
           END IF;
         ELSE
           IF p_range = '3' THEN
                v_fr_date := TO_DATE(p_fm_date,'MM-DD-YYYY');
                v_to_date := TO_DATE(p_to_date,'MM-DD-YYYY');
           ELSE
                v_fr_date := v_min_fr;
                v_to_date := v_max_to;
           END IF;
         END IF;

         IF p_range = '1' THEN
             FOR a IN ( SELECT policy_id
                         FROM gipi_polbasic
                        WHERE line_cd = p_pol_line_cd
                          AND subline_cd = p_pol_subline_cd
                          AND iss_cd = p_pol_iss_cd
                          AND issue_yy = p_pol_issue_yy
                          AND pol_seq_no = p_pol_pol_seq_no
                          AND renew_no = p_pol_renew_no)
             LOOP
                 v_pol_exists := 'Y';
                 EXIT;
             END LOOP;

             IF v_pol_exists = 'N' THEN
                 FOR a IN (SELECT pack_policy_id
                             FROM gipi_pack_polbasic
                            WHERE line_cd = p_pol_line_cd
                              AND subline_cd = p_pol_subline_cd
                              AND iss_cd = p_pol_iss_cd
                              AND issue_yy = p_pol_issue_yy
                              AND pol_seq_no = p_pol_pol_seq_no
                              AND renew_no = p_pol_renew_no)
                 LOOP
                     v_pol_exists := 'Y';
                     EXIT;
                 END LOOP;
             END IF;

             IF v_pol_exists = 'N' THEN
                  p_msg := '1';
                  RETURN;
             END IF;

               v_line_cd       :=  p_pol_line_cd;
               v_subline_cd    :=  p_pol_subline_cd;
               v_iss_cd        :=  p_pol_iss_cd;
               v_fr_date       :=  NULL;
               v_to_date       :=  NULL;
         ELSE
               v_line_cd       :=  p_line_cd;
               v_subline_cd    :=  p_subline_cd;
               v_iss_cd        :=  p_iss_cd;
         END IF;

           v_intm_no    :=  p_intm_no;
           v_plate_no   :=  p_plate_no;

        iF p_line_pack_pol_flag = 'Y' AND
           p_include_package = 'on' THEN
           process_expiring_pack_pol1 (v_intm_no,
                                           v_fr_date,
                                           v_to_date,
                                           p_inc_special_sw,
                                           v_line_cd,
                                           v_subline_cd,
                                           v_iss_cd,
                                           p_pol_issue_yy,
                                           p_pol_pol_seq_no,
                                           p_pol_renew_no,
                                           p_def_is_pol_summ_sw,
                                           p_def_same_polno_sw,
                                           v_plate_no,
                                           p_user_id,
                                           p_cred_branch, --benjo 11.12.2015 UW-SPECS-2015-087
                                           t_policy_id,
                                           t_line_cd,
                                           t_subline_cd,
                                           t_iss_cd,
                                           t_issue_yy,
                                           t_pol_seq_no,
                                           t_renew_no,
                                           t_expiry_date,
                                           t_incept_date,
                                           t_assd_no,
                                           t_auto_sw,
                                           t_intm_no);
          /*PROCESS_EXPIRING_PACK_POLICIES (v_intm_no,
                                           v_fr_date,
                                           v_to_date,
                                           p_inc_special_sw,
                                           v_line_cd,
                                           v_subline_cd,
                                           v_iss_cd,
                                           p_pol_issue_yy,
                                           p_pol_pol_seq_no,
                                           p_pol_renew_no,
                                           p_def_is_pol_summ_sw,
                                           p_def_same_polno_sw,
                                           v_plate_no,
                                           p_user_id,
                                           t_policy_id,
                                           t_line_cd,
                                           t_subline_cd,
                                           t_iss_cd,
                                           t_issue_yy,
                                           t_pol_seq_no,
                                           t_renew_no,
                                           t_expiry_date,
                                           t_incept_date,
                                           t_assd_no,
                                           t_auto_sw,
                                           t_intm_no);
          process_expiring_policies(v_intm_no,
                                   v_fr_date,
                                   v_to_date,
                                   p_inc_special_sw,
                                   v_line_cd,
                                   v_subline_cd,
                                   v_iss_cd,
                                   p_pol_issue_yy,
                                   p_pol_pol_seq_no,
                                   p_pol_renew_no,
                                   p_def_is_pol_summ_sw,
                                   p_def_same_polno_sw,
                                   v_plate_no,
                                   p_user_id,
                                   t_policy_id,
                                   t_line_cd,
                                   t_subline_cd,
                                   t_iss_cd,
                                   t_issue_yy,
                                   t_pol_seq_no,
                                   t_renew_no,
                                   t_expiry_date,
                                   t_incept_date,
                                   t_assd_no,
                                   t_auto_sw,
                                   t_intm_no);  */ --joanne 120513
        ELSE
         process_expiring_policies1(v_intm_no,
                                   v_fr_date,
                                   v_to_date,
                                   p_inc_special_sw,
                                   v_line_cd,
                                   v_subline_cd,
                                   v_iss_cd,
                                   p_pol_issue_yy,
                                   p_pol_pol_seq_no,
                                   p_pol_renew_no,
                                   p_def_is_pol_summ_sw,
                                   p_def_same_polno_sw,
                                   v_plate_no,
                                   p_user_id,
                                   p_cred_branch, --benjo 11.12.2015 UW-SPECS-2015-087
                                   t_policy_id,
                                   t_line_cd,
                                   t_subline_cd,
                                   t_iss_cd,
                                   t_issue_yy,
                                   t_pol_seq_no,
                                   t_renew_no,
                                   t_expiry_date,
                                   t_incept_date,
                                   t_assd_no,
                                   t_auto_sw,
                                   t_intm_no);
          /*process_expiring_policies(v_intm_no,
                                   v_fr_date,
                                   v_to_date,
                                   p_inc_special_sw,
                                   v_line_cd,
                                   v_subline_cd,
                                   v_iss_cd,
                                   p_pol_issue_yy,
                                   p_pol_pol_seq_no,
                                   p_pol_renew_no,
                                   p_def_is_pol_summ_sw,
                                   p_def_same_polno_sw,
                                   v_plate_no,
                                   p_user_id,
                                   t_policy_id,
                                   t_line_cd,
                                   t_subline_cd,
                                   t_iss_cd,
                                   t_issue_yy,
                                   t_pol_seq_no,
                                   t_renew_no,
                                   t_expiry_date,
                                   t_incept_date,
                                   t_assd_no,
                                   t_auto_sw,
                                   t_intm_no);     */--joanne 120513
        END IF;
     --IF t_policy_id.count = 0 THEN
    /* v_cnt := v_cnt + t_policy_id.count; --joanne
     IF v_cnt = 0 THEN    --joanne end
        p_msg := '2';
      ELSE
         v_param  := NULL;
         IF p_line_cd IS NOT NULL THEN
            v_param := v_param||' Line Code = ' || p_line_cd;
         END IF;
         IF p_subline_cd IS NOT NULL THEN
            v_param := v_param||' Subline Code = ' || p_subline_cd;
         END IF;
         IF p_iss_cd IS NOT NULL THEN
            v_param := v_param||' Branch Code = ' || p_iss_cd;
         END IF;
         IF v_param IS NOT NULL THEN
            p_msg := 'A total of ' ||to_char(v_cnt)/*to_char(t_policy_id.count) JOANNE|| */
      /*                ' policy(s) is to be extracted with the following parameter : '||
                      v_param || '. Would you like to continue? ';
         ELSE
            p_msg := 'A total of ' || to_char(v_cnt)/*to_char(t_policy_id.count) JOANNE*/
      /*                ' policy(s) is to be extracted. Would you like to continue? ';
         END IF;
         --p_policy_count := to_char(t_policy_id.count); --joanne
         p_policy_count := to_char(v_cnt); --joanne
      END IF;  */
      IF t_policy_id.count = 0 THEN
        p_msg := '2';
      ELSE
         v_param  := NULL;
         IF p_line_cd IS NOT NULL THEN
            v_param := v_param||' Line Code = ' || p_line_cd;
         END IF;
         IF p_subline_cd IS NOT NULL THEN
            v_param := v_param||' Subline Code = ' || p_subline_cd;
         END IF;
         IF p_iss_cd IS NOT NULL THEN
            v_param := v_param||' Branch Code = ' || p_iss_cd;
         END IF;
         IF v_param IS NOT NULL THEN
            p_msg := 'A total of ' || to_char(t_policy_id.count) ||
                      ' policy(s) is to be extracted with the following parameter : '||
                      v_param || '. Would you like to continue? ';
         ELSE
            p_msg := 'A total of ' || to_char(t_policy_id.count) ||
                      ' policy(s) is to be extracted. Would you like to continue? ';
         END IF;
         p_policy_count := to_char(t_policy_id.count);
      END IF;
    END extract_expiring_policies;

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 09.30.2011
    **  Reference By     : (GIEXS004- TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description      : update_balance_claim_flag program unit
    */
    PROCEDURE update_balance_claim_flag(
        p_all_user  VARCHAR2,
        p_user      giex_expiry.extract_user%TYPE
    )
    IS
      v_w_claim                varchar2(1);
      v_all_user               VARCHAR2(1):= NVL(p_all_user,'N'); --added by joanne 06.25.14, default all_user_sw is N --marco - SR-23395 - added NVL
      --commented by iris bordey 04.11.2003
      --for optimization
      /*CURSOR C IS
        SELECT e.line_cd, e.subline_cd, e.iss_cd, e.issue_yy, e.pol_seq_no, e.renew_no
          FROM giex_expiry e
         WHERE NVL(POST_FLAG,'N') = 'N' AND extract_user = :CG$CTRL.CG$US;*/
    BEGIN
      --SET_APPLICATION_PROPERTY(CURSOR_STYLE, 'BUSY');
      --message('Updating w/ balance flag....',NO_ACKNOWLEDGE);
      --synchronize;
      --commented by iris borde 04.11.2003
      --commented for optimization

      --reset balance flag of giex_expiry to null
      UPDATE giex_expiry
         SET balance_flag = NULL
       WHERE 1=1
         AND NVL(post_flag, 'N') = 'N'
         AND processor = p_user           --nieko 02082017
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user; joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user;

      UPDATE giex_pack_expiry
         SET balance_flag = NULL
       WHERE 1=1
         AND NVL(post_flag, 'N') = 'N'
         AND processor = p_user           --nieko 02082017
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user; joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user;

      UPDATE giex_expiry ge
         SET balance_flag = 'Y',
          user_id = p_user
       WHERE 1=1
         AND NVL(ge.post_flag, 'N') = 'N'
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user
         AND ge.processor = p_user           --nieko 02082017
         AND pack_policy_id IS NULL
         AND 0<(SELECT sum(nvl(gagd.balance_amt_due,0))
                  FROM giac_aging_soa_details GAGD,
                             gipi_polbasic B250
                         WHERE 1=1
                           AND B250.policy_id    = gagd.policy_id
                           AND B250.iss_cd       = gagd.iss_cd
                           AND B250.line_cd      = ge.line_cd
                           AND B250.subline_cd   = ge.subline_cd
                           AND B250.iss_cd       = ge.iss_cd
                           AND B250.issue_yy     = ge.issue_yy
                           AND B250.pol_seq_no   = ge.pol_seq_no
                           AND B250.renew_no     = ge.renew_no);
        --and update_flag = 'Y'; -- To only update expired policies that are set for process(update_flag = 'Y') - irwin 9.5.2012

      UPDATE giex_pack_expiry ge
         SET balance_flag = 'Y',
          user_id = p_user
       WHERE 1=1
         AND NVL(ge.post_flag, 'N') = 'N'
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user
         AND ge.processor = p_user           --nieko 02082017
         AND 0<(SELECT sum(nvl(gagd.balance_amt_due,0))
                  FROM giac_aging_soa_details GAGD,
                       gipi_polbasic a,
                             gipi_pack_polbasic B250
                         WHERE 1=1
                           AND a.policy_id       =  gagd.policy_id
                           AND B250.pack_policy_id    = a.pack_policy_id
                            AND B250.iss_cd       = gagd.iss_cd
                           AND B250.line_cd      = ge.line_cd
                           AND B250.subline_cd   = ge.subline_cd
                            AND B250.iss_cd       = ge.iss_cd
                           AND B250.issue_yy     = ge.issue_yy
                           AND B250.pol_seq_no   = ge.pol_seq_no
                           AND B250.renew_no     = ge.renew_no); --and update_flag = 'Y'; -- To only update expired policies that are set for process(update_flag = 'Y') - irwin 9.5.2012

       UPDATE giex_expiry a
          SET balance_flag = 'Y'
        WHERE 1=1
            AND processor = p_user           --nieko 02082017
            AND EXISTS (SELECT '1'
                        FROM giex_pack_expiry b
                       WHERE a.pack_policy_id = b.pack_policy_id
                         AND b.balance_flag = 'Y');
                         --and update_flag = 'Y'; -- To only update expired policies that are set for process(update_flag = 'Y') - irwin 9.5.2012

       /*FOR cur_a IN C LOOP
           FOR cur_b IN ( SELECT sum(nvl(gagd.balance_amt_due,0)) balance_amt_due
                                          FROM giac_aging_soa_details GAGD,
                                                gipi_polbasic B250
                                          WHERE B250.policy_id  = gagd.policy_id
                                            AND B250.iss_cd     = gagd.iss_cd
                                            AND B250.line_cd    = cur_a.line_cd
                                                AND B250.subline_cd = cur_a.subline_cd
                                                    AND B250.iss_cd     = cur_a.iss_cd
                                                AND B250.issue_yy   = cur_a.issue_yy
                                                AND B250.pol_seq_no = cur_a.pol_seq_no
                                                AND B250.renew_no   = cur_a.renew_no
                                      GROUP BY B250.line_cd,
                                                        B250.subline_cd,
                                                            B250.iss_cd,
                                                        B250.issue_yy,
                                                      B250.pol_seq_no,
                                                        B250.renew_no ) LOOP
                IF cur_b.balance_amt_due = 0 THEN
                UPDATE giex_expiry
                   SET balance_flag = null
                 WHERE line_cd      = cur_a.line_cd
                   AND subline_cd   = cur_a.subline_cd
                   AND iss_cd       = cur_a.iss_cd
                   AND issue_yy     = cur_a.issue_yy
                   AND pol_seq_no   = cur_a.pol_seq_no
                   AND renew_no     = cur_a.renew_no;
           ELSE
                UPDATE giex_expiry
                   SET balance_flag = 'Y'
                 WHERE line_cd      = cur_a.line_cd
                   AND subline_cd   = cur_a.subline_cd
                   AND iss_cd       = cur_a.iss_cd
                   AND issue_yy     = cur_a.issue_yy
                   AND pol_seq_no   = cur_a.pol_seq_no
                   AND renew_no     = cur_a.renew_no;
           END IF;
         END LOOP;
        END LOOP;                                                    */
      --commit;
      --clear_message;
      --message('W/ balance flag updated succesfully.',NO_ACKNOWLEDGE);
      --synchronize;
      --message('Updating w/ claim flag....',NO_ACKNOWLEDGE);
      --synchronize;
      --commented by iris bordey 04.11.2003
      --commented for optimization
      /*FOR cur_c IN c LOOP
           v_w_claim := 'N';
           FOR cur_d IN ( SELECT '1'
                                     FROM gicl_claims C003
                                          WHERE C003.line_cd    = cur_c.line_cd
                                                  AND C003.subline_cd = cur_c.subline_cd
                                                   AND C003.pol_iss_cd = cur_c.iss_cd
                                                  AND C003.issue_yy   = cur_c.issue_yy
                                                  AND C003.pol_seq_no = cur_c.pol_seq_no
                                                  AND C003.renew_no   = cur_c.renew_no
                                                  AND C003.clm_stat_cd NOT IN ('CC','WD','DN','CD') ) LOOP
                      v_w_claim := 'Y';
             EXIT;
             END LOOP;
                 IF v_w_claim = 'Y' THEN
                       UPDATE giex_expiry
                       SET claim_flag = 'Y'
                     WHERE line_cd = cur_c.line_cd
                       AND subline_cd = cur_c.subline_cd
                       AND iss_cd = cur_c.iss_cd
                       AND issue_yy = cur_c.issue_yy
                       AND pol_seq_no = cur_c.pol_seq_no
                       AND renew_no = cur_c.renew_no;
                 ELSE
                       UPDATE giex_expiry
                       SET claim_flag = null
                     WHERE line_cd = cur_c.line_cd
                       AND subline_cd = cur_c.subline_cd
                       AND iss_cd = cur_c.iss_cd
                       AND issue_yy = cur_c.issue_yy
                       AND pol_seq_no = cur_c.pol_seq_no
                       AND renew_no = cur_c.renew_no;
             END IF;
      END LOOP;  */
      --reset claim_flag of giex_expiry
      /*
      **nieko 02082017
      UPDATE giex_expiry
         SET claim_flag = NULL
       WHERE 1=1
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user
         AND NVL(POST_FLAG,'N') = 'N';*/

      UPDATE giex_expiry
         SET claim_flag = NULL
       WHERE 1=1
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user
         AND processor = p_user           --nieko 02082017
         AND NVL(POST_FLAG,'N') = 'N';

      UPDATE giex_expiry ge
         SET claim_flag = 'Y',
         user_id = p_user
       WHERE 1=1
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user
         AND ge.processor = p_user           --nieko 02082017
         AND NVL(POST_FLAG,'N') = 'N'
         AND EXISTS (SELECT '1'
                       FROM gicl_claims gc
                              WHERE gc.line_cd    = ge.line_cd
                                AND gc.subline_cd = ge.subline_cd
                                --AND gc.iss_cd     = ge.iss_cd --marco - 04.20.2013 - changed to pol_iss_cd
                                AND gc.pol_iss_cd     = ge.iss_cd
                                AND gc.issue_yy   = ge.issue_yy
                                AND gc.pol_seq_no = ge.pol_seq_no
                                AND gc.renew_no   = ge.renew_no
                                AND gc.clm_stat_cd NOT IN ('CC','WD','DN'));
 --and update_flag = 'Y'; -- To only update expired policies that are set for process(update_flag = 'Y') - irwin 9.5.2012

      UPDATE giex_pack_expiry ge
         SET claim_flag = 'Y',
         user_id = p_user
       WHERE 1=1
         --AND decode(p_all_user,'Y',p_user,extract_user) = p_user joanne 06.25.14
         AND decode(v_all_user,'Y',p_user,extract_user) = p_user
         AND ge.processor = p_user           --nieko 02082017
         AND NVL(POST_FLAG,'N') = 'N'
         AND EXISTS (SELECT '1'
                       FROM gicl_claims gc
                              WHERE gc.line_cd    = ge.line_cd
                                AND gc.subline_cd = ge.subline_cd
                                --AND gc.iss_cd     = ge.iss_cd --marco - 04.20.2013 - changed to pol_iss_cd
                                AND gc.pol_iss_cd     = ge.iss_cd
                                AND gc.issue_yy   = ge.issue_yy
                                AND gc.pol_seq_no = ge.pol_seq_no
                                AND gc.renew_no   = ge.renew_no
                                AND gc.clm_stat_cd NOT IN ('CC','WD','DN'));
 --and update_flag = 'Y'; -- To only update expired policies that are set for process(update_flag = 'Y') - irwin 9.5.2012

       UPDATE giex_expiry a
          SET claim_flag = 'Y'
        WHERE 1 = 1
          AND processor = p_user           --nieko 02082017
          AND EXISTS (SELECT '1'
                        FROM giex_pack_expiry b
                       WHERE a.pack_policy_id = b.pack_policy_id
                         AND b.claim_flag = 'Y');

 --and update_flag = 'Y'; -- To only update expired policies that are set for process(update_flag = 'Y') - irwin 9.5.2012


      --clear_message;
      --message('W/ claim flag updated succesfully.',NO_ACKNOWLEDGE);
      --synchronize;
      --execute_query;
      --clear_message;
      --SET_APPLICATION_PROPERTY(CURSOR_STYLE, 'DEFAULT');
    END update_balance_claim_flag;

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 10.06.2011
    **  Reference By     : (GIEXS004- TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description      : ar_validation program unit
    */
    PROCEDURE ar_validation(
        p_is_package            VARCHAR2,
        p_from_post_query       VARCHAR2,
        p_policy_id             giex_expiry.policy_id%TYPE,
        p_update_flag           giex_expiry.update_flag%TYPE,
        p_same_polno_sw         giex_expiry.same_polno_sw%TYPE,
        p_summary_sw            giex_expiry.summary_sw%TYPE,
        p_non_ren_reason        giex_expiry.non_ren_reason%TYPE,
        p_non_ren_reason_cd     giex_expiry.non_ren_reason_cd%TYPE,
        p_peril_pol_id      OUT giex_expiry.policy_id%TYPE,
        p_need_commit       OUT VARCHAR2,
        p_override_ok       OUT VARCHAR2,
        p_msg               OUT VARCHAR2
    )
    IS
      --alert_id       ALERT;
      --alert_but      NUMBER;
    BEGIN

      --VJ 120905 if tagged for non-renewal, requires the user to add a reason for non-renewal
      /*IF p_renew_flag = '1' THEN
          IF p_require_nr_reason = 'Y' THEN
             p_msg := 1;
             RETURN;
             --variables.required := 'Y';
               --set_item_property('f000.non_ren_reason',required,property_true);
           --go_item('f000.non_ren_reason_cd'); --modified by randell 03062007, cursor location set to non_ren_reason_cd field (previously set on non_ren_reason)
             --msg_alert('Please enter reason for non-renewal','I',false);
        END IF;
      ELSE
          p_msg := 2;
          RETURN;
        --variables.required := 'N';
        --set_item_property('f000.non_ren_reason',required,property_false);
      END IF;*/
      --BETH 08022000 if policy have existing records in giex_itmperil, flash a message that will
      --     warn the user that records in giex_itmperil would be deleted, or else summary_sw
      --     cannot be changed
      IF p_is_package = 'Y' THEN
          FOR A IN (SELECT a.policy_id
                      FROM giex_itmperil a, giex_expiry b
                     WHERE b.pack_policy_id = p_policy_id
                       AND a.policy_id = b.policy_id)
          LOOP
            /*alert_id   := FIND_ALERT('DELETE2');
            alert_but  := SHOW_ALERT(ALERT_ID);
            IF alert_but = ALERT_BUTTON1 THEN
               DELETE giex_itmperil
                WHERE policy_id = a.policy_id;
            ELSE
               :f000.renew_flag := '2';
               RAISE FORM_TRIGGER_FAILURE;
            END IF;
            EXIT; */
            p_peril_pol_id := a.policy_id;
            p_msg := 1;
            RETURN;
          END LOOP;
      ELSE
          FOR A IN (SELECT '1'
                      FROM giex_itmperil
                     WHERE policy_id = p_policy_id)
          LOOP
            /*alert_id   := FIND_ALERT('DELETE2');
            alert_but  := SHOW_ALERT(ALERT_ID);
            IF alert_but = ALERT_BUTTON1 THEN
               DELETE giex_itmperil
                WHERE policy_id = :f000.policy_id;
            ELSE
               :f000.renew_flag := '2';
               RAISE FORM_TRIGGER_FAILURE;
            END IF;
            EXIT; */
            p_msg := 2;
            RETURN;
          END LOOP;
      END IF;

      IF p_from_post_query = 'N' THEN
            IF p_is_package = 'Y' THEN
              UPDATE giex_pack_expiry
                 SET update_flag       = p_update_flag,
                     same_polno_sw     = p_same_polno_sw,
                     summary_sw        = p_summary_sw,
                     non_ren_reason    = p_non_ren_reason,
                     non_ren_reason_cd = p_non_ren_reason_cd
               WHERE pack_policy_id    = p_policy_id;
              UPDATE giex_expiry
                 SET update_flag       = p_update_flag,
                     same_polno_sw     = p_same_polno_sw,
                     summary_sw        = p_summary_sw,
                     non_ren_reason    = p_non_ren_reason,
                     non_ren_reason_cd = p_non_ren_reason_cd
               WHERE pack_policy_id    = p_policy_id;
            ELSE
              UPDATE giex_expiry
                 SET update_flag       = p_update_flag,
                     same_polno_sw     = p_same_polno_sw,
                     summary_sw        = p_summary_sw,
                     non_ren_reason    = p_non_ren_reason,
                     non_ren_reason_cd = p_non_ren_reason_cd
               WHERE policy_id         = p_policy_id;
            END IF;
            p_need_commit := 'Y';
            p_override_ok := 'Y';--vin 9.23.2010 so that override process will not be repeated once process button is pressed
      END IF;

      --F000_FIELD_UPDATES;

    END ar_validation;

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 10.18.2011
    **  Reference By     : (GIEXS004- TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description      : updates giex_expiry/giex_pack_expiry before processing program unit
    */
    PROCEDURE update_f000_field(
        p_from_post_query   VARCHAR2,
        p_is_package        VARCHAR2,
        p_summary_sw        giex_pack_expiry.summary_sw%TYPE,
        p_same_polno_sw     giex_pack_expiry.same_polno_sw%TYPE,
        p_update_flag       giex_pack_expiry.update_flag%TYPE,
        p_balance_flag      giex_pack_expiry.balance_flag%TYPE,
        p_claim_flag        giex_pack_expiry.claim_flag%TYPE,
        p_reg_policy_sw     giex_pack_expiry.reg_policy_sw%TYPE,
        p_renew_flag        giex_pack_expiry.renew_flag%TYPE,
        p_remarks           giex_pack_expiry.remarks%TYPE,
        p_non_ren_reason_cd giex_pack_expiry.non_ren_reason_cd%TYPE,
        p_non_ren_reason    giex_pack_expiry.non_ren_reason%TYPE,
        p_policy_id         giex_pack_expiry.pack_policy_id%TYPE,
        p_processor         giex_expiry.processor%TYPE -- andrew - 09212015 - SR 4942
    )
    IS
    BEGIN
        IF p_from_post_query = 'N' THEN
                --message('hey');message('hey');
            IF p_is_package = 'Y' THEN
                UPDATE giex_pack_expiry
                   SET summary_sw         = nvl(p_summary_sw,summary_sw),
                       same_polno_sw      = nvl(p_same_polno_sw,same_polno_sw),
                       update_flag        = nvl(p_update_flag,update_flag),
                       balance_flag       = nvl(p_balance_flag,balance_flag),
                       claim_flag         = nvl(p_claim_flag,claim_flag),
                       reg_policy_sw      = nvl(p_reg_policy_sw,reg_policy_sw),
                       renew_flag         = nvl(p_renew_flag,renew_flag),
                       remarks            = p_remarks,
                       non_ren_reason_cd  = p_non_ren_reason_cd,
                       non_ren_reason       = p_non_ren_reason,
                       processor          = p_processor -- andrew - 09212015 - SR 4942
                 WHERE pack_policy_id     = p_policy_id;
                UPDATE giex_expiry
                   SET summary_sw         = nvl(p_summary_sw,summary_sw),
                       same_polno_sw      = nvl(p_same_polno_sw,same_polno_sw),
                       update_flag        = nvl(p_update_flag,update_flag),
                       balance_flag       = nvl(p_balance_flag,balance_flag),
                       claim_flag         = nvl(p_claim_flag,claim_flag),
                       reg_policy_sw      = nvl(p_reg_policy_sw,reg_policy_sw),
                       renew_flag         = nvl(p_renew_flag,renew_flag),
                       remarks            = p_remarks,
                       non_ren_reason_cd  = p_non_ren_reason_cd,
                       non_ren_reason       = p_non_ren_reason,
                       processor          = p_processor -- andrew - 09212015 - SR 4942
                 WHERE pack_policy_id     = p_policy_id;
            ELSE
                UPDATE giex_expiry
                   SET summary_sw         = nvl(p_summary_sw,summary_sw),
                       same_polno_sw      = nvl(p_same_polno_sw,same_polno_sw),
                       update_flag        = nvl(p_update_flag,update_flag),
                       balance_flag       = nvl(p_balance_flag,balance_flag),
                       claim_flag         = nvl(p_claim_flag,claim_flag),
                       reg_policy_sw      = nvl(p_reg_policy_sw,reg_policy_sw),
                       renew_flag         = nvl(p_renew_flag,renew_flag),
                       remarks            = p_remarks,
                       non_ren_reason_cd  = p_non_ren_reason_cd,
                       non_ren_reason       = p_non_ren_reason,
                       processor          = p_processor -- andrew - 09212015 - SR 4942
                 WHERE policy_id          = p_policy_id;
            END IF;
        END IF;
     
     /* SR-5896 01.04.2017 - commented out by VJ, to avoid deadlocks as reported by UCPB
     UPDATE giex_expiry a
        SET update_flag = 'Y'
      WHERE EXISTS (SELECT '1'
                     FROM giex_pack_expiry b
                    WHERE a.pack_policy_id = b.pack_policy_id
                      AND b.update_flag = 'Y');*/ 
    END update_f000_field;


    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves B240 data block
    */
    FUNCTION get_giexs007_b240_info (
        p_pack_policy_id    giex_expiry.pack_policy_id%TYPE,
        p_policy_id         giex_expiry.policy_id%TYPE
    )
    RETURN giex_expiry_tab PIPELINED
    IS
        v_expiry           giex_expiry_type;
        v_stmt_str         VARCHAR2(2000);
        TYPE exp_cur_type  IS REF CURSOR;
        v_exp_cursor       exp_cur_type;
        exp_record         giex_expiry%ROWTYPE;
    BEGIN
        v_stmt_str := ' SELECT * FROM giex_expiry';

         IF p_pack_policy_id IS NOT NULL AND p_pack_policy_id <> 0 THEN
             v_stmt_str := v_stmt_str ||' WHERE pack_policy_id = :pack_policy_id ' ||
                                        '  AND (1=1 OR :policy_id IS NULL) ';
         ELSE
             v_stmt_str := v_stmt_str ||' WHERE (1=1 OR :pack_policy_id IS NULL) '||
                                        ' AND policy_id = :policy_id';
         END IF;

         OPEN v_exp_cursor FOR v_stmt_str USING p_pack_policy_id, p_policy_id;

         LOOP
            FETCH v_exp_cursor INTO exp_record;
              v_expiry.incept_date            := exp_record.incept_date;
              v_expiry.policy_id              := exp_record.policy_id;
              v_expiry.pack_policy_id         := exp_record.pack_policy_id;
              v_expiry.line_cd                := exp_record.line_cd;
              v_expiry.subline_cd             := exp_record.subline_cd;
              v_expiry.iss_cd                 := exp_record.iss_cd;
              v_expiry.assd_no                := exp_record.assd_no;
              v_expiry.summary_sw             := exp_record.summary_sw;
              v_expiry.renew_flag             := exp_record.renew_flag;
              EXIT;
         END LOOP;

         IF p_pack_policy_id IS NOT NULL AND p_pack_policy_id <> 0 THEN
            --GET_PACK_NUMBER;
            BEGIN
              SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                INTO v_expiry.dsp_pack_line_cd,
                     v_expiry.dsp_pack_subline_cd,
                     v_expiry.dsp_pack_iss_cd,
                     v_expiry.dsp_pack_issue_yy,
                     v_expiry.dsp_pack_pol_seq_no,
                     v_expiry.dsp_pack_renew_no
                  FROM giex_pack_expiry
                 WHERE pack_policy_id = p_pack_policy_id;
               v_expiry.v_is_pack   := 'Y';
            EXCEPTION
              WHEN TOO_MANY_ROWS THEN
                --msg_alert('Duplicate package policy exists in GIEX_PACK_EXPIRY','I',TRUE);
                raise_application_error('-20001', 'Duplicate package policy exists in GIEX_PACK_EXPIRY');
              WHEN NO_DATA_FOUND THEN
                --msg_alert('Package policy does not exist','I',TRUE);
                raise_application_error('-20001', 'Package policy does not exist');
            END;
         END IF;
         FOR A IN (SELECT   pack_pol_flag
                    FROM   giis_line
                   WHERE   line_cd  =  v_expiry.line_cd)
         LOOP
            v_expiry.pack_pol_flag  :=  NVL(A.pack_pol_flag,'N');
            EXIT;
         END LOOP;

         BEGIN
            FOR a IN (SELECT line_cd,subline_cd,iss_cd,issue_yy, pol_seq_no, renew_no,prorate_flag,
                           endt_expiry_date,eff_date,
                           short_rt_percent,prov_prem_pct,
                           prov_prem_tag, expiry_date
                    FROM   gipi_polbasic
                   WHERE   policy_id  =  v_expiry.policy_id)
            LOOP
              v_expiry.nbt_issue_yy         :=  a.issue_yy;
              v_expiry.nbt_pol_seq_no       :=  a.pol_seq_no;
              v_expiry.nbt_renew_no         :=  a.renew_no;
              v_expiry.nbt_prorate_flag     :=  2; /* value replaced with hardcoded 2(straight 1 year) ang renewal ay annual basis plagi */ --A.prorate_flag;
              v_expiry.endt_expiry_date     :=  a.endt_expiry_date;
              v_expiry.eff_date             :=  a.eff_date;
              v_expiry.expiry_date          :=  a.expiry_date;
              v_expiry.short_rt_percent     :=  a.short_rt_percent;
              v_expiry.prov_prem_pct        :=  a.prov_prem_pct;
              v_expiry.prov_prem_tag        :=  a.prov_prem_tag;
              EXIT;
            END LOOP;
            BEGIN
              DECLARE
                CURSOR C IS
                  SELECT A020.ASSD_NAME
                  FROM   GIIS_ASSURED A020
                  WHERE  A020.ASSD_NO = v_expiry.assd_no;
              BEGIN
                OPEN C;
                FETCH C
                INTO   v_expiry.dsp_assd_name;
                IF C%NOTFOUND THEN
                  RAISE NO_DATA_FOUND;
                END IF;
                CLOSE C;
                END;
            END;
         /*EXCEPTION
           WHEN NO_DATA_FOUND THEN
            message('Error: This Assured Name does not exist');*/
         END;

         FOR A1 IN (SELECT NVL(comp_sw, 'N') comp_sw
                       FROM gipi_polbasic
                      WHERE policy_id = v_expiry.policy_id)
          LOOP
              v_expiry.v_comp_sw := A1.comp_sw;
              EXIT;
          END LOOP;
          IF NVL(v_expiry.summary_sw, 'N') = 'Y' THEN
             v_expiry.nbt_prorate_flag  :=  '2';
             v_expiry.short_rt_percent  :=  NULL;
             v_expiry.prov_prem_pct     :=  NULL;
             v_expiry.prov_prem_tag     :=  'N';
             v_expiry.v_comp_sw         := 'N';
          END IF;

          FOR a2 IN (SELECT 1
                      FROM gipi_itmperil_grouped
                     WHERE policy_id = v_expiry.policy_id)
          LOOP
            v_expiry.v_is_gpa := 'Y';
          END LOOP;

          IF NVL(v_expiry.v_is_gpa, 'N') = 'N' THEN
              FOR A IN (SELECT '1'
                    FROM giex_itmperil
                   WHERE policy_id = v_expiry.policy_id)
              LOOP
                v_expiry.v_sw := 'Y';
              END LOOP;
          ELSE
              FOR A IN (SELECT '1'
                    FROM giex_itmperil_grouped
                   WHERE policy_id = v_expiry.policy_id)
              LOOP
                v_expiry.v_sw := 'Y';
              END LOOP;
          END IF;

          PIPE ROW (v_expiry);
    END get_giexs007_b240_info;

    /*GIEXS006 START*/
    FUNCTION get_policy_id (
        p_fr_rn_seq_no      giex_rn_no.rn_seq_no%TYPE,
        p_to_rn_seq_no      giex_rn_no.rn_seq_no%TYPE,
        p_assd_no           giex_expiry.assd_no%TYPE,
        p_intm_no           giex_expiry.intm_no%TYPE,
        p_iss_cd            giex_expiry.iss_cd%TYPE,
        p_subline_cd        giex_expiry.subline_cd%TYPE,
        p_line_cd           giex_expiry.line_cd%TYPE,
        p_start_date        giex_expiry.expiry_date%TYPE,
        p_end_date          giex_expiry.expiry_date%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_renew_flag        giex_expiry.renew_flag%TYPE,
		p_req_renewal_no    VARCHAR2,
        p_prem_balance_only VARCHAR2,	--Gzelle 05202015 SR3703
        p_claims_only       VARCHAR2	--Gzelle 05202015 SR3698
    )
    RETURN giex_expiry_tab PIPELINED IS
        v_policy_id         giex_expiry_type;
    BEGIN
        IF p_req_renewal_no = 'Y' THEN
            FOR i IN(SELECT a.policy_id, a.line_cd
                         FROM giex_expiry a, giex_rn_no b
                        WHERE a.renew_flag = p_renew_flag
                          AND a.policy_id = b.policy_id
                          AND b.rn_seq_no BETWEEN NVL(p_fr_rn_seq_no,b.rn_seq_no) AND NVL(p_to_rn_seq_no,b.rn_seq_no)
                          AND NVL(a.post_flag,'N') = 'N' --Added by Jerome Bautista 07.29.2015 SR 19689/19538/19673
                          --AND a.policy_id = NVL(:fblock.dsp_policy_id, a.policy_id)
                          AND a.assd_no = NVL(p_assd_no, a.assd_no)
                          AND NVL(a.intm_no,0) = NVL(p_intm_no,NVL(a.intm_no,0))
                          AND UPPER(a.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
                          AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
                          AND UPPER(a.line_cd) = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
                          AND TRUNC(a.expiry_date) <= TRUNC(NVL(p_end_date, NVL(p_start_date, a.expiry_date)))
                          AND TRUNC(a.expiry_date) >= DECODE(p_end_date, NULL, TRUNC(a.expiry_date), TRUNC(NVL(p_start_date, a.expiry_date)))
                          AND a.extract_user = p_user_id
                          AND NVL(a.claim_flag,'N') LIKE NVL(p_claims_only,'%') --Gzelle 05202015 SR3698
                          AND NVL(a.balance_flag,'N') LIKE NVL(p_prem_balance_only,'%')   --Gzelle 05202015 SR3703
                          )
            LOOP
                v_policy_id.policy_id := i.policy_id;
                v_policy_id.line_cd   := i.line_cd;
                PIPE ROW(v_policy_id);
            END LOOP;
        ELSIF p_req_renewal_no = 'N' THEN
            FOR j IN(SELECT b.policy_id, b.line_cd
                       FROM giex_expiry b
                      WHERE b.renew_flag = p_renew_flag
                         --AND b.policy_id = NVL(p_policy_id, b.policy_id)
                         AND NVL(b.post_flag,'N') = 'N' --Added by Jerome Bautista 07.29.2015 SR 19689/19538/19673
                         AND b.assd_no = NVL(p_assd_no, b.assd_no)
                         AND NVL(b.intm_no,0) = NVL(p_intm_no,NVL(b.intm_no,0))
                         AND UPPER(b.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(b.iss_cd))
                         AND UPPER(b.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(b.subline_cd))
                         AND UPPER(b.line_cd) = NVL(UPPER(p_line_cd),UPPER(b.line_cd))
                         AND TRUNC(b.expiry_date) <= TRUNC(NVL(p_end_date, NVL(p_start_date, b.expiry_date)))
                         AND TRUNC(b.expiry_date) >= DECODE(p_end_date, NULL, TRUNC(b.expiry_date), TRUNC(NVL(p_start_date, b.expiry_date)))
                         AND b.extract_user = p_user_id
                         AND NVL(b.claim_flag,'N') LIKE NVL(p_claims_only,'%') --Gzelle 05202015 SR3698
                         AND NVL(b.balance_flag,'N') LIKE NVL(p_prem_balance_only,'%')   --Gzelle 05202015 SR3703
                         )
            LOOP
                v_policy_id.policy_id := j.policy_id;
                v_policy_id.line_cd   := j.line_cd;
                PIPE ROW(v_policy_id);
            END LOOP;
        END IF;
    END get_policy_id;

    FUNCTION check_policy_id_giexs006 (
    p_policy_id        giex_expiry.policy_id%TYPE
    )
    RETURN VARCHAR2 IS
        v_result VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN(SELECT '1'
                   FROM giex_expiry
                  WHERE policy_id = p_policy_id)
        LOOP
            v_result := 'Y';
        END LOOP;
        RETURN v_result;
    END check_policy_id_giexs006;

    FUNCTION pop_non_ren_notice (
        p_policy_id        giex_expiry.policy_id%TYPE,
        p_assd_no        giex_expiry.assd_no%TYPE,
        p_intm_no        giex_expiry.intm_no%TYPE,
        p_iss_cd        giex_expiry.iss_cd%TYPE,
        p_subline_cd    giex_expiry.subline_cd%TYPE,
        p_line_cd        giex_expiry.line_cd%TYPE,
        p_start_date    giex_expiry.expiry_date%TYPE,
        p_end_date        giex_expiry.expiry_date%TYPE,
        p_user_id        giis_users.user_id%TYPE
    )
        RETURN pop_non_ren_notice_tab PIPELINED
    IS
        v_res    pop_non_ren_notice_type;
        --v_policy_id        giex_expiry.policy_id%TYPE;
    BEGIN
            FOR i IN(SELECT b.policy_id,b.line_cd,d.line_name,b.iss_cd,non_ren_reason,
                            LTRIM(TO_CHAR(b.intm_no,'999999999999')) intm_no,c.ref_intm_cd,b.loc_risk1,b.loc_risk2,
                            b.loc_risk3
                         FROM giex_expiry b,giis_intermediary c,giis_line d
                        WHERE 1=1
                         AND b.renew_flag = '2' -- 1 dapat
                        and b.line_cd = d.line_cd
                          and c.intm_no = b.intm_no
                        AND b.policy_id = NVL(p_policy_id, b.policy_id)
                        AND b.assd_no = NVL(p_assd_no, b.assd_no)
                          AND NVL(b.intm_no,0) = NVL(p_intm_no,NVL(b.intm_no,0))
                        AND UPPER(b.iss_cd)    = NVL(UPPER(p_iss_cd),UPPER(b.iss_cd))
                        AND UPPER(b.subline_cd)    = NVL(UPPER(p_subline_cd),UPPER(b.subline_cd))
                        AND UPPER(b.line_cd)    = NVL(UPPER(p_line_cd),UPPER(b.line_cd))
                          AND TRUNC(b.expiry_date) <=TRUNC(NVL(p_end_date, NVL(p_start_date, b.expiry_date)))
                        AND TRUNC(b.expiry_date) >= DECODE(p_end_date, NULL, TRUNC(b.expiry_date), TRUNC(NVL(p_start_date, b.expiry_date)))
                        AND b.extract_user = p_user_id)
            LOOP
                v_res.policy_id      := i.policy_id;
                --v_policy_id      := i.policy_id;
                /*v_res.line_cd         := i.line_cd;
                v_res.line_name         := i.line_name;
                v_res.iss_cd         := i.iss_cd;
                v_res.non_ren_reason := i.non_ren_reason;
                v_res.intm_no         := i.intm_no;
                v_res.ref_intm_cd     := i.ref_intm_cd;
                v_res.loc_risk         := i.loc_risk1||' '||i.loc_risk2||' '||i.loc_risk3;

                FOR j IN(SELECT signatory,designation
                              FROM giis_signatory_names a,
                                   giis_signatory b
                             WHERE a. signatory_id = b.signatory_id
                               AND b.current_signatory_sw = 'Y'
                               AND line_cd         = i.line_cd
                               AND iss_cd          = i.iss_cd
                               AND report_id     = 'NON_RENEW')
                LOOP
                    v_res.sign    := j.signatory;
                    v_res.des    := j.designation;
                END LOOP;*/



                PIPE ROW(v_res);
            END LOOP;
    END;

    /*GIEXS006 END*/

    /*
    **  Created by   : Marco Paolo Rebong
    **  Date Created : February, 2013
    **  Reference By : (GISMS007- SMS Renewal)
    **  Description  : retrieves policies for sms renewal tablegrid
    */
    FUNCTION get_sms_renewal_policies(
        p_line_cd       GIEX_EXPIRY.line_cd%TYPE,
        p_subline_cd    GIEX_EXPIRY.subline_cd%TYPE,
        p_iss_cd        GIEX_EXPIRY.iss_cd%TYPE,
        p_issue_yy      GIEX_EXPIRY.issue_yy%TYPE,
        p_pol_seq_no    GIEX_EXPIRY.pol_seq_no%TYPE,
        p_renew_no      GIEX_EXPIRY.renew_no%TYPE,
        p_tsi_amt       GIEX_EXPIRY.tsi_amt%TYPE,
        p_prem_amt      GIEX_EXPIRY.prem_amt%TYPE,
        p_expiry_date   VARCHAR2,
        p_policy_no     VARCHAR2,
        p_renew_flag    GIEX_EXPIRY.renew_flag%TYPE,
        p_user_id       GIEX_EXPIRY.user_id%TYPE -- marco - 05.26.2015 - GENQA SR 4485
    )
      RETURN sms_renewal_tab PIPELINED
    IS
        v_sms               sms_renewal_type;
        v_chk_received      VARCHAR2(1);
        v_chk_sent          VARCHAR2(1);
    BEGIN
        FOR i IN(SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                        tsi_amt, prem_amt, expiry_date, assd_no, intm_no,
                        renew_flag, balance_flag, claim_flag,
                        user_id, last_update, remarks, pack_policy_id,
                        assd_sms, intm_sms, post_flag
                   FROM GIEX_EXPIRY
                  WHERE NVL(post_flag ,'N') = 'N'
                    AND UPPER(line_cd) LIKE UPPER(NVL(p_line_cd, line_cd))
                    AND UPPER(subline_cd) LIKE UPPER(NVL(p_subline_cd, subline_cd))
                    AND UPPER(iss_cd) LIKE UPPER(NVL(p_iss_cd, iss_cd))
                    AND issue_yy = NVL(p_issue_yy, issue_yy)
                    AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                    AND renew_no = NVL(p_renew_no, renew_no)
                    AND NVL(prem_amt, 0) = NVL(p_prem_amt, NVL(prem_amt, 0))
                    AND NVL(tsi_amt, 0) = NVL(p_tsi_amt, NVL(tsi_amt, 0))
                    AND TRUNC(expiry_date) = TRUNC(NVL(TO_DATE(p_expiry_date, 'MM-DD-YYYY'), expiry_date))
                    AND UPPER(line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM(TO_CHAR(issue_yy, '09')) || '-'
                        || LTRIM (TO_CHAR (pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (renew_no, '09'))) LIKE
                        UPPER(NVL(p_policy_no, UPPER(line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM(TO_CHAR(issue_yy, '09')) || '-'
                        || LTRIM (TO_CHAR (pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (renew_no, '09')))))
                    AND (NVL(renew_flag, 0) = NVL(p_renew_flag, NVL(renew_flag, 0))
                     OR (renew_flag = 1 AND (UPPER(p_renew_flag) = 'NR' OR UPPER(p_renew_flag) = 'NON RENEWAL'))
                     OR (renew_flag = 2 AND (UPPER(p_renew_flag) = 'R' OR UPPER(p_renew_flag) = 'RENEWAL'))
                     OR (renew_flag = 3 AND (UPPER(p_renew_flag) = 'AR' OR UPPER(p_renew_flag) = 'AUTO RENEWAL'))
                     )
                    AND check_user_per_iss_cd2(line_cd, iss_cd, 'GISMS007', p_user_id) = 1 -- marco - 05.26.2015 - GENQA SR 4485
                  ORDER BY line_cd, subline_cd, iss_cd, expiry_date)
        LOOP
            v_sms := NULL;

            FOR a IN(SELECT COUNT(date_received) date_received, COUNT(date_sent) date_sent
                       FROM GIEX_SMS_DTL
                      WHERE policy_id = i.policy_id)
            LOOP
                IF a.date_received > 0 THEN
                    v_chk_received := 'Y';
                ELSE
                    v_chk_received := 'N';
                END IF;

                IF a.date_sent > 0 THEN
                    v_chk_sent := 'Y';
                ELSE
                    v_chk_sent := 'N';
                END IF;
            END LOOP;

            FOR b IN(SELECT message_type
                       FROM GIEX_SMS_DTL
                      WHERE policy_id = i.policy_id)
            LOOP
                IF b.message_type = 'R' THEN
                    v_sms.sms_for_renew := 'Y';
                END IF;

                IF b.message_type = 'N' THEN
                    v_sms.sms_for_non_renew := 'Y';
                END IF;
            END LOOP;

            FOR a IN (SELECT assd_name, cp_no
                        FROM GIIS_ASSURED
                       WHERE assd_no = i.assd_no)
            LOOP
                v_sms.assd_name := a.assd_name;
                v_sms.cp_no := NVL(a.cp_no, '');
            END LOOP;

            FOR a IN (SELECT cp_no
                        FROM GIIS_INTERMEDIARY
                       WHERE intm_no = i.intm_no)
            LOOP
                v_sms.intm_cp_no := NVL(a.cp_no, '');
            END LOOP;

            FOR a IN (SELECT intm_name
                        FROM GIIS_INTERMEDIARY
                       WHERE intm_no = i.intm_no)
            LOOP
                v_sms.intm_name := a.intm_name;
            END LOOP;

            FOR x IN(SELECT DISTINCT policy_id
                      FROM GIEX_SMS_DTL b,
                           GISM_MESSAGES_SENT a
                     WHERE a.msg_id = b.msg_id
                       AND b.message_type = 'R'
                       AND (a.message_status = 'Q' OR a.message_status = 'S')
                       AND policy_id = i.policy_id)
            LOOP
                v_sms.with_msg := 'Y';
            END LOOP;

            FOR x IN(SELECT DISTINCT policy_id
                      FROM GIEX_SMS_DTL b,
                           GISM_MESSAGES_SENT a
                     WHERE a.msg_id = b.msg_id
                       AND b.message_type = 'N'
                       AND (a.message_status = 'Q' OR a.message_status = 'S')
                       AND policy_id = i.policy_id)
            LOOP
                v_sms.intm_with_msg := 'Y';
            END LOOP;

            v_sms.policy_id := i.policy_id;
            v_sms.line_cd := i.line_cd;
            v_sms.subline_cd := i.subline_cd;
            v_sms.iss_cd := i.iss_cd;
            v_sms.issue_yy := i.issue_yy;
            v_sms.pol_seq_no := i.pol_seq_no;
            v_sms.renew_no := i.renew_no;
            v_sms.tsi_amt := i.tsi_amt;
            v_sms.prem_amt := i.prem_amt;
            v_sms.expiry_date := i.expiry_date;
            v_sms.chk_received := v_chk_received;
            v_sms.chk_sent := v_chk_sent;
            v_sms.assd_no := i.assd_no;
            v_sms.intm_no := i.intm_no;
            v_sms.renew_flag := i.renew_flag;
            v_sms.balance_flag := NVL(i.balance_flag, 'N');
            v_sms.claim_flag := NVL(i.claim_flag, 'N');
            v_sms.user_id := i.user_id;
            v_sms.last_update := TRUNC(i.last_update);
            v_sms.remarks := i.remarks;
            v_sms.pack_policy_id := i.pack_policy_id;
            v_sms.policy_no := UPPER(i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd || '-' || LTRIM(TO_CHAR(i.issue_yy, '09')) || '-'
                                || LTRIM (TO_CHAR (i.pol_seq_no, '0999999')) || '-' ||LTRIM (TO_CHAR (i.renew_no, '09')));
            v_sms.assd_sms := i.assd_sms;
            v_sms.intm_sms := i.intm_sms;
            v_sms.post_flag := NVL(i.post_flag, 'N');
            PIPE ROW(v_sms);
        END LOOP;
    END;

    PROCEDURE update_print_tag(
        p_policy_id     giex_expiry.policy_id%TYPE,
        p_is_pack       VARCHAR2,
        p_user_id       giex_expiry.extract_user%TYPE
    )
    IS
    BEGIN
        UPDATE giex_expiry
           SET print_tag = 'Y',
               print_date = SYSDATE
         WHERE DECODE(p_is_pack, 'N', policy_id, pack_policy_id) = p_policy_id
           AND extract_user = p_user_id;

    END;

END giex_expiry_pkg;
/


