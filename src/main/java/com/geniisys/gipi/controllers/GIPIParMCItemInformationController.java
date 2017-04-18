/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIParItemMC;
import com.geniisys.gipi.entity.GIPIWMcAcc;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParItemMCService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.geniisys.gipi.util.GIPIWDeductiblesUtil;
import com.geniisys.gipi.util.GIPIWItemPerilUtil;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIParMCItemInformationController.
 */
public class GIPIParMCItemInformationController extends BaseController {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIParMCItemInformationController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env

		try {
			/* default attributes */
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			//GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
			//GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
			GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
			
			//LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env			
			
			//int parId = Integer.parseInt(request.getParameter((parType.equals("P")) ? "globalParId" : "globalEndtParId"));
			int parId;
			
			parId = Integer.parseInt(request.getParameter("globalParId"));
			
			if(parId == 0){
				message = "PAR No. is empty";
				PAGE = "/pages/genericMessage.jsp";
			}else{	
				if (parId != 0)	{
					GIPIPARList gipiPAR = null;
					GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
					gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
					gipiPAR.setParId(parId);
					request.setAttribute("parDetails", gipiPAR);
					System.out.println("discExists: "+gipiPAR.getDiscExists());
				}
				
				if("showMotorItemInfo".equals(ACTION)){
					GIPIWPolbas wPolbas =  gipiWPolbasService.getGipiWPolbas(parId);
					
					DateFormat df = new SimpleDateFormat("MM-dd-yyyy");					
					
					String lineCd = request.getParameter("lineCd"); // andrew - 10.05.2010 - get the line code from request
					request.setAttribute("parId", parId);
					request.setAttribute("lineCd", lineCd);
					request.setAttribute("sublineCd", wPolbas.getSublineCd());
					request.setAttribute("fromDate", df.format(wPolbas.getInceptDate()));
					request.setAttribute("toDate", df.format(wPolbas.getExpiryDate()));	
					request.setAttribute("wPolbas", wPolbas);
					
					GIPIParItemMCService gipiWItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env					
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
					@SuppressWarnings("unused")
					GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					
					List<GIPIParItemMC> items = gipiWItemMCService.getGIPIParItemMCs(parId);
					String parType = request.getParameter("globalParType");
					
					loadListingToRequest(request, lovHelper, wPolbas);
					
					int itemSize = items.size();					
					
					//request.setAttribute("parNo", request.getParameter("globalParNo"));
					//request.setAttribute("assdName", request.getParameter("globalAssdName"));
					
					request.setAttribute("parNo", gipiWItemMCService.getParNo(parId));
					request.setAttribute("assdName", gipiWItemMCService.getAssuredName(wPolbas.getAssdNo()));
					
					request.setAttribute("items", items);
					request.setAttribute("itemCount", itemSize);
					request.setAttribute("policyNo", composePolicyNo(wPolbas));
					request.setAttribute("wItemParCount", itemSize);
					//System.out.println(gipiWItemService.getGIPIWItem(parId));
					//System.out.println(StringFormatter.replaceQuotesInList(gipiWItemService.getGIPIWItem(parId)));
					request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiWItemService.getGIPIWItem(parId)));
					//request.setAttribute("itemsWPerilGroupedListing", new JSONArray (StringFormatter.replaceQuotesInList(gipiWItemService.getGIPIWItem(parId))));
					
					StringBuilder arrayItemNo = new StringBuilder(itemSize);
					StringBuilder arrayMotorNo = new StringBuilder(itemSize);
					StringBuilder arraySerialNo = new StringBuilder(itemSize);
					StringBuilder arrayPlateNo = new StringBuilder(itemSize);
					int lastItemNo = 0;
					
					for(GIPIParItemMC mc : items){						
						arrayItemNo.append(mc.getItemNo() + " ");
						arrayMotorNo.append(mc.getMotorNo() + "\n");
						arraySerialNo.append(mc.getSerialNo() + "\n");
						arrayPlateNo.append(mc.getPlateNo() + "\n ");
						
						if(Integer.parseInt(mc.getItemNo()) > lastItemNo){
							lastItemNo = Integer.parseInt(mc.getItemNo());
						}						
					}
					
					request.setAttribute("lastItemNo", lastItemNo);
					request.setAttribute("itemNumbers", arrayItemNo.toString());
					request.setAttribute("motorNumbers", arrayMotorNo.toString());
					request.setAttribute("serialNumbers", arraySerialNo.toString());
					request.setAttribute("plateNumbers", arrayMotorNo.toString());
					request.setAttribute("wPolBasic", wPolbas);
					
					/*
					GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					String issCdRi = serv.getParamValueV2("ISS_CD_RI");
					request.setAttribute("issCdRi", issCdRi);
					request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
					gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
					String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
					request.setAttribute("pDeductibleExist", pDeductibleExist);
					request.setAttribute("dedItemPeril", gipiWdeductibleService.getDeductibleItemAndPeril(parId, lineCd, sublineCd));
					*/					
					
					if (parType != null) {
						if ("E".equals(parType)) {
							GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
							GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
							//gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
							
							Date expiryDate = gipiPolbasicService.extractExpiryDate(parId);
							
							String endtTaxSw = gipiWItemMCService.getEndtTax(parId);
							String discExists = gipiWItemMCService.checkIfDiscountExists(parId);
							Integer dfltCoverage = giisParamService.getParamValueN("DEFAULT_COVERAGE_CD");
							String vDisplayMotorCoverage = giisParamService.getParamValueV2("DISPLAY_MOTOR_COVERAGE");
							String vGenerateCOCSerial = giisParamService.getParamValueV2("GENERATE_COC_SERIAL");
							String vPhilPeso = giisParamService.getParamValueV2("PHP");
							String vAllowUpdateCurrRate = giisParamService.getParamValueV2("ALLOW_UPDATE_CURR_RATE");
							String vMotorCar = giisParamService.getParamValueV2("MOTOR CAR");
							String vMotorCycle = giisParamService.getParamValueV2("MOTORCYCLE");
							String vCommercialVehicle = giisParamService.getParamValueV2("COMMERCIAL VEHICLE");
							String vPrivateCar = giisParamService.getParamValueV2("PRIVATE CAR");
							String vLto = giisParamService.getParamValueV2("LAND TRANS. OFFICE");
							String vCocLto = giisParamService.getParamValueV2("COC_TYPE_LTO");
							String vCocNlto = giisParamService.getParamValueV2("COC_TYPE_NLTO");
							List<GIISParameter> towingParams = giisParamService.getParamValues("TOWING%");
							List<GIISParameter> plateNoParams = giisParamService.getParamValues("PLATE NUMBER%");
							String vAllowCurrRtUpdate = giisParamService.getParamValueV2("ALLOW_UPDATE_CURR_RATE");
							//String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); -- taken outside of the condition for endt so that it can be used for ordinary PAR (BRY 07.26.2010)
							
							request.setAttribute("parType", "E");
							request.setAttribute("varPackParId", wPolbas.getPackParId());
							request.setAttribute("endtTaxSw", endtTaxSw);
							request.setAttribute("discExists", discExists);
							request.setAttribute("vPhilPeso", vPhilPeso);
							request.setAttribute("paramDfltCoverage", dfltCoverage);
							request.setAttribute("vDisplayMotor", vDisplayMotorCoverage);
							request.setAttribute("vGenerateCOCSerial", vGenerateCOCSerial);
							request.setAttribute("pAllowUpdateCurrRate", vAllowUpdateCurrRate);
							request.setAttribute("vMotorCar", vMotorCar);
							request.setAttribute("vMotorCycle", vMotorCycle);
							request.setAttribute("vCommercialVehicle", vCommercialVehicle);
							request.setAttribute("vPrivateCar", vPrivateCar);
							request.setAttribute("vLto", vLto);
							request.setAttribute("vCocLto", vCocLto);
							request.setAttribute("vCocNlto", vCocNlto);
							request.setAttribute("expiryDate", expiryDate == null ? null : df.format(expiryDate));
							request.setAttribute("towingParams", towingParams);
							request.setAttribute("plateNoParams", plateNoParams);
							request.setAttribute("vAllowCurrRtUpdate", vAllowCurrRtUpdate);
							//request.setAttribute("pDeductibleExist", pDeductibleExist);
							
							//gipi_wpolbas
							//format the date and time of some attributes
							request.setAttribute("effDate", wPolbas.getEffDate() == null ? " " : df.format(wPolbas.getEffDate()));
							request.setAttribute("endtExpiryDate", wPolbas.getEndtExpiryDate() == null ? " " : df.format(wPolbas.getEndtExpiryDate()));
							request.setAttribute("expiryDate", wPolbas.getExpiryDate() == null ? " " : df.format(wPolbas.getExpiryDate()));
							request.setAttribute("wPolbas", wPolbas);
							
							log.info("Pack Par ID - " + wPolbas.getPackParId());
							log.info("Endt Tax SW - " + endtTaxSw);
							log.info("Param Dflt Coverage - " + dfltCoverage);
							log.info("vDisplay - " + vDisplayMotorCoverage);
							log.info("Generate COC Serial - " + vGenerateCOCSerial);
							log.info("Allow update cur rate - " + vAllowUpdateCurrRate);
							log.info("Loaded Expiry Date - " + expiryDate);
							log.info("Par Expiry Date - " + wPolbas.getExpiryTag());
							log.info("Par Endt Expiry Date - " + wPolbas.getEndtExpiryTag());
							PAGE = "/pages/underwriting/endt/motorcar/endtMotorItemInformationMain.jsp";
						}else{
							PAGE = "/pages/underwriting/itemInformation.jsp";
						}
					}
					
					// load variables for new form instance
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("lineCd", wPolbas.getLineCd());
					params.put("sublineCd", wPolbas.getSublineCd());
					params.put("issCd", wPolbas.getIssCd());
					
					params = gipiWItemMCService.gipis010NewFormInstance(params);
					
					if(params.get("msgAlert") == null){
						request.setAttribute("issCdRi", params.get("issCdRi"));
						request.setAttribute("paramName", params.get("paramName"));
						request.setAttribute("pDeductibleExist", params.get("perilDedExist"));
						request.setAttribute("dedItemPeril", params.get("dedItemPeril"));
						
						params.remove("parId");
						params.remove("lineCd");
						params.remove("sublineCd");
						params.remove("issCd");
						params.remove("issCdRi");
						params.remove("paramName");
						params.remove("perilDedExist");
						params.remove("dedItemPeril");
						
						loadNewFormInstanceVariableToRequest(request, params);
					}else{
						request.setAttribute("message", params.get("msgAlert"));
						PAGE = "/pages/genericMessage.jsp";
					}
				} else if("saveGipiParVehicle".equals(ACTION)){								
					log.info("Saving Motor Car (MC) Details");
					//request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
					GIPIParMortgageeFacadeService gipiParMortgageeService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService"); // +env 
					
					Map<String, Object> param = new HashMap<String, Object>();
					
					// policy deductibles - ADDED BY BRY 10.19.2010 (for deleting all deductibles when peril is added)
					String[] delDedPolNos = request.getParameterValues("delDedItemNo1");
					
					// item info
					@SuppressWarnings("unused")
					Map<String, Object> insItemMap = GIPIWItemUtil.prepareGipiWItemForInsertUpdate(request);
					Map<String, Object> delItemMap = GIPIWItemUtil.prepareGipiWItemForDelete(request);					
					Map<String, Object> vehicleMap = prepareGipiWVehicle(request);
					Map<String, Object> globals = new HashMap<String, Object>();
					Map<String, Object> vars = new HashMap<String, Object>();
					Map<String, Object> pars = new HashMap<String, Object>();
					Map<String, Object> others = new HashMap<String, Object>();
					JSONObject params = new JSONObject(request.getParameter("parameters"));
					
					// item deductibles
					String[] insDedItemNos = request.getParameterValues("insDedItemNo2");
					String[] delDedItemNos = request.getParameterValues("delDedItemNo2");
					
					// mortgagee
					//String[] insMortgItemNos = request.getParameterValues("insMortgItemNos");
					//String[] delMortgItemNos = request.getParameterValues("delMortgageeItemNos");
					
					// accessory
					String[] insAccItemNos = request.getParameterValues("accItemNos");
					String[] delAccItemNos = request.getParameterValues("delAccItemNos");
					
					// item perils
					//String[] insItemPerilItemNos 	= request.getParameterValues("perilItemNos");
					//String[] delItemPerilItemNos 	= request.getParameterValues("delPerilItemNos");
					
					// peril deductibles
					String[] insPerilDedItemNos	= request.getParameterValues("insDedItemNo3");
					String[] delPerilDedItemNos = request.getParameterValues("delDedItemNo3");
					
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
							//System.out.println(element+": "+request.getParameter(element));
							others.put(element, request.getParameter(element));
						}
					}
					
					//ADDED BY BRY for deletion of policy level ded when making changes in peril
					if(delDedPolNos != null){
						param.put("polDeductibleDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 1));
					}
					
					// item deductible
					if(insDedItemNos != null){
						param.put("deductibleInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 2));
					}
					
					if(delDedItemNos != null){
						param.put("deductibleDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 2));
					}
					
					// mortgagee
					/*
					if(insMortgItemNos != null){
						param.put("mortgageeInsList", GIPIWMortgageeUtil.prepareInsGipiWMortgageeList(request, USER));
					}
					
					if(delMortgItemNos != null){
						param.put("mortgageeDelList", GIPIWMortgageeUtil.prepareDelGipiWMortgageeList(request));
					}
					*/
					param.put("mortgageeInsList", gipiParMortgageeService.prepareGIPIWMortgageeForInsert(new JSONArray(params.getString("setMortgagees"))));
					param.put("mortgageeDelList", gipiParMortgageeService.prepareGIPIWMortgageeForDelete(new JSONArray(params.getString("delMortgagees"))));
					
					GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					param.put("perilInsList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("setPerils"))));
					param.put("perilDelList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("delPerils"))));
					
					GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
					param.put("wcInsList", gipiWPolWCService.prepareGIPIWPolWCForInsert(new JSONArray(params.getString("setWCs"))));
					
					// accessory
					if(insAccItemNos != null){
						param.put("accessoryInsList", prepareInsGipiWMcAccList(request, USER));
					}
					
					if(delAccItemNos != null){
						param.put("accessoryDelList", prepareDelGipiWMcAccList(request));
					}
					
					// item perils
					/*if(insItemPerilItemNos != null){
						param.put("itemPerilInsList", GIPIWItemPerilUtil.prepareInsItemPerilList(request));						
					}
					
					if(delItemPerilItemNos != null){						
						param.put("itemPerilDelList", GIPIWItemPerilUtil.prepareDelGipiWDeductiblesList(request));
					}*/
					
					// peril deductible
					if(insPerilDedItemNos != null){
						param.put("perilDedInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 3));
					}
					
					if(delPerilDedItemNos != null){
						param.put("perilDedDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 3));
					}
					
					//param.put("insItemMap", insItemMap);
					param.put("delItemMap", delItemMap);
					param.put("vehicleMap", vehicleMap);
					param.put("globals", globals);
					param.put("vars", vars);
					param.put("pars", pars);
					param.put("others", others);
					param.put("parId", parId);
					param.put("userId", USER.getUserId());
					param.put("gipiParList", GIPIPARUtil.prepareGIPIParList(request));
					param.put("itemList", GIPIWItemUtil.prepareGIPIWItems(request));
					param.put("vehicleList", prepareGIPIWVehicles(request));
					
					// add peril variables to map
					param = GIPIWItemPerilUtil.loadPerilVariablesToMap(request, param);					
					
					if(gipiParItemMCService.saveItemMotorCar(param)){
						message = "SUCCESS";
					}else{
						message = "FAILED";
					}					
					
					PAGE = "/pages/genericMessage.jsp";
				} else if("deleteItem".equals(ACTION)){
					System.out.println("delete");
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
					int deleteItemNo = (request.getParameter("itemNo").isEmpty() || request.getParameter("itemNo").equals("")) ? 0 : Integer.parseInt(request.getParameter("itemNo"));
					
					gipiParItemMCService.deleteGIPIParItemMC(36792, deleteItemNo);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
					request.setAttribute("message", message);			
				} else if("filterMakes".equals(ACTION)){
					log.info("Filtering Makes ...");
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env			
					String[] carCompany = {request.getParameter("carCompany")};
					request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_LISTING, carCompany));
					PAGE = "/pages/underwriting/dynamicDropDown/makes.jsp";
				} else if("filterEngineSeries".equals(ACTION)){
					log.info("Filtering Engine Series ...");
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					GIPIWPolbas wPolbas =  gipiWPolbasService.getGipiWPolbas(parId);
					String[] make = {request.getParameter("make"), wPolbas.getSublineCd(), request.getParameter("carCompanyCd")};
					request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_SERIES_LISTING, make));
					PAGE = "/pages/marketing/quotation/dynamicDropdown/engineSeries.jsp";				
				} else if ("filterColors".equals(ACTION)) {
					log.info("Filtering Colors ...");
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env			
					String[] basicColorCd = {request.getParameter("basicColorCd")};
					request.setAttribute("colors", lovHelper.getList(LOVHelper.MC_COLOR_LISTING, basicColorCd));
					PAGE = "/pages/marketing/quotation/dynamicDropdown/colors.jsp";
				} else if("checkCOCSerialNoInPolicy".equals(ACTION)){
					log.info("Checking COC Serial No. in Policy ...");
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
					int cocSerialNo = Integer.parseInt(request.getParameter("cocSerialNo"));				
					System.out.println("Serial No: " + cocSerialNo);
					message = gipiParItemMCService.checkCOCSerialNoInPolicy(cocSerialNo);
					PAGE = "/pages/genericMessage.jsp";
					request.setAttribute("message", message);
					System.out.println("COC Serial in Policy: " + message);				
				} else if("checkCOCSerialNoInPar".equals(ACTION)){
					log.info("Checking COC Serial No. in Par ...");	
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env				
					int itemNo = Integer.parseInt(request.getParameter("itemNo"));
					int cocSerialNo = Integer.parseInt(request.getParameter("cocSerialNo"));
					String cocType = request.getParameter("cocType");
					
					message = gipiParItemMCService.checkCOCSerialNoInPar(parId, itemNo, cocSerialNo, cocType);
					PAGE = "/pages/genericMessage.jsp";
					request.setAttribute("message", message);
					System.out.println("COC Serial in PAR: " + message);
				} else if("validateOtherInfo".equals(ACTION)){
					log.info("Validating Other Info ...");
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
					message = gipiParItemMCService.validateOtherInfo(parId);
					PAGE = "/pages/genericMessage.jsp";
					request.setAttribute("message", message);
					System.out.println("Validate Other Info: " + message);			
				} else if ("showUploadFleetPage".equals(ACTION)) {
					request.setAttribute("parId", request.getParameter("globalParId"));
					PAGE = "/pages/underwriting/overlay/uploadFleetPolicy.jsp";
				} else if ("updateMotorTypeList".equals(ACTION)) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String sublineCd;
					
					List<LOV> motorTypeList;
					int listSize = 0;
					
					sublineCd = request.getParameter("packSublineCd");
					if (sublineCd == null) {
						sublineCd = "";
					}
					String[] motorTypeParams = {sublineCd};
					motorTypeList = lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING , motorTypeParams);
					listSize = motorTypeList == null ? 0 : motorTypeList.size();
					
					request.setAttribute("motorTypeList", motorTypeList);
					request.setAttribute("motorTypeListSize", listSize);
					
					message = "SUCCESS";
					PAGE = "/pages/underwriting/subPages/ajaxUpdateLOV.jsp";
				} else if ("updateSublineTypeList".equals(ACTION)) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					List<LOV> sublineTypeList;
					int listSize = 0;
					String sublineCd;
					sublineCd = request.getParameter("packSublineCd");
					if (sublineCd == null) {
						sublineCd = "";
					}
					String[] motorTypeParams = {sublineCd};
					sublineTypeList = lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING , motorTypeParams);
					listSize = sublineTypeList == null ? 0 : sublineTypeList.size();
					
					request.setAttribute("sublineTypeList", sublineTypeList);
					request.setAttribute("sublineTypeListSize", listSize);
					
					message = "SUCCESS";
					PAGE = "/pages/underwriting/subPages/ajaxUpdateLOV.jsp";
				} else if ("updateGipiWpolbasEndt".equals(ACTION)) {
					GIPIWPolbas wPolbas =  gipiWPolbasService.getGipiWPolbas(parId);
					String negateItem = request.getParameter("negateItem") == null ? "" : request.getParameter("negateItem"); 
					String prorateFlag = request.getParameter("prorateFlag") == null ? "" : request.getParameter("prorateFlag");
					String compSw = request.getParameter("compSw") == null ? "" : request.getParameter("compSw");
					String endtExpiryDate = request.getParameter("endtExpiryDate") == null ? "" : request.getParameter("endtExpiryDate");
					String effDate = request.getParameter("effDate") == null ? "" : request.getParameter("effDate");
					String expiryDate = request.getParameter("expiryDate") == null ? "" : request.getParameter("expiryDate");
					BigDecimal shortRtPercent = request.getParameter("shortRtPercent") == null ? null : request.getParameter("shortRtPercent").trim().length() == 0 ? null : new BigDecimal(request.getParameter("shortRtPercent"));
						
					message = gipiWPolbasService.updateGipiWpolbasEndt(parId, wPolbas.getLineCd(), negateItem, prorateFlag, compSw, endtExpiryDate, effDate, shortRtPercent, expiryDate);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("showAddDeleteItemDiv".equals(ACTION)) {					
					GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
					GIPIWPolbas wPolbas =  gipiWPolbasService.getGipiWPolbas(parId);
					message = gipiWdeductibleService.isExistGipiWdeductible(parId, wPolbas.getLineCd(), wPolbas.getSublineCd());
					request.setAttribute("message", message);
					PAGE = "/pages/underwriting/subPages/endtItemInfoAddDeleteItem.jsp";
				} else if ("deleteEndtItem".equals(ACTION)) {
					message = "SUCCESS";
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					String[] strItemNos = request.getParameter("itemNos").split(" ");
					int currentItemNo = request.getParameter("itemNo") == null ? 0 : Integer.parseInt(request.getParameter("itemNo"));
					int[] itemNo = new int[strItemNos.length];
					
					for (int i = 0; i < strItemNos.length; i++) {
						itemNo[i] = Integer.parseInt(strItemNos[i]);
					}
					
					gipiParItemMCService.deleteEndtItem(parId, itemNo, currentItemNo);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("addEndtItem".equals(ACTION)) {
					message = "SUCCESS";
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					String[] strItemNos = request.getParameter("itemNos").split(" ");
					int[] itemNo = new int[strItemNos.length];
					
					for (int i = 0; i < strItemNos.length; i++) {
						itemNo[i] = Integer.parseInt(strItemNos[i]);
					}
					
					gipiParItemMCService.addEndtItem(parId, itemNo);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("checkAdditionalInfo".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					message = gipiParItemMCService.checkAddtlInfo(parId);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("getDistNo".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					message = Integer.toString(gipiParItemMCService.getDistNo(parId));
					PAGE = "/pages/genericMessage.jsp";
				} else if ("deleteDistribution".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					int distNo = request.getParameter("distNo") == null ? 0 : Integer.parseInt(request.getParameter("distNo"));
					message = gipiParItemMCService.deleteDistribution(parId, distNo);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("deleteWinvRecords".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					gipiParItemMCService.deleteWinvRecords(parId);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				} else if ("validateEndtParMCItemNo".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					int itemNo = Integer.parseInt(request.getParameter("itemNo"));
					String dfltCoverage = request.getParameter("dfltCoverage");
					String expiryDate = request.getParameter("expiryDate");
					message = gipiParItemMCService.validateEndtParMCItemNo(parId, itemNo, dfltCoverage, expiryDate);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("validateEndtMotorItemAddtlInfo".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					int itemNo = Integer.parseInt(request.getParameter("itemNo"));
					BigDecimal towing = request.getParameter("towing") == null ? null : new BigDecimal(request.getParameter("towing"));
					String cocType = request.getParameter("cocType");
					String plateNo = request.getParameter("plateNo");
					gipiParItemMCService.validateEndtMotorItemAddtlInfo(parId, itemNo, towing, cocType, plateNo);
					
					request.setAttribute("towing", towing);
					request.setAttribute("cocType", cocType);
					request.setAttribute("plateNo", plateNo);
					PAGE = "/pages/underwriting/subPages/ajaxUpdateFields.jsp";
				} else if ("populateOrigItmperil".equals(ACTION)) {
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					
					message = gipiParItemMCService.populateOrigItmperil(parId);
					PAGE = "/pages/genericMessage.jsp";
				} else if("preFormsCommit".equals(ACTION)){
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("parId", parId);
					params.put("lineCd", request.getParameter("lineCd"));
					params.put("parStatus", Integer.parseInt(request.getParameter("parStatus")));
					params.put("invoiceSw", request.getParameter("invoiceSw"));					
					
					message = generateResponse(gipiParItemMCService.preFormsCommit(params));
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
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
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIWPolbas wPolbas){
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		
		int parId = wPolbas.getParId();
		String lineCd = wPolbas.getLineCd();
		String sublineCd = wPolbas.getSublineCd();
		String assdNo = wPolbas.getAssdNo();		
		
		/* used null as parameters to get all records */
		String[] covs = {null, null};
		String[] groupParam = {assdNo};	
		//String[] carCompany = {null};
		//String[] basicColorParams = {null};
		String[] motorTypeParams = {sublineCd};
		//String[] cocType = {"NLTO", "LTO"};
		String[] cgRefCodes = {"GIPI_VEHICLE.MOTOR_COVERAGE"};
		String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};
		
		request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, covs));		
		request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));		
		request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));		
		request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));		
		request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));				
		request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_LISTING_BY_SUBLINE1, motorTypeParams));		
		request.setAttribute("basicColors", lovHelper.getList(LOVHelper.MC_BASIC_COLOR_LISTING));	
		request.setAttribute("colors", lovHelper.getList(LOVHelper.MC_ALL_COLOR));		
		request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_LISTING_BY_SUBLINE, motorTypeParams));	
		request.setAttribute("motorTypes", lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING , motorTypeParams));
		request.setAttribute("sublineTypes", lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING , motorTypeParams));
		request.setAttribute("motorCoverages", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, cgRefCodes));
		//request.setAttribute("cocType", cocType);
		request.setAttribute("perilListing", lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
	}
	
	private String composePolicyNo(GIPIWPolbas gipiWPolbas){
		StringBuilder policyNo = new StringBuilder();
		
		policyNo.append(gipiWPolbas.getLineCd());
		policyNo.append(" - ");
		policyNo.append(gipiWPolbas.getSublineCd());
		policyNo.append(" - ");
		policyNo.append(gipiWPolbas.getIssCd());
		policyNo.append(" - ");
		policyNo.append(String.format("%02d", gipiWPolbas.getIssueYy()));
		policyNo.append(" - ");
		policyNo.append(String.format("%06d", gipiWPolbas.getPolSeqNo()));
		policyNo.append(" - ");
		policyNo.append(gipiWPolbas.getRenewNo());
		
		return policyNo.toString();		
	}
	
	/**
	 * 
	 * @param request
	 * @param params
	 */
	@SuppressWarnings("unchecked")
	private void loadNewFormInstanceVariableToRequest(HttpServletRequest request, Map<String, Object> params){
		@SuppressWarnings("rawtypes")
		Iterator mapIterator = params.entrySet().iterator();
		
		while(mapIterator.hasNext()){
			Map.Entry<String, Object> entry = (Map.Entry<String, Object>) mapIterator.next();
			request.setAttribute(entry.getKey(), entry.getValue());
		}
	}
	
	private Map<String, Object> prepareGipiWVehicle(HttpServletRequest request){
		Map<String, Object> vehicleMap = new HashMap<String, Object>();		
		
		vehicleMap.put("parIds", request.getParameterValues("itemParIds"));
		vehicleMap.put("itemNos", request.getParameterValues("itemItemNos"));
		vehicleMap.put("sublineCds", request.getParameterValues("addlInfoSublineCds"));
		vehicleMap.put("motorNos", request.getParameterValues("addlInfoMotorNos"));
		vehicleMap.put("plateNos", request.getParameterValues("addlInfoPlateNos"));
		vehicleMap.put("estValues", request.getParameterValues("addlInfoEstValues"));
		vehicleMap.put("makes", request.getParameterValues("addlInfoMakes"));
		vehicleMap.put("motorTypes", request.getParameterValues("addlInfoMotorTypes"));
		vehicleMap.put("colors", request.getParameterValues("addlInfoColors"));
		vehicleMap.put("repairLims", request.getParameterValues("addlInfoRepairLimits"));
		vehicleMap.put("serialNos", request.getParameterValues("addlInfoSerialNos"));
		vehicleMap.put("cocSeqNos", request.getParameterValues("addlInfoCOCSeqNos"));
		vehicleMap.put("cocSerialNos", request.getParameterValues("addlInfoCOCSerialNos"));
		vehicleMap.put("cocTypes", request.getParameterValues("addlInfoCOCTypes"));
		vehicleMap.put("assignees", request.getParameterValues("addlInfoAssignees"));
		vehicleMap.put("modelYears", request.getParameterValues("addlInfoModelYears"));
		vehicleMap.put("cocIssueDates", request.getParameterValues("addlInfoCOCIssueDates"));
		vehicleMap.put("cocYYs", request.getParameterValues("addlInfoCOCYys"));				
		vehicleMap.put("towings", request.getParameterValues("addlInfoTowings"));
		vehicleMap.put("sublineTypeCds", request.getParameterValues("addlInfoSublineTypeCds"));
		vehicleMap.put("noOfPasss", request.getParameterValues("addlInfoNoOfPasss"));
		vehicleMap.put("tariffZones", request.getParameterValues("addlInfoTariffZones"));
		vehicleMap.put("mvFileNos", request.getParameterValues("addlInfoMVFileNos"));
		vehicleMap.put("acquiredFroms", request.getParameterValues("addlInfoAcquiredFroms"));
		vehicleMap.put("ctvTags", request.getParameterValues("addlInfoCTVs"));
		vehicleMap.put("carCompanyCds", request.getParameterValues("addlInfoCarCompanyCds"));
			
		vehicleMap.put("typeOfBodyCds", request.getParameterValues("addlInfoTypeOfBodyCds"));
		vehicleMap.put("unladenWts", request.getParameterValues("addlInfoUnladenWts"));
		vehicleMap.put("makeCds", request.getParameterValues("addlInfoMakeCds"));
		vehicleMap.put("seriesCds", request.getParameterValues("addlInfoEngineSeriess"));
		vehicleMap.put("basicColorCds", request.getParameterValues("addlInfoBasicColorCds"));
		vehicleMap.put("colorCds", request.getParameterValues("addlInfoColorCds"));
		vehicleMap.put("origins", request.getParameterValues("addlInfoOrigins"));
		vehicleMap.put("destinations", request.getParameterValues("addlInfoDestinations"));
		vehicleMap.put("cocAtcns", request.getParameterValues("addlInfoCOCAtcns"));
		vehicleMap.put("motorCoverages", request.getParameterValues("addlInfoMotorCoverages"));
		vehicleMap.put("cocSerialSws", request.getParameterValues("addlInfoCOCSerialSws"));
		vehicleMap.put("deductibleAmounts", request.getParameterValues("addlInfoDeductibleAmounts"));
		
		return vehicleMap;
	}
	
	private List<GIPIParItemMC> prepareGIPIWVehicles(HttpServletRequest request) {
		List<GIPIParItemMC> vehicleList = new ArrayList<GIPIParItemMC>();
		
		if(request.getParameterValues("addlInfoMotorNos") != null && request.getParameterValues("addlInfoMotorNos").length > 0){
			String[] parIds 			=  request.getParameterValues("itemParIds");
			String[] itemNos 			=  request.getParameterValues("addlInfoItemNos");
			String[] sublineCds 		=  request.getParameterValues("addlInfoSublineCds");
			String[] motorNos 			=  request.getParameterValues("addlInfoMotorNos");
			String[] plateNos 			=  request.getParameterValues("addlInfoPlateNos");
			String[] estValues 			=  request.getParameterValues("addlInfoEstValues");
			String[] makes 				=  request.getParameterValues("addlInfoMakes");
			String[] motorTypes 		=  request.getParameterValues("addlInfoMotorTypes");
			String[] colors 			=  request.getParameterValues("addlInfoColors");
			String[] repairLims 		=  request.getParameterValues("addlInfoRepairLimits");
			String[] serialNos 			=  request.getParameterValues("addlInfoSerialNos");
			String[] cocSeqNos 			=  request.getParameterValues("addlInfoCOCSeqNos");
			String[] cocSerialNos 		=  request.getParameterValues("addlInfoCOCSerialNos");
			String[] cocTypes 			=  request.getParameterValues("addlInfoCOCTypes");
			String[] assignees 			=  request.getParameterValues("addlInfoAssignees");
			String[] modelYears 		=  request.getParameterValues("addlInfoModelYears");
			String[] cocIssueDates 		=  request.getParameterValues("addlInfoCOCIssueDates");
			String[] cocYys 			=  request.getParameterValues("addlInfoCOCYys");				
			String[] towings 			=  request.getParameterValues("addlInfoTowings");
			String[] sublineTypeCds 	=  request.getParameterValues("addlInfoSublineTypeCds");
			String[] noOfPasss 			=  request.getParameterValues("addlInfoNoOfPasss");
			String[] tariffZones 		=  request.getParameterValues("addlInfoTariffZones");
			String[] mvFileNos 			=  request.getParameterValues("addlInfoMVFileNos");
			String[] acquiredFroms 		=  request.getParameterValues("addlInfoAcquiredFroms");
			String[] ctvTags 			=  request.getParameterValues("addlInfoCTVs");
			String[] carCompanyCds 		=  request.getParameterValues("addlInfoCarCompanyCds");
				
			String[] typeOfBodyCds 		=  request.getParameterValues("addlInfoTypeOfBodyCds");
			String[] unladenWts 		=  request.getParameterValues("addlInfoUnladenWts");
			String[] makeCds 			=  request.getParameterValues("addlInfoMakeCds");
			String[] seriesCds 			=  request.getParameterValues("addlInfoEngineSeriess");
			String[] basicColorCds 		=  request.getParameterValues("addlInfoBasicColorCds");
			String[] colorCds 			=  request.getParameterValues("addlInfoColorCds");
			String[] origins 			=  request.getParameterValues("addlInfoOrigins");
			String[] destinations 		=  request.getParameterValues("addlInfoDestinations");
			String[] cocAtcns 			=  request.getParameterValues("addlInfoCOCAtcns");
			String[] motorCoverages 	=  request.getParameterValues("addlInfoMotorCoverages");
			String[] cocSerialSws 		=  request.getParameterValues("addlInfoCOCSerialSws");
			String[] deductibleAmounts 	=  request.getParameterValues("addlInfoDeductibleAmounts");
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			
			for(int i=0, length = motorNos.length; i <length; i++){
				GIPIParItemMC vehicle = new GIPIParItemMC();
				try{					
					vehicle.setParId(parIds[i]);
					vehicle.setItemNo(itemNos[i]);
					vehicle.setSublineCd(sublineCds[i]);
					vehicle.setMotorNo(motorNos[i]);
					vehicle.setPlateNo(plateNos[i]);
					vehicle.setEstValue(new BigDecimal(estValues[i] != null && !(estValues[i].isEmpty()) ? estValues[i].replaceAll(",", "") : "0.00"));
					vehicle.setMake(makes[i]);
					vehicle.setMotType(motorTypes[i]);
					vehicle.setColor(colors[i]);
					vehicle.setRepairLim(new BigDecimal(repairLims[i] != null && !(repairLims[i].isEmpty()) ? repairLims[i].replaceAll(",", "") : "0.00"));
					vehicle.setSerialNo(serialNos[i]);
					vehicle.setCocSeqNo(cocSeqNos[i]);
					vehicle.setCocSerialNo(cocSerialNos[i]);
					vehicle.setCocType(cocTypes[i]);
					vehicle.setAssignee(assignees[i]);
					vehicle.setModelYear(modelYears[i]);
					vehicle.setCocIssueDate(cocIssueDates[i] != null && !(cocIssueDates[i].isEmpty()) ? sdf.parse(cocIssueDates[i]) : null);
					vehicle.setCocYY(cocYys[i]);
					vehicle.setTowing(new BigDecimal(towings[i] != null && !(towings[i].isEmpty()) ? towings[i].replaceAll(",", "") : "0.00"));
					vehicle.setSublineTypeCd(sublineTypeCds[i]);
					vehicle.setNoOfPass(noOfPasss[i]);
					vehicle.setTariffZone(tariffZones[i]);
					vehicle.setMvFileNo(mvFileNos[i]);
					vehicle.setAcquiredFrom(acquiredFroms[i]);
					vehicle.setCtvTag(ctvTags[i]);
					vehicle.setCarCompanyCd(carCompanyCds[i]);
					vehicle.setTypeOfBodyCd(typeOfBodyCds[i]);
					vehicle.setUnladenWt(unladenWts[i]);
					vehicle.setMakeCd(makeCds[i]);
					vehicle.setSeriesCd(seriesCds[i]);
					vehicle.setBasicColorCd(basicColorCds[i]);
					vehicle.setColorCd(colorCds[i]);
					vehicle.setOrigin(origins[i]);
					vehicle.setDestination(destinations[i]);
					vehicle.setCocAtcn(cocAtcns[i]);
					vehicle.setMotorCoverage(motorCoverages[i]);
					vehicle.setCocSerialSw(cocSerialSws[i]);
					vehicle.setDeductibleAmount(new BigDecimal(deductibleAmounts[i] != null && !(deductibleAmounts[i].isEmpty()) ? deductibleAmounts[i].replaceAll(",", "") : "0.00"));
					vehicleList.add(vehicle);
				}catch(ParseException e){
					e.printStackTrace();
					log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				}				
			}
			
		}
		
		return vehicleList;
	}
	
	/**
	 * 
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private String generateResponse (Map<String, Object> params) {
		StringBuilder response = new StringBuilder();		
		
		@SuppressWarnings("rawtypes")
		Iterator mapIterator = params.entrySet().iterator();
		
		while(mapIterator.hasNext()){
			Map.Entry<String, Object> entry = (Entry<String, Object>) mapIterator.next();
			
			if(response.length() < 1){
				response.append(entry.getKey() + "=" + (entry.getValue() != null ? entry.getValue() : ""));
			}else{
				response.append("&" + entry.getKey() + "=" + (entry.getValue() != null ? entry.getValue() : ""));
			}			
		}
		
		return response.toString();
	}
	
	private List<GIPIWMcAcc> prepareInsGipiWMcAccList(HttpServletRequest request, GIISUser USER){
		List<GIPIWMcAcc> accessoryList = new ArrayList<GIPIWMcAcc>();
			
		String[] itemNos = request.getParameterValues("accItemNos");
		String[] accCds = request.getParameterValues("accCds");
		String[] accAmts = request.getParameterValues("accAmts");
		
		GIPIWMcAcc acc = null;
		for(int i=0, length=itemNos.length; i <length; i++){
			acc = new GIPIWMcAcc();
			acc.setParId(Integer.parseInt(request.getParameter("globalParId")));
			acc.setItemNo(Integer.parseInt(itemNos[i]));
			acc.setAccessoryCd(accCds[i]);
			acc.setAccAmt(accAmts[i].replaceAll(",", "").equals("") || accAmts[i].replaceAll(",", "") == null ? null :new BigDecimal(accAmts[i].replaceAll(",", "")));
			acc.setUserId(USER.getUserId());
			accessoryList.add(acc);
			acc = null;
		}		
		return accessoryList;
	}
	
	private List<Map<String, Object>> prepareDelGipiWMcAccList(HttpServletRequest request){
		List<Map<String, Object>> accessoryList = new ArrayList<Map<String, Object>>();
		
		String[] itemNos = request.getParameterValues("delAccItemNos");
		String[] accCds = request.getParameterValues("delAccAccCds");
		
		for(int i=0, length=itemNos.length; i < length; i++){
			Map<String, Object> acc = new HashMap<String, Object>();
			acc.put("parId", Integer.parseInt(request.getParameter("globalParId")));
			acc.put("itemNo", Integer.parseInt(itemNos[i]));
			acc.put("accCd", Integer.parseInt(accCds[i]));
			accessoryList.add(acc);
			acc = null;
		}
		
		return accessoryList;
	}
}