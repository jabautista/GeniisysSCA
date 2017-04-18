<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br/>
<div style="margin: 1px;">
	<div id="quotesAndPolTable" name="quotesAndPolTable" style="height: 200px; width: 100%;">
		<!--div id="itemPerilHeaderDiv" class="tableHeader" style="padding-right: 0px;">
			<label style="width: 5%; text-align: right; margin-right: 5px;">Item</label>
			<label style="width: 20%; text-align: left; margin-left: 5px;">Peril Name</label>
			<label style="width: 15%; text-align: right;">Rate</label>
	   		<label style="width: 15%; text-align: right; margin-left: 5px;">TSI Amount</label>
			<label style="width: 15%; text-align: right; margin-left: 5px;">Premium Amount</label>
			<label style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">Remarks</label>
			<label style="width: 3%; text-align: right;">A</label>
			<label style="width: 3%; text-align: right;">S</label>
			<label style="width: 3%; text-align: right;">D</label>
		</div-->
	</div>
	<div align="center" style="margin: 10px;">
		<input type="button" class="button" id="btnViewQuotation" value="View Quotation"/>
		<input type="button" class="button" id="btnViewPolicyInformation" value="View Policy Information"/>
		<input type="button" class="button" id="btnReturn" value="Return"/>
	</div>
</div>
<script>

	disableButton("btnViewQuotation");
	disableButton("btnViewPolicyInformation");

	var objGIPIQuotes = JSON.parse('${existingQuotesAndPoliciesTableGrid}'.replace(/\\/g, '\\\\'));  
	objGIPIQuotes.rows = objGIPIQuotes.rows || [];
	
	var tableModel = {
		//url: contextPath+"/GIACOpTextController?action=refreshORPreview&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd,
		options : {
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
			
			onCellFocus : function(){
				enableButton("btnViewQuotation");
				enableButton("btnViewPolicyInformation");
			}
			
			/*prePager: function(){
				tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
			},
			postPager: function(){
				//to compute total amount after moving to another page
				computeAllTotal();
			},	
			onCellFocus : function(element, value, x, y, id) {
				//to disable Local Currency if Gen is not equal to variable.itemGenType else enable
				if (y>=0){
					if (objAC.hidObjGIACS025.variables.itemGenType != tableGrid.rows[y][tableGrid.getColumnIndex('itemGenType')]){
						tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = false;
					}else{
						tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
					}	
				}else{
					tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
				}	
				computeAllTotal();
			},
			onCellBlur : function(element, value, x, y, id) {
				computeAllTotal();
			},*/
			/*toolbar : {
				elements: [MyTableGrid.ADD_BTN, MyTableGrid.DEL_BTN, MyTableGrid.SAVE_BTN]
			}*/
		},
		
		columnModel : [
			{
			    id: 'quoteNo',
			    title: 'Quotation No.',
			    width: 185,
			    maxlength: 30

			},
			{
			    id: 'parNo',
			    title: 'PAR No.',
			    width: 145,
			    maxlength: 30
			},
			{
			    id: 'polNo',
			    title: 'Policy No.',
			    width: 145,
			    maxlength: 30
			},
			{
	            id: 'tsiAmt',
	            title: 'Sum Insured',
	            type : 'number',
	            width : 110,
	            maxlength: 18,
	            geniisysClass : 'money'
	        },
	        {
	            id: 'inceptDate',
	            title: 'Incept Date',
	            type : 'date',
	            width : 85,
	            maxlength: 18
	        },
	        {
	            id: 'expiryDate',
	            title: 'Expiry Date',
	            type : 'date',
	            width : 85,
	            maxlength: 18
	        },
	        {
			    id: 'status',
			    title: 'Status',
			    width: 89,
			    maxlength: 30
			}
	    ],
	    //requiredColumns: 'printSeqNo itemText itemAmt itemGenType gaccTranId itemSeqNo',
	    rows : objGIPIQuotes.rows
	};

	$("overlayTitleDiv").hide();
	
	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objGIPIQuotes; //to update pager section
	tableGrid.render('quotesAndPolTable');  // 'mytable1' div id that will contain the table grid
