<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
<title>AIBO MIND 2 | PHOTO ALBUM Pictures taken by AIBO</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<style type="text/css">
<!--
body{
	background: "#FFFFFF";
	margin: 0;
}	
td{
    font-family: Verdana;
    font-size: 14px;
    font-style: normal;
    line-height: 20px;
}
.textm{
	font-family: Verdana;
	font-size: 12px;
	font-style: normal;
	line-height: 18px;
	vertical-align: middle;
}
.texts{
	font-family: Verdana;
	font-size: 12px;
	font-style: normal;
	line-height: 18px;
	vertical-align: middle;
}
-->
</style>
<script type="text/javascript">
<!--
var imageWindow;
var path;
var n;
function OpenImageWindow(filename){
	if(!imageWindow || imageWindow.closed){
		if(document.getElementById){
			imageWindow = window.open("./IMAGE.HTM", "image","height=528,width=464,resizable");
			n = 0;
			setTimeout("WriteImage()", 50);
		}else{
			imageWindow = window.open("./PHOTO/" + filename, "image", "height=348,width=436,resizable");
		}
		path = filename;

	}else{
		path = filename;
		if(document.getElementById){
			WriteImage();
		}else{
			imageWindow = window.open("./PHOTO/" + filename, "image", "height=348,width=438,resizable");
		}
		if(imageWindow.focus){
			imageWindow.focus();
		}
	}
}
function WriteImage(){
	var obj = imageWindow.document.getElementById("FullImage");
	if(!obj){
		if(n < 100){
			setTimeout("WriteImage()", 100);
			n++;
		}
	}else{
		obj.setAttribute("src", "./PHOTO/" + path);
	}
}
-->
</script>
</head>
<!--#LNK 0 9 ../VOICE/%04d.WAV -->

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="../IMG/COMMON/BG.GIF">
<tr> 
<td>
<table width="772" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td height="74" width="43"></td>
<td height="74" width="537" valign="bottom"><img src="./IMG/TITLE.GIF" width="386" height="55" alt="AIBO PHOTO ALBUM Pictures taken by AIBO"></td>
<td height="74" width="192" valign="bottom"><img src="../IMG/COMMON/SUBTITLE.GIF" width="192" height="55" alt="AIBO MIND 2" border="0" usemap="#Map"></td>
</tr>
</table>
</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="78">
<tr>
<td height="7"></td>
</tr>
<tr>
<td background="../IMG/COMMON/BGBAR.GIF" height="40"></td>
</tr>
<tr>
<td height="30"></td>
</tr>
</table>
<!-- GLOBAL DESIGN TABLE -->
<table width="761" border="0" cellspacing="0" cellpadding="0">
<tr>
<!-- LEFT MARGIN -->
<td width="43"></td>
<!-- PHOTO DESIGN TABLE BLOCK table size 540 + trail 10 -->
<td width="550">
<table width="550" border="0" cellspacing="0" cellpadding="0">

<!-- SNAPSHOT -->
<!-- SNAPSHOT TITLE -->
<tr>
<td><img src="../IMG/COMMON/TABLE01.GIF" alt="Pictures taken by voice commands, AIBO Card and AIBO MAIL"></td>
</tr>
<tr>
<td height="4"></td>
</tr>

<tr>
<td>
<!-- SNAPSHOT TABLE start-->
<table width="540" align="left" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 0 5 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
<!-- SNAPSHOT TABLE 5 x 1-->
</td>
</tr>

<!-- Category Horizontal spacer -->
<tr>
<td height="15"></td>
</tr>

<!-- WATCH -->
<!-- WATCH TITLE -->
<tr>
<td><img src="../IMG/COMMON/TABLE02.GIF" alt="Pictures and sounds recorded during House Sitting Mode"></td>
</tr>
<tr>
<td height="4"></td>
</tr>

<tr>
<td>
<!-- WATCH TABLE start-->
<table width="540" align="left" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 1 5 3 IDTC 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
<!-- WATCH TABLE 5 x 3-->
</td>
</tr>

