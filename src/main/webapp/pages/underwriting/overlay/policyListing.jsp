<!-- 
Remarks: For deletion
Date : 01-09-2012
Developer: andrew robes
Replacement : /pages/underwriting/overlay/policyTableGridListing.jsp
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br/><br/>
<div class="tableHeader" style="width: 100%;">
	<label style="width: 20%; text-align: center; margin-left: 10px;">Policy No.</label>
	<label style="width: 20%; text-align: left; margin-left: 5px;">Endorsement No.</label>
	<label style="width: 20%; text-align: left; margin-left: 5px;">PAR No.</label>
	<label style="width: 20%; text-align: left; margin-left: 5px;">Assured Name</label>
	<label style="text-align: left; margin-left: 5px;">Prem Seq No.</label>
</div>
<div id="polsDiv" name="polsDiv" class="tableContainer">
	
</div>
<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
<div id="buttonContainerDiv" style="" align="center">
	<input style="width: 70px;" type="button" class="button" id="btnOK" name="btnOK" value="OK" />
	<input style="width: 70px;" type="button" class="button" id="btnCancelPolicyListing" name="btnCancelPolicyListing" value="Cancel" />
	<br/><br/>
</div>

<script>
	var objGIPIPolbasic = JSON.parse('${polbasicListing}'.replace(/\\/g, '\\\\'));
	if (objGIPIPolbasic.length != 0){
		setPolicyList();
	} else {
		hideOverlay();
		showMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO);
	}
	$("pager").setStyle("margin-top: 10px;");
	if ($("pager").down("div", 0) != undefined){
		$("pager").down("div", 0).setStyle("margin-right:10px;");
	}
	
	$("btnOK").observe("click", function(){
		loadSelectedPol();
	});

	$$("div[name='rowPol']").each(function(row){
		row.observe("dblclick", function() {
			loadSelectedPol();
		});
	});

	function loadSelectedPol() {
		try {
			$$("div[name='rowPol']").each(function(pol){
				if (pol.hasClassName("selectedRow")){
					var policyId = pol.getAttribute("policyId");
					for (var i=0; i<objGIPIPolbasic.length; i++){
						if (policyId == objGIPIPolbasic[i].policyId){
							objCurrentPolicy 		= objGIPIPolbasic[i];
							$("txtLineCd").value 	= objGIPIPolbasic[i].lineCd;
							$("txtSublineCd").value = objGIPIPolbasic[i].sublineCd; 
							$("txtIssCd").value 	= objGIPIPolbasic[i].issCd;
							$("txtIssueYy").value 	= objGIPIPolbasic[i].issueYy.toPaddedString(2);
							$("txtPolSeqNo").value 	= objGIPIPolbasic[i].polSeqNo.toPaddedString(6);
							$("txtRenewNo").value 	= objGIPIPolbasic[i].renewNo;
							if (nvl(objGIPIPolbasic[i].endtSeqNo, "0") != "0"){
								$("txtCLineCd").value 		= objGIPIPolbasic[i].lineCd;
								$("txtCSublineCd").value 	= objGIPIPolbasic[i].sublineCd;
								$("txtCEndtIssCd").value 	= objGIPIPolbasic[i].endtIssCd;
								$("txtEndtYy").value 		= objGIPIPolbasic[i].endtYy;
								$("txtEndtSeqNo").value 	= objGIPIPolbasic[i].endtSeqNo;
							}
							$("assdName").value 	= objGIPIPolbasic[i].assdName;
							$("parNo").value 		= objGIPIPolbasic[i].parNo;
							$("txtPremSeqNo").value = (objGIPIPolbasic[i].premSeqNo != null) ? (objGIPIPolbasic[i].issCd + "-" + objGIPIPolbasic[i].premSeqNo.toPaddedString(8)) : "" ;
							$("policyId").value		= objGIPIPolbasic[i].policyId;
							$("policyLineCd").value = nvl(objGIPIPolbasic[i].menulineCd, objGIPIPolbasic[i].lineCd); //objGIPIPolbasic[i].lineCd; //replaced by jeffdojello 05.30.2013
							$("issCd").value 		= objGIPIPolbasic[i].issCd;
							$("sublineCd").value 	= objGIPIPolbasic[i].sublineCd;
							$("cocType").value 		= objGIPIPolbasic[i].cocType;
							$("endtTax").value 		= objGIPIPolbasic[i].endtTax;
							$("renewNo").value 		= objGIPIPolbasic[i].renewNo;
							$("packPolFlag").value 	= objGIPIPolbasic[i].packPolFlag; // added by: nica 04.18.2011 necessary for package printing
							$$("input[name='capsField']").each(function(field){
								field.readOnly = true;
							});
							$$("input[name='intField']").each(function(field){
								field.readOnly = true;
							});
							$("searchForPolicy").stopObserving();
							new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getOtherPolicyDetails&policyId="+objGIPIPolbasic[i].policyId, {
								method : "POST",
								asynchronous : false,
								evalScripts : true,
								onComplete : function(response){
									if (checkErrorOnResponse(response)) {
										var a = response.responseText.split(",");
										$("compulsoryDeath").value 	= a[0];
										$("itmperilCount").value 	= a[1];
										if (a[2]=="Y"){
											showMessageBox("Total Amount Due is 0, bill will not be printed.", imgMessage.INFO);
											$("docType").childElements().each(function (o) {
												if (o.value == "BILL"){
													o.hide();
												}
											});
										}
									}
								}
							});
							
							//var lineCd = objGIPIPolbasic[i].lineCd == "PA" ? "AC" : objGIPIPolbasic[i].lineCd; replaced by: nica 04.19.2011 - to handle all lines
							var lineCd = nvl(objGIPIPolbasic[i].menulineCd, objGIPIPolbasic[i].lineCd);
							new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getReportsListingForPolicy&lineCd="+lineCd, {
								method : "POST",
								asynchronous : false,
								evalScripts : true,
								onComplete : function(response){
									if (checkErrorOnResponse(response)) {
										var objReports = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
										for (var i=0; i<objReports.length; i++){
											var newDiv 		= new Element("div");
											var reportId	= objReports[i].reportId;
											var reportTitle	= objReports[i].reportTitle;
											newDiv.setAttribute("id", "row"+reportId);
											newDiv.setAttribute("name", "report");
											newDiv.addClassName("tableRow");
											newDiv.setAttribute("reportId", reportId);
											newDiv.setAttribute("reportTitle", reportTitle);
											newDiv.setStyle("display: none;");
											$("reportsDiv").insert({bottom: newDiv});
										}
									}
								}
							});
							manageDocTypes();
							hideOverlay();
							
							return false;
						}
					}
				}
			});
		} catch(e) {
			showErrorMessage("loadSelectedPol", e);
		}
	}

	$("btnCancelPolicyListing").observe("click", function(){
		hideOverlay();
	});

	if ($("page") != undefined){
		$("page").observe("change", function(){
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=filterPolicyListing",{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					pageNo		:$F("page"),
					lineCd		:$F("txtLineCd"),
					sublineCd	:$F("txtSublineCd"),
					issCd		:$F("txtIssCd"),
					issueYy		:$F("txtIssueYy"),
					polSeqNo	:$F("txtPolSeqNo"),
					renewNo		:$F("txtRenewNo"),
					lineCd2		:$F("txtCLineCd"),
					sublineCd2	:$F("txtCSublineCd"),
					endtIssCd	:$F("txtCEndtIssCd"),
					endtYy		:$F("txtEndtYy"),
					endtSeqNo	:$F("txtEndtSeqNo"),
					assdName	:$F("assdName") 
				},
				onCreate: showNotice("Getting policy listing..."),
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						var objPolicyList = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						objGIPIPolbasic = objPolicyList;
						$("polsDiv").innerHTML = "";
						for (var i=0; i<objPolicyList.length; i++){
							addObjToPolTable(objPolicyList[i]);
						}
					}
					hideNotice("");
				}
			});
		});
	}

	function trimPolText(){
		$$("label[name='polText']").each(function (label)	{
			if ((label.innerHTML).length > 22)    {
	            label.update((label.innerHTML).truncate(22, "..."));
	        }
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
				$$("div[name='rowPol']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
				});
			}
		});
	}

	function setPolicyList(){
		for (var i=0; i<objGIPIPolbasic.length; i++){
			addObjToPolTable(objGIPIPolbasic[i]);
		}
	}

	function addObjToPolTable(obj){
		var policyId 	= obj.policyId;
		var issCd		= obj.issCd;
		var premSeqNo	= obj.premSeqNo;
		var policyNo 	= obj.lineCd+"-"+obj.sublineCd+"-"+obj.issCd+"-"
							+(obj.issueYy).toPaddedString(2)+"-"
							+(obj.polSeqNo).toPaddedString(6)+"-"+obj.renewNo;
		var endtNo 		= "";
		var parNo 		= obj.parNo;
		var assdName 	= obj.assdName;
		if ("0" == nvl(obj.endtSeqNo, "0")){
			endtNo = "";
		} else {
			endtNo = obj.lineCd+"-"+obj.sublineCd+"-"+obj.endtIssCd+"-"
						+(obj.endtYy).toPaddedString(2)+"-"
						+(obj.endtSeqNo).toPaddedString(6);
		}
		var labelContent = '<label name="polText" style="width: 20%; text-align: left; margin-left: 10px;">'+policyNo+'</label>'
			+'<label name="polText" style="width: 20%; text-align: left; margin-left: 5px;">'+nvl(endtNo, "---")+'</label>'
			+'<label name="polText" style="width: 20%; text-align: left; margin-left: 5px;">'+parNo+'</label>'
			+'<label name="polText" style="width: 20%; text-align: left; margin-left: 5px;">'+assdName+'</label>'
			+'<label name="polText" style="text-align: left; margin-left: 8px;">'+((premSeqNo != null) ? (issCd + "-" + premSeqNo.toPaddedString(8)) : "---") +'</label>';

		var newDiv = new Element("div");
		newDiv.setAttribute("id", "rowPol"+policyId);
		newDiv.setAttribute("name", "rowPol");
		newDiv.setAttribute("policyId", policyId);
		newDiv.addClassName("tableRow");
		newDiv.update(labelContent);
		$("polsDiv").insert({bottom: newDiv});
		initializePolicyRow(newDiv);
		trimPolText();
		Effect.Appear("rowPol"+policyId, {
			duration: .2,
			afterFinish: function () {
				
			}
		});
	}

</script>