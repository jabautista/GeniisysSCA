package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWCasualtyPersonnel;

public interface GIPIWCasualtyPersonnelDAO {

	List<GIPIWCasualtyPersonnel> getGipiWCasualtyPersonnel(Integer parId) throws SQLException;
	Map<String, Object> getCasualtyPersonnelDetails(Map<String, Object> params) throws SQLException;
}
