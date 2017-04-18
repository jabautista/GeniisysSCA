package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISPayees;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIWBondBasic;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWBondBasicService;
import com.geniisys.gipi.service.GIPIWEndtTextService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolGeninService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolnrepFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWBondBasicController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWBondBasicController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
			GIPIWBondBasicService gipiWBondBasicService = (GIPIWBondBasicService) APPLICATION_CONTEXT.getBean("gipiWBondBasicService");
			GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService");
			GIPIWPolbasService gipiPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
			GIPIWEndtTextService gipiWEndtTxtService = (GIPIWEndtTextService) APPLICATION_CONTEXT.getBean("gipiWEndtTextService");
			GIPIWPolGeninService gipiWPolGeninService = (GIPIWPolGeninService) APPLICATION_CONTEXT.getBean("gipiWPolGeninService");
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			request.setAttribute("showJCLDetails", giisParametersService.getParamValueV2("OPTION_SHOW_JCL_DETAILS"));
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			GIPIPARList gipiPAR = null;
			if (parId != 0)	{
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				//request.setAttribute("parDetails", gipiPAR);
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiPAR);
			}
			if ("showBondPolicyDataPage".equals(ACTION)){
				log.info("Getting bond policy data page...");
				
				//obtaining bond details
				GIPIWBondBasic bond = gipiWBondBasicService.getGIPIWBondBasic(parId);
				request.setAttribute("bond", bond);
				
				//obtaining obligee listing
				request.setAttribute("obligeeListing", lovHelper.getList(LOVHelper.OBLIGEE_LISTING));
				
				//obtaining principal signor
				String assdNo = (request.getParameter("globalAssdNo") == null) ? "0" : request.getParameter("globalAssdNo");
				System.out.println("assdNo: "+assdNo);
				String[] args = {assdNo};
				request.setAttribute("prinSigListing", lovHelper.getList(LOVHelper.PRINCIPAL_SIGNATORY_LISTING, args));
				
				//obtaining notary public listing
				request.setAttribute("notaryPublicListing", lovHelper.getList(LOVHelper.NOTARY_PUBLIC_LISTING));
				
				//obtaining bond clause listing
				String sublineCd = (request.getParameter("globalSublineCd") == null) ? "" : request.getParameter("globalSublineCd");
				System.out.println("sublineCd: "+sublineCd);
				String[] param = {sublineCd};
				request.setAttribute("bondClauseListing", lovHelper.getList(LOVHelper.BOND_CLAUSE_LISTING, param));
				
				//checks if par exists in winvoice table
				Map<String, String> params = new HashMap<String, String>();
				params = gipiWInvoiceService.isExist(parId);
				String wInvoiceExists = params.get("exist");
				request.setAttribute("wInvoiceExists", wInvoiceExists);
				
				PAGE = "/pages/underwriting/bondPolicyData.jsp";
			}else if ("showEndtBondPolicyDataPage".equals(ACTION)) {
				//obtaining bond details
				log.info("showEndtBondPolicyDataPage");
				GIPIWBondBasic bond = gipiWBondBasicService.getGIPIWBondBasic(parId);
				if(bond == null) {
					System.out.println("null gipi_wbond_basic for par - "+parId);
					bond = gipiWBondBasicService.getBondBasicNewRecord(parId);
				}
				request.setAttribute("bond", bond);
				
				//obtaining obligee listing
				request.setAttribute("obligeeListing", lovHelper.getList(LOVHelper.OBLIGEE_LISTING));
				
				//obtaining notary public listing
				request.setAttribute("notaryPublicListing", lovHelper.getList(LOVHelper.NOTARY_PUBLIC_LISTING));
				
				//obtaining bond clause listing
				String sublineCd = (request.getParameter("globalSublineCd") == null) ? "" : request.getParameter("globalSublineCd");
				System.out.println("sublineCd: "+sublineCd);
				String[] param = {sublineCd};
				request.setAttribute("bondClauseListing", lovHelper.getList(LOVHelper.BOND_CLAUSE_LISTING, param));
				
				//checks if par exists in winvoice table
				Map<String, String> params = new HashMap<String, String>();
				params = gipiWInvoiceService.isExist(parId);
				String wInvoiceExists = params.get("exist");
				request.setAttribute("wInvoiceExists", wInvoiceExists);
				
				PAGE = "/pages/underwriting/endt/bond/endtBondPolicyData.jsp";
			}else if ("saveEndtBondPolicyData".equals(ACTION)) {
				Integer obligeeNo = request.getParameter("obligee") == "" ? null :Integer.parseInt(request.getParameter("obligee"));
				String bondDtl = request.getParameter("bondDtl");
				String indemnityText = request.getParameter("indemnityText");
				Integer npNo = request.getParameter("dspNPName") == "" ? null : Integer.parseInt(request.getParameter("dspNPName"));
				String clauseType = request.getParameter("dspClauseType");
				String collFlag = request.getParameter("dspCollFlag");
				String waiverLimit = request.getParameter("dspWaiverLimit");
				String contractDate = request.getParameter("contractDate");
				String contractDtl = request.getParameter("contractDtl");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("obligeeNo", obligeeNo);
				params.put("bondDtl", bondDtl);
				params.put("indemnityText", indemnityText);
				params.put("npNo", npNo);
				params.put("clauseType", clauseType);
				params.put("collFlag", collFlag);
				params.put("waiverLimit", waiverLimit == null ? null : waiverLimit.replaceAll(",", ""));
				params.put("contractDate", contractDate);
				params.put("contractDtl", contractDtl);
				params.put("plaintiffDtl", request.getParameter("plaintiffDtl"));
				params.put("defendantDtl", request.getParameter("defendantDtl"));
				params.put("civilCaseNo", request.getParameter("civilCaseNo"));
				params.put("deleteBillsSw", request.getParameter("deleteBillsSw")); //marco - delete bill info when clause type is changed - 12.10.2013
				log.info("saveEndtBondPolicyData: "+params);
				gipiWBondBasicService.saveEndtBondPolicyData(params);
				message = "SUCCESSFUL";
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("saveBondPolicyDataPageChanges".equals(ACTION)){
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				
				String deleteBillsSw = request.getParameter("deleteBillsSw");
				params.put("deleteBillsSw", deleteBillsSw);
				
				Map<String, Object> wBondBasic = new HashMap<String, Object>();
				
				Integer obligeeNo = Integer.parseInt((request.getParameter("obligeeNo") == "")? "0" : request.getParameter("obligeeNo"));
				String bondDtl = request.getParameter("bondDtl");
				String indemnityText = request.getParameter("indemnityText");
				String clauseType = request.getParameter("clauseType");
				BigDecimal waiverLimit = new BigDecimal(request.getParameter("dspWaiverLimit")==""? "0": request.getParameter("dspWaiverLimit").replaceAll(",", ""));
				String contractDate = request.getParameter("contractDate");
				String contractDtl = request.getParameter("contractDtl");
				Integer prinId = Integer.parseInt((request.getParameter("prinId") == "")? "0" : request.getParameter("prinId"));
				String coPrinSw = request.getParameter("coPrinSw");
				Integer npNo = Integer.parseInt((request.getParameter("npNo") == "")? "0" : request.getParameter("npNo"));
				String collFlag = request.getParameter("collFlag");
				
				if (obligeeNo == 0){
					obligeeNo = null;
				}
				
				if (prinId == 0){
					prinId = null;
				}
				
				if (npNo == 0){
					npNo = null;
				}
				
				wBondBasic.put("parId", parId);
				wBondBasic.put("obligeeNo", obligeeNo);
				wBondBasic.put("bondDtl", bondDtl);
				wBondBasic.put("indemnityText", indemnityText);
				wBondBasic.put("clauseType", clauseType);
				wBondBasic.put("waiverLimit", waiverLimit);
				wBondBasic.put("contractDate", contractDate);
				wBondBasic.put("contractDtl", contractDtl);
				wBondBasic.put("prinId", prinId);
				wBondBasic.put("coPrinSw", coPrinSw);
				wBondBasic.put("npNo", npNo);
				wBondBasic.put("collFlag", collFlag);
				wBondBasic.put("plaintiffDtl", request.getParameter("plaintiffDtl"));
				wBondBasic.put("defendantDtl", request.getParameter("defendantDtl"));
				wBondBasic.put("civilCaseNo", request.getParameter("civilCaseNo"));
				wBondBasic.put("valPeriod", request.getParameter("valPeriod"));	// shan 10.13.2014
				wBondBasic.put("valPeriodUnit", request.getParameter("valPeriodUnit"));	// shan 10.13.2014
				
				params.put("wBondBasic", wBondBasic);
				
				System.out.println("parId :"+parId);
				System.out.println("obligeeNo :"+obligeeNo);
				System.out.println("bondDtl :"+bondDtl);
				System.out.println("indemnityText :"+indemnityText);
				System.out.println("clauseType :"+clauseType);
				System.out.println("waiverLimit :"+waiverLimit);
				System.out.println("contractDate :"+contractDate);
				System.out.println("contractDtl :"+contractDtl);
				System.out.println("prinId :"+prinId);
				System.out.println("coPrinSw :"+coPrinSw);
				System.out.println("npNo :"+npNo);
				System.out.println("collFlag :"+collFlag);
				
				//get cosignatory details
				String[] cosignIds = request.getParameterValues("cosignId");
				params.put("cosignIds", cosignIds);
				
				if (cosignIds != null){
					for (int i=0; i<cosignIds.length; i++){
						System.out.println("cosignId: "+cosignIds[i]);
					}
					for (int i=0; i<cosignIds.length; i++){
						Map<String, Object> cosignMap = new HashMap<String, Object>();
						
						Integer cosignId =Integer.parseInt(request.getParameter("cosignId"+cosignIds[i]));
						Integer assdNo =Integer.parseInt(request.getParameter("assdNo"+cosignIds[i]));
						String indemFlag = request.getParameter("indemFlag"+cosignIds[i]);
						String bondsFlag = request.getParameter("bondsFlag"+cosignIds[i]);
						String bondsRiFlag = request.getParameter("bondsRiFlag"+cosignIds[i]);
						
						System.out.println("i: "+i);
						System.out.println("CONTROLLER - parId: "+parId);
						System.out.println("CONTROLLER - cosignId: "+cosignId);
						System.out.println("CONTROLLER - assdNo: "+assdNo);
						System.out.println("CONTROLLER - indemFlag: "+indemFlag);
						System.out.println("CONTROLLER - bondsFlag: "+bondsFlag);
						System.out.println("CONTROLLER - bondsRiFlag: "+bondsRiFlag);
						
						cosignMap.put("parId", parId);
						cosignMap.put("cosignId", cosignId);
						cosignMap.put("assdNo", assdNo);
						cosignMap.put("indemFlag", indemFlag);
						cosignMap.put("bondsFlag", bondsFlag);
						cosignMap.put("bondsRiFlag", bondsRiFlag);
						
						params.put(cosignIds[i], cosignMap);
						
					}
				}
				
				gipiWBondBasicService.saveBondPolicyData(params);
				//gipiParService.updatePARStatus(parId, 5);
				
				message = "SUCCESSFUL";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showEndtBondBasicInfo".equals(ACTION)){ //added by angelo 05.05.2011 for endt
				Map<String, Object> jsonParams = new HashMap<String, Object>();
				GIACParameterFacadeService paramService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIPIWPolnrepFacadeService polnrepService = (GIPIWPolnrepFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolnrepFacadeService");
				//GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				Integer parID = Integer.parseInt(request.getParameter("parId"));
				System.out.println("fromPolicyNo === "+parID+" / "+request.getParameter("fromPolicyNo"));
				
				GIPIPARList gipiParList = null;
				GIPIWPolbas gipiWPolbas = null;
				GIPIWPolGenin gipiWPolGenin = null;
				GIPIWEndtText gipiWEndtText = null;
				
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				String msgAlertNull = "Y"; // bonok :: 1.12.2017 :: UCPB SR 23618 :: null pointer exception when params.get("msgAlert") is not null
				
				GIPIPolbasicService polbasic = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				if("Y".equals(request.getParameter("fromPolicyNo"))) {
					Map<String, Object> params = new HashMap<String, Object>();
					GIISAssuredFacadeService giisAssuredService = (GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
					
					params.put("parId", parID);
					params.put("lineCd", request.getParameter("lineCd"));
					params.put("sublineCd", request.getParameter("sublineCd"));
					params.put("issCd", request.getParameter("issCd"));
					params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
					params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
					params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
					params = gipiPolbasService.searchForPolicy(params);
					Debug.print("fromPolicyNo ::: "+params);
					request.setAttribute("confirmResult", request.getParameter("confirmResult")); // jmm SR-22834
					request.setAttribute("newAssdName", request.getParameter("globalAssdName"));
					request.setAttribute("newAssdNo", request.getParameter("globalAssdNo"));
					request.setAttribute("newAddress1", request.getParameter("globalAddress1"));
					request.setAttribute("newAddress2", request.getParameter("globalAddress2"));
					request.setAttribute("newAddress3", request.getParameter("globalAddress3")); // end SR-22834
					if(null != params.get("msgAlert")){
						msgAlertNull = "N"; // bonok :: 1.12.2017 :: UCPB SR 23618 :: null pointer exception when params.get("msgAlert") is not null
						message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";
						request.setAttribute("message", message);
						PAGE = "/pages/genericMessage.jsp";
					} else {
						for(GIPIWPolGenin wPolGenin : (List<GIPIWPolGenin>) params.get("gipiWPolGenin")){								
							gipiWPolGenin = wPolGenin;
						}					
						
						for(GIPIPARList parList : (List<GIPIPARList>) params.get("gipiParlist")){								
							gipiParList = parList;
						}
						
						for(GIPIWPolbas wPolbas : (List<GIPIWPolbas>) params.get("gipiWPolbas")){								
							gipiWPolbas = wPolbas;
						}
						for(GIPIWEndtText wEndtText : (List<GIPIWEndtText>) params.get("gipiWEndtText")){							
							gipiWEndtText = wEndtText;
						}
						
						System.out.println(gipiWPolbas.getParId()+ " /test gipiwpolbas/ "+ gipiWPolbas.getBookingMth() + " // " + 
								gipiWPolbas.getIssueDate());
						System.out.println("MortgName " + gipiWPolbas.getMortgName());
						params.remove("gipiParlist");
						params.remove("gipiWPolbas");
						params.remove("gipiWPolGenin");
						params.remove("gipiWEndtText");
						
						Map<String, Object> newFormInstance = new HashMap<String, Object>();
						newFormInstance.put("parId", parId);
						newFormInstance = gipiPolbasService.gipis031NewFormInstance(newFormInstance);
						//Debug.print("New Form Instance - "+gipiWPolbas.getAssdNo()+"; "+newFormInstance);
						
						if(newFormInstance.get("msgAlert") != null){
							message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";
							request.setAttribute("message", message);
							PAGE = "/pages/genericMessage.jsp";
						}else{
							GIISAssured assured = giisAssuredService.getGIISAssuredByAssdNo(gipiParList.getAssdNo().toString());
							String regionCd = (String) (newFormInstance.get("regionCd") == null ? "" : newFormInstance.get("regionCd").toString());
							//gipiWPolbas.setParId(parID);
							gipiWPolbas.setDspAssdName(assured.getAssdName());
							gipiWPolbas.setRegionCd(regionCd.equals("") ? "15" : regionCd);
							if(gipiWPolbas.getCredBranch() != null) {
								
							} else {
								gipiWPolbas.setCredBranch("HO");
							}
							if(gipiWPolbas.getIssueDate() != null) {
								//gipiWPolbas.setBookingMth(DateUtil.getMonthInWords(gipiWPolbas.getIssueDate()));
								//gipiWPolbas.setBookingYear(Integer.toString(DateUtil.getYear(gipiWPolbas.getIssueDate())));
								gipiWPolbas = gipiPolbasService.updateBookingDates(gipiWPolbas);
							}
						}
						//System.out.println("booking test : "+gipiWPolbas.getBookingMth()+" - "+gipiWPolbas.getBookingYear()
						//		+" // "+gipiWPolbas.getIssueDate()+" / "+gipiWPolbas.getInceptDate());
						gipiParList.setParNo(gipiParService.getParNo(parID));
						
						gipiWPolbas.setBondSeqNo(polbasic.getPolBondSeqNo(request));
						System.out.println("XXXXXXXXXXX "+ gipiWPolbas.getMortgName());
						gipiWPolbas = (GIPIWPolbas) StringFormatter.escapeHTMLInObject(gipiWPolbas); //added by christian 03/04/13
						gipiParList = (GIPIPARList) StringFormatter.escapeHTMLInObject(gipiParList); //added by christian 03/04/13
						DateFormat format = new SimpleDateFormat("MM-dd-yyyy"); //added by robert GENQA SR 4828 08.26.15
						request.setAttribute("defaultExpiryDate", format.format(gipiWPolbas.getExpiryDate())); //added by robert GENQA SR 4828 08.26.15
					}
				} else {
					gipiParList = gipiParService.getGIPIPARDetails(parID);
					//statements below commented for now...
					//gipiWPolbas = gipiPolbasService.getGipiWPolbas(parID);
					//GIPIPARList gipiParList = gipiParService.getGIPIPARDetails(parID);
					List<GIPIWPolnrep> gipiWPolnrep = polnrepService.getWPolnrep(parID);
					//String gipiWEndtText = gipiWEndtTxtService.getEndtText(parID);
					//String gipiWPolGenin = gipiWPolGeninService.getGenInfo(parID);
					gipiWPolGenin = gipiWPolGeninService.getGipiWPolGenin(parID);
					
					Map parsWPolbas = new HashMap();
					parsWPolbas = gipiPolbasService.isExist(parID);
					String isExistWPolbas = (String) parsWPolbas.get("exist");
					System.out.println("isExistWPolbas === "+isExistWPolbas);
					
					if (isExistWPolbas.equals("1")) {
						log.info("Getting gipi_wpolbas...");
						gipiWPolbas = gipiPolbasService.getGipiWPolbas(parID);
						//added by robert GENQA SR 4828 08.26.15
						Map<String, Object> parameters = new HashMap<String, Object>();
						parameters.put("parId", parID);
						parameters.put("lineCd", gipiWPolbas.getLineCd());
						parameters.put("sublineCd", StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())); //Deo [01.03.2017]: added StringFormatter (SR-23567)
						parameters.put("issCd", gipiWPolbas.getIssCd());
						parameters.put("issueYy", Integer.parseInt(gipiWPolbas.getIssueYy().toString()));
						parameters.put("polSeqNo", Integer.parseInt(gipiWPolbas.getPolSeqNo().toString()));
						parameters.put("renewNo", Integer.parseInt(gipiWPolbas.getRenewNo().toString()));
						parameters = gipiPolbasService.searchForPolicy(parameters);
						GIPIWPolbas gipiWPolbas2 = null; 
						for(GIPIWPolbas wPolbas : (List<GIPIWPolbas>) parameters.get("gipiWPolbas")){								
							gipiWPolbas2 = wPolbas;
						}
						DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
						request.setAttribute("defaultExpiryDate", format.format(gipiWPolbas2.getExpiryDate())); 
						//end robert GENQA SR 4828 08.26.15
					} else {
						log.info("Getting gipi_wpolbas default value...");
						gipiWPolbas = gipiPolbasService.getGipiWPolbasDefault(parID);	
					}
					//gipiWPolbas.setBondSeqNo(polbasic.getPolBondSeqNo(request));
					request.setAttribute("gipiWPolbas", gipiWPolbas);
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parID);
					params = gipiPolbasService.getRecordsForService(params);
					
					for(GIPIWEndtText wEndtText : (List<GIPIWEndtText>) params.get("gipiWEndtText")){					
						gipiWEndtText = wEndtText;
					}
					
					if(gipiWEndtText != null) System.out.println("gipiWEndtText == "+gipiWEndtText.getEndtText()+"; "+gipiWEndtText.getEndtText01());
					if(gipiWPolGenin != null) System.out.println("gipiWPolGenin == "+gipiWPolGenin.getGenInfo()+"; "+gipiWPolGenin.getGenInfo01());
					/*String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
					String issCdRI = giisParametersService.getParamValueV2("ISS_CD_RI");

					jsonParams.put("varVDate", paramService.getParamValueN("PROD_TAKE_UP"));
					jsonParams.put("ora2010Sw", ora2010Sw);
					jsonParams.put("issCdRI", issCdRI);*/ // moved by: Nica 06.28.2012
					
					/*jsonParams.put("gipiWPolbas", gipiWPolbas);
					jsonParams.put("gipiParList", gipiParList);
					jsonParams.put("gipiWPolGenin", gipiWPolGenin);
					jsonParams.put("gipiWEndtText", gipiWEndtText);*/
					jsonParams.put("gipiWPolnrep", gipiWPolnrep);
					//for testing
					System.out.println("====================================================");
					System.out.println("Par id : " + gipiWPolbas.getParId());
					System.out.println("Par No : " + gipiParList.getParNo());
					System.out.println("Policy number : " + gipiWPolbas.getLineCd() + "-" + gipiWPolbas.getSublineCd() + "-" + gipiWPolbas.getIssCd() + "-" + gipiWPolbas.getIssueYy() + "-" + gipiWPolbas.getPolSeqNo() + "-" + gipiWPolbas.getRenewNo());
					System.out.println("Endorsement number : " + gipiWPolbas.getLineCd() + "-" + gipiWPolbas.getSublineCd() + "-" + gipiWPolbas.getEndtIssCd() + "-" + gipiWPolbas.getEndtYy());
					System.out.println("Inception date : " + gipiWPolbas.getInceptDate() + "\nExpiry Date : " + gipiWPolbas.getExpiryDate());
					System.out.println("Endt. eff. date : " + gipiWPolbas.getEffDate() + "\nEndt. exp. date : " + gipiWPolbas.getEndtExpiryDate());
					System.out.println("Issue date : " + gipiWPolbas.getIssueDate() + "\nRef bond no. : " + gipiWPolbas.getRefPolNo());
					System.out.println("Policy type : " + gipiWPolbas.getTypeCd() + "\nRegion : " + gipiWPolbas.getRegionCd());
					System.out.println("Assured No : " + gipiWPolbas.getAssdNo() + " / " + gipiParList.getAssdNo());
					System.out.println("Ann Tsi Amt: " + gipiWPolbas.getAnnTsiAmt());
					System.out.println("====================================================");
				}
				
				if(msgAlertNull.equals("Y")){ // bonok :: 1.12.2017 :: UCPB SR 23618 :: null pointer exception when params.get("msgAlert") is not null
					jsonParams.put("gipiWPolbas", gipiWPolbas); //removed StringFormatter.escapeHTMLInObject christian 02/26/2013
					System.out.println("test ann tsi - "+gipiWPolbas.getAssdNo()+" - "+gipiWPolbas.getAnnTsiAmt());
					jsonParams.put("gipiParList", gipiParList); //removed StringFormatter.escapeHTMLInObject christian 02/26/2013
					jsonParams.put("gipiWPolGenin", StringFormatter.escapeHTMLInObject(gipiWPolGenin));
					jsonParams.put("gipiWEndtText", StringFormatter.escapeHTMLInObject(gipiWEndtText));
					
					String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
					String issCdRI = giisParametersService.getParamValueV2("ISS_CD_RI");

					jsonParams.put("varVDate", paramService.getParamValueN("PROD_TAKE_UP"));
					jsonParams.put("ora2010Sw", ora2010Sw);
					jsonParams.put("issCdRI", issCdRI); // moved here Nica 06.28.2012

					//jsonParams = jsonParams;
					log.info("JSONparams:::: "+jsonParams);
					request.setAttribute("jsonParams", new JSONObject(jsonParams));
					request.setAttribute("gipiParList", gipiParList);
					
					String[] args = {lineCd};
					List<LOV> policyTypeList = lovHelper.getList(LOVHelper.POLICY_TYPE_LISTING, args);
					request.setAttribute("policyTypeListing", policyTypeList);
					
					Date date = new Date();
					DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
					String[] argsDate = {format.format(date)};
					List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
					request.setAttribute("bookingMonthListing", bookingMonths);
					
					List<LOV> regionList = lovHelper.getList(LOVHelper.REGION_LISTING);
					request.setAttribute("regionListing", regionList);
					
					String[] args2 = {issCd};
					List<LOV> mortgageeList = lovHelper.getList(LOVHelper.MORTGAGEE_LISTING, args2);				
					request.setAttribute("mortgageeListing", mortgageeList);
					
					List<LOV> industryList = lovHelper.getList(LOVHelper.INDUSTRY_LISTING);
					request.setAttribute("industryListing", industryList);
					
					if(issCd.equals("RI")){ //added by christian 03/20/2013
						List<LOV> branchSourceList = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
						request.setAttribute("branchSourceListing", branchSourceList);
					}else{ //list of issCd excluding RI
						String[] args3 = {"Y"};
						List<LOV> branchSourceList = lovHelper.getList(LOVHelper.GET_ISS_CD_BY_CRED_TAG_EXC_RI, args3);
						request.setAttribute("branchSourceListing", branchSourceList);
					}
					
					List<LOV> takeupTermList = lovHelper.getList(LOVHelper.TAKEUP_TERM_LISTING);
					request.setAttribute("takeupTermListing", takeupTermList);
					
					request.setAttribute("convInceptDate", gipiWPolbas.getInceptDate() == null ? "" : format.format(gipiWPolbas.getInceptDate()));
					request.setAttribute("convEffDate", gipiWPolbas.getEffDate() == null ? "" : format.format(gipiWPolbas.getEffDate()));
					request.setAttribute("convIssDate", gipiWPolbas.getExpiryDate() == null ? "" : format.format(gipiWPolbas.getIssueDate()));
					request.setAttribute("convExpiry", gipiWPolbas.getExpiryDate() == null ? "" : format.format(gipiWPolbas.getExpiryDate()));
					request.setAttribute("convEndtExpiry", gipiWPolbas.getEndtExpiryDate() == null ? "" : format.format(gipiWPolbas.getEndtExpiryDate()));
					request.setAttribute("updIssueDate", giisParametersService.getParamValueV2("UPDATE_ISSUE_DATE")); // added by: Nica 05.14.2012
					request.setAttribute("updateBooking", giisParametersService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.25.2012
					request.setAttribute("showBondSeqNo", giisParametersService.getParamValueV2("SHOW_BOND_SEQ_NO"));
					request.setAttribute("dispDefaultCredBranch", giisParametersService.getParamValueV2("DISPLAY_DEF_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					request.setAttribute("defaultCredBranch", giisParametersService.getParamValueV2("DEFAULT_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					request.setAttribute("reqRefNo", giisParametersService.getParamValueV2("REQUIRE_REF_NO"));	//added by Gzelle 12042014 SR3092
					request.setAttribute("reqRefPolNo", giisParametersService.getParamValueV2("REQUIRE_REF_POL_NO")); //added by gab 02.17.2016
					request.setAttribute("reqCredBranch", giisParametersService.getParamValueV2("MANDATORY_CRED_BRANCH")); // added by apollo 07.24.2015 SR#2749
					
					if (ora2010Sw.equals("Y")) {	//added by Gzelle 12042014 SR 3092
						request.setAttribute("companyListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.COMPANY_LISTING))));
						request.setAttribute("employeeListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.EMPLOYEE_LISTING))));
					}
					//added by robert GENQA SR 4825 08.04.15 checks if par exists in winvoice table
					Map<String, String> params = new HashMap<String, String>();
					params = gipiWInvoiceService.isExist(parID);
					String wInvoiceExists = params.get("exist");
					request.setAttribute("wInvoiceExists", wInvoiceExists);
					//end robert GENQA SR 4825 08.04.15
					//PAGE = "/pages/underwriting/endt/bond/endtBondBasicInformation.jsp";
					PAGE = "/pages/underwriting/endt/bondTest/endtBondBasicInformation.jsp";
				}
			} else if("showEditPolicyNo".equals(ACTION)){
				gipiPolbasService.showEditPolicyNo(request);
				PAGE = "/pages/underwriting/endt/basicInfo/subPages/editPolicyNoForEndt.jsp";
			} else if ("checkPolicy".equals(ACTION)){
				GIPIWPolbasService polBasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",  request.getParameter("lineCd"));
				params.put("sublineCd",  request.getParameter("sublineCd"));
				params.put("issCd",  request.getParameter("issCd"));
				params.put("issueYy",  Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo",  Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo",  Integer.parseInt(request.getParameter("renewNo")));
				
				//check claims
				polBasService.checkPolicyNoForEndt(params);
				
				String paidMsg = gipiPolbasService.checkPaidPolicy(params);
				
				System.out.println(
						"Line Cd : " + params.get("lineCd") + "\n" +
						"Subline Cd : " + params.get("sublineCd") + "\n" +
						"Iss Cd : " + params.get("issCd") + "\n" +
						"Issue Yy : " + params.get("issueYy") + "\n" +
						"Pol Seq No : " + params.get("polSeqNo") + "\n" +
						"Renew No : " + params.get("renewNo"));
				
				//System.out.println("PAID MESSAGE :::: " + paidMsg);
				
				params.put("paidMsg", paidMsg);
				
				System.out.println("Testing variables : " + params.toString());
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateEffDateB5401".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				System.out.println(request.getParameter("expiryDate") + " - " + request.getParameter("inceptDate"));
				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				params.put("polFlag", request.getParameter("polFlag"));
				params.put("expiryDate", df.parse(request.getParameter("expiryDate")));
				params.put("inceptDate", df.parse(request.getParameter("inceptDate")));
				params.put("vOldDate", request.getParameter("vOldDate"));
				params.put("expChgSw", request.getParameter("expChgSw"));
				params.put("vMaxEffDate", request.getParameter("vMaxEffDate"));
				params.put("endtYy", Integer.parseInt("".equals(request.getParameter("endtYy")) || request.getParameter("endtYy")== null ? "0" : request.getParameter("endtYy")));
				params.put("effDate", request.getParameter("effDate"));
				
				System.out.println("testing : " + params.get("effDate"));
				params = gipiPolbasService.validateEffDateB5401(params);
				log.info("action validateEffDateB5401 controller - "+params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("checkForAvailableEndt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",  request.getParameter("lineCd"));
				params.put("sublineCd",  request.getParameter("sublineCd"));
				params.put("issCd",  request.getParameter("issCd"));
				params.put("issueYy",  Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo",  Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo",  Integer.parseInt(request.getParameter("renewNo")));
				
				message = gipiPolbasService.checkAvailableEndt(params).toString();
				System.out.println("MESSAGE :::: " + message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkExistence".equals(ACTION)){
				System.out.println("testing :::::: " + request.getParameter("parId"));
				if ("peril".equals(request.getParameter("code"))){
					GIPIWItemPerilService itmPerlService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					message = itmPerlService.checkPerilExist(Integer.parseInt(request.getParameter("parId"))).toString();
				} else if ("item".equals(request.getParameter("code"))){
					GIPIWItemService itemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
					message = itemService.checkItemExist(Integer.parseInt(request.getParameter("parId"))).toString();
				}
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCancellationLOV".equals(ACTION)){
				GIPIPolbasicService polbasService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				List<GIPIPolbasic>  polbasListing = new ArrayList<GIPIPolbasic>();
				GIPIPolbasic polbas = new GIPIPolbasic();
				polbas.setLineCd(request.getParameter("lineCd"));
				polbas.setSublineCd(request.getParameter("sublineCd"));
				polbas.setIssCd(request.getParameter("issCd"));
				polbas.setIssueYy(Integer.parseInt(request.getParameter("issueYy")));
				polbas.setPolSeqNo(Integer.parseInt(request.getParameter("polSeqNo")));
				polbas.setRenewNo(Integer.parseInt(request.getParameter("renewNo")));
				
				polbasListing = polbasService.getEndtCancellationLOV(polbas, request.getParameter("lovType"));
				//request.setAttribute("polbasListing", new JSONArray(polbasListing));
				request.setAttribute("polbasListing", polbasListing);
				PAGE = "/pages/underwriting/endt/bond/subPages/cancellationLOV.jsp";
			} else if ("saveEndtBondBasicInfo".equals(ACTION)){
				//testing for endt bond basic info saving...
				log.info("TESTING NA NAMAN (saveEndtBondBasicInfo)... " + request.getParameter("parameters"));
				
				//Map<String, Object> params = new HashMap<String, Object>();
				String params = request.getParameter("parameters");
				
				//GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
				//GIPIWEndtText gipiWEndtText = new GIPIWEndtText();
				//GIPIWPolnrep gipiWPolnrep = new GIPIWPolnrep();
				//GIPIWPolGenin gipiWPolGenin = new GIPIWPolGenin();
				//gipiWPolbas = prepareGipiWPolbas(request, response, USER);
				//lines below are commented for now...
				//gipiWEndtText = prepareEndtText(request, response, USER);
				//gipiWPolGenin = preparePolGenin(request, response, USER);
				
				//classes
				//params.put("gipiWPolbas", gipiWPolbas);
				//params.put("gipiWEndtText", gipiWEndtText);
				//params.put("gipiWPolGenin", gipiWPolGenin);
				//params.put("gipiWPolnrep", gipiWPolnrep);
				
				//hidden parameter fields...
				//prepareGipis165Var(request, response, params);
				
				//line for saving gipiWPolbas goes here...
				//Map<String, Object> paramsResult = new HashMap<String, Object>();
				//paramsResult = gipiPolbasService.saveGipiWPolbasForEndtBond(params);
				gipiPolbasService.saveGipiWPolbasForEndtBond2(params, USER);

				//message = (new JSONObject(StringFormatter.replaceQuotesInMap(paramsResult))).toString();
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getBancassuranceDtl".equals(ACTION)){
				GIPIWPolbas endtBancaDtl = gipiPolbasService.getEndtBancassuranceDtl(parId);
				if (endtBancaDtl != null){
					request.setAttribute("endtBancassuranceDtls", endtBancaDtl);
				}
				
				PAGE = "/pages/underwriting/endt/bond/subPages/endtPolicyBancassuranceDtl.jsp";
				
			}else if("showLandCarrierDtl".equals(ACTION)){
				JSONObject json = gipiWBondBasicService.showLandCarrierDtl(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("globalParId", parId);
					request.setAttribute("itemNo", gipiWBondBasicService.getMaxItemNoLandCarrierDtl(parId));
					request.setAttribute("jsonLandCarrierDtlList", json);
					PAGE = "/pages/underwriting/landCarrierDetails.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valAddLandCarrierDtl".equals(ACTION)){
				gipiWBondBasicService.valAddLandCarrierDtl(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveLandCarrierDtl".equals(ACTION)) {
				gipiWBondBasicService.saveLandCarrierDtl(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";	
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
/*	public Map<String, Object> prepareGipis165Var(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params){
		params.put("mortgCd", request.getParameter("mortgCd"));
		params.put("ora2010Sw", request.getParameter("ora2010Sw"));
		params.put("issCdRI", request.getParameter("issCdRI"));
		params.put("endtCancellationFlag", request.getParameter("endtCancellationFlag"));
		params.put("coiCancellationFlag", request.getParameter("coiCancellationFlag"));
		params.put("varCancellationFlag", request.getParameter("varCancellationFlag"));
		params.put("varCnclldFlatFlag", request.getParameter("varCnclledFlatFlag"));
		params.put("varCnclldFlag", request.getParameter("varCnclldFlag"));
		
		params.put("varPolChangedSw", request.getParameter("varPolChangedSw"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw" ));
		params.put("globalCg$BackEndt", request.getParameter("globalCg$BackEndt"));
		params.put("parSysdateSw", request.getParameter("parSysdateSw"));
		params.put("parBackEndtSw", request.getParameter("parBackEndtSw"));
		
		params.put("blockFlag", request.getParameter("blockFlag"));
		params.put("mplSwitch", request.getParameter("mplSwitch"));
		params.put("clearInvoiceSw", request.getParameter("clearInvoiceSw"));
		params.put("varMaxEffDate", request.getParameter("varMaxEffDate"));
		params.put("polChangedSw", request.getParameter("polChangedSw"));
		params.put("expChgSw", request.getParameter("expChgSw"));
		params.put("changeSw", request.getParameter("changeSw"));
		
		params.put("firstEndtSw", request.getParameter("firstEndtSw"));
		params.put("confirmSw", request.getParameter("confirmSw"));
		params.put("cancelPolId", request.getParameter("cancelPolId"));
		params.put("endtPolId", request.getParameter("endtPolId"));
		params.put("varNDate", request.getParameter("varNDate"));
		params.put("varIDate", request.getParameter("varIDate"));
		params.put("varVDate", request.getParameter("varVDate"));
		
		params.put("delBillTbls", request.getParameter("delBillTbls"));
		
		return params;
	}
	
	public GIPIWPolGenin preparePolGenin(HttpServletRequest request, HttpServletResponse response, GIISUser USER) {
		GIPIWPolGenin polGenin = new GIPIWPolGenin();
		Integer parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		polGenin.setParId(parId);
		polGenin.setUserId(USER.getUserId());
		polGenin.setGenInfo(request.getParameter("generalInfo"));
		polGenin.setGenInfo01(request.getParameter("genInfo01"));
		polGenin.setGenInfo02(request.getParameter("genInfo02"));
		polGenin.setGenInfo03(request.getParameter("genInfo03"));
		polGenin.setGenInfo04(request.getParameter("genInfo04"));
		polGenin.setGenInfo05(request.getParameter("genInfo05"));
		polGenin.setGenInfo06(request.getParameter("genInfo06"));
		polGenin.setGenInfo07(request.getParameter("genInfo07"));
		polGenin.setGenInfo08(request.getParameter("genInfo08"));
		polGenin.setGenInfo09(request.getParameter("genInfo09"));
		polGenin.setGenInfo10(request.getParameter("genInfo10"));
		polGenin.setGenInfo11(request.getParameter("genInfo11"));
		polGenin.setGenInfo12(request.getParameter("genInfo12"));
		polGenin.setGenInfo13(request.getParameter("genInfo13"));
		polGenin.setGenInfo14(request.getParameter("genInfo14"));
		polGenin.setGenInfo15(request.getParameter("genInfo15"));
		polGenin.setGenInfo16(request.getParameter("genInfo16"));
		polGenin.setGenInfo17(request.getParameter("genInfo17"));
		
		return polGenin;
	}
	
	public GIPIWEndtText prepareEndtText(HttpServletRequest request, HttpServletResponse response, GIISUser USER) {
		GIPIWEndtText endtText = new GIPIWEndtText();
		Integer parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		endtText.setParId(parId);
		endtText.setEndtCd(request.getParameter("endtCd"));
		endtText.setUserId(USER.getUserId());
		endtText.setEndtText01(request.getParameter("endtText01"));
		endtText.setEndtText02(request.getParameter("endtText02"));
		endtText.setEndtText03(request.getParameter("endtText03"));
		endtText.setEndtText04(request.getParameter("endtText04"));
		endtText.setEndtText05(request.getParameter("endtText05"));
		endtText.setEndtText06(request.getParameter("endtText06"));
		endtText.setEndtText07(request.getParameter("endtText07"));
		endtText.setEndtText08(request.getParameter("endtText08"));
		endtText.setEndtText09(request.getParameter("endtText09"));
		endtText.setEndtText10(request.getParameter("endtText10"));
		endtText.setEndtText11(request.getParameter("endtText11"));
		endtText.setEndtText12(request.getParameter("endtText12"));
		endtText.setEndtText13(request.getParameter("endtText13"));
		endtText.setEndtText14(request.getParameter("endtText14"));
		endtText.setEndtText15(request.getParameter("endtText15"));
		endtText.setEndtText16(request.getParameter("endtText16"));
		endtText.setEndtText17(request.getParameter("endtText17"));
		
		return endtText;
	}
	
	public GIPIWPolbas prepareGipiWPolbas(HttpServletRequest request, HttpServletResponse response, GIISUser USER) throws ParseException {
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		Integer parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		gipiWPolbas.setParId(parId);
		gipiWPolbas.setUserId(USER.getUserId());
		gipiWPolbas.setLineCd(request.getParameter("txtLineCd"));
		gipiWPolbas.setSublineCd(request.getParameter("txtSublineCd"));
		gipiWPolbas.setIssCd(request.getParameter("txtIssCd"));
		gipiWPolbas.setIssueYy(Integer.parseInt(request.getParameter("txtIssueYy")));
		gipiWPolbas.setPolSeqNo(Integer.parseInt(request.getParameter("txtPolSeqNo")));
		gipiWPolbas.setRenewNo(request.getParameter("txtRenewNo"));
		
		gipiWPolbas.setInceptDate(sdf.parse(request.getParameter("doi")));
		gipiWPolbas.setEffDate(sdf.parse(request.getParameter("doe")));
		gipiWPolbas.setIssueDate(sdf.parse(request.getParameter("issDate")));
		gipiWPolbas.setTypeCd(request.getParameter("polType"));
		gipiWPolbas.setAddress1(request.getParameter("add1"));
		gipiWPolbas.setAddress2(request.getParameter("add2"));
		gipiWPolbas.setAddress3(request.getParameter("add3"));
		gipiWPolbas.setBookingMth(request.getParameter("bookingMth"));
		gipiWPolbas.setBookingYear(request.getParameter("bookingYear"));
		gipiWPolbas.setTakeupTerm(request.getParameter("takeupTermType"));
		
		gipiWPolbas.setAssdNo(request.getParameter("assuredNo"));
		gipiWPolbas.setDspAssdName(request.getParameter("dspAssdName"));
		gipiWPolbas.setEndtIssCd(request.getParameter("txtEndtIssCd"));
		gipiWPolbas.setEndtYy(request.getParameter("txtEndtIssueYy"));
		gipiWPolbas.setExpiryDate(sdf.parse(request.getParameter("bondExpiry")));
		gipiWPolbas.setEndtExpiryDate(sdf.parse(request.getParameter("eed")));
		gipiWPolbas.setRefPolNo(request.getParameter("refPolNo"));
		gipiWPolbas.setRegionCd(request.getParameter("region"));
		gipiWPolbas.setMortgName(request.getParameter("mortgagee"));
		gipiWPolbas.setIndustryCd(request.getParameter("industry"));
		gipiWPolbas.setCredBranch(request.getParameter("creditedBranch"));
		
		gipiWPolbas.setInceptTag((request.getParameter("inceptTag") == null) || (request.getParameter("inceptTag") == "") ? "N" : request.getParameter("inceptTag"));
		gipiWPolbas.setExpiryTag((request.getParameter("expiryTag") == null) || (request.getParameter("expiryTag") == "") ? "N" : request.getParameter("expiryTag"));
		gipiWPolbas.setEndtExpiryTag((request.getParameter("endtExpiryTag") == null) || (request.getParameter("endtExpiryTag") == "") ? "N" : request.getParameter("endtExpiryTag"));
		
		gipiWPolbas.setRegPolicySw((request.getParameter("regPolSw") == null) || (request.getParameter("regPolSw") == "") ? "N" : request.getParameter("regPolSw"));
		gipiWPolbas.setForeignAccSw((request.getParameter("foreignAccSw") == null) || (request.getParameter("foreignAccSw") == "") ? "N" : request.getParameter("foreignAccSW"));
		gipiWPolbas.setInvoiceSw((request.getParameter("invoiceSw") == null) || (request.getParameter("invoiceSw") == "") ? "N" : request.getParameter("invoiceSw"));
		gipiWPolbas.setAutoRenewFlag((request.getParameter("autoRenewFlag") == null) || (request.getParameter("autoRenewFlag") == "") ? "N" : request.getParameter("autoRenewFlag"));
		gipiWPolbas.setProvPremTag((request.getParameter("provPremTag") == null) || (request.getParameter("provPremTag") == "") ? "N" : request.getParameter("provPremTag"));
		gipiWPolbas.setPackPolFlag((request.getParameter("packPolFlag") == null) || (request.getParameter("packPolFlag") == "") ? "N" : request.getParameter("packPolFlag"));
		gipiWPolbas.setCoInsuranceSw((request.getParameter("coInsuranceSw") == null) || (request.getParameter("coInsuranceSw") == "") ? "N" : request.getParameter("coInsuranceSw"));
        
		System.out.println("testing for endt bond basic controller : " + request.getParameter("polType"));
		
		return gipiWPolbas;
	}*/
}
