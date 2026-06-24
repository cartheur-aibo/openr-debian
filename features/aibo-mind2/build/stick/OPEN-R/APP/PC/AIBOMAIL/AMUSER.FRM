<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
<title>AIBO MIND 2 | AIBO EYES Private Mode Setup</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<script language="JavaScript">
<!--
mac=(navigator.appVersion.indexOf('Mac')!=-1)?true:false;
ie=(navigator.appName.charAt(0) == "M")?true:false;

document.write("<STYLE TYPE='text/css'><!--")
if(mac){
    if(ie){
        document.write(".m { font-family: Verdana; font-size: 10px; line-height: 135%;}")
        document.write(".l { font-family: Verdana; font-size: 12px; line-height: 145%;}")
        document.write(".lb { font-family: Verdana; font-size: 12px; line-height: 145%; font-weight: bold;}")
    }

    else{
        document.write(".m { font-family: Verdana; font-size: 10px; line-height: 115%;}")
        document.write(".l { font-family: Verdana; font-size: 12px; line-height: 115%;}")
        document.write(".lb { font-family: Verdana; font-size: 12px; line-height: 115%; font-weight: bold;}")
    }
}

else{
    if(ie){
        document.write(".m { font-family: Verdana; font-size: 10px; line-height: 130%; }")
        document.write(".l { font-family: Verdana; font-size: 12px; line-height: 130%;}")
        document.write(".lb { font-family: Verdana; font-size: 12px; line-height: 130%; font-weight: bold; }")
    }
    else{
        document.write(".m { font-family: Verdana; font-size: 10px; line-height: 125%;  }")
        document.write(".l { font-family: Verdana; font-size: 12px; line-height: 130%;}")
        document.write(".lb { font-family: Verdana; font-size: 12px; line-height: 130%; font-weight: bold; }")
    }
}

document.write("--></STYLE>");
//-->   
</script>
</head>

<body bgcolor="#FFFFFF" text="#333333" link="#FF0000" vlink="#FF3300" alink="#FF3300" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form method="post" action="./amuser.cgi">
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="../IMG/COMMON/BG.GIF">
<tr> 
<td>
<table width="743" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td height="74" width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td height="74" width="537" valign="bottom"><img src="./IMG/TITLE02.GIF" width="204" height="55" alt="AIBO EYES Private Mode Setup"></td>
<td height="74" width="192" valign="bottom"><img src="../IMG/COMMON/SUBTITLE.GIF" width="192" height="55" alt="AIBO MIND 2" border="0" usemap="#Map2"></td>
<td height="74" width="*"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="78">
<tr>
<td height="7"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td background="../IMG/COMMON/BGBAR.GIF" height="40"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
<table width="743" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19"><img src="./IMG/C.GIF" width="19" height="17" alt=""></td>
<td width="186"><img src="./IMG/P01A.GIF" width="62" height="14" alt="User 1"></td>
<td width="297"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>E-mail address</b></font></td>
<td width="297" height="30" valign="bottom">
<%USER1_MAILADDR%>
</td>
<td width="35" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td rowspan="6" valign="top" width="163"><img src="../IMG/COMMON/00A.GIF" width="163" height="14" border="0"><br>
      <img src="../IMG/COMMON/03.GIF" width="163" height="16" border="0" usemap="#Map4" alt="Mail Setup"><br>
