package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPILoadHistDAO;
import com.geniisys.gipi.entity.GIPILoadHist;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPILoadHistDAOImpl implements GIPILoadHistDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIPILoadHistDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPILoadHist> getGipiLoadHist() throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPILoadHist");
	}

	@Override
	public String createToPar(String uploadNo, Integer parId, Integer itemNo,
			String polId, String lineCd, String issCd, String userId)
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, String> paramsIns = new HashMap<String, String>();
			paramsIns.put("uploadNo", uploadNo);
			paramsIns.put("parId", parId.toString());
			paramsIns.put("itemNo", itemNo.toString());
			paramsIns.put("polId", polId.toString());
			paramsIns.put("appUser", userId);
			System.out.println("createToPar - uploadNo:"+uploadNo.toString()+",parId:"+parId.toString()+",itemNo:"+itemNo.toString());
			this.sqlMapClient.update("createToPar", paramsIns);
			this.getSqlMapClient().executeBatch();
			
			Map<String, String> recgrp = new HashMap<String, String>();
			recgrp.put("parId", parId.toString());
			recgrp.put("lineCd", lineCd);
			recgrp.put("itemNo", itemNo.toString());
			this.sqlMapClient.update("insertRecgrpWitemUpload", recgrp);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> addParStatus = new HashMap<String, Object>();
			addParStatus.put("parId", parId);
			addParStatus.put("lineCd", lineCd);
			addParStatus.put("issCd", issCd);
			addParStatus.put("invoiceSw", "N");
			addParStatus.put("itemGrp", null);
			this.sqlMapClient.update("addParStatusNo2", addParStatus);
			this.getSqlMapClient().executeBatch();
			
			Map<String, String> inv = new HashMap<String, String>();
			inv.put("parId", parId.toString());
			inv.put("lineCd", lineCd);
			inv.put("issCd", issCd);
			inv.put("userId", userId);
			this.sqlMapClient.update("createInvoiceItemUpload", inv);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			message = "SQLException occured...<br />"+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println(message);
		}	
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getUploadedEnrollees(Map<String, Object> params)  //created by christian 04/29/2013
			throws SQLException {
		return this.getSqlMapClient().queryForList("getUploadedEnrollees", params);
	}

}
