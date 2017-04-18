<div id="mcEvaluationTGDiv" style="padding: 10px;">
	<div id="mcEvaluationTG" style="height: 200px; width: 900px;"></div>
</div>

<script type="text/javascript">
	var objMcEvalTG = JSON.parse('${mcEvalTg}');
	var mtgId;
	
	var mcEvalTable = {
		id: 260,	
		url: contextPath+"/GICLMcEvaluationController?action=getMcEvaluationTGList&refresh=1"+
			"&claimId="+nvl(mcMainObj.claimId,"")+ "&itemNo="+nvl(mcMainObj.itemNo,"")+ "&payeeNo="+nvl(mcMainObj.payeeNo,"")+ "&payeeClassCd="+nvl(mcMainObj.payeeClassCd,"")+
			"&plateNo=" +nvl(mcMainObj.plateNo,"")+"&perilCd="+nvl(mcMainObj.perilCd,"") + 		
			"&polLineCd=" +nvl(mcMainObj.polLineCd,"")+"&polSublineCd="+nvl(mcMainObj.polSublineCd,"") + "&polIssCd=" +nvl(mcMainObj.polIssCd,"")+"&polIssueYy="+nvl(mcMainObj.polIssueYy,"") + 
			"&polRenewNo="+nvl(mcMainObj.polRenewNo,"")
		,options : {
			prePager: function(){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
					return false;
				} else {
					populateEvalSumFields(null);
					populateOtherDetailsFields(null);
					toggleButtons(null);
					toggleEditableOtherDetails(false);
					enableButton("btnAddReport");
					disableButton("btnSave");
					selectedMcEvalObj = null;
					return true;
				}
			},beforeSort: function(){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
					return false;
				} else {
					populateEvalSumFields(null);
					populateOtherDetailsFields(null);
					toggleButtons(null);
					toggleEditableOtherDetails(false);
					enableButton("btnAddReport");
					disableButton("btnSave");
					selectedMcEvalObj = null;
					return true;
				}
			},
			onCellFocus: function(element, value, x, y, id) {
				mtgId = mcEvalGrid._mtgId;
				if (y >= 0){
					selectedMcEvalObj = mcEvalGrid.getRow(y);
					populateEvalSumFields(selectedMcEvalObj);
					populateOtherDetailsFields(selectedMcEvalObj);
					toggleButtons(selectedMcEvalObj);
					$("editMode").value = "Y";
					disableButton("btnAddReport");
					enableButton("btnSave");
				}
				mcEvalGrid.keys.removeFocus(mcEvalGrid.keys._nCurrentFocus, true);
				mcEvalGrid.releaseKeys();
			},onRemoveRowFocus : function(){
				populateEvalSumFields(null);
				populateOtherDetailsFields(null);
				toggleButtons(null);
				toggleEditableOtherDetails(false);
				enableButton("btnAddReport");
				disableButton("btnSave");
				selectedMcEvalObj = null;
				$("editMode").value = "";
				mcEvalGrid.keys.removeFocus(mcEvalGrid.keys._nCurrentFocus, true);
				mcEvalGrid.keys.releaseKeys();
		  	},toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onAdd: function(){ // remove the function from onAdd because when the user returns from the add page, the added row still remains
					mcEvalGrid.keys.releaseKeys();
				},onRefresh: function (){
					populateEvalSumFields(null);
					populateOtherDetailsFields(null);
					toggleButtons(null);
					toggleEditableOtherDetails(false);
					enableButton("btnAddReport");
					selectedMcEvalObj = null;
					$("editMode").value = "";
					changeTag = 0;
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
			} ,
			{	
				id: 'evaluationNo',
				width: '300',
				title: 'Evaluation Number'  //corrected spelling by robert 
			},
			{	
				id: 'csoId',
				width: '200',
				title: 'Claim Service Officer',
			  	filterOption: true
			},
			{	
				id: 'evalDate',
				width: '150',
				title: 'Evaluation Date',
			  	filterOption: true
			} ,
			{	
				id: 'inspectDate',
				width: '150',
				title: 'Inspection Date',
			  	filterOption: true
			},
			{
				id: 'claimId',
				width: "0",
				visible: false
			},
			{
				id: 'evalId',
				width: "0",
				visible: false
			},
			{
				id: 'itemNo',
				width: "0",
				visible: false
			},
			{
				id: 'perilCd',
				width: "0",
				visible: false
			},
			{
				id: 'sublineCd',
				width: "0",
				visible: false
			},
			{
				id: 'issCd',
				width: "0",
				visible: false
			},
			{
				id: 'evalYy',
				width: "0",
				visible: false
			},
			{
				id: 'evalSeqNo',
				width: "0",
				visible: false
			},
			{
				id: 'evalVersion',
				width: "0",
				visible: false
			},
			{
				id: 'reportType',
				width: "0",
				visible: false
			},
			{
				id: 'evalMasterId',
				width: "0",
				visible: false
			},
			{
				id: 'payeeNo',
				width: "0",
				visible: false
			},
			{
				id: 'payeeClassCd',
				width: "0",
				visible: false
			},
			{
				id: 'plateNo',
				width: "0",
				visible: false
			},
			{
				id: 'tpSw',
				width: "0",
				visible: false
			},
			{
				id: 'adjusterId',
				width: "0",
				visible: false
			},
			{
				id: 'replaceAmt',
				width: "0",
				visible: false
			},
			{
				id: 'vat',
				width: "0",
				visible: false
			},
			{
				id: 'depreciation',
				width: "0",
				visible: false
			},
			{
				id: 'remarks',
				width: "0",
				visible: false
			},
			{
				id: 'currencyCd',
				width: "0",
				visible: false
			},
			{
				id: 'currencyRate',
				width: "0",
				visible: false
			},
			{
				id: 'dspAdjusterDesc',
				width: "0",
				visible: false
			},
			{
				id: 'dspPayee',
				width: "0",
				visible: false
			},
			{
				id: 'dspCurrShortname',
				width: "0",
				visible: false
			},
			{
				id: 'dspDiscount',
				width: "0",
				visible: false
			},
			{
				id: 'deductible',
				width: "0",
				visible: false
			},
			{
				id: 'totEstCos',
				width: "0",
				visible: false
			},
			{
				id: 'totErc',
				width: "0",
				visible: false
			},
			{
				id: 'totInp',
				width: "0",
				visible: false
			},
			{
				id: 'totInl',
				width: "0",
				visible: false
			},
			{
				id: 'dspReportTypeDesc',
				width: "0",
				visible: false
			},
			{
				id: 'dspEvalDesc',
				width: "0",
				visible: false
			},
			{
				id: 'repairGross',
				width: "0",
				visible: false
			},
			{
				id: 'replaceGross',
				width: "0",
				visible: false
			},
			{
				id: 'repairAmt',
				width: "0",
				visible: false
			},
			{
				id: 'evalStatCd',
				width: "0",
				visible: false
			},
			{
				id: 'varPayeeCdGiclReplace',
				width: "0",
				visible: false
			},
			{
				id: 'varPayeeTypeCdGiclReplace',
				width: "0",
				visible: false
			},
			{
				id: 'masterFlag',
				width: "0",
				visible: false
			},
			{
				id: 'cancelFlag',
				width: "0",
				visible: false
			},
			{
				id: 'dedFlag',
				width: "0",
				visible: false
			},
			{
				id: 'depFlag',
				width: "0",
				visible: false
			},
			{
				id: 'inHouAdj',
				width: "0",
				visible: false
			},{
				id: 'inspectPlace',
				width: '0',
				visible: false
			},{
				id: 'masterReportType',
				width: '0',
				visible: false
			},{
				id: 'mainEvalVatExist',
				width: '0',
				visible: false
			}
		],rows: objMcEvalTG.rows
	};
	mcEvalGrid = new MyTableGrid(mcEvalTable);
	mcEvalGrid.pager = objMcEvalTG;
	mcEvalGrid.render('mcEvaluationTG');
	mcEvalGrid.afterRender = function(){ //marco - 03.27.2014
		mcEvalGrid.onRemoveRowFocus();
	};
	
	initializeAccordion();
	
	
</script>

