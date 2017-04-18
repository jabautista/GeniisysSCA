<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="wcMainDiv" name="wcMainDiv">
	<form id="wcMainForm" name="wcMainForm">
		<input type="hidden" name="quoteId"  	id="quoteId" 	value="${gipiQuote.quoteId}" />
		<input type="hidden" name="lineCd" 		id="lineCd" 	value="${gipiQuote.lineCd}" />
		<input type="hidden" name="lineName" 	id="lineName" 	value="${gipiQuote.lineName}" />

		<!-- Start Quotation Information Section -->
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;"><!-- Header -->
			<div id="innerDiv" name="innerDiv">
				<label id="">Quotation Information</label>  
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="clausesDiv" name="clausesDiv" class="sectionDiv"><!-- Body -->
			<div id="quoteInfo" name="quoteInfo" style="margin: 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Quotation No. </td>
						<td class="leftAligned"><input type="text" style="width: 250px;" id="quoteNo" name="quoteNo" readonly="readonly" value="${gipiQuote.quoteNo}" />
						<td class="rightAligned">Assured Name </td>
						<td class="leftAligned">
							<input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${gipiQuote.assdName}" />
							<input type="hidden" id="assuredNo" name="assuredNo" value="${gipiQuote.assdNo}" />
						</td>	
					</tr>
				</table>
			</div>
		</div>		
		<!-- End Quotation Information Section -->

		<!-- Start Warranties and Clauses Section -->
		<div id="outerDiv" name="outerDiv"><!-- Header -->
			<div id="innerDiv" name="innerDiv">
				<label>Warranties and Clauses</label> 
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="cwDivAndFormDiv" name="cwDivAndFormDiv" class="sectionDiv"><!-- Body -->
			<div id="quoteWarrClaTableDiv" style="padding: 10px 0 10px 10px;">
				<div id="quoteWarrClaTable" name="quoteWarrClaTable" style="height: 250px;"></div>
			</div>
			
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px; margin-top: 30px;" changeTagAttr="true" >
				<form id="wcFormHaha" name="wcFormHaha">
					<table align="center" >
						<tr style="display: none;" id="message" name="message">
							<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
						</tr>
						<tr>
							<td class="rightAligned">Warranty Title </td>
							<td colspan="4" class="leftAligned">
								<span class="required lovSpan" style="width: 430px;">
									<input type="hidden" id="hidWcCd" name="hidWcCd"> 								
									<input type="text" id="warratyTitleDisplay" name="warratyTitleDisplay" readonly="readonly" class="required" style="width: 405px;  float: left; border: medium none; height: 13px; margin: 0pt;" />								
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarrantyTitle" name="searchWarrantyTitle" alt="Go" style="float: right;"/>
								</span>
							</td>
							<td class="leftAligned" colspan="3">
								<div style="border: 1px solid gray; height: 20px; width: 200px;">
									<textarea type="text" id="warrantyTitle2" name="warrantyTitle2" style="width: 171px; height: 13px; border: none;" maxlength="100"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyTitle2" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Type</td>
							<td class="leftAligned" width="120px;"><input type="text" id="warrantyClauseType" name="warrantyClauseType" style="width: 100px;" readonly="readonly"></input></td>
							<td class="rightAligned">Print Sequence No. </td>
							<td class="leftAligned"><input type="text" id="printSeqNumber" class="required integerNoNegativeUnformatted" maxlength="2" style="width: 40px;" errorMsg="Invalid Print Sequence No. Value should be from 1 to 99."/></td>
							<td class="rigthAligned">Print Switch</td>
							<td class="leftAligned"><input type="checkbox" id="printSwitch" name="printSwitch" value="Y"></td>
							<td class="rightAligned">Change Tag</td>
							<td class="leftAligned" width="60px;"><input type="checkbox" id="changeTag" name="changeTag" value="Y" disabled="disabled"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Warranty Text</td>
							<td colspan="7" class="leftAligned">
								<div style="border: 1px solid gray; height: 20px; width: 642px;">
									<input type="hidden" id="hidOrigWarrantyText" name="hidOrigWarrantyText" style="width: 610px; border: none; height: 13px;"></input>
									<textarea id="warrantyText" name="warrantyText" style="width: 610px; border: none; height: 13px;"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
								</div>
							</td>
							<td class="leftAligned"><input type="hidden" id="charactersRemaining" name="charactersRemaining" style="width: 61px;" value="32500" />  </td>
						</tr>
						<tr>
							<td class="rightAligned">Remarks</td>
							<td colspan="7" class="leftAligned">
								<div style="border: 1px solid gray; height: 20px; width: 642px;">
									<textarea id="inputWcRemarks" name="inputWcRemarks" style="width: 610px; border: none; height: 13px;"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWcRemarks" />
								</div>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div style="width: 100%; margin: 10px 0;" align="center" >
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" disabled="disabled" />
			</div>
		</div>
		<div class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnEditQuotation" value="Edit Basic Quotation Info">
						<input type="button" class="button" id="btnSaveQuotationWC" value="Save">
					</td>
				</tr>
			</table>		
		</div>
		<!-- End Warranties and Clauses Section -->
	</form>
