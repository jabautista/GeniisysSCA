package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWItemVes;

public interface GIPIWItemVesDAO {
	List<GIPIWItemVes> getGipiWItemVes(Integer parId) throws SQLException;
	void saveGIPIParMarineHullItem (Map<String, Object> params) throws SQLException;
	GIPIWItemVes getEndtGipiWItemVesDetails(Map<String, Object> params) throws SQLException; 
	String validateVessel(Map<String, Object> params) throws SQLException;
	void saveEndtMarineHullItemInfoPage(Map<String, Object> params) throws SQLException;
	void delGIPIWItemVes(Map<String, Object> params) throws SQLException;
	String preInsertMarineHull(Map<String, Object> params) throws SQLException;
	void insertGIPIWItemVes(GIPIWItemVes itemVes) throws SQLException;
	String checkItemVesAddtlInfo(Integer parId) throws SQLException; 
	void changeItemVesGroup(Integer parId) throws SQLException; 
	String checkUpdateGipiWPolbasValidity(Map<String, Object> params) throws SQLException;
	String checkCreateDistributionValidity(Integer parId) throws SQLException;
	String checkGiriDistfrpsExist(Integer parId) throws SQLException;
	void itemVesCreateDistribution(Integer parId) throws SQLException;
	void updateGipiWPolbas2(Map<String, Object> updateGIPIWPolbasParams) throws SQLException;
	public void saveGIPIEndtItemVes(Map<String, Object> allParams)	throws SQLException, ParseException;
	
	Map<String, Object> gipis009NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIWItemVes(Map<String, Object> params) throws SQLException, JSONException;
}
