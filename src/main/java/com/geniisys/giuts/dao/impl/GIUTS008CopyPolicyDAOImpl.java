package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giuts.dao.GIUTS008CopyPolicyDAO;
import com.geniisys.giuts.entity.GIUTS008CopyPolicyDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUTS008CopyPolicyDAOImpl implements GIUTS008CopyPolicyDAO{
	
	
	private Logger log = Logger.getLogger(GIUTS008CopyPolicyDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public String validateLineCd(String lineCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLineCdGIUTS080",lineCd);
	}
	
	@Override
	public String validateGIUTS008LineCd(Map<String, Object> params) throws SQLException, Exception {
		log.info("Validating user line code access: "+params);
		return (String) this.getSqlMapClient().queryForObject("validateGIUTS008LineCd", params);
	}

	@Override
	public String validateOpFlag(HashMap<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("validateOpFlag",params);
	}

	@Override
	public Integer validateUserPackIssCd(HashMap<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		return (Integer) this.getSqlMapClient().queryForObject("validateUserPassIssCd",params);
	}

	@Override
	public Integer getPolicyId(HashMap<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		return (Integer) this.getSqlMapClient().queryForObject("getPolicyId",params);
	}

	@Override
	public String copyMainQuery(HashMap<String, Object> params)
			throws SQLException {
		return null;
		/*String test = (String) this.getSqlMapClient().queryForObject("copyMainQuery",params);
		System.out.println(":::::::::::::::::::::::::"+test+":::::::::::");
		return (String) this.getSqlMapClient().queryForObject("copyMainQuery",params);*/
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> copyPARPolicyMainQuery(HashMap<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			GIUTS008CopyPolicyDtl mainDetails = null;
			GIUTS008CopyPolicyDtl mainDetails2 = null;
			GIUTS008CopyPolicyDtl mainDetails3 = null;
			GIUTS008CopyPolicyDtl mainDetails4 = null;
			GIUTS008CopyPolicyDtl mainDetails5 = null;
			List<GIUTS008CopyPolicyDtl> curDetail = null;
			if(params != null){
				HashMap<String,Object> details = new HashMap<String, Object>();		
				mainDetails = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("copyMain1Giuts008",params);
				this.getSqlMapClient().executeBatch();
				
				System.out.println(":::::::::::::::::::MAIN DETAILS>>>>>>>>>>>>"+mainDetails+"<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::::");
				HashMap<String,Object> params2 = new HashMap<String, Object>();
				Integer parId = ((GIUTS008CopyPolicyDtl) mainDetails).getParId();
				System.out.println(":::::::::::::::::::PAR ID>>>>>>>>>>>>"+((GIUTS008CopyPolicyDtl) mainDetails).getParId()+"<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::::");
				String issCd = (String) params.get("issCd");
				String issCdRi = ((GIUTS008CopyPolicyDtl) mainDetails).getIssCdRi();
				//String nbtIssCd = ((GIUTS008CopyPolicyDtl) mainDetails).getNbtIssCd();
				
				String nbtIssCd = (String) params.get("nbtIssCd");
				String nbtLineCd = (String) params.get("nbtLineCd");
				String lineCd = (String) params.get("lineCd");
				Integer nbtIssueYy = (Integer) params.get("nbtIssueYy");
				Integer nbtPolSeqNo = (Integer) params.get("nbtPolSeqNo");
				Integer nbtRenewNo = (Integer) params.get("nbtRenewNo");
				String userId = (String) params.get("userId");
				String long1 = (String) params.get("long1");
				Integer issueYy = ((GIUTS008CopyPolicyDtl) mainDetails).getIssueYy();
				Integer polSeqNo = ((GIUTS008CopyPolicyDtl) mainDetails).getPolSeqNo();
				String nbtSublineCd = (String) params.get("nbtSublineCd");
				String parType = ((GIUTS008CopyPolicyDtl) mainDetails).getParType();
				//Integer parSeqNo = ((GIUTS008CopyPolicyDtl) mainDetails).getParSeqNo();
				Integer renewNo = ((GIUTS008CopyPolicyDtl) mainDetails).getRenewNo();
				String sublineMop = ((GIUTS008CopyPolicyDtl) mainDetails).getSublineMop();
				String lineAc = ((GIUTS008CopyPolicyDtl) mainDetails).getLineAc();
				String lineCa = ((GIUTS008CopyPolicyDtl) mainDetails).getLineCa();
				String lineAv = ((GIUTS008CopyPolicyDtl) mainDetails).getLineAv();
				String lineEn = ((GIUTS008CopyPolicyDtl) mainDetails).getLineEn();
				String lineMc = ((GIUTS008CopyPolicyDtl) mainDetails).getLineMc();
				String lineFi = ((GIUTS008CopyPolicyDtl) mainDetails).getLineFi();
				String lineMh = ((GIUTS008CopyPolicyDtl) mainDetails).getLineMh();
				String lineMn = ((GIUTS008CopyPolicyDtl) mainDetails).getLineMn();
				String lineSu = ((GIUTS008CopyPolicyDtl) mainDetails).getLineSu();
				String sublineCd = (String) params.get("sublineCd");
				String nbtEndtIssCd = (String) params.get("nbtEndtIssCd");
				String openFlag = ((GIUTS008CopyPolicyDtl) mainDetails).getOpenFlag();
				String packLineCdCur = null;
				String packSublineCdCur = null;
				String itemGrpCur = null;
				Integer itemNoCur = null;
				String itemExistCur = null;		
				Integer quoteSeqNo = (Integer) params.get("nbtQuoteSeqNo");
				
				Integer nbtEndtSeqNo = (Integer) params.get("nbtEndtSeqNo");
				System.out.println("nbtEndtSeqNo >>>>>>>>>>>>>>>>>>>>>>>>"+nbtEndtSeqNo+"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
				@SuppressWarnings("unused")
				GIUTS008CopyPolicyDtl validationDetails = null;
				/*if(nbtEndtSeqNo > 0 ){
					validationDetails = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("checkEndtGiuts008",params);
					mainDetails5 = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("getValidationDetailsGiuts008",params);
				}
				else{
					validationDetails = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("checkPolicyGiuts008",params);
					mainDetails5 = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("getValidationPolicyDetailsGiuts008",params);
				}*/
				
				Integer policyId = ((GIUTS008CopyPolicyDtl) mainDetails).getPolicyId();
				
				HashMap<String,Object> insertParams = new HashMap<String, Object>();
				insertParams.put("policyId",policyId);
				insertParams.put("userId",userId);
				insertParams.put("parType",parType);
				insertParams.put("parId",parId);
				System.out.println("INSERT PARAMS >>>>>>>>>>>>>>>>>>>>>>>>>>"+insertParams+"<<<<<<<<<<<<<<<<<<<<<<<<<");
				
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("insertParlistGiuts008",insertParams);
				
				this.getSqlMapClient().executeBatch();
				
				
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("insertParhistGiuts008",insertParams);
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().startBatch();
				
				params2.put("parId",parId);
				mainDetails2 = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("copyMain2Giuts008",params2);
				Integer parSeqNo = ((GIUTS008CopyPolicyDtl) mainDetails2).getParSeqNo();
				System.out.println("PAR SEQ NO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+parSeqNo+"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
				if(issCd != "RI" || issCd == issCdRi){
					HashMap<String,Object> params3 = new HashMap<String, Object>();
					params3.put("policyId",policyId);
					params3.put("parId",parId);
					System.out.println("::::::::::::::::::POLBAS PARAMS >>>>>>>>>>>>>>>>>>>>>>"+params3+"::::::::::::::::::::::::::::::::");
					this.getSqlMapClient().queryForList("copyInpolbasGiuts008",params3);
					
				}
				HashMap<String,Object> params4 = new HashMap<String, Object>();
				params4.put("policyId",policyId);
				params4.put("issCd",issCd);
				params4.put("nbtIssCd",nbtIssCd);
				params4.put("nbtLineCd",nbtLineCd);
				params4.put("lineCd",lineCd);
				params4.put("nbtIssueYy",nbtIssueYy);
				params4.put("nbtPolSeqNo",nbtPolSeqNo);
				params4.put("nbtRenewNo",nbtRenewNo);
				params4.put("parId",parId);
				params4.put("userId",userId);
				params4.put("long1",long1);
				System.out.println("::::::::::::::::::::::::::::::PARAMS COPY POLBAS>>>>>>>>>>>>>>>>>>"+params4+"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("copyPolbasicGiuts008",params4);
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().startBatch();
				
				this.getSqlMapClient().update("copyMortgageeGiuts008",params4);
				this.getSqlMapClient().update("copyPolgeninGiuts008",params4);
				this.getSqlMapClient().update("copyPolwcGiuts008",params4);
				this.getSqlMapClient().update("copyEndttextGiuts008",params4);
				
				mainDetails3 = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("copyMain3Giuts008",params4);
				String packPolFlag = ((GIUTS008CopyPolicyDtl) mainDetails3).getPackPolFlag();
				String menuLineCd = ((GIUTS008CopyPolicyDtl) mainDetails3).getMenuLineCd();
				if (packPolFlag == "Y"){
					this.getSqlMapClient().update("copyPackLineSublineGiuts008",params4);
					curDetail = this.getSqlMapClient().queryForList("curQuery",policyId);
					
					
					for(GIUTS008CopyPolicyDtl cur : curDetail){
						HashMap<String,Object> lineParam = new HashMap<String, Object>();
						packLineCdCur = ((GIUTS008CopyPolicyDtl) curDetail).getPackLineCd();
						packSublineCdCur = ((GIUTS008CopyPolicyDtl) curDetail).getPackSublineCd();  
						itemGrpCur	= ((GIUTS008CopyPolicyDtl) curDetail).getItemGrp();
						itemNoCur	= ((GIUTS008CopyPolicyDtl) curDetail).getItemNo();	
						lineParam.put("policyId",policyId);
						lineParam.put("packLingCd",packLineCdCur);
						lineParam.put("packSublineCd",packSublineCdCur);
						lineParam.put("issCd",issCd);
						lineParam.put("issueYy",issueYy);
						lineParam.put("polSeqNo",polSeqNo);
						lineParam.put("itemNo",itemNoCur);
						lineParam.put("itemGrp",itemGrpCur);
						lineParam.put("nbtLineCd",nbtLineCd);
						lineParam.put("nbtSublineCd",nbtSublineCd);
						lineParam.put("parType",parType);
						lineParam.put("parId",parId);
						lineParam.put("parSeqNo",parSeqNo);
						lineParam.put("renewNo",renewNo);
						this.getSqlMapClient().update("copyLineGiuts008",lineParam);
						itemExistCur = "Y";
						}					
				}
				else{
					
					if((menuLineCd != "MN") || (nbtSublineCd != sublineMop)){
						if((lineCd != lineAc) || (menuLineCd != "AC")){
							HashMap<String,Object> limLiabParam = new HashMap<String, Object>();
							limLiabParam.put("policyId",policyId);
							limLiabParam.put("parId",parId);
							this.getSqlMapClient().update("copyLimLiabGiuts008",limLiabParam);
						}
						HashMap<String,Object> copyItemParam = new HashMap<String, Object>();
						copyItemParam.put("policyId",policyId);
						copyItemParam.put("nbtLineCd",nbtLineCd);
						copyItemParam.put("nbtSublineCd",nbtSublineCd);
						copyItemParam.put("nbtIssCd",nbtIssCd);
						copyItemParam.put("nbtIssueYy",nbtIssueYy);
						copyItemParam.put("nbtPolSeqNo",nbtPolSeqNo);
						copyItemParam.put("nbtRenewNo",nbtRenewNo);
						copyItemParam.put("parType",parType);
						copyItemParam.put("parId",parId);
						this.getSqlMapClient().update("copyItemGiuts008",copyItemParam);
						if(parType == "P"){
							HashMap<String,Object> copyItemPeril = new HashMap<String, Object>();
							copyItemPeril.put("policyId",policyId);
							copyItemPeril.put("nbtLineCd",nbtLineCd);
							copyItemPeril.put("parId",parId);
							this.getSqlMapClient().update("copyItmperilGiuts008",copyItemPeril);
						}
						if(parType == "P"){
							HashMap<String,Object> copyParam = new HashMap<String, Object>();
							copyParam.put("policyId",policyId);
							copyParam.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyPerilDiscountGiuts008",copyParam);
							this.getSqlMapClient().update("copyItemDiscountGiuts008",copyParam);
							this.getSqlMapClient().update("copyPolbasDiscountGiuts008",copyParam);
						}
						if((lineCd == lineAc) || (menuLineCd == "AC")){
							HashMap<String,Object> acParams = new HashMap<String, Object>();
							acParams.put("policyId",policyId);
							acParams.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyBeneficiaryGiuts008",acParams);
							this.getSqlMapClient().update("copyAccidentItemGiuts008",acParams);
						}
						else if((lineCd == lineCa) || (menuLineCd == "CA")){
							HashMap<String,Object> caParams = new HashMap<String, Object>();
							caParams.put("policyId",policyId);
							caParams.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyCasualtyItemGiuts008",caParams);
							this.getSqlMapClient().update("copyCasualtyPersonnelGiuts008",caParams);
						}
						else if((lineCd == lineEn) || (menuLineCd == "EN")){
							HashMap<String,Object> enParams = new HashMap<String, Object>();
							enParams.put("policyId",policyId);
							enParams.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyEnggBasicGiuts008",enParams);
							this.getSqlMapClient().update("copyLocationGiuts008",enParams);
							this.getSqlMapClient().update("copyPrincipalGiuts008",enParams);
						}
						else if((lineCd == lineFi) || (menuLineCd == "FI")){
							HashMap<String,Object> fiParams = new HashMap<String, Object>();
							fiParams.put("policyId",policyId);
							fiParams.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyFireGiuts008",fiParams);
						}
						else if((lineCd == lineMc) || (menuLineCd == "MC")){
							HashMap<String,Object> mcParams = new HashMap<String, Object>();
							mcParams.put("policyId",policyId);
							mcParams.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyVehicleGiuts008",mcParams);
							this.getSqlMapClient().update("copyMcaccGiuts008",mcParams);
						}
						else if(lineCd == lineSu){
							HashMap<String,Object> suParams = new HashMap<String, Object>();
							suParams.put("policyId",policyId);
							suParams.put("nbtLineCd",nbtLineCd);
							this.getSqlMapClient().update("copyBondBasicGiuts008",suParams);
							this.getSqlMapClient().update("copyCosignatoryGiuts008",suParams);
						}
						else if(((lineCd == lineMh) || (lineCd == lineMn) || (lineCd == lineAv)) || ((menuLineCd == "MC") || (menuLineCd == "MN") || (menuLineCd == "AV"))){
							HashMap<String,Object> copyAvMhMnParams = new HashMap<String, Object>();
							copyAvMhMnParams.put("policyId",policyId);
							copyAvMhMnParams.put("lineCd",lineCd);
							copyAvMhMnParams.put("sublineCd",sublineCd);
							copyAvMhMnParams.put("issCd",issCd);
							copyAvMhMnParams.put("issueYy",issueYy);
							copyAvMhMnParams.put("polSeqNo",polSeqNo);
							copyAvMhMnParams.put("parId",parId);
							copyAvMhMnParams.put("parType",parType);
							copyAvMhMnParams.put("renewNo",renewNo);
							copyAvMhMnParams.put("userId",userId);
							this.getSqlMapClient().update("copyAviationCargoHullGiuts008",copyAvMhMnParams);							
						}
						HashMap<String,Object> otherParams = new HashMap<String, Object>();
						otherParams.put("policyId",policyId);
						otherParams.put("parId",parId);
						this.getSqlMapClient().update("copyDeductiblesGiuts008",otherParams);
						this.getSqlMapClient().update("copyGroupedItemsGiuts008",otherParams);
						//this.getSqlMapClient().queryForList("copyPictures",otherParams);
						if((openFlag == "Y") && (menuLineCd != "MN")){
							HashMap<String,Object> copyFlag = new HashMap<String, Object>();
							copyFlag.put("policyId",policyId);
							copyFlag.put("parId",parId);
							this.getSqlMapClient().update("copyOpenLiabGiuts008",copyFlag);
							this.getSqlMapClient().update("copyOpenPerilGiuts008",copyFlag);
						}						
					}
				}
					HashMap<String,Object> copyOrigParams = new HashMap<String, Object>();
					copyOrigParams.put("policyId",policyId);
					copyOrigParams.put("parId",parId);
					this.getSqlMapClient().update("copyOrigInvoiceGiuts008",copyOrigParams);
					this.getSqlMapClient().update("copyOrigInvperilGiuts008",copyOrigParams);
					this.getSqlMapClient().update("copyOrigInvTaxGiuts008",copyOrigParams);
					this.getSqlMapClient().update("copyOrigItemperilGiuts008",copyOrigParams);
					this.getSqlMapClient().update("copyCoInsGiuts008",copyOrigParams);
					
					if(itemExistCur == "N"){
						HashMap<String,Object> copyInvPackParams = new HashMap<String, Object>();
						copyInvPackParams.put("policyId",policyId);
						copyInvPackParams.put("parId",parId);
						this.getSqlMapClient().update("copyInvoicePackGiuts008",copyInvPackParams);
					}
					HashMap<String,Object> updateTablesParams = new HashMap<String, Object>();
					updateTablesParams.put("issCd",issCd);
					updateTablesParams.put("parId",parId);
					updateTablesParams.put("nbtEndtIssCd",nbtEndtIssCd);
					this.getSqlMapClient().update("updateAllTablesGiuts008",updateTablesParams);
					
					HashMap<String,Object> details4Params = new HashMap<String, Object>();
					details4Params.put("parId",parId);
					details4Params.put("nbtLineCd",nbtLineCd);
					details4Params.put("nbtIssCd",nbtIssCd);
					details4Params.put("openFlag",openFlag);
					details4Params.put("parType",parType);
					mainDetails4 = (GIUTS008CopyPolicyDtl) this.getSqlMapClient().queryForObject("copyMain4Giuts008",details4Params);
					
					this.getSqlMapClient().executeBatch();
					
					String oldPar = "";
					String newPar = "";
					
					
					oldPar = nbtLineCd + " - " + nbtSublineCd + " - " + nbtIssCd + " - " +
							 nbtIssueYy + " - " + nbtPolSeqNo + " - " + nbtRenewNo;
					
					System.out.println("OLD PAR >>>>>>>>>>>>>>>>>>>>>>"+oldPar+"<<<<<<<<<<<<<<<<<<<<<<");
					
					newPar = lineCd + " - " + issCd + " - " + issueYy + " - " + parSeqNo + " - " + renewNo;  
					
					System.out.println("NEW PAR >>>>>>>>>>>>>>>>>>>>>>"+newPar+"<<<<<<<<<<<<<<<<<<<<<<");
					
					//HashMap<String, Object> outPut = new HashMap<String, Object>();
					
					params.put("oldPar",oldPar);
					params.put("newPar",newPar);
					params.put("parSeqNo",parSeqNo);
					
					
					
					//this.getSqlMapClient().getCurrentConnection().commit();
			}
			this.getSqlMapClient().getCurrentConnection().rollback();
			
			
		}catch (Exception e){
			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> copyPolicyEndtToPAR(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Check policy existence and status..."+params);
			this.getSqlMapClient().update("checkGiuts008ExistingPolicy", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting record in GIPI_PARLIST:"+params);
			this.getSqlMapClient().insert("giuts008InsertIntoParlist", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting record in GIPI_PARHIST:"+params);
			this.getSqlMapClient().insert("insertParhistGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> paramValueMap = new HashMap<String, Object>();
			paramValueMap.put("nbtLineCd", params.get("nbtLineCd"));
			paramValueMap.put("nbtSublineCd", params.get("nbtSublineCd"));
			this.getSqlMapClient().update("initializeGiuts008CopyVariables", paramValueMap);
			this.getSqlMapClient().executeBatch();
			
			log.info("Param value Map: "+paramValueMap);
			params.put("openFlag", paramValueMap.get("openFlag"));
			
			if(params.get("nbtIssCd").equals(paramValueMap.get("issCdRi")) || params.get("nbtIssCd").equals("RI")){
				log.info("Copying records in GIRI_INPOLBAS:"+params);
				this.getSqlMapClient().update("copyInpolbasGiuts008", params);
				this.getSqlMapClient().executeBatch();
			}
			
			log.info("Copying records in GIPI_POLBASIC:"+params);
			this.getSqlMapClient().insert("copyPolbasicGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Copying records in GIPI_MORTGAGEE:"+params);
			this.getSqlMapClient().insert("copyMortgageeGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Copying records in GIPI_POLGENIN:"+params);
			this.getSqlMapClient().insert("copyPolgeninGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Copying records in GIPI_POLWC:"+params);
			this.getSqlMapClient().insert("copyPolwcGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Copying records in GIPI_ENDTTEXT:"+params);
			this.getSqlMapClient().insert("copyEndttextGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			String itemExists = "N";
			if("Y".equals(paramValueMap.get("packPolFlag"))){
				log.info("Copying records in GIPI_PACK_LINE_SUBLINE:"+params);
				this.getSqlMapClient().insert("copyPackLineSublineGiuts008", params);
				this.getSqlMapClient().executeBatch();
				
				log.info("Copying records in Package Items:"+params);
				this.getSqlMapClient().insert("copyGiuts008PackItems", params);
				this.getSqlMapClient().executeBatch();
				
			}else{
				String menuLineCd = (String) paramValueMap.get("menuLineCd");
				String lineCd	= (String) params.get("nbtLineCd");
				String sublineMOP = (String) paramValueMap.get("sublineMOP");
				String sublineCd = (String) params.get("nbtSublineCd");
				String parType = (String) params.get("parType");
				log.info("Adding items for line="+lineCd+ " menuLineCd="+menuLineCd+" parType="+parType);
				
				if(!(menuLineCd.equals("MN") || lineCd.equals("MN")) && !(sublineMOP.equals(sublineCd))){
					if(!(menuLineCd.equals("AC")) || !(menuLineCd.equals(paramValueMap.get("lineAC")))){
						this.getSqlMapClient().insert("copyLimLiabGiuts008", params);
						this.getSqlMapClient().executeBatch();
					}
					
					log.info("Copying records in GIPI_ITEM:"+params);
					this.getSqlMapClient().insert("copyItemGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					if("P".equals(parType)){
						log.info("Copying records in GIPI_ITMPERIL:"+params);
						this.getSqlMapClient().insert("copyItmperilGiuts008", params);
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().insert("copyPerilDiscountGiuts008", params);
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().insert("copyItemDiscountGiuts008", params);
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().insert("copyPolbasDiscountGiuts008", params);
						this.getSqlMapClient().executeBatch();
					}
				}
				
				if(menuLineCd.equals("AC") || menuLineCd.equals(paramValueMap.get("lineAC"))){
					log.info("Copying records in GIPI_BENEFICIARY:"+params);
					this.getSqlMapClient().insert("copyBeneficiaryGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					log.info("Copying records in GIPI_ACCIDENT_ITEM:"+params);
					this.getSqlMapClient().insert("copyAccidentItemGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}else if(menuLineCd.equals("CA") || menuLineCd.equals(paramValueMap.get("lineCA"))){
					log.info("Copying records in GIPI_CASUALTY_ITEM:"+params);
					this.getSqlMapClient().insert("copyCasualtyItemGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					log.info("Copying records in GIPI_CASUALTY_PERSONNEL:"+params);
					this.getSqlMapClient().insert("copyCasualtyPersonnelGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}else if(menuLineCd.equals("EN") || menuLineCd.equals(paramValueMap.get("lineEN"))){
					log.info("Copying records in GIPI_ENGG_BASIC:"+params);
					this.getSqlMapClient().insert("copyEnggBasicGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					log.info("Copying records in GIPI_LOCATION:"+params);
					this.getSqlMapClient().insert("copyLocationGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					log.info("Copying records in GIPI_PRINCIPAL:"+params);
					this.getSqlMapClient().insert("copyPrincipalGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}else if(menuLineCd.equals("FI") || menuLineCd.equals(paramValueMap.get("lineFI"))){
					log.info("Copying records in GIPI_FIREITM:"+params);
					this.getSqlMapClient().insert("copyFireGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
				}else if(menuLineCd.equals("MC") || menuLineCd.equals(paramValueMap.get("lineMC"))){
					log.info("Copying records in GIPI_VEHICLE:"+params);
					this.getSqlMapClient().insert("copyVehicleGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().insert("copyMcaccGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}else if(menuLineCd.equals("SU") || menuLineCd.equals(paramValueMap.get("lineSU"))){
					log.info("Copying records in GIPI_BOND_BASIC:"+params);
					this.getSqlMapClient().insert("copyBondBasicGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().insert("copyCosignatoryGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}else if(menuLineCd.equals("AV") || menuLineCd.equals(paramValueMap.get("lineAV")) ||
						 menuLineCd.equals("MH") || menuLineCd.equals(paramValueMap.get("lineMH")) ||
						 menuLineCd.equals("MN") || menuLineCd.equals(paramValueMap.get("lineMN"))){
					log.info("Copying "+menuLineCd+" item information: "+params);
					this.getSqlMapClient().insert("copyAviationCargoHullGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}
				
				log.info("Copying records in GIPI_DEDUCTIBLES:"+params);
				this.getSqlMapClient().insert("copyDeductiblesGiuts008", params);
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().insert("copyGroupedItemsGiuts008", params);
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().insert("copyPicturesGiuts008", params);
				this.getSqlMapClient().executeBatch();
				
				if(!(menuLineCd.equals("MN")) && "Y".equals(paramValueMap.get("openFlag"))){
					log.info("Copying records in GIPI_OPEN_LIAB and GIPI_OPEN_PERIL:"+params);
					this.getSqlMapClient().insert("copyOpenLiabGiuts008", params);
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().insert("copyOpenPerilGiuts008", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			this.getSqlMapClient().insert("copyOrigInvoiceGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("copyOrigInvperilGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("copyOrigInvTaxGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("copyOrigItemperilGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("copyCoInsGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			if("Y".equals(itemExists)){
				log.info("Inserting record for Package Invoice:"+params);
				this.getSqlMapClient().insert("copyInvoicePackGiuts008", params);
				this.getSqlMapClient().executeBatch();
			}
			
			log.info("Inserting record for Invoice:"+params);
			this.getSqlMapClient().insert("updateInvoiceGiuts008", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("getGiuts008CopiedPARDetails", params);
			log.info("Successfully copied Policy/Endt to PAR: "+params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
}
