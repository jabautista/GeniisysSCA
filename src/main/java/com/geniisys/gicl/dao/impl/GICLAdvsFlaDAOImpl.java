package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLAdvsFlaDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLAdvsFlaDAOImpl implements GICLAdvsFlaDAO{
	private Logger log = Logger.getLogger(GICLAdvsFlaDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public String generateFLA(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			String clmRiGrp = (String) this.getSqlMapClient().queryForObject("getGIACParamValueN2", "CLM_RI_GRP");
			
			if (clmRiGrp == null){
				message = "No CLM_RI_GRP parameter found in giac parameter.";
				log.info(message);
				throw new SQLException(message);
			}
			
			String vAdvice = null;
			for (Map<String, Object> fla : rows){
				if (vAdvice == null){
					vAdvice = ","+fla.get("adviceId")+",";
				}else{
					vAdvice = vAdvice+","+fla.get("adviceId")+",";
				}
			}
			params.put("vAdvice", vAdvice);
			
			Integer vAdvFlaId = (Integer) this.getSqlMapClient().queryForObject("getAdvFlaId");
			params.put("vAdvFlaId", vAdvFlaId);
			
			if ("1".equals(clmRiGrp)){
				System.out.println("Claim FLA Grp 1");
				this.getSqlMapClient().update("clmFlaGrp1", params);
			}else if ("2".equals(clmRiGrp)){
				System.out.println("Claim FLA Grp 1A");
				this.getSqlMapClient().update("clmFlaGrp1A", params);
			}
			this.getSqlMapClient().executeBatch();
			
			for (Map<String, Object> fla : rows){
				System.out.println("Generating FLA details : "+fla);
				params.put("adviceId", fla.get("adviceId"));
				this.getSqlMapClient().update("generateFla", params);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("populateAdvsFlaType", params);
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
	public Map<String, Object> cancelFla(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("cancelFla", params);
		return params;
	}

	@Override
	public void updateFla(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("updateFla", params);
	}

	@Override
	public Integer getAdvFlaId() throws SQLException {
		return (Integer)this.getSqlMapClient().queryForObject("getAdvFlaId");
	}

	@Override
	public String validatePdFla(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePdFla", params);
	}

	@Override
	public void updateFlaPrintSw(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("updateFlaPrintSw", params);
	}

}
