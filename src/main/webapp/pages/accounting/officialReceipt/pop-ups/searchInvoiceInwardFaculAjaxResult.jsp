<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div id="invoiceListGrid" style="position:relative; height:360px;"></div>
<script type="text/javascript">
	objAC.hidObjAC008.invoiceListTableGrid = JSON.parse('${invoiceListTableGrid}'.replace(/\\/g, '\\\\'));
	objAC.hidObjAC008.invoiceListRows = objAC.hidObjAC008.invoiceListTableGrid.rows || [];
	var objInwardFaculArray = []; //store previously checked records by MAC 03/21/2013.
	var objCheckBoxArray=[]; //added temporary variable to check for previously checked records by MAC 03/21/2013.
	var tableModel = {
		url: contextPath+"/GIACInwFaculPremCollnsController?action=refreshInvoiceListing&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd+"&a180RiCd="+(($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4")?$("a180RiCdInw").value:$("a180RiCd2Inw").value)+"&b140IssCd="+$("b140IssCdInw").value+"&transactionType="+$("transactionTypeInw").value+"&b140PremSeqNoInw="+$("b140PremSeqNoInw").value,
		options: {
			hideColumnChildTitle: true,
			querySort: true,				// to sort using existing rows
			addSettingBehavior: false,     	// disable|remove setting icon button
			addDraggingBehavior: false,    	// disable dragging behavior
			pager: { //dummy pagination
				total: 55,
				pages: 5,
				currentPage: 1,
				from: 1,
				to: 10
			},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
			},
			onCellFocus : function(element, value, x, y, id) { //added event to store all tagged records in an array by MAC 03/21/2013.
				if ($('mtgInput2_0,'+y).checked == true) {
					checkPremPaytForRiSpecial(objInwardFaculArray[y]);
				 }else if($('mtgInput2_0,'+y).checked == false){
					 for (var i=0; i<objCheckBoxArray.length; i++){
						 	if (objCheckBoxArray[i].assdNo === objInwardFaculArray[y].assdNo
								&& objCheckBoxArray[i].lineCd === objInwardFaculArray[y].lineCd
								&& objCheckBoxArray[i].riCd === objInwardFaculArray[y].riCd
								&& objCheckBoxArray[i].issCd === objInwardFaculArray[y].issCd
								&& objCheckBoxArray[i].premSeqNo === objInwardFaculArray[y].premSeqNo
								&& objCheckBoxArray[i].instNo === objInwardFaculArray[y].instNo) {
								objCheckBoxArray.splice(i, 1);
							 }
						}
				 }
				tableGrid.keys.releaseKeys();
			}
		},
		columnModel: [
			{ 								// this column will only use for deletion
				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			 	title: '&#160;I',
			 	altTitle: 'Include?',
				width: 19,
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
			{
				id: 'issCd premSeqNo',
				title: 'Bill No.',
				width : 117,
				children : [
		            {
		                id : 'issCd',
		                title: 'Bill No. - Iss Cd',
		                width : 30,
		                editable: false
// 		                filterOption: true //remove by steven 1/11/2013 base on SR 0011895		
		            },
		            {
		                id : 'premSeqNo', 
		                title: 'Bill No. - Prem Sequence Number',
		                width : 90,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
						},
						filterOption: true, 
						filterOptionType: 'integerNoNegative'		
		            }
				]
			},
			{
				id: 'drvPolicyNo',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'drvPolicyNo2',
				title: 'Policy No. / Endorsement No.',
				width: 200,
				editable: false	
			},
			{//decrease size of installment number by MAC 03/06/2013.
				id: 'instNo',
				title: 'Inst. No.',
				width: 50,
				align: 'right',
				editable: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative'		
			},
			{
				id: 'lineCd',
				title: 'Policy Line Code',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true		
			},
			{
				id: 'sublineCd',
				title: 'Policy Subline Code',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true	
			},
			{
				id: 'polIssCd',
				title: 'Policy Iss Code',
				width: '0',
				editable: false,
				visible: false
//                 filterOption: true //remove by steven 1/11/2013 base on SR 0011895			
			},
			{
				id: 'issueYy',
				title: 'Policy Issue Year',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative'	
			},
			{
				id: 'polSeqNo',
				title: 'Policy Pol Sequence No.',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative'		
			},
			{
				id: 'renewNo',
				title: 'Policy Renew No.',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{
				id: 'endtIssCd',
				title: 'Endt. Iss Code',
				width: '0',
				editable: false,
				visible: false
//                 filterOption: true  //remove by steven 1/11/2013 base on SR 0011895	
			},
			{
				id: 'endtYy',
				title: 'Endt. Year',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative'	
			},
			{
				id: 'endtSeqNo',
				title: 'Endt. Sequence No.',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{
				id: 'endtType',
				title: 'Endt. Type',
				width: '0',
				editable: false,
				visible: false,
                filterOption: true
			},
			{//display collection amount by MAC 04/06/2013
				id: 'dspCollnAmt',
				title: 'Collection',
				titleAlign: 'right',
				align: 'right',
				width: '100',
				editable: false,
				visible: true,
				renderer : function(value) {
			    	return formatCurrency(value);
			    }
			},
			{//hide incept and expiry date by MAC 04/06/2013
				id: 'inceptDate',
				title: 'Incept Date',
				width: 80,
				editable: false,
                filterOption: false, 
                visible: false
			},
			{
				id: 'expiryDate',
				title: 'Expiry Date',
				width: 80,
				editable: false,
                filterOption: false,	
                visible: false
			},
			{//added by steven 11.06.2013 base on test case
				id: 'strInceptDate',
				title: 'Incept Date',
				width: 80,
                filterOption: true ,
                filterOptionType: 'formattedDate' 
			},
			{
				id: 'strExpiryDate',
				title: 'Expiry Date',
				width: 80,
                filterOption: true,
                filterOptionType: 'formattedDate' 
			},			
			{
				id: 'riPolicyNo',
				title: 'RI Policy Number',
				width: 130,
				editable: false,
                filterOption: true
			},
			{
				id: 'riEndtNo',
				title: 'RI Endorsement Number',
				width: 155,
				editable: false,
                filterOption: true 		
			},
			{
				id: 'riBinderNo',
				title: 'RI Binder Number',
				width: 130,
				editable: false,
                filterOption: true 		
			},
			{//decrese size of assured number by MAC 03/06/2013
				id: 'assdNo',
				title: 'Assured No.',
				width: 70,
				align: 'right',
				editable: false,
                filterOption: true,
				filterOptionType: 'integerNoNegative' 		
			},
			{
				id: 'assdName',
				title: 'Assured Name',
				width: 150,
				editable: false,
                filterOption: true,
                renderer: function(value) {
					return escapeHTML2(value);
				}
			},
			{
				id: 'riCd',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'premiumAmt',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'premTax',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'wholdingTax',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'commAmt',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'foreignCurrAmt',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'taxAmount',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'commVat',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'convertRate',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'currencyCd',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'currencyDesc',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			},
			{
				id: 'vMsgAlert',
				title: '',
				width: '0',
				editable: false,
				visible: false	
			}
		],
		rows : objAC.hidObjAC008.invoiceListRows
	};	   			
	
	function disableExistingInvoice(){
		for (var i=0; i<tableGrid.rows.length; i++){
			$$("div[name='inwFacul']").each( function(a){
				var inwA180RiCd = "";
				if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
					inwA180RiCd = $F("a180RiCdInw");
				}else{
					inwA180RiCd = $F("a180RiCd2Inw");
				}
				if (a.getAttribute("transactionType") == $("transactionTypeInw").value
						&& a.getAttribute("a180RiCd") == inwA180RiCd
						&& a.getAttribute("b140IssCd") == $("b140IssCdInw").value 
						&& a.getAttribute("b140PremSeqNo") == objCheckBoxArray[i].premSeqNo
						&& a.getAttribute("instNo") == objCheckBoxArray[i].instNo 
						&& !a.hasClassName("selectedRow")){
					exists = true;
					$('mtgInput'+tableGrid._mtgId+'_0,'+i).checked = true;
					$('mtgInput'+tableGrid._mtgId+'_0,'+i).disable();
					//showMessageBox("Record already exists!", imgMessage.ERROR);
					//return false;
				}
			});
		}	
	}
	
	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objAC.hidObjAC008.invoiceListTableGrid; //to update pager section
	tableGrid.afterRender = function (){
		disableExistingInvoice;
		objInwardFaculArray=tableGrid.geniisysRows;
		for (var i=0; i<objCheckBoxArray.length; i++){
			for ( var j = 0; j < objInwardFaculArray.length; j++) {
				if (objCheckBoxArray[i].assdNo === objInwardFaculArray[j].assdNo
					&& objCheckBoxArray[i].lineCd === objInwardFaculArray[j].lineCd
					&& objCheckBoxArray[i].riCd === objInwardFaculArray[j].riCd
					&& objCheckBoxArray[i].issCd === objInwardFaculArray[j].issCd
					&& objCheckBoxArray[i].premSeqNo === objInwardFaculArray[j].premSeqNo
					&& objCheckBoxArray[i].instNo === objInwardFaculArray[j].instNo) {
					$('mtgInput2_0,'+j).checked = true;
				 }
			}
		}
	};
	tableGrid.render('invoiceListGrid');

	objAC.hidObjAC008.transactionTypeSelected = $F("transactionTypeInw");
	objAC.hidObjAC008.inwA180RiCdSelected = "";
	if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
		objAC.hidObjAC008.inwA180RiCdSelected = $F("a180RiCdInw");
	}else{
		objAC.hidObjAC008.inwA180RiCdSelected = $F("a180RiCd2Inw");
	}
	
	//when OK button click
	//replaced tableGrid by objCheckBoxArray to be able to insert all tagged records in tablegrid by MAC 04/04/2013 
	$("btnInvoiceOk").observe("click", function () {
		var hasSelected = false;
		var vMsgAlert = "";
		var exists = false;
		
		for (var i=0; i<objCheckBoxArray.length; i++){
			$("transactionTypeInw").value = $F("transactionTypeInw") == "" ? objAC.hidObjAC008.transactionTypeSelected :$F("transactionTypeInw");
			if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				$("a180RiCdInw").value = $F("a180RiCdInw") == "" ? objAC.hidObjAC008.inwA180RiCdSelected :$F("a180RiCdInw");
			}else{
				$("a180RiCd2Inw").value = $F("a180RiCd2Inw") == "" ? objAC.hidObjAC008.inwA180RiCdSelected :$F("a180RiCd2Inw");
			}
			
				hasSelected = true;
				$$("div[name='inwFacul']").each( function(a){
					var inwA180RiCd = "";
					if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
						inwA180RiCd = $F("a180RiCdInw");
					}else{
						inwA180RiCd = $F("a180RiCd2Inw");
					}
					if (a.getAttribute("transactionType") == $("transactionTypeInw").value
							&& a.getAttribute("a180RiCd") == inwA180RiCd
							&& a.getAttribute("b140IssCd") == $("b140IssCdInw").value 
							&& a.getAttribute("b140PremSeqNo") == objCheckBoxArray[i].premSeqNo
							&& a.getAttribute("instNo") == objCheckBoxArray[i].instNo 
							&& !a.hasClassName("selectedRow")){
						exists = true;
						showMessageBox("Record already exists!", imgMessage.ERROR);
						//return false;
					}
				});

				if (!exists){
					vMsgAlert = validateInvoiceInwFacul(objCheckBoxArray[i].premSeqNo);
					if (vMsgAlert == ""){
						$("b140PremSeqNoInw").value = formatNumberDigits(objCheckBoxArray[i].premSeqNo,8);	
						//filterInstallmentNoLOV(row.down("input",2).value,row.down("input",1).value);
						$("instNoInw").value = objCheckBoxArray[i].instNo;
						$("riPolicyNoInw").value = objCheckBoxArray[i].riPolicyNo;
						$("assdNoInw").value = objCheckBoxArray[i].assdNo;		
						$("assuredNameInw").value = objCheckBoxArray[i].assdName;	
						$("policyNoInw").value = unescapeHTML2(objCheckBoxArray[i].drvPolicyNo);  //bertongbully
						$("transactionTypeInw").focus();
						$("instNoInw").enable();
						$("collectionAmtInw").value = formatCurrency(objCheckBoxArray[i].collectionAmt);
						$("defCollnAmtInw").value = objCheckBoxArray[i].collectionAmt;
						$("premiumAmtInw").value = formatCurrency(objCheckBoxArray[i].premiumAmt);
						$("premiumTaxInw").value = objCheckBoxArray[i].premTax;
						$("wholdingTaxInw").value = objCheckBoxArray[i].wholdingTax;
						$("commAmtInw").value = formatCurrency(objCheckBoxArray[i].commAmt);
						$("foreignCurrAmtInw").value = formatCurrency(objCheckBoxArray[i].foreignCurrAmt);
						$("taxAmountInw").value = formatCurrency(objCheckBoxArray[i].taxAmount);
						$("commVatInw").value = formatCurrency(objCheckBoxArray[i].commVat);
						$("convertRateInw").value = formatToNineDecimal(objCheckBoxArray[i].convertRate);
						$("currencyCdInw").value = objCheckBoxArray[i].currencyCd;
						$("currencyDescInw").value = objCheckBoxArray[i].currencyDesc;
						$("collectionAmtInw").enable();
						$("foreignCurrAmtInw").enable();
						$("particularsInw").enable();	
		
						$("variableSoaCollectionAmtInw").value = objCheckBoxArray[i].collectionAmt;
						$("variableSoaPremiumAmtInw").value = objCheckBoxArray[i].premiumAmt;
						$("variableSoaPremiumTaxInw").value = objCheckBoxArray[i].premTax;
						$("variableSoaWholdingTaxInw").value = objCheckBoxArray[i].wholdingTax;
						$("variableSoaCommAmtInw").value = objCheckBoxArray[i].commAmt;
						$("variableSoaTaxAmountInw").value = objCheckBoxArray[i].taxAmount;
						$("variableSoaCommVatInw").value = objCheckBoxArray[i].commVat;
						$("defForgnCurAmtInw").value = objCheckBoxArray[i].foreignCurrAmt;
						objAC.hidObjAC008.addInwardFaculFunc();
						
						hideNotice();
					}else{
						hideNotice();
						showMessageBox(vMsgAlert, imgMessage.ERROR);
						return false;
					}		
				}

			if (i == (objCheckBoxArray.length-1)){
				hideNotice();
				//Modalbox.hide();
				overlaySearchInvoiceInward.close(); //added by steven 11.07.2013
				$("transactionTypeInw").clear();
				$("a180RiCdInw").clear();
				$("a180RiCd2Inw").clear();
				tableGrid.keys.releaseKeys();
			}	
		}	
		if (!hasSelected){
			hideNotice();
			//Modalbox.hide();
			overlaySearchInvoiceInward.close(); //added by steven 11.07.2013
			tableGrid.keys.releaseKeys();
		}	
	});
	//added by steven 1/11/2013
	var filterOptionToUpperArray = ["endtType","lineCd","sublineCd","riBinderNo","riEndtNo"];

	$("mtgKeyword2").observe("keyup", function () {
		if (filterOptionToUpper(filterOptionToUpperArray)){
			this.value = this.value.toUpperCase();
		}	
	});
	
	$("mtgFilterBy2").observe("change", function () {
		if (filterOptionToUpper(filterOptionToUpperArray)){
			$("mtgKeyword2").value = $("mtgKeyword2").value.toUpperCase();
		}	
	});
	
	function filterOptionToUpper(array) {
		for ( var i = 0; i < array.length; i++) {
			if($("mtgFilterBy2").value == array[i]){
				return true;
			}
		}
		return false;
	}
	
	//added john 11.3.2014
	function checkPremPaytForRiSpecial(b140PremSeqNoInw){
		try{
			var a180RiCd;
			if ($("transactionTypeInw").value == "2" || $("transactionTypeInw").value == "4"){
				a180RiCd = $("a180RiCdInw").value;
			}else{
				a180RiCd = $("a180RiCd2Inw").value;
			}
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=checkPremPaytForRiSpecial', {
				parameters: {
					a180RiCd: a180RiCd,
					b140IssCd: $("b140IssCdInw").value,
					transactionType: $("transactionTypeInw").value,
					b140PremSeqNoInw: b140PremSeqNoInw.premSeqNo
				},
				asynchronous:false,
				evalScripts:true,
				onCreate: function(){
					showNotice("Validating Invoice, please wait...");	
				},	
				onComplete: function(response){
					hideNotice("");
					if(response.responseText == ""){
						checkPremPaytForCancelled(b140PremSeqNoInw);
					} else if(response.responseText == "This is a Special Policy."){
						showWaitingMessageBox(response.responseText, "I", function(){
							checkPremPaytForCancelled(b140PremSeqNoInw);
							//objCheckBoxArray.push(b140PremSeqNoInw);
						});
					} else {
						showWaitingMessageBox(response.responseText, "E", function(){
							tableGrid.setValueAt(false,tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
						});
					}
				}
			});
		}catch(e){
			showErrorMessage ("checkPremPaytForRiSpecial",e);
		}
	}
	
	//added john 11.4.2014
	function checkPremPaytForCancelled(b140PremSeqNoInw){
		try{
			var a180RiCd;
			if ($("transactionTypeInw").value == "2" || $("transactionTypeInw").value == "4"){
				a180RiCd = $("a180RiCdInw").value;
			}else{
				a180RiCd = $("a180RiCd2Inw").value;
			}
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=checkPremPaytForCancelled', {
				parameters: {
					a180RiCd: a180RiCd,
					b140IssCd: $("b140IssCdInw").value,
					b140PremSeqNoInw: b140PremSeqNoInw.premSeqNo
				},
				asynchronous:false,
				evalScripts:true,
				onCreate: function(){
					showNotice("Validating Invoice, please wait...");	
				},	
				onComplete: function(response){
					hideNotice("");
					msg = response.responseText;
					if(msg == ""){
						//objCheckBoxArray.push(b140PremSeqNoInw); //Deo [01.20.2017]: comment out (SR-5909)
						checkClaim(b140PremSeqNoInw); //Deo [01.20.2017]: SR-5909
					} else if (msg == "N"){
						showMessageBox("This is a cancelled policy.", imgMessage.ERROR);
						tableGrid.setValueAt(false,tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
						return false;
					} else {
						var arr = msg.split(",");
						showConfirmBox("CONFIRMATION", "The policy of " + $("b140IssCdInw").value + "-" + b140PremSeqNoInw.premSeqNo + "" +  " is already cancelled. Would you like to continue processing the payment?",
								"Yes", "No",function() {
								if (arr[1] == "N"){
									showConfirmBox("CONFIRMATION", "User is not allowed to process payment of bill with cancelled policy. Would you like to override?",
											"Yes", "No",function() {
										showGenericOverride("GIACS008", "AP",
												function(ovr, userId, result){
													if(result == "FALSE"){
														showMessageBox(userId + " is not allowed to process payment of bill with cancelled policy.", imgMessage.ERROR);
														$("txtOverrideUserName").clear();
														$("txtOverridePassword").clear();
														return false;
													}else if(result == "TRUE"){
														ovr.close();
														delete ovr;
														//objCheckBoxArray.push(b140PremSeqNoInw); //Deo [01.20.2017]: comment out (SR-5909)
														checkClaim(b140PremSeqNoInw); //Deo [01.20.2017]: SR-5909
													}
												},
												function() {
													showMessageBox("This is a cancelled policy.", imgMessage.ERROR);
													tableGrid.setValueAt(false,tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
													return false;
												});
										
									}, function(){
										tableGrid.setValueAt(false,tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
									});
								} else {
									//objCheckBoxArray.push(b140PremSeqNoInw); //Deo [01.20.2017]: comment out (SR-5909)
									checkClaim(b140PremSeqNoInw); //Deo [01.20.2017]: SR-5909
								}
						}, function(){
							tableGrid.setValueAt(false,tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
						});
					}
				}
			});
		}catch(e){
			showErrorMessage ("checkPremPaytForCancelled",e);
		}
	}
	
	//Deo [01.20.2017]: add start (SR-5909)
	function checkClaim(curRecObj) {
		try {
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=checkClaimAndOverDue', {
				parameters : {
					issCd : curRecObj.issCd,
					premSeqNo : curRecObj.premSeqNo,
					instNo : curRecObj.instNo,
					tranDate : $F("tranDate")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Validating Invoice, please wait...");	
				},	
				onComplete : function(response) {
					hideNotice("");
					var text = response.responseText;
					var arr = text.split(resultMessageDelimiter);
					if (arr[0] != "FALSE") {
						showConfirmBox("Premium Collections", "The policy of " + curRecObj.issCd + "-" + curRecObj.premSeqNo + "-" + curRecObj.instNo
							+ " has existing claim(s): Claim Number(s) " + arr[0] + ". Would you like to continue with the premium collections?", "Yes", "No",
							function() {
								if (objAC.hasGiacs008CCFnc == "N" && objAC.giacs008AllowClm == "N") {
									showConfirmBox("Premium Collections", "User is not allowed to process policy that has an existing claim. "
										+ "Would you like to override?", "Yes", "No",
										function() {
											callOverride("GIACS008", "CC", " is not allowed to process collections for policies with existing claims.",
												curRecObj, arr[1]);
										}, function() {
											tableGrid.setValueAt(false, tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
										});
								} else {
									checkOverDue(curRecObj, arr[1]);
								}
							}, function() {
								tableGrid.setValueAt(false, tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
							});
					} else {
						checkOverDue(curRecObj, arr[1]);
					}
				}
			});
		} catch(e) {
			showErrorMessage ("checkClaim",e);
		}
	}

	function checkOverDue(curRecObj, daysOverDue) {
		if (nvl(objAC.chkPremAging, "N") == "Y" && ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "3")) {
			if (parseFloat(daysOverDue) > parseFloat(nvl(objAC.chkBillDueDate, daysOverDue))) {
				showConfirmBox("Premium Collections", "This bill is " + daysOverDue + " days overdue. "
					+ "Would you like to continue with the premium collection?", "Yes", "No",
					function() {
						if (objAC.hasGiacs008AOFnc == "N" && objAC.giacs008AllowOvrDue == "N") {
							showConfirmBox("Premium Collections", "User is not allowed to process premium collections for overdue bill. "
								+ "Would you like to override?", "Yes", "No",
								function() {
									callOverride("GIACS008", "AO", " is not allowed to process collections for overdue bill.", curRecObj);
								}, function() {
									tableGrid.setValueAt(false, tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
								});
						} else {
							objCheckBoxArray.push(curRecObj);
						}
					}, function() {
						tableGrid.setValueAt(false, tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
					});
			} else {
				objCheckBoxArray.push(curRecObj);
			}
		} else {
			objCheckBoxArray.push(curRecObj);
		}
	}

	function callOverride(moduleId, functionCd, message, curRecObj, daysOverDue) {
		showGenericOverride(moduleId, functionCd,
			function(ovr, userId, res) {
				if (res == "FALSE") {
					showMessageBox(userId + message, imgMessage.ERROR);
					$("txtOverrideUserName").clear();
					$("txtOverridePassword").clear();
					return false;
				} else if (res == "TRUE") {
					if (functionCd == "CC") {
						objAC.giacs008AllowClm = "Y";
						checkOverDue(curRecObj, daysOverDue);
					} else {
						objAC.giacs008AllowOvrDue = "Y";
						objCheckBoxArray.push(curRecObj);
					}
					ovr.close();
					delete ovr;
				}
			}, function() {
				tableGrid.setValueAt(false, tableGrid.getColumnIndex('recordStatus'), tableGrid.getCurrentPosition()[1]);
			}, "Override User");
	}
	//Deo [01.20.2017]: add ends (SR-5909)

/*COMMENT OLD CODE BELOW - nok 05.12.2011
<div class="tableContainer" style="font-size: 12px; display: none;">
	<div id="tableInwFaculHeader" class="tableHeader">
		<label style="width: 12%; margin-right: 1px;">Policy No.</label>
		<label style="width: 9%; margin-right: 13px; ">Bill No.</label>
		<label style="width: 7%; margin-right: 2px;">Inst No.</label>
		<label style="width: 10%; margin-right: 2px;">Incept Date</label>
		<label style="width: 10%; margin-right: 2px;">Expiry Date</label>
		<label style="width: 12%; margin-right: 2px;">RI Policy No.</label>
		<label style="width: 12%; margin-right: 2px;">Ri Endt No.</label>
		<label style="width: 12.5%; margin-right: 2px;">Ri Binder No.</label>
		<label style="width: 12%; ">Assured Name</label>
	</div>
	<div style="height:270px; overflow:auto;">
		<c:if test="${empty searchResult}">
			<div id="rowInwFaculInvoiceList" name="rowInwFaculInvoiceList" class="tableRow">No records available</div>
		</c:if>
		<c:forEach var="invoice" items="${searchResult}">
			<div id="rowInwFaculInvoiceList${invoice.lineCd}${invoice.sublineCd}${invoice.polIssCd}${invoice.issueYy}${invoice.polSeqNo}${invoice.renewNo}${invoice.endtIssCd}${invoice.endtYy}${invoice.endtSeqNo}${invoice.endtType}${invoice.premSeqNo}${invoice.instNo}" name="rowInwFaculInvoiceList" class="tableRow" style="padding: 1px; padding-top: 5px;">
				<label name="policyNoInwText" style="width: 12%; margin-right: 1px;">${empty invoice.drvPolicyNo ? '---' :invoice.drvPolicyNo }</label>
				<label name="billNoInwText" style="width: 9%; margin-right: 13px; ">${empty invoice.issCd ? '---' :invoice.issCd }-<fmt:formatNumber pattern="00000000">${invoice.premSeqNo }</fmt:formatNumber></label>
				<label name="instNoInwText" style="width: 7%; margin-right: 2px;">${empty invoice.instNo ? '---' :invoice.instNo}</label>
				<label name="dateInwText" style="width: 10%; margin-right: 2px;">${empty invoice.inceptDate ? '---' :invoice.inceptDate}</label>
				<label name="dateInwText" style="width: 10%; margin-right: 2px;">${empty invoice.expiryDate ? '---' :invoice.expiryDate}</label>
				<label name="policyNoInwText" style="width: 12%; margin-right: 2px;">${empty invoice.riPolicyNo ? '---' :invoice.riPolicyNo}</label>
				<label name="policyNoInwText" style="width: 12%; margin-right: 2px;">${empty invoice.riEndtNo ? '---' :invoice.riEndtNo}</label>
				<label name="policyNoInwText" style="width: 12.5%; margin-right: 1px;">${empty invoice.riBinderNo ? '---' :invoice.riBinderNo}</label>
				<label name="assdNameInwText" style="width: 12%; ">${empty invoice.assdName ? '---' :invoice.assdName}</label>
				
				<input type="hidden" id="issCdInvoiceList" 		name="issCdInvoiceList" 	value="${invoice.issCd}"/>
				<input type="hidden" id="premSeqNoInvoiceList" 	name="premSeqNoInvoiceList" value="${invoice.premSeqNo}"/>
				<input type="hidden" id="instNoInvoiceList" 	name="instNoInvoiceList" 	value="${invoice.instNo}"/>
				<input type="hidden" id="lineCdInvoiceList" 	name="lineCdInvoiceList" 	value="${invoice.lineCd}"/>
				<input type="hidden" id="sublineCdInvoiceList" 	name="sublineCdInvoiceList" value="${invoice.sublineCd}"/>
				<input type="hidden" id="polIssCdCdInvoiceList" name="polIssCdInvoiceList" 	value="${invoice.polIssCd}"/>
				<input type="hidden" id="issueYyInvoiceList" 	name="issueYyInvoiceList" 	value="${invoice.issueYy}"/>
				<input type="hidden" id="polSeqNoInvoiceList" 	name="polSeqNoInvoiceList" 	value="${invoice.polSeqNo}"/>
				<input type="hidden" id="renewNoInvoiceList" 	name="renewNoInvoiceList" 	value="${invoice.renewNo}"/>
				<input type="hidden" id="endtIssCdInvoiceList"  name="endtIssCdInvoiceList" value="${invoice.endtIssCd}"/>
				<input type="hidden" id="endtYyInvoiceList" 	name="endtYyInvoiceList" 	value="${invoice.endtYy}"/>
				<input type="hidden" id="endtSeqNoInvoiceList"  name="endtSeqNoInvoiceList" value="${invoice.endtSeqNo}"/>
				<input type="hidden" id="endtTypeInvoiceList" 	name="endtTypeInvoiceList" 	value="${invoice.endtType}"/>
				<input type="hidden" id="inceptDateInvoiceList" name="inceptDateInvoiceList" value="${invoice.inceptDate}"/>
				<input type="hidden" id="expiryDateInvoiceList" name="expiryDateInvoiceList" value="${invoice.expiryDate}"/>
				<input type="hidden" id="riPolicyNoInvoiceList" name="riPolicyNoInvoiceList" value="${invoice.riPolicyNo}"/>
				<input type="hidden" id="riEndtNoInvoiceList" 	name="riEndtNoInvoiceList" 	 value="${invoice.riEndtNo}"/>
				<input type="hidden" id="riBinderNoInvoiceList" name="riBinderNoInvoiceList" value="${invoice.riBinderNo}"/>
				<input type="hidden" id="assdNoInvoiceList" 	name="assdNoInvoiceList" 	value="${invoice.assdNo}"/>
				<input type="hidden" id="assdNameInvoiceList" 	name="assdNameInvoiceList" 	value="${fn:escapeXml(invoice.assdName)}"/>
				<input type="hidden" id="riCdInvoiceList" 		name="riCdInvoiceList" 		value="${invoice.riCd}"/>
				<input type="hidden" id="policyNoInvoiceList" 	name="policyNoInvoiceList" 	value="${invoice.drvPolicyNo}"/>
				<input type="hidden" id="collectionAmtInvoiceList" 	name="collectionAmtInvoiceList"  value="${invoice.collectionAmt}"/>
				<input type="hidden" id="premiumAmtInvoiceList" 	name="premiumAmtInvoiceList" 	 value="${invoice.premiumAmt}"/>
				<input type="hidden" id="premTaxInvoiceList" 		name="premTaxInvoiceList" 		 value="${invoice.premTax}"/>
				<input type="hidden" id="wholdingTaxInvoiceList" 	name="wholdingTaxInvoiceList" 	 value="${invoice.wholdingTax}"/>
				<input type="hidden" id="commAmtInvoiceList" 		name="commAmtInvoiceList" 		 value="${invoice.commAmt}"/>
				<input type="hidden" id="foreignCurrAmtInvoiceList" name="foreignCurrAmtInvoiceList" value="${invoice.foreignCurrAmt}"/>
				<input type="hidden" id="taxAmountInvoiceList" 		name="taxAmountInvoiceList" 	 value="${invoice.taxAmount}"/>
				<input type="hidden" id="commVatInvoiceList" 		name="commVatInvoiceList" 		 value="${invoice.commVat}"/>
				<input type="hidden" id="convertRateInvoiceList" 	name="convertRateInvoiceList" 	 value="${invoice.convertRate}"/>
				<input type="hidden" id="currencyCdInvoiceList" 	name="currencyCdInvoiceList" 	 value="${invoice.currencyCd}"/>
				<input type="hidden" id="currencyDescInvoiceList" 	name="currencyDescInvoiceList" 	 value="${invoice.currencyDesc}"/>
			</div>			
		</c:forEach>
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="invoiceInwardFaculPage" name="invoiceInwardFaculPage">
		<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
			<option value="${i}"
				<c:if test="${pageNo==i}">
					selected="selected"
				</c:if>
			>${i}</option>
		</c:forEach>
	</select> of ${noOfPages}
</div>
	
	//when PAGE change
	$("invoiceInwardFaculPage").observe("change",function(){
		searchInvoiceInwardModal($("invoiceInwardFaculPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowInwFaculInvoiceList]").each(function(row){
		row.observe("mouseover",function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout",function(){
			row.removeClassName("lightblue");
		});
		row.observe("click",function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$("selectedClientId").value = row.getAttribute("id").substring(3);
				$$("div[name=rowInwFaculInvoiceList]").each(function(li){
					if (row.getAttribute("id") != li.getAttribute("id")){
						li.removeClassName("selectedRow");
					}	
				});
			}else{
				null;
			}		
		});
	});

	//truncate label text
	$$("label[name='policyNoInwText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(13, "..."));
	});
	$$("label[name='billNoInwText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(11, "..."));
	});
	$$("label[name='dateInwText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(10, "..."));
	});
	$$("label[name='instNoInwText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(8, "..."));
	});
	$$("label[name='assdNameInwText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(12, "..."));
	});
	if ($$("div[name=rowInwFaculInvoiceList]").size() > 10){
		$("tableInwFaculHeader").setStyle("padding-right: 18px");
	}	
	*/
</script>