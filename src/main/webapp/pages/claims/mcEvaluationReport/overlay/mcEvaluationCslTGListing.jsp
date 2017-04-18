<div style="width: 99%;">
	<div class="sectionDiv"  style="padding: 10px;  height: 250px; margin-top: 10px; width: 855px;">
		<div id="mainCSLTGDiv" style="height: 230px;">
			<div id="mainCSLTG" style="height: 200px; width: 850px;"></div>
		</div>
		<div style="height: 30px;">
			<span style="float: left; margin-top: 5px;">Remarks: </span>
			<span id="particularsSpan" style="border: 1px solid gray; width: 785px; height: 21px; float: left;"> 
				<input type="text" id="generateRemarks" name="generateRemarks" style="border: none; float: left; width: 96%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" /> 
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnGenerateRemarksGo" name="btnGenerateRemarksGo" alt="Go" style="background: transparent;" />
			</span>
		</div>
	</div>
	<div id="cslDtlDiv"  class="sectionDiv" style="padding: 10px;  margin-top: 10px; width: 855px; height: 230px;">
		
	</div>
	
	<div class="sectionDiv" style="padding: 10px;  margin-top: 10px; width: 855px; height: 50px;">
		<div style="margin-top:10px;text-align:center">
			<input type="button" class="disabledButton" id="btnGenerate" value="Generate CSL" style="width:170px;"/>
			<input type="button" class="disabledButton" id="btnPrintLoaOrCsl" value="Print CSL" style="width:170px;"/>
			<input type="button" class="button" id="btnMainScreen" value="Main Screen" style="width:170px;"/>
		</div>
	</div>
</div>	
<input type="hidden" id="evalId" value=""/>
<input type="hidden" id="payeeTypeCd" value=""/>
<input type="hidden" id="payeeCd" value=""/>

