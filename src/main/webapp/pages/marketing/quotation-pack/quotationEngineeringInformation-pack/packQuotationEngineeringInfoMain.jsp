<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packQuoteENInfoMainDiv" name="packQuoteENInfoMainDiv">
	<form id="packQuoteENInfoForm" name="packQuoteENInfoForm">
		<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationInfoHeader.jsp"></jsp:include>		
		<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationSubQuotesTable.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Additional Engineering Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
			
		<div id="packQuoteENInfoFormDiv" name="packQuoteENInfoFormDiv" class="sectionDiv" align="center" changeTagAttr="true" >
			<jsp:include page="/pages/marketing/quotation-pack/quotationEngineeringInformation-pack/quotationEngineeringInfo.jsp"></jsp:include>
		</div>
		
		<div class="buttonsDiv" id="addENInfoButtonsDiv">
			<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Package Quotation" />
			<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>

<script type="text/javascript">
	objQuoteENDetailList = new Array();
	objQuotePrincipalList = new Array();
	setModuleId("GIIMM010");
	setENInfoPageAccordingToSubline("");
	hideNotice();
	objCurrPackQuote = null;
	changeTag = 0;
	var enInfoTag = 0;
	
	objPackQuoteList = JSON.parse('${objPackQuoteList}'.replace(/\\/g, '\\\\'));
	objQuoteENDetailList = JSON.parse('${objQuoteENDetailList}'.replace(/\\/g, '\\\\'));
	var objENSublineParams = JSON.parse('${objENSublineParams}'.replace(/\\/g, '\\\\'));
	
	function setQuoteListForENInfoRowObserver(row){
		try{
			row.observe("click", function(){
				if(enInfoTag == 1){
					showMessageBox("Press the Update button first to apply all changes.");
					return false;
				}
				
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){												
					($$("div#packQuotationTableDiv div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
					for(var i=0; i<objPackQuoteList.length; i++){
						if(objPackQuoteList[i].quoteId == row.getAttribute("quoteId")){
							objCurrPackQuote = objPackQuoteList[i];
							populateENInfoDtls(objPackQuoteList[i]);
							var subline = pluckENParamSublineParam(objPackQuoteList[i].sublineCd);
							setENInfoPageAccordingToSubline(subline);
							showPrincipalListForPackQuote(objPackQuoteList[i].quoteId);
						}
					}
					
				}else{
					objCurrPackQuote = null;
					populateENInfoDtls(null);
					setENInfoPageAccordingToSubline("");
				}
			});
		}catch(e){
			showErrorMessage("setQuoteListForENInfoRowObserver", e);
		}
	}

	function populateENInfoDtls(obj){
		$("enSublineName").value 	= obj == null ? "": unescapeHTML2(obj.sublineName);
		$("enInceptDate").value 	= obj == null ? "" : obj.inceptDate == null ? "" : dateFormat(obj.inceptDate, "mm-dd-yyyy");
		$("enExpiryDate").value 	= obj == null ? "" : obj.expiryDate == null ? "" : dateFormat(obj.expiryDate, "mm-dd-yyyy");
		(obj == null ? disableButton($("btnUpdateENInfo")) : enableButton($("btnUpdateENInfo")));
		(obj == null ? disableButton($("btnDeleteENInfo")) : enableButton($("btnDeleteENInfo")));

		if(obj != null){
			var objEN = pluckQuoteENDetails(obj.quoteId);
			$("enggBasicInfoNum").value = objEN == null ? "" : objEN.enggBasicInfoNum;
			$("enProjectName").value    = objEN == null ? "" : unescapeHTML2(objEN.contractProjBussTitle);
			$("enSiteLoc").value 	 	= objEN == null ? "" : unescapeHTML2(objEN.siteLocation);
			$("constructFrom").value 	= objEN == null ? "" : (objEN.constructStartDate == null ? "" : dateFormat(objEN.constructStartDate, "mm-dd-yyyy"));
			$("constructTo").value 	 	= objEN == null ? "" : (objEN.constructEndDate == null ? "" : dateFormat(objEN.constructEndDate, "mm-dd-yyyy"));
			$("mainFrom").value      	= objEN == null ? "" : (objEN.maintainStartDate == null ? "" : dateFormat(objEN.maintainStartDate, "mm-dd-yyyy"));
			$("mainTo").value        	= objEN == null ? "" : (objEN.maintainEndDate == null ? "" : dateFormat(objEN.maintainEndDate, "mm-dd-yyyy"));
			$("timeExcess").value 	 	= objEN == null ? "" : formatNumber(parseFloat(objEN.timeExcess));
			$("weeksTesting").value  	= objEN == null ? "" : formatNumber(parseFloat(objEN.weeksTest));
			$("mbiPolNo").value 	 	= objEN == null ? "" : unescapeHTML2(objEN.mbiPolicyNo);
			$("testStartDate").value 	= objEN == null ? "" : unescapeHTML2(objEN.testingStartDate);
			$("testEndDate").value   	= objEN == null ? "" : unescapeHTML2(objEN.testingEndDate);
		}else{
			$("enggBasicInfoNum").value = "";
			$("enProjectName").value 	= "";
			$("enSiteLoc").value 	 	= "";
			$("mainFrom").value 	 	= "";
			$("mainTo").value 	 	 	= "";
			$("constructFrom").value 	= "";
			$("constructTo").value 	 	= "";
			$("timeExcess").value 	 	= "";
			$("weeksTesting").value  	= "";
			$("mbiPolNo").value 	 	= "";
			$("testStartDate").value 	= "";
			$("testEndDate").value   	= "";
		}
	}

	function makeQuoteENDetailsObject(){
		var quoteEN = new Object();
		quoteEN.quoteId = objCurrPackQuote.quoteId;
		quoteEN.enggBasicInfoNum 	  = nvl($("enggBasicInfoNum").value, 1);
		quoteEN.contractProjBussTitle = escapeHTML2($("enProjectName").value);
		quoteEN.siteLocation 		  = escapeHTML2($("enSiteLoc").value);
		quoteEN.maintainStartDate 	  = escapeHTML2($("mainFrom").value);
		quoteEN.maintainEndDate 	  = escapeHTML2($("mainTo").value);
		quoteEN.constructStartDate 	  = escapeHTML2($("constructFrom").value);
		quoteEN.constructEndDate 	  = escapeHTML2($("constructTo").value);
		quoteEN.weeksTest 			  = escapeHTML2($("weeksTesting").value);
		quoteEN.timeExcess 			  = escapeHTML2($("timeExcess").value);
		quoteEN.mbiPolicyNo 		  = escapeHTML2($("mbiPolNo").value);
		quoteEN.testingStartDate	  = escapeHTML2($("testStartDate").value);
		quoteEN.testingEndDate	  	  = escapeHTML2($("testEndDate").value);
		return quoteEN;
	}

	function showPrincipalListForPackQuote(quoteId){
		if($("enPrincipalsDivP") != null){
			($$("div#enPrincipalsDivP div[name='princRowP']")).invoke("show");
			($$("div#enPrincipalTableP div:not([quoteId='" +quoteId+ "'])")).invoke("hide");
			resizeTableBasedOnVisibleRows("enPrincipalsDivP", "enPrincipalTableP");
		}
		if($("enPrincipalsDivC") != null){
			($$("div#enPrincipalsDivC div[name='princRowC']")).invoke("show");
			($$("div#enPrincipalTableC div:not([quoteId='" +quoteId+ "'])")).invoke("hide");
			resizeTableBasedOnVisibleRows("enPrincipalsDivC", "enPrincipalTableC");
		}
	}

	function pluckQuoteENDetails(quoteId){
		var objEnDtls = null;
		for(var i=0; i<objQuoteENDetailList.length; i++){
			if(objQuoteENDetailList[i].quoteId == quoteId &&
			   objQuoteENDetailList[i].recordStatus != -1){
				objEnDtls = objQuoteENDetailList[i];
				break;
			}
		}
		return objEnDtls;
	}

	function pluckENParamSublineParam(sublineCd){
		var paramName = null;
		for(var i=0; i<objENSublineParams.length; i++){
			if(objENSublineParams[i].paramValueV == sublineCd){
				paramName = objENSublineParams[i].paramName;
				break;
			}
		}
		return paramName;
	}

	$$("div[name='quoteRow']").each(function(row){
		setQuoteListForENInfoRowObserver(row);
	});

	$$("div.quoteENInfo").each(function(rec){
		rec.descendants().each(function (obj) {
			if (obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA" || obj.nodeName == "SELECT") {
				obj.observe("focus", function (event) {
					checkIfNoPackQuoteIsSelected();		
				});
				obj.observe("change", function (event) {
					enInfoTag = 1;		
				});
			}
		});
	});

	$("btnUpdateENInfo").observe("click", function(){
		var quoteEN = makeQuoteENDetailsObject();
		quoteEN.recordStatus = 1;
		changeTag = 1;
		enInfoTag = 0;
		for(var i=0; i<objQuoteENDetailList.length; i++){
			if(objQuoteENDetailList[i].quoteId == quoteEN.quoteId){
				objQuoteENDetailList.splice(i, 1);
				break;
			}
		}
		objQuoteENDetailList.push(quoteEN);
		($$("div#packQuotationTableDiv div[name='quoteRow']")).invoke("removeClassName", "selectedRow");
		populateENInfoDtls(null);
		setENInfoPageAccordingToSubline("");
	});

	$("btnDeleteENInfo").observe("click", function(){
		for(var i=0; i<objQuoteENDetailList.length; i++){
			if(objQuoteENDetailList[i].quoteId == objCurrPackQuote.quoteId){
				objQuoteENDetailList[i].recordStatus = -1;
				break;
			}
		}
		($$("div#packQuotationTableDiv div[name='quoteRow']")).invoke("removeClassName", "selectedRow");
		populateENInfoDtls(null);
		setENInfoPageAccordingToSubline("");
	});

	observeReloadForm($("reloadForm"),  showPackQuoteENInfoPage);

	$("btnEditQuotation").observe("click", function(){
		function goToBasicQuotationInfo(){
			editPackQuotation(objMKGlobal.lineName, objMKGlobal.lineCd, objMKGlobal.packQuoteId);
		}
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", savePackQuoteENInfo, goToBasicQuotationInfo, "");
		}else{
			goToBasicQuotationInfo();
		}
	});

	$("btnSave").observe("click", function(){
		if(enInfoTag == 1){
			showMessageBox("Press the Update button first to apply all changes.");
			return false;
		}else if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES);
			return false;
		}else{
			savePackQuoteENInfo();
			enInfoTag = 0;
		}
	});

	populateENInfoDtls(null);
	initializeChangeTagBehavior(savePackQuoteENInfo);
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		showPackQuotationListing();
	});
</script>