<!-- Category Horizontal spacer -->
<tr>
<td height="15"></td>
</tr>


<!-- OWNER FACE -->
<!-- OWNER FACE TITLE -->
<tr>
<td><img src="../IMG/COMMON/TABLE04.GIF" alt="Friendly faces"></td>
</tr>
<tr>
<td height="4"></td>
</tr>

<tr>
<td>
<!-- OWNER FACE TABLE start-->
<table width="322" align="left" border="0" cellspacing="0" cellpadding="0">
<tr>

<!-- OWNER FACE #1 -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 3 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

<td width="5"></td>

<!-- OWNER FACE #2 -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 4 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

<td width="5"></td>

<!-- OWNER FACE #3 -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 5 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

</tr>
</table>

<!-- OWNER FACE -->
</td>
</tr>

<!-- Category Horizontal spacer -->
<tr>
<td height="15"></td>
</tr>

<!-- FAVORITE -->
<tr>
<td>
<!-- FAVORITE DESIGN TABLE -->
<table width="550" border="0" cellspacing="0" cellpadding="0">
<tr>
<td colspan="8"><img src="../IMG/COMMON/TABLE05.GIF" alt="Favorite things"></td>
<td colspan="2"><img src="../IMG/COMMON/TABLE03.GIF" alt="Favorite place"></td>
</tr>
<tr>
<td height="4"></td>
</tr>

<tr>
<!-- FAVORITE THING #1 -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 6 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

<td width="5"></td>

<!-- FAVORITE THING #2 -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 7 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

<td width="5"></td>

<!-- FAVORITE THING #3 -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 8 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

<!-- FAVORITE spacing -->
<td width="5"></td>
<td width="104"></td>
<td width="5"></td>

<!-- FAVORITE PLACE  -->
<td width="104">
<table width="104" border="0" cellspacing="0" cellpadding="0">
<!--#TBL 2 1 1 IDT 104 80 104 80 5 5 ./PHOTO/ IMG%05d.JPG ./PHOTO/ THM%05d.JPG OpenImageWindow('IMG%05d.JPG') -->
</table>
</td>

<!-- trail -->
<td width="10" ></td>

</tr>
</table>

<!-- FAVORITE close -->
</td>
</tr>

<!-- Category Horizontal spacer -->
<tr>
<td height="15"></td>
</tr>

<!-- PHOTO DESIGN TABLE BLOCK-->
</table>
</td>

<!--#ESC This is escape block -->

<!-- HORZ SPACE -->
<td width="14" align="right" valign="top"><br>
</td>

<!-- LINKS -->
<td width="154" align="left" valign="top"><font color="#FF0000"><span class="texts">* </span></font><font color="#333333"><span class="textm">Click on an image to enlarge.</span></font><br>
<br><br><br><br><br><br><br>
<font color="#FF0000"><span class="texts">* </span></font><font color="#333333"><span class="textm">MOTION : Motion activated recording.<br>
<font color="#FF0000"><span class="texts">* </span></font><font color="#333333"><span class="textm">SOUND : Sound activated recording.<br>
<font color="#FF0000"><span class="texts">* </span></font><font color="#333333"><span class="textm">Click SOUND to hear the audio clip.</span></font><br>
</td>
<!-- GLOBAL DESIGN TABLE -->
</tr>
</table>

<!-- AIBO LINKS -->
<table width="752" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td height="27" colspan="2"></td>
</tr>
<tr>
<td width="43"></td>
<td width="709"><img src="../IMG/COMMON/FOOTER.GIF" width="444" height="39" alt="Copyright 2003-2004 Sony Corporation"></td>
</tr>
<tr>
<td height="12" colspan="2"></td>
</tr>
</table>

<!-- Clickable map declaration -->
<map name="Map"> 
<area shape="rect" coords="10,39,156,54" href="../INDEX.HTM" alt="Return to the top page" title="Return to the top page">
</map>
</body>
</html>
