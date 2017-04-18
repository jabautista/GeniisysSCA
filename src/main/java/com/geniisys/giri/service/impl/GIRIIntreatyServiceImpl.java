package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giri.dao.GIRIIntreatyDAO;
import com.geniisys.giri.entity.GIRIInchargesTax;
import com.geniisys.giri.entity.GIRIIntreaty;
import com.geniisys.giri.entity.GIRIIntreatyCharges;
import com.geniisys.giri.service.GIRIIntreatyService;
import com.seer.framework.util.StringFormatter;

public class GIRIIntreatyServiceImpl implements GIRIIntreatyService {
	
	private GIRIIntreatyDAO giriIntreatyDAO;
	private static Logger log = Logger.getLogger(GIRIIntreatyServiceImpl.class);

	public GIRIIntreatyDAO getGiriIntreatyDAO() {		
		return giriIntreatyDAO;
	}

	public void setGiriIntreatyDAO(GIRIIntreatyDAO giriIntreatyDAO) {
		this.giriIntreatyDAO = giriIntreatyDAO;
	}
	
	@Override
	public JSONObject showIntreatyListing(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getGIRIIntreatyTG");
		params.put("intrtyFlag", request.getParameter("intrtyFlag"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("shareCd", request.getParameter("shareCd"));
		Map<String, Object> intreatyTG = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(intreatyTG));
	}
	
	@Override
	public void getIntreatyListing(HttpServletRequest request) throws SQLException, Exception {
		String lineCd = request.getParameter("lineCd");
		Integer trtyYy = request.getParameter("trtyYy") == null || request.getParameter("trtyYy").equals("") ? null : Integer.parseInt(request.getParameter("trtyYy"));
		Integer shareCd = request.getParameter("shareCd") == null || request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", lineCd);
		params.put("trtyYy", trtyYy);
		params.put("shareCd", shareCd);
		Map<String, Object> intrty = StringFormatter.escapeHTMLInMap(this.giriIntreatyDAO.getGIISDistShare(params));
		request.setAttribute("lineCd", lineCd);
		request.setAttribute("lineName", intrty.get("lineName"));
		request.setAttribute("trtyYy", trtyYy);
		request.setAttribute("dspTrtyYy", intrty.get("dspTrtyYy"));
		request.setAttribute("shareCd", shareCd);
		request.setAttribute("trtyName", intrty.get("trtyName"));
	}
	
	@Override
	public String copyIntreaty(Integer intreatyId, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();						
		params.put("appUser", userId);
		params.put("intreatyId", intreatyId);
		return this.giriIntreatyDAO.copyIntreaty(params);
	}
	
	@Override
	public void approveIntreaty(HttpServletRequest request, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("intreatyId", Integer.parseInt(request.getParameter("intreatyId")));
		params.put("userId", userId);
		this.giriIntreatyDAO.approveIntreaty(params);
	}
	
	@Override
	public void cancelIntreaty(HttpServletRequest request, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("intreatyId", Integer.parseInt(request.getParameter("intreatyId")));
		params.put("userId", userId);
		this.giriIntreatyDAO.cancelIntreaty(params);
	}
	
	@Override
	public void showCreateIntreaty(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, Exception {
		GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
		GIACParameterFacadeService giacParamService  = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
		LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
		Integer intreatyId = request.getParameter("intreatyId") == null || request.getParameter("intreatyId").equals("") ? 0 : Integer.parseInt(request.getParameter("intreatyId"));
		String lineCd = request.getParameter("lineCd");
		Integer trtyYy = Integer.parseInt(request.getParameter("trtyYy"));
		Integer shareCd = Integer.parseInt(request.getParameter("shareCd"));
		request.setAttribute("intreatyId", intreatyId);
		request.setAttribute("lineCd", lineCd);
		request.setAttribute("trtyYy", trtyYy);
		request.setAttribute("shareCd", shareCd);
		
		Map<String, Object> approveParams = new HashMap<String, Object>();
		approveParams.put("user", userId);
		approveParams.put("funcCode", "AP");
		approveParams.put("moduleName", "GIRIS056");
		request.setAttribute("allowApprove", giacModulesService.validateUserFunc3(approveParams));
		
		Map<String, Object> cancelParams = new HashMap<String, Object>();
		cancelParams.put("user", userId);
		cancelParams.put("funcCode", "CP");
		cancelParams.put("moduleName", "GIRIS056");
		request.setAttribute("allowCancel", giacModulesService.validateUserFunc3(cancelParams));
		
		Map<String, Object> distShareParams = new HashMap<String, Object>();
		distShareParams.put("lineCd", lineCd);
		distShareParams.put("shareCd", shareCd);
		distShareParams.put("trtyYy", trtyYy);
		request.setAttribute("distShare", new JSONObject(StringFormatter.escapeHTMLInMap(this.giriIntreatyDAO.getGIISDistShare(distShareParams))));
		
		List<Map<String, Object>> tranTypes = this.giriIntreatyDAO.getTranTypeList();
		request.setAttribute("tranTypeListing", tranTypes);
		
		Date date = new Date();
		DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> dfltBookMap = new HashMap<String, Object>();
		dfltBookMap.put("acceptDate", format.format(date));
		dfltBookMap = this.giriIntreatyDAO.getDfltBookingMonth(dfltBookMap);
		request.setAttribute("dfltAcceptDate", dfltBookMap.get("acceptDate"));
		request.setAttribute("dfltBookingYear", dfltBookMap.get("bookingYear"));
		request.setAttribute("dfltBookingMth", dfltBookMap.get("bookingMth"));
		
		List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING3);
		request.setAttribute("bookingMonthListing", bookingMonths);
		
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("dfltCurrency", giacParamService.getParamValueN("CURRENCY_CD"));
		
		if(intreatyId > 0){
			request.setAttribute("giriIntreaty", new JSONObject(StringFormatter.escapeHTMLInObject(this.giriIntreatyDAO.getGIRIIntreaty(intreatyId))));
			request.setAttribute("giriIntreatyCharges", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.giriIntreatyDAO.getGIRIIntreatyCharges(intreatyId))));
			request.setAttribute("giriIntreatyChargesTG", this.getIntreatyChargesTG(request));
		}else{
			request.setAttribute("giriIntreaty", new JSONObject());
			request.setAttribute("giriIntreatyCharges", new JSONArray());
			request.setAttribute("giriIntreatyChargesTG", new JSONArray());
		}
	}
	
	@Override
	public JSONObject getIntreatyChargesTG(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getGIRIIntreatyChargesTG");
		params.put("intreatyId", request.getParameter("intreatyId"));
		Map<String, Object> intreatyChargesTG = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(intreatyChargesTG));
	}
	
	@Override
	public Integer saveIntreaty(String param, String userId) throws SQLException, Exception{
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("giriIntreaty", JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("giriIntreaty")), userId, GIRIIntreaty.class));
		params.put("addIntreatyCharges", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addIntreatyCharges")), userId, GIRIIntreatyCharges.class));
		params.put("delIntreatyCharges", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delIntreatyCharges")), userId, GIRIIntreatyCharges.class));
		return this.giriIntreatyDAO.saveIntreaty(params);
	}
	
	@Override
	public void showInchargesTax(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, Exception {
		Integer intreatyId = Integer.parseInt(request.getParameter("intreatyId"));
		Integer chargeCd = Integer.parseInt(request.getParameter("chargeCd"));
		request.setAttribute("charge", request.getParameter("charge"));
		request.setAttribute("chargeCd", request.getParameter("chargeCd"));
		request.setAttribute("chargeAmount", request.getParameter("chargeAmount"));
		Map<String, Object> taxParams = new HashMap<String, Object>();
		taxParams.put("intreatyId", intreatyId);
		taxParams.put("chargeCd", chargeCd);
		request.setAttribute("giriInchargesTax", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.giriIntreatyDAO.getGIRIInchargesTax(taxParams))));
		request.setAttribute("giriInchargesTaxTG", this.getInchargesTaxTG(request));
	}
	
	@Override
	public JSONObject getInchargesTaxTG(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getGIRIInchargesTaxTG");
		params.put("intreatyId", request.getParameter("intreatyId"));
		params.put("chargeCd", request.getParameter("chargeCd"));
		Map<String, Object> inchargesTaxTG = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(inchargesTaxTG));
	}
	
	@Override
	public void saveInchargesTax(String param, String userId) throws SQLException, Exception {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("intreatyId", objParams.getInt("intreatyId"));
		params.put("chargeCd", objParams.getInt("chargeCd"));
		params.put("delInchargesTax", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delInchargesTax")), userId, GIRIInchargesTax.class));
		params.put("addInchargesTax", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addInchargesTax")), userId, GIRIInchargesTax.class));
	    this.giriIntreatyDAO.saveInchargesTax(params);
	    this.giriIntreatyDAO.updateIntreatyCharges(params);
	    this.giriIntreatyDAO.updateChargeAmount(params);
	}
	
	@Override
	public void showViewIntreaty(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("intrtySeqNo", request.getParameter("intrtySeqNo"));
		Integer intreatyId = this.giriIntreatyDAO.getIntreatyId2(params);
		
		if(intreatyId > 0){
			request.setAttribute("viewIntreaty", new JSONObject(StringFormatter.escapeHTMLInMap(this.giriIntreatyDAO.getViewIntreaty(intreatyId))));
			Map<String, Object> chargesTG = new HashMap<String, Object>();				
			chargesTG.put("ACTION", "getGIRIIntreatyChargesTG");
			chargesTG.put("intreatyId", intreatyId);
			request.setAttribute("giriIntreatyChargesTG", new JSONObject(StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, chargesTG))));
			request.setAttribute("giriInchargesTaxTG", new JSONArray());
		}else{
			request.setAttribute("viewIntreaty", new JSONObject());
			request.setAttribute("giriIntreatyChargesTG", new JSONArray());
			request.setAttribute("giriInchargesTaxTG", new JSONArray());
			
		}
	}
}
	


