/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIParMortgageeDAO;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.pack.entity.GIPIPackMortgagee;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIParMortgageeFacadeServiceImpl.
 */
public class GIPIParMortgageeFacadeServiceImpl implements GIPIParMortgageeFacadeService{

	/** The gipi par mortgagee dao. */
	private GIPIParMortgageeDAO gipiParMortgageeDAO;	
	
	/**
	 * Gets the gipi par mortgagee dao.
	 * 
	 * @return the gipi par mortgagee dao
	 */
	public GIPIParMortgageeDAO getGipiParMortgageeDAO() {
		return gipiParMortgageeDAO;
	}

	/**
	 * Sets the gipi par mortgagee dao.
	 * 
	 * @param gipiParMortgageeDAO the new gipi par mortgagee dao
	 */
	public void setGipiParMortgageeDAO(GIPIParMortgageeDAO gipiParMortgageeDAO) {
		this.gipiParMortgageeDAO = gipiParMortgageeDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParMortgageeFacadeService#deleteGIPIParMortgagee(int, int)
	 */
	@Override
	public void deleteGIPIParMortgagee(int parId, int itemNo)
			throws SQLException {
		this.getGipiParMortgageeDAO().deleteGIPIParMortgagee(parId, itemNo);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParMortgageeFacadeService#getGIPIParMortgagee(int)
	 */
	@Override
	public List<GIPIParMortgagee> getGIPIParMortgagee(int parId)
			throws SQLException {
		List<GIPIParMortgagee> mortgagees = this.getGipiParMortgageeDAO().getGIPIParMortgagee(parId);
		
		for(GIPIParMortgagee m : mortgagees){
			m.setMortgCd(m.getMortgCd().replaceAll(" ", "_"));
		}
		
		return mortgagees;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParMortgageeFacadeService#saveGIPIParMortgagee(com.geniisys.gipi.entity.GIPIParMortgagee)
	 */
	@Override
	public void saveGIPIParMortgagee(GIPIParMortgagee gipiParMortgagee)
			throws SQLException {
		this.getGipiParMortgageeDAO().saveGIPIParMortgagee(gipiParMortgagee);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParMortgageeFacadeService#saveGIPIParMortgagee(java.util.Map)
	 */
	@Override
	public void saveGIPIParMortgagee(Map<String, Object> params)
			throws SQLException {
		String[] itemNos	= (String[]) params.get("itemNos");
		String[] amounts	= (String[]) params.get("amounts");
		String[] mortgCds	= (String[]) params.get("mortgCds");
		
		int parId = Integer.parseInt(params.get("parId").toString());
		String issCd 	= params.get("issCd").toString();		
		
		// save all the mortgagees
		if(itemNos != null){
			List<GIPIParMortgagee> morts = new ArrayList<GIPIParMortgagee>();
			for(int i=0; i < itemNos.length; i++){
				morts.add(new GIPIParMortgagee(parId, issCd,
						Integer.parseInt(itemNos[i]),
						mortgCds[i], 
						new BigDecimal(amounts[i].replaceAll(",", "")),
						null, null,
						params.get("userId").toString()));				
			}
			this.getGipiParMortgageeDAO().setGIPIParMortgagee(morts);
		}		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParMortgageeFacadeService#deleteGIPIParMortgagee(java.util.Map)
	 */
	@Override
	public void deleteGIPIParMortgagee(Map<String, Object> params)
			throws SQLException {
		String[] delItemNos 	= (String[]) params.get("delItemNos");
		String[] delMortgCds	= (String[]) params.get("delMortgCds");
		
		int parId = Integer.parseInt(params.get("parId").toString());
		String issCd 	= params.get("issCd").toString();
		
		if(delItemNos != null){			
			List<GIPIParMortgagee> morts = new ArrayList<GIPIParMortgagee>();
			for(int i=0; i < delItemNos.length; i++){
				morts.add(new GIPIParMortgagee(parId, issCd,
						Integer.parseInt(delItemNos[i]),
						delMortgCds[i], 
						new BigDecimal("0.00"),
						null, null,
						params.get("userId").toString()));				
			}
			this.getGipiParMortgageeDAO().delGIPIParMortgagee(morts);
		}
	}

	@Override
	public List<GIPIParMortgagee> prepareGIPIWMortgageeForInsert(
			JSONArray setRows) throws JSONException {
		List<GIPIParMortgagee> mortgagees = new ArrayList<GIPIParMortgagee>();
		GIPIParMortgagee mort = null;
		JSONObject objMort = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			mort = new GIPIParMortgagee();
			objMort = setRows.getJSONObject(i);			
			mort.setParId(objMort.isNull("parId") ? null : objMort.getInt("parId"));
			mort.setItemNo(objMort.isNull("itemNo") ? null : objMort.getInt("itemNo"));			
			mort.setMortgCd(objMort.isNull("mortgCd") ? null : StringFormatter.unescapeHtmlJava(objMort.getString("mortgCd").replaceAll("_", " ")));			
			mort.setAmount(objMort.isNull("amount") ? null : new BigDecimal(objMort.getString("amount").replaceAll(",", "")));
			mort.setIssCd(objMort.isNull("issCd") ? null : objMort.getString("issCd"));
			mort.setRemarks(objMort.isNull("remarks") ? null : StringFormatter.unescapeHtmlJava(objMort.getString("remarks")));
			mort.setUserId(objMort.isNull("userId") ? null : objMort.getString("userId"));
			mort.setAppUser(objMort.isNull("userId") ? null : objMort.getString("userId"));
			mort.setDeleteSw(objMort.isNull("deleteSw") ? null : objMort.getString("deleteSw")); //kenneth SR 5483 05.26.2016
			mortgagees.add(mort);
			mort = null;
		}
		
		return mortgagees;
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWMortgageeForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> mortgagees = new ArrayList<Map<String, Object>>();
		Map<String, Object> mort = null;
		JSONObject objMort = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			mort = new HashMap<String, Object>();
			objMort = delRows.getJSONObject(i);
			
			mort.put("parId", objMort.isNull("parId") ? null : objMort.getInt("parId"));
			mort.put("itemNo", objMort.isNull("itemNo") ? null : objMort.getInt("itemNo"));
			mort.put("mortgCd", objMort.isNull("mortgCd") ? null : objMort.getString("mortgCd").replaceAll("_", " "));
			
			mortgagees.add(mort);
			mort = null;
		}		
		
		return mortgagees;
	}

	@Override
	public List<GIPIParMortgagee> getGIPIWMortgageeByItemNo(
			HttpServletRequest request) throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		
		List<GIPIParMortgagee> mortgagees = this.getGipiParMortgageeDAO().getGIPIWMortgageeByItemNo(params);
		
		for(GIPIParMortgagee m : mortgagees){
			m.setMortgCd(m.getMortgCd().replaceAll(" ", "_"));
		}
		
		return mortgagees;
	}

	@Override
	public List<GIPIPackMortgagee> getPackParMortgagees(Integer packParId)
			throws SQLException {
		return this.getGipiParMortgageeDAO().getPackParMortgagees(packParId);
	}

	@Override
	public List<GIPIParMortgagee> getGIPIWMortgagee(Integer parId)
			throws SQLException {
		
		List<GIPIParMortgagee> mortgagees = this.getGipiParMortgageeDAO().getGIPIWMortgagee(parId);
		
		//for(GIPIParMortgagee m : mortgagees){
		//	m.setMortgCd(m.getMortgCd().replaceAll(" ", "_"));
		//}
		
		return mortgagees;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void newFormInstance(Map<String, Object> params) throws SQLException, JSONException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		GIISUser USER = (GIISUser) params.get("USER");
		LOVHelper helper = (LOVHelper) params.get("helper");
		
		String issCd = request.getParameter("issCd");//par.getIssCd();
		int parId = Integer.parseInt(request.getParameter("parId")== null ? "0" : request.getParameter("parId"));
		int itemNo = Integer.parseInt(request.getParameter("itemNo"));
		
		String[] args = {String.valueOf(parId), issCd};
		List<GIPIParMortgagee> mortgagees = null;
		List<LOV> mortgageeList = null;			
		
		if(itemNo > 0){
			mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING_POLICY, args);
			mortgagees = this.getGipiParMortgageeDAO().getGIPIParMortgagee(parId);
		}else if(itemNo == 0){
			Map<String, Integer> mortgMap = new HashMap<String, Integer>();
			mortgMap.put("parId", parId);
			mortgMap.put("itemNo", itemNo);
			
			mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING_ITEM, args);					
			mortgagees = this.getGipiParMortgageeDAO().getGIPIWMortgageeByItemNo(mortgMap);
		}
		
		Map<String, Object> tgParams = new HashMap<String, Object>();
		
		tgParams.put("ACTION", "getGIPIWMortgageeTableGrid");
		tgParams.put("parId", parId);
		tgParams.put("itemNo", itemNo);
		//tgParams.put("pageSize", 5);
		
		Map<String, Object> tgMortgagees = TableGridUtil.getTableGrid(request, tgParams);	//changed to getTableGrid Gzelle 02032015
		tgParams.put("allRecords", (List<GIPIParMortgagee>) StringFormatter.escapeHTMLInList(mortgagees));
		request.setAttribute("tgMortgagees", new JSONObject(tgMortgagees));
		
		request.setAttribute("parId", parId);
		//request.setAttribute("mortgagees", mortgagees);
		//request.setAttribute("objMortgagees", new JSONArray(mortgagees));
		request.setAttribute("mortgageeListing", mortgageeList);
		request.setAttribute("itemNo", itemNo);
		request.setAttribute("userId", USER.getUserId());
		//request.setAttribute("fromSave", params.get("fromSave") != null ? "Y" : "N");
		
	}	
}
