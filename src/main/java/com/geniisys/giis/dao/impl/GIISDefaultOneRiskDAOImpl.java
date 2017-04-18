package com.geniisys.giis.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giis.dao.GIISDefaultOneRiskDAO;
import com.geniisys.giis.entity.GIISDefaultDist;
import com.geniisys.giis.entity.GIISDefaultDistDtl;
import com.geniisys.giis.entity.GIISDefaultDistGroup;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISDefaultOneRiskDAOImpl implements GIISDefaultOneRiskDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddDefaultDistRec(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valAddDefaultDistRec", params);
	}

	@Override
	public void valDelDefaultDistRec(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valDelDefaultDistRec", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss065(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			Integer defaultNo = null;
			Integer newDefaultNo = null;
			Integer defNo = (Integer) params.get("defaultNo"); //Added by Jerome 10.17.2016 SR 5552
			String lineCd = (String) params.get("lineCd");
			
			List<GIISDefaultDist> delList = (List<GIISDefaultDist>) params.get("delGIISDefaultDist");
			for(GIISDefaultDist d : delList){
				this.sqlMapClient.update("delGIISDefaultDist", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISDefaultDist> setList = (List<GIISDefaultDist>) params.get("setGIISDefaultDist");
			for(GIISDefaultDist s: setList){
				if(s.getDefaultNo() == null){
					newDefaultNo = (Integer) this.getSqlMapClient().queryForObject("getGiiss065DefaultNo");
					s.setDefaultNo(newDefaultNo);
				}
				
				if(s.getChildTag().toString().equals("Y")){
					defaultNo = s.getDefaultNo();
				}
				
				lineCd = s.getLineCd();
				this.sqlMapClient.update("setGIISDefaultDist", s);
			}
			
			List<GIISDefaultDistGroup> delList2 = (List<GIISDefaultDistGroup>) params.get("delGIISDefaultDistGroup");
			for(GIISDefaultDistGroup d2 : delList2){
				this.sqlMapClient.update("delGIISDefaultDistGroup", d2);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
			List<GIISDefaultDistGroup> setList2 = (List<GIISDefaultDistGroup>) params.get("setGIISDefaultDistGroup");
			for(GIISDefaultDistGroup s2: setList2){
				if(s2.getChildTag().toString().equals("Y")){
					s2.setDefaultNo(defaultNo);
				};
				this.sqlMapClient.update("setGIISDefaultDistGroup", s2);
			}
			
			List<GIISDefaultDistDtl> delList3 = (List<GIISDefaultDistDtl>) params.get("delGIISDefaultDistDtl");
			for(GIISDefaultDistDtl d3 : delList3){
				this.sqlMapClient.update("delGIISDefaultDistDtl", d3);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISDefaultDistDtl> setList3 = (List<GIISDefaultDistDtl>) params.get("setGIISDefaultDistDtl");
			
		    if (setList2.isEmpty()){ //Added by Jerome 09.13.2016 SR 5552
		    	for(GIISDefaultDistDtl s3: setList3) {
					s3.setLineCd(lineCd);
                
					this.sqlMapClient.update("setGIISDefaultDistDtl", s3);
			    }
		    } else {
			for(GIISDefaultDistGroup distGrp : setList2){	
				for(GIISDefaultDistDtl s3: setList3) {
					s3.setDefaultNo(defNo == 0 ? newDefaultNo : defNo);
					s3.setShareCd(distGrp.getShareCd() == null ? 0 : distGrp.getShareCd());
					s3.setSharePct(distGrp.getSharePct() == null ? new BigDecimal("0") : distGrp.getSharePct());
					s3.setLineCd(lineCd);
                
					this.sqlMapClient.update("setGIISDefaultDistDtl", s3);
			    }
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		   }
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valExistingDistPerilRecord(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valExistingDistPerilRecord", params);
	}

	@Override
	public void valAddDefaultDistGroupRec(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valAddDefaultDistGroupRec", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateSaveExist(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateSaveExist", params);
	}

	@Override
	public Integer getMaxSequencNo(Integer defaultNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("defaultNo", defaultNo);
		this.getSqlMapClient().update("getMaxSequenceNo", params);
		return (Integer) params.get("sequence");
	}
}
