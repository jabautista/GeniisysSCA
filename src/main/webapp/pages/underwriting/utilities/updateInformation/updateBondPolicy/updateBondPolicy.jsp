<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="updateBondPolicyDiv" name="updateBondPolicyDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Update Bond Policy Basic Information</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
	   	</div>
	</div>
	<div id="updateBondPolicyMainDiv" name="updateBondPolicyMainDiv" class="sectionDiv" style="border:none; margin: 0 0 2px 0;">
		<div id="updateBondPolicyBodyDiv" name="updateBondPolicyBodyDiv" class="sectionDiv">
			<input type="hidden" id="hidPolicyId" />
			<input type="hidden" id="hidAssdNo" />	
			<input type="hidden" id="hidNpNo" />	
			<input type="hidden" id="hidObligeeNo" />	
			<table align="center" style="margin-top: 15px; margin-bottom: 15px;">
				<tr>
					<td class="rightAligned">Bond No.</td>
					<td>
						<input type="text" id="txtLineCd" 		name="txtLineCd" 	style="width:40px; float:left;" class="allCaps required editable" maxlength="2" tabindex="101"/>
						<input type="text" id="txtSublineCd" 	name="txtSublineCd" style="width:90px; float:left;  margin-left:3px;" class="allCaps editable" maxlength="7" tabindex="102"/>
						<input type="text" id="txtIssCd" 		name="txtIssCd" 	style="width:40px; float:left;  margin-left:3px;" class="allCaps editable" maxlength="2" tabindex="103"/>
						<input type="text" id="txtIssueYy" 		name="txtIssueYy" 	style="width:40px; float:left;  margin-left:3px; text-align:right;" class="integerUnformatted editable" lpad="2" maxlength="2" tabindex="104"/>
						<input type="text" id="txtPolSeqNo" 	name="txtPolSeqNo" 	style="width:70px; float:left;  margin-left:3px; text-align:right;" class="integerUnformatted editable" lpad="7" maxlength="7" tabindex="105"/>
						<input type="text" id="txtRenewNo" 		name="txtRenewNo" 	style="width:40px; float:left;  margin-left:3px; text-align:right;" class="integerUnformatted editable" lpad="2" maxlength="2" tabindex="106"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBondNo" name="searchBondNo" style="margin-left: 3px; float:left; padding:3px; cursor: pointer;" tabindex="107"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Endt. No.</td>
					<td>
						<input type="text" id="txtEndtLineCd" 		name="txtEndtLineCd" 	style="width:40px; float:left;" class="allCaps editable" maxlength="2" tabindex="108"/>
						<input type="text" id="txtEndtSublineCd" 	name="txtEndtSublineCd" style="width:90px; float:left; margin-left:3px;" class="allCaps editable" maxlength="7" tabindex="109"/>
						<input type="text" id="txtEndtIssCd" 		name="txtEndtIssCd" 	style="width:40px; float:left; margin-left:3px;" class="allCaps editable" maxlength="2" tabindex="110"/>
						<input type="text" id="txtEndtIssueYy" 		name="txtEndtIssueYy" 	style="width:40px; float:left; margin-left:3px; text-align:right;" class="integerUnformatted editable" lpad="2" maxlength="2" tabindex="111"/>
						<input type="text" id="txtEndtSeqNo" 		name="txtEndtSeqNo" 	style="width:121px;float:left; margin-left:3px; text-align:right;" class="integerUnformatted editable" lpad="6" maxlength="7" tabindex="112"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Principal</td>
					<td>
						<input type="text" id="txtAssdName" name="txtAssdName" style="width:375px; float:left;" class="allCaps" maxlength="500" readonly="readonly" tabindex="113"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">OR No.</td>
					<td>
						<input type="text" id="txtOrNo" name="txtOrNo" style="width:192px; float:left; text-align: right;" maxlength="10" readonly="readonly" tabindex="114"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Amount Paid</td>
					<td>
						<input class="money2" type="text" id="txtAmtPaid" name="txtAmtPaid" style="width:192px; float:left; text-align: right;" maxlength="30" readonly="readonly" tabindex="115"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Release Date</td>
					<td>
						<input type="text" id="txtReleaseDate" name="txtReleaseDate" readonly="readonly" style="width: 192px;" maxlength="33" tabindex="116"/>
					</td>
				</tr>
			</table>
		</div>	
		<div id="updateBondPolicyFooterDiv" name="updateBondPolicyFooterDiv" class="sectionDiv"  style="margin: 0 0 5px 0;">
			<table align="center" style="padding: 20px;">
				<tr>
					<td class="rightAligned">Obligee</td>
					<td>
						<input type="text" id="txtObligeeName" name="txtObligeeName" style="width:375px; float:left;" maxlength="100" readonly="readonly" tabindex="117"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Notary</td>
					<td colspan="3">
						<span class="lovSpan" style="width:381px; height: 21px; margin: 2px 4px 0 0; float: left;">
							<input class="observeChanges"  type="text" id="txtNpName" name="txtNpName" style="width: 350px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="50" tabindex="118" lastValidValue=""/>	
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchNpNo" name="searchNpNo" alt="Go" style="float: right;" tabindex="119"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Coll. Flag</td>
					<td>
						<select id="txtCollFlag" style="margin: 2px 0 0 0; width: 143px; height: 23px; float: left;" class="observeChanges" tabindex="120">
							<option value="Q">Required</option>
							<option value="S">Submitted</option>
							<option value="W">Waived</option>
							<option value="C">Cancelled</option>
							<option value="R">Released</option>
							<option value="P">Paid</option>
							<option value="N">Not Required</option>
						</select>
						<label style="margin: 6px 0 0 15px; float: left;">Waiver Limit</label>
						<input class="money2 observeChanges" type="text" id="txtWaiverLimit" name="txtWaiverLimit" style="width: 143px; float: left; margin-left: 3px;" maxlength="18" tabindex="121" min="-99999999999999.99" max="99999999999999.99" errorMsg="Invalid Waiver Limit. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99."/>
					</td>
				</tr>
			</table>
		</div>
		<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="margin-bottom: 30px;">
			<input type="button" id="btnCancel" name="btnCancel" class="button"	style="width:90px;" value="Cancel" tabindex="122" />
			<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	style="width:90px;" value="Save" tabindex="123" />
		</div>
	</div> 
