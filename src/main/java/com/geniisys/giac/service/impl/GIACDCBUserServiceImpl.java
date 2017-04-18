/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDCBUserDAO;
import com.geniisys.giac.entity.GIACDCBUser;
import com.geniisys.giac.service.GIACDCBUserService;

public class GIACDCBUserServiceImpl implements GIACDCBUserService{
	
	/** The gipi par item dao. */
	private GIACDCBUserDAO giacDCBUserDAO;
	
	/**
	 * @return the giacDCBUserDAO
	 */
	public GIACDCBUserDAO getGiacDCBUserDAO() {
		return giacDCBUserDAO;
	}

	/**
	 * @param giacDCBUserDAO the giacDCBUserDAO to set
	 */
	public void setGiacDCBUserDAO(GIACDCBUserDAO giacDCBUserDAO) {
		this.giacDCBUserDAO = giacDCBUserDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDCBUserService#getDCBCashierCd(java.lang.String, java.lang.String)
	 */
	@Override
	public GIACDCBUser getDCBCashierCd(String fundCd, String branchCd, String userId) throws SQLException {
		return giacDCBUserDAO.getDCBCashierCd(fundCd, branchCd, userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDCBUserService#getValidUSerInfo(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, Object> getValidUSerInfo(String orTag, String orCancel, String fundCd, String branchCd, String userId)
			throws SQLException {
		Map<String, Object> result = new HashMap<String, Object>();
		String mesg = "";	
		String word = "";
		String isValid = "Y";
		String module = "";
		Calendar cal = Calendar.getInstance();
		Date currentDate = cal.getTime();
		System.out.println("date: " + currentDate);
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
		
		GIACDCBUser user = this.getGiacDCBUserDAO().getValidUSerInfo(fundCd, branchCd, userId);
		if(user == null) {
			isValid = "N";
			if(orCancel.equals("X") && orTag.equals("X")) {
				mesg = "You are not authorized to issue an Acknowledgement Receipt for this company/branch.";
			} else if(orCancel.equals("Y") && orTag.equals("C")) {
				mesg = "You are not authorized to cancel an O.R. for this company/branch.";
			} else {
				mesg = "You are not authorized to issue an O.R. for this company/branch.";
			}
		} else {
			if(orCancel.equals("X") && orTag.equals("X")) {
				word = "Acknowledgement Receipt";
				module = "GIACS090";
			} else {
				word = "O.R.";
				module = "GIACS001";
			}
						
			if((user.getValidTag()).toUpperCase().equals("N")) {
				isValid = "N";
				mesg = "You are not authorized to issue an " + word + 
						" for this company/branch.";
			} else {
				if(user.getEffectivityDt().after(currentDate)) {
					isValid = "N";
					mesg = "Your authority to process an " + word + 
							" for this company/branch starts on " + df.format(user.getEffectivityDt()) + ".";
				} else if(user.getExpiryDt() != null) {
					if(user.getExpiryDt().before(currentDate)) {
					isValid = "N";
					mesg = "Your authority to process an " + word +
							"for this company/branch has expired last " +
							df.format(user.getExpiryDt()) + ".";
					}
				}
			}
		}
		System.out.println("values for result map: " + isValid + " / " + mesg);
		result.put("module", module);
		result.put("validity", isValid);
		result.put("message", mesg);
		return result;
	}

	@Override
	public String checkIfDcbUserExists(String userId) throws SQLException {
		return this.getGiacDCBUserDAO().checkIfDcbUserExists(userId);
	}

	@Override
	public GIACDCBUser getValidUSerInfo(String fundCd, String branchCd,	String userId) throws SQLException {
		return this.getGiacDCBUserDAO().getValidUSerInfo(fundCd, branchCd, userId);
	}
	
	@Override
	public JSONObject showGiacs319(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs319RecList");	
		params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gibrFundCd", request.getParameter("gibrFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("cashierCd", request.getParameter("cashierCd"));
		params.put("dcbUserId", request.getParameter("dcbUserId"));
		this.giacDCBUserDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiacs319(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACDCBUser.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACDCBUser.class));
		params.put("appUser", userId);
		this.giacDCBUserDAO.saveGiacs319(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gibrFundCd", request.getParameter("gibrFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("cashierCd", request.getParameter("cashierCd"));
		params.put("dcbUserId", request.getParameter("dcbUserId"));
		this.giacDCBUserDAO.valAddRec(params);
	}

}
