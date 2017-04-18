package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACInwFaculPremCollns;

public interface GIACInwFaculPremCollnsService {
	
	List<GIACInwFaculPremCollns> getGIACInwFaculPremCollns(Integer gaccTranId, GIISUser user) throws SQLException;
	PaginatedList getInvoiceList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	PaginatedList getInstNoList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	String validateInvoice(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> validateInstNo(HashMap<String, Object> params) throws SQLException;
	String saveInwardFacul(Map<String, Object> params) throws SQLException;
	List<GIACInwFaculPremCollns> prepareInsertInwItems(HttpServletRequest request, HttpServletResponse response,GIISUser USER);
	List<GIACInwFaculPremCollns> prepareDelInwItems(HttpServletRequest request, HttpServletResponse response,GIISUser USER);
	
	Map<String, Object> getInvoice(HashMap<String, Object> params) throws SQLException;
	/**
	 * Returns Inw Facul Premium Collection for a given invoice
	 * @param a HashMap containing table grid parameters 
	 * 		    plus issCd and premSeqNo
	 * @returns HashMap that contains list of Inw Premium Collections
	 * @throws  SQLException
	 */
	HashMap<String, Object> getRelatedInwFaculPremCollns(HashMap<String,Object> params) throws SQLException;
	HashMap<String, Object> getInvoiceListTableGrid(HashMap<String, Object> params) throws SQLException, JSONException;
	List<GIACInwFaculPremCollns> getOtherInwFaculPremCollns(Integer gaccTranId) throws SQLException;
	
	//added john 11.3.2014
	String checkPremPaytForRiSpecial(HttpServletRequest request) throws SQLException;
	String checkPremPaytForCancelled(HttpServletRequest request, GIISUser userId) throws SQLException;
	String validateDelete(HttpServletRequest request) throws SQLException; //added john 2.24.2015
	Map<String, Object> updateOrDtls(HttpServletRequest request) throws SQLException; //Deo [01.20.2017]: SR-5909
}
