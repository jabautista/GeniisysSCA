<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>History Details</label>
   		<span class="refreshers" style="margin-top: 0;">
  			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv">
	<div id="historyTableDiv" style="padding: 10px 0 10px 10px;">
		<div id="historyTable" style="height: 200px"></div>
	</div>
</div>
<script type="text/javascript">
	function setCurrencyListing(adviceCurrency){
		try {
			if(adviceCurrency != null){
				$$("option[name='optCurrency']").each(function(o){
					if(o.value == objGICLS032.vars.localCurrency || o.value == adviceCurrency){
						showOption(o);
					} else {
						hideOption(o);
					}
				});
				hideOption($("selCurrency").down("option"));		
			} else {
				$$("option[name='optCurrency']").each(function(o){
					showOption(o);
				});
			}
		} catch(e){
			showErrorMessage("setCurrencyListing", e);
		}
	}

	function validateHist(value){
		try {
			//modified condition by MAC 02/19/2013 to check closeFlag if payeeType is Loss or closeFlag2 if payeeType is Expense.
			//if(objGICLS032.objCurrGICLClmLossExp.distSw == "Y" && objGICLS032.objCurrGICLClmLossExp.closeFlag != "AP"){
			if(objGICLS032.objCurrGICLClmLossExp.distSw == "Y" && objGICLS032.objCurrGICLAdvice == null && //objGICLS032.objCurrGICLAdvice == null Added by Jerome Bautista 08.25.2015 SR 12213 / 4651
					( (objGICLS032.objCurrGICLClmLossExp.payeeType == "L" && objGICLS032.objCurrGICLClmLossExp.closeFlag != "AP") ||
					  (objGICLS032.objCurrGICLClmLossExp.payeeType == "E" && objGICLS032.objCurrGICLClmLossExp.closeFlag2 != "AP"))){
				showMessageBox("You cannot generate an advice for this settlement. Please check if peril is distributed or not closed/denied/withdrawn/cancelled.", imgMessage.INFO); //Changed by: Jerome 02272015	
				$("mtgInput"+tbgClaimAdviceHistory._mtgId+"_2,"+objGICLS032.objCurrGICLClmLossExp.rowIndex).checked = false;
				objGICLS032.tempPayeeNameArray = []; //Added by Jerome Bautista 05.28.2015 SR 4083
				objGICLS032.tempPayeeNameArray.pop(); //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
			}else {
				for(var i=0,j=objGICLS032.tempPayeeNameArray.length-1;i<j;i++,j--){ //Added by: Jerome Bautista 5.20.2015 to disallow user from creating an advice with different payees. SR 4175
					if(objGICLS032.tempPayeeNameArray[i] != objGICLS032.tempPayeeNameArray[j]){
						showMessageBox("You cannot group settlement histories with different payees.", imgMessage.INFO);
						$("mtgInput"+tbgClaimAdviceHistory._mtgId+"_2,"+objGICLS032.objCurrGICLClmLossExp.rowIndex).checked = false;
						objGICLS032.tempPayeeNameArray.pop();
						disableButton("btnGenerateAdvice");
						value = false;
						break;
			    }
				}
				if(value){
					if(nvl(objGICLS032.vars.vSwitch, 0) == 0){
						objGICLS032.vars.adviceCurrency = objGICLS032.objCurrGICLClmLossExp.currencyCd;
						objGICLS032.vars.adviceRate = objGICLS032.objCurrGICLClmLossExp.currencyRate;
						$("selCurrency").value = objGICLS032.objCurrGICLClmLossExp.currencyCd;

						if(objGICLS032.objCurrGICLAdvice == null) {
							$("txtConvertRate").value = formatToNineDecimal(objGICLS032.objCurrGICLClmLossExp.currencyRate);
							$("txtConvertRate").writeAttribute("oldConvertRate", objGICLS032.objCurrGICLClmLossExp.currencyRate);
						}
						
						if(objGICLS032.vars.adviceCurrency == objGICLS032.vars.localCurrency){
							$("selCurrency").disabled = true;
							$("txtConvertRate").writeAttribute("readonly");
							$("txtConvertRate").removeClassName("required");
						} else {
							setCurrencyListing(objGICLS032.vars.adviceCurrency);
							$("txtConvertRate").removeAttribute("readonly");
							$("txtConvertRate").addClassName("required");
						}
						
						objGICLS032.vars.vSwitch = parseInt(nvl(objGICLS032.vars.vSwitch, 0)) + 1;
						
						if(objGICLS032.vars.vSwitch > 1){
							if(objGICLS032.vars.adviceCurrency != objGICLS032.objCurrGICLClmLossExp.currencyCd){
								objGICLS032.vars.vSwitch = objGICLS032.vars.vSwitch - 1;
								showMessageBox("Items to be tagged should have the same currency. Please check currency of previously tagged item.", imgMessage.INFO);
								tbgClaimAdviceHistory.setValueAt(false, tbgClaimAdviceHistory.getColumnIndex('select'), objGICLS032.objCurrGICLClmLossExp.rowIndex, true);
								objGICLS032.tempPayeeNameArray.pop(); //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
	        					return false;
							}
						}
					}
					
					if(objGICLS032.objCurrGICLClmLossExp.distSw == "N" || objGICLS032.objCurrGICLClmLossExp.distSw == null){
						showMessageBox("Cannot generate advice. See Distribution Status field.", imgMessage.ERROR);
						tbgClaimAdviceHistory.setValueAt(false, tbgClaimAdviceHistory.getColumnIndex('select'), objGICLS032.objCurrGICLClmLossExp.rowIndex, true);
						objGICLS032.tempPayeeNameArray.pop(); //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
						return false;
					} else if(objGICLS032.objCurrGICLClmLossExp.itemStatCd == "DN" || objGICLS032.objCurrGICLClmLossExp.itemStatCd == "WD"){
						showMessageBox("Item may not be distributed. See Claim Status field.", imgMessage.ERROR);
						tbgClaimAdviceHistory.setValueAt(false, tbgClaimAdviceHistory.getColumnIndex('select'), objGICLS032.objCurrGICLClmLossExp.rowIndex, true);
						objGICLS032.tempPayeeNameArray.pop(); //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
						return false;
					}
					
					if(objGICLS032.objCurrGICLAdvice != null) {	            		
						showMessageBox("Advice has been generated for this history.", imgMessage.ERROR);
		    			tbgClaimAdviceHistory.setValueAt(false, tbgClaimAdviceHistory.getColumnIndex('select'), objGICLS032.objCurrGICLClmLossExp.rowIndex, true);
		    			objGICLS032.tempPayeeNameArray.pop(); //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
		    			return false;
		    		}			
											
					if(objGICLS032.vars.selectedClmLoss == undefined || objGICLS032.vars.selectedClmLoss == null){					
						objGICLS032.vars.selectedClmLoss = "#"+objGICLS032.objCurrGICLClmLossExp.clmLossId+"#";
						objGICLS032.selectedRows = [];
						objGICLS032.selectedRows.push(objGICLS032.objCurrGICLClmLossExp);
					} else {
						objGICLS032.vars.selectedClmLoss += "#"+objGICLS032.objCurrGICLClmLossExp.clmLossId+"#";
						objGICLS032.selectedRows.push(objGICLS032.objCurrGICLClmLossExp);
					}
					checkTsi();
				} else {					
					if(objGICLS032.vars.selectedClmLoss != undefined){
						objGICLS032.vars.selectedClmLoss = objGICLS032.vars.selectedClmLoss.replace("#"+objGICLS032.objCurrGICLClmLossExp.clmLossId+"#", "");
					}					
					if(objGICLS032.vars.vSwitch != undefined){
						objGICLS032.vars.vSwitch = objGICLS032.vars.vSwitch - 1;
					}
					
					if(objGICLS032.selectedRows){
						for(var j=0; j<objGICLS032.selectedRows.length; j++){
							if(objGICLS032.selectedRows[j].clmLossId == objGICLS032.objCurrGICLClmLossExp.clmLossId){
								objGICLS032.selectedRows.splice(j,1);
							}
						}
					}
					computeAmounts();
					setCurrencyListing();
				}
			}
			tbgClaimAdviceHistory.keys.removeFocus(tbgClaimAdviceHistory.keys._nCurrentFocus, true);
			tbgClaimAdviceHistory.keys.releaseKeys();
		} catch(e){
			showErrorMessage("validateHist", e);
		}
	}

	function checkConfirmTsiOnResponse(response){
		var result = true;
		if (response.responseText.include("CONFIRM_TSI")){
			var message = response.responseText.split("#"); 
			showConfirmBox("Confirmation", message[2], "Yes", "No",  
				function(){
					computeAmounts();
				},
				function(){
					for(var j=0; j<objGICLS032.selectedRows.length; j++){
						if(objGICLS032.selectedRows[j].clmLossId == objGICLS032.objCurrGICLClmLossExp.clmLossId){
							objGICLS032.selectedRows.splice(j,1);
						}
					}
					objGICLS032.vars.selectedClmLoss = objGICLS032.vars.selectedClmLoss.replace("#"+objGICLS032.objCurrGICLClmLossExp.clmLossId+"#", "");
					tbgClaimAdviceHistory.setValueAt(false, tbgClaimAdviceHistory.getColumnIndex('select'), objGICLS032.objCurrGICLClmLossExp.rowIndex, true);
				});
			result = false;
		} 
		return result;
	}
	
	function checkTsi(){
		if(objGICLS032.selectedRows){
			new Ajax.Request(contextPath+"/GICLAdviceController", {
				method: "POST",
				parameters: {action : "gicls032CheckTsi",
							 claimId : objCLMGlobal.claimId,
							 itemNo : objGICLS032.objCurrGICLClmLossExp.itemNo,
							 perilCd : objGICLS032.objCurrGICLClmLossExp.perilCd,
							 selectedClmLoss : objGICLS032.vars.selectedClmLoss},
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkConfirmTsiOnResponse(response)){
						computeAmounts();
					}
				}
			});			
		}
	}
	
	function computeAmounts(){
		try {
			if(objGICLS032.selectedRows && $F("selCurrency") != ""){
				new Ajax.Request(contextPath+"/GICLAdviceController", {
					method: "POST",
					parameters: {action : "gicls032ComputeAmounts",
								 rows : prepareJsonAsParameter(objGICLS032.selectedRows),
								 currencyCd : $F("selCurrency"),
								 convertRate : $F("txtConvertRate"),							 
								 localCurrency : objGICLS032.vars.localCurrency,
								 adviceCurrency : objGICLS032.vars.adviceCurrency},
					onComplete : function(response){
						try {
							if(checkErrorOnResponse(response)){
								var result = JSON.parse(response.responseText);
								
								$("txtPaidAmount").value = formatCurrency(result.paidAmt);
								$("txtNetAmount").value = formatCurrency(result.netAmt);
								$("txtAdviceAmount").value = formatCurrency(result.adviseAmt);
								$("hidPaidFcurrAmt").value = result.paidFcurrAmt;
								$("hidNetFcurrAmt").value = result.netFcurrAmt;
								$("hidAdvFcurrAmt").value = result.advFcurrAmt;
								
								if(result.paidAmt > 0){
									enableButton("btnGenerateAdvice");
								} else {
									disableButton("btnGenerateAdvice");
								}
							}
						} catch(e){
							showErrorMessage("computeAmounts - onComplete", e);
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("computeAmounts", e);
		}
	}

	var jsonClmLossExp = JSON.parse('${jsonClmLossExp}');
	historyTableModel = {
			url : contextPath+"/GICLClaimLossExpenseController?action=getGICLClmLossExpList&claimId="+objCLMGlobal.claimId+"&adviceId=&lineCd="+objCLMGlobal.lineCd,
			options: {
				hideColumnChildTitle: true,
				width: '900px',
				pager: {
				},
				/* toolbar: {
					elements: [MyTableGrid.FILTER_BTN]
				},	 */				
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgClaimAdviceHistory._mtgId;							
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						objGICLS032.objCurrGICLClmLossExp = tbgClaimAdviceHistory.geniisysRows[y];
						objGICLS032.objCurrGICLClmLossExp.rowIndex = y;
					}
					if(id != "select") {
						tbgClaimAdviceHistory.keys.removeFocus(tbgClaimAdviceHistory.keys._nCurrentFocus, true);
						tbgClaimAdviceHistory.keys.releaseKeys();
					}
					tbgClaimAdviceHistory.keys.removeFocus(tbgClaimAdviceHistory.keys._nCurrentFocus, true);
					tbgClaimAdviceHistory.keys.releaseKeys();
				},
				prePager: function(){
					objGICLS032.objCurrGICLClmLossExp = null;
					objGICLS032.vars.selectedClmLoss = null;
					objGICLS032.selectedRows = [];
				},
				onRemoveRowFocus : function(element, value, x, y, id){						
					objGICLS032.objCurrGICLClmLossExp = null;
					objGICLS032.vars.selectedClmLoss = null;
				},
				afterRender : function (){
					
				},
				onSort : function(){
					objGICLS032.objCurrGICLClmLossExp = null;
					objGICLS032.vars.vSwitch = null;
					objGICLS032.vars.selectedClmLoss = null;
					objGICLS032.selectedRows = [];
					objGICLS032.setClaimAdviceForm(null);
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
					id : "select",
					title: "",
					width: '25px',
					editable : true,	
					hideSelectAllBox: true,
					sortable : false,
					editor: "checkbox"
					/* Apollo - 5.16.2014 
					calling of validateHist() was transfered in afterRender 
					
					editor: new MyTableGrid.CellCheckbox({
		            	onClick: function(value, checked){
		            		validateHist(value, checked);		            		
		            	}
					}) */
				},
				{
					id : "histSeqNo",
					title: "Hist No.",
					width: '50px',
					align : 'right',
					renderer: function(value){
						return formatNumberDigits(value, 3);
					}
				},
				{
					id : "itemStatCd",
					title: "Status",
					width: '45px'
				},
				{
					id : "itemNo",
					title: "Item",
					width: '45px',
					align : 'right',
					titleAlign : 'right',
					renderer: function(value){
						return formatNumberDigits(value, 5);
					}
				},
				{
					id : "dspPerilSname",
					title: "Peril",
					width: '100px'
				},
				{
					id : "currencyCd",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "currencyRate",
					title: "Currency Rate",
					width: '95px',
					align : 'right',
					renderer: function(value){
						return formatToNineDecimal(value);
					}
				},
				{
					id : "payeeType dspPayeeLastName",
					title: "Payee",
					width: '165px',
					children : [
					            {
									id : "payeeType",
									width: 25
					            },
					            {
									id : "dspPayeeLastName",
									width: 140
					            }
					            ]
				},
				{
					id : "distSw",
					title: "Dist",
					width: '40px'
				},
				{
					id : "paidAmt",
					title: "Paid Amount",
					width: '95px',
					align : 'right',
					renderer: function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "netAmt",
					title: "Net Amount",
					width: '95px',
					align : 'right',
					renderer: function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "adviseAmt",
					title: "Advice Amount",
					width: '95px',
					align : 'right',
					renderer: function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "claimId",
					title: "",
					width: '0',
					visible: false					
				},
				{
					id : "adviceId",
					title: "",
					width: '0',
					visible: false					
				},
				{
					id : "payeeCd",
					title: "",
					width: '0',
					visible: false					
				},
				{
					id : "payeeClassCd",
					title: "",
					width: '0',
					visible: false					
				},
				{
					id : "apprvdTag",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "tranId",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "closeFlag",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "clmLossId",
					title: "",
					width: '0',
					visible: false
				}
			],
			rows: jsonClmLossExp.rows
		};

	tbgClaimAdviceHistory = new MyTableGrid(historyTableModel);
	tbgClaimAdviceHistory.pager = jsonClmLossExp;
	tbgClaimAdviceHistory.render('historyTable');		
	
	/* Apollo - 5.16.2014
	observed checkboxes manually to function properly */
	
	tbgClaimAdviceHistory.afterRender = function(){
		if(tbgClaimAdviceHistory.geniisysRows.length > 0) {			
			$$("div#historyTable .mtgInputCheckbox").each(function(obj){
				obj.observe("click", function(){
					var rowIndex = this.id.substring(this.id.length - 1);
					objGICLS032.objCurrGICLClmLossExp = tbgClaimAdviceHistory.geniisysRows[rowIndex];
					objGICLS032.objCurrGICLClmLossExp.rowIndex = rowIndex;
					if(obj.checked){ //Added by: Jerome Bautista 5.20.2015 SR 4175
						objGICLS032.tempPayeeNameArray.push(objGICLS032.objCurrGICLClmLossExp.dspPayeeLastName);
					}else{
						objGICLS032.tempPayeeNameArray.pop();
					}
					validateHist(obj.checked);
				});				
			});
		}
	};
</script>