</div>

<script type="text/JavaScript">
	/*	Created by: Udel 
	**	Date Created: 03282012
	**	Created new Quotation Warranties and Clauses page
	**	 implemented with tableGrid and JSON (based on warrantyAndClauses.jsp).
	*/
	try{
		changeTag = 0;
		setModuleId("GIIMM008");
		setDocumentTitle("Warranties and Clauses");
		observeAccessibleModule(accessType.TOOLBUTTON, "GIIMM002", "btnEditQuotation", goToEnterQuotationInfo);
		initializeAccordion();
		addStyleToInputs();
		initializeAll();
		
		jsonWarrCla = {};
		jsonWarrCla.populateQuoteWarrCla = populateQuoteWarrCla;
		var objGIPIQuoteWarrCla = [];
		var currentRowIndex = -1;
		var cond2 = true;
		var totalRecords = 0;
		var maxDb = 0;	
		var jsonQuoteWarrCla = JSON.parse('${jsonQuoteWarrClaTableGrid}'.replace(/\\/g, '\\\\').replace(/\t/gi, " "));
		var quoteWarrClaTableModel = {
			url : contextPath+"/GIPIQuotationWarrantyAndClauseController?action=showWarrClaPage&refresh=1&quoteId="+$F("quoteId"),
			options: {
				hideColumnChildTitle: true,
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
					var obj = tbgQuoteWarrCla.geniisysRows[y];
					populateQuoteWarrCla(obj);
					currentRowIndex = y;
					disableSearch("searchWarrantyTitle");
					$("btnAdd").value = "Update";
					enableButton("btnDelete");
					tbgQuoteWarrCla.keys.releaseKeys();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					currentRowIndex = -1;
					formatAppearance();
					clearChangeAttribute("wcFormDiv");
				},
				beforeSort: function(){
					if (changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveQWC, showClausesPage,"");
						return false;
					} else {
						return true;
					}
				},
				onRefresh: function(){
					formatAppearance();
				},
				postPager: function () {
					formatAppearance();
				},
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function() {
						formatAppearance();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					title: '',
					width: '0',
					visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'wcTitle wcTitle2',
					title:'Warranty Title',
					width: 250,
					align: 'left',
					children: [
				    	   	    {	id: 'wcTitle',
							    	width: 150,
							    	align: 'right',
							    	filterOption: true,	
									title:'Warranty Title'
							    },
							    {	id: 'wcTitle2',
							    	width: 100
							    }
				   	]
				},
				{
					id: 'wcSw',
					title: 'Type',
					width: '120px',
					filterOption: true
				},
				{
					id: 'printSeqNo',
					title: 'Prt. Seq.',
					width: '70px',
					align: 'right',
					titleAlign: 'center'
				},
				{
					id: 'wcText',
					title: 'Text',
					width: '350px',
					renderer: function(value){
						if (value == null){
							return '-';
						} else {
							return value;
						}
					}
				},
				{
					id: 'tbgPrintSw',
					title: 'P',
					width: '30px',
					tooltip: 'Print',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					editor:	 'checkbox',
					sortable: false
				},
				{
					id: 'printSw',
					width: '0',
					visible: false
				},
				{
					id: 'tbgChangeTag',
					title: 'C',
					width: '30px',
					tooltip: 'Change Tag',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					editor:	 'checkbox',
					sortable: false
				},
				{
					id: 'changeTag',
					width: '0',
					visible: false
				},
				{
					id: 'quoteId',
					width: '0',
					visible: false
				},
				{
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{
					id: 'wcTitle2',
					width: '0',
					visible: false
				},
				{
					id: 'wcCd',
					width: '0',
					visible: false
				}
			],
			rows: jsonQuoteWarrCla.rows
		};
		
		tbgQuoteWarrCla = new MyTableGrid(quoteWarrClaTableModel);
		tbgQuoteWarrCla.pager = jsonQuoteWarrCla;
		tbgQuoteWarrCla.render('quoteWarrClaTable');
		tbgQuoteWarrCla.afterRender = function(){
													objGIPIQuoteWarrCla=tbgQuoteWarrCla.geniisysRows;
													if(tbgQuoteWarrCla.geniisysRows.length != 0){
														maxDb = tbgQuoteWarrCla.geniisysRows[0].maxPrintSeqNo;
														totalRecords = tbgQuoteWarrCla.geniisysRows[0].rowCount;
													}
												};
		
		initializeChangeAttribute();
		observeReloadForm("reloadForm", showClausesPage);
		initializeChangeTagBehavior(saveQWC);
		
