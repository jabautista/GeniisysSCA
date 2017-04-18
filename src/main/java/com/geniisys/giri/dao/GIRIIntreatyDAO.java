package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giri.entity.GIRIInchargesTax;
import com.geniisys.giri.entity.GIRIIntreaty;
import com.geniisys.giri.entity.GIRIIntreatyCharges;

public interface GIRIIntreatyDAO {
	String copyIntreaty(Map<String, Object> params) throws SQLException, Exception;
	void approveIntreaty(Map<String, Object> params) throws SQLException, Exception;
	void cancelIntreaty(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> getGIISDistShare(Map<String, Object> params) throws SQLException, Exception;
	List<Map<String, Object>> getTranTypeList() throws SQLException, Exception;
	Map<String, Object> getDfltBookingMonth(Map<String, Object> params) throws SQLException, Exception;
	GIRIIntreaty getGIRIIntreaty(Integer intreatyId) throws SQLException, Exception;
	List<GIRIIntreatyCharges> getGIRIIntreatyCharges(Integer intreatyId) throws SQLException, Exception;
	Integer getIntreatyId() throws SQLException, Exception;
	Integer saveIntreaty(Map<String, Object> params) throws SQLException, Exception;
	List<GIRIInchargesTax> getGIRIInchargesTax(Map<String, Object> params) throws SQLException, Exception;
	void saveInchargesTax(Map<String, Object> params) throws SQLException, Exception;
	void updateIntreatyCharges(Map<String, Object> params) throws SQLException, Exception;
	void updateChargeAmount(Map<String, Object> params) throws SQLException, Exception;
	Integer getIntreatyId2(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> getViewIntreaty(Integer intreatyId) throws SQLException, Exception;
}
