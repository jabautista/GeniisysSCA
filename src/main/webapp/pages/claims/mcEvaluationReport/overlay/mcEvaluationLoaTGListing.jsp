<div style="width: 99%;">
	<div class="sectionDiv"  style="padding: 10px;  height: 220px; margin-top: 10px; width: 805px;">
		<div id="mainLOATGDiv" style="height: 190px;">
			<div id="mainLOATG" style="height: 170px; width: 850px;"></div>
		</div>
		<div style="height: 30px;">
			<span style="float: left; margin-top: 5px; margin-right: 3px;">Remarks: </span>
			<span id="particularsSpan" style="border: 1px solid gray; width: 740px; height: 21px; float: left;"> 
				<input type="text" id="generateRemarks" name="generateRemarks" style="border: none; float: left; width: 96%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" /> 
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnGenerateRemarksGo" name="btnGenerateRemarksGo" alt="Go" style="background: transparent;" />
			</span>
		</div>
	</div>
	<div id="loaDtlDiv"  class="sectionDiv" style="padding: 10px;  margin-top: 10px; width: 805px; height: 210px;">
		
	</div>
	
	<div style="margin-top:0px;text-align:center; width: 805px;">
		<input type="button" class="disabledButton" id="btnGenerate" value="Generate LOA" style="width:170px; margin-top: 10px;"/>
		<input type="button" class="disabledButton" id="btnPrintLoaOrCsl" value="Print LOA" style="width:170px;"/>
		<input type="button" class="button" id="btnMainScreen" value="Main Screen" style="width:170px;"/>
	</div>
	
