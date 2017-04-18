package com.geniisys.gipi.controllers;

import java.io.IOException; 
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIGroupedItems;
import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIItmPerilGrouped;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWAccidentItem;
import com.geniisys.gipi.entity.GIPIWBeneficiary;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWAccidentItemService;
import com.geniisys.gipi.service.GIPIWBeneficiaryService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.geniisys.gipi.service.GIPIWGrpItemsBeneficiaryService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWItmperlBeneficiaryService;
import com.geniisys.gipi.service.GIPIWItmperlGroupedService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.geniisys.gipi.util.GIPIWDeductiblesUtil;
import com.geniisys.gipi.util.GIPIWItemPerilUtil;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWAccidentItemController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWAccidentItemController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/* default attributes */			
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			//int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
			int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
			
			if (parId == 0) {
				message = "PAR No. is empty";
				PAGE = "/pages/genericMessage.jsp";
			} else {
				GIPIPARList gipiPAR = null;
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				request.setAttribute("parDetails", gipiPAR);
				System.out.println("discExists: "+gipiPAR.getDiscExists());
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				int wItemCount = gipiWItemService.getWItemCount(parId);
				request.setAttribute("wItemParCount", wItemCount);
				GIPIWAccidentItemService gipiWAccidentItemService = (GIPIWAccidentItemService)  APPLICATION_CONTEXT.getBean("gipiWAccidentItemService");
				if("showAccidentItemInfo".equals(ACTION)){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					//GIPIWAccidentItemService gipiWAccidentItemService = (GIPIWAccidentItemService)  APPLICATION_CONTEXT.getBean("gipiWAccidentItemService");
					GIPIWBeneficiaryService gipiWBeneficiaryService = (GIPIWBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWBeneficiaryService");
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					
					GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
					
					String lineCd = par.getLineCd();
					String sublineCd = par.getSublineCd();
					String assdNo = par.getAssdNo();
					request.setAttribute("fromDate", sdf.format(par.getInceptDate()));
					request.setAttribute("toDate", sdf.format(par.getExpiryDate()));
					
					request.setAttribute("parId", parId);
					request.setAttribute("lineCd", lineCd);
					request.setAttribute("sublineCd", sublineCd);
					request.setAttribute("parNo", request.getParameter("globalParNo"));
					request.setAttribute("assdName", request.getParameter("globalAssdName"));
					
					String[] lineSubLineParams = {par.getLineCd(), par.getSublineCd()};
					request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));	
					request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
					
					String[] groupParam = {assdNo};					
					request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
					
					//added for endt
					request.setAttribute("distNo", gipiPAR.getDistNo());
					request.setAttribute("gipiWInvoiceExist", gipiPAR.getGipiWInvoiceExist());
					request.setAttribute("gipiWInvTaxExist", gipiPAR.getGipiWInvTaxExist());
					
					/* Perils*/
					String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
					request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
					
					String[] planParam = {lineCd,sublineCd};					
					request.setAttribute("plans", helper.getList(LOVHelper.PACKAGE_BENEFIT_LISTING, planParam));
					request.setAttribute("payTerms", helper.getList(LOVHelper.PAYTERM_LISTING));
					String[] benParam = {lineCd};
					List<LOV> benDtlsListing = helper.getList(LOVHelper.PACKAGE_BENEFIT_DTL_LISTING, benParam);
					StringFormatter.replaceQuotesInList(benDtlsListing);
					
					request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));
					String[] civilStat = {"CIVIL STATUS"};
					request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
					request.setAttribute("benDtlsListing", new JSONArray(benDtlsListing));
					request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiWItemService.getGIPIWItem(parId)));
					
					List<GIPIWAccidentItem> accidentItems = gipiWAccidentItemService.getGipiWAccidentItem(parId);
					List<GIPIWBeneficiary> beneficiaryItems = gipiWBeneficiaryService.getGipiWBeneficiary(parId);
					
					int itemSize = 0;
					itemSize = accidentItems.size();
					StringBuilder arrayItemNo = new StringBuilder(itemSize);
					for(GIPIWAccidentItem ca : accidentItems){
						arrayItemNo.append(ca.getItemNo() + " ");
						System.out.println("HERE"+ca.getCurrencyRt());
					}
					request.setAttribute("items", accidentItems);
					
					request.setAttribute("itemNumbers", arrayItemNo);
					request.setAttribute("gipiWBeneficiary", beneficiaryItems);
					request.setAttribute("wPolBasic", par);
					GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					String issCdRi = serv.getParamValueV2("ISS_CD_RI");
					request.setAttribute("issCdRi", issCdRi);
					request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
					GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
					String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
					request.setAttribute("pDeductibleExist", pDeductibleExist);
					
					PAGE = "/pages/underwriting/itemInformation.jsp";
					//for endt par. Aug 10, 2010. By irwin
					String parType = request.getParameter("globalParType");
										
					if("E".equals(parType)){
						GIPIWItmperlGroupedService gipiWItmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
						GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService = (GIPIWGrpItemsBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWGrpItemsBeneficiaryService");
						GIPIWItmperlBeneficiaryService gipiWItmperlBeneficiaryService = (GIPIWItmperlBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWItmperlBeneficiaryService");
						
						System.out.println("ParType is: "+parType);
						String policyNo = request.getParameter("globalEndtPolicyNo");
						request.setAttribute("parType", parType);
						request.setAttribute("policyNo", policyNo);
						
						request.setAttribute("accidentItems", new JSONArray(accidentItems));
						
						GIPIWGroupedItemsService gipiWGroupedItemsService = (GIPIWGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiWGroupedItemsService");
					    List<GIPIWGroupedItems> groupedItems = new ArrayList<GIPIWGroupedItems>();
					    List<GIPIWItmperlGrouped> coverageItems = new ArrayList<GIPIWItmperlGrouped>();
					    List<GIPIWGrpItemsBeneficiary> groupedBenItems = new ArrayList<GIPIWGrpItemsBeneficiary>();
					    List<GIPIWItmperlBeneficiary> beneficiaryPerils = new ArrayList<GIPIWItmperlBeneficiary>();
					    
						for (GIPIWAccidentItem ai : accidentItems){
							//System.out.println("Item No. " + ai.getItemNo() + " has " + ai.getNoOfPersons());
							if ((Integer.parseInt(ai.getItemNo())) > 1){
								groupedItems = gipiWGroupedItemsService.getGipiWGroupedItems(parId);
								coverageItems = gipiWItmperlGroupedService.getGipiWItmperlGrouped2(parId);
								groupedBenItems = gipiWGrpItemsBeneficiaryService.getGipiWGrpItemsBeneficiary2(parId);
								beneficiaryPerils = gipiWItmperlBeneficiaryService.getGipiWItmperlBeneficiary2(parId);
							}
						}
						
						request.setAttribute("gipiWGroupedItems", new JSONArray(groupedItems));
						request.setAttribute("gipiWCoverageItems", new JSONArray(coverageItems));
						request.setAttribute("gipiWGroupedBenItems", new JSONArray(groupedBenItems));
						request.setAttribute("gipiWGroupedBenPerils", new JSONArray(beneficiaryPerils));
						
						request.setAttribute("wPolBasic", par);
						
						PAGE = "/pages/underwriting/endt/accident/endtAccidentItemInformationMain.jsp";
					}					
				}else if("showEndtAccidentItemInfo".equals(ACTION)){
					GIPIWAccidentItemService accService = (GIPIWAccidentItemService) APPLICATION_CONTEXT.getBean("gipiWAccidentItemService");
					
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(accService.gipis065NewFormInstance(params)));
					
					message = "SUCCESS";
					PAGE = "/pages/underwriting/endt/jsonAccident/endtAccidentItemInformationMain.jsp";					
				} else if("showPersonalAdditionalInfoOverlay".equals(ACTION)){	
					List<GIPIWAccidentItem> accidentItem = gipiWAccidentItemService.getGipiWAccidentItem(parId);
					String itemNo = request.getParameter("itemNo");
					String age = "";
					String height = "";
					String weight = "";
					String civilStatus = "";
					String sex = "";
					
					String groupPrintSw = "";
					String acClassCd = "";
					String levelCd = "";
					String parentLevelCd = "";
					String itemWItmPerlExist = "";
					String itemWItmPerlGroupedExist = "";
					String populatePerils = "";
					String itemWGroupedItemsExist = "";
					String accidentDeleteBill = "";
					
					Date dateOfBirth = new Date();
					
					for (GIPIWAccidentItem a : accidentItem){
						if (a.getItemNo().equals(itemNo)){
							dateOfBirth = a.getDateOfBirth();
							age = a.getAge() == null ? "0" : a.getAge();
							height = a.getHeight();
							weight = a.getWeight();
							civilStatus = a.getCivilStatus();
							sex = a.getSex();
							
							groupPrintSw = a.getGroupPrintSw();
							acClassCd = a.getAcClassCd();
							levelCd = a.getLevelCd();
							parentLevelCd = a.getParentLevelCd();
							itemWItmPerlExist = a.getItemWitmperlExist();
							itemWItmPerlGroupedExist = a.getItemWitmperlGroupedExist();
							populatePerils = a.getPopulatePerils();
							itemWGroupedItemsExist = a.getItemWgroupedItemsExist();
							accidentDeleteBill = a.getAccidentDeleteBills();							
						}
												
					}

					request.setAttribute("dateOfBirth", dateOfBirth);
					request.setAttribute("age", age);
					request.setAttribute("sex", sex);
					request.setAttribute("civilStatus", civilStatus);
					request.setAttribute("height", height);
					request.setAttribute("weight", weight);
					
					request.setAttribute("groupPrintSw", groupPrintSw);
					request.setAttribute("acClassCd", acClassCd);
					request.setAttribute("levelCd", levelCd);
					request.setAttribute("parentLevelCd", parentLevelCd);
					request.setAttribute("itemWItmPerlExist", itemWItmPerlExist);
					request.setAttribute("itemWItmPerlGroupedExist", itemWItmPerlGroupedExist);
					request.setAttribute("populatePerils", populatePerils);
					request.setAttribute("itemWGroupedItemsExist", itemWGroupedItemsExist);
					request.setAttribute("accidentDeleteBill", accidentDeleteBill);
					
					String[] civilStat = {"CIVIL STATUS"};
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
					
					System.out.println("dumaan naman sa personal additional information ah...");
					
					PAGE = "/pages/underwriting/endt/accident/pop-ups/accidentEndtPersonalAdditionalInfo.jsp";
				} else if("saveGipiParAccidentItem".equals(ACTION)){	
					//GIPIWAccidentItemService gipiWAccidentItemService = (GIPIWAccidentItemService)  APPLICATION_CONTEXT.getBean("gipiWAccidentItemService");
					List<GIPIWAccidentItem> accidentItems = new ArrayList<GIPIWAccidentItem>();
					List<GIPIWBeneficiary> beneficiaryItems = new ArrayList<GIPIWBeneficiary>();
					Map<String, Object> globals = new HashMap<String, Object>();
					Map<String, Object> vars = new HashMap<String, Object>();
					Map<String, Object> pars = new HashMap<String, Object>();
					Map<String, Object> others = new HashMap<String, Object>();
					Map<String, Object> param = new HashMap<String, Object>();
					JSONObject params = new JSONObject(request.getParameter("parameters"));
					
					// item deductibles
					String[] insDedItemNos = request.getParameterValues("insDedItemNo2");
					String[] delDedItemNos = request.getParameterValues("delDedItemNo2");
					if(insDedItemNos != null){
						param.put("deductibleInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 2));
					}
					if(delDedItemNos != null){
						param.put("deductibleDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 2));
					}
					
					// item perils
					/*String[] insItemPerilItemNos 	= request.getParameterValues("perilItemNos");
					String[] delItemPerilItemNos 	= request.getParameterValues("delPerilItemNos");
					if(insItemPerilItemNos != null){
						param.put("itemPerilInsList", GIPIWItemPerilUtil.prepareInsItemPerilList(request));						
					}
					if(delItemPerilItemNos != null){						
						param.put("itemPerilDelList", GIPIWItemPerilUtil.prepareDelGipiWDeductiblesList(request));
					}*/
					
					// peril deductibles
					String[] insPerilDedItemNos	= request.getParameterValues("insDedItemNo3");
					String[] delPerilDedItemNos = request.getParameterValues("delDedItemNo3");
					if(insPerilDedItemNos != null){
						param.put("perilDedInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 3));
					}
					if(delPerilDedItemNos != null){
						param.put("perilDedDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 3));
					}
					
					accidentItems = prepareAccidentItems(request);
					beneficiaryItems = prepareBeneficiaryItems(request);
					
					String[] delItemNos					= request.getParameterValues("delItemNos");	
					String[] delBeneficiaryItemNos		= request.getParameterValues("delBeneficiaryItemNos");
					String[] delBeneficiaryNos			= request.getParameterValues("delBeneficiaryNos");
					
					String element = "";
					for(Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();){
						element = e.nextElement();
						//System.out.println("Element: " + element);
						if("var".equals(element.substring(0, 3))){
							vars.put(element, request.getParameter(element));
						}else if("par".equals(element.substring(0, 3))){
							pars.put(element, request.getParameter(element));
						}else if(element.contains("global")){
							globals.put(element, request.getParameter(element));
						}else{
							others.put(element, request.getParameter(element));
						}
					}
					
					// add peril variables to map
					param = GIPIWItemPerilUtil.loadPerilVariablesToMap(request, param);		
					
					param.put("accidentItems",accidentItems);
					param.put("beneficiaryItems",beneficiaryItems);
					param.put("delItemNos",delItemNos);
					param.put("delBeneficiaryItemNos",delBeneficiaryItemNos);
					param.put("delBeneficiaryNos",delBeneficiaryNos);
					param.put("parId", parId);
					param.put("userId", USER.getUserId());
					param.put("itemList", GIPIWItemUtil.prepareGIPIWItems(request));
					param.put("delItemMap", GIPIWItemUtil.prepareGipiWItemForDelete(request));
					param.put("globals", globals);
					param.put("vars", vars);
					param.put("pars", pars);
					param.put("others", others);
					param.put("gipiParList", GIPIPARUtil.prepareGIPIParList(request));
					//gipiWAccidentItemService.saveGIPIParAccidentItem(param);
					
					/****Added for JSON implementation******* BJGA 11.30.2010***/
					GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					param.put("perilInsList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("setPerils"))));
					param.put("perilDelList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("delPerils"))));
					
					GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
					param.put("wcInsList", gipiWPolWCService.prepareGIPIWPolWCForInsert(new JSONArray(params.getString("setWCs"))));
					
					if (gipiWAccidentItemService.saveAccidentItem(param)){
						message = "SUCCESS";
					}else{
						message = "FAILED";
					}
					
					PAGE = "/pages/genericMessage.jsp";
				} else if("saveEndtAccidentItemInfoPage".equals(ACTION)){
					System.out.println("action is "+ACTION);
					String sublineCd = request.getParameter("globalSublineCd");
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					String invoiceSw 		= request.getParameter("invoiceSw");
					String varPost 			= request.getParameter("varPost");
					String gipiWItemExist = request.getParameter("gipiWItemExist");
					String gipiWItemPerilExist = request.getParameter("gipiWItemPerilExist");
					String gipiWInvoiceExist   = request.getParameter("gipiWInvoiceExist") == "1"? "Y" : "N";
					String gipiWInvTaxExist   = request.getParameter("gipiWInvTaxExist") == "1"? "Y" : "N";
					String aItem			= request.getParameter("aItem");
					String aPeril			= request.getParameter("aPeril");
					Integer distNo			= Integer.parseInt(request.getParameter("distNo").equals("") ? "0" : request.getParameter("distNo"));
					Integer itemRecANoPerilCount = Integer.parseInt(request.getParameter("itemRecANoPerilCount"));
					String packPolFlag		= request.getParameter("packPolFlag");
					String varGroupSw		= request.getParameter("varGroupSw");
					
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> items = new HashMap<String, Object>();
					Map<String, Object> itemAcc = new HashMap<String, Object>();
					Map<String, Object> beneficiaryItems = new HashMap<String, Object>();
					params.put("varPost", varPost);
					params.put("userId", USER.getUserId());
					params.put("invoiceSw", invoiceSw);
					params.put("gipiWItemExist", gipiWItemExist);
					params.put("gipiWItemPerilExist", gipiWItemPerilExist);
					params.put("gipiWInvoiceExist", gipiWInvoiceExist);
					params.put("gipiWInvTaxExist", gipiWInvTaxExist);
					params.put("itemRecANoPerilCount", itemRecANoPerilCount);
					params.put("distNo", distNo);
					params.put("aItem", aItem);
					params.put("aPeril", aPeril);
					
					//added parameters
					params.put("lineCd", request.getParameter("globalLineCd"));
					params.put("issCd", request.getParameter("globalIssCd"));
					
					System.out.println("issCd : " + request.getParameter("globalIssCd"));
					System.out.println("lineCd : " + request.getParameter("globalLineCd"));
					
					params.put("packPolFlag", packPolFlag);
					System.out.println("user is "+USER.getUserId());
					System.out.println("(controller)gipiWItemExist?: "+gipiWItemExist);
					if(request.getParameterValues("itemItemNos") != null){
						String delPolDed = request.getParameter("delPolDed");
						String[] itemNos		= request.getParameterValues("itemItemNos");
						params.put("delPolDed", delPolDed);
						params.put("itemNos", itemNos);
						
						//getting GIPIItem details 
						//String[] delItemNos			= request.getParameterValues("delItemNos");	
						String[] parIds				= request.getParameterValues("itemParIds");
						String[] itemTitles			= request.getParameterValues("itemItemTitles");
						String[] itemGrps			= request.getParameterValues("itemItemGrps");
						String[] itemDescs			= request.getParameterValues("itemItemDescs");
						String[] itemDesc2s			= request.getParameterValues("itemItemDesc2s");
						String[] tsiAmts			= request.getParameterValues("itemTsiAmts");
						String[] premAmts			= request.getParameterValues("itemPremAmts");
						String[] annPremAmts		= request.getParameterValues("itemAnnPremAmts");
						String[] annTsiAmts			= request.getParameterValues("itemAnnTsiAmts");
						String[] recFlags			= request.getParameterValues("itemRecFlags");
						String[] currencyCds		= request.getParameterValues("itemCurrencyCds");
						String[] currencyRts		= request.getParameterValues("itemCurrencyRts");
						String[] groupCds			= request.getParameterValues("itemGroupCds");
						String[] fromDates			= request.getParameterValues("itemFromDates");
						String[] toDates			= request.getParameterValues("itemToDates");
						String[] packLineCds		= request.getParameterValues("itemPackLineCds");
						String[] packSublineCds		= request.getParameterValues("itemPackSublineCds");
						String[] discountSws		= request.getParameterValues("itemDiscountSws");
						String[] coverageCds		= request.getParameterValues("itemCoverageCds");
						String[] otherInfos			= request.getParameterValues("itemOtherInfos");
						String[] surchargeSws		= request.getParameterValues("itemSurchargeSws"); 
						String[] regionCds			= request.getParameterValues("itemRegionCds");
						String[] changedTags		= request.getParameterValues("itemChangedTags");
						String[] prorateFlags		= request.getParameterValues("itemProrateFlags");
						String[] compSws			= request.getParameterValues("itemCompSws");
						String[] shortRtPercents	= request.getParameterValues("itemShortRtPercents");
						String[] packBenCds			= request.getParameterValues("itemPackBenCds");
						String[] paytTermss			= request.getParameterValues("itemPaytTermss");
						String[] riskNos			= request.getParameterValues("itemRiskNos");
						String[] riskItemNos		= request.getParameterValues("itemRiskItemNos");
						
						//accident item additional info
						String[] itemNosAcc 			= request.getParameterValues("itemItemNos");
						String[] noOfPersons 			= request.getParameterValues("noOfPersons");
						//System.out.println("no of persons is " +noOfPersons);
						String[] destinations			= request.getParameterValues("destinations");
						String[] monthlySalarys			= request.getParameterValues("monthlySalarys");
						String[] salaryGrades			= request.getParameterValues("salaryGrades");
						String[] positionCds			= request.getParameterValues("positionCds");
						String[] delGrpItemsInItems     = request.getParameterValues("delGrpItemsInItems");
						String[] dateOfBirths     		= request.getParameterValues("dateOfBirths");
						String[] ages     				= request.getParameterValues("ages");
						String[] civilStatuss     		= request.getParameterValues("civilStatuss");
						String[] sexs     				= request.getParameterValues("sexs");
						String[] heights     			= request.getParameterValues("heights");
						String[] weights     			= request.getParameterValues("weights");
						String[] groupPrintSws     		= request.getParameterValues("groupPrintSws");
						String[] acClassCds     		= request.getParameterValues("acClassCds");
						String[] levelCds     			= request.getParameterValues("levelCds");
						String[] parentLevelCds     	= request.getParameterValues("parentLevelCds");
						String[] populatePerilss		= request.getParameterValues("populatePerilss");
						String[] accidentDeleteBills	= request.getParameterValues("accidentDeleteBills");
						
						//System.out.println("Date of Births : " + dateOfBirths[0]);
						System.out.println("Height : " + heights[0]);
						
						//for gipiwitem
						for(int i=0 ; i<itemNos.length; i++){
							//for gipiwitem
							GIPIWItem item = new GIPIWItem(
									Integer.parseInt(parIds[i]),
									Integer.parseInt(itemNos[i]),
									itemTitles[i], 
									itemGrps[i] == "" ? null : Integer.parseInt(itemGrps[i]),
									itemDescs[i], 
									itemDesc2s[i],
									tsiAmts[i] == "" ? null :  new BigDecimal(tsiAmts[i]),
									premAmts[i] == "" ? null : new BigDecimal(premAmts[i]),
									annPremAmts[i] == "" ? null : new BigDecimal(annPremAmts[i]),
									annTsiAmts[i] == "" ? null : new BigDecimal(annTsiAmts[i]),
									recFlags[i],						
									Integer.parseInt(currencyCds[i]),
									new BigDecimal(currencyRts[i]), 
									groupCds[i] == "" ? null : Integer.parseInt(groupCds[i])/*groupCd*/,
									(fromDates[i] == null || fromDates[i] == "" ? null :sdf.parse(fromDates[i])),//sdf.parse(fromDates[i]),
									(toDates[i] == null || toDates[i] == "" ? null :sdf.parse(toDates[i])),//sdf.parse(toDates[i]),
									packLineCds == null ? null : packLineCds[i], 
									packSublineCds == null ? null : packSublineCds[i],
									discountSws[i] == null || discountSws[i] == "" ? "N" : discountSws[i]/*discountSw*/,
									coverageCds[i] == "" ? null : Integer.parseInt(coverageCds[i]),
									otherInfos == null ? null : otherInfos[i]/*otherInfo*/,
									surchargeSws[i] == null || surchargeSws[i] == "" ? "N" : surchargeSws[i]/*surchargeSw*/,
									regionCds[i] == "" ? null : Integer.parseInt(regionCds[i]),
									changedTags == null ? null : changedTags[i]/*changedTag*/,
									prorateFlags == null ? null : prorateFlags[i]/*prorateFlag*/,
									compSws == null ? null : compSws[i]/*compSw*/,
									(shortRtPercents[i] == "" || shortRtPercents[i] == null || shortRtPercents[i].equals("") || shortRtPercents[i].equals(null))? null : new BigDecimal(shortRtPercents[i]), 
									packBenCds[i] == "" ? null : Integer.parseInt(packBenCds[i])/*packBenCd*/,
									paytTermss == null ? null : paytTermss[i], 
									riskNos[i] == "" ? null : Integer.parseInt(riskNos[i]), 
									riskItemNos[i] == "" ? null : Integer.parseInt(riskItemNos[i]));
									System.out.println(item.getItemDesc());
									
									//store in items map
									items.put(itemNos[i], item);
									
									GIPIWAccidentItem acc = new GIPIWAccidentItem(parIds[i],itemNosAcc[i],
											noOfPersons[i].replaceAll(",", ""),destinations[i],
											(monthlySalarys[i] == "" ? null : new BigDecimal(monthlySalarys[i].replaceAll(",", ""))),
											salaryGrades[i],positionCds[i],delGrpItemsInItems[i],
											(dateOfBirths[i] == "" || dateOfBirths[i] == null ? null : sdf.parse(dateOfBirths[i])),
											ages[i],civilStatuss[i],heights[i],weights[i],sexs[i],
											groupPrintSws[i],acClassCds[i],levelCds[i],parentLevelCds[i],
											populatePerilss[i],accidentDeleteBills[i]);
									System.out.println("noofperons is" +noOfPersons[i]);
									//store in itemAcc map
									itemAcc.put(itemNos[i], acc);
						}
					}
					
					// for benificiary
					
					if(request.getParameterValues("bItemNos") != null){
						String[] bParIds					= request.getParameterValues("bParIds");
						String[] bItemNos					= request.getParameterValues("bItemNos");
						String[] bBeneficiaryNos			= request.getParameterValues("bBeneficiaryNos");
						String[] bBeneficiaryNames			= request.getParameterValues("bBeneficiaryNames");
						String[] bBeneficiaryAddrs			= request.getParameterValues("bBeneficiaryAddrs");
						String[] bBeneficiaryDateOfBirths	= request.getParameterValues("bBeneficiaryDateOfBirths");
						String[] bBeneficiaryAges			= request.getParameterValues("bBeneficiaryAges");
						String[] bBeneficiaryRelations		= request.getParameterValues("bBeneficiaryRelations");
						String[] bBenefeciaryRemarkss		= request.getParameterValues("bBenefeciaryRemarkss");
						
						params.put("bItemNos", bItemNos);
					
						/*
						for (int a = 0; a < bItemNos.length; a++) {
								
							GIPIWBeneficiary bItems = new GIPIWBeneficiary(bParIds[a],bItemNos[a],
									bBeneficiaryNos[a],bBeneficiaryNames[a],bBeneficiaryAddrs[a],
									bBeneficiaryRelations[a],(bBeneficiaryDateOfBirths[a] == "" || bBeneficiaryDateOfBirths[a] == null ? null : sdf.parse(bBeneficiaryDateOfBirths[a])),
									bBeneficiaryAges[a],bBenefeciaryRemarkss[a]
									);
							
							beneficiaryItems.put(bItemNos[a], bItems);
													
						}
						*/
						
						for (int b = 0; b < bBeneficiaryNos.length; b++){
							
							GIPIWBeneficiary bItems = new GIPIWBeneficiary(bParIds[b], bItemNos[b],
									bBeneficiaryNos[b], bBeneficiaryNames[b], bBeneficiaryAddrs[b],
									bBeneficiaryRelations[b], (bBeneficiaryDateOfBirths[b] == "" || bBeneficiaryDateOfBirths[b] == null ? null : sdf.parse(bBeneficiaryDateOfBirths[b])),
									bBeneficiaryAges[b], bBenefeciaryRemarkss[b]);
							
							beneficiaryItems.put(bBeneficiaryNos[b], bItems);
							
						}
					}

					String[] delBeneficiaryItemNos		= request.getParameterValues("delBeneficiaryItemNos");
					String[] delBeneficiaryNos			= request.getParameterValues("delBeneficiaryNos");
					String[] delItemNos					= request.getParameterValues("delItemNos");	
					
					//for item deductibles
					String[] insDedItemNos	= request.getParameterValues("insDedItemNo2");
					String[] delDedItemNos	= request.getParameterValues("delDedItemNo2");
					
					params.put("insDedItemNos", insDedItemNos);
					params.put("delDedItemNos", delDedItemNos);
					
					if (insDedItemNos != null){
						List<GIPIWDeductible> deductibleInsList = new ArrayList<GIPIWDeductible>();
						
						String[] dedItemNos 		= request.getParameterValues("insDedItemNo2");		
						String[] perilCds 		 	= request.getParameterValues("insDedPerilCd2");
						String[] deductibleCds 	 	= request.getParameterValues("insDedDeductibleCd2");
						String[] deductibleAmts  	= request.getParameterValues("insDedAmount2");
						String[] deductibleRts 	 	= request.getParameterValues("insDedRate2");
						String[] deductibleTexts 	= request.getParameterValues("insDedText2");
						String[] aggregateSws 	 	= request.getParameterValues("insDedAggregateSw2");
						String[] ceilingSws 	 	= request.getParameterValues("insDedCeilingSw2");
						
						GIPIWDeductible deductible = new GIPIWDeductible();
						for (int i = 0; i < dedItemNos.length; i++){
							deductible = new GIPIWDeductible();
							deductible.setParId(Integer.parseInt(request.getParameter("globalParId")));
							deductible.setDedLineCd(request.getParameter("globalLineCd"));
							deductible.setDedSublineCd(request.getParameter("globalSublineCd"));
							deductible.setUserId(USER.getUserId());
							deductible.setItemNo(Integer.parseInt(dedItemNos[i]));
							deductible.setPerilCd(Integer.parseInt(perilCds[i]));
							deductible.setDedDeductibleCd(deductibleCds[i]);
							deductible.setDeductibleAmount(new BigDecimal(deductibleAmts[i].isEmpty() ? "0.00" : deductibleAmts[i].replaceAll(",", "")));
							deductible.setDeductibleRate(new BigDecimal(deductibleRts[i].isEmpty() ? "0.00" : deductibleRts[i]));
							deductible.setDeductibleText(deductibleTexts[i]);
							deductible.setAggregateSw(aggregateSws[i]);
							deductible.setCeilingSw(ceilingSws[i]);
							deductibleInsList.add(deductible);
							
							deductibleInsList.add(deductible);
							deductible = null;
						}
						params.put("deductibleInsList", deductibleInsList);
					}
					
					if (delDedItemNos != null){
						List<Map<String, Object>> deductibleDelList = new ArrayList<Map<String,Object>>();
						
						String[] dedItemNos 		= request.getParameterValues("delDedItemNo2");
						String[] deductibleCds		= request.getParameterValues("delDedDeductibleCd2");
						
						for (int i = 0; i < dedItemNos.length; i++){
							Map<String, Object> deductibleMap = new HashMap<String, Object>();
							
							deductibleMap.put("parId", Integer.parseInt(request.getParameter("globalParId")));
							deductibleMap.put("itemNo", Integer.parseInt(dedItemNos[i]));
							deductibleMap.put("dedDeductibleCd", deductibleCds[i]);
							
							deductibleDelList.add(deductibleMap);
							deductibleMap = null;
						}
						params.put("deductibleDelList", deductibleDelList);
					}					
					//end deductibles
					
					//for item perils
					//for inserted perils
					Map<String, Object> insParams = new HashMap<String, Object>();
					String[] insItemNos 			= request.getParameterValues("insItemNo");
					String[] insPerilCds 			= request.getParameterValues("insPerilCd");
					String[] insPremiumRates		= request.getParameterValues("insPremiumRate");
					String[] insTsiAmounts			= request.getParameterValues("insTsiAmount");
					String[] insAnnTsiAmounts		= request.getParameterValues("insAnnTsiAmount");
					String[] insPremiumAmounts		= request.getParameterValues("insPremiumAmount");
					String[] insAnnPremiumAmounts 	= request.getParameterValues("insAnnPremiumAmount");
					String[] insRemarkss			= request.getParameterValues("insRemarks");
					String[] insWcSws				= request.getParameterValues("insWcSw");
					
					//System.out.println(insPerilCds[0] + " - first peril code");
					
					/*
					insParams.put("parId", parId);
					insParams.put("insItemNos", insItemNos);
					insParams.put("insPerilCds", insPerilCds);
					insParams.put("insPerilNames", insPerilNames);
					insParams.put("insPremiumRates", insPremiumRates);
					insParams.put("insTsiAmounts", insTsiAmounts);
					insParams.put("insAnnTsiAmounts", insAnnTsiAmounts);
					insParams.put("insPremiumAmounts", insPremiumAmounts);
					insParams.put("insRemarkss", insRemarkss);
					insParams.put("insWcSws", insWcSws);
					*/
					insParams.put("parId", parId);
					insParams.put("lineCd", request.getParameter("globalLineCd"));
					insParams.put("itemNos", insItemNos);
					insParams.put("perilCds", insPerilCds);
					insParams.put("premiumRates", insPremiumRates);
					insParams.put("tsiAmounts", insTsiAmounts);
					insParams.put("annTsiAmounts", insAnnTsiAmounts);
					insParams.put("premiumAmounts", insPremiumAmounts);
					insParams.put("annPremiumAmounts", insAnnPremiumAmounts);
					insParams.put("remarks", insRemarkss);
					insParams.put("wcSws", insWcSws);
					
					//for removed perils
					String[] delPerilItemNos = request.getParameterValues("delItemNo");
					String[] delPerilCds	 = request.getParameterValues("delPerilCd");
					
					Map<String, Object> delParams = new HashMap<String, Object>();
					
					delParams.put("parId", parId);
					delParams.put("lineCd", request.getParameter("globalLineCd"));
					delParams.put("itemNos", delPerilItemNos);
					delParams.put("perilCds", delPerilCds);
					
					//other parameters
					String delDiscounts 				= request.getParameter("delDiscounts");
					String delPercentTsiDeductibles		= request.getParameter("delPercentTsiDeductibles");
					String updateEndtTax				= request.getParameter("updateEndtTax");
					String parTsiAmount					= request.getParameter("parTsiAmount");
					String parAnnTsiAmount				= request.getParameter("parAnnTsiAmount");
					String parPremiumAmount				= request.getParameter("parPremiumAmount");
					String parAnnPremiumAmount			= request.getParameter("parAnnPremiumAmount");
					
					@SuppressWarnings("unused")
					String perilPackPolFlag   		= request.getParameter("globalPackPolFlag");
					Integer packParId     			= Integer.parseInt((request.getParameter("globalPackParId") == null || request.getParameter("globalPackParId") == "" ? "0" : request.getParameter("globalPackParId")));
					String packLineCd				= request.getParameter("packLineCd");
					@SuppressWarnings("unused")
					String perilIssCd 	    		= request.getParameter("globalIssCd");
					
					Map<String, Object> otherParams = new HashMap<String, Object>();
					
					otherParams.put("userId", USER.getUserId());
					otherParams.put("delDiscounts", delDiscounts);
					otherParams.put("delPercentTsiDeductibles", delPercentTsiDeductibles);
					otherParams.put("updateEndtTax", updateEndtTax);
					otherParams.put("parTsiAmount", parTsiAmount);
					otherParams.put("parAnnTsiAmount", parAnnTsiAmount);
					otherParams.put("parPremiumAmount", parPremiumAmount);
					otherParams.put("parAnnPremiumAmount", parAnnPremiumAmount);
					
					//peril deductibles
					String[] perilDedItemNos 		 = request.getParameterValues("dedItemNo3");
					String[] perilDedPerilCds 		 = request.getParameterValues("dedPerilCd3");
					String[] perilDedDeductibleCds 	 = request.getParameterValues("dedDeductibleCd3");
					String[] perilDedDeductibleAmts  = request.getParameterValues("dedAmount3");
					String[] perilDedDeductibleRts 	 = request.getParameterValues("dedRate3");
					String[] perilDedDeductibleTexts = request.getParameterValues("dedText3");
					String[] perilDedAggregateSws 	 = request.getParameterValues("dedAggregateSw3");
					String[] perilDedCeilingSws 	 = request.getParameterValues("dedCeilingSw3");
										
					Map<String, Object> perilDedParams = new HashMap<String, Object>();
					perilDedParams.put("itemNos", perilDedItemNos);
					perilDedParams.put("perilCds", perilDedPerilCds);
					perilDedParams.put("deductibleCds",perilDedDeductibleCds);
					perilDedParams.put("deductibleAmounts", perilDedDeductibleAmts);
					perilDedParams.put("deductibleRates", perilDedDeductibleRts);
					perilDedParams.put("deductibleTexts", perilDedDeductibleTexts);
					perilDedParams.put("aggregateSws", perilDedAggregateSws);
					perilDedParams.put("ceilingSws", perilDedCeilingSws);
					perilDedParams.put("parId", parId);
					perilDedParams.put("dedLineCd", request.getParameter("globalLineCd"));
					perilDedParams.put("dedSublineCd", sublineCd);
					perilDedParams.put("userId", USER.getUserId());	
					
					//all parameters
					Map<String, Object> allEndtPerilParams = new HashMap<String, Object>();
					allEndtPerilParams.put("insItemNos", insItemNos);
					allEndtPerilParams.put("delPerilItemNos", delPerilItemNos);
					allEndtPerilParams.put("insParams", insParams);
					allEndtPerilParams.put("delParams", delParams);
					allEndtPerilParams.put("otherParams", otherParams);
					allEndtPerilParams.put("perilDedParams", perilDedParams);
					
					params.put("allEndtPerilParams", allEndtPerilParams);
					
					// pol basic parameters
					Map<String, Object> updateGIPIWPolbasParams = new HashMap<String, Object>();
					updateGIPIWPolbasParams = this.getUpdateGIPIWPolbasParams(request);
					params.put("updateGIPIWPolbasParams", updateGIPIWPolbasParams);
					
					//finally put all maps and parameters into "params map"
					//added beneficiaryNos parameter by angelo for saving multiple beneficiaries per item
					String[] bBeneficiaryNos = request.getParameterValues("bBeneficiaryNos");
					params.put("beneficiaryNos", bBeneficiaryNos);
					params.put("items", items);
					params.put("itemsAcc", itemAcc);
					params.put("delItemNos", delItemNos);
					params.put("sublineCD", sublineCd);
					params.put("parId", parId);
					params.put("beneficiaryItems",beneficiaryItems);
					params.put("delBeneficiaryItemNos",delBeneficiaryItemNos);
					params.put("delBeneficiaryNos",delBeneficiaryNos);
					
					if ("Y".equals(packPolFlag)){
//						String packParId = request.getParameter("globalPackParId");
//						String packLineCd = request.getParameter("packLineCd");
						String packSublineCd = request.getParameter("packSublineCd");
						params.put("packParId", packParId);
						params.put("packLineCd", packLineCd);
						params.put("packSublineCd", packSublineCd);
					}
					
					gipiWAccidentItemService.saveEndtAccidentItemInfoPage(params);
					
					if ((("Y".equals(invoiceSw)) && ("".equals(varPost))) || ("Y".equals(varGroupSw))){
						gipiWAccidentItemService.changeItemAccGroup(parId);
					}
					message = "SUCCESS";
		      		PAGE = "/pages/genericMessage.jsp";
				} else if("saveAccidentEndtGroupedItemsModal".equals(ACTION)){ //angelo
					System.out.println("I Went Here");
					String groupedItemsObjParameters = request.getParameter("groupedItemsObjParameters");
					message = gipiWAccidentItemService.saveGipiWAccidentGroupedItemsModal(groupedItemsObjParameters);

					PAGE = "/pages/genericMessage.jsp";
				} else if ("checkRetrieveGroupedItems".equals(ACTION)){
					String lineCd = request.getParameter("lineCd");
					String sublineCd = request.getParameter("sublineCd");
					String issCd = request.getParameter("issCd");
					String issueYy = request.getParameter("issueYy");
					String polSeqNo = request.getParameter("polSeqNo");
					String renewNo = request.getParameter("renewNo");
					String itemNo = request.getParameter("itemNo");
					String effDate = request.getParameter("effDate");
					
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					Date newEffDate = sdf.parse(effDate);

					Map<String, Object> params = new HashMap<String, Object>();
					params.put("lineCd", lineCd);
					params.put("sublineCd", sublineCd);
					params.put("issCd", issCd);
					params.put("issueYy", issueYy);
					params.put("polSeqNo", polSeqNo);
					params.put("renewNo", renewNo);
					params.put("itemNo", itemNo);
					params.put("effDate", newEffDate);
					
					message = gipiWAccidentItemService.checkRetrieveGroupedItems(params);
					
					PAGE = "/pages/genericMessage.jsp";
				} else if ("retrieveGroupedItems".equals(ACTION)){
					/*
					@SuppressWarnings("unused")
					GIPIWItmperlGroupedService gipiWItmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
					GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService = (GIPIWGrpItemsBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWGrpItemsBeneficiaryService");
					int policyId = 0;
					List<Integer> groupedItemNos = new ArrayList<Integer>();
					
					String lineCd = request.getParameter("lineCd");
					String sublineCd = request.getParameter("sublineCd");
					String issCd = request.getParameter("issCd");
					String issueYy = request.getParameter("issueYy");
					String polSeqNo = request.getParameter("polSeqNo");
					String renewNo = request.getParameter("renewNo");
					String itemNo = request.getParameter("itemNo");
					String effDate = request.getParameter("effDate");
					
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					Date newEffDate = sdf.parse(effDate);
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("lineCd", lineCd);
					params.put("sublineCd", sublineCd);
					params.put("issCd", issCd);
					params.put("issueYy", issueYy);
					params.put("polSeqNo", polSeqNo);
					params.put("renewNo", renewNo);
					params.put("itemNo", itemNo);
					params.put("effDate", newEffDate);
										
					List<GIPIGroupedItems> groupedItems = gipiWAccidentItemService.retrieveGroupedItems(params);
					List<GIPIWGroupedItems> gipiwGroupedItems = new ArrayList<GIPIWGroupedItems>();
					List<GIPIWItmperlGrouped> gipiwItmperlGrouped = new ArrayList<GIPIWItmperlGrouped>();
					List<GIPIWGrpItemsBeneficiary> gipiwGrpItemsBeneficiary = new ArrayList<GIPIWGrpItemsBeneficiary>();
					
					//List<GIPIWGrpItemsBeneficiary> gipiwGrpItemsBeneficiary = new ArrayList<GIPIWGrpItemsBeneficiary>();
					
					for (GIPIGroupedItems g : groupedItems){
						policyId = g.getPolicyId();
						groupedItemNos.add(g.getGroupedItemNo());
					}

					params.put("policyId", policyId);
					params.put("groupedItemNos", groupedItemNos);
					groupedItems = gipiWAccidentItemService.retrieveGroupedItems(params);
					gipiwGroupedItems = gipiWAccidentItemService.retGrpItmsGipiWGroupedItems(params);
					gipiwItmperlGrouped = gipiWAccidentItemService.retGrpItmsGipiWItmperlGrouped(params);
					gipiwGrpItemsBeneficiary = gipiWGrpItemsBeneficiaryService.getRetGipiWGrpItemsBeneficiary(params);
					
					System.out.println("Grouped Item Number\tGrouped Item Title");
					for (GIPIGroupedItems i : groupedItems){
						System.out.println(i.getGroupedItemNo() + "\t\t\t" + i.getGroupedItemTitle());
					}
					
					List<JSONArray> grpItems = new ArrayList<JSONArray>();
					
					grpItems.add(new JSONArray(gipiwGroupedItems));
					grpItems.add(new JSONArray(gipiwItmperlGrouped));
					grpItems.add(new JSONArray(gipiwGrpItemsBeneficiary));
					grpItems.add(new JSONArray(groupedItems));
					
					//request.setAttribute("groupedItems", groupedItems);
					
					//request.setAttribute("gipiwGroupedItems", gipiwGroupedItems);
					//request.setAttribute("gipiwItmperlGrouped", gipiwItmperlGrouped);
					
					//request.setAttribute("gipiwGroupedItems", new JSONArray(groupedItems));
					//request.setAttribute("gipiwItmperlGrouped", new JSONArray(gipiwItmperlGrouped));
					
					request.setAttribute("object", grpItems);
					
					//PAGE = "/pages/underwriting/endt/accident/pop-ups/accidentEndtRetGroupedItems.jsp";
					PAGE = "/pages/genericObject.jsp";
					*/
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);					
					params = gipiWAccidentItemService.retrieveGroupedItems(params);
					
					if((String) params.get("message") != null){
						//request.setAttribute("message", params.get("message"));
						message = params.get("message").toString();
						PAGE = "/pages/genericMessage.jsp";						
					}else{
						request.setAttribute("gipiGroupedItems", new JSONArray((List<GIPIGroupedItems>) params.get("gipiGroupedItems")));
						request.setAttribute("gipiItmPerilGrouped", new JSONArray((List<GIPIItmPerilGrouped>) params.get("gipiItmPerilGrouped")));
						request.setAttribute("gipiGrpItemsBeneficiary", new JSONArray((List<GIPIGrpItemsBeneficiary>) params.get("gipiGrpItemBeneficiary")));
						PAGE = "/pages/underwriting/endt/jsonAccident/pop-ups/endtAccidentRetrievedGroupedItems.jsp";
					}					
				} else if("insertRetrievedGroupedItems".equals(ACTION)){
					String lineCd = request.getParameter("lineCd");
					String sublineCd = request.getParameter("sublineCd");
					String issCd = request.getParameter("issCd");
					String issueYy = request.getParameter("issueYy");
					String polSeqNo = request.getParameter("polSeqNo");
					String renewNo = request.getParameter("renewNo");
					String itemNo = request.getParameter("itemNo");
					String effDate = request.getParameter("effDate");
					String[] groupedItemNos = request.getParameter("groupedItemNos").split("/");
					String[] groupedItemTitles = request.getParameter("groupedItemTitles").split("/");
					String[] groupedControlCds = request.getParameter("groupedControlCds").split("/");
					String[] groupedControlTypeCds = request.getParameter("groupedControlTypeCds").split("/");
					
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					Date newEffDate = sdf.parse(effDate);
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("lineCd", lineCd);
					params.put("sublineCd", sublineCd);
					params.put("issCd", issCd);
					params.put("issueYy", issueYy);
					params.put("polSeqNo", polSeqNo);
					params.put("renewNo", renewNo);
					params.put("itemNo", itemNo);
					params.put("effDate", newEffDate);
					params.put("groupedItemNos", groupedItemNos);
					params.put("groupedItemTitles", groupedItemTitles);
					params.put("groupedControlCds", groupedControlCds);
					params.put("groupedControlTypeCds", groupedControlTypeCds);
					
					System.out.println("lineCd : " + lineCd);
					System.out.println("sublineCd : " + sublineCd);
					System.out.println("issCd : " + issCd);
					System.out.println("issueYy : " + issueYy);
					System.out.println("polSeqNo : " + polSeqNo);
					System.out.println("renewNo : " + renewNo);
					System.out.println("itemNo : " + itemNo);
					System.out.println("effDate : " + newEffDate);
					System.out.println("groupedItemNos : ");
					for (int x = 0; x < groupedItemNos.length; x++){
						System.out.println(groupedItemNos[x]);
					}	
					System.out.println("groupedItemTitles : ");
					for (int y = 0; y < groupedItemTitles.length; y++){
						System.out.println(groupedItemTitles[y]);
					}
					System.out.println("groupedControlCds : ");
					for (int z = 0; z < groupedControlCds.length; z++){
						System.out.println(groupedControlCds[z]);
					}
					System.out.println("groupedControlTypeCds : ");
					for (int a = 0; a < groupedControlTypeCds.length; a++){
						System.out.println(groupedControlTypeCds[a]);
					}
					
					gipiWAccidentItemService.insertRetrievedGroupedItems(params);
					
					//message = "haayzz....";
					
					PAGE = "/pages/genericMessage.jsp";
				} else if("showAccidentGroupedItemsModal".equals(ACTION)){	
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					GIPIWGroupedItemsService gipiWGroupedItemsService = (GIPIWGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiWGroupedItemsService");
					GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					GIPIWItmperlGroupedService gipiWItmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
					GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService = (GIPIWGrpItemsBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWGrpItemsBeneficiaryService");
					GIPIWItmperlBeneficiaryService gipiWItmperlBeneficiaryService = (GIPIWItmperlBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWItmperlBeneficiaryService");
					//GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
					
					int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
										
					GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
					String lineCd = par.getLineCd();
					String sublineCd = par.getSublineCd();
					String assdNo = par.getAssdNo();
					request.setAttribute("parId", parId);
					request.setAttribute("itemNo", itemNo);
					request.setAttribute("lineCd", lineCd);
					request.setAttribute("issCd", par.getIssCd());
					request.setAttribute("isFromOverwriteBen", request.getParameter("isFromOverwriteBen"));
					
					String[] planParam = {lineCd,sublineCd};					
					request.setAttribute("plans", helper.getList(LOVHelper.PACKAGE_BENEFIT_LISTING, planParam));
					request.setAttribute("payTerms", helper.getList(LOVHelper.PAYTERM_LISTING));
					request.setAttribute("controlTypes", helper.getList(LOVHelper.CONTROL_TYPE_LISTING));
					String[] civilStat = {"CIVIL STATUS"};
					request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
					request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));
					String[] groupParam = {assdNo};					
					request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					
					String stringParId = ("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
					String[] perilParam = {stringParId ,lineCd,sublineCd};
					String[] perilParam2 = {lineCd,sublineCd};		
					request.setAttribute("perils", helper.getList(LOVHelper.PERIL_NAME_LISTING3, perilParam));
					request.setAttribute("beneficiaryPerils", helper.getList(LOVHelper.PERIL_NAME_LISTING2, perilParam2));
					
					List<GIPIWGroupedItems> groupedItems = gipiWGroupedItemsService.getGipiWGroupedItems2(parId,itemNo);
					request.setAttribute("gipiWGroupedItems", groupedItems);
					String isExist = gipiWItemPerilService.isExist(parId, itemNo);
					request.setAttribute("itemPerilExist", isExist);
					String isExist2 = gipiWItmperlGroupedService.isExist(parId, itemNo);
					request.setAttribute("itemPerilGroupedExist", isExist2);
					List<GIPIWItmperlGrouped> coverageitems = gipiWItmperlGroupedService.getGipiWItmperlGrouped(parId, itemNo);
					request.setAttribute("gipiWItmperlGrouped", coverageitems);
					List<GIPIWGrpItemsBeneficiary> beneficiaryItems = gipiWGrpItemsBeneficiaryService.getGipiWGrpItemsBeneficiary(parId, itemNo);
					request.setAttribute("gipiWGrpItemsBeneficiary", beneficiaryItems);
					List<GIPIWItmperlBeneficiary> beneficiaryPerils = gipiWItmperlBeneficiaryService.getGipiWItmperlBeneficiary(parId, itemNo);
					request.setAttribute("gipiWItmperlBeneficiary", beneficiaryPerils);
					
					GIPIWItem gipiWItem = gipiWItemService.getTsiPremAmt(parId, itemNo);
					request.setAttribute("gipiWItem", gipiWItem);
					
					PAGE = "/pages/underwriting/pop-ups/accidentAdditionalInfo.jsp";
				}else if("showEndtACGroupedItems".equals(ACTION)){					
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("APPLICATION_CONTEXT", APPLICATION_CONTEXT);
					params.put("request", request);
					
					gipiWAccidentItemService.showEndtACGroupedItems(params);
					message = "SUCCESS";
					PAGE = "/pages/underwriting/endt/jsonAccident/pop-ups/endtAccidentAdditionalInfo.jsp";					
				}else if("showAccidentEndtGroupedItemsModal".equals(ACTION)){	
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					//GIPIWGroupedItemsService gipiWGroupedItemsService = (GIPIWGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiWGroupedItemsService");
					GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					GIPIWItmperlGroupedService gipiWItmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
					//GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService = (GIPIWGrpItemsBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWGrpItemsBeneficiaryService");
					//GIPIWItmperlBeneficiaryService gipiWItmperlBeneficiaryService = (GIPIWItmperlBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWItmperlBeneficiaryService");
					//GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");		
									
					int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
					GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
					String lineCd = par.getLineCd();
					String sublineCd = par.getSublineCd();
					String assdNo = par.getAssdNo();
					request.setAttribute("parId", parId);
					request.setAttribute("itemNo", itemNo);
					request.setAttribute("lineCd", lineCd);
					//request.setAttribute("isFromOverwriteBen", request.getParameter("isFromOverwriteBen"));
					
					String[] planParam = {lineCd,sublineCd};					
					request.setAttribute("plans", helper.getList(LOVHelper.PACKAGE_BENEFIT_LISTING, planParam));
					request.setAttribute("payTerms", helper.getList(LOVHelper.PAYTERM_LISTING));
					request.setAttribute("controlTypes", helper.getList(LOVHelper.CONTROL_TYPE_LISTING));
					String[] civilStat = {"CIVIL STATUS"};
					request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
					request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));
					String[] groupParam = {assdNo};					
					request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					
					String stringParId = ("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
					String[] perilParam = {stringParId ,lineCd,sublineCd};		
					String[] perilParam2 = {lineCd,sublineCd};		
					request.setAttribute("perils", helper.getList(LOVHelper.PERIL_NAME_LISTING3, perilParam));
					request.setAttribute("beneficiaryPerils", helper.getList(LOVHelper.PERIL_NAME_LISTING2, perilParam2));
					
					//List<GIPIWGroupedItems> groupedItems = gipiWGroupedItemsService.getGipiWGroupedItems2(parId,itemNo);
					//request.setAttribute("gipiWGroupedItems", groupedItems);
					String isExist = gipiWItemPerilService.isExist(parId, itemNo);
					request.setAttribute("itemPerilExist", isExist);
					String isExist2 = gipiWItmperlGroupedService.isExist(parId, itemNo);
					request.setAttribute("itemPerilGroupedExist", isExist2);
					//List<GIPIWItmperlGrouped> coverageitems = gipiWItmperlGroupedService.getGipiWItmperlGrouped(parId, itemNo);
					//request.setAttribute("gipiWItmperlGrouped", coverageitems);
					//List<GIPIWGrpItemsBeneficiary> beneficiaryItems = gipiWGrpItemsBeneficiaryService.getGipiWGrpItemsBeneficiary(parId, itemNo);
					//request.setAttribute("gipiWGrpItemsBeneficiary", beneficiaryItems);
					//List<GIPIWItmperlBeneficiary> beneficiaryPerils = gipiWItmperlBeneficiaryService.getGipiWItmperlBeneficiary(parId, itemNo);
					//request.setAttribute("gipiWItmperlBeneficiary", beneficiaryPerils);
					//GIPIWItem gipiWItem = gipiWItemService.getTsiPremAmt(parId, itemNo);
					
					/*
					request.setAttribute("gipiWItem", gipiWItem);
					
					request.setAttribute("gipiwGrpItems", new JSONArray(groupedItems));
					request.setAttribute("gipiwCoverageItems", new JSONArray(coverageitems));
					request.setAttribute("gipiwBeneficiaryItems", new JSONArray(beneficiaryItems));
					request.setAttribute("gipiwBeneficiaryPerils", new JSONArray(beneficiaryPerils));*/
					
					PAGE = "/pages/underwriting/endt/accident/subPages/accidentGroupAdditionalInfo.jsp";
				} else if("saveEndtACGroupedItemsModal".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("param", request.getParameter("parameters"));
					params.put("USER", USER);
					
					gipiWAccidentItemService.saveEndtACGroupedItemsModal(params);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				} else if ("saveAccidentGroupedItemsModal".equals(ACTION)){
					//GIPIWAccidentItemService gipiWAccidentItemService = (GIPIWAccidentItemService)  APPLICATION_CONTEXT.getBean("gipiWAccidentItemService");
					List<GIPIWGroupedItems> groupedItems = new ArrayList<GIPIWGroupedItems>();
					List<GIPIWItmperlGrouped> coverageItems = new ArrayList<GIPIWItmperlGrouped>();
					List<GIPIWGrpItemsBeneficiary> beneficiaryItems = new ArrayList<GIPIWGrpItemsBeneficiary>();
					List<GIPIWItmperlBeneficiary> beneficiaryPerils = new ArrayList<GIPIWItmperlBeneficiary>();
					int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
					String newNoOfPerson = request.getParameter("newNoOfPerson");
					String lineCd = request.getParameter("globalLineCd");
					String issCd = request.getParameter("globalIssCd");
					String userId = USER.getUserId();
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					
					if(request.getParameterValues("grpParIds") != null){
						String[] grpParIds					= request.getParameterValues("grpParIds");
						String[] grpItemNos					= request.getParameterValues("grpItemNos");
						String[] grpGroupedItemNos			= request.getParameterValues("grpGroupedItemNos");
						String[] grpGroupedItemTitles		= request.getParameterValues("grpGroupedItemTitles");
						String[] grpPrincipalCds			= request.getParameterValues("grpPrincipalCds");
						String[] grpPackBenCds				= request.getParameterValues("grpPackBenCds");
						String[] grpPaytTermss				= request.getParameterValues("grpPaytTermss");
						String[] grpFromDates				= request.getParameterValues("grpFromDates");
						String[] grpToDates					= request.getParameterValues("grpToDates");
						String[] grpSexs					= request.getParameterValues("grpSexs");
						String[] grpDateOfBirths			= request.getParameterValues("grpDateOfBirths");
						String[] grpAges					= request.getParameterValues("grpAges");
						String[] grpCivilStatuss			= request.getParameterValues("grpCivilStatuss");
						String[] grpPositionCds				= request.getParameterValues("grpPositionCds");
						String[] grpGroupCds				= request.getParameterValues("grpGroupCds");
						String[] grpControlTypeCds			= request.getParameterValues("grpControlTypeCds");
						String[] grpControlCds				= request.getParameterValues("grpControlCds");
						String[] grpSalarys					= request.getParameterValues("grpSalarys");
						String[] grpSalaryGrades			= request.getParameterValues("grpSalaryGrades");
						String[] grpAmountCovereds			= request.getParameterValues("grpAmountCovereds");
						String[] grpIncludeTags				= request.getParameterValues("grpIncludeTags");
						String[] grpRemarkss				= request.getParameterValues("grpRemarkss");
						String[] grpLineCds					= request.getParameterValues("grpLineCds");
						String[] grpSublineCds				= request.getParameterValues("grpSublineCds");
						String[] grpDeleteSws				= request.getParameterValues("grpDeleteSws");
						String[] grpAnnTsiAmts				= request.getParameterValues("grpAnnTsiAmts");
						String[] grpAnnPremAmts				= request.getParameterValues("grpAnnPremAmts");
						String[] grpTsiAmts					= request.getParameterValues("grpTsiAmts");
						String[] grpPremAmts				= request.getParameterValues("grpPremAmts");
						String[] grpOverwriteBens			= request.getParameterValues("grpOverwriteBens");
						
						for (int a = 0; a < grpParIds.length; a++) {
							groupedItems.add(new GIPIWGroupedItems(grpParIds[a],grpItemNos[a],
									grpGroupedItemNos[a],grpIncludeTags[a],grpGroupedItemTitles[a],
									grpGroupCds[a],(grpAmountCovereds[a] == null || grpAmountCovereds[a] == "" ? null : new BigDecimal(grpAmountCovereds[a].replaceAll(",", ""))),
									grpRemarkss[a],grpLineCds[a],grpSublineCds[a],
									grpSexs[a],grpPositionCds[a],grpCivilStatuss[a],
									(grpDateOfBirths[a] == "" || grpDateOfBirths[a] == null ? null : sdf.parse(grpDateOfBirths[a])),
									grpAges[a],(grpSalarys[a] == null || grpSalarys[a] == "" ? null : new BigDecimal(grpSalarys[a].replaceAll(",", ""))),
									grpSalaryGrades[a],grpDeleteSws[a],
									(grpFromDates[a] == "" || grpFromDates[a] == null ? null : sdf.parse(grpFromDates[a])),
									(grpToDates[a] == "" || grpToDates[a] == null ? null : sdf.parse(grpToDates[a])),
									grpPaytTermss[a],grpPackBenCds[a],
									(grpAnnTsiAmts[a] == null || grpAnnTsiAmts[a] == "" ? null : new BigDecimal(grpAnnTsiAmts[a].replaceAll(",", ""))),
									(grpAnnPremAmts[a] == null || grpAnnPremAmts[a] == "" ? null : new BigDecimal(grpAnnPremAmts[a].replaceAll(",", ""))),
									(grpTsiAmts[a] == null || grpTsiAmts[a] == "" ? null : new BigDecimal(grpTsiAmts[a].replaceAll(",", ""))),
									(grpPremAmts[a] == null || grpPremAmts[a] == "" ? null : new BigDecimal(grpPremAmts[a].replaceAll(",", ""))),
									grpControlCds[a],grpControlTypeCds[a],grpPrincipalCds[a],grpOverwriteBens[a]
									));
						}
					}
					
					if(request.getParameterValues("covParIds") != null){
						String[] covParIds					= request.getParameterValues("covParIds");
						String[] covItemNos					= request.getParameterValues("covItemNos");
						String[] covPerilCds				= request.getParameterValues("covPerilCds");
						String[] covPremRts					= request.getParameterValues("covPremRts");
						String[] covTsiAmts					= request.getParameterValues("covTsiAmts");
						String[] covPremAmts				= request.getParameterValues("covPremAmts");
						String[] covNoOfDayss				= request.getParameterValues("covNoOfDayss");
						String[] covBaseAmts				= request.getParameterValues("covBaseAmts");
						String[] covAggregateSws			= request.getParameterValues("covAggregateSws");
						String[] covAnnPremAmts				= request.getParameterValues("covAnnPremAmts");
						String[] covAnnTsiAmts				= request.getParameterValues("covAnnTsiAmts");
						String[] covGroupedItemNos			= request.getParameterValues("covGroupedItemNos");
						String[] covLineCds					= request.getParameterValues("covLineCds");
						String[] covRecFlags				= request.getParameterValues("covRecFlags");
						String[] covRiCommRts				= request.getParameterValues("covRiCommRts");
						String[] covRiCommAmts				= request.getParameterValues("covRiCommAmts");
						String[] covWcSws					= request.getParameterValues("covWcSws");
						
						for (int a = 0; a < covParIds.length; a++) {
							coverageItems.add(new GIPIWItmperlGrouped(new Integer(covParIds[a]),new Integer(covItemNos[a]),
									new Integer(covGroupedItemNos[a]),covLineCds[a],covPerilCds[a],
									covRecFlags[a],covNoOfDayss[a],
									(covPremRts[a] == null || covPremRts[a] == "" ? "" : covPremRts[a].replaceAll(",", "")),
									(covTsiAmts[a] == null || covTsiAmts[a] == "" ? null : new BigDecimal(covTsiAmts[a].replaceAll(",", ""))),
									(covPremAmts[a] == null || covPremAmts[a] == "" ? null : new BigDecimal(covPremAmts[a].replaceAll(",", ""))),
									(covAnnTsiAmts[a] == null || covAnnTsiAmts[a] == "" ? null : new BigDecimal(covAnnTsiAmts[a].replaceAll(",", ""))),
									(covAnnPremAmts[a] == null || covAnnPremAmts[a] == "" ? null : new BigDecimal(covAnnPremAmts[a].replaceAll(",", ""))),
									covAggregateSws[a],(covBaseAmts[a] == null || covBaseAmts[a] == "" ? null : new BigDecimal(covBaseAmts[a].replaceAll(",", ""))),
									(covRiCommRts[a] == null || covRiCommRts[a] == "" ? null : new BigDecimal(covRiCommRts[a].replaceAll(",", ""))),
									(covRiCommAmts[a] == null || covRiCommAmts[a] == "" ? null : new BigDecimal(covRiCommAmts[a].replaceAll(",", ""))),
									covWcSws[a]
									));
						}
					}
					
					if(request.getParameterValues("benParIds") != null){
						String[] benParIds					= request.getParameterValues("benParIds");
						String[] benItemNos					= request.getParameterValues("benItemNos");
						String[] benBeneficiaryNos			= request.getParameterValues("benBeneficiaryNos");
						String[] benBeneficiaryNames		= request.getParameterValues("benBeneficiaryNames");
						String[] benBeneficiaryAddrs		= request.getParameterValues("benBeneficiaryAddrs");
						String[] benDateOfBirths			= request.getParameterValues("benDateOfBirths");
						String[] benAges					= request.getParameterValues("benAges");
						String[] benRelations				= request.getParameterValues("benRelations");
						String[] benCivilStatuss			= request.getParameterValues("benCivilStatuss");
						String[] benSexs					= request.getParameterValues("benSexs");
						String[] benGroupedItemNos			= request.getParameterValues("benGroupedItemNos");
						
						for (int a = 0; a < benParIds.length; a++) {
							beneficiaryItems.add(new GIPIWGrpItemsBeneficiary(new Integer(benParIds[a]),new Integer(benItemNos[a]),
									benGroupedItemNos[a],benBeneficiaryNos[a],benBeneficiaryNames[a],
									benBeneficiaryAddrs[a],benRelations[a],
									(benDateOfBirths[a] == "" || benDateOfBirths[a] == null ? null : sdf.parse(benDateOfBirths[a])),
									benAges[a],benCivilStatuss[a],benSexs[a]
									));
						}
					}
					
					if(request.getParameterValues("bpParIds") != null){
						String[] bpParIds					= request.getParameterValues("bpParIds");
						String[] bpItemNos					= request.getParameterValues("bpItemNos");
						String[] bpPerilCds					= request.getParameterValues("bpPerilCds");
						String[] bpTsiAmts					= request.getParameterValues("bpTsiAmts");
						String[] bpGroupedItemNos			= request.getParameterValues("bpGroupedItemNos");
						String[] bpBeneficiaryNos			= request.getParameterValues("bpBeneficiaryNos");
						String[] bpLineCds					= request.getParameterValues("bpLineCds");
						String[] bpRecFlags					= request.getParameterValues("bpRecFlags");
						String[] bpPremRts					= request.getParameterValues("bpPremRts");
						String[] bpPremAmts					= request.getParameterValues("bpPremAmts");
						String[] bpAnnTsiAmts				= request.getParameterValues("bpAnnTsiAmts");
						String[] bpAnnPremAmts				= request.getParameterValues("bpAnnPremAmts");
						
						for (int a = 0; a < bpParIds.length; a++) {
							beneficiaryPerils.add(new GIPIWItmperlBeneficiary(new Integer(bpParIds[a]),new Integer(bpItemNos[a]),
									bpGroupedItemNos[a],bpBeneficiaryNos[a],bpLineCds[a],
									bpPerilCds[a],bpRecFlags[a],
									(bpPremRts[a] == null || bpPremRts[a] == "" ? null : new BigDecimal(bpPremRts[a].replaceAll(",", ""))),
									(bpTsiAmts[a] == null || bpTsiAmts[a] == "" ? null : new BigDecimal(bpTsiAmts[a].replaceAll(",", ""))),
									(bpPremAmts[a] == null || bpPremAmts[a] == "" ? null : new BigDecimal(bpPremAmts[a].replaceAll(",", ""))),
									(bpAnnTsiAmts[a] == null || bpAnnTsiAmts[a] == "" ? null : new BigDecimal(bpAnnTsiAmts[a].replaceAll(",", ""))),
									(bpAnnPremAmts[a] == null || bpAnnPremAmts[a] == "" ? null : new BigDecimal(bpAnnPremAmts[a].replaceAll(",", "")))
									));
						}
					}
					
					String[] delGroupItemsItemNos			= request.getParameterValues("delGroupItemsItemNos");
					String[] delGroupedItemNos				= request.getParameterValues("delGroupedItemNos");
					String[] delCoverageGroupedItemNos		= request.getParameterValues("delCoverageGroupedItemNos");
					String[] delCoveragePerilCds			= request.getParameterValues("delCoveragePerilCds");
					String[] delBenefitGroupedItemNos		= request.getParameterValues("delBenefitGroupedItemNos");
					String[] delBenefitBeneficiaryNos		= request.getParameterValues("delBenefitBeneficiaryNos");
					String[] delBenPerilGroupedItemNos		= request.getParameterValues("delBenPerilGroupedItemNos");
					String[] delBenPerilBeneficiaryNos		= request.getParameterValues("delBenPerilBeneficiaryNos");
					
					String[] popParIds = request.getParameterValues("popParIds");
					String[] popItemNos = request.getParameterValues("popItemNos");
					String[] popGroupedItemNos = request.getParameterValues("popGroupedItemNos");
					String[] popCheckSw = request.getParameterValues("popCheckSw");
					String popBenefitsSw = request.getParameter("popBenefitsSw");
					String popBenefitsGroupedItemNo = request.getParameter("popBenefitsGroupedItemNo");
					String popBenefitsPackBenCd = request.getParameter("popBenefitsPackBenCd");
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId",parId);
					params.put("itemNo",itemNo);
					params.put("lineCd",lineCd);
					params.put("issCd",issCd);
					params.put("userId",userId);
					params.put("newNoOfPerson", newNoOfPerson);
					params.put("groupedItems",groupedItems);
					params.put("coverageItems",coverageItems);
					params.put("beneficiaryItems",beneficiaryItems);
					params.put("beneficiaryPerils",beneficiaryPerils);
					params.put("delGroupItemsItemNos",delGroupItemsItemNos);
					params.put("delGroupedItemNos",delGroupedItemNos);
					params.put("delCoverageGroupedItemNos",delCoverageGroupedItemNos);
					params.put("delCoveragePerilCds",delCoveragePerilCds);
					params.put("delBenefitGroupedItemNos",delBenefitGroupedItemNos);
					params.put("delBenefitBeneficiaryNos",delBenefitBeneficiaryNos);
					params.put("delBenPerilGroupedItemNos",delBenPerilGroupedItemNos);
					params.put("delBenPerilBeneficiaryNos",delBenPerilBeneficiaryNos);
					params.put("doRenumber", request.getParameter("doRenumber"));
					params.put("popParIds", popParIds);
					params.put("popItemNos", popItemNos);
					params.put("popGroupedItemNos", popGroupedItemNos);
					params.put("popCheckSw", popCheckSw);
					params.put("popBenefitsSw", popBenefitsSw);
					params.put("popBenefitsGroupedItemNo", popBenefitsGroupedItemNo);
					params.put("popBenefitsPackBenCd", popBenefitsPackBenCd);
					
					message = gipiWAccidentItemService.saveGIPIParAccidentItemModal(params);
					PAGE = "/pages/genericMessage.jsp";
				}else if ("getEndtGipiWItemAccidentDetails".equals(ACTION)){ //item no. step 2 validation
					//GIPIWAccidentItemService gipiWAccidentItemService = (GIPIWAccidentItemService)  APPLICATION_CONTEXT.getBean("gipiWAccidentItemService");
					DateFormat df = new SimpleDateFormat("MM-dd-yyyy"); 
					
					String lineCd = request.getParameter("lineCd");
					@SuppressWarnings("unused")
					String issueCd = request.getParameter("issueCd");
					String sublineCd = request.getParameter("sublineCd");
					String issCd = request.getParameter("issCd");
					int itemNo= Integer.parseInt(request.getParameter("itemNo"));
					String expiryDate = request.getParameter("expiryDate");
					String effDate = request.getParameter("effDate");
					int issueYy = Integer.parseInt(request.getParameter("issueYy"));
					int polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
					int renewNo = Integer.parseInt(request.getParameter("renewNo"));
					BigDecimal annTsiAmt = new BigDecimal(request.getParameter("annTsiAmt") == "" ?"0" : request.getParameter("annTsiAmt"));
				    BigDecimal annPremAmt = new BigDecimal(request.getParameter("annPremAmt") == "" ? "0" : request.getParameter("annPremAmt"));  
				    
				    Map<String, Object> params = new HashMap<String, Object>();
					params.put("lineCd", lineCd);
					params.put("sublineCd", sublineCd);
					params.put("issCd", issCd);
					params.put("itemNo", itemNo);
					params.put("expiryDate", df.parse(expiryDate));
					params.put("effDate", df.parse(effDate));
					params.put("issueYy", issueYy);
					params.put("polSeqNo", polSeqNo);
					params.put("renewNo", renewNo);
					params.put("annTsiAmt", annTsiAmt);
					params.put("annPremAmt", annPremAmt);
					System.out.println(params.toString());					
					
					GIPIWAccidentItem acc = gipiWAccidentItemService.getEndtGipiWAccidentItemDetails(params);
					@SuppressWarnings("unused")
					Map<String, GIPIWAccidentItem>test = new HashMap<String, GIPIWAccidentItem>();
					
					System.out.println(acc.toString()); 
	
					System.out.println();
					
					//0-item title, 1 coverage, 2 groupcd, 3 fromdate, 4 todate, 5 restrictedcondition, 6, changedtag, 7 prorateflag, 8 comsw, 9 shortratepercent
					// 10 recflag// 11 region code//12 anntsiamt// 13 annpremamt//14 currencycd
					message= acc.getItemTitle()+","+acc.getCoverageCd()+","+acc.getGroupCd()+","+acc.getFromDate()+","+acc.getToDate()+","+acc.getRestrictedCondition()
					+","+acc.getChangedTag()+","+acc.getProrateFlag()+","+acc.getCompSw()+","+acc.getShortRtPercent()+","+acc.getRecFlag()+","+acc.getRegionCd()+","
					+acc.getAnnTsiAmt()+","+acc.getAnnPremAmt()+","+acc.getCurrencyCd();
					PAGE = "/pages/genericMessage.jsp";
				}else if("preInsertAccident".equals(ACTION)){
					String lineCd = request.getParameter("lineCd");
		      		String sublineCd = request.getParameter("sublineCd");
		      		String issCd = request.getParameter("issCd");
		      		int issueYy = Integer.parseInt(request.getParameter("issueYy"));
		      		int polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
		      		int renewNo = Integer.parseInt(request.getParameter("renewNo"));
		      		int itemNo = Integer.parseInt(request.getParameter("itemNo"));
		      		int currencyCd = Integer.parseInt(request.getParameter("currencyCd"));
		      		
		      		Map<String, Object> params = new HashMap<String, Object>();
		      		params.put("lineCd", lineCd);
		      		params.put("sublineCd", sublineCd);
		      		params.put("issCd", issCd);
		      		params.put("issueYy", issueYy);
		      		params.put("polSeqNo", polSeqNo);
		      		params.put("renewNo", renewNo);
		      		params.put("itemNo", itemNo);
		      		params.put("currencyCd", currencyCd);
		      		
		      		message = gipiWAccidentItemService.preInsertAccident(params);
		      		PAGE = "/pages/genericMessage.jsp";
				}else if("preInsertEndtAccident".equals(ACTION)){
					DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
					
					String lineCd = request.getParameter("lineCd");
		      		String sublineCd = request.getParameter("sublineCd");
		      		String issCd = request.getParameter("issCd");
		      		int issueYy = Integer.parseInt(request.getParameter("issueYy"));
		      		int polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
		      		int renewNo = Integer.parseInt(request.getParameter("renewNo"));
		      		int itemNo = Integer.parseInt(request.getParameter("itemNo"));
		      		int currencyCd = Integer.parseInt(request.getParameter("currencyCd"));
		      		Date effDate = df.parse(request.getParameter("effDate"));
					Map<String, Object>params = new HashMap<String, Object>();
					
					System.out.println(effDate + " : effectivity date");
					
					params.put("lineCd", lineCd);
		      		params.put("sublineCd", sublineCd);
		      		params.put("issCd", issCd);
		      		params.put("issueYy", issueYy);
		      		params.put("polSeqNo", polSeqNo);
		      		params.put("renewNo", renewNo);
		      		params.put("itemNo", itemNo);
		      		params.put("currencyCd", currencyCd);
		      		params.put("effDate", effDate);
		      		
		      		GIPIWAccidentItem acc = gipiWAccidentItemService.preInsertEndtAccident(params);
		      		//System.out.println(acc.);
					//gipiWAccidentItemService.preInsertAccident(params);
		      		System.out.println("restricted = "+acc.getRestrictedCondition());
		      		//0 restricted condition, 1 ann tsi amt, 2 prem amt, 3 currency cd, restricted condition2 4
		      		// restricted condition = N or 1 OR 2
		      		message = acc.getRestrictedCondition()+","+acc.getAnnTsiAmt()+","+acc.getAnnPremAmt()+","+acc.getCurrencyCd()+","+acc.getRestrictedCondition2();
		      		PAGE = "/pages/genericMessage.jsp";
				} else if ("checkUpdateGipiWPolbasValidity".equals(ACTION)){
					message = gipiWAccidentItemService.checkUpdateGipiWPolbasValidity(this.getUpdateGIPIWPolbasParams(request));
					PAGE = "/pages/genericMessage.jsp";
				}else if ("checkCreateDistributionValidity".equals(ACTION)){					
					message = gipiWAccidentItemService.checkCreateDistributionValidity(parId);
					PAGE = "/pages/genericMessage.jsp";
				}else if ("checkGiriDistfrpsExist".equals(ACTION)){
					message = gipiWAccidentItemService.checkGiriDistfrpsExist(parId);
					PAGE = "/pages/genericMessage.jsp";
					
				}else if("showGIPIWAccidentInfo".equals(ACTION)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("user", USER);
					
					String parType = request.getParameter("globalParType") == null ? "P" : request.getParameter("globalParType");
					request.setAttribute("formMap", new JSONObject(gipiWAccidentItemService.newFormInstance(params)));
					if(parType.equals("P")) {
						PAGE = "/pages/underwriting/par/accident/accidentItemInfoMain.jsp";
					}
				} else if("getGIPIWItemTableGridAC".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("user", USER);					
					
					request.setAttribute("formMap", new JSONObject(gipiWAccidentItemService.newFormInstanceTG(params)));
					message = "SUCCES";
					PAGE = "/pages/underwriting/parTableGrid/accident/accidentItemInformationMain.jsp";					
				}else if("saveGIPIWAccidentInfo".equals(ACTION)) {
					log.info("Saving accident items:: " + parId);
					gipiWAccidentItemService.saveGIPIWAccidentItem(request.getParameter("parameters"), USER);
					message="SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}else if("showACGroupedItems".equals(ACTION)) {
					System.out.println("Item NO ========== "+request.getParameter("itemNo"));
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("user", USER);
					String parType = request.getParameter("globalParType") == null ? "P" : request.getParameter("globalParType");
					
					request.setAttribute("groupMap", new JSONObject(gipiWAccidentItemService.showACGroupedItems(params)));
					request.setAttribute("isFromOverwriteBen", request.getParameter("isFromOverwriteBen"));
					
					if(parType.equals("P")) {
						PAGE = "/pages/underwriting/par/accident/subPages/groupedItems/acGroupedItemsMain.jsp";
					}
				}else if("showACGroupedItemsTableGrid".equals(ACTION)) {					
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("parId", parId);
					params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
					params.put("request", request);					
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("user", USER);					
					
					request.setAttribute("groupMap", new JSONObject(gipiWAccidentItemService.showACGroupedItemsTG(params)));
					request.setAttribute("isFromOverwriteBen", request.getParameter("isFromOverwriteBen"));					
					
					PAGE = "/pages/underwriting/parTableGrid/accident/subPages/groupedItems/accGroupedItemsMainOverlay.jsp";					
				}else if("checkIfPerilsExistsForEndt".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
					
					message = gipiWAccidentItemService.gipis065CheckIfPerilExists(params);
					PAGE = "/pages/genericMessage.jsp";
				}else if("saveAccidentGroupedItemsModalTG".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("param", request.getParameter("parameters"));
					params.put("USER", USER);
					params.put("parId", request.getParameter("parId"));
					params.put("lineCd", request.getParameter("lineCd"));
					params.put("issCd", request.getParameter("issCd"));
					
					gipiWAccidentItemService.saveAccidentGroupedItemsModalTG(params);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}else if("showPopulateBenefits".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();		
					params.put("request", request);
					JSONObject json = new JSONObject(gipiWAccidentItemService.showPopulateBenefits(params));
					
					if("1".equals(request.getParameter("refresh"))){ //marco - 05.23.2013 - added refresh condition
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					}else{
						request.setAttribute("groupedItems", new JSONObject(gipiWAccidentItemService.showPopulateBenefits(params)));
						PAGE = "/pages/underwriting/overlay/populateBenefits.jsp";					
					}
				}else if("populateBenefits".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("parameters", request.getParameter("parameters"));
					params.put("selectedGroupedItemNo", Integer.parseInt(request.getParameter("selectedGroupedItemNo")));
					params.put("delBenSw", request.getParameter("delBenSw"));
					params.put("popChecker", request.getParameter("popChecker"));
					params.put("issCd", request.getParameter("issCd"));
					params.put("lineCd", request.getParameter("lineCd"));
					
					gipiWAccidentItemService.populateBenefits(params);
					
					PAGE = "/pages/genericMessage.jsp";
				} 
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){  //to handle customize ORACLE Error.
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			}else {
				message = ExceptionHandler.handleException(e, USER);
			}
			//message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private List<GIPIWBeneficiary> prepareBeneficiaryItems(
			HttpServletRequest request) throws ParseException {
		List<GIPIWBeneficiary> beneficiaryItems = new ArrayList<GIPIWBeneficiary>();
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(request.getParameterValues("bItemNos") != null){
			String[] bParIds					= request.getParameterValues("bParIds");
			String[] bItemNos					= request.getParameterValues("bItemNos");
			String[] bBeneficiaryNos			= request.getParameterValues("bBeneficiaryNos");
			String[] bBeneficiaryNames			= request.getParameterValues("bBeneficiaryNames");
			String[] bBeneficiaryAddrs			= request.getParameterValues("bBeneficiaryAddrs");
			String[] bBeneficiaryDateOfBirths	= request.getParameterValues("bBeneficiaryDateOfBirths");
			String[] bBeneficiaryAges			= request.getParameterValues("bBeneficiaryAges");
			String[] bBeneficiaryRelations		= request.getParameterValues("bBeneficiaryRelations");
			String[] bBenefeciaryRemarkss		= request.getParameterValues("bBenefeciaryRemarkss");
			
			for (int a = 0; a < bItemNos.length; a++) {
				beneficiaryItems.add(new GIPIWBeneficiary(bParIds[a],bItemNos[a],
						bBeneficiaryNos[a],bBeneficiaryNames[a],bBeneficiaryAddrs[a],
						bBeneficiaryRelations[a],(bBeneficiaryDateOfBirths[a] == "" || bBeneficiaryDateOfBirths[a] == null ? null : sdf.parse(bBeneficiaryDateOfBirths[a])),
						bBeneficiaryAges[a],bBenefeciaryRemarkss[a]
						));
			}
		}
		return beneficiaryItems;
	}

	private List<GIPIWAccidentItem> prepareAccidentItems(
			HttpServletRequest request) throws ParseException {
		List<GIPIWAccidentItem> accidentItems = new ArrayList<GIPIWAccidentItem>();
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(request.getParameterValues("itemItemNos") != null){
			String[] parIds				    = request.getParameterValues("itemParIds");
			String[] itemNos				= request.getParameterValues("itemItemNos");
			String[] noOfPersons			= request.getParameterValues("noOfPersons");
			String[] destinations			= request.getParameterValues("destinations");
			String[] monthlySalarys			= request.getParameterValues("monthlySalarys");
			String[] salaryGrades			= request.getParameterValues("salaryGrades");
			String[] positionCds			= request.getParameterValues("positionCds");
			String[] delGrpItemsInItems     = request.getParameterValues("delGrpItemsInItems");
			String[] dateOfBirths     		= request.getParameterValues("dateOfBirths");
			String[] ages     				= request.getParameterValues("ages");
			String[] civilStatuss     		= request.getParameterValues("civilStatuss");
			String[] sexs     				= request.getParameterValues("sexs");
			String[] heights     			= request.getParameterValues("heights");
			String[] weights     			= request.getParameterValues("weights");
			String[] groupPrintSws     		= request.getParameterValues("groupPrintSws");
			String[] acClassCds     		= request.getParameterValues("acClassCds");
			String[] levelCds     			= request.getParameterValues("levelCds");
			String[] parentLevelCds     	= request.getParameterValues("parentLevelCds");
			String[] populatePerilss		= request.getParameterValues("populatePerilss");
			String[] accidentDeleteBills	= request.getParameterValues("accidentDeleteBills");
			
			System.out.println("No of people :" +noOfPersons[0]);
			for (int a = 0; a < itemNos.length; a++) {
				accidentItems.add(new GIPIWAccidentItem(parIds[a],itemNos[a],
						noOfPersons[a].replaceAll(",", ""),destinations[a],
						(monthlySalarys[a] == null || monthlySalarys[a] == "" ? null : new BigDecimal(monthlySalarys[a].replaceAll(",", ""))),
						salaryGrades[a],positionCds[a],delGrpItemsInItems[a],
						(dateOfBirths[a] == "" || dateOfBirths[a] == null ? null : sdf.parse(dateOfBirths[a])),
						ages[a],civilStatuss[a],heights[a],weights[a],sexs[a],
						groupPrintSws[a],acClassCds[a],levelCds[a],parentLevelCds[a],
						populatePerilss[a],accidentDeleteBills[a]
						));
			}
		}
		return accidentItems;
	}

	private Map<String, Object> getUpdateGIPIWPolbasParams(HttpServletRequest request){		
		int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
		String negateItem = request.getParameter("varNegateItem");
		String prorateFlag = request.getParameter("varProrateFlag");
		String compSw = request.getParameter("varCompSw");
		String endtExpiryDate = request.getParameter("varEndtExpiryDate");
		String effDate = request.getParameter("varEffDate");
		BigDecimal shortRtPercent = request.getParameter("varShortRtPercent") == "" ? null : new BigDecimal(request.getParameter("varShortRtPercent"));
		String expiryDate = request.getParameter("varExpiryDate");
		
		log.info("parId: "+parId);
		log.info("negateItem: "+negateItem);
		log.info("prorateFlag: "+prorateFlag);
		log.info("compSw: "+compSw);
		log.info("endtExpiryDate: "+endtExpiryDate);
		log.info("effDate: "+effDate);
		log.info("shortRtPercent: "+shortRtPercent);
		log.info("expiryDate: "+expiryDate);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("negateItem", negateItem);
		params.put("prorateFlag", prorateFlag);
		params.put("compSw", compSw);
		params.put("endtExpiryDate", endtExpiryDate);
		params.put("effDate", effDate);
		params.put("shortRtPercent", shortRtPercent);
		params.put("expiryDate", expiryDate);
		return params;
	}

}

