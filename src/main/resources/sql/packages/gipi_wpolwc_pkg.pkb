CREATE OR REPLACE PACKAGE BODY CPI.gipi_wpolwc_pkg
AS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS024 - Policy Warranties and Clauses)
**  Description  : Retrieves the policy warranty and clause records of the given par_id.
*/
   FUNCTION get_gipi_wpolwc (
      p_line_cd   gipi_wpolwc.line_cd%TYPE,              --to limit the query
      p_par_id    gipi_wpolwc.par_id%TYPE
   )                                                     --to limit the query
      RETURN gipi_wpolwc_tab PIPELINED
   IS
      v_wpolwc   gipi_wpolwc_type;
   BEGIN
      FOR i IN (SELECT   wc_cd,
                         DECODE (wc_cd, 'C', 'Clause', 'Warranty') wc_sw,
                         wc_title, wc_title2, wc_text01, wc_text02,
                         wc_text03, wc_text04, wc_text05, wc_text06,
                         wc_text07, wc_text08, wc_text09, wc_text10,
                         wc_text11, wc_text12, wc_text13, wc_text14,
                         wc_text15, wc_text16, wc_text17, change_tag,
                         wc_remarks, print_sw, print_seq_no, rec_flag,
                         line_cd, par_id
                    FROM gipi_wpolwc
                   WHERE par_id = p_par_id
                     AND line_cd = p_line_cd
                     AND NVL (change_tag, 'N') = 'Y'
                UNION
                SELECT   a.wc_cd,
                         DECODE (b.wc_sw, 'C', 'Clause', 'Warranty') wc_sw,
                         
                         --replace by steven 5.2.2012: a.wc_cd to b.wc_sw
                         a.wc_title, a.wc_title2, b.wc_text01, b.wc_text02,
                         b.wc_text03, b.wc_text04, b.wc_text05, b.wc_text06,
                         b.wc_text07, b.wc_text08, b.wc_text09, b.wc_text10,
                         b.wc_text11, b.wc_text12, b.wc_text13, b.wc_text14,
                         b.wc_text15, b.wc_text16, b.wc_text17, a.change_tag,
                         a.wc_remarks, a.print_sw, a.print_seq_no, a.rec_flag,
                         a.line_cd, a.par_id
                    FROM gipi_wpolwc a, giis_warrcla b
                   WHERE a.par_id = p_par_id
                     AND a.line_cd = p_line_cd
                     AND NVL (a.change_tag, 'N') = 'N'
                     AND a.wc_cd = b.main_wc_cd
                     AND a.line_cd = b.line_cd
                ORDER BY print_seq_no)
      LOOP
         v_wpolwc.wc_cd := i.wc_cd;
         v_wpolwc.wc_sw := i.wc_sw;
         v_wpolwc.wc_title := i.wc_title;
         v_wpolwc.wc_title2 := i.wc_title2;
     /*    v_wpolwc.wc_text_a      := (i.wc_text01 || i.wc_text02 || i.wc_text03 || i.wc_text04
                                || i.wc_text05 || i.wc_text06 || i.wc_text07 || i.wc_text08
                                || i.wc_text09);
         v_wpolwc.wc_text_b      := (i.wc_text10 || i.wc_text11 || i.wc_text12
                                || i.wc_text13 || i.wc_text14 || i.wc_text15 || i.wc_text16
                                || i.wc_text17);*/
