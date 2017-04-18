<div style="width: 99%;">
	<div class="sectionDiv"  style="padding: 10px;  height: 250px; margin-top: 10px; width: 855px;">
		<div id="packQuotationTGDiv" style="height: 230px;">
			<div id="packQuotationTG" style="height: 200px; width: 850px;"></div>
		</div>
		
	</div>
	
	
	<div class="sectionDiv" style="padding: 10px;  margin-top: 10px; width: 855px; height: 50px;">
		<div style="margin-top:10px;text-align:center">
			<input type="button" class="disabledButton" id="btnViewQuotation" value="View Quotation" style="width:170px;"/>
			<input type="button" class="button" id="btnMainScreen" value="Return" style="width:170px;"/>
		</div>
	</div>
</div>	
<input id="overlayLineCd" value="${lineCd }" type="hidden"/>
<input id="overlayAssdNo" value="${assdNo }" type="hidden"/>

<script>
	$("btnMainScreen").observe("click", function(){
		genericObjOverlay.close();
		delete genericObjOverlay;
	});
	
	var objExistingPackQuotationTG = JSON.parse('${jsonExistingPackQuotations}'.replace(/\\/g, '\\\\'));
	var selectedExistingQuote = {};
	
	
	try{
		var existingPackQuotationTable = {
			id: 5,
			url: contextPath+"/GIPIPackQuoteController?action=getExistingPackQuotations&refresh=1&lineCd="+$F("overlayLineCd")+"&assdNo="+$F("overlayAssdNo"),
			options: {
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						selectedExistingQuote = existingPackQuotationGrid.getRow(y);
						if(selectedExistingQuote.packQuoteId == null){
							disableButton("btnViewQuotation");
						}else{
							enableButton("btnViewQuotation");
						}
						
						
					}
					existingPackQuotationGrid.releaseKeys();
				},onRemoveRowFocus : function(){
					disableButton("btnViewQuotation");
					selectedExistingQuote = null;
			  	}/* ,onRowDoubleClick: function(y){
			  		selectedExistingQuote = existingPackQuotationGrid.getRow(y);
				//	quotationStatus.quoteId = row.packQuoteId;
					
					isMakeQuotationInformationFormsHidden = 1;
					$("quoteId").value =  selectedExistingQuote.packQuoteId;
					viewPackQuotation( selectedExistingQuote.packQuoteId);
					
				} */,toolbar: {
					elements: [/* MyTableGrid.FILTER_BTN,  */MyTableGrid.REFRESH_BTN]
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
				{	
					id: 'quoteNo',
					width: '200',
					title: 'Quotation No.'
				},
				{	
					id: 'parNo',
					width: '180',
					title: 'PAR No.'
				},
				{	
					id: 'polNo',
					width: '200',
					title: 'Policy No.'
				},
				{	
					id: 'tsiAmt',
					width: '100',
					title: 'Sum Insured',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number'
				},
				{	
					id: 'inceptDate',
					width: '80',
					title: 'Incept Date'
				},{	
					id: 'expiryDate',
					width: '80',
					title: 'Expiry Date'
				},
				{	
					id: 'address',
					width: '200',
					title: 'Address'
				},
				{	
					id: 'status',
					width: '100',
					title: 'Status'
				},
				{	
					id: 'packQuoteId',
					width: '0',
					title: '',
					visible: false
				}
				
			],rows: objExistingPackQuotationTG.rows 
		};
			
		existingPackQuotationGrid = new MyTableGrid(existingPackQuotationTable);
		existingPackQuotationGrid.pager = objExistingPackQuotationTG;
		existingPackQuotationGrid.render('packQuotationTG');
	}catch(e){
		showErrorMessage("Error in existing pack quotation page.",e);
	}
	
	function viewPackQuotation(quoteId){
		try{
			
			isMakeQuotationInformationFormsHidden = 1;
			new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationInformationController?action=showQuoteInformationPage&userId=" + userId,
				{method : "GET",
				parameters : {
					quoteId : quoteId,
					lineCd: $F("overlayLineCd"),
					ajax : "1"
				},
				evalScripts : true,
				asynchronous : true,
				onCreate : function(){ 
					genericObjOverlay.close();
					delete genericObjOverlay;
					showNotice("Getting quotation information, please wait...");
					resetQuoteInfoGlobals();
				},
				onComplete : function(){
					Effect.Appear("quotationInformationMainDiv", {
						duration : .001
					});
					setDocumentTitle("Quotation Information");
					//$("quotationMenus").show();					
					//$("marketingMainMenu").hide();
					initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
					addStyleToInputs();
					initializeAll();
				}
			});
		}catch(e){
			showErrorMessage("viewQuotation",e);
		}
	}
	
	$("btnViewQuotation").observe("click", function(){
		viewPackQuotation2(selectedExistingQuote.packQuoteId);
	});
	
	function viewPackQuotation2(packQuoteId){
		try{
			objQuote.fromGIIMM001A = "Y";
			objQuote.giimm001ALineCd = $F("lineCd");
			objQuote.giimm001ALineName = $F("lineName");
			objQuote.giimm001AAssdNo = $("assuredNo").value == null || $("assuredNo").value=="" ? objQuote.giimm001AAssdNo :  $("assuredNo").value; //added by steven 1/30/2013
			populateQuoteInfoToGlobal(); //added by steven 1/30/2013 -> ilalagay ung laman nung mga field sa global.
			objMKGlobal.packQuoteId = packQuoteId;
			objGIPIPackQuote = new Object();
			objGIPIPackQuote.quoteNo = selectedExistingQuote.quoteNo;
			objGIPIPackQuote.assdName = $F("assuredName");
			
			isMakeQuotationInformationFormsHidden = 1;
			new Ajax.Updater("packQuoteDynamicDiv", contextPath + "/GIPIPackQuotationInformationController?action=showPackQuotationInformationPage",
				{method : "GET",
				parameters : {
					packQuoteId : packQuoteId,
					fromCreatePackQuote : "Y"
				},
				evalScripts : true,
				asynchronous : true,
				onCreate : function(){
					genericObjOverlay.hide();
					delete genericObjOverlay;
					showNotice("Getting quotation information, please wait...");
					resetQuoteInfoGlobals();
				},
				onComplete : function(){
					setDocumentTitle("Quotation Information");
					$("contentsDiv").update("");
					$("packQuotationInformationMainDiv").show();
				}
			});
		}catch(e){
			showErrorMessage("viewQuotation",e);
		}
	}
</script>