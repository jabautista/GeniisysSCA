<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryDetailsDiv" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 139px;">
		<div id="recoveryTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 129px;">
		<div id="payorDetailsTable" style="height: 105px; margin-left: auto;"></div>
	</div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 129px;">
		<div id="historyTable" style="height: 105px; margin-left: auto;"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
</div>
<script type="text/javascript">
	try{
		var recoveryId = "";
		
		function showPayorDetails (rec) {
			if(rec == null)
				payorDetailsTableGrid.url = contextPath+"/GICLClaimListingInquiryController?action=getPayorDetails&refresh=1";
			else 
				payorDetailsTableGrid.url = contextPath+"/GICLClaimListingInquiryController?action=getPayorDetails&refresh=1&claimId="+objRecovery.claimId+"&recoveryId="+rec.recoveryId;
			payorDetailsTableGrid._refreshList();
			
		}
		
		function showHistory (rec) {
			if(rec == null)
				historyTableGrid.url = contextPath+"/GICLClaimListingInquiryController?action=showHistory&refresh=1";
			else
				historyTableGrid.url = contextPath+"/GICLClaimListingInquiryController?action=showHistory&refresh=1&recoveryId="+rec.recoveryId;
			historyTableGrid._refreshList();
		}

		//payor details tableGrid
		var objPayorDetails = new Object();
		objPayorDetails.objPayorDetailsTableGrid = {};
		var payorDetailsTableModel = {
					id : "payorDetails",
					options: {
						width: '796px',
						//marco - 08.27.2013 - released keys
						onCellFocus : function(element, value, x, y, id) {
							payorDetailsTableGrid.keys.removeFocus(payorDetailsTableGrid.keys._nCurrentFocus, true);
							payorDetailsTableGrid.keys.releaseKeys();
							
						},
						onRemoveRowFocus : function(element, value, x, y, id){
							payorDetailsTableGrid.keys.removeFocus(payorDetailsTableGrid.keys._nCurrentFocus, true);
							payorDetailsTableGrid.keys.releaseKeys();
						}
					},
					columnModel:[
								{   id: 'recordStatus',
								    width: '0px',
								    visible: false,
								    editor: 'checkbox'
								},
								{	id: 'divCtrId',
									width: '0px',
									visible: false
								},
								{	id: 'payorClass',
									title: 'Payor Class',
									width: '273px'
								},
								{
									id: 'payor',
									title: 'Payor',
									width: '290px'
								},
								{
									id: 'recoveredAmt',
									title: 'Recovered Amount',
									width: '204px',
									align : "right",
									titleAlign : "right",
									filterOption : true,
									renderer : function(value){
										return formatCurrency(value);
									}
								}
		  					],  				
		  				rows: []
				};
				payorDetailsTableGrid = new MyTableGrid(payorDetailsTableModel);
				payorDetailsTableGrid.pager = objPayorDetails.objPayorDetailsTableGrid;
				payorDetailsTableGrid.render('payorDetailsTable'); 
				
		//history details
		var objHistory = new Object();
		objHistory.objHistoryTableGrid = {};
		var historyTableModel = {
				id : "history",
				options: {
					hideColumnChildTitle: true,
					width: '796px',
					//marco - 08.27.2013 - released keys
		          	onCellFocus: function(element, value, x, y, id){
		          		historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
		          		historyTableGrid.keys.releaseKeys();
	                },
	                onRemoveRowFocus: function(){
	                	historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
	                	historyTableGrid.keys.releaseKeys();
	                },
	                beforeSort: function(){
	                },
	                onSort: function(){
	                }
				},
				columnModel:[
							{   id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox'
							},
							{	id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	id: 'recHistNo',
								title: 'Hist No.',
								width: '61px'
							} ,
							{
								id: 'recStatCd recStatDesc',
								title: 'Status',
								children:
								[
									{
										id: 'recStatCd',
										title: 'Stat Cd',
										width: 50
									},
									{
										id: 'recStatDesc',
										title: 'Stat Desc',
										width: 150
									}
								]
								
							},
							{
								id: 'remarks',
								title: 'Remarks',
								width: '200px'								
							},
							{
								id: 'userId',
								title: 'User Id',
								width: '100px'
							},
							{
								id: 'lastUpdate',
								title: 'Last Update',
								width: '200px'/* ,
								renderer : function(value){
									return dateFormat(value, "mm-dd-yyyy HH:MM:ss TT");
								} */
							}
	  					],  				
						rows: []
				};
		historyTableGrid = new MyTableGrid(historyTableModel);
		historyTableGrid.pager = objHistory.objHistoryTableGrid;
		historyTableGrid.render('historyTable');
		
		//recovery details
		var jsonRecoveryDetails = JSON.parse('${jsonRecoveryDetails}');	
		recoveryTableModel = {
			id  : "recoveryDetails",	
			url : contextPath+"/GICLClaimListingInquiryController?action=showRecoveryDetails&refresh=1&claimId=" + objRecovery.claimId,
			options: {
				width: '796px',
				onCellFocus : function(element, value, x, y, id) {
					showPayorDetails(tbgRecovery.geniisysRows[y]);
					showHistory(tbgRecovery.geniisysRows[y]);
					tbgRecovery.keys.removeFocus(tbgRecovery.keys._nCurrentFocus, true);
					tbgRecovery.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgRecovery.keys.removeFocus(tbgRecovery.keys._nCurrentFocus, true);
					tbgRecovery.keys.releaseKeys();
					showPayorDetails(null);
					showHistory(null);
				}
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id: 'recoveryId',
					width: '0',
					visible: false
				},
				{
					id : "recoveryNo",
					title: "Recovery No.",
					width: '100px',
					filterOption : true
				},
				{
					id : "recoverableAmt",
					title: "Recoverable Amt.",
					width: '120px',
					filterOption: true,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					renderer : function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "recoveredAmt",
					title: "Recovered Amt.",
					width: '120px',
					filterOption: true,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					renderer : function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "lawyer",
					title: "Lawyer",
					width: '155px',
					filterOption: true
				},
				{
					id : "plateNo",
					title: "Plate No.",
					width: '80px',
					filterOption: true
				},
				{
					id : "status",
					title : "Status",
					width : "100px",
					filterOption : true
					
				},
				{
					id : "tpItemDesc",
					title : "Third Party Item Description",
					width : '200px',
					filterOption : true
				}
			],
			rows: jsonRecoveryDetails.rows
		};
	
		tbgRecovery = new MyTableGrid(recoveryTableModel);
		tbgRecovery.pager = jsonRecoveryDetails;
		tbgRecovery.render('recoveryTable');
		tbgRecovery.afterRender = function() {
			if(tbgRecovery.geniisysRows.length > 0){
				tbgRecovery.selectRow('0');
				showPayorDetails(tbgRecovery.geniisysRows[0]);
				showHistory(tbgRecovery.geniisysRows[0]);
			}
		};
	
		$("btnReturn").observe("click", function(){
			overlayRecoveryDetails.close();
			delete overlayRecoveryDetails;
		});
	
	}catch(e){
		showMessageBox("Error in recoveryDetails.jsp " + e, imgMessage.ERROR);
	}
</script>