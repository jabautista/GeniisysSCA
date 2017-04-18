package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.dao.GIRIFrpsRiDAO;
import com.geniisys.giri.entity.GIRIFrpsRi;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIFrpsRiDAOImpl implements GIRIFrpsRiDAO{
	
	private Logger log = Logger.getLogger(GIRIFrpsRiDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIFrpsRi> getGIRIFrpsRiList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting GIRI_Frps_Ri list...");
		return this.getSqlMapClient().queryForList("getGIRIFrpsRi", params);
	}
	
	@Override
	public Map<String, Object> checkBinderGiuts004(Map<String, Object> params)
		throws SQLException {
		this.getSqlMapClient().update("checkBinderGiuts004", params);
		Debug.print(params);
		return params ;
	}
	
	@Override
	public Map<String, Object> performReversalGiuts004(Map<String, Object> params)
		throws SQLException {
		this.getSqlMapClient().update("performReversalGiuts004", params);
		Debug.print(params);
		return params ;
	}

	@Override
	public String reversePackageBinder(Map<String, Object> params)
			throws SQLException {
		log.info("Start of reversing package binder...");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//List<GIRIFrpsRi> setRows = (List<GIRIFrpsRi>) params.get("setRows");
			String packageBinders[] = params.get("packageBinders").toString().split(",");
			
			for(String packBinderId: packageBinders){
				log.info("Reversing package binders: " + packBinderId);
				params.put("packBinderId", packBinderId);
				this.getSqlMapClient().update("reversePackageBinder", params);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of reversing package binder...");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String generatePackageBinder(Map<String, Object> params)
			throws Exception {
		log.info("Start of generating package binder...");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("generatePackageBinder", params);
							
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of generating package binder...");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void groupBinders(Map<String, Object> params)
			throws SQLException {
		log.info("Start of grouping binders...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer generatedBinderId = (Integer) this.sqlMapClient.queryForObject("getBinderId");
			this.getSqlMapClient().executeBatch();
			List<Map<String, Object> > setRows = (List<Map<String, Object> >) params.get("setRows");
			
			log.info("GENERATED BINDER ID: "+generatedBinderId);
			Map<String, Object> createBinderParams = new HashMap<String, Object>();
			Map<String, Object> createBinderPerilParams = new HashMap<String, Object>();
			for (Map<String, Object> map : setRows) {
				log.info("Grouping Binder : "+map.get("lineCd")+"-"+map.get("frpsYy")+"-"+map.get("frpsSeqNo")+"-"+map.get("riCd"));
				System.out.println(map);
				map.put("binderId", generatedBinderId);
				this.getSqlMapClient().update("updateMasterBndrId", map);
				createBinderParams.put("lineCd", map.get("lineCd"));
				createBinderParams.put("riCd", map.get("riCd"));
				
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("Creating Binder with Binder id: "+generatedBinderId);
			createBinderParams.put("binderId", generatedBinderId);
			createBinderParams.put("userId", params.get("userId"));
			System.out.println("create Binder params:" +createBinderParams );
			this.getSqlMapClient().update("createBinder", createBinderParams);
			this.getSqlMapClient().executeBatch();
			
			log.info("Creating Binder Peril");
			createBinderPerilParams.put("binderId", generatedBinderId);
			System.out.println(createBinderPerilParams);
			this.getSqlMapClient().update("createBinderPerilGiris053", createBinderPerilParams);

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of grouping binder...");
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void ungroupBinders(Map<String, Object> params)
			throws SQLException {
		log.info("Start of ungrouping binders...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> ungrpBndrsParams = new HashMap<String, Object>();
			ungrpBndrsParams.put("masterBndrId", params.get("masterBndrId"));
			ungrpBndrsParams.put("user", params.get("user"));
			
			
			this.getSqlMapClient().update("ungroupBinders", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of ungrouping binders...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Integer getOutFaculTotAmtGIUTS004(Map<String, Object> params) throws SQLException {
		Debug.print(params);
		Integer outFaculTotAmt = (Integer) this.sqlMapClient.queryForObject("getOutFaculTotAmtGIUTS004", params);
		System.out.println("outFaculTotAmt: " + outFaculTotAmt);
		return outFaculTotAmt;
	}

	@Override
	public String checkBinderWithClaimsGIUTS004(Map<String, Object> params)
			throws SQLException {
		Debug.print(params);
		return (String) this.sqlMapClient.queryForObject("checkBinderWithClaimsGIUTS004", params);
	}

}
