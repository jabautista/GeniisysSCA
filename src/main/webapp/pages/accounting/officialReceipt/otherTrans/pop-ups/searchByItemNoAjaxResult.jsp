<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="width: 100%; text-align: center;" id="itemNoListingTable" name="itemNoListingTable">
	<div class="tableHeader">
	     <label style="width: 100px; margin-left: 15px; ">Tran Year</label>
		<label style="width: 100px; ">Tran Month</label>
		<label style="width: 100px; ">Tran Seq No.</label>
		<label style="width: 100px; ">Old Item No.</label>
		<label style="width: 100px; margin-left: 40px; ">Collection Amt</label>
		<label style="width: 100px; margin-left: 10px; ">Particulars</label>
	</div>
</div>
<div id="itemNoTableContainer"  style="width: 100%; text-align: center;"  class="tableContainer">	
			
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select onChange="openSearchItemModal2(this.value);">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
</div>
<script>
var objLblValues = new Object();
var objArray = eval('${JSONSearchResults}');

showSearhResults(objArray);

function showSearhResults(objArray){
	try {
		var itemTable = $("itemNoTableContainer");
		
		for(var i=0; i<objArray.length; i++) {				
			var content = prepareItemNoListInfo(objArray[i]);										
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "row"+objArray[i].gaccTranId+ "" +objArray[i].itemNo);
			newDiv.setAttribute("name", "itemNoRow");
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			itemTable.insert({bottom : newDiv});
			divEvents(newDiv);
		}
	} catch (e) {
		showErrorMessage("showSearhResults", e);
		//showMessageBox("showItemList : " + e.message);
	}
}

function prepareItemNoListInfo(obj){
	var particulars = obj.particulars == null ? "" : obj.particulars;
	try {				
		var itemNoListInfo  = '<label style="width: 40px; text-align: right; margin-left: 63px;" id="lblTranYear'+obj.tranYear+'">'+obj.tranYear+'</label>' +						
						'<label style="width: 40px; text-align: right; margin-left: 55px;" id="lblTranMonth'+obj.tranMonth+'">'+obj.tranMonth+'</label>'+
						'<label style="width: 75px; text-align: right; margin-left: 34px;" id="lblTakeSeqNo'+obj.tranSeqNo+'">'+obj.tranSeqNo+'</label>'+
						'<label style="width: 75px; text-align: right; margin-left: 25px;" id="lblItemNo'+obj.itemNo+'">'+obj.itemNo+'</label>'+
						'<label style="width: 120px; text-align: right; margin-left: 25px;" id="lblCollectionAmt'+obj.collectionAmt+'">'+formatCurrency(obj.collectionAmt)+'</label>'+
						'<label style="width: 160px; text-align: left; margin-left: 14px;" id="lblparticulars'+obj.particulars+'">'+particulars+'</label>' + 
						'<label style="display: none;" id="lblGlAcctId">'+obj.glAcctId+'</label>' + 
						'<label style="display: none;" id="lblGlAcctCategory">'+obj.glAcctCategory+'</label>' +
						'<label style="display: none;" id="lblGlCtrlAcct">'+obj.glCtrlAcct+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct1">'+obj.glSubAcct1+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct2">'+obj.glSubAcct2+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct3">'+obj.glSubAcct3+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct4">'+obj.glSubAcct4+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct5">'+obj.glSubAcct5+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct6">'+obj.glSubAcct6+'</label>' +
						'<label style="display: none;" id="lblGlSubAcct7">'+obj.glSubAcct7+'</label>' +
						'<label style="display: none;" id="lblOrPrintTag">'+obj.orPrintTag+'</label>' +
						'<label style="display: none;" id="lblSlCd">'+obj.slCd+'</label>' + 
						'<label style="display: none;" id="lblGuncTranId">'+obj.guncTranId+'</label>' + 
						'<label style="display: none;" id="lblGuncItemNo">'+obj.guncItemNo+'</label>' +
						'<label style="display: none;" id="lblGlAcctName">'+obj.glAcctName+'</label>';

		return itemNoListInfo;
	} catch (e) {
		showErrorMessage("prepareItemNoListInfo", e);
		//showMessageBox("prepareItemNoListInfo : " + e.message);
	}
}


