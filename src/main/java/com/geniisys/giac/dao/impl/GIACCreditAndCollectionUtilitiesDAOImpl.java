/**
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACCreditAndCollectionUtilitiesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author steven
 *
 */
public class GIACCreditAndCollectionUtilitiesDAOImpl implements GIACCreditAndCollectionUtilitiesDAO{
	
	private Logger log = Logger.getLogger(GIACCreditAndCollectionUtilitiesDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

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
	public List<Map<String, Object>> getAllCancelledPol(
			Map<String, Object> params) throws SQLException, Exception {
		log.info("Getting All Records in Payment Processing for Cancelled Policies");
		log.info("Parameters: " + params);
		return getSqlMapClient().queryForList("getGIACS412AllRecord",params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void processCancelledPol(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> paramList = (List<Map<String, Object>>) params.get("cancelledPol");
			List<Map<String, Object>> tempList = new ArrayList<Map<String, Object>>();
			
			if(paramList != null){
				for (Map<String, Object> param : paramList) {
					if(tempList != null){
						tempLoop:for (Map<String, Object> map : tempList) {
							if (param.get("issCd").equals(map.get("issCd"))) {
								param.put("tranId", map.get("tranId"));
								break tempLoop;
							}
						}
					}
					this.getSqlMapClient().insert("processCancelledPol",param);
					
					Map<String, Object> tempMap = new HashMap<String, Object>();
					tempMap.put("issCd", param.get("issCd"));
					tempMap.put("tranId", param.get("tranId"));
					tempList.add(tempMap);
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void ageBills(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("ageBills", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().executeBatch();
			//this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")	// start FGIC SR-4266 : shan 05.21.2015
	public List<Map<String, Object>> getPoliciesForReverseByParam(Map<String, Object> params) throws SQLException{
		log.info("getPoliciesForReverseByParam: " + params.toString());
		return (List<Map<String, Object>>) this.sqlMapClient.queryForList("getPoliciesForReverseByParam", params);
		//return (List<Map<String, Object>>) this.sqlMapClient.queryForList("getGIACS412PoliciesForReverse", params);
	}
	
	@SuppressWarnings("unchecked")
	public void reverseProcessedPolicies(Map<String, Object> params) throws SQLException, Exception{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> taggedRecords = (List<Map<String, Object>>) params.get("taggedRecords");
			
			for (Map<String, Object> pol : taggedRecords){
				pol.put("userId", params.get("userId"));
				System.out.println("Reversing Processed Policy : " + params.toString());
				this.getSqlMapClient().update("reverseProcessedPolicies", pol);
			}
			
			this.getSqlMapClient().executeBatch();
			//this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}	// end FGIC SR-4266 : shan 05.21.2015
	
}
