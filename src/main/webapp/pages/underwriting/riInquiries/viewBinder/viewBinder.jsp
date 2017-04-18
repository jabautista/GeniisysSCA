<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewBinderMainDiv" name="viewBinderMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Binder</label>
		</div>
	</div>
	
	<div id="viewBinderHeaderDiv" class="sectionDiv" style="padding: 10px 0 10px 0;">
		<table style="margin-left: 45px;">
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Binder No.</td>
				<td><input id="lineCd" name="headerField" type="text" class="required upper" style="float: left; height: 13px; width: 75px;" maxlength="2" tabindex="101"/></td>
				<td><input id="binderYy" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 75px;" maxlength="2" tabindex="102"/></td>
				<td><input id="binderSeqNo" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 186px;" maxlength="5" tabindex="103"/></td>
				<td style="width: 20px; float: left;  margin: 2px 10px 0 0;"><img id="searchBinder" name="searchBinder" alt="Go" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/></td>
				
				<td class="rightAligned">Binder Date</td>
				<td colspan="2"><input id="binderDate" name="binderDate" type="text" style="float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="104"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Reinsurer</td>
				<td colspan="4"><input id="riSname" name="riSname" type="text" style="float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="105"/></td>
				
				<td class="rightAligned">Reversal Date</td>
				<td colspan="2"><input id="reverseDate" name="reverseDate" type="text" style="float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="106"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Policy No.</td>
				<td colspan="3">
					<div>
						<input id="polLineCd" name="headerField" type="text" class="required upper" style="float: left; height: 13px; width: 40px; margin-right: 4px;" maxlength="2" tabindex="107"/>
						<input id="sublineCd" name="headerField" type="text" class="upper" style="float: left; height: 13px; width: 70px; margin-right: 4px;" maxlength="7" tabindex="108"/>
						<input id="issCd" name="headerField" type="text" class="upper" style="float: left; height: 13px; width: 40px; margin-right: 4px;" maxlength="2" tabindex="109"/>
						<input id="issueYy" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 40px; margin-right: 4px;" maxlength="2" tabindex="110"/>
						<input id="polSeqNo" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 70px; margin-right: 4px;" maxlength="7" tabindex="111"/>
						<input id="renewNo" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 40px;" maxlength="2" tabindex="112"/>
					</div>
				</td>
				<td style="width: 20px; float: left;  margin: 2px 10px 0 0;"><img id="searchPolicy" name="searchPolicy" alt="Go" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/></td>
				<td class="rightAligned">FRPS No.</td>
				<td><input id="frpsYy" name="frpsYy" type="text" style="float: left; height: 13px; width: 62px;" readonly="readonly" tabindex="113"/></td>
				<td><input id="frpsSeqNo" name="frpsSeqNo" type="text" style="float: left; height: 13px; width: 130px;" readonly="readonly" tabindex="114"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Endt No.</td>
				<td><input id="endtIssCd" name="endtIssCd" type="text" style="float: left; height: 13px; width: 75px;" maxlength="2" readonly="readonly" tabindex="115"/></td>
				<td><input id="endtYy" name="endtYy" type="text" style="float: left; height: 13px; width: 75px;" maxlength="7" readonly="readonly" tabindex="116"/></td>
				<td colspan="2"><input id="endtSeqNo" name="endtSeqNo" type="text" style="float: left; height: 13px; width: 186px;" maxlength="7" readonly="readonly" tabindex="117"/></td>
				
				<td class="rightAligned">Currency</td>
				<td colspan="2"><input id="currencyDesc" name="currencyDesc" type="text" style="float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="118"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Assured</td>
				<td colspan="4"><input id="assdName" name="assdName" type="text" style="float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="119"/></td>
				
				<td class="rightAligned">Currency Rate</td>
				<td colspan="2"><input id="currencyRt" name="currencyRt" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="120"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Total TSI</td>
				<td colspan="4"><input id="tsiAmt" name="tsiAmt" type="text" style="text-align: right; float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="121"/></td>
				
				<td class="rightAligned">Total Premium</td>
				<td colspan="2"><input id="premAmt" name="premAmt" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="122"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">RI TSI Amt.</td>
				<td colspan="4"><input id="riTsiAmt" name="riTsiAmt" type="text" style="text-align: right; float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="123"/></td>
				
				<td class="rightAligned">RI Shr. %</td>
				<td colspan="2"><input id="riShrPct" name="riShrPct" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="124"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">RI Prem. Amt.</td>
				<td colspan="4"><input id="riPremAmt" name="riPremAmt" type="text" style="text-align: right; float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="125"/></td>
				
				<td class="rightAligned">RI Comm. Amt.</td>
				<td colspan="2"><input id="riCommAmt" name="riCommAmt" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="126"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">RI Prem. VAT</td>
				<td colspan="4"><input id="riPremVat" name="riPremVat" type="text" style="text-align: right; float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="127"/></td>
				
				<td class="rightAligned">RI Comm VAT</td>
				<td colspan="2"><input id="riCommVat" name="riCommVat" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="128"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Prem. Tax</td>
				<td colspan="4"><input id="premTax" name="premTax" type="text" style="text-align: right; float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="129"/></td>
				
				<td class="rightAligned" style="padding-left: 10px;">RI W/holding VAT</td>
				<td colspan="2"><input id="riWholdingVat" name="riWholdingVat" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="130"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Net Due RI</td>
				<td colspan="4"><input id="netDueRi" name="netDueRi" type="text" style="text-align: right; float: left; height: 13px; width: 360px;" readonly="readonly" tabindex="131"/></td>
				
				<td class="rightAligned">RI Comm. Rate</td>
				<td colspan="2"><input id="riCommRt" name="riCommRt" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="132"/></td>
			</tr>
		</table>
		
		<div style="display: none;">
			<input id="hidFnlBinderId" name="hidFnlBinderId" type="hidden">
			<input id="hidRemarks" name="hidRemarks" type="hidden">
			<input id="hidBndrRemarks1" name="hidBndrRemarks1" type="hidden">
			<input id="hidBndrRemarks2" name="hidBndrRemarks2" type="hidden">
			<input id="hidBndrRemarks3" name="hidBndrRemarks3" type="hidden">
			<input id="hidRiAcceptBy" name="hidRiAcceptBy" type="hidden">
			<input id="hidRiAsNo" name="hidRiAsNo" type="hidden">
			<input id="hidRiAcceptDate" name="hidRiAcceptDate" type="hidden">
		</div>
		
		<div id="buttonDiv" align="center">
			<input id="btnViewInfo" name="btnViewInfo" value="Additional Information" style="width: 165px; margin: 10px 0 4px 0;" type="button" class="disabledButton">
		</div>
	</div>
	
	<div id="binderPerilDiv" class="sectionDiv" style="height: 354px; margin-bottom: 25px;">
		<div id="binderPerilTGDiv" name="binderPerilTGDiv" style="height: 322px; margin: 12px 0 40px 11px;"></div>
	</div>
