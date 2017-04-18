DROP PROCEDURE CPI.GET_CA_TEMP_EXPOSURE;

CREATE OR REPLACE PROCEDURE CPI.GET_CA_TEMP_EXPOSURE( p_exclude_expiry   IN VARCHAR2,
                                                      p_exclude_not_eff  IN VARCHAR2,
                                                      p_location_cd      IN GIPI_CASUALTY_ITEM.location_cd%TYPE,
                                                      p_share_type       IN GIIS_DIST_SHARE.share_type%TYPE,
                                                      p_dist_tsi        OUT GIXX_CA_ACCUM_DIST.dist_tsi%TYPE ) IS
BEGIN
  IF p_exclude_expiry = 'Y' AND p_exclude_not_eff = 'Y' THEN
     SELECT SUM(dist_tsi)
       INTO p_dist_tsi
       FROM gipi_ca_item_basic_dist_v a, giis_peril b
      WHERE a.line_cd = b.line_cd
        AND a.peril_cd = b.peril_cd
        AND a.location_cd = p_location_cd
        AND b.peril_type = 'B'
        AND a.share_type = p_share_type
        AND a.expiry_date >= SYSDATE
        AND a.eff_date <= SYSDATE;
  ELSIF p_exclude_expiry = 'Y' AND p_exclude_not_eff = 'N' THEN
     SELECT SUM(dist_tsi)
       INTO p_dist_tsi
       FROM gipi_ca_item_basic_dist_v a, giis_peril b
      WHERE a.line_cd = b.line_cd
        AND a.peril_cd = b.peril_cd
        AND a.location_cd = p_location_cd
        AND b.peril_type = 'B'
        AND a.share_type = p_share_type
        AND a.expiry_date >= SYSDATE;
  ELSIF p_exclude_expiry = 'N' AND p_exclude_not_eff = 'Y' THEN
     SELECT SUM(dist_tsi)
       INTO p_dist_tsi
       FROM gipi_ca_item_basic_dist_v a, giis_peril b
      WHERE a.line_cd = b.line_cd
        AND a.peril_cd = b.peril_cd
        AND a.location_cd = p_location_cd
        AND b.peril_type = 'B'
        AND a.share_type = p_share_type
        AND a.eff_date <= SYSDATE;
  ELSIF p_exclude_expiry = 'N' AND p_exclude_not_eff = 'N' THEN
     SELECT SUM(dist_tsi)
       INTO p_dist_tsi
       FROM gipi_ca_item_basic_dist_v a, giis_peril b
      WHERE a.line_cd = b.line_cd
        AND a.peril_cd = b.peril_cd
        AND a.location_cd = p_location_cd
        AND b.peril_type = 'B'
        AND a.share_type = p_share_type;
  END IF;
END;
/


