/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
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
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWRequiredDocuments;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWRequiredDocumentsService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIWRequiredDocumentsController.
 */
public class GIPIWRequiredDocumentsController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWRequiredDocumentsController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
			GIPIWRequiredDocumentsService gipiWRequiredDocumentsService = (GIPIWRequiredDocumentsService) APPLICATION_CONTEXT.getBean("gipiWRequiredDocumentsService");
			//GIPIWPolBasicService gipiWPolBasicService = (GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			//int parId = 49802;// 16689;//with expiry date
			GIPIPARList gipiPAR = null;
			if (parId != 0)	{
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				//request.setAttribute("parDetails", gipiPAR);
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiPAR);
			}
			/*if ("showRequiredDocsPage".equals(ACTION)){
				log.info("Getting required documents page...");
				System.out.println("parId: "+parId);
				
				//GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
				//GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
				
				//request.setAttribute("wPolBasic", par);
				
				//getting all documents by par id
				List<GIPIWRequiredDocuments> reqDocs = gipiWRequiredDocumentsService.getReqDocsList(parId);
				request.setAttribute("reqDocs", reqDocs);
				
				//getting current date
				Date date = new Date();
				DateFormat formatter = new SimpleDateFormat("mm-dd-yyyy");
				String[] args={formatter.format(date)};
				request.setAttribute("dateSubmitted", formatter.parse(args[0]));
				
				//for LOV
				String lineCd = request.getParameter("globalLineCd");
				String sublineCd = request.getParameter("globalSublineCd");
				System.out.println("lineCd: "+lineCd);
				System.out.println("sublineCd: "+sublineCd);
				String[] params = {lineCd, sublineCd};
				request.setAttribute("reqDocsListing", lovHelper.getList(LOVHelper.REQUIRED_DOCS_LISTING, params));
				//request.setAttribute("expiryDate", gipiWPolBasicService.getExpiryDate(parId));
				//System.out.println("expiryDate: "+gipiWPolBasicService.getExpiryDate(parId));
				request.setAttribute("defaultUser", USER.getUserId());
//				PAGE = "/pages/underwriting/requiredDocuments.jsp";
				PAGE = "/pages/underwriting/requiredDocumentTableGrid.jsp";
			}*///replaced by agazarraga 5-11-2012, for tablegrid conversion
			if ("showRequiredDocsPage".equals(ACTION)){
				log.info("Getting required documents page...");
				System.out.println("parId: "+parId);
				Map<String, Object> params1 = new HashMap<String, Object>();
				params1.put("ACTION","getWReqDocsList2");
				params1.put("moduleId", request.getParameter("moduleId") == null ? "GIPIS002" : request.getParameter("moduleId"));
				params1.put("appUser", USER.getUserId());
				params1.put("parId", Integer.toString(parId));
				Map<String, Object> reqDocsTableGrid = TableGridUtil.getTableGrid(request, params1);
				JSONObject jsonReqDocsTableGrid = new JSONObject(reqDocsTableGrid);
				System.out.println(jsonReqDocsTableGrid.getJSONArray("rows").toString());
				JSONArray rows = jsonReqDocsTableGrid.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgDocSw", rows.getJSONObject(i).getString("docSw").equals("Y") ? true : false);
				}
				//getting current date
				Date date = new Date();
				DateFormat formatter = new SimpleDateFormat("mm-dd-yyyy");
				String[] args={formatter.format(date)};
				request.setAttribute("dateSubmitted", formatter.parse(args[0]));
				
				//for LOV
				String lineCd = request.getParameter("globalLineCd");
				String sublineCd = request.getParameter("globalSublineCd");
				System.out.println("lineCd: "+lineCd);
				System.out.println("sublineCd: "+sublineCd);
				String[] params = {lineCd, sublineCd};
				request.setAttribute("reqDocsListing", lovHelper.getList(LOVHelper.REQUIRED_DOCS_LISTING, params));
				request.setAttribute("defaultUser", USER.getUserId());
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonReqDocsTableGrid", jsonReqDocsTableGrid);
					PAGE = "/pages/underwriting/requiredDocumentTableGrid.jsp";
				}else{
					message = jsonReqDocsTableGrid.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			}
			else if ("saveReqDocsPageChanges".equals(ACTION)){
				gipiWRequiredDocumentsService.saveGIPISReqDocs(request,USER.getUserId());
				System.out.println(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				//changed by agazarraga 5/11/2012 for tablegrid conversion [saving]
				/*log.info("Saving changes...");
				String lineCd = request.getParameter("globalLineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				
				//docs for insert or update
				Map<String, Object> insDocs = new HashMap<String, Object>();
				String[] insDocCds = request.getParameterValues("insDocCd");
				insDocs.put("insDocCds", insDocCds);
				if (insDocCds != null){
					for (int i=0; i<insDocCds.length; i++){
						String docSw = request.getParameter("insDocSw"+insDocCds[i]);
						String dateSubmitted = request.getParameter("insDateSubmitted"+insDocCds[i]);
						if ("---".equals(dateSubmitted)){
							dateSubmitted = null;
						}
						String docCd = request.getParameter("insDocCd"+insDocCds[i]);
						String userId = request.getParameter("insUserId"+insDocCds[i]);
						String remarks = request.getParameter("insRemarks"+insDocCds[i]);
						if ("---".equals(remarks)){
							remarks = null;
						}
		
						System.out.println("CONTROLLER -- INS docCd: "+docCd);
						System.out.println("CONTROLLER -- INS docSw: "+docSw);
						System.out.println("CONTROLLER -- INS dateSubmitted: "+dateSubmitted);
						System.out.println("CONTROLLER -- INS userId: "+userId);
						System.out.println("CONTROLLER -- INS remarks: "+remarks);
						System.out.println("CONTROLLER -- INS lineCd: "+lineCd);
						System.out.println("CONTROLLER -- INS parId: "+parId);
						
						Map<String, Object> docMap = new HashMap<String, Object>();
						docMap.put("docSw", docSw);
						docMap.put("dateSubmitted", dateSubmitted);
						docMap.put("docCd", insDocCds[i]);
						docMap.put("userId", userId);
						docMap.put("remarks", remarks);
						docMap.put("lineCd", lineCd);
						docMap.put("parId", parId);
						insDocs.put(insDocCds[i], docMap);
					}
				}
				params.put("insDocs", insDocs);
				
				//docs for delete
				Map<String, Object> delDocs = new HashMap<String, Object>();
				String[] delDocCds = request.getParameterValues("delDocCd");
				//System.out.println("delete length: "+delDocCds.length);
				delDocs.put("delDocCds", delDocCds);
				if (delDocCds != null){
					for (int i=0; i<delDocCds.length; i++){
						String docCd = request.getParameter("delDocCd"+delDocCds[i]);
						System.out.println("CONTROLLER -- DEL docCd: "+docCd);
						Map<String, Object> docMap = new HashMap<String, Object>();
						docMap.put("docCd", docCd);
						delDocs.put(delDocCds[i], docMap);
					}
				}
				params.put("delDocs", delDocs);
				
				gipiWRequiredDocumentsService.saveGIPIWReqDocs(params);
				message = "SAVING SUCCESSFUL.";
				PAGE = "/pages/genericMessage.jsp";*/
			} else if ("reloadDocumentsTable".equals(ACTION)){
				log.info("Refreshing required documents listing...");
				System.out.println("parId: "+parId);
				
				//getting all documents by par id
				List<GIPIWRequiredDocuments> reqDocs = gipiWRequiredDocumentsService.getReqDocsList(parId);
				request.setAttribute("reqDocs", reqDocs);
				PAGE = "/pages/underwriting/subPages/requiredDocumentsListingTable.jsp";
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
