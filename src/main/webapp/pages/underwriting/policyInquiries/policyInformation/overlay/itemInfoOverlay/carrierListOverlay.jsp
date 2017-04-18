<div id="carrierListOuterDiv" class="sectionDiv" style="border: none; overflow: none;">
	<div id="carrierListInnerDiv" class="sectionDiv" style="border: none; overflow: none;">
		<div id="carrierListDiv1" class="sectionDiv" style="border: none; height: 250px; width: 650px; overflow: none;">
		 	
	 		<div id="carrierListDiv" name="policyDiscountSurchargeDetails" style="border: none; overflow: none; padding: 10px;">	 
				<div id="carrierList" class="sectionDiv" style="border: none; height: 200px; margin-bottom: 15px; overflow: none;"></div> 
				<div id="returnDiv" class="sectionDiv" style="text-align:center; border: none; padding: 20px; overflow: none;">
					<input type="button" class="button" id="btnCarrierReturn" value="Return" style="width:23%"/>
				</div>				
			</div>
		</div>
	</div>
</div>
<script>
	var moduleId = $F("hidModuleId");
	var gipis100path = "/GIPIVehicleController?action=getListOfCarriers&refresh=1";
	var gipis101path = "/GIXXVehicleController?action=getGIXXCargoCarrierTG&refresh=1";

	try{		
		var carrierList = new Object();
		carrierList.carrierListTableGrid = JSON.parse('${carrierList}'.replace(/\\/g,'\\\\'));
		carrierList.carrierList = carrierList.carrierListTableGrid || [];
	
		var carrierListTableModel = {
				url: contextPath + ( moduleId == "GIPIS101" ? gipis101path : gipis100path ),
			    options: {
			    	width: '650px',
			    	onCellFocus: function(element,value,x,y,id){
			    		
			    	}
			    },
			    columnModel: [
								{   id: 'recordStatus',							    
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},	
								{	id: 'vesselCd',
									title: 'Vessel Code',
									titleAlign: 'center',
									width: '230px'									
								},
								{	id: 'vesselName',
									title: 'Vessel Name',
									titleAlign: 'center',
									width: '410px'									
								}
			                  ],
			              rows: carrierList.carrierListTableGrid.rows
		};
		
		carrierListTableGrid = new MyTableGrid(carrierListTableModel);
		carrierListTableGrid.pager = carrierList.carrierListTableGrid;
		carrierListTableGrid.render('carrierList');
		
	}catch(e){
		showErrorMessage("carrierListOverlay.jsp",e);
	}
	
	$("btnCarrierReturn").observe("click",function(){
		overlayListOfCarriers.close();
	});
</script>
	
	