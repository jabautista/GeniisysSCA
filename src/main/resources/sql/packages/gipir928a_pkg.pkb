CREATE OR REPLACE PACKAGE BODY CPI.GIPIR928A_PKG
AS

   FUNCTION get_data (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type, 
                      P_ISS_PARAM NUMBER,
                      P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
                      P_SCOPE NUMBER, 
                      P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
                      p_user_id     gipi_uwreports_dist_peril_ext.user_id%TYPE) -- marco - 02.05.2013 - added parameter
      RETURN gipir928a_tab PIPELINED
   IS
        v_data get_data_type;
        v_exists    boolean := FALSE;
   BEGIN
   
  --Q_2
   FOR rec IN (SELECT  b.iss_cd iss_cd,
                       DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) iss_cd_header,
                       b.line_cd line_cd,
                       INITCAP(e.line_name) line_name,
                       b.subline_cd subline_cd,
                       INITCAP(f.subline_name) subline_name,
                       b.policy_no policY_no,
                       DECODE(C.PERIL_TYPE,'B','*'||C.PERIL_SNAME,' '||C.PERIL_SNAME)peril_sname,
                       SUM(DECODE(c.peril_type,'B',NVL(b.nr_dist_tsi,0),'0')) f_nr_dist_tsi,
                       SUM(DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),'0')) f_tr_dist_tsi,
                       SUM(DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),'0')) f_fa_dist_tsi,
                       SUM(NVL(b.nr_dist_tsi,0)) nr_peril_tsi,
                       SUM(NVL(b.nr_dist_prem,0)) nr_peril_prem,
                       SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi,
                       SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem,
                       SUM(NVL(b.fa_dist_tsi,0)) fa_peril_tsi,
                       SUM(NVL(b.fa_dist_prem,0)) fa_peril_prem
               FROM gipi_uwreports_dist_peril_ext b,  
                     giis_peril c,
                     giis_subline f,
                     giis_dist_share d,
                     giis_issource g,
                     giis_line e
                WHERE 1 = 1
                AND b.line_cd = c.line_cd
                AND b.peril_cd = c.peril_cd
                AND b.line_cd = f.line_cd
                AND b.subline_cd = f.subline_cd
                AND DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd))
                AND b.line_cd = d.line_cd
                AND b.share_cd = d.share_cd
                AND b.line_cd = e.line_cd 
                AND DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) = g.iss_cd
                --AND b.iss_cd=nvl(upper(P_ISS_CD),b.iss_cd)
                AND b.line_cd=nvl(upper(P_LINE_CD),b.line_cd)
                AND b.user_id = p_user_id
                AND ((P_SCOPE=3 AND b.endt_seq_no=b.endt_seq_no)
                OR  (P_SCOPE=1 AND b.endt_seq_no=0)
                OR  (P_SCOPE=2 AND b.endt_seq_no>0))
                AND b.subline_cd = NVL(P_SUBLINE_CD, b.subline_cd)
                -- commented out jhing 03.21.2016 security control is already handled by extraction. removed it in printing to reduce
                -- impact on performance 
				/* added security rights control by robert 01.02.14*/
				--AND check_user_per_iss_cd2 (b.line_cd,DECODE (p_iss_param,1, b.cred_branch,b.iss_cd),'GIPIS901A', p_user_id) =1
                --AND check_user_per_line2 (b.line_cd,DECODE (p_iss_param,1, b.cred_branch,b.iss_cd),'GIPIS901A', p_user_id) = 1
				/* robert 01.02.14 end of added code */
                GROUP BY  b.iss_cd, DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd),b.line_cd,e.line_name,b.subline_cd,f.subline_name, b.policy_no,c.peril_sname,
                          c.peril_type,C.PERIL_SNAME   
                ORDER BY iss_cd, iss_cd_header, line_name, line_cd, subline_cd, subline_name, policY_no, peril_sname)
   LOOP
   v_data.iss_cd := rec.iss_cd;
   v_data.iss_cd_header := rec.iss_cd_header;
   v_data.line_cd := rec.line_cd;
   v_data.line_name := rec.line_name;
   v_data.subline_cd := rec.subline_cd;
   v_data.subline_name := rec.subline_name;
   v_data.policy_no := rec.policy_no;
   v_data.peril_sname := rec.peril_sname;
   v_data.f_nr_dist_tsi := rec.f_nr_dist_tsi;
   v_data.f_tr_dist_tsi := rec.f_tr_dist_tsi;
   v_data.f_fa_dist_tsi := rec.f_fa_dist_tsi;
   v_data.nr_peril_tsi := rec.nr_peril_tsi;
   v_data.nr_peril_prem := rec.nr_peril_prem;
   v_data.tr_peril_tsi := rec.tr_peril_tsi;
   --v_data.tr_peril_prem := rec.tr_peril_tsi; -- jhing commented out incorrect value   REPUBLICFULLWEB 21882 
   v_data.tr_peril_prem := rec.tr_peril_prem;  -- jhing 03.21.2016 REPUBLICFULLWEB 21882 
   v_data.fa_peril_tsi := rec.fa_peril_tsi;
   v_data.fa_peril_prem := rec.fa_peril_prem;
   
   --CF_iss_name
      BEGIN
		SELECT iss_name
	    INTO v_data.iss_name
	    FROM giis_issource
	   WHERE iss_cd = v_data.iss_cd_header;
	        EXCEPTION
		        WHEN no_data_found THEN
            v_data.iss_name := NULL;
      END;
   --CF_iss_header
       BEGIN
          IF P_ISS_PARAM = 1 THEN
             v_data.iss_header := 'Crediting Branch :';
          ELSIF P_ISS_PARAM = 2 THEN
             v_data.iss_header := 'Issue Source     :';
          ELSE 
             v_data.iss_header := NULL;
          END IF;
       END;
   --CF_based_on
   v_data.based_on := GIPIR928A_PKG.cf_based_on(p_user_id);
   --CF_toggle
       BEGIN 
              IF P_SCOPE = 1 THEN
                v_data.policy_label := 'Policies Only';
              ELSIF P_SCOPE = 2 THEN
                v_data.policy_label := 'Endorsements Only';
              ELSIF P_SCOPE = 3 THEN
                v_data.policy_label := 'Policies and Endorsements';
              END IF;  	
       END;
   v_data.company_name := giisp.v('COMPANY_NAME');
   v_data.company_address := giisp.v('COMPANY_ADDRESS');
   --cf_report_nm
   begin
   FOR k IN (SELECT report_title
             FROM giis_reports
             WHERE report_id = 'GIPIR928A')
   LOOP
       v_data.reportnm := k.report_title;
       v_exists := TRUE;
       EXIT;
   END LOOP;
   IF v_exists THEN
      v_data.reportnm := v_data.reportnm;
   ELSE
      v_data.reportnm := 'No report found in GIIS_REPORTS';
   END IF;
   END;
   --CF_from_date
   BEGIN
   SELECT from_date1
    INTO v_data.f_from
    FROM gipi_uwreports_dist_peril_ext
   WHERE user_id = p_user_id
     AND ROWNUM = 1;
   END;
   --CF_to_date
   BEGIN
   SELECT to_date1
    INTO v_data.to_date1
    FROM gipi_uwreports_dist_peril_ext
   WHERE user_id = p_user_id
     AND ROWNUM = 1;
   END;

   BEGIN
   v_data.fromtodate := 'From ' || TO_CHAR(v_data.f_from, 'fmMonth dd, RRRR') || ' to ' || TO_CHAR(v_data.to_date1, 'fmMonth dd, RRRR');
   END;

   PIPE ROW(v_data); 
   END LOOP;


   RETURN;
   END;
   
   /* Q_1 subline_recap */
   FUNCTION get_subrecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%TYPE, 
                          P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                          P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                          P_SCOPE  NUMBER,
                          P_ISS_PARAM NUMBER,
                          P_ISS_CD1 gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                          P_LINE_CD1 gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                          P_SUBLINE_CD1 gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                          p_user_id     gipi_uwreports_dist_peril_ext.user_id%TYPE) -- marco - 02.05.2013 - added parameter
      RETURN gipir928a_subline_recap_tab PIPELINED
   IS
      v_subdata get_subrecap_type;
  BEGIN
   FOR rec IN (SELECT   b.iss_cd ISS_CD1,
                        b.line_cd LINE_CD1,
                        b.subline_cd SUBLINE_CD2,
                        DECODE(C.PERIL_TYPE,'B','*'||C.PERIL_SNAME,' '||C.PERIL_SNAME)peril_sname4,
                        SUM(DECODE(c.peril_type,'B',NVL(b.nr_dist_tsi,0),'0')) f_nr_dist_tsi3,
                        SUM(DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),'0')) f_tr_dist_tsi3,
                        SUM(DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),'0')) f_fa_dist_tsi3,
                        SUM(NVL(b.nr_dist_tsi,0)) nr_peril_tsi3,
                        SUM(NVL(b.nr_dist_prem,0)) nr_peril_prem3,
                        SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi3,
                        SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem3,
                        SUM(NVL(b.fa_dist_tsi,0)) fa_peril_tsi3,
                        SUM(NVL(b.fa_dist_prem,0)) fa_peril_prem3
                FROM gipi_uwreports_dist_peril_ext b,  
                     giis_peril c,
                     giis_dist_share d
                WHERE 1 = 1
                    AND P_ISS_CD1 = b.iss_cd
                    AND b.line_cd = c.line_cd
                    AND P_LINE_CD1 = b.line_cd
                    AND P_SUBLINE_CD1 = b.subline_cd
                    AND b.peril_cd = c.peril_cd
                    AND b.line_cd = d.line_cd
                    AND b.share_cd = d.share_cd
                    --and b.iss_cd=nvl(upper(:p_iss_cd),b.iss_cd)
                    AND b.line_cd=NVL(UPPER(P_LINE_CD),b.line_cd)
                    AND b.user_id = p_user_id
                    AND DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd))
                    AND ((P_SCOPE=3 AND b.endt_seq_no=b.endt_seq_no)
                    OR  (P_SCOPE=1 AND b.endt_seq_no=0)
                    OR  (P_SCOPE=2 AND b.endt_seq_no>0))
                    AND b.subline_cd = NVL(P_SUBLINE_CD, b.subline_cd)
                    GROUP BY  b.iss_cd,b.line_cd,b.subline_cd,c.peril_sname,
                              c.peril_type)
    LOOP
    v_subdata.iss_cd1 := rec.iss_cd1;
    v_subdata.line_cd1 := rec.line_cd1;
    v_subdata.subline_cd2 := rec.subline_cd2;
    v_subdata.peril_sname4 := rec.peril_sname4;
    v_subdata.f_nr_dist_tsi3 := rec.f_nr_dist_tsi3;
    v_subdata.f_tr_dist_tsi3 := rec.f_tr_dist_tsi3;
    v_subdata.f_fa_dist_tsi3 := rec.f_fa_dist_tsi3;
    v_subdata.nr_peril_tsi3 := rec.nr_peril_tsi3;
    v_subdata.nr_peril_prem3 := rec.nr_peril_prem3;
    v_subdata.tr_peril_tsi3 := rec.tr_peril_tsi3;
    v_subdata.tr_peril_prem3 := rec.tr_peril_prem3;
    v_subdata.fa_peril_tsi3 := rec.fa_peril_tsi3;
    v_subdata.fa_peril_prem3 := rec.fa_peril_prem3;
    PIPE ROW(v_subdata);
    END LOOP;
    RETURN;
  END;