<script type="text/javascript">
	$("btnMainScreen").observe("click", function(){
		genericObjOverlay.close();
	});
	
	var objCslTG = JSON.parse('${mcEvalCslTG}'.replace(/\\/g, '\\\\'));
	tempArrForPrint = [];
	tempArrForGenerate = [];
	var cslIndex; 
	var objSelectedCsl = {};
	var remarksArr = [];
	
	function showRemarksCsl(selectedObj, arrayObj){
		try{
			for ( var i = 0; i < arrayObj.length; i++) {
				if(selectedObj.cslNo == arrayObj[i].cslNo && selectedObj.payeeCd == arrayObj[i].payeeCd && selectedObj.payeeTypeCd == arrayObj[i].payeeTypeCd){
					$("generateRemarks").value = unescapeHTML2(arrayObj[i].remarks);
				}
			}
		}catch(e){
			showErrorMessage("showRemarksCsl",e);
		}
	}
	
	function generateCsl(){
		try{
			//build final list of csl
			for ( var i = 0; i < tempArrForGenerate.length; i++) {
				//set addional parameters from master eval detail
				tempArrForGenerate[i].claimId = selectedMcEvalObj.claimId;
				tempArrForGenerate[i].itemNo = selectedMcEvalObj.itemNo;
				tempArrForGenerate[i].evalId = selectedMcEvalObj.evalId;
				tempArrForGenerate[i].tpSw = selectedMcEvalObj.tpSw;
				tempArrForGenerate[i].sublineCd = selectedMcEvalObj.sublineCd;
				tempArrForGenerate[i].issCd = selectedMcEvalObj.issCd;
				tempArrForGenerate[i].clmYy = mcMainObj.clmYy;
				
				//get the temp remarks 
				for ( var r = 0; r < remarksArr.length; r++) {
					if(tempArrForGenerate[i].cslNo == remarksArr[r].cslNo && tempArrForGenerate[i].payeeCd == remarksArr[r].payeeCd && tempArrForGenerate[i].payeeTypeCd == remarksArr[r].payeeTypeCd){
						tempArrForGenerate[i].remarks =remarksArr[r].remarks;
					}
				}
			}
			
			new Ajax.Request(contextPath +"/GICLEvalCslController", {
				parameters: {
					action: "generateCsl",
					method: "POST",
					cslList : prepareJsonAsParameter(tempArrForGenerate)
				},	
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Generating CSL.."),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							genericObjOverlay.close();
							showMcEvalCsl();
						});
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
				
			});
		}catch(e){
			showErrorMessage("generateCsl",e);
		}
	}
	$("btnGenerate").observe("click", function(){
		showConfirmBox("Generate CSL", "Generate CSL No. for the selected record/s?","Yes","No",generateCsl, null);
	});
	try{
		var mainCSLTable = {
				id: 2,
				url: contextPath+"/GICLEvalCslController?action=getMcEvalCslTGList&refresh=1&evalId="+selectedMcEvalObj.evalId,
				options: {
					onCellFocus: function(element, value, x, y, id) {
						if (y >= 0){
							cslIndex = y;
							objSelectedCsl = mainCSLGrid.getRow(y);
							getMcEvalCslDtlTGList(objSelectedCsl);
							showRemarksCsl(objSelectedCsl, remarksArr );
						}
						//mainCSLGrid.releaseKeys();
					},onRemoveRowFocus : function(){
						cslIndex = null;
						objSelectedCsl = null;
						getMcEvalCslDtlTGList(null);
						$("generateRemarks").value = "";
				  	},toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onRefresh: function (){
							getMcEvalCslDtlTGList(null);
						}
					}
				},columnModel : [
					{   
						id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	id:'generateSw',
						sortable:	false,
						align:		'left',
						title:		'&#160;G',
						width:		'22px',
						altTitle: 'Generate CSL',
						editable:  true,
						hideSelectAllBox : true,
						editor: new MyTableGrid.CellCheckbox({
							getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked) {
		            			if(value == "Y"){
		            				if(nvl(objSelectedCsl.cslNo,"") != ""){
		            					showMessageBox("CSL No. has already been generated for this record.", "I");
		            					$("mtgInput"+mainCSLGrid._mtgId+"_2,"+cslIndex).checked = false;		
		            				}else{
		            					tempArrForGenerate.push(mainCSLGrid.getRow(cslIndex));	
		            				}
		            				
		            			}else{
		            				for ( var i = 0; i < tempArrForGenerate.length; i++) {
		            					if(tempArrForGenerate[i].evalId == mainCSLGrid.getRow(cslIndex).evalId){
		            						tempArrForGenerate.splice(i,1);
		            					}
									}
		            			}	
		            			toggleLoaCslButtons();
		 			    	} 
			            })
					},{	id:'printSw',
						sortable:	false,
						align:		'left',
						title:		'&#160;P',
						width:		'22px',
						altTitle: 'Print CSL',
						editable:  true,
						hideSelectAllBox : true,
						editor: new MyTableGrid.CellCheckbox({
							getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked) {
		            			if(value == "Y"){
		            				
		            				if(nvl(objSelectedCsl.cslNo,"") == ""){
		            					showMessageBox("No CSL No. has been generated for this record.", "I");
		            					$("mtgInput"+mainCSLGrid._mtgId+"_3,"+cslIndex).checked = false;		
		            				}else{
		            					tempArrForPrint.push(mainCSLGrid.getRow(cslIndex));	
		            				}
		            				
		            			}else{
		            				for ( var i = 0; i < tempArrForPrint.length; i++) {
		            					if(tempArrForPrint[i].evalId == mainCSLGrid.getRow(cslIndex).evalId){
		            						tempArrForPrint.splice(i,1);
		            					}
									}
		            			}	
		            			toggleLoaCslButtons();
		 			    	} 
			            })
					},
					{	
						id: 'dspClassDesc',
						width: '200',
						title: 'Company',
					  	filterOption: true
					},
					{	
						id: 'payeeName',
						width: '260',
						title: 'Payee Name',
					  	filterOption: true
					},
					{	
						id: 'baseAmt',
						width: '180',
						title: 'Amount',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					},
					{	
						id: 'cslNo',
						width: '180',
						title: 'CSL No.',
					  	filterOption: true
					},
					{	
						id: 'evalId',
						width: '0',
						visible: false
					},
					{	
						id: 'payeeCd',
						width: '0',
						visible: false
					},
					{	
						id: 'payeeTypeCd',
						width: '0',
						visible: false
					},
					{	
						id: 'clmLossId',
						width: '0',
						visible: false
					}
				],rows: objCslTG.rows 
			};
				
			mainCSLGrid = new MyTableGrid(mainCSLTable);
			mainCSLGrid.pager = objCslTG;
			mainCSLGrid.render('mainCSLTG');
	}catch(e){
		showErrorMessage("CSL TG Error",e);
	}
	
	getMcEvalCslDtlTGList(null);
	
	$("btnPrintLoaOrCsl").observe("click", function(){
		checkUnpaidPremiums2("CSL");
	});
</script>