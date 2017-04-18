CREATE OR REPLACE PACKAGE CPI.gipi_wpack_line_subline_pkg
AS
   TYPE gipi_wpack_line_subline_type IS RECORD (
      par_id            gipi_wpack_line_subline.par_id%TYPE,
      pack_par_id       gipi_wpack_line_subline.pack_par_id%TYPE,
      line_cd           gipi_wpack_line_subline.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
      pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      item_tag          gipi_wpack_line_subline.item_tag%TYPE,
      remarks           gipi_wpack_line_subline.remarks%TYPE,
      op_flag           giis_subline.op_flag%TYPE,
      menu_line_cd      giis_line.menu_line_cd%TYPE
   );

   TYPE gipi_wpack_line_subline_tab IS TABLE OF gipi_wpack_line_subline_type;

   FUNCTION get_gipi_wpack_line_subline (
      p_par_id   gipi_wpack_line_subline.par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab PIPELINED;

   FUNCTION get_gipi_wpack_line_subline (
      p_par_id    gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd   gipi_wpack_line_subline.line_cd%TYPE
   )
      RETURN gipi_wpack_line_subline_tab PIPELINED;

   FUNCTION get_gipi_wpack_line_subline3 (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab PIPELINED;

   TYPE gipi_wpack_coverage_type IS RECORD (
      pack_line_cd        gipi_wpack_line_subline.pack_line_cd%TYPE,
      pack_line_name      giis_line.line_name%TYPE,
      pack_subline_cd     gipi_wpack_line_subline.pack_subline_cd%TYPE,
      pack_subline_name   giis_subline.subline_name%TYPE
   );

   TYPE gipi_wpack_coverage_tab IS TABLE OF gipi_wpack_coverage_type;

/*
**  Created by        : irwin
**  Date Created     : 03.11.2011
*/
   FUNCTION get_line_subline (p_line_cd gipi_wpack_line_subline.line_cd%TYPE)
      RETURN gipi_wpack_coverage_tab PIPELINED;

   TYPE gipi_wpack_line_subline_type1 IS RECORD (
      pack_par_id         gipi_wpack_line_subline.pack_par_id%TYPE,
      par_id              gipi_wpack_line_subline.par_id%TYPE,
      pack_line_cd        gipi_wpack_line_subline.pack_line_cd%TYPE,
      pack_line_name      giis_line.line_name%TYPE,
      pack_subline_cd     gipi_wpack_line_subline.pack_subline_cd%TYPE,
      pack_subline_name   giis_subline.subline_name%TYPE,
      item_tag            gipi_wpack_line_subline.item_tag%TYPE,
      remarks             gipi_wpack_line_subline.remarks%TYPE
   );

   TYPE gipi_wpack_line_subline_tab1 IS TABLE OF gipi_wpack_line_subline_type1;

   FUNCTION get_wpack_line_subline_list (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab1 PIPELINED;

   FUNCTION get_wpack_dsp_tag (
      p_par_id            gipi_wpack_line_subline.par_id%TYPE,
      p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_line_cd           gipi_wpack_line_subline.line_cd%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE set_gipi_wpack_line_subline (
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_pack_par_id       IN   gipi_wpack_line_subline.pack_par_id%TYPE,
      p_line_cd           IN   gipi_wpack_line_subline.line_cd%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_item_tag          IN   gipi_wpack_line_subline.item_tag%TYPE,
      p_remarks           IN   gipi_wpack_line_subline.remarks%TYPE
   );

   PROCEDURE del_gipi_wpack_line_subline (
      p_par_id            gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd           gipi_wpack_line_subline.line_cd%TYPE,
      p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE
   );

   PROCEDURE del_gipi_wpack_line_subline (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   );

/*
 Created by Cris 05/21/2010
 For GIPIS050A as validation before saving new Package PAR
*/
   PROCEDURE check_if_line_subline_exist (
      p_pack_par_id   IN       gipi_wpack_line_subline.pack_par_id%TYPE,
      p_line_cd       IN       gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_message       IN OUT   VARCHAR2
   );

/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_wpack_line_subline (
      p_par_id    gipi_witem.par_id%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   );

-- end of whofeih
/***************************************************************************/

   /*
    Created by Emman 06/28/2010
    For GIPIS060
   */
   PROCEDURE update_gipi_wpack_line_subline (
      p_par_id            gipi_wpolbas.par_id%TYPE,
      p_pack_line_cd      gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd   gipi_witem.pack_subline_cd%TYPE
   );

   PROCEDURE upd_gipi_wpack_line_subline (
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE
   );

   PROCEDURE populate_package (
      p_par_id    gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd   gipi_wpack_line_subline.line_cd%TYPE
   );

   /*   Created By Irwin Tabisora
        GIPIS093 B955 POST INSERT
   */
   PROCEDURE gipis093_post_insert (
      p_iss_cd         IN   VARCHAR2,
      p_pack_par_id    IN   gipi_wpack_line_subline.pack_par_id%TYPE,
      p_pack_line_cd   IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_par_id         IN   gipi_wpack_line_subline.par_id%TYPE
   );

     /*   Created By Irwin Tabisora
     GIPI_PARLIST
   */

   --  procedure pack_line_subline_post_insert(pack_par_id GIPI_PARLIST.pack_par_id%TYPE, par_id GIPI_PARLIST.par_id%TYPE,
    -- p_line_cd GIPI_PARLIST.line_cd%TYPE, p_iss_cd GIPI_PARLIST.iss_cd%TYPE, p_par_yy GIPI_PARLIST.par_yy%TYPE, p_quote_seq_no GIPI_PARLIST.quote_seq_no%TYPE,);
   PROCEDURE update_item_tag (
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_item_tag          IN   gipi_wpack_line_subline.item_tag%TYPE
   );

   /*
   **  Created by: Robert 07.25.2011
   **  Used on: Endt Package Line  Coverage
   */
   FUNCTION get_endt_line_subline (
      p_line_cd      gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     gipi_wpolbas.renew_no%TYPE
   )
      RETURN gipi_wpack_coverage_tab PIPELINED;

   TYPE gipi_wpack_line_subline_type2 IS RECORD (
      pack_par_id         gipi_wpack_line_subline.pack_par_id%TYPE,
      par_id              gipi_wpack_line_subline.par_id%TYPE,
      pack_line_cd        gipi_wpack_line_subline.pack_line_cd%TYPE,
      pack_line_name      giis_line.line_name%TYPE,
      pack_subline_cd     gipi_wpack_line_subline.pack_subline_cd%TYPE,
      pack_subline_name   giis_subline.subline_name%TYPE,
      item_tag            gipi_wpack_line_subline.item_tag%TYPE,
      remarks             gipi_wpack_line_subline.remarks%TYPE
   );

   TYPE gipi_wpack_line_subline_tab2 IS TABLE OF gipi_wpack_line_subline_type2;

   PROCEDURE del_wpack_line_subline_by_id (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   );

   PROCEDURE post_insert_pack_line_subline (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   );

   FUNCTION get_wpack_line_subline_list2 (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab1 PIPELINED;

   PROCEDURE gipis094_post_insert (
      p_pack_par_id       IN   gipi_wpack_line_subline.pack_par_id%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd           IN   gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd        IN   gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd            IN   gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy          IN   gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN   gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN   gipi_pack_polbasic.renew_no%TYPE
   );

   PROCEDURE cancellation_update_amounts (
      p_pack_par_id   IN   gipi_wpack_line_subline.pack_par_id%TYPE
   );
END gipi_wpack_line_subline_pkg;
/


