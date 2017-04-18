package com.geniisys.giac.controllers;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISCurrency;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.exceptions.UploadSizeLimitExceededException;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.common.service.CGRefCodesService;
import com.geniisys.common.service.GIISCurrencyService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACUploadingService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name = "GIACUploadingController", urlPatterns = { "/GIACUploadingController" })
public class GIACUploadingController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub

		Integer noOfRecords = 0;
		File uploadedFile = null;
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			CGRefCodesService cgRefCodesService = (CGRefCodesService) APPLICATION_CONTEXT.getBean("cgRefCodesService");
			GIACUploadingService giacUploadingService = (GIACUploadingService) APPLICATION_CONTEXT
					.getBean("giacUploadingService");
			GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT
					.getBean("giacParameterFacadeService");

			if ("showConvertFile".equals(ACTION)) {
				request.setAttribute("trans", cgRefCodesService.getFileSourceList());
				PAGE = "/pages/accounting/uploading/convertFile/convertFile.jsp";
			} else if ("checkFileName".equals(ACTION)) {
				request.setAttribute("object", giacUploadingService.checkFileName(request));
				PAGE = "/pages/genericObject.jsp";
			} else if ("readFile".equals(ACTION)) {
				String filePath = getServletContext().getInitParameter("UPLOADS_PATH");
				response.setContentType("text/html");
				FileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				FileUploadListener listener = new FileUploadListener();
				HttpSession session = request.getSession();
				session.setAttribute("LISTENER", listener);
				upload.setProgressListener(listener);
				StringBuffer sb = new StringBuffer();
				List items = null;
				FileItem fileItem = null;
				String myFileName = "";

				(new File(filePath)).mkdir();
				items = new ArrayList<>();// upload.parseRequest(request);
				items = upload.parseRequest(request);
				//File uploadedFile = null; //declared within the controller
				for (Iterator i = items.iterator(); i.hasNext();) {
					fileItem = (FileItem) i.next();
					if (!fileItem.isFormField()) {
						if (fileItem.getSize() > 0) {
							// code that handle uploaded fileItem
							// don't forget to delete uploaded files after you
							// done
							// with them! Use fileItem.delete();
							String myFullFileName = fileItem.getName();

							String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows
																									// or
																									// UNIX
							int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
							int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");

							// Ignore the path and get the filename
							myFileName = myFullFileName.substring(lastIndexOfSlash + 1);

							if (!FileUtil.isExcelFile(myFullFileName, lastIndexOfPeriod)) {
								fileItem.delete();
								throw new FileUploadException("The file you are trying to upload is not supported.");
							} else if (listener.getBytesRead() > 1048576) {
								fileItem.delete();
								throw new UploadSizeLimitExceededException("Upload limit is only 1MB");
							} else {
								// Create new File object
								uploadedFile = new File(filePath, myFileName);
								System.out.println("filePath : " + filePath);
								System.out.println("myFileName : " + myFileName.replaceAll(".xls", ""));
								// if (uploadedFile.isFile()) {
								// throw new
								// MediaAlreadyExistingException("Media already
								// exists!");
								// }

								// Write the uploaded file to the system
								fileItem.write(uploadedFile);
								sb.append("SUCCESS");

								Map<String, Object> params = new HashMap<String, Object>();
								params.put("tranTypeCd", request.getParameter("selTransaction"));
								params.put("sourceCd", request.getParameter("txtSourceCd"));
								params.put("convertDate", request.getParameter("txtConvertDate"));
								params.put("remarks", request.getParameter("txtRemarks"));
								params.put("userId", USER.getUserId());
								params.put("myFileName", myFileName.replaceAll(".xls", "").trim());

								noOfRecords = giacUploadingService.countExcelRows(uploadedFile);
								try {
									params = giacUploadingService.readFile(uploadedFile, params);
									// message = (String) params.get("message")
									// + "#" + (String) params.get("rows");
									// //replaced by john 4.21.2015
									// JSONObject jsonMessage = new
									// JSONObject(params);
									// message = jsonMessage.toString();
									// PAGE = "/pages/genericMessage.jsp";
									// //replaced by john 4.21.2015
									request.setAttribute("object", new JSONObject(params));
									PAGE = "/pages/genericObject.jsp";
									System.out.println("RETURN : " + params);
								} catch (SQLException e) {
									if (e.getErrorCode() > 20000) {
										message = ExceptionHandler.extractSqlExceptionMessage(e);
										ExceptionHandler.logException(e);
									} else {
										message = ExceptionHandler.handleException(e, USER);
									}
									PAGE = "/pages/genericMessage.jsp";
								}
							}
						}
					}
				}

			} else if ("showProcessDataListing".equals(ACTION)) {
				JSONObject jsonProcessDataList = giacUploadingService.getProcessDataList(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonProcessDataList.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonProcessDataList", jsonProcessDataList);
					PAGE = "/pages/accounting/uploading/processDataListing/processDataListing.jsp";
				}
			} else if ("showGiacs603".equals(ACTION)) { // added by john
														// 4.21.2015
				request.setAttribute("jsonGiacs603Table", giacUploadingService.showGiacs603RecList(request));
				request.setAttribute("showGiacs603Head",
						new JSONObject(giacUploadingService.showGiacs603Head(request, USER.getUserId())));
				request.setAttribute("giacs603Legend",
						new JSONObject(giacUploadingService.showGiacs603Legend(request)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/processDataPerPolicy.jsp";
			} else if ("showGiacs603RecList".equals(ACTION)) {
				JSONObject jsonGiacs603Table = giacUploadingService.showGiacs603RecList(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGiacs603Table.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGiacs603Table", jsonGiacs603Table);
					PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/processDataPerPolicy.jsp";
				}
			} else if ("showPaymentDetailsDV".equals(ACTION)) {
				request.setAttribute("showGiacUploadDvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadDvPaytDtl(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/subPages/paymentDetailsDV.jsp";
			} else if ("showPaymentDetailsJV".equals(ACTION)) {
				request.setAttribute("showGiacUploadJvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadJvPaytDtl(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/subPages/paymentDetailsJV.jsp";
			} else if ("saveGiacs603DVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGiacs603DVPaytDtl(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("delGiacs603DVPaytDtl".equals(ACTION)) {
				giacUploadingService.delGiacs603DVPaytDtl(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiacs603JVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGiacs603JVPaytDtl(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("delGiacs603JVPaytDtl".equals(ACTION)) {
				giacUploadingService.delGiacs603JVPaytDtl(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("uploadingForeignCurrency".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/subPages/uploadingForeignCurrency.jsp";
			} else if ("uploadingForeignCurrencyPerBill".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBill/subPages/uploadingForeignCurrency.jsp";
			} else if ("checkDataGiacs603".equals(ACTION)) {
				giacUploadingService.checkDataGiacs603(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showPrintDialog".equals(ACTION)) {
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/subPages/overlayUploadPrint.jsp";
			} else if ("cancelFileGiacs603".equals(ACTION)) {
				giacUploadingService.cancelFileGiacs603(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateUploadGiacs603".equals(ACTION)) {
				giacUploadingService.validateUploadGiacs603(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showDefaultBank".equals(ACTION)) {
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT
						.getBean("giacUserFunctionsService");
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.getDefaultBank(request, USER.getUserId()))));
				request.setAttribute("hasCCFunction",
						giacUserFunctionsService.checkIfUserHasFunction("CC", "GIACS007", USER.getUserId()));
				request.setAttribute("hasAUFunction",
						giacUserFunctionsService.checkIfUserHasFunction("UA", "GIACS603", USER.getUserId()));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerPolicy/subPages/defaultBank.jsp";
			} else if ("processGiacs603".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.processGiacs603(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs603CheckForOverride".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.giacs603CheckForOverride(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs603UploadPayments".equals(ACTION)) {
				giacUploadingService.giacs603UploadPayments(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("checkPaymentDetails".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.checkPaymentDetails(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validatePrintOr".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.validatePrintOr(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validatePrintDv".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.validatePrintDv(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validatePrintJv".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.validatePrintJv(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("checkDcbNoGiacs603".equals(ACTION)) {
				giacUploadingService.checkDcbNoGiacs603(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("showGIACS607".equals(ACTION)) { 
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
				String premLegend = StringFormatter.escapeHTML2(StringFormatter.escapeBackslash2(
						giacUploadingService.getGIACS607Legend("GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG")));
				String commLegend = StringFormatter.escapeHTML2(StringFormatter.escapeBackslash2(
						giacUploadingService.getGIACS607Legend("GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG")));
				Map<String, Object> mapLegend = new HashMap<String, Object>();
				mapLegend.put("premLegend", premLegend);
				mapLegend.put("commLegend", commLegend);

				request.setAttribute("jsonGUF",
						StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUFDetails(request)));
				request.setAttribute("jsonGUPC",
						StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUPCRecords(request)));
				request.setAttribute("jsonLegend", new JSONObject(mapLegend));
				request.setAttribute("jsonParameters", new JSONObject(giacUploadingService.getGIACS607Parameters(USER.getUserId())));
				/*request.setAttribute("noPremPayt", giacParamService.getParamValueV2("NO_PREM_PAYT"));
				request.setAttribute("hasAUFunction", giacUserFunctionsService.checkIfUserHasFunction("AU", "GIACS020", USER.getUserId()));*/ //Deo [01.31.2017]: comment out (SR-5906)
				PAGE = "/pages/accounting/uploading/convertFile/processPremAndComm/processPremAndComm.jsp";
			} else if ("getGUPCRecords".equals(ACTION)) {
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUPCRecords(request))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIACS607FCurrOverlay".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertFile/processPremAndComm/pop-ups/foreignCurrencyOverlay.jsp";
			} else if ("showGIACS607DVPaytDtlOverlay".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT
						.getBean("giisCurrencyService");

				String defaultCurrency = giacParamService.getParamValueV2("DEFAULT_CURRENCY");
				List<GIISCurrency> giisCurrency = giisCurrencyService.getCurrencyLOVByShortName(defaultCurrency);
				BigDecimal defaultCurrencyRt = null;
				Integer defaultCurrencyCd = null;

				if (giisCurrency.size() > 0) {
					defaultCurrencyRt = new BigDecimal(giisCurrency.get(0).getValueFloat());
					defaultCurrencyCd = giisCurrency.get(0).getCode();
				}

				request.setAttribute("defaultCurrency", StringFormatter.escapeHTMLInObject2(defaultCurrency));
				request.setAttribute("defaultCurrencyCd", defaultCurrencyCd);
				request.setAttribute("defaultCurrencyRt", defaultCurrencyRt);
				request.setAttribute("jsonGUDV",
						StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUDVDetails(request)));
				PAGE = "/pages/accounting/uploading/convertFile/processPremAndComm/pop-ups/dvPaytDtlOverlay.jsp";
			} else if ("saveGIACS607DVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGIACS607Gudv(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUDVDetails(request))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIACS607JVPaytDtlOverlay".equals(ACTION)) {
				request.setAttribute("jsonGUJV",
						StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUJVDetails(request)));
				PAGE = "/pages/accounting/uploading/convertFile/processPremAndComm/pop-ups/jvPaytDtlOverlay.jsp";
			} else if ("saveGIACS607JVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGIACS607Gujv(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUJVDetails(request))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIACS607CollnDtlOverlay".equals(ACTION)) {
				JSONObject jsonGUCD = giacUploadingService.getGIACS607GUCDetails(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGUCD.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");

					List<LOV> payModeCodes = helper.getList(LOVHelper.PAY_MODE_LISTING);
					request.setAttribute("payModeCodes", payModeCodes);
					List<LOV> checkClassDetails = helper.getList(LOVHelper.CHECK_CLASS_LISTING);
					request.setAttribute("checkClassDetails", checkClassDetails);

					request.setAttribute("jsonGUCD", StringFormatter.escapeHTMLInJSONObject(jsonGUCD));
					PAGE = "/pages/accounting/uploading/convertFile/processPremAndComm/pop-ups/collnDtlOverlay.jsp";
					;
				}
			} else if ("saveGIACS607CollnDtl".equals(ACTION)) {
				giacUploadingService.saveGIACS607Gucd(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS607GUCDetails(request))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkNetCollnGIACS607".equals(ACTION)) {
				giacUploadingService.checkNetCollnGIACS607(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateGIACS607GrossTag".equals(ACTION)) {
				giacUploadingService.updateGIACS607GrossTag(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("cancelFileGIACS607".equals(ACTION)) {
				giacUploadingService.cancelFileGIACS607(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkOrPaytsGIACS607".equals(ACTION)) {
				message = giacUploadingService.checkOrPaytsGIACS607(request.getParameter("tranId"));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateBeforeUploadGIACS607".equals(ACTION)) {
				giacUploadingService.validateBeforeUploadGIACS607(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validatePolicyGIACS607".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.validatePolicyGIACS607(request, USER.getUserId()))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkUserBranchAccessGIACS607".equals(ACTION)) {
				message = giacUploadingService.checkUserBranchAccessGIACS607(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkUploadGIACS607".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.checkUploadGIACS607(request, USER.getUserId()))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getParentIntmNoGIACS607".equals(ACTION)) {
				message = giacUploadingService.getParentIntmNoGIACS607(request.getParameter("intmNo")).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("uploadPaymentsGIACS607".equals(ACTION)) {
				giacUploadingService.uploadPaymentsGIACS607(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateOnPrintBtnGIACS607".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.validateOnPrintBtnGIACS607(request, USER.getUserId()))
						.toString();
				PAGE = "/pages/genericMessage.jsp"; // end shan 06.09.2015 :
													// conversion of GIACS607
			} else if ("checkDcbNoGiacs607".equals(ACTION)) {
				giacUploadingService.checkDcbNoGiacs607(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("showGiacs604".equals(ACTION)) { // added by john
														// 9.2.2015
				request.setAttribute("jsonGiacs604Table", giacUploadingService.showGiacs604RecList(request));
				request.setAttribute("showGiacs604Head",
						new JSONObject(giacUploadingService.showGiacs604Head(request, USER.getUserId())));
				request.setAttribute("giacs603Legend",
						new JSONObject(giacUploadingService.showGiacs603Legend(request)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBill/processDataPerBill.jsp";
			} else if ("showGiacs604RecList".equals(ACTION)) {
				JSONObject jsonGiacs604Table = giacUploadingService.showGiacs604RecList(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGiacs604Table.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGiacs604Table", jsonGiacs604Table);
					PAGE = "/pages/accounting/uploading/convertFile/processDataPerBill/processDataPerBill.jsp";
				}	
			} else if ("checkDataGiacs604".equals(ACTION)) {
				giacUploadingService.checkDataGiacs604(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs604ValidatePrintOr".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.giacs604ValidatePrintOr(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs604ValidatePrintDv".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.giacs604ValidatePrintDv(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs604ValidatePrintJv".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.giacs604ValidatePrintJv(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("cancelFileGiacs604".equals(ACTION)) {
				giacUploadingService.cancelFileGiacs603(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs604ShowPaymentDetailsDV".equals(ACTION)) {
				request.setAttribute("showGiacUploadDvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadDvPaytDtlGiacs604(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBill/subPages/paymentDetailsDV.jsp";
			} else if ("giacs604ShowPaymentDetailsJV".equals(ACTION)) {
				request.setAttribute("showGiacUploadJvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadJvPaytDtlGiacs604(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBill/subPages/paymentDetailsJV.jsp";
			} else if ("showGiacs604DefaultBank".equals(ACTION)) {
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT
						.getBean("giacUserFunctionsService");
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.getDefaultBank(request, USER.getUserId()))));
				request.setAttribute("hasCCFunction",
						giacUserFunctionsService.checkIfUserHasFunction("CC", "GIACS007", USER.getUserId()));
				request.setAttribute("hasAUFunction",
						giacUserFunctionsService.checkIfUserHasFunction("UA", "GIACS604", USER.getUserId()));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBill/subPages/defaultBank.jsp";
			} else if ("checkDcbNoGiacs604".equals(ACTION)) {
				giacUploadingService.checkDcbNoGiacs604(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("checkForClaim".equals(ACTION)) {
				giacUploadingService.checkForClaim(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkForOverride".equals(ACTION)) {
				giacUploadingService.checkForOverride(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs604UploadPayments".equals(ACTION)) {
				giacUploadingService.giacs604UploadPayments(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIACS608".equals(ACTION)) { // john 9.21.2015 :
														// conversion of
														// GIACS608
				request.setAttribute("giacs608Legend",
						new JSONObject(giacUploadingService.showGiacs608Legend(request)));
				request.setAttribute("guf",
						new JSONObject(giacUploadingService.giacs608Guf(request, USER.getUserId())));
				request.setAttribute("giup", giacUploadingService.showGiacs608RecList(request, USER.getUserId()));
				request.setAttribute("giupTotal",
						new JSONObject(giacUploadingService.giacs608GiupTableTotal(request, USER.getUserId())));
				
				//nieko Accounting Uploading GIACS608
				/*Map<String, Object> params = new HashMap<String, Object>();
				params.put("staleMgrChk", giacParamService.getParamValueN("STALE_MGR_CHK"));
				params.put("staleCheck", giacParamService.getParamValueN("STALE_CHECK"));
				params.put("staleDays", giacParamService.getParamValueN("STALE_DAYS"));
				params.put("fundCd", giacParamService.getParamValueV2("FUND_CD"));
				params.put("taxAllocation", giacParamService.getParamValueV2("TAX_ALLOCATION"));
				params.put("params", giacUploadingService.getParametersGiacs608(request, USER.getUserId()));
				request.setAttribute("jsonParameters", new JSONObject(params));*/
				request.setAttribute("jsonParameters",
						new JSONObject(giacUploadingService.getGIACS607Parameters(USER.getUserId())));
				PAGE = "/pages/accounting/uploading/convertFile/processInwardRIPrem/processInwardRIPrem.jsp";
			} else if ("showGiacs608RecList".equals(ACTION)) {
				JSONObject jsonGiacs608Table = giacUploadingService.showGiacs608RecList(request, USER.getUserId());
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGiacs608Table.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giup", jsonGiacs608Table);
					PAGE = "/pages/accounting/uploading/convertFile/processInwardRIPrem/processInwardRIPrem.jsp";
				}
			} else if ("giacs608ForeignCurrency".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertFile/processInwardRIPrem/subPages/foreignCurrency.jsp";
			} else if ("showGIACS608CollnDtlOverlay".equals(ACTION)) {
				JSONObject jsonGUCD = giacUploadingService.getGIACS608GUCDetails(request);
				
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGUCD.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");

					List<LOV> payModeCodes = helper.getList(LOVHelper.PAY_MODE_LISTING);
					request.setAttribute("payModeCodes", payModeCodes);
					List<LOV> checkClassDetails = helper.getList(LOVHelper.CHECK_CLASS_LISTING);
					request.setAttribute("checkClassDetails", checkClassDetails);
					
					request.setAttribute("jsonGUCD", StringFormatter.escapeHTMLInJSONObject(jsonGUCD));
					PAGE = "/pages/accounting/uploading/convertFile/processInwardRIPrem/subPages/collnDtlOverlay.jsp";
				}
			} else if ("saveGIACS608CollnDtl".equals(ACTION)) {
				giacUploadingService.saveGIACS608Gucd(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGIACS608GUCDetails(request))
						.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs608ShowPaymentDetailsDV".equals(ACTION)) {
				request.setAttribute("showGiacUploadDvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadDvPaytDtlGiacs608(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processInwardRIPrem/subPages/paymentDetailsDV.jsp";
			} else if ("giacs608ShowPaymentDetailsJV".equals(ACTION)) {
				request.setAttribute("showGiacUploadJvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadJvPaytDtlGiacs608(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processInwardRIPrem/subPages/paymentDetailsJV.jsp";
			} else if ("checkDataGiacs608".equals(ACTION)) {
				giacUploadingService.checkDataGiacs608(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkCollectionAmountGiacs608".equals(ACTION)) {
				giacUploadingService.checkCollectionAmountGiacs608(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkPaymentDetailsGiacs608".equals(ACTION)) {
				giacUploadingService.checkPaymentDetailsGiacs608(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("proceedUploadGiacs608".equals(ACTION)) {
				giacUploadingService.proceedUploadGiacs608(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giacs608ValidatePrintOr".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.giacs608ValidatePrintOr(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("checkDcbNoGiacs608".equals(ACTION)) {
				giacUploadingService.checkDcbNoGiacs608(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkNetCollnGIACS608".equals(ACTION)) {
				giacUploadingService.checkNetCollnGIACS608(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("showGiacs610".equals(ACTION)) {
				request.setAttribute("giacs610Legend",
						new JSONObject(giacUploadingService.showGiacs610Legend(request)));
				request.setAttribute("guf",
						new JSONObject(giacUploadingService.showGiacs610Guf(request, USER.getUserId())));
				request.setAttribute("gupr", giacUploadingService.showGiacs610RecList(request, USER.getUserId()));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBankRefNo/processDataPerBankRefNo.jsp";
			} else if ("showGiacs610RecList".equals(ACTION)) {
				JSONObject jsonGiacs610Table = giacUploadingService.showGiacs610RecList(request, USER.getUserId());
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGiacs610Table.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("gupr", jsonGiacs610Table);
					PAGE = "/pages/accounting/uploading/convertFile/processDataPerBankRefNo/processDataPerBankRefNo.jsp";
				}
			} else if ("showPaymentDetailsJVGiacs610".equals(ACTION)) {
				request.setAttribute("showGiacUploadJvPaytDtl",
						new JSONObject(giacUploadingService.showGiacUploadJvPaytDtl(request, USER)));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBankRefNo/subPages/paymentDetailsJV.jsp";
			} else if ("checkDataGiacs610".equals(ACTION)) {
				giacUploadingService./*checkDataGiacs603*/checkDataGiacs610(request, USER.getUserId()); //Deo [10.06.2016]: replace checkDataGiacs603 with checkDataGiacs610
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkValidatedGiacs610".equals(ACTION)) {
				giacUploadingService.checkValidatedGiacs610(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGiacs610DefaultBank".equals(ACTION)) {
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT
						.getBean("giacUserFunctionsService");
				request.setAttribute("object", StringFormatter.escapeHTMLInJSONObject(
						new JSONObject(giacUploadingService.getDefaultBankGiacs610(request, USER.getUserId()))));
				request.setAttribute("hasCCFunction",
						giacUserFunctionsService.checkIfUserHasFunction("CC", "GIACS007", USER.getUserId()));
				request.setAttribute("hasAUFunction",
						giacUserFunctionsService.checkIfUserHasFunction("UA", "GIACS610", USER.getUserId()));
				//Deo [10.06.2016]: add start
				request.setAttribute("processAll", request.getParameter("processAll"));
				if (request.getParameter("parameters") != null) {
					request.setAttribute("taggedRows", giacUploadingService.setTaggedRows(request));
				}
				//Deo [10.06.2016]: add ends
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBankRefNo/subPages/defaultBank.jsp";
			} else if ("checkDcbNoGiacs610".equals(ACTION)) {
				giacUploadingService.checkDcbNoGiacs610(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("uploadPaymentsGiacs610".equals(ACTION)) {
				giacUploadingService.uploadPaymentsGiacs610(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			//Deo [10.06.2016]: add start
			} else if ("validateUploadTranDate".equals(ACTION)) {
				giacUploadingService.validateUploadTranDate(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("cancelFileGiacs610".equals(ACTION)) {
				giacUploadingService.cancelFileGiacs610(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs610ValidatePrintOr".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter
						.escapeHTMLInMap(giacUploadingService.giacs610ValidatePrintOr(request, USER.getUserId()))));
				message = "SUCCESS";
				PAGE = "/pages/genericObject.jsp";
			} else if ("showUploadList".equals(ACTION)) {
				request.setAttribute("validRecords",
						new JSONObject(giacUploadingService.getValidRecords(request)));
				request.setAttribute("gupr", giacUploadingService.showGiacs610RecList(request, USER.getUserId()));
				PAGE = "/pages/accounting/uploading/convertFile/processDataPerBankRefNo/subPages/uploadList.jsp";
			} else if ("preUploadCheck".equals(ACTION)) {
				giacUploadingService.preUploadCheck(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiacs610JVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGiacs610JVDtls(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			//Deo [10.06.2016]: add ends
			//Deo: GIACS609 conversion start
			} else if ("showGiacs609".equals(ACTION)) {
				request.setAttribute("jsonGiacs609Table", giacUploadingService.showGiacs609RecList(request));
				request.setAttribute("showGiacs609Head", new JSONObject(giacUploadingService.showGiacs609Head(request)));
				request.setAttribute("giacs609Legend",
						StringFormatter.escapeHTML2(StringFormatter.escapeBackslash2(giacUploadingService.getGiacs609legend())));
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				request.setAttribute("hasAccess", giisUserFacadeService.checkUserAccess2("GIACS019", USER.getUserId()));
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
				request.setAttribute("hasODFnc", giacUserFunctionsService.checkIfUserHasFunction("OD", "GIACS019", USER.getUserId()));
				request.setAttribute("jsonParameters", new JSONObject(giacUploadingService.getGiacs609Parameters(USER.getUserId())));
				PAGE = "/pages/accounting/uploading/convertFile/processOutwardRIPrem/processOutwardRIPrem.jsp";
			} else if ("showGiacs609RecList".equals(ACTION)) {
				JSONObject jsonGiacs609Table = giacUploadingService.showGiacs609RecList(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGiacs609Table.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGiacs609Table", jsonGiacs609Table);
					PAGE = "/pages/accounting/uploading/convertFile/processOutwardRIPrem/processOutwardRIPrem.jsp";
				}
			} else if ("showGiacs609FC".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertFile/processOutwardRIPrem/pop-ups/foreignCurrencyOverlay.jsp";
			} else if ("showGiacs609CollnDtlOverlay".equals(ACTION)) {
				JSONObject jsonGUCD = giacUploadingService.getGiacs609CollnDtls(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = jsonGUCD.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");

					List<LOV> payModeCodes = helper.getList(LOVHelper.PAY_MODE_LISTING);
					request.setAttribute("payModeCodes", payModeCodes);
					List<LOV> checkClassDetails = helper.getList(LOVHelper.CHECK_CLASS_LISTING);
					request.setAttribute("checkClassDetails", checkClassDetails);

					request.setAttribute("jsonGUCD", StringFormatter.escapeHTMLInJSONObject(jsonGUCD));
					PAGE = "/pages/accounting/uploading/convertFile/processOutwardRIPrem/pop-ups/collnDtlOverlay.jsp";
				}
			} else if ("saveGiacs609CollnDtls".equals(ACTION)) {
				giacUploadingService.saveGiacs609CollnDtls(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGiacs609CollnDtls(request)).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGiacs609ORCollnDtls".equals(ACTION)) {				
				JSONArray collnDtls = new JSONArray(giacUploadingService.getGiacs609ORCollnDtls(request));
				request.setAttribute("object", collnDtls);
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateCollnAmtGiacs609".equals(ACTION)) {
				giacUploadingService.validateCollnAmtGiacs609(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGiacs609DVPaytDtl".equals(ACTION)) {
				request.setAttribute("jsonGUDV",
						StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGiacs609DVDtls(request, USER.getUserId())));
				PAGE = "/pages/accounting/uploading/convertFile/processOutwardRIPrem/pop-ups/dvPaytDtlOverlay.jsp";
			} else if ("saveGiacs609DVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGiacs609DVDtls(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGiacs609DVDtls(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGiacs609JVPaytDtl".equals(ACTION)) {
				request.setAttribute("gujpd",
						StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGiacs609JVDtls(request, USER.getUserId())));
				PAGE = "/pages/accounting/uploading/convertFile/processOutwardRIPrem/pop-ups/jvPaytDtlOverlay.jsp";
			} else if ("saveGiacs609JVPaytDtl".equals(ACTION)) {
				giacUploadingService.saveGiacs609JVDtls(request, USER.getUserId());
				message = StringFormatter.escapeHTMLInJSONObject(giacUploadingService.getGiacs609JVDtls(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkDataGiacs609".equals(ACTION)) {
				giacUploadingService.checkDataGiacs609(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validatePrintGiacs609".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.validatePrintGiacs609(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("uploadBeginGiacs609".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.uploadBeginGiacs609(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateTranDateGiacs609".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.validateTranDateGiacs609(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkUploadAllGiacs609".equals(ACTION)) {
				message = new JSONObject(giacUploadingService.checkUploadAllGiacs609(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("uploadPaymentsGiacs609".equals(ACTION)) {
				giacUploadingService.uploadPaymentsGiacs609(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("cancelFileGiacs609".equals(ACTION)) {
				giacUploadingService.cancelFileGiacs610(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			//Deo: GIACS609 conversion ends
			} else if ("readFile2".equals(ACTION)){
				FileEntityService fileService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
				// create file upload factory and upload servlet
				FileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				
				// set file upload progress listener
				FileUploadListener listener = new FileUploadListener();
				HttpSession session = request.getSession();
				session.setAttribute("LISTENER", listener);
				
				// upload servlet allows to set upload listener
				upload.setProgressListener(listener);
		
				// to be used to write response
				StringBuffer sb = new StringBuffer();
				
				List items 			= null;
				FileItem fileItem 	= null;
				String myFileName 	= "";
				String filePath   = (String) APPLICATION_CONTEXT.getBean("uploadPath");
				filePath += "accounting/uploading";
				//new File(filePath).getParentFile().mkdirs();
				new File(filePath).mkdirs();
				
				// iterate over all uploaded files
				items = upload.parseRequest(request);
				
				try {
					for (Iterator i = items.iterator(); i.hasNext();) {
						fileItem = (FileItem) i.next();
						if (!fileItem.isFormField()) {
							if (fileItem.getSize() > 0) {
								// code that handle uploaded fileItem
								// don't forget to delete uploaded files after you done
								// with them! Use fileItem.delete();
								//File uploadedFile = null; //declared within the controller
								String myFullFileName = fileItem.getName();
								
								String slashType 		= (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
								int lastIndexOfSlash 	= myFullFileName.lastIndexOf(slashType);
			                    myFileName = myFullFileName.substring(lastIndexOfSlash + 1);
			                    
			                    // Create new File object
				                uploadedFile = new File(filePath, fileItem.getName());
				                
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    // write media to web server			                    
			                    String uploadPath = "/uploads/accounting/uploading";
			                    Map<String, Object> params = new HashMap<String, Object>();
			                    params.put("fileName",fileItem.getName());
			                    params.put("filePath", filePath);
			                    params.put("uploadPath", uploadPath);
			                    params.put("realPath", request.getSession().getServletContext().getRealPath(""));
			                    params.put("message", "SUCCESS");
			                    fileService.writeMedia(params);
			                    
			                    params.put("tranTypeCd", request.getParameter("selTransaction"));
			                    params.put("sourceCd", request.getParameter("txtSourceCd"));
			                    params.put("convertDate", request.getParameter("txtConvertDate"));
								params.put("remarks", request.getParameter("txtRemarks"));
								params.put("userId", USER.getUserId());
									
								JSONObject result = new JSONObject(params); 
								message = result.toString();
								PAGE = "/pages/genericMessage.jsp";
			                    fileItem.delete();
		                    }
						}
					}									
				} catch (Exception e) {
					message = ExceptionHandler.handleException(e, USER);
				} finally {
					for (Iterator i = items.iterator(); i.hasNext();) {
						fileItem = (FileItem) i.next();
						fileItem.delete();
					}
					session.removeAttribute("LISTENER");
				}
			} else if ("showGIACS605".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertedAndUploadedFiles.jsp";
			} else if ("showGIACS606".equals(ACTION)) {
				PAGE = "/pages/accounting/uploading/convertedRecordsPerStatus.jsp"; 
			} else if ("processFile".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranTypeCd", request.getParameter("tranTypeCd"));
				params.put("sourceCd", request.getParameter("sourceCd"));
				params.put("convertDate", request.getParameter("convertDate"));
				params.put("remarks", request.getParameter("remarks"));
				params.put("userId", USER.getUserId());
				params.put("myFileName", request.getParameter("fileName").replaceAll(".xls", ""));
				
				uploadedFile = new File(request.getParameter("filePath"), request.getParameter("fileName"));

				noOfRecords = giacUploadingService.countExcelRows(uploadedFile);
				params = giacUploadingService.readFile(uploadedFile, params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
				System.out.println("RETURN : " + params);
			} else {
				HttpSession session = null;
				FileUploadListener listener = null;
				long contentLength = 0;
				
				if (((session = request.getSession()) == null)
						|| ((listener = (FileUploadListener) session.getAttribute("LISTENER")) == null)
						|| ((contentLength = listener.getContentLength()) < 1)) {
					return;
				}
				
				long percent = ((100 * listener.getBytesRead()) / contentLength);
				message = String.valueOf(percent);
				System.out.println("Message: " + message);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if (e.getErrorCode() > 20000) {
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
