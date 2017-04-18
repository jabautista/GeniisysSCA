package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIWEngineeringItem;
import com.geniisys.gipi.entity.GIPIWLocation;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWEngineeringItemService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWEngineeringItemController extends BaseController{

	private static final long serialVersionUID = -3036853977876008254L;
	private static Logger log = Logger.getLogger(GIPIWEngineeringItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			
			//int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
			int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
			DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			
			if(parId == 0) {
				message = "PAR No. is empty";
				PAGE = "/pages/genericMessage.jsp";
			} else {

				GIPIWEngineeringItemService gipiWENService = (GIPIWEngineeringItemService) appContext.getBean("gipiWEngineeringItemService");
				
				LOVHelper helper = (LOVHelper)appContext.getBean("lovHelper");
				
				if("showENItemInfo".equals(ACTION)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", appContext);
					params.put("USER", USER);
					
					String parType = request.getParameter("globalParType") == null ? "P" : request.getParameter("globalParType");
					
					request.setAttribute("formMap", new JSONObject(gipiWENService.newENInstance(params)));
					
					if(parType.equals("P")) {
						PAGE = "/pages/underwriting/par/engineering/enItemInformationMain.jsp";
					}
				} else if("getGIPIWItemTableGridEN".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", appContext);
					params.put("USER", USER);					
					
					request.setAttribute("formMap", new JSONObject(gipiWENService.newENInstanceTG(params)));					
					
					PAGE = "/pages/underwriting/parTableGrid/engineering/engineeringItemInformationMain.jsp";				
				} else if("showEndtEngineeringItemInfo".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", appContext);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWENService.gipis067NewFormInstance(params)));
					
					PAGE = "/pages/underwriting/endt/jsonEngineering/endtENItemInformationMain.jsp";
				}else if("showENEndtItemInfo".equals(ACTION)) {
					GIPIWPolbasService gipiwPolbasService = (GIPIWPolbasService) appContext.getBean("gipiWPolbasService");
					GIPIWPolbas par = gipiwPolbasService.getGipiWPolbas(parId);
					
					GIPIPARList gipiPar = null;
					GIPIPARListService gipiParService = (GIPIPARListService) appContext.getBean("gipiPARListService");
					gipiPar = gipiParService.getGIPIPARDetails(parId);
					gipiPar.setParId(parId);
					request.setAttribute("parDetails", gipiPar);
					GIPIWItemService gipiwItemService = (GIPIWItemService) appContext.getBean("gipiWItemService");
					
					int wItemCount = gipiwItemService.getWItemCount(parId);
					request.setAttribute("wItemParCount", wItemCount);
					
					GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) appContext.getBean("gipiPolbasicService");
					
					String lineCd = request.getParameter("lineCd");
					String sublineCd = par.getSublineCd();
					String assdNo = par.getAssdNo();
					
					request.setAttribute("fromDate", sdf.format(par.getInceptDate()));
					request.setAttribute("toDate", sdf.format(par.getExpiryDate()));
					
					request.setAttribute("parId", parId);
					request.setAttribute("lineCd", lineCd);
					request.setAttribute("sublineCd", sublineCd);
					request.setAttribute("parNo", request.getParameter("globalParNo"));
					request.setAttribute("assdName", request.getParameter("globalAssdName"));
					request.setAttribute("parType", request.getParameter("globalParType"));
					request.setAttribute("policyNo", request.getParameter("globalEndtPolicyNo"));
					
					String[] lineSubLineParams = {par.getLineCd(), par.getSublineCd()};
					request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));	
					request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
					
					String[] groupParam = {assdNo};	
					request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
					
					String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
					request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
					request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiwItemService.getGIPIWItem(parId)));
					
					List<GIPIWEngineeringItem> enItems = gipiWENService.getGipiWENItems(parId);
					System.out.println("EN SIZE: " + enItems.size());
					
					List<GIPIPolbasic> gipiPolbasics = gipiPolbasicService.getEndtPolicy(parId);
					request.setAttribute("gipiPolbasics2", new JSONArray(gipiPolbasics));
					
					int itemSize = enItems.size();
					StringBuilder arrayItemNo = new StringBuilder(itemSize);
					for(GIPIWEngineeringItem en: enItems) {
						Debug.print("EN OBJECT: " + en.getItemNo());
						arrayItemNo.append(en.getItemNo() + "");
					}
					StringFormatter.replaceQuotesInList(enItems);
					request.setAttribute("itemsJSON", new JSONArray(enItems));
					request.setAttribute("itemNumbers", arrayItemNo);
					
					request.setAttribute("wPolBasic", par);
					GIISParameterFacadeService serv = (GIISParameterFacadeService) appContext.getBean("giisParameterFacadeService");
					String issCdRi = serv.getParamValueV2("ISS_CD_RI");
					request.setAttribute("issCdRi", issCdRi);
					request.setAttribute("paramName", serv.getParamByIssCd(gipiPar.getIssCd()));					
					
					GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) appContext.getBean("gipiWDeductibleFacadeService");
					String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
					request.setAttribute("pDeductibleExist", pDeductibleExist);
					
					List<GIPIWPolbas> gipiWPolbasList = new ArrayList<GIPIWPolbas>();						
					gipiWPolbasList.add(par);
					request.setAttribute("gipiWPolbas", new JSONArray(gipiWPolbasList));
					
					List<LOV> defaultCurrency = helper.getList(LOVHelper.DEFAULT_CURRENCY);
					request.setAttribute("defaultCurrency", defaultCurrency.get(0).getCode());
					
					PAGE = "/pages/underwriting/endt/engineering/endtEngineeringItemInformationMain.jsp";
				} else if("saveParItemEN".equals(ACTION)) {
					gipiWENService.saveEngineeringItem(request.getParameter("parameters"), USER);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";			
				} else if ("showLocationSelect".equals(ACTION))	{
					int locType = Integer.parseInt(request.getParameter("locType") == null ? "0" : request.getParameter("locType"));

					List<LOV> regionList = helper.getList(LOVHelper.REGION_LISTING);
					StringFormatter.replaceQuotesInList(regionList);
					request.setAttribute("regions", new JSONArray(regionList));
					
					List<LOV> provinceList = helper.getList(LOVHelper.PROVINCE_LISTING);
					StringFormatter.replaceQuotesInList(provinceList);
					request.setAttribute("provinces", new JSONArray(provinceList));

					request.setAttribute("locType", locType);
					PAGE = "/pages/underwriting/pop-ups/enItemLocation.jsp";
					
				} else if("saveEndtParEN".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					Debug.print("Parameters: " + request.getParameter("parameter"));
					gipiWENService.saveEndtEngineeringItem(request.getParameter("parameter"), params);
				
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";		
				} 
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
	
	List<GIPIWLocation> prepareLocations(HttpServletRequest request, int parId) {
		List<GIPIWLocation> loc = new ArrayList<GIPIWLocation>();
		if(request.getParameterValues("locItemNo") != null) {
			String[] locItemNos = request.getParameterValues("locItemNo");
			String[] locRegions = request.getParameterValues("locRegion");
			String[] locProvinces = request.getParameterValues("locProvince");
			
			for(int i=0; i<locItemNos.length; i++) {
				loc.add(new GIPIWLocation(parId, Integer.parseInt(locItemNos[i]), locRegions[i], locProvinces[i]));
			}
		}
		return loc;
	}
}