--         v_wpolwc.wc_text1     := (i.wc_text01 || i.wc_text02);
--         v_wpolwc.wc_text2     := (i.wc_text03 || i.wc_text04);
--         v_wpolwc.wc_text3     := (i.wc_text05 || i.wc_text06);
--         v_wpolwc.wc_text4     := (i.wc_text07 || i.wc_text08);
--         v_wpolwc.wc_text5     := (i.wc_text09 || i.wc_text10);
--         v_wpolwc.wc_text6     := (i.wc_text11 || i.wc_text12);
--         v_wpolwc.wc_text7     := (i.wc_text13 || i.wc_text14);
--         v_wpolwc.wc_text8     := (i.wc_text05 || i.wc_text16);
--         v_wpolwc.wc_text9     := i.wc_text17;
         v_wpolwc.change_tag := i.change_tag;
         --added by steven 1.19.2013
         IF NVL (i.change_tag, 'N') = 'Y'
         THEN
            v_wpolwc.wc_text1 := i.wc_text01;
            v_wpolwc.wc_text2 := i.wc_text02;
            v_wpolwc.wc_text3 := i.wc_text03;
            v_wpolwc.wc_text4 := i.wc_text04;
            v_wpolwc.wc_text5 := i.wc_text05;
            v_wpolwc.wc_text6 := i.wc_text06;
            v_wpolwc.wc_text7 := i.wc_text07;
            v_wpolwc.wc_text8 := i.wc_text08;
            v_wpolwc.wc_text9 := i.wc_text09;
            v_wpolwc.wc_text10 := i.wc_text10;
            v_wpolwc.wc_text11 := i.wc_text11;
            v_wpolwc.wc_text12 := i.wc_text12;
            v_wpolwc.wc_text13 := i.wc_text13;
            v_wpolwc.wc_text14 := i.wc_text14;
            v_wpolwc.wc_text15 := i.wc_text05;
            v_wpolwc.wc_text16 := i.wc_text16;
            v_wpolwc.wc_text17 := i.wc_text17;
         ELSE
            FOR warcla IN (SELECT wc_text01, wc_text02, wc_text03, wc_text04,
                                  wc_text05, wc_text06, wc_text07, wc_text08,
                                  wc_text09, wc_text10, wc_text11, wc_text12,
                                  wc_text13, wc_text14, wc_text15, wc_text16,
                                  wc_text17
                             FROM giis_warrcla
                            WHERE line_cd = i.line_cd
                                  AND main_wc_cd = i.wc_cd)
            LOOP
               v_wpolwc.wc_text1 := warcla.wc_text01;
               v_wpolwc.wc_text2 := warcla.wc_text02;
               v_wpolwc.wc_text3 := warcla.wc_text03;
               v_wpolwc.wc_text4 := warcla.wc_text04;
               v_wpolwc.wc_text5 := warcla.wc_text05;
               v_wpolwc.wc_text6 := warcla.wc_text06;
               v_wpolwc.wc_text7 := warcla.wc_text07;
               v_wpolwc.wc_text8 := warcla.wc_text08;
               v_wpolwc.wc_text9 := warcla.wc_text09;
               v_wpolwc.wc_text10 := warcla.wc_text10;
               v_wpolwc.wc_text11 := warcla.wc_text11;
               v_wpolwc.wc_text12 := warcla.wc_text12;
               v_wpolwc.wc_text13 := warcla.wc_text13;
               v_wpolwc.wc_text14 := warcla.wc_text14;
               v_wpolwc.wc_text15 := warcla.wc_text05;
               v_wpolwc.wc_text16 := warcla.wc_text16;
               v_wpolwc.wc_text17 := warcla.wc_text17;
            END LOOP;
         END IF;

         v_wpolwc.wc_remarks := i.wc_remarks;
         v_wpolwc.print_sw := i.print_sw;
         v_wpolwc.print_seq_no := i.print_seq_no;
         v_wpolwc.rec_flag := i.rec_flag;
         v_wpolwc.line_cd := i.line_cd;
         v_wpolwc.par_id := i.par_id;
         PIPE ROW (v_wpolwc);
      END LOOP;

      RETURN;
   END get_gipi_wpolwc;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS024 - Policy Warranties and Clauses)