</div> 

<script type="text/javascript">
	var objGIPIS047 = {};
	objGIPIS047.exitPage = null;
	resetPage();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	setModuleId("GIPIS047");
	setDocumentTitle("Update Bond Policy Basic Information");
	var notaryExist = true;
	var bondUpdate = new Object();
	var pageStatus = "ENTER QUERY";
	
	function resetPage() {
		try {
			changeTag = 0;
			bondUpdate = new Object();
			$("txtLineCd").focus();
			$("btnToolbarExecuteQuery").hide();
			//$("btnToolbarEnterSep").hide(); removed by jdiago 07.14.2014 : causing javascript error and was never used.
			$("btnToolbarPrint").hide();
			$("btnToolbarPrintSep").hide();
			$("txtNpName").readOnly = true;
			$("txtWaiverLimit").readOnly = true;
			$("txtWaiverLimit").removeClassName('required');
			$("txtCollFlag").disabled = true;
			disableToolbarButton("btnToolbarEnterQuery");
			disableSearch("searchNpNo");
			disableButton("btnSave");
			enableSearch("searchBondNo");
			pageStatus = "ENTER QUERY";
			objGIPIS047.exitPage = null;

			$("txtCollFlag").value= "N";
			$$("div#updateBondPolicyBodyDiv input[type='text'].editable").each(function (a) {
				$(a).readOnly = false;
			});
			$$("div#updateBondPolicyMainDiv input[type='text']").each(function (a) {
				$(a).clear();
			});
			
		} catch (e) {
			showErrorMessage("resetPage",e);
		}
	}
	
	function populateBondDetail(obj) {
		try{
			$("txtLineCd").value 				= obj			== null ? "" : nvl(obj.lineCd,"");
			$("txtSublineCd").value 			= obj			== null ? "" : nvl(obj.sublineCd,"");
			$("txtIssCd").value 				= obj 	 		== null ? "" : nvl(obj.issCd,"");
			$("txtIssueYy").value				= obj  			== null ? "" : lpad(nvl(obj.issYy,""),2,'0');
			$("txtPolSeqNo").value  			= obj  			== null ? "" : lpad(nvl(obj.polSeqNo,""),7,'0');
			$("txtRenewNo").value  				= obj  			== null ? "" : lpad(nvl(obj.renewNo,""),2,'0');
			$("txtEndtLineCd").value 			= obj			== null ? "" : nvl(obj.lineCd,"");
			$("txtEndtSublineCd").value 		= obj			== null ? "" : nvl(obj.sublineCd,"");
			$("txtEndtIssCd").value 			= obj			== null ? "" : nvl(obj.endtIssCd,"");
			$("txtEndtIssueYy").value 			= obj			== null ? "" : obj.endtYy == null ? "" : lpad(obj.endtYy,2,'0');
			$("txtEndtSeqNo").value 			= obj			== null ? "" : obj.endtSeqNo == null? "" : lpad(obj.endtSeqNo,6,'0');
			$("txtAssdName").value 				= obj			== null ? "" : unescapeHTML2(nvl(obj.assdName,""));
			$("hidAssdNo").value 				= obj			== null ? "" : obj.assdNo;
			$("hidPolicyId").value 				= obj			== null ? "" : obj.policyId;
			$("txtOrNo").value  				= obj  			== null ? "" : unescapeHTML2(nvl(obj.dspOrNo,"")); 
			$("txtAmtPaid").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.dspAmtPaid,""));
			$("txtReleaseDate").value 			= obj			== null ? "" : obj.dspEffDate;
			$("txtObligeeName").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.dspObligeeName,"")); 
			$("hidObligeeNo").value 			= obj			== null ? "" : obj.obligeeNo;
			$("txtNpName").value  				= obj  			== null ? "" : unescapeHTML2(nvl(obj.npName,"")); 
			$("hidNpNo").value 					= obj			== null ? "" : obj.npNo;
			$("txtCollFlag").value 				= obj			== null ? "" : obj.collFlag;
			$("txtWaiverLimit").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.waiverLimit,0));
			$("txtNpName").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.npName)));
		} catch(e){
			showErrorMessage("populateBondDetail", e);
		}
	}
	
	function disableFields() {
		$$("div#updateBondPolicyBodyDiv input[type='text']").each(function (a) {
			$(a).readOnly = true;
		});
		disableSearch("searchBondNo");
	}
	
	function enableFields() {
		enableToolbarButton("btnToolbarEnterQuery");
		enableButton("btnSave");
		enableSearch("searchNpNo");
		$("txtNpName").readOnly = false;
		$("txtCollFlag").disabled = false;
		
		if ($("txtCollFlag").value == "W" ) {
			$("txtWaiverLimit").readOnly = false;
			$("txtWaiverLimit").addClassName('required');
		}else{
			$("txtWaiverLimit").readOnly = true;
			$("txtWaiverLimit").removeClassName('required');
		}
	}
	
	function setFilter() {
		var obj = new Object();
		obj.sublineCd = $F("txtSublineCd");
		obj.issueYy = $F("txtIssueYy");
		obj.polSeqNo = $F("txtPolSeqNo");
		obj.renewNo = $F("txtRenewNo");
		obj.endtIssCd = $F("txtEndtIssCd");
		obj.endtYy = $F("txtEndtIssueYy");
		obj.endtSeqNo = $F("txtEndtSeqNo");
		return obj;
	}
	
	function showBondNoLov() {
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action      : "getGipis047BondLov",
					moduleId	: "GIPIS047",
					issCd		: $F("txtIssCd"),
					lineCd		: $F("txtLineCd"),
					objFilter2   : JSON.stringify(setFilter())
				},
				title : "Bond Listing",
				width : 630,
				height : 400,
				filterVersion : "2",
				columnModel : [ {
									id : 'recordStatus',
									title : '',
									width : '0',
									visible : false,
									editor : 'checkbox'
								}, 
								{
									id : 'divCtrId',
									width : '0',
									visible : false
								},
								{
									id : "policyNo",
									title : "Bond No.",
									width : '180px',
									filterOption : true
								}, 
								{
									id : "endtNo",
									title : "Endorsement No.",
									width : '120px',
									filterOption : true
								}, 
								{
									id : "assdName",
									title : "Principal",
									width : '300px',
									filterOption : true
								}
							   ],
				draggable : true,
				autoSelectOneRecord : true,
				onSelect : function(row) {
					if (row != undefined) {
						populateBondDetail(row);
						disableFields();
						enableFields();
						bondUpdate = row;
						pageStatus = "EXECUTE QUERY";
					}
				},
				onCancel : function(){
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected", "I");
				}
			});
			
		}catch(e){
			showErrorMessage("showBondNoLov", e);
		}
		
	}
	
	function showNotaryLov(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
								 action   : "getGipis047NotaryLov",
								 findText2 : ($("txtNpName").readAttribute("lastValidValue").trim() != $F("txtNpName").trim() ? $F("txtNpName").trim() : "%"),
								 page : 1
				},
				title: "Notary List",
				width: 400,
				height: 390,
				columnModel: [
					{
						id :  'npNo',
						title: '',
						width : '0',
						visible : false
					},
					{
						id : 'npName',
						title: 'Notary',
					    width: '380px',
					    align: 'left'
					}
				],
				autoSelectOneRecord: true,
				filterText : ($("txtNpName").readAttribute("lastValidValue").trim() != $F("txtNpName").trim() ? $F("txtNpName").trim() : ""),
				onSelect: function(row) {
					$("hidNpNo").value = row.npNo;
					$("txtNpName").value = unescapeHTML2(row.npName);
					$("txtNpName").setAttribute("lastValidValue", unescapeHTML2(row.npName));
					changeTagFunc = saveBondUpdate;
					changeTag = 1;
				},
				onCancel: function (){
					$("hidNpNo").clear();
					$("txtNpName").clear();
					$("txtNpName").value = escapeHTML2($("txtNpName").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtNpName").value = escapeHTML2($("txtNpName").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showNotaryLov",e);
		}
	}
	
	/* function checkReleaseDate() {
		if (pageStatus != "ENTER QUERY") {
			if (bondUpdate.updtEffDt == "N") {
				showMessageBox("Release date cannot be modified.","E");
				return;
			}
			if (compareDatesIgnoreTime(Date.parse(bondUpdate.effDate),Date.parse(new Date) == -1)) {
				showMessageBox("Release Date cannot be after today.","E");
				return;
			}
			if (compareDatesIgnoreTime(Date.parse(bondUpdate.effDate),Date.parse(bondUpdate.inceptDate) == 1)) {
				showMessageBox("Release Date cannot be before the inception date.","E");
				return;
			}
			
			if (compareDatesIgnoreTime(Date.parse(bondUpdate.effDate),Date.parse(bondUpdate.issueDate) == 1)) {
				showMessageBox("Release Date cannot be before the issue date.","E");
				return;
			}
			if (bondUpdate.endtSeqNo > 0) {
				if (compareDatesIgnoreTime(Date.parse(bondUpdate.effDateCond),Date.parse(bondUpdate.effDate) == -1)) {
					showMessageBox("Endorsement cannot be effective earlier than the effectivity date of the policy.","E");
					return;
				}
				if (compareDatesIgnoreTime(Date.parse(bondUpdate.effDate),Date.parse(bondUpdate.endtExpiryDate) == 1)) {
					bondUpdate.updtEffDt = 'N';
				}
			}else {
				if (compareDatesIgnoreTime(Date.parse(bondUpdate.effDate),Date.parse(bondUpdate.expiryDate) == 1)) {
					bondUpdate.updtEffDt = 'N';
				}
			}
			
		} 
	} */
	
	function setBondUpdate() {
		bondUpdate.npName = $F("txtNpName");
		bondUpdate.npNo = $F("hidNpNo");
		bondUpdate.collFlag = $F("txtCollFlag");
		bondUpdate.waiverLimit = $F("txtWaiverLimit");
	}
	
	function saveBondUpdate(){
		try{
			setBondUpdate();
			var objParameters = new Object();
			objParameters.setBondUpdate = bondUpdate;
			new Ajax.Request(contextPath+"/UpdateUtilitiesController?action=saveGipis047BondUpdate",{
				method: "POST",
				asynchronous: false,
				parameters:{
					npNo: 		bondUpdate.npNo,
					collFlag: 		bondUpdate.collFlag,
					waiverLimit: 	unformatCurrencyValue(bondUpdate.waiverLimit),
					policyId: 		bondUpdate.policyId
				},
				onCreate:function(){
					showNotice("Saving  Update Bond Policy Basic Information, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if(objGIPIS047.exitPage != null) {
									objGIPIS047.exitPage();
								} else {
									resetPage();
								}
							});
							changeTag = 0;
						}else{
							showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveBondUpdate", e);
		}
	}
	
	function exitPage(){ 
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGipis047(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIPIS047.exitPage = exitPage;
						saveBondUpdate();
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}

	/* observe */
	$$("div#updateBondPolicyMainDiv input[type='text'].observeChanges, select.observeChanges").each(function (a) {
		$(a).observe("change", function() {
			changeTagFunc = saveBondUpdate;
			changeTag = 1;
		});
	});
	
	$("txtCollFlag").observe("change", function() {
		if ($("txtCollFlag").value == "W" ) {
			$("txtWaiverLimit").readOnly = false;
			$("txtWaiverLimit").addClassName('required');
		}else{
			$("txtWaiverLimit").readOnly = true;
			$("txtWaiverLimit").removeClassName('required');
		}
	});
	
	$("searchBondNo").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("updateBondPolicyBodyDiv")) {
			showBondNoLov();
		}
	});
	
	$("searchNpNo").observe("click", showNotaryLov);
	
	$("txtNpName").observe("change", function() {
		if($F("txtNpName").trim() == "") {
			$("txtNpName").clear();
			$("hidNpNo").clear();
			$("txtNpName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtNpName").trim() != "" && $F("txtNpName") != unescapeHTML2($("txtNpName").readAttribute("lastValidValue"))) {
				showNotaryLov();
			}
		}
	});
	
	$("txtLineCd").observe("change", function() {
		$("txtEndtLineCd").value = this.value;
	});
	
	$("txtSublineCd").observe("change", function() {
		$("txtEndtSublineCd").value = this.value;
	});
	
	$("txtEndtLineCd").observe("change", function() {
		$("txtLineCd").value = this.value;
	});
	
	$("txtEndtSublineCd").observe("change", function() {
		$("txtSublineCd").value = this.value;
	});
	
	$("btnToolbarEnterQuery").observe("click" , function() {
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						saveBondUpdate();
					}, function(){
						changeTag = 0;
						resetPage();
					}, "");
		}else{
			resetPage();
		}
	});
	
	$("btnToolbarExit").observe("click" , cancelGipis047);
	$("btnCancel").observe("click" , cancelGipis047);

	$("btnSave").observe("click" , function() {
		if (checkAllRequiredFieldsInDiv("updateBondPolicyMainDiv")) {
			if (changeTag == 1) {
				saveBondUpdate();
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES,"I");
			}
		}
	});
	$("reloadForm").observe("click" , function() {
		observeReloadForm("reloadForm", showUpdateBondPolicy);
	});
</script>