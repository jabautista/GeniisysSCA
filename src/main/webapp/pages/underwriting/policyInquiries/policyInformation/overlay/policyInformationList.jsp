<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div id="polInfoDiv" name="polInfoDiv" class="sectionDiv" style="margin-right: 10px; margin-left: 3px; margin-top: 3px; margin-bottom: 3px; width: 99%;">
	<div id="polInfoListDiv" name="polInfoListDiv" style="margin: 10px;">
		<div id="searchResultPolInfo" align="center">
			<div style="width: 100%;" id="policiesTable" name="policiesTable">
				<div class="tableHeader">
					<label style="width: 26%; text-align: left;">Policy No.</label>
					<label style="width: 26%; text-align: left;">PAR No.</label>
					<label style="width: 48%; text-align: left;">Assured Name</label>
				</div>
				<div id="rowPolDiv" name="rowPolDiv" class="tableContainer">
				</div>
			</div>
		</div>
	</div>
</div>

<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>

<div id="buttonContainerDiv" style="" align="center">
	<input style="width: 70px;" type="button" class="button" id="btnOK" name="btnOK" value="OK" />
	<input style="width: 70px;" type="button" class="button" id="btnCancelPolicyInfoList" name="btnCancelPolicyInfoList" value="Cancel" />
	<br/><br/>
</div>

<script type="text/javaScript">
	
	var objPolBasicList = JSON.parse('${polBasicList}'/*.replace(/\\/g, '\\\\')*/);
	
	setPolBasicList();
	function setPolBasicList(){
		for (var i=0; i<objPolBasicList.length; i++){
			addObjToPolBasicTable(objPolBasicList[i]);
		}
	}
	
	function addObjToPolBasicTable(obj){
		var policyId		= obj.policyId;
		var lineCd 			= obj.lineCd;
		var subLineCd 		= obj.subLineCd;
		var issCd			= obj.issCd;
		var issueYy			= parseInt(obj.issueYy).toPaddedString(2);
		var polSeqNo		= parseInt(obj.polSeqNo).toPaddedString(6);
		var renewNo			= parseInt(obj.renewNo).toPaddedString(2);
		var refPolNo		= obj.refPolNo;
		var nbtLineCd		= obj.nbtLineCd;
		var nbtIssCd		= obj.nbtIssCd;
		var parYy			= parseInt(obj.parYy).toPaddedString(2);
		var parSeqNo		= parseInt(obj.parSeqNo).toPaddedString(6);
		var quoteSeqNo		= parseInt(obj.quoteSeqNo).toPaddedString(2);
		var assdName		= obj.assdName;
		var policyNo 		= obj.lineCd+"-"+obj.sublineCd+"-"+obj.issCd+"-"
								+parseInt(obj.issueYy).toPaddedString(2)+"-"
								+parseInt(obj.polSeqNo).toPaddedString(6)+"-"
								+parseInt(obj.renewNo).toPaddedString(2);
		var parNo			= obj.lineCd+"-"+obj.issCd+"-"
								+parseInt(obj.parYy).toPaddedString(2)+"-"
								+parseInt(obj.parSeqNo).toPaddedString(6)+"-"
								+parseInt(obj.quoteSeqNo).toPaddedString(2);
		var labelContent = "<label style='width: 26%; text-align:left;'>"+policyNo+"</label>"
			+"<label style='width: 26%; text-align:left;'>"+parNo+"</label>"
			+"<label style='width: 48%; text-align:left;'>"+assdName.truncate(50, '...')+"</label>";
		var newDiv = new Element("div");

		newDiv.setAttribute("id", "rowPolInfo"+policyId);
		newDiv.setAttribute("name", "rowPolInfo");
		newDiv.setAttribute("policyId", policyId);
		newDiv.addClassName("tableRow");

		newDiv.update(labelContent);
		$("rowPolDiv").insert({bottom: newDiv});
		
		initializePolicyRow(newDiv);
		
		Effect.Appear("rowPolInfo"+policyId, {
			duration: .2,
			afterFinish: function () {
				
			}
		});
	}

	
	if ($("page") != undefined){
		$("page").observe("change", function(){
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getPolicyInformationOtherPage",{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters:{
					pageNo		:$F("page"),
					lineCd		:$F("txtLineCd"),
					sublineCd	:$F("txtSublineCd"),
					issCd		:$F("txtIssCd"),
					issueYy		:$F("txtIssueYy"),
					polSeqNo	:$F("txtPolSeqNo"),
					renewNo		:$F("txtRenewNo"),
					refPolNo	:$F("txtRefPolNo")
				},	
				onCreate: showNotice("Getting Policy List..."),
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						objPolBasicList = null;
						objPolBasicList = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						$("rowPolDiv").innerHTML = "";
						for (var i=0; i<objPolBasicList.length; i++){
							addObjToPolBasicTable(objPolBasicList[i]);
						}
					}
					hideNotice("");
				}
			});
		});
	}

	function initializePolicyRow(row){
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
		
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});

		row.observe("click", function ()	{
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				$$("div[name='rowPolInfo']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
				});
			}
		});
	}

	$("btnOK").observe("click", function(){

		$$("div[name='rowPolInfo']").each(function(pol){
			if (pol.hasClassName("selectedRow")){
				for(var i=0; i<objPolBasicList.length; i++){
					if(pol.getAttribute("policyId") == objPolBasicList[i].policyId){
						if(objPolBasicList[i].packPolicyId != null){
							$("lblPackPol").setStyle('opacity: 1;');
							$("lblPackPolNo").setStyle('opacity: 1;');
						}else {
							$("lblPackPol").setStyle('opacity: 0;');
							$("lblPackPolNo").setStyle('opacity: 0;');
						}
						loadPolicy(objPolBasicList[i]);
						searchRelatedPolicies();
					}
				}
			}
		});
		hideOverlay();
		objGIPIS100.disableQueryFields();
		objGIPIS100.disableQueryButtons();
	});

	$("btnCancelPolicyInfoList").observe("click", function(){
		hideOverlay();
	});
</script>