**  Description  : This inserts new policy warranty and clause record or updates the record if existing.
*/
   PROCEDURE set_gipi_wpolwc (p_wpolwc gipi_wpolwc%ROWTYPE)
   --warranty and clause to be inserted.
   IS
      v_print_seq_no_temp   gipi_wpolwc.print_seq_no%TYPE
                                                     := p_wpolwc.print_seq_no;
      --added by steven 01.14.2013 base on SR 0011912
      v_exist               BOOLEAN                         := FALSE;
      v_wc_text01           VARCHAR2(2002);
      v_wc_text02           VARCHAR2(2002);
      v_wc_text03           VARCHAR2(2002);
      v_wc_text04           VARCHAR2(2002);
      v_wc_text05           VARCHAR2(2002);
      v_wc_text06           VARCHAR2(2002);
      v_wc_text07           VARCHAR2(2002);
      v_wc_text08           VARCHAR2(2002);
      v_wc_text09           VARCHAR2(2002);
      v_wc_text10           VARCHAR2(2002);
      v_wc_text11           VARCHAR2(2002);
      v_wc_text12           VARCHAR2(2002);
      v_wc_text13           VARCHAR2(2002);
      v_wc_text14           VARCHAR2(2002);
      v_wc_text15           VARCHAR2(2002);
      v_wc_text16           VARCHAR2(2002);
      v_wc_text17           VARCHAR2(2002);
   BEGIN
      /*FOR polwc IN (SELECT print_seq_no
                      FROM gipi_wpolwc
                     WHERE par_id = p_wpolwc.par_id)
      LOOP
         IF v_print_seq_no_temp = polwc.print_seq_no
         THEN
            v_exist := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF v_exist
      THEN
         SELECT NVL (MAX (print_seq_no), 0) + 1
           INTO v_print_seq_no_temp
           FROM gipi_wpolwc
          WHERE par_id = p_wpolwc.par_id;
      END IF;*/ --commented out by steven 09.19.2013;it automatically updates the print_seq_no if it is existing.

      IF p_wpolwc.change_tag = 'N'
      THEN
         v_wc_text01 := NULL;
         v_wc_text02 := NULL;
         v_wc_text03 := NULL;
         v_wc_text04 := NULL;
         v_wc_text05 := NULL;
         v_wc_text06 := NULL;
         v_wc_text07 := NULL;
         v_wc_text08 := NULL;
         v_wc_text09 := NULL;
         v_wc_text10 := NULL;
         v_wc_text11 := NULL;
         v_wc_text12 := NULL;
         v_wc_text13 := NULL;
         v_wc_text14 := NULL;
         v_wc_text15 := NULL;
         v_wc_text16 := NULL;
         v_wc_text17 := NULL;
      ELSE
         v_wc_text01 := p_wpolwc.wc_text01;
         v_wc_text02 := p_wpolwc.wc_text02;
         v_wc_text03 := p_wpolwc.wc_text03;
         v_wc_text04 := p_wpolwc.wc_text04;
         v_wc_text05 := p_wpolwc.wc_text05;
         v_wc_text06 := p_wpolwc.wc_text06;
         v_wc_text07 := p_wpolwc.wc_text07;
         v_wc_text08 := p_wpolwc.wc_text08;
         v_wc_text09 := p_wpolwc.wc_text09;
         v_wc_text10 := p_wpolwc.wc_text10;
         v_wc_text11 := p_wpolwc.wc_text11;
         v_wc_text12 := p_wpolwc.wc_text12;
         v_wc_text13 := p_wpolwc.wc_text13;
         v_wc_text14 := p_wpolwc.wc_text14;
         v_wc_text15 := p_wpolwc.wc_text15;
         v_wc_text16 := p_wpolwc.wc_text16;
         v_wc_text17 := p_wpolwc.wc_text17;
      END IF;

      MERGE INTO gipi_wpolwc
         USING DUAL
         ON (    line_cd = p_wpolwc.line_cd
             AND par_id = p_wpolwc.par_id
             AND wc_cd = p_wpolwc.wc_cd)
         WHEN NOT MATCHED THEN
            INSERT (wc_cd, wc_title, wc_title2, wc_text01, wc_text02,
                    wc_text03, wc_text04, wc_text05, wc_text06, wc_text07,
                    wc_text08, wc_text09, wc_text10, wc_text11, wc_text12,
                    wc_text13, wc_text14, wc_text15, wc_text16, wc_text17,
                    change_tag, wc_remarks, print_sw, print_seq_no, rec_flag,
                    line_cd, par_id, create_user                --, swc_seq_no
                                                )
            VALUES (p_wpolwc.wc_cd, p_wpolwc.wc_title, p_wpolwc.wc_title2,
                    v_wc_text01, v_wc_text02,
                    v_wc_text03, v_wc_text04,
                    v_wc_text05, v_wc_text06,
                    v_wc_text07, v_wc_text08,
                    v_wc_text09, v_wc_text10,
                    v_wc_text11, v_wc_text12,
                    v_wc_text13, v_wc_text14,
                    v_wc_text15, v_wc_text16,
                    v_wc_text17, p_wpolwc.change_tag,
                    p_wpolwc.wc_remarks, p_wpolwc.print_sw,
                    
/*p_wpolwc.print_seq_no*/
                    v_print_seq_no_temp, p_wpolwc.rec_flag, p_wpolwc.line_cd,
                    p_wpolwc.par_id, p_wpolwc.user_id  --, p_wpolwc.swc_seq_no
                                                     )
         WHEN MATCHED THEN
            UPDATE
               SET wc_title = p_wpolwc.wc_title,
                   wc_title2 = p_wpolwc.wc_title2,
                   wc_text01 = v_wc_text01,
                   wc_text02 = v_wc_text02,
                   wc_text03 = v_wc_text03,
                   wc_text04 = v_wc_text04,
                   wc_text05 = v_wc_text05,
                   wc_text06 = v_wc_text06,
                   wc_text07 = v_wc_text07,
                   wc_text08 = v_wc_text08,
                   wc_text09 = v_wc_text09,
                   wc_text10 = v_wc_text10,
                   wc_text11 = v_wc_text11,
                   wc_text12 = v_wc_text12,
                   wc_text13 = v_wc_text13,
                   wc_text14 = v_wc_text14,
                   wc_text15 = v_wc_text15,
                   wc_text16 = v_wc_text16,
                   wc_text17 = v_wc_text17,
                   change_tag = p_wpolwc.change_tag,
                   wc_remarks = p_wpolwc.wc_remarks,
                   print_sw = p_wpolwc.print_sw,
                   print_seq_no = v_print_seq_no_temp,
                   
                   --p_wpolwc.print_seq_no,
                   rec_flag = p_wpolwc.rec_flag, user_id = p_wpolwc.user_id
            ;
   END set_gipi_wpolwc;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS024 - Policy Warranties and Clauses)
