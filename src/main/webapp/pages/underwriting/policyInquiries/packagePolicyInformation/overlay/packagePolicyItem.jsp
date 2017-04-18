<div id="packagePolicyItemDiv" style="padding: 5px; height: 210px;">
	<div id="packagePolicyItemTable" style="height: 100%;"></div>
</div>
<div style="width: 100%;" align="center">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px;"/>
</div>
<script type="text/javascript">
	initializeAll();
	var objItem = new Object();
	objItem.objPackagePolItemTable = JSON.parse('${json}');
	showPackPolItemTable();
	
	$("btnReturn").observe("click", function(){
		overlayPackagePolItem.close();
		delete overlayPackagePolItem;
	});
	
	function showPackPolItemTable(){
		try {
			packagePolicyItemTable = {
				url : contextPath+ "/GIPIPolbasicController?action=showPackagePolicyItem&refresh=1&packPolId="+'${packPolId}',
				id: "packagePolicyItemTable",
				options : {
					height : '200px',
					width : '815px',
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						tbgPackagePolicyItemTable.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tbgPackagePolicyItemTable.keys.releaseKeys();
					},
					onSort : function(){
						tbgPackagePolicyItemTable.keys.releaseKeys();
					},
					postPager : function() {
						tbgPackagePolicyItemTable.keys.releaseKeys();
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "policyNo",
						title: "Policy No",
						width: '240px',
						filterOption : true,
						align : "left",
						titleAlign : "left"
					},
					{
						id : "itemNo",
						title: "Item No",
						width: '80px',
						filterOption : true,
						align : "right",
						titleAlign : "right"
					},
					{
						id : "itemTitle",
						title: "Item Title",
						width: '370px',
						filterOption : true,
						align : "left",
						titleAlign : "left"
					},
					{   // added by jdiago 07.04.2014
						id : "lineCd",
						title: "Line",
						width: '50px',
						filterOption : true,
					},
					{   // added by jdiago 07.04.2014
						id : "sublineCd",
						title: "Subline",
						width: '50px',
						filterOption : true,
					}
				],
				rows : objItem.objPackagePolItemTable.rows
			};
				tbgPackagePolicyItemTable = new MyTableGrid(packagePolicyItemTable);
				tbgPackagePolicyItemTable.pager = objItem.objPackagePolItemTable;
				tbgPackagePolicyItemTable.render('packagePolicyItemTable');
			} catch (e) {
				showErrorMessage("packagePolicyInformation.jsp", e);
			}
		}
</script>