// 		if (isMakeQuotationInformationFormsHidden == 1) {
// 			$("wcFormDiv").hide();
// 			$("wcButtonsDiv").hide();
// 		}
	} catch(e){
		showErrorMessage("Quotation Warranties and Clauses", e);
	}
	
	function setQuotationWarrClaFormToObj() {
		obj = new Object();
		
		obj.quoteId 	= parseInt($F("quoteId"));
		obj.lineCd	 	= escapeHTML2($F("lineCd"));
		obj.wcCd 		= escapeHTML2($F("hidWcCd"));
		obj.printSeqNo 	= parseInt($("printSeqNumber").value);
		obj.wcTitle 	= escapeHTML2($("warratyTitleDisplay").value);
		obj.wcText 		= escapeHTML2($F("warrantyText"));
		obj.wcText1 	= escapeHTML2($F("warrantyText").substring(0,2000));
		obj.wcText2 	= escapeHTML2($F("warrantyText").substring(2001,4000));
		obj.wcText3 	= escapeHTML2($F("warrantyText").substring(4001,6000));
		obj.wcText4 	= escapeHTML2($F("warrantyText").substring(6001,8000));
		obj.wcText5 	= escapeHTML2($F("warrantyText").substring(8001,10000));
		obj.wcText6 	= escapeHTML2($F("warrantyText").substring(10001,12000));
		obj.wcText7 	= escapeHTML2($F("warrantyText").substring(12001,14000));
		obj.wcText8 	= escapeHTML2($F("warrantyText").substring(14001,16000));
		obj.wcText9 	= escapeHTML2($F("warrantyText").substring(16001,18000));
		obj.wcText10 	= escapeHTML2($F("warrantyText").substring(18001,20000));
		obj.wcText11 	= escapeHTML2($F("warrantyText").substring(20001,22000));
		obj.wcText12 	= escapeHTML2($F("warrantyText").substring(22001,24000));
		obj.wcText13 	= escapeHTML2($F("warrantyText").substring(24001,26000));
		obj.wcText14 	= escapeHTML2($F("warrantyText").substring(26001,28000));
		obj.wcText15 	= escapeHTML2($F("warrantyText").substring(28001,30000));
		obj.wcText16 	= escapeHTML2($F("warrantyText").substring(30001,32000));
		obj.wcText17 	= escapeHTML2($F("warrantyText").substring(32001,34000));
		obj.wcRemarks 	= escapeHTML2($("inputWcRemarks").value);
		obj.printSw 	= $("printSwitch").checked ? "Y" : "N";
		obj.changeTag 	= $("changeTag").checked ? "Y" : "N";
		obj.wcTitle2 	= escapeHTML2($F("warrantyTitle2"));
		obj.swcSeqNo 	= "";
		obj.wcSw 		= $F("warrantyClauseType");
		obj.tbgPrintSw 	= $("printSwitch").checked;
		obj.tbgChangeTag = $("changeTag").checked;
		
		return obj;
	} 
	
	function populateQuoteWarrCla(obj){
		try{
			$("hidWcCd").value 				= obj == null ? "" : obj.wcCd;
			$("printSeqNumber").value 		= obj == null ? "" : (obj.printSeqNo);	
			$("warratyTitleDisplay").value 	= obj == null ? "" : unescapeHTML2(obj.wcTitle);
			$("warrantyTitle2").value		= obj == null ? "" : unescapeHTML2(nvl(obj.wcTitle2,""));
			$("warrantyClauseType").value 	= obj == null ? "" : unescapeHTML2(obj.wcSw);
			$("inputWcRemarks").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.wcRemarks,""));
			$("printSwitch").checked 		= obj == null ? false : (obj.printSw == 'Y' ? true : false);
			$("changeTag").checked 			= obj == null ? false : (obj.changeTag == 'Y' ? true : false);
			$("warrantyText").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.wcText,""));
			$("hidOrigWarrantyText").value  = obj == null ? "" : unescapeHTML2(nvl(obj.wcText,""));  
		} catch (e){
			showErrorMessage("populateQuoteWarrCla", e);
		}
	}
	
	function addQWC(){
		try{
			if (checkWCRequiredFields() && checkRemarksLength() && checkWarrantyTextLength()){
				var wcPrintSeqNo 	= $F("printSeqNumber");
				if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".") || isNaN(parseFloat(wcPrintSeqNo))) {
					showWaitingMessageBox("Invalid Print Sequence No. Value should be from 1 to 99.", "I", function(){
						$("printSeqNumber").clear();
						$("printSeqNumber").focus();						
					});
					
					return;
				}
				
				var newObj = setQuotationWarrClaFormToObj();
				if ($("btnAdd").value == "Add"){
					newObj.recordStatus = 0;
					objGIPIQuoteWarrCla.push(newObj);
					tbgQuoteWarrCla.addBottomRow(newObj);
				} else {
					for(var i = 0; i<objGIPIQuoteWarrCla.length; i++){
						if ((objGIPIQuoteWarrCla[i].wcCd == newObj.wcCd)&&(objGIPIQuoteWarrCla[i].recordStatus != -1)){
							newObj.recordStatus = 1;
							objGIPIQuoteWarrCla.splice(i, 1, newObj);
							tbgQuoteWarrCla.updateVisibleRowOnly(newObj, tbgQuoteWarrCla.getCurrentPosition()[1]);
						}
					}
				}
				changeTag = 1;
				formatAppearance();
				clearChangeAttribute("wcFormDiv");
			}
		} catch(e){
			showErrorMessage("addQWC", e);
		}
	}
	
	function delQWC(){
		try{
			var delObj = setQuotationWarrClaFormToObj();
			for(var i = 0; i<objGIPIQuoteWarrCla.length; i++){
				if ((objGIPIQuoteWarrCla[i].wcCd == delObj.wcCd)&&(objGIPIQuoteWarrCla[i].recordStatus != -1)){
					delObj.recordStatus = -1;
					objGIPIQuoteWarrCla.splice(i, 1, delObj);
					tbgQuoteWarrCla.deleteRow(tbgQuoteWarrCla.getCurrentPosition()[1]);
					changeTag = 1;
				}
			}
			formatAppearance();
		} catch(e){
			showErrorMessage("delQWC", e);
		}
	}
	
	function saveQWC(){
		try{
			var objParameters = new Object();
			objParameters.setObjQuoteWarrCla = getAddedAndModifiedJSONObjects(objGIPIQuoteWarrCla);
			objParameters.delObjQuoteWarrCla = getDeletedJSONObjects(objGIPIQuoteWarrCla);
			 if(checkPendingRecord()){
				 new Ajax.Request(contextPath+"/GIPIQuotationWarrantyAndClauseController?action=saveGIPIQuotationWarrCla", {
						method: "POST",
						parameters: {
							parameters: JSON.stringify(objParameters)
						},
						onCreate: function(){
							showNotice("Saving Quotation Warranties and Clauses. Please Wait...");
						},
						onSuccess: function(response){
							hideNotice();
							if (response.responseText == "SUCCESS"){
								tbgQuoteWarrCla.refresh();
								changeTag = 0;
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								formatAppearance();
								lastAction();
								lastAction = "";
							}else{
								showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
							}
						}
					});
			 }
		} catch (e){
			showErrorMessage("saveQWC", e);
		}
	}
	
	function checkPendingRecord() {
		var cond = true;
		cond2 = true;
		if ($("btnAdd").value == "Update"){
			var message = "You have changes in Warranties and Clauses portion. Press Update button first to apply changes otherwise unselect the Warranties and Clauses record to clear changes.";
			showMessageBox(message);
			cond = false;
			cond2 = false;
		} else if($("warratyTitleDisplay").value != "" || $("warrantyTitle2").value != "" || $("printSeqNumber").value != "" || $("warrantyClauseType").value != "" || $("warrantyText").value != "" || $("inputWcRemarks").value != "" ||$("printSwitch").checked !=false){  
			var message = "You have changes in Warranties and Clauses portion. Press Add button first to apply changes.";
			showMessageBox(message);
			cond = false;
			cond2 = false;
		}
		return cond;
	}
	
	function goToEnterQuotationInfo(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", "Do you want to save the changes you have made?", "Yes", "No", "Cancel", 
							function(){
								saveWarrantyAndClause();
								changeTag = 0;
								setModuleId("GIIMM002");
								setDocumentTitle("Enter Quotation Information");
								editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");},
							function(){
								changeTag = 0;
								setModuleId("GIIMM002");
								setDocumentTitle("Enter Quotation Information");
								editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");},
							"" );		
		}else{
			setModuleId("GIIMM002");
			setDocumentTitle("Enter Quotation Information");
			editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
		}
	}
	
	function checkIfPrintSeqNoExist(printSeqNo){
		try{
			var exist = false;
	
			for(var i=0; i<objGIPIQuoteWarrCla.length; i++){
				if(printSeqNo == objGIPIQuoteWarrCla[i].printSeqNo && objGIPIQuoteWarrCla[i].recordStatus != -1){
					exist = true;
				}
			}
			if(!exist){
				new Ajax.Request(contextPath+"/GIPIQuotationWarrantyAndClauseController?action=validatePrintSeqNo",{
					method: "POST",
					asynchronous: true,
					parameters:{
						printSeqNo: printSeqNo,
						quoteId: $F("quoteId"),
						moduleId: null
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							if(response.responseText == "Y"){
								showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
								$("printSeqNumber").clear();
								$("printSeqNumber").focus();
								exist = true;
							}
						}
					}
				});
			}
			return exist;
		}catch(e){
			showErrorMessage("checkIfPrintSeqNoExist", e);
		}
	}
	function generatePrintSeqNo() {
		var max = 0;
		for(var i=0; i<objGIPIQuoteWarrCla.length; i++){
			if(parseInt(objGIPIQuoteWarrCla[i].printSeqNo) > max && objGIPIQuoteWarrCla[i].recordStatus != -1){
				max = parseInt(objGIPIQuoteWarrCla[i].printSeqNo);
			}
		}
		if(totalRecords>10){
			if (parseInt(maxDb) > parseInt(max)){
				max = parseInt(maxDb);
			}
		}
		return (parseInt(max) + 1);
	}
	
	function checkWarrantyTextLength(){
		try{
			var isNotLimit = true;
			if($("warrantyText").value.length > 34000){
				showMessageBox('You have exceeded the maximum number of allowed characters (34000) for Warranty Text field.', imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		}catch(e){
			showErrorMessage("checkWarrantyTextLength", e);
		}
	}
	
	function checkWCRequiredFields(){
		try{
			var isOk = true;
			var fields = ["warratyTitleDisplay", "printSeqNumber"];
	
			for(var i=0; i<fields.length; i++){
				if($(fields[i]).value.blank()){
					showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
					isOk = false;
				}
			}
	
			return isOk;
		}catch(e){
			showErrorMessage("checkWCRequiredFields", e);
		}
	}
	
	function checkRemarksLength(){
		try{
			var isNotLimit = true;
			if($("inputWcRemarks").value.length > 2000){
				showMessageBox('You have exceeded the maximum number of allowed characters (2000) for Remarks field.', imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		}catch(e){
			showErrorMessage("checkRemarksLength", e);
		}
	}
	
	
	function onCancelFunc() {
		$("warrantyText").value = $("origWarrantyText").value;
	}
	
	function resetText() {
		try{
			var defaultText = "";
			if($F("warrantyText") != ""){
				defaultText = $F("hidOrigWarrantyText");
			}
			$("warrantyText").value = defaultText;
			$("changeTag").checked = false;
		}catch(e){
			showErrorMessage("resetText", e);
		}
	}
	
	function checkChangeTag() {
		$("changeTag").checked = true;
	}
	
	function formatAppearance() {
		try{
			$("btnAdd").value="Add";
			disableButton("btnDelete");
			enableSearch("searchWarrantyTitle");
			populateQuoteWarrCla(null);
			tbgQuoteWarrCla.keys.releaseKeys();
		}catch (e) {
			showErrorMessage("formatAppearance",e);
		}
	}
	/* Observers */
	$("searchWarrantyTitle").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		try {
			objGIPIQuoteWarrCla.filter(function(obj){return obj.recordStatus != -1;}).each(function(row){
				if(withPrevious) notIn += ",";
				notIn += "'"+row.wcCd+"'";
				withPrevious = true;
			});
			notIn = (notIn != "" ? "("+notIn+")" : "");
			showQuoteWarrClaLOV($("lineCd").value, notIn,generatePrintSeqNo());
		} catch (e){
			showErrorMessage("Quotation Warranties and Clauses", e);
		}
				
	});
	
	$("printSeqNumber").observe("change", function(){
		var wcPrintSeqNo 	= this.value;
		if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".") || isNaN(parseFloat(wcPrintSeqNo))) {
			showMessageBox("Invalid Print Sequence No. Value should be from 1 to 99.");
			$("printSeqNumber").clear();
			$("printSeqNumber").focus();
		}else if(checkIfPrintSeqNoExist(wcPrintSeqNo)){
			showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
			$("printSeqNumber").clear();
			$("printSeqNumber").focus();
		}
		$("printSeqNumber").value = parseInt(this.value);
	});
	
	$("editWarrantyText").observe("click", function () {
		showEditor2("warrantyText", 34000, "Confirm", "Do you really want to change this text?", resetText, checkChangeTag);
	});
	
	$("warrantyText").observe("change", function(){
		if(!$("changeTag").checked){
			showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No",
						    function(){
			    				$("changeTag").checked = true;
			    				limitText($("warrantyText"), 34000);
							},
							function(){
								$("warrantyText").value = $F("hidOrigWarrantyText");
								limitText($("warrantyText"), 34000);
							});
		}else{
			limitText($("warrantyText"), 34000);
		}
	});
	
	$("editWcRemarks").observe("click", function(){
		showEditor("inputWcRemarks", 2000);
	});
	
	$("editWarrantyTitle2").observe("click", function(){
		showEditor("warrantyTitle2", 100);
	});
	
	$("warrantyText").observe("keyup", function(){
		limitText(this, 34000);
	});

	$("inputWcRemarks").observe("keyup", function(){
		limitText(this, 2000);
	});

	$("warrantyTitle2").observe("change", function(){
		limitText(this, 2000);
	});
	
	$("btnAdd").observe("click", addQWC);
	$("btnDelete").observe("click", delQWC);
	$("btnSaveQuotationWC").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveQWC();
		}
	});
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){ // Patrick
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					saveQWC();
					if(cond2){
						hideNotice();
						showQuotationListing();
					}
			}, 
				function(){
					changeTag = 0;
					showQuotationListing(); 
			},"");
		}else {
			showQuotationListing();
		}
	});
</script>