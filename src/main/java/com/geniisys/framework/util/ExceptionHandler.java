package com.geniisys.framework.util;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.ReportNotFoundException;

public class ExceptionHandler {

	private static String newLine = System.getProperty("line.separator");
	private static boolean detailedExceptionMessage;
	private static boolean autoBugReport;
	private static Mailer mailer;
	private static String clientShortName;
	
	private static Logger logger = Logger.getLogger(ExceptionHandler.class);
	
	public void setAutoBugReport(boolean autoBugReport) {
		ExceptionHandler.autoBugReport = autoBugReport;
	}

	public static boolean isAutoBugReport() {
		return autoBugReport;
	}

	public void setDetailedExceptionMessage(boolean detailedExceptionMessage) {
		ExceptionHandler.detailedExceptionMessage = detailedExceptionMessage;
	}

	public static boolean isDetailedExceptionMessage() {
		return detailedExceptionMessage;
	}

	public void setMailer(Mailer mailer) {
		ExceptionHandler.mailer = mailer;
	}

	public static Mailer getMailer() {
		return mailer;
	}

	public void setClientShortName(String clientShortName) {
		ExceptionHandler.clientShortName = clientShortName;
	}

	public static String getClientShortName() {
		return clientShortName;
	}

	public static String handleException(Exception e, GIISUser USER) {
		String errorTypeMessage = null;
		if(e instanceof SQLException) {
			errorTypeMessage = "Sql";
		} else if (e instanceof NullPointerException){
			errorTypeMessage = "Null Pointer";
		} else if (e instanceof JSONException) {
			errorTypeMessage = "Json";
		} else if (e instanceof ParseException) {
			errorTypeMessage = "Parse";
		} else if (e instanceof NumberFormatException) {
			errorTypeMessage = "Number Format";
		} else if (e instanceof ArithmeticException) {
			errorTypeMessage = "Arithmetic";
		} else {
			errorTypeMessage = "";;
		}
		
		if(USER != null) {
			logException(e, USER.getUserId());
		} else {
			logException(e);
		}
		String message = null;
		String trace = null;
		StringBuilder detailedMessage = new StringBuilder("UNHANDLED EXCEPTION<br>");
		
		if(e.getMessage() != null && e.getMessage().toUpperCase().contains("THE RPC SERVER IS UNAVAILABLE")) {
			detailedMessage.append("The RPC server is unavailable. Possible causes:<br><ul><li>Errors resolving a DNS or NetBIOS name.</li><li>The RPC service or related services may not be running.</li><li>Problems with network connectivity.</li><li>File and printer sharing is not enabled.</li></ul><br/>Please contact your administrator.");
		} else if(e instanceof ReportNotFoundException){
			detailedMessage.append(e.getMessage());
		} else {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar cal = Calendar.getInstance();
			trace = sdf.format(cal.getTime());
			detailedMessage.append(errorTypeMessage);
			detailedMessage.append(" Exception occurred.<br><br>");
			detailedMessage.append("Trace: ");
			detailedMessage.append(trace);
			detailedMessage.append("<br>");
			detailedMessage.append("Error Message: ");
			detailedMessage.append(e.getMessage());
			detailedMessage.append("<br>");
			detailedMessage.append("Cause: ");
			detailedMessage.append(e.getCause());
		}
		
		message = "An exception occurred while processing the request. This may be caused by missing or invalid procedure."+ (isAutoBugReport() ? " A bug report has been automatically sent to the support team to address this problem." : "");
		
		return ((ContextParameters.ENABLE_DETAILED_EXCEPTION_MESSAGE != null && ContextParameters.ENABLE_DETAILED_EXCEPTION_MESSAGE.equals("Y")) || (USER.getMisSw() != null && USER.getMisSw().equals("Y")) ? detailedMessage.toString() : message);
	}

	//belle 11.21.2012
	public static String handleException(Exception e) {
		String errorTypeMessage = null;
		if(e instanceof SQLException) {
			errorTypeMessage = "Sql";
		} else if (e instanceof NullPointerException){
			errorTypeMessage = "Null Pointer";
		} else if (e instanceof JSONException) {
			errorTypeMessage = "Json";
		} else if (e instanceof ParseException) {
			errorTypeMessage = "Parse";
		} else if (e instanceof NumberFormatException) {
			errorTypeMessage = "Number Format";
		} else {
			errorTypeMessage = "";
		}
		
		logException(e);
		String trace = null;
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		trace = sdf.format(cal.getTime());
		StringBuilder detailedMessage = new StringBuilder(errorTypeMessage);
		detailedMessage.append(" Exception occurred.<br><br>");
		detailedMessage.append("Trace: ");
		detailedMessage.append(trace);
		detailedMessage.append("<br>");
		detailedMessage.append("Error Message: ");
		detailedMessage.append(e.getMessage());
		detailedMessage.append("<br>");
		detailedMessage.append("Cause: ");
		detailedMessage.append(e.getCause());
		
		return detailedMessage.toString();
	}
	
	public static void logException(Exception e) {		
		e.printStackTrace();
		long heapSpace = Runtime.getRuntime().totalMemory();
		logger.error(newLine + "HEAP: " + heapSpace + newLine + "ERROR MESSAGE: " + e.getMessage() + newLine + "CAUSE: " + e.getCause());
	}
	
	public static void logException(Exception e, String userId) {		
		e.printStackTrace();
		long heapSpace = Runtime.getRuntime().totalMemory();
		logger.error(newLine+ "USER: " + userId + newLine + "HEAP: " + heapSpace + newLine + "ERROR MESSAGE: " + e.getMessage() + newLine + "CAUSE: " + e.getCause());
	}
	
	public static String handleJavascriptException(String functionName, String description, GIISUser USER){
		String trace = null;

		logger.error(newLine + "\tA javascript error occurred." + newLine + "\tUSER: " + USER.getUserId() + newLine + "\tOCCURED AT: "+functionName + newLine + "\tERROR MESSAGE: "+description);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		trace = sdf.format(cal.getTime());		
		StringBuilder detailedMessage = new StringBuilder("A javascript exception occurred.<br><br>");
		detailedMessage.append("Trace: ");
		detailedMessage.append(trace);
		detailedMessage.append("<br>");
		detailedMessage.append("Occured At: ");
		detailedMessage.append(functionName);
		detailedMessage.append("<br>");
		detailedMessage.append("Description: ");
		detailedMessage.append(description);
		
		String jsErrorMessage = "An exception occurred in the module page."+ (isAutoBugReport() ? " A bug report has been automatically sent to the support team to address this problem." : "");

		return ((ContextParameters.ENABLE_DETAILED_EXCEPTION_MESSAGE != null && ContextParameters.ENABLE_DETAILED_EXCEPTION_MESSAGE.equals("Y")) || (USER.getMisSw() != null && USER.getMisSw().equals("Y")) ? detailedMessage.toString() : jsErrorMessage);
	}
	
	public static String extractSqlExceptionMessage(SQLException e){
		String message = null;
		if (e == null || (e.getCause() == null && e.getMessage() == null)) {
			message = "Geniisys Exception#E#Something went wrong but we are not able to retrieve the details of the problem. Kindly report this to your system provider.";
		} else {
			if(e.getCause() != null){
				String cause = e.getCause().toString();
				String[] causeLines = cause.split("ORA");
				message = "ORA"+causeLines[1];
			} else if(e.getMessage() != null){
				String cause = e.getMessage();
				String[] causeLines = cause.split("ORA");
				message = "ORA"+causeLines[1];
			}
		}
		return message;
	}
}
