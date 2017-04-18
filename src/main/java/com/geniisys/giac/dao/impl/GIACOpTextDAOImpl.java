package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACOpTextDAO;
import com.geniisys.giac.entity.GIACOpText;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACOpTextDAOImpl implements GIACOpTextDAO{

	private static Logger log = Logger.getLogger(GIACOpTextDAOImpl.class);
	public SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACOpText> getGIACOpText(Integer gaccTranId) throws SQLException {
		return this.sqlMapClient.queryForList("getGIACOpText", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> whenNewFormsInsGIACS025(Integer gaccTranId)
			throws SQLException {
		return (HashMap<String, Object>) this.sqlMapClient.queryForObject("whenNewFormsInsGIACS025", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveORPreview(Map<String, Object> allParams)
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving OR Preview.");
			
			List<GIACOpText> setRows = (List<GIACOpText>) allParams.get("setRows");
			List<GIACOpText> delRows = (List<GIACOpText>) allParams.get("delRows");
			
			for (GIACOpText del:delRows){
				log.info("deleting: "+ del);
				this.getSqlMapClient().delete("delGIACOpText3", del);
			}
			
			for (GIACOpText set:setRows){
				log.info("inserting: "+ set);
				this.getSqlMapClient().insert("setGIACOpText", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving OR Preview.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACOpText> generateParticulars(Integer gaccTranId)
			throws SQLException {
		return this.sqlMapClient.queryForList("generateParticularsGIACS025", gaccTranId);
	}

	@Override
	public HashMap<String, Object> checkInsertTaxCollnsGIACS025(
			HashMap<String, Object> insertTax) throws SQLException {
		log.info("checkInsertTaxCollnsGIACS025 - "+insertTax);
		this.sqlMapClient.update("checkInsertTaxCollnsGIACS025", insertTax);
		return insertTax;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACOpText> getGIACOpTextTableGrid(
			HashMap<String, Object> params) throws SQLException{
		return this.sqlMapClient.queryForList("getGIACOpTextTableGrid", params);
	}

	@Override
	public HashMap<String, Object> genSeqNos(HashMap<String, Object> map)
			throws SQLException {
		this.sqlMapClient.update("genSeqNosGiacOpText", map);
		return map;
	}

	@Override
	public String checkPrintSeqNoORPreview(HashMap<String, Object> map)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPrintSeqNoORPreview", map);
	}

	@Override
	public HashMap<String, Object> sumAmountsORPreview(
			HashMap<String, Object> params) throws SQLException {
		this.sqlMapClient.update("sumAmountsORPreview",params);
		return params;
	}

	@Override
	public HashMap<String, Object> validatePrintOP(HashMap<String, Object> map)
			throws SQLException {
		this.sqlMapClient.update("validatePrintOP", map);
		return map;
	}

	@Override
	public Map<String, Object> newFormInstanceGIACS050(Map<String, Object> params) throws SQLException {
		log.info("Setting default values for GIACS050 OR Printing... ");
		this.getSqlMapClient().queryForObject("giacs050GetDefaults", params);
		return params;
	}

	@Override
	public String checkVATOR(Map<String, Object> params)
			throws SQLException {
		log.info("Checking Default VAT Type...");
		String printType = (String) this.getSqlMapClient().queryForObject("checkVatORPrinting", params);
		return printType;
	}

	@Override
	public HashMap<String, Object> validateORForPrint(Map<String, Object> params)
			throws SQLException {
		log.info("Validating OR for Printing...");
		this.getSqlMapClient().update("validateORForPrint", params);
		return (HashMap<String, Object>) params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getPrintSeqNoList(Integer gaccTranId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPrintSeqNoList", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getItemSeqNoList(Integer gaccTranId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getItemSeqNoList", gaccTranId);
	}

	@Override
	public void adjustOpTextOndDiscrep(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Adjusting Op Text Due to Discrepancy... "+params);
			this.getSqlMapClient().update("adjustOpTextOnDiscrepancy", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String validateORAcctgEntries(String paramName)
			throws SQLException {
		log.info("Validating OR Accounting Entries in GIAC_PARAMETERS WHERE PARAM_NAME = "+ paramName);
		return (String) this.sqlMapClient.queryForObject("validateORAcctgEntries",paramName);
	}

	@Override
	public String validateBalanceAcctgEntrs(Integer gaccTranId)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateBalanceAcctEntrs",gaccTranId);
	}
	
	//added john 10.24.2013
	@Override
	public void adjDocStampsGiacs025(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Adjusting Op Text Due to Discrepancy... "+params);
			this.getSqlMapClient().update("adjDocStampsGiacs025", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	//added john 7.1.2015
	@Override
	public void recomputeOpText(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Adjusting Op Text Due to Discrepancy... "+params);
			this.getSqlMapClient().update("recomputeOpText", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