</script>
<script>
	// moved the validation on the field itself, saving is for this overlay is not needed anymore - irwin
	$("btnReturn").observe("click", function() { 
			hideOverlay();
		/* if(saveSw == 1){
			$("allowMultipleAssuredSw").value = "true"; 
			hideOverlay();
			overlayListOfExistingQuotationsAndPolicies.close();
			createNewQuotation1();
		}else{
			$("allowMultipleAssuredSw").value = "true"; 
			hideOverlay();
			overlayListOfExistingQuotationsAndPolicies.close();
		} */
	});
	
	function createNewQuotation1(){
		try{
			if(validateBeforeSave1()){
				saveQuotation1();
			}else{
				showMessageBox('A field may have been invalid.', imgMessage.ERROR);
			}
		}catch(e){
			showErrorMessage("createNewQuotation", e);
		}		
	}

	function saveQuotation1(){
		try{
			new Ajax.Updater("quoteIdDiv", contextPath+'/GIPIQuotationController?action=saveQuotation', {
				method: "POST",
				postBody: Form.serialize("createQuotationForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function ()	{
					$("createQuotationForm").disable();
					showNotice("Saving, please wait...");
				},
				onComplete: function (response)	{
					try{						
						$("createQuotationForm").enable();
						if(checkErrorOnResponse(response)){							
							if ("SUCCESS" == $F("message") && $F("isEditQuotation").blank()) {								
								$("quotationNo").value = $F("quoteNo");
								$("quoteId").value = $F("generatedQuoteId");
								
								$("reloadForm").stopObserving();
								$("reloadForm").observe("click", reloadForm);
								enableMenu("quoteInformation"); // addedBy irwin march 3, 2011
								enableButton("btnMaintainAssured");
								//showNotice("Success!");
								//hideNotice(response.responseText);
								changeTag = 0;
							}						
							
							if ("SUCCESS" == $F("message") && $F("isEditQuotation")!='1'){
								changeContainers("text");
							}					
							changeTag = 0;
							refreshQuotationMenu(); // added by mark jm 04.14.2011 @UCPBGEN
							objGIPIQuote.quoteId = $F("generatedQuoteId");
							hideNotice(response.responseText);							
							showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);							
						}
					}catch(e){
						showErrorMessage("onComplete", e);
					}		
				}
			});
		}catch(e){
			showErrorMessage("saveQuotation", e);
		}		
	}
	
	function validateBeforeSave1(){
		var result = true;
		var today = new Date();
		var eff = makeDate($F("validDate"));
		var incept = makeDate($F("doi"));
		var exp = makeDate($F("doe"));
		
		if(changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);
			return false;
		}else if($F("subline")=="" || $F("subline").empty()){
			result = false;

			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$('subline').focus();	
			});
		} else if ($F('validDate')=='' || $F("validDate").empty()) {
			result = false;
			$('validDate').focus();
			showMessageBox('Validity date is required.', imgMessage.ERROR);
		} else if ($F("quotationNo").blank() && Math.ceil((eff-today)/1000/24/60/60)<30){ // nilagyan ng addtl condition para pag edit di mag-error
			result = false;
			showMessageBox('Validity date should be at least 30 days after system date.', imgMessage.ERROR);
			$('validDate').focus();
		} /*else if ($F('assuredName')=='' || $F('assuredName').empty()){   // removed by Irwin.
			result = false;
			$F('assuredName').focus;
			showMessageBox('Assured Name is Required.', imgMessage.ERROR);		
		} */else if ($F('doi')=='' || $F('doi').empty()) {
			result = false;
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$('doi').focus();
			});
		} else if ($F('doe')=='') {
			result = false;
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$('doe').focus();
			});
		} /*else if (incept<today) {
			result = false;
			$('doi').focus();
			showMessageBox('Incept date must not be earlier than system date.', imgMessage.ERROR); // removed. - Irwin
		} */else if (exp<incept) {
			result = false;
			$('doe').focus();
			showMessageBox('Expiry date must not be earlier than or equal to incept date.', imgMessage.ERROR);
		} else if ($F('prorateFlag')=='1' && parseInt($F('noOfDays')) < 0) {
			result = false;
			$('noOfDays').focus();
			showMessageBox('Tagging of -1 day will result to invalid no. of days. Changing is not allowed.', imgMessage.ERROR);			
		} else if ($F('prorateFlag')=='1' && isNaN($F("noOfDays"))) {
			result = false;
			$('noOfDays').focus();
			showMessageBox('Invalid No. of Days', imgMessage.ERROR);			
		} else if ($F('prorateFlag')=='1' && $F("noOfDays") > 9999){
			result = false;
			$('noOfDays').focus();
			showMessageBox('Entered pro-rate number of days is invalid. Entered value should not result to a year greater than 9999.', imgMessage.ERROR);
		} else if ($F('prorateFlag')=='3' && (	$F('shortRatePercent') == '' || 
												$F("shortRatePercent").blank()/* ||
												parseFloat($F('shortRatePercent')) <= 0 || 
												parseFloat($F('shortRatePercent')) > 100*/)) {
			result = false;
			$('shortRatePercent').focus();
			
			showMessageBox('Short Rate Percent is required.', imgMessage.ERROR);

			$("shortRatePercent").value = '';
		} else if ($F('prorateFlag')=='3' &&  (parseFloat($F('shortRatePercent')) <= 0 || 
												parseFloat($F('shortRatePercent')) > 100)) {
			result = false;
			$('shortRatePercent').focus();
			
			showMessageBox('Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.', imgMessage.ERROR);
			
			$("shortRatePercent").value = '';
		} else if($F("prorateFlag")=='3' && isNaN($F("shortRatePercent"))){
			showMessageBox('Invalid Short Rate Percent. Value must range from 0.000000001% - 100.000000000%.', imgMessage.ERROR);
		} 
		return result;
	}
	
</script>