FUNCTION get_linerecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%TYPE, 
                        P_ISS_PARAM NUMBER,
                        P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                        P_SCOPE NUMBER, 
                        P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                        P_ISS_CD1 gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                        P_LINE_CD1 gipi_uwreports_dist_peril_ext.line_cd%TYPE,
                        p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE)
      RETURN gipir928a_line_recap_tab PIPELINED
   IS
        v_linedata get_linerecap_type;
   BEGIN
   FOR rec IN (SELECT    b.iss_cd iss_cd3,
                         b.line_cd line_cd2, 
                         DECODE(C.PERIL_TYPE,'B','*'||C.PERIL_SNAME,' '||C.PERIL_SNAME)peril_sname5,
                         SUM(DECODE(c.peril_type,'B',NVL(b.nr_dist_tsi,0),'0')) f_nr_dist_tsi4,
                         SUM(DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),'0')) f_tr_dist_tsi4,
                         SUM(DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),'0')) f_fa_dist_tsi4,
                         SUM(NVL(b.nr_dist_tsi,0)) nr_peril_tsi4,
                         SUM(NVL(b.nr_dist_prem,0)) nr_peril_prem4,
                         SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi4,
                         SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem4,
                         SUM(NVL(b.fa_dist_tsi,0)) fa_peril_tsi4,
                         SUM(NVL(b.fa_dist_prem,0)) fa_peril_prem4
                  FROM   gipi_uwreports_dist_peril_ext b,  
                         giis_peril c,
                         giis_dist_share d
                  WHERE 1 = 1
                        AND b.line_cd = c.line_cd
                        AND P_LINE_CD1 = b.line_cd
                        AND b.peril_cd = c.peril_cd
                        AND b.line_cd = d.line_cd
                        AND b.share_cd = d.share_cd
                        AND DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd))
                        --and b.iss_cd=nvl(upper(:p_iss_cd),b.iss_cd)
                        AND b.line_cd=nvl(upper(P_LINE_CD),b.line_cd)
                        AND b.user_id = p_user_id -- marco - 02.05.2013 - changed from user
                        AND ((P_SCOPE=3 AND b.endt_seq_no=b.endt_seq_no)
                        OR  (P_SCOPE=1 AND b.endt_seq_no=0)
                        OR  (P_SCOPE=2 AND b.endt_seq_no>0))
                        AND b.subline_cd = NVL(P_SUBLINE_CD, b.subline_cd)
                        AND P_ISS_CD1 = b.iss_cd
                  GROUP BY  b.iss_cd,b.line_cd,c.peril_sname,
                              c.peril_type  )
   LOOP
        v_linedata.iss_cd3 := rec.iss_cd3; 
        v_linedata.line_cd2 := rec.line_cd2; 
        v_linedata.peril_sname5 := rec.peril_sname5;
        v_linedata.f_nr_dist_tsi4 := rec.f_nr_dist_tsi4;
        v_linedata.f_tr_dist_tsi4 := rec.f_tr_dist_tsi4;
        v_linedata.f_fa_dist_tsi4 := rec.f_fa_dist_tsi4;
        v_linedata.nr_peril_tsi4 := rec.nr_peril_tsi4; 
        v_linedata.nr_peril_prem4 := rec.nr_peril_prem4;
        v_linedata.tr_peril_tsi4 := rec.tr_peril_tsi4; 
        v_linedata.tr_peril_prem4 := rec.tr_peril_prem4; 
        v_linedata.fa_peril_tsi4 := rec.fa_peril_tsi4; 
        v_linedata.fa_peril_prem4 := rec.fa_peril_prem4;
        PIPE ROW (v_linedata); 
   END LOOP;
   END;
