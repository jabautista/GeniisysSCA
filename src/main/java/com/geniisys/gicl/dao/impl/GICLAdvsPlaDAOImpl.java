package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLAdvsPlaDAO;
import com.geniisys.gicl.entity.GICLAdvsPla;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLAdvsPlaDAOImpl implements GICLAdvsPlaDAO{

	private Logger log = Logger.getLogger(GICLAdvsPlaDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String cancelPLA(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try{
			log.info("Cancel PLA : "+params);
			this.sqlMapClient.update("cancelPLA", params);
		}catch(Exception e) {
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		} 
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String generatePLA(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			
			log.info("Generating PLA...");
			String clmRiGrp = (String) this.getSqlMapClient().queryForObject("getGIACParamValueN2", "CLM_RI_GRP");
			
			if (clmRiGrp == null){
				message = "No CLM_RI_GRP parameter found in giac parameter.";
				log.info(message);
				throw new SQLException(message);
			}
			
			String vHistId = null;
			for (Map<String, Object> gen : rows){
				if (vHistId == null){
					vHistId = ","+gen.get("clmResHistId")+",";
				}else{
					vHistId = vHistId+","+gen.get("clmResHistId")+",";
				} 
			}
			
			System.out.println("vHistId : "+vHistId);
			params.put("histId", vHistId);
			
			if ("1".equals(clmRiGrp)){
				System.out.println("Claim PLA grp 1");
				this.getSqlMapClient().update("clmPlaGrp1", params);
			}else if ("2".equals(clmRiGrp)){
				System.out.println("Claim PLA grp 1A");
				this.getSqlMapClient().update("clmPlaGrp1A", params);
			}
			this.getSqlMapClient().executeBatch();
			
			for (Map<String, Object> gen : rows){
				System.out.println("Generating PLA details : "+gen);
				this.getSqlMapClient().update("generatePLA", gen);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "SUCCESS" ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();	
		}
		return message;
	}

	@Override
	public void updatePrintSwPla(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("updatePrintSwPla", params);
	}
	
	@Override
	public void updatePrintSwPla2(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("updatePrintSwPla2", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String savePreliminaryLossAdv(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Preliminary Loss Advice.");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLAdvsPla> setRows = (List<GICLAdvsPla>) params.get("setRows");
			
			for (GICLAdvsPla set: setRows){
				log.info("Insert/update pla : "+set.getPlaId()+"-"+set.getGrpSeqNo());
				this.sqlMapClient.insert("setGiclAdvsPla", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Preliminary Loss Advice.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLAdvsPla> getAllPlaDetails(Map<String, Object> params)
			throws SQLException {
		return (List<GICLAdvsPla>) StringFormatter.escapeHTMLJavascriptInList(this.getSqlMapClient().queryForList("getAllPlaDetails", params));
	}
	
}
