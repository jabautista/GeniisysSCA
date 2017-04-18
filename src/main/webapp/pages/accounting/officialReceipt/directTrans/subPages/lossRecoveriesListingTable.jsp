<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div style="margin:10px; margin-top:5px; margin-bottom:0px; padding-top:1px;" id="directTransLossRecoveriesTable" name="directTransLossRecoveriesTable">
	<div class="tableHeader" style="margin-top: 5px;">
		<label style="text-align: left; width: 4%; text-indent: 5px;"><div title="Automatic Generation of Accounting Entries">A</div></label>
		<label style="text-align: left; width: 19%; margin-right: 3px;">Transaction Type</label>
		<label style="text-align: left; width: 19%; margin-right: 3px;">Recovery No.</label>
		<label style="text-align: left; width: 20%; margin-right: 3px;">Payee Class</label>
		<label style="text-align: left; width: 20%; margin-right: 3px;">Payee</label>
		<label style="text-align: right; width: 16%;">Recovered Amount</label>
	</div>	
	<div class="tableContainer" id="directTransLossRecoveriesListing" name="directTransLossRecoveriesListing" style="display: block;">
	</div>
</div>
<div id="lossRecoveriesTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
	<div id="lossRecoveriesTotalAmtDiv" style="width:100%;">
		<label style="text-align:left; width:39%; margin-right: 2px;">Total:</label>
		<label style="text-align:right; width:60%; " class="money">&nbsp;</label>
	</div>
</div>