CREATE OR REPLACE PACKAGE BODY CPI.GIPI_POLWC_PKG AS

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 15, 2010
**  Reference By : (GIPIS002 - Open Policy Details)
**  Description  : This modifies polwc details upon updating open policy details
*/
  PROCEDURE update_polwc_from_openpolicy(p_policy_id	GIPI_POLWC.policy_id%TYPE,
  										 p_par_id		GIPI_WPOLWC.par_id%TYPE) IS
	v_count								 NUMBER := 0;
	v_count2							 NUMBER := 0;
  BEGIN
    FOR i IN (SELECT policy_id,
                    line_cd,
                    wc_cd,
                    swc_seq_no,
                    print_seq_no,
                    wc_title,
                    print_sw,
                    change_tag
               FROM gipi_polwc
              WHERE policy_id = p_policy_id)
	LOOP
      v_count  := get_policy_count(p_policy_id);
	  v_count2 := Gipi_Wpolwc_Pkg.get_policy_count(p_par_id
	                                              ,i.line_cd
												  ,i.wc_cd
												  ,i.swc_seq_no);
      IF v_count <> 0 AND v_count2 = 0 THEN
	    INSERT INTO
		  gipi_wpolwc(par_id,line_cd,wc_cd,swc_seq_no,print_seq_no,wc_title,print_sw,change_tag)
      		  VALUES (p_par_id,i.line_cd,i.wc_cd,i.swc_seq_no,i.print_seq_no,i.wc_title,i.print_sw,i.change_tag);
	  END IF;
	END LOOP;
  END;

  FUNCTION get_policy_count(p_policy_id		GIPI_POLWC.policy_id%TYPE)
    RETURN NUMBER IS
	v_count		  NUMBER := 0;
  BEGIN
    SELECT count(*)
      INTO v_count
      FROM gipi_polwc
     WHERE policy_id = p_policy_id;
	RETURN v_count;
  END;

  FUNCTION get_related_wc_info(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)

    RETURN gipi_related_wc_info_tab PIPELINED

  IS v_wc_info    gipi_related_wc_info_type;

  BEGIN

     FOR i IN (SELECT a.policy_id,a.print_seq_no,a.wc_cd,a.swc_seq_no,
                      a.wc_title,a.wc_title2,a.wc_remarks,a.change_tag,
                      a.wc_text01,a.wc_text02,a.wc_text03,a.wc_text04,
                      a.wc_text05,a.wc_text06,a.wc_text07,a.wc_text08,
                      a.wc_text09,a.wc_text10,a.wc_text11,a.wc_text12,
                      a.wc_text13,a.wc_text14,a.wc_text15,a.wc_text16,
                      a.wc_text17,a.line_cd,a.print_sw
                 FROM GIPI_POLWC a
                WHERE a.policy_id = NVL(p_policy_id,a.policy_id))
      LOOP

        v_wc_info.print_sw          :=      i.print_sw;
        v_wc_info.policy_id         :=      i.policy_id;
        v_wc_info.print_seq_no      :=      i.print_seq_no;
        v_wc_info.wc_cd             :=      i.wc_cd;
        v_wc_info.swc_seq_no        :=      i.swc_seq_no;
        v_wc_info.wc_title          :=      i.wc_title;
        v_wc_info.wc_title2         :=      i.wc_title2;
        v_wc_info.wc_remarks        :=      i.wc_remarks;
        v_wc_info.change_tag        :=      i.change_tag;


        IF NVL(i.change_tag,'N') = 'Y' THEN
            v_wc_info.wc_text01     := i.wc_text01;
            v_wc_info.wc_text02     := i.wc_text02;
            v_wc_info.wc_text03     := i.wc_text03;
            v_wc_info.wc_text04     := i.wc_text04;
            v_wc_info.wc_text05     := i.wc_text05;
            v_wc_info.wc_text06     := i.wc_text06;
            v_wc_info.wc_text07     := i.wc_text07;
            v_wc_info.wc_text08     := i.wc_text08;
            v_wc_info.wc_text09     := i.wc_text09;
            v_wc_info.wc_text10     := i.wc_text10;
            v_wc_info.wc_text11     := i.wc_text11;
            v_wc_info.wc_text12     := i.wc_text12;
            v_wc_info.wc_text13     := i.wc_text13;
            v_wc_info.wc_text14     := i.wc_text14;
            v_wc_info.wc_text15     := i.wc_text15;
            v_wc_info.wc_text16     := i.wc_text16;
            v_wc_info.wc_text17     := i.wc_text17;
        ELSE

            SELECT wc_text01,wc_text02,
                   wc_text03,wc_text04,
                   wc_text05,wc_text06,
                   wc_text07,wc_text08,
                   wc_text09,wc_text10,
                   wc_text11,wc_text12,
                   wc_text13,wc_text14,
                   wc_text15,wc_text16,
                   wc_text17
              INTO v_wc_info.wc_text01,
                   v_wc_info.wc_text02,
                   v_wc_info.wc_text03,
                   v_wc_info.wc_text04,
                   v_wc_info.wc_text05,
                   v_wc_info.wc_text06,
                   v_wc_info.wc_text07,
                   v_wc_info.wc_text08,
                   v_wc_info.wc_text09,
                   v_wc_info.wc_text10,
                   v_wc_info.wc_text11,
                   v_wc_info.wc_text12,
                   v_wc_info.wc_text13,
                   v_wc_info.wc_text14,
                   v_wc_info.wc_text15,
                   v_wc_info.wc_text16,
                   v_wc_info.wc_text17
              FROM GIIS_WARRCLA
             WHERE line_cd    = i.line_cd
               AND main_wc_cd = i.wc_cd;

        END IF;

        PIPE ROW(v_wc_info);

      END LOOP;                     --moses 04192011


  END get_related_wc_info;

END GIPI_POLWC_PKG;
/


