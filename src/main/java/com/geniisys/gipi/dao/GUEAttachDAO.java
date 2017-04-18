package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GUEAttach;

public interface GUEAttachDAO {

	List<String> setGUEAttach(Map<String, Object> params) throws SQLException; 
	void saveGUEAttachments(Map<String, Object> params) throws SQLException;
	List<GUEAttach> getGUEAttachListing(Integer tranId) throws SQLException;
	
}
