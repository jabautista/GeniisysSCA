CREATE OR REPLACE PACKAGE BODY CPI.gipi_insp_data_wc_pkg AS

  FUNCTION get_gipi_insp_data_wc(
  	 p_insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE
  ) RETURN gipi_insp_data_wc_table PIPELINED

  IS
  	v_insp_data_wc			  gipi_insp_data_wc_type;

  BEGIN
  	   FOR i IN (SELECT insp_no, line_cd, wc_cd, arc_ext_data
	   	   	 	   FROM gipi_insp_data_wc
	              WHERE insp_no = p_insp_no
	   	   	 	)
	   LOOP
	   	   v_insp_data_wc.insp_no 		   := i.insp_no;
		   v_insp_data_wc.line_cd		   := i.line_cd;
		   v_insp_data_wc.wc_cd			   := i.wc_cd;
		   v_insp_data_wc.arc_ext_data	   := i.arc_ext_data;

           FOR j IN (
                SELECT *
                  FROM giis_warrcla
                 WHERE main_wc_cd = i.wc_cd
                   AND line_cd = NVL(i.line_cd, line_cd)
           ) LOOP
                v_insp_data_wc.dsp_wc_title     := j.wc_title;
                v_insp_data_wc.dsp_wc_text1     := j.wc_text01;
                v_insp_data_wc.dsp_wc_text2     := j.wc_text02;
                v_insp_data_wc.dsp_wc_text3     := j.wc_text03;
                v_insp_data_wc.dsp_wc_text4     := j.wc_text04;
                v_insp_data_wc.dsp_wc_text5     := j.wc_text05;
                v_insp_data_wc.dsp_wc_text6     := j.wc_text06;
                v_insp_data_wc.dsp_wc_text7     := j.wc_text07;
                v_insp_data_wc.dsp_wc_text8     := j.wc_text08;
                v_insp_data_wc.dsp_wc_text9     := j.wc_text09;
                v_insp_data_wc.dsp_wc_text10     := j.wc_text10;
                v_insp_data_wc.dsp_wc_text11     := j.wc_text11;
                v_insp_data_wc.dsp_wc_text12     := j.wc_text12;
                v_insp_data_wc.dsp_wc_text13     := j.wc_text13;
                v_insp_data_wc.dsp_wc_text14     := j.wc_text14;
                v_insp_data_wc.dsp_wc_text15     := j.wc_text05;
                v_insp_data_wc.dsp_wc_text16     := j.wc_text16;
                v_insp_data_wc.dsp_wc_text17     := j.wc_text17;
                EXIT;
           END LOOP;
		   PIPE ROW(v_insp_data_wc);
	   END LOOP;
	   RETURN;
  END get_gipi_insp_data_wc;

  PROCEDURE insert_insp_data_wc(
  	 p_insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE,
	 p_wc_cd				  GIPI_INSP_DATA_WC.wc_cd%TYPE,
	 p_arc_ext_data			  GIPI_INSP_DATA_WC.arc_ext_data%TYPE
  )

  IS

  BEGIN
	   INSERT
	     INTO gipi_insp_data_wc(insp_no, wc_cd, arc_ext_data)
	   VALUES (p_insp_no, p_wc_cd, p_arc_ext_data);
  END insert_insp_data_wc;

  PROCEDURE delete_insp_data_wc(
  	 p_insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE,
	 p_wc_cd				  GIPI_INSP_DATA_WC.wc_cd%TYPE
  )

  IS

  BEGIN
  	   DELETE
	     FROM gipi_insp_data_wc
		WHERE insp_no = p_insp_no
		  AND wc_cd = p_wc_cd;
  END delete_insp_data_wc;

END gipi_insp_data_wc_pkg;
/


