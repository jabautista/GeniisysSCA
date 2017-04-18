<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="warrantyAndClauseMainDiv" name="warrantyAndClauseMainDiv"	style="margin-top: 1px; display: none;">
	<div id="message" style="display: none;">${message}</div>
	<div></div>
	<form id="warrantyAndClauseForm" name="warrantyAndClauseForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv"	name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label>Warranties and Clauses</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="warrantyAndClauseDiv" name="warrantyAndClauseDiv" class="sectionDiv">
			<jsp:include page="/pages/underwriting/par/warrantyAndClauses/warrantyAndClausesTable.jsp"></jsp:include>
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px;" changeTagAttr="true">
				<table align="center">
					<tr style="display: none;" id="message" name="message">
						<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Title</td>
						<td colspan="4" class="leftAligned">
							<span class="required lovSpan" style="width: 430px;">
								<input type="hidden" id="hidWcCd" name="hidWcCd"> 
								<input type="hidden" id="hidWcCd2" name="hidWcCd2"> 
								<input type="hidden" id="hidRecFlag" name="hidRecFlag"> 								
								<input type="text" id="txtWarrantyTitle" name="txtWarrantyTitle" style="width: 405px; float: left; border: none; height: 13px; margin: 0;" class="required" readonly="readonly" maxlength="100"></input>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarrantyTitle" name="btnWarrantyTitle" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td class="leftAligned" colspan="3">
							<div style="border: 1px solid gray; height: 20px; width: 200px;">
								<textarea type="text" id="inputWarrantyTitle2" name="inputWarrantyTitle2" style="width: 171px; height: 13px; border: none;" maxlength="100"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyTitle2" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Type</td>
						<td class="leftAligned" width="120px;"><input type="text" id="inputWarrantyType" name="inputWarrantyType" style="width: 100px;" readonly="readonly"></input></td>
						<td class="rightAligned">Print Sequence No. </td>
						<td class="leftAligned"><input type="text" id="inputPrintSeqNo" class="required integerNoNegativeUnformatted" maxlength="2" style="width: 40px;" errorMsg="Invalid Print Sequence No. Value should be from 1 to 99."/></td>
						<td class="rigthAligned">Print Switch</td>
						<td class="leftAligned"><input type="checkbox" id="inputPrintSwitch" name="inputPrintSwitch" value="Y"></td>
						<td class="rightAligned">Change Tag</td>
						<td class="leftAligned" width="60px;"><input type="checkbox" id="inputChangeTag" name="inputChangeTag" value="Y"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Text</td>
						<td colspan="7" class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 642px;">
								<input type="hidden" id="hidOrigWarrantyText" name="hidOrigWarrantyText" style="width: 610px; border: none; height: 13px;"></input>
								<textarea id="inputWarrantyText" name="inputWarrantyText" style="width: 610px; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
							</div>
						</td>
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
				<div style="width: 100%; margin: 10px 0;" align="center" >
					<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
					<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" disabled="disabled" />
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnCancel" value="Cancel">
						<input type="button" class="button" id="btnSave" value="Save">
					</td>
				</tr>
			</table>		
		</div>
	</form>
</div>

