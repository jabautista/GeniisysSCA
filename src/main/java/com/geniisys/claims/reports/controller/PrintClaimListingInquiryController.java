package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet (name="PrintClaimListingInquiryController", urlPatterns={"/PrintClaimListingInquiryController"})
public class PrintClaimListingInquiryController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 391856010046182614L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");				
				Map<String, Object> params = new HashMap<String, Object>();
				
				if("GICLR257".equals(reportId)){
					String searchBy = request.getParameter("searchBy");
					params.put("P_PAYEE_NO", request.getParameter("payeeNoA"));
					params.put("P_STAT", request.getParameter("status"));
					params.put("P_USER_ID", USER.getUserId());
					if(searchBy.equals("claimFileDate")){
						params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_DATE", request.getParameter("dateFrom"));
						params.put("P_TO_DATE", request.getParameter("dateTo"));
					}else if(searchBy.equals("lossDate")){
						params.put("P_AS_OF_LDATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_LDATE", request.getParameter("dateFrom"));
						params.put("P_TO_LDATE", request.getParameter("dateTo"));
					}else if(searchBy.equals("dateAssigned")){
						params.put("P_AS_OF_ADATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_ADATE", request.getParameter("dateFrom"));
						params.put("P_TO_ADATE", request.getParameter("dateTo"));
					}
					System.out.println("GICLR257 params: "+params);
				}else if("GICLR257A".equals(reportId)){
					String searchBy = request.getParameter("searchBy");
					params.put("P_PAYEE_NO", request.getParameter("payeeNo"));
					params.put("P_STAT", request.getParameter("status"));
					params.put("P_USER_ID", USER.getUserId());
					if(searchBy.equals("claimFileDate")){
						params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_DATE", request.getParameter("dateFrom"));
						params.put("P_TO_DATE", request.getParameter("dateTo"));
					}else if(searchBy.equals("lossDate")){
						params.put("P_AS_OF_LDATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_LDATE", request.getParameter("dateFrom"));
						params.put("P_TO_LDATE", request.getParameter("dateTo"));
					}else if(searchBy.equals("dateAssigned")){
						params.put("P_AS_OF_ADATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_ADATE", request.getParameter("dateFrom"));
						params.put("P_TO_ADATE", request.getParameter("dateTo"));
					}
				}else if("GICLR257B".equals(reportId)){
					params.put("P_PAYEE_NO", request.getParameter("payeeNo"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
					params.put("P_USER_ID", USER.getUserId());					
					String searchBy = request.getParameter("searchBy");
					if(searchBy.equals("claimFileDate"))
						params.put("P_SEARCH_TYPE", "1");
					else if(searchBy.equals("lossDate"))
						params.put("P_SEARCH_TYPE", "2");
					else if(searchBy.equals("dateAssigned"))
						params.put("P_SEARCH_TYPE", "3");
				}else if("GICLR258".equals(reportId)){
					params.put("P_REC_TYPE_CD", request.getParameter("recTypeCd"));
					params.put("P_SEARCH_BY", request.getParameter("searchBy"));
					params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					System.out.println("GICLR258 params: "+ params);
				}else if("GICLR263".equals(reportId) || "GICLR263_CSV".equals(reportId)){ //Dren Niebres SR-5374 04.26.2016
					params.put("P_MAKE_CD", request.getParameter("makeCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_COMP", request.getParameter("carCompanyCd"));
					if("claimFileDate".equals(request.getParameter("searchBy"))){
						params.put("P_FROM_FDATE", request.getParameter("fromDate"));
						params.put("P_TO_FDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_FDATE", request.getParameter("asOfDate"));
					}else{
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
					System.out.println("GICLR263 params: "+ params);
				}else if("GICLR275".equals(reportId)){
					params.put("P_MOTCAR_COMP_CD", request.getParameter("carCompanyCd"));
					params.put("P_MAKE_CD", request.getParameter("makeCd"));
					params.put("P_MODEL_YEAR", request.getParameter("modelYear"));
					params.put("P_LOSS_EXP_CD", request.getParameter("lossExpCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_CLM_PER_MC_RPL_GICLR275"); // added by carlo de guzman 4.01.2016 SR 5409
					params.put("functionName", "csv_"+reportId);    // added by carlo de guzman 4.01.2016 SR 5409
					params.put("csvAction", "print"+reportId+"CSV");   // added by carlo de guzman 4.01.2016 SR 5409
					if("claimFileDate".equals(request.getParameter("searchBy"))){
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					}else{
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
					System.out.println("GICLR275 params: "+ params);
				}else if("GICLR264".equals(reportId)){
					params.put("P_COLOR_CD", Integer.parseInt(request.getParameter("colorCd")));
					params.put("P_BASIC_COLOR_CD", request.getParameter("basicColorCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_SEARCH_BY", Integer.parseInt(request.getParameter("searchBy")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));	
					params.put("packageName", "CSV_CLM_PER_COLOR_GICLR264");	 //added for gilcr264csv carlo de guzman 3/1/2016
					params.put("functionName", "get_giclr264"); 			     //added for gilcr264csv carlo de guzman 3/1/2016
					params.put("csvAction", "printGICLR264CSV");       			 //added for gilcr264csv carlo de guzman 3/1/2016					
				} else if("GICLR251".equals(reportId)){
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_ASSD_NO", request.getParameter("assdNo"));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR251A".equals(reportId)){
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_ASSD_NO", request.getParameter("assdNo"));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR251B".equals(reportId)){
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_FREE_TEXT", request.getParameter("freeText"));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR251C".equals(reportId)){
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_FREE_TEXT", request.getParameter("freeText"));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR266".equals(reportId) || "GICLR266_CSV".equals(reportId)){ //Dren Niebres SR-5370 05.10.2016
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_INTM_NO", Integer.parseInt(request.getParameter("intmNo")));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR266A".equals(reportId) || "GICLR266A_CSV".equals(reportId)){ //Dren Niebres SR-5370 05.10.2016
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_INTM_NO", Integer.parseInt(request.getParameter("intmNo")));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR268".equals(reportId)){
					params.put("P_PLATE_NO", request.getParameter("plateNo"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_CLM_PER_PLATENO_GICLR268"); // added by carlo de guzman 3.31.2016 SR-5406
					params.put("functionName", "csv_"+reportId);    // added by carlo de guzman 3.31.2016 SR-5406
					params.put("csvAction", "print"+reportId+"CSV");   // added by carlo de guzman 3.31.2016 SR-5406
					if(request.getParameter("searchBy").equals("claimFileDate")){
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					} else {
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
				}else if("GICLR262".equals(reportId)){
					params.put("P_VESSEL_CD", request.getParameter("vesselCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_CLM_PER_VESSEL_GICLR262");	 //Dren 03.08.2016 SR-5373
					params.put("functionName", "csv_giclr262"); 			     //Dren 03.08.2016 SR-5373
					params.put("csvAction", "printGICLR262CSV");       			 //Dren 03.08.2016 SR-5373					
					if("claimFileDate".equals(request.getParameter("searchBy"))){
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					}else{
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
				}else if("GICLR267".equals(reportId)){
					params.put("P_RI_CD", request.getParameter("riCd"));
					if("claimFileDate".equals(request.getParameter("searchBy"))){
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					}else{
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
					params.put("packageName", "CSV_CLM_PER_CEDING_GICLR267");	 //bernadeth quitain 3/29/2016 SR-5405
					params.put("functionName", "CSV_GICLR267"); 			     //bernadeth quitain 3/29/2016 SR-5405
					params.put("csvAction", "printGICLR267CSV");  				 //bernadeth quitain 3/29/2016 SR-5405
					System.out.println("GICLR267 params: "+ params);
				}else if("GICLR268".equals(reportId)){
					params.put("P_PLATE_NO", request.getParameter("plateNo"));
					if("claimFileDate".equals(request.getParameter("searchBy"))){
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					}else{
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
					System.out.println("GICLR268 params: "+ params);
				}else if("GICLR268A".equals(reportId)){
					params.put("P_PLATE_NO", request.getParameter("plateNo"));
					if("claimFileDate".equals(request.getParameter("searchBy"))){
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					}else{
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
				}else if ("GICLR259".equals(reportId)) {
					params.put("P_PAYEE_NO", Integer.parseInt(request.getParameter("payeeCd")));
					params.put("P_PAYEE_CLASS_CD",Integer.parseInt(request.getParameter("payeeClassCd")));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_CLM_PER_PAYEE_GICLR259"); //CarloR SR-5369 06.23.2016 -start
					params.put("functionName", "GET_GICLR259_DETAILS");    
					params.put("csvAction", "printGICLR259CSV");       	   //end SR-5369 
					if (request.getParameter("dateType").equals("fileDate")) {
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					} else {
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
					}
				} else if ("GICLR250".equals(reportId) || "GICLR250A".equals(reportId)) {
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_POL_ISS_CD", request.getParameter("polIssCd"));
					params.put("P_ISSUE_YY", Integer.parseInt(request.getParameter("issueYy")));
					params.put("P_POL_SEQ_NO", Integer.parseInt(request.getParameter("polSeqNo")));
					params.put("P_RENEW_NO", Integer.parseInt(request.getParameter("renewNo")));
					params.put("P_SEARCH_BY_OPT", request.getParameter("searchByOpt"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
				} else if("GICLR274A".equals(reportId) || "GICLR274B".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_POL_ISS_CD", request.getParameter("polIssCd"));
					params.put("P_ISSUE_YY", Integer.parseInt(request.getParameter("issueYy")));
					params.put("P_POL_SEQ_NO", Integer.parseInt(request.getParameter("polSeqNo")));
					params.put("P_RENEW_NO", Integer.parseInt(request.getParameter("renewNo")));
					if("fileDate".equals(request.getParameter("searchByOpt"))){
						params.put("P_FROM_DATE", request.getParameter("dateFrom"));
						params.put("P_TO_DATE", request.getParameter("dateTo"));
						params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
					}else{//lossDate
						params.put("P_FROM_LDATE", request.getParameter("dateFrom"));
						params.put("P_TO_LDATE", request.getParameter("dateTo"));
						params.put("P_AS_OF_LDATE", request.getParameter("dateAsOf"));
					}
					System.out.println(reportId + " params: " + params);
				} else if ("GICLR252".equals(reportId)) {
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_STAT", request.getParameter("status"));
					params.put("P_SEARCH_BY_OPT", request.getParameter("dateBy"));
					params.put("P_DATE_AS_OF", request.getParameter("dateAsOf"));
					params.put("P_DATE_FROM", request.getParameter("dateFrom"));
					params.put("P_DATE_TO", request.getParameter("dateTo"));
					System.out.println("GICLR252 params: "+params);
				} else if("GICLR265".equals(reportId)){
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_CARGO_CLASS_CD", request.getParameter("cargoClassCd"));
					params.put("P_CARGO_TYPE", request.getParameter("cargoType"));
					params.put("packageName", "CSV_CLM_PER_CARGO_GICLR265"); // added by carlo de guzman 3.08.2016
					params.put("functionName", "csv_giclr265");    // added by carlo de guzman 3.08.2016
					params.put("csvAction", "printGICLR265CSV");   // added by carlo de guzman 3.08.2016					
					
					if("1".equals(request.getParameter("searchBy"))){
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));						
					} else {
						params.put("P_AS_OF_L_DATE", request.getParameter("asOfDate"));
						params.put("P_FROM_L_DATE", request.getParameter("fromDate"));
						params.put("P_TO_L_DATE", request.getParameter("toDate"));
					}						
				}  else if("GICLR271".equals(reportId)){
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_IN_HOU_ADJ", request.getParameter("inHouAdj"));
					params.put("packageName", "CSV_CLM_PER_USER_GICLR271");
					params.put("functionName", "csv_giclr271");
					params.put("csvAction", "printGICLR271CSV");
					
					if("fileDate".equals(request.getParameter("searchByOpt"))){
						params.put("P_AS_OF_DATE", request.getParameter("dateAsOf") == "" ? null : sdf.parse(request.getParameter("dateAsOf")));
						params.put("P_FROM_DATE", request.getParameter("dateFrom") == "" ? null : sdf.parse(request.getParameter("dateFrom")));
						params.put("P_TO_DATE", request.getParameter("dateTo") == "" ? null : sdf.parse(request.getParameter("dateTo")));
					}else if("lossDate".equals(request.getParameter("searchByOpt"))){
						params.put("P_AS_OF_LDATE", request.getParameter("dateAsOf") == "" ? null : sdf.parse(request.getParameter("dateAsOf")));
						params.put("P_FROM_LDATE", request.getParameter("dateFrom") == "" ? null : sdf.parse(request.getParameter("dateFrom")));
						params.put("P_TO_LDATE", request.getParameter("dateTo") == "" ? null : sdf.parse(request.getParameter("dateTo")));
					}else if("entryDate".equals(request.getParameter("searchByOpt"))){
						params.put("P_AS_OF_EDATE", request.getParameter("dateAsOf") == "" ? null : sdf.parse(request.getParameter("dateAsOf")));
						params.put("P_FROM_EDATE", request.getParameter("dateFrom") == "" ? null : sdf.parse(request.getParameter("dateFrom")));
						params.put("P_TO_EDATE", request.getParameter("dateTo") == "" ? null : sdf.parse(request.getParameter("dateTo")));
					}
				} else if("GICLR276".equals(reportId) || "GICLR276_CSV".equals(reportId)){ //GICLR276_CSV added for CSV report SR-5410 Kevin 6-16-2016
					params.put("P_USER_ID", USER.getUserId());	
					params.put("P_LAWYER_CD", Integer.parseInt(request.getParameter("lawyerCd")));
					params.put("P_LAWYER_CLASS_CD", request.getParameter("lawyerClassCd"));
					System.out.println(request.getParameter("lawyerClassCd"));
					params.put("P_SEARCH_BY", Integer.parseInt(request.getParameter("searchBy")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));	
					params.put("P_USER_ID", USER.getUserId());
				} else if("GICLR279".equals(reportId) || "GICLR279_CSV".equals(reportId)){ //added GICLR279_CSV SR-5415
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_BLOCK_ID", Integer.parseInt(request.getParameter("blockId"))); 
					params.put("P_DATE_CONDITION", request.getParameter("dateCondition"));
					params.put("P_SEARCH_BY", request.getParameter("searchBy")); //added parameter SR-5415
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
				} else if ("GICLR269".equals(reportId)) {
					String dateBy = request.getParameter("dateBy");
					
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_STATUS", request.getParameter("status"));
					
					if(dateBy.equals("claimFileDate")){
						params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_DATE", request.getParameter("dateFrom"));
						params.put("P_TO_DATE", request.getParameter("dateTo"));
					}else if(dateBy.equals("lossDate")){
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
					}										
				} else if("GICLR277".equals(reportId)){
					String searchBy = request.getParameter("searchBy");
					
					params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd"));
					params.put("P_PAYEE_NO",Integer.parseInt(request.getParameter("payeeNo")));
					params.put("P_TP_TYPE", request.getParameter("tpType"));
					//Start John Michael Mabini SR-5413 4/26/2016
					params.put("csvAction", "printGICLR277CSV");
					params.put("packageName", "CSV_GICLR277_PKG");
					params.put("functionName", "csv_giclr277");
					//End
					if(searchBy.equals("claimFileDate")){
						params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
					}else if(searchBy.equals("lossDate")){
						params.put("P_AS_OF_LDATE", request.getParameter("asOfDate"));
						params.put("P_FROM_LDATE", request.getParameter("fromDate"));
						params.put("P_TO_LDATE", request.getParameter("toDate"));
					}	
				}else if("GICLR278".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_POL_ISS_CD", request.getParameter("polIssCd"));
					params.put("P_ISS_YY", request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
					params.put("P_POL_SEQ_NO", request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
					params.put("P_RENEW_NO", request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
					params.put("P_DT_BASIS", request.getParameter("dateType"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF", request.getParameter("asOfDate"));
					//Start John Michael Mabini SR-5414 4/25/2016
					params.put("csvAction","printGICLR278CSV");
					params.put("packageName", "CSV_GICLR278_PKG");
					params.put("functionName", "populate_giclr278");
					//End
				}else if("GICLR057C".equals(reportId) || "GICLR057C_CSV".equals(reportId)){		// Start: added by Kevin for SR-5417
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_CATASTROPHIC_CD", request.getParameter("catCd"));
					params.put("P_LOSS_CAT_CD", request.getParameter("lossCatCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_LOCATION", request.getParameter("location"));
					params.put("P_BLOCK_NO", request.getParameter("blockNo"));
					params.put("P_DISTRICT_NO", request.getParameter("districtNo"));
					params.put("P_CITY_CD", request.getParameter("cityCd"));
					params.put("P_PROVINCE_CD", request.getParameter("provinceCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
				}else if("GICLR057D".equals(reportId) || "GICLR057D_CSV".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_CATASTROPHIC_CD", request.getParameter("catCd"));
					params.put("P_LOSS_CAT_CD", request.getParameter("lossCatCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_LOCATION", request.getParameter("location"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate")); // End: added by Kevin for SR-5417
				}else if("GICLR256".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LOSS_CAT", request.getParameter("lossCatCd"));
					params.put("P_SEARCH_BY", request.getParameter("searchBy"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GICLR253".equals(reportId)){
					params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
					params.put("P_SEARCH_BY", request.getParameter("searchBy"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("packageName", "CSV_CLM_PER_MSHOP_GICLR253");	 //Dren 03.08.2016 SR-5373
					params.put("functionName", "csv_giclr253"); 			     //Dren 03.08.2016 SR-5373
					params.put("csvAction", "printGICLR253CSV");       			 //Dren 03.08.2016 SR-5373					
				}else if("GICLR273".equals(reportId) || "GICLR273_CSV".equals(reportId)){ //jmm SR-5629
					String searchBy = request.getParameter("searchBy");
					params.put("P_USER_ID", USER.getUserId());
					if(searchBy.equals("1")){	//claimFileDate
						params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_DATE", request.getParameter("dateFrom"));
						params.put("P_TO_DATE", request.getParameter("dateTo"));
					}else if(searchBy.equals("2")){	//lossDate
						params.put("P_AS_OF_LDATE", request.getParameter("dateAsOf"));
						params.put("P_FROM_LDATE", request.getParameter("dateFrom"));
						params.put("P_TO_LDATE", request.getParameter("dateTo"));
					}					
				}
				
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/inquiry/listing/reports")+"/";
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				this.doPrintReport(request, response, params, reportDir);
				
			}
		} catch (SQLException e) {			
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
