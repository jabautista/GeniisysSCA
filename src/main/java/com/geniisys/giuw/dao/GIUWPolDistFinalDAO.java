package com.geniisys.giuw.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIUWPolDistFinalDAO {
	
	Map<String, Object> compareGIPIItemItmperil(Map<String, Object> params) throws SQLException;
	void createItemsGiuws010(Map<String, Object> params) throws SQLException, Exception;
	void saveSetUpGroupsForDistrFinalItem(Map<String, Object> allParams) throws SQLException, Exception;
	Map<String, Object> compareGIPIItemItmperilGiuws018(Map<String, Object> params) throws SQLException;
	void createItemsGiuws018(Map<String, Object> params) throws SQLException, Exception;
	void saveSetUpPerilGrpDistFinal(Map<String, Object> allParams) throws SQLException, Exception;
	//edgar 09/11/2014
	Map<String, Object> checkPostedBinder(Map<String, Object> params) throws SQLException;
	void validateSetupDistPerAction (Map<String, Object> params) throws SQLException, Exception; // added by jhing 12.05.2014 

}
