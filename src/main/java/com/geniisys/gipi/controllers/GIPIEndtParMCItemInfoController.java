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
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
//import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.entity.GIPIParItemMC;
import com.geniisys.gipi.entity.GIPIWPolbas;
//import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIEndtParItemMCService;
import com.geniisys.gipi.service.GIPIParItemMCService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWPolbasService;
//import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIParMCItemInformationController.
 */
public class GIPIEndtParMCItemInfoController extends BaseController {
	
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
			
			GIPIEndtParItemMCService gipiEndtParItemMCService;
			GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
			GIPIWDeductibleFacadeService gipiWdeductibleService;			
			
			int parId;
			message = "SUCCESS";
			
			parId = Integer.parseInt(request.getParameter("globalParId") == null ? "0" : request.getParameter("globalParId"));			
			
			GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
			
			String lineCd = par.getLineCd();
			String sublineCd = par.getSublineCd();
			String assdNo = par.getAssdNo();
			
			request.setAttribute("lineCd", lineCd);
			request.setAttribute("sublineCd", sublineCd);
			
			if("showMotorEndtItemInfo".equals(ACTION)){
				//Map<String, Object> params = new HashMap<String, Object>();				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
				request.setAttribute("parId", parId);
				request.setAttribute("fromDate", df.format(par.getEffDate()));
				request.setAttribute("toDate", df.format(par.getEndtExpiryDate()));
				
				if(lineCd.equals("MC")){
					//LOV's
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env			
					request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
					
					String[] covs = {lineCd, sublineCd};				
					request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, covs));
					
