package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWGrpItemsBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWGrpItemsBeneficiaryDAOImpl implements GIPIWGrpItemsBeneficiaryDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIPIWGrpItemsBeneficiaryDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWGrpItemsBeneficiaryDAO#getGipiWGrpItemsBeneficiary(java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary(
			Integer parId, Integer itemNo) throws SQLException {
		@SuppressWarnings("rawtypes")
		Map<String, String> params = new HashMap();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		return this.getSqlMapClient().queryForList("getGIPIWGrpItemsBeneficiary", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWGrpItemsBeneficiaryDAO#getGipiWGrpItemsBeneficiary2(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary2(
			Integer parId) throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIWGrpItemsBeneficiary2", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWGrpItemsBeneficiaryDAO#getRetGipiWGrpItemsBeneficiary(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGrpItemsBeneficiary> getRetGipiWGrpItemsBeneficiary(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("retGrpItmsGipiWGrpItemsBeneficiary", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveBeneficiaries(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving beneficiaries...");
			
			List<GIPIWGrpItemsBeneficiary> setBenRows = (List<GIPIWGrpItemsBeneficiary>) params.get("setBenRows");
			List<GIPIWGrpItemsBeneficiary> delBenRows = (List<GIPIWGrpItemsBeneficiary>) params.get("delBenRows");
			List<GIPIWItmperlBeneficiary> setPerilRows = (List<GIPIWItmperlBeneficiary>) params.get("setPerilRows");
			List<GIPIWItmperlBeneficiary> delPerilRows = (List<GIPIWItmperlBeneficiary>) params.get("delPerilRows");
			
			for (GIPIWGrpItemsBeneficiary del : delBenRows){
				log.info("DELETING: " + del);
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("parId", del.getParId());
				delParams.put("itemNo", del.getItemNo());
				delParams.put("groupedItemNo", del.getGroupedItemNo());
				delParams.put("beneficiaryNo", del.getBeneficiaryNo());
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary", delParams);
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiaryGrpItemNoBenNo", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			for (GIPIWGrpItemsBeneficiary set : setBenRows){
				log.info("INSERTING: " + set);
				this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", set);
			}
			this.getSqlMapClient().executeBatch();
			
			for (GIPIWItmperlBeneficiary del : delPerilRows){
				log.info("DELETING: " + del);
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("parId", del.getParId());
				delParams.put("itemNo", del.getItemNo());
				delParams.put("groupedItemNo", del.getGroupedItemNo());
				delParams.put("beneficiaryNo", del.getBeneficiaryNo());
				delParams.put("perilCd", del.getPerilCd());
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiaryGrpItemNoBenNoPerilCd", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			for (GIPIWItmperlBeneficiary set : setPerilRows){
				log.info("INSERTING: " + set);
				this.getSqlMapClient().insert("setGIPIWItmperlBeneficiary", set);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving beneficiaries...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> validateBenNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateBenNo", params);
		return params;
	}
	/*added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)*/
	@Override
	public Map<String, Object> validateBenNo2(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateBenNo2", params);
		return params;
	}
	/*END SR21720*/
}