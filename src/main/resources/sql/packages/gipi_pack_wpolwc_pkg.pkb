CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Pack_WPolWC_Pkg AS

/*
**  Created by   :  Veronica V.Raymundo
**  Date Created :  January 24, 2011
**  Reference By : (GIPIS024A - Package Par Policy Warranties and Clauses)
**  Description  : This inserts new package policy warranty and clause record
**                 or updates the record if existing.
*/

 PROCEDURE set_gipi_pack_wpolwc (p_pack_wpolwc      GIPI_PACK_WPOLWC%ROWTYPE)

 IS

 BEGIN
    MERGE INTO GIPI_PACK_WPOLWC
    USING DUAL ON ( pack_par_id  = p_pack_wpolwc.pack_par_id
                AND line_cd      = p_pack_wpolwc.line_cd
                AND wc_cd        = p_pack_wpolwc.wc_cd)

      WHEN NOT MATCHED THEN
        INSERT (pack_par_id,    line_cd,            wc_cd,
                swc_seq_no,     print_seq_no,       wc_title,
                rec_flag,       print_sw,           change_tag,
                wc_text01,      wc_text02,          wc_text03,
                wc_text04,      wc_text05,          wc_text06,
                wc_text07,      wc_text08,          wc_text09,
                wc_text10,      wc_text11,          wc_text12,
                wc_text13,      wc_text14,          wc_text15,
                wc_text16,      wc_text17,          wc_title2)

       VALUES(p_pack_wpolwc.pack_par_id,        p_pack_wpolwc.line_cd,      p_pack_wpolwc.wc_cd,
              p_pack_wpolwc.swc_seq_no,         p_pack_wpolwc.print_seq_no, p_pack_wpolwc.wc_title,
              p_pack_wpolwc.rec_flag,           p_pack_wpolwc.print_sw,     p_pack_wpolwc.change_tag,
              p_pack_wpolwc.wc_text01,          p_pack_wpolwc.wc_text02,    p_pack_wpolwc.wc_text03,
              p_pack_wpolwc.wc_text04,          p_pack_wpolwc.wc_text05,    p_pack_wpolwc.wc_text06,
              p_pack_wpolwc.wc_text07,          p_pack_wpolwc.wc_text08,    p_pack_wpolwc.wc_text09,
              p_pack_wpolwc.wc_text10,          p_pack_wpolwc.wc_text11,    p_pack_wpolwc.wc_text12,
              p_pack_wpolwc.wc_text13,          p_pack_wpolwc.wc_text14,    p_pack_wpolwc.wc_text15,
              p_pack_wpolwc.wc_text16,          p_pack_wpolwc.wc_text17,    p_pack_wpolwc.wc_title2)

    WHEN MATCHED THEN
        	UPDATE SET  wc_text01 		= p_pack_wpolwc.wc_text01,
                        wc_text02 		= p_pack_wpolwc.wc_text02,
                        wc_text03 		= p_pack_wpolwc.wc_text03,
                        wc_text04 		= p_pack_wpolwc.wc_text04,
                        wc_text05 		= p_pack_wpolwc.wc_text05,
                        wc_text06 		= p_pack_wpolwc.wc_text06,
                        wc_text07 		= p_pack_wpolwc.wc_text07,
                        wc_text08 		= p_pack_wpolwc.wc_text08,
                        wc_text09 		= p_pack_wpolwc.wc_text09,
                        wc_text10 		= p_pack_wpolwc.wc_text10,
                        wc_text11 		= p_pack_wpolwc.wc_text11,
                        wc_text12 		= p_pack_wpolwc.wc_text12,
                        wc_text13 		= p_pack_wpolwc.wc_text13,
                        wc_text14 		= p_pack_wpolwc.wc_text14,
                        wc_text15 		= p_pack_wpolwc.wc_text15,
                        wc_text16 		= p_pack_wpolwc.wc_text16,
                        wc_text17 		= p_pack_wpolwc.wc_text17,
                        swc_seq_no		= p_pack_wpolwc.swc_seq_no,
                        print_seq_no    = p_pack_wpolwc.print_seq_no,
                        rec_flag		= p_pack_wpolwc.rec_flag,
                        print_sw		= p_pack_wpolwc.print_sw,
                        change_tag		= p_pack_wpolwc.change_tag,
                        wc_title2		= p_pack_wpolwc.wc_title2;

 END set_gipi_pack_wpolwc;

/*
**  Created by   :  Veronica V.Raymundo
**  Date Created :  January 24, 2011
**  Reference By : (GIPIS024A - Package Par Policy Warranties and Clauses)
**  Description  : Deletes the specific policy warranty and clause record included
**                 in a package par.
*/

 PROCEDURE del_gipi_pack_wpolwc (p_wc_cd            GIPI_PACK_WPOLWC.wc_cd%TYPE,
                                 p_line_cd          GIPI_PACK_WPOLWC.line_cd%TYPE,
                                 p_pack_par_id      GIPI_PACK_WPOLWC.pack_par_id%TYPE)
 IS

 BEGIN
    DELETE FROM GIPI_PACK_WPOLWC
  	 WHERE wc_cd 				= p_wc_cd
		   AND line_cd 			= p_line_cd
		   AND pack_par_id      = p_pack_par_id;

 END del_gipi_pack_wpolwc;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-13-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  :
  */
    PROCEDURE del_gipi_pack_wpolwc (p_pack_par_id      GIPI_PACK_WPOLWC.pack_par_id%TYPE) IS
    BEGIN
        DELETE FROM GIPI_PACK_WPOLWC
         WHERE pack_par_id      = p_pack_par_id;
    END del_gipi_pack_wpolwc;

 END gipi_pack_wpolwc_pkg;
/


