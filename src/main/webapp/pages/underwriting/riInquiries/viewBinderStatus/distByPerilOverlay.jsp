<div id="giris055DistByPerilMainDiv" style="width: 99.5%; margin-top: 5px; height: 340px; margin-bottom: 20px;" class="sectionDiv">
	<div>
		<div style="padding:10px;">
			<div id="distByPerilTable" style="height: 280px; width: 98%;" align="center">
				Table Grid Space
			</div>
		</div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" id="btnOkay" value="Ok" style="width: 100px;" tabindex="504">
</div>
<input id="fnlBinderId" type="hidden"  value="${fnlBinderId}"/>
<script type="text/javascript">
	initializeAll();
	
	var rowIndex = -1;
	var objBinderPerilDist = {};
	var objCurrBinderPerilDist = null;
	objBinderPerilDist.binderPerilDistList = JSON.parse('${jsonBinderDistPerilDtls}');

	var binderPerilDistTableModel = {
			url : contextPath + "/GIRIBinderController?action=showDistPerilOverLay&refresh=1" + "&fnlBinderId=" + $F("fnlBinderId"),
			options : {
				width : '775px',
				height : '320px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					
				},
				onRemoveRowFocus : function(){
					
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						
					}
				},
				beforeSort : function(){
					
				},
				onSort: function(){
					
				},
				onRefresh: function(){
					
				},
				prePager: function(){
					
				}
			},
			columnModel : [
				{ 								// this column will only be used for deletion
					id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					width: '0',				    
					visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'nbtPerilName',
					filterOption : true,
					title : 'Peril',
					width : '270px'
				},
				{
				   	id: 'riShrPct',
				   	title: 'RI % Share',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass: 'rate',
				  	deciRate: 9
				},
				{
					id : "riTsiAmt",
					title : "RI TSI Amount",
					titleAlign : 'right',
					width : '130px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "riPremAmt",
					title : "RI Prem. Amount",
					titleAlign : 'right',
					width : '130px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "riCommAmt",
					title : "RI Comm. Amount",
					titleAlign : 'right',
					width : '130px',
					geniisysClass: 'money',
					align : 'right',
				}
			],
			rows : objBinderPerilDist.binderPerilDistList.rows
	};
	tbgBinderPerilDist = new MyTableGrid(binderPerilDistTableModel);
	tbgBinderPerilDist.pager = objBinderPerilDist.binderPerilDistList;
	tbgBinderPerilDist.render("distByPerilTable");
	
	$("btnOkay").observe("click", function(){
		distPerilOverlay.close();
		delete distPerilOverlay;
	});
</script>