<%@page import="java.net.InetAddress"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE>Session Clustering Test</TITLE>


<script>
    (function(j,ennifer) {
        j['dmndata']=[];j['jenniferFront']=function(args){window.dmndata.push(args)};
        j['dmnaid']=ennifer;j['dmnatime']=new Date();j['dmnanocookie']=false;j['dmnajennifer']='JENNIFER_FRONT@INTG';
    }(window, 'f92bcee4'));
</script>
<script async src="https://d-collect.jennifersoft.com/f92bcee4/demian.js"></script>


<script type="text/javascript">
	function showClock() {
		var currentDate = new Date();
		var divClock = document.getElementById('divClock');
		var toClock = document.getElementById('toClock');
		var msg = "현재 시간 : ";
		if (currentDate.getHours() > 12) { //시간이 12보다 크다면 오후 아니면 오전
			msg += "오후 ";
			msg += currentDate.getHours() - 12 + "시 ";
		} else {
			msg += "오전 ";
			msg += currentDate.getHours() + "시 ";
		}

		msg += currentDate.getMinutes() + "분 ";
		msg += currentDate.getSeconds() + "초";

		divClock.innerText = msg;

		if (currentDate.getMinutes() > 58) { //정각 1분전부터 빨강색으로 출력
			divClock.style.color = "red";
		}
		setTimeout(showClock, 1000); //1초마다 갱신
	}

	function setSessionTimeReset() {
		var link = "./session.jsp";
		location.href = link;

	}
	function setSessionTime() {
		var sessionTime = document.getElementById("sessionTime").value;
		if (sessionTime != null && sessionTime.length > 0) {
			var link = "./session.jsp?sessionTime=" + sessionTime;
			location.href = link;
		}
	}

	function reload() {
		location.reload();
	}
</script>
</head>

</head>
<body onload="showClock()">
	<div id="divClock"></div>

	<h1>Session Clustering Test</h1>
	<%
		//세션 타임아웃값을 강제로 설정할 수 있다.
		// http://~/session.jsp?sesstionTime=5
		String customSessionTimeout = (String) request.getParameter("sessionTime");
		if (customSessionTimeout == null || customSessionTimeout.length() < 1) {
			customSessionTimeout = null;
		}

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		HttpSession sess = request.getSession();

		System.out.println("customSessionTimeout=" + customSessionTimeout);
		//세션 타임아웃 시간 강제 설정(sec)
		if (customSessionTimeout != null) {
			int timeout = Integer.parseInt(customSessionTimeout);
			sess.setMaxInactiveInterval(timeout);
		}
		// 		sess.setMaxInactiveInterval(6);

		//세션 데이터 가져오기
		long ssCreateTime = sess.getCreationTime();
		long ssLastAccessedTime = sess.getLastAccessedTime();
		String ssGetId = sess.getId();
		int ssMaxInactiveInterval = sess.getMaxInactiveInterval();

		//값 변환 작업
		//세션 타임아웃될 시간 구하기
		long v1 = ssLastAccessedTime;
		long v2 = Long.valueOf(1000 * ssMaxInactiveInterval);

		//세션 ID값 가져오기
		String getId1 = ssGetId.substring(0, ssGetId.length() - 4);
		String getId2 = ssGetId.substring(ssGetId.length() - 4, ssGetId.length());
		// 		System.out.println(getId1 + "-"+ getId2);


		String sessionCreateTime = sdf.format(new Date(ssCreateTime));
		String lastAccessedTime = sdf.format(new Date(ssLastAccessedTime));
		String expiredSessionTime = sdf
				.format(new Date(ssLastAccessedTime + Long.valueOf(1000 * ssMaxInactiveInterval)));

		//처리된서버 정보 가져오기
		InetAddress inet = InetAddress.getLocalHost();
		String hostName = inet.getHostName();
		String hostAddr = inet.getHostAddress();
		//

		//JVM properties정보 가져오기
		Properties props = System.getProperties();
		Enumeration enumm = props.keys();
		
		//

		Integer ival = (Integer) session.getAttribute("_session_counter");
		if (ival == null) {
			ival = new Integer(1);
		} else {
			ival = new Integer(ival.intValue() + 1);
		}
		session.setAttribute("_session_counter", ival);
		System.out.println("here~~~~");
	%>
	Session Counter = [
	<b> <%=ival%>
	</b>]
	<p>
		<button type="button" onclick="reload();">[Reload]</button>
	<p>
	<table border="1" width="100%">
		<tr>
			<th>처리된 서버 HostName</th>
			<td><%=hostName%></td>
		</tr>
		<tr>
			<th>처리된 서버 HostAddress</th>
			<td><%=hostAddr%></td>
		</tr>
		<tr>
			<th>현재 세션 ID</th>
			<td><%=getId1%><font color="red"><b><%=getId2%></b></font></td>
		</tr>
		<tr>
			<th>세션 생성시간</th>
			<td><%=sessionCreateTime%></td>
		</tr>
		<tr>
			<th>세션 마지막 Access 시간</th>
			<td><%=lastAccessedTime%></td>
		</tr>
		<tr>
			<th>세션 타임아웃 설정값(sec)</th>
			<td><%=ssMaxInactiveInterval%>초 (<%=ssMaxInactiveInterval / 60%>분)</td>
		</tr>
		<tr>
			<th>세션 타임아웃될 시간</th>
			<td><%=expiredSessionTime%></td>
		</tr>
		<tr>
			<th>세션 타임아웃될 시간 jsp에서 강제설정(초)</th>
			<td><input type="number" id="sessionTime"
				value="<%=customSessionTimeout%>">
				<button type="button" onclick="setSessionTime();">설정</button>
				<button type="button" onclick="setSessionTimeReset();">초기화</button>
			</td>
		</tr>
	</table>

	<br><br>

	<table border="1" width="100%">
		<%
		while (enumm.hasMoreElements()) {
			String key = (String) enumm.nextElement();
			String val = (String) props.get(key);
			
			%>
			<tr>
				<th ><%=key %></th>
				<td style="word-break:break-all"><%=val %></td>
			</tr>
			<%
		}
		%>
		<tr>
		</tr>
	</table>


</body>
</html>
