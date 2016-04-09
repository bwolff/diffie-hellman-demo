package de.wolff.springcampus.dh.servlet;

import java.io.IOException;
import java.math.BigInteger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import de.wolff.springcampus.dh.engine.DhKeyExchange;


public abstract class DhKeyExchangeServlet extends HttpServlet {

    public enum DhRole {
        alice("Alice"), bob("Bob");

        private final String label;

        private DhRole(String label) {
            this.label = label;
        }

        public String getLabel() {
            return label;
        }

        public boolean getIsAlice() {
            // This is a small helper method for usage in the JSP.
            return this == alice;
        }
    }

    public enum DhAction {
        generate_p_and_g, set_p_and_g, generate_x, calculate_gx, set_gx_of_other, calculate_k, reset
    }

    private final ThreadLocal<HttpServletRequest> currentRequest = new ThreadLocal<HttpServletRequest>();
    private final ThreadLocal<HttpServletResponse> currentResponse = new ThreadLocal<HttpServletResponse>();
    private final ThreadLocal<DhKeyExchange> currentDhKeyExchange = new ThreadLocal<DhKeyExchange>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            initializeCurrentRequest(request, response);
            populatePageContext();
            renderDhJsp();
        } finally {
            clearCurrentRequest();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            initializeCurrentRequest(request, response);
            processDhAction();
            populatePageContext();

            // Send a redirect instead of directly rendering the JSP in the response. This is done
            // to
            // avoid the "resend data?" dialog when doing a refresh of the page.
            redirectToDhJsp();
        } finally {
            clearCurrentRequest();
        }
    }

    private void initializeCurrentRequest(HttpServletRequest request, HttpServletResponse response) {
        currentRequest.set(request);
        currentResponse.set(response);
        currentDhKeyExchange.set(getOrInitializeDhKeyExchange());
    }

    private void clearCurrentRequest() {
        currentRequest.remove();
        currentResponse.remove();
        currentDhKeyExchange.remove();
    }

    private DhKeyExchange getOrInitializeDhKeyExchange() {
        // The DH exchange instance is stored in the session with the current role (alice or bob) as
        // the key. This allows to do a key exchange in the same browser using the same session,
        // e.g. with two tabs.
        DhKeyExchange dh = (DhKeyExchange) getCurrentSession().getAttribute(getRole().name());

        if (dh == null) {
            dh = new DhKeyExchange();
            getCurrentSession().setAttribute(getRole().name(), dh);
        }

        return dh;
    }

    protected abstract DhRole getRole();

    private void populatePageContext() {
        HttpServletRequest request = getCurrentRequest();
        request.setAttribute("role", getRole());
        request.setAttribute("dh", getCurrentDhKeyExchange());
    }

    private void processDhAction() {
        DhAction action = getRequestedAction();

        // Yes, yes, this switch statement here is really ugly! I agree, but it can be blamed on to
        // time pressure ;).
        switch (action) {
            case generate_p_and_g:
                getCurrentDhKeyExchange().generateValuesForPandG();
                break;
            case set_p_and_g:
                setPandG();
                break;
            case generate_x:
                getCurrentDhKeyExchange().generateValueForX();
                break;
            case calculate_gx:
                getCurrentDhKeyExchange().calculateGx();
                break;
            case set_gx_of_other:
                setGxOfOther();
                break;
            case calculate_k:
                getCurrentDhKeyExchange().calculateK();
                break;
            case reset:
                getCurrentDhKeyExchange().reset();
                break;
            default:
                throw new IllegalArgumentException("Unsupported action: " + action);
        }
    }

    private DhAction getRequestedAction() {
        return DhAction.valueOf(currentRequest.get().getParameter("action"));
    }

    private void setPandG() {
        BigInteger p = new BigInteger(getCurrentRequest().getParameter("p"));
        BigInteger g = new BigInteger(getCurrentRequest().getParameter("g"));
        getCurrentDhKeyExchange().setValuesForPandG(p, g);
    }

    private void setGxOfOther() {
        BigInteger gxOther = new BigInteger(getCurrentRequest().getParameter("gx_other"));
        getCurrentDhKeyExchange().setGxOther(gxOther);
    }

    private void renderDhJsp() throws ServletException, IOException {
        HttpServletRequest request = getCurrentRequest();
        HttpServletResponse response = getCurrentResponse();
        request.getRequestDispatcher("/WEB-INF/jsp/dh.jsp").forward(request, response);
    }

    private void redirectToDhJsp() throws IOException {
        getCurrentResponse().sendRedirect("/" + getRole().name());
    }

    private HttpServletRequest getCurrentRequest() {
        return currentRequest.get();
    }

    private HttpServletResponse getCurrentResponse() {
        return currentResponse.get();
    }

    private HttpSession getCurrentSession() {
        return currentRequest.get().getSession();
    }

    private DhKeyExchange getCurrentDhKeyExchange() {
        return currentDhKeyExchange.get();
    }
}