<script type="text/javascript">
		try{
			var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
			var pAction = pageActions.none;
			var currentRow = -1;
			var changeTextSw = "N";
			var lastRowNo = 0;
			var cond2 = true;
			var totalRecords = 0;
			var maxDb = 0;
			var userId = '${userId}';
			disableMenu("distribution");
			var riSwitch = $F("globalIssCd") == "RI" ? "Y" : "";
			initializeAccordion();
			addStyleToInputs();
			initializeAll();
			parType = '${parType}';
			changeTag = 0;
			initializeChangeTagBehavior(saveGIPIWPolWC);
			initializeChangeAttribute();
			hideNotice();
		}catch (e) {
			showErrorMessage("Initialize", e);
		}
		
		try{
			if(parType == "P") {
				setDocumentTitle("Warranties and Clauses Entry - Policy");
				setModuleId("GIPIS024");
			} else if (parType == "E"){
				setDocumentTitle("Warranties and Clauses Entry - Endorsement");
				setModuleId("GIPIS035");
				//$("print").hide();  //hides print in the menu -- temporarily removed by robert 01.29.2014
			}
			
		}catch (e) {
			showErrorMessage("Policy or Endorsement Condition", e);
		}

	
		
		try{
			var objPolWarrCla = [];
 			var objWarrClauses = new Object();
			objWarrClauses.objWarrClausesTableGrid = JSON.parse('${objWarrClauses}');
			objWarrClauses.warrClauses = objWarrClauses.objWarrClausesTableGrid.rows || [];
			
			var policyWarrClaTableModel = {
				url : contextPath+"/GIPIWPolicyWarrantyAndClauseController?action=showWPolWarrAndClausePageTableGrid&globalLineCd="+$F("globalLineCd")+"&globalParId="+$F("globalParId"),
				options: {
					hideColumnChildTitle: true,
					height: '250px',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = polWarrClaTableGrid.geniisysRows[y];
// 						$("searchWarrantyTitle").hide();
						$("btnAdd").value="Update";
						enableButton("btnDelete");
						$("txtWarrantyTitle").readOnly=false;
						if (obj.recordStatus===""){
							disableSearch("searchWarrantyTitle");
							$("txtWarrantyTitle").readOnly=true; 
						}else{
							enableSearch("searchWarrantyTitle");
							$("txtWarrantyTitle").readOnly=false; 
						}
						obj.recordStatus===""?disableSearch("searchWarrantyTitle"):enableSearch("searchWarrantyTitle");
						populateWarrantyAndClauseForm(obj);
						polWarrClaTableGrid.keys.releaseKeys();
					},
					onCellBlur: function(element, value, x, y, id) {
						observeChangeTagInTableGrid(polWarrClaTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id){
						formatAppearance();
					},
					//marco - 04.11.2013 - added validation properties for filter
					masterDetail: true,
					masterDetailRequireSaving: true,
					masterDetailValidation : function(){
						if(getAddedAndModifiedJSONObjects(objPolWarrCla).length > 0 || getDeletedJSONObjects(objPolWarrCla).length > 0){
							return true;
						}else{
							return false;
						}
					},
					masterDetailNoFunc: function(){
						formatAppearance();
					},
					//end - 04.11.2013
					onSort: function() {
						formatAppearance();
					},
					beforeSort: function(){
						if(changeTag == 1){
							showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
									function(){
										pAction = pageActions.reload;
										saveGIPIWPolWC();
									}, function(){
										showWPolicyWarrantyAndClausePage();
										changeTag = 0;
									}, "");
							return false;
						}else{
							return true;
						}
					},
					postPager: function () {
						formatAppearance();
					},
					toolbar : {
						elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onRefresh: function(){
							formatAppearance();
						},
						onFilter: function(){
							formatAppearance();
						}
					}
				},
				columnModel: [
					{
						id: 'recordStatus',
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
								    	align: 'left',
								    	filterOption: true,	
										title:'Warranty Title'
								    },
								    {	id: 'wcTitle2',
								    	align: 'left',
								    	width: 100
								    }
					   	]
					},
					{
						id: 'wcSw',
						title: 'Type',
						width: '85px',
						align: 'left',
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
						id: 'wcTexts',
						title: 'Warranty Text',
						width: '365px',
						renderer: function(value){
							if (value == null){
								return '-';
							} else {
								return value;
							}
						}
					},
					{
						id: 'wcText1',
						width: '0',
						visible: false
					},
					{
						id: 'wcText2',
						width: '0',
						visible: false
					},
					{
						id: 'wcText3',
						width: '0',
						visible: false
					},
					{
						id: 'wcText4',
						width: '0',
						visible: false
					},
					{
						id: 'wcText5',
						width: '0',
						visible: false
					},
					{
						id: 'wcText6',
						width: '0',
						visible: false
					},
					{
						id: 'wcText7',
						width: '0',
						visible: false
					},
					{
						id: 'wcText8',
						width: '0',
						visible: false
					},
					{
						id: 'wcText9',
						width: '0',
						visible: false
					},
					{
						id: 'wcText10',
						width: '0',
						visible: false
					},
					{
						id: 'wcText11',
						width: '0',
						visible: false
					},
					{
						id: 'wcText12',
						width: '0',
						visible: false
					},
					{
						id: 'wcText13',
						width: '0',
						visible: false
					},
					{
						id: 'wcText14',
						width: '0',
						visible: false
					},
					{
						id: 'wcText15',
						width: '0',
						visible: false
					},
					{
						id: 'wcText16',
						width: '0',
						visible: false
					},
					{
						id: 'wcText17',
						width: '0',
						visible: false
					},
					{
						id: 'parId',
						width: '0',
						visible: false
					},
					{
						id: 'wcCd',
						width: '0',
						visible: false
					},
					{
						id: 'recFlag',
						width: '0',
						visible: false
					},
					{
						id: 'serialversionuid',
						width: '0',
						visible: false,
						
					},
					{
						id: 'lineCd',
						width: '0',
						visible: false
					},
					{
						id: 'printSw',
						width: '0',
						visible: false
					},
					{
						id: 'changeTag',
						width: '0',
						visible: false
					},
					{
						id: 'tbgPrintSw',
						title: 'P',
						width: '30px',
						tooltip: 'P',
						align: 'center',
						titleAlign: 'center',
						editable: false,
						editor:	 'checkbox',
						sortable:false
					},
					{
						id: 'tbgChangeTag',
						title: 'C',
						width: '30px',
						tooltip: 'C',
						align: 'center',
						titleAlign: 'center',
						editable: false,
						editor:	 'checkbox',
						sortable:false
					}
				],
				rows: objWarrClauses.warrClauses
			};
			
			polWarrClaTableGrid = new MyTableGrid(policyWarrClaTableModel);
			polWarrClaTableGrid.pager = objWarrClauses.objWarrClausesTableGrid;
			polWarrClaTableGrid.render('polWarrClaTableGrid');
			polWarrClaTableGrid.afterRender = function(){
															objPolWarrCla=polWarrClaTableGrid.geniisysRows;
															if(polWarrClaTableGrid.geniisysRows.length != 0){
																maxDb = polWarrClaTableGrid.geniisysRows[0].maxPrintSeqNo;
																totalRecords = polWarrClaTableGrid.geniisysRows[0].rowCount;
															}
														};
	} catch(e){
		showErrorMessage("Policy Warranties and Clauses TableGrid", e);
	}

	function populateWarrantyAndClauseForm(obj){
		try{
			$("hidWcCd2").value 			= obj			== null ? "" : nvl(obj.wcCd,"");
			$("hidWcCd").value 				= obj			== null ? "" : nvl(obj.wcCd,"");
			$("txtWarrantyTitle").value 	= obj			== null ? "" : unescapeHTML2(nvl(obj.wcTitle,""));
			$("inputWarrantyTitle2").value 	= obj			== null ? "" : unescapeHTML2(nvl(obj.wcTitle2,""));
			$("inputWarrantyType").value 	= obj			== null ? "" : unescapeHTML2(nvl(obj.wcSw,""));
			$("inputPrintSeqNo").value 		= obj			== null ? "" : nvl(obj.printSeqNo,"");
			$("inputPrintSwitch").checked 	= obj			== null ? "" :(nvl(obj.printSw,"") 			== 'Y' ? true : false);
			$("inputChangeTag").checked 	= obj			== null ? "" :(nvl(obj.changeTag,"")		== 'Y' ? true : false);
			$("inputWarrantyText").value 	= obj 	 		== null ? "" : unescapeHTML2(nvl(obj.wcTexts,""));
			$("inputWcRemarks").value		= obj  			== null ? "" : unescapeHTML2(nvl(obj.wcRemarks,""));
			$("hidOrigWarrantyText").value  = obj  			== null ? "" : unescapeHTML2(nvl(obj.wcTexts,""));  
			$("hidRecFlag").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.recFlag,""));
		}catch(e){
			showErrorMessage("populateWarrantyAndClauseForm", e);
		}
	}

	function generatePrintSeqNo() {
		var max = 0;
		for(var i=0; i<objPolWarrCla.length; i++){
			if(parseInt(objPolWarrCla[i].printSeqNo) > max && objPolWarrCla[i].recordStatus != -1){
				max = parseInt(objPolWarrCla[i].printSeqNo);
			}
		}
		if(totalRecords>10){
			if (parseInt(maxDb) > parseInt(max)){
				max = parseInt(maxDb);
			}
		}
		return (parseInt(max) + 1);
	}
	
	function setWCObject(){
		try{
			var objWarrCla = new Object();
			var wcText= $("inputChangeTag").checked ? $F("inputWarrantyText"): $F("hidOrigWarrantyText");
			
			objWarrCla.wcCd 	= $F("hidWcCd"); //escapeHTML2($F("hidWcCd")); removed escapeHTML2 by robert SR 5155 11.04.15
			objWarrCla.wcCd2 	= $F("hidWcCd2"); //escapeHTML2($F("hidWcCd2")); removed escapeHTML2 by robert SR 5155 11.04.15
			//objWarrCla.parId	= parseInt(objUWGlobal.parId != null ? objUWGlobal.parId :  $F("globalParId"));
			objWarrCla.parId	= parseInt($F("globalParId") != null ? $F("globalParId") :  objUWGlobal.parId); //robert
			objWarrCla.lineCd 	= escapeHTML2(objUWGlobal.lineCd != null ? objUWGlobal.lineCd :  $F("globalLineCd"));
			objWarrCla.wcSw 	= escapeHTML2($("inputWarrantyType").value);
			objWarrCla.wcTitle 	= escapeHTML2($F("txtWarrantyTitle"));
			objWarrCla.wcTitle2 = escapeHTML2($("inputWarrantyTitle2").value);
			objWarrCla.wcRemarks = escapeHTML2($("inputWcRemarks").value);
			objWarrCla.wcTexts 	=	escapeHTML2(wcText);
			objWarrCla.wcText1 = escapeHTML2(wcText.substring(0,2000));
			objWarrCla.wcText2 = escapeHTML2(wcText.substring(2001,4000));
			objWarrCla.wcText3 = escapeHTML2(wcText.substring(4001,6000));
			objWarrCla.wcText4 = escapeHTML2(wcText.substring(6001,8000));
			objWarrCla.wcText5 = escapeHTML2(wcText.substring(8001,10000));
			objWarrCla.wcText6 = escapeHTML2(wcText.substring(10001,12000));
			objWarrCla.wcText7 = escapeHTML2(wcText.substring(12001,14000));
			objWarrCla.wcText8 = escapeHTML2(wcText.substring(14001,16000));
			objWarrCla.wcText9 = escapeHTML2(wcText.substring(16001,18000));
			objWarrCla.wcText10 = escapeHTML2(wcText.substring(18001,20000));
			objWarrCla.wcText11 = escapeHTML2(wcText.substring(20001,22000));
			objWarrCla.wcText12 = escapeHTML2(wcText.substring(22001,24000));
			objWarrCla.wcText13 = escapeHTML2(wcText.substring(24001,26000));
			objWarrCla.wcText14 = escapeHTML2(wcText.substring(26001,28000));
			objWarrCla.wcText15 = escapeHTML2(wcText.substring(28001,30000));
			objWarrCla.wcText16 = escapeHTML2(wcText.substring(30001,32000));
			objWarrCla.wcText17 = escapeHTML2(wcText.substring(32001,34000));
			objWarrCla.changeTag= $("inputChangeTag").checked ? "Y" : "N";
			objWarrCla.printSw 	= $("inputPrintSwitch").checked ? "Y" : "N";
			objWarrCla.tbgChangeTag= $("inputChangeTag").checked ? true : false;
			objWarrCla.tbgPrintSw 	= $("inputPrintSwitch").checked ? true : false;
			objWarrCla.printSeqNo= $("inputPrintSeqNo").value;
			objWarrCla.swcSeqNo	= 0;
			objWarrCla.recFlag  = 	nvl($("hidRecFlag").value,"");
			objWarrCla.userId	= userId;
			objWarrCla.recordStatus = "" ;
		
			return objWarrCla;
		}catch(e){
			showErrorMessage("setWCObject", e);
		}
	}
	
