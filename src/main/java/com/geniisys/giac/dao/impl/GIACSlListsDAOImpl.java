package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACSlListsDAO;
import com.geniisys.giac.entity.GIACSlLists;
import com.geniisys.giac.entity.GIACSlLists;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIACSlListsDAOImpl implements GIACSlListsDAO {

	/** The logger **/
	private static Logger log = Logger.getLogger(GIACSlListsDAOImpl.class);
	
	/** The Sql Map Client **/
	private SqlMapClient sqlMapClient;	

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACSlListsDAO#getSlListingByWhtaxId(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACSlLists> getSlListingByWhtaxId(Integer whtaxId, String keyword)
			throws SQLException {
		log.info("");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("whtaxId", whtaxId);
		params.put("keyword", keyword);
		return this.getSqlMapClient().queryForList("getSlListingByWhtaxId", params);
	}
	
	public String getSapIntegrationSw() throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getSapIntegrationSwGiacs309");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs309(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACSlLists> delList = (List<GIACSlLists>) params.get("delRows");
			for(GIACSlLists d: delList){
				System.out.println("========== BEFORE:: slTypeCd: " + d.getSlTypeCd() +", slCd: " + d.getSlCd() + ", fundCd: "+d.getFundCd());	
				d.setSlTypeCd(StringFormatter.unescapeHTML2(d.getSlTypeCd()));
				d.setFundCd(StringFormatter.unescapeHTML2(d.getFundCd()));
				System.out.println("========== DELETE:: slTypeCd: " + d.getSlTypeCd() +", slCd: " + d.getSlCd() + ", fundCd: "+d.getFundCd());
				this.sqlMapClient.update("delSlLists", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACSlLists> setList = (List<GIACSlLists>) params.get("setRows");
			for(GIACSlLists s: setList){
				this.sqlMapClient.update("setSlLists", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddSlLists", params);		
	}
}
