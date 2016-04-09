package de.wolff.springcampus.dh.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public abstract class DhKeyExchangeServlet extends HttpServlet {

    public enum Role {
        ALICE, BOB;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderRoleJsp(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        throw new ServletException("Not yet implemented");
    }

    protected void renderRoleJsp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderJsp(getRole().name().toLowerCase(), request, response);
    }

    protected void renderJsp(String jspName, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/" + jspName + ".jsp").forward(request, response);
    }

    protected abstract Role getRole();
}
