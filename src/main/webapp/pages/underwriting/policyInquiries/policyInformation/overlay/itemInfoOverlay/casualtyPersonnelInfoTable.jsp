<div style="margin:10px auto 10px auto;">	
	<div style="height:160px;margin:5px auto 5px auto;width:538px;">
		<div id="casualtyPersonnelListing" style="height:156px;width:538px;float:left;"></div>
	</div>
	<div style="margin: 10px auto 5px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromCasualtyPersonnelInfo" name="btnReturnFromCasualtyPersonnels" value="Additional Information" style="width:200px;"/>
	</div>
</div>
<script>
	$("btnReturnFromCasualtyPersonnelInfo").observe("click", function(){
		overlayCasualtyPersonnelInfoTable.close();
	});
	
	//initialization
	var objCasualtyPersonnel = new Object();
	objCasualtyPersonnel.objCasualtyPersonnelListTableGrid = JSON.parse('${casualtyPersonnel}'.replace(/\\/g, '\\\\'));																							   
	objCasualtyPersonnel.objCasualtyPersonnelList = objCasualtyPersonnel.objCasualtyPersonnelListTableGrid.rows || [];
	
	//added by Kris 03.05.2013 for GIPIS101
	var moduleId = $F("hidModuleId");
	var gipis100path = "/?action=getCasualtyPersonnel"+
						"&policyId="+$("hidItemPolicyId").value+
						"&itemNo="+$("hidItemNo").value;
	var gipis101path = "/GIXXCasualtyPersonnelController?action=getGIXXCasualtyPersonnelTG" + 
						"&extractId=" + $F("hidItemExtractId") + 
						"itemNo=" + $F("hidItemNo");
	if(moduleId == "GIPIS101"){
		$("btnReturnFromCasualtyPersonnelInfo").value = "Return";
		$("btnReturnFromCasualtyPersonnelInfo").setStyle('width : 100px');
	}
	
	
	try{
		var casualtyPersonnelTableModel = {
			url:contextPath+ ( moduleId == "GIPIS101" ? gipis101path : gipis100path )
				,
			options:{
					title: 'Personnel Information',
					width: '538px',
					onCellFocus: function(element, value, x, y, id){
						casualtyPersonnelTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						casualtyPersonnelTableGrid.releaseKeys();
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
					{
						id: 'policyId',
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{
						id: 'itemNo',
						title: 'itemNo',
						width: '0px',
						align: 'right',
						visible: false
					},
					{
						id: 'personnelNo',
						title: 'No.',
						titleAlign: 'center',
						width: '50%',
						align: 'right',
						visible: true
					},
					{
						id: 'name',
						title: 'Name',
						titleAlign: 'center',
						width: '250%',
						visible: true
					},
					{
						id: 'capacityCd',
						title: 'Cap. Code',
						titleAlign: 'center',
						width: '70%',
						align: 'right',
						visible: true
					},
					{
						id: 'amountCovered',
						title: 'Amount Covered',
						titleAlign: 'center',
						width: '150%',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
			],
			rows:objCasualtyPersonnel.objCasualtyPersonnelList
		};
	
		casualtyPersonnelTableGrid = new MyTableGrid(casualtyPersonnelTableModel);
		casualtyPersonnelTableGrid.render('casualtyPersonnelListing');
	}catch(e){
		showErrorMessage("Casualty Personnel", e);
	}
</script>