<img src="../IMG/COMMON/00B.GIF" width="163" height="9" border="0"><br>
<img src="../IMG/COMMON/02.GIF" width="163" height="16" border="0" usemap="#Map5" alt="Connection Check"><br>
<img src="../IMG/COMMON/00C.GIF" width="163" height="14" border="0">
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Voice signature</b></font></td>
<td width="297" height="30" valign="bottom">
<select name="USER1_VOICESIG">
<%USER1_VOICESIG% VALUE="1">AIBO friend 1</OPTION>
<%USER1_VOICESIG% VALUE="2">AIBO friend 2</OPTION>
<%USER1_VOICESIG% VALUE="3">AIBO friend 3</OPTION>
<%USER1_VOICESIG% VALUE="4">AIBO friend 4</OPTION>
<%USER1_VOICESIG% VALUE="5">AIBO friend 5</OPTION>
<%USER1_VOICESIG% VALUE="6">Owner</OPTION>
<%USER1_VOICESIG% VALUE="7">Dad</OPTION>
<%USER1_VOICESIG% VALUE="8">Mom</OPTION>
<%USER1_VOICESIG% VALUE="9">Me</OPTION>
<%USER1_VOICESIG% VALUE="10">AIBO</OPTION>
<%USER1_VOICESIG% VALUE="11">User recording 1</OPTION>
<%USER1_VOICESIG% VALUE="12">User recording 2</OPTION>
<%USER1_VOICESIG% VALUE="13">User recording 3</OPTION>
<%USER1_VOICESIG% VALUE="14">User recording 4</OPTION>
<%USER1_VOICESIG% VALUE="15">User recording 5</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td colspan="2" height="30" valign="bottom"><img src="./IMG/P04.GIF" width="263" height="15" alt="Periodic photography (WATCH command)">
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Time interval</b></font></td>
<td width="297" height="30" valign="bottom">
<SELECT NAME="USER1_WATCH_HOUR">
<%USER1_WATCH_HOUR% VALUE="0">0 hour</OPTION>
<%USER1_WATCH_HOUR% VALUE="1">1 hour</OPTION>
<%USER1_WATCH_HOUR% VALUE="2">2 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="3">3 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="4">4 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="5">5 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="6">6 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="7">7 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="8">8 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="9">9 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="10">10 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="11">11 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="12">12 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="13">13 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="14">14 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="15">15 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="16">16 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="17">17 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="18">18 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="19">19 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="20">20 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="21">21 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="22">22 hours</OPTION>
<%USER1_WATCH_HOUR% VALUE="23">23 hours</OPTION>
</SELECT>
<SELECT NAME="USER1_WATCH_MIN">
<%USER1_WATCH_MIN% VALUE="0">0 minute</OPTION>
<%USER1_WATCH_MIN% VALUE="10">10 minutes</OPTION>
<%USER1_WATCH_MIN% VALUE="20">20 minutes</OPTION>
<%USER1_WATCH_MIN% VALUE="30">30 minutes</OPTION>
<%USER1_WATCH_MIN% VALUE="40">40 minutes</OPTION>
<%USER1_WATCH_MIN% VALUE="50">50 minutes</OPTION>
</SELECT>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Picture countdown</b></font></td>
<td width="297" height="30" valign="bottom">
<select name="USER1_WATCH_CUE">
<%USER1_WATCH_CUE% VALUE="C1">Countdown</OPTION>
<%USER1_WATCH_CUE% VALUE="C2">"Let's take a picture"</OPTION>
<%USER1_WATCH_CUE% VALUE="C3">"All Right, strike a pose"</OPTION>
<%USER1_WATCH_CUE% VALUE="C4">"Smile"</OPTION>
<%USER1_WATCH_CUE% VALUE="C5">"Show me some teeth!"</OPTION>
<%USER1_WATCH_CUE% VALUE="C6">"Show me your pearly whites!"</OPTION>
</select>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="35"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Neck angle</b></font></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Right to Left)</b></font></td>
<td width="80" valign="bottom"> 
<%USER1_WATCH_H%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Up and Down)</b></font></td>
<td width="80" valign="bottom"> 
<%USER1_WATCH_V%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
<table width="565" border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="54" width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td height="54"><img src="./IMG/BAR.GIF" width="522" height="7" alt=""></td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="545">
<tr>
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19"><img src="./IMG/C.GIF" width="19" height="17" alt=""></td>
<td width="186"><img src="./IMG/P01B.GIF" width="62" height="14" alt="User 2"></td>
<td width="297"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>E-mail address</b></font></td>
<td width="297" height="30" valign="bottom">
<%USER2_MAILADDR%>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Voice signature</b></font></td>
<td width="297" height="30" valign="bottom">
<select name="USER2_VOICESIG">
<%USER2_VOICESIG% VALUE="1">AIBO friend 1</OPTION>
<%USER2_VOICESIG% VALUE="2">AIBO friend 2</OPTION>
<%USER2_VOICESIG% VALUE="3">AIBO friend 3</OPTION>
<%USER2_VOICESIG% VALUE="4">AIBO friend 4</OPTION>
<%USER2_VOICESIG% VALUE="5">AIBO friend 5</OPTION>
<%USER2_VOICESIG% VALUE="6">Owner</OPTION>
<%USER2_VOICESIG% VALUE="7">Dad</OPTION>
<%USER2_VOICESIG% VALUE="8">Mom</OPTION>
<%USER2_VOICESIG% VALUE="9">Me</OPTION>
<%USER2_VOICESIG% VALUE="10">AIBO</OPTION>
<%USER2_VOICESIG% VALUE="11">User recording 1</OPTION>
<%USER2_VOICESIG% VALUE="12">User recording 2</OPTION>
<%USER2_VOICESIG% VALUE="13">User recording 3</OPTION>
<%USER2_VOICESIG% VALUE="14">User recording 4</OPTION>
<%USER2_VOICESIG% VALUE="15">User recording 5</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td colspan="2" height="30" valign="bottom"><img src="./IMG/P04.GIF" width="263" height="15" alt="Periodic photography (WATCH command)">
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Time interval</b></font></td>
<td width="297" height="30" valign="bottom">
<SELECT NAME="USER2_WATCH_HOUR">
<%USER2_WATCH_HOUR% VALUE="0">0 hour</OPTION>
<%USER2_WATCH_HOUR% VALUE="1">1 hour</OPTION>
<%USER2_WATCH_HOUR% VALUE="2">2 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="3">3 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="4">4 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="5">5 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="6">6 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="7">7 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="8">8 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="9">9 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="10">10 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="11">11 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="12">12 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="13">13 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="14">14 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="15">15 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="16">16 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="17">17 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="18">18 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="19">19 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="20">20 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="21">21 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="22">22 hours</OPTION>
<%USER2_WATCH_HOUR% VALUE="23">23 hours</OPTION>
</SELECT>
<SELECT NAME="USER2_WATCH_MIN">
<%USER2_WATCH_MIN% VALUE="0">0 minute</OPTION>
<%USER2_WATCH_MIN% VALUE="10">10 minutes</OPTION>
<%USER2_WATCH_MIN% VALUE="20">20 minutes</OPTION>
<%USER2_WATCH_MIN% VALUE="30">30 minutes</OPTION>
<%USER2_WATCH_MIN% VALUE="40">40 minutes</OPTION>
<%USER2_WATCH_MIN% VALUE="50">50 minutes</OPTION>
</SELECT>
</td>
</tr>
<tr>
<td width="43" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="29" valign="bottom"><font class="lb"><b>Picture countdown</b></font></td>
<td width="297" height="29" valign="bottom">
<SELECT NAME="USER2_WATCH_CUE">
<%USER2_WATCH_CUE% VALUE="C1">Countdown</OPTION>
<%USER2_WATCH_CUE% VALUE="C2">"Let's take a picture"</OPTION>
<%USER2_WATCH_CUE% VALUE="C3">"All Right, strike a pose"</OPTION>
<%USER2_WATCH_CUE% VALUE="C4">"Smile"</OPTION>
<%USER2_WATCH_CUE% VALUE="C5">"Show me some teeth!"</OPTION>
<%USER2_WATCH_CUE% VALUE="C6">"Show me your pearly whites!"</OPTION>
</select>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="35"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Neck angle</b></font></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Right to Left)</b></font></td>
<td width="80" valign="bottom"> 
<%USER2_WATCH_H%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Up and Down)</b></font></td>
<td width="80" valign="bottom"> 
<%USER2_WATCH_V%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
<table width="565" border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="54" width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td height="54"><img src="./IMG/BAR.GIF" width="522" height="7" alt=""></td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="545">
<tr>
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19"><img src="./IMG/C.GIF" width="19" height="17" alt=""></td>
<td width="186"><img src="./IMG/P01C.GIF" width="62" height="14" alt="User 3"></td>
<td width="297"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>E-mail address</b></font></td>
<td width="297" height="30" valign="bottom">
<%USER3_MAILADDR%>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Voice signature</b></font></td>
<td width="297" height="30" valign="bottom">
<select name="USER3_VOICESIG">
<%USER3_VOICESIG% VALUE="1">AIBO friend 1</OPTION>
<%USER3_VOICESIG% VALUE="2">AIBO friend 2</OPTION>
<%USER3_VOICESIG% VALUE="3">AIBO friend 3</OPTION>
<%USER3_VOICESIG% VALUE="4">AIBO friend 4</OPTION>
<%USER3_VOICESIG% VALUE="5">AIBO friend 5</OPTION>
<%USER3_VOICESIG% VALUE="6">Owner</OPTION>
<%USER3_VOICESIG% VALUE="7">Dad</OPTION>
<%USER3_VOICESIG% VALUE="8">Mom</OPTION>
<%USER3_VOICESIG% VALUE="9">Me</OPTION>
<%USER3_VOICESIG% VALUE="10">AIBO</OPTION>
<%USER3_VOICESIG% VALUE="11">User recording 1</OPTION>
<%USER3_VOICESIG% VALUE="12">User recording 2</OPTION>
<%USER3_VOICESIG% VALUE="13">User recording 3</OPTION>
<%USER3_VOICESIG% VALUE="14">User recording 4</OPTION>
<%USER3_VOICESIG% VALUE="15">User recording 5</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td colspan="2" height="30" valign="bottom"><img src="./IMG/P04.GIF" width="263" height="15" alt="Periodic photography (WATCH command)">
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Time interval</b></font></td>
<td width="297" height="30" valign="bottom">
<SELECT NAME="USER3_WATCH_HOUR">
<%USER3_WATCH_HOUR% VALUE="0">0 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="1">1 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="2">2 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="3">3 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="4">4 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="5">5 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="6">6 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="7">7 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="8">8 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="9">9 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="10">10 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="11">11 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="12">12 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="13">13 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="14">14 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="15">15 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="16">16 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="17">17 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="18">18 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="19">19 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="20">20 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="21">21 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="22">22 hours</OPTION>
<%USER3_WATCH_HOUR% VALUE="23">23 hours</OPTION>
</SELECT>
<SELECT NAME="USER3_WATCH_MIN">
<%USER3_WATCH_MIN% VALUE="0">0 minute</OPTION>
<%USER3_WATCH_MIN% VALUE="10">10 minutes</OPTION>
<%USER3_WATCH_MIN% VALUE="20">20 minutes</OPTION>
<%USER3_WATCH_MIN% VALUE="30">30 minutes</OPTION>
<%USER3_WATCH_MIN% VALUE="40">40 minutes</OPTION>
<%USER3_WATCH_MIN% VALUE="50">50 minutes</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="29" valign="bottom"><font class="lb"><b>Picture countdown</b></font></td>
<td width="297" height="29" valign="bottom">
<SELECT NAME="USER3_WATCH_CUE">
<%USER3_WATCH_CUE% VALUE="C1">Countdown</OPTION>
<%USER3_WATCH_CUE% VALUE="C2">"Let's take a picture"</OPTION>
<%USER3_WATCH_CUE% VALUE="C3">"All Right, strike a pose"</OPTION>
<%USER3_WATCH_CUE% VALUE="C4">"Smile"</OPTION>
<%USER3_WATCH_CUE% VALUE="C5">"Show me some teeth!"</OPTION>
<%USER3_WATCH_CUE% VALUE="C6">"Show me your pearly whites!"</OPTION>
</select>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="35"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Neck angle</b></font></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Right to Left)</b></font></td>
<td width="80" valign="bottom"> 
<%USER3_WATCH_H%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Up and Down)</b></font></td>
<td width="80" valign="bottom"> 
<%USER3_WATCH_V%>
</td>
</tr>
</table>
<td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
<table width="565" border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="54" width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td height="54"><img src="./IMG/BAR.GIF" width="522" height="7" alt=""></td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="545">
<tr>
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19"><img src="./IMG/C.GIF" width="19" height="17" alt=""></td>
<td width="186"><img src="./IMG/P01D.GIF" width="62" height="14" alt="User 4"></td>
<td width="297"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>E-mail address</b></font></td>
<td width="297" height="30" valign="bottom">
<%USER4_MAILADDR%>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Voice signature</b></font></td>
<td width="297" height="30" valign="bottom">
<select name="USER4_VOICESIG">
<%USER4_VOICESIG% VALUE="1">AIBO friend 1</OPTION>
<%USER4_VOICESIG% VALUE="2">AIBO friend 2</OPTION>
<%USER4_VOICESIG% VALUE="3">AIBO friend 3</OPTION>
<%USER4_VOICESIG% VALUE="4">AIBO friend 4</OPTION>
<%USER4_VOICESIG% VALUE="5">AIBO friend 5</OPTION>
<%USER4_VOICESIG% VALUE="6">Owner</OPTION>
<%USER4_VOICESIG% VALUE="7">Dad</OPTION>
<%USER4_VOICESIG% VALUE="8">Mom</OPTION>
<%USER4_VOICESIG% VALUE="9">Me</OPTION>
<%USER4_VOICESIG% VALUE="10">AIBO</OPTION>
<%USER4_VOICESIG% VALUE="11">User recording 1</OPTION>
<%USER4_VOICESIG% VALUE="12">User recording 2</OPTION>
<%USER4_VOICESIG% VALUE="13">User recording 3</OPTION>
<%USER4_VOICESIG% VALUE="14">User recording 4</OPTION>
<%USER4_VOICESIG% VALUE="15">User recording 5</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td colspan="2" height="30" valign="bottom"><img src="./IMG/P04.GIF" width="263" height="15" alt="Periodic photography (WATCH command)"></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Time interval</b></font></td>
<td width="297" height="30" valign="bottom">
<SELECT NAME="USER4_WATCH_HOUR">
<%USER4_WATCH_HOUR% VALUE="0">0 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="1">1 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="2">2 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="3">3 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="4">4 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="5">5 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="6">6 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="7">7 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="8">8 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="9">9 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="10">10 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="11">11 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="12">12 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="13">13 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="14">14 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="15">15 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="16">16 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="17">17 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="18">18 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="19">19 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="20">20 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="21">21 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="22">22 hours</OPTION>
<%USER4_WATCH_HOUR% VALUE="23">23 hours</OPTION>
</SELECT>
<SELECT NAME="USER4_WATCH_MIN">
<%USER4_WATCH_MIN% VALUE="0">0 minute</OPTION>
<%USER4_WATCH_MIN% VALUE="10">10 minutes</OPTION>
<%USER4_WATCH_MIN% VALUE="20">20 minutes</OPTION>
<%USER4_WATCH_MIN% VALUE="30">30 minutes</OPTION>
<%USER4_WATCH_MIN% VALUE="40">40 minutes</OPTION>
<%USER4_WATCH_MIN% VALUE="50">50 minutes</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="29" valign="bottom"><font class="lb"><b>Picture countdown</b></font></td>
<td width="297" height="29" valign="bottom">
<SELECT NAME="USER4_WATCH_CUE">
<%USER4_WATCH_CUE% VALUE="C1">Countdown</OPTION>
<%USER4_WATCH_CUE% VALUE="C2">"Let's take a picture"</OPTION>
<%USER4_WATCH_CUE% VALUE="C3">"All Right, strike a pose"</OPTION>
<%USER4_WATCH_CUE% VALUE="C4">"Smile"</OPTION>
<%USER4_WATCH_CUE% VALUE="C5">"Show me some teeth!"</OPTION>
<%USER4_WATCH_CUE% VALUE="C6">"Show me your pearly whites!"</OPTION>
</select>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="35"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Neck angle</b></font></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Right to Left)</b></font></td>
<td width="80" valign="bottom"> 
<%USER4_WATCH_H%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Up and Down)</b></font></td>
<td width="80" valign="bottom"> 
<%USER4_WATCH_V%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
<table width="565" border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="54" width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td height="54"><img src="./IMG/BAR.GIF" width="522" height="7" alt=""></td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="545">
<tr>
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19"><img src="./IMG/C.GIF" width="19" height="17" alt=""></td>
<td width="186"><img src="./IMG/P01E.GIF" width="62" height="14" alt="User 5"></td>
<td width="297"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>E-mail address</b></font></td>
<td width="297" height="30" valign="bottom">
<%USER5_MAILADDR%>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Voice signature</b></font></td>
<td width="297" height="30" valign="bottom">
<select name="USER5_VOICESIG">
<%USER5_VOICESIG% VALUE="1">AIBO friend 1</OPTION>
<%USER5_VOICESIG% VALUE="2">AIBO friend 2</OPTION>
<%USER5_VOICESIG% VALUE="3">AIBO friend 3</OPTION>
<%USER5_VOICESIG% VALUE="4">AIBO friend 4</OPTION>
<%USER5_VOICESIG% VALUE="5">AIBO friend 5</OPTION>
<%USER5_VOICESIG% VALUE="6">Owner</OPTION>
<%USER5_VOICESIG% VALUE="7">Dad</OPTION>
<%USER5_VOICESIG% VALUE="8">Mom</OPTION>
<%USER5_VOICESIG% VALUE="9">Me</OPTION>
<%USER5_VOICESIG% VALUE="10">AIBO</OPTION>
<%USER5_VOICESIG% VALUE="11">User recording 1</OPTION>
<%USER5_VOICESIG% VALUE="12">User recording 2</OPTION>
<%USER5_VOICESIG% VALUE="13">User recording 3</OPTION>
<%USER5_VOICESIG% VALUE="14">User recording 4</OPTION>
<%USER5_VOICESIG% VALUE="15">User recording 5</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td colspan="2" height="30" valign="bottom"><img src="./IMG/P04.GIF" width="263" height="15" alt="Periodic photography (WATCH command)">
</td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Time interval</b></font></td>
<td width="297" height="30" valign="bottom">
<SELECT NAME="USER5_WATCH_HOUR">
<%USER5_WATCH_HOUR% VALUE="0">0 hour</OPTION>
<%USER5_WATCH_HOUR% VALUE="1">1 hour</OPTION>
<%USER5_WATCH_HOUR% VALUE="2">2 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="3">3 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="4">4 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="5">5 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="6">6 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="7">7 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="8">8 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="9">9 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="10">10 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="11">11 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="12">12 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="13">13 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="14">14 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="15">15 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="16">16 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="17">17 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="18">18 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="19">19 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="20">20 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="21">21 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="22">22 hours</OPTION>
<%USER5_WATCH_HOUR% VALUE="23">23 hours</OPTION>
</SELECT>
<SELECT NAME="USER5_WATCH_MIN">
<%USER5_WATCH_MIN% VALUE="0">0 minute</OPTION>
<%USER5_WATCH_MIN% VALUE="10">10 minutes</OPTION>
<%USER5_WATCH_MIN% VALUE="20">20 minutes</OPTION>
<%USER5_WATCH_MIN% VALUE="30">30 minutes</OPTION>
<%USER5_WATCH_MIN% VALUE="40">40 minutes</OPTION>
<%USER5_WATCH_MIN% VALUE="50">50 minutes</OPTION>
</select>
</td>
</tr>
<tr>
<td width="43" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="29"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="29" valign="bottom"><font class="lb"><b>Picture countdown</b></font></td>
<td width="297" height="29" valign="bottom">
<SELECT NAME="USER5_WATCH_CUE">
<%USER5_WATCH_CUE% VALUE="C1">Countdown</OPTION>
<%USER5_WATCH_CUE% VALUE="C2">"Let's take a picture"</OPTION>
<%USER5_WATCH_CUE% VALUE="C3">"All Right, strike a pose"</OPTION>
<%USER5_WATCH_CUE% VALUE="C4">"Smile"</OPTION>
<%USER5_WATCH_CUE% VALUE="C5">"Show me some teeth!"</OPTION>
<%USER5_WATCH_CUE% VALUE="C6">"Show me your pearly whites!"</OPTION>
</select>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="35"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><font class="lb"><b>Neck angle</b></font></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Right to Left)</b></font></td>
<td width="80" valign="bottom"> 
<%USER5_WATCH_H%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr>
<td width="43" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="19" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="186" height="30" valign="bottom"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="317" height="30" valign="bottom">
<table width="200" border="0" cellspacing="0" cellpadding="0" height="30">
<tr>
<td width="120" valign="bottom"><font class="lb"><b>(Up and Down)</b></font></td>
<td width="80" valign="bottom"> 
<%USER5_WATCH_V%>
</td>
</tr>
</table>
</td>
<td width="15" height="30"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
</table>
<table width="565" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td height="54" width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td height="54"><img src="./IMG/BAR.GIF" width="522" height="7" alt=""></td>
</tr>
</table>
<table width="565" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td align="center" width="522">
<input type="submit" value="Save" style="width: 70; height: 22">
</td>
</tr>
</table>
<table width="487" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td width="43" height="40"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="295" height="4"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
</tr>
<tr> 
<td width="43"><img src="../IMG/COMMON/SPACE.GIF" width="1" height="1" alt=""></td>
<td width="444"><img src="../IMG/COMMON/FOOTER.GIF" width="444" height="39" alt="Copyright 2003-2004 Sony Corporation"></td>
</tr>
</table>
</form>
<map name="Map2"> 
<area shape="rect" coords="10,39,156,54" href="../INDEX.HTM" alt="Return to the top page" title="Return to the top page">
</map>
<map name="Map4">
<area shape="rect" coords="12,0,146,16" href="./AMOWNER.FRM" alt="Mail Setup" title="Mail Setup">
</map>
<map name="Map5">
<area shape="rect" coords="12,0,146,15" href="./AMNWSTAT.FRM" alt="Connection Check" title="Connection Check">
</map></body>
</html>
