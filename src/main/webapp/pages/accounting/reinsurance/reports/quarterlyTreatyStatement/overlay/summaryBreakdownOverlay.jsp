<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div>
	<div class="sectionDiv" style="width: 680px; margin: 10px 10px 10px 10px;" >
		<div id="tableGridDiv" name="tableGridDiv" style=" width: 660px; height:310px; margin: 10px 10px 10px 10px;"></div>
		
		<div id="totalDiv" name="totalDiv" style="width: 660px; margin: 10px 10px 10px 10px;">
			<table style="margin: 30px 10px 10px 400px;">
				<tr>
					<td class="rightAligned">Total</td>
					<td><input type="text" id="txtTGTotal" name="txtTGTotal" style="margin-left: 5px; width: 200px; text-align: right;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="buttonsDiv" style="width: 660px; margin: 10px 10px 10px 10px;" >
		<input type="button" class="button" id="txtTGReturn" name="txtTGReturn" value="Return" style="width: 90px;" />
	</div>
</div>

<script type="text/javascript">
	var action = ('${action}');
	var objList = JSON.parse('${objList}'); 

	if(action == "getPerilBreakdownList"){
		try {
			var selectedPerilBreakdownRow = null;
			var perilBreakdownTableGrid = objList;
			var perilBreakdownRows = perilBreakdownTableGrid.rows || [];
			
			perilBreakdownTableModel = {
					url: contextPath + "/GIACReinsuranceReportsController?action=getPerilBreakdownList&refresh=1"
									 + "&lineCd="	+ (objGtqs != null ? nvl(objGtqs.lineCd, "") : "")
									 + "&shareCd="	+ (objGtqs != null ? nvl(objGtqs.shareCd, "") : "")
									 + "&treatyYy="	+ (objGtqs != null ? nvl(objGtqs.treatyYy, "") : "")
									 + "&year="		+ (objGtqs != null ? nvl(objGtqs.year, "") : "")
									 + "&qtr="		+ (objGtqs != null ? nvl(objGtqs.qtr, "") : ""),
					id: 3,
					options: {
						id: 3,
				     	height: '310px',
				     	width: '660px',
				     	hideColumnChildTitle: true,
				     	onCellFocus: function(element, value, x, y, id){
				     		selectedPerilBreakdownRow = perilBreakdownTG.geniisysRows[y];
				     		perilBreakdownTG.keys.removeFocus(perilBreakdownTG.keys._nCurrentFocus, true);
				     		perilBreakdownTG.keys.releaseKeys();
				       },
				       onRemoveRowFocus: function(){
				    		selectedPerilBreakdownRow = null;perilBreakdownTG.keys.removeFocus(perilBreakdownTG.keys._nCurrentFocus, true);
				     		perilBreakdownTG.keys.releaseKeys();
				       },				       
				       toolbar: {
				       		elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
								{	id: 'perilCd',
									title: 'Peril Code',
									width: '100px',
									align: 'right',
									titleAlign: 'right',
									sortable: true,
									filterOption: true,
									filterOptionType: 'number'
								},
								{	id: 'perilName',
									title: 'Peril Name',
									width: '340px',
									filterOption: true
								},
								{	id: 'premiumAmt',
									title: 'Premium Ceded Amount',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								}
								],
					rows: perilBreakdownRows
				};
				perilBreakdownTG = new MyTableGrid(perilBreakdownTableModel);
				perilBreakdownTG.pager = perilBreakdownTableGrid;
				perilBreakdownTG.render('tableGridDiv');
				perilBreakdownTG.afterRender = function(){
					perilBreakdownRows = perilBreakdownTG.geniisysRows;
					
					var tempTotal = parseFloat("0");
					for(var i=0; i<perilBreakdownRows.length; i++){
						if(i == 0){
							tempTotal = perilBreakdownRows[i].totalPremiumAmt;
						}
					}
					$("txtTGTotal").value = formatCurrency(tempTotal);
			}; 
		} catch(e){
			showErrorMessage("PerilBreakdownTableGrid: ",e);
		}
		
	} else if(action == "getCommissionBreakdownList"){
		try {
			var selectedCommissionBreakdownRow = null;
			var commissionBreakdownTableGrid = objList;
			var commissionBreakdownRows = commissionBreakdownTableGrid.rows || [];
			
			commissionBreakdownTableModel = {
					url: contextPath + "/GIACReinsuranceReportsController?action=getCommissionBreakdownList&refresh=1"
									 + "&lineCd="	+ (objGtqs != null ? nvl(objGtqs.lineCd, "") : "")
									 + "&shareCd="	+ (objGtqs != null ? nvl(objGtqs.shareCd, "") : "")
									 + "&treatyYy="	+ (objGtqs != null ? nvl(objGtqs.treatyYy, "") : "")
									 + "&year="		+ (objGtqs != null ? nvl(objGtqs.year, "") : "")
									 + "&qtr="		+ (objGtqs != null ? nvl(objGtqs.qtr, "") : ""),
					id: 4,
					options: {
						id: 4,
				     	height: '310px',
				     	width: '660px',
				     	hideColumnChildTitle: true,
				     	onCellFocus: function(element, value, x, y, id){
				     		selectedCommissionBreakdownRow = commissionBreakdownTG.geniisysRows[y];
				     		commissionBreakdownTG.keys.removeFocus(commissionBreakdownTG.keys._nCurrentFocus, true);
				     		commissionBreakdownTG.keys.releaseKeys();
				       },
				       onRemoveRowFocus: function(){
				    	   selectedCommissionBreakdownRow = null;
				    		commissionBreakdownTG.keys.removeFocus(commissionBreakdownTG.keys._nCurrentFocus, true);
				    		commissionBreakdownTG.keys.releaseKeys();
				       },				       
				       toolbar: {
				       		elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
								{	id: 'treatyCommRt',
									title: 'Commission Rate',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									sortable: true,
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatToNineDecimal(value);
									}
								},
								{	id: 'premiumAmt',
									title: 'Premium Ceded',
									width: '220px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								},
								{	id: 'commissionAmt',
									title: 'Commission',
									width: '220px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								}
								],
					rows: commissionBreakdownRows
				};
				commissionBreakdownTG = new MyTableGrid(commissionBreakdownTableModel);
				commissionBreakdownTG.pager = commissionBreakdownTableGrid;
				commissionBreakdownTG.render('tableGridDiv');
				commissionBreakdownTG.afterRender = function(){
					commissionBreakdownRows = commissionBreakdownTG.geniisysRows;
					
					var tempTotal = parseFloat("0");
					for(var i=0; i<commissionBreakdownRows.length; i++){
						if(i == 0){
							tempTotal = commissionBreakdownRows[i].totalCommissionAmt;
						}
					}
					$("txtTGTotal").value = formatCurrency(tempTotal);
			}; 
		} catch(e){
			showErrorMessage("CommissionBreakdownTableGrid: ",e);
		}
		
	} else if(action == "getClmLossPaidBreakdownList"){
		try {
			var selectedClmLossPdBreakdownRow = null;
			var clmLossPdBreakdownTableGrid = objList;
			var clmLossPdBreakdownRows = clmLossPdBreakdownTableGrid.rows || [];
			
			clmLossPdBreakdownTableModel = {
					url: contextPath + "/GIACReinsuranceReportsController?action=getClmLossPaidBreakdownList&refresh=1"
									 + "&lineCd="	+ (objGtqs != null ? nvl(objGtqs.lineCd, "") : "")
									 + "&shareCd="	+ (objGtqs != null ? nvl(objGtqs.shareCd, "") : "")
									 + "&treatyYy="	+ (objGtqs != null ? nvl(objGtqs.treatyYy, "") : "")
									 + "&year="		+ (objGtqs != null ? nvl(objGtqs.year, "") : "")
									 + "&qtr="		+ (objGtqs != null ? nvl(objGtqs.qtr, "") : ""),
					id: 5,
					options: {
						id: 5,
				     	height: '310px',
				     	width: '660px',
				     	hideColumnChildTitle: true,
				     	onCellFocus: function(element, value, x, y, id){
				     		selectedClmLossPdBreakdownRow = clmLossPdBreakdownTG.geniisysRows[y];
				     		clmLossPdBreakdownTG.keys.removeFocus(clmLossPdBreakdownTG.keys._nCurrentFocus, true);
				     		clmLossPdBreakdownTG.keys.releaseKeys();
				       },
				       onRemoveRowFocus: function(){
				    	   selectedClmLossPdBreakdownRow = null;
				    	   clmLossPdBreakdownTG.keys.removeFocus(clmLossPdBreakdownTG.keys._nCurrentFocus, true);
				    	   clmLossPdBreakdownTG.keys.releaseKeys();
				       },				       
				       toolbar: {
				       		elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
								{	id: 'perilCd',
									title: 'Peril Code',
									width: '100px',
									align: 'right',
									titleAlign: 'right',
									sortable: true,
									filterOption: true,
									filterOptionType: 'number'
								},
								{	id: 'perilName',
									title: 'Peril Name',
									width: '340px',
									filterOption: true
								},
								{	id: 'lossPaidAmt',
									title: 'Loss Paid Amount',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								}
								],
					rows: clmLossPdBreakdownRows
				};
				clmLossPdBreakdownTG = new MyTableGrid(clmLossPdBreakdownTableModel);
				clmLossPdBreakdownTG.pager = clmLossPdBreakdownTableGrid;
				clmLossPdBreakdownTG.render('tableGridDiv');
				clmLossPdBreakdownTG.afterRender = function(){
					clmLossPdBreakdownRows = clmLossPdBreakdownTG.geniisysRows;
					
					var tempTotal = parseFloat("0");
					for(var i=0; i<clmLossPdBreakdownRows.length; i++){
						if(i == 0){
							tempTotal = clmLossPdBreakdownRows[i].totalLossPaidAmt;
						}
					}
					$("txtTGTotal").value = formatCurrency(tempTotal);
			}; 
		} catch(e){
			showErrorMessage("ClaimLossPaidBreakdownTableGrid: ",e);
		}
		
	} else if(action == "getClmLossExpBreakdownList"){
		try {
			var selectedClmLossExpBreakdownRow = null;
			var clmLossExpBreakdownTableGrid = objList;
			var clmLossExpBreakdownRows = clmLossExpBreakdownTableGrid.rows || [];
			
			clmLossExpBreakdownTableModel = {
					url: contextPath + "/GIACReinsuranceReportsController?action=getClmLossExpBreakdownList&refresh=1"
									 + "&lineCd="	+ (objGtqs != null ? nvl(objGtqs.lineCd, "") : "")
									 + "&shareCd="	+ (objGtqs != null ? nvl(objGtqs.shareCd, "") : "")
									 + "&treatyYy="	+ (objGtqs != null ? nvl(objGtqs.treatyYy, "") : "")
									 + "&year="		+ (objGtqs != null ? nvl(objGtqs.year, "") : "")
									 + "&qtr="		+ (objGtqs != null ? nvl(objGtqs.qtr, "") : ""),
					id: 6,
					options: {
						id: 6,
				     	height: '310px',
				     	width: '660px',
				     	hideColumnChildTitle: true,
				     	onCellFocus: function(element, value, x, y, id){
				     		selectedClmLossExpBreakdownRow = clmLossExpBreakdownTG.geniisysRows[y];
				     		clmLossExpBreakdownTG.keys.removeFocus(clmLossExpBreakdownTG.keys._nCurrentFocus, true);
				     		clmLossExpBreakdownTG.keys.releaseKeys();
				       },
				       onRemoveRowFocus: function(){
				    	   selectedClmLossExpBreakdownRow = null;
				    	   clmLossExpBreakdownTG.keys.removeFocus(clmLossExpBreakdownTG.keys._nCurrentFocus, true);
				    	   clmLossExpBreakdownTG.keys.releaseKeys();
				       },				       
				       toolbar: {
				       		elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
								{	id: 'perilCd',
									title: 'Peril Code',
									width: '100px',
									align: 'right',
									titleAlign: 'right',
									sortable: true,
									filterOption: true,
									filterOptionType: 'number'
								},
								{	id: 'perilName',
									title: 'Peril Name',
									width: '340px',
									filterOption: true
								},
								{	id: 'lossExpAmt',
									title: 'Loss Expense Amount',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								}
								],
					rows: clmLossExpBreakdownRows
				};
				clmLossExpBreakdownTG = new MyTableGrid(clmLossExpBreakdownTableModel);
				clmLossExpBreakdownTG.pager = clmLossExpBreakdownTableGrid;
				clmLossExpBreakdownTG.render('tableGridDiv');
				clmLossExpBreakdownTG.afterRender = function(){
					clmLossExpBreakdownRows = clmLossExpBreakdownTG.geniisysRows;
					
					var tempTotal = parseFloat("0");
					for(var i=0; i<clmLossExpBreakdownRows.length; i++){
						if(i == 0){
							tempTotal = clmLossExpBreakdownRows[i].totalLossExpAmt;
						}
					}
					$("txtTGTotal").value = formatCurrency(tempTotal);
			}; 
		} catch(e){
			showErrorMessage("ClaimLossExpenseBreakdownTableGrid: ",e);
		}
	}

	$("txtTGReturn").observe("click", function(){
		if(action == "getPerilBreakdownList"){
			perilBreakdownOverlay.close();
		} else if(action == "getCommissionBreakdownList"){
			commissionBreakdownOverlay.close();
		} else if(action == "getClmLossPaidBreakdownList"){
			clmLossPaidBreakdownOverlay.close();
		} else if(action == "getClmLossExpBreakdownList"){
			clmLossExpBreakdownOverlay.close();
		}
	});
</script>