function divEvents(div) {
	div.observe("mouseover", function () {
		div.addClassName("lightblue");
	});
	
	div.observe("mouseout", function ()	{
		div.removeClassName("lightblue");
	});

	div.observe("click", function () {
		selectedRowId = div.getAttribute("id");
		div.toggleClassName("selectedRow");
		if (div.hasClassName("selectedRow"))	{
			$$("div[name='itemNoRow']").each(function (r)	{
				if (div.getAttribute("id") != r.getAttribute("id"))	{
					r.removeClassName("selectedRow");
				}
		    });
			setObjectValues(div);	
			enableButton("btnOk");		
		}else{
			objLblValues = null;
			disableButton("btnOk");	
		} 
	});
}

$("btnOk").observe("click", function (){
	$("ucTranYear").value = objLblValues.tranYear;
	$("ucTranMonth").value = objLblValues.tranMonth;
	$("ucTranSeqNo").value = objLblValues.tranSeqNo;
	$("ucAmount").value = objLblValues.collectionAmt;
	$("ucParticulars").value = objLblValues.particulars;
	$("ucOldItemNo").value = objLblValues.itemNo;
	$("glAcctCategory").value = objLblValues.glAcctCategory;
	$("glControlAcct").value = objLblValues.glCtrlAcct;
	$("acctCode1").value = objLblValues.glSubAcct1;
	$("acctCode2").value = objLblValues.glSubAcct2;
	$("acctCode3").value = objLblValues.glSubAcct3;
	$("acctCode4").value = objLblValues.glSubAcct4;
	$("acctCode5").value = objLblValues.glSubAcct5;
	$("acctCode6").value = objLblValues.glSubAcct6;
	$("acctCode7").value = objLblValues.glSubAcct7;
	$("ucAcctName").value = objLblValues.glAcctName;
	$("ucHiddenSlTypeCd").value = objLblValues.gsltSlTypeCd;
	$("ucHiddenGlAcctId").value = objLblValues.glAcctId;
	$("ucHiddenSlCd").value = objLblValues.slCd;
	$("ucHiddenGuncTranId").value = objLblValues.guncTranId;
	Modalbox.hide();
});

function setObjectValues(div){
	objLblValues.tranYear = div.down("label", 0).innerHTML; 
	objLblValues.tranMonth = parseInt(div.down("label", 1).innerHTML).toPaddedString(2); 
	objLblValues.tranSeqNo = parseInt(div.down("label", 2).innerHTML).toPaddedString(5); 
	objLblValues.itemNo = parseInt(div.down("label", 3).innerHTML).toPaddedString(2); 
	objLblValues.collectionAmt = div.down("label", 4).innerHTML; 
	objLblValues.particulars = div.down("label", 5).innerHTML; 
	objLblValues.glAcctId = div.down("label", 6).innerHTML; 
	objLblValues.glAcctCategory = div.down("label", 7).innerHTML; 
	objLblValues.glCtrlAcct = parseInt(div.down("label", 8).innerHTML).toPaddedString(2); 
	objLblValues.glSubAcct1 = parseInt(div.down("label", 9).innerHTML).toPaddedString(2); 
	objLblValues.glSubAcct2 = parseInt(div.down("label", 10).innerHTML).toPaddedString(2); 
	objLblValues.glSubAcct3 = parseInt(div.down("label", 11).innerHTML).toPaddedString(2);  
	objLblValues.glSubAcct4 = parseInt(div.down("label", 12).innerHTML).toPaddedString(2);  
	objLblValues.glSubAcct5 = parseInt(div.down("label", 13).innerHTML).toPaddedString(2); 
	objLblValues.glSubAcct6 = parseInt(div.down("label", 14).innerHTML).toPaddedString(2); 
	objLblValues.glSubAcct7 = parseInt(div.down("label", 15).innerHTML).toPaddedString(2); 
	objLblValues.orPrintTag = div.down("label", 16).innerHTML; 
	objLblValues.slCd = div.down("label", 17).innerHTML; 
	objLblValues.guncTranId = div.down("label", 18).innerHTML; 
	objLblValues.guncItemNo = div.down("label", 19).innerHTML; 
	objLblValues.glAcctName = div.down("label", 20).innerHTML; 
}

</script>