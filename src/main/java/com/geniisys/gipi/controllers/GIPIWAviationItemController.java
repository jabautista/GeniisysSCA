package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWAviationItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWAviationItemService;
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

public class GIPIWAviationItemController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWCargoController.class);
	
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
			DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			
			System.out.println("parId:"+parId);
			System.out.println("action:"+ACTION);
			
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
				request.setAttribute("itemCount", wItemCount);
				if("showAviationItemInfo".equals(ACTION)){
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService");
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWAviationItemService.newFormInstance(params)));
					message = "SUCCES";
					PAGE = "/pages/underwriting/par/aviation/aviationItemInformationMain.jsp";
				} else if("getGIPIWItemTableGridAV".equals(ACTION)){
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService");
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWAviationItemService.newFormInstanceTG(params)));
					message = "SUCCES";
					PAGE = "/pages/underwriting/parTableGrid/aviation/aviationItemInformationMain.jsp";
				} else if("showEndtAviationItemInfo".equals(ACTION)){
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService");
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWAviationItemService.gipis082NewFormInstance(params)));
					message = "SUCCESS";
					PAGE = "/pages/underwriting/endt/jsonAviation/endtAviationItemInformationMain.jsp";					
				}else if("showAviationItemInfoOLD".equals(ACTION)){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService"); // +env
					GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
					
					//String lineCd = par.getLineCd();
					String lineCd = request.getParameter("lineCd"); // andrew - 10.05.2010 - get the line code from request
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
					
					/* Perils*/
					String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
					request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
					request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiWItemService.getGIPIWItem(parId)));
					
					/*Map pars1 = new HashMap();
					pars1 = gipiWAviationItemService.isExist(parId);
					String isExistWAv = (String) pars1.get("exist");
					
					if (isExistWAv.equals("0")){
						request.setAttribute("vesselListing", helper.getList(LOVHelper.VESSEL_LISTING4));
					} else {
						String[] parIdParams = {Integer.toString(parId)}; 
						request.setAttribute("vesselListing", helper.getList(LOVHelper.VESSEL_LISTING3, parIdParams));
					}*/
					request.setAttribute("vesselListing", helper.getList(LOVHelper.VESSEL_LISTING4));
					
					List<GIPIWAviationItem> gipiWAviationItems = gipiWAviationItemService.getGipiWAviationItem(parId);
					
					int itemSize = 0;
					itemSize = gipiWAviationItems.size();
					StringBuilder arrayItemNo = new StringBuilder(itemSize);
					for (GIPIWAviationItem av: gipiWAviationItems){
						arrayItemNo.append(av.getItemNo() + " ");
					}
					
					request.setAttribute("items", gipiWAviationItems);
					request.setAttribute("itemNumbers", arrayItemNo);
					request.setAttribute("wPolBasic", par);
					GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					String issCdRi = serv.getParamValueV2("ISS_CD_RI");
					request.setAttribute("issCdRi", issCdRi);
					request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
					GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
					String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
					request.setAttribute("pDeductibleExist", pDeductibleExist);
					
					PAGE = "/pages/underwriting/itemInformation.jsp";
				} else if("saveGipiParAviationItem".equals(ACTION)){	
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService"); // +env
					List<GIPIWAviationItem> aviationList = new ArrayList<GIPIWAviationItem>();
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
					
					//aviation items
					aviationList = prepareAviationItem(request);
					
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
					
					param.put("parId", parId);
					param.put("userId", USER.getUserId());
					param.put("itemList", GIPIWItemUtil.prepareGIPIWItems(request));
					param.put("delItemMap", GIPIWItemUtil.prepareGipiWItemForDelete(request));
					param.put("aviationList", aviationList);
					param.put("globals", globals);
					param.put("vars", vars);
					param.put("pars", pars);
					param.put("others", others);
					param.put("gipiParList", GIPIPARUtil.prepareGIPIParList(request));
					
					if (gipiWAviationItemService.saveAvaiationItem(param)){
						message = "SUCCESS";
					}else{
						message = "FAILED";
					}
					
					PAGE = "/pages/genericMessage.jsp";
				} else if("preCommitAviationItem".equals(ACTION)){
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService"); // +env
					int itemNo = Integer.parseInt(request.getParameter("itemNo"));
					String vesselCd = request.getParameter("vesselCd");
					
					Map params = new HashMap();
					params = gipiWAviationItemService.preCommitAviationItem(parId, itemNo, vesselCd);
					String recFlag = (String) params.get("recFlag");
					message = recFlag;
					PAGE = "/pages/genericMessage.jsp";
				} else if("saveParAVItems".equals(ACTION)){
					GIPIWAviationItemService gipiWAviationItemService = (GIPIWAviationItemService) APPLICATION_CONTEXT.getBean("gipiWAviationItemService"); // +env
					gipiWAviationItemService.saveGIPIWAviationItm(request.getParameter("parameters"), USER);
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
	
	public List<GIPIWAviationItem> prepareAviationItem(HttpServletRequest request){
		List<GIPIWAviationItem> aviationItems = new ArrayList<GIPIWAviationItem>();
		if(request.getParameterValues("itemItemNos") != null && !(request.getParameterValues("vesselCds").toString().isEmpty())){
			String[] parIds				= request.getParameterValues("itemParIds");
			String[] itemNos			= request.getParameterValues("itemItemNos");	
			String[] purposes			= request.getParameterValues("purposes");
			String[] deductTexts		= request.getParameterValues("deductTexts");
			String[] prevUtilHrss		= request.getParameterValues("prevUtilHrss");
			String[] estUtilHrss		= request.getParameterValues("estUtilHrss");
			String[] totalFlyTimes		= request.getParameterValues("totalFlyTimes");
			String[] qualifications		= request.getParameterValues("qualifications");
			String[] geogLimits			= request.getParameterValues("geogLimits");
			String[] vesselCds			= request.getParameterValues("vesselCds");
			String[] recFlagAvs			= request.getParameterValues("recFlagAvs");
			
			if (request.getParameterValues("vesselCds") != null) {
				for (int a = 0; a < vesselCds.length; a++) {
					aviationItems.add(new GIPIWAviationItem(
							parIds[a],itemNos[a],vesselCds[a],
							totalFlyTimes[a].replaceAll(",", ""),qualifications[a],purposes[a],
							geogLimits[a],deductTexts[a],recFlagAvs[a],
							null,null,prevUtilHrss[a].replaceAll(",", ""),estUtilHrss[a].replaceAll(",", "")));
				}
			}
		}	
		return aviationItems;
	}

}
