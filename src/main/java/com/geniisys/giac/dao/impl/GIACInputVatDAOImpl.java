package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISPayees;
import com.geniisys.giac.dao.GIACInputVatDAO;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACInputVat;
import com.geniisys.giac.entity.GIACSlLists;
import com.geniisys.giac.exceptions.InvalidGIACInputVatDataException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACInputVatDAOImpl implements GIACInputVatDAO{
	
	private static Logger log = Logger.getLogger(GIACInputVatDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInputVat> getGiacInputVat(HashMap<String, String> params)
			throws SQLException {
		log.info("Getting input vat: "+params);
		return this.getSqlMapClient().queryForList("getGIACInputVats", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISPayees> getPayeeList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting payee list: "+params);
		return this.getSqlMapClient().queryForList("getPayeesInputVatListing", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACSlLists> getSlNameList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting sl name list: "+params);
		//return this.getSqlMapClient().queryForList("getSlNameInputVatListing", params);
		return this.getSqlMapClient().queryForList("getSlNameInputVatListing2", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getAcctCodeList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting account code list: "+params);
	//	return this.getSqlMapClient().queryForList("getGlAcctListing2", params);
		return this.getSqlMapClient().queryForList("getGlAcctListing5", params);
	}

	@Override
	public GIACChartOfAccts validateAcctCode(HashMap<String, String> params)
			throws SQLException {
		log.info("validate account code: "+params);
		return (GIACChartOfAccts) this.getSqlMapClient().queryForObject("validateAcctCodeInputVat", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInputVat(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving direct trans input vat.");
			List<GIACInputVat> setRows = (List<GIACInputVat>) params.get("setRows");
			List<GIACInputVat> delRows = (List<GIACInputVat>) params.get("delRows");
			String globalTranSource = (String) params.get("globalTranSource");
			String globalOrFlag = (String) params.get("globalOrFlag");
			String userId = (String) params.get("userId");
			Integer gaccTranId = (Integer) params.get("gaccTranId"); 
			
			for(GIACInputVat vat:delRows){
				log.info("deleting input vat: "+vat.getGaccTranId()+","+vat.getTransactionType()+","+vat.getPayeeClassCd()+","+vat.getPayeeNo()+","+vat.getReferenceNo());
				this.getSqlMapClient().delete("delGIACInputVat", vat);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIACInputVat vat:setRows){
				log.info("inserting input vat: "+vat.getGaccTranId()+","+vat.getTransactionType()+","+vat.getPayeeClassCd()+","+vat.getPayeeNo()+","+vat.getReferenceNo());
				this.getSqlMapClient().insert("setGIACInputVat", vat);
				this.getSqlMapClient().executeBatch();
			}
			
			//start of post-form-commit
			if (globalTranSource.equals("OR") || globalTranSource.equals("OP")){
				if (!globalOrFlag.equals("P")){
					Map<String, Object> paramsMap = new HashMap<String, Object>();
					paramsMap.put("gaccTranId", gaccTranId);
					paramsMap.put("moduleName", "GIACS039");
					paramsMap.put("userId", userId);
					this.sqlMapClient.update("updateGiacOpTextGIACS039", paramsMap);
					this.getSqlMapClient().executeBatch();
					if (paramsMap.get("vMsgAlert") != null){
						message = "Error occured. "+(String) paramsMap.get("vMsgAlert");
						throw new InvalidGIACInputVatDataException(message);
					}
					log.info("update giac_op_text : "+paramsMap);
				}
			}
			for(GIACInputVat vat:delRows){
				Map<String, Object> paramsAeg = new HashMap<String, Object>();
				paramsAeg.put("gaccTranId", gaccTranId);
				paramsAeg.put("gaccBranchCd", (String) params.get("gaccBranchCd"));
				paramsAeg.put("gaccFundCd", (String) params.get("gaccFundCd"));
				paramsAeg.put("moduleName", "GIACS039");
				paramsAeg.put("vatGlAcctId", vat.getVatGlAcctId());
				paramsAeg.put("baseAmt", vat.getBaseAmt());
				paramsAeg.put("userId", userId);
				this.sqlMapClient.update("aegParametersGIACS039", paramsAeg);
				this.getSqlMapClient().executeBatch();
				if (paramsAeg.get("vMsgAlert") != null){
					message = "Error occured. "+(String) paramsAeg.get("vMsgAlert");
					throw new InvalidGIACInputVatDataException(message);
				}
				log.info("aeg_parameters : "+paramsAeg);
			}
			for(GIACInputVat vat:setRows){
				Map<String, Object> paramsAeg = new HashMap<String, Object>();
				paramsAeg.put("gaccTranId", gaccTranId);
				paramsAeg.put("gaccBranchCd", (String) params.get("gaccBranchCd"));
				paramsAeg.put("gaccFundCd", (String) params.get("gaccFundCd"));
				paramsAeg.put("moduleName", "GIACS039");
				paramsAeg.put("vatGlAcctId", vat.getVatGlAcctId());
				paramsAeg.put("baseAmt", vat.getBaseAmt());
				paramsAeg.put("userId", userId);
				this.sqlMapClient.update("aegParametersGIACS039", paramsAeg);
				this.getSqlMapClient().executeBatch();
				if (paramsAeg.get("vMsgAlert") != null){
					message = "Error occured. "+(String) paramsAeg.get("vMsgAlert");
					throw new InvalidGIACInputVatDataException(message);
				}
				log.info("aeg_parameters : "+paramsAeg);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (InvalidGIACInputVatDataException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving direct trans input vat.");
			this.getSqlMapClient().endTransaction();	
		}	
		return message;
	}
}