					String[] groupParam = {assdNo};	
					request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));					
					request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));					
					request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));
					request.setAttribute("basicColors", lovHelper.getList(LOVHelper.MC_BASIC_COLOR_LISTING));
					
					String[] motorTypeParams = {sublineCd};
					request.setAttribute("motorTypes", lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING , motorTypeParams));
					request.setAttribute("sublineTypes", lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING , motorTypeParams));
					
					String[] cocType = {"NLTO", "LTO"};
					request.setAttribute("cocType", cocType);
					
					/* Perils*/
					String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
					request.setAttribute("perilListing", lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
				}
				
				if(parId > 0){
					gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService"); // +env
					GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
					
					//when-new-form-instance validation
					String endtTaxSw = gipiEndtParItemMCService.getEndtTax(parId);
					String discExists = gipiEndtParItemMCService.checkIfDiscountExists(parId);
					Integer dfltCoverage = giisParamService.getParamValueN("DEFAULT_COVERAGE_CD");
					String vDisplayMotorCoverage = giisParamService.getParamValueV2("DISPLAY_MOTOR_COVERAGE");
					String vGenerateCOCSerial = giisParamService.getParamValueV2("GENERATE_COC_SERIAL");
					String vPhilPeso = giisParamService.getParamValueV2("PHP");
					String vAllowUpdateCurrRate = giisParamService.getParamValueV2("ALLOW_UPDATE_CURR_RATE");
					String vMotorCar = giisParamService.getParamValueV2("MOTOR CAR");
					String vMotorCycle = giisParamService.getParamValueV2("MOTOR CYCLE");
					String vCommercialVehicle = giisParamService.getParamValueV2("COMMERCIAL VEHICLE");
					String vPrivateCar = giisParamService.getParamValueV2("PRIVATE CAR");
					String vLto = giisParamService.getParamValueV2("LAND TRANS. OFFICE");
					String vCocLto = giisParamService.getParamValueV2("COC_TYPE_LTO");
					String vCocNlto = giisParamService.getParamValueV2("COC_TYPE_NLTO");
					
					if ("SUCCESS".equals(message)) {
						List<GIPIParItemMC> items = gipiEndtParItemMCService.getGIPIEndtParItemMCs(parId);
						String policyNo = lineCd + " - " + sublineCd + " - " + par.getIssCd() + " - " + par.getIssueYy().toString() + " - " + 
							((par.getPolSeqNo() == null) ? "" : par.getPolSeqNo().toString()) + " - " + par.getRenewNo();
						
						int itemSize = 0;
						Date expiryDate = gipiPolbasicService.extractExpiryDate(parId);
						
						itemSize = items.size();
						
						request.setAttribute("parNo", request.getParameter("globalParNo"));
						request.setAttribute("assdName", request.getParameter("globalAssdName"));
						
						request.setAttribute("items", items);
						request.setAttribute("itemCount", itemSize);
						request.setAttribute("policyNo", policyNo);
						request.setAttribute("parType", "E");
						request.setAttribute("varPackParId", par.getPackParId());
						
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
						
						//other variables
						request.setAttribute("endtTaxSw", endtTaxSw);
						request.setAttribute("discExists", discExists);
						request.setAttribute("vPhilPeso", vPhilPeso);
						request.setAttribute("paramDfltCoverage", dfltCoverage);
						request.setAttribute("vDisplayMotor", vDisplayMotorCoverage);
						request.setAttribute("vGenerateCOCSerial", vGenerateCOCSerial);
						request.setAttribute("vAllowUpdateCurrRate", vAllowUpdateCurrRate);
						request.setAttribute("vMotorCar", vMotorCar);
						request.setAttribute("vMotorCycle", vMotorCycle);
						request.setAttribute("vCommercialVehicle", vCommercialVehicle);
						request.setAttribute("vPrivateCar", vPrivateCar);
						request.setAttribute("vLto", vLto);
						request.setAttribute("vCocLto", vCocLto);
						request.setAttribute("vCocNlto", vCocNlto);
						request.setAttribute("expiryDate", expiryDate == null ? null : df.format(expiryDate));
						
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
					} else {
						PAGE = "/pages/genericMessage.jsp";
					}					
				}
				
				//request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));
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
			} else if("filterEngineSeries".equals(ACTION)){
				log.info("Filtering Engine Series ...");
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env			
				String[] make = {request.getParameter("make"), sublineCd, request.getParameter("carCompanyCd")};
				request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_SERIES_LISTING, make));
				PAGE = "/pages/marketing/quotation/dynamicDropdown/engineSeries.jsp";				
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
			} else if ("updateGipiWpolbasGipis060".equals(ACTION)) {
				//DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				String negateItem = request.getParameter("negateItem") == null ? "" : request.getParameter("negateItem"); 
				String prorateFlag = request.getParameter("prorateFlag") == null ? "" : request.getParameter("prorateFlag");
				String compSw = request.getParameter("compSw") == null ? "" : request.getParameter("compSw");
				String endtExpiryDate = request.getParameter("endtExpiryDate") == null ? "" : request.getParameter("endtExpiryDate");
				String effDate = request.getParameter("effDate") == null ? "" : request.getParameter("effDate");
				String expiryDate = request.getParameter("expiryDate") == null ? "" : request.getParameter("expiryDate");
				BigDecimal shortRtPercent = request.getParameter("shortRtPercent") == null ? null : request.getParameter("shortRtPercent").trim().length() == 0 ? null : new BigDecimal(request.getParameter("shortRtPercent"));
								
				message = gipiWPolbasService.updateGipiWpolbasEndt(parId, lineCd, negateItem, prorateFlag, compSw, endtExpiryDate, effDate, shortRtPercent, expiryDate);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showAddDeleteItemDiv".equals(ACTION)) {
				gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
				GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId); 
				message = gipiWdeductibleService.isExistGipiWdeductible(parId, gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd());
				log.info("response: "+message);
				request.setAttribute("message", message);
				PAGE = "/pages/underwriting/subPages/endtItemInfoAddDeleteItem.jsp";
			} else if ("deleteEndtItem".equals(ACTION)) {
				message = "SUCCESS";
				gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService");
				String[] strItemNos = request.getParameter("itemNos").split(" ");
				int currentItemNo = request.getParameter("itemNo") == "" ? 0 : Integer.parseInt(request.getParameter("itemNo")); 
				int[] itemNo = new int[strItemNos.length];
				
				for (int i = 0; i < strItemNos.length; i++) {
					itemNo[i] = Integer.parseInt(strItemNos[i]);
				}
				
				gipiEndtParItemMCService.deleteItem(parId, itemNo, currentItemNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("addEndtItem".equals(ACTION)) {
				message = "SUCCESS";
				gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService");
				String[] strItemNos = request.getParameter("itemNos").split(" ");
				int[] itemNo = new int[strItemNos.length];
				
				for (int i = 0; i < strItemNos.length; i++) {
					itemNo[i] = Integer.parseInt(strItemNos[i]);
				}
				
				gipiEndtParItemMCService.addItem(parId, itemNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkAdditionalInfo".equals(ACTION)) {
				gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService");
				message = gipiEndtParItemMCService.checkAddtlInfo(parId);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getDistNo".equals(ACTION)) {
				gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService");
				message = Integer.toString(gipiEndtParItemMCService.getDistNo(parId));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteDistribution".equals(ACTION)) {
				gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService");
				int distNo = request.getParameter("distNo") == null ? 0 : Integer.parseInt(request.getParameter("distNo"));
				message = gipiEndtParItemMCService.deleteDistribution(parId, distNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteWinvRecords".equals(ACTION)) {
				gipiEndtParItemMCService = (GIPIEndtParItemMCService) APPLICATION_CONTEXT.getBean("gipiEndtParItemMCService");
				gipiEndtParItemMCService.deleteWinvRecords(parId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
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
	
}