**  Description  : Deletes the specific policy warranty and clause record.
*/
   PROCEDURE del_gipi_wpolwc (
      p_line_cd   gipi_wpolwc.line_cd%TYPE,
      --line_cd of the record to be deleted
      p_par_id    gipi_wpolwc.par_id%TYPE,
      --par_id of the record to be deleted
      p_wc_cd     gipi_wpolwc.wc_cd%TYPE
   )                                       --wc_cd of the record to be deleted
   IS
   BEGIN
      DELETE FROM gipi_wpolwc
            WHERE line_cd = p_line_cd AND par_id = p_par_id
                  AND wc_cd = p_wc_cd;
   END del_gipi_wpolwc;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS024 - Policy Warranties and Clauses)
**  Description  : Deletes all policy warranty and clause records of the given par_id.
*/
   PROCEDURE del_all_gipi_wpolwc (
      p_line_cd   gipi_wpolwc.line_cd%TYPE,
      --line_cd of the record/s to be deleted
      p_par_id    gipi_wpolwc.par_id%TYPE
   )                                    --par_id of the record/s to be deleted
   IS
   BEGIN
      DELETE FROM gipi_wpolwc
            WHERE line_cd = p_line_cd AND par_id = p_par_id;
   END del_all_gipi_wpolwc;

