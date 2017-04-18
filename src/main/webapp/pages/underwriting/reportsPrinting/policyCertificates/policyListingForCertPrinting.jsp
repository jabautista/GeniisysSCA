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
	<label style="width: 25%; text-align: left; margin-left: 10px;">Policy No.</label>
	<label style="width: 20%; text-align: left; margin-left: 5px;">Endorsement No.</label>
	<label style="width: 20%; text-align: left; margin-left: 5px;">PAR No.</label>
	<label style="width: 20%; text-align: left; margin-left: 5px;">Assured Name</label>
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
							$("policyId").value		= objGIPIPolbasic[i].policyId;
							$("lineCd").value 		= objGIPIPolbasic[i].lineCd;
							$("menulineCd").value 	= objGIPIPolbasic[i].menulineCd;
							//$("sublineCd").value 	= objGIPIPolbasic[i].sublineCd;
							//$("renewNo").value 		= objGIPIPolbasic[i].renewNo;
							$$("input[name='capsField']").each(function(field){
								field.readOnly = true;
							});
							$$("input[name='intField']").each(function(field){
								field.readOnly = true;
							});
							$("searchForPolicy").stopObserving();
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
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=filterPolicyListingForCertPrinting",{
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
			if ((label.innerHTML).length > 30)    {
	            label.update((label.innerHTML).truncate(30, "..."));
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
		
		var labelContent = '<label name="polText" style="width: 25%; text-align: left; margin-left: 10px;">'+policyNo+'</label>'
			+'<label name="polText" style="width: 20%; text-align: left; margin-left: 5px;">'+nvl(endtNo, "---")+'</label>'
			+'<label name="polText" style="width: 20%; text-align: left; margin-left: 5px;">'+parNo+'</label>'
			+'<label name="polText" style="width: 30%; text-align: left; margin-left: 5px;">'+assdName+'</label>';

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