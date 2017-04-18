package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIReminder;

public interface GIPIReminderDAO {

	List<GIPIReminder> getGIPIReminderListing(String alertUser) throws SQLException;
	String saveReminder(Map<String, Object> allParams) throws SQLException;
	Map<String, Object> validateAlarmUser(Map<String, Object> params) throws SQLException;
	Integer getClaimParId(String claimId) throws SQLException;	//SR-19555 : shan 07.07.2015
}