// 	function to add record
	function addPolWarrCla(){ 
		try{
				var newObj  = setWCObject();
				if(checkWCRequiredFields() && checkRemarksLength() && checkWarrantyTextLength()){
					if ($F("btnAdd") == "Update"){
						//on UPDATE records
						for(var i = 0; i<objPolWarrCla.length; i++){
							if ((objPolWarrCla[i].wcCd == newObj.wcCd2)&&(objPolWarrCla[i].recordStatus != -1)){
								newObj.recordStatus = 1;
								objPolWarrCla.splice(i, 1, newObj);
								polWarrClaTableGrid.updateVisibleRowOnly(newObj, polWarrClaTableGrid.getCurrentPosition()[1]);
							}
						}
					}else{
						//on ADD records
						newObj.recordStatus = 0;
						objPolWarrCla.push(newObj);
						polWarrClaTableGrid.addBottomRow(newObj);
					}
					changeTag = 1;
					formatAppearance();
				}
		}catch(e){
			showErrorMessage("addPolWarrCla", e);
		}
	}	
	
// 	function to delete record
	function deletePolWarrCla(){    
		try{
			var delObj = setWCObject();
			for(var i = 0; i<objPolWarrCla.length; i++){
				if ((objPolWarrCla[i].wcCd == delObj.wcCd2)&&(objPolWarrCla[i].recordStatus != -1)){
					delObj.recordStatus = -1;
					objPolWarrCla.splice(i, 1, delObj);
					polWarrClaTableGrid.deleteRow(polWarrClaTableGrid.getCurrentPosition()[1]);
					changeTag = 1;
				}
			}
			formatAppearance();
		} catch(e){
			showErrorMessage("deletePolWarrCla()", e);
		}
	}
	
