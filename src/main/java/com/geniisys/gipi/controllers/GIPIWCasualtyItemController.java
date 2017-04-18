package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWCasualtyItem;
import com.geniisys.gipi.entity.GIPIWCasualtyPersonnel;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWCasualtyItemService;
import com.geniisys.gipi.service.GIPIWCasualtyPersonnelService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.geniisys.gipi.util.GIPIWDeductiblesUtil;
import com.geniisys.gipi.util.GIPIWItemPerilUtil;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIWCasualtyItemController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWCasualtyItemController.class);	

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/* default attributes */			
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			if("showCasualtyItemInfo".equals(ACTION)){
				GIPIWCasualtyItemService gipiWCasualtyItemService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWCasualtyItemService.newFormInstace(params)));
				message = "SUCCES";
				PAGE = "/pages/underwriting/par/casualty/casualtyItemInformationMain.jsp";
			} else if("getGIPIWItemTableGridCA".equals(ACTION)){
				GIPIWCasualtyItemService gipiWCasualtyItemService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				params.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 08.23.2016 SR 5606
				
				request.setAttribute("formMap", new JSONObject(gipiWCasualtyItemService.newFormInstanceTG(params)));
				message = "SUCCESS";
				PAGE = "/pages/underwriting/parTableGrid/casualty/casualtyItemInformationMain.jsp";
			} else if("showEndtCasualtyItemInfo".equals(ACTION)){
				GIPIWCasualtyItemService gipiWCasualtyItemService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWCasualtyItemService.gipis061NewFormInstance(params)));
				message = "SUCCESS";
				PAGE = "/pages/underwriting/endt/jsonCasualty/endtCasualtyItemInformationMain.jsp";		
			}else if("saveParCAItems".equals(ACTION)){
				GIPIWCasualtyItemService gipiWCasualtyService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");
				gipiWCasualtyService.saveGIPIWCasualtyItem(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveEndtCAItems".equals(ACTION)){
				GIPIWCasualtyItemService gipiWCasualtyService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");					
				gipiWCasualtyService.saveGIPIEndtCasualtyItem(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";					
			}else if("showCasualtyEndtItemInfo".equals(ACTION)){
				int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				GIPIPARList gipiPAR = null;
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				request.setAttribute("parDetails", gipiPAR);
				System.out.println("discExists: "+gipiPAR.getDiscExists());
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				int wItemCount = gipiWItemService.getWItemCount(parId);
				request.setAttribute("wItemParCount", wItemCount);
				
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				GIPIWCasualtyItemService gipiWCasualtyService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService"); 
				GIPIWGroupedItemsService gipiWGroupedItemsService = (GIPIWGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiWGroupedItemsService"); 
				GIPIWCasualtyPersonnelService gipiWCasualtyPersonnelService = (GIPIWCasualtyPersonnelService) APPLICATION_CONTEXT.getBean("gipiWCasualtyPersonnelService"); 
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				
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
				
				/* Perils*/
				String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
				request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
				
				request.setAttribute("locationListing", helper.getList(LOVHelper.CA_LOCATION_LISTING));
				String[] secHazardParam = {lineCd, sublineCd};					
				//request.setAttribute("sectionHazardListing", helper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING, secHazardParam)); // replaced by: Nica 05.16.2012
				request.setAttribute("sectionHazardListing", helper.getList(LOVHelper.CA_SECTION_OR_HAZARD_LIST, secHazardParam));
				request.setAttribute("capacityListing", helper.getList(LOVHelper.POSITION_LISTING));
				
				String[] groupParam = {assdNo};					
				request.setAttribute("groupListing", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
				
				request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
				request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
				request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiWItemService.getGIPIWItem(parId)));
				
				List<GIPIWCasualtyItem> casualtyItems = gipiWCasualtyService.getGipiWCasualtyItem(parId);
				List<GIPIWGroupedItems> groupedItems = gipiWGroupedItemsService.getGipiWGroupedItems(parId);
				List<GIPIWCasualtyPersonnel> casualtyPersonnel = gipiWCasualtyPersonnelService.getGipiWCasualtyPersonnel(parId);
				
				int itemSize = 0;
				itemSize = casualtyItems.size();
				StringBuilder arrayItemNo = new StringBuilder(itemSize);
				for(GIPIWCasualtyItem ca : casualtyItems){
					arrayItemNo.append(ca.getItemNo() + " ");
				}
				request.setAttribute("items", casualtyItems);
				request.setAttribute("itemNumbers", arrayItemNo);
				request.setAttribute("gipiWGroupedItems", groupedItems);
				request.setAttribute("gipiWCasualtyPersonnel", casualtyPersonnel);
				
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				request.setAttribute("ora2010Sw", ora2010Sw);
				request.setAttribute("wPolBasic", par);
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				String issCdRi = serv.getParamValueV2("ISS_CD_RI");
				request.setAttribute("issCdRi", issCdRi);
				request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
				GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
				String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
				request.setAttribute("pDeductibleExist", pDeductibleExist);
				
				PAGE = "/pages/underwriting/itemInformation.jsp";
				
				if("E".equals(request.getParameter("globalParType"))){
					GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
					
					Map<String, Object> params = new HashMap<String, Object>();
					List<GIPIWPolbas> gipiWPolbasList = new ArrayList<GIPIWPolbas>();
					
					gipiWPolbasList.add(par);
					
					request.setAttribute("casualtyItems", new JSONArray(casualtyItems));
					request.setAttribute("groupedItems", new JSONArray(groupedItems));
					request.setAttribute("casualtyPersonnels", new JSONArray(casualtyPersonnel));
					request.setAttribute("gipiPolbasics", new JSONArray(gipiPolbasicService.getEndtPolicyCA(parId)));
					request.setAttribute("gipiWPolbas", new JSONArray(gipiWPolbasList));
					
					params.put("parId", parId);
					loadNewFormInstanceVariablesToRequest(request, gipiWCasualtyService.gipis061NewFormInstance(params));
					
					PAGE = "/pages/underwriting/endt/casualty/endtCasualtyItemInformationMain.jsp";
				}
			} else if("saveGipiParCasualtyItem".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWCasualtyItemService gipiWCasualtyService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");
				int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				List<GIPIWCasualtyItem> casualtyitems = new ArrayList<GIPIWCasualtyItem>();
				List<GIPIWGroupedItems> groupedItems = new ArrayList<GIPIWGroupedItems>();
				List<GIPIWCasualtyPersonnel> personnelItems = new ArrayList<GIPIWCasualtyPersonnel>();
				Map<String, Object> globals = new HashMap<String, Object>();
				Map<String, Object> vars = new HashMap<String, Object>();
				Map<String, Object> pars = new HashMap<String, Object>();
				Map<String, Object> others = new HashMap<String, Object>();
				Map<String, Object> param = new HashMap<String, Object>();
				JSONObject params = new JSONObject(request.getParameter("parameters"));
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
				String lineCd = par.getLineCd();
				String sublineCd = par.getSublineCd();

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
				/****Added for JSON implementation******* BJGA 11.30.2010***/
				GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
				param.put("perilInsList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("setPerils"))));
				param.put("perilDelList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("delPerils"))));
				
				GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
				param.put("wcInsList", gipiWPolWCService.prepareGIPIWPolWCForInsert(new JSONArray(params.getString("setWCs"))));
				
				
				// peril deductibles
				String[] insPerilDedItemNos	= request.getParameterValues("insDedItemNo3");
				String[] delPerilDedItemNos = request.getParameterValues("delDedItemNo3");
				if(insPerilDedItemNos != null){
					param.put("perilDedInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 3));
				}
				if(delPerilDedItemNos != null){
					param.put("perilDedDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 3));
				}
				
				casualtyitems = prepareCasualtyItems(request);
				groupedItems = prepareGroupedItems(request, lineCd, sublineCd);
				personnelItems = preparePersonnelItems(request);
				
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
				
				
				String[] delGroupItemsItemNos		= request.getParameterValues("delGroupItemsItemNos");
				String[] delGroupedItemNos			= request.getParameterValues("delGroupedItemNos");
				String[] delPersonnelItemNos		= request.getParameterValues("delPersonnelItemNos");
				String[] delPersonnelNos			= request.getParameterValues("delPersonnelNos");
				
				param.put("itemList", GIPIWItemUtil.prepareGIPIWItems(request));
				param.put("delItemMap", GIPIWItemUtil.prepareGipiWItemForDelete(request));
				param.put("casualtyitems",casualtyitems);
				param.put("groupedItems",groupedItems);
				param.put("personnelItems",personnelItems);
				param.put("delGroupItemsItemNos",delGroupItemsItemNos);
				param.put("delGroupedItemNos",delGroupedItemNos);
				param.put("delPersonnelItemNos",delPersonnelItemNos);
				param.put("delPersonnelNos",delPersonnelNos);
				param.put("parId",parId);
				param.put("userId", USER.getUserId());
				param.put("globals", globals);
				param.put("vars", vars);
				param.put("pars", pars);
				param.put("others", others);
				param.put("gipiParList", GIPIPARUtil.prepareGIPIParList(request));
				
				if (gipiWCasualtyService.saveCasualtyItem(param)){
					message = "SUCCESS";
				}else{
					message = "FAILED";
				}
				
				//gipiWCasualtyService.saveGIPIParCasualtyItem(params);
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveEndtCAItems".equals(ACTION)){
				GIPIWCasualtyItemService gipiWCasualtyService = (GIPIWCasualtyItemService) APPLICATION_CONTEXT.getBean("gipiWCasualtyItemService");					
				gipiWCasualtyService.saveGIPIEndtCasualtyItem(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";					
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
	
	private List<GIPIWCasualtyPersonnel> preparePersonnelItems(
			HttpServletRequest request) {
		List<GIPIWCasualtyPersonnel> personnelItems = new ArrayList<GIPIWCasualtyPersonnel>();
		if (request.getParameterValues("pItemNos") != null && !(request.getParameterValues("pPersonnelNos").toString().isEmpty())){
			String[] pParIds				    = request.getParameterValues("pParIds");
			String[] pItemNos				    = request.getParameterValues("pItemNos");
			String[] pPersonnelNos				= request.getParameterValues("pPersonnelNos");
			String[] pPersonnelNames			= request.getParameterValues("pPersonnelNames");
			String[] pAmountCovereds			= request.getParameterValues("pAmountCovereds");
			String[] pCapacityCds				= request.getParameterValues("pCapacityCds");
			String[] pRemarkss				    = request.getParameterValues("pRemarkss");
			String[] pIncludeTags				= request.getParameterValues("pIncludeTags");
			
			for (int a = 0; a < pPersonnelNos.length; a++) {
				personnelItems.add(new GIPIWCasualtyPersonnel(pParIds[a],pItemNos[a],
						pPersonnelNos[a],pPersonnelNames[a],pIncludeTags[a],
						pCapacityCds[a],(pAmountCovereds[a] == null || pAmountCovereds[a] == "" ? null : new BigDecimal(pAmountCovereds[a].replaceAll(",", ""))),
						pRemarkss[a]
						));
			}
		}
		return personnelItems;
	}

	private List<GIPIWGroupedItems> prepareGroupedItems(
			HttpServletRequest request,String lineCd, String sublineCd) {
		List<GIPIWGroupedItems> groupedItems = new ArrayList<GIPIWGroupedItems>();
		if (request.getParameterValues("gItemNos") != null && !(request.getParameterValues("gGroupedItemNos").toString().isEmpty())){
			String[] gParIds				    = request.getParameterValues("gParIds");
			String[] gItemNos				    = request.getParameterValues("gItemNos");
			String[] gGroupedItemNos			= request.getParameterValues("gGroupedItemNos");
			String[] gGroupedItemTitles			= request.getParameterValues("gGroupedItemTitles");
			String[] gAmountCovereds			= request.getParameterValues("gAmountCovereds");
			String[] gGroupItemCds				= request.getParameterValues("gGroupItemCds");
			String[] gRemarkss				    = request.getParameterValues("gRemarkss");
			String[] gIncludeTags				= request.getParameterValues("gIncludeTags");
			
			for (int a = 0; a < gGroupedItemNos.length; a++) {
				groupedItems.add(new GIPIWGroupedItems(gParIds[a],gItemNos[a],
						gGroupedItemNos[a],gIncludeTags[a],gGroupedItemTitles[a],
						gGroupItemCds[a],(gAmountCovereds[a] == null || gAmountCovereds[a] == "" ? null : new BigDecimal(gAmountCovereds[a].replaceAll(",", ""))),
						gRemarkss[a],lineCd,sublineCd
						));
			}
		}
		return groupedItems;
	}

	private List<GIPIWCasualtyItem> prepareCasualtyItems(
			HttpServletRequest request) {
		List<GIPIWCasualtyItem> casualtyitems = new ArrayList<GIPIWCasualtyItem>();
		if(request.getParameterValues("itemItemNos") != null){
			String[] parIds				    = request.getParameterValues("itemParIds");
			String[] itemNos				= request.getParameterValues("itemItemNos");
			String[] locations				= request.getParameterValues("locations");
			String[] limitOfLiabilitys		= request.getParameterValues("limitOfLiabilitys");
			String[] sectionLineCds			= request.getParameterValues("sectionLineCds");
			String[] sectionSublineCds		= request.getParameterValues("sectionSublineCds");
			String[] interestOnPremisess	= request.getParameterValues("interestOnPremisess");
			String[] sectionOrHazardInfos	= request.getParameterValues("sectionOrHazardInfos");
			String[] conveyanceInfos		= request.getParameterValues("conveyanceInfos");
			String[] propertyNos			= request.getParameterValues("propertyNos");
			String[] locationCds			= request.getParameterValues("locationCds");
			String[] sectionOrHazardCds		= request.getParameterValues("sectionOrHazardCds");
			String[] capacityCds			= request.getParameterValues("capacityCds");
			String[] propertyNoTypes		= request.getParameterValues("propertyNoTypes");
			
			for (int a = 0; a < itemNos.length; a++) {
				casualtyitems.add(new GIPIWCasualtyItem(parIds[a],itemNos[a],
						sectionLineCds[a],sectionSublineCds[a],sectionOrHazardCds[a],
						propertyNoTypes[a],capacityCds[a],propertyNos[a],
						locations[a],conveyanceInfos[a],limitOfLiabilitys[a],
						interestOnPremisess[a],sectionOrHazardInfos[a],locationCds[a]
						));
			}
		}
		return casualtyitems;
	}

	@SuppressWarnings("unchecked")
	private void loadNewFormInstanceVariablesToRequest(HttpServletRequest request, Map<String, Object> newFormInstance){
		Set mapSet = newFormInstance.entrySet();
		Iterator mapIterator = mapSet.iterator();
		
		while(mapIterator.hasNext()){
			Map.Entry<String, Object> entry = (Map.Entry<String, Object>) mapIterator.next();
			
			if(!("parId".equals(entry.getKey()))){
				request.setAttribute(entry.getKey().toString(), entry.getValue());
			}
			//System.out.println(entry.getKey() + "=" + entry.getValue());
		}
	}
}
