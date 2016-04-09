<%@ page import="de.wolff.springcampus.dh.servlet.DhKeyExchangeServlet.DhAction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="/css/dh.css">
    <title>${role.label} - Diffie-Hellman Key Exchange Demo - CERN Spring Campus 2016</title>
</head>
<body>
    <h3>Hello ${role.label}!</h3>

    <c:choose>
        <c:when test="${role.isAlice}">
            <!-- Alice -->
            <form action="${role}" method="post">
                <input type="hidden" name="action" value="<%=DhAction.generate_p_and_g%>">
                <fieldset>
                    <legend>Step 1: Generate public P and G</legend>
                    <label>P:</label> <input type="text" readonly id="p_input" name="p" value="${dh.p}"><br>
                    <label>G:</label> <input type="text" readonly id="g_input" name="g" value="${dh.g}"><br>
                    <input type="submit" value="Generate">
                </fieldset>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Bob -->
            <form action="${role}" method="post">
                <input type="hidden" name="action" value="<%=DhAction.set_p_and_g%>">
                <fieldset>
                    <legend>Step 1: Set public P and G received from Alice</legend>
                    <label>P:</label> <input type="number" required id="p_input" name="p" value="${dh.p}"><br>
                    <label>G:</label> <input type="number" required id="g_input" name="g" value="${dh.g}"><br>
                    <input type="submit" value="Set">
                </fieldset>
            </form>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty dh.p}">
        <form action="${role}" method="post">
            <input type="hidden" name="action" value="<%=DhAction.generate_x%>">
            <fieldset>
                <legend>Step 2: Generate secret <c:out value="${role.isAlice ? 'A' : 'B'}"/></legend>
                <label><c:out value="${role.isAlice ? 'A' : 'B'}"/>:</label> <input type="text" readonly id="x_input" name="x" value="${dh.x}"><br>
                <input type="submit" value="Generate">
            </fieldset>
        </form>
    </c:if>

    <c:if test="${not empty dh.x}">
        <form action="${role}" method="post">
            <input type="hidden" name="action" value="<%=DhAction.calculate_gx%>">
            <fieldset>
                <legend>Step 3: Calculate public <c:out value="${role.isAlice ? 'Xa = G^A mod P' : 'Xb = G^B mod P'}"/></legend>
                <label><c:out value="${role.isAlice ? 'Xa' : 'Xb'}"/>:</label> <input type="text" readonly id="gx_input" name="gx" value="${dh.gx}"><br>
                <input type="submit" value="Calculate">
            </fieldset>
        </form>
    </c:if>

    <c:if test="${not empty dh.gx}">
        <form action="${role}" method="post">
            <input type="hidden" name="action" value="<%=DhAction.set_gx_of_other%>">
            <fieldset>
                <legend>Step 4: Enter the value for <c:out value="${role.isAlice ? 'Xb received from Bob' : 'Xa received from Alice'}"/></legend>
                <label><c:out value="${role.isAlice ? 'Xb of Bob' : 'Xa of Alice'}"/>:</label> <input type="number" required id="gx_other_input" name="gx_other" value="${dh.gxOther}"><br>
                <input type="submit" value="Set">
            </fieldset>
        </form>
    </c:if>
    
    <c:if test="${not empty dh.gxOther}">
        <form action="${role}" method="post">
            <input type="hidden" name="action" value="<%=DhAction.calculate_k%>">
            <fieldset>
                <legend>Step 5: Calculate the secret key K</legend>
                <label>Secret Key:</label> <input type="text" readonly id="k_input" name="k" value="${dh.k}"><br>
                <label><b>Padlock Code:</b></label> <input type="text" readonly id="padlock_code_input" name="padlock_code" value="${dh.padlockCodeAsString}"><br>
                <input type="submit" value="Calculate">
            </fieldset>
        </form>
    </c:if>

    <form action="${role}" method="post">
        <input type="hidden" name="action" value="<%=DhAction.reset%>">
        <input type="submit" value="Reset">
    </form>
</body>
</html>