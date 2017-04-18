<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewMotorCarsMainDiv" name="viewMotorCarsMainDiv" style="">
	<div id="toolbarDiv" name="toolbarDiv">	
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnQuery">Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnQueryDisabled">Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnExitDisabled">Exit</span>
		</div>
	 </div>

	<div class="sectionDiv" style="margin-bottom:50px;">
		<div id="motorCarsTableDiv"  style="height:330px;width:900px;margin:10px auto 10px auto;"></div>
		
		<div style="text-align:center;margin:10px auto 10px auto">
			<input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information"/>
			<input type="button" class="button" id="btnAdditionalInfo" name="btnAdditionalInfo" value="Additional Motor Car Information"/>
			<input type="button" class="button" id="btnViewAttachment" name="btnViewAttachment" value="View Picture or Video"/>
		</div>
	</div>
	
</div>

<script>
	getMotorCarsTable();
	$("btnExit").observe("click", showViewPolicyInformationPage);
	
	disableButton("btnSummarizedInfo");
	disableButton("btnAdditionalInfo");
	disableButton("btnViewAttachment");

	function getMotorCarsTable(){
		new Ajax.Updater("motorCarsTableDiv","GIPIVehicleController?action=getMotorCarsTable",{
			method:"get",
			evalScripts: true
		});
	}



</script>