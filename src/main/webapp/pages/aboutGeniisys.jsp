<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="aboutGeniisysMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center"> 
	<div class="sectionDiv" style="float: left; height: 245px; width: 100%;" id="">
		<div style="float: left; margin: 5px; width: 97%;">
			<div class="aboutGeniisys" style="margin-left: 160px; height: 70px; width: 350px; float: left;"></div>
			<table align="left" style="margin-left: 5px; width: 570px; margin-top: 5px;">
				<!-- <tr>
					<td><label style="font-size: 40px; float: left; height: 30px; color: graytext;">Geniisys</label></td>
				</tr> -->
				<tr>
					<td><label style="margin-left: 5px;">Version:&nbsp;${geniisys.version}</label></td>
				</tr>
				<tr>
					<td><label style="margin-left: 5px;">Release Date:&nbsp;${geniisys.releaseDate}</label></td>
				</tr>	
				<tr>
					<td>&nbsp;</td>
				</tr>			
				<tr>
					<td><div style="margin-left: 5px; height: 55px; overflow-x: auto;">${description}</div></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td><label style="margin-left: 5px;">&copy; Copyright Computer Professionals, Inc. All rights reserved.</label></td>
				</tr>		
				<tr>
					<td><label style="margin-left: 5px;">Visit&nbsp;</label><a href="http://www.cpi.com.ph" target="#">www.cpi.com.ph</a></td>
				</tr>
			</table>
		</div>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnClose" name="btnClose" value="Close" style="width: 80px;">	
	</div>	
</div>
<script type="text/javascript">
	$("btnClose").observe("click", function(){
		ovlAboutGeniisys.close();
		delete ovlAboutGeniisys;
	});
</script>