</div>	
<input type="hidden" id="evalId" value=""/>
<input type="hidden" id="payeeTypeCd" value=""/>
<input type="hidden" id="payeeCd" value=""/>
<script>
	$("btnMainScreen").observe("click", function(){
		genericObjOverlay.close();
	});
	
	$("btnGenerateRemarksGo").observe("click",function(){
		showEditor("generateRemarks","2000");
	});
	
	var objLoaTG = JSON.parse('${mcEvalLoaTG}'.replace(/\\/g, '\\\\'));
	tempArrForPrint = [];
	tempArrForGenerate = [];
	var loaIndex; 
	var objSelectedLoa = {};
	var remarksArr = [];
	
	$("generateRemarks").observe("blur", function(){
		if(objSelectedLoa != null){
			for ( var i = 0; i < remarksArr.length; i++) {
				if(objSelectedLoa.loaNo == remarksArr[i].loaNo && objSelectedLoa.payeeCd == remarksArr[i].payeeCd && objSelectedLoa.payeeTypeCd == remarksArr[i].payeeTypeCd){
					remarksArr[i].remarks = escapeHTML2($F("generateRemarks"));
				}
			}
		}
	});
	
	function generateLoa(){
		try{
			//build final list of loa
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
					if(tempArrForGenerate[i].loaNo == remarksArr[r].loaNo && tempArrForGenerate[i].payeeCd == remarksArr[r].payeeCd && tempArrForGenerate[i].payeeTypeCd == remarksArr[r].payeeTypeCd){
						tempArrForGenerate[i].remarks =remarksArr[r].remarks;
					}
				}
			}
			
			new Ajax.Request(contextPath +"/GICLEvalLoaController", {
				parameters: {
					action: "generateLoa",
					method: "POST",
					loaList : prepareJsonAsParameter(tempArrForGenerate)
				},	
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Generating LOA.."),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							genericObjOverlay.close();
							showMcEvalLoa();
						});
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
				
			});
		}catch(e){
			showErrorMessage("generateLoa",e);
		}
	}
	
	
	function showRemarksLoa(selectedObj, arrayObj){
		try{
			for ( var i = 0; i < arrayObj.length; i++) {
				if(selectedObj.loaNo == arrayObj[i].loaNo && selectedObj.payeeCd == arrayObj[i].payeeCd && selectedObj.payeeTypeCd == arrayObj[i].payeeTypeCd){
					$("generateRemarks").value = unescapeHTML2(arrayObj[i].remarks);
				}
			}
		}catch(e){
			showErrorMessage("showRemarksLoaCsl",e);
		}
	}
	
	/* benjo 03.08.2017 SR-5945 */
	function checkEvalVatExist(){	
		var result = false;
		new Ajax.Request(contextPath+"/GICLEvalVatController?action=checkEvalVatExist", {
			method: "POST",
			parameters: {
				evalId : selectedMcEvalObj.evalId
			},
			asynchronous: false,
			onCreate: showNotice("Checking V.A.T. Details..."),
			onComplete: function (response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText=="Y"){
						result = true;
					}else{
						result = false;
					}
				}
			}
		});
		return result;
	}
	
	$("btnGenerate").observe("click", function(){
		showConfirmBox("Generate LOA", "Generate LOA No. for the selected record/s?","Yes","No",generateLoa, null);
	});
	try{
		var mainLOATable = {
			id: 2,
			url: contextPath+"/GICLMcEvaluationController?action=getMcEvalLoaTGLst&refresh=1&evalId="+selectedMcEvalObj.evalId,
			options: {
				height: '150px',
				width: '800px',
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						loaIndex = y;
						objSelectedLoa = mainLOAGrid.getRow(y);
						getMcEvalLoaDtlTGList(objSelectedLoa);
						showRemarksLoa(objSelectedLoa, remarksArr );
					}
				},onRemoveRowFocus : function(){
					loaIndex = null;
					objSelectedLoa= null;
					getMcEvalLoaDtlTGList(null);
					$("generateRemarks").value = "";
					mainLOAGrid.keys.removeFocus(mainLOAGrid.keys._nCurrentFocus, true);
					mainLOAGrid.releaseKeys();
			  	},toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function (){
						loaIndex = null;
						objSelectedLoa= null;
						getMcEvalLoaDtlTGList(null);
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
					altTitle: 'Generate LOA',
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
	            				if(nvl(objSelectedLoa.loaNo,"") != ""){
	            					showMessageBox("LOA No. has already been generated for this record.", "I");
	            					$("mtgInput"+mainLOAGrid._mtgId+"_2,"+loaIndex).checked = false;		
	            				}else{
	            					/* benjo 03.08.2017 SR-5945 */
	            					if(checkEvalVatExist()){
	            						tempArrForGenerate.push(mainLOAGrid.getRow(loaIndex));
	            					}else{
	            						$("mtgInput"+mainLOAGrid._mtgId+"_2,"+loaIndex).checked = false;
	            						showMessageBox("Cannot Generate LOA for this record. Please check MC Eval [V.A.T Details].", "I");
	            					}
	            				}
	            				
	            			}else{
	            				for ( var i = 0; i < tempArrForGenerate.length; i++) {
	            					if(tempArrForGenerate[i].evalId == mainLOAGrid.getRow(loaIndex).evalId){
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
					altTitle: 'Print LOA',
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
	            				
	            				if(nvl(objSelectedLoa.loaNo,"") == ""){
	            					showMessageBox("No LOA No. has been generated for this record.", "I");
	            					$("mtgInput"+mainLOAGrid._mtgId+"_3,"+loaIndex).checked = false;		
	            				}else{
	            					tempArrForPrint.push(mainLOAGrid.getRow(loaIndex));	
	            				}
	            				
	            			}else{
	            				for ( var i = 0; i < tempArrForPrint.length; i++) {
	            					if(tempArrForPrint[i].evalId == mainLOAGrid.getRow(loaIndex).evalId){
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
					width: '180',
					title: 'Company',
				  	filterOption: true
				},
				{	
					id: 'payeeName',
					width: '240',
					title: 'Payee Name',
				  	filterOption: true
				},
				{	
					id: 'baseAmt',
					width: '145',
					title: 'Amount',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				},
				{	
					id: 'loaNo',
					width: '145',
					title: 'LOA No.',
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
			],rows: objLoaTG.rows 
		};
			
		mainLOAGrid = new MyTableGrid(mainLOATable);
		mainLOAGrid.pager = objLoaTG;
		mainLOAGrid.render('mainLOATG');
		mainLOAGrid.afterRender = function (){
			remarksArr = objLoaTG.rows ;
		};
	}catch(e){
		showErrorMessage("mcEvalLoaTG",e);
	}
	
	$("btnPrintLoaOrCsl").observe("click", function(){
		checkUnpaidPremiums2("LOA");
	});
	
	getMcEvalLoaDtlTGList(null);
</script>
