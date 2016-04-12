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
            <form action="${role}" method="post" class="dh_form">
                <input type="hidden" name="action" value="<%=DhAction.generate_p_and_g%>">
                <fieldset>
                    <legend>Step 1: Generate public P and G</legend>
                    <div><label for="p_input" style="width: 1.2em;">P:</label><input type="text" readonly id="p_input" name="p" value="${dh.p}"></div>
                    <div><label for="g_input" style="width: 1.2em;">G:</label><input type="text" readonly id="g_input" name="g" value="${dh.g}"></div>
                    <c:if test="${empty dh.p}">
                        <div><input type="submit" value="Generate"></div>
                    </c:if>
                </fieldset>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Bob -->
            <form action="${role}" method="post" class="dh_form">
                <input type="hidden" name="action" value="<%=DhAction.set_p_and_g%>">
                <fieldset>
                    <legend>Step 1: Set public P and G received from Alice</legend>
                    <div><label for="p_input" style="width: 1.2em;">P:</label><input type="number" required id="p_input" name="p" value="${dh.p}"></div>
                    <div><label for="g_input" style="width: 1.2em;">G:</label><input type="number" required id="g_input" name="g" value="${dh.g}"></div>
                    <c:if test="${empty dh.p}">
                        <div><input type="submit" value="Set"></div>
                    </c:if>
                </fieldset>
            </form>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty dh.p}">
        <form action="${role}" method="post" class="dh_form">
            <input type="hidden" name="action" value="<%=DhAction.generate_x%>">
            <fieldset>
                <legend>Step 2: Generate secret <c:out value="${role.isAlice ? 'A' : 'B'}"/></legend>
                <div><label for="x_input"><c:out value="${role.isAlice ? 'A' : 'B'}"/>:</label><input type="text" readonly id="x_input" name="x" value="${dh.x}">
                    <span><strong>!!! KEEP SECRET !!!</strong></span></div>
                <c:if test="${empty dh.x}">
                    <div><input type="submit" value="Generate"></div>
                </c:if>
            </fieldset>
        </form>
    </c:if>

    <c:if test="${not empty dh.x}">
        <form action="${role}" method="post" class="dh_form">
            <input type="hidden" name="action" value="<%=DhAction.calculate_gx%>">
            <fieldset>
                <legend>Step 3: Calculate public <c:out value="${role.isAlice ? 'Xa = G^A mod P' : 'Xb = G^B mod P'}"/></legend>
                <div><label for="gx_input"><c:out value="${role.isAlice ? 'Xa' : 'Xb'}"/>:</label><input type="text" readonly id="gx_input" name="gx" value="${dh.gx}">
                    <span>Tell this to <c:out value="${role.isAlice ? 'Bob' : 'Alice'}"/></span></div>
                <c:if test="${empty dh.gx}">
                    <div><input type="submit" value="Calculate"></div>
                </c:if>
            </fieldset>
        </form>
    </c:if>

    <c:if test="${not empty dh.gx}">
        <form action="${role}" method="post" class="dh_form">
            <input type="hidden" name="action" value="<%=DhAction.set_gx_of_other%>">
            <fieldset>
                <legend>Step 4: Enter the value for <c:out value="${role.isAlice ? 'Xb received from Bob' : 'Xa received from Alice'}"/></legend>
                <div><label for="gx_other_input"><c:out value="${role.isAlice ? 'Xb of Bob' : 'Xa of Alice'}"/>:</label><input type="number" <c:out value="${empty dh.gxOther ? 'required ' : 'readonly'}"/> id="gx_other_input" name="gx_other" value="${dh.gxOther}"></div>
                <c:if test="${empty dh.gxOther}">
                    <div><input type="submit" value="Set"></div>
                </c:if>
            </fieldset>
        </form>
    </c:if>
    
    <c:if test="${not empty dh.gxOther}">
        <form action="${role}" method="post" class="dh_form">
            <input type="hidden" name="action" value="<%=DhAction.calculate_k%>">
            <fieldset>
                <legend>Step 5: Calculate the shared secret key K</legend>
                <div><label for="k_input" style="width: 8.5em;">Secret Key:</label><input type="text" readonly id="k_input" name="k" value="${dh.k}"> <span><strong>!!! KEEP SECRET !!!</strong></span></div>
                <div><label for="padlock_code_input" style="width: 8.5em;"><strong>Padlock Code:</strong></label><input type="text" readonly id="padlock_code_input" name="padlock_code" value="${dh.padlockCodeAsString}">
                    <span><strong>!!! KEEP SECRET !!!</strong></span></div>
                <c:if test="${empty dh.k}">
                    <div><input type="submit" value="Calculate"></div>
                </c:if>
            </fieldset>
        </form>
    </c:if>

    <form action="${role}" method="post" class="dh_form">
        <input type="hidden" name="action" value="<%=DhAction.reset%>">
        <div><input type="submit" value="Reset"></div>
    </form>
</body>
</html>