FUNCTION get_branchrecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%TYPE, 
                        P_ISS_PARAM NUMBER,
                        P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                        P_SCOPE NUMBER, 
                        P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                        P_ISS_CD1 gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                        p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
                        --,P_ISS_CD_HEADER1 VARCHAR2
                        )
      RETURN gipir928a_branch_recap_tab PIPELINED
   IS
        v_branchdata get_branchrecap_type;
   BEGIN
        FOR rec IN (SELECT  b.iss_cd iss_cd4,
                            DECODE(C.PERIL_TYPE,'B','*'||C.PERIL_SNAME,' '||C.PERIL_SNAME)peril_sname1,
                            SUM(DECODE(c.peril_type,'B',NVL(b.nr_dist_tsi,0),'0')) f_nr_dist_tsi5,
                            SUM(DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),'0')) f_tr_dist_tsi5,
                            SUM(DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),'0')) f_fa_dist_tsi5,
                            SUM(NVL(b.nr_dist_tsi,0)) nr_peril_tsi5,
                            SUM(NVL(b.nr_dist_prem,0)) nr_peril_prem5,
                            SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi5,
                            SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem5,
                            SUM(NVL(b.fa_dist_tsi,0)) fa_peril_tsi5,
                            SUM(NVL(b.fa_dist_prem,0)) fa_peril_prem5
                       FROM gipi_uwreports_dist_peril_ext b,  
                            giis_peril c,
                            giis_dist_share d
                       WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND P_ISS_CD1 = b.iss_cd
                       --AND P_ISS_CD_HEADER1 = DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd)
                       AND b.peril_cd = c.peril_cd
                       AND b.line_cd = d.line_cd
                       AND b.share_cd = d.share_cd
                       AND DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd))
                       --and b.iss_cd=nvl(upper(:p_iss_cd),b.iss_cd)
                       AND b.line_cd=nvl(upper(P_LINE_CD),b.line_cd)
                       AND b.user_id = p_user_id
                       AND ((P_SCOPE=3 AND b.endt_seq_no=b.endt_seq_no)
                       OR  (P_SCOPE=1 AND b.endt_seq_no=0)
                       OR  (P_SCOPE=2 AND b.endt_seq_no>0))
                       AND b.subline_cd = NVL(P_SUBLINE_CD, b.subline_cd)
                       GROUP BY  b.iss_cd, c.peril_sname,
                                  c.peril_type  )
         LOOP
         v_branchdata.iss_cd4 := rec.iss_cd4;
         v_branchdata.peril_sname1 := rec.peril_sname1;
         v_branchdata.f_nr_dist_tsi5 := rec.f_nr_dist_tsi5;
         v_branchdata.f_tr_dist_tsi5 := rec.f_tr_dist_tsi5;
         v_branchdata.f_fa_dist_tsi5 := rec.f_fa_dist_tsi5;
         v_branchdata.nr_peril_tsi5 := rec.nr_peril_tsi5;
         v_branchdata.nr_peril_prem5 := rec.nr_peril_prem5;
         v_branchdata.tr_peril_tsi5 := rec.tr_peril_tsi5;
         v_branchdata.tr_peril_prem5 := rec.tr_peril_prem5;
         v_branchdata.fa_peril_tsi5 := rec.fa_peril_tsi5;
         v_branchdata.fa_peril_prem5 := rec.fa_peril_prem5;
         PIPE ROW (v_branchdata);
         END LOOP;
   END;
