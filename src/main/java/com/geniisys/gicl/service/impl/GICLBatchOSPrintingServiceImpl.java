/**
 * 
 */
package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLBatchOSPrintingDAO;
import com.geniisys.gicl.service.GICLBatchOSPrintingService;

/**
 * @author steven
 *
 */
public class GICLBatchOSPrintingServiceImpl implements GICLBatchOSPrintingService{
	
	private GICLBatchOSPrintingDAO giclBatchOSPrintingDAO;

	/**
	 * @return the giclBatchOSPrintingDAO
	 */
	public GICLBatchOSPrintingDAO getGiclBatchOSPrintingDAO() {
		return giclBatchOSPrintingDAO;
	}

	/**
	 * @param giclBatchOSPrintingDAO the giclBatchOSPrintingDAO to set
	 */
	public void setGiclBatchOSPrintingDAO(GICLBatchOSPrintingDAO giclBatchOSPrintingDAO) {
		this.giclBatchOSPrintingDAO = giclBatchOSPrintingDAO;
	}

	@Override
	public JSONObject showBatchOSPrinting(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getGICLS207Record");				
		params.put("userId", USER.getUserId());
		Map<String, Object> jsonBatchOSMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBatchOS = new JSONObject(jsonBatchOSMap);
		return jsonBatchOS;
	}

	@Override
	public List<Map<String, Object>> getBatchOSRecord(HttpServletRequest request,
			GIISUser USER) throws SQLException , Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("action", request.getParameter("action"));
		params.put("userId", USER.getUserId());
		params.put("tranId", request.getParameter("tranId"));
		
		return getGiclBatchOSPrintingDAO().getBatchOSRecord(params);
	}

	@Override
	public void extractOSDetail(HttpServletRequest request, GIISUser uSER)
			throws SQLException, Exception {
		getGiclBatchOSPrintingDAO().extractOSDetail(request.getParameter("tranId"));
	}
}
