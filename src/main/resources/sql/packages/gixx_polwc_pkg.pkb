CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Polwc_Pkg AS

   FUNCTION get_pol_doc_warranties 
     RETURN pol_doc_warranties_tab PIPELINED IS
     
     v_warranties pol_doc_warranties_type;
     
   BEGIN
     FOR i IN (  
        SELECT ALL wc.extract_id extract_id14, wc.wc_title wc_wc_title,
                   wc.wc_text01 polwc_wc_text01, wc.wc_text02 polwc_wc_text02,
                   wc.wc_text03 polwc_wc_text03, wc.wc_text04 polwc_wc_text04,
                   wc.wc_text05 polwc_wc_text05, wc.wc_text06 polwc_wc_text06,
                   wc.wc_text07 polwc_wc_text07, wc.wc_text08 polwc_wc_text08,
                   wc.wc_text09 polwc_wc_text09, wc.wc_text10 polwc_wc_text10,
                   wc.wc_text11 polwc_wc_text11, wc.wc_text12 polwc_wc_text12,
                   wc.wc_text13 polwc_wc_text13, wc.wc_text14 polwc_wc_text14,
                   wc.wc_text15 polwc_wc_text15, wc.wc_text16 polwc_wc_text16,
                   wc.wc_text17 polwc_wc_text17, gwc.wc_text01 warrc_wc_text01,
                   gwc.wc_text02 warrc_wc_text02, gwc.wc_text03 warrc_wc_text03,
                   gwc.wc_text04 warrc_wc_text04, gwc.wc_text05 warrc_wc_text05,
                   gwc.wc_text06 warrc_wc_text06, gwc.wc_text07 warrc_wc_text07,
                   gwc.wc_text08 warrc_wc_text08, gwc.wc_text09 warrc_wc_text09,
                   gwc.wc_text10 warrc_wc_text10, gwc.wc_text11 warrc_wc_text11,
                   gwc.wc_text12 warrc_wc_text12, gwc.wc_text13 warrc_wc_text13,
                   gwc.wc_text14 warrc_wc_text14, gwc.wc_text15 warrc_wc_text15,
                   gwc.wc_text16 warrc_wc_text16, gwc.wc_text17 warrc_wc_text17,
                   wc.change_tag polwc_change_tag, wc.wc_cd wc_wc_cd,
                   wc.print_sw wc_print_sw
              FROM GIXX_POLWC   wc, 
                   GIIS_WARRCLA gwc
             WHERE gwc.main_wc_cd = wc.wc_cd 
               AND gwc.line_cd    = wc.line_cd)
     LOOP
        v_warranties.extract_id14     := i.extract_id14;
        v_warranties.wc_wc_title      := i.wc_wc_title;
        v_warranties.polwc_wc_text01  := i.polwc_wc_text01;
        v_warranties.polwc_wc_text02  := i.polwc_wc_text02;
        v_warranties.polwc_wc_text03  := i.polwc_wc_text03;
        v_warranties.polwc_wc_text04  := i.polwc_wc_text04;
        v_warranties.polwc_wc_text05  := i.polwc_wc_text05;
        v_warranties.polwc_wc_text06  := i.polwc_wc_text06;
        v_warranties.polwc_wc_text07  := i.polwc_wc_text07;
        v_warranties.polwc_wc_text08  := i.polwc_wc_text08;
        v_warranties.polwc_wc_text09  := i.polwc_wc_text09;
        v_warranties.polwc_wc_text10  := i.polwc_wc_text10;
        v_warranties.polwc_wc_text11  := i.polwc_wc_text11;
        v_warranties.polwc_wc_text12  := i.polwc_wc_text12;
        v_warranties.polwc_wc_text13  := i.polwc_wc_text13;
        v_warranties.polwc_wc_text14  := i.polwc_wc_text14;
        v_warranties.polwc_wc_text15  := i.polwc_wc_text15;
        v_warranties.polwc_wc_text16  := i.polwc_wc_text16;
        v_warranties.polwc_wc_text17  := i.polwc_wc_text17;
        v_warranties.warrc_wc_text01  := i.warrc_wc_text01;
        v_warranties.warrc_wc_text02  := i.warrc_wc_text02;
        v_warranties.warrc_wc_text03  := i.warrc_wc_text03;
        v_warranties.warrc_wc_text04  := i.warrc_wc_text04;
        v_warranties.warrc_wc_text05  := i.warrc_wc_text05;
        v_warranties.warrc_wc_text06  := i.warrc_wc_text06;
        v_warranties.warrc_wc_text07  := i.warrc_wc_text07;
        v_warranties.warrc_wc_text08  := i.warrc_wc_text08;
        v_warranties.warrc_wc_text09  := i.warrc_wc_text09;
        v_warranties.warrc_wc_text10  := i.warrc_wc_text10;
        v_warranties.warrc_wc_text11  := i.warrc_wc_text11;
        v_warranties.warrc_wc_text12  := i.warrc_wc_text12;
        v_warranties.warrc_wc_text13  := i.warrc_wc_text13;
        v_warranties.warrc_wc_text14  := i.warrc_wc_text14;
        v_warranties.warrc_wc_text15  := i.warrc_wc_text15;
        v_warranties.warrc_wc_text16  := i.warrc_wc_text16;
        v_warranties.warrc_wc_text17  := i.warrc_wc_text17;
        v_warranties.polwc_change_tag := i.polwc_change_tag;
        v_warranties.wc_wc_cd         := i.wc_wc_cd;
        v_warranties.wc_print_sw      := i.wc_print_sw;
       PIPE ROW(v_warranties);
     END LOOP;
     RETURN;
   END get_pol_doc_warranties;
   
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 04.26.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Returns 'Y' if records exists with the given extract_id
	*/
	FUNCTION is_record_exists(p_extract_id IN GIXX_POLWC.extract_id%TYPE)
	RETURN VARCHAR2
	IS
		v_exist	VARCHAR2(1) := 'N';
	BEGIN
		FOR i IN (
			SELECT extract_id
			  FROM GIXX_POLWC
			 WHERE extract_id = p_extract_id)
		LOOP
			v_exist := 'Y';
		END LOOP;
		RETURN v_exist;
	END is_record_exists;
    
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 08, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to get the policy warranties and clauses which is used in package policy document report. 
*/
    
    FUNCTION get_pack_pol_doc_warranties(p_extract_id IN GIXX_POLWC.extract_id%TYPE,
                                         p_policy_id  IN GIXX_POLWC.policy_id%TYPE)
    RETURN pol_doc_warranties_tab PIPELINED IS
     
     v_warranties pol_doc_warranties_type;
     
   BEGIN
     FOR i IN (  
        SELECT ALL wc.extract_id extract_id, wc.wc_title wc_wc_title,
                   wc.wc_text01 polwc_wc_text01, wc.wc_text02 polwc_wc_text02,
                   wc.wc_text03 polwc_wc_text03, wc.wc_text04 polwc_wc_text04,
                   wc.wc_text05 polwc_wc_text05, wc.wc_text06 polwc_wc_text06,
                   wc.wc_text07 polwc_wc_text07, wc.wc_text08 polwc_wc_text08,
                   wc.wc_text09 polwc_wc_text09, wc.wc_text10 polwc_wc_text10,
                   wc.wc_text11 polwc_wc_text11, wc.wc_text12 polwc_wc_text12,
                   wc.wc_text13 polwc_wc_text13, wc.wc_text14 polwc_wc_text14,
                   wc.wc_text15 polwc_wc_text15, wc.wc_text16 polwc_wc_text16,
                   wc.wc_text17 polwc_wc_text17, gwc.wc_text01 warrc_wc_text01,
                   gwc.wc_text02 warrc_wc_text02, gwc.wc_text03 warrc_wc_text03,
                   gwc.wc_text04 warrc_wc_text04, gwc.wc_text05 warrc_wc_text05,
                   gwc.wc_text06 warrc_wc_text06, gwc.wc_text07 warrc_wc_text07,
                   gwc.wc_text08 warrc_wc_text08, gwc.wc_text09 warrc_wc_text09,
                   gwc.wc_text10 warrc_wc_text10, gwc.wc_text11 warrc_wc_text11,
                   gwc.wc_text12 warrc_wc_text12, gwc.wc_text13 warrc_wc_text13,
                   gwc.wc_text14 warrc_wc_text14, gwc.wc_text15 warrc_wc_text15,
                   gwc.wc_text16 warrc_wc_text16, gwc.wc_text17 warrc_wc_text17,
                   wc.change_tag polwc_change_tag, wc.wc_cd wc_wc_cd,
                   wc.print_sw wc_print_sw
              FROM GIXX_POLWC   wc, 
                   GIIS_WARRCLA gwc
             WHERE wc.extract_id = p_extract_id
              AND wc.policy_id   = p_policy_id
              AND gwc.main_wc_cd = wc.wc_cd
              AND gwc.line_cd = wc.line_cd
             ORDER BY wc.print_seq_no)
     LOOP
        v_warranties.extract_id14     := i.extract_id;
        v_warranties.wc_wc_title      := i.wc_wc_title;
        v_warranties.polwc_wc_text01  := i.polwc_wc_text01;
        v_warranties.polwc_wc_text02  := i.polwc_wc_text02;
        v_warranties.polwc_wc_text03  := i.polwc_wc_text03;
        v_warranties.polwc_wc_text04  := i.polwc_wc_text04;
        v_warranties.polwc_wc_text05  := i.polwc_wc_text05;
        v_warranties.polwc_wc_text06  := i.polwc_wc_text06;
        v_warranties.polwc_wc_text07  := i.polwc_wc_text07;
        v_warranties.polwc_wc_text08  := i.polwc_wc_text08;
        v_warranties.polwc_wc_text09  := i.polwc_wc_text09;
        v_warranties.polwc_wc_text10  := i.polwc_wc_text10;
        v_warranties.polwc_wc_text11  := i.polwc_wc_text11;
        v_warranties.polwc_wc_text12  := i.polwc_wc_text12;
        v_warranties.polwc_wc_text13  := i.polwc_wc_text13;
        v_warranties.polwc_wc_text14  := i.polwc_wc_text14;
        v_warranties.polwc_wc_text15  := i.polwc_wc_text15;
        v_warranties.polwc_wc_text16  := i.polwc_wc_text16;
        v_warranties.polwc_wc_text17  := i.polwc_wc_text17;
        v_warranties.warrc_wc_text01  := i.warrc_wc_text01;
        v_warranties.warrc_wc_text02  := i.warrc_wc_text02;
        v_warranties.warrc_wc_text03  := i.warrc_wc_text03;
        v_warranties.warrc_wc_text04  := i.warrc_wc_text04;
        v_warranties.warrc_wc_text05  := i.warrc_wc_text05;
        v_warranties.warrc_wc_text06  := i.warrc_wc_text06;
        v_warranties.warrc_wc_text07  := i.warrc_wc_text07;
        v_warranties.warrc_wc_text08  := i.warrc_wc_text08;
        v_warranties.warrc_wc_text09  := i.warrc_wc_text09;
        v_warranties.warrc_wc_text10  := i.warrc_wc_text10;
        v_warranties.warrc_wc_text11  := i.warrc_wc_text11;
        v_warranties.warrc_wc_text12  := i.warrc_wc_text12;
        v_warranties.warrc_wc_text13  := i.warrc_wc_text13;
        v_warranties.warrc_wc_text14  := i.warrc_wc_text14;
        v_warranties.warrc_wc_text15  := i.warrc_wc_text15;
        v_warranties.warrc_wc_text16  := i.warrc_wc_text16;
        v_warranties.warrc_wc_text17  := i.warrc_wc_text17;
        v_warranties.polwc_change_tag := i.polwc_change_tag;
        v_warranties.wc_wc_cd         := i.wc_wc_cd;
        v_warranties.wc_print_sw      := i.wc_print_sw;
       PIPE ROW(v_warranties);
     END LOOP;
     RETURN;
   END get_pack_pol_doc_warranties;
   
   
   /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 1, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves warranties and clauses info for GIPIS101
    */
    FUNCTION get_polwc (
        p_extract_id    gixx_polwc.extract_id%TYPE
    ) RETURN polwc_tab PIPELINED
    IS
        v_polwc     polwc_type;
    BEGIN
        FOR rec IN (SELECT extract_id, line_cd, wc_cd, swc_seq_no,
                           print_seq_no, wc_title, wc_remarks, rec_flag,
                           wc_text01, wc_text02, wc_text03, wc_text04, wc_text05,
                           wc_text06, wc_text07, wc_text08, wc_text09, wc_text10,
                           wc_text11, wc_text12, wc_text13, wc_text14, wc_text15,
                           wc_text16, wc_text17
                      FROM gixx_polwc
                     WHERE extract_id = p_extract_id)
        LOOP
            v_polwc.extract_id := rec.extract_id;
            v_polwc.line_cd := rec.line_cd;
            v_polwc.wc_cd := rec.wc_cd;
            v_polwc.swc_seq_no := rec.swc_seq_no;
            v_polwc.print_seq_no := rec.print_seq_no;
            v_polwc.wc_title := rec.wc_title;
            v_polwc.wc_remarks := rec.wc_remarks;
            v_polwc.rec_flag := rec.rec_flag;
            /*v_polwc.dsp_wc_text := rec.wc_text01 || rec.wc_text02 || rec.wc_text03 || rec.wc_text04 || rec.wc_text05 ||
                                   rec.wc_text06 || rec.wc_text07 || rec.wc_text08 || rec.wc_text09 || rec.wc_text10 ||
                                   rec.wc_text11 || rec.wc_text12 || rec.wc_text13 || rec.wc_text14 || rec.wc_text15 ||
                                   rec.wc_text16 || rec.wc_text17; */
            v_polwc.wc_text01 := nvl(rec.wc_text01, '');
            v_polwc.wc_text02 := nvl(rec.wc_text02, '');
            v_polwc.wc_text03 := nvl(rec.wc_text03, '');
            v_polwc.wc_text04 := nvl(rec.wc_text04, '');
            v_polwc.wc_text05 := nvl(rec.wc_text05, '');
            v_polwc.wc_text06 := nvl(rec.wc_text06, '');
            v_polwc.wc_text07 := nvl(rec.wc_text07, '');
            v_polwc.wc_text08 := nvl(rec.wc_text08, '');
            v_polwc.wc_text09 := nvl(rec.wc_text09, '');
            v_polwc.wc_text10 := nvl(rec.wc_text10, '');
            v_polwc.wc_text11 := nvl(rec.wc_text11, '');
            v_polwc.wc_text12 := nvl(rec.wc_text12, '');
            v_polwc.wc_text13 := nvl(rec.wc_text13, '');
            v_polwc.wc_text14 := nvl(rec.wc_text14, '');
            v_polwc.wc_text15 := nvl(rec.wc_text15, '');
            v_polwc.wc_text16 := nvl(rec.wc_text16, '');
            v_polwc.wc_text04 := nvl(rec.wc_text17, '');            
                   
            PIPE ROW(v_polwc);
            
        END LOOP;
        
    END get_polwc;

END Gixx_Polwc_Pkg;
/


