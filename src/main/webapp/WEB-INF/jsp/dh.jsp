<%@ page import="de.wolff.springcampus.dh.servlet.DhKeyExchangeServlet.DhAction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dh.css">
    <title>${role.label} - Diffie-Hellman Key Exchange Demo - CERN Spring Campus 2016</title>
</head>
<body>
    <h3 class="dh-title">Hello ${role.label}!</h3>

    <c:choose>
        <c:when test="${role.isAlice}">
            <!-- Alice -->
            <form action="${role}" method="post" class="dh-form">
                <input type="hidden" name="action" value="<%=DhAction.generate_p_and_g%>">
                <fieldset>
                    <legend class="dh-form__title">Step 1: Generate public P and G</legend>
                    <div class="dh-form__body">
                        <div class="dh-form__input-body">
                            <div class="dh-form__input-row">
                                <label for="p_input" class="dh-form__label dh-form__label--step-1">P:</label>
                                <input type="text" class="dh-form__input" readonly id="p_input" name="p" value="${dh.p}">
                            </div>
                            <div class="dh-form__input-row">
                                <label for="g_input" class="dh-form__label dh-form__label--step-1">G:</label>
                                <input type="text" class="dh-form__input" readonly id="g_input" name="g" value="${dh.g}">
                            </div>
                            <c:if test="${empty dh.p}">
                                <div class="dh-form__input-row"><input type="submit" value="Generate" class="dh-form__submit"></div>
                            </c:if>
                        </div>
                        <div class="dh-form__img-body">
                            <img src="${pageContext.request.contextPath}/img/common_colour.png" class="dh-form__img">
                            <span class="dh-form__img-label">Common paint</span>
                        </div>
                    </div>
                </fieldset>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Bob -->
            <form action="${role}" method="post" class="dh-form">
                <input type="hidden" name="action" value="<%=DhAction.set_p_and_g%>">
                <fieldset>
                    <legend class="dh-form__title">Step 1: Set public P and G received from Alice</legend>
                    <div class="dh-form__body">
                        <div class="dh-form__input-body">
                            <div class="dh-form__input-row">
                                <label for="p_input" class="dh-form__label dh-form__label--step-1">P:</label>
                                <input type="number" class="dh-form__input" required id="p_input" name="p" value="${dh.p}">
                            </div>
                            <div class="dh-form__input-row">
                                <label for="g_input" class="dh-form__label dh-form__label--step-1">G:</label>
                                <input type="number" class="dh-form__input" required id="g_input" name="g" value="${dh.g}">
                            </div>
                            <c:if test="${empty dh.p}">
                                <div class="dh-form__input-row"><input type="submit" value="Set" class="dh-form__submit"></div>
                            </c:if>
                        </div>
                        <div class="dh-form__img-body">
                            <img src="${pageContext.request.contextPath}/img/common_colour.png" class="dh-form__img">
                            <span class="dh-form__img-label">Common paint</span>
                        </div>
                    </div>
                </fieldset>
            </form>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty dh.p}">
        <form action="${role}" method="post" class="dh-form">
            <input type="hidden" name="action" value="<%=DhAction.generate_x%>">
            <fieldset>
                <legend class="dh-form__title">Step 2: Generate secret <c:out value="${role.isAlice ? 'A' : 'B'}"/></legend>
                <div class="dh-form__body">
                    <div class="dh-form__input-body">
                        <div class="dh-form__input-row">
                            <label for="x_input" class="dh-form__label dh-form__label--step-2"><c:out value="${role.isAlice ? 'A' : 'B'}"/>:</label>
                            <input type="text" class="dh-form__input" readonly id="x_input" name="x" value="${dh.x}">
                        </div>
                        <c:if test="${empty dh.x}">
                            <div class="dh-form__input-row"><input type="submit" value="Generate" class="dh-form__submit"></div>
                        </c:if>
                    </div>
                    <div class="dh-form__img-body">
                        <img src="${pageContext.request.contextPath}/img/${role.isAlice ? 'secret_colour_alice' : 'secret_colour_bob'}.png" class="dh-form__img">
                        <span class="dh-form__img-label">Secret colour of <c:out value="${role.label}"/></span>
                    </div>
                </div>
            </fieldset>
        </form>
    </c:if>

    <c:if test="${not empty dh.x}">
        <form action="${role}" method="post" class="dh-form">
            <input type="hidden" name="action" value="<%=DhAction.calculate_gx%>">
            <fieldset>
                <legend class="dh-form__title">Step 3: Calculate public <c:out value="${role.isAlice ? 'Xa = G^A mod P' : 'Xb = G^B mod P'}"/></legend>
                <div class="dh-form__body">
                    <div class="dh-form__input-body">
                        <div class="dh-form__input-row">
                            <label for="gx_input" class="dh-form__label dh-form__label--step-3"><c:out value="${role.isAlice ? 'Xa' : 'Xb'}"/>:</label>
                            <input type="text" class="dh-form__input" readonly id="gx_input" name="gx" value="${dh.gx}">
                        </div>
                        <c:if test="${empty dh.gx}">
                            <div class="dh-form__input-row"><input type="submit" value="Calculate" class="dh-form__submit"></div>
                        </c:if>
                    </div>
                    <div class="dh-form__img-body">
                        <img src="${pageContext.request.contextPath}/img/${role.isAlice ? 'mixed_colour_alice' : 'mixed_colour_bob'}.png" class="dh-form__img">
                        <span class="dh-form__img-label">Mixed colour of <c:out value="${role.label}"/></span>
                    </div>
                </div>
            </fieldset>
        </form>
    </c:if>

    <c:if test="${not empty dh.gx}">
        <form action="${role}" method="post" class="dh-form">
            <input type="hidden" name="action" value="<%=DhAction.set_gx_of_other%>">
            <fieldset>
                <legend class="dh-form__title">Step 4: Enter the value for <c:out value="${role.isAlice ? 'Xb received from Bob' : 'Xa received from Alice'}"/></legend>
                <div class="dh-form__body">
                    <div class="dh-form__input-body">
                        <div class="dh-form__input-row">
                            <label for="gx_other_input" class="dh-form__label dh-form__label--step-4"><c:out value="${role.isAlice ? 'Xb' : 'Xa'}"/>:</label>
                            <input type="number" class="dh-form__input" <c:out value="${empty dh.gxOther ? 'required ' : 'readonly'}"/> id="gx_other_input" name="gx_other" value="${dh.gxOther}">
                        </div>
                        <c:if test="${empty dh.gxOther}">
                            <div class="dh-form__input-row"><input type="submit" value="Set" class="dh-form__submit"></div>
                        </c:if>
                    </div>
                    <div class="dh-form__img-body">
                        <img src="${pageContext.request.contextPath}/img/${role.isAlice ? 'mixed_colour_bob' : 'mixed_colour_alice'}.png" class="dh-form__img">
                        <span class="dh-form__img-label">Mixed colour received from <c:out value="${role.isAlice ? 'Bob' : 'Alice'}"/></span>
                    </div>
                </div>
            </fieldset>
        </form>
    </c:if>
    
    <c:if test="${not empty dh.gxOther}">
        <form action="${role}" method="post" class="dh-form">
            <input type="hidden" name="action" value="<%=DhAction.calculate_k%>">
            <fieldset>
                <legend class="dh-form__title">Step 5: Calculate the shared secret key K</legend>
                <div class="dh-form__body">
                    <div class="dh-form__input-body">
                        <div class="dh-form__input-row">
                            <label for="k_input" class="dh-form__label dh-form__label--step-5">Secret Key:</label>
                            <input type="text" class="dh-form__input" readonly id="k_input" name="k" value="${dh.k}">
                        </div>
                        <div class="dh-form__input-row">
                            <label for="padlock_code_input" class="dh-form__label dh-form__label--step-5 dh-form__label--strong">Padlock Code:</label>
                            <input type="text" class="dh-form__input" readonly id="padlock_code_input" name="padlock_code" value="${dh.padlockCodeAsString}">
                        </div>
                        <c:if test="${empty dh.k}">
                            <div class="dh-form__input-row"><input type="submit" value="Calculate" class="dh-form__submit"></div>
                        </c:if>
                    </div>
                    <div class="dh-form__img-body">
                        <img src="${pageContext.request.contextPath}/img/shared_colour.png" class="dh-form__img">
                        <span class="dh-form__img-label">Shared secret colour</span>
                    </div>
                </div>
            </fieldset>
        </form>
    </c:if>

    <form action="${role}" method="post" class="dh-form">
        <input type="hidden" name="action" value="<%=DhAction.reset%>">
        <div><input type="submit" value="Reset" class="dh-form__submit"></div>
    </form>
</body>
</html>