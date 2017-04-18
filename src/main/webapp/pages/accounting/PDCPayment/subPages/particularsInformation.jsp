<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="spinLoadingDiv"></div>
<div class="sectionDiv">
	<div id="particularsDtlsDiv" style="height: 200px;">
		<div style="width: 100%; float: left; margin-top: 10px;">
			<label style="margin-left: 151px; float: left; margin-top: 4px;">Payor</label>
			<input style="float: left; margin-left: 4px; width: 571px;" type="text" class="required" id="particularsPayor" name="particularsPayor" maxlength="150" tabindex="1" />
		</div>
		<div style="width: 100%; float: left;">
			<label style="margin-left: 137px; float: left; margin-top: 4px;">Address</label>
			<input style="float: left; margin-left: 5px; width: 572px;" type="text" class="required" id="address1" name="address1" maxlength="50" tabindex="2" />
			<input style="float: left; margin-left: 188px; width: 571px;" type="text" class="required" id="address2" name="address2" maxlength="50" tabindex="3" />
			<input style="float: left; margin-left: 188px; width: 571px;" type="text" class="required" id="address3" name="address3" maxlength="50" tabindex="4" />
		</div>
		<div style="width: 100%; float: left;">
			<label style="margin-left: 140px; float: left; margin-top: 4px;">TIN No.</label>
			<input style="float: left; margin-left: 5px; width: 151px;" type="text" class="required" id="tinNo" name="tinNo" maxlength="30" tabindex="5" />
			<label style="margin-left: 30px; float: left; margin-top: 4px;">Intermediary</label>
			<input style="float: left; margin-left: 5px; width: 304px;" type="text" class="required" id="intermediary" name="intermediary" maxlength="240" tabindex="6" />
		</div>
		<div style="width: 100%; float: left; margin-top: 3px;">
			<label style="margin-left: 123px; margin-top: 5px; float: left;">Particulars</label>
			<div id="particulars" name="particulars" style="float: left; margin-left: 6px; width: 577px; border: 1px solid gray; background-color: cornsilk;"/>
				<input style="float: left; height: 14px; width: 95%; margin-top: 1px; background-color: cornsilk; border: none;" type="text" id="particularsDtl" name="particularsDtl" maxlength="500" tabindex="7" />
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditParticulars" id="editParticularsDtlText" />
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">	
	$("editParticularsDtlText").observe("click", function (){
		showEditor("particularsDtl", 500);
	});

	$("particularsPayor").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("particularsPayor"),postDatedChecksTableGrid.getColumnIndex('payor'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.payor = $F("particularsPayor");
		//setPostDatedCheckAsEdited(testEditedRow);
	});

	$("address1").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("address1"),postDatedChecksTableGrid.getColumnIndex('address1'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.address1 = $F("address1"); 
		//setPostDatedCheckAsEdited(testEditedRow);
	});

	$("address2").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("address2"),postDatedChecksTableGrid.getColumnIndex('address2'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.address2 = $F("address2");
		//setPostDatedCheckAsEdited(testEditedRow);
	});

	$("address3").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("address3"),postDatedChecksTableGrid.getColumnIndex('address3'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.address3 = $F("address3");
		//setPostDatedCheckAsEdited(testEditedRow);
	});

	$("tinNo").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("tinNo"),postDatedChecksTableGrid.getColumnIndex('tin'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.tin = $F("tinNo"); 
		//setPostDatedCheckAsEdited(testEditedRow);
	});

	$("intermediary").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("intermediary"),postDatedChecksTableGrid.getColumnIndex('intermediary'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.intermediary = $F("intermediary");
		//setPostDatedCheckAsEdited(testEditedRow);
	});

	$("particularsDtl").observe("blur", function (){
		postDatedChecksTableGrid.setValueAt($F("particularsDtl"),postDatedChecksTableGrid.getColumnIndex('particulars'),$F("selectedPDCIndex"),true);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		//testEditedRow.particulars = $F("particularsDtl");
		//setPostDatedCheckAsEdited(testEditedRow);
	});
</script>