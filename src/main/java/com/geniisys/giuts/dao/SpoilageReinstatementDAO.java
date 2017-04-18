package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SpoilageReinstatementDAO {

	Map<String, Object> whenNewFormInstanceGiuts003() throws SQLException;
	Map<String, Object> spoilPolicyGiuts003(Map<String, Object> params) throws SQLException;
	Map<String, Object> unspoilPolicyGiuts003(Map<String, Object> params) throws SQLException;
	Map<String, Object> postPolicyGiuts003(Map<String, Object> params) throws SQLException;
	Map<String, Object> postPolicy2Giuts003(Map<String, Object> params) throws SQLException;	

	/* for GIUTS003A - Spoil Package Policy/Endorsement */
	public Map<String, Object> whenNewFormGiuts003a() throws SQLException;
	public Map<String, Object> getPackPolicyDetailsGiuts003a(Map<String, Object> params) throws SQLException;
	//public List<Map<String, Object>> chkPackPolicyForSpoilageGiuts003a(Map<String, Object> params) throws SQLException; //changed by kenneth 07132015 SR 4753 
	void chkPackPolicyForSpoilageGiuts003a(Map<String, Object> params) throws SQLException;
	public Map<String, Object> spoilPackGiuts003a(Map<String, Object> params) throws SQLException;
	public Map<String, Object> unspoilPackGiuts003a(Map<String, Object> params) throws SQLException;
	public Map<String, Object> chkPackPolicyPostGiuts003a(Map<String, Object> params) throws SQLException;
	
	/*for GIUTS028 - policy reinstatement jomsdiago 07.25.2013*/
	Map<String, Object> whenNewFormInstanceGIUTS028() throws SQLException;
	Map<String, Object> validateGIUTS028EndtRecord(Map<String, Object> params) throws SQLException;
	void validateGIUTS028CheckPaid(Map<String, Object> params) throws SQLException;
	void validateGIUTS028CheckRIPayt(Map<String, Object> params) throws SQLException;
	void validateGIUTS028RenewPol(Map<String, Object> params) throws SQLException;
	void validateGIUTS028CheckAcctEntDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkMrn(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkEndtOnProcess(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> processGIUTS028Reinstate(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> checkOrigRenewStatus(Map<String, Object> params) throws SQLException; //benjo 09.03.2015 UW-SPECS-2015-080
	
	/*for GIUTS028A - package policy reinstatement jomsdiago 07.29.2013*/
	Map<String, Object> whenNewFormInstanceGIUTS028A() throws SQLException;
	HashMap<String, Object> reinstatePackageGIUTS028A(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> postGIUTS028AReinstate(HashMap<String, Object> params) throws SQLException;
	String validateSpoilCdGiuts003(String spoilCd) throws SQLException;
	Map<String, Object> checkPackOrigRenewStatus(Map<String, Object> params) throws SQLException; //benjo 09.03.2015 UW-SPECS-2015-080
}
