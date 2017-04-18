/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWMcAccDAO;
import com.geniisys.gipi.entity.GIPIWMcAcc;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWMcAccDAOImpl.
 */
public class GIPIWMcAccDAOImpl implements GIPIWMcAccDAO{


	private Logger log = Logger.getLogger(GIPIParMortgageeDAOImpl.class);

	/** The sql map client. */

	private SqlMapClient sqlMapClient;
	
	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWMcAccDAO#getGipiWMcAcc(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWMcAcc> getGipiWMcAcc(int parId,int itemNo) throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		return this.getSqlMapClient().queryForList("getGIPIWMcAcc", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWMcAccDAO#saveGipiWMcAcc(com.geniisys.gipi.entity.GIPIWMcAcc)
	 */
	@Override
	public void saveGipiWMcAcc(GIPIWMcAcc gipiWMcAcc) throws SQLException {
		this.sqlMapClient.insert("setGipiWMcAcc", gipiWMcAcc);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWMcAccDAO#deleteGipiWMcAcc(com.geniisys.gipi.entity.GIPIWMcAcc)
	 */
	@Override
	public void deleteGipiWMcAcc(GIPIWMcAcc gipiWMcAcc) throws SQLException {
		this.sqlMapClient.delete("deleteGipiWMcAcc", gipiWMcAcc);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWMcAccDAO#getGipiWMcAccbyParId(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWMcAcc> getGipiWMcAccbyParId(int parId) throws SQLException {		
		return this.sqlMapClient.queryForList("getGIPIWMcAccByParId", parId);
	}

	@Override
	public void saveGipiWMcAcc(List<GIPIWMcAcc> accItems) throws SQLException {		
		log.info("DAO calling saveGipiWMcAcc...");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Saving record/s:");
			System.out.println("ParId\tItemNo\tAccCd\tAccAmt");
			System.out.println("=======================================================================================");
			for(GIPIWMcAcc a : accItems){
				System.out.println(a.getParId() + "\t" + a.getItemNo() + "\t" + a.getAccessoryCd() + "\t" + a.getAccAmt());
				this.getSqlMapClient().insert("setGipiWMcAccByParams", a);
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
	}

	@Override
	public void deleteGipiWMcAcc(List<GIPIWMcAcc> gipiWMcAcc)
			throws SQLException {
		log.info("DAO calling deleteGipiWMcACC...");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Deleting record/s:");
			System.out.println("ParId\tItemNo\tAccCd\tAccAmt");
			System.out.println("=======================================================================================");
			for(GIPIWMcAcc a : gipiWMcAcc){
				System.out.println(a.getParId() + "\t" + a.getItemNo() + "\t" + a.getAccessoryCd() + "\t" + a.getAccAmt());
				this.deleteGipiWMcAcc(a.getParId(), a.getItemNo(), Integer.parseInt(a.getAccessoryCd()));
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
	}

	@Override
	public void deleteGipiWMcAcc(int parId, int itemNo) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().delete("delGipiWMcAcc", params);
	}

	@Override
	public void deleteGipiWMcAcc(int parId, int itemNo, int accCd)
			throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("accessoryCd", accCd);
		this.getSqlMapClient().delete("delGipiWMcAccWithAccCd", params);
	}
}
