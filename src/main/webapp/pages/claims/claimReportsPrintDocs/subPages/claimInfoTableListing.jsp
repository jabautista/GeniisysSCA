<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="printDocsItemInfoTableGrid" style="height: 200px; width: 800px;"></div>
<script type="text/javascript">
	try{
		var objPrintDocsItemInfo = JSON.parse('${giclItemPeril2}');
		var claimItemInfoTableModel = {
			url: contextPath+"/GICLItemPerilController?action=getItemPerilGrid2&refresh=1&claimId="+objCLMGlobal.claimId+"&lineCd="+objCLMGlobal.lineCd,
			options:{
				title: '',
				width: '810px', 
				pager:{},
				onCellFocus : function(element, value, x, y, id) {
					row = printDocsItemInfoTableGrid.geniisysRows[y];
					objCLMItem.mcItemInfo = row;
						dspItemNo = parseInt(row.dspItemNo);
						dspPerilCd = row.dspPerilCd;
						histInfoTableGrid.url = contextPath+"/GICLClaimLossExpenseController?action=getClmHistInfo&claimId="+objCLMGlobal.claimId+"&dspItemNo="+dspItemNo+"&dspPerilCd="+dspPerilCd,
						histInfoTableGrid._refreshList();		
						objCLM.histInfoTBLength = histInfoTableGrid.geniisysRows.length;
				},
				onRemoveRowFocus : function(){
					histInfoTableGrid.clear();
					histInfoTableGrid.empty();
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
				{ 	id: 'dspItemNo',
				  	align: 'right',
				  	title: 'Item No',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true
				},
				{ 	id: 'groupedItemNo',
					width: '0',
				  	visible:false
				},
				{	id: 'dspItemTitle',
					align: 'left',
				  	title: 'Item Title',
				  	titleAlign: 'center',
				  	width: '250px',
				  	editable: false,
				  	sortable: true
				},
				{ 	id: 'dspPerilCd',
					title : 'Peril Code',
					titleAlign: 'center',
					align: 'right',
					width : '63px',
					editable: false,
				  	sortable: true
				},
				{ 	id: 'dspPerilName',
					align : 'left',
					title : 'Peril Name',
					titleAlign : 'center',
					width : '250px',
					editable: false,
					sortable: true
				},
				{ 	id: 'currencyCd',
					width : '0px',
					visible: false
				},
				{ 	id: 'dspCurrDesc',
					align : 'left',
					title : 'Currency',
					titleAlign : 'center',
					width : '171px',
					editable: false,
					sortable: true
				}
			],
			rows : objPrintDocsItemInfo.rows
		};
		
		printDocsItemInfoTableGrid = new MyTableGrid(claimItemInfoTableModel);
		printDocsItemInfoTableGrid.pager = objPrintDocsItemInfo;
		printDocsItemInfoTableGrid.render('printDocsItemInfoTableGrid');
		
	}catch(e){
		showErrorMessage("printDocsItemInfo", e);
	}
	
	//hist info table grid
	try{
		objPayee = new Object();
		objPayee.payeeClCd = "";
		objPayee.payeeCd= "";
		objPayee.clmLossId = ""; //create a variable for clm_loss_id field by MAC 12/6/2012
		var histInfo = {};
		var histInfoTableModel = {
				options:{
					title: '',
					width: '810px',
					pager:{},
					hideColumnChildTitle: true,
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
					    editable: true, 
					    sortable: false,
					    /* editor: 'checkbox',*/
					    editor: new MyTableGrid.CellCheckbox({
			            	onClick: function(value, checked){
			            		getPayee(value, checked);		            		
			            	}
						})
					},
					{	id: 'adviceId',
						width: '0',
					  	visible:false
					},
					{ 	id: 'historySequenceNumber',
					  	align: 'right',
					  	title: '&nbspHist No',
					  	titleAlign: 'left',
					  	altTitle: 'History No.',
					  	width: '50px',
					  	editable: false,
					  	sortable: true
					},
					{	id: 'itemStatusCd',
						align: 'center',
					  	title: 'Item Stat',
					  	titleAlign: 'center',
					  	width: '66px',
					  	editable: false,
					  	sortable: true
					},
					{ 	id: 'payeeType',
						title : '&nbsp&nbspP',
						titleAlign: 'center',
						altTitle: 'Payee Type',
						align: 'center',
						width : '25px',
						editable: false,
					  	sortable: true
					},
					{ 	id: 'payeeClassCode payeeCode payeeLastName',
						title : 'Payee',
						titleAlign : 'center',
						width : '500px',
						children : [
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
				                width : '260',
				                editable: false,
				                align: 'left'
				            }
						]
					},
					{ 	id: 'csrNo',
						align : 'left',
						title : 'CSR No',
						titleAlign : 'left',
						width : '130px',
						editable: false,
						sortable: true
					},
					{ 	id: 'paidAmount',
						align : 'right',
						title : 'Paid Amount',
						titleAlign : 'right',
						geniisysClass: 'money',
						width : '110px',
						editable: false,
					  	sortable: true
					},
					{//included clm_loss_id field by MAC 12/6/2012
						id: 'claimLossId',
						width: '0',
					  	visible: false
					}	
				],
				rows : []
			};
			
			histInfoTableGrid = new MyTableGrid(histInfoTableModel);
			histInfoTableGrid.pager = histInfo;
			histInfoTableGrid.render('claimsHistInfoTableGridDiv');
	}catch(e){
		showErrorMessage("printDocsHistInfo", e);
	}
	
	//belle 06.25.2012
	function getPayee(value, checked){
		if (true == checked){
			var currPayeeClCd = histInfoTableGrid.getValueAt(histInfoTableGrid.getColumnIndex("payeeClassCode"), histInfoTableGrid.getCurrentPosition()[1]); 
			var currPayeeCd   = histInfoTableGrid.getValueAt(histInfoTableGrid.getColumnIndex("payeeCode"), histInfoTableGrid.getCurrentPosition()[1]);
			var currPayeeName = histInfoTableGrid.getValueAt(histInfoTableGrid.getColumnIndex("payeeLastName"), histInfoTableGrid.getCurrentPosition()[1]);
			var currClmLossId = histInfoTableGrid.getValueAt(histInfoTableGrid.getColumnIndex("claimLossId"), histInfoTableGrid.getCurrentPosition()[1]); //store value of clm_loss_id by MAC 12/6/2012
			var currAdviceId = histInfoTableGrid.getValueAt(histInfoTableGrid.getColumnIndex("adviceId"), histInfoTableGrid.getCurrentPosition()[1]); //store value of advice_id by MAC 12/6/2012
			
			if (objPayee.payeeClCd == ""){
				objPayee.payeeClCd = currPayeeClCd;
				objPayee.payeeCd   = currPayeeCd;
				objPayee.payeeName = currPayeeName;
				objPayee.clmLossId = currClmLossId; //get clm_loss_id of the first tagged settlement history by MAC 12/6/2012
			}
			
			if (objPayee.payeeClCd == currPayeeClCd){
				if (objPayee.payeeCd == currPayeeCd){
					if (currAdviceId != null){ //get clm_loss_id if advice_id is not null by MAC 12/6/2012
						objPayee.clmLossId = currClmLossId;
					}
				}else{
					showMessageBox("Please select records with the same payee.", imgMessage.ERROR);
					histInfoTableGrid.setValueAt(false, histInfoTableGrid.getColumnIndex('checkBox1'), histInfoTableGrid.getCurrentPosition()[1]);
				}
			}else{
				showMessageBox("Please select records with the same payee.", imgMessage.ERROR);
				histInfoTableGrid.setValueAt(false, histInfoTableGrid.getColumnIndex('checkBox1'), histInfoTableGrid.getCurrentPosition()[1]);
			}
		}else if (false == checked){
			var rows = histInfoTableGrid.getModifiedRows();
			var ctr = 0;
			for (var i=0; i<rows.length; i++){
				if (rows[i].checkBox1 == true){
					ctr = ctr+1;
				}
			}
			if (ctr==0){
				objPayee.payeeClCd = "";
				objPayee.payeeCd   = "";
				objPayee.payeeName = "";
				objPayee.clmLossId = ""; //clear variable by MAC 12/6/2012
			}
		} 
	}
	

</script>