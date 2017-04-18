<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<div id="contentsDiv">
	<div style="padding-top: 10px; height: 365px; background-color: #ffffff;" id="binderListDiv" >
	</div>
	
	<div id="divB" align="center" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 60px;"/>
		<input type="button" id="btnModalCancel" class="button" value="Cancel" style="width: 60px;"/>
	</div>
</div>
<script>
	try{
		var tempTranType = $F("tranType"); // andrew - hold the selected tranType
		var tempRiName = $F("reinsurer"); // andrew - hold the selected riName
		var tempRiCd = $F("hiddenRiCd"); // andrew - hold the selected riCd
		var objCurrFacul;
		var modifiedRows = null;
		var objOutFaculPremPayts = JSON.parse('${objBinderLov}'.replace(/\\/g, "\\\\"));
		var objOutFaculPremPaytsArray=[];
		var objCheckBoxArray=[];
		var lineCd = $F("faculPremLineCd");	// added by steven 10.03.2014
		if (objACGlobal.previousModule == 'GIACS016'){
			lineCd = (lineCd.trim() == "" || lineCd == objGIACS002.lineCd ? objGIACS002.lineCd : $F("faculPremLineCd"));
		}
		var tranType = $("tranType").options[$("tranType").selectedIndex].value;	// SR-19631 : shan 08.19.2015
		initializeOutFaculPremPaytsTable(objOutFaculPremPayts);
	}catch (e) {
		showErrorMessage("Intialize",e);
	}
	
	/**
	 * @author tonio
	 * @date February 15, 2011
	 * @description Initializes the grid table
	 * @param objOutFaculPremPayts - array of user events json
	 */
	function initializeOutFaculPremPaytsTable(objOutFaculPremPayts){
		try {
			var outFaculPremPaytsTable = {
					url: contextPath+"/GIACOutFaculPremPaytsController?action=openSearchBinderModal2&tranType=" + $("tranType").options[$("tranType").selectedIndex].value + "&riCd=" + $F("hiddenRiCd") + "&lineCd=" + lineCd/* $F("faculPremLineCd") */ + "&binderYY=" +  $F("faculPremBinderYY") + "&gaccTranId=" + objACGlobal.gaccTranId + "&moduleId=" + "GIACS019&notIn="+objAC.hidObjGIACS019.notIn,
					options: {
						width: '675px',
						pager: {
						},
						toolbar: {
							elements: [MyTableGrid.FILTER_BTN,MyTableGrid.REFRESH_BTN],
							onRefresh: function(){
								tbgOutFaculPremPayts.keys.releaseKeys();
							},
							onFilter: function(){
								tbgOutFaculPremPayts.keys.releaseKeys();
							}
						},					
						onCellFocus : function(element, value, x, y, id) {
							tbgOutFaculPremPayts.getRow(tbgOutFaculPremPayts.getCurrentPosition()[1]).recordStatus = false;
							if (tbgOutFaculPremPayts.getRow(tbgOutFaculPremPayts.getCurrentPosition()[1]).recordStatus == true && tbgOutFaculPremPayts.getRow(tbgOutFaculPremPayts.getCurrentPosition()[1]).message != null ){
								showMessageBox(tbgOutFaculPremPayts.getRow(tbgOutFaculPremPayts.getCurrentPosition()[1]).message, imgMessage.INFO);		
							}
							if ($('mtgInput2_0,'+y).checked == true) {
								if (tbgOutFaculPremPayts.getRow(tbgOutFaculPremPayts.getCurrentPosition()[1]).recordStatus == true 
										&& tbgOutFaculPremPayts.getRow(tbgOutFaculPremPayts.getCurrentPosition()[1]).message == "RI premium payment transaction related to this invoice is still open."){
									$('mtgInput2_0,'+y).checked = false;	// SR-19631 : shan 08.24.2015
								}else{
									objCheckBoxArray.push(objOutFaculPremPaytsArray[y]);
								}
							 }else if($('mtgInput2_0,'+y).checked == false){
								 for (var i=0; i<objCheckBoxArray.length; i++){
										if (objCheckBoxArray[i].binderId === objOutFaculPremPaytsArray[y].binderId) {
											objCheckBoxArray.splice(i, 1);
										 }
									}
							 }
							tbgOutFaculPremPayts.keys.releaseKeys();
						},
						onRemoveRowFocus : function() {
							tbgOutFaculPremPayts.keys.releaseKeys();
						}
					},									
					columnModel: [
			  			{ 						
			  				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
						 	title: '&#160;I',
						 	altTitle: 'Include?',
							width: 23,
							sortable: false,
							editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
							//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
							//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
							editor: 'checkbox',
							hideSelectAllBox: true					  			
						},
						{
							id: 'divCtrId',
							width: '0',
							visible: false 
						},		
// 						{
// 							id: 'incTag',
// 							title: '&nbsp;&nbsp;I',
// 							titleAlign: 'center',
// 							editor: 'checkbox',
// 							width: 23,
// 							align: 'center',
// 							editable: true,
// 							visible: true,
// 							editor: new MyTableGrid.CellCheckbox({
// 								onClick: function (value, checked) {
// 								modifiedRows = tbgOutFaculPremPayts.getModifiedRows();
// 								}
							
// 							}) 
// 						},							
						{
							id : "lineCd",
							title: "Line Cd",
							width: '50',
							visible: true,
							align: "center",
							filterOption: true	
						},
						{
							id : "binderYY",
							title: "Binder Year",
							width: '70',
							visible: true,
							align: "center",
							filterOption: true,
							filterOptionType: "integerNoNegative"	
						},
						{
							id : "binderSeqNo",
							title: "Binder Seq#",
							width: '90',
							visible: true,
							align: "right",
							filterOption: true,
							filterOptionType: "integerNoNegative"
						},
						{
							id : 'policyNo',
							title: "Policy No. / Endorsement No.",
							width: '250',
							visible: true,
							align: 'left'
						},
						{
							id : 'disbursementAmt',
							width: '0',
							visible: false  
						},
						{
							id : 'disbursementAmtLocal',
							title: 'Disbursement',
							width: '100',
							visible: true,
							align: 'right',
							geniisysClass: 'money'
							
						},
						{
							id : 'refNo',
							title: "Reference No.",
							width: (tranType == 2 || tranType == 4) ? '150' : '0',
							visible: (tranType == 2 || tranType == 4) ? true : false,
							align: 'left'
						},
						{
							id: 'assdName',
							width: '0',
							visible: false 
						},
						{
							id: 'remarks',
							width: '0',
							visible: false 
						},
						{
							id: 'message',
							width: '0',
							visible: false 
						},
						{
							id: 'binderId',
							width: '0',
							visible: false 
						},
						{
							id: 'premAmt',
							width: '0',
							visible: false 
						},
						{
							id: 'premVat',
							width: '0',
							visible: false 
						},
						{
							id: 'commAmt',
							width: '0',
							visible: false 
						},
						{
							id: 'commVat',
							width: '0',
							visible: false 
						},
						{
							id: 'wholdingVat',
							width: '0',
							visible: false 
						},
						{
							id: 'currencyCd',
							width: '0',
							visible: false 
						},
						{
							id: 'currencyRt',
							width: '0',
							visible: false 
						},
						{
							id: 'riCd',
							width: '0',
							visible: false 
						},
						{
							id: 'tranType',
							width: '0',
							visible: false 
						},
						{
							id: 'assdNo',
							width: '0',
							visible: false 
						}			
								
															
						
					],
					rows: objOutFaculPremPayts.rows
				};
			tbgOutFaculPremPayts = new MyTableGrid(outFaculPremPaytsTable);
			tbgOutFaculPremPayts.pager = objOutFaculPremPayts;
			tbgOutFaculPremPayts.render('binderListDiv');
			tbgOutFaculPremPayts.afterRender = function(){
					objOutFaculPremPaytsArray=tbgOutFaculPremPayts.geniisysRows;
					for (var i=0; i<objCheckBoxArray.length; i++){
						for ( var j = 0; j < objOutFaculPremPaytsArray.length; j++) {
							if (objCheckBoxArray[i].binderId === objOutFaculPremPaytsArray[j].binderId) {
								 $('mtgInput2_0,'+j).checked = true;
							 }
						}
					}
				};
		} catch(e){
			showErrorMessage("initializeOutFaculPremPaytsTable", e);
		}
	}

	function setCheckedItems(binderId, y){
		if (objAC.currModifiedRows != null ){
			for (var i=0; i<objAC.currModifiedRows.length; i++){
				if (objAC.currModifiedRows[i].binderId == binderId && objAC.currModifiedRows[i].recordStatus != -1){
					$("mtgInput1_2," + y).setAttribute("checked", "yes");
					$("mtgInput1_2," + y).disabled = true;
					break;
				} 
			}
		}
	}

	/** 
	 * @author 		tonio
	 * @date 		02.16.2011
	 * @description	Executes the necessary functions when a row is selected * 
	 * @param 		rowIndex - index of selected row
	 * 				element - the selected row
	 */