/*
**  Created by   :  Bryan joseph G. Abuluyan
**  Date Created :  February 15, 2010
**  Reference By : (GIPI_WOPENPOLICY_PKG.save_wopenpolicy
**  Description  : Counts policies matching input details from GIPI_WOPENPOLICY table
*/
   FUNCTION get_policy_count (
      p_par_id       gipi_wpolwc.par_id%TYPE,
      p_line_cd      gipi_wpolwc.line_cd%TYPE,
      p_wc_cd        gipi_wpolwc.wc_cd%TYPE,
      p_swc_seq_no   gipi_wpolwc.swc_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM gipi_wpolwc
       WHERE par_id = p_par_id
         AND line_cd = p_line_cd
         AND wc_cd = p_wc_cd
         AND swc_seq_no = p_swc_seq_no;

      RETURN v_count;
   END get_policy_count;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  May 16, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril)
**  Description  : Returns true or false whether peril has attached warranties and clauses.
*/
   FUNCTION endt_peril_wc_exists (
      p_par_id     gipi_witmperl.par_id%TYPE,
      p_line_cd    gipi_witmperl.line_cd%TYPE,
      p_peril_cd   gipi_witmperl.peril_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (1) := 'N';
   BEGIN
      FOR a IN (SELECT '1'
                  FROM giis_peril_clauses a
                 WHERE a.line_cd = p_line_cd
                   AND a.peril_cd = p_peril_cd
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM gipi_wpolwc b
                           WHERE par_id = p_par_id
                             AND b.line_cd = a.line_cd
                             AND b.wc_cd = a.main_wc_cd))
      LOOP
         v_result := 'Y';
         EXIT;
      END LOOP;

      RETURN v_result;
   END endt_peril_wc_exists;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril)