// 	function to save records
		function saveGIPIWPolWC(){
		try{
			var objParameters = new Object();
				objParameters.setPolWarrCla = getAddedAndModifiedJSONObjects(objPolWarrCla);
				objParameters.delPolWarrCla = getDeletedJSONObjects(objPolWarrCla);
				
			 if(checkPendingRecord()){
				new Ajax.Request(contextPath+"/GIPIWPolicyWarrantyAndClauseController?action=saveGIPIWPolWCTableGrid",{
					method: "POST",
					asynchronous: true,
					parameters:{
						param: JSON.stringify(objParameters)
					},
					onCreate:function(){
						showNotice("Saving Warranties and Clauses, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							if(response.responseText == "SUCCESS"){
								if(pAction == pageActions.save){
									showWPolicyWarrantyAndClausePage();
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								}else if(pAction == pageActions.reload){
									showWPolicyWarrantyAndClausePage();
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								}else{
									 // getLineListingForPAR(riSwitch);
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								}
								clearObjectRecordStatus(objParameters); // added by: Nica 07.5.2012 - to reset record status
								changeTag = 0;
								lastAction();
								lastAction = "";
								formatAppearance();
								pAction = pageActions.none;
							}else{
								showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
							}
						}
					}
				});				
			}
		}catch(e){
			showErrorMessage("saveGIPIWPolWC", e);
		}
	}
	
	function checkExistingRecord(wcCd,swcSeqNo) {
		var policyNo = $F("policyNo").split("-");
		var lineCd		=	policyNo[0];
		var sublineCd	=	policyNo[1];
		var issCd		=	policyNo[2];
		var issueYY		=	policyNo[3];
		var polSeqNo	=	policyNo[4];
		new Ajax.Request(contextPath+"/GIPIWPolicyWarrantyAndClauseController?action=checkExistingRecord",{
			method: "POST",
			asynchronous: true,
			parameters:{
				lineCd:lineCd,
				sublineCd:sublineCd,
				issCd:issCd,
				issueYY:issueYY,
				wcCd: wcCd,
				polSeqNo:polSeqNo,
				swcSeqNo:swcSeqNo
			},
			onComplete: function(response){
				if (response.responseText == "Y"){
					showMessageBox("Warranty Code "+ wcCd + " already exists in policy/endorsement.",imgMessage.INFO);
				}		
			}
		});
	}
	
	function checkPendingRecord() {
		var cond = true;
		cond2 = true;
		if ($("btnAdd").value == "Update"){
			var message = "You have changes in Warranties and Clauses portion. Press Update button first to apply changes otherwise unselect the Warranties and Clauses record to clear changes.";
			showMessageBox(message);
			cond = false;
			cond2 = false;
		} else if($("txtWarrantyTitle").value != "" || $("inputWarrantyTitle2").value != "" || $("inputPrintSeqNo").value != "" || $("inputWarrantyType").value != "" || $("inputWarrantyText").value != "" || $("inputWcRemarks").value != ""){  
			var message = "You have changes in Warranties and Clauses portion. Press Add button first to apply changes.";
			showMessageBox(message);
			cond = false;
			cond2 = false;
		}
		
		return cond;
	}
	
	function checkChangeTag() {
		$("inputChangeTag").checked = true;
	}

	function resetText() {
		try{
			var defaultText = "";
			if($F("inputWarrantyText") != ""){
				defaultText = $F("hidOrigWarrantyText");
			}
			$("inputWarrantyText").value = defaultText;
			$("inputChangeTag").checked = false;
		}catch(e){
			showErrorMessage("resetText", e);
		}
	}

	function checkWCRequiredFields(){
		try{
			var isOk = true;
			var fields = ["txtWarrantyTitle", "inputPrintSeqNo"];
	
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

	function checkWarrantyTextLength(){
		try{
			var isNotLimit = true;
			if($("inputWarrantyText").value.length > 34000){
				showMessageBox('You have exceeded the maximum number of allowed characters (34000) for Warranty Text field.', imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		}catch(e){
			showErrorMessage("checkWarrantyTextLength", e);
		}
	}

	function checkIfPrintSeqNoExist(printSeqNo){
		try{
			var exist = false;
	
			for(var i=0; i<objPolWarrCla.length; i++){
				if(parseInt(printSeqNo) == parseInt(objPolWarrCla[i].printSeqNo) && objPolWarrCla[i].recordStatus != -1){
					exist = true;
				}
			}
			if(!exist){
				new Ajax.Request(contextPath+"/GIPIWPolicyWarrantyAndClauseController?action=validatePrintSeqNo",{
					method: "POST",
					asynchronous: true,
					parameters:{
						printSeqNo: printSeqNo,
						parId: $F("globalParId"),
						lineCd: $F("globalLineCd")
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							if(response.responseText == "Y"){
								showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
								$("inputPrintSeqNo").clear();
								$("inputPrintSeqNo").focus();
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

	function formatAppearance() {
		try{
			$("btnAdd").value="Add";
			disableButton("btnDelete");
			enableSearch("searchWarrantyTitle");
			populateWarrantyAndClauseForm(null);
			$("txtWarrantyTitle").readOnly=true; 
			polWarrClaTableGrid.keys.releaseKeys();
		}catch (e) {
			showErrorMessage("formatAppearance",e);
		}
	}
	
	/* observe */
	
	$("editWarrantyText").observe("click", function () {
		//showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", resetText, checkChangeTag);
		showOverlayEditor("inputWarrantyText", 34000,  $("inputWarrantyText").hasAttribute("readonly"), 
				function () {
						var textarea =  $("textarea").value;
						showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No", function() {
								$("inputWarrantyText").value = textarea;
								checkChangeTag();
							},resetText);
				});
	});

	$("editWcRemarks").observe("click", function(){
		showOverlayEditor("inputWcRemarks", 2000,'false');
	});
	
	$("editWarrantyTitle2").observe("click", function(){
		showOverlayEditor("inputWarrantyTitle2", 100,'false');
	});

	$("inputWarrantyText").observe("keyup", function(){
		limitText(this, 34000);
	});

	$("inputWcRemarks").observe("keyup", function(){
		limitText(this, 2000);
	});

	$("inputWcRemarks").observe("change", function(){
		limitText(this, 2000);
	});

	$("inputWarrantyText").observe("change", function(){
		if(!$("inputChangeTag").checked){
			showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No",
						    function(){
			    				$("inputChangeTag").checked = true;
			    				limitText($("inputWarrantyText"), 34000);
							},
							function(){
								$("inputWarrantyText").value = $F("hidOrigWarrantyText");
								limitText($("inputWarrantyText"), 34000);
							});
		}else{
			limitText($("inputWarrantyText"), 34000);
		}
	});

	$("inputPrintSeqNo").observe("change", function(){
		var wcPrintSeqNo 	= this.value;
		if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".") || isNaN(parseFloat(wcPrintSeqNo))) {
			showMessageBox("Invalid Print Sequence No. Value should be from 1 to 99.");
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}else if(checkIfPrintSeqNoExist(wcPrintSeqNo)){
			showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}
		$("inputPrintSeqNo").value = parseInt(this.value);
	});

	$("btnAdd").observe("click", function(){
		if($F("inputPrintSeqNo") > 99){
			customShowMessageBox("Invalid Print Sequence No. Value should be from 1 to 99.", "E", "inputPrintSeqNo");
			$("inputPrintSeqNo").clear();
		}else{
			if(parType == "P") {
				addPolWarrCla();
			}else if (parType == "E"){
				if(this.value=="Add"){
					checkExistingRecord($F("hidWcCd"),0);
				}
				addPolWarrCla();
			}
		}
	});

	$("btnDelete").observe("click", function(){
		deletePolWarrCla();
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			pAction = pageActions.save;
			saveGIPIWPolWC();
		}
	});

// 	$("btnCancel").observe("click", function(){
// 		pAction = pageActions.cancel;
// 		fireEvent($("parExit"), "click");
// 	});

	$("reloadForm").observe("click", function(){
		if(changeTag == 1){
			pAction = pageActions.reload;
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					showWPolicyWarrantyAndClausePage, "");
		}else{
			showWPolicyWarrantyAndClausePage();
		}
	});
	
	$("searchWarrantyTitle").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		for ( var i = 0; i < objPolWarrCla.length; i++) {
			if (objPolWarrCla[i].recordStatus != -1) {
				if(withPrevious) notIn += ",";
				notIn += "'"+(objPolWarrCla[i].wcCd).replace(/&#38;/g,'&')+"'";
				withPrevious = true;
			}
		}
		notIn = (notIn != "" ? "("+notIn+")" : "");
		showWarrantyAndClauseLOV($F("globalLineCd"), notIn, $("btnAdd").value==="Update"?$F("inputPrintSeqNo") : generatePrintSeqNo());	
	});
	
	$("btnCancel").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("btnCancel").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGIPIWPolWC();
						if(cond2){
							objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing() : showParListing(); 
						}
					}, function(){
						objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing() : showParListing(); 
						changeTag = 0;
					}, "");
		}else{
			objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing() : showParListing(); 
		}
	});
	
	$("parExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("parExit").observe("click", function(){
		var riSwitch = $F("globalIssCd") == "RI" ? "Y" : ""; //added by jeffdojello 04182013
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						saveGIPIWPolWC();
						if(cond2){
							objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing(riSwitch) : showParListing(riSwitch); //riSwitch parameter added by jeffdojello 04182013
						}
					}, function(){
						objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing(riSwitch) : showParListing(riSwitch); //riSwitch parameter added by jeffdojello 04182013
						changeTag = 0;
					}, "");
		}else{
			objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing(riSwitch) : showParListing(riSwitch); //riSwitch parameter added by jeffdojello 04182013
		}
	});
</script>