FUNCTION get_grandrecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type, 
                      P_ISS_PARAM NUMBER,
                      P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
                      P_SCOPE NUMBER, 
                      P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
                      p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE) -- marco - 02.05.2013 - added parameter
      RETURN gipir928a_grand_recap_tab PIPELINED
   IS
      v_granddata get_grandrecap_type;
   BEGIN
        FOR rec IN (SELECT  DECODE(C.PERIL_TYPE,'B','*'||C.PERIL_SNAME,' '||C.PERIL_SNAME)peril_sname2,
                            SUM(DECODE(c.peril_type,'B',NVL(b.nr_dist_tsi,0),'0')) f_nr_dist_tsi1,
                            SUM(DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),'0')) f_tr_dist_tsi1,
                            SUM(DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),'0')) f_fa_dist_tsi1,
                            SUM(NVL(b.nr_dist_tsi,0)) nr_peril_tsi1,
                            SUM(NVL(b.nr_dist_prem,0)) nr_peril_prem1,
                            SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi1,
                            SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem1,
                            SUM(NVL(b.fa_dist_tsi,0)) fa_peril_tsi1,
                            SUM(NVL(b.fa_dist_prem,0)) fa_peril_prem1
                       FROM gipi_uwreports_dist_peril_ext b,  
                                 giis_peril c,
                                 giis_dist_share d
                      WHERE 1 = 1
                            AND b.line_cd = c.line_cd
                            AND b.peril_cd = c.peril_cd
                            AND b.line_cd = d.line_cd
                            AND b.share_cd = d.share_cd
                            AND DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,b.cred_branch,b.iss_cd))
                            --and b.iss_cd=nvl(upper(:p_iss_cd),b.iss_cd)
                            AND b.line_cd=NVL(UPPER(P_LINE_CD),b.line_cd)
                            AND b.user_id = p_user_id
                            AND ((P_SCOPE=3 AND b.endt_seq_no=b.endt_seq_no)
                            OR  (P_SCOPE=1 AND b.endt_seq_no=0)
                            OR  (P_SCOPE=2 AND b.endt_seq_no>0))
                            AND b.subline_cd = NVL(P_SUBLINE_CD, b.subline_cd)
                  GROUP BY  c.peril_sname,
                                      c.peril_type)
        LOOP
        v_granddata.peril_sname2 := rec.peril_sname2;
        v_granddata.f_nr_dist_tsi1 := rec.f_nr_dist_tsi1;
        v_granddata.f_tr_dist_tsi1 := rec.f_tr_dist_tsi1;
        v_granddata.f_fa_dist_tsi1 := rec.f_fa_dist_tsi1;
        v_granddata.nr_peril_tsi1 := rec.nr_peril_tsi1;
        v_granddata.nr_peril_prem1 := rec.nr_peril_prem1;
        v_granddata.tr_peril_tsi1 := rec.tr_peril_tsi1;
        v_granddata.tr_peril_prem1 := rec.tr_peril_prem1;
        v_granddata.fa_peril_tsi1 := rec.fa_peril_tsi1;
        v_granddata.fa_peril_prem1 := rec.fa_peril_prem1;
        PIPE ROW (v_granddata);
        END LOOP;
   END;
   
    FUNCTION cf_based_on(
        p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
      RETURN CHAR IS
        v_param_date  number(1);
        v_based_on varchar2(100);
    BEGIN
        SELECT param_date
          INTO v_param_date
          FROM gipi_uwreports_dist_peril_ext
         WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from USER
           AND ROWNUM = 1;
           
        IF v_param_date = 1 THEN
            v_based_on := 'Based on Issue Date';
        ELSIF v_param_date = 2 THEN
            v_based_on := 'Based on Inception Date';
        ELSIF v_param_date = 3 THEN
            v_based_on := 'Based on Booking month - year';
        ELSIF v_param_date = 4 THEN
            v_based_on := 'Based on Acctg Entry Date';
        END IF;
        
        RETURN(v_based_on);
    END;
    
END gipir928a_pkg;
/


