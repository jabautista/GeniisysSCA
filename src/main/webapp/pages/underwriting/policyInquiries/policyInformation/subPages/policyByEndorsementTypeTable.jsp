<div id="policyByEndorsementTypeTableGridSectionDiv" style="height:204px;width:856px; float: left;">
	<div id="policyByEndorsementTypeTableGridDiv" style="margin-left: 125px; margin-top: 10px;  height:214px;">
		<div id="policyByEndorsementTypeListing" style="height:181px;width:856px;"></div>
	</div>
	<div id="endtTypeListTGDiv" style="margin-left: 125px; margin-top: 10px; float: left; width: 856px; height: 204px; ">
		
	</div>
</div>

<script type="text/javascript" src="underwriting.js">
try{
	var policyByEndorsementTypeSelectedIndex;
	var objPolicyByEndorsementType = new Object();
	objPolicyByEndorsementType.objPolicyByEndorsementTypeListTableGrid = JSON.parse('${policyListByEndorsementType}'.replace(/\\/g, '\\\\'));
	objPolicyByEndorsementType.objPolicyByEndorsementTypeList = objPolicyByEndorsementType.objPolicyByEndorsementTypeListTableGrid.rows || [];

	try{ // policyByEndorsementTypeTableGrid is actually the endorsement code and title list
		var policyByEndorsementTypeTableModel = {
			url:contextPath+"/GIPIPolbasicController?action=getPolicyListByEndorsementType"+
				"&refresh=1",
			options:{
					title: '',
					width:'651px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = policyByEndorsementTypeTableGrid._mtgId;
						policyByEndorsementTypeSelectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							policyByEndorsementTypeSelectedIndex = y;
						}
						
						policyByEndorsementTypeTableGrid.keys.removeFocus(policyByEndorsementTypeTableGrid.keys._nCurrentFocus, true);
						policyByEndorsementTypeTableGrid.keys.releaseKeys();
						
						var endtCd = policyByEndorsementTypeTableGrid.geniisysRows[y].endtCd;
						queryEndtTypeList(endtCd);
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						endtTypeListTableGrid.url = contextPath+"/GIPIPolbasicController?action=getEndtTypeList&refresh=1";
						endtTypeListTableGrid._refreshList();
						
						policyByEndorsementTypeTableGrid.keys.removeFocus(policyByEndorsementTypeTableGrid.keys._nCurrentFocus, true);
						policyByEndorsementTypeTableGrid.keys.releaseKeys();
					}
			},
			columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id: 'endtCd',
						title: 'Endorsement Code',
						width: '160px',
						visible: true
					},
					{	id: 'endtTitle',
						title: 'Endorsement Title',
						width: '464px',
						visible: true
					},
			],
			rows:objPolicyByEndorsementType.objPolicyByEndorsementTypeList
		};
		policyByEndorsementTypeTableGrid = new MyTableGrid(policyByEndorsementTypeTableModel);
		policyByEndorsementTypeTableGrid.pager = objPolicyByEndorsementType.objPolicyByEndorsementTypeListTableGrid;
		policyByEndorsementTypeTableGrid.render('policyByEndorsementTypeListing');
	}catch(e){
		showErrorMessage(e.message);
	}
	
	function queryEndtTypeList(endtCd){
		try{
			endtTypeListTableGrid.url = contextPath+"/GIPIPolbasicController?action=getEndtTypeList&refresh=1&endtCd="+endtCd;
			endtTypeListTableGrid._refreshList();
		}catch(e){
			showErrorMessage("queryEndtTypeList", e);
		}
	}
	
	try{ // policy list per endorsement code
		var objEndtType = new Object();
		objEndtType.objEndtTypeListTableGrid = [];//JSON.parse('${jsonEndtTypeList}');
		objEndtType.objEndtTypeList = objEndtType.objEndtTypeListTableGrid.rows || [];
		
		var endtTypeListTableModel = {
			url:contextPath+"/GIPIPolbasicController?action=getEndtTypeList&refresh=1",
			options:{
					title: '',
					width:'651px',
					onCellFocus: function(element, value, x, y, id){
						endtTypeListTableGrid.keys.removeFocus(endtTypeListTableGrid.keys._nCurrentFocus, true);
						endtTypeListTableGrid.keys.releaseKeys();
						
						enableButton("btnPolEndtDetails");
						$("hidEndtTypePolId").value = endtTypeListTableGrid.geniisysRows[y].policyId;
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						endtTypeListTableGrid.keys.removeFocus(endtTypeListTableGrid.keys._nCurrentFocus, true);
						endtTypeListTableGrid.keys.releaseKeys();
						
						disableButton("btnPolEndtDetails");
						$("hidEndtTypePolId").value = "";
					},
					onRowDoubleClick: function(y){
						$("viewPolInfoMainDiv").show();
						getPolicyEndtSeq0(endtTypeListTableGrid.geniisysRows[y].policyId);
						objGIPIS100.endtType = "Y";
					}
			},
			columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id: 'policyNo',
						title: 'Policy No.',
						width: '170px',
						visible: true
					},
					{	id: 'endtNo',
						title: 'Endorsement No.',
						width: '130px',
						visible: true
					},
					{	id: 'tsiAmt',
						title: 'TSI Amount',
						titleAlign: 'right',
						align: 'right',
						width: '160px',
						visible: true,
						geniisysClass: 'money'
					},
					{	id: 'premAmt',
						title: 'Premium Amount',
						titleAlign: 'right',
						align: 'right',
						width: '160px',
						visible: true,
						geniisysClass: 'money'
					},
			],
			rows: objEndtType.objEndtTypeList
		};
		endtTypeListTableGrid = new MyTableGrid(endtTypeListTableModel);
		endtTypeListTableGrid.pager = objEndtType.objEndtTypeListTableGrid;
		endtTypeListTableGrid.render('endtTypeListTGDiv');
	}catch(e){
		showErrorMessage(e.message);
	}
	
	hideNotice();
	/* $("btnSummarizedInfo").observe("click", function () {		
		try{
			var row = policyByEndorsementTypeTableGrid.geniisysRows[policyByEndorsementTypeSelectedIndex];
			getPolicyEndtSeq0(row.policyId);
		}catch(e){}
	}); */
}catch(e){
	showErrorMessage("policyByEndorsementTypeTable.jsp", e);
}
</script>