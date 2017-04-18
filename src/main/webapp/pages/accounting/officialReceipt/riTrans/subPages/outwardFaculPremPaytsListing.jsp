<!--
Remarks: For deletion
Date : 05-16-2012
Developer: S. Ramirez
Replacement : /pages/accounting/officialReceipt/riTrans/outwardFaculPremPaytsTableGrid.jsp
--> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="outwardFaculPremPaytsTableMainDiv" name="outwardFaculPremPaytsTableMainDiv" style="width: 921px;" changeTagAttr="true">
	<div id="outwardFaculPremPaytsList" style="margin: 10px;" align="center">
		<div style="width: 81%; text-align: center;" id="outwardFaculPremPaytsTable" name="outwardFaculPremPaytsTable">
			<div class="tableHeader">
				<label style="width: 120px;font-size: 10px; text-align: center; margin-left: 50px; ">Transaction Type</label>
				<label style="width: 60px;font-size: 10px; text-align: center; margin-left: 20px; ">Reinsurer</label>		
				<label style="width: 60px;font-size: 10px; text-align: center; margin-left: 170px; ">Binder No.</label>	
				<label style="width: 60px;font-size: 10px; text-align: center; margin-left: 135px; ">Amount</label>	
			</div>
			
			<div class="tableContainer" id="outwardFaculPremPaytsTableContainer" name="tableContainer" style="display: block">
				
			</div>
		</div>
	</div>
</div>

<script>
	checkTableIfEmpty("outFaculPremPayts", "outwardFaculPremPaytsTable");
</script>