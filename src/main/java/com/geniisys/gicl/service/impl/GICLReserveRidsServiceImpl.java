/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Apr 13, 2012
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLReserveRidsDAO;
import com.geniisys.gicl.service.GICLReserveRidsService;
import com.seer.framework.util.StringFormatter;

public class GICLReserveRidsServiceImpl implements GICLReserveRidsService {

	private GICLReserveRidsDAO giclReserveRidsDAO;
	private Logger log = Logger.getLogger(GICLReserveRidsService.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLReserveRidsService#getReserveRidsGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getReserveRidsGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		log.info("get reserve rids grid");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("itemNo", request.getParameter("itemNo")); 
		params.put("histSeqNo", request.getParameter("histSeqNo"));
		
		// added more parameters - irwin 6.26.2012
		params.put("clmResHistId", request.getParameter("clmResHistId"));
		params.put("clmDistNo", request.getParameter("clmDistNo")); 
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		
		System.out.println("claimId- " + request.getParameter("claimId"));
		System.out.println("line cd: " + request.getParameter("lineCd"));
		System.out.println("item No: " + request.getParameter("itemNo"));
		System.out.println("histseq No: " + request.getParameter("histSeqNo"));
		
		params.put("ACTION", "getResRidsGrid");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("reserveRidsTG", grid);
		request.setAttribute("object", grid);
	}

	public void setGiclReserveRidsDAO(GICLReserveRidsDAO giclReserveRidsDAO) {
		this.giclReserveRidsDAO = giclReserveRidsDAO;
	}

	public GICLReserveRidsDAO getGiclReserveRidsDAO() {
		return giclReserveRidsDAO;
	}
}