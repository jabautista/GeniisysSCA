<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="addtlInfoDiv" changeTagAttr="true">
	<table align="center" style="margin-bottom: 5px; margin-top: 5px;">
		<tr>
			<td class="rightAligned" width="120px">Address</td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtAddress1" name="txtAddress1" value="" style="width: 370px; border: none;" tabindex="21" maxlength="50" class="upper"/><!-- Gzelle 10.18.2013 added maxlength and class=upper-->
					<img id="editAddress1" alt="editAddress" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px"></td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtAddress2" name="txtAddress2" value="" style="width: 370px; border: none;" tabindex="22" maxlength="50" class="upper"/><!-- Gzelle 10.18.2013 added maxlength and class=upper-->
					<img id="editAddress2" alt="editAddress2" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px"></td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtAddress3" name="txtAddress3" value="" style="width: 370px; border: none;" tabindex="23" maxlength="50" class="upper"/><!-- Gzelle 10.18.2013 added maxlength and class=upper-->
					<img id="editAddress3" alt="editAddress3" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px">Remarks</td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtRemarks" name="txtRemarks" value="" style="width: 370px; border: none;" tabindex="24" maxlength="4000" class="upper"/><!-- Gzelle 10.21.2013 added maxlength and class=upper-->
					<img id="editRemarks" alt="editRemarks" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px">Binder Remarks</td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtBinder1" name="txtBinder1" value="" style="width: 370px; border: none;" tabindex="25" maxlength="100" class="upper"/><!-- Gzelle 10.21.2013 added maxlength and class=upper-->
					<img id="editBinder1" alt="editBinder" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px"></td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtBinder2" name="txtBinder2" value="" style="width: 370px; border: none;" tabindex="26" maxlength="100" class="upper"/><!-- Gzelle 10.21.2013 added maxlength and class=upper-->
					<img id="editBinder2" alt="editBinder" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px"></td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtBinder3" name="txtBinder3" value="" style="width: 370px; border: none;" tabindex="27" maxlength="100" class="upper"/><!-- Gzelle 10.21.2013 added maxlength and class=upper-->
					<img id="editBinder3" alt="editBinder" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px">Accepted By (RI)</td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtAcceptedBy" name="txtAcceptedBy" value="" style="width: 370px; border: none;" tabindex="28" maxlength="30" class="upper"/><!-- Gzelle 10.21.2013 added maxlength and class=upper-->
					<img id="editAcceptedBy" alt="editAcceptedBy" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px">AS No (RI)</td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtASNo" name="txtASNo" value="" style="width: 370px; border: none;" tabindex="29" maxlength="20" class="upper"/><!-- Gzelle 10.21.2013 added maxlength and class=upper-->
					<img id="editASNo" alt="editASNo" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px">Accept Date (RI)</td>
			<td class="leftAligned" width="430px">
				<div style="width: 400px; border: 1px solid gray;">
					<input type="text" id="txtAcceptDate" name="txtAcceptDate" value="" style="width: 370px; border: none;" readonly="readonly" tabindex="30" removeStyle="true"/>
					<img id="imgAcceptDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtAcceptDate').focus(); scwShow($('txtAcceptDate'),this, null);" style="margin: 0;" />
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input type="button" id="btnUpdate"	name="btnUpdate" class="disabledButton" value="Update" style="width: 100px;"/></td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	makeInputFieldUpperCase();
	/* disableButton("btnUpdate");

	$$("div#addtlInfoDiv input").each(function(input) {
		input.observe("keyup", function() {
			enableButton("btnUpdate");
			return;
		});
	}); */

	$("editAddress1").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtAddress1", 50); //changed from 250 to 50 by robert 09182013
		showOverlayEditor("txtAddress1", 50, $("txtAddress1").hasAttribute("readonly"), function() {
			limitText($("txtAddress1"),50);		
		});
	});

	$("txtAddress1").observe("keyup", function () {
		limitText(this, 50); //changed from 250 to 50 by robert 09182013
	});
	
	$("editAddress2").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtAddress2", 50); //changed from 250 to 50 by robert 09182013
		showOverlayEditor("txtAddress2", 50, $("txtAddress2").hasAttribute("readonly"), function() {
			limitText($("txtAddress2"),50);		
		});
	});

	$("txtAddress2").observe("keyup", function () {
		limitText(this, 50); //changed from 250 to 50 by robert 09182013
	});

	$("editAddress3").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtAddress3", 50); //changed from 250 to 50 by robert 09182013
		showOverlayEditor("txtAddress3", 50, $("txtAddress3").hasAttribute("readonly"), function() {
			limitText($("txtAddress3"),50);		
		});
	});

	$("txtAddress3").observe("keyup", function () {
		limitText(this, 50); //changed from 250 to 50 by robert 09182013
	});

	$("editRemarks").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtRemarks", 4000); //changed from 250 to 4000 by robert 09182013
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
			limitText($("txtRemarks"),4000);
		});
	});

	$("txtRemarks").observe("keyup", function () {
		limitText(this, 4000); //changed from 250 to 4000 by robert 09182013
	});

	$("editBinder1").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtBinder1", 100); //changed from 250 to 100 by robert 09182013
		showOverlayEditor("txtBinder1", 100, $("txtBinder1").hasAttribute("readonly"), function() {
			limitText($("txtBinder1"),100);
		});
	});

	$("txtBinder1").observe("keyup", function () {
		limitText(this, 100); //changed from 250 to 100 by robert 09182013
	});

	$("editBinder2").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtBinder2", 100); //changed from 250 to 100 by robert 09182013
		showOverlayEditor("txtBinder2", 100, $("txtBinder2").hasAttribute("readonly"), function() {
			limitText($("txtBinder2"),100);
		});
	});

	$("txtBinder2").observe("keyup", function () {
		limitText(this, 100); //changed from 250 to 100 by robert 09182013
	});

	$("editBinder3").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtBinder3", 100); //changed from 250 to 100 by robert 09182013
		showOverlayEditor("txtBinder3", 100, $("txtBinder3").hasAttribute("readonly"), function() {
			limitText($("txtBinder3"),100);
		});
	});

	$("txtBinder3").observe("keyup", function () {
		limitText(this, 100); //changed from 250 to 100 by robert 09182013
	});

	$("editAcceptedBy").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtAcceptedBy", 30); //changed from 250 to 30 by robert 09182013
		showOverlayEditor("txtAcceptedBy", 30, $("txtBinder3").hasAttribute("readonly"), function() {
			limitText($("txtAcceptedBy"),30);
		});
	});

	$("txtAcceptedBy").observe("keyup", function () {
		limitText(this, 30); //changed from 250 to 30 by robert 09182013
	});

	$("editASNo").observe("click", function () {
		//comment out by Gzelle 10.21.2013 changed to showOverlayEditor
		//showEditor("txtASNo", 20); //changed from 250 to 20 by robert 09182013
		showOverlayEditor("txtASNo", 20, $("txtASNo").hasAttribute("readonly"), function() {
			limitText($("txtASNo"),20);
		});
	});

	$("txtASNo").observe("keyup", function () {
		limitText(this, 20); //changed from 250 to 20 by robert 09182013
	});

</script>