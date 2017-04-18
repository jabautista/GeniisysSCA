package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACInwFaculPremCollns;

public interface GIACInwFaculPremCollnsDAO {

	List<GIACInwFaculPremCollns> getGIACInwFaculPremCollns(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getInvoiceList(HashMap<String, Object> params) throws SQLException;
	List<Map<String, Object>> getInstNoList(HashMap<String, Object> params) throws SQLException;
	String validateInvoice(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> validateInstNo(HashMap<String, Object> params) throws SQLException;
	String saveInwardFacul(Map<String, Object> params) throws SQLException;
	Map<String, Object> getInvoice(HashMap<String, Object> params) throws SQLException;
	/**
	 * Returns Inw Facul Premium Collection for a given invoice
	 * @param a HashMap containing table grid parameters 
	 * 		    plus issCd and premSeqNo
	 * @returns list of Inw Facul Premium Collections
	 * @throws  SQLException
	 */
	List<GIACInwFaculPremCollns> getRelatedInwFaculPremCollns(HashMap<String,Object> params) throws SQLException;
	List<Map<String, Object>> getInvoiceListTableGrid(HashMap<String, Object> params) throws SQLException;
	List<GIACInwFaculPremCollns> getOtherInwFaculPremCollns(Integer gaccTranId) throws SQLException;
	
	//added john 11.3.2014
	String checkPremPaytForRiSpecial(HashMap<String, Object> params) throws SQLException;
	String checkPremPaytForCancelled(HashMap<String, Object> params) throws SQLException;
	String validateDelete(String recId) throws SQLException; //added john 2.24.2015
	void updateOrDtls(Map<String, Object> params) throws SQLException; //Deo [01.20.2017]: SR-5909
	Map<String, Object> getUpdatedOrDtls(HashMap<String, Object> params) throws SQLException; //Deo [01.20.2017]: SR-5909
}
