package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACLossRiCollnsDAO;
import com.geniisys.giac.entity.GIACLossRiCollns;
import com.geniisys.giac.exceptions.InvalidAegParametersException;
import com.geniisys.giac.exceptions.InvalidSlTypeParametersException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACLossRiCollnsDAOImpl implements GIACLossRiCollnsDAO{
	
	private static Logger log = Logger.getLogger(GIACLossRiCollnsDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getLossAdviceList(
			HashMap<String, Object> params) throws SQLException {
		List<Map<String, Object>> list = null;
		list = this.sqlMapClient.queryForList("getLossAdviceListing", params);
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACLossRiCollns> getGIACLossRiCollns(Integer gaccTranId)
			throws SQLException {
		return this.sqlMapClient.queryForList("getGIACLossRiCollns", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> validateFLA(HashMap<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("validateFLALossesRecov", params);
	}

	@Override
	public Map<String, Object> validateCurrencyCode(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateCurrencyCodeLossesRecov", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveLossesRecov(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			log.info("Start of saving ri trans losses recov from ri.");
			//Integer gaccTranId = (Integer) params.get("gaccTranId"); 
			List<GIACLossRiCollns> setRows = (List<GIACLossRiCollns>) params.get("setRows");
			List<GIACLossRiCollns> delRows = (List<GIACLossRiCollns>) params.get("delRows");
			
			this.getSqlMapClient().startBatch();
			for (GIACLossRiCollns del:delRows){
				log.info("deleting: "+ del.getGaccTranId()+","+del.getA180RiCd()+","+del.getE150LineCd()+","+del.getE150LaYy()+","+del.getE150FlaSeqNo()+","+del.getPayeeType());
				this.getSqlMapClient().delete("delGIACLossRiCollns", del);
			}
			this.getSqlMapClient().executeBatch();
			
			for (GIACLossRiCollns set:setRows){
				log.info("inserting: "+ set.getGaccTranId()+","+set.getA180RiCd()+","+set.getE150LineCd()+","+set.getE150LaYy()+","+set.getE150FlaSeqNo());
				this.getSqlMapClient().insert("setGIACLossRiCollns", set);
			}
			this.getSqlMapClient().executeBatch();
			
			//POST-FORMS-COMMIT form trigger
			if (params.get("tranSource").equals("OP") || params.get("tranSource").equals("OR")){
				if (!params.get("orFlag").equals("P")){
					log.info("Updating GIAC_OP_TEXT: "+params.get("gaccTranId"));
					this.sqlMapClient.insert("updateGIACOpTextLossesRecov", params);
				}
			}
			this.getSqlMapClient().executeBatch();
				
			Map<String, Object> slTypeParams = new HashMap<String, Object>();
			slTypeParams = (Map<String, Object>) this.sqlMapClient.queryForObject("getSlTypeParametersLossesRecov", "GIACS009");
			this.getSqlMapClient().executeBatch();
			if (slTypeParams.get("vMsgAlert") != null){
				message = "Exception occurred. "+(String) slTypeParams.get("vMsgAlert");
				throw new InvalidSlTypeParametersException(message);
			}
				
			//creating acct entries
			Map<String, Object> paramsAeg = new HashMap<String, Object>();
			paramsAeg.put("gaccTranId", (Integer) params.get("gaccTranId"));
			paramsAeg.put("slCdType1", (String) slTypeParams.get("variablesSlTypeCd1"));
			paramsAeg.put("genType", (String) slTypeParams.get("variablesGenType"));
			paramsAeg.put("moduleId", slTypeParams.get("variablesModuleId"));
			paramsAeg.put("gaccBranchCd", (String) params.get("gaccBranchCd"));
			paramsAeg.put("gaccFundCd", (String) params.get("gaccFundCd"));
			paramsAeg.put("userId", (String) params.get("userId"));
			
			this.sqlMapClient.update("aegParametersGIACS009", paramsAeg);
			this.getSqlMapClient().executeBatch();
			
			if (paramsAeg.get("vMsgAlert") != null){
				message = "Exception occurred. "+(String) paramsAeg.get("vMsgAlert");
				throw new InvalidAegParametersException(message);
			}
			log.info("aeg_parameters : "+paramsAeg);
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (InvalidSlTypeParametersException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (InvalidAegParametersException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();	
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving ri trans losses recov from ri.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getLossAdviceListTableGrid(
			HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getLossAdviceListTableGrid", params);
	}
}
