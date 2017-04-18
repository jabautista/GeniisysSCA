<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div style="margin:10px; margin-top:5px; margin-bottom:0px; padding-top:1px;" id="riTransLossesRecovTable" name="riTransLossesRecovTable">
	<div class="tableHeader" style="margin-top: 5px;">
		<label style="text-align: left; width: 18%; margin-right: 3px;">Transaction Type</label>
		<label style="text-align: left; width: 15%; margin-right: 3px;">Share Type</label>
		<label style="text-align: left; width: 18%; margin-right: 3px;">Reinsurer</label>
		<label style="text-align: left; width: 18%; margin-right: 3px;">Final Loss Advice No.</label>
		<label style="text-align: left; width: 9%; margin-right: 3px;">Payee Type</label>
		<label style="text-align: right; width: 20%;">Collection Amount</label>
	</div>	
	<div class="tableContainer" id="riTransLossesRecovListing" name="riTransLossesRecovListing" style="display: block;">
	</div>
</div>
<div id="lossesRecovTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
	<div id="lossesRecovTotalAmtDiv" style="width:100%;">
		<label style="text-align:left; width:39%; margin-right: 2px;">Total:</label>
		<label style="text-align:right; width:60%; float:right;" class="money">&nbsp;</label>
	</div>
</div>