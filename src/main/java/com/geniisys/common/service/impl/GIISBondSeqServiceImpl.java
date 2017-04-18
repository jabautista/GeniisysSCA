package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISBondSeqDAO;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISBondSeqService;

public class GIISBondSeqServiceImpl implements GIISBondSeqService {

	private GIISBondSeqDAO giisBondSeqDAO;
	private Logger log = Logger.getLogger(GIISBondSeqServiceImpl.class);
	
	public GIISBondSeqDAO getGiisBondSeqDAO() {
		return giisBondSeqDAO;
	}

	public void setGiisBondSeqDAO(GIISBondSeqDAO giisBondSeqDao) {
		this.giisBondSeqDAO = giisBondSeqDao;
	}

	@Override
	public Integer generateBondSeq(HttpServletRequest request, Integer noOfSequence, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd").toUpperCase());
		params.put("sublineCd", request.getParameter("sublineCd").toUpperCase());
		params.put("moduleId", request.getParameter("moduleId").toUpperCase());
		params.put("generatedBondSeq", new Integer(0));
		params.put("userId", USER.getUserId());
		log.info("Generating Bond Sequence...");
		log.info("No. of sequence: " + noOfSequence);
		log.info("params: " + params);
		this.giisBondSeqDAO.generateBondSeq(params, noOfSequence);
		log.info("Finished generating Bond Sequence");
		return (Integer) params.get("generatedBondSeq");
	}

}
