package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
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
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParItemMCService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWVehicleService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWVehicleController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWVehicleController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			if("showMotorItemInfo".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");				
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);				
				
				request.setAttribute("formMap", new JSONObject(gipiWVehicleService.newFormInstance(params)));			
				message = "SUCCESS";				
				PAGE = "/pages/underwriting/par/motorcar/motorItemInformationMain.jsp";
			}else if("getGIPIWItemTableGridMC".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");				
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);				
				
				request.setAttribute("formMap", new JSONObject(gipiWVehicleService.newFormInstanceTG(params)));			
				message = "SUCCESS";				
				PAGE = "/pages/underwriting/parTableGrid/motorcar/motorItemInformationMain.jsp";
			} else if("showEndtMotorItemInfo".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);				
				
				/*Integer ctplDfltTsiAmt = giisParamService.getParamValueN("CTPL_PERIL_TSI");
				
				request.setAttribute("ctplDfltTsiAmt", ctplDfltTsiAmt);*/
				request.setAttribute("formMap", new JSONObject(gipiWVehicleService.gipis060NewFormInstance(params)));			
				message = "SUCCESS";				
				PAGE = "/pages/underwriting/endt/jsonMotorcar/endtMotorItemInformationMain.jsp";					
			}else if("showMotorEndtItemInfo".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
				GIPIWDeductibleFacadeService gipiWdeductibleService;
				int parId;
				
				parId = Integer.parseInt(request.getParameter("globalParId"));
							
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				
				String lineCd = par.getLineCd();
				String sublineCd = par.getSublineCd();
				String assdNo = par.getAssdNo();
				
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("sublineCd", sublineCd);
				
				//int parId = /*22216*/ /*36792*/ 61515 /*53382*/ /*32984*/ /*35881*/ /*28834*/ /*56179*/ /*35782*/ /*28830*/ /*26928*/ ;
				//int parId = 53382; // for delete deductibles
				//int parId = 61515; // for copy item
				
				GIPIPARList gipiPAR = null;
				if (parId != 0)	{
					GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
					gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
					gipiPAR.setParId(parId);
					request.setAttribute("parDetails", gipiPAR);
					System.out.println("discExists: "+gipiPAR.getDiscExists());
				}
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				int wItemCount = gipiWItemService.getWItemCount(parId);
				request.setAttribute("wItemParCount", wItemCount);
				//Map<String, Object> params = new HashMap<String, Object>();				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
				request.setAttribute("parId", parId);
				request.setAttribute("fromDate", df.format(par.getInceptDate()));
				request.setAttribute("toDate", df.format(par.getExpiryDate()));
				
				if(lineCd.equals("MC")){	
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env			
					request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
					
					String[] covs = {lineCd, sublineCd};				
					request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, covs));
					
					String[] groupParam = {assdNo};	
					request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));
					
					request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));				
					
					request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));
					//String[] carCompany = {params.get("carCompany") == null ? "" : params.get("carCompany").toString()};
					/* temporary commented */
					//String[] carCompany = {"125"};
					//if (!"".equals(carCompany[0])) {
					//	request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_LISTING /*, carCompany*/));
					//}
					
					request.setAttribute("basicColors", lovHelper.getList(LOVHelper.MC_BASIC_COLOR_LISTING));				
					/* temporary commented */
					//String[] basicColorParams = {params.get("basicColor") == null ? "" : params.get("basicColor").toString()};
					//request.setAttribute("colors", lovHelper.getList(LOVHelper.MC_COLOR_LISTING, basicColorParams));
					
					/*String[] paramsES = {params.get("make") == null ? "" : params.get("make").toString(), gipiQuote.getSublineCd()};*/
					/* temporary commented */
					//String[] paramsES = {"1", sublineCd};
					//request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_SERIES_LISTING , paramsES));
					
					/*String[] motorTypeParams = {params.get("sublineCd") == null ? "" : params.get("sublineCd").toString()};*/
					String[] motorTypeParams = {sublineCd};
					request.setAttribute("motorTypes", lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING , motorTypeParams));
					request.setAttribute("sublineTypes", lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING , motorTypeParams));
					
					String[] cocType = {"NLTO", "LTO"};
					request.setAttribute("cocType", cocType);
					
					/* Perils*/
					String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};
					request.setAttribute("perilListing",lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
				}
				
				//request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));
				PAGE = "/pages/underwriting/itemInformation.jsp";
				
				if(parId > 0){
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
					List<GIPIParItemMC> items = gipiParItemMCService.getGIPIParItemMCs(parId);
					String parType = request.getParameter("globalParType");
					System.out.println("par.getIssCd(): "+par.getIssCd());
					System.out.println("par.getIssueYy().toString(): "+par.getIssueYy().toString());
					System.out.println("par.getPolSeqNo().toString(): "+par.getPolSeqNo());
					System.out.println("par.getRenewNo(): "+par.getRenewNo());
					String policyNo =lineCd + " - " + sublineCd + " - " + par.getIssCd() + " - " + par.getIssueYy().toString() + " - " + 
						((par.getPolSeqNo() == null) ? "" : par.getPolSeqNo().toString()) + " - " + par.getRenewNo();
					int itemSize = 0;
					itemSize = items.size();
					System.out.println("PAR ID: " + parId);
					//request.setAttribute("parNo", gipiParItemMCService.getParNo(parId));										
					System.out.println("ASSDNO: " + assdNo);
					//request.setAttribute("assdName", gipiParItemMCService.getAssuredName(assdNo.toString()));
					
					request.setAttribute("parNo", request.getParameter("globalParNo"));
					request.setAttribute("assdName", request.getParameter("globalAssdName"));
					
					request.setAttribute("items", items);
					request.setAttribute("itemCount", itemSize);
					request.setAttribute("policyNo", policyNo);					
					
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
					System.out.println("Last Item No: " + lastItemNo);
					request.setAttribute("lastItemNo", lastItemNo);
					request.setAttribute("itemNumbers", arrayItemNo.toString());
					request.setAttribute("motorNumbers", arrayMotorNo.toString());
					request.setAttribute("serialNumbers", arraySerialNo.toString());
					request.setAttribute("plateNumbers", arrayMotorNo.toString());
					request.setAttribute("wPolBasic", par);
					GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					String issCdRi = serv.getParamValueV2("ISS_CD_RI");
					request.setAttribute("issCdRi", issCdRi);
					request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
					gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
					String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
					request.setAttribute("pDeductibleExist", pDeductibleExist);
					request.setAttribute("dedItemPeril", gipiWdeductibleService.getDeductibleItemAndPeril(parId, lineCd, sublineCd));
					
					if (parType != null) {
						if ("E".equals(parType)) {
							GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
							GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
							//gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
							
							Date expiryDate = gipiPolbasicService.extractExpiryDate(parId);
							
							String endtTaxSw = gipiParItemMCService.getEndtTax(parId);
							String discExists = gipiParItemMCService.checkIfDiscountExists(parId);
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
							//String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); -- taken outside of the condition for endt so that it can be used for ordinary PAR (BRY 07.26.2010)
							
							request.setAttribute("parType", "E");
							request.setAttribute("varPackParId", par.getPackParId());
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
							//request.setAttribute("pDeductibleExist", pDeductibleExist);
							
							//gipi_wpolbas
							//format the date and time of some attributes
							request.setAttribute("effDate", par.getEffDate() == null ? " " : df.format(par.getEffDate()));
							request.setAttribute("endtExpiryDate", par.getEndtExpiryDate() == null ? " " : df.format(par.getEndtExpiryDate()));
							request.setAttribute("expiryDate", par.getExpiryDate() == null ? " " : df.format(par.getExpiryDate()));
							request.setAttribute("wPolbas", par);
							
							log.info("Pack Par ID - " + par.getPackParId());
							log.info("Endt Tax SW - " + endtTaxSw);
							log.info("Param Dflt Coverage - " + dfltCoverage);
							log.info("vDisplay - " + vDisplayMotorCoverage);
							log.info("Generate COC Serial - " + vGenerateCOCSerial);
							log.info("Allow update cur rate - " + vAllowUpdateCurrRate);
							log.info("Loaded Expiry Date - " + expiryDate);
							log.info("Par Expiry Date - " + par.getExpiryTag());
							log.info("Par Endt Expiry Date - " + par.getEndtExpiryTag());
							PAGE = "/pages/underwriting/endtItemInformation.jsp";
						}
					}
				}
			} else if("saveGipiParVehicle".equals(ACTION)){								
				log.info("Saving MC Details");
				//request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));								
				
				if(request.getParameterValues("itemItemNos") != null && request.getParameterValues("motorNos") != null /*itemNos != null && !(motorNos.toString().isEmpty())*/){
					GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
					
					String[] parIds				= request.getParameterValues("itemParIds");
					String[] itemNos			= request.getParameterValues("itemItemNos");
					String[] sublineCds			= request.getParameterValues("sublineCds");
					String[] motorNos			= request.getParameterValues("motorNos");
					String[] plateNos			= request.getParameterValues("plateNos");
					String[] estValues			= request.getParameterValues("estValues");
					String[] makes				= request.getParameterValues("makes");
					String[] motorTypes			= request.getParameterValues("motorTypes");
					String[] colors				= request.getParameterValues("colors");
					String[] repairLims			= request.getParameterValues("repairLimits");
					String[] serialNos			= request.getParameterValues("serialNos");
					String[] cocSeqNos			= request.getParameterValues("cocSeqNos");
					String[] cocSerialNos		= request.getParameterValues("cocSerialNos");
					String[] cocTypes			= request.getParameterValues("cocTypes");
					String[] assignees			= request.getParameterValues("assignees");
					String[] modelYears			= request.getParameterValues("modelYears");
					String[] cocIssueDates		= request.getParameterValues("cocIssueDates");
					String[] cocYYs				= request.getParameterValues("cocYYs");				
					String[] towings			= request.getParameterValues("towings");
					String[] sublineTypeCds		= request.getParameterValues("sublineTypeCds");
					String[] noOfPasss			= request.getParameterValues("noOfPasss");	
					String[] tariffZones		= request.getParameterValues("tariffZones");
					String[] mvFileNos			= request.getParameterValues("mvFileNos");
					String[] acquiredFroms		= request.getParameterValues("acquiredFroms");
					String[] ctvTags			= request.getParameterValues("ctvs");
					String[] carCompanyCds		= request.getParameterValues("carCompanys");
						
					String[] typeOfBodyCds		= request.getParameterValues("typeOfBodys");
					String[] unladenWts			= request.getParameterValues("unladenWts");
					String[] makeCds			= request.getParameterValues("makeCds");
					String[] seriesCds			= request.getParameterValues("engineSeriess");
					String[] basicColorCds		= request.getParameterValues("basicColors");
					String[] colorCds			= request.getParameterValues("colorCds");
					String[] origins			= request.getParameterValues("origins");
					String[] destinations		= request.getParameterValues("destinations");
					String[] cocAtcns			= request.getParameterValues("cocAtcns");
					String[] motorCoverages		= request.getParameterValues("motorCoverages");
					String[] cocSerialSws		= request.getParameterValues("cocSerialSws");
					String[] deductibleAmounts	= request.getParameterValues("deductibleAmounts");
					
					Map<String, Object> vehicleParams = new HashMap<String, Object>();
					vehicleParams.put("parIds", parIds);
					vehicleParams.put("itemNos", itemNos);
					vehicleParams.put("sublineCds", sublineCds);
					vehicleParams.put("motorNos", motorNos);
					vehicleParams.put("plateNos", plateNos);
					vehicleParams.put("estValues", estValues);
					vehicleParams.put("makes", makes);
					vehicleParams.put("motorTypes", motorTypes);
					vehicleParams.put("colors", colors);
					vehicleParams.put("repairLims", repairLims);
					vehicleParams.put("serialNos", serialNos);
					vehicleParams.put("cocSeqNos", cocSeqNos);
					vehicleParams.put("cocSerialNos", cocSerialNos);
					vehicleParams.put("cocTypes", cocTypes);
					vehicleParams.put("assignees", assignees);
					vehicleParams.put("modelYears", modelYears);
					vehicleParams.put("cocIssueDates", cocIssueDates);
					vehicleParams.put("cocYYs", cocYYs);				
					vehicleParams.put("towings", towings);
					vehicleParams.put("sublineTypeCds", sublineTypeCds);
					vehicleParams.put("noOfPasss", noOfPasss);
					vehicleParams.put("tariffZones", tariffZones);
					vehicleParams.put("mvFileNos", mvFileNos);
					vehicleParams.put("acquiredFroms", acquiredFroms);
					vehicleParams.put("ctvTags", ctvTags);
					vehicleParams.put("carCompanyCds", carCompanyCds);
						
					vehicleParams.put("typeOfBodyCds", typeOfBodyCds);
					vehicleParams.put("unladenWts", unladenWts);
					vehicleParams.put("makeCds", makeCds);
					vehicleParams.put("seriesCds", seriesCds);
					vehicleParams.put("basicColorCds", basicColorCds);
					vehicleParams.put("colorCds", colorCds);
					vehicleParams.put("origins", origins);
					vehicleParams.put("destinations", destinations);
					vehicleParams.put("cocAtcns", cocAtcns);
					vehicleParams.put("motorCoverages", motorCoverages);
					vehicleParams.put("cocSerialSws", cocSerialSws);
					vehicleParams.put("deductibleAmounts", deductibleAmounts);
					
					gipiParItemMCService.saveGIPIParVehicle(vehicleParams);
					request.setAttribute("message", "Item saved.");					
				}
				message = "SUCCESS";
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
				String[] make = {request.getParameter("make"), request.getParameter("globalSublineCd"), request.getParameter("carCompanyCd")};
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
				
				message = gipiParItemMCService.checkCOCSerialNoInPar(Integer.parseInt(request.getParameter("globalParId")), itemNo, cocSerialNo, cocType);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("COC Serial in PAR: " + message);
			} else if("validateOtherInfo".equals(ACTION)){
				log.info("Validating Other Info ...");
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
				message = gipiParItemMCService.validateOtherInfo(Integer.parseInt(request.getParameter("globalParId")));
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Validate Other Info: " + message);			
			} else if ("showUploadFleetPage".equals(ACTION)) {
				request.setAttribute("parId", request.getParameter("globalParId"));
				PAGE = "/pages/underwriting/overlay/uploadFleetPolicy.jsp";
				//PAGE = "/pages/underwriting/par/motorcar/subPages/uploadFleet.jsp";
			} else if("uploadFile".equalsIgnoreCase(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("APPLICATION_CONTEXT", APPLICATION_CONTEXT);
				params.put("servletContext", getServletContext());
				params.put("request", request);
				params.put("response", response);
				
				gipiWVehicleService.uploadFleetData(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateMotorTypeList".equals(ACTION)) {
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> motorTypeList;
				int listSize = 0;
				
				String sublineCd = null;
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
				
				String sublineCd = null;
				sublineCd = request.getParameter("packSublineCd");
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
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
				String negateItem = request.getParameter("negateItem") == null ? "" : request.getParameter("negateItem"); 
				String prorateFlag = request.getParameter("prorateFlag") == null ? "" : request.getParameter("prorateFlag");
				String compSw = request.getParameter("compSw") == null ? "" : request.getParameter("compSw");
				String endtExpiryDate = request.getParameter("endtExpiryDate") == null ? "" : request.getParameter("endtExpiryDate");
				String effDate = request.getParameter("effDate") == null ? "" : request.getParameter("effDate");
				String expiryDate = request.getParameter("expiryDate") == null ? "" : request.getParameter("expiryDate");
				BigDecimal shortRtPercent = request.getParameter("shortRtPercent") == null ? null : request.getParameter("shortRtPercent").trim().length() == 0 ? null : new BigDecimal(request.getParameter("shortRtPercent"));
					
				message = gipiWPolbasService.updateGipiWpolbasEndt(Integer.parseInt(request.getParameter("globalParId")), request.getParameter("lineCd"), negateItem, prorateFlag, compSw, endtExpiryDate, effDate, shortRtPercent, expiryDate);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showAddDeleteItemDiv".equals(ACTION)) {
				GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
				message = gipiWdeductibleService.isExistGipiWdeductible(Integer.parseInt(request.getParameter("globalParId")), request.getParameter("globalLineCd"), request.getParameter("globalSublineCd"));
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
				
				gipiParItemMCService.deleteEndtItem(Integer.parseInt(request.getParameter("globalParId")), itemNo, currentItemNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("addEndtItem".equals(ACTION)) {
				message = "SUCCESS";
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				String[] strItemNos = request.getParameter("itemNos").split(" ");
				int[] itemNo = new int[strItemNos.length];
				
				for (int i = 0; i < strItemNos.length; i++) {
					itemNo[i] = Integer.parseInt(strItemNos[i]);
				}
				
				gipiParItemMCService.addEndtItem(Integer.parseInt(request.getParameter("globalParId")), itemNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkAdditionalInfo".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				message = gipiParItemMCService.checkAddtlInfo(Integer.parseInt(request.getParameter("globalParId")));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getDistNo".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				message = Integer.toString(gipiParItemMCService.getDistNo(Integer.parseInt(request.getParameter("globalParId"))));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteDistribution".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				int distNo = request.getParameter("distNo") == null ? 0 : Integer.parseInt(request.getParameter("distNo"));
				message = gipiParItemMCService.deleteDistribution(Integer.parseInt(request.getParameter("globalParId")), distNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteWinvRecords".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				gipiParItemMCService.deleteWinvRecords(Integer.parseInt(request.getParameter("globalParId")));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateEndtParMCItemNo".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String dfltCoverage = request.getParameter("dfltCoverage");
				String expiryDate = request.getParameter("expiryDate");
				message = gipiParItemMCService.validateEndtParMCItemNo(Integer.parseInt(request.getParameter("globalParId")), itemNo, dfltCoverage, expiryDate);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateEndtMotorItemAddtlInfo".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				BigDecimal towing = request.getParameter("towing") == null ? null : new BigDecimal(request.getParameter("towing"));
				String cocType = request.getParameter("cocType");
				String plateNo = request.getParameter("plateNo");
				gipiParItemMCService.validateEndtMotorItemAddtlInfo(Integer.parseInt(request.getParameter("globalParId")), itemNo, towing, cocType, plateNo);
				
				request.setAttribute("towing", towing);
				request.setAttribute("cocType", cocType);
				request.setAttribute("plateNo", plateNo);
				PAGE = "/pages/underwriting/subPages/ajaxUpdateFields.jsp";
			} else if ("populateOrigItmperil".equals(ACTION)) {
				GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService");
				
				message = gipiParItemMCService.populateOrigItmperil(Integer.parseInt(request.getParameter("globalParId")));
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCarCompany".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));
				PAGE = "/pages/underwriting/overlay/carCompany.jsp";
			}else if("showMake".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] makeParams = {request.getParameter("sublineCd"), request.getParameter("carCompanyCd")};
				request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_BY_SUBLINE_CAR_COMPANY_CD, makeParams));
				PAGE = "/pages/underwriting/overlay/makes.jsp";
			}else if("showEngineSeries".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] engineParams = {request.getParameter("sublineCd"), request.getParameter("carCompanyCd"), request.getParameter("makeCd")};
				request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_SERIES_BY_SUBLINE_CAR_MAKE_CD, engineParams));				
				PAGE = "/pages/underwriting/overlay/engineSeries.jsp";
			}else if("saveParMCItems".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				gipiWVehicleService.saveGIPIWVehicle(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showUploadFleetPage".equals(ACTION)) {
				request.setAttribute("parId", request.getParameter("globalParId"));
				PAGE = "/pages/underwriting/overlay/uploadFleetPolicy.jsp";
			}else if("checkCOCSerialNoInPolicyAndPar".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				message = gipiWVehicleService.checkCOCSerialNoInPolicyAndPar(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateOtherInfo2".equals(ACTION)){				
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				message = gipiWVehicleService.validateOtherInfo(request.getParameter("parameters"));				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("gipis060ValidateItem".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));				
				params.put("backEndt", request.getParameter("backEndt"));
				gipiWVehicleService.gipis060ValidateItem(params);
				StringFormatter.replaceQuotesInListOfMap(params.get("endtItem"));
				System.out.println("WHEN VALIDATE ITEM PARAMS : " + params);
				StringFormatter.replaceQuotesInMap(params);
				message = new JSONObject(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePlateNo".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("plateNo", request.getParameter("plateNo"));				
				message = (new JSONObject(gipiWVehicleService.validatePlateNo(params))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateCocSerialNo".equals(ACTION)){
				GIPIWVehicleService gipiWVehicleService = (GIPIWVehicleService) APPLICATION_CONTEXT.getBean("gipiWVehicleService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("cocType", request.getParameter("cocType"));
				params.put("cocSerialNo", Integer.parseInt(request.getParameter("cocSerialNo")));				
				
				message = gipiWVehicleService.validateCocSerialNo(params);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
