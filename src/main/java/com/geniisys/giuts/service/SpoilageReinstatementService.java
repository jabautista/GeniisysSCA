package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface SpoilageReinstatementService {
	
	String whenNewFormInstanceGiuts003(HttpServletRequest request) throws SQLException;
	String spoilPolicyGiuts003(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String unspoilPolicyGiuts003(HttpServletRequest request) throws SQLException;
	String postPolicyGiuts003(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String postPolicy2Giuts003(HttpServletRequest request, String userId) throws SQLException, ParseException;
	

	/* for GIUTS003A - Spoil Package Policy/Endorsement */
	public Map<String, Object> whenNewFormGiuts003a() throws SQLException;
	public String getPackPolicyDetailsGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException;
	//public List<Map<String, Object>> chkPackPolicyForSpoilageGiuts003a(HttpServletRequest request) throws SQLException; //changed by kenneth 07132015 SR 4753 
	String chkPackPolicyForSpoilageGiuts003a(HttpServletRequest request) throws SQLException; //apollo cruz 11.13.2015 sr#20906
	public String spoilPackGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException;
	public String unspoilPackGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException;
	public String chkPackPolicyPostGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException;
	
	/*for GIUTS028 - policy reinstatement jomsdiago 07.25.2013*/
	String whenNewFormInstanceGIUTS028(HttpServletRequest request) throws SQLException;
	String validateGIUTS028EndtRecord(HttpServletRequest request) throws SQLException;
	void validateGIUTS028CheckPaid(Map<String, Object> params) throws SQLException;
	void validateGIUTS028CheckRIPayt(Map<String, Object> params) throws SQLException;
	void validateGIUTS028RenewPol(Map<String, Object> params) throws SQLException;
	void validateGIUTS028CheckAcctEntDate(Map<String, Object> params) throws SQLException;
	String checkMrn(HttpServletRequest request) throws SQLException;
	String checkEndtOnProcess(HttpServletRequest request) throws SQLException;
	String processGIUTS028Reinstate(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String checkOrigRenewStatus(HttpServletRequest request) throws SQLException; //benjo 09.03.2015 UW-SPECS-2015-080
	
	/*for GIUTS028A - package policy reinstatement jomsdiago 07.29.2013*/
	String whenNewFormInstanceGIUTS028A(HttpServletRequest request) throws SQLException;
	String reinstatePackageGIUTS028A(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String postGIUTS028AReinstate(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String validateSpoilCdGiuts003(HttpServletRequest request) throws SQLException;
	String checkPackOrigRenewStatus(HttpServletRequest request) throws SQLException; //benjo 09.03.2015 UW-SPECS-2015-080
}