// 	function doOutFaculPremCellFocus(element, rowIndex){
// 		try {
// 			if(element.hasClassName("selectedRow")){
// 				objCurrFacul = tbgOutFaculPremPayts.getRow(rowIndex);
// 			} 
// 		} catch (e){
// 			showErrorMessage("doOutFaculPremCellFocus", e);
// 		}
// 	}

// 	function setSelectedValues(obj){
// 		$("binderNo").value = obj.lineCd + "-" + obj.binderYY + "-" + obj.binderSeqNo;
// 		$("amount").value = formatCurrency(obj.disbursementAmt);
// 		$("policyNo").value = obj.policyNo;	
// 		$("assuredName").value = obj.assdName;
// 	}
	
	function populateBinderDetails(obj,i) {
		$("hiddenBinderId").value		=	obj[i].binderId;
		$("faculPremLineCd").value		=	obj[i].lineCd;
		$("faculPremBinderYY").value	=	obj[i].binderYY;
		$("binderSeqNo").value			=	obj[i].binderSeqNo;
		$("assuredName").value			=	obj[i].assdName;
		$("hiddenAssdNo").value			=	obj[i].assdNo;
		$("policyNo").value				=	obj[i].policyNo;
		$("remarks").value				=	obj[i].remarks;	
		$("amount").value				=	obj[i].disbursementAmtLocal; //added by steven 11.26.2014
		$("hiddenCurrencyCd").value		= 	obj[i].currencyCd;
		$("hiddenPremAmt").value		=	obj[i].premAmt;
		$("hiddenPremVat").value		=	obj[i].premVat;
		$("hiddenCommAmt").value		=	obj[i].commAmt;
		$("hiddenCommVat").value		=	obj[i].commVat;	
		$("hiddenwHoldingTax").value	=	obj[i].wholdingVat;
		$("hiddenCurrencyRt").value		= 	obj[i].currencyRt;
		$("hiddenCurrencyDesc").value	= 	obj[i].currencyDesc;
		$("hiddenForeignCurrAmt").value	= 	unformatCurrency("amount") / obj[i].currencyRt;
		$("hiddenPaytGaccTranId").value = 	obj[i].paytGaccTranId; // SR-19631 : shan 08.17.2015
		if (obj[i].message === "There is still no premium payment for this policy. "){
		//it will not show any message.	
		}else if (obj[i].message!==null) {
			showMessageBox("No collection has been made for this binder. Will now override default computation.",imgMessage.INFO);
		} 
	}

	objAC.hidObjGIACS019.addedLovRecSize = 0;
	
	function populateOverride() {
		try {			
			objAC.hidObjGIACS019.selectedLovRecSize = objCheckBoxArray.length;
			
			for ( var i = 0; i <objCheckBoxArray.length; i++) {
				$("tranType").value = tempTranType;
				$("reinsurer").value = tempRiName;
				$("hiddenRiCd").value = tempRiCd;
				
				objAC.hidObjGIACS019.getOverrideDetails(tempTranType, tempRiCd,objCheckBoxArray[i].lineCd,objCheckBoxArray[i].binderYY,objCheckBoxArray[i].binderSeqNo);				
				
/* 				var obj = objAC.hidObjGIACS019.getOverrideDetails(objAC.hidObjGIACS019.tranType,objAC.hidObjGIACS019.riCd,objCheckBoxArray[i].lineCd,objCheckBoxArray[i].binderYY,objCheckBoxArray[i].binderSeqNo);
				$("hiddenBinderId").value		=	obj.binderId;
				$("faculPremLineCd").value		=	obj.lineCd;
				$("faculPremBinderYY").value	=	obj.binderYY;
				$("binderSeqNo").value			=	obj.binderSeqNo;
				$("assuredName").value			=	obj.assdName;
				$("hiddenAssdNo").value			=	obj.assdNo;
				$("policyNo").value				=	obj.policyNo;
				$("remarks").value				=	obj.remarks;	
				$("amount").value				=	obj.disbursementAmt * obj.currencyRt;
				$("hiddenCurrencyCd").value		= 	obj.currencyCd;
				$("hiddenPremAmt").value		=	obj.premAmt;
				$("hiddenPremVat").value		=	obj.premVat;
				$("hiddenCommAmt").value		=	obj.commAmt;
				$("hiddenCommVat").value		=	obj.commVat;	
				$("hiddenwHoldingTax").value	=	obj.wholdingVat;
				$("hiddenCurrencyRt").value		= 	obj.currencyRt;
				$("hiddenCurrencyDesc").value	= 	obj.currencyDesc;
				$("hiddenForeignCurrAmt").value	= 	unformatCurrency("amount") / obj.currencyRt;
				objAC.hidObjGIACS019.addOutFaculPremPayts();
				//hideOverlay();
				tbgOutFaculPremPayts.keys.releaseKeys();
				overlaySearchBinder.close(); */
			}
		} catch(e){
			showErrorMessage("populateOverride", e);
		}
	}
	objAC.hidObjGIACS019.populateOverride = populateOverride;

	/* OBSERVE ITEMS */
	
	$("btnOk").observe("click", function () {
		try{
			objAC.hidObjGIACS019.tranType 		= $F("tranType");
			objAC.hidObjGIACS019.riName			= $F("reinsurer");
			objAC.hidObjGIACS019.riCd			= $F("hiddenRiCd");
				for (var i=0; i<objCheckBoxArray.length; i++){
					if(objCheckBoxArray[i].disbursementAmt > 0 && (objAC.hidObjGIACS019.tranType==1 || objAC.hidObjGIACS019.tranType==4) &&(objCheckBoxArray[i].message==="No collection has been made for this binder." || objCheckBoxArray[i].message===null || objCheckBoxArray[i].message==="")){
						if (!objAC.hidObjGIACS019.checkIfBinderExistInList(objCheckBoxArray[i].binderId)){
							populateBinderDetails(objCheckBoxArray,i);
							objAC.hidObjGIACS019.addOutFaculPremPayts();
							tbgOutFaculPremPayts.keys.releaseKeys();
							overlaySearchBinder.close();
						}
					}else if(objCheckBoxArray[i].message === "There is still no premium payment for this policy. " && (objAC.hidObjGIACS019.tranType==1 || objAC.hidObjGIACS019.tranType==4)){
						objAC.hidObjGIACS019.tempCnt=i;
						objAC.hidObjGIACS019.cond = 1;
						tbgOutFaculPremPayts.keys.releaseKeys();
						if (!objAC.overideOk){
							showConfirmBox("CONFIRMATION", "There is still no premium payment for this policy,Do you want to continue facultative premium payment?", "Yes","No", 
									function (){
										showConfirmBox("CONFIRMATION", "You are not allowed to process this transaction. However you can override by pressing OK button.", "OK","Cancel", 
												function (){
													if (!objAC.hidObjGIACS019.checkIfBinderExistInList(objCheckBoxArray[objAC.hidObjGIACS019.tempCnt].binderId)){
														objAC.hidObjGIACS019.override();
													}
												},
												function (){
													tbgOutFaculPremPayts.keys.releaseKeys();
													objAC.hidObjGIACS019.formatAppearance("hide");
													overlaySearchBinder.close();
												});
									},
									function (){
										tbgOutFaculPremPayts.keys.releaseKeys();
										objAC.hidObjGIACS019.formatAppearance("hide");
										overlaySearchBinder.close();
									});
						}else{
							populateBinderDetails(objCheckBoxArray,i);
							objAC.hidObjGIACS019.addOutFaculPremPayts();
							tbgOutFaculPremPayts.keys.releaseKeys();
							overlaySearchBinder.close();
						}
					}else if((objCheckBoxArray[i].disbursementAmt <= 0 || objCheckBoxArray[i].message === "This Binder has been fully paid." || objCheckBoxArray[i].message === null)  && (objAC.hidObjGIACS019.tranType==1 || objAC.hidObjGIACS019.tranType==4)){
						showMessageBox("This Binder has been fully paid.",imgMessage.INFO);
						tbgOutFaculPremPayts.keys.releaseKeys();
						overlaySearchBinder.close();
					}else if(objCheckBoxArray[i].disbursementAmt < 0 && (objAC.hidObjGIACS019.tranType==2 || objAC.hidObjGIACS019.tranType==3)){
						if (!objAC.hidObjGIACS019.checkIfBinderExistInList(objCheckBoxArray[i].binderId)){
							populateBinderDetails(objCheckBoxArray,i);
							objAC.hidObjGIACS019.addOutFaculPremPayts();
							tbgOutFaculPremPayts.keys.releaseKeys();
							overlaySearchBinder.close();
						}
					}else if(objCheckBoxArray[i].disbursementAmt >= 0 && (objAC.hidObjGIACS019.tranType==2 || objAC.hidObjGIACS019.tranType==3)){
						showMessageBox("Positive amount for entered Binder No.",imgMessage.INFO);
						tbgOutFaculPremPayts.keys.releaseKeys();
						overlaySearchBinder.close();
					}else{
						showMessageBox(objCheckBoxArray[i].message,imgMessage.INFO);
						tbgOutFaculPremPayts.keys.releaseKeys();
						overlaySearchBinder.close();
					}
					if (i==objCheckBoxArray.length-1){
						objAC.hidObjGIACS019.tranType = null;
						objAC.hidObjGIACS019.riName = null;
						objAC.hidObjGIACS019.riCd = null;
					}
				 }
				if(objCheckBoxArray.length==0){
					tbgOutFaculPremPayts.keys.releaseKeys();
					overlaySearchBinder.close();
				}
		}catch (e) {
			showErrorMessage("btnOk function", e);
		}
	});

	$("btnModalCancel").observe("click", function () {
		tbgOutFaculPremPayts.keys.releaseKeys();
		overlaySearchBinder.close();
	});
	
/* 	$("close").observe("click", function () {
		overlaySearchBinder.close();
	}); */
	/* END OBSERVE ITEMS */
</script>