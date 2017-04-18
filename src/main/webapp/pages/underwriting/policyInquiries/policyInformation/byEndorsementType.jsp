<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewByEndorsementTypeMainDiv" name="viewByEndorsementTypeMainDiv" style="">

	<div id="regeneratePolicyDocumentsMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parEndtExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="sectionDiv">
		<%-- <div style="margin:10px 5px 5px auto;">
			<div style="width:98%;margin-left:2%;">
				Endorsement Type:
				<input type="text" id="txtAssdNo" name="txtAssdNo" style="width:50px;" readonly="readonly"/>
				<input type="text" id="txtAssdName" name="txtAssdName" style="width:670px;" readonly="readonly"/>
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForEndorsementType" name="searchForEndorsementType" alt="Go" style="margin-top: 2px;" title="Search Endorsement"/>
			</div>
		</div> --%> 
		
		<div id="policyByEndorsementTypeDiv" class="sectionDiv" style="border: none; height:466px; width:856px; padding: 10px;"></div>
		
		<div style="text-align:center; margin:10px auto 40px auto">
			<!-- <input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information"/> -->
			<input type="button" class="button" id="btnPolEndtDetails" name="btnPolEndtDetails" value="Policy/Endorsement Details"/>
			<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 120px;"/>
		</div>
	</div>
	<input type="hidden" id="hidEndtTypePolId" />
</div>

<script>
try{
	getPolicyByEndorsementTypeTable();
	$("parEndtExit").observe("click", function(){
		objGIPIS100.endtType = "N";
		showViewPolicyInformationPage();
	});
	
	 /* $("searchForEndorsementType").observe("click", function(){
		overlayEndorsementTypeList = Overlay.show(contextPath+"/GIPIPolbasicController", {
			urlContent: true,
			urlParameters: {action : "showPolicyEndorsementTypeOverLay"},
			title: "Endorsement Type",
			width: 416,
			height: 400,
			draggable: false
		});
	}); */ 
	
	disableButton("btnPolEndtDetails");

	$("btnPolEndtDetails").observe("click", function(){
		var policyId = $("hidEndtTypePolId").value;
		//showViewPolicyInformationPage(policyId);
		showPolicyMainInfoPage(policyId);
		$("polMainInfoDiv").show();
		$("endtTypeDiv").hide();
	});
	
	$("btnPrint").observe("click", function(){
		showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
	});
	
	disableButton("btnPrint");
}catch(e){
	showErrorMessage("byEndorsementType.jsp", e);
}
	
</script>