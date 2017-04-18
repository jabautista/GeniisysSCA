<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<!-- <div class="sectionDiv" id="settlementHistTableGrid" style="height: 208px; width: 600px;"></div>
<div class="sectionDiv" id="paramsDiv" style="width: 244px; height:70px; margin-left: 160px; margin-top: 20px;">
		<div class="sectionDiv" id="rdoBtndiv" name="rdoBtndiv" style="height: 70px; width: 120px; float:left;">
			<input type="radio" id="tagAll"       name="radBtn" style="margin-top: 9px;"/> Tag All <br/>
			<input type="radio" id="untaggedAll"  name="radBtn"/> Untagged All <br/>
			<input type="radio" id="selectedItem" name="radBtn"/> Selected Items <br/>
		</div>
		<div class=sectionDiv id="buttondiv" name="buttondiv" style="height: 70px; width: 120px; float:left;" align="center">
			<input type="button" class="button hover" style="width:100px; margin-top: 10px;" id="btnOk"     name="btnOk"     value="OK" /> <br/>
			<input type="button" class="button hover" style="width:100px; margin-top: 1px; " id="btnCancel" name="btnCancel" value="Cancel" />
		</div>
</div>	
<script type="text/javascript">
	try{
	    var settlementHistInfo = JSON.parse('${objSettlementHist}');	    
		var settlementHistTableModel = {
				options:{
					title: '',
					width: '600px',
					pager:{},
					hideColumnChildTitle: true,
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN]
					},
					onCellFocus : function(element, value, x, y, id) {
						if(x == settlementhistTableGrid.getColumnIndex('checkBox1')){
							
						 $("selectedItem").checked = true;
						}
					}
				},
				columnModel: [
					{   id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					{   id: 'checkBox1',
					    title: '',
					    width: '23px',
					    editor: 'checkbox', 	
					    editable: true
					},
					{ 	id: 'historySequenceNumber',
					  	align: 'center',
					  	title: '&nbspHist No',
					  	titleAlign: 'center',
					  	width: '50px',
					  	editable: false,
					  	sortable: true
					},
					{ 	id: 'payeeType payeeClassCode payeeCode payeeLastName',
						title : 'Payee',
						titleAlign : 'center',
						width : '160px',
						children : [
						    {	id : 'payeeType',
				                width : '25',
				                align: 'center',
				                editable: false	
						    },
				            {	id : 'payeeClassCode',
				                width : '25',
				                align: 'center',
				                editable: false		
				            },
				            {	id : 'payeeCode',
				                width : '100',
				                editable: false,
				                align: 'center'
				            },
				            {	id : 'payeeLastName',
				                width : '245',
				                editable: false,
				                align: 'left'
				            }
						]
					},
					{ 	id: 'paidAmount',
						align : 'center',
						title : 'Paid Amount',
						titleAlign : 'center',
						geniisysClass: 'money',
						width : '116px',
						editable: false,
					  	sortable: true
					}
				],
				rows : settlementHistInfo.rows
			};
			
			settlementhistTableGrid = new MyTableGrid(settlementHistTableModel);
			settlementhistTableGrid.pager = settlementHistInfo;
			settlementhistTableGrid.render('settlementHistTableGrid');
	}catch(e){
		showErrorMessage("settlementHistInfo", e);
	}
	
	function checkAllRows(){
		var rows = settlementhistTableGrid.geniisysRows;
		for(i=0; i<rows.length; i++){
			settlementhistTableGrid.setValueAt(true, settlementhistTableGrid.getColumnIndex('checkBox1'), rows[i].divCtrId);
		}
	}
	
	function unCheckAllRows(){
		var rows = settlementhistTableGrid.geniisysRows;
		for(i=0; i<rows.length; i++){
			settlementhistTableGrid.setValueAt(false, settlementhistTableGrid.getColumnIndex('checkBox1'), rows[i].divCtrId);
		}
	}
	
	function checkSelectedRow(){
		var rows = settlementhistTableGrid.getModifiedRows();
		for(i=0; i<rows.length; i++){
			if(rows[i].checkBox1 == true){
				settlementhistTableGrid.setValueAt(false, settlementhistTableGrid.getColumnIndex('checkBox1'), rows[i].divCtrId);	
			}
		}
	}
		
	$("btnCancel").observe("click", function(){
		overlaySettlementHist.close();
	});
	
	$("btnOk").observe("click", function(){
		var rows = settlementhistTableGrid.getModifiedRows();
		var count = 0;
		
		for (var i=0; i<rows.length; i++){
			if (rows[i].checkBox1 == true){
				count = count +1;
			}
		}	
		
		if (count > 0){
			settlementhistTableGrid.keys.releaseKeys();
			populatePrintDocs();
		}else {
			showMessageBox("Please select a settlement history before printing.", imgMessage.INFO);	 			
			return false;
		}
});
	
	$("tagAll").observe("click", checkAllRows);
	$("untaggedAll").observe("click", unCheckAllRows);
	$("selectedItem").observe("click", checkSelectedRow);
</script> belle 06.25.2012 hindi na gagamitin itong page -->