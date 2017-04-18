<div id="motorCarsTableGridSectionDiv" style="height:329px;width:900px;">
		<div id="motorCarsTableGridDiv" style="height:329px;">
			<div id="motorCarsListing" style="height:306px;width:776px;"></div>
		</div>
</div>

<script type="text/javascript" src="underwriting.js">
	var rowIndex;
	var objMotorCars = new Object();
	/* objMotorCars.objMotorCarsListTableGrid = JSON.parse('${motorCarsTableGrid}'.replace(/\\/g, '\\\\'));
	objMotorCars.objMotorCarsList = objMotorCars.objMotorCarsListTableGrid.rows || []; */
	
	//var jsonMotorCar = JSON.parse('${jsonMotorCar}');

	objGIPIS100.motorcars = {};
	
	try{
		var motorCarsTableModel = {
			url: contextPath+"/GIPIVehicleController?action=getMotorCarsTable&refresh=1&itemNo=-1",
			options:{
					hideColumnChildTitle: true,
					width:'900px',
					onCellFocus: function(element, value, x, y, id){
						rowIndex = y;					
						motorCarsTableGrid.keys.removeFocus(motorCarsTableGrid.keys._nCurrentFocus, true);
						motorCarsTableGrid.keys.releaseKeys();
						setMCButtons(motorCarsTableGrid.geniisysRows[y]);
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						rowIndex = -1;
						motorCarsTableGrid.keys.removeFocus(motorCarsTableGrid.keys._nCurrentFocus, true);
						motorCarsTableGrid.keys.releaseKeys();
						setMCButtons(null);
					},
					onRowDoubleClick: function(param){
						var row = motorCarsTableGrid.geniisysRows[param];
						getPolicyEndtSeq0(row.policyId);
					},
					toolbar : {
						elements: [MyTableGrid.REFRESH_BTN]
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
					{	id: 'rowNum',
						title: 'rowNum',
						width: '0px',
						visible: false
					},
					{	id: 'rowCount',
						title: 'rowCount',
						width: '0px',
						visible: false
					},
					{	id: 'policyId',
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{	id: 'itemNo',
						title: 'Item',
						align: 'right',
						width: '40%',
						visible: true
					},
					{	id: 'motorNo',
						title: 'Motor No.',
						width: '100%',
						filterOption : true,
						visible: true
					},
					{	id: 'plateNo',
						title: 'Plate No.',
						width: '80%',
						filterOption : true,
						visible: true
					},
					{	id: 'serialNo',
						title: 'Serial No.',
						width: '120px',
						filterOption : true,
						visible: true
					},
					{	id: 'modelYear',
						title: 'Model Year',
						width: '70%',
						align: 'right',
						filterOption : true,
						visible: true
					},
					{
						id : "cocType cocSerialNo cocYy",
						title: "COC No.",
						width: '165px',
						children : [
						            {
										id : "cocType",
										width: 40
						            },
						            {
										id : "cocSerialNo",
										width: 85,
										align: 'right',
										renderer: function(value){
											return formatNumberDigits(value, 7);
										} 
						            },
						            {
										id : "cocYy",
										width: 25,
										align: 'right',
										renderer: function(value){
											return formatNumberDigits(value, 2);
										}
						            }
						            ]
					},
					{	id: 'policyNo',
						title: 'Policy No.',
						width: '180px',
						filterOption : true,
						visible: true
					},
					{
						id : "polFlag status",
						title: "Status",
						width: '120px',
						children : [
						            {
										id : "polFlag",
										width: 25
						            },
						            {
										id : "status",
										width: 80
						            }						            
						            ]
					}					
			],
			rows: [] //jsonMotorCar.rows
		};
		motorCarsTableGrid = new MyTableGrid(motorCarsTableModel);
		motorCarsTableGrid.pager = {}; //jsonMotorCar;
		motorCarsTableGrid.render('motorCarsListing');
		motorCarsTableGrid.afterRender = function(){
			disableButton("btnSummarizedInfo");
			disableButton("btnAdditionalInfo");
			disableButton("btnViewAttachment");
			motorCarsTableGrid.keys.removeFocus(motorCarsTableGrid.keys._nCurrentFocus, true);
			motorCarsTableGrid.keys.releaseKeys();
			setMCButtons(null);
			
			if(motorCarsTableGrid.geniisysRows.length == 0){
				if(objGIPIS100.motorcars.querySw == "Y"){
					$("mtgPagerMsg"+motorCarsTableGrid._mtgId).innerHTML = "<strong>No records found. Use Query button to view record/s.</strong>";
				} else {
					$("mtgPagerMsg"+motorCarsTableGrid._mtgId).innerHTML = "<strong>Use Query button to view record/s.</strong>";
				}
			}		
		};
		
	}catch(e){
		showErrorMessage("motorCarsTableModel", e);
	}
	
	function setMCButtons(obj){
		if(obj == null){
			disableButton("btnSummarizedInfo");
			disableButton("btnAdditionalInfo");
			disableButton("btnViewAttachment");
		} else {
			enableButton("btnSummarizedInfo");
			
			if(checkUserModule("GIPIS116"))
				enableButton("btnAdditionalInfo");
			else
				disableButton("btnAdditionalInfo");
			
			
			if(obj.hasAttachment == "Y")
				enableButton("btnViewAttachment");
			else
				disableButton("btnViewAttachment");
		}
	}

	$("btnSummarizedInfo").observe("click", function () {		
		try{
			var row = motorCarsTableGrid.geniisysRows[rowIndex];
			getPolicyEndtSeq0(row.policyId);
		}catch(e){}
	});
	
	function showAttachments(){
		try{
			overlayAttachmentList = Overlay.show(contextPath+"/GIPIPictureController", {
				urlContent: true,
				urlParameters: {action : "showAttachmentList",
					    		policyId : motorCarsTableGrid.geniisysRows[rowIndex].policyId,
					    		itemNo : motorCarsTableGrid.geniisysRows[rowIndex].itemNo,
								ajax : "1"},
			    title: "Attachments",
			    height: 380,
			    width: 650,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showAttachments", e);
		}
	}
	
	function showAdditionalMCInfo(){
		objUWGlobal.callingForm = "GIPIS100";
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
		    parameters : {
		    	action : "getMotorCarInquiryRecords",
		    	policyId : motorCarsTableGrid.geniisysRows[rowIndex].policyId,
	    		itemNo : motorCarsTableGrid.geniisysRows[rowIndex].itemNo
		    },
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showAdditionalMCInfo - onComplete : ", e);
				}								
			} 
		});
	}
	
	$("btnViewAttachment").observe("click", showAttachments);
	$("btnAdditionalInfo").observe("click", showAdditionalMCInfo);
	
	function showQueryOverlay(){
		try{
			overlayQueryMotorcars = Overlay.show(contextPath+"/GIPIVehicleController",{
				urlContent: true,
				urlParameters: {action : "showQueryMotorcarsPage"},
			    title: "Query Motorcars",
			    height: 200,
			    width: 600,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showQueryOverlay", e);
		}		
	}
	
	$("btnQuery").observe("click", showQueryOverlay);
	showQueryOverlay();
</script>