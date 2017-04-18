package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACSpoiledOr;

public interface GIACSpoiledOrDAO {

	List<GIACSpoiledOr> getGIACSpoiledOrListing(Map<String, Object> params) throws SQLException;
	void saveSpoiledOrDtls(Map<String, Object> params) throws SQLException;
	String validateSpoiledOr(Map<String, Object> params) throws SQLException;
}
