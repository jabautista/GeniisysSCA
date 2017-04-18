<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="mcPoliciesParListingMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="mcPolParListingExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Listing of Motorcar Policies/PARs</label>
		</div>
	</div>

	<div id="parListDiv" class="sectionDiv" style="width: 920px; height: 370px;">		
		<div id="parListingTGDiv" style="width: 894px; height: 306px; margin: 15px 10px 10px 10px;"></div>	 	
	</div>
	
	<jsp:include page="/pages/underwriting/policyInquiries/motorCarInquiries/motorcarPoliciesParListing/subpages/motorcarDetails.jsp"></jsp:include>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIPIS211");
	setDocumentTitle("Motor Car Issuance");
	
	var selectedParRow = null;
	var selectedParY = null;		
	
	var objPar = new Object();
	objPar.tableGrid = JSON.parse('${policiesParListing}'.replace(/\\/g, '\\\\'));
	objPar.objRows = objPar.tableGrid.rows || [];
	objPar.objList = [];	// holds all the geniisys rows
	
	var tempGlobalParId = objUWGlobal.parId == null ? "" : objUWGlobal.parId;
	var tempGlobalLineCd = objUWGlobal.lineCd == null ? "" : objUWGlobal.lineCd;
	
	try{
		var parTableModel = {
			url: contextPath + "/GIPIPARListController?action=showGIPIS211&refresh=1&globalParId="+tempGlobalParId+
					"&globalLineCd="+tempGlobalLineCd,
			width: '898px',
			height: '305px',
			options: {
				onCellFocus: function(element, value, x, y, id){
					selectedParRow = parTG.geniisysRows[y];
					selectedParY = y;					
				},
				onRowDoubleClick: function(y){
					parTG.keys.releaseKeys();
					selectedParRow = parTG.geniisysRows[y];
					selectedParY = y;
					populateVehicleTable(true);
					toggleDivs(false);
				},
				onRemoveRowFocus: function(){
					parTG.keys.releaseKeys();
					selectedParRow = null;
					selectedParY = null;
					populateVehicleTable();
				},
				onSort: function(){
					parTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					parTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						parTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{
					id: 'parId',
					width: '0px',
					visible: false
				},
				{
					id: 'lineCd',
					title: 'Line Cd',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'issCd',
					title: 'Issue Cd',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'parYy',
					title: 'PAR Year',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'parSeqNo',
					title: 'PAR Seq No',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'quoteSeqNo',
					title: 'Quote Seq No',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'parStatus',
					width: '0px',
					visible: false
				},
				{
					id: 'assdNo',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtParNo',
					width: '0px',
					visible: false
				},
				{
					id: 'parNumber',
					title: 'PAR Number',
					width: '170px', 
					visible: true,
					sortable: true
				},
				{
					id: 'assdName',
					title: 'Assured',
					width: '380px',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'underwriter',
					title: 'Underwriter',
					width: '110px',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'inceptDate',
					title: 'Incept Date',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return formatDateToDefaultMask(value);
					}
				},
				{
					id: 'expiryDate',
					title: 'Expiry Date',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return formatDateToDefaultMask(value);
					}
				}     
			],
			rows: objPar.objRows
		};
		
		parTG = new MyTableGrid(parTableModel);
		parTG.pager = objPar.tableGrid;
		parTG.render('parListingTGDiv');
		
	}catch(e){
		showErrorMessage("Par Listing table grid error", e);
	}
	
	
	function populateVehicleTable(populate){
		try{
			if(populate){
				$("txtParNo").value = unescapeHTML2(selectedParRow.nbtParNo);
				$("txtAssdName").value = unescapeHTML2(selectedParRow.assdName);
				vehicleTG.url = contextPath + "/GIPIPARListController?action=getParVehiclesGIPIS211&refresh=1&parId="+selectedParRow.parId+
								"&parStatus="+selectedParRow.parStatus;
				vehicleTG._refreshList();
			}else{
				$("txtParNo").clear();
				$("txtAssdName").clear();
				vehicleTG.url = contextPath + "/GIPIPARListController?action=getParVehiclesGIPIS211&refresh=1";
				vehicleTG._refreshList();
			}
		}catch(e){
			showErrorMessage("populateVehicleTable", e);	
		}
	}
	
	function toggleDivs(showMain){
		if (showMain){
			$("vehicleDetailsMainDiv").hide();
			$("parListDiv").show();
		}else{
			$("vehicleDetailsMainDiv").show();
			$("parListDiv").hide();
		}
	}
	
	
	$("btnReturn").observe("click", function(){
		populateVehicleTable(false);
		toggleDivs(true);
	});
	
	$("mcPolParListingExit").observe("click", function(){
		vehicleTG.onRemoveRowFocus();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	toggleDivs(true);
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>