</div>

<script type="text/javascript">
	try{
		binderPerilModel = {
			url: contextPath+"/GIRIBinderController?action=showViewBinder",
			options: {
	          	height: '306px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		binderPerilTG.keys.removeFocus(binderPerilTG.keys._nCurrentFocus, true);
	            	binderPerilTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	binderPerilTG.keys.removeFocus(binderPerilTG.keys._nCurrentFocus, true);
	            	binderPerilTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	binderPerilTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN], //Daniel Marasigan SR 5491, added filter btn
	            	onRefresh: function(){
	            		binderPerilTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		binderPerilTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[ //Daniel Marasigan SR 5491; added filterOption to tblgrid 
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'perilName',
							title: 'Peril',
							width: '313px',
							filterOption: true
						},
						{	id: 'riShrPct',
							title: 'RI % Share',
							width: '120px',
							align: 'right',
							geniisysClass: 'rate',
							filterOption: true,
							filterOptionType : 'percentType'
						},
						{	id: 'riTsiAmt',
							title: 'RI TSI Amount',
							width: '150px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType : 'numberNoNegative'
						},
						{	id: 'riPremAmt',
							title: 'RI Premium Amount',
							width: '150px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType : 'numberNoNegative'
						},
						{	id: 'riCommAmt',
							title: 'RI Comm. Amount',
							width: '150px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType : 'numberNoNegative'
						}
						],
			rows: []
		};
		binderPerilTG = new MyTableGrid(binderPerilModel);
		binderPerilTG.pager = [];
		binderPerilTG.render('binderPerilTGDiv');
		binderPerilTG.afterRender = function(){
			binderPerilTG.onRemoveRowFocus();
			
			if(typeof objGIRIS015 != "undefined"){
				if(nvl(objGIRIS015.query, "N") == "Y"){
					objGIRIS015.query = "N";
					queryOnLoad();
				}
			}
		};
	}catch(e){
		showMessageBox("Error in Binder Peril Table Grid: " + e, imgMessage.ERROR);
	}

	function newFormInstance(){
		$("lineCd").focus();
		initializeAll();
		makeInputFieldUpperCase();
		hideToolbarButton("btnToolbarPrint");
		setModuleId("GIRIS016");
		setDocumentTitle("View Binder");
	}
	
	function resetForm(){
		$$("input[type='text'], input[type='hidden']").each(function(i){
			i.value = "";
			if(i.name == "headerField"){
				enableInputField(i.id);
			}
		});
		
		enableSearch("searchBinder");
		enableSearch("searchPolicy");
		disableButton("btnViewInfo");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
	}
	
	function queryOnLoad(){
		$("lineCd").value = objGIRIS015.lineCd;
		$("binderYy").value = formatNumberDigits(objGIRIS015.binderYy, 2);
		$("binderSeqNo").value = formatNumberDigits(objGIRIS015.binderSeqNo, 5);
		$("hidFnlBinderId").value = objGIRIS015.fnlBinderId;
		
		getBinder();
		executeQuery();
		enableToolbarButton("btnToolbarEnterQuery");
	}
	
	function executeQuery(){
		binderPerilTG.url = contextPath +"/GIRIBinderController?action=showViewBinder&refresh=1&fnlBinderId="+$F("hidFnlBinderId");
		binderPerilTG._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function populateFields(row){
		$("binderYy").value = row.binderYy;
		$("binderSeqNo").value = formatNumberDigits(row.binderSeqNo, 5);
		$("riSname").value = row.riSname;
		$("lineCd").value = row.lineCd;
		$("polLineCd").value = unescapeHTML2(row.polLineCd);	//edited by gab 08.05.2015
		$("sublineCd").value = unescapeHTML2(row.sublineCd);	//edited by gab 08.05.2015
		$("issCd").value = unescapeHTML2(row.issCd);	//edited by gab 08.05.2015
		$("issueYy").value = formatNumberDigits(row.issueYy, 2);
		$("polSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
		$("renewNo").value = formatNumberDigits(row.renewNo, 2);
		$("endtIssCd").value = row.endtIssCd;
		$("endtYy").value = row.endtYy;
		$("endtSeqNo").value = nvl(row.endtSeqNo, "") == "" ? "" : formatNumberDigits(row.endtSeqNo, 6);
		$("assdName").value = unescapeHTML2(row.assdName);
		$("tsiAmt").value = formatCurrency(row.tsiAmt);
		$("riTsiAmt").value = formatCurrency(row.riTsiAmt);
		$("riPremAmt").value = formatCurrency(row.riPremAmt);
		$("riPremVat").value = formatCurrency(row.riPremVat);
		$("premTax").value = formatCurrency(row.premTax);
		$("binderDate").value = row.binderDate;
		$("reverseDate").value = row.reverseDate;
		$("frpsYy").value = row.frpsYy;
		$("frpsSeqNo").value = formatNumberDigits(row.frpsSeqNo, 6);
		$("currencyDesc").value = unescapeHTML2(row.currencyDesc);
		$("currencyRt").value = formatToNthDecimal(row.currencyRt, 10);
		$("premAmt").value = formatCurrency(row.premAmt);
		$("riShrPct").value = formatToNthDecimal(row.riShrPct, 8);
		$("riCommAmt").value = formatCurrency(row.riCommAmt);
		$("riCommVat").value = formatCurrency(row.riCommVat);
		$("riWholdingVat").value = formatCurrency(row.riWholdingVat);
		$("riCommRt").value = formatToNthDecimal(row.riCommRt, 8);
		$("netDueRi").value = formatCurrency(row.netDueRi);
		
		$("hidFnlBinderId").value = row.fnlBinderId;
		$("hidRemarks").value = unescapeHTML2(row.remarks);
		$("hidBndrRemarks1").value = unescapeHTML2(row.bndrRemarks1);
		$("hidBndrRemarks2").value = unescapeHTML2(row.bndrRemarks2);
		$("hidBndrRemarks3").value = unescapeHTML2(row.bndrRemarks3);
		$("hidRiAcceptBy").value = unescapeHTML2(row.riAcceptBy);
		$("hidRiAsNo").value = row.riAsNo;
		$("hidRiAcceptDate").value = row.riAcceptDate;
		
		enableButton("btnViewInfo");
		enableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("searchBinder");
		disableSearch("searchPolicy");
		
		$$("input[name='headerField']").each(function(i){
			disableInputField(i.id);
		});
	}
	
	function showBinderLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getBinderLOV",
					lineCd: $F("lineCd"),
					binderYy: $F("binderYy"),
					binderSeqNo: $F("binderSeqNo"),
					moduleId: 'GIRIS016'
				},
				title: "List of Binders",
				width: 412,
				height: 386,
				columnModel:[
								{	id: "binderNumber",
									title: "Binder Number",
									width: "110px",
								},
								{	id: "riSname",
									title: "Reinsurer",
									width: "110px"
								},
				             	{	id: "policyNumber",
									title: "Policy Number",
									width: "175px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined){
						populateFields(row);
					}
				}
			});
		}catch(e){
			showErrorMessage("showBinderLOV", e);
		}
	}
	
	// added by Gab Ramos 07.27.2015
	function showPolicyLOV(){
		try{
			LOV.show({
				controller: "UWRIInquiryController",
				urlParameters: {
					action: "getPolicyNumberLOV",
					polLineCd: escapeHTML2($F("polLineCd")),
					sublineCd: escapeHTML2($F("sublineCd")),
					issCd: escapeHTML2($F("issCd")),
					issueYy: $F("issueYy"),
					polSeqNo: $F("polSeqNo"),
					renewNo: $F("renewNo"),
					userId: userId,
					moduleId: 'GIRIS016'
				},
				title: "List of Policy",
				width: 599,
				height: 386,
				columnModel:[
								{	id: "policyNumber",
									title: "Policy Number",
									width: "170px",
								},
								{	id: "endtNumber",
									title: "Endorsement Number",
									width: "150px"
								},
				             	{	id: "binderNumber",
									title: "Binder Number",
									width: "130px"
								},
								{	id: "riSname",
									title: "Reinsurer Name",
									width: "130px"
								}
							],
					draggable: true,
					showNotice: true,
					autoSelectOneRecord : true,
					noticeMessage: "Getting list, please wait...",
					onSelect : function(row){
					if(row != undefined){
						populateFields(row);
								}
							}
		});
		}catch(e){
			showErrorMessage("showBinderLOV", e);
		}
	}
	
	function getBinder(){
		new Ajax.Request(contextPath+"/GIRIBinderController", {
			parameters: {
				action: "getBinder",
				lineCd: $F("lineCd"),
				binderYy: $F("binderYy"),
				binderSeqNo: $F("binderSeqNo"),
				moduleId: 'GIRIS016'
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					populateFields(JSON.parse(response.responseText));
				}
			}
		});
	}
	
	function showAdditionalInfo(){
		additionalInfoOverlay = Overlay.show(contextPath+"/GIRIBinderController", {
			urlParameters: {
				action: "showBinderDetails"
			},
			title: "Remarks",
		    height: 370,
		    width: 490,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}
	
	$$("input[name='headerField']").each(function(i){
		i.observe("change", function(){
			if($F("lineCd") != "" || $F("binderYy") != "" || $F("binderSeqNo") != "" || $F("polLineCd") != "" || 
			$F("sublineCd") != "" || $F("issCd") != "" || $F("issueYy") != "" || $F("polSeqNo") != "" || $F("renewNo") != ""){
				enableToolbarButton("btnToolbarEnterQuery");
			}else{
				disableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});

	$("binderSeqNo").observe("change", function(){
		if($F("binderSeqNo") != ""){
			$("binderSeqNo").value = lpad($F("binderSeqNo"), 5, '0');
		}
	});
	
	$("polSeqNo").observe("change", function(){
		if($F("polSeqNo") != ""){
			$("polSeqNo").value = lpad($F("polSeqNo"), 7, '0');
		}
	});
	
	$("issueYy").observe("change", function(){
		if($F("issueYy") != ""){
			$("issueYy").value = lpad($F("issueYy"), 2, '0');
		}
	});
	
	$("renewNo").observe("change", function(){
		if($F("renewNo") != ""){
			$("renewNo").value = lpad($F("renewNo"), 2, '0');
		}
	});

	/*	 $("searchBinder").observe("click", function(){				
	 if(checkAllRequiredFieldsInDiv("viewBinderHeaderDiv")){	
	 showBinderLOV();
	 }
	 }); */

	// edited by gab ramos 07.27.2015
	$("searchBinder").observe("click", function() {
		if ($F("lineCd") != "") {
			showBinderLOV();
		} else {
			showMessageBox("Required fields must be entered.", "I");
		}
	});

	// added by gab ramos 07.27.2015
	$("searchPolicy").observe("click", function() {
		if ($F("polLineCd") != "") {
			showPolicyLOV();
		} else {
			showMessageBox("Required fields must be entered.", "I");
		}
	});

	$("btnViewInfo").observe("click", function(){
		showAdditionalInfo();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		binderPerilTG.url = contextPath +"/GIRIBinderController?action=showViewBinder&refresh=1";
		binderPerilTG._refreshList();
		resetForm();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	$("btnToolbarExit").observe("click", function(){
		if(nvl(objUW.callingForm, "") == "GIRIS015"){
			objUW.callingForm = "GIRIS016";
			if(nvl(objGipis130.callSw, "") == "Y"){ //benjo 07.20.2015 UCPBGEN-SR-19626 added if condition
				showViewRIPlacementsOnGIPIS130();
			} else {
				showViewRIPlacements();
			}
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	});

	newFormInstance();
	resetForm();
</script>