**  Description  : Inserts the peril's attached warranties and clauses.
*/
   PROCEDURE include_wc (
      p_par_id     gipi_wpolwc.par_id%TYPE,
      p_line_cd    gipi_wpolwc.line_cd%TYPE,
      p_peril_cd   gipi_witmperl.peril_cd%TYPE
   )
   IS
   BEGIN
      FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
                   FROM giis_peril_clauses a
                  WHERE a.line_cd = p_line_cd
                    AND a.peril_cd = p_peril_cd
                    AND NOT EXISTS (
                           SELECT '1'
                             FROM gipi_wpolwc b
                            WHERE b.par_id = p_par_id
                              AND b.line_cd = a.line_cd
                              AND b.wc_cd = a.main_wc_cd))
      LOOP
         FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                     FROM giis_warrcla
                    WHERE line_cd = a1.line_cd AND main_wc_cd = a1.main_wc_cd)
         LOOP
            INSERT INTO gipi_wpolwc
                        (par_id, line_cd, wc_cd, swc_seq_no, print_seq_no,
                         wc_title, rec_flag, print_sw, change_tag
                        )
                 VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0, 1,
                         b.wc_title, 'A', b.print_sw, 'N'
                        );
         END LOOP;
      END LOOP;
   END include_wc;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.01.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure deletes record based on the given par_id
   */
   PROCEDURE del_gipi_wpolwc (p_par_id IN gipi_wpolwc.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_wpolwc
            WHERE par_id = p_par_id;
   END del_gipi_wpolwc;

   /*
   **  Created by        : Bryan Abuluyan
   **  Date Created     : 11.22.2010
   **  Reference By     : (GIPIS038 - Peril Information)
   **  Description     : Taking list of all WCs for a certain PAR
   */
   FUNCTION get_gipi_wpolwc1 (
      p_par_id    gipi_wpolwc.par_id%TYPE,
      p_line_cd   gipi_wpolwc.line_cd%TYPE
   )
      RETURN gipi_wpolwc_tab PIPELINED
   IS
      v_wpolwc   gipi_wpolwc_type;
   BEGIN
      FOR i IN (SELECT par_id, line_cd, wc_cd, swc_seq_no, print_seq_no,
                       wc_title, rec_flag, print_sw, change_tag
                  FROM gipi_wpolwc b
                 WHERE b.par_id = p_par_id AND b.line_cd = p_line_cd)
      LOOP
         v_wpolwc.par_id := i.par_id;
         v_wpolwc.line_cd := i.line_cd;
         v_wpolwc.wc_cd := i.wc_cd;
         v_wpolwc.swc_seq_no := i.swc_seq_no;
         v_wpolwc.print_seq_no := i.print_seq_no;
         v_wpolwc.wc_title := i.wc_title;
         v_wpolwc.rec_flag := i.rec_flag;
         v_wpolwc.print_sw := i.print_sw;
         v_wpolwc.change_tag := i.change_tag;
         PIPE ROW (v_wpolwc);
      END LOOP;

      RETURN;
   END get_gipi_wpolwc1;

   FUNCTION get_default_wc_details (
      p_line_cd      gipi_wpolwc.line_cd%TYPE,
      p_main_wc_cd   gipi_wpolwc.wc_cd%TYPE
   )
      RETURN gipi_wpolwc_tab PIPELINED
   IS
      v_wpolwc   gipi_wpolwc_type;
   BEGIN
      FOR i IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                  FROM giis_warrcla
                 WHERE line_cd = p_line_cd AND main_wc_cd = p_main_wc_cd)
      LOOP
         v_wpolwc.line_cd := i.line_cd;
         v_wpolwc.wc_cd := i.main_wc_cd;
         v_wpolwc.print_sw := i.print_sw;
         v_wpolwc.wc_title := i.wc_title;
         PIPE ROW (v_wpolwc);
      END LOOP;

      RETURN;
   END get_default_wc_details;

   /*
   **  Created by        : Steven Ramirez
   **  Date Created     : 06.01.2012
   **  Reference By     : (GIPIS035 - Warranties and Clauses Endorsement)
   **  Description     : Checked endorsement and policy if the existing warranties are the same.
   */
   FUNCTION exist_wpolwc_polwc (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_wc_cd        gipi_wpolwc.wc_cd%TYPE,
      p_swc_seq_no   gipi_wpolwc.swc_seq_no%TYPE
   )
      RETURN VARCHAR
   IS
      v_policy_id     gipi_polbasic.policy_id%TYPE;
      v_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE;
      v_rec_flag      VARCHAR2 (1);
      v_policy_id2    NUMBER (8);
      v_exist         VARCHAR2 (1);
   BEGIN
      v_exist := 'N';

      FOR a1 IN (SELECT   a.policy_id
                     FROM gipi_polbasic a
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND pol_flag IN ('1', '2', '3')
                 ORDER BY eff_date DESC)
      LOOP
         FOR a2 IN (SELECT rec_flag
                      FROM gipi_polwc
                     WHERE policy_id = a1.policy_id
                       AND wc_cd = p_wc_cd
                       AND swc_seq_no = NVL (p_swc_seq_no, 0))
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_exist = 'Y'
         THEN
            EXIT;
         END IF;
      END LOOP;

      RETURN v_exist;
   END exist_wpolwc_polwc;

   PROCEDURE set_default_wc (
      p_par_id     gipi_wpolwc.par_id%TYPE,
      p_line_cd    gipi_wpolwc.line_cd%TYPE,
      p_peril_cd   giis_peril_clauses.peril_cd%TYPE
   )
   IS
   BEGIN
      FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
                   FROM giis_peril_clauses a
                  WHERE a.line_cd = p_line_cd
                    AND a.peril_cd = p_peril_cd
                    AND NOT EXISTS (
                           SELECT '1'
                             FROM gipi_wpolwc b
                            WHERE b.par_id = p_par_id
                              AND b.line_cd = a.line_cd
                              AND b.wc_cd = a.main_wc_cd))
      LOOP
         FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                     FROM giis_warrcla
                    WHERE line_cd = a1.line_cd AND main_wc_cd = a1.main_wc_cd)
         LOOP
            INSERT INTO gipi_wpolwc
                        (par_id, line_cd, wc_cd, swc_seq_no, print_seq_no,
                         wc_title, rec_flag, print_sw, change_tag
                        )
                 VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0, 1,
                         b.wc_title, 'A', b.print_sw, 'N'
                        );
         END LOOP;
      END LOOP;
   END;
END gipi_wpolwc_pkg;
/


