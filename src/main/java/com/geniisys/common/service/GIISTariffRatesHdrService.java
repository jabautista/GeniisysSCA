package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISTariffRatesHdr;

public interface GIISTariffRatesHdrService {
	
	GIISTariffRatesHdr getTariffDetailsFI(Map<String, Object> params) throws SQLException; 
	GIISTariffRatesHdr getTariffDetailsMC(Map<String, Object> params) throws SQLException; 
	
	//shan 01.06.2014

	JSONObject showGiiss106(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiiss106FixedSIList(HttpServletRequest request, String userId) throws SQLException, JSONException;
//	JSONObject getGiiss106WithCompDtl(String tariffCd) throws SQLException; //remove by steven 07.04.2014
//	JSONObject getGiiss106FixedPremDtl(String tariffCd) throws SQLException; 
	void valAddHdrRec(HttpServletRequest request) throws SQLException;
	void valDeleteHdrRec(String tariffCd) throws SQLException;
	Integer getTariffCdNoSequence() throws SQLException;
	void valTariffRatesFixedSIRec(HttpServletRequest request) throws SQLException;
//	JSONObject getGiiss106MinMaxAmt(Integer tariffCd) throws SQLException;
//	Integer getNextTariffDtlCd(Integer tariffCd) throws SQLException;
	void valAddDtlRec(HttpServletRequest request) throws SQLException;
//	List<GIISTariffRatesDtl> prepareTariffRatesDtlForInsert(JSONArray rows, String userId) throws SQLException, JSONException;  //remove by steven 07.04.2014 sa serviceImpl mo lang gagamit,ginawan mo pa ng interface. :(
//	List<GIISTariffRatesHdr> prepareTariffRatesHdrForInsert(JSONArray rows, String userId) throws SQLException, JSONException;
	void saveGiiss106(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss106AllFixedSIList(HttpServletRequest request,String userId) throws SQLException, JSONException;
	JSONObject getGiiss106AllRec(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
