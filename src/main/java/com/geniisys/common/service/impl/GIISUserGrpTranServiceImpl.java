/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISUserGrpTranDAO;
import com.geniisys.common.entity.GIISTransaction;
import com.geniisys.common.entity.GIISUserGrpDtl;
import com.geniisys.common.entity.GIISUserGrpLine;
import com.geniisys.common.entity.GIISUserGrpTran;
import com.geniisys.common.service.GIISUserGrpTranService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;


/**
 * The Class GIISUserGrpTranServiceImpl.
 */
public class GIISUserGrpTranServiceImpl implements GIISUserGrpTranService {

	/** The giis user grp tran dao. */
	private GIISUserGrpTranDAO giisUserGrpTranDAO;
	
	/**
	 * Gets the giis user grp tran dao.
	 * 
	 * @return the giis user grp tran dao
	 */
	public GIISUserGrpTranDAO getGiisUserGrpTranDAO() {
		return giisUserGrpTranDAO;
	}

	/**
	 * Sets the giis user grp tran dao.
	 * 
	 * @param giisUserGrpTranDAO the new giis user grp tran dao
	 */
	public void setGiisUserGrpTranDAO(GIISUserGrpTranDAO giisUserGrpTranDAO) {
		this.giisUserGrpTranDAO = giisUserGrpTranDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpTranService#getGiisUserGrpTranList(int)
	 */
	@Override
	public List<GIISTransaction> getGiisUserGrpTranList(int userGrp) throws SQLException {
		return this.getGiisUserGrpTranDAO().getGiisUserGrpTranList(userGrp);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpTranService#deleteGiisUserGrpTran(com.geniisys.common.entity.GIISUserGrpTran)
	 */
	@Override
	public void deleteGiisUserGrpTran(GIISUserGrpTran userGrpTran)throws SQLException {
		this.getGiisUserGrpTranDAO().deleteGiisUserGrpTran(userGrpTran);
	}
	
	@Override
	public JSONObject getUserGrpTran(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss041UserGrpTrans");
		params.put("userGrp", request.getParameter("userGrp"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void valAddUserGrpTran(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		
		this.getGiisUserGrpTranDAO().valAddUserGrpTran(params);
	}
	
	@Override
	public void saveUserGrpTran(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setTranRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setTranRows")), userId, GIISUserGrpTran.class));
		params.put("delTranRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delTranRows")), userId, GIISUserGrpTran.class));
		params.put("setDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setDtlRows")), userId, GIISUserGrpDtl.class));
		params.put("delDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delDtlRows")), userId, GIISUserGrpDtl.class));
		params.put("setLineRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setLineRows")), userId, GIISUserGrpLine.class));
		params.put("delLineRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delLineRows")), userId, GIISUserGrpLine.class));
		params.put("appUser", userId);
		
		this.getGiisUserGrpTranDAO().saveUserGrpTran(params);
	}
	
}
