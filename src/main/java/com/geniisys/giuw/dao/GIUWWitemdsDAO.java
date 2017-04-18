package com.geniisys.giuw.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giuw.entity.GIUWWitemds;

public interface GIUWWitemdsDAO {
	
	List<GIUWWitemds> getGiuwWitemdsForDistrFinal(HashMap<String, Object> params) throws SQLException;
	List<Map<String, Object>> getGiuwWitemdsOthPgeDistGrps(HashMap<String, Object> params) throws SQLException; // added by jhing 12.05.2014

}
