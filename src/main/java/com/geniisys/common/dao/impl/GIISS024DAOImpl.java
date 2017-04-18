package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISS024DAO;
import com.geniisys.common.entity.GIISCity;
import com.geniisys.common.entity.GIISProvince;
import com.geniisys.common.entity.GIISRegion;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISS024DAOImpl implements GIISS024DAO{
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIISS024DAOImpl.class);

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	} 
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss024(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();

			log.info("*****Saving GIISRegion...");
			List<GIISRegion> delList = (List<GIISRegion>) params.get("delGIISRegion");
			for(GIISRegion d: delList){
				this.sqlMapClient.update("delGIISRegion", d.getRegionCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRegion> setList = (List<GIISRegion>) params.get("setGIISRegion");
			for(GIISRegion s: setList){
				this.sqlMapClient.update("setGIISRegion", s);
			}
			this.sqlMapClient.executeBatch();
			log.info("finished.");
			
			log.info("*****Saving GIISProvince...");
			List<GIISProvince> delList2 = (List<GIISProvince>) params.get("delGIISProvince");
			for(GIISProvince d: delList2){
				this.sqlMapClient.update("delGIISProvince", d.getProvinceCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISProvince> setList2 = (List<GIISProvince>) params.get("setGIISProvince");
			for(GIISProvince s: setList2){
				this.sqlMapClient.update("setGIISProvince", s);
			}
			this.sqlMapClient.executeBatch();
			log.info("finished.");
			
			log.info("*****Saving GIISCity...");
			List<GIISCity> delList3 = (List<GIISCity>) params.get("delGIISCity");
			for(GIISCity d: delList3){
				/*Map<String, Object> cityParams = new HashMap<String, Object>();
				cityParams.put("cityCd", d.getCityCd());
				cityParams.put("provinceCd", d.getProvinceCd());*/
				this.sqlMapClient.update("delGIISCity",d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISCity> setList3 = (List<GIISCity>) params.get("setGIISCity");
			for(GIISCity s: setList3){
				this.sqlMapClient.update("setGIISCity", s);
			}
			this.sqlMapClient.executeBatch();
			log.info("finished.");
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteGiiss024", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGiiss024", params);		
	}
}
