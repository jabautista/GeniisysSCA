package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.giac.dao.GIACCloseGLDAO;
import com.geniisys.giac.service.GIACCloseGLService;

public class GIACCloseGLServiceImpl implements GIACCloseGLService{
	
	private GIACCloseGLDAO giacCloseGLDAO;

	/**
	 * @return the giacCloseGLDAO
	 */
	public GIACCloseGLDAO getGiacCloseGLDAO() {
		return giacCloseGLDAO;
	}

	/**
	 * @param giacCloseGLDAO the giacCloseGLDAO to set
	 */
	public void setGiacCloseGLDAO(GIACCloseGLDAO giacCloseGLDAO) {
		this.giacCloseGLDAO = giacCloseGLDAO;
	}

	@Override
	public void showCloseGL(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		request.setAttribute("glNo", getGiacCloseGLDAO().getCloseGLParams("getGLNo"));
		request.setAttribute("financeEnd", getGiacCloseGLDAO().getCloseGLParams("getFinanceEnd"));
		request.setAttribute("fiscalEnd", getGiacCloseGLDAO().getCloseGLParams("getFiscalEnd"));
		System.out.println("steven "+ getGiacCloseGLDAO().getModuleId().toString());
		request.setAttribute("jsonModuleObj", new JSONObject(getGiacCloseGLDAO().getModuleId()));
	}

	@Override
	public Map<String, Object> closeGenLedger(HttpServletRequest request,
			String userId) throws SQLException, Exception {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("tranYear", request.getParameter("tranYear"));
		params.put("tranMonth", request.getParameter("tranMonth"));
		params.put("glNo", request.getParameter("glNo"));
		params.put("financeEnd", request.getParameter("financeEnd"));
		params.put("fiscalEnd", request.getParameter("fiscalEnd"));
		params.put("msg", null);
		return getGiacCloseGLDAO().closeGenLedger(params);
	}

	@Override
	public Map<String, Object> closeGenLedgerConfirmation(
			HttpServletRequest request, String userId) throws SQLException, Exception {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("tranYear", request.getParameter("tranYear"));
		params.put("tranMonth", request.getParameter("tranMonth"));
		params.put("glNo", request.getParameter("glNo"));
		params.put("financeEnd", request.getParameter("financeEnd"));
		params.put("fiscalEnd", request.getParameter("fiscalEnd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("genType", request.getParameter("genType"));
		params.put("userId", userId);
		params.put("msg", null);
		return getGiacCloseGLDAO().closeGenLedgerConfirmation(params);
	}
}
