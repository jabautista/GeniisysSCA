<div style="width: 99%;">
	<div class="sectionDiv"  style="padding: 10px;  height: 250px; margin-top: 10px; width: 855px;">
		<div id="quotationTGDiv" style="height: 230px;">
			<div id="quotationTG" style="height: 200px; width: 850px;"></div>
		</div>
		
	</div>
	
	
	<div class="sectionDiv" style="padding: 10px;  margin-top: 10px; width: 855px; height: 50px;">
		<div style="margin-top:10px;text-align:center">
			<input type="button" class="disabledButton" id="btnViewQuotation" value="View Quotation"/>
			<input type="button" class="disabledButton" id="btnViewPolicyInformation" value="View Policy Information"/>
			<input type="button" class="button" id="btnReturn" value="Return"/>
		</div>
	</div>
</div>	
<input id="overlayLineCd" value="${lineCd }" type="hidden"/>
<input id="overlayAssdNo" value="${assdNo }" type="hidden"/>
<input id="OverlayVExist2" value="${vExist2 }" type="hidden" />
<input id="overlayAssdName" value="${assdName }" type="hidden" />
<script>
	$("btnReturn").observe("click", function(){
		genericObjOverlay.close();
		delete genericObjOverlay;
	});
	var selectedExistingQuote = {};
	var objGIPIQuotes = JSON.parse('${existingQuotesAndPoliciesTableGrid}'.replace(/\\/g, '\\\\'));  
	try{
		var existingQuotationTable = {
			id: 5,
			url: contextPath+"/GIPIQuotationController?action=getExistingQuotesPolsListing&refresh=1&lineCd="+$F("overlayLineCd")+"&assdNo="+$F("overlayAssdNo")+"&vExist2="+$F("OverlayVExist2")+"&assdName="+$F("overlayAssdName"),
			options: {
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						selectedExistingQuote = existingQuotationGrid.getRow(y);
						if(selectedExistingQuote.quoteId == null){
							disableButton("btnViewQuotation");
						}else{
							enableButton("btnViewQuotation");
						}
						
						if(selectedExistingQuote.policyId == null){
							disableButton("btnViewPolicyInformation");
						}else{
							enableButton("btnViewPolicyInformation");
						}
						
						
					}
					existingQuotationGrid.releaseKeys();
				},onRemoveRowFocus : function(){
					disableButton("btnViewQuotation");
					disableButton("btnViewPolicyInformation");
					selectedExistingQuote = null;
			  	}/* ,onRowDoubleClick: function(y){
			  		selectedExistingQuote = existingQuotationGrid.getRow(y);
					
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
					id: 'quoteId',
					width: '0',
					title: '',
					visible: false
				},
				{	
					id: 'policyId',
					width: '0',
					title: '',
					visible: false
				},
				{	
					id: 'origPolicyId',
					width: '0',
					title: '',
					visible: false
				}
				
			],rows: objGIPIQuotes.rows 
		};
			
		existingQuotationGrid = new MyTableGrid(existingQuotationTable);
		existingQuotationGrid.pager = objGIPIQuotes;
		existingQuotationGrid.render('quotationTG');
	}catch(e){
		showErrorMessage("Error in existing quotation page.",e);
	}
	
	objGIPIS100.callingForm = "GIIMM000";
	
	$("btnViewQuotation").observe("click",function(){
		if(selectedExistingQuote == null){
			showMessageBox("Please select a record first.", "I");
		}else{
			$("quoteId").value =  selectedExistingQuote.quoteId;
			//viewQuotation(selectedExistingQuote.quoteId);
			showQuotationStatusFromExt(); // bonok :: 02.07.2013
		}
	});
	
	function showQuotationStatusFromExt(){ // bonok :: 02.07.2013 
		var quoteId = nvl($F("quoteId"), "") == "" ? selectedExistingQuote.quoteId : $F("quoteId");
		objGIPIQuote.quoteId = selectedExistingQuote.quoteId;
		
		objQuote.giimm001LineCd = $F("lineCd");
		objQuote.giimm001LineName = $F("lineName");
		objQuote.giimm001AssdNo = $F("assuredNo");
		objQuote.giimm001AssdName = $F("assuredName");
		objQuote.giimm001VExist2 = $F("vExist2");
		populateQuoteInfoToGlobal(); //added by steven 12/04/2012 -> ilalagay ung laman nung mga field sa global.
		isMakeQuotationInformationFormsHidden = 1;
		new Ajax.Updater("quoteDynamicDiv", contextPath + "/GIPIQuoteController?action=showViewQuotationStatusPage", {
			method : "GET",
			parameters : {
				quoteId : quoteId,
				lineCd  : getLineCdMarketing()
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function(){ 
				genericObjOverlay.close();
				showNotice("Getting quotation information, please wait...");
			},
			onComplete : function(){
				changeTag = 0;
				hideNotice("");
				objQuote.fromGIIMM001 = "Y";
				Effect.Appear("quotationInformationMainDiv", {
					duration : .001
				});
				setModuleId("GIIMM005");
				setDocumentTitle("View Quotation Information");
				$("contentsDiv").hide();
				$("reassignExit").stopObserving();
				$("reassignExit").observe("click", function(){
					$("home").show();
					$("quotationProcessing").show();
					$("quotationMenus").show();
					$("reassignMenu").hide();
					showCreateQuoteFromQuoteInfo();
				});			
				$("home").hide();
				$("quotationProcessing").hide();
				$("quotationMenus").hide();
				$("reassignMenu").show();
				initializeMenu();
				addStyleToInputs();
				initializeAll();
			}
		});
	}
	
	function viewQuotation(quoteId){
		try{
			objQuote.giimm001LineCd = $F("lineCd");
			objQuote.giimm001LineName = $F("lineName");
			objQuote.giimm001AssdNo = $F("assuredNo");
			objQuote.giimm001AssdName = $F("assuredName");
			populateQuoteInfoToGlobal(); //added by steven 12/04/2012 -> ilalagay ung laman nung mga field sa global.
			isMakeQuotationInformationFormsHidden = 1;
			new Ajax.Updater("quoteDynamicDiv", contextPath + "/GIPIQuotationInformationController?action=showQuoteInformationPage&userId=" + userId,
				{method : "GET",
				parameters : {
					quoteId : quoteId,
					lineCd: $F("overlayLineCd"),
					fromCreateQuote : "Y",
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
					changeTag = 0;
					hideNotice(); //added by steven 11/6/2012
					objQuote.fromGIIMM001 = "Y";
					$("contentsDiv").innerHTML = "";
					Effect.Appear("quotationInformationMainDiv", {
						duration : .001
					});
					setDocumentTitle("Quotation Information");
					$("contentsDiv").hide();
					$("gimmExit").stopObserving(); // marco - 06.25.2012 - to return to GIIMM001
					$("gimmExit").observe("click", function(){
						showCreateQuoteFromQuoteInfo();
					});
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
	
	$("btnViewPolicyInformation").observe("click", function(){
		if(selectedExistingQuote == null){
			showMessageBox("Please select a record first.", "I");
		}else{
			viewPolicyInfoFromCreate();			
		}
	});
	
	// marco - 06.22.2012 - to view policy information
	function viewPolicyInfoFromCreate(){
		try{
			objQuote.giimm001LineCd = $F("lineCd");
			objQuote.giimm001LineName = $F("lineName");
			objQuote.giimm001AssdNo = $F("assuredNo");
			objQuote.giimm001AssdName = $F("assuredName");
			
			populateQuoteInfoToGlobal(); //added by steven 12/04/2012 -> ilalagay ung laman nung mga field sa global.
			
			new Ajax.Updater("quoteDynamicDiv", contextPath+"/GIPIPolbasicController?action=showViewPolicyInformationPage",{
				method: "POST",
				parameters: {policyId : nvl(selectedExistingQuote.origPolicyId, selectedExistingQuote.policyId)},
				evalScripts: true,
				asynchronous: true,
				onCreate: function(){
					showNotice("Getting Policy Information page, please wait...");
					resetQuoteInfoGlobals();
				},
				onComplete: function (response) {
					hideNotice();
					if(checkErrorOnResponse(response)){
						objGIPIS100.callingForm = "GIIMM001";
						$("mainNav").hide();
						$("contentsDiv").innerHTML = "";
						$("contentsDiv").hide();
						genericObjOverlay.close();
						setDocumentTitle("View Policy Information");
						initializeMenu();
					}
				}
			});
		}catch(e){
			showErrorMessage("viewPolicyInfoFromCreate", e);
		}
	}
	initializeAll();
</script>